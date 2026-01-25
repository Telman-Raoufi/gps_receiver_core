# =============================================================================
# Project:     GPS Receiver Core
# File:        CA_Generator.py
# Description: A bit-accurate algorithmic model of the GPS L1 C/A (Gold Code) generator. 
#              Implements G1 and G2 LFSRs to produce 1023-chip sequences for PRN identification
#              and serves as the primary verification reference for SystemVerilog RTL.
# Author:      Telman Raoufi
# License:     SPDX-License-Identifier: MIT
# =============================================================================

import numpy as np
import matplotlib.pyplot as plt
import os

class CAGenerator:
    """
    Generates GPS C/A (Gold) codes.
    Based on Project 1 of the GPS Course.
    """
    def __init__(self):
        # Taps for G2 shift register to select different PRNs (Satellite IDs)
        # These are the specific "delay" taps defined by the GPS standard
        self.PRN_TAPS = {
            1: (2, 6),   2: (3, 7) ,  3: (4, 8),   4: (5, 9),
            5: (1, 9),   6: (2, 10),  7: (1, 8),   8: (2, 9),
            9: (3,10),  10: (2,  3), 11: (3, 4),  12: (5, 6),
            13:(6, 7),  14: (7,  8), 15: (8, 9),  16: (9,10),
            17:(1, 4),  18: (2,  5), 19: (3, 6),  20: (4, 7),
            21:(5, 8),  22: (6,  9), 23: (1, 3),  24: (4, 6),
            25:(5, 7),  26: (6,  8), 27: (7, 9),  28: (8,10),
            29:(1, 6),  30: (2,  7), 31: (3, 8),  32: (4, 9)            
        }

    def generate_ca_code(self, prn_id):
        """Generates the 1023-chip sequence for a specific PRN."""
        # Initialize 10-bit registers with all ones (GPS Standard)
        # In Python, we can use a simple list to represent bits
        g1 = [1] * 10
        g2 = [1] * 10
        ca_code = []

        for _ in range(1023):
            # 1. Get output bits
            g1_out = g1[9]
            # G2 output is the XOR of two specific taps based on PRN
            t1, t2 = self.PRN_TAPS[prn_id]
            g2_out = g2[t1-1] ^ g2[t2-1]
            
            # 2. Compute XORed Result (the Gold Code chip)
            ca_code.append(g1_out ^ g2_out)

            # 3. Compute Feedback
            # G1 feedback taps: 3 and 10
            g1_fb = g1[2] ^ g1[9]
            # G2 feedback taps: 2, 3, 6, 8, 9, 10
            g2_fb = g2[1] ^ g2[2] ^ g2[5] ^ g2[7] ^ g2[8] ^ g2[9]

            # 4. Shift and insert feedback at the start
            g1 = [g1_fb] + g1[:9]
            g2 = [g2_fb] + g2[:9]

        return np.array(ca_code)      


    def compute_autocorrelation(self, code):
        bipolar_code = np.where(code == 0, 1, -1)
        autocorrelate = np.zeros(1023)
        
        for i in range (1023):
            shifted_code = np.roll(bipolar_code, i)
            autocorrelate[i] = np.dot(shifted_code, bipolar_code)
            
        return autocorrelate
        
    def compute_correlation(self, code1, code2):
        bipolar_code1 = np.where(code1 == 0, 1, -1)
        bipolar_code2 = np.where(code2 == 0, 1, -1)
        correlate = np.zeros(1023)
        
        for i in range (1023):
            shifted_code2 = np.roll(bipolar_code2, i)
            correlate[i] = np.dot(bipolar_code1, shifted_code2)
            
        return correlate
        
        
   
# --- QUICK TEST SCRIPT ---
if __name__ == "__main__":
    gen = CAGenerator()
    code_prn1 = gen.generate_ca_code(1)
    code_prn5 = gen.generate_ca_code(5)
    print(f"Generated {len(code_prn1)} chips for PRN 1.")
    print(f"First 10 chips: {code_prn1[:10]}")
    print(f"Generated {len(code_prn5)} chips for PRN 5.")
    print(f"First 10 chips: {code_prn5[:10]}")
    
    autocorrelate = gen.compute_autocorrelation (code_prn1)
    # Find the maximum value in the results
    peak_value = np.max(autocorrelate)
    # Find the index (shift) where that peak occurs
    peak_index = np.argmax(autocorrelate)
    
    # Find the correlation between two C/A codes
    correlate = gen.compute_correlation (code_prn1, code_prn5)

    print(f"The highest correlation value is: {peak_value}")
    print(f"This peak occurs at shift: {peak_index}")
    
    # The average value should be very close to zero
    print(f"Average correlation (noise floor): {np.mean(autocorrelate)}")
    
    # Create one large figure
    plt.figure(figsize=(10, 8))

    # Top Plot: Autocorrelation
    plt.subplot(2, 1, 1) 
    plt.plot(autocorrelate, color='blue')
    plt.title('Autocorrelation (PRN 1 vs PRN 1)')
    plt.ylabel('Magnitude')
    plt.grid(True)

    # Bottom Plot: Cross-Correlation
    plt.subplot(2, 1, 2)
    plt.plot(correlate, color='red')
    plt.title('Cross-Correlation (PRN 1 vs PRN 5)')
    plt.xlabel('Shift (chips)')
    plt.ylabel('Magnitude')
    plt.grid(True)

    # Adjust layout so titles don't overlap
    plt.tight_layout()
    plt.show()
    
    # --- SAVE ALL 32 PRN SEQUENCES FOR VERILOG REGRESSION ---
    # Create a directory to keep the files organized
    output_dir = "gold_data"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    print(f"\nGenerating 32 golden references in '{output_dir}/'...")
    
    for prn in range(1, 33):
        # Generate the sequence using your existing bit-accurate method
        code = gen.generate_ca_code(prn)
        
        # Create a dynamic filename for each satellite ID
        filename = os.path.join(output_dir, f"gold_chips_prn{prn}.txt")
        
        with open(filename, "w") as f:
            for chip in code:
                # SystemVerilog $readmemb requires one bit per line or space-separated bits
                f.write(f"{chip}\n")
                
    print("Generation complete. 32 files ready for SystemVerilog verification.")   
    
// =============================================================================
// Project:     GPS Receiver Core
// File:        tb_gps_ca_gen.sv
// Description: Automated regression testbench for the GPS L1 C/A generator.
//              Verifies all 32 PRN sequences by comparing RTL output against
//              Python-generated golden references in a nested-loop sequence.
// Author:      Telman Raoufi
// License:     SPDX-License-Identifier: MIT
// =============================================================================

`timescale 1ns / 1ps

module tb_gps_ca_gen();

    // 1. Signals
    logic clk;
    logic rst_n;
    logic [9:0] prn_id;
    logic ca_out;
    
    // Memory and Counters
    bit golden_ref [1023];
    int error_count;
    int total_failed_prns;
    string file_path;

    // 2. Unit Under Test
    gps_ca_gen uut (
        .clk    (clk),
        .rst_n  (rst_n),
        .prn_id (prn_id),
        .ca_out (ca_out)
    );

    // 3. Independent Clock Generation
    // This MUST be in its own block to ensure it never stops
    initial clk = 0;
    always #10 clk = ~clk; 

    // 4. Main Control Logic
    initial begin
        // --- Initialization ---
        total_failed_prns = 0;
        rst_n = 1;
        prn_id = 1;
        
        $display("[%0t ns] --- STARTING 32-PRN REGRESSION ---", $time);

        for (int p = 1; p <= 32; p++) begin
            
            // A. Prepare Data
            prn_id = p;
            file_path = $sformatf("F:/Projects/gps_receiver_core/model/python/gold_data/gold_chips_prn%0d.txt", p);
            $readmemb(file_path, golden_ref);    
                        
            // B. Reset Pulse (Crucial for every PRN)
            rst_n = 0; 
            #100; // Hold reset for 2 clock cycles
            rst_n = 1;
            #5;  // Move away from the clock edge
            
            $display("[%0t ns] Testing PRN %0d...", $time, p);
            
            // C. The Checker Loop
            error_count = 0;
            for (int i = 0; i < 1023; i++) begin
                // For chip 0, we don't wait for a clock (it's the reset state)
                // For chips 1-1022, we wait for the hardware to shift
                if (i > 0) begin
                    @(posedge clk);
                    #2; // Strobe delay
                end
                
                if (ca_out !== golden_ref[i]) begin
                    error_count++;                    
                end
                
            end
            
            // D. Log Result
            if (error_count == 0)
                $display("   PRN %0d: PASSED", p);
            else begin
                $display("   PRN %0d: FAILED (%0d errors)", p, error_count);
                total_failed_prns++;
            end
            
            // Small delay before starting the next satellite
            #100;

            
        end

        // 5. Final Report
        $display("---------------------------------------");
        if (total_failed_prns == 0)
            $display("SUCCESS: All 32 PRNs matched perfectly!");
        else
            $display("FAILURE: %0d PRNs failed.", total_failed_prns);
        $display("---------------------------------------");
        
        $finish;
    end

endmodule
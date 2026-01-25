// =============================================================================
// Project:     GPS Receiver Core
// File:        gps_ca_gen.sv
// Description: RTL implementation of the GPS L1 C/A (Gold Code) generator. 
//              Implements G1 and G2 LFSRs to produce 1023-chip sequences for
//              PRN identification, verified against the Python reference model.
// Author:      Telman Raoufi
// License:     SPDX-License-Identifier: MIT
// =============================================================================



module gps_ca_gen ( input logic clk,
                    input logic rst_n,
                    input logic [9:0] prn_id,
                    output logic ca_out);
                    
    logic [9:0] g1_reg;
    logic [9:0] g2_reg;
    logic new_g1_bit;
    logic new_g2_bit;
    
    assign new_g1_bit = g1_reg[0] ^ g1_reg[7];
    assign new_g2_bit = g2_reg[0] ^ g2_reg[1] ^ g2_reg[2] ^ g2_reg[4] ^ g2_reg[7] ^ g2_reg[8];
    
    always_ff @(posedge clk, negedge rst_n) begin
            if (!rst_n) begin
                g1_reg <= 10'h3FF;
                g2_reg <= 10'h3FF;
                end
            else begin
                g1_reg <= {new_g1_bit , g1_reg[9:1]};
                g2_reg <= {new_g2_bit, g2_reg[9:1]};
                end
            end
    
    always_comb begin
            case (prn_id)
                10'h01 : ca_out = g1_reg[0] ^ g2_reg[8] ^ g2_reg[4];
                10'h02 : ca_out = g1_reg[0] ^ g2_reg[7] ^ g2_reg[3];
                10'h03 : ca_out = g1_reg[0] ^ g2_reg[6] ^ g2_reg[2];
                10'h04 : ca_out = g1_reg[0] ^ g2_reg[5] ^ g2_reg[1];
                10'h05 : ca_out = g1_reg[0] ^ g2_reg[9] ^ g2_reg[1];
                10'h06 : ca_out = g1_reg[0] ^ g2_reg[8] ^ g2_reg[0];
                10'h07 : ca_out = g1_reg[0] ^ g2_reg[9] ^ g2_reg[2];
                10'h08 : ca_out = g1_reg[0] ^ g2_reg[8] ^ g2_reg[1];
                10'h09 : ca_out = g1_reg[0] ^ g2_reg[7] ^ g2_reg[0];
                10'h0a : ca_out = g1_reg[0] ^ g2_reg[8] ^ g2_reg[7];
                10'h0b : ca_out = g1_reg[0] ^ g2_reg[7] ^ g2_reg[6];
                10'h0c : ca_out = g1_reg[0] ^ g2_reg[5] ^ g2_reg[4];
                10'h0d : ca_out = g1_reg[0] ^ g2_reg[4] ^ g2_reg[3];
                10'h0e : ca_out = g1_reg[0] ^ g2_reg[3] ^ g2_reg[2];
                10'h0f : ca_out = g1_reg[0] ^ g2_reg[2] ^ g2_reg[1];
                10'h10 : ca_out = g1_reg[0] ^ g2_reg[1] ^ g2_reg[0];
                10'h11 : ca_out = g1_reg[0] ^ g2_reg[9] ^ g2_reg[6];
                10'h12 : ca_out = g1_reg[0] ^ g2_reg[8] ^ g2_reg[5];
                10'h13 : ca_out = g1_reg[0] ^ g2_reg[7] ^ g2_reg[4];
                10'h14 : ca_out = g1_reg[0] ^ g2_reg[6] ^ g2_reg[3];
                10'h15 : ca_out = g1_reg[0] ^ g2_reg[5] ^ g2_reg[2];
                10'h16 : ca_out = g1_reg[0] ^ g2_reg[4] ^ g2_reg[1];
                10'h17 : ca_out = g1_reg[0] ^ g2_reg[9] ^ g2_reg[7];
                10'h18 : ca_out = g1_reg[0] ^ g2_reg[6] ^ g2_reg[4];
                10'h19 : ca_out = g1_reg[0] ^ g2_reg[5] ^ g2_reg[3];
                10'h1a : ca_out = g1_reg[0] ^ g2_reg[4] ^ g2_reg[2];
                10'h1b : ca_out = g1_reg[0] ^ g2_reg[3] ^ g2_reg[1];
                10'h1c : ca_out = g1_reg[0] ^ g2_reg[2] ^ g2_reg[0];
                10'h1d : ca_out = g1_reg[0] ^ g2_reg[9] ^ g2_reg[4];
                10'h1e : ca_out = g1_reg[0] ^ g2_reg[8] ^ g2_reg[3];
                10'h1f : ca_out = g1_reg[0] ^ g2_reg[7] ^ g2_reg[2];
                10'h20 : ca_out = g1_reg[0] ^ g2_reg[6] ^ g2_reg[1];
                default: ca_out = 1'b0;
            endcase
        end          
                  
                  
endmodule
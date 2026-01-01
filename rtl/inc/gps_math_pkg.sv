// =============================================================================
// Project:     GPS Receiver Core
// File:        gps_math_pkg.sv
// Description: Global mathematical constants and fixed-point types.
// =============================================================================

package gps_math_pkg;

    // Fixed-point scaling: 16 bits total, 8 bits for fractional part (Q8.8)
    localparam int FXP_WIDTH = 16;
    localparam int FXP_FRACT = 8;

    // Custom type for signed fixed-point numbers
    typedef logic signed [FXP_WIDTH-1:0] fxp_t;

    // Pi scaled for Q8.8 (3.14159 * 2^8 ≈ 804 or 16'h0324)
    localparam fxp_t PI_FXP = 16'h0324; 

endpackage : gps_math_pkg
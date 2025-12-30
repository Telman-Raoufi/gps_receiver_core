package gps_math_pkg;
    // Fixed-point definition: 16 bits total
    // Using 8 bits for integer and 8 bits for fraction
    localparam int FXP_WIDTH = 16;
    
    // Custom type for readability
    typedef logic signed [FXP_WIDTH-1:0] fxp_t;
    
    // Pi scaled for 8-bit fractional: 3.14159 * 256 ≈ 804 (0x0324)
    localparam fxp_t PI_FXP = 16'h0324; 
endpackage
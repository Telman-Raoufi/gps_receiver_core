// =============================================================================
// Project:     GPS Receiver Core
// File:        gps_core_pkg.sv
// Description: State machine and data structures for the GPS engine.
// =============================================================================

package gps_core_pkg;

    // Acquisition Engine States
    typedef enum logic [2:0] {
        ACQ_IDLE    = 3'b000, // Waiting for start signal
        ACQ_SEARCH  = 3'b001, // Correlating incoming signal
        ACQ_CONFIRM = 3'b010, // Verifying the correlation peak
        ACQ_LOCKED  = 3'b011, // Signal successfully acquired
        ACQ_TIMEOUT = 3'b100  // Signal search failed
    } acq_state_e;

    // Structure for tracking results
    typedef struct packed {
        logic [5:0]  sv_id;      // Space Vehicle ID (Satellite Number)
        logic [15:0] doppler_hz; // Frequency offset
        logic [9:0]  code_phase; // C/A code alignment
    } sat_status_s;

endpackage : gps_core_pkg
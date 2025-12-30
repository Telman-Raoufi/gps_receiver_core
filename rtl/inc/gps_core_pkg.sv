package gps_core_pkg;
    // The main Acquisition State Machine types
    typedef enum logic [2:0] {
        ACQ_IDLE    = 3'b000, // Waiting for command
        ACQ_SEARCH  = 3'b001, // Searching for satellite signal
        ACQ_CONFIRM = 3'b010, // Verifying the signal peak
        ACQ_LOCKED  = 3'b011, // Signal acquired successfully
        ACQ_TIMEOUT = 3'b100  // Failed to find signal
    } acq_state_e;
endpackage
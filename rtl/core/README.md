# GPS Receiver Core - RTL Modules

**Author:** Telman Raoufi  
**License:** SPDX-License-Identifier: MIT

---

## Overview
This directory contains the synthesizable SystemVerilog implementations of the GPS Receiver Core. The architecture is designed to be modular, allowing for independent verification of each signal processing block before integration into the top-level receiver.

## Current Modules

### 1. C/A Code Generator (`gps_ca_gen.sv`)
The fundamental building block used for satellite identification and signal spreading.
- **Function:** Implements the G1 and G2 Linear Feedback Shift Registers (LFSRs) as defined in the IS-GPS-200 specification.
- **Key Features:** - Supports all 32 primary PRN sequences.
    - Bit-accurate state transitions.
    - Asynchronous reset to the standard-defined "all-ones" state.
- **Status:** Verified via 32-PRN Automated Regression.

## Upcoming Modules (Roadmap)
- **Correlation Engine:** Multi-channel correlators for signal despreading.
- **Carrier NCO:** Numerically Controlled Oscillator for Doppler compensation.
- **Integrate-and-Dump:** Accumulators for correlation peak detection.

---

## Global Hardware Parameters
- **Primary Clock:** 50 MHz (Input), internal logic scales to 1.023 MHz chip rate.
- **Reset Logic:** Asynchronous, Active-Low (`rst_n`).
- **Standard Compliance:** IS-GPS-200.
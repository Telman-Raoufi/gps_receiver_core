# GPS Receiver Design Verification (DV)

**Author:** Telman Raoufi  
**License:** SPDX-License-Identifier: MIT

---

## Overview
This directory contains the verification environment for the GPS Receiver Core. The primary goal is to ensure that the RTL implementation matches the mathematical "Golden Model" with 100% bit-accuracy across all operating conditions.

## Verification Strategy: Automated Regression
The testbench (`tb_gps_ca_gen.sv`) uses an automated regression approach to validate the C/A Code Generator. This method is more robust than manual inspection as it covers the entire satellite constellation in a single execution.

### Key Components
1. **Dynamic Data Loading**: The testbench uses `$readmemb` and `$sformatf` to dynamically load 32 unique golden reference files from the Python model.
2. **Synchronized Reset Testing**: The environment pulses the asynchronous reset (`rst_n`) before every PRN test to verify that the G1 and G2 registers initialize correctly to the "All-Ones" state.
3. **Strobe Timing**: To avoid simulation race conditions, the testbench utilizes a "strobe" delay (#1ns) to sample the RTL output after the clock edge transition.

## Running the Simulation
1. Ensure the Python reference files have been generated in `/model/python/gold_data/`.
2. In Vivado, set `tb_gps_ca_gen.sv` as the top-level simulation module.
3. Set the simulation runtime to `run -all` (Total simulation time is ~660 µs).
4. Monitor the Tcl Console for the final regression report: `SUCCESS: All 32 PRNs matched perfectly!`.

## Testbench Files
* `tb_gps_ca_gen.sv`: The main SystemVerilog testbench.
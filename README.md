# GPS Receiver Core

**Author:** Telman Raoufi  
**License:** SPDX-License-Identifier: MIT  
**Status:** Project 1 (C/A Generation) Complete | Project 2 (Correlation) In Development

---

## Project Overview
The GPS Receiver Core is a high-performance, modular SystemVerilog implementation of a GPS L1-band receiver. The goal of this project is to implement the full signal processing chain—from C/A code generation and carrier tracking to correlation and navigation message decoding.

## Repository Structure
* **`/rtl`**: Synthesizable SystemVerilog source files.
* **`/model`**: Python-based algorithmic models and "Golden" reference data.
* **`/dv`**: Design Verification environment, including testbenches and regression scripts.
* **`/docs`**: Specification documents and architecture diagrams.

## Current Progress
- [x] **Project 1: C/A Code Generator** - Full 32-PRN support.
    - Verified with bit-accurate Python model.
    - Automated regression testbench passing.
- [ ] **Project 2: Correlation Engine** (Current Focus)
- [ ] **Project 3: Acquisition & Tracking Loops**

## Getting Started
To verify the current design:
1. Run the Python model in `/model/python` to generate golden data.
2. Load the Vivado project and run the simulation in `/dv/tests`.
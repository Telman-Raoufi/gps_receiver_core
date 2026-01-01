# Project Plan: GPS Receiver Core (L1 C/A)

## 1. Project Goal
To design and verify a professional, synthesizable SystemVerilog GPS Baseband Receiver. 
This core will utilize a bit-accurate Python Golden Model for verification and will process real-world satellite data.

## 2. Modular Architecture
The project is divided into three distinct domains:
- **Algorithmic Model (`model/python/`)**: Python-based reference using NumPy. Includes fixed-point utilities to match hardware precision exactly.
- **RTL Implementation (`rtl/core/`)**: Synthesizable SystemVerilog modules including C/A code generators, correlators, and state machines.
- **Design Verification (`dv/`)**: A self-checking testbench environment that compares RTL outputs against Python-generated test vectors.

## 3. Implementation Roadmap (Aligned with Course Milestones)
1. **Gold Code Foundation**: Implement a multi-satellite C/A code generator (G1/G2 LFSRs).
2. **Signal Emulation**: Create a Python-based emulator to generate noisy signals with Doppler shifts and high-rate resampling (50MHz to 5MHz).
3. **Time-Domain Acquisition**: Build a serial search correlator and FSM to identify visible satellites.
4. **Frequency-Domain Acquisition**: (Optional Upgrade) Implement FFT-based acquisition for high-speed search.
5. **Integration & Non-Coherent Processing**: Combine steps into a unified acquisition engine.
6. **Fine Frequency Estimation**: Use extended FFTs and carrier phase-based acquisition for precision.
7. **Tracking Loops**: Implement Costas Loops (Carrier) and DLLs (Code) using specialized discriminators.
8. **Navigation Decoding**: Extract subframe data and calculate final Position, Velocity, and Time (PVT).

## 4. Engineering Standards
- **Bit-Accuracy**: All Python models must produce identical results to RTL for matching fixed-point inputs.
- **Portability**: Code must be synthesizable and vendor-independent (FPGA/ASIC ready).
- **Automation**: Use scripts to generate test vectors and run regression simulations.
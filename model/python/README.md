# GPS Receiver Algorithmic Model (Python)

**Author:** Telman Raoufi  
**License:** SPDX-License-Identifier: MIT

---

## Overview
This directory contains the Python-based reference models for the GPS Receiver Core. These scripts serve as the mathematical "Ground Truth" used to verify the bit-accuracy of the SystemVerilog RTL implementation. By using a high-level language like Python, the Gold Code mathematics are validated before committing to hardware design.

## Primary Modules

### 1. C/A Code Generator (`CA_Generator.py`)
A class-based implementation of the Gold Code generation algorithm as defined in the IS-GPS-200 specification. It replicates the G1 and G2 LFSR logic to produce the 1023-chip sequences for the GPS satellite constellation.

**Key Capabilities:**
* **Sequence Generation:** Generates bit-accurate arrays for any PRN ID (1-32).
* **Verification Export:** Automatically generates the `gold_data/` directory containing 32 text files used for RTL regression testing.
* **DSP Analysis:** Includes built-in methods to calculate autocorrelation and cross-correlation to verify signal orthogonality.



## Environment Setup
The model requires Python 3.x and the following libraries for analysis and visualization:
* `numpy`: Efficient array manipulations and correlation mathematics.
* `matplotlib`: Visualizing correlation results and chip sequences.

To install dependencies:
```bash
pip install numpy matplotlib
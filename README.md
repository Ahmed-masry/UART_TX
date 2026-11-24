# UART transmitter RTL

An educational UART transmitter implemented as separate control, serialization, parity and output-selection modules.

## Design overview

The transmitter accepts parallel data with a data-valid input and produces a serial output with a busy indicator. The top-level exposes parity enable and parity type controls and defaults to an 8-bit data width.

## Repository map

| File | Purpose |
| --- | --- |
| `UART_TX.v` | Top-level module connecting the transmitter blocks |
| `FSM_UART_TX.v` | Transmit control state machine |
| `Serializer_UART_TX.v` | Parallel-to-serial data path |
| `Parity_UART_TX.v` | Parity generation |
| `MUX_UART_TX.v` | Serial output selection |
| `UART_TX_tb.v` | Testbench with parity-enabled, parity-disabled and additional stimulus cases |
| `sourcefile.txt`, `run.do` | Existing simulator file list and command script |

## Verification status

The testbench includes expected-frame comparisons and prints a success or failure message for the checked cases. The repository also includes an existing Questa/ModelSim-style `run.do` script.

This documentation does not certify a passing simulation, timing result or hardware implementation. No fresh simulation results or coverage measurements are supplied here.

<div align="center">
<h1>dApps: Enabling Real-Time AI-Based Open RAN Control</h1>

[![ArXiv Link](https://img.shields.io/badge/arXiv-2501.16502-red?logo=arxiv)](https://arxiv.org/abs/2501.16502)
[![Computer Networks](https://img.shields.io/badge/Computer%20Networks-10.1016%2Fj.comnet.2025.111342-orange?logo=elsevier)](https://doi.org/10.1016/j.comnet.2025.111342)

</div>

In this repository we configure an OpenAirInterface 5G gNB and a dApp for real-time RAN control.

There are four modules composing this frameworks:

- Python library for creating and deploying dApps
- LibE3: A Vendor neutral library in C++ with C wrappers for the E3AP on the RAN side
- A custom version of OAI with LibE3 and the E3SM-Spectrum for IQ sensing and PRB nulling
- A custom version of FlexRIC to enable xApp-dApp synchronization through E2SM-DAPP 

For a more detailed description of what are the dApps, please refer to [our architectural paper](https://doi.org/10.1016/j.comnet.2025.111342) ([here for the archive version](https://arxiv.org/pdf/2501.16502)) and its [presentation page](https://openrangym.com/o-ran-frameworks/dapps).

If you use the dApp concept and/or the framework to develop your own dApps, please cite the following paper:

```text
@article{LACAVA2025111342,
title = {{dApps: Enabling Real-Time AI-based Open RAN Control}},
journal = {Computer Networks},
pages = {111342},
year = {2025},
issn = {1389-1286},
doi = {https://doi.org/10.1016/j.comnet.2025.111342},
url = {https://www.sciencedirect.com/science/article/pii/S1389128625003093},
author = {Andrea Lacava and Leonardo Bonati and Niloofar Mohamadi and Rajeev Gangula and Florian Kaltenberger and Pedram Johari and Salvatore D’Oro and Francesca Cuomo and Michele Polese and Tommaso Melodia},
keywords = {Open RAN, dApps, Real-time control loops, Radio Resource Management (RRM), Spectrum sharing, Positioning, Integrated Sensing and Communication (ISAC)}
}
```

## Usage

A complete tutorial on dApps can be found [on the OpenRAN Gym website](https://openrangym.com/tutorials/dapps-oai).

Configuration and setup guides live in [`docs/`](docs/):

- [Documentation index & tutorial](docs/README.md) — including the over-the-air (OTA) OAI configuration notes.
- [System configuration for IPC](docs/ipc-setup.md) — Unix Domain Socket (UDS) group and folder setup.
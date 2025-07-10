# dApps: Enabling Real-Time AI-Based Open RAN Control

In this repository we configure an OpenAirInterface 5G gNB and a dApp for real-time RAN control.

There are two main modules composing this frameworks:

- A custom library in Python for dApps
- A custom version of OAI (soon to be updated and hopefully merged with the original branch)

For a more detailed description of what are the dApps, please refer to [our architectural paper](https://doi.org/10.1016/j.comnet.2025.111342) ([here for the archive version](https://arxiv.org/pdf/2501.16502)) and its [presentation page](https://openrangym.com/o-ran-frameworks/dapps).

## Usage

A complete tutorial on dApps can be found [on the OpenRAN Gym website](https://openrangym.com/tutorials/dapps-oai).

In this page we discuss the configuration parameters that can be use to perform experiments over the air (OTA).

### Configuration for OAI

For every configuration of the E3 interface, ensure that the `do_SRS` flag is set to `0`.

If you are using a USRP radio, it is recommended to set 3/4 sampling by using the `-E` flag in both the OAI and dApp software. This flag should not be used for standard Radio Units (RUs).

### System configuration for IPC

This part of the guide is inteded to be only if running with Unix Domain Sockets (UDSs).
If we need the dApp to run in a different user than OAI (e.g., $USER vs root) we need to create a specific unix users group called `dapp` and we assign root and user to this group to enable shared UDS through a dedicated folder:

```bash
sudo groupadd dapp
sudo usermod -aG dapp root
sudo usermod -aG dapp $USER

# check the groups
groups root $USER
```

Folder creation (path is not important, but it should be the same in OAI and the dApp)

```bash
mkdir -p /tmp/dapps
sudo chown :dapp /tmp/dapps
sudo chmod g+ws /tmp/dapps
```

If the dApp is not run from the root user, a new folder should be included called `logs`

```bash
# In the root of your project
mkdir logs
```

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
keywords = {Open RAN, dApps, Real-time control loops, Radio Resource Management (RRM), Spectrum sharing, Positioning, Integrated Sensing and Communication (ISAC)},
abstract = {Open Radio Access Networks (RANs) leverage disaggregated and programmable RAN functions and open interfaces to enable closed-loop, data-driven radio resource management. This is performed through custom intelligent applications on the RAN Intelligent Controllers (RICs), optimizing RAN policy scheduling, network slicing, user session management, and medium access control, among others. In this context, we have proposed dApps as a key extension of the O-RAN architecture into the real-time and user-plane domains. Deployed directly on RAN nodes, dApps access data otherwise unavailable to RICs due to privacy or timing constraints, enabling the execution of control actions within shorter time intervals. In this paper, we propose for the first time a reference architecture for dApps, defining their life cycle from deployment by the Service Management and Orchestration (SMO) to real-time control loop interactions with the RAN nodes where they are hosted. We introduce a new dApp interface, E3, along with an Application Protocol (AP) that supports structured message exchanges and extensible communication for various service models. By bridging E3 with the existing O-RAN E2 interface, we enable dApps, xApps, and rApps to coexist and coordinate. These applications can then collaborate on complex use cases and employ hierarchical control to resolve shared resource conflicts. Finally, we present and open-source a dApp framework based on OpenAirInterface (OAI). We benchmark its performance in two real-time control use cases, i.e., spectrum sharing and positioning in a 5th generation (5G) Next Generation Node Base (gNB) scenario. Our experimental results show that standardized real-time control loops via dApps are feasible, achieving average control latency below 450microseconds and allowing optimal use of shared spectral resources.}
}
```

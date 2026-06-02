# dApp Framework — Documentation

A complete tutorial on dApps can be found [on the OpenRAN Gym website](https://openrangym.com/tutorials/dapps-oai).

This page discusses the configuration parameters that can be used to perform experiments over the air (OTA).

## Guides

- [System configuration for IPC](ipc-setup.md) — Unix Domain Socket (UDS) group and folder setup.

## Configuration for OAI

For every configuration of the E3 interface, ensure that the `do_SRS` flag is set to `0`.

If you are using a USRP radio, it is recommended to set 3/4 sampling by using the `-E` flag in both the OAI and dApp software. This flag should not be used for standard Radio Units (RUs).

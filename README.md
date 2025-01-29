# dApps: Enabling Real-Time AI-Based Open RAN Control

In this repository we configure an OpenAirInterface 5G gNB and a dApp for real-time RAN control. 

There are two main modules composing this frameworks:

- A custom library in Python for dApps
- A custom version of OAI (soon to be updated and hopefully merged with the original branch)

For a more indepth description of what are the dApps, please refer to [this page](https://openrangym.com/ran-frameworks/dapps).

## Usage

A full tutorial about the dApps can be found [here](https://openrangym.com/tutorials/dapps-oai).

In this page we discuss the configuration parameters that can be use to perform experiments over the air (OTA)

### Configuration for OAI

For every configuration of the E3 interface, make sure that do_SRS flag is set to 0.

### System configuration for OTA

This part of the guide is inteded to be only if running with `--ota` **and** with UDS sockets
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
@ARTICLE{TDB
 }
```

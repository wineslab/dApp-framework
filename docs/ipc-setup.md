# System configuration for IPC

This part of the guide is intended to be used only if running with Unix Domain Sockets (UDSs).

If we need the dApp to run in a different user than OAI (e.g., `$USER` vs `root`) we need to create a specific unix users group called `dapp` and we assign root and user to this group to enable shared UDS through a dedicated folder:

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

# k8s-preflight-setup

Starter pack for k8s installation

## Usage

Just run the setup script as blew

```bash
./setup.bash
```

## Changing Versions

In every component bash file you can find the appropriate version variable. Changing the version will install the specific package.

```bash
CONTAINERD_VERSION=1.7.22 # inside the containerd.bash
```

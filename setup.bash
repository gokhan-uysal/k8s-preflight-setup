#!/bin/bash

source "utils.bash"
source "prerequisites.bash"
source "containerd.bash"
source "crictl.bash"
source "runc.bash"
source "cniplug.bash"

ARCH=$(get_arch)

rm -rf "cni-plugins-"*
rm -rf "containerd-"*
rm -rf "runc.${ARCH}"*
rm -rf "crictl-"*

sudo apt-get update &&
    sudo apt-get install conntrack ethtool socat -y

log_info "###########################"
log_info ""
log_info "Ready to install K8S :)"

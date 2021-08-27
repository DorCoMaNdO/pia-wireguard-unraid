#!/bin/bash

# Script run location
RUN_PATH="/mnt/user/appdata/PIA-WireGuard/"

# PIA account details
PIA_USER="pXXXXXXX"
PIA_PASS="YourPIAPassword"

# VPN configuration
PIA_DNS=true        # true/false, use PIA DNS, resolvconf is missing so this is always false, input is provided in case that changes.
MAX_LATENCY=0.05    # latency ceiling for AUTOCONNECT in seconds, default 0.05 (50ms)
AUTOCONNECT=true    # true/false, tests servers and selects the one with the lowest latency (at the time of script execution), overrides PREFERRED_REGION
PREFERRED_REGION=   # region ID for PIA servers, to validate your input run the "get_region.sh" script separately.
DISABLE_IPV6=true   # true/false, disable IPv6
CONNECT_VPN=false   # true/false, automatically start the VPN tunnel after it is created, see TUNNEL_INDEX before changing this.
TUNNEL_INDEX=0      # index for the tunnel to be created, if left blank, auto-increments (creates new tunnel on every run), if provided, when a the index
                    # already exists, it will be overridden, if it was previously running, it will be restarted (CONNECT_VPN will be changed to true).

PIA_PF=false        # NOT RECOMMENDED, true/false, requests a port-forwarding compatible server and run a keep-alive script.
                    # this script will need to run in the background or in some other way when this is enabled, the port
                    # recieved is provided in the script output so it needs to be readable.


###### USERSCRIPT ######

# Create run directory
if [ ! -d "$RUN_PATH" ] ; then
  mkdir -vp "$RUN_PATH"
fi

# Clone scripts from github
cd $RUN_PATH
if [ -d "$RUN_PATH/pia-scripts" ] ; then
  echo "Removing old scripts..."
  rm -rd pia-scripts
fi
git clone https://github.com/DorCoMaNdO/pia-wireguard-unraid.git pia-scripts

cd pia-scripts

# Make scripts executable
find ./ -name "*.sh" | xargs chmod 744

# Run setup script with our parameters
sudo PIA_USER=$PIA_USER \
     PIA_PASS=$PIA_PASS \
     PIA_DNS=$PIA_DNS \
     MAX_LATENCY=$MAX_LATENCY \
     AUTOCONNECT=$AUTOCONNECT \
     PREFERRED_REGION=$PREFERRED_REGION \
     DISABLE_IPV6=$DISABLE_IPV6 \
     CONNECT_VPN=$CONNECT_VPN \
     TUNNEL_INDEX=$TUNNEL_INDEX \
     PIA_PF=$PIA_PF ./run_setup.sh
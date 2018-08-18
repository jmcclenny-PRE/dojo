#! /bin/bash
VPN_AUTH_GROUP=###CHANGEME###
VPN_AUTH_CONNECT=###CHANGEME###

##### Create VPN connect script #####
cd ~/
echo "sudo openconnect --authgroup $VPN_AUTH_GROUP --script=~/vpnc-script-split-traffic.sh   $VPN_AUTH_CONNECT  --servercert sha256:cca84f3585f647d4507276d3b714fb3868ed1bd27e33b6535652fd915818d34c" > connect-ceif.sh
chmod +x connect-ceif.sh

##### Create VPN tunnel script #####
echo '# Add one IP to the list of split tunnel
add_ip ()
{
    export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_ADDR=$1
    export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASK=$2
    export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASKLEN=$3
    export CISCO_SPLIT_INC=$(($CISCO_SPLIT_INC + 1))
}

# Initialize empty split tunnel list
export CISCO_SPLIT_INC=0

# Delete DNS info provided by VPN server to use internet DNS
# Comment following line to use DNS beyond VPN tunnel
#unset INTERNAL_IP4_DNS

# List of IPs beyond VPN tunnel
add_ip 10.5.15.0	 255.255.255.0 24   #MGMT1
add_ip 10.5.16.0 255.255.255.0 24       #MGMT2
add_ip 192.168.0.0 255.255.0.0 16		#Platform

# Execute default script
. /usr/local/etc/vpnc-script

# End of script' > vpnc-script-split-traffic.sh
chmod +x vpnc-script-split-traffic.sh
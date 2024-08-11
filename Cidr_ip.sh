#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <CIDR>"
    exit 1
fi

CIDR=$1

# Get network address and netmask
NETWORK=$(ipcalc -n $CIDR | grep Network | awk '{print $2}')
NETMASK=$(ipcalc -m $CIDR | grep Netmask | awk '{print $2}')

# Convert CIDR to IP address range
IFS=. read -r i1 i2 i3 i4 <<< "$NETWORK"
IFS=. read -r m1 m2 m3 m4 <<< "$NETMASK"

# Calculate the total number of IP addresses
count=$(( ( (256 - m4) * 256 + (256 - m3) ) * 256 + (256 - m2) * 256 + (256 - m1) ))

# Calculate the start and end IP addresses
start_ip=$(( (i1 * 256 + i2) * 256 + i3 * 256 + i4 + 1 ))
end_ip=$(( start_ip + count - 3 ))

# Function to convert integer to IP address
int_to_ip() {
    local ip="$1"
    echo "$((ip >> 24 & 255)).$((ip >> 16 & 255)).$((ip >> 8 & 255)).$((ip & 255))"
}

# List IP addresses
for (( ip=start_ip; ip<=end_ip; ip++ )); do
    int_to_ip $ip
done

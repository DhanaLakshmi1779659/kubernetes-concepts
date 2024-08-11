
#!/bin/bash

# Check if a CIDR is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <CIDR>"
    exit 1
fi

CIDR=$1

# Extract the IP and prefix length from the CIDR
IP=$(echo $CIDR | cut -d'/' -f1)
PREFIX=$(echo $CIDR | cut -d'/' -f2)

# Convert the IP to its integer representation
IFS=. read -r i1 i2 i3 i4 <<< "$IP"
IP_DEC=$(( (i1 << 24) + (i2 << 16) + (i3 << 8) + i4 ))

# Calculate the number of IPs in the range
NUM_IPS=$(( 2 ** (32 - PREFIX) ))

# Generate the IP addresses
for ((i=0; i<NUM_IPS; i++)); do
    IP_DEC_CURRENT=$(( IP_DEC + i ))
    IP_CURRENT=$(printf "%d.%d.%d.%d\n" $(( (IP_DEC_CURRENT >> 24) & 255 )) $(( (IP_DEC_CURRENT >> 16) & 255 )) $(( (IP_DEC_CURRENT >> 8) & 255 )) $(( IP_DEC_CURRENT & 255 )))
    echo $IP_CURRENT
done

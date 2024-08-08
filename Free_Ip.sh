#!/bin/bash

# Define the subnet range
subnet="10.151.100"
start=0
end=1023

# Initialize the free IPs array
free_ips=()

# Loop through the IP range
for i in $(seq $start $end); do
  ip=$(( $(echo $subnet | tr '.' ' ') + (i / 256) ))"."$(( (i / 256) % 256 ))"."$((i % 256))
  ping -c 1 -W 1 $ip > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    free_ips+=($ip)
  fi
done

# Print the free IPs
echo "Free IPs in the range $subnet.0/22:"
for ip in "${free_ips[@]}"; do
  echo $ip
done

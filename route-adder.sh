#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <subnet_file> <tunnel_interface>"
    exit 1
fi

subnet_file=$1
tunnel_interface=$2

# Check if the subnet file exists
if [ ! -f "$subnet_file" ]; then
    echo "Error: Subnet file '$subnet_file' not found."
    exit 1
fi

# Check if the tunnel interface exists
if ! ip link show "$tunnel_interface" &> /dev/null; then
    echo "Error: Tunnel interface '$tunnel_interface' not found."
    exit 1
fi

# Read subnets from the file and add routes for each subnet
while IFS= read -r subnet || [[ -n "$subnet" ]]; do
    sudo ip route add "$subnet" dev "$tunnel_interface"
done < "$subnet_file"

echo "Routes added successfully."

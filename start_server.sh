#!/bin/bash
# Ensure the simulated memory device file exists
#fallocate -l 516KiB /tmp/marcos_server_mem

# Start the server
cd /opt/marcos_server/build
./marcos_server &

# Keep the container running
tail -f /dev/null


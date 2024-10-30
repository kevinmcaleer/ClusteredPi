#!/bin/bash

# Function to add a line to a file if it does not already exist
add_line_if_not_exists() {
  local line="$1"
  local file="$2"
  grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

# Configure limits.conf with idempotent checks
echo "Configuring /etc/security/limits.conf..."
add_line_if_not_exists "crate soft nofile unlimited" /etc/security/limits.conf
add_line_if_not_exists "crate hard nofile unlimited" /etc/security/limits.conf
add_line_if_not_exists "crate soft memlock unlimited" /etc/security/limits.conf
add_line_if_not_exists "crate hard memlock unlimited" /etc/security/limits.conf
add_line_if_not_exists "crate soft nproc 4096" /etc/security/limits.conf
add_line_if_not_exists "crate hard nproc 4096" /etc/security/limits.conf
add_line_if_not_exists "crate soft as unlimited" /etc/security/limits.conf
add_line_if_not_exists "crate hard as unlimited" /etc/security/limits.conf

# Configure sysctl.conf with idempotent check
echo "Configuring /etc/sysctl.conf..."
add_line_if_not_exists "vm.max_map_count = 262144" /etc/sysctl.conf

# Apply sysctl changes
echo "Applying sysctl configuration..."
sysctl -p

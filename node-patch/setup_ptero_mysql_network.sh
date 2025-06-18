#!/bin/bash

# === Configuration Values ===
MYSQL_PORT="3306"
DOCKER_NETWORK_NAME="pterodactyl_nw"

# === Get internal IP (gateway) of the custom Docker network ===
BRIDGE_IP=$(docker network inspect "$DOCKER_NETWORK_NAME" -f '{{range .IPAM.Config}}{{.Gateway}}{{end}}')

if [[ -z "$BRIDGE_IP" ]]; then
  echo "❌ Could not determine the gateway IP for Docker network '$DOCKER_NETWORK_NAME'."
  echo "Make sure the network exists and Docker is running."
  exit 1
fi

DOCKER_SUBNET="${BRIDGE_IP%.*}.0/24"

echo "============== Starting Pterodactyl MySQL Network Setup =============="

# 1. Set firewall rules
echo "[1/2] Setting firewall rules..."
sudo ufw allow from $DOCKER_SUBNET to any port $MYSQL_PORT comment 'Allow access from Pterodactyl container network'

# 2. Set iptables NAT rules
echo "[2/2] Applying iptables NAT rules for Docker containers..."
iptables -t nat -C PREROUTING -s $DOCKER_SUBNET -p tcp --dport $MYSQL_PORT -j DNAT --to-destination $BRIDGE_IP:$MYSQL_PORT 2>/dev/null || iptables -t nat -A PREROUTING -s $DOCKER_SUBNET -p tcp --dport $MYSQL_PORT -j DNAT --to-destination $BRIDGE_IP:$MYSQL_PORT

iptables -t nat -C POSTROUTING -d $BRIDGE_IP/32 -p tcp --dport $MYSQL_PORT -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -d $BRIDGE_IP/32 -p tcp --dport $MYSQL_PORT -j MASQUERADE

# Save rules
if command -v netfilter-persistent &>/dev/null; then
    sudo netfilter-persistent save
else
    sudo apt update
    sudo apt install -y iptables-persistent
    sudo netfilter-persistent save
fi

echo ""
echo "✅ Network setup complete!"
echo "----------------------------------------"
echo "📌 Internal database address to use in the Panel:"
echo "   ➤ Internal Address: $BRIDGE_IP"
echo ""
echo "============== Done =============="

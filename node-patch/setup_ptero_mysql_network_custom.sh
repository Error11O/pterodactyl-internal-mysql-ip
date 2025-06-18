#!/bin/bash

# === Konfigurationswerte ===
MYSQL_PORT="3306"
DOCKER_NETWORK_NAME="pterodactyl_nw"

# === Interne IP (Gateway) des benutzerdefinierten Docker-Netzwerks ermitteln ===
BRIDGE_IP=$(docker network inspect "$DOCKER_NETWORK_NAME" -f '{{range .IPAM.Config}}{{.Gateway}}{{end}}')

if [[ -z "$BRIDGE_IP" ]]; then
  echo "❌ Gateway-IP für Docker-Netzwerk '$DOCKER_NETWORK_NAME' konnte nicht ermittelt werden."
  echo "Stelle sicher, dass das Netzwerk existiert und Docker läuft."
  exit 1
fi

DOCKER_SUBNET="${BRIDGE_IP%.*}.0/24"

echo "============== Pterodactyl MySQL Netzwerk-Setup starten =============="

# 1. Firewall-Regeln setzen
echo "[1/2] Firewall-Regeln setzen..."
sudo ufw allow from $DOCKER_SUBNET to any port $MYSQL_PORT comment 'Zugriff für Pterodactyl-Container-Netzwerk'

# 2. iptables NAT-Regeln setzen
echo "[2/2] iptables NAT-Regeln für Docker-Container..."
iptables -t nat -C PREROUTING -s $DOCKER_SUBNET -p tcp --dport $MYSQL_PORT -j DNAT --to-destination $BRIDGE_IP:$MYSQL_PORT 2>/dev/null || iptables -t nat -A PREROUTING -s $DOCKER_SUBNET -p tcp --dport $MYSQL_PORT -j DNAT --to-destination $BRIDGE_IP:$MYSQL_PORT

iptables -t nat -C POSTROUTING -d $BRIDGE_IP/32 -p tcp --dport $MYSQL_PORT -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -d $BRIDGE_IP/32 -p tcp --dport $MYSQL_PORT -j MASQUERADE

# Regeln speichern
if command -v netfilter-persistent &>/dev/null; then
    sudo netfilter-persistent save
else
    sudo apt update
    sudo apt install -y iptables-persistent
    sudo netfilter-persistent save
fi

echo ""
echo "✅ Netzwerk-Setup abgeschlossen!"
echo "----------------------------------------"
echo "📌 Interne Adresse für Datenbank im Panel:"
echo "   ➤ Interne Adresse: $BRIDGE_IP"
echo ""
echo "============== Fertig =============="

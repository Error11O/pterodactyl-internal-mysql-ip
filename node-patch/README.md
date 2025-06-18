# Node Patch: Internal MySQL Network Setup for Pterodactyl Wings

This script configures the firewall and networking on a Pterodactyl **node** (Wings server) so that game server containers can communicate with the MySQL server running on the host using an internal Docker IP address.

## What it does

- Detects the internal gateway IP of the Docker network used by Pterodactyl (e.g. `pterodactyl_nw`)
- Applies `iptables` NAT rules to allow Docker containers to access MySQL via the gateway
- Adds a UFW rule to allow traffic from the Docker subnet to port `3306`
- Saves these rules using `netfilter-persistent`

## Usage

1. Clone this repository on your node:

```bash
git clone https://github.com/nycon/pterodactyl-internal-mysql-ip.git
cd pterodactyl-internal-mysql-ip/node-patch
```

2. Make the script executable and run it:

```bash
chmod +x setup_ptero_mysql_network_custom.sh
sudo ./setup_ptero_mysql_network_custom.sh
```

> 🛡 Requires root privileges — use `sudo`.

## Notes

- This only needs to be run **once per node**, or if the Docker network changes.
- Ensure `pterodactyl_nw` is the correct Docker network name. Modify the script if your setup uses a different name.

## Result

Once configured, your game servers will be able to connect to MySQL using the **internal address** (e.g. `172.18.0.1:3306`) instead of the external IP.

This makes the connection faster, more secure, and isolated within the Docker network.
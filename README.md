
# 🧩 Pterodactyl Internal MySQL IP Support

This project enables Pterodactyl game server containers to connect to a MySQL server on the **host system** via a **Docker internal IP**, such as `172.18.0.1`.

It contains automation and patches for both the **node (Wings)** and **panel** sides of Pterodactyl.

---

## 📁 Repository Structure

| Folder         | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| `panel-patch/`       | Contains scripts and patches for the Pterodactyl **web panel**             |
| `node-patch/`  | Contains the **network patch** and Docker config setup for Wings/containers |

---

## 🚀 Goal

Normally, when a database is created in the panel, the **external host IP** is used as the MySQL endpoint. However, game containers run in a Docker network and need to reach the MySQL server using the **internal Docker bridge IP** of the host machine.

This project ensures that:

- Databases are created with the correct internal IP (`172.18.0.1`)
- Game containers can resolve and connect to the MySQL host reliably
- The internal IP is shown in the panel interface (endpoint field)

---

## 🛠️ How to Use

1. 🔧 Go to the `panel-ptach/` folder and follow the instructions in its `README.md`
2. ⚙️ Then go to the `node-patch/` folder and follow the instructions in its `README.md`
3. 🧪 Restart the Pterodactyl services and test database creation and container connectivity

---

## 📎 Compatibility

- Pterodactyl Panel `>=1.11`
- Wings (Docker-based) node
- Docker bridge network with internal subnet (`172.18.0.0/16` recommended)

---

## 🧠 Credits

Maintained by [@nycon](https://github.com/nycon)  
Contributions, bug reports, and improvements are welcome!

---

## 📜 License

MIT – Use responsibly and at your own risk.

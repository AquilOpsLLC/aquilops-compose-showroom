# 🧩 MongoDB Replica Set Cluster Guide

This guide explains how to deploy and manage a **MongoDB Replica Set cluster** using Docker Compose.

---

## 📦 Setup Instructions

1. Clone or download this repository to your local machine.  
2. Place the `docker-compose.yml` file in the project root directory.  
3. Create a `scripts` directory and add the `init-replica.sh` file inside it.  
4. Grant execute permissions to the initialization script:

   ```bash
   chmod +x scripts/init-replica.sh
   ```

5. Start the MongoDB cluster using Docker Compose:

   ```bash
   docker-compose up -d
   ```

6. Verify the replica set status:

   ```bash
   docker exec -it mongo1 mongosh --eval "rs.status()"
   ```

---

## 🔗 Connection Details

- **Primary MongoDB URI:**

  ```
  mongodb://mongo1:27017,mongo2:27017,mongo3:27017/?replicaSet=rs0
  ```

- **Localhost URI:**

  ```
  mongodb://localhost:27017/?replicaSet=rs0
  ```

---

## ⚙️ Replica Set Specifications

- **Replica Set Name:** `rs0`  
- **Node Count:** 3 (1 Primary, 2 Secondaries)  
- **Exposed Port:** `27017` (mapped to the primary node `mongo1`)

---

## 🛠️ Cluster Management

### ✅ Check Replica Set Status

```bash
docker exec -it mongo1 mongosh --eval "rs.status()"
```

### ➕ Add a New Node to the Cluster

```bash
docker exec -it mongo1 mongosh --eval 'rs.add("new-mongo-node:27017")'
```

### ⚙️ View Replica Set Configuration

```bash
docker exec -it mongo1 mongosh --eval "rs.conf()"
```

### 💻 Access MongoDB Shell

```bash
docker exec -it mongo1 mongosh
```

---

## 🧯 Troubleshooting

### ❌ Replica Set Initialization Fails

Run the initialization script manually:

```bash
docker exec -it mongo-init bash /scripts/init-replica.sh
```

### 🌐 Connection Issues

Inspect the Docker network:

```bash
docker network inspect mongo-network
```

### 💾 Persistent Data

Data is stored in Docker volumes. To list MongoDB volumes:

```bash
docker volume ls | grep mongo
```

---

## 🧹 Shut Down the Cluster

To stop and remove the cluster:

```bash
docker-compose down
```

To also remove persistent volumes:

```bash
docker-compose down -v
```

---

## 📁 Project Structure

```bash
.
├── docker-compose.yml
└── scripts
    └── init-replica.sh
```

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

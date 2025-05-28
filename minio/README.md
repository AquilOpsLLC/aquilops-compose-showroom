# ☁️ MinIO Server Setup Guide (Docker Compose)

This guide explains how to deploy a **MinIO object storage server** using Docker Compose.  
MinIO is an S3-compatible high-performance object storage system.

---

## 📦 Setup Instructions

1. Create a project folder (e.g., `minio-server`) and move into it:

   ```bash
   mkdir minio-server && cd minio-server
   ```

2. Create the following files in the root directory:

   - `docker-compose.yml` (configuration provided below)
   - Optionally, a `.env` file to override environment variables

3. Start the MinIO server:

   ```bash
   docker-compose up -d
   ```

4. Verify MinIO is running and healthy:

   ```bash
   docker ps
   docker inspect --format='{{json .State.Health}}' minio | jq
   ```

---

## 🧾 docker-compose.yml

```yaml
version: '3.8'

services:
  minio:
    image: minio/minio:latest
    container_name: minio
    restart: unless-stopped
    ports:
      - "9000:9000"
      - "9090:9090"
    volumes:
      - minio-data:/data
    environment:
      MINIO_ROOT_USER: ${MINIO_ROOT_USER:-minio}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD:-minio123}
    command: server /data --console-address ":9090"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/ready"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  minio-data:
```

---

## 🔐 Access Credentials

Default credentials are defined as environment variables:

- **Username:** `minio`
- **Password:** `minio123`

> You can override these via a `.env` file or directly in the environment.

Example `.env`:

```env
MINIO_ROOT_USER=minio
MINIO_ROOT_PASSWORD=minio123
```

---

## 🌐 Access Endpoints

- **S3 API:** `http://localhost:9000`
- **Admin Console (UI):** `http://localhost:9090`

---

## 📦 Persistent Storage

MinIO data is stored in a Docker volume:

```bash
docker volume ls | grep minio
```

Volume name: `minio-data`

To inspect volume:

```bash
docker volume inspect minio-data
```

---

## ✅ Health Monitoring

MinIO is monitored with a built-in healthcheck hitting the readiness endpoint:

```bash
curl -f http://localhost:9000/minio/health/ready
```

Docker will restart the container automatically if it fails the healthcheck (`unless-stopped` policy).

---

## 🧹 Shut Down & Clean Up

To stop the container:

```bash
docker-compose down
```

To remove volumes as well:

```bash
docker-compose down -v
```

---

## 📁 Project Structure

```bash
.
├── docker-compose.yml
└── .env (optional)
```

---

## 📄 License

This deployment is powered by [MinIO](https://min.io), released under the GNU AGPL v3.


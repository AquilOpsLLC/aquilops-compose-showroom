# 📊 MLflow Tracking Server Deployment Guide (via Docker Compose)

This guide explains how to deploy an **MLflow Tracking Server** using Docker Compose and a custom Dockerfile.  
MLflow is an open-source platform for managing the ML lifecycle, including experimentation, reproducibility, and deployment.

---

## 📦 Setup Instructions

1. Clone or create the project folder and switch to it:

   ```bash
   mkdir mlflow-server && cd mlflow-server
   ```

2. Create the following structure:

   ```
   .
   ├── Dockerfile
   ├── docker-compose.yml
   └── mlruns/           # Will be created at runtime
       data/             # Will be created at runtime
   ```

3. Save the provided `Dockerfile` and `docker-compose.yml` (see below).

4. Build and start the MLflow server:

   ```bash
   docker-compose up -d --build
   ```

5. Check container health status:

   ```bash
   docker ps
   docker inspect --format='{{json .State.Health}}' mlflow-server | jq
   ```

---

## 🧾 docker-compose.yml

```yaml
version: '3.8'

services:
  mlflow:
    build: .
    container_name: mlflow-server
    ports:
      - "5000:5000"
    volumes: 
      - ./mlruns:/mlflow/mlruns
      - ./data:/mlflow/data
    environment:
      - MFLOW_BACKEND_STORE_URI=sqlite:////mlflow/data/mlflow.db
      - MFLOW_DEFAULT_ARTIFACT_ROOT=/mlflow/mlruns
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

---

## 🐳 Dockerfile

```dockerfile
FROM python:3.13.3-slim

RUN apt-get update && apt-get install -y sqlite3 curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir mlflow boto3 psycopg2-binary

RUN useradd -m -u 1000 mlflow

WORKDIR /mlflow
RUN mkdir /mlflow/mlruns /mlflow/data
RUN chown -R mlflow:mlflow /mlflow

USER mlflow

EXPOSE 5000
CMD ["sh", "-c", "mlflow server --backend-store-uri sqlite:////mlflow/data/mlflow.db --default-artifact-root /mlflow/mlruns --host 0.0.0.0 --port 5000"]
```

---

## 🌐 Access Information

- **Tracking UI:** http://localhost:5000
- **Artifact Location:** Mounted volume at `./mlruns`
- **Backend Store:** SQLite DB at `./data/mlflow.db`

---

## 🔐 Environment Variables

- `MFLOW_BACKEND_STORE_URI`: Path to SQLite DB or other supported backends
- `MFLOW_DEFAULT_ARTIFACT_ROOT`: Directory for storing experiment artifacts

---

## 🧯 Health & Monitoring

The container includes a healthcheck via the `/health` endpoint:

```bash
curl -f http://localhost:5000/health
```

Docker auto-restarts the container if it's unhealthy (`unless-stopped` policy).

---

## 🧹 Shut Down & Clean Up

Stop and remove the container:

```bash
docker-compose down
```

Remove volumes as well (if persistent data is disposable):

```bash
docker-compose down -v
```

---

## 📁 Project Structure

```bash
.
├── Dockerfile
├── docker-compose.yml
├── mlruns/              # Artifact root
└── data/                # SQLite DB location
```

---

## 📄 Notes

- For production, consider using a PostgreSQL backend instead of SQLite.
- You can extend this setup with MinIO for S3-compatible artifact storage or integrate with AWS/GCP.
- Use `mlflow ui` or REST API to interact with experiments remotely.

---

## 📚 References

- [MLflow Documentation](https://mlflow.org/docs/latest/index.html)
- [MLflow Tracking API](https://mlflow.org/docs/latest/tracking.html)


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
CMD ["sh","-c", "mlflow server --backend-store-uri sqlite:////mlflow/data/mlflow.db --default-artifact-root /mlflow/mlruns --host 0.0.0.0 --port 5000"]

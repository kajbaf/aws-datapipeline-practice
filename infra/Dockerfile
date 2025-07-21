# Stage 1: Base for Spark code
FROM docker.io/bitnami/spark:4.0.0 AS spark

## Stage 2: Use base Python image
FROM python:3.12.11-slim AS compile-image

# Update image
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential curl git vim procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add Java SDK from Spark image
COPY --from=spark /opt/bitnami/java /opt/java

ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    UV_SYSTEM_PYTHON=true \
    SPARK_VERSION=4.0.0 \
    HADOOP_VERSION=3 \
    PYSPARK_PYTHON=python3 \
    JAVA_HOME=/opt/java \
    PATH=/opt/java/bin:/root/.local/bin:/prj/.venv/bin:$PATH

# Copy UV requirements file from local
WORKDIR /prj/
COPY pyproject.toml uv.lock /prj/
RUN uv sync --locked --no-dev --no-install-project

ENTRYPOINT ["uv", "run"]

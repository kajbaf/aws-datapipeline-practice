# Virtual Environment
VENV_DIR := .venv

# Default target
.PHONY: all
all: init-data venv up

#    Step 1: Initialize data (copy from ./data to ./s3-datalake/source)
.PHONY: init-data
init-data:
	@echo "Copying source data to s3-datalake..."
	mkdir -p s3-datalake/source
	cp -r data/* s3-datalake/source/

#   Step 2: Manage virtualenv with uv
.PHONY: venv
venv:
	@echo "Setting up virtual environment with uv..."
	uv sync

.PHONY: lock
lock:
	@echo "Locking requirements..."
	uv lock

#   Step 3: Run individual docker-compose services
.PHONY: up-spark
up-spark:
	@echo "Starting Spark services..."
	docker-compose up -d spark worker --scale worker=2

.PHONY: build-notebook
build-notebook:
	@echo "Building Notebook image..."
	docker-compose build notebook

.PHONY: up-notebook
up-notebook:
	@echo "Starting Notebook service..."
	docker-compose up -d notebook

#   Step 4: Run all services (Spark + Notebook)
.PHONY: up
up:
	@echo "Starting Spark + Notebook services..."
	docker-compose up -d --scale worker=2

#   Clean up Docker containers and volumes
.PHONY: clean
clean:
	@echo "Stopping and removing containers and volumes..."
	docker-compose down -v
	@echo "Cleaned up."

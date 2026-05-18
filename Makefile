include .env
.PHONY: setup lint format format-check help check up rebuild down db-logs db-shell run-db-schema

COMPOSE = docker compose
DB_CONTAINER = olist-db

setup: ## Bootstrap a fresh clone: install deps and pre-commit hooks
	uv sync
	uv run pre-commit install

lint: ## Run ruff lint check
	uv run ruff check .

format: ## Reformat code with ruff
	uv run ruff format .

format-check:  ## Verify code is formatted (no changes made)
	uv run ruff format --check

check: lint format-check test ## Run all checks (lint, format-check, test)

up: ## Start project containers
	$(COMPOSE) up -d

rebuild: ## Rebuild and restart project container
	$(COMPOSE) up --build -d

down: ## Stop and remove project containers
	$(COMPOSE) down

db-logs: ## Stream db container logs
	docker logs -f $(DB_CONTAINER)

db-shell: ## Open psql shell in db container
	docker exec -it $(DB_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME)

run-db-schema: ## Drop and restart the database schema
	psql -h localhost -p 5433 -U $(DB_USER) -d $(DB_NAME) -f sql/01_schema.sql

help: ## Show this help message
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

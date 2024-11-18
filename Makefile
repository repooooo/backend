.PHONY: build build-no-cache run run-no-cache down down-with-volumes stop start logs status clean

DOCKER_COMPOSE_FILE_DEV=./dev-config/docker-compose.yml

build:
	@echo "Building Docker images with BuildKit enabled..."
	DOCKER_BUILDKIT=1 docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) build

build-no-cache:
	@echo "Building Docker images without cache..."
	DOCKER_BUILDKIT=1 docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) build --no-cache

run: build
	@echo "Building and starting containers in detached mode..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) up -d

run-no-cache: build-no-cache
	@echo "Building without cache and starting containers in detached mode..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) up -d

down:
	@echo "Stopping and removing containers..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) down

down-with-volumes:
	@echo "Stopping and removing containers along with volumes..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) down -v

stop:
	@echo "Stopping containers..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) stop

start:
	@echo "Starting stopped containers..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) start

logs:
	@echo "Displaying container logs..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) logs -f

status:
	@echo "Displaying container status..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) ps

clean:
	@echo "Stopping containers, removing volumes and images..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_DEV) down -v --rmi all

SECRETS_DIR=./test-config/secrets
LOGS_DIR=./test-config/logs
GITHUB_TOKEN_FILE=$(SECRETS_DIR)/github_token
AUTH_SERVICE_LOG_FILE=$(LOGS_DIR)/auth-service.log
EMAIL_SERVICE_LOG_FILE=$(LOGS_DIR)/email-service.log

log_files=$(AUTH_SERVICE_LOG_FILE) $(EMAIL_SERVICE_LOG_FILE)

DOCKER_COMPOSE_FILE_TEST=./test-config/docker-compose.yaml

DATABASE=database
AUTH_SERVICE=auth-service
EMAIL_SERVICE=email-service

init-test-config-secrets:
	@echo "Checking for required secrets files..."

	@mkdir -p $(SECRETS_DIR)

	@if ! grep -q "ghp" $(GITHUB_TOKEN_FILE); then \
    		echo "github_token found, but it does not contain 'ghp'."; \
    		echo "Please enter your GitHub Token (starting with 'ghp'):"; \
    		read -r TOKEN; \
    		if [ -n "$$TOKEN" ]; then \
    			echo "$$TOKEN" > $(GITHUB_TOKEN_FILE); \
    			echo "GitHub Token saved to $(GITHUB_TOKEN_FILE)."; \
    		else \
    			echo "No input provided. GitHub Token not updated."; \
    		fi; \
    	else \
    		echo "github_token already contains a valid key."; \
    	fi

init-test-config-logs:
	@echo "Checking for required logs files..."

	@mkdir -p $(LOGS_DIR)

	@for log_file in $(log_files); do \
    		if [ ! -f $$log_file ]; then \
    			echo "$$log_file not found. Creating it..."; \
    			touch $$log_file; \
    		else \
    			echo "$$log_file already exists."; \
    		fi \
    	done

init-test-config-all: init-test-config-logs init-test-config-secrets

test-auth-service:
	@echo "Starting auth-service and database..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_TEST) up -d $(AUTH_SERVICE) $(DATABASE)

	@echo "Running Go tests for auth-service..."
	@cd ./microservices/auth && go test -v ./tests

	@echo "Stopping Docker services and removing volumes..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_TEST) down -v

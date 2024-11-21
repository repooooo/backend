.PHONY: build build-no-cache run run-no-cache down down-with-volumes stop start logs status clean

DOCKER_COMPOSE_FILE_LOCAL=./infrastructure/local/docker-compose.yml

build:
	@echo "Building Docker images with BuildKit enabled..."
	DOCKER_BUILDKIT=1 docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) build

build-no-cache:
	@echo "Building Docker images without cache..."
	DOCKER_BUILDKIT=1 docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) build --no-cache

run: build
	@echo "Building and starting containers in detached mode..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) up -d

run-log: build
	@echo "Building and starting containers in detached mode..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) up

run-no-cache: build-no-cache
	@echo "Building without cache and starting containers in detached mode..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) up -d

down:
	@echo "Stopping and removing containers..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) down

down-with-volumes:
	@echo "Stopping and removing containers along with volumes..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) down -v

stop:
	@echo "Stopping containers..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) stop

start:
	@echo "Starting stopped containers..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) start

logs:
	@echo "Displaying container logs..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) logs -f

status:
	@echo "Displaying container status..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) ps

clean:
	@echo "Stopping containers, removing volumes and images..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_LOCAL) down -v --rmi all

SECRETS_DIR=./infrastructure/common/secrets
LOGS_DIR=./infrastructure/common/logs
GITHUB_TOKEN_FILE=$(SECRETS_DIR)/github_token
AUTH_SERVICE_LOG_FILE=$(LOGS_DIR)/auth-service.log
EMAIL_SERVICE_LOG_FILE=$(LOGS_DIR)/email-service.log

log_files=$(AUTH_SERVICE_LOG_FILE) $(EMAIL_SERVICE_LOG_FILE)

DOCKER_COMPOSE_FILE_TEST=./infrastructure/tests/docker-compose.yaml

DATABASE=database
AUTH_SERVICE=auth-service
EMAIL_SERVICE=email-service

init-secrets:
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

init-logs:
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

init-all: init-logs init-secrets

test-auth-service: init-all
	@echo "Starting auth-service and database..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_TEST) up -d --build $(AUTH_SERVICE) $(DATABASE)

	@echo "Running Go tests for auth-service..." \
	&& cd ./microservices/auth \
	&& export CONFIG_PATH=$(PWD)/infrastructure/tests/configs/auth-service.yaml \
    && go test -v ./tests


	@echo "Stopping Docker services and removing volumes..."
	docker-compose -f $(DOCKER_COMPOSE_FILE_TEST) down -v

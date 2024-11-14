.PHONY: build build-no-cache run run-no-cache down down-with-volumes stop start logs status clean

DOCKER_COMPOSE_FILE=./dev-config/docker-compose.yml

build:
	@echo "Building Docker images with BuildKit enabled..."
	DOCKER_BUILDKIT=1 docker-compose -f $(DOCKER_COMPOSE_FILE) build

build-no-cache:
	@echo "Building Docker images without cache..."
	DOCKER_BUILDKIT=1 docker-compose -f $(DOCKER_COMPOSE_FILE) build --no-cache

run: build
	@echo "Building and starting containers in detached mode..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

run-no-cache: build-no-cache
	@echo "Building without cache and starting containers in detached mode..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	@echo "Stopping and removing containers..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) down

down-with-volumes:
	@echo "Stopping and removing containers along with volumes..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) down -v

stop:
	@echo "Stopping containers..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) stop

start:
	@echo "Starting stopped containers..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) start

logs:
	@echo "Displaying container logs..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

status:
	@echo "Displaying container status..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) ps

clean:
	@echo "Stopping containers, removing volumes and images..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) down -v --rmi all
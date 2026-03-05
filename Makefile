# Path to the docker-compose file
COMPOSE_FILE = ./srcs/docker-compose.yml

# Main rule, executed when running just 'make'
all: build up

# Create data directories and build the images
build:
	@mkdir -p /home/mmravec/data/mariadb
	@mkdir -p /home/mmravec/data/wordpress
	docker compose -f $(COMPOSE_FILE) build

# Bonus rule to build and start the bonus services
bonus:
	@mkdir -p /home/mmravec/data/mariadb
	@mkdir -p /home/mmravec/data/wordpress
	docker compose -f ./srcs/docker-compose-bonus.yml up -d --build

# Start the containers in detached mode
up:
	docker compose -f $(COMPOSE_FILE) up -d

# Stop the containers (without deleting data volumes)
down:
	docker compose -f $(COMPOSE_FILE) down

# Stop containers, remove networks, volumes, and clean Docker cache
clean:
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -af

# Full clean: runs clean, then removes all physical data from the host disk
fclean: clean
	@sudo rm -rf /home/mmravec/data/mariadb/*
	@sudo rm -rf /home/mmravec/data/wordpress/*

# Rebuild the entire project from scratch
re: fclean all

.PHONY: all build up down clean fclean re
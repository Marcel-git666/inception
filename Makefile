# Cesta k našemu docker-compose souboru
COMPOSE_FILE = ./srcs/docker-compose.yml

# Hlavní pravidlo, které se spustí při zadání příkazu 'make'
all: build up

# Vytvoření složek pro data (pro jistotu) a sestavení obrazů
build:
	@sudo mkdir -p /home/mmravec/data/mariadb
	@sudo mkdir -p /home/mmravec/data/wordpress
	docker compose -f $(COMPOSE_FILE) build

# Spuštění kontejnerů na pozadí (-d znamená detached mode)
up:
	docker compose -f $(COMPOSE_FILE) up -d

# Vypnutí kontejnerů (bez smazání dat)
down:
	docker compose -f $(COMPOSE_FILE) down

# Zastavení kontejnerů, smazání sítě a odstranění svazků (čištění Dockeru)
clean: down
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -af

# Úplné pročištění (smaže i fyzická data z tvého disku pro čistý start)
fclean: clean
	@sudo rm -rf /home/mmravec/data/mariadb/*
	@sudo rm -rf /home/mmravec/data/wordpress/*

# Znovusestavení celého projektu od nuly
re: fclean all

.PHONY: all build up down clean fclean re
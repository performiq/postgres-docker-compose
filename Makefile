
TAG := pg-demo
NET := ${TAG}-net
VOL := ${TAG}-data
DB_PORT := $(shell cat .env | grep PG_LOCALHOST_PORT | sed 's/.*=//')
DB_PASSWORD := $(shell cat .env | grep DB_PASSWORD | sed 's/.*=//')
ADMINER_PORT := $(shell cat .env | grep ADMINER_LOCALHOST_PORT | sed 's/.*=//')


NET_EXISTS = $(shell docker network ls | grep ${NET} | wc -l | sed 's/ *//g') 
VOL_EXISTS = $(shell docker volume ls | grep ${VOL} | wc -l | sed 's/ *//g') 

.PHONEY: list
check:
	@echo "  VOL_EXISTS |${VOL_EXISTS}|"
	@echo "     DB_PORT |${DB_PORT}|"
	@echo " DB_PASSWORD |${DB_PASSWORD}|"
	@echo "ADMINER_PORT |${ADMINER_PORT}|"
	docker ps

.PHONEY: list
list: check-net

.PHONEY: ps
ps:
	@docker ps

# ------------------------------------------------------------------------------

.PHONEY: create-net
create-net:
	@if [ $(NET_EXISTS) -eq 1 ] ; then \
		echo "Docker network - ${NET} - exists already"; \
	else \
		echo "Creating new docker network - ${NET}"; \
		docker network create ${NET}; \
	fi

.PHONEY: check-net
check-net:
	-docker network ls  | grep ${NET}

# ------------------------------------------------------------------------------

.PHONEY: create-vol
create-vol:
	@if [ $(VOL_EXISTS) -eq 1 ] ; then \
		echo "Docker volume - ${VOL} - exists already"; \
	else \
		echo "Creating new docker volume - ${VOL}"; \
		docker volume create ${VOL}; \
	fi


check-vol:
	-docker volume ls | grep ${VOL}

# ------------------------------------------------------------------------------

.PHONEY: setup
setup: create-net
	mkdir -p data
	mkdir -p data/db 
	mkdir -p data/bak 
	mkdir -p data/root 
	mkdir -p storage


# ------------------------------------------------------------------------------

up:
	docker compose up -d
	docker ps | grep pg-demo

down:
	docker compose down
	docker ps


# ------------------------------------------------------------------------------

connect:
	@echo "Password is ${DB_PASSWORD}"
	PGPASSWORD=$(DB_PASSWORD) psql -h localhost -p ${DB_PORT} -Upostgres

bash:
	docker exec -it pg-demo-db bash

su-postgres:
	docker exec -it pg-demo-db su - postgres



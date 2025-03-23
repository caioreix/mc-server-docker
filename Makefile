ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

-include $(ROOT_DIR)/.env
export $(shell sed 's/=.*//' $(ROOT_DIR)/.env)

-include $(ROOT_DIR)/.$(PROJECT_NAME).env
export $(shell sed 's/=.*//' $(ROOT_DIR)/.env)


REQUIRED_VARS := PROJECT_NAME MODPACK_PLATFORM CF_PAGE_URL RESTIC_PASSWORD

check-vars:
	@$(foreach var,$(REQUIRED_VARS),\
        $(if $(value $(var)),,\
            $(error Variable '$(var)' is not defined)))

install:
	@sudo apt install restic
	@sudo -v ; curl https://rclone.org/install.sh | sudo bash

restore:
	@restic restore latest --target ./$(PROJECT_NAME)/backups -r rclone:SUPABASE:mc-server/${PROJECT_NAME}

rclone:
	rclone ls SUPABASE:mc-server/atm9tts -vv

# https://docker-minecraft-server.readthedocs.io/en/latest/commands/
rcon: check-vars
	@docker exec -i $(PROJECT_NAME)-mc rcon-cli

attach: check-vars
	@docker attach $(PROJECT_NAME)-mc

run: check-vars
	@echo "Running $(PROJECT_NAME)"
	@docker compose -f $(ROOT_DIR)/docker-compose.yml --env-file $(ROOT_DIR)/.env --env-file $(ROOT_DIR)/.$(PROJECT_NAME).env up -d

stop: check-vars
	@echo "Stopping $(PROJECT_NAME)"
	@docker compose -f $(ROOT_DIR)/docker-compose.yml --env-file $(ROOT_DIR)/.env --env-file $(ROOT_DIR)/.$(PROJECT_NAME).env down

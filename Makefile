ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

-include $(ROOT_DIR)/.env
export $(shell sed 's/=.*//' $(ROOT_DIR)/.env)

-include $(ROOT_DIR)/.$(PROJECT_NAME).env
export $(shell sed 's/=.*//' $(ROOT_DIR)/.env)


REQUIRED_VARS := PROJECT_NAME MODPACK_PLATFORM CF_PAGE_URL RESTIC_PASSWORD

PROFILE_ARG := $(if $(filter true,$(ENABLE_BACKUP)),--profile backup,)

CF_MODPACK_ZIP := $(shell \
	if [ ! -z "$(ZIP_URL)" ]; then \
		if [ -z "$(CF_FILE_ID)" ]; then \
			echo "Error: CF_FILE_ID must be set when using ZIP_URL" >&2; \
			exit 1; \
		fi; \
		echo "/modpacks/$(PROJECT_NAME)-$(CF_FILE_ID).zip"; \
	fi)

PROFILE_ARG += $(if $(CF_MODPACK_ZIP),--profile mc-zip,--profile mc-auto)


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

run: download-zip check-vars
	@echo "Running $(PROJECT_NAME)"
	@docker compose -f $(ROOT_DIR)/docker-compose.yml --env-file $(ROOT_DIR)/.env --env-file $(ROOT_DIR)/.$(PROJECT_NAME).env $(PROFILE_ARG) up -d

download-zip: check-vars
	@if [ ! -z "$(ZIP_URL)" ]; then \
		if [ -z "$(CF_FILE_ID)" ]; then \
			echo "Error: CF_FILE_ID must be set when using ZIP_URL"; \
			exit 1; \
		fi; \
		echo "Downloading modpack from $(ZIP_URL)"; \
		mkdir -p ./$(PROJECT_NAME)/modpacks; \
		wget -O ./$(PROJECT_NAME)/modpacks/$(PROJECT_NAME)-$(CF_FILE_ID).zip "$(ZIP_URL)"; \
	fi

stop: check-vars
	@echo "Stopping $(PROJECT_NAME)"
	@docker compose -f $(ROOT_DIR)/docker-compose.yml --env-file $(ROOT_DIR)/.env --env-file $(ROOT_DIR)/.$(PROJECT_NAME).env $(PROFILE_ARG) down

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

run: check-vars
	@echo "Running $(PROJECT_NAME)"
	@docker compose -f $(ROOT_DIR)/docker-compose.yml --env-file $(ROOT_DIR)/.env --env-file $(ROOT_DIR)/.$(PROJECT_NAME).env up -d

stop: check-vars
	@echo "Stopping $(PROJECT_NAME)"
	@docker compose -f $(ROOT_DIR)/docker-compose.yml --env-file $(ROOT_DIR)/.env --env-file $(ROOT_DIR)/.$(PROJECT_NAME).env down

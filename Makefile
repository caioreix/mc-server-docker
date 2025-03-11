ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

-include $(ROOT_DIR)/.env
export $(shell sed 's/=.*//' $(ROOT_DIR)/.env)


install:
	@sudo apt install restic
	@sudo -v ; curl https://rclone.org/install.sh | sudo bash

atm9tts-run:
	@echo "Running ATM9TTS"
	@docker compose -f $(ROOT_DIR)/atm9tts/docker-compose.yml --env-file $(ROOT_DIR)/.env up -d

atm9tts-stop:
	@echo "Stopping ATM9TTS"
	@docker compose -f $(ROOT_DIR)/atm9tts/docker-compose.yml --env-file $(ROOT_DIR)/.env down

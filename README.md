# Minecraft Server Docker

## Usage

1. Set the project name via `.env` or directly in the command:

   ```bash
   PROJECT_NAME=atm9tts make run
   ```

2. To enable backups, make sure RCON is enabled in `server.properties`:

   ```properties
   enable-rcon=true
   ```

## Notes

- If you see the following messages:

  ```
  INFO Repository already initialized
  INFO Checking for stale locks
  WARN Confirmed stale lock on repo, unlocking...
  ```

  Set the environment variable to suppress log output:

  ```bash
  RCLONE_LOG_LEVEL=ERROR
  ```

- Easy config to configure ports on local Windows:
  You can try to "trick" the system and redirect port 25565 from the VPN IP to Docker.

  ```bash
  netsh interface portproxy add v4tov4 listenaddress=26.x.x.x listenport=25565 connectaddress=127.0.0.1 connectport=25565
  ```

  Portproxy DOES NOT survive reboot. It stays saved, but the IP Helper service may need to be restarted. To ensure it's running after a reboot:

  ```bash
  netsh interface portproxy show all
  ```

  🗑️ To delete the rule if needed:

  ```bash
  netsh interface portproxy delete v4tov4 listenaddress=26.x.x.x listenport=25565
  ```

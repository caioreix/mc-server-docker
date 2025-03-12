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

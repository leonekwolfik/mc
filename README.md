# mc — Midnight Commander in WebUI in Docker

Run the classic **Midnight Commander** file manager directly in your browser, powered by [ttyd](https://github.com/tsl0922/ttyd) and Docker.

The container exposes port **7681**. Open `http://localhost:7681` in your browser to access MC.

---

## Quick Start

### docker build

Build from the Alpine-based Dockerfile (recommended – smaller image):

```bash
docker build -f Dockerfile.alpine -t leonekwolfik/midnight-commander .
```

Or build from the Ubuntu-based Dockerfile:

```bash
docker build -f Dockerfile.ubuntu -t leonekwolfik/midnight-commander .
```

---

### docker run

Run the container and open `http://localhost:7681` in your browser:

```bash
docker run -d \
  --name midnight-commander \
  -p 7681:7681 \
  leonekwolfik/midnight-commander
```

Mount a local directory so you can browse it inside MC:

```bash
docker run -d \
  --name midnight-commander \
  -p 7681:7681 \
  -v /path/to/your/files:/data \
  leonekwolfik/midnight-commander
```

The container automatically detects the first mounted volume and opens MC in that directory.

---

### docker compose

A ready-to-use `docker-compose.yml` is included in the repository.  
It mounts a local `data/` directory and maps port 7681:

```bash
# Start
docker compose up -d

# Open in browser
open http://localhost:7681

# Stop
docker compose down
```

To mount a different directory, edit the `volumes` section in `docker-compose.yml`:

```yaml
volumes:
  - /path/to/your/files:/data
```

---

## Environment Variables

| Variable              | Default | Description                                              |
|-----------------------|---------|----------------------------------------------------------|
| `ENTRYPOINT_TEST_MODE`| —       | Set to `1` to print the detected start directory and exit without launching ttyd (used in CI). |

---

## Ports

| Port | Protocol | Description         |
|------|----------|---------------------|
| 7681 | TCP      | ttyd web terminal   |

---

## License

[MIT](LICENSE)

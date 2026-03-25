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

### docker compose with SMB share

You can mount a network SMB/CIFS share directly in `docker-compose.yml` without mounting it on the host first.

Create a `docker-compose.yml` with a named volume using the `cifs` driver:

```yaml
services:
  midnight-commander:
    image: leonekwolfik/midnight-commander
    ports:
      - "7681:7681"
    volumes:
      - smb_share:/data
    restart: unless-stopped

volumes:
  smb_share:
    driver: local
    driver_opts:
      type: cifs
      o: "username=myuser,password=mypassword,vers=3.0"
      device: "//192.168.1.100/sharename"
```

Replace `192.168.1.100` with your NAS/server IP, `sharename` with the share name, and set your credentials.

> **Security tip:** Avoid storing credentials in `docker-compose.yml`. Use a credentials file instead:
>
> ```yaml
> driver_opts:
>   type: cifs
>   o: "credentials=/etc/samba/mc-credentials,vers=3.0"
>   device: "//192.168.1.100/sharename"
> ```
>
> Then create `/etc/samba/mc-credentials` on the host:
>
> ```
> username=myuser
> password=mypassword
> ```
>
> Secure the file so only root can read it:
>
> ```bash
> sudo chmod 600 /etc/samba/mc-credentials
> ```

> **Note:** The `cifs-utils` package must be installed on the **host** (not inside the container) for CIFS mounts to work:
>
> ```bash
> # Debian/Ubuntu
> sudo apt-get install cifs-utils
>
> # Alpine
> sudo apk add cifs-utils
> ```

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
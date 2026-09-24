# Midnight Commander in Docker

A web-based interface for the classic two-panel file manager, Midnight Commander, running in a lightweight Docker container.

## Quick Start

### Pull the image
```bash
docker pull leonekwolfik/midnight-commander
```

### Run the container
```bash
docker run -d \
  --name midnight-commander \
  -p 7681:7681 \
  leonekwolfik/midnight-commander
```

### Open in your browser
Navigate to [http://localhost:7681](http://localhost:7681).

## Usage

### Mount a local directory
The container auto-detects the first mounted volume and opens MC there.

```bash
docker run -d \
  --name midnight-commander \
  -p 7681:7681 \
  -v /path/to/your/files:/data \
  leonekwolfik/midnight-commander
```

### Docker Compose
Clone the repo, then:

```bash
docker compose up -d
```

The included `docker-compose.yml` mounts a local `data/` folder and maps port 7681.

## Build from source

```bash
# Alpine (recommended — smaller image)
docker build -f Dockerfile.alpine -t leonekwolfik/midnight-commander .
```

## SMB / CIFS Support

### Option 1 — Browse SMB shares directly inside MC
The Alpine image ships with Samba client tools (`samba-client`).
In MC press `Ctrl+\` or use the `cd` command bar and type an `smb://` URL:

```bash
smb://192.168.1.100/sharename
smb://myuser:mypassword@192.168.1.100/sharename
```

You can also use `smbclient` directly in the built-in shell:

```bash
smbclient //192.168.1.100/sharename -U myuser
```

No host-side packages needed for this option.

### Option 2 — Mount an SMB share as a Docker volume (CIFS driver)
Use Docker's built-in `cifs` driver to mount the share before the container starts.
Add a named volume to your `docker-compose.yml`:

```yaml
volumes:
  smb_share:
    driver: local
    driver_opts:
      type: cifs
      o: "username=myuser,password=mypassword,vers=3.0"
      device: "//192.168.1.100/sharename"
```

Then reference `smb_share:/data` in your service's `volumes` list.
This option requires `cifs-utils` installed on the **host**:

```bash
# Debian/Ubuntu host
sudo apt-get install cifs-utils

# RHEL/CentOS host
sudo yum install cifs-utils

# Alpine host
sudo apk add cifs-utils
```

For security, store credentials in a file (`/etc/samba/mc-credentials`, mode 600) and reference it via
`o: "credentials=/etc/samba/mc-credentials,vers=3.0"` instead of embedding them in the compose file.

## Reference

### Ports
| Port | Protocol | Description |
|------|----------|-------------|
| 7681 | TCP      | ttyd web terminal |

### Environment variables
| Variable | Description |
|----------|-------------|
| `ENTRYPOINT_TEST_MODE` | Set to `1` to print the detected start directory and exit without launching ttyd (CI use). |

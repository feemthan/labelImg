# LabelImg Docker Setup

A Docker setup for running LabelImg image annotation tool with GUI support.

## Prerequisites

- Docker and Docker Compose installed
- X11 server running (for GUI display)
- Linux/Unix environment (for X11 forwarding)

## Setup

1. Place the `Dockerfile` and `docker-compose.yml` in your project directory
2. Allow X11 connections from Docker (run on host):
   ```bash
   xhost +local:docker
   ```

## Usage

### Build the image (first time only)
```bash
docker-compose build
```

### Run LabelImg
```bash
docker-compose up
```

### Run with specific image directory
```bash
# If your images are in a subdirectory
docker-compose run --rm labelimg labelImg images/
```

### Run with predefined classes
```bash
# If you have a predefined_classes.txt file
docker-compose run --rm labelimg labelImg images/ predefined_classes.txt
```

### Stop the container
```bash
docker-compose down
```

## File Structure

```
your-project/
├── Dockerfile
├── docker-compose.yml
├── images/           # Your images to label
├── labels/           # Generated annotation files
└── predefined_classes.txt  # Optional: predefined class names
```

## Alternative Commands

### Run without Docker Compose
```bash
# Build image
docker build -t labelimg .

# Run container
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v $(pwd):/app \
  --network host \
  labelimg
```

### Run with custom arguments
```bash
docker-compose run --rm labelimg labelImg --help
```

## Troubleshooting

### Display issues
If you encounter display issues:

1. Check DISPLAY variable:
   ```bash
   echo $DISPLAY
   ```

2. Allow X11 connections:
   ```bash
   xhost +local:docker
   ```

3. For SSH connections, use:
   ```bash
   export DISPLAY=:0
   ```

### Permission issues
If you have file permission issues, you can add user mapping to docker-compose.yml:
```yaml
user: "${UID}:${GID}"
```

Then run:
```bash
UID=$(id -u) GID=$(id -g) docker-compose up
```

## Security Note

Remember to revoke X11 permissions when done:
```bash
xhost -local:docker
```
#!/bin/bash

echo "Setting up LabelImg Docker environment..."

# Get current user information
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo "User ID: $USER_ID"
echo "Group ID: $GROUP_ID"

# Create .env file with user information
cat > .env << EOF
# Environment variables for Docker Compose
USER_ID=$USER_ID
GROUP_ID=$GROUP_ID
EOF

# Create necessary directories
echo "Creating directories..."
mkdir -p test_images
mkdir -p runtime

# Set proper permissions
echo "Setting permissions..."
chmod 755 test_images
chmod 755 runtime

# Fix any existing root-owned files in test_images
if [ -d "test_images" ] && [ "$(ls -la test_images 2>/dev/null | grep '^-.*root' | wc -l)" -gt 0 ]; then
    echo "Fixing ownership of existing files in test_images..."
    sudo chown -R $USER_ID:$GROUP_ID test_images
fi

# Build the Docker image
echo "Building Docker image..."
docker compose build --no-cache

echo ""
echo "Setup complete! You can now run:"
echo "  docker compose up"
echo ""
echo "To clean up later:"
echo "  docker compose down"
echo "  docker rmi labelimg:latest"
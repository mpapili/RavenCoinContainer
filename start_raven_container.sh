#!/bin/bash

# Function to check if Docker is already allowed in xhost
check_docker_in_xhost() {
    if xhost | grep -q "local:docker"; then
        return 0 # Docker is found in xhost list
    else
        return 1 # Docker is not found in xhost list
    fi
}

# Main script starts here
echo "Checking if local Docker is already added to xhost..."

if check_docker_in_xhost; then
    echo "Local Docker is already added to xhost. No action needed."
else
    # If Docker is not found in xhost, proceed with the prompt
    echo "Local Docker is not added to xhost."
    echo "This script can add local Docker to xhost to allow GUI applications in Docker containers to display on your host's X server."
    echo "This is necessary for running GUI applications from Docker containers."
    read -p "Are you okay with adding local Docker to xhost? (y/n) " -n 1 -r
    echo    # Move to a new line

    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Add local Docker to xhost
        xhost +local:docker
        echo "Local Docker has been added to xhost."
    else
        echo "Operation cancelled. Local Docker has not been added to xhost."
    fi
fi

docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $(pwd)/raven_data:/root/.raven \
  ravencoin


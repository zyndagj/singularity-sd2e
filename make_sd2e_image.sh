#!/bin/bash

# Clone latest jupyteruser-sd2e repo
git clone https://github.com/sd2e/jupyteruser-sd2e.git
cd jupyteruser-sd2e
# Build jupyteruser-sd2e docker container locally
make clean && make develop

# Convert docker image to singularity
docker run -v /var/run/docker.sock:/var/run/docker.sock \
	-v $PWD:/output --privileged -t --rm \
	singularityware/docker2singularity sd2e/jupyteruser-sd2e:devel
# Get image name
IMG=$(ls sd2e_jupyteruser-sd2e_devel*img)
echo $IMG

# Incorporate changes into singularity image
gzip -dc ../changes.tar.gz | singularity import $IMG

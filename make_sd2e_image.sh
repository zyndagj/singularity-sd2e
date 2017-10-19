#!/bin/bash

dIMG=taccsciapps/jupyteruser-sd2e:0.2.0

set -ex

# Make folder structure
mkdir -p singularity_files/usr/share/sd2e/
# Pull image
docker pull $dIMG
# Grab files from /home/jupyter
docker run -u root -v $PWD/singularity_files/usr/share/sd2e/jupyter:/output --rm -t $dIMG -c "sudo cp -r /home/jupyter/* /output/"
docker run -u root -v $PWD/singularity_files/usr/share/sd2e:/output --rm -t $dIMG -c "sudo cp -r /home/jupyter/.jupyter /output/"
# Delete .git files
find singularity_files -name .\* | sudo xargs -n 1 rm -rf
# Convert docker image to singularity
docker run -v /var/run/docker.sock:/var/run/docker.sock \
	-v $PWD:/output --privileged -t --rm \
	singularityware/docker2singularity $dIMG
# Get image name
IMG=$(ls sd2e_jupyteruser-sd2e_devel*img)
# Get docker_environment
singularity export $IMG /docker_environment | tar -xf - -C singularity_files
# Chown everything
chown $USER $IMG
chown -R $USER singularity_files
# Modify docker_environment
sed -e '/export (WORK|DATA)/d' singularity_files/docker_environment
sed -i 's~/home/jupyter~$STOCKYARD/jupyter~' singularity_files/docker_environment

# Tar up jupyter for $WORK
(cd $PWD/singularity_files/usr/share/sd2e && tar -czf jupyter.tar.gz jupyter)
# Tar up .jupyter for home
(cd $PWD/singularity_files/usr/share/sd2e && tar -czf dotjupyter.tar.gz .jupyter)

# Incorporate changes into image

# Incorporate changes into singularity image
gzip -dc ../changes.tar.gz | singularity import $IMG
 1177  

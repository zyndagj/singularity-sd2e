#!/bin/bash

dIMG=taccsciapps/jupyteruser-sd2e:0.2.0

set -ex

# Delete old data
for f in taccsciapps_jupyteruser-sd2e*img singularity_files/usr singularity_files/docker_environment
do
	[ -e $f ] && rm -rf $f
done
# Make folder structure
mkdir -p singularity_files/usr/share/sd2e/

# Pull image
docker pull $dIMG
# Grab files from /home/jupyter
docker run -u root -v $PWD/singularity_files/usr/share/sd2e/jupyter:/output --rm -t $dIMG bash -c "cp -r /home/jupyter/* /output/"
docker run -u root -v $PWD/singularity_files/usr/share/sd2e:/output --rm -t $dIMG bash -c "cp -r /home/jupyter/.jupyter /output/"
curl https://raw.githubusercontent.com/SD2E/jupyteruser-sd2e/master/test/dotjupyter/jupyter-local-conf.py --output singularity_files/usr/share/sd2e/.jupyter/jupyter_notebook_config.py
# Add symlinks
( cd singularity_files/usr/share/sd2e/jupyter && ln -s /work/projects/SD2E-Community/prod/data/ sd2e-community )
( cd singularity_files/usr/share/sd2e/jupyter && ln -s ../ tacc-work )
# Delete .git files
find singularity_files -name ".g*" | sudo xargs -n 1 rm -rf

# Convert docker image to singularity
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/output --privileged -t --rm \
	singularityware/docker2singularity $dIMG
# Get image name
IMG=$(ls taccsciapps_jupyteruser-sd2e*img)

# Get docker_environment
singularity exec $IMG cp /docker_environment /tmp/ && mv /tmp/docker_environment singularity_files/
# Chown everything
chown $USER $IMG
chown -R $USER singularity_files
# Modify docker_environment
sed -i '/export WORK/d' singularity_files/docker_environment
sed -i '/export USER/d' singularity_files/docker_environment
sed -i 's~/home/jupyter~$STOCKYARD/jupyter~' singularity_files/docker_environment

# Tar up jupyter for $WORK
(cd $PWD/singularity_files/usr/share/sd2e && tar -czf jupyter.tar.gz jupyter && rm -rf jupyter)
# Tar up .jupyter for home
(cd $PWD/singularity_files/usr/share/sd2e && tar -czf dotjupyter.tar.gz .jupyter && rm -rf .jupyter)

chown -R $USER singularity_files

# Incorporate changes into singularity image
( cd singularity_files && tar -cf - * ) | singularity import $IMG

#!/bin/bash
#SBATCH -J sd2e-notebook
#SBATCH -o sd2e-notebook.%j.o
#SBATCH -e sd2e-notebook.%j.e
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -A SD2E-Community
#SBATCH -t 06:00:00

export PASSWORD=`date | md5sum | cut -c-32`
RPORT=`shuf -i 2000-65000 -n 1`
LPORT=8888
LOGIN=login1.${TACC_SYSTEM}.tacc.utexas.edu
LOCAL=${HOSTNAME}.${TACC_SYSTEM}.tacc.utexas.edu
IMG=${TACC_SD2E_DIR}/sd2e_jupyteruser-sd2e_devel.img

ssh -f -g -N -R ${RPORT}:${LOCAL}:${LPORT} ${LOGIN}
mail -s "SD2E notebook" $EMAIL << EOF
Your notebook will be running for the next 6 hours. You can access it at

	http://login1.${TACC_SYSTEM}.tacc.utexas.edu:${RPORT}

	PASSWORD = ${PASSWORD}
EOF
singularity run $IMG

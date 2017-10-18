help (
[[
This module provides a script to launch an SD2E jupyter notebook server on a TACC compute node. Please run as follows:

  submit_notebook

Then enter your email to receive a link when your notebook is running.

Version 0.1

]])

whatis("Name: singularity-sd2e")
whatis("Version: 0.1")
whatis("Category: jupyter, sd2e")
whatis("Keywords: jupyter, sd2e")
whatis("Description: a local sd2e notebook environment running on hpc")
whatis("URL: https://github.com/SD2E/jupyteruser-sd2e")

always_load("tacc-singularity")

setenv("TACC_SD2E_DIR",	"/work/03076/gzynda/public/apps/singularity-sd2e/")

prepend_path("PATH",	"/work/03076/gzynda/public/apps/singularity-sd2e/")

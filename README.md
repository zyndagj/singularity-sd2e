# singularity-sd2e
Create a singularity image from jupyter-sd2e

## Requirements

* singularity
* docker
* `$WORK` folder

## Building Singularity Image

```
sudo bash make_sd2e_image.sh
```

## Running Singularity Container

```
export PASSWORD=secret
singularity run sd2e_jupyteruser-sd2e_devel*.img
```

singularity run does the following:

* unpacks `$HOME/.jupyter/jupyter_notebook_config.py`
* unpacks example SD2E data in `$WORK/jupyter/`
* launches notebook from `$WORK/jupyter` or `$PWD` on port 8888

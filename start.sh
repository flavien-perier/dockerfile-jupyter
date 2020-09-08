#!/bin/bash

PASSWORD_HASH=$(python3 password.py)
mkdir ~/.jupyter
echo "{\"NotebookApp\": {\"password\":\"$PASSWORD_HASH\"}}" > ~/.jupyter/jupyter_notebook_config.json
jupyter notebook --notebook-dir=/opt/notebooks --ip="*" --port=8080 --no-browser --allow-root

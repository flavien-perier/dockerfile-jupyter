#!/bin/bash

set -e

mkdir -p ~/.jupyter

python3 << EOL > ~/.jupyter/jupyter_notebook_config.json
from jupyter_server.auth import passwd
import os

jupyter_hash=passwd(os.environ['JUPYTER_PASSWORD'])
print('{"NotebookApp": {\"password\":"' + jupyter_hash + '"}}')
EOL

jupyter notebook --notebook-dir=/opt/notebooks --ip="*" --port=8080 --no-browser --allow-root
from notebook.auth import passwd
import os

print(passwd(os.environ['JUPYTER_PASSWORD']))
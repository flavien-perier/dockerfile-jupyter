import os
import json
from jupyter_server.auth import passwd
from jupyter_server.serverapp import ServerApp

jupyter_password = os.environ.get("JUPYTER_PASSWORD")

jupyter_dir = os.path.expanduser("/opt/jupyter/.jupyter")
os.makedirs(jupyter_dir, exist_ok=True)

jupyter_hash = passwd(jupyter_password)

config_content = {
    "IdentityProvider": {
        "hashed_password": jupyter_hash
    }
}

config_path = os.path.join(jupyter_dir, "jupyter_server_config.json")
with open(config_path, "w") as config_file:
    json.dump(config_content, config_file)

app = ServerApp()
app.root_dir = "/data"
app.ip = "0.0.0.0"
app.port = 8080
app.open_browser = False

app.initialize()
app.start()

# Dockerfile Jupyter

Dockerfile for Python ![Jupyter](https://jupyter.org/) environment.

## Env variables

- JUPYTER_PASSWORD: Password of the Jupyter environment

## Ports

- 8080: HTTP

## Volumes

- /opt/notebooks

## Docker-compose example

```yaml
jupyter:
    image: flavienperier/jupyter
    container_name: jupyter
    restart: always
    volumes:
      - ./documents:/opt/notebooks
    environment:
      JUPYTER_PASSWORD: password
```

![license](https://badgen.net/github/license/flavien-perier/dockerfile-jupyter)
[![docker pulls](https://badgen.net/docker/pulls/flavienperier/jupyter)](https://hub.docker.com/r/flavienperier/jupyter)
[![ci status](https://badgen.net/github/checks/flavien-perier/dockerfile-jupyter)](https://github.com/flavien-perier/dockerfile-jupyter)

# Dockerfile Jupyter

Dockerfile for Python [Jupyter](https://jupyter.org/) environment.

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
  ports:
    - 8080:8080
  environment:
    JUPYTER_PASSWORD: password
```

FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04

LABEL org.opencontainers.image.title="Jupyter" \
      org.opencontainers.image.description="Jupyter notebook" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.vendor="flavien.io" \
      org.opencontainers.image.maintainer="Flavien PERIER <perier@flavien.io>" \
      org.opencontainers.image.url="https://github.com/flavien-perier/dockerfile-jupyter" \
      org.opencontainers.image.source="https://github.com/flavien-perier/dockerfile-jupyter" \
      org.opencontainers.image.licenses="MIT"

ARG DOCKER_UID="1000" \
    DOCKER_GID="1000" \
    DEBIAN_FRONTEND="noninteractive"

ENV JUPYTER_PASSWORD="password"

WORKDIR /opt/jupyter
VOLUME /opt/notebooks

RUN apt-get update && apt-get install -y python3 python3-dev python3-pip python3-poetry python3-venv gcc gpp && \
    deluser ubuntu && \
    mkdir -p /opt/jupyter && \
    mkdir -p /data && \
    groupadd -g $DOCKER_GID jupyter && \
    useradd -g jupyter -M -d /opt/jupyter -u $DOCKER_UID jupyter && \
    chown -R jupyter: /opt/jupyter && \
    chmod -R 700 /opt/jupyter && \
    chown -R jupyter: /data && \
    chmod -R 700 /data && \
    rm -rf /var/lib/apt/lists/* && \
    rm -Rf /var/log/apt/* && \
    rm -f /var/log/dpkg.log

USER jupyter

WORKDIR /opt/jupyter/venv

COPY --chown=jupyter:jupyter --chmod=400 requirements.txt requirements.txt

RUN python3 -m venv /opt/jupyter/venv && \
    . /opt/jupyter/venv/bin/activate && \
    pip3 install -r requirements.txt && \
    rm -Rf /opt/jupyter/.cache && \
    mkdir -p /opt/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension && \
    chmod -R 700 /opt/jupyter/.jupyter

WORKDIR /opt/jupyter

VOLUME /data

EXPOSE 8080

COPY --chown=jupyter:jupyter --chmod=500 start-jupyter.py start-jupyter.py
COPY --chown=jupyter:jupyter --chmod=500 start-docker.sh start-docker.sh
COPY --chown=jupyter:jupyter --chmod=400 themes.jupyterlab-settings /opt/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings

CMD ["./start-docker.sh"]

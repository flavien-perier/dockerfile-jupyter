FROM nvidia/cuda:12.8.1-devel-ubuntu24.04

LABEL org.opencontainers.image.title="Jupyter" \
      org.opencontainers.image.description="Jupyter notebook" \
      org.opencontainers.image.version="2.0.0" \
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

RUN apt-get update && apt-get install -y sudo python3 python3-dev python3-pip python3-poetry gcc gpp libcudnn9-cuda-12 && \
    pip3 install --break-system-packages jupyterlab && \
    deluser ubuntu && \
    groupadd -g $DOCKER_GID jupyter && \
    useradd -g jupyter -M -d /opt/jupyter -u $DOCKER_UID jupyter && \
    chmod -R 750 /opt/jupyter && \
    chown -R jupyter:jupyter /opt/jupyter && \
    rm -rf /var/lib/apt/lists/* && \
    echo "jupyter ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jupyter

RUN pip3 install --break-system-packages --user pandas scipy numpy statsmodels scikit-learn matplotlib seaborn tensorflow keras nltk transformers openai crewai langchain-community

COPY --chown=jupyter:jupyter --chmod=500 themes.jupyterlab-settings .jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
COPY --chown=jupyter:jupyter --chmod=500 start.py start.py

EXPOSE 8080

CMD ./start.py

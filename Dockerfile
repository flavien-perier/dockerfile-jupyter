FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

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

RUN apt-get update && apt-get install -y sudo python3 python3-dev python3-pip gcc gpp libcudnn8 &&\
    pip3 install notebook==6.5.7 jupyter_contrib_nbextensions jupyterthemes && \
    groupadd -g $DOCKER_GID jupyter && \
    useradd -g jupyter -M -d /opt/jupyter -u $DOCKER_UID jupyter && \
    chmod -R 750 /opt/jupyter && \
    chown -R jupyter:jupyter /opt/jupyter && \
    rm -rf /var/lib/apt/lists/* && \
    echo "jupyter ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jupyter

RUN pip3 install pandas scipy numpy statsmodels scikit-learn matplotlib seaborn tensorflow keras nltk transformers openai --user && \
    pip3 install jupyter-tabnine --user && \
    jupyter contrib nbextension install --user && \
    jupyter nbextension install --py jupyter_tabnine --user && \
    jupyter nbextension enable --py jupyter_tabnine --user && \
    jupyter serverextension enable --py jupyter_tabnine --user && \
    jupyter nbextension enable execute_time/ExecuteTime --user && \
    jupyter nbextension enable autosavetime/main --user && \
    jupyter nbextension enable hide_input_all/main --user && \
    jupyter nbextension enable skip-traceback/main --user && \
    jupyter nbextension enable varInspector/main --user && \
    jupyter nbextension enable table_beautifier/main --user && \
    jupyter nbextension enable snippets_menu/main --user && \
    jupyter nbextension enable hinterland/hinterland --user && \
    jt -t monokai -f fira -fs 13 -nf ptsans -nfs 11 -N -kl -cursw 5 -cursc r -cellw 95% -T

COPY --chown=jupyter:jupyter --chmod=500 start.sh start.sh

EXPOSE 8080

CMD ./start.sh

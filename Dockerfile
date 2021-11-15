FROM nvidia/cuda:11.4.2-devel-ubuntu20.04

LABEL maintainer="Flavien PERIER <perier@flavien.io>" \
      version="2.0.0" \
      description="Jupyter notebook"

ARG DOCKER_UID="500" \
    DOCKER_GID="500" \
    DEBIAN_FRONTEND=noninteractive

ENV JUPYTER_PASSWORD="password"

WORKDIR /opt/jupyter
VOLUME /opt/notebooks

RUN apt-get update && apt-get install -y sudo python3.9 python3.9-dev python3-pip gcc gpp libcudnn8 &&\
    pip3 install jupyter jupyter_contrib_nbextensions jupyterthemes && \
    groupadd -g $DOCKER_GID jupyter && \
    useradd -g jupyter -M -d /opt/jupyter -u $DOCKER_UID jupyter && \
    chmod -R 750 /opt/jupyter && \
    chown -R jupyter:jupyter /opt/jupyter && \
    rm -rf /var/lib/apt/lists/* && \
    echo "jupyter ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY --chown=jupyter:jupyter start.sh start.sh

USER jupyter

RUN pip3 install pandas scipy numpy statsmodels sklearn matplotlib seaborn tensorflow tensorflow-gpu keras nltk openai --user && \
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
    jt -t monokai -f fira -fs 13 -nf ptsans -nfs 11 -N -kl -cursw 5 -cursc r -cellw 95% -T && \
    chmod 750 start.sh

EXPOSE 8080

CMD ./start.sh

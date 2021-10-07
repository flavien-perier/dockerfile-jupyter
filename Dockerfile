FROM nvidia/cuda:10.0-devel

LABEL maintainer="Flavien PERIER <perier@flavien.io>" \
      version="1.0.0" \
      description="Jupyter notebook"

ARG DOCKER_UID="500" \
    DOCKER_GID="500"

ENV JUPYTER_PASSWORD="password" \
    LD_LIBRARY_PATH="/usr/local/cuda/lib64/;/usr/lib/x86_64-linux-gnu/"

WORKDIR /opt/jupyter
VOLUME /opt/notebooks

RUN apt-get update && \
    apt-get install -y sudo python3.6 python3.6-dev python3-pip gcc gpp libcudnn7 && \
    pip3 install jupyter jupyter_contrib_nbextensions jupyterthemes && \
    groupadd -g $DOCKER_GID jupyter && \
    useradd -g jupyter -M -d /opt/jupyter -u $DOCKER_UID jupyter && \
    chmod -R 750 /opt/jupyter && \
    chown -R jupyter:jupyter /opt/jupyter && \
    rm -rf /var/lib/apt/lists/* && \
    echo "jupyter ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY --chown=jupyter:jupyter start.sh start.sh

USER jupyter

RUN pip3 install pandas scipy numpy statsmodels sklearn matplotlib seaborn tensorflow tensorflow-gpu keras nltk --user && \
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
    jt -t monokai -f fira -fs 13 -nf ptsans -nfs 11 -N -kl -cursw 5 -cursc r -cellw 95% -T

EXPOSE 8080

CMD ./start.sh

FROM python:slim-buster

LABEL maintainer="Flavien PERIER <perier@flavien.io>"
LABEL version="1.0"
LABEL description="Jupyter notebook"

ARG DOCKER_UID=500
ARG DOCKER_GID=500

ENV JUPYTER_PASSWORD=password

WORKDIR /opt/jupyter

RUN apt-get update && apt-get install -y sudo && \
    pip3 install jupyter jupyter_contrib_nbextensions jupyterthemes ipyparallel && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g $DOCKER_GID jupyter && \
    useradd -g jupyter -M -d /opt/jupyter -u $DOCKER_UID jupyter

COPY password.py password.py
COPY start.sh start.sh
RUN chmod -R 750 /opt/jupyter && \
    chown -R jupyter:jupyter /opt/jupyter && \
    echo "jupyter ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jupyter
VOLUME /opt/notebooks
EXPOSE 8080

RUN pip3 install pandas scipy numpy statsmodels sklearn matplotlib tensorflow tensorflow-gpu keras nltk

RUN pip3 install jupyter-tabnine --user && \
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

CMD ./start.sh

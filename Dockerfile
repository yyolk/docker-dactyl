FROM python:3-slim-stretch
MAINTAINER Joseph Yølk Chiocchi <joe@yolk.cc>

ENV WORKSPACE /opt/workspace

RUN pip install -U dactyl && mkdir -p $WORKSPACE
WORKDIR $WORKSPACE
VOLUME $WORKSPACE

ENTRYPOINT ["dactyl_build"]

CMD []

FROM alpine:3.19

ARG BUILD_DATE
ARG MITOGEN_VERSION=0.3.4
ARG VCS_REF

ARG USER=ubuntu
ARG GROUP=root

ENV HOME /home/${USER}

LABEL maintainer="Kartashov E. <kartashov_egor96@mail.ru>" \
  org.label-schema.build-date=${BUILD_DATE} \
  org.label-schema.vcs-ref=${VCS_REF} \
  org.label-schema.docker.dockerfile="/Dockerfile" \
  org.label-schema.description="K3S on alpine docker image" \
  org.label-schema.schema-version="1.0"

RUN apk --update --no-cache add \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        rsync \
        sshpass \
        nano \
        curl \
        wget \
        bash

USER root

# Set user and group
RUN adduser -S -G ${GROUP} ${USER}

RUN mkdir -p ${HOME}/.ssh
RUN echo -e """\
    \n\
    Host *\n\
        StrictHostKeyChecking no\n\
        UserKnownHostsFile=/dev/null\n\
    """ >> ${HOME}/.ssh/config

CMD ["/bin/sh"]
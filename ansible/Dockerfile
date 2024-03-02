FROM alpine:3.19

ARG BUILD_DATE
ARG ANSIBLE_VERSION=9.1.0
ARG ANSIBLE_LINT_VERSION=6.22.1
ARG MITOGEN_VERSION=0.3.4
ARG VCS_REF

LABEL maintainer="Kartashov E. <kartashov_egor96@mail.ru>" \
  org.label-schema.build-date=${BUILD_DATE} \
  org.label-schema.version=${ANSIBLE_VERSION} \
  org.label-schema.version_ansible=${ANSIBLE_VERSION} \
  org.label-schema.version_ansible_lint=${ANSIBLE_LINT_VERSION} \
  org.label-schema.vcs-ref=${VCS_REF} \
  org.label-schema.docker.dockerfile="/Dockerfile" \
  org.label-schema.description="Ansible on alpine docker image" \
  org.label-schema.schema-version="1.0"

COPY ./entrypoint /usr/local/bin/

RUN apk --update --no-cache add \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        py3-cryptography \
        py3-pip \
        py3-yaml \
        python3\
        rsync \
        sshpass \
        nano \
        curl \
        wget \
        bash

RUN apk --update --no-cache add --virtual \
        .build-deps \
        build-base \
        cargo \
        curl \
        libffi-dev \
        openssl-dev \
        python3-dev

RUN pip3 install --no-cache-dir --break-system-packages --upgrade pip

RUN pip3 install --no-cache-dir --break-system-packages --upgrade --no-binary \
        cffi \
        ansible==${ANSIBLE_VERSION} \
        ansible-lint==${ANSIBLE_LINT_VERSION} \
        mitogen==${MITOGEN_VERSION}

RUN apk del .build-deps

RUN rm -rf /var/cache/apk/*

RUN find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
  && find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

RUN mkdir -p /etc/ansible/playbooks \
  && mkdir -p /etc/ansible/hosts \
  && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

COPY ./hosts /etc/ansible/hosts

WORKDIR /ansible

RUN ln -s /ansible/roles /etc/ansible/roles

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]

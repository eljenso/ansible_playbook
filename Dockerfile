FROM alpine:3.6

RUN \
  apk --update add sudo && \
  apk --update add python py-pip openssl ca-certificates && \
  apk --update add --virtual \ 
  build-dependencies \
  python-dev \
  libffi-dev \
  openssl-dev \
  build-base && \
  pip install --upgrade pip cffi && \
  pip install ansible && \
  pip install --upgrade pywinrm && \
  apk --update add sshpass openssh-client rsync && \
  apk del build-dependencies && \
  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True

# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/bin/bash"]

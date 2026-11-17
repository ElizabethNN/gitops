FROM alpine:latest
LABEL authors="nikita"

RUN apk add --no-cache ansible-core openssh-client py3-pip py3-requests \
    && pip install --no-cache-dir --break-system-packages proxmoxer
RUN ansible-galaxy collection install community.proxmox

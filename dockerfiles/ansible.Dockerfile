FROM alpine:latest
LABEL authors="nikita"

RUN apk add --no-cache ansible-core openssh-client
RUN ansible-galaxy collection install community.proxmox

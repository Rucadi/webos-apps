FROM ubuntu:latest
RUN apt update && apt install -y build-essential bsdextrautils python3 git mmdebstrap sudo && apt clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/*
RUN useradd -ms /bin/bash user && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

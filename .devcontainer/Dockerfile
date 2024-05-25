FROM ubuntu:latest
RUN apt update && apt install -y curl sudo xz-utils && apt clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/*
RUN useradd -ms /bin/bash user && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER user
ENV HOME /home/user
ENV USER user
WORKDIR /home/user
RUN curl -L https://nixos.org/nix/install > install-nix.sh && bash install-nix.sh --no-daemon && rm install-nix.sh
RUN echo . /home/user/.nix-profile/etc/profile.d/nix.sh >> /home/user/.bashrc
RUN mkdir -p /home/user/.config/nix/ && echo experimental-features = nix-command flakes >> /home/user/.config/nix/nix.conf
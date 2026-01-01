FROM debian:trixie-slim
WORKDIR /workspace

RUN apt-get update && apt-get install -y curl git zsh sudo

RUN git config --global init.defaultBranch main

# Run terminal under `vscode` user which has `sudo`, run containers under `lean`
RUN adduser --disabled-password --comment "" --ingroup sudo vscode
RUN passwd -l root
RUN echo "vscode ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/vscode

USER vscode
RUN sudo curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y

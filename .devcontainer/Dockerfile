ARG VARIANT=bullseye
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    texlive-base \
    texlive-binaries \
    texlive-fonts-recommended \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-science \
    texlive-font-utils \
    biber \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

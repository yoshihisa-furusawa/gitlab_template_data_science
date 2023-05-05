# FROM nvidia/cuda:11.6.0-cudnn8-runtime-ubuntu20.04
FROM ubuntu:20.04

ENV TZ=Asia/Tokyo
RUN echo $TZ > /etc/timezone

SHELL ["/bin/bash", "-c"]

ENV LC_CTYPE="C.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive

ARG USER_NAME=root
ARG HOMEDIR=/root/

# RUN sed -i'' 's/archive.ubuntu.com/jp.archive.ubuntu.com/' /etc/apt/sources.list
RUN sed -i.org -e 's|archive.ubuntu.com|ubuntutym.u-toyama.ac.jp|g' /etc/apt/sources.list

# delete cuda log files
RUN rm -rf /etc/apt/sources.list.d/cuda.list
RUN rm -rf /etc/apt/sources.list.d/nvidia-ml.list

# github setting
RUN echo "source /usr/share/bash-completion/completions/git" >> ~/.bashrc

# apt install
RUN apt-get autoclean -y && apt-get clean all -y && rm -rf /var/lib/apt/list/* && apt-get update --fix-missing
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get install -y build-essential checkinstall apt-utils gcc git g++ \
    cmake curl make vim wget unzip yasm screen zip --fix-missing

RUN apt-get install -y zlib1g-dev libncurses5-dev \
    libgdbm-dev libnss3-dev libssl-dev libreadline-dev \
    libffi-dev libsqlite3-dev libbz2-dev --fix-missing

RUN apt-get install -y python3.9 python3.9-dev python3-venv python3.9-venv python3-pip --fix-missing

WORKDIR root

# poetry setting
RUN curl -sSL https://install.python-poetry.org | python3.9 - --version 1.2.0
RUN /root/.local/bin/poetry self update
RUN /root/.local/bin/poetry config virtualenvs.in-project true

# python setting
RUN echo export PATH="$PATH:/root/.local/bin/" >> ~/.bashrc \
    && echo alias python=python3.9 >> ~/.bashrc \
    && echo alias python3=python3.9 >> ~/.bashrc

# set japanese format
RUN wget https://www.dropbox.com/s/zb7lub5c3zc8xgm/meiryo.lzh
RUN apt-get install -y lhasa
RUN lha x meiryo.lzh
RUN rm meiryo.lzh
RUN mkdir -p /usr/share/fonts/meiryo
RUN mv meiryo.ttc meiryob.ttc /usr/share/fonts/meiryo
RUN chmod 755 /usr/share/fonts/meiryo -R

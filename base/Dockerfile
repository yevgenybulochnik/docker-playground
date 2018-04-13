FROM ubuntu:16.04

RUN apt update

RUN apt install -y \
    git \
    curl \
    htop \
    sudo \
    locales \
    net-tools \
    software-properties-common

RUN apt-add-repository ppa:jonathonf/vim -y

RUN apt update &&  apt install -y vim

RUN curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -

RUN apt install nodejs -y

RUN git clone https://github.com/yevgenybulochnik/dotfiles /root/dotfiles

RUN locale-gen en_US.UTF-8

RUN echo "export LC_CTYPE=en_US.UTF-8" >> /root/.bashrc
RUN echo "export LC_ALL=en_US.UTF-8" >> /root/.bashrc

RUN /root/dotfiles/install.sh

CMD ["/bin/bash"]

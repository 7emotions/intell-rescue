FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install -y sudo \
    && useradd -m developer -s /bin/bash \
    && adduser developer sudo \
    && echo "developer ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers   

ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y tzdata \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-get update && apt-get install -y \
    build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
    python3-dev python3-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev \
    libcanberra-gtk-module libcanberra-gtk3-module

USER developer
WORKDIR /home/developer

RUN sudo apt update && sudo apt install -y git\
    && git config --global http.proxy http://172.17.0.1:7890 \
    && git config --global https.proxy http://172.17.0.1:7890

RUN sudo apt install -y zsh \
    && git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh \  
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && sed -i "s/robbyrussell/ys/" ~/.zshrc \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i "s/plugins=(git.*)$/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/" ~/.zshrc \
    && sudo usermod -s /bin/zsh developer

RUN sudo apt install -y net-tools openssh-server vim\ 
    && echo "set nu" >> ~/.vimrc


RUN git clone https://github.com/opencv/opencv.git && \
    cd /home/developer/opencv && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j"$(nproc)" && \
    sudo make install && \
    rm -rf /home/developer/opencv

RUN sudo apt autoremove \
    && sudo apt clean -y \
    && sudo rm -rf /var/lib/apt/lists/*

EXPOSE 22
ENTRYPOINT ["/bin/zsh"]
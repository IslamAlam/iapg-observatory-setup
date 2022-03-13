
sudo apt update && sudo apt upgrade -y

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    wget \
    curl \
    software-properties-common \
    gparted \
    tasksel
#sudo tasksel

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update --yes && \
    # - apt-get upgrade is run to patch known vulnerabilities in apt-get packages as
    #   the ubuntu base image is rebuilt too seldom sometimes (less than once a month)
    apt-get upgrade --yes && \
    apt-get install --yes --no-install-recommends \
    ca-certificates \
    fonts-liberation \
    locales \
    # - pandoc is used to convert notebooks to html files
    #   it's not present in arm64 ubuntu image, so we install it here
    pandoc \
    # - run-one - a wrapper script that runs no more
    #   than one unique  instance  of  some  command with a unique set of arguments,
    #   we use `run-one-constantly` to support `RESTARTABLE` option
    run-one \
    sudo \
    # - tini is installed as a helpful container entrypoint that reaps zombie
    #   processes and such of the actual executable we want to start, see
    #   https://github.com/krallin/tini#why-tini for details.
    tini \
    dialog \
    apt-utils \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

sudo apt update \
    && sudo apt install -y gnome-system-monitor zsh apt-transport-https git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

sudo apt update \
    # && sudo apt install -y tasksel \
    && sudo apt install -y openssh-server^ \
    && sudo apt install -y xubuntu-desktop^ \ 

USER=astronomer
#sudo adduser $USER
#sudo passwd $USER
export RESOURCES_PATH=./resources
bash $RESOURCES_PATH/tools/oh-my-zsh.sh
sudo bash $RESOURCES_PATH/tools/python-conda.sh




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

USER=astronomer
#sudo adduser $USER
#sudo passwd $USER
export RESOURCES_PATH=./resources
bash $RESOURCES_PATH/tools/oh-my-zsh.sh
sudo bash $RESOURCES_PATH/tools/python-conda.sh



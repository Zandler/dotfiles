#!/bin/bash

set -e

clone_repo() {
    git clone https://github.com/zandler/dotfiles ~/.dotfiles
}

exec_bootstrap() {
    cd $HOME/.dotfiles && ./bootstrap.sh
}



is_ubuntu() {
    if grep -q "ID=ubuntu" /etc/os-release; then 
        echo "Checked. OK "
        clone_repo
        exec_bootstrap
    else 
        echo "OS not ubuntu. exit. :/ "
    fi
}

header() {

    clear

    echo -e "${ORANGE}
     ###############################################
     #   Dotfiles / Linux                          #
     #   Author: Zandler <zandler@outlook.com>     #
     #   Version: 0.9                              #
     #   $(date +'%d/%m/%Y')                                # 
     ###############################################${ENDCOLOR}"

    sleep 5
    clear
}

header 
is_ubuntu
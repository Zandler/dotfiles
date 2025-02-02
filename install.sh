#!/bin/bash



clone_repo() {
    git clone https://github.com/zandler/dotfiles ~/.dotfiles
}

exec_bootstrap() {
    cd $HOME && ./dotfiles/bootstrap.sh
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
#!/bin/bash

check_command() {
    echo "Check if $1 is installed"

    if ! command -v $1 &> /dev/null; then 
        return 1
    else
        return 0
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

update_system() {
    echo -e "${CYAN}Update packages...${ENDCOLOR}"
    sudo apt update && sudo apt upgrade -y
}

dotbot_update() {
    echo -e "${ORANGE}
    Restore files with dotbot${ENDCOLOR}"
    sleep 3

    pushd "$DOTBOT_DIR" > /dev/null
    git submodule update --init --recursive
    popd > /dev/null
}

dotbot_restore() {
    echo -e "${CYAN} Restoring confg and files ${ENDCOLOR}"
    "$DOTBOT_DIR/bin/dotbot" -d "${BASEDIR}" -c "$BASEDIR/install.conf.yaml"
}

install_apt_packages() {
    
    SOFTWARES=(
        "build-essential"
        "gpg"
        "git"
        "vim"
        "zsh"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "curl"
        "htop"
        "net-tools"
        "tree"
        "wget"
        "python3-venv"
        "python3-pip"
        "fonts-jetbrains-mono"
        "eza"
        "kubecolor"
        )

    clear
   echo -e "${CYAN}
    #########################
    #  INSTALL APT PACKAGES #
    #########################${ENDCOLOR}"

    sleep 3

    for soft in "${SOFTWARES[@]}"; do 

        sudo apt install -y $soft
    done
    echo "Finish"

    sleep 3
}

install_snap_packages() {
    SOFTWARES=(
            "kubectx"
            "terraform"
            "helix"
            "helm"
            "k9s"
            "aws-cli"
            "terragrunt"
            "dotnet-sdk --channel=lts/stable"
            "httpie"
            "k6"
            "astral-uv"
            )

        clear
    echo -e "${CYAN}
        ##########################
        #  INSTALL SNAP PACKAGES #
        ##########################${ENDCOLOR}"

        sleep 3

        for soft in "${SOFTWARES[@]}"; do 

            sudo snap install $soft --classic
        done
        echo "Finish"

        sleep 3
}

install_nvm() {
    clear 

    echo -e "${CYAN}
    ######################
    #  NODE + NPM + YARN #
    ######################${ENDCOLOR}"

    sleep 3

    # Verifica se o diretório do NVM existe
    if [ ! -d "/home/"${HOME}"/.nvm" ]; then
        echo "Install NVM..."
        # Instala o NVM
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

        # Configura o NVM no arquivo .bashrc se não estiver configurado
        if ! grep -q 'export NVM_DIR="$HOME/.nvm"' "$HOME/.bashrc"; then
            echo 'Configurando NVM no .bashrc...'
            echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.bashrc"
            echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> "$HOME/.bashrc"
            echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> "$HOME/.bashrc"
        fi

        # Carrega o NVM no ambiente atual
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

        echo "${PURPLE}NVM installed.${ENDCOLOR}"
        sleep 3
        # Instala versão LTS node
        nvm install node
        # Instala versão mais atual npm
        nvm install-latest-npm

       source "$HOME/.zshrc"
    else
        echo "NVM already installed"
    fi

    echo "Node step finish"
}

# TODO: Craate for loop
install_npm_packages() {

    npm install -g autoprefixer postcss-cli
    npm install -g markdown-link-check
    npm install -g standard
    npm install -g yarn 
    npm install -g @astrojs/language-server
    npm install -g bash-language-server
    npm install -g vscode-langservers-extracted
    npm install -g dockerfile-language-server-nodejs
    npm install -g sql-language-server
    npm install -g @tailwindcss/language-server
    npm install -g typescript typescript-language-server
    npm install -g vscode-langservers-extracted@4.8
    npm install -g yaml-language-server@next
    npm install -g pyright
    npm install -g @microsoft/compose-language-service
    npm install -g dockerfile-language-server-nodejs
    npm i -g vscode-langservers-extracted
    npm i -g yaml-language-server@next
}

oh-my-zsh() {
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 
}

starship() {
    curl -sS https://starship.rs/install.sh | sh
}

zsh_plugins() {
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $HOME/.oh-my-zsh/plugins/zsh-autocomplete
}

config_terminal() {
    echo "###################
    # Config terminal # 
    ###################"

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh-my-zsh not found, installing..."
        oh-my-zsh 
        zsh_plugins
    fi

    starship
    chsh -s $(which zsh)
    dotbot_update
    dotbot_restore
}

install_docker() {
    clear 

    echo -e "${PURPLE}
    ######################
    #  Instalacao Docker #
    ######################${ENDCOLOR}"

    sleep 3

    echo "🐋 Verificando Docker"
    # Verifica se o Docker está instalado
    if ! command -v docker &> /dev/null; then
        echo "Instalando Docker..."
        # Atualiza os pacotes existentes
        sudo apt update

        # Instala as dependências necessárias para adicionar repositórios via HTTPS
        sudo apt install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common

        # Adiciona a chave GPG oficial do Docker
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        # Adiciona o repositório estável do Docker
        sudo add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) \
            stable"

        # Instala o Docker Engine
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io

        # Adiciona o usuário atual ao grupo docker para não precisar usar sudo
        sudo usermod -aG docker $USER

        # Inicia o serviço como sudo para validar 
         sudo service docker start

        echo "Docker instalado e configurado."
    else
        echo "Docker já está instalado."
    fi 
}


# Init Values for folders (dotfiles and dotbot)
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTBOT_DIR="$BASEDIR/dotbot"

# TODO: Create a option choice for SRE, frontend, backend
# If you dont need some thing , just comment e run again
header
update_system
install_apt_packages
install_snap_packages
install_nvm
install_docker
config_terminal
install_npm_packages

echo "SUCCESS. LOAD ZSH. ENJOY!!!!" 
sleep 3

zsh

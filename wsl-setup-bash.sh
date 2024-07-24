#!/bin/bash

ORANGE='\033[0;33m'
CYAN='\033[0;36m'
ENDCOLOR='\033[0m'

update() {
    clear
   echo -e "${ORANGE}
    ############################
    #  Atualizacao do sistema  #
    ############################${ENDCOLOR}"

    sudo apt update && sudo apt upgrade -y
}

install_software() {
    SOFTWARES=(
        "git"
        "vim"
        "zsh"
        "httpie"
        "curl"
        "htop"
        "net-tools"
        "tree"
        "wget"
        "dotnet-sdk-8.0"
        "dotnet-sdk-6.0"
        "python3-venv"
        "python3-pip"
        "fonts-jetbrains-mono"
    )
    clear
   echo -e "${PURPLE}
    ############################
    #  Instalacao de softwares #
    ############################${ENDCOLOR}"

    for soft in "${SOFTWARES[@]}"; do 

        sudo apt install -y $soft
    done
}

install_docker() {
    clear 

    echo -e "${PURPLE}
    ######################
    #  Instalacao Docker #
    ######################${ENDCOLOR}"

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

install_frontend() {
    clear 

    echo -e "${PURPLE}
    ######################
    #  NODE + NPM + YARN #
    ######################${ENDCOLOR}"

    # Verifica se o diretório do NVM existe
    if [ ! -d "/home/"${HOME}"/.nvm" ]; then
        echo "Instalando NVM..."
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

        echo "NVM instalado e configurado."

        # Instala versão LTS node
        nvm install node
        # Instala versão mais atual npm
        nvm install-latest-npm
        
        # Instala bibliotecas básicas
        npm install -g autoprefixer postcss-cli
        npm install -g markdown-link-check
        npm install -g standard
        npm install -g yarn 

        # Configura NEXUS do Bmg como repositorio principal 
        npm config set registry https://nexus-prd.bancobmg.com.br/repository/npm-public/

        source "$HOME/.bashrc"
    else
        echo "NVM já está instalado."
    fi
}

install_terminal() {
    clear 

    echo -e "${CYAN}
    #############################
    #  Configuracao do terminal #
    #############################${ENDCOLOR}"
    
    echo 'eval "$(starship init bash)" ' >> "$HOME/.bashrc"

    curl -sS https://starship.rs/install.sh | sh

    #source "/home/"${SUDO_USER}"/.bashrc"

    #mkdir -p "/home/"${SUDO_USER}"/.config"

    #starship preset tokyo-night -o "/home/"${SUDO_USER}"/.config/starship.toml"

    source "$HOME/.bashrc"
}

header() {

    clear

    echo -e "${ORANGE}
     ###############################################
     #   Banco Bmg                                 #
     #   Versão: 0.9                               #
     #   $(date +'%d/%m/%Y')                                #
     #  Script para configuracao do ambiente local # 
     ###############################################${ENDCOLOR}"

    #sleep 3

}


header
update
install_software
install_docker
install_terminal
install_frontend

source $HOME/.bashrc
#!/bin/bash

set -euo pipefail

# Colors
ORANGE='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
ENDCOLOR='\033[0m'

# Init Values for folders (dotfiles and dotbot)
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTBOT_DIR="$BASEDIR/dotbot"

log_info() {
    echo -e "${GREEN}[INFO]${ENDCOLOR} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${ENDCOLOR} $1" >&2
}

log_warning() {
    echo -e "${ORANGE}[WARNING]${ENDCOLOR} $1"
}

check_command() {
    command -v "$1" &> /dev/null
}

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                ubuntu|debian|pop)
                    echo "debian"
                    ;;
                fedora|centos|rhel|rocky|almalinux)
                    echo "redhat"
                    ;;
                arch|manjaro)
                    echo "arch"
                    ;;
                opensuse*)
                    echo "suse"
                    ;;
                *)
                    echo "unknown"
                    ;;
            esac
        else
            echo "unknown"
        fi
    else
        echo "unknown"
    fi
}

get_package_manager() {
    local os=$(detect_os)
    case "$os" in
        "macos")
            if check_command brew; then
                echo "brew"
            else
                echo "brew_missing"
            fi
            ;;
        "debian")
            echo "apt"
            ;;
        "redhat")
            if check_command dnf; then
                echo "dnf"
            elif check_command yum; then
                echo "yum"
            else
                echo "unknown"
            fi
            ;;
        "arch")
            echo "pacman"
            ;;
        "suse")
            echo "zypper"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

header() {
    clear
    local os=$(detect_os)
    local os_name="Linux"
    
    case "$os" in
        "macos")
            os_name="macOS"
            ;;
        "debian")
            os_name="Debian/Ubuntu"
            ;;
        "redhat")
            os_name="RedHat/Fedora"
            ;;
        "arch")
            os_name="Arch Linux"
            ;;
        "suse")
            os_name="openSUSE"
            ;;
        *)
            os_name="Unknown OS"
            ;;
    esac
    
    echo -e "${ORANGE}
     ###############################################
     #   Dotfiles / $os_name                       #
     #   Author: Zandler <zandler@outlook.com>     #
     #   Version: 1.0                              #
     #   $(date +'%d/%m/%Y')                       #
     ###############################################${ENDCOLOR}"
    echo
    sleep 2
}

update_system() {
    clear && log_info "Updating system packages..."
    local pkg_manager=$(get_package_manager)
    
    case "$pkg_manager" in
        "brew")
            brew update && brew upgrade
            ;;
        "apt")
            sudo apt update && sudo apt upgrade -y
            ;;
        "dnf")
            sudo dnf update -y
            ;;
        "yum")
            sudo yum update -y
            ;;
        "pacman")
            sudo pacman -Syu --noconfirm
            ;;
        "zypper")
            sudo zypper refresh && sudo zypper update -y
            ;;
        *)
            log_error "Unsupported package manager: $pkg_manager"
            return 1
            ;;
    esac
}

dotbot_update() {
    log_info "Updating dotbot submodules..."
    if [ -d "$DOTBOT_DIR" ]; then
        pushd "$DOTBOT_DIR" > /dev/null
        git submodule update --init --recursive
        popd > /dev/null
    else
        log_warning "Dotbot directory not found: $DOTBOT_DIR"
    fi
}

dotbot_restore() {
    log_info "Restoring config files with dotbot..."
    if [ -f "$BASEDIR/install.conf.yaml" ] && [ -x "$DOTBOT_DIR/bin/dotbot" ]; then
        "$DOTBOT_DIR/bin/dotbot" -d "${BASEDIR}" -c "$BASEDIR/install.conf.yaml"
    else
        log_error "Dotbot configuration or binary not found"
        return 1
    fi
}

install_system_packages() {
    clear && log_info "Installing system packages..."
    sleep 2
    local pkg_manager=$(get_package_manager)
    local os=$(detect_os)
    
    case "$os" in
        "macos")
            install_brew_packages
            ;;
        "debian")
            install_apt_packages
            ;;
        "redhat")
            install_dnf_packages
            ;;
        "arch")
            install_pacman_packages
            ;;
        "suse")
            install_zypper_packages
            ;;
        *)
            log_error "Unsupported operating system"
            return 1
            ;;
    esac
}

install_brew_packages() {
    local packages=(
        "git"
        "vim"
        "zsh"
        "curl"
        "htop"
        "tree"
        "wget"
        "python3"
        "font-jetbrains-mono"
        "eza"
        "kubecolor"
        "gnupg"
    )

    log_info "Installing Homebrew packages..."
    
    for package in "${packages[@]}"; do
        if ! brew list "$package" &> /dev/null; then
            log_info "Installing $package..."
            brew install "$package" || log_warning "Failed to install $package"
        else
            log_info "$package already installed"
        fi
    done
}

install_apt_packages() {
    local packages=(
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

    log_info "Installing APT packages..."
    
    for package in "${packages[@]}"; do
        if ! dpkg -l | grep -q "^ii  $package "; then
            log_info "Installing $package..."
            sudo apt install -y "$package" || log_warning "Failed to install $package"
        else
            log_info "$package already installed"
        fi
    done
}

install_dnf_packages() {
    local packages=(
        "@development-tools"
        "gnupg2"
        "git"
        "vim"
        "zsh"
        "curl"
        "htop"
        "net-tools"
        "tree"
        "wget"
        "python3"
        "python3-pip"
        "jetbrains-mono-fonts-all"
        "eza"
    )

    log_info "Installing DNF packages..."
    
    for package in "${packages[@]}"; do
        if ! rpm -q "$package" &> /dev/null; then
            log_info "Installing $package..."
            sudo dnf install -y "$package" || log_warning "Failed to install $package"
        else
            log_info "$package already installed"
        fi
    done
}

install_pacman_packages() {
    local packages=(
        "base-devel"
        "gnupg"
        "git"
        "vim"
        "zsh"
        "curl"
        "htop"
        "net-tools"
        "tree"
        "wget"
        "python"
        "python-pip"
        "ttf-jetbrains-mono"
        "eza"
    )

    log_info "Installing Pacman packages..."
    
    for package in "${packages[@]}"; do
        if ! pacman -Q "$package" &> /dev/null; then
            log_info "Installing $package..."
            sudo pacman -S --noconfirm "$package" || log_warning "Failed to install $package"
        else
            log_info "$package already installed"
        fi
    done
}

install_zypper_packages() {
    local packages=(
        "development-tools"
        "gpg2"
        "git"
        "vim"
        "zsh"
        "curl"
        "htop"
        "net-tools-deprecated"
        "tree"
        "wget"
        "python3"
        "python3-pip"
        "jetbrains-mono-fonts"
        "eza"
    )

    log_info "Installing Zypper packages..."
    
    for package in "${packages[@]}"; do
        if ! rpm -q "$package" &> /dev/null; then
            log_info "Installing $package..."
            sudo zypper install -y "$package" || log_warning "Failed to install $package"
        else
            log_info "$package already installed"
        fi
    done
}

install_snap_packages() {
    sleep 2
    clear && log_info "Installing Snap packages..."
    local packages=(
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

    if ! command -v snap &> /dev/null; then
        log_warning "Snap not available, skipping snap packages"
        return 0
    fi
    
    for package in "${packages[@]}"; do
        local package_name=$(echo "$package" | cut -d' ' -f1)
        if ! snap list | grep -q "$package_name"; then
            log_info "Installing $package..."
            sudo snap install $package --classic || log_warning "Failed to install $package"
        else
            log_info "$package_name already installed"
        fi
    done
}

install_nvm() {
    log_info "Setting up Node.js with NVM..."
    
    local nvm_dir="$HOME/.nvm"
    
    if [ ! -d "$nvm_dir" ]; then
        log_info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        
        # Load NVM
        export NVM_DIR="$nvm_dir"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        
        log_info "Installing Node.js LTS..."
        nvm install --lts
        nvm use --lts
        nvm alias default node
    else
        log_info "NVM already installed"
        export NVM_DIR="$nvm_dir"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
}

install_npm_packages() {
    local packages=(
        "autoprefixer"
        "postcss-cli"
        "markdown-link-check"
        "standard"
        "yarn"
        "@astrojs/language-server"
        "bash-language-server"
        "vscode-langservers-extracted"
        "dockerfile-language-server-nodejs"
        "sql-language-server"
        "@tailwindcss/language-server"
        "typescript"
        "typescript-language-server"
        "yaml-language-server@next"
        "pyright"
        "@microsoft/compose-language-service"
    )

    if ! check_command npm; then
        log_warning "npm not found, skipping npm packages"
        return 0
    fi

    log_info "Installing npm packages globally..."
    
    for package in "${packages[@]}"; do
        log_info "Installing $package..."
        npm install -g "$package" || log_warning "Failed to install $package"
    done
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "Oh My Zsh already installed"
    fi
}

install_starship() {
    if ! check_command starship; then
        log_info "Installing Starship prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    else
        log_info "Starship already installed"
    fi
}

install_zsh_plugins() {
    local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
    
    # Create plugins directory if it doesn't exist
    mkdir -p "$plugins_dir"
    
    # Define plugins using simple arrays instead of associative arrays
    local plugins=(
        "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions.git"
        "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "fast-syntax-highlighting:https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
        "zsh-autocomplete:https://github.com/marlonrichert/zsh-autocomplete.git"
    )
    
    for plugin in "${plugins[@]}"; do
        local name="${plugin%%:*}"
        local url="${plugin#*:}"
        local plugin_dir="$plugins_dir/$name"
        
        if [ ! -d "$plugin_dir" ]; then
            log_info "Installing zsh plugin: $name"
            git clone --depth 1 "$url" "$plugin_dir"
        else
            log_info "Zsh plugin $name already installed"
        fi
    done
}

config_terminal() {
    log_info "Configuring terminal..."
    
    install_oh_my_zsh
    install_zsh_plugins
    install_starship
    
    if check_command zsh; then
        log_info "Setting zsh as default shell..."
        sudo chsh -s "$(which zsh)" "$USER" || log_warning "Failed to change default shell"
    fi
    
    dotbot_update
    dotbot_restore
}

install_docker() {
    if check_command docker; then
        log_info "Docker already installed"
        return 0
    fi
    
    log_info "Installing Docker..."
    local os=$(detect_os)
    
    case "$os" in
        "macos")
            install_docker_macos
            ;;
        "debian")
            install_docker_debian
            ;;
        "redhat")
            install_docker_redhat
            ;;
        "arch")
            install_docker_arch
            ;;
        "suse")
            install_docker_suse
            ;;
        *)
            log_error "Docker installation not supported for this OS"
            return 1
            ;;
    esac
}

install_docker_macos() {
    log_info "Installing Docker Desktop for Mac..."
    if check_command brew; then
        brew install --cask docker || log_warning "Failed to install Docker Desktop"
        log_info "Docker Desktop installed. Please start it manually from Applications."
    else
        log_error "Homebrew not found. Please install Docker Desktop manually."
    fi
}

install_docker_debian() {
    # Install dependencies
    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    
    # Add Docker GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Add user to docker group
    sudo usermod -aG docker "$USER"
    
    # Start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker
    
    log_info "Docker installed successfully"
}

install_docker_redhat() {
    local pkg_manager=$(get_package_manager)
    
    # Install dependencies
    sudo "$pkg_manager" install -y yum-utils device-mapper-persistent-data lvm2
    
    # Add Docker repository
    sudo "$pkg_manager" config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    
    # Install Docker
    sudo "$pkg_manager" install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Add user to docker group
    sudo usermod -aG docker "$USER"
    
    # Start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker
    
    log_info "Docker installed successfully"
}

install_docker_arch() {
    # Install Docker
    sudo pacman -S --noconfirm docker
    
    # Add user to docker group
    sudo usermod -aG docker "$USER"
    
    # Start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker
    
    log_info "Docker installed successfully"
}

install_docker_suse() {
    # Add Docker repository
    sudo zypper addrepo https://download.docker.com/linux/centos/docker-ce.repo
    
    # Install Docker
    sudo zypper -n install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Add user to docker group
    sudo usermod -aG docker "$USER"
    
    # Start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker
    
    log_info "Docker installed successfully"
}

change_to_zsh() {
    if ! check_command zsh; then
        log_error "Zsh not installed"
        return 1
    fi
    
    local current_shell=$(getent passwd "$USER" | cut -d: -f7)
    local zsh_path=$(which zsh)
    
    if [ "$current_shell" = "$zsh_path" ]; then
        log_info "Zsh is already the default shell"
    else
        log_info "Changing default shell to zsh..."
        sudo chsh -s "$zsh_path" "$USER"
        log_info "Default shell changed to zsh. Please log out and log back in."
    fi
    
    log_info "Starting zsh session..."
    exec zsh
}

main() {
    header
    
    # Check if package manager is available
    local pkg_manager=$(get_package_manager)
    if [ "$pkg_manager" = "unknown" ] || [ "$pkg_manager" = "brew_missing" ]; then
        log_error "No supported package manager found"
        if [ "$pkg_manager" = "brew_missing" ]; then
            log_info "Please install Homebrew first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        fi
        exit 1
    fi
    
    update_system
    install_system_packages
    install_snap_packages
    install_nvm
    install_docker
    config_terminal
    install_npm_packages
    
    log_info "Bootstrap completed successfully!"
    change_to_zsh
}
# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
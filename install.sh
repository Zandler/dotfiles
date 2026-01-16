#!/bin/bash

#set -euo pipefail

# Colors
ORANGE='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ENDCOLOR='\033[0m'

# Configuration
REPO_URL="https://github.com/zandler/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

log_info() {
    echo -e "${GREEN}[INFO]${ENDCOLOR} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${ENDCOLOR} $1" >&2
}

check_dependencies() {
    clear && log_info "Checking dependencies..."
    sleep 2
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed. Installing"
        sudo apt update && sudo apt install -y git || {
            log_error "Failed to install Git"
            exit 1
        }

    fi
    log_info "Git is installed."
}

clone_repo() {
   clear && log_info "Cloning dotfiles repository..."
    
    if [ -d "$DOTFILES_DIR" ]; then
        log_info "Dotfiles directory already exists. Updating..."
        cd "$DOTFILES_DIR"
        git pull origin main || {
            log_error "Failed to update repository"
            exit 1
        }
    else
        git clone "$REPO_URL" "$DOTFILES_DIR" || {
            log_error "Failed to clone repository"
            exit 1
        }
    fi
}

exec_bootstrap() {
    log_info "Executing bootstrap script..."
    cd "$DOTFILES_DIR" || {
        log_error "Failed to change to dotfiles directory"
        exit 1
    }
    
    if [ ! -f "bootstrap.sh" ]; then
        log_error "bootstrap.sh not found in dotfiles directory"
        exit 1
    fi
    
    chmod +x bootstrap.sh
    ./bootstrap.sh || {
        log_error "Bootstrap script failed"
        exit 1
    }
}

is_ubuntu() {
    clear && log_info "Checking OS version..."
    if [ ! -f "/etc/os-release" ]; then
        log_error "Cannot determine OS version"
        exit 1
    fi
    
    if grep -q "ID=ubuntu" /etc/os-release; then
        log_info "Ubuntu detected. Proceeding with installation..."
        return 0
    else
        log_error "This script is designed for Ubuntu only"
        exit 1
    fi
}

header() {
    clear
    echo -e "${ORANGE}
     ###############################################
     #   Dotfiles / Linux                          #
     #   Author: Zandler <zandler@outlook.com>     #
     #   Version: 1.0                              #
     #   $(date +'%d/%m/%Y')                                #
     ###############################################${ENDCOLOR}"
    echo
    sleep 2
}

main() {
    header
    is_ubuntu
    check_dependencies
    clone_repo
    exec_bootstrap
    log_info "Installation completed successfully!"
}

main "$@"

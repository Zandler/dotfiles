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
        local pkg_manager=$(get_package_manager)
        
        case "$pkg_manager" in
            "brew")
                brew install git || {
                    log_error "Failed to install Git"
                    exit 1
                }
                ;;
            "apt")
                sudo apt update && sudo apt install -y git || {
                    log_error "Failed to install Git"
                    exit 1
                }
                ;;
            "dnf")
                sudo dnf install -y git || {
                    log_error "Failed to install Git"
                    exit 1
                }
                ;;
            "yum")
                sudo yum install -y git || {
                    log_error "Failed to install Git"
                    exit 1
                }
                ;;
            "pacman")
                sudo pacman -S --noconfirm git || {
                    log_error "Failed to install Git"
                    exit 1
                }
                ;;
            "zypper")
                sudo zypper install -y git || {
                    log_error "Failed to install Git"
                    exit 1
                }
                ;;
            *)
                log_error "Unsupported package manager for Git installation"
                exit 1
                ;;
        esac
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
            if command -v brew &> /dev/null; then
                echo "brew"
            else
                echo "brew_missing"
            fi
            ;;
        "debian")
            echo "apt"
            ;;
        "redhat")
            if command -v dnf &> /dev/null; then
                echo "dnf"
            elif command -v yum &> /dev/null; then
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

check_supported_os() {
    clear && log_info "Checking OS compatibility..."
    local os=$(detect_os)
    local pkg_manager=$(get_package_manager)
    
    if [ "$os" = "unknown" ]; then
        log_error "Unsupported operating system"
        exit 1
    fi
    
    if [ "$pkg_manager" = "unknown" ] || [ "$pkg_manager" = "brew_missing" ]; then
        log_error "No supported package manager found"
        if [ "$pkg_manager" = "brew_missing" ]; then
            log_info "Please install Homebrew first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        fi
        exit 1
    fi
    
    local os_name="Unknown"
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
    esac
    
    log_info "$os_name detected with $pkg_manager package manager. Proceeding with installation..."
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

main() {
    header
    check_supported_os
    check_dependencies
    clone_repo
    exec_bootstrap
    log_info "Installation completed successfully!"
}

main "$@"

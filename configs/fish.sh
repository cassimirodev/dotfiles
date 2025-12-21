#!/bin/bash

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[ZSH-SETUP]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }

if ! command -v zsh &> /dev/null; then
    warn "Zsh não encontrado! Certifique-se de rodar o instalador de apps primeiro."
    exit 1
fi

OMZ_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$OMZ_DIR" ]; then
    log "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    log "Oh My Zsh já está instalado."
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    log "Baixando Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    log "Powerlevel10k já baixado."
fi

ZSH_PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
    log "Baixando zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    log "Baixando zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%s)"

log "Aplicando configurações no .zshrc..."

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' "$HOME/.zshrc"

sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' "$HOME/.zshrc"

log "Configuração do ZSH concluída!"
warn "Abra um novo terminal e digite 'p10k configure' para terminar de ajustar o visual."
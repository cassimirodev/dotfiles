#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

log() {
    echo -e "${GREEN}[SETUP]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[ATENÇÃO]${NC} $1"
}

log "Iniciando setup. Atualizando lista de pacotes e sistema..."
sudo apt update -y && sudo apt upgrade -y

log "Iniciando instalação do git"

if command -v git &> /dev/null
then
    log "O Git está instalado"
else
    warn "O Git não está instalado."
    sudo apt install git -y
fi

log "Iniciando configuração."

git config --global user.name "cassimirodev"
git config --global user.email "luiseduardocass06@gmail.com"
git config --global init.defaultBranch main

log "Instalação do git completa."
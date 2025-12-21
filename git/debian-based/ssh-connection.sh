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


log "Inicando geração de chave SSH."
ssh-keygen -t ed25519 -C "luiseduardocass06@gmail.com"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

log "ADICIONE ESTA CHAVE NO GITHUB"
cat ~/.ssh/id_ed25519.pub


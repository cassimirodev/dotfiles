#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
EMAIL="luiseduardocass06@gmail.com"
KEY_FILE="$HOME/.ssh/id_ed25519"

log() {
    echo -e "${GREEN}[SETUP]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[ATENÇÃO]${NC} $1"
}


if [ -f "$KEY_FILE" ]; then
    warn "[AVISO] Uma chave SSH já existe em $KEY_FILE."
    warn "[AVISO] Pulando geração para não sobrescrever sua chave atual."
else
    echo "[SETUP] Gerando nova chave SSH..."
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_FILE"
    
    eval "$(ssh-agent -s)"
    ssh-add "$KEY_FILE"
    
    echo "--- CHAVE PÚBLICA (Copie e cole no GitHub) ---"
    cat "$KEY_FILE.pub"
    echo "----------------------------------------------"
fi

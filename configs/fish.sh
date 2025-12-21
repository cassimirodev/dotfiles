#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${GREEN}[FISH-SETUP]${NC} $1"; }

if ! command -v fish &> /dev/null; then
    echo "Fish não encontrado. Pulando configuração."
    exit 0
fi

log "Configurando Fish Shell..."

fish -c "
    if not functions -q fisher
        echo 'Instalando Fisher...'
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    end

    echo 'Instalando Plugins (Tide Theme, Autopair)...'
    # Tide é um tema moderno parecido com Powerlevel10k, mas pro Fish
    fisher install IlanCosman/tide@v6
    fisher install jorgebucaran/autopair.fish
    
    echo 'Atualizando plugins...'
    fisher update
"

log "Configuração do Fish concluída."
#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[FONTS]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE_DIR="$SCRIPT_DIR/fonts/ttf"
TARGET_DIR="$HOME/.local/share/fonts"

log "Iniciando instalação de fontes..."

if [ ! -d "$SOURCE_DIR" ]; then
    warn "Diretório de origem não encontrado: $SOURCE_DIR"
    warn "Sua estrutura de pastas está errada. O script espera: assets/fonts/ttf/*.ttf"
    exit 1
fi

mkdir -p "$TARGET_DIR"

log "Copiando arquivos de $SOURCE_DIR para $TARGET_DIR..."

COUNT=$(ls "$SOURCE_DIR"/*.ttf 2>/dev/null | wc -l)

if [ "$COUNT" -eq 0 ]; then
    warn "Nenhum arquivo .ttf encontrado na pasta de origem!"
    exit 1
fi

cp "$SOURCE_DIR"/*.ttf "$TARGET_DIR"

log "Foram copiados $COUNT arquivos."

log "Atualizando cache de fontes do Linux..."
fc-cache -fv "$TARGET_DIR" > /dev/null

log "Instalação de fontes concluída com sucesso."
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

log "Instalando Git, Curl, Flatpak e ferramentas de build..."

log "Adicionando repositório Flathub..."

log "Preparando instalação do Node.js (LTS)..."

log "Instalando Node.js..."

log "Instalando OpenJDK 17..."

log "Instalando aplicações de usuário via Flatpak (Isso vai demorar)..."

# Caso eu precise adicionar novos aplicativos, basta pegar o ID no flathub
APPS=(
    "com.spotify.Client"
    "com.discordapp.Discord"
    "com.getpostman.Postman"
    "com.jetbrains.IntelliJ-IDEA-Ultimate"
    "com.jetbrains.DataGrip"
    "io.dbeaver.DBeaverCommunity"
)

for app in "${APPS[@]}"; do
    log "Instalando $app..."
    flatpak install flathub "$app" -y
done

log "Realizando limpeza de pacotes desnecessários..."
sudo apt autoremove -y
sudo apt clean

log "Setup concluído com sucesso."
warn "Recomendado reiniciar a sessão para que as variáveis de ambiente sejam carregadas corretamente."
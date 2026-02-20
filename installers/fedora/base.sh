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
sudo dnf update -y

log "Instalando Git, Curl, Flatpak e ferramentas de build..."
sudo dnf install -y git curl flatpak gcc gcc-c++ make openssl-devel

log "Adicionando repositório Flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

log "Preparando instalação do Node.js (LTS)..."
sudo dnf remove -y nodejs npm
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
log "Instalando Node.js..."
sudo dnf install -y nodejs

log "Instalando OpenJDK 17..."
sudo dnf install -y java-17-openjdk java-17-openjdk-devel

log "Instalando Visual Studio Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update 2>/dev/null
sudo dnf install -y code

log "Instalando aplicações de usuário via Flatpak (Isso vai demorar)..."

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
    sudo flatpak install flathub "$app" -y
done

log "Realizando limpeza de pacotes desnecessários..."
sudo dnf autoremove -y
sudo dnf clean all

log "Setup concluído com sucesso."
warn "Recomendado reiniciar a sessão para que as variáveis de ambiente sejam carregadas corretamente."

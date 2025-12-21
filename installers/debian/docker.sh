#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${GREEN}[DOCKER]${NC} $1"; }

log "Removendo versões antigas ou conflitantes..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove $pkg -y 2>/dev/null
done

log "Instalando dependências para o repositório..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl

log "Adicionando a chave GPG oficial do Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

DISTRO_CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")

log "Adicionando repositório (Versão: $DISTRO_CODENAME)..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $DISTRO_CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

log "Instalando Docker Engine, CLI e Compose..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

log "Adicionando o usuário '$USER' ao grupo docker..."
sudo usermod -aG docker "$USER"

log "Instalação concluída!"
echo -e "${GREEN}[IMPORTANTE]${NC} Você precisa fazer LOGOFF e LOGIN novamente para o grupo 'docker' funcionar."
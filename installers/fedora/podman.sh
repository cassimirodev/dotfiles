#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[PODMAN]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }

log "Removendo versões conflitantes do Docker (se existirem)..."
for pkg in docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine moby-engine; do
    sudo dnf remove $pkg -y 2>/dev/null
done

log "Instalando Podman e ferramentas relacionadas..."
sudo dnf install -y podman podman-compose podman-docker

log "Habilitando suporte rootless para Podman..."
if ! grep -q "^$USER:" /etc/subuid; then
    log "Configurando subuid para $USER..."
    echo "$USER:100000:65536" | sudo tee -a /etc/subuid > /dev/null
fi

if ! grep -q "^$USER:" /etc/subgid; then
    log "Configurando subgid para $USER..."
    echo "$USER:100000:65536" | sudo tee -a /etc/subgid > /dev/null
fi

log "Habilitando e iniciando serviço Podman socket (para compatibilidade Docker API)..."
systemctl --user enable --now podman.socket

log "Criando alias docker -> podman para compatibilidade..."
mkdir -p "$HOME/.config/fish/conf.d" 2>/dev/null
echo "# Alias Podman para Docker" > "$HOME/.config/fish/conf.d/podman.fish"
echo "alias docker='podman'" >> "$HOME/.config/fish/conf.d/podman.fish"
echo "alias docker-compose='podman-compose'" >> "$HOME/.config/fish/conf.d/podman.fish"

mkdir -p "$HOME/.oh-my-zsh/custom" 2>/dev/null
echo "# Alias Podman para Docker" > "$HOME/.oh-my-zsh/custom/podman.zsh"
echo "alias docker='podman'" >> "$HOME/.oh-my-zsh/custom/podman.zsh"
echo "alias docker-compose='podman-compose'" >> "$HOME/.oh-my-zsh/custom/podman.zsh"

if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "alias docker='podman'" "$HOME/.bashrc"; then
        echo "" >> "$HOME/.bashrc"
        echo "# Alias Podman para Docker" >> "$HOME/.bashrc"
        echo "alias docker='podman'" >> "$HOME/.bashrc"
        echo "alias docker-compose='podman-compose'" >> "$HOME/.bashrc"
    fi
fi

log "Testando instalação do Podman..."
podman --version

log "Instalação do Podman concluída!"
warn "O Podman está configurado em modo rootless (sem sudo)."
warn "Use 'podman' ou o alias 'docker' para rodar containers."
echo -e "${GREEN}[INFO]${NC} Exemplo: podman run hello-world"

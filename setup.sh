#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[SETUP-MASTER]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERRO]${NC} $1"; }

log "Concedendo permissões de execução aos scripts..."
find . -name "*.sh" -exec chmod +x {} \;

log "Detectando sistema..."

if [ -f /etc/debian_version ]; then
    DISTRO="debian"
    info "Sistema Debian/Ubuntu detectado."

    log "Iniciando instalação do Docker..."
    ./installers/debian/docker.sh

    log "Iniciando instalação de Apps e Dependências..."
    ./installers/debian/base.sh

elif [ -f /etc/arch-release ]; then
    DISTRO="arch"
    warn "Sistema Arch Linux detectado (Não implementado)."
else
    error "Sistema não suportado."
    exit 1
fi


log "Iniciando configurações universais..."

./assets/install.sh

./configs/git.sh
./configs/ssh.sh


echo -e "\n${BLUE}--- SELEÇÃO DE SHELL ---${NC}"
echo "Qual terminal você deseja configurar como padrão?"
echo "  1) Zsh + Powerlevel10k (Padrão da indústria, robusto)"
echo "  2) Fish + Tide (Moderno, autosuggestions nativo, rápido)"
echo "  3) Nenhum (Manter o atual/Bash)"
echo -n "Digite sua escolha [1-3]: "
read SHELL_OPT

case $SHELL_OPT in
    1)
        log "Você escolheu Zsh."
        if [ "$DISTRO" == "debian" ]; then 
            log "Instalando pacote zsh..."
            sudo apt install -y zsh
        fi
        
        ./configs/zsh.sh
        
        log "Definindo Zsh como shell padrão..."
        sudo chsh -s "$(which zsh)" "$USER"
        ;;
        
    2)
        log "Você escolheu Fish."
        if [ "$DISTRO" == "debian" ]; then 
            log "Instalando pacote fish..."
            sudo apt-add-repository ppa:fish-shell/release-3 -y 2>/dev/null
            sudo apt update 2>/dev/null
            sudo apt install -y fish
        fi
        
        ./configs/fish.sh
        
        log "Definindo Fish como shell padrão..."
        sudo chsh -s "$(which fish)" "$USER"
        ;;
        
    3)
        info "Mantendo o shell atual (provavelmente Bash). Nenhuma alteração feita."
        ;;
        
    *)
        warn "Opção inválida. Pulando configuração de shell."
        ;;
esac

log "Setup Finalizado!"
warn "Se você trocou o shell ou instalou o Docker, faça LOGOUT e LOGIN novamente."

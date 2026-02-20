#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[ZRAM]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

log "Configurando ZRAM para swap comprimido..."

if [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
elif [ -f /etc/arch-release ]; then
    DISTRO="arch"
else
    warn "Sistema não reconhecido. Tentando instalação genérica..."
    DISTRO="generic"
fi

case $DISTRO in
    fedora)
        log "Sistema Fedora detectado. Instalando zram-generator..."
        sudo dnf install -y zram-generator-defaults
        
        log "Configurando zram-generator..."
        sudo mkdir -p /etc/systemd/zram-generator.conf.d
        
        sudo tee /etc/systemd/zram-generator.conf.d/custom.conf > /dev/null << 'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
EOF
        
        log "Reiniciando systemd-zram-setup@zram0.service..."
        sudo systemctl daemon-reload
        sudo systemctl restart systemd-zram-setup@zram0.service 2>/dev/null || sudo systemctl start systemd-zram-setup@zram0.service
        ;;
        
    debian)
        log "Sistema Debian/Ubuntu detectado. Instalando zram-tools..."
        sudo apt update
        sudo apt install -y zram-tools
        
        log "Configurando zram-tools..."
        # Configurar porcentagem de RAM para zram (50%)
        sudo sed -i 's/#PERCENTAGE=.*/PERCENTAGE=50/' /etc/default/zramswap 2>/dev/null || \
            echo "PERCENTAGE=50" | sudo tee -a /etc/default/zramswap > /dev/null
        
        # Usar algoritmo de compressão zstd
        sudo sed -i 's/#ALGO=.*/ALGO=zstd/' /etc/default/zramswap 2>/dev/null || \
            echo "ALGO=zstd" | sudo tee -a /etc/default/zramswap > /dev/null
        
        log "Reiniciando serviço zramswap..."
        sudo systemctl restart zramswap
        sudo systemctl enable zramswap
        ;;
        
    arch)
        log "Sistema Arch Linux detectado. Instalando zram-generator..."
        sudo pacman -S --noconfirm zram-generator
        
        log "Configurando zram-generator..."
        sudo mkdir -p /etc/systemd/zram-generator.conf.d
        
        sudo tee /etc/systemd/zram-generator.conf.d/custom.conf > /dev/null << 'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
EOF
        
        log "Reiniciando systemd-zram-setup@zram0.service..."
        sudo systemctl daemon-reload
        sudo systemctl restart systemd-zram-setup@zram0.service 2>/dev/null || sudo systemctl start systemd-zram-setup@zram0.service
        ;;
        
    *)
        warn "Instalação genérica - você pode precisar instalar manualmente."
        info "Tente: sudo apt install zram-tools (Debian) ou sudo dnf install zram-generator (Fedora)"
        exit 1
        ;;
esac

log "Verificando status do ZRAM..."
echo ""
if command -v zramctl &> /dev/null; then
    sudo zramctl
else
    info "Dispositivos zram ativos:"
    ls -la /dev/zram* 2>/dev/null || warn "Nenhum dispositivo zram encontrado ainda."
    echo ""
    info "Uso de swap:"
    swapon --show
fi

echo ""
log "Configuração do ZRAM concluída!"
info "O ZRAM usa compressão para criar swap na RAM, melhorando a performance."
info "Tamanho configurado: 50% da RAM disponível com compressão zstd."

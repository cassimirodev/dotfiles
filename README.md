# 🔧 Dotfiles

Configuração automatizada de ambiente de desenvolvimento para sistemas Linux (Debian/Ubuntu).

## 📋 Descrição

Este projeto fornece um conjunto de scripts para configurar rapidamente um ambiente de desenvolvimento completo em sistemas Debian/Ubuntu. Ele automatiza a instalação de ferramentas essenciais, configura shells modernos (Zsh ou Fish), instala Docker, e aplica configurações personalizadas para Git e SSH.

## ✨ Recursos

- 🐳 **Docker**: Instalação automática do Docker Engine, CLI e Docker Compose
- 🖥️ **Shells Modernos**: 
  - Zsh com Oh My Zsh e Powerlevel10k
  - Fish com Fisher e Tide theme
- 🔧 **Ferramentas de Desenvolvimento**:
  - Git com configurações pré-definidas
  - Node.js (LTS)
  - Build essentials e bibliotecas SSL
  - Curl e outras ferramentas úteis
- 📦 **Gerenciamento de Pacotes**: Flatpak e Flathub
- 🔐 **Configuração SSH**: Scripts para setup de SSH
- 🎨 **Fontes Personalizadas**: Instalação automática de fontes TTF

## 📦 Pré-requisitos

- Sistema operacional Debian/Ubuntu (ou derivados)
- Acesso root/sudo
- Conexão com a internet

## 🚀 Instalação

### Instalação Rápida

```bash
git clone https://github.com/cassimirodev/dotfiles.git
cd dotfiles
chmod +x setup.sh
./setup.sh
```

### O que acontece durante a instalação?

1. **Detecção de Sistema**: O script detecta automaticamente seu sistema operacional
2. **Instalação do Docker**: Configura o Docker Engine e adiciona seu usuário ao grupo docker
3. **Instalação de Dependências**: Instala Git, Node.js, build tools, e outras ferramentas essenciais
4. **Configuração de Fontes**: Instala fontes personalizadas do diretório `assets/fonts/ttf`
5. **Configuração Git**: Define nome de usuário, email e preferências globais
6. **Configuração SSH**: Executa scripts de configuração SSH
7. **Seleção de Shell**: Permite escolher entre Zsh, Fish ou manter o shell atual

### Opções de Shell

Durante a instalação, você poderá escolher um dos seguintes shells:

#### 1. Zsh + Powerlevel10k (Recomendado)
- Shell robusto e amplamente usado
- Oh My Zsh para gerenciamento de plugins
- Tema Powerlevel10k para interface visual rica
- Ideal para quem busca estabilidade e ecossistema maduro

#### 2. Fish + Tide
- Shell moderno com autosugestões nativas
- Configuração mais simples
- Sintaxe mais amigável
- Fisher para gerenciamento de plugins
- Tema Tide (similar ao Powerlevel10k)

#### 3. Nenhum
- Mantém o shell atual (geralmente Bash)
- Nenhuma modificação é feita

## 📁 Estrutura do Projeto

```
dotfiles/
├── setup.sh              # Script principal de instalação
├── assets/
│   ├── install.sh        # Instalação de fontes
│   └── fonts/            # Fontes personalizadas (TTF)
├── configs/
│   ├── git.sh           # Configurações do Git
│   ├── ssh.sh           # Configurações do SSH
│   ├── zsh.sh           # Setup do Zsh
│   └── fish.sh          # Setup do Fish
└── installers/
    └── debian/
        ├── base.sh      # Instalação de pacotes base
        └── docker.sh    # Instalação do Docker
```

## 🔧 Uso

### Executar o Setup Completo

```bash
./setup.sh
```

### Executar Scripts Individuais

Se você deseja executar apenas partes específicas da configuração:

```bash
# Instalar apenas o Docker
./installers/debian/docker.sh

# Configurar apenas o Git
./configs/git.sh

# Configurar apenas o Zsh
./configs/zsh.sh

# Configurar apenas o Fish
./configs/fish.sh

# Instalar apenas as fontes
./assets/install.sh
```

## ⚠️ Pós-Instalação

Após a instalação, é **importante** realizar logout e login novamente para que:
- O grupo Docker seja aplicado corretamente ao seu usuário
- O novo shell padrão seja ativado (se você escolheu Zsh ou Fish)

```bash
# Faça logout e login novamente, ou reinicie a sessão
exit
```

## 🛠️ Personalização

### Modificar Configurações do Git

Edite o arquivo `configs/git.sh` para alterar:
- Nome de usuário
- Email
- Editor padrão
- Outras preferências do Git

### Adicionar Suas Próprias Fontes

Coloque arquivos `.ttf` no diretório `assets/fonts/ttf/` antes de executar o script.

### Adicionar Mais Pacotes

Edite `installers/debian/base.sh` para incluir pacotes adicionais na instalação.

## 🐛 Solução de Problemas

### Erro de permissão ao executar Docker

Se você receber erros de permissão ao tentar usar o Docker:
```bash
# Verifique se você está no grupo docker
groups

# Se não estiver, adicione-se manualmente
sudo usermod -aG docker $USER

# Faça logout e login novamente
```

### Shell não mudou após instalação

Certifique-se de ter feito logout e login novamente após a instalação.

### Fontes não aparecem

Execute manualmente o cache de fontes:
```bash
fc-cache -fv
```

## 📝 Notas

- Este projeto está configurado para o usuário `cassimirodev` por padrão. **Antes de usar, edite `configs/git.sh`** para ajustar seu nome de usuário e email do Git.
- O suporte para Arch Linux está planejado mas ainda não implementado.
- Alguns pacotes requerem confirmação durante a instalação.

## 🤝 Contribuindo

Sinta-se à vontade para abrir issues ou enviar pull requests com melhorias!

## 📄 Licença

Este projeto é de código aberto e está disponível sob os termos que você escolher.

## 🙏 Créditos

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Fish Shell](https://fishshell.com/)
- [Fisher](https://github.com/jorgebucaran/fisher)
- [Tide](https://github.com/IlanCosman/tide)

---

Desenvolvido por [cassimirodev](https://github.com/cassimirodev)

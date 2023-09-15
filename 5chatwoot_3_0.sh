#!/bin/bash

# Mostra o banner.sh
cat banner.sh

# Atualiza e atualiza o sistema
sudo apt update -y && sudo apt upgrade -y

# Baixa o instalador do Chatwoot
wget https://get.chatwoot.app/linux/install.sh

# Dá permissões de execução ao script de instalação
chmod +x install.sh

# Executa o script de instalação do Chatwoot
./install.sh --install

# Retorna para o instalador.sh
exec ./instalador.sh

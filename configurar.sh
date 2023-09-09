#!/bin/bash

# Função para exibir o banner do arquivo banner.sh
display_banner() {
  clear
  if [ -f banner.sh ]; then
    source banner.sh
  else
    echo "Banner não encontrado. Verifique se o arquivo banner.sh está na mesma pasta."
  fi
  sleep 3  # Tempo de exibição do banner (3 segundos)
}

# Exibe o banner informativo
display_banner

# Configuração automática da timezone para São Paulo
echo "Configurando a timezone para São Paulo..."
echo "America/Sao_Paulo" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata
echo "Timezone configurada para 'America/Sao_Paulo'."

# Atualização do sistema
echo "Atualizando o sistema..."
sudo apt update -qq
sudo apt -y upgrade -qq
echo "Sistema atualizado com sucesso."

# Instalação de pacotes
echo "Instalando pacotes..."
{
  curl -sSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt-get install -y nodejs
  echo "Node.js instalado com sucesso."

  npm install -g npm@latest
  echo "NPM atualizado com sucesso."

  npm install -g pm2@latest
  echo "PM2 instalado com sucesso."

  sudo apt-get install -y git zip unzip nload snapd curl wget sudo
  echo "Pacotes adicionais instalados com sucesso."
} > /dev/null 2>&1

# Verifica se as operações foram bem-sucedidas
if [ $? -eq 0 ]; then
  echo "Todas as operações foram concluídas com sucesso."
else
  echo "Erro durante a execução das operações."
fi

# Retorna ao instalador.sh
exit 0

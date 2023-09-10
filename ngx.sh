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

# Função para verificar e instalar dependências
function verificar_e_instalar_dependencias() {
  local dependencia="$1"
  if ! command -v "$dependencia" &>/dev/null; then
    echo "$dependencia não encontrado. Instalando..."
    if [ "$dependencia" == "docker" ]; then
      sudo apt update -y
      sudo apt install -y docker.io
    elif [ "$dependencia" == "docker-compose" ]; then
      sudo apt update -y
      sudo apt install -y docker-compose
    else
      echo "Dependência desconhecida: $dependencia. Por favor, instale manualmente."
      exit 1
    fi
  fi
}

# Verificar e instalar dependências
verificar_e_instalar_dependencias "docker"
verificar_e_instalar_dependencias "docker-compose"

# Criar a pasta 'ngx' no diretório atual
echo "Criando a pasta 'ngx'..."
mkdir -p ngx

# Navegar até a pasta 'ngx'
cd ngx

# Criar o arquivo 'docker-compose.yml' com as informações inseridas
echo "Criando o arquivo 'docker-compose.yml'..."
cat <<EOL >docker-compose.yml
version: '3.3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    volumes:
      - npm_data:/data
      - npm_letsencrypt:/etc/letsencrypt
    ports:
      # These ports are in format <host-port>:<container-port>
      - '81:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == manager
      resources:
        limits:
          cpus: "0.1"
          memory: 256M
    networks:
      - npm_public
volumes:
  npm_data:
    external: true
  npm_letsencrypt:
    external: true

networks:
  npm_public:
    external: true
EOL

# Executar docker-compose
echo "Executando 'docker-compose up -d'..."
docker-compose up -d

if [ $? -eq 0 ]; then
  echo "Nginx Proxy Manager foi iniciado com sucesso!"
else
  echo "Erro ao iniciar o Nginx Proxy Manager. Verifique as dependências e tente novamente."
fi

# Voltar para o instalador.sh
exec ./instalador.sh

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

# Função para verificar se o usuário é root (sudo)
check_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root (sudo)." 
    exit 1
  fi
}

# Função para instalar Docker e Docker Compose
install_docker() {
  curl -fsSL https://get.docker.com | sh && \
  sudo usermod -aG docker $USER && \
  sudo apt-get install docker-compose -y
}

# Função para atualizar o sistema e instalar dependências
update_and_install() {
  apt update
  apt upgrade -y
  apt install -y curl sqlite3 docker.io docker-compose ufw
}

# Função para criar diretórios e rede Docker
setup_directories_and_network() {
  mkdir -p /opt/nginxproxymanager/databases
  touch /opt/nginxproxymanager/databases/nginxproxy.db

  if ! docker network inspect nginxproxyman &>/dev/null; then
      docker network create nginxproxyman
  fi
}

# Função para criar arquivo docker-compose.yml
create_docker_compose_file() {
  cat > /opt/nginxproxymanager/docker-compose.yml <<EOL
version: '3.7'
services:
  proxy:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    networks:
      - proxy_manager
networks:
  proxy_manager:
EOL
}

# Função para iniciar Nginx Proxy Manager
start_nginx_proxy_manager() {
  cd /opt/nginxproxymanager
  docker-compose up -d
  echo "Nginx Proxy Manager instalado e configurado com sucesso."
}

# Função principal
main() {
  check_root
  install_docker
  update_and_install
  setup_directories_and_network
  create_docker_compose_file
  start_nginx_proxy_manager

  # Exiba os contêineres em execução
  sudo docker ps -a

  echo "A instalação do Nginx Proxy Manager foi concluída. Acesse http://SEU_IP_SERVER/ para configurá-lo."
  echo "Use o seguinte login inicial:"
  echo "Email: admin@example.com"
  echo "Senha: changeme"
}

# Chama a função principal
main

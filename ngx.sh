#!/bin/bash


curl -fsSL https://get.docker.com | sh && \
sudo usermod -aG docker $USER && \
sudo apt-get install docker-compose -y


# Verifica se o script está sendo executado como root (sudo)
if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root (sudo)." 
    exit 1
fi

# Atualiza o sistema
apt update
apt upgrade -y

# Instala dependências
apt install -y curl sqlite3 docker.io docker-compose ufw

# Cria diretórios
mkdir -p /opt/nginxproxymanager/databases
touch /opt/nginxproxymanager/databases/nginxproxy.db

# Cria a rede Docker nginxproxyman se não existir
if ! docker network inspect nginxproxyman &>/dev/null; then
    docker network create nginxproxyman
fi

# Cria arquivo docker-compose.yml
cat > /opt/nginxproxymanager/docker-compose.yml <<EOL
version: '3.7'
services:
  
  proxy:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: nginx-poxymanager
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
      name: proxy_manager
          
    
# Inicia Nginx Proxy Manager
cd /opt/nginxproxymanager
docker-compose up -d

echo "Nginx Proxy Manager instalado e configurado com sucesso."


# Exiba os contêineres em execução
sudo docker ps -a

echo "A instalação do Nginx Proxy Manager foi concluída. Acesse http://SEU_IP_SERVER/ para configurá-lo."
echo "Use o seguinte login inicial:"
echo "Email: admin@example.com"
echo "Senha: changeme"

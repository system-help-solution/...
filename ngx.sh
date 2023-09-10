#!/bin/bash

# Atualize o sistema
sudo apt update
sudo apt upgrade -y

# Instale as dependências
sudo apt install -y ca-certificates curl gnupg2 apt-transport-https lsb-release

# Adicione o repositório oficial do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualize o repositório e instale o Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Instale o Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Crie os diretórios para o Nginx Proxy Manager
sudo mkdir -p /etc/nginx-proxy/{data,letsencrypt}

# Crie o arquivo de composição do Docker para o Nginx Proxy Manager
cat > /etc/nginx-proxy/docker-compose.yml <<EOL
version: "3"
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '443:443'
      - '81:81'
    environment:
      DB_MYSQL_HOST: "db"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "nginxproxy"
      DB_MYSQL_PASSWORD: "S3NHA_NGINX_PR0XY"
      DB_MYSQL_NAME: "nginxproxy"
    volumes:
      - /etc/nginx-proxy/data:/data
      - /etc/nginx-proxy/letsencrypt:/etc/letsencrypt
    depends_on:
      - db

  db:
    image: 'jc21/mariadb-aria:latest'
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: 'S3NHA_D3_R00T'
      MYSQL_DATABASE: 'nginxproxy'
      MYSQL_USER: 'nginxproxy'
      MYSQL_PASSWORD: 'S3NHA_NGINX_PR0XY'
    volumes:
      - /etc/nginx-proxy/data/mysql:/var/lib/mysql
EOL

# Navegue até o diretório do Nginx Proxy Manager e inicie os contêineres
cd /etc/nginx-proxy
sudo docker-compose up -d

# Aguarde até que os contêineres sejam iniciados
sleep 10

# Exiba os contêineres em execução
sudo docker ps -a

echo "A instalação do Nginx Proxy Manager foi concluída. Acesse http://SEU_IP_SERVER/ para configurá-lo."
echo "Use o seguinte login inicial:"
echo "Email: admin@example.com"
echo "Senha: changeme"

cd #
cd ...

./instalador.sh

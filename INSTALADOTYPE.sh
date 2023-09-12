#!/bin/bash

# Incluir o banner.sh para exibição do banner
source ./banner.sh

# Função para coletar uma variável com confirmação
function coletar_com_confirmacao() {
  local mensagem="$1"
  local variavel=""
  local confirmacao=""

  while [ -z "$variavel" ] || [ "$confirmacao" != "y" ]; do
    read -p "$mensagem: " -s variavel
    echo
    read -p "Confirme parte da senha (os últimos caracteres): " -s confirmacao
    echo
    if [ "$confirmacao" != "y" ]; then
      variavel=""
    fi
  done

  echo "$variavel"
}

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
    elif [ "$dependencia" == "nginx" ]; then
      sudo apt update -y
      sudo apt install -y nginx
    else
      echo "Dependência desconhecida: $dependencia. Por favor, instale manualmente."
      exit 1
    fi
  fi
}

# Coleta das informações
read -p "Por favor, insira seu domínio para o Typeboot: " dominio_typeboot
read -p "Agora, insira seu domínio para o Boot do Typeboot: " dominio_boot
read -p "Digite seu email do Google (Gmail): " email_google
read -p "Digite a senha do aplicativo do Google (Gmail): " senha_app_google
read -p "Por favor, insira o domínio de data: " dominio_data

# Exibe as informações coletadas
echo -e "\nInformações inseridas:"
echo "Domínio Typeboot: $dominio_typeboot"
echo "Domínio Boot Typeboot: $dominio_boot"
echo "Email do Google: $email_google"
echo "Senha do App do Google: $senha_app_google"
echo "Domínio de Data: $dominio_data"

read -p "As informações estão corretas? (y/n): " confirmacao_final

if [ "$confirmacao_final" == "y" ]; then
  echo "Continuando com a instalação..."
  
  # Verificar e instalar dependências
  verificar_e_instalar_dependencias "docker"
  verificar_e_instalar_dependencias "docker-compose"
  verificar_e_instalar_dependencias "nginx"

  # Criar a pasta 'typeboot' no diretório raiz
  cd
  echo "Criando a pasta 'typeboot'..."
  mkdir ~/typeboot

  # Navegar até a pasta 'typeboot'
  cd ~/typeboot

  # Criar o arquivo 'docker-compose.yml' com as informações inseridas
  echo "Criando o arquivo 'docker-compose.yml'..."
  cat <<EOL >docker-compose.yml
version: '3.3'
services:

  typebot-db:
    image: postgres:13
    restart: always
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=typebot # Troque se necessario
      - POSTGRES_PASSWORD=typebot # Troque se necessario
  typebot-builder:
    labels:
      virtual.host: '$dominio_typeboot' # Troque pelo seu dominio ou subdominio
      virtual.port: '3000'
      virtual.tls-email: '$email_google' # Troque pelo seu email
    image: elestio/typebot-builder:latest
    restart: always
    ports:
      - '3001:3000'
    depends_on:
      - typebot-db
    extra_hosts:
      - 'host.docker.internal:host-gateway'
    # See https://docs.typebot.io/self-hosting/configuration for more configuration options
    environment:
      - DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot
      - NEXTAUTH_URL=https://$dominio_typeboot # Troque pelo seu dominio ou subdominio
      - NEXT_PUBLIC_VIEWER_URL=https://$dominio_boot # Troque pelo seu dominio ou subdominio
      - ENCRYPTION_SECRET=c56f3775313440c3edce57529a0f02b4
      - ADMIN_EMAIL=$email_google # Troque pelo seu email
      #- DISABLE_SIGNUP=false # Mude Para false caso queira permitir que outras pessoas criem contas
      - SMTP_AUTH_DISABLED=false
      - SMTP_SECURE=false # Troque para false seu nao usar a porta 465 ou se estiver enfretando problemas no login
      - SMTP_HOST=smtp.gmail.com # Troque pelo seu SMTP USE SOMENTE DOMINIO PROPRIETARIOS
      - SMTP_PORT=587 # altere aqui se nescessario portas comuns 25, 587, 465, 2525
      - SMTP_USERNAME=$email_google # troque pelo seu email
      - SMTP_PASSWORD=$senha_app_google # Troque pela sua senha
      - NEXT_PUBLIC_SMTP_FROM=$email_google # Troque pelo seu email
      - S3_ACCESS_KEY=minio # Troque se necessario
      - S3_SECRET_KEY=minio123 # Troque se necessario
      - S3_BUCKET=typebot
      - S3_ENDPOINT=$dominio_data # Troque pelo seu dominio ou subdominio
  typebot-viewer:
    labels:
      virtual.host: '$dominio_boot' # Troque pelo seu dominio ou subdominio
      virtual.port: '3000'
      virtual.tls-email: '$email_google' # Troque pelo seu email
    image: elestio/typebot-viewer:latest
    restart: always
    ports:
      - '3002:3000'
    # See https://docs.typebot.io/self-hosting/configuration for more configuration options
    environment:
      - DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot
      - NEXTAUTH_URL=https://$dominio_typeboot # Troque pelo seu dominio ou subdominio
      - NEXT_PUBLIC_VIEWER_URL=https://$dominio_boot # Troque pelo seu dominio ou subdominio
      - ENCRYPTION_SECRET=c56f3775313440c3edce57529a0f02b4
      - SMTP_HOST=smtp.gmail.com # Troque pelo seu SMTP USE SOMENTE DOMINIO PROPRIETARIOS
      - NEXT_PUBLIC_SMTP_FROM=$email_google # Troque pelo seu email
      - S3_ACCESS_KEY=minio # Troque se necessario - Deve ser Igual ao Declarado no Typebot Builder S3_ACCESS_KEY=
      - S3_SECRET_KEY=minio123 # Troque se necessario - Deve ser Igual ao Declarado no Typebot Builder S3_SECRET_KEY=
      - S3_BUCKET=typebot
      - S3_ENDPOINT=$dominio_data # Troque pelo seu dominio ou subdominio
  mail:
    image: bytemark/smtp
    restart: always
  minio:
    labels:
      virtual.host: '$dominio_data' # Troque pelo seu dominio ou subdominio
      virtual.port: '9000'
      virtual.tls-email: '$email_google' # Troque pelo seu email
    image: minio/minio
    command: server /data
    ports:
      - '9000:9000'
    environment:
      MINIO_ROOT_USER: minio # Troque se necessario - Deve ser Igual ao Declarado no Typebot Builder S3_ACCESS_KEY=
      MINIO_ROOT_PASSWORD: minio123 # Troque se necessario - Deve ser Igual ao Declarado no Typebot Builder S3_SECRET_KEY=
    volumes:
      - s3_data:/data
  # This service just makes sure a bucket with the right policies is created

  # Certifique-se de atualizar S3_ACCESS_KEY , S3_SECRET_KEY abaixo para corresponder às suas configurações do S3, elas estão no final dessa linha /usr/bin/mc config host add minio http://minio:9000 minio minio123; sendo o usuario e a senha em sequencia.
  createbuckets:
    image: minio/mc
    depends_on:
      - minio
    entrypoint: >
      /bin/sh -c "
      sleep 10;
      /usr/bin/mc config host add minio http://minio:9000 minio minio123;
      /usr/bin/mc mb minio/typebot;
      /usr/bin/mc anonymous set public minio/typebot/public;
      exit 0;
      "
volumes:
  db_data:
  s3_data:
  caddy-certificates:
    driver: local

EOL

  echo "Arquivo 'docker-compose.yml' criado com sucesso!"

  # Instalar Certbot e configurar Nginx
  echo "Instalando Certbot e configurando Nginx..."
  sudo apt update -y
  sudo apt install -y certbot python3-certbot-nginx

  # Obter o certificado SSL
  sudo certbot --nginx --email $email_google --redirect --agree-tos -d $dominio_typeboot -d $dominio_boot -d $dominio_data

  # Reiniciar Nginx para aplicar as configurações
  sudo systemctl restart nginx

  # Executar 'docker-compose up -d'
  echo "Executando 'docker-compose up -d'..."
  docker-compose up -d
  if [ $? -eq 0 ]; then
    echo "Typeboot foi iniciado com sucesso!"
  else
    echo "Erro ao iniciar o Typeboot. Verifique as dependências e tente novamente."
  fi

else
  echo "As informações não estão corretas. Por favor, execute o script novamente."
fi

echo "Criado e configurado com sucesso"

sleep 3

clear

###############################################

echo "Iniciando Conteiner"

sleep 3

docker-compose up -d

echo "Typebot Instaldo... Realizando Proxy Reverso"

sleep 3

clear

###############################################

cd

cat > typeboot << EOL
server {

  server_name $dominio_typeboot;

  location / {

    proxy_pass http://127.0.0.1:3001;

    proxy_http_version 1.1;

    proxy_set_header Upgrade \$http_upgrade;

    proxy_set_header Connection 'upgrade';

    proxy_set_header Host \$host;

    proxy_set_header X-Real-IP \$remote_addr;

    proxy_set_header X-Forwarded-Proto \$scheme;

    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    
    proxy_cache_bypass \$http_upgrade;

    }

  }
EOL

###############################################

sudo mv typebot /etc/nginx/sites-available/

sudo ln -s /etc/nginx/sites-available/typebot /etc/nginx/sites-enabled

###############################################

cd

cat > bot << EOL
server {

  server_name $dominio_boot;

  location / {

    proxy_pass http://127.0.0.1:3002;

    proxy_http_version 1.1;

    proxy_set_header Upgrade \$http_upgrade;

    proxy_set_header Connection 'upgrade';

    proxy_set_header Host \$host;

    proxy_set_header X-Real-IP \$remote_addr;

    proxy_set_header X-Forwarded-Proto \$scheme;

    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    
    proxy_cache_bypass \$http_upgrade;

    }

  }
EOL

###############################################

sudo mv bot /etc/nginx/sites-available/

sudo ln -s /etc/nginx/sites-available/bot /etc/nginx/sites-enabled

##################################################

cd

cat > storage << EOL
server {

  server_name $dominio_data;

  location / {

    proxy_pass http://127.0.0.1:9000;

    proxy_http_version 1.1;

    proxy_set_header Upgrade \$http_upgrade;

    proxy_set_header Connection 'upgrade';

    proxy_set_header Host \$host;

    proxy_set_header X-Real-IP \$remote_addr;

    proxy_set_header X-Forwarded-Proto \$scheme;

    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    
    proxy_cache_bypass \$http_upgrade;

    }

  }
EOL

###############################################

sudo mv storage /etc/nginx/sites-available/

sudo ln -s /etc/nginx/sites-available/storage /etc/nginx/sites-enabled

#######################################################

echo "proxy reverso da Evolution e do typebot"

sudo certbot --nginx --email $email_google --redirect --agree-tos -d $dominio_typeboot -d $dominio_boot -d $dominio_data

####

cd
cd ...

./instalador.sh

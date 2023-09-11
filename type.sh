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
    else
      echo "Dependência desconhecida: $dependencia. Por favor, instale manualmente."
      exit 1
    fi
  fi
}

source ./banner.sh

echo "Bem-vindo à configuração do Typeboot!"
echo "Vou fazer algumas perguntas para configurar seu ambiente."
echo "Vamos lá!"

# Coleta das informações
read -p "Por favor, insira seu domínio para o Typeboot: " dominio_typeboot
read -p "Agora, insira seu domínio para o Boot do Typeboot: " dominio_boot
read -p "Digite seu email do Google (Gmail): " email_google
read -p "Digite a senha do aplicativo do Google (Gmail): " senha_app_google
read -p "Por favor, insira a chave gerada: " key_gerada

# Exibe as informações coletadas
echo -e "\nInformações inseridas:"
echo "Domínio Typeboot: $dominio_typeboot"
echo "Domínio Boot Typeboot: $dominio_boot"
echo "Email do Google: $email_google"
echo "Senha do App do Google: ************"
echo "Chave Gerada: $key_gerada"

read -p "As informações estão corretas? (y/n): " confirmacao_final

if [ "$confirmacao_final" == "y" ]; then
  echo "Continuando com a instalação..."


  # Verificar e instalar dependências
  verificar_e_instalar_dependencias "docker"
  verificar_e_instalar_dependencias "docker-compose"

  # Criar a pasta 'typeboot' no diretório raiz
  echo "Criando a pasta 'typeboot'..."
  mkdir ~/typeboot

  # Navegar até a pasta 'typeboot'
  cd ~/typeboot

  # Criar o arquivo 'docker-compose.yml' com as informações inseridas
  echo "Criando o arquivo 'docker-compose.yml'..."
  cat <<EOL >docker-compose.yml
version: '3.7'
services:
  typebot-db:
    image: postgres:13
    restart: always
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=typebot # Troque se necessário
      - POSTGRES_PASSWORD=typebot # Troque se necessário
  typebot-builder:
    labels:
      virtual.host: '$domínio_typeboot' # Troque pelo seu domínio ou subdomínio
      virtual.port: '3000'
      virtual.tls-email: '$email_google' # Troque pelo seu email
    image: baptistearno/typebot-builder:latest
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
      - NEXTAUTH_URL=https://$domínio_typeboot # Troque pelo seu domínio ou subdomínio
      - NEXT_PUBLIC_VIEWER_URL=https://$domínio_boot # Troque pelo seu domínio ou subdomínio
      - ENCRYPTION_SECRET=c56f3775313440c3edce57529a0f02b4
      - ADMIN_EMAIL=$email_google # Troque pelo seu email
      #- DISABLE_SIGNUP=false # Mude para false caso queira permitir que outras pessoas criem contas
      - SMTP_AUTH_DISABLED=false
      - SMTP_SECURE=false # Troque para false se não usar a porta 465 ou se estiver enfrentando problemas no login
      - SMTP_HOST=smtp.gmail.com # Troque pelo seu SMTP USE SOMENTE DOMÍNIOS PRÓPRIOS
      - SMTP_PORT=587 # Altere aqui se necessário, portas comuns: 25, 587, 465, 2525
      - SMTP_USERNAME=$email_google # Troque pelo seu email
      - SMTP_PASSWORD=$senha_app_google # Troque pela sua senha
      - NEXT_PUBLIC_SMTP_FROM=$email_google # Troque pelo seu email
      - S3_ACCESS_KEY=minio # Troque se necessário
      - S3_SECRET_KEY=minio123 # Troque se necessário
      - S3_BUCKET=typebot
      - S3_ENDPOINT=$domínio_boot # Troque pelo seu domínio ou subdomínio
  typebot-viewer:
    labels:
      virtual.host: '$domínio_boot' # Troque pelo seu domínio ou subdomínio
      virtual.port: '3000'
      virtual.tls-email: '$email_google' # Troque pelo seu email
    image: baptistearno/typebot-viewer:latest
    restart: always
    ports:
      - '3002:3000'
    # See https://docs.typebot.io/self-hosting/configuration for more configuration options
    environment:
      - DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot
      - NEXTAUTH_URL=https://$domínio_typeboot # Troque pelo seu domínio ou subdomínio
      - NEXT_PUBLIC_VIEWER_URL=https://$domínio_boot # Troque pelo seu domínio ou subdomínio
      - ENCRYPTION_SECRET=c56f3775313440c3edce57529a0f02b4
      - SMTP_HOST=smtp.gmail.com # Troque pelo seu SMTP USE SOMENTE DOMÍNIOS PRÓPRIOS
      - NEXT_PUBLIC_SMTP_FROM=$email_google # Troque pelo seu email
      - S3_ACCESS_KEY=minio # Troque se necessário - Deve ser igual ao declarado no Typebot Builder S3_ACCESS_KEY=
      - S3_SECRET_KEY=minio123 # Troque se necessário - Deve ser igual ao declarado no Typebot Builder S3_SECRET_KEY=
      - S3_BUCKET=typebot
      - S3_ENDPOINT=$domínio_boot # Troque pelo seu domínio ou subdomínio
  mail:
    image: bytemark/smtp
    restart: always
  minio:
    labels:
      virtual.host: '$domínio_boot' # Troque pelo seu domínio ou subdomínio
      virtual.port: '9000'
      virtual.tls-email: '$email_google' # Troque pelo seu email
    image: minio/minio
    command: server /data
    ports:
      - '9000:9000'
    environment:
      MINIO_ROOT_USER: minio # Troque se necessário - Deve ser igual ao declarado no Typebot Builder S3_ACCESS_KEY=
      MINIO_ROOT_PASSWORD: minio123 # Troque se necessário - Deve ser igual ao declarado no Typebot Builder S3_SECRET_KEY=
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



cd #
cd ...

./instalador.sh

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

# Coleta das informações
dominio_typeboot=$(coletar_com_confirmacao "Seu domínio para o Typeboot")
domino_boot=$(coletar_com_confirmacao "Seu domínio para o Boot do Typeboot")
email_google=$(coletar_com_confirmacao "Seu email do Google (Gmail)")
senha_app_google=$(coletar_com_confirmacao "Senha do aplicativo do Google (Gmail)")
key_gerada=$(coletar_com_confirmacao "Sua chave gerada")

# Exibe as informações coletadas para confirmação
echo -e "\nConfirme as informações:"
echo "Domínio Typeboot: $dominio_typeboot"
echo "Domínio Boot Typeboot: $domino_boot"
echo "Email do Google: $email_google"
echo "Senha do App do Google: ************ (apenas os últimos caracteres)"
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
version: '3.3'
services:
  caddy-gen:
    image: 'wemakeservices/caddy-gen:latest'
    restart: always
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - caddy-certificates:/data/caddy
    ports:
      - '82:80'
      - '8443:443'
    depends_on:
      - typebot-builder
      - typebot-viewer
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
      virtual.host: '$dominio_typeboot' # Troque pelo seu domínio ou subdominio
      virtual.port: '3000'
      virtual.tls-email: '$email_typeboot' # Troque pelo seu email
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
      - NEXTAUTH_URL=https://$dominio_typeboot # Troque pelo seu domínio ou subdominio
      - NEXT_PUBLIC_VIEWER_URL=https://$domino_boot # Troque pelo seu dominio ou subdominio
      - ENCRYPTION_SECRET=$key_gere
      - ADMIN_EMAIL=$email_typeboot # Troque pelo seu email
      - DISABLE_SIGNUP=false # Mude Para false caso queira permitir que outras pessoas criem contas
      - SMTP_AUTH_DISABLED=false
      - SMTP_SECURE=true # Troque para false seu nao usar a porta 465 ou se estiver enfretando problemas no login
      - SMTP_HOST=smtp.gmail.com # Troque pelo seu SMTP USE SOMENTE DOMINIO PROPRIETARIOS
      - SMTP_PORT=587 # altere aqui se nescessario portas comuns 25, 587, 465, 2525
      - SMTP_USERNAME=$email_typeboot # troque pelo seu email
      - SMTP_PASSWORD=$senha_app_google # Troque pela sua senha
      - NEXT_PUBLIC_SMTP_FROM=$email_typeboot # Troque pelo seu email
      - S3_ACCESS_KEY=minio # Troque se necessario
      - S3_SECRET_KEY=minio123 # Troque se necessario
      - S3_BUCKET=typebot
      - S3_ENDPOINT=$domino_boot # Troque pelo seu dominio ou subdominio
  typebot-viewer:
    labels:
      virtual.host: '$domino_boot' # Troque pelo seu domínio ou subdominio
      virtual.port: '3000'
      virtual.tls-email: '$email_typeboot' # Troque pelo seu email
    image: baptistearno/typebot-viewer:latest
    restart: always
    ports:
      - '3002:3000'
    # See https://docs.typebot.io/self-hosting/configuration for more configuration options
    environment:
      - DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot
      - NEXTAUTH_URL=https://$dominio_typeboot # Troque pelo seu domínio ou subdominio
      - NEXT_PUBLIC_VIEWER_URL=https://$domino_boot # Troque pelo seu dominio ou subdominio
      - ENCRYPTION_SECRET=$key_gere
      - SMTP_HOST=smtp.gmail.com # Troque pelo seu SMTP USE SOMENTE DOMINIO PROPRIETARIOS
      - NEXT_PUBLIC_SMTP_FROM=$email_typeboot # Troque pelo seu email
      - S3_ACCESS_KEY=minio # Troque se necessario - Deve ser Igual ao Declarado no Typebot Builder S3_ACCESS_KEY=
      - S3_SECRET_KEY=minio123 # Troque se necessario - Deve ser Igual ao Declarado no Typebot Builder S3_SECRET_KEY=
      - S3_BUCKET=typebot
      - S3_ENDPOINT=$domino_boot # Troque pelo seu dominio ou subdominio
  mail:
    image: bytemark/smtp
    restart: always
  minio:
    labels:
      virtual.host: '$domino_boot' # Troque pelo seu dominio ou subdominio
      virtual.port: '9000'
      virtual.tls-email: '$email_typeboot' # Troque pelo seu email
    image: minio/minio
    command: server /data
    ports:
      - '9000:9000'
    environment:
      MINIO_ROOT_USER: minio # Troque se necessario - Deve ser Igual ao Declarado no Typebot Builder S3_ACCESS_KEY=
      MINIO_ROOT_PASSWORD: minio123 # Troque se necessario - Deve ser Igual ao Declarado no Typebot Builder S3_SECRET_KEY=
    volumes:
      - s3_data:/data
  # This service just make sure a bucket with the right policies is created

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

  # Voltar para o instalador.sh
  exec ./instalador.sh
else
  echo "As informações não estão corretas. Por favor, execute o script novamente."
fi

# Exibir o banner2.sh por 5 segundos
sleep 5
if [ -f banner2.sh ]; then
  source banner2.sh
fi

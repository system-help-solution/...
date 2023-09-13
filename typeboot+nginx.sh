#######################################################

clear
# Imprime o banner centralizado
echo -e "$green"
echo -e "\e[32m▄████████ ▄██   ▄      ▄████████     ███        ▄████████   ▄▄▄▄███▄▄▄▄\e[0m"
echo -e "\e[32m███    ███ ███   ██▄   ███    ███ ▀█████████▄   ███    ███ ▄██▀▀▀███▀▀▀██▄\e[0m"
echo -e "\e[32m███    █▀  ███▄▄▄███   ███    █▀     ▀███▀▀██   ███    █▀  ███   ███   ██▄\e[0m"
echo -e "\e[32m███        ▀▀▀▀▀▀███   ███            ███   ▀  ▄███▄▄▄     ███   ███   ██▄\e[0m"
echo -e "\e[32m▀███████████ ▄██   ███ ▀███████████     ███     ▀▀███▀▀▀     ███   ███   ██▄\e[0m"
echo -e "\e[32m         ███ ███   ███          ███     ███       ███    █▄  ███   ███   ██▄\e[0m"
echo -e "\e[32m   ▄█    ███ ███   ███    ▄█    ███     ███       ███    ███ ███   ███   ██▄\e[0m"
echo -e "\e[32m ▄████████▀   ▀█████▀   ▄████████▀     ▄████▀     ██████████  ▀█   ███   █▀\e[0m"
echo -e "\e[32m           By SystemHelp MOD V. 0.0.1\e[0m"
echo -e "\e[32m                          APOIA AQUI ESTA O PIX CNPJ: 48.590.314/0001-18 \e[0m"
echo -e "\e[32m                          Telegram https://t.me/+FGzk0EiNths1N2Nh \e[0m"
echo -e "\e[32m                          YOUTUBE https://www.youtube.com/@SYSTEMHELP\e[0m"
echo -e "$reset"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"

sleep 3

#######################################################



    # Função para configurar o TypeBot
    echo "Agora vamos configurar o Typebot para rodar em Docker"
echo ""
while true; do
    read -p "Qual é o seu domínio para o Typebot (ex: typebot.seudominio.com): " builder

    while [ -z "$builder" ]; do
        echo "Resposta inválida. O domínio do Typebot não pode ser vazio."
        read -p "Qual é o seu domínio para o Typebot (ex: typebot.seudominio.com): " builder
    done

    echo ""
    read -p "Porta para o Typebot (padrão: 3301): " portabuilder

    while [ -z "$portabuilder" ]; do
        portabuilder="3301"
    done

    read -p "Qual é o seu domínio para o Bot (ex: bot.seudominio.com): " viewer

    while [ -z "$viewer" ]; do
        echo "Resposta inválida. O domínio do Bot não pode ser vazio."
        read -p "Qual é o seu domínio para o Bot (ex: bot.seudominio.com): " viewer
    done

    echo ""
    read -p "Porta para seu Bot (padrão: 3302): " portaviewer

    while [ -z "$portaviewer" ]; do
        portaviewer="3302"
    done

    read -p "Qual é o seu domínio para o Storage (ex: storage.seudominio.com): " storage

    while [ -z "$storage" ]; do
        echo "Resposta inválida. O domínio do Storage não pode ser vazio."
        read -p "Qual é o seu domínio para o Storage (ex: storage.seudominio.com): " storage
    done

    echo ""
    read -p "Porta para o Storage (padrão: 9020): " portastorage

    while [ -z "$portastorage" ]; do
        portastorage="9020"
    done

    read -p "Seu Email (eu configurei para que funcione com o Gmail, então, em outro email, pode não funcionar): " email

    while [ -z "$email" ]; do
        echo "Resposta inválida. O Email não pode ser vazio."
        read -p "Seu Email (eu configurei para que funcione com o Gmail, então, em outro email, pode não funcionar): " email
    done

    echo ""
    read -p "Senha do aplicativo do Gmail (se você não souber o que é, pare aqui e procure): " senha

    while [ -z "$senha" ]; do
        echo "Resposta inválida. A senha não pode ser vazia."
        read -p "Senha do aplicativo do Gmail (se você não souber o que é, pare aqui e procure): " senha
    done

    echo ""
    read -p "SMTP do Gmail (ex: smtp.gmail.com): " smtp

    while [ -z "$smtp" ]; do
        echo "Resposta inválida. O SMTP do Gmail não pode ser vazio."
        read -p "SMTP do Gmail (ex: smtp.gmail.com): " smtp
    done

    echo ""
    read -p "Porta SMTP (ex: 587): " portasmtp

    while [ -z "$portasmtp" ]; do
        echo "Resposta inválida. A porta SMTP não pode ser vazia."
        read -p "Porta SMTP (ex: 587): " portasmtp
    done

    echo ""
    read -p "SMTP_SECURE (Se a porta SMTP for 587, digite false; caso contrário, digite true): " SECURE

    while [ -z "$SECURE" ]; do
        echo "Resposta inválida. O campo SMTP_SECURE não pode ser vazio."
        read -p "SMTP_SECURE (Se a porta SMTP for 587, digite false; caso contrário, digite true): " SECURE
    done

        echo "Crie sua ApiKey no link: https://codebeautify.org/generate-random-hexadecimal-numbers"
        read -p "Chave secreta de 32 caracteres: (ex: c56f3775313440c3edce57529a0f02b4) " key

    while [ ${#key} -ne 32 ]; do
        echo "A chave secreta deve ter exatamente 32 caracteres."
        read -p "Chave secreta de 32 caracteres: (ex: c56f3775313440c3edce57529a0f02b4) " key
    done

    echo ""
    echo "As informações fornecidas estão corretas?"
    echo "Domínio do Typebot: $builder"
    echo "Porta do Typebot: $portabuilder"
    echo "Domínio do Bot: $viewer"
    echo "Porta do Bot: $portaviewer"
    echo "Domínio do Storage: $storage"
    echo "Porta do Storage: $portastorage"
    echo "Email: $email"
    echo "SMTP do Gmail: $smtp"
    echo "Porta SMTP: $portasmtp"
    echo "SMTP_SECURE: $SECURE"
    echo "Chave secreta (ApiKey): $key"
    read -p "Digite 'Y' para continuar ou 'N' para corrigir: " confirmacao

    if [ "$confirmacao" = "Y" ] || [ "$confirmacao" = "y" ]; then
        break
    elif [ "$confirmacao" = "N" ] || [ "$confirmacao" = "n" ]; then
        continue
    fi
done

# O script continuará a partir daqui com as informações corretas


#######################################################

echo "Instalando as Dependencias"

sleep 3

clear

sudo apt update -y

sudo apt upgrade -y

curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - && apt-get install -y nodejs

npm install -g npm@

npm install -g pm2@

apt-get install -y git zip unzip nload snapd curl wget sudo

sudo timedatectl set-timezone America/Sao_Paulo

apt update && apt -y upgrade

apt install docker-compose -y

sudo apt update

sudo apt install nginx -y

sudo apt update

sudo apt install certbot -y

sudo apt install python3-certbot-nginx -y

sudo apt update

#systemctl start nginx

#systemctl enable nginx

#snap install --classic certbot

#rm /etc/nginx/sites-enabled/default

clear

cd

cd

#######################################################

echo "Instalando Typebot"

echo "Criando arquivo docker-compose.yml"

sleep 3

cat > docker-compose.yml << EOL
version: '3.3'
services:
  typebot-db:
    image: postgres:13
    restart: always
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=typebot
      - POSTGRES_PASSWORD=typebot
  typebot-builder:
    ports:
      - $portabuilder:3000
    image: baptistearno/typebot-builder:2.16.0
    restart: always
    depends_on:
      - typebot-db
    environment:
      - DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot
      - NEXTAUTH_URL=https://$builder
      - NEXT_PUBLIC_VIEWER_URL=https://$viewer

      - ENCRYPTION_SECRET=$key

      - ADMIN_EMAIL=$email

      - SMTP_SECURE=$SECURE

      - SMTP_HOST=$smtp
      - SMTP_PORT=$portasmtp
      - SMTP_USERNAME=$email
      - SMTP_PASSWORD=$senha
      - NEXT_PUBLIC_SMTP_FROM='Suporte Typebot' <$email>

      - S3_ACCESS_KEY=minio
      - S3_SECRET_KEY=minio123
      - S3_BUCKET=typebot
      - S3_ENDPOINT=$storage
  typebot-viewer:
    ports:
      - $portaviewer:3000
    image: baptistearno/typebot-viewer:2.16.0
    restart: always
    environment:
      - DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot
      - NEXT_PUBLIC_VIEWER_URL=https://$viewer
      - ENCRYPTION_SECRET=$key

      - S3_ACCESS_KEY=minio
      - S3_SECRET_KEY=minio123
      - S3_BUCKET=typebot
      - S3_ENDPOINT=$storage
  mail:
    image: bytemark/smtp
    restart: always
  minio:
    labels:
      virtual.host: '$storage'
      virtual.port: '$portastorage'
      virtual.tls-email: '$email'
    image: minio/minio
    command: server /data
    ports:
      - '$portastorage:$portastorage'
    environment:
      MINIO_ROOT_USER: minio
      MINIO_ROOT_PASSWORD: minio123
    volumes:
      - s3_data:/data
  createbuckets:
    image: minio/mc
    depends_on:
      - minio
    entrypoint: >
      /bin/sh -c "
      sleep 10;
      /usr/bin/mc config host add minio http://minio:$portastorage minio minio123;
      /usr/bin/mc mb minio/typebot;
      /usr/bin/mc anonymous set public minio/typebot/public;
      exit 0;
      "
volumes:
  db_data:
  s3_data:
EOL

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

cat > typebot << EOL
server {

  server_name $builder;

  location / {

    proxy_pass http://127.0.0.1:$portabuilder;

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

  server_name $viewer;

  location / {

    proxy_pass http://127.0.0.1:$portaviewer;

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

  server_name $storage;

  location / {

    proxy_pass http://127.0.0.1:$portastorage;

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

sudo certbot --nginx --email $email --redirect --agree-tos -d $dominio -d $builder -d $viewer -d $storage


#######################################################
cd
cd
cd
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m _                             _              _        \e[0m"
echo -e "\e[32m| |                _          | |            | |       \e[0m"
echo -e "\e[32m| | ____    ___  _| |_  _____ | |  _____   __| |  ___  \e[0m"
echo -e "\e[32m| ||  _ \  /___)(_   _)(____ || | (____ | / _  | / _ \ \e[0m"
echo -e "\e[32m| || | | ||___ |  | |_ / ___ || | / ___ |( (_| || |_| |\e[0m"
echo -e "\e[32m|_||_| |_|(___/    \__)\_____| \_)\_____| \____| \___/ \e[0m"
echo -e "\e[32m                                                       \e[0m"              
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32mAcesse a Evolution API através do link: https://$dominio\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32mAcesse o Builder do Tyoebot através do link: https://$builder\e[0m"
echo -e "\e[32m\e[0m"
            # Imprime o banner centralizado
            echo -e "$green"
            echo -e "\e[32m▄████████ ▄██   ▄      ▄████████     ███        ▄████████   ▄▄▄▄███▄▄▄▄\e[0m"
            echo -e "\e[32m███    ███ ███   ██▄   ███    ███ ▀█████████▄   ███    ███ ▄██▀▀▀███▀▀▀██▄\e[0m"
            echo -e "\e[32m███    █▀  ███▄▄▄███   ███    █▀     ▀███▀▀██   ███    █▀  ███   ███   ██▄\e[0m"
            echo -e "\e[32m███        ▀▀▀▀▀▀███   ███            ███   ▀  ▄███▄▄▄     ███   ███   ██▄\e[0m"
            echo -e "\e[32m▀███████████ ▄██   ███ ▀███████████     ███     ▀▀███▀▀▀     ███   ███   ██▄\e[0m"
            echo -e "\e[32m         ███ ███   ███          ███     ███       ███    █▄  ███   ███   ██▄\e[0m"
            echo -e "\e[32m   ▄█    ███ ███   ███    ▄█    ███     ███       ███    ███ ███   ███   ██▄\e[0m"
            echo -e "\e[32m ▄████████▀   ▀█████▀   ▄████████▀     ▄████▀     ██████████  ▀█   ███   █▀\e[0m"
            echo -e "\e[32m           By SystemHelp MOD V. 0.0.1\e[0m"
            echo -e "\e[32m                          APOIA AQUI ESTA O PIX CNPJ: 48.590.314/0001-18 \e[0m"
            echo -e "\e[32m                          Telegram https://t.me/+FGzk0EiNths1N2Nh \e[0m"
            echo -e "\e[32m                          YOUTUBE https://www.youtube.com/@SYSTEMHELP\e[0m"
            echo -e "$reset"


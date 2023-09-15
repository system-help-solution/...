#######################################################

#######################################################
while true; do
    echo "Vamos Instalar o EvolutionApi"
    echo ""
    read -p "Digite seu domínio para acessar a EvolutionApi (ex: api.dominio.com): " dominio

    while [ -z "$dominio" ]; do
        echo "Resposta inválida. O domínio não pode ser vazio."
        read -p "Digite seu domínio para acessar a EvolutionApi (ex: api.dominio.com): " dominio
    done

    echo ""
    read -p "Digite a porta da EvolutionApi (padrão: 8080): " porta

    while [ -z "$porta" ]; do
        echo "Resposta inválida. A porta não pode ser vazia."
        read -p "Digite a porta da EvolutionApi (padrão: 8080): " porta
    done

    read -p "Digite o nome para sua API (ex: system): " client

    while [ -z "$client" ]; do
        echo "Resposta inválida. O nome da API não pode ser vazio."
        read -p "Digite o nome para sua API (ex: system): " client
    done

    echo ""
    echo "ATENÇÃO ⚠️ CRIE UM TOKEN DE 32 CARACTERES OU USE O QUE JA ESTÁ AQUI⚠️: https://codebeautify.org/generate-random-hexadecimal-numbers"
    read -p "Sua ApiKey Global (ex: c56f3775313440c3edce57529a0f02b4): " keyy

    while [ -z "$keyy" ]; do
        echo "Resposta inválida. A ApiKey Global não pode ser vazia."
        read -p "Sua ApiKey Global (ex: c56f3775313440c3edce57529a0f02b4): " keyy
    done

    # Pergunte ao usuário se as informações estão corretas
    echo ""
    echo "As informações fornecidas estão corretas?"
    echo "Domínio da API: $dominio"
    echo "Porta da API: $porta"
    echo "Nome da API: $client"
    echo "ApiKey Global: $keyy"
    read -p "Digite 'Y' para continuar ou 'N' para corrigir: " confirmacao

    if [ "$confirmacao" = "Y" ] || [ "$confirmacao" = "y" ]; then
        break  # Se as informações estiverem corretas, saia do loop
    elif [ "$confirmacao" = "N" ] || [ "$confirmacao" = "n" ]; then
        continue  # Se o usuário disser "N", continue repetindo as perguntas
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

echo "Clonando git e trocando para develop"

git clone https://github.com/EvolutionAPI/evolution-api.git

cd evolution-api

#git branch -a

#git checkout develo

cd

cd

echo "Criando Env e Instalando com NPM"

cat > env.yml << EOL
# Choose the server type for the application
SERVER:
  TYPE: http # https
  PORT: $porta # 443
  URL: https://$dominio

CORS:
  ORIGIN:
    - "*"
    # - yourdomain.com
  METHODS:
    - POST
    - GET
    - PUT
    - DELETE
  CREDENTIALS: true

# Install ssl certificate and replace string <domain> with domain name
# Access: https://certbot.eff.org/instructions?ws=other&os=ubuntufocal
SSL_CONF:
  PRIVKEY: /etc/letsencrypt/live/<domain>/privkey.pem
  FULLCHAIN: /etc/letsencrypt/live/<domain>/fullchain.pem

# Determine the logs to be displayed
LOG:
  LEVEL:
    - ERROR
    - WARN
    - DEBUG
    - INFO
    - LOG
    - VERBOSE
    - DARK
    - WEBHOOKS
  COLOR: true
  BAILEYS: error # fatal | error | warn | info | debug | trace

# Determine how long the instance should be deleted from memory in case of no connection.
# Default time: 5 minutes
# If you don't even want an expiration, enter the value false
DEL_INSTANCE: false # or false

# Temporary data storage
STORE:
  MESSAGES: true
  MESSAGE_UP: true
  CONTACTS: true
  CHATS: true

CLEAN_STORE:
  CLEANING_INTERVAL: 7200 # 7200 seconds === 2h
  MESSAGES: true
  MESSAGE_UP: true
  CONTACTS: true
  CHATS: true

# Permanent data storage
DATABASE:
  ENABLED: false
  CONNECTION:
    URI: "mongodb://root:root@localhost:27017/?authSource=admin&readPreference=primary&ssl=false&directConnection=true"
    DB_PREFIX_NAME: evolution
  # Choose the data you want to save in the application's database or store
  SAVE_DATA:
    INSTANCE: false
    NEW_MESSAGE: false
    MESSAGE_UPDATE: false
    CONTACTS: false
    CHATS: false

REDIS:
  ENABLED: false
  URI: "redis://localhost:6379"
  PREFIX_KEY: "evolution"

RABBITMQ:
  ENABLED: false
  URI: "amqp://guest:guest@localhost:5672"

WEBSOCKET: 
  ENABLED: false

# Global Webhook Settings
# Each instance's Webhook URL and events will be requested at the time it is created
WEBHOOK:
  # Define a global webhook that will listen for enabled events from all instances
  GLOBAL:
    URL: <url>
    ENABLED: false
    # With this option activated, you work with a url per webhook event, respecting the global url and the name of each event
    WEBHOOK_BY_EVENTS: false
  # Automatically maps webhook paths
  # Set the events you want to hear
  EVENTS:
    APPLICATION_STARTUP: false
    QRCODE_UPDATED: true
    MESSAGES_SET: true
    MESSAGES_UPSERT: true
    MESSAGES_UPDATE: true
    MESSAGES_DELETE: true
    SEND_MESSAGE: true
    CONTACTS_SET: true
    CONTACTS_UPSERT: true
    CONTACTS_UPDATE: true
    PRESENCE_UPDATE: true
    CHATS_SET: true
    CHATS_UPSERT: true
    CHATS_UPDATE: true
    CHATS_DELETE: true
    GROUPS_UPSERT: true
    GROUP_UPDATE: true
    GROUP_PARTICIPANTS_UPDATE: true
    CONNECTION_UPDATE: true
    CALL: true
    # This event fires every time a new token is requested via the refresh route
    NEW_JWT_TOKEN: false

CONFIG_SESSION_PHONE:
  # Name that will be displayed on smartphone connection
  CLIENT: "$client"
  NAME: chrome # chrome | firefox | edge | opera | safari

# Set qrcode display limit
QRCODE:
  LIMIT: 30
  COLOR: '#198754'

# Defines an authentication type for the api
# We recommend using the apikey because it will allow you to use a custom token,
# if you use jwt, a random token will be generated and may be expired and you will have to generate a new token
AUTHENTICATION:
  TYPE: apikey # jwt or apikey
  # Define a global apikey to access all instances
  API_KEY:
    # OBS: This key must be inserted in the request header to create an instance.
    KEY: $keyy
  # Expose the api key on return from fetch instances
  EXPOSE_IN_FETCH_INSTANCES: true
  # Set the secret key to encrypt and decrypt your token and its expiration time.
  JWT:
    EXPIRIN_IN: 0 # seconds - 3600s === 1h | zero (0) - never expires
    SECRET: L=6544120E713976
EOL

#######################################################

sudo mv env.yml evolution-api/src/env.yml

cd

cd evolution-api

npm install

echo "Iniciando pm2"

pm2 start 'npm run start:prod' --name ApiEvolution

pm2 startup

pm2 save --force

#######################################################


#######################################################

clear

cd

cd

echo "Proxy Reverso"

cat > api << EOL
server {
  server_name $dominio;

  location / {
    proxy_pass http://127.0.0.1:$porta;
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

#######################################################
clear
cd

sudo mv api /etc/nginx/sites-available/api

ln -s /etc/nginx/sites-available/api /etc/nginx/sites-enabled

systemctl reload nginx

###############
###############
###############

#######################################################

echo "proxy reverso da Evolution e do typebot"

sudo certbot --nginx --email gamerhfj@gmail.com --redirect --agree-tos -d $dominio 


#######################################################

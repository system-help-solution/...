#!/bin/bash

sudo ln -s /caminho/para/seu/instalador.sh /usr/local/bin/menu

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

# Função para exibir o menu
display_menu() {
  echo "===================================="
  echo "        Instalador Automático       "
  echo "===================================="
  echo
  echo "Escolha uma opção para instalação:"
  echo "1. Instalar Typebot v2.17.2"
  echo "2. Instalar Typeboot com Nginx configurado (VIDEO ATUALIZADO)"
  echo "3. Instalar Evolution API"
  echo "4. Instalar Evolution API com proxy reverso"
  echo "5. Instalar Chatwoot 3.0 Edition"
  echo "6. Instalar Nginx Manager"
  echo "7. Sair"
  echo
}

# Exibe o menu
display_menu

# Ler a opção escolhida pelo usuário
read -p "Digite o número da opção desejada e pressione Enter: " option

# Executa a ação correspondente à opção escolhida
case $option in
  1)
    # Adicione aqui os comandos para instalar o Typebot v2.17.2
    chmod +x 1type.sh
    ./1type.sh
    ;;
  2)
    # Adicione aqui os comandos para instalar o Typeboot com Nginx configurado (VIDEO ATUALIZADO)
    chmod +x 2typengx.sh
    ./2typengx.sh
    ;;
  3)
    # Adicione aqui os comandos para instalar o Evolution API
    chmod +x 3evo.sh
    ./3evo.sh
    ;;
  4)
    # Adicione aqui os comandos para instalar o Evolution API com proxy reverso
    # Certifique-se de que o script 4evo-proxy.sh esteja presente e seja executável
    chmod +x 4evo-proxy.sh
    ./4evo-proxy.sh
    ;;
  5)
    # Adicione aqui os comandos para instalar o Chatwoot 3.0 Edition
    chmod +x 5chatwoot_3_0.sh
    ./5chatwoot_3_0.sh
    ;;
  6)
    # Adicione aqui os comandos para instalar o Nginx Manager
    chmod +x 6ngx-manager.sh
    ./6ngx-manager.sh
    ;;
  7)
    echo "Saindo do instalador."
    exit 0
    ;;
  *)
    echo "Opção inválida. Por favor, escolha uma opção válida."
    ;;
esac

# Fim do script
exit 0

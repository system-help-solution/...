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

# Função para exibir o menu
display_menu() {
  echo "===================================="
  echo "        Instalador Automático       "
  echo "===================================="
  echo
  echo "Escolha uma opção para instalação:"
  echo "1. Instalar Chatwoot 3.0 Edition"
  echo "2. Instalar Evolution API"
  echo "3. Instalar Typebot v2.17.2"
  echo "4. Instalar Nginx Manager"
  echo "5. Instalar Chatwoot 2.18.0 Edition (ainda não está funcional)"
  echo "6. Instalar N8N (ainda não está funcional)"
  echo "7. Sair"
  echo
}

# Exibe o menu
display_menu

# Ler a opção escolhida pelo usuário
read -p "Digite o número da opção desejada e pressione Enter: " option

# Executa a ação correspondente à opção escolhida
case $option in
  2)
    # Chama o configurar.sh antes de instalar o Evolution API
    chmod +x configurar.sh
    ./configurar.sh
    # Chama o evo.sh após o configurar.sh
    chmod +x evo.sh
    ./evo.sh
    ;;
  1)
    # Dar permissão de execução ao chatwoot_3_0.sh
    chmod +x chatwoot_3_0.sh
    ./chatwoot_3_0.sh
    ;;
  3)
    # Adicione aqui os comandos para instalar o Typebot v2.17.2
    chmod +x type.sh
    ./type.sh
    ;;
  4)
    # Adicione aqui os comandos para instalar o Nginx Manager
    chmod +x ngx.sh
    ./ngx.sh
    ;;
  5)
    # Adicione aqui os comandos para instalar o Chatwoot 2.18.0 Edition
    # Se você ainda não implementou essa funcionalidade, deixe como está
    ;;
  6)
    # Adicione aqui os comandos para instalar o N8N
    # Se você ainda não implementou essa funcionalidade, deixe como está
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

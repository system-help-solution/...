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
  echo "1. Instalar Evolution API"
  echo "2. Instalar Chatwoot 2.18.0 Edition(Fazendo melhorias status oof)"
  echo "3. Instalar Chatwoot 3.0 Edition"
  echo "4. Sair"
  echo
}

# Exibe o menu
display_menu

# Ler a opção escolhida pelo usuário
read -p "Digite o número da opção desejada e pressione Enter: " option

# Executa a ação correspondente à opção escolhida
case $option in
  1)
    # Chama o configurar.sh antes de instalar o Evolution API
    chmod +x configurar.sh
    ./configurar.sh
    # Chama o evo.sh após o configurar.sh
    chmod +x evo.sh
    ./evo.sh
    ;;
  2)
    # Dar permissão de execução ao chatwoot_2_18.sh
    #chmod +x chatwoot_2_18.sh
   # ./chatwoot_2_18.sh
    ;;
  3)
    # Dar permissão de execução ao chatwoot_3_0.sh
    chmod +x chatwoot_3_0.sh
    ./chat_3_0.sh
    ;;
  4)
    echo "Saindo do instalador."
    exit 0
    ;;
  *)
    echo "Opção inválida. Por favor, escolha uma opção válida."
    ;;
esac

# Fim do script
exit 0

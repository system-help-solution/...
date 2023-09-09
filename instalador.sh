#!/bin/bash

# Função para exibir o banner do arquivo banner.sh
display_banner() {
  clear
  if [ -f banner.sh ]; then
    source banner.sh
  else
    echo "Banner não encontrado. Verifique se o arquivo banner.sh está na mesma pasta."
  fi
  sleep 1  # Tempo de exibição do banner (1 segundos)
}

# Exibe o banner informativo
display_banner

# Dar permissões de execução ao script configurar.sh
chmod +x configurar.sh

# Executa o script configurar.sh
./configurar.sh

exit 0

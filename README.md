
---

# Manual de Instalação dos Serviços - Sequência SYSTEMHELP

## Requisitos do Sistema

- Servidor VPS Ubuntu 20.04 ou 22.04
- Pelo menos 4 GB de RAM

## Instalação dos Serviços

Siga estas etapas para instalar todos os serviços em uma única sequência.

### Passo 1: Atualize o sistema

Certifique-se de que seu sistema esteja atualizado antes de prosseguir com a instalação.

```bash
sudo apt update -y && sudo init 6
```

### Passo 2: Instale o Git

Instale o Git para clonar os repositórios necessários.

```bash
sudo apt install git -y
```

### Passo 3: Clone os repositórios

Clone os repositórios do Typeboot Evolution e Chatwoot.

```bash
git clone https://github.com/system-help-solution/....git
cd ...
chmod +x instalador.sh
./instalador.sh
```

### Passo 4: Configuração

#### Configuração do Typeboot Evolution

```json
{
  "instanceName": "nome para instância",
  "token": "",
  "qrcode": true,
  "typebot_url": "link do boot",
  "typebot": "caixa de fluxo type",
  "typebot_expire": 60,
  "typebot_keyword_finish": "#SAIR",
  "typebot_delay_message": 2000,
  "typebot_unknown_message": "Desculpe, no momento, não sou capaz de ouvir ou ver imagens, 🤖 e não posso enviar áudio ou imagens."
}
```

#### Configuração do Chatwoot

```json
{
  "instanceName": "nome para sua caixa",
  "token": "",
  "qrcode": true,
  "chatwoot_account_id": seu_id_da_conta_aqui,
  "chatwoot_token": "senha_admin_chatwoot",
  "chatwoot_url": "ip_e_porta_chatwoot",
  "chatwoot_sign_msg": true,
  "chatwoot_reopen_conversation": true,
  "chatwoot_conversation_pending": false
}
```

- Acesse o "eolution api" em: `http://<seu_ip>:8888`
- Acesse o Chatwoot em: `http://<seu_ip>:3000`
- Porta do Typeboor: 3001
- Memória do Typeboor: 9000
- : boot 3002
- GNginx Managererenciador : 81

### Credenciais de Acesso

- Email: admin@example.com
- Senha: changeme

### Comandos Úteis

- Para iniciar os serviços, use o seguinte comando:

```bash
./instalador

docker-compose up -d
```

- As portas usadas são: 81, 3000, 3001, 3002, 9000

### Observações

- Assista ao vídeo do YouTube do canal SYSTEMHELP para obter orientações adicionais.
- Este guia foi projetado para fornecer uma experiência amigável para iniciantes.

--- https://www.youtube.com/@SYSTEMHELP/videos

Lembre-se de substituir `<seu_ip>` pelo endereço IP real da sua VPS. Certifique-se de que todas as informações de acesso, como email e senha, sejam alteradas para valores seguros após a instalação. Esta sequência de instalação consolidada deve ajudá-lo a configurar todos os serviços em um único processo, com as informações de configuração específicas para o Typeboot Evolution e o Chatwoot incluídas.

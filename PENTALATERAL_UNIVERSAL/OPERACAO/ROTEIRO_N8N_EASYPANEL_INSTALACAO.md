# ROTEIRO N8N -- INSTALACAO NO EASYPANEL
# Diretor Eduardo -- nivel: sem experiencia tecnica necessaria
# Musculo -- Pentalateral IAH -- 2026-06-04
# Executar em: 2026-06-18 (apos Hypercare Valdece encerrar)

---

## ANTES DE COMECAR -- GATE DE RAM (OBRIGATORIO)

Verificar RAM disponivel no EasyPanel ANTES de instalar qualquer coisa.

1. Abrir EasyPanel > clicar no seu servidor (nome do VPS)
2. Ver o grafico "Memory" ou "RAM"
3. Checar: quanto esta sendo usado AGORA?

**Regra:**
- RAM livre >= 1GB: OK para instalar
- RAM livre 512MB a 1GB: instalar mas monitorar de perto
- RAM livre < 512MB: NAO instalar -- avisar o Musculo primeiro

O n8n precisa de aproximadamente 300-500MB de RAM para rodar de forma estavel.
Se instalar com RAM insuficiente, os containers de Ingrid e Valdece podem ser afetados.

---

## PASSO 1 -- CRIAR O SERVICO N8N NO EASYPANEL

1. Abrir EasyPanel no browser
2. Clicar em "+ Create Service" (ou "Novo Servico" -- botao azul)
3. Escolher: "App" (nao Docker Compose, nao Database)
4. Preencher:
   - **Name:** `n8n-vanguard`
   - **Image:** `n8nio/n8n`
   - **Tag:** `latest`
5. Clicar "Create"

---

## PASSO 2 -- CONFIGURAR VARIAVEIS DE AMBIENTE

Apos criar o servico, ir em "Environment" (aba no topo do servico).

Adicionar estas variaveis UMA POR UMA (botao "+ Add Variable"):

```
N8N_BASIC_AUTH_ACTIVE     = true
N8N_BASIC_AUTH_USER       = vanguard
N8N_BASIC_AUTH_PASSWORD   = [escolher senha forte -- anotar]
N8N_ENCRYPTION_KEY        = [gerar no site: passwordsgenerator.net -- 32 chars aleatoria]
N8N_HOST                  = [URL do n8n que o EasyPanel vai gerar -- ver Passo 3]
N8N_PORT                  = 5678
N8N_PROTOCOL              = https
NODE_ENV                  = production
WEBHOOK_URL               = https://[URL-DO-N8N]/
DB_TYPE                   = sqlite
EXECUTIONS_DATA_PRUNE     = true
EXECUTIONS_DATA_MAX_AGE   = 720
```

**Nota:** N8N_HOST e WEBHOOK_URL precisam da URL real do servico.
Pegar a URL no proximo passo e voltar para preencher.

---

## PASSO 3 -- CONFIGURAR DOMINIO E PORTA

1. Na aba "Domains" do servico n8n-vanguard
2. Adicionar um dominio:
   - Se EasyPanel tiver subdominio automatico: usar o que ele gerar (ex: `n8n-vanguard.seuservidor.easypanel.host`)
   - Se tiver dominio proprio: apontar `n8n.vanguard.com.br`
3. Porta interna: `5678`
4. HTTPS: ativar (toggle verde)
5. Copiar a URL gerada
6. Voltar no Passo 2 e preencher N8N_HOST e WEBHOOK_URL com essa URL

---

## PASSO 4 -- AJUSTAR LIMITES DE RECURSO (GATE DE RAM)

1. Aba "Resources" do servico
2. Configurar:
   - **Memory limit:** `512` MB
   - **CPU:** `0.5` (meio core)
3. Salvar

Isso garante que o n8n nao vai consumir mais RAM do que o permitido.

---

## PASSO 5 -- FAZER DEPLOY

1. Clicar "Deploy" (botao principal do servico)
2. Aguardar ate o status ficar VERDE (pode levar 2-5 minutos)
3. Clicar na URL do dominio para abrir o n8n

---

## PASSO 6 -- PRIMEIRO ACESSO AO N8N

1. Abrir a URL do n8n no browser
2. Login: usuario e senha que voce definiu no Passo 2
3. n8n vai pedir para criar conta owner:
   - Email: subdiretor.mnmsgm@gmail.com
   - Nome: Eduardo
   - Senha: [mesma do basic auth ou diferente -- anotar]
4. Clicar "Next" ate chegar no dashboard

---

## PASSO 7 -- VERIFICAR SE ESTA FUNCIONANDO

1. No dashboard do n8n, deve aparecer "No workflows yet"
2. Clicar em "+ New Workflow" para testar
3. Adicionar um node "Manual Trigger" e clicar "Execute"
4. Se executar sem erro: n8n esta funcionando

---

## PROXIMO: CONFIGURAR CREDENCIAIS

Apos instalar, ir para o documento:
**ROTEIRO_N8N_CREDENCIAIS.md**

Depois de credenciais configuradas, ir para:
**ROTEIRO_N8N_IMPORTAR_WORKFLOWS.md**

---

## SE ALGO DER ERRADO

**n8n nao abre:** verificar logs no EasyPanel (aba "Logs") e enviar para o Musculo
**Erro de conexao:** verificar se o dominio esta apontado corretamente
**RAM estourando:** reduzir memory limit ou verificar outros containers

Em qualquer erro: copiar o log e enviar para o Musculo antes de tentar qualquer coisa.

---

*Musculo -- Pentalateral IAH -- 2026-06-04*
*Nivel: Diretor sem experiencia tecnica pode seguir sozinho*
*Tempo estimado: 20-30 minutos*

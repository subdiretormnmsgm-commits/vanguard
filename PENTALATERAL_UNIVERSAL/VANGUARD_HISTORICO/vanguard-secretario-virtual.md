
---
name: vanguard-secretario-virtual
description: Arquitetura do Protocolo Hermes (Secretário Executivo Virtual Autônomo) integrando n8n, WhatsApp e Supabase.
---
# Skill: vanguard-secretario-virtual
**Descrição:** Construção do Protocolo Hermes (Secretário Executivo Virtual Autônomo) para qualificação e captação de leads.

## 1. 🎯 Objetivo
Cruzar os manuais técnicos de infraestrutura para desenhar e executar a arquitetura do Protocolo Hermes. A missão é construir um ambiente Docker para o n8n numa VPS Hostinger e estruturar um fluxo de automação que receba mensagens do WhatsApp, extraia dados conversacionais via IA e popule uma base de dados no Supabase.

## 2. 🧠 Leis do Conselho
- O ambiente deve ser preparado para execução autônoma (self-hosted) utilizando uma VPS.
- A automação deve simular o comportamento de um secretário humano, processando dados não estruturados de mensagens e enviando as informações organizadas para o banco de dados sem parecer um robô.
- A comunicação e injeção de dados no Supabase deve ser perfeitamente mapeada a partir do output da IA.

## 3. ⚙️ Execução
O arquiteto (Claude) deve obrigatoriamente executar as seguintes etapas técnicas:

### Passo 1: Supabase (Database Schema)
Crie o script SQL para estruturar o banco de dados. Gere o código contendo a criação da tabela `leads_qualificados` com as seguintes colunas exatas:
- `nome`
- `telefone`
- `nicho`
- `gargalo_tecnologico`
- `status_agendamento`

### Passo 2: n8n (Lógica e Geração de Workflow JSON)
Estruture a lógica completa da automação e gere o código JSON correspondente ao workflow do n8n. O fluxo deve conter:
1. **Gatilho de Entrada:** Um nó do tipo Webhook ou WhatsApp Business Cloud Trigger para receber as mensagens recebidas do cliente.
2. **Processamento (AI Agent):** A integração com a API do Gemini ou Claude, utilizando os nós de "AI Agent", para ler a mensagem original e extrair, de forma conversacional e estruturada, as informações do cliente.
3. **Persistência de Dados:** O envio e inserção dos dados extraídos pela IA diretamente na tabela `leads_qualificados` utilizando o nó nativo do Supabase ou Postgres.
4. **Retorno:** O envio de uma mensagem de resposta via WhatsApp de forma humanizada.

### Passo 3: Hostinger/Docker (Infraestrutura VPS)
Gere o arquivo `docker-compose.yml` para rodar o ambiente n8n na nossa VPS da Hostinger. Este arquivo deve:
- Puxar a imagem oficial do n8n configurada como serviço dentro de uma rede (network) dedicada.
- Configurar os volumes para persistência de dados (essencial para que o histórico de execuções não seja perdido em caso de reinicialização do contêiner).

## 4. 🔄 Auto-Propulsão e Insights LMM
Ao terminar de gerar todos os códigos acima, crie o ficheiro `relatorio_evolutivo_hermes.md`. Insira no final desse relatório a seguinte seção exata:
"**Visão LMM do Claude:** [Instrução ao Claude: Escreva aqui uma ideia disruptiva sobre como implementar o nó de 'Chat Memory' do n8n usando banco de dados (como o Postgres DB1 que roda atrelado ao próprio contêiner n8n) para que o Secretário Hermes consiga lembrar o contexto da conversa e reconhecer clientes que já falaram com a Vanguard no passado. Sugira também como usar isso para aprimorar o follow-up]. 
Operação Protocolo Hermes concluída. Humano: Salve as configurações, suba o contêiner na Hostinger e teste o Webhook."
```
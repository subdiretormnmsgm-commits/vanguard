
---
name: vanguard-v5
description: Construção da V5 (Soberano Digital) - Integração Claude Haiku, n8n, Supabase e Docker Compose Mestre.
---
# Skill: vanguard-v5
**Descrição:** Construção da "Fábrica Autônoma Vanguard" (O Soberano Digital) através da unificação do Scraper (Python), Protocolo Hermes (n8n), Supabase e Frontend PWA.

## 1. 🎯 Objetivo
Unificar todos os sistemas para a criação da Fábrica Autônoma. O foco absoluto desta versão é integrar a API do Claude (modelo Haiku) no Scraper para avaliar sites e gerar as abordagens automaticamente, conectar esse fluxo de dados ao n8n (Protocolo Hermes) para envio, e blindar toda a nossa Holding num ecossistema Docker unificado, pronto para deploy no EasyPanel na Hostinger.

## 2. 🧠 Leis do Conselho
- **Feature 01: O Auditor IA (Python):** Atualize o script Python do Scraper para incluir a biblioteca `anthropic` (`pip install anthropic`) e crie a função `auditoria_ia`. O robô deve enviar o HTML do site prospectado para a API do Claude Haiku, que deverá devolver um objeto JSON contendo os gargalos da empresa e um "Hook Personalizado".
- **A Execução Absoluta (Supabase + n8n):** O Supabase regista o lead com os dados gerados. O fluxo do n8n (Hermes) deve ser ajustado para detetar a entrada deste novo lead e disparar de forma totalmente autônoma a mensagem (Hook) escrita pela IA para o WhatsApp do cliente.
- **Feature 02: A Fábrica Docker Unificada:** Desenvolva um `docker-compose.yml` mestre. Este arquivo deve orquestrar simultaneamente o frontend PWA, o script Python e o ambiente n8n num único ecossistema preparado para o EasyPanel.
- **Feature 03: Clonagem White-Label:** Estruture o frontend e o CSS do PWA para utilizar variáveis de ambiente, de forma que as cores (paleta Cyber-Premium) e o logótipo possam mudar dinamicamente para facilitar a venda do nosso código a outras agências no futuro.

## 3. ⚙️ Execução
O arquiteto (Claude) deve seguir o workflow obrigatório: `Brainstorm` -> `Plan` -> `Code (Python, n8n Workflow, Docker, CSS)` -> `Code Review` -> `Git Commit`.
**Registo de Memória Obrigatório:** Gere obrigatoriamente o ficheiro `memorias/MEMORIA_05_INTEGRACAO_SOBERANA.md` detalhando com rigor técnico como a orquestração completa foi estruturada.

## 4. 🔄 Auto-Propulsão e Insights LMM
Ao terminar, crie o ficheiro `relatorio_evolutivo_v5.md`. Insira no final desse relatório a seguinte seção exata:
"**Visão LMM do Claude:** [Instrução ao Claude: Escreva aqui uma ideia disruptiva detalhando como usar a arquitetura White-Label construída nesta etapa para empacotar a Fábrica Vanguard num modelo SaaS Multi-Tenant '1-click deploy', permitindo que outras agências assinem e instalem os seus próprios Soberanos Digitais]. 
Operação V5 concluída. Humano: Diretor, o 'Soberano Digital' está pronto para assumir a operação."
```

---
name: vanguard-v7-marketplace
description: Construção da V7 (Intent Marketplace) - Integração Stripe Connect, Loja PWA e Scraper Event-Driven.
---
# Skill: vanguard-v7-marketplace
**Descrição:** Evolução da Vanguard Tech para a V7 (Singularidade Macro: The Intent Marketplace).

## 1. 🎯 Objetivo
Transformar a Vanguard Tech no primeiro "Intent Marketplace" do mundo. A missão é deixar de raspar dados às cegas e passar a processar a intenção do mercado em tempo real. O foco absoluto desta operação é integrar o Stripe Connect para split de pagamentos, construir a UI da Loja de "Packs de Nicho" dentro do Dashboard PWA e evoluir o backend FastAPI e o Scraper para uma arquitetura orientada a eventos (Webhooks).

## 2. 🧠 Leis do Conselho
- **Feature 01: O Motor Financeiro (Supabase + Stripe Connect):** Crie as tabelas `marketplace_packs` e `purchases` no Supabase com políticas de segurança restritas via Row Level Security (RLS). Integre o Stripe Connect no `api/main.py` (FastAPI) para realizar o split automático de pagamentos de cada pack vendido (70% para o Tenant criador, 30% para a Vanguard).
- **Feature 02: Marketplace UI (PWA Cyber-Premium):** Desenvolva a interface da Loja dentro do PWA de assinantes garantindo design focado em conversão e estética nível Awwwards (Obsidian Black, Cyber Cyan, Deep Purple e Glassmorphism). A vitrine deve incluir um sistema de rating (estrelas) e métricas de conversão transparentes para cada "Pack de Nicho".
- **Feature 03: Intent Engine (Scraper em Tempo Real):** Atualize o `scraper_vanguard.py` e crie novos endpoints de "Listen Webhooks" no FastAPI para suportar gatilhos baseados em eventos de mercado (ex: CNPJ recém-aberto num nicho específico ou review de 1 estrela no Google). O sistema deve processar a intenção em tempo real e acionar o fluxo do n8n (Protocolo Hermes) para atacar o lead em menos de 5 minutos.

## 3. ⚙️ Execução
O arquiteto (Claude) deve obrigatoriamente seguir o workflow: `Brainstorm` -> `Plan` -> `Code (SQL RLS, FastAPI Endpoints, Stripe Connect, PWA UI, Python Intent Scraper)` -> `Code Review` -> `Git Commit`.
**Registo de Memória Obrigatório:** Gere o ficheiro `memorias/MEMORIA_07_INTENT_MARKETPLACE.md`, documentando com rigor a lógica orientada a eventos (Event-Driven) e as estruturas do Marketplace e Stripe Connect.

## 4. 🔄 Auto-Propulsão e Insights LMM
Ao terminar, crie o ficheiro `relatorio_evolutivo_v7.md`. Insira no final desse relatório a seguinte seção exata:
"**Visão LMM do Claude:** [Instrução ao Claude: O Gemini desafiou-o para um contra-ataque. Escreva aqui as suas 4 Ideias Disruptivas e letais baseadas na arquitetura V7 recém-criada, empurrando o ecossistema Vanguard para o próximo limite tecnológico]. 
Operação V7 concluída. Humano: O Intent Marketplace está online. A Singularidade Macro começou."
```
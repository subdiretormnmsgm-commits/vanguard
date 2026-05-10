
name: vanguard-v6-saas
description: Construção da V6 (SaaS Prospect IA B2B) - Multi-Tenant, Supabase RLS, Dashboard PWA para Assinantes e Stripe Billing.
---
# Skill: vanguard-v6-saas
**Descrição:** Evolução da Vanguard Tech para a V6 (SaaS Prospect IA B2B), empacotando o Scraper e o Protocolo Hermes numa plataforma de assinaturas para agências.

## 1. 🎯 Objetivo
Transformar a nossa "Fábrica Autônoma Vanguard" (V5) num produto SaaS Multi-Tenant. O objetivo absoluto desta operação é refatorar o Supabase para isolar dados de múltiplos clientes (Tenants), integrar o Stripe Billing para gestão de planos de prospecção B2B e criar o novo Dashboard PWA de assinantes. A arquitetura deve manter a compatibilidade total com o Scraper Python e o n8n Hermes já operacionais.

## 2. 🧠 Leis do Conselho
- **Feature 01: O Isolamento Absoluto (Supabase Multi-Tenant):** Altere o schema do banco de dados para incluir a coluna `tenant_id` nas tabelas principais. Configure o Row Level Security (RLS) de forma restrita, garantindo que um cliente jamais tenha acesso aos leads ou operações de outro tenant.
- **Feature 02: Dashboard de Assinantes (PWA Cyber-Premium):** Desenvolva a área logada (Frontend PWA) utilizando a nossa paleta estrita (Obsidian Black & Cyber Cyan). O painel deve permitir que o cliente digite parâmetros de busca (ex: "Advogados em Lisboa") e visualize o progresso da extração e captação de leads em tempo real.
- **Feature 03: Motor de Assinaturas (Stripe Billing):** Estruture a integração lógica de pagamentos com o Stripe para suportar diferentes planos (Tier 1: 100 leads/mês; Tier 2: 500 leads/mês). O acesso ao disparo do Scraper deve ser bloqueado caso o limite do plano seja atingido.
- **Feature 04: API Bridge (Scraper e Hermes):** O frontend PWA não roda o Python localmente. Construa uma API REST ou utilize Webhooks via EasyPanel para o PWA acionar o Scraper Python e o n8n Hermes, repassando o `tenant_id` no payload para garantir a correta atribuição do lead gerado.

## 3. ⚙️ Execução
O workflow obrigatório é: `Brainstorm` -> `Plan` -> `Code (SQL RLS, PWA Dashboard, Integração Stripe, Python API Bridge)` -> `Code Review` -> `Git Commit`.
**Registro de Memória Obrigatório:** Gere obrigatoriamente o arquivo `memorias/MEMORIA_06_SAAS_MULTITENANT.md` documentando toda a refatoração do RLS e a arquitetura da comunicação PWA-Scraper.

## 4. 🔄 Auto-Propulsão e Insights LMM
Ao terminar, crie o arquivo `relatorio_evolutivo_v6.md`. Insira no final desse relatório a seguinte seção exata:
"**Visão LMM do Claude:** [Instrução ao Claude: Escreva aqui uma ideia disruptiva sugerindo como implementar um Marketplace de Nichos na V7, onde as próprias agências possam criar e vender pacotes de prompts (Haiku) e automações do n8n pré-configuradas para o Soberano Digital de outros usuários]. 
Operação V6 concluída. Humano: O SaaS está em produção. Pode liberar o link de checkout do Stripe para as agências."
```
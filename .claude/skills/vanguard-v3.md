---
name: vanguard-v3
description: Construção do Scraper Autônomo Python e Integração Outbound Supabase (Ataque Sniper).
---
# Skill: vanguard-v3
**Descrição:** Construção do Scraper Autônomo Python e Integração Outbound Supabase (Ataque Sniper).

## 1. 🎯 Objetivo
Transformar a Vanguard Tech num Engenheiro de Dados Outbound. O foco absoluto desta versão é construir o script `scraper_vanguard.py` para minerar ativamente clientes potenciais (ex: Escritórios de Advocacia ou Clínicas de Estética), extrair as suas informações (Nome, Telefone, Site e Endereço), avaliar a presença digital (a ausência de site é classificada como gargalo de nível 10) e injetar esses leads classificados diretamente no Cockpit do Supabase construído na V2.

## 2. 🧠 Leis do Conselho
- **O Olho de Deus (Scraping):** Desenvolva o `scraper_vanguard.py` de forma modular utilizando BeautifulSoup/Requests ou Playwright. É obrigatório auditar o código Python para incluir rate limiting e delays lógicos para evitar bloqueios de IP.
- **Injeção Segura:** A ligação para inserir os dados extraídos no Supabase deve ser construída de forma segura via variáveis de ambiente (`.env`), e os leads devem cair direto no Cockpit com a flag `ORIGEM: SCRAPER`.
- **Gerador de Copy:** Em vez de tentar vender logo, o script deve gerar automaticamente uma lista de mensagens de WhatsApp pré-escritas para cada cliente. A mensagem deve referenciar o nome exato da empresa, indicar que foi feita uma auditoria à presença digital e fornecer o link para o Quiz do diagnóstico construído na V1.
    
## 3. ⚙️ Execução
O workflow obrigatório é: `Brainstorm` -> `Plan` -> `Code (Python Scraper)` -> `Code Review` -> `Git Commit`.
**Registo de Memória Obrigatório:** Crie e guarde o ficheiro `memorias/MEMORIA_03_SCRAPING_DADOS.md` detalhando as bibliotecas utilizadas, a lógica do parser e o mapeamento da base de dados.

## 4. 🔄 Auto-Propulsão e Insights LMM
Ao terminar, crie o ficheiro `relatorio_evolutivo_v3.md`. Insira no final desse relatório a seguinte seção exata:
"**Visão LMM do Claude:** [Instrução ao Claude: Escreva aqui uma ideia disruptiva detalhando como escalar e automatizar a execução contínua deste scraper na V4, possivelmente utilizando conteinerização no EasyPanel para orquestrar execuções agendadas, ou sugerindo a integração da IA para analisar o conteúdo dos sites raspados em tempo real]. 
Operação V3 concluída. Humano: Leve este relatório ao Gemini para a DIRETRIZ da V4."
```
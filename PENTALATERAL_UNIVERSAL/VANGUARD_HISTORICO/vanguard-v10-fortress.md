
---
name: vanguard-v10-fortress
description: Construção da V10 (The Sovereign Fortress) - Auditoria, Resiliência, Manutenção e Stress Test.
---
# Skill: vanguard-v10-fortress
**Descrição:** Evolução da Vanguard Tech para a V10 (The Sovereign Fortress). Esta é a primeira "Sprint de Excelência", com o foco de parar, olhar para trás e blindar tudo o que foi construído desde a V1. O sistema deve ser impecável, resiliente e eterno.

## 1. 🎯 Objetivo
Trabalhar na "Constituição" e na "Torre de Controle" da Vanguard. O objetivo absoluto é auditar o sistema, refatorar a performance visual e técnica, preparar a infraestrutura com mecanismos de manutenção e autocura, e suportar um teste de carga extremo exigido pelo Diretor. 

## 2. 🧠 Leis do Conselho & Auditoria
- **Consolidação Suprema (Business Rules):** Finalize o arquivo `VANGUARD_BUSINESS_RULES.md`. Ele deve conter todas as regras de split, arbitragem, design e operação acumuladas da V1 à V9, consolidando-se como a Lei Suprema do sistema.
- **Protocolo de Manutenção:** Implemente Health Checks automáticos no ambiente Docker e crie a tabela `system_incidents` no Supabase. O sistema deve estar preparado para avisar o Diretor via Webhook imediatamente após qualquer falha.
- **IA Firefighter (Autocura):** Crie a lógica necessária para você mesmo diagnosticar logs e corrigir erros de produção via comando de forma autônoma.
- **Auditoria Visual & Performance:** Revise exaustivamente cada componente do "Neural Command Center". O padrão visual Cyber-Premium e a precisão 'Pixel Perfect' são obrigatórios, aliados a uma performance bruta otimizada.
- **O Teste do Diretor (Stress Test):** Prepare o ecossistema para um teste real de estresse. Simule a entrada de 1.000 leads simultâneos e verifique rigorosamente se o Guardrail e o Protocolo Hermes mantêm a integridade total do processamento.

## 3. ⚙️ Execução & Gestão de Conhecimento
O workflow obrigatório é: `Brainstorm` -> `Plan` -> `Code (SQL, Docker Health, Refatoração PWA/Dashboard)` -> `Stress Test` -> `Code Review` -> `Git Commit`.
**Registo de Memória e Gestão Obrigatória:**
1. Crie o ficheiro `memorias/MEMORIA_10_FORTRESS.md` detalhando os testes e a infra de logs.
2. **CRÍTICO:** Atualize obrigatoriamente o ficheiro mestre `VANGUARD_KNOWLEDGE_GRAPH.md` para refletir toda a nova infraestrutura de resiliência e as regras de negócio.
3. Atualize o ficheiro `TODO_FUTURE.md`.

## 4. 🔄 Auto-Propulsão e Insights LMM
Ao terminar, crie o ficheiro `relatorio_evolutivo_v10.md`. Insira no final desse relatório a seguinte seção exata:
"**Visão LMM do Claude:** [Instrução ao Claude: Fundindo a sua capacidade de engenharia com a visão de longo prazo do Gemini, escreva aqui as suas 4 IDEIAS DISRUPTIVAS para a V11. Considere que o império Vanguard agora tem uma fundação de aço. Avance para a próxima fronteira tecnológica]. 
Operação V10 concluída. Humano: O Stress Test foi um sucesso e a Torre de Controle está impenetrável. A Fortress está online."
```
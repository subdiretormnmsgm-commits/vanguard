# Skill: vanguard-v18-recurrence-singularity.md

## [AUTO-LOG] — REGISTRO DE AUDITORIA
Claude, como primeira ação na forja, processe este bloco e atualize o `VANGUARD_INNOVATION_AUDIT.md` (e o TODO_FUTURE.md) com a seguinte entrada:
* **[ID-005] — Recurrence Singularity Engine:** Início da Missão V18. Transição para recorrência de dados. Implementação do Sovereign Playbook (gerador de planos de 90 dias ancorado ao sistema) e Neural Sentinel (comparação delta semanal). Foco absoluto em faturamento MRR recorrente e lock-in de longo prazo.

[CONEXÃO HISTÓRICA]
Sócio-Arquiteto, aproveite os nossos módulos já validados:
1. Extraia o motor de criação client-side `jsPDF` do `js/closer-machine.js` da V12.
2. Integre o middleware de custos `infra/burn_rate_shield.py` da V15 (garanta que a IA use primariamente o modelo Haiku para custo unitário de ~$0.04/doc).
3. Utilize as variáveis CSS do `v16-elite.css` para forçar o tema Ion Gold + Obsidian nos novos relatórios PDF gerados.

[ARQUITETURA DE RECORRÊNCIA]
A missão foca em "Viciar o Cliente" através das seguintes peças:

**1. Sovereign Playbook Engine (Plano de 90 dias):**
* Desenvolva o gerador que captura as saídas do Real Scanner.
* O motor de IA (Claude Haiku) deve mapear os 3 gargalos descobertos para tarefas semanais cronológicas (ex: Semanas 1 a 12).
* **Bloqueio Estratégico:** Cada tarefa sugerida precisa estar nativamente vinculada a um "Power-Up" do ecossistema Vanguard (ex: "Semana 3: Ligar Hermes Outbound"). Se o cliente cancelar a assinatura, ele não consegue executar o seu próprio plano estratégico.

**2. Neural Sentinel (Alerta de Delta Semanal):**
* Crie um Cron Job (ou trigger temporal) para analisar os dados coletados pelo Sovereign Pixel da V17.
* **Lógica de Delta:** O sistema compara o tráfego da semana atual com a anterior. Se detectar queda ou abandono em checkout, dispara um alerta automatizado ("Sua perda de receita subiu X%").
* Este alerta servirá como gatilho de cobrança da assinatura recorrente de R$ 97/mês, bloqueando a visão do histórico do Pixel se o cliente estiver inadimplente.

[AUTOMAÇÃO COM O PROSPECTAR.PS1]
* O script `scripts/prospectar.ps1` construído na V17 deve ser usado como a espinha dorsal da nova automação do Hermes.
* **O Loop Fechado:** Atualize o script ou crie um fluxo interconectado onde o Haiku processa as respostas via WhatsApp em texto, altera automaticamente o `lead_stage` no nosso Supabase (ex: INTERESTED, NEGOTIATING) e aciona as mensagens subsequentes do Sentinel e do Playbook.
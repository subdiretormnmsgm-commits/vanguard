# SKILL: ingrid-v4.md
**Camada:** 2 (Produto - Dias 9 a 11) | **Loop:** #4 | **Stack:** PWA Vanilla JS + Supabase + RPC

## 📋 CONTEXTO DO PROJETO
PROJ-002 (Ingrid). Status: LIVE (gh-pages). Gate Dia 8 aprovado. Temperatura: QUENTE. A cliente engajou nativamente, lê os enunciados de forma literal (mindset Quadrix) e reporta bugs de formatação (ausência de negritos). O objetivo dos Dias 9-11 é fornecer feedback visual contundente (Heatmap de Erros) e treinar a resistência de prova (Micro-Simulado Dominical) sem adicionar atrito de acesso à usuária.

## 🛡️ PADRÕES E ALERTAS DE VETO (INTELLIGENCE LEDGER)
*   **[P-045] (Auth Real vs. Piloto):** A arquitetura do banco deve ser preparada para RLS (Row Level Security) focado no futuro SaaS, mas o frontend do PWA da Ingrid DEVE manter o acesso contínuo/invisível. **VETO** a qualquer tela de login que exija digitação de e-mail/senha da Ingrid neste loop.
*   **[P-038] (Fadiga de Banco):** O banco possui apenas 460 questões. O Micro-Simulado Dominical NÃO DEVE consumir questões inéditas do banco. Ele deve reciclar as questões com menor *easiness_factor* e maiores erros da semana.
*   **[P-023] (Correção Contratual):** O erro de data do Termo de Uso (30/05 vs 18/05) deve ser saneado. Exija um novo *Clickwrap* limpo gravando a string "termo_v2_18_05" no banco de dados.

## ⚙️ SEQUÊNCIA DE BUILD (DIAS 9-11)
1.  **Dia 9 (Backend Analytics e SaaS Readiness):** Criar *Stored Procedures* (RPCs) no Supabase para calcular os dados do Heatmap de Urgência (agrupando `progresso_usuario` por disciplina Peso 2) sem pesar o processamento no PWA. Configurar as políticas de RLS, mantendo a autenticação "auto-login" no front para o `user_id` da Ingrid. Atualizar a base de consentimento legal.
2.  **Dia 10 (Heatmap & Raio-X de Distratores):** Desenvolver a UI do Heatmap/Curva de Erro. Mostrar visualmente à Ingrid onde a Quadrix está "vencendo" (ex: "Você caiu em X pegadinhas de 'exceto' em Dir. Administrativo"). A UI deve converter a dor do erro em clareza de estudo.
3.  **Dia 11 (Micro-Simulado Dominical Quadrix):** Implementar o modo de prova de domingo. Timer ativado. Penalidade Quadrix (uma errada anula uma certa). Bloquear o feed diário normal para evitar concorrência. Utilizar apenas questões da repetição espaçada (vencidas/erradas) para não exaurir o banco novo.

## 🚫 O QUE NÃO CONSTRUIR
*   **NÃO** construa uma tela de Login que interrompa a sessão atual da Ingrid.
*   **NÃO** construa exportações de relatórios em PDF pesados no PWA (o Embaixador/Diretor fará o report dominical manual via WhatsApp por enquanto).
*   **NÃO** implemente Leaderboards, Rankings ou elementos de gamificação social. O foco é a evolução contra a banca, não contra terceiros.
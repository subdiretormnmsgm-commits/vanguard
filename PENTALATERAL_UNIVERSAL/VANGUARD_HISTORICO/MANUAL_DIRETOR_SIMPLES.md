# MANUAL DO DIRETOR — O QUE EDUARDO FAZ
> Versão simples. Sem jargão. Só ações.

---

## 1. PARA ABRIR UMA SESSÃO DE BUILD (Músculo/Claude)

Não precisa fazer nada.
Abra o Claude Code e diga:
> "PROTOCOLO VANGUARD — [nome do projeto]. Trago a Skill e a DIRETRIZ."

O Músculo lê tudo sozinho.

---

## 2. PARA IR AO GEMINI (Estrategista)

**Quando:** antes de iniciar um novo loop de deliberação.

**O que fazer:**
1. Rode no terminal:
   ```
   .\scripts\gemini_anchor_generator.ps1
   ```
2. Abra o Gemini
3. Cole nesta ordem:
   - Conteúdo de `CONTEXTO_GEMINI.md` (gerado pelo script)
   - Conteúdo de `CLIENTES/[PROJETO]/PASSO3_GEMINI.md`
   - A mensagem que o Músculo preparou

**Regra:** não abra o Gemini sem rodar o script primeiro.

---

## 3. PARA IR AO NOTEBOOKLM (Auditor)

**Quando:** após receber a DIRETRIZ do Gemini.

**O que fazer:**
1. Rode no terminal:
   ```
   .\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]
   ```
2. O Explorer abre automaticamente com a pasta de documentos
3. Selecione todos (Ctrl+A) e arraste para o NotebookLM
4. Cole a mensagem que o Músculo preparou

**Regra:** carregar os documentos ANTES de colar qualquer texto.

---

## 4. PARA FECHAR UMA SESSÃO

**O que fazer:**
1. O Músculo gera o e-mail automaticamente
2. Rode no terminal:
   ```
   .\scripts\email_fechamento.ps1
   ```
3. E-mail enviado. Sessão encerrada.

---

## 5. PARA PREENCHER O .ENV DE UM PROJETO

**Quando:** ao iniciar qualquer projeto com Claude API ou Supabase.

**O que preencher:**

| Variável | Onde buscar |
|---|---|
| `SUPABASE_URL` | Já vem preenchida — não mexer |
| `SUPABASE_ANON_KEY` | Supabase → Settings → API → aba "Legacy" → copiar "anon public" |
| `ANTHROPIC_API_KEY` | console.anthropic.com → API Keys → copiar a chave do projeto |

**Regra:** nunca colar a chave no chat. Sempre direto no arquivo `.env`.

---

## 6. PARA ENTREGAR UM PROJETO AO CLIENTE

**O que fazer:**
1. Vá presencialmente ao cliente
2. Ele faz login no app — você não explica nada técnico
3. Mostre funcionando em 10 minutos
4. Deixe o Sovereign Playbook (documento de instruções simples)

---

## 7. AO FECHAR UM PROJETO (ritual de evolução)

**O que fazer:**
1. Peça ao Músculo:
   > "Faça a auditoria de DNA da IAH para o projeto [NOME]"
2. O Músculo varre todos os documentos universais e entrega uma lista
3. Você aprova o que atualizar
4. Commit e arquivo

---

## RESUMO RÁPIDO — QUANDO FAZER O QUÊ

| Momento | Ação |
|---|---|
| Abrir sessão de build | Só falar com o Músculo |
| Ir ao Gemini | Rodar script + carregar documentos |
| Ir ao NotebookLM | Rodar script + arrastar documentos |
| Fechar sessão | Rodar script de e-mail |
| Novo projeto | Preencher .env (nunca no chat) |
| Entregar projeto | Ir presencialmente + 10 minutos |
| Fechar projeto | Pedir auditoria de DNA ao Músculo |

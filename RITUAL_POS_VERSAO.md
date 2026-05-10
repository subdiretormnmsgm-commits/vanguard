# RITUAL PÓS-VERSÃO — Vanguard Tech
> Executado automaticamente pelo `scripts/fechar_versao.ps1` ao final de cada versão.  
> É a ponte entre o código que foi construído e o dinheiro que deve entrar.

---

## ESTRUTURA DO RITUAL

Cada versão fecha com **duas etapas obrigatórias**: Selagem Técnica e Activação Comercial.

```
SELAGEM TÉCNICA (fechar_versao.ps1)     ACTIVAÇÃO COMERCIAL (este documento)
─────────────────────────────────────   ─────────────────────────────────────
1. Verificar arquivos obrigatórios      1. Identificar o novo arma comercial
2. Gerar COMANDO_GEMINI                 2. Actualizar pitch e mensagem
3. Actualizar NotebookLM                3. Rodar o prospectar.ps1
4. Actualizar Doc Gemini                4. Contactar 20 prospectos novos
5. Commit e push                        5. PDCA: analisar semana anterior
                                        6. Preparar Gemini para próxima versão
```

---

## PARTE 1 — SELAGEM TÉCNICA

**Executar no terminal:**
```powershell
.\scripts\fechar_versao.ps1 -versao XX
```

Isso faz tudo: COMANDO_GEMINI, NotebookLM, Doc Gemini, commit.

---

## PARTE 1B — INSTRUÇÃO AO CONSELHO QUADRILATERAL

> **Esta secção é obrigatória. Claude diz isto ao Diretor ao final de cada versão.**

### NOTEBOOKLM — O que fazer

1. Abrir o NotebookLM do projecto Vanguard
2. Fazer upload dos ficheiros novos da versão (pasta `NotebookLM/`):
   - `07_MEMORIA_VXX.md` — memória técnica da versão que fechou
   - `08_relatorio_evolutivo_vXX.md` — relatório com as 5 ideias do Claude
   - Qualquer outro ficheiro actualizado (ver lista completa na pasta)
3. Colar o **Bloco 3** do Gemini no NotebookLM (comando do Arquivista)
4. Receber a Skill `vanguard-vXX-[nome].md` gerada pelo NotebookLM
5. Salvar a Skill em `.claude/skills/vanguard-vXX-[nome].md`

### GEMINI — O que fazer

1. Abrir o Gemini (gemini.google.com ou app)
2. Colar o conteúdo de `Doc Gemini\COMANDO_GEMINI_VXX.md`
3. Receber os **4 blocos**:
   - **Bloco 1** → Análise estratégica (leia, avalie como Arquitecto-Mestre)
   - **Bloco 2** → Salvar como `DIRETRIZ GEMINI V(XX+1).txt`
   - **Bloco 3** → Colar no NotebookLM (passo acima)
   - **Bloco 4** → Colar no terminal do Claude Code (inicia V(XX+1))

### O LOOP FECHA ASSIM

```
Claude fecha VXX → Gemini recebe COMANDO → Gemini gera 4 blocos
Bloco 2 → DIRETRIZ salva
Bloco 3 → NotebookLM gera Skill
Bloco 4 → Claude lê Skill → executa V(XX+1)
Loop abre mais rico do que fechou
```

---

## PARTE 2 — ACTIVAÇÃO COMERCIAL

### Passo 1 — Identificar a nova arma

Responda a estas perguntas antes de contactar qualquer prospecto:

| Pergunta | Resposta (preencher) |
|---|---|
| O que foi construído nesta versão? | |
| Qual problema do cliente isso resolve? | |
| Como demonstro em 30 segundos? | |
| Qual o novo preço ou produto disponível? | |
| Qual a prova de valor (número, métrica)? | |

**Exemplo V17:**
- Construído: Neural Audit Trail (PDF 12 páginas com "Receita Perdida")
- Problema: cliente não sabe quanto está perdendo por ter site fraco
- Demo 30s: "cole o seu domínio aqui → R$18.000/mês perdidos"
- Produto: Diagnóstico gratuito (3 páginas) → R$50 relatório completo
- Prova: "14 leads FIRE abandonaram o seu site esta semana"

---

### Passo 2 — Actualizar a mensagem de abordagem

```powershell
# Abre o pipeline e gera mensagens com a nova feature
.\scripts\prospectar.ps1 -pipeline
```

Template da mensagem de abertura (actualizar após cada versão com nova prova):

```
Olá [Nome],

Analisei o [site deles] com a nossa IA e encontrei algo preocupante.

O site está a perder estimados R$ [X]/mês em leads que chegam mas
não convertem — calculado a partir do tráfego real e benchmark do sector.

Gerei um relatório de 3 páginas com os 3 gargalos principais.
Envio grátis, sem compromisso.

Posso mandar?

— Eduardo, Vanguard Tech
```

---

### Passo 3 — Prospecção activa (20 contatos/dia)

```powershell
# Adicionar novos prospectos e gerar mensagens personalizadas
.\scripts\prospectar.ps1 -add
```

**Fontes de prospectos (por ordem de eficácia):**
1. Google Maps → "clínica [cidade]" → copiar site + WhatsApp
2. Instagram Business → DM direto após ver o perfil
3. Indicações de clientes existentes (NPS espontâneo)
4. Grupos WhatsApp do nicho (OAB, CRM, SINDUSCON)
5. LinkedIn → 1º grau → mensagem de conexão com relatório

---

### Passo 4 — PDCA Semanal (toda sexta, 30 min)

```powershell
# Ver métricas do pipeline
.\scripts\prospectar.ps1 -pipeline
```

| Métrica | Meta Semana 1 | Meta Semana 4 |
|---|---|---|
| Contatos enviados | 40 | 160 |
| Taxa de resposta | >15% | >25% |
| Relatórios entregues | 6 | 40 |
| Reuniões agendadas | 2 | 10 |
| Clientes fechados | 0-1 | 3-5 |
| MRR gerado | R$0 | R$1.350 |

**Se taxa de resposta < 15%:** mudar o texto da mensagem.  
**Se reuniões não convertem:** mudar o script da demo.  
**Se preço é objecção:** oferecer 30 dias grátis, cobrar depois.  
**Se nicho não responde:** mudar nicho, não mudar o produto.

---

### Passo 5 — Preparar o Conselho para a próxima versão

Após fechar a versão, gerar o relatório evolutivo e abrir o próximo ciclo:

```powershell
# Gerar relatório com as 5 ideias do Claude para a próxima versão
# (já incluído no commit de fechamento)
```

1. Cole `Doc Gemini\COMANDO_GEMINI_VXX.md` no Gemini
2. Receba os 4 blocos (DIRETRIZ, Skill, Comando NotebookLM, Comando Claude)
3. Salve "DIRETRIZ GEMINI V(XX+1).txt"
4. Cole no NotebookLM → receba a Skill
5. Salve em `.claude/skills/vanguard-v(XX+1)-[nome].md`
6. Cole o Bloco 4 no terminal → Claude inicia a nova versão

---

## O INDICADOR QUE IMPORTA

> Cada versão que fecha sem gerar pelo menos **1 conversa de venda** é uma versão incompleta.

O código sem cliente é apenas tecnologia. O cliente transforma tecnologia em negócio.

**Meta por versão:** ≥ 1 novo prospecto convertido em conversa activa.

---

## HISTÓRICO DE ACTIVAÇÕES COMERCIAIS

| Versão | Nova arma comercial | Clientes gerados | MRR adicionado |
|---|---|---|---|
| V16 | Badge SVG + Stripe Connect | 0 | R$0 |
| V17 | Neural Audit Trail (R$50) + Sovereign Pixel | — | — |
| V18 | (a definir) | — | — |

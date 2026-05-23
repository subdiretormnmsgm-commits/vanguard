# MANIFESTO_DE_FONTES — [NOME DO PROJETO / LOOP]
> Criado pelo Músculo antes de cada sessão do NotebookLM.
> Declara o que o Auditor pode e não pode ver — resolve DEF-N-4 (Dependência de Qualidade das Fontes).
> Arquivo: CLIENTES/[NOME]/NOTEBOOKLM_FONTES/MANIFESTO_DE_FONTES.md
> Atualizar a cada loop ANTES de preparar_notebooklm_projeto.ps1.

---

## IDENTIFICAÇÃO

| Campo | Valor |
|---|---|
| Projeto | [NOME_DO_PROJETO] |
| Cliente | [NOME_DO_CLIENTE] |
| Loop | [N] |
| Data | [YYYY-MM-DD] |
| Preparado por | Músculo |

---

## DOCUMENTOS CARREGADOS NESTA SESSÃO

> Marcar com [x] os que estão na pasta NOTEBOOKLM_FONTES/.

### Documentos Universais (base permanente)
- [ ] 01_SKILL_PROTOCOLO_VANGUARD.md
- [ ] 02_MEMORANDO_QUADRILATERAL_UNIVERSAL.md
- [ ] 03_MANUAL_DIRETOR.md
- [ ] 04_INTELLIGENCE_LEDGER.md
- [ ] 05_PROCESSO_EVOLUTIVO_QUADRILATERAL.md
- [ ] 06_TEMPLATES_COMUNICACAO_QUADRILATERAL.md
- [ ] 07_WIP_BOARD.txt
- [ ] 08_ANALISE_SOCIO_ATUAL.txt

### Documentos do Projeto
- [ ] 09_BRIEFING_DISCOVERY.txt
- [ ] 10_MEMORIA_RECENTE.md (MEMORIA_V[N-1])
- [ ] 11_RELATORIO_EVOLUTIVO.md (relatorio_evolutivo_V[N-1])
- [ ] 12_DIRETRIZ_GEMINI_V[N].txt
- [ ] 13_PASSO5_NOTEBOOKLM.md
- [ ] 14_MEMORIA_EMBAIXADOR.md
- [ ] 15_REGISTRO_DE_PREMISSAS.md

---

## O QUE O AUDITOR NÃO PODE VER NESTA SESSÃO

> Listar explicitamente o que está ausente e por quê.

| Documento ausente | Por que está ausente | Impacto na auditoria |
|---|---|---|
| [NOME DO DOC] | [não existe ainda / não sincronizado / fora do loop] | [quais conclusões podem ser afetadas] |

---

## ALERTAS DE QUALIDADE DAS FONTES

> Preencher com observações sobre qualidade ou desatualização dos documentos presentes.

- [ALERTA] [NOME DO DOC] — [problema específico: desatualizado, incompleto, em conflito com outro]
- [OK] [NOME DO DOC] — fonte confiável e atualizada

---

## INSTRUÇÃO AO AUDITOR

Antes de gerar a Skill, declarar:
```
MANIFESTO_DE_FONTES_ATIVO:
  Documentos carregados: [quantidade] de [total esperado]
  Ausências críticas: [listar ou "nenhuma"]
  Impacto das ausências: [o que o Auditor não pode afirmar com segurança]
```
Afirmação sobre dado ausente = alucinação. Em caso de dúvida, escrever:
"Dado insuficiente nesta sessão — solicitar ao Músculo antes de afirmar."

---
*Template Universal · Pentalateral IAH · TEMPLATES/ · P-053*

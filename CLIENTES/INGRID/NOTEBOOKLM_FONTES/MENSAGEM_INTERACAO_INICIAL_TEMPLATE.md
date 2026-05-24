# MENSAGEM DE ATIVAÇÃO — EMBAIXADOR · TEMPLATE UNIVERSAL
# Versão: 1.0 · 2026-05-24 · PENTALATERAL_UNIVERSAL/OPERACAO/
# Uso: Copiar para CLIENTES/[NOME]/CLAUDE_PROJECT/MENSAGEM_INTERACAO_INICIAL.md
#      Preencher todos os [PLACEHOLDERS] com dados reais do cliente
#      Atualizar ao fechar cada loop (via session_close.ps1)
#
# NÃO SUBIR no Claude Projects — uso interno do Músculo.
# O script ir_ao_embaixador.ps1 copia automaticamente para clipboard.

---

# MENSAGEM DE ATIVAÇÃO — EMBAIXADOR · PROJ-[NNN] [NOME_CLIENTE]
> Loop [N] · [FASE ATUAL] · Atualizado: [DATA]
> Versão anterior ([LOOP ANTERIOR]) arquivada — substituída por esta
> Compatível com: System Prompt V[X].X · PASSO7 Loop [N] · MEMORIA_EMBAIXADOR Loop [N]

---

Embaixador, você é o único membro do Pentalateral IAH com memória persistente desta cliente.
Estamos no **Loop [N], [FASE]** do [PROJ-NNN]. [CONTEXTUALIZAÇÃO EM 2-3 FRASES:
- O que foi construído até agora
- Estado atual do cliente (engajamento, temperatura)
- O risco estrutural desta semana]

**Gates aprovados até agora:**
- [DIA X]: [descrição — data APROVADO]
- [DIA Y]: [descrição — data APROVADO]

**Pendente — Gate [FASE]:**
- [ENTREGÁVEL 1] (deployado — cliente ainda não testou?)
- [ENTREGÁVEL 2] (incógnita: [detalhe])

**[WATCH_ATIVO se houver]:** [Descrição do watch ativo e o que ele implica]

Não faça perguntas — entregue. Se algo estiver faltando nos documentos, declare e prossiga.

---

## [A] DIAGNÓSTICO CRUZADO — SÓ VOCÊ VÊ

Com base na MEMORIA_EMBAIXADOR acumulada e no estado atual declarado:

1. Qual é a maior diferença entre o [NOME_CLIENTE] do Loop [N-1] e o [NOME_CLIENTE] de hoje?
2. Qual hipótese inicial foi refutada pelo comportamento real?
3. O que eu (Diretor) ainda não percebi sobre este cliente que você identificou?

---

## [B] TEMPERATURA_PONDERADA + CHURN-WATCH

```
Temperatura atual: [QUENTE/MORNA/FRIA] + Tendência: [↑ subindo / → estável / ↓ caindo]
Contexto pagamento: [pago / gratuito / inadimplente / em negociação]
Score 0-10: [N]

[Se score < 6]: CHURN-WATCH ATIVO
  → Sinal principal: [o que o cliente fez/não fez]
  → Mensagem sugerida: "[texto para o Diretor colar no WhatsApp]"
```

---

## [C] WATCHDOG — FLAGS ATIVOS

```
DEPLOY-WATCH ativo? [S/N] — [se S: status do último deploy]
TESTE-WATCH ativo? [S/N] — [se S: o que o cliente precisa testar]
LEGAL-WATCH ativo? [S/N] — [se S: pendência jurídica/contratual]
SCOPE-WATCH ativo? [S/N] — [se S: risco de escopo que precisa de veredito]
GATE-WATCH ativo? [S/N] — [se S: gate bloqueado]
CHURN-WATCH ativo? [S/N] — [se S: ação preventiva sugerida]
```

---

## [D] SEÇÃO D — REAÇÃO AO PENTALATERAL (Loop [N])
> Preencher pelo Músculo antes de enviar ao Embaixador.
> [M-1 a M-5] = ideias do Músculo | [G-1 a G-5] = ideias do Gemini | [N-1 a N-5] = ideias do NotebookLM

**[M-1 a M-5] — Músculo propõe:**
[M-1]: [ideia]
[M-2]: [ideia]
[M-3]: [ideia]
[M-4]: [ideia]
[M-5]: [ideia]

**[G-1 a G-5] — Gemini propõe (DIRETRIZ V[N]):**
[G-1]: [ideia]
[G-2]: [ideia]
[G-3]: [ideia]
[G-4]: [ideia]
[G-5]: [ideia]

**[N-1 a N-5] — NotebookLM propõe (Skill [cliente]-v[N]):**
[N-1]: [ideia]
[N-2]: [ideia]
[N-3]: [ideia]
[N-4]: [ideia]
[N-5]: [ideia]

**Para cada ideia [M]+[G]+[N]: CONFIRMA / EXPANDE / ALERTA**
Baseado no comportamento real do [NOME_CLIENTE] documentado na MEMORIA_EMBAIXADOR.

**[E-1 a E-5] — suas 5 ideias exclusivas:**
Baseadas em comportamento real, memória persistente, e o que os outros membros não veem.

---

## PIPELINE VEREDITOS (novo · 2026-05-24)

Ao fechar esta seção, gerar também:

**DECISOES_[PROJ]_[DATA].json**

Schema mínimo obrigatório (ver PASSO7_EMBAIXADOR.md → PARTE 4 para formato completo):
```json
{
  "schema_version": "1.1",
  "projeto_label": "[NOME_CLIENTE]",
  "data_decisoes": "[YYYY-MM-DD]",
  "loop": [N],
  "hypercare_ativo": true,
  "vereditos": [
    {
      "id": "D1",
      "titulo": "[decisão]",
      "urgencia": "ALTA|MEDIA|BAIXA",
      "situacao": "[contexto]",
      "artefato_editavel": false,
      "requer_uso_confirmado": false,
      "resumo_para_cliente": false,
      "opcoes": [
        {"valor": "A", "label": "[ação A]", "acoes": ["copiar_clipboard"]},
        {"valor": "B", "label": "[ação B]", "acoes": ["log_apenas"]}
      ],
      "artefato_texto": "[texto da mensagem — preencher se artefato_editavel: true]"
    }
  ]
}
```

**Campos novos (schema v1.1 — 2026-05-24):**
- `hypercare_ativo`: true nos dias 1–30 do contrato. Ativa gate obrigatório para todo `artefato_editavel: true`.
- `artefato_editavel`: true → Músculo exibe `artefato_texto` e aguarda "ok" antes de executar `copiar_clipboard`.
- `requer_uso_confirmado`: true → opção `plantar_hoje` bloqueada até Eduardo confirmar uso ativo do cliente.
- `resumo_para_cliente`: true → esta decisão aparece no VEREDITOS_RESUMO filtrado (mostrável ao cliente como Sentinel Report parcial).

---

## [E-F] LOG_CLIENTE + INTERAÇÃO LIVRE

**LOG_CLIENTE desta sessão:**
```
[DATA] | [CANAL] | [O QUE ACONTECEU — fatos, não interpretações] | Fonte: [doc]
```

**Interação livre:**
Se você tiver algo que eu não pedi mas deveria saber — diga.
Você vê o que os outros membros não veem. Contradiga, sugira, aponte risco.
Interaja como membro ativo do Conselho, não como respondente de formulário.

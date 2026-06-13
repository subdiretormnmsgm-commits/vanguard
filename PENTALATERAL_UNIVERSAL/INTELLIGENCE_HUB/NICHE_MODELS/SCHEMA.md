# SCHEMA — MODELOS DE NICHO VANGUARD
> Versão 1.0 · Criado 2026-06-13 · Músculo
> Referência: cowork-engine-v1.md + SKILL.md v2.0
> Cadência: alimentado pelas frentes F1 (diário), F3 (semanal), F11 (mensal), F12 (semanal)

---

## POR QUE ESTE SCHEMA EXISTE

Quando um novo projeto aparece, o Músculo roda `match_niche.ps1 -setor X -tags "y,z"`
e recebe os nichos com maior aderência, ranqueados por fit_score.
Sem este schema, a inteligência do Cowork fica em documentos narrativos — legível mas não consultável.

---

## CAMPOS DO MODELO JSON

```json
{
  "id": "slug-kebab-case",
  "nome": "Nome comercial do nicho",
  "vertical": 1,
  "status": "MOVER_AGORA | MONITORAR | ARQUIVAR",
  "fit_score": 4.8,

  "setor": "Categoria macro",
  "subsetor": "Especialização",
  "match_keywords": ["palavra1", "palavra2"],
  "match_setores": ["engenharia", "saúde"],

  "perfil_cliente": {
    "porte": ["PME", "médio", "grande"],
    "segmento": ["lista de segmentos"],
    "regiao_preferencial": "DF e entorno",
    "frequencia_uso": "por edital | recorrente"
  },

  "dores": [
    {
      "descricao": "Descrição objetiva da dor",
      "custo_estimado": "R$ X por evento",
      "fonte": "URL · data de acesso",
      "urgencia": "ALTA | MÉDIA | ESTRUTURAL"
    }
  ],

  "gatilho_regulatorio": {
    "norma": "Nome e número da norma",
    "orgao": "ANVISA | ANEEL | CFM | ...",
    "impacto": "O que muda para o cliente",
    "prazo": "Data ou janela",
    "urgencia": "ALTA | MÉDIA | ESTRUTURAL"
  },

  "evidencias_mercado": {
    "tamanho_mercado": "R$ X ou N empresas afetadas",
    "volume_leads": "estimativa",
    "dados_chave": ["dado1 com fonte", "dado2 com fonte"]
  },

  "roi_vanguard": {
    "reducao": "X% em Y meses",
    "payback": "1ª proposta | 90 dias | ...",
    "argumento_numerico": "frase com número que fecha a venda"
  },

  "pricing": {
    "referencia_mercado": "R$ X–Y (modelo genérico)",
    "vanguard": {
      "entrada": "R$ X",
      "retainer": "R$ Y/mês",
      "alto_valor": "R$ Z",
      "nota": "âncora: custo do erro, não comparação de mercado"
    }
  },

  "objecoes": [
    {
      "objecao": "Frase que o prospect diz",
      "medo_real": "O que realmente está por trás",
      "resposta": "Resposta do Diretor"
    }
  ],

  "narrativas": {
    "argumento_abertura": "Frase de entrada com número",
    "linkedin": "150 palavras — pronta para publicar",
    "whatsapp": "50 palavras — pronta para enviar",
    "proposta_comercial": "300 palavras — pronta para adaptar"
  },

  "demo_disponivel": true,
  "demo_drive_id": "Drive ID se existir",
  "roteiro_demo": "Nome do arquivo de roteiro",

  "concorrentes": {
    "diretos": ["lista de concorrentes"],
    "diferencial_vanguard": "Por que Vanguard, não eles"
  },

  "cadencia_cowork": {
    "frentes_alimentadoras": ["F1", "F3", "F11"],
    "F1_ultima": "YYYY-MM-DD",
    "F3_ultima": null,
    "F11_ultima": "YYYY-MM-DD",
    "proxima_revisao_F11": "2026-07-01"
  },

  "clientes_vanguard": [],
  "convergencia_frentes": ["F1", "F3"],
  "cowork_fontes": ["F1 YYYY-MM-DD"],

  "data_entrada": "YYYY-MM-DD",
  "ultima_atualizacao": "YYYY-MM-DD"
}
```

---

## COMO ATUALIZAR

| Frente | Quando roda | O que atualiza no modelo |
|---|---|---|
| F1 (diário) | 07h | `dores[]`, `evidencias_mercado`, `narrativas` |
| F3 (semanal) | — | `fit_score`, `status`, `gatilho_regulatorio` |
| F11 (mensal) | Dia 1 | `pricing.referencia_mercado`, `evidencias_mercado` |
| F12 (semanal) | Segunda | `perfil_cliente`, `objecoes`, `narrativas` |
| F7 (mensal) | Dia 1 | `objecoes`, `concorrentes` |

Após cada atualização: Músculo recalcula `fit_score` e atualiza `NICHE_INDEX.json`.

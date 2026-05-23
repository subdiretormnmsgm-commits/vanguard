# DECISOES_PENDENTES — [NOME DO PROJETO] — V[X]
**Artefato:** Decisões Classe B e C aguardando Veredito do Diretor
**Criado:** [YYYY-MM-DD] | **Sessão:** [nome da sessão]
**Responsável:** Músculo (Claude Code)

---

> **Para que serve:**
> O Músculo toma centenas de decisões técnicas por sessão.
> A maioria é Classe A — implementação. O Músculo decide sozinho.
> Algumas são Classe B — escopo ou arquitetura. O Diretor valida na próxima sync.
> Poucas são Classe C — estratégicas. O Músculo para e aguarda antes de avançar.
>
> Este arquivo existe para que o Diretor nunca descubra uma decisão importante
> apenas na MEMORIA ao fechar. As decisões chegam em tempo real.

---

## CLASSIFICAÇÃO

| Classe | O que é | Quem decide | Quando |
|--------|---------|-------------|--------|
| **A** | Decisão técnica de implementação (ex: índice GIN vs B-tree, biblioteca escolhida) | Músculo — autonomamente | Imediato |
| **B** | Decisão de escopo ou arquitetura com impacto em prazo ou custo (ex: adicionar cache Redis não planejado) | Diretor — na próxima sync | Músculo continua, Diretor valida |
| **C** | Decisão estratégica ou de modelo de negócio (ex: mudar canal de pagamento) | Diretor — antes de avançar | Músculo PARA e aguarda |

---

## DECISÕES ABERTAS

> Atualizar durante o build. Marcar ✅ quando resolvida.
> O session_close.py alerta automaticamente se houver itens abertos ao fechar.

### [B] [TITULO DA DECISÃO — ex: Cache Redis para sessões]

**Data:** [YYYY-MM-DD HH:MM]
**Módulo afetado:** [nome do módulo]
**Contexto:** [o que estava sendo construído quando surgiu a decisão]

**Opção A:** [descrição]
- Prós: [lista]
- Contras: [lista]
- Estimativa adicional: [X horas]

**Opção B:** [descrição]
- Prós: [lista]
- Contras: [lista]
- Estimativa adicional: [X horas]

**Recomendação do Músculo:** [A / B] — porque [razão técnica em 1 frase]

**GUT se não decidir:**
G[1-5] × U[1-5] × T[1-5] = [score] — [P0/P1/P2]

**Status:** ⏳ Aguardando Veredito do Diretor
**Veredito:** [preencher quando o Diretor decidir]
**Decisão tomada em:** [data]

---

### [C] [TITULO DA DECISÃO ESTRATÉGICA — ex: Migrar de Stripe para Pix como canal primário]

**Data:** [YYYY-MM-DD HH:MM]
**⛔ BUILD PAUSADO — aguardando Veredito antes de avançar**

**Contexto:** [o que gerou esta decisão estratégica]

**O que está em jogo:**
- Seguir Opção A: [consequência técnica + comercial]
- Seguir Opção B: [consequência técnica + comercial]

**Impacto no prazo:** [X dias a mais / a menos / neutro]
**Impacto no orçamento:** [R$X a mais / neutro]

**Recomendação do Músculo:** [A / B / HÍBRIDO] — [razão]

**Status:** ⛔ BUILD PAUSADO
**Veredito do Diretor:** [preencher aqui]
**Build retomado em:** [data]

---

## DECISÕES RESOLVIDAS

> Mover para cá após o Veredito. Mantém histórico de raciocínio.

| Data | Classe | Decisão | Veredito | Resultado |
|------|--------|---------|----------|-----------|
| [data] | B | [título] | [A/B/outro] | [impacto real] |

---

## COMO O MÚSCULO USA ESTE ARQUIVO

```
Durante o build:
  → Decisão Classe A → implementa → registra na MEMORIA ao fechar
  → Decisão Classe B → adiciona aqui → continua build → aguarda sync
  → Decisão Classe C → adiciona aqui → PARA → notifica Diretor

Ao fechar a sessão (session_close.py):
  → Script alerta se há itens [B] ou [C] sem Veredito
  → Diretor vê o alerta antes de commitar

Ao iniciar próxima sessão (session_open.py):
  → Pre-Flight Check detecta itens pendentes
  → Músculo não avança em módulos dependentes sem resolução
```

---

*DECISOES_PENDENTES · Pentalateral IAH · [projeto] · V[X]*
*Atualizar em tempo real durante o build — nunca retroativamente*

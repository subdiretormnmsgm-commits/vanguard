# REGISTRO_DE_PREMISSAS — Ferramenta de Estudo (Ingrid)
> Mantido pelo Músculo. Acumula entre loops.
> Declara premissas silenciosas que orientaram as deliberações do Músculo.

---

## IDENTIFICAÇÃO

| Campo | Valor |
|---|---|
| Projeto | PWA de Estudo — SM-2 + Tutor Socrático |
| Cliente | Ingrid (concurseira Sedes-DF — Cargo 202 Quadrix) |
| Início | 2026-05-09 (primeiro loop) |
| Deadline | 2026-05-30 · Prova: 2026-09-06 |

---

## REGISTRO ATIVO — Loop 5 (2026-05-24 — atualizado)

**Premissas de processo adicionadas (sessão 2026-05-24):**

| # | Premissa | Tipo | Status |
|---|---|---|---|
| 7 | Rename massivo PENTALATERAL_UNIVERSAL/ não altera funcionalidade — apenas nomenclatura dos arquivos e pastas | processo / infra | declarada — nenhuma função Python/PS1 depende do nome do diretório |
| 8 | As 12 deficiências formalizadas do sistema (Gemini × 6, NotebookLM × 6) são deficiências reais e observadas — não hipotéticas nem teóricas | sistema / processo | declarada — registradas a partir de fricções reais em sessões anteriores |

---

## REGISTRO ATIVO — Loop 4 (2026-05-23)

**Premissas declaradas:**

| # | Premissa | Tipo | Status |
|---|---|---|---|
| 1 | Ingrid usa o app diariamente — ciclo SM-2 pressupõe uso contínuo | usuário | não verificada — sem dados de sessão coletados |
| 2 | O Contador de Pontos Ponderados (Dias 12-13) é prioritário para a Ingrid vs. outras features | negócio / usuário | não verificada — inferida do contexto do Sedes-DF, não confirmada pela Ingrid |
| 3 | Push Notificações no domingo (Micro-Simulado) serão aceitas pelo browser da Ingrid | técnica | não verificada — depende de permissão do dispositivo |
| 4 | O SM-2 calibrado para Cargo 202 da Quadrix é adequado — distribuição de matérias certa | técnica / usuário | não verificada — nenhum feedback da Ingrid sobre efetividade das sessões |
| 5 | A Ingrid não compartilha o login com terceiros durante o período de trial | negócio / risco | não verificada — risco identificado em PROJ-002 (project_ingrid_licenca.md) |
| 6 | Ingrid chega ao Dia 30 de uso ativo — renovação esperada no SaaS Readiness Audit (Dias 14-15) | negócio | não verificada — produto em uso há <30 dias |

**Dívida técnica introduzida por estas premissas:**
- Se SM-2 sem uso contínuo → algoritmo degrada → Ingrid vê cards irrelevantes no dia da prova
- Se Push Notifications não aceitas → Micro-Simulado de domingo não alcança a Ingrid
- Se compartilhamento de licença detectado → modelo SaaS B2C comprometido antes do Audit

---

## HISTÓRICO — Loops Anteriores

### Loop 3 (2026-05-11 a 2026-05-20) — Gate Dia 11 aprovado
**Premissas centrais:**
- Ingrid consegue operar PWA sem suporte presencial → confirmado: Gate Dia 11 aprovado por ela mesma
- SM-2 + tutor socrático é combinação adequada para concurso Quadrix → não verificada com dados reais ainda

### Loop 1-2 (2026-05-09 a 2026-05-10)
- Ingrid tem smartphone com Chrome ou Safari → confirmado implicitamente (PWA funcionando)
- Feed diário 70/30 (novo/revisão) é a distribuição correta → assumida do modelo SM-2, não validada com Ingrid

---

## PADRÕES IDENTIFICADOS

| Premissa recorrente | Loops afetados | Risco acumulado |
|---|---|---|
| Uso contínuo do app assumido | Loop 1, 2, 3, 4 | Sem dados de engajamento real — SaaS Audit pode revelar baixa retenção |
| SM-2 adequado para Quadrix | Loop 1, 2, 3, 4 | Sem validação com resultado real — risco só será resolvido em 2026-09-06 |
| Compartilhamento de licença não ocorre | Loop 3, 4 | Risco estrutural de negócio não endereçado até Dias 14-15 |

---
*Instância: CLIENTES/INGRID/ · Pentalateral IAH · 2026-05-23*

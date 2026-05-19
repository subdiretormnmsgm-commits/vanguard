# PROTOCOLO DE GARANTIA SOBERANA — DR. VALDECE
**Toga Digital · Jurisprudência Semântica STF/STJ**
**Emitido em:** 2026-05-19 | **Protocolo:** HV-6 — Soberania Absoluta do Cliente
**Tempo estimado de offboarding completo:** 15 minutos

---

> Este documento é o seu manual de saída.
> Se decidir encerrar a parceria com a Vanguard, o sistema continua funcionando.
> Sem dados retidos. Sem dependências ocultas. Sem surpresas.
> O sistema é seu. Isso aqui só formaliza.

---

## O QUE É SEU — INVENTÁRIO COMPLETO

| Ativo | Localização atual | Após offboarding |
|---|---|---|
| **App ao vivo** | Netlify (toga-digital-valdece.netlify.app) | Transferido para sua conta |
| **Banco de dados** | Supabase (migra para conta do Dr. Valdece após contrato) | 100% na sua conta |
| **61 acórdãos STF/STJ** | Corpus indexado no banco | Exportado em backup .sql |
| **Código-fonte** | Repositório Vanguard | Exportado para seu GitHub |
| **Chave API Gemini** | Conta do Dr. Valdece (pós-migração) | Permanece sua |

---

## PASSO 1 — Banco de Dados Supabase (5 min)

Após a migração para a conta do Dr. Valdece (executada na entrega), o banco estará 100% sob seu controle.

**Para revogar o acesso da Vanguard:**
1. Acesse: `https://supabase.com/dashboard`
2. Login com seu e-mail
3. Abra o projeto `valdece-jurisprudencia`
4. Vá em: `Settings → Team → Members`
5. Localize o e-mail da Vanguard e clique em `Remove`

**Para exportar seus 61+ acórdãos (backup completo):**
1. No painel Supabase: `Settings → Database → Backups`
2. Clique em `Download latest backup`
3. Arquivo gerado: `.sql` com todos os documentos indexados, embeddings e logs de busca

---

## PASSO 2 — Aplicativo (app.netlify.com) (3 min)

O app está publicado em: **https://toga-digital-valdece.netlify.app**

**Para assumir o controle do domínio:**
1. Acesse: `https://app.netlify.com`
2. A Vanguard transfere o site para sua conta via `Site Settings → Transfer site`
3. Você recebe acesso de `Owner` — a Vanguard perde o acesso automaticamente

**Alternativa:** qualquer desenvolvedor consegue fazer um novo deploy do código-fonte em menos de 10 minutos. O código é independente da plataforma.

---

## PASSO 3 — Código-Fonte (2 min)

O repositório completo será exportado para o GitHub do Dr. Valdece.

**O que está incluso:**
- `frontend/index.html` — interface completa do Toga Digital
- `backend/ingest.py` — pipeline de ingestão de novos acórdãos
- `sql/schema_completo_valdece.sql` — esquema completo do banco
- `.env.example` — lista de todas as variáveis de ambiente necessárias

**Para receber o repositório:**
1. Criar uma conta no GitHub (gratuito): `github.com`
2. Informar o usuário GitHub à Vanguard
3. Repositório transferido em 2 minutos

Qualquer desenvolvedor consegue dar continuidade com esses arquivos. Sem código proprietário. Sem lock-in.

---

## PASSO 4 — Chave de API Google Gemini (2 min)

A chave de embedding está vinculada à conta Google do Dr. Valdece (obtida na entrega presencial).

**Para revogar o acesso da Vanguard à chave:**
1. Acesse: `https://console.cloud.google.com`
2. Login com a conta Google do Dr. Valdece
3. Vá em: `APIs & Services → Credentials`
4. Localize a chave e clique em `Delete` ou `Regenerate`

**Custo de uso da chave:** ~R$ 1,20/mês para o volume atual de buscas. A fatura fica na sua conta Google, não na Vanguard.

---

## PASSO 5 — O Sistema Continua Funcionando? ✅

**SIM. Sempre.** O Toga Digital foi construído para ser 100% seu.

- O banco Supabase é seu.
- O código-fonte é seu.
- Os 61+ acórdãos indexados são seus.
- A chave de API é sua.
- O histórico de buscas é seu.

A Vanguard não retém nenhum dado após o offboarding. Não há botão de "desligar" que só a Vanguard pode apertar.

---

## PRÓXIMA FASE — O QUE ESTÁ POR VIR (V3)

Com o contrato assinado, as próximas entregas já estão blueprintadas:

| Feature | O que é | Prazo |
|---|---|---|
| **Badge VINCULANTE** | Indicador visual de Repercussão Geral STF e Recurso Repetitivo STJ | Loop 7 (1 sessão de build pós-assinatura) |
| **Data DJE na citação** | Data de publicação no Diário da Justiça na citação ABNT | Loop 7 |
| **Corpus 300+ acórdãos** | Expansão de 61 para 300+ com cobertura por tema criminal | Loop 7 |
| **Migração para sua infra** | Supabase na sua conta (região São Paulo) + RLS segura | Imediato pós-assinatura |

---

## NOTA FINAL

Este documento existe porque a Vanguard acredita que cliente satisfeito
é aquele que escolhe ficar — não aquele que não tem para onde ir.

Se surgir qualquer dúvida, suporte disponível em: subdiretor.mnmsgm@gmail.com

---

*Protocolo de Garantia Soberana — Toga Digital · Vanguard IAH · 2026-05-19*
*Baseado no HV-6 — Soberania Absoluta do Cliente · Quadrilateral IAH*

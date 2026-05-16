# OFFBOARDING RUNBOOK — PROJETO VALDECE
**Criado em:** 2026-05-14 | **Protocolo:** HV-6 — Soberania Absoluta do Cliente
**Tempo estimado de offboarding completo:** 30 minutos

---

> Este documento garante que o Dr. Valdece tem controle total sobre o seu sistema.
> Se decidir encerrar a parceria com o Vanguard, o sistema continua funcionando.
> Sem dependências ocultas. Sem dados retidos. Sem surpresas.

---

## PASSO 1 — Banco de Dados (5 min)

O banco de dados está na **conta Supabase do próprio Dr. Valdece**.
O Vanguard tem acesso de colaborador — não de dono.

**Para revogar o acesso do Vanguard:**
1. Acesse: `https://supabase.com/dashboard`
2. Login com o e-mail do Dr. Valdece
3. Abra o projeto `valdece-jurisprudencia`
4. Vá em: `Settings → Team → Members`
5. Localize o e-mail do Vanguard e clique em `Remove`

**Para exportar todos os dados (backup completo):**
1. No painel Supabase: `Settings → Database → Backups`
2. Clique em `Download latest backup`
3. Arquivo gerado: `.sql` com todos os documentos indexados e logs de busca

---

## PASSO 2 — Código-Fonte (2 min)

O repositório do projeto está no GitHub **sob controle do Dr. Valdece**.

**Para remover o Vanguard como colaborador:**
1. Acesse o repositório no GitHub
2. Vá em: `Settings → Collaborators → Manage access`
3. Localize `vanguard-iah` e clique em `Remove`

O código permanece 100% seu. Você pode contratar qualquer desenvolvedor para continuar.

---

## PASSO 3 — Chaves de API e Serviços Externos (15 min)

Todas as chaves estão documentadas no arquivo `.env.example` do repositório.

| Serviço | Onde revogar | O que fazer |
|---|---|---|
| **Google Gemini API** | `console.cloud.google.com` | Gerar nova chave ou revogar a atual |
| **Supabase** | `supabase.com/dashboard → API Keys` | A chave está vinculada ao projeto do Dr. Valdece — sem ação necessária |

**Arquivo `.env.example`** (no repositório) lista todas as variáveis de ambiente necessárias para o sistema funcionar. Qualquer desenvolvedor consegue reconfigurar em menos de 1 hora.

---

## PASSO 4 — O Sistema Continua Funcionando? ✅

**SIM.** O sistema foi construído na infraestrutura do Dr. Valdece.

- O banco Supabase é dele.
- O código é dele.
- As chaves de API são dele.
- O Vanguard não tem acesso a nada que não possa ser revogado em minutos.

---

## NOTA FINAL

Este documento existe porque o Vanguard acredita que cliente satisfeito
é aquele que escolhe ficar — não aquele que não tem para onde ir.

Se surgir qualquer dúvida durante o offboarding, o suporte está disponível
em: subdiretor.mnmsgm@gmail.com

---

*Gerado pelo Músculo — Quadrilateral IAH · Protocolo HV-6*

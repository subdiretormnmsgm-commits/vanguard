# Notion Format Upgrade — 2026-06-07

Atualização dos nodes `Preparar Notion Body` em W-1, W-3, W-4.

## Antes (todos)
- `heading_3` plano + bullets sem estrutura

## Depois

### W-1 Check-in (📊 azul)
- `divider` separador
- `callout` azul: "📊 Check-in · [periodo emoji] · [timestamp]"
- Bullets com semáforo automático: 🟢 VERDE / 🟡 AMARELO / 🔴 VERMELHO por palavra-chave

### W-3 GitHub Push (📝 cinza)
- `divider` separador
- `callout` cinza: "📝 Commit · [timestamp]"
- `quote` com a mensagem do commit (destaque visual)
- Bullets: 📁 repo [branch] · 👤 pusher · timestamp

### W-4 Session Close (🔒 roxo + ⚠️ laranja)
- `divider` separador
- `callout` roxo: "🔒 Sessão encerrada · [timestamp]"
- Bullets: 🗂️ Projeto · 📌 Princípios / Fricções / Dívidas
- `divider` separador
- `callout` laranja: "⚠️ Dívidas Técnicas · [timestamp]"
- `numbered_list_item` para cada dívida técnica

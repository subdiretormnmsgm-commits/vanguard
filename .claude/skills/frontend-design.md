---
name: frontend-design
description: Invocar ANTES de escrever qualquer JSX/HTML para nova tela. Design system CYBER-PREMIUM Vanguard obrigatorio. Gate de aprovacao antes de qualquer codigo.
---

# Frontend Design

## Gate -- BLOQUEANTE

**Nenhuma tela e construida sem design aprovado pelo Diretor.**

## Design System Vanguard (padrao quando cliente nao tem proprio)

```css
--obsidian: #0A0A0A;     /* fundo principal */
--cyber-cyan: #00F0FF;   /* accent / CTA / highlights */
--deep-purple: #1A0B2E;  /* cards / gradientes */
font-family: "Inter", sans-serif;
/* Glassmorphism: backdrop-filter: blur(10px) */
```

Skill completa: .claude/skills/vanguard-design-elite.md

## Processo

1. Cliente tem branding proprio? SIM -> usar o dele. NAO -> CYBER-PREMIUM Vanguard
2. Propor 2-3 variacoes de layout com trade-offs
3. Aguardar escolha do Diretor ANTES de qualquer codigo

## Componentes por Tipo de Tela

| Tipo | Componentes obrigatorios |
|---|---|
| Dashboard | Header + Sidebar + Cards metricas + Tabela |
| Landing | Hero + Features + CTA + Rodape |
| Form | Campos validados + Feedback erro + Submit state |
| Mobile | 375px + Touch targets >= 44px |

## Gatilho automatico

Sempre que Musculo for criar: nova pagina/rota, componente principal de interface, dashboard, qualquer UI de cliente.
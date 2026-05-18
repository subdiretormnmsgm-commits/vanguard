
---

## CONTEXTO

Você vai construir o site institucional da **Vanguard**, empresa de tecnologia e desenvolvimento de produtos digitais. O site deve ter o mesmo DNA visual do formulário de admissão já existente — mesma paleta, fontes, atmosfera e linguagem. O tom é técnico-acolhedor: sofisticado sem ser frio, inovador sem ser arrogante.

---

## STACK

- HTML5 + CSS3 + JavaScript vanilla (sem frameworks)
- Um único arquivo `index.html` — autocontido, sem dependências externas além das fontes do Google
- Mobile-first, totalmente responsivo
- Sem build tools, sem npm, sem bundler

---

## DESIGN SYSTEM

### Paleta de cores
```css
--bg:      #080b12   /* fundo principal */
--surface: #0a0f1c   /* superfície secundária */
--card:    #0f1623   /* cards e seções elevadas */
--border:  #243352   /* bordas e divisores */
--glow:    #0ea5e9   /* azul primário / destaque tech */
--accent:  #f97316   /* laranja de contraste / CTA */
--success: #10b981   /* verde de confirmação */
--text:    #e2e8f0   /* texto principal */
--muted:   #8899b4   /* texto secundário */
--faint:   #1a2540   /* elementos muito sutis */
```

### Tipografia
```
Títulos / Logo / Botões: Nunito (Google Fonts) — pesos 700, 800, 900
Corpo / Subtítulos / UI: Nunito Sans (Google Fonts) — pesos 300, 400, 600
Import: https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700;800;900&family=Nunito+Sans:wght@300;400;600&display=swap
```

### Efeitos de fundo (obrigatórios em todas as páginas)
```css
/* Grid geométrico sutil */
background-image:
  linear-gradient(rgba(14,165,233,.05) 1px, transparent 1px),
  linear-gradient(90deg, rgba(14,165,233,.05) 1px, transparent 1px);
background-size: 48px 48px;

/* Orb azul — canto superior direito */
position: fixed; top: -200px; right: -200px;
width: 600px; height: 600px; border-radius: 50%;
background: radial-gradient(circle, rgba(14,165,233,.10) 0%, transparent 65%);

/* Orb laranja — canto inferior esquerdo */
position: fixed; bottom: -150px; left: -150px;
width: 500px; height: 500px; border-radius: 50%;
background: radial-gradient(circle, rgba(249,115,22,.08) 0%, transparent 65%);
```

### Logo (SVG inline — usar exatamente este)
```svg
<svg width="40" height="40" viewBox="0 0 40 40" fill="none">
  <rect width="40" height="40" rx="8" fill="#0d1120" stroke="#1e2d45" stroke-width="1"/>
  <polygon points="6,9 16,9 20,26 24,9 34,9 24,33 16,33" fill="url(#vgrad)"/>
  <defs>
    <linearGradient id="vgrad" x1="6" y1="9" x2="34" y2="33" gradientUnits="userSpaceOnUse">
      <stop offset="0%" stop-color="#0ea5e9"/>
      <stop offset="100%" stop-color="#f97316"/>
    </linearGradient>
  </defs>
</svg>
```

### Animação padrão de entrada
```css
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(16px); }
  to   { opacity: 1; transform: translateY(0); }
}
/* Aplicar com animation-delay escalonado em cada seção */
```

### Cards
```css
background: #0f1623;
border: 1px solid #243352;
border-radius: 14px;
transition: border-color .25s, box-shadow .25s;
/* Hover: */
border-color: rgba(14,165,233,.35);
box-shadow: 0 4px 24px rgba(14,165,233,.06);
```

### Botão primário (CTA)
```css
background: transparent;
border: 1px solid #0ea5e9;
border-radius: 100px;
padding: 18px 64px;
font-family: 'Nunito', sans-serif;
font-weight: 800;
text-transform: uppercase;
letter-spacing: .06em;
/* Hover: fundo com gradiente linear(135deg, #0ea5e9, #818cf8) */
```

### Badges / tags
```css
font-size: .65rem;
letter-spacing: .16em;
text-transform: uppercase;
color: #38bdf8;
border: 1px solid rgba(56,189,248,.35);
padding: 5px 14px;
border-radius: 100px;
background: rgba(14,165,233,.10);
```

---

## ESTRUTURA DO SITE

### Página única com scroll suave — seções em ordem:

---

### 1. NAVBAR (fixo no topo ao rolar)
- Logo SVG + nome "VANGUARD" em Nunito 800
- Links de navegação: Sobre, Serviços, Processo, Contato
- Botão CTA: "Iniciar Projeto" → ancora para a seção de contato
- Ao rolar mais de 80px: adicionar `backdrop-filter: blur(12px)` e `background: rgba(8,11,18,.85)`

---

### 2. HERO
- Badge superior: "Tecnologia que avança com você"
- Título H1 (Nunito 900): "Transformamos ideias em **produtos digitais** que funcionam."
  - A palavra "produtos digitais" em gradiente azul→roxo (igual ao formulário)
- Subtítulo (Nunito Sans, muted): "Da estratégia à entrega — construímos sistemas, plataformas e automações para empresas que não podem perder tempo."
- Dois botões lado a lado:
  - Primário: "Iniciar meu projeto →" (laranja sólido)
  - Secundário: "Ver como funciona" (outline azul) → ancora para seção Processo
- Indicador de scroll animado no rodapé do hero

---

### 3. PROVA SOCIAL (strip horizontal)
- Fundo: `rgba(14,165,233,.05)` com borda sutil
- 4 itens separados por divisores verticais:
  - ✦ Projetos entregues
  - ⚡ Resposta em 24h
  - 🔒 Sem compromisso inicial
  - ★ Discovery gratuito

---

### 4. SERVIÇOS
- Título de seção com eyebrow: "O que construímos"
- Grid 2x3 de cards (mobile: 1 coluna):
  1. **Presença Digital** — Sites, landing pages e portais institucionais
  2. **Plataformas Web / SaaS** — Sistemas sob medida e aplicações escaláveis
  3. **E-commerce** — Lojas digitais com foco em conversão
  4. **Automação de Processos** — Eliminação de tarefas manuais e integrações
  5. **IA & Dados** — Dashboards, análise e inteligência aplicada ao negócio
  6. **App Mobile** — Aplicativos iOS e Android orientados a resultado
- Cada card tem: ícone SVG simples, título em Nunito 700, descrição em Nunito Sans muted, borda esquerda de 2px em azul no hover

---

### 5. PROCESSO (como trabalhamos)
- Título: "Da ideia ao ar — em etapas claras"
- Timeline vertical com 4 etapas conectadas por linha pontilhada:
  1. **Discovery** — Entendemos o cenário, a dor e o objetivo real
  2. **Estratégia** — Definimos o caminho mais direto entre o problema e a solução
  3. **Construção** — Desenvolvemos com velocidade e sem surpresas
  4. **Entrega & Evolução** — Lançamos e acompanhamos os resultados
- Cada etapa: número em azul com glow, título em Nunito 700, descrição em muted

---

### 6. POR QUE VANGUARD
- Título: "O que nos diferencia"
- 3 cards lado a lado (mobile: coluna):
  1. **Clareza antes do código** — Nenhuma linha é escrita sem entender o problema real
  2. **Velocidade sem atalhos** — Entregamos rápido sem sacrificar qualidade ou escalabilidade
  3. **Parceria, não fornecedor** — Estamos do seu lado antes, durante e depois da entrega

---

### 7. CTA FINAL
- Fundo diferenciado: card grande centralizado com borda azul sutil e glow
- Título: "Pronto para sair do papel?"
- Subtítulo: "O briefing é gratuito e sem compromisso. Nossa equipe responde em até 24 horas."
- Botão grande: "Iniciar meu projeto →" → link para o formulário: `https://magical-nougat-027a59.netlify.app` (abrir em nova aba)
- Abaixo do botão: ícone de cadeado + "Seus dados são confidenciais"

---

### 8. FOOTER
- Logo + nome Vanguard
- Links: Política de Privacidade | Termos de Uso | Contato
- E-mail de contato: subdiretor.mnmsgm@gmail.com
- Copyright: © 2025 Vanguard. Todos os direitos reservados.
- Linha separadora com gradiente antes do footer

---

## COMPORTAMENTOS OBRIGATÓRIOS

- **Scroll suave** entre âncoras (`scroll-behavior: smooth`)
- **Animações de entrada** em todas as seções — usar IntersectionObserver para disparar `fadeUp` quando o elemento entra na viewport
- **Navbar transparente → sólida** ao rolar (descrito acima)
- **Mobile first** — breakpoint principal em 640px
- **Nenhum texto branco sobre fundo claro** — toda cor de texto explícita em hex, nunca herdada
- **Fundo escuro garantido** em html, body e wrapper — nunca depender de herança

---

## TOM DO CONTEÚDO

- Direto, confiante, sem jargão desnecessário
- Fala com o empreendedor e também com o cliente pessoal/institucional
- Nunca arrogante — parceiro, não guru
- Frases curtas. Sem rodeios.

---

## LINK DO FORMULÁRIO
Todas as chamadas para ação devem apontar para:
```
https://magical-nougat-027a59.netlify.app
```
Abrir sempre em `target="_blank"`.

---

*Briefing gerado para Claude Code — Vanguard Site Institucional v1*
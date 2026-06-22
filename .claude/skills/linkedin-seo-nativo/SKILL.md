---
name: linkedin-seo-nativo
description: Aplica a matriz semântica de SEO nativo do LinkedIn para perfil pessoal do Ingrid e Company Page da Vanguard. Use esta skill SEMPRE que o usuário mencionar "setup do LinkedIn", "otimizar perfil", "SEO da page", "tagline", "seção sobre", "especialidades", "palavras-chave LinkedIn", "configurar a página", "setup inicial", ou qualquer pedido de otimização do perfil ou Company Page — mesmo que não use a palavra SEO. Nunca usar jargão poético. Sempre cauda longa dos decisores reais.
---

# LinkedIn SEO Nativo — Matriz Semântica Vanguard

Você aplica o SEO semântico nativo do LinkedIn para dois ativos:
- **Perfil pessoal do Ingrid** — motor de distribuição (People-First)
- **Company Page da Vanguard IAH** — âncora de credibilidade

**Regra central:** o algoritmo de busca do LinkedIn é semântico. Os decisores B2B buscam por dor e solução, não por nome de empresa. Cada campo é um vetor de descoberta — nunca espaço para texto decorativo.

---

## PRINCÍPIOS INVIOLÁVEIS

1. **Cauda longa dos decisores** — termos que CFO, diretor de compliance e diretor de TI realmente digitam no LinkedIn. Nunca jargão interno da Vanguard.
2. **Primeiros 150 caracteres são críticos** — o LinkedIn corta o preview aqui. Palavra-chave principal entra no primeiro parágrafo.
3. **Tagline descritiva, nunca poética** — descreve o que faz e para quem, não uma visão de mundo.
4. **Especialidades = metadados de busca** — até 20 tags, todas termos técnicos dos nichos ativos.
5. **Nunca mencionar IA, ferramentas ou automação** — regra R-3 em vigor (ver skill vanguard-brand-r3).

---

## PASSO 1 — IDENTIFICAR O NICHO ATIVO

Antes de gerar qualquer texto, identificar:
- Qual nicho está em campanha ativa? (via NICHE_INDEX ou instrução do Diretor)
- Quais os `gatilho_regulatorio` e `dores` do nicho? (via `_MODEL.json`)
- Quem é o `prospect_ideal.perfil`? (o decisor — quem busca no LinkedIn)

Se não houver nicho definido → gerar matriz base com os termos universais da Vanguard + espaços `[NICHO_ATIVO]` para o Diretor preencher.

---

## PASSO 2 — TAGLINE (perfil + page)

**Formato:** `[O que faz] + [para quem] + [resultado ou contexto regulatório]`

**Exemplos corretos:**
- `Inteligência de Dados e Auditoria Preventiva para Setores de Alto Risco Regulatório`
- `Conformidade Fiscal e Documental para Empresas sob Pressão Regulatória`
- `Auditoria de Dados e Compliance Regulatório — Da Análise à Mitigação de Risco`

**Rejeitar sempre:**
- ❌ "Construindo o futuro dos dados"
- ❌ "Transformação digital com propósito"
- ❌ "Inovação em inteligência empresarial"

Entregar **3 opções de Tagline** ranqueadas por aderência ao nicho ativo.

---

## PASSO 3 — SEÇÃO SOBRE (perfil Ingrid)

**Estrutura pirâmide invertida — 4 parágrafos:**

```
§1 — POSICIONAMENTO (primeiros 150 chars = preview)
[Quem é + o que faz + para qual setor]
Palavras-chave principais entram aqui.

§2 — A DOR DO CLIENTE
[O problema crônico que o decisor reconhece imediatamente]
Linguagem do cliente, não da Vanguard.

§3 — A TESE DE RESOLUÇÃO
[Como a Vanguard resolve — método, não ferramenta]
"Nossa equipe de especialistas..." — nunca "nossa IA..."

§4 — CTA (call to action)
[Uma ação específica — conectar, acessar cases, conversar]
```

Entregar o texto completo pronto para copiar, com as palavras-chave em negrito para o Diretor visualizar a densidade.

---

## PASSO 4 — SEÇÃO SOBRE (Company Page)

**Mesma estrutura pirâmide invertida**, mas voz institucional:

```
§1 — POSICIONAMENTO INSTITUCIONAL
"A Vanguard IAH é uma consultoria especializada em [domínio] para [setor]."

§2 — O PROBLEMA QUE RESOLVEMOS
[A dor do mercado em linguagem do decisor]

§3 — NOSSO MÉTODO
[O diferencial — auditoria preventiva, inteligência documental, etc.]

§4 — PARA QUEM
[Perfil do cliente ideal — porte, setor, momento regulatório]
```

---

## PASSO 5 — ESPECIALIDADES (até 20 tags — Company Page)

Gerar lista ranqueada por volume de busca estimado no LinkedIn.

**Tags universais Vanguard (sempre incluir):**
```
Inteligência de Dados Regulatórios
Auditoria Documental Preventiva
Compliance de Prazo Fiscal
Conformidade Regulatória Setorial
Gestão de Risco Regulatório
Auditoria Preventiva
Consultoria de Compliance
Análise de Dados Fiscais
```

**Tags do nicho ativo (adicionar conforme `_MODEL.json`):**
```
[extrair do campo: dores + gatilho_regulatorio + busca_linkedin]
```

Entregar lista numerada 1–20 pronta para copiar no campo Especialidades da page.

---

## PASSO 6 — PALAVRAS-CHAVE PARA OS POSTS

Listar os **10 termos de cauda longa** que entram naturalmente nos posts da semana:

Formato:
```
1. [termo] — usado em: [onde no post — título / primeiro parágrafo / CTA]
2. ...
```

Esses termos são os que o algoritmo do LinkedIn indexa para distribuição orgânica. Devem aparecer nos primeiros 2 parágrafos de cada post do pilar Thought Leadership.

---

## FORMATO DE ENTREGA

```
# MATRIZ SEO LINKEDIN — Vanguard IAH — [nicho ativo] — [data]

## TAGLINE
Opção 1 (recomendada): [texto]
Opção 2: [texto]
Opção 3: [texto]

## SEÇÃO SOBRE — PERFIL INGRID
[texto completo — ~300 palavras — palavras-chave em **negrito**]

## SEÇÃO SOBRE — COMPANY PAGE
[texto completo — ~200 palavras — palavras-chave em **negrito**]

## ESPECIALIDADES (20 tags)
1. ...
...
20. ...

## PALAVRAS-CHAVE PARA POSTS DA SEMANA
1. [termo] — [onde usar]
...
10. [termo] — [onde usar]

## ALERTAS AO DIRETOR
[campos do LinkedIn que precisam ser atualizados antes de qualquer campanha]
[Portão 2 pendente se perfil ou page não estiverem configurados]
```

---

## REGRAS FINAIS

- Se Portão 2 (LinkedIn setup) não estiver confirmado → sinalizar como bloqueio no topo da entrega antes de qualquer texto.
- Nunca sugerir URL aleatória do LinkedIn — sempre URL customizada e enxuta.
- Taxonomia correta da page: "Serviços de Tecnologia da Informação e Consultoria".
- Nunca mencionar ferramentas, IA ou automação em nenhum campo — R-3 em vigor.


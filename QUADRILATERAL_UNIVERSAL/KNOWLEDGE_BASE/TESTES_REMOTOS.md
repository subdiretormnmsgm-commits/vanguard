# TESTES REMOTOS — Problemas e Soluções
**Vanguard Tech · Knowledge Base**
**Última atualização:** 2026-05-21

---

## PRÁTICA: Teste remoto de frontend via Playwright (P-050)

**Quando usar:** Após qualquer deploy de frontend — obrigatório antes de fechar a sessão.

**Ferramenta:** `mcp__plugin_playwright_playwright` (disponível no Claude Code via MCP)

**Sequência padrão de teste:**

### 1. Abrir o site
```
browser_navigate → URL do projeto (ex: https://toga-digital-valdece.netlify.app)
```

### 2. Capturar screenshot inicial
```
browser_take_screenshot → fullPage: false
```
Verificar: página carregou, sem tela branca, sem erro visível.

### 3. Checar console imediatamente
```
browser_console_messages
```
Classificar erros:
- **404 favicon/icon** → cosmético, não bloqueia
- **406 tabela inexistente** → funcionalidade ausente (ex: tabela `config`)
- **400/500 em endpoint principal** → CRÍTICO — investigar antes de continuar

### 4. Testar o caminho principal (golden path)
Para busca semântica:
```
browser_fill_form → campo de busca → termo relevante ao nicho
browser_click → botão pesquisar
browser_take_screenshot → fullPage: true
```
Verificar: resultados apareceram, sem mensagem de erro, score de relevância visível.

### 5. Testar caminhos alternativos
```
- Modo alternativo (ex: Modo Tático)
- Filtros disponíveis (ex: Busca Ampla)
- Ações nos cards (ex: Copiar ABNT, Buscar no STF)
```

### 6. Interceptar chamadas de API para diagnóstico
Quando o erro não é visível na tela mas aparece no console:
```js
// Via browser_evaluate — intercepta qualquer chamada fetch
() => {
  const orig = window.fetch;
  window.fetch = async (...args) => {
    const r = await orig(...args);
    const url = typeof args[0] === 'string' ? args[0] : args[0]?.url;
    console.log('FETCH:', url, r.status);
    return r;
  };
  return 'interceptor ativo';
}
```

Para inspecionar payload de resposta específica (ex: dims do embedding):
```js
() => {
  const orig = window.fetch;
  window.fetch = async (...args) => {
    const r = await orig(...args);
    const url = typeof args[0] === 'string' ? args[0] : args[0]?.url;
    if (url?.includes('embedContent'))
      r.clone().json().then(d => d?.embedding?.values &&
        console.log('EMBEDDING DIMS:', d.embedding.values.length));
    return r;
  };
  return 'interceptor instalado';
}
```
Depois rodar a ação (pesquisar) e verificar o console com `browser_console_messages`.

---

## CHECKLIST DE TESTES POR TIPO DE PROJETO

### Busca Semântica (Toga Digital, nichos jurídicos, médicos etc.)
```
[ ] Página carrega sem erro crítico no console
[ ] Busca com termo genérico do nicho retorna resultados
[ ] Busca com termo específico retorna resultado mais relevante no topo
[ ] Score de similaridade > 80% no primeiro resultado
[ ] Modo alternativo (Tático, Ampla etc.) não quebra
[ ] Copiar ABNT / link externo funciona
[ ] Interceptar fetch → confirmar dims query == dims documentos
```

### Deploy Geral (qualquer projeto)
```
[ ] URL de produção carrega
[ ] Console sem erros 400/500
[ ] Ação principal do sistema funciona end-to-end
[ ] Variáveis de ambiente (API keys) estão corretas — testar via ação real
```

---

## PROBLEMA: Erro no console mas não aparece na tela

**Contexto:** `browser_console_messages` mostra erro 400/500, mas a UI não exibe mensagem de erro.

**Causa:** O frontend capturou a exceção mas não renderizou para o usuário, ou o erro acontece em uma chamada secundária (ex: `config` table).

**Solução:** Usar `browser_evaluate` para interceptar fetch e logar payloads. Verificar qual endpoint retornou erro e investigar separadamente.

**Projeto de origem:** PROJ-001 Valdece V3 · 2026-05-21

---

## PROBLEMA: Teste no Playwright mostra resultado diferente do browser real

**Contexto:** Playwright reporta erro, mas ao abrir no browser do usuário funciona (ou vice-versa).

**Causa possível 1:** Cache do CDN — Netlify pode estar servindo versão antiga para o Playwright.
**Solução:** Aguardar ~60s após deploy e testar novamente.

**Causa possível 2:** O Playwright usa uma sessão limpa (sem cookies, sem localStorage).
**Solução:** Para testar comportamento com estado, usar `browser_evaluate` para setar dados antes do teste.

**Projeto de origem:** Geral · Vanguard Tech

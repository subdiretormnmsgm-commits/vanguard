# KB: Deploy GitHub Pages — branch gh-pages separada do master

**Projeto:** PROJ-002 Ingrid  
**Data:** 2026-05-23  
**Sintoma:** código novo não chegava ao app em produção mesmo após git push

---

## Causa raiz

O repositório tem **duas branches**:
- `master` — onde todo o código de desenvolvimento fica
- `gh-pages` — branch que o GitHub Pages serve em produção

**Todo commit feito para `master` NÃO vai automaticamente para produção.**  
O GitHub Pages serve SOMENTE o que está em `gh-pages`.

A `gh-pages` tinha o frontend do Ingrid em versão Loop 3 (arquivo flat na raiz).  
Commits de Loop 4 e Loop 5 foram para `master` — nunca chegaram ao usuário.

## Estrutura de paths

```
gh-pages/           ← raiz servida em produção
  app.js            ← vem de CLIENTES/INGRID/frontend/app.js no master
  index.html        ← vem de CLIENTES/INGRID/frontend/index.html
  style.css         ← vem de CLIENTES/INGRID/frontend/style.css
  sw.js             ← vem de CLIENTES/INGRID/frontend/sw.js
  manifest.json     ← vem de CLIENTES/INGRID/frontend/manifest.json
```

URL de produção: `https://subdiretormnmsgm-commits.github.io/vanguard/`

## Sintomas que levaram ao diagnóstico

1. `Ctrl+Shift+R` não atualizava o app
2. `?fresh=1` na URL não ajudava
3. Limpar cache do Chrome não resolvia
4. Navegar para `/CLIENTES/INGRID/frontend/app.js` retornava 404
5. Navegar para `/vanguard/app.js` mostrava Loop 3 — código muito antigo
6. Debug panel não tinha os novos campos adicionados

## Solução — deploy manual (executar a cada Loop)

```bash
git stash                              # salva mudanças pendentes no master
git checkout gh-pages
git show master:CLIENTES/INGRID/frontend/app.js      > app.js
git show master:CLIENTES/INGRID/frontend/index.html  > index.html
git show master:CLIENTES/INGRID/frontend/style.css   > style.css
git show master:CLIENTES/INGRID/frontend/sw.js       > sw.js
git show master:CLIENTES/INGRID/frontend/manifest.json > manifest.json
git add app.js index.html style.css sw.js manifest.json
git commit -m "deploy(gh-pages): ingrid loop X dia Y"
git push origin gh-pages
git checkout master
git stash pop                          # restaura mudanças pendentes
```

## Automação futura recomendada

Criar GitHub Action que faz esse sync automaticamente quando há push no master em `CLIENTES/INGRID/frontend/**`:

```yaml
on:
  push:
    branches: [master]
    paths:
      - 'CLIENTES/INGRID/frontend/**'
```

## Como confirmar que o deploy chegou

1. Abrir `https://subdiretormnmsgm-commits.github.io/vanguard/`
2. Clicar 3× em "Sedes-DF 2026" no topo
3. Debug panel deve mostrar `🔧 Debug · v13` (ou a versão atual)

## Ponto cego eliminado

**P-054 (2026-05-23):** Deploy de frontend para GitHub Pages NUNCA é automático neste repo.  
O Músculo DEVE rodar o script de sync `master → gh-pages` ao final de cada sessão de build do Ingrid,  
antes de declarar qualquer feature como "deployada".

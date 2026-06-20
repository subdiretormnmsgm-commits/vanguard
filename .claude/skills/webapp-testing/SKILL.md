---
name: webapp-testing
description: Gate obrigatorio antes de toda entrega de build cliente. Golden path + edge cases + console limpo + mobile. Sem este gate, nenhum commit de entrega.
---

# WebApp Testing

## Gate -- BLOQUEANTE em entregas

Nunca commitar build de cliente sem completar este checklist.

## Processo (via Playwright MCP)

### 1. Setup
- URL de staging disponivel? SIM -> continuar
- Credenciais de teste? SIM -> continuar

### 2. Golden Path
```
browser_navigate(staging-url)
browser_snapshot()           # verificar estado inicial
# Fluxo: login -> funcionalidade principal -> resultado esperado
browser_take_screenshot()    # evidencia
```

### 3. Edge Cases
- Campo obrigatorio vazio -> mensagem de erro correta?
- Dados invalidos -> validacao funciona?
- Logout e re-login -> sessao limpa?

### 4. Console Check
```
browser_console_messages()
# Zero erros JS -- warnings aceitaveis se conhecidos
```

### 5. Mobile Viewport
```
browser_resize(width: 375, height: 812)
browser_snapshot()    # layout quebrado?
```

## Checklist de Saida

- [ ] Login/auth funciona
- [ ] Golden path sem erro (screenshot como evidencia)
- [ ] Edge cases testados
- [ ] Console limpo (zero erros JS)
- [ ] Mobile 375px OK
- [ ] Supabase respondendo (se aplicavel)

## Output

```
WEBAPP-TESTING -- [CLIENTE] [DATA]
STATUS: PASSOU / FALHOU
Evidencias: [screenshots ou descricao]
Bugs encontrados: [lista ou "nenhum"]
```

## Gatilho automatico

Sempre que Musculo for:
- Fazer commit de entrega de feature cliente
- Deploy para producao/staging
- Fechar task de build no PENDENTES.md
# RUNBOOK — NotebookLM Wipe & Sync (Playwright)
# Origem: Loop 33 — erros e acertos documentados em 2026-06-11
# Caderno VANGUARD: d7dab0e1-8844-4697-bdec-d67a150d6502
# Conta: subdiretor.mnmsgm@gmail.com | Senha: CHAVES_SISTEMA_VANGUARD.txt → GOOGLE_ACCOUNT_PASSWORD

---

## PASSO 1 — NAVEGAR PARA O CADERNO CORRETO

```
URL: https://notebooklm.google.com/notebook/d7dab0e1-8844-4697-bdec-d67a150d6502
```

CRÍTICO: Verificar SEMPRE que a URL após navegação ainda contém `d7dab0e1`.
Se mudou (ex: `46fd4612`) → navegação falhou. Navegar de volta explicitamente.

---

## PASSO 2 — LOGIN (se necessário)

Sequência:
1. Preencher email: `subdiretor.mnmsgm@gmail.com`
2. Clicar "Próxima"
3. Preencher senha: ler de CHAVES_SISTEMA_VANGUARD.txt → `GOOGLE_ACCOUNT_PASSWORD`
4. Clicar "Próxima"
5. Aguardar push de 2 fatores no celular do Diretor — aguardar confirmação dele
6. Após login, navegar DIRETAMENTE para a URL do caderno (não confiar no redirecionamento)

---

## PASSO 3 — WIPE (remover todas as fontes)

### ⚠️ CÓDIGO CORRETO (validado no Loop 30 — 2026-06-09):
```javascript
async (page) => {
  let removed = 0;
  
  for (let i = 0; i < 40; i++) {
    await page.waitForTimeout(800);
    
    const maisButtons = await page.locator('button[aria-label="Mais"]').all();
    if (maisButtons.length === 0) break;
    
    await maisButtons[0].click();
    await page.waitForTimeout(500);
    
    const removerBtn = page.getByRole('menuitem', { name: 'Remover fonte' });
    await removerBtn.waitFor({ timeout: 3000 });
    await removerBtn.click();
    await page.waitForTimeout(500);
    
    // PASSO CRITICO: modal de confirmacao aparece apos "Remover fonte"
    const excluirBtn = page.getByRole('button', { name: 'Excluir' });
    await excluirBtn.waitFor({ timeout: 3000 });
    await excluirBtn.click();
    await page.waitForTimeout(1000);
    
    removed++;
  }
  
  const remaining = await page.locator('button[aria-label="Mais"]').count();
  const url = page.url();
  return { removed, remaining, url };
}
```

**CAUSA DOS ERROS NO LOOP 33:** O passo "Excluir" no modal de confirmação foi ignorado.
Fluxo correto: clicar "Mais" → "Remover fonte" → **clicar "Excluir" no modal** → fonte removida.
Sem o "Excluir", o modal fica aberto e bloqueia todos os proximos cliques.

### VERIFICAÇÃO PÓS-WIPE (obrigatória):
- `remaining` deve ser 0
- `url` deve ainda conter `d7dab0e1`
- Se url mudou → navegar de volta para a URL do caderno
- Se remaining > 0 → executar o loop novamente

### Fallback manual (se Playwright falhar):
- Diretor usa "⋮" → "Remover fonte" → confirmar "Excluir" para cada item
- Músculo faz apenas o upload (Passo 4)

---

## PASSO 4 — SYNC (upload das novas fontes)

### Arquivos a fazer upload (CLIENTES/VANGUARD/NOTEBOOKLM_FONTES/):
```
00_MANIFESTO_DE_FONTES.md
00_INSTRUCAO_AUDITOR.md
01_SKILL_PROTOCOLO_VANGUARD.md
02_MEMORANDO_PENTALATERAL_UNIVERSAL.md
03_MANUAL_DIRETOR.md
04_INTELLIGENCE_LEDGER.md
05_PROCESSO_EVOLUTIVO_PENTALATERAL.md
06_TEMPLATES_COMUNICACAO_PENTALATERAL.md
07_WIP_BOARD.txt
08_ANALISE_SOCIO_ATUAL.txt
10_MEMORIA_RECENTE.md
11_RELATORIO_EVOLUTIVO.md
12_DIRETRIZ_GEMINI.txt
13_PASSO5_NOTEBOOKLM.md
16_ALERTA_CONFLITO.md
17_VANGUARD_TIMELINE.md
18_ATUALIZACAO_PENTALATERAL_2026-05-24.md
20_LOOP_STATE_SCHEMA.md
LEDGER_INDEX.md
```

### Código de upload:
```javascript
// Clicar em "Adicionar fontes"
await page.locator('button:has-text("Adicionar fontes"), button:has-text("+ Adicionar fontes")').first().click();
await page.waitForTimeout(1000);

// Fazer upload via file input
const fileInput = page.locator('input[type="file"]');
await fileInput.setInputFiles([
  'CAMINHO/00_MANIFESTO_DE_FONTES.md',
  // ... lista completa
]);
await page.waitForTimeout(3000);
```

### Alternativa — usar browser_file_upload:
```
Elemento: input[type="file"] (dentro do modal "Adicionar fontes")
Arquivos: caminhos absolutos dos 19 arquivos
```

---

## ERROS — CAUSA RAIZ (descoberta no Loop 33)

| Erro | Causa real | Solução |
|---|---|---|
| hover/click timeout apos step 0 | Modal "Excluir" estava aberto bloqueando proximos cliques | Adicionar o passo getByRole('button', { name: 'Excluir' }) |
| URL muda para caderno errado | NotebookLM auto-navega quando operacao interrompida | Verificar URL pos-wipe e navegar de volta se necessario |
| remaining=0 falso positivo | Verificacao rodou no caderno errado (vazio) | Sempre conferir URL antes de declarar wipe concluido |

---

## HISTORICO POR LOOP DO CADERNO VANGUARD
- **Loop 30 (2026-06-09):** Wipe REAL — 34 fontes removidas com codigo correto (com passo "Excluir")
- **Loop 31 (?):** — nao registrado
- **Loop 32 (2026-06-10):** Wipe FALSO — remaining:0 era caderno errado 46fd4612; Sync nao foi feito
- **Loop 33 (2026-06-11):** Wipe MANUAL pelo Diretor (Playwright falhou — passo "Excluir" estava ausente no codigo); Sync via browser_file_upload (19 arquivos) CONCLUIDO

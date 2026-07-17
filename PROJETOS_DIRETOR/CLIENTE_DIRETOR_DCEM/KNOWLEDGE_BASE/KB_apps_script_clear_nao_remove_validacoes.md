# KB — Apps Script: `Sheet.clear()` NÃO remove validações de dados

- **Projeto:** DCEM · Base de Consultas (Asse Ct Orç)
- **Data de origem:** 2026-07-17
- **Arquivo afetado:** `FASE1_GERADOR_BASE.gs` (`criarHandoverLog`, `criarNormas`)

## Mensagem de erro exata
```
Exception: Os dados inseridos na célula B2 violam as regras de validação de dados
definidas nessa célula. Insira um destes valores: Assunção de função, Movimentação (saída).
    (em Código.gs:530)
```
> Obs.: o Apps Script agrupa (batch) as operações de planilha. A exceção pode aflorar
> num número de linha POSTERIOR (530) ao `setValues` culpado (514), por causa do flush
> preguiçoso. Não confie no nº da linha do erro — procure o `setValues`/`setValue` anterior
> que escreve sobre uma célula com validação ativa.

## Causa raiz
`Sheet.clear()` limpa **conteúdo e formatação**, mas **NÃO remove as validações de dados**
(dropdowns / regras de lista) que já existiam nas células. Ao reconstruir uma aba com
`aba.clear()` seguido de `setValues` reescrevendo o cabeçalho, o texto do cabeçalho
(ex.: "Evento" em B2) colide com a regra de lista antiga que ainda mora naquela coluna
(`requireValueInList(...).setAllowInvalid(false)`) → a escrita é rejeitada.

Agravante nesta base: a aba "Livro de Passagem de Função" (HANDOVER_LOG) tem o **cabeçalho
na linha 2** (não na 1), e `aplicarLista` aplica a validação a partir da linha 2 — então a
regra da coluna B se sobrepõe exatamente à célula do cabeçalho B2.

## Solução (passo a passo)
1. Depois de `aba.clear()` e ANTES de reescrever o cabeçalho, limpar as validações do range inteiro:
   ```javascript
   aba.getRange(1, 1, aba.getMaxRows(), aba.getMaxColumns()).clearDataValidations();
   ```
2. `clearDataValidations()` é método de **`Range`**, NÃO de `Sheet`.
   `aba.clearDataValidations()` lança `TypeError: aba.clearDataValidations is not a function`.
   Sempre chamar sobre um `getRange(...)`.
3. Reescrever o cabeçalho + reaplicar a lista nova por último (`aplicarLista`).

## Armadilha secundária (dropdown do runner)
O seletor de função do editor Apps Script é instável: o rótulo visível pode estar
dessincronizado da função efetivamente executada. **Sempre confirmar pelo Registro de
execução** qual função rodou (ex.: `construirBase: 7 abas criadas com sucesso.`), nunca
pelo rótulo do seletor. Um erro desse tipo já causou execução indevida de `construirBase`
(que faz `criarRegistros → aba.clear()`, destrutivo) no lugar da função pretendida.

## Padrão reutilizável
Toda função que faz `aba.clear() + setValues(cabeçalho)` numa coluna que depois recebe
`requireValueInList` DEVE limpar as validações antes. Já aplicado em `criarNormas`
(comentário nas linhas ~126-129) e `criarHandoverLog`.

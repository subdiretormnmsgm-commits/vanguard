---
name: json-bom-guard
description: Prevenção, detecção e correção de BOM UTF-8 em arquivos JSON antes do parse
---

# SKILL: JSON BOM Guard

## [FUNÇÃO]
Esta skill atua como uma barreira arquitetural de sanitização de arquivos. A sua função é detectar preventivamente e corrigir a presença de marcadores de "Byte Order Mark" (BOM) em arquivos UTF-8 (em especial os de extensão `.json`). Ela blinda os scripts do sistema (como o `ConvertFrom-Json` do PowerShell) contra falhas silenciosas de leitura e corrupção de estado.

## [DETECÇÃO]
A lógica de detecção atua diretamente na camada de bytes do arquivo, ignorando a codificação de alto nível do editor:
1. Ler os primeiros 3 bytes do arquivo.
2. Identificar a assinatura hexadecimal: `0xEF 0xBB 0xBF`.
3. Se a assinatura for detectada, o arquivo é imediatamente sinalizado (marcado como "BOM Presente").
4. A detecção atua como um Gate estrito: **NENHUM** arquivo JSON pode ser repassado ao `ConvertFrom-Json` sem antes passar por esta verificação. 

## [CORREÇÃO]
A correção é o processo profilático ou reativo de sanitização do arquivo JSON:
1. Caso a detecção seja positiva, o fluxo de leitura é interrompido.
2. O conteúdo real (ignorando os 3 bytes iniciais) deve ser extraído.
3. O conteúdo deve ser reescrito no arquivo de destino utilizando explicitamente a codificação `UTF8 sem BOM` (no PowerShell: `[System.Text.Encoding]::UTF8`).
4. Essa ação atua em complementação direta ao script de manutenção `fix_bom_json.ps1` já implementado no sistema.

## [INTEGRAÇÃO session_close]
Esta verificação tem integração compulsória com a orquestração do sistema:
- **Gate 1 do `session_close.ps1`:** Antes de qualquer processo de *sync*, persistência de memória ou salvamento de `LOOP_STATE.json` e `WIP_BOARD.json`, esta checagem de BOM deve rodar. Ela impede que um JSON contaminado (gerado inadvertidamente pelo LLM ou salvo incorretamente pelo terminal) contamine a base de dados do cliente.
- **`validate_scripts.ps1`:** A varredura universal de scripts de validação deve ser ampliada para incluir arquivos `.json` (*wildcard* de json) na sua esteira de análise de integridade.

## [GUARDRAILS]
1. **FAIL FAST:** Se a conversão/remoção do BOM falhar por permissionamento de arquivo, o sistema não deve engolir o erro; deve abortar o *parse* e emitir um alerta ao Diretor (Terminal Vermelho).
2. **RESTRIÇÃO DE TIPO:** A correção e conversão para "UTF8 Sem BOM" aplica-se apenas aos arquivos de infraestrutura e estado de inteligência (como `.json` e `.md` em `.claude/`). Não alterar codificação de arquivos binários.
3. **IMUTABILIDADE DO BACKUP:** Em caso de resgate agressivo de BOM, uma cópia em memória do conteúdo bruto deve ser preservada até a validação final da correção, garantindo zero perda do histórico do *state*.

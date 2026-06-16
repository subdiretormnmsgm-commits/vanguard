# /update-map
# Comando: atualizar MAPA_VAULT.md com a estrutura real do vault
# Responsável: Músculo (Claude Code)
# Acionar: início de cada Loop + sempre que criar/remover pasta
# Caminho: vanguard/.claude/commands/update-map.md

---

Você é o Músculo da Vanguard Tech. Execute a atualização do MAPA_VAULT.md agora.

## PASSO 1 — Verificar a estrutura real do vault

```bash
# Listar todas as pastas existentes
find "PENTALATERAL_UNIVERSAL" -type d | sort

# Listar arquivos-chave na raiz do INTELLIGENCE_HUB
ls PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/

# Verificar se as pastas do Loop 34 já foram criadas
ls PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PROJETISTA/ 2>/dev/null || echo "PROJETISTA/ ainda não existe"
ls PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/DIGITAL/ 2>/dev/null || echo "DIGITAL/ ainda não existe"
ls PENTALATERAL_UNIVERSAL/CONSELHO/ 2>/dev/null || echo "CONSELHO/ ainda não existe"
```

## PASSO 2 — Comparar com o MAPA_VAULT.md atual

Leia `PENTALATERAL_UNIVERSAL/MAPA_VAULT.md` e compare com o que o PASSO 1 retornou.

Identifique:
- **Pastas que existem mas não estão no mapa** → adicionar
- **Pastas marcadas como "A CRIAR" que já existem** → remover o aviso ⚠️
- **Pastas que estão no mapa mas não existem mais** → remover ou marcar como REMOVIDA

## PASSO 3 — Atualizar o MAPA_VAULT.md

Edite `PENTALATERAL_UNIVERSAL/MAPA_VAULT.md`:

1. Atualizar a árvore de pastas (seção "ÁRVORE DE PASTAS")
2. Remover marcações ⚠️ das pastas que já foram criadas
3. Adicionar pastas novas que não estavam mapeadas
4. Incrementar a versão no cabeçalho: `Versão: [anterior + 0.1]`
5. Atualizar a data: `[data de hoje]`
6. Adicionar linha na tabela "HISTÓRICO DE VERSÕES"

**Não alterar:**
- Seção PERMISSÕES POR AGENTE (só muda por decisão do Diretor)
- Seção REGRAS DE ACESSO INVIOLÁVEIS (só muda por deliberação formal)
- Seção PROTOCOLO DE ATUALIZAÇÃO

## PASSO 4 — Confirmar e sincronizar

```bash
# Verificar que o arquivo foi salvo corretamente
wc -l PENTALATERAL_UNIVERSAL/MAPA_VAULT.md

# Registrar no git (se vault sob controle de versão)
git add PENTALATERAL_UNIVERSAL/MAPA_VAULT.md
git commit -m "update-map: Loop [N] · [data]"

# Rodar sync para o Drive
rclone sync "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard" "gdrive:vanguard"
```

## PASSO 5 — Reportar ao Diretor

Entregue:
```
/update-map concluído — Loop [N] · [data]

ESTRUTURA ATUAL: [N] pastas mapeadas
MUDANÇAS:
- Adicionadas: [lista ou "nenhuma"]
- Removidas marcações ⚠️: [lista ou "nenhuma"]
- Novas pastas detectadas: [lista ou "nenhuma"]

Versão MAPA_VAULT.md: [nova versão]
Sync: [OK / PENDENTE]
```

Se o Diretor não pediu explicitamente o relatório, registre apenas no git commit.

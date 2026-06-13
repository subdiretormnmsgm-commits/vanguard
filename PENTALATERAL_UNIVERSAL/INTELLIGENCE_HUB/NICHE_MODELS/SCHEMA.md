# SCHEMA — NICHE_MODELS
> Versão: 1.0 · Criado: 2026-06-13 · Músculo · Loop 33

## Campos obrigatórios

| Campo | Tipo | Descrição |
|---|---|---|
| `_meta` | object | Metadados — origem, versão, loop |
| `id` | string | Slug kebab-case — igual ao NICHE_INDEX |
| `nome` | string | Nome completo do nicho |
| `vertical` | int | Número da vertical |
| `status` | enum | MOVER_AGORA / MONITORAR / ARQUIVAR |
| `fit_score` | float | 1.0–5.0 |
| `fit_score_criterios` | object | dor_clara · solucao_diferenciada · concorrencia_baixa · ticket_viavel · recorrencia |
| `setor` | string | Setor primário |
| `subsetor` | string | Especialidade |
| `match_keywords` | array | Palavras-chave para match Cowork Engine |
| `match_setores` | array | Setores para match prospect |
| `urgencia_regulatoria` | enum | CRITICA / ALTA / MEDIA / ESTRUTURAL |
| `gatilho_regulatorio` | object | norma · prazo · impacto |
| `dores` | array | Mínimo 3 dores do prospect |
| `objecoes` | array | Objetos {objecao, reversao} — mínimo 3 |
| `roi_vanguard` | object | ticket_estimado · retorno · pricing |
| `narrativas` | object | argumento_abertura · linkedin_post · whatsapp_cold · whatsapp_indicacao |
| `prospect_ideal` | object | perfil · tamanho_empresa · canal · busca_linkedin · gatilho_abordagem |
| `qualificacao` | object | perguntas (array) · criterios_ideal (array) |
| `demo_disponivel` | bool | Demo disponível |
| `cowork_densidade` | string | Cobertura pelas frentes Cowork |
| `cadencia_cowork` | object | frentes_alimentadoras (array) |
| `cross_sell` | array | Objetos {nicho, argumento, ticket_combinado} |
| `notas_embaixador` | array | Perguntas para o Embaixador validar |
| `historico` | object | criado · ultima_atualizacao · loop_origem · notas_loop |

## Placeholder para pendentes
Usar "[AGUARDA_NICHE_MODELER_L34]" quando narrativa ainda não foi gerada.

## Atualização
- F1 diário → atualizar dores quando novo sinal detectado
- NICHE_MODELER mensal → atualizar narrativas + fit_score + historico
- Veredito do Diretor → atualizar status imediatamente

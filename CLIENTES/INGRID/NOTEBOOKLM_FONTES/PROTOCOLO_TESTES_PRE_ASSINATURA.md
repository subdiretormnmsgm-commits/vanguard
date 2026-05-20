# PROTOCOLO DE TESTES PRÉ-ASSINATURA
**Vanguard Tech — Documento de Governança de Projetos**
**Criado:** 2026-05-19 | **Autor:** Formalização IAH
**Decisão do Diretor:** obrigatório em todo projeto a partir desta data

> **Origem deste documento:**
> No projeto Valdece (PROJ-001), o contrato foi assinado antes da ferramenta ser
> testada no ambiente e dispositivo do cliente. A ferramenta falhou na entrega
> presencial. O contrato já estava assinado. Trabalho e credibilidade foram
> comprometidos. Este protocolo existe para que isso nunca se repita.

---

## PRINCÍPIO CENTRAL

**Testar → Validar → Assinar → Entregar.**
Nunca: Assinar → Tentar Entregar → Descobrir Falha.

O contrato é o documento que formaliza uma entrega **que já funciona.**
Não é o ponto de partida — é o ponto de chegada do processo de teste.

---

## QUANDO ESTE PROTOCOLO SE APLICA

- Todo projeto com cliente externo (Camada 1 ou superior)
- Todo projeto com valor > R$0
- Independente do prazo, da pressão comercial ou do nível de confiança no código

**Não há exceção.** Urgência não dispensa o protocolo — urgência é exatamente quando mais importa executá-lo.

---

## AS TRÊS FASES OBRIGATÓRIAS

### FASE 1 — PERÍODO DE TESES (interno)
*Antes de qualquer contato com o cliente sobre assinatura*

**Objetivo:** confirmar que a ferramenta funciona no ambiente de produção real, sem a presença do cliente, sem pressão de tempo.

**Checklist obrigatório (adaptar itens 2, 3 e 5 ao produto):**

```
[ ] 1. Deploy realizado no ambiente final (não em localhost)
[ ] 2. Executar os 5 casos de uso principais do produto no fluxo real do cliente
        → Registrar: input | resultado | latência | comportamento esperado vs. obtido
[ ] 3. Executar 2 casos de borda (menor cobertura, cenário adverso)
        → Registrar resultado e comportamento de fallback
[ ] 4. Testar autenticação: acesso correto + tentativa de acesso negado (se aplicável)
[ ] 5. Verificar o output principal do produto em pelo menos 3 exemplos distintos
        (ex: citação ABNT para LegalTech, questão gerada para EdTech, relatório para FinTech)
[ ] 6. Testar no dispositivo equivalente ao do cliente (smartphone/tablet/desktop dele)
        — não apenas no computador de Eduardo
[ ] 7. Testar em rede diferente da rede de desenvolvimento (4G/5G do celular)
[ ] 8. Registrar: todos os gates aprovados com print ou log datado
```

**Gate de saída da Fase 1:**
Todos os 8 itens marcados. Se algum falhar → corrigir e reiniciar o checklist.
**Nenhum contato sobre assinatura antes deste gate.**

---

### FASE 2 — PERÍODO DE TESES (com o cliente)
*Antes da reunião de assinatura*

**Objetivo:** o cliente usa a ferramenta no próprio dispositivo, em condições reais, antes de ver o contrato.

**Como executar:**

1. Enviar o link da ferramenta ao cliente com 24–48h de antecedência
2. Pedir que ele teste 2–3 buscas reais do trabalho dele
3. Aguardar feedback antes de agendar a assinatura
4. Se o cliente reportar qualquer falha → corrigir antes de prosseguir

**Script de envio (adaptar para cada cliente):**
> "[NOME_CLIENTE], antes de formalizarmos, quero que você teste a ferramenta no seu
> [celular / computador] com um caso real. Link: [URL].
> Testa 2 ou 3 [buscas / exercícios / consultas] e me diz o que apareceu.
> A gente assina depois que você confirmar que está funcionando como esperado."

**Gate de saída da Fase 2:**
Cliente confirma funcionamento verbalmente ou por mensagem.
Registrar a confirmação (print do WhatsApp, e-mail, ou nota no LOG_CLIENTE).

---

### FASE 3 — ASSINATURA E ENTREGA
*Somente após Fase 1 e Fase 2 concluídas*

**O que acontece nesta fase:**
- Contrato apresentado com escopo exatamente igual ao que foi testado
- Assinatura do cliente
- Handoff + Sovereign Playbook
- Pagamento

**Sequência na reunião presencial:**

```
1. Cliente usa o sistema (demonstração ao vivo — ele digita, não Eduardo)
2. Eduardo confirma verbalmente: "Está funcionando como testamos?"
3. Cliente confirma
4. Eduardo apresenta o contrato: "Isso aqui formaliza exatamente o que você acabou de usar"
5. Assinatura
6. Handoff dos documentos e credenciais
7. Pagamento
```

---

## REGISTRO OBRIGATÓRIO

Ao concluir a Fase 1, gerar um **RELATÓRIO DE TESTES** mínimo:

```
# RELATÓRIO DE TESTES — [Nome do Projeto] — [Nome do Cliente] — [Data]

**Ambiente testado:** [URL de produção]
**Dispositivo de teste:** [modelo do dispositivo equivalente ao do cliente]
**Rede:** [4G / WiFi externo — nunca a rede de desenvolvimento]
**Testado por:** Eduardo

| # | Caso de Uso / Teste              | Resultado | Latência | Status     |
|---|----------------------------------|-----------|----------|------------|
| 1 | Caso principal 1                 |           |          | ✅ / ❌    |
| 2 | Caso principal 2                 |           |          | ✅ / ❌    |
| 3 | Caso principal 3                 |           |          | ✅ / ❌    |
| 4 | Caso de borda 1                  |           |          | ✅ / ❌    |
| 5 | Autenticação — acesso correto    |           |          | ✅ / ❌    |
| 6 | Autenticação — acesso negado     |           |          | ✅ / ❌    |
| 7 | Output principal — formato/conteúdo |        |          | ✅ / ❌    |

**Gate Fase 1: APROVADO / REPROVADO**
**Liberado para Fase 2 (teste com cliente):** SIM / NÃO
**Liberado para contato de assinatura:** SIM (somente após Fase 2 concluída) / NÃO
```

Este relatório entra como fonte no NotebookLM e é arquivado junto ao contrato.

---

## O QUE MUDA NO CONTRATO

A cláusula de entrega do contrato padrão passa a incluir:

> **Cláusula X — Validação Prévia**
> O Contratante confirma que testou a ferramenta em seu dispositivo pessoal antes
> da assinatura deste instrumento e que os resultados obtidos correspondem ao
> escopo descrito na Cláusula 2. A assinatura deste contrato equivale à
> homologação do funcionamento da ferramenta nas condições demonstradas.

Esta cláusula protege o Contratado e documenta que o cliente assinou ciente do que recebeu — não por fé.

---

## REGRAS DO DIRETOR

```
REGRA 1: Contrato nunca precede o teste. Sem exceção.
REGRA 2: "O código está funcionando no meu computador" não é teste válido.
          Teste válido = cliente usando, no dispositivo dele, em rede real.
REGRA 3: Pressão comercial para assinar rápido é sinal de alerta — não de agilidade.
          Cliente que confia espera 48h de teste. Cliente apressado merece mais cautela.
REGRA 4: Falha descoberta após assinatura custa 10x mais do que falha descoberta antes.
          Custo do teste: 2 horas. Custo da falha pós-assinatura: credibilidade.
REGRA 5: O Diretor é o único que pode decidir avançar para assinatura.
          O Músculo não tem autoridade para comprimir este protocolo.
```

---

## PRINCÍPIO REGISTRADO NO INTELLIGENCE LEDGER

> **[P-046] Contrato segue teste — nunca precede**
> **Descoberto:** 2026-05-19 | **Sessão:** Formalização pós-entrega presencial PROJ-001 Valdece
>
> **Fricção:** O contrato do Valdece foi assinado antes da ferramenta ser testada no dispositivo e na rede real do cliente. Na entrega presencial, a ferramenta falhou. O contrato já estava assinado. Trabalho de recuperação foi necessário. Situação inteiramente evitável.
>
> **Princípio:** A sequência obrigatória é:
> 1. **Testar internamente** — no ambiente de produção, no dispositivo equivalente ao do cliente, em rede externa
> 2. **Validar com o cliente** — cliente usa a ferramenta antes da reunião de assinatura e confirma funcionamento
> 3. **Assinar** — contrato formaliza entrega que já funciona, não uma promessa de que vai funcionar
> 4. **Entregar** — handoff, Sovereign Playbook, credenciais
>
> Nenhuma pressão comercial, prazo ou nível de confiança no código dispensa as Fases 1 e 2. O contrato é o ponto de chegada do processo de teste — nunca o ponto de partida.
>
> **Causa raiz:** Pressão de timing comercial + confiança no código testado apenas no ambiente de desenvolvimento. "Funciona no meu computador" não é gate de aprovação.
>
> **Ferramenta criada:** `QUADRILATERAL_UNIVERSAL/OPERACAO/PROTOCOLO_TESTES_PRE_ASSINATURA.md` — checklist de 8 itens (Fase 1 interna) + script de envio ao cliente (Fase 2) + nova cláusula contratual de validação prévia.
>
> **Regra de ouro:** Pressão para assinar rápido é sinal de alerta — não de agilidade. Cliente que confia espera 48h de teste. O custo do protocolo é 2h. O custo da falha pós-assinatura é a credibilidade.
>
> **Responsabilidade:** O Diretor é o único que autoriza o avanço para assinatura. O Músculo não tem autonomia para comprimir este protocolo sob nenhuma circunstância.
>
> **Aplica-se a:** todo projeto com cliente externo, qualquer valor, qualquer prazo, qualquer nível de confiança no código.

---

*Este documento é vivo. Atualizar quando o processo de entrega mudar ou quando
um novo tipo de produto exigir adaptação do checklist.*

*Arquivar junto ao contrato de cada projeto como evidência de que o protocolo foi seguido.*

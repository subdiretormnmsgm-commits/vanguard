# SKILL: ingrid-v8.md
**Camada:** 3 (Telemetria e Monetização) | **Loop:** #8 | **Stack:** PWA Vanilla JS + Supabase (RLS) + Telegram API

## [AUDITORIA DE COERENCIA]
O Loop 8 expande a estabilidade do motor técnico, mas a intenção de usar logs pessoais (M-1) da cliente como prova social para o mercado [4] expõe a Vanguard Tech a penalidades da LGPD e ao Mapeamento Jurídico da Holding [5]. A exigência inegociável é: todo dataset usado para vendas futuras deve ser purgado de PII (Personally Identifiable Information) e agrupado estatisticamente. O *Dry-Run* do RLS (Gate 7.2) [11] é mandatório para chancelar a segurança do banco antes que a View `snapshot_ingrid` [11] compile métricas B2C. 

## [CONEXAO HISTORICA]
O sistema já padeceu no passado de "Miopia de Telemetria" por confiar apenas em requisições ativas. Para o alerta do Telegram (F-E) [11] funcionar com integridade contra o falso *churn*, o Músculo deve espelhar o aprendizado de retenção offline-first [24]. A lógica de *batch* não-bloqueante de telemetria é a correção definitiva para prevenir sobrecarga de latência que historicamente destruiu a adoção em apps web móveis.

## [PADRAO DE SUCESSO/FALHA]
* **Sucesso:** A captação do shift vocabular da usuária ("volto para atacar mais") pelo Embaixador [25], abrindo a janela cirúrgica de *pitch* de R$97/mês [7], demonstrando o perfeito funcionamento do princípio **[P-079]** [8].
* **Falha:** A sugestão de adiar o *pitch* passivamente (G-5) [4] e aplicar punições de redução de cota de questões (G-3) [4], ações que esbarram no desamparo aprendido da usuária não-técnica, arriscando o abandono silencioso de um cliente com Temperatura de 8.5/10 [6].

## [PERSPECTIVA DO SOCIO]
Se este projeto se tornar o motor White-Label B2C SaaS da Vanguard, a barreira de entrada legal é o isolamento. Testar o RLS e garantir o Git Hook pre-push (F-G) [11] é a fundação que permitirá a comercialização seriada a R$97/mês. Eduardo atua como o "Copiloto Premium", logo, as notificações automatizadas (F-E) [11] devem protegê-lo de fadiga administrativa, acionando a atenção humana apenas na quebra aguda da métrica.

## ⚙️ SEQUÊNCIA DE BUILD E RESTRIÇÕES (LOOP 8)
1. **Bloco A (Segurança P0):** Gate 7.2 (test_tenant_isolation.ps1). Implementar o Git Hook pre-push (F-G) blindando o vazamento de chaves (SUPABASE_SERVICE_ROLE_KEY) [11].
2. **Bloco B (Data Engine):** Persistir evento_uso (F-A) com persistência em local storage e envio em *batch* assíncrono [11]. Instanciar a View `snapshot_ingrid_loop6_golden` [11].
3. **Bloco C (Interação e Observabilidade):** Alerta Compound Telegram (F-E) calibrado para 3 dias sem rede/sincronização. *Pulse Check* qualitativo (F-F) integrado suavemente à UX [11]. Tabela CLI/SQL para Painel Eduardo (F-B) [11].
4. **Bloco D (Escala Comercial):** *SaaS Readiness Audit* anônimo focado no custo operacional (M-4) [4].

* **O QUE NÃO CONSTRUIR:** 
  * NÃO desenvolva painéis Web gráficos robustos e custosos para Eduardo (Painel F-B é minimalista em CLI ou plain HTML) [16, 26]. 
  * NÃO aplique deduções punitivas no SM-2 (Rejeição sumária do G-3) [4]. 
  * NÃO gere rotas públicas para métricas (M-4) sem ofuscação integral de identidade [27].
# CONTRATO_CLAUSULAS — INGRID
> Documento de referência para o Change-Order Interceptor (N-5 Ingrid).
> Eduardo: preencher com as cláusulas reais do contrato assinado.
> O interceptor lê este arquivo para identificar o que está dentro e fora do escopo.

---

## ESCOPO CONTRATUAL (Cláusula X.X)

**O que está incluso:**
- [Listar as entregas contratadas — ex: sistema de agendamento, módulo de recepção, etc.]
- [Funcionalidade 2]
- [Funcionalidade 3]

**O que está EXPLICITAMENTE excluído:**
- Integrações com sistemas de terceiros não listados acima
- Módulos de faturamento ou cobranças automáticas
- [Outros exclusos relevantes]

---

## PRAZO E FASES (Cláusula X.X)

| Fase | Entrega | Prazo |
|---|---|---|
| Fase 1 | [descrição] | [data] |
| Fase 2 | [descrição] | [data] |

---

## ADICIONAL E ADITIVOS (Cláusula X.X)

**Política de mudanças de escopo:**
- Toda solicitação fora do escopo definido acima requer aditivo contratual formal
- Prazo para orçamento de aditivo: [X] dias úteis após solicitação
- Forma de aprovação: [assinatura digital / WhatsApp / presencial]

**Valores de referência para aditivos:**
- Feature pequena (< 8h): R$[X]
- Feature média (8-20h): R$[X]
- Feature grande (> 20h): deliberar caso a caso

---

## PROPRIEDADE INTELECTUAL (Cláusula X.X)

[Inserir cláusula sobre quem detém o código, licença, etc.]

---

## SUPORTE E MANUTENÇÃO (Cláusula X.X)

**Incluso no contrato:**
- Hypercare de [X] dias: correção de bugs do escopo original sem custo adicional
- Bugs = falha no que foi contratado · Feature nova = aditivo

**Não incluso:**
- Treinamento de equipe além do onboarding inicial
- Suporte a problemas causados por alterações feitas pelo cliente

---

> INSTRUÇÃO PARA O MÚSCULO:
> Ao executar change_order_interceptor.ps1, este arquivo é lido automaticamente.
> Se vazio ou com placeholders, o interceptor alerta que as cláusulas precisam ser preenchidas.
> Eduardo: completar antes da primeira sessão com Ingrid onde mudança de escopo for provável.

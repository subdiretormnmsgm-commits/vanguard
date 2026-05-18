# SKILL: VANGUARD_DESIGN_ELITE_2026

## 🎨 ESTÉTICA VANGUARD (ANTI-GENÉRICO)
- **Layout Anti-Grid:** Proibido o uso de grids simétricos óbvios. Exigido o uso de composições assimétricas, onde elementos de texto e imagem se sobrepõem de forma orgânica.
- **Tipografia Cinética:** Títulos devem utilizar bibliotecas de interpolação (Framer Motion) para reagir ao scroll ou ao hover, alterando escala ou peso dinamicamente.

## 🚀 STACK DE PERFORMANCE "ZERO-LATÊNCIA"
- **PPR (Partial Pre-Rendering):** A estrutura de rotas do Next.js deve usar PPR. Seções estáticas (Hero) carregam em <200ms; seções dinâmicas (Preços/Dashboard) fazem stream de dados em background.
- **RSC (React Server Components):** Minimizar o uso de `use client`. Interatividade apenas onde for estritamente necessário.

## 🧪 AS 4 TÁTICAS AVANÇADAS (REQUISITOS TÉCNICOS)
1. **[SPATIAL_UI]:** Implementar profundidade real. O fundo do site deve se mover em uma velocidade 15% menor que o conteúdo (Paralaxe Z), criando uma sensação de volume espacial. Uso de Spline para assets 3D leves é encorajado.
2. **[INTENT_BASED_UI]:** O código deve monitorar a velocidade do cursor. Se o usuário mover o mouse rapidamente para o topo (intenção de saída), um componente de "Oferta de Retenção" deve ser injetado via portal no DOM.
3. **[NEURO_ACCESSIBILITY]:** Aplicar a Lei da Carga Cognitiva. Informações densas devem ser reveladas progressivamente (Progressive Disclosure). O contraste deve se ajustar automaticamente: tons mais suaves à noite, alto contraste sob luz forte (via Sensor de Luz da API do Browser, se disponível).
4. **[ECO_RENDERING]:** Otimização de GPU. Animações devem ser delegadas ao CSS (Transform/Opacity) em vez de JS puro, visando economizar bateria em dispositivos mobile e reduzir o CLS (Cumulative Layout Shift) para zero.
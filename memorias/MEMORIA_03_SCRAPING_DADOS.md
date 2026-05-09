# MEMORIA_03_SCRAPING_DADOS — Vanguard Tech V3

**Data:** 2026-05-09
**Versão do Projecto:** 3
**Componente:** Scraper Vanguard — Engenheiro de Dados Outbound

---

## 1. Arquitectura do Scraper

```
scraper_vanguard.py
├── DigitalAudit        # Audita presença digital via HTTP real (score 0-10)
├── CopyGenerator       # Gera copy WhatsApp personalizado por lead
├── SupabaseWriter      # Injeta leads em leads_diagnostico via REST
├── DemoSource          # Dados sintéticos para testes sem API keys
├── OSMSource           # OpenStreetMap Overpass API (gratuito, legal)
├── PlacesSource        # Google Places API (premium, opcional)
└── main()              # CLI com argparse: --nicho --cidade --limite --modo
```

---

## 2. Bibliotecas Utilizadas

| Biblioteca     | Versão  | Uso                                      |
|----------------|---------|------------------------------------------|
| `requests`     | ≥2.31   | HTTP client para auditorias e APIs       |
| `beautifulsoup4`| ≥4.12  | Parser HTML para auditoria de sites      |
| `lxml`         | ≥5.0    | Parser XML/HTML rápido (backend do BS4)  |
| `python-dotenv`| ≥1.0    | Carrega credenciais de `.env`            |

Nenhuma dependência de terceiros para o scraping em si — o OSM usa o Overpass API via HTTP puro.

---

## 3. Algoritmo de Auditoria Digital (DigitalAudit)

O scraper faz um pedido HTTP real ao site de cada lead e analisa:

| Critério                      | Penalidade | Justificação                               |
|-------------------------------|------------|--------------------------------------------|
| Sem HTTPS                     | +3         | Segurança e SEO crítico desde 2018         |
| Sem meta description          | +2         | SEO básico ausente                         |
| Sem viewport meta             | +2         | Site não é mobile-friendly                 |
| Sem analytics (GA/GTM/Pixel)  | +2         | Sem dados = sem estratégia                 |
| Sem Open Graph tags           | +1         | Partilha social não optimizada             |
| **Score máximo**              | **10**     | **Sem site = score 10 automático**         |

### Mapeamento Score → Gargalo

| Score | Gargalo (campo quiz)                              |
|-------|---------------------------------------------------|
| 8-10  | Dependência de ferramentas de terceiros           |
| 5-7   | Falta de visibilidade sobre métricas do negócio  |
| 2-4   | Captação e retenção de clientes                  |
| 0-1   | Processos manuais que consomem tempo             |

---

## 4. Fontes de Dados

### 4.1 Demo Mode (--modo demo)
Dados sintéticos realistas para 3 nichos (advocacia, estetica, clinica). Valida o pipeline completo sem dependência externa. Usado para onboarding e testes.

### 4.2 OSM Mode (--modo osm)
**OpenStreetMap Overpass API** — sem violação de ToS, gratuito, dados públicos.
- Endpoint primário: `overpass-api.de`
- Fallback: `overpass.kumi.systems`
- Estratégia: failover automático entre servidores
- Cobertura: excelente para estabelecimentos físicos (dentistas, clínicas, farmácias). Dados de contact (telefone, site) são opcionais no OSM — leads OSM frequentemente chegam sem site (score 10 = oportunidade máxima).
- **Limitação:** OSM cobre melhor estabelecimentos públicos e físicos. Negócios puramente digitais estão sub-representados.

### 4.3 Places Mode (--modo places)
**Google Places API** — dados ricos e actualizados.
- Requer `GOOGLE_PLACES_API_KEY` em `.env`
- Custo: ~USD 32/1000 pesquisas (após free tier)
- Paginação automática com `next_page_token`
- Delay de 2s entre páginas (requisito Google)
- Ideal para nichos com alta concentração online (restaurantes, beleza, saúde privada)

---

## 5. Rate Limiting e Segurança

```python
# Delay aleatório entre leads processados (respeita servidores)
time.sleep(random.uniform(0.8, 1.8))

# Timeout em todas as chamadas HTTP
requests.get(url, timeout=6)  # auditoria de sites
urllib.request.urlopen(req, timeout=15)  # Supabase

# User-Agent realista (evita bloqueios básicos)
HEADERS = {'User-Agent': 'Mozilla/5.0 ... Chrome/124.0.0.0 ...'}
```

---

## 6. Injecção Supabase

Os leads são injectados em `leads_diagnostico` com `origem = 'scraper'`. Esta estratégia reutiliza a tabela existente e o Cockpit V2 já os exibe — sem necessidade de nova tabela.

```python
payload = {
    'nome':     lead['nome'],
    'whatsapp': lead.get('telefone') or 'N/D',
    'nicho':    lead['nicho'],       # mapeado para valores do quiz
    'gargalo':  lead['gargalo'],     # derivado do score digital
    'origem':   'scraper',           # flag de identificação
}
```

**Credenciais:** carregadas de `.env` via `python-dotenv`. O ficheiro `.env` está em `.gitignore` — nunca entra no repositório.

---

## 7. Geração de Copy WhatsApp

3 templates rotativos (evita padrão detectável por spam filters). Personalização dinâmica:
- `{nome}` — nome exacto do negócio scraped
- `{gargalo}` — derivado da auditoria digital
- `{nicho}` — categoria do negócio
- `{score}` — score digital calculado
- `{quiz_url}` — link configurável em `.env`

---

## 8. Resultados dos Testes

| Teste                       | Leads | Supabase | Score Médio |
|-----------------------------|-------|----------|-------------|
| Demo — advocacia/SP         | 5     | 0 (sem key no 1º teste) | 7.4 |
| Demo — estetica/RJ          | 3     | 3 ✓      | 6.0         |
| OSM  — clinica/SP (real)    | 3     | 3 ✓      | 10.0        |
| **Total injectado**         | **6** | **6 ✓**  | —           |

---

## 9. Como Usar em Produção

```powershell
# Configurar .env com credenciais reais
# Depois executar:

# Modo demo (testar pipeline)
python scraper_vanguard.py --nicho advocacia --cidade "São Paulo" --limite 10 --modo demo

# Modo OSM (dados reais gratuitos)
python scraper_vanguard.py --nicho estetica --cidade "Rio de Janeiro" --limite 20 --modo osm

# Modo Google Places (dados premium)
python scraper_vanguard.py --nicho clinica --cidade "Belo Horizonte" --limite 50 --modo places
```

Relatórios gerados automaticamente em `outbound/NICHO_CIDADE_TIMESTAMP.md`.

---

## 10. Próximos Passos (V4)

Ver `relatorio_evolutivo_v3.md` — Visão LMM sobre containerização do scraper no EasyPanel com execuções agendadas (cron) e análise de conteúdo dos sites via Anthropic API em tempo real.

**Levar o `relatorio_evolutivo_v3.md` ao Gemini para a DIRETRIZ da V4.**

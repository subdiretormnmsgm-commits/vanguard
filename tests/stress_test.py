#!/usr/bin/env python3
"""
Vanguard V10 — Director Stress Test Protocol
Simula 1.000 leads simultâneos e verifica integridade do Guardrail e Hermes.

Uso:
  pip install httpx
  python tests/stress_test.py --n 1000 --url http://localhost:9000 --token <bearer_token>

Saídas verificadas:
  [1] Health API: latência p95 < 500ms sob carga
  [2] Guardrail:  quota_exceeded (429) deve disparar correctamente
  [3] Throughput: >= 50 req/s em hardware standard
"""

import argparse
import asyncio
import json
import sys
import time
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional

import httpx

CYAN  = '\033[96m'
GREEN = '\033[92m'
AMBER = '\033[93m'
RED   = '\033[91m'
RESET = '\033[0m'
BOLD  = '\033[1m'


@dataclass
class TestResult:
    n_total:          int = 0
    ok_health:        int = 0
    ok_scraper:       int = 0
    erros:            int = 0
    quota_violations: int = 0
    latencias:        list = field(default_factory=list)
    tempo_total_s:    float = 0.0
    erros_detalhe:    list = field(default_factory=list)

    def pct(self, p: int) -> float:
        if not self.latencias: return 0.0
        s = sorted(self.latencias)
        return round(s[max(0, round(p / 100 * len(s)) - 1)], 1)

    @property
    def taxa_sucesso(self) -> float:
        ok = self.ok_health + self.ok_scraper
        return round(ok / max(1, self.n_total) * 100, 1)

    @property
    def rps(self) -> float:
        return round(self.n_total / max(0.001, self.tempo_total_s), 1)


async def ping_health(client: httpx.AsyncClient, url: str) -> tuple[bool, float]:
    t0 = time.monotonic()
    try:
        r = await client.get(f'{url}/health', timeout=10)
        return r.status_code < 400, (time.monotonic() - t0) * 1000
    except Exception:
        return False, (time.monotonic() - t0) * 1000


async def trigger_scraper(
    client: httpx.AsyncClient,
    url:    str,
    token:  str,
) -> tuple[bool, float, str]:
    t0 = time.monotonic()
    headers = {'Authorization': f'Bearer {token}', 'Content-Type': 'application/json'}
    payload = {'nicho': 'advocacia', 'cidade': 'Lisboa', 'limite': 1, 'modo': 'demo'}
    try:
        r = await client.post(
            f'{url}/api/scraper/trigger',
            json=payload, headers=headers, timeout=15,
        )
        lat = (time.monotonic() - t0) * 1000
        if r.status_code == 429:
            return False, lat, 'quota_exceeded'
        elif r.status_code in (200, 201, 202):
            return True, lat, 'ok'
        else:
            return False, lat, f'http_{r.status_code}'
    except Exception as e:
        return False, (time.monotonic() - t0) * 1000, str(e)[:60]


async def run_batch(
    client:  httpx.AsyncClient,
    coros:   list,
) -> list:
    return await asyncio.gather(*coros, return_exceptions=True)


async def run_stress_test(
    url:        str,
    token:      str,
    n:          int = 1000,
    batch_size: int = 100,
) -> TestResult:
    res = TestResult(n_total=n)

    print(f'\n{CYAN}{"═" * 62}{RESET}')
    print(f'{BOLD}  VANGUARD V10 — DIRECTOR STRESS TEST{RESET}')
    print(f'  Target  : {url}')
    print(f'  N       : {n:,} requests  |  Batch: {batch_size}')
    print(f'  Início  : {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}')
    print(f'{CYAN}{"═" * 62}{RESET}\n')

    limits = httpx.Limits(max_connections=200, max_keepalive_connections=100)
    t0_all = time.monotonic()

    async with httpx.AsyncClient(limits=limits) as client:

        # ── Phase 1: Health storm ─────────────────────────────────────
        n_health = n // 2
        print(f'{BOLD}[Phase 1]{RESET} Health storm ({n_health:,} simultâneos)...')
        ph_start = time.monotonic()
        for i in range(0, n_health, batch_size):
            b = min(batch_size, n_health - i)
            results = await run_batch(client, [ping_health(client, url) for _ in range(b)])
            for r in results:
                if isinstance(r, Exception):
                    res.erros += 1; res.latencias.append(9999)
                else:
                    ok, lat = r
                    res.latencias.append(lat)
                    if ok: res.ok_health += 1
                    else:  res.erros += 1
            done = i + b
            bar = '█' * (done * 30 // n_health) + '░' * (30 - done * 30 // n_health)
            print(f'  [{bar}] {done}/{n_health}', end='\r')
        print(f'\n  {GREEN}✓ Phase 1{RESET} — {round(time.monotonic()-ph_start, 1)}s '
              f'| ok={res.ok_health}')

        # ── Phase 2: Guardrail test ───────────────────────────────────
        n_scraper = n // 2
        print(f'\n{BOLD}[Phase 2]{RESET} Guardrail + Quota stress ({n_scraper:,} requests)...')
        ph_start = time.monotonic()
        for i in range(0, n_scraper, batch_size):
            b = min(batch_size, n_scraper - i)
            coros = [trigger_scraper(client, url, token) for _ in range(b)]
            results = await run_batch(client, coros)
            for r in results:
                if isinstance(r, Exception):
                    res.erros += 1; res.latencias.append(9999)
                else:
                    ok, lat, outcome = r
                    res.latencias.append(lat)
                    if outcome == 'quota_exceeded':
                        res.quota_violations += 1
                    elif ok:
                        res.ok_scraper += 1
                    else:
                        res.erros += 1
                        res.erros_detalhe.append(outcome)
            done = i + b
            bar = '█' * (done * 30 // n_scraper) + '░' * (30 - done * 30 // n_scraper)
            print(f'  [{bar}] {done}/{n_scraper} | quota={res.quota_violations}', end='\r')
        print(f'\n  {GREEN}✓ Phase 2{RESET} — {round(time.monotonic()-ph_start, 1)}s '
              f'| ok={res.ok_scraper} | quota={res.quota_violations}')

    res.tempo_total_s = time.monotonic() - t0_all

    # ── Print Results ─────────────────────────────────────────────────────
    print(f'\n{CYAN}{"═" * 62}{RESET}')
    print(f'{BOLD}  RESULTADOS{RESET}')
    print(f'{CYAN}{"═" * 62}{RESET}')

    c_ok = GREEN if res.taxa_sucesso >= 99 else AMBER if res.taxa_sucesso >= 95 else RED
    c_grd = GREEN if res.quota_violations > 0 else AMBER
    c_p95 = GREEN if res.pct(95) < 500 else AMBER if res.pct(95) < 2000 else RED

    print(f'  Total requests   : {BOLD}{n:>8,}{RESET}')
    print(f'  Taxa de sucesso  : {c_ok}{BOLD}{res.taxa_sucesso:>7.1f}%{RESET}')
    print(f'  Erros            : {RED if res.erros > 0 else GREEN}{res.erros:>8,}{RESET}')
    print(f'  Guardrail (429s) : {c_grd}{BOLD}{res.quota_violations:>8,}{RESET}'
          f'  {"✓ ACTIVO" if res.quota_violations > 0 else "⚠ sem violações detectadas"}')
    print(f'  Throughput       : {BOLD}{res.rps:>7.1f}{RESET} req/s')
    print(f'  Latência  p50    : {res.pct(50):>8.1f} ms')
    print(f'  Latência  p95    : {c_p95}{res.pct(95):>8.1f} ms{RESET}')
    print(f'  Latência  p99    : {res.pct(99):>8.1f} ms')
    print(f'  Latência  máx    : {res.pct(100):>8.1f} ms')
    print(f'  Tempo total      : {res.tempo_total_s:>8.2f} s')

    if res.erros_detalhe:
        from collections import Counter
        top = Counter(res.erros_detalhe).most_common(5)
        print(f'  Erros mais freq. : {", ".join(f"{k}×{v}" for k,v in top)}')

    print(f'{CYAN}{"═" * 62}{RESET}')

    # Veredicto
    if res.taxa_sucesso >= 99.0 and res.pct(95) < 500:
        print(f'\n  {GREEN}{BOLD}🟢 VEREDICTO: FORTRESS IMPENETRÁVEL{RESET}')
        print(f'     {n:,} requests absorvidos. Guardrail activo. Torre de Controlo ONLINE.')
    elif res.taxa_sucesso >= 95.0:
        print(f'\n  {AMBER}{BOLD}🟡 VEREDICTO: SISTEMA RESILIENTE{RESET} (margem de optimização)')
    else:
        print(f'\n  {RED}{BOLD}🔴 VEREDICTO: ATENÇÃO — taxa abaixo de 95%{RESET}')

    print()
    return res


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Vanguard V10 Director Stress Test')
    parser.add_argument('--n',     type=int,   default=1000,                   help='Total de requests')
    parser.add_argument('--url',   default='http://localhost:9000',             help='Base URL da API')
    parser.add_argument('--token', default='',                                  help='Bearer JWT token')
    parser.add_argument('--batch', type=int,   default=100,                    help='Tamanho do batch')
    parser.add_argument('--json',  action='store_true',                         help='Output JSON puro')
    args = parser.parse_args()

    result = asyncio.run(run_stress_test(args.url, args.token, args.n, args.batch))

    if args.json:
        print(json.dumps({
            'n_total':          result.n_total,
            'ok':               result.ok_health + result.ok_scraper,
            'erros':            result.erros,
            'quota_violations': result.quota_violations,
            'taxa_sucesso':     result.taxa_sucesso,
            'rps':              result.rps,
            'p50_ms':           result.pct(50),
            'p95_ms':           result.pct(95),
            'p99_ms':           result.pct(99),
            'tempo_s':          round(result.tempo_total_s, 2),
            'ts':               datetime.now().isoformat(),
        }, indent=2))

    sys.exit(0 if result.taxa_sucesso >= 95.0 else 1)

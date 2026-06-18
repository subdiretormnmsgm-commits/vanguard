"""
Testes do Quadrilateral IAH — validação das 3 alavancas implementadas.

Roda sem ANTHROPIC_API_KEY (auditor.py é mockado).
Uso: pytest tests/test_quadrilateral.py -v
"""

import json
import os
import sys
import tempfile
from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest

# Ajusta path para importar os módulos
sys.path.insert(0, str(Path(__file__).parent.parent))


# ─────────────────────────────────────────────────────────────────────────────
# Fixtures
# ─────────────────────────────────────────────────────────────────────────────

@pytest.fixture(autouse=True)
def ledger_temporario(tmp_path, monkeypatch):
    """Cada teste usa um ledger_state.json isolado em tmp_path."""
    ledger_file = tmp_path / "ledger_state.json"
    monkeypatch.setenv("LEDGER_PATH", str(ledger_file))

    # Força reload do módulo para pegar o novo path
    import importlib
    import api.ledger as ledger_mod
    ledger_mod.LEDGER_PATH = ledger_file
    ledger_mod._state = None  # reseta singleton
    yield ledger_file
    ledger_mod._state = None


# ─────────────────────────────────────────────────────────────────────────────
# Alavanca 1 — LEDGER como estado vivo
# ─────────────────────────────────────────────────────────────────────────────

class TestLedgerEstadoVivo:

    def test_principios_iniciais_carregados(self):
        """Os 10 princípios da V24 devem estar presentes desde o início."""
        from api.ledger import listar_principios_ativos
        principios = listar_principios_ativos()
        assert len(principios) >= 10
        ids = {p.id for p in principios}
        # Verifica os 5 princípios canônicos da V24
        assert "P-001" in ids  # Claude Code ≠ daemon
        assert "P-005" in ids  # Inteligência acumula por sessão
        assert "P-007" in ids  # Skill genérica é pior que incompleta
        assert "P-010" in ids  # Gate sem evidência = gate inválido

    def test_registrar_friccao_persiste(self):
        """Evento de fricção deve ser persistido no JSON."""
        from api.ledger import FricaoEvento, get_state, registrar_fricao
        evento = FricaoEvento(
            id="",
            timestamp="2026-05-15T10:00:00Z",
            sessao="V25-teste",
            tipo="ALUCINACAO_TECNICA",
            fonte="Estrategista",
            instrucao_original="Construir pgvector agora",
            problema_detectado="YAGNI — não há consulta semântica no escopo",
            acao_tomada="Soft Veto SV-1 emitido",
            principio_gerado=None,
            severidade="HIGH",
        )
        registrado = registrar_fricao(evento)
        assert registrado.id == "F-001"

        # Verifica que persiste no arquivo
        state = get_state()
        assert len(state.fricoes) == 1
        assert state.fricoes[0].tipo == "ALUCINACAO_TECNICA"

    def test_adicionar_principio_novo(self):
        """Novo princípio deve ser adicionado e persistido."""
        from api.ledger import Principio, adicionar_principio, listar_principios_ativos
        antes = len(listar_principios_ativos())
        p = Principio(
            id="P-TESTE",
            descricao="Teste: nunca hardcodar credenciais (HV-1)",
            origem="V25-teste",
            data="2026-05-15",
        )
        adicionado = adicionar_principio(p)
        assert adicionado.id == "P-TESTE"
        assert len(listar_principios_ativos()) == antes + 1

    def test_exportar_markdown_contem_principios(self):
        """O markdown exportado deve conter todos os princípios ativos."""
        from api.ledger import exportar_para_markdown
        md = exportar_para_markdown()
        assert "P-001" in md
        assert "P-005" in md
        assert "INTELLIGENCE LEDGER" in md
        assert "PRINCÍPIOS ATIVOS" in md


# ─────────────────────────────────────────────────────────────────────────────
# Alavanca 2 — Hard Veto bloqueia deploy
# ─────────────────────────────────────────────────────────────────────────────

class TestHardVetoDeployGuard:

    def test_sem_veto_deploy_liberado(self):
        """Sem vetos ativos, deploy deve ser liberado."""
        from api.ledger import verificar_bloqueio_deploy
        resultado = verificar_bloqueio_deploy("vanguard")
        assert resultado["bloqueado"] is False
        assert resultado["motivos"] == []

    def test_hard_veto_bloqueia_deploy(self):
        """Hard Veto ativo sem override deve bloquear deploy."""
        from api.ledger import VetoAtivo, ativar_veto, verificar_bloqueio_deploy
        veto = VetoAtivo(
            tipo="HV-4",
            projeto="vanguard",
            motivo="Dívida P0 ativa em api/scanner.py — scanner frontend-only",
            timestamp="2026-05-15T10:00:00Z",
        )
        ativar_veto(veto)
        resultado = verificar_bloqueio_deploy("vanguard")
        assert resultado["bloqueado"] is True
        assert "HV-4" in resultado["motivos"][0]

    def test_soft_veto_nao_bloqueia_deploy(self):
        """Soft Veto não deve bloquear deploy (apenas warning)."""
        from api.ledger import VetoAtivo, ativar_veto, verificar_bloqueio_deploy
        veto = VetoAtivo(
            tipo="SV-4",
            projeto="vanguard",
            motivo="DIRETRIZ com 7 prioridades — acima do limite de 5",
            timestamp="2026-05-15T10:00:00Z",
        )
        ativar_veto(veto)
        resultado = verificar_bloqueio_deploy("vanguard")
        assert resultado["bloqueado"] is False  # SV não bloqueia

    def test_override_diretor_libera_deploy(self):
        """Override do Diretor deve desbloquear o deploy."""
        from api.ledger import VetoAtivo, ativar_veto, resolver_veto, verificar_bloqueio_deploy
        veto = VetoAtivo(
            tipo="HV-3",
            projeto="vanguard",
            motivo="Custo acima do burn rate",
            timestamp="2026-05-15T10:00:00Z",
        )
        ativar_veto(veto)
        assert verificar_bloqueio_deploy("vanguard")["bloqueado"] is True

        resolvido = resolver_veto(
            tipo="HV-3",
            projeto="vanguard",
            override_diretor="OVERRIDE DOCUMENTADO: demo com cliente amanhã. Eduardo. 2026-05-15",
        )
        assert resolvido is True
        assert verificar_bloqueio_deploy("vanguard")["bloqueado"] is False

    def test_veto_de_outro_projeto_nao_bloqueia(self):
        """Veto de projeto X não deve bloquear deploy de projeto Y."""
        from api.ledger import VetoAtivo, ativar_veto, verificar_bloqueio_deploy
        veto = VetoAtivo(
            tipo="HV-5",
            projeto="cliente-abc",
            motivo="Breaking change sem kill-switch",
            timestamp="2026-05-15T10:00:00Z",
        )
        ativar_veto(veto)
        resultado = verificar_bloqueio_deploy("vanguard")
        assert resultado["bloqueado"] is False  # veto é de outro projeto


# ─────────────────────────────────────────────────────────────────────────────
# Alavanca 2 — API FastAPI
# ─────────────────────────────────────────────────────────────────────────────

class TestAPI:

    @pytest.fixture
    def client(self):
        from fastapi.testclient import TestClient
        from api.main import app
        return TestClient(app)

    def test_status_operacional(self, client):
        r = client.get("/status")
        assert r.status_code == 200
        data = r.json()
        assert data["status"] in ("operacional", "bloqueado")
        assert "principios_ativos" in data
        assert data["principios_ativos"] >= 10

    def test_listar_principios(self, client):
        r = client.get("/ledger/principios")
        assert r.status_code == 200
        data = r.json()
        assert data["total"] >= 10
        assert len(data["principios"]) >= 10

    def test_deploy_liberado_sem_veto(self, client):
        r = client.get("/deploy/verificar/meu-projeto")
        assert r.status_code == 200
        assert r.json()["deploy_liberado"] is True

    def test_deploy_bloqueado_com_hard_veto(self, client):
        # Ativa veto via API
        client.post("/ledger/veto", json={
            "tipo": "HV-1",
            "projeto": "meu-projeto",
            "motivo": "Credencial hardcoded detectada em config.py",
            "timestamp": "2026-05-15T10:00:00Z",
            "override_diretor": None,
        })
        r = client.get("/deploy/verificar/meu-projeto")
        assert r.status_code == 403
        detail = r.json()["detail"]
        assert "BLOQUEADO" in detail["mensagem"]

    def test_registrar_friccao_via_api(self, client):
        r = client.post("/ledger/friccao", json={
            "id": "",
            "timestamp": "2026-05-15T10:00:00Z",
            "sessao": "V25-teste",
            "tipo": "ESCOPO_INDEVIDO",
            "fonte": "Músculo",
            "instrucao_original": "Adicionar feature não aprovada",
            "problema_detectado": "Escopo silencioso detectado",
            "acao_tomada": "Feature removida, declarado ao Diretor",
            "principio_gerado": None,
            "severidade": "MEDIUM",
        })
        assert r.status_code == 200
        assert r.json()["registrado"] is True

    def test_exportar_ledger_markdown(self, client):
        r = client.get("/ledger/exportar")
        assert r.status_code == 200
        assert "INTELLIGENCE LEDGER" in r.text
        assert "P-001" in r.text


# ─────────────────────────────────────────────────────────────────────────────
# Alavanca 3 — Session Close
# ─────────────────────────────────────────────────────────────────────────────

class TestSessionClose:

    def test_session_close_silencioso(self, tmp_path, monkeypatch):
        """Session close em modo silencioso deve funcionar sem input interativo."""
        monkeypatch.chdir(tmp_path)
        # Cria ledger vazio
        (tmp_path / "ledger_state.json").write_text(json.dumps({
            "principios": [], "fricoes": [], "vetos_ativos": [],
            "sessoes_count": 0, "ultima_sessao": "", "versao": "V24"
        }))

        from scripts.session_close import executar_fechamento
        # Não deve levantar exceção
        executar_fechamento(
            sessao="V25-teste-automatico",
            projeto="vanguard",
            silencioso=True,
        )

        # Verifica que sessão foi incrementada no arquivo
        state = json.loads((tmp_path / "ledger_state.json").read_text())
        assert state["sessoes_count"] == 1
        assert state["ultima_sessao"] == "V25-teste-automatico"

    def test_veto_cli_ativar_e_resolver(self, tmp_path, monkeypatch):
        """CLI de veto deve ativar e resolver corretamente."""
        monkeypatch.chdir(tmp_path)
        (tmp_path / "ledger_state.json").write_text(json.dumps({
            "principios": [], "fricoes": [], "vetos_ativos": [],
            "sessoes_count": 0, "ultima_sessao": "", "versao": "V24"
        }))

        from scripts.veto import cmd_ativar, cmd_resolver

        class Args:
            tipo = "HV-4"
            projeto = "vanguard"
            motivo = "Dívida P0 ativa"
            override = "OVERRIDE: aceito risco. Eduardo."
            todos = False

        cmd_ativar(Args())
        state = json.loads((tmp_path / "ledger_state.json").read_text())
        assert len(state["vetos_ativos"]) == 1
        assert state["vetos_ativos"][0]["override_diretor"] is None

        cmd_resolver(Args())
        state = json.loads((tmp_path / "ledger_state.json").read_text())
        assert state["vetos_ativos"][0]["override_diretor"] == Args.override

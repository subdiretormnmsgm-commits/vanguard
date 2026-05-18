"""
SECRETÁRIO VIRTUAL — QUADRILATERAL IAH
Fase 1: Qualificação automática de leads + briefing para o Gemini

Fluxo:
  Cliente preenche Tally → webhook → Claude Haiku avalia → email para Eduardo
  Se GO: briefing pronto para colar no Gemini
  Se NO-GO: proposta de Produto de Entrada enviada automaticamente ao cliente
"""

import json
import os
import smtplib
from datetime import datetime
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

import anthropic
from dotenv import load_dotenv
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

load_dotenv()

app = FastAPI(title="Secretário Virtual — Quadrilateral IAH")

anthropic_client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))

GMAIL_USER = os.getenv("GMAIL_USER")
GMAIL_PASSWORD = os.getenv("GMAIL_PASSWORD")  # Gmail App Password
EDUARDO_EMAIL = os.getenv("EDUARDO_EMAIL")
PRODUTO_ENTRADA_LINK = os.getenv("PRODUTO_ENTRADA_LINK", "")
NOME_OPERADOR = os.getenv("NOME_OPERADOR", "Eduardo")
NOME_EMPRESA = os.getenv("NOME_EMPRESA", "Quadrilateral IAH")


# ─── PARSING DO TALLY ────────────────────────────────────────────────────────

def parse_tally(fields: list) -> dict:
    """Mapeia os campos do Tally para estrutura interna."""
    r = {}
    for f in fields:
        label = f.get("label", "").lower()
        value = f.get("value", "") or ""
        if isinstance(value, list):
            value = ", ".join(str(v) for v in value)

        if "problema" in label:
            r["problema"] = value
        elif "investimento" in label:
            r["investimento"] = value
        elif "consequência" in label or "urgencia_q" in label or ("urgência" in label and "prazo" not in label):
            r["urgencia_qualificacao"] = value
        elif "tipo" in label or "projecto" in label or "projeto" in label:
            r["tipo_projeto"] = value
        elif "cliente ideal" in label:
            r["cliente_ideal"] = value
        elif "volume" in label or "utilizadores" in label:
            r["volume"] = value
        elif "receita" in label or "ticket" in label:
            r["receita"] = value
        elif "existe" in label or "estado" in label:
            r["estado_atual"] = value
        elif "prazo" in label or "urgência" in label:
            r["urgencia_prazo"] = value
        elif "orçamento" in label or "recursos" in label:
            r["recursos"] = value
        elif "email" in label:
            r["email"] = value.strip().lower()
        elif "nome" in label:
            r["nome"] = value
        elif "whatsapp" in label or "telefone" in label:
            r["whatsapp"] = value

    return r


# ─── AVALIAÇÃO COM CLAUDE HAIKU ───────────────────────────────────────────────

EVALUATION_PROMPT = """Actuas como Secretário Virtual do Quadrilateral IAH.

Recebeste um formulário de potencial cliente. Avalia e formata o output.

DADOS DO LEAD:
Nome: {nome}
Email: {email}
WhatsApp: {whatsapp}

QUALIFICAÇÃO (GO/NO-GO):
Problema que custa dinheiro: {problema}
Investimento disponível: {investimento}
Consequência de não resolver: {urgencia_qualificacao}

DISCOVERY:
Tipo de projecto: {tipo_projeto}
Cliente ideal: {cliente_ideal}
Volume mensal: {volume}
Receita/ticket médio: {receita}
Estado actual: {estado_atual}
Urgência/prazo: {urgencia_prazo}
Orçamento/recursos: {recursos}

CRITÉRIOS GO/NO-GO:
GO se: problema específico e real, investimento compatível (não "o mínimo"), urgência real.
NO-GO se: problema vago, investimento "o mínimo possível" ou muito baixo, sem urgência.

CAMADAS:
1=MVP(1-5 dias), 2=Produto(1-3 sem), 3=Plataforma(2-6 sem), 4=Ecossistema(1-3 meses), 5=Monopólio(3-6 meses)

Responde APENAS com JSON válido neste formato exacto:
{{
  "decisao": "GO" ou "NO-GO",
  "razao": "1 frase explicando a decisão",
  "camada": 1-5 ou null,
  "alerta": "algo relevante sobre este lead que o Director deve saber",
  "briefing_gemini": "APENAS SE GO: texto completo do comando abaixo preenchido. Se NO-GO: null",
  "resposta_cliente": "mensagem personalizada para enviar ao cliente (tom humano, não robótico)"
}}

SE GO, o briefing_gemini deve seguir EXACTAMENTE este formato preenchido:
════════════════════════════════════════════
QUADRILATERAL IAH — NOVA ITERAÇÃO
Projecto: [tipo detectado] | DATA: {data}
════════════════════════════════════════════
Gemini, somos o Quadrilateral IAH.
Tu és o Estrategista. Eu sou o Director.
O NotebookLM é o Auditor. O Claude Code é o Músculo.

BRIEFING:
NICHO/SECTOR: [inferir do tipo de projecto e cliente ideal]
PROBLEMA PRINCIPAL: [problema declarado]
VOLUME MENSAL: [volume declarado]
RECEITA/TICKET: [receita declarada]
ESTADO ACTUAL: [estado declarado]
URGÊNCIA: [urgência declarada]
RECURSOS/ORÇAMENTO: [recursos declarados]
CAMADA ESTIMADA: [camada estimada]

RESPONDE COM 5 BLOCOS:
BLOCO 0 — DIAGNÓSTICO
BLOCO 1 — CAMADA E 3 PRIORIDADES
BLOCO 2 — PROPOSTA COMERCIAL
BLOCO 3 — DIRETRIZ TÉCNICA ([PARA O NOTEBOOKLM] e [PARA O CLAUDE])
BLOCO 4 — PRÓXIMOS PASSOS DO DIRECTOR
Inclui obrigatoriamente: 5 ideias disruptivas.
════════════════════════════════════════════

SE NO-GO, a resposta_cliente deve oferecer o Produto de Entrada (diagnóstico pago sem build).
"""


def evaluate_lead(r: dict) -> dict:
    prompt = EVALUATION_PROMPT.format(
        nome=r.get("nome", "N/A"),
        email=r.get("email", "N/A"),
        whatsapp=r.get("whatsapp", "N/A"),
        problema=r.get("problema", "Não informado"),
        investimento=r.get("investimento", "Não informado"),
        urgencia_qualificacao=r.get("urgencia_qualificacao", "Não informado"),
        tipo_projeto=r.get("tipo_projeto", "Não informado"),
        cliente_ideal=r.get("cliente_ideal", "Não informado"),
        volume=r.get("volume", "Não informado"),
        receita=r.get("receita", "Não informado"),
        estado_atual=r.get("estado_atual", "Não informado"),
        urgencia_prazo=r.get("urgencia_prazo", "Não informado"),
        recursos=r.get("recursos", "Não informado"),
        data=datetime.now().strftime("%d/%m/%Y"),
    )

    msg = anthropic_client.messages.create(
        model="claude-haiku-4-5-20251001",
        max_tokens=2000,
        messages=[{"role": "user", "content": prompt}],
    )

    raw = msg.content[0].text
    start, end = raw.find("{"), raw.rfind("}") + 1
    return json.loads(raw[start:end])


# ─── EMAIL ───────────────────────────────────────────────────────────────────

def send_email(to: str, subject: str, html: str):
    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"] = GMAIL_USER
    msg["To"] = to
    msg.attach(MIMEText(html, "html"))
    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as s:
        s.login(GMAIL_USER, GMAIL_PASSWORD)
        s.sendmail(GMAIL_USER, to, msg.as_string())


def email_eduardo(r: dict, ev: dict) -> str:
    decisao = ev["decisao"]
    emoji = "🟢" if decisao == "GO" else "🔴"
    camada = f" · Camada {ev['camada']}" if ev.get("camada") else ""

    if decisao == "GO":
        briefing_html = f"""
<h3>🤖 BRIEFING PRONTO — copiar e colar no Gemini</h3>
<pre style="background:#0a0a0a;color:#00f0ff;padding:16px;border-radius:8px;
font-size:12px;white-space:pre-wrap;font-family:monospace;">{ev.get('briefing_gemini','')}</pre>
"""
    else:
        briefing_html = f"""
<h3>💬 Resposta enviada ao cliente</h3>
<p style="background:#fff3cd;padding:12px;border-radius:6px;">{ev.get('resposta_cliente','')}</p>
<p><em>Nenhuma acção necessária da sua parte.</em></p>
"""

    return f"""
<div style="font-family:Inter,sans-serif;max-width:700px;margin:0 auto;">
  <div style="background:#0a0a0a;color:#00f0ff;padding:20px;border-radius:10px 10px 0 0;">
    <h2 style="margin:0;">{emoji} {decisao}{camada} — {r.get('nome','Novo lead')}</h2>
    <p style="margin:4px 0 0;color:#aaa;font-size:13px;">{datetime.now().strftime('%d/%m/%Y %H:%M')}</p>
  </div>
  <div style="background:#f9f9f9;padding:20px;border-radius:0 0 10px 10px;">

    <h3>📋 Lead</h3>
    <table style="border-collapse:collapse;width:100%;">
      <tr><td style="padding:4px 8px;font-weight:bold;">Nome</td><td>{r.get('nome','N/A')}</td></tr>
      <tr><td style="padding:4px 8px;font-weight:bold;">Email</td><td>{r.get('email','N/A')}</td></tr>
      <tr><td style="padding:4px 8px;font-weight:bold;">WhatsApp</td><td>{r.get('whatsapp','N/A')}</td></tr>
    </table>

    <h3>📌 Avaliação</h3>
    <p><strong>Decisão:</strong> {ev['razao']}</p>
    <p><strong>Alerta do Secretário:</strong> {ev.get('alerta','')}</p>

    {briefing_html}

  </div>
</div>
"""


def email_cliente_go(r: dict, ev: dict) -> str:
    return f"""
<div style="font-family:Inter,sans-serif;max-width:600px;margin:0 auto;">
  <p>Olá {r.get('nome','')},</p>
  <p>{ev.get('resposta_cliente','Obrigado pelo teu contacto. Entraremos em contacto brevemente.')}</p>
  <br>
  <p>Até breve,<br><strong>{NOME_OPERADOR}</strong><br>{NOME_EMPRESA}</p>
</div>
"""


def email_cliente_nogo(r: dict, ev: dict) -> str:
    produto_link = f'<br><br><a href="{PRODUTO_ENTRADA_LINK}">→ Saber mais sobre o Diagnóstico</a>' if PRODUTO_ENTRADA_LINK else ""
    return f"""
<div style="font-family:Inter,sans-serif;max-width:600px;margin:0 auto;">
  <p>Olá {r.get('nome','')},</p>
  <p>{ev.get('resposta_cliente','Obrigado pelo teu contacto.')}{produto_link}</p>
  <br>
  <p>Até breve,<br><strong>{NOME_OPERADOR}</strong><br>{NOME_EMPRESA}</p>
</div>
"""


# ─── ENDPOINTS ───────────────────────────────────────────────────────────────

@app.post("/webhook/tally")
async def tally_webhook(request: Request):
    try:
        body = await request.json()
        fields = body.get("data", {}).get("fields", [])
        r = parse_tally(fields)

        if not r.get("email"):
            return JSONResponse({"status": "ignored", "reason": "no_email"})

        ev = evaluate_lead(r)
        decisao = ev["decisao"]

        # Notificar Eduardo
        subject = f"{'🟢 GO' if decisao == 'GO' else '🔴 NO-GO'} · {r.get('nome','Lead')} · Camada {ev.get('camada','?')}"
        send_email(EDUARDO_EMAIL, subject, email_eduardo(r, ev))

        # Responder ao cliente
        if decisao == "GO":
            send_email(r["email"], f"Recebemos o teu contacto — {NOME_EMPRESA}", email_cliente_go(r, ev))
        else:
            send_email(r["email"], f"O teu pedido — {NOME_EMPRESA}", email_cliente_nogo(r, ev))

        return JSONResponse({"status": "ok", "decisao": decisao})

    except Exception as e:
        print(f"[ERRO] {e}")
        return JSONResponse({"status": "error"}, status_code=500)


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "service": "Secretário Virtual — Quadrilateral IAH",
        "versao": "1.0",
        "timestamp": datetime.now().isoformat(),
    }

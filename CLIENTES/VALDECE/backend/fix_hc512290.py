"""
Fix pontual — HC 512.290/RJ
Problema: registro no Supabase tem ementa e numero do REsp 1896440 (mix-up de corpus)
Solução: atualizar ementa/data/relator/numero_acordao + re-embedar

Uso:
  python fix_hc512290.py            # identifica o registro e pergunta antes de atualizar
  python fix_hc512290.py --apply    # aplica a correção
"""

import argparse
import os
import sys
import time
from pathlib import Path

import requests
from dotenv import load_dotenv
from supabase import create_client

load_dotenv(Path(__file__).parent.parent / ".env")

SUPABASE_URL = os.environ["SUPABASE_URL"]
SUPABASE_SERVICE_KEY = os.environ["SUPABASE_SERVICE_KEY"]
GEMINI_API_KEY = os.environ["GEMINI_API_KEY"]

GEMINI_EMBED_URL = (
    "https://generativelanguage.googleapis.com/v1beta/models/"
    "gemini-embedding-001:embedContent"
)

# Dado correto do HC 512.290/RJ
HC_EMENTA = (
    "HABEAS CORPUS. ORGANIZAÇÃO CRIMINOSA. EXTORSÃO, CONCUSSÃO E EXTORSÃO MEDIANTE SEQUESTRO "
    "POR POLICIAIS CIVIS. POSSIBILIDADE DE APOIO DE AGÊNCIA DE INTELIGÊNCIA À INVESTIGAÇÃO DO "
    "MINISTÉRIO PÚBLICO. NÃO OCORRÊNCIA DE INFILTRAÇÃO POLICIAL. DESNECESSIDADE DE AUTORIZAÇÃO "
    "JUDICIAL PRÉVIA PARA A AÇÃO CONTROLADA. COMUNICAÇÃO POSTERIOR QUE VISA A PROTEGER O TRABALHO "
    "INVESTIGATIVO. HABEAS CORPUS DENEGADO.\n"
    "1. A atividade de inteligência desempenhada por agências dos estados, que integram o Subsistema "
    "de Inteligência criado pelo Decreto n. 3.695, de 21/12/2012, consiste no exercício de ações "
    "especializadas para identificar, avaliar e acompanhar ameaças reais ou potenciais na esfera de "
    "segurança pública. Alcança diversos campos de atuação - um deles a inteligência policial "
    "judiciária - e entre suas finalidades está não só subsidiar o planejamento estratégico de "
    "políticas públicas, mas também assessorar com informações as ações de prevenção e repressão "
    "de atos criminosos.\n"
    "2. Apesar de não se confundir com a investigação, nem se esgotar com o objetivo desta, uma vez "
    "que a inteligência de segurança pública opera na busca incessante de dados, o resultado de suas "
    "operações pode, ocasionalmente, ser aproveitado no processo penal para subsidiar a produção de "
    "provas, desde que materializado em relatório técnico.\n"
    "3. No passado, no Estado do Rio de Janeiro, ante a necessidade de aperfeiçoar o combate a "
    "crimes cometidos por policiais, foi atribuída à Subscretaria de Inteligência (SSINTE/SESEG) a "
    "missão de prestar apoio a determinados órgãos em suas investigações criminais.\n"
    "4. Nesse contexto, não é ilegal o auxílio da agência de inteligência ao Ministério Público do "
    "Estado do Rio de Janeiro durante procedimento criminal instaurado para apurar graves crimes "
    "atribuídos a servidores de Delegacia do Meio Ambiente, em contexto de organização criminosa.\n"
    "5. O Parquet optou por não utilizar a estrutura da própria Polícia Civil para auxiliá-lo no "
    "procedimento apuratório criminal, e é incabível criar limitação, alheia ao texto constitucional, "
    "para o exercício conjunto da atividade investigativa pelos órgãos estatais.\n"
    "6. Esta Corte possui o entendimento de que a atribuição de polícia judiciária às polícias civil "
    "e federal não torna nula a colheita de elementos informativos por outras fontes. Ademais, o art. "
    "3°, VIII, da Lei n. 12.850/2013 permite a cooperação entre as instituições públicas na busca de "
    "dados de interesse da investigação.\n"
    "7. Se agente lotada em agência de inteligência, sob identidade falsa, apenas representou o "
    "ofendido nas negociações da extorsão, sem se introduzir ou se infiltrar na organização criminosa "
    "com o propósito de identificar e angariar a confiança de seus membros ou obter provas sobre a "
    "estrutura e o funcionamento do bando, não há falar em infiltração policial.\n"
    "8. O acórdão recorrido está em conformidade com a jurisprudência desta Corte, de que a gravação "
    "ambiental realizada por colaborador premiado, um dos interlocutores da conversa, sem o "
    "consentimento dos outros, é lícita, ainda que obtida sem autorização judicial, e pode ser "
    "validamente utilizada como meio de prova no processo penal.\n"
    "9. A ação controlada prevista no § 1° do art. 8° da Lei n. 12.850/2013 não necessita de "
    "autorização judicial. A comunicação prévia ao Poder Judiciário, a seu turno, visa a proteger o "
    "trabalho investigativo, de forma a afastar eventual crime de prevaricação ou infração "
    "administrativa por parte do agente público.\n"
    "10. As autoridades acompanharam o recebimento de dinheiro por servidores suspeitos de extorsão "
    "mediante sequestro, na fase do exaurimento do crime, e não há ilegalidade a ser reconhecida em "
    "habeas corpus se ausentes circunstâncias preparadas de forma insidiosa.\n"
    "11. O habeas corpus não se presta à análise de teses que demandam exame ou realização de provas.\n"
    "12. Habeas corpus denegado."
)

HC_CORRECT = {
    "numero_acordao": "HC 512.290",
    "data_julgamento": "2020-08-18",
    "relator": "Rogerio Schietti Cruz",
    "tribunal": "STJ",
    "tema": "investigacao_policial",
    "ementa": HC_EMENTA,
    "content": HC_EMENTA,
    "link": "https://scon.stj.jus.br/SCON/pesquisar.jsp?b=ACOR&livre=@NUM%20'HC%20512.290'",
}

# Identificador do registro errado (ementa começa com REsp)
WRONG_EMENTA_PREFIX = "RECURSO ESPECIAL. DOSIMETRIA DA PENA"


def embed_text(text: str) -> list[float]:
    payload = {
        "model": "models/gemini-embedding-001",
        "content": {"parts": [{"text": text}]},
        "taskType": "RETRIEVAL_DOCUMENT",
        "outputDimensionality": 768,
    }
    resp = requests.post(
        GEMINI_EMBED_URL,
        headers={"Content-Type": "application/json"},
        params={"key": GEMINI_API_KEY},
        json=payload,
        timeout=30,
    )
    resp.raise_for_status()
    return resp.json()["embedding"]["values"]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="Aplicar a correção")
    args = parser.parse_args()

    sb = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

    # Localizar o registro errado
    resp = sb.table("documents").select("id, numero_acordao, data_julgamento, ementa").execute()
    wrong = [
        r for r in resp.data
        if r.get("ementa", "").startswith(WRONG_EMENTA_PREFIX)
    ]

    if not wrong:
        # Tentar também por numero_acordao
        wrong = [
            r for r in resp.data
            if r.get("numero_acordao", "") == "REsp 1896440"
        ]

    if not wrong:
        print("⚠️  Registro errado não encontrado. Talvez já tenha sido corrigido.")
        sys.exit(0)

    print(f"Registros encontrados com dados incorretos: {len(wrong)}")
    for r in wrong:
        print(f"  ID={r['id']} | numero={r['numero_acordao']} | data={r['data_julgamento']}")
        print(f"  Ementa (primeiros 80 chars): {r.get('ementa','')[:80]}")

    if not args.apply:
        print("\n[DRY RUN] Para aplicar a correção, rodar: python fix_hc512290.py --apply")
        sys.exit(0)

    record_id = wrong[0]["id"]
    print(f"\nGerando embedding correto para HC 512.290/RJ...")
    embedding = embed_text(HC_EMENTA)
    print(f"Embedding gerado — dimensões: {len(embedding)}")
    time.sleep(0.5)

    update_payload = {**HC_CORRECT, "embedding": embedding}
    sb.table("documents").update(update_payload).eq("id", record_id).execute()

    print(f"✅ Registro {record_id} corrigido com sucesso.")
    print(f"   numero_acordao: HC 512.290")
    print(f"   data_julgamento: 2020-08-18")
    print(f"   relator: Rogerio Schietti Cruz")
    print(f"   Embedding re-gerado.")


if __name__ == "__main__":
    main()

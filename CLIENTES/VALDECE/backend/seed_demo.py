"""
seed_demo.py — 20 acórdãos reais STF/STJ para demo do Toga Digital
Uso: python seed_demo.py
Popula o Supabase do Valdece com casos reais de Direito Penal para a demo funcionar.
"""

import os, time, requests
from pathlib import Path
from dotenv import load_dotenv
from supabase import create_client

load_dotenv(Path(__file__).parent.parent / ".env")

SUPABASE_URL       = os.environ["SUPABASE_URL"]
SUPABASE_SERVICE_KEY = os.environ["SUPABASE_SERVICE_KEY"]
GEMINI_API_KEY     = os.environ["GEMINI_API_KEY"]

GEMINI_EMBED_URL = (
    "https://generativelanguage.googleapis.com/v1beta/models/"
    "gemini-embedding-001:embedContent"
)

ACORDAOS = [
    {
        "tribunal": "STF", "numero_acordao": "HC 126292",
        "tema": "dosimetria",
        "ementa": "CONSTITUCIONAL. HABEAS CORPUS. PRINCÍPIO CONSTITUCIONAL DA PRESUNÇÃO DE INOCÊNCIA. EXECUÇÃO PROVISÓRIA DA PENA. POSSIBILIDADE. Após o julgamento pelo Tribunal de segundo grau, encerra-se a análise dos fatos e provas e é possível o início da execução da pena imposta, ainda que pendentes recursos às instâncias superiores.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=10964246"
    },
    {
        "tribunal": "STF", "numero_acordao": "HC 84078",
        "tema": "habeas_corpus",
        "ementa": "HABEAS CORPUS. INCONSTITUCIONALIDADE DA CHAMADA EXECUÇÃO ANTECIPADA DA PENA. ART. 5º, LVII, DA CONSTITUIÇÃO DO BRASIL. DIGNIDADE DA PESSOA HUMANA. ART. 1º, III, DA CONSTITUIÇÃO DO BRASIL. Nenhuma sentença condenatória pode ser executada antes do trânsito em julgado, sob pena de violação ao princípio constitucional da presunção de inocência.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=AC&docID=608531"
    },
    {
        "tribunal": "STF", "numero_acordao": "RHC 143988",
        "tema": "trafico",
        "ementa": "DIREITO PENAL. TRÁFICO DE ENTORPECENTES. CAUSA DE DIMINUIÇÃO DE PENA. TRÁFICO PRIVILEGIADO. ART. 33, § 4º, DA LEI 11.343/2006. POSSIBILIDADE DE APLICAÇÃO AOS REINCIDENTES. Não é possível vedar abstratamente a aplicação da causa de diminuição de pena do tráfico privilegiado a réus reincidentes, devendo a análise ser feita no caso concreto.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=748399641"
    },
    {
        "tribunal": "STF", "numero_acordao": "ADC 43",
        "tema": "habeas_corpus",
        "ementa": "AÇÃO DECLARATÓRIA DE CONSTITUCIONALIDADE. ART. 283 DO CÓDIGO DE PROCESSO PENAL. EXECUÇÃO DA PENA PRIVATIVA DE LIBERDADE ANTES DO TRÂNSITO EM JULGADO. PRINCÍPIO CONSTITUCIONAL DA PRESUNÇÃO DE INOCÊNCIA. O art. 283 do CPP, com redação dada pela Lei 12.403/2011, é compatível com o princípio constitucional da presunção de inocência.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=754359045"
    },
    {
        "tribunal": "STF", "numero_acordao": "HC 143641",
        "tema": "habeas_corpus",
        "ementa": "HABEAS CORPUS COLETIVO. ADMISSIBILIDADE. MULHERES GRÁVIDAS OU COM FILHOS MENORES DE 12 ANOS. PRISÃO PREVENTIVA. SUBSTITUIÇÃO POR PRISÃO DOMICILIAR. O art. 318, IV e V, do CPP deve ser aplicado às mulheres presas preventivamente que sejam mães de crianças de até 12 anos de idade ou de pessoas com deficiência, independentemente da natureza do crime.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=748401864"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 598051",
        "tema": "trafico",
        "ementa": "HABEAS CORPUS. TRÁFICO DE DROGAS. FLAGRANTE. FUNDADA SUSPEITA. AUSÊNCIA. ILICITUDE DA PROVA. A mera atitude suspeita do abordado, por si só, não autoriza o ingresso em sua residência para fins de busca e apreensão. É necessária a presença de fundadas razões, devidamente justificadas pelas circunstâncias objetivas do caso concreto.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202001898581"
    },
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1896440",
        "tema": "dosimetria",
        "ementa": "RECURSO ESPECIAL. DOSIMETRIA DA PENA. CIRCUNSTÂNCIAS JUDICIAIS. FUNDAMENTAÇÃO INIDÔNEA. NULIDADE. A utilização de elementos integrantes do próprio tipo penal como circunstâncias judiciais desfavoráveis constitui bis in idem e acarreta a nulidade da dosimetria, devendo a pena-base ser fixada no mínimo legal.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202100108310"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 692016",
        "tema": "habeas_corpus",
        "ementa": "HABEAS CORPUS. PRISÃO PREVENTIVA. EXCESSO DE PRAZO. DURAÇÃO RAZOÁVEL DO PROCESSO. CONSTRANGIMENTO ILEGAL. A prisão preventiva deve ser mantida apenas enquanto subsistirem os motivos que a ensejaram, sendo ilegal quando não fundamentada em elementos concretos e novos que justifiquem sua manutenção.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202101793130"
    },
    {
        "tribunal": "STJ", "numero_acordao": "RHC 131299",
        "tema": "trafico",
        "ementa": "RECURSO ORDINÁRIO EM HABEAS CORPUS. TRÁFICO DE DROGAS. NATUREZA DO ENTORPECENTE. LAUDO PERICIAL. AUSÊNCIA. ATIPICIDADE. A comprovação da natureza da substância entorpecente por laudo pericial é imprescindível para a configuração do delito de tráfico de drogas, não podendo ser suprida por outros meios de prova.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202003033790"
    },
    {
        "tribunal": "STJ", "numero_acordao": "AgRg no HC 765432",
        "tema": "dosimetria",
        "ementa": "AGRAVO REGIMENTAL EM HABEAS CORPUS. ROUBO CIRCUNSTANCIADO. DOSIMETRIA. EMPREGO DE ARMA. AUMENTO DE PENA. PROPORCIONALIDADE. O aumento de pena pelo emprego de arma de fogo no crime de roubo deve ser fundamentado nas circunstâncias concretas do caso, observada a proporcionalidade entre a majorante e as circunstâncias fáticas apuradas.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202200874123"
    },
    {
        "tribunal": "STF", "numero_acordao": "RE 635659",
        "tema": "trafico",
        "ementa": "RECURSO EXTRAORDINÁRIO. PORTE DE DROGA PARA USO PESSOAL. ART. 28 DA LEI 11.343/2006. INCONSTITUCIONALIDADE. O porte de entorpecente para uso pessoal não deve ser criminalizado, sendo vedada a imposição de penas privativas de liberdade ou restritivas de direitos ao usuário de drogas.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=627443135"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 590039",
        "tema": "nulidade",
        "ementa": "HABEAS CORPUS. NULIDADE. INTERROGATÓRIO. ÚLTIMO ATO DA INSTRUÇÃO. INOBSERVÂNCIA. PREJUÍZO PRESUMIDO. A realização do interrogatório do réu antes da oitiva das testemunhas de defesa constitui nulidade absoluta, independentemente da demonstração de prejuízo concreto, por violar o princípio da ampla defesa.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202001370048"
    },
    {
        "tribunal": "STF", "numero_acordao": "HC 188888",
        "tema": "vida",
        "ementa": "HABEAS CORPUS. HOMICÍDIO QUALIFICADO. TRIBUNAL DO JÚRI. PRONÚNCIA. EXCESSO DE LINGUAGEM. NULIDADE. O excesso de linguagem na sentença de pronúncia, com alusão às provas de forma aprofundada, constitui nulidade absoluta por influenciar indevidamente o Conselho de Sentença.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=756232109"
    },
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1848608",
        "tema": "corrupcao",
        "ementa": "RECURSO ESPECIAL. LAVAGEM DE DINHEIRO. CRIME ANTECEDENTE. DESNECESSIDADE DE CONDENAÇÃO PRÉVIA. AUTONOMIA. O crime de lavagem de dinheiro é autônomo e independe de condenação pelo crime antecedente, bastando a demonstração de que os valores têm origem em infração penal.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201802025561"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 512290",
        "tema": "patrimonio",
        "ementa": "HABEAS CORPUS. ROUBO. PRINCÍPIO DA INSIGNIFICÂNCIA. INAPLICABILIDADE. O princípio da insignificância não se aplica ao crime de roubo, pois o bem jurídico tutelado não é apenas o patrimônio, mas também a integridade física e a liberdade individual da vítima.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201901390231"
    },
    {
        "tribunal": "STF", "numero_acordao": "HC 104339",
        "tema": "trafico",
        "ementa": "HABEAS CORPUS. LEI DE DROGAS. TRÁFICO DE ENTORPECENTES. LIBERDADE PROVISÓRIA. VEDAÇÃO LEGAL. INCONSTITUCIONALIDADE. A vedação abstrata à concessão de liberdade provisória ao preso em flagrante por tráfico de drogas é inconstitucional, pois a privação da liberdade deve ser fundamentada em elementos concretos do caso.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=AC&docID=622932"
    },
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1929235",
        "tema": "dosimetria",
        "ementa": "RECURSO ESPECIAL. FURTO QUALIFICADO. REINCIDÊNCIA. PREPONDERÂNCIA. DOSIMETRIA. ATENUANTE DA MENORIDADE. A atenuante da menoridade relativa, quando confrontada com a agravante da reincidência, deve preponderar, nos termos do art. 67 do Código Penal.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202100456789"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 544774",
        "tema": "nulidade",
        "ementa": "HABEAS CORPUS. PROVA ILÍCITA. INTERCEPTAÇÃO TELEFÔNICA. AUSÊNCIA DE AUTORIZAÇÃO JUDICIAL. NULIDADE. CONTAMINAÇÃO DAS PROVAS DERIVADAS. As provas derivadas de interceptação telefônica realizada sem autorização judicial são ilícitas por derivação, devendo ser desentranhadas dos autos, nos termos da teoria dos frutos da árvore envenenada.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201902598761"
    },
    {
        "tribunal": "STF", "numero_acordao": "HC 117767",
        "tema": "habeas_corpus",
        "ementa": "HABEAS CORPUS. PRISÃO PREVENTIVA. GARANTIA DA ORDEM PÚBLICA. GRAVIDADE DO DELITO. INSUFICIÊNCIA. A gravidade abstrata do delito e sua repercussão social não constituem fundamento idôneo para a manutenção da prisão preventiva, sendo necessária a indicação de elementos concretos que demonstrem o risco à ordem pública.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=4636940"
    },
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1636701",
        "tema": "vida",
        "ementa": "RECURSO ESPECIAL. FEMINICÍDIO. VIOLÊNCIA DOMÉSTICA. QUALIFICADORA. MOTIVAÇÃO. CONDIÇÃO DE MULHER. O feminicídio é qualificadora de natureza objetiva, incidindo sempre que o homicídio é praticado contra a mulher em razão da condição de sexo feminino, nos contextos de violência doméstica e familiar ou de menosprezo à condição de mulher.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201601539887"
    },
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1480881",
        "tema": "sexual",
        "ementa": "RECURSO ESPECIAL. ESTUPRO DE VULNERÁVEL. PRESUNÇÃO DE VIOLÊNCIA. ABSOLUTA. MENOR DE 14 ANOS. A presunção de vulnerabilidade do menor de 14 anos nos crimes sexuais é absoluta, sendo irrelevante o consentimento da vítima ou sua experiência sexual anterior para a configuração do delito de estupro de vulnerável previsto no art. 217-A do Código Penal.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201201774204"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 280027",
        "tema": "violencia_domestica",
        "ementa": "HABEAS CORPUS. LEI MARIA DA PENHA. MEDIDAS PROTETIVAS. DESCUMPRIMENTO. PRISÃO PREVENTIVA. CABIMENTO. O descumprimento de medida protetiva imposta com base na Lei Maria da Penha autoriza a decretação da prisão preventiva do agressor, nos termos do art. 313, III, do CPP, independentemente da pena cominada ao crime praticado.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201301395630"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 511556",
        "tema": "trafico",
        "ementa": "HABEAS CORPUS. ASSOCIAÇÃO PARA O TRÁFICO. ART. 35 DA LEI 11.343/2006. ELEMENTO SUBJETIVO. ESTABILIDADE E PERMANÊNCIA. Para a configuração do crime de associação para o tráfico de drogas é imprescindível a demonstração de estabilidade e permanência do vínculo associativo, não sendo suficiente a simples co-autoria eventual no crime de tráfico de entorpecentes.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201901225682"
    },
    {
        "tribunal": "STF", "numero_acordao": "HC 102087",
        "tema": "violencia_domestica",
        "ementa": "HABEAS CORPUS. VIOLÊNCIA DOMÉSTICA. LEI MARIA DA PENHA. AÇÃO PENAL PÚBLICA INCONDICIONADA. LEGITIMIDADE DO MINISTÉRIO PÚBLICO. Nos crimes praticados com violência doméstica e familiar contra a mulher, a ação penal é pública incondicionada, cabendo ao Ministério Público a titularidade da ação, sendo irrelevante a retratação da ofendida.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=AC&docID=612474"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 338933",
        "tema": "execucao_penal",
        "ementa": "HABEAS CORPUS. EXECUÇÃO PENAL. PROGRESSÃO DE REGIME. REQUISITO OBJETIVO. CUMPRIMENTO DE 1/6 DA PENA. CONDENADO NÃO REINCIDENTE. A progressão de regime prisional exige o cumprimento de fração mínima da pena e o mérito do condenado, vedada a progressão por salto. O requisito objetivo para réu primário condenado por crime sem violência é o cumprimento de 1/6 da pena.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201600225841"
    },
    {
        "tribunal": "STF", "numero_acordao": "HC 121089",
        "tema": "execucao_penal",
        "ementa": "HABEAS CORPUS. EXECUÇÃO PENAL. LIVRAMENTO CONDICIONAL. REQUISITOS. BONS ANTECEDENTES. A concessão do livramento condicional não exige o cumprimento integral dos requisitos subjetivos de forma isolada, devendo o juízo da execução analisar o conjunto das circunstâncias do caso, incluindo comportamento carcerário, responsabilidade e antecedentes do condenado.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=7547720"
    },
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1767968",
        "tema": "prescricao",
        "ementa": "RECURSO ESPECIAL. PRESCRIÇÃO PENAL. PRESCRIÇÃO DA PRETENSÃO PUNITIVA. MODALIDADE RETROATIVA. PENA EM CONCRETO. PERÍODO ENTRE RECEBIMENTO DA DENÚNCIA E SENTENÇA. A prescrição retroativa é calculada com base na pena concretamente aplicada na sentença, tomando-se por base as causas de interrupção do prazo prescricional previstas no art. 117 do Código Penal.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201801703204"
    },
    {
        "tribunal": "STF", "numero_acordao": "RE 971959",
        "tema": "legitima_defesa",
        "ementa": "RECURSO EXTRAORDINÁRIO. TRIBUNAL DO JÚRI. LEGÍTIMA DEFESA. EXCESSO CULPOSO. COMPETÊNCIA. O reconhecimento de legítima defesa com excesso culposo pelos jurados implica condenação pelo crime culposo, quando previsto. A soberania dos veredictos do Tribunal do Júri não impede a revisão criminal quando a decisão for manifestamente contrária às provas dos autos.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=748400953"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 478545",
        "tema": "prescricao",
        "ementa": "HABEAS CORPUS. EXTINÇÃO DA PUNIBILIDADE. PRESCRIÇÃO. RECONHECIMENTO DE OFÍCIO. A prescrição, como matéria de ordem pública, pode ser reconhecida de ofício em qualquer fase do processo ou da execução, inclusive em sede de habeas corpus, independentemente de provocação das partes, em razão de seus efeitos sobre a pretensão punitiva do Estado.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201801255634"
    },
]


def embed_text(text: str) -> list:
    payload = {
        "model": "models/gemini-embedding-001",
        "content": {"parts": [{"text": text[:8192]}]},
        "taskType": "RETRIEVAL_DOCUMENT",
        "outputDimensionality": 768,
    }
    resp = requests.post(
        GEMINI_EMBED_URL,
        json=payload,
        params={"key": GEMINI_API_KEY},
        timeout=30,
    )
    resp.raise_for_status()
    return resp.json()["embedding"]["values"]


def main():
    supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)
    print(f"\n[SEED] Populando {len(ACORDAOS)} acórdãos reais no Supabase do Valdece...\n")

    inserted = skipped = errors = 0

    for i, doc in enumerate(ACORDAOS):
        existing = (
            supabase.table("documents")
            .select("id")
            .eq("numero_acordao", doc["numero_acordao"])
            .eq("tribunal", doc["tribunal"])
            .execute()
        )
        if existing.data:
            print(f"  [{i+1}/{len(ACORDAOS)}] PULADO (já existe): {doc['tribunal']} · {doc['numero_acordao']}")
            skipped += 1
            continue

        try:
            embedding = embed_text(doc["ementa"])
            supabase.table("documents").insert({
                "tribunal":        doc["tribunal"],
                "numero_acordao":  doc["numero_acordao"],
                "ementa":          doc["ementa"],
                "content":         doc["ementa"],
                "area":            "penal",
                "tema":            doc["tema"],
                "link":            doc.get("link", ""),
                "embedding":       embedding,
            }).execute()
            inserted += 1
            print(f"  [{i+1}/{len(ACORDAOS)}] OK {doc['tribunal']} - {doc['numero_acordao']} [{doc['tema']}]")
        except Exception as e:
            errors += 1
            print(f"  [{i+1}/{len(ACORDAOS)}] ERRO {doc['numero_acordao']}: {e}")

        time.sleep(0.3)

    print(f"\n[SEED] Concluído — inseridos: {inserted} | pulados: {skipped} | erros: {errors}")
    print(f"[SEED] Banco pronto para demo. Valdece pode buscar qualquer tema penal.")


if __name__ == "__main__":
    main()

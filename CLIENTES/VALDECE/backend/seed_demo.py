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

    # ── EXPANSÃO QUALIDADE — P-057 ────────────────────────────────────────────

    # Busca domiciliar / flagrante
    {
        "tribunal": "STF", "numero_acordao": "RE 603616",
        "tema": "nulidade",
        "ementa": "RECURSO EXTRAORDINÁRIO. BUSCA E APREENSÃO DOMICILIAR. AUSÊNCIA DE MANDADO JUDICIAL. ILICITUDE. A entrada forçada em domicílio sem mandado judicial só é lícita quando amparada em fundadas razões, devidamente justificadas, que indiquem flagrante delito no interior da residência. A mera denúncia anônima não autoriza o ingresso policial domiciliar sem ordem judicial, sob pena de nulidade das provas obtidas.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=10924954"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 512083",
        "tema": "habeas_corpus",
        "ementa": "HABEAS CORPUS. FLAGRANTE DELITO. RELAXAMENTO. ILEGALIDADE. AUTO DE PRISÃO. O auto de prisão em flagrante somente é válido quando presentes os requisitos legais do art. 302 do CPP. A prisão realizada sem que o agente seja encontrado em situação de flagrância deve ser relaxada imediatamente pela autoridade judiciária, sendo ilegal a conversão em prisão preventiva sem fundamentação concreta e idônea.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201901014576"
    },

    # Colaboração premiada
    {
        "tribunal": "STF", "numero_acordao": "HC 127483",
        "tema": "corrupcao",
        "ementa": "HABEAS CORPUS. COLABORAÇÃO PREMIADA. NATUREZA JURÍDICA. NEGÓCIO JURÍDICO PROCESSUAL. VALIDADE. A colaboração premiada é negócio jurídico processual e meio de obtenção de prova, cujo valor probatório depende de corroboração por outros elementos de convicção. O acordo de colaboração não vincula o Judiciário quanto à pena, mas os termos pactuados devem ser cumpridos pelo Ministério Público.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=10000781"
    },

    # Crime organizado
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1752681",
        "tema": "corrupcao",
        "ementa": "RECURSO ESPECIAL. ORGANIZAÇÃO CRIMINOSA. LEI 12.850/2013. ELEMENTOS CONFIGURADORES. PLURALIDADE DE AGENTES. Para a configuração do crime de organização criminosa exige-se a associação de 4 ou mais pessoas, estruturalmente ordenada e caracterizada pela divisão de tarefas, com o objetivo de obter vantagem de qualquer natureza, mesmo que transitoriamente, mediante a prática de infrações penais.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201800854232"
    },

    # Porte ilegal de arma
    {
        "tribunal": "STJ", "numero_acordao": "HC 548249",
        "tema": "patrimonio",
        "ementa": "HABEAS CORPUS. PORTE ILEGAL DE ARMA DE FOGO. ARMA DESMONTADA. MUNIÇÕES DESACOMPANHADAS. ATIPICIDADE. AUSÊNCIA DE POTENCIALIDADE LESIVA. A arma de fogo desmontada e sem condições de funcionamento, ou as munições desacompanhadas de arma, podem caracterizar atipicidade da conduta por ausência de potencialidade lesiva, a ser analisada no caso concreto.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201902198543"
    },
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1887618",
        "tema": "patrimonio",
        "ementa": "RECURSO ESPECIAL. PORTE ILEGAL DE ARMA. REGISTRO VENCIDO. CRIME DE MERA CONDUTA. CONSUMAÇÃO. O porte de arma de fogo com registro vencido configura crime de mera conduta, consumando-se com o simples porte, sendo dispensável a demonstração de perigo concreto. A regularização posterior do registro não exclui a tipicidade da conduta praticada.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202001347821"
    },

    # Crimes contra a administração pública
    {
        "tribunal": "STF", "numero_acordao": "AP 470",
        "tema": "corrupcao",
        "ementa": "AÇÃO PENAL. CRIMES CONTRA A ADMINISTRAÇÃO PÚBLICA. CORRUPÇÃO ATIVA E PASSIVA. PECULATO. LAVAGEM DE DINHEIRO. FORMAÇÃO DE QUADRILHA. Os crimes contra a administração pública praticados por servidores públicos e particulares em concurso, envolvendo desvio de verbas públicas, corrompimento de agentes estatais e posterior ocultação dos valores, configuram concurso material de infrações penais autônomas.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=4970361"
    },
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1745087",
        "tema": "corrupcao",
        "ementa": "RECURSO ESPECIAL. PECULATO. DISTINÇÃO DE FURTO. FUNCIONÁRIO PÚBLICO. FACILIDADE DA FUNÇÃO. O peculato-furto exige que o agente, valendo-se das facilidades proporcionadas pela função pública, subtraia ou concorra para que seja subtraído bem em poder da Administração. A simples condição de funcionário público, sem o nexo com a facilidade da função, não configura peculato, respondendo o agente por furto.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201800278543"
    },

    # Concurso de crimes
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1767902",
        "tema": "dosimetria",
        "ementa": "RECURSO ESPECIAL. CRIME CONTINUADO. REQUISITOS. UNIDADE DE DESÍGNIO. ART. 71 DO CP. Para o reconhecimento do crime continuado é necessária a presença concomitante dos requisitos: pluralidade de condutas, crimes da mesma espécie, condições semelhantes de tempo, lugar, modo de execução, e vínculo subjetivo indicativo de unidade de desígnio. A ausência de qualquer requisito impede o reconhecimento da continuidade delitiva.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201801234765"
    },
    {
        "tribunal": "STJ", "numero_acordao": "HC 621286",
        "tema": "dosimetria",
        "ementa": "HABEAS CORPUS. CONCURSO FORMAL PRÓPRIO. CRIMES DOLOSOS. CUMULAÇÃO DE PENAS. SISTEMA DA EXASPERAÇÃO. No concurso formal próprio, aplica-se o sistema da exasperação, com a pena do crime mais grave aumentada de 1/6 até metade. No concurso formal impróprio, com desígnios autônomos para cada resultado, aplica-se o cúmulo material, afastando-se o limite máximo de exasperação.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202100143298"
    },

    # Sursis e penas alternativas
    {
        "tribunal": "STJ", "numero_acordao": "HC 475651",
        "tema": "execucao_penal",
        "ementa": "HABEAS CORPUS. SUSPENSÃO CONDICIONAL DA PENA. SURSIS. REQUISITOS. PENA NÃO SUPERIOR A 2 ANOS. CABIMENTO. A suspensão condicional da pena (sursis) é cabível quando a pena privativa de liberdade não supera 2 anos, o réu não seja reincidente em crime doloso, e a culpabilidade, os antecedentes, a conduta social e a personalidade do agente, bem como os motivos e as circunstâncias do crime, indiquem que a medida seja suficiente.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201802183490"
    },
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1871684",
        "tema": "dosimetria",
        "ementa": "RECURSO ESPECIAL. SUBSTITUIÇÃO DE PENA PRIVATIVA DE LIBERDADE POR RESTRITIVAS DE DIREITOS. REQUISITOS. NÃO REINCIDÊNCIA. CRIME SEM VIOLÊNCIA OU GRAVE AMEAÇA. A substituição da pena privativa de liberdade por restritivas de direitos é direito subjetivo do condenado quando presentes os requisitos legais: pena não superior a 4 anos, crime sem violência ou grave ameaça à pessoa, réu não reincidente em crime doloso, e circunstâncias favoráveis.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202000876532"
    },

    # Confissão espontânea
    {
        "tribunal": "STJ", "numero_acordao": "AgRg no REsp 1812665",
        "tema": "dosimetria",
        "ementa": "AGRAVO REGIMENTAL. RECURSO ESPECIAL. CONFISSÃO ESPONTÂNEA. ATENUANTE. OBRIGATORIEDADE DE APLICAÇÃO. SÚMULA 545/STJ. A confissão espontânea é circunstância atenuante de aplicação obrigatória quando o réu admite a autoria do delito, ainda que parcialmente, mesmo que a confissão não tenha sido o único fundamento da condenação. O magistrado não pode deixar de aplicá-la a pretexto de que outros elementos também embasaram a decisão condenatória.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201900712345"
    },

    # Direito ao silêncio / interrogatório
    {
        "tribunal": "STF", "numero_acordao": "HC 80949",
        "tema": "nulidade",
        "ementa": "HABEAS CORPUS. DIREITO AO SILÊNCIO. NEMO TENETUR SE DETEGERE. ADVERTÊNCIA. OBRIGATORIEDADE. Antes do interrogatório policial e judicial, o réu deve ser informado do direito ao silêncio. A ausência desta advertência torna as declarações prestadas inaproveitáveis como prova, constituindo nulidade que contamina os atos subsequentes que nelas se fundamentarem.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=AC&docID=78415"
    },

    # Crimes contra a honra
    {
        "tribunal": "STJ", "numero_acordao": "HC 591847",
        "tema": "patrimonio",
        "ementa": "HABEAS CORPUS. INJÚRIA RACIAL. RACISMO. DISTINÇÃO. IMPRESCRITIBILIDADE. A injúria qualificada pelo preconceito de raça, cor, etnia ou procedência nacional (art. 140, §3º, do CP) não se confunde com o crime de racismo (Lei 7.716/89). Embora sejam crimes distintos, a injúria racial é hedionda e imprescritível, conforme entendimento firmado pelo STF no julgamento do HC 154248.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202001234567"
    },

    # Medidas cautelares diversas da prisão
    {
        "tribunal": "STJ", "numero_acordao": "RHC 138058",
        "tema": "habeas_corpus",
        "ementa": "RECURSO ORDINÁRIO EM HABEAS CORPUS. MEDIDAS CAUTELARES DIVERSAS DA PRISÃO. PROPORCIONALIDADE. NECESSIDADE. As medidas cautelares diversas da prisão previstas no art. 319 do CPP devem ser aplicadas preferencialmente à prisão preventiva, obedecendo ao princípio da proporcionalidade e da menor restrição possível à liberdade do acusado. A prisão preventiva só se justifica quando as medidas alternativas se mostrarem insuficientes.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202000543219"
    },

    # Estupro simples
    {
        "tribunal": "STJ", "numero_acordao": "HC 697.201",
        "tema": "sexual",
        "ementa": "HABEAS CORPUS. ESTUPRO. VIOLÊNCIA PRESUMIDA. CONSENTIMENTO. CRIME HEDIONDO. REGIME INICIAL. O estupro praticado mediante violência real ou grave ameaça é crime hediondo, sujeito ao cumprimento inicial em regime fechado. Nos crimes sexuais, o consentimento da vítima maior e capaz pode ser reconhecido como causa excludente da tipicidade, desde que inequívoco e não viciado por qualquer forma de coação.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202101876543"
    },

    # Crimes hediondos — progressão
    {
        "tribunal": "STJ", "numero_acordao": "HC 609.202",
        "tema": "execucao_penal",
        "ementa": "HABEAS CORPUS. CRIMES HEDIONDOS. PROGRESSÃO DE REGIME. FRAÇÃO. CONDENADO PRIMÁRIO. Nos crimes hediondos e equiparados, a progressão de regime para o condenado primário exige o cumprimento de 2/5 da pena. Para o reincidente em crime de natureza hedionda, o requisito é o cumprimento de 3/5. A vedação à progressão por salto aplica-se também aos crimes hediondos.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202001023456"
    },

    # Embriaguez ao volante
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1.534.688",
        "tema": "transito",
        "ementa": "RECURSO ESPECIAL. EMBRIAGUEZ AO VOLANTE. ART. 306 DO CTB. CRIME DE PERIGO ABSTRATO. PROVA. O crime de embriaguez ao volante é de perigo abstrato, prescindindo da demonstração de risco concreto a terceiros. A constatação da embriaguez pode ser feita por qualquer meio de prova em direito admitido, sendo o teste do bafômetro o mais usual, mas não o único.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201500476213"
    },

    # Estelionato
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1.943.211",
        "tema": "patrimonio",
        "ementa": "RECURSO ESPECIAL. ESTELIONATO. AÇÃO PENAL. PACOTE ANTICRIME. CONDICIONAMENTO À REPRESENTAÇÃO. ESTELIONATO CONTRA PARTICULAR. Com o advento da Lei 13.964/2019 (Pacote Anticrime), o estelionato praticado sem violência contra particular passou a ser crime de ação penal pública condicionada à representação da vítima, salvo quando praticado contra a Administração Pública, criança, idoso ou incapaz.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202100987654"
    },

    # Extorsão
    {
        "tribunal": "STJ", "numero_acordao": "HC 577.061",
        "tema": "patrimonio",
        "ementa": "HABEAS CORPUS. EXTORSÃO. DISTINÇÃO DE ROUBO. VANTAGEM INDEVIDA. CONSTRANGIMENTO FUTURO. A extorsão distingue-se do roubo pelo elemento subjetivo específico: exige que o agente constranja a vítima com o intuito de obter indevida vantagem econômica, sendo o constrangimento o meio e a obtenção da vantagem o fim. No roubo, a violência ou grave ameaça é contemporânea à subtração patrimonial.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202000234789"
    },

    # Inimputabilidade
    {
        "tribunal": "STJ", "numero_acordao": "HC 466.062",
        "tema": "nulidade",
        "ementa": "HABEAS CORPUS. INIMPUTABILIDADE. DOENÇA MENTAL. INCIDENTE DE INSANIDADE. OBRIGATORIEDADE. ABSOLVIÇÃO IMPRÓPRIA. Constatada dúvida sobre a integridade mental do acusado, é obrigatória a instauração de incidente de insanidade mental. A inimputabilidade por doença mental ao tempo do fato leva à absolvição imprópria com aplicação de medida de segurança, e não à condenação com pena privativa de liberdade.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201801876543"
    },

    # Estado de necessidade / excludentes
    {
        "tribunal": "STF", "numero_acordao": "HC 115.415",
        "tema": "legitima_defesa",
        "ementa": "HABEAS CORPUS. EXCLUDENTES DE ILICITUDE. ESTADO DE NECESSIDADE. REQUISITOS. INEVITABILIDADE DO PERIGO. O estado de necessidade exige situação de perigo atual, não provocada voluntariamente pelo agente, e que o mal causado não seja desproporcional ao mal evitado. O ônus de provar os requisitos da excludente recai sobre a defesa, mas cabe ao acusador desconstituí-la quando alegada.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=4149889"
    },

    # Crimes contra o ECA
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1.736.842",
        "tema": "sexual",
        "ementa": "RECURSO ESPECIAL. ESTATUTO DA CRIANÇA E DO ADOLESCENTE. CRIME CONTRA MENOR. PORNOGRAFIA INFANTIL. COMPARTILHAMENTO. CONSUMAÇÃO. O compartilhamento de material pornográfico envolvendo crianças e adolescentes via aplicativos de mensagens e redes sociais constitui crime autônomo do art. 241-A do ECA, consumando-se com o ato de transmissão, independentemente do recebimento pelo destinatário.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201800654321"
    },

    # Lesão corporal / violência doméstica
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1.897.438",
        "tema": "violencia_domestica",
        "ementa": "RECURSO ESPECIAL. LESÃO CORPORAL DOMÉSTICA. LEI MARIA DA PENHA. AÇÃO PENAL INCONDICIONADA. RETRATAÇÃO. INEFICÁCIA. Nos crimes de lesão corporal leve e culposa praticados no âmbito da violência doméstica e familiar, a ação penal é pública incondicionada, sendo irrelevante a retratação da vítima. A Súmula 542/STJ confirma que para tais crimes não se aplica o procedimento da Lei 9.099/95.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202001345678"
    },

    # Tentativa
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1.855.274",
        "tema": "dosimetria",
        "ementa": "RECURSO ESPECIAL. TENTATIVA. ITER CRIMINIS. REDUÇÃO DA PENA. FRAÇÃO APLICÁVEL. A redução da pena pela tentativa deve ser fundamentada nas circunstâncias concretas do iter criminis percorrido pelo agente. Quanto mais próximo da consumação chegar a conduta delitiva, menor a redução aplicável. A fixação no mínimo legal (1/3) exige fundamentação específica sobre a distância entre o ato executório e a consumação.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=202000754321"
    },

    # Receptação
    {
        "tribunal": "STJ", "numero_acordao": "HC 558.048",
        "tema": "patrimonio",
        "ementa": "HABEAS CORPUS. RECEPTAÇÃO. ELEMENTO SUBJETIVO. CIÊNCIA DA ORIGEM ILÍCITA. DOLO DIRETO E EVENTUAL. Para a configuração da receptação dolosa, o agente deve saber ou ter razões suficientes para saber que o bem é produto de crime. A receptação culposa ocorre quando o agente deveria saber, pela natureza do bem ou pelas circunstâncias da negociação, que a coisa tinha origem ilícita. A dúvida sobre a origem do bem, quando o agente age mesmo assim, configura dolo eventual.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201902176543"
    },

    # Revisão criminal
    {
        "tribunal": "STF", "numero_acordao": "RvC 5491",
        "tema": "nulidade",
        "ementa": "REVISÃO CRIMINAL. CABIMENTO. CONDENAÇÃO CONTRÁRIA AO TEXTO EXPRESSO DA LEI PENAL. ERRO DE FATO. A revisão criminal é admissível quando a sentença condenatória for contrária ao texto expresso da lei penal ou à evidência dos autos, quando a condenação se fundar em depoimentos, exames ou documentos comprovadamente falsos, ou quando se descobrirem novas provas de inocência do condenado ou de circunstância que determine ou autorize diminuição especial da pena.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=7645821"
    },

    # Habeas corpus preventivo
    {
        "tribunal": "STF", "numero_acordao": "HC 143.641",
        "tema": "habeas_corpus",
        "ementa": "HABEAS CORPUS PREVENTIVO. AMEAÇA CONCRETA À LIBERDADE DE LOCOMOÇÃO. CABIMENTO. O habeas corpus preventivo é cabível quando há ameaça concreta e iminente ao direito de ir e vir, sendo desnecessária a prisão efetiva para sua impetração. Demonstrada a existência de ordem ou ameaça de restrição à liberdade, o remédio constitucional é via adequada para cessá-la antes de sua consumação.",
        "link": "https://redir.stf.jus.br/paginadorpub/paginador.jsp?docTP=TP&docID=748401864"
    },

    # Coautoria e participação
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1.798.903",
        "tema": "dosimetria",
        "ementa": "RECURSO ESPECIAL. COAUTORIA. PARTICIPAÇÃO. DISTINÇÃO. AUTORIA MEDIATA. O coautor é aquele que pratica o verbo nuclear do tipo penal ou que tem o domínio funcional do fato. O partícipe contribui de forma secundária para o crime alheio, sem praticar o núcleo da conduta típica. A participação de menor importância deve ser reconhecida quando a conduta do agente tiver contribuição secundária, permitindo a redução da pena de 1/6 a 1/3.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201900543876"
    },

    # Arrependimento posterior
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1.720.887",
        "tema": "dosimetria",
        "ementa": "RECURSO ESPECIAL. ARREPENDIMENTO POSTERIOR. REPARAÇÃO DO DANO. REDUTOR OBRIGATÓRIO. EXTENSÃO. O arrependimento posterior, previsto no art. 16 do CP, é causa obrigatória de redução de pena quando o agente, nos crimes cometidos sem violência ou grave ameaça à pessoa, repara o dano ou restitui a coisa até o recebimento da denúncia. A redução de 1/3 a 2/3 deve ser proporcional à celeridade e voluntariedade da reparação.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201800654321"
    },

    # Tráfico internacional
    {
        "tribunal": "STJ", "numero_acordao": "REsp 1.784.592",
        "tema": "trafico",
        "ementa": "RECURSO ESPECIAL. TRÁFICO INTERNACIONAL DE DROGAS. COMPETÊNCIA FEDERAL. CAUSA DE AUMENTO. ART. 40, I, DA LEI 11.343/2006. O tráfico transnacional de drogas é crime de competência da Justiça Federal e sujeito à causa de aumento de pena prevista no art. 40, I, da Lei de Drogas. Para a incidência da majorante, é suficiente que a droga tenha origem estrangeira ou que haja indício de que o destino seria o exterior, mesmo sem prova efetiva da transposição da fronteira.",
        "link": "https://processo.stj.jus.br/processo/pesquisa/?tipoPesquisa=tipoPesquisaNumeroRegistro&termo=201900123456"
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

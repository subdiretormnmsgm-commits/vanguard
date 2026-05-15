/**
 * VANGUARD TECH — Script de criação do Formulário de Discovery
 *
 * INSTRUÇÕES:
 * 1. Acesse https://script.google.com e crie um novo projeto.
 * 2. Cole todo este código no editor (substitua o conteúdo existente).
 * 3. Clique em "Executar" (▶) na função criarFormularioDiscovery.
 * 4. Autorize as permissões solicitadas pelo Google.
 * 5. Após a execução, o link do formulário aparece no Log (Ver > Registros).
 */

function criarFormularioDiscovery() {

  /* ── Criação do formulário ── */
  const form = FormApp.create('Diagnóstico de Projeto — Vanguard Tech');

  form.setTitle('Diagnóstico de Projeto — Vanguard Tech');
  form.setDescription(
    'Olá! Preciso muito da sua visão para darmos o primeiro passo.\n\n' +
    'Nós temos uma forma um pouco diferente de construir tecnologia. Antes de escrevermos ' +
    'qualquer linha de código, gostamos de entender profundamente o seu cenário para garantir ' +
    'que a ferramenta vai realmente facilitar a sua vida e trazer retorno.\n\n' +
    'Como este será o nosso projeto piloto (e o desenvolvimento fica por nossa conta!), as suas ' +
    'respostas serão a nossa principal bússola. Fique totalmente à vontade para responder no seu ' +
    'tempo, seja por áudio ou texto, como for mais confortável para você.'
  );

  form.setCollectEmail(false);
  form.setShowLinkToRespondAgain(false);
  form.setConfirmationMessage(
    'Muito obrigado pela transparência e pela confiança!\n\n' +
    'Com essas respostas em mãos, minha equipe vai analisar o seu cenário com todo o cuidado e ' +
    'desenhar o melhor caminho para o seu projeto. Vou te mantendo a par de cada etapa, de forma ' +
    'bem tranquila e transparente, desde o diagnóstico até colocarmos tudo no ar.\n\n' +
    'Qualquer dúvida que surgir no meio do caminho, é só me chamar. Vamos construir algo incrível juntos! 🚀'
  );

  /* ── Pergunta 1 ── */
  form.addSectionHeaderItem()
    .setTitle('Pergunta 1 de 6')
    .setHelpText(
      'Não se preocupe em usar nenhum termo técnico. Pode explicar exatamente como você contaria ' +
      'para um amigo. Por exemplo: "quero um portal para agilizar meus atendimentos", ou ' +
      '"preciso automatizar uma rotina que hoje faço na mão".'
    );

  form.addParagraphTextItem()
    .setTitle('Qual é a ideia principal que você quer tirar do papel?')
    .setHelpText('O que você tem em mente para construirmos?')
    .setRequired(true);

  /* ── Pergunta 2 ── */
  form.addSectionHeaderItem()
    .setTitle('Pergunta 2 de 6')
    .setHelpText(
      'A ideia aqui é mapearmos juntos o tamanho do alívio que a solução vai te trazer.'
    );

  form.addParagraphTextItem()
    .setTitle('Qual é a dor ou o gargalo que estamos resolvendo hoje?')
    .setHelpText(
      'O que mais consome o seu tempo ou o seu caixa por essa ferramenta ainda não existir? ' +
      'Se puder estimar (mesmo que por alto) quantas horas você perde na semana com isso, ' +
      'ou se há negócios que acabam passando, me ajuda muito a entender o valor real do que vamos criar.'
    )
    .setRequired(true);

  /* ── Pergunta 3 ── */
  form.addSectionHeaderItem()
    .setTitle('Pergunta 3 de 6')
    .setHelpText(
      'Pode ser algo como um pagamento aprovado, um documento gerado em segundos, ou um contato ' +
      'chegando limpo no seu WhatsApp.'
    );

  form.addParagraphTextItem()
    .setTitle('Como saberemos que deu certo? Qual é o nosso "momento de sucesso"?')
    .setHelpText(
      'Se o seu cliente (ou você) entrar no sistema, qual é aquela ação específica que faz você ' +
      'pensar: "Perfeito, a ferramenta cumpriu o seu papel"?'
    )
    .setRequired(true);

  /* ── Pergunta 4 ── */
  form.addSectionHeaderItem()
    .setTitle('Pergunta 4 de 6')
    .setHelpText(
      'Pode sonhar alto! Não se preocupe se parece viável ou não tecnicamente agora. ' +
      'Muitas vezes é dessa visão ideal que tiramos as nossas melhores soluções.'
    );

  form.addParagraphTextItem()
    .setTitle('Se você tivesse uma varinha mágica, que função colocaria no sistema para deixar a concorrência para trás?')
    .setHelpText(
      'Se você pudesse colocar uma função perfeita no sistema — algo que deixasse a sua concorrência ' +
      'muito para trás —, o que seria?'
    )
    .setRequired(true);

  /* ── Pergunta 5 ── */
  form.addSectionHeaderItem()
    .setTitle('Pergunta 5 de 6')
    .setHelpText(
      'Conte-nos sobre o que você já tem rodando hoje e sobre o volume atual do seu negócio.'
    );

  form.addParagraphTextItem()
    .setTitle('Como é o seu cenário hoje?')
    .setHelpText(
      'Você já tem algo rodando? Pode ser um site antigo, planilhas de controle, rascunhos, ' +
      'ou alguma outra plataforma que você já use.'
    )
    .setRequired(true);

  form.addShortAnswerItem()
    .setTitle('Qual costuma ser o valor médio do seu serviço/produto hoje?')
    .setHelpText('Ex.: R$ 500, R$ 2.000… pode ser um valor aproximado.')
    .setRequired(false);

  form.addShortAnswerItem()
    .setTitle('Quantos atendimentos (ou vendas) você tem, em média, por mês?')
    .setHelpText('Ex.: 10 clientes/mês, 50 pedidos/mês… um número aproximado já ajuda.')
    .setRequired(false);

  /* ── Pergunta 6 ── */
  form.addSectionHeaderItem()
    .setTitle('Pergunta 6 de 6')
    .setHelpText(
      'Última etapa! Duas perguntas rápidas para alinharmos prazo e modelo de parceria.'
    );

  form.addShortAnswerItem()
    .setTitle('Temos alguma data especial no horizonte para termos isso rodando?')
    .setHelpText(
      'Um evento, um lançamento, ou alguma urgência do seu calendário? ' +
      'Se não houver data definida, pode escrever "sem prazo específico".'
    )
    .setRequired(false);

  form.addMultipleChoiceItem()
    .setTitle('Se você fosse contratar essa solução no mercado, qual orçamento se sentiria seguro em investir?')
    .setHelpText(
      'Esta pergunta nos ajuda a calibrar o nosso modelo de negócio e garantir que a parceria ' +
      'faça sentido para ambos os lados.'
    )
    .setChoiceValues([
      'Até R$ 1.000',
      'Entre R$ 1.000 e R$ 3.000',
      'Entre R$ 3.000 e R$ 7.000',
      'Entre R$ 7.000 e R$ 15.000',
      'Acima de R$ 15.000',
      'Ainda não tenho clareza sobre isso'
    ])
    .setRequired(true);

  /* ── Log com o link ── */
  const url = form.getPublishedUrl();
  const editUrl = form.getEditUrl();

  Logger.log('✅ Formulário criado com sucesso!');
  Logger.log('🔗 Link para responder: ' + url);
  Logger.log('✏️  Link de edição (só para você): ' + editUrl);

  return url;
}

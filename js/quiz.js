const Quiz = (() => {
  // Substitua pelo número WhatsApp da Vanguard (ex: 351912345678)
  const WA_NUMBER = '5521996008570';

  const state = { step: 1, nicho: '', gargalo: '', nome: '', whatsapp: '' };

  function showStep(id) {
    document.querySelectorAll('.quiz__step')
      .forEach(el => el.classList.add('quiz__step--hidden'));
    document.getElementById(id).classList.remove('quiz__step--hidden');
  }

  function setProgress(step) {
    const pct = step === 'done' ? 100 : Math.round((step / 3) * 100);
    document.getElementById('quiz-progress-bar').style.width = pct + '%';
    document.getElementById('quiz-step-label').textContent =
      step === 'done' ? 'Concluído!' : `Passo ${step} de 3`;
  }

  function goTo(step) {
    state.step = step;
    setProgress(step);
    showStep(`step-${step}`);
  }

  function init() {
    setProgress(1);

    // Passo 1 → 2
    document.getElementById('btn-next-1').addEventListener('click', () => {
      const val = document.getElementById('quiz-nicho').value;
      if (!val) return;
      state.nicho = val;
      goTo(2);
    });

    // Passo 2 → 3
    document.getElementById('btn-next-2').addEventListener('click', () => {
      const checked = document.querySelector('input[name="gargalo"]:checked');
      if (!checked) return;
      state.gargalo = checked.value;
      goTo(3);
    });

    // Passo 3: activar botão submit quando ambos preenchidos
    const nomeEl = document.getElementById('quiz-nome');
    const waEl   = document.getElementById('quiz-whatsapp');
    const btn    = document.getElementById('btn-submit');

    const WA_REGEX = /^\+?[1-9]\d{7,14}$/;

    function checkStep3() {
      btn.disabled = !(nomeEl.value.trim() && WA_REGEX.test(waEl.value.trim()));
    }
    nomeEl.addEventListener('input', checkStep3);
    waEl.addEventListener('input', checkStep3);
    nomeEl.addEventListener('change', checkStep3);
    waEl.addEventListener('change', checkStep3);

    // Submit
    btn.addEventListener('click', async () => {
      state.nome     = nomeEl.value.trim();
      state.whatsapp = waEl.value.trim();
      btn.disabled   = true;

      // Mostra estado de processamento IA
      setProgress('done');
      showStep('step-processing');

      const result = await supabaseClient.saveLeadDiagnostico({
        nicho:    state.nicho,
        gargalo:  state.gargalo,
        nome:     state.nome,
        whatsapp: state.whatsapp,
      });

      if (result.success) {
        const msg = encodeURIComponent(
          `Olá! Acabei de fazer o diagnóstico Vanguard.\nNicho: ${state.nicho}\nGargalo: ${state.gargalo}`
        );
        document.getElementById('btn-whatsapp-contact').href =
          `https://web.whatsapp.com/send/?phone=${WA_NUMBER}&text=${msg}`;
        // Mantém o ecrã de processamento por 2s (efeito "IA a analisar")
        setTimeout(() => showStep('step-success'), 2000);
      } else {
        showStep('step-3');
        setProgress(3);
        btn.disabled = false;
        const errEl = document.getElementById('quiz-error');
        if (errEl) { errEl.textContent = 'Erro ao enviar. Por favor tente novamente.'; errEl.hidden = false; }
      }
    });
  }

  return { init };
})();

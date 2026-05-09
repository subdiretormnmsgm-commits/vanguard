const Quiz = (() => {
  // Substitua pelo número WhatsApp da Vanguard (ex: 351912345678)
  const WA_NUMBER = 'YOUR_WHATSAPP_NUMBER';

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

    function checkStep3() {
      btn.disabled = !(nomeEl.value.trim() && waEl.value.trim());
    }
    nomeEl.addEventListener('input', checkStep3);
    waEl.addEventListener('input', checkStep3);

    // Submit
    btn.addEventListener('click', async () => {
      state.nome      = nomeEl.value.trim();
      state.whatsapp  = waEl.value.trim();
      btn.disabled    = true;
      btn.textContent = 'A enviar...';

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
          `https://wa.me/${WA_NUMBER}?text=${msg}`;
        setProgress('done');
        showStep('step-success');
      } else {
        btn.disabled    = false;
        btn.textContent = 'Enviar Diagnóstico →';
        alert('Erro ao enviar. Por favor tente novamente.');
      }
    });
  }

  return { init };
})();

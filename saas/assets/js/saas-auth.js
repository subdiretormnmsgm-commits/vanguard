/* ══════════════════════════════════════════════════════════════════
   saas-auth.js — Supabase Auth + tenant registration
   Shared by index.html (login) and dashboard.html (session guard)
═══════════════════════════════════════════════════════════════════ */

// ── Config ────────────────────────────────────────────────────────
const SUPABASE_URL = window.VANGUARD_CONFIG?.SUPABASE_URL || '';
const SUPABASE_ANON = window.VANGUARD_CONFIG?.SUPABASE_ANON_KEY || '';
const API_BASE = window.VANGUARD_CONFIG?.API_BASE || '/api';
const DASH_PATH = '/saas/dashboard.html';
const LOGIN_PATH = '/saas/';

// Supabase client (shared instance)
const _sb = supabase.createClient(SUPABASE_URL, SUPABASE_ANON);
window.sb = _sb;

// ── Session Guard (dashboard.html) ────────────────────────────────
if (document.getElementById('shell')) {
  _sb.auth.getSession().then(({ data: { session } }) => {
    if (!session) {
      window.location.replace(LOGIN_PATH);
    } else {
      window._session = session;
      window._token  = session.access_token;
      // dashboard.js will call loadDashboard()
    }
  });

  // Keep token fresh
  _sb.auth.onAuthStateChange((event, session) => {
    if (event === 'SIGNED_OUT' || !session) {
      window.location.replace(LOGIN_PATH);
    } else {
      window._session = session;
      window._token   = session.access_token;
    }
  });
}

// ── Login page logic (index.html) ────────────────────────────────
let _mode = 'login'; // 'login' | 'register'

function switchTab(tab) {
  _mode = tab;
  document.getElementById('tabLogin').classList.toggle('active', tab === 'login');
  document.getElementById('tabRegister').classList.toggle('active', tab === 'register');
  document.getElementById('fieldNome').style.display = tab === 'register' ? 'flex' : 'none';
  document.getElementById('btnLabel').textContent = tab === 'login' ? 'Entrar' : 'Criar Conta';
  clearMessages();
}

async function handleSubmit(e) {
  e.preventDefault();
  clearMessages();

  const email    = document.getElementById('inputEmail').value.trim();
  const password = document.getElementById('inputPassword').value;
  const nome     = document.getElementById('inputNome')?.value.trim() || '';
  const btn      = document.getElementById('btnSubmit');

  btn.disabled = true;
  btn.classList.add('loading');

  try {
    if (_mode === 'login') {
      await signIn(email, password);
    } else {
      await signUp(email, password, nome);
    }
  } finally {
    btn.disabled = false;
    btn.classList.remove('loading');
  }
}

async function signIn(email, password) {
  const { data, error } = await _sb.auth.signInWithPassword({ email, password });
  if (error) return showError(translateError(error.message));
  window._session = data.session;
  window._token   = data.session.access_token;
  window.location.replace(DASH_PATH);
}

async function signUp(email, password, nome) {
  if (!nome) return showError('Informe o nome da agência.');

  const { data, error } = await _sb.auth.signUp({ email, password });
  if (error) return showError(translateError(error.message));

  // Register tenant via API
  const token = data.session?.access_token;
  if (token) {
    try {
      const r = await fetch(`${API_BASE}/tenant/registar`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
        body: JSON.stringify({ nome, email }),
      });
      if (!r.ok) console.warn('Tenant auto-registration skipped:', await r.text());
    } catch (err) {
      console.warn('API offline, tenant will be created on first login:', err);
    }
    window.location.replace(DASH_PATH);
  } else {
    // Email confirmation required
    showSuccess('Conta criada! Verifique o seu e-mail para confirmar o registo.');
  }
}

// ── Logout (dashboard.html) ────────────────────────────────────────
async function logout() {
  await _sb.auth.signOut();
  window.location.replace(LOGIN_PATH);
}

// ── UI helpers ────────────────────────────────────────────────────
function showError(msg) {
  const el = document.getElementById('authError');
  if (!el) return;
  el.textContent = msg;
  el.classList.add('show');
}

function showSuccess(msg) {
  const el = document.getElementById('authSuccess');
  if (!el) return;
  el.textContent = msg;
  el.classList.add('show');
}

function clearMessages() {
  document.getElementById('authError')?.classList.remove('show');
  document.getElementById('authSuccess')?.classList.remove('show');
}

function translateError(msg) {
  const map = {
    'Invalid login credentials': 'E-mail ou palavra-passe incorretos.',
    'Email not confirmed':        'Confirme o seu e-mail antes de entrar.',
    'User already registered':    'Este e-mail já possui uma conta.',
    'Password should be at least 6 characters': 'A senha deve ter pelo menos 6 caracteres.',
  };
  return map[msg] || msg;
}

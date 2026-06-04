# n8n_config.example.ps1 -- template de configuracao do n8n
# NUNCA commitar o arquivo n8n_config.ps1 real (esta no .gitignore)
# Copiar este arquivo para n8n_config.ps1 e preencher com valores reais

# URL do webhook de session_close (Workflow 4)
# Pegar no n8n: abrir Workflow 4 > clicar no node Webhook > copiar URL
$N8N_SESSION_CLOSE_URL = ""

# URL do n8n (sem barra no final)
$N8N_BASE_URL = "https://n8n-vanguard.seuservidor.easypanel.host"

# Credenciais basicas do n8n (basic auth)
$N8N_USER     = "vanguard"
$N8N_PASSWORD = ""

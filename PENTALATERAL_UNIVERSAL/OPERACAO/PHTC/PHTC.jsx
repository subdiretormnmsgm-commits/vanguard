import { useState, useEffect } from "react";

const phases = [
  {
    id: "f1",
    tag: "FASE 1",
    sub: "INTERNO · PRÉ-ENVIO AO CLIENTE",
    title: "Teste de Estabilidade Interna",
    color: "#C9A84C",
    items: [
      { id: "f1_1", text: "Deploy realizado no ambiente de produção final — não em localhost nem branch de desenvolvimento" },
      { id: "f1_2", text: "5 queries de alta cobertura executadas — registrar query, resultado, latência e similarity score" },
      { id: "f1_3", text: "2 queries de borda executadas — registrar resultado e comportamento de fallback" },
      { id: "f1_4", text: "Autenticação testada: login correto + tentativa de acesso negado" },
      { id: "f1_5", text: "Output/citação verificada em pelo menos 3 resultados distintos — formato, completude e acurácia" },
      { id: "f1_6", text: "Testado no dispositivo equivalente ao do cliente (smartphone/tablet) — não apenas no computador da equipe" },
      { id: "f1_7", text: "Testado em rede externa ao ambiente de dev (4G/5G ou hotspot)" },
      { id: "f1_8", text: "Todos os gates registrados com evidência datada (print, log ou screenshot)" },
    ],
    gate: "Todos os 8 itens marcados com evidência. Se qualquer item falhar: corrigir e reiniciar o checklist. Nenhum contato sobre assinatura antes deste gate.",
  },
  {
    id: "f2",
    tag: "FASE 2",
    sub: "COM O CLIENTE · PERÍODO DE TESES",
    title: "Validação no Ecossistema Real",
    color: "#7EC8A0",
    items: [
      { id: "f2_1", text: "Link enviado ao cliente 24–48h antes do presencial com script de orientação" },
      { id: "f2_2", text: "Passo 1 — Acesso e estabilidade: cliente acessou no próprio dispositivo sem travar" },
      { id: "f2_3", text: "Passo 2 — Tarefa central: cliente realizou o fluxo principal com um caso real e atual" },
      { id: "f2_4", text: "Passo 3 — Output validado: resultado atendeu a necessidade com velocidade prometida" },
      { id: "f2_5", text: "Passo 4 — Exceção testada: sistema se recuperou de forma amigável de erro ou busca ambígua" },
      { id: "f2_6", text: "Cenário de sucesso definido no levantamento de necessidades: materializado e validado verbalmente pelo cliente" },
      { id: "f2_7", text: "Confirmação do cliente registrada (print de WhatsApp, e-mail ou nota no LOG_CLIENTE)" },
    ],
    gate: "Os 3 critérios atendidos: sistema estável no dispositivo do cliente · output eliminou esforço do modelo tradicional · Cena de Sucesso validada verbalmente.",
  },
  {
    id: "f3",
    tag: "FASE 3",
    sub: "TRANSIÇÃO PARA ENTREGA · SOMENTE APÓS FASE 1 E 2",
    title: "Transição para Assinatura e Entrega",
    color: "#A78BFA",
    items: [
      { id: "f3_1", text: "Termo de PoC assinado pelas duas partes antes do acesso do cliente" },
      { id: "f3_2", text: "Demonstração ao vivo: cliente digita — não Eduardo. Confirmação verbal: 'Está funcionando como testamos?'" },
      { id: "f3_3", text: "Contrato apresentado: 'Isso formaliza exatamente o que você acabou de usar'" },
      { id: "f3_4", text: "Contrato assinado" },
      { id: "f3_5", text: "Manual de operação da ferramenta e credenciais de acesso (usuário e senha) entregues ao cliente" },
      { id: "f3_6", text: "Pagamento confirmado" },
      { id: "f3_7", text: "Relatório de Testes da Fase 1 arquivado junto ao contrato assinado" },
    ],
    gate: "Somente com Gates das Fases 1 e 2 fechados o Diretor avança para apresentação do contrato.",
  },
];

const PROJECT_KEY = "phtc_checklist_v1";

function loadState() {
  try {
    const raw = localStorage.getItem(PROJECT_KEY);
    return raw ? JSON.parse(raw) : {};
  } catch { return {}; }
}

function saveState(state) {
  try { localStorage.setItem(PROJECT_KEY, JSON.stringify(state)); } catch {}
}

export default function PHTC() {
  const [checked, setChecked] = useState({});
  const [projectName, setProjectName] = useState("");
  const [editingProject, setEditingProject] = useState(false);
  const [tmpName, setTmpName] = useState("");
  const [expanded, setExpanded] = useState({ f1: true, f2: true, f3: true });

  useEffect(() => {
    const s = loadState();
    setChecked(s.checked || {});
    setProjectName(s.projectName || "");
  }, []);

  const persist = (newChecked, newName) => {
    saveState({ checked: newChecked, projectName: newName ?? projectName });
  };

  const toggle = (id) => {
    const next = { ...checked, [id]: !checked[id] };
    setChecked(next);
    persist(next);
  };

  const resetAll = () => {
    setChecked({});
    persist({}, projectName);
  };

  const totalItems = phases.reduce((a, p) => a + p.items.length, 0);
  const totalChecked = Object.values(checked).filter(Boolean).length;
  const progress = Math.round((totalChecked / totalItems) * 100);

  const phaseProgress = (phase) => {
    const done = phase.items.filter(i => checked[i.id]).length;
    return { done, total: phase.items.length, pct: Math.round((done / phase.items.length) * 100) };
  };

  const phaseComplete = (phase) => phaseProgress(phase).done === phase.items.length;

  const togglePhase = (id) => setExpanded(e => ({ ...e, [id]: !e[id] }));

  return (
    <div style={{
      minHeight: "100vh",
      background: "#0D1B2A",
      fontFamily: "'Georgia', serif",
      color: "#F5F0E8",
      padding: "0 0 80px",
    }}>

      {/* HEADER */}
      <div style={{
        background: "linear-gradient(180deg, #0D1B2A 0%, #1A2E45 100%)",
        borderBottom: "1px solid rgba(201,168,76,0.3)",
        padding: "36px 32px 28px",
        position: "sticky",
        top: 0,
        zIndex: 50,
      }}>
        <div style={{ maxWidth: 680, margin: "0 auto" }}>
          <div style={{
            fontFamily: "monospace",
            fontSize: 10,
            letterSpacing: 3,
            color: "#C9A84C",
            marginBottom: 8,
          }}>VANGUARD TECH · P-046</div>

          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", flexWrap: "wrap", gap: 12 }}>
            <div>
              <h1 style={{ fontSize: 22, fontWeight: 700, color: "#fff", margin: 0, lineHeight: 1.3 }}>
                PHTC — Protocolo de Homologação
              </h1>
              <div style={{ fontSize: 14, color: "rgba(255,255,255,0.45)", marginTop: 4, fontStyle: "italic" }}>
                Fase Pré-Contrato · Documento Mandatório
              </div>
            </div>

            {/* PROJECT NAME */}
            <div>
              {editingProject ? (
                <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
                  <input
                    value={tmpName}
                    onChange={e => setTmpName(e.target.value)}
                    onKeyDown={e => {
                      if (e.key === "Enter") {
                        setProjectName(tmpName);
                        persist(checked, tmpName);
                        setEditingProject(false);
                      }
                      if (e.key === "Escape") setEditingProject(false);
                    }}
                    autoFocus
                    placeholder="Nome do projeto..."
                    style={{
                      background: "rgba(255,255,255,0.08)",
                      border: "1px solid #C9A84C",
                      borderRadius: 4,
                      padding: "6px 12px",
                      color: "#fff",
                      fontSize: 13,
                      fontFamily: "monospace",
                      outline: "none",
                      width: 180,
                    }}
                  />
                  <button
                    onClick={() => { setProjectName(tmpName); persist(checked, tmpName); setEditingProject(false); }}
                    style={{ background: "#C9A84C", border: "none", borderRadius: 4, padding: "6px 12px", color: "#0D1B2A", fontWeight: 700, cursor: "pointer", fontSize: 12 }}
                  >OK</button>
                </div>
              ) : (
                <button
                  onClick={() => { setTmpName(projectName); setEditingProject(true); }}
                  style={{
                    background: "rgba(201,168,76,0.12)",
                    border: "1px solid rgba(201,168,76,0.4)",
                    borderRadius: 4,
                    padding: "6px 14px",
                    color: "#C9A84C",
                    fontSize: 12,
                    fontFamily: "monospace",
                    cursor: "pointer",
                    letterSpacing: 1,
                  }}
                >
                  {projectName ? `📁 ${projectName}` : "+ PROJETO"}
                </button>
              )}
            </div>
          </div>

          {/* PROGRESS BAR */}
          <div style={{ marginTop: 20 }}>
            <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 6 }}>
              <span style={{ fontFamily: "monospace", fontSize: 11, color: "rgba(255,255,255,0.5)", letterSpacing: 1 }}>
                {totalChecked} DE {totalItems} ITENS CONCLUÍDOS
              </span>
              <span style={{ fontFamily: "monospace", fontSize: 11, color: progress === 100 ? "#7EC8A0" : "#C9A84C", fontWeight: 700 }}>
                {progress}%
              </span>
            </div>
            <div style={{ height: 4, background: "rgba(255,255,255,0.08)", borderRadius: 2, overflow: "hidden" }}>
              <div style={{
                height: "100%",
                width: `${progress}%`,
                background: progress === 100
                  ? "linear-gradient(90deg, #7EC8A0, #4ade80)"
                  : "linear-gradient(90deg, #C9A84C, #E2C47A)",
                borderRadius: 2,
                transition: "width 0.4s ease",
              }} />
            </div>
          </div>
        </div>
      </div>

      {/* PHASES */}
      <div style={{ maxWidth: 680, margin: "0 auto", padding: "32px 32px 0" }}>

        {phases.map((phase, pi) => {
          const pp = phaseProgress(phase);
          const complete = phaseComplete(phase);
          const open = expanded[phase.id];
          const prevComplete = pi === 0 ? true : phaseComplete(phases[pi - 1]);

          return (
            <div key={phase.id} style={{ marginBottom: 24 }}>

              {/* PHASE HEADER */}
              <button
                onClick={() => togglePhase(phase.id)}
                style={{
                  width: "100%",
                  background: complete
                    ? "rgba(126,200,160,0.1)"
                    : "rgba(255,255,255,0.04)",
                  border: `1px solid ${complete ? "rgba(126,200,160,0.4)" : "rgba(255,255,255,0.1)"}`,
                  borderLeft: `3px solid ${complete ? "#7EC8A0" : phase.color}`,
                  borderRadius: 6,
                  padding: "16px 20px",
                  cursor: "pointer",
                  display: "flex",
                  alignItems: "center",
                  gap: 16,
                  textAlign: "left",
                  transition: "all 0.2s",
                }}
              >
                <div style={{
                  width: 36,
                  height: 36,
                  borderRadius: "50%",
                  background: complete ? "#7EC8A0" : `rgba(${phase.color === "#C9A84C" ? "201,168,76" : phase.color === "#7EC8A0" ? "126,200,160" : "167,139,250"},0.15)`,
                  border: `2px solid ${complete ? "#7EC8A0" : phase.color}`,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  flexShrink: 0,
                  fontSize: 14,
                  color: complete ? "#0D1B2A" : phase.color,
                  fontWeight: 700,
                  fontFamily: "monospace",
                }}>
                  {complete ? "✓" : `${pi + 1}`}
                </div>

                <div style={{ flex: 1 }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 2 }}>
                    <span style={{ fontFamily: "monospace", fontSize: 10, letterSpacing: 2, color: phase.color }}>{phase.tag}</span>
                    <span style={{ fontFamily: "monospace", fontSize: 10, color: "rgba(255,255,255,0.3)", letterSpacing: 1 }}>{phase.sub}</span>
                  </div>
                  <div style={{ fontSize: 15, fontWeight: 600, color: complete ? "#7EC8A0" : "#fff" }}>{phase.title}</div>
                </div>

                <div style={{ display: "flex", alignItems: "center", gap: 12, flexShrink: 0 }}>
                  <span style={{ fontFamily: "monospace", fontSize: 12, color: complete ? "#7EC8A0" : "rgba(255,255,255,0.4)" }}>
                    {pp.done}/{pp.total}
                  </span>
                  <span style={{ color: "rgba(255,255,255,0.3)", fontSize: 12 }}>{open ? "▲" : "▼"}</span>
                </div>
              </button>

              {/* PHASE ITEMS */}
              {open && (
                <div style={{
                  background: "rgba(255,255,255,0.02)",
                  border: "1px solid rgba(255,255,255,0.07)",
                  borderTop: "none",
                  borderRadius: "0 0 6px 6px",
                  padding: "4px 0 16px",
                }}>
                  {phase.items.map((item, idx) => (
                    <div
                      key={item.id}
                      onClick={() => toggle(item.id)}
                      style={{
                        display: "flex",
                        alignItems: "flex-start",
                        gap: 14,
                        padding: "12px 20px",
                        cursor: "pointer",
                        borderBottom: idx < phase.items.length - 1 ? "1px solid rgba(255,255,255,0.05)" : "none",
                        transition: "background 0.15s",
                        background: checked[item.id] ? "rgba(126,200,160,0.05)" : "transparent",
                      }}
                    >
                      <div style={{
                        width: 20,
                        height: 20,
                        borderRadius: 4,
                        border: `1.5px solid ${checked[item.id] ? "#7EC8A0" : "rgba(255,255,255,0.2)"}`,
                        background: checked[item.id] ? "#7EC8A0" : "transparent",
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                        flexShrink: 0,
                        marginTop: 2,
                        transition: "all 0.2s",
                        fontSize: 12,
                        color: "#0D1B2A",
                        fontWeight: 900,
                      }}>
                        {checked[item.id] && "✓"}
                      </div>

                      <span style={{
                        fontFamily: "monospace",
                        fontSize: 10,
                        color: checked[item.id] ? "#7EC8A0" : "rgba(255,255,255,0.25)",
                        marginTop: 4,
                        minWidth: 18,
                        letterSpacing: 1,
                      }}>
                        {String(idx + 1).padStart(2, "0")}
                      </span>

                      <span style={{
                        fontSize: 14,
                        lineHeight: 1.6,
                        color: checked[item.id] ? "rgba(255,255,255,0.4)" : "rgba(255,255,255,0.85)",
                        textDecoration: checked[item.id] ? "line-through" : "none",
                        transition: "all 0.2s",
                      }}>
                        {item.text}
                      </span>
                    </div>
                  ))}

                  {/* GATE */}
                  <div style={{
                    margin: "12px 20px 0",
                    background: complete
                      ? "rgba(126,200,160,0.12)"
                      : "rgba(255,255,255,0.04)",
                    border: `1px solid ${complete ? "rgba(126,200,160,0.35)" : "rgba(255,255,255,0.08)"}`,
                    borderRadius: 4,
                    padding: "12px 16px",
                  }}>
                    <div style={{
                      fontFamily: "monospace",
                      fontSize: 9,
                      letterSpacing: 2,
                      color: complete ? "#7EC8A0" : "#C9A84C",
                      marginBottom: 6,
                    }}>
                      {complete ? "✓ GATE APROVADO" : "◦ GATE DE SAÍDA"}
                    </div>
                    <div style={{
                      fontSize: 13,
                      color: complete ? "rgba(126,200,160,0.8)" : "rgba(255,255,255,0.5)",
                      lineHeight: 1.6,
                      fontStyle: "italic",
                    }}>
                      {phase.gate}
                    </div>
                  </div>
                </div>
              )}
            </div>
          );
        })}

        {/* COMPLETION BANNER */}
        {progress === 100 && (
          <div style={{
            background: "linear-gradient(135deg, rgba(126,200,160,0.15), rgba(201,168,76,0.1))",
            border: "1px solid rgba(126,200,160,0.4)",
            borderRadius: 8,
            padding: "24px 28px",
            textAlign: "center",
            marginTop: 8,
          }}>
            <div style={{ fontSize: 32, marginBottom: 12 }}>✓</div>
            <div style={{ fontSize: 18, fontWeight: 700, color: "#7EC8A0", marginBottom: 6 }}>
              Protocolo Concluído
            </div>
            <div style={{ fontSize: 14, color: "rgba(255,255,255,0.55)", fontStyle: "italic" }}>
              Todos os gates aprovados. O Diretor está autorizado a apresentar o contrato.
            </div>
          </div>
        )}

        {/* FOOTER */}
        <div style={{
          marginTop: 32,
          borderTop: "1px solid rgba(201,168,76,0.2)",
          paddingTop: 20,
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          flexWrap: "wrap",
          gap: 12,
        }}>
          <div style={{ fontFamily: "monospace", fontSize: 11, color: "rgba(255,255,255,0.3)", letterSpacing: 1 }}>
            TESTAR → VALIDAR → ASSINAR → ENTREGAR
          </div>
          <button
            onClick={resetAll}
            style={{
              background: "transparent",
              border: "1px solid rgba(255,255,255,0.15)",
              borderRadius: 4,
              padding: "6px 14px",
              color: "rgba(255,255,255,0.3)",
              fontSize: 11,
              fontFamily: "monospace",
              cursor: "pointer",
              letterSpacing: 1,
            }}
          >
            RESETAR
          </button>
        </div>
      </div>
    </div>
  );
}

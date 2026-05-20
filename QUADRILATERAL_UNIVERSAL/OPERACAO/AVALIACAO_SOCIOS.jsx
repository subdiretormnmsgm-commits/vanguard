import { useState } from "react";

const C = {
  navy: "#0D1B2A", navyMid: "#1A2E45", navyLight: "#243B55",
  gold: "#C9A84C", goldLight: "#E2C47A", goldPale: "#F5EDD6",
  cream: "#FAF7F2", text: "#1A1A1A", muted: "#5A5A5A",
  green: "#1A4A2E", greenLight: "#2D6B47",
  purple: "#4A1A6E", purpleLight: "#7C3AED",
  red: "#6E1A1A",
};
const mono = { fontFamily: "monospace" };
const serif = { fontFamily: "'Georgia', serif" };

const SOCIOS = [
  {
    id: "estrategista",
    nome: "Estrategista",
    ferramenta: "Gemini",
    papel: "Direção estratégica · DIRETRIZ + 5 ideias · Shadow Architect",
    cor: "#1A3A6E",
    corBorda: "#3B82F6",
    icon: "G",
    outputLabel: "DIRETRIZ entregue",
    formatoLabel: "Formato DIRETRIZ respeitado? (título + blocos + skill nomeada + 5 ideias)",
    deficiencias: ["Shadow Architect (solução >4h sem Mágico de Oz)", "Recência Soberana", "DIRETRIZ sem [CONTRA-INTUITIVO]"],
  },
  {
    id: "auditor",
    nome: "Auditor",
    ferramenta: "NotebookLM",
    papel: "Auditoria histórica · SKILL nomeada · 4 blocos obrigatórios",
    cor: "#1A4A2E",
    corBorda: "#10B981",
    icon: "N",
    outputLabel: "SKILL entregue",
    formatoLabel: "4 blocos obrigatórios respeitados? (Contexto + Padrões + Alertas + Ações)",
    deficiencias: ["Rejeição Sumária (Skill sem 4 blocos = BLOQUEIO)", "Filtro Recência (MEMORIA→relatorio→DIRETRIZ)", "Yes-Man (confirma sem confrontar)"],
  },
  {
    id: "embaixador",
    nome: "Embaixador",
    ferramenta: "Claude Projects",
    papel: "Inteligência persistente do cliente · CONFIRMA / EXPANDE / ALERTA",
    cor: "#4A3A1A",
    corBorda: C.gold,
    icon: "E",
    outputLabel: "Reações entregues (CONFIRMA / EXPANDE / ALERTA)",
    formatoLabel: "Filtro de realidade aplicado? Comportamento real do cliente como base?",
    deficiencias: ["Recomendação técnica ≠ demanda do cliente", "Flags negativos exigidos", "P-032: MEMORIA_EMBAIXADOR automática pelo Músculo"],
  },
];

const NOTAS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

const NOTA_COR = (n) => {
  if (!n) return "rgba(255,255,255,0.15)";
  if (n <= 3) return "#F87171";
  if (n <= 6) return C.gold;
  return "#7EC8A0";
};

const DECISAO_OPTS = ["— Pendente", "✓ Aprovado para próximo ciclo", "⚠ Aprovado com ressalvas", "✗ Requere nova iteração"];
const DECISAO_CORES = {
  "— Pendente": "rgba(255,255,255,0.2)",
  "✓ Aprovado para próximo ciclo": "#7EC8A0",
  "⚠ Aprovado com ressalvas": C.gold,
  "✗ Requere nova iteração": "#F87171",
};

export default function AvaliacaoSocios() {
  const [meta, setMeta] = useState({
    projeto: "", loop: "", data: "", diretor: "Eduardo",
  });
  const [avaliacoes, setAvaliacoes] = useState({
    estrategista: { output: "", formato: "—", nota: null, acertou: "", falhou: "", acao: "", decisao: "— Pendente" },
    auditor:       { output: "", formato: "—", nota: null, acertou: "", falhou: "", acao: "", decisao: "— Pendente" },
    embaixador:    { output: "", formato: "—", nota: null, acertou: "", falhou: "", acao: "", decisao: "— Pendente" },
  });
  const [geral, setGeral] = useState({
    maisAlinhado: "—",
    decisaoLoop: "— Pendente",
    observacoes: "",
    ideias: ["", "", "", "", ""],
  });

  const setMeta_ = (k, v) => setMeta(p => ({ ...p, [k]: v }));
  const setAval = (socio, k, v) => setAvaliacoes(p => ({ ...p, [socio]: { ...p[socio], [k]: v } }));
  const setGeral_ = (k, v) => setGeral(p => ({ ...p, [k]: v }));
  const setIdeia = (i, v) => setGeral(p => ({ ...p, ideias: p.ideias.map((x, j) => j === i ? v : x) }));

  const formatoOpts = ["—", "✓ Sim — formato completo", "⚠ Parcial — faltou algo", "✗ Não — formato quebrado"];
  const formatoCores = {
    "—": "rgba(255,255,255,0.2)",
    "✓ Sim — formato completo": "#7EC8A0",
    "⚠ Parcial — faltou algo": C.gold,
    "✗ Não — formato quebrado": "#F87171",
  };

  const inputStyle = (bg = "rgba(255,255,255,0.06)") => ({
    width: "100%", background: bg,
    border: "1px solid rgba(255,255,255,0.12)", padding: "8px 12px",
    color: "#fff", fontSize: 13, ...mono, outline: "none", borderRadius: 3,
    resize: "vertical",
  });

  const avgNota = () => {
    const ns = Object.values(avaliacoes).map(a => a.nota).filter(Boolean);
    if (!ns.length) return null;
    return (ns.reduce((a, b) => a + b, 0) / ns.length).toFixed(1);
  };

  return (
    <div style={{ minHeight: "100vh", background: "#080F18", ...serif }}>

      {/* HEADER */}
      <div style={{ background: "#050A10", borderBottom: "1px solid rgba(201,168,76,0.2)", padding: "24px 32px" }}>
        <div style={{ maxWidth: 900, margin: "0 auto" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 4, color: C.gold, marginBottom: 8 }}>
            QUADRILATERAL IAH · PENTALATERAL · AVALIAÇÃO DO CONSELHO
          </div>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-end", flexWrap: "wrap", gap: 16 }}>
            <div>
              <h1 style={{ fontSize: 26, fontWeight: 700, color: "#fff", margin: 0 }}>Avaliação dos Sócios</h1>
              <div style={{ fontSize: 14, color: "rgba(255,255,255,0.35)", marginTop: 4, fontStyle: "italic" }}>
                Executada pelo Diretor ao fechar cada loop · Base para o próximo ciclo evolutivo
              </div>
            </div>
            <div style={{ ...mono, fontSize: 10, color: C.gold, border: `1px solid rgba(201,168,76,0.3)`, padding: "6px 14px", borderRadius: 4 }}>
              {avgNota() ? `MÉDIA LOOP: ${avgNota()}/10` : "MÉDIA — / 10"}
            </div>
          </div>
        </div>
      </div>

      <div style={{ maxWidth: 900, margin: "0 auto", padding: "0 0 60px" }}>

        {/* META */}
        <div style={{ background: C.navyMid, padding: "22px 36px" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 16 }}>IDENTIFICAÇÃO DO LOOP</div>
          <div style={{ display: "grid", gridTemplateColumns: "2fr 1fr 1fr 1fr", gap: 14 }}>
            {[
              { label: "PROJETO", k: "projeto", ph: "Nome do projeto" },
              { label: "LOOP #", k: "loop", ph: "ex: 6" },
              { label: "DATA", k: "data", ph: "dd/mm/aaaa" },
              { label: "DIRETOR", k: "diretor", ph: "Eduardo" },
            ].map(f => (
              <div key={f.k}>
                <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.4)", letterSpacing: 2, marginBottom: 4 }}>{f.label}</div>
                <input
                  value={meta[f.k]}
                  onChange={e => setMeta_(f.k, e.target.value)}
                  placeholder={f.ph}
                  style={{ width: "100%", background: "rgba(255,255,255,0.07)", border: "1px solid rgba(255,255,255,0.12)", padding: "6px 10px", color: "#fff", fontSize: 13, ...mono, outline: "none", borderRadius: 3 }}
                />
              </div>
            ))}
          </div>
        </div>

        {/* AVISO */}
        <div style={{ margin: "28px 36px 0" }}>
          <div style={{ background: "rgba(201,168,76,0.07)", border: `1px solid rgba(201,168,76,0.2)`, borderLeft: `4px solid ${C.gold}`, borderRadius: 4, padding: "14px 18px" }}>
            <div style={{ ...mono, fontSize: 9, color: C.gold, letterSpacing: 2, marginBottom: 6 }}>INSTRUÇÃO DO DIRETOR</div>
            <div style={{ fontSize: 14, color: "rgba(255,255,255,0.6)", lineHeight: 1.7 }}>
              Preencher após receber os outputs dos três sócios no loop. A avaliação alimenta o próximo ciclo —
              sócios que falharem no formato são confrontados no próximo <strong style={{ color: "rgba(255,255,255,0.8)" }}>PASSO3</strong> (Estrategista) ou
              <strong style={{ color: "rgba(255,255,255,0.8)" }}> PASSO5</strong> (Auditor) com a falha documentada aqui.
              O Embaixador recebe a avaliação via <strong style={{ color: "rgba(255,255,255,0.8)" }}>PASSO7</strong>.
            </div>
          </div>
        </div>

        {/* AVALIAÇÃO POR SÓCIO */}
        <div style={{ padding: "28px 36px 0" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 24 }}>AVALIAÇÃO POR SÓCIO</div>

          {SOCIOS.map((socio) => {
            const aval = avaliacoes[socio.id];
            return (
              <div key={socio.id} style={{
                marginBottom: 28,
                border: `2px solid ${socio.corBorda}`,
                borderRadius: 8, overflow: "hidden",
              }}>
                {/* Cabeçalho do sócio */}
                <div style={{ background: socio.cor, padding: "16px 22px", display: "flex", alignItems: "center", gap: 16 }}>
                  <div style={{
                    width: 48, height: 48, borderRadius: "50%",
                    background: socio.corBorda, display: "flex", alignItems: "center", justifyContent: "center",
                    ...mono, fontSize: 18, fontWeight: 700, color: "#fff", flexShrink: 0,
                  }}>
                    {socio.icon}
                  </div>
                  <div style={{ flex: 1 }}>
                    <div style={{ fontSize: 16, color: "#fff", fontWeight: 700 }}>
                      {socio.nome} <span style={{ ...mono, fontSize: 11, color: "rgba(255,255,255,0.4)", fontWeight: 400 }}>via {socio.ferramenta}</span>
                    </div>
                    <div style={{ ...mono, fontSize: 10, color: "rgba(255,255,255,0.4)", marginTop: 2 }}>{socio.papel}</div>
                  </div>
                  {/* Nota */}
                  <div style={{ textAlign: "center" }}>
                    <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2, marginBottom: 6 }}>NOTA</div>
                    <div style={{ display: "flex", gap: 4, flexWrap: "wrap", justifyContent: "flex-end", maxWidth: 180 }}>
                      {NOTAS.map(n => (
                        <button
                          key={n}
                          onClick={() => setAval(socio.id, "nota", aval.nota === n ? null : n)}
                          style={{
                            width: 28, height: 28,
                            background: aval.nota === n ? NOTA_COR(n) : "rgba(255,255,255,0.05)",
                            border: `1px solid ${aval.nota === n ? NOTA_COR(n) : "rgba(255,255,255,0.15)"}`,
                            color: aval.nota === n ? "#fff" : "rgba(255,255,255,0.4)",
                            ...mono, fontSize: 11, cursor: "pointer", borderRadius: 3,
                            fontWeight: aval.nota === n ? 700 : 400,
                          }}
                        >
                          {n}
                        </button>
                      ))}
                    </div>
                    {aval.nota && (
                      <div style={{ ...mono, fontSize: 10, color: NOTA_COR(aval.nota), marginTop: 6, fontWeight: 700 }}>
                        {aval.nota}/10
                      </div>
                    )}
                  </div>
                </div>

                {/* Corpo */}
                <div style={{ background: "rgba(255,255,255,0.02)", padding: "20px 22px" }}>

                  {/* Deficiências nativas — lembrete */}
                  <div style={{ background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.06)", borderRadius: 4, padding: "10px 14px", marginBottom: 18 }}>
                    <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.25)", letterSpacing: 2, marginBottom: 6 }}>DEFICIÊNCIAS NATIVAS — CHECAR</div>
                    <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
                      {socio.deficiencias.map((d, i) => (
                        <div key={i} style={{ ...mono, fontSize: 10, color: "rgba(255,255,255,0.35)", background: "rgba(255,255,255,0.04)", border: "1px solid rgba(255,255,255,0.08)", padding: "3px 8px", borderRadius: 3 }}>
                          {d}
                        </div>
                      ))}
                    </div>
                  </div>

                  <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 16 }}>
                    {/* Output */}
                    <div>
                      <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.35)", letterSpacing: 2, marginBottom: 6 }}>{socio.outputLabel.toUpperCase()}</div>
                      <textarea
                        value={aval.output}
                        onChange={e => setAval(socio.id, "output", e.target.value)}
                        placeholder="Descreva o output principal entregue..."
                        rows={3}
                        style={inputStyle()}
                      />
                    </div>
                    {/* Formato */}
                    <div>
                      <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.35)", letterSpacing: 2, marginBottom: 6 }}>FORMATO RESPEITADO?</div>
                      <div style={{ fontSize: 11, color: "rgba(255,255,255,0.35)", marginBottom: 8, lineHeight: 1.5 }}>{socio.formatoLabel}</div>
                      <select
                        value={aval.formato}
                        onChange={e => setAval(socio.id, "formato", e.target.value)}
                        style={{
                          background: "rgba(255,255,255,0.05)", border: `1px solid ${formatoCores[aval.formato]}`,
                          color: formatoCores[aval.formato], padding: "6px 10px",
                          fontSize: 12, ...mono, outline: "none", borderRadius: 3, cursor: "pointer", width: "100%",
                        }}
                      >
                        {formatoOpts.map(o => <option key={o} value={o} style={{ background: C.navy }}>{o}</option>)}
                      </select>
                    </div>
                  </div>

                  <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 16, marginBottom: 16 }}>
                    {/* Acertou */}
                    <div>
                      <div style={{ ...mono, fontSize: 9, color: "#7EC8A0", letterSpacing: 2, marginBottom: 6 }}>O QUE ACERTOU</div>
                      <textarea
                        value={aval.acertou}
                        onChange={e => setAval(socio.id, "acertou", e.target.value)}
                        placeholder="Pontos fortes, alinhamentos, surpresas positivas..."
                        rows={3}
                        style={inputStyle("rgba(26,74,46,0.1)")}
                      />
                    </div>
                    {/* Falhou */}
                    <div>
                      <div style={{ ...mono, fontSize: 9, color: "#F87171", letterSpacing: 2, marginBottom: 6 }}>O QUE FALHOU OU FALTOU</div>
                      <textarea
                        value={aval.falhou}
                        onChange={e => setAval(socio.id, "falhou", e.target.value)}
                        placeholder="Lacunas, deficiências não combatidas, formato quebrado..."
                        rows={3}
                        style={inputStyle("rgba(110,26,26,0.1)")}
                      />
                    </div>
                    {/* Ação */}
                    <div>
                      <div style={{ ...mono, fontSize: 9, color: C.gold, letterSpacing: 2, marginBottom: 6 }}>AÇÃO PARA O PRÓXIMO LOOP</div>
                      <textarea
                        value={aval.acao}
                        onChange={e => setAval(socio.id, "acao", e.target.value)}
                        placeholder="O que instruir no próximo PASSO3/5/7 para corrigir..."
                        rows={3}
                        style={inputStyle("rgba(201,168,76,0.06)")}
                      />
                    </div>
                  </div>

                  {/* Decisão individual */}
                  <div style={{ display: "flex", alignItems: "center", gap: 14, borderTop: "1px solid rgba(255,255,255,0.07)", paddingTop: 14 }}>
                    <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2 }}>DECISÃO DO DIRETOR:</div>
                    <select
                      value={aval.decisao}
                      onChange={e => setAval(socio.id, "decisao", e.target.value)}
                      style={{
                        background: "rgba(255,255,255,0.05)", border: `1px solid ${DECISAO_CORES[aval.decisao]}`,
                        color: DECISAO_CORES[aval.decisao], padding: "6px 12px",
                        fontSize: 12, ...mono, outline: "none", borderRadius: 3, cursor: "pointer",
                      }}
                    >
                      {DECISAO_OPTS.map(o => <option key={o} value={o} style={{ background: C.navy }}>{o}</option>)}
                    </select>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* ANÁLISE COMPARATIVA */}
        <div style={{ padding: "0 36px 28px" }}>
          <div style={{ background: C.navyMid, borderRadius: 8, padding: "22px 28px" }}>
            <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 20 }}>ANÁLISE COMPARATIVA DO LOOP</div>

            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 20, marginBottom: 20 }}>
              {/* Mais alinhado */}
              <div>
                <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.35)", letterSpacing: 2, marginBottom: 8 }}>SÓCIO MAIS ALINHADO COM A REALIDADE</div>
                <select
                  value={geral.maisAlinhado}
                  onChange={e => setGeral_("maisAlinhado", e.target.value)}
                  style={{
                    width: "100%", background: "rgba(255,255,255,0.05)", border: "1px solid rgba(255,255,255,0.15)",
                    color: "rgba(255,255,255,0.8)", padding: "8px 12px",
                    fontSize: 13, ...mono, outline: "none", borderRadius: 3, cursor: "pointer",
                  }}
                >
                  {["—", "Estrategista (Gemini)", "Auditor (NotebookLM)", "Embaixador (Claude Projects)", "Todos alinhados", "Nenhum alinhado"].map(o => (
                    <option key={o} value={o} style={{ background: C.navy }}>{o}</option>
                  ))}
                </select>
              </div>

              {/* Decisão do loop */}
              <div>
                <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.35)", letterSpacing: 2, marginBottom: 8 }}>DECISÃO SOBRE O LOOP</div>
                <select
                  value={geral.decisaoLoop}
                  onChange={e => setGeral_("decisaoLoop", e.target.value)}
                  style={{
                    width: "100%", background: "rgba(255,255,255,0.05)", border: `1px solid ${DECISAO_CORES[geral.decisaoLoop] || "rgba(255,255,255,0.15)"}`,
                    color: DECISAO_CORES[geral.decisaoLoop] || "rgba(255,255,255,0.8)", padding: "8px 12px",
                    fontSize: 13, ...mono, outline: "none", borderRadius: 3, cursor: "pointer",
                  }}
                >
                  {DECISAO_OPTS.map(o => <option key={o} value={o} style={{ background: C.navy }}>{o}</option>)}
                </select>
              </div>
            </div>

            {/* Observações gerais */}
            <div>
              <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.35)", letterSpacing: 2, marginBottom: 8 }}>OBSERVAÇÕES GERAIS DO DIRETOR</div>
              <textarea
                value={geral.observacoes}
                onChange={e => setGeral_("observacoes", e.target.value)}
                placeholder="Padrões identificados, convergências, divergências relevantes, o que muda no próximo loop..."
                rows={4}
                style={{ ...inputStyle(), resize: "vertical" }}
              />
            </div>
          </div>
        </div>

        {/* 5 IDEIAS */}
        <div style={{ padding: "0 36px 28px" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 14 }}>5 IDEIAS QUE SURGIRAM DESTA AVALIAÇÃO</div>
          <div style={{ fontSize: 12, color: "rgba(255,255,255,0.3)", ...mono, marginBottom: 16 }}>
            Ideias para o próximo ciclo · vão para o PASSO3 do Estrategista como "inputs do Diretor"
          </div>
          {geral.ideias.map((ideia, i) => (
            <div key={i} style={{ display: "flex", gap: 14, marginBottom: 10, alignItems: "flex-start" }}>
              <div style={{
                width: 28, height: 28, borderRadius: "50%", background: C.navyMid,
                border: `1px solid ${C.gold}`, display: "flex", alignItems: "center", justifyContent: "center",
                ...mono, fontSize: 12, color: C.gold, fontWeight: 700, flexShrink: 0, marginTop: 2,
              }}>
                {i + 1}
              </div>
              <input
                value={ideia}
                onChange={e => setIdeia(i, e.target.value)}
                placeholder={`Ideia ${i + 1} para o próximo loop...`}
                style={{ flex: 1, background: "rgba(255,255,255,0.04)", border: "1px solid rgba(255,255,255,0.1)", padding: "8px 12px", color: "#fff", fontSize: 13, ...mono, outline: "none", borderRadius: 3 }}
              />
            </div>
          ))}
        </div>

        {/* SCORECARD VISUAL */}
        <div style={{ padding: "0 36px 28px" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 14 }}>SCORECARD DO LOOP</div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr 1fr", gap: 12 }}>
            {[
              ...SOCIOS.map(s => ({
                label: s.nome,
                value: avaliacoes[s.id].nota ? `${avaliacoes[s.id].nota}/10` : "—",
                cor: NOTA_COR(avaliacoes[s.id].nota),
                sub: avaliacoes[s.id].decisao.split(" ").slice(1).join(" ") || "Pendente",
              })),
              {
                label: "MÉDIA GERAL",
                value: avgNota() ? `${avgNota()}/10` : "—",
                cor: NOTA_COR(parseFloat(avgNota())),
                sub: geral.decisaoLoop.split(" ").slice(1).join(" ") || "Pendente",
              },
            ].map((item, i) => (
              <div key={i} style={{
                background: "rgba(255,255,255,0.03)", border: `1px solid ${item.cor}`,
                borderRadius: 6, padding: "16px 14px", textAlign: "center",
              }}>
                <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.35)", letterSpacing: 2, marginBottom: 8 }}>{item.label.toUpperCase()}</div>
                <div style={{ fontSize: 28, fontWeight: 700, color: item.cor, ...mono, marginBottom: 8 }}>{item.value}</div>
                <div style={{ fontSize: 10, color: "rgba(255,255,255,0.3)", lineHeight: 1.4 }}>{item.sub}</div>
              </div>
            ))}
          </div>
        </div>

        {/* ASSINATURA */}
        <div style={{ padding: "0 36px" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 14, borderBottom: "1px solid rgba(255,255,255,0.08)", paddingBottom: 10 }}>
            ASSINATURA DO DIRETOR
          </div>
          <div style={{ fontSize: 14, color: "rgba(255,255,255,0.45)", marginBottom: 24, lineHeight: 1.7 }}>
            Ao assinar, o Diretor confirma que avaliou os três sócios, registrou as ações corretivas
            e está abrindo o próximo loop com os insumos desta avaliação.
          </div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 2fr", gap: 48, maxWidth: 600 }}>
            <div>
              <div style={{ height: 48, borderBottom: "1px solid rgba(255,255,255,0.4)", marginBottom: 8 }} />
              <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2, marginBottom: 4 }}>DIRETOR — VANGUARD TECH</div>
              <div style={{ ...serif, fontStyle: "italic", fontSize: 13, color: "rgba(255,255,255,0.4)" }}>Eduardo</div>
            </div>
            <div>
              <div style={{ height: 48, borderBottom: "1px solid rgba(255,255,255,0.4)", marginBottom: 8 }} />
              <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2, marginBottom: 4 }}>DATA / LOOP</div>
              <div style={{ ...mono, fontSize: 13, color: "rgba(255,255,255,0.3)" }}>
                {meta.data || "___/___/______"} · Loop {meta.loop || "#"}
              </div>
            </div>
          </div>
        </div>

      </div>

      {/* FOOTER */}
      <div style={{ borderTop: "1px solid rgba(201,168,76,0.1)", padding: "14px 32px", display: "flex", justifyContent: "space-between" }}>
        <div style={{ ...mono, fontSize: 10, color: "rgba(255,255,255,0.2)", letterSpacing: 1 }}>QUADRILATERAL IAH · AVALIAÇÃO DOS SÓCIOS · PENTALATERAL</div>
        <div style={{ ...mono, fontSize: 10, color: "rgba(255,255,255,0.2)", letterSpacing: 1 }}>ARQUIVAR COM MEMORIA DO LOOP</div>
      </div>
    </div>
  );
}

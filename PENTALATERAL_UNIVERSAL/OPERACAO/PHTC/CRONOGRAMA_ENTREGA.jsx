import { useState } from "react";

const C = {
  navy: "#0D1B2A", navyMid: "#1A2E45", navyLight: "#243B55",
  gold: "#C9A84C", goldLight: "#E2C47A", goldPale: "#F5EDD6",
  cream: "#FAF7F2", text: "#1A1A1A", muted: "#5A5A5A",
  rule: "#D4C4A0", green: "#1A4A2E", greenLight: "#2D6B47",
};
const mono = { fontFamily: "monospace" };
const serif = { fontFamily: "'Georgia', serif" };

const STATUS_OPTIONS = ["—", "Prevista", "Em andamento", "Concluída", "Atrasada"];
const STATUS_COLORS = {
  "—": "rgba(255,255,255,0.2)",
  "Prevista": C.gold,
  "Em andamento": "#60A5FA",
  "Concluída": "#7EC8A0",
  "Atrasada": "#F87171",
};

const FASES = [
  {
    num: "00",
    nome: "Qualificação e Proposta",
    duracao: "1 A 3 DIAS · PRIMEIRO CONTATO ATÉ APROVAÇÃO DO PROJETO",
    cor: "#1a1a2e",
    corBorda: "rgba(201,168,76,0.4)",
    desc: "Primeiro contato com a Vanguard, apresentação do projeto, alinhamento de expectativas e aprovação da proposta comercial. Ao final desta fase, o cliente decide se avança para o levantamento de necessidades. Nenhum prazo de entrega começa a contar antes desta aprovação.",
    campos: [
      { label: "Primeiro contato", k: "f0_inicio" },
      { label: "Proposta aprovada em", k: "f0_real" },
    ],
  },
  {
    num: "01",
    nome: "Levantamento de Necessidades",
    duracao: "1 DIA · PRESENCIAL OU REMOTO",
    cor: C.navy,
    corBorda: C.gold,
    desc: "Sessão de alinhamento completo: levantamento das necessidades reais do cliente, definição do resultado concreto que valida a entrega, aprovação do escopo fechado e assinatura deste Cronograma. Nenhuma construção começa antes desta fase estar concluída.",
    campos: [
      { label: "Data prevista", k: "f1_prevista" },
      { label: "Concluída em", k: "f1_real" },
    ],
  },
  {
    num: "02",
    nome: "Build — Construção do Produto",
    duracao: "CONFORME COMPLEXIDADE DO PROJETO (1 A 15 DIAS ÚTEIS)",
    cor: C.navyLight,
    corBorda: C.gold,
    desc: "Desenvolvimento completo do produto. Ciclos internos de validação ocorrem diariamente. O cliente não é acionado durante esta fase, salvo para esclarecer algum ponto do escopo. Ao final do build, o produto está no ambiente final de produção — funcional e estável.",
    campos: [
      { label: "Início previsto", k: "f2_inicio" },
      { label: "Término previsto", k: "f2_fim" },
    ],
  },
  {
    num: "03",
    nome: "Período de Testes",
    duracao: "ATÉ 48 HORAS · CLIENTE USA A FERRAMENTA NO PRÓPRIO CELULAR",
    cor: "#7A5C1E",
    corBorda: C.gold,
    destaque: true,
    desc: "O cliente recebe o link da ferramenta e testa com casos reais do seu trabalho — no celular ou computador que usa no dia a dia, na rede que usa normalmente. Esta fase é obrigatória e faz parte do projeto. Só após o cliente confirmar que a ferramenta funcionou como esperado é que o contrato definitivo é apresentado.",
    nota: "Se o cliente identificar qualquer falha durante os testes, a equipe Vanguard corrige e reinicia o período. Nenhum contrato é apresentado enquanto o produto não estiver aprovado pelo cliente.",
    campos: [
      { label: "Acesso liberado em", k: "f3_inicio" },
      { label: "Prazo de aprovação", k: "f3_fim" },
    ],
  },
  {
    num: "04",
    nome: "Assinatura do Contrato Definitivo",
    duracao: "1 DIA · APÓS APROVAÇÃO DOS TESTES",
    cor: C.navyMid,
    corBorda: C.goldLight,
    desc: "Com a confirmação do cliente em mãos, o contrato definitivo é apresentado. O documento formaliza exatamente o produto que o cliente acabou de testar e aprovar — sem surpresas. Assinatura presencial ou digital.",
    campos: [
      { label: "Data prevista", k: "f4_prevista" },
      { label: "Assinado em", k: "f4_real" },
    ],
  },
  {
    num: "✓",
    nome: "Entrega Formal — Chaves na Mão",
    duracao: "1 DIA · PRESENCIAL OU REMOTO",
    cor: C.green,
    corBorda: C.greenLight,
    verde: true,
    desc: "Entrega formal do produto: o cliente recebe as credenciais de acesso (usuário e senha definitivos), o manual de operação completo — para usar a ferramenta de forma autônoma, sem precisar chamar a Vanguard — e o início do período de suporte de 30 dias para correção de eventuais falhas, sem custo adicional.",
    campos: [
      { label: "Data prevista de entrega", k: "f5_prevista" },
      { label: "Entregue em", k: "f5_real" },
    ],
  },
  {
    num: "06",
    nome: "Suporte Pós-Entrega — 30 Dias Inclusos",
    duracao: "30 DIAS CORRIDOS A PARTIR DA ENTREGA FINAL",
    cor: "#1a2e1a",
    corBorda: "rgba(45,107,71,0.6)",
    desc: "Durante 30 dias após a entrega, a Vanguard está disponível para corrigir qualquer falha que o cliente encontrar no uso diário — sem custo adicional. Este período existe para garantir que o cliente está operando com conforto e autonomia. Após os 30 dias, qualquer suporte ou evolução da ferramenta é tratado como um novo projeto.",
    campos: [
      { label: "Início do suporte", k: "f6_inicio" },
      { label: "Encerramento do suporte", k: "f6_fim" },
    ],
  },
];

export default function CronogramaEntrega() {
  const [meta, setMeta] = useState({
    cliente: "", produto: "", responsavel: "Eduardo — Vanguard Tech",
    kickoff: "", camada: "", valor: "",
  });
  const [datas, setDatas] = useState({
    f0_inicio: "", f0_real: "", f0_status: "—",
    f1_prevista: "", f1_real: "", f1_status: "—",
    f2_inicio: "", f2_fim: "", f2_status: "—",
    f3_inicio: "", f3_fim: "", f3_status: "—",
    f4_prevista: "", f4_real: "", f4_status: "—",
    f5_prevista: "", f5_real: "", f5_status: "—",
    f6_inicio: "", f6_fim: "", f6_status: "—",
  });

  const setMeta_ = (k, v) => setMeta(p => ({ ...p, [k]: v }));
  const setData = (k, v) => setDatas(p => ({ ...p, [k]: v }));

  const input = (k, ph = "—", bg = "rgba(255,255,255,0.07)") => (
    <input
      value={datas[k] !== undefined ? datas[k] : meta[k] || ""}
      onChange={e => datas[k] !== undefined ? setData(k, e.target.value) : setMeta_(k, e.target.value)}
      placeholder={ph}
      style={{
        width: "100%", background: bg,
        border: "1px solid rgba(255,255,255,0.12)", padding: "6px 10px",
        color: "#fff", fontSize: 13, ...mono, outline: "none", borderRadius: 3,
      }}
    />
  );

  const statusBadge = (statusKey) => {
    const val = datas[statusKey];
    return (
      <select
        value={val}
        onChange={e => setData(statusKey, e.target.value)}
        style={{
          background: "rgba(255,255,255,0.05)", border: `1px solid ${STATUS_COLORS[val] || "rgba(255,255,255,0.15)"}`,
          color: STATUS_COLORS[val] || "rgba(255,255,255,0.4)", padding: "4px 8px",
          fontSize: 11, ...mono, outline: "none", borderRadius: 3, cursor: "pointer",
        }}
      >
        {STATUS_OPTIONS.map(s => <option key={s} value={s} style={{ background: C.navy }}>{s}</option>)}
      </select>
    );
  };

  const faseStatusKey = ["f0_status", "f1_status", "f2_status", "f3_status", "f4_status", "f5_status", "f6_status"];

  return (
    <div style={{ minHeight: "100vh", background: "#080F18", ...serif }}>

      {/* HEADER */}
      <div style={{ background: "#050A10", borderBottom: "1px solid rgba(201,168,76,0.2)", padding: "24px 32px" }}>
        <div style={{ maxWidth: 860, margin: "0 auto" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 4, color: C.gold, marginBottom: 8 }}>
            VANGUARD TECH · CRONOGRAMA DE ENTREGA · DOCUMENTO DO CLIENTE
          </div>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-end", flexWrap: "wrap", gap: 16 }}>
            <div>
              <h1 style={{ fontSize: 26, fontWeight: 700, color: "#fff", margin: 0 }}>Cronograma Oficial de Entrega</h1>
              <div style={{ fontSize: 14, color: "rgba(255,255,255,0.35)", marginTop: 4, fontStyle: "italic" }}>
                Entregue na reunião de início · Lido e assinado antes de qualquer construção
              </div>
            </div>
            <div style={{ ...mono, fontSize: 10, color: C.gold, border: `1px solid rgba(201,168,76,0.3)`, padding: "6px 14px", borderRadius: 4 }}>
              P-046 · P-047
            </div>
          </div>
        </div>
      </div>

      <div style={{ maxWidth: 860, margin: "0 auto", padding: "0 0 60px" }}>

        {/* META */}
        <div style={{ background: C.navyMid, padding: "24px 36px" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 16 }}>IDENTIFICAÇÃO DO PROJETO</div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 14 }}>
            {[
              { label: "CLIENTE", k: "cliente", ph: "Nome do cliente" },
              { label: "PRODUTO / PROJETO", k: "produto", ph: "Nome da ferramenta" },
              { label: "RESPONSÁVEL VANGUARD", k: "responsavel", ph: "Eduardo — Vanguard Tech" },
              { label: "DATA DE INÍCIO OFICIAL", k: "kickoff", ph: "dd/mm/aaaa" },
              { label: "ETAPA DO PROJETO", k: "camada", ph: "ex: Etapa 1 — Validação" },
              { label: "VALOR CONTRATADO", k: "valor", ph: "R$ —" },
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

        {/* AVISO INICIAL */}
        <div style={{ margin: "0 36px", marginTop: 28 }}>
          <div style={{ background: "rgba(201,168,76,0.08)", border: `1px solid rgba(201,168,76,0.25)`, borderLeft: `4px solid ${C.gold}`, borderRadius: 4, padding: "14px 18px" }}>
            <div style={{ ...mono, fontSize: 9, color: C.gold, letterSpacing: 2, marginBottom: 6 }}>COMO LER ESTE CRONOGRAMA</div>
            <div style={{ fontSize: 14, color: "rgba(255,255,255,0.65)", lineHeight: 1.7 }}>
              Cada fase tem uma duração estimada e uma data prevista. As fases seguintes só começam após a conclusão da anterior. O cliente é comunicado ao início de cada nova fase. <strong style={{ color: "rgba(255,255,255,0.85)" }}>A fase de testes (Fase 3) é obrigatória — o contrato definitivo só é apresentado após ela ser concluída.</strong>
            </div>
          </div>
        </div>

        {/* FASES */}
        <div style={{ padding: "28px 36px" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 20 }}>FASES DO PROJETO</div>

          {/* Timeline line */}
          <div style={{ position: "relative" }}>
            <div style={{ position: "absolute", left: 29, top: 0, bottom: 0, width: 2, background: `linear-gradient(180deg, ${C.gold} 0%, rgba(201,168,76,0.2) 100%)`, zIndex: 0 }} />

            {FASES.map((fase, idx) => (
              <div key={idx} style={{ display: "flex", gap: 24, marginBottom: 20, position: "relative", zIndex: 1 }}>
                {/* DOT */}
                <div style={{
                  width: 60, height: 60, borderRadius: "50%", flexShrink: 0,
                  background: fase.cor, border: `2px solid ${fase.corBorda}`,
                  display: "flex", alignItems: "center", justifyContent: "center",
                  ...mono, fontSize: fase.verde ? 20 : 13, fontWeight: 700,
                  color: fase.verde ? "#fff" : C.gold,
                }}>
                  {fase.num}
                </div>

                {/* BODY */}
                <div style={{
                  flex: 1,
                  background: fase.destaque ? "rgba(201,168,76,0.06)" : fase.verde ? "rgba(26,74,46,0.15)" : "rgba(255,255,255,0.03)",
                  border: `1px solid ${fase.destaque ? `rgba(201,168,76,0.35)` : fase.verde ? "rgba(45,107,71,0.4)" : "rgba(255,255,255,0.07)"}`,
                  borderWidth: fase.destaque || fase.verde ? 2 : 1,
                  borderRadius: 6, padding: "18px 22px",
                }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 6 }}>
                    <div style={{ fontSize: 15, color: "#fff", fontWeight: 700 }}>{fase.nome}</div>
                    {statusBadge(faseStatusKey[idx])}
                  </div>

                  <div style={{ ...mono, fontSize: 10, color: fase.destaque ? C.gold : "rgba(255,255,255,0.35)", letterSpacing: 1, marginBottom: 10 }}>
                    {fase.duracao}
                  </div>

                  <div style={{ fontSize: 14, color: "rgba(255,255,255,0.55)", lineHeight: 1.7, marginBottom: fase.nota ? 12 : 16 }}>
                    {fase.desc}
                  </div>

                  {fase.nota && (
                    <div style={{ background: "rgba(201,168,76,0.1)", border: `1px solid rgba(201,168,76,0.25)`, borderRadius: 4, padding: "10px 14px", marginBottom: 16, fontSize: 13, color: "rgba(255,255,255,0.6)", lineHeight: 1.7 }}>
                      <strong style={{ color: C.gold }}>Importante: </strong>{fase.nota}
                    </div>
                  )}

                  {/* DATE FIELDS */}
                  <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 14, borderTop: "1px solid rgba(255,255,255,0.07)", paddingTop: 14 }}>
                    {fase.campos.map(campo => (
                      <div key={campo.k}>
                        <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2, marginBottom: 4 }}>{campo.label.toUpperCase()}</div>
                        <input
                          value={datas[campo.k]}
                          onChange={e => setData(campo.k, e.target.value)}
                          placeholder="dd/mm/aaaa"
                          style={{
                            width: "100%", background: datas[campo.k] ? "rgba(126,200,160,0.08)" : "rgba(255,255,255,0.05)",
                            border: `1px solid ${datas[campo.k] ? "rgba(126,200,160,0.3)" : "rgba(255,255,255,0.1)"}`,
                            padding: "6px 10px", color: "#fff", fontSize: 13, ...mono, outline: "none", borderRadius: 3,
                          }}
                        />
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* TABELA RESUMO */}
        <div style={{ padding: "0 36px 28px" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 16 }}>RESUMO DE DATAS</div>
          <div style={{ border: "1px solid rgba(255,255,255,0.08)", borderRadius: 6, overflow: "hidden" }}>
            <div style={{ display: "grid", gridTemplateColumns: "2fr 1fr 1fr 1fr", background: C.navy, padding: "10px 16px" }}>
              {["FASE", "DATA PREVISTA", "DATA REAL", "STATUS"].map(h => (
                <div key={h} style={{ ...mono, fontSize: 9, color: C.gold, letterSpacing: 2 }}>{h}</div>
              ))}
            </div>
            {[
              { nome: "Qualificação e Proposta", prev: "f0_inicio", real: "f0_real", status: "f0_status" },
              { nome: "Levantamento de Necessidades", prev: "f1_prevista", real: "f1_real", status: "f1_status" },
              { nome: "Build — Construção", prev: "f2_inicio", real: "f2_fim", status: "f2_status" },
              { nome: "Período de Testes (até 48h)", prev: "f3_inicio", real: "f3_fim", status: "f3_status", destaque: true },
              { nome: "Assinatura do Contrato", prev: "f4_prevista", real: "f4_real", status: "f4_status" },
              { nome: "Entrega Formal — Chaves na Mão", prev: "f5_prevista", real: "f5_real", status: "f5_status", verde: true },
              { nome: "Suporte Pós-Entrega — 30 Dias Inclusos", prev: "f6_inicio", real: "f6_fim", status: "f6_status" },
            ].map((row, idx) => (
              <div key={idx} style={{
                display: "grid", gridTemplateColumns: "2fr 1fr 1fr 1fr",
                padding: "10px 16px",
                background: row.destaque ? "rgba(201,168,76,0.05)" : row.verde ? "rgba(26,74,46,0.1)" : idx % 2 === 0 ? "rgba(255,255,255,0.02)" : "transparent",
                borderTop: "1px solid rgba(255,255,255,0.06)",
                alignItems: "center",
              }}>
                <div style={{ fontSize: 14, color: row.destaque ? C.gold : row.verde ? "#7EC8A0" : "rgba(255,255,255,0.7)", fontWeight: row.destaque || row.verde ? 600 : 400 }}>{row.nome}</div>
                <div style={{ ...mono, fontSize: 12, color: datas[row.prev] ? "rgba(255,255,255,0.8)" : "rgba(255,255,255,0.25)" }}>{datas[row.prev] || "—"}</div>
                <div style={{ ...mono, fontSize: 12, color: datas[row.real] ? "#7EC8A0" : "rgba(255,255,255,0.25)" }}>{datas[row.real] || "—"}</div>
                <div style={{ ...mono, fontSize: 11, color: STATUS_COLORS[datas[row.status]] || "rgba(255,255,255,0.25)" }}>{datas[row.status] || "—"}</div>
              </div>
            ))}
          </div>
        </div>

        {/* CONDIÇÕES */}
        <div style={{ margin: "0 36px 28px" }}>
          <div style={{ background: C.navyMid, padding: "22px 28px" }}>
            <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 16 }}>CONDIÇÕES DO CRONOGRAMA</div>
            {[
              "Os prazos acima são estimativas baseadas no escopo fechado na reunião de levantamento de necessidades. Alterações solicitadas após o início oficial do projeto podem impactar os prazos e serão tratadas via pedido formal de alteração de escopo.",
              "O Período de Testes (Fase 3) é parte integrante do projeto e não pode ser suprimido. O contrato definitivo e a entrega final dependem da conclusão desta fase.",
              "A Vanguard se compromete a comunicar o cliente com antecedência mínima de 24 horas sobre qualquer alteração nas datas previstas.",
              "O período de suporte pós-entrega de 30 dias para correção de falhas começa na data da Entrega Final, independente da data de assinatura do contrato.",
            ].map((cond, i) => (
              <div key={i} style={{ display: "flex", gap: 14, marginBottom: i < 3 ? 14 : 0 }}>
                <div style={{ ...mono, fontSize: 11, color: C.gold, flexShrink: 0, marginTop: 2 }}>{i + 1}.</div>
                <div style={{ fontSize: 14, color: "rgba(255,255,255,0.6)", lineHeight: 1.7 }}>{cond}</div>
              </div>
            ))}
          </div>
        </div>

        {/* ASSINATURAS */}
        <div style={{ padding: "0 36px" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 14, borderBottom: "1px solid rgba(255,255,255,0.08)", paddingBottom: 10 }}>CIÊNCIA E CONCORDÂNCIA</div>
          <div style={{ fontSize: 14, color: "rgba(255,255,255,0.45)", marginBottom: 24, lineHeight: 1.7 }}>
            Ao assinar abaixo, o cliente confirma que leu e compreendeu o cronograma de entrega, incluindo o Período de Testes obrigatório como fase oficial do projeto — <strong style={{ color: "rgba(255,255,255,0.65)" }}>anterior à assinatura do contrato definitivo.</strong>
          </div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 48 }}>
            {[
              { label: "CONTRATADO — VANGUARD TECH", nome: "Eduardo" },
              { label: "CLIENTE — AVALIADOR", nome: meta.cliente || "" },
            ].map((s, i) => (
              <div key={i}>
                <div style={{ height: 48, borderBottom: "1px solid rgba(255,255,255,0.4)", marginBottom: 8 }} />
                <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2, marginBottom: 4 }}>{s.label}</div>
                <div style={{ ...serif, fontStyle: "italic", fontSize: 13, color: "rgba(255,255,255,0.4)", marginBottom: 16 }}>{s.nome}</div>
                <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.25)", marginBottom: 4 }}>DATA</div>
                <div style={{ borderBottom: "1px solid rgba(255,255,255,0.15)", paddingBottom: 6, color: "rgba(255,255,255,0.3)", ...serif, fontSize: 13, width: 140 }}>___/___/______</div>
              </div>
            ))}
          </div>
        </div>

      </div>

      {/* FOOTER */}
      <div style={{ borderTop: "1px solid rgba(201,168,76,0.1)", padding: "14px 32px", display: "flex", justifyContent: "space-between" }}>
        <div style={{ ...mono, fontSize: 10, color: "rgba(255,255,255,0.2)", letterSpacing: 1 }}>VANGUARD TECH · CRONOGRAMA DE ENTREGA · ENTREGUE NO INÍCIO DO PROJETO</div>
        <div style={{ ...mono, fontSize: 10, color: "rgba(255,255,255,0.2)", letterSpacing: 1 }}>ARQUIVAR JUNTO AO CONTRATO</div>
      </div>
    </div>
  );
}

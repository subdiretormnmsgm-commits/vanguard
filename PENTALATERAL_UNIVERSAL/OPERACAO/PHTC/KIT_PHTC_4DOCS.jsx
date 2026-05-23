import { useState } from "react";

// ─── SHARED STYLES ───────────────────────────────────────────────────────────
const C = {
  navy: "#0D1B2A", navyMid: "#1A2E45", navyLight: "#243B55",
  gold: "#C9A84C", goldLight: "#E2C47A", goldPale: "#F5EDD6",
  cream: "#FAF7F2", text: "#1A1A1A", muted: "#5A5A5A",
  rule: "#D4C4A0", red: "#8B1A1A", green: "#1A4A2E", greenLight: "#2D6B47",
};

const mono = { fontFamily: "monospace" };
const serif = { fontFamily: "'Georgia', serif" };

// ─── DOCUMENT 1: RELATÓRIO DE TESTES ─────────────────────────────────────────
const TEST_ITEMS = [
  { id: 1, label: "Deploy em produção", detail: "Confirmar que o sistema está no ambiente final — não localhost, não staging. URL anotada abaixo." },
  { id: 2, label: "Query de alta cobertura 1", detail: "Registrar: query exata · resultado obtido · latência (segundos) · score de similaridade" },
  { id: 3, label: "Query de alta cobertura 2", detail: "Registrar: query exata · resultado obtido · latência (segundos) · score de similaridade" },
  { id: 4, label: "Query de alta cobertura 3", detail: "Registrar: query exata · resultado obtido · latência (segundos) · score de similaridade" },
  { id: 5, label: "Query de alta cobertura 4", detail: "Registrar: query exata · resultado obtido · latência (segundos) · score de similaridade" },
  { id: 6, label: "Query de alta cobertura 5", detail: "Registrar: query exata · resultado obtido · latência (segundos) · score de similaridade" },
  { id: 7, label: "Query de borda 1", detail: "Tema com corpus menor. Registrar resultado e comportamento de fallback (o sistema informou a limitação de forma clara?)" },
  { id: 8, label: "Query de borda 2", detail: "Tema com corpus menor. Registrar resultado e comportamento de fallback" },
  { id: 9, label: "Autenticação — acesso correto", detail: "Login com credencial válida do cliente. Registrar: funcionou na primeira tentativa? Tempo de resposta?" },
  { id: 10, label: "Autenticação — acesso negado", detail: "Tentativa com credencial inválida ou usuário não autorizado. O sistema bloqueou corretamente?" },
  { id: 11, label: "Output / citação — formato e acurácia", detail: "Verificar em mínimo 3 resultados distintos: formato correto, dados completos, sem truncamento" },
  { id: 12, label: "Dispositivo equivalente ao do cliente", detail: "Smartphone ou tablet — não o computador da equipe. Anotar modelo e OS abaixo." },
  { id: 13, label: "Rede externa (4G / hotspot)", detail: "Não usar a rede do ambiente de desenvolvimento. Registrar operadora ou hotspot utilizado." },
  { id: 14, label: "Evidências registradas", detail: "Prints ou logs datados de cada item aprovado. Arquivo ou pasta indicada abaixo." },
];

function Doc1() {
  const [items, setItems] = useState(() => TEST_ITEMS.reduce((a, i) => ({ ...a, [i.id]: { ok: null, nota: "" } }), {}));
  const [meta, setMeta] = useState({ projeto: "", cliente: "", url: "", dispositivo: "", rede: "", evidencias: "", data: "", testador: "" });
  const [gateDecision, setGateDecision] = useState(null);

  const allApproved = TEST_ITEMS.every(i => items[i.id].ok === true);
  const anyFailed = TEST_ITEMS.some(i => items[i.id].ok === false);

  const toggleItem = (id, val) => {
    setItems(prev => ({ ...prev, [id]: { ...prev[id], ok: prev[id].ok === val ? null : val } }));
  };
  const setNota = (id, val) => setItems(prev => ({ ...prev, [id]: { ...prev[id], nota: val } }));

  const done = TEST_ITEMS.filter(i => items[i.id].ok !== null).length;

  return (
    <div>
      <div style={{ background: C.navy, padding: "32px 36px 28px", borderBottom: `3px solid ${C.gold}`, marginBottom: 0 }}>
        <div style={{ ...mono, fontSize: 10, letterSpacing: 3, color: C.gold, marginBottom: 10 }}>
          VANGUARD TECH · PHTC · DOCUMENTO 1 DE 4
        </div>
        <div style={{ ...serif, fontSize: 24, fontWeight: 700, color: "#fff", marginBottom: 4 }}>
          Relatório de Testes — Fase 1
        </div>
        <div style={{ ...serif, fontStyle: "italic", color: "rgba(255,255,255,0.45)", fontSize: 14 }}>
          Homologação Interna · Preenchido pela equipe antes de qualquer contato com o cliente
        </div>
        <div style={{ marginTop: 16, display: "flex", gap: 24, flexWrap: "wrap" }}>
          {[
            { label: "ITENS AVALIADOS", val: `${done} / ${TEST_ITEMS.length}` },
            { label: "APROVADOS", val: TEST_ITEMS.filter(i => items[i.id].ok === true).length },
            { label: "REPROVADOS", val: TEST_ITEMS.filter(i => items[i.id].ok === false).length },
            { label: "STATUS", val: allApproved ? "GATE VERDE" : anyFailed ? "GATE VERMELHO" : "EM PROGRESSO" },
          ].map((s, i) => (
            <div key={i}>
              <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2 }}>{s.label}</div>
              <div style={{ ...mono, fontSize: 16, fontWeight: 700, color: s.label === "STATUS" ? (allApproved ? "#7EC8A0" : anyFailed ? "#F87171" : C.gold) : C.goldLight, marginTop: 2 }}>{s.val}</div>
            </div>
          ))}
        </div>
      </div>

      <div style={{ background: C.navyMid, padding: "20px 36px", display: "grid", gridTemplateColumns: "1fr 1fr 1fr 1fr", gap: 16 }}>
        {[
          { key: "projeto", label: "PROJETO" },
          { key: "cliente", label: "CLIENTE" },
          { key: "url", label: "URL DE PRODUÇÃO" },
          { key: "testador", label: "TESTADO POR" },
          { key: "dispositivo", label: "DISPOSITIVO (modelo/OS)" },
          { key: "rede", label: "REDE UTILIZADA" },
          { key: "evidencias", label: "PASTA DE EVIDÊNCIAS" },
          { key: "data", label: "DATA DO TESTE" },
        ].map(f => (
          <div key={f.key}>
            <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.4)", letterSpacing: 2, marginBottom: 4 }}>{f.label}</div>
            <input
              value={meta[f.key]}
              onChange={e => setMeta(p => ({ ...p, [f.key]: e.target.value }))}
              placeholder="—"
              style={{ width: "100%", background: "rgba(255,255,255,0.07)", border: "1px solid rgba(255,255,255,0.12)", padding: "6px 10px", color: "#fff", fontSize: 13, ...mono, outline: "none", borderRadius: 3 }}
            />
          </div>
        ))}
      </div>

      <div style={{ padding: "24px 36px" }}>
        {TEST_ITEMS.map((item, idx) => {
          const state = items[item.id];
          return (
            <div key={item.id} style={{
              background: state.ok === true ? "rgba(45,107,71,0.12)" : state.ok === false ? "rgba(139,26,26,0.1)" : idx % 2 === 0 ? "rgba(255,255,255,0.03)" : "transparent",
              border: `1px solid ${state.ok === true ? "rgba(126,200,160,0.3)" : state.ok === false ? "rgba(248,113,113,0.3)" : "rgba(255,255,255,0.06)"}`,
              borderRadius: 4, padding: "14px 16px", marginBottom: 8,
              transition: "all 0.2s",
            }}>
              <div style={{ display: "flex", alignItems: "flex-start", gap: 14 }}>
                <div style={{ ...mono, fontSize: 11, color: C.gold, opacity: 0.6, minWidth: 22, marginTop: 2 }}>
                  {String(item.id).padStart(2, "0")}
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 15, color: "#fff", fontWeight: 600, marginBottom: 3 }}>{item.label}</div>
                  <div style={{ fontSize: 13, color: "rgba(255,255,255,0.4)", lineHeight: 1.5 }}>{item.detail}</div>
                  <input
                    value={state.nota}
                    onChange={e => setNota(item.id, e.target.value)}
                    placeholder="Observação / resultado registrado..."
                    style={{ marginTop: 8, width: "100%", background: "rgba(255,255,255,0.05)", border: "1px solid rgba(255,255,255,0.08)", padding: "5px 10px", color: "rgba(255,255,255,0.7)", fontSize: 12, ...mono, outline: "none", borderRadius: 3 }}
                  />
                </div>
                <div style={{ display: "flex", gap: 6, flexShrink: 0 }}>
                  <button onClick={() => toggleItem(item.id, true)} style={{
                    background: state.ok === true ? "#2D6B47" : "rgba(45,107,71,0.2)",
                    border: `1px solid ${state.ok === true ? "#7EC8A0" : "rgba(126,200,160,0.3)"}`,
                    color: state.ok === true ? "#7EC8A0" : "rgba(126,200,160,0.5)",
                    padding: "6px 14px", cursor: "pointer", ...mono, fontSize: 11, borderRadius: 3, fontWeight: 700,
                    transition: "all 0.2s",
                  }}>✓ OK</button>
                  <button onClick={() => toggleItem(item.id, false)} style={{
                    background: state.ok === false ? "rgba(139,26,26,0.5)" : "rgba(139,26,26,0.15)",
                    border: `1px solid ${state.ok === false ? "#F87171" : "rgba(248,113,113,0.3)"}`,
                    color: state.ok === false ? "#F87171" : "rgba(248,113,113,0.5)",
                    padding: "6px 14px", cursor: "pointer", ...mono, fontSize: 11, borderRadius: 3, fontWeight: 700,
                    transition: "all 0.2s",
                  }}>✕ FALHA</button>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      <div style={{ padding: "0 36px 32px" }}>
        <div style={{
          background: allApproved ? "rgba(45,107,71,0.2)" : anyFailed ? "rgba(139,26,26,0.15)" : "rgba(255,255,255,0.04)",
          border: `1px solid ${allApproved ? "#7EC8A0" : anyFailed ? "#F87171" : "rgba(255,255,255,0.1)"}`,
          borderRadius: 6, padding: "20px 24px",
        }}>
          <div style={{ ...mono, fontSize: 10, letterSpacing: 3, color: allApproved ? "#7EC8A0" : anyFailed ? "#F87171" : C.gold, marginBottom: 10 }}>
            DECISÃO DO GATE — EXCLUSIVA DO DIRETOR
          </div>
          {anyFailed && !allApproved && (
            <div style={{ fontSize: 14, color: "#F87171", marginBottom: 16, lineHeight: 1.6 }}>
              ⚠ Itens reprovados identificados. O sistema retorna para engenharia. Nenhum contato sobre assinatura ou prazo com o cliente neste momento.
            </div>
          )}
          {allApproved && (
            <div style={{ fontSize: 14, color: "#7EC8A0", marginBottom: 16, lineHeight: 1.6 }}>
              ✓ Todos os itens aprovados. O Diretor pode liberar o avanço para a Fase 2 — envio do acesso ao cliente.
            </div>
          )}
          <div style={{ display: "flex", gap: 12, flexWrap: "wrap" }}>
            {["APROVADO — Liberar Fase 2", "REPROVADO — Retornar à Engenharia"].map((label, i) => (
              <button key={i} onClick={() => setGateDecision(i === 0 ? "ok" : "fail")} style={{
                background: gateDecision === (i === 0 ? "ok" : "fail")
                  ? (i === 0 ? "#2D6B47" : "rgba(139,26,26,0.6)")
                  : "rgba(255,255,255,0.05)",
                border: `1px solid ${gateDecision === (i === 0 ? "ok" : "fail") ? (i === 0 ? "#7EC8A0" : "#F87171") : "rgba(255,255,255,0.15)"}`,
                color: gateDecision === (i === 0 ? "ok" : "fail") ? "#fff" : "rgba(255,255,255,0.4)",
                padding: "10px 20px", cursor: "pointer", ...mono, fontSize: 11, letterSpacing: 1, borderRadius: 4,
                transition: "all 0.2s",
              }}>{label}</button>
            ))}
          </div>
          {gateDecision && (
            <div style={{ marginTop: 16, display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16 }}>
              {[{ label: "ASSINATURA DO DIRETOR", ph: "Eduardo —" }, { label: "DATA / HORA", ph: "___/___/____  ____:____" }].map((f, i) => (
                <div key={i}>
                  <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2, marginBottom: 4 }}>{f.label}</div>
                  <div style={{ borderBottom: "1px solid rgba(255,255,255,0.2)", paddingBottom: 8, color: "rgba(255,255,255,0.6)", fontSize: 14, ...serif, fontStyle: "italic" }}>{f.ph}</div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

// ─── DOCUMENT 2: TERMO DE POC ────────────────────────────────────────────────
function Doc2() {
  const [fields, setFields] = useState({
    cliente: "", oab: "", produto: "", dias: "", inicio: "", fim: "",
    criterio: "", diretor: "", dataDir: "", dataCliente: "",
  });
  const set = (k, v) => setFields(p => ({ ...p, [k]: v }));

  const Field = ({ label, k, placeholder = "—", wide = false }) => (
    <div style={{ gridColumn: wide ? "1 / -1" : "auto" }}>
      <div style={{ ...mono, fontSize: 9, color: C.muted, letterSpacing: 2, marginBottom: 4, textTransform: "uppercase" }}>{label}</div>
      <input
        value={fields[k]}
        onChange={e => set(k, e.target.value)}
        placeholder={placeholder}
        style={{ width: "100%", background: C.goldPale, border: `1px solid ${C.rule}`, borderBottom: `2px solid ${C.navy}`, padding: "8px 10px", fontSize: 14, ...serif, outline: "none", color: C.text }}
      />
    </div>
  );

  return (
    <div style={{ background: C.cream, color: C.text, ...serif }}>
      <div style={{ background: C.navy, padding: "36px 48px 28px", position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", top: 0, left: 0, right: 0, height: 3, background: `linear-gradient(90deg, ${C.gold}, ${C.goldLight}, ${C.gold})` }} />
        <div style={{ ...mono, fontSize: 9, letterSpacing: 4, color: C.gold, marginBottom: 12 }}>VANGUARD TECH · PHTC · DOCUMENTO 2 DE 4</div>
        <div style={{ ...serif, fontSize: 26, fontWeight: 700, color: "#fff", marginBottom: 4 }}>Termo de Prova de Conceito</div>
        <div style={{ ...serif, fontStyle: "italic", color: "rgba(255,255,255,0.4)", fontSize: 14 }}>Acesso restrito ao período de homologação · Não substitui o contrato definitivo</div>
      </div>

      <div style={{ padding: "28px 48px" }}>
        <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 14, borderBottom: `1px solid ${C.rule}`, paddingBottom: 8 }}>DADOS DO TESTE</div>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 24 }}>
          <Field label="Nome completo do avaliador" k="cliente" placeholder="Nome do cliente" />
          <Field label="OAB / Registro profissional" k="oab" placeholder="OAB/XX 000000 (se aplicável)" />
          <Field label="Produto em avaliação" k="produto" placeholder="Nome do produto" />
          <Field label="Duração do acesso (dias)" k="dias" placeholder="ex: 3 dias" />
          <Field label="Data de início" k="inicio" placeholder="___/___/______" />
          <Field label="Data de término" k="fim" placeholder="___/___/______" />
          <Field label="Critério de aprovação" k="criterio" placeholder="Descreva o resultado que constitui aprovação..." wide />
        </div>

        {[
          {
            num: "1", title: "OBJETO E DURAÇÃO",
            body: `A Vanguard Tech concede ao Avaliador ${fields.cliente || "[NOME DO AVALIADOR]"} acesso temporário à ferramenta "${fields.produto || "[NOME DO PRODUTO]"}" pelo período de ${fields.dias || "[X]"} dias corridos, com início em ${fields.inicio || "___/___/______"} e término em ${fields.fim || "___/___/______"}, exclusivamente para fins de avaliação e homologação.`,
          },
          {
            num: "2", title: "RESTRIÇÕES DE USO",
            body: "Durante o período de PoC, é vedado: (a) uso produtivo sistemático em substituição permanente de ferramentas já em uso; (b) compartilhamento do acesso com terceiros; (c) extração, cópia ou reprodução do código, dados ou lógica da ferramenta. O acesso será revogado ao término do período ou imediatamente em caso de descumprimento.",
          },
          {
            num: "3", title: "PROPRIEDADE INTELECTUAL",
            body: "A ferramenta permanece de propriedade exclusiva da Vanguard Tech durante e após o período de PoC. Nenhuma cessão de direitos ocorre com este Termo. A transferência de propriedade está condicionada à assinatura do contrato definitivo e quitação integral do valor acordado.",
          },
          {
            num: "4", title: "CRITÉRIO DE APROVAÇÃO",
            body: `O PoC é considerado aprovado quando o Avaliador confirmar, por escrito, que a ferramenta ${fields.criterio || "[CRITÉRIO DEFINIDO ACIMA]"}, operando de forma estável no dispositivo e rede de uso habitual do Avaliador. O silêncio do Avaliador ao término do prazo equivale à não-aprovação e o acesso será revogado automaticamente.`,
          },
          {
            num: "5", title: "NÃO-OBRIGATORIEDADE DE CONTRATAÇÃO",
            body: "A assinatura deste Termo não obriga o Avaliador à contratação definitiva. Em caso de não-aprovação fundamentada, o acesso é revogado sem ônus para nenhuma das partes.",
          },
          {
            num: "6", title: "CONFIDENCIALIDADE",
            body: "O Avaliador compromete-se a manter em sigilo as informações técnicas, arquiteturais e metodológicas da ferramenta observadas durante o período de PoC, durante o prazo mínimo de 2 (dois) anos.",
          },
        ].map(cl => (
          <div key={cl.num} style={{ marginBottom: 20, padding: "16px 20px", background: "#fff", border: `1px solid ${C.rule}`, borderLeft: `3px solid ${C.navy}` }}>
            <div style={{ ...mono, fontSize: 10, color: C.navy, letterSpacing: 2, marginBottom: 8, fontWeight: 700 }}>CLÁUSULA {cl.num} — {cl.title}</div>
            <div style={{ fontSize: 14, color: C.text, lineHeight: 1.8 }}>{cl.body}</div>
          </div>
        ))}

        <div style={{ marginTop: 32, borderTop: `2px solid ${C.navy}`, paddingTop: 24 }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 20 }}>ASSINATURAS</div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 40 }}>
            {[
              { label: "CONTRATADO", sub: "Eduardo — Vanguard Tech" },
              { label: "AVALIADOR", sub: fields.cliente || "[NOME DO AVALIADOR]" },
            ].map((s, i) => (
              <div key={i}>
                <div style={{ height: 48, borderBottom: `1px solid ${C.text}`, marginBottom: 8 }} />
                <div style={{ ...mono, fontSize: 10, color: C.muted, marginBottom: 4 }}>{s.label}</div>
                <div style={{ ...serif, fontStyle: "italic", fontSize: 13, color: C.muted, marginBottom: 12 }}>{s.sub}</div>
                <div style={{ ...mono, fontSize: 9, color: C.muted, marginBottom: 4 }}>DATA</div>
                <div style={{ borderBottom: `1px solid ${C.rule}`, paddingBottom: 6, ...serif, color: C.muted, fontSize: 13 }}>___/___/______</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

// ─── DOCUMENT 3: SCRIPT DE ENVIO — FASE 2 ────────────────────────────────────
const CANAIS = ["WhatsApp", "E-mail", "Presencial"];
const NICHOS = ["Advocacia", "Saúde", "Contabilidade", "Concursos", "Outro"];

function Doc3() {
  const [canal, setCanal] = useState("WhatsApp");
  const [nicho, setNicho] = useState("Advocacia");
  const [fields, setFields] = useState({ nome: "", url: "", produto: "", dias: "48", remetente: "Eduardo" });
  const [copied, setCopied] = useState(false);
  const set = (k, v) => setFields(p => ({ ...p, [k]: v }));

  const N = fields.nome || "[NOME]";
  const U = fields.url || "[URL DO PRODUTO]";
  const P = fields.produto || "[NOME DO PRODUTO]";
  const D = fields.dias || "48";
  const R = fields.remetente || "Eduardo";

  const nichoLine = {
    "Advocacia": "um caso real que você está trabalhando agora — qualquer tema da sua área",
    "Saúde": "um protocolo ou situação clínica real do seu dia a dia",
    "Contabilidade": "uma consulta ou normativa que você precisou verificar recentemente",
    "Concursos": "uma disciplina ou tema da sua prova que você está revisando agora",
    "Outro": "uma situação real do seu trabalho atual",
  }[nicho];

  const SCRIPTS = {
    WhatsApp: `${N}, tudo bem?\n\nAntes de formalizarmos, quero que você teste o ${P} no seu celular — com um caso real, sem filtro.\n\nAcessa aqui: ${U}\n\nTesta 2 ou 3 buscas usando ${nichoLine}. Me diz o que apareceu e o que achou.\n\nA gente só assina depois que você confirmar que está funcionando do jeito que você precisa.\n\nEstou disponível para qualquer dúvida. — ${R}`,
    "E-mail": `Assunto: ${P} — Acesso para você testar antes de qualquer formalidade\n\n${N},\n\nConforme conversamos, quero que você avalie a ferramenta no seu próprio ambiente antes de qualquer assinatura.\n\nAcesso: ${U}\n\nComo testar:\n1. Acesse o link pelo seu celular ou computador de uso diário\n2. Realize 2 ou 3 buscas usando ${nichoLine}\n3. Avalie: o resultado resolveu o que você precisava? Em quanto tempo?\n\nTenho ${D} horas de acesso reservadas para você. Após esse período, posso estender se necessário.\n\nSe encontrar qualquer inconsistência, me comunique antes de qualquer conclusão — posso ajustar.\n\nAguardo seu retorno.\n\n${R}\nVanguard Tech`,
    Presencial: `[ROTEIRO PARA USO NO MOMENTO DA REUNIÃO]\n\nAbertura:\n"${N}, antes de qualquer formalidade, quero que você teste a ferramenta aqui, no seu dispositivo."\n\nPasso 1 — Acesso:\nEnviar o link ${U} via WhatsApp para o dispositivo do cliente agora, na reunião.\n\nPasso 2 — Instrução mínima:\n"Pensa em ${nichoLine}. Digita no campo de busca."\n\nPasso 3 — Observação:\nNão interferir. Não explicar o resultado. Deixar o cliente processar sozinho.\n\nPasso 4 — Pergunta de validação:\n"Isso resolveu o que você precisava? Em quanto tempo apareceu?"\n\nSe resposta positiva → avançar para apresentação do contrato.\nSe dúvida ou falha → anotar, agradecer e comunicar que ajusta antes de formalizar.`,
  };

  const scriptText = SCRIPTS[canal];
  const copyToClipboard = () => {
    navigator.clipboard.writeText(scriptText).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  };

  return (
    <div>
      <div style={{ background: C.navy, padding: "32px 36px 28px", borderBottom: `3px solid ${C.gold}` }}>
        <div style={{ ...mono, fontSize: 10, letterSpacing: 3, color: C.gold, marginBottom: 10 }}>VANGUARD TECH · PHTC · DOCUMENTO 3 DE 4</div>
        <div style={{ ...serif, fontSize: 24, fontWeight: 700, color: "#fff", marginBottom: 4 }}>Script de Envio — Fase 2</div>
        <div style={{ ...serif, fontStyle: "italic", color: "rgba(255,255,255,0.4)", fontSize: 14 }}>Mensagem para o cliente antes da assinatura · Adaptar por canal e nicho</div>
      </div>

      <div style={{ background: C.navyMid, padding: "20px 36px" }}>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr 1fr 1fr 1fr", gap: 16 }}>
          {[
            { label: "NOME DO CLIENTE", k: "nome", ph: "Valdece" },
            { label: "URL DO PRODUTO", k: "url", ph: "https://...", span: 2 },
            { label: "NOME DO PRODUTO", k: "produto", ph: "Toga Digital" },
            { label: "HORAS DE ACESSO", k: "dias", ph: "48" },
            { label: "SEU NOME", k: "remetente", ph: "Eduardo" },
          ].map(f => (
            <div key={f.k} style={{ gridColumn: f.span ? `span ${f.span}` : "span 1" }}>
              <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.4)", letterSpacing: 2, marginBottom: 4 }}>{f.label}</div>
              <input value={fields[f.k]} onChange={e => set(f.k, e.target.value)} placeholder={f.ph}
                style={{ width: "100%", background: "rgba(255,255,255,0.08)", border: "1px solid rgba(255,255,255,0.12)", padding: "6px 10px", color: "#fff", fontSize: 13, ...mono, outline: "none", borderRadius: 3 }} />
            </div>
          ))}
        </div>
        <div style={{ display: "flex", gap: 24, marginTop: 20 }}>
          <div>
            <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.4)", letterSpacing: 2, marginBottom: 8 }}>CANAL</div>
            <div style={{ display: "flex", gap: 8 }}>
              {CANAIS.map(c => (
                <button key={c} onClick={() => setCanal(c)} style={{
                  background: canal === c ? `${C.gold}25` : "transparent",
                  border: `1px solid ${canal === c ? C.gold : "rgba(255,255,255,0.15)"}`,
                  color: canal === c ? C.gold : "rgba(255,255,255,0.4)",
                  padding: "6px 14px", cursor: "pointer", ...mono, fontSize: 11, borderRadius: 3,
                }}>{c}</button>
              ))}
            </div>
          </div>
          <div>
            <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.4)", letterSpacing: 2, marginBottom: 8 }}>NICHO DO CLIENTE</div>
            <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
              {NICHOS.map(n => (
                <button key={n} onClick={() => setNicho(n)} style={{
                  background: nicho === n ? "rgba(167,139,250,0.2)" : "transparent",
                  border: `1px solid ${nicho === n ? "#A78BFA" : "rgba(255,255,255,0.15)"}`,
                  color: nicho === n ? "#A78BFA" : "rgba(255,255,255,0.4)",
                  padding: "6px 14px", cursor: "pointer", ...mono, fontSize: 11, borderRadius: 3,
                }}>{n}</button>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div style={{ padding: "28px 36px" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 14 }}>
          <div style={{ ...mono, fontSize: 10, letterSpacing: 2, color: C.gold }}>MENSAGEM GERADA — {canal.toUpperCase()}</div>
          <button onClick={copyToClipboard} style={{
            background: copied ? "rgba(126,200,160,0.2)" : "rgba(201,168,76,0.15)",
            border: `1px solid ${copied ? "#7EC8A0" : C.gold}`,
            color: copied ? "#7EC8A0" : C.gold,
            padding: "7px 18px", cursor: "pointer", ...mono, fontSize: 11, borderRadius: 3,
            transition: "all 0.2s",
          }}>{copied ? "✓ COPIADO" : "COPIAR"}</button>
        </div>
        <div style={{
          background: "#0A1520", border: `1px solid rgba(201,168,76,0.2)`,
          borderLeft: `3px solid ${C.gold}`, borderRadius: 6, padding: "24px 28px",
          whiteSpace: "pre-line", fontSize: 15, lineHeight: 1.9, color: "rgba(255,255,255,0.85)",
          ...serif, fontStyle: "italic",
        }}>
          {scriptText}
        </div>
        <div style={{ marginTop: 20, background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.07)", borderLeft: "3px solid rgba(167,139,250,0.5)", borderRadius: 4, padding: "14px 18px" }}>
          <div style={{ ...mono, fontSize: 9, color: "#A78BFA", letterSpacing: 2, marginBottom: 8 }}>PROTOCOLO DE TIMING</div>
          <div style={{ fontSize: 13, color: "rgba(255,255,255,0.55)", lineHeight: 1.7 }}>
            Enviar com <strong style={{ color: "rgba(255,255,255,0.75)" }}>24 a 48 horas de antecedência</strong> ao presencial ou à reunião de assinatura. Nunca enviar e exigir retorno imediato. Se o cliente não testar no prazo, reagendar — não pular a fase.
          </div>
        </div>
      </div>
    </div>
  );
}

// ─── DOCUMENT 4: REGISTRO DE APROVAÇÃO DO GATE ───────────────────────────────
// NOTA: Este documento é preenchido pelo Músculo (Claude Code) após Eduardo
// relatar a resposta do cliente às 3 perguntas de validação.
// Eduardo informa: dispositivo, rede, respostas verbais/escritas, evidência.
// O Músculo preenche o initialState abaixo e gera o documento final.

export function gerarDoc4Preenchido({ cliente, projeto, produto, dispositivo, os, rede, canal, data, hora, q1, q2, q3, evidencia, gate }) {
  return { cliente, projeto, produto, dispositivo, os, rede, canal, data, hora, q1, q2, q3, obs: evidencia, gate };
}

function Doc4({ initialData = {} }) {
  const [fields, setFields] = useState({
    cliente: "", projeto: "", produto: "", dispositivo: "", os: "", rede: "",
    canal: "WhatsApp", data: "", hora: "", testador: "",
    q1: "", q2: "", q3: "", obs: "", gate: null,
    dirAssinatura: "", dirData: "",
    ...initialData,
  });
  const set = (k, v) => setFields(p => ({ ...p, [k]: v }));

  return (
    <div>
      <div style={{ background: C.navy, padding: "32px 36px 28px", borderBottom: `3px solid ${C.gold}` }}>
        <div style={{ ...mono, fontSize: 10, letterSpacing: 3, color: C.gold, marginBottom: 10 }}>VANGUARD TECH · PHTC · DOCUMENTO 4 DE 4</div>
        <div style={{ ...serif, fontSize: 24, fontWeight: 700, color: "#fff", marginBottom: 4 }}>Registro de Aprovação do Gate — Fase 2</div>
        <div style={{ ...serif, fontStyle: "italic", color: "rgba(255,255,255,0.4)", fontSize: 14 }}>Confirmação do cliente · Documento que protege o Diretor na assinatura do contrato</div>
        {Object.keys(initialData).length > 0 && (
          <div style={{ marginTop: 12, ...mono, fontSize: 10, color: "#7EC8A0", letterSpacing: 1 }}>
            ✓ PRÉ-PREENCHIDO PELO MÚSCULO — {initialData.data || ""}
          </div>
        )}
      </div>

      <div style={{ padding: "28px 36px" }}>
        <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 14, borderBottom: "1px solid rgba(255,255,255,0.1)", paddingBottom: 8 }}>1. IDENTIFICAÇÃO DO TESTE</div>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 14, marginBottom: 28 }}>
          {[
            { k: "cliente", label: "CLIENTE" }, { k: "projeto", label: "PROJETO" }, { k: "produto", label: "PRODUTO" },
            { k: "dispositivo", label: "DISPOSITIVO USADO" }, { k: "os", label: "SISTEMA / VERSÃO" }, { k: "rede", label: "REDE (Wi-Fi / 4G)" },
            { k: "canal", label: "CANAL DE CONFIRMAÇÃO" }, { k: "data", label: "DATA DO TESTE" }, { k: "hora", label: "HORÁRIO" },
          ].map(f => (
            <div key={f.k}>
              <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.35)", letterSpacing: 2, marginBottom: 4 }}>{f.label}</div>
              <input value={fields[f.k]} onChange={e => set(f.k, e.target.value)} placeholder="—"
                style={{ width: "100%", background: fields[f.k] ? "rgba(126,200,160,0.08)" : "rgba(255,255,255,0.06)", border: `1px solid ${fields[f.k] ? "rgba(126,200,160,0.3)" : "rgba(255,255,255,0.1)"}`, padding: "7px 10px", color: "#fff", fontSize: 13, ...mono, outline: "none", borderRadius: 3 }} />
            </div>
          ))}
        </div>

        <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 14, borderBottom: "1px solid rgba(255,255,255,0.1)", paddingBottom: 8 }}>2. VALIDAÇÃO VERBAL DO CLIENTE</div>
        <div style={{ fontSize: 13, color: "rgba(255,255,255,0.4)", marginBottom: 16, fontStyle: "italic" }}>
          Registre abaixo exatamente o que o cliente disse em resposta a cada pergunta — pode ser transcrição de áudio, print de mensagem ou nota manual.
        </div>

        {[
          { k: "q1", pergunta: "PERGUNTA 1", texto: "\"O sistema funcionou no seu dispositivo sem travar ou apresentar erro?\"" },
          { k: "q2", pergunta: "PERGUNTA 2", texto: "\"O resultado que apareceu resolveu o que você precisava?\"" },
          { k: "q3", pergunta: "PERGUNTA 3", texto: "\"Isso é o que você esperava quando pediu esta ferramenta?\"" },
        ].map(q => (
          <div key={q.k} style={{ marginBottom: 16, background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.07)", borderRadius: 6, padding: "16px 18px" }}>
            <div style={{ ...mono, fontSize: 9, color: "#A78BFA", letterSpacing: 2, marginBottom: 4 }}>{q.pergunta}</div>
            <div style={{ ...serif, fontStyle: "italic", fontSize: 14, color: "rgba(255,255,255,0.6)", marginBottom: 10 }}>{q.texto}</div>
            <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2, marginBottom: 4 }}>RESPOSTA DO CLIENTE</div>
            <textarea value={fields[q.k]} onChange={e => set(q.k, e.target.value)} placeholder="Transcrição ou resumo fiel da resposta..."
              rows={2} style={{ width: "100%", background: fields[q.k] ? "rgba(126,200,160,0.08)" : "rgba(255,255,255,0.06)", border: `1px solid ${fields[q.k] ? "rgba(126,200,160,0.3)" : "rgba(255,255,255,0.1)"}`, padding: "8px 10px", color: "#fff", fontSize: 13, ...serif, outline: "none", borderRadius: 3, resize: "vertical" }} />
          </div>
        ))}

        <div style={{ marginBottom: 28 }}>
          <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.35)", letterSpacing: 2, marginBottom: 4 }}>EVIDÊNCIA ANEXADA (print, áudio, e-mail, link)</div>
          <textarea value={fields.obs} onChange={e => set("obs", e.target.value)} placeholder="Descreva ou cole o link da evidência. Ex: 'Print do WhatsApp às 14h32 — pasta PROJ-001/F2'" rows={2}
            style={{ width: "100%", background: fields.obs ? "rgba(126,200,160,0.08)" : "rgba(255,255,255,0.06)", border: `1px solid ${fields.obs ? "rgba(126,200,160,0.3)" : "rgba(255,255,255,0.1)"}`, padding: "8px 10px", color: "#fff", fontSize: 13, ...mono, outline: "none", borderRadius: 3, resize: "vertical" }} />
        </div>

        <div style={{ ...mono, fontSize: 9, letterSpacing: 3, color: C.gold, marginBottom: 14, borderBottom: "1px solid rgba(255,255,255,0.1)", paddingBottom: 8 }}>3. DECISÃO DO GATE — DIRETOR</div>

        <div style={{ display: "flex", gap: 12, marginBottom: 20 }}>
          {[
            { val: "ok", label: "✓  GATE APROVADO — Agendar apresentação do contrato", color: "#7EC8A0", bg: "rgba(45,107,71,0.2)" },
            { val: "fail", label: "✕  GATE REPROVADO — Corrigir antes de qualquer formalidade", color: "#F87171", bg: "rgba(139,26,26,0.15)" },
          ].map(g => (
            <button key={g.val} onClick={() => set("gate", g.val)} style={{
              flex: 1, padding: "14px 20px", cursor: "pointer", ...mono, fontSize: 11, letterSpacing: 1, borderRadius: 4,
              background: fields.gate === g.val ? g.bg : "rgba(255,255,255,0.04)",
              border: `1px solid ${fields.gate === g.val ? g.color : "rgba(255,255,255,0.1)"}`,
              color: fields.gate === g.val ? g.color : "rgba(255,255,255,0.35)",
              transition: "all 0.2s", textAlign: "left",
            }}>{g.label}</button>
          ))}
        </div>

        {fields.gate && (
          <div style={{
            background: fields.gate === "ok" ? "rgba(45,107,71,0.12)" : "rgba(139,26,26,0.1)",
            border: `1px solid ${fields.gate === "ok" ? "rgba(126,200,160,0.3)" : "rgba(248,113,113,0.3)"}`,
            borderRadius: 6, padding: "20px 24px",
          }}>
            <div style={{ fontSize: 14, color: fields.gate === "ok" ? "#7EC8A0" : "#F87171", lineHeight: 1.7, marginBottom: 20, ...serif, fontStyle: "italic" }}>
              {fields.gate === "ok"
                ? `Cliente ${fields.cliente || "[NOME]"} confirmou funcionamento da ferramenta "${fields.produto || "[PRODUTO]"}" no dispositivo próprio e em rede real. As 3 perguntas de validação foram respondidas positivamente. O Diretor está autorizado a apresentar o contrato definitivo.`
                : `Gate reprovado. O sistema retorna para engenharia. Nenhuma apresentação de contrato, discussão de prazo ou valor será realizada com o cliente até a correção e novo ciclo de validação.`
              }
            </div>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 16 }}>
              {[
                { label: "ASSINATURA DO DIRETOR", ph: "Eduardo —" },
                { label: "DATA", ph: "___/___/______" },
                { label: "HORA", ph: "____:____" },
              ].map((f, i) => (
                <div key={i}>
                  <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.3)", letterSpacing: 2, marginBottom: 4 }}>{f.label}</div>
                  <div style={{ borderBottom: "1px solid rgba(255,255,255,0.2)", paddingBottom: 8, color: "rgba(255,255,255,0.5)", ...serif, fontStyle: "italic", fontSize: 14 }}>{f.ph}</div>
                </div>
              ))}
            </div>
          </div>
        )}

        <div style={{ marginTop: 24, background: "rgba(255,255,255,0.02)", border: "1px solid rgba(255,255,255,0.06)", borderRadius: 4, padding: "12px 16px" }}>
          <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.25)", letterSpacing: 2, marginBottom: 6 }}>VALIDADE DOCUMENTAL</div>
          <div style={{ fontSize: 12, color: "rgba(255,255,255,0.35)", lineHeight: 1.6 }}>
            Este registro, quando preenchido e assinado, documenta que o cliente validou o funcionamento do produto antes da assinatura do contrato definitivo. Arquivar junto ao contrato assinado como parte do processo de entrega. A evidência anexada (campo 2) é o elemento probatório primário.
          </div>
        </div>
      </div>
    </div>
  );
}

// ─── MAIN ─────────────────────────────────────────────────────────────────────
const DOCS = [
  { id: 1, label: "Relatório de Testes", sub: "Fase 1 — Interno", color: "#C9A84C", component: Doc1 },
  { id: 2, label: "Termo de PoC", sub: "Acesso do Cliente", color: "#7EC8A0", component: Doc2 },
  { id: 3, label: "Script de Envio", sub: "Fase 2 — Mensagem", color: "#A78BFA", component: Doc3 },
  { id: 4, label: "Registro de Aprovação", sub: "Gate Final", color: "#F472B6", component: Doc4 },
];

export default function App() {
  const [active, setActive] = useState(1);
  const doc = DOCS.find(d => d.id === active);
  const Component = doc.component;

  return (
    <div style={{ minHeight: "100vh", background: "#080F18", ...serif }}>
      <div style={{ background: "#050A10", borderBottom: "1px solid rgba(201,168,76,0.2)", padding: "24px 32px" }}>
        <div style={{ maxWidth: 860, margin: "0 auto" }}>
          <div style={{ ...mono, fontSize: 9, letterSpacing: 4, color: C.gold, marginBottom: 8 }}>VANGUARD TECH · KIT PHTC · 4 DOCUMENTOS OPERACIONAIS</div>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-end", flexWrap: "wrap", gap: 16 }}>
            <div>
              <h1 style={{ fontSize: 26, fontWeight: 700, color: "#fff", margin: 0 }}>Kit de Homologação</h1>
              <div style={{ fontSize: 14, color: "rgba(255,255,255,0.35)", marginTop: 4, fontStyle: "italic" }}>Protocolo PHTC · Fase Pré-Contrato · P-046</div>
            </div>
            <div style={{ display: "flex", gap: 8 }}>
              {DOCS.map(d => (
                <button key={d.id} onClick={() => setActive(d.id)} style={{
                  background: active === d.id ? `${d.color}18` : "rgba(255,255,255,0.03)",
                  border: `1px solid ${active === d.id ? d.color : "rgba(255,255,255,0.08)"}`,
                  borderTop: active === d.id ? `3px solid ${d.color}` : "3px solid transparent",
                  borderRadius: 4, padding: "10px 16px", cursor: "pointer", textAlign: "left",
                  transition: "all 0.2s", minWidth: 120,
                }}>
                  <div style={{ ...mono, fontSize: 9, color: d.color, letterSpacing: 1, marginBottom: 3 }}>DOC {d.id}</div>
                  <div style={{ fontSize: 12, color: active === d.id ? "#fff" : "rgba(255,255,255,0.4)", fontWeight: active === d.id ? 700 : 400 }}>{d.label}</div>
                  <div style={{ ...mono, fontSize: 9, color: "rgba(255,255,255,0.25)", marginTop: 2 }}>{d.sub}</div>
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div style={{ maxWidth: 860, margin: "0 auto", padding: "0 0 60px" }}>
        <Component />
      </div>

      <div style={{ borderTop: "1px solid rgba(201,168,76,0.1)", padding: "14px 32px", display: "flex", justifyContent: "center", gap: 40 }}>
        {DOCS.map((d, i) => (
          <div key={d.id} style={{ display: "flex", alignItems: "center", gap: i < DOCS.length - 1 ? 40 : 0 }}>
            <div style={{ textAlign: "center" }}>
              <div style={{ ...mono, fontSize: 9, color: active === d.id ? d.color : "rgba(255,255,255,0.2)", letterSpacing: 1 }}>DOC {d.id}</div>
              <div style={{ fontSize: 11, color: active === d.id ? "#fff" : "rgba(255,255,255,0.2)", marginTop: 2 }}>{d.label}</div>
            </div>
            {i < DOCS.length - 1 && <div style={{ ...mono, fontSize: 12, color: "rgba(255,255,255,0.1)", margin: "0 0 0 40px" }}>→</div>}
          </div>
        ))}
      </div>
    </div>
  );
}

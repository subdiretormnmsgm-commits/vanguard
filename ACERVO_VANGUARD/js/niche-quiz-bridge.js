// Ponte porta-de-entrada: lê ?nicho=<slug> da URL e publica window.VG_ENTRADA para o quiz.
// Porta orgânica (sem ?nicho) -> origem 'organico', DNA Ingrid/Valdece intacto.
// Porta de inteligência (?nicho válido) -> marca o documento p/ o quiz mirar a dor do nicho.
import { resolveEntrada } from './lib/niche-public.js';

const entrada = resolveEntrada(window.location.search);
// porta ('organica' | 'inteligencia') fica publicada aqui para quem precisar diferenciar a entrada
// (quiz.js lê origem/nicho; a V2 quiz-por-nicho lerá .porta). Sem hook DOM enquanto nada o consome.
window.VG_ENTRADA = { nicho: entrada.nicho, origem: entrada.origem, porta: entrada.porta };

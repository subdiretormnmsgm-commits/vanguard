// fix_wip_board.js - Corrige aspas tipograficas e stray \r no WIP_BOARD.json
const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, '..', 'CLIENTES', 'WIP_BOARD.json');
let content = fs.readFileSync(filePath, 'utf8');
const hasBOM = content.charCodeAt(0) === 0xFEFF;
let text = hasBOM ? content.slice(1) : content;

// Normalize line endings
text = text.replace(/\r\n/g, '\n').replace(/\r/g, '\n');

const CURLY_OPEN  = '“';  // " left double quotation mark
const CURLY_CLOSE = '”';  // " right double quotation mark
const STRAIGHT    = '"';  // " standard double quote

const lines = text.split('\n');

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  if (!line.includes('loop_atual')) continue;

  // Build char array for surgical replacement
  let chars = [...line];

  // Find all positions with curly quotes
  const curlies = [];
  for (let j = 0; j < chars.length; j++) {
    if (chars[j] === CURLY_OPEN || chars[j] === CURLY_CLOSE) {
      curlies.push({ pos: j, char: chars[j] });
    }
  }

  // The mojibake em-dash pattern is: U+00E2 U+20AC U+201D
  // We need to identify which U+201D are part of mojibake vs JSON delimiters
  // Mojibake: preceded by U+20AC (euro sign, U+20AC)
  const mojibakePositions = new Set();
  for (let j = 1; j < chars.length; j++) {
    if (chars[j] === CURLY_CLOSE && chars[j-1] === '€') {
      mojibakePositions.add(j);
    }
  }

  // Replace curly quotes that are NOT part of mojibake
  let changed = false;
  for (const { pos, char } of curlies) {
    if (!mojibakePositions.has(pos)) {
      chars[pos] = STRAIGHT;
      changed = true;
      console.log('Line', i+1, 'pos', pos, ':', char === CURLY_OPEN ? 'open->straight' : 'close->straight');
    } else {
      console.log('Line', i+1, 'pos', pos, ': SKIPPED (mojibake)');
    }
  }

  if (changed) {
    lines[i] = chars.join('');
  }
}

let result = lines.join('\n');
if (hasBOM) result = '﻿' + result;

// Validate
try {
  const testStr = hasBOM ? result.slice(1) : result;
  JSON.parse(testStr);
  console.log('\nJSON VALIDO apos correcao');
  fs.writeFileSync(filePath, result, 'utf8');
  console.log('Arquivo salvo:', filePath);
} catch(e) {
  console.log('\nINVALIDO:', e.message);
  const lines2 = (hasBOM ? result.slice(1) : result).split('\n');
  const match = e.message.match(/line (\d+)/);
  if (match) {
    const ln = parseInt(match[1]);
    const lineContent = lines2[ln-1] || '';
    // Show chars around the error
    const colMatch = e.message.match(/column (\d+)/);
    const col = colMatch ? parseInt(colMatch[1]) - 1 : 0;
    for (let k = Math.max(0, col-5); k < Math.min(lineContent.length, col+10); k++) {
      const code = lineContent.charCodeAt(k);
      console.log('  col', k+1, ':', 'U+' + code.toString(16).toUpperCase().padStart(4,'0'), lineContent[k]);
    }
  }
  process.exit(1);
}

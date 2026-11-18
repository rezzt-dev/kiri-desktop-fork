// Contrast: every text colour on :root reads at 4.5:1 or better (WCAG 2.x, AA
// for text) on every surface it's drawn on, in the dark theme and the light
// one; the primary button's words on its ink too; the consoles' colours on the
// console. Both themes are read from the sheet itself (:root and the
// prefers-color-scheme: light block), so one run checks both whatever the
// system's scheme. --deco (#585858 in the palette) is for what isn't read and
// isn't checked.
const R = [];
const t = (name, fn) => { try { fn(); R.push("PASS " + name); } catch (e) { R.push("FAIL " + name + ": " + e.message); } };
const eq = (a, b, m) => { if (JSON.stringify(a) !== JSON.stringify(b)) throw new Error(m + ": got " + JSON.stringify(a) + " want " + JSON.stringify(b)); };

// The tokens a rule sets, as written (hex only: the rest are mixes of these).
const tokens = (rule) => { const out = {}; for (const p of rule.style) if (p.startsWith("--")) out[p] = rule.style.getPropertyValue(p).trim(); return out; };
let dark = null, light = null;
for (const sheet of document.styleSheets) for (const r of sheet.cssRules) {
  if (!dark && r.selectorText === ":root" && r.style.getPropertyValue("--bg")) dark = tokens(r);
  if (!light && r.media?.mediaText === "(prefers-color-scheme: light)")
    for (const inner of r.cssRules) if (inner.selectorText === ":root" && inner.style.getPropertyValue("--bg")) light = { ...dark, ...tokens(inner) };
}
const lum = (hex) => {
  const m = /^#([0-9a-f]{6})$/i.exec(hex);
  if (!m) throw new Error(`not a hex colour: ${hex}`);
  const c = [0, 2, 4].map((i) => parseInt(m[1].slice(i, i + 2), 16) / 255).map((x) => (x <= 0.03928 ? x / 12.92 : ((x + 0.055) / 1.055) ** 2.4));
  return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2];
};
const ratio = (a, b) => { const [x, y] = [lum(a), lum(b)].sort((p, q) => q - p); return (x + 0.05) / (y + 0.05); };
const below = (theme, fgs, bgs, min) => {
  const out = [];
  for (const f of fgs) for (const b of bgs) { const r = ratio(theme[f], theme[b]); if (r < min) out.push(`${f} on ${b}: ${r.toFixed(2)}`); }
  return out;
};
const TEXT = ["--text", "--muted", "--faint", "--red-text", "--sun-text", "--moss-text", "--ext-text"];
const SURFACES = ["--bg", "--side", "--panel", "--raised", "--field"];
t("both themes are in the sheet", () => eq([!!dark, !!light], [true, true], "dark :root and light :root"));
for (const [name, theme] of [["dark", dark], ["light", light]]) {
  t(`${name}: text reads on every surface`, () => eq(below(theme, TEXT, SURFACES, 4.5), [], "under 4.5:1"));
  t(`${name}: the primary button's words on its ink`, () => eq(below(theme, ["--ink-on"], ["--ink"], 4.5), [], "under 4.5:1"));
  t(`${name}: the consoles' colours on the console`, () =>
    eq(below(theme, ["--console-fg", "--console-mid", "--console-dim", "--console-err", "--console-warn", "--console-info", "--console-prompt"], ["--console-bg"], 4.5), [], "under 4.5:1"));
}
t("the faint text is the palette's step up, not its #585858", () => eq([dark["--faint"] !== "#585858", dark["--deco"]], [true, "#585858"], "faint and deco"));
report(R);

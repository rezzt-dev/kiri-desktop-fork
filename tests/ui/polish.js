// Details from the UI audit (.docs/agent-docs/ui-ux-audit.md): each one a thing that
// was wrong once.
const R = [];
const t = (name, fn) => { try { fn(); R.push("PASS " + name); } catch (e) { R.push("FAIL " + name + ": " + e.message); } };
const need = (c, m) => { if (!c) throw new Error(m); };
const box = (el) => el.getBoundingClientRect();
const wait = (ms) => new Promise((r) => setTimeout(r, ms));
const ta = async (name, fn) => { try { await fn(); R.push("PASS " + name); } catch (e) { R.push("FAIL " + name + ": " + e.message); } };
(async () => {

t("Share's title counts a link still opening apart from the live ones", () => {
  show("share");
  render();
  // The fixture: web and api live, postgres connecting.
  need($("subtitle").textContent === "2 live, 1 starting", "subtitle reads " + JSON.stringify($("subtitle").textContent));
});

await ta("a container's Shared button has one light, on the globe", async () => {
  show("containers");
  openDetail("a1");
  await wait(300);
  const b = document.querySelector(".sh-ico.lbl.live");
  need(b, "no Shared button");
  const a = getComputedStyle(b, "::after"), p = getComputedStyle(b, "::before");
  need(a.left === p.left && a.top === p.top, `light at ${a.left},${a.top}, its pulse at ${p.left},${p.top}`);
  closeDetail();
});

t("every dismiss (×) is a 24 px square", () => {
  toast("error", "Could not do the thing");
  shModal(1);
  const xs = [...document.querySelectorAll(".toast .tclose, .sh-x")];
  need(xs.length >= 2, "found " + xs.length);
  for (const x of xs) need(Math.round(box(x).width) === 24 && Math.round(box(x).height) === 24, `${x.className} is ${box(x).width}×${box(x).height}`);
  document.querySelectorAll(".scrim").forEach((s) => s.remove());
  document.querySelector("#sh-modal")?.remove();
});

await ta("toasts sit over the status bar and above a card that's showing", async () => {
  // Headless frames don't run transitions on virtual time: the stack moves at once here.
  $("toasts").style.transition = "none";
  const bar = box($("statusbar"));
  const last = () => [...document.querySelectorAll("#toasts .toast")].at(-1);
  await wait(400);
  need(box(last()).bottom <= bar.top, `toast bottom ${box(last()).bottom}, bar top ${bar.top}`);
  ctx.card = { from: "orbstack", total: 0, done: 0, failed: 0, finished: false };
  drawCtxCard();
  cornerLift();
  await wait(400);
  const card = box($("ctxcard"));
  need(card.height > 0, "no card");
  need(box(last()).bottom <= card.top, `toast bottom ${box(last()).bottom}, card top ${card.top}`);
  ctx.card = null;
  drawCtxCard();
  cornerLift();
});

t("Settings' lists are the same box as Language's button", () => {
  show("settings");
  render();
  const lang = document.querySelector(".lpick");
  const sel = [...document.querySelectorAll(".pref select")].find((s) => !s.classList.contains("lsrc"));
  need(lang && sel, "no language button or list");
  need(box(lang).width === box(sel).width && box(lang).height === box(sel).height, `button ${box(lang).width}×${box(lang).height}, list ${box(sel).width}×${box(sel).height}`);
  need(getComputedStyle(sel).appearance === "none", "the system's arrow shows");
});

t("an empty list's words balance their lines", () => {
  show("networks");
  render();
  const p = document.querySelector(".empty p");
  need(p && getComputedStyle(p).textWrap.includes("balance"), "not balanced");
});
report(R);
})();

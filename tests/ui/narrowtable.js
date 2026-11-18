// window: 760x560
// The smallest window (760 px wide): the containers' table keeps the name readable.
// Size goes, the share column shows its globe and light (the word stays for a screen
// reader), and when the columns can't all have their minimum the name keeps more
// than the rest instead of an even split.
const R = [];
const t = (name, fn) => { try { fn(); R.push("PASS " + name); } catch (e) { R.push("FAIL " + name + ": " + e.message); } };
const need = (c, m) => { if (!c) throw new Error(m); };
show("containers");
render();
fitColumns();
const head = () => [...document.querySelector("#content table").tHead.rows[0].cells];
const col = (word) => head().find((c) => c.textContent.trim() === word);
t("the name column is the widest and fits a name beside its tile", () => {
  const name = col("Name").getBoundingClientRect().width;
  const others = ["State", "Ports", "Share"].map((w) => col(w).getBoundingClientRect().width);
  need(name >= 100, `name is ${Math.round(name)}px`);
  need(others.every((w) => w < name), `others ${others.map(Math.round)} vs name ${Math.round(name)}`);
  const n = document.querySelector('#content tr[data-key="a3"] .name');
  need(n.textContent.includes("postgres"), "no postgres row");
});
t("size is hidden, created too", () => {
  need(getComputedStyle(col("Size")).display === "none", "Size shows");
  need(getComputedStyle(col("Created")).display === "none", "Created shows");
});
t("the share word is out of sight but still read", () => {
  const w = document.querySelector('#content tr[data-key="a1"] .shc .shw');
  need(w && w.textContent.trim() === "Live", "no word");
  need(w.getBoundingClientRect().width <= 1, "the word still shows");
  need(getComputedStyle(w).display !== "none", "hidden from screen readers too");
});
t("the page doesn't scroll sideways", () => need(document.documentElement.scrollWidth <= innerWidth, "scrolls"));
report(R);

# The window's typefaces, vendored

Space Grotesk sets the window's interface (headings, tables, the sidebar) and
JetBrains Mono its labels and code (IDs, ports, commands, logs). They are
Kiri's defaults; Settings → Appearance can pick any installed font or the
system's instead.

They don't go into the page: it is already close to WebView2's 2 MB limit
(assemble.rs). The page asks for them once it's up (`typefaces`) and the host
answers with `typefaces::js()`, which adds them to `document.fonts`, the way a
language's words arrive (`langwords`). Until then the window uses the system's
fonts.

| File | Source | SHA-256 of the source |
|---|---|---|
| space-grotesk.woff2 | `ofl/spacegrotesk/SpaceGrotesk[wght].ttf`, google/fonts @ main | acad6de1fc93436f5c0f1f4137751ef04f1aea3063e7036535970ffcfbd79f72 |
| jetbrains-mono.woff2 | `ofl/jetbrainsmono/JetBrainsMono[wght].ttf`, google/fonts @ main | 48715a42ec242c21e9f02692891e147d022299a52e48d5e413e1a942193ffeda |

Each is the variable font cut to weights 400–700, without hinting, and
subset with fonttools (`pip install fonttools brotli`):

```sh
U="U+0000-024F,U+0259,U+02B0-02FF,U+0300-036F,U+1E00-1EFF,U+2000-206F,U+20A0-20CF,U+2100-214F,U+2190-21FF,U+2212,U+2215,U+2248,U+2260,U+2264,U+2265,U+25A0-25FF,U+2713,U+2715"
fonttools varLib.instancer SpaceGrotesk[wght].ttf wght=400:700 -o sg.ttf
pyftsubset sg.ttf --unicodes="$U" --layout-features='kern,liga,calt,tnum,ss01,ss02,ccmp,locl,mark,mkmk' \
  --flavor=woff2 --no-hinting --desubroutinize --output-file=space-grotesk.woff2
fonttools varLib.instancer JetBrainsMono[wght].ttf wght=400:700 -o jb.ttf
pyftsubset jb.ttf --unicodes="$U,U+0370-03FF,U+0400-04FF" --layout-features='kern,tnum,zero,ccmp,locl,mark,mkmk' \
  --flavor=woff2 --no-hinting --output-file=jetbrains-mono.woff2
```

Latin, Latin Extended and Vietnamese in both; Greek and Cyrillic in JetBrains
Mono as well (Space Grotesk has neither). Every other script the window speaks
falls back, glyph by glyph, to the fonts the page names after these (the CJK,
Arabic and Indic families in index.html). JetBrains Mono leaves out its
programming ligatures: an ID or a command must read exactly as typed.

SIL Open Font License 1.1: OFL-SpaceGrotesk.txt and OFL-JetBrainsMono.txt
here, and in the repository's NOTICE.

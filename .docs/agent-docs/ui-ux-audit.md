# Auditoría UI/UX de Kiri

## Resumen

Última revisión: 2026-11-18 (primera sesión sobre Kiri). Auditoría en curso, no terminada.

**Producto.** Kiri: ventana de escritorio (macOS, Windows, Linux) para contenedores, imágenes, volúmenes, redes, *builds*, Kubernetes, USB y Share. Toda la interfaz es HTML escrito a mano, sin framework:

- `crates/kiri/src/ui/index.html` (≈ 10 400 líneas): ventana principal, con `icons.js`, `langstep.js` y `xterm/` empalmados por `assemble.rs`.
- `crates/kiri-win/src/setup.html`: ventana de instalación de Windows (pasos WSL → Linux → motor → herramientas → listo).
- 38 idiomas en `crates/kiri/src/ui/lang/*.json`, con soporte de derecha a izquierda (árabe, persa, kurdo central).

**Sistema de diseño de referencia.** El árbol sin confirmar ya trae el lenguaje de Enki aplicado a Kiri (cabecera de estilos de `index.html` y de `setup.html`): brutalismo editorial suizo, monocromo y oscuro primero, esquinas rectas (círculos solo en lo que es redondo), líneas finas, titulares pesados frente a microetiquetas en mayúsculas monoespaciadas, tinta invertida en la acción principal y en lo elegido, color solo con significado, y todo color como *token* (`--bg`, `--ink`, `--ink-05/10/20/40`, `--line`, `--edge`, `--muted`, `--faint`, `--moss`, `--sun`, `--red`, `--*-text`, `--focus-ring`, `--t-fast`, `--ease`…). Tipografías propias: Space Grotesk y JetBrains Mono. Cuatro tamaños de letra (`tests/ui/type.js`) y suelo de contraste de 4,5:1 en ambos temas (`tests/ui/contrast.js`). Esta auditoría refina y hace cumplir ese sistema; no propone otro.

**Documentación consultada.** `.docs/manager.md` (reglas de idioma es-ES y de git), `.docs/tema-diseno-estilo-enki.md` (lenguaje visual de Enki, origen del sistema), `README.md`, `scripts/ui-test.py`, `tests/ui/fixture.js`, `tests/ui/contrast.js` y `tests/ui/type.js`. En `.docs/agent-skills/` no hay guía específica de HTML/CSS sin framework; se tuvieron en cuenta `javascript-pro` y `playwright-expert` solo como referencia general. No existen `agents.md`, `AGENTS.md`, `claude.md` ni `CLAUDE.md`.

**Documento anterior.** El `ui-ux-audit.md` que había en esta carpeta describía otro producto (Beekeeper Studio: Vue, `apps/studio`, Electron). Se conserva sin cambios como [`ui-ux-audit-beekeeper-studio.md`](ui-ux-audit-beekeeper-studio.md); no aplica a este repositorio.

**Cómo se verifica.** Con la suite de página real (`python3 scripts/ui-test.py`, Chrome sin interfaz; en Linux hay que pasar `CHROME=<ruta a chrome>`) y con capturas de la página real montada igual que `ui-test.py` (iconos, idioma, fuentes propias y la fixture de cuatro contenedores y tres enlaces de Share), en oscuro y claro, a 1280 × 800 y a 760 × 560 (tamaño mínimo de la ventana: `gtk.rs`, `set_size_request(760, 480)`). La ventana de instalación se captura con su modo demostración (`#demo-<paso>`). No se ha probado en la aplicación nativa (WebKitGTK, WKWebView, WebView2) ni con lector de pantalla.

**Alcance cubierto en esta sesión.** Barrido visual de todas las vistas de la barra lateral, detalle de contenedor (pestaña Overview), menú de fila, avisos emergentes, tarjeta de contexto de Docker, franja de importación, diálogo de Share, búsqueda, VM apagada, onboarding de Linux y los pasos de la ventana de instalación de Windows. Corregidos ocho problemas (ver «Hecho»). Las listas con datos de imágenes, volúmenes, redes, *builds*, pods y servicios no se han visto: la fixture las deja vacías.

## Inventario de pantallas y componentes

Estado a 2026-11-18. «Pulido»: revisado y sin problemas abiertos conocidos. «Parcial»: revisado en parte o con pendientes. «Pendiente»: sin revisión visual.

| Pantalla o componente | Estado | Cobertura |
| --- | --- | --- |
| Barra superior (`.strip`: barra lateral, atrás/adelante, búsqueda, terminal, ajustes) | Parcial | Vista en oscuro y claro, 1280 y 760 px. Resultados de la búsqueda global sin revisar |
| Barra lateral: navegación y grupos | Parcial | Vista en ambos temas. Botón de tema junto a «DOCKER» en duda. Modo riel sin captura |
| Barra lateral: tarjeta de la VM | Parcial | Encendida y apagada. Arranque, parada y suspensión sin captura |
| Barra de estado | Parcial | Vista. Menús de sus elementos sin abrir |
| Contenedores: lista | Parcial | Ambos temas, 1280 y 760 px; ventana estrecha corregida. Estado y puertos aún se recortan a 760 px |
| Contenedores: menú de fila («…») | Pulido | Abierto en oscuro; foco visible en la primera opción, «Remove» en rojo |
| Contenedor: detalle, Overview | Parcial | Cabecera y acciones vistas; punto doble de «Shared» corregido. «Loading…» sin esqueleto |
| Contenedor: detalle, Logs, Terminal, Files | Pendiente | Sin revisar |
| Imágenes: vacío | Pulido | Estado vacío corregido (líneas equilibradas, chip de comando) |
| Imágenes: lista, diálogo «Pull image», capas | Pendiente | La fixture no tiene imágenes |
| Volúmenes, Redes: vacío | Pulido | Mismo patrón de estado vacío, corregido |
| Volúmenes, Redes: lista | Pendiente | Sin datos en la fixture |
| Builds | Parcial | Solo el estado de carga |
| Pods, Services | Parcial | Solo «Looking for Kubernetes…» |
| USB | Parcial | Aviso beta (cierre corregido) y estado de carga; lista de dispositivos sin datos |
| Share: página | Parcial | Ambos temas; subtítulo corregido. Estados de error, pausa y externo sin capturar |
| Share: diálogo del enlace | Parcial | Visto en oscuro; cierre unificado |
| Ajustes: Apariencia | Parcial | Desplegables unificados. Resto de filas visto solo en la primera pantalla |
| Ajustes: Resources, Network, Builds, Kubernetes, Import, Domains, Diagnostics, About | Pendiente | Sin revisar |
| Avisos emergentes (*toasts*) | Pulido | Error y éxito; posición y cierre corregidos |
| Tarjeta de contexto Docker y tarjeta de actualización | Parcial | La de contexto, vista; la de actualización, sin capturar |
| Franja de importación (`#impstrip`) | Parcial | Vista; cierre unificado |
| Onboarding de Linux | Parcial | Estado inicial visto. Error y reinicio sin capturar |
| Paso de idioma (`langstep.js`) | Pendiente | Cubierto por pruebas, no revisado a ojo |
| Instalación de Windows (`setup.html`) | Parcial | Error, elección de Linux y herramientas vistos y corregidos. Bienvenida, WSL, reinicio, motor y listo sin revisar a fondo |
| Terminal integrado (xterm) | Pendiente | Sin revisar |

## Pendiente

### Ventana estrecha (prioridad alta)

- **Contenedores a 760 px: estado y puertos se recortan** («Up 2…», «808…»). Tras la corrección, el nombre tiene 117 px, pero las acciones de fila ocupan 182 px (cuatro botones) de los 548 px del área principal. Opciones, por orden de preferencia: plegar la barra lateral a riel por debajo de unos 900 px (ver «En duda»), o pasar «Restart» y la papelera al menú «…» por debajo de 960 px. Esto último exige añadir «Restart» a ese menú, que hoy no lo tiene.
- Revisar a 760 × 480 el resto de listas (imágenes, volúmenes, redes, pods, servicios) con datos reales: comparten `fitColumns`, así que el nuevo reparto también les afecta, pero no se ha visto.
- A 760 × 560 la tarjeta de la VM queda cortada por abajo (la barra lateral no desplaza). Comprobar a 480 px de alto, el mínimo.

### Cobertura sin revisar (prioridad alta)

- Listas con datos: imágenes (y capas de *build*), volúmenes, redes, *builds*, pods y servicios. Hay que ampliar la fixture o montar estados con `kiri.on({type:"lists", …})`.
- Detalle de contenedor: Logs (filtros, niveles, seguimiento), Terminal y Files.
- Ajustes: las ocho pestañas que no son Apariencia.
- Diálogo «Pull image» (búsqueda en Docker Hub, etiquetas, progreso).
- Resultados de la búsqueda global (`#gq`, `role=combobox`).
- Tema claro de todo lo anterior y una pasada en árabe (RTL), incluido el chevrón nuevo de los desplegables, que no se ha visto en RTL.

### Estados (prioridad media)

- **Carga frente a vacío.** «Looking for Kubernetes…», «Reading build history…» y «Looking for USB devices…» usan el mismo diseño que un estado vacío (icono grande gris y título), sin indicador de actividad. No se distingue «cargando» de «no hay nada». Propuesta: el mismo bloque con un indicador discreto (la barra indeterminada de 3 px que ya usan otras vistas) y sin el icono a tamaño completo.
- **Overview del detalle:** «Loading…» en texto plano, alineado arriba a la izquierda, mientras llegan los datos. Sustituir por un esqueleto con la forma de la tabla de datos para evitar el salto de diseño.
- **Share, tarjeta «Shared now»:** las tres barras salen en verde aunque uno de los enlaces aún se está abriendo. La barra de un enlace que empieza debería ir en `--sun`, como su punto en la lista.

### Accesibilidad (prioridad media)

- El lint del editor (Biome) marca `useButtonType` y `noSvgWithoutTitle` en todo `index.html`. Fuera de un formulario `type` no cambia nada, y los SVG son decorativos dentro de botones con nombre. No es un fallo real, pero conviene confirmar con un lector de pantalla que ningún botón de solo icono se queda sin nombre.
- Medir el contraste de bordes de controles e iconos (criterio 1.4.11, 3:1). `contrast.js` solo mide texto.
- Navegación por teclado completa por vista: orden de tabulación en la tabla, el detalle y Ajustes.

## En duda (requiere decisión del usuario)

- **Plegado automático de la barra lateral.** A 760 px la barra lateral se lleva 212 de 760 px. Recomendación: por debajo de unos 900 px, mostrarla como riel de iconos sin tocar la preferencia guardada (al ensanchar vuelve como estaba). Es el arreglo de fondo de la tabla estrecha, pero cambia la navegación principal, así que no se ha aplicado.
- **Rojo en «Stop».** En la fila de un contenedor, «Stop» y la papelera van en rojo. Con el sistema («el color dice algo: peligro…»), el rojo debería quedar para lo destructivo (eliminar). Parar es reversible. Recomendación: «Stop» en tinta neutra, como «Restart», y rojo solo en eliminar. Por la misma lógica, el ámbar de «Pause» en Share es discutible: ámbar es «atención». Se mantiene porque rojo/verde para parar/arrancar es una convención arraigada en herramientas de contenedores.
- **Botón de tema junto a «DOCKER».** El conmutador claro/oscuro (sol/luna) vive en la cabecera del grupo Docker, donde parece una acción de Docker. Ajustes → Apariencia ya ofrece Sistema/Oscuro/Claro. Recomendación: llevarlo a la barra superior junto al engranaje, o quitarlo. Viene del proyecto original, así que no se ha tocado.
- **Ventana de instalación solo en oscuro.** `setup.html` no tiene tema claro, mientras que la ventana principal sí. Puede ser intencionado (primera impresión de marca). Recomendación: mantenerla oscura, pero que la decisión quede escrita en su cabecera.

## Hecho

### Sesión 1 — 2026-11-18

**Tarea transversal: botón de cierre (×).** El mismo control estaba resuelto de cinco maneras: el aviso beta de USB (texto de unos 14 × 18 px sin fondo, color `--faint`), la tarjeta de contexto (sin tamaño propio), los avisos emergentes (18 × 18), la franja de importación (18 × 18) y el diálogo de Share (24 × 24, con *hover* `--raised`). Ahora hay una sola regla: cuadrado de 24 px (área de pulsación suficiente), color `--muted`, *hover* `--ink-05`, pulsación `--ink-10`, foco con `--focus-ring-in` y transición del sistema (`--t-fast`, `--ease`). Cada sitio solo indica su posición. El relleno derecho de los avisos pasa de 30 a 36 px para dejar sitio al cierre.

**Tarea transversal: pila de la esquina inferior derecha.** Los avisos se colocaban a 18 px del borde inferior, sobre la barra de estado de 24 px, y por encima de la tarjeta de contexto o de actualización, a la que tapaban el botón. Ahora los avisos se alinean con las tarjetas (16 px del borde, por encima de la barra de estado) y suben sobre la tarjeta visible: `cornerLift()` mide la tarjeta con `ResizeObserver` y fija `--corner-h`, con una transición de 180 ms.

**Contenedores en ventana estrecha.** A 760 px (el mínimo) la tabla repartía el ancho a partes iguales, porque no cabía cada columna a su mínimo de 110 px. El nombre se quedaba en 60 px, de los que el icono ocupa casi todo: se leía «w», «a», «p». Tres cambios:

- `fitColumns`: cuando falta sitio, el suelo de cada columna baja a cuatro quintos del reparto igual, de modo que la columna principal conserva más anchura sin quedarse sin nada. Esto se aplica a todas las tablas.
- Por debajo de 960 px se oculta «Size» (nueva clase `col-size`), como ya se ocultaba «Created» por debajo de 1080.
- Por debajo de 960 px, la columna Share muestra el globo y su luz. La palabra («Live», «Sharing…») queda oculta a la vista pero accesible al lector de pantalla y sigue en el `title`.

Resultado: nombre a 117 px, legible, sin desplazamiento horizontal.

**Share: el subtítulo contaba de más.** Con dos enlaces activos y uno abriéndose, la página decía «3 live», mientras que la tarjeta de la VM decía «2 live». Ahora dice «2 live, 1 starting», reutilizando la frase que ya usan la tarjeta y la barra de estado (ya traducida a los 37 idiomas).

**Detalle de contenedor: dos luces en «Shared».** En el botón con etiqueta, el punto verde se recolocaba sobre el globo, pero su pulso (`::before`) se quedaba en la esquina derecha y se veía un segundo punto suelto. Ahora ambos comparten posición.

**Estados vacíos.** El chip de comando (`docker pull alpine`, `docker network create`) pisaba la línea de arriba (relleno de 2 px con interlineado 1,4), y el párrafo dejaba palabras sueltas («show / up here.»). Ahora el interlineado es 1,75, el relleno del chip 1 × 6 px y el texto usa `text-wrap: balance`. Afecta a imágenes, volúmenes, redes y a todos los estados que usan `.empty`.

**Ajustes: desplegables unificados.** El de idioma era un botón propio de 220 × 28 px con chevrón de línea. Los de fuente de interfaz y monoespaciada eran `select` nativos de 240 × 32 px con la flecha del sistema. Ahora ambos miden 240 × 28 (se respeta el límite de 30 px que fija `langmenu-search.js`) y llevan el mismo chevrón de línea. El chevrón es un SVG guardado como *token* por tema (`--chev`, en el color de `--muted`), con posición espejada en RTL y estado deshabilitado.

**Instalación de Windows (`setup.html`).**

- Las casillas y los radios usaban el control nativo con `accent-color` (redondeado y gris), distinto de la casilla cuadrada de la ventana principal. Ahora siguen el mismo dibujo: cuadrado de 16 px, borde de 1,5 px, relleno de tinta con la marca en el color de la página y anillo de foco de tinta. El radio sigue siendo redondo.
- Con la descarga detenida por un error, la barra de progreso seguía en el amarillo de «trabajo en curso». Ahora toma el color de error (`--bad`) y la variante indeterminada deja de moverse (clase `stalled`; se evitó `err`, que ya es la caja de error y rompía el bloque).

## Verificación y evidencias

Sesión 1 (2026-11-18):

- Línea base antes de tocar nada: `python3 scripts/ui-test.py`, todas las pruebas pasadas, ningún fallo.
- Después: **558 comprobaciones pasadas, 0 fallos**, incluidas las de la ventana de instalación, contraste, tipografía, paridad entre sistemas y RTL. Un fallo intermedio (`langmenu-search.js`: el botón de idioma debe medir ≤ 30 px) llevó a fijar los desplegables en 28 px en vez de 32.
- `python3 scripts/i18n-check.py`: 1672 claves, 37 idiomas, 0 problemas. No se añadió ninguna frase.
- Pruebas nuevas:
  - `tests/ui/narrowtable.js` (ventana de 760 × 560): el nombre es la columna más ancha y mide ≥ 100 px; «Size» y «Created» ocultas; la palabra de Share fuera de la vista pero no oculta al lector de pantalla; sin desplazamiento horizontal.
  - `tests/ui/polish.js`: subtítulo «2 live, 1 starting»; una sola luz en «Shared»; cierres de 24 × 24; avisos por encima de la barra de estado y de la tarjeta visible; desplegables de Ajustes del mismo tamaño que el de idioma y sin flecha del sistema; párrafo de estado vacío equilibrado.
- Capturas inspeccionadas antes y después de cada cambio, en oscuro y claro, generadas en el *scratchpad* de la sesión (no se conservan en el repositorio).
- No verificado: la aplicación nativa en los tres sistemas (solo Chromium), RTL a ojo para el chevrón nuevo, ni lector de pantalla.

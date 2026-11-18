# CHANGELOG

## SIN PUBLICAR / UNRELEASED

### CASTELLANO

#### AÑADIDO
- añadir `.docs/github-docs/readme.md` como indice de documentos trasladados, excepciones de nombres y comprobaciones de compatibilidad
- añadir las instrucciones raiz y el registro de adaptacion documental del fork
- incluir las tipografias `Space Grotesk` y `JetBrains Mono` en la aplicacion (`crates/kiri/src/ui/fonts/`, `typefaces.rs`) y registrar sus licencias en `notice.md` y `scripts/ci/notices.sh`
- traducir el color de acento `Graphite` a los 37 idiomas
- añadir las pruebas `tests/ui/contrast.js`, `tests/ui/narrowtable.js` y `tests/ui/polish.js`
- documentar la auditoria de interfaz en `.docs/agent-docs/ui-ux-audit.md`

#### CAMBIOS
- reescribir `readme.md` como portada personal e independiente del fork, detallar sus cambios y distinguir autoria, documentacion y distribuciones de upstream
- normalizar los nombres documentales de raiz y `.github/`, mover acuerdos y procesos a `.docs/github-docs/` y actualizar enlaces, guias e instrucciones
- adaptar `xtask/src/main.rs` y `packaging/linux/build.sh` para leer `license.md` y `notice.md`, conservando `LICENSE` y `NOTICE` en los paquetes de macOS, windows y linux
- cambiar la salida de `scripts/ci/notices.sh` a `notice.md` y actualizar las referencias a los avisos en la documentacion de componentes
- adaptar las guias de gestion y auditoria al workspace Rust, las ramas y la publicacion de Kiri
- rediseñar la ventana principal y la de instalacion de windows con un estilo monocromo, de esquinas rectas, lineas finas y colores definidos como variables, en tema oscuro y claro
- unificar el boton de cierre (×) de avisos, tarjetas, franjas y dialogos en un solo control de 24 px con estados de cursor, pulsacion y foco
- unificar los desplegables de ajustes con el selector de idioma (mismo tamaño y mismo chevron)
- dibujar las casillas y los radios de la instalacion de windows como los de la ventana principal
- colocar los avisos emergentes sobre la barra de estado y por encima de la tarjeta de contexto o de actualizacion

#### CORREGIDO
- mostrar el nombre de los contenedores en ventanas estrechas (760 px): se oculta `Size` y la columna `Share` pasa a icono
- contar aparte los enlaces de `Share` que aun se estan abriendo (`2 live, 1 starting`)
- quitar la segunda luz verde del boton `Shared` en el detalle de un contenedor
- evitar que el comando de los estados vacios pise la linea anterior y deje palabras sueltas
- pintar de rojo la barra de progreso de la instalacion de windows cuando la descarga se detiene

### ENGLISH

#### ADDED
- add `.docs/github-docs/readme.md` as an index of relocated documents, filename exceptions and compatibility checks
- add root instructions and the documentation adaptation record for the fork
- bundle the `Space Grotesk` and `JetBrains Mono` typefaces in the app (`crates/kiri/src/ui/fonts/`, `typefaces.rs`) and record their licences in `notice.md` and `scripts/ci/notices.sh`
- translate the `Graphite` accent colour into the 37 languages
- add the `tests/ui/contrast.js`, `tests/ui/narrowtable.js` and `tests/ui/polish.js` tests
- document the interface audit in `.docs/agent-docs/ui-ux-audit.md`

#### CHANGED
- rewrite `readme.md` as the personal, independent fork landing page, describe its changes and distinguish authorship, documentation and upstream distributions
- normalize root and `.github/` document names, move agreements and processes to `.docs/github-docs/`, and update links, guides and instructions
- adapt `xtask/src/main.rs` and `packaging/linux/build.sh` to read `license.md` and `notice.md`, preserving `LICENSE` and `NOTICE` in macOS, windows and linux packages
- change the output of `scripts/ci/notices.sh` to `notice.md` and update notice references in component documentation
- adapt management and audit guides to the Rust workspace, branches and Kiri release process
- redesign the main window and the windows setup window in a monochrome style with square corners, hairlines and colours defined as variables, in dark and light themes
- unify the close button (×) of toasts, cards, strips and dialogs into one 24 px control with hover, pressed and focus states
- unify the settings lists with the language picker (same size and same chevron)
- draw the windows setup checkboxes and radios like the main window's
- place toasts above the status bar and above the context or update card

#### FIXED
- show container names in narrow windows (760 px): `Size` is hidden and the `Share` column turns into an icon
- count `Share` links that are still opening apart (`2 live, 1 starting`)
- remove the second green light on the `Shared` button in a container's detail
- stop the command in empty states from overlapping the line above and leaving single words on a line
- turn the windows setup progress bar red when the download stops

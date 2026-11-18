<h1 align="center">KIRI-DESKTOP-FORK</h1>

<p align="center">
  <strong>fork personal e independiente de Kiri</strong><br>
  cambios de interfaz, ajustes de uso y documentacion mantenidos por un usuario.
</p>

<p align="center">
  <a href="https://github.com/rezzt-dev/kiri-desktop-fork"><img src="https://img.shields.io/badge/fork-personal-555?style=flat-square" alt="fork personal"></a>
  <a href="#independencia-y-autoria"><img src="https://img.shields.io/badge/relacion_oficial-ninguna-555?style=flat-square" alt="sin relacion oficial con Kiri"></a>
  <a href="license.md"><img src="https://img.shields.io/badge/licencia-Apache--2.0-555?style=flat-square" alt="licencia Apache-2.0"></a>
</p>

<p align="center">
  <a href="#cambios-del-fork">cambios del fork</a> ·
  <a href="#compilar-desde-el-codigo">compilar</a> ·
  <a href="changelog.md">historial</a> ·
  <a href="https://github.com/libracoder/kiri">proyecto original</a>
</p>

## INDEPENDENCIA Y AUTORIA

> **este es el proyecto personal de un usuario, mantenido en [rezzt-dev/kiri-desktop-fork](https://github.com/rezzt-dev/kiri-desktop-fork). no es el proyecto oficial de Kiri ni tiene relacion oficial, afiliacion, patrocinio o respaldo de su equipo.**

el codigo de partida procede de [Kiri, de libracoder](https://github.com/libracoder/kiri). los cambios propios de este fork los realiza y mantiene el usuario responsable de este repositorio; no deben atribuirse al equipo original. el trabajo heredado conserva la autoria y las licencias de sus respectivos autores.

el nombre de Kiri aparece para identificar el origen del codigo y los comandos existentes. no implica representacion del proyecto original ni autorizacion para usar su marca. esta portada no utiliza su logo.

## QUE ES ESTE PROYECTO

Kiri es un runtime de contenedores escrito en `Rust`, con una API compatible con `Docker` e interfaz para `macOS`, `Windows` y `Linux`. el fork parte de esa base y concentra sus cambios en el diseño de la interfaz, los controles, la legibilidad y la organizacion del repositorio.

la compatibilidad con la CLI de `Docker`, `Compose` y `buildx`, la gestion de contenedores, imagenes, volumenes y redes, los dominios locales, `Kubernetes` y las maquinas `Linux` son capacidades heredadas del proyecto original. no son funcionalidades creadas por este fork. su alcance y sus requisitos se describen en [`docs/features.md`](docs/features.md).

## CAMBIOS DEL FORK

este resumen recoge los cambios propios registrados en [`changelog.md`](changelog.md) y la reorganizacion documental del arbol de trabajo. el historial los mantiene bajo `SIN PUBLICAR / UNRELEASED`; su presencia aqui no acredita una release publicada ni pruebas superadas en todos los sistemas.

| area | cambios realizados por el usuario del fork |
| --- | --- |
| diseño de la interfaz | rediseño monocromo de la ventana principal y de la instalacion de `Windows`, con esquinas rectas, lineas finas y colores definidos mediante variables en los temas oscuro y claro |
| tipografias | inclusion de `Space Grotesk` y `JetBrains Mono` en la aplicacion, con sus licencias registradas en `notice.md` |
| controles | cierre comun de 24 px para avisos, tarjetas, franjas y dialogos; desplegables de ajustes coherentes con el selector de idioma; casillas y radios de instalacion alineados con la ventana principal |
| ventanas estrechas | ajustes a 760 px para mantener legibles los nombres de contenedores, ocultando `Size` y mostrando `Share` como icono |
| enlaces compartidos | recuento separado de enlaces activos y en apertura, y retirada del segundo indicador verde del boton `Shared` |
| avisos y estados | avisos emergentes sobre la barra de estado y las tarjetas; mejor reparto del texto de los estados vacios; progreso rojo cuando se detiene la descarga en la instalacion de `Windows` |
| traducciones | traduccion del acento `Graphite` a los 37 idiomas adicionales al ingles |
| pruebas de interfaz | incorporacion de `tests/ui/contrast.js`, `tests/ui/narrowtable.js` y `tests/ui/polish.js` para contraste, tablas estrechas y controles |
| documentacion | instrucciones raiz, guias de gestion adaptadas al workspace, changelog bilingue y registro de auditoria de interfaz |
| organizacion y empaquetado | entradas documentales en minusculas, documentos comunitarios en `.github/` y acuerdos y procesos heredados en `.docs/github-docs/`; rutas legales actualizadas conservando `LICENSE` y `NOTICE` en los paquetes |

<details>
<summary>VER EL CODIGO Y LOS REGISTROS DE LOS CAMBIOS</summary>

- interfaz principal: [`crates/kiri/src/ui/index.html`](crates/kiri/src/ui/index.html).
- instalacion de `Windows`: [`crates/kiri-win/src/setup.html`](crates/kiri-win/src/setup.html).
- tipografias: [`crates/kiri/src/ui/typefaces.rs`](crates/kiri/src/ui/typefaces.rs) y [`crates/kiri/src/ui/fonts/`](crates/kiri/src/ui/fonts/).
- pruebas añadidas: [`contrast.js`](tests/ui/contrast.js), [`narrowtable.js`](tests/ui/narrowtable.js) y [`polish.js`](tests/ui/polish.js).
- auditoria de interfaz y asuntos pendientes: [`.docs/agent-docs/ui-ux-audit.md`](.docs/agent-docs/ui-ux-audit.md).
- adaptacion documental: [`.docs/documentation-adaptation.md`](.docs/documentation-adaptation.md).

los informes describen el contexto y los limites de su revision. no sustituyen las comprobaciones de una compilacion actual ni la validacion en la aplicacion nativa.

</details>

## COMPILAR DESDE EL CODIGO

para trabajar con los cambios de este usuario, utiliza el codigo de este repositorio:

```sh
git clone https://github.com/rezzt-dev/kiri-desktop-fork.git
cd kiri-desktop-fork
```

el workspace usa `Rust 2024`, resolver `3` y dependencias fijadas en `Cargo.lock`. consulta los requisitos completos en [`docs/development.md`](docs/development.md), las tareas de [`xtask/`](xtask/) y los scripts de [`scripts/ci/`](scripts/ci/).

| sistema | tarea disponible | referencia |
| --- | --- | --- |
| `macOS` | `cargo xtask host` | [desarrollo](docs/development.md): entitlement de virtualizacion y preparacion de kernel, disco y guest |
| `Linux` | `cargo xtask linux` | [compilacion de Linux](scripts/ci/linux-build.sh) y [empaquetado](packaging/README.md) |
| `Windows` | `cargo xtask windows-dev` | [desarrollo](docs/development.md): entorno y bundle; tareas `windows` y `msi` para distribucion |

los instaladores y las releases enlazados por la documentacion upstream pertenecen al proyecto original; no acreditan que incluyan estos cambios. los checkouts declaran la version `0.0.0`, que no es un numero de release del fork. el proceso heredado de publicacion se conserva en [`.docs/github-docs/releases.md`](.docs/github-docs/releases.md).

## COMPROBACIONES PARA CONTRIBUIR

para cambios de `Rust`, ejecuta las comprobaciones correspondientes al alcance y la plataforma:

```sh
cargo fmt --check
cargo clippy
cargo test
```

para cambios de interfaz o traducciones:

```sh
python3 scripts/i18n-check.py
python3 scripts/ui-test.py
```

en `Linux`, configura `CHROME` con la ruta de `Chrome` o `Chromium`. las pruebas de runtime y rendimiento requieren un entorno apropiado; los comandos anteriores no acreditan por si solos que toda la aplicacion funcione en los tres sistemas.

## DOCUMENTACION Y CONTRIBUCIONES

| documento | contenido |
| --- | --- |
| [`changelog.md`](changelog.md) | historial de cambios del fork en castellano e ingles |
| [`.docs/manager.md`](.docs/manager.md) | convenciones de gestion del fork y guias de commits, ramas, PR y releases |
| [`docs/features.md`](docs/features.md) | funcionalidades y limites documentados por upstream |
| [`docs/development.md`](docs/development.md) | arquitectura, compilacion y desarrollo |
| [`docs/releases/`](docs/releases/) | notas de versiones heredadas del proyecto original |
| [`.github/contributing.md`](.github/contributing.md) | requisitos tecnicos y de contribucion heredados |
| [`.github/code_of_conduct.md`](.github/code_of_conduct.md) | codigo de conducta |
| [`security.md`](security.md) | politica de seguridad y canales heredados |

las propuestas sobre los cambios del fork deben dirigirse a [este repositorio](https://github.com/rezzt-dev/kiri-desktop-fork). contribuir aqui no equivale a enviar una contribucion a upstream. para proponer cambios al proyecto original, sigue sus requisitos de issue previo para cambios grandes, commits firmados, acuerdo de contribucion y pruebas en los tres sistemas.

## LICENCIA Y MARCA

el codigo se distribuye bajo [Apache-2.0](license.md). las licencias de terceros se recogen en [`notice.md`](notice.md). el kernel guest es `Linux`, bajo `GPL-2.0`; su configuracion, parches y oferta de codigo fuente se conservan en [`guest/kernel/`](guest/kernel/).

**el nombre y el logo de Kiri no estan cubiertos por la licencia del codigo.** el proyecto original exige un nombre y un logo distintos para distribuir forks. este repositorio conserva referencias e identificadores heredados; eso no concede derechos sobre la marca ni convierte este trabajo personal en una distribucion oficial.

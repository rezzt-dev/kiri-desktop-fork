# DOCUMENTOS DE GITHUB Y PROCESOS HEREDADOS

indice de acuerdos y procesos trasladados desde la raiz el `2026-11-18`. `docs/` conserva la documentacion tecnica upstream; `.github/` contiene los documentos comunitarios.

| nombre | para que sirve | origen |
| --- | --- | --- |
| [cla.md](cla.md) | acuerdo de contribucion heredado de upstream | `CLA.md` en raiz |
| [releases.md](releases.md) | proceso upstream de compilacion, firma y publicacion | `RELEASES.md` en raiz |

estos documentos conservan sus condiciones y alcance. describir infraestructura de upstream no implica que el fork disponga de ella.

## NORMALIZACION REALIZADA

arbol inicial limpio; nueve archivos renombrados o trasladados. los cambios se preparan sin crear commit ni publicar.

| origen | destino | motivo |
| --- | --- | --- |
| `README.md` | [readme.md](../../readme.md) | entrada del repositorio |
| `LICENSE` | [license.md](../../license.md) | licencia del codigo |
| `NOTICE` | [notice.md](../../notice.md) | avisos legales de terceros |
| `SECURITY.md` | [security.md](../../security.md) | entrada de seguridad conservada en raiz |
| `CODE_OF_CONDUCT.md` | [code_of_conduct.md](../../.github/code_of_conduct.md) | documento comunitario |
| `CONTRIBUTING.md` | [contributing.md](../../.github/contributing.md) | documento comunitario |
| `.github/PULL_REQUEST_TEMPLATE.md` | [pull_request_template.md](../../.github/pull_request_template.md) | plantilla de pr |
| `CLA.md` | [cla.md](cla.md) | acuerdo de contribucion |
| `RELEASES.md` | [releases.md](releases.md) | proceso heredado |

## EXCEPCIONES Y COMPATIBILIDAD

- `Cargo.toml` y `Cargo.lock`: nombres exigidos por Cargo
- `.github/ISSUE_TEMPLATE/`: carpeta conservada por instruccion expresa; sus tres archivos ya usan minusculas
- `.github/workflows/codeql.yml`, `perf.yml` y `ui-tests.yml`: nombres conservados por instruccion expresa
- `about.toml`, `about.hbs` y `deny.toml`: configuracion y plantilla de herramientas que necesitan permanecer en raiz
- `.gitignore` ya incluye `!/claude.md`; no se necesita otra excepcion
- `license.md` y `notice.md` se conservan byte por byte respecto a los originales. las referencias de origen se actualizan en `xtask/src/main.rs`, `scripts/ci/notices.sh` y `packaging/linux/build.sh`
- los paquetes de macOS, Windows y Linux siguen incluyendo `LICENSE` y `NOTICE`. sus nombres en `installer/windows/kiri.wxs`, `packaging/linux/rpm/kiri.spec` y las pruebas de paquetes se conservan porque apuntan al contenido del artefacto, no a archivos de la raiz
- los `README.md` internos de codigo y el fixture de `tests/finder-mount.sh` conservan sus nombres: quedan fuera del alcance de normalizar raiz y `.github/`
- los textos legales y las urls externas se conservan literalmente

## REFERENCIAS REVISADAS

se buscaron los nombres antiguos en archivos versionados, incluidos documentos, `.docs/`, `.github/`, `docs/`, codigo, scripts, empaquetado, manifiestos y configuracion. los ejemplos genericos de `.docs/agent-skills/` se conservan como material de referencia de terceros.

se actualizaron enlaces de `readme.md`, la contribucion movida y el proceso de releases, ademas de `agents.md`, `claude.md`, el manager, las guias, el procedimiento de auditoria, el registro de adaptacion y las menciones a los avisos de la raiz. los enlaces salientes se resolvieron desde su ubicacion original para recalcular sus destinos.

## COMPROBACIONES

- `git diff --check` y `git diff --cached --check`: sin errores
- 67 enlaces y recursos locales de los documentos tocados: destinos existentes
- `git ls-files`: nueve rutas nuevas registradas; sin mayusculas en raiz o `.github/` fuera de las excepciones
- licencia y avisos: comparacion binaria contra `HEAD` satisfactoria; urls externas conservadas
- `cargo metadata --offline --no-deps --format-version 1`: correcto
- `cargo check -p xtask --offline --locked`: correcto; advertencia del sistema de archivos por falta de hardlinks en la cache incremental, con copia alternativa
- `bash -n packaging/linux/build.sh` y `sh -n scripts/ci/notices.sh`: correctos
- simulacion aislada del empaquetado: el script real prepara los archivos legales para deb y rpm, tanto `kiri` como `kiri-lite`, con empaquetadores sustituidos por verificadores; bytes y nombres de destino correctos
- simulacion aislada del generador: el script real escribe `notice.md` con generacion y descargas sustituidas por fixtures, sin crear `NOTICE` en raiz
- cuatro llamadas de copia legal en `xtask` comprobadas contra las rutas nuevas

no estan instalados `dpkg-deb` ni `rpmbuild`: la simulacion comprueba el staging legal, no construye paquetes instalables. no se han compilado ni firmado los instaladores de macOS o Windows. la deteccion de documentos por github y las integraciones externas solo pueden comprobarse tras publicar; no se ha subido la rama. no se ejecutan instalaciones ni pruebas sobre motores o datos reales.

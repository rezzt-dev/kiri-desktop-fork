# KIRI-DESKTOP-FORK: INSTRUCCIONES DEL PROYECTO

## CONTEXTO Y LECTURA

fork de Kiri (`origin`: `rezzt-dev/kiri-desktop-fork`), runtime de contenedores en Rust con api compatible con Docker e interfaz para macOS, Windows y Linux. el workspace usa Rust 2024, resolver `3` y dependencias fijadas en `Cargo.lock`.

- leer [el manager](.docs/manager.md) para commits, pr, ramas, changelog y releases
- consultar [el indice de guias](.docs/-github-guides/index.md) y abrir las guias de la tarea
- seguir [el procedimiento de auditoria](.docs/repo-audit-and-fix.md) cuando se solicite auditar el repositorio
- desarrollo y arquitectura: [guia tecnica](docs/development.md); requisitos de contribucion: [.github/contributing.md](.github/contributing.md)
- [claude.md](claude.md) remite a estas mismas instrucciones; mantener ambos puntos de entrada coherentes

## MAPA DEL CODIGO Y DOCUMENTACION

| ruta | responsabilidad |
| --- | --- |
| `crates/kiri/` | cli, daemon, api Docker e interfaz (`src/ui/`) |
| `crates/kiri-init/` | agente guest y runtime de contenedores |
| `crates/kiri-vmm/` | virtualizacion |
| `crates/kiri-image/` | registros, imagenes y blobs |
| `crates/kiri-proto/`, `crates/kiri-share-proto/` | protocolos |
| `crates/kiri-win/` | integracion e instalacion de Windows |
| `xtask/`, `.cargo/config.toml` | tareas de compilacion y alias `cargo xtask` |
| `guest/`, `installer/`, `packaging/`, `contrib/` | kernel, instaladores e integracion |
| `tests/`, `scripts/` | pruebas, mediciones y herramientas |
| `docs/` | documentacion tecnica y notas upstream |
| `.github/` | contribucion, conducta, plantilla de pr, issues y workflows |
| `.docs/github-docs/` | acuerdo de contribucion, proceso heredado de releases e indice de documentos movidos |
| `.docs/-github-guides/` | convenciones de gestion del fork |
| `.docs/agent-docs/` | informes de trabajo; comprobar su contexto antes de reutilizarlos |
| `.docs/agent-skills/` | recursos existentes; seleccionar solo los pertinentes, sin copiarlos de otros proyectos |
| `changelog.md` | historial bilingue del fork |

## COMPROBACIONES SEGUN EL CAMBIO

- documentacion: `git diff --check`, enlaces relativos, rutas y referencias a otros proyectos
- Rust: `cargo fmt --check`, `cargo clippy`, `cargo test`, segun `.github/contributing.md`; registrar los limites de plataforma
- interfaz y traducciones: `python3 scripts/i18n-check.py` y `python3 scripts/ui-test.py`; en Linux configurar `CHROME` con Chrome o Chromium
- respetar la paridad de funciones entre sistemas; una excepcion en `tests/ui/parity-allow.txt` requiere la aprobacion del mantenedor indicada en `.github/contributing.md`
- macOS: `cargo xtask host` construye el ejecutable con entitlement de virtualizacion; ver `docs/development.md` para kernel, disco y guest
- Linux: `cargo xtask linux` y scripts de `scripts/ci/`; Windows: `cargo xtask windows-dev`, `windows` y `msi`, con los requisitos de la guia tecnica
- cambios de dependencias Rust o herramientas empaquetadas: ejecutar `scripts/ci/notices.sh` y revisar `notice.md`
- las pruebas de runtime y rendimiento necesitan un entorno apropiado; no reinstalar, iniciar servicios ni alterar datos o contextos Docker como prueba de documentacion

## CONVENCIONES Y ALCANCE

preservar cambios previos y añadir al staging solo rutas de la tarea. no modificar identidad git ni reescribir historial. preparar un commit significa revisar los cambios y entregar titulo y descripcion; crearlo requiere que se solicite esa accion. la autorizacion vigente se mantiene durante toda la tarea.

seguir `.docs/manager.md`: mensajes con `<prefijo> | <resumen>`, cuerpo de 2 a 6 bullets y changelog castellano/ingles bajo `SIN PUBLICAR / UNRELEASED`. conservar `ñ` y `Ñ` y los identificadores literales. el formato de mensajes no obliga a reescribir los documentos tecnicos heredados en ingles.

los workflows presentes son `ui-tests.yml`, `perf.yml` y `codeql.yml` en `.github/workflows/`; no afirmar que han pasado sin evidencia. las referencias locales apuntan a `main`; comprobar el destino remoto antes de publicar.

`Cargo.toml` usa `0.0.0` en checkouts; `.docs/github-docs/releases.md` describe versiones estampadas desde tags en infraestructura privada upstream. no inventar versiones propias, firmas ni acceso a feeds. conservar `docs/releases/`, `license.md`, `notice.md`, `.docs/github-docs/cla.md`, `security.md` y `.github/code_of_conduct.md`. `readme.md` advierte de restricciones del nombre y logo para forks.

al contribuir a upstream, seguir sus requisitos de issue previo para cambios grandes, commits firmados, cla y pruebas en los tres sistemas. completar `.github/pull_request_template.md` con resultados reales y declaracion veraz de herramientas cuando corresponda. evitar pies automaticos de atribucion en los mensajes no permite omitir campos exigidos por el destino.

## ORGANIZACION DE LOS DOCUMENTOS

las entradas de la raiz se llaman `readme.md`, `license.md`, `notice.md`, `security.md`, `changelog.md`, `agents.md` y `claude.md`. los documentos comunitarios viven en `.github/` y los acuerdos y procesos heredados en [.docs/github-docs/](.docs/github-docs/readme.md). conservar `docs/` como documentacion tecnica upstream.

mantener los nombres exigidos por herramientas: `Cargo.toml`, `Cargo.lock`, `.github/ISSUE_TEMPLATE/` y los workflows existentes. `about.toml`, `about.hbs` y `deny.toml` permanecen en raiz como recursos de herramientas. el generador de avisos escribe `notice.md`; `xtask` y el empaquetado leen `license.md` y `notice.md` y mantienen `LICENSE` y `NOTICE` dentro de los paquetes distribuidos.

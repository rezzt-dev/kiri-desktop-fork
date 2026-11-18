# KIRI-DESKTOP-FORK: CONTEXTO DE TRABAJO

leer [agents.md](agents.md) como fuente comun de contexto, mapa del workspace Rust, comprobaciones y convenciones del fork. aplicar estas referencias en cada tarea:

| tarea | referencia |
| --- | --- |
| git y github | [manager](.docs/manager.md) y [guias](.docs/-github-guides/index.md) |
| auditoria | [procedimiento](.docs/repo-audit-and-fix.md) |
| desarrollo y compilacion | [desarrollo](docs/development.md) y [contribucion](.github/contributing.md) |
| historial y publicacion | [changelog del fork](changelog.md), [notas upstream](docs/releases/) y [proceso upstream](.docs/github-docs/releases.md) |
| documentos comunitarios y procesos | [indice](.docs/github-docs/readme.md), [contribucion](.github/contributing.md) y [conducta](.github/code_of_conduct.md) |
| adaptacion documental | [registro de repositorios y mensaje preparado](.docs/documentation-adaptation.md) |

el proyecto usa `crates/` y `xtask/`; no aplicar rutas de Electron, Android ni flujos de ramas de otros proyectos. conservar cambios previos, comprobar el diff real y mantener paridad de funciones entre macOS, Windows y Linux. no afirmar pruebas ni publicaciones sin evidencia. actualizar este punto de entrada y `agents.md` conjuntamente cuando cambie el contexto.

las entradas documentales de raiz y `.github/` usan minusculas. `.docs/github-docs/` guarda acuerdos y procesos; `docs/` conserva la documentacion tecnica. ver `agents.md` para las excepciones de herramientas y los nombres legales conservados dentro de paquetes.

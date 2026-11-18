# KIRI-DESKTOP-FORK: CONTEXTO DE TRABAJO

leer [agents.md](agents.md) como fuente comun de contexto, mapa del workspace Rust, comprobaciones y convenciones del fork. aplicar estas referencias en cada tarea:

| tarea | referencia |
| --- | --- |
| git y github | [manager](.docs/manager.md) y [guias](.docs/-github-guides/index.md) |
| auditoria | [procedimiento](.docs/repo-audit-and-fix.md) |
| desarrollo y compilacion | [desarrollo](docs/development.md) y [contribucion](CONTRIBUTING.md) |
| historial y publicacion | [changelog del fork](changelog.md), [notas upstream](docs/releases/) y [proceso upstream](RELEASES.md) |
| adaptacion documental | [registro de repositorios y mensaje preparado](.docs/documentation-adaptation.md) |

el proyecto usa `crates/` y `xtask/`; no aplicar rutas de Electron, Android ni flujos de ramas de otros proyectos. conservar cambios previos, comprobar el diff real y mantener paridad de funciones entre macOS, Windows y Linux. no afirmar pruebas ni publicaciones sin evidencia. actualizar este punto de entrada y `agents.md` conjuntamente cuando cambie el contexto.

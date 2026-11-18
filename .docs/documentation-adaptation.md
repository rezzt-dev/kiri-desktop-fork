# REGISTRO DE ADAPTACION DOCUMENTAL

fecha: `2026-11-18`. referencia de organizacion: `focusphone-app`, en particular `.docs/-github-guides/`, `.docs/manager.md` y `.docs/repo-audit-and-fix.md`. alcance confirmado: solo este repositorio.

| repositorio modificado | adaptacion | estado |
| --- | --- | --- |
| `rezzt-dev/kiri-desktop-fork` | guias de git/github, manager, auditoria, instrucciones raiz y changelog bilingue | cambios preparados y revisados; commit local pendiente de ejecucion |

## REVISION Y RESULTADO

| hallazgo | evidencia | resultado |
| --- | --- | --- |
| contexto heredado de otro fork | las guias citaban `apps/studio/`, workflows de Studio y version `5.0.9` | sustituido por el workspace Rust, workflows y fuentes de version de Kiri |
| faltaban entradas raiz | inventario inicial sin `agents.md` ni `claude.md` | creadas con mapa tecnico, comprobaciones y enlaces comunes |
| la entrada complementaria estaba ignorada | patron `CLAUDE.md` de `.gitignore` coincide con `claude.md` en este entorno | añadir excepcion explicita para versionar la entrada compartida |
| plantilla de contribucion y reglas de atribucion ambiguas | `.github/pull_request_template.md` pide declarar herramientas | distinguir pies automaticos de la declaracion veraz exigida por upstream |
| contexto de publicacion ajeno al fork | `Cargo.toml`, `xtask/src/main.rs`, `.docs/github-docs/releases.md` y `docs/releases/` | documentar `0.0.0` en checkouts y proceso upstream desde tags; sin inventar releases propias |
| cambio previo del propietario | `git status --short` inicial: `scripts/reinstall-linux.sh` modificado | conservar y excluir del commit documental |

## ARCHIVOS DEL COMMIT PROPUESTO

- `.gitignore`
- `.docs/-github-guides/agent-rules.md`
- `.docs/-github-guides/branching-guide.md`
- `.docs/-github-guides/changelog-guide.md`
- `.docs/-github-guides/index.md`
- `.docs/-github-guides/pr-merge-guide.md`
- `.docs/-github-guides/release-guide.md`
- `.docs/manager.md`
- `.docs/repo-audit-and-fix.md`
- `.docs/documentation-adaptation.md`
- `agents.md`
- `claude.md`
- `changelog.md`

`commit-guide.md` se ha revisado y conserva su formato vigente: prefijo cerrado, separador ` | `, titulo de hasta 72 caracteres y cuerpo de 2 a 6 bullets. las guias conservan la organizacion de referencia, con rutas, ramas, comprobaciones y notas de publicacion propias de Kiri.

## MENSAJE PREPARADO

```text
changes | adaptar la organizacion documental al contexto de kiri
```

```text
- adaptar las guias de gestion y auditoria al workspace Rust y al flujo de publicacion de Kiri
- añadir las instrucciones raiz y sus referencias de desarrollo, contribucion y verificacion
- registrar la adaptacion del repositorio y actualizar el changelog bilingue
```

## COMPROBACIONES Y LIMITES

- `git diff --check`: sin errores de espacios
- enlaces markdown locales de los documentos de la tarea: destinos existentes
- rutas de codigo, manifiestos, workflows y comandos contrastados con los archivos locales
- retiradas las referencias operativas a Studio, Electron, Android y ramas de promociones ajenas en los documentos adaptados
- nuevas entradas de `changelog.md`: dos items por idioma, mismo orden y significado
- staging inicial vacio; no se ejecutan commit, push, pr, tags ni releases al preparar este mensaje
- no se ejecutan compilacion, pruebas funcionales ni reinstalacion para este cambio documental
- no se consulta github: ramas y tags se describen como referencias locales; metadatos y publicaciones remotas quedan pendientes de comprobacion cuando sean necesarios

este registro acredita la adaptacion documental. la auditoria funcional descrita en `repo-audit-and-fix.md` queda como procedimiento futuro.

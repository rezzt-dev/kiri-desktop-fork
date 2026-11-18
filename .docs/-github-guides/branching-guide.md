# GUIA DE RAMAS

## ESPAÑOL DE ESPAÑA: USO OBLIGATORIO DE Ñ

- todo texto en castellano debe usar español de españa (`es-ES`) y su ortografia, tambien en titulos y cuerpos de commits, changelogs, pull requests, merges y documentacion
- escribir siempre `ñ` en las palabras que la llevan y `Ñ` cuando corresponda la mayuscula; nunca sustituirlas por `n` o `N`
- la `ñ` es una letra distinta de la `n`; las instrucciones «sin acentos» o «sin tildes» solo afectan a las tildes de las vocales y nunca permiten eliminar la eñe
- ejemplos correctos: `añadir`, `diseño`, `año`, `tamaño`, `contraseña`, `español`, `españa` y `AÑADIDO`; sus formas con `n` son incorrectas cuando se refieren a esas palabras españolas
- conservar literalmente rutas, urls, nombres de archivo, identificadores tecnicos y texto de otros idiomas; esta regla no autoriza renombrarlos ni aplicar sustituciones indiscriminadas
- antes de entregar o publicar texto en castellano, revisar que ninguna palabra haya perdido su `ñ` o `Ñ`; esta regla prevalece sobre cualquier normalizacion a ascii o instruccion generica de eliminar acentos


## 1. RAMAS VERIFICADAS

inventario local a 2026-11-18: rama actual `main`, referencias `origin/main` y `origin/HEAD -> origin/main`. el remoto `origin` apunta a `rezzt-dev/kiri-desktop-fork`. estas referencias no son una consulta actual de la api de github; comprobar el destino remoto antes de publicar.

## 2. RAMAS DE TRABAJO

| prefijo | uso | destino habitual en el fork |
| --- | --- | --- |
| `feature/` | funcionalidad nueva | `main` |
| `fix/` | correcciones | `main` |
| `changes/` | documentacion, estructura y tooling | `main` |
| `hotfix/` | urgencia en una version publicada | verificar la rama del codigo publicado |

una rama por tema, por ejemplo `changes/documentacion-kiri`. antes de abrir una pr, comprobar `git log <base>..<rama>` y `git diff <base>...<rama>`. no crear ramas de alfa, beta o promociones tomadas de focusphone.

## 3. FLUJO Y VERSIONES

`changes/<tema>` → `main` mediante pr cuando se solicite. conservar merge commit como convencion del fork; al contribuir a upstream, comprobar su politica vigente. una pr de documentacion no cierra una version ni publica artefactos.

## 4. VERIFICACION

workflows versionados: `.github/workflows/ui-tests.yml` (traducciones e interfaz), `.github/workflows/perf.yml` (rendimiento) y `.github/workflows/codeql.yml` (analisis). comprobar los checks reales de la pr; un workflow presente no demuestra que se haya ejecutado.

para documentos, revisar enlaces y `git diff --check`; para codigo, seguir `agents.md` y `.github/contributing.md`. no reescribir commits publicados para actualizar una rama.

## 5. LIMPIEZA

conservar `main`. borrar ramas de trabajo solo tras verificar su merge y cuando se haya solicitado. conservar los cambios previos del propietario.

# AGENTS.md — Rdpack (ms609 fork)

Personal agent notes. **Never commit this to `master` or any PR branch**: `master` of the
fork is PR'd wholesale to upstream. It lives alone on the orphan branch `agents` of `origin`
and is hidden locally via `.git/info/exclude`.

Restore on a new machine:

```bash
git fetch origin agents
git show origin/agents:AGENTS.md > AGENTS.md
echo AGENTS.md >> .git/info/exclude
```

Update: edit, then commit onto `agents` without switching checkout:

```bash
blob=$(git hash-object -w AGENTS.md)
tree=$(printf '100644 blob %s\tAGENTS.md\n' "$blob" | git mktree)
commit=$(git commit-tree "$tree" -p agents -m "Update AGENTS.md")
git update-ref refs/heads/agents "$commit"
git push origin agents
```

## Repository

- Upstream: `GeoBosh/Rdpack` (maintainer Georgi Boshnakov). `origin` = `ms609/Rdpack` fork.
- Workflow: feature branch off `upstream/master` → PR to GeoBosh. Keep diffs minimal and in
  Georgi's style; no personal artefacts, no drive-by refactors.
- Commit as `ms609-agent` (see global CLAUDE.md); `origin` is `ms609/*` so GitHub calls use
  `CLAUDE_GH_TOKEN_MS609`. PRs to GeoBosh may be the human's to open — ask.

## Code conventions (upstream's, not ours)

- No roxygen: `man/*.Rd` are hand-written. Edit them directly; `RoxygenNote` in
  DESCRIPTION is vestigial.
- Comments use dated notes: `## 2026-09-16 new: ...`, `# 2025-11-11 was: ...`. Old code is
  often left commented out rather than deleted — follow suit when replacing behaviour.
- 4-space indent, `if(`/`for(` with no space, `<-`.
- NEWS.md: bullet under the current `# Rdpack x.y.z.9000` heading.

## Layout

- `R/bib.R` — everything bibliographic: `get_bibentries()` (single entry point reading
  `REFERENCES.bib` via `rbibutils::readBib(direct = TRUE, texChars = "Rdpack")`),
  `insert_ref`, `insert_citeOnly` (the `\insertCite` machinery), `safe_cite`,
  `insert_all_ref`, `.toRd_styled`, bibstyles `JSSRd`/`JSSLongNames`.
- `man/macros/refmacros.Rd` — the `\insertRef`, `\insertCite`, … Rd macro definitions.
- Bib parsing is delegated to **rbibutils** (also Georgi's). `readBib` → `bibtexImport`
  → generated R code of `bibentry(...)` calls → `readBibentry`, which drops entries that
  fail `utils::bibentry()` validation. Hook: `fbibentry` argument (rbibutils ≥ 2.2.8).

## Testing

```bash
Rscript -e 'devtools::test()'
```

- Tests in `tests/testthat/`; `test-bib.R` is the relevant one for citations.
- The suite **rewrites tracked fixtures** (`StructureClasses.Rd`, `show.Rd`,
  `myshow-methods.Rd`, `as.character.f_usage.Rd`); `git checkout --` them afterwards.
- One pre-existing warning ("Coercing LHS to a list", test-bib.R `insert_all_ref`).
- `insert_citeOnly()` needs an installed/dev package with `inst/REFERENCES.bib`; for
  fixture bib files use `get_bibentries(test_path(), bibfile = ...)` + `safe_cite()`.

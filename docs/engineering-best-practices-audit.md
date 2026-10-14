# Engineering Best Practices Audit — gcp-cloud-run-enabled-projects

| | |
|---|---|
| **Audit date** | 2026-10-14 |
| **Auditor** | Claude — gauge-repo skill |
| **Rubric version** | `item-credit-v1` — 2026-09-04 (`references/best-practices.md`) |

## Changes since last audit

### Re-audit 2026-10-14 (phase 2, `chore/ai-readiness-100`)

- **9** Gap → **Met**: `.github/CODEOWNERS` → `* @patterninc/security`
- **10** Gap → **Partial**: Error-level lint now gates CI (shellcheck -S error). A fuller ruleset is still to be adopted.
- **13** Gap → **Met**: `.pre-commit-config.yaml` added: gitleaks, private-key detection, YAML/merge-conflict checks, shellcheck
- **14** Not applicable → **Met**: Conventional Commits documented in `AGENTS.md`; enforced on PR titles by `amannn/action-semantic-pull-request` (`pr-title` job)
- **16** Gap → **Partial**: `.github/workflows/ai-readiness-ci.yml` runs `shellcheck` and `pr-title` on every PR. The org ruleset has no `required_status_checks`, so the checks don't gate merges yet.
- **36** Gap → **Met**: `.devcontainer/devcontainer.json` pins the toolchain (github-cli) and runs `make dev` on create
- **37** Gap → **Met**: Root `Makefile`: `make dev` installs deps and git hooks; `make check` runs lint, tests and pre-commit
- **49** Gap → **Met**: `.agents/pattern-agents.json` added: GitHub, ClickUp 132251242 (Security Engineering), `#security-team`, Datadog, skills; no `aws[]` because there is no AWS footprint

## Repo profile

A minimal operator utility: a single ~60-line bash script (`find-cloudrun-projects.sh`) that scans all GCP projects via the gcloud CLI to inventory Cloud Run usage, writing a sorted text file (`cloud-run-projects.txt`, gitignored). There is no build, no package manager, no third-party dependencies beyond the operator's locally installed gcloud SDK, no deployment (the script is run manually from a workstation using the operator's own `gcloud auth`), no AWS footprint, no persistence layer, and no UI. Git history shows a single commit by one bot contributor (`patterninc-gha-runner`); the repo was onboarded to Backstage (`backstage.yaml`, owner `security-comm`, system `security`). GitHub owner verified as `patterninc` via `gh repo view` (default branch `main`), so Pattern inherited controls (Wiz secret scanning, Wiz SAST, Toolsmith MCP, org-wide Wiz dependency coverage) and the org-level active ruleset `require-pr-review` (id 3174764) apply. There is no `.github/` directory (no CI workflows) and no `.agents/` manifest. The repo's minimal scale — a manually run, read-only, dependency-free CLI script with no deployment surface — justifies the large number of N/A verdicts below.

## Scorecard

| Metric | Value |
|--------|-------|
| **Critical gates** | **RED** |
| **Adjusted compliance** | **78.9%** |

Critical gates are RED: 16 (Partial), 23 (Gap) are not yet Met.

`(14 Met + 0.5 × 2 Partial) / (49 total − 30 justified N/A) = 15 / 19 = 78.9%`

### Status totals

| Status | Items |
|--------|------:|
| Met | 14 |
| Partial | 2 |
| Gap | 3 |
| N/A | 30 |
| **Total** | **49** |

### Per-category breakdown

| Category | Met | Partial | Gap | N/A |
|----------|----:|--------:|----:|----:|
| Documentation & Context | 4 | 0 | 0 | 5 |
| Guardrails & Enforcement | 5 | 2 | 1 | 5 |
| Testing & Feedback Loops | 0 | 0 | 2 | 11 |
| Environment & Tooling | 4 | 0 | 0 | 9 |
| Agent dispatch | 1 | 0 | 0 | 0 |
| **Total** | **14** | **2** | **3** | **30** |

## Documentation & Context

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 1 | Skills / reusable prompt workflows | **Not applicable** | Repo's only workflow is one command, fully documented in `CLAUDE.md` | Single-script utility; a skill wrapping one documented command adds no value at this scale. |
| 2 | AGENTS.md | **Met** | `CLAUDE.md` documents purpose, key commands, required permissions, script architecture, and phased roadmap | Equivalent of AGENTS.md; consider renaming/symlinking to `AGENTS.md` for tool-agnostic agents. |
| 3 | Architecture decision records | **Not applicable** | Two-stage verification design rationale documented in `CLAUDE.md` (Architecture section) | Single-script tool with one structural decision, already captured; a dated ADR directory is ceremony at this scale. |
| 4 | Runbooks | **Met** | `README.md` Usage/Prerequisites sections; `CLAUDE.md` Key Commands | The repo's only recurring operational task (run the scan) is documented step by step. |
| 5 | API contract docs | **Not applicable** | No API surface | Consumes gcloud CLI; exposes no wire contract. |
| 6 | README with setup & run instructions | **Met** | `README.md` — overview, prerequisites (gcloud install, auth, permissions), usage, output format | — |
| 7 | Changelog with migration notes | **Not applicable** | Single commit; no releases or versioning | Internal utility with no release process or downstream consumers to migrate. |
| 8 | On-call playbooks | **Not applicable** | No deployed service | Nothing runs in production; no incidents to triage. |
| 9 | CODEOWNERS | **Met** | `.github/CODEOWNERS` → `* @patterninc/security` | — |

## Guardrails & Enforcement

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 10 | Linters | **Partial** | Error-level lint now gates CI (shellcheck -S error). A fuller ruleset is still to be adopted. | See evidence. |
| 11 | Formatters | **Gap** | No shfmt config | Add `shfmt` to the same CI job as shellcheck for canonical shell style. |
| 12 | Type checking | **Not applicable** | Bash-only repo | No static type system exists for bash; shellcheck (item 10) is the closest analog. |
| 13 | Pre-commit hooks | **Met** | `.pre-commit-config.yaml` added: gitleaks, private-key detection, YAML/merge-conflict checks, shellcheck | — |
| 14 | Commit message conventions | **Met** | Conventional Commits documented in `AGENTS.md`; enforced on PR titles by `amannn/action-semantic-pull-request` (`pr-title` job) | — |
| 15 | Branch protection rules | **Met** | Org ruleset `require-pr-review` (id 3174764, active) on `main`: blocks deletion/force-push, requires 1-approval PR | — |
| 16 | Required CI checks before merge | **Partial** | `.github/workflows/ai-readiness-ci.yml` runs `shellcheck` and `pr-title` on every PR. The org ruleset has no `required_status_checks`, so the checks don't gate merges yet. | Add a ruleset requiring these checks. |
| 17 | Dependency allow/deny lists | **Not applicable** | No package manager or third-party dependencies | Only external tool is the operator's gcloud SDK. |
| 18 | License compliance scanning | **Not applicable** | No third-party dependencies | Nothing to scan. |
| 19 | Secret scanning | **Met** | Inherited Pattern Wiz policy (owner verified `patterninc`) | — |
| 20 | SAST / static analysis gates | **Met** | Inherited Pattern Wiz policy (owner verified `patterninc`) | — |
| 21 | Max complexity limits | **Not applicable** | One ~60-line script with a single loop | No ecosystem-standard complexity tooling for bash; enforcement would be ceremony. |
| 22 | Import boundary enforcement | **Not applicable** | Single file; no modules or layers | No import graph exists. |

## Testing & Feedback Loops

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 23 | Unit tests | **Gap** | No tests of any kind | Add bats-core tests exercising the script's filtering/sorting logic against a stubbed `gcloud` on `PATH`. |
| 24 | Integration tests | **Not applicable** | Manually run, read-only query tool; no CI credentials to a GCP org | Real-GCP integration in CI is impractical and risky; stubbed-gcloud unit tests (item 23) cover the logic. |
| 25 | Snapshot / golden-file tests | **Not applicable** | Output is a sorted project-ID list | Would duplicate the stubbed-gcloud unit tests recommended in item 23. |
| 26 | Contract tests | **Not applicable** | No API producer/consumer relationship | — |
| 27 | End-to-end tests | **Not applicable** | No browser UI | — |
| 28 | Visual regression tests | **Not applicable** | No visual surface | — |
| 29 | Test coverage thresholds | **Not applicable** | Bash script; no meaningful coverage tooling at this scale | A threshold over one script adds no signal beyond the tests themselves. |
| 30 | Mutation testing | **Not applicable** | No mutation tooling for bash at this scale | — |
| 31 | Load / performance benchmarks | **Not applicable** | Sequential read-only scan; no service under load | Long runtime (~4,667 projects) is documented; parallelization is a feature idea, not a regression risk. |
| 32 | Flaky test quarantine | **Not applicable** | No test suite to quarantine | — |
| 33 | Structured CI output | **Gap** | No CI exists | Comes largely for free with the item 16 workflow (GitHub Actions annotations from shellcheck/bats). |
| 34 | Deterministic test fixtures | **Not applicable** | No tests; stubbed-gcloud fixtures would be introduced with item 23 | — |
| 35 | Smoke tests for deploys | **Not applicable** | Nothing is deployed | — |

## Environment & Tooling

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 36 | Devcontainer config | **Met** | `.devcontainer/devcontainer.json` pins the toolchain (github-cli) and runs `make dev` on create | — |
| 37 | One-command setup | **Met** | Root `Makefile`: `make dev` installs deps and git hooks; `make check` runs lint, tests and pre-commit | — |
| 38 | Seed scripts for local databases | **Not applicable** | No database | — |
| 39 | MCP servers for external tools | **Met** | Toolsmith-managed MCP access (verified Pattern repo) | — |
| 40 | Scoped secrets per environment | **Not applicable** | No credentials stored in or used by the repo; script relies on the operator's own `gcloud auth login`; no environments | Scoring guidance: N/A for a repo with no credentials or deployment. |
| 41 | Preview environments per PR | **Not applicable** | Nothing to deploy | — |
| 42 | Hot-reload / watch mode | **Not applicable** | Interpreted bash script; edit-and-run is already instant | — |
| 43 | Structured logging (JSON) | **Not applicable** | Interactive operator CLI; console progress output plus a text result file is the product | No production log pipeline consumes this output. |
| 44 | Observable traces and metrics | **Not applicable** | No production runtime | — |
| 45 | Feature flags with local overrides | **Not applicable** | Single-purpose script; no runtime feature surface | — |
| 46 | Database migration tooling | **Not applicable** | No schema or database | — |
| 47 | Dependency update automation | **Met** | Org-wide Wiz coverage for verified Pattern repos (and no third-party dependencies exist) | — |
| 48 | Reproducible builds (lockfiles) | **Not applicable** | No build step, package manager, or dependency manifest — a bash script is its own artifact | Nothing exists to lock or pin. |

## Documentation & Context (agent dispatch)

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 49 | Agent-dispatch manifest | **Met** | `.agents/pattern-agents.json` added: GitHub, ClickUp 132251242 (Security Engineering), `#security-team`, Datadog, skills; no `aws[]` because there is no AWS footprint | — |

## Prioritized recommendations

1. **[S] Gap — required CI checks (item 16, RED gate):** Add a GitHub Actions workflow running shellcheck (and bats once item 23 lands) on PRs, and require it via a repo ruleset since the org ruleset carries no status checks.
2. **[M] Gap — unit tests (item 23, RED gate):** Add bats-core tests for `find-cloudrun-projects.sh` using a stubbed `gcloud` on `PATH` to verify API-check filtering, service-check filtering, and sorted output.
3. **[S] Gap — one-command setup (item 37):** Remove the hard-coded `/home/john/google-cloud-sdk/bin/gcloud` path; resolve `gcloud` from `PATH` or a `GCLOUD` env var and update `README.md`/`CLAUDE.md` accordingly.
4. **[S] Gap — linters (item 10):** Run shellcheck locally and in the item 16 CI workflow.
5. **[S] Gap — CODEOWNERS (item 9):** Add `CODEOWNERS` assigning the security-comm team so org-required reviews auto-route.
6. **[S] Gap — pre-commit hooks (item 13):** Add `.pre-commit-config.yaml` running shellcheck and shfmt.
7. **[S] Gap — agent-dispatch manifest (item 49):** Add `.agents/pattern-agents.json` with repo, ClickUp, Slack, and Datadog identifiers.
8. **[S] Gap — formatters (item 11):** Add shfmt alongside shellcheck in CI and pre-commit.
9. **[S] Gap — structured CI output (item 33):** Satisfied incidentally by the item 16 workflow via GitHub Actions annotations; verify problem-matcher output for shellcheck.
10. **[M] Gap — devcontainer (item 36):** Provide a devcontainer with a pinned gcloud SDK so the environment is reproducible for humans and agents.

## Declined practices

| # | Practice | Rationale |
|---|----------|-----------|
| 1 | Skills / reusable prompt workflows | Single documented one-command workflow; a skill adds nothing. |
| 3 | Architecture decision records | One structural decision (two-stage verification), already documented in `CLAUDE.md`. |
| 5 | API contract docs | No API surface; consumes gcloud CLI only. |
| 7 | Changelog with migration notes | No releases, versions, or downstream consumers. |
| 8 | On-call playbooks | No deployed service; nothing pages. |
| 12 | Type checking | Bash has no static type system; shellcheck is the analog (item 10). |
| 14 | Commit message conventions | No changelog/release automation to feed; single-commit bot-maintained repo. |
| 17 | Dependency allow/deny lists | Zero third-party dependencies. |
| 18 | License compliance scanning | Zero third-party dependencies. |
| 21 | Max complexity limits | One ~60-line script; no bash complexity tooling worth enforcing. |
| 22 | Import boundary enforcement | Single file; no module graph. |
| 24 | Integration tests | Manually run read-only tool; real-GCP CI credentials impractical; logic covered by recommended stubbed-gcloud unit tests. |
| 25 | Snapshot / golden-file tests | Would duplicate the recommended unit tests over a sorted text list. |
| 26 | Contract tests | No producer/consumer API relationship. |
| 27 | End-to-end tests | No browser UI. |
| 28 | Visual regression tests | No visual surface. |
| 29 | Test coverage thresholds | No meaningful coverage tooling for a one-script bash repo. |
| 30 | Mutation testing | No practical bash mutation tooling; disproportionate at this scale. |
| 31 | Load / performance benchmarks | No service under load; scan runtime is documented and non-regressive. |
| 32 | Flaky test quarantine | No test suite exists to quarantine. |
| 34 | Deterministic test fixtures | No tests yet; fixtures arrive with the item 23 recommendation. |
| 35 | Smoke tests for deploys | Nothing is deployed. |
| 38 | Seed scripts for local databases | No database. |
| 40 | Scoped secrets per environment | No stored credentials and no deployment; script uses the operator's own gcloud auth. |
| 41 | Preview environments per PR | Nothing to deploy per PR. |
| 42 | Hot-reload / watch mode | Interpreted script; edit-and-run is instant. |
| 43 | Structured logging | Interactive CLI; text output file is the product; no log pipeline. |
| 44 | Observable traces and metrics | No production runtime. |
| 45 | Feature flags | Single-purpose script with no runtime feature surface. |
| 46 | Database migration tooling | No schema or database. |
| 48 | Reproducible builds (lockfiles) | No build step, package manager, or dependencies; the bash script is its own artifact. |

## Beyond the checklist

- `CLAUDE.md` is unusually thorough for a repo this size: it documents required IAM permissions, the two-stage verification design rationale, and the phased roadmap agents should follow when extending the code.
- The script's two-stage check (API enablement, then actual deployed services) is a deliberate noise-reduction design that avoids false positives, and it is documented rather than left implicit.
- `.gitignore` correctly excludes the generated project-ID output files, keeping potentially sensitive inventory data out of version control.
- The repo is onboarded to Backstage (`backstage.yaml`) with clear ownership metadata (security-comm, SECURITY cost center).
- The tool is read-only by design (list/describe operations only), keeping its permission blast radius minimal.

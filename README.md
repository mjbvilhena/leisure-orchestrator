# Leisure Orchestrator

Product and documentation repository for **Leisure Orchestrator**, a B2C executive leisure assistant. The product coordinates complex travel (flights, lodging, and dining) through a multi-agent orchestration engine, rather than stopping at advice-only chat.

This repository currently holds product specification and related documentation. Application implementation is expected later. TypeScript is a likely implementation language; linting and unit tests for it will be added when application code lands. Other content types are not locked yet.

## Contents

- `docs/product-spec.md` — product specification and MVP epics
- `.github/workflows/` — CI quality checks
- `.github/CODEOWNERS` — default review ownership

## Quality checks

GitHub Actions on `push` to `master`, pull requests, and `workflow_dispatch`:

| Check | Tool | Why |
| --- | --- | --- |
| Secret scanning | [Gitleaks](https://github.com/gitleaks/gitleaks-action) | Universal control against committed credentials |
| Documentation lint | [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2-action) | Markdown is the current primary content |
| Workflow lint | [actionlint](https://github.com/rhysd/actionlint) | GitHub Actions YAML is part of this repo |

### Secrets

Store tokens in GitHub Actions secrets. Do not commit them.

- `GITHUB_TOKEN` — provided by GitHub; used by Gitleaks
- `GITLEAKS_LICENSE` — **required for GitHub Organization repositories**, not for personal accounts. Add it under repository or organization secrets if this repo lives in an org

## Branch protection

On `master` (or the default branch), enable:

1. Require a pull request before merging
2. Require at least one approving review (CODEOWNERS covers the tree)
3. Require status checks to pass: `Secret scan`, `Markdown lint`, and `Workflow lint`
4. Do not allow bypassing these rules for administrators unless there is an explicit break-glass process

## Local lint

```bash
npx --yes markdownlint-cli2
```

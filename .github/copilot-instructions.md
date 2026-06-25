# GitHub Copilot Instructions — Speak for Me

## Workflow — Feature branches

Branch naming convention: `feature/<N>-<short-description>`
where `<N>` is the feature number from the README status table (global unique numbering, 1–22).

Examples: `feature/10-responsive-ui`, `feature/12-historique`, `feature/18-favoris`

**When creating a feature branch**, follow this order strictly:
1. On `develop`, update the row `| N |` in `README.md` to `🟡 En cours`
2. Commit and push that change on `develop`
3. Only then create the feature branch from `develop`

**When the feature is complete**, update the row to `✅ Terminé` directly on `develop` (not on the feature branch).

The README status table is under `## 🗺️ État d'avancement`.

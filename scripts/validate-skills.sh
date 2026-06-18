#!/usr/bin/env bash
# validate-skills — linter de SKILL.md + bins (adaptado de clawvis validate-skills.sh)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

errors=0
warnings=0
checked=0
bins_checked=0

fail() {
  echo "FAIL: $1" >&2
  errors=$((errors + 1))
}

warn() {
  echo "WARN: $1" >&2
  warnings=$((warnings + 1))
}

check_skill_md() {
  local f="$1"
  checked=$((checked + 1))
  local rel="${f#"$ROOT"/}"

  if ! head -1 "$f" | grep -q '^---$'; then
    warn "$rel — sin frontmatter (legacy)"
    return
  fi

  local name desc
  name=$(awk '/^---$/{n++; next} n==1 && /^name:/{sub(/^name:[[:space:]]*/,""); print; exit}' "$f" | tr -d '"' | tr -d "'")
  desc=$(awk '/^---$/{n++; next} n==1 && /^description:/{sub(/^description:[[:space:]]*/,""); print; exit}' "$f" | tr -d '"' | tr -d "'")

  if [[ -z "$name" ]]; then
    fail "$rel — frontmatter sin 'name:'"
  fi
  if [[ -z "$desc" ]]; then
    fail "$rel — frontmatter sin 'description:'"
  fi
}

check_bins() {
  local skill_dir="$1"
  local rel="${skill_dir#"$ROOT"/}"
  shopt -s nullglob
  for bin in "$skill_dir"/bin/*; do
    [[ -f "$bin" ]] || continue
    bins_checked=$((bins_checked + 1))
    local bname
    bname=$(basename "$bin")
    if [[ ! -x "$bin" ]]; then
      warn "$rel/bin/$bname — no ejecutable (chmod +x)"
      continue
    fi
    if ! "$bin" help >/dev/null 2>&1 && ! "$bin" --help >/dev/null 2>&1; then
      warn "$rel/bin/$bname — sin help/--help"
    fi
  done
}

check_skill_oc() {
  local skill_dir="$1"
  local rel="${skill_dir#skills/}"
  # Solo non-code con bin/ — recomendación OpenClaw
  if [[ "$rel" != non-code/* ]]; then
    return
  fi
  shopt -s nullglob
  local bins=("$skill_dir"/bin/*)
  if [[ ${#bins[@]} -eq 0 ]]; then
    return
  fi
  if [[ ! -f "$skill_dir/SKILL-OC.md" ]]; then
    warn "$rel — tiene bin/ pero sin SKILL-OC.md (recomendado para OpenClaw)"
  fi
}

echo "== validate-skills: frontmatter =="
while IFS= read -r -d '' f; do
  check_skill_md "$f"
done < <(find skills -name 'SKILL.md' -print0 2>/dev/null)

echo "== validate-skills: bins =="
while IFS= read -r d; do
  [[ -n "$d" ]] || continue
  check_bins "$d"
  check_skill_oc "$d"
done < <(find skills -name 'SKILL.md' -exec dirname {} \; 2>/dev/null | sort -u)

echo ""
echo "checked=$checked bins=$bins_checked errors=$errors warnings=$warnings"
if [[ $errors -gt 0 ]]; then
  exit 1
fi

#!/usr/bin/env bash
# install.sh — Symlink global skills into IDE skill directories (flat by skill name).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${HOME}/.cursor/skills"
DRY_RUN=false
FORCE=false
INSTALL_ALL=false

usage() {
  cat <<'EOF'
Usage: install.sh [options]

Installs skills from jarvis-skills-library into a flat IDE skills directory.

Options:
  --target PATH   Target directory (default: ~/.cursor/skills)
  --all           Install to ~/.cursor/skills and ~/.claude/skills
  --dry-run       Show actions without creating symlinks
  --force         Replace existing non-symlink directories
  -h, --help      Show this help

Examples:
  bash scripts/install.sh
  bash scripts/install.sh --all
  bash scripts/install.sh --target ~/.claude/skills
  bash scripts/install.sh --dry-run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --all)
      INSTALL_ALL=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

install_to_target() {
  local target="$1"
  local dry="$2"
  local force="$3"

  if [[ -z "$target" ]]; then
    echo "ERROR: target cannot be empty" >&2
    return 1
  fi

  extract_name() {
    local f="$1"
    awk '
      /^---$/ { n++; next }
      n == 1 && /^name:/ {
        sub(/^name:[[:space:]]*/, "")
        gsub(/^["'\''"]|["'\''"]$/, "")
        print
        exit
      }
    ' "$f"
  }

  mkdir -p "$target"
  local installed=0 skipped=0 errors=0

  echo "== jarvis-skills-library install =="
  echo "Source: $ROOT/skills"
  echo "Target: $target"
  echo ""

  while IFS= read -r -d '' skill_md; do
    local skill_dir="$(dirname "$skill_md")"
    local name="$(extract_name "$skill_md")"

    if [[ -z "$name" ]]; then
      echo "SKIP: $skill_md — no name in frontmatter"
      skipped=$((skipped + 1))
      continue
    fi

    local dest="$target/$name"

    if [[ -L "$dest" ]]; then
      local current="$(readlink -f "$dest" 2>/dev/null || true)"
      local expected="$(readlink -f "$skill_dir")"
      if [[ "$current" == "$expected" ]]; then
        echo "OK: $name (already linked)"
        skipped=$((skipped + 1))
        continue
      fi
      if $dry; then
        echo "WOULD relink: $name -> $skill_dir"
      else
        rm "$dest"
        ln -s "$skill_dir" "$dest"
        echo "RELINK: $name"
      fi
      installed=$((installed + 1))
      continue
    fi

    if [[ -e "$dest" ]]; then
      if $force; then
        if $dry; then
          echo "WOULD replace: $dest with symlink to $skill_dir"
        else
          rm -rf "$dest"
          ln -s "$skill_dir" "$dest"
          echo "REPLACE: $name"
        fi
        installed=$((installed + 1))
      else
        echo "WARN: $dest exists (not symlink) — use --force to replace"
        errors=$((errors + 1))
      fi
      continue
    fi

    if $dry; then
      echo "WOULD link: $name -> $skill_dir"
    else
      ln -s "$skill_dir" "$dest"
      echo "LINK: $name"
    fi
    installed=$((installed + 1))
  done < <(find "$ROOT/skills" -name 'SKILL.md' -print0)

  echo ""
  echo "Done [$target]: linked/updated=$installed skipped=$skipped errors=$errors"
  if [[ $errors -gt 0 ]]; then
    return 1
  fi
  return 0
}

if $INSTALL_ALL; then
  failed=0
  install_to_target "${HOME}/.cursor/skills" "$DRY_RUN" "$FORCE" || failed=1
  echo ""
  install_to_target "${HOME}/.claude/skills" "$DRY_RUN" "$FORCE" || failed=1
  exit $failed
fi

if [[ -z "$TARGET" ]]; then
  echo "ERROR: --target cannot be empty" >&2
  exit 1
fi

install_to_target "$TARGET" "$DRY_RUN" "$FORCE"

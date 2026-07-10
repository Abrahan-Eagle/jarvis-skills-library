#!/usr/bin/env bash
# jarvis_git_checkout_pin — fetch + checkout a pinned ref; abort on failure.
# Usage: jarvis_git_checkout_pin <repo_dir> <ref>
# Sourced by sync-*/install-* scripts. Do not execute directly.
#
# Supply-chain: never swallow checkout failures with `|| true`.

jarvis_git_checkout_pin() {
  local repo_dir="$1"
  local ref="$2"

  if [[ -z "$repo_dir" || -z "$ref" ]]; then
    echo "ERROR: jarvis_git_checkout_pin requires <repo_dir> <ref>" >&2
    return 1
  fi
  if [[ ! -d "$repo_dir/.git" ]]; then
    echo "ERROR: not a git repo: $repo_dir" >&2
    return 1
  fi

  if [[ "$ref" == "main" || "$ref" == "master" ]]; then
    echo "WARN: floating branch ref '$ref' — prefer tag or commit SHA for supply-chain safety" >&2
  fi

  # Try tag first, then commit/branch
  if ! git -C "$repo_dir" fetch --depth 1 origin "refs/tags/${ref}:refs/tags/${ref}" 2>/dev/null; then
    if ! git -C "$repo_dir" fetch --depth 1 origin "$ref" 2>/dev/null; then
      if ! git -C "$repo_dir" fetch origin "$ref" 2>/dev/null; then
        echo "ERROR: failed to fetch ref '$ref' from origin in $repo_dir" >&2
        return 1
      fi
    fi
  fi

  if ! git -C "$repo_dir" checkout "$ref" 2>/dev/null; then
    echo "ERROR: failed to checkout pinned ref '$ref' in $repo_dir" >&2
    return 1
  fi

  local head
  head=$(git -C "$repo_dir" rev-parse HEAD)
  echo "Pinned HEAD: $head (requested: $ref)"
  return 0
}

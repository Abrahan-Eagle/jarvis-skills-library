#!/usr/bin/env python3
"""Validate relative markdown links under skills/, docs/, catalog/, AGENTS.md, README.md.

Exits 1 if any relative link target does not resolve to an existing file or directory.
Ignores http(s), mailto, file://, and pure anchors (#...).

Resolution order for a target path:
1. Relative to the markdown file's directory (standard markdown).
2. Relative to the repository root (catalog/AGENTS style: `skills/...`, `docs/...`).
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LINK_RE = re.compile(r"(?<!!)\[[^\]]*\]\(([^)]+)\)")
SKIP_SCHEMES = ("http://", "https://", "mailto:", "file://")

SCAN_GLOBS = (
    "skills/**/*.md",
    "docs/*.md",
    "catalog/*.md",
    "AGENTS.md",
    "README.md",
)


def iter_md_files() -> list[Path]:
    files: list[Path] = []
    for pattern in SCAN_GLOBS:
        files.extend(ROOT.glob(pattern))
    return sorted({p.resolve() for p in files if p.is_file()})


def resolve_target(from_file: Path, target_part: str) -> Path | None:
    """Return an existing Path, or None if missing."""
    candidates = [
        (from_file.parent / target_part).resolve(),
        (ROOT / target_part).resolve(),
    ]
    seen: set[Path] = set()
    for cand in candidates:
        if cand in seen:
            continue
        seen.add(cand)
        if cand.exists():
            return cand
    return None


def strip_fenced_code(text: str) -> str:
    """Blank out fenced code blocks so regex examples are not treated as links."""
    lines = text.splitlines(keepends=True)
    out: list[str] = []
    in_fence = False
    for line in lines:
        if line.lstrip().startswith("```"):
            in_fence = not in_fence
            out.append("\n" if line.endswith("\n") else "")
            continue
        if in_fence:
            out.append("\n" if line.endswith("\n") else "")
        else:
            out.append(line)
    return "".join(out)


def check_file(path: Path) -> list[str]:
    errors: list[str] = []
    try:
        raw = path.read_text(encoding="utf-8")
    except OSError as exc:
        return [f"{path.relative_to(ROOT)}: cannot read ({exc})"]

    text = strip_fenced_code(raw)
    for i, line in enumerate(text.splitlines(), start=1):
        for match in LINK_RE.finditer(line):
            href = match.group(1).strip()
            if " " in href:
                href = href.split(" ", 1)[0].strip('"').strip("'")
            if not href or href.startswith(SKIP_SCHEMES) or href.startswith("#"):
                continue
            # Skip obvious non-path fragments (regex / code leftovers)
            if href.startswith("?") or href.startswith("*") or ":" in href.split("/", 1)[0]:
                continue
            target_part = href.split("#", 1)[0]
            if not target_part:
                continue
            if resolve_target(path, target_part) is None:
                rel = path.relative_to(ROOT)
                errors.append(f"{rel}:{i} -> {href}")
    return errors


def main() -> int:
    all_errors: list[str] = []
    checked = 0
    for md in iter_md_files():
        checked += 1
        all_errors.extend(check_file(md))

    if all_errors:
        print(
            f"ERROR: {len(all_errors)} broken relative markdown link(s) in {checked} files:",
            file=sys.stderr,
        )
        for err in all_errors:
            print(f"  {err}", file=sys.stderr)
        return 1

    print(f"OK: markdown links ({checked} files scanned, 0 broken)")
    return 0


if __name__ == "__main__":
    sys.exit(main())

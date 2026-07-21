#!/usr/bin/env bash
# Copy freshly generated cards into the directory the README points at.
#
# Only files that were actually produced are copied. When the generator fails —
# which it does intermittently, since aggregate queries for this account sit on
# GitHub's GraphQL resource limit — the existing cards are left untouched, so
# the README keeps yesterday's version instead of losing its images.
#
# Safe to run locally: it touches files only, never git.
set -euo pipefail

src=${1:-profile-summary-card-output/github}
dest=${2:-cards}
cards=(1-repos-per-language 2-most-commit-language)

mkdir -p "$dest"

published=0
for name in "${cards[@]}"; do
    if [ -s "$src/$name.svg" ]; then
        cp "$src/$name.svg" "$dest/$name.svg"
        echo "published $name"
        published=$((published + 1))
    else
        echo "skipped   $name (not generated)"
    fi
done

rm -rf "$src"

echo "$published of ${#cards[@]} cards published"

#!/usr/bin/env bash

if git rev-parse --verify HEAD >/dev/null 2>&1; then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=$(${git}/bin/git hash-object -t tree /dev/null)
fi

diff="git diff-index --name-only --cached $against --diff-filter d"

all_files=($($diff))
formatter_files=($($diff -- '*.nix' '*.css' '*.js' '*.json' '*.jsx' '*.md' '*.mdx' '*.scss' '*.ts' '*.yaml' '*.sh' '*.bash'))

# Format staged files.
if [[ -n ${formatter_files[@]} ]]; then
  treefmt && git add "${formatter_files[@]}"
fi

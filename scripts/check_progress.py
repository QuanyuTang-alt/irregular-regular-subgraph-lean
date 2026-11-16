#!/usr/bin/env python3
"""Check the source-only, no-CI progress snapshot; not a principal-theorem certificate."""
import json
import pathlib
import re
import subprocess

root = pathlib.Path(__file__).resolve().parents[1]
files = subprocess.check_output(['git', 'ls-files'], cwd=root, text=True).splitlines()
assert files, 'Stage source files before running this check'
for name in files:
    p = root / name
    assert not p.is_symlink(), f'Symlink refused: {name}'
    assert not name.startswith('.github/workflows/'), 'Progress repositories must not run CI'
    assert p.suffix.lower() not in {'.tex', '.pdf', '.olean', '.ilean', '.o', '.trace'}, name
    if p.suffix == '.lean':
        text = p.read_text(encoding='utf-8')
        assert text.startswith('module\n'), f'Module header: {name}'
        assert len(text.splitlines()) <= 10000
        assert not re.search(r'\b(sorry|admit|axiom|native_decide)\b|sorryAx|Lean\.ofReduceBool', text), name
    if p.suffix in {'.md', '.yaml', '.json', '.lean', '.txt'}:
        text = p.read_text(encoding='utf-8')
        assert '/Users/' not in text and 'gho_' not in text and 'ghp_' not in text, name
manifest = json.loads((root / 'lake-manifest.json').read_text())
assert all(p['type'] == 'git' and re.fullmatch('[0-9a-f]{40}', p['rev']) and
           p['url'].startswith('https://github.com/') for p in manifest['packages'])
print('PASS: module/source/pin/privacy/no-CI checks for verified PARTIAL progress.')
print('Main theorem: NOT FORMALIZED. Comparator: NOT RUN. Palomar-ready: NO.')

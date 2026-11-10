#!/usr/bin/env python3
"""Migrate <i>/<span class="material-icons">ENTITY</i> markup to Lucide icon partials.

Usage: python3 tools/migrate-icons.py
Processes all .tpl files under templates/ and modules/.
"""
import re
import sys
from pathlib import Path

THEME = Path(__file__).resolve().parent.parent

MAP = {
    'e000': 'circle-x', 'e001': 'circle-alert', 'e002': 'triangle-alert',
    'e0b0': 'phone', 'e0be': 'mail', 'e0cd': 'phone',
    'e145': 'plus', 'e148': 'circle-plus', 'e14b': 'ban', 'e14c': 'x',
    'e151': 'mail-open', 'e152': 'list-filter', 'e153': 'flag', 'e158': 'mail',
    'e15b': 'minus', 'e254': 'square-pen', 'e2c4': 'file-down',
    'e313': 'chevron-down', 'e314': 'chevron-left', 'e315': 'chevron-right',
    'e316': 'chevron-up', 'e415': 'file-text', 'e417': 'eye',
    'e547': 'shopping-cart', 'e54e': 'tag', 'e5c4': 'arrow-left',
    'e5c5': 'chevron-down', 'e5c8': 'arrow-right', 'e5ca': 'check',
    'e5cb': 'chevron-left', 'e5cc': 'chevron-right', 'e5cd': 'x',
    'e5d2': 'menu', 'e853': 'circle-user-round', 'e854': 'shopping-cart',
    'e860': 'undo-2', 'e86c': 'circle-check', 'e872': 'trash-2',
    'e879': 'log-out', 'e87d': 'heart', 'e88a': 'house', 'e88e': 'info',
    'e88f': 'info', 'e8ad': 'printer', 'e8b0': 'receipt', 'e8b1': 'gift',
    'e8b6': 'search', 'e8cc': 'shopping-cart', 'e8db': 'thumbs-down',
    'e8dc': 'thumbs-up', 'e8f4': 'eye', 'e916': 'calendar',
    'ef3a': 'map-pin', 'f00f': 'map-pin', 'f02e': 'user-round-cog',
    'f05b': 'tag', 'f090': 'download', 'f1cc': 'shopping-bag',
}
TEXT_MAP = {'chevron_right': 'chevron-right', 'visibility': 'eye',
            'visibility_off': 'eye-off'}

TAG_RE = re.compile(
    r'<(?P<tag>i|span)\b(?P<attrs>[^<>]*)>'
    r'\s*(?:&#x(?P<ent>[0-9a-fA-F]+);|(?P<text>[a-z_]+))\s*'
    r'</(?P=tag)>'
)
CLASS_RE = re.compile(r'\bclass="([^"]*)"')
ATTR_RE = re.compile(r'([\w-]+)="([^"]*)"')


def convert(match: re.Match) -> str:
    attrs_str = match.group('attrs')
    class_m = CLASS_RE.search(attrs_str)
    if not class_m or 'material-icons' not in class_m.group(1).split():
        return match.group(0)

    ent = match.group('ent')
    text = match.group('text')
    if ent:
        name = MAP.get(ent.lower())
        if not name:
            print(f'  !! unknown entity &#x{ent}; in match, kept as-is')
            return match.group(0)
    else:
        name = TEXT_MAP.get(text)
        if not name:
            return match.group(0)

    classes = [c for c in class_m.group(1).split() if c != 'material-icons']
    others = ' '.join(
        m.group(0) for m in ATTR_RE.finditer(attrs_str)
        if m.group(1) not in ('class', 'aria-hidden')
    )

    out = f'{{include file="_partials/icons/{name}.tpl"'
    if classes:
        out += f' class="{" ".join(classes)}"'
    if others:
        out += f" attrs='{others}'"
    return out + '}'


def main() -> int:
    changed = 0
    for sub in ('templates', 'modules'):
        for tpl in sorted((THEME / sub).rglob('*.tpl')):
            src = tpl.read_text(encoding='utf8')
            if 'material-icons' not in src:
                continue
            dst, count = TAG_RE.subn(convert, src)
            leftover = len(re.findall(r'material-icons', dst))
            if dst != src:
                tpl.write_text(dst, encoding='utf8')
                print(f'{tpl.relative_to(THEME)}: {count} replaced'
                      + (f' ({leftover} material-icons LEFT)' if leftover else ''))
                changed += 1
            elif leftover:
                print(f'{tpl.relative_to(THEME)}: NO replacements, {leftover} left')
    print(f'\n{changed} files updated')
    return 0


if __name__ == '__main__':
    sys.exit(main())

# Changelog

Copyright (C) 2026 Yu Zhai. LPPL 1.3c or later.

## 0.8.1 -- 2026-10-29

- Replace NewEnvironmentCopy with separate NewCommandCopy calls.
- Require LaTeX 2020-10-01 or newer, with an explicit error on older kernels.
- Add clean-archive verification and minimum-kernel rollback tests.
- Document the difference between kernel rollback and historical distributions.

## 0.8.0 -- 2026-10-29

- Add rainbow coloring at package and environment scope.
- Add local enable/disable and custom cyclic color palettes.
- Preserve math dimensions and surrounding text/formula color.

## 0.7.1 -- 2026-10-29

- Fix measurement across intertext and parsing of align inside gather.
- Validate braced metadata arguments and row-spacing brackets.
- Consolidate the public package as matchedsplit.sty.
- Add the English user manual and distribution metadata.

## 0.7 -- 2026-10-29

- Add matchedalign, matchedalign* and the overridealign option.
- Retain native amsmath numbering, tags and reference handling.

## 0.6 -- 2026-10-29

- Add the overridesplit option and tag-position handling.

## 0.5 -- 2026-10-29

- Repair nested delimiter measurement and preservation of token groups.
- Add independent-pair measurements and explicit diagnostics.

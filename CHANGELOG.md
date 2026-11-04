# Changelog

Copyright (C) 2026 Yu Zhai. LPPL 1.3c or later.

## Unreleased

- Keep the original measurement backend on all engines; LuaTeX physical
  partition development now lives in a separate project.
- Add niji as an alias for rainbow at package and environment scope.

- Preserve native left/right spacing for pairs contained in one alignment
  cell, including after operators such as lim and Tr.

- Keep rainbow color resets inside top-level delimiter atoms so following
  superscripts, subscripts and primes retain their attachment.

- Color explicit left/middle/right pairs inside braced groups in rainbow
  mode, preserving native math styles and script attachment. Ordinary
  delimiters remain unchanged.

- Add matchedalignat and matchedalignat*, with native column counts, spacing,
  numbering, local color options and independent overridealignat support.

- Add matchedaligned with explicit block position and separate local color options.

- Apply amsmath tag placement to matchedsplit as well as overridden split.
- Clarify that delimiter layout carries no guarantee of semantic correctness.

- Exclude delimiter measurement and invisible sizing aids from math tagging.
- Preserve native align environment names for tagged equation numbers.
- Add LuaLaTeX MathML and PDF structure comparisons against native amsmath.

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

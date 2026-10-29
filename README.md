# matchedsplit

Matched delimiters across manually broken equations.

Version: 0.8.0 (2026-10-29)  
Author and current maintainer: Yu Zhai <me@zhaiyusci.net>  
License: LaTeX Project Public License, version 1.3c or later  
Maintenance status: maintained

## Description

matchedsplit allows `\left`, `\middle` and `\right` constructions to
cross manually chosen alignment rows. Each delimiter pair is measured
independently, including nested pairs. The package provides:

- `matchedsplit`: an inner math alignment, with numbering supplied by its parent;
- `matchedalign` and `matchedalign*`: numbered and unnumbered display alignments;
- `overridesplit` and `overridealign`: opt-in replacements for the amsmath environments.

It does not choose line breaks automatically. Groups and inner environments
are kept intact; cross-boundary pairing and side-effectful formula macros
are outside the supported interface. See the manual for details.

## Requirements

A modern LaTeX format with the document-command, environment-copy and hook
interfaces, and amsmath, xcolor and l3keys2e. Tested with pdfLaTeX, XeLaTeX and LuaLaTeX in
TeX Live 2026. Earlier formats have not been verified. The package itself
requires no special fonts or shell escape and is not platform-specific.

## Installation

Place `matchedsplit.sty` beside your document, or install it under
`tex/latex/matchedsplit/` in a personal TEXMF tree. Refresh the filename
database if required by your installation. No docstrip extraction is needed.

```tex
\usepackage{matchedsplit}
```

To replace the native environments instead:

```tex
\usepackage[overridesplit,overridealign]{matchedsplit}
```

## Example

```tex
\begin{matchedalign}
F &= \left( a+\frac{x}{y} \label{eq:first}\\
  &\quad +\frac{p}{q}\right)\label{eq:second}
\end{matchedalign}
```

Each row receives a number. For one number for the complete formula, put
`matchedsplit` inside `equation`. Compile twice to resolve references.
The complete example is `numbered_example.tex`.

## Rainbow delimiters

Enable coloring globally with `\usepackage[rainbow]{matchedsplit}`, or
locally with `\begin{matchedalign}[rainbow]`. Use `[rainbow=false]` to
disable a global default for one environment. The same local options work
on matchedsplit, matchedalign*, and on the replaced split/align/align*.

Use `colors={blue,orange,teal}` at either level to select a nonempty xcolor
palette. The palette cycles by nesting depth; sibling pairs reuse their
color. A pair's left/right/middle delimiters remain the same color across
rows, while formula contents and equation numbers retain their own color.
The colors key alone does not enable coloring. Groups and native inner
environments retain their original behavior.

## Documentation

Read `matchedsplit.pdf`. Rebuild it from the directory containing the
package and documentation source:

```sh
pdflatex matchedsplit.tex
pdflatex matchedsplit.tex
```

The manual additionally uses standard documentation packages including
geometry, Latin Modern, listings, booktabs, fancyhdr, xcolor and hyperref.
Its mathematical examples are typeset by matchedsplit itself.

## License and reporting bugs

Copyright (C) 2026 Yu Zhai.

This work may be distributed and/or modified under the conditions of the
LaTeX Project Public License, either version 1.3c of this license or (at your
option) any later version. The latest version is available at
<https://www.latex-project.org/lppl.txt>.

This work has the LPPL maintenance status `maintained`.
The Current Maintainer is Yu Zhai <me@zhaiyusci.net>.
See `MANIFEST.md` for the files comprising the distribution and `LICENSE`
for the license notice.

Please send bug reports with a minimal reproducing document, the engine
and distribution version, and the relevant log to <me@zhaiyusci.net>.

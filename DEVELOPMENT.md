# Developer notes

Copyright (C) 2026 Yu Zhai. LPPL 1.3c or later.

## Structure

`matchedsplit.sty` is the single implementation. Public interfaces are
specified in matchedsplit.pdf; names beginning with `__ms` and the
msnativealign environments are internal and are not stable APIs.
`regression.tex` retains the extended user examples.

## Processing

The environment collects its body with `+b`. The parser preserves braced
groups, tracks nested environment depth, and identifies top-level
delimiters, row controls and supported metadata. Open delimiter pairs
are stored on a stack. Each ordinary mathematical token is appended to
all active pairs. Closing a pair measures its contents in display style
with invisible boundaries and records the dimensions in a local box.

The rendered stream contains complete local delimiter constructions with
phantoms. matchedsplit passes that stream to aligned; matchedalign passes
it to a saved native align environment for numbering and layout.

## Invariants

- Property keys must contain expanded numeric IDs.
- Preserve group braces, including a final single group: the scanner uses
  a sentinel to avoid TeX stripping that group's braces during argument scanning.
- Row markers, supported labels/tags and intertext must not execute during
  delimiter measurement.
- Parsing inside an alignment requires alignment-safe protection, not merely
  an ordinary TeX group.
- Do not expand arbitrary user macros while scanning.
- Box assignments and parser state are local; box registers are allocated
  lazily by pair ID and reused in later environments.

Token-list copying and appending to every active pair can be costly.
The implementation is not claimed to be linear in input size or nesting depth.

## amsmath integration

The split replacement also changes insplit@ because amsmath locally
rebinds split inside align/gather. Native align* and other alignment
environments share endalign. The native ending is restored locally when
those implementations are invoked, avoiding interference from the new
body-collecting align wrapper. Retest after upgrading amsmath.

## Tests and documentation

Run `./test.ps1` in PowerShell with all three engines on PATH. It places
outputs and Lua font caches under build/, restores the cache environment
variables afterwards, and gives each compiler process a 30-second timeout.
The timeout may need adjustment on a machine building fonts for the first time.

Numbering cases run twice and assert aux label values. Dimension tests
compare with native TeX boxes. Negative cases require a nonzero exit code
and a matchedsplit error; a timeout is a failure, not an expected rejection.
Inspect rendered PDFs for changes to delimiter sizes or layout.

Build the manual by running `pdflatex matchedsplit.tex` twice from this
directory. The upload archive includes only the files in MANIFEST.md.
See AUDIT.md for the audit scope and remaining limitations.

## Rainbow implementation (0.8.0)

Package options establish defaults; each environment copies those defaults
into local settings before applying its optional keys. Palette indices are
stored by pair ID when a left delimiter opens, using the current stack
depth modulo the palette length. Siblings therefore reuse colors.
The rendering commands set color inside the existing math atom group;
measurement stays uncolored, and subsequent formula material is unaffected.

rainbow_assertions.tex checks palette cycling, sibling mapping, setting
reset, and equal width/height/depth with coloring enabled and disabled.
rainbow_test.tex and rainbow_local_test.tex exercise package/local options,
custom palettes, replacements, middle delimiters and ambient text color.

## Release verification

Run `./verify-release.ps1` after rebuilding dist/matchedsplit.zip. The script
extracts the archive into a newly created system temporary directory and
uses the archived implementation and documentation. Test fixtures and the
test runner are supplied separately from the checkout as a harness; no
package implementation is copied from the checkout.

It clears custom TEXINPUTS, supplies an empty TEXMFHOME, isolates writable
font caches, and checks kpsewhich plus recorder provenance. It runs the
complete suite, rebuilds the archived manual and example with three engines,
checks selected cases under the 2020-10-01 kernel rollback, and checks that
2020-02-02 is rejected. The initial and final archive hashes must agree.
The temporary directory and compiler logs are retained for inspection.
This isolates files and configuration, not the operating system or the
installed TeX distribution. Kernel rollback retains installed package versions.

The native align copies use separate NewCommandCopy calls for start and
end commands. This preserves command-copy semantics without requiring the
NewEnvironmentCopy interface introduced in 2023. Both NewCommandCopy and
the kernel hooks used here are available from LaTeX 2020-10-01.

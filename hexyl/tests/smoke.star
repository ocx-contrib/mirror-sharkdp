# hexyl/tests/smoke.star — stable across upstream hexyl releases.
# Asserts the contract (exit code, version shape, the exact bytes hexyl computes
# for a hermetic input, in two bases and through the offset/length selectors),
# never help/version prose. See ocx.mirror testing-practices.md.
#
# hexyl is a single self-contained binary with no external assets, so there is
# no second "flavour" to discriminate — what a truncated or wrong-arch archive
# would break is the exec itself, and the rendered output below is what would
# break if the binary ran but the formatter did not.
#
# Every flag used here exists in v0.15.0, the floor, and was checked against
# v0.15.0/v0.16.0/v0.17.0 binaries. `--include` (v0.17.0-only) is deliberately
# NOT used: it would red every older version.

HEXYL = "hexyl.exe" if ocx.target_platform.os == ocx.os.Windows else "hexyl"

# Tier 1 + 2: liveness on the composed PATH + version SHAPE (not the vendor
# banner, not the exact version — the digits are the contract).
r_version = ocx.run(HEXYL, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3a: the core contract — render a hermetic byte string as hex.
# `--plain` is hexyl's own alias for --no-characters --no-position
# --border=none --color=never, so the output is nothing but the hex bytes,
# right-padded to the panel width.
#
# The assertion is ANCHORED (^…$) rather than a substring check, which makes it
# the negative test too: a stray position gutter, character panel or border
# would break the match. `\s*` absorbs both the leading indent and the trailing
# pad, and covers the newline on either line-ending convention.
ocx.write_file("sample.bin", "ABCDEFGH")
r_plain = ocx.run(HEXYL, "--plain", "sample.bin")
expect.ok(r_plain)
expect.matches(r_plain.stdout, r"^\s*41 42 43 44 45 46 47 48\s*$")

# Tier 3b: the offset/length selectors. This is the assertion with teeth —
# hexyl exits 0 having printed a full dump, an empty dump, or the wrong window
# alike, so "it ran" proves nothing. Skipping 2 and taking 3 of ABCDEFGH must
# yield exactly C, D, E (0x43 0x44 0x45). The anchor is what excludes both
# failure directions: a binary that ignored --skip prints 41 first, one that
# ignored --length runs on to 48, and either breaks the match.
r_window = ocx.run(HEXYL, "--plain", "--skip", "2", "--length", "3", "sample.bin")
expect.ok(r_window)
expect.matches(r_window.stdout, r"^\s*43 44 45\s*$")

# Tier 3c: a computed re-encoding of the same bytes in a different base. This
# forces the formatter rather than a byte passthrough — 0x41/0x42 are rendered
# as binary by hexyl's own conversion, and nothing in this script supplied the
# digits.
r_bin = ocx.run(HEXYL, "--plain", "--base", "binary", "--length", "2", "sample.bin")
expect.ok(r_bin)
expect.matches(r_bin.stdout, r"^\s*01000001 01000010\s*$")

# Tier 3d: the colorizer path — hexyl's whole point is a *colored* hex view, and
# --plain above never exercises it. The same window is rendered twice, once
# forced uncolored and once forced colored, and the pair compared.
#
# Do NOT assert a multi-word plain substring against the colored output: hexyl
# emits SGR sequences per byte class, so any given run of hex pairs may be split
# by an escape at a class boundary. Asserting the two renders DIFFER, plus the
# presence of an ESC-CSI, is the color-scheme-independent way to prove the
# colorizer actually ran.
r_nocolor = ocx.run(
    HEXYL, "--no-position", "--no-characters", "--border=none",
    "--color=never", "--length", "4", "sample.bin",
)
expect.ok(r_nocolor)
r_color = ocx.run(
    HEXYL, "--no-position", "--no-characters", "--border=none",
    "--color=always", "--length", "4", "sample.bin",
)
expect.ok(r_color)
expect.matches(r_color.stdout, r"\x1b\[")
expect.ne(r_color.stdout, r_nocolor.stdout)

# No Tier 4: metadata.json declares PATH only (proven by Tier 1 liveness).

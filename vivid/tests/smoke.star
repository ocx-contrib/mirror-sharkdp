# vivid/tests/smoke.star — stable across upstream vivid releases.
# Asserts the contract (exit code, version shape, the structure of the LS_COLORS
# expression vivid computes, and that the EMBEDDED theme set and filetype
# database really shipped), never help/version prose.
# See ocx.mirror testing-practices.md.
#
# What this has to discriminate: vivid's release archive contains the executable
# and nothing else — no themes/, no filetypes.yml (verified by `tar tzf`). The
# whole theme set and the filetype database are compiled INTO the binary, so a
# truncated or wrong-flavour archive that still execs would answer `--version`
# and fail everything below it. That is why Tier 3 asserts on generated output
# rather than stopping at liveness.
#
# Every subcommand and flag used here exists in v0.10.1, the floor, and was
# checked against v0.10.1 and v0.11.1 binaries. Theme names are asserted only
# from the set present in BOTH.

VIVID = "vivid.exe" if ocx.target_platform.os == ocx.os.Windows else "vivid"

# Tier 1 + 2: liveness on the composed PATH + version SHAPE (not the vendor
# banner, not the exact version — the digits are the contract).
r_version = ocx.run(VIVID, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3a: the embedded theme registry. `themes` prints one theme name per line
# — these are documented `generate <theme>` arguments a user types, i.e. stable
# identifiers, not prose. Asserting the COUNT as well is what has teeth: a
# binary that lost its embedded themes would print an empty list and still exit
# 0, and a single-name check would pass against a build carrying one theme.
r_themes = ocx.run(VIVID, "themes")
expect.ok(r_themes)
theme_names = [t for t in r_themes.stdout.replace("\r", "").split("\n") if t]
expect.true(len(theme_names) >= 20)
expect.true("molokai" in theme_names)
expect.true("nord" in theme_names)

# Tier 3b: generate a real LS_COLORS expression. The output is a single
# colon-separated list of `key=value` pairs, and every assertion below is on a
# value vivid COMPUTED from its embedded theme + filetype database — nothing
# here was supplied by this script.
#
#   di=  — the directory entry, present in every theme; `0;38;2;R;G;B` is the
#          24-bit encoding (the default color mode).
#   *.rs= — a per-extension entry, which can only come from the embedded
#          filetype database. This is the assertion that would red against a
#          binary whose database failed to ship.
r_gen = ocx.run(VIVID, "generate", "molokai")
expect.ok(r_gen)
expect.matches(r_gen.stdout, r"(^|:)di=[0-9;]*38;2;\d+;\d+;\d+(:|$)")
expect.matches(r_gen.stdout, r"(^|:)\*\.rs=[0-9;]+(:|$)")
entries = [e for e in r_gen.stdout.strip().split(":") if e]
expect.true(len(entries) >= 100)

# Tier 3c: the color-mode conversion. 8-bit re-encodes the same theme as
# `38;5;<n>` instead of `38;2;<r>;<g>;<b>` — a computed transform of the
# embedded palette, so the two renders must differ AND each must carry its own
# encoding. A binary that ignored -m would emit identical output twice.
r_8bit = ocx.run(VIVID, "-m", "8-bit", "generate", "molokai")
expect.ok(r_8bit)
expect.matches(r_8bit.stdout, r"(^|:)di=[0-9;]*38;5;\d+(:|$)")
expect.ne(r_8bit.stdout, r_gen.stdout)

# Tier 3d: a second theme. Proves more than one theme is really embedded —
# `themes` listing 30 names would still pass Tier 3a if every one of them
# resolved to the same hardcoded palette.
r_ayu = ocx.run(VIVID, "generate", "ayu")
expect.ok(r_ayu)
expect.matches(r_ayu.stdout, r"(^|:)di=[0-9;]*38;2;\d+;\d+;\d+(:|$)")
expect.ne(r_ayu.stdout, r_gen.stdout)

# No Tier 4: metadata.json declares PATH only (proven by Tier 1 liveness).

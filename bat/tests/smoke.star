# bat/tests/smoke.star — stable across upstream bat releases.
# Asserts the contract (exit code, version shape, exact byte passthrough,
# highlighting actually running), never help/version prose.
# See ocx.mirror testing-practices.md.

BAT = "bat.exe" if ocx.target_platform.os == ocx.os.Windows else "bat"

# Tier 1 + 2: liveness on the composed PATH + version SHAPE (not the vendor
# banner, not the exact version — the digits are the contract).
r_version = ocx.run(BAT, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3a: bat's core contract is that `--plain` is a byte-exact `cat`. The
# assertion is ANCHORED (^…$) rather than a substring check, which makes it the
# negative test too: any decoration bat might add — line numbers, the default
# box-drawing gutter, a header — breaks the match. `--no-config` keeps a stray
# BAT_CONFIG_PATH on the runner from changing the styling out from under us.
# `\r?` tolerates the Windows console translating the line endings.
ocx.write_file("sample.txt", "hello ocx\nsecond line\n")
r_cat = ocx.run(
    BAT, "--no-config", "--plain", "--paging=never", "--color=never", "sample.txt",
)
expect.ok(r_cat)
expect.matches(r_cat.stdout, r"^hello ocx\r?\nsecond line\r?\n?$")

# Tier 3b: bat embeds its syntax definitions and themes INSIDE the executable,
# so this is what would red against a truncated or wrong-flavour archive that
# still happened to exec. The same file is rendered twice — once uncolored, once
# forced through a named theme — and the pair is compared.
#
# Do NOT assert a multi-word plain substring against the colored output: bat
# emits one SGR sequence PER TOKEN, so "fn main" is never contiguous there
# (measured — the bytes are `ESC[…mfn ESC[0m ESC[…mmain ESC[0m`). Asserting the
# two renders DIFFER is the theme-independent way to prove highlighting actually
# ran: if the syntax/theme assets failed to ship, bat would emit the plain text
# and the two would be byte-identical.
ocx.write_file("sample.rs", "fn main() { let x = 1; }\n")
r_plain_rs = ocx.run(
    BAT, "--no-config", "--plain", "--paging=never", "--color=never",
    "--language=rust", "sample.rs",
)
expect.ok(r_plain_rs)
expect.matches(r_plain_rs.stdout, r"^fn main\(\) \{ let x = 1; \}\r?\n?$")

r_hl = ocx.run(
    BAT, "--no-config", "--plain", "--paging=never", "--color=always",
    "--theme=Monokai Extended", "--language=rust", "sample.rs",
)
expect.ok(r_hl)
expect.matches(r_hl.stdout, r"\x1b\[")
expect.ne(r_hl.stdout, r_plain_rs.stdout)
expect.contains(r_hl.stdout, "main")

# The theme registry itself, independent of the render above. "Monokai
# Extended" is bat's default theme and a documented `--theme=` value, i.e. a
# stable identifier a user can type — not prose.
r_themes = ocx.run(BAT, "--no-config", "--list-themes", "--color=never")
expect.ok(r_themes)
expect.contains(r_themes.stdout, "Monokai Extended")

# No Tier 4: metadata.json declares PATH only (proven by Tier 1 liveness).

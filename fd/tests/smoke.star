# fd/tests/smoke.star — stable across upstream fd releases.
# Asserts the contract (exit code, version shape, exact result SET of a search
# over a hermetic tree), never help/version prose.
# See ocx.mirror testing-practices.md.

FD = "fd.exe" if ocx.target_platform.os == ocx.os.Windows else "fd"

# Tier 1 + 2: liveness on the composed PATH + version SHAPE (not the vendor
# banner, not the exact version — the digits are the contract).
r_version = ocx.run(FD, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: a real search over a hermetic tree.
#
# ⚠️ fd exits 0 on an EMPTY result set (measured), so `expect.ok` alone would
# pass against a binary that found nothing at all. The assertion that actually
# has teeth is the result COUNT: four files exist, the glob must select exactly
# the two named `needle.*`. A tool that degenerated into "list everything" gives
# 4 and reds; one that found nothing gives 0 and reds.
#
# `--no-ignore` makes the search independent of any .gitignore above the scratch
# root — the CI runner's workspace IS a git checkout, so without it an ignore
# rule outside the sandbox could silently shrink the result set.
ocx.mkdir("tree/sub")
ocx.write_file("tree/needle.txt", "x\n")
ocx.write_file("tree/haystack.txt", "x\n")
ocx.write_file("tree/sub/needle.md", "x\n")
ocx.write_file("tree/sub/other.md", "x\n")

r_find = ocx.run(FD, "--no-ignore", "--type", "f", "--glob", "needle.*", cwd = "tree")
expect.ok(r_find)

hits = [line for line in r_find.stdout.replace("\r", "").split("\n") if line]
expect.eq(len(hits), 2)
expect.true("needle.txt" in hits)
# Nested hit: fd prints paths relative to the search root, so the separator is
# `/` on unix and `\` on Windows — match either rather than branching.
expect.matches(r_find.stdout, r"sub[/\\]needle\.md")

# The extension filter is a second, independent selector over the same tree —
# it must pick the two .md files and neither .txt.
r_ext = ocx.run(FD, "--no-ignore", "--type", "f", "--extension", "md", cwd = "tree")
expect.ok(r_ext)
ext_hits = [line for line in r_ext.stdout.replace("\r", "").split("\n") if line]
expect.eq(len(ext_hits), 2)
expect.matches(r_ext.stdout, r"sub[/\\]other\.md")

# No Tier 4: metadata.json declares PATH only (proven by Tier 1 liveness).

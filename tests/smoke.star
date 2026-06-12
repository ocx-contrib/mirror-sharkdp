# tests/smoke.star — stable across upstream hyperfine releases.
# Asserts the contract (exit code, version shape, file side effect, stable
# JSON tokens), never help/version prose. See ocx.mirror testing-practices.md.

HYPERFINE = "hyperfine.exe" if ocx.target_platform.os == ocx.os.Windows else "hyperfine"

# Tier 1 + 2: liveness on the composed PATH + version SHAPE (not the vendor
# banner, not the exact version — the digits are the contract).
r_version = ocx.run(HYPERFINE, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: functional benchmark on a hermetic, cross-platform command — the
# bundled binary benchmarks itself. `-N` (--shell=none) execs directly so no
# system shell is required, and `--export-json` writes a deterministic result
# document. Assert the file side effect plus stable structural JSON tokens
# (schema keys, never prose) rather than any timing value.
r_bench = ocx.run(
    HYPERFINE, "-N", "--warmup", "1", "--runs", "2",
    "--export-json", "bench.json", HYPERFINE + " --version",
)
expect.ok(r_bench)
expect.true(ocx.exists("bench.json"))

bench = ocx.read_file("bench.json")
expect.contains(bench, "\"results\"")
expect.contains(bench, "\"mean\"")

# No Tier 4: metadata.json declares PATH only (proven by Tier 1 liveness).

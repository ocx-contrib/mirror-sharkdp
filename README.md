# mirror-sharkdp

OCX mirrors for the command-line tools published by
[sharkdp](https://github.com/sharkdp). One repository, one spec directory per
package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [bat](https://github.com/sharkdp/bat) | [`bat/mirror.yml`](bat/mirror.yml) | `ghcr.io/ocx-contrib/sharkdp/bat` | [`ocx.sh/sharkdp/bat`](https://index.ocx.sh/sharkdp/bat) | `MIT OR Apache-2.0` |
| [fd](https://github.com/sharkdp/fd) | [`fd/mirror.yml`](fd/mirror.yml) | `ghcr.io/ocx-contrib/sharkdp/fd` | [`ocx.sh/sharkdp/fd`](https://index.ocx.sh/sharkdp/fd) | `MIT OR Apache-2.0` |
| [hexyl](https://github.com/sharkdp/hexyl) | [`hexyl/mirror.yml`](hexyl/mirror.yml) | `ghcr.io/ocx-contrib/sharkdp/hexyl` | [`ocx.sh/sharkdp/hexyl`](https://index.ocx.sh/sharkdp/hexyl) | `MIT OR Apache-2.0` |
| [hyperfine](https://github.com/sharkdp/hyperfine) | [`hyperfine/mirror.yml`](hyperfine/mirror.yml) | `ghcr.io/ocx-contrib/sharkdp/hyperfine` | [`ocx.sh/sharkdp/hyperfine`](https://index.ocx.sh/sharkdp/hyperfine) | `MIT OR Apache-2.0` |
| [vivid](https://github.com/sharkdp/vivid) | [`vivid/mirror.yml`](vivid/mirror.yml) | `ghcr.io/ocx-contrib/sharkdp/vivid` | [`ocx.sh/sharkdp/vivid`](https://index.ocx.sh/sharkdp/vivid) | `MIT OR Apache-2.0` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

> This repository previously published hyperfine to the flat coordinate
> `ocx.sh/hyperfine`, as `mirror-hyperfine`. `sharkdp/hyperfine` is the grouped
> successor. The org is kept as the namespace because it is a real family —
> `bat`, `fd`, `hexyl` and `vivid` joined it as sibling directories on
> 2026-08-04.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
bat/ fd/ hexyl/ hyperfine/ vivid/
                        one directory per package, named exactly after it
└── mirror.yml          the spec — never at the repo root
    metadata.json       bundle interface
    CATALOG.md          → ocx package describe
    logo.svg / logo.png describe assets, 512px PNG
    tests/smoke.star    Starlark smoke test
```

`LICENSE` and `NOTICE.md` are shared at the root. Logos are **not** — each
package carries its own, because a repo-root `logo.*` sits in no workflow's
`paths:` filter, so replacing it would publish nothing until some unrelated
edit happened to fire.

⚠️ `extends:` is a **shallow** merge of top-level keys. A spec that restates
`platforms:` to change one runner drops every `containers:` entry with it, and
nothing reds — the legs simply stop existing, and every `os.features` claim
goes back to being asserted rather than verified. Restate a block in full or
not at all.

## Platforms

The packages do **not** share a platform set, and the differences are measured
rather than assumed:

| Package | Platforms | Notable |
|---|---|---|
| `bat` | 6 | both Linux, both macOS, both Windows. `windows/arm64` carries `min_version: 0.26.0` — that asset first appears in v0.26.0 |
| `fd` | 5 | **no `darwin/amd64`** — upstream ships no Intel Mac asset at all |
| `hexyl` | 5 | **no `windows/arm64`**. `darwin/arm64` carries `min_version: 0.16.0` — Apple Silicon first appears in v0.16.0 |
| `hyperfine` | 5 | **no `windows/arm64`** — upstream ships no aarch64 Windows asset |
| `vivid` | 5 | **no `windows/arm64`**. `darwin/arm64` carries `min_version: 0.11.0`. Every platform `exclude`s **v0.11.0** — see below |

**The Linux keys differ per package too.** `os.features` states what an artifact
requires *of the host*, so what decides the key is linkage, not the asset name:

| Package | `linux/amd64` | `linux/arm64` |
|---|---|---|
| `bat`, `fd` | **bare** — musl build is static | **bare** — musl build is static |
| `hexyl`, `hyperfine`, `vivid` | **bare** — musl build is static | **`+libc.glibc`** — no aarch64 musl asset exists |

For every package here, `x86_64-unknown-linux-musl` measures static-pie with no
`PT_INTERP` and no `DT_NEEDED`, so it requires nothing of the host and takes a
bare key. On arm64 the matrices diverge: bat and fd ship
`aarch64-unknown-linux-musl` (statically linked, `INTERP` segment count 0), so
their arm64 keys are bare as well; hexyl, hyperfine and vivid ship no such
asset — their only aarch64 Linux build is the gnu one, carrying `PT_INTERP
/lib/ld-linux-aarch64.so.1` and `NEEDED libgcc_s.so.1` — so their arm64 key must
be `+libc.glibc`.

That is exactly why **every spec here restates `platforms:` in full** instead of
inheriting it: `mirror-base.yml`'s block encodes hyperfine's asymmetry, and
`extends:` is a shallow merge. A new package must measure its own arm64 asset
before deciding whether to inherit — and even one whose libc facts match the
base exactly (hexyl) has to restate the whole block to add a single
per-platform `min_version`, because there is no per-key merge.

The `alpine:3.20` leg is what turns a bare key's universality claim into
evidence — bat and fd carry it on **both** arches; hexyl, hyperfine and vivid
carry it on amd64 only. A `+libc.glibc` key gets no alpine leg: the binary genuinely cannot load
under musl and the renderer rejects that leg at spec load (exit 65). The
measurements themselves are recorded above the `assets:` block in each spec.

The `-gnu` Linux builds exist for every package here and are deliberately not
carried: publishing them alongside a static build under `+libc.glibc` is legal
and resolves correctly by specificity scoring, but it only buys something where
musl's libc changes behaviour a user can reach — canonically DNS/NSS. None of
these tools opens a socket.

### vivid v0.11.0 is excluded on every platform

Upstream's `v0.11.0` release is a stale build: all 19 of its assets are named
`vivid-v0.10.1-*`, and the binary inside reports `vivid 0.10.1`. Mirroring it
would publish a 0.10.1 executable under the tag `0.11.0`, and **nothing would
red** — the asset patterns match, the archive layout is normal, and a smoke test
may not assert an exact version by fleet rule. It is dropped with a per-platform
`exclude` (`severity: broken`, defined once as a YAML anchor and aliased into
every platform), which is the documented lever for a known-bad release and
keeps the perfectly good `0.10.1` in range. `v0.11.1-pre` needs no such handling
— it is a prerelease by the API flag *and* fails the anchored tag pattern.

## The binaries claim

sharkdp's release archives all share one layout — a single
`<tool>-v<ver>-<triple>/` wrapper holding the executable at its **root**, beside
`README.md`, `LICENSE-*`, `<tool>.1` and — for all but hexyl, which generates
completions on demand instead — `autocomplete/` (an empty directory in vivid's
archives). This holds for the `.tar.gz` and the `.zip` alike, so one
`strip_components: 1` serves every platform and no per-platform `asset_type`
override is needed.

After the strip the bundle's only PATH entry is therefore a bare
`${installPath}` — the executable *is* the content root. `bin_scan` only looks
*below* an `${installPath}/<dir>` entry, so `auto`/`verify` is rejected at spec
load with exit 65 (`the verification would inspect no file and pass green
whatever the archive contains`). `mirror-base.yml` therefore sets
`bin_scan: off` and each package's `metadata.json` hand-lists its single binary
(`["bat"]`, `["fd"]`, `["hexyl"]`, `["hyperfine"]`, `["vivid"]`) — the blessed
shape for this layout.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `<pkg>/mirror.yml` | hand | yes — see below |
| `<pkg>/{metadata.json,CATALOG.md,logo.*}` | hand | — |
| `<pkg>/tests/smoke.star` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

```bash
ocx-mirror package pipeline generate ci \
  --spec bat/mirror.yml --spec fd/mirror.yml --spec hexyl/mirror.yml \
  --spec hyperfine/mirror.yml --spec vivid/mirror.yml
```

**Name every spec.** `--spec` *appends* rather than replaces, so a command
naming a subset silently stops rendering the rest while staying green — and the
drift guard reds on a generated workflow the current spec set no longer
produces.

`verify-generated.yml` exits 65 on drift. If a generated workflow is wrong, the
spec or the renderer template is wrong — fix it there and regenerate.

Run `direnv allow` once to put the pinned toolchain on `PATH`, and invoke
`ocx-mirror` directly — never `ocx run -- ocx-mirror`, which pins
`OCX_BINARY_PIN` to the bootstrap `ocx` and false-reds the nested push.

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_ANNOUNCE_TOKEN` | opens the index pull request from the `ocx-contrib/index` fork |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

(Inherited from the `ocx-contrib` org with visibility ALL. GHCR pushes use the
run's own `GITHUB_TOKEN` — no registry secret needed.)

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets are out of scope; each
package's redistribution license is recorded in [`NOTICE.md`](NOTICE.md).

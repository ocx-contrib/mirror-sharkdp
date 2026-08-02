# mirror-sharkdp

OCX mirrors for the command-line tools published by
[sharkdp](https://github.com/sharkdp). One repository, one spec directory per
package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [hyperfine](https://github.com/sharkdp/hyperfine) | [`hyperfine/mirror.yml`](hyperfine/mirror.yml) | `ghcr.io/ocx-contrib/sharkdp/hyperfine` | `ocx.sh/sharkdp/hyperfine` | `MIT OR Apache-2.0` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

> This repository previously published the same upstream to the flat coordinate
> `ocx.sh/hyperfine`, as `mirror-hyperfine`. `sharkdp/hyperfine` is the grouped
> successor. The org is kept as the namespace because it is a real prospective
> family — `bat` and `fd` would join it as sibling directories here.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
hyperfine/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface
├── CATALOG.md          → ocx package describe
├── logo.svg / logo.png describe assets, 512px PNG
└── tests/smoke.star    Starlark smoke test
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

`hyperfine` publishes five platform entries: both Linux arches, both macOS
arches, and `windows/amd64`. There is no `windows/arm64` — upstream ships
`x86_64-pc-windows-msvc` and the 32-bit `i686-pc-windows-msvc` and nothing else.

**The Linux keys are asymmetric, and deliberately so.** `os.features` states
what an artifact requires *of the host*, and upstream's Rust release matrix does
not offer the same choice on both arches:

| Key | Asset | Measured | Container legs |
|---|---|---|---|
| `linux/amd64` | `x86_64-unknown-linux-musl` | static-pie, no `PT_INTERP`, no `DT_NEEDED` → requires nothing → **bare** | ubuntu + **alpine** + fedora |
| `linux/arm64+libc.glibc` | `aarch64-unknown-linux-gnu` | `PT_INTERP /lib/ld-linux-aarch64.so.1`, `NEEDED libgcc_s.so.1` → **`+libc.glibc`** | ubuntu + fedora, **no alpine** |

There is **no `aarch64-unknown-linux-musl` asset upstream** — the only other
ARM Linux build is `arm-unknown-linux-musleabihf`, which is 32-bit armv7 — so
arm64 cannot be made bare. The `alpine:3.20` leg on the amd64 key is what turns
its universality claim into evidence; the arm64 key gets no alpine leg because
the binary genuinely cannot load under musl and the renderer rejects the leg at
spec load (exit 65). The measurements themselves are recorded above the
`assets:` block in `hyperfine/mirror.yml`.

## The binaries claim

sharkdp's release archives put the executable at the archive **root**, beside
`README.md`, `LICENSE-*`, `hyperfine.1` and `autocomplete/`. After
`strip_components: 1` the bundle's only PATH entry is therefore a bare
`${installPath}` — the executable *is* the content root. `bin_scan` only looks
*below* an `${installPath}/<dir>` entry, so `auto`/`verify` is rejected at spec
load with exit 65 (`the verification would inspect no file and pass green
whatever the archive contains`). `mirror-base.yml` therefore sets
`bin_scan: off` and `hyperfine/metadata.json` hand-lists
`binaries: ["hyperfine"]` — the blessed shape for this archive layout.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `hyperfine/mirror.yml` | hand | yes — see below |
| `hyperfine/{metadata.json,CATALOG.md,logo.*}` | hand | — |
| `hyperfine/tests/smoke.star` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

```bash
ocx-mirror package pipeline generate ci --spec hyperfine/mirror.yml
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

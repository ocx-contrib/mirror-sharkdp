# NOTICE

This repository packages and redistributes upstream software published by
[David Peter ("sharkdp")](https://github.com/sharkdp). The Apache-2.0 license in
[`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It does
**not** cover any upstream-derived asset — each package's redistributed bytes
carry their own license, recorded below.

Each package's logo is reproduced for catalog identification only, under
nominative fair use. The marks remain the property of their respective owners
and no endorsement is implied.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `bat` | `ghcr.io/ocx-contrib/sharkdp/bat` | `MIT OR Apache-2.0` |
| `fd` | `ghcr.io/ocx-contrib/sharkdp/fd` | `MIT OR Apache-2.0` |
| `hexyl` | `ghcr.io/ocx-contrib/sharkdp/hexyl` | `MIT OR Apache-2.0` |
| `hyperfine` | `ghcr.io/ocx-contrib/sharkdp/hyperfine` | `MIT OR Apache-2.0` |
| `vivid` | `ghcr.io/ocx-contrib/sharkdp/vivid` | `MIT OR Apache-2.0` |

---

## `bat`

Upstream: <https://github.com/sharkdp/bat>
Published to `ghcr.io/ocx-contrib/sharkdp/bat`.

| Component | SPDX | Holder |
|---|---|---|
| bat (`bat`) | **MIT OR Apache-2.0** | Copyright (c) 2018-2021 bat-developers |

Permissive dual license — the recipient may take either arm. Redistribution of
the compiled binary is granted provided the copyright and permission notices are
retained, and they are: every release archive ships `LICENSE-APACHE` and
`LICENSE-MIT` beside the executable, and both are republished inside the OCX
bundle. The canonical texts are
<https://github.com/sharkdp/bat/blob/master/LICENSE-MIT> and
<https://github.com/sharkdp/bat/blob/master/LICENSE-APACHE>; the SPDX expression
is taken from upstream's `Cargo.toml` (`license = "MIT OR Apache-2.0"`), not
from the GitHub license API, which reports only one of the two files. The
published binaries statically link third-party Rust crates under permissive
licenses, enumerated in upstream's `Cargo.lock`. They additionally embed syntax
definitions and themes sourced from third-party Sublime Text packages, which
upstream tracks as git submodules under `assets/` (see `.gitmodules`), each
carrying its own permissive license; those assets are compiled into the
executable and are not separately extractable from the release archive.

The bat name is used for catalog identification under nominative fair use. The
logo shipped with this package is an OCX-authored mark, not an official bat
mark — upstream's own `doc/logo-header.svg` is a wide wordmark banner and is not
reproduced here.

---

## `fd`

Upstream: <https://github.com/sharkdp/fd>
Published to `ghcr.io/ocx-contrib/sharkdp/fd`.

| Component | SPDX | Holder |
|---|---|---|
| fd (`fd`) | **MIT OR Apache-2.0** | Copyright (c) 2017-present The fd developers |

Permissive dual license — the recipient may take either arm. Redistribution of
the compiled binary is granted provided the copyright and permission notices are
retained, and they are: every release archive ships `LICENSE-APACHE` and
`LICENSE-MIT` beside the executable, and both are republished inside the OCX
bundle. The canonical texts are
<https://github.com/sharkdp/fd/blob/master/LICENSE-MIT> and
<https://github.com/sharkdp/fd/blob/master/LICENSE-APACHE>; the SPDX expression
is taken from upstream's `Cargo.toml` (`license = "MIT OR Apache-2.0"`), not
from the GitHub license API, which reports only one of the two files. The
published binaries statically link third-party Rust crates under permissive
licenses, enumerated in upstream's `Cargo.lock`.

The fd name is used for catalog identification under nominative fair use. The
logo shipped with this package is an OCX-authored mark, not an official fd mark.
Upstream does publish a square `doc/logo.svg`, but its wordmark is live text
bound to two fonts it does not bundle (`Fira Sans Condensed`, `Source Code Pro`),
so it renders in an arbitrary fallback face wherever those are absent; an
OCX-authored geometric mark is shipped instead, consistent with the other
packages in this repository.

---

## `hexyl`

Upstream: <https://github.com/sharkdp/hexyl>
Published to `ghcr.io/ocx-contrib/sharkdp/hexyl`.

| Component | SPDX | Holder |
|---|---|---|
| hexyl (`hexyl`) | **MIT OR Apache-2.0** | Copyright (c) 2018-2021 David Peter |

Permissive dual license — the recipient may take either arm. Redistribution of
the compiled binary is granted provided the copyright and permission notices are
retained, and they are: every release archive ships `LICENSE-APACHE` and
`LICENSE-MIT` beside the executable, and both are republished inside the OCX
bundle. The canonical texts are
<https://github.com/sharkdp/hexyl/blob/master/LICENSE-MIT> and
<https://github.com/sharkdp/hexyl/blob/master/LICENSE-APACHE>; the SPDX
expression is taken from upstream's `Cargo.toml`, which uses Cargo's deprecated
slash spelling (`license = "MIT/Apache-2.0"`) of the same dual grant, rather
than from the GitHub license API, which reports only one of the two files. The
published binaries statically link third-party Rust crates under permissive
licenses, enumerated in upstream's `Cargo.lock`.

The hexyl name is used for catalog identification under nominative fair use. The
logo shipped with this package is an OCX-authored mark, not an official hexyl
mark — upstream's own `doc/logo.svg` is a 400×200 wordmark banner and does not
fit the square 512px describe asset, the same situation as `bat`.

---

## `hyperfine`

Upstream: <https://github.com/sharkdp/hyperfine>
Published to `ghcr.io/ocx-contrib/sharkdp/hyperfine`.

| Component | SPDX | Holder |
|---|---|---|
| hyperfine (`hyperfine`) | **MIT OR Apache-2.0** | Copyright (c) 2018 David Peter |

Permissive dual license — the recipient may take either arm. Redistribution of
the compiled binary is granted provided the copyright and permission notices are
retained, and they are: every release archive ships `LICENSE-APACHE` and
`LICENSE-MIT` beside the executable, and both are republished inside the OCX
bundle. The canonical texts are
<https://github.com/sharkdp/hyperfine/blob/master/LICENSE-MIT> and
<https://github.com/sharkdp/hyperfine/blob/master/LICENSE-APACHE>; the SPDX
expression is taken from upstream's `Cargo.toml` (`license = "MIT OR
Apache-2.0"`), not from the GitHub license API, which reports only one of the
two files. The published binaries statically link third-party Rust crates under
permissive licenses, enumerated in upstream's `Cargo.lock`.

The hyperfine name is used for catalog identification under nominative fair use.
The logo shipped with this package is an OCX-authored lettermark, not an
official hyperfine mark.

---

## `vivid`

Upstream: <https://github.com/sharkdp/vivid>
Published to `ghcr.io/ocx-contrib/sharkdp/vivid`.

| Component | SPDX | Holder |
|---|---|---|
| vivid (`vivid`) | **MIT OR Apache-2.0** | Copyright (c) 2018 David Peter |

Permissive dual license — the recipient may take either arm. Redistribution of
the compiled binary is granted provided the copyright and permission notices are
retained, and they are: every release archive ships `LICENSE-APACHE` and
`LICENSE-MIT` beside the executable, and both are republished inside the OCX
bundle. The canonical texts are
<https://github.com/sharkdp/vivid/blob/master/LICENSE-MIT> and
<https://github.com/sharkdp/vivid/blob/master/LICENSE-APACHE>; the SPDX
expression is taken from upstream's `Cargo.toml`, which uses Cargo's deprecated
slash spelling (`license = "MIT/Apache-2.0"`) of the same dual grant, rather
than from the GitHub license API, which reports only one of the two files. The
published binaries statically link third-party Rust crates under permissive
licenses, enumerated in upstream's `Cargo.lock`. They additionally embed
upstream's own theme set (`themes/`) and filetype database (`config/`), which
are part of the same repository and carry the same dual license; those assets
are compiled into the executable and are not separately extractable from the
release archive.

The vivid name is used for catalog identification under nominative fair use. The
logo shipped with this package is an OCX-authored mark; upstream publishes no
logo of its own.

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.

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
| `hyperfine` | `ghcr.io/ocx-contrib/sharkdp/hyperfine` | `MIT OR Apache-2.0` |

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

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.

# Security

## Reporting a vulnerability

Open a private security advisory on this repository ( Security tab, "Report a vulnerability" ). Do not open a public issue for security reports.

## Trust model

- This repository is a fork of `Wandalen/wretry.action` maintained on a personal account. The action runs inside the caller's job, so it can read every secret and token that the job exposes to it. Treat a change to this action like a change to any other privileged step in your pipeline.
- The runnable action exists only in release commits. `master` contains sources only, without `node_modules`.
- Release tags ( `vX.Y.Z` and the moving major tag `vX` ) are created only by `.github/workflows/release.yml`. The workflow runs from `master`, requires approval of the `release` environment, builds the artifact twice and requires identical sha256, runs the verification suite, and publishes a tarball with a build provenance attestation.
- Verify a release tarball with `gh attestation verify wretry.action-vX.Y.Z.tar.gz --repo fzangrande/wretry.action`.

## Consuming the action

| Pin | Behavior | Use when |
|---|---|---|
| `@vX` | Moves with every release of that major version. | You accept the maintainer's release process as your review. |
| `@vX.Y.Z` | Tag of one release. Tags are not meant to move, but a tag is mutable unless protected. | You want a stable version and review before upgrading. |
| `@<sha>` of the release commit | Immutable. Obtain it with `git ls-remote --tags https://github.com/fzangrande/wretry.action 'vX.Y.Z^{}'`. | You need deterministic builds or must audit each version. |

Only the commit of a release tag is runnable. Commits on `master` are not.

## Data handled by the action

- `github_token` is used to clone the wrapped action over HTTPS through a temporary `http.<server>/.extraheader` git config. The config is set in the process environment only for the clone and restored afterwards, and the token is redacted from logs.
- The token is also passed to the wrapped action as its own `github_token` input, so the wrapped action receives the same access that you gave to this one.
- The action does not make network calls other than cloning the wrapped action and, on Windows only when `time_out` is set, cloning `Wandalen/wProcessTreeWindows` pinned to a fixed commit.
- Docker-based wrapped actions run through `docker run` with the Docker socket mounted, as the runner does for native Docker actions. Do not wrap untrusted Docker actions.

## Maintenance and continuity

- Releases require the approval of a reviewer of the `release` environment.
- If the maintainer account becomes unavailable, consumers should pin an exact tag or commit SHA and fall back to `Wandalen/wretry.action@v3.8.0` or to separate retry steps until the repository is transferred.

## Dependencies

- `github-actions-parser` is installed from a git commit pinned by SHA in `package.json`. The `package-lock.json` pins every other dependency.
- Release builds use `npm ci --ignore-scripts` and pinned GitHub Actions.

# ci-app-playground

A throwaway, synthetic repository for testing the portable CI pipeline
([dagger-ci](https://github.com/slice-abhinavgautam/dagger-ci)) end to end with a GitHub App:
check runs posted by the App, and a ruleset that blocks merging until the App reports green.

Nothing here is real configuration. Do not copy company code or secrets into this repository.

## What is here

| Path | Purpose |
|---|---|
| `.ci/pipeline.yaml` | `kind: demo` (no platform steps); `smoke` is required |
| `.ci/checks/smoke.sh` | Required. Each `apps/<name>/config.env` must have `APP_NAME=<name>` and a numeric `REPLICAS` |
| `.ci/checks/yaml-valid.py` | Reports only. Every YAML file under `apps/` must parse |
| `.ci/checks/changed-files.sh` | Reports only. Prints `BRANCH`, `BASE`, `HEAD` and `ALL_CHANGED`; always passes |
| `apps/hello`, `apps/world` | Fake apps the checks look at |

## Setup

1. Create the GitHub App (Settings → Developer settings → GitHub Apps → New):
   - Webhook: **Active unchecked**
   - Repository permissions: **Checks: Read and write**, **Contents: Read-only**, **Pull requests: Read-only**
   - Installable: only on this account
   - Generate a private key and keep the `.pem` local (`chmod 600`)
2. Push this repository to GitHub (public, so rulesets work on a free account) and install the App on it only.
   The installation ID is the number in `github.com/settings/installations/<id>`.
3. Add a branch ruleset on `main`: **Require status checks to pass**, check `ci / smoke`, source = the App.

## Test

Open a PR (for example the `break-smoke` branch below), then run:

```sh
dagger call -m <path-to>/dagger-ci run-pull-request \
  --repo=<you>/ci-app-playground --number=<pr> \
  --github-app-id=<app id> --github-installation-id=<installation id> \
  --github-app-key=file://<path-to>/key.pem
```

Expected:

- The PR shows `ci / smoke`, `ci / yaml-valid` and `ci / changed-files`, posted by the App.
- With a broken `config.env`, `ci / smoke` is red and **merging is blocked** by the ruleset.
- After pushing a fix and running again, `ci / smoke` turns green on the new commit and merging is allowed.

To break it on purpose:

```sh
git switch -c break-smoke
sed -i '' 's/REPLICAS=2/REPLICAS=two/' apps/hello/config.env
git commit -am "break smoke on purpose"
```
# superseded test 1792058705

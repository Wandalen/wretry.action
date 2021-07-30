
# action::wretry.action  [![status](https://github.com/Wandalen/wretry.action/actions/workflows/StandardPush.yml/badge.svg)](https://github.com/Wandalen/wretry.action/actions/workflows/StandardPush.yml) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Retries an Github Action step on failure.

This action is intended to wrap Github actions based on NodeJS interpreter.

## Why

Github actions which use an Internet connection can fail when connection is lost :

```bash
Run actions/setup-node@v1
connect ETIMEDOUT 104.20.22.46:443
Waiting 15 seconds before trying again
connect ETIMEDOUT 104.20.22.46:443
Waiting 18 seconds before trying again
Error: connect ETIMEDOUT 104.20.22.46:443
```

It is a cause of failed jobs. For this case, the action `wretry.action` can retry the action immediately after fail or with some delay. And if the connection will be restored, then the job will continue the normal run.

## Inputs

### `action`

**Required** The name of the Github action.

### `with`

An options map for Github action. It is a multiline string with pairs `key - value`.

### `attempt_limit`

Set number of attempts. Default is 2.

### `attempt_delay`

Set delay between attempts in ms. Default is 0.

## Outputs

Depends on output of given Github action.

## Example usage

```yaml
uses: Wandalen/wretry.action@0.1.0
with:
  action: action/node-setup@2.3.0
  with: |
    node-version: 14.x
    architecture: x64
  attempt_limit: 3
  attempt_delay: 2000
```

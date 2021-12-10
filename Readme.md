
# action::retry [![status](https://github.com/Wandalen/wretry.action/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wretry.action/actions/workflows/StandardPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Retries an Github Action step or command on failure.

This action is intended to wrap Github actions based on NodeJS interpreter and shell commands.

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

## Features

- Retries Github actions. The action can be an action repository that is not published on `Marketplace`.
- Retries shell command.
- Always has `pre` and `post` stages. If external action has `pre` or/and `post` stage, then action run it also.
- Retries only `main` action script. Retries no `pre` and `post` stages of external actions.
- Handles no conditions in external actions. All stages of external action will be performed.
- Retries actions with defined number of attempts ( default is 2 ).
- Retries actions with defined delay between attempts ( default is 0 ).

## Inputs

### `action`

The name of the Github action.

### `command`

The command to run.

**Attend**. Action requires defined `action` or `command`. If the fields `action` and `commands` are defined simultaneously, then action will throw error.

### `with`

An options map for Github action. It is a multiline string with pairs `key : value`.

### `attempt_limit`

Set number of attempts. Default is 2.

### `attempt_delay`

Set delay between attempts in ms. Default is 0.

## Outputs

Depends on output of given Github action.

## Example usage

### Retry action

```yaml
uses: Wandalen/wretry.action@0.2.7
with:
  action: action/node-setup@2.3.0
  with: |
    node-version: 14.x
    architecture: x64
  attempt_limit: 3
  attempt_delay: 2000
```

### Retry command

```yaml
uses: Wandalen/wretry.action@0.2.7
with:
  command: npm i
  attempt_limit: 3
  attempt_delay: 2000
```

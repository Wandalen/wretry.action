# wretry.action

Retries an Github Action step on failure.

This action is intended to wrap Github actions based on NodeJS interpreter.

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
uses: Wandalen/wrerun.action@bbb9aecb9c675a9d0438a070cb42657a8125f4aa
with:
  action: action/node-setup@2.3.0
  with: |
    node-version: 14.x
    architecture: x64
  attempt_limit: 3
  attempt_delay: 2000
```

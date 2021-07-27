# wretry.action

Retries an Github Action step on failure.

This action is intended to wrap Github actions based on NodeJS interpreter.

## Inputs

### `action`

**Required** The name of the Github action.

### `options`

An options map for Github action.

### `attempt_limit`

Set number of attempts. Default is 2.

## Outputs

Depends on output of given Github action.

## Example usage

```yaml
uses: actions/wrerun.action@v1
with:
  action: action/node-setup@2.3.0
  with:
    node-version: 14.x
  attempt_limit: 3
```

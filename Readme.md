[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://stand-with-ukraine.pp.ua)

# action::retry [![status](https://github.com/Wandalen/wretry.action/actions/workflows/JsActionPublish.yml/badge.svg)](https://github.com/Wandalen/wretry.action/actions/workflows/JsActionPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Retries an Github Action step or a command on failure.

Works with either shell commands or other actions to retry.

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

- Retries Github `JavaScript` actions. The action can be an action repository that is not published on `Marketplace`.
- Retries Github `Docker` actions which use `Dockerfile` as image.
- Retries shell commands.
- Can retry single action or single command ( multiline command ), but not both simultaneously.
- Retries `main`, `pre` and `post` stages of external actions.
- Always has `pre` and `post` stages. If external action has `pre` or/and `post` stage, then action run it also.
- Handles no conditions in external actions ( fields `pre-if` and `post-if` ). All stages of external action will be performed.
- Resolves external action default inputs from next contexts : `github`, `env`, `job`, `matrix`.
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

An example of declaration of option with single line value :
```yaml

- uses: Wandalen/wretry.action@master
  with:
    action: owner/action-repo@version
    with: |
      option1: value
      option2: value
```
An example of declaration of option with multiline string :
```yaml

- uses: Wandalen/wretry.action@master
  with:
    action: owner/action-repo@version
    with: |
      option1: |
        value1
        value2
          value3
      option2: value
```

### `current_path`

Setup working directory for the action. Works with only commands. Default is `github.workspace` path.

### `env_context`

Pass context `env` into an external action. Action cannot resolve separate environments of workflow at the startup and provide all environments. If you need valid context `env`, then add option `env_context : ${{ toJSON( env ) }}`.

### `github_context`

Pass context `github` into an external action. Default is global context `github`.

### `job_context`

Pass context `job` into an external action. Default is context `job` of a job.

### `matrix_context`

Pass context `matrix` into an external action. Default is context `matrix` of a job.

### `attempt_limit`

Set number of attempts. Default is 2.

### `attempt_delay`

Set delay between attempts in ms. Default is 0.

## Outputs

Depends on output of given Github action.

## Example usage

### Retry action

```yaml
- uses: Wandalen/wretry.action@master
  with:
    action: action/setup-node@2.3.0
    with: |
      node-version: 14.x
      architecture: x64
    attempt_limit: 3
    attempt_delay: 2000
```

### Retry command

```yaml
- uses: Wandalen/wretry.action@master
  with:
    command: npm i
    attempt_limit: 3
    attempt_delay: 2000
```

### Development and contributing

To build compiled dependencies utility `willbe` is required. To install utility run :

```
npm i -g 'willbe@latest'
```

`willbe` is not required to use the action in your project as submodule.

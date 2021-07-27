
# module::Procedure [![status](https://github.com/Wandalen/wProcedure/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wProcedure/actions/workflows/StandardPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Minimal programming interface to launch, stop and track collection of asynchronous procedures. It prevents an application from termination waiting for the last procedure and helps to diagnose your system with many interdependent procedures

### Try out from the repository

```
git clone https://github.com/Wandalen/wProcedure
cd wProcedure
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wprocedure@stable'
```

`Willbe` is not required to use the module in your project as submodule.


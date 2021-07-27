
# module::Verbal [![status](https://github.com/Wandalen/wVerbal/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wVerbal/actions/workflows/StandardPublish.yml) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Verbal is small mixin which adds verbosity control to your class. It tracks verbosity changes, reflects any change of verbosity to instance's components, and also clamp verbosity in [ 0 .. 9 ] range. Use it as a companion for a logger, mixing it into logger's carrier.

### Try out from the repository

```
git clone https://github.com/Wandalen/wVerbal
cd wVerbal
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wverbal@stable'
```

`Willbe` is not required to use the module in your project as submodule.


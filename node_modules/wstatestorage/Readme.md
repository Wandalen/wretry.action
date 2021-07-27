
# module::StateStorage [![status](https://github.com/Wandalen/wStateStorage/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wStateStorage/actions/workflows/StandardPublish.yml) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Mixin to add persistent state storing functionality to a class. StateStorage solves the common problem to persistently store the state of an object. It let save the state in a specific moment ( for example on process exit ) and to restore the state later ( for example on process start ). Use the module to be more cross-platform, don't repeat yourself and forget about details of implementation you don't worry.

### Try out from the repository

```
git clone https://github.com/Wandalen/wStateStorage
cd wStateStorage
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wstatestorage@stable'
```

`Willbe` is not required to use the module in your project as submodule.


# module::Files [![status](https://img.shields.io/circleci/build/github/Wandalen/wFiles?label=Test&logo=Test)](https://circleci.com/gh/Wandalen/wFiles) [![status](https://github.com/Wandalen/wFiles/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wFiles/actions/workflows/StandardPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Collection of classes to abstract files systems. Many interfaces provide files, but not called as file systems and treated differently. For example server-side gives access to local files and browser-side HTTP/HTTPS protocol gives access to files as well, but in the very different way, it does the first. This problem forces a developer to break fundamental programming principle DRY and make code written to solve a problem not applicable to the same problem, on another platform/technology.

Files treats any file-system-like interface as files system. Files combines all files available to the application into the single namespace where each file has unique Path/URI, so that operating with several files on different files systems is not what user of the module should worry about. If Files does not have an adapter for your files system you may design it providing a short list of simple methods fulfilling completely or partly good defined API and get access to all sophisticated general algorithms on files for free. Is concept of file applicable to external entities of an application? Files makes possible to treat internals of a program as files system(s). Use the module to keep DRY.

### Try out from the repository

```
git clone https://github.com/Wandalen/wFiles
cd wFiles
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project
```
npm add 'wfiles@stable'
```

`Willbe` is not required to use the module in your project as submodule.

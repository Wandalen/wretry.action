# module::FilesArchive [![status](https://github.com/Wandalen/wFilesArchive/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wFilesArchive/actions/workflows/StandardPublish.yml) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Experimental. Several classes to reflect changes of files on dependent files and keep links of hard linked files. FilesArchive provides means to define interdependence between files and to forward changes from dependencies to dependents. Use FilesArchive to avoid unnecessary CPU workload.

### Try out from the repository

```
git clone https://github.com/Wandalen/wFilesArchive
cd wFilesArchive
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wfilesarchive@stable'
```

`Willbe` is not required to use the module in your project as submodule.


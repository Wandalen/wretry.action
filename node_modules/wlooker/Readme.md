
# module::Looker  [![status](https://github.com/Wandalen/wLooker/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wLooker/actions/workflows/StandardPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Collection of routines to traverse complex data structure. The module takes care of cycles in a data structure( recursions ) and can be used for comparison, cloning, serialization or operation on several similar data structures. Many other modules based on this to traverse abstract data structures.

### Relations diagram

<div align="center">
		<img src="./doc/images/ClassDiagram.png" width="50%" height="50%">
</div>

The diagram above displays the connections between classes Looker, [Replicator](https://github.com/Wandalen/wReplicator), [Stringer](https://github.com/Wandalen/wStringer), [Selector](https://github.com/Wandalen/wSelector), [Resolver](https://github.com/Wandalen/wResolver) and [Equaler](https://github.com/Wandalen/wEqualer). The solid lines indicate inheritance between classes, where the arrow indicates the parent class. The dashed lines indicate the use of classes, where the arrow indicates the class used by another. The diagram shows that Looker is the basic class, and it's inherited by others.

### Sample

```js

let structure =
{
  number : 1,
  string : 's',
  array : [ 1, { date : new Date() } ],
  routine : function(){},
  set : new Set([ 'a', 13 ]),
  hasmap : new HashMap([ [ 'a', 13 ], [ null, 0 ] ]),
}

_.look( structure, ( e, k, it ) => console.log( it.path ) );

/* output :
/
/number
/string
/array
/array/#0
/array/#1
/array/#1/date
/routine
/set
/set/a
/set/#1
/hasmap
/hasmap/a
/hasmap/#1
*/

```

[Source](./sample/trivial/Sample.s)

### Try out from the repository

```
git clone https://github.com/Wandalen/wLooker
cd wLooker
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wlooker@stable'
```

`Willbe` is not required to use the module in your project as submodule.

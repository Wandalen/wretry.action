
# module::ArraySorted [![status](https://github.com/Wandalen/wArraySorted/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wArraySorted/actions/workflows/StandardPublish.yml) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Collection of cross-platform routines to operate effectively sorted arrays. For that ArraySorted provides customizable quicksort algorithm and a dozen functions to optimally find/add/remove single/multiple elements into a sorted array, add/remove sorted array to/from another sorted array. Use it to increase the performance of your algorithms.

### Try out from the repository

```
git clone https://github.com/Wandalen/wArraySorted
cd wArraySorted
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'warraysorted@stable'
```

`Willbe` is not required to use the module in your project as submodule.

#### Binary search
Binary search algorithm is used for finding an item from an ordered list of elements. Its based on dividing in half the part of list that can contain the element, until the count of the possible locations is decreased to just one. [More about binary search.]( https://en.wikipedia.org/wiki/Binary_search_algorithm )

#### Comparator vs Evaluator
* Comparator - function that makes comparison between two values of two elements.

Default comparator looks like:
```javascript
function comparator( a, b )
{
  return a - b;
}
```
* Evaluator - function that makes some operations on passed values before they will be compared
default comparison in that case looks like :
`evaluator( a ) - evaluator( b )`

Both can be combined together to perform some custom features.
[<b>See examples.</b>]( https://github.com/Wandalen/wArraySorted/blob/master/sample/ComparatorTransformer.js )

#### Difference between Index,Value and no-sufix versions
* Index  methods returns index of element as result or -1 if nothing founded.
* Value methods returns element value as result or undefined if nothing founded.
* Non sufix methods returns object with properties: value, index if element exists.
Otherwise returns object with undefined as value and -1 as index.

  [<b>Examples.</b>]( https://github.com/Wandalen/wArraySorted/blob/master/sample/IndexValueDifference.js )



## Methods

* arraySortedLookUp - binary search of element in array, returns object containing properties: value, index. If nothing founded returns object with value property setted to undefined and index to -1.

* arraySortedLookUpIndex - binary search of element in array, returns index of the element if it is found, otherwise returns -1.

* arraySortedLookUpClosest - binary search of element in array, finds element equal to passed value or element with smallest possible difference. Returns object with properties: value, index. If nothing founded returns zero or length of array as index, it depends on element value, if its bigger/lower then last/first element of the array.

* arraySortedLookUpInterval - looks for elements from passed interval that exists in array and returns range where this elements are locaded.

* arraySortedLookUpEmbrace - returns range where all elements from interval can be located even if they do not exist in the current array, range can go out of interval boundaries for minimal possible value.

* arraySortedLeftMostIndex - returns index of first element that is equal or bigger with smallest difference to passed value.

* arraySortedRightMostIndex - returns index of last element that is equal or bigger with smallest difference to passed value.

* arraySortedAdd - method adds the passed value to the array, no matter whether it has there or hasn't, and returns the new added or the updated index.

#### Example #1
```javascript
let _ = wTools;

let arr = [ 3,5,6,7,9 ];
let e = 5
let i = _.arraySortedLookUp( arr,e );
console.log( 'arraySortedLookUp(',e,') :',i );
// arraySortedLookUp( 5 ) : { value: 5, index: 1 }
```

#### Example #2
```javascript
let _ = wTools;

let arr = [ 3,5,6,7,9 ];
let e = 4
let i = _.arraySortedLookUpIndex( arr,e );
console.log( 'arraySortedLookUpIndex(',e,') :',i );
// arraySortedLookUpIndex( 4 ) : -1
```

#### Example #3
```javascript
let _ = wTools;

let arr = [ 1,2,5,9 ];
let e = 4
let i = _.arraySortedLookUpClosest( arr,e );
console.log( 'arraySortedLookUpClosest(',e,') :',i );
// arraySortedLookUpClosest( 4 ) : { value: 5, index: 2 }
```

#### Example #4
```javascript
let _ = wTools;

let arr = [ 0,1,4,5 ];

let interval = [ 2, 5 ];

let range = _.arraySortedLookUpInterval( arr,interval );
console.log( 'arraySortedLookUpInterval(',interval,') :',range );
// arraySortedLookUpInterval( [ 2, 5 ] ) : [ 2, 4 ]

let range = _.arraySortedLookUpEmbrace( arr,interval );
console.log( 'arraySortedLookUpEmbrace(',interval,') :',range );
 // arraySortedLookUpEmbrace( [ 2, 5 ] ) : [ 1, 4 ]
```
For more examples see: [samples/Interval.js](https://github.com/Wandalen/wArraySorted/blob/master/sample/Interval.js), [samples/Embrace.js](https://github.com/Wandalen/wArraySorted/blob/master/sample/Embrace.js), [sample/LookUpDifference.js](https://github.com/Wandalen/wArraySorted/blob/master/sample/LookUpDifference.js)

#### Example #5
```javascript
let _ = wTools;

let arr = [ 0,0,0,0,1,1,1,1 ];

let e = 1;
let leftMost = _.arraySortedLeftMostIndex( arr, e );
console.log( 'arraySortedLeftMostIndex(',e,') :',leftMost );
// arraySortedLeftMostIndex( 1 ) : 4

let e = 0;
let rightMost = _.arraySortedRightMostIndex( arr, 0 );
console.log( 'arraySortedRightMostIndex(',e,') :',rightMost );
// arraySortedRightMostIndex( 0 ) : 3
```
#### Example #6
```javascript
let _ = wTools;
let arr = [ 1,2,5,9 ];

let e = 0;
let i = _.arraySortedAdd( arr,e );
console.log( 'arraySortedAdd(',e,') inserted to index :',i, "array: ", arr );
// arraySortedAdd( 0 ) inserted to index : 0 array:  [ 0, 1, 2, 5, 9 ]
```































































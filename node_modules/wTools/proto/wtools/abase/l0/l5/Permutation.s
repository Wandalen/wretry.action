( function _l5_Permutation_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.permutation = _.permutation || Object.create( null );

// --
//
// --

/**
 * Routine eachSample() accepts the container {-sets-} with scalar or vector elements.
 * Routine returns an array of vectors. Each vector is a unique combination of elements of vectors
 * that is passed in option {-sets-}.
 *
 * Routine eachSample() accepts the options map {-o-} or two arguments. If options map
 * is used, all parameters can be set. If passed two arguments, first of them is ( sets )
 * and second is ( onEach ).
 *
 * Routine eachSample() accepts the callback {-onEach-}. Callback accepts two arguments. The first is
 * template {-sample-} and second is index of vector in returned array. Callback can change template {-sample-}
 * and corrupt the building of vectors.
 *
 * @param {Array|Map} sets - Container with vector and scalar elements to combine new vectors.
 * @param {Routine|Null} onEach - Callback that accepts template {-sample-} and index of new vector.
 * @param {Array|Map} sample - Template for new vectors. If not passed, routine create empty container.
 * If sample.length > vector.length, then vector elements replace template elements with the same indexes.
 * @param {boolean} leftToRight - Sets the direction of reading {-sets-}. 1 - left to rigth, 0 - rigth to left. By default is 1.
 * @param {boolean} result - Sets retuned value. 1 - routine returns array with verctors, 0 - routine returns index of last element. By default is 1.
 *
 * @example
 * var got = _.permutation.eachSample( { sets : [ [ 0, 1 ], 2 ] });
 * console.log( got );
 * // log [ [ 0, 2 ], [ 1, 2 ] ]
 *
 * @example
 * var got = _.permutation.eachSample( { sets : [ [ 0, 1 ], [ 2, 3 ] ], result : 0 });
 * console.log( got );
 * // log 3
 *
 * @example
 * var got = _.permutation.eachSample( { sets : [ [ 0, 1 ], [ 2, 3 ] ] });
 * console.log( got );
 * // log [ [ 0, 2 ], [ 1, 2 ],
 *          [ 0, 3 ], [ 1, 3 ] ]
 *
 * @example
 * var got = _.permutation.eachSample( { sets : { a : [ 0, 1 ], b : [ 2, 3 ] } });
 * console.log( got );
 * // log [ { a : 0, b : 2}, { a : 1, b : 2},
 *          { a : 0, b : 3}, { a : 1, b : 3} ]
 *
 * @example
 * var got = _.permutation.eachSample( { sets : [ [ 0, 1 ], [ 2, 3 ] ], leftToRight : 0 } );
 * console.log( got );
 * // log [ [ 3, 0 ], [ 2, 0 ],
 *          [ 3, 1 ], [ 2, 1 ] ]
 *
 * @example
 * var got = _.permutation.eachSample
 * ({
 *   sets : [ [ 0, 1 ], [ 2, 3 ] ],
 *   sample : [ 2, 3, 4, 5 ]
 * });
 * console.log( got );
 * // log [ [ 3, 0, 4, 5 ], [ 2, 0, 4, 5 ],
 *          [ 3, 1, 4, 5 ], [ 2, 1, 4, 5 ] ]
 *
 * @example
 * function onEach( sample, i )
 * {
 *   _.arrayAppend( got, sample[ i ] );
 * }
 * var got = [];
 * _.permutation.eachSample
 * ({
 *   sets : [ [ 0, 1 ], [ 2, 3 ] ],
 *   onEach : onEach,
 *   sample : [ 'a', 'b', 'c', 'd' ]
 * });
 * console.log( got );
 * // log [ 0, 2, 'c', 'd' ]
 *
 * @function eachSample
 * @returns {Array} Returns array contained  check function.
 * @throws {exception} If ( arguments.length ) is less then one or more then two.
 * @throws {exception} If( onEach ) is not a Routine or null.
 * @throws {exception} If( o.sets ) is not array or objectLike.
 * @throws {exception} If ( sets ) is aixiliary and ( onEach ) not passed.
 * @throws {exception} If( o.base ) or ( o.add) is undefined.
 * @namespace Tools
 */

function eachSample( o )
{

  if( arguments.length === 2 )
  o =
  {
    sets : arguments[ 0 ],
    onEach : arguments[ 1 ],
  }
  else if( _.argumentsArray.like( arguments[ 0 ] ) )
  o =
  {
    sets : arguments[ 0 ],
  }

  _.routine.options( eachSample, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.routine.is( o.onEach ) || o.onEach === null );
  _.assert( _.longLike( o.sets ) || _.aux.is( o.sets ) );
  _.assert( o.base === undefined && o.add === undefined );

  if( o.result === null )
  o.result = o.onEach === null;

  /* sample */

  if( !o.sample )
  o.sample = _.entity.makeUndefined( o.sets );

  /* */

  let keys = _.longLike( o.sets ) ? _.longFromRange([ 0, o.sets.length ]) : _.props.keys( o.sets );
  if( _.bool.likeTrue( o.result ) && !_.arrayIs( o.result ) )
  o.result = [];
  if( keys.length === 0 )
  return o.result ? o.result : 0;
  let len = [];
  let indexnd = [];
  let index = 0;
  let l = _.entity.lengthOf( o.sets );

  /* sets */

  let sindex = 0;
  let breaking = 0;

  o.sets = _.filter_( null, o.sets, function( set, k )
  {
    _.assert( _.longIs( set ) || _.primitive.is( set ) );

    if( breaking === 0 )
    {
      if( _.primitive.is( set ) )
      set = [ set ];

      if( set.length === 0 )
      breaking = 1;

      len[ sindex ] = _.entity.lengthOf( o.sets[ k ] );
      indexnd[ sindex ] = 0;
      sindex += 1;
    }
    return set;

  });

  if( breaking === 1 )
  return o.result ? o.result : 0;

  /* */

  if( !firstSample() )
  return o.result;

  let iterate = o.leftToRight ? iterateLeftToRight : iterateRightToLeft;
  do
  {
    if( o.onEach )
    o.onEach.call( o.sample, o.sample, index );
  }
  while( iterate() );

  if( o.result )
  return o.result;
  else
  return index;

  /* */

  function firstSample()
  {
    let sindex = 0;

    _.each( o.sets, function( e, k )
    {
      o.sample[ k ] = o.sets[ k ][ indexnd[ sindex ] ];
      sindex += 1;
      if( !len[ k ] )
      return 0;
    });

    if( o.result )
    if( _.aux.is( o.sample ) )
    o.result.push( _.props.extend( null, o.sample ) );
    else
    // o.result.push( _.longSlice( o.sample ) ); /* Dmytro : routine _.longSlice is the common interface for slicing of longs */
    o.result.push( _.longSlice( o.sample ) );

    return 1;
  }

  /* */

  function nextSample( i )
  {

    let k = keys[ i ];
    indexnd[ i ]++;

    if( indexnd[ i ] >= len[ i ] )
    {
      indexnd[ i ] = 0;
      o.sample[ k ] = o.sets[ k ][ indexnd[ i ] ];
    }
    else
    {
      o.sample[ k ] = o.sets[ k ][ indexnd[ i ] ];
      index += 1;

      if( o.result )
      if( _.aux.is( o.sample ) )
      o.result.push( _.props.extend( null, o.sample ) );
      else
      // o.result.push( o.sample.slice() );
      o.result.push( _.longSlice( o.sample ) );

      return 1;
    }

    return 0;
  }

  /* */

  function iterateLeftToRight()
  {
    for( let i = 0 ; i < l ; i++ )
    if( nextSample( i ) )
    return 1;

    return 0;
  }

  /* */

  function iterateRightToLeft()
  {
    for( let i = l - 1 ; i >= 0 ; i-- )
    if( nextSample( i ) )
    return 1;

    return 0;
  }

}

eachSample.defaults =
{
  leftToRight : 1,
  onEach : null,

  sets : null,
  sample : null,

  result : null, /* was 1 */
};

//

function eachPermutation( o )
{

  _.routine.options( eachPermutation, arguments );

  if( o.result === null )
  o.result = o.onEach === null;

  if( _.number.is( o.sets ) )
  {
    if( o.sets < 0 )
    o.sets = 0;
    let sets = Array( o.sets );
    for( let i = o.sets-1 ; i >= 0 ; i-- )
    sets[ i ] = i;
    o.sets = sets;
  }

  if( _.bool.likeTrue( o.result ) && !_.arrayIs( o.result ) )
  o.result = [];

  const add = ( _.argumentsArray.like( o.result ) || _.routineIs( o.result.push ) ) ? append1 : append0;
  const dst = o.result ? o.result : undefined;
  const sets = o.sets;
  const length = o.sets.length;
  const last = length - 1;
  const plast = length - 2;
  const slast = length - 3;
  const iterateAll = o.onEach === null ? iterateWithoutCallback : iterateWithCallback;
  let left = last;
  let swaps = 0;
  let iteration = 0;

  if( length <= 1 )
  {
    if( length === 1 )
    {
      if( o.onEach )
      o.onEach( sets, iteration, left, last, swaps );
      add();
    }
    return;
  }

  let iterations = 1;
  for( let i = plast-1 ; i >= 0 ; i-- )
  {
    iterations *= ( last - i );
  }
  iterations *= length;

  let counter = [];
  for( let i = plast ; i >= 0 ; i-- )
  counter[ i ] = last-i;

  _.assert( _.longIs( sets ) );
  _.assert( length >= 0 );
  _.assert( length <= 30 );

  iterateAll();

  return dst;

  /* */

  function append0()
  {
  }

  function append1()
  {
    dst.push( sets.slice() );
  }

  function swap( left, right )
  {
    _.assert( sets[ right ] !== undefined );
    _.assert( sets[ left ] !== undefined );
    let ex = sets[ right ];
    sets[ right ] = sets[ left ];
    sets[ left ] = ex;
  }

  function reverse()
  {
    if( left >= slast )
    {
      swaps = 1;
      swap( left, last );
      counter[ left ] -= 1;
    }
    else
    {
      swaps = last - left;
      if( swaps % 2 === 1 )
      swaps -= 1;
      swaps /= 2;
      for( let i = swaps ; i >= 0 ; i-- )
      swap( left + i, last - i );
      counter[ left ] -= 1;
      swaps += 1;
    }
  }

  function nextCounter()
  {
    while( counter[ left ] === 0 && left !== 0 )
    left -= 1;
    for( let i = left + 1 ; i < counter.length ; i++ )
    counter[ i ] = last - i;
  }

  function onEachDefault()
  {
  }

  function iterateWithoutCallback()
  {

    while( iteration < iterations )
    {
      add();
      left = plast;
      nextCounter();
      reverse();
      iteration += 1;
    }
  }

  function iterateWithCallback()
  {
    _.assert( _.routineIs( o.onEach ), 'Expects routine {-o.onEach-}' );

    while( iteration < iterations )
    {
      o.onEach( sets, iteration, left, last, swaps );
      add();
      left = plast;
      nextCounter();
      reverse();
      iteration += 1;
    }
  }

}

eachPermutation.defaults =
{
  onEach : null,
  sets : null, /* was container */
  result : null, /* was dst */
}

/*

== number:3

= log

0 . 2..2 . 0 1 2
1 . 1..2 . 0 2 1
2 . 0..2 . 1 2 0
3 . 1..2 . 1 0 2
4 . 0..2 . 2 0 1
5 . 1..2 . 2 1 0

== number:4

= log

0 . 3..3 . 0 1 2 3
1 . 2..3 . 0 1 3 2
2 . 1..3 . 0 2 3 1
3 . 2..3 . 0 2 1 3
4 . 1..3 . 0 3 1 2
5 . 2..3 . 0 3 2 1

6 . 0..3 . 1 2 3 0
7 . 2..3 . 1 2 0 3
8 . 1..3 . 1 3 0 2
9 . 2..3 . 1 3 2 0
10 . 1..3 . 1 0 2 3
11 . 2..3 . 1 0 3 2

12 . 0..3 . 2 3 0 1
13 . 2..3 . 2 3 1 0
14 . 1..3 . 2 0 1 3
15 . 2..3 . 2 0 3 1
16 . 1..3 . 2 1 3 0
17 . 2..3 . 2 1 0 3

18 . 0..3 . 3 0 1 2
19 . 2..3 . 3 0 2 1
20 . 1..3 . 3 1 2 0
21 . 2..3 . 3 1 0 2
22 . 1..3 . 3 2 0 1
23 . 2..3 . 3 2 1 0

== number:5

= count

120
24
6
2
1

4
3
2

= log

0 . 4..4 . 0 1 2 3 4
1 . 3..4 . 0 1 2 4 3
2 . 2..4 . 0 1 3 4 2
3 . 3..4 . 0 1 3 2 4
4 . 2..4 . 0 1 4 2 3
5 . 3..4 . 0 1 4 3 2
6 . 1..4 . 0 2 3 4 1
7 . 3..4 . 0 2 3 1 4
8 . 2..4 . 0 2 4 1 3
9 . 3..4 . 0 2 4 3 1
10 . 2..4 . 0 2 1 3 4
11 . 3..4 . 0 2 1 4 3
12 . 1..4 . 0 3 4 1 2
13 . 3..4 . 0 3 4 2 1
14 . 2..4 . 0 3 1 2 4
15 . 3..4 . 0 3 1 4 2
16 . 2..4 . 0 3 2 4 1
17 . 3..4 . 0 3 2 1 4
18 . 1..4 . 0 4 1 2 3
19 . 3..4 . 0 4 1 3 2
20 . 2..4 . 0 4 2 3 1
21 . 3..4 . 0 4 2 1 3
22 . 2..4 . 0 4 3 1 2
23 . 3..4 . 0 4 3 2 1

24 . 0..4 . 1 2 3 4 0
25 . 3..4 . 1 2 3 0 4
26 . 2..4 . 1 2 4 0 3
27 . 3..4 . 1 2 4 3 0
28 . 2..4 . 1 2 0 3 4
29 . 3..4 . 1 2 0 4 3
30 . 1..4 . 1 3 4 0 2
31 . 3..4 . 1 3 4 2 0
32 . 2..4 . 1 3 0 2 4
33 . 3..4 . 1 3 0 4 2
34 . 2..4 . 1 3 2 4 0
35 . 3..4 . 1 3 2 0 4
36 . 1..4 . 1 4 0 2 3
37 . 3..4 . 1 4 0 3 2
38 . 2..4 . 1 4 2 3 0
39 . 3..4 . 1 4 2 0 3
40 . 2..4 . 1 4 3 0 2
41 . 3..4 . 1 4 3 2 0
42 . 1..4 . 1 0 2 3 4
43 . 3..4 . 1 0 2 4 3
44 . 2..4 . 1 0 3 4 2
45 . 3..4 . 1 0 3 2 4
46 . 2..4 . 1 0 4 2 3
47 . 3..4 . 1 0 4 3 2

48 . 0..4 . 2 3 4 0 1
49 . 3..4 . 2 3 4 1 0
50 . 2..4 . 2 3 0 1 4
51 . 3..4 . 2 3 0 4 1
52 . 2..4 . 2 3 1 4 0
53 . 3..4 . 2 3 1 0 4
54 . 1..4 . 2 4 0 1 3
55 . 3..4 . 2 4 0 3 1
56 . 2..4 . 2 4 1 3 0
57 . 3..4 . 2 4 1 0 3
58 . 2..4 . 2 4 3 0 1
59 . 3..4 . 2 4 3 1 0
60 . 1..4 . 2 0 1 3 4
61 . 3..4 . 2 0 1 4 3
62 . 2..4 . 2 0 3 4 1
63 . 3..4 . 2 0 3 1 4
64 . 2..4 . 2 0 4 1 3
65 . 3..4 . 2 0 4 3 1
66 . 1..4 . 2 1 3 4 0
67 . 3..4 . 2 1 3 0 4
68 . 2..4 . 2 1 4 0 3
69 . 3..4 . 2 1 4 3 0
70 . 2..4 . 2 1 0 3 4
71 . 3..4 . 2 1 0 4 3
72 . 0..4 . 3 4 0 1 2
73 . 3..4 . 3 4 0 2 1
74 . 2..4 . 3 4 1 2 0
75 . 3..4 . 3 4 1 0 2
76 . 2..4 . 3 4 2 0 1
77 . 3..4 . 3 4 2 1 0
78 . 1..4 . 3 0 1 2 4
79 . 3..4 . 3 0 1 4 2
80 . 2..4 . 3 0 2 4 1
81 . 3..4 . 3 0 2 1 4
82 . 2..4 . 3 0 4 1 2
83 . 3..4 . 3 0 4 2 1
84 . 1..4 . 3 1 2 4 0
85 . 3..4 . 3 1 2 0 4
86 . 2..4 . 3 1 4 0 2
87 . 3..4 . 3 1 4 2 0
88 . 2..4 . 3 1 0 2 4
89 . 3..4 . 3 1 0 4 2
90 . 1..4 . 3 2 4 0 1
91 . 3..4 . 3 2 4 1 0
92 . 2..4 . 3 2 0 1 4
93 . 3..4 . 3 2 0 4 1
94 . 2..4 . 3 2 1 4 0
95 . 3..4 . 3 2 1 0 4
96 . 0..4 . 4 0 1 2 3
97 . 3..4 . 4 0 1 3 2
98 . 2..4 . 4 0 2 3 1
99 . 3..4 . 4 0 2 1 3
100 . 2..4 . 4 0 3 1 2
101 . 3..4 . 4 0 3 2 1
102 . 1..4 . 4 1 2 3 0
103 . 3..4 . 4 1 2 0 3
104 . 2..4 . 4 1 3 0 2
105 . 3..4 . 4 1 3 2 0
106 . 2..4 . 4 1 0 2 3
107 . 3..4 . 4 1 0 3 2
108 . 1..4 . 4 2 3 0 1
109 . 3..4 . 4 2 3 1 0
110 . 2..4 . 4 2 0 1 3
111 . 3..4 . 4 2 0 3 1
112 . 2..4 . 4 2 1 3 0
113 . 3..4 . 4 2 1 0 3
114 . 1..4 . 4 3 0 1 2
115 . 3..4 . 4 3 0 2 1
116 . 2..4 . 4 3 1 2 0
117 . 3..4 . 4 3 1 0 2
118 . 2..4 . 4 3 2 0 1
119 . 3..4 . 4 3 2 1 0

*/

//

function swapsCount( permutation )
{
  let counter = 0;
  let forward = permutation.slice();
  let backward = [];
  for( let i = forward.length-1 ; i >= 0 ; i-- )
  {
    backward[ forward[ i ] ] = i;
  }
  for( let i = backward.length-1 ; i >= 0 ; i-- )
  {
    if( backward[ i ] !== i )
    {
      let forward1 = forward[ i ];
      let backward1 = backward[ i ];
      forward[ backward1 ] = forward1;
      backward[ forward1 ] = backward1;
      counter += 1;
    }
  }
  return counter;
}

//

/* Calculates the factorial of an integer number ( >= 0 ) */

function _factorial( src )
{
  let result = 1;
  while( src > 1 )
  {
    result = result * src;
    src -= 1;
  }
  return result;
}

//

/**
 * @summary Returns factorial for number `src`.
 * @description Number `src`
 * @param {Number} src Source number. Should be less than 10000.
 * @function factorial
 * @namespace Tools
 * @module wTools
 */

function factorial( src )
{
  _.assert( src < 10000 );
  _.assert( _.intIs( src ) );
  _.assert( src >= 0 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( src === 0 )
  return 1;
  return _.permutation._factorial( src )
}

// --
// extend permutation
// --

let PermutationExtension =
{

  eachSample, /* xxx : review */
  eachPermutation,
  swapsCount,
  _factorial,
  factorial,

}

//

Object.assign( _.permutation, PermutationExtension );

// --
// extend tools
// --

let ToolsExtension =
{

  // eachSample, /* xxx : review */
  // eachPermutation,
  // swapsCount,
  // _factorial,
  factorial,

}

//

Object.assign( _, ToolsExtension );

})();

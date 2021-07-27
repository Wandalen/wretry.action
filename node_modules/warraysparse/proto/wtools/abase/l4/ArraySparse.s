( function _ArraySparse_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to operate effectively sparse array. A sparse array is an vector of intervals which split number space into two subsets, internal and external. ArraySparse leverage iterating, inverting, minimizing and other operations on a sparse array. Use the module to increase memory efficiency of your algorithms.
  @module Tools/base/ArraySparse
*/

/**
 *  */

/**
 * Collection of cross-platform routines to operate effectively sparse array.
  @namespace wTools.sparse
  @extends Tools
  @module Tools/base/ArraySparse
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

}

//

const _ = _global_.wTools;
const _global = _global_;
_.sparse = _.sparse || Object.create( null );

const _ArraySlice = Array.prototype.slice;
const _FunctionBind = Function.prototype.bind;
const _ObjectToString = Object.prototype.toString;
const _ObjectHasOwnProperty = Object.hasOwnProperty;

const _longSlice = _.longSlice;

// --
// sparse
// --

/**
 * @summary Checks if current entity is a sparse array.
 *
 * @param {*} sparse Entity to check
 *
 * @example
 * _.sparse.is( {} ) // false
 *
 * @example
 * _.sparse.is( [ 1, 2, 3, 4, 5 ] ) // false
 *
 * @example
 * _.sparse.is( [ 1, 2, 3, 4 ] ) // true
 *
 * @returns { Number } Returns true if entity( sparse ) is a sparse array, otherwise false.
 * @function is
 * @namespace Tools.sparse
 */

function is( sparse )
{
  _.assert( arguments.length === 1 );

  if( !_.longIs( sparse ) )
  return false;

  if( sparse.length % 2 !== 0 )
  return false;

  return true;
}

//

/**
 * @summary Calls onEach routine for each range
 * @description
 * Arguments list of onEach routine:
 * * range - current range
 * * s - index of current range
 * * sparse - source sparse array
 * @param {Array} sparse Source sparse array
 * @param {Function} onEach Routine to call for each range
 *
 * @example
 * _.sparse.eachRange( [ 1, 2, 3, 4 ], ( range ) =>
 * {
 *   console.log( range )
 * })
 * //[ 1, 2 ]
 * //[ 3, 4 ]
 *
 * @function eachRange
 * @throws {Error} If ( sparse ) is not a sparse array.
 * @namespace Tools.sparse
 */

function eachRange( sparse, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( _.sparse.is( sparse ) );

  let index = 0;
  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ], sparse[ s*2 + 1 ] ];
    onEach( range, s, sparse );
  }

}

//

/**
 * @summary Calls onEach routine for all elements of each range
 * @description
 * Arguments list of onEach routine:
 * * value - current element from range
 * * index - global index of current element
 * * range  current range
 *
 * @param {Array} sparse Source sparse array
 * @param {Function} onEach Routine to call for each range
 *
 * @example
 * _.sparse.eachElement( [ 1, 3, 3, 5 ], ( value, index ) =>
 * {
 *   console.log( value, index )
 * })
 * // 1 0
 * // 2 1
 * // 3 2
 * // 4 3
 *
 * @function eachElement
 * @throws {Error} If ( sparse ) is not a sparse array.
 * @namespace Tools.sparse
 */

function eachElement( sparse, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( _.sparse.is( sparse ) );

  let index = 0;
  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ], sparse[ s*2 + 1 ] ];
    for( let key = range[ 0 ], kl = range[ 1 ] ; key < kl ; key++ )
    {
      onEach.call( this, key, index, range, 1 );
      index += 1;
    }
  }

}

//

/**
 * @summary Calls onEach routine for all elements inside and outside of each range
 * @description
 * Arguments list of onEach routine:
 * * value - current element from range
 * * index - global index of current element
 * * range  current range
 *
 * @param {Array} sparse Source sparse array
 * @param {Number} length
 * @param {Function} onEach Routine to call for each range
 *
 * @example
 * _.sparse.eachElementEvenOutside( [ 2, 3, 3, 6 ], 1, ( value, index, range ) =>
 * {
 *   console.log( value, range )
 * })
 * // 0 0 [2, 3]
 * // 1 1 [2, 3]
 * // 2 2 [2, 3]
 * // 3 3 [3, 6]
 * // 4 4 [3, 6]
 * // 5 5 [3, 6]
 *
 * @function eachElementEvenOutside
 * @throws {Error} If ( sparse ) is not a sparse array.
 * @namespace Tools.sparse
 */

function eachElementEvenOutside( sparse, length, onEach )
{

  _.assert( arguments.length === 3 );
  _.assert( _.sparse.is( sparse ) );
  _.assert( _.numberIs( length ) );
  _.assert( _.routineIs( onEach ) );

  let index = 0;
  let was = 0;
  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ], sparse[ s*2 + 1 ] ];

    for( let key = was ; key < range[ 0 ] ; key++ )
    {
      onEach.call( this, key, index, range, 0 );
      index += 1;
    }

    for( let key = range[ 0 ], kl = range[ 1 ] ; key < kl ; key++ )
    {
      onEach.call( this, key, index, range, 1 );
      index += 1;
    }

    was = range[ 1 ];
  }

  for( let key = was ; key < length ; key++ )
  {
    onEach.call( this, key, index, range, 0 );
    index += 1;
  }

}

//

/**
 * @summary Returns total number of elements from all ranges
 * @param {Array} sparse Source sparse array
 *
 * @example
 * _.sparse.elementsTotal( [ 2, 3, 3, 6 ] )//4
 *
 * @function elementsTotal
 * @throws {Error} If ( sparse ) is not a sparse array.
 * @namespace Tools.sparse
 */

function elementsTotal( sparse )
{
  let result = 0;

  _.assert( arguments.length === 1 );
  _.assert( _.sparse.is( sparse ) );

  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ], sparse[ s*2 + 1 ] ];
    result += range[ 1 ] - range[ 0 ];
  }

  return result;
}

//

/**
 * @summary Minimizes provided sparse array into a single range.
 * @param {Array} sparse Source sparse array
 *
 * @example
 * _.sparse.minimize( [ 2, 3, 3, 6  ] )//[ 2, 6 ]
 *
 * @function minimize
 * @throws {Error} If ( sparse ) is not a sparse array.
 * @namespace Tools.sparse
 */

function minimize( sparse )
{

  _.assert( arguments.length === 1 );
  _.assert( _.sparse.is( sparse ) )

  if( sparse.length === 0 )
  {
    // return _.entity.cloneShallow( sparse, 0 );
    return _.long.make( sparse, 0 );
  }

  let l = 0;

  for( let i = 2 ; i < sparse.length ; i += 2 )
  {

    let e1 = sparse[ i-1 ];
    let b2 = sparse[ i+0 ];

    if( e1 !== b2 )
    l += 2;

  }

  l += 2;

  // let result = _.entity.cloneShallow( sparse, l );
  let result = _.long.make( sparse, l );
  let b = sparse[ 0 ];
  let e = sparse[ 1 ];
  let r = 0;

  /* */

  for( let i = 2 ; i < sparse.length ; i += 2 )
  {

    let e1 = sparse[ i-1 ];
    let b2 = sparse[ i+0 ];

    if( e1 === b2 )
    {
      e = sparse[ i+1 ];
    }
    else
    {
      result[ r+0 ] = b;
      result[ r+1 ] = e;
      b = b2;
      e = sparse[ i+1 ];
      r += 2;
    }
    // if( e1 !== b2 )
    // {
    //   result[ r+0 ] = b;
    //   result[ r+1 ] = e;
    //   b = b2;
    //   e = sparse[ i+1 ];
    //   r += 2;
    // }
    // else
    // {
    //   e = sparse[ i+1 ];
    // }

  }

  /* */

  result[ r+0 ] = b;
  result[ r+1 ] = e;
  r += 2;

  _.assert( r === l );

  return result;
}

//

/**
 * @function invertFinite
 * @throws {Error} If ( sparse ) is not a sparse array.
 * @namespace Tools.sparse
 */

function invertFinite( sparse )
{
  _.assert( arguments.length === 1 );
  _.assert( _.sparse.is( sparse ) )

  if( !sparse.length )
  // return _.entity.cloneShallow( sparse, 0 );
  return _.long.make( sparse, 0 );

  if( sparse.length === 2 && sparse[ 0 ] === sparse[ 1 ] )
  return _.entity.make( sparse );

  let needPre = 0;
  let needPost = 0;

  if( sparse.length >= 2 )
  {
    needPre = sparse[ 0 ] === sparse[ 1 ] ? 0 : 1;
    needPost = sparse[ sparse.length-2 ] === sparse[ sparse.length-1 ] ? 0 : 1;
  }

  let l = sparse.length + needPre*2 + needPost*2 - 2;
  // let result = _.entity.cloneShallow( sparse, l );
  let result = _.long.make( sparse, l );
  let r = 0;

  _.assert( l % 2 === 0 );

  if( needPre )
  {
    result[ r+0 ] = sparse[ 0 ];
    result[ r+1 ] = sparse[ 0 ];
    r += 2;
  }

  if( needPost )
  {
    result[ result.length-2 ] = sparse[ sparse.length-1 ];
    result[ result.length-1 ] = sparse[ sparse.length-1 ];
  }

  for( let i = 2 ; i < sparse.length ; i += 2 )
  {
    let e1 = sparse[ i-1 ];
    let b2 = sparse[ i+0 ];

    result[ r+0 ] = e1;
    result[ r+1 ] = b2;
    r += 2;
  }

  return result;
}

// --
// declare
// --

let Proto =
{

  // sparse

  is,

  eachRange,
  eachElement,
  eachElementEvenOutside,
  elementsTotal,

  minimize,
  invertFinite,

}

/* _.props.extend */Object.assign( _.sparse, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _.sparse;

})();

( function _l5_ArraySet_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.arraySet = _.arraySet || Object.create( null );

// --
// array set
// --

// /**
//  * Returns new array that contains difference between two arrays: ( src1 ) and ( src2 ).
//  * If some element is present in both arrays, this element and all copies of it are ignored.
//  * @param { longIs } src1 - source array;
//  * @param { longIs} src2 - array to compare with ( src1 ).
//  *
//  * @example
//  * _.arraySet.diff_( null, [ 1, 2, 3 ], [ 4, 5, 6 ] );
//  * // returns [ 1, 2, 3, 4, 5, 6 ]
//  *
//  * @example
//  * _.arraySet.diff_( null, [ 1, 2, 4 ], [ 1, 3, 5 ] );
//  * // returns [ 2, 4, 3, 5 ]
//  *
//  * @returns { Array } Array with unique elements from both arrays.
//  * @function arraySetDiff
//  * @throws { Error } If arguments count is not 2.
//  * @throws { Error } If one or both argument(s) are not longIs entities.
//  * @namespace Tools
//  */
//
// function arraySetDiff( src1, src2 )
// {
//   let result = [];
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( _.longIs( src1 ) );
//   _.assert( _.longIs( src2 ) );
//
//   for( let i = 0 ; i < src1.length ; i++ )
//   {
//     if( src2.indexOf( src1[ i ] ) === -1 )
//     result.push( src1[ i ] );
//   }
//
//   for( let i = 0 ; i < src2.length ; i++ )
//   {
//     if( src1.indexOf( src2[ i ] ) === -1 )
//     result.push( src2[ i ] );
//   }
//
//   return result;
// }

//

function _has( /* src, e, onEvaluate1, onEvaluate2 */ )
{
  let src = arguments[ 0 ];
  let e = arguments[ 1 ];
  let onEvaluate1 = arguments[ 2 ];
  let onEvaluate2 = arguments[ 3 ];

  _.assert( onEvaluate2 === undefined || _.routine.is( onEvaluate2 ) );

  let fromIndex = 0;
  if( _.number.is( onEvaluate1 ) )
  {
    fromIndex = onEvaluate1;
    onEvaluate1 = onEvaluate2;
    onEvaluate2 = undefined;
  }

  if( _.routine.is( onEvaluate1 ) )
  {
    if( onEvaluate1.length === 2 )
    {
      _.assert( !onEvaluate2 );

      for( let el of src )
      {
        if( fromIndex === 0 )
        {
          if( onEvaluate1( el, e ) )
          return true;
        }
        else
        {
          fromIndex -= 1;
        }
      }

      return false;
    }
    else if( onEvaluate1.length === 1 )
    {
      _.assert( !onEvaluate2 || onEvaluate2.length === 1 );

      if( onEvaluate2 )
      e = onEvaluate2( e );
      else
      e = onEvaluate1( e );

      for( let el of src )
      {
        if( fromIndex === 0 )
        {
          if( onEvaluate1( el ) === e )
          return true;
        }
        else
        {
          fromIndex -= 1;
        }
      }

      return false;
    }
    else _.assert( 0 );
  }
  else if( onEvaluate1 === undefined || onEvaluate1 === null )
  {
    if( _.longLike( src ) )
    return src.includes( e );
    else if( _.set.like( src ) )
    return src.has( e );
  }
  else _.assert( 0 );
}

//

/* qqq : for junior : should work
_.arraySet.diff_( null, hashMap1.keys(), hashMap2.keys() )
*/
/* qqq : reimplement. dst should be map. first discuss */
function diff_( /* dst, src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let dst = arguments[ 0 ];
  let src1 = arguments[ 1 ];
  let src2 = arguments[ 2 ];
  let onEvaluate1 = arguments[ 3 ];
  let onEvaluate2 = arguments[ 4 ];

  _.assert( 2 <= arguments.length && arguments.length <= 5 );
  _.assert( _.longIs( dst ) || _.set.is( dst ) || dst === null );
  _.assert( _.longIs( src1 ) || _.set.is( src1 ) );
  _.assert( _.longIs( src2 ) || _.set.is( src2 ) || _.routine.is( src2 ) || src2 === undefined );

  if( dst === null )
  dst = new src1.constructor();

  if( _.routine.is( src2 ) || src2 === undefined )
  {
    onEvaluate2 = onEvaluate1;
    onEvaluate1 = src2;
    src2 = src1;
    src1 = dst;
  }

  let temp = [];
  if( dst === src1 )
  {
    if( _.longLike( dst ) )
    {
      for( let e of src2 )
      if( _.longLeftIndex( dst, e, onEvaluate1, onEvaluate2 ) === -1 )
      temp.push( e );
      for( let i = dst.length - 1; i >= 0; i-- )
      if( _has( src2, dst[ i ], onEvaluate1, onEvaluate2 ) )
      dst.splice( i, 1 )
      for( let i = 0; i < temp.length; i++ )
      dst.push( temp[ i ] );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of src2 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      temp.push( e );
      for( let e of dst )
      if( _has( src2, e, onEvaluate1, onEvaluate2 ) )
      dst.delete( e );
      for( let i = 0; i < temp.length; i++ )
      dst.add( temp[ i ] );
    }
  }
  else if( dst === src2 )
  {
    if( _.longLike( dst ) )
    {
      for( let e of src1 )
      if( _.longLeftIndex( dst, e, onEvaluate1, onEvaluate2 ) === -1 )
      temp.push( e );
      for( let i = dst.length - 1; i >= 0; i-- )
      if( _has( src1, dst[ i ], onEvaluate1, onEvaluate2 ) )
      dst.splice( i, 1 )
      for( let i = 0; i < temp.length; i++ )
      dst.push( temp[ i ] );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of src1 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      temp.push( e );
      for( let e of dst )
      if( _has( src1, e, onEvaluate1, onEvaluate2 ) )
      dst.delete( e );
      for( let i = 0; i < temp.length; i++ )
      dst.add( temp[ i ] );
    }
  }
  else
  {
    if( _.longLike( dst ) )
    {
      for( let e of src1 )
      if( !_has( src2, e, onEvaluate1, onEvaluate2 ) )
      dst.push( e );
      for( let e of src2 )
      if( !_has( src1, e, onEvaluate1, onEvaluate2 ) )
      dst.push( e );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of src1 )
      if( !_has( src2, e, onEvaluate1, onEvaluate2 ) )
      dst.add( e );
      for( let e of src2 )
      if( !_has( src1, e, onEvaluate1, onEvaluate2 ) )
      dst.add( e );
    }
  }

  return dst;
}

// //
//
// /**
//  * Returns new array that contains elements from ( src ) that are not present in ( but ).
//  * All copies of ignored element are ignored too.
//  * @param { longIs } src - source array;
//  * @param { longIs} but - array of elements to ignore.
//  *
//  * @example
//  * _.arraySetBut( [ 1, 1, 1 ], [ 1 ] );
//  * // returns []
//  *
//  * @example
//  * _.arraySetBut( [ 1, 1, 2, 2, 3, 3 ], [ 1, 3 ] );
//  * // returns [ 2, 2 ]
//  *
//  * @returns { Array } Source array without elements from ( but ).
//  * @function arraySetBut
//  * @throws { Error } If arguments count is not 2.
//  * @throws { Error } If one or both argument(s) are not longIs entities.
//  * @namespace Tools
//  */
//
// function arraySetBut( dst )
// {
//   let args = _.longSlice( arguments );
//
//   if( dst === null )
//   if( args.length > 1 )
//   {
//     dst = _.longSlice( args[ 1 ] );
//     args.splice( 1, 1 );
//   }
//   else
//   {
//     return [];
//   }
//
//   args[ 0 ] = dst;
//
//   _.assert( arguments.length >= 1, 'Expects at least one argument' );
//   for( let a = 0 ; a < args.length ; a++ )
//   _.assert( _.longIs( args[ a ] ) );
//
//   for( let i = dst.length-1 ; i >= 0 ; i-- )
//   {
//     for( let a = 1 ; a < args.length ; a++ )
//     {
//       let but = args[ a ];
//       if( but.indexOf( dst[ i ] ) !== -1 )
//       {
//         dst.splice( i, 1 );
//         break;
//       }
//     }
//   }
//
//   return dst;
// }

//

function but_( /* dst, src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let dst = arguments[ 0 ];
  let src1 = arguments[ 1 ];
  let src2 = arguments[ 2 ];
  let onEvaluate1 = arguments[ 3 ];
  let onEvaluate2 = arguments[ 4 ];

  if( arguments.length === 1 )
  {
    if( dst === null )
    return [];
    else if( _.longLike( dst ) || _.set.like( dst ) )
    return dst;
    else
    _.assert( 0 );
  }

  if( ( dst === null && _.routine.is( src2 ) ) || ( dst === null && src2 === undefined ) )
  {
    if( _.longLike( src1 ) )
    return _.longSlice( src1 )
    else if( _.set.like( src1 ) )
    return new Set( src1 )
    _.assert( 0 );
  }

  _.assert( 2 <= arguments.length && arguments.length <= 5 );
  _.assert( _.longIs( dst ) || _.set.is( dst ) || dst === null );
  _.assert( _.longIs( src1 ) || _.set.is( src1 ) );
  _.assert( _.longIs( src2 ) || _.set.is( src2 ) || _.routine.is( src2 ) || src2 === undefined );


  if( dst === null )
  dst = new src1.constructor();

  if( _.routine.is( src2 ) || src2 === undefined )
  {
    onEvaluate2 = onEvaluate1;
    onEvaluate1 = src2;
    src2 = src1;
    src1 = dst;
  }

  if( dst === src1 )
  {
    if( _.longLike( dst ) )
    {
      for( let i = dst.length - 1; i >= 0; i-- )
      if( _has( src2, dst[ i ], onEvaluate1, onEvaluate2 ) )
      dst.splice( i, 1 );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of dst )
      if( _has( src2, e, onEvaluate1, onEvaluate2 ) )
      dst.delete( e );
    }
  }
  else
  {
    if( _.longLike( dst ) )
    {
      for( let e of src1 )
      if( !_has( src2, e, onEvaluate1, onEvaluate2 ) )
      dst.push( e );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of src1 )
      if( !_has( src2, e, onEvaluate1, onEvaluate2 ) )
      dst.add( e );
    }
  }

  return dst;
}

// //
//
// /**
//  * Returns array that contains elements from ( src ) that exists at least in one of arrays provided after first argument.
//  * If element exists and it has copies, all copies of that element will be included into result array.
//  * @param { longIs } src - source array;
//  * @param { ...longIs } - sequence of arrays to compare with ( src ).
//  *
//  * @example
//  * _.arraySetIntersection( [ 1, 2, 3 ], [ 1 ], [ 3 ] );
//  * // returns [ 1, 3 ]
//  *
//  * @example
//  * _.arraySetIntersection( [ 1, 1, 2, 2, 3, 3 ], [ 1 ], [ 2 ], [ 3 ], [ 4 ] );
//  * // returns [ 1, 1, 2, 2, 3, 3 ]
//  *
//  * @returns { Array } Array with elements that are a part of at least one of the provided arrays.
//  * @function arraySetIntersection
//  * @throws { Error } If one of arguments is not an longIs entity.
//  * @namespace Tools
//  */
//
// function arraySetIntersection( dst )
// {
//
//   let first = 1;
//   if( dst === null )
//   if( arguments.length > 1 )
//   {
//     dst = _.longSlice( arguments[ 1 ] );
//     first = 2;
//   }
//   else
//   {
//     return [];
//   }
//
//   _.assert( arguments.length >= 1, 'Expects at least one argument' );
//   _.assert( _.longIs( dst ) );
//   for( let a = 1 ; a < arguments.length ; a++ )
//   _.assert( _.longIs( arguments[ a ] ) );
//
//   for( let i = dst.length-1 ; i >= 0 ; i-- )
//   {
//
//     for( let a = first ; a < arguments.length ; a++ )
//     {
//       let ins = arguments[ a ];
//       if( ins.indexOf( dst[ i ] ) === -1 )
//       {
//         dst.splice( i, 1 );
//         break;
//       }
//     }
//
//   }
//
//   return dst;
// }

//

function intersection_( /* dst, src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let dst = arguments[ 0 ];
  let src1 = arguments[ 1 ];
  let src2 = arguments[ 2 ];
  let onEvaluate1 = arguments[ 3 ];
  let onEvaluate2 = arguments[ 4 ];

  if( arguments.length === 1 )
  {
    if( dst === null )
    return [];
    else if( _.longIs( dst ) || _.set.is( dst ) )
    return dst;
    else
    _.assert( 0 );
  }
  if( ( dst === null && _.routine.is( src2 ) ) || ( dst === null && src2 === undefined ) )
  {
    if( _.longIs( src1 ) )
    return _.longSlice( src1 )
    else if( _.set.is( src1 ) )
    return new Set( src1 )
    _.assert( 0 );
  }

  _.assert( 2 <= arguments.length && arguments.length <= 5 );
  _.assert( _.longIs( dst ) || _.set.is( dst ) || dst === null );
  _.assert( _.longIs( src1 ) || _.set.is( src1 ) );
  _.assert( _.longIs( src2 ) || _.set.is( src2 ) || _.routine.is( src2 ) || src2 === undefined );


  if( dst === null )
  dst = new src1.constructor();

  if( _.routine.is( src2 ) || src2 === undefined )
  {
    onEvaluate2 = onEvaluate1;
    onEvaluate1 = src2;
    src2 = src1;
    src1 = dst;
  }

  if( dst === src1 )
  {
    if( _.longLike( dst ) )
    {
      for( let i = dst.length - 1; i >= 0; i-- )
      if( !_has( src2, dst[ i ], onEvaluate1, onEvaluate2 ) )
      dst.splice( i, 1 );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of dst )
      if( !_has( src2, e, onEvaluate1, onEvaluate2 ) )
      dst.delete( e );
    }
  }
  else
  {
    if( _.longLike( dst ) )
    {
      for( let e of src1 )
      if( _has( src2, e, onEvaluate1, onEvaluate2 ) )
      dst.push( e );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of src1 )
      if( _has( src2, e, onEvaluate1, onEvaluate2 ) )
      dst.add( e );
    }
  }

  return dst;
}

// //
//
// function arraySetUnion( dst )
// {
//   let args = _.longSlice( arguments );
//
//   if( dst === null )
//   if( arguments.length > 1 )
//   {
//     dst = [];
//     // dst = _.longSlice( args[ 1 ] );
//     // args.splice( 1, 1 );
//   }
//   else
//   {
//     return [];
//   }
//
//   _.assert( arguments.length >= 1, 'Expects at least one argument' );
//   _.assert( _.longIs( dst ) );
//   for( let a = 1 ; a < args.length ; a++ )
//   _.assert( _.longIs( args[ a ] ) );
//
//   for( let a = 1 ; a < args.length ; a++ )
//   {
//     let ins = args[ a ];
//     for( let i = 0 ; i < ins.length ; i++ )
//     {
//       if( dst.indexOf( ins[ i ] ) === -1 )
//       dst.push( ins[ i ] )
//     }
//   }
//
//   return dst;
// }

//

function union_( /* dst, src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let dst = arguments[ 0 ];
  let src1 = arguments[ 1 ];
  let src2 = arguments[ 2 ];
  let onEvaluate1 = arguments[ 3 ];
  let onEvaluate2 = arguments[ 4 ];

  if( arguments.length === 1 )
  {
    if( dst === null )
    return [];
    else if( _.longIs( dst ) || _.set.is( dst ) )
    return dst;
    else
    _.assert( 0 );
  }

  _.assert( 2 <= arguments.length && arguments.length <= 5 );
  _.assert( _.longIs( dst ) || _.set.is( dst ) || dst === null );
  _.assert( _.longIs( src1 ) || _.set.is( src1 ) );
  _.assert( _.longIs( src2 ) || _.set.is( src2 ) || _.routine.is( src2 ) || src2 === undefined );


  if( dst === null )
  dst = new src1.constructor();

  if( _.routine.is( src2 ) || src2 === undefined )
  {
    onEvaluate2 = onEvaluate1;
    onEvaluate1 = src2;
    src2 = src1;
    src1 = dst;
  }

  if( dst === src1 )
  {
    if( _.longLike( dst ) )
    {
      for( let e of src2 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      dst.push( e );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of src2 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      dst.add( e );
    }
  }
  else if( dst === src2 )
  {
    if( _.longLike( dst ) )
    {
      for( let e of src1 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      dst.push( e );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of src1 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      dst.add( e );
    }
  }
  else
  {
    if( _.longLike( dst ) )
    {
      for( let e of src1 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      dst.push( e );
      for( let e of src2 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      dst.push( e );
    }
    else if( _.set.like( dst ) )
    {
      for( let e of src1 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      dst.add( e );
      for( let e of src2 )
      if( !_has( dst, e, onEvaluate1, onEvaluate2 ) )
      dst.add( e );
    }
  }

  return dst;
}

//

/*
function arraySetContainAll( src )
{
  let result = [];

  _.assert( _.longIs( src ) );

  for( let a = 1 ; a < arguments.length ; a++ )
  {

    _.assert( _.longIs( arguments[ a ] ) );

    if( src.length > arguments[ a ].length )
    return false;

    for( let i = 0 ; i < src.length ; i++ )
    {

      throw _.err( 'Not tested' );
      if( arguments[ a ].indexOf( src[ i ] ) !== -1 )
      {
        throw _.err( 'Not tested' );
        return false;
      }

    }

  }

  return true;
}
*/

// //
//
// /**
//  * The arraySetContainAll() routine returns true, if at least one of the following arrays (arguments[...]),
//  * contains all the same values as in the {-srcMap-} array.
//  *
//  * @param { longIs } src - The source array.
//  * @param { ...longIs } arguments[...] - The target array.
//  *
//  * @example
//  * _.arraySetContainAll( [ 1, 'b', 'c', 4 ], [ 1, 2, 3, 4, 5, 'b', 'c' ] );
//  * // returns true
//  *
//  * @example
//  * _.arraySetContainAll( [ 'abc', 'def', true, 26 ], [ 1, 2, 3, 4 ], [ 26, 'abc', 'def', true ] );
//  * // returns false
//  *
//  * @returns { boolean } Returns true, if at least one of the following arrays (arguments[...]),
//  * contains all the same values as in the {-srcMap-} array.
//  * If length of the {-srcMap-} is more than the next argument, it returns false.
//  * Otherwise, it returns false.
//  * @function arraySetContainAll
//  * @throws { Error } Will throw an Error if {-srcMap-} is not an array-like.
//  * @throws { Error } Will throw an Error if (arguments[...]) is not an array-like.
//  * @namespace Tools
//  */
//
// function arraySetContainAll( src )
// {
//   _.assert( _.longIs( src ) );
//   for( let a = 1 ; a < arguments.length ; a++ )
//   _.assert( _.longIs( arguments[ a ] ) );
//
//   for( let a = 1 ; a < arguments.length ; a++ )
//   {
//     let ins = arguments[ a ];
//
//     for( let i = 0 ; i < ins.length ; i++ )
//     {
//       if( src.indexOf( ins[ i ] ) === -1 )
//       return false;
//     }
//
//   }
//
//   return true;
// }

//

function containAll_( /* src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let src1 = arguments[ 0 ];
  let src2 = arguments[ 1 ];
  let onEvaluate1 = arguments[ 2 ];
  let onEvaluate2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( src2 ) || _.set.is( src2 ) );

  let result = true;
  if( _.arrayIs( src1 ) )
  {
    for( let e of src2 )
    if( _.longLeftIndex( src1, e, onEvaluate1, onEvaluate2 ) === -1 )
    result = false;
  }
  else if( _.set.is( src1 ) )
  {
    let startFrom = 0;
    if( _.number.is( onEvaluate1 ) )
    {
      startFrom = onEvaluate1;
      onEvaluate1 = onEvaluate2;
      onEvaluate2 = undefined;
    }

    if( !src1.size && ( src2.length || src2.size ) )
    return false;

    for( let e of src2 )
    {
      if( result === false )
      {
        break;
      }
      else
      {
        let from = startFrom;
        result = undefined;
        setElementsCheck( from, e );
      }
    }
    return result === undefined ? true : result;
  }
  else
  {
    _.assert( 0, '{-src1-} should be instance of Array or Set' );
  }

  return result;

  /* */

  function setElementsCheck( from, e )
  {
    for( let el of src1 )
    {
      if( from === 0 )
      {
        if( _.entity.equal( el, e, onEvaluate1, onEvaluate2 ) )
        {
          result = true;
          break;
        }
        else
        {
          result = false
        }
      }
      else
      {
        from--;
      }
    }
  }
}

// //
//
// /**
//  * The arraySetContainAny() routine returns true, if at least one of the following arrays (arguments[...]),
//  * contains the first matching value from {-srcMap-}.
//  *
//  * @param { longIs } src - The source array.
//  * @param { ...longIs } arguments[...] - The target array.
//  *
//  * @example
//  * _.arraySetContainAny( [ 33, 4, 5, 'b', 'c' ], [ 1, 'b', 'c', 4 ], [ 33, 13, 3 ] );
//  * // returns true
//  *
//  * @example
//  * _.arraySetContainAny( [ 'abc', 'def', true, 26 ], [ 1, 2, 3, 4 ], [ 26, 'abc', 'def', true ] );
//  * // returns true
//  *
//  * @example
//  * _.arraySetContainAny( [ 1, 'b', 'c', 4 ], [ 3, 5, 'd', 'e' ], [ 'abc', 33, 7 ] );
//  * // returns false
//  *
//  * @returns { Boolean } Returns true, if at least one of the following arrays (arguments[...]),
//  * contains the first matching value from {-srcMap-}.
//  * Otherwise, it returns false.
//  * @function arraySetContainAny
//  * @throws { Error } Will throw an Error if {-srcMap-} is not an array-like.
//  * @throws { Error } Will throw an Error if (arguments[...]) is not an array-like.
//  * @namespace Tools
//  */
//
// function arraySetContainAny( src )
// {
//   _.assert( _.longIs( src ) );
//   for( let a = 1 ; a < arguments.length ; a++ )
//   _.assert( _.longIs( arguments[ a ] ) );
//
//   if( src.length === 0 )
//   return true;
//
//   for( let a = 1 ; a < arguments.length ; a++ )
//   {
//     let ins = arguments[ a ];
//
//     let i;
//     for( i = 0 ; i < ins.length ; i++ )
//     {
//       if( src.indexOf( ins[ i ] ) !== -1 )
//       break;
//     }
//
//     if( i === ins.length )
//     return false;
//
//   }
//
//   return true;
// }

//

function containAny_( /* src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let src1 = arguments[ 0 ];
  let src2 = arguments[ 1 ];
  let onEvaluate1 = arguments[ 2 ];
  let onEvaluate2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( src2 ) || _.set.is( src2 ) );

  if( _.arrayIs( src1 ) )
  {
    for( let e of src2 )
    if( _.longLeftIndex( src1, e, onEvaluate1, onEvaluate2 ) !== -1 )
    return true;
  }
  else if( _.set.is( src1 ) )
  {
    let startFrom = 0;
    if( _.number.is( onEvaluate1 ) )
    {
      startFrom = onEvaluate1;
      onEvaluate1 = onEvaluate2;
      onEvaluate2 = undefined;
    }

    for( let e of src2 )
    {
      let from = startFrom;
      for( let el of src1 )
      {
        if( from === 0 )
        {
          if( _.entity.equal( el, e, onEvaluate1, onEvaluate2 ) )
          return true;
        }
        else
        {
          from--;
        }
      }
    }
  }
  else
  {
    _.assert( 0, '{-src1-} should be instance of Array or Set' );
  }

  return false;
}

// //
//
// function arraySetContainNone( src )
// {
//   _.assert( _.longIs( src ) );
//
//   for( let a = 1 ; a < arguments.length ; a++ )
//   {
//
//     _.assert( _.longIs( arguments[ a ] ) );
//
//     for( let i = 0 ; i < src.length ; i++ )
//     {
//
//       if( arguments[ a ].indexOf( src[ i ] ) !== -1 )
//       {
//         return false;
//       }
//
//     }
//
//   }
//
//   return true;
// }

//

function containNone_( /* src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let src1 = arguments[ 0 ];
  let src2 = arguments[ 1 ];
  let onEvaluate1 = arguments[ 2 ];
  let onEvaluate2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( src2 ) || _.set.is( src2 ) );

  if( _.arrayIs( src1 ) )
  {
    for( let e of src2 )
    if( _.longLeftIndex( src1, e, onEvaluate1, onEvaluate2 ) !== -1 )
    return false;
  }
  else if( _.set.is( src1 ) )
  {
    let startFrom = 0;
    if( _.number.is( onEvaluate1 ) )
    {
      startFrom = onEvaluate1;
      onEvaluate1 = onEvaluate2;
      onEvaluate2 = undefined;
    }

    for( let e of src2 )
    {
      let from = startFrom;
      for( let el of src1 )
      {
        if( from === 0 )
        {
          if( _.entity.equal( el, e, onEvaluate1, onEvaluate2 ) )
          return false;
        }
        else
        {
          from--;
        }
      }
    }
  }
  else
  {
    _.assert( 0, '{-src1-} should be instance of Array or Set' );
  }

  return true;
}

//

function containSetsAll( /* src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let src1 = arguments[ 0 ];
  let src2 = arguments[ 1 ];
  let onEvaluate1 = arguments[ 2 ];
  let onEvaluate2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( src1 ) || _.set.is( src1 ) );
  _.assert( _.arrayIs( src2 ) || _.set.is( src2 ) );

  for( let e of src2 )
  if( containAll_( src1, e, onEvaluate1, onEvaluate2 ) === false )
  return false;

  return true;
}

//

function containSetsAny( /* src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let src1 = arguments[ 0 ];
  let src2 = arguments[ 1 ];
  let onEvaluate1 = arguments[ 2 ];
  let onEvaluate2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( src1 ) || _.set.is( src1 ) );
  _.assert( _.arrayIs( src2 ) || _.set.is( src2 ) );

  for( let e of src2 )
  if( containAny_( src1, e, onEvaluate1, onEvaluate2 ) === true )
  return true;

  return false;
}

//

function containSetsNone( /* src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let src1 = arguments[ 0 ];
  let src2 = arguments[ 1 ];
  let onEvaluate1 = arguments[ 2 ];
  let onEvaluate2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( src1 ) || _.set.is( src1 ) );
  _.assert( _.arrayIs( src2 ) || _.set.is( src2 ) );

  for( let e of src2 )
  if( containNone_( src1, e, onEvaluate1, onEvaluate2 ) === false )
  return false;

  return true;
}

//

/**
 * Returns true if ( ins1 ) and ( ins2) arrays have same length and elements, elements order doesn't matter.
 * Inner arrays of arguments are not compared and result of such combination will be false.
 * @param { longIs } ins1 - source array;
 * @param { longIs} ins2 - array to compare with.
 *
 * @example
 * _.arraySet.identical( [ 1, 2, 3 ], [ 4, 5, 6 ] );
 * // returns false
 *
 * @example
 * _.arraySet.identical( [ 1, 2, 4 ], [ 4, 2, 1 ] );
 * // returns true
 *
 * @returns { Boolean } Result of comparison as boolean.
 * @function identical
 * @throws { Error } If one of arguments is not an ArrayLike entity.
 * @throws { Error } If arguments length is not 2.
 * @namespace Tools
 */

function identical( ins1, ins2 )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.longIs( ins1 ) );
  _.assert( _.longIs( ins2 ) );

  if( ins1.length !== ins2.length )
  return false;

  let result = _.arraySet.diff_( null, ins1, ins2 );

  return result.length === 0;
}

//

function left( /* arr, ins, fromIndex, onEvaluate1, onEvaluate2 */ )
{
  let arr = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let fromIndex = arguments[ 2 ];
  let onEvaluate1 = arguments[ 3 ];
  let onEvaluate2 = arguments[ 4 ];

  _.assert( 2 <= arguments.length && arguments.length <= 5 );

  if( _.set.like( arr ) )
  {
    let result = Object.create( null );
    result.index = -1;
    let index = 0;
    let from = 0;

    if( _.routine.is( fromIndex ) )
    {
      onEvaluate2 = onEvaluate1;
      onEvaluate1 = fromIndex;
    }
    else if( _.number.is( fromIndex ) )
    {
      from = fromIndex;
    }

    for( let e of arr )
    {
      if( from === 0 )
      {
        if( _.entity.equal( e, ins, onEvaluate1, onEvaluate2 ) )
        {
          result.index = index;
          result.element = e;
          break;
        }
      }
      else
      {
        from--;
      }
      index++;
    }

    return result;
  }
  else if( _.longLike( arr ) )
  {
    return _.longLeft.apply( this, arguments );
  }
  else
  _.assert( 0 );

}

//

function right( /* arr, ins, fromIndex, onEvaluate1, onEvaluate2 */ )
{
  let arr = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let fromIndex = arguments[ 2 ];
  let onEvaluate1 = arguments[ 3 ];
  let onEvaluate2 = arguments[ 4 ];

  _.assert( 2 <= arguments.length && arguments.length <= 5 );

  if( _.set.like( arr ) )
  {
    let result = Object.create( null );
    result.index = -1;
    let to = arr.size;
    let index = 0;

    if( _.routine.is( fromIndex ) )
    {
      onEvaluate2 = onEvaluate1;
      onEvaluate1 = fromIndex;
    }
    else if( _.number.is( fromIndex ) )
    {
      to = fromIndex;
    }
    else if( fromIndex !== undefined )
    _.assert( 0 );

    for( let e of arr )
    {
      if( index < to )
      {
        if( _.entity.equal( e, ins, onEvaluate1, onEvaluate2 ) )
        {
          result.index = index;
          result.element = e;
        }
      }
      index += 1;
    }

    return result;
  }
  else if( _.longLike( arr ) )
  {
    return _.longRight.apply( this, arguments );
  }
  else
  _.assert( 0 );

}

// --
// implementation
// --

let ToolsExtension =
{

  // array set

  // arraySetDiff, /* !!! : use instead of arraySetDiff */
  arraySetDiff_ : diff_,
  // arraySetBut, /* !!! : use instead of arraySetBut */
  arraySetBut_ : but_,
  // arraySetIntersection, /* !!! : use instead of arraySetIntersection */
  arraySetIntersection_ : intersection_,
  // arraySetUnion, /* !!! : use instead of arraySetUnion */
  arraySetUnion_ : union_,

  // arraySetContainAll, /* !!! : use instead of arraySetContainAll */
  arraySetContainAll_ : containAll_,
  // arraySetContainAny, /* !!! : use instead of arraySetContainAny */
  arraySetContainAny_ : containAny_,
  // arraySetContainNone, /* !!! : use instead of arraySetContainNone */
  arraySetContainNone_ : containNone_,
  arraySetContainSetsAll : containSetsAll,
  arraySetContainSetsAny : containSetsAny,
  arraySetContainSetsNone : containSetsNone,
  arraySetIdentical : identical,

  arraySetLeft : left,
  arraySetRight : right,

  // to replace

  /*
  | routine                 | makes new dst container                       | saves dst container                           |
  | ----------------------- | --------------------------------------------- | --------------------------------------------- |
  | arraySetDiff_           | _.arraySet.diff_( null )                       | _.arraySet.diff_( src1, src2 )                 |
  |                         | _.arraySet.diff_( null, src1 )                 | _.arraySet.diff_( src1, src1, src2 )           |
  |                         | _.arraySet.diff_( null, src1, src2 )           | _.arraySet.diff_( src2, src1, src2 )           |
  |                         |                                               | _.arraySet.diff_( dst, src1, src2 )            |
  | ----------------------- | --------------------------------------------- | --------------------------------------------- |
  | arraySetBut_            | _.arraySet.but_( null )                        | _.arraySet.but_( src1 )                        |
  |                         | _.arraySet.but_( null, src1 )                  | _.arraySet.but_( src1, src2 )                  |
  |                         | _.arraySet.but_( null, src1, src2 )            | _.arraySet.but_( src1, src1, src2 )            |
  |                         |                                               | _.arraySet.but_( src2, src1, src2 )            |
  |                         |                                               | _.arraySet.but_( dst, src1, src2 )             |
  | ----------------------- | --------------------------------------------- | --------------------------------------------- |
  | arraySetIntersection_   | _.arraySet.intersection_( null )               | _.arraySet.intersection_( src1 )               |
  |                         | _.arraySet.intersection_( null, src1 )         | _.arraySet.intersection_( src1, src2 )         |
  |                         | _.arraySet.intersection_( null, src1, src2 )   | _.arraySet.intersection_( src1, src1, src2 )   |
  |                         |                                               | _.arraySet.intersection_( src2, src1, src2 )   |
  |                         |                                               | _.arraySet.intersection_( dst, src1, src2 )    |
  | ----------------------- | --------------------------------------------- | --------------------------------------------- |
  | arraySetUnion_          | _.arraySet.union_( null )                      | _.arraySet.union_( src1 )                      |
  |                         | _.arraySet.union_( null, src1 )                | _.arraySet.union_( src1, src2 )                |
  |                         | _.arraySet.union_( null, src1, src2 )          | _.arraySet.union_( src1, src1, src2 )          |
  |                         |                                               | _.arraySet.union_( src2, src1, src2 )          |
  |                         |                                               | _.arraySet.union_( dst, src1, src2 )           |
  | ----------------------- | --------------------------------------------- | --------------------------------------------- |

  */

}

//

let Extension =
{

  // array set

  // arraySetDiff, /* !!! : use instead of arraySetDiff */
  diff_,
  // arraySetBut, /* !!! : use instead of arraySetBut */
  but_,
  // arraySetIntersection, /* !!! : use instead of arraySetIntersection */
  intersection_,
  // arraySetUnion, /* !!! : use instead of arraySetUnion */
  union_,

  // arraySetContainAll, /* !!! : use instead of arraySetContainAll */
  containAll_,
  // arraySetContainAny, /* !!! : use instead of arraySetContainAny */
  containAny_,
  // arraySetContainNone, /* !!! : use instead of arraySetContainNone */
  containNone_,
  containSetsAll,
  containSetsAny,
  containSetsNone,
  identical,

  left,
  right,

  // to replace

}

Object.assign( Self, Extension );
Object.assign( _, ToolsExtension );

})();

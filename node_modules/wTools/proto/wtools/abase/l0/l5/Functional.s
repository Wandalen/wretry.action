( function _l5_Functional_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// scalar
// --

/**
 * Produce a single array from all arguments if cant return single argument as a scalar.
 * If {-scalarAppend-} gets a single argument it returns the argument as is.
 * If {-scalarAppend-} gets an argument and one or more undefined it returns the argument as is.
 * If {-scalarAppend-} gets more than one or less than one defined arguments then it returns array having all defined arguments.
 * If some argument is a Long ( for example array ) then each element of the Long is treated as an argument, not recursively.
 *
 * @function scalarAppend.
 * @namespace Tools
 */

function scalarAppend( dst, src )
{

  _.assert( arguments.length === 2 );

  if( dst === undefined )
  {
    if( _.longIs( src ) )
    {
      dst = [];
    }
    else
    {
      if( src === undefined )
      return [];
      else
      return src;
    }
  }

  if( _.longIs( dst ) )
  {

    if( !_.arrayIs( dst ) )
    dst = _.array.from( dst );

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    _.arrayAppendArray( dst, src );
    else
    dst.push( src );

  }
  else
  {

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    dst = _.arrayAppendArray( [ dst ], src );
    else
    dst = [ dst, src ];

  }

  return dst;
}

//

function scalarAppendOnce( dst, src )
{

  _.assert( arguments.length === 2 );

  if( dst === undefined )
  {
    if( _.longIs( src ) )
    {
      dst = [];
    }
    else
    {
      if( src === undefined )
      return [];
      else
      return src;
    }
  }

  if( _.longIs( dst ) )
  {

    if( !_.arrayIs( dst ) )
    dst = _.array.from( dst );

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    _.arrayAppendArrayOnce( dst, src );
    else
    _.arrayAppendElementOnce( dst, src );

  }
  else
  {

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    dst = _.arrayAppendArrayOnce( [ dst ], src );
    else
    dst = _.arrayAppendElementOnce( [ dst ], src );

  }

  return dst;
}

//

function scalarPrepend( dst, src )
{

  _.assert( arguments.length === 2 );

  if( dst === undefined )
  {
    if( _.longIs( src ) )
    {
      dst = [];
    }
    else
    {
      if( src === undefined )
      return [];
      else
      return src;
    }
  }

  if( _.longIs( dst ) )
  {

    if( !_.arrayIs( dst ) )
    dst = _.array.from( dst );

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    _.arrayPrependArray( dst, src );
    else
    dst.splice( 0, 0, src );

  }
  else
  {

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    dst = _.arrayPrependArray( [ dst ], src );
    else
    dst = [ src, dst ];

  }

  return dst;
}

//

function scalarPrependOnce( dst, src )
{

  _.assert( arguments.length === 2 );

  if( dst === undefined )
  {
    if( _.longIs( src ) )
    {
      dst = [];
    }
    else
    {
      if( src === undefined )
      return [];
      else
      return src;
    }
  }

  if( _.longIs( dst ) )
  {

    if( !_.arrayIs( dst ) )
    dst = _.array.from( dst );

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    _.arrayPrependArrayOnce( dst, src );
    else
    _.arrayPrependElementOnce( dst, src );

  }
  else
  {

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    dst = _.arrayPrependArrayOnce( [ dst ], src );
    else
    dst = _.arrayPrependElementOnce( [ dst ], src );

  }

  return dst;
}

/**
 * The scalarToVector() routine returns a new array
 * which containing the static elements only type of Number.
 *
 * It takes two arguments (dst) and (length)
 * checks if the (dst) is a Number, If the (length) is greater than or equal to zero.
 * If true, it returns the new array of static (dst) numbers.
 * Otherwise, if the first argument (dst) is an Array,
 * and its (dst.length) is equal to the (length),
 * it returns the original (dst) Array.
 * Otherwise, it throws an Error.
 *
 * @param { ( Number | Array ) } dst - A number or an Array.
 * @param { Number } length - The length of the new array.
 *
 * @example
 * _.scalarToVector( 3, 7 );
 * // returns [ 3, 3, 3, 3, 3, 3, 3 ]
 *
 * @example
 * _.scalarToVector( [ 3, 7, 13 ], 3 );
 * // returns [ 3, 7, 13 ]
 *
 * @returns { Number[] | Array } - Returns the new array of static numbers or the original array.
 * @function scalarToVector
 * @throws { Error } If missed argument, or got less or more than two arguments.
 * @throws { Error } If type of the first argument is not a number or array.
 * @throws { Error } If the second argument is less than 0.
 * @throws { Error } If (dst.length) is not equal to the (length).
 * @namespace Tools
 */

// function arrayFromNumber( dst, length )
function scalarToVector( dst, length )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  // _.assert( _.number.is( dst ) || _.arrayIs( dst ), 'Expects array of number as argument' );
  _.assert( dst !== undefined, 'Expects array or scalar' );
  _.assert( length >= 0 );

  if( _.arrayIs( dst ) )
  {
    _.assert( dst.length === length, () => 'Expects array of length ' + length + ' but got ' + dst.length );
  }
  else
  {
    dst = _.longFill( [], dst, [ 0, length ] );
  }

  return dst;
}

//

function scalarFrom( src )
{
  if( _.longIs( src ) && src.length === 1 )
  return src[ 0 ];
  return src;
}

//

function scalarFromOrNull( src )
{
  if( _.longIs( src ) )
  {
    if( src.length === 1 )
    return src[ 0 ];
    else if( src.length === 0 )
    return null;
  }
  return src;
}

// --
// multiplier
// --

function dup( ins, times, result )
{
  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );
  _.assert( _.number.is( times ) || _.longIs( times ), 'dup expects times as number or array' );

  if( _.number.is( times ) )
  {
    if( !result )
    result = new Array( times );
    for( let t = 0 ; t < times ; t++ )
    result[ t ] = ins;
    return result;
  }
  else if( _.longIs( times ) )
  {
    _.assert( times.length === 2 );
    let l = times[ 1 ] - times[ 0 ];
    if( !result )
    result = new Array( times[ 1 ] );
    for( let t = 0 ; t < l ; t++ )
    result[ times[ 0 ] + t ] = ins;
    return result;
  }
  else _.assert( 0, 'unexpected' );

}

//

function multiple( src, times )
{
  _.assert( arguments.length === 2 );
  if( _.argumentsArray.like( src ) )
  _.assert( src.length === times, () => 'Vector should have ' + times + ' elements, but have ' + src.length );
  else
  src = _.dup( src, times );
  return src;
}

//

function multipleAll( dsts )
{
  let length;

  _.assert( arguments.length === 1 );

  for( let d = 0 ; d < dsts.length ; d++ )
  if( _.arrayIs( dsts[ d ] ) )
  {
    length = dsts[ d ].length;
    break;
  }

  if( length === undefined )
  return dsts;

  for( let d = 0 ; d < dsts.length ; d++ )
  dsts[ d ] = _.multiple( dsts[ d ], length );

  return dsts;
}

// --
// entity iterator
// --

function entityEach( src, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( onEach.length <= 3 );
  _.assert( _.routine.is( onEach ) );

  /* */

  /* qqq for junior : add branch for countable case */
  if( _.longIs( src ) )
  {

    for( let k = 0 ; k < src.length ; k++ )
    {
      onEach( src[ k ], k, src );
    }

  }
  else if( _.aux.is( src ) )
  {

    for( let k in src )
    {
      onEach( src[ k ], k, src );
    }

  }
  else
  {
    onEach( src, undefined, undefined );
  }

  /* */

  return src;
}

//

function entityEachOwn( src, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( onEach.length <= 3 );
  _.assert( _.routine.is( onEach ) );

  /* */

  /* qqq for junior : add branch for countable case */
  if( _.longIs( src ) )
  {

    for( let k = 0 ; k < src.length ; k++ )
    {
      onEach( src[ k ], k, src );
    }

  }
  else if( _.aux.is( src ) || _.object.like( src ) )
  {

    for( let k in src )
    {
      if( !Object.hasOwnProperty.call( src, k ) )
      continue;
      onEach( src[ k ], k, src );
    }

  }
  else
  {
    onEach( src, undefined, undefined );
  }

  /* */

  return src;
}

//

/*

LongLike / Aux / HashMapLike / SetLike


_.only( Array::dst, Map::src );
_.only( Array::dst, Set::src );

*/

/**
 * The routine entityOnly() provides the filtering of elements of destination container
 * {-dst-} by checking values in the source container {-src-}. The routine checks values
 * with the same keys in both containers. If a received {-src-} element has falsy value, then
 * element with the same key deletes from the {-dst-} container.
 *
 * If {-dst-} container is null, routine makes new container with type of {-src-} container, and fill it obtained values.
 * If {-src-} is undefined, routine filters {-dst-} container obtaining values from {-dst-}.
 * Note: containers should have same type.
 *
 * Also, {-dst-} and {-src-} might be not iteratable element, for example, primitive.
 * If {-dst-} is not iteratable, then routine check value of {-src-}.
 *
 * @param { ArrayLike|Set|Map|Object|* } dst - Container or another single element for filtering.
 * If {-dst-} is null, then makes new container of {-src-} type.
 * @param { ArrayLike|Set|Map|Object|* } src - Container or another single element for filtering.
 * If {-src-} is undefined, then {-dst-} filters by its own values.
 * @param { Function } onEach - The callback that obtain value for every {-src-} element. The
 * callback accepts three parameters - element, key, source container.
 *
 * @example
 * _.entityOnly( 'str', 1 );
 * // returns 'str'
 *
 * @example
 * _.entityOnly( 'str', 1, ( e, k, src ) => e - 1 );
 * // returns undefined
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityOnly( null, src );
 * // returns [ 1, true ]
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityOnly( null, src, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityOnly( dst );
 * // returns [ true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityOnly( dst, undefined, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * let src = [ 1, 2, false, undefined, 0 ];
 * _.entityOnly( dst, src );
 * // returns [ '', 0, true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * let src = [ 1, 2, false, undefined, 0 ];
 * _.entityOnly( dst, undefined, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @returns { ArrayLike|Set|Map|Object|* } - Returns filtered container.
 * If {-dst-} is not iteratable value, routine returns original {-dst-} or undefined.
 * @function entityOnly
 * @throws { Error } If arguments.length is less then one or more than three arguments.
 * @throws { Error } If {-dst-} is not null or {-dst-} and {-src-} containers has different types.
 * @throws { Error } If {-onEach-} is not undefined, not a routine, not selector.
 * @throws { Error } If onEach.length is more then three.
 * @throws { Error } If {-onEach-} is selector and it does not begin with '*\/'.
 * @namespace Tools
 */

function entityOnly( dst, src, onEach )
{

  if( arguments.length > 2 )
  onEach = arguments[ arguments.length-1 ];

  if( src === undefined )
  src = dst;

  if( _.strIs( onEach ) )
  {
    let selector = onEach;
    /* xxx : qqq : for Dmytro : fix that. ask how to */
    _.assert( _.routine.is( _.select ) );
    _.assert( _.strBegins( selector, '*/' ), () => `Selector should begins with "*/", but "${selector}" does not` );
    selector = _.strRemoveBegin( selector, '*/' );
    onEach = function( e, k )
    {
      return _.select( e, selector );
    }
  }

  let dstTypeStr = typeStr( dst );
  let srcTypeStr = typeStr( src );

  _.assert( dst === null || dstTypeStr === srcTypeStr );
  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( onEach === undefined || ( _.routine.is( onEach ) && onEach.length <= 3 ), 'Expects optional routine or selector {- onEach -}' );

  /* */

  /*

    let srcHas = null;
    if ...
    srcHas = srcHasMap;
    else ...
    srcHas = srcHasSet;

  */

  /* */

  if( dst !== null )
  // if( dst === src )
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutineDeleting();
      else
      withRoutineDeleting();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutineDeleting();
      else
      withoutRoutineDeleting();
    }

  }
  else
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutine();
      else
      withRoutine();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutine();
      else
      withoutRoutine(); /* don't change the subroutine */
    }

  }

  /* */

  return dst;

  /* */

  function setWithRoutine()
  {
    dst = new Set( src );

    for( let value of src )
    {
      let res = onEach( value, undefined, src );
      if( !res )
      dst.delete( value );
    }
  }

  /* */

  function setWithoutRoutine()
  {
    dst = new Set( src );

    let unnecessaries = [ null, 0, undefined, false, '' ];
    for( let key of unnecessaries )
    if( dst.has( key ) )
    dst.delete( key );
  }

  /* */

  function hashMapWithRoutine()
  {
    dst = new HashMap( src );

    for( let [ key, value ] of src )
    {
      let res = onEach( value, key, src );
      if( !res )
      dst.delete( key );
    }
  }

  /* */

  function hashMapWithoutRoutine()
  {
    dst = new HashMap( src );

    for( let [ key, value ] of dst )
    if( !value )
    dst.delete( key );
  }

  /* */

  function withRoutine()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {

      dst = [];
      for( let k = 0 ; k < src.length ; k++ )
      {
        let res = onEach( src[ k ], k, src );
        if( res )
        dst.push( src[ k ] );
      }

    }
    else if( _.aux.is( src ) )
    {

      dst = Object.create( null );
      for( let k in src )
      {
        let res = onEach( src[ k ], k, src );
        if( res )
        dst[ k ] = src[ k ];
      }

    }
    else
    {
      let res = onEach( src, undefined, undefined );
      if( res )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function withoutRoutine()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {

      dst = [];
      for( let k = 0 ; k < src.length ; k++ )
      {
        let res = src[ k ];
        if( res )
        dst.push( src[ k ] );
      }

    }
    else if( _.aux.is( src ) )
    {

      dst = Object.create( null );
      for( let k in src )
      {
        let res = src[ k ];
        if( res )
        dst[ k ] = src[ k ];
      }

    }
    else
    {
      let res = src;
      if( res )
      dst = res;
      else
      dst = undefined;
    }

  }

  /* */

  function setWithRoutineDeleting()
  {
    for( let value of src )
    {
      let res = onEach( value, undefined, src );
      if( !res )
      dst.delete( value );
    }
  }

  /* */

  function setWithoutRoutineDeleting()
  {
    let unnecessaries = [ null, 0, undefined, false, '' ];
    for( let key of unnecessaries )
    {
      if( src.has( key ) )
      dst.delete( key );
    }
  }

  /* */

  function hashMapWithRoutineDeleting()
  {
    for( let [ key, value ] of src )
    {
      let res = onEach( value, key, src )
      if( !res )
      dst.delete( key );
    }
  }

  /* */

  function hashMapWithoutRoutineDeleting()
  {
    for( let [ key, value ] of src )
    if( !value )
    dst.delete( key );
  }

  /* */

  function withRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      for( let k = dst.length - 1; k >= 0; k-- )
      {
        let res = onEach( src[ k ], k, src );
        if( !res )
        dst.splice( k, 1 );
      }

    }
    else if( _.aux.is( dst ) )
    {

      for( let k in dst )
      {
        let res = onEach( src[ k ], k, src );
        if( !res )
        delete dst[ k ];
      }

    }
    else
    {
      let res = onEach( src, undefined, undefined );
      if( !res )
      dst = undefined;
    }

  }

  /* */

  function withoutRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      for( let k = dst.length - 1; k >= 0; k-- )
      {
        let res = src[ k ];
        if( !res )
        dst.splice( k, 1 );
      }
    }
    else if( _.aux.is( dst ) )
    {

      for( let k in dst )
      {
        let res = src[ k ];
        if( !res )
        delete dst[ k ];
      }

    }
    else
    {
      let res = src;
      if( !res )
      dst = undefined;
    }

  }

  function typeStr( e )
  {
    let type;
    if( _.longIs( e ) )
    type = 'long';
    else if( _.aux.is( e ) )
    type = 'map';
    else if( _.set.is( e ) )
    type = 'set';
    else if( _.hashMap.is( e ) )
    type = 'hashMap';
    else
    type = 'primitive';

    return type;
  }

}

//

/**
 * The routine entityBut() provides the filtering of elements of destination container
 * {-dst-} by checking values in the source container {-src-}. The routine checks values
 * with the same keys in both containers. If a received {-src-} element has not falsy value, then
 * element with the same key deletes from the {-dst-} container.
 *
 * If {-dst-} container is null, routine makes new container with type of {-src-} container, and fill it obtained values.
 * If {-src-} is undefined, routine filters {-dst-} container obtaining values from {-dst-}.
 * Note: containers should have same type.
 *
 * Also, {-dst-} and {-src-} might be not iteratable element, for example, primitive.
 * If {-dst-} is not iteratable, then routine check value of {-src-}.
 *
 * @param { ArrayLike|Set|Map|Object|* } dst - Container or another single element for filtering.
 * If {-dst-} is null, then makes new container of {-src-} type.
 * @param { ArrayLike|Set|Map|Object|* } src - Container or another single element for filtering.
 * If {-src-} is undefined, then {-dst-} filters by its own values.
 * @param { Function } onEach - The callback that obtain value for every {-src-} element. The
 * callback accepts three parameters - element, key, source container.
 *
 * @example
 * _.entityBut( 'str', 1 )
 * // returns undefined
 *
 * @example
 * _.entityBut( 'str', 1, ( e, k, src ) => e - 1 )
 * // returns 'str'
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityBut( null, src );
 * // returns [ 0, null, undefined ]
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityBut( null, src, ( e, k ) => k );
 * // returns [ 1 ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityBut( dst );
 * // returns [ '', 0, null, undefined ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityBut( dst, undefined, ( e, k ) => k );
 * // returns [ '' ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * let src = [ 1, 2, false, undefined, 0 ]
 * _.entityBut( dst, src );
 * // returns [ null, undefined ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * let src = [ 1, 2, false, undefined, 0 ]
 * _.entityBut( dst, undefined, ( e, k ) => k );
 * // returns [ '' ]
 *
 * @returns { ArrayLike|Set|Map|Object|* } - Returns filtered container.
 * If {-dst-} is not iteratable value, routine returns original {-dst-} or undefined.
 * @function entityBut
 * @throws { Error } If arguments.length is less then one or more than three arguments.
 * @throws { Error } If {-dst-} is not null or {-dst-} and {-src-} containers has different types.
 * @throws { Error } If {-onEach-} is not undefined, not a routine, not selector.
 * @throws { Error } If onEach.length is more then three.
 * @throws { Error } If {-onEach-} is selector and it does not begin with '*\/'.
 * @namespace Tools
 */

function entityBut( dst, src, onEach )
{

  if( arguments.length > 2 )
  onEach = arguments[ arguments.length-1 ];

  if( src === undefined )
  src = dst;

  if( _.strIs( onEach ) )
  {
    let selector = onEach;
    _.assert( _.routine.is( _.select ) );
    _.assert( _.strBegins( selector, '*/' ), () => `Selector should begins with "*/", but "${selector}" does not` );
    selector = _.strRemoveBegin( selector, '*/' );
    onEach = function( e, k )
    {
      return _.select( e, selector );
    }
  }

  let dstTypeStr = typeStr( dst );
  let srcTypeStr = typeStr( src );

  _.assert( dst === null || dstTypeStr === srcTypeStr );
  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( onEach === undefined || ( _.routine.is( onEach ) && onEach.length <= 3 ), 'Expects optional routine or selector {- onEach -}' );

  /* */

  if( dst !== null )
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutineDeleting();
      else
      withRoutineDeleting();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutineDeleting();
      else
      withoutRoutineDeleting();
    }

  }
  else
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutine();
      else
      withRoutine();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutine();
      else
      withoutRoutine(); /* don't change the subroutine */
    }

  }

  /* */

  return dst;

  /* */

  function setWithRoutine()
  {
    dst = new Set( null );

    for( let value of src )
    {
      let res = onEach( value, undefined, src );
      if( !res )
      dst.add( value );
    }
  }

  /* */

  function setWithoutRoutine()
  {
    dst = new Set( null );

    // Dmytro : it'll be faster, but can't keep order of elements
    // let unnecessaries = [ undefined, 0, null, false, '' ];
    // for( let key of unnecessaries )
    // if( src.has( key ) )
    // dst.add( key );
    for( let e of src )
    if( !e )
    dst.add( e );
  }

  /* */

  function hashMapWithRoutine()
  {
    dst = new HashMap( null );

    for( let [ key, value ] of src )
    {
      let res = onEach( value, key, src );
      if( !res )
      dst.set( key, value );
    }
  }

  /* */

  function hashMapWithoutRoutine()
  {
    dst = new HashMap( null );

    for( let [ key, value ] of src )
    if( !value )
    dst.set( key, value );
  }

  /* */

  function withRoutine()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {

      dst = [];
      for( let k = 0 ; k < src.length ; k++ )
      {
        let res = onEach( src[ k ], k, src );
        if( !res )
        dst.push( src[ k ] );
      }

    }
    else if( _.aux.is( src ) )
    {

      dst = Object.create( null );
      for( let k in src )
      {
        let res = onEach( src[ k ], k, src );
        if( !res )
        dst[ k ] = src[ k ];
      }

    }
    else
    {
      let res = onEach( src, undefined, undefined );
      if( !res )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function withoutRoutine()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {

      dst = [];
      for( let k = 0 ; k < src.length ; k++ )
      {
        let res = src[ k ];
        if( !res )
        dst.push( src[ k ] );
      }

    }
    else if( _.aux.is( src ) )
    {

      dst = Object.create( null );
      for( let k in src )
      {
        let res = src[ k ];
        if( !res )
        dst[ k ] = src[ k ];
      }

    }
    else
    {
      let res = src;
      if( !res )
      dst = res;
      else
      dst = undefined;
    }

  }

  /* */

  function setWithRoutineDeleting()
  {
    for( let value of src )
    {
      let res = onEach( value, undefined, src );
      if( res )
      dst.delete( value );
    }
  }

  /* */

  function setWithoutRoutineDeleting()
  {
    for( let value of src )
    {
      if( value )
      dst.delete( value );
    }
  }

  /* */

  function hashMapWithRoutineDeleting()
  {
    for( let [ key, value ] of src )
    {
      let res = onEach( value, key, src )
      if( res )
      dst.delete( key );
    }
  }

  /* */

  function hashMapWithoutRoutineDeleting()
  {
    for( let [ key, value ] of src )
    if( value )
    dst.delete( key );
  }

  /* */

  function withRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      for( let k = dst.length - 1; k >= 0; k-- )
      {
        let res = onEach( src[ k ], k, src );
        if( res )
        dst.splice( k, 1 );
      }

    }
    else if( _.aux.is( dst ) )
    {

      for( let k in dst )
      {
        let res = onEach( src[ k ], k, src );
        if( res )
        delete dst[ k ];
      }

    }
    else
    {
      let res = onEach( src, undefined, undefined );
      if( res )
      dst = undefined;
    }

  }

  /* */

  function withoutRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      for( let k = dst.length - 1; k >= 0; k-- )
      {
        let res = src[ k ];
        if( res )
        dst.splice( k, 1 );
      }

    }
    else if( _.aux.is( dst ) )
    {

      for( let k in dst )
      {
        let res = src[ k ];
        if( res )
        delete dst[ k ];
      }

    }
    else
    {
      let res = src;
      if( res )
      dst = undefined;
      else
      dst = dst;
    }

  }

  /* xxx */
  function typeStr( e )
  {
    let type;
    if( _.longIs( e ) )
    type = 'long';
    else if( _.aux.is( e ) )
    type = 'map';
    else if( _.set.is( e ) )
    type = 'set';
    else if( _.hashMap.is( e ) )
    type = 'hashMap';
    else
    type = 'primitive';

    return type;
  }

}

//

/**
 * The routine entityAnd() provides the filtering of elements of destination container
 * {-dst-} by checking values with the same keys in the {-dst-} and source {-src-} containers.
 * If one of received values is falsy, then element with deletes from the {-dst-} container.
 *
 * If {-dst-} container is null, routine makes new container with type of {-src-} container, and fill it obtained values.
 * If {-src-} is undefined, routine filters {-dst-} container obtaining values from {-dst-}.
 * Note: containers should have same type.
 *
 * Also, {-dst-} and {-src-} might be not iteratable element, for example, primitive.
 * If {-dst-} is not iteratable, then routine check value of {-src-}.
 *
 * @param { ArrayLike|Set|Map|Object|* } dst - Container or another single element for filtering.
 * If {-dst-} is null, then makes new container of {-src-} type.
 * @param { ArrayLike|Set|Map|Object|* } src - Container or another single element for filtering.
 * If {-src-} is undefined, then {-dst-} filters by its own values.
 * @param { Function } onEach - The callback that obtain value for every {-dst-} and {-src-} element
 * with the same keys. The callback accepts three parameters - element, key, source container.
 *
 * @example
 * _.entityAnd( 'str', 1 );
 * // returns 'str'
 *
 * @example
 * _.entityAnd( 'str', 1, ( e, k, src ) => e - 1 );
 * // returns undefined
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityAnd( null, src );
 * // returns [ 1, true ]
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityAnd( null, src, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityAnd( dst );
 * // returns [ true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityAnd( dst, undefined, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * let src = [ 1, 2, false, undefined, 0 ];
 * _.entityAnd( dst, src );
 * // returns []
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * let src = [ 1, 2, false, undefined, 0 ];
 * _.entityAnd( dst, undefined, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @returns { ArrayLike|Set|Map|Object|* } - Returns filtered container.
 * If {-dst-} is not iteratable value, routine returns original {-dst-} or undefined.
 * @function entityAnd
 * @throws { Error } If arguments.length is less then one or more than three arguments.
 * @throws { Error } If {-dst-} is not null or {-dst-} and {-src-} containers has different types.
 * @throws { Error } If {-onEach-} is not undefined, not a routine, not selector.
 * @throws { Error } If onEach.length is more then three.
 * @throws { Error } If {-onEach-} is selector and it does not begin with '*\/'.
 * @namespace Tools
 */

function entityAnd( dst, src, onEach )
{

  if( arguments.length > 2 )
  onEach = arguments[ arguments.length-1 ];

  if( src === undefined )
  src = dst;

  if( _.strIs( onEach ) )
  {
    let selector = onEach;
    _.assert( _.routine.is( _.select ) );
    _.assert( _.strBegins( selector, '*/' ), () => `Selector should begins with "*/", but "${selector}" does not` );
    selector = _.strRemoveBegin( selector, '*/' );
    onEach = function( e, k )
    {
      return _.select( e, selector );
    }
  }

  let dstTypeStr = typeStr( dst );
  let srcTypeStr = typeStr( src );

  _.assert( dst === null || dstTypeStr === srcTypeStr );
  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( onEach === undefined || ( _.routine.is( onEach ) && onEach.length <= 3 ), 'Expects optional routine or selector {- onEach -}' );

  /* */

  if( dst !== null )
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutineDeleting();
      else
      withRoutineDeleting();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutineDeleting();
      else
      withoutRoutineDeleting();
    }

  }
  else
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutine();
      else
      withRoutine();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutine();
      else
      withoutRoutine(); /* don't change the subroutine */
    }

  }

  return dst;

  /* */

  function setWithRoutine()
  {
    dst = new Set( null );

    for( let value of src )
    {
      let res = onEach( value, undefined, src );
      if( res )
      dst.add( value );
    }
  }

  /* */

  function setWithoutRoutine()
  {
    dst = new Set( src );

    let unnecessaries = [ null, 0, undefined, false, '' ];
    for( let key of unnecessaries )
    if( src.has( key ) )
    dst.delete( key );
  }

  /* */

  function hashMapWithRoutine()
  {
    dst = new HashMap( null );

    for( let [ key, value ] of src )
    {
      let res = onEach( value, key, src );
      if( res )
      dst.set( key, value );
    }
  }

  /* */

  function hashMapWithoutRoutine()
  {
    dst = new HashMap( null );

    for( let [ key, value ] of src )
    if( value )
    dst.set( key, value );
  }

  /* */

  function withRoutine()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {

      dst = [];
      for( let k = 0; k < src.length; k++ )
      {
        let res = onEach( src[ k ], k, src );
        if( res )
        dst.push( src[ k ] );
      }

    }
    else if( _.aux.is( src ) )
    {

      dst = Object.create( null );
      for( let k in src )
      {
        let res = onEach( src[ k ], k, src );
        if( res )
        dst[ k ] = src[ k ];
      }

    }
    else
    {
      let res = onEach( src, undefined, undefined );
      if( res )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function withoutRoutine()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {

      dst = [];
      for( let k = 0; k < src.length; k++ )
      {
        let res = src[ k ];
        if( res )
        dst.push( src[ k ] );
      }

    }
    else if( _.aux.is( src ) )
    {

      dst = Object.create( null );
      for( let k in src )
      {
        let res = src[ k ];
        if( res )
        dst[ k ] = src[ k ];
      }

    }
    else
    {
      let res = src;
      if( res )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function setWithRoutineDeleting()
  {

    for( let value of dst )
    {
      let res1, res2;
      let from = [ ... src ]

      res1 = onEach( value, undefined, dst );
      if( res1 && from.lastIndexOf( value ) !== -1 )
      res2 = onEach( value, undefined, from );
      else if( res1 )
      res2 = onEach( undefined, undefined, src );

      if( !res1 || !res2 )
      dst.delete( value );
    }
  }

  /* */

  function setWithoutRoutineDeleting()
  {
    for( let value of dst )
    {
      if( !value || !src.has( value ) )
      dst.delete( value );
    }
  }

  /* */

  function hashMapWithRoutineDeleting()
  {
    for( let [ key, value ] of dst )
    {
      let res1, res2;
      res1 = onEach( value, key, dst )
      if( res1 !== undefined && src.has( key ) )
      res2 = onEach( src.get( key ), key, src );

      if( !res1 || !res2 )
      dst.delete( key );
    }
  }

  /* */

  function hashMapWithoutRoutineDeleting()
  {
    for( let [ key, value ] of dst )
    if( !value || !src.get( key ) )
    dst.delete( key );
  }

  /* */

  function withRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      dst = _.arrayIs( dst ) ? dst : _.array.make( dst );
      for( let k = dst.length - 1; k >= 0; k-- )
      {
        let res1, res2;
        res1 = onEach( dst[ k ], k, dst );
        if( res1 )
        res2 = onEach( src[ k ], k, src );
        if( !res1 || !res2 )
        dst.splice( k, 1 );
      }

    }
    else if( _.aux.is( dst ) )
    {

      for( let k in dst )
      {
        let res1, res2;
        res1 = onEach( dst[ k ], k, dst );
        if( res1 )
        res2 = onEach( src[ k ], k, src );
        if( !res1 || !res2 )
        delete dst[ k ];
      }

    }
    else
    {
      let res1, res2;
      res1 = onEach( dst, undefined, undefined );
      if( res1 )
      res2 = onEach( src, undefined, undefined );
      if( !res1 || !res2 )
      dst = undefined;
    }

  }

  /* */

  function withoutRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      dst = _.arrayIs( dst ) ? dst : _.array.make( dst );
      for( let k = dst.length - 1; k >= 0; k-- )
      {
        let res1 = dst[ k ];
        let res2 = src[ k ];
        if( !res1 || !res2 )
        dst.splice( k, 1 );
      }

    }
    else if( _.aux.is( dst ) )
    {

      for( let k in dst )
      {
        let res1 = dst[ k ];
        let res2 = src[ k ];
        if( !res1 || !res2 )
        delete dst[ k ];
      }

    }
    else
    {
      let res1 = dst;
      let res2 = src;
      if( !res1 || !res2 )
      dst = undefined;
    }

  }

  function typeStr( e )
  {
    let type;
    if( _.longIs( e ) )
    type = 'long';
    else if( _.aux.is( e ) )
    type = 'map';
    else if( _.set.is( e ) )
    type = 'set';
    else if( _.hashMap.is( e ) )
    type = 'hashMap';
    else
    type = 'primitive';

    return type;
  }

}

//

/**
 * The routine entityOr() provides the filtering of elements of destination container
 * {-dst-} by checking values with the same keys in the {-dst-} and source {-src-} containers.
 * If checking of {-dst-} element returs true, routine save {-dst-} element.
 * If checking of {-dst-} element return false and checking of {-src-} element returns true,
 * routine replace {-dst-} element by {-src-} element.
 * Else, routine deletes {-dst-} element.
 *
 * If {-dst-} container is null, routine makes new container with type of {-src-} container, and fill it obtained values.
 * If {-src-} is undefined, routine filters {-dst-} container obtaining values from {-dst-}.
 * Note: containers should have same type.
 *
 * Also, {-dst-} and {-src-} might be not iteratable element, for example, primitive.
 * If {-dst-} is not iteratable, then routine check value of {-src-}.
 *
 * @param { ArrayLike|Set|Map|Object|* } dst - Container or another single element for filtering.
 * If {-dst-} is null, then makes new container of {-src-} type.
 * @param { ArrayLike|Set|Map|Object|* } src - Container or another single element for filtering.
 * If {-src-} is undefined, then {-dst-} filters by its own values.
 * @param { Function } onEach - The callback that obtain value for every {-dst-} and {-src-} element
 * with the same keys. The callback accepts three parameters - element, key, source container.
 *
 * @example
 * _.entityOr( 'str', undefined );
 * // returns 'str'
 *
 * @example
 * _.entityOr( false, 1, ( e, k, src ) => e - 1 );
 * // returns 1
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityOr( null, src );
 * // returns [ 1, true ]
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityOr( null, src, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityOr( dst );
 * // returns [ true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityOr( dst, undefined, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * let src = [ 1, 2, false, undefined, 0 ];
 * _.entityOr( dst, src );
 * // returns [ 1, 2, true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * let src = [ 1, 2, false, undefined, 0 ];
 * _.entityOr( dst, undefined, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @returns { ArrayLike|Set|Map|Object|* } - Returns filtered container.
 * If {-dst-} is not iteratable value, routine returns original {-dst-} or undefined.
 * @function entityOr
 * @throws { Error } If arguments.length is less then one or more than three arguments.
 * @throws { Error } If {-dst-} is not null or {-dst-} and {-src-} containers has different types.
 * @throws { Error } If {-onEach-} is not undefined, not a routine, not selector.
 * @throws { Error } If onEach.length is more then three.
 * @throws { Error } If {-onEach-} is selector and it does not begin with '*\/'.
 * @namespace Tools
 */

function entityOr( dst, src, onEach )
{

  if( arguments.length > 2 )
  onEach = arguments[ arguments.length-1 ];

  if( src === undefined )
  src = dst;

  if( _.strIs( onEach ) )
  {
    let selector = onEach;
    _.assert( _.routine.is( _.select ) );
    _.assert( _.strBegins( selector, '*/' ), () => `Selector should begins with "*/", but "${selector}" does not` );
    selector = _.strRemoveBegin( selector, '*/' );
    onEach = function( e, k )
    {
      return _.select( e, selector );
    }
  }

  let dstTypeStr = typeStr( dst );
  let srcTypeStr = typeStr( src );

  _.assert( dst === null || dstTypeStr === srcTypeStr );
  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( onEach === undefined || ( _.routine.is( onEach ) && onEach.length <= 3 ), 'Expects optional routine or selector {- onEach -}' );

  /* */

  if( dst !== null )
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutineDeleting();
      else
      withRoutineDeleting();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutineDeleting();
      else
      withoutRoutineDeleting();
    }

  }
  else
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutine();
      else
      withRoutine();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutine();
      else
      withoutRoutine(); /* don't change the subroutine */
    }

  }

  return dst;

  /* */

  function setWithRoutine()
  {
    dst = new Set( null );

    for( let value of src )
    {
      let res = onEach( value, undefined, src );
      if( res )
      dst.add( value );
    }
  }

  /* */

  function setWithoutRoutine()
  {
    dst = new Set( src );

    let unnecessaries = [ null, 0, undefined, false, '' ];
    for( let key of unnecessaries )
    if( src.has( key ) )
    dst.delete( key );
  }

  /* */

  function hashMapWithRoutine()
  {
    dst = new HashMap( null );

    for( let [ key, value ] of src )
    {
      let res = onEach( value, key, src );
      if( res )
      dst.set( key, value );
    }
  }

  /* */

  function hashMapWithoutRoutine()
  {
    dst = new HashMap( null );

    for( let [ key, value ] of src )
    if( value )
    dst.set( key, value );
  }

  /* */

  function withRoutine()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {

      dst = [];
      for( let k = 0; k < src.length; k++ )
      {
        let res = onEach( src[ k ], k, src );
        if( res )
        dst.push( src[ k ] );
      }

    }
    else if( _.aux.is( src ) )
    {

      dst = Object.create( null );
      for( let k in src )
      {
        let res = onEach( src[ k ], k, src );
        if( res )
        dst[ k ] = src[ k ];
      }

    }
    else
    {
      let res = onEach( src, undefined, undefined );
      if( res )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function withoutRoutine()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {

      dst = [];
      for( let k = 0; k < src.length; k++ )
      {
        let res = src[ k ];
        if( res )
        dst.push( src[ k ] );
      }

    }
    else if( _.aux.is( src ) )
    {

      dst = Object.create( null );
      for( let k in src )
      {
        let res = src[ k ];
        if( res )
        dst[ k ] = src[ k ];
      }

    }
    else
    {
      let res = src;
      if( res )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function setWithRoutineDeleting()
  {
    for( let key of dst )
    {
      let res1, res2;
      res1 = onEach( key, undefined, dst );
      if( !res1 && src.has( key ) )
      res2 = onEach( key, undefined, src );
      else
      res2 = onEach( undefined, undefined, src );

      if( !res1 && !res2 )
      dst.delete( key );
    }
  }

  /* */

  function setWithoutRoutineDeleting()
  {
    for( let value of dst )
    {
      if( !value )
      dst.delete( value );
    }
  }

  /* */

  function hashMapWithRoutineDeleting()
  {
    for( let [ key, value ] of dst )
    {
      let res1, res2
      res1 = onEach( value, key, dst )
      if( !res1 && src.has( key ) )
      res2 = onEach( src.get( key ), key, src );
      else
      res2 = onEach( undefined, undefined, src );

      if( res1 )
      dst.set( key, value );
      else if( res2 )
      dst.set( key, src.get( key ) );
      else
      dst.delete( key );
    }
  }

  /* */

  function hashMapWithoutRoutineDeleting()
  {
    for( let [ key, value ] of dst )
    {
      if( !value )
      {
        let res = src.get( key );

        if( res )
        dst.set( key, res );
        else
        dst.delete( key );
      }
    }
  }

  /* */

  function withRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      dst = _.arrayIs( dst ) ? dst : _.array.make( dst );
      for( let k = dst.length - 1; k >= 0; k-- )
      {
        let res1, res2;
        res1 = onEach( dst[ k ], k, dst );
        if( !res1 )
        res2 = onEach( src[ k ], k, src );

        if( res1 )
        dst[ k ] = dst[ k ];
        else if( res2 )
        dst[ k ] = src[ k ];
        else
        dst.splice( k, 1 );
      }

    }
    else if( _.aux.is( dst ) )
    {

      for( let k in dst )
      {
        let res1, res2;
        res1 = onEach( dst[ k ], k, dst );
        if( !res1 )
        res2 = onEach( src[ k ], k, src );

        if( res1 )
        dst[ k ] = dst[ k ];
        else if( res2 )
        dst[ k ] = src[ k ];
        else
        delete dst[ k ];
      }

    }
    else
    {
      let res1, res2;
      res1 = onEach( dst, undefined, undefined );
      if( !res1 )
      res2 = onEach( src, undefined, undefined );

      if( res1 )
      dst = dst;
      else if( res2 )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function withoutRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      dst = _.arrayIs( dst ) ? dst : _.array.make( dst );
      for( let k = dst.length - 1; k >= 0; k-- )
      {
        let res1 = dst[ k ];
        let res2 = src[ k ];

        if( res1 )
        dst[ k ] = dst[ k ];
        else if( res2 )
        dst[ k ] = src[ k ];
        else
        dst.splice( k, 1 );
      }

    }
    else if( _.aux.is( dst ) )
    {

      for( let k in dst )
      {
        let res1 = dst[ k ];
        let res2 = src[ k ];

        if( res1 )
        dst[ k ] = dst[ k ];
        else if( res2 )
        dst[ k ] = src[ k ];
        else
        delete dst[ k ];
      }

    }
    else
    {
      let res1 = dst;
      let res2 = src;

      if( res1 )
      dst = dst;
      else if( res2 )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function typeStr( e )
  {
    let type;
    if( _.longIs( e ) )
    type = 'long';
    else if( _.aux.is( e ) )
    type = 'map';
    else if( _.set.is( e ) )
    type = 'set';
    else if( _.hashMap.is( e ) )
    type = 'hashMap';
    else
    type = 'primitive';

    return type;
  }

}

//

/**
 * The routine entityXor() provides the filtering of elements of destination container
 * {-dst-} by checking values with the same keys in the {-dst-} and source {-src-} containers.
 * If both received values from {-dst-} and {-src-} has the same boolean value, then routine
 * deletes {-dst-} element.
 * Else routine sets in {-dst-} element, which received boolean value is true.
 *
 * If {-dst-} container is null, routine makes new container with type of {-src-} container, and fill it obtained values.
 * If {-src-} is undefined, routine filters {-dst-} container obtaining values from {-dst-}.
 * Note: containers should have same type.
 *
 * Also, {-dst-} and {-src-} might be not iteratable element, for example, primitive.
 * If {-dst-} is not iteratable, then routine check value of {-src-}.
 *
 * @param { ArrayLike|Set|Map|Object|* } dst - Container or another single element for filtering.
 * If {-dst-} is null, then makes new container of {-src-} type.
 * @param { ArrayLike|Set|Map|Object|* } src - Container or another single element for filtering.
 * If {-src-} is undefined, then {-dst-} filters by its own values.
 * @param { Function } onEach - The callback that obtain value for every {-dst-} and {-src-} element
 * with the same keys. The callback accepts three parameters - element, key, source container.
 *
 * @example
 * _.entityXor( 'str', undefined );
 * // returns 'str'
 *
 * @example
 * _.entityXor( 'str', 1, ( e, k, src ) => e - 1 );
 * // returns false
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityXor( null, src );
 * // returns [ 1, 0, null, undefined, true ]
 *
 * @example
 * let src = [ 1, 0, null, undefined, true ];
 * _.entityXor( null, src, ( e, k ) => k );
 * // returns [ 0, null, undefined, true ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityXor( dst );
 * // returns []
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * _.entityXor( dst, undefined, ( e, k ) => k );
 * // returns []
 *
 * @example
 * let dst = [ '', 0, null, 1, true ];
 * let src = [ 1, 2, false, 1, 'str' ];
 * _.entityXor( dst, src );
 * // returns [ 1, 2 ]
 *
 * @example
 * let dst = [ '', 0, null, undefined, true ];
 * let src = [ 1, 2, false, undefined, 0 ];
 * _.entityXor( dst, undefined, ( e, k ) => k );
 * // returns []
 *
 * @returns { ArrayLike|Set|Map|Object|* } - Returns filtered container.
 * If {-dst-} is not iteratable value, routine returns original {-dst-} or undefined.
 * @function entityXor
 * @throws { Error } If arguments.length is less then one or more than three arguments.
 * @throws { Error } If {-dst-} is not null or {-dst-} and {-src-} containers has different types.
 * @throws { Error } If {-onEach-} is not undefined, not a routine, not selector.
 * @throws { Error } If onEach.length is more then three.
 * @throws { Error } If {-onEach-} is selector and it does not begin with '*\/'.
 * @namespace Tools
 */

function entityXor( dst, src, onEach )
{

  if( arguments.length > 2 )
  onEach = arguments[ arguments.length-1 ];

  if( src === undefined )
  src = dst;

  if( _.strIs( onEach ) )
  {
    let selector = onEach;
    _.assert( _.routine.is( _.select ) );
    _.assert( _.strBegins( selector, '*/' ), () => `Selector should begins with "*/", but "${selector}" does not` );
    selector = _.strRemoveBegin( selector, '*/' );
    onEach = function( e, k )
    {
      return _.select( e, selector );
    }
  }

  let dstTypeStr = typeStr( dst );
  let srcTypeStr = typeStr( src );

  _.assert( dst === null || dstTypeStr === srcTypeStr );
  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( onEach === undefined || ( _.routine.is( onEach ) && onEach.length <= 3 ), 'Expects optional routine or selector {- onEach -}' );

  /* */

  if( dst !== null )
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutineDeleting();
      else
      withRoutineDeleting();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutineDeleting();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutineDeleting();
      else
      withoutRoutineDeleting();
    }

  }
  else
  {

    if( _.routine.is( onEach ) )
    {
      if( srcTypeStr === 'set' )
      setWithRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithRoutine();
      else
      withRoutine();
    }
    else
    {
      if( srcTypeStr === 'set' )
      setWithoutRoutine();
      else if( srcTypeStr === 'hashMap' )
      hashMapWithoutRoutine();
      else
      withoutRoutine(); /* don't change the subroutine */
    }

  }

  return dst;

  /* */

  function setWithRoutine()
  {
    dst = new Set( null );

    for( let value of src )
    {
      let res1 = onEach( undefined, undefined, dst );
      let res2 = onEach( value, undefined, src );

      if( ( res1 && !res2 ) || ( !res1 && res2 ) )
      dst.add( value );
    }
  }

  /* */

  function setWithoutRoutine()
  {
    dst = new Set( src );

    let unnecessaries = [ null, 0, undefined, false, '' ];
    for( let e of unnecessaries )
    dst.delete( e );
  }

  /* */

  function hashMapWithRoutine()
  {
    dst = new HashMap( null );

    for( let [ key, value ] of src )
    {
      let res1 = onEach( undefined, undefined, dst );
      let res2 = onEach( value, key, src );

      if( ( res1 && !res2 ) || ( !res1 && res2 ) )
      dst.set( key, value );
    }
  }

  /* */

  function hashMapWithoutRoutine()
  {
    dst = new HashMap( src );

    let unnecessaries = [ null, 0, undefined, false, '' ];
    for( let k of unnecessaries )
    {
      if( !dst.get( k ) )
      dst.delete( k );
    }
  }

  /* */

  function withRoutine()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {

      dst = [];
      for( let k = 0; k < src.length; k++ )
      {
        let res1 = onEach( undefined, undefined, dst );
        let res2 = onEach( src[ k ], k, src );

        if( ( res1 && !res2 ) || ( !res1 && res2 ) )
        dst.push( src[ k ] );
      }

    }
    else if( _.aux.is( src ) )
    {

      dst = Object.create( null );
      for( let k in src )
      {
        let res1 = onEach( undefined, undefined, dst );
        let res2 = onEach( src[ k ], k, src );

        if( ( res1 && !res2 ) || ( !res1 && res2 ) )
        dst[ k ] = src[ k ];
      }

    }
    else
    {
      let res1 = onEach( null );
      let res2 = onEach( src, undefined, undefined );
      if( ( res1 && !res2 ) || ( !res1 && res2 ) )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function withoutRoutine()
  {

    if( _.longIs( src ) )
    {
      dst = [];
      for( let e of src )
      if( e )
      dst.push( e );
    }
    else if( _.aux.is( src ) )
    {
      dst = Object.assign( Object.create( null ), src );
      let  unnecessaries = [ null, 0, undefined, false, '' ];
      for( let k of unnecessaries )
      {
        if( !dst[ k ] )
        delete dst[ k ];
      }
    }
    else
    {
      if( src !== undefined )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function setWithRoutineDeleting()
  {
    for( let key of dst )
    {
      let res = onEach( key, undefined, dst );
      if( !res )
      dst.delete( key );
    }

    for( let key of src )
    {
      let res1, res2;
      if( dst.has( key ) )
      res1 = onEach( key, key, dst );
      else
      res1 = onEach( undefined, undefined, dst );
      res2 = onEach( key, key, src );

      if( res1 && !res2 )
      {}
      else if( !res1 && res2 )
      dst.add( key );
      else
      dst.delete( key );
    }
  }

  /* */

  function setWithoutRoutineDeleting()
  {
    for( let key of dst )
    if( !key )
    dst.delete( key );
    for( let key of src )
    {
      if( dst.has( key ) )
      dst.delete( key );
      else if( key )
      dst.add( key );
    }
  }

  /* */

  function hashMapWithRoutineDeleting()
  {
    for( let [ key, value ] of dst )
    {
      let res = onEach( value, key, dst )
      if( !res )
      dst.delete( key );
    }
    for( let [ key, value ] of src )
    {
      let res1, res2
      if( dst.has( key ) )
      res1 = onEach( dst.get( key ), key, dst );
      else
      res1 = onEach( undefined, undefined, dst );
      res2 = onEach( value, key, src )

      if( res1 && !res2 )
      {}
      else if( !res1 && res2 )
      dst.set( key, value );
      else
      dst.delete( key );
    }
  }

  /* */

  function hashMapWithoutRoutineDeleting()
  {
    for( let [ key, value ] of dst )
    if( !value )
    dst.delete( key );
    for( let [ key, value ] of src )
    {
      let res1 = dst.get( key );
      let res2 = value;

      if( res1 && !res2 )
      {}
      else if( !res1 && res2 )
      dst.set( key, value );
      else
      dst.delete( key );
    }
  }

  /* */

  function withRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      dst = _.arrayIs( dst ) ? dst : _.array.make( dst );
      for( let k = src.length - 1; k >= 0; k-- )
      {
        let res1 = onEach( dst[ k ], k, dst );
        let res2 = onEach( src[ k ], k, src );

        if( res1 && !res2 )
        {}
        else if( !res1 && res2 )
        dst[ k ] = src[ k ];
        else
        dst.splice( k, 1 );
      }

    }
    else if( _.aux.is( dst ) )
    {

      for( let k in src )
      {
        let res1 = onEach( dst[ k ], k, dst );
        let res2 = onEach( src[ k ], k, src );

        if( res1 && !res2 )
        {}
        else if( !res1 && res2 )
        dst[ k ] = src[ k ];
        else
        delete dst[ k ];
      }

    }
    else
    {
      let res1 = onEach( dst, undefined, undefined );
      let res2 = onEach( src, undefined, undefined );

      if( res1 && !res2 )
      {}
      else if( !res1 && res2 )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function withoutRoutineDeleting()
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( dst ) )
    {

      dst = _.arrayIs( dst ) ? dst : _.array.make( dst );
      for( let k = src.length - 1; k >= 0; k-- )
      {
        let res1 = dst[ k ];
        let res2 = src[ k ];

        if( res1 && !res2 )
        {}
        else if( !res1 && res2 )
        dst[ k ] = src[ k ];
        else
        dst.splice( k, 1 );
      }

    }
    else if( _.aux.is( dst ) )
    {

      for( let k in src )
      {
        let res1 = dst[ k ];
        let res2 = src[ k ];

        if( res1 && !res2 )
        {}
        else if( !res1 && res2 )
        dst[ k ] = src[ k ];
        else
        delete dst[ k ];
      }

    }
    else
    {
      let res1 = dst;
      let res2 = src;

      if( res1 && !res2 )
      {}
      else if( !res1 && res2 )
      dst = src;
      else
      dst = undefined;
    }

  }

  /* */

  function typeStr( e )
  {
    let type;
    if( _.longIs( e ) )
    type = 'long';
    else if( _.aux.is( e ) )
    type = 'map';
    else if( _.set.is( e ) )
    type = 'set';
    else if( _.hashMap.is( e ) )
    type = 'hashMap';
    else
    type = 'primitive';

    return type;
  }

}

//

function entityAll( src, onEach )
{
  let result = true;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( onEach === undefined || ( _.routine.is( onEach ) && onEach.length <= 3 ) );

  /* */

  if( _.routine.is( onEach ) )
  {

    /* qqq for junior : add branch for countable case */
    if( _.set.like( src ) )
    {

      for( let e of src )
      {
        result = onEach( e, undefined, src );
        if( !result )
        return result;
      }

    }
    else if( _.hashMap.is( src ) )
    {

      for( let [ key, value ] of src )
      {
        result = onEach( value, key, src );
        if( !result )
        return result;
      }

    }
    else if( _.longIs( src ) )
    {

      /* qqq for junior : add branch for countable case */
      for( let k = 0 ; k < src.length ; k++ )
      {
        result = onEach( src[ k ], k, src );
        if( !result )
        return result;
      }

    }
    else if( _.aux.is( src ) )
    {

      for( let k in src )
      {
        result = onEach( src[ k ], k, src );
        if( !result )
        return result;
      }

    }
    else
    {
      result = onEach( src, undefined, undefined );
      if( !result )
      return result;
    }

  }
  else
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) || _.set.like( src ) )
    {

      for( let e of src )
      {
        result = e;
        if( !result )
        return result;
      }

    }
    else if( _.hashMap.is( src ) )
    {

      for( let [ key, value ] of src )
      {
        result = value;
        if( !result )
        return result;
      }

    }
    else if( _.aux.is( src ) )
    {

      for( let k in src )
      {
        result = src[ k ];
        if( !result )
        return result;
      }

    }
    else
    {
      result = src;
      if( !result )
      return result;
    }

  }

  /* */

  return true;
}

//

function entityAny( src, onEach )
{
  let result = undefined;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( onEach === undefined || ( _.routine.is( onEach ) && onEach.length <= 3 ) );

  /* */

  if( _.routine.is( onEach ) )
  {

    /* qqq for junior : add branch for countable case */
    if( _.set.like( src ) )
    {

      for( let e of src )
      {
        result = onEach( e, undefined, src );
        if( result )
        return result;

      }

    }
    else if( _.hashMap.is( src ) )
    {

      for( let [ key, value ] of src )
      {
        result = onEach( value, key, src );
        if( result )
        return result;

      }

    }
    else if( _.longIs( src ) )
    {

      /* qqq for junior : add branch for countable case */
      for( let k = 0 ; k < src.length ; k++ )
      {
        result = onEach( src[ k ], k, undefined );
        if( result )
        return result;
      }

    }
    else if( _.aux.is( src ) )
    {

      for( let k in src )
      {
        result = onEach( src[ k ], k, undefined );
        if( result )
        return result;
      }

    }
    else
    {
      result = onEach( src, undefined, undefined );
      if( result )
      return result;
    }

  }
  else
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) || _.set.like( src ) )
    {

      for( let e of src )
      {
        result = e;
        if( result )
        return result;
      }

    }
    else if( _.hashMap.is( src ) )
    {

      for( let [ key, value ] of src )
      {
        result = value;
        if( result )
        return result;
      }

    }
    else if( _.aux.is( src ) )
    {

      for( let k in src )
      {
        result = src[ k ];
        if( result )
        return result;
      }

    }
    else
    {
      result = src;
      if( result )
      return result;
    }

  }

  /* */

  /* qqq : for Dmytro : should return undefined in such cases */
  // return false;
  return undefined;
}

//

function entityNone( src, onEach )
{
  let result = true;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( onEach === undefined || ( _.routine.is( onEach ) && onEach.length <= 3 ) );

  /* */

  if( _.routine.is( onEach ) )
  {

    /* qqq for junior : add branch for countable case */
    if( _.set.like( src ) )
    {

      for( let e of src )
      {
        result = onEach( e, undefined, src );
        if( result )
        return !result;
      }

    }
    else if( _.hashMap.is( src ) )
    {

      for( let [ key, value ] of src )
      {
        result = onEach( value, key, src );
        if( result )
        return !result;
      }

    }
    else if( _.longIs( src ) )
    {

      /* qqq for junior : add branch for countable case */
      for( let k = 0 ; k < src.length ; k++ )
      {
        result = onEach( src[ k ], k, src );
        if( result )
        return !result;
      }

    }
    else if( _.aux.is( src ) )
    {

      for( let k in src )
      {
        result = onEach( src[ k ], k, src );
        if( result )
        return !result;
      }

    }
    else
    {
      result = onEach( src, undefined, undefined );
      if( result )
      return !result;
    }

  }
  else
  {

    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) || _.set.like( src ) )
    {

      for( let e of src )
      {
        result = e;
        if( result )
        return !result;
      }

    }
    else if( _.hashMap.is( src ) )
    {

      for( let [ key, value ] of src )
      {
        result = value;
        if( result )
        return !result;
      }

    }
    else if( _.aux.is( src ) )
    {

      for( let k in src )
      {
        result = src[ k ];
        if( result )
        return !result;
      }

    }
    else
    {
      result = src;
      if( result )
      return !result;
    }

  }

  /* */

  return true;
}

//

/**
 * Returns generated function that takes single argument( e ) and can be called to check if object( e )
 * has at least one key/value pair that is represented in( condition ).
 * If( condition ) is provided as routine, routine uses it to check condition.
 * Generated function returns origin( e ) if conditions is true, else undefined.
 *
 * @param {object|function} condition - Map to compare with( e ) or custom function.
 * @returns {function} Returns condition check function.
 *
 * @example
 * let check = _._filter_functor( { a : 1, b : 1, c : 1 } );
 * check( { a : 1 } );
 * // returns Object {a: 1}
 *
 * @example
 * function condition( src ){ return src.y === 1 }
 * let check = _._filter_functor( condition );
 * check( { a : 2 } );
 * // returns false
 *
 * @function _filter_functor
 * @throws {exception} If no argument provided.
 * @throws {exception} If( condition ) is not a Routine or Object.
 * @namespace Tools
 */

function _filter_functor( condition, levels )
{
  let result;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.routine.is( condition ) || _.object.isBasic( condition ) );

  if( _.object.isBasic( condition ) )
  {
    let template = condition;
    condition = function condition( e, k, src )
    {
      _.assert( arguments.length === 3 );
      if( e === template )
      return e;
      if( !_.object.like( e ) )
      return;
      let satisfied = _.objectSatisfy
      ({
        template,
        src : e,
        levels
      });
      if( satisfied )
      return e;
    };
  }

  return condition;
}

//

/**
 * Function that produces an elements for entityMap result
 * @callback wTools.onEach
 * @param {*} val - The current element being processed in the entity.
 * @param {string|number} key - The index (if entity is array) or key of processed element.
 * @param {Array|Object} src - The src passed to entityMap.
 */

/**
 * Creates new instance with same as( src ) type. Elements of new instance results of calling a provided ( onEach )
 * function on every element of src. If entity is array, the new array has the same length as source.
 *
 * @example
 * let numbers = [ 3, 4, 6 ];
 * function sqrt( v )
 * {
 *   return v * v;
 * };
 *
 * _.container.map_( null, numbers, sqrt );
 * // returns [ 9, 16, 36 ]
 * // numbers is still [ 3, 4, 6 ]
 *
 * @example
 * function checkSidesOfTriangle( v, i, src )
 * {
 *   let sumOthers = 0,
 *     l = src.length,
 *     j;
 *
 *   for( j = 0; j < l; j++ )
 *   {
 *     if( i === j ) continue;
 *     sumOthers += src[ j ];
 *   }
 *   return v < sumOthers;
 * }
 *
 * _.container.map_( null, numbers, checkSidesOfTriangle );
 * // returns [ true, true, true ]
 *
 * @param {ArrayLike|ObjectLike} src - Entity, on each elements of which will be called ( onEach ) function.
 * @param {wTools.onEach} onEach - Function that produces an element of the new entity.
 * @returns {ArrayLike|ObjectLike} New entity.
 * @thorws {Error} If number of arguments less or more than 2.
 * @thorws {Error} If( src ) is not Array or ObjectLike.
 * @thorws {Error} If( onEach ) is not function.
 * @function entityMap
 * @namespace Tools
 */

//

function map_( dst, src, onEach )
{
  if( arguments.length === 2 )
  {
    _.assert( arguments.length === 2, 'Expects three arguments' );
    onEach = src;
    src = dst;
  }
  else
  {
    _.assert( arguments.length === 3, 'Expects three arguments' );
  }
  _.assert( _.routine.is( onEach ) );

  /* */

  let result;

  if( dst === src )
  {

    result = src;
    /* qqq for junior : add branch for countable case */
    if( _.longIs( src ) )
    {
      for( let s = 0 ; s < src.length ; s++ )
      {
        let r = onEach( src[ s ], s, src );
        if( r !== undefined )
        result[ s ] = r;
      }
    }
    else if( _.aux.is( src ) )
    {
      for( let s in src )
      {
        let r = onEach( src[ s ], s, src );
        if( r !== undefined )
        result[ s ] = r;
      }
    }
    else
    {
      result = src;
      let r = onEach( src, undefined, undefined );
      if( r !== undefined )
      result = r;
    }

  }
  else
  {

    result = dst;
    if( _.longIs( src ) )
    {
      if( dst === null )
      result = _.entity.makeUndefined( src, src.length );
      else
      _.assert( _.longIs( dst ), '{-dst-} container should be long like' );

      /* qqq for junior : add branch for countable case */
      for( let s = 0 ; s < src.length ; s++ )
      {
        let r = onEach( src[ s ], s, src );
        if( r !== undefined )
        result[ s ] = r;
      }
    }
    else if( _.aux.is( src ) )
    {
      if( dst === null )
      result = _.entity.makeUndefined( src );
      else
      _.assert( _.aux.is( dst ), '{-dst-} container should be map like' );

      for( let s in src )
      {
        let r = onEach( src[ s ], s, src );
        if( r !== undefined )
        result[ s ] = r;
      }
    }
    else
    {
      let r = onEach( src, undefined, undefined );
      if( r === undefined )
      return dst;

      if( _.longIs( dst ) )
      result = _.arrayAppendElement( dst, r );
      else if( _.aux.is( dst ) )
      result = _.props.extend( dst, r );
      else if( _.primitive.is( dst ) )
      result = r;
      else
      _.assert( 0, 'Not clear how to add result in destination container {-dst-}' );
    }

  }

  return result;
}

//

function filter_( dst, src, onEach )
{

  if( arguments.length === 2 )
  {
    _.assert( arguments.length === 3, 'Expects three arguments' );
    onEach = src;
    src = dst;
  }
  else
  {
    _.assert( arguments.length === 3, 'Expects two or three arguments' );
  }
  onEach = _._filter_functor( onEach, 1 );

  _.assert( _.routine.is( onEach ) );

  /* */

  let result;

  if( dst === src )
  {

    result = src;
    if( _.longIs( src ) )
    {
      /* qqq for junior : add branch for countable case */
      /* qqq : should be direct! check other cycles */
      for( let s = src.length - 1 ; s >= 0 ; s-- )
      {
        let r = onEach.call( src, src[ s ], s, src );
        if( _.unrollIs( r ) )
        _.longBut_( result, s, r );
        else if( r !== undefined )
        result[ s ] = r;
        else
        result.splice( s, 1 );
      }
    }
    else if( _.aux.is( src ) )
    {
      for( let s in src )
      {
        let r = onEach.call( src, src[ s ], s, src );
        if( r === undefined )
        delete src[ s ];
        else
        src[ s ] = r;
      }
    }
    else
    {
      result = onEach.call( null, src, null, null );
    }

  }
  else
  {

    result = dst;
    if( _.longIs( src ) )
    {
      if( dst === null )
      {
        if( _.argumentsArray.is( src ) )
        result = [];
        else
        result = _.long.make( src, 0 );
      }
      else
      {
        _.assert( _.longIs( dst ), '{-dst-} container should be long like' );
      }

      let s, d;
      /* qqq for junior : add branch for countable case */
      for( s = 0, d = 0 ; s < src.length ; s++ )
      {
        let r = onEach.call( src, src[ s ], s, src );
        if( _.unrollIs( r ) )
        {
          _.longBut_( result, d, r );
          d += r.length;
        }
        else if( r !== undefined )
        {
          result[ d ] = r;
          d += 1;
        }
      }
    }
    else if( _.aux.is( src ) )
    {
      if( dst === null )
      result = _.entity.makeUndefined( src );
      else
      _.assert( _.aux.is( dst ), '{-dst-} container should be map like' );

      for( let s in src )
      {
        let r = onEach.call( src, src[ s ], s, src );
        if( r !== undefined )
        result[ s ] = r;
      }
    }
    else
    {
      let r = onEach.call( null, src, null, null );

      if( r !== undefined )
      {
        if( _.longIs( dst ) )
        result = _.arrayAppendElement( dst, r );
        else if( _.aux.is( dst ) )
        result = _.props.extend( dst, r );
        else if( _.primitive.is( dst ) )
        result = r;
        else
        _.assert( 0, 'Not clear how to add result in destination container {-dst-}' );
      }
    }

  }

  return result;
}

//

function entityFirst( src, onEach )
{
  let result;

  onEach = _._filter_functor( onEach, 1 );

  _.assert( arguments.length === 2 );
  _.assert( _.routine.is( onEach ) );

  /* */

  if( _.longIs( src ) )
  {

    /* qqq for junior : add branch for countable case */
    for( let s = 0 ; s < src.length ; s++ )
    {
      let r = onEach.call( src, src[ s ], s, src );
      if( r !== undefined )
      return r;
    }

  }
  else if( _.aux.is( src ) )
  {

    for( let s in src )
    {
      let r = onEach.call( src, src[ s ], s, src );
      if( r !== undefined )
      return r;
    }

  }
  else
  {

    result = onEach.call( null, src, null, null );

  }

  /* */

  return result;
}

//

function entityLast( src, onEach )
{
  let result;

  onEach = _._filter_functor( onEach, 1 );

  _.assert( arguments.length === 2 );
  _.assert( _.routine.is( onEach ) );
  // _.assert( src !== undefined, 'Expects src' );

  /* */

  if( _.longIs( src ) )
  {

    /* qqq for junior : add branch for countable case */
    for( let s = src.length - 1 ; s >= 0 ; s-- )
    {
      let r = onEach.call( src, src[ s ], s, src );
      if( r !== undefined )
      return r;
    }

  }
  else if( _.aux.is( src ) )
  {

    for( let s in src )
    {
      let r = onEach.call( src, src[ s ], s, src );
      if( r !== undefined )
      result = r;
    }

  }
  else
  {

    result = onEach.call( null, src, null, null );

  }

  /* */

  return result;
}

//

/**
 * The result of _most routine object.
 * @typedef {Object} wTools.entityMostResult
 * @property {Number} index - Index of found element.
 * @property {String|Number} key - If the search was on map, the value of this property sets to key of found element.
 * Else if search was on array - to index of found element.
 * @property {Number} value - The found result of onEvaluate, if onEvaluate don't set, this value will be same as element.
 * @property {Number} element - The appropriate element for found value.
 */

/**
 * Returns object( wTools.entityMostResult ) that contains min or max element of entity, it depends on( returnMax ).
 *
 * @param {ArrayLike|Object} src - Source entity.
 * @param {Function} onEvaluate  - ( onEach ) function is called for each element of( src ).If undefined routine uses it own function.
 * @param {Boolean} returnMax  - If true - routine returns maximum, else routine returns minimum value from entity.
 * @returns {wTools.entityMostResult} Object with result of search.
 *
 * @example
 * _._most([ 1, 3, 3, 9, 10 ], undefined, 0 );
 * // returns { index: 0, key: 0, value: 1, element: 1 }
 *
 * @example
 * _._most( [ 1, 3, 3, 9, 10 ], undefined, 1 );
 * // returns { index: 4, key: 4, value: 10, element: 10 }
 *
 * @example
 * _._most( { a : 1, b : 2, c : 3 }, undefined, 0 );
 * // returns { index: 4, key: 4, value: 10, element: 10 }
 *
 * @private
 * @function _most
 * @throws {Exception} If( arguments.length ) is not equal 3.
 * @throws {Exception} If( onEvaluate ) function is not implemented.
 * @namespace Tools
 */

//

function _most( o )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( _.mapIs( o ), 'Expect map, but got ' + _.entity.strType( o ) );
  _.routine.options( _most, o );

  if( !o.onEach )
  o.onEach = _most.defaults.onEach;

  if( !o.onEvaluate )
  {
    _.assert( o.returnMax !== null, 'o.returnMax should has value' );
    if( o.returnMax )
    o.onEvaluate = ( a, b ) => a - b > 0;
    else
    o.onEvaluate = ( a, b ) => b - a > 0;
  }

  _.assert( 1 <= o.onEach.length && o.onEach.length <= 3 );
  _.assert( o.onEvaluate.length === 1 || o.onEvaluate.length === 2 );

  let result = { index : -1, key : undefined, value : undefined, element : undefined };

  /* qqq for junior : add branch for countable case */
  if( _.longIs( o.src ) )
  {
    if( o.src.length === 0 )
    return result;

    let s = 0;
    if( o.onEvaluate.length === 1 )
    for( ; s < o.src.length; s++ )
    {
      let value = o.onEach( o.src[ s ], s, o.src );
      if( o.onEvaluate( value ) )
      {
        result.value = value;
        result.key = s;
        break;
      }
    }
    else
    {
      result.key = s;
      result.value = o.onEach( o.src[ s ], s, o.src );
    }

    /* qqq for junior : add branch for countable case */
    for( ; s < o.src.length; s++ )
    resultValue( o.src[ s ], s, o.src );
    result.index = result.key;
    result.element = o.src[ result.key ];
  }
  else if( _.aux.is( o.src ) )
  {
    let index = 0;
    if( o.onEvaluate.length === 1 )
    {
      for( let s in o.src )
      {
        if( result.value === undefined )
        {
          let value = o.onEach( o.src[ s ], s, o.src );
          if( o.onEvaluate( value ) )
          {
            result.value = value;
            result.index = index;
            result.key = s;
          }
        }
        else
        {
          if( resultValue( o.src[ s ], s, o.src ) )
          result.index = index;
        }

        index++;

      }
      result.element = o.src[ result.key ];
    }
    else
    {
      for( let s in o.src )
      {
        result.index = 0;
        result.key = s;
        result.value = o.onEach( o.src[ s ], s, o.src );
        break;
      }

      for( let s in o.src )
      {
        if( resultValue( o.src[ s ], s, o.src ) )
        result.index = index;

        index++;
      }
      result.element = o.src[ result.key ];
    }

  }
  else
  _.assert( 0 );

  return result;

  /* */

  function resultValue( e, k, s )
  {
    let value = o.onEach( e, k, s );
    if( o.onEvaluate.length === 1 )
    {
      if( o.onEvaluate( value ) === o.onEvaluate( result.value ) )
      {
        result.key = k;
        result.value = value;
        return true;
      }
    }
    else if( o.onEvaluate( value, result.value ) )
    {
      result.key = k;
      result.value = value;
      return true;
    }

    return false;
  }

}

_most.defaults =
{
  src : null,
  onEach : ( e ) => e,
  onEvaluate : null,
  returnMax : null
}

//

/**
 * Short-cut for _most() routine. Returns object( wTools.entityMostResult ) with smallest value from( src ).
 *
 * @param {ArrayLike|Object} src - Source entity.
 * @param {Function} onEvaluate  - ( onEach ) function is called for each element of( src ).If undefined routine uses it own function.
 * @returns {wTools.entityMostResult} Object with result of search.
 *
 * @example
 *  let obj = { a : 25, b : 16, c : 9 };
 *  _.entityMin( obj, Math.sqrt );
 *  // returns { index : 2, key : 'c', value 3: , element : 9  };
 *
 * @see wTools.onEach
 * @see wTools.entityMostResult
 * @function entityMin
 * @throws {Exception} If missed arguments.
 * @throws {Exception} If passed extra arguments.
 * @namespace Tools
 */

function entityMin( src, onEach )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  return _most
  ({
    src,
    onEach : onEach || null,
    returnMax : 0
  });
}

//

/**
 * Short-cut for _most() routine. Returns object( wTools.entityMostResult ) with biggest value from( src ).
 *
 * @param {ArrayLike|Object} src - Source entity.
 * @param {Function} onEvaluate  - ( onEach ) function is called for each element of( src ).If undefined routine uses it own function.
 * @returns {wTools.entityMostResult} Object with result of search.
 *
 * @example
 *  let obj = { a: 25, b: 16, c: 9 };
 *  _.entityMax( obj );
 *  // returns { index: 0, key: "a", value: 25, element: 25 };
 *
 * @see wTools.onEach
 * @see wTools.entityMostResult
 * @function entityMax
 * @throws {Exception} If missed arguments.
 * @throws {Exception} If passed extra arguments.
 * @namespace Tools
 */

function entityMax( src, onEach )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  return _most
  ({
    src,
    onEach : onEach || null,
    returnMax : 1
  });
}

// --
// extension
// --

let ContainerExtension =
{

  // scalar

  scalarAppend,
  scalarPrepend,
  scalarAppendOnce,
  scalarPrependOnce,

  scalarToVector,
  scalarFrom,
  scalarFromOrNull,

  // multiplier

  dup,
  multiple,
  multipleAll,

  // entity iterator

  each : entityEach,
  eachOwn : entityEachOwn,

  /* qqq : for Dmytro : implementations with dst-null convention? */
  only : entityOnly,
  but : entityBut,
  and : entityAnd,
  or : entityOr,
  xor : entityXor,

  all : entityAll,
  any : entityAny,
  none : entityNone,

  _filter_functor,

  map_,
  filter_,
  first : entityFirst,
  last : entityLast,

  //

  _most,
  min : entityMin,
  max : entityMax,

}

_.props.supplement( _.container, ContainerExtension );

//

let ToolsExtension =
{

  // scalar

  scalarAppend,
  scalarPrepend,
  scalarAppendOnce,
  scalarPrependOnce,

  scalarToVector,
  scalarFrom,
  scalarFromOrNull,

  // multiplier

  dup,
  multiple,
  multipleAll,

  // entity iterator

  entityEach,
  each : entityEach,
  entityEachOwn,
  eachOwn : entityEachOwn,

  // entityEachKey,
  // eachKey : entityEachKey,

  entityOnly,
  only : entityOnly,
  entityBut,
  but : entityBut,
  entityAnd,
  and : entityAnd,
  entityOr,
  or : entityOr,
  entityXor,
  xor : entityXor,

  entityAll,
  all : entityAll,
  entityAny,
  any : entityAny,
  entityNone,
  none : entityNone,

  _filter_functor,

  // entityMap,
  // map : entityMap,/* !!! : use instead of entityMap */
  // container.map_,
  // map_,
  // entityFilter,
  // filter : entityFilter, /* !!! : use instead of entityFilter */
  // container.filter_,
  filter_,
  // entityFirst,
  // first : entityFirst,
  // entityLast,
  // last : entityLast,

  //

  _most,
  _entityMost : _most,
  entityMin,
  min : entityMin,
  entityMax,
  max : entityMax,

}

_.props.supplement( _, ToolsExtension );

})();

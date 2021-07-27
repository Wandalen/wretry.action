( function _l7_Buffer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// buffer
// --

function _argumentsOnlyBuffer( /* dst, src, range, ins */ )
{
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];
  let cinterval = arguments[ 2 ];
  let ins = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );

  if( dst === null )
  dst = true;
  else if( dst === src )
  dst = false;
  else if( arguments.length === 4 )
  _.assert( _.longIs( dst ) || _.bufferAnyIs( dst ), '{-dst-} should be Long or buffer' );
  else
  {
    if( arguments.length > 1 && !_.intervalIs( src ) && !_.number.is( src ) )
    _.assert( _.longIs( dst ) || _.bufferAnyIs( dst ) );
    else
    {
      ins = range;
      range = src;
      src = dst;
      dst = false;
    }
  }

  _.assert( _.longIs( src ) || _.bufferAnyIs( src ) );

  return [ dst, src, range, ins ];
}

function _returnDst( dst, src )
{
  let dstLength;
  if( !_.bool.is( dst ) )
  dstLength = dst.length === undefined ? dst.byteLength : dst.length;

  if( dstLength !== undefined )
  {
    let srcLength = src.length === undefined ? src.byteLength : src.length;

    if( _.arrayLikeResizable( dst ) )
    dst.length = srcLength;
    else if( _.argumentsArray.is( dst ) )
    dst = new Array( srcLength );
    else if( dstLength !== srcLength )
    dst = _.bufferViewIs( dst ) ? new BufferView( new BufferRaw( srcLength ) ) : new dst.constructor( srcLength );

    let dstTyped = dst;
    if( _.bufferRawIs( dstTyped ) )
    dstTyped = new U8x( dstTyped );
    else if( _.bufferViewIs( dstTyped ) )
    dstTyped = new U8x( dstTyped.buffer );

    if( _.bufferRawIs( src ) )
    src = new U8x( src );
    else if( _.bufferViewIs( src ) )
    src = new U8x( src.buffer );

    for( let i = 0; i < srcLength; i++ )
    dstTyped[ i ] = src[ i ];

    return dst;
  }
  return dst === true ? _.bufferMake( src ) : src;
}

//

/**
 * The bufferRelen() routine returns a new or the same typed array {-srcMap-} with a new or the same length (len).
 *
 * It creates the variable (result) checks, if (len) is more than (src.length),
 * if true, it creates and assigns to (result) a new typed array with the new length (len) by call the function(longMakeUndefined(src, len))
 * and copies each element from the {-srcMap-} into the (result) array while ensuring only valid data types, if data types are invalid they are replaced with zero.
 * Otherwise, if (len) is less than (src.length) it returns a new typed array from 0 to the (len) indexes, but not including (len).
 * Otherwise, it returns an initial typed array.
 *
 * @see {@link wTools.longMakeUndefined} - See for more information.
 *
 * @param { typedArray } src - The source typed array.
 * @param { Number } len - The length of a typed array.
 *
 * @example
 * let ints = new I8x( [ 3, 7, 13 ] );
 * _.bufferRelen( ints, 4 );
 * // returns [ 3, 7, 13, 0 ]
 *
 * @example
 * let ints2 = new I16x( [ 3, 7, 13, 33, 77 ] );
 * _.bufferRelen( ints2, 3 );
 * // returns [ 3, 7, 13 ]
 *
 * @example
 * let ints3 = new I32x( [ 3, 7, 13, 33, 77 ] );
 * _.bufferRelen( ints3, 6 );
 * // returns [ 3, 0, 13, 0, 77, 0 ]
 *
 * @returns { typedArray } - Returns a new or the same typed array {-srcMap-} with a new or the same length (len).
 * @function bufferRelen
 * @namespace Tools
 */

function bufferRelen( src, len )
{
  let result = src;

  _.assert( _.bufferTypedIs( src ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.number.is( len ) );

  if( len > src.length )
  {
    result = _.long.makeUndefined( src, len );
    result.set( src );
  }
  else if( len < src.length )
  {
    result = src.subarray( 0, len );
  }

  return result;
}

//

/**
 * Routine bufferBut_() copies elements from source buffer {-src-} to destination buffer {-dst-}.
 * Routine copies all elements excluding elements in range {-cinterval-}, its elements replaces by elements
 * from insertion buffer {-ins-}.
 *
 * If first and second provided arguments is containers, then fisrs argument is destination
 * container {-dst-} and second argument is source container {-src-}. All data in {-dst-} cleares. If {-dst-} container
 * is not resizable and resulted length of destination container is not equal to original {-dst-} length, then routine
 * makes new container of {-dst-} type.
 *
 * If first argument and second argument are the same container, routine tries to change container inplace.
 *
 * If {-dst-} is not provided then routine tries to change container inplace.
 *
 * @param { BufferAny|Long|Null } dst - The destination container.
 * @param { BufferAny|Long } src - The container from which makes a shallow copy.
 * @param { Range|Number } cinterval - The two-element array that defines the start index and the end index for removing elements.
 * If {-cinterval-} is a Number, then it defines the index of removed element.
 * If {-cinterval-} is undefined and {-dst-} is null, then routine returns copy of {-src-}, otherwise, routine returns original {-src-}.
 * If range[ 0 ] < 0, then start index sets to 0.
 * If range[ 1 ] > src.length, end index sets to ( src.length - 1 ).
 * If range[ 1 ] < range[ 0 ], then routine removes not elements, the insertion of elements begins at start index.
 * @param { BufferAny|Long } ins - The container with elements for insertion. Inserting begins at start index.
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferBut_( buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferBut_( null, buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferBut_( buffer, buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let dst = [ 0, 0 ]
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferBut_( dst, buffer );
 * console.log( got );
 * // log [ 1, 2, 3, 4 ]
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let ins = new I32x( [ 0, 0 ] );
 * let got = _.bufferBut_( buffer, [ 1, 2 ], ins );
 * console.log( got );
 * // log Uint8Array[ 1, 0, 0, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferBut_( null, buffer, 1, [ 0, 0 ] );
 * console.log( got );
 * // log Uint8Array[ 0, 0, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferBut_( buffer, buffer, [ 1, 2 ], [ 0, 0 ] );
 * console.log( got );
 * // log Uint8Array[ 1, 0, 0, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let dst = [ 0, 0 ]
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferBut_( dst, buffer, [ 1, 2 ], [ 0, 0 ] );
 * console.log( got );
 * // log [ 1, 0, 0, 4 ]
 * console.log( got === dst );
 * // log true
 *
 * @returns { BufferAny|Long } - If {-dst-} is provided, routine returns container of {-dst-} type.
 * Otherwise, routine returns container of {-src-} type.
 * If {-dst-} and {-src-} are the same container, routine tries to return original container.
 * @function bufferBut_
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-dst-} is not a buffer, not a Long, not null.
 * @throws { Error } If {-src-} is not an any buffer, not a Long.
 * @throws { Error } If {-cinterval-} is not a Range or not a Number.
 * @namespace Tools
 */

function bufferBut_( /* dst, src, cinterval, ins */ )
{
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];
  let cinterval = arguments[ 2 ];
  let ins = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );

  if( arguments.length < 4 && dst !== null && dst !== src )
  {
    dst = arguments[ 0 ];
    src = arguments[ 0 ];
    cinterval = arguments[ 1 ];
    ins = arguments[ 2 ];
  }

  let dstLength = 0;
  if( dst !== null )
  dstLength = dst.length === undefined ? dst.byteLength : dst.length;
  let srcLength = src.length === undefined ? src.byteLength : src.length;

  if( cinterval === undefined )
  {
    cinterval = [ 0, -1 ];
    ins = undefined;
  }
  else if( _.number.is( cinterval ) )
  {
    cinterval = [ cinterval, cinterval ];
  }

  _.assert( _.bufferAnyIs( dst ) || _.longIs( dst ) || dst === null, 'Expects {-dst-} of any buffer type, long or null' );
  _.assert( _.bufferAnyIs( src ) || _.longIs( src ), 'Expects {-src-} of any buffer type or long' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );
  _.assert( _.longIs( ins ) || _.bufferNodeIs( ins ) || ins === undefined || ins === null, 'Expects iterable buffer {-ins-}' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] === undefined ? 0 : cinterval[ 0 ];
  let last = cinterval[ 1 ] = cinterval[ 1 ] === undefined ? srcLength - 1 : cinterval[ 1 ];

  if( first < 0 )
  first = 0;
  if( first > srcLength )
  first = srcLength;
  if( last > srcLength - 1 )
  last = srcLength - 1;

  if( last + 1 < first )
  last = first - 1;

  let delta = last - first + 1;
  let insLength = 0
  if( ins )
  insLength = ins.length === undefined ? ins.byteLength : ins.length;
  let delta2 = delta - insLength;
  let resultLength = srcLength - delta2;

  let result = dst;
  if( dst === null )
  {
    result = _.bufferMakeUndefined( src, resultLength );
  }
  else if( dst === src )
  {
    if( ( dstLength === resultLength ) && delta === 0 )
    {
      return dst;
    }
    if( _.arrayLikeResizable( dst ) )
    {
      ins ? dst.splice( first, delta, ... ins ) : dst.splice( first, delta );
      return dst;
    }
    else if( dstLength !== resultLength || _.argumentsArray.is( dst ) )
    {
      result = _.bufferMakeUndefined( dst, resultLength );
    }
  }
  else if( dstLength !== resultLength )
  {
    dst = _.bufferMakeUndefined( dst, resultLength );
  }

  let resultTyped = result;
  if( _.bufferRawIs( result ) )
  resultTyped = new U8x( result );
  else if( _.bufferViewIs( result ) )
  resultTyped = new U8x( result.buffer );
  let srcTyped = src;
  if( _.bufferRawIs( src ) )
  srcTyped = new U8x( src );
  else if( _.bufferViewIs( src ) )
  srcTyped = new U8x( src.buffer );

  for( let i = 0 ; i < first ; i++ )
  resultTyped[ i ] = srcTyped[ i ];

  for( let i = last + 1 ; i < srcLength ; i++ )
  resultTyped[ i - delta2 ] = srcTyped[ i ];

  if( ins )
  {
    for( let i = 0 ; i < insLength ; i++ )
    resultTyped[ first + i ] = ins[ i ];
  }

  return result;
}

//

/**
 * Routine bufferOnly_() returns a shallow copy of a portion of provided container {-dstArray-}
 * into a new container selected by range {-range-}.
 *
 * If first and second provided arguments is containers, then fisrs argument is destination
 * container {-dst-} and second argument is source container {-dstArray-}. All data in {-dst-}
 * will be cleared. If {-dst-} container is not resizable and resulted container length
 * is not equal to original {-dst-} length, then routine makes new container of {-dst-} type.
 *
 * If first argument and second argument is the same container, routine will try change container inplace.
 *
 * If {-dst-} is not provided routine makes new container of {-dstArray-} type.
 *
 * @param { BufferAny|Long|Null } dst - The destination container.
 * @param { BufferAny|Long } dstArray - The container from which makes a shallow copy.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for selecting elements.
 * If {-range-} is number, then it defines the start index, and the end index sets to dstArray.length.
 * If {-range-} is undefined, routine returns copy of {-dstArray-}.
 * If range[ 0 ] < 0, then start index sets to 0.
 * If range[ 1 ] > dstArray.length, end index sets to dstArray.length.
 * If range[ 1 ] <= range[ 0 ], then routine returns empty container.
 * @param { * } srcArray - The object of any type for insertion.
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferOnly_( buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferOnly_( null, buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferOnly_( buffer, buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let dst = [ 0, 0 ]
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferOnly_( dst, buffer );
 * console.log( got );
 * // log [ 1, 2, 3, 4 ]
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let src = new I32x( [ 0, 0, 0 ] );
 * let got = _.bufferOnly_( buffer, [ 1, 3 ], src );
 * console.log( got );
 * // log Uint8Array[ 2, 3 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferOnly_( null, buffer, 1, [ 0, 0, 0 ] );
 * console.log( got );
 * // log Uint8Array[ 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferOnly_( buffer, buffer, [ 1, 3 ], [ 0, 0, 0 ] );
 * console.log( got );
 * // log Uint8Array[ 2, 3 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let dst = [ 0, 0 ];
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferOnly_( dst, buffer, [ 1, 3 ], [ 0, 0, 0 ] );
 * console.log( got );
 * // log [ 2, 3 ]
 * console.log( got === dst );
 * // log true
 *
 * @returns { BufferAny|Long } If {-dst-} is provided, routine returns container of {-dst-} type.
 * Otherwise, routine returns container of {-dstArray-} type.
 * If {-dst-} and {-dstArray-} is the same container, routine tries to return original container.
 * @function bufferOnly_
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-dst-} is not an any buffer, not a Long, not null.
 * @throws { Error } If {-dstArray-} is not an any buffer, not a Long.
 * @throws { Error } If ( range ) is not a Range or not a Number.
 * @namespace Tools
 */

function bufferOnly_( dst, src, cinterval )
{
  _.assert( 1 <= arguments.length && arguments.length <= 3, 'Expects not {-ins-} argument' );

  if( arguments.length < 3 && dst !== null && dst !== src )
  {
    dst = arguments[ 0 ];
    src = arguments[ 0 ];
    cinterval = arguments[ 1 ];
  }

  let dstLength = 0;
  if( dst !== null )
  dstLength = dst.length === undefined ? dst.byteLength : dst.length;
  let srcLength = src.length === undefined ? src.byteLength : src.length;

  if( cinterval === undefined )
  cinterval = [ 0, srcLength - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval ];

  _.assert( _.bufferAnyIs( dst ) || _.longIs( dst ) || dst === null, 'Expects {-dst-} of any buffer type, long or null' );
  _.assert( _.bufferAnyIs( src ) || _.longIs( src ), 'Expects {-src-} of any buffer type or long' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] === undefined ? 0 : cinterval[ 0 ];
  let last = cinterval[ 1 ] = cinterval[ 1 ] === undefined ? srcLength - 1 : cinterval[ 1 ];

  if( first < 0 )
  first = 0;
  if( last > srcLength - 1 )
  last = srcLength - 1;

  if( last + 1 < first )
  last = first - 1;

  let first2 = Math.max( first, 0 );
  let last2 = Math.min( srcLength - 1, last );

  let resultLength = last - first + 1;

  let result = dst;
  if( dst === null )
  {
    result = _.bufferMakeUndefined( src, resultLength );
  }
  else if( dst === src )
  {
    if( dstLength === resultLength )
    {
      return dst;
    }
    if( _.arrayLikeResizable( dst ) )
    {
      _.assert( Object.isExtensible( dst ), 'Array is not extensible, cannot change array' );
      if( resultLength === 0 )
      return _.longEmpty( dst );

      dst.splice( last2 + 1, dst.length - last + 1 );
      dst.splice( 0, first2 );
      return dst;
    }
    else if( dstLength !== resultLength || _.argumentsArray.is( dst ) )
    {
      result = _.bufferMakeUndefined( dst, resultLength );
    }
  }
  else if( dstLength !== resultLength )
  {
    if( _.arrayLikeResizable( result ) )
    result.splice( resultLength );
    else
    result = _.bufferMakeUndefined( dst, resultLength );
  }

  let resultTyped = result;
  if( _.bufferRawIs( result ) )
  resultTyped = new U8x( result );
  else if( _.bufferViewIs( result ) )
  resultTyped = new U8x( result.buffer );
  let srcTyped = src;
  if( _.bufferRawIs( src ) )
  srcTyped = new U8x( src );
  else if( _.bufferViewIs( src ) )
  srcTyped = new U8x( src.buffer );

  for( let r = first2 ; r < last2 + 1 ; r++ )
  resultTyped[ r - first2 ] = srcTyped[ r ];

  return result;
}

//

/**
 * Routine bufferGrow_() grows provided container {-dst-} by copying elements of source buffer to it.
 * Routine uses cinterval {-cinterval-} positions of the source container and value {-ins-} to fill destination buffer.
 * Routine can only grows size of source container.
 *
 * If first and second provided arguments is containers, then fisrs argument is destination
 * container {-dst-} and second argument is source container {-dstArray-}. All data in {-dst-}
 * will be cleared. If {-dst-} container is not resizable and resulted container length
 * is not equal to original {-src-} length, then routine makes new container with {-dst-} type.
 *
 * If first argument and second argument is the same container, routine will try change container inplace.
 *
 * If {-dst-} is not provided routine makes new container with {-src-} type.
 *
 * @param { BufferAny|Long|Null } dst - The destination container.
 * @param { BufferAny|Long } src - The container from which makes a shallow copy.
 * @param { Range|Number } cinterval - The two-element array that defines the start index and the end index for copying elements from {-src-} and adding {-ins-}.
 * If {-range-} is number, then it defines the end index, and the start index is 0.
 * If range[ 0 ] < 0, then start index sets to 0, end index incrementes by absolute value of range[ 0 ].
 * If range[ 0 ] > 0, then start index sets to 0.
 * If range[ 1 ] < range[ 0 ], then routine returns a copy of original container.
 * @param { * } ins - The object of any type for insertion.
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferGrow_( buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferGrow_( null, buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferGrow_( buffer, buffer, [ 0, 3 ] );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let dst = [ 0, 0 ]
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferGrow_( dst, buffer, [ 0, 3 ] );
 * console.log( got );
 * // log [ 1, 2, 3, 4 ]
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferGrow_( buffer, [ 1, 5 ], 0 );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4, 0, 0 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferGrow_( null, buffer, 2, 1 );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferGrow_( buffer, buffer, [ 0, 3 ], 2 );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let dst = [ 0, 0 ];
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferGrow_( dst, buffer, [ 1, 5 ], 1 );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 1, 1 ]
 * console.log( got === dst );
 * // log true
 *
 * @returns { BufferAny|Long } - If {-dst-} is provided, routine returns container of {-dst-} type.
 * Otherwise, routine returns container of {-src-} type.
 * If {-dst-} and {-src-} is the same container, routine tries to return original container.
 * @function bufferGrow_
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-dst-} is not an any buffer, not a Long, not null.
 * @throws { Error } If {-src-} is not an any buffer, not a Long.
 * @throws { Error } If ( range ) is not a Range or not a Number.
 * @namespace Tools
 */

function bufferGrow_( /* dst, src, cinterval, ins */ )
{
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];
  let cinterval = arguments[ 2 ];
  let ins = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );

  if( arguments.length < 4 && dst !== null && dst !== src )
  {
    dst = arguments[ 0 ];
    src = arguments[ 0 ];
    cinterval = arguments[ 1 ];
    ins = arguments[ 2 ];
  }

  let dstLength = 0;
  if( dst !== null )
  dstLength = dst.length === undefined ? dst.byteLength : dst.length;
  let srcLength = src.length === undefined ? src.byteLength : src.length;

  if( cinterval === undefined )
  cinterval = [ 0, srcLength - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval - 1 ];

  _.assert( _.bufferAnyIs( dst ) || _.longIs( dst ) || dst === null, 'Expects {-dst-} of any buffer type, long or null' );
  _.assert( _.bufferAnyIs( src ) || _.longIs( src ), 'Expects {-src-} of any buffer type or long' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] === undefined ? 0 : cinterval[ 0 ];
  let last = cinterval[ 1 ] = cinterval[ 1 ] === undefined ? srcLength - 1 : cinterval[ 1 ];

  if( first > 0 )
  first = 0;
  if( last < srcLength - 1 )
  last = srcLength - 1;

  if( first < 0 )
  {
    last -= first;
    first -= first;
  }

  if( last + 1 < first )
  last = first - 1;

  let first2 = Math.max( -cinterval[ 0 ], 0 );
  let last2 = Math.min( srcLength - 1 + first2, last + first2 );

  let resultLength = last - first + 1;

  let result = dst;
  if( dst === null )
  {
    result = _.bufferMakeUndefined( src, resultLength );
  }
  else if( dst === src )
  {
    if( dstLength === resultLength )
    {
      return dst;
    }
    if( _.arrayLikeResizable( dst ) )
    {
      _.assert( Object.isExtensible( dst ), 'Array is not extensible, cannot change array' );
      dst.splice( first, 0, ... _.dup( ins, first2 ) );
      dst.splice( last2 + 1, 0, ... _.dup( ins, resultLength <= last2 ? 0 : resultLength - last2 - 1 ) );
      return dst;
    }
    else if( dstLength !== resultLength || _.argumentsArray.is( dst ) )
    {
      result = _.bufferMakeUndefined( dst, resultLength );
    }
  }
  else if( dstLength !== resultLength )
  {
    if( _.arrayLikeResizable( result ) )
    result.splice( resultLength );
    else
    result = _.bufferMakeUndefined( dst, resultLength );
  }

  let resultTyped = result;
  if( _.bufferRawIs( result ) )
  resultTyped = new U8x( result );
  else if( _.bufferViewIs( result ) )
  resultTyped = new U8x( result.buffer );
  let srcTyped = src;
  if( _.bufferRawIs( src ) )
  srcTyped = new U8x( src );
  else if( _.bufferViewIs( src ) )
  srcTyped = new U8x( src.buffer );

  for( let r = first2 ; r < last2 + 1 ; r++ )
  resultTyped[ r ] = srcTyped[ r - first2 ];

  if( ins !== undefined )
  {
    for( let r = 0 ; r < first2 ; r++ )
    resultTyped[ r ] = ins;

    for( let r = last2 + 1 ; r < resultLength ; r++ )
    resultTyped[ r ] = ins;
  }

  return result;
}

//

/**
 * Routine bufferRelength_() changes length of provided container {-dstArray-} by copying it elements to newly created container of the same
 * type using range {-range-} positions of the original containers and value to fill free space after copy {-srcArray-}.
 * Routine can grows and reduces size of container.
 *
 * If first and second provided arguments is containers, then fisrs argument is destination
 * container {-dst-} and second argument is source container {-dstArray-}. All data in {-dst-}
 * will be cleared. If {-dst-} container is not resizable and resulted container length
 * is not equal to original {-dst-} length, then routine makes new container of {-dst-} type.
 *
 * If first argument and second argument is the same container, routine will try change container inplace.
 *
 * If {-dst-} is not provided routine makes new container of {-dstArray-} type.
 *
 * @param { BufferAny|Long|Null } dst - The destination container.
 * @param { BufferAny|Long } dstArray - The container from which makes a shallow copy.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements from {-dstArray-} and adding {-srcArray-}.
 * If {-range-} is number, then it defines the start index, and the end index sets to dstArray.length.
 * If range[ 0 ] < 0, then start index sets to 0.
 * If range[ 1 ] <= range[ 0 ], then routine returns empty container.
 * @param { * } srcArray - The object of any type for insertion.
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferRelength_( buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferRelength_( null, buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferRelength_( buffer, buffer );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let dst = [ 0, 0 ]
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferRelength_( dst, buffer );
 * console.log( got );
 * // log [ 1, 2, 3, 4 ]
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferRelength_( buffer, [ 1, 6 ], 0 );
 * console.log( got );
 * // log Uint8Array[ 2, 3, 4, 0, 0 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferRelength_( null, buffer, 2, 1 );
 * console.log( got );
 * // log Uint8Array[ 3, 4 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferRelength_( buffer, buffer, [ 0, 3 ], 2 );
 * console.log( got );
 * // log Uint8Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * @example
 * let dst = [ 0, 0 ];
 * let buffer = new U8x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferRelength_( dst, buffer, [ 1, 6 ], [ 0, 0, 0 ] );
 * console.log( got );
 * // log [ 2, 3, 4, [ 0, 0, 0 ], [ 0, 0, 0 ] ]
 * console.log( got === dst );
 * // log true
 *
 * @returns { BufferAny|Long } If {-dst-} is provided, routine returns container of {-dst-} type.
 * Otherwise, routine returns container of {-dstArray-} type.
 * If {-dst-} and {-dstArray-} is the same container, routine tries to return original container.
 * @function bufferRelength_
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-dst-} is not an any buffer, not a Long, not null.
 * @throws { Error } If {-dstArray-} is not an any buffer, not a Long.
 * @throws { Error } If ( range ) is not a Range or not a Number.
 * @namespace Tools
 */

function bufferRelength_( /* dst, src, cinterval, ins */ )
{
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];
  let cinterval = arguments[ 2 ];
  let ins = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );

  if( arguments.length < 4 && dst !== null && dst !== src )
  {
    dst = arguments[ 0 ];
    src = arguments[ 0 ];
    cinterval = arguments[ 1 ];
    ins = arguments[ 2 ];
  }

  let dstLength = 0;
  if( dst !== null )
  dstLength = dst.length === undefined ? dst.byteLength : dst.length;
  let srcLength = src.length === undefined ? src.byteLength : src.length;

  if( cinterval === undefined )
  cinterval = [ 0, srcLength - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval-1 ];

  _.assert( _.bufferAnyIs( dst ) || _.longIs( dst ) || dst === null, 'Expects {-dst-} of any buffer type, long or null' );
  _.assert( _.bufferAnyIs( src ) || _.longIs( src ), 'Expects {-src-} of any buffer type or long' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] === undefined ? 0 : cinterval[ 0 ];
  let last = cinterval[ 1 ] = cinterval[ 1 ] === undefined ? srcLength - 1 : cinterval[ 1 ];

  if( last < first )
  last = first - 1;

  if( cinterval[ 1 ] < 0 && cinterval[ 0 ] < 0 )
  cinterval[ 0 ] -= cinterval[ 1 ] + 1;

  if( first < 0 )
  {
    last -= first;
    first -= first;
  }

  let first2 = Math.max( Math.abs( cinterval[ 0 ] ), 0 );
  let last2 = Math.min( srcLength - 1, last );

  let resultLength = last - first + 1;

  let result = dst;
  if( dst === null )
  {
    result = _.bufferMakeUndefined( src, resultLength );
  }
  else if( dst === src )
  {
    if( dstLength === resultLength && cinterval[ 0 ] === 0 )
    {
      return dst;
    }
    if( _.arrayLikeResizable( dst ) )
    {
      _.assert( Object.isExtensible( dst ), 'dst is not extensible, cannot change dst' );
      if( cinterval[ 0 ] < 0 )
      {
        dst.splice( first, 0, ... _.dup( ins, first2 ) );
        dst.splice( last2 + 1, src.length - last2, ... _.dup( ins, last - last2 ) );
      }
      else
      {
        dst.splice( 0, first );
        dst.splice( last2 + 1 - first2, src.length - last2, ... _.dup( ins, last - last2 ) );
      }
      return dst;
    }
    else if( dstLength !== resultLength || _.argumentsArray.is( dst ) )
    {
      result = _.bufferMakeUndefined( dst, resultLength );
    }
  }
  else if( dstLength !== resultLength )
  {
    if( _.arrayLikeResizable( result ) )
    result.splice( resultLength );
    else
    result = _.bufferMakeUndefined( dst, resultLength );
  }

  let resultTyped = result;
  if( _.bufferRawIs( result ) )
  resultTyped = new U8x( result );
  else if( _.bufferViewIs( result ) )
  resultTyped = new U8x( result.buffer );
  let srcTyped = src;
  if( _.bufferRawIs( src ) )
  srcTyped = new U8x( src );
  else if( _.bufferViewIs( src ) )
  srcTyped = new U8x( src.buffer );

  if( resultLength === 0 )
  {
    return result;
  }
  if( cinterval[ 0 ] < 0 )
  {
    for( let r = first2 ; r < ( last2 + 1 + first2 ) && r < resultLength ; r++ )
    resultTyped[ r ] = srcTyped[ r - first2 ];
    if( ins !== undefined )
    {
      for( let r = 0 ; r < first2 ; r++ )
      resultTyped[ r ] = ins;
      for( let r = last2 + 1 + first2 ; r < resultLength ; r++ )
      resultTyped[ r ] = ins;
    }
  }
  else
  {
    for( let r = first2 ; r < last2 + 1 ; r++ )
    resultTyped[ r - first2 ] = srcTyped[ r ];
    if( ins !== undefined )
    {
      for( let r = last2 + 1 ; r < last + 1 ; r++ )
      resultTyped[ r - first2 ] = ins;
    }
  }

  return result;
}

//

function bufferResize_( dst, srcBuffer, size )
{
  if( dst === null )
  dst = _.nothing;

  if( arguments.length === 2 )
  {
    size = srcBuffer;
    srcBuffer = dst;
  }

  let range = _.intervalIs( size ) ? size : [ 0, size ];
  size = range[ 1 ] - range[ 0 ];

  if( range[ 1 ] < range[ 0 ] )
  range[ 1 ] = range[ 0 ];

  _.assert( _.bufferAnyIs( srcBuffer ) && srcBuffer.byteLength >= 0 );
  _.assert( _.intervalIs( range ) );
  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( dst === srcBuffer && range[ 0 ] === 0 && range[ 1 ] === srcBuffer.byteLength )
  return srcBuffer;

  let result;
  let newOffset = srcBuffer.byteOffset ? srcBuffer.byteOffset + range[ 0 ] : range[ 0 ];

  if( dst === _.nothing )
  {
    _.assert( dst === _.nothing );

    result = _.bufferMakeUndefined( srcBuffer, size / srcBuffer.BYTES_PER_ELEMENT || size );
    let resultTyped = _.bufferRawIs( result ) ? new U8x( result ) : new U8x( result.buffer );
    let srcBufferToU8x = _.bufferRawIs( srcBuffer ) ? new U8x( srcBuffer ) : new U8x( srcBuffer.buffer );

    let first = Math.max( newOffset, 0 );
    let last = Math.min( srcBufferToU8x.byteLength, newOffset + size );
    newOffset = newOffset < 0 ? -newOffset : 0;
    for( let r = first ; r < last ; r++ )
    resultTyped[ r - first + newOffset ] = srcBufferToU8x[ r ];
  }
  else
  {
    _.assert( _.bufferAnyIs( dst ) );

    if( dst === srcBuffer && !_.bufferRawIs( srcBuffer ) && newOffset >= 0 && newOffset + size <= srcBuffer.buffer.byteLength )
    {
      if( _.bufferNodeIs( srcBuffer ) )
      result = BufferNode.from( srcBuffer.buffer, newOffset, size );
      else if( _.bufferViewIs( srcBuffer ) )
      result = new BufferView( srcBuffer.buffer, newOffset, size );
      else
      result = new srcBuffer.constructor( srcBuffer.buffer, newOffset, size / srcBuffer.BYTES_PER_ELEMENT );
    }
    else if( _.bufferRawIs( dst ) )
    {
      if( size === dst.byteLength )
      result = dst;
      else
      result = _.bufferMakeUndefined( dst, size );
    }
    else if( size <= dst.byteLength )
    {
      result = dst;
    }
    else
    {
      result = _.bufferMakeUndefined( dst, size / dst.BYTES_PER_ELEMENT || size );
    }

    let dstTyped = _.bufferRawIs( result ) ? new U8x( result ) : new U8x( result.buffer );
    let srcBufferToU8x = _.bufferRawIs( srcBuffer ) ? new U8x( srcBuffer ) : new U8x( srcBuffer.buffer );

    let first = Math.max( newOffset, 0 );
    let last = Math.min( srcBufferToU8x.byteLength, newOffset + size );
    for( let r = first ; r < last ; r++ )
    dstTyped[ r - first ] = srcBufferToU8x[ r ];
    dstTyped.fill( 0, last - first, dstTyped.length );
  }

  return result;
}

//

function bufferReusing4Arguments_head( routine, args )
{
  _.assert( arguments.length === 2 );
  _.assert( args.length > 0, 'Expects arguments' );

  /* qqq : for Dmytro : use switch here and in similar code */
  let o = Object.create( null );
  if( args.length === 1 )
  {
    if( _.mapIs( args[ 0 ] ) )
    {
      o = args[ 0 ];
    }
    else
    {
      o.dst = null;
      o.src = args[ 0 ];
    }
  }
  else if( args.length === 2 )
  {
    o.dst = null;
    o.src = args[ 0 ];
    o.cinterval = args[ 1 ];
  }
  else if( args.length === 3 )
  {
    o.dst = null;
    o.src = args[ 0 ];
    o.cinterval = args[ 1 ];
    o.ins = args[ 2 ];
  }
  else if( args.length === 4 )
  {
    o.dst = args[ 0 ];
    o.src = args[ 1 ];
    o.cinterval = args[ 2 ];
    o.ins = args[ 3 ];
  }
  else
  {
    _.assert( 0, 'Expects less then 4 arguments' );
  }

  /* */

  _.routine.optionsWithoutUndefined( routine, o ); /* qqq : for Dmytro : use _.routine.options() */
  _.assert( _.bufferAnyIs( o.src ) || _.longIs( o.src ) );
  _.assert( _.intervalIs( o.cinterval ) || _.numberIs( o.cinterval ) || o.cinterval === null );
  _.assert( _.intIs( o.minSize ) && o.minSize >= 0 );

  o.growFactor = o.growFactor === 0 ? 1 : o.growFactor;
  o.shrinkFactor = o.shrinkFactor === 0 ? 1 : o.shrinkFactor;

  if( o.dst === _.self )
  o.dst = o.src;

  return o;
}

//

function bufferReusing3Arguments_head( routine, args )
{
  _.assert( arguments.length === 2 );
  _.assert( 1 <= args.length && args.length <= 3 );

  let o;
  if( args.length === 3 )
  {
    o = Object.create( null );
    o.dst = args[ 0 ];
    o.src = args[ 1 ];
    o.cinterval = args[ 2 ];
    o = _.bufferReusing4Arguments_head.call( this, routine, [ o ] );
  }
  else
  {
    o = _.bufferReusing4Arguments_head.apply( this, arguments );
  }

  return o;
}

//

function _bufferElementSizeGet( src )
{
  if( src.BYTES_PER_ELEMENT )
  return src.BYTES_PER_ELEMENT;
  else if( src.byteLength === undefined )
  return 8;
  else
  return 1;
}

//

function _dstBufferSizeRecount( o )
{
  if( !_.numberIs( o.dstSize ) )
  o.dstSize = ( o.cinterval[ 1 ] - o.cinterval[ 0 ] + 1 ) * o.dstElementSize;

  if( o.growFactor > 1 && o.reusing && o.dst !== null )
  {
    let dstSize = o.dst.length ? o.dst.length * o.dstElementSize : o.dst.byteLength;
    if( dstSize < o.dstSize )
    {
      let growed = dstSize * o.growFactor;
      o.dstSize = growed > o.dstSize ? growed : o.dstSize;
    }
  }

  o.dstSize = o.minSize > o.dstSize ? o.minSize : o.dstSize;
  return o.dstSize;
}

//

function _bufferTypedViewMake( src )
{
  let srcTyped = src;
  if( _.bufferRawIs( src ) )
  srcTyped = new U8x( src );
  if( _.bufferViewIs( src ) )
  srcTyped = new U8x( src.buffer );

  return srcTyped;
}

//

function _resultBufferReusedMaybe( o )
{
  let buffer;

  let dstOffset = 0;
  let dstSize = o.dst.length ? o.dst.length * o.dstElementSize : o.dst.byteLength;

  if( o.offsetting && !_.bufferNodeIs( o.dst ) && _.bufferAnyIs( o.dst ) )
  {
    dstOffset = o.dst.byteOffset ? o.dst.byteOffset : dstOffset;
    dstSize = o.dst.buffer ? o.dst.buffer.byteLength : dstSize;
  }

  let shouldReuse = insideBufferBounds( dstOffset, dstSize, o.dstSize );
  let shouldShrink = shrinkFactorCheck( dstSize, o.dstSize );

  if( shouldReuse && !shouldShrink )
  {
    buffer = o.dst;
    let leftOffset = dstOffset + o.cinterval[ 0 ];
    let bufferLength = buffer.buffer && !_.bufferViewIs( buffer ) ? buffer.length : buffer.byteLength;

    if( leftOffset !== dstOffset || o.dstSize !== bufferLength )
    {
      if( !o.offsetting )
      leftOffset += buffer.byteOffset ? buffer.byteOffset : 0;

      if( _.bufferNodeIs( buffer ) )
      buffer = BufferNode.from( buffer.buffer, leftOffset, o.dstSize );
      else if( buffer.buffer )
      buffer = new buffer.constructor( buffer.buffer, leftOffset, o.dstSize );
    }
  }
  else
  {
    buffer = _resultBufferMake( o );
  }

  return buffer;

  /* */

  function shrinkFactorCheck( dstSize, resultSize )
  {
    if( o.shrinkFactor > 1 )
    return ( dstSize / resultSize ) >= o.shrinkFactor;
    return false;
  }

  /* */
  function insideBufferBounds( dstOffset, dstSize, resultSize )
  {
    let leftOffset = dstOffset + o.cinterval[ 0 ];
    let insideLeftBound = leftOffset >= 0 && leftOffset < dstSize;
    let rightBound = leftOffset + resultSize;
    let insideRightBound = rightBound <= dstSize;
    return insideLeftBound && insideRightBound;
  }
}

//

function _resultBufferMake( o )
{
  let buffer;
  let dstResultedLength = o.dstSize / o.dstElementSize;
  _.assert( _.intIs( dstResultedLength ) );

  if( o.dst === null )
  {
    buffer = _.bufferMakeUndefined( o.src, dstResultedLength );
  }
  else if( o.dst.length === dstResultedLength )
  {
    buffer = o.dst;
  }
  else if( o.dst.byteLength === o.dstSize )
  {
    buffer = o.dst;
  }
  else if( _.arrayLikeResizable( o.dst ) )
  {
    buffer = o.dst;
    buffer.length = dstResultedLength;
  }
  else
  {
    buffer = _.bufferMakeUndefined( o.dst, dstResultedLength );
  }

  return buffer;
}

//

/**
 * Routine bufferReusingBut() copies elements from source buffer {-src-} to destination buffer {-dst-}.
 * Routine copies all elements excluding elements in interval {-cinterval-}, its elements replace by elements
 * from insertion buffer {-ins-}.
 *
 * Data in buffer {-dst-} overwrites. If {-dst-} container is not resizable and resulted length of destination
 * container is not equal to original {-dst-} length, then routine makes new container of {-dst-} type.
 *
 * If buffer {-dst-} and {-src-} are the same buffer, then routine tries to change container {-src-} inplace and
 * reuse original raw buffer.
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingBut( buffer, [ 1, 1 ], [ 5 ] );
 * console.log( got );
 * // log Float64Array[ 1, 5, 3, 4, 0, 0, 0, 0 ]
 * console.log( got === buffer );
 * // log false
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingBut
 * ({
 *   dst : buffer,
 *   src : buffer,
 *   cinterval : [ 1, 1 ],
 *   ins : [ 5 ],
 *   minSize : 2,
 * });
 * console.log( got );
 * // log Float64Array[ 1, 5, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 *
 * First parameter set :
 * @param { BufferAny|Long|Null } dst - The destination container.
 * @param { BufferAny|Long } src - The container from which makes a shallow copy.
 * @param { Interval|Number } cinterval - The closed interval that defines the start index and the end index for removing elements.
 * If {-cinterval-} is a Number, then it defines the index of removed element.
 * If cinterval[ 0 ] < 0, then start index sets to 0.
 * If cinterval[ 1 ] > src.length, end index sets to ( src.length - 1 ).
 * If cinterval[ 1 ] < cinterval[ 0 ], then routine removes not elements, the insertion of elements begins at start index.
 * @param { BufferAny|Long|Undefined } ins - The container with elements for insertion. Inserting begins at start index.
 *
 * Second parameter set :
 * @param { Aux } o - Options map.
 * @param { BufferAny|Long|Null } o.dst - The destination container.
 * @param { BufferAny|Long } o.src - The container from which makes a shallow copy.
 * @param { Interval|Number } o.cinterval - The closed interval that defines the start index and the end index for removing elements.
 * The behavior same to first parameter set.
 * @param { BufferAny|Long|Undefined } o.ins - The container with elements for insertion. Inserting begins at start index.
 * @param { BoolLike } o.reusing - Allows routine to reuse original raw buffer. Default is true.
 * @param { BoolLike } o.offsetting - Allows routine to change offset in destination buffer {-o.dst-}. Default is true.
 * @param { Number } o.minSize - Minimal size of resulted buffer. If resulted buffer size is less than {-o.minSize-}, routine makes
 * new buffer. Default is 64.
 * @param { Number } o.growFactor - If routine needs to make new container that is bigger than {-o.minSize-}, then routine multiplies
 * {-o.growFactor-} on resulted buffer size. If {-o.growFactor-} <= 1, routine does not grow size of resulted buffer. Default is 2.
 * @param { Number } o.shrinkFactor - If resulted buffer in {-o.shrinkFactor-} times less than its raw buffer, than routine makes
 * new buffer. If {-o.shrinkFactor-} <= 1, then routine not change original raw buffer. Default is 0.
 *
 * @returns { BufferAny|Long } - If {-dst-} is provided, routine returns container of {-dst-} type.
 * Otherwise, routine returns container of {-src-} type.
 * If {-dst-} and {-src-} are the same container, routine tries to return original container.
 * Routine tries to save original raw buffer.
 * @function bufferReusingBut
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-dst-} has not valid type.
 * @throws { Error } If {-src-} has not valid type.
 * @throws { Error } If {-cinterval-} has not valid type.
 * @throws { Error } If {-ins-} has not valid type.
 * @throws { Error } If options map {-o-} has not valid type.
 * @throws { Error } If options map {-o-} has not known options.
 * @throws { Error } If {-o.minSize-} has not valid type or is not an Integer.
 * @throws { Error } If {-o.growFactor-} has not valid type or is not an Integer.
 * @throws { Error } If {-o.shrinkFactor-} has not valid type or is not an Integer.
 * @namespace Tools
 */

function bufferReusingBut_body( o )
{
  _.assert( _.intIs( o.growFactor ) && o.growFactor >= 0 );
  _.assert( _.intIs( o.shrinkFactor ) && o.shrinkFactor >= 0 );

  /* */

  let bufferLength = 0;
  if( o.dst )
  bufferLength = o.dst && o.dst.length !== undefined ? o.dst.length : o.dst.byteLength;
  else
  bufferLength = o.src.length === undefined ? o.src.byteLength : o.src.length;

  let _cinterval;
  o.cinterval = cintervalClamp();

  if( o.ins === null || o.ins === undefined )
  o.ins = [];

  _.assert( _.longIs( o.ins ) || _.bufferAnyIs( o.ins ) );

  /* */

  let newBufferCreate = o.dst === null;

  _.assert( newBufferCreate || _.bufferAnyIs( o.dst ) || _.longIs( o.dst ) );

  let dstElementSize;
  if( newBufferCreate )
  o.dstElementSize = _._bufferElementSizeGet( o.src );
  else
  o.dstElementSize = _._bufferElementSizeGet( o.dst );

  o.dstSize = bufferSizeCount( _cinterval, o.dstElementSize );
  o.dstSize = _._dstBufferSizeRecount( o );

  let dstBuffer
  if( o.reusing && !newBufferCreate )
  dstBuffer = _resultBufferReusedMaybe( o );
  else
  dstBuffer = _resultBufferMake( o );

  let dstTyped = _bufferTypedViewMake( dstBuffer );
  let srcTyped = _bufferTypedViewMake( o.src );
  let result = dstBufferFill( dstTyped, srcTyped, o.cinterval, o.ins );

  return dstBuffer;

  /* */

  function cintervalClamp()
  {
    if( o.cinterval === null )
    o.cinterval = [ 0, -1 ];
    else if( _.number.is( o.cinterval ) )
    o.cinterval = [ o.cinterval, o.cinterval ];

    if( o.cinterval[ 0 ] < 0 )
    o.cinterval[ 0 ] = 0;
    if( o.cinterval[ 1 ] < o.cinterval[ 0 ] - 1 )
    o.cinterval[ 1 ] = o.cinterval[ 0 ] - 1;

    _cinterval = o.cinterval;
    return [ 0, o.cinterval[ 1 ] ];
  }

  function bufferSizeCount( cinterval, elementSize )
  {
    let length = bufferLength - ( cinterval[ 1 ] - cinterval[ 0 ] + 1 ) + o.ins.length;
    return length * elementSize;
  }

  /* */

  function dstBufferFill( /* dstTyped, srcTyped, cinterval, ins */ )
  {
    let dstTyped = arguments[ 0 ];
    let srcTyped = arguments[ 1 ];
    let cinterval = arguments[ 2 ];
    let ins = arguments[ 3 ];

    /* */

    cinterval = _cinterval;

    let left = Math.max( 0, cinterval[ 0 ] );
    let right = left + ins.length
    let start = cinterval[ 1 ] + 1;

    if( srcTyped.length )
    {
      if( dstTyped.buffer === srcTyped.buffer )
      {
        let val = srcTyped[ srcTyped.length - 1 ];
        /* qqq for Dmytro : not optimal */
        for( let i = srcTyped.length - 1 ; i >= start ; i-- )
        {
          let temp = srcTyped[ i - 1 ];
          dstTyped[ right + i - start ] = val;
          val = temp;
        }
      }
      else
      {
        for( let i = srcTyped.length - 1 ; i >= start ; i-- )
        dstTyped[ right + i - start ] = srcTyped[ i ];
      }

      for( let i = 0 ; i < left ; i++ )
      dstTyped[ i ] = srcTyped[ i ];
    }

    for( let i = left ; i < right ; i++ )
    dstTyped[ i ] = ins[ i - left ];

    return dstTyped;
  }
}

bufferReusingBut_body.defaults =
{
  dst : null,
  src : null,
  cinterval : null,
  ins : null,
  offsetting : 1,
  reusing : 1,
  growFactor : 2,
  shrinkFactor : 0,
  minSize : 64,
};

//

let bufferReusingBut = _.routine.unite( bufferReusing4Arguments_head, bufferReusingBut_body );

//

/**
 * Routine bufferReusingOnly() gets the part of source buffer {-src-} and copies it to destination buffer {-dst-}.
 *
 * Data in buffer {-dst-} overwrites. If {-dst-} container is not resizable and resulted length of destination
 * container is not equal to original {-dst-} length, then routine makes new container of {-dst-} type.
 *
 * If buffer {-dst-} and {-src-} are the same buffer, then routine tries to change container {-src-} inplace and
 * reuse original raw buffer.
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingOnly( buffer, [ 1, 1 ] );
 * console.log( got );
 * // log Float64Array[ 2 ]
 * console.log( got === buffer );
 * // log false
 * console.log( got.buffer === buffer.buffer );
 * // log false
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingOnly
 * ({
 *   dst : buffer,
 *   src : buffer,
 *   cinterval : [ 1, 1 ],
 *   minSize : 1,
 * });
 * console.log( got );
 * // log Float64Array[ 2 ]
 * console.log( got === buffer );
 * // log false
 * console.log( got.buffer === buffer.buffer );
 * // log true
 *
 * First parameter set :
 * @param { BufferAny|Long|Null } dst - The destination container.
 * @param { BufferAny|Long } src - The container from which makes a shallow copy.
 * @param { Interval|Number } cinterval - The closed interval that defines the start index and the end index for removing elements.
 * If {-cinterval-} is a Number, then it defines the index of removed element.
 * If cinterval[ 0 ] < 0, then start index sets to 0.
 * If cinterval[ 1 ] > src.length, end index sets to ( src.length - 1 ).
 * If cinterval[ 1 ] < cinterval[ 0 ], then routine makes buffer of minimal size and fills by data.
 *
 * Second parameter set :
 * @param { Aux } o - Options map.
 * @param { BufferAny|Long|Null } o.dst - The destination container.
 * @param { BufferAny|Long } o.src - The container from which makes a shallow copy.
 * @param { Interval|Number } o.cinterval - The closed interval that defines the start index and the end index for removing elements.
 * The behavior same to first parameter set.
 * @param { BoolLike } o.reusing - Allows routine to reuse original raw buffer. Default is true.
 * @param { BoolLike } o.offsetting - Allows routine to change offset in destination buffer {-o.dst-}. Default is true.
 * @param { Number } o.minSize - Minimal size of resulted buffer. If resulted buffer size is less than {-o.minSize-}, routine makes
 * new buffer. Default is 64.
 * @param { Number } o.shrinkFactor - If resulted buffer in {-o.shrinkFactor-} times less than its raw buffer, than routine makes
 * new buffer. If {-o.shrinkFactor-} <= 1, then routine not change original raw buffer. Default is 0.
 *
 * @returns { BufferAny|Long } - If {-dst-} is provided, routine returns container of {-dst-} type.
 * Otherwise, routine returns container of {-src-} type.
 * If {-dst-} and {-src-} are the same container, routine tries to return original container.
 * Routine tries to save original raw buffer.
 * @function bufferReusingOnly
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-dst-} has not valid type.
 * @throws { Error } If {-src-} has not valid type.
 * @throws { Error } If {-cinterval-} has not valid type.
 * @throws { Error } If options map {-o-} has not valid type.
 * @throws { Error } If options map {-o-} has not known options.
 * @throws { Error } If {-o.minSize-} has not valid type or is not an Integer.
 * @throws { Error } If {-o.shrinkFactor-} has not valid type or is not an Integer.
 * @namespace Tools
 */

// function bufferReusingOnly( /* dst, src, cinterval */ )
// {
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   let o;
//   if( arguments.length === 3 )
//   {
//     o = Object.create( null );
//     o.dst = arguments[ 0 ];
//     o.src = arguments[ 1 ];
//     o.cinterval = arguments[ 2 ];
//   }
//   else
//   {
//     o = _._bufferReusing_head.apply( this, arguments );
//   }
//   _.assert( o.ins === undefined, 'Expects no argument {-ins-}' );
//
//   o.cinterval = cintervalClamp();
//
//   _.routine.options( bufferReusingOnly, o );
//   o.growFactor = 1;
//   o.bufferFill = dstBufferFill;
//
//   return _._bufferReusing( o );
//
//   /* */
//
//   function cintervalClamp()
//   {
//     let bufferLength = 0;
//     if( o.dst )
//     bufferLength = o.dst && o.dst.length !== undefined ? o.dst.length : o.dst.byteLength;
//     else
//     bufferLength = o.src.length === undefined ? o.src.byteLength : o.src.length;
//
//     if( o.cinterval === undefined )
//     o.cinterval = [ 0, bufferLength - 1 ];
//     else if( _.numberIs( o.cinterval ) )
//     o.cinterval = [ 0, o.cinterval ];
//
//     if( o.cinterval[ 0 ] < 0 )
//     o.cinterval[ 0 ] = 0;
//     if( o.cinterval[ 1 ] < o.cinterval[ 0 ] - 1 )
//     o.cinterval[ 1 ] = o.cinterval[ 0 ] - 1;
//     if( o.cinterval[ 1 ] > bufferLength - 1 )
//     o.cinterval[ 1 ] = bufferLength - 1;
//
//     return o.cinterval;
//   }
//
//   /* */
//
//   function dstBufferFill( /* dstTyped, srcTyped, cinterval */ )
//   {
//     let dstTyped = arguments[ 0 ];
//     let srcTyped = arguments[ 1 ];
//     let cinterval = arguments[ 2 ];
//
//     /* */
//
//     let left = Math.max( 0, cinterval[ 0 ] );
//     let right = Math.min( cinterval[ 1 ], srcTyped.length - 1 );
//     let i;
//     for( i = left ; i < right + 1 ; i++ )
//     dstTyped[ i - left ] = srcTyped[ i ];
//
//     if( _.arrayLikeResizable( dstTyped ) && i - left < dstTyped.length )
//     for( ; i - left < dstTyped.length; i++ )
//     dstTyped[ i - left ] = undefined;
//   }
// }
//
// bufferReusingOnly.defaults =
// {
//   dst : null,
//   src : null,
//   cinterval : null,
//   offsetting : 1,
//   reusing : 1,
//   shrinkFactor : 0,
//   minSize : 64,
// };

function bufferReusingOnly_body( o )
{
  _.assert( _.intIs( o.shrinkFactor ) && o.shrinkFactor >= 0 );

  o.cinterval = cintervalClamp();
  o.growFactor = 1;

  /* */

  let newBufferCreate = o.dst === null;

  _.assert( newBufferCreate || _.bufferAnyIs( o.dst ) || _.longIs( o.dst ) );

  let dstElementSize;
  if( newBufferCreate )
  o.dstElementSize = _._bufferElementSizeGet( o.src );
  else
  o.dstElementSize = _._bufferElementSizeGet( o.dst );

  o.dstSize = _._dstBufferSizeRecount( o );

  let dstBuffer
  if( o.reusing && !newBufferCreate )
  dstBuffer = _resultBufferReusedMaybe( o );
  else
  dstBuffer = _resultBufferMake( o );

  let dstTyped = _bufferTypedViewMake( dstBuffer );
  let srcTyped = _bufferTypedViewMake( o.src );
  let result = dstBufferFill( dstTyped, srcTyped, o.cinterval, o.ins );

  return dstBuffer;

  /* */

  function cintervalClamp()
  {
    let bufferLength = 0;
    if( o.dst )
    bufferLength = o.dst && o.dst.length !== undefined ? o.dst.length : o.dst.byteLength;
    else
    bufferLength = o.src.length === undefined ? o.src.byteLength : o.src.length;

    if( o.cinterval === null )
    o.cinterval = [ 0, bufferLength - 1 ];
    else if( _.number.is( o.cinterval ) )
    o.cinterval = [ 0, o.cinterval ];

    if( o.cinterval[ 0 ] < 0 )
    o.cinterval[ 0 ] = 0;
    if( o.cinterval[ 1 ] < o.cinterval[ 0 ] - 1 )
    o.cinterval[ 1 ] = o.cinterval[ 0 ] - 1;
    if( o.cinterval[ 1 ] > bufferLength - 1 )
    o.cinterval[ 1 ] = bufferLength - 1;

    return o.cinterval;
  }

  /* */

  function dstBufferFill( /* dstTyped, srcTyped, cinterval */ )
  {
    let dstTyped = arguments[ 0 ];
    let srcTyped = arguments[ 1 ];
    let cinterval = arguments[ 2 ];

    /* */

    let left = Math.max( 0, cinterval[ 0 ] );
    let right = Math.min( cinterval[ 1 ], srcTyped.length - 1 );
    let i;
    for( i = left ; i < right + 1 ; i++ )
    dstTyped[ i - left ] = srcTyped[ i ];

    if( _.arrayLikeResizable( dstTyped ) && i - left < dstTyped.length )
    for( ; i - left < dstTyped.length; i++ )
    dstTyped[ i - left ] = undefined;
  }
}

bufferReusingOnly_body.defaults =
{
  dst : null,
  src : null,
  cinterval : null,
  offsetting : 1,
  reusing : 1,
  shrinkFactor : 0,
  minSize : 64,
};

//

let bufferReusingOnly = _.routine.unite( bufferReusing3Arguments_head, bufferReusingOnly_body );

//

/**
 * Routine bufferReusingGrow() copies elements from source buffer {-src-} to grow destination buffer {-dst-}.
 * All original source buffer will contains in destination buffer.
 *
 * Data in buffer {-dst-} overwrites. If {-dst-} container is not resizable and resulted length of destination
 * container is not equal to original {-dst-} length, then routine makes new container of {-dst-} type.
 *
 * If buffer {-dst-} and {-src-} are the same buffer, then routine tries to change container {-src-} inplace and
 * reuse original raw buffer.
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingGrow( buffer, [ -1, 3 ], 7 );
 * console.log( got );
 * // log Float64Array[ 7, 1, 2, 3, 4, 7, 7, 7 ]
 * console.log( got === buffer );
 * // log false
 * console.log( got.buffer === buffer.buffer );
 * // log false
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingGrow
 * ({
 *   dst : buffer,
 *   src : buffer,
 *   cinterval : [ 0, 3 ],
 *   ins : 7,
 *   minSize : 2,
 * });
 * console.log( got );
 * // log Float64Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 * console.log( got.buffer === buffer.buffer );
 * // log true
 *
 * First parameter set :
 * @param { BufferAny|Long|Null } dst - The destination container.
 * @param { BufferAny|Long } src - The container from which makes a shallow copy.
 * @param { Interval|Number } cinterval - The closed interval that defines the start index and the end index for removing elements.
 * If {-cinterval-} is a Number, then it defines the index of removed element.
 * If cinterval[ 0 ] < 0, then insertion element prepends to buffer.
 * If cinterval[ 0 ] > 0, then cinterval[ 0 ] sets to 0.
 * If cinterval[ 1 ] < src.length, then cinterval[ 1 ] sets to ( src.length - 1 ).
 * If cinterval[ 1 ] > src.length, then insertion element appends to buffer.
 * If cinterval[ 1 ] < cinterval[ 0 ], then routine change not source buffer.
 * @param { * } ins - Insertion element with compatible type to destination buffer.
 *
 * Second parameter set :
 * @param { Aux } o - Options map.
 * @param { BufferAny|Long|Null } o.dst - The destination container.
 * @param { BufferAny|Long } o.src - The container from which makes a shallow copy.
 * @param { Interval|Number } o.cinterval - The closed interval that defines the start index and the end index for removing elements.
 * The behavior same to first parameter set.
 * @param { * } o.ins - Insertion element with compatible type to destination buffer.
 * @param { BoolLike } o.reusing - Allows routine to reuse original raw buffer. Default is true.
 * @param { BoolLike } o.offsetting - Allows routine to change offset in destination buffer {-o.dst-}. Default is true.
 * @param { Number } o.minSize - Minimal size of resulted buffer. If resulted buffer size is less than {-o.minSize-}, routine makes
 * new buffer. Default is 64.
 * @param { Number } o.growFactor - If routine needs to make new container that is bigger than {-o.minSize-}, then routine multiplies
 * {-o.growFactor-} on resulted buffer size. If {-o.growFactor-} <= 1, routine does not grow size of resulted buffer. Default is 2.
 *
 * @returns { BufferAny|Long } - If {-dst-} is provided, routine returns container of {-dst-} type.
 * Otherwise, routine returns container of {-src-} type.
 * If {-dst-} and {-src-} are the same container, routine tries to return original container.
 * Routine tries to save original raw buffer.
 * @function bufferReusingGrow
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-dst-} has not valid type.
 * @throws { Error } If {-src-} has not valid type.
 * @throws { Error } If {-cinterval-} has not valid type.
 * @throws { Error } If {-ins-} has not valid type.
 * @throws { Error } If options map {-o-} has not valid type.
 * @throws { Error } If options map {-o-} has not known options.
 * @throws { Error } If {-o.minSize-} has not valid type or is not an Integer.
 * @throws { Error } If {-o.growFactor-} has not valid type or is not an Integer.
 * @namespace Tools
 */

// function bufferReusingGrow( /* dst, src, cinterval, ins */ )
// {
//   let o = _._bufferReusing_head.apply( this, arguments );
//
//   let srcLength = o.src.byteLength;
//   if( o.src.length !== undefined )
//   srcLength = o.src.length;
//   o.cinterval = cintervalClamp();
//
//   _.routine.options( bufferReusingGrow, o );
//
//   o.bufferFill = dstBufferFill;
//
//   return _._bufferReusing( o );
//
//   /* */
//
//   function cintervalClamp()
//   {
//     let bufferLength = 0;
//     if( o.dst )
//     bufferLength = o.dst && o.dst.length !== undefined ? o.dst.length : o.dst.byteLength;
//     else
//     bufferLength = o.src.length === undefined ? o.src.byteLength : o.src.length;
//
//     if( o.cinterval === undefined )
//     o.cinterval = [ 0, bufferLength - 1 ];
//     else if( _.numberIs( o.cinterval ) )
//     o.cinterval = [ 0, o.cinterval - 1 ];
//
//     if( o.cinterval[ 0 ] > 0 )
//     o.cinterval[ 0 ] = 0;
//     if( o.cinterval[ 1 ] < o.cinterval[ 0 ] - 1 )
//     o.cinterval[ 1 ] = o.cinterval[ 0 ] - 1;
//     if( o.cinterval[ 1 ] < bufferLength - 1 )
//     o.cinterval[ 1 ] = bufferLength - 1;
//
//     return o.cinterval;
//   }
//
//   /* */
//
//   function dstBufferFill( /* dstTyped, srcTyped, cinterval, ins */ )
//   {
//     let dstTyped = arguments[ 0 ];
//     let srcTyped = arguments[ 1 ];
//     let cinterval = arguments[ 2 ];
//     let ins = arguments[ 3 ];
//
//     /* */
//
//     let offset = Math.max( 0, -cinterval[ 0 ] );
//     let rightBound = Math.min( dstTyped.length, srcLength );
//     let length = dstTyped.length;
//
//     if( dstTyped !== srcTyped )
//     {
//       for( let i = offset ; i < rightBound + offset ; i++ )
//       dstTyped[ i ] = srcTyped[ i - offset ];
//     }
//
//     for( let i = 0 ; i < offset ; i++ )
//     dstTyped[ i ] = o.ins;
//
//     for( let i = offset + rightBound ; i < length ; i++ )
//     dstTyped[ i ] = o.ins;
//
//     return dstTyped;
//
//   }
// }
//
// bufferReusingGrow.defaults =
// {
//   dst : null,
//   src : null,
//   cinterval : null,
//   ins : null,
//   offsetting : 1,
//   reusing : 1,
//   growFactor : 2,
//   minSize : 64,
// };

function bufferReusingGrow_body( o )
{
  _.assert( _.intIs( o.growFactor ) && o.growFactor >= 0 );

  let srcLength = o.src.byteLength;
  if( o.src.length !== undefined )
  srcLength = o.src.length;
  o.cinterval = cintervalClamp();

  /* */

  let newBufferCreate = o.dst === null;

  _.assert( newBufferCreate || _.bufferAnyIs( o.dst ) || _.longIs( o.dst ) );

  let dstElementSize;
  if( newBufferCreate )
  o.dstElementSize = _._bufferElementSizeGet( o.src );
  else
  o.dstElementSize = _._bufferElementSizeGet( o.dst );

  o.dstSize = _._dstBufferSizeRecount( o );

  let dstBuffer
  if( o.reusing && !newBufferCreate )
  dstBuffer = _resultBufferReusedMaybe( o );
  else
  dstBuffer = _resultBufferMake( o );

  let dstTyped = _bufferTypedViewMake( dstBuffer );
  let srcTyped = _bufferTypedViewMake( o.src );
  let result = dstBufferFill( dstTyped, srcTyped, o.cinterval, o.ins );

  return dstBuffer;

  /* */

  function cintervalClamp()
  {
    let bufferLength = 0;
    if( o.dst )
    bufferLength = o.dst && o.dst.length !== undefined ? o.dst.length : o.dst.byteLength;
    else
    bufferLength = o.src.length === undefined ? o.src.byteLength : o.src.length;

    if( o.cinterval === null )
    o.cinterval = [ 0, bufferLength - 1 ];
    else if( _.number.is( o.cinterval ) )
    o.cinterval = [ 0, o.cinterval - 1 ];

    if( o.cinterval[ 0 ] > 0 )
    o.cinterval[ 0 ] = 0;
    if( o.cinterval[ 1 ] < o.cinterval[ 0 ] - 1 )
    o.cinterval[ 1 ] = o.cinterval[ 0 ] - 1;
    if( o.cinterval[ 1 ] < bufferLength - 1 )
    o.cinterval[ 1 ] = bufferLength - 1;

    return o.cinterval;
  }

  /* */

  function dstBufferFill( /* dstTyped, srcTyped, cinterval, ins */ )
  {
    let dstTyped = arguments[ 0 ];
    let srcTyped = arguments[ 1 ];
    let cinterval = arguments[ 2 ];
    let ins = arguments[ 3 ];

    /* */

    let offset = Math.max( 0, -cinterval[ 0 ] );
    let rightBound = Math.min( dstTyped.length, srcLength );
    let length = dstTyped.length;

    if( dstTyped !== srcTyped )
    {
      for( let i = offset ; i < rightBound + offset ; i++ )
      dstTyped[ i ] = srcTyped[ i - offset ];
    }

    for( let i = 0 ; i < offset ; i++ )
    dstTyped[ i ] = o.ins;

    for( let i = offset + rightBound ; i < length ; i++ )
    dstTyped[ i ] = o.ins;

    return dstTyped;

  }
}

bufferReusingGrow_body.defaults =
{
  dst : null,
  src : null,
  cinterval : null,
  ins : null,
  offsetting : 1,
  reusing : 1,
  growFactor : 2,
  minSize : 64,
};

//

let bufferReusingGrow = _.routine.unite( bufferReusing4Arguments_head, bufferReusingGrow_body );

//

/**
 * Routine bufferReusingRelength() copies elements from source buffer {-src-} to destination buffer {-dst-}.
 * Routine applies any offsets from Interval {-cinterval-}.
 *
 * Data in buffer {-dst-} overwrites. If {-dst-} container is not resizable and resulted length of destination
 * container is not equal to original {-dst-} length, then routine makes new container of {-dst-} type.
 *
 * If buffer {-dst-} and {-src-} are the same buffer, then routine tries to change container {-src-} inplace and
 * reuse original raw buffer.
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingRelength( buffer, [ -1, 3 ], 7 );
 * console.log( got );
 * // log Float64Array[ 7, 1, 2, 3, 4, 7, 7, 7 ]
 * console.log( got === buffer );
 * // log false
 * console.log( got.buffer === buffer.buffer );
 * // log false
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingRelength
 * ({
 *   dst : buffer,
 *   src : buffer,
 *   cinterval : [ 0, 3 ],
 *   ins : 7,
 *   minSize : 2,
 * });
 * console.log( got );
 * // log Float64Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 * console.log( got.buffer === buffer.buffer );
 * // log true
 *
 * First parameter set :
 * @param { BufferAny|Long|Null } dst - The destination container.
 * @param { BufferAny|Long } src - The container from which makes a shallow copy.
 * @param { Interval|Number } cinterval - The closed interval that defines the start index and the end index for removing elements.
 * If {-cinterval-} is a Number, then it defines the index of removed element.
 * If cinterval[ 0 ] < 0, then insertion element prepends to buffer.
 * If cinterval[ 0 ] > 0, then routine skips elements until index cinterval[ 0 ].
 * If cinterval[ 1 ] < src.length, routine shrinks buffer on right side.
 * If cinterval[ 1 ] > src.length, then insertion element appends to buffer.
 * If cinterval[ 1 ] < cinterval[ 0 ], then routine makes buffer with minimal size.
 * @param { * } ins - Insertion element with compatible type to destination buffer.
 *
 * Second parameter set :
 * @param { Aux } o - Options map.
 * @param { BufferAny|Long|Null } o.dst - The destination container.
 * @param { BufferAny|Long } o.src - The container from which makes a shallow copy.
 * @param { Interval|Number } o.cinterval - The closed interval that defines the start index and the end index for removing elements.
 * The behavior same to first parameter set.
 * @param { * } o.ins - Insertion element with compatible type to destination buffer.
 * @param { BoolLike } o.reusing - Allows routine to reuse original raw buffer. Default is true.
 * @param { BoolLike } o.offsetting - Allows routine to change offset in destination buffer {-o.dst-}. Default is true.
 * @param { Number } o.minSize - Minimal size of resulted buffer. If resulted buffer size is less than {-o.minSize-}, routine makes
 * new buffer. Default is 64.
 * @param { Number } o.growFactor - If routine needs to make new container that is bigger than {-o.minSize-}, then routine multiplies
 * {-o.growFactor-} on resulted buffer size. If {-o.growFactor-} <= 1, routine does not grow size of resulted buffer. Default is 2.
 * @param { Number } o.shrinkFactor - If resulted buffer in {-o.shrinkFactor-} times less than its raw buffer, than routine makes
 * new buffer. If {-o.shrinkFactor-} <= 1, then routine not change original raw buffer. Default is 0.
 *
 * @returns { BufferAny|Long } - If {-dst-} is provided, routine returns container of {-dst-} type.
 * Otherwise, routine returns container of {-src-} type.
 * If {-dst-} and {-src-} are the same container, routine tries to return original container.
 * Routine tries to save original raw buffer.
 * @function bufferReusingRelength
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-dst-} has not valid type.
 * @throws { Error } If {-src-} has not valid type.
 * @throws { Error } If {-cinterval-} has not valid type.
 * @throws { Error } If {-ins-} has not valid type.
 * @throws { Error } If options map {-o-} has not valid type.
 * @throws { Error } If options map {-o-} has not known options.
 * @throws { Error } If {-o.minSize-} has not valid type or is not an Integer.
 * @throws { Error } If {-o.growFactor-} has not valid type or is not an Integer.
 * @throws { Error } If {-o.shrinkFactor-} has not valid type or is not an Integer.
 * @namespace Tools
 */

// function bufferReusingRelength( /* dst, src, cinterval, ins */ )
// {
//   let o = _._bufferReusing_head.apply( this, arguments );
//
//   let left, right;
//   let srcLength = o.src.byteLength;
//   if( o.src.length !== undefined )
//   srcLength = o.src.length;
//   o.cinterval = cintervalClamp();
//
//   _.routine.options( bufferReusingRelength, o );
//
//   o.bufferFill = dstBufferFill;
//
//   return _._bufferReusing( o );
//
//   /* */
//
//   function cintervalClamp()
//   {
//
//     let bufferLength = 0;
//     if( o.dst )
//     bufferLength = o.dst && o.dst.length !== undefined ? o.dst.length : o.dst.byteLength;
//     else
//     bufferLength = o.src.length === undefined ? o.src.byteLength : o.src.length;
//
//     if( o.cinterval === undefined )
//     o.cinterval = [ 0, bufferLength - 1 ];
//     else if( _.numberIs( o.cinterval ) )
//     o.cinterval = [ 0, o.cinterval - 1 ];
//
//     left = o.cinterval[ 0 ];
//     right = o.cinterval[ 1 ];
//
//     if( o.cinterval[ 1 ] < o.cinterval[ 0 ] - 1 )
//     o.cinterval[ 1 ] = o.cinterval[ 0 ] - 1;
//
//     return o.cinterval;
//   }
//
//   /* */
//
//   function dstBufferFill( /* dstTyped, srcTyped, cinterval, ins */ )
//   {
//     let dstTyped = arguments[ 0 ];
//     let srcTyped = arguments[ 1 ];
//     let cinterval = arguments[ 2 ];
//     let ins = arguments[ 3 ];
//
//     /* */
//
//     let offset = left < 0 ? Math.max( 0, -left ) : 0;
//     left = left < 0 ? 0 : left;
//     let rightBound = Math.min( srcTyped.length, right - left + 1 );
//     rightBound = Math.min( rightBound, srcLength );
//     let length = dstTyped.length;
//
//     let i;
//     for( i = offset ; i < rightBound + offset && i - offset + left < srcTyped.length ; i++ )
//     dstTyped[ i ] = srcTyped[ i - offset + left ];
//
//     if( i > srcLength + offset - left )
//     i = srcLength + offset - left;
//
//     for( ; i < length ; i++ )
//     dstTyped[ i ] = o.ins;
//
//     for( let i = 0 ; i < offset ; i++ )
//     dstTyped[ i ] = o.ins;
//
//     return dstTyped;
//
//   }
// }
//
// bufferReusingRelength.defaults =
// {
//   dst : null,
//   src : null,
//   cinterval : null,
//   ins : null,
//   offsetting : 1,
//   reusing : 1,
//   growFactor : 2,
//   shrinkFactor : 0,
//   minSize : 64,
// };

function bufferReusingRelength_body( o )
{
  _.assert( _.intIs( o.growFactor ) && o.growFactor >= 0 );
  _.assert( _.intIs( o.shrinkFactor ) && o.shrinkFactor >= 0 );

  let left, right;
  let srcLength = o.src.byteLength;
  if( o.src.length !== undefined )
  srcLength = o.src.length;
  o.cinterval = cintervalClamp();

  let newBufferCreate = o.dst === null;

  _.assert( newBufferCreate || _.bufferAnyIs( o.dst ) || _.longIs( o.dst ) );

  let dstElementSize;
  if( newBufferCreate )
  o.dstElementSize = _._bufferElementSizeGet( o.src );
  else
  o.dstElementSize = _._bufferElementSizeGet( o.dst );

  o.dstSize = _._dstBufferSizeRecount( o );

  let dstBuffer
  if( o.reusing && !newBufferCreate )
  dstBuffer = _resultBufferReusedMaybe( o );
  else
  dstBuffer = _resultBufferMake( o );

  let dstTyped = _bufferTypedViewMake( dstBuffer );
  let srcTyped = _bufferTypedViewMake( o.src );
  let result = dstBufferFill( dstTyped, srcTyped, o.cinterval, o.ins );

  return dstBuffer;

  /* */

  function cintervalClamp()
  {

    let bufferLength = 0;
    if( o.dst )
    bufferLength = o.dst && o.dst.length !== undefined ? o.dst.length : o.dst.byteLength;
    else
    bufferLength = o.src.length === undefined ? o.src.byteLength : o.src.length;

    if( o.cinterval === null )
    o.cinterval = [ 0, bufferLength - 1 ];
    else if( _.number.is( o.cinterval ) )
    o.cinterval = [ 0, o.cinterval - 1 ];

    left = o.cinterval[ 0 ];
    right = o.cinterval[ 1 ];

    if( o.cinterval[ 1 ] < o.cinterval[ 0 ] - 1 )
    o.cinterval[ 1 ] = o.cinterval[ 0 ] - 1;

    return o.cinterval;
  }

  /* */

  function dstBufferFill( /* dstTyped, srcTyped, cinterval, ins */ )
  {
    let dstTyped = arguments[ 0 ];
    let srcTyped = arguments[ 1 ];
    let cinterval = arguments[ 2 ];
    let ins = arguments[ 3 ];

    /* */

    let offset = left < 0 ? Math.max( 0, -left ) : 0;
    left = left < 0 ? 0 : left;
    let rightBound = Math.min( srcTyped.length, right - left + 1 );
    rightBound = Math.min( rightBound, srcLength );
    let length = dstTyped.length;

    let i;
    for( i = offset ; i < rightBound + offset && i - offset + left < srcTyped.length ; i++ )
    dstTyped[ i ] = srcTyped[ i - offset + left ];

    if( i > srcLength + offset - left )
    i = srcLength + offset - left;

    for( ; i < length ; i++ )
    dstTyped[ i ] = o.ins;

    for( let i = 0 ; i < offset ; i++ )
    dstTyped[ i ] = o.ins;

    return dstTyped;

  }
}

bufferReusingRelength_body.defaults =
{
  dst : null,
  src : null,
  cinterval : null,
  ins : null,
  offsetting : 1,
  reusing : 1,
  growFactor : 2,
  shrinkFactor : 0,
  minSize : 64,
};

//

let bufferReusingRelength = _.routine.unite( bufferReusing4Arguments_head, bufferReusingRelength_body );

//

/**
 * Routine bufferReusingResize() resizes raw buffer of source buffer {-src-} in interval {-cinterval-}.
 *
 * If destination buffer {-dst-} is provided, then routine copies data to the buffer byte per byte. Data in
 * buffer {-dst-} overwrites. If {-dst-} container is not resizable and resulted length of destination container
 * is not equal to original {-dst-} length, then routine makes new container of {-dst-} type.
 *
 * If buffer {-dst-} and {-src-} are the same buffer, then routine tries to change container {-src-} inplace and
 * reuse original raw buffer.
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingResize( buffer, buffer, [ 8, 32 ] );
 * console.log( got );
 * // log Float64Array[ 2, 3, 4 ]
 * console.log( got === buffer );
 * // log false
 * console.log( got.buffer === buffer.buffer );
 * // log true
 *
 * @example
 * let buffer = new F64x( [ 1, 2, 3, 4 ] );
 * let got = _.bufferReusingResize
 * ({
 *   dst : buffer,
 *   src : buffer,
 *   cinterval : [ 0, 32 ],
 *   ins : 7,
 *   minSize : 2,
 * });
 * console.log( got );
 * // log Float64Array[ 1, 2, 3, 4 ]
 * console.log( got === buffer );
 * // log true
 * console.log( got.buffer === buffer.buffer );
 * // log true
 *
 * First parameter set :
 * @param { BufferAny|Long|Null } dst - The destination container.
 * @param { BufferAny|Long } src - The container from which makes a shallow copy.
 * @param { Interval|Number } cinterval - The closed interval that defines the start index and the end index for removing elements.
 * If {-cinterval-} is a Number, then it defines the index of removed element.
 * If cinterval[ 0 ] < 0, then routine resizes buffer left.
 * If cinterval[ 0 ] > 0, then routine skips bytes until index cinterval[ 0 ].
 * If cinterval[ 1 ] < src size, routine shrinks buffer on right side.
 * If cinterval[ 1 ] > src size, then routine resizes buffer right.
 * If cinterval[ 1 ] < cinterval[ 0 ], then routine makes buffer with minimal size.
 *
 * Second parameter set :
 * @param { Aux } o - Options map.
 * @param { BufferAny|Long|Null } o.dst - The destination container.
 * @param { BufferAny|Long } o.src - The container from which makes a shallow copy.
 * @param { Interval|Number } o.cinterval - The closed interval that defines the start index and the end index for removing elements.
 * The behavior same to first parameter set.
 * @param { BoolLike } o.reusing - Allows routine to reuse original raw buffer. Default is true.
 * @param { BoolLike } o.offsetting - Allows routine to change offset in destination buffer {-o.dst-}. Default is true.
 * @param { Number } o.minSize - Minimal size of resulted buffer. If resulted buffer size is less than {-o.minSize-}, routine makes
 * new buffer. Default is 64.
 * @param { Number } o.growFactor - If routine needs to make new container that is bigger than {-o.minSize-}, then routine multiplies
 * {-o.growFactor-} on resulted buffer size. If {-o.growFactor-} <= 1, routine does not grow size of resulted buffer. Default is 2.
 * @param { Number } o.shrinkFactor - If resulted buffer in {-o.shrinkFactor-} times less than its raw buffer, than routine makes
 * new buffer. If {-o.shrinkFactor-} <= 1, then routine not change original raw buffer. Default is 0.
 *
 * @returns { BufferAny|Long } - If {-dst-} is provided, routine returns container of {-dst-} type.
 * Otherwise, routine returns container of {-src-} type.
 * If {-dst-} and {-src-} are the same container, routine tries to return original container.
 * Routine tries to save original raw buffer.
 * @function bufferReusingResize
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-dst-} has not valid type.
 * @throws { Error } If {-src-} has not valid type.
 * @throws { Error } If {-cinterval-} has not valid type.
 * @throws { Error } If options map {-o-} has not valid type.
 * @throws { Error } If options map {-o-} has not known options.
 * @throws { Error } If {-o.minSize-} has not valid type or is not an Integer.
 * @throws { Error } If {-o.growFactor-} has not valid type or is not an Integer.
 * @throws { Error } If {-o.shrinkFactor-} has not valid type or is not an Integer.
 * @namespace Tools
 */

// function bufferReusingResize( /* dst, src, cinterval */ )
// {
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   let o;
//   if( arguments.length === 3 )
//   {
//     o = Object.create( null );
//     o.dst = arguments[ 0 ];
//     o.src = arguments[ 1 ];
//     o.cinterval = arguments[ 2 ];
//   }
//   else
//   {
//     o = _._bufferReusing_head.apply( this, arguments );
//   }
//
//   _.assert( _.bufferAnyIs( o.src ), 'Expects buffer {-src-}' );
//
//   let left, right;
//   o.cinterval = cintervalClamp();
//
//   _.routine.options( bufferReusingResize, o );
//
//   o.bufferSizeCount = bufferSizeCount;
//   o.bufferFill = dstBufferFill;
//
//   return _._bufferReusing( o );
//
//   /* */
//
//   function cintervalClamp()
//   {
//     let bufferLength = 0;
//     if( o.dst )
//     bufferLength = o.dst && o.dst.length !== undefined ? o.dst.length : o.dst.byteLength;
//     else
//     bufferLength = o.src.length === undefined ? o.src.byteLength : o.src.length;
//
//     if( o.cinterval === undefined )
//     o.cinterval = [ 0, bufferLength - 1 ];
//     else if( _.numberIs( o.cinterval ) )
//     o.cinterval = [ 0, o.cinterval - 1 ];
//
//     left = o.cinterval[ 0 ];
//     right = o.cinterval[ 1 ];
//
//     if( o.cinterval[ 1 ] < o.cinterval[ 0 ] - 1 )
//     o.cinterval[ 1 ] = o.cinterval[ 0 ] - 1;
//
//     return o.cinterval;
//   }
//
//   /* */
//
//   function bufferSizeCount( cinterval, elementSize )
//   {
//     return cinterval[ 1 ] - cinterval[ 0 ] + 1;
//   }
//
//   /* */
//
//   function dstBufferFill( /* dstTyped, srcTyped, cinterval, ins */ )
//   {
//     let dstTyped = arguments[ 0 ];
//     let srcTyped = arguments[ 1 ];
//     let cinterval = arguments[ 2 ];
//     let ins = arguments[ 3 ];
//
//     /* */
//
//     if( srcTyped === dstTyped )
//     return dstTyped;
//
//     if( _.bufferAnyIs( dstTyped ) )
//     dstTyped = _.bufferBytesFrom( dstTyped.buffer ? dstTyped.buffer : dstTyped );
//
//     let srcBytesView = srcTyped;
//     if( _.bufferAnyIs( srcTyped ) )
//     srcBytesView = _.bufferBytesFrom( srcTyped.buffer ? srcTyped.buffer : srcTyped );
//
//     let offset = srcTyped.byteOffset ? srcTyped.byteOffset : 0;
//     offset += left;
//
//     let length = right - left + 1;
//     if( dstTyped.buffer === srcTyped.buffer )
//     {
//       dstTyped = new dstTyped.constructor( dstTyped.buffer, offset, length );
//     }
//     else
//     {
//       for( let i = 0; i < dstTyped.length && i < length ; i++ )
//       dstTyped[ i ] = srcBytesView[ offset + i ] ? srcBytesView[ offset + i ] : 0;
//     }
//
//     return dstTyped;
//
//   }
// }
//
// bufferReusingResize.defaults =
// {
//   dst : null,
//   src : null,
//   cinterval : null,
//   offsetting : 1,
//   reusing : 1,
//   growFactor : 2,
//   shrinkFactor : 0,
//   minSize : 64,
// };


function bufferReusingResize_body( o )
{
  _.assert( _.intIs( o.shrinkFactor ) && o.shrinkFactor >= 0 );
  _.assert( _.intIs( o.growFactor ) && o.growFactor >= 0 );
  _.assert( _.bufferAnyIs( o.src ), 'Expects buffer {-src-}' );

  let left, right;
  o.cinterval = cintervalClamp();

  let newBufferCreate = o.dst === null;

  _.assert( newBufferCreate || _.bufferAnyIs( o.dst ) || _.longIs( o.dst ) );

  let dstElementSize;
  if( newBufferCreate )
  o.dstElementSize = _._bufferElementSizeGet( o.src );
  else
  o.dstElementSize = _._bufferElementSizeGet( o.dst );

  o.dstSize = bufferSizeCount( o.cinterval );
  o.dstSize = _._dstBufferSizeRecount( o );

  let dstBuffer
  if( o.reusing && !newBufferCreate )
  dstBuffer = _resultBufferReusedMaybe( o );
  else
  dstBuffer = _resultBufferMake( o );

  let dstTyped = _bufferTypedViewMake( dstBuffer );
  let srcTyped = _bufferTypedViewMake( o.src );
  let result = dstBufferFill( dstTyped, srcTyped, o.cinterval, o.ins );

  return dstBuffer;

  /* */

  function cintervalClamp()
  {
    let bufferLength = 0;
    if( o.dst )
    bufferLength = o.dst && o.dst.length !== undefined ? o.dst.length : o.dst.byteLength;
    else
    bufferLength = o.src.length === undefined ? o.src.byteLength : o.src.length;

    if( o.cinterval === null )
    o.cinterval = [ 0, bufferLength - 1 ];
    else if( _.number.is( o.cinterval ) )
    o.cinterval = [ 0, o.cinterval - 1 ];

    left = o.cinterval[ 0 ];
    right = o.cinterval[ 1 ];

    if( o.cinterval[ 1 ] < o.cinterval[ 0 ] - 1 )
    o.cinterval[ 1 ] = o.cinterval[ 0 ] - 1;

    return o.cinterval;
  }

  /* */

  function bufferSizeCount( cinterval )
  {
    return cinterval[ 1 ] - cinterval[ 0 ] + 1;
  }

  /* */

  function dstBufferFill( /* dstTyped, srcTyped, cinterval, ins */ )
  {
    let dstTyped = arguments[ 0 ];
    let srcTyped = arguments[ 1 ];
    let cinterval = arguments[ 2 ];
    let ins = arguments[ 3 ];

    /* */

    if( srcTyped === dstTyped )
    return dstTyped;

    if( _.bufferAnyIs( dstTyped ) )
    dstTyped = _.bufferBytesFrom( dstTyped.buffer ? dstTyped.buffer : dstTyped );

    let srcBytesView = srcTyped;
    if( _.bufferAnyIs( srcTyped ) )
    srcBytesView = _.bufferBytesFrom( srcTyped.buffer ? srcTyped.buffer : srcTyped );

    let offset = srcTyped.byteOffset ? srcTyped.byteOffset : 0;
    offset += left;

    let length = right - left + 1;
    if( dstTyped.buffer === srcTyped.buffer )
    {
      dstTyped = new dstTyped.constructor( dstTyped.buffer, offset, length );
    }
    else
    {
      for( let i = 0; i < dstTyped.length && i < length ; i++ )
      dstTyped[ i ] = srcBytesView[ offset + i ] ? srcBytesView[ offset + i ] : 0;
    }

    return dstTyped;

  }
}

bufferReusingResize_body.defaults =
{
  dst : null,
  src : null,
  cinterval : null,
  offsetting : 1,
  reusing : 1,
  growFactor : 2,
  shrinkFactor : 0,
  minSize : 64,
};

//

let bufferReusingResize = _.routine.unite( bufferReusing3Arguments_head, bufferReusingResize_body );

//

/**
 * The routine bufferBytesGet() converts source buffer {-src-} and returns a new instance of buffer U8x ( array of 8-bit unsigned integers ).
 *
 * @param { BufferRaw|BufferNode|BufferTyped|BufferView|String } src - Instance of any buffer or string.
 *
 * @example
 * let src = new BufferRaw( 5 );
 * _.bufferBytesGet(src);
 * // returns [ 0, 0, 0, 0, 0, ]
 *
 * @example
 * let src = BufferNode.alloc( 5, 'a' );
 * _.bufferBytesGet(src);
 * // returns [ 97, 97, 97, 97, 97 ]
 *
 * @example
 * let src = new I32x( [ 5, 6, 7 ] );
 * _.bufferBytesGet(src);
 * // returns [ 5, 0, 6, 0, 7, 0 ]
 *
 * @example
 * let src = 'string';
 * _.bufferBytesGet(src);
 * // returns [ 115, 116, 114, 105, 110, 103 ]
 *
 * @returns { TypedArray } Returns a new instance of U8x constructor.
 * @function bufferBytesGet
 * @throws { Error } If arguments.length is less or more than 1.
 * @throws { Error } If {-src-} is not a instance of any buffer or string.
 * @memberof wTools
 */

function bufferBytesGet( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( src instanceof BufferRaw || src instanceof BufferRawShared )
  {
    return new U8x( src );
  }
  else if( typeof BufferNode !== 'undefined' && src instanceof BufferNode )
  {
    return new U8x( src.buffer, src.byteOffset, src.byteLength );
  }
  else if( _.bufferTypedIs( src ) )
  {
    return new U8x( src.buffer, src.byteOffset, src.byteLength );
  }
  else if( _.bufferViewIs( src ) )
  {
    return new U8x( src.buffer, src.byteOffset, src.byteLength );
  }
  else if( _.strIs( src ) )
  {
    if( _global_.BufferNode )
    return new U8x( _.bufferRawFrom( BufferNode.from( src, 'utf8' ) ) );
    else
    return new U8x( _.encode.utf8ToBuffer( src ) ); /* Dmytro : maybe it should have some improvement, base module should not use higher level modules */
  }
  else _.assert( 0, 'wrong argument' );

}

//

/**
 * The bufferRetype() routine converts and returns a new instance of (bufferType) constructor.
 *
 * @param { typedArray } src - The typed array.
 * @param { typedArray } bufferType - The type of typed array.
 *
 * @example
 * let view1 = new I8x( [ 1, 2, 3, 4, 5, 6 ] );
 * _.bufferRetype(view1, I16x);
 * // returns [ 513, 1027, 1541 ]
 *
 * @example
 * let view2 = new I16x( [ 513, 1027, 1541 ] );
 * _.bufferRetype(view2, I8x);
 * // returns [ 1, 2, 3, 4, 5, 6 ]
 *
 * @returns { typedArray } Returns a new instance of (bufferType) constructor.
 * @function bufferRetype
 * @throws { Error } Will throw an Error if {-srcMap-} is not a typed array object.
 * @throws { Error } Will throw an Error if (bufferType) is not a type of the typed array.
 * @namespace Tools
 */

function bufferRetype( src, bufferType )
{

  _.assert( arguments.length === 2, 'Expects source buffer {-src-} and constructor of buffer {-bufferTyped-}' );
  _.assert( _.bufferTypedIs( src ) );
  _.assert( _.constructorIsBuffer( bufferType ) );

  let o = src.byteOffset;
  let l = Math.floor( src.byteLength / bufferType.BYTES_PER_ELEMENT );
  let result = new bufferType( src.buffer, o, l );

  return result;
}

//

function bufferJoin()
{

  if( arguments.length < 2 )
  {
    _.assert( _.bufferAnyIs( arguments[ 0 ] ) || !arguments[ 0 ] );
    return arguments[ 0 ] || null;
  }

  let srcs = [];
  let size = 0;
  let firstSrc;
  for( let s = 0 ; s < arguments.length ; s++ )
  {
    let src = arguments[ s ];

    if( src === null )
    continue;

    if( !firstSrc )
    firstSrc = src;

    if( _.bufferRawIs( src ) )
    {
      srcs.push( new U8x( src ) );
    }
    else if( src instanceof U8x )
    {
      srcs.push( src );
    }
    else
    {
      srcs.push( new U8x( src.buffer, src.byteOffset, src.byteLength ) );
    }

    _.assert( src.byteLength >= 0, 'Expects buffers, but got', _.entity.strType( src ) );

    size += src.byteLength;
  }

  if( srcs.length === 0 )
  return null;

  /* */

  let resultBuffer = new BufferRaw( size );
  let result = _.bufferRawIs( firstSrc ) ? resultBuffer : new firstSrc.constructor( resultBuffer );
  let resultBytes = result.constructor === U8x ? result : new U8x( resultBuffer );

  /* */

  let offset = 0;
  for( let s = 0 ; s < srcs.length ; s++ )
  {
    let src = srcs[ s ];
    if( resultBytes.set )
    {
      resultBytes.set( src, offset );
    }
    else
    {
      for( let i = 0 ; i < src.length ; i++ )
      resultBytes[ offset+i ] = src[ i ];
    }
    offset += src.byteLength;
  }

  return result;
}

//

function bufferMove( dst, src )
{

  if( arguments.length === 2 )
  {

    _.assert( _.longIs( dst ) );
    _.assert( _.longIs( src ) );

    if( dst.length !== src.length )
    throw _.err( '_.bufferMove :', '"dst" and "src" must have same length' );

    if( dst.set && ( src instanceof U64x || src instanceof I64x ) )
    {
      for( let s = 0 ; s < src.length ; s++ )
      dst[ s ] = Number( src[ s ] );
    }
    else if( dst.set && ( dst instanceof U64x || dst instanceof I64x ) )
    {
      dst.set( _.bigInt.s.from( src ) );
    }
    else if( dst.set )
    {
      dst.set( src );
    }
    else
    {
      for( let s = 0 ; s < src.length ; s++ )
      dst[ s ] = src[ s ];
    }

  }
  else if( arguments.length === 1 )
  {

    let options = arguments[ 0 ];
    _.map.assertHasOnly( options, bufferMove.defaults );

    src = options.src;
    dst = options.dst;

    if( _.bufferRawIs( dst ) )
    {
      dst = new U8x( dst );
      if( _.bufferTypedIs( src ) && !( src instanceof U8x ) )
      src = new U8x( src.buffer, src.byteOffset, src.byteLength );
    }

    _.assert( _.longIs( dst ) );
    _.assert( _.longIs( src ) );

    options.dstOffset = options.dstOffset || 0;

    if( dst.set && ( src instanceof U64x || src instanceof I64x ) )
    {
      for( let s = 0, d = options.dstOffset ; s < src.length ; s++, d++ )
      dst[ d ] = Number( src[ s ] );
    }
    else if( dst.set && ( dst instanceof U64x || dst instanceof I64x ) )
    {
      dst.set( _.bigInt.s.from( src ), options.dstOffset );
    }
    else if( dst.set )
    {
      dst.set( src, options.dstOffset );
    }
    else
    {
      for( let s = 0, d = options.dstOffset ; s < src.length ; s++, d++ )
      dst[ d ] = src[ s ];
    }

  }
  else _.assert( 0, 'unexpected' );

  return dst;
}

bufferMove.defaults =
{
  dst : null,
  src : null,
  dstOffset : null,
}

//

function bufferToStr( src )
{
  let result = '';

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.bufferAnyIs( src ) );

  if( typeof BufferNode !== 'undefined' )
  src = _.bufferNodeFrom( src );
  else if( src instanceof BufferRaw )
  src = new U8x( src, 0, src.byteLength );

  if( _.bufferNodeIs( src ) )
  return src.toString( 'utf8' );

  try
  {
    result = String.fromCharCode.apply( null, src );
  }
  catch( e )
  {
    for( let i = 0 ; i < src.byteLength ; i++ )
    {
      result += String.fromCharCode( src[ i ] );
    }
  }

  return result;
}

//

function bufferToDom( xmlBuffer )
{
  let result;

  if( typeof DOMParser !== 'undefined' && DOMParser.prototype.parseFromBuffer )
  {

    let parser = new DOMParser();
    result = parser.parseFromBuffer( xmlBuffer, xmlBuffer.byteLength, 'text/xml' );
    throw _.err( 'not tested' );

  }
  else
  {

    let xmlStr = _.bufferToStr( xmlBuffer );
    result = this.strToDom( xmlStr );

  }

  return result;
}

//

function bufferLeft( src, ins )
{

  if( !_.bufferRawIs( src ) )
  src = _.bufferBytesGet( src );

  if( !_.bufferRawIs( ins ) )
  ins = _.bufferBytesGet( ins );

  _.assert( _.routine.is( src.indexOf ) );
  _.assert( _.routine.is( ins.indexOf ) );

  let index = src.indexOf( ins[ 0 ] );
  while( index !== -1 )
  {
    let i = 0;
    for( ; i < ins.length ; i++ )
    if( src[ index + i ] !== ins[ i ] )
    break;

    if( i === ins.length )
    return index;

    index += 1;
    index = src.indexOf( ins[ 0 ], index );

  }

  return index;
}

//

function bufferRight( src, ins )
{

  if( !_.bufferRawIs( src ) )
  src = _.bufferBytesGet( src );

  if( !_.bufferRawIs( ins ) )
  ins = _.bufferBytesGet( ins );

  _.assert( _.routine.is( src.indexOf ) );
  _.assert( _.routine.is( ins.indexOf ) );

  let index = src.lastIndexOf( ins[ 0 ] );
  while( index !== -1 )
  {

    let i = 0;
    for( ; i < ins.length; i++ )
    if( src[ index + i ] !== ins[ i ] )
    break;

    if( i === ins.length )
    return index;

    index -= 1;
    index = src.lastIndexOf( ins[ 0 ], index );

  }

  return index;
}

//

function bufferSplit( src, del )
{

  if( !_.bufferRawIs( src ) )
  src = _.bufferBytesGet( src );

  if( !_.bufferRawIs( del ) )
  del = _.bufferBytesGet( del );

  _.assert( _.routine.is( src.indexOf ) );
  _.assert( _.routine.is( del.indexOf ) );

  let result = [];
  let begin = 0;
  let index = src.indexOf( del[ 0 ] );
  while( index !== -1 )
  {

    for( let i = 0 ; i < del.length ; i++ )
    if( src[ index+i ] !== del[ i ] )
    break;

    if( i === del.length )
    {
      result.push( src.slice( begin, index ) );
      index += i;
      begin = index;
    }
    else
    {
      index += 1;
    }

    index = src.indexOf( del[ 0 ], index );

  }

  if( begin === 0 )
  result.push( src );
  else
  result.push( src.slice( begin, src.length ) );

  return result;
}

//

function bufferCutOffLeft( src, del )
{

  if( !_.bufferRawIs( src ) )
  src = _.bufferBytesGet( src );

  if( !_.bufferRawIs( del ) )
  del = _.bufferBytesGet( del );

  _.assert( _.routine.is( src.indexOf ) );
  _.assert( _.routine.is( del.indexOf ) );

  let result = [];
  let index = src.indexOf( del[ 0 ] );
  while( index !== -1 )
  {

    for( let i = 0 ; i < del.length ; i++ )
    if( src[ index+i ] !== del[ i ] )
    break;

    if( i === del.length )
    {
      result.push( src.slice( 0, index ) );
      result.push( src.slice( index, index+i ) );
      result.push( src.slice( index+i, src.length ) );
      return result;
    }
    else
    {
      index += 1;
    }

    index = src.indexOf( del[ 0 ], index );

  }

  result.push( null );
  result.push( null );
  result.push( src );

  return result;
}

//

function bufferIsolate_head( routine, args )
{
  let o;

  if( args.length > 1 )
  {
    if( args.length === 3 )
    o = { src : args[ 0 ], delimeter : args[ 1 ], times : args[ 2 ] };
    else if( args.length === 2 )
    o = { src : args[ 0 ], delimeter : args[ 1 ] };
    else
    o = { src : args[ 0 ] };
  }
  else
  {
    o = args[ 0 ];
    _.assert( args.length === 1, 'Expects single argument' );
  }

  _.routine.options( routine, o );
  _.assert( 1 <= args.length && args.length <= 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.bufferAnyIs( o.src ) || _.strIs( o.src ) );
  _.assert( _.bufferAnyIs( o.delimeter ) || _.strIs( o.delimeter ) );
  _.assert( _.number.is( o.times ) );

  return o;
}

//

function bufferIsolate_body( o )
{
  _.routine.assertOptions( bufferIsolate_body, arguments );

  let src = o.src;
  if( _.strIs( o.src ) )
  src = o.src = _.bufferBytesGet( o.src );
  if( !_.bufferTypedIs( o.src ) )
  src = _.bufferBytesGet( o.src );

  let delimeter = o.delimeter;
  if( _.strIs( o.delimeter ) || !_.bufferTypedIs( o.delimeter ) )
  delimeter = _.bufferBytesGet( o.delimeter );

  delimeter = _.bufferRetype( delimeter, src.constructor );

  _.assert( _.routine.is( src.indexOf ) );
  _.assert( _.routine.is( delimeter.indexOf ) );

  let result = [];
  let times = o.times;
  let index = o.left ? 0 : src.length;
  let more = o.left ? bufferLeft : bufferRight;

  /* */

  while( times > 0 )
  {
    index = more( index );

    if( index === -1 )
    break;

    times -= 1;

    if( times === 0 )
    {
      if( o.src.constructor === src.constructor )
      {
        let del = delimeter;
        result.push( o.src.subarray( 0, index ) );
        result.push( new o.src.constructor( del.buffer, del.byteOffset, del.byteLength / ( o.src.BYTES_PER_ELEMENT || 1 ) ) );
        result.push( o.src.subarray( index + delimeter.length ) );
      }
      else
      {
        if( o.src.constructor === BufferRaw )
        {
          result.push( o.src.slice( 0, index ) );
          result.push( delimeter.buffer.slice( delimeter.byteOffset, delimeter.byteOffset + delimeter.byteLength ) );
          result.push( o.src.slice( index + delimeter.length, src.byteLength ) );
        }
        else
        {
          let del = delimeter;
          result.push( new o.src.constructor( o.src.buffer, o.src.byteOffset, index ) );
          result.push( new o.src.constructor( del.buffer, del.byteOffset, del.byteLength / ( o.src.BYTES_PER_ELEMENT || 1 ) ) );
          let secondOffset = src.byteOffset + index * ( o.src.BYTES_PER_ELEMENT || 1 ) + delimeter.length;
          result.push( new o.src.constructor( o.src.buffer, secondOffset, o.src.byteOffset + src.byteLength - secondOffset ) );
        }
      }
      return result;
    }

    /* */

    if( o.left )
    {
      index = index + 1;
      if( index >= src.length )
      break;
    }
    else
    {
      index = index - 1;
      if( index <= 0 )
      break;
    }

  }

  /* */

  if( !result.length )
  {
    if( o.times === 0 )
    return everything( !o.left );
    else if( times === o.times )
    return everything( o.left ^ o.none );
    else
    return everything( o.left );
  }

  return result;

  /* */

  function everything( side )
  {
    let empty = new U8x( 0 ).buffer;
    return ( side ) ? [ o.src, undefined, new o.src.constructor( empty ) ] : [ new o.src.constructor( empty ), undefined, o.src ];
  }

  /* */

  function bufferLeft( index )
  {
    index = src.indexOf( delimeter[ 0 ], index );
    while( index !== -1 )
    {
      let i = 0;
      for( ; i < delimeter.length; i++ )
      if( src[ index + i ] !== delimeter[ i ] )
      break;

      if( i === delimeter.length )
      return index;

      index += 1;
      index = src.indexOf( delimeter[ 0 ], index );
    }
    return index;
  }

  /* */

  function bufferRight( index )
  {
    index = src.lastIndexOf( delimeter[ 0 ], index );
    while( index !== -1 )
    {
      let i = 0;
      for( ; i < delimeter.length; i++ )
      if( src[ index + i ] !== delimeter[ i ] )
      break;

      if( i === delimeter.length )
      return index;

      index -= 1;
      index = src.lastIndexOf( delimeter[ 0 ], index );
    }
    return index;
  }
}

bufferIsolate_body.defaults =
{
  src : null,
  delimeter : ' ',
  left : 1,
  times : 1,
  none : 1,
};

//

let bufferIsolate = _.routine.unite( bufferIsolate_head, bufferIsolate_body );

//

function bufferIsolateLeftOrNone_body( o )
{
  o.left = 1;
  o.none = 1;
  let result = _.bufferIsolate.body( o );
  return result;
}

bufferIsolateLeftOrNone_body.defaults =
{
  src : null,
  delimeter : ' ',
  times : 1,
};

let bufferIsolateLeftOrNone = _.routine.unite( bufferIsolate_head, bufferIsolateLeftOrNone_body );

//

function bufferIsolateLeftOrAll_body( o )
{
  o.left = 1;
  o.none = 0;
  let result = _.bufferIsolate.body( o );
  return result;
}

bufferIsolateLeftOrAll_body.defaults =
{
  src : null,
  delimeter : ' ',
  times : 1,
};

let bufferIsolateLeftOrAll = _.routine.unite( bufferIsolate_head, bufferIsolateLeftOrAll_body );

//

function bufferIsolateRightOrNone_body( o )
{
  o.left = 0;
  o.none = 1;
  let result = _.bufferIsolate.body( o );
  return result;
}

bufferIsolateRightOrNone_body.defaults =
{
  src : null,
  delimeter : ' ',
  times : 1,
};

let bufferIsolateRightOrNone = _.routine.unite( bufferIsolate_head, bufferIsolateRightOrNone_body );

//

function bufferIsolateRightOrAll_body( o )
{
  o.left = 0;
  o.none = 0;
  let result = _.bufferIsolate.body( o );
  return result;
}

bufferIsolateRightOrAll_body.defaults =
{
  src : null,
  delimeter : ' ',
  times : 1,
};

let bufferIsolateRightOrAll = _.routine.unite( bufferIsolate_head, bufferIsolateRightOrAll_body );

// --
// declaration
// --

let BufferExtension =
{
}

Object.assign( _.buffer, BufferExtension );

//

let ToolsExtension =
{

  bufferRelen, /* xxx : investigate */

  bufferBut_,
  bufferOnly_,
  bufferGrow_,
  bufferRelength_,
  bufferResize_,

  //

  // _bufferReusing_head,
  // _bufferReusing,
  bufferReusing4Arguments_head,
  bufferReusing3Arguments_head,
  _bufferElementSizeGet,
  _dstBufferSizeRecount,
  _bufferTypedViewMake,
  _resultBufferReusedMaybe,
  _resultBufferMake,
  bufferReusingBut,
  bufferReusingOnly,
  bufferReusingGrow,
  bufferReusingRelength,
  bufferReusingResize,

  //

  bufferBytesGet,
  bufferRetype,

  bufferJoin, /* qqq for Dmytro : look, analyze and cover _.longJoin */

  bufferMove,
  bufferToStr,
  bufferToDom, /* qqq for Dmytro : move out to DomTools */

  bufferLeft,
  bufferRight,
  bufferSplit,
  bufferCutOffLeft,

  bufferIsolate,
  bufferIsolateLeftOrNone,
  bufferIsolateLeftOrAll,
  bufferIsolateRightOrNone,
  bufferIsolateRightOrAll,

  // buffersSerialize, /* deprecated */
  // buffersDeserialize, /* deprecated */

  // to replace

  /*
  | routine           | makes new dst container                        | saves dst container                                        |
  | ----------------- | ---------------------------------------------- | ---------------------------------------------------------- |
  | bufferBut_        | _.bufferBut_( src, range )                     | _.bufferBut_( src )                                        |
  |                   | if src is not resizable and  change length     | _.bufferBut_( dst, dst )                                   |
  |                   | _.bufferBut_( null, src, range )               | _.bufferBut_( dst, dst, range ) if dst is resizable        |
  |                   | _.bufferBut_( dst, src, range )                | or dst not change length                                   |
  |                   | if dst not resizable and change length         | _.bufferBut_( dst, src, range ) if dst is resizable        |
  |                   |                                                | or dst not change length                                   |
  | ----------------- | ---------------------------------------------- | ---------------------------------------------------------- |
  | bufferOnly__    | _.bufferOnly__( src, range )                 | _.bufferOnly__( src )                                    |
  |                   | if src is not resizable and  change length     | _.bufferOnly__( dst, dst )                               |
  |                   | _.bufferOnly__( null, src, range )           | _.bufferOnly__( dst, dst, range ) if dst is resizable    |
  |                   | _.bufferOnly__( dst, src, range )            | or dst not change length                                   |
  |                   | if dst not resizable and change length         | _.bufferOnly__( dst, src, range ) if dst is resizable    |
  |                   |                                                | or dst not change length                                   |
  | ----------------- | ---------------------------------------------- | ---------------------------------------------------------- |
  | bufferGrow_       | _.bufferGrow_( src, range )                    | _.bufferGrow_( src )                                       |
  |                   | if src is not resizable and  change length     | _.bufferGrow_( dst, dst )                                  |
  |                   | _.bufferGrow_( null, src, range )              | _.bufferGrow_( dst, dst, range ) if dst is resizable       |
  |                   | _.bufferGrow_( dst, src, range )               | or dst not change length                                   |
  |                   | if dst not resizable and change length         | _.bufferGrow_( dst, src, range ) if dst is resizable       |
  |                   |                                                | or dst not change length                                   |
  | ----------------- | ---------------------------------------------- | ---------------------------------------------------------- |
  | bufferRelength_   | _.bufferRelength_( src, range )                | _.bufferRelength_( src )                                   |
  |                   | if src is not resizable and  change length     | _.bufferRelength_( dst, dst )                              |
  |                   | _.bufferRelength_( null, src, range )          | _.bufferRelength_( dst, dst, range ) if dst is resizable   |
  |                   | _.bufferRelength_( dst, src, range )           | or dst not change length                                   |
  |                   | if dst not resizable and change length         | _.bufferRelength_( dst, src, range ) if dst is resizable   |
  |                   |                                                | or dst not change length                                   |
  | ----------------- | ---------------------------------------------- | ---------------------------------------------------------- |
  | bufferResize_     | _.bufferResize_( null, src, size )             | _.bufferResize_( src, size )                               |
  | bufferResize_     | every time                                     | if src is not BufferRaw or buffer not changes length       |
  |                   | _.bufferResize_( src, size )                   | _.bufferResize_( dst, dst, size ) if buffer not changes    |
  |                   | if src is BufferRaw or buffer changes length   | _.bufferResize_( dst, src, size )                          |
  |                   | _.bufferResize_( dst, src, range )             | if dst.byteLength >= size                                  |
  |                   | if dst.byteLength < size                       |                                                            |
  | ----------------- | ---------------------------------------------- | ---------------------------------------------------------- |
  */

}

Object.assign( _, ToolsExtension );

})();

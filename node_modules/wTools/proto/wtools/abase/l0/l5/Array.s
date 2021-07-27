( function _l5_Array_s_()
{

'use strict';

const _ArrayIndexOf = Array.prototype.indexOf;
const _ArrayIncludes = Array.prototype.includes;
if( !_ArrayIncludes )
_ArrayIncludes = function( e ){ _ArrayIndexOf.call( this, e ) }

const _global = _global_;
const _ = _global_.wTools;

/*
               |  can grow   |  can shrink  |   range
grow                +                -         positive
select              -                +         positive
relength            +                +         positive
but                 -                +         negative
*/

/* array / long / buffer */
/* - / inplace */

/*

alteration Routines :

- array { Op } { Tense } { Second } { How }

alteration Op : [ Append , Prepend , Remove, Flatten ]        // operation
alteration Tense : [ - , ed ]                                 // what to return
alteration Second : [ -, element, array, array ]              // how to treat src arguments
alteration How : [ - , Once , OnceStrictly ]                  // how to treat repeats

~ 60 routines

*/

// --
// array checker
// --

function constructorLikeArray( src )
{
  if( !src )
  return false;

  if( src === Function )
  return false;
  if( src === Object )
  return false;
  if( src === String )
  return false;

  if( _.primitive.is( src ) )
  return false;

  if( !( 'length' in src.prototype ) )
  return false;
  if( Object.propertyIsEnumerable.call( src.prototype, 'length' ) )
  return false;

  return true;
}

// --
// array producer
// --

/**
 * The routine arrayFromCoercing() returns Array from provided argument {-src-}. The feature of routine is possibility of
 * converting an object-like {-src-} into Array. Also, routine longFromCoercing() converts string with number literals
 * to an Array.
 *
 * @param { Array|Long|ObjectLike|String } src - An instance to convert into Array.
 * If {-src-} is instance of Array, then routine converts not {-src-}.
 *
 * @example
 * let src = [ 3, 7, 13, 'abc', false, undefined, null, {} ];
 * let got = _.arrayFromCoercing( src );
 * // returns [ 3, 7, 13, 'abc', false, undefined, null, {} ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * let src = _.argumentsArray.make( [ 3, 7, 13, 'abc', false, undefined, null, {} ] );
 * let got = _.arrayFromCoercing( src );
 * // returns [ 3, 7, 13, 'abc', false, undefined, null, {} ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * let src = { a : 3, b : 7, c : 13 };
 * let got = _.arrayFromCoercing( src );
 * // returns [ [ 'a', 3 ], [ 'b', 7 ], [ 'c', 13 ] ]
 *
 * @example
 * let src = "3, 7, 13, 3.5abc, 5def, 7.5ghi, 13jkl";
 * let got = _.arrayFromCoercing( src );
 * // returns [ 3, 7, 13, 3.5, 5, 7.5, 13 ]
 *
 * @returns { Array } - Returns an Array. If {-src-} is Array instance, then routine returns original {-src-}.
 * @function arrayFromCoercing
 * @throws { Error } If {-src-} is not an Array, not a Long, not object-like, not a String.
 * @namespace Tools
 */

function arrayFromCoercing( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.arrayIs( src ) && !_.unrollIs( src ) )
  return src;

  if( _.longIs( src ) )
  return Array.prototype.slice.call( src );

  if( _.strIs( src ) )
  return this.arrayFromStr( src );

  if( _.object.isBasic( src ) )
  return _.props.pairs( src );

  _.assert( 0, 'Unknown data type : ' + _.entity.strType( src ) );
}

//

function arrayFromStr( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) );
  return src.split(/[, ]+/).map( ( s ) => s.length ? parseFloat( s ) : undefined );
}

// --
// array transformer
// --

function arrayExtendAppending( dst, src )
{

  _.assert( arguments.length === 2 );

  if( _.longIs( src ) )
  {

    if( dst === null || dst === undefined )
    dst = _.longSlice( src );
    else if( _.arrayIs( dst ) )
    dst = _.arrayAppendArray( dst, src );
    else if( _.longLike( dst ) )
    dst = _.arrayAppendArrays( null, [ dst, src ] );
    else
    dst = _.arrayAppendArray( [ dst ], src );

  }
  else
  {

    if( dst === null || dst === undefined )
    dst = [ src ];
    else if( _.arrayIs( dst ) )
    dst = _.arrayAppend( dst, src );
    else if( _.longLike( dst ) )
    dst = _.arrayAppendArrays( null, [ dst, src ] );
    else
    dst = _.arrayAppend( [ dst ], src );

  }

  return dst;
}

//

function arrayExtendPrepending( dst, src )
{

  _.assert( arguments.length === 2 );

  if( _.longIs( src ) )
  {

    if( dst === null || dst === undefined )
    dst = _.longSlice( src );
    else if( _.arrayIs( dst ) )
    dst = _.arrayPrependArray( dst, src );
    else if( _.longLike( dst ) )
    dst = _.arrayPrependArrays( null, [ dst, src ] );
    else
    dst = _.arrayPrependArray( [ dst ], src );

  }
  else
  {

    if( dst === null || dst === undefined )
    dst = [ src ];
    else if( _.arrayIs( dst ) )
    dst = _.arrayPrepend( dst, src );
    else if( _.longLike( dst ) )
    dst = _.arrayPrependArrays( null, [ dst, src ] );
    else
    dst = _.arrayPrepend( [ dst ], src );

  }

  return dst;
}

//

/**
 * The routine arrayBut() returns a shallow copy of provided array {-src-}. Routine removes existing
 * elements in bounds defined by {-range-} and insert new elements from {-ins-}. The original
 * source array {-src-} will not be modified.
 *
 * @param { Array|Unroll } src - The Array or Unroll from which makes a shallow copy.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for removing elements.
 * If {-range-} is number, then it defines the start index, and the end index is start index incremented by one.
 * If {-range-} is undefined, routine returns copy of {-src-}.
 * If range[ 0 ] < 0, then start index sets to 0.
 * If range[ 1 ] > src.length, end index sets to src.length.
 * If range[ 1 ] <= range[ 0 ], then routine removes not elements, the insertion of elements begins at start index.
 * @param { Long } ins - The Long with elements for insertion. Inserting begins at start index.
 * If quantity of removed elements is not equal to ins.length, then returned array will have length different to src.length.
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayBut( src );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayBut( src, 2, [ 'str' ] );
 * console.log( got );
 * // log [ 1, 2, 'str', 4, 5 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayBut( src, [ 1, 4 ], [ 'str' ] );
 * console.log( got );
 * // log [ 1, 'str', 5 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayBut( src, [ -5, 10 ], [ 'str' ] );
 * console.log( got );
 * // log [ 'str' ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayBut( src, [ 4, 1 ], [ 'str' ] );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 'str', 5 ]
 * console.log( got === src );
 * // log false
 *
 * @returns { Array|Unroll } Returns a copy of Array / Unroll with removed or replaced existing elements and / or added new elements.
 * @function arrayBut
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If argument {-src-} is not an array or unroll.
 * @throws { Error } If range.length is less or more then two.
 * @throws { Error } If range elements is not number / undefined.
 * @throws { Error } If argument {-ins-} is not Long / undefined.
 * @namespace Tools
 */

function arrayBut( src, range, ins )
{

  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( range === undefined )
  return _.array.make( src );

  if( _.number.is( range ) )
  range = [ range, range + 1 ];

  _.assert( _.arrayIs( src ) );
  _.assert( _.intervalIs( range ) );
  _.assert( ins === undefined || _.longLike( ins ) );

  _.ointerval.clamp/*rangeClamp*/( range, [ 0, src.length ] );
  if( range[ 1 ] < range[ 0 ] )
  range[ 1 ] = range[ 0 ];

  let args = [ range[ 0 ], range[ 1 ] - range[ 0 ] ];

  if( ins )
  _.arrayAppendArray( args, ins );

  let result = src.slice();

  result.splice.apply( result, args );

  return result;
}

//

/**
 * The routine arrayButInplace() returns a provided array {-src-} with removed existing elements in bounds
 * defined by {-range-} and inserted new elements from {-ins-}.
 *
 * @param { Array|Unroll } src - The Array or Unroll to remove, replace or add elements.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for removing elements.
 * If {-range-} is number, then it defines the start index, and the end index defines as start index incremented by one.
 * If {-range-} is undefined, routine returns {-src-}.
 * If range[ 0 ] < 0, then start index sets to 0.
 * If range[ 1 ] > src.length, end index sets to src.length.
 * If range[ 1 ] <= range[ 0 ], then routine removes no elements, the insertion of elements begins at start index.
 * @param { Long } ins - The Long with elements for insertion. Inserting begins at start index.
 * If quantity of removed elements is not equal to ins.length, then returned array will have length different to original src.length.
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayButInplace( src );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayButInplace( src, 2, [ 'str' ] );
 * console.log( got );
 * // log [ 1, 2, 'str', 4, 5 ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayButInplace( src, [ 1, 4 ], [ 'str' ] );
 * console.log( got );
 * // log [ 1, 'str', 5 ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayButInplace( src, [ -5, 10 ], [ 'str' ] );
 * console.log( got );
 * // log [ 'str' ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayButInplace( src, [ 4, 1 ], [ 'str' ] );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 'str', 5 ]
 * console.log( got === src );
 * // log true
 *
 * @returns { Array|Unroll } Returns original Array / Unroll with removed or replaced existing elements and / or added new elements.
 * @function arrayButInplace
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If argument {-src-} is not an array or unroll.
 * @throws { Error } If range.length is less or more then two.
 * @throws { Error } If range elements is not number / undefined.
 * @throws { Error } If argument {-ins-} is not Long / undefined.
 * @namespace Tools
 */

function arrayButInplace( src, range, ins )
{

  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( range === undefined )
  return src;

  if( _.number.is( range ) )
  range = [ range, range + 1 ];

  _.assert( _.arrayLikeResizable( src ) );
  _.assert( _.intervalIs( range ) );
  _.assert( ins === undefined || _.longLike( ins ) );

  _.ointerval.clamp( range, [ 0, src.length ] );
  if( range[ 1 ] < range[ 0 ] )
  range[ 1 ] = range[ 0 ];

  let args = [ range[ 0 ], range[ 1 ] - range[ 0 ] ];

  if( ins )
  {
    if( !Object.isExtensible( src ) && ins.length > range[ 1 ] - range[ 0 ] )
    _.assert( 0, 'Array is not resizable, cannot change length of array' );
    else
    _.arrayAppendArray( args, ins );
  }


  let result = src;

  result.splice.apply( result, args );

  return result;
}

//

function arrayBut_( /* dst, src, cinterval, ins */ )
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

  if( cinterval === undefined )
  {
    cinterval = [ 0, -1 ];
    ins = undefined;
  }
  else if( _.number.is( cinterval ) )
  {
    cinterval = [ cinterval, cinterval ];
  }

  _.assert( _.arrayIs( dst ) || dst === null, 'Expects {-dst-} of Array type or null' );
  _.assert( _.longIs( src ), 'Expects {-src-} of Array type' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );
  _.assert( _.longLike( ins ) || ins === undefined || ins === null, 'Expects long {-ins-} for insertion' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] !== undefined ? cinterval[ 0 ] : 0;
  let last = cinterval[ 1 ] = cinterval[ 1 ] !== undefined ? cinterval[ 1 ] : src.length - 1;

  if( first < 0 )
  first = 0;
  if( first > src.length )
  first = src.length;
  if( last > src.length - 1 )
  last = src.length - 1;

  if( last + 1 < first )
  last = first - 1;

  let delta = last - first + 1;
  let insLength = ins ? ins.length : 0;
  let delta2 = delta - insLength;
  let resultLength = src.length - delta2;

  let result = dst;
  if( dst === null )
  {
    result = _.array.makeUndefined( resultLength );
  }
  else if( dst === src )
  {
    if( !( ( dst.length === resultLength ) && delta === 0 ) )
    ins ? dst.splice( first, delta, ... ins ) : dst.splice( first, delta );
    return dst;
  }
  else if( dst.length !== resultLength )
  {
    if( dst.length < resultLength )
    _.assert( Object.isExtensible( result ), 'Expects extensible array {-dst-}' );
    dst.length = resultLength;
  }

  for( let i = 0 ; i < first ; i++ )
  result[ i ] = src[ i ];

  for( let i = last + 1 ; i < src.length ; i++ )
  result[ i - delta2 ] = src[ i ];

  if( ins )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    result[ first + i ] = ins[ i ];
  }

  return result;
}

//

/**
 * The routine arrayShrink() returns a copy of a portion of provided array {-src-} into a new array object
 * selected by {-range-}. The original {-src-} will not be modified.
 *
 * @param { Array|Unroll } src - The Array or Unroll from which makes a shallow copy.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
 * If {-range-} is number, then it defines the start index, and the end index sets to src.length.
 * If {-range-} is undefined, routine returns copy of {-src-}.
 * If range[ 0 ] < 0, then start index sets to 0.
 * If range[ 1 ] > src.length, end index sets to src.length.
 * If range[ 1 ] <= range[ 0 ], then routine returns empty array object.
 * @param { * } ins - The object of any type for insertion.
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrink( src );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrink( src, 2, 'str' );
 * console.log( got );
 * // log [ 3, 4, 5 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrink( src, [ 1, 4 ], 'str' );
 * console.log( got );
 * // log [ 2, 3, 4 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrink( src, [ -5, 10 ], 'str' );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrink( src, [ 4, 1 ], 'str' );
 * console.log( got );
 * // log []
 * console.log( got === src );
 * // log false
 *
 * @returns { Array|Unroll } Returns a copy of Array / Unroll containing the extracted elements.
 * @function arrayShrink
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If argument {-src-} is not an array or unroll.
 * @throws { Error } If range.length is less or more then two.
 * @throws { Error } If range elements is not number / undefined.
 * @namespace Tools
 */

function arrayShrink( src, range, ins )
{
  let result;

  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( range === undefined )
  return src.slice();

  if( _.number.is( range ) )
  range = [ range, src.length ];

  _.assert( _.arrayIs( src ) );
  _.assert( _.intervalIs( range ) );

  _.ointerval.clamp/*rangeClamp*/( range, [ 0, src.length ] );
  if( range[ 1 ] < range[ 0 ] )
  range[ 1 ] = range[ 0 ];

  if( range[ 0 ] === 0 && range[ 1 ] === src.length )
  return src.slice( src );

  result = _.array.makeUndefined( src, range[ 1 ]-range[ 0 ] );

  let f2 = Math.max( range[ 0 ], 0 );
  let l2 = Math.min( src.length, range[ 1 ] );
  for( let r = f2 ; r < l2 ; r++ )
  result[ r-range[ 0 ] ] = src[ r ];

  return result;
}

//

/**
 * The routine arrayShrinkInplace() returns a portion of provided array {-src-} selected by {-range-}.
 *
 * @param { Array|Unroll } src - The Array or Unroll from which selects elements.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
 * If {-range-} is number, then it defines the start index, and the end index sets to src.length.
 * If {-range-} is undefined, routine returns {-src-}.
 * If range[ 0 ] < 0, then start index sets to 0.
 * If range[ 1 ] > src.length, end index sets to src.length.
 * If range[ 1 ] <= range[ 0 ], then routine returns empty array object.
 * @param { * } ins - The object of any type for insertion.
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrinkInplace( src );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrinkInplace( src, 2, 'str' );
 * console.log( got );
 * // log [ 3, 4, 5 ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrinkInplace( src, [ 1, 4 ], 'str' );
 * console.log( got );
 * // log [ 2, 3, 4 ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrinkInplace( src, [ -5, 10 ], 'str' );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayShrinkInplace( src, [ 4, 1 ], 'str' );
 * console.log( got );
 * // log []
 * console.log( got === src );
 * // log true
 *
 * @returns { Array|Unroll } Returns a Array / Unroll containing the selected elements.
 * @function arrayShrinkInplace
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If argument {-src-} is not an array or unroll.
 * @throws { Error } If range.length is less or more then two.
 * @throws { Error } If range elements is not number / undefined.
 * @namespace Tools
 */

function arrayShrinkInplace( src, range, ins )
{

  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( range === undefined )
  return src;

  if( _.number.is( range ) )
  range = [ range, src.length ];

  _.assert( _.arrayIs( src ) );
  _.assert( _.intervalIs( range ) );

  _.ointerval.clamp/*rangeClamp*/( range, [ 0, src.length ] );
  if( range[ 1 ] < range[ 0 ] )
  range[ 1 ] = range[ 0 ];

  if( range[ 0 ] === 0 && range[ 1 ] === src.length )
  return src;

  let f2 = Math.max( range[ 0 ], 0 );
  let l2 = Math.min( src.length, range[ 1 ] );

  let result = src;

  result.splice.apply( result, [ 0, f2 ] );
  result.length = range[ 1 ] - range[ 0 ];

  return result;
}

//

function arrayShrink_( dst, src, cinterval )
{
  _.assert( 1 <= arguments.length && arguments.length <= 3, 'Expects not {-ins-} argument' );

  if( arguments.length < 3 && dst !== null && dst !== src )
  {
    dst = arguments[ 0 ];
    src = arguments[ 0 ];
    cinterval = arguments[ 1 ];
  }

  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval ];

  _.assert( _.arrayIs( dst ) || dst === null, 'Expects {-dst-} of Array type or null' );
  _.assert( _.arrayIs( src ), 'Expects {-src-} of Array type' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] !== undefined ? cinterval[ 0 ] : 0;
  let last = cinterval[ 1 ] = cinterval[ 1 ] !== undefined ? cinterval[ 1 ] : src.length - 1;

  if( first < 0 )
  first = 0;
  if( last > src.length - 1 )
  last = src.length - 1;

  if( last + 1 < first )
  last = first - 1;

  let first2 = Math.max( first, 0 );
  let last2 = Math.min( src.length - 1, last );

  let resultLength = last - first + 1;

  let result = dst;
  if( dst === null )
  {
    result = _.array.makeUndefined( resultLength );
  }
  else if( dst === src )
  {
    result.splice.apply( result, [ 0, first2 ] );
    result.length = resultLength;
    return result;
  }
  else if( dst.length < resultLength )
  {
    _.assert( Object.isExtensible( dst ), 'Array is not extensible, cannot change array' );
    result.length = resultLength;
  }

  for( let i = first2 ; i < last2 + 1 ; i++ )
  result[ i - first2 ] = src[ i ];

  return result;
}

//

/**
 * Routine arrayGrow() changes length of provided array {-src-} by copying it elements to newly created array
 * using range {-range-} positions of the original array and value to fill free space after copy {-ins-}.
 * Routine can only grows size of array.The original {-src-} will not be modified.
 *
 * @param { Array|Unroll } src - The Array or Unroll from which makes a shallow copy.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
 * If {-range-} is number, then it defines the end index, and the start index is 0.
 * If range[ 0 ] < 0, then start index sets to 0, end index incrementes by absolute value of range[ 0 ].
 * If range[ 0 ] > 0, then start index sets to 0.
 * If range[ 1 ] > src.length, end index sets to src.length.
 * If range[ 1 ] <= range[ 0 ], then routine returns copy of origin array.
 * @param { * } ins -  object of any type. Used to fill the space left after copying elements of the original array.
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src, 7, 'str' );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5, 'str', 'str' ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src, [ 1, 6 ], 'str' );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5, 'str' ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src, [ -5, 6 ], 7 );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5, 7, 7, 7, 7, 7, 7 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src, [ 4, 1 ], 'str' );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log false
 *
 * @returns { Array|Unroll } Returns a copy of Array / Unroll with changed length.
 * @function arrayGrow
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If argument {-src-} is not an array or unroll.
 * @throws { Error } If range.length is less or more then two.
 * @throws { Error } If range elements is not number / undefined.
 * @namespace Tools
 */

function arrayGrow( src, range, ins )
{
  let result;

  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( range === undefined )
  return src.slice();

  if( _.number.is( range ) )
  range = [ 0, range ];

  let f = range ? range[ 0 ] : undefined;
  let l = range ? range[ 1 ] : undefined;

  f = f !== undefined ? f : 0;
  l = l !== undefined ? l : src.length;

  _.assert( _.arrayIs( src ) );
  _.assert( _.intervalIs( range ) )

  if( l < f )
  l = f;

  if( f < 0 )
  {
    l -= f;
    f -= f;
  }

  if( f > 0 )
  f = 0;
  if( l < src.length )
  l = src.length;

  if( l === src.length )
  return src.slice();

  result = _.array.makeUndefined( src, l-f );

  let f2 = Math.max( f, 0 );
  let l2 = Math.min( src.length, l );
  for( let r = f2 ; r < l2 ; r++ )
  result[ r-f ] = src[ r ];

  if( ins !== undefined )
  {
    for( let r = l2 - f; r < result.length ; r++ )
    {
      result[ r ] = ins;
    }
  }

  return result;
}

//

/**
 * Routine arrayGrowInplace() changes length of provided array {-src-} using range {-range-} positions of the original
 * array and value to fill free space after copy {-ins-}. Routine can only grows size of array.
 *
 * @param { Array|Unroll } src - The Array or Unroll to grow length.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
 * If {-range-} is number, then it defines the end index, and the start index is 0.
 * If range[ 0 ] < 0, then start index sets to 0, end index incrementes by absolute value of range[ 0 ].
 * If range[ 0 ] > 0, then start index sets to 0.
 * If range[ 1 ] > src.length, end index sets to src.length.
 * If range[ 1 ] <= range[ 0 ], then routine returns copy of origin array.
 * @param { * } ins - The object of any type. Used to fill the space left of the original array.
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src, 7, 'str' );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5, 'str', 'str' ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src, [ 1, 6 ], 'str' );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5, 'str' ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src, [ -5, 6 ], 7 );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5, 7, 7, 7, 7, 7, 7 ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayGrow( src, [ 4, 1 ], 'str' );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log true
 *
 * @returns { Array|Unroll } Returns a provided Array / Unroll with changed length.
 * @function arrayGrowInplace
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If argument {-src-} is not an array or unroll.
 * @throws { Error } If range.length is less or more then two.
 * @throws { Error } If range elements is not number / undefined.
 * @namespace Tools
 */

function arrayGrowInplace( src, range, ins )
{

  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( range === undefined )
  return src;

  if( _.number.is( range ) )
  range = [ 0, range ];

  let f = range ? range[ 0 ] : undefined;
  let l = range ? range[ 1 ] : undefined;

  f = f !== undefined ? f : 0;
  l = l !== undefined ? l : src.length;

  _.assert( _.arrayIs( src ) );
  _.assert( _.intervalIs( range ) )

  if( f < 0 )
  {
    l -= f;
    f -= f;
  }

  if( l < f )
  l = f;

  if( f > 0 )
  f = 0;
  if( l < src.length )
  l = src.length;

  if( l === src.length )
  return src;

  if( !Object.isExtensible( src ) && src.length < l )
  _.assert( 0, 'Array is not extensible, cannot change length of array' );

  let resultLength = l - f;
  let f2 = Math.max( -range[ 0 ], 0 );
  let l2 = Math.min( src.length, l );
  l2 += f2;

  src.splice( f, 0, ... _.dup( ins, f2 ) );
  src.splice( l2, 0, ... _.dup( ins, resultLength <= l2 ? 0 : resultLength - l2 ) );
  return src;
}

//

function arrayGrow_( /* dst, src, cinterval, ins */ )
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

  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval - 1 ];

  _.assert( _.arrayIs( dst ) || dst === null, 'Expects {-dst-} of Array type or null' );
  _.assert( _.arrayIs( src ), 'Expects {-src-} of Array type' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );

  let f = cinterval[ 0 ] === undefined ?  0 : cinterval[ 0 ];
  let l = cinterval[ 1 ] === undefined ?  src.length - 1 : cinterval[ 1 ];

  if( f > 0 )
  f = 0;
  if( l < src.length - 1 )
  l = src.length - 1;

  if( f < 0 )
  {
    l -= f;
    f -= f;
  }

  if( l + 1 < f )
  l = f - 1;

  let f2 = Math.max( -cinterval[ 0 ], 0 );
  let l2 = Math.min( src.length - 1 + f2, l + f2 );

  let resultLength = l - f + 1;

  let result = dst;
  if( dst === null )
  {
    result = _.array.make( resultLength );
  }
  else if( dst === src )
  {
    if( dst.length === resultLength )
    return dst;

    _.assert( Object.isExtensible( dst ), 'Array is not extensible, cannot change array' );

    dst.splice( f, 0, ... _.dup( ins, f2 ) );
    dst.splice( l2 + 1, 0, ... _.dup( ins, resultLength <= l2 ? 0 : resultLength - l2 - 1 ) );
    return dst;
  }
  else if( dst.length < resultLength && !Object.isExtensible( dst ) )
  {
    _.assert( 0, 'Array is not extensible, cannot change array' );
  }

  for( let r = f2 ; r < l2 + 1 ; r++ )
  result[ r ] = src[ r - f2 ];

  if( ins !== undefined )
  {
    for( let r = 0 ; r < f2 ; r++ )
    result[ r ] = ins;

    for( let r = l2 + 1 ; r < resultLength ; r++ )
    result[ r ] = ins;
  }

  return result;
}

// function arrayGrow_( dst, src, range, ins )
// {
//
//   [ dst, src, range, ins ] = _argumentsOnlyArray.apply( this, arguments );
//
//   if( range === undefined )
//   return returnDst();
//
//   if( _.number.is( range ) )
//   range = [ 0, range ];
//   _.assert( _.intervalIs( range ) || _.number.is( range ) || range === undefined );
//
//   let f = range[ 0 ] === undefined ?  0 : range[ 0 ];
//   let l = range[ 1 ] === undefined ?  0 : range[ 1 ];
//
//   if( l < f )
//   l = f;
//
//   if( f < 0 )
//   {
//     l -= f;
//     f -= f;
//   }
//
//   if( f > 0 )
//   f = 0;
//   if( l < src.length )
//   l = src.length;
//
//   if( l === src.length )
//   return returnDst();
//
//   let l2 = src.length;
//
//   let result;
//   if( dst !== false )
//   {
//     if( dst.length !== undefined )
//     result = dst;
//     else
//     result = src.slice();
//
//     if( !Object.isExtensible( dst ) && dst.length < l - f )
//     _.assert( 0, 'Array is not extensible, cannot change array' );
//
//     for( let i = 0; i < l2; i++ )
//     result[ i ] = src[ i ];
//   }
//   else
//   {
//     if( !Object.isExtensible( src ) && src.length < l - f )
//     _.assert( 0, 'Array is not extensible, cannot change array' );
//
//     result = src;
//   }
//
//   result.length = l;
//
//   if( ins !== undefined )
//   {
//     for( let r = l2; r < result.length ; r++ )
//     result[ r ] = ins;
//   }
//
//   return result;
//
//   /* */
//
//   function returnDst()
//   {
//     if( dst.length !== undefined )
//     dst.splice( 0, dst.length, ... src );
//     else
//     dst = dst === true ? src.slice() : src;
//
//     return dst;
//   }
// }

//

/**
 * Routine arrayRelength() changes length of provided array {-src-} by copying it elements to newly created array object
 * using range (range) positions of the original array and value to fill free space after copy (val).
 * Routine can grows and reduces size of Long. The original {-src-} will not be modified.
 *
 * @param { Array|Unroll } src - The Array or Unroll from which makes a shallow copy.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
 * If {-range-} is number, then it defines the start index, and the end index sets to src.length.
 * If range[ 0 ] < 0, then start index sets to 0.
 * If range[ 1 ] <= range[ 0 ], then routine returns empty array.
 * @param { * } ins - The object of any type. Inserting begins from last index of {-src-} to end index.
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelength( src );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelength( src, 7, 'str' );
 * console.log( got );
 * // log []
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelength( src, [ 1, 6 ], 'str' );
 * console.log( got );
 * // log [ 2, 3, 4, 5, 'str' ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelength( src, [ -5, 6 ], 7 );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5, 7 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelength( src, [ 4, 1 ], 'str' );
 * console.log( got );
 * // log []
 * console.log( got === src );
 * // log false
 *
 * @returns { Array|Unroll } Returns a copy provided Array / Unroll with changed length.
 * @function arrayRelength
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If argument {-src-} is not an array or unroll.
 * @throws { Error } If range.length is less or more then two.
 * @throws { Error } If range elements is not number / undefined.
 * @namespace Tools
 */

function arrayRelength( src, range, ins )
{
  let result;

  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( range === undefined )
  return src.slice();

  if( _.number.is( range ) )
  range = [ range, src.length ];

  let f = range ? range[ 0 ] : undefined;
  let l = range ? range[ 1 ] : undefined;

  f = f !== undefined ? f : 0;
  l = l !== undefined ? l : src.length;

  _.assert( _.arrayIs( src ) );
  _.assert( _.intervalIs( range ) );

  if( l < f )
  l = f;

  if( f < 0 )
  f = 0;

  if( f === 0 && l === src.length )
  return src.slice( src );

  result = _.array.makeUndefined( src, l-f );

  let f2 = Math.max( f, 0 );
  let l2 = Math.min( src.length, l );
  for( let r = f2 ; r < l2 ; r++ )
  result[ r-f2 ] = src[ r ];

  if( ins !== undefined )
  {
    for( let r = l2 - f; r < result.length ; r++ )
    result[ r ] = ins;
  }

  return result;
}

//

/**
 * Routine arrayRelengthInplace() changes length of provided array {-src-} using range {-range-} positions of the original
 * array and value to fill free space after copy {-ins-}. Routine can grows and reduce size of Long.
 *
 * @param { Array|Unroll } src - The Array or Unroll to change length.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index of new array.
 * If {-range-} is number, then it defines the start index, and the end index sets to src.length.
 * If range[ 0 ] < 0, then start index sets to 0.
 * If range[ 1 ] <= range[ 0 ], then routine returns empty array.
 * @param { * } ins - The object of any type. Inserting begins from last index of {-src-} to end index.
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelengthInplace( src );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelengthInplace( src, 7, 'str' );
 * console.log( got );
 * // log []
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelengthInplace( src, [ 1, 6 ], 'str' );
 * console.log( got );
 * // log [ 2, 3, 4, 5, 'str' ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelengthInplace( src, [ -5, 6 ], 7 );
 * console.log( got );
 * // log [ 1, 2, 3, 4, 5, 7 ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * var src = [ 1, 2, 3, 4, 5 ];
 * var got = _.arrayRelengthInplace( src, [ 4, 1 ], 'str' );
 * console.log( got );
 * // log []
 * console.log( got === src );
 * // log false
 *
 * @returns { Array|Unroll } Returns a provided Array / Unroll with changed length.
 * @function arrayRelengthInplace
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If argument {-src-} is not an array or unroll.
 * @throws { Error } If range.length is less or more then two.
 * @throws { Error } If range elements is not number / undefined.
 * @namespace Tools
 */

function arrayRelengthInplace( src, range, ins )
{
  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( range === undefined )
  return src;

  if( _.number.is( range ) )
  range = [ range, src.length ];

  let f = range ? range[ 0 ] : undefined;
  let l = range ? range[ 1 ] : undefined;

  f = f !== undefined ? f : 0;
  l = l !== undefined ? l : src.length;

  _.assert( _.arrayIs( src ) );
  _.assert( _.intervalIs( range ) );

  if( l < f )
  l = f;

  if( f < 0 )
  f = 0;

  if( f === 0 && l === src.length )
  return src;

  if( !Object.isExtensible( src ) && src.length < l - f )
  _.assert( 0, 'Array is not extensible, cannot change length of array' );

  let f2 = Math.max( f, 0 );
  let l2 = Math.min( src.length, l );

  let result = src;

  result.splice.apply( result, [ 0, f ] );
  result.length = l - f;

  if( ins !== undefined )
  {
    for( let r = l2 - f; r < result.length ; r++ )
    result[ r ] = ins;
  }

  return result;
}

//

function arrayRelength_( /* dst, src, cinterval, ins */ )
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

  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval - 1 ];

  _.assert( _.arrayIs( dst ) || dst === null, 'Expects {-dst-} of Array type or null' );
  _.assert( _.arrayIs( src ), 'Expects {-src-} of Array type' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] !== undefined ? cinterval[ 0 ] : 0;
  let last = cinterval[ 1 ] = cinterval[ 1 ] !== undefined ? cinterval[ 1 ] : src.length - 1;

  if( last < first )
  last = first - 1;

  if( first < 0 )
  {
    last -= first;
    first -= first;
  }

  let first2 = Math.max( Math.abs( cinterval[ 0 ] ), 0 );
  let last2 = Math.min( src.length - 1, last );

  let resultLength = last - first + 1;

  let result = dst;
  if( dst === null )
  {
    result = _.array.makeUndefined( src, resultLength );
  }
  else if( dst === src )
  {
    if( dst.length === resultLength && cinterval[ 0 ] === 0 )
    {
      return dst;
    }
    if( resultLength === 0 )
    {
      return _.array.empty( dst );
    }

    if( dst.length < resultLength )
    _.assert( Object.isExtensible( dst ), 'dst is not extensible, cannot change dst' );

    if( cinterval[ 0 ] < 0 )
    {
      dst.splice( first, 0, ... _.dup( ins, first2 ) );
      dst.splice( last2 + 1, src.length - last2, ... _.dup( ins, last - last2 ) );
    }
    else
    {
      dst.splice( 0, first );
      dst.splice( last2 + 1 - first2, dst.length - last2, ... _.dup( ins, last - last2 ) );
    }
    return dst;
  }

  /* */

  if( result.length < resultLength )
  _.assert( Object.isExtensible( result ), 'dst is not extensible, cannot change dst' );

  if( resultLength === 0 )
  {
    return _.array.empty( result );
  }
  if( cinterval[ 0 ] < 0 )
  {
    result.splice( 0, first2, ... _.dup( ins, first2 ) );
    result.splice( first2, last2 - first2, ... src.slice( 0, last2 + 1 - first2 ) );
    result.splice( last2 + 1, result.length - last2, ... _.dup( ins, last - last2 ) );
  }
  else
  {
    result.splice( 0, last2 + 1, ... src.slice( first2, last2 + 1 ));
    result.splice( last2 + 1 - first2, result.length - last2, ... _.dup( ins, last - last2 ) );
  }

  return result;
}

// --
// array remove
// --

/**
 * ArrayRemove, arrayRemoveOnce, arrayRemoveOnceStrictly and arrayRemoved behave just like
 * arrayRemoveElement, arrayRemoveElementOnce, arrayRemoveElementOnceStrictly and arrayRemovedElement.
 */

function arrayRemove( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.arrayRemoved.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveOnce( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.arrayRemovedOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveOnceStrictly( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.arrayRemoveElementOnceStrictly.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoved( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let removedElements = _.arrayRemovedElement.apply( this, arguments );
  return removedElements;
}

//

/**
 * ArrayRemovedOnce and arrayRemovedOnceStrictly behave just like arrayRemovedElementOnce and arrayRemovedElementOnceStrictly,
 * but return the index of the removed element, instead of the removed element
 */

function arrayRemovedOnce( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let index = _.longLeftIndex.apply( _, arguments );
  if( index >= 0 )
  dstArray.splice( index, 1 );

  return index;
}

//

function arrayRemovedOnceStrictly( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let index = _.longLeftIndex.apply( _, arguments );
  if( index >= 0 )
  {
    dstArray.splice( index, 1 );
  }
  else _.assert( 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );

  let newIndex = _.longLeftIndex.apply( _, arguments );
  _.assert( newIndex < 0, () => 'The element ' + _.entity.exportStringDiagnosticShallow( ins ) + ' is several times in dstArray' );

  return index;
}

//

function arrayRemoveElement( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.arrayRemovedElement.apply( this, arguments );
  return dstArray;
}

//

/**
 * The arrayRemoveElementOnce() routine removes the first matching element from (dstArray)
 * that corresponds to the condition in the callback function and returns a modified array.
 *
 * It takes two (dstArray, ins) or three (dstArray, ins, onEvaluate) arguments,
 * checks if arguments passed two, it calls the routine
 * [arrayRemovedElementOnce( dstArray, ins )]{@link wTools.arrayRemovedElementOnce}
 * Otherwise, if passed three arguments, it calls the routine
 * [arrayRemovedElementOnce( dstArray, ins, onEvaluate )]{@link wTools.arrayRemovedElementOnce}
 * @see  wTools.arrayRemovedElementOnce
 * @param { Array } dstArray - The source array.
 * @param { * } ins - The value to remove.
 * @param { wTools~compareCallback } [ onEvaluate ] - The callback that compares (ins) with elements of the array.
 * By default, it checks the equality of two arguments.
 *
 * @example
 * _.arrayRemoveElementOnce( [ 1, 'str', 2, 3, 'str' ], 'str' );
 * // returns [ 1, 2, 3, 'str' ]
 *
 * @example
 * _.arrayRemoveElementOnce( [ 3, 7, 33, 13, 33 ], 13, function( el, ins ) {
 *   return el > ins;
 * });
 * // returns [ 3, 7, 13, 33 ]
 *
 * @returns { Array } - Returns the modified (dstArray) array with the new length.
 * @function arrayRemoveElementOnce
 * @throws { Error } If the first argument is not an array.
 * @throws { Error } If passed less than two or more than three arguments.
 * @throws { Error } If the third argument is not a function.
 * @namespace Tools
 */

function arrayRemoveElementOnce( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];
  _.arrayRemovedElementOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveElementOnceStrictly( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result;
  if( Config.debug )
  {
    let result = _.arrayRemovedElementOnce.apply( this, arguments );
    let index = _.longLeftIndex.apply( _, arguments );
    _.assert( index < 0 );
    _.assert( result >= 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );
  }
  else
  {
    let result = _.arrayRemovedElement.apply( this, [ dstArray, ins ] );
  }
  return dstArray;
}

/*
function arrayRemoveElementOnceStrictly( dstArray, ins, evaluator1, evaluator2 )
{
  let result = arrayRemovedElementOnce.apply( this, arguments );
  _.assert( result >= 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );
  return dstArray;
}
*/

//

function arrayRemovedElement( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let index = _.longLeftIndex.apply( this, arguments );
  let removedElements = 0;

  for( let i = 0; i < dstArray.length; i++ ) /* Dmytro : bad implementation, this cycle run routine longLeftIndex even if it not needs, better implementation commented below */
  {
    if( index !== -1 )
    {
      dstArray.splice( index, 1 );
      removedElements = removedElements + 1;
      i = i - 1 ;
    }
    index = _.longLeftIndex.apply( this, arguments ); /* Dmytro : this call uses not offset, it makes routine slower */
  }

  return removedElements;

  // let removedElements = 0;
  // let index = _.longLeftIndex.apply( this, arguments );
  // evaluator1 = _.number.is( evaluator1 ) ? undefined : evaluator1;
  //
  // while( index !== -1 )
  // {
  //   dstArray.splice( index, 1 );
  //   removedElements = removedElements + 1;
  //   index = _.longLeftIndex( dstArray, ins, index, evaluator1, evaluator2 );
  // }
  //
  // return removedElements;
}

//

function arrayRemovedElement_( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let removedElement;

  let index = _.longLeftIndex.apply( this, arguments );
  evaluator1 = _.number.is( evaluator1 ) ? undefined : evaluator1;

  if( index !== -1 )
  removedElement = dstArray[ index ];

  while( index !== -1 )
  {
    dstArray.splice( index, 1 );
    index = _.longLeftIndex( dstArray, ins, index, evaluator1, evaluator2 );
  }

  return removedElement;
}

//

/**
 * The callback function to compare two values.
 *
 * @callback wTools~compareCallback
 * @param { * } el - The element of the array.
 * @param { * } ins - The value to compare.
 */

/**
 * The arrayRemovedElementOnce() routine returns the index of the first matching element from (dstArray)
 * that corresponds to the condition in the callback function and remove this element.
 *
 * It takes two (dstArray, ins) or three (dstArray, ins, onEvaluate) arguments,
 * checks if arguments passed two, it calls built in function(dstArray.indexOf(ins))
 * that looking for the value of the (ins) in the (dstArray).
 * If true, it removes the value (ins) from (dstArray) array by corresponding index.
 * Otherwise, if passed three arguments, it calls the routine
 * [longLeftIndex( dstArray, ins, onEvaluate )]{@link wTools.longLeftIndex}
 * If callback function(onEvaluate) returns true, it returns the index that will be removed from (dstArray).
 * @see {@link wTools.longLeftIndex} - See for more information.
 *
 * @param { Array } dstArray - The source array.
 * @param { * } ins - The value to remove.
 * @param { wTools~compareCallback } [ onEvaluate ] - The callback that compares (ins) with elements of the array.
 * By default, it checks the equality of two arguments.
 *
 * @example
 * _.arrayRemovedElementOnce( [ 2, 4, 6 ], 4, function( el ) {
 *   return el;
 * });
 * // returns 1
 *
 * @example
 * _.arrayRemovedElementOnce( [ 2, 4, 6 ], 2 );
 * // returns 0
 *
 * @returns { Number } - Returns the index of the value (ins) that was removed from (dstArray).
 * @function arrayRemovedElementOnce
 * @throws { Error } If the first argument is not an array-like.
 * @throws { Error } If passed less than two or more than three arguments.
 * @throws { Error } If the third argument is not a function.
 * @namespace Tools
 */

function arrayRemovedElementOnce( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let index = _.longLeftIndex.apply( _, arguments );
  if( index >= 0 )
  dstArray.splice( index, 1 );

  return index;
  /* "!!! : breaking" */
  /* // arrayRemovedElementOnce should return the removed element
  let result;
  let index = _.longLeftIndex.apply( _, arguments );

  if( index >= 0 )
  {
    result = dstArray[ index ];
    dstArray.splice( index, 1 );
  }

  return result;
  */
}

//

function arrayRemovedElementOnce_( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let removedElement;
  let index = _.longLeftIndex.apply( _, arguments );
  if( index >= 0 )
  {
    removedElement = dstArray[ index ];
    dstArray.splice( index, 1 );
  }

  return removedElement;
}

//

function arrayRemovedElementOnceStrictly( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result;
  let index = _.longLeftIndex.apply( _, arguments );
  if( index >= 0 )
  {
    result = dstArray[ index ];
    dstArray.splice( index, 1 );
  }
  else _.assert( 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );

  index = _.longLeftIndex.apply( _, arguments );
  _.assert( index < 0, () => 'The element ' + _.entity.exportStringDiagnosticShallow( ins ) + ' is several times in dstArray' );

  return result;
}

//

function arrayRemovedElementOnceStrictly_( /* dstArray, ins, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let removedElement;
  let index = _.longLeftIndex.apply( _, arguments );
  if( index >= 0 )
  {
    removedElement = dstArray[ index ];
    dstArray.splice( index, 1 );
  }
  else _.assert( 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );

  index = _.longLeftIndex.apply( _, arguments );
  _.assert( index < 0, () => 'The element ' + _.entity.exportStringDiagnosticShallow( ins ) + ' is several times in dstArray' );

  return removedElement;
}

/*
function arrayRemovedElementOnceStrictly( dstArray, ins, evaluator1, evaluator2 )
{

  let result;
  let index = _.longLeftIndex.apply( _, arguments );
  if( index >= 0 )
  {
    result = dstArray[ index ];
    dstArray.splice( index, 1 );
  }
  else _.assert( 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );

  return result;
}
*/

//

function arrayRemoveArray( dstArray, insArray )
{
  arrayRemovedArray.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveArrayOnce( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  arrayRemovedArrayOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveArrayOnceStrictly( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result;
  if( Config.debug )
  {
    let insArrayLength = insArray.length;
    result = arrayRemovedArrayOnce.apply( this, arguments );
    let index = - 1;
    for( let i = 0, len = insArray.length; i < len ; i++ )
    {
      index = dstArray.indexOf( insArray[ i ] );
      _.assert( index < 0 );
    }
    _.assert( result === insArrayLength );

  }
  else
  {
    result = arrayRemovedArray.apply( this, [ dstArray, insArray ] );
  }
  return dstArray;
}

/*
function arrayRemoveArrayOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
{
  let result = arrayRemovedArrayOnce.apply( this, arguments );
  _.assert( result === insArray.length );
  return dstArray;
}
*/

//

function arrayRemovedArray( dstArray, insArray )
{
  _.assert( arguments.length === 2 )
  _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );
  _.assert( _.longLike( insArray ) );

  if( dstArray === insArray )
  return dstArray.splice( 0 ).length;

  let result = 0;
  let index = -1;

  for( let i = 0, len = insArray.length; i < len ; i++ )
  {
    index = dstArray.indexOf( insArray[ i ] );
    while( index !== -1 )
    {
      dstArray.splice( index, 1 );
      result += 1;
      index = dstArray.indexOf( insArray[ i ], index );
    }
  }

  return result;
}

//

/**
 * The callback function to compare two values.
 *
 * @callback arrayRemovedArrayOnce~onEvaluate
 * @param { * } el - The element of the (dstArray[n]) array.
 * @param { * } ins - The value to compare (insArray[n]).
 */

/**
 * The arrayRemovedArrayOnce() determines whether a (dstArray) array has the same values as in a (insArray) array,
 * and returns amount of the deleted elements from the (dstArray).
 *
 * It takes two (dstArray, insArray) or three (dstArray, insArray, onEqualize) arguments, creates variable (let result = 0),
 * checks if (arguments[..]) passed two, it iterates over the (insArray) array and calls for each element built in function(dstArray.indexOf(insArray[i])).
 * that looking for the value of the (insArray[i]) array in the (dstArray) array.
 * If true, it removes the value (insArray[i]) from (dstArray) array by corresponding index,
 * and incrementing the variable (result++).
 * Otherwise, if passed three (arguments[...]), it iterates over the (insArray) and calls for each element the routine
 *
 * If callback function(onEqualize) returns true, it returns the index that will be removed from (dstArray),
 * and then incrementing the variable (result++).
 *
 * @see wTools.longLeftIndex
 *
 * @param { longLike } dstArray - The target array.
 * @param { longLike } insArray - The source array.
 * @param { function } onEqualize - The callback function. By default, it checks the equality of two arguments.
 *
 * @example
 * _.arrayRemovedArrayOnce( [  ], [  ] );
 * // returns 0
 *
 * @example
 * _.arrayRemovedArrayOnce( [ 1, 2, 3, 4, 5 ], [ 6, 2, 7, 5, 8 ] );
 * // returns 2
 *
 * @example
 * _.arrayRemovedArrayOnce( [ 1, 2, 3, 4, 5 ], [ 6, 2, 7, 5, 8 ], function( a, b ) {
 *   return a < b;
 * } );
 * // returns 4
 *
 * @returns { number }  Returns amount of the deleted elements from the (dstArray).
 * @function arrayRemovedArrayOnce
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (insArray) is not an array-like.
 * @throws { Error } Will throw an Error if (arguments.length < 2  || arguments.length > 3).
 * @namespace Tools
 */

function arrayRemovedArrayOnce( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );
  _.assert( _.longLike( insArray ) );

  if( dstArray === insArray )
  if( arguments.length === 2 )
  return dstArray.splice( 0 ).length;

  let result = 0;
  let index = -1;

  for( let i = insArray.length - 1; i >= 0 ; i-- )
  {
    index = _.longLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 );

    if( index >= 0 )
    {
      dstArray.splice( index, 1 );
      result += 1;
    }
  }

  return result;
}

//

function arrayRemovedArrayOnceStrictly( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result;
  if( Config.debug )
  {
    let insArrayLength = insArray.length;
    result = arrayRemovedArrayOnce.apply( this, arguments );
    let index = - 1;
    for( let i = 0, len = insArray.length; i < len ; i++ )
    {
      index = dstArray.indexOf( insArray[ i ] );
      _.assert( index < 0 );
    }
    _.assert( result === insArrayLength );

  }
  else
  {
    result = arrayRemovedArray.apply( this, [ dstArray, insArray ] );
  }
  return result;
}

//

function arrayRemoveArrays( dstArray, insArray )
{
  arrayRemovedArrays.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveArraysOnce( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  arrayRemovedArraysOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveArraysOnceStrictly( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result;
  if( Config.debug )
  {
    let expected = 0;
    for( let i = insArray.length - 1; i >= 0; i-- )
    {
      if( _.longLike( insArray[ i ] ) )
      expected += insArray[ i ].length;
      else
      expected += 1;
    }

    result = arrayRemovedArraysOnce.apply( this, arguments );

    _.assert( result === expected );
    _.assert( arrayRemovedArraysOnce.apply( this, arguments ) === 0 );
  }
  else
  {
    result = arrayRemovedArrays.apply( this, [ dstArray, insArray ] );
  }

  return dstArray;
}

/*
function arrayRemoveArraysOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
{
  let result = arrayRemovedArraysOnce.apply( this, arguments );

  let expected = 0;
  for( let i = insArray.length - 1; i >= 0; i-- )
  {
    if( _.longLike( insArray[ i ] ) )
    expected += insArray[ i ].length;
    else
    expected += 1;
  }

  _.assert( result === expected );

  return dstArray;
}
*/

//

function arrayRemovedArrays( dstArray, insArray )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.arrayIs( dstArray ), 'arrayRemovedArrays :', 'Expects array' );
  _.assert( _.longLike( insArray ), 'arrayRemovedArrays :', 'Expects longLike entity' );

  let result = 0;

  if( dstArray === insArray )
  {
    result = insArray.length;
    dstArray.splice( 0 );
    return result;
  }

  function _remove( argument )
  {
    let index = dstArray.indexOf( argument );
    while( index !== -1 )
    {
      dstArray.splice( index, 1 );
      result += 1;
      index = dstArray.indexOf( argument, index );
    }
  }

  for( let a = insArray.length - 1; a >= 0; a-- )
  {
    if( _.longLike( insArray[ a ] ) )
    {
      let array = insArray[ a ];
      for( let i = array.length - 1; i >= 0; i-- )
      _remove( array[ i ] );
    }
    else
    {
      _remove( insArray[ a ] );
    }
  }

  return result;
}

//

function arrayRemovedArraysOnce( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ), 'arrayRemovedArraysOnce :', 'Expects array' );
  _.assert( _.longLike( insArray ), 'arrayRemovedArraysOnce :', 'Expects longLike entity' );

  let result = 0;

  if( dstArray === insArray )
  if( arguments.length === 2 )
  {
    result = insArray.length;
    dstArray.splice( 0 );
    return result;
  }

  function _removeOnce( argument )
  {
    let index = _.longLeftIndex( dstArray, argument, evaluator1, evaluator2 );
    if( index >= 0 )
    {
      dstArray.splice( index, 1 );
      result += 1;
    }
  }

  for( let a = insArray.length - 1; a >= 0; a-- )
  {
    if( _.longLike( insArray[ a ] ) )
    {
      let array = insArray[ a ];
      for( let i = array.length - 1; i >= 0; i-- )
      _removeOnce( array[ i ] );
    }
    else
    {
      _removeOnce( insArray[ a ] );
    }
  }

  return result;
}

//

function arrayRemovedArraysOnceStrictly( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result;
  if( Config.debug )
  {
    let expected = 0;
    for( let i = insArray.length - 1; i >= 0; i-- )
    {
      if( _.longLike( insArray[ i ] ) )
      expected += insArray[ i ].length;
      else
      expected += 1;
    }

    result = arrayRemovedArraysOnce.apply( this, arguments );

    _.assert( result === expected );
    _.assert( arrayRemovedArraysOnce.apply( this, arguments ) === 0 );
  }
  else
  {
    result = arrayRemovedArrays.apply( this, [ dstArray, insArray ] );
  }

  return result;
}

//

/**
 * The arrayRemoveDuplicates( dstArray, evaluator ) routine returns the dstArray with the duplicated elements removed.
 *
 * @param { ArrayIs } dstArray - The source and destination array.
 * @param { Function } [ evaluator = function( e ) { return e } ] - A callback function.
 *
 * @example
 * _.arrayRemoveDuplicates( [ 1, 1, 2, 'abc', 'abc', 4, true, true ] );
 * // returns [ 1, 2, 'abc', 4, true ]
 *
 * @example
 * _.arrayRemoveDuplicates( [ 1, 2, 3, 4, 5 ] );
 * // returns [ 1, 2, 3, 4, 5 ]
 *
 * @returns { Number } - Returns the source array without the duplicated elements.
 * @function arrayRemoveDuplicates
 * @throws { Error } If passed arguments is less than one or more than two.
 * @throws { Error } If the first argument is not an array.
 * @throws { Error } If the second argument is not a Function.
 * @namespace Tools
 */

function arrayRemoveDuplicates( dstArray, evaluator )
{
  _.assert( 1 <= arguments.length || arguments.length <= 2 );
  _.assert( _.arrayIs( dstArray ), 'Expects Array' );

  for( let i = 0 ; i < dstArray.length ; i++ )
  {
    let index;
    do
    {
      index = _.longRightIndex( dstArray, dstArray[ i ], evaluator );
      if( index !== i )
      {
        dstArray.splice( index, 1 );
      }
    }
    while( index !== i );
  }

  return dstArray;
}

/*
/*
function arrayRemoveDuplicates( dstArray, evaluator )
{
  _.assert( 1 <= arguments.length || arguments.length <= 2 );
  _.assert( _.arrayIs( dstArray ), 'arrayRemoveDuplicates :', 'Expects Array' );

  for( let i1 = 0 ; i1 < dstArray.length ; i1++ )
  {
    let element1 = dstArray[ i1 ];
    let index = _.longRightIndex( dstArray, element1, evaluator );

    while ( index !== i1 )
    {
      dstArray.splice( index, 1 );
      index = _.longRightIndex( dstArray, element1, evaluator );
    }
  }

  return dstArray;
}
*/

// --
// array flatten
// --

/**
 * The arrayFlatten() routine returns an array that contains all the passed arguments.
 *
 * It creates two variables the (result) - array and the {-srcMap-} - elements of array-like object (arguments[]),
 * iterate over array-like object (arguments[]) and assigns to the {-srcMap-} each element,
 * checks if {-srcMap-} is not equal to the 'undefined'.
 * If true, it adds element to the result.
 * If {-srcMap-} is an Array and if element(s) of the {-srcMap-} is not equal to the 'undefined'.
 * If true, it adds to the (result) each element of the {-srcMap-} array.
 * Otherwise, if {-srcMap-} is an Array and if element(s) of the {-srcMap-} is equal to the 'undefined' it throws an Error.
 *
 * @param {...*} arguments - One or more argument(s).
 *
 * @example
 * _.arrayFlatten( 'str', {}, [ 1, 2 ], 5, true );
 * // returns [ 'str', {}, 1, 2, 5, true ]
 *
 * @returns { Array } - Returns an array of the passed argument(s).
 * @function arrayFlatten
 * @throws { Error } If (arguments[...]) is an Array and has an 'undefined' element.
 * @namespace Tools
 */

function arrayFlatten( dstArray, insArray )
{
  if( dstArray === null )
  {
    dstArray = [];
    arguments[ 0 ] = dstArray;
  }

  _.arrayFlattened.apply( this, arguments );

  return dstArray;
}

//

function arrayFlattenOnce( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  if( dstArray === null )
  {
    dstArray = [];
    arguments[ 0 ] = dstArray;
  }

  _.arrayFlattenedOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayFlattenOnceStrictly( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.arrayFlattenedOnceStrictly.apply( this, arguments );
  return dstArray;
}

//

function arrayFlattened( dstArray, src )
{
  let result = 0;
  let length = dstArray.length;
  let visited = [];

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.object.isBasic( this ) );
  _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${dstArray}"` );

  if( arguments.length === 1 )
  {
    for( let i = 0 ; i < dstArray.length ; i++ )
    {
      let e = dstArray[ i ];
      if( _.longLike( e ) || _.set.like( e ) )
      {
        dstArray.splice( i, 1 );
        if( e !== dstArray )
        i = containerReplace( e, i );
        i -= 1;
      }
      else
      {
        result += 1;
      }
    }

    return result;
  }

  /*
  Dmytro : stack is unstable if dstArray.push( dstArray )
  */
  if( _.longHas( dstArray, dstArray ) )
  {
    let i = _.longLeftIndex( dstArray, dstArray );

    while( i !== -1 )
    {
      dstArray.splice( i, 1 );
      i = _.longLeftIndex( dstArray, dstArray );
    }
  }

  if( _.longLike( src ) || _.set.like( src ) )
  {
    containerAppend( src );
  }
  else
  {
    dstArray.push( src );
    result += 1;
  }

  return result;

  /* */

  function containerAppend( src )
  {
    if( _.longHas( visited, src ) )
    return;
    visited.push( src );

    let count;
    if( src === dstArray )
    count = length;
    else
    count = src.length;

    for( let e of src )
    {
      if( count < 1 )
      break;
      count--;

      if( _.longLike( e ) || _.set.like( e ) )
      {
        containerAppend( e )
      }
      else
      {
        dstArray.push( e );
        result += 1;
      }
    }

    visited.pop();
  }

  /* */

  function containerReplace( src, index )
  {
    for( let e of src )
    {
      if( _.longLike( e ) || _.set.like( e ) )
      {
        index = containerReplace( e, index );
      }
      else
      {
        dstArray.splice( index, 0, e );
        result += 1;
        index += 1;
      }
    }
    return index;
  }

}

//

function arrayFlattenedOnce( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result = 0;
  let length = dstArray.length;
  let visited = [];

  _.assert( arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );

  if( arguments.length === 1 )
  {
    _.arrayRemoveDuplicates( dstArray );

    for( let i = 0 ; i < dstArray.length ; i++ )
    {
      let e = dstArray[ i ];
      if( _.longLike( e ) || _.set.like( e ) )
      {
        dstArray.splice( i, 1 );
        if( e !== dstArray )
        i = containerReplace( e, i );
        i -= 1;
      }
      else
      {
        result += 1;
      }
    }

    return result;
  }

  if( _.longHas( dstArray, dstArray ) )
  {
    let i = _.longLeftIndex( dstArray, dstArray );

    while( i !== -1 )
    {
      dstArray.splice( i, 1 );
      i = _.longLeftIndex( dstArray, dstArray );
    }
  }

  if( _.longLike( insArray ) || _.set.like( insArray ) )
  {
    containerAppend( insArray );
  }
  else if( _.longLeftIndex( dstArray, insArray, evaluator1, evaluator2 ) === -1 )
  {
    dstArray.push( insArray );
    result += 1;
  }

  return result;

  /* */

  function containerAppend( src )
  {
    if( _.longHas( visited, src ) )
    return;
    visited.push( src );

    let count;
    if( src === dstArray )
    count = length;
    else
    count = src.length;


    for( let e of src )
    {
      if( count < 1 )
      break;
      count--;

      if( _.longLike( e ) || _.set.like( e ) )
      {
        containerAppend( e )
      }
      else if( _.longLeftIndex( dstArray, e, evaluator1, evaluator2 ) === -1 )
      {
        dstArray.push( e );
        result += 1;
      }
    }

    visited.pop();
  }

  /* */

  function containerReplace( src, index )
  {
    for( let e of src )
    {
      if( _.longLike( e ) || _.set.like( e ) )
      {
        index = containerReplace( e, index );
      }
      else if( _.longLeftIndex( dstArray, e ) === -1 )
      {
        dstArray.splice( index, 0, e );
        result += 1;
        index += 1;
      }
    }
    return index;
  }
}

// function arrayFlattenedOnce( dstArray, insArray, evaluator1, evaluator2 )
// {
//
//   _.assert( arguments.length && arguments.length <= 4 );
//   _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );
//
//   if( arguments.length === 1 )
//   {
//     _.arrayRemoveDuplicates( dstArray );
//
//     for( let i = dstArray.length-1; i >= 0; --i )
//     if( _.longLike( dstArray[ i ] ) )
//     {
//       let insArray = dstArray[ i ];
//       dstArray.splice( i, 1 );
//       onLongOnce( insArray, i );
//     }
//     return dstArray;
//   }
//
//   let result = 0;
//
//   if( _.longLike( insArray ) )
//   {
//     for( let i = 0, len = insArray.length; i < len; i++ )
//     {
//       _.assert( insArray[ i ] !== undefined, 'The Array should have no undefined' );
//       if( _.longLike( insArray[ i ] ) )
//       {
//         let c = _.arrayFlattenedOnce( dstArray, insArray[ i ], evaluator1, evaluator2 );
//         result += c;
//       }
//       else
//       {
//         let index = _.longLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 );
//         if( index === -1 )
//         {
//           dstArray.push( insArray[ i ] );
//           result += 1;
//         }
//       }
//     }
//   }
//   else
//   {
//
//     _.assert( insArray !== undefined, 'The Array should have no undefined' );
//
//     let index = _.longLeftIndex( dstArray, insArray, evaluator1, evaluator2 );
//     if( index === -1 )
//     {
//       dstArray.push( insArray );
//       result += 1;
//     }
//   }
//
//   return result;
//
//   /* */
//
//   function onLongOnce( insArray, insIndex )
//   {
//     for( let i = 0, len = insArray.length; i < len; i++ )
//     {
//       if( _.longLike( insArray[ i ] ) )
//       onLongOnce( insArray[ i ], insIndex )
//       else if( _.longLeftIndex( dstArray, insArray[ i ] ) === -1 )
//       dstArray.splice( insIndex++, 0, insArray[ i ] );
//     }
//   }
// }

//

function arrayFlattenedOnceStrictly( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result = 0;
  let visited = [];

  _.assert( arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );

  let oldLength = dstArray.length;
  _.arrayRemoveDuplicates( dstArray );
  let newLength = dstArray.length;
  if( Config.debug )
  _.assert( oldLength === newLength, 'Elements in dstArray must not be repeated' );

  if( arguments.length === 1 )
  {
    for( let i = 0 ; i < dstArray.length ; i++ )
    {
      let e = dstArray[ i ];
      if( _.longLike( e ) || _.set.like( e ) )
      {
        dstArray.splice( i, 1 );
        if( e !== dstArray )
        i = containerReplace( e, i );
        i -= 1;
      }
      else
      {
        result += 1;
      }
    }

    return result;
  }

  if( _.longHas( dstArray, dstArray ) )
  {
    let i = _.longLeftIndex( dstArray, dstArray );

    while( i !== -1 )
    {
      dstArray.splice( i, 1 );
      i = _.longLeftIndex( dstArray, dstArray );
    }
  }

  if( _.longLike( insArray ) || _.set.like( insArray ) )
  {
    containerAppend( insArray );
  }
  else if( _.longLeftIndex( dstArray, insArray, evaluator1, evaluator2 ) === -1 )
  {
    _.assert( insArray !== undefined, 'The container should be no undefined' );

    dstArray.push( insArray );
    result += 1;
  }
  else if( Config.debug )
  _.assert( 0, 'Elements must not be repeated' );

  return result;

  /* */

  function containerAppend( src )
  {
    if( _.longHas( visited, src ) )
    return;
    visited.push( src );

    let count;
    if( src === dstArray )
    count = oldLength;
    else
    count = src.length;


    for( let e of src )
    {
      if( count < 1 )
      break;
      count--;

      _.assert( e !== undefined, 'The container should have no undefined' );

      if( _.longLike( e ) || _.set.like( e ) )
      {
        containerAppend( e )
      }
      else if( _.longLeftIndex( dstArray, e, evaluator1, evaluator2 ) === -1 )
      {
        dstArray.push( e );
        result += 1;
      }
      else if( Config.debug )
      _.assert( 0, 'Elements must not be repeated' );

    }

    visited.pop();
  }

  /* */

  function containerReplace( src, index )
  {
    for( let e of src )
    {
      if( _.longLike( e ) || _.set.like( e ) )
      {
        index = containerReplace( e, index );
      }
      else if( _.longLeftIndex( dstArray, e ) === -1 )
      {
        dstArray.splice( index, 0, e );
        result += 1;
        index += 1;
      }
    }
    return index;
  }

}

// function arrayFlattenedOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
// {
//
//   _.assert( arguments.length && arguments.length <= 4 );
//   _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );
//
//   let oldLength = dstArray.length;
//   _.arrayRemoveDuplicates( dstArray );
//   let newLength = dstArray.length;
//   if( Config.debug )
//   _.assert( oldLength === newLength, 'Elements in dstArray must not be repeated' );
//
//
//   if( arguments.length === 1 )
//   {
//     for( let i = dstArray.length-1; i >= 0; --i )
//     if( _.longLike( dstArray[ i ] ) )
//     {
//       let insArray = dstArray[ i ];
//       dstArray.splice( i, 1 );
//       onLongOnce( insArray, i );
//     }
//     return dstArray;
//   }
//
//   let result = 0;
//
//   if( _.longLike( insArray ) )
//   {
//     for( let i = 0, len = insArray.length; i < len; i++ )
//     {
//       _.assert( insArray[ i ] !== undefined, 'The Array should have no undefined' );
//       if( _.longLike( insArray[ i ] ) )
//       {
//         let c = _.arrayFlattenedOnceStrictly( dstArray, insArray[ i ], evaluator1, evaluator2 );
//         result += c;
//       }
//       else
//       {
//         let index = _.longLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 );
//         if( Config.debug )
//         _.assert( index === -1, 'Elements must not be repeated' );
//
//         if( index === -1 )
//         {
//           dstArray.push( insArray[ i ] );
//           result += 1;
//         }
//       }
//     }
//   }
//   else
//   {
//     _.assert( insArray !== undefined, 'The Array should have no undefined' );
//     let index = _.longLeftIndex( dstArray, insArray, evaluator1, evaluator2 );
//     if( Config.debug )
//     _.assert( index === -1, 'Elements must not be repeated' );
//
//     if( index === -1 )
//     {
//       dstArray.push( insArray );
//       result += 1;
//     }
//   }
//
//   return result;
//
//   /* */
//
//   function onLongOnce( insArray, insIndex )
//   {
//     for( let i = 0, len = insArray.length; i < len; i++ )
//     {
//       if( _.longLike( insArray[ i ] ) )
//       onLongOnce( insArray[ i ], insIndex )
//       else if( _.longLeftIndex( dstArray, insArray[ i ] ) === -1 )
//       dstArray.splice( insIndex++, 0, insArray[ i ] );
//       else if( Config.debug )
//       _.assert( _.longLeftIndex( dstArray, insArray[ i ] ) === -1, 'Elements must not be repeated' );
//     }
//   }
// }

//

function arrayFlattenDefined( dstArray, insArray )
{
  if( dstArray === null )
  {
    dstArray = [];
    arguments[ 0 ] = dstArray;
  }

  arrayFlattenedDefined.apply( this, arguments );

  return dstArray;
}

//

function arrayFlattenDefinedOnce( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  if( dstArray === null )
  {
    dstArray = [];
    arguments[ 0 ] = dstArray;
  }

  arrayFlattenedDefinedOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayFlattenDefinedOnceStrictly( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  arrayFlattenedDefinedOnceStrictly.apply( this, arguments );
  return dstArray;
}

//

function arrayFlattenedDefined( dstArray, src )
{
  let result = 0;
  let length = dstArray.length;
  let visited = [];

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.object.isBasic( this ) );
  _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );

  if( arguments.length === 1 )
  {
    for( let i = 0 ; i < dstArray.length ; i++ )
    {
      let e = dstArray[ i ];

      if( e === undefined )
      {
        dstArray.splice( i, 1 );
        i -= 1;
      }
      else if( _.longLike( e ) || _.set.like( e ) )
      {
        dstArray.splice( i, 1 );
        if( e !== dstArray )
        i = containerReplace( e, i );
        i -= 1;
      }
      else
      {
        result += 1;
      }
    }

    return result;
  }

  if( _.longHas( dstArray, dstArray ) )
  {
    let i = _.longLeftIndex( dstArray, dstArray );

    while( i !== -1 )
    {
      dstArray.splice( i, 1 );
      i = _.longLeftIndex( dstArray, dstArray );
    }
  }

  if( _.longLike( src ) || _.set.like( src ) )
  {
    containerAppend( src );
  }
  else if( src !== undefined )
  {
    dstArray.push( src );
    result += 1;
  }

  return result;

  /* */

  function containerAppend( src )
  {
    if( _.longHas( visited, src ) )
    return;
    visited.push( src );

    let count;
    if( src === dstArray )
    count = length;
    else
    count = src.length;

    for( let e of src )
    {
      if( count < 1 )
      break;
      count--;

      if( _.longLike( e ) || _.set.like( e ) )
      {
        containerAppend( e )
      }
      else
      {
        if( e !== undefined )
        {
          dstArray.push( e );
          result += 1;
        }
      }
    }

    visited.pop();
  }

  /* */

  function containerReplace( src, index )
  {
    for( let e of src )
    {
      if( _.longLike( e ) || _.set.like( e ) )
      {
        index = containerReplace( e, index );
      }
      else
      {
        if( e !== undefined )
        {
          dstArray.splice( index, 0, e );
          result += 1;
          index += 1;
        }
      }
    }
    return index;
  }

}

// function arrayFlattenedDefined( dstArray, insArray )
// {
//
//   _.assert( arguments.length >= 1 );
//   _.assert( _.object.isBasic( this ) );
//   _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );
//
//   if( arguments.length === 1 )
//   {
//     for( let i = dstArray.length-1; i >= 0; --i )
//     if( _.longLike( dstArray[ i ] ) )
//     {
//       let insArray = dstArray[ i ];
//       dstArray.splice( i, 1 );
//       onLong( insArray, i );
//     }
//     return dstArray;
//   }
//
//   let result = 0;
//
//   for( let a = 1 ; a < arguments.length ; a++ )
//   {
//     let insArray = arguments[ a ];
//
//     if( _.longLike( insArray ) )
//     {
//       for( let i = 0, len = insArray.length; i < len; i++ )
//       {
//         if( _.longLike( insArray[ i ] ) )
//         {
//           let c = _.arrayFlattenedDefined( dstArray, insArray[ i ] );
//           result += c;
//         }
//         else
//         {
//           // _.assert( insArray[ i ] !== undefined, 'The Array should have no undefined' );
//           if( insArray[ i ] !== undefined )
//           {
//             dstArray.push( insArray[ i ] );
//             result += 1;
//           }
//         }
//       }
//     }
//     else
//     {
//       _.assert( insArray !== undefined, 'The Array should have no undefined' );
//       if( insArray !== undefined )
//       {
//         dstArray.push( insArray );
//         result += 1;
//       }
//     }
//
//   }
//
//   return result;
//
//   /* */
//
//   function onLong( insArray, insIndex )
//   {
//     for( let i = 0, len = insArray.length; i < len; i++ )
//     {
//       if( _.longLike( insArray[ i ] ) )
//       onLong( insArray[ i ], insIndex )
//       else
//       dstArray.splice( insIndex++, 0, insArray[ i ] );
//     }
//   }
//
// }

//

function arrayFlattenedDefinedOnce( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result = 0;
  let length = dstArray.length;
  let visited = [];

  _.assert( arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );

  if( arguments.length === 1 )
  {
    _.arrayRemoveDuplicates( dstArray );

    for( let i = 0 ; i < dstArray.length ; i++ )
    {
      let e = dstArray[ i ];
      if( e === undefined )
      {
        dstArray.splice( i, 1 );
        i -= 1;
      }
      else if( _.longLike( e ) || _.set.like( e ) )
      {
        dstArray.splice( i, 1 );
        if( e !== dstArray )
        i = containerReplace( e, i );
        i -= 1;
      }
      else
      {
        result += 1;
      }
    }

    return result;
  }

  if( _.longHas( dstArray, dstArray ) )
  {
    let i = _.longLeftIndex( dstArray, dstArray );

    while( i !== -1 )
    {
      dstArray.splice( i, 1 );
      i = _.longLeftIndex( dstArray, dstArray );
    }
  }

  if( _.longLike( insArray ) || _.set.like( insArray ) )
  {
    containerAppend( insArray );
  }
  else if( insArray !== undefined )
  {
    if( _.longLeftIndex( dstArray, insArray, evaluator1, evaluator2 ) === -1)
    {
      dstArray.push( insArray );
      result += 1;
    }
  }

  return result;

  /* */

  function containerAppend( src )
  {
    if( _.longHas( visited, src ) )
    return;
    visited.push( src );

    let count;
    if( src === dstArray )
    count = length;
    else
    count = src.length;


    for( let e of src )
    {
      if( count < 1 )
      break;
      count--;

      if( _.longLike( e ) || _.set.like( e ) )
      {
        containerAppend( e )
      }
      else if( e !== undefined )
      {
        if( _.longLeftIndex( dstArray, e, evaluator1, evaluator2 ) === -1 )
        {
          dstArray.push( e );
          result += 1;
        }
      }
    }

    visited.pop();
  }

  /* */

  function containerReplace( src, index )
  {
    for( let e of src )
    {
      if( _.longLike( e ) || _.set.like( e ) )
      {
        index = containerReplace( e, index );
      }
      else if( e !== undefined )
      {
        if( _.longLeftIndex( dstArray, e ) === -1 )
        {
          dstArray.splice( index, 0, e );
          result += 1;
          index += 1;
        }
      }
    }
    return index;
  }
}

// function arrayFlattenedDefinedOnce( dstArray, insArray, evaluator1, evaluator2 )
// {
//
//   _.assert( arguments.length && arguments.length <= 4 );
//   _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );
//
//   if( arguments.length === 1 )
//   {
//     _.arrayRemoveDuplicates( dstArray );
//
//     for( let i = dstArray.length-1; i >= 0; --i )
//     if( _.longLike( dstArray[ i ] ) )
//     {
//       let insArray = dstArray[ i ];
//       dstArray.splice( i, 1 );
//       onLongOnce( insArray, i );
//     }
//     return dstArray;
//   }
//
//   let result = 0;
//
//   if( _.longLike( insArray ) )
//   {
//     for( let i = 0, len = insArray.length; i < len; i++ )
//     {
//       _.assert( insArray[ i ] !== undefined );
//       if( _.longLike( insArray[ i ] ) )
//       {
//         let c = _.arrayFlattenedDefinedOnce( dstArray, insArray[ i ], evaluator1, evaluator2 );
//         result += c;
//       }
//       else
//       {
//         let index = _.longLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 );
//         if( index === -1 )
//         {
//           dstArray.push( insArray[ i ] );
//           result += 1;
//         }
//       }
//     }
//   }
//   else if( insArray !== undefined )
//   {
//
//     let index = _.longLeftIndex( dstArray, insArray, evaluator1, evaluator2 );
//     if( index === -1 )
//     {
//       dstArray.push( insArray );
//       result += 1;
//     }
//   }
//
//   return result;
//
//   /* */
//
//   function onLongOnce( insArray, insIndex )
//   {
//     for( let i = 0, len = insArray.length; i < len; i++ )
//     {
//       if( _.longLike( insArray[ i ] ) )
//       onLongOnce( insArray[ i ], insIndex )
//       else if( _.longLeftIndex( dstArray, insArray[ i ] ) === -1 )
//       dstArray.splice( insIndex++, 0, insArray[ i ] );
//     }
//   }
//
// }

//

function arrayFlattenedDefinedOnceStrictly( /* dstArray, insArray, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let insArray = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let result = 0;
  let visited = [];

  _.assert( arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );

  let oldLength = dstArray.length;
  _.arrayRemoveDuplicates( dstArray );
  let newLength = dstArray.length;
  if( Config.debug )
  _.assert( oldLength === newLength, 'Elements in dstArray must not be repeated' );

  if( arguments.length === 1 )
  {
    for( let i = 0 ; i < dstArray.length ; i++ )
    {
      let e = dstArray[ i ];
      if( e === undefined )
      {
        dstArray.splice( i, 1 );
        i -= 1;
      }
      else if( _.longLike( e ) || _.set.like( e ) )
      {
        dstArray.splice( i, 1 );
        if( e !== dstArray )
        i = containerReplace( e, i );
        i -= 1;
      }
      else
      {
        result += 1;
      }
    }

    return result;
  }

  if( _.longHas( dstArray, dstArray ) )
  {
    let i = _.longLeftIndex( dstArray, dstArray );

    while( i !== -1 )
    {
      dstArray.splice( i, 1 );
      i = _.longLeftIndex( dstArray, dstArray );
    }
  }

  if( _.longLike( insArray ) || _.set.like( insArray ) )
  {
    containerAppend( insArray );
  }
  else if( insArray !== undefined )
  {
    if( _.longLeftIndex( dstArray, insArray, evaluator1, evaluator2 ) === -1 )
    {
      dstArray.push( insArray );
      result += 1;
    }
    else if( Config.debug )
    _.assert( 0, 'Elements must not be repeated' );
  }

  return result;

  /* */

  function containerAppend( src )
  {
    if( _.longHas( visited, src ) )
    return;
    visited.push( src );

    let count;
    if( src === dstArray )
    count = oldLength;
    else
    count = src.length;


    for( let e of src )
    {
      if( count < 1 )
      break;
      count--;

      if( _.longLike( e ) || _.set.like( e ) )
      {
        containerAppend( e )
      }
      else if( e !== undefined )
      {
        if( _.longLeftIndex( dstArray, e, evaluator1, evaluator2 ) === -1 )
        {
          dstArray.push( e );
          result += 1;
        }
        else if( Config.debug )
        _.assert( 0, 'Elements must not be repeated' );
      }
    }

    visited.pop();
  }

  /* */

  function containerReplace( src, index )
  {
    for( let e of src )
    {
      if( _.longLike( e ) || _.set.like( e ) )
      {
        index = containerReplace( e, index );
      }
      else if( e !== undefined )
      {
        if( _.longLeftIndex( dstArray, e ) === -1 )
        {
          dstArray.splice( index, 0, e );
          result += 1;
          index += 1;
        }
        else if( Config.debug )
        _.assert( 0, 'Elements must not be repeated' );
      }
    }
    return index;
  }

}

// function arrayFlattenedDefinedOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
// {
//
//   _.assert( arguments.length && arguments.length <= 4 );
//   _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );
//
//   let oldLength = dstArray.length;
//   _.arrayRemoveDuplicates( dstArray );
//   let newLength = dstArray.length;
//   if( Config.debug )
//   _.assert( oldLength === newLength, 'Elements in dstArray must not be repeated' );
//
//
//   if( arguments.length === 1 )
//   {
//     for( let i = dstArray.length-1; i >= 0; --i )
//     if( _.longLike( dstArray[ i ] ) )
//     {
//       let insArray = dstArray[ i ];
//       dstArray.splice( i, 1 );
//       onLongOnce( insArray, i );
//     }
//     return dstArray;
//   }
//
//   let result = 0;
//
//   if( _.longLike( insArray ) )
//   {
//     for( let i = 0, len = insArray.length; i < len; i++ )
//     {
//       // _.assert( insArray[ i ] !== undefined );
//       if( insArray[ i ] === undefined )
//       {
//       }
//       else if( _.longLike( insArray[ i ] ) )
//       {
//         let c = _.arrayFlattenedDefinedOnceStrictly( dstArray, insArray[ i ], evaluator1, evaluator2 );
//         result += c;
//       }
//       else
//       {
//         let index = _.longLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 );
//         if( Config.debug )
//         _.assert( index === -1, 'Elements must not be repeated' );
//         if( index === -1 )
//         {
//           dstArray.push( insArray[ i ] );
//           result += 1;
//         }
//       }
//     }
//   }
//   else if( insArray !== undefined )
//   {
//
//     let index = _.longLeftIndex( dstArray, insArray, evaluator1, evaluator2 );
//     if( Config.debug )
//     _.assert( index === -1, 'Elements must not be repeated' );
//
//     if( index === -1 )
//     {
//       dstArray.push( insArray );
//       result += 1;
//     }
//   }
//
//   return result;
//
//   /* */
//
//   function onLongOnce( insArray, insIndex )
//   {
//     for( let i = 0, len = insArray.length; i < len; i++ )
//     {
//       if( _.longLike( insArray[ i ] ) )
//       onLongOnce( insArray[ i ], insIndex )
//       else if( _.longLeftIndex( dstArray, insArray[ i ] ) === -1 )
//       dstArray.splice( insIndex++, 0, insArray[ i ] );
//       else if( Config.debug )
//       _.assert( _.longLeftIndex( dstArray, insArray[ i ] ) === -1, 'Elements must not be repeated' );
//     }
//   }
// }

// --
// array replace
// --

//

function arrayReplace( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  let index = -1;
  let result = 0;

  index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );

  while( index !== -1 )
  {
    dstArray.splice( index, 1, sub );
    result += 1;
    index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );
  }

  return dstArray;
}

/**
 * The arrayReplaceOnce() routine returns the index of the (dstArray) array which will be replaced by (sub),
 * if (dstArray) has the value (ins).
 *
 * It takes three arguments (dstArray, ins, sub), calls built in function(dstArray.indexOf(ins)),
 * that looking for value (ins) in the (dstArray).
 * If true, it replaces (ins) value of (dstArray) by (sub) and returns the index of the (ins).
 * Otherwise, it returns (-1) index.
 *
 * @param { Array } dstArray - The source array.
 * @param { * } ins - The value to find.
 * @param { * } sub - The value to replace.
 *
 * @example
 * _.arrayReplaceOnce( [ 2, 4, 6, 8, 10 ], 12, 14 );
 * // returns -1
 *
 * @example
 * _.arrayReplaceOnce( [ 1, undefined, 3, 4, 5 ], undefined, 2 );
 * // returns 1
 *
 * @example
 * _.arrayReplaceOnce( [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ], 'Dmitry', 'Bob' );
 * // returns 3
 *
 * @example
 * _.arrayReplaceOnce( [ true, true, true, true, false ], false, true );
 * // returns 4
 *
 * @returns { number }  Returns the index of the (dstArray) array which will be replaced by (sub),
 * if (dstArray) has the value (ins).
 * @function arrayReplaceOnce
 * @throws { Error } Will throw an Error if (dstArray) is not an array.
 * @throws { Error } Will throw an Error if (arguments.length) is less than three.
 * @namespace Tools
 */

function arrayReplaceOnce( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  arrayReplacedOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayReplaceOnceStrictly( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result;
  if( Config.debug )
  {
    result = arrayReplacedOnce.apply( this, arguments );
    _.assert( result >= 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );
    result = arrayReplacedOnce.apply( this, arguments );
    _.assert( result < 0, () => 'The element ' + _.entity.exportStringDiagnosticShallow( ins ) + 'is several times in dstArray' );
  }
  else
  {
    result = arrayReplacedOnce.apply( this, arguments );
  }
  return dstArray;
}

/*
function arrayReplaceOnceStrictly( dstArray, ins, sub, evaluator1, evaluator2 )
{
  let result = arrayReplacedOnce.apply( this, arguments );
  _.assert( result >= 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );
  return dstArray;
}
*/

//

function arrayReplaced( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  let index = -1;
  let result = 0;

  index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );

  while( index !== -1 )
  {
    dstArray.splice( index, 1, sub );
    result += 1;
    index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );
  }

  return result;
}

//

function arrayReplacedOnce( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  if( _.longLike( ins ) )
  {
    _.assert( _.longLike( sub ) );
    _.assert( ins.length === sub.length );
  }

  let index = -1;

  index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );

  if( index >= 0 )
  dstArray.splice( index, 1, sub );

  return index;
}

//

function arrayReplacedOnceStrictly( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result;
  if( Config.debug )
  {
    result = arrayReplacedOnce.apply( this, arguments );
    _.assert( result >= 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );
    let newResult = arrayReplacedOnce.apply( this, arguments );
    _.assert( newResult < 0, () => 'The element ' + _.entity.exportStringDiagnosticShallow( ins ) + 'is several times in dstArray' );
  }
  else
  {
    result = arrayReplacedOnce.apply( this, arguments );
  }

  return result;
}

//

function arrayReplaceElement( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  let index = -1;
  let result = 0;

  index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );

  while( index !== -1 )
  {
    dstArray.splice( index, 1, sub );
    result += 1;
    index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );
  }

  return dstArray;
}

//

function arrayReplaceElementOnce( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  arrayReplacedElementOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayReplaceElementOnceStrictly( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result;
  if( Config.debug )
  {
    result = arrayReplacedElementOnce.apply( this, arguments );
    _.assert( result !== undefined, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );
    result = arrayReplacedElementOnce.apply( this, arguments );
    _.assert( result === undefined, () => 'The element ' + _.entity.exportStringDiagnosticShallow( ins ) + 'is several times in dstArray' );
  }
  else
  {
    result = arrayReplacedElementOnce.apply( this, arguments );
  }
  return dstArray;
}

//

function arrayReplacedElement( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  let index = -1;
  let result = 0;

  index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );

  while( index !== -1 )
  {
    dstArray.splice( index, 1, sub );
    result += 1;
    index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );
  }

  return result;
}

//

function arrayReplacedElementOnce( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  if( _.longLike( ins ) )
  {
    _.assert( _.longLike( sub ) );
    _.assert( ins.length === sub.length );
  }

  let index = -1;

  index = _.longLeftIndex( dstArray, ins, evaluator1, evaluator2 );

  if( index >= 0 )
  dstArray.splice( index, 1, sub );
  else
  return undefined;

  return ins;
}

//

function arrayReplacedElementOnceStrictly( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result;
  if( Config.debug )
  {
    result = arrayReplacedElementOnce.apply( this, arguments );
    _.assert( result !== undefined, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );
    let newResult = arrayReplacedElementOnce.apply( this, arguments );
    _.assert( newResult === undefined, () => 'The element ' + _.entity.exportStringDiagnosticShallow( ins ) + 'is several times in dstArray' );
  }
  else
  {
    result = arrayReplacedElementOnce.apply( this, arguments );
  }

  return result;
}

/*
function arrayReplacedOnceStrictly( dstArray, ins, sub, evaluator1, evaluator2 )
{
  let result = arrayReplacedOnce.apply( this, arguments );
  _.assert( result >= 0, () => 'Array does not have element ' + _.entity.exportStringDiagnosticShallow( ins ) );
  return result;
}
*/

//

function arrayReplaceArray( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  arrayReplacedArray.apply( this, arguments );
  return dstArray;
}

//

function arrayReplaceArrayOnce( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  arrayReplacedArrayOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayReplaceArrayOnceStrictly( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result;
  if( Config.debug )
  {
    let insArrayLength = ins.length;
    result = arrayReplacedArrayOnce.apply( this, arguments );
    _.assert( result === insArrayLength, '{-dstArray-} should have each element of {-insArray-}' );
    _.assert( insArrayLength === sub.length, '{-subArray-} should have the same length {-insArray-} has' );

    if( dstArray === ins )
    return dstArray;

    let newResult = arrayReplacedArrayOnce.apply( this, arguments );

    _.assert( newResult === 0, () => 'The element ' + _.entity.exportStringDiagnosticShallow( ins ) + 'is several times in dstArray' );
  }
  else
  {
    result = arrayReplacedArrayOnce.apply( this, arguments );
  }

  return dstArray;
}

/*
function arrayReplaceArrayOnceStrictly( dstArray, ins, sub, evaluator1, evaluator2 )
{
  let result = arrayReplacedArrayOnce.apply( this, arguments );
  _.assert( result === ins.length, '{-dstArray-} should have each element of {-insArray-}' );
  _.assert( ins.length === sub.length, '{-subArray-} should have the same length {-insArray-} has' );
  return dstArray;
}
*/

//

function arrayReplacedArray( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( 3 <= arguments.length && arguments.length <= 5 );
  _.assert( _.longLike( ins ) );
  _.assert( _.longLike( sub ) );
  _.assert( ins.length === sub.length, '{-subArray-} should have the same length {-insArray-} has' );

  let result = 0;
  let index = -1;
  // let oldDstArray = dstArray.slice();  // Array with src values stored
  if( dstArray === ins )
  ins = ins.slice();

  for( let i = 0, len = ins.length; i < len; i++ )
  {
    // let dstArray2 = oldDstArray.slice(); // Array modified for each ins element
    index = _.longLeftIndex( dstArray, ins[ i ], evaluator1, evaluator2 );
    while( index !== -1 )
    {
      let subValue = sub[ i ];
      let insValue = ins[ i ];
      if( subValue === undefined )
      {
        dstArray.splice( index, 1 );
        // dstArray2.splice( index, 1 );
      }
      else
      {
        dstArray.splice( index, 1, subValue );
        // dstArray2.splice( index, 1, subValue );
      }

      result += 1;

      // if( dstArray === ins )
      // break;

      if( subValue === insValue )
      break;

      index = _.longLeftIndex( dstArray, insValue, evaluator1, evaluator2 );
    }
  }

  return result;
}

//

function arrayReplacedArrayOnce( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( _.longLike( ins ) );
  _.assert( _.longLike( sub ) );
  _.assert( ins.length === sub.length, '{-subArray-} should have the same length {-insArray-} has' );
  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  let index = -1;
  let result = 0;

  //let oldDstArray = dstArray.slice();  // Array with src values stored
  for( let i = 0, len = ins.length; i < len; i++ )
  {
    index = _.longLeftIndex( dstArray, ins[ i ], evaluator1, evaluator2 );
    if( index >= 0 )
    {
      let subValue = sub[ i ];
      if( subValue === undefined )
      dstArray.splice( index, 1 );
      else
      dstArray.splice( index, 1, subValue );
      result += 1;
    }
  }

  return result;
}

//

function arrayReplacedArrayOnceStrictly( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result;
  if( Config.debug )
  {
    let insArrayLength = ins.length
    result = arrayReplacedArrayOnce.apply( this, arguments );
    _.assert( result === insArrayLength, '{-dstArray-} should have each element of {-insArray-}' );
    _.assert( insArrayLength === sub.length, '{-subArray-} should have the same length {-insArray-} has' );

    if( dstArray === ins )
    return result;

    let newResult = arrayReplacedArrayOnce.apply( this, arguments );
    _.assert( newResult === 0, () => 'One element of ' + _.entity.exportStringDiagnosticShallow( ins ) + 'is several times in dstArray' );
  }
  else
  {
    result = arrayReplacedArrayOnce.apply( this, arguments );
  }

  return result;
}

//

function arrayReplaceArrays( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  arrayReplacedArrays.apply( this, arguments );
  return dstArray;
}

//

function arrayReplaceArraysOnce( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  arrayReplacedArraysOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayReplaceArraysOnceStrictly( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result;
  if( Config.debug )
  {
    let expected = 0;
    for( let i = ins.length - 1; i >= 0; i-- )
    {
      if( _.longLike( ins[ i ] ) )
      expected += ins[ i ].length;
      else
      expected += 1;
    }

    result = arrayReplacedArraysOnce.apply( this, arguments );

    _.assert( result === expected, '{-dstArray-} should have each element of {-insArray-}' );
    _.assert( ins.length === sub.length, '{-subArray-} should have the same length {-insArray-} has' );

    if( dstArray === ins )
    return dstArray;

    let newResult = arrayReplacedArrayOnce.apply( this, arguments );
    _.assert( newResult === 0, () => 'One element of ' + _.entity.exportStringDiagnosticShallow( ins ) + 'is several times in dstArray' );
  }
  else
  {
    result = arrayReplacedArraysOnce.apply( this, arguments );
  }

  return dstArray;

}

//

function arrayReplacedArrays( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( 3 <= arguments.length && arguments.length <= 5 );
  _.assert( _.arrayIs( dstArray ), 'arrayReplacedArrays :', 'Expects array' );
  _.assert( _.longLike( sub ), 'arrayReplacedArrays :', 'Expects longLike entity' );
  _.assert( _.longLike( ins ), 'arrayReplacedArrays :', 'Expects longLike entity' );
  _.assert( ins.length === sub.length, '{-subArray-} should have the same length {-insArray-} has' );

  let result = 0;

  function _replace( /* dstArray, argument, subValue, evaluator1, evaluator2 */ )
  {
    let dstArray = arguments[ 0 ];
    let argument = arguments[ 1 ];
    let subValue = arguments[ 2 ];
    let evaluator1 = arguments[ 3 ];
    let evaluator2 = arguments[ 4 ];
    // let dstArray2 = oldDstArray.slice();
    //let index = dstArray.indexOf( argument );
    let index = _.longLeftIndex( dstArray, argument, evaluator1, evaluator2 );

    while( index !== -1 )
    {
      // dstArray2.splice( index, 1, subValue );
      dstArray.splice( index, 1, subValue );
      result += 1;
      if( subValue === argument )
      break;
      index = _.longLeftIndex( dstArray, argument, evaluator1, evaluator2 );
    }
  }

  let insCopy = Object.create( null );
  let subCopy = Object.create( null );

  if( dstArray === ins )
  {
    ins = ins.slice();
  }
  else
  {
    for( let i = ins.length - 1; i >= 0; i-- )
    {
      if( _.longLike( ins[ i ] ) )
      if( ins[ i ] === dstArray )
      insCopy[ i ] = ins[ i ].slice();

      if( _.longLike( sub[ i ] ) )
      if( sub[ i ] === dstArray )
      subCopy[ i ] = sub[ i ].slice();
    }
  }

  for( let a = 0, len = ins.length; a < len; a++ )
  {
    if( _.longLike( ins[ a ] ) )
    {
      let insArray = insCopy[ a ] || ins[ a ];
      let subArray = sub[ a ] || subCopy[ a ];

      for( let i = 0, len2 = insArray.length; i < len2; i++ )
      _replace( dstArray, insArray[ i ], subArray[ i ], evaluator1, evaluator2 );
    }
    else
    {
      _replace( dstArray, ins[ a ], sub[ a ], evaluator1, evaluator2 );
    }
  }

  return result;
}

//

function arrayReplacedArraysOnce( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  _.assert( 3 <= arguments.length && arguments.length <= 5 );
  _.assert( _.arrayIs( dstArray ), 'arrayReplacedArrays :', 'Expects array' );
  _.assert( _.longLike( sub ), 'arrayReplacedArrays :', 'Expects longLike entity' );
  _.assert( _.longLike( ins ), 'arrayReplacedArrays :', 'Expects longLike entity' );
  _.assert( ins.length === sub.length, '{-subArray-} should have the same length {-insArray-} has' );

  let result = 0;
  // let oldDstArray = dstArray.slice();  // Array with src values stored

  function _replace( /* dstArray, argument, subValue, evaluator1, evaluator2 */ )
  {
    let dstArray = arguments[ 0 ];
    let argument = arguments[ 1 ];
    let subValue = arguments[ 2 ];
    let evaluator1 = arguments[ 3 ];
    let evaluator2 = arguments[ 4 ];
    // let dstArray2 = oldDstArray.slice();
    //let index = dstArray.indexOf( argument );
    // let index = _.longLeftIndex( dstArray2, argument, evaluator1, evaluator2 );
    let index = _.longLeftIndex( dstArray, argument, evaluator1, evaluator2 );

    if( index !== -1 )
    {
      // dstArray2.splice( index, 1, subValue );
      dstArray.splice( index, 1, subValue );
      result += 1;
    }
  }

  for( let a = 0, len = ins.length; a < len ; a++ )
  {
    if( _.longLike( ins[ a ] ) )
    {
      let insArray = ins[ a ];
      let subArray = sub[ a ];

      for( let i = 0, len2 = insArray.length; i < len2; i++ )
      _replace( dstArray, insArray[ i ], subArray[ i ], evaluator1, evaluator2 );
    }
    else
    {
      _replace( dstArray, ins[ a ], sub[ a ], evaluator1, evaluator2 );
    }
  }

  return result;
}

//

function arrayReplacedArraysOnceStrictly( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result;
  if( Config.debug )
  {
    result = arrayReplacedArraysOnce.apply( this, arguments );

    let expected = 0;
    for( let i = ins.length - 1; i >= 0; i-- )
    {
      if( _.longLike( ins[ i ] ) )
      expected += ins[ i ].length;
      else
      expected += 1;
    }

    _.assert( result === expected, '{-dstArray-} should have each element of {-insArray-}' );
    _.assert( ins.length === sub.length, '{-subArray-} should have the same length {-insArray-} has' );

    if( dstArray === ins )
    return result;

    let newResult = arrayReplacedArrayOnce.apply( this, arguments );
    _.assert( newResult === 0, () => 'The element ' + _.entity.exportStringDiagnosticShallow( ins ) + 'is several times in dstArray' );
  }
  else
  {
    result = arrayReplacedArraysOnce.apply( this, arguments );
  }

  return result;

}

//

/**
 * The arrayUpdate() routine adds a value (sub) to an array (dstArray) or replaces a value (ins) of the array (dstArray) by (sub),
 * and returns the last added index or the last replaced index of the array (dstArray).
 *
 * It creates the variable (index) assigns and calls to it the function(arrayReplaceOnce( dstArray, ins, sub ).
 * [arrayReplaceOnce( dstArray, ins, sub )]{@link wTools.arrayReplaceOnce}.
 * Checks if (index) equal to the -1.
 * If true, it adds to an array (dstArray) a value (sub), and returns the last added index of the array (dstArray).
 * Otherwise, it returns the replaced (index).
 *
 * @see wTools.arrayReplaceOnce
 *
 * @param { Array } dstArray - The source array.
 * @param { * } ins - The value to change.
 * @param { * } sub - The value to add or replace.
 *
 * @example
 * let add = _.arrayUpdate( [ 'Petre', 'Mikle', 'Oleg' ], 'Dmitry', 'Dmitry' );
 * // returns 3
 * console.log( add );
 * // log [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ]
 *
 * @example
 * let add = _.arrayUpdate( [ 1, 2, 3, 4, 5 ], 6, 6 );
 * // returns 5
 * console.log( add );
 * // log [ 1, 2, 3, 4, 5, 6 ]
 *
 * @example
 * let replace = _.arrayUpdate( [ true, true, true, true, false ], false, true );
 * // returns 4
 * console.log( replace );
 * // log [ true, true true, true, true ]
 *
 * @returns { number } Returns the last added or the last replaced index.
 * @function arrayUpdate
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (arguments.length) is less or more than three.
 * @namespace Tools
 */

function arrayUpdate( /* dstArray, ins, sub, evaluator1, evaluator2 */ )
{
  let dstArray = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let sub = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let index = arrayReplacedOnce.apply( this, arguments );

  if( index === -1 )
  {
    dstArray.push( sub );
    index = dstArray.length - 1;
  }

  return index;
}

// --
// extension
// --

let ToolsExtension =
{

  // array checker

  constructorLikeArray,

  arrayFromCoercing, /* aaa : check coverage */ /* Dmytro : coverage extended */
  arrayFromStr,

  // arrayAs,
  // arrayAsShallowing,

  // array transformer

  // arraySlice,
  // arrayEmpty,
  arrayExtendAppending,
  arrayExtendPrepending,

  arrayBut,
  arrayButInplace, /* !!! : use instead of arrayBut, arrayButInplace */
  arrayBut_, /* qqq : for Dmytro : use in wTools */
  arrayShrink,
  arrayShrinkInplace, /* !!! : use instead of arrayShrink, arrayShrinkInplace */
  arrayShrink_, /* qqq : for Dmytro : use in wTools */
  arrayGrow,
  arrayGrowInplace, /* !!! : use instead of arrayGrow, arrayGrowInplace */
  arrayGrow_, /* qqq : for Dmytro : use in wTools */
  arrayRelength,
  arrayRelengthInplace, /* !!! : use instead of arrayRelength, arrayRelengthInplace */
  arrayRelength_, /* qqq : for Dmytro : use in wTools */

  // array prepend on l3

  // array append on l3

  // array remove

  arrayRemove,
  arrayRemoveOnce,
  arrayRemoveOnceStrictly,
  arrayRemoved,
  arrayRemovedOnce,
  arrayRemovedOnceStrictly,

  arrayRemoveElement,
  arrayRemoveElementOnce,
  arrayRemoveElementOnceStrictly,
  arrayRemovedElement, /* !!! : use instead of arrayRemovedElement */
  arrayRemovedElement_,
  arrayRemovedElementOnce, /* !!! : use instead of arrayRemovedElementOnce */
  arrayRemovedElementOnce_,
  arrayRemovedElementOnceStrictly, /* !!! : use instead of arrayRemovedElementOnceStrictly */
  arrayRemovedElementOnceStrictly_,

  arrayRemoveArray,
  arrayRemoveArrayOnce,
  arrayRemoveArrayOnceStrictly,
  arrayRemovedArray,
  arrayRemovedArrayOnce,
  arrayRemovedArrayOnceStrictly,

  arrayRemoveArrays,
  arrayRemoveArraysOnce,
  arrayRemoveArraysOnceStrictly,
  arrayRemovedArrays,
  arrayRemovedArraysOnce,
  arrayRemovedArraysOnceStrictly,

  arrayRemoveDuplicates,

  // array flatten

  arrayFlatten,
  arrayFlattenOnce,
  arrayFlattenOnceStrictly,
  arrayFlattened,
  arrayFlattenedOnce,
  arrayFlattenedOnceStrictly,

  arrayFlattenDefined,
  arrayFlattenDefinedOnce,
  arrayFlattenDefinedOnceStrictly,
  arrayFlattenedDefined,
  arrayFlattenedDefinedOnce,
  arrayFlattenedDefinedOnceStrictly,

  // array replace

  arrayReplace,
  arrayReplaceOnce,
  arrayReplaceOnceStrictly,
  arrayReplaced,
  arrayReplacedOnce,
  arrayReplacedOnceStrictly,

  arrayReplaceElement,
  arrayReplaceElementOnce,
  arrayReplaceElementOnceStrictly,
  arrayReplacedElement,
  arrayReplacedElementOnce,
  arrayReplacedElementOnceStrictly,

  arrayReplaceArray,
  arrayReplaceArrayOnce,
  arrayReplaceArrayOnceStrictly,
  arrayReplacedArray,
  arrayReplacedArrayOnce,
  arrayReplacedArrayOnceStrictly,

  arrayReplaceArrays,
  arrayReplaceArraysOnce,
  arrayReplaceArraysOnceStrictly,
  arrayReplacedArrays,
  arrayReplacedArraysOnce,
  arrayReplacedArraysOnceStrictly,

  arrayUpdate,

  // to replace

  /*
  | routine          | makes new dst container                  | saves dst container                                     |
  | ---------------- | ---------------------------------------- | ------------------------------------------------------- |
  | arrayBut_        | _.arrayBut_( null, src, range )          | _.arrayBut_( src )                                      |
  |                  |                                          | _.arrayBut_( src, range )                               |
  |                  |                                          | _.arrayBut_( dst, dst, range )                          |
  |                  |                                          | _.arrayBut_( dst, src )                                 |
  |                  |                                          | _.arrayBut_( dst, src, range )                          |
  | ---------------  | ---------------------------------------- | ------------------------------------------------------- |
  | arrayShrink_     | _.arrayShrink_( null, src, range )       | _.arrayShrink_( src )                                   |
  |                  |                                          | _.arrayShrink_( src, range )                            |
  |                  |                                          | _.arrayShrink_( dst, dst, range )                       |
  |                  |                                          | _.arrayShrink_( dst, src )                              |
  |                  |                                          | _.arrayShrink_( dst, src, range )                       |
  | ---------------  | ---------------------------------------- | ------------------------------------------------------- |
  | arrayGrow_       | _.arrayGrow_( null, src, range )         | _.arrayGrow_( src )                                     |
  |                  |                                          | _.arrayGrow_( src, range )                              |
  |                  |                                          | _.arrayGrow_( dst, dst, range )                         |
  |                  |                                          | _.arrayGrow_( dst, src )                                |
  |                  |                                          | _.arrayGrow_( dst, src, range )                         |
  | ---------------  | ---------------------------------------- | ------------------------------------------------------- |
  | arrayRelength_   | _.arrayRelength_( null, src, range )     | _.arrayRelength_( src )                                 |
  |                  |                                          | _.arrayRelength_( src, range )                          |
  |                  |                                          | _.arrayRelength_( dst, dst, range )                     |
  |                  |                                          | _.arrayRelength_( dst, src )                            |
  |                  |                                          | _.arrayRelength_( dst, src, range )                     |
  | ---------------- | ---------------------------------------- | ------------------------------------------------------- |
  */

}

_.props.supplement( _, ToolsExtension );

})();

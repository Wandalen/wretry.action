(function _Routines_s_() {

'use strict';

const _ = _global_.wTools;
const _longSlice = _.longSlice;
const _sqr = _.math.sqr;
const _sqrt = _.math.sqrt;
// let _assertMapHasOnly = _.map.assertHasOnly;
const _routineIs = _.routineIs;

const _min = Math.min;
const _max = Math.max;
const _pow = Math.pow;
const sqrt = Math.sqrt;
const abs = Math.abs;

let vad = _.vectorAdapter;
let operations = vad.operations;
let meta = vad._meta;
let Routines = meta.routines;

/*

- split _onVectorsScalarWise_functor !!!

*/

_.assert( _.object.isBasic( operations ) );

// --
// basic
// --

/**
 * Routine assign() assigns the values of second argument to the vector {-dst-}.
 * If {-dst-}.length < src.length, then rest of {-dst-} will be filled by zeros.
 * If {-dst-}.length > src.length, then for {-dst-} will be assigned only part of src with length same as {-dst-}.
 * If arguments.length is more then two, then routine assigns elements of pseudo array {-arguments-} to the vector {-dst-}.
 * The assigning starts from the index 1.
 *
 * @example
 * var dst = [ 0, -1, 2 ];
 * var got = _.avector.assign( dst, [ 3, -2, -4 ] );
 * console.log( got );
 * // log [ 3, -2, -4 ];
 * console.log( dst );
 * // log [ 3, -2, -4 ];
 *
 * var got = _.avector.assign( [ 1, 2, 3 ], 0 );
 * console.log( got );
 * // log [ 0, 0, 0 ];
 *
 * var got = _.avector.assign( [ 0, -1, 2, 3, -4 ], [ 3, -2, -4 ] );
 * console.log( got );
 * // log [ 3, -2, -4, 0, 0 ];
 *
 * var got = _.avector.assign( [ 0, -1, 2 ], [ 3, -2, -4, 3, -4 ] );
 * console.log( got );
 * // log [ 3, -2, -4 ];
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { * } ... - Source vector. If arguments.length is 2, then source vector is second argument.
 * Otherwise, the source vector is copy of arguments starting from index 1.
 * @returns { Long|VectorAdapter } - Returns original {-dst-} vector filled by values from source vector.
 * @function assign
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function assign( dst ) /* aaa2 : perfect coverage is required */ /* Dmytro : covered */
{
  let length = dst.length;
  let alength = arguments.length;

  if( alength === 2 )
  {
    let src = arguments[ 1 ];
    if( _.numberIs( src ) )
    {
      for( let i = 0 ; i < dst.length ; i++ )
      dst.eSet( i, src );
    }
    else if( _.vectorIs( src ) )
    {
      src = this.fromLong( src );
      // _.assert( src.length === dst.length );
      // _.assert( src.length <= dst.length );
      let l = _min( src.length, dst.length );
      for( let i = 0 ; i < l ; i++ )
      dst.eSet( i, src.eGet( i ) );
      for( let i = src.length, l = dst.length ; i < l ; i++ )
      dst.eSet( i, 0 );
    }
    else _.assert( 0, 'Unknown type of argument', _.entity.strType( src ) );
    // if( _.numberIs( arguments[ 1 ] ) )
    // this.assignScalar( dst, arguments[ 1 ] );
    // else if( _.vector.hasLength( arguments[ 1 ] ) )
    // this.assignVector( dst, this.fromLong( arguments[ 1 ] ) );
    // else _.assert( 0, 'unknown arguments' );
  }
  else if( alength === 1 + length )
  {
    this.assign.call( this, dst, this.fromLong( _longSlice( arguments, 1, alength ) ) );
  }
  else _.assert( 0, 'assign :', 'unknown arguments' );

  return dst;
}

let dop = assign.operation = Object.create( null );
dop.input = 'vw ?ar *!vr';
dop.scalarWise = true;
dop.homogeneous = false;
dop.takingArguments = [ 1, Infinity ];
dop.takingVectors = [ 1, 2 ];
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * Routine assignVector() assigns the values of source vector {-src-} to the destination vector {-dst-}.
 *
 * @example
 * var got = _.avector.assignVector( [ 1, 2, 3 ], [ 0, 1, 0 ] );
 * console.log( got );
 * // log [ 0, 1, 0 ];
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns original {-dst-} vector filled by values from source vector.
 * @function assignVector
 * @throws { Error } If {-dst-} or {-src-} are not vectors.
 * @throws { Error } If length of {-src-} and {-dst-} vectors are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function assignVector( dst, src )
{
  let length = dst.length;

  _.assert( !!dst && !!src, 'Expects {-src-} and ( dst )' );
  _.assert( dst.length === src.length, 'src and dst should have same length' );
  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.vectorAdapterIs( src ) );

  for( let s = 0 ; s < length ; s++ )
  {
    dst.eSet( s, src.eGet( s ) );
  }

  return dst;
}

dop = assignVector.operation = Object.create( null );
dop.input = 'vw vr';
dop.scalarWise = true;
dop.homogeneous = true;
dop.takingArguments = 2;
dop.takingVectors = 2;
dop.takingVectorsOnly = true;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;
dop.special = true;

//

function assignScalar( dst, scalar )
{
  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.numberIs( scalar ) );

  for( let i = 0; i < dst.length ; i++ )
  dst.eSet( i, scalar );
  return dst;
}

//

/**
 * Routine clone() makes copy of source vector {-src-}.
 *
 * @example
 * var src = _.avector.make( [ 1, 2, 3 ] )
 * var got = _.avector.clone( src );
 * console.log( got );
 * // log [ 1, 2, 3 ];
 * console.log( got === src );
 * // log false
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns copy of source vector.
 * @function clone
 * @throws { Error } If arguments.length is less or more then one.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function clone( src )
{
  let length = src.length;
  let dst = this.MakeSimilar( src );

  _.assert( arguments.length === 1 )

  for( let s = 0 ; s < length ; s++ )
  dst.eSet( s, src.eGet( s ) );

  return dst;
}

dop = clone.operation = Object.create( null );
dop.input = 'vr';
dop.scalarWise = true;
dop.homogeneous = true;
dop.takingArguments = 1;
dop.takingVectors = 1;
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = true;
dop.modifying = false;
dop.special = true;

//

/**
 * Routine MakeSimilar() makes new instance of vector {-src-} with length defined by argument {-length-}.
 *
 * @example
 * var got = _.avector.MakeSimilar( [ 1, 2, 3 ], 2 );
 * console.log( got );
 * // log [ undefined, undefined ];
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Number } length - Length of returned vector. If {-length-} is not defined, then routine makes vector with src.length.
 * @returns { Long|VectorAdapter } - Returns instance of source vector with defined length.
 * @function MakeSimilar
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-length-} is not a Number.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function MakeSimilar( src, length )
{
  if( length === undefined )
  length = src.length;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIs( length ) );

  let dst = this.fromLong( new src._vectorBuffer.constructor( length ) );

  return dst;
}

dop = MakeSimilar.operation = Object.create( null );
dop.input = 'vr ?s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, 2 ];
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = true;
dop.modifying = false;
dop.special = true;

//

/*
  if( _.numberIs( array ) && f === undefined && l === undefined )
  return array;

  let result;
  let f = f !== undefined ? f : 0;
  let l = l !== undefined ? l : array.length;

  _.assert( _.longIs( array ) );
  _.assert( _.numberIs( f ) );
  _.assert( _.numberIs( l ) );
  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( f < 0 )
  f = 0;
  if( l > array.length )
  l = array.length;
  if( l < f )
  l = f;

  if( _.bufferTypedIs( array ) )
  result = new array.constructor( l-f );
  else
  result = new Array( l-f );

  for( let r = f ; r < l ; r++ )
  result[ r-f ] = array[ r ];

  return result;
*/

/**
 * Routine slice() makes slice copy of part of vector {-src-}.
 *
 * @example
 * var got = _.avector.slice( [ 1, 2, 3, 4, 5 ], 1, 3 );
 * console.log( got );
 * // log [ 2, 3, 4 ];
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Number } first - Start index. If {-first-} is not defined, then copying starts from index 0.
 * @param { Number } last - End index (included). If {-last-} is not defined, then copying ends on last index of {-src-}.
 * @returns { Long|VectorAdapter } - Returns copy of part of source vector.
 * @function slice
 * @throws { Error } If {-src-} is not a Long, not a VectorAdapter.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function slice( src, first, last )
{
  let cinterval = [ first, last ]
  if( !cinterval[ 0 ] )
  cinterval[ 0 ] = 0;
  if( cinterval[ 1 ] === undefined )
  cinterval[ 1 ] = src.length;
  let result = this.onlyLong.call( this, src, cinterval );
  return result;
}

dop = slice.operation = Object.create( null );
dop.input = 'vr ?s ?s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, 3 ];
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = true;
dop.modifying = false;

//

// function slicedLong( src, first, last )
// {
//   _.assert( !!src );
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//   _.assert( !!src._vectorBuffer, 'Expects vector as argument' );
//
//   let length = src.length;
//   let f = first !== undefined ? first : 0;
//   let l = last !== undefined ? last : src.length;
//   let result;
//   if( src.stride !== 1 || src.offset !== 0 || src._vectorBuffer.length !== l || f !== 0 )
//   {
//     result = new src._vectorBuffer.constructor( l-f );
//     for( let i = f ; i < l ; i++ )
//     result[ i-f ] = src.eGet( i );
//   }
//   else
//   {
//     debugger;
//     return result = src._vectorBuffer.slice( f, l );
//   }
//
//   return result;
// }
//
// dop = slicedLong.operation = Object.create( null );
// dop.input = 'vr ?s ?s';
// dop.scalarWise = false;
// dop.homogeneous = false;
// dop.takingArguments = [ 1, 3 ];
// dop.takingVectors = 1;
// dop.takingVectorsOnly = false;
// dop.returningSelf = false;
// dop.returningNew = false;
// dop.returningLong = true;
// dop.modifying = false;
//
// //
//
// function slicedAdapter( src, first, last )
// {
//   let result = this.slicedLong.apply( this, arguments );
//   return this.fromLong( result );
// }
//
// dop = slicedAdapter.operation = Object.create( null );
// dop.input = 'vr ?s ?s';
// dop.scalarWise = false;
// dop.homogeneous = false;
// dop.takingArguments = [ 1, 3 ];
// dop.takingVectors = 1;
// dop.takingVectorsOnly = false;
// dop.returningSelf = false;
// dop.returningNew = false;
// dop.returningLong = true;
// dop.modifying = false;
//
// //
//
// function resizedLong( src, first, last, val )
// {
//   let length = src.length;
//   let f = first !== undefined ? first : 0;
//   let l = last !== undefined ? last : src.length;
//
//   if( l < f )
//   l = f;
//
//   let lsrc = Math.min( src.length, l );
//
//   _.assert( 1 <= arguments.length && arguments.length <= 4 );
//   _.assert( !!src._vectorBuffer, 'Expects vector as argument' );
//
//   let result;
//   if( src.stride !== 1 || src.offset !== 0 || src._vectorBuffer.length !== l || f !== 0 )
//   {
//     debugger;
//     result = new src._vectorBuffer.constructor( l-f );
//     for( let r = Math.max( f, 0 ) ; r < lsrc ; r++ )
//     result[ r-f ] = src.eGet( r );
//   }
//   else
//   {
//     debugger;
//     result = src._vectorBuffer.slice();
//   }
//
//   /* */
//
//   if( val !== undefined )
//   if( f < 0 || l > array.length )
//   {
//     for( let r = 0 ; r < -f ; r++ )
//     {
//       result[ r ] = val;
//     }
//     let r = Math.max( lsrc-f, 0 );
//     for( ; r < result.length ; r++ )
//     {
//       result[ r ] = val;
//     }
//   }
//
//   return result;
// }
//
// dop = resizedLong.operation = Object.create( null );
// dop.input = 'vr ?s ?s ?s';
// dop.scalarWise = false;
// dop.homogeneous = false;
// dop.takingArguments = [ 1, 4 ];
// dop.takingVectors = 1;
// dop.takingVectorsOnly = false;
// dop.returningSelf = false;
// dop.returningNew = false;
// dop.returningLong = true;
// dop.modifying = false;
//
// //
//
// function resizedAdapter( src, first, last, val )
// {
//   let result = this.resizedLong.apply( this, arguments );
//   return this.fromLong( result );
// }
//
// dop = resizedAdapter.operation = Object.create( null );
// dop.input = 'vr ?s ?s ?s';
// dop.scalarWise = false;
// dop.homogeneous = false;
// dop.takingArguments = [ 1, 4 ];
// dop.takingVectors = 1;
// dop.takingVectorsOnly = false;
// dop.returningSelf = false;
// dop.returningNew = false;
// dop.returningLong = true;
// dop.modifying = false;

//

/**
 * Routine growAdapter() makes new instance of source vector {-src-} with length equal to src.length or bigger.
 * The elements of new vector, which index is less or equal to src.length, have values of vector {-src-}, other elements filled by value {-val-}.
 *
 * @example
 * var got = _.vectorAdapter.growAdapter( [ 1, 2, 3 ], [ 1, 4 ], 5 );
 * console.log( got.toStr() );
 * // log "1.000, 2.000, 3.000, 5.000, 5.000"
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Range } cinterval - Defines length of new vector.
 * @param { * } val - To fill extra elements.
 * @returns { VectorAdapter } - Returns instance of VectorAdapter filled by values of original vector {-src-}.
 * If length of new vector is more then src.length, then extra elements filled by value {-val-}.
 * @function growAdapter
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-src-} is not a Long, not a VectorAdapter.
 * @throws { Error } If {-cinterval-} is not a Range.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function growAdapter( src, cinterval, val )
{
  let result = this.growLong.apply( this, arguments );
  return this.fromLong( result );
}

dop = growAdapter.operation = Object.create( null );
dop.input = 'vr ?s ?s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, 3 ];
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = true;
dop.modifying = false;

//

/**
 * Routine growLong() makes new instance of source vector {-src-} with length equal to src.length or bigger.
 * The elements of new vector, which index is less or equal to src.length, have values of vector {-src-}, other elements filled by value {-val-}.
 *
 * @example
 * var got = _.avector.growLong( [ 1, 2, 3 ], [ 1, 4 ], 5 );
 * console.log( got );
 * // log [ 1, 2, 3, 5, 5 ]
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Range } cinterval - Defines length of new vector.
 * @param { * } val - To fill extra elements.
 * @returns { Long } - Returns instance of source Long filled by values of original vector {-src-}.
 * If length of new vector is more then src.length, then extra elements filled by value {-val-}.
 * @function growLong
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-src-} is not a Long, not a VectorAdapter.
 * @throws { Error } If {-cinterval-} is not a Range.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function growLong( src, cinterval, val )
{

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( _.vectorAdapterIs( src ) );

  if( val === undefined )
  val = 0;
  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];

  _.assert( _.intervalIs( cinterval ) );
  _.assert( _.numberIs( val ) );

  if( cinterval[ 0 ] >= 0 )
  cinterval[ 0 ] = 0;
  if( cinterval[ 1 ] <= src.length-1 )
  cinterval[ 1 ] = src.length-1;

  let l = cinterval[ 1 ] - cinterval[ 0 ] + 1;
  let result = this.long.makeUndefined( this.bufferConstructorOf( src ), l );

  /* aaa : optimize */ /* Dmytro : used method fill instead of cycle for */

  // let l2 = -cinterval[ 0 ];
  // for( let i = 0 ; i < l2 ; i++ )
  // result[ i ] = val;
  //
  // _.assert( cinterval[ 0 ] === 0, 'not implemented' );
  // let l3 = src.length-cinterval[ 0 ];
  // for( let i = -cinterval[ 0 ] ; i < l3 ; i++ )
  // result[ i-cinterval[ 0 ] ] = src.eGet( i );
  //
  // let l4 = l;
  // for( let i = src.length ; i < l4 ; i++ )
  // result[ i ] = val;

  let l2 = -cinterval[ 0 ];
  result.fill( val, 0, l2 ); /* qqq : does it work for any kind of buffer? check please. extend test */

  let l3 = src.length + l2;
  for( let i = l2 ; i < l3 ; i++ )
  result[ i ] = src.eGet( i-l2 );

  result.fill( val, l3, l )

  return result;
}

dop = growLong.operation = Object.create( null );
dop.input = 'vr ?s ?s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, 3 ];
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = true;
dop.modifying = false;

//

/**
 * Routine onlyAdapter() makes new instance of source vector {-src-} with length equal to src.length or less. The elements of new vector filled by values of {-src-}.
 *
 * @example
 * var got = _.vectorAdapter.onlyAdapter( [ 1, 2, 3, 4, 5 ], [ 1, 3 ] );
 * console.log( got.toStr() );
 * // log "2.000, 3.000, 4.000"
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Range } cinterval - Defines range for copying.
 * @returns { VectorAdapter } - Returns instance of VectorAdapter filled by values of original vector {-src-}.
 * @function onlyAdapter
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-src-} is not a Long, not a VectorAdapter.
 * @throws { Error } If {-cinterval-} is not a Range.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function onlyAdapter( src, cinterval )
{
  let result = this.onlyLong.apply( this, arguments );
  return this.fromLong( result );
}

dop = onlyAdapter.operation = Object.create( null );
dop.input = 'vr ?s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, 2 ];
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = true;
dop.modifying = false;

//

/**
 * Routine onlyLong() makes new instance of source vector {-src-} with length equal to src.length or less. The elements of new vector filled by values of {-src-}.
 *
 * @example
 * var got = _.avector.onlyLong( [ 1, 2, 3, 4, 5 ], [ 1, 3 ] );
 * console.log( got );
 * // log [ 2, 3, 4 ]
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Range } cinterval - Defines range for copying.
 * @returns { Long } - Returns instance of source Long filled by values of original vector {-src-}.
 * @function onlyLong
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-src-} is not a Long, not a VectorAdapter.
 * @throws { Error } If {-cinterval-} is not a Range.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function onlyLong( src, cinterval )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];
  if( cinterval[ 0 ] < 0 )
  cinterval[ 0 ] = 0;
  if( cinterval[ 1 ] > src.length - 1 )
  cinterval[ 1 ] = src.length - 1;

  let l = cinterval[ 1 ] - cinterval[ 0 ] + 1;
  let result = this.long.makeUndefined( this.bufferConstructorOf( src ), l );

  /* qqq : optimize */

  let l2 = cinterval[ 1 ];
  for( let i = cinterval[ 0 ] ; i <= l2 ; i++ )
  result[ i ] = src.eGet( i );

  return result;
}

dop = onlyLong.operation = Object.create( null );
dop.input = 'vr ?s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, 2 ];
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = true;
dop.modifying = false;

//

/**
 * Routine onlyAdapter_() makes new instance of source vector {-src-} with length equal to src.length or less. The elements of new vector filled by values of {-src-}.
 * End of range included. If provided range is outside of actual it will be adjusted.
 *
 * @example
 * var got = _.vectorAdapter.onlyAdapter_( [ 1, 2, 3, 4, 5 ], [ 1, 3 ] );
 * console.log( got );
 * // log "2.000, 3.000, 4.000"
 * var got = _.vectorAdapter.onlyAdapter_( [ 1, 2, 3, 4, 5 ], [ 3, 7 ] );
 * console.log( got );
 * // log "4.000, 5.000"
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Range } cinterval - Defines range for copying.
 * @returns { VectorAdapter } - Returns instance of VectorAdapter filled by values of original vector {-src-}.
 * @function onlyAdapter_
 * @throws { Error } If arguments.length is not equal one or two.
 * @throws { Error } If {-src-} is not a Long, not a VectorAdapter.
 * @throws { Error } If {-cinterval-} is not a Range.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function onlyAdapter_( src, cinterval )
{
  let result = this.onlyLong_.apply( this, arguments );
  return this.fromLong( result );
}

dop = onlyAdapter_.operation = Object.create( null );
dop.input = 'vr ?s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, 2 ];
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = true;
dop.modifying = false;

//

/**
 * Routine onlyLong_() makes new instance of source vector {-src-} with length equal to src.length or less. The elements of new vector filled by values of {-src-}.
 * End of range included. If provided range is outside of actual it will be adjusted.
 *
 * @example
 * var got = _.avector.onlyLong_( [ 1, 2, 3, 4, 5 ], [ 1, 3 ] );
 * console.log( got );
 * // log [ 2, 3, 4 ]
 * var got = _.avector.onlyLong_( [ 1, 2, 3, 4, 5 ], [ 3, 7 ] );
 * console.log( got );
 * // log [ 4, 5 ]
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Range } cinterval - Defines range for copying.
 * @returns { Long } - Returns instance of source Long filled by values of original vector {-src-}.
 * @function onlyLong_
 * @throws { Error } If arguments.length is not equal one or two.
 * @throws { Error } If {-src-} is not a Long, not a VectorAdapter.
 * @throws { Error } If {-cinterval-} is not a Range.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function onlyLong_( src, cinterval )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.vectorAdapterIs( src ) );

  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];

  _.assert( _.intervalIs( cinterval ) );

  if( cinterval[ 0 ] < 0 )
  cinterval[ 0 ] = 0;
  if( cinterval[ 1 ] > src.length - 1 )
  cinterval[ 1 ] = src.length - 1;
  if( cinterval[ 0 ] > cinterval[ 1 ] || src.length === 0 )
  {
    cinterval[ 1 ] = -1;
    cinterval[ 0 ] = 0;
  }

  let l = cinterval[ 1 ] - cinterval[ 0 ] + 1;
  let result = this.long.makeUndefined( this.bufferConstructorOf( src ), l );

  /* qqq : optimize */

  let l2 = cinterval[ 0 ];
  for( let i = 0 ; i < l ; i++ )
  result[ i ] = src.eGet( i + l2 );

  return result;

}

dop = onlyLong_.operation = Object.create( null );
dop.input = 'vr ?s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, 2 ];
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = true;
dop.modifying = false;

//

/**
 * Routine review() reviews source vector {-src-} in defined range {-cinterval-}. Routine makes new instance of vector {-src-} if range defines length smaller then src.length. Otherwise, routine returns original vector. The elements of new vector filled by values of {-src-}.
 *
 * @example
 * var got = _.avector.review( [ 1, 2, 3 ], 0 );
 * console.log( got );
 * // log [ 1, 2, 3 ];
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Range|Number } cinterval - Defines ranges for copying.
 * @returns { Long|VectorAdapter } - Returns instance of vector filled by values of original vector {-src-}. If {-src-} vector not changes, then routine returns original vector.
 * @function review
 * @throws { Error } If arguments.length is less or more then two.
 * @throws { Error } If {-src-} is not a Long, not a VectorAdapter.
 * @throws { Error } If {-cinterval-} is not a Range.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function review( src, cinterval )
{

  if( _.numberIs( cinterval ) )
  cinterval = [ cinterval, src.length-1 ];

  _.assert( arguments.length === 2 );
  _.assert( _.intervalIs( cinterval ) );
  _.assert( cinterval[ 0 ] >= 0 );
  _.assert( cinterval[ 1 ] <= src.length-1 );

  if( cinterval[ 0 ] === 0 && cinterval[ 1 ] === src.length-1 )
  return this.fromLong( src );

  src = this.fromLong( src );

  // if( src.stride !== 1 )
  // {
  //   result = this.fromLongLrangeAndStride( src._vectorBuffer , src.offset + first*src.stride , last-first , src.stride );
  // }
  // else
  // {
  //   result = this.fromLongLrange( src._vectorBuffer , src.offset + first , last-first );
  // }

  let result = src._review( cinterval );

  return result;
}

dop = review.operation = Object.create( null );
dop.input = 'vr s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 2;
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = true;
dop.returningLong = false;
dop.modifying = false;

//

/**
 * Routine bufferConstructorOf() returns constructor of vector {-src-}.
 *
 * @example
 * var got = _.avector.bufferConstructorOf( [ 1, 2, 3 ] );
 * console.log( got );
 * // log [function Array];
 *
 * @param { Function|Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns constructor of source vector.
 * @function bufferConstructorOf
 * @throws { Error } If source vector is not a Function, not a Long, not a VectorAdapter.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function bufferConstructorOf( src )
{
  if( _.routineIs( src ) )
  return src;
  else if( _.vectorAdapterIs( src ) )
  return src._bufferConstructorGet();
  else if( _.longIs( src ) )
  return src.constructor;
  else _.assert( 0 );
}

dop = bufferConstructorOf.operation = Object.create( null );
dop.input = 'vr|s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = false;
dop.modifying = false;

//

// function subarray( src, first, last )
// {
//   let result;
//   let length = src.length;
//   first = first || 0;
//   last = _.numberIs( last ) ? last : length;
//
//   if( last > length )
//   last = length;
//   if( first < 0 )
//   first = 0;
//   if( first > last )
//   first = last;
//
//   _.assert( arguments.length === 2 || arguments.length === 3 );
//   _.assert( !!src._vectorBuffer, 'Expects vector as argument' );
//   _.assert( src.offset >= 0 );
//
//   if( src.stride !== 1 )
//   {
//     result = this.fromLongLrangeAndStride( src._vectorBuffer , src.offset + first*src.stride , last-first , src.stride );
//   }
//   else
//   {
//     result = this.fromLongLrange( src._vectorBuffer , src.offset + first , last-first );
//   }
//
//   return result;
// }
//
// dop = subarray.operation = Object.create( null );
// dop.input = 'vr s ?s';
// dop.scalarWise = false;
// dop.homogeneous = false;
// dop.takingArguments = [ 2, 3 ];
// dop.takingVectors = 1;
// dop.takingVectorsOnly = false;
// dop.returningSelf = false;
// dop.returningNew = true;
// dop.modifying = false;

//

/**
 * Routine toLong() returns Long maiden from vector {-src-}.
 *
 * @example
 * var src = this.fromLong( [ 1, 2, 3 ] );
 * var got = src.toLong();
 * console.log( got );
 * // log [ 1, 2, 3 ];
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long } - Returns default Long maiden from source vector.
 * @function toLong
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If source vector is not a Long, not a VectorAdapter.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function toLong( src )
{
  let result;
  let length = src.length;

  _.assert( _.vectorAdapterIs( src ) || _.longIs( src ), 'Expects vector as a single argument' );
  _.assert( arguments.length === 1 );

  if( _.longIs( src ) )
  return src;

  return src._toLong();
}

dop = toLong.operation = Object.create( null );
dop.input = 'vr';
dop.output = 'l';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 1;
dop.takingVectors = 1;
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = true;
dop.modifying = false;

//

/**
 * Routine _toStr() makes string from data in source vector {-src-}.
 *
 * @example
 * var src = this.fromLong( [ 1, 2, 3 ] );
 * var got = src.toStr();
 * console.log( got );
 * // log "1.000, 2.000, 3.000";
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Map|Aux } o - Options map.
 * @param { Number } o.precision - The precision of numbers in returned string. Default value is 4.
 * @returns { String } - Returns string with elements of source vector.
 * @function _toStr
 * @throws { Error } If source vector is not a Long, not a VectorAdapter.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

/* zzz : redo */
function _toStr( src, o )
{
  let result = this.headExport( src ) + ' :: ';
  let length = src.length;

  if( !o )
  o = Object.create( null );

  if( o.precision === undefined )
  o.precision = 4;

  if( length )
  if( o.precision === 0 )
  {
    _.assert( 0, 'not tested' );
    for( let i = 0, l = length-1 ; i < l ; i++ )
    {
      result += String( src.eGet( i ) ) + ' ';
    }
    result += String( src.eGet( i ) );
  }
  else
  {
    let i = 0;
    let l = length-1;
    for(  ; i < l ; i++ )
    {
      let e = src.eGet( i );
      if( _.numberIs( e ) )
      result += e.toPrecision( o.precision ) + ' ';
      else
      result += e + ' ';
    }
    let e = src.eGet( i );
    if( _.numberIs( e ) )
    result += e.toPrecision( o.precision );
    else
    result += e;
  }

  result += '';
  return result;
}

_toStr.defaults =
{
  precision : 4,
}

dop = _toStr.operation = Object.create( null );
dop.input = 'vr ?t';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, 2 ];
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = false;

//

function headExport( src )
{
  let result = `VectorAdapter.x${src.length}.${_.entity.strType( src._vectorBuffer )}`;
  return result;
}

headExport.defaults =
{
  precision : 4,
}

dop = headExport.operation = Object.create( null );
dop.input = 'vr';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = false;

//

/**
 * Routine gather() fills destination vector {-dst-} by values from source vectors {-srcs-}.
 * The {-srcs-} can contain numbers and vectors. The dst.length to srcs.length ratio should be
 * an Integer. The length of element of {-srcs-} should be less then the ratio.
 *
 * @example
 * var src = this.fromLong( [ 0, 0, 0, 0 ] );
 * var got = _.avector.gather( src, [ [ 1, 4 ], [ 2, 8 ] ] );
 * console.log( got );
 * // log [ 1, 2, 4, 8 ]
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Array } srcs - An array with source vectors.
 * @returns { Long|VectorAdapter } - Returns vector filled by elements of source vectors.
 * @function gather
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If source vectors is not an Array.
 * @throws { Error } If {-dst-} is not a VectorAdapter.
 * @throws { Error } If dst.length divided on src.length is not an Integer.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function gather( dst, srcs )
{

  let scalarsPerElement = srcs.length;
  let l = dst.length / srcs.length;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.arrayIs( srcs ) );
  _.assert( _.intIs( l ) );

  debugger;

  /* */

  for( let s = 0 ; s < srcs.length ; s++ )
  {
    let src = srcs[ s ];
    _.assert( _.numberIs( src ) || _.vectorAdapterIs( src ) || _.longIs( src ) );
    if( _.numberIs( src ) )
    continue;
    if( _.longIs( src ) )
    src = srcs[ s ] = this.fromLong( src );
    _.assert( src.length === l );
  }

  /* */

  for( let e = 0 ; e < l ; e++ )
  {
    for( let s = 0 ; s < srcs.length ; s++ )
    {
      let v = _.numberIs( srcs[ s ] ) ? srcs[ s ] : srcs[ s ].eGet( e );
      dst.eSet( e*scalarsPerElement + s , v );
    }
  }

  return dst;
}

dop = gather.operation = Object.create( null );
dop.input = 'vw !vw'; /* xxx : introduce (*vw) */
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 2;
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * Routine map() provides replacing of elements in destination vector {-dst-} using results of execution {-onEach-} callback.
 *
 * @example
 * var src = [ 1, 2, 3 ];
 * var got = _.avector.map( src, [ 3, 2, 1 ], ( e ) => e );
 * console.log( got );
 * // log [ 3, 2, 1 ];
 * console.log( got === dst );
 * // log true
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Function } onEach - Callback. Accepts element of {-src-}, element index, {-src-} and {-dst-}.
 * @returns { Long|VectorAdapter } - Returns original destination vector with replaced elements.
 * @function map
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If destination vector is not a Long, not a VectorAdapter.
 * @throws { Error } If source vector is not a Long, not a VectorAdapter.
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function map( dst, src, onEach )
{

  if( arguments.length < 3 || _.routineIs( arguments[ 1 ] ) )
  {
    src = arguments[ 0 ];
    onEach = arguments[ 1 ];
    _.assert( arguments[ 2 ] === undefined );
  }

  if( onEach === undefined || onEach === null )
  onEach = onEach0;

  if( dst === null )
  dst = this.make( src.length );

  let l = src.length;

  _.assert( 1 <= arguments.length && arguments.length <= 3 );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.routineIs( onEach ) );
  _.assert( src.length === dst.length );
  _.assert( _.intIs( l ) );

  for( let i = 0 ; i < l ; i++ )
  {
    let r = onEach( src.eGet( i ), i, src, dst );
    if( r !== undefined )
    dst.eSet( i, r );
  }

  return dst;

  /* */

  function onEach0( e, k, src, dst )
  {
  }
}

dop = map.operation = Object.create( null );
dop.input = 'vw|n ?vr ?s';
dop.scalarWise = true;
dop.homogeneous = false;
dop.takingArguments = [ 1, 3 ];
dop.takingVectors = [ 1, 2 ];
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = true;
dop.modifying = true;

//

/**
 * Routine filter() provides filtering of elements in destination vector {-dst-} using results of execution {-onEach-} callback.
 *
 * @example
 * var src = [ 1, 2, 3 ];
 * var got = _.avector.filter( src, [ 3, 2, 1 ], ( e ) => k );
 * console.log( got );
 * // log [ 0, 1, 2 ];
 * console.log( got === dst );
 * // log true
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Function } onEach - Callback. Accepts element of {-src-}, element index, {-src-} and {-dst-}.
 * @returns { Long|VectorAdapter } - Returns original destination vector without filtered elements.
 * @function filter
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If destination vector is not a Long, not a VectorAdapter.
 * @throws { Error } If source vector is not a Long, not a VectorAdapter.
 * @throws { Error } If dst.length and src.length are different.
 * @throws { Error } If {-dst-} and {-src-} is the same vector and it has filtered elements.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function filter( dst, src, onEach )
{

  if( arguments.length < 3 || _.routineIs( arguments[ 1 ] ) )
  {
    src = dst;
    onEach = arguments[ 1 ];
    _.assert( arguments[ 2 ] === undefined );
  }

  if( onEach === undefined || onEach === null )
  onEach = onEach0;

  if( dst === null )
  dst = this.make( src.length );

  let l = src.length;

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.routineIs( onEach ) );
  _.assert( _.intIs( l ) );

  if( src === dst )
  {
    let dsti = 0;
    for( let i = 0 ; i < l ; i++ )
    {
      let r = onEach( src.eGet( i ), i, src, dst );
      if( r === undefined )
      continue;
      dst.eSet( dsti, r );
      dsti += 1;
    }
    if( dst.length !== dsti )
    throw _.err( `Length of destination container is ${dst.length}, but filtering preserved only ${dsti} elements` );
  }
  else
  {
    let dsti = 0;
    for( let i = 0 ; i < l ; i++ )
    {
      let r = onEach( src.eGet( i ), i, src, dst );
      if( r === undefined )
      continue;
      dst.eSet( dsti, r );
      dsti += 1;
    }
    if( dst.length !== dsti )
    dst = dst.onlyAdapter([ 0, dsti-1 ]);
  }

  return dst;

  function onEach0( e, k, src, dst )
  {
    return e;
  }
}

dop = filter.operation = Object.create( null );
dop.input = 'vw|n ?vr ?s';
dop.scalarWise = true;
dop.homogeneous = false;
dop.takingArguments = [ 1, 3 ];
dop.takingVectors = [ 1, 2 ];
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = true;
dop.modifying = true;

//

/**
 * Routine _while() provides replacing of elements in destination vector {-dst-} using results of execution {-onEach-} callback.
 *
 * @example
 * var src = [ 1, 2, 3 ];
 * var got = _.avector._while( src, [ 3, 2, 1 ], ( e ) => e );
 * console.log( got );
 * // log [ 3, 2, 1 ];
 * console.log( got === dst );
 * // log true
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Function } onEach - Callback. Accepts element of {-src-}, element index, {-src-} and {-dst-}.
 * @returns { Long|VectorAdapter } - Returns original destination vector with replaced elements.
 * @function _while
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If destination vector is not a Long, not a VectorAdapter.
 * @throws { Error } If source vector is not a Long, not a VectorAdapter.
 * @throws { Error } If {-onEach-} at least once returns undefined.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function _while( dst, src, onEach )
{

  if( arguments.length < 3 || _.routineIs( arguments[ 1 ] ) )
  {
    src = dst;
    onEach = arguments[ 1 ];
    _.assert( arguments[ 2 ] === undefined );
  }

  if( onEach === undefined || onEach === null )
  onEach = onEach0;

  if( dst === null )
  dst = this.make( src.length );

  let l = src.length;

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.routineIs( onEach ) );
  _.assert( _.intIs( l ) );

  if( src === dst )
  {
    let dsti = 0;
    for( let i = 0 ; i < l ; i++ )
    {
      let r = onEach( src.eGet( i ), i, src, dst );
      if( r === undefined )
      break;
      dst.eSet( dsti, r );
      dsti += 1;
    }
    if( dst.length !== dsti )
    throw _.err( `Length of destination container is ${dst.length}, but filtering preserved only ${dsti} elements` );
  }
  else
  {
    let dsti = 0;
    for( let i = 0 ; i < l ; i++ )
    {
      let r = onEach( src.eGet( i ), i, src, dst );
      if( r === undefined )
      break;
      dst.eSet( dsti, r );
      dsti += 1;
    }
    if( dst.length !== dsti )
    dst = dst.onlyAdapter([ 0, dsti-1 ]);
  }

  return dst;

  function onEach0( e, k, src, dst )
  {
    return e;
  }
}

dop = _while.operation = Object.create( null );
dop.input = 'vw|n ?vr ?s';
dop.scalarWise = true;
dop.homogeneous = false;
dop.takingArguments = [ 1, 3 ];
dop.takingVectors = [ 1, 2 ];
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = true;
dop.modifying = true;

// --
// not scalar-wise : self
// --

/**
 * Routine sort() sorts elements of destination vector {-dst-} using callback {-comparator-}.
 *
 * @example
 * var got = _.avector.map( [ 3, 2, 1 ] );
 * console.log( got );
 * // log [ 1, 2, 3 ];
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Function } comparator - Callback to compare two values.
 * @returns { Long|VectorAdapter } - Returns original destination vector with sorted elements.
 * @function sort
 * @throws { Error } If {-comparator-} is not a routine, not undefined.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function sort( dst, comparator )
{
  let length = dst.length;

  if( !comparator )
  comparator = function( a, b ){ return a-b };

  _sort( 0, length-1 );

  return dst;

  function _sort( left, right )
  {

    if( left >= right )
    return;

    let m = Math.floor( ( left+right ) / 2 );
    let mValue = dst.eGet( m );
    let l = left;
    let r = right;

    do
    {

      while( comparator( dst.eGet( l ), mValue ) < 0 )
      l += 1;

      while( comparator( dst.eGet( r ), mValue ) > 0 )
      r -= 1;

      if( l <= r )
      {
        let v = dst.eGet( l );
        dst.eSet( l, dst.eGet( r ) );
        dst.eSet( r, v );
        r -= 1;
        l += 1;
      }

    }
    while( l <= r );

    _sort( left, r );
    _sort( l, right );

  }

}

dop = sort.operation = Object.create( null );
dop.input = 'vw ?s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * Routine randomInRadius() replaces elements of destination vector {-dst-} by random values.
 * This values are less of equal to square root of radius {-radius-}.
 *
 * @example
 * var got = _.avector.randomInRadius( [ 3, 2, 1 ], 5 );
 * console.log( got );
 * // log [ -1.9156929300523022, 1.877215370279174, -0.7458539339998151 ];
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Number|Map } radius - Defines the upper range of random values.
 * @returns { Long|VectorAdapter } - Returns original destination vector with random values.
 * @function randomInRadius
 * @throws { Error } If {-radius-} or {-radius.radius-} is not a Number.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function randomInRadius( dst, radius )
{
  let length = dst.length;
  let o = Object.create( null );

  if( _.object.isBasic( radius ) )
  {
    o = radius;
    radius = o.radius;
  }

  if( o.attempts === undefined )
  o.attempts = 32;

  _.assert( _.numberIs( radius ) );

  let radiusSqrt = sqrt( radius );
  let radiusSqr = _sqr( radius );
  let attempts = o.attempts;
  for( let a = 0 ; a < attempts ; a++ )
  {

    this.randomInRangeAssigning( dst, -radiusSqrt, +radiusSqrt ); /* Dmytro : routine randomInRadiusAssigning does not exists */
    // this.randomInRange( dst, -radiusSqrt, +radiusSqrt );
    let m = this.magSqr( dst );
    if( m < radiusSqr ) break;

  }

  return dst;
}

dop = randomInRadius.operation = Object.create( null );
dop.input = 'vw s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 2, 2 ];
dop.takingVectors = [ 1, 1 ];
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

// function crossWithPoints( a, b, c, result )

/**
 * Routine crossWithPoints() provides cross multiplication of three 3-elements vectors.
 * The result of multiplications stores in destination vector {-dst-}.
 *
 * @example
 * var dst = [ 1, 2, 3 ];
 * var got = _.avector.crossWithPoints( dst, [ 1, 1, 1 ], [ 2, 2, 2 ], [ 3, 3, 3 ] );
 * console.log( got );
 * // log [ 0, 0, 0 ];
 * console.log( got === dst );
 * // log true
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Long|VectorAdapter } a - First vector.
 * @param { Long|VectorAdapter } b - Second vector.
 * @param { Long|VectorAdapter } c - Third vector.
 * @returns { Long|VectorAdapter } - Returns original destination vector with results of multiplications.
 * @function crossWithPoints
 * @throws { Error } If arguments.length is less or more then four.
 * @throws { Error } If {-a-}, {-b-}, {-c-} lengths are different and not equal to 3.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function crossWithPoints( dst, a, b, c )
{
  _.assert( arguments.length === 4 );
  _.assert( a.length === 3 && b.length === 3 && c.length === 3, 'Implemented only for 3D' );

  //_.assert( 0, 'not tested' );
  dst = dst || this.make( 3 );
  // dst = dst || this.longType.long.make( 3 );

  let ax = a.eGet( 0 )-c.eGet( 0 ), ay = a.eGet( 1 )-c.eGet( 1 ), az = a.eGet( 2 )-c.eGet( 2 );
  let bx = b.eGet( 0 )-c.eGet( 0 ), by = b.eGet( 1 )-c.eGet( 1 ), bz = b.eGet( 2 )-c.eGet( 2 );

  dst.eSet( 0, ay * bz - az * by );
  dst.eSet( 1, az * bx - ax * bz );
  dst.eSet( 2, ax * by - ay * bx );

  return dst;
}

dop = crossWithPoints.operation = Object.create( null );
dop.input = 'vw|n vr vr vr';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 4, 4 ];
dop.takingVectors = [ 4, 4 ];
dop.takingVectorsOnly = true;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

function _cross3( dst, src1, src2 )
{

  let src1x = src1.eGet( 0 );
  let src1y = src1.eGet( 1 );
  let src1z = src1.eGet( 2 );

  let src2x = src2.eGet( 0 );
  let src2y = src2.eGet( 1 );
  let src2z = src2.eGet( 2 );

  // dst = dst || this.make( 3 );

  dst.eSet( 0, src1y * src2z - src1z * src2y );
  dst.eSet( 1, src1z * src2x - src1x * src2z );
  dst.eSet( 2, src1x * src2y - src1y * src2x );

  return dst;
}

dop = _cross3.operation = Object.create( null );
dop.input = 'vw|n vr vr';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 3;
dop.takingVectors = 3;
dop.takingVectorsOnly = true;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * Routine cross3() provides cross multiplication of two 3-elements vectors.
 * The result of multiplications stores in destination vector {-dst-}.
 *
 * @example
 * var dst = [ 1, 2, 3 ];
 * var got = _.avector.cross3( dst, [ 2, 2, 2 ], [ 3, 3, 3 ] );
 * console.log( got );
 * // log [ 0, 0, 0 ];
 * console.log( got === dst );
 * // log true
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Long|VectorAdapter } src1 - First vector.
 * @param { Long|VectorAdapter } src1 - Second vector.
 * @returns { Long|VectorAdapter } - Returns original destination vector with results of multiplications.
 * @function cross3
 * @throws { Error } If arguments.length is not equal to three.
 * @throws { Error } If {-dst-}, {-src1-}, {-src2-} lengths are not equal to 3.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function cross3( dst, src1, src2 )
{

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( dst.length === 3, 'Implemented only for 3D' );
  _.assert( src1.length === 3, 'Implemented only for 3D' );
  _.assert( src2.length === 3, 'Implemented only for 3D' );

  dst = dst || this.make( 3 );

  dst = this.from( dst );
  src1 = this.from( src1 );
  src2 = this.from( src2 );

  return this._cross3( dst, src1, src2 );
}

dop = cross3.operation = _.props.extend( null, _cross3.operation );

//

/**
 * Routine cross() provides cross multiplication of a set of 3-elements vectors.
 * The result of multiplications stores in destination vector {-dst-}.
 *
 * @example
 * var dst = [ 1, 2, 3 ];
 * var got = _.avector.cross( dst, [ 2, 2, 2 ], [ 3, 3, 3 ], [ 4, 4, 4 ] );
 * console.log( got );
 * // log [ 72, -144, 72 ]
 * console.log( got === dst );
 * // log true
 *
 * @param { Null|Long|VectorAdapter } dst - Destination vector.
 * @param { Long|VectorAdapter } ... - Vectors.
 * @returns { Long|VectorAdapter } - Returns original destination vector with results of multiplications.
 * @function cross
 * @throws { Error } If arguments.length is less then two.
 * @throws { Error } If dst length is not equal to 3.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function cross( dst )
{
  let first = 1;

  if( arguments.length === 2 )
  {
    first = 1;
    dst = arguments[ 0 ].clone();
  }
  else if( dst === null )
  {
    dst = arguments[ 1 ].clone();
    first = 2;
    _.assert( arguments.length >= 3, 'Expects at least three arguments' );
  }

  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  _.assert( dst.length === 3, 'Implemented only for 3D' );

  for( let a = first ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    _.assert( src.length === 3, 'Implemented only for 3D' );
    this._cross3( dst, dst, src );
  }

  return dst;
}

dop = cross.operation = Object.create( null );
dop.input = '?vw|?n vr *vr';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 1, Infinity ];
dop.takingVectors = [ 1, Infinity ];
dop.takingVectorsOnly = true;
dop.returningSelf = true;
dop.returningNew = true;
dop.modifying = true;

//

/**
 * Routine quaternionApply() replaces elements of destination vector {-dst-} by its quaternion images.
 *
 * @example
 * var dst = [ 1, 2, 3 ];
 * var got = _.avector.quaternionApply( dst, [ 2, 2, 2, 2 ] );
 * console.log( got );
 * // log [ 48, 16, 32 ]
 * console.log( got === dst );
 * // log true
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Long|VectorAdapter } q - Vector of quaternion basis elements.
 * @returns { Long|VectorAdapter } - Returns original destination vector with results of transformation.
 * @function quaternionApply
 * @throws { Error } If dst.length is not equal to 3.
 * @throws { Error } If q.length is not equal to 4.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function quaternionApply( dst, q )
{

  _.assert( dst.length === 3 && q.length === 4, 'quaternionApply :', 'Expects vector and quaternion as arguments' );

  let x = dst.eGet( 0 );
  let y = dst.eGet( 1 );
  let z = dst.eGet( 2 );

  let qx = q.eGet( 1 );
  let qy = q.eGet( 2 );
  let qz = q.eGet( 3 );
  let qw = q.eGet( 0 );

  /* */

  let ix = + qw * x + qy * z - qz * y;
  let iy = + qw * y + qz * x - qx * z;
  let iz = + qw * z + qx * y - qy * x;
  let iw = - qx * x - qy * y - qz * z;

  /* */

  dst.eSet( 0, ix * qw + iw * - qx + iy * - qz - iz * - qy );
  dst.eSet( 1, iy * qw + iw * - qy + iz * - qx - ix * - qz );
  dst.eSet( 2, iz * qw + iw * - qz + ix * - qy - iy * - qx );

  /* */

/*
  clone.quaternionApply2( q );
  let err = clone.distanceSqr( this );
  if( abs( err ) > 0.0001 )
  throw _.err( 'Vector :', 'Something wrong' );
*/

  /* */

  return dst;
}

dop = quaternionApply.operation = Object.create( null );
dop.input = 'vw vr';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 2;
dop.takingVectors = 2;
dop.takingVectorsOnly = true;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * Routine quaternionApply2() replaces elements of destination vector {-dst-} by its quaternion images.
 *
 * @example
 * var dst = [ 1, 2, 3 ];
 * var got = _.avector.quaternionApply2( dst, [ 2, 2, 2, 2 ] );
 * console.log( got );
 * // log [ 48, 16, 32 ]
 * console.log( got === dst );
 * // log true
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Long|VectorAdapter } q - Vector of quaternion basis elements.
 * @returns { Long|VectorAdapter } - Returns original destination vector with results of transformation.
 * @function quaternionApply2
 * @throws { Error } If dst.length is not equal to 3.
 * @throws { Error } If q.length is not equal to 4.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

/*
v' = q * v * conjugate(q)
--
t = 2 * cross(q.xyz, v)
v' = v + q.w * t + cross(q.xyz, t)
*/

function quaternionApply2( dst, q )
{

  _.assert( dst.length === 3 && q.length === 4, 'quaternionApply :', 'Expects vector and quaternion as arguments' );
  let qvector = this.fromLongLrange( dst, 0, 3 );

  let cross1 = this.cross( qvector, dst );
  this.mul( cross1, 2 );

  let cross2 = this.cross( qvector, cross1 );
  this.mul( cross1, q.eGet( 3 ) );

  dst.eSet( 0, dst.eSet( 0 ) + cross1.eGet( 0 ) + cross2.eGet( 0 ) );
  dst.eSet( 1, dst.eGet( 1 ) + cross1.eGet( 1 ) + cross2.eGet( 1 ) );
  dst.eSet( 2, dst.eGet( 2 ) + cross1.eGet( 2 ) + cross2.eGet( 2 ) );

  return dst;
}

dop = quaternionApply2.operation = Object.create( null );
dop.input = 'vw vr';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 2;
dop.takingVectors = 2;
dop.takingVectorsOnly = true;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

function eulerApply( v, e )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  throw _.err( 'not implemented' )

}

dop = eulerApply.operation = Object.create( null );
dop.input = 'vw vr';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 2;
dop.takingVectors = 2;
dop.takingVectorsOnly = true;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * Routine reflect() calculate the reflection direction for an incident vector {-src-} and surface normal {-normal-}.
 * Reflection calculated as I - 2.0 * dot(N, I) * N where I {-src-} and N {-normal-}
 * Expected {-normal-} in normalized form.
 *
 * @example
 * let src = this.fromLong( [ -1, -2, -3 ] )
 * let got = _.avector.reflect( src, _.vector.normalize( [ 1, 1, 1 ] ) );
 * console.log( got );
 * // log [ 3, 2, 1 ];
 * console.log( src );
 * // log [ 3, 2, 1 ];
 *
 * let dst = this.fromLong( [ 0, 0, 0 ] )
 * let src = this.fromLong( [ -1, -2, -3 ] )
 * let got = _.avector.reflect( dst, src, _.vector.normalize( [ 1, 1, 1 ] ) );
 * console.log( got );
 * // log [ 3, 2, 1 ];
 * console.log( dst );
 * // log [ 3, 2, 1 ];
 * console.log( src );
 * // log [ -1, -2, -3 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Container for result.
 * @param { Long|VectorAdapter } src - Incident vector.
 * @param { Long|VectorAdapter } normal - Normal vector. Should be normalized.
 * @returns { Long|VectorAdapter } - Returns reflection direction for an incident vector.
 * @function reflect
 * @throws { Error } If arguments.length is not equal two or three.
 * @throws { Error } If {-src-} and {-normal-} are not vectors.
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-dst-} and {-src-} are different length.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function reflect( dst, src, normal )
{

  if( arguments.length === 2 )
  {
    normal = arguments[ 1 ];
    src = arguments[ 0 ];
  }
  if( dst === null )
  dst = this.MakeSimilar( src );

  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects exactly two or three arguments' );
  _.assert( dst.length === src.length );
  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( _.vectorAdapterIs( normal ) );

  // throw _.err( 'not tested' ); /* qqq : cover */

  let result = this.sub( null, src, this.mul( null, normal, 2 * this.dot( src, normal ) ) );
  if( arguments.length === 2 )
  {
    src.assign( result );
    return src;
  }
  else if( arguments.length === 3 )
  {
    dst.assign( result );
    return dst;
  }

}

dop = reflect.operation = Object.create( null );
dop.input = '?vw|?n vr vr';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 2, 3 ];
dop.takingVectors = [ 2, 3 ];
dop.takingVectorsOnly = true;
dop.returningSelf = true;
dop.returningNew = true;
dop.modifying = true;

//

/**
 * Routine refract() calculate the refraction direction for an incident {-src-} vector, surface normal {-normal-}, and ratio of indices of refraction {-eta-}.
 * Expected {-eta-} as ratio between medium with incident {-src-} vector and medium of reflected vector.
 * For example, {-eta-} for vector passing from air to glass will be 1 / 1.6, in opposite direction is 1.6/1.
 * Expected incident {-src-} vector and surface normal {-normal-} in normalized form.
 * If there is total internal reflection returned zero vector.
 *
 * @example
 * let src = _.vector.normalize( [ 0, 1, -1 ] )
 * let got = _.avector.refract( src, [ 0, 0, 1 ], 1/1.6 );
 * console.log( got );
 * // log [ 0, 0.44194173824159216, -0.8970437647041472 ];
 * console.log( src );
 * // log [ 0, 0.44194173824159216, -0.8970437647041472 ];
 *
 * let dst = this.fromLong( [ 0, 0, 0 ] )
 * let src = _.vector.normalize( [ 0, 1, -1 ] )
 * let got = _.avector.refract( src, [ 0, 0, 1 ], 1/1.6 );
 * console.log( got );
 * // log [ 0, 0.44194173824159216, -0.8970437647041472 ];
 * console.log( dst );
 * // log [ 0, 0.44194173824159216, -0.8970437647041472 ];
 * console.log( src );
 * // log [ 0, 0.7071067811865475, -0.7071067811865475 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Container for result.
 * @param { Long|VectorAdapter } src - Incident vector. Should be normalized.
 * @param { Long|VectorAdapter } normal - Normal vector. Should be normalized.
 * @param { Number } eta - Ratio of indices of refraction. Numerator is index of medium with incident vector.
 * @returns { Long|VectorAdapter } - Returns refraction direction for an incident vector.
 * @function refract
 * @throws { Error } If arguments.length is not equal three or four.
 * @throws { Error } If {-src-} and {-normal-} are not vectors.
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-eta-} is not number.
 * @throws { Error } If {-dst-} and {-src-} are different length.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function refract() // dst, src, normal, eta
{
  let dst, src, normal, eta;
  if( arguments.length === 4 )
  {
    eta = arguments[ 3 ];
    normal = arguments[ 2 ];
    src = arguments[ 1 ];
    dst = arguments[ 0 ];
  }
  else if( arguments.length === 3 )
  {
    eta = arguments[ 2 ];
    normal = arguments[ 1 ];
    src = arguments[ 0 ];
    dst = arguments[ 0 ];
  }
  if( dst === null )
  {
    dst = this.MakeSimilar( src );
  }

  _.assert( arguments.length === 3 || arguments.length === 4, 'Expects exactly three or four arguments' );
  _.assert( dst.length === src.length );
  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( _.vectorAdapterIs( normal ) );
  _.assert( _.numberIs( eta ) );

  // Compute squared sin of transmitted angle using Snell's law
  const cosi = this.dot( src, normal );
  const sin2t = eta * eta * ( 1 - cosi * cosi );

  let result;
  // handle total internal reflection
  if( sin2t >= 1 )
  {
    result = this.MakeSimilar( src );
    this.assign( result, 0 );
  }
  else
  {
    const cost = sqrt( 1 - sin2t );
    result = this.sub( null, this.mul( null, src, eta ), this.mul( null, normal, eta * cosi + cost ) );
  }

  if( arguments.length === 3 )
  {
    src.assign( result );
    return src;
  }
  else if( arguments.length === 4 )
  {
    dst.assign( result );
    return dst;
  }

}

dop = refract.operation = Object.create( null );
dop.input = '?vw|?n vr vr s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = [ 3, 4 ];
dop.takingVectors = [ 2, 3 ];
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = true;
dop.modifying = true;

//

/**
 * The routine matrixApplyTo() applies the provided source matrix {-srcMatrix-} to destination vector {-dst-}.
 *
 * @example
 * var srcMatrix = _.Matrix.Make( [ 2, 2 ] ).copy( [ 1, 2, 3, 4 ] );
 * var got = _.avector.matrixApplyTo( [ 1, 1 ], srcMatrix );
 * console.log( got );
 * // log [ 3, 7 ]
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Matrix } srcMatrix - Source matrix.
 * @returns { Long|VectorAdapter } - Returns vector with changed values.
 * @function matrixApplyTo
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If dimensions of matrix is not equivalent.
 * @throws { Error } If dimensions are different to dst.length.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function matrixApplyTo( dst, srcMatrix ) /* xxx : move out? */
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.matrixIs( srcMatrix ) );
  debugger;
  // return _.space.mul( dst, [ srcMatrix, dst ] ); /* Dmytro : old namespace */
  return _.Matrix.Mul( dst, [ srcMatrix, dst ] );
}

dop = matrixApplyTo.operation = Object.create( null );
dop.input = 'vr mw';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 2;
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * The routine matrixHomogenousApply() applies the homogenous source matrix {-srcMatrix-} to provided vector {-dst-},
 * returns the instance of the vector.
 *
 * @example
 * var srcMatrix = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   4, 0, 1,
 *   0, 5, 2,
 *   0, 0, 1,
 * ]);
 * var got = _.avector.matrixHomogenousApply( [ 0, 0 ], srcMatrix );
 * console.log( got );
 * // log [ 1, 2 ]
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Matrix } srcMatrix - Source matrix.
 * @returns { Long|VectorAdapter } - Returns vector with changed values.
 * @function matrixHomogenousApply
 * @throws { Error } If arguments.length is not equal to two.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function matrixHomogenousApply( dst, srcMatrix ) /* xxx : move out? */
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.matrixIs( srcMatrix ) );
  return srcMatrix.matrixHomogenousApply( dst );
}

dop = matrixHomogenousApply.operation = Object.create( null );
dop.input = 'vr mw';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 2;
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * The routine matrixDirectionsApply() applies the directions of source matrix {-srcMatrix-} to provided vector {-dst-},
 * returns the instance of the vector.
 *
 * @example
 * var matrix = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   4, 0, 1,
 *   0, 5, 2,
 *   0, 0, 1,
 * ]);
 * var got = _.avector.matrixDirectionsApply( [ 0, 0 ], srcMatrix );
 * console.log( got );
 * // log [ 1, 2 ]
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Matrix } srcMatrix - Source matrix.
 * @returns { Long|VectorAdapter } - Returns vector with changed values.
 * @function matrixDirectionsApply
 * @throws { Error } If arguments.length is not equal to two.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function matrixDirectionsApply( v, m )
{
  _.assrt( arguments.length === 2 );
  m.matrixDirectionsApply( v );
  return v;
}

dop = matrixDirectionsApply.operation = Object.create( null );
dop.input = 'vr mw';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 2;
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * Routine swapVectors() swaps content of two vectors.
 *
 * @example
 * var src1 = [ 1, 2, 3 ];
 * var src2 = [ 4, 5, 6 ];
 * var got = _.avector.swapVectors( src1, src2 );
 * console.log( src1 );
 * // log [ 4, 5, 6 ];
 * var got = _.avector.swapVectors( src1, src2 );
 * console.log( src2 );
 * // log [ 1, 2, 3 ];
 *
 * @param { Long|VectorAdapter } v1 - Vector.
 * @param { Long|VectorAdapter } v2 - Vector.
 * @returns { Undefined } - Returns not a value, swaps two vectors.
 * @function swapVectors
 * @throws { Error } If arguments.length is less or more then two.
 * @throws { Error } If v1.length and v2.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function swapVectors( v1, v2 )
{

  _.assert( arguments.length === 2 );
  _.assert( v1.length === v2.length );

  for( let i = 0 ; i < v1.length ; i++ )
  {
    let val = v1.eGet( i );
    v1.eSet( i, v2.eGet( i ) );
    v2.eSet( i, val );
  }

}

dop = swapVectors.operation = Object.create( null );
dop.input = 'vw vw';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 2;
dop.takingVectors = 2;
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * Routine scalarsSwap() swaps elements of vector {-v-}.
 *
 * @example
 * var got = _.avector.scalarsSwap( [ 1, 2, 3 ], 0, 2 );
 * console.log( got );
 * // log [ 3, 2, 1 ];
 *
 * @param { Long|VectorAdapter } v1 - Vector.
 * @param { Number } i1 - Index of first element.
 * @param { Number } i2 - Index of second element.
 * @returns { Long|VectorAdapter } - Returns vector {-v-}.
 * @function scalarsSwap
 * @throws { Error } If arguments.length is less or more then three.
 * @throws { Error } If i1 or i2 are out of ranges of vector {-v-}.
 * @throws { Error } If i1 or i2 are not Number.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function scalarsSwap( v, i1, i2 )
{

  _.assert( arguments.length === 3 );
  _.assert( 0 <= i1 && i1 < v.length );
  _.assert( 0 <= i2 && i2 < v.length );
  _.assert( _.numberIs( i1 ) );
  _.assert( _.numberIs( i2 ) );

  let val = v.eGet( i1 );
  v.eSet( i1, v.eGet( i2 ) );
  v.eSet( i2, val );

  return v;
}

dop = scalarsSwap.operation = Object.create( null );
dop.input = 'vw s s';
dop.scalarWise = false;
dop.homogeneous = false;
dop.takingArguments = 3;
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;

//

/**
 * Routine formate() replaces elements of destination vector {-dst-} by values from source elements in container {-srcs-}.
 *
 * @example
 * var got = _.avector.formate( [ 1, 2, 3, 4, 5, 6 ], [ 0, 1 );
 * console.log( got );
 * // log [ 0, 1, 0, 1, 0, 1 ];
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @param { Array } srcs - Source container with elements.
 * @returns { Long|VectorAdapter } - Returns destination vector with replaced elements.
 * @function formate
 * @throws { Error } If {-srcs-} is not an Array.
 * @throws { Error } If dst.length / srcs.length is not an Integer.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function formate( dst, srcs )
{
  let ape = srcs.length;
  let l = dst.length / ape;

  _.assert( _.arrayIs( srcs ) );
  _.assert( _.intIs( l ) );

  // debugger;

  for( let a = 0 ; a < ape ; a++ )
  {
    let src = srcs[ a ];

    if( _.numberIs( src ) )
    {
      for( let i = 0 ; i < l ; i++ )
      dst.eSet( i*ape+a , src );
    }
    else
    {
      src = this.from( src );
      _.assert( src.length === l );
      for( let i = 0 ; i < l ; i++ )
      dst.eSet( i*ape+a , src.eGet( i ) );
    }
  }

  // debugger;
  return dst;
}

dop = formate.operation = Object.create( null );
dop.input = 'vw !vw';
dop.takingArguments = 2;
dop.takingVectors = 1;
dop.takingVectorsOnly = false;
dop.returningSelf = true;
dop.returningNew = false;
dop.modifying = true;
dop.reducing = false;
dop.homogeneous = false;

// --
// scalar-wise, modifying, taking single vector : self
// --

/**
 * Routine inv() replaces elements of vector {-dst-} by inverted values of vector {-src-}.
 *
 * @example
 * let got = _.avector.inv( [ 0.25, 0.5, 1, 0 ] );
 * console.log( got );
 * // log [ 4, 2, 1, Infinity ];
 *
 * let src = [ 0.25, 0.5, 1 ]
 * let got = _.avector.inv( src );
 * console.log( got );
 * // log [ 4, 2, 1 ];
 * console.log( src );
 * // log [ 4, 2, 1 ];
 *
 * let src = [ 0.25, 0.5, 1 ]
 * let got = _.avector.inv( null, src );
 * console.log( got );
 * // log [ 4, 2, 1 ];
 * console.log( src );
 * // log [ 0.25, 0.5, 1 ];

 * let dst = [ 0, 0, 0 ]
 * let src = [ 0.25, 0.5, 1 ]
 * let got = _.avector.inv( dst, src );
 * console.log( got );
 * // log [ 4, 2, 1 ];
 * console.log( dst );
 * // log [ 4, 2, 1 ];
 * console.log( src );
 * // log [ 0.25, 0.5, 1 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns destination vector with replaced elements.
 * @function inv
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-src-} is not vector.
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let inv = meta._operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function _inv( dst, src, i )
  {
    dst.eSet( i, 1 / src.eGet( i ) );
  }
});

//

/**
 * Routine invOrOne() replaces elements of vector {-dst-} by inverted values of vector {-src-}. If {-src-} element is 0, then element with its index sets to 1.
 *
 * @example
 * let got = _.avector.invOrOne( [ 0.25, 0.5, 1, 0 ] );
 * console.log( got );
 * // log [ 4, 2, 1, 1 ];
 *
 * let src = [ 0.25, 0.5, 1 ]
 * let got = _.avector.invOrOne( src );
 * console.log( got );
 * // log [ 4, 2, 1 ];
 * console.log( src );
 * // log [ 4, 2, 1 ];
 *
 * let src = [ 0.25, 0.5, 1 ]
 * let got = _.avector.invOrOne( null, src );
 * console.log( got );
 * // log [ 4, 2, 1 ];
 * console.log( src );
 * // log [ 0.25, 0.5, 1 ];

 * let dst = [ 0, 0, 0 ]
 * let src = [ 0.25, 0.5, 1 ]
 * let got = _.avector.invOrOne( dst, src );
 * console.log( got );
 * // log [ 4, 2, 1 ];
 * console.log( dst );
 * // log [ 4, 2, 1 ];
 * console.log( src );
 * // log [ 0.25, 0.5, 1 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns destination vector with replaced elements.
 * @function invOrOne
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-src-} is not vector.
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let invOrOne = meta._operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function _invOrOne( dst, src, i )
  {
    if( src.eGet( i ) === 0 )
    dst.eSet( i, 1 );
    else
    dst.eSet( i, 1 / src.eGet( i ) );
  }
});

//

/**
 * Routine absRoutine() replaces elements of vector {-dst-} by elements of vector {-src-} with absolute values.
 *
 * @example
 * let got = _.avector.absRoutine( [ -2, 3, -1, 0 ] );
 * console.log( got );
 * // log [ 2, 3, 1, 0 ];
 *
 * let src = [ -2, 3, -1, 0 ]
 * let got = _.avector.absRoutine( src );
 * console.log( got );
 * // log [ 2, 3, 1, 0 ];
 * console.log( src );
 * // log [ 2, 3, 1, 0 ];
 *
 * let src = [ -2, 3, -1, 0 ]
 * let got = _.avector.absRoutine( null, src );
 * console.log( got );
 * // log [ 2, 3, 1, 0 ];
 * console.log( src );
 * // log [ -2, 3, -1, 0 ];

 * let dst = [ 0, 0, 0, 0 ]
 * let src = [ -2, 3, -1, 0 ]
 * let got = _.avector.absRoutine( dst, src );
 * console.log( got );
 * // log [ 2, 3, 1, 0 ];
 * console.log( dst );
 * // log [ 2, 3, 1, 0 ];
 * console.log( src );
 * // log [ -2, 3, -1, 0 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns destination vector with replaced elements.
 * @function absRoutine
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-src-} is not vector.
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */


let absRoutine = meta._operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function _abs( dst, src, i )
  {
    dst.eSet( i, Math.abs( src.eGet( i ) ) );
  }
});

//

/**
 * Routine floor() replaces elements of vector {-dst-} by elements of vector {-src-} that rounded to smaller values.
 *
 * @example
 * var got = _.avector.floor( [ 1, 2, 4 ], [ 1.25, 2.5, 1.7, -1.4 ] );
 * console.log( got );
 * // log [ 1, 2, 1, -2 ];
 * let got = _.avector.floor( [ 1.25, 2.5, 1.7, -1.4 ] );
 * console.log( got );
 * // log [ 1, 2, 1, -2 ];
 *
 * let src = [ 1.25, 2.5, 1.7, -1.4 ]
 * let got = _.avector.floor( src );
 * console.log( got );
 * // log [ 1, 2, 1, -2 ];
 * console.log( src );
 * // log [ 1, 2, 1, -2 ];
 *
 * let src = [ 1.25, 2.5, 1.7, -1.4 ]
 * let got = _.avector.floor( null, src );
 * console.log( got );
 * // log [ 1, 2, 1, -2 ];
 * console.log( src );
 * // log [ 1.25, 2.5, 1.7, -1.4 ];

 * let dst = [ 0, 0, 0, 0 ]
 * let src = [ 1.25, 2.5, 1.7, -1.4 ]
 * let got = _.avector.floor( dst, src );
 * console.log( got );
 * // log [ 1, 2, 1, -2 ];
 * console.log( dst );
 * // log [ 1, 2, 1, -2 ];
 * console.log( src );
 * // log [ 1.25, 2.5, 1.7, -1.4 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns destination vector with replaced elements.
 * @function floorRoutine
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-src-} is not vector.
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */


let floorRoutine = meta._operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function _floor( dst, src, i )
  {
    dst.eSet( i, Math.floor( src.eGet( i ) ) );
  }
});

//

/**
 * Routine ceil() replaces elements of vector {-dst-} by elements of vector {-src-} that rounded to bigger values.
 *
 * @example
 * var got = _.avector.ceil( [ 1, 2, 4 ], [ 1.25, 2.5, 1.7, -1.4 ] );
 * console.log( got );
 * // log [ 2, 3, 2, -1 ];
 * let got = _.avector.ceil( [ 1.25, 2.5, 1.7, -1.4 ] );
 * console.log( got );
 * // log [ 2, 3, 2, -1 ];
 *
 * let src = [ 1.25, 2.5, 1.7, -1.4 ]
 * let got = _.avector.ceil( src );
 * console.log( got );
 * // log [ 2, 3, 2, -1 ];
 * console.log( src );
 * // log [ 2, 3, 2, -1 ];
 *
 * let src = [ 1.25, 2.5, 1.7, -1.4 ]
 * let got = _.avector.ceil( null, src );
 * console.log( got );
 * // log [ 2, 3, 2, -1 ];
 * console.log( src );
 * // log [ 1.25, 2.5, 1.7, -1.4 ];

 * let dst = [ 0, 0, 0, 0 ]
 * let src = [ 1.25, 2.5, 1.7, -1.4 ]
 * let got = _.avector.ceil( dst, src );
 * console.log( got );
 * // log [ 2, 3, 2, -1 ];
 * console.log( dst );
 * // log [ 2, 3, 2, -1 ];
 * console.log( src );
 * // log [ 1.25, 2.5, 1.7, -1.4 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns destination vector with replaced elements.
 * @function ceilRoutine
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-src-} is not vector.
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let ceilRoutine = meta._operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function _ceil( dst, src, i )
  {
    dst.eSet( i, Math.ceil( src.eGet( i ) ) );
  }
});

//

/**
 * Routine round() replaces elements of vector {-dst-} by elements of vector {-src-} with rounded values.
 *
 * @example
 * var got = _.avector.round( [ 1, 2, 4 ], [ 1.25, 2.5, 1.7, -1.4 ] );
 * console.log( got );
 * // log [ 1, 3, 1, -1 ];
 * let got = _.avector.round( [ 1.25, 2.5, 1.7, -1.4 ] );
 * console.log( got );
 * // log [ 1, 3, 1, -1 ];
 *
 * let src = [ 1.25, 2.5, 1.7, -1.4 ]
 * let got = _.avector.round( src );
 * console.log( got );
 * // log [ 1, 3, 1, -1 ];
 * console.log( src );
 * // log [ 1, 3, 1, -1 ];
 *
 * let src = [ 1.25, 2.5, 1.7, -1.4 ]
 * let got = _.avector.round( null, src );
 * console.log( got );
 * // log [ 1, 3, 1, -1 ];
 * console.log( src );
 * // log [ 1.25, 2.5, 1.7, -1.4 ];

 * let dst = [ 0, 0, 0, 0 ]
 * let src = [ 1.25, 2.5, 1.7, -1.4 ]
 * let got = _.avector.round( dst, src );
 * console.log( got );
 * // log [ 1, 3, 1, -1 ];
 * console.log( dst );
 * // log [ 1, 3, 1, -1 ];
 * console.log( src );
 * // log [ 1.25, 2.5, 1.7, -1.4 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns destination vector with replaced elements.
 * @function roundRoutine
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-src-} is not vector.
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let roundRoutine = meta._operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function _round( dst, src, i )
  {
    debugger;
    dst.eSet( i, Math.round( src.eGet( i ) ) );
  }
});

//

/**
 * Routine ceilToPowerOfTwo() replaces elements of vector {-dst-} by elements of vector {-src-} that rounded to closes value power of two.
 *
 * @example
 * let got = _.avector.ceilToPowerOfTwo( [ 3, 5, 13 ] );
 * console.log( got );
 * // log [ 4, 8, 16 ];
 * @example
 * let got = _.avector.ceilToPowerOfTwo( [ 3, 5, 13 ] );
 * console.log( got );
 * // log [ 4, 8, 16 ];
 *
 * let src = [ 3, 5, 13 ]
 * let got = _.avector.ceilToPowerOfTwo( src );
 * console.log( got );
 * // log [ 4, 8, 16 ];
 * console.log( src );
 * // log [ 4, 8, 16 ];
 *
 * let src = [ 3, 5, 13 ]
 * let got = _.avector.ceilToPowerOfTwo( null, src );
 * console.log( got );
 * // log [ 4, 8, 16 ];
 * console.log( src );
 * // log [ 3, 5, 13 ];

 * let dst = [ 0, 0, 0 ]
 * let src = [ 3, 5, 13 ]
 * let got = _.avector.ceilToPowerOfTwo( dst, src );
 * console.log( got );
 * // log [ 4, 8, 16 ];
 * console.log( dst );
 * // log [ 4, 8, 16 ];
 * console.log( src );
 * // log [ 3, 5, 13 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns destination vector with replaced elements.
 * @function ceilToPowerOfTwo
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-src-} is not vector.
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let ceilToPowerOfTwo = meta._operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function _ceil( dst, src, i )
  {
    dst.eSet( i, _.math.ceilToPowerOfTwo( src.eGet( i ) ) );
  }
});

//

/**
 * Routine normalize() replaces elements of vector {-dst-} by elements of vector {-src-} that multiplied on square root of sum of squares of {-src-} elements.
 *
 * @example
 * let got = _.avector.normalize( [ 1, 1, 1 ] );
 * console.log( got );
 * // log [ 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 ];
 *
 * let src = [ 1, 1, 1 ]
 * let got = _.avector.normalize( src );
 * console.log( got );
 * // log [ 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 ];
 * console.log( src );
 * // log [ 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 ];
 *
 * let src = [ 1, 1, 1 ]
 * let got = _.avector.normalize( null, src );
 * console.log( got );
 * // log [ 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 ];
 * console.log( src );
 * // log [ 1, 1, 1 ];

 * let dst = [ 0, 0, 0 ]
 * let src = [ 1, 1, 1 ]
 * let got = _.avector.normalize( dst, src );
 * console.log( got );
 * // log [ 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 ];
 * console.log( dst );
 * // log [ 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 ];
 * console.log( src );
 * // log [ 1, 1, 1 ];
 *
 * @param { Long|VectorAdapter|Null } dst - Destination vector.
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Long|VectorAdapter } - Returns destination vector with replaced elements.
 * @function normalize
 * @throws { Error } If {-dst-} is not null or not vector.
 * @throws { Error } If {-src-} is not vector.
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let _normalizeM;
let normalize = meta._operationTakingDstSrcReturningSelfComponentWise_functor
({
  onVectorsBegin : function normalize( dst, src )
  {
    _normalizeM = this.mag( src );
    if( !_normalizeM )
    _normalizeM = 1;
    _normalizeM = 1 / _normalizeM;
  },
  onEach : function normalize( dst, src, i )
  {
    dst.eSet( i, src.eGet( i ) * _normalizeM );
  },
});

//

function addVectorScalar( dst, src, scalar )
{
  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( _.numberIs( scalar ) );
  _.assert( src.length === dst.length );

  for( let i = 0; i < dst.length; i++ )
  dst.eSet( i, src.eGet( i ) + scalar );
  return dst;
}

// --
// float / vector
// --

// /**
//  * @summary Add vectors `src` and `dst`. Saves result in vector `dst`.
//  * @param {Long|VectorAdapter} dst Destination vector.
//  * @param {Long|VectorAdapter} src Source vector.
//  * @example
//  * var a1 = [ 1, 2, 5, 9 ];
//  * var a2 = [ 1, 2, 3, 4 ];
//  * _.avector.add( a1, a2 );
//  * console.log( 'a1', a1 );
//  * console.log( 'a2', a2 );
//  * //a1 [ 2, 4, 8, 13 ]
//  * //a2 [ 1, 2, 3, 4 ]
//  *
//  * @function add
//  * @namespaces "wTools.avector","wTools.vectorAdapter"
//  * @module Tools/math/Vector
// */
//
// let add = meta._operationReturningSelfTakingVariantsComponentWise_functor
// ({
//   takingArguments : [ 2, Infinity ],
//   input : 'vw +vr|+s',
//   homogenous : 1,
//   onEach : function add( dst, src, i )
//   {
//     let d = dst.eGet( i );
//     let s = src.eGet( i );
//
//     let r = d + s;
//
//     dst.eSet( i, r );
//   }
// });
//
// //
//
// /**
//  * @summary Subtracts vector `src` from vector `dst`. Saves result in vector `dst`.
//  * @param {Long|VectorAdapter} dst Destination vector.
//  * @param {Long|VectorAdapter} src Source vector.
//  * @example
//  * var a1 = [ 1, 2, 5, 9 ];
//  * var a2 = [ 1, 2, 3, 4 ];
//  * _.avector.sub( a1, a2 );
//  * console.log( 'a1', a1 );
//  * console.log( 'a2', a2 );
//  * //a1 [ 0, 0, 2, 5 ]
//  * //a2 [ 1, 2, 3, 4 ]
//  *
//  * @function sub
//  * @namespaces "wTools.avector","wTools.vectorAdapter"
//  * @module Tools/math/Vector
// */
//
// let sub = meta._operationReturningSelfTakingVariantsComponentWise_functor
// ({
//   takingArguments : [ 2, Infinity ],
//   input : 'vw +vr|+s',
//   homogenous : 1,
//   onEach : function sub( dst, src, i )
//   {
//     let d = dst.eGet( i );
//     let s = src.eGet( i );
//
//     let r = d - s;
//
//     dst.eSet( i, r );
//   }
// });
//
// //
//
// /**
//  * @summary Multiplication of vectors `src` and `dst`. Saves result in vector `dst`.
//  * @param {Long|VectorAdapter} dst Destination vector.
//  * @param {Long|VectorAdapter} src Source vector.
//  * @example
//  * var a1 = [ 1, 2, 5, 9 ];
//  * var a2 = [ 1, 2, 3, 4 ];
//  * _.avector.mul( a1, a2 );
//  * console.log( 'a1', a1 );
//  * console.log( 'a2', a2 );
//  * //a1 [1, 4, 15, 36]
//  * //a2 [ 1, 2, 3, 4 ]
//  *
//  * @function mul
//  * @namespaces "wTools.avector","wTools.vectorAdapter"
//  * @module Tools/math/Vector
// */
//
// let mul = meta._operationReturningSelfTakingVariantsComponentWise_functor
// ({
//   takingArguments : [ 2, Infinity ],
//   input : 'vw +vr|+s',
//   homogenous : 1,
//   onMakeIdentity : function( dst )
//   {
//     _.vectorAdapter.assignScalar( dst, 1 );
//   },
//   onEach : function mul( dst, src, i )
//   {
//     let d = dst.eGet( i );
//     let s = src.eGet( i );
//
//     let r = d * s;
//
//     dst.eSet( i, r );
//   }
// });
//
// //
//
// /**
//  * @summary Division of vectors `src` and `dst`. Saves result in vector `dst`.
//  * @param {Long|VectorAdapter} dst Destination vector.
//  * @param {Long|VectorAdapter} src Source vector.
//  * @example
//  * var a1 = [ 1, 4, 9, 16 ];
//  * var a2 = [ 1, 2, 3, 4 ];
//  * _.avector.div( a1, a2 );
//  * console.log( 'a1', a1 );
//  * console.log( 'a2', a2 );
//  * //a1 [1, 2, 3, 4]
//  * //a2 [ 1, 2, 3, 4 ]
//  *
//  * @function div
//  * @namespaces "wTools.avector","wTools.vectorAdapter"
//  * @module Tools/math/Vector
// */
//
// let div = meta._operationReturningSelfTakingVariantsComponentWise_functor
// ({
//   takingArguments : [ 2, Infinity ],
//   input : 'vw +vr|+s',
//   homogenous : 1,
//   onMakeIdentity : function( dst )
//   {
//     debugger;
//     _.vectorAdapter.assignScalar( dst, 1 );
//   },
//   onEach : function div( dst, src, i )
//   {
//     debugger;
//     let d = dst.eGet( i );
//     let s = src.eGet( i );
//
//     let r = d / s;
//
//     dst.eSet( i, r );
//   }
// });
//
// //
//
// /**
//  * @summary Finds minimum values from vectors `src` and `dst`. Saves result in vector `dst`.
//  * @param {Long|VectorAdapter} dst Destination vector.
//  * @param {Long|VectorAdapter} src Source vector.
//  * @example
//  * var a1 = [ 1, 4, 9, 16 ];
//  * var a2 = [ 1, 2, 3, 4 ];
//  * _.avector.min( a1, a2 );
//  * console.log( 'a1', a1 );
//  * console.log( 'a2', a2 );
//  * //a1 [1, 2, 3, 4]
//  * //a2 [ 1, 2, 3, 4 ]
//  *
//  * @function min
//  * @namespaces "wTools.avector","wTools.vectorAdapter"
//  * @module Tools/math/Vector
// */
//
// let min = meta._operationReturningSelfTakingVariantsComponentWise_functor
// ({
//   takingArguments : [ 2, Infinity ],
//   homogenous : 1,
//   input : 'vw +vr|+s',
//   onMakeIdentity : function( dst )
//   {
//     debugger;
//     _.vectorAdapter.assignScalar( dst, +Infinity );
//   },
//   onEach : function min( dst, src, i )
//   {
//     let d = dst.eGet( i );
//     let s = src.eGet( i );
//
//     let r = _min( d, s );
//
//     dst.eSet( i, r );
//   }
// });
//
// //
//
// /**
//  * @summary Finds maximal values from vectors `src` and `dst`. Saves result in vector `dst`.
//  * @param {Long|VectorAdapter} dst Destination vector.
//  * @param {Long|VectorAdapter} src Source vector.
//  * @example
//  * var a1 = [ 1, 4, 9, 16 ];
//  * var a2 = [ 1, 2, 3, 4 ];
//  * _.avector.max( a1, a2 );
//  * console.log( 'a1', a1 );
//  * console.log( 'a2', a2 );
//  * //a1 [ 1, 4, 9, 16 ]
//  * //a2 [ 1, 2, 3, 4 ]
//  *
//  * @function max
//  * @namespaces "wTools.avector","wTools.vectorAdapter"
//  * @module Tools/math/Vector
// */
//
// let max = meta._operationReturningSelfTakingVariantsComponentWise_functor
// ({
//   takingArguments : [ 2, Infinity ],
//   homogenous : 1,
//   input : 'vw +vr|+s',
//   onMakeIdentity : function( dst )
//   {
//     debugger;
//     _.vectorAdapter.assignScalar( dst, -Infinity );
//   },
//   onEach : function max( dst, src, i )
//   {
//     let d = dst.eGet( i );
//     let s = src.eGet( i );
//
//     let r = _max( d, s );
//
//     dst.eSet( i, r );
//   }
// });
//
// //
//
// /**
//  * @summary Limits values of vector `dst` to values in ointerval [min, max].
//  * @param {Long|VectorAdapter} dst Vector.
//  * @example
//  * var a1 = [ 1, 2, 3, 4 ];
//  * _.avector.clamp( a1, 1, 2 );
//  * console.log( 'a1', a1 );
//  * //a1 [ 1, 2, 2, 2 ]
//  *
//  * @function clamp
//  * @namespaces "wTools.avector","wTools.vectorAdapter"
//  * @module Tools/math/Vector
// */
//
// let clamp = meta._operationReturningSelfTakingVariantsComponentWise_functor
// ({
//   takingArguments : [ 3, 3 ],
//   input : 'vw vr|s vr|s',
//   onEach : function clamp( dst, min, max, i )
//   {
//     let vmin = min.eGet( i );
//     let vmax = max.eGet( i );
//     if( dst.eGet( i ) > vmax ) dst.eSet( i, vmax );
//     else if( dst.eGet( i ) < vmin ) dst.eSet( i, vmin );
//   }
// });
//
// //
//
// let randomInRange = meta._operationReturningSelfTakingVariantsComponentWise_functor
// ({
//   takingArguments : [ 3, 3 ],
//   input : 'vw vr|s vr|s',
//   onEach : function randomInRange( dst, min, max, i )
//   {
//     let vmin = min.eGet( i );
//     let vmax = max.eGet( i );
//     dst.eSet( i, vmin + Math.random()*( vmax-vmin ) );
//   }
// });
//
// //
//
// let mix = meta._operationReturningSelfTakingVariantsComponentWise_functor
// ({
//   takingArguments : [ 3, 3 ],
//   input : 'vw vr|s vr|s',
//   onEach : function mix( dst, src, progress, i )
//   {
//     debugger;
//     throw _.err( 'not tested' );
//     let v1 = dst.eGet( i );
//     let v2 = src.eGet( i );
//     let p = progress.eGet( i );
//     dst.eSet( i, v1*( 1-p ) + v2*( p ) );
//   }
// });

  // add,
  // sub,
  // mul,
  // div,
  // min,
  // max,

// --
// extremal reductor
// --

/**
 * Routine reduceToClosest() returns the closest value of source vector {-src-}.
 *
 * @example
 * var got = _.avector.reduceToClosest( [ 1, -4, 2 ] );
 * console.log( got );
 * // log {
 * //       container : VectorAdapterFromLong { _vectorBuffer : [ 1, -4, 3 ] },
 * //       index : 1,
 * //       value : -4
 * // }
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Number } - Returns minimal value of source vector.
 * @function reduceToClosest
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let reduceToClosest = meta._operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    debugger;
    _.assert( o.container.length > 0, 'not tested' );
    _.assert( 0, 'not tested' );
    return abs( o.result.instance - o.element );
  },
  onIsGreater : function( a, b )
  {
    return a < b;
  },
  input : 'vr *vr',
  // takingArguments : 2,
  // takingVectors : 1,
  distanceOnBegin : +Infinity,
  valueName : 'distance',
  name : 'reduceToClosest',
});

//

/**
 * Routine reduceToFurthest() returns the maximal value of source vector {-src-}.
 *
 * @example
 * var got = _.avector.reduceToFurthest( [ 1, -4, 2 ] );
 * console.log( got );
 * // log 2
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Number } - Returns maximal value of source vector.
 * @function reduceToFurthest
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let reduceToFurthest = meta._operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    debugger;
    _.assert( o.container.length > 0, 'not tested' );
    _.assert( 0, 'not tested' );
    return abs( o.result.instance - o.element );
  },
  onIsGreater : function( a, b )
  {
    return a > b;
  },
  input : 'vr *vr',
  // takingArguments : 2,
  // takingVectors : 1,
  distanceOnBegin : -Infinity,
  valueName : 'distance',
  name : 'reduceToFurthest',
});

//

/**
 * Routine reduceToMin() returns the minimal value of source vector {-src-}.
 *
 * @example
 * var got = _.avector.reduceToMin( [ 1, -4, 2 ] );
 * console.log( got );
 * // log 1
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Number } - Returns minimal value of source vector.
 * @function reduceToMin
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let reduceToMin = meta._operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    debugger;
    _.assert( o.container.length > 0, 'not tested' );
    _.assert( 0, 'not tested' );
    return o.element;
  },
  onIsGreater : function( a, b )
  {
    return a < b;
  },
  input : 'vr *vr',
  distanceOnBegin : +Infinity,
  valueName : 'value',
  name : 'reduceToMin',
});

//

/**
 * Routine reduceToMinAbs() returns the absolute minimal value of source vector {-src-}.
 *
 * @example
 * var got = _.avector.reduceToMinAbs( [ 1, -4, 2 ] );
 * console.log( got );
 * // log {
 * //       container : VectorAdapterFromLong { _vectorBuffer : [ 1, -4, 2 ] },
 * //       index : 0,
 * //       value : 1
 * // }
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Number } - Returns absolute minimal value of source vector.
 * @function reduceToMinAbs
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let reduceToMinAbs = meta._operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    _.assert( o.container.length > 0, 'not tested' );
    return abs( o.element );
  },
  onIsGreater : function( a, b )
  {
    return a < b;
  },
  input : 'vr *vr',
  distanceOnBegin : -Infinity,
  valueName : 'value',
  name : 'reduceToMinAbs',
});

//

/**
 * Routine reduceToMax() returns the maximal value of source vector {-src-}.
 *
 * @example
 * var got = _.avector.reduceToMax( [ 1, -4, 2 ] );
 * console.log( got );
 * // log {
 * //       container : VectorAdapterFromLong { _vectorBuffer : [ 1, -4, 2 ] },
 * //       index : 2,
 * //       value : 2
 * // }
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Number } - Returns maximal value of source vector.
 * @function reduceToMax
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let reduceToMax = meta._operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    _.assert( o.container.length > 0, 'not tested' );
    return o.element;
  },
  onIsGreater : function( a, b )
  {
    return a > b;
  },
  input : 'vr *vr',
  distanceOnBegin : -Infinity,
  valueName : 'value',
  name : 'reduceToMax',
});

//

/**
 * Routine reduceToMaxAbs() returns the absolute maximal value of source vector {-src-}.
 *
 * @example
 * var got = _.avector.reduceToMin( [ 1, -4, 2 ] );
 * console.log( got );
 * // log {
 * //       container : VectorAdapterFromLong { _vectorBuffer : [ 1, -4, 3 ] },
 * //       index : 2,
 * //       value : -4
 * // }
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Number } - Returns absolute maximal value of source vector.
 * @function reduceToMaxAbs
 * @throws { Error } If dst.length and src.length are different.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

let reduceToMaxAbs = meta._operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    _.assert( o.container.length > 0, 'not tested' );
    return abs( o.element );
  },
  onIsGreater : function( a, b )
  {
    return a > b;
  },
  input : 'vr *vr',
  distanceOnBegin : -Infinity,
  valueName : 'value',
  name : 'reduceToMaxAbs',
});

//

/**
 * Routine distributionRangeSummary() finds the biggest and the lowest values in source vector {-src-} and the median between them.
 *
 * @param { Aux } o - Map.
 * @example
 * var got = _.avector.distributionRangeSummary( [ 1, 2, 3 ] );
 * console.log( got );
 * // log {
 * //       result : {
 * //                   element : 3,
 * //                   container : [ 1, 2, 3 ],
 * //                   min : { value : 1, index : 0, container : [ 1, 2, 3 ] },
 * //                   max : { value : 3, index : 2, container : [ 1, 2, 3 ] },
 * //                   median : 2
 * //                }
 * //  }
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { Map } - Returns map that contains data with biggest, lowest values and median between them.
 * @function distributionRangeSummary
 * @throws { Error } If {-src-} is not a Long, not a VectorAdapter.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function _distributionRangeSummaryBegin( o )
{

  o.result = { min : Object.create( null ), max : Object.create( null ), };

  o.result.min.value = +Infinity;
  o.result.min.index = -1;
  o.result.min.container = null;
  o.result.max.value = -Infinity;
  o.result.max.index = -1;
  o.result.max.container = null;

}

function _distributionRangeSummaryEach( o )
{

  _.assert( o.container.length > 0, 'not tested' );

  if( o.element > o.result.max.value )
  {
    o.result.max.value = o.element;
    o.result.max.index = o.key;
    o.result.max.container = o.container;
  }

  if( o.element < o.result.min.value )
  {
    o.result.min.value = o.element;
    o.result.min.index = o.key;
    o.result.min.container = o.container;
  }

}

function _distributionRangeSummaryEnd( o )
{
  if( o.result.min.index === -1 )
  {
    o.result.min.value = NaN;
    o.result.max.value = NaN;
  }
  o.result.median = ( o.result.min.value + o.result.max.value ) / 2;
}

let distributionRangeSummary = meta._operationReduceToScalar_functor
({
  onScalar : _distributionRangeSummaryEach,
  onScalarsBegin : _distributionRangeSummaryBegin,
  onScalarsEnd : _distributionRangeSummaryEnd,
  returningNumber : false,
  returningPrimitive : false,
  interruptible : false,
  name : 'distributionRangeSummary',
});

_.assert( distributionRangeSummary.trivial.operation.reducing );

//

/**
 * Routine reduceToMinValue() returns the minimal value in passed vectors.
 *
 * @example
 * var got = _.avector.reduceToMinValue( [ 1, -4, 2 ] );
 * console.log( got );
 * // log -4
 *
 * @param { Long|VectorAdapter } srcs - Source vectors.
 * @returns { Number } - Returns minimal value in arguments.
 * @function reduceToMinValue
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function reduceToMinValue()
{
  debugger;
  let result = this.reduceToMin.apply( this, arguments );
  return result.value;
}

_.assert( _.strIs( reduceToMin.trivial.operation.input.definition ) );
// debugger;
dop = reduceToMinValue.operation = Object.create( null );
dop.input = reduceToMin.trivial.operation.input.definition;
// dop.takingArguments = [ 1, Infinity ];
// dop.takingVectors = [ 1, Infinity ];
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningNumber = true;
dop.returningPrimitive = true;
dop.modifying = false;
dop.reducing = true;

//

/**
 * Routine reduceToMaxValue() returns the maximal value in passed vectors.
 *
 * @example
 * var got = _.avector.reduceToMaxValue( [ 1, -4, 2 ] );
 * console.log( got );
 * // log 2
 *
 * @param { Long|VectorAdapter } srcs - Source vectors.
 * @returns { Number } - Returns maximal value of source vector.
 * @function reduceToMaxValue
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function reduceToMaxValue()
{
  let result = this.reduceToMax.apply( this, arguments );
  return result.value;
}

dop = reduceToMaxValue.operation = Object.create( null );
dop.input = reduceToMax.trivial.operation.input.definition;
// dop.takingArguments = [ 1, Infinity ];
// dop.takingVectors = [ 1, Infinity ];
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningNumber = true;
dop.returningPrimitive = true;
dop.modifying = false;
dop.reducing = true;

//

/**
 * Routine distributionRangeSummaryValue() finds the biggest and the lowest values in passed vectors.
 *
 * @example
 * var got = _.avector.distributionRangeSummaryValue( [ 1, -4, 2, -1 ] );
 * console.log( got );
 * // log [ -4, 2 ]
 *
 * @param { Long|VectorAdapter } srcs - Source vectors.
 * @returns { Array } - Returns array with lowest biggest value in passed vectors.
 * @function distributionRangeSummaryValue
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function distributionRangeSummaryValue()
{
  _.assert( _.routineIs( this.distributionRangeSummary ) );
  let result = this.distributionRangeSummary.apply( this, arguments );
  return [ result.min.value, result.max.value ];
}

// debugger;
dop = distributionRangeSummaryValue.operation = Object.create( null );
dop.input = distributionRangeSummary.trivial.operation.input.definition;
// dop.takingArguments = [ 1, Infinity ];
// dop.takingVectors = [ 1, Infinity ];
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningNumber = false;
dop.modifying = false;
dop.reducing = true;

// meta.declareHomogeneousLogical2Routines();

// --
// zipping
// --

// function gt( dst, src )
// {
//   return _.vectorAdapter.isGreater.apply( this, arguments );
// }
//
// debugger;
// dop = gt.operation = Routines.isGreater.operation;
// _.assert( _.object.isBasic( dop ) );
//
// //
//
// function ge( dst, src )
// {
//   return _.vectorAdapter.isGreaterEqual.apply( this, arguments );
// }
//
// dop = ge.operation = Routines.isGreaterEqual.operation;
// _.assert( _.object.isBasic( dop ) );
//
// //
//
// function lt( dst, src )
// {
//   return _.vectorAdapter.isLess.apply( this, arguments );
// }
//
// dop = lt.operation = Routines.isLess.operation;
// _.assert( _.object.isBasic( dop ) );
//
// //
//
// function le( dst, src )
// {
//   return _.vectorAdapter.isLessEqual.apply( this, arguments );
// }
//
// dop = le.operation = Routines.isLessEqual.operation;
// _.assert( _.object.isBasic( dop ) );

//

/**
 * Routine all() checks that for each element of source vector {-src-} callback {-onEach-} returns defined value.
 *
 * @example
 * var got = _.avector.all( [ 1, -4, 2 ], ( e ) => e );
 * console.log( got );
 * // log true
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Function } onEach - Callback. Applies element, index and source vector.
 * @returns { Boolean|BoolLike } - Returns true if for each element of source vector callback returns defined value. Otherwise, it returns value.
 * @function all
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-src-} is not a VectorAdapter.
 * @throws { Error } If {-onEach-} is not a Function.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */


function all( src, onEach )
{

  if( onEach === undefined || onEach === null )
  onEach = onEach0;

  let l = src.length;

  _.assert( 1 <= arguments.length && arguments.length <= 3 );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( _.routineIs( onEach ) );
  _.assert( _.intIs( l ) );

  for( let i = 0 ; i < l ; i++ )
  {
    let r = onEach( src.eGet( i ), i, src );
    if( !r )
    return r;
  }

  return true;

  /* */

  function onEach0( e, k, src )
  {
    return e;
  }
}

dop = all.operation = Object.create( null );
dop.input = 'vw ?s';
dop.scalarWise = true;
dop.homogeneous = false;
dop.takingArguments = [ 1, 2 ];
dop.takingVectors = [ 1, 1 ];
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = false;
dop.returningBoolean = true;
dop.reducing = true;
dop.modifying = false;

//

/**
 * Routine any() checks that for any element of source vector {-src-} callback {-onEach-} returns defined value.
 *
 * @example
 * var got = _.avector.any( [ 0, 0, 0 ], ( e ) => e );
 * console.log( got );
 * // log 0
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Function } onEach - Callback. Applies element, index and source vector.
 * @returns { Boolean|BoolLike } - If result of callback is defined value, returns it values. Otherwise, returns false.
 * @function any
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-src-} is not a VectorAdapter.
 * @throws { Error } If {-onEach-} is not a Function.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function any( src, onEach )
{

  if( onEach === undefined || onEach === null )
  onEach = onEach0;

  let l = src.length;

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( _.routineIs( onEach ) );
  _.assert( _.intIs( l ) );

  for( let i = 0 ; i < l ; i++ )
  {
    let r = onEach( src.eGet( i ), i, src );
    if( r )
    return r;
  }

  return false;

  function onEach0( e, k, src )
  {
    return e;
  }
}

dop = any.operation = Object.create( null );
dop.input = 'vw ?s';
dop.scalarWise = true;
dop.homogeneous = false;
dop.takingArguments = [ 1, 2 ];
dop.takingVectors = [ 1, 1 ];
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = false;
dop.returningBoolean = true;
dop.reducing = true;
dop.modifying = false;

//

/**
 * Routine none() checks that for none element of source vector {-src-} callback {-onEach-} returns defined value.
 *
 * @example
 * var got = _.avector.none( [ 0, 0, 0 ], ( e ) => e );
 * console.log( got );
 * // log true
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @param { Function } onEach - Callback. Applies element, index and source vector.
 * @returns { Boolean|BoolLike } - If result of callback is defined value, returns it reversed boolean value. Otherwise, returns true.
 * @function any
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-src-} is not a VectorAdapter.
 * @throws { Error } If {-onEach-} is not a Function.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function none( src, onEach )
{

  if( onEach === undefined || onEach === null )
  onEach = onEach0;

  let l = src.length;

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( _.routineIs( onEach ) );
  _.assert( _.intIs( l ) );

  for( let i = 0 ; i < l ; i++ )
  {
    let r = onEach( src.eGet( i ), i, src );
    if( r )
    return !r;
  }

  return true;

  function onEach0( e, k, src )
  {
    return e;
  }
}

dop = none.operation = Object.create( null );
dop.input = 'vw ?s';
dop.scalarWise = true;
dop.homogeneous = false;
dop.takingArguments = [ 1, 2 ];
dop.takingVectors = [ 1, 1 ];
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.returningLong = false;
dop.returningBoolean = true;
dop.reducing = true;
dop.modifying = false;

// --
// interruptible reductor with bool result
// --

/**
 * Routine _equalAre() checks that two vectors {-it.src-} and {-it.src2-} are equivalent.
 *
 * @example
 * var got = _.avector._equalAre( { src : [ 1, -4, 2 ], src1 : [ 1, -4.0000001, 2 ], strictTyping : 1, containing : 'all' } );
 * console.log( got );
 * // log true
 *
 * @param { Map } it - Options map.
 * @returns { Boolean|BoolLike } - If vectors {-it.src-} and {-it.src2-} are equivalent, returns true. Otherwise, returns false.
 * @function _equalAre
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If {-it.strictTyping-} is undefined.
 * @throws { Error } If {-it.containing-} is undefined.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */


function _equalAre( it )
{
  let length = it.src2.length;

  _.assert( arguments.length === 1 );
  _.assert( it.strictTyping !== undefined );
  _.assert( it.containing !== undefined );

  it.continue = false;

  if( !( it.src.length >= 0 ) )
  return end( false );

  if( !( it.src2.length >= 0 ) )
  return end( false );

  if( !it.strictContainer )
  {
    if( !_.vectorAdapterIs( it.src ) && _.longIs( it.src ) )
    it.src = this.fromLong( it.src );
    if( !_.vectorAdapterIs( it.src2 ) && _.longIs( it.src2 ) )
    it.src2 = this.fromLong( it.src2 );
  }
  else
  {
    if( !_.vectorAdapterIs( it.src ) )
    return end( false );
    if( !_.vectorAdapterIs( it.src2 ) )
    return end( false );
  }

  if( it.strictTyping )
  if( it.src._vectorBuffer.constructor !== it.src2._vectorBuffer.constructor )
  return end( false );

  if( !it.containing )
  if( it.src.length !== length )
  return end( false );

  if( !length )
  return end( true );

  for( let i = 0 ; i < length ; i++ )
  {
    if( !it.onNumbersAreEqual( it.src.eGet( i ), it.src2.eGet( i ) ) )
    return end( false );
  }

  return end( true );

  function end( result )
  {
    it.result = result;
  }

}

_.routineExtend( _equalAre, _.equaler._equal );

dop = _equalAre.operation = Object.create( null );
dop.input = '!v';
dop.takingArguments = 1;
dop.takingVectors = 0;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = false;
dop.reducing = true;
dop.homogeneous = true;

//

// /**
//  * Routine equalAre() checks that two vectors {-src1-} and {-src2-} are equivalent.
//  *
//  * @example
//  * var got = _.avector.equalAre( [ 1, -4, 2 ], [ 1, -4.0000001, 2 ], { strictTyping : 1, containing : 'all' } );
//  * console.log( got );
//  * // log true
//  *
//  * @param { Long|VectorAdapter } src1 - First vector.
//  * @param { Long|VectorAdapter } src2 - Second vector.
//  * @param { Map } opts - Options map.
//  * @returns { Boolean|BoolLike } - If vectors {-src1-} and {-src2-} are equivalent, returns true. Otherwise, returns false.
//  * @function equalAre
//  * @throws { Error } If arguments.length is less or more then one.
//  * @throws { Error } If {-opts.strictTyping-} is undefined.
//  * @throws { Error } If {-opts.containing-} is undefined.
//  * @namespaces "wTools.avector","wTools.vectorAdapter"
//  * @module Tools/math/Vector
//  */
//
// function equalAre( src1, src2, opts )
// {
//   let it = this._equalAre.head.call( this, this.equalAre, arguments );
//   let r = this._equalAre( it );
//   return it.result;
// }
//
// _.routineExtend( equalAre, { defaults : _._equal } );
//
// // _.routineExtend( equalAre, _.equaler._equal );
// // _.assert( _.object.isBasic( equalAre.defaults ) );
// // _.assert( _.routineIs( equalAre.body ) );
// // _.assert( _.routineIs( equalAre.lookContinue ) );
//
// dop = equalAre.operation = Object.create( null );
// dop.input = 'vr vr ?!v';
// dop.takingArguments = [ 2, 3 ];
// dop.takingVectors = 2;
// dop.takingVectorsOnly = false;
// dop.returningSelf = false;
// dop.returningNew = false;
// dop.modifying = false;
// dop.reducing = true;
// dop.homogeneous = true;

//

/**
 * Routine identicalAre() checks that two vectors {-src1-} and {-src2-} are identical.
 *
 * @example
 * var got = _.avector.identicalAre( [ 1, -4, 2 ], [ 1, -4.0000001, 2 ], { strictTyping : 1, containing : 'all' } );
 * console.log( got );
 * // log false
 *
 * @param { Long|VectorAdapter } src1 - First vector.
 * @param { Long|VectorAdapter } src2 - Second vector.
 * @param { Map } iterator - Options map.
 * @returns { Boolean|BoolLike } - If vectors {-src1-} and {-src2-} are identical, returns true. Otherwise, returns false.
 * @function identicalAre
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If {-iterator.strictTyping-} is undefined.
 * @throws { Error } If {-iterator.containing-} is undefined.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function identicalAre( src1, src2, iterator )
{
  debugger;
  let it = this._equalAre.head.call( this, this.identicalAre, arguments );
  let r = this._equalAre( it );
  return it.result;
}

_.routine.extendInheriting( identicalAre, { defaults : _.entityIdentical.defaults } );
identicalAre.defaults.Seeker = identicalAre.defaults;

// _.routineExtend( identicalAre, _.entityIdentical );

dop = identicalAre.operation = Object.create( null );
dop.input = 'vr vr ?!v';
dop.takingArguments = [ 2, 3 ];
dop.takingVectors = 2;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = false;
dop.reducing = true;
dop.homogeneous = true;

//

/**
 * Routine equivalentAre() checks that two vectors {-src1-} and {-src2-} are equivalent.
 *
 * @example
 * var got = _.avector.equivalentAre( [ 1, -4, 2 ], [ 1, -4.0000001, 2 ], { strictTyping : 1, containing : 'all' } );
 * console.log( got );
 * // log true
 *
 * @param { Long|VectorAdapter } src1 - First vector.
 * @param { Long|VectorAdapter } src2 - Second vector.
 * @param { Map } iterator - Options map.
 * @returns { Boolean|BoolLike } - If vectors {-src1-} and {-src2-} are equivalent, returns true. Otherwise, returns false.
 * @function equivalentAre
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If {-iterator.strictTyping-} is undefined.
 * @throws { Error } If {-iterator.containing-} is undefined.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */


function equivalentAre( src1, src2, iterator )
{
  let it = this._equalAre.head.call( this, this.equivalentAre, arguments );
  let r = this._equalAre( it );
  return it.result;
}

_.routine.extendInheriting( equivalentAre, { defaults : _.entityEquivalent.defaults } );
equivalentAre.defaults.Seeker = equivalentAre.defaults;

dop = equivalentAre.operation = Object.create( null );
dop.input = 'vr vr ?!v';
dop.takingArguments = [ 2, 3 ];
dop.takingVectors = 2;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = false;
dop.reducing = true;
dop.homogeneous = true;

//

/**
 * Routine areParallel() checks that two vectors {-src1-} and {-src2-} are parallel.
 *
 * @example
 * var got = _.avector.areParallel( [ 1, -4, 2 ], [ 2, -8, 4 ] );
 * console.log( got );
 * // log true
 *
 * @param { Long|VectorAdapter } src1 - First vector.
 * @param { Long|VectorAdapter } src2 - Second vector.
 * @param { Number } accuracy - Accuracy of comparison.
 * @returns { Boolean|BoolLike } - If vectors {-src1-} and {-src2-} are parallel, returns true. Otherwise, returns false.
 * @function areParallel
 * @throws { Error } If src1.length and src2.length are different.
 * @throws { Error } If {-accuracy-} is not a Number.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

/* aaa : good coverage required */
/* Dmytro : covered, name of routine use not common naming pattern */
/* aaa2 : bad coverage! */ /* Dmytro : extended */

function areParallel( src1, src2, accuracy )
{
  let length = src1.length;
  accuracy = ( accuracy !== undefined ) ? accuracy : this.accuracy;

  _.assert( _.numberIs( accuracy ) );
  _.assert( src1.length === src2.length, 'vector.areParallel :', 'src1 and src2 should have same length' );

  if( !length )
  return true;

  let ratio = 0;
  let s = 0;
  while( s < length )
  {

    let e1 = src1.eGet( s );
    let e2 = src2.eGet( s );

    let isZero1 = Math.abs( e1 ) < accuracy;
    let isZero2 = Math.abs( e2 ) < accuracy;

    debugger;
    // if( isZero1 ^ isZero2 )
    if( isZero1 !== isZero2 )
    return false;

    if( isZero1 )
    {
      s += 1;
      continue;
    }

    ratio = src1.eGet( s ) / src2.eGet( s );

    s += 1;
    break;
  }

  while( s < length )
  {

    let e1 = src1.eGet( s );
    let e2 = src2.eGet( s );

    let isZero1 = Math.abs( e1 ) < accuracy;

    if( isZero1 )
    {
      let isZero2 = Math.abs( e2 ) < accuracy;
      if( !isZero2 )
      return false;
      s += 1;
      continue;
    }

    let r = src1.eGet( s ) / src2.eGet( s );

    if( abs( r - ratio ) > accuracy )
    return false;

    s += 1;
  }

  return true;
}

dop = areParallel.operation = Object.create( null );
dop.input = 'vr vr ?s';
dop.takingArguments = [ 2, 3 ];
dop.takingVectors = 2;
dop.takingVectorsOnly = false;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = false;
dop.reducing = true;
dop.homogeneous = true;

// --
// before
// --

meta._routinesDeclare();

// --
// helper
// --

/**
 * Routine mag() calculates square root from sum of squares of vector {-v-} elements.
 *
 * @example
 * var got = _.avector.mag( [ 1, -4, 2, 2 ] );
 * console.log( got );
 * // log 5
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @returns { Number } - Returns square root from sum of squares of source vector elements.
 * @function mag
 * @throws { Error } If arguments.length is less or more then one.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function mag( v )
{

  _.assert( arguments.length === 1 );

  return this.reduceToMag( v );
}

dop = mag.operation = _.props.extend( null , Routines.reduceToMag.operation );
dop.input = 'vr';
dop.takingArguments = [ 1, 1 ];
dop.takingVectors = [ 1, 1 ];

//

/**
 * Routine magSqr() calculates sum of squares of vector {-v-} elements.
 *
 * @example
 * var got = _.avector.magSqr( [ 1, -4, 2, 2 ] );
 * console.log( got );
 * // log 25
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @returns { Number } - Returns sum of squares of source vector elements.
 * @function magSqr
 * @throws { Error } If arguments.length is less or more then one.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function magSqr( v )
{

  _.assert( arguments.length === 1 );

  return this.reduceToMagSqr( v );
}

dop = magSqr.operation = _.props.extend( null , Routines.reduceToMagSqr.operation );
dop.input = 'vr';
dop.takingArguments = [ 1, 1 ];
dop.takingVectors = [ 1, 1 ];


// --
// statistics
// --

//

/**
 * Routine dot() calculates sum of multiplication of vectors {-dst-} and {-src-}.
 *
 * @example
 * var got = _.avector.dot( [ 1, -4, 2 ], [ 2, 3, 2 ] );
 * console.log( got );
 * // log 6
 *
 * @param { VectorAdapter } dst - Source vector.
 * @param { VectorAdapter } src - Source vector.
 * @returns { Number } - Returns sum of multiplication of vectors {-dst-} and {-src-}.
 * @function dot
 * @throws { Error } If arguments.length is less or more then two.
 * @throws { Error } If {-dst-} is not a VectorAdapter.
 * @throws { Error } If {-src-} is not a VectorAdapter.
 * @throws { Error } If dst.length and src.length are not equivalent.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

/* Dmytro : maybe, parameters should have name src1 and src2 */

function dot( dst, src )
{
  let result = 0;
  let length = dst.length;

  _.assert( _.vectorAdapterIs( dst ) );
  _.assert( _.vectorAdapterIs( src ) );
  _.assert( dst.length === src.length, 'src and dst should have same length' );
  _.assert( arguments.length === 2 );

  for( let s = 0 ; s < length ; s++ )
  {
    result += dst.eGet( s ) * src.eGet( s );
  }

  return result;
}

dop = dot.operation = Object.create( null );
dop.input = 'vr vr';
dop.takingArguments = 2;
dop.takingVectors = 2;
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = false;

//

/**
 * Routine distance() calculates square root from sum of squares of substruction vectors {-src1-} and {-src2-}.
 * It is distance between vectors, a normal to vectors.
 *
 * @example
 * var got = _.avector.distance( [ 1, -4, 2 ], [ 2, 3, 2 ] );
 * console.log( got );
 * // log 7.0710678118654755
 *
 * @param { Long|VectorAdapter } src1 - Source vector.
 * @param { Long|VectorAdapter } src2 - Source vector.
 * @returns { Number } - Returns square root from sum of squares of substruction vectors {-src1-} and {-src2-}.
 * @function distance
 * @throws { Error } If src1.length and src2.length are not equivalent.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function distance( src1, src2 )
{
  let result = this.distanceSqr( src1, src2 );
  result = sqrt( result );
  return result;
}

dop = distance.operation = Object.create( null );
dop.input = 'vr vr';
dop.takingArguments = 2;
dop.takingVectors = 2;
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = false;

//

/**
 * Routine distanceSqr() calculates sum of squares of substruction vectors {-src1-} and {-src2-}.
 *
 * @example
 * var got = _.avector.distanceSqr( [ 1, -4, 2 ], [ 2, 3, 2 ] );
 * console.log( got );
 * // log 50
 *
 * @param { Long|VectorAdapter } src1 - Source vector.
 * @param { Long|VectorAdapter } src2 - Source vector.
 * @returns { Number } - Returns sum of squares of substruction vectors {-src1-} and {-src2-}.
 * @function distanceSqr
 * @throws { Error } If src1.length and src2.length are not equivalent.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function distanceSqr( src1, src2 )
{
  let result = 0;
  let length = src1.length;

  _.assert( src1.length === src2.length, 'vector.distanceSqr :', 'src1 and src2 should have same length' );

  for( let s = 0 ; s < length ; s++ )
  {
    result += _sqr( src1.eGet( s ) - src2.eGet( s ) );
  }

  return result;
}

dop = distanceSqr.operation = Object.create( null );
dop.input = 'vr vr';
dop.takingArguments = 2;
dop.takingVectors = 2;
dop.takingVectorsOnly = true;
dop.returningSelf = false;
dop.returningNew = false;
dop.modifying = false;

//

/**
 * Routine median() calculates median between lowest and biggest values of vector {-v-}.
 *
 * @example
 * var got = _.avector.median( [ 1, -4, 2 ] );
 * console.log( got );
 * // log -1
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @returns { Number } - Returns median of source vector.
 * @function median
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function median( v )
{
  let result = this.distributionRangeSummary( v ).median;
  return result;
}

dop = median.operation = _.props.extend( null , distributionRangeSummary.trivial.operation );

//

/**
 * Routine momentCentral() calculates a probability distribution of a random variable about the random variable's mean.
 *
 * @example
 * var got = _.avector.momentCentral( [ 2, -4, 2 ], 1, 1 );
 * console.log( got );
 * // log -1
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @param { Number } degree - Degree of moment.
 * @param { Number } mean - Mean of value.
 * @returns { Number } - Returns a value of probability distribution of a random variable about the variable's mean.
 * @function momentCentral
 * @throws { Error } If arguments.length is less then two or more then three.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function momentCentral( v, degree, mean )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( mean === undefined || mean === null )
  mean = _.avector.mean( v );

  return this._momentCentral( v, degree, mean );
}

dop = momentCentral.operation = _.props.extend( null , Routines._momentCentral.operation );
dop.input = 'vr s ?s';
dop.takingArguments = [ 2, 3 ];

//

/**
 * Routine momentCentralConditional() calculates a probability distribution of a random variable about the random variable's mean.
 * If {-mean-} is undefined, then it calculates from source vector {-v-}, due to that elements of {-v-} filters by callback {-filter-}.
 *
 * @example
 * var got = _.avector.momentCentralConditional( [ 2, -4, 2 ], 1, 1, ( e ) => e > 0 ? e : Math.abs( e ) );
 * console.log( got );
 * // log 1.6666666666666
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @param { Number } degree - Degree of moment.
 * @param { Number } mean - Mean of value.
 * @param { Function } filter - Callback.
 * @returns { Number } - Returns a value of probability distribution of a random variable about the variable's mean.
 * @function momentCentralConditional
 * @throws { Error } If arguments.length is less then two or more then three.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function momentCentralConditional( v, degree, mean, filter )
{
  _.assert( arguments.length === 3 || arguments.length === 4 );

  if( _.routineIs( mean ) )
  {
    _.assert( filter === undefined );
    filter = mean;
    mean = null;
  }

  if( mean === undefined || mean === null )
  mean = _.avector.meanConditional( v, filter );

  return this._momentCentralConditional( v, degree, mean, filter );
}

dop = momentCentralConditional.operation = _.props.extend( null , Routines._momentCentralConditional.operation );
dop.input = 'vr s ?s !v';
dop.takingArguments = [ 3, 4 ];

//

/**
 * Routine distributionSummary() calculates a set of values that characterize the source vector {-v-}.
 * The values: min and max values, mean, variance, standard deviation, normalized kurtosis, skewness.
 *
 * @param { Long|VectorAdapter } v - Source vector.
 *
 * @returns { Number } - Returns the expectation of the squared deviation of a random variable from its mean.
 * @function distributionSummary
 * @throws { Error } If arguments.length is less then one or more then two.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function distributionSummary( v )
{
  let result = Object.create( null );

  result.range = this.distributionRangeSummary( v );
  delete result.range.min.container;
  delete result.range.max.container;

  result.mean = this.mean( v );
  result.variance = this.variance( v, result.mean );
  result.standardDeviation = this.standardDeviation( v, result.mean );
  result.kurtosisExcess = this.kurtosisExcess( v, result.mean );
  result.skewness = this.skewness( v, result.mean );

  return result;
}

dop = distributionSummary.operation = _.props.extend( null , Routines._momentCentral.operation );
// dop.input = 'vr';
// dop.takingArguments = [ 1, 1 ];

//

/**
 * Routine variance() calculates the expectation of the squared deviation of a random variable from its mean.
 *
 * @example
 * var got = _.avector.variance( [ 2, -4, 2 ], 1 );
 * console.log( got );
 * // log 9
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @param { Number } mean - Mean of value.
 * @returns { Number } - Returns the expectation of the squared deviation of a random variable from its mean.
 * @function variance
 * @throws { Error } If arguments.length is less then one or more then two.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function variance( v, mean )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  let degree = 2;
  return this.momentCentral( v, degree, mean );
}

dop = variance.operation = _.props.extend( null , momentCentral.operation );
dop.input = 'vr ?s';
dop.takingArguments = [ 1, 2 ];

//

/**
 * Routine varianceConditional() calculates the expectation of the squared deviation of a random variable from its mean.
 * The values of vector can be filtered by callback {-filter-}
 *
 * @example
 * var got = _.avector.varianceConditional( [ 2, -4, 2 ], 1, ( e ) => e > 0 ? e : Math.abs( e ) );
 * console.log( got );
 * // log 3.6666666666666
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @param { Number } mean - Mean of value.
 * @param { Function } filter - Callback.
 * @returns { Number } - Returns the expectation of the squared deviation of a random variable from its mean.
 * @function variance
 * @throws { Error } If arguments.length is less then one or more then two.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function varianceConditional( v, mean, filter )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( _.routineIs( mean ) )
  {
    _.assert( filter === undefined );
    filter = mean;
    mean = null;
  }

  let degree = 2;
  return this.momentCentralConditional( v, degree, mean, filter );
}

dop = varianceConditional.operation = _.props.extend( null , momentCentralConditional.operation );
dop.input = 'vr ?s !v';
dop.takingArguments = [ 2, 3 ];

//

/**
 * Routine standardDeviation() calculates the dispersion of a set of values in vectors.
 *
 * @example
 * var got = _.avector.standardDeviation( [ 2, -4, 2 ] );
 * console.log( got );
 * // log 2.8284271247461903
 *
 * @param { Long|VectorAdapter } srcs - Source vectors.
 * @returns { Number } - Returns the dispersion of a set of values.
 * @function standardDeviation
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function standardDeviation()
{
  let result = this.variance.apply( this, arguments );
  return _sqrt( result );
}

dop = standardDeviation.operation = _.props.extend( null , variance.operation );
dop.input = 'vr ?s';

//

/**
 * Routine standardDeviationNormalized() calculates the dispersion of a set of values in vectors divided by the mean.
 *
 * @example
 * var got = _.avector.standardDeviationNormalized( [ 2, -4, 2 ], 1 );
 * console.log( got );
 * // log 3
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @param { Number } mean - Mean of value.
 * @returns { Number } - Returns the dispersion of a set of values divided by the mean.
 * @function standardDeviationNormalized
 * @throws { Error } If arguments.length is less then one or more then two.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function standardDeviationNormalized( v, mean )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( mean === undefined || mean === null )
  mean = _.avector.mean( v );

  let result = this.variance( v, mean );

  return _sqrt( result ) / mean;
}

dop = standardDeviationNormalized.operation = _.props.extend( null , variance.operation );
dop.input = 'vr ?s';

//

/**
 * Routine kurtosis() calculates the "tailedness" of the probability distribution of a real-valued random variable.
 *
 * @example
 * var got = _.avector.kurtosis( [ 2, -4, 2 ], 1 );
 * console.log( got );
 * // log 2.580246913580247
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @param { Number } mean - Mean of value.
 * @returns { Number } - Returns the "tailedness" of the probability distribution of a real-valued random variable.
 * @function kurtosis
 * @throws { Error } If arguments.length is less then one or more then two.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function kurtosis( v, mean )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( mean === undefined || mean === null )
  mean = _.avector.mean( v );

  let variance = this.variance( v, mean );
  let result = this.momentCentral( v, 4, mean );

  return result / _pow( variance, 2 );
}

dop = kurtosis.operation = _.props.extend( null , variance.operation );
dop.input = 'vr ?s';

//

/* kurtosis of normal distribution is three */

/**
 * Routine kurtosisNormalized() calculates the "tailedness" of the probability distribution of a real-valued random variable subtracted by 3.
 *
 * @example
 * var got = _.avector.kurtosisNormalized( [ 2, -4, 2 ], 1 );
 * console.log( got );
 * // log -0.4197530864197532
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @param { Number } mean - Mean of value.
 * @returns { Number } - Returns normalized "tailedness" of the probability distribution of a real-valued random variable.
 * @function kurtosisNormalized
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */


function kurtosisNormalized( v, mean )
{
  let result = this.kurtosis.apply( this, arguments );
  return result - 3;
}

dop = kurtosisNormalized.operation = _.props.extend( null , variance.operation );
dop.input = 'vr ?s';

//

/**
 * Routine skewness() calculates the asymmetry of the probability distribution of a real-valued random variable about the mean.
 * If {-mean-} is undefined, then it calculates from source vector {-v-}.
 *
 * @example
 * var got = _.avector.skewness( [ 2, -4, 2 ], 1 );
 * console.log( got );
 * // log -0.5925925925925926
 *
 * @param { Long|VectorAdapter } v - Source vector.
 * @param { Number } mean - Mean of value.
 * @returns { Number } - Returns the asymmetry of the probability distribution.
 * @function skewness
 * @throws { Error } If arguments.length is less then one or more then two.
 * @namespaces "wTools.avector","wTools.vectorAdapter"
 * @module Tools/math/Vector
 */

function skewness( v, mean )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( mean === undefined || mean === null )
  mean = _.avector.mean( v );

  let moment = this.moment( v, 3 );
  let std = this.std( v, mean );

  return moment / _pow( std, 3 );
}

dop = skewness.operation = _.props.extend( null , variance.operation );
dop.input = 'vr ?s';

//

function contextsForTesting( o )
{

  if( _.routineIs( arguments[ 0 ] ) )
  o = { onEach : arguments[ 0 ] }
  o = _.routine.options_( contextsForTesting, o );

  if( o.single )
  {
    if( o.varyingForm === null )
    o.varyingForm = 0;
    if( o.varyingFormat === null )
    o.varyingFormat = 0;
  }
  else
  {
    if( o.varyingForm === null )
    o.varyingForm = 1;
    if( o.varyingFormat === null )
    o.varyingFormat = 1;
  }

  if( _.strIs( o.varyingForm ) )
  o.varyingForm = _.array.as( o.varyingForm );
  if( _.strIs( o.varyingFormat ) )
  o.varyingFormat = _.array.as( o.varyingFormat );

  if( o.varyingForm && _.boolLike( o.varyingForm ) )
  o.varyingForm = [ 'straight', 'linterval', 'stride' ];
  if( o.varyingFormat && _.boolLike( o.varyingFormat ) )
  o.varyingFormat = [ 'Array', 'F32x', 'F64x', 'I16x' ];

  _.assert( _.routineIs( o.onEach ) );
  _.assert( arguments.length === 1 );
  _.assert( _.longHasAll( [ 'straight', 'linterval', 'stride' ], o.varyingForm ) );
  _.assert( _.longHasAll( [ 'Array', 'F32x', 'F64x', 'I16x' ], o.varyingFormat ) );

  let defaultFormat = o.varyingFormat[ 0 ];

  if( _.longHas( o.varyingForm, 'straight' ) )
  // if( _.longHas( o.varyingFormat, 'Array' ) )
  {
    let op = _.props.extend( null, o );
    op.format = defaultFormat;
    op.form = 'straight';
    op.vadMake = ( src ) => this.fromLong( _.long.make( _global_[ defaultFormat ], src ) );
    op.longMake = ( src ) => _.long.make( _global_[ defaultFormat ], src );
    o.onEach( op );
  }

  if( o.varyingFormat )
  {

    if( _.longHas( o.varyingFormat, 'F32x' ) )
    {
      let op = _.props.extend( null, o );
      op.format = 'F32x';
      op.form = 'straight';
      op.vadMake = ( src ) => this.fromLong( new F32x( src ) );
      op.longMake = ( src ) => new F32x( src );
      o.onEach( op );
    }

    if( _.longHas( o.varyingFormat, 'F64x' ) )
    {
      let op = _.props.extend( null, o );
      op.format = 'F64x';
      op.form = 'straight';
      op.vadMake = ( src ) => this.fromLong( new F64x( src ) );
      op.longMake = ( src ) => new F64x( src );
      o.onEach( op );
    }

    if( _.longHas( o.varyingFormat, 'I16x' ) )
    {
      let op = _.props.extend( null, o );
      op.format = 'I16x';
      op.form = 'straight';
      op.vadMake = ( src ) => this.fromLong( new I16x( src ) );
      op.longMake = ( src ) => new I16x( src );
      o.onEach( op );
    }

  }

  if( !o.varyingForm )
  return;

  if( _.longHas( o.varyingForm, 'linterval' ) )
  {
    let op = _.props.extend( null, o );
    op.format = defaultFormat;
    op.form = 'linterval';
    op.longMake = ( src ) => _.long.make( _global_[ defaultFormat ], src );
    op.vadMake = ( src ) =>
    {
      let dst = _.longMakeZeroed( _global_[ defaultFormat ], src.length + 2 );
      for( let i = 0 ; i < src.length ; i++ )
      dst[ i+1 ] = src[ i ];
      return this.fromLongLrange( dst, 1, src.length )
    };
    o.onEach( op );
  }

  if( _.longHas( o.varyingForm, 'stride' ) )
  {
    let op = _.props.extend( null, o );
    op.format = defaultFormat;
    op.form = 'stride';
    op.longMake = ( src ) => _.long.make( _global_[ defaultFormat ], src );
    op.vadMake = ( src ) =>
    {
      let dst = _.longMakeZeroed( _global_[ defaultFormat ], src.length*2 + 2 );
      for( let i = 0 ; i < src.length ; i++ )
      dst[ i*2+1 ] = src[ i ];
      return this.fromLongLrangeAndStride( dst, 1, src.length, 2 )
    };
    o.onEach( op );
  }

}

contextsForTesting.defaults =
{
  onEach : null,
  varyingForm : null,
  varyingFormat : null,
  single : 0,
}

// --
// implementation
// --

let _routinesMathematical =
{

  // basic

  assign,
  assignVector,

  clone,
  MakeSimilar,

  slice,
  // slicedAdapter, /* zzz : deprecate */
  // slicedLong, /* zzz : deprecate */

  /* qqq : implement routine onlyLong and cover */
  /* qqq : implement routine onlyAdapter and cover */
  /* aaa : implement routine growLong and cover */ /* Dmytro : covered */
  /* aaa : implement routine growAdapter and cover */ /* Dmytro : covered */

  grow : growAdapter,
  growAdapter,
  growLong, /* aaa2 : implement good coverage, does not work properly */ /* Dmytro : covered, routine had some bugs with indexes */

  only : onlyAdapter,
  onlyAdapter,
  onlyLong,
  onlyAdapter_,
  onlyLong_,

  // resizedAdapter, /* zzz : deprecate */
  // resizedLong, /* zzz : deprecate */

  review, /* aaa : cover please */ /* Dmytro : covered */
  // subarray, /* zzz : deprecate */

  bufferConstructorOf,

  toLong,
  toStr : _toStr,
  _toStr,
  headExport,

  gather,

  map, /* aaa : implement perfect coverage */ /* Dmytro : implemented */
  filter, /* aaa : implement perfect coverage */ /* Dmytro : implemented */
  while : _while,

  // special

  sort,
  randomInRadius,

  crossWithPoints,
  _cross3,
  cross3,
  cross,

  quaternionApply,
  quaternionApply2,
  eulerApply,

  reflect,
  refract,

  matrixApplyTo,
  matrixHomogenousApply,
  matrixDirectionsApply,

  swapVectors,
  scalarsSwap,

  formate,


  // scalar-wise, modifying, taking single vector : self

  /* meta._operationTakingDstSrcReturningSelfComponentWise_functor */

  inv,
  invOrOne,

  abs : absRoutine,
  floor : floorRoutine,
  ceil : ceilRoutine,
  round : roundRoutine,

  ceilToPowerOfTwo,

  normalize,

  // scalar-wise, assigning, mixed : self /* zzz qqq : deprecate */

  /* meta._operationReturningSelfTakingVariantsComponentWise_functor */
  /* meta._operationReturningSelfTakingVariantsComponentWiseAct_functor */

  // addAssigning : add.assigning,
  // subAssigning : sub.assigning,
  // mulAssigning : mul.assigning,
  // divAssigning : div.assigning,
  //
  // minAssigning : min.assigning,
  // maxAssigning : max.assigning,
  // clampAssigning : clamp.assigning,
  // randomInRangeAssigning : randomInRange.assigning,
  // mixAssigning : mix.assigning,

  // scalar-wise, copying, mixed : self /* zzz qqq : deprecate */

  // addCopying : add.copying,
  // subCopying : sub.copying,
  // mulCopying : mul.copying,
  // divCopying : div.copying,
  //
  // minCopying : min.copying,
  // maxCopying : max.copying,
  // clampCopying : clamp.copying,
  // randomInRangeCopying : randomInRange.copying,
  // mixCopying : mix.copying,

  // scalar-wise, homogeneous, taking vectors
  // vectors only -> self

  // /*
  // declareHomogeneousTakingVectorsRoutines,
  // */

  // addVectors : Routines.addVectors,
  // subVectors : Routines.subVectors,
  // mulVectors : Routines.mulVectors,
  // divVectors : Routines.divVectors,
  //
  // assignVectors : Routines.assignVectors,
  // minVectors : Routines.minVectors,
  // maxVectors : Routines.maxVectors,
  //
  // // scalar-wise, homogeneous, taking scalar
  // // 1 vector , 1 scalar -> self
  //
  // /*
  // declareHomogeneousTakingScalarRoutines,
  // */
  //
  // addScalar : Routines.addScalar,
  // subScalar : Routines.subScalar,
  // mulScalar : Routines.mulScalar,
  // divScalar : Routines.divScalar,
  //
  // assignScalar : Routines.assignScalar,
  // minScalar : Routines.minScalar,
  // maxScalar : Routines.maxScalar,

  // scalar-wise

  /*
  _onScalarScalarWise_functor,
  _onVectorsScalarWise_functor,
  */


// scalar-wise, homogeneous

  /*
  _routineHomogeneousDeclare,
  routinesHomogeneousDeclare,
  */

  // experiment1 : Routines.experiment1,

  add : Routines.add,
  sub : Routines.sub,
  mul : Routines.mul,
  div : Routines.div,

  min : Routines.min,
  max : Routines.max,

// scalar-wise, heterogeneous

  /*
  _routinesHeterogeneousDeclare,
  routinesHeterogeneousDeclare,
  */

  addScaled : Routines.addScaled,
  subScaled : Routines.subScaled,
  mulScaled : Routines.mulScaled,
  divScaled : Routines.divScaled,

  clamp : Routines.clamp,
  randomInRange : Routines.randomInRange,
  mix : Routines.mix,

  // scalarReductor

/*

  _normalizeOperationArity,
  _normalizeOperationFunctions,

  _meta._operationReduceToScalar_functor,
  meta._operationReduceToScalar_functor,
  declareReducingRoutines,

*/

  polynomApply : Routines.polynomApply,
  mean : Routines.mean,
  moment : Routines.moment,
  _momentCentral : Routines._momentCentral,
  reduceToMean : Routines.reduceToMean,
  reduceToProduct : Routines.reduceToProduct,
  reduceToSum : Routines.reduceToSum,
  reduceToAbsSum : Routines.reduceToAbsSum,
  reduceToMag : Routines.reduceToMag,
  reduceToMagSqr : Routines.reduceToMagSqr,

  polynomApplyConditional : Routines.polynomApplyConditional,
  meanConditional : Routines.meanConditional,
  momentConditional : Routines.momentConditional,
  _momentCentralConditional : Routines._momentCentralConditional,
  reduceToMeanConditional : Routines.reduceToMeanConditional,
  reduceToProductConditional : Routines.reduceToProductConditional,
  reduceToSumConditional : Routines.reduceToSumConditional,
  reduceToAbsSumConditional : Routines.reduceToAbsSumConditional,
  reduceToMagConditional : Routines.reduceToMagConditional,
  reduceToMagSqrConditional : Routines.reduceToMagSqrConditional,

  // allFiniteConditional : Routines.allFiniteConditional,
  // anyNanConditional : Routines.anyNanConditional,
  // allIntConditional : Routines.allIntConditional,
  // allZeroConditional : Routines.allZeroConditional,

  // extremal reductor

  /* meta._operationReduceToExtremal_functor*/

  reduceToClosest : reduceToClosest.trivial,
  reduceToFurthest : reduceToFurthest.trivial,
  reduceToMin : reduceToMin.trivial,
  reduceToMinAbs : reduceToMinAbs.trivial,
  reduceToMax : reduceToMax.trivial,
  reduceToMaxAbs : reduceToMaxAbs.trivial,
  distributionRangeSummary : distributionRangeSummary.trivial,

  reduceToClosestConditional : reduceToClosest.conditional,
  reduceToFurthestConditional : reduceToFurthest.conditional,
  reduceToMinConditional : reduceToMin.conditional,
  reduceToMinAbsConditional : reduceToMinAbs.conditional,
  reduceToMaxConditional : reduceToMax.conditional,
  reduceToMaxAbsConditional : reduceToMaxAbs.conditional,
  distributionRangeSummaryConditional : distributionRangeSummary.conditional,

  reduceToMinValue,
  reduceToMaxValue,
  distributionRangeSummaryValue,

  // logical2 zipper

/*
  _declareHomogeneousLogical2Routine,
  _declareHomogeneousLogical2NotReducingRoutine,
  _declareHomogeneousLogical2ReducingRoutine,
  _declareHomogeneousLogical2ReducingAllRoutine,
  _declareHomogeneousLogical2ReducingAnyRoutine,
  _declareHomogeneousLogical2ReducingNoneRoutine,
  declareHomogeneousLogical2Routines,
*/

  gt : Routines.isGreater,
  ge : Routines.isGreaterEqual,
  ga : Routines.isGreaterAprox,
  gea : Routines.isGreaterEqualAprox,
  lt : Routines.isLess,
  le : Routines.isLessEqual,
  la : Routines.isLessAprox,
  lea : Routines.isLessEqualAprox,

  //

  isIdentical : Routines.isIdentical,
  isNotIdentical : Routines.isNotIdentical,
  isEquivalent : Routines.isEquivalent,
  // isEquivalent2 : Routines.isEquivalent2,
  isNotEquivalent : Routines.isNotEquivalent,
  isGreater : Routines.isGreater,
  isGreaterEqual : Routines.isGreaterEqual,
  isGreaterEqualAprox : Routines.isGreaterEqualAprox,
  isGreaterAprox : Routines.isGreaterAprox,
  isLess : Routines.isLess,
  isLessEqual : Routines.isLessEqual,
  isLessEqualAprox : Routines.isLessEqualAprox,
  isLessAprox : Routines.isLessAprox,

  isNumber : Routines.isNumber,
  isZero : Routines.isZero,
  isFinite : Routines.isFinite,
  isInfinite : Routines.isInfinite,
  isNan : Routines.isNan,
  isInt : Routines.isInt,
  isString : Routines.isString,

  // logical2 reductor

  all, /* qqq : implement perfect coverage */

  allIdentical : Routines.allIdentical,
  allNotIdentical : Routines.allNotIdentical,
  allEquivalent : Routines.allEquivalent,
  // allEquivalent2 : Routines.allEquivalent2,
  allNotEquivalent : Routines.allNotEquivalent,
  allGreater : Routines.allGreater,
  allGreaterEqual : Routines.allGreaterEqual,
  allGreaterEqualAprox : Routines.allGreaterEqualAprox,
  allGreaterAprox : Routines.allGreaterAprox,
  allLess : Routines.allLess,
  allLessEqual : Routines.allLessEqual,
  allLessEqualAprox : Routines.allLessEqualAprox,
  allLessAprox : Routines.allLessAprox,

  allNumber : Routines.allNumber,
  allZero : Routines.allZero,
  allFinite : Routines.allFinite,
  allInfinite : Routines.allInfinite,
  allNan : Routines.allNan,
  allInt : Routines.allInt,
  allString : Routines.allString,

  //

  any, /* qqq : implement perfect coverage */

  anyIdentical : Routines.anyIdentical,
  anyNotIdentical : Routines.anyNotIdentical,
  anyEquivalent : Routines.anyEquivalent,
  // anyEquivalent2 : Routines.anyEquivalent2,
  anyNotEquivalent : Routines.anyNotEquivalent,
  anyGreater : Routines.anyGreater,
  anyGreaterEqual : Routines.anyGreaterEqual,
  anyGreaterEqualAprox : Routines.anyGreaterEqualAprox,
  anyGreaterAprox : Routines.anyGreaterAprox,
  anyLess : Routines.anyLess,
  anyLessEqual : Routines.anyLessEqual,
  anyLessEqualAprox : Routines.anyLessEqualAprox,
  anyLessAprox : Routines.anyLessAprox,

  anyNumber : Routines.anyNumber,
  anyZero : Routines.anyZero,
  anyFinite : Routines.anyFinite,
  anyInfinite : Routines.anyInfinite,
  anyNan : Routines.anyNan,
  anyInt : Routines.anyInt,
  anyString : Routines.anyString,

  //

  none, /* qqq : implement perfect coverage */

  noneIdentical : Routines.noneIdentical,
  noneNotIdentical : Routines.noneNotIdentical,
  noneEquivalent : Routines.noneEquivalent,
  // noneEquivalent2 : Routines.noneEquivalent2,
  noneNotEquivalent : Routines.noneNotEquivalent,
  noneGreater : Routines.noneGreater,
  noneGreaterEqual : Routines.noneGreaterEqual,
  noneGreaterEqualAprox : Routines.noneGreaterEqualAprox,
  noneGreaterAprox : Routines.noneGreaterAprox,
  noneLess : Routines.noneLess,
  noneLessEqual : Routines.noneLessEqual,
  noneLessEqualAprox : Routines.noneLessEqualAprox,
  noneLessAprox : Routines.noneLessAprox,

  noneNumber : Routines.noneNumber,
  noneZero : Routines.noneZero,
  noneFinite : Routines.noneFinite,
  noneInfinite : Routines.noneInfinite,
  noneNan : Routines.noneNan,
  noneInt : Routines.noneInt,
  noneString : Routines.noneString,

  // logical1 singler

/*
  _declareLogic1SinglerRoutine,
  _declareLogic1ReducingSinglerRoutine,
  _declareLogic1ReducingSinglerAllRoutine,
  _declareLogic1ReducingSinglerAnyRoutine,
  _declareLogic1ReducingSinglerNoneRoutine,
  declareLogic1Routines,
*/

  // interruptible reductor with bool result

  // [ Symbol.for( 'equalAre' ) ] : _equalAre,
  _equalAre,
  // equalAre,
  identicalAre, /* aaa2 : cover please */ /* Dmytro : covered */
  equivalentAre, /* aaa2 : cover please */ /* Dmytro : covered */

  areParallel,

  // helper

  mag,
  magSqr,

  // statistics

  dot,
  distance,
  distanceSqr,

  median,

  momentCentral,
  momentCentralConditional,

  distributionSummary,

  variance,
  varianceConditional,

  std : standardDeviation,
  standardDeviation,
  coefficientOfVariation : standardDeviationNormalized,
  standardDeviationNormalized,

  kurtosis,
  kurtosisNormalized,
  kurtosisExcess : kurtosisNormalized,

  skewness,

}

//

for( let r in Routines )
_.assert( _.routineIs( _routinesMathematical[ r ] ), `routine::${r} was not declared explicitly in the proto map as it should` );

//

let Forbidden =
{
  randomInRange : 'randomInRange',
}

// --
// after
// --

_.assert( _.routineIs( _routinesMathematical.assign ) );
_.assert( _.object.isBasic( _routinesMathematical.assign.operation ) );
_.assert( _.arrayIs( _routinesMathematical.assign.operation.takingArguments ) );

for( let r in _routinesMathematical )
meta._routinePostForm( _routinesMathematical[ r ], r );

// --
// declare
// --

let Extension =
{

  _routinesMathematical,

  contextsForTesting, /* xxx : move out */

  assignScalar,

  addVectorScalar

}

_.props.extend( Extension, _routinesMathematical );
/* _.props.extend */Object.assign( _.vectorAdapter, Extension );

//

_.vectorAdapter._meta._routinesLongWrap_functor();

//

_.assert( _.mapOnlyOwnKey( _.avector, 'withLong' ) );
_.assert( _.object.isBasic( _.avector.withLong ) );
_.assert( _.object.isBasic( _.avector.withLong.Array ) );
_.assert( _.object.isBasic( _.avector.withLong.F32x ) );
_.assert( Object.getPrototypeOf( _.avector ) === wTools );
_.assert( _.object.isBasic( _.vectorAdapter._routinesMathematical ) );
_.assert( !_.avector.isValid );
_.assert( _.routineIs( _.avector.allFinite ) );

//

_.assert( _.routineIs( _.vectorAdapter.reduceToMean ) );
_.assert( !_.vectorAdapter.isValid );
_.assert( _.routineIs( _.vectorAdapter.allFinite ) );
_.assert( _.routineIs( _.vectorAdapter.reduceToMaxValue ) );
_.assert( _.routineIs( _.vectorAdapter.floor ) );
_.assert( _.routineIs( _.vectorAdapter.ceil ) );
_.assert( _.routineIs( _.vectorAdapter.abs ) );
_.assert( _.routineIs( _.vectorAdapter.round ) );
_.assert( _.routineIs( _.vectorAdapter.allIdentical ) );
_.assert( _.routineIs( _.vectorAdapter.isZero ) );
_.assert( _.long.identical( _.vectorAdapter.allIdentical.operation.takingArguments, [ 2, 2 ] ) );
_.assert( _.vectorAdapter.accuracy >= 0 );
_.assert( _.vectorAdapter.accuracySqr >= 0 );
_.assert( _.numberIs( _.vectorAdapter.accuracy ) );
_.assert( _.numberIs( _.vectorAdapter.accuracySqr ) );
_.assert( _.routineIs( _routinesMathematical.reduceToMaxValue ) );

})();

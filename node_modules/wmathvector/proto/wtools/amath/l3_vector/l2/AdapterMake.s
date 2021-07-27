(function _AdapterMake_s_() {

'use strict';

const _ = _global_.wTools;
const _hasLength = _.vector.hasLength;
const _min = Math.min;
const _max = Math.max;
const _longSlice = _.longSlice;
let _sqrt = Math.sqrt;
let _abs = Math.abs;
const _sqr = _.math.sqr;

let vectorAdapter = _.vectorAdapter;
let VectorAdapter = _.VectorAdapter;
let avector = _.avector;

// --
// make
// --

/**
 * Creates vector of default vector type from long {-src-} or length {-length-}.
 *
 * @example
 * var vec = _.avector.make( 3 );
 * console.log( `vec : ${ vec }` );
 * console.log( `vec.toStr() : ${ vec.toStr() }` );
 *
 * @param { Number|Long|VectorAdapter|Null } src - Source long to make vector.
 * @param { Number|Long|VectorAdapter } length - Length of long.
 * @returns { VectorAdapter } - Returns instance of VectorAdapter made from arguments.
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If arguments.length is one and {-src-} has incompatible type.
 * @throws { Error } If arguments.length is two and {-src-} is not null.
 * @throws { Error } If arguments.length is two and {-length-} has incompatible type.
 * @function make
 * @namespace wTools.vectorAdapter
 * @module Tools/math/Vector
 */

function make( src, length )
{
  let self = this;
  _.assert( arguments.length === 1 || src === null );
  _.assert( arguments.length === 2 || length === undefined );

  src = src === null ? length : src;

  if( _.routineIs( self ) )
  self = self.prototype;
  let srcLong = self.long.default.make( src );
  return self.fromLong( srcLong );
}

// function make( length )
// {
//   let self = this;
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   if( _.routineIs( self ) )
//   self = self.prototype;
//   let srcLong = self.long.default.make( length );
//   return self.fromLong( srcLong );
// }

//

/**
* @summary Creates vector from long of length `length` and fills it with element `value`.
* @param {Number} length Length of long.
* @param {*} value Element for fill operation.
*
* @example
* var vec = wTools.vector.makeFilling( 3, 0 );
* console.log( 'vec:', vec );
* console.log( 'vec.toStr():', vec.toStr() );
*
* @function makeFilling
* @namespace wTools.vectorAdapter
* @module Tools/math/Vector
*/

function makeFilling( length, value )
{
  let self = this;
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( length ) );
  if( _.routineIs( self ) )
  self = self.prototype;
  let srcLong = self.long.default.make( length );
  for( let i = 0 ; i < length ; i++ )
  srcLong[ i ] = value;
  return self.defaultVad.fromLong( srcLong );
}

//

function makeUndefined( src, length )
{
  let self = this;
  if( _.routineIs( self ) )
  self = self.prototype;
  let srcLong = self.long.default.makeUndefined( ... arguments );
  return self.defaultVad.fromLong( srcLong );
}

// --
// from
// --

/**
* @summary Creates vector from entity `srcLong`.
* @param {Array} srcLong Source array, vector, space.
*
* @example
* var srcLong = [ 1, 2, 3 ];
* var vec = wTools.vector.from( srcLong );
* console.log( 'vec:', vec );
* console.log( 'vec.toStr():', vec.toStr() );
*
* @function from
* @namespace wTools.vectorAdapter
* @module Tools/math/Vector
*/

function from( src )
{

  _.assert
  (
    arguments.length === 1 || arguments.length === 3 || arguments.length === 4,
    () => `Expects either 1, 3, 4 argument, got ${arguments.length}`
  );

  if( _.vadIs( src ) )
  {
    return src;
  }
  else if( _.longIs( src ) )
  {
    if( arguments.length === 1 )
    return this.fromLong( src );
    else if( arguments.length === 3 )
    return this.fromLongLrange( ... arguments );
    else if( arguments.length === 4 )
    return this.fromLongLrangeAndStride( ... arguments );
    else _.assert( 0 );
  }
  else if( _.object.isBasic( src ) && _.routineIs( src.toVad ) )
  {
    _.assert( arguments.length === 1 );
    return src.toVad();
    // _.assert( src.dims.length === 2 );
    // _.assert( src.dims[ 0 ] === 1 || src.dims[ 1 ] === 1 );
    // if( src.dims[ 0 ] === 1 )
    // return src.rowGet( 0 );
    // else
    // return src.colGet( 0 );
  }
  // else if( _.matrixIs( srcLong ) )
  // {
  //   _.assert( arguments.length === 1 );
  //   _.assert( srcLong.dims.length === 2 );
  //   _.assert( srcLong.dims[ 0 ] === 1 || srcLong.dims[ 1 ] === 1 );
  //   if( srcLong.dims[ 0 ] === 1 )
  //   return srcLong.rowGet( 0 );
  //   else
  //   return srcLong.colGet( 0 );
  // }
  else _.assert( 0, `Can't make VectorAdapter from ${ _.entity.strType( src ) }` );

}

// --
// Extension
// --

let _routinesFrom =
{

  make, /*makeArrayOfLength*/
  makeFilling,

  makeUndefined,

  from,

}

let VectorExtension =
{

  _routinesFrom,

}

_.props.extend( VectorExtension, _routinesFrom );
/* _.props.extend */Object.assign( _.vectorAdapter, VectorExtension );

})();

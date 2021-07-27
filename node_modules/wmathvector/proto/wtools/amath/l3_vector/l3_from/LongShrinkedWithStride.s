(function _LongShrinkedWithStride_s_() {

'use strict';

const _ = _global_.wTools;
const Parent = _.VectorAdapter;

// --
//
// --

const Self = VectorAdapterFromLongShrinkedWithStrideNumberShrinkView;
function VectorAdapterFromLongShrinkedWithStrideNumberShrinkView(){};

//

function _review( cinterval )
{
  let offset = this.offset + cinterval[ 0 ]*this.stride;
  let length = cinterval[ 1 ]-cinterval[ 0 ]+1;
  _.assert( cinterval[ 0 ] >= 0 );
  _.assert( cinterval[ 1 ] <= this.length );
  _.assert( length >= 0 );
  return this.FromLongLrangeAndStride( this._vectorBuffer, offset, length, this.stride );
}

//

function _toLong()
{
  let result;
  if( this.stride !== 1 || this.offset !== 0 || this.length !== this._vectorBuffer.length )
  {
    result = this.vectorAdapter.long.make( this._vectorBuffer, this.length );
    for( let i = 0 ; i < this.length ; i++ )
    result[ i ] = this.eGet( i );
  }
  else
  {
    result = this._vectorBuffer;
  }
  return result;
}

//

function _bufferConstructorGet()
{
  return this._vectorBuffer.constructor;
}

//

Self.prototype =
{
  constructor : Self,
  eGet : function( index )
  {
    let i = this.offset+index*this.stride;
    _.assert( index < this.length );
    _.assert( i < this._vectorBuffer.length );
    return this._vectorBuffer[ i ];
  },
  eSet : function( index, src )
  {
    let i = this.offset+index*this.stride;
    _.assert( index < this.length );
    _.assert( i < this._vectorBuffer.length );
    this._vectorBuffer[ i ] = src;
  },
  _review,
  _toLong,
  _bufferConstructorGet,
}

Object.setPrototypeOf( Self.prototype, Parent.prototype );

//

/**
 * Routine fromLongLrangeAndStride creates vector from part of source Long `srcLong`. The elements of the
 * vector are selected with a defined stride.
 *
 * @param { Long|VectorAdapter } srcLong - Source vector.
 * @param { Number|Range } offset - Offset to sub array in source array `srcLong` or range with offset and length.
 * @param { Number } length - Length of new vector.
 * @param { Number } stride - The stride to select elements of new vector.
 *
 * @example
 * var srcLong = [ 1, 2, 3, 4, 5, 6, 7 ];
 * var got = _.vector.fromLongLrangeAndStride( srcLong, 1, 3, 2 );
 * console.log( got.toStr() );
 * // log "2.000, 4.000, 6.000"
 *
 * var srcLong = [ 1, 2, 3, 4, 5, 6, 7 ];
 * var got = _.vector.fromLongLrangeAndStride( srcLong, 5, 2, -2 );
 * console.log( got.toStr() );
 * // log "6.000, 4.000"
 *
 * @returns { VectorAdapter } - Returns new VectorAdapter.
 * @function fromLongLrangeAndStride
 * @throws { Error } If arguments.length is not equal three or four.
 * @throws { Error } If {-offset-} < 0.
 * @throws { Error } If {-length-} < 0.
 * @throws { Error } If {-offset-} + ( {-length-} - 1 ) * {-stride-} >= 0.
 * @throws { Error } If {-offset-} + ( {-length-} - 1 ) * {-stride-} < {-srcLong-}.length.
 * @namespace wTools.vectorAdapter
 * @module Tools/math/Vector
 */

function fromLongLrangeAndStride( srcLong, offset, length, stride )
{

  if( _.intervalIs( arguments[ 1 ] ) ) /* qqq : make sure it is covered */ /* Andrey: cover */
  {
    [ offset, length ] = arguments[ 1 ];
    stride = arguments[ 2 ];
    _.assert( arguments.length === 3 );
  }
  else
  {
    _.assert( arguments.length === 4 );
  }

  _.assert( offset >= 0 );
  _.assert( length >= 0 );
  _.assert( offset + ( length - 1 ) * stride >= 0 || length === 0 );
  // _.assert( length <= srcLong.length-offset || length === 0 );
  _.assert( offset+(length-1)*stride < srcLong.length );

  if( stride === 1 )
  return this.fromLongLrange( srcLong, offset, length );

  if( srcLong._vectorBuffer )
  {
    throw _.err( 'not implemented' );
  }

  let result = new Self();
  result._vectorBuffer = srcLong;
  result.length = length;
  result.offset = offset;
  result.stride = stride;

  Object.freeze( result );
  return result;
}

//

/**
 * Routine fromLongWithStride creates vector from all elements of source Long `srcLong`. The elements of the
 * vector are selected with a defined stride.
 *
 * @param { Long|VectorAdapter } srcLong - Source vector.
 * @param { Number } stride - The stride to select elements of new vector.
 *
 * @example
 * var srcLong = [ 1, 2, 3, 4, 5, 6, 7 ];
 * var got = _.vector.fromLongWithStride( srcLong, 3 );
 * console.log( got.toStr() );
 * // log "1.000, 4.000, 7.000"
 *
 * @returns { VectorAdapter } - Returns new VectorAdapter.
 * @function fromLongWithStride
 * @namespace wTools.vectorAdapter
 * @module Tools/math/Vector
 */

function fromLongWithStride( srcLong, stride )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return this.fromLongLrangeAndStride( srcLong, 0, Math.ceil( srcLong.length / stride ), stride );
}

// --
// extension
// --

let _routinesFrom =
{

  fromLongLrangeAndStride,
  fromLongWithStride,

}

let VectorExtension =
{

}
_.props.supplement( VectorExtension, _routinesFrom );
_.props.supplement( _.vectorAdapter._routinesFrom, _routinesFrom );
_.props.supplement( _.vectorAdapter, VectorExtension );

})();

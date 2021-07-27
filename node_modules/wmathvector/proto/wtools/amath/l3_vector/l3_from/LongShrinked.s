(function _LongShrinked_s_() {

'use strict';

const _ = _global_.wTools;
const Parent = _.VectorAdapter;

// --
//
// --

const Self = VectorAdapterFromLongShrinked;
function VectorAdapterFromLongShrinked(){};

//

function _review( cinterval )
{
  let offset = this.offset + cinterval[ 0 ];
  let length = cinterval[ 1 ]-cinterval[ 0 ]+1;
  _.assert( cinterval[ 0 ] >= 0 );
  _.assert( cinterval[ 1 ] <= this.length );
  _.assert( length >= 0 );
  return this.FromLongLrange( this._vectorBuffer, offset, length );
}

//

function _toLong()
{
  let result;
  if( this.offset !== 0 || this.length !== this._vectorBuffer.length )
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
    _.assert( index < this.length );
    return this._vectorBuffer[ this.offset + index ];
  },
  eSet : function( index, src )
  {
    _.assert( index < this.length );
    this._vectorBuffer[ this.offset + index ] = src;
  },
  _review,
  _toLong,
  _bufferConstructorGet,
}

_.props.constant( Self.prototype,
{
  stride : 1,
});

Object.setPrototypeOf( Self.prototype, Parent.prototype );

//

/**
 * Routine fromLongLrange() creates vector from part of source Long `srcLong`. Offset and length may be passed as arguments or as range array as second argument.
 *
 * @param { Long|VectorAdapter } srcLong - Source Long or vector.
 * @param { Number|Range } offset - Offset in source Long or range with offset and length.
 * @param { Number } length - Length of new vector.
 *
 * @example
 * var srcLong = [ 1, 2, 3 ];
 * var got = _.vectorAdapter.fromLongLrange( srcLong, 1, 2 );
 * console.log( got.toStr() );
 * // log "2.000, 3.000"
 *
 * var srcLong = [ 1, 2, 3 ];
 * var got = _.vectorAdapter.fromLongLrange( srcLong, [ 1, 2 ] );
 * console.log( got.toStr() );
 * // log "2.000, 3.000"
 *
 * @returns { VectorAdapter } - Returns new VectorAdapter from part of source Long.
 * @function fromLongLrange
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-offset-} < 0.
 * @throws { Error } If {-length-} < 0.
 * @throws { Error } If {-offset-} + {-length-} > {-srcLong-}.length.
 * @namespace wTools.vectorAdapter
 * @module Tools/math/Vector
 */

function fromLongLrange( srcLong, offset, length )
{

  if( offset === undefined )
  offset = 0;

  if( length === undefined )
  length = srcLong.length - offset;

  _.assert( _.numberIs( offset ) || _.intervalIs( offset ) );
  _.assert( _.numberIs( length ) );

  if( _.intervalIs( arguments[ 1 ] ) ) /* qqq : make sure it is covered */ /* Andrey: cover */
  [ offset, length ] = arguments[ 1 ];

  _.assert( arguments.length >= 1 && arguments.length <= 3, 'Expects from one to three arguments' );
  _.assert( !!srcLong ); // _.assert( _.vectorAdapterIs( srcLong ) || _.longIs( srcLong ) ); ?
  _.assert( offset >= 0 );
  _.assert( length >= 0 );
  _.assert( offset+length <= srcLong.length );

  if( _.vectorAdapterIs( srcLong ) )
  {
    return srcLong._review( [ offset, offset+length-1 ] );
  }

  let result = new Self();
  result._vectorBuffer = srcLong;
  result.length = length;
  result.offset = offset;

  // Object.freeze( result );
  return result;
}

//

function updateLrange( srcVad, offset, length )
{
  _.assert( offset+length <= srcVad._vectorBuffer.length );
  
  srcVad.length = length;
  srcVad.offset = offset;
  
  return srcVad;
}

// --
// extension
// --

let _routinesFrom =
{

  fromLongLrange, /* qqq : cover routine _.vectorAdapter.fromLongLrange and all _.vectorAdapter.from* routines. coverage should be perfect */

}

let VectorExtension =
{
  updateLrange
}

_.props.supplement( VectorExtension, _routinesFrom );
_.props.supplement( _.vectorAdapter._routinesFrom, _routinesFrom );
_.props.supplement( _.vectorAdapter, VectorExtension );

})();

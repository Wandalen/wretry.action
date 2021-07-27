(function _Long_s_() {

'use strict';

const _ = _global_.wTools;
const Parent = _.VectorAdapter;

// --
//
// --

const Self = VectorAdapterFromLong;
function VectorAdapterFromLong(){};


//

function _review( cinterval )
{
  let offset = cinterval[ 0 ];
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
  result = this._vectorBuffer;
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
  _lengthGet : function(){ return this._vectorBuffer.length; },
  eGet : function( index ){ return this._vectorBuffer[ index ]; },
  eSet : function( index, src ){ this._vectorBuffer[ index ] = src; },
  _review,
  _toLong,
  _bufferConstructorGet,
}

_.accessor.readOnly
({
  object : Self.prototype,
  prime : 0,
  names :
  {
    length : 'length',
  },
});

_.props.constant( Self.prototype,
{
  offset : 0,
  stride : 1,
});

Object.setPrototypeOf( Self.prototype, Parent.prototype );

//

/**
 * Routine fromLong creates vector from source Long `srcLong`.
 *
 * @param { Long|VectorAdapter } srcLong - Source Long or vector.
 *
 * @example
 * var srcLong = [ 1, 2, 3 ];
 * var got = _.vectorAdapter.fromLong( srcLong );
 * console.log( got.toStr() );
 * // log "1.000, 2.000, 3.000"
 *
 * @returns { VectorAdapter } - Returns new VectorAdapter from source Long.
 * @function fromLong
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-srcLong-} is not a Long, not a VectorAdapter.
 * @namespace wTools.vectorAdapter
 * @module Tools/math/Vector
 */

function fromLong( srcLong )
{

  _.assert( arguments.length === 1 );
  _.assert( _.vectorAdapterIs( srcLong ) || _.longIs( srcLong ) );

  if( srcLong._vectorBuffer )
  return srcLong;

  let result = new Self();
  result._vectorBuffer = srcLong;

  Object.freeze( result );
  return result;
}

// --
// extension
// --

let _routinesFrom =
{

  fromLong,

}

let VectorExtension =
{
}

_.props.supplement( VectorExtension, _routinesFrom );
_.props.supplement( _.vectorAdapter._routinesFrom, _routinesFrom );
_.props.supplement( _.vectorAdapter, VectorExtension );

})();

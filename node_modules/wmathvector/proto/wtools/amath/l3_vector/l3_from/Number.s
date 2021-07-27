(function _Number_s_() {

'use strict';

const _ = _global_.wTools;
const Parent = _.VectorAdapter;

// --
//
// --

const Self = AdapterFromNumber;
function AdapterFromNumber() {};

//

function _review( cinterval )
{
  let l = cinterval[ 1 ] - cinterval[ 0 ] + 1;
  _.assert( l >= 0 );
  return this.FromMaybeNumber( this._vectorBuffer[ 0 ], l );
}

//

function _toLong()
{
  let result;
  // result = this.vectorAdapter.longMakeFilling( this._vectorBuffer[ 0 ], this.length );
  result = this.vectorAdapter.long.makeFilling( this._vectorBuffer[ 0 ], this.length );
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
  eGet : function( index ){ return this._vectorBuffer[ 0 ]; },
  eSet : function( index, src ){ this._vectorBuffer[ 0 ] = src; },
  _review,
  _toLong,
  _bufferConstructorGet,
}

_.props.constant( Self.prototype,
{
  offset : 0,
  stride : 0,
});

Object.setPrototypeOf( Self.prototype, Parent.prototype );

//

/**
 * Routine fromNumber() creates vector of length `length` from value of `number`.
 *
 * @param { Number } number - Source number.
 * @param { Number } length - Length of new vector.
 *
 * @example
 * var got = wTools.vector.fromNumber( 3, 2 );
 * console.log( got.toStr() );
 * // log "3.000, 3.000"
 *
 * @returns { VectorAdapter } - Returns new VectorAdapter instance.
 * @function fromNumber
 * @namespace wTools.vectorAdapter
 * @module Tools/math/Vector
 */

function fromNumber( number, length )
{
  let numberIs = _.numberIs( number );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( length >= 0 );
  _.assert( numberIs || _.vectorAdapterIs( number ) );

  if( !numberIs )
  {
    _.assert( number.length === length, () => `Inconsistant length ${number.length} <> ${length}` );
    return number;
  }

  let result = new Self();
  result._vectorBuffer = this.longType.long.make( 1 );
  result._vectorBuffer[ 0 ] = number;

  // if( result._vectorBuffer[ 0 ] !== number )
  // {
  //   result._vectorBuffer = this.withLong.F64x.long.make( 1 )
  //   result._vectorBuffer[ 0 ] = number;
  // }

  _.props.constant( result, { length } );

  return result;
}

//

/**
 * Routine fromMaybeNumber() creates vector of length `length` from value of `number`.
 * Also, routine can make new vector from Long or VectorAdapter.
 *
 * @param { Number|Long|VectorAdapter } number - Source number, vector or array.
 * @param { Number } length - Length of new vector.
 *
 * @example
 * var got = _.vectorAdapter.fromMaybeNumber( 3, 2 );
 * console.log( got.toStr() );
 * // log "3.000, 3.000"
 *
 * @returns { VectorAdapter } - Returns new VectorAdapter instance.
 * @function fromMaybeNumber
 * @namespace wTools.vectorAdapter
 * @module Tools/math/Vector
 */

function fromMaybeNumber( number, length )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( length >= 0 );

  if( _.longIs( number ) )
  {
    _.assert( number.length === length, () => `Inconsistant length ${number.length} <> ${length}` );
    return this.fromLong( number );
  }

  let result = this.fromNumber( number, length );
  return result;
}

// --
// extension
// --

let _routinesFrom =
{

  fromNumber,
  fromMaybeNumber,

}

let VectorExtension =
{

}

_.props.supplement( VectorExtension, _routinesFrom );
_.props.supplement( _.vectorAdapter._routinesFrom, _routinesFrom );
_.props.supplement( _.vectorAdapter, VectorExtension );

})();

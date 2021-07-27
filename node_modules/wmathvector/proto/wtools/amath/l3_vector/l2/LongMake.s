(function _LongMake_s_() {

'use strict';

const _ = _global_.wTools;
const _hasLength = _.vector.hasLength;
const _min = Math.min;
const _max = Math.max;
const _longSlice = _.longSlice;
let _sqrt = Math.sqrt;
let _abs = Math.abs;
const _sqr = _.math.sqr;

// --
// From
// --

/**
* @summary Creates vector From array of length `length`.
* @param {Number} length Length of array.
*
* @example
* var vec = wTools.vector.make( 3 );
* console.log( 'vec:', vec );
* console.log( 'vec.toStr():', vec.toStr() );
*
* @function make
* @namespace wTools.avector
* @module Tools/math/Vector
*/

function make( length )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( _.routineIs( self ) )
  self = self.prototype;
  let srcLong = self.long.default.make( length );
  return srcLong;
}

//

/**
* @summary Creates vector From array of length `length` and fills it with element `value`.
* @param {Number} length Length of array.
* @param {*} value Element for fill operation.
*
* @example
* var vec = wTools.vector.makeFilling( 3, 0 );
* console.log( 'vec:', vec );
* console.log( 'vec.toStr():', vec.toStr() );
*
* @function makeFilling
* @namespace wTools.avector
* @module Tools/math/Vector
*/

function makeFilling( length, value )
{
  let self = this;
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( _.routineIs( self ) )
  self = self.prototype;
  let srcLong = self.long.default.make( length );
  for( let i = 0 ; i < length ; i++ )
  srcLong[ i ] = value;
  return srcLong;
}

// --
// extension
// --

let _routinesFrom =
{

  make, /*makeArrayOfLength*/
  makeFilling,

}

let AvectorExtension =
{

  _routinesFrom : _routinesFrom,

}

_.props.extend( AvectorExtension, _routinesFrom );
/* _.props.extend */Object.assign( _.avector, AvectorExtension );

})();

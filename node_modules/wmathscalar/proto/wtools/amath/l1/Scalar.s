(function _Scalar_s_() {

'use strict';

/**
 * Collection of functions for non-vector math
  @module Tools/math/Scalar
*/

/**
 *  */

/**
 *@summary Collection of functions for non-vector math
  @extends Tools
  @namespace wTools.math
  @module Tools/math/Scalar
*/

if( typeof module !== 'undefined' )
{

  require( '../../../node_modules/Tools' );

  const _ = _global_.wTools;

}

const _ = _global_.wTools;
let _random = Math.random;
let _floor = Math.floor;
let _ceil = Math.ceil;
let _round = Math.round;

let degToRadFactor = Math.PI / 180.0;
let radToDegFactor = 180.0 / Math.PI;
_.math = _.math || _.props.extend( null, _.props.of( Math, { onlyOwn : 1, onlyEnumerable : 0 } ) );

_.assert( _.math.cos === Math.cos );

// --
// basic
// --

function isPowerOfTwo( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( src ) );

  return ( src & ( src - 1 ) ) === 0 && src !== 0;
}

/**
 * @summary Returns fractal part of a number `src`.
 * @param {Number} src Source number
 * @function fract
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function fract( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( src ) );
  return src - _floor( src );
}

//

/**
 * @summary Converts degree `src` to radian.
 * @param {Number} src Source number
 * @function degToRad
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function degToRad( srcDegrees )
{
  return degToRadFactor * srcDegrees;
}

//

/**
 * @summary Converts radian `src` to degree.
 * @param {Number} src Source number
 * @function radToDeg
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function radToDeg( srcRadians )
{
  return radToDegFactor * srcRadians;
}

//

/* Calculates the factorial of an integer number ( >= 0 ) */

function _factorial( src )
{
  let result = 1;
  while( src > 1 )
  {
    result = result * src;
    src -= 1;
  }
  return result;
}

//

/**
 * @summary Returns factorial for number `src`.
 * @description Number `src`
 * @param {Number} src Source number. Should be less than 10000.
 * @function factorial
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function factorial( src )
{
  _.assert( src < 10000 );
  _.assert( _.intIs( src ) );
  _.assert( src >= 0 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( src === 0 )
  return 1;
  return _.math._factorial( src )
}

//

function fibonacci( degree )
{

  _.assert( degree >= 0 );
  _.assert( _.intIs( degree ) );

  let phi = ( Math.sqrt( 5 ) + 1 ) * 0.5;
  let phiPow = Math.pow( phi, degree-1 );
  let phiSqr = phi*phi;
  let sign = degree % 2 === 0 ? -1 : +1;
  let result = ( phiPow*phiSqr + sign / phiPow ) / ( 1 + phiSqr );

  return result;
}

//

function clamp( src , low , high )
{
  return _.numberClamp.apply( _, arguments );
}

//

/**
 * @summary Short-cut for Math.sqrt.
 * @param {Number} src Source number.
 * @function sqrt
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function sqrt( src )
{
  return Math.sqrt( src );
}

//

/**
 * @summary Returns square root of number `src`.
 * @param {Number} src Source number.
 * @function sqr
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function sqr( src )
{
  return src * src;
}

//

/**
 * @summary Returns cube of number `src`.
 * @param {Number} src Source number.
 * @function cbd
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function cbd( src )
{
  return src * src * src;
}

//

/**
 * @summary Returns cubic root.
 * @param {Number} src Source number.
 * @function cbrt
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function cbrt( src )
{
  var result = Math.pow( Math.abs( src ), 1/3 );
  return x < 0 ? -result : result;
}

//

/**
 * @summary Returns remainder after division of `src1` by `src2`.
 * @param {Number} src1 First number.
 * @param {Number} src2 Second number.
 * @function mod
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function mod( src1, src2 )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  let result = src1 - src2 * Math.floor( src1 / src2 );
  return result;
}

//

/**
 * @summary Returns sing of a number. `-1` if number is negative, `+1` if positive, otherwise `0`.
 * @param {Number} src Source number.
 * @function sign
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function sign( src )
{

  return ( src < 0 ) ? - 1 : ( src > 0 ) ? 1 : 0;

}

//

/**
 * @summary Calculates sine and cosine of a number `src`. Returns map with two properties : `s` - for sine result, `c` - for cosine.
 * @param {Number} src Source number.
 * @function sc
 * @namespace wTools.math
 * @module Tools/math/Scalar
 */

function sc( src )
{
  let result = Object.create( null );

  result.s = Math.sin( src );
  result.c = Math.cos( src );

  return result;
}

// --
// round
// --

function roundToPowerOfTwo( src )
{

  _.assert( _.numberIs( src ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( src >= 0 );

  return Math.pow( 2, Math.round( Math.log( src ) / Math.LN2 ) );

}

//

function ceilToPowerOfTwo( src )
{

  _.assert( _.numberIs( src ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( src >= 0 );

  return Math.pow( 2, _ceil( Math.log( src ) / Math.LN2 ) );

}

//

function floorToPowerOfTwo( src )
{

  _.assert( _.numberIs( src ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( src >= 0 );

  return Math.pow( 2, Math.floor( Math.log( src ) / Math.LN2 ) );
}

// --
//
// --

Object.defineProperty( _.math, 'accuracy', {
  get : function() { return this.tools.accuracy },
});

Object.defineProperty( _.math, 'accuracySqr', {
  get : function() { return this.tools.accuracySqr },
});

Object.defineProperty( _.math, 'accuracySqrt', {
  get : function() { return this.tools.accuracySqrt },
});

// --
// declare
// --

let Extension =
{

  // basic

  isPowerOfTwo,

  fract,
  _factorial,
  factorial,
  fibonacci,

  degToRad,
  radToDeg,

  clamp,
  sqrt,
  sqr,
  cbd,
  cbrt,

  mod,
  sign,
  sc,

  // round

  roundToPowerOfTwo,
  ceilToPowerOfTwo,
  floorToPowerOfTwo,

  // var

  tools : _,

}

_.props.supplement( _.math, Extension );
_.assert( _.math.accuracy >= 0 );
_.assert( _.math.accuracySqr >= 0 );
_.assert( _.accuracy >= 0 );
_.assert( _.accuracySqr >= 0 );
_.assert( _.math.accuracy === _.accuracy );
_.assert( _.math.accuracySqr === _.accuracySqr );

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

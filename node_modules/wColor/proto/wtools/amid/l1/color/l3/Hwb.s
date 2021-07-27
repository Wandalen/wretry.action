(function _ColorHwb_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to convert from hwb into rgb.
 * @module Tools/mid/Color
*/

/**
 * @summary Collection of cross-platform routines to operate colors conveniently.
 * @namespace wTools.color.hwb
 * @module Tools/mid/Color
*/

const _ = _global_.wTools;
const Self = _.color.hwb = _.color.hwb || Object.create( null );

// --
// implement
// --

function _strToRgb( dst, src )
{
  /*
    hwb(H, W, B)
  */

  _.assert( arguments.length === 2, 'Expects 2 arguments' );
  _.assert( _.strIs( src ) );
  _.assert( dst === null || _.vectorIs( dst ) );

  let hwbColors = _.color.hwb._formatStringParse( src );

  _.assert
  (
    hwbColors.length === 3 || hwbColors.length === 4,
    `{-src-} string must contain exactly 3 or 4 numbers, but got ${hwbColors.length}`
  );
  _.assert
  (
    hwbColors[ 3 ] === undefined || hwbColors[ 3 ] === 100,
    `alpha channel must be 100, but got ${hwbColors[ 3 ]}`
  );

  if( !_.color.hwb._validate( hwbColors ) )
  return null;

  /* normalize ranges */
  hwbColors[ 0 ] = hwbColors[ 0 ] / 360;
  hwbColors[ 1 ] = hwbColors[ 1 ] / 100;
  hwbColors[ 2 ] = hwbColors[ 2 ] / 100;
  if( hwbColors[ 3 ] )
  hwbColors[ 3 ] = hwbColors[ 3 ] / 100;

  return _.color.hwb._longToRgb( dst, hwbColors );

}

//

function _longToRgb( dst, src )
{
  _.assert( src.length === 3 || src.length === 4, `{-src-} length must be 3 or 4, but got : ${src.length}` );
  _.assert( src[ 3 ] === undefined || src[ 3 ] === 1, `alpha channel must be 1, but got : ${src[ 3 ]}` );

  if( !_.color._validateNormalized( src ) )
  return null;

  let r, g, b;

  if( dst === null || _.longIs( dst ) )
  {
    dst = dst || new Array( 3 );
    _.assert( dst.length === 3, `{-dst-} container length must be 3, but got : ${dst.length}` );

    convert( src );

    /*
      TypedArray:

      For non-basic colors with r, g, b values in range ( 0, 1 )
      only instances of those constructors can be used
      Float32Array,
      Float64Array,
    */

    dst[ 0 ] = r;
    dst[ 1 ] = g;
    dst[ 2 ] = b;

  }
  else if( _.vadIs( dst ) )
  {
    /* optional dependency */

    _.assert( dst.length === 3, `{-dst-} container length must be 3, but got : ${dst.length}` );

    convert( src );

    dst.eSet( 0, r );
    dst.eSet( 1, g );
    dst.eSet( 2, b );
  }
  else _.assert( 0, '{-dts-} container must be of type Vector' );

  return dst;

  /* - */

  function convert( src )
  {
    let h = src[ 0 ];
    let wh = src[ 1 ];
    let bl = src[ 2 ];
    let ratio = wh + bl;
    let i, v, f, n;

    /* wh + bl cannot be > 1 */
    if( ratio > 1 )
    {
      wh /= ratio;
      bl /= ratio;
    }

    i = Math.floor( 6 * h );
    v = 1 - bl;
    f = 6 * h - i;

    if( ( i & 0x01 ) !== 0 )
    {
      f = 1 - f;
    }

    /* linear interpolation */
    n = wh + f * ( v - wh );

    switch( i )
    {
      case 6 :
      case 0 : r = v; g = n; b = wh; break;
      case 1 : r = n; g = v; b = wh; break;
      case 2 : r = wh; g = v; b = n; break;
      case 3 : r = wh; g = n; b = v; break;
      case 4 : r = n; g = wh; b = v; break;
      case 5 : r = v; g = wh; b = n; break;
      default : break;
    }
  }


}

//

function _validate ( src )
{
  if
  (
    !_.cinterval.has( [ 0, 360 ], src[ 0 ] )
    || !_.cinterval.has( [ 0, 100 ], src[ 1 ] )
    || !_.cinterval.has( [ 0, 100 ], src[ 2 ] )
  )
  return false;

  return true;
}

//

function _formatStringParse( src )
{
  _.assert( /^hwb\(\d{1,3}, ?\d{1,3}%, ?\d{1,3}%(, ?\d{1,3}%)?\)$/g.test( src ), 'Wrong source string pattern' );
  return src.match( /\d+(\.\d+)?/g ).map( ( el ) => +el );
}

// --
// declare
// --

let Extension =
{

  // to rgb/a

  _strToRgb,
  _longToRgb,
  _validate,

  _formatStringParse

}

_.props.supplement( _.color.hwb, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

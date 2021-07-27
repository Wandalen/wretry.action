(function _ColorXyza_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to convert from xyza into rgb.
 * @module Tools/mid/Color
*/

/**
 * @summary Collection of cross-platform routines to operate colors conveniently.
 * @namespace wTools.color.xyza
 * @module Tools/mid/Color
*/

const _ = _global_.wTools;
let Self = _.color.xyza = _.color.xyza || Object.create( null );

// --
// implement
// --

function _strToRgba( dst, src )
{
  /*
    xyza(H, S, L, A)
  */

  _.assert( arguments.length === 2, 'Expects 2 arguments' );
  _.assert( _.strIs( src ) );
  _.assert( dst === null || _.vectorIs( dst ) );

  let xyzaColors = _.color.xyza._formatStringParse( src );

  _.assert
  (
    xyzaColors.length === 3 || xyzaColors.length === 4,
    `{-src-} string must contain exactly 3 or 4 numbers, but got ${xyzaColors.length}`
  );

  if( !_.color.xyza._validate( xyzaColors ) )
  return null;

  /* normalize ranges */
  xyzaColors[ 0 ] = xyzaColors[ 0 ] / 100;
  xyzaColors[ 1 ] = xyzaColors[ 1 ] / 100;
  xyzaColors[ 2 ] = xyzaColors[ 2 ] / 100;
  if( xyzaColors[ 3 ] )
  xyzaColors[ 3 ] = xyzaColors[ 3 ] / 100;

  return _.color.xyza._longToRgba( dst, xyzaColors );

}

//

function _longToRgba( dst, src )
{
  _.assert( src.length === 3 || src.length === 4, `{-src-} length must be 3 or 4, but got : ${src.length}` );

  /*
    Values greater than 1.0 are allowed and must not be clamped; they represent colors brighter than diffuse white.
    https://drafts.csswg.org/css-color/#valdef-color-xyz
  */
  // if( !_.color._validateNormalized( src ) )
  // return null;
  if
  (
    src[ 0 ] < 0
    || src[ 1 ] < 0
    || src[ 2 ] < 0
    || src[ 3 ] !== undefined && !_.cinterval.has( [ 0, 100 ], src[ 3 ] )
  )
  return null;

  let r, g, b;
  let a = 1;

  if( dst === null || _.longIs( dst ) )
  {
    dst = dst || new Array( 4 );
    _.assert( dst.length === 4, `{-dst-} container length must be 4, but got : ${dst.length}` );

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
    dst[ 3 ] = a;

  }
  else if( _.vadIs( dst ) )
  {
    /* optional dependency */

    _.assert( dst.length === 4, `{-dst-} container length must be 4, but got : ${dst.length}` );

    convert( src );

    dst.eSet( 0, r );
    dst.eSet( 1, g );
    dst.eSet( 2, b );
    dst.eSet( 3, a );
  }
  else _.assert( 0, '{-dts-} container must be of type Vector' );

  return dst;

  /* - */

  function convert( src )
  {
    let x = src[ 0 ];
    let y = src[ 1 ];
    let z = src[ 2 ];
    if( src[ 3 ] !== undefined )
    a = src[ 3 ];

    r = adj( x * 3.2406 + y * -1.5372 + z * -0.4986 );
    g = adj( x * -0.9689 + y * 1.8758 + z * 0.0415 );
    b = adj( x * 0.0557 + y * -0.2040 + z * 1.0570 );

    function adj( channel ) /* gamma correction */
    {
      if( Math.abs( channel ) < 0.0031308 )
      {
        return 12.92 * channel;
      }
      return 1.055 * Math.pow( channel, 0.41666 ) - 0.055;
    }
  }


}

//

function _validate ( src )
{
  if
  (
    src[ 0 ] < 0
    || src[ 1 ] < 0
    || src[ 2 ] < 0
    || ( src[ 3 ] !== undefined && !_.cinterval.has( [ 0, 100 ], src[ 3 ] ) )
  )
  return false;

  return true;
}

//

function _formatStringParse( src )
{
  _.assert( /^xyza\(\d+(\.\d+)?, ?\d+(\.\d+)?, ?\d+(\.\d+)?(, ?\d{1,3}%)?\)$/g.test( src ), 'Wrong source string pattern' );
  return src.match( /\d+(\.\d+)?/g ).map( ( el ) => +el );
}

// --
// declare
// --

let Extension =
{

  // to rgb/a

  _strToRgba,
  _longToRgba,
  _validate,

  _formatStringParse

}

_.props.supplement( _.color.xyza, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

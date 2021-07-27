(function _ColorXyz_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to convert from xyz into rgb.
 * @module Tools/mid/Color
*/

/**
 * @summary Collection of cross-platform routines to operate colors conveniently.
 * @namespace wTools.color.xyz
 * @module Tools/mid/Color
*/

const _ = _global_.wTools;
let Self = _.color.xyz = _.color.xyz || Object.create( null );

// --
// implement
// --

function _strToRgb( dst, src )
{
  /*
    xyz(X, Y, Z)
  */

  _.assert( arguments.length === 2, 'Expects 2 arguments' );
  _.assert( _.strIs( src ) );
  _.assert( dst === null || _.vectorIs( dst ) );

  let xyzColors = _.color.xyz._formatStringParse( src );

  _.assert
  (
    xyzColors.length === 3 || xyzColors.length === 4,
    `{-src-} string must contain exactly 3 or 4 numbers, but got ${xyzColors.length}`
  );
  _.assert
  (
    xyzColors[ 3 ] === undefined || xyzColors[ 3 ] === 100,
    `alpha channel must be 100, but got ${xyzColors[ 3 ]}`
  );

  if( !_.color.xyz._validate( xyzColors ) )
  return null;

  /* normalize ranges */
  xyzColors[ 0 ] = xyzColors[ 0 ] / 100;
  xyzColors[ 1 ] = xyzColors[ 1 ] / 100;
  xyzColors[ 2 ] = xyzColors[ 2 ] / 100;
  if( xyzColors[ 3 ] )
  xyzColors[ 3 ] = xyzColors[ 3 ] / 100;

  return _.color.xyz._longToRgb( dst, xyzColors );

}

//

function _longToRgb( dst, src )
{
  _.assert( src.length === 3 || src.length === 4, `{-src-} length must be 3 or 4, but got : ${src.length}` );
  _.assert( src[ 3 ] === undefined || src[ 3 ] === 1, `alpha channel must be 1, but got : ${src[ 3 ]}` );

  /*
    Values greater than 1.0 are allowed and must not be clamped; they represent colors brighter than diffuse white.
    https://drafts.csswg.org/css-color/#valdef-color-xyz
  */
  // if( !_.color._validateNormalized( src ) )
  // return null;
  if( src[ 0 ] < 0 || src[ 1 ] < 0 || src[ 2 ] < 0 )
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
    let x = src[ 0 ];
    let y = src[ 1 ];
    let z = src[ 2 ];

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
  )
  return false;

  return true;
}

//

function _formatStringParse( src )
{
  _.assert( /^xyz\(\d+(\.\d+)?, ?\d+(\.\d+)?, ?\d+(\.\d+)?(, ?\d{1,3}%)?\)$/g.test( src ), 'Wrong source string pattern' );
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

_.props.supplement( _.color.xyz, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

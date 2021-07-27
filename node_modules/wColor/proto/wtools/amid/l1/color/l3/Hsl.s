(function _ColorHsl_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to convert from hsl into rgb.
 * @module Tools/mid/Color
*/

/**
 * @summary Collection of cross-platform routines to operate colors conveniently.
 * @namespace wTools.color.hsl
 * @module Tools/mid/Color
*/

const _ = _global_.wTools;
const Self = _.color.hsl = _.color.hsl || Object.create( null );

// --
// implement
// --

function _strToRgb( dst, src )
{
  /*
    hsl(H, S, L)
  */

  _.assert( arguments.length === 2, 'Expects 2 arguments' );
  _.assert( _.strIs( src ) );
  _.assert( dst === null || _.vectorIs( dst ) );

  let hslColors = _.color.hsl._formatStringParse( src );

  _.assert
  (
    hslColors.length === 3 || hslColors.length === 4,
    `{-src-} string must contain exactly 3 or 4 numbers, but got ${hslColors.length}`
  );
  _.assert
  (
    hslColors[ 3 ] === undefined || hslColors[ 3 ] === 100,
    `alpha channel must be 100, but got ${hslColors[ 3 ]}`
  );

  if( !_.color.hsl._validate( hslColors ) )
  return null;

  /* normalize ranges */
  hslColors[ 0 ] = hslColors[ 0 ] / 360;
  hslColors[ 1 ] = hslColors[ 1 ] / 100;
  hslColors[ 2 ] = hslColors[ 2 ] / 100;
  if( hslColors[ 3 ] )
  hslColors[ 3 ] = hslColors[ 3 ] / 100;

  return _.color.hsl._longToRgb( dst, hslColors );

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
    [ r, g, b ] = _.color.hslToRgb( src );
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
  _.assert( /^hsl\(\d{1,3}, ?\d{1,3}%, ?\d{1,3}%(, ?\d{1,3}%)?\)$/g.test( src ), 'Wrong source string pattern' );
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

_.props.supplement( _.color.hsl, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

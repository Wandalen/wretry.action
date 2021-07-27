(function _ColorCmyk_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to convert from cmyk into rgb.
 * @module Tools/mid/Color
*/

/**
 * @summary Collection of cross-platform routines to operate colors conveniently.
 * @namespace wTools.color.cmyk
 * @module Tools/mid/Color
*/

const _ = _global_.wTools;
const Self = _.color.cmyk = _.color.cmyk || Object.create( null );

// --
// implement
// --

function _strToRgb( dst, src )
{
  /*
    cmyk(C, M, Y, K)
  */

  _.assert( arguments.length === 2, 'Expects 2 arguments' );
  _.assert( _.strIs( src ) );
  _.assert( dst === null || _.vectorIs( dst ) );

  let cmykColors = _.color.cmyk._formatStringParse( src );

  _.assert
  (
    cmykColors.length === 4 || cmykColors.length === 5,
    `{-src-} string must contain exactly 4 or 5 numbers, but got ${cmykColors.length}`
  );
  _.assert
  (
    cmykColors[ 4 ] === undefined || cmykColors[ 4 ] === 100,
    `alpha channel must be 100, but got ${cmykColors[ 4 ]}`
  );

  if( !_.color.cmyk._validate( cmykColors ) )
  return null;

  /* normalize ranges */
  cmykColors[ 0 ] = cmykColors[ 0 ] / 100;
  cmykColors[ 1 ] = cmykColors[ 1 ] / 100;
  cmykColors[ 2 ] = cmykColors[ 2 ] / 100;
  cmykColors[ 3 ] = cmykColors[ 3 ] / 100;
  if( cmykColors[ 4 ] )
  cmykColors[ 4 ] = cmykColors[ 4 ] / 100;

  return _.color.cmyk._longToRgb( dst, cmykColors );

}

//

function _longToRgb( dst, src )
{
  _.assert( src.length === 4 || src.length === 5, `{-src-} length must be 4 or 5, but got : ${src.length}` );
  _.assert( src[ 4 ] === undefined || src[ 4 ] === 1, `alpha channel must be 1, but got : ${src[ 5 ]}` );

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
    r = ( 1 - src[ 0 ] ) * ( 1 - src[ 3 ] );
    g = ( 1 - src[ 1 ] ) * ( 1 - src[ 3 ] );
    b = ( 1 - src[ 2 ] ) * ( 1 - src[ 3 ] );
  }

}

//

function _validate ( src )
{
  if
  (
    !_.cinterval.has( [ 0, 100 ], src[ 0 ] )
    || !_.cinterval.has( [ 0, 100 ], src[ 1 ] )
    || !_.cinterval.has( [ 0, 100 ], src[ 2 ] )
    || !_.cinterval.has( [ 0, 100 ], src[ 3 ] )
  )
  return false;

  return true;
}

//

function _formatStringParse( src )
{
  _.assert( /^cmyk\(\d{1,3}%,\d{1,3}%,\d{1,3}%,\d{1,3}%(,\d{1,3}%)?\)$/g.test( src ), 'Wrong source string pattern' );
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

_.props.supplement( _.color.cmyk, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

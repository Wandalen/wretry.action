(function _ColorCmyka_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to convert from cmyka ( a - alpha channel ) into rgba.
 * @module Tools/mid/Color
*/

/**
 * @summary Collection of cross-platform routines to operate colors conveniently.
 * @namespace wTools.color.cmyka
 * @module Tools/mid/Color
*/

const _ = _global_.wTools;
const Self = _.color.cmyka = _.color.cmyka || Object.create( null );

// --
// implement
// --

function _strToRgba( dst, src )
{
  /*
    cmyka(C, M, Y, K, A)
  */

  _.assert( arguments.length === 2, 'Expects 2 arguments' );
  _.assert( _.strIs( src ) );
  _.assert( dst === null || _.vectorIs( dst ) );

  let cmykColors = _.color.cmyka._formatStringParse( src );
  _.assert
  (
    cmykColors.length === 4 || cmykColors.length === 5,
    `{-src-} string must contain exactly 4 or 5 numbers, but got ${cmykColors.length}`
  );

  if( !_.color.cmyka._validate( cmykColors ) )
  return null;

  /* normalize ranges */
  cmykColors[ 0 ] = cmykColors[ 0 ] / 100;
  cmykColors[ 1 ] = cmykColors[ 1 ] / 100;
  cmykColors[ 2 ] = cmykColors[ 2 ] / 100;
  cmykColors[ 3 ] = cmykColors[ 3 ] / 100;
  if( cmykColors[ 4 ] )
  cmykColors[ 4 ] = cmykColors[ 4 ] / 100;

  return _.color.cmyka._longToRgba( dst, cmykColors );

}

//

function _longToRgba( dst, src )
{

  _.assert( src.length === 4 || src.length === 5, `{-src-} length must be 4 or 5, but got : ${src.length}` );

  if( !_.color._validateNormalized( src ) )
  return null;

  let r, g, b;
  let a = 1;
  /* qqq : bad!
  assert
  alpha channel

  aaa : Added
  */

  if( dst === null || _.longIs( dst ) )
  {
    dst = dst || new Array( 4 );

    _.assert( dst.length === 4, `{-dst-} container length must be 4, but got : ${dst.length}` );

    convert( src );

    /*
      TypedArray:

      For non-basic colors with r, g, b values range ( 0, 1 )
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
    r = ( 1 - src[ 0 ] ) * ( 1 - src[ 3 ] );
    g = ( 1 - src[ 1 ] ) * ( 1 - src[ 3 ] );
    b = ( 1 - src[ 2 ] ) * ( 1 - src[ 3 ] );
    if( src[ 4 ] !== undefined )
    a = src[ 4 ];
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
    || src[ 4 ] !== undefined && !_.cinterval.has( [ 0, 100 ], src[ 4 ] )
  )
  return false;

  return true;
}

//

function _formatStringParse( src )
{
  _.assert( /^cmyka\(\d{1,3}%,\d{1,3}%,\d{1,3}%,\d{1,3}%(,\d{1,3}%)?\)$/g.test( src ), 'Wrong source string pattern' );
  return src.match( /\d+(\.\d+)?/g ).map( ( el ) => +el );
}


// --
// declare
// --

let Extension =
{

  // to rgba

  _strToRgba,
  _longToRgba,
  _validate,
  _formatStringParse

}

_.props.supplement( _.color.cmyka, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

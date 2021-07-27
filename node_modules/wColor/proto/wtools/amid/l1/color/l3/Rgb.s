(function _ColorRgb_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to convert from hex into rgb.
 * @module Tools/mid/Color
*/

/**
 * @summary Collection of cross-platform routines to operate colors conveniently.
 * @namespace wTools.color.rgb
 * @module Tools/mid/Color
*/

const _ = _global_.wTools;
let Self = _.color.rgb = _.color.rgb || Object.create( null );

// --
// implement
// --

function fromHexStr( hex )
{
  let result = _.color.rgba.fromHexStr( hex );

  if( result === null )
  return null;

  _.assert( result[ 3 ] === undefined || result[ 3 ] === 1 );

  if( result[ 3 ] )
  result.pop();

  return result;
}

//

function fromRgbStr( rgb )
{
  /*
    -- 'R:10 G:20 B:30'
    -- '(R10 / G20 / B30)'
  */

  let isWithColons = /r ?: ?\d+ ?g ?: ?\d+ ?b ?: ?\d+( ?a ?: ?\d+)?/gi.test( rgb );
  let isWithSpaces = /\(r\d+ ?\/ ?g\d+ ?\/ ?b\d+( ?\/ ?a\d+)?\)/gi.test( rgb );

  if( isWithColons && isWithSpaces )
  return null;

  let colors = rgb.match( /\d+/g ).map( ( el ) => +el );

  if( !_.color.rgb._validate( colors ) )
  return null;

  if( colors[ 3 ] )
  {
    _.assert( colors[ 3 ] === 100, 'Alpha channel must be 100' );
    colors.pop();
  }

  return colors.map( ( el ) => el / 255 );

}

//

function _validate ( src )
{
  if
  (
    !_.cinterval.has( [ 0, 255 ], src[ 0 ] )
    || !_.cinterval.has( [ 0, 255 ], src[ 1 ] )
    || !_.cinterval.has( [ 0, 255 ], src[ 2 ] )
  )
  return false;

  return true;
}

// --
// declare
// --

let Extension =
{

  // to rgb/a

  fromHexStr,
  fromRgbStr,

  _validate

}

_.props.supplement( _.color.rgb, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

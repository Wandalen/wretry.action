(function _ColorRgba_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to convert from hex into rgba.
 * @module Tools/mid/Color
*/

/**
 * @summary Collection of cross-platform routines to operate colors conveniently.
 * @namespace wTools.color.rgba
 * @module Tools/mid/Color
*/

const _ = _global_.wTools;
let Self = _.color.rgba = _.color.rgba || Object.create( null );

// --
// implement
// --

function fromHexStr( hex )
{
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( hex ) );

  result = /^#?([a-f\d])([a-f\d])([a-f\d])$/i.exec( hex );
  if( result )
  {
    result =
    [
      parseInt( result[ 1 ], 16 ) / 15,
      parseInt( result[ 2 ], 16 ) / 15,
      parseInt( result[ 3 ], 16 ) / 15,
    ]
    return result;
  }

  result = /^#?([a-f\d])([a-f\d])([a-f\d])([a-f\d])$/i.exec( hex );
  if( result )
  {
    result =
    [
      parseInt( result[ 1 ], 16 ) / 15,
      parseInt( result[ 2 ], 16 ) / 15,
      parseInt( result[ 3 ], 16 ) / 15,
      parseInt( result[ 4 ], 16 ) / 15,
    ]
    return result;
  }

  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec( hex );
  if( result )
  {
    result =
    [
      parseInt( result[ 1 ], 16 ) / 255,
      parseInt( result[ 2 ], 16 ) / 255,
      parseInt( result[ 3 ], 16 ) / 255,
    ]
    return result;
  }

  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec( hex );
  if( result )
  {
    result =
    [
      parseInt( result[ 1 ], 16 ) / 255,
      parseInt( result[ 2 ], 16 ) / 255,
      parseInt( result[ 3 ], 16 ) / 255,
      parseInt( result[ 4 ], 16 ) / 255,
    ]
    return result;
  }

  return null;
}

//

function fromRgbaStr( rgb )
{
  /*
    -- 'R:10 G:20 B:30 A:40'
    -- '(R10 / G20 / B30 / A40)'
  */

  let isWithColons = /r ?: ?\d+ ?g ?: ?\d+ ?b ?: ?\d+( ?a ?: ?\d+)?/gi.test( rgb );
  let isWithSpaces = /\(r\d+ ?\/ ?g\d+ ?\/ ?b\d+( ?\/ ?a\d+)?\)/gi.test( rgb );

  if( isWithColons && isWithSpaces )
  return null;

  let colors = rgb.match( /\d+/g ).map( ( el ) => +el );

  if( !_.color.rgba._validate( colors ) )
  return null;

  colors[ 0 ] /= 255;
  colors[ 1 ] /= 255;
  colors[ 2 ] /= 255;

  if( colors[ 3 ] )
  colors[ 3 ] /= 100;
  else
  colors.push( 1 );

  return colors;

}

//

function _validate ( src )
{
  if
  (
    !_.cinterval.has( [ 0, 255 ], src[ 0 ] )
    || !_.cinterval.has( [ 0, 255 ], src[ 1 ] )
    || !_.cinterval.has( [ 0, 255 ], src[ 2 ] )
    || src[ 3 ] !== undefined && !_.cinterval.has( [ 0, 100 ], src[ 3 ] )
  )
  return false;

  return true;
}


// --
// declare
// --

let Extension =
{

  // to rgba/a

  fromHexStr,
  fromRgbaStr,
  _validate

}

_.props.supplement( _.color.rgba, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

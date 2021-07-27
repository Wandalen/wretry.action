( function _Mid_s_( )
{

'use strict';

/* color */

if( typeof module !== 'undefined' )
{
  const _ = require( './Basic.s' );
  require( '../l3/Color.s' );
  require( '../l3/Cmyk.s' );
  require( '../l3/Cmyka.s' );
  require( '../l3/Hwb.s' );
  require( '../l3/Hwba.s' );
  require( '../l3/Hsl.s' );
  require( '../l3/Hsla.s' );
  require( '../l3/Xyz.s' );
  require( '../l3/Xyza.s' );
  require( '../l3/Rgb.s' );
  require( '../l3/Rgba.s' );
  module[ 'exports' ] = _global_.wTools;
}

} )();

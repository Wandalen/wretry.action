( function _Color256_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to operate colors conveniently. Extends basic implementation Color by additional color names. Color provides functions to convert color from one color space to another color space, from name to color and from color to the closest name of a color. The module does not introduce any specific storage format of color what is a benefit. Color has a short list of the most common colors. Use the module for formatted colorful output or other sophisticated operations with colors.
  @module Tools/mid/Color256
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../include/Color256.s' );
  module[ 'exports' ] = _global_.wTools;
}

} )();

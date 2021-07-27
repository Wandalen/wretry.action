( function _Color256_s_( )
{

'use strict';

/* color */

if( typeof module !== 'undefined' )
{
  const _ = require( './Basic.s' );
  _.include( 'wColor' );
  require( '../l5/Color256.s' );
  module[ 'exports' ] = _global_.wTools;
}

} )();

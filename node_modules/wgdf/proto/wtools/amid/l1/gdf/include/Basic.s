( function _Basic_s_( )
{

'use strict';

/* gdf */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../../node_modules/Tools' );
  _.include( 'wCopyable' );
  // _.include( 'wIntrospectorBasic' );
  // _.include( 'wStringsExtra' );
  // _.include( 'wStringer' );
  module[ 'exports' ] = _global_.wTools;
}

} )();

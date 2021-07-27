( function _Basic_s_( )
{

'use strict';

/* Logger */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../../node_modules/Tools' );

  _.include( 'wCopyable' );
  _.include( 'wStringer' );
  _.include( 'wStringsExtra' );
  _.include( 'wEventHandler' );

  _.include( 'wColor256' ); /* qqq : make the depdendeny optional */

  module[ 'exports' ] = _global_.wTools;
}

})();

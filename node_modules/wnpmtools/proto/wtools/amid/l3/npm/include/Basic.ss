( function _Basic_ss_()
{

'use strict';

/* npm */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../../node_modules/Tools' );
  _.include( 'wHttp' );
  _.include( 'wProcess' );
  _.include( 'wFilesBasic' );
  module[ 'exports' ] = _global_.wTools;
}

})();

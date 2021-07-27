( function _Http_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  // _.include( 'wFilesBasic' );
  if( Config.interpreter === 'browser' )
  require( '../l7_provider/Http.js' );
  if( Config.interpreter === 'njs' )
  require( '../l7_provider/Http.ss' );

  module[ 'exports' ] = _;
}

})();

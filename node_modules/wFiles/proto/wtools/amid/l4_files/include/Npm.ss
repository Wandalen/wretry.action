( function _Npm_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  _.include( 'wFilesBasic' );
  _.include( 'wNpmTools' )

  require( '../l7_provider/Npm.ss' );

  module[ 'exports' ] = _;
}

})();

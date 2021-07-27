( function _Git_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  _.include( 'wFilesBasic' );
  _.include( 'wGitTools' );
  require( '../l7_provider/Git.ss' );

  module[ 'exports' ] = _;
}

})();

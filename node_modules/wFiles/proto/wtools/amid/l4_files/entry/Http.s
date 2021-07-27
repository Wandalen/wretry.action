( function _Http_s_()
{

'use strict';

/**
 * File provider implements strategy for module files to access files over HTTP / HTTPS protocol.
  @module Tools/mid/FilesHttp
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  require( '../include/Http.s' )
  module[ 'exports' ] = _;
}

})();

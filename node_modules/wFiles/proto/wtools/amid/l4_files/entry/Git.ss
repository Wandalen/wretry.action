( function _Git_ss_()
{

'use strict';

/**
 * Implements file provider to access files over Git.
 * @module Tools/mid/FilesGit
 */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  require( '../include/Git.ss' )
  module[ 'exports' ] = _;
}

})();

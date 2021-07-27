( function _Reroot_s_()
{

'use strict';

/**
 * Experimental. File filter to change the root of the file system virtually.
  @module Tools/mid/FilesReroot
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  require( '../include/Reroot.s' )
  module[ 'exports' ] = _;
}

})();

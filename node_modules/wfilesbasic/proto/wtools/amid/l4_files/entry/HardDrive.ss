( function _HardDrive_ss_()
{

'use strict';

/**
 * File provider implements strategy for module files to access files system of operating system.
  @module Tools/mid/FilesHardDrive
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  require( '../include/HardDrive.ss' )
  module[ 'exports' ] = _;
}

})();

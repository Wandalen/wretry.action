( function _Archive_s_()
{

'use strict';

/**
 * Experimental. Several classes to reflect changes of files on dependent files and keep links of hard linked files. FilesArchive provides means to define interdependence between files and to forward changes from dependencies to dependents. Use FilesArchive to avoid unnecessary CPU workload.
  @module Tools/mid/FilesArchive
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  require( '../include/Archive.s' )
  module[ 'exports' ] = _;
}

} )();

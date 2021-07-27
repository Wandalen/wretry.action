( function _Archive_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  _.include( 'wFiles' );
  _.include( 'wVerbal' );
  _.include( 'wStateStorage' );

  require( '../l4/ArchiveRecord.s' );
  require( '../l4/ArchiveRecordFactory.s' );

  require( '../l8_filter/Archive.s' );

  require( '../l9/Archive.s' );
  // require( '../l9/GraphOld.s' );
  require( '../l9/GraphArchive.s' );

  module[ 'exports' ] = _;
}

} )();

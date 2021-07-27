( function _Imap_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  _.include( 'wFiles' );
  _.include( 'wCensorBasic' );
  _.include( 'wResolver' );

  require( '../l7_provider/Imap.ss' );

  module[ 'exports' ] = _;
}

})();

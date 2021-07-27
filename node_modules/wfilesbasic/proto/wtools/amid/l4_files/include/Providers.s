( function _Providers_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( './Mid.s' );

  /* l7_provider */

  require( './Extract.s' );
  if( Config.interpreter === 'njs' )
  require( './HardDrive.ss' );

  module[ 'exports' ] = _;
}

})();

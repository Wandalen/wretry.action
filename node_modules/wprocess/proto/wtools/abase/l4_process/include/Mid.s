( function _Mid_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  require( '../l1/Basic.s' );
  require( '../l2/Process.s' );
  require( '../l3/Execution.s' );
  require( '../l3/Io.s' );

  module[ 'exports' ] = _global_.wTools;
}

})();

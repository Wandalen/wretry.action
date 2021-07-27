( function _Mid_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './Base.s' );

  require( '../l1/Namespace.s' );

  require( '../l3/Agent.s' );
  require( '../l3/Flock.s' );
  require( '../l3/Representative.s' );

  require( '../l5/Master.s' );
  require( '../l5/Slave.s' );

}

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();

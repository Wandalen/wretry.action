( function _Include_s_()
{

'use strict';

/**
 * Minimal programming interface to launch, stop and track collection of asynchronous procedures. It prevents an application from termination waiting for the last procedure and helps to diagnose your system with many interdependent procedures.
  @module Tools/base/Procedure
*/

/**
 *@summary Collection of cross-platform routines to launch, stop and track collection of asynchronous procedures.
  @namespace wTools.procedure
  @module Tools/base/Procedure
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wProto' );
  _.include( 'wCopyable' );

  require( './Namespace.s' );
  require( './Procedure.s' );

}

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools.procedure;

})();

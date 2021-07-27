( function _Include_s_( )
{

'use strict';

/**
 * Collection of cross-platform routines to generate functions, manage execution of such and analyze them.
  @module Tools/base/IntrospectorBasic
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wStringer' );
  _.include( 'wPathBasic' );
  _.include( 'wConsequence' );
  _.include( 'wFilesBasic' );

  require( './l3/Introspector.s' );
  require( './l3/Node.s' );
  require( './l3/Program.s' );
  require( './l3/Tools.s' );

  module[ 'exports' ] = wTools;
}

})();

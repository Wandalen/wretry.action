( function _Top_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );
  _.include( 'wFilesBasic' );

  /* l7_provider */

  require( './Http.s' );

  if( Config.interpreter === 'njs' )
  require( './Npm.ss' );
  if( Config.interpreter === 'njs' )
  require( './Git.ss' );

  require( './Operator.s' );

  /* l8_filter */

  require( '../l8_filter/Image.s' );

  require( './Reroot.s' ); /* qqq : split module */

  /* l9 */

  require( '../l9/Namespace.s' );

  _.assert( _.path.currentAtBegin !== undefined );

  module[ 'exports' ] = _;
}

})();

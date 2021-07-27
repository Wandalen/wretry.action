( function _Mid_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( './Basic.s' );

  require( '../l1/Namespace.s' );

  require( '../l2/Encoder.s' );
  require( '../l2/Encoders.s' );
  require( '../l2/Linker.s' );
  require( '../l2/RecordContext.s' );

  require( '../l3/Path.s' );
  if( Config.interpreter === 'njs' )
  require( '../l3/Path.ss' );
  require( '../l3/Record.s' );
  require( '../l3/RecordFactory.s' );
  require( '../l3/RecordFilter.s' );
  require( '../l3/StatClass.s' );
  require( '../l3/StatNamespace.s' );

  require( '../l4/Abstract.s' );

  require( '../l5/Partial.s' );
  require( '../l6/System.s' );

  require( './MixinFind.s' );
  require( './MixinConfig.s' );
  require( './MixinSecondary.s' );
  require( './MixinTemp.s' );

  module[ 'exports' ] = _;
}

})();

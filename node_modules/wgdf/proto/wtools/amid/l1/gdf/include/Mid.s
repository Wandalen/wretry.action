( function _Mid_s_()
{

'use strict';

/* gdf */

if( typeof module !== 'undefined' )
{
  const _ = require( './Basic.s' );

  require( '../l1/Namespace.s' );
  require( '../l2/Encoder.s' );
  require( '../l3/Context.s' );

  require( '../l5_strategy/Base64.s' );
  require( '../l5_strategy/Bson.s' );
  require( '../l5_strategy/Cbor.s' );
  require( '../l5_strategy/Coffee.s' );
  require( '../l5_strategy/Json.s' );
  require( '../l5_strategy/JsStructure.s' );
  require( '../l5_strategy/MsgpackLite.s' );
  require( '../l5_strategy/Yml.s' );

  module[ 'exports' ] = _global_.wTools;
}

})();

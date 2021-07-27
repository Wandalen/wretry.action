( function _Include_s_( )
{

'use strict';

/**
 * Classes defining tool on steroids. make possible multiple inheritances, removing fields in descendants, defining the schema of structure, typeless objects, generating optimal code for definition, and many cool things alternatives cant do.
  @module Tools/base/Blueprint
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );

  require( './l1/Class.s' );
  require( './l1/Property.s' );
  require( './l1/PropertyTransformers.s' );
  require( './l1/Proto.s' );

  require( './l2/Accessor.s' );
  require( './l2/Definition.s' );
  require( './l2/Types.s' );

  require( './l3/Blueprint.s' );
  require( './l3/Construction.s' );
  require( './l3/Definitions.s' );
  require( './l3/Traits.s' );

  module[ 'exports' ] = wTools;
}

})();

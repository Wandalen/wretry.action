( function _Include_s_( ) {

'use strict';

/**
 * Relations module. Collection of cross-platform routines to define classes and relations between them. Proto leverages multiple inheritances, mixins, accessors, fields groups defining, introspection and more. Use it as a skeleton of the application.
  @module Tools/base/Proto
  @extends Tools
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wBlueprint' );

  require( './l1/Define.s' );
  require( './l1/Proto.s' );
  require( './l1/Workpiece.s' );

  require( './l3/Accessor.s' );

  require( './l5/Class.s' );
  require( './l5/Collection.s' );
  require( './l5/Like.s' );

}

})();

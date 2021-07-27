( function _TreeMap_s_()
{

'use strict';

/**
 * Modest implementation of treeMap.
 * @module Tools/base/TreeMap
*/

const _ = _global_.wTools;
_.treeMap = _.treeMap || Object.create( null );

// --
// dichotomy
// --

function is( node )
{
  if( !_.aux.is( node ) )
  return false;
  if( !node.ups )
  return false;
  return true;
}

//

function make()
{
  _.assert( arguments.length === 0 );
  let node = Object.create( null );
  node.vals = new Set();
  node.ups = Object.create( null );
  return node;
}

// --
// declare
// --

let NamespaceExtension =
{

  // dichotomy

  is,
  make,

}

//

/* _.props.extend */Object.assign( _.treeMap, NamespaceExtension );

// _.class.declareBasic
// ({
//   constructor : fo.class,
//   iterate,
//   equalAre : equalAre_functor( fo ),
//   exportString,
//   cloneShallow, /* xxx : implement */
//   cloneDeep, /* xxx : implement */
// });

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();


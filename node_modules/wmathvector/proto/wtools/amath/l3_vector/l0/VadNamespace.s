(function _VadNamespace_s_() {

'use strict';

/**
 *@summary Collection of functions for vector math
  @namespace "wTools.vectorAdapter"
  @module Tools/math/Vector
*/

const _ = _global_.wTools;

_.vectorAdapter = _.vad = _.vectorAdapter || _.vad || Object.create( null );

// --
// implementation
// --

function IsResizable()
{
  _.assert( arguments.length === 0 );
  return false;
}
// --
// declare
// --

let AdapterExtension =
{
  // vectorAdapter : _.vectorAdapter,

  NamespaceName : 'vectorAdapter',
  NamespaceNames : [ 'vectorAdapter', 'vad' ],
  NamespaceQname : 'wTools/vectorAdapter',
  MoreGeneralNamespaceName : 'vectorAdapter',
  MostGeneralNamespaceName : 'countable',
  TypeName : 'VectorAdapter',
  TypeNames : [ 'VectorAdapter' ],
  InstanceConstructor : null,
  IsFixedLength : true,
  tools : _,

  IsResizable,

  _elementSet : _.countable._elementSet,
  elementSet : _.countable.elementSet,
  _lengthOf : _.countable._lengthOf,
}

Object.setPrototypeOf( _.vectorAdapter, wTools );
/* _.props.extend */Object.assign( _.vectorAdapter, AdapterExtension );

_.assert( !!_.fx );

_.vectorAdapter.long = Object.create( _.long );
_.vectorAdapter.long.namespaces = Object.create( _.long.namespaces );
_.vectorAdapter.long.toolsNamespacesByType = Object.create( _.long.toolsNamespacesByType );
_.vectorAdapter.long.toolsNamespacesByName = Object.create( _.long.toolsNamespacesByName );
_.vectorAdapter.long.toolsNamespaces = _.vectorAdapter.long.toolsNamespacesByName;
_.vectorAdapter.long.tools = _.vectorAdapter;
_.vectorAdapter.long.default = _.fx;
_.vectorAdapter.withLong = _.vectorAdapter.long.toolsNamespacesByType;

_.long._namespaceRegister( _.vectorAdapter, 'defaultVad' );

_.vectorAdapter.default = _.fx;
_.defaultVad = _.vectorAdapter;

_.assert( _.mapOnlyOwnKey( _.vectorAdapter, 'default' ) );

_.assert( _.defaultVad === _.vectorAdapter );
_.assert( _.vectorAdapter.long.tools === _.vectorAdapter );
_.assert( _.vectorAdapter.withLong.Array.tools.defaultVad === _.vectorAdapter );

_.assert( _.object.isBasic( _.withLong.Fx ) );
_.assert( _.vectorAdapter.longType === undefined );
_.vectorAdapter.longType = _.withLong.Fx;
_.assert( _.object.isBasic( _.vectorAdapter.longType ) );
_.assert( _.routineIs( _.vectorAdapter.longType.longFrom ) );
_.assert( _.numberDefined( _.accuracy ) );
_.assert( _.numberDefined( _.accuracySqr ) );
_.assert( _.numberDefined( _.accuracySqrt ) );

//

})();

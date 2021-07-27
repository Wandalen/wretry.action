(function _VectorNamespace_s_() {

'use strict';

/**
 *@summary Collection of functions for vector math
  @namespace "wTools.avector"
  @module Tools/math/Vector
*/

const _ = _global_.wTools;

_.avector = _.vector = _.avector || _.vector || Object.create( null );

// --
// implementation
// --

function IsResizable()
{
  _.assert( arguments.length === 0 );
  return this.default.IsResizable();
}

//

function namespaceOf( src )
{
  if( _.vectorAdapterIs( src ) )
  return _.vectorAdapter;
  return this.long.namespaceOf( src );
}

// --
// declare
// --

//

let AvectorExtension =
{
  NamespaceName : 'avector',
  NamespaceNames : [ 'avector', 'vector' ],
  NamespaceQname : 'wTools/avector',
  MoreGeneralNamespaceName : 'avector',
  MostGeneralNamespaceName : 'countable',
  TypeName : 'Vector',
  TypeNames : [ 'Vector' ],
  InstanceConstructor : null,
  IsFixedLength : true,
  tools : _,

  IsResizable,

  namespaceOf,

  _elementSet : _.countable._elementSet,
  elementSet : _.countable.elementSet,
  _lengthOf : _.countable._lengthOf,

}

Object.setPrototypeOf( _.avector, wTools );
/* _.props.extend */Object.assign( _.avector, AvectorExtension );

_.avector.long = Object.create( _.long );
_.avector.long.namespaces = Object.create( _.long.namespaces );
_.avector.long.toolsNamespacesByType = Object.create( _.long.toolsNamespacesByType );
_.avector.long.toolsNamespacesByName = Object.create( _.long.toolsNamespacesByName );
_.avector.long.toolsNamespaces = _.avector.long.toolsNamespacesByName;
_.avector.long.tools = _.avector;
_.avector.long.default = _.fx;
_.avector.withLong = _.avector.long.toolsNamespacesByType;

_.long._namespaceRegister( _.avector, 'defaultVector' );

_.assert( !!_.fx );

_.avector.default = _.fx;
_.defaultVector = _.avector;

_.assert( _.mapOnlyOwnKey( _.avector, 'default' ) );
_.assert( _.defaultVector === _.avector );
_.assert( _.avector.long.tools === _.avector );
_.assert( _.avector.withLong.Array.tools.defaultVector === _.avector );

_.assert( _.mapOnlyOwnKey( _.avector, 'withLong' ) );
_.assert( _.object.isBasic( _.avector.withLong ) );
_.assert( _.object.isBasic( _.avector.withLong.Array ) );
_.assert( _.object.isBasic( _.avector.withLong.F32x ) );
_.assert( Object.getPrototypeOf( _.avector ) === wTools );

//

})();

( function _l1_Primitive_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.primitive = _.primitive || Object.create( null );

// --
// primitive
// --


function is( src )
{
  if( !src )
  return true;
  let t = Object.prototype.toString.call( src );
  return _.primitive._is( src, t );
}

//

function like( src )
{
  return _.primitive.is( src );
}

//

function _primitiveIs_functor()
{
  const is = new Set();
  is.add( '[object Symbol]' );
  is.add( '[object Number]' );
  is.add( '[object BigInt]' );
  is.add( '[object Boolean]' );
  is.add( '[object String]' );
  return _primitiveIs;

  function _primitiveIs( src, typeStr )
  {
    return is.has( typeStr );
  }

}

let _is = _primitiveIs_functor();
_is.functor = _primitiveIs_functor;

// --
// meta
// --

/* qqq2 : full implementation is required */
/* qqq2 : optimize */
function namespaceOf( src )
{

  debugger;
  if( _.str.is( src ) )
  return _.str;
  if( _.number.is( src ) )
  return _.number;
  if( _.symbol.is( src ) )
  return _.symbol;

  return null;
}

// --
// extension
// --

let PrimitiveExtension =
{

  //

  NamespaceName : 'primitive',
  NamespaceNames : [ 'primitive' ],
  NamespaceQname : 'wTools/primitive',
  MoreGeneralNamespaceName : 'primitive',
  MostGeneralNamespaceName : 'primitive',
  TypeName : 'Primitive',
  TypeNames : [ 'Primitive' ],
  // SecondTypeName : 'Primitive',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  is,
  _is,
  like,

  // maker

  _makeEmpty : _.blank._makeEmpty,
  makeEmpty : _.blank.makeEmpty, /* qqq : for junior : cover */
  _makeUndefined : _.blank._makeUndefined,
  makeUndefined : _.blank.makeUndefined, /* qqq : for junior : cover */
  _make : _.blank._make,
  make : _.blank.make, /* qqq : for junior : cover */
  _cloneShallow : _.blank._cloneShallow,
  cloneShallow : _.blank.cloneShallow, /* qqq : for junior : cover */
  from : _.blank.from, /* qqq : for junior : cover */

  // meta

  namespaceOf,
  namespaceWithDefaultOf : _.props.namespaceWithDefaultOf,
  _functor_functor : _.props._functor_functor,

}

Object.assign( _.primitive, PrimitiveExtension );

//

let ToolsExtension =
{

  // dichotomy

  primitiveIs : is.bind( _.primitive ),
  primitiveLike : like.bind( _.primitive ),

}

Object.assign( _, ToolsExtension );

})();

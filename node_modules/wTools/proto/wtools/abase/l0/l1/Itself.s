( function _l1_Itself_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.itself = _.itself || Object.create( null );

_.assert( !!_.blank.make, 'Expects routine _.blank.make' );

// --
// implementation
// --

function is( src )
{
  return true;
}

//

function like( src )
{
  return true;
}

//

function IsResizable()
{
  _.assert( arguments.length === 0 );
  return false;
}

// --
// extension
// --

let ToolsExtension =
{

  // dichotomy

  itselfIs : is.bind( _.itself ),
  itselfLike : like.bind( _.itself ),

}

Object.assign( _, ToolsExtension );

//

let ItselfExtension =
{

  // fields

  NamespaceName : 'itself',
  NamespaceNames : [ 'itself' ],
  NamespaceQname : 'wTools/itself',
  MoreGeneralNamespaceName : 'itself',
  MostGeneralNamespaceName : 'itself',
  TypeName : 'Itself',
  TypeNames : [ 'Itself' ],
  // SecondTypeName : 'Itself',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  is,
  like,
  IsResizable,

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

  namespaceOf : _.blank.namespaceOf,
  namespaceWithDefaultOf : _.blank.namespaceWithDefaultOf,
  _functor_functor : _.blank._functor_functor,

}

Object.assign( _.itself, ItselfExtension );

})();

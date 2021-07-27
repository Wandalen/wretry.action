( function _l1_Countable_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.countable = _.countable || Object.create( null );

// --
// dichotomy
// --

/* qqq : for Junior : cover please */
function is( src )
{

  if( _.arrayIs( src ) )
  return true;

  if( _.primitive.is( src ) )
  return false;

  // if( _.routine.like( _.class.methodIteratorOf( src ) ) )
  // if( !_.mapIs( src ) )
  if( _.class.methodIteratorOf( src ) !== undefined ) /* qqq : for Junior : cover please */
  return true;

  return false;
}

//

function like( src )
{
  return _.countable.is( src );
}

//

function isResizable( src )
{
  if( _.array.is( src ) )
  return true;
  return false;
  // return this.is( src );
}

//

function IsResizable()
{
  _.assert( arguments.length === 0 );
  return this.default.IsResizable();
}

// --
// maker
// --

function _makeEmpty( src )
{
  if( arguments.length === 0 || src === null || _.long.is( src ) )
  return _.long._makeEmpty( ... arguments );
  return _.object.makeEmpty( ... arguments );
}

//

/* qqq2 : for junior : cover please */
function makeEmpty( src )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( arguments.length === 1 )
  {
    _.assert( this.like( src ) || _.routineIs( src ) );
    return this._makeEmpty( src );
  }
  else
  {
    return this._makeEmpty();
  }
}

//

function _makeUndefined( src, length )
{
  if( _.long.is( src ) )
  return _.long._makeUndefined( ... arguments );
  return _.object.makeUndefined( ... arguments );
}

//

/* qqq2 : for junior : cover please */
function makeUndefined( src, length )
{
  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || _.long.is( src ) || _.routineIs( src ) );
    _.assert( _.numberIs( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.numberIs( src ) || this.like( src ) || _.routineIs( src ) );
  }
  return this._makeUndefined( ... arguments );
}

//

function _makeZeroed( src, length )
{
  if( _.long.is( src ) )
  return _.long._makeZeroed( ... arguments );
  return _.object.make( ... arguments );
}

//

/* qqq2 : for junior : cover please */
/* qqq : for junior : extend with test cases with countable in 2nd arg */
function makeZeroed( src, length )
{
  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || _.long.is( src ) || _.routineIs( src ) );
    _.assert( _.numberIs( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.numberIs( src ) || this.like( src ) || _.routineIs( src ) );
  }
  return this._makeZeroed( ... arguments );
}

//

function _make( src, length )
{
  if( _.long.is( src ) )
  return _.long._make( ... arguments );
  return _.object.make( ... arguments );
}

//

/* qqq2 : for junior : full implementation and coverage are required */
/* qqq : for junior : extend with test cases with countable in 2nd arg */
function make( src, length )
{
  _.assert( arguments.length <= 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || _.countable.is( src ) || _.routineIs( src ) );
    _.assert( _.numberIs( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.numberIs( src ) || this.like( src ) || _.routineIs( src ) );
  }
  return this._make( ... arguments );
}

//

/* qqq2 : for junior : full implementation and coverage are required */
function _cloneShallow( src )
{
  if( _.long.is( src ) )
  return _.long._cloneShallow( src );
  return _.object.cloneShallow( src );
}

//

function cloneShallow( srcArray )
{
  _.assert( this.like( srcArray ) );
  _.assert( arguments.length === 1 );
  return this._cloneShallow( srcArray );
}

//

function from( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( this.is( src ) )
  return src;
  if( src === null )
  return this.make( null );
  return this.make( null, src );
}

// --
// meta
// --

/* qqq : optimize */
function namespaceOf( src )
{
  if( !this.is( src ) )
  return null;

  let result = _.long.namespaceOf( src );
  if( result )
  return result;

  return this;
}

// --
// extension
// --

var ToolsExtension =
{

  // dichotomy

  countableIs : is.bind( _.countable ),
  countableLike : like.bind( _.countable ),

}

Object.assign( _, ToolsExtension );

//

var CountableExtension =
{

  //

  NamespaceName : 'countable',
  NamespaceNames : [ 'countable' ],
  NamespaceQname : 'wTools/countable',
  MoreGeneralNamespaceName : 'countable',
  MostGeneralNamespaceName : 'countable',
  TypeName : 'Countable',
  TypeNames : [ 'Countable' ],
  // SecondTypeName : 'Countable',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  is, /* qqq : cover here and in the module::MathVector */
  like, /* qqq : cover here and in the module::MathVector */
  isResizable,
  IsResizable,

  // maker

  _makeEmpty,
  makeEmpty, /* qqq : for junior : cover */
  _makeUndefined,
  makeUndefined, /* qqq : for junior : cover */
  _makeZeroed,
  makeZeroed, /* qqq : for junior : cover */
  _make,
  make, /* qqq : for junior : cover */
  _cloneShallow,
  cloneShallow, /* qqq : for junior : cover */
  from, /* qqq : for junior : cover */

  // meta

  namespaceOf,
  namespaceWithDefaultOf : _.props.namespaceWithDefaultOf,
  _functor_functor : _.props._functor_functor,

}

Object.assign( _.countable, CountableExtension );

})();

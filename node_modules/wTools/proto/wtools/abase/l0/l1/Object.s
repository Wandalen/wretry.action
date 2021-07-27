( function _l1_Object_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.object = _.object || Object.create( null );

// --
// dichotomy
// --

/**
 * Function is checks incoming param whether it is object.
 * Returns "true" if incoming param is object. Othervise "false" returned.
 *
 * @example
 * let obj = { x : 100 };
 * _.object.isBasic(obj);
 * // returns true
 *
 * @example
 * _.object.isBasic( 10 );
 * // returns false
 *
 * @param { * } src.
 * @return { Boolean }.
 * @function is
 * @namespace Tools/object
 */

function isBasic( src )
{
  return Object.prototype.toString.call( src ) === '[object Object]';
}

//

/**
 * Function is checks incoming param whether it is object.
 * Returns "true" if incoming param is object. Othervise "false" returned.
 *
 * @example
 * let obj = { x : 100 };
 * _.object.is(obj);
 * // returns true
 *
 * @example
 * _.object.is( 10 );
 * // returns false
 *
 * @param { * } src.
 * @return { Boolean }.
 * @function is
 * @namespace Tools/object
 */

function is( src ) /* xxx : qqq : for junior : optimize */
{

  if( Object.prototype.toString.call( src ) === '[object Object]' )
  return true;

  if( _.primitive.is( src ) )
  return false;

  // if( _.vector.is( src ) )
  // return false;

  if( _.long.is( src ) )
  return false;

  if( _.set.is( src ) )
  return false;

  if( _.hashMap.is( src ) )
  return false;

  if( _.routine.isTrivial( src ) )
  return false;

  return true;
}

//

function like( src ) /* xxx : qqq : for junior : optimize */
{
  return _.object.is( src );
  // if( _.object.isBasic( src ) )
  // return true;
  //
  // if( _.primitive.is( src ) )
  // return false;
  //
  // if( _.vector.is( src ) )
  // return false;
  //
  // if( _.routine.isTrivial( src ) )
  // return false;
  //
  // if( _.set.is( src ) )
  // return false;
  //
  // if( _.hashMap.is( src ) )
  // return false;
  //
  // return true;
}

//

function likeStandard( src ) /* xxx : qqq : for junior : optimize */
{

  if( _.primitive.is( src ) )
  return false;
  if( _.vector.is( src ) )
  return false;
  if( _.routine.isTrivial( src ) )
  return false;
  if( _.set.is( src ) )
  return false;
  if( _.hashMap.is( src ) )
  return false;

  if( _.date.is( src ) )
  return true
  if( _.regexpIs( src ) )
  return true
  if( _.bufferAnyIs( src ) )
  return true

  return false;
}

//

function isEmpty( src )
{
  if( !this.like( src ) )
  return false;
  return this.keys( src ).length === 0;
}

//

function isPopulated( src )
{
  if( !this.like( src ) )
  return false;
  return this.keys( src ).length > 0;
}

//

function IsResizable()
{
  _.assert( arguments.length === 0 );
  return true;
}

// --
// maker
// --

function _makeEmpty( src )
{
  if( src )
  {
    let method = _.class.methodMakeEmptyOf( src );
    if( method )
    return method.call( src );
  }
  return new src.constructor();
}

//

function makeEmpty( src )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( arguments.length === 1 )
  _.assert( this.like( src ) );
  return this._makeEmpty( src );
}

//

function _makeUndefined( src )
{
  if( src )
  {
    let method = _.class.methodMakeUndefinedOf( src );
    if( method )
    return method.call( src );
  }
  return new src.constructor();
}

//

function makeUndefined( src, length )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  {
    _.assert( this.like( src ) );
    _.assert( _.number.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( this.like( src ) );
  }

  return this._makeUndefined( src );
}

//

function _make( src, length )
{
  if( arguments.length === 1 || ( arguments.length === 2 && length === 1 ) )
  return this._cloneShallow( src );
  if( _.aux.is( src ) )
  return _.aux._cloneShallow( src );
  if( arguments.length === 2 )
  return new src.constructor( length );
  else
  return new src.constructor( src );
}

//

function make( src, length )
{
  _.assert( this.like( src ) );
  _.assert( arguments.length >= 1 );
  _.assert( !_.aux.is( src ) || arguments.length === 1 || ( arguments.length === 2 && length === 1) );
  return this._make( ... arguments );
}

//

function _cloneShallow( src )
{
  let method = _.class.methodCloneShallowOf( src );
  if( method )
  return method.call( src );
  if( _.aux.is( src ) )
  return _.aux._cloneShallow( src );
  return new src.constructor( src );
}

// --
// meta
// --

/* qqq : optimize */
function namespaceOf( src )
{

  if( _.object.is( src ) )
  return _.object;

  return null;
}

// --
// extension
// --

let ToolsExtension =
{

  // dichotomy

  objectIs : is.bind( _.object ),
  objectIsBasic : isBasic.bind( _.object ),
  objectIsEmpty : isEmpty.bind( _.object ),
  objectIsPopulated : isPopulated.bind( _.object ),
  objectLike : like.bind( _.object ),
  objectLikeStandard : likeStandard.bind( _.object ),

  // maker

  objectMakeEmpty : makeEmpty.bind( _.object ),
  objectMakeUndefined : makeUndefined.bind( _.object ),
  objectMake : make.bind( _.object ),
  objectCloneShallow : _.props.cloneShallow.bind( _.object ),
  objectFrom : _.props.from.bind( _.object ),

}

Object.assign( _, ToolsExtension );

//

let ObjectExtension =
{

  //

  NamespaceName : 'object',
  NamespaceNames : [ 'object' ],
  NamespaceQname : 'wTools/object',
  MoreGeneralNamespaceName : 'props',
  MostGeneralNamespaceName : 'props',
  TypeName : 'Object',
  TypeNames : [ 'Object' ],
  // SecondTypeName : 'Object',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  is,
  isBasic,
  like,
  likeStandard,

  isEmpty, /* qqq : cover */
  isPopulated, /* qqq : cover */
  IsResizable,

  // maker

  _makeEmpty,
  makeEmpty, /* qqq : for junior : cover */
  _makeUndefined,
  makeUndefined, /* qqq : for junior : cover */
  _make,
  make, /* qqq : for junior : cover */
  _cloneShallow,
  cloneShallow : _.props.cloneShallow, /* qqq : for junior : cover */
  from : _.props.from, /* qqq : for junior : cover */

  // properties

  _keys : _.props._keys,
  keys : _.props.keys, /* qqq : for junior : cover */
  onlyOwnKeys : _.props.onlyOwnKeys, /* qqq : for junior : cover */
  onlyEnumerableKeys : _.props.onlyEnumerableKeys, /* qqq : for junior : implement and cover properly */
  allKeys : _.props.allKeys, /* qqq : for junior : cover */

  _vals : _.props._vals,
  vals : _.props.vals, /* qqq : for junior : cover */
  onlyOwnVals : _.props.onlyOwnVals, /* qqq : for junior : cover */
  onlyEnumerableVals : _.props.onlyEnumerableVals, /* qqq : for junior : implement and cover properly */
  allVals : _.props.allVals, /* qqq : for junior : cover */

  _pairs : _.props._pairs,
  pairs : _.props.pairs, /* qqq : for junior : cover */
  onlyOwnPairs : _.props.onlyOwnPairs, /* qqq : for junior : cover */
  onlyEnumerablePairs : _.props.onlyEnumerablePairs, /* qqq : for junior : implement and cover properly */
  allPairs : _.props.allPairs, /* qqq : for junior : cover */

  // amender

  _extendWithHashmap : _.props._extendWithHashmap,
  _extendWithSet : _.props._extendWithSet,
  _extendWithCountable : _.props._extendWithCountable,
  _extendWithProps : _.props._extendWithProps,
  _extendUniversal : _.props._extendUniversal,
  extendUniversal : _.props.extendUniversal,
  extend : _.props.extend,

  _supplementWithHashmap : _.props._supplementWithHashmap,
  _supplementWithSet : _.props._supplementWithSet,
  _supplementWithCountable : _.props._supplementWithCountable,
  _supplementWithProps : _.props._supplementWithProps,
  _supplementUniversal : _.props._supplementUniversal,
  supplementUniversal : _.props.supplementUniversal,
  supplement : _.props.supplement,

  // meta

  namespaceOf,
  namespaceWithDefaultOf : _.props.namespaceWithDefaultOf,
  _functor_functor : _.props._functor_functor,

}

//

Object.assign( _.object, ObjectExtension );

})();

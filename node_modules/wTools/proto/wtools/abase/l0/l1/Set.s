( function _l1_Set_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.set = _.set || Object.create( null );
_.sets = _.set.s = _.sets || _.set.s || Object.create( null );

// --
// implementation
// --

function is( src )
{
  if( !src )
  return false;
  return src instanceof Set || src instanceof WeakSet;
}

//

function like( src )
{
  return _.set.is( src );
}

//

function isEmpty()
{
  return !src.size;
}

//

function isPopulated()
{
  return !!src.size;
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
  return new Set();
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

function _makeUndefined( src, length )
{
  return new Set();
}

//

function makeUndefined( src, length )
{
  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  {
    _.assert( this.like( src ) );
    _.assert( _.number.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( _.number.is( src ) || this.like( src ) );
  }

  return new Set();
}

//

function _make( src, length )
{
  if( length === 0 )
  return new Set();
  else if( _.number.is( src ) )
  return new Set();
  else
  return new Set([ ... src ]);
}

//

function make( src, length )
{
  _.assert( arguments.length === 0 || src === null || _.countable.is( src ) || src === 0 );
  _.assert( arguments.length < 2 || length === 0 );
  _.assert( arguments.length <= 2 );
  return this._make( ... arguments );
}

//

function _cloneShallow( src )
{
  return new Set([ ... src ]);
}

//

function cloneShallow( src )
{
  _.assert( _.countable.is( src ) );
  _.assert( arguments.length === 1 );
  return this._cloneShallow( src );
}

//

function from( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( this.is( src ) )
  return src;

  if( _.containerAdapter.is( src ) )
  src = src.toArray().original;

  return this.make( src );
}

// //
//
// function from( src )
// {
//   _.assert( arguments.length === 1 );
//   if( _.set.adapterLike( src ) )
//   return src;
//   if( src === null )
//   return new Set();
//   if( _.containerAdapter.is( src ) )
//   src = src.toArray().original;
//   _.assert( _.longIs( src ) );
//   return new Set([ ... src ]);
// }

//

/* qqq : for junior : cover please */
function as( src )
{
  _.assert( src !== undefined );
  if( src === null )
  return new Set;
  else if( _.set.is( src ) )
  return src;
  else if( _.countable.like( src ) )
  return new Set([ ... src ]);
  else
  return new Set([ src ]);
}

// //
//
// function asTest( src )
// {
//   if( src === null || src === undefined )
//   return new Set;
//   if( src[ Symbol.iterator ] && !_.str.is( src ) )
//   return new Set( [ ... src ] );
//   if( src instanceof WeakSet )
//   return src;
//
//   return new Set( [ src ] );
// }

// //
//
// function setsFrom( srcs )
// {
//   _.assert( arguments.length === 1 );
//   _.assert( _.longIs( srcs ) );
//   let result = [];
//   for( let s = 0, l = srcs.length ; s < l ; s++ )
//   result[ s ] = _.set.from( srcs[ s ] );
//   return result;
// }

// --
// properties
// --

function _keys( src )
{
  return [ ... src.keys() ];
}

//

function keys( src )
{
  _.assert( this.like( src ) );
  return this._keys( src );
}

//

function _vals( src )
{
  return [ ... src.values() ];
}

//

function vals( src )
{
  _.assert( this.like( src ) );
  return this._vals( src );
}

//

function _pairs( src )
{
  return [ ... src.entries() ];
}

//

function pairs( src )
{
  _.assert( this.like( src ) );
  return this._pairs( src );
}

// --
// set extension
// --

let SetExtension =
{

  //

  NamespaceName : 'set',
  NamespaceNames : [ 'set' ],
  NamespaceQname : 'wTools/set',
  MoreGeneralNamespaceName : 'set',
  MostGeneralNamespaceName : 'countable',
  TypeName : 'Set',
  TypeNames : [ 'Set' ],
  InstanceConstructor : Set,
  tools : _,

  // dichotomy

  is,
  like,
  // adapterLike,
  isEmpty,
  isPopulated,
  IsResizable,

  // maker

  _makeEmpty,
  makeEmpty, /* qqq : for junior : cover */
  _makeUndefined,
  makeUndefined, /* qqq : for junior : cover */
  _make,
  make, /* qqq : for junior : cover */
  _cloneShallow,
  cloneShallow, /* qqq : for junior : cover */
  from,
  as,
  // asTest,

  // properties

  _keys,
  keys, /* qqq : for junior : cover */
  _vals,
  vals, /* qqq : for junior : cover */
  _pairs,
  pairs, /* qqq : for junior : cover */

  // meta

  namespaceOf : _.blank.namespaceOf,
  namespaceWithDefaultOf : _.blank.namespaceWithDefaultOf,
  _functor_functor : _.blank._functor_functor,

}

Object.assign( _.set, SetExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  // dichotomy

  setIs : is.bind( _.set ),
  setIsEmpty : isEmpty.bind( _.set ),
  setIsPopulated : isPopulated.bind( _.set ),
  setLike : like.bind( _.set ),

  // maker

  setMakeEmpty : makeEmpty.bind( _.set ),
  setMakeUndefined : makeUndefined.bind( _.set ),
  setMake : make.bind( _.set ),
  setCloneShallow : cloneShallow.bind( _.set ),
  setFrom : from.bind( _.set ),
  setAs : as.bind( _.set ),

}

Object.assign( _, ToolsExtension );

//

})();

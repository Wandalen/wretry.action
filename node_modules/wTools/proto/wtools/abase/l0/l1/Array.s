( function _l1_Array_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.array = _.array || Object.create( null );
_.countable = _.countable || Object.create( null );
_.vector = _.vector || Object.create( null );

_.assert( !!_.argumentsArray.make, 'Expects routine _.argumentsArray.make' );

// --
// array
// --

/**
 * The is() routine determines whether the passed value is an Array.
 *
 * If the {-srcMap-} is an Array, true is returned,
 * otherwise false is.
 *
 * @param { * } src - The object to be checked.
 *
 * @example
 * _.array.is( [ 1, 2 ] );
 * // returns true
 *
 * @example
 * _.array.is( 10 );
 * // returns false
 *
 * @returns { boolean } Returns true if {-srcMap-} is an Array.
 * @function is
 * @namespace Tools
 */

function is( src )
{
  return Array.isArray( src );
  // return Object.prototype.toString.call( src ) === '[object Array]';
}

//

function isEmpty( src )
{
  if( !_.array.is( src ) )
  return false;
  return src.length === 0;
}

//

function isPopulated( src )
{
  if( !_.array.is( src ) )
  return false;
  return src.length > 0;
}

//

function likeResizable( src )
{
  return _.array.is( src );
}

//

function like( src ) /* qqq : cover */
{
  return this.is( src );
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

function _make( src, length )
{
  if( arguments.length === 2 )
  {
    let data = length;
    if( _.number.is( length ) )
    {
      data = src;
    }
    else if( length.length )
    {
      length = length.length;
    }
    if( _.countable.is( length ) )
    {
      data = [ ... length ];
      length = data.length;
    }

    return fill( new Array( length ), data );
  }
  else if( arguments.length === 1 )
  {
    if( _.number.is( src ) )
    return new Array( src );
    if( _.countable.is( src ) )
    return [ ... src ];
  }
  return [];

  /* */

  function fill( dst, data )
  {
    if( data === null || data === undefined )
    return dst;
    let l = Math.min( length, data.length );
    for( let i = 0 ; i < l ; i++ )
    dst[ i ] = data[ i ];
    return dst;
  }

}

//

function _cloneShallow( srcArray )
{
  return srcArray.slice();
}

//

/**
 * The as() routine copies passed argument to the array.
 *
 * @param { * } src - The source value.
 *
 * @example
 * _.array.as( false );
 * // returns [ false ]
 *
 * @example
 * _.array.as( { a : 1, b : 2 } );
 * // returns [ { a : 1, b : 2 } ]
 *
 * @returns { Array } - If passed null or undefined than return the empty array. If passed an array then return it.
 * Otherwise return an array which contains the element from argument.
 * @function as
 * @namespace Tools/array
 */

function as( src )
{
  _.assert( arguments.length === 1 );
  _.assert( src !== undefined );

  //src === undefined check below conflicts with above assert
  // if( src === null || src === undefined )
  if( src === null )
  return [];
  else if( _.array.is( src ) )
  return src;
  else if( _.countable.like( src ) )
  return [ ... src ];
  else
  return [ src ];

}

// //
//
// function asTest( src )
// {
//   _.assert( arguments.length === 1 );
//   _.assert( src !== undefined );
//
//   if( src === null )
//   return [];
//   if( src[ Symbol.iterator ] && !_.str.is( src ) )
//   return [ ... src ];
//
//   return [ src ];
// }

//

function asShallow( src )
{
  _.assert( arguments.length === 1 );
  _.assert( src !== undefined );

  if( src === null )
  return [];
  else if( _.longLike( src ) )
  return _.array.slice( src );
  else
  return [ src ];

}

// --
// array extension
// --

let ArrayExtension =
{

  // fields

  NamespaceName : 'array',
  NamespaceNames : [ 'array' ],
  NamespaceQname : 'wTools/array',
  MoreGeneralNamespaceName : 'long',
  MostGeneralNamespaceName : 'countable',
  TypeName : 'Array',
  TypeNames : [ 'Array' ],
  // SecondTypeName : 'Array',
  InstanceConstructor : Array,
  tools : _,

  // dichotomy

  is,
  isEmpty,
  isPopulated,
  likeResizable,
  like,
  IsResizable,

  // maker

  _makeEmpty : _.argumentsArray._makeEmpty,
  makeEmpty : _.argumentsArray.makeEmpty, /* qqq : for junior : cover */
  _makeUndefined : _.argumentsArray._makeUndefined,
  makeUndefined : _.argumentsArray.makeUndefined, /* qqq : for junior : cover */
  _makeZeroed : _.argumentsArray._makeZeroed,
  makeZeroed : _.argumentsArray.makeZeroed, /* qqq : for junior : cover */
  _makeFilling : _.argumentsArray._makeFilling,
  makeFilling : _.argumentsArray.makeFilling,
  _make,
  make : _.argumentsArray.make, /* qqq : for junior : cover */
  _cloneShallow,
  cloneShallow : _.argumentsArray.cloneShallow, /* qqq : for junior : cover */
  from : _.argumentsArray.from, /* qqq : for junior : cover */
  as,
  // asTest,
  asShallow,

  // meta

  namespaceOf : _.blank.namespaceOf,
  namespaceWithDefaultOf : _.blank.namespaceWithDefaultOf,
  _functor_functor : _.blank._functor_functor,

}

//

Object.assign( _.array, ArrayExtension );

_.long._namespaceRegister( _.array );
_.assert( _.long.default === undefined );
_.long.default = _.array;

_.assert( _.countable.default === undefined );
_.countable.default = _.array;

_.assert( _.vector.default === undefined );
_.vector.default = _.array;

// --
// tools extension
// --

/* qqq : for junior : duplicate routines on all levels */
let ToolsExtension =
{

  // dichotomy

  arrayIs : is.bind( _.array ),
  arrayIsEmpty : isEmpty.bind( _.array ),
  arrayIsPopulated : isPopulated.bind( _.array ),
  arrayLikeResizable : likeResizable.bind( _.array ),
  arrayLike : like.bind( _.array ),

  // maker

  arrayMakeEmpty : _.argumentsArray.makeEmpty.bind( _.array ),
  // arrayMakeEmpty : makeEmpty.bind( _.array ),
  arrayMakeUndefined : _.argumentsArray.makeUndefined.bind( _.array ),
  arrayMake : _.argumentsArray.make.bind( _.array ),
  arrayCloneShallow : _.argumentsArray.cloneShallow.bind( _.array ),
  arrayFrom : _.argumentsArray.from.bind( _.array ),

}

//

Object.assign( _, ToolsExtension );

})();

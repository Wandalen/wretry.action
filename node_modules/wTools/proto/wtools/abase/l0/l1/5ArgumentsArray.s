( function _l1_5ArgumentsArray_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.argumentsArray = _.argumentsArray || Object.create( null );

// --
// dichotomy
// --

function is( src )
{
  return Object.prototype.toString.call( src ) === '[object Arguments]';
}

//

function isOld( src )
{
  return Object.prototype.toString.call( src ) === '[object Arguments]';
}

//

function isIterator( src )
{
  if( !src || !src[ Symbol.iterator ] )
  return false;
  return Object.prototype.toString.call( src ) === '[object Arguments]';
}

//

/* qqq : for Rahul : bad : useless variant */
// function isUsingFunctor_functor( src )
// {
//   let argumentObject = '[object Arguments]';
//   return isUsingFunctor;
//
//   function isUsingFunctor( src )
//   {
//     return Object.prototype.toString.call( src ) === argumentObject;
//   }
// }
//
// let isUsingFunctor = isUsingFunctor_functor();

//

function like( src )
{
  if( Array.isArray( src ) )
  return true;
  if( Object.prototype.toString.call( src ) === '[object Arguments]' )
  return true;
  return false;
}

//

function likeOld( src )
{
  if( _.array.is( src ) )
  return true;
  if( _.argumentsArray.is( src ) )
  return true;
  return false;
}

//

function likeUnfolded( src )
{
  if( Array.isArray( src ) )
  return true;
  if( Object.prototype.toString.call( src ) === '[object Arguments]' )
  return true;
  return false;
}

//

/* qqq : for Rahul : bad : misleading name, this is not functor! */
// function likeUsingIsFunctor( src )
// {
//   if( _.argumentsArray.isUsingFunctor( src ) )
//   return true;
//   if( _.array.is( src ) )
//   return true;
//   return false;
// }

//

function IsResizable()
{
  _.assert( arguments.length === 0 );
  return false;
}

// --
// maker
// --

function _makeAct()
{
  return arguments;
}

//

function _make( src, length )
{
  if( arguments.length === 2 )
  {
    let data = length;
    if( _.number.is( length ) )
    data = src;
    if( _.countable.is( length ) )
    length = length.length;

    const dst = _.argumentsArray._makeAct.apply( _, _.number.is( length ) ? Array( length ) : [ ... length ] );
    return fill( dst, data );
  }
  else if( arguments.length === 1 )
  {
    if( _.numberIs( src ) )
    return _.argumentsArray._makeAct.apply( _, Array( src ) );
    if( _.countable.is( src ) )
    return _.argumentsArray._makeAct.apply( _, [ ... src ] );
  }
  return _.argumentsArray._makeAct.apply( _, [] );

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

function make( src, length )
{
  // if( !( arguments.length === 0 || src === null || _.countable.is( src ) || _.numberIs( src ) ) )
  // debugger;
  _.assert( arguments.length === 0 || src === null || _.countable.is( src ) || _.numberIs( src ) );
  _.assert( length === undefined || !_.number.is( src ) || !_.number.is( length ) );
  _.assert( arguments.length < 2 || _.number.is( length ) || _.countable.is( length ) );
  _.assert( arguments.length <= 2 );
  return this._make( ... arguments );
}

//

function _makeEmpty()
{
  return this._make( 0 );
}

//

function makeEmpty( src )
{
  _.assert( arguments.length === 0 || src === null || this.like( src ) || _.countable.is( src ) );
  _.assert( arguments.length <= 1 );
  return this._makeEmpty( src );
}

//

function _makeUndefined( src, length )
{
  if( arguments.length === 0 )
  return this._make( 0 );

  if( length === undefined )
  length = src;
  if( length && !_.number.is( length ) )
  {
    if( length.length )
    length = length.length;
    else
    length = [ ... length ].length;
  }
  return this._make( length );
}

//

function makeUndefined( src, length )
{
  _.assert( 0 <= arguments.length && arguments.length <= 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || _.long.is( src ) || _.routineIs( src ) );
    _.assert( _.numberIs( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.numberIs( src ) || _.countable.is( src ) || _.routineIs( src ) );
  }
  return this._makeUndefined( ... arguments );
}

//

function _makeZeroed( src, length )
{
  return this._makeFilling.call( this, 0, ... arguments );
}

//

function makeZeroed( src, length )
{
  _.assert( 0 <= arguments.length && arguments.length <= 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || _.long.is( src ) || _.routine.is( src ) );
    _.assert( _.number.is( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.numberIs( src ) || _.long.is( src ) || _.countable.is( src ) ||  _.routine.is( src ) );
  }
  return this._makeZeroed( ... arguments );
}

//

function _makeFilling( type, value, length )
{
  if( arguments.length === 2 )
  {
    value = arguments[ 0 ];
    length = arguments[ 1 ];
  }

  if( !_.number.is( length ) )
  // if( _.long.is( length ) )
  if(  length.length )
  length = length.length;
  else if( _.countable.is( length ) )
  length = [ ... length ].length;

  let result = this._make( length );
  for( let i = 0 ; i < length ; i++ )
  result[ i ] = value;

  return result;
}

//

function makeFilling( type, value, length )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( arguments.length === 2 )
  {
    _.assert( _.number.is( value ) || _.countable.is( value ) );
    _.assert( type !== undefined );
  }
  else
  {
    _.assert( value !== undefined );
    _.assert( _.number.is( length ) || _.countable.is( length ) );
    _.assert( type === null || _.routine.is( type ) || _.long.is( type ) );
  }

  return this._makeFilling( ... arguments );
}

//

function _cloneShallow( src )
{
  return this._makeAct( ... src );
}

//

function cloneShallow( src )
{
  _.assert( this.is( src ) );
  _.assert( arguments.length === 1 );
  return this._cloneShallow( src );
}

//

function from( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( this.is( src ) )
  return src;
  return this.make( src );
}

// --
// extension
// --

var ToolsExtension =
{

  // dichotomy

  argumentsArrayIs : is.bind( _.argumentsArray ),
  argumentsArrayLike : like.bind( _.argumentsArray ),

  // maker

  argumentsArrayMakeEmpty : makeEmpty.bind( _.argumentsArray ),
  argumentsArrayMakeUndefined : makeUndefined.bind( _.argumentsArray ),
  argumentsArrayMake : make.bind( _.argumentsArray ),
  argumentsArrayCloneShallow : cloneShallow.bind( _.argumentsArray ),
  argumentsArrayFrom : from.bind( _.argumentsArray ),

}

//

Object.assign( _, ToolsExtension );

//

var ArgumentsArrayExtension =
{

  //

  NamespaceName : 'argumentsArray',
  NamespaceNames : [ 'argumentsArray' ],
  NamespaceQname : 'wTools/argumentsArray',
  MoreGeneralNamespaceName : 'long',
  MostGeneralNamespaceName : 'countable',
  TypeName : 'ArgumentsArray',
  TypeNames : [ 'ArgumentsArray', 'Arguments' ],
  // SecondTypeName : 'Arguments',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  is, /* qqq : cover */
  isOld,
  isIterator,
  // isUsingFunctor,
  like, /* qqq : cover */
  likeOld,
  likeUnfolded,
  // likeUsingIsFunctor,
  IsResizable,

  // maker

  _makeAct,
  _make,
  make, /* qqq : for junior : cover */
  _makeEmpty,
  makeEmpty, /* qqq : for junior : cover */
  _makeUndefined,
  makeUndefined, /* qqq : for junior : cover */
  _makeZeroed,
  makeZeroed, /* qqq : for junior : cover */
  _makeFilling,
  makeFilling,
  _cloneShallow,
  cloneShallow, /* qqq : for junior : cover */
  from, /* qqq : for junior : cover */

  // meta

  namespaceOf : _.blank.namespaceOf,
  namespaceWithDefaultOf : _.blank.namespaceWithDefaultOf,
  _functor_functor : _.blank._functor_functor,

}

Object.assign( _.argumentsArray, ArgumentsArrayExtension );
_.long._namespaceRegister( _.argumentsArray );

})();

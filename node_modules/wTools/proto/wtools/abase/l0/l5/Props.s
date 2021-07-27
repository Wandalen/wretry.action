( function _l5_Property_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.props = _.props || Object.create( null );

// --
// implementation
// --

// function identical( src1, src2 )
// {
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( !_.primitive.is( src1 ) );
//   _.assert( !_.primitive.is( src2 ) );
//
//   if( Object.keys( src1 ).length !== Object.keys( src2 ).length )
//   return false;
//
//   for( let s in src1 )
//   {
//     if( src1[ s ] !== src2[ s ] )
//     return false;
//   }
//
//   return true;
// }

//

function hasAll( src, screen )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( src ) );
  _.assert( !_.primitive.is( screen ) );

  if( _.argumentsArray.like( screen ) )
  {
    for( let s = 0 ; s < screen.length ; s++ )
    if( !( screen[ s ] in src ) )
    return false;
  }
  else if( _.vector.is( screen ) )
  {
    for( let value of screen )
    if( !( value in src ) )
    return false;
  }
  else if( _.aux.is( screen ) )
  {
    for( let k in screen )
    if( !( k in src ) )
    return false;
  }

  return true;

}

//

function hasAny( src, screen )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( src ) );
  _.assert( !_.primitive.is( screen ) );

  if( _.argumentsArray.like( screen ) )
  {
    for( let s = 0 ; s < screen.length ; s++ )
    if( screen[ s ] in src )
    return true;
  }
  else if( _.vector.is( screen ) )
  {
    for( let value of screen )
    if( value in src )
    return true;
  }
  else if( _.aux.is( screen ) )
  {
    for( let k in screen )
    if( k in src )
    return true;
  }

  return false;
}

//

function hasNone( src, screen )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( src ) );
  _.assert( !_.primitive.is( screen ) );

  if( _.argumentsArray.like( screen ) )
  {
    for( let s = 0 ; s < screen.length ; s++ )
    if( screen[ s ] in src )
    return false;
  }
  else if( _.vector.is( screen ) )
  {
    for( let value of screen )
    if( value in src )
    return false;
  }
  else if( _.aux.is( screen ) )
  {
    for( let k in screen )
    if( k in src )
    return false;
  }

  return true;
}

// // --
// // property implicit
// // --
//
// const prototypeSymbol = Symbol.for( 'prototype' );
// const constructorSymbol = Symbol.for( 'constructor' );
//
// _.assert( _.props.implicit === undefined );
// _.assert( _.props.Implicit === undefined );
// _.props.implicit = _.wrap.declare({ name : 'Implicit' }).namespace;
// _.props.Implicit = _.props.implicit.class;
// _.assert( _.mapIs( _.props.implicit ) );
// _.assert( _.routineIs( _.props.Implicit ) );
//
// _.props.implicit.prototype = new _.props.Implicit( prototypeSymbol );
// _.props.implicit.constructor = new _.props.Implicit( constructorSymbol );

// --
// extension
// --

let Extension =
{

  // identical,
  hasAll,
  hasAny,
  hasNone,

}

//

Object.assign( _.props, Extension );
// _.assert( _.routine.is( _.props.filterWithEscape ) ); debugger;

})();

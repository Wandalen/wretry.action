( function _l1_Prototype_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.prototype = _.prototype || Object.create( null );

// --
// implementation
// --

/**
 * @namespace Tools.prototype
 * @module Tools/base/Proto
 */

function _of( object )
{
  return Object.getPrototypeOf( object );
}

//

/**
 * Iterate through prototypes.
 * @param {object} proto - prototype
 * @function each
 * @namespace Tools.prototype
 */

function each( proto, onEach )
{
  let result = [];

  _.assert( _.routine.is( onEach ) || !onEach );
  _.assert( !_.primitive.is( proto ) || proto === null );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  while( proto )
  {
    if( onEach )
    onEach.call( this, proto );
    result.push( proto );
    proto = Object.getPrototypeOf( proto );
  }

  return result;
}

//

function isPrototypeFor( superPrototype, subPrototype ) /* xxx : move */
{
  _.assert( arguments.length === 2, 'Expects two arguments, probably you meant routine prototypeOf' );
  if( !superPrototype )
  return false;
  if( !subPrototype )
  return false;
  if( superPrototype === subPrototype )
  return true;
  return Object.isPrototypeOf.call( superPrototype, subPrototype );
}

//

/**
 * Return proto owning names.
 * @param {object} srcPrototype - src object to investigate proto stack.
 * @function havingProperty
 * @namespace Tools.prototype
 */

function havingProperty( srcPrototype, name ) /* yyy qqq : names could be only string */
{

  _.assert( !_.primitive.is( srcPrototype ) );
  _.assert( _.strIs( name ) );

  do
  {
    let has = true;
    if( !Object.hasOwnProperty.call( srcPrototype, name ) )
    has = false;
    if( has )
    return srcPrototype;

    srcPrototype = Object.getPrototypeOf( srcPrototype );
  }
  while( srcPrototype !== Object.prototype && srcPrototype );

  return null;
}

// //
//
// /**
//  * Does srcProto has insProto as prototype.
//  * @param {object} srcProto - proto stack to investigate.
//  * @param {object} insProto - proto to look for.
//  * @function hasPrototype
//  * @namespace Tools.prototype
//  */
//
// function hasPrototype( srcProto, insProto )
// {
//
//   while( srcProto !== null )
//   {
//     if( srcProto === insProto )
//     return true;
//     srcProto = Object.getPrototypeOf( srcProto );
//   }
//
//   return false;
// }

//

function has( superPrototype, subPrototype ) /* xxx : move */
{
  _.assert( arguments.length === 2, 'Expects two arguments' );
  // eslint-disable-next-line no-prototype-builtins
  return _.prototype.isPrototypeFor( subPrototype, superPrototype );
}

//

/**
 * Is prototype.
 * @function is
 * @param {object} src - entity to check
 * @namespace Tools
 */

function is( src ) /* xxx : move */
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( _.primitive.is( src ) )
  return false;
  if( _.routine.is( src ) )
  return false;
  return Object.hasOwnProperty.call( src, 'constructor' );
}

//

function set( dst, src )
{
  Object.setPrototypeOf( dst, src );
  return dst;
}

// --
// extension
// --

var Extension =
{

  of : _of,
  each,
  isPrototypeFor,
  havingProperty,

  // hasPrototype,
  hasPrototype : has, /* xxx : remove */
  has,
  is,

  set,

}

//

var ToolsExtension =
{

  // prototypeIsPrototypeOf : isPrototypeOf,  /* xxx : remove */
  // prototypeHas : has, /* xxx : remove */
  prototypeIs : is

}

//

Object.assign( Self, Extension );
Object.assign( _, ToolsExtension );

})();

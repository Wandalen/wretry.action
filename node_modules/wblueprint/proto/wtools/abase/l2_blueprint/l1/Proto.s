( function _Proto_s_()
{

'use strict';

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

// /**
//  * @namespace Tools.prototype
//  * @module Tools/base/Proto
//  */
//
// function _of( object )
// {
//   return Object.getPrototypeOf( object );
// }
//
// //
//
// /**
//  * Iterate through prototypes.
//  * @param {object} proto - prototype
//  * @function each
//  * @namespace Tools.prototype
//  */
//
// function each( proto, onEach )
// {
//   let result = [];
//
//   _.assert( _.routineIs( onEach ) || !onEach );
//   _.assert( !_.primitiveIs( proto ) || proto === null );
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//
//   while( proto )
//   {
//     if( onEach )
//     onEach.call( this, proto );
//     result.push( proto );
//     proto = Object.getPrototypeOf( proto );
//   }
//
//   return result;
// }

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
// //
//
// /**
//  * Return proto owning names.
//  * @param {object} srcPrototype - src object to investigate proto stack.
//  * @function havingProperty
//  * @namespace Tools.prototype
//  */
//
// function havingProperty( srcPrototype, name ) /* yyy qqq : names could be only string */
// {
//
//   _.assert( !_.primitiveIs( srcPrototype ) );
//   _.assert( _.strIs( name ) );
//
//   do
//   {
//     let has = true;
//     if( !Object.hasOwnProperty.call( srcPrototype, name ) )
//     has = false;
//     if( has )
//     return srcPrototype;
//
//     srcPrototype = Object.getPrototypeOf( srcPrototype );
//   }
//   while( srcPrototype !== Object.prototype && srcPrototype );
//
//   return null;
// }

// {
//   names = _nameFielded( names );
//   _.assert( _.object.isBasic( srcPrototype ) );
//
//   do
//   {
//     let has = true;
//     for( let n in names )
//     if( !Object.hasOwnProperty.call( srcPrototype, n ) )
//     {
//       has = false;
//       break;
//     }
//     if( has )
//     return srcPrototype;
//
//     srcPrototype = Object.getPrototypeOf( srcPrototype );
//   }
//   while( srcPrototype !== Object.prototype && srcPrototype );
//
//   return null;
// }

//

function isSubPrototypeOf( sub, parent )
{

  _.assert( !!parent );
  _.assert( !!sub );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( parent === sub )
  return true;

  return Object.isPrototypeOf.call( parent, sub );
}

//

function _ofStandardEntity( src )
{
  if( src === Object.prototype )
  return true;
  return false;
}

// //
//
// function propertyDescriptorActiveGet( object, name )
// {
//   let result = Object.create( null );
//   // yyy
//   // result.object = null;
//   // result.descriptor = null;
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( !!object, 'No object' );
//
//   do
//   {
//     let descriptor = Object.getOwnPropertyDescriptor( object, name );
//     if( descriptor && !( 'value' in descriptor ) )
//     {
//       result.descriptor = descriptor;
//       result.object = object;
//       return result;
//     }
//     object = Object.getPrototypeOf( object );
//   }
//   while( object );
//
//   return result;
// }
//
// //
//
// function propertyDescriptorGet( object, name )
// {
//   let result = Object.create( null );
//   // yyy
//   // result.object = null;
//   // result.descriptor = null;
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   do
//   {
//     let descriptor = Object.getOwnPropertyDescriptor( object, name );
//     if( descriptor )
//     {
//       result.descriptor = descriptor;
//       result.object = object;
//       return result;
//     }
//     object = Object.getPrototypeOf( object );
//   }
//   while( object );
//
//   return result;
// }

// --
// define
// --

let PrototypeExtension =
{

  // of : _of,
  // each,

  // havingProperty,
  // hasPrototype,

  isSubPrototypeOf, /* xxx : remove? */
  _ofStandardEntity,

  // propertyDescriptorActiveGet, /* qqq : cover please */
  // propertyDescriptorGet, /* qqq : cover please */

}

_.prototype = _.prototype || Object.create( null );
/* _.props.extend */Object.assign( _.prototype, PrototypeExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

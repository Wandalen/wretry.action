( function _l3_Container_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const _functor_functor = _.container._functor_functor;

// --
// exporter
// --

function _exportStringDiagnosticShallow( src, o )
{
  let result;
  let namespace = this.namespaceForExporting( src );

  if( namespace )
  result = namespace.exportStringDiagnosticShallow( src );
  else
  result = _.strShort_( String( src ) ).result;

  return result;
}

//

function exportStringDiagnosticShallow( src, o )
{
  let result;
  _.assert( arguments.length === 1 || arguments.length === 2, 'Expects 1 or 2 arguments' );
  _.assert( this.like( src ) );
  return this._exportStringDiagnosticShallow( ... arguments );
}

// --
// properties
// --

function keys( src )
{
  _.assert( arguments.length === 1 );
  return keys.functor.call( this, src )();
}

keys.functor = _functor_functor( 'keys' );

//

function vals( src )
{
  _.assert( arguments.length === 1 );
  return vals.functor.call( this, src )();
}

vals.functor = _functor_functor( 'vals' );

//

function pairs( src )
{
  _.assert( arguments.length === 1 );
  return pairs.functor.call( this, src )();
}

pairs.functor = _functor_functor( 'pairs' );

// --
// inspector
// --

function lengthOf( src ) /* qqq for junior : cover please */
{
  _.assert( arguments.length === 1 );
  return lengthOf.functor.call( this, src )();
}

lengthOf.functor = _functor_functor( 'lengthOf' );

//

function hasKey( src, ... args ) /* qqq for junior : cover please */
{
  _.assert( arguments.length === 2 );
  return hasKey.functor.call( this, src )( ... args );
}

hasKey.functor = _functor_functor( 'hasKey' );

//

function hasCardinal( src, ... args ) /* qqq for junior : cover please */
{
  _.assert( arguments.length === 2 );
  return hasCardinal.functor.call( this, src )( ... args );
}

hasCardinal.functor = _functor_functor( 'hasCardinal' );

//

function keyWithCardinal( src, ... args ) /* qqq for junior : cover please */
{
  _.assert( arguments.length === 2 );
  return keyWithCardinal.functor.call( this, src )( ... args );
}

keyWithCardinal.functor = _functor_functor( 'keyWithCardinal' );

//

function cardinalWithKey( src, ... args ) /* qqq for junior : cover please */
{
  _.assert( arguments.length === 2 );
  return cardinalWithKey.functor.call( this, src )( ... args );
}

cardinalWithKey.functor = _functor_functor( 'cardinalWithKey' );

// --
// editor
// --

// function empty( src ) /* qqq for junior : cover please */
// {
//   _.assert( arguments.length === 1 );
//   return empty.functor.call( this, src )();
// }
//
// empty.functor = _functor_functor( 'empty' );

//

/**
 * The routine elementWithCardinal() searches for value under a certain index {-key-} in a src {-src-}
 * and returns array with value, key, booLike.
 *
 * @param { Long|Set|HashMap|Aux } src - input src.
 * @param { Number } key - index to be looked in a src.
 *
 * @example
 * var src = { a : 1, b : 2 };
 * var got = _.src.elementWithCardinal( src, 0 );
 * console.log( got );
 * // log : [ 1, 'a', true ]
 *
 * @example
 * var src = [ 1, 2, 3 ];
 * var got = _.src.elementWithCardinal( src, 2 );
 * console.log( got );
 * // log : [ 3, 2, true ]
 *
 * @example
 * var src = new HashMap([ [ 'a', 1 ], [ true, false ], [ objRef, { a : 2 } ] ]);
 * var got = _.src.elementWithCardinal( src, 1 );
 * console.log( got )
 * // log : [ false, true, true ] );
 *
 * @example
 * var src = [ 1, 2, 3 ];
 * var got = _.src.elementWithCardinal( src, 5 );
 * console.log( got );
 * // log : [ undefined, 5, false ]
 *
 * @returns { Long } - with 3 elements : value ( undefined if index {-key-} is more or less than src's length ), key, boolLike ( true if index {-key-} is within src's length, false otherwise ).
 * @function elementWithCardinal
 * @throws { Error } If arguments.length is not equal to 2.
 * @throws { Error } If {-key-} is not Number.
 * @namespace Tools
 */

function elementWithCardinal( src, key ) /* qqq for junior : cover please | aaa : Done. */
{
  _.assert( arguments.length === 2 );
  _.assert( _.numberIs( key ) );
  if( !_.numberIs( key ) || key < 0 )
  return [ undefined, key, false ];
  return elementWithCardinal.functor.call( this, src )( key );
}

elementWithCardinal.functor = _functor_functor( 'elementWithCardinal' );

//

/**
 * The routine elementWithKey() searches for value under a certain {-key-} in a src {-src-}
 * and returns array with value, key, booLike.
 *
 * @param { Long|Set|HashMap|Aux } src - input src.
 * @param { * } key - key to be looked in a src.
 *
 * @example
 * var src = { a : 1, b : 2 };
 * var got = _.src.elementWithKey( src, 'a' );
 * console.log( got );
 * // log : [ 1, 'a', true ]
 *
 * @example
 * var src = [ 1, 2, 3 ];
 * var got = _.src.elementWithKey( src, 2 );
 * console.log( got );
 * // log : [ 3, 2, true ]
 *
 * @example
 * var src = new HashMap([ [ 'a', 1 ], [ true, false ], [ objRef, { a : 2 } ] ]);
 * var got = _.src.elementWithKey( src, true );
 * console.log( got )
 * // log : [ false, true, true ] );
 *
 * @example
 * var src = [ 1, 2, 3 ];
 * var got = _.src.elementWithKey( src, 5 );
 * console.log( got );
 * // log : [ undefined, 5, false ]
 *
 * @returns { Long } - with 3 elements : value ( undefined if key is absent ), key, boolLike ( true if key exists, false otherwise ).
 * @function elementWithKey
 * @throws { Error } If arguments.length is not equal to 2.
 * @namespace Tools
 */

function elementWithKey( src, key )
{
  _.assert( arguments.length === 2 );
  return elementWithKey.functor.call( this, src )( key );
}

elementWithKey.functor = _functor_functor( 'elementWithKey' );

//

function elementWithImplicit( src, key )
{
  _.assert( arguments.length === 2 );
  return elementWithImplicit.functor.call( this, src )( key );
}

elementWithImplicit.functor = _functor_functor( 'elementWithImplicit' );

//

function elementWithCardinalSet( src, key, val )
{
  _.assert( arguments.length === 3 );
  _.assert( _.numberIs( key ) );
  return elementWithCardinalSet.functor.call( this, src )( key, val );
}

elementWithCardinalSet.functor = _functor_functor( 'elementWithCardinalSet' );

//

function elementSet( src, key, val )
{
  _.assert( arguments.length === 3 );
  return elementSet.functor.call( this, src )( key, val );
}

elementSet.functor = _functor_functor( 'elementSet' );

// --
//
// --

function elementDel( src, key )
{
  _.assert( arguments.length === 2 );
  return elementDel.functor.call( this, src )( key );
}

elementDel.functor = _functor_functor( 'elementDel' );

//

function elementWithKeyDel( src, key )
{
  _.assert( arguments.length === 2 );
  return elementWithKeyDel.functor.call( this, src )( key );
}

elementWithKeyDel.functor = _functor_functor( 'elementWithKeyDel' );

//

function elementWithCardinalDel( src, key )
{
  _.assert( arguments.length === 2 );
  return elementWithCardinalDel.functor.call( this, src )( key );
}

elementWithCardinalDel.functor = _functor_functor( 'elementWithCardinalDel' );

//

/**
 * The routine empty() clears provided container {-dstContainer-}.
 *
 * @param { Long|Set|HashMap|Aux } dstContainer - Container to be cleared. {-dstContainer-} should be resizable.
 *
 * @example
 * let dst = [];
 * let got = _.src.empty( dst );
 * console.log( got );
 * // log []
 * console.log( got === dst );
 * log true
 *
 * @example
 * let dst = [ 1, 'str', { a : 2 } ];
 * let got = _.src.empty( dst );
 * console.log( got );
 * // log []
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let dst = _.unroll.make( [ 1, 'str', { a : 2 } ] );
 * let got = _.src.empty( dst );
 * console.log( got );
 * // log []
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let dst = new Set( [ 1, 'str', { a : 2 } ] );
 * let got = _.src.empty( dst );
 * console.log( got );
 * // log Set {}
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let dst = new HashMap( [ [ 1, 'str' ], [ 'a', null ] ] );
 * let got = _.src.empty( dst );
 * console.log( got );
 * // log Map {}
 * console.log( got === dst );
 * // log true
 *
 * @returns { Long|Set|HashMap|Aux } - Returns a empty {-dstContainer-}.
 * @function empty
 * @throws { Error } If arguments.length is less than one.
 * @throws { Error } If {-dstContainer-} is not a Long, not a Set, not a HashMap, not a Aux.
 * @throws { Error } If {-dstContainer-} is not a resizable Long, or if it is a WeakSet or WeakMap.
 * @namespace Tools
 */

function empty( src )
{
  _.assert( arguments.length === 1 );
  return empty.functor.call( this, src )();
}

empty.functor = _functor_functor( 'empty' );

  // elementDel, /* qqq : cover */
  // elementWithKeyDel, /* qqq : cover */
  // elementWithCardinalDel,  /* qqq : cover */
  // empty, /* qqq : for junior : cover */

// --
// iterator
// --

function eachLeft( src, onEach )
{
  _.assert( arguments.length === 2 );
  return eachLeft.functor.call( this, src )( onEach );
}

eachLeft.functor = _functor_functor( 'eachLeft' );

//

function eachRight( src, onEach )
{
  _.assert( arguments.length === 2 );
  return eachRight.functor.call( this, src )( onEach );
}

eachRight.functor = _functor_functor( 'eachRight' );

//

function whileLeft( src, onEach )
{
  _.assert( arguments.length === 2 );
  return whileLeft.functor.call( this, src )( onEach );
}

whileLeft.functor = _functor_functor( 'whileLeft' );

//

function whileRight( src, onEach )
{
  _.assert( arguments.length === 2 );
  return whileRight.functor.call( this, src )( onEach );
}

whileRight.functor = _functor_functor( 'whileRight' );

//

function aptLeft( src, onEach )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  return aptLeft.functor.call( this, src )( onEach );
}

aptLeft.functor = _functor_functor( 'aptLeft' );

//

function aptRight( src, onEach )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  return aptRight.functor.call( this, src )( onEach );
}

aptRight.functor = _functor_functor( 'aptRight' );

//

function filterWithoutEscapeLeft( dst, src, ... args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return filterWithoutEscapeLeft.functor.call( this, src )( dst, ... args );
}

filterWithoutEscapeLeft.functor = _functor_functor( 'filterWithoutEscapeLeft', null, 1 );

//

function filterWithoutEscapeRight( dst, src, ... args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return filterWithoutEscapeRight.functor.call( this, src )( dst, ... args );
}

filterWithoutEscapeRight.functor = _functor_functor( 'filterWithoutEscapeRight', null, 1 );

//

function filterWithEscapeLeft( dst, src, ... args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return filterWithEscapeLeft.functor.call( this, src )( dst, ... args );
}

filterWithEscapeLeft.functor = _functor_functor( 'filterWithEscapeLeft', null, 1 );

//

function filterWithEscapeRight( dst, src, ... args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return filterWithEscapeRight.functor.call( this, src )( dst, ... args );
}

filterWithEscapeRight.functor = _functor_functor( 'filterWithEscapeRight', null, 1 );

//

function mapWithoutEscapeLeft( dst, src, ... args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return mapWithoutEscapeLeft.functor.call( this, src )( dst, ... args );
}

mapWithoutEscapeLeft.functor = _functor_functor( 'mapWithoutEscapeLeft', null, 1 );

//

function mapWithoutEscapeRight( dst, src, ... args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return mapWithoutEscapeRight.functor.call( this, src )( dst, ... args );
}

mapWithoutEscapeRight.functor = _functor_functor( 'mapWithoutEscapeRight', null, 1 );

//

function mapWithEscapeLeft( dst, src, ... args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return mapWithEscapeLeft.functor.call( this, src )( dst, ... args );
}

mapWithEscapeLeft.functor = _functor_functor( 'mapWithEscapeLeft', null, 1 );

//

function mapWithEscapeRight( dst, src, ... args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return mapWithEscapeRight.functor.call( this, src )( dst, ... args );
}

mapWithEscapeRight.functor = _functor_functor( 'mapWithEscapeRight', null, 1 );

// --
// extension
// --

let ContainerExtension =
{

  // exporter

  _exportStringDiagnosticShallow,
  exportStringDiagnosticShallow,
  _exportStringCodeShallow : _exportStringDiagnosticShallow,
  exportStringCodeShallow : exportStringDiagnosticShallow,
  exportString : exportStringDiagnosticShallow,

  // properties

  /* xxx : review */
  keys,
  vals,
  pairs,

  // inspector

  lengthOf, /* qqq : cover */
  hasKey, /* qqq : cover */
  hasCardinal, /* qqq : cover */
  keyWithCardinal, /* qqq : cover */
  cardinalWithKey, /* qqq : cover */

  // editor

  // empty, /* qqq : cover */

  // elementor

  elementWithCardinal, /* qqq : cover */
  elementWithKey, /* qqq : cover */
  elementWithImplicit, /* qqq : cover */
  elementWithCardinalSet, /* qqq : cover */
  elementSet, /* qqq : cover */

  elementDel, /* qqq : cover */
  elementWithKeyDel, /* qqq : cover */
  elementWithCardinalDel,  /* qqq : cover */
  empty, /* qqq : for junior : cover */

  // iterator

  each : eachLeft, /* qqq : cover */
  eachLeft, /* qqq : cover */
  eachRight, /* qqq : cover */

  while : whileLeft, /* qqq : cover */
  whileLeft, /* qqq : cover */
  whileRight, /* qqq : cover */

  aptLeft, /* qqq : cover */
  first : aptLeft, /* qqq : cover */
  aptRight, /* qqq : cover */
  last : aptRight, /* qqq : cover */

  filterWithoutEscapeLeft,
  filterWithoutEscapeRight,
  filterWithoutEscape : filterWithoutEscapeLeft,
  filterWithEscapeLeft,
  filterWithEscapeRight,
  filterWithEscape : filterWithEscapeLeft,
  filter : filterWithoutEscapeLeft,

  mapWithoutEscapeLeft,
  mapWithoutEscapeRight,
  mapWithoutEscape : mapWithoutEscapeLeft,
  mapWithEscapeLeft,
  mapWithEscapeRight,
  mapWithEscape : mapWithEscapeLeft,
  map : mapWithoutEscapeLeft,

  // map,
  // filter,

}

Object.assign( _.container, ContainerExtension );

//

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

//

})();

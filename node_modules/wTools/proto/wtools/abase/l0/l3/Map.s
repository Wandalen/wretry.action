( function _l3_Map_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

_.assert( !!_.props._elementWithKey, 'Expects routine _.props._elementWithKey' );
_.assert( !!_.props.exportString, 'Expects routine _.props.exportString' );

// --
// equaler
// --

function _identicalShallow( src1, src2 )
{

  if( Object.keys( src1 ).length !== Object.keys( src2 ).length )
  return false;

  for( let s in src1 )
  {
    if( src1[ s ] !== src2[ s ] )
    return false;
  }

  return true;
}

//

/**
 * The containShallow() returns true, if the first object {-srcMap-}
 * has the same values as the second object(ins).
 *
 * It takes two objects (scr, ins),
 * checks if the first object {-srcMap-} has the same [key, value] as
 * the second object (ins).
 * If true, it returns true,
 * otherwise it returns false.
 *
 * @param { objectLike } src - Target object.
 * @param { objectLike } ins - Second object.
 * Objects to compare values.
 *
 * @example
 * _.map.containShallow( { a : 7, b : 13, c : 15 }, { a : 7, b : 13 } );
 * // returns true
 *
 * @example
 * _.map.containShallow( { a : 7, b : 13 }, { a : 7, b : 13, c : 15 } );
 * // returns false
 *
 * @returns { boolean } Returns true, if the first object {-srcMap-}
 * has the same values as the second object(ins).
 * @function containShallow
 * @throws Will throw an error if ( arguments.length !== 2 ).
 * @namespace Tools/map
 */

function containShallow( src, ins )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( !this.like( src ) )
  return false;
  if( !this.like( ins ) )
  return false;

  for( let s in ins )
  {
    if( !( s in src ) )
    continue;
    if( src[ s ] !== ins[ s ] )
    return false;
  }

  return true;
}

// /**
//  * The mapsAreIdentical() returns true, if the second object (src2)
//  * has the same values as the first object(src1).
//  *
//  * It takes two objects (scr1, src2), checks
//  * if both object have the same length and [key, value] return true
//  * otherwise it returns false.
//  *
//  * @param { objectLike } src1 - First object.
//  * @param { objectLike } src2 - Target object.
//  * Objects to compare values.
//  *
//  * @example
//  * _.map.identical( { a : 7, b : 13 }, { a : 7, b : 13 } );
//  * // returns true
//  *
//  * @example
//  * _.map.identical( { a : 7, b : 13 }, { a : 33, b : 13 } );
//  * // returns false
//  *
//  * @example
//  * _.map.identical( { a : 7, b : 13, c : 33 }, { a : 7, b : 13 } );
//  * // returns false
//  *
//  * @returns { boolean } Returns true, if the second object (src2)
//  * has the same values as the first object(src1).
//  * @function mapsAreIdentical
//  * @throws Will throw an error if ( arguments.length !== 2 ).
//  * @namespace Tools
//  */
//
// function mapsAreIdentical( src1, src2 )
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

// --
// extension
// --

/* qqq : for junior : duplicate routines */

let ToolsExtension =
{

}

Object.assign( _, ToolsExtension );

//

let ExtensionMap =
{

  // equaler

  _identicalShallow,
  identicalShallow : _.props.identicalShallow,
  identical : _.props.identical,
  _equivalentShallow : _identicalShallow,
  equivalentShallow : _.props.equivalentShallow,
  equivalent : _.props.equivalent,

  containShallow,
  contain : containShallow,

  // exporter

  _exportStringDiagnosticShallow : _.props._exportStringDiagnosticShallow,
  exportStringDiagnosticShallow : _.props.exportStringDiagnosticShallow,
  _exportStringCodeShallow : _.props._exportStringCodeShallow,
  exportStringCodeShallow : _.props.exportStringCodeShallow,
  exportString : _.props.exportString,

  // container interface

  _lengthOf : _.props._lengthOf,
  lengthOf : _.props.lengthOf, /* qqq : cover */
  _hasKey : _.props._hasKey,
  hasKey : _.props._hasKey, /* qqq : cover */
  _hasCardinal : _.props._hasKey,
  hasCardinal : _.props._hasKey, /* qqq : cover */
  _keyWithCardinal : _.props._hasKey,
  keyWithCardinal : _.props._hasKey, /* qqq : cover */
  _cardinalWithKey : _.props._cardinalWithKey,
  cardinalWithKey : _.props.cardinalWithKey, /* qqq : cover */

  _elementGet : _.props._elementWithKey,
  elementGet : _.props.elementWithKey, /* qqq : cover */
  _elementWithKey : _.props._elementWithKey,
  elementWithKey : _.props.elementWithKey, /* qqq : cover */
  _elementWithImplicit : _.props._elementWithImplicit,
  elementWithImplicit : _.props.elementWithImplicit,  /* qqq : cover */
  _elementWithCardinal : _.props._elementWithCardinal,
  elementWithCardinal : _.props.elementWithCardinal,  /* qqq : cover */

  _elementSet : _.props._elementSet,
  elementSet : _.props.elementSet, /* qqq : cover */
  _elementWithKeySet : _.props._elementWithKeySet,
  elementWithKeySet : _.props.elementWithKeySet, /* qqq : cover */
  _elementWithCardinalSet : _.props._elementWithCardinalSet,
  elementWithCardinalSet : _.props.elementWithCardinalSet,  /* qqq : cover */

  _elementDel : _.props._elementDel,
  elementDel : _.props.elementDel, /* qqq : cover */
  _elementWithKeyDel : _.props._elementWithKeyDel,
  elementWithKeyDel : _.props.elementWithKeyDel, /* qqq : cover */
  _elementWithCardinalDel : _.props._elementWithCardinalDel,
  elementWithCardinalDel : _.props.elementWithCardinalDel,  /* qqq : cover */
  _empty : _.props._empty,
  empty : _.props.empty, /* qqq : for junior : cover */

  _each : _.props._each,
  each : _.props.each, /* qqq : cover */
  _eachLeft : _.props._eachLeft,
  eachLeft : _.props.eachLeft, /* qqq : cover */
  _eachRight : _.props._eachRight,
  eachRight : _.props.eachRight, /* qqq : cover */

  _while : _.props._while,
  while : _.props.while, /* qqq : cover */
  _whileLeft : _.props._whileLeft,
  whileLeft : _.props.whileLeft, /* qqq : cover */
  _whileRight : _.props._whileRight,
  whileRight : _.props.whileRight, /* qqq : cover */

  _aptLeft : _.props._aptLeft,
  aptLeft : _.props.aptLeft, /* qqq : cover */
  first : _.props.first,
  _aptRight : _.props._aptRight, /* qqq : cover */
  aptRight : _.props.aptRight,
  last : _.props.last, /* qqq : cover */

  _filterAct0 : _.props._filterAct0,
  _filterAct : _.props._filterAct,
  filterWithoutEscapeLeft : _.props.filterWithoutEscapeLeft,
  filterWithoutEscapeRight : _.props.filterWithoutEscapeRight,
  filterWithoutEscape : _.props.filterWithoutEscape,
  filterWithEscapeLeft : _.props.filterWithEscapeLeft,
  filterWithEscapeRight : _.props.filterWithEscapeRight,
  filterWithEscape : _.props.filterWithEscape,
  filter : _.props.filter,

  _mapAct0 : _.props._mapAct0,
  _mapAct : _.props._mapAct,
  mapWithoutEscapeLeft : _.props.mapWithoutEscapeLeft,
  mapWithoutEscapeRight : _.props.mapWithoutEscapeRight,
  mapWithoutEscape : _.props.mapWithoutEscape,
  mapWithEscapeLeft : _.props.mapWithEscapeLeft,
  mapWithEscapeRight : _.props.mapWithEscapeRight,
  mapWithEscape : _.props.mapWithEscape,
  map : _.props.map,

}

Object.assign( _.map, ExtensionMap );

})();

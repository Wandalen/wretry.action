( function _l3_Vector_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

_.assert( !!_.countable._elementWithKey, 'Expects routine countable._elementWithKey' );

// --
// dichotomy
// --

function adapterIs( src )
{
  return Object.prototype.toString.call( src ) === '[object VectorAdapter]';
}

//

function constructorIsVectorAdapter( src )
{
  if( !src )
  return false;
  return '_vectorBuffer' in src.prototype;
}

// --
// extension
// --

var ToolsExtension =
{
  vectorAdapterIs : adapterIs,
  vadIs : adapterIs,
  constructorIsVectorAdapter,
  constructorIsVad : constructorIsVectorAdapter,
}

Object.assign( _, ToolsExtension );

//

var VectorExtension =
{

  // dichotomy

  adapterIs,
  constructorIsVectorAdapter,

  // equaler

  /* qqq : implement more optimal own version of this routines */
  _identicalShallow : _.countable.identicalShallow,
  identicalShallow : _.countable.identicalShallow,
  identical : _.countable.identical,
  _equivalentShallow : _.countable.identicalShallow,
  equivalentShallow : _.countable.equivalentShallow,
  equivalent : _.countable.equivalent,

  // exporter

  /* qqq : implement more optimal own version of this routines */
  _exportStringDiagnosticShallow : _.countable._exportStringDiagnosticShallow,
  exportStringDiagnosticShallow : _.countable.exportStringDiagnosticShallow,
  _exportStringCodeShallow : _.countable._exportStringCodeShallow,
  exportStringCodeShallow : _.countable.exportStringCodeShallow,
  exportString : _.countable.exportString,

    // container interface

  _lengthOf : _.countable._lengthOf,
  lengthOf : _.countable.lengthOf, /* qqq : cover */

  _hasKey : _.countable._hasKey,
  hasKey : _.countable._hasKey, /* qqq : cover */
  _hasCardinal : _.countable._hasKey,
  hasCardinal : _.countable._hasKey, /* qqq : cover */
  _keyWithCardinal : _.countable._hasKey,
  keyWithCardinal : _.countable._hasKey, /* qqq : cover */
  _cardinalWithKey : _.countable._cardinalWithKey,
  cardinalWithKey : _.countable.cardinalWithKey, /* qqq : cover */

  _elementGet : _.countable._elementWithKey,
  elementGet : _.countable.elementWithKey, /* qqq : cover */
  _elementWithKey : _.countable._elementWithKey,
  elementWithKey : _.countable.elementWithKey, /* qqq : cover */
  _elementWithImplicit : _.countable._elementWithImplicit,
  elementWithImplicit : _.countable.elementWithImplicit,  /* qqq : cover */
  _elementWithCardinal : _.countable._elementWithCardinal,
  elementWithCardinal : _.countable.elementWithCardinal,  /* qqq : cover */

  _elementSet : _.countable._elementSet,
  elementSet : _.countable.elementSet, /* qqq : cover */
  _elementWithKeySet : _.countable._elementWithKeySet,
  elementWithKeySet : _.countable.elementWithKeySet, /* qqq : cover */
  _elementWithCardinalSet : _.countable._elementWithCardinalSet,
  elementWithCardinalSet : _.countable.elementWithCardinalSet,  /* qqq : cover */

  _elementDel : _.countable._elementDel,
  elementDel : _.countable.elementDel, /* qqq : cover */
  _elementWithKeyDel : _.countable._elementWithKeyDel,
  elementWithKeyDel : _.countable.elementWithKeyDel, /* qqq : cover */
  _elementWithCardinalDel : _.countable._elementWithCardinalDel,
  elementWithCardinalDel : _.countable.elementWithCardinalDel,  /* qqq : cover */
  _empty : _.countable._empty,
  empty : _.countable.empty,  /* qqq : cover */

  _elementAppend : _.countable._elementAppend,
  elementAppend : _.countable.elementAppend, /* qqq : cover */
  _elementPrepend : _.countable._elementPrepend,
  elementPrepend : _.countable.elementPrepend, /* qqq : cover */

  _each : _.countable._each,
  each : _.countable.each, /* qqq : cover */
  _eachLeft : _.countable._eachLeft,
  eachLeft : _.countable.eachLeft, /* qqq : cover */
  _eachRight : _.countable._eachRight,
  eachRight : _.countable.eachRight, /* qqq : cover */

  _while : _.countable._while,
  while : _.countable.while, /* qqq : cover */
  _whileLeft : _.countable._whileLeft,
  whileLeft : _.countable.whileLeft, /* qqq : cover */
  _whileRight : _.countable._whileRight,
  whileRight : _.countable.whileRight, /* qqq : cover */

  _aptLeft : _.countable._aptLeft,
  aptLeft : _.countable.aptLeft, /* qqq : cover */
  first : _.countable.first,
  _aptRight : _.countable._aptRight, /* qqq : cover */
  aptRight : _.countable.aptRight,
  last : _.countable.last, /* qqq : cover */

  _filterAct : _.countable._filterAct,
  filterWithoutEscapeLeft : _.countable.filterWithoutEscapeLeft,
  filterWithoutEscapeRight : _.countable.filterWithoutEscapeRight,
  filterWithoutEscape : _.countable.filterWithoutEscape,
  filterWithEscapeLeft : _.countable.filterWithEscapeLeft,
  filterWithEscapeRight : _.countable.filterWithEscapeRight,
  filterWithEscape : _.countable.filterWithEscape,
  filter : _.countable.filter,

  _mapAct : _.countable._mapAct,
  mapWithoutEscapeLeft : _.countable.mapWithoutEscapeLeft,
  mapWithoutEscapeRight : _.countable.mapWithoutEscapeRight,
  mapWithoutEscape : _.countable.mapWithoutEscape,
  mapWithEscapeLeft : _.countable.mapWithEscapeLeft,
  mapWithEscapeRight : _.countable.mapWithEscapeRight,
  mapWithEscape : _.countable.mapWithEscape,
  map : _.countable.map,

  // _filterAct0 : _.countable._filterAct0,
  // _filterAct : _.countable._filterAct,
  // filterWithoutEscapeLeft : _.countable.filterWithoutEscapeLeft,
  // filterWithoutEscapeRight : _.countable.filterWithoutEscapeRight,
  // filterWithoutEscape : _.countable.filterWithoutEscape,
  // filterWithEscapeLeft : _.countable.filterWithEscapeLeft,
  // filterWithEscapeRight : _.countable.filterWithEscapeRight,
  // filterWithEscape : _.countable.filterWithEscape,
  // filter : _.countable.filter,
  //
  // _mapAct0 : _.countable._mapAct0,
  // _mapAct : _.countable._mapAct,
  // mapWithoutEscapeLeft : _.countable.mapWithoutEscapeLeft,
  // mapWithoutEscapeRight : _.countable.mapWithoutEscapeRight,
  // mapWithoutEscape : _.countable.mapWithoutEscape,
  // mapWithEscapeLeft : _.countable.mapWithEscapeLeft,
  // mapWithEscapeRight : _.countable.mapWithEscapeRight,
  // mapWithEscape : _.countable.mapWithEscape,
  // map : _.countable.map,

}

Object.assign( _.vector, VectorExtension );

//

})();

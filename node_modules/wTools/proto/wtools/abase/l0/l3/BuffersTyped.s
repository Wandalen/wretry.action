( function _l1_BuffersTyped_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

function _functor( namespace )
{

  // --
  // declare
  // --

  let ToolsExtension =
  {
  }

  Object.assign( _, ToolsExtension );

  //

  let BufferTypedExtension =
  {

    // equaler

    _identicalShallow : _.long._identicalShallow,
    identicalShallow : _.long.identicalShallow,
    identical : _.long.identical,
    _equivalentShallow : _.long._equivalentShallow,
    equivalentShallow : _.long.equivalentShallow,
    equivalent : _.long.equivalent,

    // exporter

    _exportStringDiagnosticShallow : _.long._exportStringDiagnosticShallow,
    exportStringDiagnosticShallow : _.long.exportStringDiagnosticShallow,
    _exportStringCodeShallow : _.long._exportStringCodeShallow,
    exportStringCodeShallow : _.long.exportStringCodeShallow,
    exportString : _.long.exportString,

    // container interface

    _lengthOf : _.long._lengthOf,
    lengthOf : _.long.lengthOf, /* qqq : cover */

    _hasKey : _.long._hasKey,
    hasKey : _.long._hasKey, /* qqq : cover */
    _hasCardinal : _.long._hasKey,
    hasCardinal : _.long._hasKey, /* qqq : cover */
    _keyWithCardinal : _.long._hasKey,
    keyWithCardinal : _.long._hasKey, /* qqq : cover */
    _cardinalWithKey : _.long._cardinalWithKey,
    cardinalWithKey : _.long.cardinalWithKey, /* qqq : cover */

    _elementGet : _.long._elementWithKey,
    elementGet : _.long.elementWithKey, /* qqq : cover */
    _elementWithKey : _.long._elementWithKey,
    elementWithKey : _.long.elementWithKey, /* qqq : cover */
    _elementWithImplicit : _.long._elementWithImplicit,
    elementWithImplicit : _.long.elementWithImplicit,  /* qqq : cover */
    _elementWithCardinal : _.long._elementWithCardinal,
    elementWithCardinal : _.long.elementWithCardinal,  /* qqq : cover */

    _elementSet : _.long._elementSet,
    elementSet : _.long.elementSet, /* qqq : cover */
    _elementWithKeySet : _.long._elementWithKeySet,
    elementWithKeySet : _.long.elementWithKeySet, /* qqq : cover */
    _elementWithCardinalSet : _.long._elementWithCardinalSet,
    elementWithCardinalSet : _.long.elementWithCardinalSet,  /* qqq : cover */

    _elementAppend : _.argumentsArray._elementAppend,
    elementAppend : _.argumentsArray.elementAppend, /* qqq : cover */
    _elementPrepend : _.argumentsArray._elementPrepend,
    elementPrepend : _.argumentsArray.elementPrepend, /* qqq : cover */

    _elementDel : _.argumentsArray._elementDel,
    elementDel : _.argumentsArray.elementDel, /* qqq : cover */
    _elementWithKeyDel : _.argumentsArray._elementWithKeyDel,
    elementWithKeyDel : _.argumentsArray.elementWithKeyDel, /* qqq : cover */
    _elementWithCardinalDel : _.argumentsArray._elementWithCardinalDel,
    elementWithCardinalDel : _.argumentsArray.elementWithCardinalDel,  /* qqq : cover */
    _empty : _.argumentsArray._empty,
    empty : _.argumentsArray.empty, /* qqq : for junior : cover */

    _each : _.long._each,
    each : _.long.each, /* qqq : cover */
    _eachLeft : _.long._eachLeft,
    eachLeft : _.long.eachLeft, /* qqq : cover */
    _eachRight : _.long._eachRight,
    eachRight : _.long.eachRight, /* qqq : cover */

    _while : _.long._while,
    while : _.long.while, /* qqq : cover */
    _whileLeft : _.long._whileLeft,
    whileLeft : _.long.whileLeft, /* qqq : cover */
    _whileRight : _.long._whileRight,
    whileRight : _.long.whileRight, /* qqq : cover */

    _aptLeft : _.long._aptLeft,
    aptLeft : _.long.aptLeft, /* qqq : cover */
    first : _.long.first,
    _aptRight : _.long._aptRight, /* qqq : cover */
    aptRight : _.long.aptRight,
    last : _.long.last, /* qqq : cover */

    _filterAct : _.long._filterAct,
    filterWithoutEscapeLeft : _.long.filterWithoutEscapeLeft,
    filterWithoutEscapeRight : _.long.filterWithoutEscapeRight,
    filterWithoutEscape : _.long.filterWithoutEscape,
    filterWithEscapeLeft : _.long.filterWithEscapeLeft,
    filterWithEscapeRight : _.long.filterWithEscapeRight,
    filterWithEscape : _.long.filterWithEscape,
    filter : _.long.filter,

    _mapAct : _.long._mapAct,
    mapWithoutEscapeLeft : _.long.mapWithoutEscapeLeft,
    mapWithoutEscapeRight : _.long.mapWithoutEscapeRight,
    mapWithoutEscape : _.long.mapWithoutEscape,
    mapWithEscapeLeft : _.long.mapWithEscapeLeft,
    mapWithEscapeRight : _.long.mapWithEscapeRight,
    mapWithEscape : _.long.mapWithEscape,
    map : _.long.map,

  }

  //

  Object.assign( namespace, BufferTypedExtension );

}

_.assert( !!_.fx );
_.assert( !_.fx.filter );
_.assert( !_.fx.map );

for( let name in _.long.namespaces )
{
  let namespace = _.long.namespaces[ name ];
  if( namespace.IsTyped )
  _functor( namespace );
}

_.assert( !!_.fx.filter );
_.assert( !!_.fx.map );

})();

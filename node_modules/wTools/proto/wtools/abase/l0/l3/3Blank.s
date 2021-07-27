( function _l1_3Blank_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.blank = _.blank || Object.create( null );

// --
// equaler
// --

function _identicalShallow( src1, src2 )
{
  return src1 === src2;
}

// --
// exporter
// --

function _exportStringDiagnosticShallow( src )
{
  return `{- ${_.entity.strType( src )} -}`;
}

// --
// container interface
// --

function _lengthOf( src )
{
  return 0;
}

//

function _hasKey( src, key )
{
  return false;
}

//

function _hasCardinal( src, cardinal )
{
  return false;
}

//

function _keyWithCardinal( src, cardinal )
{
  return [ undefined, false ];
}

//

function _cardinalWithKey( key )
{
  return -1;
}

//

function _elementWithKey( src, key )
{
  return [ undefined, key, false ];
}

//

function _elementWithCardinal( src, cardinal )
{
  return [ undefined, cardinal, false ];
}

//

function _elementWithKeySet( dst, key, val )
{
  return [ key, false ];
}

//

function _elementWithCardinalSet( dst, cardinal, val )
{
  return [ cardinal, false ];
}

//

function _elementWithKeyDel( dst, key )
{
  _.assert( 0, `Cant delete element of ${this.NamespaceName}` );
  return false;
}

//

function _elementWithCardinalDel( dst, cardinal )
{
  _.assert( 0, `Cant delete element of ${this.NamespaceName}` );
  return false;
}

//

function _empty( dst )
{
  _.assert( 0, `Cant empty ${this.NamespaceName}` );
  return dst;
}

//

function _eachLeft( src, onEach )
{
}

//

function _eachRight( src, onEach )
{
}

//

function _whileLeft( src, onEach )
{
  return [ undefined, undefined, -1, true ];
}

//

function _whileRight( src, onEach )
{
  return [ undefined, undefined, -1, true ];
}

// --
// extension
// --

let BlankExtension =
{

  // equaler

  _identicalShallow,
  identicalShallow : _.props.identicalShallow,
  identical : _.props.identical,
  _equivalentShallow : _identicalShallow,
  equivalentShallow : _.props.equivalentShallow,
  equivalent : _.props.equivalent,

  // exporter

  _exportStringDiagnosticShallow,
  exportStringDiagnosticShallow : _.props.exportStringDiagnosticShallow,
  _exportStringCodeShallow : _exportStringDiagnosticShallow,
  exportStringCodeShallow : _.props.exportStringCodeShallow,
  exportString : _.props.exportString,

  // inspector

  _lengthOf,
  lengthOf : _.props.lengthOf, /* qqq : cover */
  _hasKey,
  hasKey : _.props.hasKey, /* qqq : cover */
  _hasCardinal,
  hasCardinal : _.props.hasCardinal, /* qqq : cover */
  _keyWithCardinal,
  keyWithCardinal : _.props.keyWithCardinal, /* qqq : cover */
  _cardinalWithKey,
  cardinalWithKey : _.props.cardinalWithKey, /* qqq : cover */

  // elementor

  _elementGet : _elementWithKey,
  elementGet : _.props.elementGet, /* qqq : cover */
  _elementWithKey,
  elementWithKey : _.props.elementWithKey, /* qqq : cover */
  _elementWithImplicit : _.props._elementWithImplicit,
  elementWithImplicit : _.props.elementWithImplicit,  /* qqq : cover */
  _elementWithCardinal,
  elementWithCardinal : _.props.elementWithCardinal,  /* qqq : cover */

  _elementSet : _elementWithKeySet,
  elementSet : _.props.elementSet, /* qqq : cover */
  _elementWithKeySet,
  elementWithKeySet : _.props.elementWithKeySet, /* qqq : cover */
  _elementWithCardinalSet,
  elementWithCardinalSet : _.props.elementWithCardinalSet,  /* qqq : cover */

  _elementDel : _elementWithKeyDel,
  elementDel : _.props.elementDel, /* qqq : cover */
  _elementWithKeyDel,
  elementWithKeyDel : _.props.elementWithKeyDel, /* qqq : cover */
  _elementWithCardinalDel,
  elementWithCardinalDel : _.props.elementWithCardinalDel,  /* qqq : cover */
  _empty,
  empty : _.props.empty, /* qqq : for junior : cover */

  // iterator

  _each : _eachLeft,
  each : _.props.each, /* qqq : cover */
  _eachLeft,
  eachLeft : _.props.eachLeft, /* qqq : cover */
  _eachRight,
  eachRight : _.props.eachRight, /* qqq : cover */

  _while : _whileLeft,
  while : _.props.while, /* qqq : cover */
  _whileLeft,
  whileLeft : _.props.whileLeft, /* qqq : cover */
  _whileRight,
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

Object.assign( _.blank, BlankExtension );

// --
// tools extension
// --

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

})();

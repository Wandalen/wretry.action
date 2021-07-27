( function _l3_Itself_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

_.assert( !!_.blank.identical, 'Expects routine blank.identical' );
_.assert( !!_.blank.exportString, 'Expects routine _.blank.exportString' );

// --
// container interface
// --

function _lengthOf( src )
{
  return 1;
}

//

function _hasKey( src, key )
{
  if( cardinal === 0 )
  return true;
  return false;
}

//

function _hasCardinal( src, cardinal )
{
  if( cardinal === 0 )
  return true;
  return false;
}

//

function _keyWithCardinal( src, cardinal )
{
  if( cardinal === 0 )
  return [ 0, true ];
  return [ undefined, false ];
}

//

function _cardinalWithKey( key )
{
  if( key === 0 )
  return 0;
  return -1;
}

//

function _elementWithKey( src, key )
{
  if( key === 0 )
  return [ src, key, true ];
  return [ undefined, key, false ];
}

//

function _elementWithCardinal( src, cardinal )
{
  if( cardinal === 0 )
  return [ src, cardinal, true ];
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
  if( cardinal === 0 )
  return [ cardinal, true ];
  else
  return [ cardinal, false ];
}

//

function _elementWithKeyDel( dst, key )
{
  return false;
}

//

function _elementWithCardinalDel( dst, cardinal )
{
  return false;
}

//

function _empty( dst )
{
  return dst;
}

//

function _eachLeft( src, onEach )
{
  onEach( src, null, 0, src );
}

//

function _eachRight( src, onEach )
{
  onEach( src, null, 0, src );
}

//

function _whileLeft( src, onEach )
{
  let r = onEach( src, null, 0, src );
  _.assert( r === true || r === false );
  if( r === false )
  return [ src, null, 0, false ];
  return [ src, null, 0, true ];
}

//

function _whileRight( src, onEach )
{
  let r = onEach( src, null, 0, src );
  _.assert( r === true || r === false );
  if( r === false )
  return [ src, null, 0, false ];
  return [ src, null, 0, true ];
}

// --
// extension
// --

let ItselfExtension =
{

  // equaler

  _identicalShallow : _.blank._identicalShallow,
  identicalShallow : _.blank.identicalShallow,
  identical : _.blank.identical,
  _equivalentShallow : _.blank._equivalentShallow,
  equivalentShallow : _.blank.equivalentShallow,
  equivalent : _.blank.equivalent,

  // exporter

  _exportStringDiagnosticShallow : _.blank._exportStringDiagnosticShallow,
  exportStringDiagnosticShallow : _.blank.exportStringDiagnosticShallow,
  _exportStringCodeShallow : _.blank._exportStringCodeShallow,
  exportStringCodeShallow : _.blank.exportStringCodeShallow,
  exportString : _.blank.exportString,

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

Object.assign( _.itself, ItselfExtension );

// --
// tools extension
// --

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

})();

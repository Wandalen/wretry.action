( function _l3_Object_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

_.assert( !!_.props._elementWithKey, 'Expects routine _.props._elementWithKey' );
_.assert( !!_.props.keys, 'Expects routine _.props.keys' );

// --
// equaler
// --

function _identicalShallow( src1, src2 )
{

  if( _.aux.is( src1 ) && _.aux.is( src2 ) )
  return _.aux._identicalShallow( src1, src2 );

  if( _.countable.is( src1 ) && _.countable.is( src2 ) )
  return _.countable._identicalShallow( src1, src2 );

  let equal = _.class.methodEqualOf( src1 ) || _.class.methodEqualOf( src2 );
  if( equal )
  return equal( src1, src2, {} );

  return src1 === src2;
}

//

function _equivalentShallow( src1, src2 )
{

  if( _.aux.is( src1 ) && _.aux.is( src2 ) )
  return _.aux._equivalentShallow( src1, src2 );

  if( _.countable.is( src1 ) && _.countable.is( src2 ) )
  return _.countable._equivalentShallow( src1, src2 );

  let equal = _.class.methodEqualOf( src1 ) || _.class.methodEqualOf( src2 );

  if( equal )
  return equal( src1, src2, {} );

  return src1 === src2;
}

// --
// exporter
// --

function _exportStringDiagnosticShallow( src )
{
  let result = '';
  let method = _.class.methodExportStringOf( src );

  if( method )
  {
    result = method.call( src, { verbosity : 1 } );
    result = _.strShort_( result ).result;
  }
  else
  {
    if( _.countable.is( src ) )
    result = _.countable.exportStringDiagnosticShallow( src );
    else
    result = `{- ${_.entity.strType( src )} -}`;
  }

  return result;
}

// --
// inspector
// --

function _lengthOf( src )
{
  if( _.countable.is( src ) )
  return _.countable._lengthOf( src );
  return _.props._lengthOf( src );
}

//

function _hasKey( src, key )
{
  // if( _.number.is( key ) )
  if( _.countable.is( src ) && _.number.is( key ) )
  return _.countable._hasKey( src, key );
  return _.props._hasKey( src, key );
}

//

function _hasCardinal( src, cardinal )
{
  if( _.countable.is( src ) )
  return _.countable._hasCardinal( src, cardinal );
  return _.props._hasCardinal( src, cardinal );
}

//

function _keyWithCardinal( src, cardinal )
{
  if( _.countable.is( src ) )
  return _.countable._keyWithCardinal( src, cardinal );
  return _.props._keyWithCardinal( src, cardinal );
}

//

function _cardinalWithKey( src, key )
{
  if( _.countable.is( src ) )
  return _.countable._cardinalWithKey( src, key );
  return _.props._cardinalWithKey( src, key );
}

// --
// elementor
// --

function _elementWithKey( src, key )
{
  // if( _.number.is( key ) )
  if( _.countable.is( src ) && _.number.is( key ) )
  return _.countable._elementWithKey( src, key );
  return _.props._elementWithKey( src, key );
}

//

function _elementWithCardinal( src, cardinal )
{
  if( _.countable.is( src ) )
  return _.countable._elementWithCardinal( src, cardinal );
  return _.props._elementWithCardinal( src, cardinal );
}

//

function _elementWithKeySet( dst, key, val )
{
  // if( _.number.is( key ) )
  if( _.countable.is( src ) && _.number.is( key ) )
  return _.countable._elementWithKeySet( dst, key, val );
  return _.props._elementWithKeySet( dst, key, val );
}

//

function _elementWithCardinalSet( dst, cardinal, val )
{
  if( _.countable.is( dst ) )
  return _.countable._elementWithCardinalSet( dst, cardinal, val );
  return _.props._elementWithCardinalSet( dst, cardinal, val );
}

//

function _elementWithKeyDel( dst, key )
{
  // if( _.number.is( key ) )
  if( _.countable.is( src ) && _.number.is( key ) )
  return _.countable._elementWithKeyDel( dst, key );
  return _.props._elementWithKeyDel( dst, key );
}

//

function _elementWithCardinalDel( dst, cardinal )
{
  if( _.countable.is( dst ) )
  return _.countable._elementWithCardinalDel( dst, cardinal );
  return _.props._elementWithCardinalDel( dst, cardinal );
}

//

function _empty( dst )
{
  if( _.countable.is( dst ) )
  return _.countable._empty( dst );
  return _.props._empty( dst );
}

// --
// iterator
// --

function _eachLeft( src, onEach )
{
  if( _.countable.is( src ) )
  return _.countable._eachLeft( src, onEach );
  return _.props._eachLeft( src, onEach );
}

//

function _eachRight( src, onEach )
{
  if( _.countable.is( src ) )
  return _.countable._eachRight( src, onEach );
  return _.props._eachRight( src, onEach );
}

//

function _whileLeft( src, onEach )
{
  if( _.countable.is( src ) )
  return _.countable._whileLeft( src, onEach );
  return _.props._whileLeft( src, onEach );
}

//

function _whileRight( src, onEach )
{
  if( _.countable.is( src ) )
  return _.countable._whileRight( src, onEach );
  return _.props._whileRight( src, onEach );
}

//

function _filterAct0( dst, src, ... args )
{
  if( _.countable.is( src ) )
  return _.countable._filterAct0( dst, src, ... args );
  return _.props._filterAct0( dst, src, ... args );
}

//

function _mapAct0( dst, src, ... args )
{
  if( _.countable.is( src ) )
  return _.countable._mapAct0( dst, src, ... args );
  return _.props._mapAct0( dst, src, ... args );
}

// --
// extension
// --

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

//

let ObjectExtension =
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

  _filterAct0,
  _filterAct : _.props._filterAct,
  filterWithoutEscapeLeft : _.props.filterWithoutEscapeLeft,
  filterWithoutEscapeRight : _.props.filterWithoutEscapeRight,
  filterWithoutEscape : _.props.filterWithoutEscape,
  filterWithEscapeLeft : _.props.filterWithEscapeLeft,
  filterWithEscapeRight : _.props.filterWithEscapeRight,
  filterWithEscape : _.props.filterWithEscape,
  filter : _.props.filter,

  _mapAct0,
  _mapAct : _.props._mapAct,
  mapWithoutEscapeLeft : _.props.mapWithoutEscapeLeft,
  mapWithoutEscapeRight : _.props.mapWithoutEscapeRight,
  mapWithoutEscape : _.props.mapWithoutEscape,
  mapWithEscapeLeft : _.props.mapWithEscapeLeft,
  mapWithEscapeRight : _.props.mapWithEscapeRight,
  mapWithEscape : _.props.mapWithEscape,
  map : _.props.map,

}

//

Object.assign( _.object, ObjectExtension );

})();

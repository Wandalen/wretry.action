( function _l3_HashMap_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// equaler
// --

function _identicalShallow( src1, src2 )
{

  if( src1.size !== src2.size )
  return false;

  for( let [ key, val ] of src1 )
  {
    if( src2.has( key ) === false )
    return false;

    let val2 = src2.get( key );

    // /*
    //   in cases of an undefined value, make sure the key
    //   exists on the object so there are no false positives
    // */
    // // if( testVal !== val || ( testVal === undefined && !src2.has( key ) ) )
    // // return false;

    if( !Object.is( val2, val ) )
    return false;

  }

  return true;
}

// --
// exporter
// --

function _exportStringDiagnosticShallow( src )
{
  return `{- ${_.entity.strType( src )} with ${_.entity.lengthOf( src )} elements -}`;
}

// --
// container interface
// --

function _lengthOf( src )
{
  return src.size;
}

//

function _hasKey( src, key )
{
  return src.has( key );
}

//

function _hasCardinal( src, cardinal )
{
  if( cardinal < 0 )
  return false;
  return cardinal < src.size;
}

//

function _keyWithCardinal( src, cardinal )
{
  if( cardinal < 0 || src.size <= cardinal )
  return [ undefined, false ];
  return [ this.keys[ cardinal ], true ];
}

//

function _cardinalWithKey( src, key )
{
  if( !src.has( key ) )
  return -1;
  let keys = this.keys( src );
  return keys.indexOf( key );
}

//

function _elementWithKey( src, key )
{
  if( src.has( key ) )
  return [ src.get( key ), key, true ];
  else
  return [ undefined, key, false ];
}

//

function _elementWithImplicit( src, key )
{
  if( _.props.keyIsImplicit( key ) )
  return _.props._onlyImplicitWithKeyTuple( src, key );
  return this._elementWithKey( src, key );
}

//

function _elementWithCardinal( src, cardinal )
{
  if( cardinal < 0 || src.size <= cardinal || !_.numberIs( cardinal ) )
  return [ undefined, cardinal, false ];
  let entry = [ ... src ][ cardinal ];
  return [ entry[ 1 ], entry[ 0 ], true ];
}

//

function _elementWithKeySet( dst, key, val )
{
  dst.set( key, val );
  return [ key, true ];
}

//

function _elementWithCardinalSet( dst, cardinal, val )
{
  let was = this._elementWithCardinal( dst, cardinal );
  if( was[ 2 ] === true )
  {
    dst.set( was[ 1 ], val );
    return [ was[ 1 ], true ];
  }
  else
  {
    return [ cardinal, false ];
  }
}

//

function _elementWithKeyDel( dst, key )
{
  if( !this._hasKey( dst, key ) )
  return false;
  dst.delete( key );
  return true;
}

//

function _elementWithCardinalDel( dst, cardinal )
{
  let has = this._keyWithCardinal( dst, cardinal );
  if( !has[ 1 ] )
  return false;
  dst.delete( has[ 0 ] );
  return true;
}

//

function _empty( dst )
{
  dst.clear();
  return dst;
}

//

function _eachLeft( src, onEach )
{
  let c = 0;
  for( let [ k, val ] of src )
  {
    onEach( val, k, c, src );
    c += 1;
  }
}

//

function _eachRight( src, onEach )
{
  let keys = [ ... src.keys() ];
  for( let c = keys.length-1 ; c >= 0 ; c-- )
  {
    let k = keys[ c ];
    let val = src.get( k );
    onEach( val, k, c, src );
  }
}

//

function _whileLeft( src, onEach )
{
  if( src.size === 0 )
  return [ undefined, undefined, -1, true ];
  let c = 0;
  let lastk;
  for( let [ k, val ] of src )
  {
    let r = onEach( val, k, c, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ val, k, c, false ];
    lastk = k;
    c += 1;
  }
  return [ src.get( lastk ), lastk, c-1, true ];
}

//

function _whileRight( src, onEach )
{
  if( src.size === 0 )
  return [ undefined, undefined, -1, true ];

  let keys = [ ... src.keys() ];
  for( let c = keys.length-1 ; c >= 0 ; c-- )
  {
    let k = keys[ c ];
    let val = src.get( k );
    let r = onEach( val, k, c, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ val, k, c, false ];
  }

  var k = keys[ 0 ];
  return [ src.get( k ), k, 0, true ];
}

// --
// extension
// --

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

//

let Extension =
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

Object.assign( _.hashMap, Extension );

})();

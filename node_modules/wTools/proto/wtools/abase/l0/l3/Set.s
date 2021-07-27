( function _l3_Set_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
//
// --

function toArray( src )
{
  _.assert( arguments.length === 1 );
  _.assert( _.set.like( src ) );
  return [ ... src ];
}

//

function setsToArrays( srcs )
{
  _.assert( arguments.length === 1 );
  _.assert( _.longIs( srcs ) );
  let result = [];
  for( let s = 0, l = srcs.length ; s < l ; s++ )
  result[ s ] = _.set.toArray( srcs[ s ] );
  return result;
}

// --
// exporter
// --

function _exportStringDiagnosticShallow( src, o )
{
  return `{- ${_.entity.strType( src )} with ${_.entity.lengthOf( src )} elements -}`;
}

// --
// equaler
// --

function _identicalShallow( src1, src2 )
{
  if( src1.size !== src2.size)
  return false;

  for( let el of src1 )
  if( !src2.has( el ) )
  return false;

  return true;
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
  return [ [ ... src ][ cardinal ], true ];
}

//

function _cardinalWithKey( src, key )
{
  return [ ... src ].indexOf( key );
}

//

function _elementWithKey( src, key )
{
  if( src.has( key ) )
  return [ key, key, true ];
  return [ undefined, key, false ];
}

//

function _elementWithCardinal( src, key )
{
  if( key < 0 || src.size <= key || !_.numberIs( key ) )
  if( src.size <= key || !_.number.is( key ) )
  return [ undefined, key, false ];
  return [ [ ... src ][ key ], key, true ];
}

//

function _elementWithKeySet( dst, key, val )
{
  // debugger;
  dst.add( val );
  return [ val, true ];
}

//

function _elementWithCardinalSet( dst, cardinal, val )
{
  let was = this._elementWithCardinal( dst, cardinal );
  if( was[ 2 ] === true )
  {
    dst.delete( was[ 0 ] );
    dst.add( val );
    return [ val, true ];
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
  for( let e of src )
  {
    onEach( e, e, c, src );
    c += 1;
  }
}

//

function _eachRight( src, onEach )
{
  let src2 = [ ... src ];
  for( let k = src2.length-1 ; k >= 0 ; k-- )
  {
    let e = src[ k ];
    onEach( e, e, k, src );
  }
}

//

function _whileLeft( src, onEach )
{
  if( src.size === 0 )
  return [ undefined, undefined, -1, true ];
  let c = 0;
  let laste;
  for( let e of src )
  {
    let r = onEach( e, e, c, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ e, e, c, false ];
    laste = e;
    c += 1;
  }
  return [ laste, laste, src.size-1, true ];
}

//

function _whileRight( src, onEach )
{
  if( src.size === 0 )
  return [ undefined, undefined, -1, true ];
  var src2 = [ ... src ];
  for( let k = src2.length-1 ; k >= 0 ; k-- )
  {
    var e = src2[ k ];
    let r = onEach( e, e, k, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ e, e, k, false ];
  }
  var e = src2[ 0 ];
  return [ e, e, 0, true ];
}

// --
// set extension
// --

let SetExtension =
{

  // from,
  toArray,

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

Object.assign( _.set, SetExtension );

// --
// sets extension
// --

let SetsExtension =
{

  // set

  // from : setsFrom,
  toArrays : setsToArrays,

}

Object.assign( _.sets, SetsExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  setToArray : toArray,
  setsToArrays,

}

Object.assign( _, ToolsExtension );

//

})();

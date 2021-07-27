( function _l3_Countable_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
//
// --

function _identicalShallow( src1, src2 )
{

  if( Object.prototype.toString.call( src1 ) !== Object.prototype.toString.call( src2 ) )
  return false;
  if( !_.countable.is( src1 ) )
  return false;
  if( !_.countable.is( src2 ) )
  return false;

  if( _.longIs( src1 ) )
  {
    return _.long.identicalShallow( src1, src2 );
  }
  else
  {
    /*
      entity with method iterator,
      entity with method iterator and length
    */

    let array1 = [ ... src1 ];
    for( let val of src2 )
    if( array1.indexOf( val ) === -1 )
    return false

    return true;
  }

}

//

function _equivalentShallow( src1, src2 )
{
  let result = true;

  if( _.longIs( src1 ) && _.longIs( src2 ) )
  {
    return _.long.equivalentShallow( src1, src2 );
  }
  else
  {
    /*
      entity with method iterator,
      entity with method iterator and length
    */

    /* don't create new array if one of arguments is array */
    if( _.argumentsArray.like( src1 ) )
    {
      result = check( src2, src1 );
    }
    else if( _.argumentsArray.like( src2 ) )
    {
      result = check( src1, src2 );
    }
    else
    {
      let array1 = [ ... src1 ];
      result = check( src2, array1 );
    }

    return result;
  }

  /* - */

  function check( arrayLoop, arrayCheck )
  {
    for( let val of arrayLoop )
    if( Array.prototype.indexOf.call( arrayCheck, val ) === -1 )
    return false
    return true;
  }
}

// --
// exporter
// --

function _exportStringDiagnosticShallow( src, o )
{
  if( _.unroll.is( src ) )
  return `{- ${_.entity.strType( src )}.unroll with ${this._lengthOf( src )} elements -}`;
  return `{- ${_.entity.strType( src )} with ${this._lengthOf( src )} elements -}`;
}

// --
// container interface
// --

function _lengthOf( src )
{
  if( _.vector.is( src ) )
  return src.length;
  return [ ... src ].length;
}

//

function _hasKey( src, key )
{
  if( key < 0 )
  return false;
  return key < this._lengthOf( src );
}

//

function _hasCardinal( src, cardinal )
{
  if( cardinal < 0 )
  return false;
  return cardinal < this._lengthOf( src );
}

//

function _keyWithCardinal( src, cardinal )
{
  if( cardinal < 0 || this._lengthOf( src ) <= cardinal )
  return [ undefined, false ];
  return [ cardinal, true ];
}

//

function _cardinalWithKey( src, key )
{
  if( key < 0 || this._lengthOf( src ) <= key )
  return -1;
  return key;
}

//

function _elementWithKey( src, key )
{

  if( _.long.is( src ) )
  return _.long._elementWithKey( ... arguments );

  if( _.number.is( key ) )
  {
    if( key < 0 )
    return [ undefined, key, false ];
    debugger;
    const src2 = [ ... src ];
    if( src2.length <= key )
    return [ undefined, key, false ];
    else
    return [ src2[ key ], key, true ];
  }
  else
  {
    return [ undefined, key, false ];
  }
}

//

function _elementWithCardinal( src, cardinal )
{

  if( _.long.is( src ) )
  return _.long._elementWithCardinal( ... arguments );

  if( !_.number.is( cardinal ) || cardinal < 0 )
  return [ undefined, cardinal, false ];
  const src2 = [ ... src ];
  if( src2.length <= cardinal )
  return [ undefined, cardinal, false ];
  else
  return [ src2[ cardinal ], cardinal, true ];
}

//

function _elementWithKeySet( dst, key, val )
{

  if( _.long.is( dst ) )
  return _.long._elementWithKeySet( ... arguments );

  if( !_.number.is( key ) || key < 0 )
  return [ key, false ];
  // const dst2 = [ ... dst ];
  // if( dst2.length <= key )
  // return [ key, false ];
  const length = this._lengthOf( dst );
  if( length <= key )
  return [ key, false ];

  let elementWithKeySet = _.class.methodElementWithKeySetOf( dst );
  if( elementWithKeySet )
  return elementWithKeySet.call( dst, key, val );

  let elementSet = _.class.methodElementSetOf( dst );
  if( elementSet )
  return [ elementSet.call( dst, key, val ), key, true ];

  _.assert( 0, 'Countable does not have implemented neither method "elementWithKeySet" nor method "eSet"' );
}

//

function _elementWithCardinalSet( dst, cardinal, val )
{

  if( _.long.is( dst ) )
  return _.long._elementWithCardinalSet( ... arguments );

  if( !_.number.is( cardinal ) || cardinal < 0 )
  return [ cardinal, false ];
  // const dst2 = [ ... dst ];
  // if( dst2.length <= cardinal )
  const length = this._lengthOf( dst );
  if( length <= cardinal )
  return [ cardinal, false ];

  let was = this._elementWithCardinal( dst, cardinal );
  if( was[ 2 ] )
  this._elementWithKeySet( dst, was[ 1 ], val );
  return [ cardinal, false ];
}

//

function _elementWithKeyDel( dst, key )
{
  if( _.array.is( dst ) )
  return _.array._elementWithKeyDel( dst, key );
  _.assert( 0, 'Countable does not have implemented method "_elementWithKeyDel"' );
}

//

function _elementWithCardinalDel( dst, cardinal )
{
  if( _.array.is( dst ) )
  return _.array._elementWithCardinalDel( dst, cardinal );
  _.assert( 0, 'Countable does not have implemented method "_elementWithCardinalDel"' );
}

//

function _empty( dst )
{
  if( _.array.is( dst ) )
  return _.array._empty( dst );
  _.assert( 0, 'Countable does not have implemented method "_empty"' );
}

//

function _elementAppend( dst, val )
{
  if( _.array.is( dst ) )
  {
    dst.push( val );
    return dst.length-1;
  }
  _.assert( 0, 'Countable does not have implemented method "_elementAppend"' );
}

//

function _elementPrepend( dst, val )
{
  if( _.array.is( dst ) )
  {
    dst.unshift( val );
    return 0;
  }
  _.assert( 0, 'Countable does not have implemented method "_elementPrepend"' );
}

//

function _eachLeft( src, onEach )
{
  let k = 0;
  for( let val of src )
  {
    onEach( val, k, k, src );
    k += 1;
  }
}

//

function _eachRight( src, onEach )
{
  let src2 = [ ... src ];
  for( let k = src2.length-1 ; k >= 0 ; k-- )
  {
    let val = src2[ k ];
    onEach( val, k, k, src );
  }
}

//

function _whileLeft( src, onEach )
{
  let k = 0;
  let laste;
  for( let val of src )
  {
    let r = onEach( val, k, k, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ val, k, false ];
    laste = val;
    k += 1;
  }
  if( k > 0 )
  return [ laste, k-1, k-1, true ];
  else
  return [ undefined, k-1, k-1, true ];
}

//

function _whileRight( src, onEach )
{
  let src2 = [ ... src ];
  for( let k = src2.length-1 ; k >= 0 ; k-- )
  {
    let val = src2[ k ];
    let r = onEach( val, k, k, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ val, k, k, false ];
  }
  if( src2.length > 0 )
  return [ src2[ 0 ], 0, 0, true ];
  else
  return [ undefined, -1, -1, true ];
}

//

function _filterAct()
{
  let self = this;
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];

  if( _.longIs( src ) )
  return _.long._filterAct( ... arguments );
  return _.props._filterAct.call( self, ... arguments );
}

//

function _mapAct()
{
  let self = this;
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];

  if( _.longIs( src ) )
  return _.long._mapAct( ... arguments );
  return _.props._mapAct.call( self, ... arguments );
}

// --
// extension
// --

var ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

//

var CountableExtension =
{

  // equaler

  _identicalShallow,
  identicalShallow : _.props.identicalShallow,
  identical : _.props.identical,
  _equivalentShallow,
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

  _elementAppend,
  elementAppend : _.long.elementAppend, /* qqq : cover */
  _elementPrepend,
  elementPrepend : _.long.elementPrepend, /* qqq : cover */

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

  // _filterAct0 : _.props._filterAct0,
  // _filterAct,
  // filterWithoutEscapeLeft : _.props.filterWithoutEscapeLeft,
  // filterWithoutEscapeRight : _.props.filterWithoutEscapeRight,
  // filterWithoutEscape : _.props.filterWithoutEscape,
  // filterWithEscapeLeft : _.props.filterWithEscapeLeft,
  // filterWithEscapeRight : _.props.filterWithEscapeRight,
  // filterWithEscape : _.props.filterWithEscape,
  // filter : _.props.filter,
  //
  // _mapAct0 : _.props._mapAct0,
  // _mapAct,
  // mapWithoutEscapeLeft : _.props.mapWithoutEscapeLeft,
  // mapWithoutEscapeRight : _.props.mapWithoutEscapeRight,
  // mapWithoutEscape : _.props.mapWithoutEscape,
  // mapWithEscapeLeft : _.props.mapWithEscapeLeft,
  // mapWithEscapeRight : _.props.mapWithEscapeRight,
  // mapWithEscape : _.props.mapWithEscape,
  // map : _.props.map,

}

Object.assign( _.countable, CountableExtension );

})();

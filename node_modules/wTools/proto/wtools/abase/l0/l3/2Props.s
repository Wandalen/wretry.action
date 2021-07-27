( function _l3_2Property_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const prototypeSymbol = Symbol.for( 'prototype' );
const constructorSymbol = Symbol.for( 'constructor' );

// --
// equaler
// --

function _identicalShallow( src1, src2 )
{
  if( this.keys( src1 ).length !== this.keys( src2 ).length )
  return false;

  for( let s in src1 )
  {
    if( src1[ s ] !== src2[ s ] )
    return false;
  }

  return true;
}

//

function identicalShallow( src1, src2, o )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( !this.like( src1 ) )
  return false;
  if( !this.like( src2 ) )
  return false;

  return this._identicalShallow( src1, src2 );
}

//

function _equivalentShallow( src1, src2 )
{
  if( this.keys( src1 ).length !== this.keys( src2 ).length )
  return false;

  for( let s in src1 )
  {
    if( src1[ s ] !== src2[ s ] )
    return false;
  }

  return true;
}

//

function equivalentShallow( src1, src2, o )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( !this.like( src1 ) )
  return false;
  if( !this.like( src2 ) )
  return false;

  return this._equivalentShallow( src1, src2 );
}

// --
// exporter
// --

function _exportStringDiagnosticShallow( src, o )
{
  return `{- ${_.entity.strType( src )} with ${this._lengthOf( src )} elements -}`;
}

//

function exportStringDiagnosticShallow( src, o )
{
  _.assert( this.like( src ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( o === undefined || _.object.isBasic( o ) );
  return this._exportStringDiagnosticShallow( ... arguments );
}

// --
// properties
// --

function keyIsImplicit( key )
{
  if( !_.props.implicit.is( key ) )
  return false;
  if( key.val === prototypeSymbol )
  return true;
  if( key.val === constructorSymbol ) /* xxx : try */
  return true;
  return false;
}

//

function _onlyImplicitWithKey( src, key )
{
  if( !_.props.implicit.is( key ) )
  return;
  if( key.val === prototypeSymbol )
  {
    if( src === undefined || src === null )
    return undefined;
    return Object.getPrototypeOf( src );
  }
  if( key.val === constructorSymbol ) /* xxx : try */
  {
    if( src === undefined || src === null )
    return undefined;
    let prototype = Object.getPrototypeOf( src );
    if( !prototype )
    return prototype;
    return prototype.constructor;
  }
}

//

function onlyImplicitWithKey( src, key )
{
  _.assert( this === _.props );
  _.assert( arguments.length === 2 );
  return this._onlyImplicitWithKey( src, key );
}

//

function _onlyImplicitWithKeyTuple( container, key )
{
  let r = _.props._onlyImplicitWithKey( container, key );
  return [ r, key, r !== undefined ];
  // return [ r, key.val, r !== undefined ];
}

//

function onlyImplicit( src )
{
  let result = new HashMap();

  _.assert( this === _.props );
  _.assert( arguments.length === 1 );

  if( src === undefined || src === null )
  return result;
  var prototype = Object.getPrototypeOf( src );
  if( prototype )
  result.set( _.props.implicit.prototype, prototype );

  return result;
}

// --
// inspector
// --

function _lengthOf( src )
{
  return this.keys( src ).length;
}

//

function lengthOf( src )
{
  _.assert( arguments.length === 1 );
  _.assert( this.like( src ) );
  return this._lengthOf( src );
}

//

function _hasKey( src, key )
{
  if( _.primitive.is( src ) )
  return false;
  if( !Reflect.has( src, key ) )
  return false;
  return true;
}

//

function hasKey( src, key )
{
  _.assert( this.like( src ) );
  return this._hasKey( src, key );
}

//

function _hasCardinal( src, cardinal )
{
  if( cardinal < 0 )
  return false;
  let length = this._lengthOf( src );
  return cardinal < length;
}

//

function hasCardinal( src, cardinal )
{
  _.assert( this.like( src ) );
  return this._hasCardinal( src, cardinal );
}

//

function _keyWithCardinal( src, cardinal )
{
  if( cardinal < 0 )
  return [ undefined, false ];
  let keys = this.keys( src );
  if( cardinal < keys.length )
  return [ keys[ cardinal ], true ];
  return [ undefined, false ];
}

//

function keyWithCardinal( src, cardinal )
{
  _.assert( this.like( src ) );
  return this._keyWithCardinal( src, cardinal );
}

//

function _cardinalWithKey( src, key )
{
  if( !( key in src ) )
  return -1;
  let keys = this.keys( src );
  return keys.indexOf( key );
}

//

function cardinalWithKey( src, key )
{
  _.assert( this.like( src ) );
  return this._cardinalWithKey( src, key );
}

// --
// elementor
// --

function _elementWithKey( src, key )
{
  if( _.strIs( key ) )
  {
    if( _.props.has( src, key ) )
    return [ src[ key ], key, true ];
    else
    return [ undefined, key, false ];
  }
  else
  {
    return [ undefined, key, false ];
  }
}

//

function elementWithKey( src, key )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( src ) );
  return this._elementWithKey( src, key );
}

//

function _elementWithImplicit( src, key )
{
  if( _.props.keyIsImplicit( key ) )
  return _.props._onlyImplicitWithKeyTuple( src, key );
  return this._elementWithKey( src, key );
}

//

function elementWithImplicit( src, key )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( src ) );
  return this._elementWithImplicit( src, key );
}

//

function _elementWithCardinal( src, cardinal )
{
  if( !_.numberIs( cardinal ) || cardinal < 0 )
  return [ undefined, cardinal, false ];
  let keys = this.keys( src );
  let key2 = keys[ cardinal ];
  if( keys.length <= cardinal )
  return [ undefined, cardinal, false ];
  return [ src[ key2 ], key2, true ];
}

//

function elementWithCardinal( src, cardinal )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( src ) );
  return this._elementWithCardinal( src, cardinal );
}

//

function _elementWithKeySet( dst, key, val )
{
  dst[ key ] = val;
  return [ key, true ];
}

//

function elementWithKeySet( dst, key, val )
{
  _.assert( arguments.length === 3 );
  _.assert( this.is( dst ) );
  return this._elementWithKeySet( dst, key, val );
}

//

function _elementWithCardinalSet( dst, cardinal, val )
{
  let was = this._elementWithCardinal( dst, cardinal );
  if( was[ 2 ] === true )
  {
    dst[ was[ 1 ] ] = val;
    return [ was[ 1 ], true ];
  }
  else
  {
    return [ cardinal, false ];
  }
}

//

function elementWithCardinalSet( dst, cardinal, val )
{
  _.assert( arguments.length === 3 );
  _.assert( this.is( dst ) );
  return this._elementWithCardinalSet( dst, cardinal, val );
}

//

function _elementWithKeyDel( dst, key )
{
  if( !this._hasKey( dst, key ) )
  return false;
  delete dst[ key ];
  return true;
}

//

function elementWithKeyDel( dst, key )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( dst ) );
  return this._elementWithKeyDel( dst, key );
}

//

function _elementWithCardinalDel( dst, cardinal )
{
  let has = this._keyWithCardinal( dst, cardinal );
  if( !has[ 1 ] )
  return false;
  delete dst[ has[ 0 ] ];
  return true;
}

//

function elementWithCardinalDel( dst, cardinal )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( dst ) );
  // return this._elementWithCardinalDel( dst, cardinal, val );
  return this._elementWithCardinalDel( dst, cardinal );
}

//

function _empty( dst )
{
  for( let k in dst )
  delete dst[ k ];
  return dst;
}

//

function empty( dst )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( this.like( dst ) );
  return this._empty( dst );
}

// --
// iterator
// --

function _eachLeft( src, onEach )
{
  let c = 0;
  for( let k in src )
  {
    let val = src[ k ];
    onEach( val, k, c, src );
    c += 1;
  }
}

//

function eachLeft( src, onEach )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( src ) );
  this._eachLeft( src, onEach );
}

//

function _eachRight( src, onEach )
{
  let keys = this.keys( src );
  for( let c = keys.length-1 ; c >= 0 ; c-- )
  {
    let k = keys[ c ];
    let val = src[ k ];
    onEach( val, k, c, src );
  }
}

//

function eachRight( src, onEach )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( src ) );
  this._eachRight( src, onEach );
}

//

function _whileLeft( src, onEach )
{
  let c = 0;
  let lastk;
  for( let k in src )
  {
    let val = src[ k ];
    let r = onEach( val, k, c, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ val, k, c, false ];
    lastk = k;
    c += 1;
  }
  if( c === 0 )
  return [ undefined, undefined, -1, true ];
  return [ src[ lastk ], lastk, c-1, true ];
}

//

function whileLeft( src, onEach )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( src ) );
  this._whileLeft( src, onEach );
}

//

function _whileRight( src, onEach )
{
  let keys = this.keys( src );
  if( keys.length === 0 )
  return [ undefined, undefined, -1, true ];
  for( let c = keys.length-1 ; c >= 0 ; c-- )
  {
    let k = keys[ c ];
    let val = src[ k ];
    let r = onEach( val, k, c, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ val, k, c, false ];
  }

  var k = keys[ 0 ];
  return [ src[ k ], k, 0, true ];
}

//

function whileRight( src, onEach )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( src ) );
  this._whileRight( src, onEach );
}

//

function _aptLeft( src, onEach )
{
  let result, result2;

  if( onEach )
  result2 = this._whileLeft( src, function( val, k, c, src2 )
  {
    let r = onEach( ... arguments );
    if( r !== undefined )
    {
      result = [ r, k, c, true ];
      return false;
    }
    return true;
  });
  else
  result2 = this._whileLeft( src, function( val, k, c, src2 )
  {
    result = [ val, k, c, true ];
    return false;
  });

  if( result === undefined )
  {
    result2[ 3 ] = false;
    return result2;
  }

  return result;
}

//

function aptLeft( src, onEach )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( this.is( src ) );
  return this._aptLeft( src, onEach );
}

//

function _aptRight( src, onEach )
{
  let result, result2;

  if( onEach )
  result2 = this._whileRight( src, function( val, k, c, src2 )
  {
    let r = onEach( ... arguments );
    if( r !== undefined )
    {
      result = [ r, k, c, true ];
      return false;
    }
    return true;
  });
  else
  result2 = this._whileRight( src, function( val, k, c, src2 )
  {
    result = [ val, k, c, true ];
    return false;
  });

  if( result === undefined )
  {
    result2[ 3 ] = false;
    return result2;
  }

  return result;
}

//

function aptRight( src, onEach )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( this.is( src ) );
  return this._aptRight( src, onEach );
}

//

function _filterAct0()
{
  const self = this;
  const dst = arguments[ 0 ];
  const src = arguments[ 1 ];
  const onEach = arguments[ 2 ];
  const each = arguments[ 3 ];
  const escape = arguments[ 4 ];

  if( dst === src )
  each( src, function( val, k, c, src2 )
  {
    let val2 = onEach( val, k, c, src2, dst );
    let val3 = escape( val2 );
    if( val2 === undefined )
    self._elementDel( dst, k );
    else if( val3 === val )
    return
    else
    self._elementSet( dst, k, val3 );
  });
  else
  each( src, function( val, k, c, src2 )
  {
    let val2 = onEach( val, k, c, src2, dst );
    let val3 = escape( val2 );
    if( val2 === undefined )
    return;
    self._elementSet( dst, k, val3 );
  });

  return dst;
}

//

function _filterAct()
{
  let self = this;
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];
  let onEach = arguments[ 2 ];
  let isLeft = arguments[ 3 ];
  let eachRoutineName = arguments[ 4 ];
  let escape = arguments[ 5 ];
  let general = this.tools[ this.MostGeneralNamespaceName ];

  if( dst === null )
  dst = this.makeUndefined( src );
  else if( dst === _.self )
  dst = src;

  if( Config.debug )
  {
    _.assert( arguments.length === 6, `Expects 3 arguments` );
    _.assert( this.is( dst ), () => `dst is not ${this.TypeName}` );
    _.assert( general.is( src ), () => `src is not ${general.TypeName}` );
    _.assert( _.routineIs( onEach ), () => 'onEach is not a routine' )
  }

  this._filterAct0( dst, src, onEach, general[ eachRoutineName ].bind( general ), escape );

  return dst;
}

//

function filterWithoutEscapeLeft( dst, src, onEach )
{
  return this._filterAct( ... arguments, true, 'eachLeft', ( val ) => val );
}

//

function filterWithoutEscapeRight( dst, src, onEach )
{
  return this._filterAct( ... arguments, false, 'eachRight', ( val ) => val );
}

//

function filterWithEscapeLeft( dst, src, onEach )
{
  return this._filterAct( ... arguments, true, 'eachLeft', ( val ) => _.escape.right( val ) );
}

//

function filterWithEscapeRight( dst, src, onEach )
{
  return this._filterAct( ... arguments, false, 'eachRight', ( val ) => _.escape.right( val ) );
}

//

function _mapAct0()
{
  const self = this;
  const dst = arguments[ 0 ];
  const src = arguments[ 1 ];
  const onEach = arguments[ 2 ];
  const each = arguments[ 3 ];
  const escape = arguments[ 4 ];

  if( dst === src )
  each( src, function( val, k, c, src2 )
  {
    let val2 = onEach( val, k, c, src2, dst );
    let val3 = escape( val2 );
    if( val3 === val || val2 === undefined )
    return;
    self._elementSet( dst, k, val3 );
  });
  else
  each( src, function( val, k, c, src2 )
  {
    let val2 = onEach( val, k, c, src2, dst );
    let val3 = escape( val2 );
    if( val2 === undefined )
    self._elementSet( dst, k, val );
    else
    self._elementSet( dst, k, val3 );
  });

  return dst;
}

//

function _mapAct()
{
  let self = this;
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];
  let onEach = arguments[ 2 ];
  let isLeft = arguments[ 3 ];
  let eachRoutineName = arguments[ 4 ];
  let escape = arguments[ 5 ];
  let general = this.tools[ this.MostGeneralNamespaceName ];

  if( dst === null )
  {
    // dst = this.makeUndefined( src );
    let dstNamespace = self.namespaceOf( src ) || self.default || self;
    dst = dstNamespace.makeUndefined( src );
  }
  else if( dst === _.self )
  {
    dst = src;
  }

  if( Config.debug )
  {
    _.assert( arguments.length === 6, `Expects 3 arguments` );
    _.assert( this.is( dst ), () => `dst is not ${this.TypeName}` );
    _.assert( general.is( src ), () => `src is not ${general.TypeName}` );
    _.assert( _.routineIs( onEach ), () => `onEach is not a routine` );
  }

  this._mapAct0( dst, src, onEach, general[ eachRoutineName ].bind( general ), escape );

  return dst;
}

//

function mapWithoutEscapeLeft( dst, src, onEach )
{
  return this._mapAct( ... arguments, true, 'eachLeft', ( val ) => val );
}

//

function mapWithoutEscapeRight( dst, src, onEach )
{
  return this._mapAct( ... arguments, false, 'eachRight', ( val ) => val );
}

//

function mapWithEscapeLeft( dst, src, onEach )
{
  return this._mapAct( ... arguments, true, 'eachLeft', ( val ) => _.escape.right( val ) );
}

//

function mapWithEscapeRight( dst, src, onEach )
{
  return this._mapAct( ... arguments, false, 'eachRight', ( val ) => _.escape.right( val ) );
}

// --
// property implicit
// --

_.assert( _.props.implicit === undefined );
_.assert( _.props.Implicit === undefined );
_.props.implicit = _.wrap.declare({ name : 'Implicit' }).namespace;
_.props.Implicit = _.props.implicit.class;
_.assert( _.mapIs( _.props.implicit ) );
_.assert( _.routineIs( _.props.Implicit ) );

_.props.implicit.prototype = new _.props.Implicit( prototypeSymbol );
_.props.implicit.constructor = new _.props.Implicit( constructorSymbol );

// --
// extension
// --

let Extension =
{

  // equaler

  _identicalShallow,
  identicalShallow,
  identical : identicalShallow,
  _equivalentShallow,
  equivalentShallow,
  equivalent : equivalentShallow,

  // exporter

  _exportStringDiagnosticShallow,
  exportStringDiagnosticShallow,
  _exportStringCodeShallow : _exportStringDiagnosticShallow,
  exportStringCodeShallow : exportStringDiagnosticShallow,
  exportString : exportStringDiagnosticShallow,

  // properties

  keyIsImplicit, /* qqq : cover */
  _onlyImplicitWithKey,
  onlyImplicitWithKey, /* qqq : cover */
  _onlyImplicitWithKeyTuple,
  onlyImplicit,

  // inspector

  _lengthOf,
  lengthOf, /* qqq : cover */
  _hasKey,
  hasKey, /* qqq : cover */
  _hasCardinal,
  hasCardinal, /* qqq : cover */
  _keyWithCardinal,
  keyWithCardinal, /* qqq : cover */
  _cardinalWithKey,
  cardinalWithKey, /* qqq : cover */

  // elementor

  _elementGet : _elementWithKey,
  elementGet : elementWithKey, /* qqq : cover */
  _elementWithKey,
  elementWithKey, /* qqq : cover */
  _elementWithImplicit,
  elementWithImplicit,  /* qqq : cover */
  _elementWithCardinal,
  elementWithCardinal,  /* qqq : cover */

  _elementSet : _elementWithKeySet,
  elementSet : elementWithKeySet, /* qqq : cover */
  _elementWithKeySet,
  elementWithKeySet, /* qqq : cover */
  _elementWithCardinalSet,
  elementWithCardinalSet,  /* qqq : cover */

  _elementDel : _elementWithKeyDel,
  elementDel : elementWithKeyDel, /* qqq : cover */
  _elementWithKeyDel,
  elementWithKeyDel, /* qqq : cover */
  _elementWithCardinalDel,
  elementWithCardinalDel,  /* qqq : cover */
  _empty,
  empty, /* qqq : for junior : cover */

  // iterator

  _each : _eachLeft,
  each : eachLeft, /* qqq : cover */
  _eachLeft,
  eachLeft, /* qqq : cover */
  _eachRight,
  eachRight, /* qqq : cover */

  _while : _whileLeft,
  while : whileLeft, /* qqq : cover */
  _whileLeft,
  whileLeft, /* qqq : cover */
  _whileRight,
  whileRight, /* qqq : cover */

  _aptLeft,
  aptLeft, /* qqq : cover */
  first : aptLeft,
  _aptRight, /* qqq : cover */
  aptRight,
  last : aptRight, /* qqq : cover */

  _filterAct0,
  _filterAct,
  filterWithoutEscapeLeft,
  filterWithoutEscapeRight,
  filterWithoutEscape : filterWithoutEscapeLeft,
  filterWithEscapeLeft,
  filterWithEscapeRight,
  filterWithEscape : filterWithEscapeLeft,
  filter : filterWithoutEscapeLeft,

  _mapAct0,
  _mapAct,
  mapWithoutEscapeLeft,
  mapWithoutEscapeRight,
  mapWithoutEscape : mapWithoutEscapeLeft,
  mapWithEscapeLeft,
  mapWithEscapeRight,
  mapWithEscape : mapWithEscapeLeft,
  map : mapWithoutEscapeLeft,

}

//

Object.assign( _.props, Extension );

})();

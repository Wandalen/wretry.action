( function _l3_Long_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const _functor_functor = _.container._functor_functor;

_.long = _.long || Object.create( null );

// --
//
// --

function appender( src )
{
  _.assert( _.longLike( src ) );

  if( 'append' in src && _.routine.is( src.append ) )
  return appendWithAppend;
  else if( 'push' in src && _.routine.is( src.push ) )
  return appendWithPush;
  else if( 'add' in src && _.routine.is( src.add ) )
  return appendWithAdd;

  function appendWithAppend( val )
  {
    src.append( val );
  }

  function appendWithPush( val )
  {
    src.push( val );
  }

  function appendWithAdd( val )
  {
    src.add( val );
  }

}

//

function prepender( src )
{
  _.assert( _.longLike( src ) );

  if( 'prepend' in src && _.routine.is( src.prepend ) )
  return prependWithAppend;
  else if( 'push' in src && _.routine.is( src.push ) )
  return prependWithPush;
  else if( 'add' in src && _.routine.is( src.add ) )
  return prependWithAdd;

  function prependWithAppend( val )
  {
    src.prepend( val );
  }

  function prependWithPush( val )
  {
    src.unshift( val );
  }

  function prependWithAdd( val )
  {
    src.add( val );
  }

}

//

function eacher( src )
{

  _.assert( _.longLike( src ) );

  if( _.class.methodIteratorOf( src ) )
  return eachOf;
  else
  return eachLength;

  /* */

  function eachOf( onEach )
  {
    let k = 0;
    for( let val of src )
    {
      onEach( val, k, src );
      k += 1;
    }
    return k;
  }

  /* */

  function eachLength( onEach )
  {
    let k = 0;
    while( k < src.length )
    {
      let val = src[ k ];
      args2[ 0 ] = val;
      onEach( val, k, src );
      k += 1;
    }
    return k;
  }

  /* */

}

// --
// equaler
// --

/**
 * The long.identicalShallow() routine checks the equality of two arrays.
 *
 * @param { longLike } src1 - The first array.
 * @param { longLike } src2 - The second array.
 *
 * @example
 * _.long.identicalShallow( [ 1, 2, 3 ], [ 1, 2, 3 ] );
 * // returns true
 *
 * @returns { Boolean } - Returns true if all values of the two arrays are equal. Otherwise, returns false.
 * @function long.identicalShallow
 * @throws { Error } Will throw an Error if (arguments.length) is less or more than two.
 * @namespace Tools
 */

//

function _identicalShallow( src1, src2 )
{
  let result = true;

  if( src1.length !== src2.length )
  return false;

  for( let s = 0 ; s < src1.length ; s++ )
  {
    result = src1[ s ] === src2[ s ];
    if( result === false )
    return false;
  }

  return result;
}

// --
// exporter
// --

function _exportStringDiagnosticShallow( src )
{
  if( _.unroll.is( src ) )
  return `{- ${_.entity.strType( src )}.unroll with ${this._lengthOf( src )} elements -}`;
  return `{- ${_.entity.strType( src )} with ${this._lengthOf( src )} elements -}`;
}

// --
// inspector
// --

function _lengthOf( src )
{
  return src.length;
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
  if( key < 0 )
  return false;
  return key < src.length;
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
  return cardinal < src.length;
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
  if( cardinal < 0 || src.length <= cardinal )
  return [ undefined, false ];
  return [ cardinal, true ]
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
  if( key < 0 || src.length <= key )
  return -1;
  return key;
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
  if( key < 0 || src.length <= key || !_.numberIs( key ) )
  return [ undefined, key, false ];
  else
  return [ src[ key ], key, true ];
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
  if( cardinal < 0 || src.length <= cardinal || !_.numberIs( cardinal ) )
  return [ undefined, cardinal, false ];
  else
  return [ src[ cardinal ], cardinal, true ];
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
  if( _.long.isResizable( dst ) )
  {
    if( key < 0 || !_.numberIs( key ) )
    return [ key, false ];
  }
  else
  {
    if( key < 0 || dst.length <= key || !_.numberIs( key ) )
    return [ key, false ];
  }
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
  if( cardinal < 0 || dst.length <= cardinal || !_.numberIs( cardinal ) )
  return [ cardinal, false ];
  dst[ cardinal ] = val;
  return [ cardinal, true ];
}

//

function elementWithCardinalSet( dst, cardinal, val )
{
  _.assert( arguments.length === 3 );
  _.assert( this.is( dst ) );
  return this._elementWithCardinalSet( dst, cardinal, val );
}

// --
// container interface
// --

function _elementAppend( dst, val )
{
  dst.push( val );
  return dst.length-1;
}

//

function elementAppend( dst, val )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( dst ) );
  _.assert( this.isResizable( dst ) );
  return this._elementAppend( dst, val );
}

//

function _elementPrepend( dst, val )
{
  dst.unshift( val );
  return 0;
}

//

function elementPrepend( dst, val )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( dst ) );
  _.assert( this.isResizable( dst ) );
  return this._elementPrepend( dst, val );
}

//

function _elementWithKeyDel( dst, key )
{
  if( !this._hasKey( dst, key ) )
  return false;
  dst.splice( key, 1 );
  return true;
}

//

function elementWithKeyDel( dst, key )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( dst ) );
  _.assert( this.isResizable( dst ) );
  return this._elementWithKeyDel( dst, key );
}

//

function _elementWithCardinalDel( dst, cardinal )
{
  if( !this._hasKey( dst, cardinal ) )
  return false;
  dst.splice( cardinal, 1 );
  return true;
}

//

function elementWithCardinalDel( dst, cardinal )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( dst ) );
  _.assert( this.isResizable( dst ) );
  return this._elementWithCardinalDel( dst, cardinal, val );
}

//

function _empty( dst )
{
  dst.splice( 0, dst.length );
  return dst;
}

//

function empty( dst )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( this.like( dst ) );
  _.assert( this.isResizable( dst ) );
  return this._empty( dst );
}

// --
// iterator
// --

function _eachLeft( src, onEach )
{
  for( let k = 0 ; k < src.length ; k++ )
  {
    onEach( src[ k ], k, k, src );
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
  for( let k = src.length-1 ; k >= 0 ; k-- )
  {
    onEach( src[ k ], k, k, src );
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
  for( let k = 0 ; k < src.length ; k++ )
  {
    let r = onEach( src[ k ], k, k, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ src[ k ], k, k, false ];
  }
  let k = src.length-1;
  if( src.length > 0 )
  return [ src[ k ], k, k, true ];
  else
  return [ undefined, k, k, true ];
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
  for( let k = src.length-1 ; k >= 0 ; k-- )
  {
    let r = onEach( src[ k ], k, k, src );
    _.assert( r === true || r === false );
    if( r === false )
    return [ src[ k ], k, k, false ];
  }
  if( src.length > 0 )
  return [ src[ 0 ], 0, 0, true ];
  else
  return [ undefined, -1, -1, true ];
}

//

function whileRight( src, onEach )
{
  _.assert( arguments.length === 2 );
  _.assert( this.is( src ) );
  this._whileRight( src, onEach );
}

//

function _filterAct( ... args )
{
  const self = this;
  let dst = arguments[ 0 ];
  const src = arguments[ 1 ];
  const onEach = arguments[ 2 ];
  const isLeft = arguments[ 3 ];
  const eachRoutineName = arguments[ 4 ];
  const escape = arguments[ 5 ];
  const srcNamesapce = this.tools[ this.MostGeneralNamespaceName ].namespaceOf( src );
  let dstNamespace;
  const each = srcNamesapce[ eachRoutineName ];
  let isSelf;
  let dstIsResizable;
  let srcSample = null;

  if( dst === null )
  {
    dstNamespace = self.namespaceOf( src ) || self.default || self;
    isSelf = false;
    if( dstNamespace.IsResizable() )
    {
      if( dstNamespace.is( src ) && !_.countable.isResizable( src ) )
      {
        srcSample = src;
        dstIsResizable = false;
      }
      else
      {
        dst = dstNamespace.makeEmpty( src );
        dstIsResizable = true;
      }
    }
    else
    {
      dstIsResizable = false;
    }
  }
  else if( dst === _.self )
  {
    isSelf = true;
    dst = src;
    dstNamespace = self.namespaceWithDefaultOf( dst );
    dstIsResizable = _.countable.isResizable( dst );
  }
  else
  {
    dstNamespace = self.namespaceWithDefaultOf( dst );
    dstIsResizable = _.countable.isResizable( dst );
    isSelf = dst === src;
    if( dstIsResizable )
    if( !isSelf )
    dstNamespace._empty( dst );
  }

  if( Config.debug )
  verify();

  if( dstIsResizable )
  {

    if( isSelf )
    {
      if( isLeft )
      resizableSelfLeft();
      else
      resizableSelfRight();
    }
    else
    {
      resizableNonEq();
    }

  }
  else
  {

    if( dst === null )
    nonResizableNull()
    else
    nonResizableNonNull();

  }

  return dst;

  function resizableSelfLeft()
  {
    let l = dstNamespace._lengthOf( src );
    for( let k = 0 ; k < l ; k++ )
    {
      let val = src[ k ];
      let val2 = onEach( val, k, k, src, dst );
      if( val2 === undefined )
      {
        dstNamespace._elementDel( dst, k );
        k -= 1;
        l -= 1;
        continue;
      }
      let val3 = escape( val2 );
      if( val3 === val )
      continue;
      dstNamespace._elementSet( dst, k, val3 );
    }
  }

  function resizableSelfRight()
  {
    each.call( srcNamesapce, src, function( val, k, c, src2 )
    {
      let val2 = onEach( val, k, c, src2, dst );
      let val3 = escape( val2 );
      if( val2 === undefined )
      dstNamespace._elementDel( dst, k );
      else if( val3 === val )
      return;
      else
      dstNamespace._elementSet( dst, k, val3 );
    });
  }

  function resizableNonEq()
  {
    const append = isLeft ? dstNamespace._elementAppend : dstNamespace._elementPrepend;
    each.call( srcNamesapce, src, function( val, k, c, src2 )
    {
      let val2 = onEach( val, k, c, src2, dst );
      let val3 = escape( val2 );
      if( val2 === undefined )
      return;
      append.call( dstNamespace, dst, val3 );
    });
  }

  function nonResizableNull()
  {
    let dst2 = [];
    if( isLeft )
    each.call( srcNamesapce, src, function( val, k, c, src2 )
    {
      let val2 = onEach( val, k, c, src2, dst2 );
      let val3 = escape( val2 );
      if( val2 === undefined )
      return;
      dst2.push( val3 );
    });
    else
    each.call( srcNamesapce, src, function( val, k, c, src2 )
    {
      let val2 = onEach( val, k, c, src2, dst2 );
      let val3 = escape( val2 );
      if( val2 === undefined )
      return;
      dst2.unshift( val3 );
    });
    dst = dstNamespace.make( srcSample, dst2 );
  }

  function nonResizableNonNull()
  {
    each.call( srcNamesapce, src, function( val, k, c, src2 )
    {
      let val2 = onEach( val, k, c, src2, dst );
      let val3 = escape( val2 );
      if( val2 === undefined )
      return;
      dstNamespace._elementSet( dst, k, val3 );
    });
  }

  function verify()
  {
    _.assert( args.length === 6, `Expects 3 arguments` );
    _.assert( dst === null || self.is( dst ), () => `dst is not ${self.TypeName}` );
    _.assert( srcNamesapce.is( src ), () => `src is not ${srcNamesapce.TypeName}` );
    _.assert( _.routineIs( onEach ), () => `onEach is not a routine` );
    _.assert
    (
      dst === null || _.countable.isResizable( dst ) || self._lengthOf( dst ) === srcNamesapce._lengthOf( src )
      , () => `dst is ${self.TypeName} and lengthOf( dst ) is ${self._lengthOf( dst )}, but lengthOf( src ) is ${self._lengthOf( src )}`
    );
  }

}

//

function _mapAct( ... args )
{
  const self = this;
  let dst = arguments[ 0 ];
  const src = arguments[ 1 ];
  const onEach = arguments[ 2 ];
  const isLeft = arguments[ 3 ];
  const eachRoutineName = arguments[ 4 ];
  const escape = arguments[ 5 ];
  const srcNamesapce = this.tools[ this.MostGeneralNamespaceName ].namespaceOf( src );
  const each = srcNamesapce[ eachRoutineName ];
  let isSelf;
  let dstIsResizable;
  let dstNamespace;

  if( dst === null )
  {
    isSelf = false;
    dstNamespace = self.namespaceOf( src ) || self.default || self;
    dst = dstNamespace.makeUndefined( src );
    dstIsResizable = self.IsResizable();
  }
  else if( dst === _.self )
  {
    isSelf = true;
    dst = src;
    dstNamespace = self.namespaceWithDefaultOf( dst );
    dstIsResizable = _.countable.isResizable( dst );
  }
  else
  {
    dstNamespace = self.namespaceWithDefaultOf( dst );
    dstIsResizable = _.countable.isResizable( dst );
    isSelf = dst === src;
    if( dstIsResizable )
    if( !isSelf )
    dst.length = srcNamesapce._lengthOf( src );
  }

  // const dstNamespace = self.namespaceWithDefaultOf( dst );

  if( Config.debug )
  verify();

  if( dst === src )
  each.call( srcNamesapce, src, function( val, k, c, src2 )
  {
    let val2 = onEach( val, k, c, src2, dst );
    let val3 = escape( val2 );
    if( val3 === val || val2 === undefined )
    return;
    self._elementSet( dst, k, val3 );
  });
  else
  each.call( srcNamesapce, src, function( val, k, c, src2 )
  {
    let val2 = onEach( val, k, c, src2, dst );
    let val3 = escape( val2 );
    if( val2 === undefined )
    self._elementSet( dst, k, val );
    else
    self._elementSet( dst, k, val3 );
  });

  return dst;

  function verify()
  {
    _.assert( args.length === 6, `Expects 3 arguments` );
    _.assert( dst === null || self.is( dst ), () => `dst is not ${self.TypeName}` );
    _.assert( srcNamesapce.is( src ), () => `src is not ${srcNamesapce.TypeName}` );
    _.assert( _.routineIs( onEach ), () => `onEach is not a routine` );
    _.assert
    (
      dst === null || _.countable.isResizable( dst ) || self._lengthOf( dst ) === srcNamesapce._lengthOf( src )
      , () => `dst is ${self.TypeName} and lengthOf( dst ) is ${self._lengthOf( dst )}, but lengthOf( src ) is ${self._lengthOf( src )}`
    );
  }

}

// --
// declare
// --

let ToolsExtension =
{

}

Object.assign( _, ToolsExtension );

//

let LongExtension =
{

  // er

  /* qqq : ask */
  /* xxx : evolve */
  appender,
  prepender,
  eacher,

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

  _elementAppend,
  elementAppend, /* qqq : cover */
  _elementPrepend,
  elementPrepend, /* qqq : cover */

  _elementWithKeyDel,
  elementWithKeyDel, /* qqq : cover */
  _elementWithCardinalDel,
  elementWithCardinalDel,  /* qqq : cover */
  _elementDel : _elementWithKeyDel,
  elementDel : _elementWithKeyDel, /* qqq : cover */
  _empty,
  empty,  /* qqq : cover */

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

  _aptLeft : _.props._aptLeft,
  aptLeft : _.props.aptLeft, /* qqq : cover */
  first : _.props.first,
  _aptRight : _.props._aptRight, /* qqq : cover */
  aptRight : _.props.aptRight,
  last : _.props.last, /* qqq : cover */

  _filterAct,
  filterWithoutEscapeLeft : _.props.filterWithoutEscapeLeft,
  filterWithoutEscapeRight : _.props.filterWithoutEscapeRight,
  filterWithoutEscape : _.props.filterWithoutEscape,
  filterWithEscapeLeft : _.props.filterWithEscapeLeft,
  filterWithEscapeRight : _.props.filterWithEscapeRight,
  filterWithEscape : _.props.filterWithEscape,
  filter : _.props.filter,

  _mapAct,
  mapWithoutEscapeLeft : _.props.mapWithoutEscapeLeft,
  mapWithoutEscapeRight : _.props.mapWithoutEscapeRight,
  mapWithoutEscape : _.props.mapWithoutEscape,
  mapWithEscapeLeft : _.props.mapWithEscapeLeft,
  mapWithEscapeRight : _.props.mapWithEscapeRight,
  mapWithEscape : _.props.mapWithEscape,
  map : _.props.map,

}

//

Object.assign( _.long, LongExtension );

})();

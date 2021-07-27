( function _l1_Class_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.class = _.class || Object.create( null );

// --
// container
// --

function methodIteratorOf( src )
{
  if( !src )
  return;
  if( _.routine.like( src[ iteratorSymbol ] ) )
  return src[ iteratorSymbol ];
  return;
}

//

/* qqq : for junior : cover */
function methodEqualOf( src )
{
  if( !src )
  return;
  if( _.routine.is( src[ equalAreSymbol ] ) )
  return src[ equalAreSymbol ];
  if( _.routine.is( src.equalAre ) )
  return src.equalAre;
  return;
}

//

/* qqq : for junior : cover */
function methodExportStringOf( src )
{
  if( !src )
  return;
  if( _.routine.is( src[ exportStringSymbol ] ) )
  return src[ exportStringSymbol ];
  if( _.routine.is( src.exportString ) )
  return src.exportString;
  return;
}

//

function methodAscendOf( src )
{
  if( !src )
  return;
  if( _.routine.is( src[ ascendSymbol ] ) )
  return src[ ascendSymbol ];
  if( _.routine.is( src.ascend ) )
  return src.ascend;
  return;
}

//

/* qqq : for junior : cover */
function methodCloneShallowOf( src )
{
  if( !src )
  return;
  if( _.routine.is( src[ cloneShallowSymbol ] ) )
  return src[ cloneShallowSymbol ];
  if( _.routine.is( src.cloneShallow ) )
  return src.cloneShallow;
  return
}

//

/* qqq : for junior : cover */
function methodCloneDeepOf( src )
{
  if( !src )
  return;
  if( _.routine.is( src[ cloneDeepSymbol ] ) )
  return src[ cloneDeepSymbol ];
  if( _.routine.is( src.cloneDeep ) )
  return src.cloneDeep;
  return
}

//

function methodElementWithKeySetOf( src )
{
  if( !src )
  return;
  if( _.routine.is( src[ elementWithKeySetSymbol ] ) )
  return src[ elementWithKeySetSymbol ];
  return;
}

//

function methodElementSetOf( src )
{
  if( !src )
  return;
  if( _.routine.is( src[ elementSetSymbol ] ) )
  return src[ elementSetSymbol ];
  if( _.routine.is( src.eSet ) )
  return src.eSet;
  return;
}

//

function methodMakeEmptyOf( src )
{
  if( _.routine.is( src.makeEmpty ) )
  return src.makeEmpty;
  if( _.routine.is( src.MakeEmpty ) )
  return src.MakeEmpty;
  return;
}

//

function methodMakeUndefinedOf( src )
{
  if( _.routine.is( src.makeUndefined ) )
  return src.makeUndefined;
  if( _.routine.is( src.MakeUndefined ) )
  return src.MakeUndefined;
  return;
}

//

function declareBasic( o )
{

  for( let e in o )
  {
    if( declareBasic.defaults[ e ] === undefined )
    {
      throw Error( `Unknown option::${e}` );
    }
  }

  for( let e in declareBasic.defaults )
  {
    if( o[ e ] === undefined )
    o[ e ] = declareBasic.defaults[ e ];
  }

  _.assert( routineIs( o.constructor ) && o.constructor !== Object.constructor && o.constructor !== Object );
  _.assert( strDefined( o.constructor.name ) && o.constructor.name !== 'Object' );
  _.assert( arguments.length === 1 );
  _.assert( o.iterate === undefined );

  o.exportString = o.exportString || exportString;
  o.cloneShallow = o.cloneShallow || cloneShallow;
  o.cloneDeep = o.cloneDeep || o.cloneShallow;
  o.equalAre = o.equalAre || equalAre;

  // debugger;
  // Object.setPrototypeOf( o.constructor.prototype, null );
  o.constructor.prototype = Object.create( o.prototype );
  if( o.iterator )
  o.constructor.prototype[ iteratorSymbol ] = o.iterator;
  o.constructor.prototype[ exportPrimitiveSymbol ] = exportStringIgnoringArgs;
  o.constructor.prototype[ exportStringNjsSymbol ] = exportStringIgnoringArgs;
  o.constructor.prototype[ exportStringSymbol ] = o.exportString;
  o.constructor.prototype[ cloneShallowSymbol ] = o.cloneShallow; /* xxx : reimplement? */
  o.constructor.prototype[ cloneDeepSymbol ] = o.cloneDeep; /* xxx : implement */
  o.constructor.prototype[ equalAreSymbol ] = o.equalAre; /* qqq : cover */
  o.constructor.prototype.constructor = o.constructor;

  Object.defineProperty( o.constructor.prototype, exportTypeNameGetterSymbol,
  {
    enumerable : false,
    configurable : false,
    get : TypeNameGet,
  });

  /* - */

  function TypeNameGet()
  {
    return this.constructor.name;
  }

  /* - */

  function cloneShallow()
  {
    _.assert( !( this instanceof cloneShallow ) );
    return this;
  }

  /* - */

  function equalAre( it )
  {
    let self = this;
    _.assert( arguments.length === 1 );
    debugger;
    if( it.src !== it.src2 )
    return it.stop( false );
  }

  /* - */

  function exportString()
  {
    return `{- ${this.constructor.name} -}`;
  }

  /* - */

  function exportStringIgnoringArgs()
  {
    return this[ exportStringSymbol ]();
  }

  /* - */

  function strDefined( src )
  {
    if( !src )
    return;
    let result = Object.prototype.toString.call( src ) === '[object String]';
    return result;
  }

  /* - */

  function routineIs( src )
  {
    let typeStr = Object.prototype.toString.call( src );
    return typeStr === '[object Function]' || typeStr === '[object AsyncFunction]';
  }

  /* - */

}

declareBasic.defaults =
{
  constructor : null,
  prototype : null,
  parent : null,
  exportString : null,
  cloneShallow : null,
  cloneDeep : null,
  equalAre : null,
  iterator : null,
}

// --
// tools extension
// --

let ToolsExtension =
{
}

//

Object.assign( _, ToolsExtension );

// --
// class extension
// --

const iteratorSymbol = Symbol.iterator;
const exportTypeNameGetterSymbol = Symbol.toStringTag;
const exportPrimitiveSymbol = Symbol.toPrimitive;
const exportStringNjsSymbol = Symbol.for( 'nodejs.util.inspect.custom' );
const exportStringSymbol = Symbol.for( 'exportString' );
const ascendSymbol = Symbol.for( 'ascend' );
const equalAreSymbol = Symbol.for( 'equalAre' );
const cloneShallowSymbol = Symbol.for( 'cloneShallow' );
const cloneDeepSymbol = Symbol.for( 'cloneDeep' );
const elementWithKeySetSymbol = Symbol.for( 'elementWithKeySet' );
const elementSetSymbol = Symbol.for( 'elementSet' );

//

let ClassExtension =
{

  methodIteratorOf,
  methodEqualOf, /* xxx : qqq : add other similar routines */
  methodExportStringOf,
  methodAscendOf,
  methodCloneShallowOf,
  methodCloneDeepOf,
  methodElementWithKeySetOf,
  methodElementSetOf,
  methodMakeEmptyOf,
  methodMakeUndefinedOf,

  declareBasic,

  // fields

  tools : _,
  iteratorSymbol,
  exportTypeNameGetterSymbol,
  exportPrimitiveSymbol,
  exportStringNjsSymbol,
  exportStringSymbol,
  ascendSymbol,
  equalAreSymbol,
  cloneShallowSymbol,
  cloneDeepSymbol,
  elementSetSymbol,

}

//

Object.assign( _.class, ClassExtension );

})();

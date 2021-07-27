( function _l1_5BufferTyped_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.buffer = _.buffer || Object.create( null );
_.bufferTyped = _.bufferTyped || Object.create( null );
_.bufferTyped.namespaces = _.bufferTyped.namespaces || Object.create( null );

// --
// implementation
// --

function is( src )
{
  if( !( src instanceof Object.getPrototypeOf( Int8Array ) ) )
  return false;
  if( _.buffer.nodeIs( src ) )
  return false;
  return true;
}

//

function isSlow( src )
{
  let type = Object.prototype.toString.call( src );
  if( !/\wArray/.test( type ) )
  return false;
  if( type === '[object SharedArrayBuffer]' )
  return false;
  if( _.buffer.nodeIs( src ) )
  return false;
  return true;
}

//

// /*qqq: Same as is. Should We Keep it?
function isUsingGetPrototype( src )
{
  if( !( src instanceof Object.getPrototypeOf( Int8Array ) ) )
  return false;
  if( _.buffer.nodeIs( src ) )
  return false;
  return true;
}

//

function isUsingGetPrototypeWithFunctor_functor()
{
  let TypedArray = Object.getPrototypeOf( Int8Array );
  return isUsingGetPrototypeWithFunctor;
  function isUsingGetPrototypeWithFunctor( src )
  {
    if( !( src instanceof TypedArray ) )
    return false;
    if( _.buffer.nodeIs( src ) )
    return false;
    return true;
  }
}

let isUsingGetPrototypeWithFunctor = isUsingGetPrototypeWithFunctor_functor();

//

function isUsingExistenceOfField_functor()
{
  let TypedArray = Object.getPrototypeOf( Int8Array );
  return isUsingExistenceOfField;
  function isUsingExistenceOfField( src )
  {
    if( !src )
    return false;
    if( !( src.buffer ) )
    return false;
    if( !( src instanceof TypedArray ) )
    return false;
    if( _.buffer.nodeIs( src ) )
    return false;
    return true;
  }
}

let isUsingExistenceOfField = isUsingExistenceOfField_functor();

//

function alternateSet_functor()
{
  let typedArraysSet = new Set();
  typedArraysSet.add( '[object BigUint64Array]' );
  typedArraysSet.add( '[object Uint32Array]' );
  typedArraysSet.add( '[object Uint16Array]' );
  typedArraysSet.add( '[object Uint8Array]' );
  typedArraysSet.add( '[object Uint8ClampedArray]' );
  typedArraysSet.add( '[object BigInt64Array]' );
  typedArraysSet.add( '[object Int32Array]' );
  typedArraysSet.add( '[object Int16Array]' );
  typedArraysSet.add( '[object Int8Array]' );
  typedArraysSet.add( '[object Float64Array]' );
  typedArraysSet.add( '[object Float32Array]' );
  return alternateSet;

  function alternateSet( src )
  {
    if( !( typedArraysSet.has( Object.prototype.toString.call( src ) ) ) )
    return false;
    if( _.buffer.nodeIs( src ) )
    return false;
    return true;
  }
}

let isUsingSet = alternateSet_functor();

//

function isUsingHashMap_functor()
{
  let typedArraysMap = new Map();
  typedArraysMap.set( '[object BigUint64Array]', '[object BigUint64Array]' );
  typedArraysMap.set( '[object Uint32Array]', '[object Uint32Array]' );
  typedArraysMap.set( '[object Uint16Array]', '[object Uint16Array]' );
  typedArraysMap.set( '[object Uint8Array]', '[object Uint8Array]' );
  typedArraysMap.set( '[object Uint8ClampedArray]', '[object Uint8ClampedArray]' );
  typedArraysMap.set( '[object BigInt64Array]', '[object BigInt64Array]' );
  typedArraysMap.set( '[object Int32Array]', '[object Int32Array]' );
  typedArraysMap.set( '[object Int16Array]', '[object Int16Array]' );
  typedArraysMap.set( '[object Int8Array]', '[object Int8Array]' );
  typedArraysMap.set( '[object Float64Array]', '[object Float64Array]' );
  typedArraysMap.set( '[object Float32Array]', '[object Float32Array]' );
  return isUsingHashMap;

  function isUsingHashMap( src )
  {
    if( !( typedArraysMap.has( Object.prototype.toString.call( src ) ) ) )
    return false;
    if( _.buffer.nodeIs( src ) )
    return false;
    return true;
  }
}

let isUsingHashMap = isUsingHashMap_functor();

//

function isUsingMap_functor()
{
  let typedArraysMap = Object.create( null );
  typedArraysMap[ '[object BigUint64Array]' ] = '[object BigUint64Array]';
  typedArraysMap[ '[object Uint32Array]' ] = '[object Uint32Array]';
  typedArraysMap[ '[object Uint16Array]' ] = '[object Uint16Array]';
  typedArraysMap[ '[object Uint8Array]' ] = '[object Uint8Array]';
  typedArraysMap[ '[object Uint8ClampedArray]' ] = '[object Uint8ClampedArray]';
  typedArraysMap[ '[object BigInt64Array]' ] = '[object BigInt64Array]';
  typedArraysMap[ '[object Int32Array]' ] = '[object Int32Array]';
  typedArraysMap[ '[object Int16Array]' ] = '[object Int16Array]';
  typedArraysMap[ '[object Int8Array]' ] = '[object Int8Array]';
  typedArraysMap[ '[object Float64Array]' ] = '[object Float64Array]';
  typedArraysMap[ '[object Float32Array]' ] = '[object Float32Array]';
  return isUsingMap;

  function isUsingMap( src )
  {
    if( !typedArraysMap[ Object.prototype.toString.call( src ) ] )
    return false;
    if( _.buffer.nodeIs( src ) )
    return false;
    return true;
  }
}

let isUsingMap = isUsingMap_functor();

//

function IsResizable()
{
  _.assert( arguments.length === 0 );
  return false;
}

//

function _make( src, length )
{
  if( arguments.length === 2 )
  {
    let data = length;
    if( _.number.is( length ) )
    {
      data = src;
    }
    else if( length.length )
    // else if( _.long.is( length ) )
    {
      length = length.length;
    }
    if( _.countable.is( length ) )
    {
      data = [ ... length ];
      length = data.length;
    }


    if( this.like( src ) )
    return fill( new src.constructor( length ), data );
    return fill( this.tools.bufferTyped.default.make( length ), data );
  }
  else if( arguments.length === 1 )
  {
    if( this.like( src ) )
    return new src.constructor( src );
    return this.tools.bufferTyped.default.make( src );
  }
  return this.tools.bufferTyped.default.make( 0 );

  /* */

  function fill( dst, data )
  {
    if( data === null || data === undefined )
    return dst;
    let l = Math.min( length, data.length );
    for( let i = 0 ; i < l ; i++ )
    dst[ i ] = data[ i ];
    return dst;
  }
}

//

function _makeEmpty( src )
{
  if( arguments.length === 1 )
  {
    if( _.routine.is( src ) )
    {
      let result = new src( 0 );
      _.assert( this.like( result ) );
      return result;
    }
    if( this.like( src ) )
    return new src.constructor();
  }
  return this.tools.bufferTyped.default.make();
}

//

function makeEmpty( src )
{
  _.assert( arguments.length === 0 || this.like( src ) || _.countable.is( src ) || _.routine.is( src ) );
  _.assert( arguments.length <= 1 );
  // _.assert( arguments.length === 0 || arguments.length === 1 );
  // if( arguments.length === 1 )
  // _.assert( this.like( src ) || _.countable.is( src ) || _.routine.is( src ) );

  return this._makeEmpty( ... arguments );
}

//

function _makeUndefined( src, length )
{
  if( arguments.length === 0 )
  return this.make( 0 );

  if( length === undefined )
  length = src;
  if( length && !_.number.is( length ) )
  {
    if( length.length )
    length = length.length;
    else
    length = [ ... length ].length;
  }
  if( this.like( src ) )
  return new src.constructor( length );
  return this._make( length );
}

//

function _makeFilling( type, value, length )
{
  if( arguments.length === 2 )
  {
    value = arguments[ 0 ];
    length = arguments[ 1 ];
    if( this.like( length ) )
    type = length;
    else
    type = null;
  }

  if( !_.number.is( length ) )
  // if( _.long.is( length ) )
  if(  length.length )
  length = length.length;
  else if( _.countable.is( length ) )
  length = [ ... length ].length;

  let result = this._make( type, length );
  for( let i = 0 ; i < length ; i++ )
  result[ i ] = value;

  return result;
}

//

function _cloneShallow( src )
{
  return src.slice( 0 );
  // if( _.buffer.rawIs( src ) )
  // return bufferRawCopy( src );
  // if( _.buffer.viewIs( src ) )
  // return new BufferView( bufferRawCopy( src ) );
  // if( _.buffer.typedIs( src ) )
  // return src.slice( 0 );
  // if( _.buffer.nodeIs( src ) )
  // return src.copy();
  //
  // /* */
  //
  // function bufferRawCopy( src )
  // {
  //   var dst = new BufferRaw( src.byteLength );
  //   new U8x( dst ).set( new U8x( src ) );
  //   return dst;
  // }
}

// --
// meta
// --

function _namespaceRegister( namespace, defaultNamespaceName )
{

  namespace.NamespaceNames.forEach( ( name ) =>
  {
    _.assert( _.bufferTyped.namespaces[ name ] === undefined );
    _.bufferTyped.namespaces[ name ] = namespace;
  });

  _.assert( namespace.IsTyped === undefined || namespace.IsTyped === true );
  namespace.IsTyped = true;

  return _.long._namespaceRegister( ... arguments );
}

//

/* qqq : optimize */
function namespaceOf( src )
{

  if( _.f32x.is( src ) )
  return _.f32x;
  if( _.f64x.is( src ) )
  return _.f64x;

  if( _.i8x.is( src ) )
  return _.i8x;
  if( _.i16x.is( src ) )
  return _.i16x;
  if( _.i32x.is( src ) )
  return _.i32x;

  if( _.u8x.is( src ) )
  return _.u8x;
  if( _.u8xClamped.is( src ) )
  return _.u8xClamped;
  if( _.u16x.is( src ) )
  return _.u16x;
  if( _.u32x.is( src ) )
  return _.u32x;

  return null;
}

// --
// declaration
// --

let BufferTypedExtension =
{

  //

  NamespaceName : 'bufferTyped',
  NamespaceNames : [ 'bufferTyped' ],
  NamespaceQname : 'wTools/bufferTyped',
  MoreGeneralNamespaceName : 'long',
  MostGeneralNamespaceName : 'countable',
  TypeName : 'BufferTyped',
  TypeNames : [ 'BufferTyped' ],
  // SecondTypeName : 'ArrayTyped',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  // typedIs : is,
  is : is,
  like : is,
  IsResizable,
  isSlow, /* xxx : remove later */
  isUsingGetPrototype,
  isUsingGetPrototypeWithFunctor,
  isUsingExistenceOfField,
  isUsingSet,
  isUsingHashMap,
  isUsingMap,

  // maker

  _make, /* qqq : cover */
  make : _.long.make,
  _makeEmpty,
  makeEmpty,
  _makeUndefined, /* qqq : implement */
  makeUndefined : _.argumentsArray.makeUndefined,
  _makeZeroed : _makeUndefined,
  makeZeroed : _.argumentsArray.makeZeroed, /* qqq : for junior : cover */
  _makeFilling,
  makeFilling : _.argumentsArray.makeFilling, /* qqq : for junior : cover */
  _cloneShallow,
  cloneShallow : _.argumentsArray.cloneShallow, /* qqq : for junior : cover */
  from : _.argumentsArray.from, /* qqq : for junior : cover */

  // meta

  _namespaceRegister,

  namespaceOf,
  namespaceWithDefaultOf : _.props.namespaceWithDefaultOf,
  _functor_functor : _.props._functor_functor,

}

Object.assign( _.bufferTyped, BufferTypedExtension );

//

let BufferExtension =
{

  // dichotomy

  typedIs : is.bind( _.buffer ),

}

Object.assign( _.buffer, BufferExtension );

//

let ToolsExtension =
{

  // dichotomy

  bufferTypedIs : is.bind( _.buffer ),

}

//

Object.assign( _, ToolsExtension );

})();

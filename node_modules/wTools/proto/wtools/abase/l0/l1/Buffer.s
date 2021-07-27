( function _l1_Buffer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.buffer = _.buffer || Object.create( null );

// --
// implementation
// --

function anyIs( src )
{
  if( src instanceof ArrayBuffer )
  return true;
  if( _global.BufferRawShared && src instanceof SharedArrayBuffer )
  return true;
  if( ArrayBuffer.isView( src ) )
  return true;
  return false;
}

// //
//
// function anyIsOld( src )
// {
//   if( !src )
//   return false;
//   if( typeof src !== 'object' )
//   return false;
//   //{ byteLength: 6 } will pass the below check
//   if( !Reflect.has( src, 'byteLength' ) )
//   return false;
//   // return src.byteLength >= 0;
//   // return typedIs( src ) || viewIs( src )  || rawIs( src ) || nodeIs( src );
//   return true;
// }
//
// //
//
// function anyIsUsingInstanceOf( src )
// {
//   if( src instanceof ArrayBuffer )
//   return true;
//   if( src instanceof SharedArrayBuffer )
//   return true;
//   if( ArrayBuffer.isView( src ) )
//   return true;
//   return false;
// }

//

function IsResizable()
{
  _.assert( arguments.length === 0 );
  return false;
}

// --
// maker
// --

function _make_functor( onMake )
{

  return function _bufferMake( src, ins )
  {
    let result;

    /* */

    let length = ins;

    // if( _.longIs( length ) || _.bufferNodeIs( length ) )
    if( _.countable.is( length ) || _.bufferNodeIs( length ) )
    {
      if( length.length )
      {
        length = length.length;
      }
      else
      {
        ins = [ ... length ];
        length = ins.length;
      }
    }
    else if( _.bufferRawIs( length ) || _.bufferViewIs( length ) )
    {
      length = length.byteLength;
      ins = _.bufferViewIs( ins ) ? new U8x( ins.buffer ) : new U8x( ins );
    }
    else if( length === undefined || length === null )
    {
      if( src === null ) /* Dmytro : Does module has default buffer type? */
      {
        length = 0;
      }
      else if( _.longIs( src ) || _.bufferNodeIs( src ) )
      {
        length = src.length;
        ins = src;
        // src = null;
      }
      else if( _.bufferRawIs( src ) )
      {
        length = src.byteLength;
        ins = new U8x( src );
        // src = null;
      }
      else if( _.bufferViewIs( src ) )
      {
        length = src.byteLength;
        ins = new U8x( src.buffer );
        // src = null;
      }
      else if( _.number.is( src ) )
      {
        length = src;
        src = null;
      }
      else if( _.routine.is( src ) )
      {
        _.assert( 0, 'Unknown length of buffer' );
      }
      else if( arguments.length === 0 )
      {
        length = 0;
        src = null;
      }
      else _.assert( 0 );
    }
    else if( !_.number.is( length ) )
    {
      _.assert( 0, 'Unknown length of buffer' );
    }

    if( !length )
    length = 0;

    /* */

    if( _.number.is( ins ) )
    {
      if( _.bufferRawIs( src ) )
      ins = new U8x( src );
      else if( _.bufferViewIs( src ) )
      ins = new U8x( src.buffer )
      else if( _.longIs( src ) || _.bufferNodeIs( src ) )
      ins = src;
      else
      ins = null;
    }

    /* */

    let minLength;
    if( ins )
    minLength = Math.min( ins.length, length );
    else
    minLength = 0;

    /* */

    if( _.argumentsArray.is( src ) )
    src = _.routine.join( this.tools.bufferTyped.default, this.tools.bufferTyped.default.make );
    // src = _.routine.join( this.tools.long.default, this.tools.long.default.make );

    if( src === null )
    src = _.routine.join( this.tools.bufferTyped.default, this.tools.bufferTyped.default.make );
    // src = _.routine.join( this.tools.long.default, this.tools.long.default.make );

    _.assert( 0 <= arguments.length && arguments.length <= 2 );
    // _.assert( arguments.length === 1 || arguments.length === 2 );
    _.assert( _.number.isFinite( length ) );
    _.assert( _.routine.is( src ) || _.longIs( src ) || _.bufferAnyIs( src ), 'unknown type of array', _.entity.strType( src ) );

    result = onMake.call( this, src, ins, length, minLength );

    _.assert( _.bufferAnyIs( result ) || _.longLike( result ) );

    return result;
  }
}

//

/**
 * The routine make() returns a new buffer with the same type as source buffer {-src-}. New buffer fills by content of insertion buffer {-ins-}. If {-ins-} is
 * a number, the buffer fills by {-src-} content. The length of resulted buffer is equal to {-ins-}. If {-ins-} is not defined, then routine makes default Long type,
 * length of returned container defines from {-src-}.
 *
 * @param { BufferAny|Long|Function|Number|Null } src - Instance of any buffer, Long or constructor, defines type of returned buffer. If {-src-} is null,
 * then routine returns instance of default Long.
 * @param { Number|Long|Buffer|Null|Undefined } ins - Defines length and content of new buffer. If {-ins-} is null or undefined, then routine makes new container
 * with default Long type and fills it by {-src-} content.
 *
 * Note. Default Long type defines by descriptor {-longDescriptor-}. If descriptor not provided directly, then it is Array descriptor.
 *
 * @example
 * let got = _.make();
 * // returns []
 *
 * @example
 * let got = _.make( null );
 * // returns []
 *
 * @example
 * let got = _.make( null, null );
 * // returns []
 *
 * @example
 * let got = _.make( 3 );
 * // returns [ undefined, undefined, undefined ]
 *
 * @example
 * let got = _.make( 3, null );
 * // returns [ undefined, undefined, undefined ]
 *
 * @example
 * let got = _.make( new U8x( [ 1, 2, 3 ] ) );
 * // returns [ 1, 2, 3 ];
 * _.bufferTypedIs( got );
 * // log false
 *
 * @example
 * let got = _.make( new I16x( [ 1, 2, 3 ] ), null );
 * // returns [ 1, 2, 3 ];
 * _.bufferTypedIs( got );
 * // log false
 *
 * @example
 * _.make( new BufferRaw( 4 ), 6 );
 * // returns ArrayBuffer { [Uint8Contents]: <00 00 00 00 00 00>, byteLength: 6 }
 *
 * @example
 * _.make( new BufferRaw( 4 ), [ 1, 2, 3 ] );
 * // returns ArrayBuffer { [Uint8Contents]: <01 02 03>, byteLength: 3 }
 *
 * @example
 * _.make( F64x, [ 1, 2, 3 ] );
 * // returns Float64Array [ 1, 2, 3 ]
 *
 * @returns { BufferAny|Long }  Returns a buffer with source buffer {-src-} type filled by insertion container {-ins-} content.
 * If {-ins-} is not defined, then routine makes default Long type container and fills it by {-src-} content.
 * @function make
 * @throws { Error } If arguments.length is more than two.
 * @throws { Error } If {-src-} is not a Long, not a buffer, not a Number, not a constructor, not null.
 * @throws { Error } If {-src-} is constructor and second argument {-src-} is not provided.
 * @throws { Error } If {-src-} is constructor that returns not a Long, not a buffer value.
 * @throws { Error } If {-ins-} is not a number, not a Long, not a buffer, not null, not undefined.
 * @throws { Error } If {-ins-} or src.length has a not finite value.
 * @namespace Tools
 */

function _make( src, length )
{
  if( length === undefined )
  length = src;
  let data = length;

  if( _.number.is( length ) )
  {
    data = src;
  }
  else if( length )
  {
    if( _.number.is( length.length ) )
    {
      length = length.length;
    }
    else if( _.number.is( length.byteLength ) )
    {
      length = length.byteLength;
    }
    else
    {
      data = [ ... length ];
      length = data.length;
    }
  }

  if( arguments.length === 2 )
  {
    if( src === null )
    return fill( this.tools.bufferTyped.make( length ), data );
    if( _.buffer.rawIs( src ) )
    return fill( new BufferRaw( length ), data );
    if( _.buffer.viewIs( src ) )
    return new BufferView( fill( new BufferRaw( length ), data ) );
    if( _.buffer.typedIs( src ) )
    return fill( new src.constructor( length ), data );
    if( _.buffer.nodeIs( src ) )
    return fill( BufferNode.alloc( length ), data );
    if( _.long.is( src ) )
    return fill( this.tools.bufferTyped.make( length ), data );

    let result;
    if( _.routineIs( src ) )
    result = fill( new src( length ), data )
    _.assert( _.buffer.is( result ), 'Not clear how to make such buffer' );
    return result;
  }
  else if( arguments.length === 1 )
  {
    if( src === null || _.number.is( src ) )
    return this.tools.bufferTyped.make( src );
    if( _.buffer.rawIs( src ) )
    return fill( new BufferRaw( length ), data );
    if( _.buffer.viewIs( src ) )
    return new BufferView( fill( new BufferRaw( length ), data ) );
    if( _.buffer.typedIs( src ) )
    return fill( new src.constructor( src ) );
    if( _.buffer.nodeIs( src ) )
    return fill( BufferNode.from( src ) );
    if( _.countable.is( src ) )
    return this.tools.bufferTyped.make( src );
  }

  return this.tools.bufferTyped.make();

  /* */

  function fill( dst, data )
  {
    if( data === null || data === undefined )
    return dst;

    let dstTyped = dst;
    if( _.bufferRawIs( dst ) )
    dstTyped = new U8x( dst );
    if( _.bufferViewIs( dst ) )
    dstTyped = new U8x( dst.buffer );

    let dataTyped = data;
    if( _.bufferRawIs( data ) )
    dataTyped = new U8x( data );
    if( _.bufferViewIs( data ) )
    dataTyped = new U8x( data.buffer );

    let l = Math.min( length, dataTyped.length );
    for( let i = 0 ; i < l ; i++ )
    dstTyped[ i ] = dataTyped[ i ];

    return dst;
  }
}

//

function make( src, length )
{
  _.assert( arguments.length <= 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || this.is( src ) || _.long.is( src ) || _.routineIs( src ) );
    _.assert( _.number.is( length ) || this.is( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.number.is( src ) || this.is( src ) || _.long.is( src ) || _.routineIs( src ) );
  }
  return this._make( ... arguments );
}

// let make = _make_functor( function( /* src, ins, length, minLength */ )
// {
//   let src = arguments[ 0 ];
//   let ins = arguments[ 1 ];
//   let length = arguments[ 2 ];
//   let minLength = arguments[ 3 ];
//
//   /* */
//
//   let resultTyped;
//   /* qqq : for Dmytro : bad solution! */
//   if( _.routine.is( src ) )
//   {
//     if( src.name === 'make' || src.name === 'bound make' )
//     resultTyped = src( length );
//     else
//     resultTyped = new src( length );
//   }
//   else if( _.bufferNodeIs( src ) )
//   resultTyped = BufferNode.alloc( length );
//   else if( _.bufferViewIs( src ) )
//   resultTyped = new BufferView( new BufferRaw( length ) );
//   else if( _.unrollIs( src ) )
//   resultTyped = _.unroll.make( length );
//   else
//   resultTyped = new src.constructor( length );
//
//   let result = resultTyped;
//   if( _.bufferRawIs( result ) )
//   resultTyped = new U8x( result );
//   if( _.bufferViewIs( result ) )
//   resultTyped = new U8x( result.buffer );
//
//   for( let i = 0 ; i < minLength ; i++ )
//   resultTyped[ i ] = ins[ i ];
//
//   return result;
// });

//

function _makeEmpty( src )
{
  if( arguments.length === 1 )
  {
    if( _.routineIs( src ) )
    {
      let result = new src( 0 );
      _.assert( this.like( result ) );
      return result;
    }
    if( this.like( src ) )
    {
      if( _.buffer.viewIs( src ) )
      return new src.constructor( new BufferRaw() );
      else if( _.buffer.nodeIs( src ) )
      return BufferNode.alloc( 0 );
      else
      return new src.constructor();
    }
  }
  return this.tools.bufferTyped.default.make();
}

//

function makeEmpty( src )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( arguments.length === 1 )
  _.assert( this.like( src ) || _.countable.is( src ) || _.routineIs( src ) );

  return this._makeEmpty( ... arguments );
}

//

/**
 * The routine makeUndefined() returns a new buffer with the same type as source buffer {-src-}. The length of resulted buffer is equal to {-ins-}.
 * If {-ins-} is not defined, then routine makes default Long type, length of returned container defines from {-src-}.
 *
 * @param { BufferAny|Long|Function|Number|Null } src - Instance of any buffer, Long or constructor, defines type of returned buffer. If {-src-} is null,
 * then routine returns instance of default Long.
 * @param { Number|Long|Buffer|Null|Undefined } ins - Defines length of new buffer. If {-ins-} is null or undefined, then routine makes new container
 * with default Long type and length defined by {-src-}.
 *
 * Note. Default Long type defines by descriptor {-longDescriptor-}. If descriptor not provided directly, then it is Array descriptor.
 *
 * @example
 * let got = _.makeUndefined();
 * // returns []
 *
 * @example
 * let got = _.makeUndefined( null );
 * // returns []
 *
 * @example
 * let got = _.makeUndefined( null, null );
 * // returns []
 *
 * @example
 * let got = _.makeUndefined( 3 );
 * // returns [ undefined, undefined, undefined ]
 *
 * @example
 * let got = _.makeUndefined( 3, null );
 * // returns [ undefined, undefined, undefined ]
 *
 * @example
 * let got = _.makeUndefined( new U8x( [ 1, 2, 3 ] ) );
 * // returns [ undefined, undefined, undefined ];
 * _.bufferTypedIs( got );
 * // log false
 *
 * @example
 * let got = _.makeUndefined( new I16x( [ 1, 2, 3 ] ), null );
 * // returns [ undefined, undefined, undefined ];
 * _.bufferTypedIs( got );
 * // log false
 *
 * @example
 * _.makeUndefined( new BufferRaw( 4 ), 6 );
 * // returns ArrayBuffer { [Uint8Contents]: <00 00 00 00 00 00>, byteLength: 6 }
 *
 * @example
 * _.makeUndefined( new BufferRaw( 4 ), [ 1, 2, 3 ] );
 * // returns ArrayBuffer { [Uint8Contents]: <00 00 00>, byteLength: 3 }
 *
 * @example
 * _.makeUndefined( F64x, [ 1, 2, 3 ] );
 * // returns Float64Array [ 0, 0, 0 ]
 *
 * @returns { BufferAny|Long }  Returns a buffer with source buffer {-src-} type filled by insertion container {-ins-} content.
 * If {-ins-} is not defined, then routine makes default Long type container and fills it by {-src-} content.
 * @function makeUndefined
 * @throws { Error } If arguments.length is more than two.
 * @throws { Error } If {-src-} is not a Long, not a buffer, not a Number, not a constructor, not null.
 * @throws { Error } If {-src-} is constructor and second argument {-src-} is not provided.
 * @throws { Error } If {-src-} is constructor that returns not a Long, not a buffer value.
 * @throws { Error } If {-ins-} is not a number, not a Long, not a buffer, not null, not undefined.
 * @throws { Error } If {-ins-} or src.length has a not finite value.
 * @namespace Tools
 */

function _makeUndefined( src, length )
{
  if( length === undefined )
  length = src;

  if( length && !_.number.is( length ) )
  {
    if( _.number.is( length.length ) )
    length = length.length;
    else if( _.number.is( length.byteLength ) )
    length = length.byteLength;
    else
    length = [ ... length ].length;
  }

  if( src === null || _.number.is( src ) )
  return this.tools.bufferTyped.make( length );
  if( _.buffer.rawIs( src ) )
  return new BufferRaw( length );
  if( _.buffer.viewIs( src ) )
  return new BufferView( new BufferRaw( length ) );
  if( _.buffer.typedIs( src ) )
  return new src.constructor( length );
  if( _.buffer.nodeIs( src ) )
  return BufferNode.alloc( length );
  if( _.countable.is( src ) )
  return this.tools.bufferTyped.make( length );

  if( _.routineIs( src ) )
  {
    _.assert( arguments.length === 2 );
    let result = new src( length );
    _.assert( _.buffer.is( result ), 'Not clear how to make such buffer' );
    return result;
  }

  return this.tools.bufferTyped.make();
}

//

function makeUndefined( src, length )
{
  _.assert( 0 <= arguments.length && arguments.length <= 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || this.like( src ) || _.long.is( src ) || _.routineIs( src ) );
    _.assert( _.number.is( length ) || this.like( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.number.is( src ) || this.like( src ) || _.long.is( src ) || _.routineIs( src ) );
  }
  return this._makeUndefined( ... arguments );
}

// let makeUndefined = _make_functor( function( /* src, ins, length, minLength */ )
// {
//   let src = arguments[ 0 ];
//   let ins = arguments[ 1 ];
//   let length = arguments[ 2 ];
//   let minLength = arguments[ 3 ];
//
//   /* */
//
//   let result;
//   /* qqq : for Dmytro : bad solution! */
//   if( _.routine.is( src ) )
//   {
//     if( src.name === 'make' || src.name === 'bound make' )
//     result = src( length );
//     else
//     result = new src( length );
//   }
//   else if( _.bufferNodeIs( src ) )
//   result = BufferNode.alloc( length );
//   else if( _.bufferViewIs( src ) )
//   result = new BufferView( new BufferRaw( length ) );
//   else if( _.unrollIs( src ) )
//   result = _.unroll.make( length );
//   else
//   result = new src.constructor( length );
//
//   return result;
// });

//

function _makeFilling( type, value, length )
{
  if( arguments.length === 2 )
  {
    type = null;
    value = arguments[ 0 ];
    length = arguments[ 1 ];
  }

  if( !_.number.is( length ) )
  if(  length.length )
  length = length.length;
  else if(  length.byteLength )
  length = length.byteLength;
  else if( _.countable.is( length ) )
  length = [ ... length ].length;

  let result = this._make( type, length );
  let resultTyped = result;
  if( !resultTyped.length )
  {
    if( _.buffer.viewIs( resultTyped ) )
    resultTyped = new U8x( resultTyped.buffer );
    else
    resultTyped = new U8x( resultTyped );
  }
  for( let i = 0 ; i < length ; i++ )
  resultTyped[ i ] = value;

  return result;
}

//

function makeFilling( type, value, length )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( arguments.length === 2 )
  {
    _.assert( _.number.is( value ) || _.countable.is( value ) || this.like( length ) );
    _.assert( type !== undefined );
  }
  else
  {
    _.assert( value !== undefined );
    _.assert( _.number.is( length ) || _.countable.is( length ) || this.like( length ) );
    _.assert( type === null || _.long.is( type ) || this.like( type ) || _.routine.is( type ) );
  }

  return this._makeFilling( ... arguments );
}

//

function _cloneShallow( src )
{
  if( _.buffer.rawIs( src ) )
  return bufferRawCopy( src );
  if( _.buffer.viewIs( src ) )
  return new BufferView( bufferRawCopy( src ) );
  if( _.buffer.typedIs( src ) )
  return src.slice( 0 );
  if( _.buffer.nodeIs( src ) )
  return BufferNode.from( src );

  /* */

  function bufferRawCopy( src )
  {
    const dst = new BufferRaw( src.byteLength );
    const buffer = src.buffer || src;
    const offset = src.byteOffset || 0;
    new U8x( dst ).set( new U8x( buffer, offset, src.byteLength ) );
    return dst;
  }
}

//

function bufferFromArrayOfArray( array, options )
{

  if( _.object.isBasic( array ) )
  {
    options = array;
    array = options.buffer;
  }

  options = options || Object.create( null );
  array = options.buffer = array || options.buffer;

  /* */

  if( options.BufferType === undefined ) options.BufferType = F32x;
  if( options.sameLength === undefined ) options.sameLength = 1;
  if( !options.sameLength )
  throw _.err( '_.bufferFromArrayOfArray :', 'different length of arrays is not implemented' );

  if( !array.length )
  return new options.BufferType();

  let scalarsPerElement = _.number.is( array[ 0 ].length ) ? array[ 0 ].length : array[ 0 ].len;

  if( !_.number.is( scalarsPerElement ) )
  throw _.err( '_.bufferFromArrayOfArray :', 'cant find out element length' );

  let length = array.length * scalarsPerElement;
  let result = new options.BufferType( length );
  let i = 0;

  for( let a = 0 ; a < array.length ; a++ )
  {
    let element = array[ a ];

    for( let e = 0 ; e < scalarsPerElement ; e++ )
    {
      result[ i ] = element[ e ];
      i += 1;
    }
  }

  return result;
}

//

/**
 * The bufferRawFromTyped() routine returns a new BufferRaw from (buffer.byteOffset) to the end of an BufferRaw of a typed array (buffer)
 * or returns the same BufferRaw of the (buffer), if (buffer.byteOffset) is not provided.
 *
 * @param { typedArray } buffer - Entity to check.
 *
 * @example
 * let buffer1 = new BufferRaw( 10 );
 * let view1 = new I8x( buffer1 );
 * _.bufferRawFromTyped( view1 );
 * // returns [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
 *
 * @example
 * let buffer2 = new BufferRaw( 10 );
 * let view2 = new I8x( buffer2, 2 );
 * _.bufferRawFromTyped( view2 );
 * // returns [ 0, 0, 0, 0, 0, 0 ]
 *
 * @returns { BufferRaw } Returns a new or the same BufferRaw.
 * If (buffer) is instance of '[object ArrayBuffer]', it returns buffer.
 * @function bufferRawFromTyped
 * @throws { Error } Will throw an Error if (arguments.length) is not equal to the 1.
 * @throws { Error } Will throw an Error if (buffer) is not a typed array.
 * @namespace Tools
 */

function bufferRawFromTyped( buffer )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.bufferTypedIs( buffer ) || _.bufferRawIs( buffer ) );

  if( _.bufferRawIs( buffer ) )
  return buffer;

  let result = buffer.buffer;

  if( buffer.byteOffset || buffer.byteLength !== result.byteLength )
  result = result.slice( buffer.byteOffset || 0, buffer.byteLength );

  _.assert( _.bufferRawIs( result ) );

  return result;
}

//

function bufferRawFrom( buffer )
{
  let result;

  /*
  aaa : should do not copying when possible! |
  aaa Dmytro : not copying if it possible
  zzz
  */

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( buffer instanceof BufferRaw )
  return buffer;

  if( _.bufferNodeIs( buffer ) || _.arrayIs( buffer ) )
  {

    // result = buffer.buffer;
    result = new U8x( buffer ).buffer;

  }
  else if( _.bufferTypedIs( buffer ) || _.bufferViewIs( buffer ) )
  {

    result = buffer.buffer;
    if( buffer.byteOffset || buffer.byteLength !== result.byteLength )
    // Dmytro : works not correctly, offset + length = right bound of new bufferRaw
    // result = result.slice( buffer.byteOffset || 0, buffer.byteLength );
    result = result.slice( buffer.byteOffset, buffer.byteOffset + buffer.byteLength );

  }
  else if( _.strIs( buffer ) )
  {

    if( _global_.BufferNode )
    {
      result = _.bufferRawFrom( BufferNode.from( buffer, 'utf8' ) );
    }
    else
    {
      result = _.encode.utf8ToBuffer( buffer ).buffer;
    }

  }
  else if( _global.File && buffer instanceof File )
  {
    let fileReader = new FileReaderSync();
    result = fileReader.readAsArrayBuffer( buffer );
    _.assert( 0, 'not tested' );
  }
  else _.assert( 0, () => 'Unknown type of source ' + _.entity.strType( buffer ) );

  _.assert( _.bufferRawIs( result ) );

  return result;
}

//

function bufferBytesFrom( buffer )
{
  let result;

  // Dmytro : missed
  if( _.bufferBytesIs( buffer ) )
  return buffer;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.bufferNodeIs( buffer ) )
  {

    _.assert( _.bufferRawIs( buffer.buffer ) )
    result = new U8x( buffer.buffer, buffer.byteOffset, buffer.byteLength );

  }
  else if( _.bufferRawIs( buffer ) )
  {

    result = new U8x( buffer, 0, buffer.byteLength );

  }
  else if( _.bufferTypedIs( buffer ) )
  {

    result = new U8x( buffer.buffer, buffer.byteOffset, buffer.byteLength );

  }
  else if( _.bufferViewIs( buffer ) )
  {

    result = new U8x( buffer.buffer, buffer.byteOffset, buffer.byteLength );

  }
  else
  {

    return _.bufferBytesFrom( _.bufferRawFrom( buffer ) );

  }

  _.assert( _.bufferBytesIs( result ) );

  return result;
}

//

function bufferBytesFromNode( src ) /* Dmytro : what does this code do? */
{
  _.assert( _.bufferNodeIs( src ) );
  let result = new U8x( buffer );
  return result;
}

//

function bufferNodeFrom( buffer )
{
  if( _.bufferNodeIs( buffer ) )
  return buffer;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.bufferAnyIs( buffer ) || _.strIs( buffer ) || _.arrayIs( buffer ), 'Expects buffer, string of array, but got', _.entity.strType( buffer ) );

  /* */

  let result;

  if( buffer.length === 0 || buffer.byteLength === 0 )
  {
    result = BufferNode.from([]);
  }
  else if( _.strIs( buffer ) )
  {
    result = _.bufferNodeFrom( _.bufferRawFrom( buffer ) );
  }
  else if( buffer.buffer )
  {
    result = BufferNode.from( buffer.buffer, buffer.byteOffset, buffer.byteLength );
  }
  else
  {
    result = BufferNode.from( buffer );
  }

  _.assert( _.bufferNodeIs( result ) );

  return result;
}

// --
// meta
// --

/* qqq : optimize */
function namespaceOf( src )
{

  if( _.bufferRaw.is( src ) )
  return _.bufferRaw;
  if( _.bufferView.is( src ) )
  return _.bufferView;
  if( _.bufferNode.is( src ) )
  return _.bufferNode;

  return _.bufferTyped.namespaceOf( src );
}

// --
// declaration
// --

let BufferExtension =
{

  //

  NamespaceName : 'buffer',
  NamespaceNames : [ 'buffer' ],
  NamespaceQname : 'wTools/buffer',
  TypeName : 'Buffer',
  TypeNames : [ 'Buffer', 'BufferAny' ],
  // SecondTypeName : 'BufferAny',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  anyIs,
  // anyIsOld,
  // anyIsUsingInstanceOf,
  is : anyIs,
  like : anyIs,
  IsResizable,

  // maker

  _make_functor, /* aaa : remove maybe */ /* Dmytro : implemented */
  _make, /* aaa : implement */ /* Dmytro : implemented */
  make,
  _makeEmpty,
  makeEmpty,
  _makeUndefined, /* aaa : implement */ /* Dmytro : implemented */
  makeUndefined,
  _makeZeroed : _makeUndefined, /* aaa : implement */ /* Dmytro : implemented */
  makeZeroed : makeUndefined,
  _makeFilling,
  makeFilling,

  _cloneShallow,
  cloneShallow : _.argumentsArray.cloneShallow, /* qqq : for junior : cover */
  from : _.argumentsArray.from, /* qqq : for junior : cover */

  // meta

  namespaceOf,
  namespaceWithDefaultOf : _.props.namespaceWithDefaultOf,
  _functor_functor : _.props._functor_functor,

}

Object.assign( _.buffer, BufferExtension );

//

let ToolsExtension =
{

  // dichotomy

  bufferAnyIs : anyIs.bind( _.buffer ),
  bufferIs : anyIs.bind( _.buffer ),

  // maker

  /* qqq : attention is needed. ask */
  bufferMake : make.bind( _.buffer ),
  bufferMakeEmpty : makeEmpty.bind( _.buffer ),
  bufferMakeUndefined : makeUndefined.bind( _.buffer ),
  bufferMakeZeroed : _.buffer.makeZeroed.bind( _.buffer ),

  bufferFromArrayOfArray,
  bufferRawFromTyped, /* xxx : qqq : for Dmytro : move corresponding namespace and tests */
  bufferRawFrom, /* xxx : qqq : for Dmytro : move corresponding namespace and tests */
  bufferBytesFrom, /* xxx : qqq : for Dmytro : move corresponding namespace and tests */
  bufferBytesFromNode, /* xxx : qqq : for Dmytro : move corresponding namespace and tests */
  bufferNodeFrom, /* xxx : qqq : for Dmytro : move corresponding namespace and tests */

}

//

Object.assign( _, ToolsExtension );

})();

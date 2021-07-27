( function _l1_2Props_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.props = _.props || Object.create( null );
const prototypeSymbol = Symbol.for( 'prototype' );
const constructorSymbol = Symbol.for( 'constructor' );

// --
// dichotomy
// --

function is( src )
{
  if( src === null )
  return false;
  if( src === undefined )
  return false;
  return true;
}

//

function like( src )
{
  return _.props.is( src );
}

//

function IsResizable()
{
  _.assert( arguments.length === 0 );
  return true;
}

// --
// maker
// --

function _makeEmpty( src )
{
  if( _.map.is( src ) )
  return _.map._makeEmpty( src );
  if( _.aux.is( src ) )
  return _.aux._makeEmpty( src );
  if( _.object.isBasic( src ) )
  return _.object._makeEmpty( src );

  _.assert( 0, `Not clear how to make ${ _.strType( src ) }` );
}

//

function makeEmpty( src )
{
  _.assert( arguments.length === 1 );
  return this._makeEmpty( ... arguments );
}

//

function _makeUndefined( src, length )
{
  if( _.map.is( src ) )
  return _.map._makeUndefined( src );
  if( _.aux.is( src ) )
  return _.aux._makeUndefined( src );
  if( _.object.isBasic( src ) )
  return _.object._makeUndefined( src );

  _.assert( 0 );

  return new src.constructor();
}

//

function makeUndefined( src, length )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  return this._makeUndefined( ... arguments );
}

//

function _make( src )
{
  if( _.map.is( src ) )
  return _.map._make( src );
  if( _.aux.is( src ) )
  return _.aux._make( src );
  if( _.object.isBasic( src ) )
  return _.object._make( src );

  _.assert( 0 );

  let method = _.class.methodCloneShallowOf( src );
  if( method )
  return method.call( src );
  return new src.constructor( src );
}

//

function make( src, length )
{
  _.assert( this.like( src ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  return this._make( ... arguments );
}

//

function _cloneShallow( src )
{
  if( _.map.is( src ) )
  return _.map._cloneShallow( src );
  if( _.aux.is( src ) )
  return _.aux._cloneShallow( src );
  if( _.object.isBasic( src ) )
  return _.object._cloneShallow( src );

  let method = _.class.methodCloneShallowOf( src );
  if( method )
  return method.call( src );
  return new src.constructor( src );

  // _.assert( 0, `Not clear how to clone ${ _.strType( src ) }` );
}

//

function cloneShallow( src )
{
  _.assert( this.like( src ) );
  _.assert( arguments.length === 1 );
  return this._cloneShallow( src );
}

//

function from( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( this.is( src ) )
  return src;
  return this.make( src );
}

// --
// amender
// --

// //
//
// function supplementStructureless( dstMap, srcMap )
// {
//   if( dstMap === null && arguments.length === 2 )
//   return Object.assign( Object.create( null ), srcMap );
//
//   if( dstMap === null )
//   dstMap = Object.create( null );
//
//   for( let a = 1 ; a < arguments.length ; a++ )
//   {
//     srcMap = arguments[ a ];
//     for( let s in srcMap )
//     {
//       if( dstMap[ s ] !== undefined )
//       continue;
//
//       if( Config.debug )
//       if( _.object.like( srcMap[ s ] ) || _.argumentsArray.like( srcMap[ s ] ) )
//       if( !_.regexpIs( srcMap[ s ] ) && !_.date.is( srcMap[ s ] ) )
//       throw Error( `Source map should have only primitive elements, but ${ s } is ${ srcMap[ s ] }` );
//
//       dstMap[ s ] = srcMap[ s ];
//     }
//   }
//
//   return dstMap;
// }

//

function _extendWithHashmap( dstMap, src )
{
  for( let [ key, val ] of src )
  dstMap[ key ] = val;
  return dstMap;
}

//

function _extendWithSet( dstMap, src )
{
  for( let key of src )
  dstMap[ key ] = key;
  return dstMap;
}

//

function _extendWithCountable( dstMap, src )
{
  for( let e of src )
  {
    _.assert( e.length === 2 );
    dstMap[ e[ 0 ] ] = e[ 1 ];
  }
  return dstMap;
}

//

function _extendWithProps( dstMap, src )
{
  for( let k in src )
  dstMap[ k ] = src[ k ];
  return dstMap;
}

//

function _extendUniversal( dstMap, srcMap )
{

  _.assert( !_.primitive.is( srcMap ), 'Expects non-primitive' );

  let srcProto = Object.getPrototypeOf( srcMap );
  if( srcProto === null || srcProto === Object.prototype )
  Object.assign( dstMap, srcMap );
  else if( _.hashMap.like( srcMap ) )
  this._extendWithHashmap( dstMap, srcMap ); /* qqq : cover */
  else if( _.set.like( srcMap ) )
  this._extendWithSet( dstMap, srcMap ); /* qqq : cover */
  else if( _.long.like( srcMap ) )
  this._extendWithCountable( dstMap, srcMap ); /* qqq : cover */
  else
  this._extendWithProps( dstMap, srcMap ); /* qqq : cover */

  return dstMap;
}

//

function extendUniversal( dstMap, srcMap )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  if( arguments.length === 2 )
  {
    let srcProto = Object.getPrototypeOf( srcMap );
    if( srcProto === null || srcProto === Object.prototype )
    return Object.assign( dstMap, srcMap );
  }

  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  _.assert( this.like( dstMap ), () => `Expects dstMap::${this.NamespaceName} as the first argument` );

  for( let a = 1 ; a < arguments.length ; a++ )
  {
    let srcMap = arguments[ a ];
    _.assert( !_.primitive.is( srcMap ), 'Expects non-primitive' );

    let srcProto = Object.getPrototypeOf( srcMap );
    if( srcProto === null || srcProto === Object.prototype )
    Object.assign( dstMap, srcMap );
    else
    this._extendUniversal( dstMap, srcMap );

  }

  return dstMap;
}

//

/**
 * The extend() is used to copy the values of all properties
 * from one or more source objects to a target object.
 *
 * It takes first object (dstMap)
 * creates variable (result) and assign first object.
 * Checks if arguments equal two or more and if (result) is an object.
 * If true,
 * it extends (result) from the next objects.
 *
 * @param{ objectLike } dstMap - The target object.
 * @param{ ...objectLike } arguments[] - The source object(s).
 *
 * @example
 * _.map.extend( { a : 7, b : 13 }, { c : 3, d : 33 }, { e : 77 } );
 * // returns { a : 7, b : 13, c : 3, d : 33, e : 77 }
 *
 * @returns { objectLike } It will return the target object.
 * @function extend
 * @throws { Error } Will throw an error if ( arguments.length < 2 ),
 * if the (dstMap) is not an Object.
 * @namespace Tools/props
 */

function extend( dstMap, srcMap )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  if( arguments.length === 2 )
  {
    let srcProto = Object.getPrototypeOf( srcMap );
    if( srcProto === null || srcProto === Object.prototype )
    return Object.assign( dstMap, srcMap );
  }

  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  _.assert( this.like( dstMap ), () => `Expects dstMap::${this.NamespaceName} as the first argument` );

  for( let a = 1 ; a < arguments.length ; a++ )
  {
    let srcMap = arguments[ a ];

    _.assert( !_.primitive.is( srcMap ), 'Expects non-primitive' );

    let srcProto = Object.getPrototypeOf( srcMap );
    if( srcProto === null || srcProto === Object.prototype )
    Object.assign( dstMap, srcMap );
    else
    this._extendWithProps( dstMap, srcMap );

  }

  return dstMap;
}

//

function _supplementWithHashmap( dstMap, src )
{
  for( let [ key, val ] of src )
  if( !( key in dstMap ) )
  dstMap[ key ] = val;
  return dstMap;
}

//

function _supplementWithSet( dstMap, src )
{
  for( let key of src )
  if( !( key in dstMap ) )
  dstMap[ key ] = key;
  return dstMap;
}

//

function _supplementWithCountable( dstMap, src )
{
  for( let e of src )
  {
    _.assert( e.length === 2 );
    if( !( e[ 0 ] in dstMap ) )
    dstMap[ e[ 0 ] ] = e[ 1 ];
  }
  return dstMap;
}

//

function _supplementWithProps( dstMap, src )
{
  for( let k in src )
  if( !( k in dstMap ) )
  dstMap[ k ] = src[ k ];
  return dstMap;
}

//

function _supplementUniversal( dstMap, srcMap )
{

  _.assert( !_.primitive.is( srcMap ), 'Expects non-primitive' );

  let srcProto = Object.getPrototypeOf( srcMap );
  if( srcProto === null || srcProto === Object.prototype )
  Object.assign( dstMap, srcMap );
  else if( _.hashMap.like( srcMap ) )
  this._supplementWithHashmap( dstMap, srcMap ); /* qqq : cover */
  else if( _.set.like( srcMap ) )
  this._supplementWithSet( dstMap, srcMap ); /* qqq : cover */
  else if( _.long.like( srcMap ) )
  this._supplementWithCountable( dstMap, srcMap ); /* qqq : cover */
  else
  this._supplementWithProps( dstMap, srcMap ); /* qqq : cover */

  return dstMap;
}

//

function supplementUniversal( dstMap, srcMap )
{
  if( dstMap === null && arguments.length === 2 )
  return Object.assign( Object.create( null ), srcMap );

  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  _.assert( this.like( dstMap ), () => `Expects dstMap::${this.NamespaceName} as the first argument` );

  for( let a = 1 ; a < arguments.length ; a++ )
  {
    srcMap = arguments[ a ];
    this._supplementWithProps( dstMap, srcMap );
  }

  return dstMap
}

//

/**
 * The supplement() supplement destination map by source maps.
 * Pairs of destination map are not overwritten by pairs of source maps if any overlap.
 * Routine rewrite pairs of destination map which has key === undefined.
 *
 * @param { ...objectLike } arguments[] - The source object(s).
 *
 * @example
 * _.map.supplement( { a : 1, b : 2 }, { a : 1, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @returns { objectLike } Returns an object with unique [ key, value ].
 * @function supplement
 * @namespace Tools/props
 */

function supplement( dstMap, srcMap )
{
  if( dstMap === null && arguments.length === 2 )
  return Object.assign( Object.create( null ), srcMap );
  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  _.assert( this.like( dstMap ), () => `Expects dstMap::${this.NamespaceName} as the first argument` );

  for( let a = 1 ; a < arguments.length ; a++ )
  {
    srcMap = arguments[ a ];
    this._supplementWithProps( dstMap, srcMap );
  }

  return dstMap
}

// --
// properties
// --

function _keys( o )
{
  let result = [];

  _.routine.options( _keys, o );

  let srcMap = o.srcMap;
  let selectFilter = o.selectFilter;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( this.like( srcMap ) );
  _.assert( selectFilter === null || _.routine.is( selectFilter ) );

  /* */

  if( o.onlyEnumerable )
  {
    let result1 = [];

    if( o.onlyOwn )
    {
      for( let k in srcMap )
      if( Object.hasOwnProperty.call( srcMap, k ) )
      result1.push( k );
    }
    else
    {
      for( let k in srcMap )
      result1.push( k );
    }

    filter( srcMap, result1 );

  }
  else
  {

    if( o.onlyOwn  )
    {
      filter( srcMap, Object.getOwnPropertyNames( srcMap ) );
    }
    else
    {
      let proto = srcMap;
      result = [];
      do
      {
        filter( proto, Object.getOwnPropertyNames( proto ) );
        proto = Object.getPrototypeOf( proto );
      }
      while( proto );
    }

  }

  return result;

  /* */

  function filter( srcMap, keys )
  {

    if( !selectFilter )
    {
      /* qqq : for junior : rewrite without arrayAppend and without duplicating array */
      arrayAppendArrayOnce( result, keys );
    }
    else for( let k = 0 ; k < keys.length ; k++ )
    {
      let e = selectFilter( srcMap, keys[ k ] );
      if( e !== undefined )
      arrayAppendOnce( result, e );
      /* qqq : for junior : rewrite without arrayAppend and without duplicating array */
    }

  }

  /* */

  function arrayAppendOnce( dst, element )
  {
    let i = dst.indexOf( element );
    if( i === -1 )
    dst.push( element );
    return dst;
  }

  /* */

  function arrayAppendArrayOnce( dst, src )
  {
    src.forEach( ( element ) =>
    {
      let i = dst.indexOf( element );
      if( i === -1 )
      dst.push( element );
    });
    return dst;
  }

  /* */

}

_keys.defaults =
{
  srcMap : null,
  onlyOwn : 0,
  onlyEnumerable : 1,
  selectFilter : null,
}

//

/**
 * This routine returns an array of a given objects onlyEnumerable properties,
 * in the same order as that provided by a for...in loop.
 * Accept single object. Each element of result array is unique.
 * Unlike standard [Object.keys]{@https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/keys}
 * which accept object only props.keys accept any object-like entity.
 *
 * @see {@link wTools.props.onlyOwnKeys} - Similar routine taking into account own elements only.
 * @see {@link wTools.props.vals} - Similar routine returning values.
 *
 * @example
 * _.props.keys({ a : 7, b : 13 });
 * // returns [ "a", "b" ]
 *
 * @example
 * let o = { onlyOwn : 1, onlyEnumerable : 0 };
 * _.props.keys.call( o, { a : 1 } );
 * // returns [ "a" ]
 *
 * @param { objectLike } srcMap - object of interest to extract keys.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyOwn = false ] - count only object`s own properties.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 * @return { array } Returns an array with unique string elements.
 * corresponding to the onlyEnumerable properties found directly upon object or empty array
 * if nothing found.
 * @function keys
 * @throws { Exception } Throw an exception if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools/props
 */

function keys( srcMap, o )
{
  let result;

  // _.assert( this === _.object );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( keys, o || null );
  // _.assert( !_.primitive.is( srcMap ) );

  o.srcMap = srcMap;

  result = this._keys( o );

  return result;
}

keys.defaults =
{
  onlyOwn : 0,
  onlyEnumerable : 1,
}

//

/**
 * The props.onlyOwnKeys() returns an array of a given object`s own enumerable properties,
 * in the same order as that provided by a for...in loop. Each element of result array is unique.
 *
 * @param { objectLike } srcMap - The object whose properties keys are to be returned.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.onlyOwnKeys({ a : 7, b : 13 });
 * // returns [ "a", "b" ]
 *
 * @example
 * let o = { onlyEnumerable : 0 };
 * _.props.onlyOwnKeys.call( o, { a : 1 } );
 * // returns [ "a" ]

 *
 * @return { array } Returns an array whose elements are strings
 * corresponding to the own onlyEnumerable properties found directly upon object or empty
 * array if nothing found.
 * @function onlyOwnKeys
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools/props
*/

function onlyOwnKeys( srcMap, o )
{
  let result;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyOwnKeys, o || null );
  _.assert( this.like( srcMap ) );

  o.srcMap = srcMap;
  o.onlyOwn = 1;

  result = this._keys( o );

  if( !o.onlyEnumerable )
  debugger;

  return result;
}

onlyOwnKeys.defaults =
{
  onlyEnumerable : 1,
}

//

function onlyEnumerableKeys( srcMap, o )
{
  let result;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyEnumerableKeys, o || null );
  _.assert( this.like( srcMap ) );

  o.srcMap = srcMap;
  o.onlyEnumerable = 1;

  result = this._keys( o );

  return result;
}

onlyEnumerableKeys.defaults =
{
  onlyOwn : 0,
}

//

/**
 * The props.allKeys() returns all properties of provided object as array,
 * in the same order as that provided by a for...in loop. Each element of result array is unique.
 *
 * @param { objectLike } srcMap - The object whose properties keys are to be returned.
 *
 * @example
 * let x = { a : 1 };
 * let y = { b : 2 };
 * Object.setPrototypeOf( x, y );
 * _.props.allKeys( x );
 * // returns [ "a", "b", "__defineGetter__", ... "isPrototypeOf" ]
 *
 * @return { array } Returns an array whose elements are strings
 * corresponding to the all properties found on the object.
 * @function allKeys
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @namespace Tools/props
*/

function allKeys( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( allKeys, o || null );

  o.srcMap = srcMap;

  let result = this._keys( o );

  return result;
}

/* qqq : write test routine for each option */
/* qqq : do the same for similar routines */
/* qqq : adjust similar routine if they handle options no like routine allKeys */
allKeys.defaults =
{
  onlyOwn : 0,
  onlyEnumerable : 0,
}

//

function _vals( o )
{

  _.routine.options( _vals, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.selectFilter === null || _.routine.is( o.selectFilter ) );
  _.assert( o.selectFilter === null );

  let result = this._keys( o );

  for( let k = 0 ; k < result.length ; k++ )
  {
    result[ k ] = o.srcMap[ result[ k ] ];
  }

  return result;
}

_vals.defaults =
{
  srcMap : null,
  onlyOwn : 0,
  onlyEnumerable : 1,
  selectFilter : null,
}

//

/**
 * The props.vals() routine returns an array of a given object's
 * onlyEnumerable property values, in the same order as that provided by a for...in loop.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns an array of values,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - The object whose property values are to be returned.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyOwn = false ] - count only object`s own properties.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.vals( { a : 7, b : 13 } );
 * // returns [ "7", "13" ]
 *
 * @example
 * let o = { onlyOwn : 1 };
 * let a = { a : 7 };
 * let b = { b : 13 };
 * Object.setPrototypeOf( a, b );
 * _.props.vals.call( o, a )
 * // returns [ 7 ]
 *
 * @returns { array } Returns an array whose elements are strings.
 * corresponding to the onlyEnumerable property values found directly upon object.
 * @function vals
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools/props
 */

function vals( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( vals, o || null );
  o.srcMap = srcMap;

  let result = this._vals( o );

  return result;
}

vals.defaults =
{
  onlyOwn : 0,
  onlyEnumerable : 1,
}

//

/**
 * The props.onlyOwnVals() routine returns an array of a given object's
 * own onlyEnumerable property values,
 * in the same order as that provided by a for...in loop.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns an array of values,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - The object whose property values are to be returned.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.onlyOwnVals( { a : 7, b : 13 } );
 * // returns [ "7", "13" ]
 *
 * @example
 * let o = { onlyEnumerable : 0 };
 * let a = { a : 7 };
 * Object.defineProperty( a, 'x', { onlyEnumerable : 0, value : 1 } )
 * _.props.onlyOwnVals.call( o, a )
 * // returns [ 7, 1 ]
 *
 * @returns { array } Returns an array whose elements are strings.
 * corresponding to the onlyEnumerable property values found directly upon object.
 * @function onlyOwnVals
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools/props
 */

function onlyOwnVals( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyOwnVals, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 1;

  let result = this._vals( o );

  return result;
}

onlyOwnVals.defaults =
{
  onlyEnumerable : 1,
}

//

function onlyEnumerableVals( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyEnumerableVals, o || null );

  o.srcMap = srcMap;
  o.onlyEnumerable = 1;

  let result = this._vals( o );

  return result;
}

onlyEnumerableVals.defaults =
{
  onlyOwn : 0,
}

//

/**
 * The props.allVals() returns values of all properties of provided object as array,
 * in the same order as that provided by a for...in loop.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns an array of values,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - The object whose property values are to be returned.
 *
 * @example
 * _.props.allVals( { a : 7, b : 13 } );
 * // returns [ "7", "13", function __defineGetter__(), ... function prototype.isPrototypeFor() ]
 *
 * @returns { array } Returns an array whose elements are strings.
 * corresponding to the onlyEnumerable property values found directly upon object.
 * @function allVals
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @namespace Tools/props
 */

function allVals( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( allVals, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 0;
  o.onlyEnumerable = 0;

  let result = this._vals( o );

  debugger;
  return result;
}

allVals.defaults =
{
}

//

function _pairs( o )
{

  _.routine.options( _pairs, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.selectFilter === null || _.routine.is( o.selectFilter ) );
  _.assert( this.like( o.srcMap ) );

  let selectFilter = o.selectFilter;

  if( o.selectFilter )
  debugger;

  if( !o.selectFilter )
  o.selectFilter = function selectFilter( srcMap, k )
  {
    return [ k, srcMap[ k ] ];
  }

  let result = this._keys( o );

  return result;
}

_pairs.defaults =
{
  srcMap : null,
  onlyOwn : 0,
  onlyEnumerable : 1,
  selectFilter : null,
}

//

/**
 * The map.pairs() converts an object into a list of unique [ key, value ] pairs.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns a list of [ key, value ] pairs if they exist,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - Object to get a list of [ key, value ] pairs.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyOwn = false ] - count only object`s own properties.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.map.pairs( { a : 7, b : 13 } );
 * // returns [ [ "a", 7 ], [ "b", 13 ] ]
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.map.pairs.call( { onlyOwn : 1 }, a );
 * // returns [ [ "a", 1 ] ]
 *
 * @returns { array } A list of [ key, value ] pairs.
 * @function pairs
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools/props
 */

function pairs( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( pairs, o || null );

  o.srcMap = srcMap;

  let result = this._pairs( o );

  return result;
}

pairs.defaults =
{
  onlyOwn : 0,
  onlyEnumerable : 1,
}

//

/**
 * The props.pairs() converts an object's own properties into a list of [ key, value ] pairs.
 *
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns a list of [ key, value ] pairs of object`s own properties if they exist,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - Object to get a list of [ key, value ] pairs.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.pairs( { a : 7, b : 13 } );
 * // returns [ [ "a", 7 ], [ "b", 13 ] ]
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.props.pairs( a );
 * // returns [ [ "a", 1 ] ]
 *
 * @example
 * let a = { a : 1 };
 * _.props.pairs.call( { onlyEnumerable : 0 }, a );
 *
 * @returns { array } A list of [ key, value ] pairs.
 * @function onlyOwnPairs
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools/props
 */

function onlyOwnPairs( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyOwnPairs, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 1;

  let result = this._pairs( o );

  debugger;
  return result;
}

onlyOwnPairs.defaults =
{
  onlyEnumerable : 1,
}

//

function onlyEnumerablePairs( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyEnumerablePairs, o || null );

  o.srcMap = srcMap;
  o.onlyEnumerable = 1;

  let result = this._pairs( o );

  debugger;
  return result;
}

onlyEnumerablePairs.defaults =
{
  onlyOwn : 0,
}

//

/**
 * The props.allPairs() converts all properties of the object {-srcMap-} into a list of unique [ key, value ] pairs.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns a list of [ key, value ] pairs that repesents all properties of provided object{-srcMap-},
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - Object to get a list of [ key, value ] pairs.
 *
 * @example
 * _.props.allPairs( { a : 7, b : 13 } );
 * // returns [ [ "a", 7 ], [ "b", 13 ], ... [ "isPrototypeOf", function prototype.isPrototypeFor() ] ]
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.props.allPairs( a );
 * // returns [ [ "a", 1 ], [ "b", 2 ], ... [ "isPrototypeOf", function prototype.isPrototypeFor() ]  ]
 *
 * @returns { array } A list of [ key, value ] pairs.
 * @function allPairs
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @namespace Tools/props
 */

function allPairs( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( allPairs, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 0;
  o.onlyEnumerable = 0;

  let result = this._pairs( o );

  return result;
}

allPairs.defaults =
{
}

// --
//
// --

function _ofAct( o )
{
  let result = Object.create( null );

  _.routine.options( _ofAct, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( this === _.props );
  _.assert( this.like( o.srcMap ) );

  let keys = this._keys( o );

  for( let k = 0 ; k < keys.length ; k++ )
  {
    result[ keys[ k ] ] = o.srcMap[ keys[ k ] ];
  }

  return result;
}

_ofAct.defaults =
{
  srcMap : null,
  onlyOwn : 0,
  onlyEnumerable : 1,
  selectFilter : null,
}

//

/**
 * Routine property.of() gets onlyEnumerable properties of the object{-srcMap-} and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies unique onlyEnumerable properties of the provided object to the new map using
 * their original name/value and returns the result,
 * otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of onlyEnumerable properties.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyOwn = false ] - count only object`s onlyOwn properties.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.of( { a : 7, b : 13 } );
 * // returns { a : 7, b : 13 }
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.props.of( a );
 * // returns { a : 1, b : 2 }
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.props.of.conlyExplicit( { onlyOwn : 1 }, a )
 * // returns { a : 1 }
 *
 * @returns { object } A new map with unique onlyEnumerable properties from source{-srcMap-}.
 * @function of
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools
 */

function _of( srcMap, o )
{
  _.assert( this === _.props );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( _of, o || null );

  o.srcMap = srcMap;

  let result = _.props._ofAct( o );
  return result;
}

_of.defaults =
{
  onlyOwn : 0,
  onlyEnumerable : 1,
}

//

/**
 * The onlyOwn() gets the object's {-srcMap-} onlyOwn onlyEnumerable properties and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies object's onlyOwn onlyEnumerable properties to the new map using
 * their original name/value and returns the result,
 * otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of object`s onlyOwn onlyEnumerable properties.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.onlyOwn( { a : 7, b : 13 } );
 * // returns { a : 7, b : 13 }
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.props.onlyOwn( a );
 * // returns { a : 1 }
 *
 * @example
 * let a = { a : 1 };
 * Object.defineProperty( a, 'b', { onlyEnumerable : 0, value : 2 } );
 * _.props.onlyOwn.conlyExplicit( { onlyEnumerable : 0 }, a )
 * // returns { a : 1, b : 2 }
 *
 * @returns { object } A new map with source {-srcMap-} onlyOwn onlyEnumerable properties.
 * @function onlyOwn
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools
 */

function onlyOwn( srcMap, o )
{

  _.assert( this === _.props );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyOwn, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 1;

  let result = _.props._ofAct( o );
  return result;
}

onlyOwn.defaults =
{
  onlyEnumerable : 1,
}

//

/**
 * The onlyExplicit() gets onlyExplicit properties from provided object {-srcMap-} and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies onlyExplicit unique object's properties to the new map using
 * their original name/value and returns the result,
 * otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of onlyExplicit object`s properties.
 *
 * @example
 * _.props.onlyExplicit( { a : 7, b : 13 } );
 * // returns { a : 7, b : 13, __defineGetter__ : function...}
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.props.onlyExplicit( a );
 * // returns { a : 1, b : 2, __defineGetter__ : function...}
 *
 * @returns { object } A new map with onlyExplicit unique properties from source {-srcMap-}.
 * @function onlyExplicit
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools
 */

function onlyExplicit( srcMap, o )
{

  _.assert( this === _.props );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyExplicit, o || null );

  o.srcMap = srcMap;
  let result = _.props._ofAct( o );

  return result;
}

onlyExplicit.defaults =
{
  onlyOwn : 0,
  onlyEnumerable : 0,
}

//

/**
 * The routines() gets onlyEnumerable properties that contains routines as value from the object {-srcMap-} and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies unique onlyEnumerable properties that holds routines from source {-srcMap-} to the new map using
 * original name/value of the property and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of object`s properties.
 * @param { objectLike } o - routine options, can be provided through routine`s context.
 * @param { boolean } [ o.onlyOwn = false ] - count only object`s onlyOwn properties.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.routines( { a : 7, b : 13, f : function(){} } );
 * // returns { f : function(){} }
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2, f : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.props.routines( a )
 * // returns { f : function(){} }
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2, f : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.props.routines.conlyExplicit( { onlyOwn : 1 }, a )
 * // returns {}
 *
 * @returns { object } A new map with unique onlyEnumerable routine properties from source {-srcMap-}.
 * @function routines
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools
 */


function routines( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( this === _.props );
  o = _.routine.options( routines, o || null );

  o.srcMap = srcMap;
  o.selectFilter = function selectRoutine( srcMap, k )
  {
    debugger;
    if( _.routine.is( srcMap[ k ] ) )
    return k;
    debugger;
  }

  debugger;
  let result = _.props._ofAct( o );
  return result;
}

routines.defaults =
{
  onlyOwn : 0,
  onlyEnumerable : 1,
}

//

/**
 * The onlyOwnRoutines() gets object`s {-srcMap-} onlyOwn onlyEnumerable properties that contains routines as value and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies object`s {-srcMap-} onlyOwn unique onlyEnumerable properties that holds routines to the new map using
 * original name/value of the property and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of object`s properties.
 * @param { objectLike } o - routine options, can be provided through routine`s context.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.onlyOwnRoutines( { a : 7, b : 13, f : function(){} } );
 * // returns { f : function(){} }
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2, f : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.props.onlyOwnRoutines( a )
 * // returns {}
 *
 * @example
 * let a = { a : 1 };
 * Object.defineProperty( a, 'b', { onlyEnumerable : 0, value : function(){} } );
 * _.props.onlyOwnRoutines.conlyExplicit( { onlyEnumerable : 0 }, a )
 * // returns { b : function(){} }
 *
 * @returns { object } A new map with unique object`s onlyOwn onlyEnumerable routine properties from source {-srcMap-}.
 * @function onlyOwnRoutines
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools
 */

function onlyOwnRoutines( srcMap, o )
{

  _.assert( this === _.props );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyOwnRoutines, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 1;
  o.selectFilter = function selectRoutine( srcMap, k )
  {
    debugger;
    if( _.routine.is( srcMap[ k ] ) )
    return k;
    debugger;
  }

  debugger;
  let result = _.props._ofAct( o );
  return result;
}

onlyOwnRoutines.defaults =
{
  onlyEnumerable : 1,
}

//

/**
 * The onlyExplicitRoutines() gets onlyExplicit properties of object {-srcMap-} that contains routines as value and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies onlyExplicit unique properties of source {-srcMap-} that holds routines to the new map using
 * original name/value of the property and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of object`s properties.
 *
 * @example
 * _.props.onlyExplicitRoutines( { a : 7, b : 13, f : function(){} } );
 * // returns { f : function, __defineGetter__ : function...}
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2, f : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.props.onlyExplicitRoutines( a )
 * // returns { f : function, __defineGetter__ : function...}
 *
 * @returns { object } A new map with onlyExplicit unique object`s {-srcMap-} properties that are routines.
 * @function onlyExplicitRoutines
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools
 */

function onlyExplicitRoutines( srcMap, o )
{

  _.assert( this === _.props );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyExplicitRoutines, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 0;
  o.onlyEnumerable = 0;
  o.selectFilter = function selectRoutine( srcMap, k )
  {
    if( _.routine.is( srcMap[ k ] ) )
    return k;
  }

  let result = _.props._ofAct( o );
  return result;
}

onlyExplicitRoutines.defaults =
{
}

//

/**
 * The fields() gets onlyEnumerable fields( onlyExplicit properties except routines ) of the object {-srcMap-} and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies unique onlyEnumerable properties of the provided object {-srcMap-} that are not routines to the new map using
 * their original name/value and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of onlyEnumerable properties.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyOwn = false ] - count only object`s onlyOwn properties.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.fields( { a : 7, b : 13, c : function(){} } );
 * // returns { a : 7, b : 13 }
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2, c : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.props.fields( a );
 * // returns { a : 1, b : 2 }
 *
 * @example
 * let a = { a : 1, x : function(){} };
 * let b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.props.fields.conlyExplicit( { onlyOwn : 1 }, a )
 * // returns { a : 1 }
 *
 * @returns { object } A new map with unique onlyEnumerable fields( onlyExplicit properties except routines ) from source {-srcMap-}.
 * @function fields
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools
 */

function fields( srcMap, o )
{

  _.assert( this === _.props );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( fields, o || null );

  o.srcMap = srcMap;
  o.selectFilter = function selectRoutine( srcMap, k )
  {
    if( !_.routine.is( srcMap[ k ] ) )
    return k;
  }

  let result = _.props._ofAct( o );
  return result;
}

fields.defaults =
{
  onlyOwn : 0,
  onlyEnumerable : 1,
}

//

/**
 * The onlyOwnFields() gets object`s {-srcMap-} onlyOwn onlyEnumerable fields( onlyExplicit properties except routines ) and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies object`s onlyOwn onlyEnumerable properties that are not routines to the new map using
 * their original name/value and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of onlyEnumerable properties.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.onlyEnumerable = true ] - count only object`s onlyEnumerable properties.
 *
 * @example
 * _.props.onlyOwnFields( { a : 7, b : 13, c : function(){} } );
 * // returns { a : 7, b : 13 }
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2, c : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.props.onlyOwnFields( a );
 * // returns { a : 1 }
 *
 * @example
 * let a = { a : 1, x : function(){} };
 * Object.defineProperty( a, 'b', { onlyEnumerable : 0, value : 2 } )
 * _.props.fields.conlyExplicit( { onlyEnumerable : 0 }, a )
 * // returns { a : 1, b : 2 }
 *
 * @returns { object } A new map with object`s {-srcMap-} onlyOwn onlyEnumerable fields( onlyExplicit properties except routines ).
 * @function onlyOwnFields
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools
 */

function onlyOwnFields( srcMap, o )
{

  _.assert( this === _.props );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyOwnFields, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 1;
  o.selectFilter = function selectRoutine( srcMap, k )
  {
    if( !_.routine.is( srcMap[ k ] ) )
    return k;
  }

  let result = _.props._ofAct( o );
  return result;
}

onlyOwnFields.defaults =
{
  onlyEnumerable : 1,
}

//

/**
 * The onlyExplicitFields() gets onlyExplicit object`s {-srcMap-} fields( properties except routines ) and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies onlyExplicit object`s properties that are not routines to the new map using
 * their original name/value and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of onlyExplicit properties.
 *
 * @example
 * _.props.onlyExplicitFields( { a : 7, b : 13, c : function(){} } );
 * // returns { a : 7, b : 13, __proto__ : Object }
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2, c : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.props.onlyExplicitFields( a );
 * // returns { a : 1, b : 2, __proto__ : Object }
 *
 * @example
 * let a = { a : 1, x : function(){} };
 * Object.defineProperty( a, 'b', { onlyEnumerable : 0, value : 2 } )
 * _.props.onlyExplicitFields( a );
 * // returns { a : 1, b : 2, __proto__ : Object }
 *
 * @returns { object } A new map with onlyExplicit fields( properties except routines ) from source {-srcMap-}.
 * @function onlyExplicitFields
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @namespace Tools
 */

function onlyExplicitFields( srcMap, o )
{

  _.assert( this === _.props );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( onlyExplicitFields, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 0;
  o.onlyEnumerable = 0;
  o.selectFilter = function selectRoutine( srcMap, k )
  {
    if( !_.routine.is( srcMap[ k ] ) )
    return k;
  }

  if( _.routine.is( srcMap ) )
  o.selectFilter = function selectRoutine( srcMap, k )
  {
    if( _.longHas( [ 'arguments', 'conlyExpliciter' ], k ) )
    return;
    if( !_.routine.is( srcMap[ k ] ) )
    return k;
  }

  let result = _.props._ofAct( o );
  return result;
}

onlyExplicitFields.defaults =
{
}

//

function own( src, key )
{
  // if( src === null )
  // return false;
  // if( src === undefined )
  // return false;
  if( _.primitive.is( src ) )
  return false;
  return Object.hasOwnProperty.call( src, key );
}

//

function has( src, key )
{
  if( _.primitive.is( src ) )
  return false;
  if( !Reflect.has( src, key ) )
  return false;
  return true;
}

//

function ownEnumerable( src, key )
{
  if( _.primitive.is( src ) )
  return false;

  let descriptor = Object.getOwnPropertyDescriptor( src, key );

  if( !descriptor )
  return false;

  debugger;

  return !!descriptor.enumerable
}

//

function hasEnumerable( src, key )
{
  if( _.primitive.is( src ) )
  return false;

  let found = _.props.descriptorOf( src, key );

  debugger;

  if( !found.descriptor )
  return false;

  return !!found.descriptor.enumerable
}

//

function descriptorActiveOf( object, name )
{
  let result = Object.create( null );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !!object, 'No object' );

  do
  {
    let descriptor = Object.getOwnPropertyDescriptor( object, name );
    if( descriptor && !( 'value' in descriptor ) )
    {
      result.descriptor = descriptor;
      result.object = object;
      return result;
    }
    object = Object.getPrototypeOf( object );
  }
  while( object );

  return result;
}

//

function descriptorOf( object, name )
{
  let result = Object.create( null );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  do
  {
    let descriptor = Object.getOwnPropertyDescriptor( object, name );
    if( descriptor )
    {
      result.descriptor = descriptor;
      result.object = object;
      return result;
    }
    object = Object.getPrototypeOf( object );
  }
  while( object );

  return result;
}

//

function descriptorOwnOf( object, name )
{
  return Object.getOwnPropertyDescriptor( object, name );
}

// --
// meta
// --

/* qqq : optimize */
function namespaceOf( src )
{

  if( _.map.is( src ) )
  return _.map;
  if( _.aux.is( src ) )
  return _.aux;
  if( _.object.is( src ) )
  return _.object;
  if( _.props.is( src ) )
  return _.props;

  return null;
}

// --
// props extension
// --

let PropsExtension =
{

  //

  NamespaceName : 'props',
  NamespaceNames : [ 'props' ],
  NamespaceQname : 'wTools/props',
  MoreGeneralNamespaceName : 'props',
  MostGeneralNamespaceName : 'props',
  TypeName : 'Props',
  TypeNames : [ 'Props', 'Properties' ],
  // SecondTypeName : 'Properties',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  is,
  like,
  IsResizable,

  // maker

  _makeEmpty,
  makeEmpty, /* qqq : for junior : cover */
  _makeUndefined,
  makeUndefined, /* qqq : for junior : cover */
  _make,
  make, /* qqq : for junior : cover */
  _cloneShallow,
  cloneShallow, /* qqq : for junior : cover */
  from,

  // amender

  _extendWithHashmap,
  _extendWithSet,
  _extendWithCountable,
  _extendWithProps,
  _extendUniversal,
  extendUniversal,
  extend,

  _supplementWithHashmap,
  _supplementWithSet,
  _supplementWithCountable,
  _supplementWithProps,
  _supplementUniversal,
  supplementUniversal,
  supplement,

  // properties

  _keys,
  keys, /* qqq : for junior : cover */
  onlyOwnKeys, /* qqq : for junior : cover */
  onlyEnumerableKeys, /* qqq : for junior : implement and cover properly */
  allKeys, /* qqq : for junior : cover */

  _vals,
  vals, /* qqq : for junior : cover */
  onlyOwnVals, /* qqq : for junior : cover */
  onlyEnumerableVals, /* qqq : for junior : implement and cover properly */
  allVals, /* qqq : for junior : cover */

  _pairs, /* qqq : for junior : cover */
  pairs, /* qqq : for junior : cover */
  onlyOwnPairs, /* qqq : for junior : cover */
  onlyEnumerablePairs, /* qqq : for junior : implement and cover properly */
  allPairs, /* qqq : for junior : cover */

  _ofAct,
  of : _of,
  onlyOwn,
  onlyExplicit,

  routines,
  onlyOwnRoutines,
  onlyExplicitRoutines,

  fields,
  onlyOwnFields,
  onlyExplicitFields,

  own, /* qqq : cover please */
  has, /* qqq : cover please */
  ownEnumerable, /* qqq : cover please */
  hasEnumerable, /* qqq : cover please */

  // propertyDescriptorActiveGet,
  // propertyDescriptorGet,
  descriptorActiveOf, /* qqq : cover please */
  descriptorOf, /* qqq : cover please */
  descriptorOwnOf,

  // meta

  namespaceOf,
  namespaceWithDefaultOf : _.long.namespaceWithDefaultOf,
  _functor_functor : _.long._functor_functor,

}

//

Object.assign( _.props, PropsExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  // dichotomy

  propsIs : is.bind( _.props ),
  propsLike : like.bind( _.props ),

  // maker

  propsMakeEmpty : makeEmpty.bind( _.props ),
  propsMakeUndefined : makeUndefined.bind( _.props ),
  propsMake : make.bind( _.props ),
  propsCloneShallow : cloneShallow.bind( _.props ),
  propsFrom : from.bind( _.props ),

  // amender

  propsExtend : extend.bind( _.props ),
  propsSupplement : supplement.bind( _.props ),

}

//

Object.assign( _, ToolsExtension );

})();

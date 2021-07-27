( function _l1_Map_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.map = _.map || Object.create( null );

_.assert( !!_.props.extend, 'Expects routine _.props.exportString' );

// --
// dichotomy
// --

/**
 * The is() routine determines whether the passed value is an Object,
 * and not inherits through the prototype chain.
 *
 * If the {-srcMap-} is an Object, true is returned,
 * otherwise false is.
 *
 * @param { * } src - Entity to check.
 *
 * @example
 * _.map.is( { a : 7, b : 13 } );
 * // returns true
 *
 * @example
 * _.map.is( 13 );
 * // returns false
 *
 * @example
 * _.map.is( [ 3, 7, 13 ] );
 * // returns false
 *
 * @returns { Boolean } Returns true if {-srcMap-} is an Object, and not inherits through the prototype chain.
 * @function is
 * @namespace Tools/map
 */

function is( src )
{

  if( !src )
  return false;

  let proto = Object.getPrototypeOf( src );

  if( proto === null )
  return true;

  if( proto === Object.prototype )
  {
    if( src[ Symbol.iterator ] )
    return Object.prototype.toString.call( src ) !== '[object Arguments]';
    return true;
  }

  return false;
}

//

function isPure( src )
{
  if( !src )
  return false;

  if( Object.getPrototypeOf( src ) === null )
  return true;

  return false;
}

//

function isPolluted( src )
{

  if( !src )
  return false;

  let proto = Object.getPrototypeOf( src );

  if( proto === null )
  return false;

  if( proto === Object.prototype )
  {
    if( src[ Symbol.iterator ] )
    return Object.prototype.toString.call( src ) !== '[object Arguments]';
    return true;
  }

  return false;
}

// function is( src )
// {
//
//   if( !src )
//   return false;
//
//   if( src[ Symbol.iterator ] )
//   return false;
//
//   let proto = Object.getPrototypeOf( src );
//
//   if( proto === null )
//   return true;
//
//   if( proto === Object.prototype )
//   return true;
//
//   return false;
// }
//
// //
//
// function isPure( src )
// {
//   if( !src )
//   return false;
//
//   if( src[ Symbol.iterator ] )
//   return false;
//
//   if( Object.getPrototypeOf( src ) === null )
//   return true;
//
//   return false;
// }
//
// //
//
// function isPolluted( src )
// {
//
//   if( !src )
//   return false;
//
//   if( src[ Symbol.iterator ] )
//   return false;
//
//   let proto = Object.getPrototypeOf( src );
//
//   if( proto === null )
//   return false;
//
//   if( proto === Object.prototype )
//   return true;
//
//   return false;
// }

//

function like( src )
{
  return _.map.is( src );
}

//

function isEmpty( src )
{
  if( !this.like( src ) )
  return false;
  return this.keys( src ).length === 0;
}

//

function isPopulated( src )
{
  if( !this.like( src ) )
  return false;
  return this.keys( src ).length > 0;
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
  return Object.create( null );
}

//

function makeEmpty( src )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( arguments.length === 1 )
  _.assert( this.like( src ) );
  return this._makeEmpty( src );
}

//

function _makeUndefined( src )
{
  return Object.create( null );
}

//

function makeUndefined( src, length )
{
  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  {
    _.assert( this.like( src ) );
    _.assert( _.number.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( _.number.is( src ) || this.like( src ) );
  }

  return this._makeUndefined( src );
}

//

function _make( src )
{
  let dst = Object.create( null );
  if( src )
  this.extendUniversal( dst, src );
  // if( src )
  // Object.assign( dst, src );
  return dst;
}

//

function make( src, length )
{
  _.assert( arguments.length === 0 || src === null || !_.primitive.is( src ) );
  _.assert( length === undefined || length === 0 );
  _.assert( arguments.length <= 2 );
  return this._make( ... arguments );
}

//

function _cloneShallow( src )
{
  let dst = Object.create( null );
  Object.assign( dst, src );
  return dst;
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

  _.assert( this === _.map );
  _.assert( arguments.length === 1, 'Expects single argument' );
  // _.assert( !( srcMap instanceof Map ), 'not implemented' );
  _.assert( selectFilter === null || _.routine.is( selectFilter ) );
  _.assert( this.is( srcMap ) );

  /* */

  if( o.onlyEnumerable )
  {
    let result1 = [];

    // _.assert( !_.primitive.is( srcMap ) );

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
    // _.assert( !( srcMap instanceof Map ), 'not implemented' );

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
      /* qqq : for junior : map cant have prototype. rewrite */
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
 * @namespace Tools/map
 */

function keys( srcMap, o )
{
  let result;

  _.assert( this === _.map );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( keys, o || null );
  _.assert( this.is( srcMap ) );

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
 * @namespace Tools/map
*/

function allKeys( srcMap, o )
{

  _.assert( this === _.map );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( allKeys, o || null );
  _.assert( this.is( srcMap ) );

  o.srcMap = srcMap;
  // o.onlyOwn = 0;
  // o.onlyEnumerable = 0;

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
  _.assert( this === _.map );

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
 * @namespace Tools/map
 */

function vals( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( vals, o || null );
  _.assert( this.is( srcMap ) );
  _.assert( this === _.map );

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
 * @namespace Tools/map
 */

function allVals( srcMap, o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( allVals, o || null );
  _.assert( this.is( srcMap ) );
  _.assert( this === _.map );

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
  _.assert( this === _.map );

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
 * @namespace Tools/map
 */

function pairs( srcMap, o )
{

  _.assert( this === _.map );
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
 * @namespace Tools/map
 */

function allPairs( srcMap, o )
{

  _.assert( this === _.map );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routine.options( allPairs, o || null );

  o.srcMap = srcMap;
  o.onlyOwn = 0;
  o.onlyEnumerable = 0;

  let result = this._pairs( o );

  debugger;
  return result;
}

allPairs.defaults =
{
}

// --
// meta
// --

/* qqq : optimize */
function namespaceOf( src )
{

  if( _.map.is( src ) )
  return _.map;

  return null;
}

// --
// extension
// --

/* qqq : for junior : duplicate routines */

let ToolsExtension =
{

  // dichotomy

  mapIs : is.bind( _.map ),
  mapIsPure : isPure.bind( _.map ),
  mapIsPolluted : isPolluted.bind( _.map ),
  mapIsEmpty : isEmpty.bind( _.map ),
  mapIsPopulated : isPopulated.bind( _.map ),
  mapLike : like.bind( _.map ),

  // maker

  mapMakeEmpty : makeEmpty.bind( _.map ),
  mapMakeUndefined : makeUndefined.bind( _.map ),
  mapMake : make.bind( _.map ),
  mapCloneShallow : _.props.cloneShallow.bind( _.map ),
  mapFrom : _.props.from.bind( _.map ),

  // amender

  mapExtend : _.props.extend.bind( _.map ),
  mapSupplement : _.props.supplement.bind( _.map ),

}

Object.assign( _, ToolsExtension );

//

let ExtensionMap =
{

  //

  NamespaceName : 'map',
  NamespaceNames : [ 'map' ],
  NamespaceQname : 'wTools/map',
  MoreGeneralNamespaceName : 'aux',
  MostGeneralNamespaceName : 'props',
  TypeName : 'Map',
  TypeNames : [ 'Map' ],
  // SecondTypeName : 'Map',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  is,
  isPure,
  isPolluted,
  like,

  isEmpty, /* qqq : cover */
  isPopulated, /* qqq : cover */
  IsResizable,

  // maker

  _makeEmpty,
  makeEmpty, /* qqq : for junior : cover */
  _makeUndefined,
  makeUndefined, /* qqq : for junior : cover */
  _make,
  make, /* qqq : for junior : cover */
  _cloneShallow,
  cloneShallow : _.props.cloneShallow, /* qqq : for junior : cover */
  from : _.props.from, /* qqq : for junior : cover */

  // properties

  _keys,
  keys, /* qqq : for junior : cover */
  // onlyEnumerableKeys, /* qqq : for junior : implement and cover properly */
  allKeys, /* qqq : for junior : cover */

  _vals,
  vals, /* qqq : for junior : cover */
  // onlyEnumerableVals, /* qqq : for junior : implement and cover properly */
  allVals, /* qqq : for junior : cover */

  _pairs,
  pairs, /* qqq : for junior : cover */
  // onlyEnumerablePairs, /* qqq : for junior : implement and cover properly */
  allPairs, /* qqq : for junior : cover */

  // amender

  _extendWithHashmap : _.props._extendWithHashmap,
  _extendWithSet : _.props._extendWithSet,
  _extendWithCountable : _.props._extendWithCountable,
  _extendWithProps : _.props._extendWithProps,
  _extendUniversal : _.props._extendUniversal,
  extendUniversal : _.props.extendUniversal,
  extend : _.props.extend,

  _supplementWithHashmap : _.props._supplementWithHashmap,
  _supplementWithSet : _.props._supplementWithSet,
  _supplementWithCountable : _.props._supplementWithCountable,
  _supplementWithProps : _.props._supplementWithProps,
  _supplementUniversal : _.props._supplementUniversal,
  supplementUniversal : _.props.supplementUniversal,
  supplement : _.props.supplement,

  // meta

  namespaceOf,
  namespaceWithDefaultOf : _.props.namespaceWithDefaultOf,
  _functor_functor : _.props._functor_functor,

}

Object.assign( _.map, ExtensionMap );

})();

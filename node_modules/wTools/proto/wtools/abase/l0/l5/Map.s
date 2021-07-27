( function _l5_Map_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

/* qqq for junior : check each _.aux.is() call, extend tests for each branch | aaa : Done. */
/* qqq for junior : check each !_.primitive.is() call, extend tests for each branch | aaa : Done. */
/* qqq for junior : check each _.vector.is() call, extend tests for each branch | aaa : Done. */

// --
// map selector
// --

/**
 * The mapFirstPair() routine returns first pair [ key, value ] as array.
 *
 * @param { objectLike } srcMap - An object like entity of get first pair.
 *
 * @example
 * _.mapFirstPair( { a : 3, b : 13 } );
 * // returns [ 'a', 3 ]
 *
 * @example
 * _.mapFirstPair( {  } );
 * // returns 'undefined'
 *
 * @example
 * _.mapFirstPair( [ [ 'a', 7 ] ] );
 * // returns [ '0', [ 'a', 7 ] ]
 *
 * @returns { Array } Returns pair [ key, value ] as array if {-srcMap-} has fields, otherwise, undefined.
 * @function mapFirstPair
 * @throws { Error } Will throw an Error if (arguments.length) less than one, if {-srcMap-} is not an object-like.
 * @namespace Tools
 */

function mapFirstPair( srcMap )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.object.like( srcMap ) );

  for( let s in srcMap )
  {
    return [ s, srcMap[ s ] ];
  }

  return [];
}

//

function mapAllValsSet( dstMap, val )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  for( let k in dstMap )
  {
    dstMap[ k ] = val;
  }

  return dstMap;
}

//

function mapValsWithKeys( srcMap, keys )
{
  let result = Object.create( null );

  _.assert( _.argumentsArray.like( keys ) );

  for( let k = 0 ; k < keys.length ; k++ )
  {
    let key = keys[ k ];
    _.assert( _.strIs( key ) || _.number.is( key ) );
    result[ key ] = srcMap[ key ];
  }

  return result;
}

//

/**
 * The mapValWithIndex() returns value of {-srcMap-} by corresponding (index).
 *
 * It takes {-srcMap-} and (index), creates a variable ( i = 0 ),
 * checks if ( index > 0 ), iterate over {-srcMap-} object-like and match
 * if ( i == index ).
 * If true, it returns value of {-srcMap-}.
 * Otherwise it increment ( i++ ) and iterate over {-srcMap-} until it doesn't match index.
 *
 * @param { objectLike } srcMap - An object-like.
 * @param { number } index - To find the position an element.
 *
 * @example
 * _.mapValWithIndex( [ 3, 13, 'c', 7 ], 3 );
 * // returns 7
 *
 * @returns { * } Returns value of {-srcMap-} by corresponding (index).
 * @function mapValWithIndex
 * @throws { Error } Will throw an Error if( arguments.length > 2 ) or {-srcMap-} is not an Object.
 * @namespace Tools
 */

function mapValWithIndex( srcMap, index )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( index < 0 )
  return;

  let i = 0;
  for( let s in srcMap )
  {
    if( i === index )
    return srcMap[ s ];
    i++;
  }
}

//

/**
 * The mapKeyWithIndex() returns key of {-srcMap-} by corresponding (index).
 *
 * It takes {-srcMap-} and (index), creates a variable ( i = 0 ),
 * checks if ( index > 0 ), iterate over {-srcMap-} object-like and match
 * if ( i == index ).
 * If true, it returns value of {-srcMap-}.
 * Otherwise it increment ( i++ ) and iterate over {-srcMap-} until it doesn't match index.
 *
 * @param { objectLike } srcMap - An object-like.
 * @param { number } index - To find the position an element.
 *
 * @example
 * _.mapKeyWithIndex( [ 'a', 'b', 'c', 'd' ], 1 );
 * // returns '1'
 *
 * @returns { string } Returns key of {-srcMap-} by corresponding (index).
 * @function mapKeyWithIndex
 * @throws { Error } Will throw an Error if( arguments.length > 2 ) or {-srcMap-} is not an Object.
 * @namespace Tools
 */

function mapKeyWithIndex( srcMap, index )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.number.intIs( index ) );
  _.assert( _.map.like( srcMap ) );

  if( index < 0 )
  return;

  let i = 0;
  for( let s in srcMap )
  {
    if( i === index )
    return s;
    i++;
  }
}

//

function mapKeyWithValue( srcMap, value )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.map.like( srcMap ) );

  for( let s in srcMap )
  if( srcMap[ s ] === value )
  return s;
}

//

// function mapIndexWithKey( srcMap, key )
// {
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   for( let s in srcMap )
//   {
//     if( s === key )
//     return s;
//   }
//
//   return;
// }
//
// //
//
// function mapIndexWithValue( srcMap, value )
// {
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   for( let s in srcMap )
//   {
//     if( srcMap[ s ] === value )
//     return s;
//   }
//
//   return;
// }

//

function mapOnlyNulls( srcMap )
{
  let result = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.map.like( srcMap ) );

  for( let s in srcMap )
  {
    if( srcMap[ s ] === null )
    result[ s ] = null;
  }

  return result;
}

//

function mapButNulls( srcMap )
{
  let result = Object.create( null );

  _.assert( arguments.length === 1 );

  for( let s in srcMap )
  {
    if( srcMap[ s ] !== null )
    result[ s ] = srcMap[ s ];
  }

  return result;
}

// --
// map checker
// --

// /**
//  * The mapsAreIdentical() returns true, if the second object (src2)
//  * has the same values as the first object(src1).
//  *
//  * It takes two objects (scr1, src2), checks
//  * if both object have the same length and [key, value] return true
//  * otherwise it returns false.
//  *
//  * @param { objectLike } src1 - First object.
//  * @param { objectLike } src2 - Target object.
//  * Objects to compare values.
//  *
//  * @example
//  * _.map.identical( { a : 7, b : 13 }, { a : 7, b : 13 } );
//  * // returns true
//  *
//  * @example
//  * _.map.identical( { a : 7, b : 13 }, { a : 33, b : 13 } );
//  * // returns false
//  *
//  * @example
//  * _.map.identical( { a : 7, b : 13, c : 33 }, { a : 7, b : 13 } );
//  * // returns false
//  *
//  * @returns { boolean } Returns true, if the second object (src2)
//  * has the same values as the first object(src1).
//  * @function mapsAreIdentical
//  * @throws Will throw an error if ( arguments.length !== 2 ).
//  * @namespace Tools
//  */
//
// /* xxx qqq : for junior : duplicate in _.props.identical() | aaa : Done */
// /* xxx qqq : for junior : move to _.aux.identical() | aaa : Done */
// function mapsAreIdentical( src1, src2 )
// {
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( !_.primitive.is( src1 ) );
//   _.assert( !_.primitive.is( src2 ) );
//
//   if( Object.keys( src1 ).length !== Object.keys( src2 ).length )
//   return false;
//
//   for( let s in src1 )
//   {
//     if( src1[ s ] !== src2[ s ] )
//     return false;
//   }
//
//   return true;
// }
//
// //
//
// /**
//  * The mapContain() returns true, if the first object {-srcMap-}
//  * has the same values as the second object(ins).
//  *
//  * It takes two objects (scr, ins),
//  * checks if the first object {-srcMap-} has the same [key, value] as
//  * the second object (ins).
//  * If true, it returns true,
//  * otherwise it returns false.
//  *
//  * @param { objectLike } src - Target object.
//  * @param { objectLike } ins - Second object.
//  * Objects to compare values.
//  *
//  * @example
//  * _.map.contain( { a : 7, b : 13, c : 15 }, { a : 7, b : 13 } );
//  * // returns true
//  *
//  * @example
//  * _.map.contain( { a : 7, b : 13 }, { a : 7, b : 13, c : 15 } );
//  * // returns false
//  *
//  * @returns { boolean } Returns true, if the first object {-srcMap-}
//  * has the same values as the second object(ins).
//  * @function mapContain
//  * @throws Will throw an error if ( arguments.length !== 2 ).
//  * @namespace Tools
//  */
//
// function mapContain( src, ins )
// {
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   /*
//     if( Object.keys( src ).length < Object.keys( ins ).length )
//     return false;
//   */
//
//   for( let s in ins )
//   {
//
//     if( ins[ s ] === undefined )
//     continue;
//
//     if( src[ s ] !== ins[ s ] )
//     return false;
//
//   }
//
//   return true;
// }

//

/**
 * Checks if object( o.src ) has at least one key/value pair that is represented in( o.template ).
 * Also works with ( o.template ) as routine that check( o.src ) with own rules.
 * @param {wTools.objectSatisfyOptions} o - Default options {@link wTools.objectSatisfyOptions}.
 * @returns { boolean } Returns true if( o.src ) has same key/value pair(s) with( o.template )
 * or result if ( o.template ) routine call is true.
 *
 * @example
 * _.objectSatisfy( {a : 1, b : 1, c : 1 }, { a : 1, b : 2 } );
 * // returns true
 *
 * @example
 * _.objectSatisfy( { template : {a : 1, b : 1, c : 1 }, src : { a : 1, b : 2 } } );
 * // returns true
 *
 * @example
 * function routine( src ){ return src.a === 12 }
 * _.objectSatisfy( { template : routine, src : { a : 1, b : 2 } } );
 * // returns false
 *
 * @function objectSatisfy
 * @throws {exception} If( arguments.length ) is not equal to 1 or 2.
 * @throws {exception} If( o.template ) is not a Object.
 * @throws {exception} If( o.template ) is not a Routine.
 * @throws {exception} If( o.src ) is undefined.
 * @namespace Tools
*/

function objectSatisfy( o )
{

  if( arguments.length === 2 )
  o = { template : arguments[ 0 ], src : arguments[ 1 ] };

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.object.isBasic( o.template ) || _.routine.is( o.template ) );
  _.assert( o.src !== undefined );
  _.routine.options( objectSatisfy, o );

  return _objectSatisfy( o.template, o.src, o.src, o.levels, o.strict );

  /* */

  function _objectSatisfy( /* template, src, root, levels, strict */ )
  {
    let template = arguments[ 0 ];
    let src = arguments[ 1 ];
    let root = arguments[ 2 ];
    let levels = arguments[ 3 ];
    let strict = arguments[ 4 ];

    if( !strict && src === undefined )
    return true;

    if( template === src )
    return true;

    if( levels === 0 )
    {
      if
      (
        _.object.isBasic( template )
        && _.object.isBasic( src )
        && _.routine.is( template.identicalWith )
        && src.identicalWith === template.identicalWith
      )
      return template.identicalWith( src );
      else
      return template === src;
    }
    else if( levels < 0 )
    {
      return false;
    }

    if( _.routine.is( template ) )
    return template( src );

    if( !_.object.isBasic( src ) )
    return false;

    if( _.object.isBasic( template ) )
    {
      for( let t in template )
      {
        let satisfy = false;
        satisfy = _objectSatisfy( template[ t ], src[ t ], root, levels-1, strict );
        if( !satisfy )
        return false;
      }
      return true;
    }

    return false;
  }

}

objectSatisfy.defaults =
{
  template : null,
  src : null,
  levels : 1,
  strict : 1,
}

//

function mapOwnKey( srcMap, key )
{
  // if( srcMap === null )
  // return false;
  // if( srcMap === undefined )
  // return false;
  if( _.primitive.is( srcMap ) )
  return false;
  return Object.hasOwnProperty.call( srcMap, key );
}

//

function mapHasKey( srcMap, key )
{
  if( _.primitive.is( srcMap ) )
  return false;
  if( !Reflect.has( srcMap, key ) )
  return false;
  return true;
}

//

/**
 * The mapOnlyOwnKey() returns true if (object) has own property.
 *
 * It takes (name) checks if (name) is a String,
 * if (object) has own property with the (name).
 * If true, it returns true.
 *
 * @param { Object } object - Object that will be check.
 * @param { name } name - Target property.
 *
 * @example
 * _.mapOnlyOwnKey( { a : 7, b : 13 }, 'a' );
 * // returns true
 *
 * @example
 * _.mapOnlyOwnKey( { a : 7, b : 13 }, 'c' );
 * // returns false
 *
 * @returns { boolean } Returns true if (object) has own property.
 * @function mapOnlyOwnKey
 * @throws { mapOnlyOwnKey } Will throw an error if the (name) is unknown.
 * @namespace Tools
 */

//

function mapOnlyOwnKey( object, key )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( key ) || _.symbolIs( key ), `Expects either string or symbol, but got ${_.entity.strType( key )}`,  );

  if( _.strIs( key ) )
  return Object.hasOwnProperty.call( object, key );
  else if( _.symbol.is( key ) )
  return Object.hasOwnProperty.call( object, key );
  // else if( _.aux.is( key ) )
  // return Object.hasOwnProperty.call( object, _.nameUnfielded( key ).coded );

  // _.assert( 0, 'Unknown type of key :', _.entity.strType( key ) );
}

//

function mapHasVal( object, val )
{
  let vals = _.props.vals( object );
  return vals.indexOf( val ) !== -1;
}

//

function mapOnlyOwnVal( object, val )
{
  let vals = _.props.onlyOwnVals( object );
  return vals.indexOf( val ) !== -1;
}

//

/**
 * The mapHasAll() returns true if object( src ) has all enumerable keys from object( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has property with same name.
 * Returns true if all keys from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { ObjectLike } src - Map that will be checked for keys from( screen ).
 * @param { ObjectLike } screen - Map that hold keys.
 *
 * @example
 * _.mapHasAll( {}, {} );
 * // returns true
 *
 * @example
 * _.mapHasAll( {}, { a : 1 } );
 * // returns false
 *
 * @returns { boolean } Returns true if object( src ) has all enumerable keys from( screen ).
 * @function mapHasAll
 * @throws { Exception } Will throw an error if the ( src ) is not a ObjectLike entity.
 * @throws { Exception } Will throw an error if the ( screen ) is not a ObjectLike entity.
 * @namespace Tools
 */

function mapHasAll( src, screen )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( src ) );
  _.assert( !_.primitive.is( screen ) );

  if( _.argumentsArray.like( screen ) )
  {
    for( let s = 0 ; s < screen.length ; s++ )
    if( !( screen[ s ] in src ) )
    return false;
  }
  else if( _.countable.is( screen ) )
  {
    for( let value of screen )
    if( !( value in src ) )
    return false;
  }
  else if( _.aux.is( screen ) )
  {
    for( let k in screen )
    if( !( k in src ) )
    return false;
  }

  return true;

}

//

/**
 * The mapHasAny() returns true if object( src ) has at least one enumerable key from object( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has at least one property with same name.
 * Returns true if any key from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { ObjectLike } src - Map that will be checked for keys from( screen ).
 * @param { ObjectLike|Vector } screen - Map or vector that hold keys.
 *
 * @example
 * _.mapHasAny( {}, {} );
 * // returns false
 *
 * @example
 * _.mapHasAny( { a : 1, b : 2 }, { a : 1 } );
 * // returns true
 *
 * @example
 * _.mapHasAny( { a : 1, b : 2 }, { c : 1 } );
 * // returns false
 *
 * @returns { boolean } Returns true if object( src ) has at least one enumerable key from( screen ).
 * @function mapHasAny
 * @throws { Exception } Will throw an error if the ( src ) is not a ObjectLike entity.
 * @throws { Exception } Will throw an error if the ( screen ) is not a ObjectLike entity.
 * @namespace Tools
 */

/* xxx qqq : for junior : teach to accept vector | aaa : Done. */
/* xxx qqq : for junior : duplicate in _.props.hasAny() | aaa : Done */
function mapHasAny( src, screen )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( src ) );
  _.assert( !_.primitive.is( screen ) );

  if( _.argumentsArray.like( screen ) )
  {
    for( let s = 0 ; s < screen.length ; s++ )
    if( screen[ s ] in src )
    return true;
  }
  else if( _.countable.is( screen ) )
  {
    for( let value of screen )
    if( value in src )
    return true;
  }
  else if( _.aux.is( screen ) )
  {
    for( let k in screen )
    if( k in src )
    return true;
  }

  return false;
}

//

/**
 * The mapHasAny() returns true if object( src ) has no one enumerable key from object( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has no one property with same name.
 * Returns true if all keys from( screen ) not exists on object( src ), otherwise returns false.
 *
 * @param { ObjectLike } src - Map that will be checked for keys from( screen ).
 * @param { ObjectLike } screen - Map that hold keys.
 *
 * @example
 * _.mapHasNone( {}, {} );
 * // returns true
 *
 * @example
 * _.mapHasNone( { a : 1, b : 2 }, { a : 1 } );
 * // returns false
 *
 * @example
 * _.mapHasNone( { a : 1, b : 2 }, { c : 1 } );
 * // returns true
 *
 * @returns { boolean } Returns true if object( src ) has at least one enumerable key from( screen ).
 * @function mapHasNone
 * @throws { Exception } Will throw an error if the ( src ) is not a ObjectLike entity.
 * @throws { Exception } Will throw an error if the ( screen ) is not a ObjectLike entity.
 * @namespace Tools
 */

/* qqq : for junior : teach to accept vector | aaa : Done */
/* xxx qqq : for junior : duplicate in _.props.hasNone() | aaa : Done */
function mapHasNone( src, screen )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( src ) );
  _.assert( !_.primitive.is( screen ) );

  if( _.argumentsArray.like( screen ) )
  {
    for( let s = 0 ; s < screen.length ; s++ )
    if( screen[ s ] in src )
    return false;
  }
  else if( _.countable.is( screen ) )
  {
    for( let value of screen )
    if( value in src )
    return false;
  }
  else if( _.aux.is( screen ) )
  {
    for( let k in screen )
    if( k in src )
    return false;
  }

  return true;
}

//

/**
 * The mapOnlyOwnAll() returns true if object( src ) has all own keys from object( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has own property with that key name.
 * Returns true if all keys from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { Object } src - Map that will be checked for keys from( screen ).
 * @param { Object } screen - Map that hold keys.
 *
 * @example
 * _.mapOnlyOwnAll( {}, {} );
 * // returns true
 *
 * @example
 * _.mapOnlyOwnAll( { a : 1, b : 2 }, { a : 1 } );
 * // returns true
 *
 * @example
 * _.mapOnlyOwnAll( { a : 1, b : 2 }, { c : 1 } );
 * // returns false
 *
 * @returns { boolean } Returns true if object( src ) has own properties from( screen ).
 * @function mapOnlyOwnAll
 * @throws { Exception } Will throw an error if the ( src ) is not a ObjectLike entity.
 * @throws { Exception } Will throw an error if the ( screen ) is not a ObjectLike entity.
 * @namespace Tools
 */

/* qqq : for junior : teach to accept vector | aaa : Done. */
function mapOnlyOwnAll( src, screen )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( src ) );
  _.assert( !_.primitive.is( screen ) );

  if( _.argumentsArray.like( screen ) )
  {
    for( let s = 0 ; s < screen.length ; s++ )
    if( !Object.hasOwnProperty.call( src, screen[ s ] ) )
    return false;
  }
  else if( _.countable.is( screen ) )
  {
    for( let value of screen )
    if( !Object.hasOwnProperty.call( src, value ) )
    return false;
  }
  else if( _.aux.is( screen ) )
  {
    for( let k in screen )
    if( !Object.hasOwnProperty.call( src, k ) )
    return false;
  }

  return true;
}

//

/**
 * The mapOnlyOwnAny() returns true if map( src ) has at least one own property from map( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from map( screen ) and checks if source( src ) has at least one property with that key name.
 * Returns true if one of keys from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { Object } src - Map that will be checked for keys from( screen ).
 * @param { Object } screen - Map that hold keys.
 *
 * @example
 * _.mapOnlyOwnAny( {}, {} );
 * // returns false
 *
 * @example
 * _.mapOnlyOwnAny( { a : 1, b : 2 }, { a : 1 } );
 * // returns true
 *
 * @example
 * _.mapOnlyOwnAny( { a : 1, b : 2 }, { c : 1 } );
 * // returns false
 *
 * @returns { boolean } Returns true if object( src ) has own properties from( screen ).
 * @function mapOnlyOwnAny
 * @throws { Exception } Will throw an error if the ( src ) is not a map.
 * @throws { Exception } Will throw an error if the ( screen ) is not a map.
 * @namespace Tools
 */

/* qqq : for junior : teach to accept vector | aaa : Done. */
function mapOnlyOwnAny( src, screen )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( src ) );
  _.assert( !_.primitive.is( screen ) );

  if( _.argumentsArray.like( screen ) )
  {
    for( let s = 0 ; s < screen.length ; s++ )
    if( Object.hasOwnProperty.call( src, screen[ s ] ) )
    return true;
  }
  else if( _.countable.is( screen ) )
  {
    for( let value of screen )
    if( Object.hasOwnProperty.call( src, value ) )
    return true;
  }
  else if( _.aux.is( screen ) )
  {
    for( let k in screen )
    if( Object.hasOwnProperty.call( src, k ) )
    return true;
  }

  return false;
}

//

/**
 * The mapOnlyOwnNone() returns true if map( src ) not owns properties from map( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has own property with that key name.
 * Returns true if no one key from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { Object } src - Map that will be checked for keys from( screen ).
 * @param { Object } screen - Map that hold keys.
 *
 * @example
 * _.mapOnlyOwnNone( {}, {} );
 * // returns true
 *
 * @example
 * _.mapOnlyOwnNone( { a : 1, b : 2 }, { a : 1 } );
 * // returns false
 *
 * @example
 * _.mapOnlyOwnNone( { a : 1, b : 2 }, { c : 1 } );
 * // returns true
 *
 * @returns { boolean } Returns true if map( src ) not owns properties from( screen ).
 * @function mapOnlyOwnNone
 * @throws { Exception } Will throw an error if the ( src ) is not a map.
 * @throws { Exception } Will throw an error if the ( screen ) is not a map.
 * @namespace Tools
 */

/* qqq : for junior : teach to accept vector | aaa : Done.*/
/* xxx : move? */
function mapOnlyOwnNone( src, screen )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( src ) );
  _.assert( !_.primitive.is( screen ) );

  if( _.argumentsArray.like( screen ) )
  {
    for( let s = 0 ; s < screen.length ; s++ )
    if( Object.hasOwnProperty.call( src, screen[ s ] ) )
    return false;
  }
  else if( _.countable.is( screen ) )
  {
    for( let value of screen )
    if( Object.hasOwnProperty.call( src, value ) )
    return false;
  }
  else if( _.aux.is( screen ) )
  {
    for( let k in screen )
    if( Object.hasOwnProperty.call( src, k ) )
    return false;
  }

  return true;
}

//

function mapHasExactly( srcMap, screenMaps )
{
  let result = true;

  _.assert( arguments.length === 2 );

  result = result && _.mapHasOnly( srcMap, screenMaps );
  result = result && _.mapHasAll( srcMap, screenMaps );

  return result;
}

//

function mapOnlyOwnExactly( srcMap, screenMaps )
{
  let result = true;

  _.assert( arguments.length === 2 );

  result = result && _.mapOnlyOwnOnly( srcMap, screenMaps );
  result = result && _.mapOnlyOwnAll( srcMap, screenMaps );

  return result;
}

//

function mapHasOnly( srcMap, screenMaps )
{

  _.assert( arguments.length === 2 );

  let l = arguments.length;
  let but = Object.keys( _.mapBut_( null, srcMap, screenMaps ) );

  if( but.length > 0 )
  return false;

  return true;
}

//

/* xxx : review */
function mapOnlyOwnOnly( srcMap, screenMaps )
{

  _.assert( arguments.length === 2 );

  let l = arguments.length;
  // let but = Object.keys( _.mapOnlyOwnBut_( null, srcMap, screenMaps ) );
  let but = Object.keys( _.mapOnlyOwnButOld( srcMap, screenMaps ) );

  if( but.length > 0 )
  return false;

  return true;
}

//

function mapHasNoUndefine( srcMap )
{

  _.assert( arguments.length === 1 );

  let but = [];
  let l = arguments.length;

  for( let s in srcMap )
  if( srcMap[ s ] === undefined )
  return false;

  return true;
}

// --
// map move
// --

// /**
//  * The mapMake() routine is used to copy the values of all properties
//  * from one or more source objects to the new object.
//  *
//  * @param { ...objectLike } arguments[] - The source object(s).
//  *
//  * @example
//  * _.mapMake( { a : 7, b : 13 }, { c : 3, d : 33 }, { e : 77 } );
//  * // returns { a : 7, b : 13, c : 3, d : 33, e : 77 }
//  *
//  * @returns { objectLike } It will return the new object filled by [ key, value ]
//  * from one or more source objects.
//  * @function mapMake
//  * @namespace Tools
//  */
//
// function mapMake( src )
// {
//   _.assert( arguments.length === 0 || arguments.length === 1 );
//   if( arguments.length <= 1 )
//   if( arguments[ 0 ] === undefined || arguments[ 0 ] === null )
//   return Object.create( null );
//   return _.props.extend( null, src );
// }
//
// //
//
// function mapCloneShallow( src )
// {
//   return _.mapMake( src );
// }

//

/**
 * @callback mapCloneAssigning.onField
 * @param { objectLike } dstContainer - destination object.
 * @param { objectLike } srcContainer - source object.
 * @param { string } key - key to coping from one object to another.
 * @param { function } onField - handler of fields.
 */

/**
 * The mapCloneAssigning() routine is used to clone the values of all
 * enumerable own properties from {-srcMap-} object to an (options.dst) object.
 *
 * It creates two variables:
 * let options = options || {}, result = options.dst || {}.
 * Iterate over {-srcMap-} object, checks if {-srcMap-} object has own properties.
 * If true, it calls the provided callback function( options.onField( result, srcMap, k ) ) for each key (k),
 * and copies each [ key, value ] of the {-srcMap-} to the (result),
 * and after cycle, returns clone with prototype of srcMap.
 *
 * @param { objectLike } srcMap - The source object.
 * @param { Object } o - The options.
 * @param { objectLike } [options.dst = Object.create( null )] - The target object.
 * @param { mapCloneAssigning.onField } [options.onField()] - The callback function to copy each [ key, value ]
 * of the {-srcMap-} to the (result).
 *
 * @example
 * function Example() {
 *   this.name = 'Peter';
 *   this.age = 27;
 * }
 * _.mapCloneAssigning( new Example(), { dst : { sex : 'Male' } } );
 * // returns Example { sex : 'Male', name : 'Peter', age : 27 }
 *
 * @returns { objectLike }  The (result) object gets returned.
 * @function mapCloneAssigning
 * @throws { Error } Will throw an Error if ( o ) is not an Object,
 * if ( arguments.length > 2 ), if (key) is not a String or
 * if {-srcMap-} has not own properties.
 * @namespace Tools
 */

function mapCloneAssigning( o ) /* xxx : review */
{
  o.dstMap = o.dstMap || Object.create( null );

  _.assert( _.mapIs( o ) );
  _.assert( arguments.length === 1, 'Expects {-srcMap-} as argument' );
  _.assert( !_.primitive.is( o.srcMap ), 'Expects {-srcMap-} as argument' );
  _.routine.options( mapCloneAssigning, o );

  if( !o.onField )
  o.onField = function onField( dstContainer, srcContainer, key )
  {
    _.assert( _.strIs( key ) );
    dstContainer[ key ] = srcContainer[ key ];
  }

  for( let k in o.srcMap )
  {
    if( Object.hasOwnProperty.call( o.srcMap, k ) )
    o.onField( o.dstMap, o.srcMap, k, o.onField );
  }

  Object.setPrototypeOf( o.dstMap, Object.getPrototypeOf( o.srcMap ) );

  return o.dstMap;
}

mapCloneAssigning.defaults =
{
  srcMap : null,
  dstMap : null,
  onField : null,
}

//

function mapsExtend( dstMap, srcMaps )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( dstMap ), 'Expects non primitive as the first argument' );

  /* aaa : allow and cover vector */ /* Dmytro : allowed and covered. I think, an optimization for array like vectors has no sense. Otherwise, we need to add single branch with for cycle */
  if( _.countable.is( srcMaps ) )
  for( let srcMap of srcMaps )
  dstMapExtend( srcMap );
  else
  dstMapExtend( srcMaps );

  return dstMap;

  /* */

  function dstMapExtend( srcMap )
  {
    _.assert( !_.primitive.is( srcMap ), 'Expects non primitive' );

    if( Object.getPrototypeOf( srcMap ) === null )
    Object.assign( dstMap, srcMap );
    else for( let k in srcMap )
    dstMap[ k ] = srcMap[ k ];
  }

  // if( dstMap === null )
  // dstMap = Object.create( null );
  //
  // if( srcMaps.length === 1 && Object.getPrototypeOf( srcMaps[ 0 ] ) === null )
  // return Object.assign( dstMap, srcMaps[ 0 ] );
  //
  // if( !_.vector.is( srcMaps ) )
  // srcMaps = [ srcMaps ];
  //
  // _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  // _.assert( _.vector.is( srcMaps ) );
  // _.assert( !_.primitive.is( dstMap ), 'Expects non primitive as the first argument' );
  //
  // /* aaa : allow and cover vector */ /* Dmytro : allowed and covered. I think, an optimization for array like vectors has no sense. Otherwise, we need to add single branch with for cycle */
  // for( let a = 0 ; a < srcMaps.length ; a++ )
  // {
  //   let srcMap = srcMaps[ a ];
  //
  //   _.assert( !_.primitive.is( srcMap ), 'Expects non primitive' );
  //
  //   if( Object.getPrototypeOf( srcMap ) === null )
  //   Object.assign( dstMap, srcMap );
  //   else for( let k in srcMap )
  //   dstMap[ k ] = srcMap[ k ];
  //
  // }
  //
  // return dstMap;
}

//

/**
 * The mapExtendConditional() creates a new [ key, value ]
 * from the next objects if callback function(filter) returns true.
 *
 * It calls a provided callback function(filter) once for each key in an (argument),
 * and adds to the {-srcMap-} all the [ key, value ] for which callback
 * function(filter) returns true.
 *
 * @param { function } filter - The callback function to test each [ key, value ]
 * of the (dstMap) object.
 * @param { objectLike } dstMap - The target object.
 * @param { ...objectLike } arguments[] - The next object.
 *
 * @example
 * _.mapExtendConditional( _.props.mapper.dstNotHas(), { a : 1, b : 2 }, { a : 1 , c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @returns { objectLike } Returns the unique [ key, value ].
 * @function mapExtendConditional
 * @throws { Error } Will throw an Error if ( arguments.length < 3 ), (filter)
 * is not a Function, (result) and (argument) are not the objects.
 * @namespace Tools
 */

function mapExtendConditional( filter, dstMap )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( !!filter );
  // _.assert( filter.functionFamily === 'PropertyMapper' );
  _.assert( _.props.mapperIs( filter ) && !filter.identity.functor );
  _.assert( arguments.length >= 3, 'Expects more arguments' );
  _.assert( _.routine.is( filter ), 'Expects filter' );
  _.assert( !_.primitive.is( dstMap ), 'Expects non primitive as argument' );

  for( let a = 2 ; a < arguments.length ; a++ )
  {
    let srcMap = arguments[ a ];

    _.assert( !_.primitive.is( srcMap ), () => 'Expects object-like entity to extend, but got : ' + _.entity.strType( srcMap ) );

    for( let k in srcMap )
    {

      filter.call( this, dstMap, srcMap, k );

    }

  }

  return dstMap;
}

//

function mapsExtendConditional( filter, dstMap, srcMaps )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( !!filter );
  // _.assert( filter.functionFamily === 'PropertyMapper' );
  _.assert( _.props.mapperIs( filter ) && !filter.identity.functor );
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( _.routine.is( filter ), 'Expects filter' );
  _.assert( !_.primitive.is( dstMap ), 'Expects non primitive as argument' );

  if( _.arrayIs( srcMaps ) )
  for( let a = 0 ; a < srcMaps.length ; a++ )
  {
    let srcMap = srcMaps[ a ];

    _.assert( !_.primitive.is( srcMap ), () => 'Expects object-like entity to extend, but got : ' + _.entity.strType( srcMap ) );

    for( let k in srcMap )
    {
      filter.call( this, dstMap, srcMap, k );
    }
  }
  else /* countable */
  for( let srcMap of srcMaps )
  {
    _.assert( !_.primitive.is( srcMap ), () => 'Expects object-like entity to extend, but got : ' + _.entity.strType( srcMap ) );

    for( let k in srcMap )
    {
      filter.call( this, dstMap, srcMap, k );
    }
  }

  return dstMap;
}

//

function mapExtendHiding( dstMap )
{
  return _.mapExtendConditional( _.props.mapper.hiding(), ... arguments );
}

//

function mapsExtendHiding( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return _.mapsExtendConditional( _.props.mapper.hiding(), dstMap, srcMaps );
}

//

function mapExtendAppending( dstMap )
{
  if( dstMap === null && arguments.length === 2 )
  return Object.assign( Object.create( null ), srcMap );
  return _.mapExtendConditional( _.props.mapper.appendingAnything(), ... arguments );
}

//

function mapsExtendAppending( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( dstMap === null )
  return _.props.extend( null, srcMaps[ 0 ] );
  return _.mapsExtendConditional( _.props.mapper.appendingAnything(), dstMap, srcMaps );
}

//

function mapExtendPrepending( dstMap )
{
  if( dstMap === null && arguments.length === 2 )
  return Object.assign( Object.create( null ), srcMap );
  return _.mapExtendConditional( _.props.mapper.prependingAnything(), ... arguments );
}

//

function mapsExtendPrepending( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( dstMap === null )
  return _.props.extend( null, srcMaps[ 0 ] );
  return _.mapsExtendConditional( _.props.mapper.prependingAnything(), dstMap, srcMaps );
}

//

function mapExtendAppendingOnlyArrays( dstMap )
{
  if( dstMap === null && arguments.length === 2 )
  return Object.assign( Object.create( null ), srcMap );
  return _.mapExtendConditional( _.props.mapper.appendingOnlyArrays(), ... arguments );
}

//

function mapsExtendAppendingOnlyArrays( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( dstMap === null )
  return _.props.extend( null, srcMaps[ 0 ] );
  return _.mapsExtendConditional( _.props.mapper.appendingOnlyArrays(), dstMap, srcMaps );
}

//

function mapExtendByDefined( dstMap )
{
  if( dstMap === null && arguments.length === 2 )
  return Object.assign( Object.create( null ), srcMap );
  return _.mapExtendConditional( _.props.mapper.srcDefined(), ... arguments );
}

//

function mapsExtendByDefined( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return _.mapsExtendConditional( _.props.mapper.srcDefined(), dstMap, srcMaps );
}

//

function mapExtendNulls( dstMap )
{
  return _.mapExtendConditional( _.props.mapper.dstNotHasOrSrcNotNull(), ... arguments );
}

//

function mapsExtendNulls( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return _.mapsExtendConditional( _.props.mapper.dstNotHasOrSrcNotNull(), dstMap, srcMaps );
}

//

function mapExtendDstNotOwn( dstMap, srcMap )
{
  if( dstMap === null && arguments.length === 2 )
  return _.props.extend( dstMap, srcMap );
  return _.mapExtendConditional( _.props.mapper.dstNotOwn(), ... arguments );
}

//

function mapsExtendDstNotOwn( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( dstMap === null )
  return _.props.extend( null, srcMaps[ 0 ] );
  return _.mapsExtendConditional( _.props.mapper.dstNotOwn(), dstMap, srcMaps );
}

//

function mapExtendNotIdentical( dstMap, srcMap )
{
  if( dstMap === null && arguments.length === 2 )
  return _.props.extend( dstMap, srcMap );
  return _.mapExtendConditional( _.props.mapper.notIdentical(), ... arguments );
}

//

function mapsExtendNotIdentical( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( dstMap === null )
  return _.props.extend( null, srcMaps[ 0 ] );
  return _.mapsExtendConditional( _.props.mapper.notIdentical(), dstMap, srcMaps );
}

//

function mapSupplementByMaps( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  if( dstMap === null )
  return _.props.extend( null, srcMaps[ 0 ] );
  return _.mapsExtendConditional( _.props.mapper.dstNotHas(), dstMap, srcMaps );
}

//

function mapSupplementNulls( dstMap )
{
  return _.mapExtendConditional( _.props.mapper.dstNotHasOrHasNull(), ... arguments );
}

//

function mapSupplementNils( dstMap )
{
  return _.mapExtendConditional( _.props.mapper.dstNotHasOrHasNil(), ... arguments );
}

//

function mapSupplementAssigning( dstMap )
{
  return _.mapExtendConditional( _.props.mapper.dstNotHasAssigning(), ... arguments );
}

//

function mapSupplementAppending( dstMap )
{
  if( dstMap === null && arguments.length === 2 )
  return Object.assign( Object.create( null ), srcMap );
  return _.mapExtendConditional( _.props.mapper.dstNotHasAppending(), ... arguments );
}

//

function mapsSupplementAppending( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return _.mapsExtendConditional( _.props.mapper.dstNotHasAppending(), dstMap, srcMaps );
}

//

function mapSupplementOwnAssigning( dstMap )
{
  return _.mapExtendConditional( _.props.mapper.dstNotOwnAssigning(), ... arguments );
}

//

/**
 * The routine mapComplement() complements {-dstMap-} by one or several {-srcMap-}. Routine does not change
 * defined pairs key-value in {-dstMap-}.
 * If {-dstMap-} and {-srcMap-} has equal keys, and value of {-dstMap-} is undefined, then routine
 * mapComplement() changes it to {-srcMap-} value.
 * If pair key-value does not exists in {-dstMap-}, then routine appends this pair to {-dstMap-}.
 *
 * @param { objectLike } dstMap - ObjectLike entity to be complemented.
 * @param { ...objectLike } srcMap - The source object(s).
 *
 * @example
 * _.mapComplement( { a : 1, b : 2, c : 3 }, { a : 4, b : 5, c : 6, d : 7 } );
 * // returns { a : 1, b : 3, c : 3, d : 7 };
 *
 * @example
 * _.mapComplement( { a : 1, b : 2, c : 3 }, { a : 4, b : 5 }, { c : 6, d : 7 } );
 * // returns { a : 1, b : 3, c : 3, d : 7 };
 *
 * @example
 * _.mapComplement( { a : 1, b : 2, c : undefined }, { a : 4, b : 5, c : 6, d : 7 } );
 * // returns { a : 1, b : 3, c : 6, d : 7 };
 *
 * @example
 * _.mapComplement( { a : 1, b : 2, c : undefined }, { a : 4, b : 5 }, { c : 6, d : 7 } );
 * // returns { a : 1, b : 3, c : 6, d : 7 };
 *
 * @returns { objectLike } - Returns the destination object filled by unique values from source object(s), and if it is possible, replaced undefined
 * values in destination object.
 * @function mapComplement
 * @namespace Tools
 */

function mapComplement( dstMap, srcMap )
{
  dstNotOwnOrUndefinedAssigning.identity = { propertyMapper : true, propertyTransformer : true };
  return _.mapExtendConditional( dstNotOwnOrUndefinedAssigning, ... arguments );

  function dstNotOwnOrUndefinedAssigning( dstContainer, srcContainer, key )
  {
    if( Object.hasOwnProperty.call( dstContainer, key ) )
    {
      if( dstContainer[ key ] !== undefined )
      return;
    }
    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
  }

}

//

function mapsComplement( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return _.mapsExtendConditional( _.props.mapper.dstNotOwnOrUndefinedAssigning(), dstMap, srcMaps );
}

//

function mapComplementReplacingUndefines( dstMap, srcMap )
{
  _.assert( !!_.props.mapper );
  return _.mapExtendConditional( _.props.mapper.dstNotOwnOrUndefinedAssigning(), ... arguments );
}

//

function mapsComplementReplacingUndefines( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return _.mapsExtendConditional( _.props.mapper.dstNotOwnOrUndefinedAssigning(), dstMap, srcMaps );
}

//

function mapComplementPreservingUndefines( dstMap )
{
  return _.mapExtendConditional( _.props.mapper.dstNotOwnAssigning(), ... arguments );
}

//

function mapsComplementPreservingUndefines( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return _.mapsExtendConditional( _.props.mapper.dstNotOwnAssigning(), dstMap, srcMaps );
}

// --
// map recursive
// --

function mapExtendRecursiveConditional( filters, dstMap, srcMap )
{
  _.assert( arguments.length >= 3, 'Expects at least three arguments' );
  // _.assert( this === Self );
  let srcMaps = _.longSlice( arguments, 2 );
  return _.mapsExtendRecursiveConditional( filters, dstMap, srcMaps );
}

//

function _filterTrue(){ return true };
_filterTrue.identity = { propertyCondition : true, propertyTransformer : true };
function _filterFalse(){ return true };
_filterFalse.identity = { propertyCondition : true, propertyTransformer : true };

function mapsExtendRecursiveConditional( filters, dstMap, srcMaps )
{

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  // _.assert( this === Self );

  if( _.routine.is( filters ) )
  filters = { onUpFilter : filters, onField : filters }

  if( filters.onUpFilter === undefined )
  filters.onUpFilter = filters.onField;
  else if( filters.onUpFilter === true )
  filters.onUpFilter = _filterTrue;
  else if( filters.onUpFilter === false )
  filters.onUpFilter = _filterFalse;

  if( filters.onField === true )
  filters.onField = _filterTrue;
  else if( filters.onField === false )
  filters.onField = _filterFalse;

  _.assert( _.routine.is( filters.onUpFilter ) );
  _.assert( _.routine.is( filters.onField ) );
  // _.assert( _.props.conditionIs( filters.onUpFilter ) );
  _.assert( _.props.conditionIs( filters.onUpFilter ) && !filters.onUpFilter.identity.functor, 'Expects PropertyFilter {-propertyCondition-}' );
  _.assert( _.props.transformerIs( filters.onField ) );
  // _.assert( filters.onUpFilter.functionFamily === 'PropertyFilter' );
  // _.assert( filters.onField.functionFamily === 'PropertyFilter' || filters.onField.functionFamily === 'PropertyMapper' );

  if( _.arrayIs( srcMaps ) )
  for( let a = 0 ; a < srcMaps.length ; a++ )
  {
    let srcMap = srcMaps[ a ];
    _mapExtendRecursiveConditional( filters, dstMap, srcMap );
  }
  else /* countable */
  {
    for( let srcMap of srcMaps )
    _mapExtendRecursiveConditional( filters, dstMap, srcMap );
  }

  return dstMap;
}

//

function _mapExtendRecursiveConditional( filters, dstMap, srcMap )
{

  _.assert( _.aux.is( srcMap ) );

  for( let s in srcMap )
  {

    if( _.aux.is( srcMap[ s ] ) )
    {

      if( filters.onUpFilter( dstMap, srcMap, s ) === true )
      {
        if( !_.object.isBasic( dstMap[ s ] ) )
        dstMap[ s ] = Object.create( null );
        _._mapExtendRecursiveConditional( filters, dstMap[ s ], srcMap[ s ] );
      }

    }
    else
    {

      if( filters.onField( dstMap, srcMap, s ) === true )
      dstMap[ s ] = srcMap[ s ];

    }

  }

  return dstMap;
}

//

function mapExtendRecursive( dstMap, srcMap )
{

  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  // _.assert( this === Self );

  for( let a = 1 ; a < arguments.length ; a++ )
  {
    srcMap = arguments[ a ];
    _._mapExtendRecursive( dstMap, srcMap );
  }

  return dstMap;
}

//

function mapsExtendRecursive( dstMap, srcMaps )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  // _.assert( this === Self );

  if( _.arrayIs( srcMaps ) )
  for( let a = 1 ; a < srcMaps.length ; a++ )
  {
    let srcMap = srcMaps[ a ];
    _._mapExtendRecursive( dstMap, srcMap );
  }
  else /* countable */
  {
    for( let srcMap of srcMaps )
    _._mapExtendRecursive( dstMap, srcMap );
  }

  return dstMap;
}

//

function _mapExtendRecursive( dstMap, srcMap )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( _.aux.is( srcMap ) );

  for( let s in srcMap )
  {

    if( _.aux.is( srcMap[ s ] ) )
    {

      if( !_.aux.is( dstMap[ s ] ) )
      dstMap[ s ] = Object.create( null );
      _._mapExtendRecursive( dstMap[ s ], srcMap[ s ] );

    }
    else
    {

      dstMap[ s ] = srcMap[ s ];

    }

  }

}

//

function mapExtendAppendingAnythingRecursive( dstMap, srcMap )
{
  // _.assert( this === Self );
  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  let filters = { onField : _.props.mapper.appendingAnything(), onUpFilter : true };
  return _.mapExtendRecursiveConditional( filters, ... arguments );
}

//

function mapsExtendAppendingAnythingRecursive( dstMap, srcMaps )
{
  // _.assert( this === Self );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  let filters = { onField : _.props.mapper.appendingAnything(), onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

//

function mapExtendAppendingArraysRecursive( dstMap, srcMap )
{
  // _.assert( this === Self );
  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  let filters = { onField : _.props.mapper.appendingOnlyArrays(), onUpFilter : true };
  return _.mapExtendRecursiveConditional( filters, ... arguments );
}

//

function mapsExtendAppendingArraysRecursive( dstMap, srcMaps )
{
  // _.assert( this === Self );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  let filters = { onField : _.props.mapper.appendingOnlyArrays(), onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

//

function mapExtendAppendingOnceRecursive( dstMap, srcMap )
{
  // _.assert( this === Self );
  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  let filters = { onField : _.props.mapper.appendingOnce(), onUpFilter : true };
  return _.mapExtendRecursiveConditional( filters, ... arguments );
}

//

function mapsExtendAppendingOnceRecursive( dstMap, srcMaps )
{
  // _.assert( this === Self );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  let filters = { onField : _.props.mapper.appendingOnce(), onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

//

function mapSupplementRecursive( dstMap, srcMap )
{
  // _.assert( this === Self );
  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  let filters = { onField : _.props.mapper.dstNotHas(), onUpFilter : true };
  return _.mapExtendRecursiveConditional( filters, ... arguments );
}

//

function mapSupplementByMapsRecursive( dstMap, srcMaps )
{
  // _.assert( this === Self );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  let filters = { onField : _.props.mapper.dstNotHas(), onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

//

function mapSupplementOwnRecursive( dstMap, srcMap )
{
  // _.assert( this === Self );
  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  let filters = { onField : _.props.mapper.dstOwn(), onUpFilter : true };
  return _.mapExtendRecursiveConditional( filters, ... arguments );
}

//

function mapsSupplementOwnRecursive( dstMap, srcMaps )
{
  // _.assert( this === Self );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  let filters = { onField : _.props.mapper.dstOwn(), onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

//

function mapSupplementRemovingRecursive( dstMap, srcMap )
{
  // _.assert( this === Self );
  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  let filters = { onField : _.props.mapper.removing(), onUpFilter : true };
  return _.mapExtendRecursiveConditional( filters, ... arguments );
}

//

function mapSupplementByMapsRemovingRecursive( dstMap, srcMaps )
{
  // _.assert( this === Self );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  let filters = { onField : _.props.mapper.removing(), onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

// --
// map selector
// --

/**
 * The mapOnlyPrimitives() gets all object`s {-srcMap-} enumerable atomic fields( null, undef, number, string, symbol ) and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies object`s {-srcMap-} enumerable atomic properties to the new map using
 * their original name/value and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of atomic properties.
 *
 * @example
 * let a = {};
 * Object.defineProperty( a, 'x', { enumerable : 0, value : 3 } )
 * _.mapOnlyPrimitives( a );
 * // returns {}
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2, c : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.mapOnlyPrimitives( a );
 * // returns { a : 1, b : 2 }
 *
 * @returns { object } A new map with all atomic fields from source {-srcMap-}.
 * @function mapOnlyPrimitives
 * @throws { Error } Will throw an Error if {-srcMap-} is not an Object.
 * @namespace Tools
 */

function mapOnlyPrimitives( srcMap )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !_.primitive.is( srcMap ) );

  let result = _.mapExtendConditional( _.props.mapper.primitive(), Object.create( null ), srcMap );
  return result;
}

// --
// map manipulator
// --

function mapSetWithKeys( dstMap, key, val )
{
  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( _.object.isBasic( dstMap ) );
  _.assert( _.strIs( key ) || _.countable.is( key ) );
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  /* aaa : allow and cover vector */ /* Dmytro : implemented and covered */
  if( _.countable.is( key ) )
  {
    if( _.argumentsArray.like( key ) )
    for( let s = 0 ; s < key.length ; s++ )
    set( dstMap, key[ s ], val );
    else
    for( let value of key )
    set( dstMap, value, val );
  }
  else
  {
    set( dstMap, key, val );
  }

  return dstMap;

  /* */

  function set( dstMap, key, val )
  {
    if( val === undefined )
    delete dstMap[ key ];
    else
    dstMap[ key ] = val;
  }
}

//

function mapSetWithKeyStrictly( dstMap, key, val )
{
  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( _.object.isBasic( dstMap ) );
  _.assert( _.strIs( key ) || _.countable.is( key ) );
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  /* aaa : allow and cover vector */ /* Dmytro : implemented and covered */
  if( _.countable.is( key ) )
  {
    if( _.argumentsArray.like( key ) )
    for( let s = 0 ; s < key.length ; s++ )
    set( dstMap, key[ s ], val );
    else
    for( let value of key )
    set( dstMap, value, val );
  }
  else
  {
    set( dstMap, key, val );
  }

  return dstMap;

  function set( dstMap, key, val )
  {
    if( val === undefined )
    {
      delete dstMap[ key ];
    }
    else
    {
      _.assert( dstMap[ key ] === undefined || dstMap[ key ] === val );
      dstMap[ key ] = val;
    }
  }
}

// --
// map getter
// --

function mapInvert( src, dst )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  return _._mapInvert({ src, dst });
}

mapInvert.defaults =
{
  src : null,
  dst : null,
  duplicate : 'error',
}

//

function _mapInvert( o )
{
  _.routine.options( _mapInvert, o );

  o.dst = o.dst || Object.create( null );

  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( !_.primitive.is( o.src ) );
  _.assert( !_.primitive.is( o.dst ) );
  /* qqq : for junior : bad : lack of important assert */

  let del;
  if( o.duplicate === 'delete' )
  del = Object.create( null );

  /* */

  for( let k in o.src )
  {
    let e = o.src[ k ];
    if( o.duplicate === 'delete' )
    if( o.dst[ e ] !== undefined )
    {
      del[ e ] = k;
      continue;
    }
    if( o.duplicate === 'array' || o.duplicate === 'array-with-value' )
    {
      if( o.dst[ e ] === undefined )
      o.dst[ e ] = o.duplicate === 'array-with-value' ? [ e ] : [];
      o.dst[ e ].push( k );
    }
    else
    {
      _.assert( o.dst[ e ] === undefined, 'Cant invert the map, it has several keys with value', o.src[ k ] );
      o.dst[ e ] = k;
    }
  }

  /* */

  if( o.duplicate === 'delete' )
  _.mapDelete( o.dst, del );

  return o.dst;
}

_mapInvert.defaults =
{
  src : null,
  dst : null,
  duplicate : 'error',
}

//

function mapInvertDroppingDuplicates( src, dst )
{
  dst = dst || Object.create( null );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !_.primitive.is( src ) );

  let drop;

  for( let s in src )
  {
    if( dst[ src[ s ] ] !== undefined )
    {
      drop = drop || Object.create( null );
      drop[ src[ s ] ] = true;
    }
    dst[ src[ s ] ] = s;
  }

  if( drop )
  for( let d in drop )
  {
    delete dst[ d ];
  }

  return dst;
}

//

function mapsFlatten( o )
{

  if( _.countable.is( o ) )
  o = { src : o };

  _.routine.options( mapsFlatten, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.delimeter === false || o.delimeter === 0 || _.strIs( o.delimeter ) );
  _.assert( _.countable.is( o.src ) || _.aux.is( o.src ) ); /* xxx */

  o.dst = o.dst || Object.create( null );
  extend( o.src, '' );

  return o.dst;

  /* */

  function extend( src, prefix )
  {

    /* aaa : allow and cover vector */ /* Dmytro : extended, covered */
    if( _.countable.is( src ) )
    {
      if( _.argumentsArray.like( src ) )
      for( let s = 0 ; s < src.length ; s++ )
      extend( src[ s ], prefix );
      else
      for( let value of src )
      extend( value, prefix );
    }
    else if( _.aux.is( src ) )
    {

      for( let k in src )
      {
        let key = k;
        if( _.strIs( o.delimeter ) )
        key = ( prefix ? prefix + o.delimeter : '' ) + k;

        if( _.aux.is( src[ k ] ) )
        {
          extend( src[ k ], key );
        }
        else
        {
          _.assert( !!o.allowingCollision || o.dst[ key ] === undefined );
          o.dst[ key ] = src[ k ];
        }
      }

    }
    else
    {
      _.assert( 0, 'Expects map or array of maps, but got ' + _.entity.strType( src ) );
    }
  }

}

mapsFlatten.defaults =
{
  src : null,
  dst : null,
  allowingCollision : 0,
  delimeter : '/',
}

// //
//
// /**
//  * The mapToArray() converts an object {-srcMap-} into array [ [ key, value ] ... ].
//  *
//  * It takes an object {-srcMap-} creates an empty array,
//  * checks if ( arguments.length === 1 ) and {-srcMap-} is an object.
//  * If true, it returns a list of [ [ key, value ] ... ] pairs.
//  * Otherwise it throws an Error.
//  *
//  * @param { objectLike } src - object to get a list of [ key, value ] pairs.
//  *
//  * @example
//  * _.mapToArray( { a : 3, b : 13, c : 7 } );
//  * // returns [ [ 'a', 3 ], [ 'b', 13 ], [ 'c', 7 ] ]
//  *
//  * @returns { array } Returns a list of [ [ key, value ] ... ] pairs.
//  * @function mapToArray
//  * @throws { Error } Will throw an Error if( arguments.length !== 1 ) or {-srcMap-} is not an object.
//  * @namespace Tools
//  */
//
// function mapToArray( src, o )
// {
//   _.assert( this === _ );
//   return _.map.pairs( ... arguments );
// }

//

/**
 * The mapToStr() routine converts and returns the passed object {-srcMap-} to the string.
 *
 * It takes an object and two strings (keyValSep) and (tupleSep),
 * checks if (keyValSep and tupleSep) are strings.
 * If false, it assigns them defaults ( ' : ' ) to the (keyValSep) and
 * ( '; ' ) to the tupleSep.
 * Otherwise, it returns a string representing the passed object {-srcMap-}.
 *
 * @param { objectLike } src - The object to convert to the string.
 * @param { string } [ keyValSep = ' : ' ] keyValSep - colon.
 * @param { string } [ tupleSep = '; ' ] tupleSep - semicolon.
 *
 * @example
 * _.mapToStr( { a : 1, b : 2, c : 3, d : 4 }, ' : ', '; ' );
 * // returns 'a : 1; b : 2; c : 3; d : 4'
 *
 * @example
 * _.mapToStr( [ 1, 2, 3 ], ' : ', '; ' );
 * // returns '0 : 1; 1 : 2; 2 : 3';
 *
 * @example
 * _.mapToStr( 'abc', ' : ', '; ' );
 * // returns '0 : a; 1 : b; 2 : c';
 *
 * @returns { string } Returns a string (result) representing the passed object {-srcMap-}.
 * @function mapToStr
 * @namespace Tools
 */

function mapToStr( o )
{

  if( _.strIs( o ) )
  o = { src : o }

  _.routine.options( mapToStr, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = '';
  for( let s in o.src )
  {
    result += s + o.keyValDelimeter + o.src[ s ] + o.entryDelimeter;
  }

  result = result.substr( 0, result.length-o.entryDelimeter.length );

  return result
}

mapToStr.defaults =
{
  src : null,
  keyValDelimeter : ':',
  entryDelimeter : ';',
}

//

function fromHashMap( dstMap, srcMap )
{

  if( arguments.length === 1 )
  {
    srcMap = arguments[ 0 ];
    dstMap = null;
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.hashMap.is( srcMap ) );
  _.assert( !_.primitiveIs( dstMap ) || dstMap === null );

  if( dstMap === null )
  dstMap = Object.create( null );

  for( let pair of srcMap )
  {
    dstMap[ pair[ 0 ] ] = pair[ 1 ];
  }

  return dstMap
}

// --
// map logical operator
// --

/**
 * The mapButConditional() routine returns a new object (result)
 * whose (values) are not equal to the arrays or objects.
 *
 * Takes any number of objects.
 * If the first object has same key any other object has
 * then this pair [ key, value ] will not be included into (result) object.
 * Otherwise,
 * it calls a provided callback function( _.props.mapper.primitive() )
 * once for each key in the {-srcMap-}, and adds to the (result) object
 * all the [ key, value ],
 * if values are not equal to the array or object.
 *
 * @param { function } filter.primitive() - Callback function to test each [ key, value ] of the {-srcMap-} object.
 * @param { objectLike } srcMap - The target object.
 * @param { ...objectLike } arguments[] - The next objects.
 *
 * @example
 * _.mapButConditional_( null, _.props.mapper.primitive(), { a : 1, b : 'b', c : [ 1, 2, 3 ] } );
 * // returns { a : 1, b : "b" }
 *
 * @returns { object } Returns an object whose (values) are not equal to the arrays or objects.
 * @function mapButConditional
 * @throws { Error } Will throw an Error if {-srcMap-} is not an object.
 * @namespace Tools
 */

function mapButConditionalOld( propertyCondition, srcMap, butMap )
{
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( !_.primitive.is( butMap ), 'Expects non primitive {-butMap-}' );
  _.assert( !_.primitive.is( srcMap ), 'Expects non primitive {-srcMap-}' );
  _.assert( propertyCondition && propertyCondition.length === 3, 'Expects PropertyFilter {-propertyCondition-}' );
  _.assert( _.props.conditionIs( propertyCondition ) && !propertyCondition.identity.functor, 'Expects PropertyFilter {-propertyCondition-}' );

  let result = Object.create( null );

  /* aaa : allow and cover vector */ /* Dmytro : implemented, covered */
  if( _.countable.is( butMap ) )
  {
    let filterRoutines = [ filterWithVectorButMap, filterWithArrayLikeButMap ];
    let arrayLikeIs = _.argumentsArray.like( butMap ) ? 1 : 0;
    for( let s in srcMap )
    {
      let butKey = filterRoutines[ arrayLikeIs ]( s );
      if( butKey === undefined )
      result[ s ] = srcMap[ s ];
    }
  }
  else
  {
    for( let s in srcMap )
    {
      if( propertyCondition( butMap, srcMap, s ) )
      result[ s ] = srcMap[ s ];
    }
  }

  return result;

  /* */

  function filterWithVectorButMap( s )
  {
    for( let but of butMap )
    if( !propertyCondition( but, srcMap, s ) )
    return s;
  }

  /* */

  function filterWithArrayLikeButMap( s )
  {
    for( let m = 0 ; m < butMap.length ; m++ )
    if( !propertyCondition( butMap[ m ], srcMap, s ) )
    return s;
  }
}

//

function mapButConditional_( /* propertyCondition, dstMap, srcMap, butMap */ )
{
  // _.assert( arguments.length === 3 || arguments.length === 4, 'Expects three or four arguments' );

  _.assert( arguments.length === 4, 'Not clear how to construct {-dstMap-}. Please, specify exactly 4 arguments' );

  let propertyCondition = arguments[ 0 ];
  let dstMap = arguments[ 1 ];
  let srcMap = arguments[ 2 ];
  let butMap = arguments[ 3 ];

  if( dstMap === null )
  dstMap = arguments[ 1 ] = Object.create( null );

  // if( arguments.length === 3 )
  // {
  //   butMap = arguments[ 2 ];
  //   srcMap = arguments[ 1 ];
  // }

  /* */

  let o =
  {
    filter : propertyCondition,
    dstMap,
    srcMap,
    butMap,
  };

  o = _._mapBut_VerifyMapFields( o );
  _.assert( _.routineIs( o.filter ) && o.filter.length === 3, 'Expects filter {-o.filter-}' );
  _.assert( _.props.conditionIs( o.filter ), 'Expects PropertyFilter {-o.filter-}' );

  let filterRoutine = _._mapBut_FilterFunctor( o );

  for( let key in o.srcMap )
  filterRoutine( key );

  return o.dstMap;


  // return _._mapBut_
  // ({
  //   filter : propertyCondition,
  //   dstMap,
  //   srcMap,
  //   butMap,
  // });

  // _.assert( arguments.length === 3 || arguments.length === 4, 'Expects three or four arguments' );
  // _.assert( _.routineIs( propertyCondition ) && propertyCondition.length === 3, 'Expects PropertyFilter {-propertyCondition-}' );
  // _.assert( _.props.conditionIs( propertyCondition ) && !propertyCondition.identity.functor, 'Expects PropertyFilter {-propertyCondition-}' );
  // _.assert( !_.primitive.is( dstMap ), 'Expects map like {-dstMap-}' );
  // _.assert( !_.primitive.is( srcMap ) || _.longIs( srcMap ), 'Expects map {-srcMap-}' );
  // _.assert( !_.primitive.is( butMap ) || _.longIs( butMap ) || _.routineIs( butMap ), 'Expects object like {-butMap-}' );
  //
  // if( dstMap === srcMap )
  // {
  //
  //   /* aaa : allow and cover vector */ /* Dmytro : implemented, covered */
  //   if( _.vector.is( butMap ) )
  //   {
  //     for( let s in srcMap )
  //     {
  //       for( let m = 0 ; m < butMap.length ; m++ )
  //       {
  //         if( !propertyCondition( butMap[ m ], srcMap, s ) )
  //         delete dstMap[ s ];
  //       }
  //     }
  //   }
  //   else
  //   {
  //     for( let s in srcMap )
  //     {
  //       if( !propertyCondition( butMap, srcMap, s ) )
  //       delete dstMap[ s ];
  //     }
  //   }
  //
  // }
  // else
  // {
  //
  //   /* aaa : allow and cover vector */ /* Dmytro : implemented, covered */
  //   if( _.vector.is( butMap ) )
  //   {
  //     /* aaa : for Dmytro : bad */ /* Dmytro : for butMap types implemented two cyles. Types of elements is checked in filters */
  //     for( let s in srcMap )
  //     {
  //       let m;
  //       for( m = 0 ; m < butMap.length ; m++ )
  //       if( !propertyCondition( butMap[ m ], srcMap, s ) )
  //       break;
  //
  //       if( m === butMap.length )
  //       dstMap[ s ] = srcMap[ s ];
  //     }
  //   }
  //   else
  //   {
  //     for( let s in srcMap )
  //     {
  //       if( propertyCondition( butMap, srcMap, s ) )
  //       dstMap[ s ] = srcMap[ s ];
  //     }
  //   }
  //
  // }
  //
  // return dstMap;
}

//

/**
 * Returns new object with unique pairs key-value from {-srcMap-} screened by screen map {-butMap-}.
 *
 * from the first {-srcMap-} original object.
 * Values for result object come from original object {-srcMap-}
 * not from second or other one.
 * If the first object has same key any other object has
 * then this pair( key/value ) will not be included into result object.
 * Otherwise pair( key/value ) from the first object goes into result object.
 *
 * @param{ objectLike } srcMap - original object.
 * @param{ ...objectLike } arguments[] - one or more objects.
 * Objects to return an object without repeating keys.
 *
 * @example
 * _.mapBut_( null, { a : 7, b : 13, c : 3 }, { a : 7, b : 13 } );
 * // returns { c : 3 }
 *
 * Returns new object filled by unique keys
 * @throws { Error }
 *  In debug mode it throws an error if any argument is not object like.
 * @returns { object } Returns new object made by unique keys.
 * @function mapBut
 * @namespace Tools
 */

function mapButOld( srcMap, butMap )
{
  let result = Object.create( null );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitive.is( srcMap ), 'Expects map {-srcMap-}' );

  /* aaa : allow and cover vector */ /* Dmytro : implemented, covered */
  if( _.countable.is( butMap ) )
  {
    let filterRoutines = [ filterWithVectorButMap, filterWithArrayLikeButMap ];
    let arrayLikeIs = _.argumentsArray.like( butMap ) ? 1 : 0;
    for( let s in srcMap )
    {
      let butKey = filterRoutines[ arrayLikeIs ]( s );
      if( butKey === undefined )
      result[ s ] = srcMap[ s ];
    }

    // /* aaa : for Dmytro : bad */ /* Dmytro : improved, used checks with types */
    // for( let s in srcMap )
    // {
    //   let m;
    //   for( m = 0 ; m < butMap.length ; m++ )
    //   {
    //     /* aaa : for Dmytro : write GOOD coverage */ /* Dmytro : coverage extended */
    //     if( _.primitive.is( butMap[ m ] ) )
    //     {
    //       if( s === butMap[ m ] )
    //       break;
    //     }
    //     else
    //     {
    //       if( s in butMap[ m ] )
    //       break;
    //     }
    //     //
    //     // if( s === butMap[ m ] )
    //     // break;
    //     // if( _.aux.is( butMap[ m ] ) )
    //     // if( s in butMap[ m ] )
    //     // break;
    //   }
    //
    //   if( m === butMap.length )
    //   result[ s ] = srcMap[ s ];
    // }
  }
  else if( !_.primitive.is( butMap ) )
  {
    for( let s in srcMap )
    {
      if( !( s in butMap ) )
      result[ s ] = srcMap[ s ];
    }
  }
  else
  {
    _.assert( 0, 'Expects object-like or long-like {-butMap-}' ); /* xxx */
  }

  return result;

  /* */

  function filterWithVectorButMap( s )
  {
    for( let but of butMap )
    {
      if( _.primitive.is( but ) )
      {
        if( s === but )
        return s;
      }
      else if( _.aux.is( but ) )
      {
        if( s in but )
        return s;
      }
      else
      {
        _.assert( 0, 'Unexpected type of element' );
      }
    }
  }

  /* */

  function filterWithArrayLikeButMap( s )
  {
    for( let m = 0 ; m < butMap.length ; m++ )
    {
      if( _.primitive.is( butMap[ m ] ) )
      {
        if( s === butMap[ m ] )
        return s;
      }
      else if( _.aux.is( butMap[ m ] ) )
      {
        if( s in butMap[ m ] )
        return s;
      }
      else
      {
        _.assert( 0, 'Unexpected type of element' );
      }
    }
  }
}

//

function mapBut_( dstMap, srcMap, butMap )
{
  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );

  if( dstMap === null )
  dstMap = arguments[ 0 ] = arguments[ 0 ] || Object.create( null );

  _.assert( arguments.length === 3, 'Not clear how to construct {-dstMap-}. Please, specify exactly 3 arguments' );
  // if( arguments.length === 2 )
  // {
  //   butMap = arguments[ 1 ];
  //   srcMap = arguments[ 0 ];
  // }

  /* */

  let o =
  {
    dstMap,
    srcMap,
    butMap,
  };

  o = _._mapBut_VerifyMapFields( o );

  let mapsAreIdentical = o.dstMap === o.srcMap ? 1 : 0;
  let butMapsIsCountable = _.countable.is( o.butMap ) ? 2 : 0;
  let filterRoutines =
  [
    filterNotIdenticalWithAuxScreenMap,
    filterIdenticalWithAuxScreenMap,
    filterNotIdenticalWithVectorScreenMap,
    filterIdenticalWithVectorScreenMap
  ];
  let key = mapsAreIdentical + butMapsIsCountable;
  let filterRoutine = filterRoutines[ key ];
  let searchingRoutine;
  if( butMapsIsCountable )
  searchingRoutine = _screenMapSearchingRoutineFunctor( o.butMap );

  for( let key in o.srcMap )
  filterRoutine( key );

  return o.dstMap;

  /* */

  function filterNotIdenticalWithAuxScreenMap( key )
  {
    if( !( key in o.butMap ) )
    o.dstMap[ key ] = o.srcMap[ key ];
  }

  /* */

  function filterIdenticalWithAuxScreenMap( key )
  {
    if( key in o.butMap )
    delete o.dstMap[ key ];
  }

  /* */

  function filterNotIdenticalWithVectorScreenMap( key )
  {
    let butKey = searchingRoutine( o.butMap, key );
    if( butKey !== undefined )
    return;

    o.dstMap[ key ] = o.srcMap[ key ];
  }

  /* */

  function filterIdenticalWithVectorScreenMap( key )
  {
    let butKey = searchingRoutine( o.butMap, key );
    if( butKey !== undefined )
    delete o.dstMap[ key ];
  }

  // let filter = _.props.conditionFrom( filterBut );
  //
  // return _._mapBut_
  // ({
  //   filter,
  //   dstMap,
  //   srcMap,
  //   butMap,
  // });
  //
  // /* */
  //
  // /* qqq : for Dmytro : bad : not optimal */
  // function filterBut( butMap, srcMap, key )
  // {
  //   if( _.aux.is( butMap ) )
  //   {
  //     if( !( key in butMap ) )
  //     return key;
  //   }
  //   else if( _.primitive.is( butMap ) )
  //   {
  //     if( key !== butMap )
  //     return key;
  //   }
  // }
  // filterBut.identity = { propertyCondition : true, propertyTransformer : true };
  //
  // _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );
  // _.assert( !_.primitive.is( dstMap ), 'Expects map like destination map {-dstMap-}' );
  // _.assert( !_.primitive.is( srcMap ) || _.longIs( srcMap ), 'Expects long or map {-srcMap-}' );
  // _.assert( !_.primitive.is( butMap ) || _.longIs( butMap ) || _.routineIs( butMap ), 'Expects object like {-butMap-}' );
  //
  // if( dstMap === srcMap )
  // {
  //
  //   /* aaa : allow and cover vector */ /* Dmytro : implemented, covered */
  //   if( _.vector.is( butMap ) )
  //   {
  //     /* aaa : for Dmytro : bad */ /* Dmytro : for butMap types implemented two cyles. Types of elements is checked in filters */
  //     for( let s in srcMap )
  //     {
  //       for( let m = 0 ; m < butMap.length ; m++ )
  //       {
  //         /* aaa : for Dmytro : write GOOD coverage */ /* Dmytro : coverage extended */
  //         if( _.aux.is( butMap[ m ] ) )
  //         {
  //           if( s in butMap[ m ] )
  //           delete dstMap[ s ];
  //         }
  //         else
  //         {
  //           if( s === butMap[ m ] )
  //           delete dstMap[ s ];
  //         }
  //       }
  //     }
  //   }
  //   else
  //   {
  //     for( let s in srcMap )
  //     {
  //       if( s in butMap )
  //       delete dstMap[ s ];
  //     }
  //   }
  //
  // }
  // else
  // {
  //
  //   /* aaa : allow and cover vector */ /* Dmytro : implemented, covered */
  //   if( _.vector.is( butMap ) )
  //   {
  //     /* aaa : for Dmytro : bad */ /* Dmytro : for butMap types implemented two cyles. Types of elements is checked in filters */
  //     for( let s in srcMap )
  //     {
  //       let m;
  //       for( m = 0 ; m < butMap.length ; m++ )
  //       {
  //         /* aaa : for Dmytro : was bad implementation. cover */ /* Dmytro : improved, implemented, covered */
  //         if( _.primitiveIs( butMap[ m ] ) )
  //         {
  //           if( s === butMap[ m ] )
  //           break;
  //         }
  //         else
  //         {
  //           if( s in butMap[ m ] )
  //           break;
  //         }
  //       }
  //
  //       if( m === butMap.length )
  //       dstMap[ s ] = srcMap[ s ];
  //     }
  //   }
  //   else
  //   {
  //     for( let s in srcMap )
  //     {
  //       if( !( s in butMap ) )
  //       dstMap[ s ] = srcMap[ s ];
  //     }
  //   }
  //
  // }
  //
  // return dstMap;
}

//

function _mapBut_VerifyMapFields( o )
{
  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.assert( !_.primitive.is( o.dstMap ), 'Expects non primitive {-o.dstMap-}' );
  _.assert( !_.primitive.is( o.srcMap ), 'Expects non primitive {-o.srcMap-}' );
  _.assert( !_.primitive.is( o.butMap ), 'Expects object like {-o.butMap-}' );
  _.assert( !_.vector.is( o.dstMap ), 'Expects aux like {-o.dstMap-}' );
  return o;
}

//

function _mapBut_FilterFunctor( o )
{
  let mapsAreIdentical = o.dstMap === o.srcMap ? 1 : 0;
  let butMapIsCountable = _.countable.is( o.butMap ) ? 2 : 0;
  if( _.argumentsArray.like( o.butMap ) )
  butMapIsCountable += 2;
  let filterRoutines =
  [
    filterNotIdentical,
    filterIdentical,
    filterNotIdenticalWithVectorButMap,
    filterIdenticalWithVectorButMap,
    filterNotIdenticalWithArrayButMap,
    filterIdenticalWithArrayButMap,
  ];

  return filterRoutines[ mapsAreIdentical + butMapIsCountable ];

  /* */

  function filterNotIdentical( key )
  {
    if( o.filter( o.butMap, o.srcMap, key ) )
    o.dstMap[ key ] = o.srcMap[ key ];
  }

  /* */

  function filterIdentical( key )
  {
    if( !o.filter( o.butMap, o.srcMap, key ) )
    delete o.dstMap[ key ];
  }

  /* */

  function filterNotIdenticalWithArrayButMap( key )
  {
    for( let m = 0 ; m < o.butMap.length ; m++ )
    if( _.primitive.is( o.butMap[ m ] ) || _.aux.is( o.butMap[ m ] ) )
    {
      if( !o.filter( o.butMap[ m ], o.srcMap, key ) )
      return;
    }
    o.dstMap[ key ] = o.srcMap[ key ];
  }

  /* */

  function filterNotIdenticalWithVectorButMap( key )
  {
    for( let but of o.butMap )
    if( _.primitive.is( but ) || _.aux.is( but ) )
    {
      if( !o.filter( but, o.srcMap, key ) )
      return;
    }
    o.dstMap[ key ] = o.srcMap[ key ];
  }

  /* */

  function filterIdenticalWithArrayButMap( key )
  {
    for( let m = 0 ; m < o.butMap.length ; m++ )
    if( _.primitive.is( o.butMap[ m ] ) )
    {
      if( !o.filter( o.butMap[ m ], o.srcMap, key ) )
      delete o.dstMap[ key ];
    }
  }

  /* */

  function filterIdenticalWithVectorButMap( key )
  {
    for( let but of o.butMap )
    if( _.primitive.is( but ) )
    {
      if( !o.filter( but, o.srcMap, key ) )
      delete o.dstMap[ key ];
    }
  }
}
//
// //
//
// function _mapBut_( o )
// {
//   _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
//   _.assert( _.routineIs( o.filter ) && o.filter.length === 3, 'Expects filter {-o.filter-}' );
//   _.assert( _.props.conditionIs( o.filter ), 'Expects PropertyFilter {-o.filter-}' );
//   _.assert( !_.primitive.is( o.dstMap ), 'Expects non primitive {-o.dstMap-}' );
//   _.assert( !_.primitive.is( o.srcMap ), 'Expects non primitive {-o.srcMap-}' );
//   _.assert( !_.primitive.is( o.butMap ), 'Expects object like {-o.butMap-}' );
//   _.assert( !_.vector.is( o.dstMap ), 'Expects aux like {-o.dstMap-}' );
//   // _.assert( !_.primitive.is( o.butMap ) || _.vector.is( o.butMap ) || _.routineIs( o.butMap ), 'Expects object like {-o.butMap-}' );
//
//   let mapsAreIdentical = o.dstMap === o.srcMap ? 1 : 0;
//   let butMapIsVector = _.vector.is( o.butMap ) ? 2 : 0;
//   let filterRoutines =
//   [
//     filterNotIdentical,
//     filterIdentical,
//     filterNotIdenticalWithVectorButMap,
//     filterIdenticalWithVectorButMap
//   ];
//   let key = mapsAreIdentical + butMapIsVector;
//
//   for( let s in o.srcMap )
//   filterRoutines[ key ]( s );
//
//   return o.dstMap;
//
//   /* */
//
//   function filterNotIdentical( key )
//   {
//     if( o.filter( o.butMap, o.srcMap, key ) )
//     o.dstMap[ key ] = o.srcMap[ key ];
//   }
//
//   /* */
//
//   function filterIdentical( key )
//   {
//     if( !o.filter( o.butMap, o.srcMap, key ) )
//     delete o.dstMap[ key ];
//   }
//
//   /* */
//
//   function filterNotIdenticalWithVectorButMap( key )
//   {
//     /* aaa : for Dmytro : bad */ /* Dmytro : for butMap types implemented two cyles. Types of elements is checked in filters */
//     if( _.argumentsArray.like( o.butMap ) )
//     {
//       for( let m = 0 ; m < o.butMap.length ; m++ )
//       if( _.primitive.is( o.butMap[ m ] ) || _.aux.is( o.butMap[ m ] ) )
//       {
//         if( !o.filter( o.butMap[ m ], o.srcMap, key ) )
//         return;
//       }
//       // if( _.primitive.is( o.butMap[ m ] ) )
//       // {
//       //   if( !o.filter( o.butMap[ m ], o.srcMap, key ) )
//       //   return;
//       // }
//       o.dstMap[ key ] = o.srcMap[ key ];
//     }
//     else
//     {
//       for( let but of o.butMap )
//       if( _.primitive.is( but ) || _.aux.is( but ) )
//       {
//         if( !o.filter( but, o.srcMap, key ) )
//         return;
//       }
//       // if( _.primitive.is( but ) )
//       // {
//       //   if( !o.filter( but, o.srcMap, key ) )
//       //   return;
//       // }
//       o.dstMap[ key ] = o.srcMap[ key ];
//     }
//   }
//
//   /* */
//
//   function filterIdenticalWithVectorButMap( key )
//   {
//     if( _.argumentsArray.like( o.butMap ) )
//     {
//       for( let m = 0 ; m < o.butMap.length ; m++ )
//       if( _.primitive.is( o.butMap[ m ] ) )
//       {
//         if( !o.filter( o.butMap[ m ], o.srcMap, key ) )
//         delete o.dstMap[ key ];
//       }
//     }
//     else
//     {
//       for( let but of o.butMap )
//       if( _.primitive.is( but ) )
//       {
//         if( !o.filter( but, o.srcMap, key ) )
//         delete o.dstMap[ key ];
//       }
//     }
//   }
//
//   // if( o.dstMap === o.srcMap )
//   // {
//   //
//   //   /* aaa : allow and cover vector */ /* Dmytro : allowed, covered */
//   //   if( _.vector.is( o.butMap ) )
//   //   {
//   //     for( let s in o.srcMap )
//   //     {
//   //       for( let m = 0 ; m < o.butMap.length ; m++ )
//   //       {
//   //         if( !o.filter( o.butMap[ m ], o.srcMap, s ) )
//   //         delete o.dstMap[ s ];
//   //       }
//   //     }
//   //   }
//   //   else
//   //   {
//   //     for( let s in o.srcMap )
//   //     {
//   //       if( !o.filter( o.butMap, o.srcMap, s ) )
//   //       delete o.dstMap[ s ];
//   //     }
//   //   }
//   //
//   // }
//   // else
//   // {
//   //
//   //   /* aaa : allow and cover vector */ /* Dmytro : implemented, covered */
//   //   if( _.vector.is( o.butMap ) )
//   //   {
//   //      /* aaa : for Dmytro : bad */ /* Dmytro : for butMap types implemented two cyles. Types of elements is checked in filters */
//   //     for( let s in o.srcMap )
//   //     {
//   //       let m;
//   //       for( m = 0 ; m < o.butMap.length ; m++ )
//   //       if( !o.filter( o.butMap[ m ], o.srcMap, s ) )
//   //       break;
//   //
//   //       if( m === o.butMap.length )
//   //       o.dstMap[ s ] = o.srcMap[ s ];
//   //     }
//   //   }
//   //   else
//   //   {
//   //     for( let s in o.srcMap )
//   //     {
//   //       if( o.filter( o.butMap, o.srcMap, s ) )
//   //       o.dstMap[ s ] = o.srcMap[ s ];
//   //     }
//   //   }
//   //
//   // }
//   //
//   // return o.dstMap;
// }

//

function mapDelete( dstMap, ins )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !_.primitive.is( dstMap ) );
  if( ins === undefined )
  return _.mapEmpty( dstMap );
  return _.mapBut_( dstMap, dstMap, ins );
}

//

function mapEmpty( dstMap )
{

  _.assert( arguments.length === 1 );
  _.assert( !_.primitive.is( dstMap ) );

  for( let i in dstMap )
  {
    delete dstMap[ i ];
  }

  return dstMap;
}

//

/**
 * Returns new object with unique keys.
 *
 * Takes any number of objects.
 * Returns new object filled by unique keys
 * from the first {-srcMap-} original object.
 * Values for result object come from original object {-srcMap-}
 * not from second or other one.
 * If the first object has same key any other object has
 * then this pair( key/value ) will not be included into result object.
 * Otherwise pair( key/value ) from the first object goes into result object.
 *
 * @param{ objectLike } srcMap - original object.
 * @param{ ...objectLike } arguments[] - one or more objects.
 * Objects to return an object without repeating keys.
 *
 * @example
 * _.mapButIgnoringUndefines( { a : 7, b : 13, c : 3 }, { a : 7, b : 13 } );
 * // returns { c : 3 }
 *
 * @throws { Error }
 *  In debug mode it throws an error if any argument is not object like.
 * @returns { object } Returns new object made by unique keys.
 * @function mapButIgnoringUndefines
 * @namespace Tools
 */

// function mapButIgnoringUndefines( srcMap, butMap )
// {
//   let result = Object.create( null );
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   return _.mapButConditional_( null, _.props.condition.dstUndefinedSrcNotUndefined(), srcMap, butMap );
// }

//

function mapButIgnoringUndefines_( dstMap, srcMap, butMap )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );

  return _.mapButConditional_( _.props.condition.dstUndefinedSrcNotUndefined(), ... arguments );

}

//

/**
 * The mapOnlyOwnBut() returns new object with unique own keys.
 *
 * Takes any number of objects.
 * Returns new object filled by unique own keys
 * from the first {-srcMap-} original object.
 * Values for (result) object come from original object {-srcMap-}
 * not from second or other one.
 * If {-srcMap-} does not have own properties it skips rest of code and checks another properties.
 * If the first object has same key any other object has
 * then this pair( key/value ) will not be included into result object.
 * Otherwise pair( key/value ) from the first object goes into result object.
 *
 * @param { objectLike } srcMap - The original object.
 * @param { ...objectLike } arguments[] - One or more objects.
 *
 * @example
 * _.mapBut_( null, { a : 7, 'toString' : 5 }, { b : 33, c : 77 } );
 * // returns { a : 7 }
 *
 * @returns { object } Returns new (result) object with unique own keys.
 * @function mapOnlyOwnBut
 * @throws { Error } Will throw an Error if {-srcMap-} is not an object.
 * @namespace Tools
 */

function mapOnlyOwnButOld( srcMap, butMap )
{
  let result = Object.create( null );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  return _.mapButConditionalOld( _.props.condition.dstNotHasSrcOwn(), srcMap, butMap );
}

//

function mapOnlyOwnBut_( dstMap, srcMap, butMap )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );

  return _.mapButConditional_( _.props.condition.dstNotHasSrcOwn(), ... arguments );
}

//

/**
 * @typedef screenMaps
 * @property { objectLike } screenMaps.screenMap - The first object.
 * @property { ...objectLike } srcMap.arguments[1, ...] -
 * The pseudo array (arguments[]) from the first [1] index to the end.
 * @property { object } dstMap - The empty object.
 * @namespace Tools
 */

/**
 * The mapOnly() returns an object filled by unique [ key, value ]
 * from others objects.
 *
 * It takes number of objects, creates a new object by three properties
 * and calls the _mapOnly( {} ) with created object.
 *
 * @see  {@link wTools._mapOnly} - See for more information.
 *
 * @param { objectLike } screenMap - The first object.
 * @param { ...objectLike } arguments[] - One or more objects.
 *
 * @example
 * _.mapOnly_( null, { a : 13, b : 77, c : 3, d : 'name' }, { d : 'name', c : 33, a : 'abc' } );
 * // returns { a : "abc", c : 33, d : "name" };
 *
 * @returns { Object } Returns the object filled by unique [ key, value ]
 * from others objects.
 * @function mapOnly
 * @throws { Error } Will throw an Error if (arguments.length < 2) or (arguments.length !== 2).
 * @namespace Tools
 */

function mapOnlyOld( srcMaps, screenMaps )
{
  if( arguments.length === 1 )
  return _.mapsExtend( null, srcMaps );

  _.assert( arguments.length === 2, 'Expects single or two arguments' );

  return _._mapOnly
  ({
    srcMaps,
    screenMaps,
    dstMap : Object.create( null ),
  });
}

//

function mapOnly_( dstMap, srcMaps, screenMaps )
{


  if( arguments.length === 1 )
  return _.mapsExtend( null, dstMap );

  _.assert( arguments.length === 3, 'Not clear how to construct {-dstMap-}. Please, specify exactly 3 arguments' );

  // else if( arguments.length === 2 )
  // {
  //
  //   // return _.mapOnlyOld( srcMaps, screenMaps );
  //
  //   // aaa : for Dmytro : bad! /* Dmytro : this condition allow modify srcMaps if passed only 2 arguments */
  //   if( dstMap === null )
  //   return Object.create( null );
  //   screenMaps = arguments[ 1 ];
  //   srcMaps = arguments[ 0 ];
  // }
  // else if( arguments.length !== 3 )
  // {
  //   _.assert( 0, 'Expects at least one argument and no more then three arguments' );
  // }

  let o = _._mapOnly_VerifyMapFields
  ({
    srcMaps,
    screenMaps,
    dstMap : dstMap || Object.create( null ),
  });

  let mapsAreIdentical = o.dstMap === o.srcMaps ? 1 : 0;
  let screenMapsIsCountable = _.countable.is( o.screenMaps ) ? 2 : 0;
  let filterRoutines =
  [
    filterNotIdenticalWithAuxScreenMap,
    filterIdenticalWithAuxScreenMap,
    filterNotIdenticalWithVectorScreenMap,
    filterIdenticalWithVectorScreenMap
  ];
  let key = mapsAreIdentical + screenMapsIsCountable;
  let filterRoutine = filterRoutines[ key ];
  let searchingRoutine;
  if( screenMapsIsCountable )
  searchingRoutine = _screenMapSearchingRoutineFunctor( o.screenMaps );

  if( _.countable.is( o.srcMaps ) )
  {
    for( let srcMap of o.srcMaps )
    {
      _.assert( !_.primitive.is( srcMap ), 'Expects no primitive in {-o.srcMaps-}' );
      filterRoutine( srcMap );
    }
  }
  else
  {
    filterRoutine( o.srcMaps );
  }

  return o.dstMap;

  /* */

  function filterNotIdenticalWithVectorScreenMap( srcMap )
  {
    for( let key in srcMap )
    {
      let screenKey = searchingRoutine( o.screenMaps, key );
      if( screenKey !== undefined )
      o.dstMap[ screenKey ] = srcMap[ screenKey ];
    }
  }

  /* */

  function filterIdenticalWithVectorScreenMap( srcMap )
  {
    for( let key in srcMap )
    {
      let screenKey = searchingRoutine( o.screenMaps, key );
      if( screenKey === undefined )
      delete srcMap[ key ];
    }
  }

  /* */

  function filterNotIdenticalWithAuxScreenMap( srcMap )
  {
    for( let key in o.screenMaps )
    {
      if( o.screenMaps[ key ] === undefined )
      continue;

      if( key in srcMap )
      o.dstMap[ key ] = srcMap[ key ];
    }
  }


  /* */

  function filterIdenticalWithAuxScreenMap( srcMap )
  {
    for( let key in srcMap )
    {
      if( !( key in o.screenMaps ) )
      delete srcMap[ key ];
    }
  }

  // return _.mapOnlyOld( srcMaps, screenMaps );
  // aaa : for Dmytro : bad! /* Dmytro : improved, optimized */

  // return _._mapOnly_
  // ({
  //   srcMaps,
  //   screenMaps,
  //   dstMap,
  // });

}

// //
//
// function mapOnlyOwn( srcMaps, screenMaps )
// {
//
//   if( arguments.length === 1 )
//   return _.mapsExtendConditional( _.props.mapper.srcOwn(), null, srcMaps );
//
//   _.assert( arguments.length === 1 || arguments.length === 2, 'Expects single or two arguments' );
//
//   return _._mapOnly
//   ({
//     filter : _.props.mapper.srcOwn(),
//     srcMaps,
//     screenMaps,
//     dstMap : Object.create( null ),
//   });
//
// }

//

function mapOnlyOwn_( dstMap, srcMaps, screenMaps )
{

  if( arguments.length === 1 )
  return _.mapsExtendConditional( _.props.mapper.srcOwn(), null, _.array.as( dstMap ) );

  _.assert( arguments.length === 3, 'Not clear how to construct {-dstMap-}. Please, specify exactly 3 arguments' );

  // else if( arguments.length === 2 )
  // {
  //   if( dstMap === null )
  //   return Object.create( null );
  //
  //   screenMaps = arguments[ 1 ];
  //   srcMaps = arguments[ 0 ];
  // }
  // else if( arguments.length !== 3 )
  // {
  //   _.assert( 0, 'Expects at least one argument and no more then three arguments' );
  // }

  let o = _._mapOnly_VerifyMapFields
  ({
    filter : _.props.mapper.srcOwn(),
    srcMaps,
    screenMaps,
    dstMap : dstMap || Object.create( null ),
  });

  _.assert( _.props.mapperIs( o.filter ), 'Expects PropertyFilter {-o.filter-}' );

  let filterRoutine = _._mapOnly_FilterFunctor( o );

  if( _.countable.is( o.srcMaps ) )
  {
    for( let srcMap of o.srcMaps )
    {
      _.assert( !_.primitive.is( srcMap ), 'Expects no primitive in {-o.srcMaps-}' );
      filterRoutine( srcMap );
    }
  }
  else
  {
    filterRoutine( o.srcMaps );
  }

  return o.dstMap;

  // return _._mapOnly_
  // ({
  //   filter : _.props.mapper.srcOwn(),
  //   srcMaps,
  //   screenMaps,
  //   dstMap,
  // });

}

//

// function mapOnlyComplementing( srcMaps, screenMaps )
// {
//
//   _.assert( arguments.length === 1 || arguments.length === 2, 'Expects single or two arguments' );
//
//   return _._mapOnly
//   ({
//     filter : _.props.mapper.dstNotOwnOrUndefinedAssigning(),
//     srcMaps,
//     screenMaps,
//     dstMap : Object.create( null ),
//   });
//
// }

//

function mapOnlyComplementing_( dstMap, srcMaps, screenMaps )
{

  _.assert( arguments.length === 3, 'Not clear how to construct {-dstMap-}. Please, specify exactly 3 arguments' );

  // if( arguments.length === 2 )
  // {
  //   if( dstMap === null )
  //   return Object.create( null );
  //
  //   screenMaps = arguments[ 1 ];
  //   srcMaps = arguments[ 0 ];
  // }
  // else if( arguments.length !== 3 )
  // {
  //   _.assert( 0, 'Expects two or three arguments' );
  // }

  let o = _._mapOnly_VerifyMapFields
  ({
    filter : _.props.mapper.dstNotOwnOrUndefinedAssigning(),
    srcMaps,
    screenMaps,
    dstMap : dstMap || Object.create( null ),
  });

  _.assert( _.props.mapperIs( o.filter ), 'Expects PropertyFilter {-o.filter-}' );

  let filterRoutine = _._mapOnly_FilterFunctor( o );

  if( _.countable.is( o.srcMaps ) )
  {
    for( let srcMap of o.srcMaps )
    {
      _.assert( !_.primitive.is( srcMap ), 'Expects no primitive in {-o.srcMaps-}' );
      filterRoutine( srcMap );
    }
  }
  else
  {
    filterRoutine( o.srcMaps );
  }

  return o.dstMap;

  // return _._mapOnly_
  // ({
  //   filter : _.props.mapper.dstNotOwnOrUndefinedAssigning(),
  //   srcMaps,
  //   screenMaps,
  //   dstMap,
  // });

}

//

/**
 * @callback  options.filter
 * @param { objectLike } dstMap - An empty object.
 * @param { objectLike } srcMaps - The target object.
 * @param { string } - The key of the (screenMap).
 */

/**
 * The _mapOnly() returns an object filled by unique [ key, value]
 * from others objects.
 *
 * The _mapOnly() checks whether there are the keys of
 * the (screenMap) in the list of (srcMaps).
 * If true, it calls a provided callback function(filter)
 * and adds to the (dstMap) all the [ key, value ]
 * for which callback function returns true.
 *
 * @param { function } [options.filter = filter.bypass()] options.filter - The callback function.
 * @param { objectLike } options.srcMaps - The target object.
 * @param { objectLike } options.screenMaps - The source object.
 * @param { Object } [options.dstMap = Object.create( null )] options.dstMap - The empty object.
 *
 * @example
 * let options = Object.create( null );
 * options.dstMap = Object.create( null );
 * options.screenMaps = { 'a' : 13, 'b' : 77, 'c' : 3, 'name' : 'Mikle' };
 * options.srcMaps = { 'a' : 33, 'd' : 'name', 'name' : 'Mikle', 'c' : 33 };
 * _mapOnly( options );
 * // returns { a : 33, c : 33, name : "Mikle" };
 *
 * @example
 * let options = Object.create( null );
 * options.dstMap = Object.create( null );
 * options.screenMaps = { a : 13, b : 77, c : 3, d : 'name' };
 * options.srcMaps = { d : 'name', c : 33, a : 'abc' };
 * _mapOnly( options );
 * // returns { a : "abc", c : 33, d : "name" };
 *
 * @returns { Object } Returns an object filled by unique [ key, value ]
 * from others objects.
 * @function _mapOnly
 * @throws { Error } Will throw an Error if (options.dstMap or screenMap) are not objects,
 * or if (srcMaps) is not an array
 * @namespace Tools
 */

/* xxx : qqq : for Dmytro : comment out */
function _mapOnly( o )
{
  let self = this;

  o.dstMap = o.dstMap || Object.create( null );
  o.filter = o.filter || _.props.mapper.bypass();

  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.assert( _.props.mapperIs( o.filter ), 'Expects PropertyFilter {-o.filter-}' );
  _.assert( !_.primitive.is( o.dstMap ), 'Expects non primitive {-o.dstMap-}' );
  _.assert( !_.primitive.is( o.screenMaps ), 'Expects non primitive {-o.screenMaps-}' );
  _.assert( !_.primitive.is( o.srcMaps ), 'Expects non primitive {-srcMap-}' );
  _.map.assertHasOnly( o, _mapOnly.defaults );

  /* aaa : allow and cover vector */ /* Dmytro : implemented, covered */
  if( _.countable.is( o.srcMaps ) )
  for( let srcMap of o.srcMaps )
  {
    _.assert( !_.primitive.is( srcMap ), 'Expects non primitive {-srcMap-}' );

    if( _.countable.is( o.screenMaps ) )
    filterSrcMapWithVectorScreenMap( srcMap );
    else
    filterSrcMap( srcMap );
  }
  else
  {
    if( _.countable.is( o.screenMaps ) )
    filterSrcMapWithVectorScreenMap( o.srcMaps );
    else
    filterSrcMap( o.srcMaps );
  }

  return o.dstMap;

  /* */

  function filterSrcMapWithVectorScreenMap( srcMap )
  {
    for( let key in srcMap )
    {
      let screenKey = screenKeySearch( key );
      if( screenKey )
      o.filter.call( self, o.dstMap, srcMap, screenKey );
    }
  }

  /* */

  function screenKeySearch( key )
  {
    if( _.argumentsArray.like( o.screenMaps ) )
    {
      for( let m = 0 ; m < o.screenMaps.length ; m++ )
      if( _.primitive.is( o.screenMaps[ m ] ) )
      {
        if( o.screenMaps[ m ] === key )
        return key;
      }
    }
    else
    {
      for( let m of o.screenMaps )
      if( _.primitive.is( m ) )
      {
        if( m === key )
        return key;
      }
    }

    // let m;
    // if( _.argumentsArray.like( o.screenMaps ) )
    // {
    //   for( m = 0 ; m < o.screenMaps.length ; m++ )
    //   if( _.vector.is( o.screenMaps[ m ] ) && key in o.screenMaps[ m ] )
    //   return key;
    //   else if( _.aux.is( o.screenMaps[ m ] ) && key in o.screenMaps[ m ] )
    //   return key;
    //   else if( _.primitive.is( o.screenMaps[ m ] ) && o.screenMaps[ m ] === key )
    //   return key;
    //   else if( key === String( m ) )
    //   return key;
    // }
    // else
    // {
    //   for( m of o.screenMaps )
    //   if( _.vector.is( m ) && key in m )
    //   return key;
    //   else if( _.aux.is( m ) && key in m )
    //   return key;
    //   else if( _.primitive.is( m ) && m === key )
    //   return key;
    // }
  }

  /* */

  function filterSrcMap( srcMap )
  {
    for( let key in o.screenMaps )
    {
      if( o.screenMaps[ key ] === undefined )
      continue;

      if( key in srcMap )
      o.filter.call( this, o.dstMap, srcMap, key );
    }
  }

  // let dstMap = o.dstMap || Object.create( null );
  // let screenMap = o.screenMaps;
  // let srcMaps = o.srcMaps;
  //
  // /* aaa : for Dmytro : not optimal */ /* Dmytro : optimized */
  // if( !_.vector.is( srcMaps ) )
  // srcMaps = [ srcMaps ];
  //
  // if( !o.filter )
  // o.filter = _.props.mapper.bypass();
  //
  // if( Config.debug )
  // {
  //
  //   // _.assert( o.filter.functionFamily === 'PropertyMapper' );
  //   _.assert( _.props.mapperIs( o.filter ), 'Expects PropertyFilter {-propertyCondition-}' );
  //   _.assert( arguments.length === 1, 'Expects single argument' );
  //   _.assert( !_.primitive.is( dstMap ), 'Expects object-like {-dstMap-}' );
  //   _.assert( !_.primitive.is( screenMap ), 'Expects not primitive {-screenMap-}' );
  //   _.assert( _.vector.is( srcMaps ), 'Expects array {-srcMaps-}' );
  //   _.map.assertHasOnly( o, _mapOnly.defaults );
  //
  //   for( let s = srcMaps.length - 1 ; s >= 0 ; s-- )
  //   _.assert( !_.primitive.is( srcMaps[ s ] ), 'Expects {-srcMaps-}' );
  //
  // }
  //
  // if( _.longIs( screenMap ) )
  // {
  //   for( let k in screenMap ) /* aaa : for Dmytro : bad */ /* Dmytro : improved, used conditions for types */
  //   {
  //
  //     if( screenMap[ k ] === undefined )
  //     continue;
  //
  //     let s;
  //     for( s = srcMaps.length-1 ; s >= 0 ; s-- )
  //     {
  //       if( !_.aux.is( screenMap[ k ] ) && screenMap[ k ] in srcMaps[ s ] )
  //       // k = screenMap[ k ]; /* aaa : ? */ /* Dmytro : key definition */
  //       break;
  //       if( k in srcMaps[ s ] )
  //       break;
  //     }
  //
  //     if( s === -1 )
  //     continue;
  //
  //     o.filter.call( this, dstMap, srcMaps[ s ], k );
  //
  //   }
  // }
  // else
  // {
  //   for( let k in screenMap )
  //   {
  //     if( screenMap[ k ] === undefined )
  //     continue;
  //
  //     for( let s in srcMaps )
  //     if( k in srcMaps[ s ] )
  //     o.filter.call( this, dstMap, srcMaps[ s ], k );
  //   }
  // }
  //
  // return dstMap;
}

_mapOnly.defaults =
{
  dstMap : null,
  srcMaps : null,
  screenMaps : null,
  filter : null,
}

//

function _mapOnly_VerifyMapFields( o )
{
  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.assert( !_.primitive.is( o.dstMap ), 'Expects non primitive {-o.dstMap-}' );
  _.assert( !_.primitive.is( o.screenMaps ), 'Expects non primitive {-o.screenMaps-}' );
  _.assert( !_.primitive.is( o.srcMaps ), 'Expects non primitive {-o.srcMaps-}' );
  _.map.assertHasOnly( o, _mapOnly_VerifyMapFields.defaults );
  _.assert( !_.vector.is( o.dstMap ), 'Expects not a vector {-o.dstMap-}' );

  return o;
}

_mapOnly_VerifyMapFields.defaults =
{
  dstMap : null,
  srcMaps : null,
  screenMaps : null,
  filter : null,
}

//

function _mapOnly_FilterFunctor( o )
{
  let self = this;
  let mapsAreIdentical = o.dstMap === o.srcMaps ? 1 : 0;
  let screenMapsIsVector = _.vector.is( o.screenMaps ) ? 2 : 0;
  let filterRoutines =
  [
    filterNotIdenticalWithAuxScreenMap,
    filterIdenticalWithAuxScreenMap,
    filterNotIdenticalWithVectorScreenMap,
    filterIdenticalWithVectorScreenMap
  ];
  let key = mapsAreIdentical + screenMapsIsVector;
  let searchingRoutine;
  if( screenMapsIsVector )
  searchingRoutine = _screenMapSearchingRoutineFunctor( o.screenMaps );

  return filterRoutines[ key ];

  /* */

  function filterNotIdenticalWithVectorScreenMap( srcMap )
  {
    for( let key in srcMap )
    {
      let screenKey = searchingRoutine( o.screenMaps, key );
      if( screenKey !== undefined )
      o.filter.call( self, o.dstMap, srcMap, key );
    }
  }

  /* */

  function filterIdenticalWithVectorScreenMap( srcMap )
  {
    for( let key in srcMap )
    {
      let screenKey = searchingRoutine( o.screenMaps, key );
      if( screenKey === undefined )
      delete srcMap[ key ];
      else
      o.filter.call( self, o.dstMap, srcMap, key );
    }
  }

  /* */

  function filterNotIdenticalWithAuxScreenMap( srcMap )
  {
    for( let key in o.screenMaps )
    {
      if( o.screenMaps[ key ] === undefined )
      continue;

      if( key in srcMap )
      o.filter.call( self, o.dstMap, srcMap, key );
    }
  }

  /* */

  function filterIdenticalWithAuxScreenMap( srcMap )
  {
    for( let key in srcMap )
    {
      if( !( key in o.screenMaps ) )
      delete srcMap[ key ];
      else
      o.filter.call( self, o.dstMap, srcMap, key );
    }
  }
}

/* */

function _screenMapSearchingRoutineFunctor( screenMaps )
{
  let screenMapsIsArray = _.argumentsArray.like( screenMaps ) ? 1 : 0;
  let searchingRoutines =
  [
    searchKeyInVectorScreenMapWithPrimitives,
    searchKeyInArrayScreenMapWithPrimitives,
    searchKeyInVectorScreenMapWithMaps,
    searchKeyInArrayScreenMapWithMaps,
  ];

  let element;
  if( screenMapsIsArray )
  {
    element = screenMaps[ 0 ];
  }
  else
  {
    for( let el of screenMaps )
    {
      element = el;
      break;
    }
  }

  let screenMapsElementIsAux = _.aux.is( element ) ? 2 : 0;
  return searchingRoutines[ screenMapsIsArray + screenMapsElementIsAux ];

  /* */

  function searchKeyInArrayScreenMapWithPrimitives( screenMaps, key )
  {
    for( let m = 0 ; m < screenMaps.length ; m++ )
    if( screenMaps[ m ] === key )
    return key;
  }

  function searchKeyInArrayScreenMapWithMaps( screenMaps, key )
  {
    for( let m = 0 ; m < screenMaps.length ; m++ )
    if( key in screenMaps[ m ] )
    return key;
  }

  /* */

  function searchKeyInVectorScreenMapWithPrimitives( screenMaps, key )
  {
    for( let m of screenMaps )
    if( m === key )
    return key;
  }

  function searchKeyInVectorScreenMapWithMaps( screenMaps, key )
  {
    for( let m of screenMaps )
    if( key in m )
    return key;
  }
}

/* */

// function _mapOnly_SearchKeyInVectorScreenMap( screenMaps, key )
// {
//   if( _.argumentsArray.like( screenMaps ) )
//   {
//     for( let m = 0 ; m < screenMaps.length ; m++ )
//     if( _.primitive.is( screenMaps[ m ] ) )
//     {
//       if( screenMaps[ m ] === key )
//       return key;
//     }
//     else if( _.aux.is( screenMaps[ m ] ) )
//     {
//       if( key in screenMaps[ m ] )
//       return key;
//     }
//   }
//   else
//   {
//     for( let m of screenMaps )
//     if( _.primitive.is( m ) )
//     {
//       if( m === key )
//       return key;
//     }
//     else if( _.aux.is( m ) )
//     {
//       if( key in m )
//       return key;
//     }
//   }
// }
//
// //
//
// function _mapOnly_( o )
// {
//   let self = this;
//   o.dstMap = o.dstMap || Object.create( null );
//   o.filter = o.filter || _.props.mapper.bypass();
//
//   _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
//   _.assert( _.props.mapperIs( o.filter ), 'Expects PropertyFilter {-o.filter-}' );
//   _.assert( !_.primitive.is( o.dstMap ), 'Expects non primitive {-o.dstMap-}' );
//   _.assert( !_.primitive.is( o.screenMaps ), 'Expects non primitive {-o.screenMaps-}' );
//   _.assert( !_.primitive.is( o.srcMaps ), 'Expects non primitive {-o.srcMaps-}' );
//   _.map.assertHasOnly( o, _mapOnly_.defaults );
//   _.assert( !_.vector.is( o.dstMap ), 'Expects not a vector {-o.dstMap-}' );
//
//   /* aaa : allow and cover vector */ /* Dmytro : allowed, covered. I think, an optimization for array like vectors has no sense. Otherwise, we need to add single branch with for cycle */
//
//   let mapsAreIdentical = o.dstMap === o.srcMaps ? 1 : 0;
//   let screenMapsIsVector = _.vector.is( o.screenMaps ) ? 2 : 0;
//   let filterRoutines = [ filterNotIdentical, filterIdentical, filterWithVectorScreenMap, filterWithVectorScreenMap ];
//   let filterCallbacks = [ filterNotIdenticalMaps, filterIdenticalMaps ];
//   let key = mapsAreIdentical + screenMapsIsVector;
//
//   if( _.vector.is( o.srcMaps ) )
//   {
//     for( let srcMap of o.srcMaps )
//     {
//       _.assert( !_.primitive.is( srcMap ), 'Expects no primitive in {-o.srcMaps-}' );
//       filterRoutines[ key ]( srcMap, filterCallbacks[ mapsAreIdentical ] );
//     }
//   }
//   else
//   {
//     filterRoutines[ key ]( o.srcMaps, filterCallbacks[ mapsAreIdentical ] );
//   }
//
//   return o.dstMap;
//
//   /* */
//
//   function filterNotIdenticalMaps( src, key, foundKey )
//   {
//     if( foundKey !== undefined )
//     o.filter.call( self, o.dstMap, src, key );
//   }
//
//   /* */
//
//   function filterIdenticalMaps( src, key, foundKey )
//   {
//     if( foundKey === undefined )
//     delete src[ key ];
//     else
//     o.filter.call( self, o.dstMap, src, key );
//   }
//
//   /* */
//
//   function filterWithVectorScreenMap( srcMap, filterCallback )
//   {
//     for( let key in srcMap )
//     {
//       let screenKey = screenMapSearch( key );
//       filterCallback( srcMap, key, screenKey );
//     }
//   }
//
//   /* */
//
//   function screenMapSearch( key )
//   {
//     if( _.argumentsArray.like( o.screenMaps ) )
//     {
//       for( let m = 0 ; m < o.screenMaps.length ; m++ )
//       if( _.primitive.is( o.screenMaps[ m ] ) )
//       {
//         if( o.screenMaps[ m ] === key )
//         return key;
//       }
//       else if( _.aux.is( o.screenMaps[ m ] ) )
//       {
//         if( key in o.screenMaps[ m ] )
//         return key;
//       }
//       // if( _.primitive.is( o.screenMaps[ m ] ) )
//       // {
//       //   if( o.screenMaps[ m ] === key )
//       //   return key;
//       // }
//     }
//     else
//     {
//       for( let m of o.screenMaps )
//       if( _.primitive.is( m ) )
//       {
//         if( m === key )
//         return key;
//       }
//       else if( _.aux.is( m ) )
//       {
//         if( key in m )
//         return key;
//       }
//       // if( _.primitive.is( m ) )
//       // {
//       //   if( m === key )
//       //   return key;
//       // }
//     }
//     // if( _.argumentsArray.like( o.screenMaps ) )
//     // {
//     //   for( let m = 0 ; m < o.screenMaps.length ; m++ )
//     //   if( _.vector.is( o.screenMaps[ m ] ) && key in o.screenMaps[ m ] )
//     //   return key;
//     //   else if( _.aux.is( o.screenMaps[ m ] ) && key in o.screenMaps[ m ] )
//     //   return key;
//     //   else if( _.primitive.is( o.screenMaps[ m ] ) && o.screenMaps[ m ] === key )
//     //   return key;
//     //   else if( key === String( m ) )
//     //   return key;
//     // }
//     // else
//     // {
//     //   for( let e of o.screenMaps )
//     //   if( _.vector.is( e ) && key in e )
//     //   return key;
//     //   else if( _.aux.is( e ) && key in e )
//     //   return key;
//     //   else if( _.primitive.is( e ) && e === key )
//     //   return key;
//     // }
//   }
//
//   /* */
//
//   function filterNotIdentical( srcMap )
//   {
//     for( let key in o.screenMaps )
//     {
//       if( o.screenMaps[ key ] === undefined )
//       continue;
//
//       if( key in srcMap )
//       o.filter.call( self, o.dstMap, srcMap, key );
//     }
//     // for( let key in srcMap )
//     // {
//     //   if( ( key in o.screenMaps ) && o.screenMaps[ key ] !== undefined )
//     //   o.filter.call( self, o.dstMap, srcMap, key );
//     // }
//   }
//
//   /* */
//
//   function filterIdentical( srcMap )
//   {
//     for( let key in srcMap )
//     {
//       if( !( key in o.screenMaps ) )
//       delete srcMap[ key ];
//       else
//       o.filter.call( self, o.dstMap, srcMap, key );
//     }
//   }
//
//   // let dstMap = o.dstMap || Object.create( null );
//   // let screenMap = o.screenMaps;
//   // let srcMaps = o.srcMaps;
//   //
//   // /* aaa : for Dmytro : not optimal */ /* Dmytro : optimized */
//   // if( !_.vector.is( srcMaps ) )
//   // srcMaps = [ srcMaps ];
//   //
//   // if( !o.filter )
//   // o.filter = _.props.mapper.bypass();
//   //
//   // if( Config.debug )
//   // {
//   //
//   //   // _.assert( o.filter.functionFamily === 'PropertyMapper' );
//   //   _.assert( _.props.mapperIs( o.filter ), 'Expects PropertyFilter {-propertyCondition-}' );
//   //   _.assert( arguments.length === 1, 'Expects single argument' );
//   //   _.assert( !_.primitive.is( dstMap ), 'Expects object-like {-dstMap-}' );
//   //   _.assert( !_.primitive.is( screenMap ), 'Expects not primitive {-screenMap-}' );
//   //   _.assert( _.vector.is( srcMaps ), 'Expects vector {-srcMaps-}' );
//   //   _.map.assertHasOnly( o, _mapOnly_.defaults );
//   //   _.map.assertHasOnly( o, _mapOnly_.defaults );
//   //
//   //   for( let s = srcMaps.length - 1 ; s >= 0 ; s-- )
//   //   _.assert( !_.primitive.is( srcMaps[ s ] ), 'Expects {-srcMaps-}' );
//   //
//   // }
//   //
//   // /* aaa : allow and cover vector */ /* Dmytro : implemented, covered */
//   //
//   // if( o.dstMap === o.srcMaps || o.dstMap === o.srcMaps[ 0 ] )
//   // {
//   //   if( _.vector.is( screenMap ) )
//   //   _mapsFilterWithLongScreenMap.call( this, mapsIdenticalFilterWithLong );
//   //   else
//   //   _mapsIdenticalFilter.call( this );
//   // }
//   // else
//   // {
//   //   if( _.vector.is( screenMap ) )
//   //   _mapsFilterWithLongScreenMap.call( this, mapsNotIdenticalFilterWithLong );
//   //   else
//   //   _mapsNotIdenticalFilter.call( this )
//   // }
//   //
//   // return dstMap;
//   //
//   // /* */
//   //
//   // function _mapsFilterWithLongScreenMap( filterCallback )
//   // {
//   //   for( let s in srcMaps )
//   //   {
//   //     let srcMap = srcMaps[ s ];
//   //
//   //     for( let k in srcMap )
//   //     {
//   //       let m = iterateKeyOfScreenMap( k );
//   //       // for( m = 0 ; m < screenMap.length ; m++ ) /* aaa : for Dmytro : teach to work with any vector here and in similar places */ /* Dmytro : implemented */
//   //       // for( m of screenMap )
//   //       // {
//   //       //   if( _.vector.is( screenMap[ m ] ) )
//   //       //   {
//   //       //     /* aaa : for Dmytro : check */ /* Dmytro : covered */
//   //       //     if( k in screenMap[ m ] )
//   //       //     break;
//   //       //   }
//   //       //   else
//   //       //   {
//   //       //     if( k === String( m ) )
//   //       //     break;
//   //       //   }
//   //       // }
//   //
//   //       filterCallback.call( this, srcMap, m, k );
//   //     }
//   //   }
//   // }
//   //
//   // /* */
//   //
//   // function iterateKeyOfScreenMap( k )
//   // {
//   //   let m;
//   //   if( _.argumentsArray.like( screenMap ) )
//   //   {
//   //     for( m = 0 ; m < screenMap.length ; m++ )
//   //     if( _.vector.is( screenMap[ m ] ) && k in screenMap[ m ] )
//   //     return m;
//   //     else if( _.aux.is( screenMap[ m ] ) && k in screenMap[ m ] )
//   //     return m;
//   //     else if( _.primitive.is( screenMap[ m ] ) && screenMap[ m ] === k )
//   //     return m;
//   //     else if( k === String( m ) )
//   //     return m;
//   //   }
//   //   else
//   //   {
//   //     for( m of screenMap )
//   //     if( _.vector.is( m ) && k in m )
//   //     return k;
//   //     else if( _.aux.is( m ) && k in m )
//   //     return k;
//   //     else if( _.primitive.is( m ) && m === k )
//   //     return k;
//   //
//   //     return srcMaps.length;
//   //   }
//   //
//   //   return m;
//   // }
//   //
//   // /* */
//   //
//   // function mapsIdenticalFilterWithLong( src, index, key )
//   // {
//   //   if( index === screenMap.length )
//   //   delete src[ key ];
//   //   else
//   //   o.filter.call( this, dstMap, src, key );
//   // }
//   //
//   // /* */
//   //
//   // function mapsNotIdenticalFilterWithLong( src, index, key )
//   // {
//   //   if( index !== screenMap.length )
//   //   o.filter.call( this, dstMap, src, key );
//   // }
//   //
//   // /* */
//   //
//   // function _mapsIdenticalFilter()
//   // {
//   //   for( let s in srcMaps )
//   //   {
//   //     let srcMap = srcMaps[ s ];
//   //
//   //     for( let k in srcMap )
//   //     {
//   //       if( !( k in screenMap ) )
//   //       delete srcMap[ k ];
//   //       else
//   //       o.filter.call( this, dstMap, srcMap, k );
//   //     }
//   //   }
//   // }
//   //
//   // /* */
//   //
//   // function _mapsNotIdenticalFilter()
//   // {
//   //   for( let k in screenMap )
//   //   {
//   //     if( screenMap[ k ] === undefined )
//   //     continue;
//   //
//   //     for( let s in srcMaps )
//   //     if( k in srcMaps[ s ] )
//   //     o.filter.call( this, dstMap, srcMaps[ s ], k );
//   //   }
//   // }
// }
//
// _mapOnly_.defaults =
// {
//   dstMap : null,
//   srcMaps : null,
//   screenMaps : null,
//   filter : null,
// }

//

/* qqq : cover */
function mapDiff( dst, src1, src2 )
{
  if( arguments.length === 2 )
  {
    dst = null;
    src1 = arguments[ 0 ];
    src2 = arguments[ 1 ];
  }

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( dst === null || _.aux.is( dst ) );

  dst = dst || Object.create( null );

  dst.src1 = _.mapBut_( dst.src1 || null, src1, src2 );
  dst.src2 = _.mapBut_( dst.src2 || null, src2, src1 );
  dst.src2 = _.props.extend( null, dst.src1, dst.src2 );
  dst.identical = Object.keys( dst.src1 ).length === 0 && Object.keys( dst.src2 ).length === 0;

  return dst;
}

// --
// map sure
// --

function sureHasExactly( srcMap, screenMaps, msg )
{
  let result = true;

  result = result && _.map.sureHasOnly.apply( this, arguments );
  result = result && _.map.sureHasAll.apply( this, arguments );

  return true;
}

//

function sureOwnExactly( srcMap, screenMaps, msg )
{
  let result = true;

  result = result && _.map.sureOwnOnly.apply( this, arguments );
  result = result && _.map.sureOwnAll.apply( this, arguments );

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has only properties represented in object(s) passed after first argument. Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2. {@link wTools.err See err}
 * If routine found some unique properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after last object. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { Object } screenMaps - object to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let a = { a : 1, b : 3 };
 * let b = { a : 2, b : 3 };
 * _.map.sureHasOnly( a, b );
 * // no exception
 *
 * @example
 * let a = { a : 1, c : 3 };
 * let b = { a : 2, b : 3 };
 * _.map.sureHasOnly( a, b );
 *
 * // log
 * // caught <anonymous>:3:8
 * // Object should have no fields : c
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:3
 *
 * @example
 * let x = { d : 1 };
 * let a = Object.create( x );
 * let b = { a : 1 };
 * _.map.sureHasOnly( a, b, 'message' )
 *
 * // log
 * // caught <anonymous>:4:8
 * // message Object should have no fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:4
 *
 * @example
 * let x = { d : 1 };
 * let a = Object.create( x );
 * let b = { a : 1 };
 * _.map.sureHasOnly( a, b, () => 'message, ' + 'map`, ' should have no fields :'  )
 *
 * // log
 * // caught <anonymous>:4:8
 * // message Object should have no fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:4
 *
 * @function sureHasOnly
 * @throws {Exception} If no arguments are provided or more than four arguments are provided.
 * @throws {Exception} If map {-srcMap-} contains unique property.
 * @namespace Tools
 *
 */

function sureHasOnly( srcMap, screenMaps, msg )
{
  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4, 'Expects two, three or four arguments' );

  /* qqq : for Dmytro : bad ! */
  // let but = Object.keys( _.mapBut_( null, srcMap, screenMaps ) );
  let but = Object.keys( _.mapButOld( srcMap, screenMaps ) );

  if( but.length > 0 )
  {
    let err;
    if( arguments.length === 2 )
    err = _._err
    ({
      args : [ `${ _.entity.strType( srcMap ) } should have no fields :`, _.strQuote( but ).join( ', ' ) ],
      level : 2,
    });
    else
    {
      let arr = [];
      for( let i = 2; i < arguments.length; i++ )
      {
        if( _.routine.is( arguments[ i ] ) )
        arguments[ i ] = ( arguments[ i ] )();
        arr.push( arguments[ i ] );
      }
      err = _._err
      ({
        args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    debugger; /* eslint-disable-line no-debugger */
    throw err;
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has only properties represented in object(s) passed after first argument. Checks only own properties of the objects.
 * Works only in debug mode. Uses StackTrace level 2.{@link wTools.err See err}
 * If routine found some unique properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after last object. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { Object } screenMaps - object to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let x = { d : 1 };
 * let a = Object.create( x );
 * a.a = 5;
 * let b = { a : 2 };
 * _.map.sureOwnOnly( a, b );
 * //no exception
 *
 * @example
 * let a = { d : 1 };
 * let b = { a : 2 };
 * _.map.sureOwnOnly( a, b );
 *
 * // log
 * // caught <anonymous>:3:10
 * // Object should have no own fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0, y : 2 };
 * let b = { c : 0, d : 3};
 * let c = { a : 1 };
 * _.map.sureOwnOnly( a, b, 'error msg' );
 *
 * // log
 * // caught <anonymous>:4:8
 * // error msg Object should have no own fields : x, y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:4
 *
 * @example
 * let a = { x : 0, y : 2 };
 * let b = { c : 0, d : 3};
 * let c = { a : 1 };
 * _.map.sureOwnOnly( a, b, () => 'error, ' + 'map should', ' no own fields :' );
 *
 * // log
 * // caught <anonymous>:4:9
 * // error, map should have no own fields : x, y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:3
 *
 * @function sureOwnOnly
 * @throws {Exception} If no arguments are provided or more than four arguments are provided.
 * @throws {Exception} If map {-srcMap-} contains unique property.
 * @namespace Tools
 *
 */

function sureOwnOnly( srcMap, screenMaps, msg )
{
  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4, 'Expects two, three or four arguments' );

  /* qqq : for Dmytro : bad! */
  let but = Object.keys( _.mapOnlyOwnButOld( srcMap, screenMaps ) );

  if( but.length > 0 )
  {
    let err;
    if( arguments.length === 2 )
    {
      err = _._err
      ({
        args : [ `${ _.entity.strType( srcMap ) } should own no fields :`, _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    else
    {
      let arr = [];
      for( let i = 2; i < arguments.length; i++ )
      {
        if( _.routine.is( arguments[ i ] ) )
        arguments[ i ] = ( arguments[ i ] )();
        arr.push( arguments[ i ] );
      }
      err = _._err
      ({
        args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
        level : 3,
      });
    }
    debugger; /* eslint-disable-line no-debugger */
    throw err;
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has all properties represented in object passed by argument( all ). Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2.{@link wTools.err See err}
 * If routine did not find some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after last object. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { Object } all - object to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let x = { a : 1 };
 * let a = Object.create( x );
 * let b = { a : 2 };
 * _.map.sureHasAll( a, b );
 * // no exception
 *
 * @example
 * let a = { d : 1 };
 * let b = { a : 2 };
 * _.map.sureHasAll( a, b );
 *
 * // log
 * // caught <anonymous>:3:10
 * // Object should have fields : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0, y : 2 };
 * let b = { x : 0, d : 3};
 * _.map.sureHasAll( a, b, 'error msg' );
 *
 * // log
 * // caught <anonymous>:4:9
 * // error msg Object should have fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0 };
 * let b = { x : 1, y : 0};
 * _.map.sureHasAll( a, b, () => 'error, ' + 'map should', ' have fields :' );
 *
 * // log
 * // caught <anonymous>:4:9
 * // error, map should have fields : y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @function sureHasAll
 * @throws {Exception} If no arguments are provided or more than four arguments are provided.
 * @throws {Exception} If map {-srcMap-} not contains some properties from argument( all ).
 * @namespace Tools
 *
 */

function sureHasAll( srcMap, all, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4, 'Expects two, three or four arguments' );

  let but = Object.keys( _.mapBut_( null, all, srcMap ) );

  if( but.length > 0 )
  {
    let err;
    if( arguments.length === 2 )
    {
      err = _._err
      ({
        args : [ `${ _.entity.strType( srcMap ) } should have fields :`, _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    else
    {
      let arr = [];
      for( let i = 2; i < arguments.length; i++ )
      {
        if( _.routine.is( arguments[ i ] ) )
        arguments[ i ] = ( arguments[ i ] )();
        arr.push( arguments[ i ] );
      }
      err = _._err
      ({
        args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    debugger; /* eslint-disable-line no-debugger */
    throw err;
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has all properties represented in object passed by argument( all ). Checks only own properties of the objects.
 * Works only in Config.debug mode. Uses StackTrace level 2. {@link wTools.err See err}
 * If routine did not find some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after last object. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { Object } all - object to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let a = { a : 1 };
 * let b = { a : 2 };
 * wTools.sureMapOwnAll( a, b );
 * // no exception
 *
 * @example
 * let a = { a : 1 };
 * let b = { a : 2, b : 2 }
 * _.map.sureOwnAll( a, b );
 *
 * // log
 * // caught <anonymous>:3:8
 * // Object should have own fields : b
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureOwnAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0 };
 * let b = { x : 1, y : 0};
 * _.map.sureOwnAll( a, b, 'error, should own fields' );
 *
 * // log
 * // caught <anonymous>:4:9
 * // error, should own fields : y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureOwnAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0 };
 * let b = { x : 1, y : 0};
 * _.map.sureOwnAll( a, b, () => 'error, ' + 'map should', ' own fields :' );
 *
 * // log
 * // caught <anonymous>:4:9
 * // error, map should own fields : y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureOwnAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @function sureOwnAll
 * @throws {Exception} If no arguments are provided or more than four arguments are provided.
 * @throws {Exception} If map {-srcMap-} not contains some properties from argument( all ).
 * @namespace Tools
 *
 */

function sureOwnAll( srcMap, all, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4, 'Expects two, three or four arguments' );

  let but = Object.keys( _.mapOnlyOwnBut_( null, all, srcMap ) );

  if( but.length > 0 )
  {
    let err;
    if( arguments.length === 2 )
    {
      err = _._err
      ({
        args : [ `${ _.entity.strType( srcMap ) } should own fields :`, _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    else
    {
      let arr = [];
      for( let i = 2; i < arguments.length; i++ )
      {
        if( _.routine.is( arguments[ i ] ) )
        arguments[ i ] = ( arguments[ i ] )();
        arr.push( arguments[ i ] );
      }
      err = _._err
      ({
        args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    debugger; /* eslint-disable-line no-debugger */
    throw err;
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has no properties represented in object(s) passed after first argument. Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2. {@link wTools.err See err}
 * If routine found some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after last object. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param {...Object} screenMaps - object(s) to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2 };
 * _.map.sureHasNone( a, b );
 * // no exception
 *
 * @example
 * let x = { a : 1 };
 * let a = Object.create( x );
 * let b = { a : 2, b : 2 }
 * _.map.sureHasNone( a, b );
 *
 * // log
 * // caught <anonymous>:4:8
 * // Object should have no fields : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasNone (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:4
 *
 * @example
 * let a = { x : 0, y : 1 };
 * let b = { x : 1, y : 0 };
 * _.map.sureHasNone( a, b, 'error, map should have no fields' );
 *
 * // log
 * // caught <anonymous>:3:9
 * // error, map should have no fields : x, y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasNone (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0, y : 1 };
 * let b = { x : 1, y : 0 };
 * _.map.sureHasNone( a, b, () => 'error, ' + 'map should have', 'no fields :' );
 *
 * // log
 * // caught <anonymous>:3:9
 * // error, map should have no fields : x, y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasNone (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:3
 *
 * @function sureHasNone
 * @throws {Exception} If no arguments are provided or more than four arguments are provided.
 * @throws {Exception} If map {-srcMap-} contains some properties from other map(s).
 * @namespace Tools
 *
 */

function sureHasNone( srcMap, screenMaps, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4, 'Expects two, three or four arguments' );

  let but = Object.keys( _.mapOnly_( null, srcMap, screenMaps ) );

  if( but.length > 0 )
  {
    let err;
    if( arguments.length === 2 )
    {
      err = _._err
      ({
        args : [ `${ _.entity.strType( srcMap ) } should have no fields :`, _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    else
    {
      let arr = [];
      for( let i = 2; i < arguments.length; i++ )
      {
        if( _.routine.is( arguments[ i ] ) )
        arguments[ i ] = ( arguments[ i ] )();
        arr.push( arguments[ i ] );
      }
      err = _._err
      ({
        args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    debugger; /* eslint-disable-line no-debugger */
    throw err;
    return false;
  }

  return true;
}

//

function sureOwnNone( srcMap, screenMaps, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4, 'Expects two, three or four arguments' );

  let but = Object.keys( _.mapOnlyOwn_( null, srcMap, screenMaps ) );

  if( but.length > 0 )
  {
    let err;
    if( arguments.length === 2 )
    {
      err = _._err
      ({
        args : [ `${ _.entity.strType( srcMap ) } should own no fields :`, _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    else
    {
      let arr = [];
      for( let i = 2; i < arguments.length; i++ )
      {
        if( _.routine.is( arguments[ i ] ) )
        arguments[ i ] = ( arguments[ i ] )();
        arr.push( arguments[ i ] );
      }
      err = _._err
      ({
        args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    debugger; /* eslint-disable-line no-debugger */
    throw err;
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} not contains undefined properties. Works only in debug mode. Uses StackTrace level 2. {@link wTools.err See err}
 * If routine found undefined property it generates and throws exception, otherwise returns without exception.
 * Also generates error using messages passed after first argument. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let map = { a : '1', b : 'name' };
 * _.map.sureHasNoUndefine( map );
 * // no exception
 *
 * @example
 * let map = { a : '1', b : undefined };
 * _.map.sureHasNoUndefine( map );
 *
 * // log
 * // caught <anonymous>:2:8
 * // Object  should have no undefines, but has : b
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @example
 * let map = { a : undefined, b : '1' };
 * _.map.sureHasNoUndefine( map, '"map" has undefines :');
 *
 * // log
 * // caught <anonymous>:2:8
 * // "map" has undefines : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @example
 * let map = { a : undefined, b : '1' };
 * _.map.sureHasNoUndefine( map, '"map"', () => 'should have ' + 'no undefines, but has :' );
 *
 * // log
 * // caught <anonymous>:2:8
 * // "map" should have no undefines, but has : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @function sureHasNoUndefine
 * @throws {Exception} If no arguments passed or than three arguments passed.
 * @throws {Exception} If map {-srcMap-} contains undefined property.
 * @namespace Tools
 *
 */

function sureHasNoUndefine( srcMap, msg )
{

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3, 'Expects one, two or three arguments' )

  let but = [];

  for( let s in srcMap )
  if( srcMap[ s ] === undefined )
  but.push( s );

  if( but.length > 0 )
  {
    let err;
    if( arguments.length === 1 )
    {
      err = _._err
      ({
        args : [ `${ _.entity.strType( srcMap ) } should have no undefines, but has :`, _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    else
    {
      let arr = [];
      for( let i = 1; i < arguments.length; i++ )
      {
        if( _.routine.is( arguments[ i ] ) )
        arguments[ i ] = ( arguments[ i ] )();
        arr.push( arguments[ i ] );
      }
      err = _._err
      ({
        args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
    }
    debugger; /* eslint-disable-line no-debugger */
    throw err;
    return false;
  }

  return true;
}

// --
// map assert
// --

function assertHasExactly( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.map.sureHasExactly.apply( this, arguments );
}

//

function assertOwnExactly( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.map.sureOwnExactly.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} has only properties represented in object(s) passed after first argument. Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2. {@link wTools.err See err}
 * If routine found some unique properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after second argument. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { Object } screenMaps - object to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let a = { a : 1, b : 3 };
 * let b = { a : 2, b : 3 };
 * _.map.assertHasOnly( a, b );
 * //no exception
 *
 * @example
 * let a = { a : 1, c : 3 };
 * let b = { a : 2, b : 3 };
 * _.map.assertHasOnly( a, b );
 *
 * // log
 * // caught <anonymous>:3:8
 * // Object should have no fields : c
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:3
 *
 * @example
 * let x = { d : 1 };
 * let a = Object.create( x );
 * let b = { a : 1 };
 * _.map.assertHasOnly( a, b, 'map should have no fields :' )
 *
 * // log
 * // caught <anonymous>:4:8
 * // map should have no fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:4
 *
 * @example
 * let x = { d : 1 };
 * let a = Object.create( x );
 * let b = { a : 1 };
 * _.map.assertHasOnly( a, b, 'map', () => ' should' + ' have no fields :' )
 *
 * // log
 * // caught <anonymous>:4:8
 * // map should have no fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:4
 *
 * @function assertHasOnly
 * @throws {Exception} If no arguments provided or more than four arguments passed.
 * @throws {Exception} If map {-srcMap-} contains unique property.
 * @namespace Tools
 *
 */

function assertHasOnly( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.map.sureHasOnly.apply( this, arguments );

  /* */

  // _.assert( 2 <= arguments.length && arguments.length <= 4, 'Expects two, three or four arguments' );
  //
  // let but = mapButKeys( srcMap, screenMaps );
  //
  // if( but.length > 0 )
  // {
  //   let err;
  //   let msgKeys = _.strQuote( but ).join( ', ' );
  //   if( arguments.length === 2 )
  //   err = errFromArgs([ `${ _.entity.strType( srcMap ) } should have no fields : ${ msgKeys }` ]);
  //   else
  //   err = errFromArgs([ msgMake( arguments ), msgKeys ]);
  //   throw err;
  // }
  //
  // return true;
  //
  // /* */
  //
  // function mapButKeys( srcMap, butMap )
  // {
  //   let result = [];
  //   _.assert( !_.primitive.is( srcMap ), 'Expects map {-srcMap-}' );
  //
  //   /* aaa : allow and cover vector */ /* Dmytro : this inlining is not needed, that was mistake */
  //   if( _.vector.is( butMap ) )
  //   {
  //     /* aaa : for Dmytro : bad */ /* Dmytro : this inlining is not needed, that was mistake */
  //     for( let s in srcMap )
  //     {
  //       let m;
  //       for( m = 0 ; m < butMap.length ; m++ )
  //       {
  //         /* aaa : for Dmytro : was bad implementation. cover */ /* Dmytro : this inlining is not needed, that was mistake */
  //         if( _.primitive.is( butMap[ m ] ) )
  //         {
  //           if( s === butMap[ m ] )
  //           break;
  //         }
  //         else
  //         {
  //           if( s in butMap[ m ] )
  //           break;
  //         }
  //       }
  //
  //       if( m === butMap.length )
  //       result.push( s );
  //     }
  //   }
  //   else if( !_.primitive.is( butMap ) )
  //   {
  //     for( let s in srcMap )
  //     {
  //       if( !( s in butMap ) )
  //       result.push( s );
  //     }
  //   }
  //   else
  //   {
  //     _.assert( 0, 'Expects object-like or long-like {-butMap-}' );
  //   }
  //
  //   return result;
  // }
  //
  // /* */
  //
  // function errFromArgs( args )
  // {
  //   return _._err
  //   ({
  //     args,
  //     level : 2,
  //   });
  // }
  //
  // /* */
  //
  // function msgMake( args )
  // {
  //   let arr = [];
  //   for( let i = 2; i < args.length; i++ )
  //   {
  //     if( _.routineIs( args[ i ] ) )
  //     args[ i ] = args[ i ]();
  //     arr.push( args[ i ] );
  //   }
  //   return arr.join( ' ' );
  // }
}

//

/**
 * Checks if map passed by argument {-srcMap-} has only properties represented in object(s) passed after first argument. Checks only own properties of the objects.
 * Works only in debug mode. Uses StackTrace level 2.{@link wTools.err See err}
 * If routine found some unique properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after second argument. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { Object } screenMaps - object to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let x = { d : 1 };
 * let a = Object.create( x );
 * a.a = 5;
 * let b = { a : 2 };
 * _.map.assertOwnOnly( a, b );
 * // no exception
 *
 * @example
 * let a = { d : 1 };
 * let b = { a : 2 };
 * _.map.assertOwnOnly( a, b );
 *
 * // log
 * // caught <anonymous>:3:10
 * // Object should have no own fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0, y : 2 };
 * let b = { c : 0, d : 3};
 * let c = { a : 1 };
 * _.map.assertOwnOnly( a, b, 'error, map should have no own fields :' );
 *
 * // log
 * // caught <anonymous>:4:8
 * // error, map should have no own fields : x, y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:4
 *
 * @example
 * let a = { x : 0, y : 2 };
 * let b = { c : 0, d : 3};
 * let c = { a : 1 };
 * _.map.assertOwnOnly( a, b, () => 'error, ' + 'map', ' should have no own fields :' );
 *
 * // log
 * // caught <anonymous>:4:8
 * // error, map should have no own fields : x, y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:4
 *
 * @function assertOwnOnly
 * @throws {Exception} If no arguments provided or more than four arguments passed.
 * @throws {Exception} If map {-srcMap-} contains unique property.
 * @namespace Tools
 *
 */

function assertOwnOnly( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.map.sureOwnOnly.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} has no properties represented in object(s) passed after first argument. Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2. {@link wTools.err See err}
 * If routine found some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after second argument. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { Object } screenMaps - object to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let a = { a : 1 };
 * let b = { b : 2 };
 * _.map.assertHasNone( a, b );
 * // no exception
 *
 * @example
 * let x = { a : 1 };
 * let a = Object.create( x );
 * let b = { a : 2, b : 2 }
 * _.map.assertHasNone( a, b );
 *
 * // log
 * // caught <anonymous>:4:8
 * // Object should have no fields : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasAll (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:4
 *
 * @example
 * let a = { x : 0, y : 1 };
 * let b = { x : 1, y : 0 };
 * _.map.assertHasNone( a, b, 'map should have no fields :' );
 *
 * // log
 * // caught <anonymous>:3:9
 * // map should have no fields : x, y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasNone (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0, y : 1 };
 * let b = { x : 1, y : 0 };
 * _.map.assertHasNone( a, b, () => 'map ' + 'should ', 'have no fields :' );
 *
 * // log
 * // caught <anonymous>:3:9
 * // map should have no fields : x, y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasNone (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:3
 *
 * @function assertHasNone
 * @throws {Exception} If no arguments provided or more than four arguments passed.
 * @throws {Exception} If map {-srcMap-} contains some properties from other map(s).
 * @namespace Tools
 *
 */

function assertHasNone( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.map.sureHasNone.apply( this, arguments );
}

//

function assertOwnNone( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.map.sureOwnNone.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} has all properties represented in object passed by argument( all ). Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2.{@link wTools.err See err}
 * If routine did not find some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after second argument. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { Object } all - object to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let x = { a : 1 };
 * let a = Object.create( x );
 * let b = { a : 2 };
 * _.map.assertHasAll( a, b );
 * // no exception
 *
 * @example
 * let a = { d : 1 };
 * let b = { a : 2 };
 * _.map.assertHasAll( a, b );
 *
 * // log
 * // caught <anonymous>:3:10
 * // Object should have fields : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0, y : 2 };
 * let b = { x : 0, d : 3};
 * _.map.assertHasAll( a, b, 'map should have fields :' );
 *
 * // log
 * // caught <anonymous>:4:9
 * // map should have fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0, y : 2 };
 * let b = { x : 0, d : 3};
 * _.map.assertHasAll( a, b, () => 'map' + ' should', ' have fields :' );
 *
 * // log
 * // caught <anonymous>:4:9
 * // map should have fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @function assertHasAll
 * @throws {Exception} If no arguments provided or more than four arguments passed.
 * @throws {Exception} If map {-srcMap-} not contains some properties from argument( all ).
 * @namespace Tools
 *
 */

function assertHasAll( srcMap, all, msg )
{
  if( Config.debug === false )
  return true;
  return _.map.sureHasAll.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} has all properties represented in object passed by argument( all ). Checks only own properties of the objects.
 * Works only in Config.debug mode. Uses StackTrace level 2. {@link wTools.err See err}
 * If routine did not find some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after second argument. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { Object } all - object to compare with.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in third argument.
 *
 * @example
 * let a = { a : 1 };
 * let b = { a : 2 };
 * _.map.assertOwnAll( a, b );
 * // no exception
 *
 * @example
 * let a = { a : 1 };
 * let b = { a : 2, b : 2 }
 * _.map.assertOwnAll( a, b );
 *
 * // log
 * // caught <anonymous>:3:8
 * // Object should own fields : b
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0 };
 * let b = { x : 1, y : 0};
 * _.map.assertOwnAll( a, b, 'error msg, map should own fields :' );
 *
 * // log
 * // caught <anonymous>:4:9
 * // error msg, map should own fields : y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertOwnAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @example
 * let a = { x : 0 };
 * let b = { x : 1, y : 0};
 * _.map.assertOwnAll( a, b, 'error msg, ', () => 'map' + ' should own fields :' );
 *
 * // log
 * // caught <anonymous>:4:9
 * // error msg, map should own fields : y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertOwnAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @function assertOwnAll
 * @throws {Exception} If no arguments passed or more than four arguments passed.
 * @throws {Exception} If map {-srcMap-} not contains some properties from argument( all ).
 * @namespace Tools
 *
 */

function assertOwnAll( srcMap, all, msg )
{
  if( Config.debug === false )
  return true;
  return _.map.sureOwnAll.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} not contains undefined properties. Works only in debug mode. Uses StackTrace level 2. {@link wTools.err See err}
 * If routine found undefined property it generates and throws exception, otherwise returns without exception.
 * Also generates error using messages passed after first argument. Message may be a string, an array, or a function.
 *
 * @param { Object } srcMap - source map.
 * @param { * } [ msg ] - error message for generated exception.
 * @param { * } [ msg ] - error message that adds to the message in second argument.
 *
 * @example
 * let map = { a : '1', b : 'name' };
 * _.map.assertHasNoUndefine( map );
 * // no exception
 *
 * @example
 * let map = { a : '1', b : undefined };
 * _.map.assertHasNoUndefine( map );
 *
 * // log
 * // caught <anonymous>:2:8
 * // Object should have no undefines, but has : b
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @example
 * let map = { a : undefined, b : '1' };
 * _.map.assertHasNoUndefine( map, '"map" has undefines :');
 *
 * // log
 * // caught <anonymous>:2:8
 * // "map" has undefines : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @example
 * let map = { a : undefined, b : '1' };
 * _.map.assertHasNoUndefine( map, 'map', () => ' has ' + 'undefines :');
 *
 * // log
 * // caught <anonymous>:2:8
 * // map has undefines : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @function assertHasNoUndefine
 * @throws {Exception} If no arguments provided or more than three arguments passed.
 * @throws {Exception} If map {-srcMap-} contains undefined property.
 * @namespace Tools
 *
 */

function assertHasNoUndefine( srcMap, msg )
{
  if( Config.debug === false )
  return true;

  /* */

  _.assert( 1 <= arguments.length && arguments.length <= 3, 'Expects one, two or three arguments' )
  _.assert( !_.primitive.is( srcMap ) );

  let but = [];

  for( let s in srcMap )
  if( srcMap[ s ] === undefined )
  but.push( s );

  if( but.length > 0 )
  {
    let msgKeys = _.strQuote( but ).join( ', ' );
    if( arguments.length === 1 )
    throw errFromArgs([ `${ _.entity.strType( srcMap ) } should have no undefines, but has : ${ msgKeys }` ]);
    else
    throw errFromArgs([ msgMake( arguments ), msgKeys ])
  }

  return true;

  /* */

  function errFromArgs( args )
  {
    return _._err
    ({
      args,
      level : 2,
    });
  }

  /* */

  function msgMake( args )
  {
    let arr = [];
    for( let i = 1 ; i < args.length ; i++ )
    {
      if( _.routine.is( args[ i ] ) )
      args[ i ] = args[ i ]();
      arr.push( args[ i ] );
    }
    return arr.join( ' ' );
  }
}

// --
// extension
// --

let Extension =
{

  // map selector

  /* xxx : review */
  mapFirstPair,
  mapAllValsSet,
  mapValsWithKeys,
  mapValWithIndex,
  mapKeyWithIndex,
  mapKeyWithValue,
  // mapIndexWithKey,
  // mapIndexWithValue,

  mapOnlyNulls,
  mapButNulls,

  // map checker

  // mapsAreIdentical, /* xxx : remove */
  // mapContain,

  objectSatisfy,

  /* xxx : move routines to another namespace? */

  /* introduce routine::mapHasKey */
  mapOwn : mapOwnKey, /* qqq : good coverage required! */
  mapOwnKey,

  mapHas : mapHasKey, /* qqq : good coverage required! */
  mapHasKey,

  mapOnlyOwnKey,
  mapHasVal,
  mapOnlyOwnVal,

  mapHasAll,
  mapHasAny,
  mapHasNone,

  mapOnlyOwnAll,
  mapOnlyOwnAny,
  mapOnlyOwnNone,

  mapHasExactly,
  mapOnlyOwnExactly,

  mapHasOnly,
  mapOnlyOwnOnly,

  mapHasNoUndefine,

  // map extend

  // mapMake,
  // mapCloneShallow,
  mapCloneAssigning, /* dubious */

  // mapExtend,
  mapsExtend,
  mapExtendConditional,
  mapsExtendConditional,

  mapExtendHiding,
  mapsExtendHiding,
  mapExtendAppending,
  mapsExtendAppending,
  mapExtendPrepending,
  mapsExtendPrepending,
  mapExtendAppendingOnlyArrays,
  mapsExtendAppendingOnlyArrays,
  mapExtendByDefined,
  mapsExtendByDefined,
  mapExtendNulls, /* qqq : cover */ /* qqq : check routine mapExtendNulls. seems does not extend undefined fields */
  mapsExtendNulls, /* qqq : cover */
  mapExtendDstNotOwn, /* qqq : cover */
  mapsExtendDstNotOwn, /* qqq : cover */
  mapExtendNotIdentical, /* qqq : cover */
  mapsExtendNotIdentical, /* qqq : cover */

  // mapSupplement,
  mapSupplementNulls,
  mapSupplementNils,
  mapSupplementAssigning,
  mapSupplementAppending,
  mapsSupplementAppending,

  mapSupplementOwnAssigning,

  mapComplement,
  mapsComplement,
  mapComplementReplacingUndefines,
  mapsComplementReplacingUndefines,
  mapComplementPreservingUndefines,
  mapsComplementPreservingUndefines,

  // map extend recursive

  mapExtendRecursiveConditional,
  mapsExtendRecursiveConditional,
  _mapExtendRecursiveConditional,

  mapExtendRecursive,
  mapsExtendRecursive,
  _mapExtendRecursive,

  mapExtendAppendingAnythingRecursive,
  mapsExtendAppendingAnythingRecursive,
  mapExtendAppendingArraysRecursive,
  mapsExtendAppendingArraysRecursive,
  mapExtendAppendingOnceRecursive,
  mapsExtendAppendingOnceRecursive,

  mapSupplementRecursive,
  mapSupplementByMapsRecursive,
  mapSupplementOwnRecursive,
  mapsSupplementOwnRecursive,
  mapSupplementRemovingRecursive,
  mapSupplementByMapsRemovingRecursive,

  // map selector

  mapOnlyPrimitives,

  // map manipulator

  /* xxx */
  mapSetWithKeys,
  mapSet : mapSetWithKeys,
  mapSetWithKeyStrictly,

  // map transformer

  mapInvert, /* qqq : write _mapInvert accepting o-map | aaa : Done. Yevhen S. */
  _mapInvert,
  mapInvertDroppingDuplicates,
  mapsFlatten,

  // mapToArray,
  mapToStr, /* experimental */
  mapFromHashMap : fromHashMap,

  // map logical operator

  mapButConditionalOld, /* !!! : use instead of mapButConditional */ /* qqq : make it accept null in the first argument */ /* Dmytro : covered, coverage is more complex */
  mapButConditional_,
  // mapBut, /* !!! : use instead of mapBut */ /* Dmytro : covered, coverage is more complex */
  mapBut_, /* qqq : make it accept null in the first argument */
  mapButOld,
  _mapBut_VerifyMapFields,
  _mapBut_FilterFunctor,
  // _mapBut_,
  mapDelete,
  mapEmpty, /* xxx : remove */
  // mapButIgnoringUndefines, /* !!! : use instead of mapButIgnoringUndefines */ /* Dmytro : covered, coverage is more complex */
  mapButIgnoringUndefines_, /* qqq : make it accept null in the first argument */
  /* qqq : for Dmytro : cover */
  /* qqq : for Dmytro : mess with problems! */
  /* xxx : use as default mapBut? */

  mapOnlyOwnButOld, /* !!! : use instead of mapOnlyOwnBut */ /* Dmytro : covered, coverage is more complex */
  mapOnlyOwnBut_, /* qqq : make it accept null in the first argument */

  mapOnlyOld, /* !!! : use instead of mapOnly */ /* Dmytro : covered, coverage is more complex */
  mapOnly_,  /* qqq : make it accept null in the first argument */
  // mapOnlyOwn, /* !!! : use instead of mapOnlyOwn */ /* Dmytro : covered, coverage is more complex */
  mapOnlyOwn_, /* qqq : make it accept null in the first argument */
  /* qqq : cover */
  // mapOnlyComplementing, /* !!! : use instead of mapOnlyComplementing */ /* Dmytro : covered, coverage is more complex */
  mapOnlyComplementing_, /* qqq : make it accept null in the first argument */
  _mapOnly, /* xxx : qqq : comment out */
  _mapOnly_VerifyMapFields,
  _mapOnly_FilterFunctor,
  _screenMapSearchingRoutineFunctor,
  // _mapOnly_SearchKeyInVectorScreenMap,
  // _mapOnly_,

  mapDiff,

  /* qqq xxx : implement mapDiff(), ask how to */

}

// --
//
// --

/* qqq : for junior : duplicate all routines */

let ExtensionMap =
{

  // transformer

  fromHashMap,

  // sure

  sureHasExactly,
  sureOwnExactly,

  sureHasOnly,
  sureOwnOnly,

  sureHasAll,
  sureOwnAll,

  sureHasNone,
  sureOwnNone,

  sureHasNoUndefine,

  // assert

  assertHasExactly,
  assertOwnExactly,

  assertHasOnly,
  assertOwnOnly,

  assertHasNone,
  assertOwnNone,

  assertHasAll,
  assertOwnAll,

  assertHasNoUndefine,

}

//

_.props.supplement( _, Extension );
_.props.supplement( _.map, ExtensionMap );
_.assert( _.aux.is( _.map ) );

})();


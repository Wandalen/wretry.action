( function _l3_Entity_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const _functor_functor = _.container._functor_functor;

_.entity = _.entity || Object.create( null );

_.assert( !!_.container.cloneShallow, 'Expects routine _.container.cloneShallow' );

// --
//
// --

function identicalShallow( src1, src2, o )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( Object.prototype.toString.call( src1 ) !== Object.prototype.toString.call( src2 ) )
  return false;

  if( src1 === src2 )
  return true;

  if( _.hashMap.like( src1 ) )
  {
    /*
      - hashMap
    */
    return _.hashMap.identicalShallow( src1, src2 )
  }
  else if( _.set.like( src1 ) )
  {
    /*
      - set
    */
    return _.set.identicalShallow( src1, src2 );
  }
  else if( _.bufferAnyIs( src1 ) )
  {
    /*
      - BufferNode
      - BufferRaw
      - BufferRawShared
      - BufferTyped
      - BufferView
      - BufferBytes
    */
    return _.buffersIdenticalShallow( src1, src2 );
  }
  else if( _.countable.is( src1 ) )
  {
    /*
      - countable
      - vector
      - long
      - array
    */
    return _.countable.identicalShallow( src1, src2 );
  }
  else if( _.object.like( src1 ) )
  {
    /*
      - objectLike
      - object

      - Map
      - Auxiliary
      - MapPure
      - MapPolluted
      - AuxiliaryPolluted
      - MapPrototyped
      - AuxiliaryPrototyped
    */
    if( _.date.is( src1 ) )
    {
      return _.date.identicalShallow( src1, src2 );
    }
    else if( _.regexp.is( src1 ) )
    {
      return _.regexp.identicalShallow( src1, src2 );
    }
    else if( _.aux.is( src1 ) )
    {
      return _.aux.identicalShallow( src1, src2 );
    }

    /* non-identical objects */
    return false;
  }
  else if( _.primitiveIs( src1 ) )
  {
    /*
      - Symbol
      - Number
      - BigInt
      - Boolean
      - String
    */

    return _.primitive.identicalShallow( src1, src2 );
  }
  else
  {
    return false;
  }
}

//

function equivalentShallow( src1, src2, options )
{
  /*
    - boolLikeTrue and boolLikeTrue - ( true, 1 )
    - boolLikeFalse and boolLikeFalse - ( false, 0 )
    - | number1 - number2 | <= accuracy
    - strings that differ only in whitespaces at the start and/or at the end
    - regexp with same source and different flags
    - countable with the same length and content
  */
  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects 2 or 3 arguments' );
  _.assert( options === undefined || _.objectLike( options ), 'Expects map of options as third argument' );

  let accuracy;

  if( options )
  accuracy = options.accuracy || undefined;

  if( _.primitiveIs( src1 ) && _.primitiveIs( src2 ) ) /* check before type comparison ( 10n & 10 and 1 & true are equivalent ) */
  {
    /*
      - Symbol
      - Number
      - BigInt
      - Boolean
      - String
    */
    return _.primitive.equivalentShallow( src1, src2, accuracy );
  }

  if( src1 === src2 )
  return true;

  if( _.bufferAnyIs( src1 ) && _.bufferAnyIs( src2 ) )
  {
    /*
      - BufferNode
      - BufferRaw
      - BufferRawShared
      - BufferTyped
      - BufferView
      - BufferBytes
    */
    return _.buffersEquivalentShallow( src1, src2 );
  }
  else if( _.hashMap.like( src1 ) && _.hashMap.like( src1 ) )
  {
    /*
      - hashMap
    */
    return _.hashMap.equivalentShallow( src1, src2 )
  }
  else if( _.set.like( src1 ) && _.set.like( src2 ) )
  {
    /*
      - set
    */
    return _.set.equivalentShallow( src1, src2 );
  }
  else if( _.countable.is( src1 ) && _.countable.is( src2 ) )
  {
    /*
      - countable
      - vector
      - long
      - array
    */
    return _.countable.equivalentShallow( src1, src2 );
  }

  if( Object.prototype.toString.call( src1 ) !== Object.prototype.toString.call( src2 ) )
  return false;

  if( _.object.like( src1 ) )
  {
    /*
      - objectLike
      - object

      - Map
      - Auxiliary
      - MapPure
      - MapPolluted
      - AuxiliaryPolluted
      - MapPrototyped
      - AuxiliaryPrototyped
    */
    if( _.date.is( src1 ) )
    {
      return _.date.equivalentShallow( src1, src2 );
    }
    else if( _.regexp.is( src1 ) )
    {
      return _.regexp.equivalentShallow( src1, src2 );
    }
    else if( _.aux.is( src1 ) )
    {
      return _.aux.equivalentShallow( src1, src2 );
    }

    /* non-identical objects */
    return false;
  }
  else
  {
    return false;
  }
}

//

/**
 * The routine equal() checks equality of two entities {-src1-} and {-src2-}.
 * Routine accepts callbacks {-onEvaluate1-} and {-onEvaluate2-}, which apply to
 * entities {-src1-} and {-src2-}. The values returned by callbacks are compared with each other.
 * If callbacks is not passed, then routine compares {-src1-} and {-src2-} directly.
 *
 * @param { * } src1 - First entity to compare.
 * @param { * } src2 - Second entity to compare.
 * @param { Function } onEvaluate - It's a callback. If the routine has two parameters,
 * it is used as an equalizer, and if it has only one, then routine is used as the evaluator.
 * @param { Function } onEvaluate2 - The second part of evaluator. Accepts the {-src2-} to search.
 *
 * @example
 * _.entity.equal( 1, 1 );
 * // returns true
 *
 * @example
 * _.entity.equal( 1, 'str' );
 * // returns false
 *
 * @example
 * _.entity.equal( [ 1, 2, 3 ], [ 1, 2, 3 ] );
 * // returns false
 *
 * @example
 * _.entity.equal( [ 1, 2, 3 ], [ 1, 2, 3 ], ( e ) => e[ 0 ] );
 * // returns true
 *
 * @example
 * _.entity.equal( [ 1, 2, 3 ], [ 1, 2, 3 ], ( e1, e2 ) => e1[ 0 ] > e2[ 2 ] );
 * // returns false
 *
 * @example
 * _.entity.equal( [ 1, 2, 3 ], [ 1, 2, 3 ], ( e1 ) => e1[ 2 ], ( e2 ) => e2[ 2 ] );
 * // returns true
 *
 * @returns { Boolean } - Returns boolean value of equality of two entities.
 * @function equal
 * @throws { Error } If arguments.length is less then two or more then four.
 * @throws { Error } If {-onEvaluate1-} is not a routine.
 * @throws { Error } If {-onEvaluate1-} is undefines and onEvaluate2 provided.
 * @throws { Error } If {-onEvaluate1-} is evaluator and accepts less or more then one parameter.
 * @throws { Error } If {-onEvaluate1-} is equalizer and onEvaluate2 provided.
 * @throws { Error } If {-onEvaluate2-} is not a routine.
 * @throws { Error } If {-onEvaluate2-} accepts less or more then one parameter.
 * @namespace Tools.entity
 */

function equal( /* src1, src2, onEvaluate1, onEvaluate2 */ )
{
  let src1 = arguments[ 0 ];
  let src2 = arguments[ 1 ];
  let onEvaluate1 = arguments[ 2 ];
  let onEvaluate2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );

  if( !onEvaluate1 )
  {
    _.assert( !onEvaluate2 );
    return Object.is( src1, src2 );
  }
  else if( onEvaluate1.length === 2 ) /* equalizer */
  {
    _.assert( !onEvaluate2 );
    return onEvaluate1( src1, src2 );
  }
  else /* evaluator */
  {
    if( !onEvaluate2 )
    onEvaluate2 = onEvaluate1;
    _.assert( onEvaluate1.length === 1 );
    _.assert( onEvaluate2.length === 1 );
    return onEvaluate1( src1 ) === onEvaluate2( src2 );
  }

}

// --
// maker
// --

// function cloneShallow( container ) /* qqq for junior : cover please */
// {
//   _.assert( arguments.length === 1 );
//   return cloneShallow.functor.call( this, container )();
// }
//
// cloneShallow.functor = _functor_functor( 'cloneShallow' );
//
// //
//
// function make( container, ... args ) /* qqq for junior : cover please */
// {
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   return make.functor.call( this, container )( ... args );
// }
//
// make.functor = _functor_functor( 'make' );
//
// //
//
// function makeEmpty( container ) /* qqq for junior : cover please */
// {
//   _.assert( arguments.length === 1 );
//   return makeEmpty.functor.call( this, container )();
// }
//
// makeEmpty.functor = _functor_functor( 'makeEmpty' );
//
// //
//
// function makeUndefined( container, ... args ) /* qqq for junior : cover please */
// {
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   return makeUndefined.functor.call( this, container )( ... args );
// }
//
// makeUndefined.functor = _functor_functor( 'makeUndefined' );
//
// // --
// // editor
// // --
//
// /**
//  * The routine empty() clears provided container {-dstContainer-}.
//  *
//  * @param { Long|Set|HashMap|Aux } dstContainer - Container to be cleared. {-dstContainer-} should be resizable.
//  *
//  * @example
//  * let dst = [];
//  * let got = _.container.empty( dst );
//  * console.log( got );
//  * // log []
//  * console.log( got === dst );
//  * log true
//  *
//  * @example
//  * let dst = [ 1, 'str', { a : 2 } ];
//  * let got = _.container.empty( dst );
//  * console.log( got );
//  * // log []
//  * console.log( got === dst );
//  * // log true
//  *
//  * @example
//  * let dst = _.unroll.make( [ 1, 'str', { a : 2 } ] );
//  * let got = _.container.empty( dst );
//  * console.log( got );
//  * // log []
//  * console.log( got === dst );
//  * // log true
//  *
//  * @example
//  * let dst = new Set( [ 1, 'str', { a : 2 } ] );
//  * let got = _.container.empty( dst );
//  * console.log( got );
//  * // log Set {}
//  * console.log( got === dst );
//  * // log true
//  *
//  * @example
//  * let dst = new HashMap( [ [ 1, 'str' ], [ 'a', null ] ] );
//  * let got = _.container.empty( dst );
//  * console.log( got );
//  * // log Map {}
//  * console.log( got === dst );
//  * // log true
//  *
//  * @returns { Long|Set|HashMap|Aux } - Returns a empty {-dstContainer-}.
//  * @function empty
//  * @throws { Error } If arguments.length is less than one.
//  * @throws { Error } If {-dstContainer-} is not a Long, not a Set, not a HashMap, not a Aux.
//  * @throws { Error } If {-dstContainer-} is not a resizable Long, or if it is a WeakSet or WeakMap.
//  * @namespace Tools
//  */
//
// function empty( container ) /* qqq for junior : cover please */
// {
//   _.assert( arguments.length === 1 );
//   return empty.functor.call( this, container )();
// }
//
// empty.functor = _functor_functor( 'empty' );

// --
// inspector
// --

/**
 * Returns "length" of entity( src ). Representation of "length" depends on type of( src ):
 *  - For object returns number of it own enumerable properties;
 *  - For array or array-like object returns value of length property;
 *  - For undefined returns 0;
 *  - In other cases returns 1.
 *
 * @param { * } src - Source entity.
 *
 * @example
 * _.entity.lengthOf( [ 1, 2, 3 ] );
 * // returns 3
 *
 * @example
 * _.entity.lengthOf( 'string' );
 * // returns 1
 *
 * @example
 * _.entity.lengthOf( { a : 1, b : 2 } );
 * // returns 2
 *
 * @example
 * let src = undefined;
 * _.entity.lengthOf( src );
 * // returns 0
 *
 * @returns {number} Returns "length" of entity.
 * @function lengthOf
 * @namespace Tools/entity
*/

function lengthOf( src ) /* qqq for junior : cover please */
{
  _.assert( arguments.length === 1 );
  return lengthOf.functor.call( this, src )();
}

lengthOf.functor = _functor_functor( 'lengthOf' );

// --
// entity extension
// --

let EntityExtension =
{

  identicalShallow,
  equivalentShallow,

  equal, /* xxx : deprecate? */

  // exporter

  _exportStringDiagnosticShallow : _.container._exportStringDiagnosticShallow,
  exportStringDiagnosticShallow : _.container.exportStringDiagnosticShallow,
  _exportStringCodeShallow : _.container._exportStringCodeShallow,
  exportStringCodeShallow : _.container.exportStringCodeShallow,
  exportString : _.container.exportString,

  // editor

  empty : _.container.empty, /* qqq : cover */

  // inspector

  lengthOf, /* qqq : cover */

  // elementor

  elementWithCardinal : _.container.elementWithCardinal, /* qqq : cover */
  elementWithKey : _.container.elementWithKey, /* qqq : cover */
  elementWithImplicit : _.container.elementWithImplicit, /* qqq : cover */
  elementWithCardinalSet : _.container.elementWithCardinalSet, /* qqq : cover */
  elementSet : _.container.elementSet, /* qqq : cover */

  elementDel : _.container.elementDel, /* qqq : cover */
  elementWithKeyDel : _.container.elementWithKeyDel, /* qqq : cover */
  elementWithCardinalDel : _.container.elementWithCardinalDel,  /* qqq : cover */
  empty : _.container.empty, /* qqq : for junior : cover */

  // iterator

  each : _.container.each, /* qqq : cover */
  eachLeft : _.container.eachLeft, /* qqq : cover */
  eachRight : _.container.eachRight, /* qqq : cover */

  while : _.container.while, /* qqq : cover */
  whileLeft : _.container.whileLeft, /* qqq : cover */
  whileRight : _.container.whileRight, /* qqq : cover */

  aptLeft : _.container.aptLeft, /* qqq : cover */
  first : _.container.first, /* qqq : cover */
  aptRight : _.container.aptRight, /* qqq : cover */
  last : _.container.last, /* qqq : cover */

}

//

Object.assign( _.entity, EntityExtension );

// --
// tools extension
// --

let ToolsExtension =
{

}

//

Object.assign( _, ToolsExtension );

})();

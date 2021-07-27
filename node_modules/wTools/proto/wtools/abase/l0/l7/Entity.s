( function _l7_Entity_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _global_.wTools;

// --
// entity getter
// --

/**
 * Returns "size" of entity( src ). Representation of "size" depends on type of( src ):
 *  - For string returns value of it own length property;
 *  - For array-like entity returns value of it own byteLength property for( BufferRaw, TypedArray, etc )
 *    or length property for other;
 *  - In other cases returns null.
 *
 * @param {*} src - Source entity.
 * @returns {number} Returns "size" of entity.
 *
 * @example
 * _.entity.sizeOfUncountable( 'string' );
 * // returns 6
 *
 * @example
 * _.entity.sizeOfUncountable( new BufferRaw( 8 ) );
 * // returns 8
 *
 * @example
 * _.entity.sizeOfUncountable( 123 );
 * // returns null
 *
 * @function sizeOfUncountable
 * @namespace Tools
*/

/* qqq : cover argument sizeOfContainer */
function sizeOfUncountable( src, sizeOfContainer )
{
  if( arguments.length === 1 )
  sizeOfContainer = 8;

  _.assert( _.number.defined( sizeOfContainer ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( _.strIs( src ) )
  {
    if( src.length )
    return _.bufferBytesFrom( src ).byteLength + sizeOfContainer;
    return src.length + sizeOfContainer;
  }

  if( _.primitive.is( src ) )
  return sizeOfContainer || 8;

  if( _.routine.is( src ) )
  return sizeOfContainer;

  if( _.number.is( src.byteLength ) )
  return src.byteLength + sizeOfContainer;

  if( _.regexpIs( src ) )
  return _.entity.sizeOfUncountable( src.source, 0 ) + src.flags.length + sizeOfContainer;

  // if( !_.iterableIs( src ) ) /* yyy */ /* Dmytro : simulate behavior of routine iterableIs, routine countableIs has different behavior */
  // return sizeOfContainer;
  // if( !_.aux.is( src ) )
  // if( !_.class.methodIteratorOf( src ) )
  // return sizeOfContainer;
  // if( _.countable.is( src ) )
  // return _.countable.lengthOf( src ) + sizeOfContainer;

  return NaN;
}

//

/**
 * Returns "size" of entity( src ). Representation of "size" depends on type of( src ):
 *  - For string returns value of it own length property;
 *  - For array-like entity returns value of it own byteLength property for( BufferRaw, TypedArray, etc )
 *    or length property for other;
 *  - In other cases returns null.
 *
 * @param {*} src - Source entity.
 * @returns {number} Returns "size" of entity.
 *
 * @example
 * _.entity.sizeOf( 'string' );
 * // returns 6
 *
 * @example
 * _.entity.sizeOf( [ 1, 2, 3 ] );
 * // returns 3
 *
 * @example
 * _.entity.sizeOf( new BufferRaw( 8 ) );
 * // returns 8
 *
 * @example
 * _.entity.sizeOf( 123 );
 * // returns null
 *
 * @function entitySize
 * @namespace Tools
*/

/* qqq : review */

/* qqq : cover argument sizeOfContainer */
function sizeOf( src, sizeOfContainer )
{
  let result = 0;

  if( arguments.length === 1 )
  sizeOfContainer = 8;

  _.assert( _.number.defined( sizeOfContainer ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  // if( _.primitive.is( src ) || _.bufferAnyIs( src ) || !( _.mapIs( src ) || _.class.methodIteratorOf( src ) ) )
  if( _.primitive.is( src ) || _.bufferAnyIs( src ) || _.routineIs( src ) || _.regexpIs( src ) )
  return _.entity.sizeOfUncountable( src, sizeOfContainer );

  /*
  full implementation of routine _.entity.sizeOf() in the module::LookerExtra
  */

  return NaN;
}

// --
// entity extension
// --

let EntityExtension =
{

  sizeOfUncountable,
  sizeOf,

}

Object.assign( _.entity, EntityExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  // sizeOfUncountable,
  // entitySize,
  // sizeOf : entitySize,

}

//

Object.assign( _, ToolsExtension );

})();

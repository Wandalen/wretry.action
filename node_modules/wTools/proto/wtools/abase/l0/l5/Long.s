( function _l5_Long_s_()
{

'use strict';

const _ArrayIndexOf = Array.prototype.indexOf;
const _ArrayIncludes = Array.prototype.includes;
if( !_ArrayIncludes )
_ArrayIncludes = function( e ){ _ArrayIndexOf.call( this, e ) }

const _global = _global_;
const _ = _global_.wTools;

/*
               |  can grow   |  can shrink  |   range
grow                +                -         positive
only                -                +         positive
relength            +                +         positive
but                 -                +         negative
*/

/* array / long / buffer */
/* - / inplace */

// --
// long
// --

function _longMake_functor( onMake )
{

  _.assert( _.routine.is( onMake ) );

  return function _longMake( src, ins )
  {
    let result;

    /* */

    let length = ins;

    if( _.longLike( length ) )
    length = length.length;

    if( length === undefined || length === null )
    {
      if( src === null )
      {
        length = 0;
      }
      else if( _.longLike( src ) )
      {
        length = src.length;
      }
      else if( _.number.is( src ) )
      {
        length = src;
        src = null;
      }
      else if( _.routine.is( src ) )
      {
        length = 0;
      }
      else _.assert( 0 );
    }

    if( !length )
    length = 0;

    /* */

    if( ins === undefined || ins === null )
    {
      if( _.longLike( src ) )
      {
        if( ins === null )
        {
          ins = src;
        }
        else
        {
          ins = src;
          // src = null;
        }
      }
      else
      {
        ins = null;
      }
    }
    else if( !_.longLike( ins ) )
    {
      if( _.longIs( src ) )
      ins = src;
      else
      ins = null;
    }

    /**/

    let minLength;
    if( ins )
    minLength = Math.min( ins.length, length );
    else
    minLength = 0;

    /**/

    if( _.argumentsArray.is( src ) )
    src = null;

    let self = this;
    if( src === null )
    src = function( src )
    {
      return self.tools.long.default.make( src );
    };

    _.assert( arguments.length === 1 || arguments.length === 2 );
    _.assert( _.number.isFinite( length ) );
    _.assert( _.routine.is( src ) || _.longLike( src ), () => 'Expects long, but got ' + _.entity.strType( src ) );

    result = onMake.call( this, src, ins, length, minLength );

    _.assert( _.longLike( result ) );

    return result;
  }

}

//

/**
 * The routine longMake() returns a new Long with the same type as source Long {-src-}. New Long makes from inserted Long {-ins-}
 * or if {-ins-} is number, the Long makes from {-src-} with length equal to {-ins-}. If {-ins-} is not provided, routine  makes
 * container with default Long type. New Long contains {-src-} elements.
 *
 * @param { Long|Function|Null } src - Instance of Long or constructor, defines type of returned Long. If null is provided, routine returns
 * container with default Long type.
 * @param { Number|Long|Null } ins - Defines length of new Long. If Long is provided, routine makes new Long from {-ins-} with {-src-} type.
 * If null is provided, then routine makes container with default Long type.
 *
 * Note. Default Long type defines by descriptor {-longDescriptor-}. If descriptor not provided directly, then it is Array descriptor.
 *
 * @example
 * _.long.make();
 * // returns []
 *
 * @example
 * _.long.make( null );
 * // returns []
 *
 * @example
 * _.long.make( null, null );
 * // returns []
 *
 * @example
 * _.long.make( 3 );
 * // returns [ undefined, undefined, undefined ]
 *
 * @example
 * _.long.make( 3, null );
 * // returns [ undefined, undefined, undefined ]
 *
 * @example
 * _.long.make( [ 1, 2, 3, 4 ] );
 * // returns [ 1, 2, 3, 4 ];
 *
 * @example
 * _.long.make( [ 1, 2, 3, 4 ], null );
 * // returns [ 1, 2, 3, 4 ];
 *
 * @example
 * _.long.make( [ 1, 2 ], 4 );
 * // returns [ 1, 2, undefined, undefined ];
 *
 * @example
 * let got = _.long.make( _.unroll.make( [] ), [ 1, 2, 3 ] );
 * console.log( got );
 * // log [ 1, 2, 3 ];
 * console.log( _.unrollIs( got ) );
 * // log true
 *
 * @example
 * let got = _.long.make( new F32x( [ 1, 2, 3 ] ), 1 );
 * console.log( got );
 * // log Float32Array[ 1 ];
 *
 * @example
 * let got = _.long.make( Array, null );
 * console.log( got );
 * // log [];
 *
 * @example
 * let got = _.long.make( Array, 3 );
 * console.log( got );
 * // log [ undefined, undefined, undefined ];
 *
 * @returns { Long } - Returns a Long with type of source Long {-src-} which makes from {-ins-}. If {-ins-} is not
 * provided, then routine returns container with default Long type.
 * @function longMake
 * @throws { Error } If arguments.length is more then two.
 * @throws { Error } If {-src-} is not a Long, not a constructor, not null.
 * @throws { Error } If {-ins-} is not a number, not a Long, not null, not undefined.
 * @throws { Error } If {-ins-} or ins.length has a not finite value.
 * @namespace Tools
 */

/* aaa : extend coverage and documentation of longMake */
/* Dmytro : extended coverage and documentation of routine longMake */
/* aaa : longMake does not create unrolls, but should */
/* Dmytro : longMake creates unrolls */

// let longMake = _longMake_functor( function( /* src, ins, length, minLength */ )
// {
//   let src = arguments[ 0 ];
//   let ins = arguments[ 1 ];
//   let length = arguments[ 2 ];
//   let minLength = arguments[ 3 ];
//
//   let result;
//   if( _.routine.is( src ) )
//   {
//     if( ins && ins.length === length )
//     {
//       if( src === Array )
//       {
//         if( _.longLike( ins ) )
//         {
//           if( ins.length === 1 )
//           result = [ ins[ 0 ] ];
//           else if( !_.argumentsArray.like( ins ) )
//           result = new( _.constructorJoin( src, [ ... ins ] ) );
//           else
//           result = new( _.constructorJoin( src, ins ) );
//         }
//         else
//         {
//           result = new src( ins );
//         }
//       }
//       else
//       {
//         result = new src( ins );
//       }
//     }
//     else
//     {
//       result = new src( length );
//       // let minLength = Math.min( length, ins.length );
//       for( let i = 0 ; i < minLength ; i++ )
//       result[ i ] = ins[ i ];
//     }
//   }
//   else if( _.arrayIs( src ) )
//   {
//     _.assert( length >= 0 );
//     result = _.unrollIs( src ) ? _.unroll.make( length ) : new src.constructor( length );
//     // let minLength = Math.min( length, ins.length );
//     for( let i = 0 ; i < minLength ; i++ )
//     result[ i ] = ins[ i ];
//   }
//   else
//   {
//     if( ins && length === ins.length )
//     {
//       result = new src.constructor( ins );
//     }
//     else
//     {
//       result = new src.constructor( length );
//       // let minLength = Math.min( length, ins.length );
//       for( let i = 0 ; i < minLength ; i++ )
//       result[ i ] = ins[ i ];
//     }
//   }
//
//   return result;
// });

// function longMake( src, ins )
// {
//   let result;
//   let length = ins;
//
//   if( _.longLike( length ) )
//   length = length.length;
//
//   if( length === undefined )
//   {
//     if( src === null )
//     {
//       length = 0;
//     }
//     else if( _.longLike( src ) )
//     {
//       length = src.length;
//     }
//     else if( _.number.is( src ) )
//     {
//       length = src;
//       src = null;
//     }
//     else _.assert( 0 );
//   }
//
//   // if( !_.longLike( ins ) )
//   // {
//   //   if( _.longLike( src ) )
//   //   ins = src;
//   //   else
//   //   ins = [];
//   // }
//
//   if( !_.longLike( ins ) )
//   {
//     if( _.longLike( src ) )
//     {
//       ins = src;
//       src = null;
//     }
//     else
//     {
//       ins = [];
//     }
//   }
//
//   if( !length )
//   length = 0;
//
//   if( _.argumentsArray.is( src ) )
//   src = null;
//
//   if( src === null )
//   src = this.tools.long.default.make;
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( _.number.isFinite( length ) );
//   _.assert( _.routine.is( src ) || _.longLike( src ), () => 'Expects long, but got ' + _.entity.strType( src ) );
//
//   if( _.routine.is( src ) )
//   {
//     if( ins.length === length )
//     {
//       if( src === Array )
//       {
//         if( _.longLike( ins ) )
//         {
//           if( ins.length === 1 )
//           result = [ ins[ 0 ] ];
//           else if( !_.argumentsArray.like( ins ) )
//           result = new( _.constructorJoin( src, [ ... ins ] ) );
//           else
//           result = new( _.constructorJoin( src, ins ) );
//         }
//         else
//         {
//           result = new src( ins );
//         }
//       }
//       else
//       {
//         result = new src( ins );
//       }
//     }
//     else
//     {
//       result = new src( length );
//       let minLen = Math.min( length, ins.length );
//       for( let i = 0 ; i < minLen ; i++ )
//       result[ i ] = ins[ i ];
//     }
//   }
//   else if( _.arrayIs( src ) )
//   {
//     if( length === ins.length )
//     {
//       result = _.unrollIs( src ) ? _.unroll.make( ins ) : new( _.constructorJoin( src.constructor, ins ) );
//     }
//     else
//     {
//       _.assert( length >= 0 );
//       result = _.unrollIs( src ) ? _.unroll.make( length ) : new src.constructor( length );
//       let minLen = Math.min( length, ins.length );
//       for( let i = 0 ; i < minLen ; i++ )
//       result[ i ] = ins[ i ];
//     }
//   }
//   else
//   {
//     if( length === ins.length )
//     {
//       result = new src.constructor( ins );
//     }
//     else
//     {
//       result = new src.constructor( length );
//       let minLen = Math.min( length, ins.length );
//       for( let i = 0 ; i < minLen ; i++ )
//       result[ i ] = ins[ i ];
//     }
//   }
//
//   _.assert( result instanceof this.tools.long.default.InstanceConstructor );
//   // _.assert( _.longLike( result ) );
//
//   return result;
// }

//

/* aaa : implement test */
/* Dmytro : implemented */

function longMakeEmpty( src )
{
  if( arguments.length === 0 )
  return this.tools.long.default.make( 0 );

  _.assert( arguments.length === 1 );

  if( _.unrollIs( src ) )
  {
    return _.unroll.make( 0 );
  }
  else if( src === null || _.argumentsArray.is( src ) )
  {
    return this.tools.long.default.make( 0 );
  }
  // else if( _.longLike( src ) )
  else if( _.vector.like( src ) )
  {
    return new src.constructor();
  }
  // else if( _.routine.is( src ) ) /* aaa : it was covered badly! */ /* Dmytro : coverage is extended */
  else if( _.routine.is( src.constructor ) )
  {
    let result = new src();
    // let result = new src.onstructor(); /* Dmytro : src is a class, it calls without constructor property */
    // _.assert( _.long.lengthOf( result ) === 0, 'Constructor should return empty long' );
    _.assert( result.length === 0, 'Constructor should return empty long' );
    return result;
  }
  _.assert( 0, `Unknown long subtype ${_.entity.strType( src )}` );
}

// function longMakeEmpty( src )
// {
//   let result;
//   let length = 0;
//
//   if( src === null )
//   src = [];
//
//   if( _.argumentsArray.is( src ) )
//   src = [];
//
//   _.assert( arguments.length === 1 );
//
//   result = new src.constructor();
//
//   _.assert( _.longIs( result ) );
//   _.assert( result.length === 0 );
//
//   return result;
// }

// //
//
// let _longMakeOfLength = _longMake_functor( function( /* src, ins, length, minLength */ )
// {
//   let src = arguments[ 0 ];
//   let ins = arguments[ 1 ];
//   let length = arguments[ 2 ];
//   let minLength = arguments[ 3 ];
//
//   let result;
//   if( _.routine.is( src ) )
//   {
//     result = new src( length );
//   }
//   else if( _.arrayIs( src ) )
//   {
//     if( length === src.length )
//     {
//       result = new( _.constructorJoin( src.constructor, src ) );
//     }
//     else if( length < src.length )
//     {
//       result = src.slice( 0, length );
//     }
//     else
//     {
//       result = new src.constructor( length );
//       for( let i = 0 ; i < minLength ; i++ )
//       result[ i ] = src[ i ];
//     }
//   }
//   else
//   {
//     if( length === src.length )
//     {
//       result = new src.constructor( ins );
//     }
//     else
//     {
//       result = new src.constructor( length );
//       for( let i = 0 ; i < minLength ; i++ )
//       result[ i ] = src[ i ];
//     }
//   }
//
//   return result;
// });

// function _longMakeOfLength( src, len )
// {
//   let result;
//
//   // if( src === null )
//   // src = [];
//
//   if( _.longLike( len ) )
//   len = len.length;
//
//   if( len === undefined )
//   {
//     if( src === null )
//     {
//       len = 0;
//     }
//     else if( _.longLike( src ) )
//     {
//       len = src.length;
//     }
//     else if( _.number.is( src ) )
//     {
//       len = src;
//       src = null;
//     }
//     else _.assert( 0 );
//   }
//
//   if( !len )
//   len = 0;
//
//   if( _.argumentsArray.is( src ) )
//   src = this.tools.long.default.name === 'ArgumentsArray' ? this.tools.long.default.make : this.tools.long.default.make( src );
//
//   if( src === null )
//   src = this.tools.long.default.make;
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( _.number.isFinite( len ) );
//   _.assert( _.routine.is( src ) || _.longLike( src ), () => 'Expects long, but got ' + _.entity.strType( src ) );
//
//   if( _.routine.is( src ) )
//   {
//     result = new src( len );
//   }
//   else if( _.arrayIs( src ) )
//   {
//     if( len === src.length )
//     {
//       result = new( _.constructorJoin( src.constructor, src ) );
//     }
//     else if( len < src.length )
//     {
//       result = src.slice( 0, len );
//     }
//     else
//     {
//       result = new src.constructor( len );
//       let minLen = Math.min( len, src.length );
//       for( let i = 0 ; i < minLen ; i++ )
//       result[ i ] = src[ i ];
//     }
//   }
//   else
//   {
//     if( len === src.length )
//     {
//       result = new src.constructor( len );
//     }
//     else
//     {
//       result = new src.constructor( len );
//       let minLen = Math.min( len, src.length );
//       for( let i = 0 ; i < minLen ; i++ )
//       result[ i ] = src[ i ];
//     }
//   }
//
//   _.assert( _.longLike( result ), 'Instance should be a long' );
//
//   return result;
// }

//

/**
 * The routine longMakeUndefined() returns a new Long with the same type as source Long {-src-}. New Long has length equal to {-ins-}
 * argument. If {-ins-} is not provided, then new container has default Long type and length of source Long {-src-}.
 *
 * @param { Long|Function|Null } src - Long or constructor, defines type of returned Long. If null is provided, then routine returns
 * container with default Long type.
 * @param { Number|Long } ins - Defines length of new Long. If {-ins-} is Long, then routine makes new Long with length equal to ins.length.
 *
 * Note. Default Long type defines by descriptor {-longDescriptor-}. If descriptor not provided directly, then it is Array descriptor.
 *
 * @example
 * _.long.makeUndefined();
 * // returns []
 *
 * @example
 * _.long.makeUndefined( null );
 * // returns []
 *
 * @example
 * _.long.makeUndefined( null, null );
 * // returns []
 *
 * @example
 * _.long.makeUndefined( 3 );
 * // returns [ undefined, undefined, undefined ]
 *
 * @example
 * _.long.makeUndefined( 3, undefined );
 * // returns [ undefined, undefined, undefined ]
 *
 * @example
 * _.long.makeUndefined( [ 1, 2, 3, 4 ] );
 * // returns [ undefined, undefined, undefined, undefined ];
 *
 * @example
 * _.long.makeUndefined( [ 1, 2, 3, 4 ], null );
 * // returns [ undefined, undefined, undefined, undefined ];
 *
 * @example
 * _.long.makeUndefined( [ 1, 2, 3, 4 ], 2 );
 * // returns [ undefined, undefined ];
 *
 * @example
 * let got = _.long.makeUndefined( _.unroll.make( [] ), [ 1, 2, 3 ] );
 * console.log( got );
 * // log [ undefined, undefined, undefined ];
 * console.log( _.unrollIs( got ) );
 * // log true
 *
 * @example
 * let got = _.long.makeUndefined( new F32x( [ 1, 2, 3, 4 ] ), 2 );
 * console.log( got );
 * // log Float32Array[ undefined, undefined ];
 *
 * @example
 * let got = _.long.makeUndefined( Array, null );
 * console.log( got );
 * // log [];
 *
 * @example
 * let got = _.long.makeUndefined( Array, 3 );
 * console.log( got );
 * // log [ undefined, undefined, undefined ];
 *
 * @returns { Long } - Returns a Long with type of source Long {-src-} with a certain length defined by {-ins-}.
 * If {-ins-} is not defined, then routine returns container with default Long type. Length of the new container defines by {-src-}.
 * @function longMakeUndefined
 * @throws { Error } If arguments.length is more then two.
 * @throws { Error } If the {-src-} is not a Long, not a constructor, not null.
 * @throws { Error } If the {-ins-} is not a number, not a Long, not null, not undefined.
 * @throws { Error } If the {-ins-} or ins.length has a not finite value.
 * @namespace Tools
 */

/*
aaa : extend coverage and documentation of longMakeUndefined
Dmytro : extended coverage and documentation
aaa : longMakeUndefined does not create unrolls, but should
Dmytro : longMakeUndefined creates unrolls.
*/

// let longMakeUndefined = _longMake_functor( function( /* src, ins, length, minLength */ )
// {
//   let src = arguments[ 0 ];
//   let ins = arguments[ 1 ];
//   let length = arguments[ 2 ];
//   let minLength = arguments[ 3 ];
//
//   let result;
//   if( _.routine.is( src ) )
//   result = new src( length );
//   else if( _.unrollIs( src ) )
//   result = _.unroll.make( length );
//   else if( src === null )
//   result = this.tools.long.default.make( length );
//   else
//   result = new src.constructor( length );
//
//   return result;
// })

// function longMakeUndefined( ins, len )
// {
//   let result, length;
//
//   /* aaa3 : ask. use default long container */
//   /* Dmytro : explained, used this.tools.longDescriptor */
//   // if( ins === null )
//   // result = [];
//
//   if( len === undefined )
//   {
//     if( ins === null )
//     {
//       length = 0;
//     }
//     else if( _.number.is( ins ) )
//     {
//       length = ins;
//       ins = null;
//     }
//     else
//     {
//       length = ins.length;
//     }
//   }
//   else
//   {
//     if( _.longLike( len ) )
//     length = len.length;
//     else if( _.number.is( len ) )
//     length = len;
//     else _.assert( 0 );
//   }
//
//   if( _.argumentsArray.is( ins ) )
//   ins = null;
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( _.number.isFinite( length ) );
//   _.assert( _.routine.is( ins ) || _.longLike( ins ) || ins === null, () => 'Expects long, but got ' + _.entity.strType( ins ) );
//
//   if( _.routine.is( ins ) )
//   result = new ins( length );
//   else if( _.unrollIs( ins ) )
//   result = _.unroll.make( length );
//   else if( ins === null ) /* aaa3 : ask */
//   result = this.tools.long.default.make( length );
//   else
//   result = new ins.constructor( length );
//
//   return result;
// }

//

/* aaa3 : teach to accept only length */
/* aaa3 : use default long type if type is not clear */
/* aaa3 : allow buffers which are long */
/* aaa3 : relevant to all routines longMake* of such kind */
/* Dmytro : all requirements implemented and covered */

// let longMakeZeroed = _longMake_functor( function( /* src, ins, length, minLength */ )
// {
//   let src = arguments[ 0 ];
//   let ins = arguments[ 1 ];
//   let length = arguments[ 2 ];
//   let minLength = arguments[ 3 ];
//
//   let result;
//   if( _.routine.is( src ) )
//   result = new src( length );
//   else if( _.unrollIs( src ) )
//   result = _.unroll.make( length );
//   else if( src === null )
//   result = this.tools.long.default.make( length );
//   else
//   result = new src.constructor( length );
//
//   if( !_.bufferTypedIs( result ) )
//   {
//     for( let i = 0 ; i < length ; i++ )
//     result[ i ] = 0;
//   }
//
//   return result;
// })

// function longMakeZeroed( ins, src )
// {
//   let result, length;
//
//   if( _.routine.is( ins ) )
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   if( src === undefined )
//   {
//     length = ins.length;
//   }
//   else
//   {
//     if( _.longLike( src ) )
//     length = src.length;
//     else if( _.number.is( src ) )
//     length = src;
//     else _.assert( 0, 'Expects long or number as the second argument, got', _.entity.strType( src ) );
//   }
//
//   if( _.argumentsArray.is( ins ) )
//   ins = [];
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( _.number.isFinite( length ) );
//   _.assert( _.routine.is( ins ) || _.longLike( ins ), () => 'Expects long, but got ' + _.entity.strType( ins ) );
//
//   if( _.routine.is( ins ) )
//   result = new ins( length );
//   else if( _.unrollIs( ins ) )
//   result = _.unroll.make( length );
//   else
//   result = new ins.constructor( length );
//
//   if( !_.bufferTypedIs( result ) )
//   for( let i = 0 ; i < length ; i++ )
//   result[ i ] = 0;
//
//   return result;
// }

function longMakeFilling( type, value, length )
{
  let result;

  // _.assert( arguments.length === 2 || arguments.length === 3 ); /* Dmytro : double check */

  if( arguments.length === 2 )
  {
    value = arguments[ 0 ];
    length = arguments[ 1 ];
    if( _.longIs( length ) )
    {
      if( _.argumentsArray.is( length ) )
      type = null;
      else
      type = length.constructor;
    }
    else
    {
      type = null;
    }
  }
  else if( arguments.length !== 3 )
  {
    _.assert( 0, 'Expects two or three arguments' );
  }

  /* Dmytro : missed */
  if( _.longIs( length ) )
  length = length.length;

  _.assert( value !== undefined );
  _.assert( _.number.is( length ) );
  _.assert( type === null || _.routine.is( type ) || _.longIs( type ) );

  result = this.long.make( type, length );
  for( let i = 0 ; i < length ; i++ )
  result[ i ] = value;

  return result;
}

//

/* aaa : add good coverage for longFrom. */
/* Dmytro : covered, two test routines implemented */

function longFrom( src )
{
  _.assert( arguments.length === 1 );
  if( src instanceof this.tools.long.default.InstanceConstructor )
  if( !_.unrollIs( src ) && _.longIs( src ) )
  return src;
  return this.longMake.call( this, src );
}

//

/**
 * The routine longFromCoercing() returns Long from provided argument {-src-}. The feature of routine is possibility of
 * converting an object-like {-src-} into Long. Also, routine longFromCoercing() converts string with number literals
 * to a Long.
 * If routine convert {-src-}, then result returns in container with default Long type.
 *
 * @param { Long|ObjectLike|String } src - An instance to convert into Long.
 * If {-src-} is a Long and it type is equal to current default Long type, then routine convert not {-src-}.
 *
 * Note. Default Long type defines by descriptor {-longDescriptor-}. If descriptor not provided directly, then it is Array descriptor.
 *
 * @example
 * let src = [ 3, 7, 13, 'abc', false, undefined, null, {} ];
 * let got = _.longFromCoercing( src );
 * // returns [ 3, 7, 13, 'abc', false, undefined, null, {} ]
 * console.log( got === src );
 * // log true
 *
 * @example
 * let src = _.argumentsArray.make( [ 3, 7, 13, 'abc', false, undefined, null, {} ] );
 * let got = _.longFromCoercing( src );
 * // returns [ 3, 7, 13, 'abc', false, undefined, null, {} ]
 * console.log( got === src );
 * // log false
 *
 * @example
 * let src = { a : 3, b : 7, c : 13 };
 * let got = _.longFromCoercing( src );
 * // returns [ [ 'a', 3 ], [ 'b', 7 ], [ 'c', 13 ] ]
 *
 * @example
 * let src = "3, 7, 13, 3.5abc, 5def, 7.5ghi, 13jkl";
 * let got = _.longFromCoercing( src );
 * // returns [ 3, 7, 13, 3.5, 5, 7.5, 13 ]
 *
 * @returns { Long } - Returns a Long. If {-src-} is Long with default Long type, then routine returns original {-src-}.
 * Otherwise, it makes new container with default Long type.
 * @function longFromCoercing
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If {-src-} is not a Long, not an object-like, not a string.
 * @namespace Tools
 */

function longFromCoercing( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( this.long.default.InstanceConstructor )
  if( src instanceof this.long.default.InstanceConstructor && _.longIs( src ) )
  return src;

  /* Dmytro : this condition make recursive call with array from argumentsArray. But first condition return any long object
     ( ArgumentsArray.type is  Object ), and next make other long types without recursive call */
  // if( _.argumentsArray.is( src ) )
  // return this.longFromCoercing( Array.prototype.slice.call( src ) );

  if( _.longIs( src ) )
  return this.long.default.from( src );

  if( _.object.isBasic( src ) )
  return this.longFromCoercing( _.props.pairs( src ) );

  /* aaa : cover */
  /* Dmytro : covered */
  if( _.strIs( src ) )
  return this.longFromCoercing( this.arrayFromStr( src ) );

  _.assert( 0, `Unknown data type : ${ _.entity.strType( src ) }` );
}

//

/**
 * The routine longFill() fills elements the given Long {-src-} by static value. The range of replaced elements
 * defines by a parameter {-range-}. If it possible, routine longFill() saves original container {-src-}.
 *
 * @param { Long } src - The source Long.
 * @param { * } value - Any value to fill the elements in the {-src-}.
 * If {-value-} is not provided, the routine fills elements of source Long by 0.
 * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
 * If {-range-} is number, then it defines the end index, and the start index is 0.
 * If range[ 0 ] < 0, then start index sets to 0, end index increments by absolute value of range[ 0 ].
 * If range[ 1 ] <= range[ 0 ], then routine returns a copy of original Long.
 * If {-range-} is not provided, routine fills all elements of the {-src-}.
 *
 * @example
 * _.longFill( [ 1, 2, 3, 4, 5 ] );
 * // returns [ 0, 0, 0, 0, 0 ]
 *
 * @example
 * _.longFill( [ 1, 2, 3, 4, 5 ], 'a' );
 * // returns [ 'a', 'a', 'a', 'a', 'a' ]
 *
 * @example
 * _.longFill( [ 1, 2, 3, 4, 5 ], 'a', 2 );
 * // returns [ 'a', 'a', 3, 4, 5 ]
 *
 * @example
 * _.longFill( [ 1, 2, 3, 4, 5 ], 'a', [ 1, 3 ] );
 * // returns [ 1, 'a', 'a', 4, 5 ]
 *
 * @example
 * _.longFill( [ 1, 2, 3, 4, 5 ], 'a', [ -1, 3 ] );
 * // returns [ 'a', 'a', 'a', 'a', 5 ]
 *
 * @example
 * _.longFill( [ 1, 2, 3, 4, 5 ], 'a', [ 4, 3 ] );
 * // returns [ 1, 2, 3, 4, 5 ]
 *
 * @returns { Long } - If it is possible, returns the source Long filled with a static value.
 * Otherwise, returns copy of the source Long filled with a static value.
 * @function longFill
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-src-} is not a Long.
 * @throws { Error } If {-range-} is not a Range or not a Number.
 * @namespace Tools
 */

function longFill( src, value, range )
{

  if( range === undefined )
  range = [ 0, src.length ];
  if( _.number.is( range ) )
  range = [ 0, range ];

  _.assert( 1 <= arguments.length && arguments.length <= 3 );
  _.assert( _.longIs( src ) );
  _.assert( _.intervalIs( range ) );

  if( value === undefined )
  value = 0;

  // src = _.longGrowInplace( src, range );
  src = _.longGrow_( src, src, [ range[ 0 ], range[ 1 ] - 1 ] );

  let offset = Math.max( -range[ 0 ], 0 );

  if( range[ 0 ] < 0 )
  {
    range[ 1 ] -= range[ 0 ];
    range[ 0 ] = 0;
  }

  if( _.routine.is( src.fill ) )
  {
    src.fill( value, range[ 0 ], range[ 1 ] + offset );
  }
  else
  {
    for( let t = range[ 0 ] ; t < range[ 1 ] + offset ; t++ )
    src[ t ] = value;
  }

  return src;
}

//

function longFill_( src, ins, cinterval )
{

  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval - 1 ];

  _.assert( 1 <= arguments.length && arguments.length <= 3 );
  _.assert( _.longIs( src ) );
  _.assert( _.intervalIs( cinterval ) );

  if( ins === undefined )
  ins = 0;

  src = _.longGrow_( src, src, cinterval );

  let offset = Math.max( -cinterval[ 0 ], 0 );

  if( cinterval[ 0 ] < 0 )
  {
    cinterval[ 1 ] -= cinterval[ 0 ];
    cinterval[ 0 ] = 0;
  }

  if( _.routine.is( src.fill ) )
  {
    src.fill( ins, cinterval[ 0 ], cinterval[ 1 ] + 1 + offset );
  }
  else
  {
    for( let t = cinterval[ 0 ] ; t < cinterval[ 1 ] + 1 + offset ; t++ )
    src[ t ] = ins;
  }

  return src;
}

//

/**
 * The longDuplicate() routine returns an array with duplicate values of a certain number of times.
 *
 * @param { objectLike } [ o = {  } ] o - The set of arguments.
 * @param { longIs } o.src - The given initial array.
 * @param { longIs } o.result - To collect all data.
 * @param { Number } [ o.nScalarsPerElement = 1 ] o.nScalarsPerElement - The certain number of times
 * to append the next value from (srcArray or o.src) to the (o.result).
 * If (o.nScalarsPerElement) is greater that length of a (srcArray or o.src) it appends the 'undefined'.
 * @param { Number } [ o.nDupsPerElement = 2 ] o.nDupsPerElement = 2 - The number of duplicates per element.
 *
 * @example
 * _.longDuplicate( [ 'a', 'b', 'c' ] );
 * // returns [ 'a', 'a', 'b', 'b', 'c', 'c' ]
 *
 * @example
 * let options = {
 *   src : [ 'abc', 'def' ],
 *   result : [  ],
 *   nScalarsPerElement : 2,
 *   nDupsPerElement : 3
 * };
 * _.longDuplicate( options, {} );
 * // returns [ 'abc', 'def', 'abc', 'def', 'abc', 'def' ]
 *
 * @example
 * let options = {
 *   src : [ 'abc', 'def' ],
 *   result : [  ],
 *   nScalarsPerElement : 3,
 *   nDupsPerElement : 3
 * };
 * _.longDuplicate( options, { a : 7, b : 13 } );
 * // returns [ 'abc', 'def', undefined, 'abc', 'def', undefined, 'abc', 'def', undefined ]
 *
 * @returns { Array } Returns an array with duplicate values of a certain number of times.
 * @function longDuplicate
 * @throws { Error } Will throw an Error if ( o ) is not an objectLike.
 * @namespace Tools
 */

function longDuplicate( o ) /* xxx : review interface */
{
  // _.assert( arguments.length === 1 || arguments.length === 2 );

  _.assert( _.mapIs( o ) );

  // if( arguments.length === 2 )
  // {
  //   o = { src : arguments[ 0 ], nDupsPerElement : arguments[ 1 ] };
  // }
  // else if( arguments.length === 1 )
  // {
  //   if( !_.mapIs( o ) )
  //   o = { src : o };
  // }
  // else _.assert( 0 );

  if( o.nScalarsPerElement === 0 )
  if( o.src.length === 0 )
  o.nScalarsPerElement = 1;
  else
  o.nScalarsPerElement = o.src.length;

  _.routine.options( longDuplicate, o );
  _.assert( _.number.is( o.nDupsPerElement ) );
  _.assert( _.longIs( o.src ), 'Expects Long {-o.src-}' );
  _.assert( _.intIs( o.src.length / o.nScalarsPerElement ) );

  if( o.nDupsPerElement === 1 )
  {
    if( o.dst )
    {
      _.assert( _.longIs( o.dst ) || _.bufferTypedIs( o.dst ), 'Expects o.dst as longIs or TypedArray if nDupsPerElement equals 1' );

      if( _.bufferTypedIs( o.dst ) )
      o.dst = _.longJoin( o.dst, o.src );
      else if( _.longIs( o.dst ) )
      o.dst.push.apply( o.dst, o.src );
    }
    else
    {
      o.dst = o.src;
    }
    return o.dst;
  }

  let length = o.src.length * o.nDupsPerElement;
  let numberOfElements = o.src.length / o.nScalarsPerElement;

  if( o.dst )
  _.assert( o.dst.length >= length );

  o.dst = o.dst || _.long.makeUndefined( o.src, length );

  let rlength = o.dst.length;

  for( let c = 0, cl = numberOfElements ; c < cl ; c++ )
  {

    for( let d = 0, dl = o.nDupsPerElement ; d < dl ; d++ )
    {

      for( let e = 0, el = o.nScalarsPerElement ; e < el ; e++ )
      {
        let indexDst = c*o.nScalarsPerElement*o.nDupsPerElement + d*o.nScalarsPerElement + e;
        let indexSrc = c*o.nScalarsPerElement+e;
        o.dst[ indexDst ] = o.src[ indexSrc ];
      }

    }

  }

  _.assert( o.dst.length === rlength );

  return o.dst;
}

longDuplicate.defaults = /* qqq : cover. take into account extreme cases */
{
  src : null,
  dst : null,
  nScalarsPerElement : 1,
  nDupsPerElement : 2,
}

//

/*
aaa : find and let me know what is _.buffer* analog of _longClone |
aaa Dmytro : module has not _.buffer* analog of routine _longClone. The closest functionality has routine bufferMake( ins, src )
zzz
*/

// function _longClone( src ) /* qqq for Dmyto : _longClone should not accept untyped buffers. _bufferClone should accept untyped buffer */
function _longClone( src ) /* qqq for Dmyto : _longClone should not accept untyped buffers. _bufferClone should accept untyped buffer */
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longLike( src ) || _.bufferAnyIs( src ) );
  // _.assert( !_.bufferNodeIs( src ), 'not tested' );

  if( _.unrollIs( src ) )
  return _.unroll.make( src );
  else if( _.arrayIs( src ) )
  return src.slice();
  else if( _.argumentsArray.is( src ) )
  return Array.prototype.slice.call( src );
  else if( _.bufferRawIs( src ) )
  return new U8x( new U8x( src ) ).buffer;
  else if( _.bufferTypedIs( src ) || _.bufferNodeIs( src ) )
  return new src.constructor( src );
  else if( _.bufferViewIs( src ) )
  return new src.constructor( src.buffer, src.byteOffset, src.byteLength );

  _.assert( 0, 'unknown kind of buffer', _.entity.strType( src ) );
}

//

/**
 * Returns a copy of original array( array ) that contains elements from index( f ) to index( l ),
 * but not including ( l ).
 *
 * If ( l ) is omitted or ( l ) > ( array.length ), _longShallow extracts through the end of the sequence ( array.length ).
 * If ( f ) > ( l ), end index( l ) becomes equal to begin index( f ).
 * If ( f ) < 0, zero is assigned to begin index( f ).

 * @param { Array/BufferNode } array - Source array or buffer.
 * @param { Number } [ f = 0 ] f - begin zero-based index at which to begin extraction.
 * @param { Number } [ l = array.length ] l - end zero-based index at which to end extraction.
 *
 * @example
 * _._longShallow( [ 1, 2, 3, 4, 5, 6, 7 ], 2, 6 );
 * // returns [ 3, 4, 5, 6 ]
 *
 * @example
 * // begin index is less then zero
 * _._longShallow( [ 1, 2, 3, 4, 5, 6, 7 ], -1, 2 );
 * // returns [ 1, 2 ]
 *
 * @example
 * // end index is bigger then length of array
 * _._longShallow( [ 1, 2, 3, 4, 5, 6, 7 ], 5, 100 );
 * // returns [ 6, 7 ]
 *
 * @returns { Array } Returns a shallow copy of elements from the original array.
 * @function _longShallow
 * @throws { Error } Will throw an Error if ( array ) is not an Array or BufferNode.
 * @throws { Error } Will throw an Error if ( f ) is not a Number.
 * @throws { Error } Will throw an Error if ( l ) is not a Number.
 * @throws { Error } Will throw an Error if no arguments provided.
 * @namespace Tools
 */

/* aaa : optimize */
/* Dmytro : optimized */

// function longSlice( array, f, l )
function _longShallow( src, f, l )
{
  _.assert( 1 <= arguments.length && arguments.length <= 3 );
  _.assert( _.longIs( src ), 'Expects long {-src-}' );
  _.assert( f === undefined || _.number.is( f ) );
  _.assert( l === undefined || _.number.is( l ) );

  /* xxx qqq for Dmytro : check and cover */

  f = f === undefined ? 0 : f;
  l = l === undefined ? src.length : l;

  if( f < 0 )
  f = src.length + f;
  if( l < 0 )
  l = src.length + l;

  if( f < 0 )
  f = 0;
  if( f > l )
  l = f;

  if( _.bufferTypedIs( src ) )
  return _.longOnly_( null, src, [ f, l - 1 ] );
  return Array.prototype.slice.call( src, f, l );

  // if( _.bufferTypedIs( src ) )
  // return src.subsrc( f, l );
  // else if( _.srcLikeResizable( src ) )
  // return src.slice( f, l );
  // else if( _.argumentssrcIs( src ) )
  // return src.prototype.slice.call( src, f, l );
  // else
  // _.assert( 0 );
}

//

/**
 * The longRepresent() routine returns a shallow copy of a portion of an array
 * or a new TypedArray that contains
 * the elements from (begin) index to the (end) index,
 * but not including (end).
 *
 * @param { Array } src - Source array.
 * @param { Number } begin - Index at which to begin extraction.
 * @param { Number } end - Index at which to end extraction.
 *
 * @example
 * _.longRepresent( [ 1, 2, 3, 4, 5 ], 2, 4 );
 * // returns [ 3, 4 ]
 *
 * @example
 * _.longRepresent( [ 1, 2, 3, 4, 5 ], -4, -2 );
 * // returns [ 2, 3 ]
 *
 * @example
 * _.longRepresent( [ 1, 2, 3, 4, 5 ] );
 * // returns [ 1, 2, 3, 4, 5 ]
 *
 * @returns { Array } - Returns a shallow copy of a portion of an array into a new Array.
 * @function longRepresent
 * @throws { Error } If the passed arguments is more than three.
 * @throws { Error } If the first argument is not an array.
 * @namespace Tools
 */

/* qqq2 : review. ask */
/* qqq2 : implement bufferRepresent_( any buffer )
should return undefined if cant create representation
let representation = _.bufferRepresent_( src );
representation[ 4 ] = x; // src changed too
*/

/* qqq2 : implement longRepresent_( src, cinterval ~ [ first, last ] ) */
/* xxx qqq for Dmytro : implement longRepresent_ */

function longRepresent( src, begin, end )
{

  _.assert( arguments.length <= 3 );
  _.assert( _.longLike( src ), 'Unknown type of (-src-) argument' );
  _.assert( _.routine.is( src.slice ) || _.routine.is( src.subarray ) );

  if( _.routine.is( src.subarray ) )
  return src.subarray( begin, end );

  return src.slice( begin, end );
}

// function longSlice( array, f, l )
// {
//   let result;
//
//   if( _.argumentsArray.is( array ) )
//   if( f === undefined && l === undefined )
//   {
//     if( array.length === 2 )
//     return [ array[ 0 ], array[ 1 ] ];
//     else if( array.length === 1 )
//     return [ array[ 0 ] ];
//     else if( array.length === 0 )
//     return [];
//   }
//
//   _.assert( _.longIs( array ) );
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   if( _.arrayLikeResizable( array ) )
//   {
//     _.assert( f === undefined || _.number.is( f ) );
//     _.assert( l === undefined || _.number.is( l ) );
//     result = array.slice( f, l );
//     return result;
//   }
//
//   f = f !== undefined ? f : 0;
//   l = l !== undefined ? l : array.length;
//
//   _.assert( _.number.is( f ) );
//   _.assert( _.number.is( l ) );
//
//   if( f < 0 )
//   f = array.length + f;
//   if( l < 0 )
//   l = array.length + l;
//
//   if( f < 0 )
//   f = 0;
//   if( l > array.length )
//   l = array.length;
//   if( l < f )
//   l = f;
//
//   result = _.long.makeUndefined( array, l-f );
//   // if( _.bufferTypedIs( array ) )
//   // result = new array.constructor( l-f );
//   // else
//   // result = new Array( l-f );
//
//   for( let r = f ; r < l ; r++ )
//   result[ r-f ] = array[ r ];
//
//   return result;
// }

//

/**
 * The routine longJoin() makes new container with type defined by first argument. Routine clones content of provided arguments
 * into created container.
 *
 * @param { Long|Buffer } arguments[ 0 ] - Long or Buffer, defines type of returned container. If provided only {-arguments[ 0 ]-}, then
 * routine makes shallow copy of it.
 * @param { * } ... - Arguments to make copy into new container. Can have any types exclude undefined.
 *
 * @example
 * let src = [];
 * let got = _.longJoin( src );
 * console.log( got );
 * // log []
 * console.log( src === got );
 * // log false
 *
 * @example
 * var src = new U8x( [ 1, 2, 3, 4 ] );
 * var got = _.longJoin( src );
 * console.log( got );
 * // log Uint8Array [ 1, 2, 3, 4 ];
 * console.log( src === got );
 * // log false
 *
 * @example
 * let src = _.unroll.make( [] );
 * let got = _.longJoin( src, 1, 'str', new F32x( [ 3 ] ) );
 * console.log( got );
 * // log [ 1, 'str', 3 ]
 * console.log( _.unrollIs( got ) );
 * // log true
 * console.log( src === got );
 * // log false
 *
 * @example
 * let src = new BufferRaw( 3 );
 * let got = _.longJoin( src, 1, 2, _.argumentsArray.make( [ 3, 4 ] ) );
 * console.log( got );
 * // log ArrayBuffer { [Uint8Contents]: <00 00 00 01 02 03 04>, byteLength: 7 }
 * console.log( src === got );
 * // log false
 *
 * @returns { Long|Buffer } - Returns a Long or a Buffer with type of first argument. Returned container filled by content of provided arguments.
 * @function longJoin
 * @throws { Error } If arguments.length is less than one.
 * @throws { Error } If the {-arguments[ 0 ]-} is not a Long or not a Buffer.
 * @throws { Error } If {-arguments-} has undefined value.
 * @namespace Tools
 */

function longJoin()
{
  _.assert( arguments.length >= 1, 'Expects at least one argument' );

  if( arguments.length === 1 )
  {
    return _._longClone( arguments[ 0 ] );
  }

  /* eval length */

  let length = 0;

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    let argument = arguments[ a ];

    _.assert( argument !== undefined, 'argument is not defined' );
    // if( argument === undefined )
    // throw _.err( 'argument is not defined' );

    if( _.longLike( argument ) || _.bufferNodeIs( argument ) )
    length += argument.length;
    else if( _.bufferRawIs( argument ) || _.bufferViewIs( argument ) )
    length += argument.byteLength;
    else
    length += 1;
  }

  /* make result */

  let result, bufferDst;
  let offset = 0;

  if( _.bufferRawIs( arguments[ 0 ] ) )
  {
    result = new BufferRaw( length );
    bufferDst = new U8x( result );
  }
  else if( _.bufferViewIs( arguments[ 0 ] ) )
  {
    result = new BufferView( new BufferRaw( length ) );
    bufferDst = new U8x( result.buffer );
  }
  else
  {
    if( _.arrayIs( arguments[ 0 ] ) || _.bufferTypedIs( arguments[ 0 ] ) || _.argumentsArray.is( arguments[ 0 ] ) )
    result = _.long.makeUndefined( arguments[ 0 ], length );
    else if( _.bufferNodeIs( arguments[ 0 ] ) )
    result = BufferNode.alloc( length );
    else
    _.assert( 0, 'Unexpected data type' );

    bufferDst = result;
  }

  /* copy */

  for( let a = 0; a < arguments.length ; a++ )
  {
    let srcTyped;
    let argument = arguments[ a ];
    if( _.bufferRawIs( argument ) )
    srcTyped = new U8x( argument );
    else if( _.bufferViewIs( argument ) )
    srcTyped = new U8x( argument.buffer );
    else if( _.bufferTypedIs( argument ) )
    srcTyped = argument;
    else if( _.longLike( argument ) || _.bufferNodeIs( argument ) )
    srcTyped = argument;
    else
    srcTyped = [ argument ];

    for( let i = 0; i < srcTyped.length; i++ )
    bufferDst[ i + offset ] = srcTyped[ i ];

    offset += srcTyped.length;
  }

  // for( let a = 0, c = 0 ; a < arguments.length ; a++ )
  // {
  //   let argument = arguments[ a ];
  //   if( _.bufferRawIs( argument ) )
  //   {
  //     bufferDst.set( new U8x( argument ), offset );
  //     offset += argument.byteLength;
  //   }
  //   else if( _.bufferTypedIs( arguments[ 0 ] ) )
  //   {
  //     result.set( argument, offset );
  //     offset += argument.length;
  //   }
  //   else if( _.longLike( argument ) )
  //   for( let i = 0 ; i < argument.length ; i++ )
  //   {
  //     result[ c ] = argument[ i ];
  //     c += 1;
  //   }
  //   else
  //   {
  //     result[ c ] = argument;
  //     c += 1;
  //   }
  // }

  return result;
}

//

function longEmpty( dstLong )
{
  if( _.arrayIs( dstLong ) )
  {
    // dstLong.slice( 0, dstLong.length ); // Dmytro : slice() method make copy of array, splice() method removes elements
    dstLong.splice( 0, dstLong.length );
    return dstLong;
  }
  _.assert( 0, () => `Cant change length of fixed-length container ${_.entity.strType( dstLong )}` );
}

// //
//
// /**
//  * The routine longBut() returns a shallow copy of provided Long {-array-}. Routine removes existing
//  * elements in bounds defined by {-range-} and inserts new elements from {-val-}. The original
//  * source Long {-array-} will not be modified.
//  *
//  * @param { Long } array - The Long from which makes a shallow copy.
//  * @param { Range|Number } range - The two-element array that defines the start index and the end index for removing elements.
//  * If {-range-} is number, then it defines the start index, and the end index is start index incremented by one.
//  * If {-range-} is undefined, routine returns copy of {-array-}.
//  * If range[ 0 ] < 0, then start index sets to 0.
//  * If range[ 1 ] > array.length, end index sets to array.length.
//  * If range[ 1 ] <= range[ 0 ], then routine removes not elements, the insertion of elements begins at start index.
//  * @param { Long } val - The Long with elements for insertion. Inserting begins at start index.
//  * If quantity of removed elements is not equal to val.length, then returned Long will have length different to array.length.
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longBut( src );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.unroll.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longBut( src, 2, [ 'str' ] );
//  * console.log( got );
//  * // log [ 1, 2, 'str', 4, 5 ]
//  * console.log( _.unrollIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = new F32x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longBut( src, [ 1, 4 ], [ 5, 6, 7 ] );
//  * console.log( got );
//  * // log Float32Array[ 1, 5, 6, 7, 5 ]
//  * console.log( _.bufferTypedIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longBut( src, [ -5, 10 ], [ 'str' ] );
//  * console.log( got );
//  * // log [ 'str' ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longBut( src, [ 4, 1 ], [ 'str' ] );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 'str', 5 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @returns { Long } - Returns a copy of source Long with removed or replaced existing elements and / or added new elements. The copy has same type as source Long.
//  * @function longBut
//  * @throws { Error } If arguments.length is less then one or more then three.
//  * @throws { Error } If argument {-array-} is not a Long.
//  * @throws { Error } If range.length is less or more then two.
//  * @throws { Error } If range elements is not number / undefined.
//  * @throws { Error } If argument {-val-} is not Long / undefined.
//  * @namespace Tools
//  */
//
// /*
// qqq : routine longBut requires good test coverage and documentation | Dmytro : extended routine coverage by using given clarifications, documented
//  */

// function longBut( array, range, val )
// {
//
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   if( range === undefined )
//   return _.longJoin( array );
//   // return _.long.make( array );
//
//   if( _.arrayIs( array ) )
//   return _.arrayBut( array, range, val );
//
//   if( _.number.is( range ) )
//   range = [ range, range + 1 ];
//
//   _.assert( _.longLike( array ) );
//   _.assert( val === undefined || _.longLike( val ) );
//   _.assert( _.intervalIs( range ) );
//   // _.assert( _.longLike( range ), 'not tested' );
//   // _.assert( !_.longLike( range ), 'not tested' );
//
//   // if( _.number.is( range ) )
//   // range = [ range, range + 1 ];
//
//   _.ointerval.clamp/*rangeClamp*/( range, [ 0, array.length ] );
//   if( range[ 1 ] < range[ 0 ] )
//   range[ 1 ] = range[ 0 ];
//
//   let d = range[ 1 ] - range[ 0 ];
//   let len = ( val ? val.length : 0 );
//   let d2 = d - len;
//   let l2 = array.length - d2;
//
//   let result = _.long.makeUndefined( array, l2 );
//
//   // _.assert( 0, 'not tested' )
//
//   for( let i = 0 ; i < range[ 0 ] ; i++ )
//   result[ i ] = array[ i ];
//
//   for( let i = range[ 1 ] ; i < array.length ; i++ )
//   result[ i-d2 ] = array[ i ];
//
//   if( val )
//   {
//     for( let i = 0 ; i < val.length ; i++ )
//     result[ range[ 0 ]+i ] = val[ i ];
//   }
//
//   return result;
// }

// //
//
// /**
//  * The routine longButInplace() returns a Long {-array-} with removed existing elements in bounds
//  * defined by {-range-} and inserted new elements from {-val-}.
//  * If provided Long is resizable, routine modifies this Long in place, otherwise, return copy.
//  *
//  * @param { Long } array - The Long to remove, replace or add elements.
//  * @param { Range|Number } range - The two-element array that defines the start index and the end index for removing elements.
//  * If {-range-} is number, then it defines the start index, and the end index defines as start index incremented by one.
//  * If {-range-} is undefined, routine returns {-src-}.
//  * If range[ 0 ] < 0, then start index sets to 0.
//  * If range[ 1 ] > array.length, end index sets to array.length.
//  * If range[ 1 ] <= range[ 0 ], then routine removes no elements, the insertion of elements begins at start index.
//  * @param { Long } ins - The Long with elements for insertion. Inserting begins at start index.
//  * If quantity of removed elements is not equal to val.length, then returned array will have length different to original array.length.
//  *
//  * @example
//  * var src = new U8x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longButInplace( src );
//  * console.log( got );
//  * // log Uint8Array[ 1, 2, 3, 4, 5 ]
//  * console.log( _.bufferTypedIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log true
//  *
//  * @example
//  * var src = new I32x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longButInplace( src, 2, [ 6, 7 ] );
//  * console.log( got );
//  * // log Int8Array[ 1, 2, 6, 7, 4, 5 ]
//  * console.log( _.bufferTypedIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.unroll.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longButInplace( src, [ 1, 4 ], [ 'str' ] );
//  * console.log( got );
//  * // log [ 1, 'str', 5 ]
//  * console.log( _.unrollIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log true
//  *
//  * @example
//  * var src = _.argumentsArray.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longButInplace( src, [ -5, 10 ], [ 'str' ] );
//  * console.log( got );
//  * // log [ 'str' ]
//  * console.log( _.argumentsArray.is( got ) );
//  * // log false
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longButInplace( src, [ 4, 1 ], [ 'str' ] );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 'str', 5 ]
//  * console.log( got === src );
//  * // log true
//  *
//  * @returns { Long } Returns Long with removed or replaced existing elements and / or added new elements.
//  * If long is resizable, routine returns modified source long, otherwise, returns a copy.
//  * @function longButInplace
//  * @throws { Error } If arguments.length is less then one or more then three.
//  * @throws { Error } If argument {-array-} is not a long.
//  * @throws { Error } If range.length is less or more then two.
//  * @throws { Error } If range elements is not number / undefined.
//  * @throws { Error } If argument {-val-} is not long / undefined.
//  * @namespace Tools
//  */
//
// /*
// aaa : routine longButInplace requires good test coverage and documentation | Dmytro : implemented and covered routine longButInplace, documented
//  */
//
// function longButInplace( array, range, val )
// {
//
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   if( _.arrayLikeResizable( array ) )
//   return _.arrayButInplace( array, range, val );
//
//   if( range === undefined )
//   return array;
//   if( _.number.is( range ) )
//   range = [ range, range + 1 ];
//
//   _.assert( _.longLike( array ) );
//   _.assert( _.intervalIs( range ) );
//
//   _.ointerval.clamp/*rangeClamp*/( range, [ 0, array.length ] );
//   if( range[ 1 ] < range[ 0 ] )
//   range[ 1 ] = range[ 0 ];
//
//   if( range[ 0 ] === range[ 1 ] && val === undefined )
//   return array;
//   else
//   return _.longBut( array, range, val );
//
//   // let result;
//   //
//   // _.assert( _.longLike( src ) );
//   // _.assert( ins === undefined || _.longLike( ins ) );
//   // _.assert( _.longLike( range ), 'not tested' );
//   // _.assert( !_.longLike( range ), 'not tested' );
//   //
//   // _.assert( 0, 'not implemented' )
//
//   //
//   // if( _.number.is( range ) )
//   // range = [ range, range + 1 ];
//   //
//   // _.ointerval.clamp/*rangeClamp*/( range, [ 0, src.length ] );
//   // if( range[ 1 ] < range[ 0 ] )
//   // range[ 1 ] = range[ 0 ];
//   //
//   // let d = range[ 1 ] - range[ 0 ];
//   // let range[ 1 ] = src.length - d + ( ins ? ins.length : 0 );
//   //
//   // result = _.long.makeUndefined( src, range[ 1 ] );
//   //
//   // _.assert( 0, 'not tested' )
//   //
//   // for( let i = 0 ; i < range[ 0 ] ; i++ )
//   // result[ i ] = src[ i ];
//   //
//   // for( let i = range[ 1 ] ; i < range[ 1 ] ; i++ )
//   // result[ i-d ] = src[ i ];
//   //
//   // return result;
// }
//
// //
//
// // function _relength_head( dst, src, range, ins )
// // {
// //   _.assert( 1 <= arguments.length && arguments.length <= 4 );
// //
// //   /* aaa : suspicious */ /* Dmytro : removed */
// //
// //   if( dst === null )
// //   {
// //     dst = true;
// //   }
// //   else if( dst === src )
// //   {
// //     dst = false;
// //   }
// //   else if( arguments.length === 4 )
// //   {
// //     _.assert( _.longLike( dst ), '{-dst-} should be Long' );
// //   }
// //   else
// //   {
// //     /* aaa2 : wrong. src could pass check intervalIs if length is 2 */
// //     /* Dmytro : this check means: if length > 1 and second argument is not a range, then it is source container, and third argument is range */
// //     // if( arguments.length > 1 && !_.intervalIs( src ) && !_.number.is( src ) )
// //     // {
// //     //   _.assert( _.longLike( dst ) );
// //     // }
// //     // else
// //     // {
// //     //   ins = range;
// //     //   range = src;
// //     //   src = dst;
// //     //   dst = false;
// //     // }
// //
// //     ins = range;
// //     range = src;
// //     src = dst;
// //     dst = false;
// //   }
// //
// //   _.assert( _.longLike( src ) );
// //
// //   return [ dst, src, range, ins ];
// // }

//

/* aaa2 : rename arguments. ask */ /* Dmytro : renamed and standardized for each routine */

function longBut_( /* dst, src, cinterval, ins */ )
{
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];
  let cinterval = arguments[ 2 ];
  let ins = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );

  if( arguments.length < 4 && dst !== null && dst !== src )
  {
    dst = arguments[ 0 ];
    src = arguments[ 0 ];
    cinterval = arguments[ 1 ];
    ins = arguments[ 2 ];
  }

  if( cinterval === undefined )
  {
    cinterval = [ 0, -1 ];
    ins = undefined;
  }
  else if( _.number.is( cinterval ) )
  {
    cinterval = [ cinterval, cinterval ];
  }

  _.assert( _.longIs( dst ) || dst === null, 'Expects {-dst-} of any long type or null' );
  _.assert( _.longIs( src ), 'Expects {-src-} of any long type' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );
  _.assert( _.longLike( ins ) || ins === undefined || ins === null, 'Expects long {-ins-} for insertion' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] !== undefined ? cinterval[ 0 ] : 0;
  let last = cinterval[ 1 ] = cinterval[ 1 ] !== undefined ? cinterval[ 1 ] : src.length - 1;

  if( first < 0 )
  first = 0;
  if( first > src.length )
  first = src.length;
  if( last > src.length - 1 )
  last = src.length - 1;

  if( last + 1 < first )
  last = first - 1;

  let delta = last - first + 1;
  let insLength = ins ? ins.length : 0;
  let delta2 = delta - insLength;
  let resultLength = src.length - delta2;

  let result = dst;
  if( dst === null )
  {
    result = _.long.makeUndefined( src, resultLength );
  }
  else if( dst === src )
  {
    if( ( dst.length === resultLength ) && delta === 0 )
    {
      return dst;
    }
    if( _.arrayLikeResizable( dst ) )
    {
      ins ? dst.splice( first, delta, ... ins ) : dst.splice( first, delta );
      return dst;
    }
    else if( dst.length !== resultLength || _.argumentsArray.is( dst ) )
    {
      result = _.long.makeUndefined( dst, resultLength );
    }
  }
  else if( dst.length !== resultLength )
  {
    dst = _.long.makeUndefined( dst, resultLength );
  }

  /* */

  for( let i = 0 ; i < first ; i++ )
  result[ i ] = src[ i ];

  for( let i = last + 1 ; i < src.length ; i++ )
  result[ i - delta2 ] = src[ i ];

  if( ins )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    result[ first + i ] = ins[ i ];
  }

  return result;
}

// //
//
// /**
//  * The routine longOnly() returns a copy of a portion of provided Long {-array-} into a new Long
//  * selected by {-range-}. The original {-array-} will not be modified.
//  *
//  * @param { Long } array - The Long from which makes a shallow copy.
//  * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
//  * If {-range-} is number, then it defines the start index, and the end index sets to array.length.
//  * If {-range-} is undefined, routine returns copy of {-array-}.
//  * If range[ 0 ] < 0, then start index sets to 0.
//  * If range[ 1 ] > array.length, end index sets to array.length.
//  * If range[ 1 ] <= range[ 0 ], then routine returns empty Long.
//  * @param { * } val - The object of any type for insertion.
//  *
//  * @example
//  * var src = new F32x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.+( src );
//  * console.log( got );
//  * // log Float32Array[ 1, 2, 3, 4, 5 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.unroll.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longOnly( src, 2, [ 'str' ] );
//  * console.log( got );
//  * // log [ 3, 4, 5 ]
//  * console.log( _.unrollIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longOnly( src, [ 1, 4 ], [ 'str' ] );
//  * console.log( got );
//  * // log [ 2, 3, 4 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.argumentsArray.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longOnly( src, [ -5, 10 ], [ 'str' ] );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5 ]
//  * console.log( _.argumentsArray.is( got ) );
//  * // log false
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longOnly( src, [ 4, 1 ], [ 'str' ] );
//  * console.log( got );
//  * // log []
//  * console.log( got === src );
//  * // log false
//  *
//  * @returns { Long } Returns a copy of source Long containing the extracted elements. The copy has same type as source Long.
//  * @function longOnly
//  * @throws { Error } If arguments.length is less then one or more then three.
//  * @throws { Error } If argument {-array-} is not a Long.
//  * @throws { Error } If range.length is less or more then two.
//  * @throws { Error } If range elements is not number / undefined.
//  * @namespace Tools
//  */
//
// /*
//   qqq : extend documentation and test coverage of longOnly | Dmytro : documented, covered.
// */
//
// function longOnly( array, range, val )
// {
//   let result;
//
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   if( range === undefined )
//   // return _.long.make( array, array.length ? array.length : 0 );
//   return _.longJoin( array );
//
//   if( _.number.is( range ) )
//   range = [ range, array.length ];
//
//   // let f = range ? range[ 0 ] : undefined;
//   // let l = range ? range[ 1 ] : undefined;
//   //
//   // f = f !== undefined ? f : 0;
//   // l = l !== undefined ? l : array.length;
//
//   _.assert( _.longLike( array ) );
//   _.assert( _.intervalIs( range ) )
//
//   // if( f < 0 )
//   // {
//   //   l -= f;
//   //   f -= f;
//   // }
//
//   _.ointerval.clamp/*rangeClamp*/( range, [ 0, array.length ] );
//   if( range[ 1 ] < range[ 0 ] )
//   range[ 1 ] = range[ 0 ];
//
//   // if( l < f )
//   // l = f;
//
//   // if( f < 0 )
//   // f = 0;
//   // if( l > array.length )
//   // l = array.length;
//
//   if( range[ 0 ] === 0 && range[ 1 ] === array.length )
//   // return _.long.make( array, array.length );
//   return _.longJoin( array );
//
//   result = _.long.makeUndefined( array, range[ 1 ]-range[ 0 ] );
//
//   let f2 = Math.max( range[ 0 ], 0 );
//   let l2 = Math.min( array.length, range[ 1 ] );
//   for( let r = f2 ; r < l2 ; r++ )
//   result[ r-f2 ] = array[ r ];
//
//   if( val !== undefined )
//   {
//     for( let r = 0 ; r < -range[ 0 ] ; r++ )
//     {
//       result[ r ] = val;
//     }
//     for( let r = l2 - range[ 0 ]; r < result.length ; r++ )
//     {
//       result[ r ] = val;
//     }
//   }
//
//   return result;
// }

// //
//
// /**
//  * The routine longOnlyInplace() returns a portion of provided Long {-array-} selected by {-range-}.
//  * If provided Long is resizable, routine modifies this Long in place, otherwise, return copy.
//  *
//  * @param { Long } array - The Long from which selects elements.
//  * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
//  * If {-range-} is number, then it defines the start index, and the end index sets to array.length.
//  * If {-range-} is undefined, routine returns {-array-}.
//  * If range[ 0 ] < 0, then start index sets to 0.
//  * If range[ 1 ] > array.length, end index sets to array.length.
//  * If range[ 1 ] <= range[ 0 ], then routine returns empty Long.
//  * @param { * } val - The object of any type for insertion.
//  *
//  * @example
//  * var src = new F32x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longOnlyInplace( src );
//  * console.log( got );
//  * // log Float32Array[ 1, 2, 3, 4, 5 ]
//  * console.log( got === src );
//  * // log true
//  *
//  * @example
//  * var src = _.unroll.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longOnlyInplace( src, 2, [ 'str' ] );
//  * console.log( got );
//  * // log [ 3, 4, 5 ]
//  * console.log( _.unrollIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log true
//  *
//  * @example
//  * var src = new U8x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longOnlyInplace( src, [ 1, 4 ], [ 1 ] );
//  * console.log( got );
//  * // log Uint8Array[ 2, 3, 4 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.argumentsArray.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longOnlyInplace( src, [ -5, 10 ], [ 'str' ] );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5 ]
//  * console.log( _.argumentsArray.is( got ) );
//  * // log false
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longOnlyInplace( src, [ 4, 1 ], [ 'str' ] );
//  * console.log( got );
//  * // log []
//  * console.log( got === src );
//  * // log false
//  *
//  * @returns { Long } Returns a Long containing the selected elements. If Long is resizable,
//  * routine returns modified source Long, otherwise, returns a copy.
//  * @function longOnlyInplace
//  * @throws { Error } If arguments.length is less then one or more then three.
//  * @throws { Error } If argument {-array-} is not a Long.
//  * @throws { Error } If range.length is less or more then two.
//  * @throws { Error } If range elements is not number / undefined.
//  * @namespace Tools
//  */
//
// /*
//   qqq : extend documentation and test coverage of longOnlyInplace | Dmytro : documented, covered
//   qqq : implement arrayShrink | Dmytro : implemented
//   qqq : implement arrayShrinkInplace | Dmytro : implemented
// */
//
// function longOnlyInplace( array, range, val )
// {
//
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   if( _.arrayLikeResizable( array ) )
//   return _.arrayShrinkInplace( array, range, val );
//
//   if( range === undefined )
//   return array;
//   if( _.number.is( range ) )
//   range = [ range, array.length ];
//
//   _.assert( _.longLike( array ) );
//   _.assert( _.intervalIs( range ) );
//
//   _.ointerval.clamp/*rangeClamp*/( range, [ 0, array.length ] );
//   if( range[ 1 ] < range[ 0 ] )
//   range[ 1 ] = range[ 0 ];
//
//   if( range[ 0 ] === 0 && range[ 1 ] === array.length )
//   return array;
//   else
//   return _.longOnly( array, range, val );
//   // let result;
//   //
//   // if( range === undefined )
//   // return array;
//   //
//   // if( _.number.is( range ) )
//   // range = [ range, array.length ];
//   //
//   // // let f = range ? range[ 0 ] : undefined;
//   // // let l = range ? range[ 1 ] : undefined;
//   // //
//   // // f = f !== undefined ? f : 0;
//   // // l = l !== undefined ? l : array.length;
//   //
//   // _.assert( _.longLike( array ) );
//   // _.assert( _.intervalIs( range ) )
//   // // _.assert( _.number.is( f ) );
//   // // _.assert( _.number.is( l ) );
//   // _.assert( 1 <= arguments.length && arguments.length <= 3 );
//   // // _.assert( 1 <= arguments.length && arguments.length <= 4 );
//   //
//   // _.ointerval.clamp/*rangeClamp*/( range, [ 0, array.length ] );
//   // if( range[ 1 ] < range[ 0 ] )
//   // range[ 1 ] = range[ 0 ];
//   //
//   // // if( l < f )
//   // // l = f;
//   // //
//   // // if( f < 0 )
//   // // f = 0;
//   // // if( l > array.length )
//   // // l = array.length;
//   //
//   // if( range[ 0 ] === 0 && range[ 1 ] === array.length )
//   // // if( range[ 0 ] === 0 && l === array.length ) // Dmytro : l is not defined
//   // return array;
//   //
//   // // if( _.bufferTypedIs( array ) )
//   // // result = new array.constructor( l-f );
//   // // else
//   // // result = new Array( l-f );
//   //
//   // result = _.long.makeUndefined( array, range[ 1 ]-range[ 0 ] );
//   //
//   // /* */
//   //
//   // let f2 = Math.max( range[ 0 ], 0 );
//   // let l2 = Math.min( array.length, range[ 1 ] );
//   // for( let r = f2 ; r < l2 ; r++ )
//   // result[ r-range[ 0 ] ] = array[ r ];
//   //
//   // /* */
//   //
//   // if( val !== undefined )
//   // {
//   //   for( let r = 0 ; r < -range[ 0 ] ; r++ )
//   //   {
//   //     result[ r ] = val;
//   //   }
//   //   for( let r = l2 - range[ 0 ]; r < result.length ; r++ )
//   //   {
//   //     result[ r ] = val;
//   //   }
//   // }
//   //
//   // /* */
//   //
//   // return result;
// }

//

function longOnly_( dst, src, cinterval )
{
  _.assert( 1 <= arguments.length && arguments.length <= 3, 'Expects not {-ins-} element' );

  if( arguments.length < 3 && dst !== null && dst !== src )
  {
    dst = arguments[ 0 ];
    src = arguments[ 0 ];
    cinterval = arguments[ 1 ];
  }

  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval ];

  _.assert( _.longIs( dst ) || dst === null, 'Expects {-dst-} of any long type or null' );
  _.assert( _.longIs( src ), 'Expects {-src-} of any long type' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] !== undefined ? cinterval[ 0 ] : 0;
  let last = cinterval[ 1 ] = cinterval[ 1 ] !== undefined ? cinterval[ 1 ] : src.length - 1;

  if( first < 0 )
  first = 0;
  if( last > src.length - 1 )
  last = src.length - 1;

  if( last + 1 < first )
  last = first - 1;

  let first2 = Math.max( first, 0 );
  let last2 = Math.min( src.length - 1, last );

  let resultLength = last - first + 1;

  let result = dst;
  if( dst === null )
  {
    result = _.long.makeUndefined( src, resultLength );
  }
  else if( dst === src )
  {
    if( dst.length === resultLength )
    {
      return dst;
    }
    if( _.arrayLikeResizable( dst ) )
    {
      _.assert( Object.isExtensible( dst ), 'Array is not extensible, cannot change array' );
      if( resultLength === 0 )
      return _.longEmpty( dst );

      dst.splice( last2 + 1, dst.length - last + 1 );
      dst.splice( 0, first2 );
      return dst;
    }
    else if( dst.length !== resultLength || _.argumentsArray.is( dst ) )
    {
      result = _.long.makeUndefined( dst, resultLength );
    }
  }
  else if( dst.length !== resultLength )
  {
    if( !_.arrayLikeResizable( result ) )
    result = _.bufferMakeUndefined( dst, resultLength );
    else
    result.splice( resultLength );
  }

  for( let r = first2 ; r < last2 + 1 ; r++ )
  result[ r - first2 ] = src[ r ];

  return result;
}

// //
//
// /**
//  * Routine longGrow() changes length of provided Long {-array-} by copying it elements to newly created Long of the same
//  * type using range {-range-} positions of the original Long and value to fill free space after copy {-val-}.
//  * Routine can only grows size of Long. The original {-array-} will not be modified.
//  *
//  * @param { Long } array - The Long from which makes a shallow copy.
//  * @param { Range } The two-element array that defines the start index and the end index for copying elements.
//  * If {-range-} is number, then it defines the end index, and the start index is 0.
//  * If range[ 0 ] < 0, then start index sets to 0, end index incrementes by absolute value of range[ 0 ].
//  * If range[ 0 ] > 0, then start index sets to 0.
//  * If range[ 1 ] > array.length, end index sets to array.length.
//  * If range[ 1 ] <= range[ 0 ], then routine returns a copy of original Long.
//  * @param { * } val - The object of any type. Used to fill the space left after copying elements of the original Long.
//  *
//  * @example
//  * var src = new F32x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longGrow( src );
//  * console.log( got );
//  * // log Float32Array[ 1, 2, 3, 4, 5 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.unroll.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longGrow( src, 7, 'str' );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5, 'str', 'str' ]
//  * console.log( _.unrollIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = new U8x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longGrow( src, [ 1, 6 ], 7 );
//  * console.log( got );
//  * // log Uint8Array[ 1, 2, 3, 4, 5, 7 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.argumentsArray.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longGrow( src, [ -5, 6 ], 7 );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5, 7, 7, 7, 7, 7, 7 ]
//  * console.log( _.argumentsArray.is( got ) );
//  * // log false
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longGrow( src, [ 4, 1 ], 'str' );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @returns { Long } Returns a copy of provided Long with changed length.
//  * @function longGrow
//  * @throws { Error } If arguments.length is less then one or more then three.
//  * @throws { Error } If argument {-array-} is not a Long.
//  * @throws { Error } If range.length is less or more then two.
//  * @throws { Error } If range elements is not number / undefined.
//  * @namespace Tools
//  */
//
// /*
//   aaa : extend documentation and test coverage of longGrowInplace | Dmytro : extended documentation, covered routine longGrow, longGrowInplace
//   aaa : implement arrayGrow | Dmytro : implemented
//   aaa : implement arrayGrowInplace | Dmytro : implemented
// */
//
// function longGrow( array, range, val )
// {
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   if( range === undefined )
//   return _.longJoin( array );
//
//   if( _.number.is( range ) )
//   range = [ 0, range ];
//
//   let f = range[ 0 ] !== undefined ? range[ 0 ] : 0;
//   let l = range[ 1 ] !== undefined ? range[ 1 ] : array.length;
//
//   _.assert( _.longLike( array ) );
//   _.assert( _.intervalIs( range ) )
//
//   if( l < f )
//   l = f;
//
//   if( f < 0 )
//   {
//     l -= f;
//     f -= f;
//   }
//
//   if( f > 0 )
//   f = 0;
//   if( l < array.length )
//   l = array.length;
//
//   if( l === array.length && -range[ 0 ] <= 0 )
//   return _.longJoin( array );
//
//   /* */
//
//   let f2 = Math.max( -range[ 0 ], 0 );
//   let l2 = Math.min( array.length, l );
//
//   let result = _.long.makeUndefined( array, range[ 1 ] > array.length ? l : array.length + f2 );
//   for( let r = f2 ; r < l2 + f2 ; r++ )
//   result[ r ] = array[ r - f2 ];
//
//   /* */
//
//   if( val !== undefined )
//   {
//     for( let r = 0 ; r < f2 ; r++ )
//     result[ r ] = val;
//     for( let r = l2 + f2; r < result.length ; r++ )
//     result[ r ] = val;
//   }
//
//   /* */
//
//   return result;
// }
//
// //
//
// /**
//  * Routine longGrowInplace() changes length of provided Long {-array-} using range {-range-} positions of the original
//  * Long and value to fill free space after copy {-val-}. If provided Long is resizable, routine modifies this
//  * Long in place, otherwise, return copy. Routine can only grows size of Long.
//  *
//  * @param { Long } array - The Long to grow length.
//  * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
//  * If {-range-} is number, then it defines the end index, and the start index is 0.
//  * If range[ 0 ] < 0, then start index sets to 0, end index incrementes by absolute value of range[ 0 ].
//  * If range[ 0 ] > 0, then start index sets to 0.
//  * If range[ 1 ] > array.length, end index sets to array.length.
//  * If range[ 1 ] <= range[ 0 ], then routine returns origin array.
//  * @param { * } val - The object of any type. Used to fill the space left of the original Long.
//  *
//  * @example
//  * var src = new F32x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longGrowInplace( src );
//  * console.log( got );
//  * // log Float32Array[ 1, 2, 3, 4, 5 ]
//  * console.log( got === src );
//  * // log true
//  *
//  * @example
//  * var src = _.unroll.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longGrowInplace( src, 7, 'str' );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5, 'str', 'str' ]
//  * console.log( _.unrollIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log true
//  *
//  * @example
//  * var src = new U8x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longGrowInplace( src, [ 1, 6 ], 7 );
//  * console.log( got );
//  * // log Uint8Array[ 1, 2, 3, 4, 5, 7 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.argumentsArray.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longGrowInplace( src, [ -5, 6 ], 7 );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5, 7, 7, 7, 7, 7, 7 ]
//  * console.log( _.argumentsArray.is( got ) );
//  * // log false
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longGrowInplace( src, [ 4, 1 ], 'str' );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5 ]
//  * console.log( got === src );
//  * // log true
//  *
//  * @returns { Long } Returns a Long with changed length.
//  * If Long is resizable, routine returns modified source Long, otherwise, returns a copy.
//  * @function longGrowInplace
//  * @throws { Error } If arguments.length is less then one or more then three.
//  * @throws { Error } If argument {-array-} is not a Long.
//  * @throws { Error } If range.length is less or more then two.
//  * @throws { Error } If range elements is not number / undefined.
//  * @namespace Tools
//  */
//
// function longGrowInplace( array, range, val )
// {
//
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   if( _.arrayLikeResizable( array ) )
//   return _.arrayGrowInplace( array, range, val );
//
//   if( range === undefined )
//   return array;
//   if( _.number.is( range ) )
//   range = [ 0, range ];
//
//   let f = range[ 0 ] !== undefined ? range[ 0 ] : 0;
//   let l = range[ 1 ] !== undefined ? range[ 1 ] : array.length;
//
//   _.assert( _.longLike( array ) );
//   _.assert( _.intervalIs( range ) )
//
//   if( l < f )
//   l = f;
//   if( f < 0 )
//   {
//     l -= f;
//     f -= f;
//   }
//   if( f > 0 )
//   f = 0;
//   if( l < array.length )
//   l = array.length;
//
//   if( l === array.length && -range[ 0 ] <= 0 )
//   return array;
//   else
//   return _.longGrow( array, range, val );
// }

//

function longGrow_( /* dst, src, cinterval, ins */ )
{
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];
  let cinterval = arguments[ 2 ];
  let ins = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );

  if( arguments.length < 4 && dst !== null && dst !== src )
  {
    dst = arguments[ 0 ];
    src = arguments[ 0 ];
    cinterval = arguments[ 1 ];
    ins = arguments[ 2 ];
  }

  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval - 1 ];

  _.assert( _.longIs( dst ) || dst === null, 'Expects {-dst-} of any long type or null' );
  _.assert( _.longIs( src ), 'Expects {-src-} of any long type' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] !== undefined ? cinterval[ 0 ] : 0;
  let last = cinterval[ 1 ] = cinterval[ 1 ] !== undefined ? cinterval[ 1 ] : src.length - 1;

  if( first > 0 )
  first = 0;
  if( last < src.length - 1 )
  last = src.length - 1;

  if( first < 0 )
  {
    last -= first;
    first -= first;
  }

  if( last + 1 < first )
  last = first - 1;

  let first2 = Math.max( -cinterval[ 0 ], 0 );
  let last2 = Math.min( src.length - 1 + first2, last + first2 );

  let resultLength = last - first + 1;

  let result = dst;
  if( dst === null )
  {
    result = _.long.makeUndefined( src, resultLength );
  }
  else if( dst === src )
  {
    if( dst.length === resultLength )
    {
      return dst;
    }
    if( _.arrayLikeResizable( dst ) )
    {
      _.assert( Object.isExtensible( dst ), 'Array is not extensible, cannot change array' );
      dst.splice( 0, 0, ... _.dup( ins, first2 ) );
      dst.splice( last2 + 1, 0, ... _.dup( ins, resultLength <= last2 ? 0 : resultLength - last2 - 1 ) );
      return dst;
    }
    else if( dst.length !== resultLength || _.argumentsArray.is( dst ) )
    {
      result = _.long.makeUndefined( dst, resultLength );
    }
  }
  else if( dst.length !== resultLength )
  {
    if( !_.arrayLikeResizable( result ) )
    result = _.bufferMakeUndefined( dst, resultLength );
    else
    result.splice( resultLength );
  }

  for( let r = first2 ; r < last2 + 1 ; r++ )
  result[ r ] = src[ r - first2 ];

  if( ins !== undefined )
  {
    for( let r = 0 ; r < first2 ; r++ )
    result[ r ] = ins;
    for( let r = last2 + 1 ; r < resultLength ; r++ )
    result[ r ] = ins;
  }

  return result;
}

// //
//
// /**
//  * Routine longRelength() changes length of provided Long {-array-} by copying its elements to newly created Long of the same
//  * type as source Long. Routine uses range {-range-} positions of the original Long and value {-val-} to fill free space after copy.
//  * Routine can grows and reduces size of Long. The original {-array-} will not be modified.
//  *
//  * @param { Long } array - The Long from which makes a shallow copy.
//  * @param { Range } The two-element array that defines the start index and the end index for copying elements.
//  * If {-range-} is number, then it defines the start index, and the end index sets to array.length.
//  * If range[ 0 ] < 0, then start index sets to 0.
//  * If range[ 1 ] <= range[ 0 ], then routine returns empty Long.
//  * @param { * } val - The object of any type. Used to fill the space left after copying elements of the original Long.
//  *
//  * @example
//  * var src = new F32x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longRelength( src );
//  * console.log( got );
//  * // log Float32Array[ 1, 2, 3, 4, 5 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.unroll.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longRelength( src, 7, 'str' );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5, 'str', 'str' ]
//  * console.log( _.unrollIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = new U8x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longRelength( src, [ 1, 6 ], 7 );
//  * console.log( got );
//  * // log Uint8Array[ 2, 3, 4, 5, 7 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.argumentsArray.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longRelength( src, [ -5, 6 ], 7 );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5, 7 ]
//  * console.log( _.argumentsArray.is( got ) );
//  * // log false
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longRelength( src, [ 4, 1 ], 'str' );
//  * console.log( got );
//  * // log []
//  * console.log( got === src );
//  * // log false
//  *
//  * @returns { Long } Returns a copy of provided Long with changed length.
//  * @function longRelength
//  * @throws { Error } If arguments.length is less then one or more then three.
//  * @throws { Error } If argument {-array-} is not a Long.
//  * @throws { Error } If range.length is less or more then two.
//  * @throws { Error } If range elements is not number / undefined.
//  * @namespace Tools
//  */
//
// function longRelength( array, range, val )
// {
//
//   let result;
//
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   if( range === undefined )
//   return _.longJoin( array );
//   // return _.long.make( array );
//
//   if( _.number.is( range ) )
//   range = [ range, array.length ];
//
//   let f = range[ 0 ] !== undefined ? range[ 0 ] : 0;
//   let l = range[ 1 ] !== undefined ? range[ 1 ] : src.length;
//
//   _.assert( _.longLike( array ) );
//   _.assert( _.intervalIs( range ) )
//
//   if( l < f )
//   l = f;
//   if( f > array.length )
//   f = array.length
//
//   if( f < 0 )
//   f = 0;
//
//   if( f === 0 && l === array.length )
//   return _.long.make( array );
//
//   result = _.long.makeUndefined( array, l-f );
//
//   /* */
//
//   let f2 = Math.max( f, 0 );
//   let l2 = Math.min( array.length, l );
//   for( let r = f2 ; r < l2 ; r++ )
//   result[ r-f2 ] = array[ r ];
//
//   /* */
//
//   if( val !== undefined )
//   {
//     for( let r = l2 - range[ 0 ]; r < result.length ; r++ )
//     {
//       result[ r ] = val;
//     }
//   }
//
//   /* */
//
//   return result;
// }
//
// //
//
// /**
//  * Routine longRelengthInplace() changes length of provided Long {-array-} using range {-range-} positions of the original
//  * Long and value to fill free space after copy {-val-}. If provided Long is resizable, routine modifies this
//  * Long in place, otherwise, return copy. Routine can grows and reduce size of Long.
//  *
//  * @param { Long } array - The Long to change length.
//  * @param { Range|Number } range - The two-element array that defines the start index and the end index for copying elements.
//  * If {-range-} is number, then it defines the start index, and the end index sets to src.length.
//  * If range[ 0 ] < 0, then start index sets to 0.
//  * If range[ 1 ] <= range[ 0 ], then routine returns empty array.
//  * @param { * } val - The object of any type. Used to fill the space left of the original Long.
//  *
//  * @example
//  * var src = new F32x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longRelengthInplace( src );
//  * console.log( got );
//  * // log Float32Array[ 1, 2, 3, 4, 5 ]
//  * console.log( got === src );
//  * // log true
//  *
//  * @example
//  * var src = _.unroll.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longRelengthInplace( src, 7, 'str' );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5, 'str', 'str' ]
//  * console.log( _.unrollIs( got ) );
//  * // log true
//  * console.log( got === src );
//  * // log true
//  *
//  * @example
//  * var src = new U8x( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longRelengthInplace( src, [ 1, 6 ], 7 );
//  * console.log( got );
//  * // log Uint8Array[ 2, 3, 4, 5, 7 ]
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = _.argumentsArray.make( [ 1, 2, 3, 4, 5 ] );
//  * var got = _.longRelengthInplace( src, [ -5, 6 ], 7 );
//  * console.log( got );
//  * // log [ 1, 2, 3, 4, 5, 7 ]
//  * console.log( _.argumentsArray.is( got ) );
//  * // log false
//  * console.log( got === src );
//  * // log false
//  *
//  * @example
//  * var src = [ 1, 2, 3, 4, 5 ];
//  * var got = _.longRelengthInplace( src, [ 4, 1 ], 'str' );
//  * console.log( got );
//  * // log []
//  * console.log( got === src );
//  * // log true
//  *
//  * @returns { Long } Returns a Long with changed length.
//  * If Long is resizable, routine returns modified source Long, otherwise, returns a copy.
//  * @function longRelengthInplace
//  * @throws { Error } If arguments.length is less then one or more then three.
//  * @throws { Error } If argument {-array-} is not a Long.
//  * @throws { Error } If range.length is less or more then two.
//  * @throws { Error } If range elements is not number / undefined.
//  * @namespace Tools
//  */
//
// function longRelengthInplace( array, range, val )
// {
//
//   _.assert( 1 <= arguments.length && arguments.length <= 3 );
//
//   if( _.arrayLikeResizable( array ) )
//   return _.arrayRelengthInplace( array, range, val );
//
//   if( range === undefined )
//   return array;
//   if( _.number.is( range ) )
//   range = [ range, array.length ];
//
//   let f = range[ 0 ] !== undefined ? range[ 0 ] : 0;
//   let l = range[ 1 ] !== undefined ? range[ 1 ] : src.length;
//
//   _.assert( _.longLike( array ) );
//   _.assert( _.intervalIs( range ) )
//
//   if( l < f )
//   l = f;
//   if( f > array.length )
//   f = array.length;
//   if( f < 0 )
//   f = 0;
//
//   if( f === 0 && l === array.length )
//   return array;
//   else
//   return _.longRelength( array, range, val );
//
// }

//

function longRelength_( /* dst, src, cinterval, ins */ )
{
  let dst = arguments[ 0 ];
  let src = arguments[ 1 ];
  let cinterval = arguments[ 2 ];
  let ins = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );

  if( arguments.length < 4 && dst !== null && dst !== src )
  {
    dst = arguments[ 0 ];
    src = arguments[ 0 ];
    cinterval = arguments[ 1 ];
    ins = arguments[ 2 ];
  }

  if( cinterval === undefined )
  cinterval = [ 0, src.length - 1 ];
  if( _.number.is( cinterval ) )
  cinterval = [ 0, cinterval - 1 ];

  _.assert( _.longIs( dst ) || dst === null, 'Expects {-dst-} of any long type or null' );
  _.assert( _.longIs( src ), 'Expects {-src-} of any long type' );
  _.assert( _.intervalIs( cinterval ), 'Expects cinterval {-cinterval-}' );

  let first = cinterval[ 0 ] = cinterval[ 0 ] !== undefined ? cinterval[ 0 ] : 0;
  let last = cinterval[ 1 ] = cinterval[ 1 ] !== undefined ? cinterval[ 1 ] : src.length - 1;

  if( last < first )
  last = first - 1;

  if( cinterval[ 1 ] < 0 && cinterval[ 0 ] < 0 )
  cinterval[ 0 ] -= cinterval[ 1 ] + 1;

  if( first < 0 )
  {
    last -= first;
    first -= first;
  }

  let first2 = Math.max( Math.abs( cinterval[ 0 ] ), 0 );
  let last2 = Math.min( src.length - 1, last );

  let resultLength = last - first + 1;

  let result = dst;
  if( dst === null )
  {
    result = _.long.makeUndefined( src, resultLength );
  }
  else if( dst === src )
  {
    if( dst.length === resultLength && cinterval[ 0 ] === 0 )
    {
      return dst;
    }
    if( _.arrayLikeResizable( dst ) )
    {
      _.assert( Object.isExtensible( dst ), 'dst is not extensible, cannot change dst' );
      if( cinterval[ 0 ] < 0 )
      {
        dst.splice( first, 0, ... _.dup( ins, first2 ) );
        dst.splice( last2 + 1, src.length - last2, ... _.dup( ins, last - last2 ) );
      }
      else
      {
        dst.splice( 0, first );
        dst.splice( last2 + 1 - first2, src.length - last2, ... _.dup( ins, last - last2 ) );
      }
      return dst;
    }
    else if( dst.length !== resultLength || _.argumentsArray.is( dst ) )
    {
      result = _.long.makeUndefined( dst, resultLength );
    }
  }
  else if( dst.length !== resultLength )
  {
    if( !_.arrayLikeResizable( result ) )
    result = _.bufferMakeUndefined( dst, resultLength );
    else
    result.splice( resultLength );
  }

  /* */

  if( resultLength === 0 )
  {
    return result;
  }
  if( cinterval[ 0 ] < 0 )
  {
    for( let r = first2 ; r < ( last2 + 1 + first2 ) && r < resultLength ; r++ )
    result[ r ] = src[ r - first2 ];
    if( ins !== undefined )
    {
      for( let r = 0 ; r < first2 ; r++ )
      result[ r ] = ins;
      for( let r = last2 + 1 + first2 ; r < resultLength ; r++ )
      result[ r ] = ins;
    }
  }
  else
  {
    for( let r = first2 ; r < last2 + 1 ; r++ )
    result[ r - first2 ] = src[ r ];

    if( ins !== undefined )
    {
      for( let r = last2 + 1 ; r < last + 1 ; r++ )
      result[ r - first2 ] = ins;
    }
  }

  return result;
}

// --
// array checker
// --

// /**
//  * The longCompare() routine returns the first difference between the values of the first array from the second.
//  *
//  * @param { longLike } src1 - The first array.
//  * @param { longLike } src2 - The second array.
//  *
//  * @example
//  * _.longCompare( [ 1, 5 ], [ 1, 2 ] );
//  * // returns 3
//  *
//  * @returns { Number } - Returns the first difference between the values of the two arrays.
//  * @function longCompare
//  * @throws { Error } Will throw an Error if (arguments.length) is less or more than two.
//  * @throws { Error } Will throw an Error if (src1 and src2) are not the array-like.
//  * @throws { Error } Will throw an Error if (src2.length) is less or not equal to the (src1.length).
//  * @namespace Tools
//  */
//
// function longCompare( src1, src2 )
// {
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( _.longLike( src1 ) && _.longLike( src2 ) );
//   _.assert( src2.length >= src1.length );
//
//   let result = 0;
//
//   for( let s = 0 ; s < src1.length ; s++ )
//   {
//
//     result = src1[ s ] - src2[ s ];
//     if( result !== 0 )
//     return result;
//
//   }
//
//   return result;
// }
//
// //
//
// /**
//  * The long.identicalShallow() routine checks the equality of two arrays.
//  *
//  * @param { longLike } src1 - The first array.
//  * @param { longLike } src2 - The second array.
//  *
//  * @example
//  * _.long.identicalShallow( [ 1, 2, 3 ], [ 1, 2, 3 ] );
//  * // returns true
//  *
//  * @returns { Boolean } - Returns true if all values of the two arrays are equal. Otherwise, returns false.
//  * @function long.identicalShallow
//  * @throws { Error } Will throw an Error if (arguments.length) is less or more than two.
//  * @namespace Tools
//  */
//
// /* xxx : vector? */
// /* qqq : extend test */
// function long.identicalShallow( src1, src2 )
// {
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   // qqq : for junior : !
//   // _.assert( _.longLike( src1 ) );
//   // _.assert( _.longLike( src2 ) );
//
//   if( !_.longLike( src1 ) )
//   return false;
//   if( !_.longLike( src2 ) )
//   return false;
//
//   return _._long.identicalShallow( src1, src2 );
//
// }
//
// //
//
// function _long.identicalShallow( src1, src2 )
// {
//   let result = true;
//
//   if( src1.length !== src2.length )
//   return false;
//
//   for( let s = 0 ; s < src1.length ; s++ )
//   {
//     result = src1[ s ] === src2[ s ];
//     if( result === false )
//     return false;
//   }
//
//   return result;
// }

//

function longHas( /* array, element, evaluator1, evaluator2 */ )
{
  let array = arguments[ 0 ];
  let element = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.argumentsArray.like( array ) );

  if( !evaluator1 && !evaluator2 )
  {
    // return _ArrayIndexOf.call( array, element ) !== -1;
    return _ArrayIncludes.call( array, element );
  }
  else
  {
    if( _.longLeftIndex( array, element, evaluator1, evaluator2 ) >= 0 )
    return true;
    return false;
  }

}

//

/**
 * The routine longHasAny() checks if the source long {-src-} has at least one element of the long {-ins-}.
 * It can take equalizer or evaluators for comparing elements.
 *
 * It iterates over source long {-src-} each element of the long {-ins-} by the routine
 * [longLeftIndex()]{@link wTools.longLeftIndex}
 * Checks, if {-src-} has at least one element of the {-ins-}.
 * If true, it returns true.
 * Otherwise, it returns false.
 *
 * @see {@link wTools.longLeftIndex} - See for more information.
 *
 * @param { Long } src - The source array.
 * @param  { Long|Primitive } ins - The elements to check in the source array.
 * @param { Function } evaluator1 - A callback function. Can be an equalizer or evaluator.
 * @param { Function } evaluator2 - A callback function. Uses only as second evaluator.
 *
 * @example
 * _.longHasAny( [ 5, 'str', 42, false ], 7 );
 * // returns false
 *
 * @example
 * _.longHasAny( [ 5, 'str', 42, false ], [ false, 7, 10 ] );
 * // returns true
 *
 * @example
 * _.longHasAny( [ { a : 2 }, 'str', 42, false ], [ { a : 2 }, { a : 3 } ] );
 * // returns false
 *
 * @example
 * var evaluator = ( e ) => e.a;
 * _.longHasAny( [ { a : 2 }, 'str', 42, false ], [ { a : 2 }, { a : 3 } ], evaluator );
 * // returns true
 *
 * @example
 * var evaluator1 = ( e ) => e.a;
 * var evaluator2 = ( e ) => e.b;
 * _.longHasAny( [ { a : 2 }, 'str', 42, false ], [ { b : 2 }, { b : 3 } ], evaluator1, evaluator2 );
 * // returns true
 *
 * @example
 * var equalizer = ( eSrc, eIns ) => eSrc.a === eIns.b;
 * _.longHasAny( [ { a : 2 }, 'str', 42, false ], [ { b : 2 }, { b : 3 } ], equalizer );
 * // returns true
 *
 * @returns { Boolean } - Returns true, if {-src-} has at least one element of {-ins-}, otherwise false is returned.
 * @function longHasAny
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-src-} is not a Long.
 * @throws { Error } If {-ins-} is not a Long, not a primitive.
 * @throws { Error } If {-evaluator1-} is not a routine.
 * @throws { Error } If {-evaluator1-} is an evaluator and accepts less or more than one argument.
 * @throws { Error } If {-evaluator1-} is an equalizer and accepts less or more than two argument.
 * @throws { Error } If {-evaluator2-} is not a routine.
 * @throws { Error } If {-evaluator2-} is an evaluator and accepts less or more than one argument.
 * @namespace Tools
 */

function longHasAny( /* src, ins, evaluator1, evaluator2 */ )
{
  let src = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );
  _.assert( _.longLike( src ), `Expects long, but got ${ _.entity.strType( src ) }` );
  _.assert( _.longLike( ins ) || _.primitive.is( ins ) );

  if( _.primitive.is( ins ) )
  ins = [ ins ];

  let i = 0;
  let result;

  do
  {
    result = _.longLeftIndex( src, ins[ i ], 0, evaluator1, evaluator2 );
    i++;
  }
  while( result < 0 && i < ins.length )

  if( result !== -1 )
  return true;
  return false;
}

//

/**
 * The routine longHasAll() checks if the source long {-src-} has all elements of the long {-ins-}.
 * It can take equalizer or evaluators for comparing elements.
 *
 * It iterates over source long {-src-} each element of the long {-ins-} by the routine
 * [longLeftIndex()]{@link wTools.longLeftIndex}
 * Checks, if {-src-} has all elements of the {-ins-}.
 * If true, it returns true.
 * Otherwise, it returns false.
 *
 * @see {@link wTools.longLeftIndex} - See for more information.
 *
 * @param { Long } src - The source array.
 * @param  { Long|Primitive } ins - The elements to check in the source array.
 * @param { Function } evaluator1 - A callback function. Can be an equalizer or evaluator.
 * @param { Function } evaluator2 - A callback function. Uses only as second evaluator.
 *
 * @example
 * _.longHasAll( [ 5, 'str', 42, false ], 7 );
 * // returns false
 *
 * @example
 * _.longHasAny( [ 5, 'str', 42, false ], [ false, 5, 'str' ] );
 * // returns true
 *
 * @example
 * _.longHasAny( [ { a : 2 }, { a : 3 } 'var', 42, false ], [ { a : 2 }, { a : 3 } ] );
 * // returns false
 *
 * @example
 * var evaluator = ( e ) => e.a;
 * _.longHasAny( [ { a : 2 }, { a : 3 } 'str', 42, false ], [ { a : 2 }, { a : 3 } ], evaluator );
 * // returns true
 *
 * @example
 * var evaluator1 = ( eSrc ) => eSrc.a;
 * var evaluator2 = ( eIns ) => eIns.b;
 * _.longHasAny( [ { a : 2 }, { a : 3 } 'str', 42, false ], [ { b : 2 }, { b : 3 } ], evaluator1, evaluator2 );
 * // returns true
 *
 * @example
 * var equalizer = ( eSrc, eIns ) => eSrc.a === eIns.b;
 * _.longHasAny( [ { a : 2 }, { a : 3 } 'str', 42, false ], [ { b : 2 }, { b : 3 } ], equalizer );
 * // returns true
 *
 * @returns { Boolean } - Returns true, if {-src-} has all elements of {-ins-}, otherwise false is returned.
 * @function longHasAll
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-src-} is not a Long.
 * @throws { Error } If {-ins-} is not a Long, not a primitive.
 * @throws { Error } If {-evaluator1-} is not a routine.
 * @throws { Error } If {-evaluator1-} is an evaluator and accepts less or more than one argument.
 * @throws { Error } If {-evaluator1-} is an equalizer and accepts less or more than two argument.
 * @throws { Error } If {-evaluator2-} is not a routine.
 * @throws { Error } If {-evaluator2-} is an evaluator and accepts less or more than one argument.
 * @namespace Tools
 */

function longHasAll( /* src, ins, evaluator1, evaluator2 */ )
{
  let src = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );
  _.assert( _.longLike( src ), `Expects long, but got ${ _.entity.strType( src ) }` );
  _.assert( _.longLike( ins ) || _.primitive.is( ins ) );

  if( _.primitive.is( ins ) )
  ins = [ ins ];

  if( ins.length === 0 )
  return true;

  let i = 0;
  let result = 0;
  while( result >= 0 && i < ins.length )
  {
    result = _.longLeftIndex( src, ins[ i ], 0, evaluator1, evaluator2 );
    i++;
  }

  if( result !== -1 )
  return true;
  return false;
}

//

/**
 * The routine longHasNone() checks if the source long {-src-} has no one element of the long {-ins-}.
 * It can take equalizer or evaluators for the comparing elements.
 *
 * It iterates over source long {-src-} each element of the long {-ins-} by the routine
 * [longLeftIndex()]{@link wTools.longLeftIndex}
 * Checks, if {-src-} has no one elements of the {-ins-}.
 * If true, it returns true.
 * Otherwise, it returns false.
 *
 * @see {@link wTools.longLeftIndex} - See for more information.
 *
 * @param { Long } src - The source array.
 * @param  { Long|Primitive } ins - The elements to check in the source array.
 * @param { Function } evaluator1 - A callback function. Can be an equalizer or evaluator.
 * @param { Function } evaluator2 - A callback function. Uses only as second evaluator.
 *
 * @example
 * _.longHasNone( [ 5, 'str', 42, false ], 7 );
 * // returns true
 *
 * @example
 * _.longHasNone( [ 5, 'str', 42, false ], [ false, 5, 'str' ] );
 * // returns false
 *
 * @example
 * _.longHasNone( [ { a : 2 }, { a : 3 } 'var', 42, false ], [ { a : 2 }, { a : 3 } ] );
 * // returns true
 *
 * @example
 * var evaluator = ( e ) => e.a;
 * _.longHasNone( [ { a : 2 }, { a : 3 } 'str', 42, false ], [ { a : 2 }, { a : 4 } ], evaluator );
 * // returns false
 *
 * @example
 * var evaluator1 = ( eSrc ) => eSrc.a;
 * var evaluator2 = ( eIns ) => eIns.b;
 * _.longHasNone( [ { a : 2 }, { a : 3 } 'str', 42, false ], [ { b : 2 }, { b : 4 } ], evaluator1, evaluator2 );
 * // returns false
 *
 * @example
 * var equalizer = ( eSrc, eIns ) => eSrc.a === eIns.b;
 * _.longHasNone( [ { a : 2 }, { a : 3 } 'str', 42, false ], [ { b : 2 }, { b : 4 } ], equalizer );
 * // returns false
 *
 * @returns { Boolean } - Returns true, if {-src-} has no one element of {-ins-}, otherwise false is returned.
 * @function longHasAll
 * @throws { Error } If arguments.length is less then one or more then four.
 * @throws { Error } If {-src-} is not a Long.
 * @throws { Error } If {-ins-} is not a Long, not a primitive.
 * @throws { Error } If {-evaluator1-} is not a routine.
 * @throws { Error } If {-evaluator1-} is an evaluator and accepts less or more than one argument.
 * @throws { Error } If {-evaluator1-} is an equalizer and accepts less or more than two argument.
 * @throws { Error } If {-evaluator2-} is not a routine.
 * @throws { Error } If {-evaluator2-} is an evaluator and accepts less or more than one argument.
 * @namespace Tools
 */

function longHasNone( /* src, ins, evaluator1, evaluator2 */ )
{
  let src = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  _.assert( 1 <= arguments.length && arguments.length <= 4 );
  _.assert( _.longLike( src ), `Expects long, but got ${ _.entity.strType( src ) }` );
  _.assert( _.longLike( ins ) || _.primitive.is( ins ) );

  if( _.primitive.is( ins ) )
  ins = [ ins ];

  let i = 0;
  let result;

  do
  {
    result = _.longLeftIndex( src, ins[ i ], 0, evaluator1, evaluator2 );
    i++;
  }
  while( result < 0 && i < ins.length )

  if( result !== -1 )
  return false;
  return true;
}

//

/* aaa : cover please | Dmytro : covered */

function longHasDepth( arr, level = 1 )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.intIs( level ) );

  if( !_.longLike( arr ) )
  return false;

  if( level <= 0 )
  return true;

  for( let a = 0 ; a < arr.length ; a += 1 )
  if( _.longLike( arr[ a ] ) )
  {
    if( _.longHasDepth( arr[ a ], level - 1 ) )
    return true;
  }

  return false;
}

//

function longAll( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longLike( src ) );

  for( let s = 0 ; s < src.length ; s += 1 )
  {
    if( !src[ s ] )
    return false;
  }

  return true;
}

//

function longAny( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longLike( src ) );

  for( let s = 0 ; s < src.length ; s += 1 )
  if( src[ s ] )
  return true;

  return false;
}

//

function longNone( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longLike( src ) );

  for( let s = 0 ; s < src.length ; s += 1 )
  if( src[ s ] )
  return false;

  return true;
}

// --
// long sequential search
// --

/**
 * The routine longCountElement() returns the count of matched elements {-element-} in the {-srcArray-} array.
 * Returns 0 if no {-element-} is matched. It can take equalizer or evaluators to check specific equalities.
 *
 * @param { Long } srcArray - The source array.
 * @param { * } element - The value to count matches.
 * @param { Function } onEvaluate1 - It's a callback. If the routine has two parameters, it is used as an equalizer, and if it has only one, then routine used as the evaluator.
 * @param { Function } onEvaluate2 - The second part of evaluator. Accepts the value to search.
 *
 * @example
 * // simple exapmle, no matches
 * _.longCountElement( [ 1, 2, 'str', 10, 10, true ], 3 );
 * // returns 0
 *
 * @example
 * // simple exapmle
 * _.longCountElement( [ 1, 2, 'str', 10, 10, true ], 10 );
 * // returns 2
 *
 * @example
 * // with equalizer
 * _.longCountElement( [ 1, 2, 'str', 10, 10, true ], 10, ( a, b ) => _.typeOf( a ) === _.typeOf( b ) );
 * // returns 4
 *
 * @example
 * // with single evaluator
 * _.longCountElement( [ [ 10 ], [ 10 ], [ 'str' ], [ 10 ], [ false ] ], [ 'str' ], ( e ) => e[ 0 ] );
 * // returns 1
 *
 * @example
 * // with two part of evaluator
 * _.longCountElement( [ [ 10 ], [ 10 ], [ 'str' ], [ 10 ], [ false ] ], 10, ( e ) => e[ 0 ], ( e ) => e );
 * // returns 4
 *
 * @returns { Number } - Returns the count of matched elements {-element-} in the {-srcArray-}.
 * @function longCountElement
 * @throws { Error } If passed arguments is less than two or more than four.
 * @throws { Error } If the first argument is not a Long.
 * @throws { Error } If the third or fourth argument is not a routine.
 * @throws { Error } If the routine in third argument has less than one or more than two arguments.
 * @throws { Error } If the routine in third argument has two arguments and fourth argument is passed into routine longCountElement.
 * @throws { Error } If the routine in fourth argument has less than one or more than one arguments.
 * @namespace Tools
 */

/*
aaa : are all combinations of call of routine arrayCountElement covered? | Dmytro : yes, all combinations of call is implemented
*/

function longCountElement( /* srcArray, element, onEvaluate1, onEvaluate2 */ )
{
  let srcArray = arguments[ 0 ];
  let element = arguments[ 1 ];
  let onEvaluate1 = arguments[ 2 ];
  let onEvaluate2 = arguments[ 3 ];

  let result = 0;

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.longLike( srcArray ), 'Expects long' );

  let left = _.longLeftIndex( srcArray, element, onEvaluate1, onEvaluate2 );
  // let index = srcArray.indexOf( element );

  while( left >= 0 )
  {
    result += 1;
    left = _.longLeftIndex( srcArray, element, left+1, onEvaluate1, onEvaluate2 );
    // index = srcArray.indexOf( element, index+1 );
  }

  return result;
}

//

/**
 * The routine longCountTotal() adds all the elements in {-srcArray-}, elements can be numbers or booleans ( it considers them 0 or 1 ).
 *
 * @param { Array } srcArray - The source array.
 *
 * @example
 * _.longCountTotal( [ 1, 2, 10, 10 ] );
 * // returns 23
 *
 * @example
 * _.longCountTotal( [ true, false, false ] );
 * // returns 1
 *
 * @returns { Number } - Returns the sum of the elements in {-srcArray-}.
 * @function longCountTotal
 * @throws { Error } If passed arguments is different than one.
 * @throws { Error } If the first argument is not a Long.
 * @throws { Error } If {-srcArray-} doesn´t contain number-like elements.
 * @namespace Tools
 */

function longCountTotal( srcArray )
{
  let result = 0;

  _.assert( arguments.length === 1 );
  _.assert( _.longLike( srcArray ), 'Expects long' );

  for( let i = 0 ; i < srcArray.length ; i++ )
  {
    _.assert( _.bool.is( srcArray[ i ] ) || _.number.is( srcArray[ i ] ) || srcArray[ i ] === null );
    result += srcArray[ i ];
  }

  return result;
}

//

/**
 * The longCountUnique() routine returns the count of matched pairs ([ 1, 1, 2, 2, ., . ]) in the array {-srcMap-}.
 *
 * @param { longLike } src - The source array.
 * @param { Function } [ onEvaluate = function( e ) { return e } ] - A callback function.
 *
 * @example
 * _.longCountUnique( [ 1, 1, 2, 'abc', 'abc', 4, true, true ] );
 * // returns 3
 *
 * @example
 * _.longCountUnique( [ 1, 2, 3, 4, 5 ] );
 * // returns 0
 *
 * @returns { Number } - Returns the count of matched pairs ([ 1, 1, 2, 2, ., . ]) in the array {-srcMap-}.
 * @function longCountUnique
 * @throws { Error } If passed arguments is less than one or more than two.
 * @throws { Error } If the first argument is not an array-like object.
 * @throws { Error } If the second argument is not a Function.
 * @namespace Tools
 */

function longCountUnique( src, onEvaluate )
{
  let found = [];
  onEvaluate = onEvaluate || function( e ){ return e };

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.longLike( src ), 'longCountUnique :', 'Expects ArrayLike' );
  _.assert( _.routine.is( onEvaluate ) );
  _.assert( onEvaluate.length === 1 );

  for( let i1 = 0 ; i1 < src.length ; i1++ )
  {
    let element1 = onEvaluate( src[ i1 ] );
    if( found.indexOf( element1 ) !== -1 )
    continue;

    for( let i2 = i1+1 ; i2 < src.length ; i2++ )
    {

      let element2 = onEvaluate( src[ i2 ] );
      if( found.indexOf( element2 ) !== -1 )
      continue;

      if( element1 === element2 )
      found.push( element1 );

    }

  }

  return found.length;
}

// --
// extension
// --

let Extension =
{

  _longMake_functor,

  // longMake,
  // longMakeEmpty,
  // _longMakeOfLength,
  // longMakeUndefined,
  // longMakeZeroed, /* xxx : review */
  // longMakeFilling,
  /* qqq : check routine longMakeFilling, and add perfect coverage */
  /* qqq : implement routine arrayMakeFilling, and add perfect coverage */

  longFrom, /* aaa2 : cover please | Dmytro : covered */
  longFromCoercing, /* aaa2 : cover please | Dmytro : covered */

  longFill, /* !!! */
  longFill_,
  longDuplicate,

  _longClone,
  _longShallow,
  longSlice : _longShallow,
  longRepresent, /* qqq2 : review. ask */
  longJoin, /* qqq for Dmytro : look, analyze and cover _.buferJoin */
  longEmpty,

  // longBut,
  // longButInplace, /* !!! : use instead of longBut, longButInplace */ /* Dmytro : the coverage of the alternative covers inplace and not inplace versions */
  longBut_,
  // longOnly,
  // longOnlyInplace, /* !!! : use instead of longOnly, longOnlyInplace */ /* Dmytro : the coverage of the alternative covers inplace and not inplace versions */
  longOnly_,
  // longGrow,
  // longGrowInplace, /* !!! : use instead of longGrow, longGrowInplace */ /* Dmytro : the coverage of the alternative covers inplace and not inplace versions */
  longGrow_,
  // longRelength,
  // longRelengthInplace, /* !!! : use instead of longRelength, longRelengthInplace */ /* Dmytro : the coverage of the alternative covers inplace and not inplace versions */
  longRelength_,

  // array checker

  // longCompare,

  // long.identicalShallow,
  // _long.identicalShallow,
  // long.identical : long.identicalShallow,
  // longEquivalentShallow : long.identicalShallow,

  longHas,
  longHasAny,
  longHasAll,
  longHasNone,
  longHasDepth,

  longAll,
  longAny,
  longNone,

  // long sequential search

  longCountElement,
  longCountTotal,
  longCountUnique,

  // to replace

  /*
  | routine          | makes new dst container                  | saves dst container                                     |
  | ---------------- | ---------------------------------------- | ------------------------------------------------------- |
  | longBut_         | _.longBut_( null, src, range )           | _.longBut_( src )                                       |
  |                  | _.longBut_( dst, src, range )            | _.longBut_( src, range )                                |
  |                  | if dst not resizable and change length   | _.longBut_( dst, dst )                                  |
  |                  |                                          | _.longBut_( dst, dst, range ) if dst is resizable       |
  |                  |                                          | or dst not change length                                |
  |                  |                                          | _.longBut_( dst, src, range ) if dst is resizable       |
  |                  |                                          | or dst not change length                                |
  | ---------------  | ---------------------------------------- | ------------------------------------------------------  |
  | longOnly_      | _.longOnly_( null, src, range )        | _.longOnly_( src )                                    |
  |                  | _.longOnly_( dst, src, range )         | _.longOnly_( src, range )                             |
  |                  | if dst not resizable and change length   | _.longOnly_( dst, dst )                               |
  |                  |                                          | _.longOnly_( dst, dst, range ) if dst is resizable    |
  |                  |                                          | or dst not change length                                |
  |                  |                                          | _.longOnly_( dst, src, range ) if dst is resizable    |
  |                  |                                          | or dst not change length                                |
  | ---------------  | ---------------------------------------- | ------------------------------------------------------  |
  | longGrow_        | _.longGrow_( null, src, range )          | _.longGrow_( src )                                      |
  |                  | _.longGrow_( dst, src, range )           | _.longGrow_( src, range )                               |
  |                  | if dst not resizable and change length   | _.longGrow_( dst, dst )                                 |
  |                  | qqq2 : should throw error                | _.longGrow_( dst, dst, range ) if dst is resizable      |
  |                  |  if not resizable                        | or dst not change length                                |
  |                  |                                          | _.longGrow_( dst, src, range ) if dst is resizable      |
  |                  |                                          | or dst not change length                                |
  | ---------------  | ---------------------------------------- | ------------------------------------------------------  |
  | longRelength_    | _.longRelength_( null, src, range )      | _.longRelength_( src )                                  |
  |                  | _.longRelength_( dst, src, range )       | _.longRelength_( src, range )                           |
  |                  | if dst not resizable and change length   | _.longRelength_( dst, dst )                             |
  |                  |                                          | _.longRelength_( dst, dst, range ) if dst is resizable  |
  |                  |                                          | or dst not change length                                |
  |                  |                                          | _.longRelength_( dst, src, range ) if dst is resizable  |
  |                  |                                          | or dst not change length                                |
  | ---------------  | ---------------------------------------- | ------------------------------------------------------- |
  */

}

_.props.supplement( _, Extension );

})();

( function _l1_Numbers_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// number
// --

function _identicalShallow( a, b )
{

  if( _.number.s.areAll( [ a, b ] ) )
  return Object.is( a, b ) || a === b;

  return false;
}

//

function identicalShallow( src1, src2, o )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( !this.is( src1 ) )
  return false;
  if( !this.is( src2 ) )
  return false;

  return this._identicalShallow( ... arguments );
}

//

function _identicalShallowStrictly( a, b )
{
  /*
  it takes into account -0 === +0 case
  */

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.number.s.areAll( [ a, b ] ) )
  return Object.is( a, b );

  return false;
}

//

function identicalShallowStrictly( src1, src2, o )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( !this.is( src1 ) )
  return false;
  if( !this.is( src2 ) )
  return false;

  return this._identicalShallowStrictly( ... arguments );
}

//

// function _equivalentShallow( a, b, accuracy )
// {
//
//   if( accuracy !== undefined )
//   _.assert( _.number.is( accuracy ) && accuracy >= 0, 'Accuracy has to be a number >= 0' );
//
//   /* qqq for junior : bad! */
//
//   if( _.number.is( a ) && _.number.is( b ) )
//   {
//     if( Object.is( a, b ) )
//     return true;
//   }
//
//   if( !_.number.is( a ) && !_.bigInt.is( a ) )
//   return false;
//
//   if( !_.number.is( b ) && !_.bigInt.is( b ) )
//   return false;
//
//   /* qqq for junior : cache results of *Is calls at the beginning of the routine */
//
//   // else
//   // {
//   //   return false;
//   // }
//
//   if( accuracy === undefined )
//   accuracy = _.accuracy;
//
//   if( _.bigInt.is( a ) )
//   {
//     if( _.intIs( b ) )
//     {
//       b = BigInt( b );
//     }
//     // else
//     // {
//     //   a = Number( a );
//     //   if( a === +Infinity || a === -Infinity )
//     //   return false;
//     // }
//   }
//
//   if( _.bigInt.is( b ) )
//   {
//     if( _.intIs( a ) )
//     {
//       a = BigInt( a );
//     }
//     // else
//     // {
//     //   b = Number( b );
//     //   if( b === +Infinity || b === -Infinity )
//     //   return false;
//     // }
//   }
//
//   if( Object.is( a, b ) )
//   return true;
//
//   if( _.bigInt.is( a ) && _.bigInt.is( b ) )
//   {
//     if( _.intIs( accuracy ) )
//     {
//       return BigIntMath.abs( a - b ) <= BigInt( accuracy );
//     }
//     else
//     {
//       let diff = BigIntMath.abs( a - b );
//       if( diff <= BigInt( Math.floor( accuracy ) ) )
//       return true;
//       if( diff > BigInt( Math.ceil( accuracy ) ) )
//       return false;
//       diff = Number( diff );
//       if( diff === Infinity || diff === -Infinity )
//       return false;
//       return Math.abs( diff ) <= accuracy;
//     }
//   }
//
//   // if( !_.number.is( a ) )
//   // return false;
//   //
//   // if( !_.number.is( b ) )
//   // return false;
//
//   return Math.abs( a - b ) <= accuracy;
//   // return +( Math.abs( a - b ) ).toFixed( 10 ) <= +( accuracy ).toFixed( 10 );
// }

//

/* xxx : qqq : refactor */
function _equivalentShallow( a, b, accuracy )
{
  let result;

  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );

  if( accuracy !== undefined )
  _.assert
  (
    ( _.number.is( accuracy ) || _.bigInt.is( accuracy ) ) && accuracy >= 0 && accuracy !== Infinity,
    'Accuracy has to be a finite Number >= 0'
  );

  let bigIntIsA = _.bigInt.is( a );
  let bigIntIsB = _.bigInt.is( b );
  let numberIsA = _.number.is( a );
  let numberIsB = _.number.is( b );

  if( !numberIsA && !bigIntIsA )
  return false;

  if( !numberIsB && !bigIntIsB )
  return false;

  if( numberIsA && numberIsB )
  {
    if( Object.is( a, b ) )
    return true;
  }

  /*
  Cases :
  a : BIF/BOF/FIB/FOB;
  b : BIF/BOF/FIB/FOB;
  accuracy : BIF/BOF/FIB/FOB;

  a       b            accuracy           implemented                covered

  BIF     BIF       BIF/BOF/FIB/FOB            +                       ++++
  BIF     BOF       BIF/BOF/FIB/FOB            +                       ++++
  BIF     FIB       BIF/BOF/FIB/FOB            +                       ++++
  BIF     FOB       BIF/BOF/FIB/FOB            +                       ++++

  BOF     BOF       BIF/BOF/FIB/FOB            +                       ++++
  BOF     FIB       BIF/BOF/FIB/FOB            +                       ++++
  BOF     FOB       BIF/BOF/FIB/FOB            +                       ++++

  FIB     FIB       BIF/BOF/FIB/FOB            +                       ++++
  FIB     FOB       BIF/BOF/FIB/FOB            +                       ++++

  FOB     FOB       BIF/BOF/FIB/FOB            +                       ++++

  Definitions :
  BIF = bigint inside range of float ( 0n, 3n, BigInt( Math.pow( 2, 52 ) ) )
  BOF = bigint outside range of float ( BigInt( Math.pow( 2, 54 ) ) )
  FIB = float inside range of bigint ( 5, 30 )
  FOB = float outside range of bigint ( 5.5, 30.1 )

  */

  if( accuracy === undefined )
  accuracy = _.accuracy;

  if( bigIntIsA && bigIntIsB ) /* a : BIF/BOF, b : BIF/BOF , accuracy : BIF/BOF/FIB/FOB  3 */
  {
    return abs( a - b ) <= accuracy;
  }

  if( bigIntIsA ) /* a : BIF/BOF, b : FIB/FOB , accuracy : BIF/BOF/FIB/FOB 4 */
  [ a, b, result ] = bigintCompare( a, b );
  if( result !== undefined )
  return result;

  // {
  //   if( _.intIs( b ) )
  //   {
  //     b = BigInt( b );
  //   }
  //   else
  //   {
  //     if( a >= Number.MIN_SAFE_INTEGER && a <= Number.MAX_SAFE_INTEGER ) /* a : BIF, b : FOB, accuracy : BIF/BOF/FIB/FOB */
  //     {
  //       a = Number( a );
  //     }
  //     else /* a : BOF, b : FOB, accuracy : BIF/BOF/FIB/FOB */
  //     {
  //       if( accuracy >= Number.MIN_SAFE_INTEGER && accuracy <= Number.MAX_SAFE_INTEGER ) /* a : BOF, b : FOB, accuracy : FIB/FOB */
  //       {
  //         let decimal = b % 1;
  //         b = BigInt( Math.floor( b ) )
  //         return abs( a - b ) <= accuracy + decimal;
  //       }
  //       else /* a : BOF, b : FOB, accuracy : BIF/BOF */
  //       {
  //         b = BigInt( Math.round( b ) );
  //       }
  //     }
  //   }
  // }

  if( bigIntIsB ) /* a : FIB/FOB, b : BIF/BOF , accuracy : BIF/BOF/FIB/FOB */
  [ b, a, result ] = bigintCompare( b, a );
  if( result !== undefined )
  return result;

  // {
  //   if( _.intIs( a ) ) /* a : FIB, b : BIF/BOF, accuracy : BIF/BOF/FIB/FOB */
  //   {
  //     a = BigInt( a );
  //   }
  //   else
  //   {
  //     if( b >= Number.MIN_SAFE_INTEGER && b <= Number.MAX_SAFE_INTEGER ) /* a : FOB, b : BIF, accuracy : BIF/BOF/FIB/FOB */
  //     {
  //       b = Number( b );
  //     }
  //     else /* a : FOB, b : BOF , accuracy : BIF/BOF/FIB/FOB */
  //     {
  //       if( accuracy >= Number.MIN_SAFE_INTEGER && accuracy <= Number.MAX_SAFE_INTEGER ) /* a : FOB, b : BOF, accuracy : FIB/FOB */
  //       {
  //         let decimal = a % 1;
  //         a = BigInt( Math.floor( a ) )
  //         return abs( a - b ) <= accuracy + decimal;
  //       }
  //       else /* a : FOB, b : BOF, accuracy : BIF/BOF */
  //       {
  //         a = BigInt( Math.round( a ) );
  //       }
  //     }
  //   }
  // }

  if( numberIsA && numberIsB ) /* a : FIB/FOB, b : FIB/FOB, accuracy : BIF/BOF/FIB/FOB 3 */
  return Math.abs( a - b ) <= accuracy;
  else
  return abs( a - b ) <= accuracy;

  /* - */

  function bigintCompare( a, b )
  {
    if( _.intIs( b ) )
    {
      b = BigInt( b );
    }
    else
    {
      if( a >= Number.MIN_SAFE_INTEGER && a <= Number.MAX_SAFE_INTEGER ) /* a : BIF, b : FOB, accuracy : BIF/BOF/FIB/FOB */
      {
        a = Number( a );
      }
      else /* a : BOF, b : FOB, accuracy : BIF/BOF/FIB/FOB */
      {
        if( accuracy >= Number.MIN_SAFE_INTEGER && accuracy <= Number.MAX_SAFE_INTEGER ) /* a : BOF, b : FOB, accuracy : FIB/FOB */
        {
          let decimal = b % 1;
          b = BigInt( Math.floor( b ) )
          return [ a, b, abs( a - b ) <= accuracy + decimal ];
        }
        else /* a : BOF, b : FOB, accuracy : BIF/BOF */
        {
          b = BigInt( Math.round( b ) );
        }
      }
    }
    return [ a, b, undefined ];
  }

  /* - */

  function sign( value )
  {
    if( value > BigInt( 0 ) )
    return BigInt( 1 );
    if( value < BigInt( 0 ) )
    return BigInt( -1 );

    return BigInt( 0 );
  }

  /* - */

  function abs( value )
  {
    if( sign( value ) === BigInt( -1 ) )
    return -value;
    return value;
  }

  /* - */

}

//

function equivalentShallow( src1, src2, accuracy )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !this.like( src1 ) )
  return false;
  if( !this.like( src2 ) )
  return false;
  return this._equivalentShallow( ... arguments );
}

// --
// extension
// --

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

//

let NumberExtension =
{

  // equaler

  _identicalShallow,
  identicalShallow,
  identical : identicalShallow,

  _identicalShallowStrictly,
  identicalShallowStrictly,
  identicalStrictly : identicalShallowStrictly,

  _equivalentShallow,
  equivalentShallow,
  equivalent : equivalentShallow,

  // areEquivalentShallow : areEquivalent,
  // areIdentical,
  // areIdenticalNotStrictly,
  // areEquivalent,

}

Object.assign( _.number, NumberExtension );

//

let NumbersExtension =
{
}

Object.assign( _.number.s, NumbersExtension );

})();


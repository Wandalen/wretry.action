( function _l5_Intervalc_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// dichotomy
// --

function isEmpty( cinterval )
{
  _.assert( arguments.length === 1 );
  if( !_.intervalIs( cinterval ) )
  return false;
  return cinterval[ 0 ] === cinterval[ 1 ] + 1;
}

//

function isPopulated( cinterval )
{
  _.assert( arguments.length === 1 );
  if( !_.intervalIs( cinterval ) )
  return false;
  return cinterval[ 0 ] !== cinterval[ 1 ] + 1;
}

//

function has( cinterval, src )
{

  // if( _.longIs( src ) )
  // src = src.length;

  _.assert( arguments.length === 2 );
  _.assert( _.intervalIs( cinterval ) );
  // _.assert( _.number.is( src ) || _.intervalIs( src ) );

  if( _.intervalIs( src ) )
  {
    if( src[ 0 ] < cinterval[ 0 ] )
    return false;
    if( src[ 1 ] > cinterval[ 1 ] )
    return false;
  }
  else if( _.number.is( src ) )
  {
    if( src < cinterval[ 0 ] )
    return false;
    if( src > cinterval[ 1 ] )
    return false;
  }
  else
  {
    _.assert( 0, 'Expects number or interval {-src-}.' );
  }

  return true;
}

//

// function inInclusive( cinterval, srcNumber )
// {
//
//   if( _.longIs( srcNumber ) )
//   srcNumber = srcNumber.length;
//
//   _.assert( arguments.length === 2 );
//   _.assert( _.intervalIs( cinterval ) );
//   _.assert( _.number.is( srcNumber ) );
//
//   if( srcNumber < cinterval[ 0 ] )
//   return false;
//   if( srcNumber >= cinterval[ 1 ] + 1 )
//   return false;
//
//   return true;
// }
//
// //
//
// function inExclusive( cinterval, srcNumber )
// {
//   if( _.longIs( srcNumber ) )
//   srcNumber = srcNumber.length;
//
//   _.assert( arguments.length === 2 );
//   _.assert( _.intervalIs( cinterval ) );
//   _.assert( _.number.is( srcNumber ) );
//
//   if( srcNumber <= cinterval[ 0 ] )
//   return false;
//   if( srcNumber > cinterval[ 1 ] + 1 )
//   return false;
//
//   return true;
// }
//
// //
//
// function inInclusiveLeft( cinterval, srcNumber )
// {
//   if( _.longIs( srcNumber ) )
//   srcNumber = srcNumber.length;
//
//   _.assert( arguments.length === 2 );
//   _.assert( _.intervalIs( cinterval ) );
//   _.assert( _.number.is( srcNumber ) );
//
//   if( srcNumber < cinterval[ 0 ] )
//   return false;
//   if( srcNumber >= cinterval[ 1 ] + 1 )
//   return false;
//
//   return true;
// }
//
// //
//
// function inInclusiveRight( cinterval, srcNumber )
// {
//   if( _.longIs( srcNumber ) )
//   srcNumber = srcNumber.length;
//
//   _.assert( arguments.length === 2 );
//   _.assert( _.intervalIs( cinterval ) );
//   _.assert( _.number.is( srcNumber ) );
//
//   if( srcNumber < cinterval[ 0 ] )
//   return false;
//   if( srcNumber >= cinterval[ 1 ] + 1 )
//   return false;
//
//   return true;
// }

//

function sureIn( src, cinterval )
{
  _.assert( arguments.length >= 2 );
  if( _.longIs( src ) )
  src = src.length;
  // let args = _.unroll.from
  // ([
  //   _.cinterval.has( cinterval, src ),
  //   () => 'Out of cinterval' + _.rangeToStr( cinterval ), _.unrollSelect( arguments, 2 )
  // ]);
  // debugger
  let args =
  [
    _.cinterval.has( cinterval, src )
    ,() => 'Out of cinterval' + _.rangeToStr( cinterval )
    , Array.prototype.slice.call( arguments, 2 )
  ];
  _.sure.apply( _, args );
  return true;
}

//

function assertIn( src, cinterval )
{
  _.assert( arguments.length >= 2 );
  if( _.longIs( src ) )
  src = src.length;
  let args =
  [
    _.cinterval.has( cinterval, src )
    ,() => 'Out of cinterval' + _.rangeToStr( cinterval )
    , Array.prototype.slice.call( arguments, 2 )
  ];
  // let args = _.unroll.from
  // ([
  //   _.cinterval.has( cinterval, src ),
  //   () => 'Out of cinterval' + _.rangeToStr( cinterval ), _.unrollSelect( arguments, 2 )
  // ]);
  _.assert.apply( _, args );
  return true;
}

// --
// maker
// --

function fromLeft( cinterval )
{
  _.assert( arguments.length === 1 );

  if( _.number.is( cinterval ) )
  return [ cinterval, Infinity ];

  _.assert( _.longIs( cinterval ) );

  if( cinterval.length === 1 )
  cinterval = [ cinterval[ 0 ], Infinity ];
  else
  _.assert( cinterval.length === 2 );

  if( !_.number.is( cinterval[ 0 ] ) )
  {
    _.assert( cinterval[ 0 ] === undefined );
    cinterval[ 0 ] = 0;
  }
  if( !_.number.is( cinterval[ 1 ] ) )
  {
    _.assert( cinterval[ 1 ] === undefined );
    cinterval[ 1 ] = Infinity;
  }

  return cinterval;
}

//

function fromRight( cinterval )
{
  _.assert( arguments.length === 1 );

  if( _.number.is( cinterval ) )
  return [ 0, cinterval ];

  _.assert( _.longIs( cinterval ) );

  if( cinterval.length === 1 )
  cinterval = [ cinterval[ 0 ], Infinity ];
  else
  _.assert( cinterval.length === 2 );

  if( !_.number.is( cinterval[ 0 ] ) )
  {
    _.assert( cinterval[ 0 ] === undefined );
    cinterval[ 0 ] = 0;
  }
  if( !_.number.is( cinterval[ 1 ] ) )
  {
    _.assert( cinterval[ 1 ] === undefined );
    cinterval[ 1 ] = Infinity;
  }

  return cinterval;
}

//

function fromSingle( cinterval )
{
  _.assert( arguments.length === 1 );

  if( _.number.is( cinterval ) )
  return [ cinterval, cinterval ];

  _.assert( _.longIs( cinterval ) );
  _.assert( cinterval.length === 1 || cinterval.length === 2 );

  if( cinterval[ 0 ] === undefined )
  {
    if( cinterval[ 1 ] === undefined )
    return [ 0, 0 ];

    _.assert( _.number.is( cinterval[ 1 ] ) );
    return [ cinterval[ 1 ], cinterval[ 1 ] ];
  }

  _.assert( _.number.is( cinterval[ 0 ] ) );

  if( cinterval[ 1 ] === undefined )
  return [ cinterval[ 0 ], cinterval[ 0 ] ];

  _.assert( _.number.is( cinterval[ 1 ] ) );

  return cinterval;
}

//

function clamp( dstRange, clampRange )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.intervalIs( dstRange ) );

  if( _.number.is( clampRange ) )
  {
    dstRange[ 0 ] = clampRange;
    dstRange[ 1 ] = clampRange;
  }
  else
  {
    _.assert( _.intervalIs( clampRange ) );

    if( dstRange[ 0 ] < clampRange[ 0 ] )
    dstRange[ 0 ] = clampRange[ 0 ];
    else if( dstRange[ 0 ] > clampRange[ 1 ] )
    dstRange[ 0 ] = clampRange[ 1 ];

    if( dstRange[ 1 ] < clampRange[ 0 ] )
    dstRange[ 1 ] = clampRange[ 0 ];
    else if( dstRange[ 1 ] > clampRange[ 1 ] )
    dstRange[ 1 ] = clampRange[ 1 ];
  }

  return dstRange;
}

//

function countElements( cinterval, increment )
{

  _.assert( _.intervalIs( cinterval ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( increment === undefined )
  increment = 1;

  _.assert( _.number.is( increment ), 'Increment should has a number value' );

  if( increment )
  {
    let result = ( cinterval[ 1 ] - cinterval[ 0 ] + 1 ) / increment;
    if( result > 0 )
    {
      if( result < 1 )
      return 1;
      return Math.floor( result );
    }
    else if( result < 0 )
    {
      if( result > -1 )
      return -1;
      return Math.ceil( result );
    }
  }

  return 0;
}

//

// function firstGet( cinterval, options )
function firstGet( cinterval )
{

  _.assert( arguments.length === 1 );

  // _.assert( arguments.length === 1 || arguments.length === 2 );
  // if( options )
  // {
  //   _.assert( _.aux.is( options ) );
  //   if( options.increment === undefined )
  //   options.increment = 1;
  // }

  if( _.longIs( cinterval ) )
  {
    _.assert( _.intervalIs( cinterval ) );
    return cinterval[ 0 ];
  }
  else if( _.mapIs( cinterval ) ) /* xxx : remove? */
  {
    return cinterval.first;
  }
  _.assert( 0, 'unexpected type of cinterval', _.entity.strType( cinterval ) );
}

//

// function lastGet( cinterval, options )
function lastGet( cinterval )
{

  _.assert( arguments.length === 1 );

  // _.assert( arguments.length === 1 || arguments.length === 2 );
  // if( options )
  // {
  //   _.assert( _.object.like( options ) );
  //   if( options.increment === undefined )
  //   options.increment = 1;
  // }

  if( _.longIs( cinterval ) )
  {
    _.assert( _.intervalIs( cinterval ) );
    return cinterval[ 1 ];
  }
  else if( _.mapIs( cinterval ) )
  {
    return cinterval.last;
  }
  _.assert( 0, 'unexpected type of cinterval', _.entity.strType( cinterval ) );

}

//

function toStr( range )
{
  _.assert( _.intervalIs( range ) );
  _.assert( arguments.length === 1 );
  return range[ 0 ] + '..' + range[ 1 ];
}

// --
// define
// --

class Crange
{
  static[ Symbol.hasInstance ]( instance )
  {
    return is( instance );
  }
}

let Handler =
{
  construct( original, args )
  {
    return Crange.fromLeft( ... args );
  }
};

const Self = new Proxy( Crange, Handler );
Self.original = Crange;

// --
// implementation
// --

let Extension =
{

  // dichotomy

  is : _.intervalIs,
  isValid : _.intervalIsValid,
  defined : _.intervalIsValid,
  isEmpty,
  isPopulated,

  // inInclusive,
  // inExclusive,
  // inInclusiveLeft,
  // inInclusiveRight,
  // has : inInclusiveLeft,
  has,

  sureIn,
  assertIn,

  // maker

  fromLeft,
  fromRight,
  fromSingle,

  clamp,
  countElements,
  firstGet,
  lastGet,

  toStr,

}

//

_.props.supplement( Self, Extension );
_.assert( _.cinterval !== undefined );
_.props.supplement( Self, _.cinterval );
_.cinterval = Self;

})();

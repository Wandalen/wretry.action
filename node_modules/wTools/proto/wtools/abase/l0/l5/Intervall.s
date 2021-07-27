( function _l5_Intervall_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// dichotomy
// --

function isEmpty( linterval )
{
  _.assert( arguments.length === 1 );
  if( !_.intervalIs( linterval ) )
  return false;
  return linterval[ 1 ] === 0;
}

//

function isPopulated( linterval )
{
  _.assert( arguments.length === 1 );
  if( !_.intervalIs( linterval ) )
  return false;
  return linterval[ 1 ] !== 0;
}

//

function has( linterval, src )
{
  _.assert( arguments.length === 2 );
  _.assert( _.intervalIs( linterval ) );

  if( _.intervalIs( src ) )
  {
    if( src[ 0 ] < linterval[ 0 ] )
    return false;
    if( src[ 1 ] > linterval[ 1 ] )
    return false;
  }
  else if( _.number.is( src ) )
  {
    if( src < linterval[ 0 ] )
    return false;
    if( src > linterval[ 0 ] + linterval[ 1 ] )
    return false;
  }
  else
  {
    _.assert( 0, 'Expects interval or number {-src-}.' );
  }

  return true;
}

//

function sureIn( src, linterval )
{
  _.assert( arguments.length >= 2 );
  if( _.longIs( src ) )
  src = src.length;
  // let args = _.unroll.from([ _.linterval.has( linterval, src ), () => 'Out of linterval' + _.rangeToStr( linterval ), _.unrollSelect( arguments, 2 ) ]);
  // debugger;
  let args =
  [
    _.linterval.has( linterval, src )
    ,() => 'Out of linterval' + _.rangeToStr( linterval )
    , Array.prototype.slice.call( arguments, 2 )
  ];
  _.sure.apply( _, args );
  return true;
}

//

function assertIn( src, linterval )
{
  _.assert( arguments.length >= 2 );
  if( _.longIs( src ) )
  src = src.length;
  // let args = _.unroll.from([ _.linterval.has( linterval, src ), () => 'Out of linterval' + _.rangeToStr( linterval ), _.unrollSelect( arguments, 2 ) ]);
  // debugger;
  let args =
  [
    _.linterval.has( linterval, src )
    ,() => 'Out of linterval' + _.rangeToStr( linterval )
    , Array.prototype.slice.call( arguments, 2 )
  ];
  _.assert.apply( _, args );
  return true;
}

// --
// maker
// --

function fromSingle( linterval )
{
  _.assert( arguments.length === 1 );

  if( _.number.is( linterval ) )
  return [ linterval, 1 ];

  _.assert( _.longIs( linterval ) );
  _.assert( linterval.length === 1 || linterval.length === 2 );

  if( linterval[ 0 ] === undefined )
  {
    if( linterval[ 1 ] === undefined )
    return [ 0, 1 ];

    _.assert( linterval[ 1 ] === 1, 'Expects length of 1' );
    return [ 0, 1 ];
  }

  _.assert( _.number.is( linterval[ 0 ] ) );

  if( linterval[ 1 ] === undefined )
  return [ linterval[ 0 ], 1 ];

  _.assert( _.number.is( linterval[ 1 ] ) );

  return linterval;
}

//

function clamp( dstRange, clampRange )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.intervalIs( dstRange ) );

  if( _.number.is( clampRange ) )
  {
    dstRange[ 0 ] = clampRange;
    dstRange[ 1 ] = 0;
  }
  else
  {
    _.assert( _.intervalIs( clampRange ) );

    if( dstRange[ 0 ] < 0 )
    dstRange[ 0 ] = 0;
    else if( dstRange[ 0 ] > clampRange[ 0 ] )
    dstRange[ 0 ] = clampRange[ 0 ];

    if( dstRange[ 1 ] < 0 )
    dstRange[ 1 ] = 0;
    else if( dstRange[ 1 ] > clampRange[ 1 ] )
    dstRange[ 1 ] = clampRange[ 1 ];
  }

  return dstRange;
}

//

function countElements( linterval, increment )
{

  _.assert( _.intervalIs( linterval ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( increment === undefined )
  increment = 1;

  _.assert( _.number.is( increment ), 'Increment should has a number value' );

  if( increment )
  {
    let result = linterval[ 1 ] / increment;
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

function lastGet( linterval, options )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  // options = options || Object.create( null ); /* Dmytro : I don't know why routine makes this side effect */
  // if( options.increment === undefined )       /* The creating of new map has no sense, improved below */
  // options.increment = 1;

  if( options )
  {
    _.assert( _.object.like( options ) );
    if( options.increment === undefined )
    options.increment = 1;
  }

  if( _.longIs( linterval ) )
  {
    _.assert( _.intervalIs( linterval ) );
    return linterval[ 0 ] + linterval[ 1 ] - 1;
  }
  else if( _.mapIs( linterval ) )
  {
    return linterval.last;
  }
  _.assert( 0, 'unexpected type of linterval', _.entity.strType( linterval ) );

}

// --
// define
// --

class Lrange
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
    return Lrange.fromLeft( ... args );
  }
};

const Self = new Proxy( Lrange, Handler );
Self.original = Lrange;

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

  has,

  sureIn,
  assertIn,

  // maker

  fromLeft : _.cinterval.fromLeft,
  fromRight : _.cinterval.fromRight,
  fromSingle,

  clamp,
  countElements,
  firstGet : _.cinterval.firstGet,
  lastGet,

  toStr : _.cinterval.toStr,

}

//

_.props.supplement( Self, Extension );
_.assert( _.linterval !== undefined );
_.props.supplement( Self, _.linterval );
_.linterval = Self;

})();

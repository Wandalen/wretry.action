( function _l5_Intervalo_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// dichotomy
// --

function isEmpty( ointerval )
{
  _.assert( arguments.length === 1 );
  if( !_.intervalIs( ointerval ) )
  return false;
  return ointerval[ 0 ] === ointerval[ 1 ];
}

//

function isPopulated( ointerval )
{
  _.assert( arguments.length === 1 );
  if( !_.intervalIs( ointerval ) )
  return false;
  return ointerval[ 0 ] !== ointerval[ 1 ];
}

//

function has( ointerval, src )
{
  _.assert( arguments.length === 2 );
  _.assert( _.intervalIs( ointerval ) );

  if( _.intervalIs( src ) )
  {
    if( src[ 0 ] < ointerval[ 0 ] )
    return false;
    if( src[ 1 ] > ointerval[ 1 ] )
    return false;
  }
  else if( _.number.is( src ) )
  {
    if( src < ointerval[ 0 ] )
    return false;
    if( src >= ointerval[ 1 ] )
    return false;
  }
  else
  {
    _.assert( 0, 'Expects interval or number {-src-}.' );
  }

  return true;
}

//

function sureIn( src, ointerval )
{
  _.assert( arguments.length >= 2 );
  if( _.longIs( src ) )
  src = src.length;
  // let args = _.unroll.from([ _.ointerval.has( ointerval, src ), () => 'Out of ointerval' + _.rangeToStr( ointerval ), _.unrollSelect( arguments, 2 ) ]);
  // debugger;
  let args =
  [
    _.ointerval.has( ointerval, src )
    ,() => 'Out of ointerval' + _.rangeToStr( ointerval )
    , Array.prototype.slice.call( arguments, 2 )
  ];
  _.sure.apply( _, args );
  return true;
}

//

function assertIn( src, ointerval )
{
  _.assert( arguments.length >= 2 );
  if( _.longIs( src ) )
  src = src.length;
  // let args = _.unroll.from([ _.ointerval.has( ointerval, src ), () => 'Out of ointerval' + _.rangeToStr( ointerval ), _.unrollSelect( arguments, 2 ) ]);
  // debugger;
  let args =
  [
    _.ointerval.has( ointerval, src )
    ,() => 'Out of ointerval' + _.rangeToStr( ointerval )
    , Array.prototype.slice.call( arguments, 2 )
  ];
  _.assert.apply( _, args );
  return true;
}

// --
// maker
// --

function fromSingle( ointerval )
{
  _.assert( arguments.length === 1 );

  if( _.number.is( ointerval ) )
  return [ ointerval, ointerval + 1 ];

  _.assert( _.longIs( ointerval ) );
  _.assert( ointerval.length === 1 || ointerval.length === 2 );

  if( ointerval[ 0 ] === undefined )
  {
    if( ointerval[ 1 ] === undefined )
    return [ 0, 1 ];

    _.assert( _.number.is( ointerval[ 1 ] ) );
    return [ ointerval[ 1 ] - 1, ointerval[ 1 ] ];
  }

  _.assert( _.number.is( ointerval[ 0 ] ) );

  if( ointerval[ 1 ] === undefined )
  return [ ointerval[ 0 ], ointerval[ 0 ] + 1 ];

  _.assert( _.number.is( ointerval[ 1 ] ) );

  return ointerval;
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

function countElements( ointerval, increment )
{

  _.assert( _.intervalIs( ointerval ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( increment === undefined )
  increment = 1;

  _.assert( _.number.is( increment ), 'Increment should has a number value' );

  if( increment )
  {
    let result = ( ointerval[ 1 ] - ointerval[ 0 ] ) / increment;
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

function lastGet( ointerval, options )
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

  if( _.longIs( ointerval ) )
  {
    _.assert( _.intervalIs( ointerval ) );
    return ointerval[ 1 ] - 1;
  }
  else if( _.mapIs( ointerval ) )
  {
    return ointerval.last;
  }
  _.assert( 0, 'unexpected type of ointerval', _.entity.strType( ointerval ) );

}

// --
// define
// --

class Orange
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
    return Orange.fromLeft( ... args );
  }
};

const Self = new Proxy( Orange, Handler );
Self.original = Orange;

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
_.assert( _.ointerval !== undefined );
_.props.supplement( Self, _.ointerval );
_.ointerval = Self;
// _.assert( _.auxIs( _.ointerval ) ); /* xxx : uncomment? */

/* xxx : qqq : for Dmytro : bad : [ 1, 3 ] instanceof _.ointerval is not covered and does not work! */

})();

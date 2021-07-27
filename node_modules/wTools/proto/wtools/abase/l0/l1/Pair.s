( function _l1_Pair_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// range
// --

function is( src )
{
  if( !_.longIs( src ) )
  return false;
  if( src.length !== 2 )
  return false;
  return true;
}

//

function make( src )
{
  let result;
  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  if( arguments.length === 2 )
  {
    result = new Array( ... arguments );
  }
  else if( arguments.length === 1 )
  {
    if( _.routine.is( src ) )
    {
      if( src === Array )
      result = new src( undefined, undefined );
      else
      result = new src( 2 );
    }
    else if( arguments[ 0 ].length === 2 )
    result = _.entity.cloneShallow( arguments[ 0 ] );
    else if( arguments[ 0 ].length === 0 )
    result = _.entity.makeUndefined( arguments[ 0 ], 2 );
    else
    throw _.err( 'Length of pair should be 2' );
  }
  else if( arguments.length === 0 )
  {
    result = new Array( undefined, undefined );
  }
  else
  {
    _.assert( 0, `Expects 0..2 arguments, but got ${arguments.length}` );
  }
  _.assert( this.is( result ), 'Faild to make a new Pair' );
  return result;
}

// --
// define
// --

class Pair
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
    return Pair.make( ... args );
  }
};

const Self = new Proxy( Pair, Handler );
Self.original = Pair;

//

var Extension =
{
  is,
  make,
}

//

Object.assign( Self, Extension );
_.assert( _.pair === undefined );
_.pair = Self;

})();

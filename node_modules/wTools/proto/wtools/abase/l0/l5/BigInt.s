( function _l5_BigInt_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function from( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  if( _.strIs( src ) )
  return BigInt( src );
  if( _.number.is( src ) )
  return BigInt( src );
  _.assert( _.bigInt.is( src ), 'Cant convert' )
  return src;
}

//

function bigIntsFrom( src )
{
  if( _.number.is( src ) )
  {
    return BigInt( src );
  }
  else if( _.bigInt.is( src ) )
  {
    return src;
  }
  else if( _.longIs( src ) )
  {
    let result = [];
    for( let i = 0 ; i < src.length ; i++ )
    result[ i ] = _.bigInt.from( src[ i ] );
    return result
  }
  else _.assert( 0, 'Cant convert' );
}

// --
// bigInt extension
// --

let BigIntExtension =
{
  from,
}

Object.assign( _.bigInt, BigIntExtension );

// --
// bigInts extension
// --

let BigIntsExtension =
{
  from : bigIntsFrom
}

Object.assign( _.bigInts, BigIntsExtension );

// --
// tools extension
// --

let ToolsExtension =
{
  bigIntFrom : from,
  bigIntsFrom,
}

Object.assign( _, ToolsExtension );

//

})();

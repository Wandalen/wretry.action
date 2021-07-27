( function _l7_Number_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// number
// --

function numbersTotal( numbers )
{
  let result = 0;
  _.assert( _.longIs( numbers ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  for( let n = 0 ; n < numbers.length ; n++ )
  {
    let number = numbers[ n ];
    _.assert( _.number.is( number ) )
    result += number;
  }
  return result;
}

//

function from( src )
{
  _.assert( arguments.length === 1 );
  if( _.strIs( src ) )
  {
    return parseFloat( src );
  }
  return Number( src );
}

//

function numbersFrom( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.strIs( src ) )
  return _.number.from( src );

  if( _.number.is( src ) )
  return src;

  let result;

  if( _.longIs( src ) )
  {
    result = [];
    for( let s = 0 ; s < src.length ; s++ )
    result[ s ] = _.number.from( src[ s ] );
  }
  else if( _.object.isBasic( src ) )
  {
    result = Object.create( null );
    for( let s in src )
    result[ s ] = _.number.from( src[ s ] );
  }
  else
  {
    result = _.number.from( src );
  }

  return result;
}

//

function fromStr( src )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( src ) )
  let result = parseFloat( src );
  return result;
}

//

// function numberFromStrMaybe( src )
function fromStrMaybe( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) || _.number.is( src ) );

  if( _.number.is( src ) )
  return src;
  if( !src ) /* qqq : cover */
  return src;

  // let parsed = !src ? NaN : Number( src ); /* Dmytro : it is strange code, the previous branch checks this condition */
  // if( !isNaN( parsed ) )
  // return parsed;
  // return src;

  let parsed = src ? Number( src ) : NaN;
  if( !isNaN( parsed ) )
  return parsed;
  return src;
}

//

function numbersSlice( src, f, l )
{
  if( _.argumentsArray.like( src ) )
  _.assert( _.number.s.areAll( src ) )

  if( _.number.is( src ) )
  return src;
  return _.longSlice( src, f, l );
}

//

/**
 * The routine numberRandom() returns a random float number, the value of which is within a
 * range {-range-} .
 *
 * @param { Range|Number } range - The range for generating random numbers.
 * If {-range-} is number, routine generates random number from zero to provided value.
 *
 * @example
 * let got = _.number.random( 0 );
 * // returns random number in range [ 0, 0 ]
 * console.log( got );
 * // log 0
 *
 * @example
 * let got = _.number.random( 3 );
 * // returns random number in range [ 0, 3 ]
 * console.log( got );
 * // log 0.10161347203073712
 *
 * @example
 * let got = _.number.random( -3 );
 * // returns random number in range [ -3, 0 ]
 * console.log( got );
 * // log -1.4184648844870276
 *
 * @example
 * let got = _.number.random( [ 3, 3 ] );
 * console.log( got );
 * // log 3
 *
 * @example
 * let got = _.number.random( [ -3, 0 ] );
 * console.log( got );
 * // log -1.5699334307486583
 *
 * @example
 * let got = _.number.random( [ 0, 3 ] );
 * console.log( got );
 * // log 0.6154656826553855
 *
 * @example
 * let got = _.number.random( [ -3, 3 ] );
 * console.log( got );
 * // log 1.9835540787557022
 *
 * @returns { Number } - Returns a random float number.
 * @function numberRandom
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If range {-range-} is not a Number or not a Range.
 * @namespace Tools
 */

function random( range )
{

  if( _.number.is( range ) )
  range = range >= 0 ? [ 0, range ] : [ range, 0 ];
  _.assert( arguments.length === 1 && _.intervalIs( range ), 'Expects range' );

  let result = Math.random()*( range[ 1 ] - range[ 0 ] ) + range[ 0 ];
  return result;
}

//

/**
 * The routine intRandom() returns a random integer number, the value of which is within a
 * range {-range-} .
 *
 * @param { Range|Number } range - The range for generating random numbers.
 * If {-range-} is number, routine generates random number from zero to provided value.
 *
 * @example
 * let got = _.intRandom( 0 );
 * // returns random number in range [ 0, 0 ]
 * console.log( got );
 * // log 0
 *
 * @example
 * let got = _.intRandom( 1 );
 * // returns random number in range [ 0, 1 ]
 * console.log( got );
 * // log 1
 *
 * @example
 * let got = _.intRandom( 3 );
 * // returns random number in range [ 0, 3 ]
 * console.log( got );
 * // log 1
 *
 * @example
 * let got = _.intRandom( -3 );
 * // returns random number in range [ -3, 0 ]
 * console.log( got );
 * // log -2
 *
 * @example
 * let got = _.intRandom( [ 3, 3 ] );
 * console.log( got );
 * // log 3
 *
 * @example
 * let got = _.intRandom( [ -3, 0 ] );
 * console.log( got );
 * // log -1
 *
 * @example
 * let got = _.intRandom( [ 0, 3 ] );
 * console.log( got );
 * // log 1
 *
 * @example
 * let got = _.intRandom( [ -3, 3 ] );
 * console.log( got );
 * // log -2
 *
 * @returns { Number } - Returns a random integer number.
 * @function intRandom
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If range {-range-} is not a Number or not a Range.
 * @namespace Tools
 */

function intRandom( range )
{

  if( _.number.is( range ) )
  range = range >= 0 ? [ 0, range ] : [ range, 0 ];
  _.assert( arguments.length === 1 && _.intervalIs( range ), 'Expects range' );

  let result = Math.floor( range[ 0 ] + Math.random()*( range[ 1 ] - range[ 0 ] ) );
  return result;
}

//

function intRandomBut( range )
{
  let result;
  let attempts = 50;

  if( _.number.is( range ) )
  range = [ 0, range ];
  else if( _.arrayIs( range ) )
  range = range;
  else throw _.err( 'intRandom', 'unexpected argument' );

  for( let attempt = 0 ; attempt < attempts ; attempt++ )
  {
    // if( attempt === attempts-2 )
    // debugger;
    // if( attempt === attempts-1 )
    // debugger;

    /*result = _.intRandom( range ); */
    let result = Math.floor( range[ 0 ] + Math.random()*( range[ 1 ] - range[ 0 ] ) );

    let bad = false;
    for( let a = 1 ; a < arguments.length ; a++ )
    if( _.routine.is( arguments[ a ] ) )
    {
      if( !arguments[ a ]( result ) )
      bad = true;
    }
    else
    {
      if( result === arguments[ a ] )
      bad = true;
    }

    if( bad )
    continue;
    return result;
  }

  result = NaN;
  return result;
}

//

/**
 * The routine numbersMake() returns an array of numbers with a length of {-length-} .
 *
 * @param { src|Number|Array } src - source number or array of numbers.
 * If {-src-} is a Number, routine generates an array of length {-length-} filled with {-src-}.
 * If {-src-} is an Array of numbers and {-src-}.length === {-length-}, the routine returns {-src-}.
 *
 * @param { length|Number } length - the size of the returned array.
 *
 * @example
 * let got = _.number.s.make( 1, 0 );
 * // returns an empty array
 * console.log( got )
 * // log []
 *
 * @example
 * let got = _.number.s.make( 1, 3 );
 * // returns an array of size 3 filled with ones
 * console.log( got )
 * // log [ 1, 1, 1 ]
 *
 * @example
 * let got = _.number.s.make( -5.22, 3 );
 * // returns an array of size 3 filled with -5.22
 * console.log( got )
 * // log [ -5.22, -5.22, -5.22 ]
 *
 * @example
 * let got = _.number.s.make( NaN, 3 );
 * // returns an array of size 3 filled with NaN
 * console.log( got )
 * // log [ NaN, NaN, NaN ]
 *
 * @example
 * let got = _.number.s.make( [ 1, 2, 3 ], 3 );
 * // returns source array
 * console.log( got )
 * // log [ 1, 2, 3 ]
 *
 * @example
 * let got = _.number.s.make( [ 1.00, -2.777, 3.00 ], 3 );
 * // returns source array
 * console.log( got )
 * // log [ 1.00, -2.777, 3.00 ]
 *
 * @example
 * let got = _.number.s.make( [ NaN, Infinity, -Infinity ], 3 );
 * // returns source array
 * console.log( got )
 * // log [ NaN, Infinity, -Infinity ]
 *
 * @returns { Array } - Returns an array of numbers.
 * @function numbersMake
 * @throws { Error } If {-src-} is array and {-src-}.length !== {-length-}.
 * @throws { Error } If {-src-} is array and {-src-} contains not a number.
 * @throws { Error } If {-src-} is not an array or a Number.
 * @throws { Error } arguments.length === 0 or arguments.length > 2.
 * @namespace Tools
 */

function numbersMake( src, length )
{
  let result;

  if( _.vector.adapterIs( src ) )
  src = _.vectorAdapter.slice( src );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.number.is( src ) || _.argumentsArray.like( src ) );

  if( _.argumentsArray.like( src ) )
  {
    _.assert( src.length === length );
    result = _.long.makeUndefined( length );
    for( let i = 0 ; i < length ; i++ )
    result[ i ] = src[ i ];
  }
  else
  {
    result = _.long.makeUndefined( length );
    for( let i = 0 ; i < length ; i++ )
    result[ i ] = src;
  }

  return result;
}

//

/**
 * The routine numbersFromNumber() returns an array of numbers with a length of {-length-} .
 *
 * @param { src|Number|Array } src - source number or array of numbers.
 * If {-src-} is a Number, routine generates an array of length {-length-} filled with {-src-}.
 * If {-src-} is an Array of numbers and {-src-}.length === {-length-}, the routine returns {-src-}.
 *
 * @param { length|Number } length - the size of the returned array.
 *
 * @example
 * let got = _.number.s.fromNumber( 1, 0 );
 * // returns an empty array
 * console.log( got )
 * // log []
 *
 * @example
 * let got = _.number.s.fromNumber( 1, 3 );
 * // returns an array of size 3 filled with ones
 * console.log( got )
 * // log [ 1, 1, 1 ]
 *
 * @example
 * let got = _.number.s.fromNumber( -5.22, 3 );
 * // returns an array of size 3 filled with -5.22
 * console.log( got )
 * // log [ -5.22, -5.22, -5.22 ]
 *
 * @example
 * let got = _.number.s.fromNumber( NaN, 3 );
 * // returns an array of size 3 filled with NaN
 * console.log( got )
 * // log [ NaN, NaN, NaN ]
 *
 * @example
 * let got = _.number.s.fromNumber( [ 1, 2, 3 ], 3 );
 * // returns source array
 * console.log( got )
 * // log [ 1, 2, 3 ]
 *
 * @example
 * let got = _.number.s.fromNumber( [ 1.00, -2.777, 3.00 ], 3 );
 * // returns source array
 * console.log( got )
 * // log [ 1.00, -2.777, 3.00 ]
 *
 * @example
 * let got = _.number.s.fromNumber( [ NaN, Infinity, -Infinity ], 3 );
 * // returns source array
 * console.log( got )
 * // log [ NaN, Infinity, -Infinity ]
 *
 * @returns { Array } - Returns an array of numbers.
 * @function numbersFromNumber
 * @throws { Error } If {-src-} is array and {-src-}.length !== {-length-}.
 * @throws { Error } If {-src-} is array and {-src-} contains not a number.
 * @throws { Error } If {-src-} is not an array or a Number.
 * @throws { Error } arguments.length === 0 or arguments.length > 2.
 * @namespace Tools
 */

function numbersFromNumber( src, length )
{

  if( _.vector.adapterIs( src ) )
  src = _.vectorAdapter.slice( src );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.number.is( src ) || _.argumentsArray.like( src ) );

  if( _.argumentsArray.like( src ) )
  {
    _.assert( src.length === length );
    return src;
  }

  // debugger; /* xxx2 : test */
  let result = _.long.makeUndefined( length );
  for( let i = 0 ; i < length ; i++ )
  result[ i ] = src;

  return result;
}

//

/**
 * The routine numbersFromInt() returns an array of integers with a length of {-length-} .
 *
 * @param { src|Number|Array } src - source number or array of integers.
 * If {-src-} is an integer Number, routine generates an array of length {-length-} filled with {-src-}.
 * If {-src-} is an Array of integers and {-src-}.length === {-length-}, the routine returns {-src-}.
 *
 * @param { length|Number } length - the size of the returned array.
 *
 * @example
 * let got = _.number.s.fromInt( 1, 0 );
 * // returns an empty array
 * console.log( got )
 * // log []
 *
 * @example
 * let got = _.number.s.fromInt( 1, 3 );
 * // returns an array of size 3 filled with ones
 * console.log( got )
 * // log [ 1, 1, 1 ]
 *
 * @example
 * let got = _.number.s.fromInt( [ 1, 2, 3 ], 3 );
 * // returns source array
 * console.log( got )
 * // log [ 1, 2, 3 ]
 *
 * @example
 * let got = _.number.s.fromInt( [ 1.00, -2.00, 3.00 ], 3 );
 * // returns source array
 * console.log( got )
 * // log [ 1.00, -2.00, 3.00 ]
 *
 * @returns { Array } - Returns an array of integers.
 * @function numbersFromInt
 * @throws { Error } If {-src-} is array and {-src-}.length !== {-length-}.
 * @throws { Error } If {-src-} is array and {-src-} contains not an integer Number.
 * @throws { Error } If {-src-} is not an array or an integer.
 * @throws { Error } arguments.length === 0 or arguments.length > 2.
 * @namespace Tools
 */

function numbersFromInt( dst, length )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.intIs( dst ) || _.arrayIs( dst ), 'Expects array of number as argument' );
  _.assert( length >= 0 );

  if( _.number.is( dst ) )
  {
    debugger;
    // dst = _.longFillTimes( [], length , dst );
    dst = _.longFill( [], dst, length );
  }
  else
  {
    for( let i = 0 ; i < dst.length ; i++ )
    _.assert( _.intIs( dst[ i ] ), 'Expects integer, but got', dst[ i ] );
    _.assert( dst.length === length, 'Expects array of length', length, 'but got', dst );
  }

  return dst;
}

//

function numbersMake_functor( length )
{
  // let _ = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.number.is( length ) );

  function numbersMake( src )
  {
    return _.number.s.make( src, length );
  }

  return numbersMake;
}

//

function numbersFrom_functor( length )
{
  // let _ = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.number.is( length ) );

  function numbersFromNumber( src )
  {
    return _.number.s.fromNumber( src, length );
  }

  return numbersFromNumber;
}

// --
// extension
// --

let ToolsExtension =
{

  numbersTotal,

  numberFrom : from,
  numbersFrom,
  numberFromStr : fromStr,
  numberFromStrMaybe : fromStrMaybe, /* qqq : cover */

  numbersSlice,

  numberRandom : random,
  intRandom,
  intRandomBut, /* dubious */

  numbersMake,
  numbersFromNumber,
  numbersFromInt,

  numbersMake_functor,
  numbersFrom_functor,

}

Object.assign( _, ToolsExtension );

//

let NumberExtension =
{


  from,
  fromStr,
  fromStrMaybe, /* qqq : cover */

  random,
  intRandom,
  intRandomBut, /* dubious */

}

Object.assign( _.number, NumberExtension );

//

let NumbersExtension =
{

  total : numbersTotal,
  from : numbersFrom,
  slice : numbersSlice,

  make : numbersMake,
  fromNumber : numbersFromNumber,
  fromInt : numbersFromInt,

  make_functor : numbersMake_functor,
  from_functor : numbersFrom_functor,

}

Object.assign( _.number.s, NumbersExtension );

})();

( function _l7_Long_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

//

const _ArrayIndexOf = Array.prototype.indexOf;
const _ArrayLastIndexOf = Array.prototype.lastIndexOf;
const _ArraySlice = Array.prototype.slice;
const _ArraySplice = Array.prototype.splice;
const _FunctionBind = Function.prototype.bind;
const _ObjectToString = Object.prototype.toString;
const _ObjectPropertyIsEumerable = Object.propertyIsEnumerable;

// --
// long transformer
// --

/**
 * The routine longOnce() returns the {-dstLong-} with the duplicated elements removed.
 * The {-dstLong-} instance will be returned when possible, if not a new instance of the same type is created.
 *
 * @param { Long } dstLong - The source and destination Long.
 * @param { Function } onEvaluate - A callback function.
 *
 * @example
 * _.longOnce( [ 1, 1, 2, 'abc', 'abc', 4, true, true ] );
 * // returns [ 1, 2, 'abc', 4, true ]
 *
 * @example
 * _.longOnce( [ 1, 2, 3, 4, 5 ] );
 * // returns [ 1, 2, 3, 4, 5 ]
 *
 * @example
 * _.longOnce( [ { v : 1 },{ v : 1 }, { v : 1 } ], ( e ) => e.v );
 * // returns [ { v : 1 } ]
 *
 * @example
 * _.longOnce( [ { v : 1 },{ v : 1 }, { v : 1 } ], ( e ) => e.k );
 * // returns [ { v : 1 },{ v : 1 }, { v : 1 } ]
 *
 * @returns { Long } - If it is possible, returns the source Long without the duplicated elements.
 * Otherwise, returns copy of the source Long without the duplicated elements.
 * @function longOnce
 * @throws { Error } If passed arguments is less than one or more than two.
 * @throws { Error } If the first argument is not an long.
 * @throws { Error } If the second argument is not a Routine.
 * @namespace Tools
 */

function longOnce( dstLong, onEvaluate )
{
  _.assert( 1 <= arguments.length || arguments.length <= 2 );
  _.assert( _.longIs( dstLong ), 'Expects Long' );

  if( _.arrayIs( dstLong ) )
  return _.arrayRemoveDuplicates( dstLong, onEvaluate );

  if( !dstLong.length )
  return dstLong;

  let length = dstLong.length;

  for( let i = 0; i < dstLong.length; i++ )
  if( _.longLeftIndex( dstLong, dstLong[ i ], i+1, onEvaluate ) !== -1 )
  length--;

  if( length === dstLong.length )
  return dstLong;

  let result = _.long.makeUndefined( dstLong, length );
  result[ 0 ] = dstLong[ 0 ];

  let j = 1;
  for( let i = 1; i < dstLong.length && j < length; i++ )
  if( _.longRightIndex( result, dstLong[ i ], j-1, onEvaluate ) === -1 )
  result[ j++ ] = dstLong[ i ];

  _.assert( j === length );

  return result;
}

//

function longOnce_( dstLong, srcLong, onEvaluate )
{
  _.assert( dstLong === null || _.longIs( dstLong ), 'Expects Long' );

  if( dstLong === null )
  {
    if( _.longIs( srcLong ) )
    dstLong = _.long.makeUndefined( srcLong, 0 );
    else
    return [];
  }
  if( arguments.length === 1 )
  {
    srcLong = dstLong;
  }
  else if( arguments.length === 2 )
  {
    if( _.routine.is( srcLong ) )
    {
      onEvaluate = arguments[ 1 ];
      srcLong = arguments[ 0 ];
    }
  }
  else if( arguments.length !== 3 )
  _.assert( 0 );

  _.assert( _.longIs( srcLong ) );

  let result;

  if( dstLong === srcLong )
  {
    if( !dstLong.length )
    return dstLong;

    if( _.arrayIs( dstLong ) )
    return _.arrayRemoveDuplicates( dstLong, onEvaluate );

    let length = dstLong.length;

    for( let i = 0; i < dstLong.length; i++ )
    if( _.longLeftIndex( dstLong, dstLong[ i ], i + 1, onEvaluate ) !== -1 )
    length--;

    if( length === dstLong.length )
    return dstLong;

    result = _.long.makeUndefined( dstLong, length );
    result[ 0 ] = dstLong[ 0 ];

    let j = 1;
    for( let i = 1; i < dstLong.length && j < length; i++ )
    if( _.longRightIndex( result, dstLong[ i ], j - 1, onEvaluate ) === -1 )
    result[ j++ ] = dstLong[ i ];

    _.assert( j === length );
  }
  else
  {
    if( _.arrayIs( dstLong ) )
    {
      result = _.arrayAppendArrayOnce( dstLong, srcLong, onEvaluate );
    }
    else
    {
      let length = srcLong.length + dstLong.length;

      for( let i = 0; i < srcLong.length; i++ )
      if
      (
        _.longLeftIndex( dstLong, srcLong[ i ], onEvaluate ) !== -1
        || _.longLeftIndex( srcLong, srcLong[ i ], i + 1, onEvaluate ) !== -1
      )
      length--;

      if( length === dstLong.length )
      return dstLong;

      result = _.long.makeUndefined( dstLong, length );

      for( let i = 0; i < dstLong.length; i++ )
      result[ i ] = dstLong[ i ]

      let offset = dstLong.length;
      for( let i = dstLong.length ; i < result.length && offset >= -result.length ;  )
      {
        if( _.longLeftIndex( result, srcLong[ i - offset ], onEvaluate ) === -1 )
        {
          result[ i ] = srcLong[ i - offset ];
          i++;
        }
        else
        {
          offset--;
        }
      }
    }
  }


  return result;
}

//

function longHasUniques( o )
{

  if( _.longIs( o ) )
  o = { src : o };

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longIs( o.src ) );
  _.map.assertHasOnly( o, longHasUniques.defaults );

  /* */

  // if( o.onEvaluate )
  // {
  //   o.src = _.entity.map_( null, o.src, ( e ) => o.onEvaluate( e ) );
  // }

  /* */

  let number = o.src.length;
  let isUnique = [];
  let index;

  for( let i = 0 ; i < o.src.length ; i++ )
  isUnique[ i ] = 1;

  for( let i = 0 ; i < o.src.length ; i++ )
  {
    index = i;

    if( !isUnique[ i ] )
    continue;

    let currentUnique = 1;
    index = _.longLeftIndex( o.src, o.src[ i ], index+1, o.onEvaluate );
    if( index >= 0 )
    do
    {
      isUnique[ index ] = 0;
      number -= 1;
      currentUnique = 0;
      index = _.longLeftIndex( o.src, o.src[ i ], index+1, o.onEvaluate );
    }
    while( index >= 0 );

    // if( currentUnique && o.src2 )
    // do
    // {
    //   index = o.src2.indexOf( o.src2[ i ], index+1 );
    //   if( index !== -1 )
    //   currentUnique = 0;
    // }
    // while( index !== -1 );

    if( !o.includeFirst )
    if( !currentUnique )
    {
      isUnique[ i ] = 0;
      number -= 1;
    }

  }

  return { number, is : isUnique };
}

longHasUniques.defaults =
{
  src : null,
  // src2 : null,
  onEvaluate : null,
  includeFirst : 0,
}

//

function longAreRepeatedProbe( srcArray, onEvaluate )
{
  let isUnique = _.long.makeUndefined( srcArray );
  let result = Object.create( null );
  result.array = _.array.make( srcArray.length );
  result.uniques = srcArray.length;
  result.condensed = srcArray.length;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.longIs( srcArray ) );

  for( let i = 0 ; i < srcArray.length ; i++ )
  {
    let element = srcArray[ i ];

    if( result.array[ i ] > 0 )
    continue;

    result.array[ i ] = 0;

    let left = _.longLeftIndex( srcArray, element, i+1, onEvaluate );
    if( left >= 0 )
    {
      result.array[ i ] = 1;
      result.uniques -= 1;
      do
      {
        result.uniques -= 1;
        result.condensed -= 1;
        result.array[ left ] = 1;
        left = _.longLeftIndex( srcArray, element, left+1, onEvaluate );
      }
      while( left >= 0 );
    }

  }

  return result;

}

//

function longAllAreRepeated( src, onEvalutate )
{
  let areRepated = _.longAreRepeatedProbe.apply( this, arguments );
  return !areRepated.uniques;
}

//

function longAnyAreRepeated( src, onEvalutate )
{
  let areRepated = _.longAreRepeatedProbe.apply( this, arguments );
  return areRepated.uniques !== src.length;
}

//

function longNoneAreRepeated( src, onEvalutate )
{
  let areRepated = _.longAreRepeatedProbe.apply( this, arguments );
  return areRepated.uniques === src.length;
}

//

/**
 * The longMask() routine returns a new instance of array that contains the certain value(s) from array (srcArray),
 * if an array (mask) contains the truth-value(s).
 *
 * The longMask() routine checks, how much an array (mask) contain the truth value(s),
 * and from that amount of truth values it builds a new array, that contains the certain value(s) of an array (srcArray),
 * by corresponding index(es) (the truth value(s)) of the array (mask).
 * If amount is equal 0, it returns an empty array.
 *
 * @param { longIs } srcArray - The source array.
 * @param { longIs } mask - The target array.
 *
 * @example
 * _.longMask( [ 1, 2, 3, 4 ], [ undefined, null, 0, '' ] );
 * // returns []
 *
 * @example
 * _longMask( [ 'a', 'b', 'c', 4, 5 ], [ 0, '', 1, 2, 3 ] );
 * // returns [ "c", 4, 5 ]
 *
 * @example
 * _.longMask( [ 'a', 'b', 'c', 4, 5, 'd' ], [ 3, 7, 0, '', 13, 33 ] );
 * // returns [ 'a', 'b', 5, 'd' ]
 *
 * @returns { longIs } Returns a new instance of array that contains the certain value(s) from array (srcArray),
 * if an array (mask) contains the truth-value(s).
 * If (mask) contains all falsy values, it returns an empty array.
 * Otherwise, it returns a new array with certain value(s) of an array (srcArray).
 * @function longMask
 * @throws { Error } Will throw an Error if (arguments.length) is less or more that two.
 * @throws { Error } Will throw an Error if (srcArray) is not an array-like.
 * @throws { Error } Will throw an Error if (mask) is not an array-like.
 * @throws { Error } Will throw an Error if length of both (srcArray and mask) is not equal.
 * @namespace Tools
 */

function longMask( srcArray, mask )
{

  let scalarsPerElement = mask.length;
  let length = srcArray.length / scalarsPerElement;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.longIs( srcArray ), 'longMask :', 'Expects array-like as srcArray' );
  _.assert( _.longIs( mask ), 'longMask :', 'Expects array-like as mask' );
  _.assert
  (
    _.intIs( length ),
    'longMask :', 'Expects mask that has component for each atom of srcArray',
    _.entity.exportString
    ({
      scalarsPerElement,
      'srcArray.length' : srcArray.length,
    })
  );

  let preserve = 0;
  for( let m = 0 ; m < mask.length ; m++ )
  if( mask[ m ] )
  preserve += 1;

  // let dstArray = new srcArray.constructor( length*preserve );
  let dstArray = _.long.makeUndefined( srcArray, length*preserve );

  if( !preserve )
  return dstArray;

  let c = 0;
  for( let i = 0 ; i < length ; i++ )
  for( let m = 0 ; m < mask.length ; m++ )
  if( mask[ m ] )
  {
    dstArray[ c ] = srcArray[ i*scalarsPerElement + m ];
    c += 1;
  }

  return dstArray;
}

//

function longUnmask( o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  o =
  {
    src : arguments[ 0 ],
    mask : arguments[ 1 ],
  }

  _.map.assertHasOnly( o, longUnmask.defaults );
  _.assert( _.longIs( o.src ), 'Expects o.src as ArrayLike' );

  let scalarsPerElement = o.mask.length;

  let scalarsPerElementPreserved = 0;
  for( let m = 0 ; m < o.mask.length ; m++ )
  if( o.mask[ m ] )
  scalarsPerElementPreserved += 1;

  let length = o.src.length / scalarsPerElementPreserved;
  if( Math.floor( length ) !== length )
  throw _.err
  (
    'longMask :',
    'Expects mask that has component for each atom of o.src',
    _.entity.exportString({ scalarsPerElementPreserved, 'o.src.length' : o.src.length  })
  );

  let dstArray = _.long.makeUndefined( o.src, scalarsPerElement*length );
  // let dstArray = new o.src.constructor( scalarsPerElement*length );

  let e = [];
  for( let i = 0 ; i < length ; i++ )
  {

    for( let m = 0, p = 0 ; m < o.mask.length ; m++ )
    if( o.mask[ m ] )
    {
      e[ m ] = o.src[ i*scalarsPerElementPreserved + p ];
      p += 1;
    }
    else
    {
      e[ m ] = 0;
    }

    if( o.onEach )
    o.onEach( e, i );

    for( let m = 0 ; m < o.mask.length ; m++ )
    dstArray[ i*scalarsPerElement + m ] = e[ m ];

  }

  return dstArray;
}

longUnmask.defaults =
{
  src : null,
  mask : null,
  onEach : null,
}

// --
// array maker
// --

/**
 * The routine longRandom() returns an array which contains random numbers.
 *
 * Routine accepts one or three arguments.
 * Optionally, routine can accepts one of two sets of parameters. First of them
 * is one or three arguments, the other is options map.
 *
 * Set 1:
 * @param { ArrayLike } dst - The destination array.
 * @param { Range|Number } range - The range for generating random numbers.
 * If {-range-} is number, routine makes range [ range, range ].
 * @param { Number|Range } length - The quantity of generated random numbers.
 * If dst.length < {-length-}, then routine makes new container of {-dst-} type.
 * If {-length-} is Range, then routine choose random lenght from provided range.
 *
 * Set 2:
 * @param { Object } o - The options map. Options map includes next fields:
 * @param { Function } o.onEach - The callback for generating random numbers.
 * Accepts three parameters - range, index of element, source container.
 * @param { ArrayLike } o.dst - The destination array.
 * @param { Range|Number } o.range -  The range for generating random numbers.
 * If {-range-} is number, routine makes range [ range, range ].
 * @param { Number|Range } o.length - The length of an array.
 * If dst.length < length, then routine makes new container of {-dst-} type.
 * If {-length-} is Range, then routine choose random lenght from provided range.
 *
 * @example
 * let got = _.longRandom( 3 );
 * // returns array with three elements in range [ 0, 1 ]
 * console.log( got );
 * // log [ 0.2054268445, 0.8651654684, 0.5564687461 ]
 *
 * @example
 * let dst = [ 0, 0, 0 ];
 * let got _.longRandom( dst, [ 1, 5 ], 3 );
 * // returns dst array with three elements in range [ 1, 5 ]
 * console.log( got );
 * // log [ 4.9883513548, 1.2313468546, 3.8973544247 ]
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let dst = [ 0, 0, 0 ];
 * let got _.longRandom( dst, [ 1, 5 ], 4 );
 * // returns dst array with three elements in range [ 1, 5 ]
 * console.log( got );
 * // log [ 4.9883513548, 1.2313468546, 3.8973544247, 2.6782254287 ]
 * console.log( got === dst );
 * // log false
 *
 * @example
 * _.longRandom
 * ({
 *   length : 5,
 *   range : [ 1, 10 ],
 *   onEach : ( range ) => _.intRandom( range ),
 * });
 * // returns [ 6, 2, 4, 7, 8 ]
 *
 * @example
 * let dst = [ 0, 0, 0, 0, 0 ]
 * var got = _.longRandom
 * ({
 *   length : 3,
 *   range : [ 1, 10 ],
 *   onEach : ( range ) => _.intRandom( range ),
 * });
 * console.log( got );
 * // log [ 1, 10, 4, 0, 0 ]
 * console.log( got === dst );
 * // log true
 *
 * @returns { ArrayLike } - Returns an array of random numbers.
 * @function longRandom
 * @throws { Error } If arguments.length === 0, arguments.length === 2, arguments.lenght > 3.
 * @throws { Error } If arguments.length === 1, and passed argument is not options map {-o-} or {-length-}.
 * @throws { Error } If options map {-o-} has unnacessary fields.
 * @throws { Error } If {-dst-} or {-o.dst-} is not ArrayLike.
 * @throws { Error } If {-range-} or {-o.range-} is not Range or not Number.
 * @throws { Error } If {-length-} or {-o.length-} is not Number or not Range.
 * @throws { Error } If {-o.onEach-} is not routine.
 * @namespace Tools
 */

function longRandom( o )
{

  if( arguments[ 2 ] !== undefined )
  o = { dst : arguments[ 0 ], value : arguments[ 1 ], length : arguments[ 2 ] }
  else if( _.number.is( o ) || _.intervalIs( o ) )
  o = { length : o }
  _.assert( arguments.length === 1 || arguments.length === 3 );
  _.routine.options( longRandom, o );

  if( o.onEach === null )
  o.onEach = ( value ) => _.number.random( value );

  if( o.value === null )
  o.value = [ 0, 1 ];
  if( _.number.is( o.value ) )
  o.value = [ 0, o.value ]
  // o.value = [ o.value, o.value ]

  if( _.intervalIs( o.length ) )
  o.length = _.intRandom( o.length );
  if( o.length === null && o.dst )
  o.length = o.dst.length;
  if( o.length === null )
  o.length = 1;

  _.assert( _.intIs( o.length ) );

  if( o.dst === null || o.dst.length < o.length )
  o.dst = _.long.make( o.dst, o.length );

  for( let i = 0 ; i < o.length ; i++ )
  {
    o.dst[ i ] = o.onEach( o.value, i, o );
  }

  return o.dst;
}

longRandom.defaults =
{
  dst : null,
  onEach : null,
  value : null,
  length : null,
}

//

/**
 * The longFromRange() routine generate array of arithmetic progression series,
 * from the range[ 0 ] to the range[ 1 ] with increment 1.
 *
 * It iterates over loop from (range[0]) to the (range[ 1 ] - range[ 0 ]),
 * and assigns to the each index of the (result) array (range[ 0 ] + 1).
 *
 * @param { longIs } range - The first (range[ 0 ]) and the last (range[ 1 ] - range[ 0 ]) elements of the progression.
 *
 * @example
 * _.longFromRange( [ 1, 5 ] );
 * // returns [ 1, 2, 3, 4 ]
 *
 * @example
 * _.longFromRange( 5 );
 * // returns [ 0, 1, 2, 3, 4 ]
 *
 * @returns { array } Returns an array of numbers for the requested range with increment 1.
 * May be an empty array if adding the step would not converge toward the end value.
 * @function longFromRange
 * @throws { Error } If passed arguments is less than one or more than one.
 * @throws { Error } If the first argument is not an array-like object.
 * @throws { Error } If the length of the (range) is not equal to the two.
 * @namespace Tools
 */

function longFromRange( range )
{

  if( _.number.is( range ) )
  range = [ 0, range ];

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( range.length === 2 );
  _.assert( _.longIs( range ) );

  let step = range[ 0 ] <= range[ 1 ] ? +1 : -1;

  return this.longFromRangeWithStep( range, step );
}

//

function longFromProgressionArithmetic( progression, numberOfSteps )
{
  let result; /* zzz : review */

  debugger;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.longIs( progression ) )
  _.assert( isFinite( progression[ 0 ] ) );
  _.assert( isFinite( progression[ 1 ] ) );
  _.assert( isFinite( numberOfSteps ) );
  _.assert( _.routine.is( this.tools.long.default.from ) );

  debugger;

  if( numberOfSteps === 0 )
  return this.tools.long.default.from();

  if( numberOfSteps === 1 )
  return this.tools.long.default.from([ progression[ 0 ] ]);

  let range = [ progression[ 0 ], progression[ 0 ]+progression[ 1 ]*(numberOfSteps+1) ];
  let step = ( range[ 1 ]-range[ 0 ] ) / ( numberOfSteps-1 );

  return this.longFromRangeWithStep( range, step );
}

//

function longFromRangeWithStep( range, step )
{
  let result;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( isFinite( range[ 0 ] ) );
  _.assert( isFinite( range[ 1 ] ) );
  _.assert( step === undefined || step < 0 || step > 0 );
  _.assert( _.routine.is( this.tools.long.default.from ) );

  if( range[ 0 ] === range[ 1 ] )
  return this.long.default.make();
  // return this.tools.long.default.from();

  if( range[ 0 ] < range[ 1 ] )
  {

    if( step === undefined )
    step = 1;

    _.assert( step > 0 );

    // debugger;
    result = this.long.default.from( Math.round( ( range[ 1 ]-range[ 0 ] ) / step ) );
    // result = this.tools.long.default.from( Math.round( ( range[ 1 ]-range[ 0 ] ) / step ) );

    let i = 0;
    while( range[ 0 ] < range[ 1 ] )
    {
      result[ i ] = range[ 0 ];
      range[ 0 ] += step;
      i += 1;
    }

  }
  else
  {

    if( step === undefined )
    step = -1;

    _.assert( step < 0 );

    // result = this.tools.long.default.from( Math.round( ( range[ 1 ]-range[ 0 ] ) / step ) ); // Dmytro it's more optimal, range[ 0 ] > range[ 1 ] and step < 0 so result will be positive number
    result = this.long.default.from( Math.abs( Math.round( ( range[ 0 ]-range[ 1 ] ) / step ) ) );
    // result = this.tools.long.default.from( Math.abs( Math.round( ( range[ 0 ]-range[ 1 ] ) / step ) ) );

    let i = 0;
    while( range[ 0 ] > range[ 1 ] )
    {
      result[ i ] = range[ 0 ];
      range[ 0 ] += step;
      i += 1;
    }

  }

  return result;
}

//

function longFromRangeWithNumberOfSteps( range, numberOfSteps )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( isFinite( range[ 0 ] ) );
  _.assert( isFinite( range[ 1 ] ) );
  _.assert( numberOfSteps >= 0 );
  _.assert( _.routine.is( this.tools.long.default.from ) );

  if( numberOfSteps === 0 )
  return this.tools.long.default.from();

  if( numberOfSteps === 1 )
  return this.tools.long.default.from( range[ 0 ] );

  let step;

  if( range[ 0 ] < range[ 1 ] )
  step = ( range[ 1 ]-range[ 0 ] ) / (numberOfSteps-1);
  else
  step = ( range[ 0 ]-range[ 1 ] ) / (numberOfSteps-1);

  return this.longFromRangeWithStep( range, step );
}

// --
// array converter
// --

/**
 * The longToMap() converts an (array) into Object.
 *
 * @param { longIs } array - To convert into Object.
 *
 * @example
 * _.longToMap( [] );
 * // returns {}
 *
 * @example
 * _.longToMap( [ 3, [ 1, 2, 3 ], 'abc', false, undefined, null, {} ] );
 * // returns { '0' : 3, '1' : [ 1, 2, 3 ], '2' : 'abc', '3' : false, '4' : undefined, '5' : null, '6' : {} }
 *
 * @example
 * let args = ( function() {
 *   return arguments;
 * } )( 3, 'abc', false, undefined, null, { greeting: 'Hello there!' } );
 * _.longToMap( args );
 * // returns { '0' : 3, '1' : 'abc', '2' : false, '3' : undefined, '4' : null, '5' : { greeting: 'Hello there!' } }
 *
 * @returns { Object } Returns an Object.
 * @function longToMap
 * @throws { Error } Will throw an Error if (array) is not an array-like.
 * @namespace Tools
 */

function longToMap( array )
{
  let result = Object.create( null );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longIs( array ) );

  for( let a = 0 ; a < array.length ; a++ )
  result[ a ] = array[ a ];
  return result;
}
//
// //
//
// /**
//  * The longToStr() routine joins an array {-srcMap-} and returns one string containing each array element separated by space,
//  * only types of integer or floating point.
//  *
//  * @param { longIs } src - The source array.
//  * @param { objectLike } [ options = {  } ] options - The options.
//  * @param { Number } [ options.precision = 5 ] - The precision of numbers.
//  * @param { String } [ options.type = 'mixed' ] - The type of elements.
//  *
//  * @example
//  * _.longToStr( [ 1, 2, 3 ], { type : 'int' } );
//  * // returns "1 2 3 "
//  *
//  * @example
//  * _.longToStr( [ 3.5, 13.77, 7.33 ], { type : 'float', precission : 4 } );
//  * // returns "3.500 13.77 7.330"
//  *
//  * @returns { String } Returns one string containing each array element separated by space,
//  * only types of integer or floating point.
//  * If (src.length) is empty, it returns the empty string.
//  * @function longToStr
//  * @throws { Error } Will throw an Error If (options.type) is not the number or float.
//  * @namespace Tools
//  */
//
// function longToStr( src, options )
// {
//
//   let result = '';
//   options = options || Object.create( null );
//
//   if( options.precission === undefined ) options.precission = 5;
//   if( options.type === undefined ) options.type = 'mixed';
//
//   if( !src.length ) return result;
//
//   if( options.type === 'float' )
//   {
//     for( var s = 0 ; s < src.length-1 ; s++ )
//     {
//       result += src[ s ].toPrecision( options.precission ) + ' ';
//     }
//     result += src[ s ].toPrecision( options.precission );
//   }
//   else if( options.type === 'int' )
//   {
//     for( var s = 0 ; s < src.length-1 ; s++ )
//     {
//       result += String( src[ s ] ) + ' ';
//     }
//     result += String( src[ s ] ) + ' ';
//   }
//   else
//   {
//     throw _.err( 'not tested' );
//     for( let s = 0 ; s < src.length-1 ; s++ )
//     {
//       result += String( src[ s ] ) + ' ';
//     }
//     result += String( src[ s ] ) + ' ';
//   }
//
//   return result;
// }

// --
// array transformer
// --

/**
 * The longOnlyWithIndices() routine selects elements from (srcArray) by indexes of (indicesArray).
 *
 * @param { longIs } srcArray - Values for the new array.
 * @param { ( longIs | object ) } [ indicesArray = indicesArray.indices ] - Indexes of elements from the (srcArray) or options map.
 *
 * @example
 * _.longOnlyWithIndices( [ 1, 2, 3, 4, 5 ], [ 2, 3, 4 ] );
 * // returns [ 3, 4, 5 ]
 *
 * @example
 * _.longOnlyWithIndices( [ 1, 2, 3 ], [ 4, 5 ] );
 * // returns [ undefined, undefined ]
 *
 * @returns { longIs } - Returns a new array with the length equal (indicesArray.length) and elements from (srcArray).
   If there is no element with necessary index than the value will be undefined.
 * @function longOnlyWithIndices
 * @throws { Error } If passed arguments is not array like object.
 * @throws { Error } If the scalarsPerElement property is not equal to 1.
 * @namespace Tools
 */

function longOnlyWithIndices( srcArray, indicesArray )
{
  let scalarsPerElement = 1;

  if( _.object.isBasic( indicesArray ) )
  {
    scalarsPerElement = indicesArray.scalarsPerElement || 1;
    indicesArray = indicesArray.indices;
  }

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.longIs( srcArray ) );
  _.assert( _.longIs( indicesArray ) );

  // let result = new srcArray.constructor( indicesArray.length );
  let result = _.long.makeUndefined( srcArray, indicesArray.length );

  if( scalarsPerElement === 1 )
  for( let i = 0, l = indicesArray.length ; i < l ; i += 1 )
  {
    result[ i ] = srcArray[ indicesArray[ i ] ];
  }
  else
  for( let i = 0, l = indicesArray.length ; i < l ; i += 1 )
  {
    for( let a = 0 ; a < scalarsPerElement ; a += 1 )
    result[ i*scalarsPerElement+a ] = srcArray[ indicesArray[ i ]*scalarsPerElement+a ];
  }

  return result;
}

// --
// long mutator
// --

function longShuffle( dst, times )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.longIs( dst ) );

  if( times === undefined )
  times = dst.length;

  let l = dst.length;
  let e1, e2;
  for( let t1 = 0 ; t1 < times ; t1++ )
  {
    let t2 = Math.floor( Math.random() * l );
    e1 = dst[ t1 ];
    e2 = dst[ t2 ];
    dst[ t1 ] = e2;
    dst[ t2 ] = e1;
  }

  return dst;
}

// --
// array mutator
// --

// function longAssign( dst, index, value )
// {
//   _.assert( arguments.length === 3, 'Expects exactly three arguments' );
//   _.assert( dst.length > index );
//   dst[ index ] = value;
//   return dst;
// }

//

/**
 * The longSwapElements() routine reverses the elements by indices (index1) and (index2) in the (dst) array.
 *
 * @param { Array } dst - The initial array.
 * @param { Number } index1 - The first index.
 * @param { Number } index2 - The second index.
 *
 * @example
 * _.longSwapElements( [ 1, 2, 3, 4, 5 ], 0, 4 );
 * // returns [ 5, 2, 3, 4, 1 ]
 *
 * @returns { Array } - Returns the (dst) array that has been modified in place by indexes (index1) and (index2).
 * @function longSwapElements
 * @throws { Error } If the first argument in not an array.
 * @throws { Error } If the second argument is less than 0 and more than a length initial array.
 * @throws { Error } If the third argument is less than 0 and more than a length initial array.
 * @namespace Tools
 */

function longSwapElements( dst, index1, index2 )
{

  if( arguments.length === 1 )
  {
    index1 = 0;
    index2 = 1;
  }

  _.assert( arguments.length === 1 || arguments.length === 3 );
  _.assert( _.longIs( dst ), 'Expects long' );
  _.assert( 0 <= index1 && index1 < dst.length > 0, 'index1 is out of bound' );
  _.assert( 0 <= index2 && index2 < dst.length > 0, 'index2 is out of bound' );

  let e = dst[ index1 ];
  dst[ index1 ] = dst[ index2 ];
  dst[ index2 ] = e;

  return dst;
}

//

/**
 * The longPut() routine puts all values of (arguments[]) after the second argument to the (dstArray)
 * in the position (dstOffset) and changes values of the following index.
 *
 * @param { longIs } dstArray - The source array.
 * @param { Number } [ dstOffset = 0 ] dstOffset - The index of element where need to put the new values.
 * @param {*} arguments[] - One or more argument(s).
 * If the (argument) is an array it iterates over array and adds each element to the next (dstOffset++) index of the (dstArray).
 * Otherwise, it adds each (argument) to the next (dstOffset++) index of the (dstArray).
 *
 * @example
 * _.longPut( [ 1, 2, 3, 4, 5, 6, 9 ], 2, 'str', true, [ 7, 8 ] );
 * // returns [ 1, 2, 'str', true, 7, 8, 9 ]
 *
 * @example
 * _.longPut( [ 1, 2, 3, 4, 5, 6, 9 ], 0, 'str', true, [ 7, 8 ] );
 * // returns [ 'str', true, 7, 8, 5, 6, 9 ]
 *
 * @returns { longIs } - Returns an array containing the changed values.
 * @function longPut
 * @throws { Error } Will throw an Error if (arguments.length) is less than one.
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (dstOffset) is not a Number.
 * @namespace Tools
 */

function longPut( dstArray, dstOffset )
{
  _.assert( arguments.length >= 1, 'Expects at least one argument' );
  _.assert( _.longIs( dstArray ) );
  _.assert( _.number.is( dstOffset ) );

  dstOffset = dstOffset || 0;

  for( let a = 2 ; a < arguments.length ; a++ )
  {
    let argument = arguments[ a ];
    let aIs = _.arrayIs( argument ) || _.bufferTypedIs( argument );

    if( aIs && _.bufferTypedIs( dstArray ) )
    {
      dstArray.set( argument, dstOffset );
      dstOffset += argument.length;
    }
    else if( aIs )
    for( let i = 0 ; i < argument.length ; i++ )
    {
      dstArray[ dstOffset ] = argument[ i ];
      dstOffset += 1;
    }
    else
    {
      dstArray[ dstOffset ] = argument;
      dstOffset += 1;
    }

  }

  return dstArray;
}

//

/**
 * The longSupplement() routine returns an array (dstArray), that contains values from following arrays only type of numbers.
 * If the initial (dstArray) isn't contain numbers, they are replaced.
 *
 * It finds among the arrays the biggest array, and assigns to the variable (length), iterates over from 0 to the (length),
 * creates inner loop that iterates over (arguments[...]) from the right (arguments.length - 1) to the (arguments[0]) left,
 * checks each element of the arrays, if it contains only type of number.
 * If true, it adds element to the array (dstArray) by corresponding index.
 * Otherwise, it skips and checks following array from the last executable index, previous array.
 * If the last executable index doesn't exist, it adds 'undefined' to the array (dstArray).
 * After that it returns to the previous array, and executes again, until (length).
 *
 * @param { longIs } dstArray - The initial array.
 * @param { ...longIs } arguments[...] - The following array(s).
 *
 * @example
 * _.longSupplement( [ 4, 5 ], [ 1, 2, 3 ], [ 6, 7, 8, true, 9 ], [ 'a', 'b', 33, 13, 'e', 7 ] );
 * // returns ?
 *
 * @returns { longIs } - Returns an array that contains values only type of numbers.
 * @function longSupplement
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (arguments[...]) is/are not the array-like.
 * @namespace Tools
 */

function longSupplement( dstArray )
{
  let result = dstArray;
  if( result === null )
  result = [];

  let length = result.length;
  _.assert( _.longIs( result ) || _.number.is( result ), 'Expects object as argument' );

  for( let a = arguments.length-1 ; a >= 1 ; a-- )
  {
    _.assert( _.longIs( arguments[ a ] ), 'argument is not defined :', a );
    length = Math.max( length, arguments[ a ].length );
  }

  if( _.number.is( result ) )
  result = arrayFill
  ({
    value : result,
    times : length,
  });

  for( let k = 0 ; k < length ; k++ )
  {

    if( k in dstArray && isFinite( dstArray[ k ] ) )
    continue;

    let a;
    for( a = arguments.length-1 ; a >= 1 ; a-- )
    if( k in arguments[ a ] && !isNaN( arguments[ a ][ k ] ) )
    break;

    if( a === 0 )
    continue;

    result[ k ] = arguments[ a ][ k ];

  }

  return result;
}

//

/**
 * The longExtendScreening() routine iterates over (arguments[...]) from the right to the left (arguments[1]),
 * and returns a (dstArray) containing the values of the following arrays,
 * if the following arrays contains the indexes of the (screenArray).
 *
 * @param { longIs } screenArray - The source array.
 * @param { longIs } dstArray - To add the values from the following arrays,
 * if the following arrays contains indexes of the (screenArray).
 * If (dstArray) contains values, the certain values will be replaced.
 * @param { ...longIs } arguments[...] - The following arrays.
 *
 * @example
 * _.longExtendScreening( [ 1, 2, 3 ], [  ], [ 0, 1, 2 ], [ 3, 4 ], [ 5, 6 ] );
 * // returns [ 5, 6, 2 ]
 *
 * @example
 * _.longExtendScreening( [ 1, 2, 3 ], [ 3, 'abc', 7, 13 ], [ 0, 1, 2 ], [ 3, 4 ], [ 'a', 6 ] );
 * // returns [ 'a', 6, 2, 13 ]
 *
 * @example
 * _.longExtendScreening( [  ], [ 3, 'abc', 7, 13 ], [ 0, 1, 2 ], [ 3, 4 ], [ 'a', 6 ] );
 * // returns [ 3, 'abc', 7, 13 ]
 *
 * @returns { longIs } Returns a (dstArray) containing the values of the following arrays,
 * if the following arrays contains the indexes of the (screenArray).
 * If (screenArray) is empty, it returns a (dstArray).
 * If (dstArray) is equal to the null, it creates a new array,
 * and returns the corresponding values of the following arrays by the indexes of a (screenArray).
 * @function longExtendScreening
 * @throws { Error } Will throw an Error if (screenArray) is not an array-like.
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (arguments[...]) is/are not an array-like.
 * @namespace Tools
 */

function longExtendScreening( screenArray, dstArray )
{
  let result = dstArray;
  if( result === null )
  result = [];

  if( Config.debug )
  {
    _.assert( _.longIs( screenArray ), 'Expects object as screenArray' );
    _.assert( _.longIs( result ), 'Expects object as argument' );
    for( let a = arguments.length-1 ; a >= 2 ; a-- )
    _.assert( !!arguments[ a ], () => `Argument #${a} is not defined` );
  }

  for( let k = 0 ; k < screenArray.length ; k++ )
  {

    if( screenArray[ k ] === undefined )
    continue;

    let a;
    for( a = arguments.length-1 ; a >= 2 ; a-- )
    if( k in arguments[ a ] )
    break;
    if( a === 1 )
    continue;

    result[ k ] = arguments[ a ][ k ];

  }

  return result;
}

//

/**
 * The routine longSort() sorts destination Long {-dstLong-}.
 *
 * @param { Long|Null } dstLong - The destination Long. If {-dstLong-} is null, then routine makes copy from {-srcLong-}.
 * @param { Long } srcArray - Source long. Uses if {-dstLong-} is null.
 * @param { Function } onEvaluate - Callback - evaluator or comparator for sorting elements.
 *
 * @example
 * let src = [ 1, 30, -2, 5, -43 ];
 * _.longSort( null, src );
 * // returns [ -43, -2, 1, 30, 5 ]
 *
 * @example
 * let dst = [ 1, 30, -2, 5, -43 ];
 * let src = [ 0 ];
 * let got = _.longSort( dst, src );
 * console.log( got );
 * // log [ -43, -2, 1, 30, 5 ]
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let dst = [ 1, 50, -2, 3, -43 ];
 * let onEval = ( e ) => e;
 * let got = _.longSort( dst, onEval );
 * console.log( got );
 * // log [ -43, -2, 1, 3, 50 ]
 * console.log( got === dst );
 * // log true
 *
 * @example
 * let dst = [ 1, 50, -2, 3, -43 ];
 * let onEval = ( a, b ) => a < b;
 * let got = _.longSort( dst, onEval );
 * console.log( got );
 * // log [ 50, 3, 1, -2, -43 ]
 * console.log( got === dst );
 * // log true
 *
 * @returns { Long } Returns sorted {-dstLong-}.
 * @function longSort
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-onEvaluate-} is not a routine or not undefined.
 * @throws { Error } If {-dstLong-} is not null or not a Long.
 * @throws { Error } If arguments.length === 3 and {-srcLong-} is not a Long.
 * @throws { Error } If onEvaluate.length is less then one or more then two.
 * @namespace Tools
 */

function longSort( dstLong, srcLong, onEvaluate )
{

  if( _.routine.is( arguments[ 1 ] ) )
  {
    onEvaluate = arguments[ 1 ];
    srcLong = dstLong;
  }

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( onEvaluate === undefined || _.routine.is( onEvaluate ) );
  _.assert( _.longIs( srcLong ) );
  _.assert( dstLong === null || _.longIs( dstLong ) );

  if( dstLong === null )
  dstLong = _.array.make( srcLong );
  if( _.argumentsArray.is( dstLong ) ) // Dmytro : missed
  dstLong = this.tools.long.default.from( dstLong );

  if( onEvaluate === undefined )
  {
    dstLong.sort();
  }
  else if( onEvaluate.length === 2 )
  {
    dstLong.sort( onEvaluate );
  }
  else if( onEvaluate.length === 1 )
  {
    dstLong.sort( function( a, b )
    {
      a = onEvaluate( a );
      b = onEvaluate( b );

      if( a > b )
      return +1;
      else if( a < b )
      return -1;
      else
      return 0;
    });
  }
  else _.assert( 0, 'Expects signle-argument evaluator or two-argument comparator' );

  return dstLong;
}

// --
// array etc
// --

// function longIndicesOfGreatest( srcArray, numberOfElements, comparator )
// {
//   let result = [];
//   let l = srcArray.length;
//
//   debugger;
//   throw _.err( 'not tested' );
//
//   comparator = _.routine._comparatorFromEvaluator( comparator );
//
//   function rcomparator( a, b )
//   {
//     return comparator( srcArray[ a ], srcArray[ b ] );
//   };
//
//   for( let i = 0 ; i < l ; i += 1 )
//   {
//
//     if( result.length < numberOfElements )
//     {
//       _.sorted.add( result, i, rcomparator );
//       continue;
//     }
//
//     _.sorted.add( result, i, rcomparator );
//     result.splice( result.length-1, 1 );
//
//   }
//
//   return result;
// }
//
// //
//
// /**
//  * The longSum() routine returns the sum of an array {-srcMap-}.
//  *
//  * @param { longIs } src - The source array.
//  * @param { Routine } [ onEvaluate = function( e ) { return e } ] - A callback function.
//  *
//  * @example
//  * _.longSum( [ 1, 2, 3, 4, 5 ] );
//  * // returns 15
//  *
//  * @example
//  * _.longSum( [ 1, 2, 3, 4, 5 ], function( e ) { return e * 2 } );
//  * // returns 29
//  *
//  * @example
//  * _.longSum( [ true, false, 13, '33' ], function( e ) { return e * 2 } );
//  * // returns 94
//  *
//  * @returns { Number } - Returns the sum of an array {-srcMap-}.
//  * @function longSum
//  * @throws { Error } If passed arguments is less than one or more than two.
//  * @throws { Error } If the first argument is not an array-like object.
//  * @throws { Error } If the second argument is not a Routine.
//  * @namespace Tools
//  */
//
// function longSum( src, onEvaluate )
// {
//   let result = 0;
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( _.longIs( src ), 'Expects ArrayLike' );
//
//   if( onEvaluate === undefined )
//   onEvaluate = function( e ){ return e; };
//
//   _.assert( _.routine.is( onEvaluate ) );
//
//   for( let i = 0 ; i < src.length ; i++ )
//   {
//     result += onEvaluate( src[ i ], i, src );
//   }
//
//   return result;
// }

// --
// declaration
// --

let ToolsExtension =
{

  // long repeater

  longOnce, /* zzz : review */ /* !!! : use instead of longOnce */
  longOnce_,

  longHasUniques,
  longAreRepeatedProbe,
  longAllAreRepeated,
  longAnyAreRepeated,
  longNoneAreRepeated,

  longMask, /* dubious */
  longUnmask, /* dubious */

  // array maker

  longRandom,

  longFromRange,
  longFromProgressionArithmetic, /* qqq : light coverage required */
  longFromRangeWithStep,
  longFromRangeWithNumberOfSteps,

  // // array converter
  //
  longToMap, /* dubious */ /* Yevhen : uncommented, routine is used in module::wChangeTransactor */
  // longToStr, /* dubious */

  // long transformer

  longOnlyWithIndices,

  // long mutator

  longShuffle,

  // long mutator

  longSwapElements,
  longPut,

  longSupplement, /* experimental */
  longExtendScreening, /* experimental */

  longSort,

  // // array etc
  //
  // longIndicesOfGreatest, /* dubious */
  // longSum, /* dubious */

}

//

Object.assign( _, ToolsExtension );

})();

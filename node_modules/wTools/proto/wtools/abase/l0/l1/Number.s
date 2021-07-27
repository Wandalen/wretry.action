( function _l1_Numbers_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

_.number = _.number || Object.create( null );
_.numbers = _.number.s = _.numbers || _.number.s || Object.create( null );

// --
// number
// --

/**
 * @summary Checks if argument( src ) is a Number.
 * @returns Returns true if ( src ) is a Number, otherwise returns false.
 *
 * @example
 * numberIs( 5 );
 * // returns true
 *
 * @example
 * numberIs( 'song' );
 * // returns false
 *
 * @param { * } src.
 * @return {Boolean}.
 * @function numberIs
 * @namespace Tools
 */

function is( src )
{
  return typeof src === 'number';
  return Object.prototype.toString.call( src ) === '[object Number]';
}

//

function like( src )
{
  return _.number.is( src ) || _.bigInt.is( src );
}

//

function isNotNan( src )
{
  return _.number.is( src ) && !isNaN( src );
}

//

function numberIsFinite( src )
{
  if( !_.number.is( src ) )
  return false;
  return isFinite( src );
}

//

function isInfinite( src )
{

  if( !_.number.is( src ) )
  return false;

  return src === +Infinity || src === -Infinity;
}

//

function intIs( src )
{

  if( !_.number.is( src ) || !_.number.isFinite( src ) )
  return false;

  return Math.floor( src ) === src;
}

//

function areAll( src )
{
  _.assert( arguments.length === 1 );

  if( _.bufferTypedIs( src ) )
  return true;

  if( _.argumentsArray.like( src ) && !_.arrayIsEmpty( src ) )
  {
    for( let s = 0 ; s < src.length ; s++ )
    if( !_.number.is( src[ s ] ) )
    return false;

    return true;
  }

  return false;
}

//

function areFinite( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );

  if( !_.number.s.areAll( src ) )
  return false;

  if( _.longIs( src ) )
  {
    for( let s = 0 ; s < src.length ; s++ )
    if( !_.number.isFinite( src[ s ] ) )
    return false;
  }

  return true;
}

//

function arePositive( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );

  if( !_.number.s.areAll( src ) )
  return false;

  if( _.longIs( src ) )
  {
    for( let s = 0 ; s < src.length ; s++ )
    if( src[ s ] < 0 || !_.number.isNotNan( src[ s ] ) )
    return false;
  }

  return true;
}

//

function areInt( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );

  if( !_.number.s.areAll( src ) )
  return false;

  if( _.longIs( src ) )
  {
    for( let s = 0 ; s < src.length ; s++ )
    if( !_.intIs( src[ s ] ) )
    return false;
  }

  return true;
}

// --
// number extension
// --

let NumberExtension =
{

  is,
  like,

  isNotNan,
  isFinite : numberIsFinite,
  defined : numberIsFinite,
  isInfinite,

  intIs,

}

Object.assign( _.number, NumberExtension );

// --
// numbers
// --

let NumbersExtension =
{

  areAll,

  areFinite,
  arePositive,
  areInt,

}

Object.assign( _.numbers, NumbersExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  numberIs : is,
  numberIsNotNan : isNotNan,
  numberIsFinite,
  numberDefined : numberIsFinite,
  numberIsInfinite : isInfinite,

  intIs,

  numbersAreAll : areAll,

  numbersAreFinite : areFinite,
  numbersArePositive : arePositive,
  numbersAreInt : areInt,

}

Object.assign( _, ToolsExtension );

//

})();

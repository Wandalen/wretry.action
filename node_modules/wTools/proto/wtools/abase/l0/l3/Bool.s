( function _l3_Bool_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// bool
// --

/**
 * @summary Returns copy of array( src ) with only boolean elements.
 * @description
 * Returns false if ( src ) is not ArrayLike object.
 * @function boolsAre
 * @param {Array} src - array of entities
 * @throws {Error} If more or less than one argument is provided.
 * @namespace Tools
 */

function are( src )
{
  _.assert( arguments.length === 1 );
  if( !_.argumentsArray.like( src ) )
  return false;
  return src.filter( ( e ) => _.bool.is( e ) );
}

//

/**
 * @summary Checks if all elements of array( src ) are booleans.
 * @description
 * * If ( src ) is not an array, routine checks if ( src ) is a boolean.
 * @function boolsAllAre
 * @param {Array} src - array of entities
 * @throws {Error} If more or less than one argument is provided.
 * @namespace Tools
 */

function allAre( src )
{
  _.assert( arguments.length === 1 );
  if( !_.arrayIs( src ) )
  return _.bool.is( src );
  return _.all( src.filter( ( e ) => _.bool.is( e ) ) );
}

//

/**
 * @summary Checks if at least one element from array( src ) is a boolean.
 * @description
 * * If ( src ) is not an array, routine checks if ( src ) is a boolean.
 * @function boolsAnyAre
 * @param {Array} src - array of entities
 * @throws {Error} If more or less than one argument is provided.
 * @namespace Tools
 */

function anyAre( src )
{
  _.assert( arguments.length === 1 );
  if( !_.arrayIs( src ) )
  return _.bool.is( src );
  return !!_.any( src.filter( ( e ) => _.bool.is( e ) ) );
}

//

/**
 * @summary Checks if array( src ) doesn't have booleans.
 * @description
 * * If ( src ) is not an array, routine checks if ( src ) is not a boolean.
 * @function boolsAnyAre
 * @param {Array} src - array of entities
 * @throws {Error} If more or less than one argument is provided.
 * @namespace Tools
 */

function noneAre( src )
{
  _.assert( arguments.length === 1 );
  if( !_.arrayIs( src ) )
  return _.bool.is( src );
  return _.none( src.filter( ( e ) => _.bool.is( e ) ) );
}

// //
//
// function areEquivalentShallow( src1, src2 )
// {
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( _.bool.like( src1 ) );
//   _.assert( _.bool.like( src2 ) );
//
//   if
//   (
//     ( _.bool.likeTrue( src1 ) && _.bool.likeTrue( src2 ) )
//     || ( ( _.bool.likeFalse( src1 ) && _.bool.likeFalse( src2 ) ) )
//   )
//   return true;
//
//   return false;
// }

//

function _identicalShallow( src1, src2 )
{
  if( src1 === src2 )
  return true;
  return false;
}

//

function identicalShallow( src1, src2, o )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !this.like( src1 ) )
  return false;
  if( !this.like( src2 ) )
  return false;
  return this._identicalShallow( src1, src2 );
}

//

function _equivalentShallow( src1, src2 )
{
  if
  (
    ( _.bool.likeTrue( src1 ) && _.bool.likeTrue( src2 ) )
    || ( ( _.bool.likeFalse( src1 ) && _.bool.likeFalse( src2 ) ) )
  )
  return true;
  return false;
}

//

function equivalentShallow( src1, src2, o )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !this.like( src1 ) )
  return false;
  if( !this.like( src2 ) )
  return false;
  return this._equivalentShallow( src1, src2 );
}

// --
// bool extension
// --

let BoolExtension =
{

  // equaler

  _identicalShallow,
  identicalShallow,
  identical : identicalShallow,
  _equivalentShallow,
  equivalentShallow,
  equivalent : equivalentShallow,

}

Object.assign( _.bool, BoolExtension );

// --
// bools
// --

let BoolsExtension =
{

  are,
  allAre,
  anyAre,
  noneAre,

}

Object.assign( _.bools, BoolsExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  boolsAre : are,
  boolsAllAre : allAre,
  boolsAnyAre : anyAre,
  boolsNoneAre : noneAre,

}

Object.assign( _, ToolsExtension );

//

})();

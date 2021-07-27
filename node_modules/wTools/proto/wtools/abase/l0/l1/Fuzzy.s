( function _l1_Fuzzy_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.fuzzy = _.fuzzy || Object.create( null );

// --
// fuzzy
// --

/**
 * Returns true if entity ( src ) is a Boolean values - true and false or Symbol(maybe).
 * @function is
 * @param { * } src - An entity to check.
 * @namespace Tools
 *
 * @example
 * var got = _.fuzzy.is( true );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.is( false );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.is( _.maybe );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.is( '1' );
 * console.log( got )
 * // log false
 *
 */

function is( src )
{
  return src === true || src === false || src === _.maybe;
}

//

/**
 * Returns true if entity ( src ) is a Boolean or a Number or Symbol(maybe).
 * @function fuzzyLike
 * @param { * } src - An entity to check.
 * @namespace Tools
 *
 * @example
 * var got = _.fuzzy.like( true );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.like( false );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.like( _.maybe );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.like( 1 );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.like( '1' );
 * console.log( got )
 * // log false
 */

function like( src )
{
  if( src === _.maybe )
  return true;
  return src === true || src === false || src === 0 || src === 1;
  // let type = Object.prototype.toString.call( src );
  // return type === '[object Boolean]' || type === '[object Number]';
}

//

/**
 * Returns true if entity ( src ) is false or 0.
 * @function likeFalse
 * @param { * } src - An entity to check.
 * @namespace Tools
 *
 * @example
 * var got = _.fuzzy.likeFalse( true );
 * console.log( got )
 * // log false
 *
 * @example
 * var got = _.fuzzy.likeFalse( false );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.likeFalse( _.maybe );
 * console.log( got )
 * // log false
 *
 * @example
 * var got = _.fuzzy.likeFalse( 0 );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.likeFalse( '1' );
 * console.log( got )
 * // log false
 *
 */

function likeFalse( src )
{
  if( !_.fuzzy.like( src ) )
  return false;
  return !src;
}

//

/**
 * Returns true if entity ( src ) is true or a Number which is not 0.
 * @function likeTrue
 * @param { * } src - An entity to check.
 * @namespace Tools
 *
 *  @example
 * var got = _.fuzzy.likeTrue( true );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.likeTrue( false );
 * console.log( got )
 * // log false
 *
 * @example
 * var got = _.fuzzy.likeTrue( _.maybe );
 * console.log( got )
 * // log true
 *
 * @example
 * var got = _.fuzzy.likeTrue( 0 );
 * console.log( got )
 * // log false
 *
 * @example
 * var got = _.fuzzy.likeTrue( 10 );
 * console.log( got )
 * // log true
 *
 */

function likeTrue( src )
{
  if( !_.fuzzy.like( src ) )
  return false;
  if( src === _.maybe )
  return false;
  return !!src;
}

// --
// extension
// --

let ToolsExtension =
{

  fuzzyIs : is,
  fuzzyLike : like,
  fuzzyLikeFalse : likeFalse,
  fuzzyLikeTrue : likeTrue,

}

//

let Extension =
{

  is,
  like,
  likeFalse,
  likeTrue,

}

Object.assign( _, ToolsExtension );
Object.assign( _.fuzzy, Extension );

})();

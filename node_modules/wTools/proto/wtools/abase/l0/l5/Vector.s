( function _l5_Vector_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.vector = _.vector || Object.create( null );

// --
// implementation
// --

/**
 * The hasLength() routine determines whether the passed value has the property (length).
 *
 * If {-srcMap-} is equal to the (undefined) or (null) false is returned.
 * If {-srcMap-} has the property (length) true is returned.
 * Otherwise false is.
 *
 * @param { * } src - The object to be checked.
 *
 * @example
 * _.hasLength( [ 1, 2 ] );
 * // returns true
 *
 * @example
 * _.hasLength( 'Hello there!' );
 * // returns true
 *
 * @example
 * let isLength = ( function() {
 *   return _.hasLength( arguments );
 * } )( 'Hello there!' );
 * // returns true
 *
 * @example
 * _.hasLength( 10 );
 * // returns false
 *
 * @example
 * _.hasLength( {} );
 * // returns false
 *
 * @returns { boolean } Returns true if {-srcMap-} has the property (length).
 * @function hasLength
 * @namespace Tools
 */

function hasLength( src )
{
  if( src === undefined || src === null )
  return false;
  if( _.number.is( src.length ) )
  return true;
  return false;
}

// --
// extension
// --

var Extension =
{

  hasLength,

}

//

Object.assign( _.vector, Extension );

})();

( function _Uris_s_()
{

'use strict';

/**
 *  */

/**
 * Collection of cross-platform routines to operate multiple uris in the reliable and consistent way.
 * @namespace wTools.uri.s
 * @extends Tools.uri
 * @module Tools/base/Uri
 */

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  require( '../l4/Uri.s' );

}

//

const _ = _global_.wTools;
const Parent = _.uri;
// const Self = _.uri.s = _.uri.s || Object.create( Parent );
const Self = _.uris = _.uri.s = _.uris || _.uri.s || Object.create( Parent );

// --
// functors
// --

let _vectorize = _.path.s._vectorize;
let _vectorizeOnly = _.path.s._vectorizeOnly;

// function _keyEndsUriFilter( e,k,c )
// {
//   _.assert( 0, 'not tested' );
//
//   if( _.strIs( k ) )
//   {
//     if( _.strEnds( k,'Uri' ) )
//     return true;
//     else
//     return false
//   }
//   return this.is( e );
// }
//
// //
//
// function _isUriFilter( e )
// {
//   return this.is( e[ 0 ] )
// }

// //
//
// function _vectorize( routine, select )
// {
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( _.strIs( routine ) );
//   select = select || 1;
//   return _.routineVectorize_functor
//   ({
//     routine : [ 'single', routine ],
//     vectorizingArray : 1,
//     vectorizingMapVals : 0,
//     vectorizingMapKeys : 1,
//     select,
//   });
// }
//
// //
//
// function _vectorizeOnly( routine )
// {
//   _.assert( arguments.length === 1 );
//   _.assert( _.strIs( routine ) );
//   return _.routineVectorize_functor
//   ({
//     routine : [ 'single', routine ],
//     propertyCondition : _keyEndsUriFilter,
//     vectorizingArray : 1,
//     vectorizingMapVals : 1,
//   });
// }

/**
 * @summary Parses uris from array `src`. Writes results into array.
 * @param {Array|String} src
 * @example
 * _.uri.s.parse( [ '/a', 'https:///stackoverflow.com' ] );
 * @returns {Array} Returns array with results of parse operation.
 * @function parse
 * @module Tools/base/Uri.wTools
 * @namespace uri.s
 */

/**
 * @summary Parses uris from array `src`. Looks only for atomic components of the uri. Writes results into array.
 * @description Atomic components: protocol,host,port,resourcePath,query,hash.
 * @param {Array|String} src
 * @example
 * _.uri.s.parseAtomic( [ '/a', 'https:///stackoverflow.com' ] );
 * @returns {Array} Returns array with results of parse operation.
 * @function parseAtomic
 * @module Tools/base/Uri.wTools
 * @namespace uri.s
 */

/**
 * @summary Parses uris from array `src`. Looks only for consecutive components of the uri. Writes results into array.
 * @description Consecutive components: protocol,longPath,query,hash.
 * @param {Array|String} src
 * @example
 * _.uri.s.parseConsecutive( [ '/a', 'https:///stackoverflow.com' ] );
 * @returns {Array} Returns array with results of parse operation.
 * @function parseConsecutive
 * @module Tools/base/Uri.wTools
 * @namespace uri.s
 */

/**
* @summary Assembles uris from array of components( src ).
* @param {Array|Object} src
* @example
* _.uri.s.str( [ { resourcePath : '/a' }, { protocol : 'http', resourcePath : '/a' } ] );
* //['/a', 'http:///a' ]
* @returns {Array} Returns array of strings, each element represent a uri.
* @function str
* @module Tools/base/Uri.wTools
* @namespace uri.s
*/

/**
 * @summary Complements current window uri origin with array of components.
 * @param {Array|Object} src
 * @example
 * _.uri.s.full( [ { resourcePath : '/a' }, { protocol : 'http', resourcePath : '/a' } ] );
 * @returns {Array} Returns array of strings, each element represent a uri.
 * @function full
 * @module Tools/base/Uri.wTools
 * @namespace uri.s
 */

// --
// implementation
// --

let Extension =
{

  // _keyEndsUriFilter,
  // _isUriFilter,
  //
  // _vectorize,
  // _vectorizeOnly,

  //

  parse : _vectorize( 'parse' ),
  parseAtomic : _vectorize( 'parseAtomic' ),
  parseConsecutive : _vectorize( 'parseConsecutive' ),

  onlyParse : _vectorizeOnly( 'parse' ),
  onlyParseAtomic : _vectorizeOnly( 'parseAtomic' ),
  onlyParseConsecutive : _vectorizeOnly( 'parseConsecutive' ),

  str : _vectorize( 'str' ),
  full : _vectorize( 'full' ),

  normalizeTolerant : _vectorize( 'normalizeTolerant' ),
  onlyNormalizeTolerant : _vectorizeOnly( 'normalizeTolerant' ),

  rebase : _vectorize( 'rebase', 3 ),

  documentGet : _vectorize( 'documentGet', 2 ),
  server : _vectorize( 'server' ),
  query : _vectorize( 'query' ),
  dequery : _vectorize( 'dequery' ),

  //

  uri : Parent,

}

_.mapExtendDstNotOwn( Self, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

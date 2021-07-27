( function _WebUri_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to operate web URIs ( URLs ) in the reliable and consistent way. Module WebUri extends Uri module to handle host and port parts of URI in a way appropriate for world wide web resources. This module leverages parsing, joining, extracting, normalizing, nativizing, resolving paths. Use the module to get uniform experience from playing with paths on different platforms.
  @module Tools/base/WebUri
*/

/**
 * Collection of cross-platform routines to operate web URIs ( URLs ) in the reliable and consistent way.
  @namespace wTools.weburi
  @extends Tools
  @module Tools/base/WebUri
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wPathBasic' );
  _.include( 'wUriBasic' );

}

//

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.uri;
const Self = _.weburi = _.weburi || Object.create( Parent );

// --
//
// --

/**
 * @summary Checks if argument `path` is a absolute path.
 * @param {String} path Source path.
 * @returns {Boolean} Returns true if provided path is absolute.
 * @function isAbsolute
 * @module Tools/base/WebUri
 * @namespace Tools.weburi
 */

function isAbsolute( path )
{
  let parent = this.path;
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ), 'Expects string' );
  if( this.isGlobal( path ) )
  return true;
  return parent.isAbsolute( path );
}

//

/**
 * @summary Joins a sequence of paths into single web uri.
 * @param {...String} path Source paths.
 * @example
 * _.weburi.join( 'http://www.site.com:13','a','http:///dir','b' );
 * //'http://www.site.com:13/dir/b'
 * @returns {String} Returns normalized new web uri.
 * @function join
 * @module Tools/base/WebUri
 * @namespace Tools.weburi
 */

let join = Parent.join_functor( 'join', 1 );

//

// function join_head( routine, args )
// {
//   let o = args[ 0 ];
//
//   if( !_.mapIs( o ) )
//   o = { args };
//   else
//   _.assert( args.length === 1, 'Expects single options map {-o-}' );
//
//   _.routine.options_( routine, o );
//   _.assert( _.strIs( o.routineName ) );
//
//   return o;
// }

//

function join_body( o )
{
  let self = this;
  let parent = self.path;
  let isGlobal = false;

  /* */

  let srcs = pathsParseAtomicAndSetIsGlobal( o.args );
  let result = resultMapMake( srcs );

  if( !isGlobal )
  return result.resourcePath;

  if( ( result.hash || result.tag ) && result.longPath )
  result.longPath = parent.detrail( result.longPath );

  return self.str( result );

  /* */

  function pathsParseAtomicAndSetIsGlobal( args )
  {
    let result = _.array.make( args.length );

    for( let s = 0 ; s < args.length ; s++ )
    {
      if( args[ s ] !== null && self.isGlobal( args[ s ] ) )
      {
        isGlobal = true;
        result[ s ] = self.parseAtomic( args[ s ] );
      }
      else
      {
        isGlobal = args[ s ] !== null;
        result[ s ] = { resourcePath : args[ s ] };
      }
    }

    return result;
  }

  /* */

  function resultMapMake( srcs )
  {
    let result = Object.create( null );
    result.resourcePath = undefined;

    for( let s = srcs.length - 1 ; s >= 0 ; s-- )
    {
      let src = srcs[ s ];
      let hostWas = result.host;

      if( result.protocol && src.protocol )
      if( result.protocol !== src.protocol )
      continue;

      if( !result.protocol && src.protocol !== undefined )
      result.protocol = src.protocol;

      if( !result.user && src.user !== undefined )
      result.user = src.user;

      if( !result.host && src.host !== undefined )
      result.host = src.host;

      if( !result.port && src.port !== undefined )
      if( !hostWas || !src.host || hostWas === src.host )
      result.port = src.port;

      if( !result.resourcePath && src.resourcePath !== undefined )
      result.resourcePath = src.resourcePath;
      else if( src.resourcePath )
      result.resourcePath = parent[ o.routineName ]( src.resourcePath, result.resourcePath );

      if( src.resourcePath === null )
      break;

      if( src.query !== undefined )
      if( result.query )
      result.query = src.query + '&' + result.query;
      else
      result.query = src.query;

      if( !result.hash && src.hash !==undefined )
      result.hash = src.hash;

      if( !result.tag && src.tag !==undefined )
      result.tag = src.tag;
    }

    return result;
  }
}

join_body.defaults =
{
  routineName : 'join',
  args : null,
};

//

let join_ = _.routine.uniteCloning_replaceByUnite( Parent.join_.head, join_body );

/**
 * @summary Joins a sequence of paths into single web uri.
 * @param {...String} path Source paths.
 * @example
 * _.weburi.joinRaw( 'http://www.site.com:13','a','http:///dir///','b' );
 * //'http://www.site.com:13/dir////b'
 * @returns {String} Returns new web uri withou normalization.
 * @function joinRaw
 * @module Tools/base/WebUri
 * @namespace Tools.weburi
 */

let joinRaw = Parent.join_functor( 'joinRaw', 1 );

//

let joinRaw_ = _.routine.uniteCloning_replaceByUnite( Parent.joinRaw_.head, join_body );
joinRaw_.defaults.routineName = 'joinRaw';

//

// let urisJoin = _.path._pathMultiplicator_functor
// ({
//   routine : join,
// });

//

function current()
{
  _.assert( arguments.length === 0, 'Expects no arguments.' );
  return this.upToken;
}

//

//
//
// function resolve()
// {
//   let parent = this.path;
//   let result = Object.create( null );
//   let srcs = [];
//   let parsed = false;
//
//   for( let s = 0 ; s < arguments.length ; s++ )
//   {
//     if( this.isGlobal( arguments[ s ] ) )
//     {
//       parsed = true;
//       srcs[ s ] = this.parseConsecutive( arguments[ s ] );
//     }
//     else
//     {
//       srcs[ s ] = { longPath : arguments[ s ] };
//     }
//   }
//
//   for( let s = 0 ; s < srcs.length ; s++ )
//   {
//     let src = srcs[ s ];
//
//     if( !result.protocol && src.protocol !== undefined )
//     result.protocol = src.protocol;
//
//     // if( !result.host && src.host !== undefined )
//     // result.host = src.host;
//     //
//     // if( !result.port && src.port !== undefined )
//     // result.port = src.port;
//
//     if( !result.longPath && src.longPath !== undefined )
//     {
//       if( !_.strDefined( src.longPath ) )
//       src.longPath = this.rootToken;
//
//       result.longPath = src.longPath;
//     }
//     else
//     {
//       result.longPath = parent.resolve( result.longPath, src.longPath );
//     }
//
//     if( src.query !== undefined )
//     if( !result.query )
//     result.query = src.query;
//     else
//     result.query = src.query + '&' + result.query;
//
//     if( !result.hash && src.hash !==undefined )
//     result.hash = src.hash;
//
//   }
//
//   if( !parsed )
//   return result.longPath;
//
//   return this.str( result );
// }

//

/**
 * @summary Resolves a sequence of paths or path segments into web uri.
 * @description
 * The given sequence of paths is processed from right to left,with each subsequent path prepended until an absolute
 * path is constructed. If after processing all given path segments an absolute path has not yet been generated,
 * the current working directory is used.
 * @param {...String} path Source paths.
 * @example
 * _.weburi.resolve( 'http://www.site.com:13','a/../' );
 * //'http://www.site.com:13/'
 * @returns {String} Returns new web uri withou normalization.
 * @function resolve
 * @module Tools/base/WebUri
 * @namespace Tools.weburi
 */

function resolve()
{
  let self = this;
  let parent = self.path;
  let joined = self.join.apply( self, arguments );
  let parsed = self.parseAtomic( joined );
  if( parsed.resourcePath )
  parsed.resourcePath = parent.resolve.call( self, parsed.resourcePath );
  // parsed.resourcePath = parent.resolve( parsed.resourcePath ); /* Dmytro : the context of resolving should be a WebUri, not Path */
  return self.str( parsed );
}

//

// let urisResolve = _.path._pathMultiplicator_functor
// ({
//   routine : resolve,
// });

// --
// extension
// --

let Extension =
{

  isAbsolute,

  join,
  join_, /* !!! : use instead of join */ /* Dmytro : separate implementation, it has less if branches */
  joinRaw,
  joinRaw_, /* !!! : use instead of joinRaw */ /* Dmytro : separate implementation, it has less if branches */
  // urisJoin,

  current,

  resolve,
  // urisResolve,

  // extension

  single : Self,

}

_.mapExtendDstNotOwn( Self, Extension );

Self.Init();

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

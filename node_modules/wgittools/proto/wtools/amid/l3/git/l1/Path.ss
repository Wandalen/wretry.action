( function _Path_ss_()
{

'use strict';

const _ = _global_.wTools;
const Parent = _.uri;
_.git.path = _.git.path || Object.create( Parent );

// --
//
// --

/**
 * Routine parse() parse string path into components.
 * Routine supports three modes of parsing : full, atomic, objects.
 * By default mode `full` is used.
 *
 * @example
 * var srcPath = 'git+https:///github.com/user.repo.git/!alpha';
 * _.git.path.parse( srcPath );
 * // returns
 * // {
 * //   protocol : 'git+https',
 * //   longPath : '/github.com/user/repo.git/',
 * //   tag : 'alpha',
 * //   localVcsPath : './',
 * //   protocols : [ 'git', 'https' ],
 * //   isFixated : false,
 * //   service : 'github.com',
 * //   user : 'user',
 * //   repo : 'repo',
 * // };
 *
 * @example
 * var srcPath = 'git+https:///github.com/user.repo.git/!alpha';
 * _.git.path.parse({ remotePath : srcPath, full : 0, atomic : 1 });
 * // returns
 * // {
 * //   protocol : 'git+https',
 * //   tag : 'alpha',
 * //   localVcsPath : './',
 * //   service : 'github.com',
 * //   user : 'user',
 * //   repo : 'repo',
 * //   isGlobal : true,
 * // };
 *
 * @example
 * var srcPath = 'git+https:///github.com/user.repo.git/!alpha';
 * _.git.path.parse({ remotePath : srcPath, full : 0, atomic : 0, objects : 1 });
 * // returns
 * // {
 * //   service : 'github.com',
 * //   user : 'user',
 * //   repo : 'repo',
 * // };
 *
 * First parameter set :
 * @param { String } remotePath - String path.
 * Second parameter set :
 * @param { Aux } o - Options map.
 * @param { String|Aux } o.remotePath - Path to parse.
 * @param { BoolLike } o.full - Enables full parsing. Default is 1.
 * @param { BoolLike } o.full - Enables atomic parsing. Default is 0.
 * @param { BoolLike } o.objects - Enables parsing of objects. Default is 1.
 * @returns { Map } - Returns map with parsed path.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-remotePath-} has incompatible type.
 * @throws { Error } If options map {-o-} has incompatible type.
 * @throws { Error } If options map {-o-} has unknown option.
 * @throws { Error } If options map {-o-} has conflicting options or no options for parsing.
 * @throws { Error } If {-remotePath-} has tag and version simultaneously.
 * @function parse
 * @module Tools/GitTools
 * @namespace Tools.git.path
 */

function parse_head( routine, args )
{
  let o = args[ 0 ];

  _.assert( args.length === 1, 'Expects single options map {-o-}' );

  if( _.strIs( o ) )
  o = { remotePath : o };

  _.routine.options_( parse, o );
  _.assert( _.strIs( o.remotePath ) || _.mapIs( o.remotePath ), 'Expects file path {-o.remotePath-}' );
  _.assert
  (
    ( !o.full || !o.atomic )
    || ( !o.full && !o.atomic ),
    'Expects only full parsing with {-o.full-} or atomic parsing with {-o.atomic-} but not both'
  );

  return o;
}

//

function parse_body( o )
{
  if( _.mapIs( o.remotePath ) )
  return o.remotePath;


  let result = pathParse( o.remotePath, o.full );
  let objects = objectsParse( result.longPath, result.protocol );

  result = _.props.extend( result, objects );

  if( o.full )
  return result;
  else if( o.atomic )
  return pathAtomicMake( result );
  else if( o.objects )
  return objects;
  else
  throw _.err( 'Routine should return some parsed path, but options set to return nothing' )

  /* */

  function pathParse( remotePath, full )
  {
    let result = Object.create( null );

    let parsed1 = _.uri.parseConsecutive( remotePath );
    _.props.extend( result, parsed1 );

    if( !result.tag && !result.hash )
    result.tag = 'master';

    _.assert( !result.tag || !result.hash, 'Remote path:', _.strQuote( remotePath ), 'should contain only hash or tag, but not both.' )

    let isolated = pathIsolateGlobalAndLocal( parsed1 );
    result.longPath = isolated.globalPath;
    result.localVcsPath = isolated.localPath;

    if( !full )
    return result;

    /* remoteVcsPath */

    let parsed2 = Object.create( null );
    result.protocols = parsed2.protocols = parsed1.protocol ? parsed1.protocol.split( '+' ) : [];

    // let isHardDrive = _.longHasAny( result.protocols, [ 'hd' ] );
    //
    // parsed2.longPath = isolated.globalPath;
    // if( !isHardDrive )
    // parsed2.longPath = _.strRemoveBegin( parsed2.longPath, '/' );
    // parsed2.longPath = _.strRemoveEnd( parsed2.longPath, '/' );
    //
    // let protocols = _.longSlice( parsed2.protocols );
    // parsed2.protocols = _.arrayRemovedArrayOnce( protocols, [ 'git', 'hd' ] );
    // result.remoteVcsPath = _.uri.str( parsed2 );
    //
    // if( isHardDrive )
    // result.remoteVcsPath = _.fileProvider.path.nativize( result.remoteVcsPath );
    //
    // /* remoteVcsLongerPath */
    //
    // let parsed3 = Object.create( null );
    // parsed3.longPath = parsed2.longPath;
    // parsed3.protocols = protocols;
    // result.remoteVcsLongerPath = _.uri.str( parsed3 );
    //
    // if( isHardDrive )
    // result.remoteVcsLongerPath = _.fileProvider.path.nativize( result.remoteVcsLongerPath );

    /* */

    result.isFixated = _.git.path.isFixated( result );

    _.assert( !_.boolLike( result.hash ) );

    return result;
  }

  /* */

  function pathIsolateGlobalAndLocal( parsedPath )
  {
    let splits = _.strIsolateLeftOrAll( parsedPath.longPath, '.git/' );
    if( parsedPath.query )
    {
      let query = _.strStructureParse
      ({
        src : parsedPath.query,
        keyValDelimeter : '=',
        entryDelimeter : '&'
      });
      if( query.out )
      splits[ 2 ] = _.uri.join( splits[ 2 ], query.out );
    }
    let globalPath = splits[ 0 ] + ( splits[ 1 ] || '' );
    let localPath = _.strRemoveBegin( splits[ 2 ], _.uri.rootToken ) || './';
    return { globalPath, localPath };
  }

  /* */

  function objectsParse( remotePath, protocol )
  {
    let objects = Object.create( null );
    let objectsRegexp;
    if( protocol && ( _.strHas( protocol, 'http' ) || _.strHas( protocol, 'ssh' ) ) )
    objectsRegexp = /([a-zA-Z0-9-_]+\.[a-zA-Z0-9-_]+)\/([a-zA-Z0-9-_.]+)\/([a-zA-Z0-9-_.]+)/;
    else if( protocol === undefined || _.strHas( protocol, 'git' ) )
    objectsRegexp = /([a-zA-Z0-9-_.]+\.[a-zA-Z0-9-_.]+):([a-zA-Z0-9-_.]+)\/([a-zA-Z0-9-_.]+)/
    else
    return objects;

    let match = remotePath.match( objectsRegexp );
    if( match )
    {
      objects.service = match[ 1 ];
      objects.user = match[ 2 ];
      objects.repo = _.strRemoveEnd( match[ 3 ], '.git' );
    }

    return objects;
  }

  /* */

  function pathAtomicMake( parsedPath )
  {
    if( parsedPath.protocol && _.strHas( parsedPath.protocol, 'hd' ) )
    return parsedPath;

    const butMap = { longPath : null };
    if( _.strBegins( parsedPath.longPath, '/' ) )
    parsedPath.isGlobal = true;
    return _.mapBut_( parsedPath, parsedPath, butMap );
  }
}

parse_body.defaults =
{
  remotePath : null,
  full : 1,
  atomic : 0,
  objects : 1,
};

//

let parse = _.routine.uniteCloning_replaceByUnite( parse_head, parse_body );

//

/**
 * Routine str() assembles path string from components.
 *
 * @example
 * let parsed =
 * {
 *   protocol : 'git+https',
 *   tag : 'alpha',
 *   localVcsPath : './',
 *   service : 'github.com',
 *   user : 'user',
 *   repo : 'repo',
 *   isGlobal : true,
 * };
 * _.git.path.str( parsed );
 * // returns : 'git+https:///github.com/user.repo.git!alpha'
 *
 * @param { Aux|String } srcPath - Map with parsed path components.
 * @returns { String } - Returns path string.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-srcPath-} has incompatible type.
 * @function str
 * @module Tools/GitTools
 * @namespace Tools.git.path
 */

function str( srcPath )
{
  _.assert( arguments.length === 1, 'Expects single argument {-srcPath-}' );

  if( _.strIs( srcPath ) )
  return srcPath;

  _.assert( _.mapIs( srcPath ), 'Expects map with parsed path to construct string' );

  let result = '';
  let isParsedAtomic = srcPath.isFixated === undefined && srcPath.protocols === undefined;

  // if( isParsedAtomic && srcPath.protocol === undefined && srcPath.localVcsPath === undefined )
  // throw _.err( 'Cannot create path from objects. Not enough information about protocols' );

  if( srcPath.protocol )
  result += srcPath.protocol + '://';
  if( srcPath.longPath )
  result += srcPath.longPath;

  if( isParsedAtomic )
  {
    if( srcPath.protocol && srcPath.protocol !== 'git' && !_.strHas( srcPath.protocol, 'ssh' ) )
    {
      if( srcPath.service )
      result += srcPath.isGlobal ? '/' + srcPath.service : srcPath.service;
      if( srcPath.user )
      result = _.uri.join( result, srcPath.user );
    }
    else
    {
      let prefix = srcPath.isGlobal ? '/' : ''
      let postfix = ( srcPath.protocol && _.strHas( srcPath.protocol, 'ssh' ) ) ? '/' : ':'
      if( srcPath.service )
      result += `${ prefix }git@${ srcPath.service }${ postfix }`;
      if( srcPath.user )
      result += srcPath.user;
    }

    if( srcPath.repo )
    result = _.uri.join( result, `${ srcPath.repo }.git` );
  }

  if( srcPath.localVcsPath && srcPath.localVcsPath !== './' )
  if( srcPath.query === undefined )
  result += ( _.strEnds( result, '/' ) ? '' : '/' ) + srcPath.localVcsPath;
  if( srcPath.query )
  result += _.uri.queryToken + srcPath.query;
  if( srcPath.tag )
  result += srcPath.tag === 'master' ? '' : _.uri.tagToken + srcPath.tag;
  if( srcPath.hash )
  result += _.uri.hashToken + srcPath.hash;

  return result;
}

//

/**
 * Routine normalize() transform provided string path {-srcPath-} to normalized form.
 * Normalized form is global git path with protocols included part `git`.
 * For remote path it looks like:
 * git[+protocol]:///[service]/[user]/[repo]/[query][tag|hash]
 *
 * @example
 * _.git.path.normalize( 'https://github.com/user.repo.git/!alpha' );
 * // returns : 'git+https:///github.com/user.repo.git/!alpha'
 *
 * @param { String } srcPath - Path to normalize.
 * @returns { String } - Returns normalized path.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-srcPath-} has incompatible type.
 * @function normalize
 * @module Tools/GitTools
 * @namespace Tools.git.path
 */

function normalize( srcPath )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( srcPath ), 'Expects string path {-srcPath-}' );

  let parsed = _.git.path.parse( srcPath );

  _.assert( !!parsed.longPath );

  if( parsed.protocol )
  {
    let match = parsed.protocol.match( /(\w+)$/ );
    let postfix = match[ 0 ] === 'git' ? `` : `+${ match[ 0 ] }`;
    parsed.protocol = `git` + postfix;
  }
  else
  {
    if( _.strHas( parsed.longPath, 'git@' ) )
    parsed.protocol = 'git';
    else
    parsed.protocol = 'git+hd';
  }

  parsed.longPath = _.uri.join( _.uri.rootToken, parsed.longPath );
  parsed.longPath = _.uri.normalize( parsed.longPath );
  return _.git.path.str( parsed );
}

// //
//
// function remotePathNormalize( remotePath )
// {
//   if( remotePath === null )
//   return remotePath;
//
//   remotePath = remotePath.replace( /^(\w+):\/\//, 'git+$1://' );
//   remotePath = remotePath.replace( /:\/\/\b/, ':///' );
//
//   return remotePath;
// }

//

/**
 * Routine nativize() transform provided string path {-srcPath-} to nativized for utility Git form.
 * For remote path it looks like:
 * [protocol]://[service]/[user]/[repo]
 *
 * @example
 * _.git.path.nativize( 'git+https:///github.com/user.repo.git/!alpha' );
 * // returns : 'https://github.com/user.repo.git'
 *
 * @param { String } srcPath - Path to nativize.
 * @returns { String } - Returns nativized path.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-srcPath-} has incompatible type.
 * @function nativize
 * @module Tools/GitTools
 * @namespace Tools.git.path
 */

function nativize( srcPath )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( srcPath ), 'Expects string path {-srcPath-}' );

  let parsed = _.git.path.parse( srcPath );

  _.assert( !!parsed.longPath );

  if( parsed.protocol )
  parsed.protocol = parsed.protocol.replace( /^git\+(\w+)/, '$1' );
  if( !parsed.protocol || parsed.protocol === 'git' )
  parsed.protocol = '';
  if( _.longHas( _.fileProvider.protocols, parsed.protocol ) )
  parsed.protocol = '';
  // parsed.protocol = 'git';

  parsed.longPath = _.uri.normalize( parsed.longPath );

  if( _.longHasAny( parsed.protocols, _.fileProvider.protocols ) )
  {
    parsed.longPath = _.uri.nativize( parsed.longPath );
    if( parsed.query )
    parsed.query = _.uri.nativize( parsed.query );
  }
  else
  {
    parsed.longPath = _.strRemoveBegin( parsed.longPath, '/' );
  }

  return _.git.path.str( parsed );
}

// //
//
// function remotePathNativize( remotePath )
// {
//   if( remotePath === null )
//   return remotePath;
//
//   remotePath = remotePath.replace( /^git\+(\w+):\/\//, '$1://' );
//   remotePath = remotePath.replace( /:\/\/\/\b/, '://' );
//
//   return remotePath;
// }

//

/**
 * Routine refine() transform provided string path {-srcPath-}.
 * Routine refines up tokens in path.
 * Works on local hard drive path.
 *
 * @example
 * _.git.path.refine( 'hd:\\some\local\repo' );
 * // returns : 'hd://some/local/repo'
 *
 * @param { String } srcPath - Path to refine.
 * @returns { String } - Returns refined path.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-srcPath-} has incompatible type.
 * @function refine
 * @module Tools/GitTools
 * @namespace Tools.git.path
 */

function refine( srcPath )
{
  _.assert( arguments.length === 1, 'Expects single path {-srcPath-}' );
  _.assert( _.strIs( srcPath ), 'Expects string path {-srcPath-}' );

  let parsed = _.git.path.parse( srcPath );
  parsed.longPath = _.path.refine( parsed.longPath );
  return _.git.path.str( parsed );
}

//

/**
 * Routine isFixated() checks that provided string path {-srcPath-} has a valid version ( hash ).
 *
 * @example
 * _.git.path.isFixated( 'git+https:///github.com/user.repo.git' );
 * // returns : false
 *
 * @example
 * _.git.path.isFixated( 'git+https:///github.com/user.repo.git/!alpha' );
 * // returns : false
 *
 * @example
 * _.git.path.isFixated( 'git+https:///github.com/user.repo.git/#ab6h2c8' );
 * // returns : true
 *
 * @param { String|Aux } srcPath - Path to check.
 * @returns { Boolean } - Returns true if path has valid version, otherwise, returns false.
 * @throws { Error } If {-srcPath-} has incompatible type.
 * @function isFixated
 * @module Tools/GitTools
 * @namespace Tools.git.path
 */

function isFixated( srcPath )
{
  let parsed = _.git.path.parse({ remotePath : srcPath, full : 0, atomic : 1 });

  if( !parsed.hash )
  return false;

  if( parsed.hash.length < 7 )
  return false;

  if( !/[0-9a-f]+/.test( parsed.hash ) )
  return false;

  return true;
}

//

/**
 * Routine fixate() changes hash in provided path {-o.remotePath-} to hash of latest available commit.
 *
 * @example
 * _.git.path.fixate( 'git+https:///github.com/user.repo.git' );
 * // returns : 'git+https://github.com/user.repo.git#abc6e1da8be34f69d24af6f90f323816a9d83f3b'
 *
 * First parameter set :
 * @param { String } srcPath - Path to fixate.
 * Second parameter set :
 * @param { Aux } o - Options map.
 * @param { String|Aux } o.srcPath - Path to fixate.
 * @param { Number } o.logger - Level of verbosity.
 * @returns { String } - Returns fixated path.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-srcPath-} has incompatible type.
 * @throws { Error } If options map {-o-} has incompatible type.
 * @throws { Error } If options map {-o-} has unknown option.
 * @function fixate
 * @module Tools/GitTools
 * @namespace Tools.git.path
 */

function fixate( o )
{

  if( !_.mapIs( o ) )
  o = { remotePath : o }
  _.routine.options_( fixate, o );
  // o = { remotePath : o };
  // _.routineOptions( fixate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let parsed = _.git.path.parse({ remotePath : o.remotePath });
  let latestVersion = _.git.remoteVersionLatest
  ({
    remotePath : o.remotePath,
    logger : o.logger,
  });

  let result = _.git.path.str
  ({
    protocol : parsed.protocol,
    longPath : parsed.longPath,
    hash : latestVersion,
  });

  return result;
}

var defaults = fixate.defaults = Object.create( null );
defaults.remotePath = null;
defaults.logger = 0;

// --
// declare
// --

let Extension =
{

  parse,

  str,

  normalize,
  nativize,
  refine,

  isFixated,
  fixate,

}

/* _.props.extend */Object.assign( _.git.path, Extension );

})();

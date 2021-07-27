( function _Namespace_ss_()
{

'use strict';

const _ = _global_.wTools;
_.git = _.git || Object.create( null );
let Ini = null;

// --
// dichotomy
//

/**
 * Routine stateIsHash() checks weather the input element {-src-} is a git version ( hash ).
 *
 * @example
 * _.git.stateIsHash( 'not a hash' );
 * // returns : false
 *
 * @example
 * _.git.stateIsHash( 'e862c547239662eb77989fd56ab0d56afa7d3ce6' );
 * // returns : false
 *
 * @example
 * _.git.stateIsHash( '#e862c547239662eb77989fd56ab0d56afa7d3ce6' );
 * // returns : true
 *
 * @example
 * _.git.stateIsHash( '#e86' );
 * // returns : false
 *
 * @example
 * _.git.stateIsHash( '#e862' );
 * // returns : true
 *
 * @param { * } src - An element to check.
 * @returns { Boolean } - Returns true if {-src-} is a String that begins with '#'
 * and length of hash is great or equal to 4 and less than 40. Otherwise, returns false.
 * @function stateIsHash
 * @throws { Error } If arguments.length is not equal to 1.
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function stateIsHash( src )
{
  _.assert( arguments.length === 1, 'Expects argument {-src-}' );

  if( !_.strIs( src ) || !_.strBegins( src, '#' ) )
  return false;

  return /^[a-fA-F0-9]{7,40}$/.test( _.strRemoveBegin( src, '#' ) );
}

//

/**
 * Routine stateIsTag() checks weather the input element {-src-} is a git tag ( branch or tag ).
 *
 * @example
 * _.git.stateIsTag( 'e862c547239662eb77989fd56ab0d56afa7d3ce6' );
 * // returns : false
 *
 * @example
 * _.git.stateIsTag( '#e862c547239662eb77989fd56ab0d56afa7d3ce6' );
 * // returns : true
 *
 * @example
 * _.git.stateIsTag( '#e86' );
 * // returns : false
 *
 * @example
 * _.git.stateIsTag( '#e862' );
 * // returns : true
 *
 * @param { * } src - An element to check.
 * @returns { Boolean } - Returns true if {-src-} is a String that begins with '#'
 * and length of hash is great or equal to 4 and less than 40. Otherwise, returns false.
 * @function stateIsTag
 * @throws { Error } If arguments.length is not equal to 1.
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function stateIsTag( src )
{
  _.assert( arguments.length === 1, 'Expects argument {-src-}' );

  return _.strIs( src ) && _.strBegins( src, '!' ) && src.length >= 2;
}

// --
// path
// --

// function objectsParse( remotePath )
// {
//   let result = Object.create( null );
//   let gitHubRegexp = /\:\/\/\/github\.com\/([a-zA-Z0-9-_.]+)\/([a-zA-Z0-9-_.]+)/;
//   // let gitHubRegexp = /\:\/\/\/github\.com\/(\w+)\/(\w+)(\.git)?/;
//   /* Dmytro : this regexp does not search dashes, maybe needs additional symbols */
//
//   // remotePath = this.remotePathNormalize( remotePath );
//   remotePath = _.git.path.normalize( remotePath );
//   let match = remotePath.match( gitHubRegexp );
//
//   if( match )
//   {
//     result.service = 'github.com';
//     result.user = match[ 1 ];
//     result.repo = _.strRemoveEnd( match[ 2 ], '.git' );
//   }
//
//   return result;
// }

// //
//
// /**
//  * @typedef {Object} RemotePathComponents
//  * @property {String} protocol
//  * @property {String} hash
//  * @property {String} longPath
//  * @property {String} localVcsPath
//  * @property {String} remoteVcsPath
//  * @property {String} remoteVcsLongerPath
//  * @namespace wTools.git
//  * @module Tools/mid/GitTools
//  */
//
// function pathParse( remotePath )
// {
//   let path = _.uri;
//   let result = Object.create( null );
//
//   if( _.mapIs( remotePath ) )
//   return remotePath;
//
//   _.assert( arguments.length === 1 );
//   _.assert( _.strIs( remotePath ) );
//   _.assert( path.isGlobal( remotePath ) )
//
//   /* */
//
//   let parsed1 = path.parseConsecutive( remotePath );
//   _.props.extend( result, parsed1 );
//
//   if( !result.tag && !result.hash )
//   result.tag = 'master';
//
//   _.assert( !result.tag || !result.hash, 'Remote path:', _.strQuote( remotePath ), 'should contain only hash or tag, but not both.' )
//
//   let isolated = pathIsolateGlobalAndLocal();
//   result.localVcsPath = isolated.localPath;
//
//   /* remoteVcsPath */
//
//   let ignoreComponents =
//   {
//     hash : null,
//     tag : null,
//     protocol : null,
//     query : null,
//     longPath : null
//   }
//   let parsed2 = _.mapBut_( null, parsed1, ignoreComponents );
//   let protocols = parsed2.protocols = parsed1.protocol ? parsed1.protocol.split( '+' ) : [];
//   let isHardDrive = false;
//   let provider = _.fileProvider;
//
//   if( protocols.length )
//   {
//     isHardDrive = _.longHasAny( protocols, [ 'hd' ] );
//     if( protocols[ 0 ].toLowerCase() === 'git' )
//     protocols.shift();
//     if( protocols.length && protocols[ 0 ].toLowerCase() === 'hd' )
//     protocols.shift();
//   }
//
//   parsed2.longPath = isolated.globalPath;
//   if( !isHardDrive )
//   parsed2.longPath = _.strRemoveBegin( parsed2.longPath, '/' );
//   parsed2.longPath = _.strRemoveEnd( parsed2.longPath, '/' );
//
//   result.remoteVcsPath = path.str( parsed2 );
//
//   if( isHardDrive )
//   result.remoteVcsPath = provider.path.nativize( result.remoteVcsPath );
//
//   /* remoteVcsLongerPath */
//
//   let parsed3 = _.mapBut_( null, parsed1, ignoreComponents );
//   parsed3.longPath = parsed2.longPath;
//   parsed3.protocols = parsed2.protocols.slice();
//   result.remoteVcsLongerPath = path.str( parsed3 );
//
//   if( isHardDrive )
//   result.remoteVcsLongerPath = provider.path.nativize( result.remoteVcsLongerPath );
//
//   /* */
//
//   result.isFixated = _.git.path.isFixated( result );
//
//   _.assert( !_.boolLike( result.hash ) );
//   return result
//
//   /* */
//
//   function pathIsolateGlobalAndLocal()
//   {
//     let splits = _.strIsolateLeftOrAll( parsed1.longPath, '.git/' );
//     if( parsed1.query )
//     {
//       let query = _.strStructureParse
//       ({
//         src : parsed1.query,
//         keyValDelimeter : '=',
//         entryDelimeter : '&'
//       });
//       if( query.out )
//       splits[ 2 ] = path.join( splits[ 2 ], query.out );
//     }
//     let globalPath = splits[ 0 ] + ( splits[ 1 ] || '' );
//     let localPath = splits[ 2 ] || './';
//     return { globalPath, localPath };
//   }
//
// }
//
// //
//
// function pathIsFixated( filePath )
// {
//   // let parsed = _.git.pathParse( filePath );
//   let parsed = _.git.path.parse({ remotePath : filePath, full : 0, atomic : 1 });
//
//   if( !parsed.hash )
//   return false;
//
//   if( parsed.hash.length < 7 )
//   return false;
//
//   if( !/[0-9a-f]+/.test( parsed.hash ) )
//   return false;
//
//   return true;
// }
//
// //
//
// /**
//  * @summary Changes hash in provided path `o.remotePath` to hash of latest commit available.
//  * @param {Object} o Options map.
//  * @param {String} o.remotePath Remote path.
//  * @param {Number} o.logger=0 Level of verbosity.
//  * @function pathFixate
//  * @namespace wTools.git
//  * @module Tools/mid/GitTools
//  */
//
// function pathFixate( o )
// {
//   let path = _.uri;
//
//   if( !_.mapIs( o ) )
//   o = { remotePath : o }
//   _.routine.options_( pathFixate, o );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   // let parsed = _.git.pathParse( o.remotePath );
//   let parsed = _.git.path.parse( o.remotePath );
//   let latestVersion = _.git.remoteVersionLatest
//   ({
//     remotePath : o.remotePath,
//     logger : o.logger,
//   });
//
//   let result = path.str
//   ({
//     protocol : parsed.protocol,
//     longPath : parsed.longPath,
//     hash : latestVersion,
//   });
//
//   return result;
// }
//
// var defaults = pathFixate.defaults = Object.create( null );
// defaults.remotePath = null;
// defaults.logger = 0;
//
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

function remotePathFromLocal( o )
{
  if( _.strIs( arguments[ 0 ] ) )
  o = { localPath : arguments[ 0 ] };

  o = _.routine.options_( remotePathFromLocal, o );

  let config = _.git.configRead( o.localPath );

  if( !config )
  throw _.err( `No git repository at ${o.localPath}` );

  if( !config[ 'remote "origin"' ] || !config[ 'remote "origin"' ].url )
  return null;

  let remotePath = config[ 'remote "origin"' ].url;

  // if( remotePath )
  // remotePath = this.remotePathNormalize( remotePath );
  if( remotePath )
  {
    if( isLocalClone( remotePath ) )
    {
      remotePath = _.git.path.parse( remotePath )
      remotePath.protocol = 'hd';
      remotePath = _.git.path.str( remotePath );
    }
    remotePath = _.git.path.normalize( remotePath );
  }

  return remotePath;

  //

  function isLocalClone( remotePath )
  {
    _.assert( _.strDefined( remotePath ) );
    let parsed = _.git.path.parse( remotePath );
    // let parsed = _.uri.parse( remotePath );
    if( parsed.user || parsed.protocols.length )
    return false;
    return !_.git.path.isGlobal( remotePath );
    // return !_.path.isGlobal( remotePath );
  }
}

remotePathFromLocal.defaults =
{
  localPath : null,
};

//

function insideRepository( o )
{
  return !!this.localPathFromInside( o );
}

var defaults = insideRepository.defaults = Object.create( null );
defaults.insidePath = null;

//

function localPathFromInside( o )
{
  let localProvider = _.fileProvider;
  let path = localProvider.path; /* Dmytro : should be local provider path */

  if( _.strIs( arguments[ 0 ] ) )
  o = { insidePath : o };

  _.routine.options_( localPathFromInside, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let paths = path.traceToRoot( o.insidePath );
  for( var i = paths.length - 1; i >= 0; i-- )
  if( _.git.isRepository({ localPath : paths[ i ] }) )
  return paths[ i ];

  return null;
}

var defaults = localPathFromInside.defaults = Object.create( null );
defaults.insidePath = null;

// --
// tag
// --

/**
 * Routine tagLocalChange() switches HEAD to defined tag {-o.tag-} in git repository located at {-o.localPath-}.
 *
 * @example
 * // if script is run in git repository with branch 'test'
 * let tag = _.git.tagLocalRetrive
 * ({
 *   localPath : _.path.current(),
 * });
 * console.log( tag );
 * // log : 'master'
 *
 * _.git.tagLocalChange
 * ({
 *   localPath : _.path.current(),
 *   tag : 'test',
 * });
 * let tag = _.git.tagLocalRetrive
 * ({
 *   localPath : _.path.current(),
 * });
 * console.log( tag );
 * // log : 'test'
 *
 * @param { Aux } o - Options map.
 * @param { String } o.localPath - Path to git repository on hard drive.
 * @param { String } o.tag - Tag to switch on.
 * @param { Number } o.logger - Level of verbosity. Default is 0.
 * @returns { Boolean } - Returns true if HEAD switched to tag {-o.tag-}, otherwise, returns false.
 * @function tagLocalChange
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If {-o.localPath-} is not a String with defined length.
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function tagLocalChange( o )
{
  if( !_.mapIs( o ) )
  o = { localPath : o };

  _.routine.options_( tagLocalChange, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let localTag = _.git.tagLocalRetrive
  ({
    localPath : o.localPath,
    logger : o.logger
  });

  if( localTag === false )
  return false;

  if( localTag === o.tag )
  return true;

  let start = _.process.starter
  ({
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    sync : 1,
    deasync : 0,
    outputCollecting : 1,
    currentPath : o.localPath,
  });

  let result = start( 'git status' );
  let localChanges = _.strHas( result.output, 'Changes to be committed' );

  if( localChanges )
  start( 'git stash' );

  start( 'git checkout ' + o.tag );

  if( localChanges )
  start( 'git pop' );

  return true;
}

var defaults = tagLocalChange.defaults = Object.create( null );
defaults.localPath = null;
defaults.tag = null
defaults.logger = 0;

//

/**
 * Routine tagLocalRetrive() returns tag of label HEAD ( current commit ) from git repository located at {-o.localPath-}.
 *
 * @example
 * // if script is run in git repository on branch 'master'
 * let tag = _.git.tagLocalRetrive
 * ({
 *   localPath : _.path.current(),
 *   detailing : 0,
 * });
 * console.log( tag );
 * // log : 'master'
 *
 * @example
 * // if script is run in git repository on branch 'master'
 * let tag = _.git.tagLocalRetrive
 * ({
 *   localPath : _.path.current(),
 *   detailing : 1,
 * });
 * console.log( tag );
 * // log :
 * // {
 * //   tag : 'master',
 * //   isTag : false,
 * //   isBranch : true,
 * // }
 *
 * @param { Aux } o - Options map.
 * @param { String } o.localPath - Path to git repository on hard drive.
 * @param { Number } o.logger - Level of verbosity. Default is 0.
 * @param { BoolLike } o.detailing - If {-o.detailing-} is true, result is map with tag description.
 * @returns { String|Map|Boolean } - Returns name of the tag or false if {-o.localPath-} is not a git repository.
 * If {-o.detailing-} is true, routine returns map with tag description.
 * @function tagLocalRetrive
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If {-o.localPath-} is not a String with defined length.
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function tagLocalRetrive( o )
{
  let localProvider = _.fileProvider;
  let path = _.git.path;
  // let path = localProvider.path;

  if( !_.mapIs( o ) )
  o = { localPath : o };

  _.routine.options_( tagLocalRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.localPath ), 'Expects local path' );

  if( !_.git.isRepository({ localPath : o.localPath }) )
  return false;

  let gitPath = path.join( o.localPath, '.git' );

  if( !localProvider.fileExists( gitPath ) )
  return false;

  let currentTag = localProvider.fileRead( path.join( gitPath, 'HEAD' ) );
  let r = /^ref: refs\/heads\/(.+)\s*$/;

  let found = r.exec( currentTag );
  if( found )
  {
    currentTag = found[ 1 ].trim();
  }
  else
  {
    let tag = _.git.repositoryVersionToTag
    ({
      localPath : o.localPath,
      version : currentTag.trim(),
      local : 1,
      remote : 0,
    });

    if( tag.length )
    currentTag = _.strIs( tag ) ? tag : tag[ 0 ];
    else
    currentTag = '';
  }

  // if( !found )
  // {
  //   let tag = _.git.repositoryVersionToTag
  //   ({
  //     localPath : o.localPath,
  //     version : currentTag.trim(),
  //     local : 1,
  //     remote : 0,
  //   });
  //
  //   if( !tag.length )
  //   currentTag = '';
  //   else
  //   currentTag = _.strIs( tag ) ? tag : tag[ 0 ];
  // }
  // else
  // {
  //   currentTag = found[ 1 ].trim();
  // }

  if( o.detailing )
  {
    let result = Object.create( null );
    result.tag = currentTag;
    result.isTag = !found && !!currentTag;
    result.isBranch = !!found;

    return result;
  }

  return currentTag;
}

var defaults = tagLocalRetrive.defaults = Object.create( null );
defaults.localPath = null;
defaults.logger = 0;
defaults.detailing = 0;

//

function tagExplain( o )
{
  let localProvider = _.fileProvider;
  let path = _.git.path;
  // let path = localProvider.path;

  if( !_.mapIs( o ) )
  o = { localPath : o };

  _.routine.options_( tagExplain, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.tag ), 'Expects tag' );
  _.assert( _.strIs( o.localPath ), 'Expects local path' );
  _.assert( _.strIs( o.remotePath ) || _.mapIs( o.remotePath ), 'Expects remote path' );

  if( !_.git.isRepository({ localPath : o.localPath }) )
  return false;

  let start = _.process.starter
  ({
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    sync : 1,
    deasync : 0,
    outputCollecting : 1,
    currentPath : o.localPath,
    throwingExitCode : 0
  });

  let remotePath = 'origin';
  if( o.remotePath )
  {
    let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 1, atomic : 0 });
    let remoteVcsPathParsed = _.mapBut_( null, parsed, { localVcsPath : null, tag : null, hash : null, query : null } );
    remoteVcsPathParsed.longPath = _.strRemoveEnd( parsed.longPath, '/' );
    let remoteVcsPath = _.git.path.str( remoteVcsPathParsed );
    remotePath = _.git.path.nativize( remoteVcsPath );
  }

  let result =
  {
    tag : o.tag,
    isBranch : null,
    isTag : null
  }

  if( o.local )
  {
    let localCheck = `git show-ref --tags --heads -- ${o.tag}`;
    if( check( localCheck ) )
    return result;
  }

  if( o.remote )
  {
    let remoteCheck = `git ls-remote --tags --refs --heads ${remotePath} -- ${o.tag}`;
    if( check( remoteCheck ) )
    return result;
  }

  /* Dmytro : change order in accordance to case where remote path is an hd path and simultaneously it is not a repository */
  // if( o.remote )
  // {
  //   let remoteCheck = `git ls-remote --tags --refs --heads ${remotePath} -- ${o.tag}`;
  //   if( check( remoteCheck ) )
  //   return result;
  // }
  //
  // if( o.local )
  // {
  //   let localCheck = `git show-ref --tags --heads -- ${o.tag}`;
  //   if( check( localCheck ) )
  //   return result;
  // }

  return false;

  function check( command )
  {
    let got = start( command );

    if( got.exitCode !== 0 && got.output )
    throw _.errOnce( `Exit code : ${got.exitCode}\n`, got.output );

    if( !got.output )
    return false;
    result.isTag = _.strHas( got.output, `refs/tags/${o.tag}` );
    result.isBranch = _.strHas( got.output, `refs/heads/${o.tag}` );
    return true;
  }
}

var defaults = tagExplain.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.local = 1;
defaults.remote = 1;
defaults.tag = null;
defaults.logger = 0;

// --
// version
// --

function versionLocalChange( o )
{
  if( !_.mapIs( o ) )
  o = { localPath : o };

  _.routine.options_( versionLocalChange, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let localVersion = _.git.localVersion
  ({
    localPath : o.localPath,
    logger : o.logger
  });

  if( !localVersion )
  return false;

  if( localVersion === o.version )
  return true;

  let start = _.process.starter
  ({
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    sync : 1,
    deasync : 0,
    outputCollecting : 1,
    currentPath : o.localPath,
  });

  let result = start( 'git status' );
  let localChanges = _.strHas( result.output, 'Changes to be committed' );

  if( localChanges )
  start( 'git stash' );

  start( 'git checkout ' + o.version );

  if( localChanges )
  start( 'git pop' );

  return true;
}

var defaults = versionLocalChange.defaults = Object.create( null );
defaults.localPath = null;
defaults.version = null
defaults.logger = 0;

//

function localVersion( o )
{
  let localProvider = _.fileProvider;
  let path = _.git.path;
  // let path = localProvider.path;

  if( !_.mapIs( o ) )
  o = { localPath : o };

  _.routine.options_( localVersion, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.localPath ), 'Expects local path' );

  if( !_.git.isRepository({ localPath : o.localPath }) )
  return '';

  let gitPath = path.join( o.localPath, '.git' );

  if( !localProvider.fileExists( gitPath ) )
  return '';

  let currentVersion = localProvider.fileRead( path.join( gitPath, 'HEAD' ) );
  let r = /^ref: refs\/heads\/(.+)\s*$/;

  let found = r.exec( currentVersion );
  if( found )
  currentVersion = found[ 1 ];

  currentVersion = currentVersion.trim() || null;

  if( o.detailing )
  {
    let result = Object.create( null );
    result.version = currentVersion;
    result.isHash = false;
    result.isBranch = false;

    if( result.version )
    {
      result.isHash = !found;
      result.isBranch = !result.isHash;
    }
    return result;
  }

  return currentVersion;
}

var defaults = localVersion.defaults = Object.create( null );
defaults.localPath = null;
defaults.logger = 0;
defaults.detailing = 0;

//

/**
 * @summary Returns hash of latest commit from git repository using its remote path `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path to git repository.
 * @param {Number} o.logger=0 Level of verbosity.
 * @function remoteVersionLatest
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function remoteVersionLatest( o )
{
  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routine.options_( remoteVersionLatest, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  // let parsed = _.git.pathParse( remotePath );
  let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 1, atomic : 0 });
  parsed = _.mapBut_( null, parsed, { localVcsPath : null, tag : null, hash : null, query : null } );
  parsed.longPath = _.strRemoveEnd( parsed.longPath, '/' );
  let remotePath = _.git.path.str( parsed );
  remotePath = _.git.path.nativize( remotePath );

  let start = _.process.starter
  ({
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    sync : 1,
    deasync : 0,
    outputCollecting : 1,
  });

  // let got = start( 'git ls-remote ' + parsed.remoteVcsLongerPath );
  let got = start( `git ls-remote ${ remotePath }` );
  let latestVersion = /([0-9a-f]+)\s+HEAD/.exec( got.output );
  if( !latestVersion || !latestVersion[ 1 ] )
  return null;

  latestVersion = latestVersion[ 1 ];

  return latestVersion;
}

var defaults = remoteVersionLatest.defaults = Object.create( null );
defaults.remotePath = null;
defaults.logger = 0;

//

/**
 * @summary Returns commit hash from remote path `o.remotePath`.
 * @description Returns hash of latest commit if no hash specified in remote path.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.logger=0 Level of verbosity.
 * @function remoteVersionCurrent
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function remoteVersionCurrent( o )
{
  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routine.options_( remoteVersionCurrent, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  // let parsed = _.git.pathParse( o.remotePath );
  let parsed = _.git.path.parse( o.remotePath );
  if( parsed.isFixated )
  return parsed.hash;

  return _.git.remoteVersionLatest( o );
}

var defaults = remoteVersionCurrent.defaults = Object.create( null );
defaults.remotePath = null;
defaults.logger = 0;

//

/**
 * @summary Checks if provided version `o.version` is a commit hash.
 * @description
 * Returns false if version is a branch name or tag.
 * There is a limitation. Result can be inaccurate if provided version is specified
 * in short form and commit doesn't exist in repository at `o.localPath`.
 * Use long form of version( SHA-1 ) to get accurate result.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to git repository.
 * @param {Number} o.sync=1 Controls execution mode.
 * @function versionIsCommitHash
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function versionIsCommitHash( o )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.routine.options_( versionIsCommitHash, o );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.version ) );

  let ready = _.take( null );
  let start = _.process.starter
  ({
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'shell',
    currentPath : o.localPath,
    throwingExitCode : 0,
    inputMirroring : 0,
    outputPiping : 0,
    ready
  });

  ready.then( () =>
  {
    if( !self.isRepository({ localPath : o.localPath }) )
    throw _.err( `Provided {-o.localPath-}: ${_.strQuote( o.localPath )} doesn't contain a git repository.` )
    return null;
  });

  start( `git rev-parse --symbolic-full-name ${o.version}` )

  ready.then( ( got ) =>
  {
    if( got.exitCode !== 0 || got.output && _.strHas( got.output, 'refs/' ) )
    return false;
    return true;
  });

  ready.catch( ( err ) =>
  {
    _.errAttend( err );
    throw _.err( 'Failed to check if provided version is a commit hash.\n', err );
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

versionIsCommitHash.defaults =
{
  localPath : null,
  version : null,
  sync : 1,
};

//

function versionsRemoteRetrive( o )
{
  _.routine.options_( versionsRemoteRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.localPath ) );

  let ready = _.process.start
  ({
    execPath : 'git',
    mode : 'spawn',
    currentPath : o.localPath,
    args :
    [
      'for-each-ref',
      'refs/remotes',
      '--format=%(refname:strip=3)'
    ],
    inputMirroring : 0,
    outputPiping : 0,
    outputCollecting : 1,
  });

  ready.finally( ( err, got ) =>
  {
    if( err )
    throw _.err( 'Can\'t retrive remote versions. Reason:', err );

    let result = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });
    return result.slice( 1 );
  });

  return ready;
}

var defaults = versionsRemoteRetrive.defaults = Object.create( null );
defaults.localPath = null;

//

function versionsPull( o )
{
  _.routine.options_( versionsPull, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  return _.git.versionsRemoteRetrive({ localPath : o.localPath })
  .then( ( versions ) =>
  {
    _.assert( _.arrayIs( versions ) && versions.length > 0 );

    let ready = _.take( null );
    let start = _.process.starter
    ({
      mode : 'shell',
      currentPath : o.localPath,
      ready,
    });
    _.each( versions, ( version ) => start( `git checkout ${version} && git pull` ) );

    return ready;
  })
}

var defaults = versionsPull.defaults = Object.create( null );
defaults.localPath = null;

// --
// dichotomy
// --

/**
 * @summary Returns true if local copy of repository `o.localPath` is up to date with remote repository `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to repository.
 * @param {String} o.remotePath Remote path to repository.
 * @param {Number} o.logger=0 Level of verbosity.
 * @function isUpToDate
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function isUpToDate( o )
{
  let localProvider = _.fileProvider;
  let path = localProvider.path;

  _.routine.options_( isUpToDate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let status = statusInit();

  /* Vova: used full:1 because repositoryHasTag expects remote path as full */
  let parsed = _.git.path.parse({ remotePath : o.remotePath, /* full : 0, atomic : 1 */ full : 1, atomic : 0 });

  let ready = _.Consequence();

  /* xxx : aaa : check mode. shell should be, probably */ /* Dmytro : the default mode is `shell` and commands passed to functors are shell commands */
  let start = _.process.starter
  ({
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    currentPath : o.localPath,
    mode : 'shell',
    ready,
  });

  /* xxx : aaa : check mode. shell should be, probably */ /* Dmytro : the default mode is `shell` and commands passed to functors are shell commands */
  let shell = _.process.starter
  ({
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    ready,
    mode : 'shell',
    currentPath : o.localPath,
    throwingExitCode : 0,
    outputCollecting : 1,
  });

  status.dirExists = localProvider.fileExists( o.localPath );

  if( !status.dirExists )
  return end( false );

  status.isRepository = localProvider.fileExists( path.join( o.localPath, '.git' ) );

  if( !status.isRepository )
  return end( false );

  status.isClonedFromRemote = isClonedFromRemote();

  if( !status.isClonedFromRemote )
  {
    ready.take( end( false ) );
    return ready.split();
  }

  ready.take( null );

  start( 'git fetch origin' );

  ready.finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( err );
    return null;
  });

  // shellAll
  // ([
  //   // 'git diff origin/master --quiet --exit-code',
  //   // 'git diff --quiet --exit-code',
  //   // 'git branch -v',
  //   'git status',
  // ]);

  shell( 'git status' );

  ready.then( ( got ) =>
  {
    let result = false;
    let detachedRegexp = /* /HEAD detached at (\w+)/ */ /(HEAD detached at (.+)|Not currently on any branch.)/;
    let detachedParsed = detachedRegexp.exec( got.output );
    // let versionLocal = _.git.tagLocalRetrive({ localPath : o.localPath, logger : o.logger });

    // if( detachedParsed )
    // {
    //   result = _.strBegins( parsed.hash, detachedParsed[ 1 ] );
    // }
    // else if( _.strBegins( parsed.hash, versionLocal ) )
    // {
    //   result = !_.strHasAny( got.output, [ 'Your branch is behind', 'have diverged' ] );
    // }

    /* qqq: find better way to check if hash is not a branch name */
    // if( parsed.hash && !parsed.isFixated )
    // throw _.err( `Remote path: ${_.color.strFormat( String( o.remotePath ), 'path' )} is fixated, but hash: ${_.color.strFormat( String( parsed.hash ), 'path' ) } doesn't look like commit hash.` )

    /* aaa: replace with versionIsCommitHash after testing */ /* Dmytro : replaced, the routine versionIsCommitHash is tested */
    // if( parsed.hash && !parsed.isFixated )
    if( parsed.hash && !_.git.versionIsCommitHash({ localPath : o.localPath, version : parsed.hash }) )
    throw _.err( `Remote path: ( ${_.color.strFormat( String( o.remotePath ), 'path' )} ) looks like path with tag, but defined as path with version. Please use ! instead of # to specify tag` );

    result = status.isHead = _.git.isHead
    ({
      localPath : o.localPath,
      tag : parsed.tag,
      hash : parsed.hash
    });

    if( o.differentiatingTags )
    if( result && parsed.tag )
    {
      /* Vova:
        Local repo is up to date with "real" remote tag ( not a branch ) only when local repo is in detached state and heads are same
        Next lines check last part of this rule.
      */
      let tagExplained = _.git.tagExplain
      ({
        localPath : o.localPath,
        remotePath : parsed,
        tag : parsed.tag
      });
      if( tagExplained.isTag )
      result = !!detachedParsed;
    }

    if( !result && parsed.tag )
    {
      status.repositoryHasTag = _.git.repositoryHasTag
      ({
        localPath : o.localPath,
        remotePath : parsed,
        tag : parsed.tag
      });

      if( !status.repositoryHasTag )
      {
        let remoteVcsPathParsed = _.mapBut_( null, parsed, { tag : null, hash : null, query : null } );
        let remoteVcsPath = _.git.path.str( remoteVcsPathParsed );
        throw _.err
        (
          `Specified tag: ${_.strQuote( parsed.tag )} doesn't exist in local and remote copy of the repository.\
          \nLocal path: ${_.color.strFormat( String( o.localPath ), 'path' )}\
          \nRemote path: ${_.color.strFormat( String( remoteVcsPath ), 'path' )}`
        );
      }
    }

    status.gitStatus = got.output;

    if( result && !detachedParsed )
    result = status.branchIsUpToDate = !_.strHasAny( got.output, [ 'Your branch is behind', 'have diverged' ] );

    if( o.logger && o.logger.verbosity > 0 )
    o.logger.log( o.remotePath, result ? 'is up to date' : 'is not up to date' );

    return end( result );
  });

  ready.finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( err );
    return arg;
  });

  return ready.split();

  /* */

  function statusInit()
  {
    let status = Object.create( null );
    status.dirExists = null;
    status.isRepository = null;
    status.isClonedFromRemote = null;
    status.isHead = null;
    status.branchIsUpToDate = null;
    status.originPath = null;
    status.hasOrigin = null;
    status.gitStatus = null;
    return status;
  }

  /* */

  function isClonedFromRemote()
  {
    let conf = _.git.configRead( o.localPath );

    status.hasOrigin = true;

    if( !conf || !conf[ 'remote "origin"' ] || !_.strIs( conf[ 'remote "origin"' ].url ) )
    {
      status.hasOrigin = false;
      return false;
    }

    status.originPath = conf[ 'remote "origin"' ].url;
    let originParsed = _.git.path.parse( status.originPath );

    // if( !_.strEnds( status.originPath, remoteVcsPath ) )
    if
    (
      parsed.service !== originParsed.service
      || parsed.user !== originParsed.user
      || parsed.repo !== originParsed.repo
    )
    return false;

    return true;
  }

  /* */

  function end( result )
  {
    status.result = result;

    if( !o.detailing )
    return result;

    if( result === false )
    {
      if( status.dirExists === false )
      status.reason = `Path does not exist: ${o.localPath}`;
      else if( status.isRepository === false )
      status.reason = `No git repository at: ${o.localPath}`;
      else if( status.hasOrigin === false )
      status.reason = `Repository does not have origin.`;
      else if( status.isClonedFromRemote === false )
      status.reason = `Repository has different origin.\nCurrent origin: ${status.originPath}\nRemote path: ${o.remotePath}`;
      else if( status.isHead === false )
      status.reason = `HEAD of the repository does not point to: ${parsed.tag ? `!${parsed.tag}` : `#${parsed.hash}`}`;
      else if( status.branchIsUpToDate === false )
      status.reason = `Current branch is not up-to-date with remote. Git status:\n${status.gitStatus}`;
    }

    return status;
  }
}

var defaults = isUpToDate.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.differentiatingTags = true;
defaults.logger = 0;
defaults.detailing = 0;

//

/**
 * @summary Returns true if path `o.localPath` contains a git repository.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {Number} o.logger=0 Level of verbosity.
 * @function hasFiles
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function hasFiles( o )
{
  let localProvider = _.fileProvider;

  _.routine.options_( hasFiles, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !localProvider.isDir( o.localPath ) )
  return false;
  if( !localProvider.dirIsEmpty( o.localPath ) )
  return true;

  return false;
}

var defaults = hasFiles.defaults = Object.create( null );
defaults.localPath = null;
// defaults.verbosity = 0; /* aaa : for Dmytro : why?? */ /* Dmytro : I don't know. I saw not this code. */

//

/**
 * @summary Returns true if path `o.localPath` contains a git repository that was cloned from remote `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.remotePath Remote path to package.
 * @param {Number} o.logger=0 Level of verbosity.
 * @function hasRemote
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function hasRemote( o )
{
  let localProvider = _.fileProvider;
  let path = _.git.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( hasRemote, o );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.remotePath ) );

  let ready = _.take( null );

  ready.then( () =>
  {
    let result = Object.create( null );
    result.downloaded = true;
    result.remoteIsValid = false;

    if( !localProvider.fileExists( o.localPath ) )
    {
      result.downloaded = false;
      return result;
    }

    let gitConfigExists = localProvider.fileExists( path.join( o.localPath, '.git/config' ) );

    if( !gitConfigExists )
    {
      result.downloaded = false;
      return result;
    }

    let config = _.git.configRead( o.localPath );

    let parsed = path.parse({ remotePath : o.remotePath, full : 0, atomic : 1 });
    let remoteVcsPathParsed = _.mapBut_( null, parsed, { tag : null, hash : null, query : null, localVcsPath : null } );
    let remoteVcsPath = path.str( remoteVcsPathParsed );
    remoteVcsPath = path.nativize( remoteVcsPath );

    let remoteOrigin = config[ 'remote "origin"' ];
    let originVcsPath = null;

    if( remoteOrigin ) /* qqq : for Dmytro : cover */
    {
      originVcsPath = path.normalize( remoteOrigin.url );
      originVcsPath = path.nativize( originVcsPath );
    }

    _.sure( _.strDefined( remoteVcsPath ) );
    _.sure( _.strDefined( originVcsPath ) || originVcsPath === null );

    result.remoteVcsPath = remoteVcsPath;
    result.originVcsPath = originVcsPath;
    if( originVcsPath === null )
    result.remoteIsValid = false;
    else
    result.remoteIsValid = path.trail( path.refine( originVcsPath ) ) === path.trail( path.refine( remoteVcsPath ) );

    return result;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = hasRemote.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.sync = 1;
// defaults.verbosity = 0;

//

function isRepository( o )
{
  let self = this;
  let path = _.git.path;
  // let path = _.uri;

  _.routine.options_( isRepository, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = _.Consequence.Try( () =>
  {
    if( o.localPath === null )
    return false;
    return _.fileProvider.fileExists( path.join( o.localPath, '.git/config' ) );
  });

  if( o.remotePath === null )
  return end();

  let remoteParsed = o.remotePath;

  ready.then( ( exists ) =>
  {
    if( !exists && o.localPath )
    return false;
    if( path.isGlobal( o.remotePath ) )
    {
      // remoteParsed = self.pathParse( o.remotePath ).remoteVcsPath;
      let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 1, atomic : 0 });
      let remoteVcsPathParsed = _.mapBut_( null, parsed, { localVcsPath : null, tag : null, hash : null, query : null } );
      remoteVcsPathParsed.longPath = _.strRemoveEnd( parsed.longPath, '/' );
      let remoteVcsPath = _.git.path.str( remoteVcsPathParsed );
      remoteParsed = _.git.path.nativize( remoteVcsPath );
    }

    return remoteIsRepository( remoteParsed );
  });

  ready.then( ( isRepo ) =>
  {
    if( !isRepo || o.localPath === null )
    return isRepo;

    return localHasRightOrigin();
  })

  return end();

  /* */

  function remoteIsRepository()
  {
    let ready = _.Consequence.Try( () =>
    {
      return _.process.start
      ({
        execPath : 'git ls-remote ' + remoteParsed,
        mode : 'shell', /* aaa : for Dmytro : why? random?? */ /* Dmytro : not random, we use `shell` for commands in all module, mode `spawn` has some old routines */
        throwingExitCode : 0,
        outputPiping : 0,
        stdio : 'ignore',
        sync : o.sync,
        deasync : 0,
        inputMirroring : 1,
        outputCollecting : 0
      });
    })
    ready.then( ( got ) =>
    {
      return got.exitCode === 0;
    });

    if( o.sync )
    return ready.syncMaybe();
    return ready;
  }

  /* */

  function localHasRightOrigin()
  {
    let config = configRead( o.localPath );
    let originPath = config[ 'remote "origin"' ].url
    if( !path.isGlobal( originPath ) )
    originPath = path.normalize( originPath )
    return originPath === remoteParsed;
  }

  /* */

  function end()
  {
    if( o.sync )
    return ready.syncMaybe();
    return ready;
  }
}

var defaults = isRepository.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.sync = 1;
// defaults.verbosity = 0;

//

/**
 * @summary Returns true if HEAD of repository located at `o.localPath` points to `o.hash` or `o.tag`.
 * Expects only `o.hash` or `o.tag` at same time.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.tag Target tag or branch name.
 * @param {String} o.hash Target commit hash.
 * @function isHead
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function isHead( o )
{
  let localProvider = _.fileProvider;
  let path = _.git.path;
  // let path = localProvider.path;

  _.routine.options_( isHead, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( !!o.tag || !!o.hash, 'Expects {-o.hash-} or {-o.tag-} to be defined.' );
  _.assert( !o.tag || !o.hash, 'Expects only {-o.hash-} or {-o.tag-}, but not both at same time.' );

  let ready = _.take( null );

  let shell = _.process.starter
  ({
    currentPath : o.localPath,
    throwingExitCode : 0,
    outputPiping : 0,
    sync : 0,
    deasync : 0,
    inputMirroring : 0,
    outputCollecting : 1
  });

  let head = null;
  let tag = null;

  ready.then( () => this.isRepository({ localPath : o.localPath }) )

  if( o.hash )
  ready.then( hashCheck )
  else if( o.tag )
  ready.then( tagCheck )

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /*  */

  function hashCheck( got )
  {
    if( !got )
    return false;

    return getHead()
    .then( ( head ) =>
    {
      if( !head )
      return false;
      return head === o.hash;
    })
  }

  function tagCheck( got )
  {
    if( !got )
    return false;

    return getHead()
    .then( ( head ) =>
    {
      if( !head )
      return false;
      return getTag();
    })
    .then( ( got ) =>
    {
      if( !got )
      return false;

      let result = head === got.hash;

      /* return result if we are checking tag or hash comparison result is negative */
      if( got.tag || !result )
      return result;

      /* compare branches in case when HEAD and target branch are on same commit */
      return getHead( true )
      .then( ( branchName ) =>
      {
        if( !branchName )
        return false;
        return got.branch === branchName;
      })
    })
  }

  function getHead( refName )
  {
    refName = refName ? '--abbrev-ref' : '';

    return shell({ execPath : `git rev-parse ${refName} HEAD`, ready : null })
    .then( ( got ) =>
    {
      if( got.exitCode )
      return false;
      head = _.strStrip( got.output );
      return head;
    })
  }

  function getTag()
  {
    return shell({ execPath : `git show-ref ${o.tag} -d --heads --tags`, ready : null })
    .then( ( got ) =>
    {
      if( got.exitCode )
      return false;
      let output = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });
      if( !output.length )
      return false;
      _.assert( output.length <= 2 );
      tag = output[ 0 ];
      if( output.length === 2 )
      {
        tag = output[ 1 ];
        _.assert( _.strHas( tag, '^{}' ), 'Expects annotated tag, got:', tag );
      }

      let isolated = _.strIsolateLeftOrAll( tag, ' ' );
      let result = Object.create( null );

      result.hash = isolated[ 0 ];
      result.ref = isolated[ 2 ];

      if( _.strBegins( result.ref, 'refs/heads/' ) )
      result.branch = _.strRemoveBegin( result.ref, 'refs/heads/' )
      else if( _.strBegins( result.ref, 'refs/tags/' ) )
      result.tag = _.strRemoveBegin( result.ref, 'refs/tags/' )

      _.assert( _.strDefined( result.hash ) );
      _.assert( _.strDefined( result.ref ) );
      _.assert( !_.strDefined( result.branch ) || !_.strDefined( result.tag ) );

      return result;
    })
  }
}

var defaults = isHead.defaults = Object.create( null );
defaults.localPath = null;
defaults.hash = null;
defaults.tag = null;
defaults.sync = 1;

//

function sureHasOrigin( o )
{
  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routine.options_( sureHasOrigin, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ), 'Expects local path' );
  _.assert( _.strDefined( o.remotePath ) || _.mapIs( o.remotePath ), 'Expects remote path' );

  if( !_.git.isRepository({ localPath : o.localPath }) )
  throw _.err( `Provided path is not a git repository:${o.localPath}` );

  // let parsed = _.git.pathParse( o.remotePath );
  let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 1, atomic : 0 });
  let remoteVcsPathParsed = _.mapBut_( null, parsed, { localVcsPath : null, tag : null, hash : null, query : null } );
  remoteVcsPathParsed.longPath = _.strRemoveEnd( parsed.longPath, '/' );
  let remoteVcsPath = _.git.path.str( remoteVcsPathParsed );
  let remoteVcsNativized = _.git.path.nativize( remoteVcsPath );

  let config = _.git.configRead( o.localPath );

  _.sure
  (
    !!config[ 'remote "origin"' ] && !!config[ 'remote "origin"' ] && _.strIs( config[ 'remote "origin"' ].url ),
    'GIT config does not have {-remote.origin.url-}'
  );

  let srcCurrentPath = config[ 'remote "origin"' ].url;
  srcCurrentPath = _.git.path.nativize( _.git.path.normalize( config[ 'remote "origin"' ].url ) ); /* qqq : for Dmytro : cover */

  // _.sure
  // (
  //   _.strEnds( _.strRemoveEnd( srcCurrentPath, '/' ), _.strRemoveEnd( parsed.remoteVcsPath, '/' ) ),
  //   () => 'GIT repository at directory ' + _.strQuote( o.localPath ) + '\n'
  //   + 'Has origin ' + _.strQuote( srcCurrentPath ) + '\n'
  //   + 'Should have ' + _.strQuote( parsed.remoteVcsPath )
  // );

  _.sure
  (
    _.strEnds( _.strRemoveEnd( srcCurrentPath, '/' ), _.strRemoveEnd( remoteVcsNativized, '/' ) ),
    () => 'GIT repository at directory ' + _.strQuote( o.localPath ) + '\n'
    + 'Has origin ' + _.strQuote( srcCurrentPath ) + '\n'
    + 'Should have ' + _.strQuote( remoteVcsPath )
  );

  return config;
}

sureHasOrigin.defaults =
{
  localPath : null,
  remotePath : null
}

// --
// status
// --

/**
 * @summary Checks local repo for uncommitted, unpushed changes and conflicts.
 *
 * @description
 * Explanation for short format of 'git status': https://git-scm.com/docs/git-status#_short_format
 * Explanation for result of `uncommittedUnstaged`:
 * XY     Meaning
 * -------------------------------------------------
 * ММ     modified->staged->modified
 * MD     modified->staged->deleted
 * AM     added->staged->modified
 * AD     added->staged->deleted
 * RM     renamed->staged->modified
 * RD     renamed->staged->deleted
 * CM     copied->staged->modified
 * CD     copied->staged->deleted
 *
 * @param {Object} o Options map.
 * @param {String} o.localPath Path to local repo.
 * @param {Boolean} o.uncommitted=1 Checks for uncommitted changes. Enables all uncommitted* checks that are not disabled explicitly.
 * @param {Boolean} o.uncommittedUntracked=null Checks for untracked files
 * @param {Boolean} o.uncommittedAdded=null Checks for new files
 * @param {Boolean} o.uncommittedChanged=null Checks for modified files
 * @param {Boolean} o.uncommittedDeleted=null Checks for deleted files
 * @param {Boolean} o.uncommittedRenamed=null Checks for renamed files
 * @param {Boolean} o.uncommittedCopied=null Checks for copied files
 * @param {Boolean} o.uncommittedIgnored=0 Checks for new files that are ignored
 * @param {Boolean} o.uncommittedUnstaged=null Checks for unstaged changes
 * @param {Boolean} o.unpushed=1 Checks for unpsuhed changes. Enables all unpushed* checks that are not disabled explicitly.
 * @param {Boolean} o.unpushedCommits=null Checks for unpushed commit
 * @param {Boolean} o.unpushedTags=null Checks for unpushed tags
 * @param {Boolean} o.unpushedBranches=null Checks for unpushed branches
 * @param {Boolean} o.conflicts=1 Check for conflicts
 * @param {Boolean} o.detailing=0 Performs check of each enabled option if enabled, otherwise performs fast check.
 * @param {Boolean} o.explaining=0 Properties from result map will contain explanation if result of check is positive.
 * @function statusLocal
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function statusLocal_head( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routine.options_( routine, o );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( args.length === 1 );

  if( o.uncommitted !== null )
  _.each( routine.uncommittedGroup, ( k ) =>
  {
    if( o[ k ] === null )
    o[ k ] = o.uncommitted;
  })

  if( o.unpushed !== null )
  _.each( routine.unpushedGroup, ( k ) =>
  {
    if( o[ k ] === null )
    o[ k ] = o.unpushed;
  })

  for( let k in o )
  if( o[ k ] === null )
  o[ k ] = true;

  return o;
}

//

function statusLocal_body( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  let start = _.process.starter
  ({
    currentPath : o.localPath,
    mode : 'spawn',
    sync : 0,
    deasync : o.sync,
    throwingExitCode : 1,
    outputCollecting : 1,
    // verbosity : o.verbosity - 1,
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    logger : _.logger.relativeMaybe( o.logger, -1 ),
  });

  let result = resultPrepare();

  let optimizingCheck = o.uncommittedUntracked && o.uncommittedAdded
                        && o.uncommittedChanged && o.uncommittedDeleted
                        && o.uncommittedRenamed && o.uncommittedCopied
                        && !o.detailing;

  let ready = _.take( null );

  ready.then( uncommittedCheck );

  if( o.unpushedCommits )
  ready.then( unpushedCommitsCheck )

  if( o.unpushedTags )
  ready.then( checkTags )

  if( o.unpushedBranches )
  ready.then( checkBranches )

  ready.finally( end );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* aaa : for Dmytro : list of subroutines? */
  /*
    Dmytro : list of subroutines is given below
    statusMake
    uncommittedCheck
    optimizedCheck
    detailedCheck
    resultPrepare
    uncommittedDetailedCheck
    checkTags
    retry
    remoteTagsGet
    remoteTagsGetSync
    checkBranches
    unpushedCommitsCheck
  */

  function end( err, got )
  {

    if( err )
    throw _.err( err, `\nFailed to check if repository ${_.color.strFormat( String( o.localPath ), 'path' )} has local changes` );

    statusMake();

    return result;
  }

  /* */

  function statusMake()
  {

    /*  */

    if( !optimizingCheck )
    {
      for( let i = 0; i < statusLocal_body.uncommittedGroup.length; i++ )
      {
        let k = statusLocal_body.uncommittedGroup[ i ];

        if( !_.strIs( result[ k ] ) )
        continue;

        if( result.uncommitted === null )
        result.uncommitted = [];

        if( !result[ k ] )
        continue;

        result.uncommitted.push( result[ k ] );
      }
      if( _.arrayIs( result.uncommitted ) )
      result.uncommitted = result.uncommitted.join( '\n' )
    }

    if( result.uncommitted )
    result.uncommitted = 'List of uncommited changes in files:\n' + '  ' + _.strLinesIndentation( result.uncommitted, '  ' );

    /*  */

    for( let i = 0; i < statusLocal_body.unpushedGroup.length; i++ )
    {
      let k = statusLocal_body.unpushedGroup[ i ];

      if( !_.strIs( result[ k ] ) )
      continue;

      if( result.unpushed === null )
      result.unpushed = [];

      if( !result[ k ] )
      continue;

      if( k === 'unpushedCommits' )
      result.unpushed.push( 'List of branches with unpushed commits:' )
      else if( k === 'unpushedBranches' || k === 'unpushedTags' )
      _.arrayAppendOnce( result.unpushed, 'List of unpushed:' );

      result.unpushed.push( '  ' + _.strLinesIndentation( result[ k ], '  ' ) );
    }
    if( _.arrayIs( result.unpushed ) )
    result.unpushed = result.unpushed.join( '\n' );

    /*  */

    result.status = result.uncommitted;

    if( _.strIs( result.unpushed ) )
    {
      if( !result.status )
      result.status = result.unpushed;
      else if( result.unpushed )
      result.status += '\n' + result.unpushed;
    }

    _.assert( _.strIs( result.status ) || result.status === null );

    /*  */

    if( optimizingCheck )
    {
      let uncommitted = !!result.uncommitted;

      _.each( statusLocal_body.uncommittedGroup, ( k ) =>
      {
        if( !o[ k ] )
        return;
        _.assert( result[ k ] === null )
        result[ k ] = uncommitted ? _.maybe : '';
      })

      if( uncommitted )
      {
        result.unpushed = _.maybe;
        _.each( statusLocal_body.unpushedGroup, ( k ) =>
        {
          if( !o[ k ] )
          return;
          _.assert( result[ k ] === null )
          result[ k ] = _.maybe;
        })
      }
    }

    for( let k in result )
    {
      if( _.strIs( result[ k ] ) )
      {
        if( !o.explaining )
        result[ k ] = !!result[ k ];
        else if( o.detailing && !result[ k ] )
        result[ k ] = false;
      }
    }
  }

  /* */

  function uncommittedCheck( got )
  {
    let gitStatusArgs = [ '-u', '--porcelain', '-b' ]
    if( o.uncommittedIgnored )
    gitStatusArgs.push( '--ignored' );

    return start({ execPath : 'git status', args : gitStatusArgs })
    .then( ( got ) =>
    {
      let output = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });

      /*
      check for any changes, except new commits/tags/branches
      */

      if( optimizingCheck )
      {
        return optimizedCheck( output );
      }
      else
      {
        return detailedCheck( output );
      }

    })
  }

  /* */

  function optimizedCheck( output )
  {
    result.uncommitted = '';

    if( output.length > 1 )
    result.uncommitted = output.join( '\n' );

    return result.uncommitted;
  }

  /* */

  function detailedCheck( output )
  {
    let outputStripped = output.join( '\n' );

    if( o.conflicts )
    if( uncommittedDetailedCheck( outputStripped, 'conflicts', /^D[DU]|A[AU]|U[DAU] .*/gm ) )
    return true;

    if( o.uncommittedUntracked )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedUntracked', /^\?{1,2} .*/gm ) )
    return true;

    if( o.uncommittedAdded )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedAdded', /^A .*/gm ) )
    return true;

    if( o.uncommittedChanged )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedChanged', /^M .*/gm ) )
    return true;

    if( o.uncommittedDeleted )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedDeleted', /^D .*/gm ) )
    return true;

    if( o.uncommittedRenamed )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedRenamed', /^R .*/gm ) )
    return true;

    if( o.uncommittedCopied )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedCopied', /^C .*/gm ) )
    return true;

    if( o.uncommittedIgnored )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedIgnored', /^!{1,2} .*/gm ) )
    return true;

    if( o.uncommittedUnstaged )
    if( uncommittedDetailedCheck( outputStripped, 'uncommittedUnstaged', /^[MARC][MD] .*/gm ) )
    return true;

    return false;
  }

  /* */

  function resultPrepare()
  {
    let result = Object.create( null );

    result.uncommitted = null;
    result.unpushed = null;

    _.each( statusLocal_body.uncommittedGroup, ( k ) => { result[ k ] = null } )
    _.each( statusLocal_body.unpushedGroup, ( k ) => { result[ k ] = null } )

    return result;
  }

  /* */

  function uncommittedDetailedCheck( output, check, regexp )
  {
    let match = output.match( regexp );

    result[ check ] = '';

    if( match )
    {
      match = _.str.lines.strip( match );
      result[ check ] = match.join( '\n' )
    }

    return result[ check ] && !o.detailing;
  }

  /* */

  function checkTags( got )
  {
    if( got && !o.detailing )
    return got;

    /* Nothing to check if there no tags*/

    let tagsDirPath = _.git.path.join( o.localPath, '.git/refs/tags' );
    let tags = _.fileProvider.dirRead({ filePath : tagsDirPath, throwing : 0 })
    if( !tags || !tags.length )
    {
      result.unpushedTags = '';
      return result.unpushedTags;
    }

    /* if origin is no defined include all tags to list, with "?" at right side */

    let config = configRead.call( this, o.localPath );
    if( !config[ 'remote "origin"' ] )
    {
      result.unpushedTags = '';

      if( tags && tags.length )
      {
        tags = tags.map( ( tag ) => `[new tag]   ${tag} -> ?` )
        result.unpushedTags += tags.join( '\n' )
      }

      return result.unpushedTags;
    }

    /* check tags */

    return start( 'git for-each-ref */tags/* --format=%(refname:short)' )
    .then( ( got ) =>
    {
      tags = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });
      _.assert( tags.length > 0 );
      return remoteTagsGet();
    })
    .then( ( got ) =>
    {
      result.unpushedTags = '';
      let unpushedTags = [];
      _.each( tags, ( tag ) =>
      {
        if( !_.strHas( got.output, `refs/tags/${tag}` ) )
        unpushedTags.push( `[new tag]   ${tag} -> ${tag}` );
      })

      if( unpushedTags.length )
      result.unpushedTags += unpushedTags.join( '\n' );

      return result.unpushedTags;
    })
  }

  /* */

  function retry()
  {
    o.attempt -= 1;
    return _.time.out( o.attemptDelay, () => remoteTagsGet() );
  }

  /* */

  function remoteTagsGet()
  {
    _.assert( o.attempt >= 1, 'Expects defined number of attempts {-o.attempt-}' );

    let result = remoteTagsGetSync();
    if( result.exitCode === 0 )
    return result;

    if( _.strHas( result.output, /(C|c)ould not resolve host/ ) && o.attempt > 1 )
    return retry();
    else
    throw _.errOnce( `Exit code : ${result.exitCode}\n`, result.output );
  }

  /* */

  function remoteTagsGetSync()
  {
    return _.process.start
    ({
      execPath : 'git ls-remote --tags --refs',
      currentPath : o.localPath,
      mode : 'spawn',
      sync : 1,
      throwingExitCode : 0,
      outputCollecting : 1,
      // verbosity : o.verbosity - 1,
      logger : _.logger.relativeMaybe( o.logger, -1 ),
      verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    })
  }

  /* */

  function checkBranches( got )
  {
    if( got && !o.detailing )
    return got;

    let startOptions =
    {
      execPath : 'git for-each-ref',
      args :
      [
        'refs/heads',
        `--format={ "branch" : "%(refname:short)", "upstream" : "%(upstream)" }`
      ]
    };

    return start( startOptions )
    .then( ( got ) =>
    {
      let output = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });
      let branches = output.map( ( src ) => JSON.parse( src ) );
      let explanation = [];

      result.unpushedBranches = '';

      for( let i = 0; i < branches.length; i++ )
      {
        let record = branches[ i ];

        _.assert( _.strIs( record.upstream ) );

        if( /\(HEAD detached at .+\)/.test( record.branch ) )
        continue;
        if( record.upstream.length )
        continue;

        explanation.push( `[new branch]        ${record.branch} -> ?` );
      }

      if( explanation.length )
      result.unpushedBranches += explanation.join( '\n' );

      return result.unpushedBranches;
    })
  }

  /* - */

  function unpushedCommitsCheck( got )
  {
    if( got && !o.detailing )
    return got;

    return start( 'git branch -vv' )
    .then( ( got ) =>
    {

      let match = got.output.match( /^.*\[.*ahead .*\].*$/gm );
      result.unpushedCommits = '';
      if( match )
      {
        match = _.str.lines.strip( match );
        result.unpushedCommits = match.join( '\n' );
      }

      return result.unpushedCommits;
    })
  }
}

statusLocal_body.uncommittedGroup =
[
  'uncommittedUntracked',
  'uncommittedAdded',
  'uncommittedChanged',
  'uncommittedDeleted',
  'uncommittedRenamed',
  'uncommittedCopied',
  'uncommittedIgnored',
  'uncommittedUnstaged',
  'conflicts'
]

statusLocal_body.unpushedGroup =
[
  'unpushedCommits',
  'unpushedTags',
  'unpushedBranches',
]

var defaults = statusLocal_body.defaults = Object.create( null );

defaults.localPath = null;
defaults.sync = 1;
defaults.logger = 0;
defaults.attempt = 2;
defaults.attemptDelay = 250;

defaults.uncommitted = null;
defaults.uncommittedUntracked = null;
defaults.uncommittedAdded = null;
defaults.uncommittedChanged = null;
defaults.uncommittedDeleted = null;
defaults.uncommittedRenamed = null;
defaults.uncommittedCopied = null;
defaults.uncommittedIgnored = 0;
defaults.uncommittedUnstaged = null;

defaults.unpushed = null;
defaults.unpushedCommits = null;
defaults.unpushedTags = null;
defaults.unpushedBranches = null;

defaults.conflicts = null;

defaults.detailing = 0;
defaults.explaining = 0;

let statusLocal = _.routine.uniteCloning_replaceByUnite( statusLocal_head, statusLocal_body );

//

/*
  additional check for branch
  git reflog --pretty=format:"%H, %D"
  if branch is not listed in `git branch` but exists in output of reflog, then branch was deleted
*/

function statusRemote_head( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routine.options_( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.version ) || o.version === _.all || o.version === null, 'Expects {-o.version-} to be: null/str/_.all, but got:', o.version );

  for( let k in o )
  if( o[ k ] === null && k !== 'version' )
  /* aaa Vova: should we just use something else for version instead of null? */ /* Dmytro : resolved in common conversation */
  o[ k ] = true;

  return o;
}

//

function statusRemote_body( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = new _.Consequence();
  let start =  _.process.starter
  ({
    currentPath : o.localPath,
    mode : 'shell',
    sync : 0,
    deasync : o.sync,
    throwingExitCode : 0,
    outputCollecting : 1,
    outputPiping : 0,
    inputMirroring : 0,
    stdio : [ 'pipe', 'pipe', 'ignore' ],
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    ready,
  });

  let result =
  {
    remoteCommits : null,
    remoteBranches : null,
    remoteTags : null,
    status : null
  }

  if( !o.remoteCommits && !o.remoteBranches && !o.remoteTags )
  {
    ready.take( result );
    return end();
  }

  ready.take( null );

  let remotes, tags, heads, output;
  let status = [];
  let version = o.version;

  if( o.version === null )
  {
    start( 'git rev-parse --abbrev-ref HEAD' )
    ready.then( ( got ) =>
    {
      version = _.strStrip( got.output );
      if( version === 'HEAD' )
      throw _.err( `Can't determine current branch: local repository is in detached state` );
      return null;
    })
  }

  /* aaa : for Dmytro : ask */ /* Dmytro : asked, temporary mistakes */
  start( 'git ls-remote' ) /* prints list of remote tags and branches */
  ready.then( parse )
  start( 'git show-ref --heads --tags -d' ) /* prints list of local tags and branches */
  ready.then( ( got ) =>
  {
    output = got.output;
    return null;
  })


  if( o.remoteBranches )
  ready.then( branchesCheck )
  if( o.remoteCommits )
  ready.then( commitsCheck )
  if( o.remoteTags )
  ready.then( tagsCheck )

  ready.finally( ( err, got ) =>
  {
    if( err )
    throw _.err( err, '\nFailed to check if remote repository has changes' );
    statusMake();
    return result;
  })

  /*  */

  return end();

  /* - */

  function end()
  {
    if( o.sync )
    {
      ready.deasync();
      return ready.sync();
    }

    return ready;
  }

  /* */

  function parse( arg )
  {
    remotes = _.strSplitNonPreserving({ src : arg.output, delimeter : '\n' });
    remotes = remotes.map( ( src ) => _.strSplitNonPreserving({ src, delimeter : /\s+/ }) );
    remotes = remotes.slice( 1 );

    /* aaa : for Dmytro : bad format of comments! */ /* Dmytro : formatted */
    /* remote heads */
    heads = remotes.filter( ( r ) =>
    {
      if( version === _.all )
      return _.strBegins( r[ 1 ], 'refs/heads' )
      return _.strBegins( r[ 1 ], `refs/heads/${version}` )
    });

    /* remote tags */
    tags = remotes.filter( ( r ) => _.strBegins( r[ 1 ], 'refs/tags' ) )

    return null;
  }

  function branchesCheck( got )
  {
    result.remoteBranches = '';

    for( var h = 0; h < heads.length ; h++ )
    {
      let ref = heads[ h ][ 1 ];

      if( !_.strHas( output, ref ) ) /* looking for remote branch in list of local branches */
      {
        if( result.remoteBranches )
        result.remoteBranches += '\n';
        result.remoteBranches += ref;
        _.arrayAppendOnce( status, 'List of unpulled remote branches:' )
        status.push( '  ' + ref );
      }
    }

    return result.remoteBranches
  }

  /*  */

  function commitsCheck( got )
  {
    result.remoteCommits = '';

    if( got && !o.detailing )
    {
      if( heads.length )
      result.remoteCommits = _.maybe;
      return got;
    }

    if( !heads.length )
    return result.remoteCommits;

    let con = _.take( null );

    _.each( heads, ( head ) =>
    {
      let hash = head[ 0 ];
      let ref = head[ 1 ];
      // let execPath = `git branch --contains ${hash} --quiet --format=%(refname)`;
      let execPath = `git for-each-ref refs/heads --contains ${hash} --format=%(refname)`;

      if( !_.strHas( output, ref ) ) /* skip if branch is not downloaded */
      return;

      con.then( () =>
      {
        return start({ execPath, ready : null, mode : 'spawn' })
      })
      .then( ( got ) =>
      {
        if( !_.strHas( got.output, ref ) )
        {
          if( result.remoteCommits )
          result.remoteCommits += '\n';
          result.remoteCommits += ref;
          _.arrayAppendOnce( status, 'List of remote branches that have new commits:' )
          status.push( '  ' + ref );
        }
        return result.remoteCommits;
      })
    })

    return con;
  }

  /*  */

  function tagsCheck( got )
  {
    result.remoteTags = '';

    if( got && !o.detailing )
    {
      if( tags.length )
      result.remoteTags = _.maybe;
      return got;
    }

    for( var h = 0; h < tags.length ; h++ )
    {
      let tag = tags[ h ][ 1 ];

      if( !_.strHas( output, tag ) ) /* looking for remote tag in list of local tags */
      {
        if( result.remoteTags )
        result.remoteTags += '\n';
        result.remoteTags += tag;
        _.arrayAppendOnce( status, 'List of unpulled remote tags:' )
        status.push( '  ' + tag );
      }
    }

    return result.remoteTags;
  }

  /*  */

  function statusMake()
  {
    result.status = status.join( '\n' );

    for( let k in result )
    if( _.strIs( result[ k ] ) )
    {
      if( !o.explaining )
      result[ k ] = !!result[ k ];
      else if( o.detailing && !result[ k ] )
      result[ k ] = false;
    }
  }

  /* */

}

var defaults = statusRemote_body.defaults = Object.create( null );
defaults.localPath = null;
defaults.logger = 0;
defaults.version = _.all;
defaults.remoteCommits = null;
defaults.remoteBranches = 0;
defaults.remoteTags = null;
defaults.detailing = 0;
defaults.explaining = 0;
defaults.sync = 1;

//

let statusRemote = _.routine.uniteCloning_replaceByUnite( statusRemote_head, statusRemote_body );

//

function status_head( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routine.options_( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );

  if( o.unpushed === null )
  o.unpushed = o.local;
  if( o.uncommitted === null )
  o.uncommitted = o.local;

  if( o.remoteCommits === null )
  o.remoteCommits = o.remote;
  if( o.remoteBranches === null )
  o.remoteBranches = o.remote;
  if( o.remoteTags === null )
  o.remoteTags = o.remote;

  return o;
}

//

function status_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let localReady = null;
  let o2 = _.mapOnly_( null, o, self.statusLocal.defaults );
  o2.sync = 0;
  localReady = self.statusLocal.call( this, o2 );

  let remoteReady = null;
  let o3 = _.mapOnly_( null, o, self.statusRemote.defaults );
  o3.sync = 0;
  remoteReady = self.statusRemote.call( this, o3 );

  let ready = _.Consequence.And( localReady, remoteReady )
  .finally( ( err, arg ) =>
  {
    if( err )
    {
      let errors = _.arrayAppendArrayOnce( localReady.errorsGet().slice(), remoteReady.errorsGet() );
      _.each( errors, ( err ) => _.errAttend( err ) )
      throw _.err.apply( _, errors );
    }

    let result = _.props.extend( null, arg[ 0 ] || {}, arg[ 1 ] || {} );

    if( arg[ 0 ] )
    {
      result.local = arg[ 0 ].status;
      if( arg[ 0 ].status !== null )
      result.status = arg[ 0 ].status;
    }


    if( arg[ 1 ] )
    {
      result.remote = arg[ 1 ].status;
      if( arg[ 1 ].status !== null )
      {
        if( !result.status )
        {
          result.status = arg[ 1 ].status;
          return result;
        }

        if( o.explaining && arg[ 1 ].status )
        if( arg[ 0 ] && arg[ 0 ].status )
        result.status += '\n' + arg[ 1 ].status;
      }
    }


    return result;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

_.assert( _.routineIs( statusLocal.body ) );
_.routineExtend( status_body, statusLocal.body )
_.assert( _.routineIs( statusRemote.body ) );
_.routineExtend( status_body, statusRemote.body )

var defaults = status_body.defaults;
defaults.localPath = null;
defaults.remote = 1;
defaults.local = 1;
defaults.detailing = 0;
defaults.explaining = 0;

let status = _.routine.uniteCloning_replaceByUnite( status_head, status_body );

//

/*
  qqq : extend and cover please
*/

function statusFull( o )
{
  let result = Object.create( null );

  o = _.routine.options_( statusFull, arguments );

  result.isRepository = false;
  if( o.prs )
  o.prs = [];

  if( !o.localPath && o.insidePath )
  o.localPath = _.git.localPathFromInside( o.insidePath );

  if( !o.localPath )
  return result;

  result.isRepository = true;

  _.assert( _.strIs( o.localPath ), 'Expects local path of inside path to deduce local path' );

  if( !o.remotePath )
  o.remotePath = _.git.remotePathFromLocal( o.localPath );

  let statusReady = _.take( null );
  if( o.remotePath )
  {
    let o2 = _.mapOnly_( null, o, status.defaults );
    o2.sync = 0;
    statusReady = _.git.status( o2 )
  }

  let prsReady = _.take( null );
  if( o.prs )
  prsReady = _.repo.pullList({ remotePath : o.remotePath, throwing : 0, sync : 0, token : o.token });

  let ready = _.Consequence.AndKeep( statusReady, prsReady )
  .finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( err );
    let status = arg[ 0 ];
    statusAdjust( status, arg[ 1 ] ? result : null );
    return result;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function statusAdjust( status, prs )
  {

    _.props.extend( result, status );

    result.prs = prs;
    if( !result.prs )
    result.prs = o.prs ? _.maybe : null;

    if( prs && !prs.length && !result.result )
    {
      if( result.status === null )
      result.status = false;
      return result;
    }

    if( prs && prs.length )
    {
      if( o.explaining )
      {
        let prsExplanation= `Has ${prs.length} opened pull request(s)`;

        if( result.status )
        result.status += '\n' + prsExplanation;
        else
        result.status = prsExplanation;

      }
      else
      {
        result.status = true;
      }
    }

    return result;
  }

}

statusFull.defaults =
{
  insidePath : null,
  localPath : null,
  remotePath : null,
  local : 1,
  remote : 1,
  prs : 1,
  detailing : 1,
  explaining : 1,
  sync : 1,
  token : null,
}

_.props.supplement( statusFull.defaults, status.defaults );

//

function hasLocalChanges()
{
  let self = this;
  let result = self.statusLocal.apply( this, arguments );

  if( _.consequenceIs( result ) )
  return result.then( end );
  return end( result );

  function end( result )
  {
    _.assert( result.status !== undefined );

    if( _.boolIs( result.status ) )
    return result.status;
    if( _.strIs( result.status ) && result.length )
    return true;

    return false;
  }
}

_.routineExtend( hasLocalChanges, statusLocal )

//

function hasRemoteChanges()
{
  let self = this;

  let result = self.statusRemote.apply( this, arguments );

  if( _.consequenceIs( result ) )
  return result.then( end );
  return end( result );

  function end( result )
  {
    _.assert( result.status !== undefined );

    if( _.boolIs( result.status ) )
    return result.status;
    if( _.strIs( result.status ) && result.length )
    return true;

    return false;
  }
}

_.routineExtend( hasRemoteChanges, statusRemote )

//

function hasChanges()
{
  let result = status.apply( this, arguments );

  if( _.consequenceIs( result ) )
  return result.then( end );
  return end( result );

  function end( result )
  {
    _.assert( result.status !== undefined );

    if( _.boolIs( result.status ) )
    return result.status;
    if( _.strIs( result.status ) && result.length )
    return true;

    return false;
  }
}

_.routineExtend( hasChanges, status )

//

function repositoryHasTag( o )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.routine.options_( repositoryHasTag, o );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.tag ) );
  _.assert( o.remotePath === null || _.strDefined( o.remotePath ) || _.mapIs( o.remotePath ) );
  _.assert( !!o.local || !!o.remote );

  let ready = _.take( null );
  let start = _.process.starter
  ({
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'shell',
    currentPath : o.localPath,
    throwingExitCode : 0,
    inputMirroring : 0,
    outputPiping : 0,
  });

  ready.then( () =>
  {
    if( !self.isRepository({ localPath : o.localPath }) )
    throw _.err( `Provided {-o.localPath-}: ${_.strQuote( o.localPath )} doesn't contain a git repository.` );
    return null;
  })

  if( o.local )
  ready.then( checkLocal );

  if( o.remote )
  ready.then( checkRemote );

  ready.catch( ( err ) =>
  {
    _.errAttend( err );
    throw _.err( 'Failed to obtain tags and heads from remote repository.\n', err );
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /*  */

  function checkLocal()
  {
    // return start( `git show-ref --heads --tags` )
    // .then( hasTag );
    return start( `git show-ref --heads --tags -- ${o.tag}` ) /* Dmytro : fast searching for tag - result empty string or tag */
    .then( ( got ) =>
    {
      if( got.output !== '' )
      {
        let splits = _.strSplitNonPreserving({ src : got.output, delimeter : /\s+/, stripping : 1 });
        return o.returnVersion ? splits[ 0 ] : true;
      }
      return false;
    });
  }

  function checkRemote( result )
  {
    if( result )
    return result;

    // let remotePath = o.remotePath ? self.pathParse( o.remotePath ).remoteVcsPath : 'origin';
    let remotePath = 'origin';
    if( o.remotePath )
    {
      let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 1, atomic : 0 });
      let remoteVcsPathParsed = _.mapBut_( null, parsed, { localVcsPath : null, tag : null, hash : null, query : null } );
      remoteVcsPathParsed.longPath = _.strRemoveEnd( parsed.longPath, '/' );
      let remoteVcsPath = _.git.path.str( remoteVcsPathParsed );
      remotePath = _.git.path.nativize( remoteVcsPath );
    }

    /* Dmytro : searching tag, the tag can be a glob, decrease volume of output */
    return start( `git ls-remote --tags --refs --heads ${remotePath} -- ${o.tag}` )
    .then( hasTag )

    // let remotePath = o.remotePath ? self.pathParse( o.remotePath ).remoteVcsPath : '';
    // return start( `git ls-remote --tags --refs --heads ${remotePath}` )
    // .then( hasTag )
  }

  function hasTag( got )
  {
    let possibleTag = `refs/tags/${o.tag}`;
    let possibleHead = `refs/heads/${o.tag}`;

    let refs = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });
    refs = refs.map( ( src ) => _.strSplitNonPreserving({ src, delimeter : /\s+/, stripping : 1 }) );

    for( let i = 0, l = refs.length; i < l; i++ )
    if( refs[ i ][ 1 ] === possibleTag || refs[ i ][ 1 ] === possibleHead )
    return o.returnVersion ? refs[ i ][ 0 ] : true;

    return false;
  }
}

repositoryHasTag.defaults =
{
  localPath : null,
  remotePath : null,
  tag : null,
  local : 1,
  remote : 1,
  returnVersion : 0,
  sync : 1
};

//

function repositoryHasVersion( o )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.routine.options_( repositoryHasVersion, o );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.version ) );

  let ready = _.take( null );
  let start = _.process.starter
  ({
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'spawn',
    currentPath : o.localPath,
    throwingExitCode : 0,
    inputMirroring : 0,
    outputPiping : 0,
  });

  ready.then( () =>
  {
    if( !self.isRepository({ localPath : o.localPath }) )
    throw _.err( `Provided {-o.localPath-}: ${_.strQuote( o.localPath )} doesn't contain a git repository.` )

    // if( !_.git.versionIsCommitHash( _.mapOnly_( null, o, _.git.versionIsCommitHash.defaults )) ) /* Dmytro : the routine `versionIsCommitHash` searches a hash in local repository, but the hash can be on remote repository */
    // throw _.err( `Provided version: ${_.strQuote( o.version ) } is not a commit hash.` )

    if( !_.git.stateIsHash( `#${ o.version }` ) )
    throw _.err( `Provided version: ${_.strQuote( o.version ) } is not a commit hash.` )

    return null;
  })

  if( o.local )
  ready.then( checkLocal );

  if( o.remote )
  ready.then( checkRemote );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* - */

  function checkLocal()
  {
    let con = start({ execPath : `git cat-file -t ${o.version}` })
    con.then( ( got ) => got.exitCode === 0 );
    return con;
  }

  /* - */

  function checkRemote( result )
  {
    if( result )
    return result;

    let ready = _.take( null );

    start({ execPath : `git fetch -v -n --dry-run`, throwingExitCode : 1, ready })

    ready.then( ( got ) =>
    {
      // if( _.strHas( got.output, /.+\.\..+/ ) )
      /*
         Dmytro : the output has range of commits that will be fetched, it is more convenient regexp than the previous one.
         The regexp does not include strings like : `From ../repo`
      */
      if( _.strHas( got.output, /[a-hA-H0-9]+\.\.[a-hA-H0-9]+/ ) )
      throw _.err( `Local repository at ${o.localPath} is not up-to-date with remote. Please run "git fetch" and try again.` )
      return true;
    })

    start({ execPath : `git branch -r --contains ${o.version}`, ready })

    ready.then( ( got ) =>
    {
      if( got.exitCode !== 0 )
      return false;
      let lines =  _.strSplitNonPreserving({ src : got.output, delimeter : /\s+/, stripping : 1 });
      return lines.length >= 1;
    })

    return ready;
  }
}

repositoryHasVersion.defaults =
{
  localPath : null,
  version : null,
  local : 1,
  remote : 0,
  sync : 1
}

//

function repositoryTagToVersion( o )
{
  let self = this;
  _.routine.options_( repositoryTagToVersion, o );
  _.assert( arguments.length === 1 );
  let o2 = _.props.extend( null, o, { returnVersion : 1 } );
  return self.repositoryHasTag( o2 );
}

repositoryTagToVersion.defaults =
{
  localPath : null,
  remotePath : null,
  tag : null,
  local : 1,
  remote : 1,
  sync : 1
};

//

function repositoryVersionToTag( o )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.routine.options_( repositoryVersionToTag, o );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.version ) );
  _.assert( o.remotePath === null || _.strDefined( o.remotePath ) );
  _.assert( !!o.local || !!o.remote );

  let ready = _.take( null );
  let start = _.process.starter
  ({
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'shell',
    currentPath : o.localPath,
    throwingExitCode : 0,
    inputMirroring : 0,
    outputPiping : 0,
  });

  ready.then( () =>
  {
    if( !self.isRepository({ localPath : o.localPath }) )
    throw _.err( `Provided {-o.localPath-}: ${_.strQuote( o.localPath )} doesn't contain a git repository.` )
    return null;
  })

  if( o.local )
  ready.then( checkLocal );

  if( o.remote )
  ready.then( checkRemote );

  ready.catch( ( err ) =>
  {
    _.errAttend( err );
    throw _.err( 'Failed to obtain tags and heads from remote repository.\n', err );
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /*  */

  function checkLocal()
  {
    // return start( `git show-ref --heads --tags` )
    return start( `git show-ref --dereference --heads --tags` )
    .then( hasTag )
  }

  function checkRemote( result )
  {
    if( result )
    return result;

    // let remotePath = o.remotePath ? self.pathParse( o.remotePath ).remoteVcsPath : '';
    let remotePath = '';
    if( o.remotePath )
    {
      let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 1, atomic : 0 });
      let remoteVcsPathParsed = _.mapBut_( null, parsed, { localVcsPath : null, tag : null, hash : null, query : null } );
      remoteVcsPathParsed.longPath = _.strRemoveEnd( parsed.longPath, '/' );
      let remoteVcsPath = _.git.path.str( remoteVcsPathParsed );
      remotePath = _.git.path.nativize( remoteVcsPath );
    }

    return start( `git ls-remote --tags --heads ${ remotePath }` )
    .then( hasTag )

    // return start( `git ls-remote --tags --heads ${remotePath}` )
    // .then( hasTag )
  }

  function hasTag( got )
  {
    let headsPrefix = 'refs/heads/';
    let tagsPrefix = 'refs/tags/';
    let tagsPostfix = '^{}';

    let refs = _.strSplitNonPreserving({ src : got.output, delimeter : '\n' });
    refs = refs.map( ( src ) => _.strSplitNonPreserving({ src, delimeter : /\s+/, stripping : 1 }) );

    let result = [];

    for( let i = 0, l = refs.length; i < l; i++ )
    if( _.strBegins( refs[ i ][ 0 ], o.version ) )
    {
      let tag = refs[ i ][ 1 ];
      if( _.strBegins( tag, headsPrefix ) )
      tag = _.strRemoveBegin( tag, headsPrefix )
      else if( _.strBegins( tag, tagsPrefix ) )
      tag = _.strRemoveBegin( tag, tagsPrefix )

      if( _.strEnds( tag, tagsPostfix ) )
      tag = _.strRemoveEnd( tag, tagsPostfix );

      _.arrayAppendOnce( result, tag );
    }

    if( result.length === 1 )
    return result[ 0 ];

    return result;
  }
}

repositoryVersionToTag.defaults =
{
  localPath : null,
  remotePath : null,
  version : null,
  local : 1,
  remote : 1,
  sync : 1
};

//

function exists( o )
{
  let self = this;

  _.routine.options_( exists, o );
  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( o.local ) || _.strDefined( o.remote ) );

  let ready = _.take( null );

  if( o.local )
  ready.then( checkLocal )

  if( o.remote )
  ready.then( checkRemote )

  ready.catch( ( err ) =>
  {
    throw _.err( 'Failed to obtain tags and heads from remote repository. Reason:\n', err );
  })

  if( o.sync )
  return ready.sync();

  return ready;

  /* - */

  function checkLocal()
  {
    let local = parse( o.local );
    if( !local )
    throw _.err( `Failed to determine kind of {o.local}. Expects "!tag" or "#version", but got:${o.local}` );

    if( local.tag )
    return self.repositoryHasTag
    ({
      localPath : o.localPath,
      local : 1,
      remote : 0,
      tag : local.tag,
      sync : o.sync
    })

    return self.repositoryHasVersion
    ({
      localPath : o.localPath,
      version : local.version,
      sync : o.sync
    })
  }

  /* - */

  function checkRemote( result )
  {
    if( result )
    return result;

    let remote = parse( o.remote );
    if( !remote )
    throw _.err( `Failed to determine kind of {o.remote}. Expects "!tag" or "#version", but got:${o.remote}` );

    if( remote.tag )
    return self.repositoryHasTag
    ({
      localPath : o.localPath,
      remotePath : o.remotePath,
      local : 0,
      remote : 1,
      returnVersion : o.returnVersion,
      tag : remote.tag,
      sync : o.sync
    });

    return self.repositoryHasVersion
    ({
      localPath : o.localPath,
      local : 0,
      remote : 1,
      version : remote.version,
      sync : o.sync
    });

    /* qqq3: Find how to check if remote has commit */
    /* Dmytro : the first way is fetching of all commits and searching for desired ( implemented above )

      Also, it can be checked by specific API of git provider.
      For example, for github.com we can use Rest API of Github or module `@octokit/core` instead.
    */
    // _.assert( 0, 'Case remote:#version is not implemented' );
    //
    // return true;
  }

  /* - */

  function parse( src )
  {
    if( _.strBegins( src, '!' ) )
    return { tag : _.strRemoveBegin( src, '!' ) };
    else if( _.strBegins( src, '#' ) )
    return { version : _.strRemoveBegin( src, '#' ) };
  }
}

exists.defaults =
{
  localPath : null,
  remotePath : null,
  local : null,
  remote : null,
  returnVersion : 0,
  sync : 1
}

//

// /**
//  * Routine tagMake() makes tag for current commit.
//  *
//  * @example
//  * // make tag `v0.1` if script run in git repository
//  * let tag = _.git.tagMake
//  * ({
//  *   localPath : _.path.current(),
//  *   tag : 'v0.1',
//  *   description : 'version 0.1',
//  * });
//  *
//  * @param { Aux } o - Options map.
//  * @param { String } o.localPath - Path to git repository on hard drive.
//  * @param { String } o.tag - Name of tag.
//  * @param { String } o.description - Description of tag.
//  * @param { BoolLike } o.light - Enable lightweight tags. Default is 0.
//  * @param { BoolLike } o.deleting - Enable deleting of duplicated tags. Default is 1.
//  * @param { BoolLike } o.sync - Enable synchronous execution of code. Default is 1.
//  * @returns { Consequence|Aux } - Returns map like object with results of Process execution
//  * or Consequence that handle such Process.
//  * @function tagMake
//  * @throws { Error } If arguments.length is not equal to 1.
//  * @throws { Error } If options map {-o-} has extra options.
//  * @throws { Error } If {-o.localPath-} is not a String with defined length.
//  * @throws { Error } If {-o.tag-} is not a String with defined length.
//  * @throws { Error } If added two tags with identical names to single commit and {-o.deleting-} is false.
//  * @namespace wTools.git
//  * @module Tools/mid/GitTools
//  */
//
// function tagMake( o )
// {
//   let ready;
//
//   _.assert( arguments.length === 1, 'Expects options map {-o-}' );
//   _.routine.options_( tagMake, arguments );
//
//   let start = _.process.starter
//   ({
//     sync : 0,
//     deasync : 0,
//     outputCollecting : 1,
//     mode : 'shell',
//     currentPath : o.localPath,
//     throwingExitCode : 1,
//     inputMirroring : 0,
//     outputPiping : 0,
//   });
//
//   if( o.deleting )
//   {
//
//     ready = _.git.repositoryHasTag
//     ({
//       localPath : o.localPath,
//       tag : o.tag,
//       local : 1,
//       remote : 0,
//       sync : 0,
//     });
//
//     ready.then( ( has ) =>
//     {
//       if( has )
//       return start( `git tag -d ${o.tag}` );
//       return has;
//     })
//
//   }
//   else
//   {
//     ready = _.take( null );
//   }
//
//   ready.then( () =>
//   {
//     if( o.light )
//     return start( `git tag ${o.tag}` );
//     else
//     return start( `git tag -a ${o.tag} -m "${o.description}"` );
//   });
//
//   // if( got.exitCode !== 0 || got.output && _.strHas( got.output, 'refs/' ) )
//   // return false;
//
//   if( o.sync )
//   {
//     ready.deasync();
//     return ready.sync();
//   }
//
//   return ready;
// }
//
// tagMake.defaults =
// {
//   localPath : null,
//   tag : null,
//   description : '',
//   light : 0,
//   deleting : 1,
//   sync : 1,
// };

// --
// hook
// --

function hookRegister( o )
{
  let provider = _.fileProvider;
  let path = _.git.path;
  // let path = provider.path;

  _.assert( arguments.length === 1 );
  _.routine.options_( hookRegister, o );

  if( o.repoPath === null )
  o.repoPath = path.current();

  _.assert( _.strDefined( o.repoPath ) );

  try
  {
    check();
    hookLauncherMake();
    register();
    setPermissions();
    return true;
  }
  catch( err )
  {
    if( o.throwing )
    throw _.err( err );
    return null;
  }

  /* */

  function check()
  {

    if( !provider.fileExists( o.filePath ) )
    throw _.err( 'Source handler path doesn\'t exit:', o.filePath )

    if( !provider.fileExists( path.join( o.repoPath, '.git' ) ) )
    throw _.err( 'No git repository found at:', o.filePath );

    if( !_.longHas( KnownHooks, o.hookName ) )
    throw _.err( 'Unknown git hook:', o.hookName );

    let handlerNamePattern = new RegExp( `^${o.hookName}\\..*` );
    if( !handlerNamePattern.test( o.handlerName ) )
    throw _.err( 'Handler name:', o.handlerName, 'should match the pattern ', handlerNamePattern.toString() )

    if( !o.rewriting )
    if( provider.fileExists( path.join( o.repoPath, '.git/hooks', o.handlerName ) ) )
    throw _.err( 'Handler:', o.handlerName, 'for git hook:', o.hookName, 'is already registered. Enable option {-o.rewriting-} to rewrite existing handler.' );

    if( o.handlerName === o.hookName || o.handlerName === o.hookName + '.was' )
    throw _.err( 'Rewriting of original git hook script', o.handlerName, 'is not allowed.' );

  }

  /* */

  function hookLauncherMake()
  {
    let specialComment = 'This script is generated by utility willbe';

    let originalHandlerPath = path.join( o.repoPath, '.git/hooks', o.hookName );

    if( provider.fileExists( originalHandlerPath ) )
    {
      let read = provider.fileRead( originalHandlerPath );

      if( _.strHas( read, specialComment ) )
      return true

      let originalHandlerPathDst = originalHandlerPath + '.was';
      if( provider.fileExists( originalHandlerPathDst ) )
      throw _.err( 'Can\'t rename original git hook file:', originalHandlerPath, '. Path :', originalHandlerPathDst, 'already exists.' );
      provider.fileRename( originalHandlerPathDst, originalHandlerPath );
    }

    _.assert( !provider.fileExists( originalHandlerPath ) );

    let hookLauncher = hookLauncherCode();

    provider.fileWrite( originalHandlerPath, hookLauncher );

    /* */

    function hookLauncherCode()
    {
      return `#!/bin/bash

      #${specialComment}
      #Based on
      #https://github.com/henrik/dotfiles/blob/master/git_template/hooks/pre-commit

      hook_dir=$(dirname $0)
      hook_name=$(basename $0)

      if [[ -d $hook_dir ]]; then
        stdin=$(cat /dev/stdin)

        if stat -t $hook_dir/$hook_name.* >/dev/null 2>&1; then
          for hook in $hook_dir/$hook_name.*; do
            echo "Running $hook hook"
            echo "$stdin" | $hook "$@"

            exit_code=$?

            if [ $exit_code != 0 ]; then
              exit $exit_code
            fi
          done
        fi
      fi

      exit 0
    `
    }
  }

  /* */

  function register()
  {
    let handlerPath = path.join( o.repoPath, '.git/hooks', o.handlerName );
    let sourceCode = provider.fileRead( o.filePath );
    provider.fileWrite( handlerPath, sourceCode );
  }

  function setPermissions() /* aaa : use _.fileProvider.* routine */ /* Dmytro : used, the mask 0o754 is equivalent to ug+x */
  {

    const files = provider.filesFind
    ({
      filePath : _.git.path.join( o.repoPath, '.git/hooks' ),
      // filePath : provider.path.join( o.repoPath, '.git/hooks' ),
      outputFormat : 'absolute',
    });
    _.each( files, ( filePath ) => provider.rightsWrite({ filePath, setRights : 0o754 }) );

    // if( process.platform !== 'win32' )
    // _.process.start
    // ({
    //   execPath : 'chmod ug+x .git/hooks/*',
    //   currentPath : o.repoPath,
    //   sync : 1,
    //   inputMirroring : 0,
    //   outputPiping : 1
    // })
  }
}

hookRegister.defaults =
{
  repoPath : null,
  filePath : null,
  handlerName : null,
  hookName : null,
  throwing : 1,
  rewriting : 0
}

//

function hookUnregister( o )
{
  let provider = _.fileProvider;
  let path = _.git.path;
  // let path = provider.path;

  _.assert( arguments.length === 1 );
  _.routine.options_( hookUnregister, o );

  if( o.repoPath === null )
  o.repoPath = path.current();

  _.assert( _.strDefined( o.repoPath ) );

  try
  {
    if( _.longHas( KnownHooks, o.handlerName ) )
    if( !o.force )
    throw _.err( 'Removal of original git hook handler is not allowed. Please enable option {-o.force-} to delete it.' )

    let handlerPath = path.join( o.repoPath, '.git/hooks', o.handlerName );

    if( !provider.fileExists( handlerPath ) )
    throw _.err( 'Git hook handler:', handlerPath, 'doesn\'t exist.' )

    provider.fileDelete
    ({
      filePath : handlerPath,
      sync : 1,
      throwing : 1
    });

    return true;
  }
  catch( err )
  {
    if( o.throwing )
    throw _.err( err );
    return null;
  }
}

hookUnregister.defaults =
{
  repoPath : null,
  handlerName : null,
  force : 0,
  throwing : 1
}

//

function hookPreservingHardLinksRegister( repoPath )
{
  let provider = _.fileProvider;
  let path = provider.path; /* Dmytro : should be provider path */

  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( repoPath ) );

  // let toolsPath = path.resolve( __dirname, '../../../../../wtools/Tools.s' );
  let toolsPath = _.module.toolsPathGet();
  _.sure( provider.fileExists( toolsPath ) );
  toolsPath = path.nativize( toolsPath );

  // let sourceCode = '#!/usr/bin/env node\n' + restoreHardLinksCode();
  // let tempPath = _.process.tempOpen({ sourceCode });
  let routineCode = '#!/usr/bin/env node\n' + restoreHardLinksCode();
  let tempPath = path.tempOpen(); /* xxx : review */
  let name = 'archivePerform';
  let filePath = path.join( tempPath, name );

  _.program.make
  ({
    // sourceCode,
    routineCode,
    name,
    filePath,
    // filePath/*programPath*/ : filePath,
  });

  try
  {
    _.git.hookRegister
    ({
      repoPath,
      filePath,
      // filePath : tempPath,
      handlerName : 'post-merge.restoreHardLinks',
      hookName : 'post-merge',
      throwing : 1,
      rewriting : 0
    })
  }
  catch( err )
  {
    throw _.err( err );
  }
  finally
  {
    path.tempClose( tempPath );
  }

  return true;

  /* */

  function restoreHardLinksCode()
  {
    let sourceCode =
    `
    function archivePerform()
    {
      try
      {
        try
        {
          var _ = require( "${ _.strEscape( toolsPath) }" );
        }
        catch( err )
        {
          var _ = require( 'wTools' );
        }
        _.include( 'wFilesArchive' );
      }
      catch( err )
      {
        console.log( err, 'Git post pull hook fails to preserve hardlinks due missing dependency.' );
        return;
      }

      let provider = _.FileFilter.Archive();
      provider.archive.basePath = _.path.join( __dirname, '../..' );
      provider.archive.fileMapAutosaving = 0;
      provider.archive.filesUpdate();
      provider.archive.filesLinkSame({ consideringFileName : 0 });
      provider.finit();
      provider.archive.finit();
    }
    `
    return sourceCode;
  }
}

//

function hookPreservingHardLinksUnregister( repoPath )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( repoPath ) );

  return _.git.hookUnregister
  ({
    repoPath,
    handlerName : 'post-merge.restoreHardLinks',
    force : 0,
    throwing : 1
  })
}

// --
// ignore
// --

function ignoreAdd( o )
{
  let provider = _.fileProvider;
  let path = _.git.path;
  // let path = provider.path;

  if( arguments.length === 2 )
  o = { insidePath : arguments[ 0 ], pathMap : arguments[ 1 ] }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routine.options_( ignoreAdd, o );

  if( !provider.isDir( o.insidePath ) )
  throw _.err( 'Provided {-o.insidePath-} is not a directory:', _.strQuote( o.insidePath ) );

  if( !this.insideRepository( o.insidePath ) )
  throw _.err( 'Provided {-o.insidePath-}:', _.strQuote( o.insidePath ), 'is not inside of a git repository.' );

  let gitignorePath = path.join( o.insidePath, '.gitignore' );
  let records = _.props.keys( o.pathMap );

  let result = 0;

  if( !records.length )
  return result;

  let gitconfig = [];

  if( provider.fileExists( gitignorePath ) )
  {
    gitconfig = provider.fileRead( gitignorePath );
    gitconfig = _.strSplitNonPreserving({ src : gitconfig, delimeter : '\n' })
  }

  result = _.arrayAppendedArrayOnce( gitconfig, records );

  let data = gitconfig.join( '\n' );
  provider.fileWrite({ filePath : gitignorePath, data, writeMode : 'append' });

  return result;
}

var defaults = ignoreAdd.defaults = Object.create( null );
defaults.insidePath = null;
defaults.pathMap = null;

//

function ignoreRemove( o )
{
  let provider = _.fileProvider;
  let path = _.git.path;
  // let path = provider.path;

  if( arguments.length === 2 )
  o = { insidePath : arguments[ 0 ], pathMap : arguments[ 1 ] }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routine.options_( ignoreRemove, o );

  let gitignorePath = path.join( o.insidePath, '.gitignore' );

  if( !provider.fileExists( gitignorePath ) )
  throw _.err( 'Provided .gitignore file doesn`t exist at:', _.strQuote( gitignorePath ) );

  if( !this.isTerminal( o.insidePath ) )
  throw _.err( 'Provided .gitignore file:', _.strQuote( gitignorePath ), 'is not terminal' );

  let records = _.props.keys( o.pathMap );

  if( !records.length )
  return false;

  let gitconfig = provider.fileRead( gitignorePath );
  gitconfig = _.strSplitNonPreserving({ src : gitconfig, delimeter : '\n' })

  let result = 0;

  if( !gitconfig.length )
  return result;

  result = _.arrayRemovedArrayOnce( gitconfig, records );

  let data = gitconfig.join( '\n' );
  provider.fileWrite({ filePath : gitignorePath, data, writeMode : 'rewrite' });

  return result;
}

_.routineExtend( ignoreRemove, ignoreAdd );

//

function ignoreRemoveAll( o )
{
  let provider = _.fileProvider;
  let path = _.git.path;
  // let path = provider.path;

  if( !_.object.isBasic( o ) )
  o = { insidePath : arguments[ 0 ] }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routine.options_( ignoreRemoveAll, o );

  let gitignorePath = path.join( o.insidePath, '.gitignore' );
  if( !provider.fileExists( gitignorePath ) )
  return false;
  provider.fileDelete( gitignorePath );
  return true;
}

var defaults = ignoreRemoveAll.defaults = Object.create( null );
defaults.insidePath = null;

// --
// maker
// --

function repositoryInit( o )
{
  let self = this;
  let ready = _.take( null );

  o = _.routine.options_( repositoryInit, o );

  let nativeRemotePath = null;
  let parsed = null;
  let remoteExists = null;

  _.assert( !o.remote || _.strDefined( o.remotePath ), `Expects path to remote repository {-o.remotePath-}, but got ${_.color.strFormat( String( o.remotePath ), 'path' )}` )

  if( o.remotePath )
  {
    // o.remotePath = self.remotePathNormalize( o.remotePath );
    // nativeRemotePath = self.remotePathNativize( o.remotePath );
    o.remotePath = nativeRemotePath = _.git.path.nativize( o.remotePath );

    // parsed = self.objectsParse( o.remotePath );
    parsed = _.git.path.parse({ remotePath : o.remotePath, full : 0, atomic : 0, objects : 1 });
    remoteExists = self.isRepository({ remotePath : o.remotePath, sync : 1 });
  }

  if( o.remote === null )
  o.remote = !!o.remotePath;
  if( o.local === null )
  o.local = !!o.localPath;

  let start = _.process.starter
  ({
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'spawn',
    currentPath : o.localPath,
  });

  ready
  .then( () =>
  {
    if( !o.remote )
    return null;
    if( remoteExists )
    return null;
    return remoteInit();
  })
  .then( () =>
  {
    if( !o.local )
    return null;
    return localInit();
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    {
      if( o.throwing )
      throw _.err( err, `\nFailed to init git repository remotePath:${_.color.strFormat( String( o.remotePath ), 'path' )}` );

      _.errAttend( err );
      return null;
    }
    return arg;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function repositoryInitOnGithub()
  {
    if( !o.token )
    {
      if( o.throwing )
      throw _.err( 'Requires an access token to create a repository on github.com' );
      return null;
    }
    let ready = _.take( null );
    ready
    .then( () =>
    {

      if( o.logger && o.logger.verbosity > 0 )
      o.logger.log( `Making remote repository ${_.color.strFormat( String( o.remotePath ), 'path' )}` );

      if( o.dry )
      return true;

      const provider = _.repo.providerForPath({ remotePath : o.remotePath });

      let o2 = _.props.extend( null, o );
      o2.remotePath = parsed;
      return provider.repositoryInitAct( o2 ); /* xxx : think how to refactor or reorganize it */

      // let github = require( 'octonode' );
      // let client = github.client( o.token );
      // let me = client.me();
      //
      // return me.repoAsync
      // ({
      //   'name' : parsed.repo,
      //   'description' : o.description || '',
      // });
    })
    .then( ( result ) =>
    {
      return result || null;
      // return result[ 0 ] || null;
    });
    return ready;
  }

  /* */

  function remoteInit()
  {
    if( parsed.service === 'github.com' )
    return repositoryInitOnGithub();
    if( o.throwing )
    throw _.err( `Cant init remote repository, because not clear what service to use for ${_.color.strFormat( String( o.remotePath ), 'path' )}` );
    return null;
  }

  /* */

  function localInit()
  {
    _.assert( _.git.path.is( o.localPath ) && !_.git.path.isGlobal( o.localPath ), () => `Expects local path, but got ${_.color.strFormat( String( o.localPath ), 'path' )}` );
    // _.assert( _.uri.is( o.localPath ) && !_.uri.isGlobal( o.localPath ), () => `Expects local path, but got ${_.color.strFormat( String( o.localPath ), 'path' )}` );

    o.localPath = _.git.path.canonize( o.localPath );
    // o.localPath = _.path.canonize( o.localPath );

    if( _.fileProvider.fileExists( o.localPath ) && !_.fileProvider.isDir( o.localPath ) )
    throw _.err( `Cant clone repository to ${_.color.strFormat( String( o.localPath ), 'path' )}. It is occupied by non-directory.` );

    if( o.remotePath && remoteExists )
    {

      if( self.isRepository({ localPath : o.localPath }) )
      return localRepositoryRemoteAdd();
      else
      return localRepositoryClone();

    }
    else
    {

      if( self.isRepository({ localPath : o.localPath }) )
      return localRepositoryRemoteAdd();
      else
      return localRepositoryNew();

    }
  }

  /* */

  function localRepositoryNew()
  {
    if( o.logger && o.logger.verbosity > 0 )
    o.logger.log( `Making a new local repository at ${_.color.strFormat( String( o.localPath ), 'path' )}` );
    if( o.dry )
    return null;
    _.fileProvider.dirMake( o.localPath );
    start( `git init .` );
    return start( `git remote add origin ${nativeRemotePath}` );
  }

  /* */

  function localRepositoryRemoteAdd()
  {
    let wasRemotePath = _.git.remotePathFromLocal( o.localPath );
    if( wasRemotePath )
    {
      if( wasRemotePath !== o.remotePath )
      throw _.err( `Repository at ${o.localPath} already exists, but has different origin ${wasRemotePath}` );
      return null;
    }
    if( o.logger )
    o.logger.log( `Adding origin ${_.color.strFormat( String( o.remotePath ), 'path' )} to local repository ${_.color.strFormat( String( o.localPath ), 'path' )}` );
    if( o.dry )
    return null;
    // if( _.git.remotePathFromLocal( o.localPath ) )
    // start( `git remote rm origin` );
    return start( `git remote add origin ${nativeRemotePath}` );
  }

  /* */

  function localRepositoryClone()
  {

    if( o.logger && o.logger.verbosity > 0 )
    if( _.fileProvider.isDir( o.localPath ) )
    o.logger.log( `Directory ${_.color.strFormat( String( o.localPath ), 'path' )} will be moved` );

    if( o.logger && o.logger.verbosity > 0 )
    o.logger.log( `Cloning repository from ${_.color.strFormat( String( o.remotePath ), 'path' )} to ${_.color.strFormat( String( o.localPath ), 'path' )}` );

    if( o.dry )
    return null;

    let downloadPath = o.localPath;
    if( _.fileProvider.isDir( o.localPath ) )
    {
      downloadPath = _.git.path.join( o.localPath + '-' + _.idWithGuid() );
      // downloadPath = _.path.join( o.localPath + '-' + _.idWithGuid() );
    }

    _.fileProvider.dirMake( downloadPath );

    let start = _.process.starter
    ({
      logger : _.logger.relativeMaybe( o.logger, -1 ),
      verbosity : o.logger ? o.logger.verbosity - 1 : 0,
      sync : 0,
      deasync : 0,
      outputCollecting : 1,
      mode : 'spawn',
      currentPath : downloadPath,
    });

    return start( `git clone ${nativeRemotePath} .` )
    .finally( ( err, arg ) =>
    {
      if( err )
      {
        _.fileProvider.filesDelete( downloadPath );
        if( err )
        throw _.err( err );
      }
      try
      {
        let o2 =
        {
          dst : o.localPath,
          src : downloadPath,
          dstRewriting : 1,
          dstRewritingOnlyPreserving : 1,
          linkingAction : 'hardLink',
        }
        _.fileProvider.filesReflect( o2 );
      }
      catch( err )
      {
        _.fileProvider.filesDelete( downloadPath );
        throw _.err( err, `\nCollision of local files with remote files at ${_.color.strFormat( String( o.localPath ), 'path' )}` );
      }
      _.fileProvider.filesDelete( downloadPath );
      return arg;
    });

  }
}

repositoryInit.defaults =
{
  remotePath : null,
  localPath : null,
  remote : null,
  local : null,
  throwing : 1,
  sync : 1,
  logger : 0,
  dry : 0,
  description : null,
  token : null,
};

//

function repositoryDelete( o )
{
  let self = this;
  let ready = _.take( null );

  o = _.routine.options_( repositoryDelete, o );

  let nativeRemotePath = null;
  let parsed = null;
  let remoteExists = null;

  if( o.remotePath )
  {
    o.remotePath = nativeRemotePath = _.git.path.normalize( o.remotePath );
    parsed = _.git.path.parse({ remotePath : o.remotePath, full : 0, atomic : 0, objects : 1 });
    remoteExists = self.isRepository({ remotePath : o.remotePath, sync : 1 });
  }

  if( !remoteExists )
  return false;

  ready.then( () =>
  {
    return remove();
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    {
      if( o.throwing )
      throw _.err( err, `\nFailed to init git repository remotePath:${_.color.strFormat( String( o.remotePath ), 'path' )}` );

      _.error.attend( err );
      return null;
    }
    return arg;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function removeGithub()
  {
    if( !o.token )
    {
      if( o.throwing )
      throw _.err( 'Requires an access token to create a repository on github.com' );
      return null;
    }

    let ready = _.take( null );
    ready.then( () =>
    {
      if( o.logger && o.logger.verbosity > 0 )
      o.logger.log( `Removing remote repository ${_.color.strFormat( String( o.remotePath ), 'path' )}` );

      if( o.dry )
      return true;

      const provider = _.repo.providerForPath({ remotePath : o.remotePath });
      let o2 = _.props.extend( null, o );
      o2.remotePath = parsed;
      return _.retry
      ({
        routine : () => provider.repositoryDeleteAct( o2 ),
        attemptLimit : o.attemptLimit,
        attemptDelay : o.attemptDelay,
        attemptDelayMultiplier : o.attemptDelayMultiplier,
        defaults : _.remote.attemptDefaults,
      })
      .finally( ( err, arg ) =>
      {
        if( err )
        throw _.err( `Error code : ${ err.status }. ${ err.message }` );
        return arg;
      });
      // return provider.repositoryDeleteAct( o2 ); /* xxx : think how to refactor or reorganize it */
    })
    .then( ( result ) =>
    {
      return result || null;
    });
    return ready;
  }

  /* */

  function remove()
  {
    if( parsed.service === 'github.com' )
    return removeGithub();
    if( o.throwing )
    throw _.err( `Can't remove remote repository, because not clear what service to use for ${_.color.strFormat( String( o.remotePath ), 'path' )}` );
    return null;
  }
}

repositoryDelete.defaults =
{
  remotePath : null,
  token : null,
  throwing : 1,
  sync : 1,
  logger : 1,
  dry : 0,
  attemptLimit : null,
  attemptDelay : null,
  attemptDelayMultiplier : null,
};

//

function repositoryClone( o )
{
  let localProvider = _.fileProvider;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( repositoryClone, o );
  _.assert( _.strDefined( o.localPath ), 'Expects local path' );
  _.assert( _.strDefined( o.remotePath ) || _.mapIs( o.remotePath ), 'Expects remote path' );

  let ready = _.take( null );

  if( _.git.isRepository({ localPath : o.localPath }) )
  return ready;

  let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 1, atomic : 0 });
  let remoteVcsPathParsed = _.mapBut_( null, parsed, { localVcsPath : null, tag : null, hash : null, query : null } );
  remoteVcsPathParsed.longPath = _.strRemoveEnd( parsed.longPath, '/' );
  let remoteVcsLongerPath = _.git.path.str( remoteVcsPathParsed );
  remoteVcsLongerPath = _.git.path.nativize( remoteVcsLongerPath );

  if( localProvider.fileExists( o.localPath ) )
  _.sure( localProvider.dirIsEmpty( o.localPath ) );
  else
  localProvider.dirMake( o.localPath );

  let shell = _.process.starter
  ({
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    currentPath : o.localPath,
    ready,
  });

  ready = _.retry
  ({
    routine : () => shell( `git clone ${ remoteVcsLongerPath } . --config core.autocrlf=false` ),
    attemptLimit : o.attemptLimit,
    attemptDelay : o.attemptDelay,
    attemptDelayMultiplier : o.attemptDelayMultiplier,
    defaults : _.remote.attemptDefaults,
    onError,
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function onError( err )
  {
    const errorMsgs =
    [
      'Could not resolve host',
      'Could not read from remote repository',
      'Failed to connect',
    ];
    if( !_.strHasAny( err.originalMessage, errorMsgs ) )
    return false;

    _.error.attend( err );
    return true;
  }
}

repositoryClone.defaults =
{
  remotePath : null,
  localPath : null,
  logger : 0,
  sync : 0,
  attemptLimit : null,
  attemptDelay : null,
  attemptDelayMultiplier : null,
};

//

function repositoryCheckout( o )
{
  let localProvider = _.fileProvider;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( repositoryCheckout, o );
  _.assert( _.strDefined( o.localPath ), 'Expects local path' );
  _.assert( _.strDefined( o.remotePath ) || _.mapIs( o.remotePath ), 'Expects remote path' );

  let ready = _.take( null );
  // let parsed = _.git.pathParse( o.remotePath );

  let parsed = _.git.path.parse({ remotePath : o.remotePath, full : 1, atomic : 0 });

  let shell = _.process.starter
  ({
    // verbosity : o.verbosity,
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    currentPath : o.localPath,
    outputCollecting : 1,
    ready,
  });

  if( parsed.tag )
  ready.then( () =>
  {
    let repoHasTag = _.git.repositoryHasTag
    ({
      localPath : o.localPath,
      remotePath : parsed,
      tag : parsed.tag
    });

    if( !repoHasTag )
    {
      let remoteVcsPathParsed = _.mapBut_( null, parsed, { tag : null, hash : null, query : null } );
      let remoteVcsPath = _.git.path.str( remoteVcsPathParsed );
      remoteVcsPath = _.git.path.nativize( remoteVcsPath );
      throw _.err
      (
        `Specified tag: ${_.strQuote( parsed.tag )} doesn't exist in local and remote copy of the repository.\
        \nLocal path: ${_.color.strFormat( String( o.localPath ), 'path' )}\
        \nRemote path: ${_.color.strFormat( String( remoteVcsPath ), 'path' )}`
      );
    }

    return null;
  });

  let checkoutOptions =
  {
    execPath : 'git -c "core.autocrlf=false" checkout ' + ( parsed.hash || parsed.tag )
  }

  shell( checkoutOptions )

  ready.catch( ( err ) =>
  {
    _.errAttend( err );
    if( o.localChanges && o.stashing )
    shell
    ({
      execPath : 'git -c "core.autocrlf=false" stash pop',
      sync : 1,
      deasync : 0,
      throwingExitCode : 0,
      ready : null
    })

    if( !_.strHasAny( checkoutOptions.output, [ 'fatal: reference', 'error: pathspec' ] ) )
    throw _.err( err );

    err = _.err
    (
      'Failed to checkout, branch/commit: '
      + _.strQuote( parsed.hash || parsed.tag )
      + ' doesn\'t exist in repository at '
      + _.strQuote( o.localPath )
    );
    err.reason = 'git';
    throw err;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

repositoryCheckout.defaults =
{
  remotePath : null,
  localPath : null,
  logger : 0,
  sync : 0
};

//

function repositoryStash( o )
{
  _.routine.options_( repositoryStash, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ), 'Expects local path' );

  let ready = _.take( null );
  let shell = _.process.starter
  ({
    // verbosity : o.verbosity,
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    currentPath : o.localPath,
    outputCollecting : 1,
    ready,
  });

  let shellOptions = { execPath : `git -c "core.autocrlf=false" stash ${ o.pop ? 'pop' : '' }` }

  shell( shellOptions );

  ready.catch( ( err ) =>
  {
    if( !_.strHas( shellOptions.output, 'CONFLICT' ) )
    throw _.err( err );
    _.errAttend( err );
    err = _.err( 'Automatic merge of stashed changes failed in repository at ' + _.strQuote( o.localPath ) + '. Fix conflict(s) manually.' );
    err.reason = 'git';
    throw err;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

repositoryStash.defaults =
{
  localPath : null,
  // verbosity : null,
  logger : 0,
  pop : 0
};

//

function repositoryMerge( o )
{
  _.routine.options_( repositoryMerge, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ), 'Expects local path' );

  let ready = _.take( null );
  let shell = _.process.starter
  ({
    // verbosity : o.verbosity,
    logger : _.logger.relativeMaybe( o.logger, -1 ),
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    currentPath : o.localPath,
    outputCollecting : 1,
    ready,
  });

  let shellOptions =
  {
    execPath : `git -c "merge.defaultToUpstream=true" -c "core.autocrlf=false" merge`
  }

  shell( shellOptions );

  ready.catch( ( err ) =>
  {
    if( !_.strHas( shellOptions.output, 'CONFLICT' ) )
    throw _.err( err )
    _.errAttend( err );
    err = _.err( 'Automatic merge of remote-tracking branch failed in repository at ' + _.strQuote( o.localPath ) + '. Fix conflict(s) manually.' );
    err.reason = 'git';
    throw err;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

repositoryMerge.defaults =
{
  localPath : null,
  logger : 0,
};

// --
// config
// --

function configRead( filePath )
{
  const fileProvider = _.fileProvider;
  const path = _.git.path;
  // const path = fileProvider.path;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( filePath ) );

  let configPath = path.join( filePath, '.git/config' );

  if( !fileProvider.fileExists( configPath ) )
  return null;

  if( !Ini )
  Ini = require( 'ini' );

  let read = fileProvider.fileRead( configPath );
  let config = Ini.parse( read );

  return config;
}

//

function configSave( filePath, config )
{
  const fileProvider = _.fileProvider;
  const path = _.git.path;
  // const path = fileProvider.path;

  _.assert( arguments.length === 2 );
  _.assert( _.strDefined( filePath ) );
  _.assert( _.object.isBasic( config ) );

  if( !Ini )
  Ini = require( 'ini' );

  let data = Ini.stringify( config, { whitespace : true } );
  fileProvider.fileWrite( path.join( filePath, '.git/config' ), data );
}

//

function configReset( o ) /* aaa : implement */ /* Dmytro : implemented */
{
  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.routine.options_( configReset, o );
  if( o.preset === 'recommended' )
  {
    _.assert( _.strDefined( o.userName ), 'Expects user name {-o.userName-}' );
    _.assert( _.strDefined( o.userMail ), 'Expects user email {-o.userMail-}' );
  }
  else
  {
    _.assert( o.preset === 'standard' );
  }

  /* */

  const ready = _.take( null );
  const start = _.process.starter
  ({
    currentPath : o.localPath,
    mode : 'shell',
    outputCollecting : 1,
    throwingExitCode : 1,
    inputMirroring : 0,
    sync : 0,
    ready,
  });

  /* */

  if( o.withLocal )
  {
    _.assert( _.git.isRepository({ localPath : o.localPath }), 'Expects git repository' );

    stadardLocalConfigSet();
    if( o.preset === 'recommended' )
    recommendedConfigSet( 'local' );
  }

  if( o.withGlobal )
  {
    standardGlobalConfigSet();
    if( o.preset === 'recommended' )
    recommendedConfigSet( 'global' );
  }

  ready.catch( ( err ) =>
  {
    _.errAttend( err );
    throw _.err( err );
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function recommendedConfigSet( scope )
  {
    return start
    ({
      execPath :
      [
        `git config --${ scope } core.autocrlf false`,
        `git config --${ scope } core.ignorecase false`,
        `git config --${ scope } core.fileMode false`,
        `git config --${ scope } credential.helper store`,
        `git config --${ scope } user.name "${ o.userName }"`,
        `git config --${ scope } user.email "${ o.userMail }"`,
        `git config --${ scope } url."https://${ o.userName }@github.com".insteadOf "https://github.com"`,
        `git config --${ scope } url."https://${ o.userName }@bitbucket.org".insteadOf "https://bitbucket.org"`,
      ],
    });
  }

  /* */

  function stadardLocalConfigSet()
  {
    /* clean sections core and user */
    start
    ({
      throwingExitCode : 0,
      execPath :
      [
        'git config --local --remove-section core',
        'git config --local --remove-section user',
      ],
    });

    return start
    ({
      execPath :
      [
        'git config --local core.repositoryformatversion 0',
        'git config --local core.filemode true',
        'git config --local core.bare false',
        'git config --local core.logallrefupdates true',
      ],
    });
  }

  /* */

  function standardGlobalConfigSet()
  {
    const provider = _.fileProvider;
    const path = provider.path; /* Dmytro : should be provider path */

    const globalConfigPath = path.nativize( path.join( process.env.HOME, '.gitconfig' ) );
    /* by default global config has no settings */
    provider.fileWrite( globalConfigPath, '' );
  }
}

configReset.defaults =
{
  localPath : null,
  sync : 0,
  preset : 'recommended', /* [ recommended, standard ] */
  withGlobal : 0,
  withLocal : 1,
  userName : null,
  userMail : null,
};

//

/* qqq : implement routine to find out does exist version/tag */
/* qqq : implement routine to convert one kind of version/tag to one another */

/* qqq : aaa:fixed

 = Message of Error#1
    Unexpected change type: "u", filePath: "revision" fatal: ambiguous argument 'alhpa': unknown revision or path not in the working tree.
    Use '--' to separate paths from revisions, like this:
    'git <command> [<revision>...] -- [<file>...]'

 = Beautified calls stack
    at detailingHandle (/pro/builder/proto/wtools/amid/l3/git/l1/Tools.s:3556:15)
    at wConsequence.handleOutput (/pro/builder/proto/wtools/amid/l3/git/l1/Tools.s:3505:5)

*/

function _stateParse( state )
{
  let statesBegin = [ '#', '!' ];
  let statesSpecial = [ 'working', 'staging', 'committed' ];
  /*
  https://neurathsboat.blog/post/git-intro/
  https://git-scm.com/book/en/v2/Getting-Started-What-is-Git%3F
  */

  let result =
  {
    original : state,
    value : state,
    isSpecial : false
  };

  /* aaa : for Dmytro : should be no such special states */ /* Dmytro : done */

  // if( _.strBegins( state, 'HEAD' ) )
  // {
  //   result.isSpecial = true;
  //   return result;
  // }

  if( _.strBegins( state, statesBegin ) )
  {
    result.isVersion = _.git.stateIsHash( state );
    result.isTag = _.git.stateIsTag( state );
    result.value = _.strRemoveBegin( state, statesBegin );

    if( !result.isTag )
    return result;

    if( _.strEnds( result.value, '/' ) )
    {
      result.isTag = false;
      result.value = _.strRemoveEnd( result.value, '/' );
    }
    else if( _.strHas( result.value, '/' ) )
    {
      result.isRemoteTag = true;
      let r = _.strIsolateLeftOrNone( result.value, '/' );
      _.sure
      (
        _.strDefined( r[ 0 ] ) && _.strDefined( r[ 2 ] ),
        `Failed to parse state: ${result.original}, expects remote tag in format: "!remote/tag".`
      );
      result.remotePath = `:///${r[ 0 ]}`;
      result.remote = `!${r[ 2 ]}`;
    }

    return result;
  }

  if( !_.longHas( statesSpecial, state ) )
  throw _.err( `Expects one of special states: ${statesSpecial}, but got: ${state}` );

  result.isSpecial = true;

  return result;
}

//

function diff( o )
{
  let self = this;

  o = _.routine.options_( diff, o );

  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( o.state1 ) || o.state1 === null );
  _.assert( _.strDefined( o.state2 ) );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( o.linesOfContext === null || _.numberIs( o.linesOfContext ) );

  if( o.state1 === null ) /* qqq : discuss */
  o.state1 = 'HEAD';

  let ready = _.take( null );
  let result = Object.create( null );
  let state1 = self._stateParse( o.state1 );
  let state2 = self._stateParse( o.state2 ); /* qqq : ! aaa: special tags now work in both states */

  let start = _.process.starter
  ({
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'spawn',
    currentPath : o.localPath,
    throwingExitCode : 0,
    inputMirroring : 0,
    outputPiping : 0,
    ready
  });

  if( o.fetchTags )
  start( `git fetch --tags` )

  ready.then( checkStates );
  ready.then( runDiff );
  ready.then( handleResult );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* - */

  function checkStates()
  {
    let ready = _.take( null )
    ready.then( () => checkState( state1 ) )
    ready.then( () => checkState( state2 ) )
    ready.then( () =>
    {
      if( !o.throwingDoesNotExist )
      return null;

      if( !state1.exists )
      throw _.err( `State::${state1.original} {-o.state1-} doesn't exist in repository at ${o.localPath}` );

      if( !state2.exists )
      throw _.err( `State::${state2.original} {-o.state2-} doesn't exist in repository at ${o.localPath}` );

      return null;
    })
    return ready;
  }

  /* - */

  function checkState( state )
  {
    state.exists = true;

    if( state.isSpecial )
    return null;

    let con = _.take( null )

    if( state.isVersion || state.isTag )
    {
      let o2 =
      {
        localPath : o.localPath,
        remotePath : null,
        local : 0,
        remote : 0,
        sync : o.sync,
      }

      if( state.isRemoteTag )
      {
        o2.remotePath = state.remotePath;
        o2.remote = state.remote;
        o2.returnVersion = true;
      }
      else
      {
        o2.local = state.original;
      }

      con.then( () => self.exists( o2 ) );
    }
    else
    {
      start({ execPath : `git rev-parse ${state.value}`, ready : con })
    }

    con.then( ( got ) =>
    {
      if( _.boolIs( got ) )
      state.exists = got;
      else if( _.object.isBasic( got ) )
      state.exists = got.exitCode === 0;
      else
      {
        _.assert( _.strDefined( got ) );
        state.value = got;
        state.exists = true;
      }

      return null;
    })

    return con;
  }

  /* - */

  function runDiff()
  {
    if( !state1.exists || !state2.exists )
    return null;

    if( state1.isSpecial && state2.isSpecial )
    if( state1.value === state2.value )
    {
      result.status = o.explaining ? '' : false;
      return null;
    }

    let ready = _.take( null );

    let op =
    {
      execPath : 'git',
      ready
    }

    diffArgsForm();

    start( op )

    ready.then( handleOutput );

    return ready;

    /* */

    function diffArgsForm()
    {
      op.args = [ 'diff', '--exit-code' ]

      if( o.detailing )
      op.args.push( '--raw' )
      else
      op.args.push( '--stat' )

      if( o.generatingPatch )
      op.args.push( '--patch' )

      if( _.numberIs( o.linesOfContext ) )
      op.args.push( `--unified=${o.linesOfContext}` )

      if( o.coloredPatch )
      op.args.push( '--color=always' )
      else
      op.args.push( '--color=never' )

      argsForStateForm( state1 );
      argsForStateForm( state2 );
    }

    /* */

    function argsForStateForm( state )
    {
      if( !state.isSpecial )
      op.args.push( state.value );
      else if( state.value === 'staging' )
      op.args.push( '--staged' )
      else if( state.value === 'committed' )
      op.args.push( 'HEAD' )
      else if( _.strBegins( state.value, 'HEAD' ) )
      op.args.push( state.value );
    }

    /*
    if( state1.value === 'working' )
    start({ execPath : `git diff ${diffMode} --exit-code ${state2.value}`, ready })
    else if( state1.value === 'staging' )
    start({ execPath : `git diff --staged ${diffMode} --exit-code ${state2.value}`, ready })
    else if( state1.value === 'committed' )
    start({ execPath : `git diff ${diffMode} --exit-code HEAD ${state2.value}`, ready })
    else
    start({ execPath : `git diff ${diffMode} --exit-code ${state1.value} ${state2.value}`, ready }) */
  }

  /*  */

  function handleOutput( got )
  {
    result.modifiedFiles = '';
    result.deletedFiles = '';
    result.addedFiles = '';
    result.renamedFiles = '';
    result.copiedFiles = '';
    result.typechangedFiles = '';
    result.unmergedFiles = '';

    let status = '';

    if( o.detailing )
    detailingHandle( got );

    for( var k in result )
    {
      if( !o.detailing )
      result[ k ] = got.exitCode === 1 ? _.maybe : false;
      else if( !o.explaining )
      result[ k ] = !!result[ k ];
      else if( result[ k ] )
      {
        _.assert( _.strDefined( result[ k ] ) );
        status += status ? '\n' + k : k;
        status += ':\n  ' + _.strLinesIndentation( result[ k ], '  ' );
      }
    }

    if( o.generatingPatch )
    result.patch = got.output;

    if( o.explaining && !o.detailing )
    status = got.output;

    result.status = o.explaining ? status : got.exitCode === 1;

    return result;
  }

  /*  */

  function detailingHandle( got )
  {
    let statusToPropertyMap =
    {
      'A' : 'addedFiles',
      // 'C' : 'copiedFiles',
      'C' : 'copiedFiles', /* aaa : ? */ /* Dmytro : fixed, not me, the task resolved in conversation */
      'D' : 'deletedFiles',
      'M' : 'modifiedFiles',
      'R' : 'renamedFiles',
      'T' : 'typechangedFiles',
      'U' : 'unmergedFiles',
    }
    let lines = _.strSplitNonPreserving
    ({
      src : got.output,
      delimeter : '\n',
      stripping : 1,
      preservingEmpty : 1,
    });
    let endOfRawOutput = _.longLeftIndex( lines, '' );
    endOfRawOutput = endOfRawOutput >= 0 ? endOfRawOutput : lines.length;

    for( let i = 0; i < endOfRawOutput; i++ )
    {
      lines[ i ] = _.strSplitNonPreserving({ src : lines[ i ], delimeter : /\s+/, stripping : 1 })
      let type = lines[ i ][ 4 ].charAt( 0 );
      let path = lines[ i ][ 5 ];
      let pName = statusToPropertyMap[ type ];
      if( !pName )
      throw _.err( `Unexpected change type: ${_.strQuote( type )}, filePath: ${_.strQuote( path )}`, got.output );
      if( o.explaining )
      result[ pName ] += result[ pName ] ? '\n' + path : path;
      else
      result[ pName ] = true;
    }
  }

  /* - */

  function handleResult()
  {
    result.state1 = state1;
    result.state2 = state2;
    if( !state1.exists || !state2.exists )
    result.status = _.maybe;
    return result;
  }
}

diff.defaults =
{
  state1 : 'working',
  state2 : 'committed',
  localPath : null,
  detailing : 1,
  explaining : 1,
  generatingPatch : 0, // https://git-scm.com/docs/git-diff.html#Documentation/git-diff.txt---patch
  throwingDoesNotExist : 0,
  linesOfContext : null, // https://git-scm.com/docs/git-diff.html#Documentation/git-diff.txt---unifiedltngt
  coloredPatch : 0, // https://git-scm.com/docs/git-diff.html#Documentation/git-diff.txt---colorltwhengt
  fetchTags : 0,
  sync : 1
}

//

function pull( o )
{
  let ready = _.take( null );

  _.assert( arguments.length === 1 );
  _.routine.options_( pull, arguments );
  _.assert( _.strDefined( o.localPath ) );

  if( o.dry )
  return;

  let start = _.process.starter
  ({
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'shell',
    currentPath : o.localPath,
    throwingExitCode : o.throwing,
    inputMirroring : 1,
    outputPiping : 1,
    logger : o.logger,
    ready,
  });

  start( `git pull` );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }
  return ready;
}

pull.defaults =
{
  localPath : null,
  dry : 0,
  sync : 1,
  logger : null,
  throwing : 0,
};

//

function push( o )
{
  _.assert( arguments.length === 1 );
  _.routine.options_( push, arguments );
  _.assert( _.strDefined( o.localPath ) );

  let ready = _.take( null );

  let start = _.process.starter
  ({
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'shell',
    currentPath : o.localPath,
    throwingExitCode : o.throwing,
    inputMirroring : 1,
    outputPiping : 1,
    logger : o.logger,
    ready,
  });

  let dryRun = o.dry ? ' --dry-run' : '';
  let force = o.force ? ' --force' : '';

  if( o.withHistory )
  start( `git push ${ dryRun } -u origin --all ${ force }` );
  if( o.withTags )
  {
    verifyRemoteRepositoryHasCommitHistory();
    if( !o.force )
    verifyRemoteRepositoryHasNoTag();
    start( `git push ${ dryRun } --tags ${ force }` );
  }

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }
  return ready;

  /* */

  function verifyRemoteRepositoryHasCommitHistory()
  {
    let unpushedTags = tagsUnpushedGet();

    if( unpushedTags.length === 0 )
    return true;

    let commits = tagsCommitsGet( unpushedTags );

    if( _.any( commits, remoteCommitNotExists ) )
    throw _.err
    (
      `Repository at ${ o.localPath } has different commit history on remote server. `,
      `Please, push history manually or enable option {-o.withHistory-}`
    );
    return true;
  }

  /* */

  function tagsUnpushedGet()
  {
    let output = start
    ({
      execPath : 'git push --tags --dry-run',
      sync : 1,
      outputPiping : 0,
      inputMirroring : 0,
    }).output;
    let tags = output.match( /(\S+)\s->/gm );
    if( !tags )
    return [];
    for( let i = 0 ; i < tags.length ; i++ )
    tags[ i ] = tags[ i ].split( ' ' )[ 0 ];
    return tags;
  }

  /* */

  function tagsCommitsGet( tags )
  {
    let result = _.array.make( tags );
    for( let i = 0 ; i < tags.length ; i++ )
    {
      let commit = start({ execPath : `git show-ref -s ${ tags[ i ] }`, sync : 1 }).output;
      result[ i ] = commit.trim();
    }
    return result;
  }

  /* */

  function remoteCommitNotExists( commit )
  {
    let exists =_.git.repositoryHasVersion
    ({
      localPath : o.localPath,
      version : commit.trim(),
      local : 0,
      remote : 1,
    });
    return !exists;
  }

  /* */

  function verifyRemoteRepositoryHasNoTag()
  {
    let currentTag = start({ execPath : 'git describe --abbrev=0 --tags', sync : 1 }).output;
    let repoHasTag = _.git.repositoryHasTag
    ({
      localPath : o.localPath,
      tag : currentTag.trim(),
      local : 0,
      remote : 1,
    });

    if( repoHasTag )
    throw _.err
    (
      `Remote repository of ${ o.localPath } has the same tags as local repository.`,
      `Please, push tags manually or enable option {-o.force-} to rewrite tags`
    );

    return true;
  }
}

push.defaults =
{
  localPath : null,
  withHistory : 1,
  withTags : 0,
  force : 0,
  dry : 0,
  sync : 1,
  throwing : 0,
  logger : null
};

//

function reset_head( routine, args )
{
  _.assert( arguments.length === 2 );

  let o = args[ 0 ];
  _.assert( args.length === 1 );
  _.routine.options( routine, o );
  _.assert( _.strDefined( o.state1 ) );
  _.assert( _.strDefined( o.state2 ) );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.longHas( [ null, 'all' ], o.preset ) );

  o.logger = _.logger.maybe( o.logger );

  if( o.preset === 'all' )
  {
    _.assert( o.state2 === 'committed', 'Preset `all` resets all changes to latest commit' );

    let o2 =
    {
      removingUntracked : 1,
      removingSubrepositories : 1,
      removingIgnored : 1,
    };
    _.mapSupplementNulls( o, o2 );
  }
  else
  {
    let o2 =
    {
      removingUntracked : 1,
      removingSubrepositories : 1,
      removingIgnored : 0,
    };
    _.mapSupplementNulls( o, o2 );
  }
  return o;
}

//

/* aaa : for Dmytro : use _.routine.unite */ /* Dmytro : done */

function reset_body( o )
{
  let self = this;

  // _.assert( arguments.length === 1 );
  // _.routineOptions( reset, arguments );
  // _.assert( _.strDefined( o.state1 ) );
  // _.assert( _.strDefined( o.state2 ) );
  // _.assert( _.strDefined( o.localPath ) );
  // _.assert( _.longHas( [ null, 'all' ], o.preset ) );
  //
  // o.logger = _.logger.maybe( o.logger );
  //
  // if( o.preset === 'all' )
  // {
  //   _.assert( o.state2 === 'committed', 'Preset `all` resets all changes to latest commit' );
  //
  //   let o2 =
  //   {
  //     removingUntracked : 1,
  //     removingSubrepositories : 1,
  //     removingIgnored : 1,
  //   };
  //   // _.mapExtend( o, o2 ); /* aaa : for Dmytro : should supplement */ /* Dmytro : done */
  //   _.mapSupplement( o, o2 );
  // }

  /* */

  let ready = _.take( null );

  let start = _.process.starter
  ({
    sync : 0,
    deasync : 0,
    outputCollecting : 1,
    mode : 'shell',
    currentPath : o.localPath,
    throwingExitCode : 0,
    inputMirroring : 0,
    outputPiping : 0,
    logger : o.logger,
    ready
  });

  /* */

  let state1 = self._stateParse( o.state1 );
  let state2 = self._stateParse( o.state2 );

  if( o.dry )
  return resetDry();

  if( state2.value === 'working' || state2.value === 'staged' )
  return;

  /* */

  let commands = [];

  if( state1.isVersion || state1.isTag )
  commands.push( `git checkout ${ state1.value }` );
  // start( `git checkout ${ state1.value }` );
  /* aaa : for Dmytro : ? */ /* Dmytro : state1 define start point for resetting. If state is not tag or hash, then repository should not change this state */

  if( state2.value === 'committed' )
  commands.push( `git reset --hard` );
  else if( state2.isVersion || state2.isTag )
  commands.push( `git reset --hard ${ state2.value }` );
  // if( state2.value === 'committed' )
  // start( `git reset --hard` );
  // else if( state2.isVersion || state2.isTag )
  // start( `git reset --hard ${ state2.value }` );

  if( o.removingUntracked )
  {
    let command = `git clean -df`
    if( o.removingSubrepositories )
    command += 'f';
    if( o.removingIgnored )
    command += 'x';

    commands.push( command );
    // start( command );
  }

  start( commands );

  /* aaa : should be "git clean -dffx", but not by default */ /* Dmytro : implemented */
  /* aaa : cover each option */ /* Dmytro : covered */

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }
  return ready;

  /* */

  function resetDry()
  {
    let shouldReset = state2.isVersion || state2.isTag || state2.value === 'committed';
    let o2 =
    {
      localPath : o.localPath,
      uncommitted : 0,
      uncommittedUntracked : o.removingUntracked,
      uncommittedAdded : o.removingUntracked,
      uncommittedChanged : shouldReset,
      uncommittedDeleted : shouldReset,
      uncommittedRenamed : shouldReset,
      uncommittedCopied : o.removingUntracked,
      uncommittedIgnored : o.removingUntracked && o.removingIgnored,
      unpushed : 0,
      unpushedCommits : 0,
      unpushedTags : 0,
      unpushedBranches : 0,
      explaining : 1,
      detailing : 1,
      sync : 1
    };
    let status = _.git.statusLocal( o2 );

    /* */

    let msgReset = `Uncommitted changes, would be reseted :`;
    msgReset += status.uncommittedChanged ? `\n${ status.uncommittedChanged }` : ``;
    msgReset += status.uncommittedDeleted ? `\n${ status.uncommittedDeleted }` : ``;
    msgReset += status.uncommittedRenamed ? `\n${ status.uncommittedRenamed }` : ``;
    o.logger.log( msgReset );

    let msgClean = `Uncommitted changes, would be cleaned :`;
    msgClean += status.uncommittedUntracked ? `\n${ status.uncommittedUntracked }` : ``;
    msgClean += status.uncommittedAdded ? `\n${ status.uncommittedAdded }` : ``;
    msgClean += status.uncommittedCopied ? `\n${ status.uncommittedCopied }` : ``;
    msgClean += status.uncommittedIgnored ? `\n${ status.uncommittedIgnored }` : ``;
    o.logger.log( msgClean );
    return true;
  }
}

reset_body.defaults =
{
  // logger : 1,
  state1 : 'working', /* 'working', 'staged', 'committed' some commit or tag */
  state2 : 'committed', /* 'working', 'staged', 'committed' some commit or tag */
  localPath : null,
  preset : null, /*[ null, 'all' ]*/ /* aaa : implement and cover option */ /* Dmytro : implemented, preset supplement options in reset_head */
  // removingUntracked : 1,
  // removingIgnored : 0, /* aaa : implement and cover option */ /* Dmytro : implemented, covered */
  // removingSubrepositories : 1, /* aaa : implement and cover option. option -ffx of git command clean */ /* Dmytro : implemented, covered */
  removingUntracked : null,
  removingIgnored : null,
  removingSubrepositories : null,
  dry : 0, /* aaa : implement and cover option */ /* Dmytro : implemented, covered */
  sync : 1,
  logger : null
};

//

const reset = _.routine.unite( reset_head, reset_body );

//
//

function tagList( o )
{
  _.assert( arguments.length === 1, 'Expects options map {-o-}' );
  _.routine.options( tagList, o );
  _.assert( _.strDefined( o.localPath ), 'Expects local path to git repository {-o.localPath-}' );
  _.assert( _.numberIs( o.lines ), 'Expects number of lines {-o.lines-}' );

  let start = _.process.starter
  ({
    currentPath : o.localPath,
    sync : 1,
    mode : 'spawn',
    outputCollecting : 1,
    throwingExitCode : 1,
    inputMirroring : 0,
    outputPiping : 0,
  });

  let listOptions = o.withDescription ? '-ln' : `-l`;
  let lines = o.withDescription ? o.lines : '';
  let result = start( `git tag ${ listOptions }${ lines }` );

  return result.output;
}

tagList.defaults =
{
  localPath : null,
  withDescription : 1,
  lines : 1,
};

//

/* aaa : for Dmytro : implement tagDelete* - 2 routines for branch and ref tag, cover */ /* Dmytro : implemented and covered */

function tagDeleteBranch( o )
{
  _.assert( arguments.length === 1, 'Expects options map {-o-}' );
  _.routine.options( tagDeleteBranch, o );
  _.assert( _.strDefined( o.localPath ), 'Expects local path to git repository {-o.localPath-}' );
  _.assert( _.strDefined( o.tag ), 'Expects tag {-o.tag-} to delete' );
  _.assert( !!o.local || !!o.remote );

  let ready = _.take( null );
  let start = _.process.starter
  ({
    currentPath : o.localPath,
    sync : o.sync,
    mode : 'shell',
    ready,
    outputCollecting : 1,
    throwingExitCode : o.throwing,
    inputMirroring : 0,
    outputPiping : 0,
  });

  let force = o.force ? '--force' : '';

  let commands = [];
  if( o.local )
  commands.push( `git branch --delete ${ force } ${ o.tag }` );

  if( o.remote )
  {
    let remotePath = _.git.remotePathFromLocal( o.localPath );
    let tagExistsremote = _.git.repositoryHasTag
    ({
      remotePath,
      localPath : o.localPath,
      tag : o.tag,
      remote : 1,
      local : 0
    });
    if( tagExistsremote )
    commands.push( `git push --delete ${ force } origin ${ o.tag }` );
  }

  start( commands );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

tagDeleteBranch.defaults =
{
  localPath : null,
  tag : null,
  force : 1,
  local : 1,
  remote : 1,
  throwing : 1,
  sync : 0,
};

//

function tagDeleteTag( o )
{
  _.assert( arguments.length === 1, 'Expects options map {-o-}' );
  _.routine.options( tagDeleteTag, o );
  _.assert( _.strDefined( o.localPath ), 'Expects local path to git repository {-o.localPath-}' );
  _.assert( _.strDefined( o.tag ), 'Expects tag {-o.tag-} to delete' );
  _.assert( !!o.local || !!o.remote );

  let ready = _.take( null );
  let start = _.process.starter
  ({
    currentPath : o.localPath,
    sync : o.sync,
    mode : 'shell',
    ready,
    outputCollecting : 1,
    throwingExitCode : o.throwing,
    inputMirroring : 0,
    outputPiping : 0,
  });

  let commands = [];
  if( o.local )
  commands.push( `git tag --delete ${ o.tag }` );

  if( o.remote )
  {
    let remotePath = _.git.remotePathFromLocal( o.localPath );
    let tagExistsremote = _.git.repositoryHasTag
    ({
      remotePath,
      localPath : o.localPath,
      tag : o.tag,
      remote : 1,
      local : 0
    });
    if( tagExistsremote )
    commands.push( `git push --delete ${ o.force ? '--force' : '' } origin refs/tags/${ o.tag }` );
  }

  start( commands );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

tagDeleteTag.defaults =
{
  localPath : null,
  tag : null,
  force : 1,
  local : 1,
  remote : 1,
  throwing : 1,
  sync : 0,
};

//

/**
 * Routine tagMake() makes tag for some commit version of repository {-o.toVersion-}.
 * If {-o.toVersion-} is not defined, then tag adds to current HEAD commit.
 *
 * @example
 * // make tag `v0.1` if script run in git repository
 * let tag = _.git.tagMake
 * ({
 *   localPath : _.path.current(),
 *   tag : 'v0.1',
 *   description : 'version 0.1',
 * });
 *
 * @param { Aux } o - Options map.
 * @param { String } o.localPath - Path to git repository on hard drive.
 * @param { String } o.tag - Name of tag.
 * @param { String } o.description - Description of tag.
 * @param { String } o.toVersion - Commit version to add tag. Default is current HEAD commit.
 * @param { BoolLike } o.light - Enable lightweight tags. Default is 0.
 * @param { BoolLike } o.force - Enable force creation of tags, it allows to rewrite tags with same name. Default is 1.
 * @param { BoolLike } o.sync - Enable synchronous execution of code. Default is 1.
 * @returns { Consequence|Aux } - Returns map like object with results of Process execution.
 * or Consequence that handle such Process.
 * @function tagMake
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If {-o.localPath-} is not a String with defined length.
 * @throws { Error } If {-o.tag-} is not a String with defined length.
 * @throws { Error } If added two tags with identical names to single commit and {-o.deleting-} is false.
 * @namespace wTools.git
 * @module Tools/mid/GitTools
 */

function tagMake( o )
{
  _.assert( arguments.length === 1, 'Expects options map {-o-}' );
  _.routine.options( tagMake, o );

  let ready = _.take( null );
  let start = _.process.starter
  ({
    currentPath : o.localPath,
    deasync : 0,
    sync : 0,
    mode : 'shell',
    ready,
    outputCollecting : 1,
    throwingExitCode : 1,
    inputMirroring : 0,
    outputPiping : 0,
    logger : o.logger
  });

  // if( o.deleting )
  // {
  //
  //   ready = _.git.repositoryHasTag
  //   ({
  //     localPath : o.localPath,
  //     tag : o.tag,
  //     local : 1,
  //     remote : 0,
  //     sync : 0,
  //   });
  //
  //   ready.then( ( has ) =>
  //   {
  //     if( has )
  //     return start( `git tag -d ${o.tag}` );
  //     return has;
  //   })
  //
  // }
  // else
  // {
  //   ready = _.take( null );
  // }
  //
  // ready.then( () =>
  // {

  // let command = 'git tag';
  // if( o.force )
  // command += ' -f';
  // if( !o.toVersion )
  // o.toVersion = '';

  // if( o.light )
  // return start( `git tag ${o.tag}` );
  // else
  // return start( `git tag -a ${o.tag} -m "${o.description}"` );

  let provider = _.fileProvider; /* Dmytro : should be hard drive provider */
  let path = provider.path;
  let tag = o.tag;
  let tempPath, description;
  if( !o.light )
  {
    tag = `-a ${ o.tag } -m "${ o.description }"`;
    if( process.platform === 'win32' )
    {
      let lines = _.strCount( o.description, '\n' );
      if( lines )
      {
        tempPath = path.tempOpen( o.description );
        let descriptionPath = path.join( tempPath, 'description' );
        provider.fileWrite( descriptionPath, o.description );
        tag = `-a ${ o.tag } -F ${ path.nativize( descriptionPath ) }`;
      }
    }
  }
  let force = o.force ? '-f' : '';
  let toVersion = o.toVersion ? o.toVersion : '';

  start( `git tag ${ force } ${ tag } ${ toVersion }` );

  ready.finally( ( err, arg ) =>
  {
    if( tempPath )
    path.tempClose( tempPath );

    if( err )
    throw _.err( err );
    return arg;
  });

  // });
  //
  // if( got.exitCode !== 0 || got.output && _.strHas( got.output, 'refs/' ) )
  // return false;

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

tagMake.defaults =
{
  localPath : null,
  tag : null,
  toVersion : null, /* aaa : for Dmytro : implement option, cover */ /* Dmytro : implemented and covered */
  force : 1, /* aaa : for Dmytro : implement option and use it instead of option deleting, cover */ /* Dmytro : implemented and covered */
  description : '',
  light : 0,
  // deleting : 1,
  sync : 1,
  logger : null
};

//

function renormalize( o )
{
  let localProvider = _.fileProvider;
  let path = _.git.path;
  // let path = localProvider.path;

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routine.options_( renormalize, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.localPath ), 'Expects local path' );

  let ready = new _.Consequence();

  if( _.git.isRepository({ localPath : o.localPath }) )
  ready.take( null );
  else
  ready.error( _.err( `Provided path is not a git repository:${o.localPath}` ) );

  // if( !_.git.isRepository({ localPath : o.localPath }) )
  // ready.error( _.err( `Provided path is not a git repository:${o.localPath}` ) );
  // else
  // ready.take( null );

  if( o.safe )
  ready.then( () =>
  {
    return _.git.statusLocal
    ({
      localPath : o.localPath,
      uncommitted : 1,
      detailing : 0,
      unpushed : 1,
      explaining : 0,
      sync : 0,
    });
  })

  ready.then( ( status ) =>
  {
    if( _.object.isBasic( status ) && status.status )
    return true;

    let config = _.git.configRead( o.localPath );

    if( !o.force )
    if( config.core.autocrlf === false )
    return true;

    if( o.audit )
    {
      audit();
    }

    config.core.autocrlf = false;

    _.git.configSave( o.localPath, config );

    return null;
  })

  ready.then( ( skip ) =>
  {
    if( skip )
    return true;

    let con = _.take( null )
    let start = _.process.starter
    ({
      // verbosity : o.verbosity - 1,
      logger : _.logger.relativeMaybe( o.logger, -1 ),
      verbosity : o.logger ? o.logger.verbosity - 1 : 0,
      outputCollecting : 1,
      currentPath : o.localPath,
      ready : con
    });

    start( 'git rm --cached -r .' )
    start( 'git reset --hard' )

    return con;
  })

  ready.catch( ( err ) =>
  {
    if( !o.throwing )
    {
      _.errAttend( err );
      return null;
    }

    throw _.err( `Failed to renormalize repository at: ${o.localPath}\nReason:`, err );
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function audit()
  {
    let attributesPath = path.join( o.localPath, '.gitattributes' );
    if( !localProvider.fileExists( attributesPath ) )
    return;
    let attributes = localProvider.fileRead( attributesPath );
    attributes = _.strSplitNonPreserving( attributes, '\n' );
    attributes = attributes.map( ( e ) => _.strSplitNonPreserving( e, /\s+/ ) );

    attributes = attributes.filter( ( e ) =>
    {
      if( _.longHasAny( e, [ 'text', 'text=auto' ] ) )
      if( !_.longHasAny( e, [ 'eol=crlf', 'eol=lf' ] ) )
      return true;
      return false;
    })

    if( !attributes.length )
    return;

    attributes = attributes.map( ( e ) => e.join( ' ' ) );

    logger.warn( `File .gitattributes from the repository at ${o.localPath} contains lines that can affect the result of EOL normalization.\nThese lines are:\n ${attributes.join('\n')}` );
  }
}

renormalize.defaults =
{
  logger : 0,
  localPath : null,
  sync : 0,
  safe : 1,
  force : 0,
  throwing : 0,
  audit : 0
}

// --
// relations
// --

var KnownHooks =
[
  'applypatch-msg',
  'head-applypatch',
  'post-applypatch',
  'pre-commit',
  'prepare-commit-msg',
  'commit-msg',
  'post-commit',
  'head-rebase',
  'post-checkout',
  'post-merge',
  'head-push',
  'head-receive',
  'update',
  'post-receive',
  'post-update',
  'head-auto-gc',
  'post-rewrite',
]

// --
// declare
// --

let Extension =
{

  protocols : [ 'git', 'git+http', 'git+https', 'git+ssh', 'git+hd', 'git+file' ],

  // dichotomy

  stateIsHash,
  stateIsTag,

  // path

  // objectsParse,
  // pathParse,
  // pathIsFixated,
  // pathFixate,
  // remotePathNormalize /* aaa : for Dmytro : ?? */, /* Dmytro : commented, not used in module */
  // remotePathNativize, /* aaa : for Dmytro : ?? */ /* Dmytro : commented, not used in module */

  remotePathFromLocal,
  insideRepository,
  localPathFromInside,

  // tag

  tagLocalChange,
  tagLocalRetrive,
  tagExplain,

  // version

  versionLocalChange,
  localVersion,
  remoteVersionLatest,
  remoteVersionCurrent,
  versionIsCommitHash,
  versionsRemoteRetrive,
  versionsPull,

  // dichotomy

  isUpToDate,
  hasFiles,
  hasRemote,
  isRepository,
  isHead,
  sureHasOrigin,

  // status

  statusLocal,
  statusRemote,
  status,
  statusFull,

  hasLocalChanges, /* xxx : use instead of _.git.status* in git commands */
  hasRemoteChanges,
  hasChanges,

  // tag and version

  repositoryHasTag,
  repositoryHasVersion,
  repositoryTagToVersion, /* aaa : cover */ /* Dmytro : covered */
  repositoryVersionToTag, /* aaa : cover */ /* Dmytro : covered */
  exists,

  // hook

  hookRegister,
  hookUnregister,
  hookPreservingHardLinksRegister,
  hookPreservingHardLinksUnregister,

  // ignore

  ignoreAdd,
  ignoreRemove,
  ignoreRemoveAll,

  // top

  repositoryInit,
  repositoryDelete, /* qqq : cover */ /* Dmytro : base coverage for remote repository added */
  repositoryClone,
  repositoryCheckout,
  repositoryStash,
  repositoryMerge,

  // config

  configRead,
  configSave,
  configReset, /* aaa : implement routine _.git.configReset() */ /* Dmytro : implemented and covered */

  //

  _stateParse,
  diff,
  pull,
  push,
  reset,

  // tag

  tagList,
  tagDeleteBranch,
  tagDeleteTag,
  tagMake, /* aaa : cover */ /* Dmytro : covered */

  renormalize,

}

/* _.props.extend */Object.assign( _.git, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();

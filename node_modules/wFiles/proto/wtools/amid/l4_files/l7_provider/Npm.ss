( function _Npm_ss_()
{

'use strict';

let Tar;

if( typeof module !== 'undefined' )
{
  // const _ = require( '../../../../node_modules/Tools' );

  // if( !_.FileProvider )
  // require( '../UseMid.s' );

  // _.include( 'wNpmTools' )

  try
  {
    Tar = require( 'tar' );
  }
  catch( err )
  {
  }

}

const _global = _global_;
const _ = _global_.wTools;

//

/**
 @class wFileProviderNpm
 @namespace wTools.FileProvider
 @module Tools/mid/Files
*/

const Parent = _.FileProvider.Partial;
const Self = wFileProviderNpm;
function wFileProviderNpm( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Npm';

_.assert( !_.FileProvider.Npm );

// --
// inter
// --

function finit()
{
  let self = this;
  if( self.claimMap )
  self.claimEnd();
  Parent.prototype.finit.call( self );
}

//

function init( o )
{
  let self = this;
  Parent.prototype.init.call( self, o );
}

// --
// path
// --

/**
 * @typedef {Object} RemotePathComponents
 * @property {String} protocol
 * @property {String} hash
 * @property {String} longPath
 * @property {String} localVcsPath
 * @property {String} remoteVcsPath
 * @property {String} remoteVcsLongerPath
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

/**
 * @summary Parses provided `remotePath` and returns object with components {@link module:Tools/mid/Files.wTools.FileProvider.Npm.RemotePathComponents}.
 * @param {String} remotePath Remote path.
 * @function pathParse
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function pathParse( remotePath )
{
  let self = this;
  return _.npm.pathParse( remotePath );
}

//

/**
 * @summary Returns true if remote path `filePath` has fixed version of npm package.
 * @param {String} filePath Global path.
 * @function pathIsFixated
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function pathIsFixated( filePath )
{
  let self = this;
  return _.npm.pathIsFixated( filePath );
}

//

/**
 * @summary Changes version of package specified in path `o.remotePath` to latest available.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function pathIsFixated
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function pathFixate( o )
{
  let self = this;
  return _.npm.pathFixate( o );
}

//

/**
 * @summary Returns version of npm package located at `o.localPath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Path to npm package on hard drive.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionLocalRetrive
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function versionLocalRetrive( o )
{
  let self = this;
  return _.npm.localVersion( o );
}

//

/**
 * @summary Returns latest version of npm package using its remote path `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionRemoteLatestRetrive
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function versionRemoteLatestRetrive( o )
{
  let self = this;
  return _.npm.remoteVersionLatest( o );
}

//

/**
 * @summary Returns current version of npm package using its remote path `o.remotePath`.
 * @description Returns latest version if no version specified in remote path.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionRemoteCurrentRetrive
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function versionRemoteCurrentRetrive( o )
{
  let self = this;
  return _.npm.remoteVersionCurrent( o );
}

//

/**
 * @summary Returns true if local copy of package `o.localPath` is up to date with remote version `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.remotePath Remote path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function isUpToDate
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function isUpToDate( o )
{
  let self = this;
  return _.npm.isUpToDate( o );
}

//

/**
 * @summary Returns true if path `o.localPath` contains a npm package.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function hasFiles
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function hasFiles( o )
{
  let self = this;
  return _.npm.hasFiles( o );
}

//

/**
 * @summary Returns true if path `o.localPath` contains a package.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function isRepository
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function isRepository( o )
{
  let self = this;
  return _.npm.isRepository( o );
}

//

function hasRemote( o )
{
  let self = this;
  return _.npm.hasRemote( o );
}

// --
// etc
// --

function filesReflectSingle_body( o )
{
  let self = this;
  let path = self.path;

  o.extra = _.routine.options_( { defaults : filesReflectSingle_body.extra }, o.extra || null );

  _.routine.assertOptions( filesReflectSingle_body, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  // _.assert( _.routineIs( o.onUp ) && o.onUp.composed && o.onUp.composed.bodies.length === 0, 'Not supported options' );
  // _.assert( _.routineIs( o.onDown ) && o.onDown.composed && o.onDown.composed.bodies.length === 0, 'Not supported options' );
  // _.assert( _.routineIs( o.onWriteDstUp ) && o.onWriteDstUp.composed && o.onWriteDstUp.composed.bodies.length === 0, 'Not supported options' );
  // _.assert( _.routineIs( o.onWriteDstDown ) && o.onWriteDstDown.composed && o.onWriteDstDown.composed.bodies.length === 0, 'Not supported options' );
  // _.assert( _.routineIs( o.onWriteSrcUp ) && o.onWriteSrcUp.composed && o.onWriteSrcUp.composed.bodies.length === 0, 'Not supported options' );
  // _.assert( _.routineIs( o.onWriteSrcDown ) && o.onWriteSrcDown.composed && o.onWriteSrcDown.composed.bodies.length === 0, 'Not supported options' );

  _.assert( o.onUp === null, 'Not supported options' );
  _.assert( o.onDown === null, 'Not supported options' );
  _.assert( o.onWriteDstUp === null, 'Not supported options' );
  _.assert( o.onWriteDstDown === null, 'Not supported options' );
  _.assert( o.onWriteSrcUp === null, 'Not supported options' );
  _.assert( o.onWriteSrcDown === null, 'Not supported options' );

  _.assert( o.outputFormat === 'record' || o.outputFormat === 'nothing', 'Not supported options' );
  _.assert( o.linkingAction === 'fileCopy' || o.linkingAction === 'hardLinkMaybe' || o.linkingAction === 'softLinkMaybe', 'Not supported options' );
  _.assert( !o.src.hasFiltering(), 'Not supported options' );
  _.assert( !o.dst.hasFiltering(), 'Not supported options' );
  _.assert( o.src.formed === 3 );
  _.assert( o.dst.formed === 3 );
  _.assert( o.srcPath === undefined );
  _.assert( o.filter === undefined );

  defaults.dstRewriting = 1;
  defaults.dstRewritingByDistinct = 1;
  defaults.dstRewritingOnlyPreserving = 0;

  /* */

  let localProvider = o.dst.providerForPath();
  let srcPath = o.src.filePathSimplest();
  let dstPath = o.dst.filePathSimplest();

  // if( _.mapIs( srcPath ) )
  // {
  //   _.assert( _.props.vals( srcPath ).length === 1 );
  //   _.assert( _.props.vals( srcPath )[ 0 ] === true || _.props.vals( srcPath )[ 0 ] === dstPath );
  //   srcPath = _.props.keys( srcPath )[ 0 ];
  // }

  let parsed = self.pathParse( srcPath );
  let version = parsed.hash || parsed.tag;

  /* */

  _.sure( _.strIs( srcPath ) );
  _.sure( _.strIs( dstPath ) );
  _.sure( _.strDefined( parsed.hash ) || _.strDefined( parsed.tag ) );
  _.sure( !parsed.tag || !parsed.hash, 'Does not expected both hash and tag in srcPath:', _.strQuote( srcPath ) );
  _.assert( localProvider instanceof _.FileProvider.HardDrive || localProvider.originalFileProvider instanceof _.FileProvider.HardDrive, 'Support only downloading on hard drive' );
  _.sure( !o.src || !o.src.hasFiltering(), 'Does not support filtering, but {o.src} is not empty' );
  _.sure( !o.dst || !o.dst.hasFiltering(), 'Does not support filtering, but {o.dst} is not empty' );
  // _.sure( !o.filter || !o.filter.hasFiltering(), 'Does not support filtering, but {o.filter} is not empty' );

  /* */

  let result = [];
  let shell = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    sync : 1,
    deasync : 0,
    outputCollecting : 1,
  });

  if( !localProvider.fileExists( path.dir( dstPath ) ) )
  localProvider.dirMake( path.dir( dstPath ) );

  let exists = localProvider.fileExists( dstPath );
  let isDir = localProvider.isDir( dstPath );
  if( exists && !isDir )
  throw occupiedErr();

  /* */

  if( exists )
  {
    if( localProvider.dirRead( dstPath ).length === 0 )
    {
      localProvider.fileDelete( dstPath );
      exists = false;
    }
  }

  if( exists )
  {

    let packageFilePath = path.join( dstPath, 'package.json' );
    if( !localProvider.isTerminal( packageFilePath ) )
    throw occupiedErr( '. Directory is occupied!' );

    try
    {
      let read = localProvider.fileRead({ filePath : packageFilePath, encoding : 'json' });
      if( !read || read.name !== parsed.remoteVcsPath )
      throw _.err( 'Directory is occupied!' );
    }
    catch( err )
    {
      throw _.err( occupiedErr( '' ), err );
    }

    localProvider.filesDelete( dstPath );

  }

  /* */

  let tmpPath = dstPath + '-' + _.idWithGuid();
  localProvider.dirMake( tmpPath );
  let tmpEssentialPath = path.join( tmpPath, 'node_modules', parsed.remoteVcsPath );

  if( o.extra.usingNpm )
  {
    let npmArgs =
    [
      '--no-package-lock',
      '--legacy-bundling',
      '--prefix',
      localProvider.path.nativize( tmpPath ),
      parsed.remoteVcsLongerPath
    ];
    let got = shell({ execPath : 'npm install', args : npmArgs });
    _.assert( got.exitCode === 0 );

    localProvider.fileRename( dstPath, tmpEssentialPath )
    localProvider.filesDelete( path.dir( tmpEssentialPath ) );
    let etcDirPath = path.join( tmpEssentialPath, '../../etc' );
    if( localProvider.fileExists( etcDirPath ) )
    localProvider.fileDelete( etcDirPath );
    localProvider.filesDelete( path.dir( path.dir( tmpEssentialPath ) ) );

    return recordsMake();
  }
  else
  {
    _.assert( Tar !== undefined, 'o.extra.usingNpm:0 mode can\'t be used without package "tar"' );

    let providerHttp = _.FileProvider.Http();
    let tmpPackagePath = localProvider.path.join( tmpEssentialPath, 'package' );
    // let version = parsed.hash || 'latest';
    let registryUrl = `https://registry.npmjs.org/${parsed.remoteVcsPath}/${version}`;
    let tarballDstPath;

    let ready = providerHttp.fileRead({ filePath : registryUrl, sync : 0 })
    .then( ( response ) =>
    {
      response = JSON.parse( response );
      let fileName = providerHttp.path.name({ path : response.dist.tarball, full : 1 });
      tarballDstPath = localProvider.path.join( tmpEssentialPath, fileName );
      return providerHttp.fileCopyToHardDrive({ url : response.dist.tarball, filePath : tarballDstPath });
    })
    .then( () =>
    {
      Tar.x
      ({
        file : localProvider.path.nativize( tarballDstPath ),
        cwd : localProvider.path.nativize( tmpEssentialPath ),
        sync : 1
      });
      localProvider.fileRename( dstPath, tmpPackagePath );
      localProvider.filesDelete( tmpPath );
      return null;
    })
    .finally( ( err, got ) =>
    {
      if( err )
      throw _.err( occupiedErr( '' ), err );
      return recordsMake();
    })

    return ready;
  }

  /* */

  function recordsMake()
  {
    /* qqq : fast solution to return some records instead of empty arrray. find better solution */
    if( o.outputFormat !== 'nothing' )
    o.result = localProvider.filesReflectEvaluate
    ({
      src : { filePath : dstPath },
      dst : { filePath : dstPath },
    });
    return o.result;
  }

  /* */

  function occupiedErr( msg )
  {
    return _.err( 'Cant download NPM package ' + _.color.strFormat( parsed.remoteVcsLongerPath, 'path' ) + ' to ' + _.color.strFormat( dstPath, 'path' ) + ( msg || '' ) )
  }

}

_.routineExtend( filesReflectSingle_body, _.FileProvider.FindMixin.prototype.filesReflectSingle.body );

var extra = filesReflectSingle_body.extra = Object.create( null );
extra.fetching = 0;
extra.usingNpm = 1;

var defaults = filesReflectSingle_body.defaults;

let filesReflectSingle =
_.routine.uniteCloning_replaceByUnite( _.FileProvider.FindMixin.prototype.filesReflectSingle.head, filesReflectSingle_body );

// --
// relations
// --

/**
 * @typedef {Object} Fields
 * @property {Boolean} safe=0
 * @property {String[]} protocols=[ 'npm' ]
 * @property {Boolean} resolvingSoftLink=0
 * @property {Boolean} resolvingTextLink=0
 * @property {Boolean} limitedImplementation=1
 * @property {Boolean} isVcs=1
 * @property {Boolean} usingGlobalPath=1
 * @class wFileProviderNpm
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

let Composes =
{

  safe : 0,
  protocols : _.define.own([ 'npm' ]),

  resolvingSoftLink : 0,
  resolvingTextLink : 0,
  limitedImplementation : 1,
  isVcs : 1,
  usingGlobalPath : 1,

}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{
  Path : _.uri.CloneExtending({ fileProvider : Self }),
}

let Forbids =
{
}

// --
// declare
// --

let Extension =
{

  finit,
  init,


  // vcs

  pathParse,
  pathIsFixated,
  pathFixate,

  versionLocalRetrive,
  versionRemoteLatestRetrive,
  versionRemoteCurrentRetrive,

  isUpToDate,
  hasFiles,
  isRepository,
  hasRemote,

  // etc

  filesReflectSingle,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

// _.FileProvider.FindMixin.mixin( Self );
// _.FileProvider.Secondary.mixin( Self );

//

_.FileProvider[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

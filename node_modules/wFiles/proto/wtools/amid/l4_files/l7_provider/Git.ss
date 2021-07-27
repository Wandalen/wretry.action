( function _Git_ss_()
{

'use strict';

// if( typeof module !== 'undefined' )
// {
//
//   const _ = require( '../../../../node_modules/Tools' );
//   if( !_.FileProvider )
//   require( '../UseMid.s' );
//
//   _.include( 'wGitTools' );
// }

const _global = _global_;
const _ = _global_.wTools;

//

/**
 @classdesc Class that allows file manipulations on a git repository. For example, cloning of the repositoty.
 @class wFileProviderGit
 @namespace wTools.FileProvider
 @module Tools/mid/Files
*/

const Parent = _.FileProvider.Partial;
const Self = wFileProviderGit;
function wFileProviderGit( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Git';

_.assert( !_.FileProvider.Git );

// --
// inter
// --

function finit()
{
  let self = this;
  Parent.prototype.finit.call( self );
}

//

function init( o )
{
  let self = this;

  Parent.prototype.init.call( self, o );

}

// --
// vcs
// --

/**
 * @typedef {Object} RemotePathComponents
 * @property {String} protocol
 * @property {String} hash
 * @property {String} longPath
 * @property {String} localVcsPath
 * @property {String} remoteVcsPath
 * @property {String} remoteVcsLongerPath
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

/**
 * @summary Parses provided `remotePath` and returns object with components {@link module:Tools/mid/Files.wTools.FileProvider.Git.RemotePathComponents}.
 * @param {String} remotePath Remote path.
 * @function pathParse
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function pathParse( remotePath )
{
  let self = this;
  return _.git.path.parse( remotePath );
  // return _.git.pathParse( remotePath );
}

//

/**
 * @summary Returns true if remote path `filePath` contains hash of specific commit.
 * @param {String} filePath Global path.
 * @function pathIsFixated
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function pathIsFixated( filePath )
{
  let self = this;
  return _.git.pathIsFixated( filePath );
}

//

/**
 * @summary Changes hash in provided path `o.remotePath` to hash of latest commit available.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @function pathFixate
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function pathFixate( o )
{
  let self = this;
  return _.git.pathFixate( o );
}

//

function versionLocalChange( o )
{
  let self = this;
  return _.git.versionLocalChange( o );
}

//

/**
 * @summary Returns hash of latest commit from git repository located at `o.localPath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Path to git repository on hard drive.
 * @function versionLocalRetrive
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function versionLocalRetrive( o )
{
  let self = this;
  return _.git.localVersion( o );
}

//

/**
 * @summary Returns hash of latest commit from git repository using its remote path `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path to git repository.
 * @function versionRemoteLatestRetrive
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function versionRemoteLatestRetrive( o )
{
  let self = this;
  return _.git.remoteVersionLatest( o );
}

//

/**
 * @summary Returns commit hash from remote path `o.remotePath`.
 * @description Returns hash of latest commit if no hash specified in remote path.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @function versionRemoteCurrentRetrive
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function versionRemoteCurrentRetrive( o )
{
  let self = this;
  return _.git.remoteVersionCurrent( o );
}

//

/**
 * @summary Returns true if local copy of repository `o.localPath` is up to date with remote repository `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to repository.
 * @param {String} o.remotePath Remote path to repository.
 * @function isUpToDate
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function isUpToDate( o )
{
  let self = this;
  return _.git.isUpToDate( o );
}

//

/**
 * @summary Returns true if path `o.localPath` contains a git repository.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @function hasFiles
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function hasFiles( o )
{
  let self = this;
  return _.git.hasFiles( o );
}

//

function isRepository( o )
{
  let self = this;
  return _.git.isRepository( o );
}

//

function hasRemote( o )
{
  let self = this;
  return _.git.hasRemote( o );
}

// --
// etc
// --

/*
qqq : investigate please, fix and cover
  if error then new directory should no be made
  if error and directory ( possibly empty ) existed then it should not be deleted
qqq : make sure downloading works if empty directory exists

 = Message
    Process returned exit code 128
    Launched as "git clone https://github.com/Wandalen/wPathBasic.git ."
     -> Stderr
     -  Cloning into '.'...
     -  fatal: unable to access 'https://github.com/Wandalen/wPathBasic.git/': Could not resolve host: github.com
     -
     -< Stderr
    Failed to download module::reflect-get-path / opener::PathBasic
    Failed to download submodules

*/

function filesReflectSingle_body( o )
{
  let self = this;
  let path = self.path;
  let con = new _.Consequence();

  o.extra = _.routine.options_( { defaults : filesReflectSingle_body.extra }, o.extra || null );
  // o.extra = o.extra || Object.create( null );
  // _.routine.options_( filesReflectSingle_body, o.extra, filesReflectSingle_body.extra );

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

  if( parsed.hash && !parsed.isFixated )
  {
    // let err = _.err( `Source path: ${_.color.strFormat( String( srcPath ), 'path' )} is fixated, but hash: ${_.color.strFormat( String( parsed.hash ), 'path' ) } doesn't look like commit hash.` )
    let err = _.err( `Source path: ( ${_.color.strFormat( String( srcPath ), 'path' )} ) looks like path with tag, but defined as path with version. Please use @ instead of # to specify tag` );
    con.error( err );
    return con;
  }

  /* */

  // _.sure( _.strDefined( parsed.remoteVcsPath ) );
  // _.sure( _.strDefined( parsed.remoteVcsLongerPath ) );
  _.sure( _.strDefined( parsed.longPath ) );
  _.sure( _.strDefined( parsed.hash ) || _.strDefined( parsed.tag ) );
  _.sure( !parsed.tag || !parsed.hash, 'Does not expected both hash and tag in srcPath:', _.strQuote( srcPath ) );
  _.sure( _.strIs( dstPath ) );
  _.assert( localProvider instanceof _.FileProvider.HardDrive || localProvider.originalFileProvider instanceof _.FileProvider.HardDrive, 'Support only downloading on hard drive' );
  _.sure( !o.src || !o.src.hasFiltering(), 'Does not support filtering, but {o.src} is not empty' );
  _.sure( !o.dst || !o.dst.hasFiltering(), 'Does not support filtering, but {o.dst} is not empty' );
  // _.sure( !o.filter || !o.filter.hasFiltering(), 'Does not support filtering, but {o.filter} is not empty' );

  /* */

  let ready = _.Consequence().take( null );
  let shell = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    // logger : _.logger.relativeMaybe( o.verbosity, -1 ), /* xxx : qqq : use filesReflect and in starter */
    ready,
    currentPath : dstPath,
  });

  let shellAll = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    ready,
    currentPath : dstPath,
    throwingExitCode : 0,
    outputCollecting : 1,
  });

  let dstPathCreated = false;
  if( !localProvider.fileExists( dstPath ) )
  {
    localProvider.dirMake( dstPath );
    dstPathCreated = true;
  }

  let gitConfigExists = localProvider.fileExists( path.join( dstPath, '.git' ) );
  let gitMergeFailed = false;

  /* already have repository here */

  // !!! : remove GitConfig
  // if( gitConfigExists )
  // {
  //   let read = localProvider.fileRead( path.join( dstPath, '.git/config' ) );
  //   let config = Ini.parse( read );
  // }

  if( gitConfigExists )
  ready.then( () =>
  {
    return _.git.sureHasOrigin
    ({
      localPath : dstPath,
      remotePath : parsed
    });
  })

  /* no repository yet */

  if( gitConfigExists )
  {
    if( o.extra.fetching ) /* qqq : what is it for? */
    shell( 'git fetch origin' );
    if( o.extra.fetchingTags )
    shell( 'git fetch --tags -f origin' ); /* fetch new tags from remote updating existing local tags */
  }
  else
  {
    /* !!! delete dst dir maybe */
    const o2 =
    {
      remotePath : parsed,
      localPath : dstPath,
      logger : o.verbosity - 1,
    };
    if( o.extra.fetchingDefaults )
    _.mapSupplementNulls( o2, o.extra.fetchingDefaults );
    ready.then( () => _.git.repositoryClone( o2 ) );
  }
  // if( !gitConfigExists )
  // {
  //   /* !!! delete dst dir maybe */
  //   ready.then( () => _.git.repositoryClone
  //   ({
  //     remotePath : parsed,
  //     localPath : dstPath,
  //     logger : o.verbosity - 1
  //   }))
  //
  // }
  // else
  // {
  //   if( o.extra.fetching ) /* qqq : what is it for? */
  //   shell( 'git fetch origin' );
  //   if( o.extra.fetchingTags )
  //   shell( 'git fetch --tags -f origin' ); /* fetch new tags from remote updating existing local tags */
  // }

  let localChanges = false;
  let mergeIsNeeded = false;
  let tagIsBranchName = false;
  if( gitConfigExists )
  {
    shellAll
    ([
      'git status',
      'git branch'
    ]);

    ready.ifNoErrorThen( ( arg ) =>
    {
      // let args = arg.runs;
      let args = arg.sessions;
      _.assert( args.length === 2 );
      localChanges = _.strHasAny( args[ 0 ].output, [ 'Changes to be committed', 'Changes not staged for commit' ] );
      mergeIsNeeded = mergeIsNeededCheck( args[ 0 ].output );
      if( parsed.tag )
      tagIsBranchName = _.strHas( args[ 1 ].output, parsed.tag );
      return localChanges;
    })
  }

  /* stash changes and checkout branch/commit */

  ready.catch( ( err ) =>
  {
    con.error( err );
    throw err;
  });

  ready.ifNoErrorThen( ( arg ) =>
  {
    if( localChanges )
    if( o.extra.stashing )
    ready.then( () =>
    {
      return _.git.repositoryStash
      ({
        localPath : dstPath,
        pop : 0,
        logger : o.verbosity - 1
      })
    })

    ready.then( () => gitCheckout() )

    if( !mergeIsNeeded )
    ready.then( () =>
    {
      return shellAll({ execPath : 'git status', ready : null })
      .ifNoErrorThen( ( arg ) =>
      {
        mergeIsNeeded = mergeIsNeededCheck( arg.output );
        return null;
      })
    })

    ready.then( () =>
    {
      if( mergeIsNeeded && tagIsBranchName )
      {
        if( localChanges && !o.extra.stashing )
        {
          let err = _.err( 'Failed to merge remote-tracking branch in repository at', _.strQuote( dstPath ), ', repository has local changes and stashing is disabled.' );
          con.error( err );
          throw err;
        }

        return gitMerge();
      }
      return null;
    })

    if( localChanges )
    if( o.extra.stashing )
    ready.then( () => gitStashPop() )

    ready.finally( con );

    return arg;
  });

  /* handle error if any */

  con
  .finally( function( err, arg )
  {
    if( err )
    {
      if( dstPathCreated )
      localProvider.filesDelete( dstPath );
      throw _.err( err );
    }
    return recordsMake();
  });

  return con;

  /* */

  function mergeIsNeededCheck( statusOutput )
  {
    return !_.strHasAny( statusOutput, [ 'Your branch is up to date', 'Your branch is up-to-date' ] );
  }

  /* */

  function recordsMake()
  {
    /* zzz : fast solution to return records instead of empty array */
    // if( o.extra.makingRecordsFast )
    // o.result = localProvider.dirRead({ filePath : dstPath, outputFormat : 'record' });
    // else
    if( o.outputFormat !== 'nothing' )
    o.result = localProvider.filesReflectEvaluate
    ({
      src : { filePath : dstPath },
      dst : { filePath : dstPath },
    });
    return o.result;
  }

  /* */

  function gitCheckout()
  {
    return _.git.repositoryCheckout
    ({
      remotePath : parsed,
      localPath : dstPath,
      logger : o.verbosity - 1,
    })
    .catch( ( err ) =>
    {
      if( err.reason === 'git' )
      handleGitError( err );
      else
      throw err;
    })
  }

  /*  */

  function gitMerge()
  {
    return _.git.repositoryMerge
    ({
      localPath : dstPath,
      logger : o.verbosity - 1
    })
    .catch( ( err ) =>
    {
      if( err.reason !== 'git' )
      throw err;
      gitMergeFailed = true;
      handleGitError( err );
    })
  }

  /* */

  function gitStashPop()
  {
    if( gitMergeFailed )
    {
      if( o.verbosity >= 1 )
      self.logger.log( 'Can\'t pop stashed changes due merge conflict at ' + _.strQuote( dstPath ) );
      return null;
    }

    return _.git.repositoryStash
    ({
      localPath : dstPath,
      pop : 1,
      logger : o.verbosity - 1
    })
    .catch( ( err ) =>
    {
      if( err.reason === 'git' )
      handleGitError( err );
      else
      throw err;
    })
  }

  /* */

  function handleGitError( err )
  {
    if( self.throwingGitErrors )
    throw _.errBrief( err );
    else if( o.logger && o.logger.verbosity >= 1 )
    self.logger.log( err );
  }

}

_.routineExtend( filesReflectSingle_body, _.FileProvider.FindMixin.prototype.filesReflectSingle.body );

var extra = filesReflectSingle_body.extra = Object.create( null );
extra.fetching = 1;
extra.fetchingTags = 0;
extra.stashing = 0;
extra.fetchingDefaults = null;

var defaults = filesReflectSingle_body.defaults;
let filesReflectSingle =
_.routine.uniteCloning_replaceByUnite( _.FileProvider.FindMixin.prototype.filesReflectSingle.head, filesReflectSingle_body );

// --
// relations
// --

/**
 * @typedef {Object} Fields
 * @property {Boolean} safe
 * @property {String[]} protocols=[ 'git', 'git+http', 'git+https', 'git+ssh' ]
 * @property {Boolean} resolvingSoftLink=0
 * @property {Boolean} resolvingTextLink=0
 * @property {Boolean} limitedImplementation=1
 * @property {Boolean} isVcs=1
 * @property {Boolean} usingGlobalPath=1
 * @class wFileProviderGit
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

let Composes =
{

  safe : 0,
  protocols : _.define.own([ 'git', 'git+http', 'git+https', 'git+ssh', 'git+hd' ]),

  resolvingSoftLink : 0,
  resolvingTextLink : 0,
  limitedImplementation : 1,
  isVcs : 1,
  usingGlobalPath : 1,
  globing : 0,

  throwingGitErrors : 1

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
  claimMap : 'claimMap',
  claimProvider : 'claimProvider'
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

  versionLocalChange,
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

// --
// export
// --

_.FileProvider[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

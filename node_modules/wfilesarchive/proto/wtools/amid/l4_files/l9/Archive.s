( function _FilesArchive_s_()
{

'use strict';

//

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wFilesArchive;
function wFilesArchive( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'FilesArchive';

//

function init( o )
{
  let archive = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( archive );
  Object.preventExtensions( archive )

  if( o )
  {
    if( o.fileProvider )
    archive.fileProvider = o.fileProvider;
    archive.copy( o );
  }

  // yyy
  // if( archive.fileProvider && archive.fileProvider.safe >= 2 )
  // archive.fileProvider.safe = 1;

}

//

function filesUpdate()
{
  let archive = this;
  let fileProvider = archive.fileProvider;
  let path = fileProvider.path;
  let time = _.time.now();

  let fileMapOld = archive.fileMap;
  archive.fileAddedMap = Object.create( null );
  archive.fileRemovedMap = null;
  archive.fileModifiedMap = Object.create( null );
  archive.hashReadMap = null;

  _.assert( _.strDefined( archive.basePath ) || _.strsDefined( archive.basePath ) );
  _.assert( archive.basePath.length >= 1 );
  _.assert
  (
    _.all( fileProvider.statsResolvedRead( path.s.fromGlob( archive.basePath ) ) )
    , () => 'Some base paths do not exist:\n'
    + '  ' + path.s.fromGlob( _.array.as( archive.basePath ) )
    .filter( ( basePath ) => fileProvider.statResolvedRead( basePath ) )
    .join( '\n  ' )
  );

  let filePath;
  let basePath = _.array.as( archive.basePath );

  filePath = basePath.map( ( basePath ) =>
  {
    if( path.isGlob( basePath ) )
    return basePath;
    else
    return _.strJoin([ basePath, '/**' ]);
  });

  if( ( archive.logger ? archive.logger.verbosity : 0 ) >= 3 )
  logger.log( ' : filesUpdate', filePath );

  /* */

  let fileMapNew = Object.create( null );

  /* */

  archive.mask = _.RegexpObject( archive.mask );

  if( archive.includingPath || archive.excludingPath )
  {
    let includingPath = archive.includingPath ? _.array.as( archive.includingPath ) : [];
    let excludingPath = archive.excludingPath ? _.array.as( archive.excludingPath ) : [];
    _.assert( _.strsDefined( includingPath ) );
    _.assert( _.strsDefined( excludingPath ) );
    filePath = _.path.mapExtend( null, filePath );
    includingPath = includingPath.length ? path.s.joinCross( basePath, includingPath ) : includingPath; /* xxx : simplify after fix of joinCross */
    excludingPath = excludingPath.length ? path.s.joinCross( basePath, excludingPath ) : excludingPath; /* xxx : simplify after fix of joinCross */
    includingPath.forEach( ( p ) => filePath[ p ] = true );
    excludingPath.forEach( ( p ) => filePath[ p ] = false );
  }

  let files = [];
  let found = fileProvider.filesFind
  ({
    filePath,
    filter :
    {
      maskAll : archive.mask,
      maskTransientAll : archive.mask,
    },
    mode : 'distinct',
    onUp : onFile,
    withTerminals : 1,
    withDirs : 1,
    withStem : 1,
    resolvingSoftLink : 1,
    maskPreset : 0,
    allowingMissed : archive.allowingMissed,
    allowingCycled : archive.allowingCycled,
  });

  archive.fileRemovedMap = fileMapOld;
  archive.fileMap = fileMapNew;

  if( archive.fileMapAutosaving )
  archive.storageSave();

  if( ( archive.logger ? archive.logger.verbosity : 0 ) >= 8 )
  {
    logger.log( 'fileAddedMap', archive.fileAddedMap );
    logger.log( 'fileRemovedMap', archive.fileRemovedMap );
    logger.log( 'fileModifiedMap', archive.fileModifiedMap );
  }
  else if( ( archive.logger ? archive.logger.verbosity : 0 ) >= 6 )
  {
    logger.log( 'fileAddedMap', _.entity.lengthOf( archive.fileAddedMap ) );
    logger.log( 'fileRemovedMap', _.entity.lengthOf( archive.fileRemovedMap ) );
    logger.log( 'fileModifiedMap', _.entity.lengthOf( archive.fileModifiedMap ) );
  }

  if( ( archive.logger ? archive.logger.verbosity : 0 ) >= 4 )
  {
    logger.log( ' . filesUpdate', filePath, 'found', _.entity.lengthOf( fileMapNew ), 'file(s)', _.time.spent( 'in ', time ) );
  }

  return archive;

  /* */

  function onFile( fileRecord, op )
  {
    let d = null;

    if( !fileRecord.stat )
    return fileRecord;

    let isDir = fileRecord.stat.isDir();

    if( isDir )
    if( archive.fileMapAutoLoading )
    {
      let loaded = archive._storageFilesRead( fileRecord.absolute );
      let storagageFilePath = archive.storageFileFromDirPath( fileRecord.absolute );
      let storage = loaded[ storagageFilePath ].storage;
      if( storage && fileRecord.isStem )
      archive.storageLoaded({ storageFilePath : storagageFilePath, storage });
    }

    if( ( archive.logger ? archive.logger.verbosity : 0 ) >= 7 )
    logger.log( ' . investigating ' + fileRecord.absolute );

    if( fileMapOld[ fileRecord.absolute ] )
    {
      d = _.props.extend( null, fileMapOld[ fileRecord.absolute ] );
      files.push( d );
      delete fileMapOld[ fileRecord.absolute ];
      let same = true;
      same = same && d.mtime === fileRecord.stat.mtime.getTime();
      same = same && d.birthtime === fileRecord.stat.birthtime.getTime();
      same = same && ( isDir || d.size === fileRecord.stat.size );
      if( same && archive.comparingRelyOnHardLinks && !isDir )
      {
        same = d.nlink === fileRecord.stat.nlink;
      }

      if( same )
      {
        fileMapNew[ d.absolutePath ] = d;
        return fileRecord;
      }
      else
      {
        if( ( archive.logger ? archive.logger.verbosity : 0 ) >= 5 )
        logger.log( ' . change ' + fileRecord.absolute );
        archive.fileModifiedMap[ fileRecord.absolute ] = d;
        d = _.props.extend( null, d );
      }
    }
    else
    {
      d = Object.create( null );
      archive.fileAddedMap[ fileRecord.absolute ] = d;
      files.push( d );
    }

    d.mtime = fileRecord.stat.mtime.getTime();
    d.ctime = fileRecord.stat.ctime.getTime();
    d.birthtime = fileRecord.stat.birthtime.getTime();
    d.absolutePath = fileRecord.absolute;
    if( !isDir )
    {
      d.size = fileRecord.stat.size;
      if( archive.maxSize === null || fileRecord.stat.size <= archive.maxSize )
      d.hash = fileProvider.hashRead({ filePath : fileRecord.absolute, throwing : 0, sync : 1 });
      d.hashOfStat = _.files.stat.hashStatFrom( fileRecord.stat );
      d.nlink = fileRecord.stat.nlink;
    }

    fileMapNew[ d.absolutePath ] = d;

    return fileRecord;
  }

}

//

function filesHashMapForm()
{
  let archive = this;

  _.assert( !archive.hashReadMap );

  archive.hashReadMap = Object.create( null );

  for( let f in archive.fileMap )
  {
    let file = archive.fileMap[ f ];
    if( file.hash )
    if( archive.hashReadMap[ file.hash ] )
    archive.hashReadMap[ file.hash ].push( file.absolutePath );
    else
    archive.hashReadMap[ file.hash ] = [ file.absolutePath ];
  }

  return archive.hashReadMap;
}

//

function filesLinkSame( o ) /* qqq : cover returned value */
{
  let archive = this;
  let provider = archive.fileProvider;
  let hashReadMap = archive.filesHashMapForm();
  let counter = 0;

  o = _.routine.options_( filesLinkSame, arguments );

  for( let f in hashReadMap )
  {
    let files = hashReadMap[ f ];

    if( files.length < 2 )
    continue;

    if( o.consideringFileName )
    {
      let byName = {};
      _.filter_( null, files, function( path )
      {
        let name = _.path.fullName( path );
        if( byName[ name ] )
        byName[ name ].push( path );
        else
        byName[ name ] = [ path ];
      });
      let linked = 0;
      for( let name in byName )
      {
        files = filterFiles( byName[ name ] );
        if( files.length < 2 )
        continue;
        linked += hardLink( files );
      }
      counter += linked;
    }
    else
    {
      files = filterFiles( files );
      if( files.length < 2 )
      continue;
      counter += hardLink( files );
    }
  }

  return counter;

  /* */

  function hardLink( files )
  {
    let r = provider.hardLink
    ({
      dstPath : files,
      verbosity : ( archive.logger ? archive.logger.verbosity : 0 ),
      resolvingDstSoftLink : 1,
      resolvingSrcSoftLink : 1,
    })
    return r ? files.length : 0;
    /* xxx : use linked instead of files.length after fix of hardLink */
  }

  /* */

  function filterFiles( files )
  {
    let fileA;
    let result = files.filter( ( fileB ) =>
    {
      if( !archive.fileMap[ fileB ].size )
      return false;
      fileB = provider.fileRead({ filePath : fileB, encoding : 'meta.original' });
      if( fileA === undefined )
      fileA = provider.fileRead({ filePath : files[ 0 ], encoding : 'meta.original' });
      return _.entity.identicalShallow( fileA, fileB );
    });
    return result;
  }

}

filesLinkSame.defaults =
{
  consideringFileName : 0,
}

//

function restoreLinksBegin()
{
  let archive = this;
  let provider = archive.fileProvider;

  archive.filesUpdate();

}

//

function restoreLinksEnd()
{
  let archive = this;
  let provider = archive.fileProvider;
  let fileMap1 = _.props.extend( null, archive.fileMap );
  let hashReadMap = archive.filesHashMapForm();
  let restored = 0;

  archive.filesUpdate();

  _.assert( !!archive.fileMap, 'restoreLinksBegin should be called before calling restoreLinksEnd' );

  let fileMap2 = _.props.extend( null, archive.fileMap );
  let fileModifiedMap = archive.fileModifiedMap;
  let linkedMap = Object.create( null );

  /* */

  for( let f in fileModifiedMap )
  {
    let modified = fileModifiedMap[ f ];
    let filesWithHash = hashReadMap[ modified.hash ];

    if( linkedMap[ f ] )
    continue;

    if( !hashReadMap[ modified.hash ] ) /* xxx qqq : cover please */
    {
      continue;
    }

    if( !modified.hash )
    continue;

    if( modified.hash === undefined )
    continue;

    /* remove removed files and use old file descriptors */

    filesWithHash = _.filter_( null, filesWithHash, ( e ) => fileMap2[ e ] ? fileMap2[ e ] : undefined );

    /* find newest file */

    if( archive.replacingByNewest )
    filesWithHash.sort( ( e1, e2 ) => e2.mtime-e1.mtime );
    else
    filesWithHash.sort( ( e1, e2 ) => e1.mtime-e2.mtime );

    let newest = filesWithHash[ 0 ];
    let mostLinked = _.entityMax( filesWithHash, ( e ) => e.nlink ).element;

    if( mostLinked.absolutePath !== newest.absolutePath )
    {
      let read = provider.fileRead({ filePath : newest.absolutePath, encoding : 'meta.original' });
      provider.fileWrite( mostLinked.absolutePath, read );
    }

    /* use old file descriptors */

    filesWithHash = _.filter_( null, filesWithHash, ( e ) => fileMap1[ e.absolutePath ] );
    mostLinked = fileMap1[ mostLinked.absolutePath ];

    /* verbosity */

    if( ( archive.logger ? archive.logger.verbosity : 0 ) >= 4 )
    logger.log( 'modified', _.entity.exportString( _.select( filesWithHash, '*/absolutePath' ), { levels : 2 } ) );

    /*  */

    let srcPath = mostLinked.absolutePath;
    let srcFile = mostLinked;
    linkedMap[ srcPath ] = srcFile;
    for( let last = 0 ; last < filesWithHash.length ; last++ )
    {
      let dstPath = filesWithHash[ last ].absolutePath;
      if( srcFile.absolutePath === dstPath )
      continue;
      if( linkedMap[ dstPath ] )
      continue;
      let dstFile = filesWithHash[ last ];
      /* if this files where linked before changes, relink them */
      _.assert( !!srcFile.hashOfStat );
      _.assert( !!srcFile.size >= 0 );
      _.assert( !!dstFile.size >= 0 );
      if( srcFile.hashOfStat && srcFile.hashOfStat === dstFile.hashOfStat && srcFile.size > 0 )
      {
        _.assert( dstFile.size === srcFile.size );
        restored += 1;
        provider.hardLink({ dstPath, srcPath, verbosity : ( archive.logger ? archive.logger.verbosity : 0 ) });
        linkedMap[ dstPath ] = filesWithHash[ last ];
      }
    }

  }

  if( ( archive.logger ? archive.logger.verbosity : 0 ) >= 1 )
  logger.log( ' + Restored', restored, 'hardlinks' );
}

//

function _loggerGet()
{
  let self = this;
  const fileProvider = self.fileProvider;
  if( fileProvider )
  return fileProvider.logger;
  return null;
}

//

function _verbosityGet()
{
  let self = this;
  if( !self.logger )
  return 0;
  return self.logger.verbosity;
}

// --
// storage
// --

function storageFilePathToSaveGet( storageDirPath )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;
  let storageFilePath = null;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  storageFilePath = _.select( self.storagesLoaded, '*/filePath' );

  // if( !storageFilePath.length )
  // storageFilePath = path.s.join( path.common( path.s.fromGlob( self.basePath ) ), self.storageFileName );

  if( !storageFilePath.length )
  storageFilePath = path.s.join( path.s.fromGlob( self.basePath ), self.storageFileName );

  _.sure
  (
    _.all( storageFilePath, ( storageFilePath ) => fileProvider.isDir( path.dir( storageFilePath ) ) ),
    () => 'Directory for storage file does not exist ' + _.strQuote( storageFilePath )
  );

  return storageFilePath;
}

//

function storageToSave( o )
{
  let self = this;

  o = _.routine.options_( storageToSave, arguments );

  let storage = self.fileMap;

  if( o.splitting )
  {
    let storageDirPath = _.path.dir( o.storageFilePath );
    let fileMap = self.fileMap;
    storage = Object.create( null );
    for( let m in fileMap )
    {
      if( _.strBegins( m, storageDirPath ) )
      storage[ m ] = fileMap[ m ];
    }
  }

  return storage;
}

storageToSave.defaults =
{
  storageFilePath : null,
  splitting : 1,
}

//

function storageLoaded( o )
{
  let self = this;
  const fileProvider = self.fileProvider;

  _.sure( self.storageIs( o.storage ), () => 'Strange storage : ' + _.entity.exportStringDiagnosticShallow( o.storage ) );
  _.assert( arguments.length === 1, 'Expects exactly two arguments' );
  _.assert( _.strIs( o.storageFilePath ) );

  if( self.storagesLoaded !== undefined )
  {
    _.assert( _.arrayIs( self.storagesLoaded ), () => 'Expects {-self.storagesLoaded-}, but got ' + _.entity.strType( self.storagesLoaded ) );
    self.storagesLoaded.push({ filePath : o.storageFilePath });
  }

  _.props.extend( self.fileMap, o.storage );

  return true;
}

// --
// vars
// --

// let verbositySymbol = Symbol.for( 'verbosity' );
let mask =
{
  excludeAny :
  [
    /(\W|^)node_modules(\W|$)/,
    /\.unique$/,
    /\.git$/,
    /\.svn$/,
    /\.hg$/,
    /\.DS_Store$/,
    /\.tmp($|\/|\.)/,
    /\.big($|\/|\.)/,
    /(^|\/)\-(?!$|\/)/,
  ],
};

// --
// relations
// --

let Composes =
{

  // verbosity : 0,

  basePath : null, /* qqq : cover. try array, glob, array of mix of glob/not glob */
  includingPath : null, /* qqq : cover */
  excludingPath : null, /* qqq : cover */

  comparingRelyOnHardLinks : 0,
  replacingByNewest : 1,
  allowingMissed : 0, /* qqq : cover the option. make a broken link for that */
  allowingCycled : 0, /* qqq : cover the option. make a cycled link for that */
  maxSize : null,

  fileMap : _.define.own( {} ),
  fileAddedMap : _.define.own( {} ),
  fileRemovedMap : _.define.own( {} ),
  fileModifiedMap : _.define.own( {} ),
  hashReadMap : null,

  fileMapAutosaving : 0,
  fileMapAutoLoading : 1,

  mask : _.define.own( mask ), /* zzz : not shallow clone required */

  storageFileName : '.warchive',
  storageSaveAsJs : true,

}

let Aggregates =
{
}

let Associates =
{
  fileProvider : null,
}

let Restricts =
{
  storagesLoaded : _.define.own([]),
}

let Statics =
{
}

let Forbids =
{
  dependencyMap : 'dependencyMap',
}

let Accessors =
{
  logger : { writable : 0 },
  verbosity : { writable : 0 },
}

// --
// declare
// --

let Extension =
{

  init,

  filesUpdate,
  filesHashMapForm,
  filesLinkSame,

  restoreLinksBegin,
  restoreLinksEnd,

  _loggerGet,
  _verbosityGet,

  // storage

  storageFilePathToSaveGet,
  storageToSave,
  storageLoaded,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

//

_.Copyable.mixin( Self );
_.StateStorage.mixin( Self );
// _.Verbal.mixin( Self );
_[ Self.shortName ] = Self;
// _global_[ Self.name ] = _[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();

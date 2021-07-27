( function _StateStorage_s_()
{

'use strict';

/**
 * Mixin to add persistent state storing functionality to a class. StateStorage solves the common problem to persistently store the state of an object. It let save the state in a specific moment ( for example on process exit ) and to restore the state later ( for example on process start ). Use the module to be more cross-platform, don't repeat yourself and forget about details of implementation you don't worry.
  @module Tools/mid/StateStorage
*/

/**
 *  */

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wProto' );
  _.include( 'wFiles' );

}

//

/**
 * @summary Mixin to add persistent state storing functionality to a class.
 * @class wStateStorage
 * @module Tools/mid/StateStorage
*/

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wStateStorage;
function wStateStorage( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'StateStorage';

// --
// save
// --

function _storageFileWrite( o )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;
  let logger = self.logger || _global_.logger;

  _.routine.options( _storageFileWrite, o || null );
  _.assert( o.storage !== undefined && !_.routineIs( o.storage ), () => 'Expects defined data {-o.storage-}' );
  _.assert( arguments.length === 1 );
  _.assert( path.isAbsolute( o.storageFilePath ) );
  _.assert( _.strDefined( self.storageFileName ), 'Expects string field {-storageFileName-}' );
  _.assert( _.routineIs( self.storageToSave ) );

  if( logger.verbosity >= 3 )
  {
    let title = _.strQuote( _.strCapitalize( _.strToTitle( self.storageFileName ) ) );
    logger.log( ' + saving config ' + title + ' at ' + _.strQuote( o.storageFilePath ) );
  }

  let o2 =
  {
    filePath : o.storageFilePath,
    data : o.storage,
    pretty : 1,
    sync : 1,
  }

  /* xxx : replace by write encoders */

  if( self.storageSavingAsJs )
  fileProvider.fileWriteJs( o2 );
  else
  fileProvider.fileWriteJson( o2 );

}

_storageFileWrite.defaults =
{
  storageFilePath : null,
  splitting : 0,
  storage : null,
}

//

function _storageFilesWrite( o )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;

  if( !_.mapIs( o ) )
  o = { storageFilePath : o }

  _.assert( _.strDefined( self.storageFileName ), 'Expects string field {-storageFileName-}' );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.routine.options( _storageFilesWrite, o || null );

  o.storageFilePath = o.storageFilePath || self.storageFilePathToSaveGet();

  let isVector = _.arrayIs( o.storageFilePath );
  _.each( o.storageFilePath, ( storageFilePath ) =>
  {
    let op = Object.create( null );
    op.storageFilePath = storageFilePath;
    op.splitting = isVector;
    op.storage = self.storageToSave( op );
    self._storageFileWrite( op );
  });

  return true;
}

_storageFilesWrite.defaults =
{
  storageFilePath : null,
}

//

/**
 * @summary Saves storage to hard drive.
 * @function storageSave
 * @class wStateStorage
 * @namespace wTools
 * @module Tools/mid/StateStorage
*/

function storageSave()
{
  let self = this;
  let storageFilePath = self.storageFilePathToSaveGet();
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !!storageFilePath, () => 'not clear where to save ' + _.entity.exportStringDiagnosticShallow( storageFilePath ) );

  let result = self._storageFilesWrite({ storageFilePath });

  self.storageFilePathApply( storageFilePath );

  return result;
}

//

/**
 * @summary Returns current storage.
 * @function storageToSave
 * @class wStateStorage
 * @namespace wTools
 * @module Tools/mid/StateStorage
*/

function storageToSave( o )
{
  let self = this;
  let storage = self.storage;
  _.assert( storage !== undefined, '{-self.storage-} is not defined' );
  // _.sure( self.storageIs( storage ), () => 'Strange storage : ' + _.entity.exportStringDiagnosticShallow( storage ) );
  self.storageCheck( storage );
  _.routine.options( storageToSave, arguments || null );
  return storage;
}

storageToSave.defaults =
{
  storageFilePath : null,
  splitting : 0,
  storage : null,
}

// --
// load
// --

function _storageFileRead( o )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;
  let logger = self.logger || _global_.logger;

  if( !_.mapIs( o ) )
  o = { storageFilePath : o }

  _.routine.options( _storageFileRead, o || null );
  _.assert( path.isAbsolute( o.storageFilePath ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !fileProvider.statResolvedRead( o.storageFilePath ) )
  return false;

  /* */

  if( logger.verbosity >= 3 )
  {
    let title = _.strQuote( _.strCapitalize( _.strToTitle( self.storageFileName ) ) );
    logger.log( ' . loading config ' + title + ' at ' + _.strQuote( o.storageFilePath ) );
  }

  o.storage = fileProvider.fileReadJs( o.storageFilePath );

  // let result = self.storageLoaded( read, o );

  return o;
}

_storageFileRead.defaults =
{
  storageFilePath : null,
}

//

function _storageFilesRead( o )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;
  let logger = self.logger || _global_.logger;

  if( !_.mapIs( o ) )
  o = { storageDirPath : o }

  // o.storageDirPath = path.resolve( o.storageDirPath || '.' );
  o.storageDirPath = o.storageDirPath || '.';
  o.storageFilePath = o.storageFilePath || self.storageFileName;
  o.storageFilePath = path.s.join( o.storageDirPath, o.storageFilePath );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!o.storageFilePath );
  _.assert( _.strDefined( self.storageFileName ), 'Expects string field {-storageFileName-}' );
  _.assert( path.s.allAreAbsolute( o.storageFilePath ), 'Expects absolute paths {-o.storageFilePath-}' );
  _.routine.options( _storageFilesRead, o || null );

  let result = Object.create( null );

  _.each( o.storageFilePath, ( storageFilePath ) =>
  {
    let op = Object.create( null );
    op.storageFilePath = storageFilePath;
    self._storageFileRead( op );
    result[ op.storageFilePath ] = op;
  });

  return result;
}

_storageFilesRead.defaults =
{
  storageDirPath : null,
  storageFilePath : null,
}

//

/*
should not throw error if cant load file, but return false
*/

/**
 * @summary Reads storage from a hard drive.
 * @description Path to storage is obtained from {@link module:Tools/mid/StateStorage.wStateStorage#storageFilePathToLoadGet wStateStorage.storageFilePathToLoadGet}.
 * @function storageLoad
 * @returns {Boolean} Returns true if storage is succesfully loaded, otherwise returns false.
 * @class wStateStorage
 * @namespace wTools
 * @module Tools/mid/StateStorage
*/

function storageLoad()
{
  let self = this;
  let storageFilePath = self.storageFilePathToLoadGet();

  _.assert( arguments.length === 0, 'Expects no arguments' );
  // _.sure( !!storageFilePath, 'Cant load storage : not found' );

  if( !storageFilePath )
  return false;

  let read = self._storageFilesRead({ storageFilePath });
  let result = true;
  let storageFilePaths = [];

  _.each( read, ( op, storageFilePath ) =>
  {
    let loaded = self.storageLoaded( op );
    result = loaded && result;
    if( loaded )
    storageFilePaths.push( storageFilePath );
  });

  if( storageFilePaths.length < 2 )
  storageFilePaths = storageFilePaths[ 0 ] || null;

  self.storageFilePathApply( storageFilePath );

  return result;
}

//

/**
 * @summary Loads provided storage. Extends current storage with properties of loaded storage.
 * @param {Object} o Options map.
 * @param {Object} o.storage Source storage.
 * @param {String} o.storageFilePath Path to storage.
 * @function storageLoaded
 * @class wStateStorage
 * @namespace wTools
 * @module Tools/mid/StateStorage
*/

function storageLoaded( o )
{
  let self = this;
  const fileProvider = self.fileProvider;

  self.storageCheck( o.storage );
  _.assert( arguments.length === 1 );
  o = _.routine.options( storageLoaded, arguments );

  if( self.storagesLoaded !== undefined )
  {
    _.assert( _.arrayIs( self.storagesLoaded ), () => 'Expects array {-self.storagesLoaded-}, but got ' + _.entity.strType( self.storagesLoaded ) );
    _.assert( _.strIs( o.storageFilePath ), 'Expects string {-self.storagesLoaded-}' );
    self.storagesLoaded.push({ filePath : o.storageFilePath });
  }

  if( self.storage !== undefined )
  self.storage = _.props.extend( self.storage, o.storage );

  return true;
}

storageLoaded.defaults =
{
  storage : null,
  storageFilePath : null,
}

// --
// path
// --

function storageFilePathApply( storageFilePath )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;

  _.assert( storageFilePath === null || path.s.allAre( storageFilePath ) );

  if( storageFilePath === null )
  {
    if( self.storageFilePath !== undefined )
    self.storageFilePath = null;
    if( self.storageDirPath !== undefined )
    self.storageDirPath = null;
    return false;
  }

  if( self.storageFilePath !== undefined )
  self.storageFilePath = storageFilePath;
  if( self.storageDirPath !== undefined )
  self.storageDirPath = path.s.dir( storageFilePath );

  return _.strIs( storageFilePath ) || storageFilePath.length > 0;
}

//

function storageFileFromDirPath( storageDirPath )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;
  let storageFilePath = null;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.strDefined( self.storageFileName ), 'Expects string field {-storageFileName-}' );

  // storageDirPath = path.s.resolve( storageDirPath );
  storageFilePath = path.s.join( storageDirPath, self.storageFileName );

  return storageFilePath;
}

//

function storagePathGet( o )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.strDefined( self.storageFileName ), 'Expects string field {-storageFileName-}' );
  o = _.routine.options( storagePathGet, o || null );

  /* */

  let pathsDefined = o.storageDirPath || o.storageFilePath;
  if( !pathsDefined && self.storageFilePath !== undefined )
  o.storageFilePath = self.storageFilePath;
  if( !pathsDefined && self.storageDirPath !== undefined )
  o.storageDirPath = self.storageDirPath;

  /* */

  if( !o.storageDirPath && o.storageFilePath )
  o.storageDirPath = path.s.dir( o.storageFilePath );
  o.storageDirPath = path.s.resolve( o.storageDirPath );

  if( !o.storageFilePath )
  o.storageFilePath = self.storageFileFromDirPath( o.storageDirPath );
  o.storageFilePath = path.s.resolve( o.storageDirPath || path.current(), o.storageFilePath );

  o.storageDirPath = path.s.dir( o.storageFilePath );

  return o;
}

storagePathGet.defaults =
{
  storageDirPath : null,
  storageFilePath : null,
}

//

/**
 * @summary Returns path on hard drive where current storage is located.
 * @param {Object} o Options map.
 * @param {String} o.storageDirPath Source storage.
 * @param {String} o.storageFilePath Path to storage.
 * @function storageFilePathToLoadGet
 * @class wStateStorage
 * @namespace wTools
 * @module Tools/mid/StateStorage
*/

function storageFilePathToLoadGet( o )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;
  let result;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  o = self.storagePathGet( o );

  [ o.storageFilePath, o.storageDirPath ] = _.multipleAll([ o.storageFilePath, o.storageDirPath ]);

  /* */

  if( _.arrayIs( o.storageFilePath ) )
  {
    result = Object.create( null );
    result.storageFilePath = [];
    result.storageDirPath = [];
    for( let s = 0 ; s < o.storageFilePath.length ; s++ )
    {
      let r = forPath({ storageFilePath : o.storageFilePath[ s ], storageDirPath : o.storageDirPath[ s ] });
      if( r !== null )
      {
        result.storageFilePath.push( r.storageFilePath );
        result.storageDirPath.push( r.storageDirPath );
      }
    }
    if( !result.storageFilePath.length )
    {
      result.storageFilePath = null;
      result.storageDirPath = null;
    }
  }
  else
  {
    result = forPath( o ) || { storageFilePath : null };
  }

  /* */

  _.sure
  (
    result.storageFilePath === null
    || !!_.all( result.storageFilePath, ( storageFilePath ) => fileProvider.statResolvedRead( storageFilePath ) ),
    () => 'Storage file does not exist ' + _.entity.exportString( o )
  );

  return result.storageFilePath;

  /* - */

  function forPath( o )
  {

    let storageDirPath = o.storageDirPath;
    storageDirPath = path.resolve( storageDirPath );
    o.storageFilePath = path.join( storageDirPath, o.storageFilePath );

    if( !fileProvider.fileExists( o.storageFilePath ) )
    do
    {
      o.storageFilePath = path.join( storageDirPath, self.storageFileName );
      o.storageFilePath = path.resolve( o.storageFilePath );
      if( fileProvider.fileExists( o.storageFilePath ) )
      break;
      storageDirPath = path.dir( storageDirPath );
    }
    while( storageDirPath !== '/..' && storageDirPath !== '/../' );
    if( storageDirPath === '/..' || storageDirPath === '/../' )
    {
      return null;
    }

    return o;
  }

}

storageFilePathToLoadGet.defaults =
{
  storageDirPath : null,
  storageFilePath : null,
}

//

/**
 * @summary Returns path on hard drive where current storage can be saved.
 * @param {Object} o Options map.
 * @param {String} o.storageDirPath Source storage.
 * @param {String} o.storageFilePath Path to storage.
 * @function storageFilePathToSaveGet
 * @class wStateStorage
 * @namespace wTools
 * @module Tools/mid/StateStorage
*/

function storageFilePathToSaveGet( o )
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  o = self.storagePathGet( o );

  let good = _.all( o.storageFilePath, ( storageFilePath ) =>
  {
    let dir = path.dir( storageFilePath );
    return !fileProvider.fileExists( dir ) || fileProvider.isDir( dir );
  })

  _.sure( good, () => 'Directory for storage file does not exist ' + _.strQuote( o.storageFilePath ) );

  return o.storageFilePath;
}

storageFilePathToSaveGet.defaults =
{
  storageDirPath : null,
  storageFilePath : null,
}

// --
// etc
// --

/**
 * @summary Returns true if provided entity `src` is a storage.
 * @param {Object} storage Source storage.
 * @function storageIs
 * @class wStateStorage
 * @namespace wTools
 * @module Tools/mid/StateStorage
*/

function storageIs( storage )
{
  let self = this;
  _.assert( arguments.length === 1 );
  if( !_.object.isBasic( storage ) )
  return false;
  return true;
}

//

/**
 * @summary Checks if provided entity `src` is a storage. Throws an Error if not.
 * @param {Object} storage Source storage.
 * @function storageCheck
 * @class wStateStorage
 * @namespace wTools
 * @module Tools/mid/StateStorage
*/

function storageCheck( storage )
{
  let self = this;
  _.assert( arguments.length === 1 );
  if( !self.storageIs( storage ) )
  throw _.err( 'Strange storage :\n' + _.entity.exportString( storage, { levels : 2, multiline : 1, wrap : 0 } ) );
}

//

function storageDefaultGet()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  let op = Object.create( null );
  op.storageFilePath = self.storagePathGet().storageFilePath;
  op.storage = self.storageToSave( op );

  let defaults = self.Self.FieldsOfRelationsGroups;
  for( let s in op.storage )
  {
    _.sureBriefly( defaults[ s ] !== undefined, 'Not clear what is default value for field', s );
    op.storage[ s ] = defaults[ s ];
  }

  return op;
}

// --
// relations
// --

let MustHave =
{
  storageFileName : null,
  fileProvider : null,
}

let CouldHave =
{
  storageFilePath : null,
  storageDirPath : null,
  storage : null,
  storagesLoaded : null,
  storageSavingAsJs : 1,
}

let Composes =
{
  storageSavingAsJs : 1,
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
}

let Forbids =
{
  storageFor : 'storageFor',
  loadedStorages : 'loadedStorages',
  storageDirPathGet : 'storageDirPathGet',
  _storageLoad : '_storageLoad',
  _storageFileLoad : '_storageFileLoad',
  _storageFileSaveAct : '_storageFileSaveAct',
  _storageFilePathGet : '_storageFilePathGet',
  storageFilePathGet : 'storageFilePathGet',
}

let Accessors =
{
}

// --
// declare
// --

let Supplement =
{

  // save

  _storageFileWrite,
  _storageFilesWrite,
  storageSave,
  storageToSave,

  // load

  _storageFileRead,
  _storageFilesRead,
  storageLoad,
  storageLoaded,

  // path

  storageFilePathApply,
  storageFileFromDirPath,
  storagePathGet,
  storageFilePathToLoadGet,
  storageFilePathToSaveGet,

  // etc

  storageIs,
  storageCheck,
  storageDefaultGet,

  //

  MustHave,
  CouldHave,

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
  supplement : Supplement,
  withMixin : true,
  withClass : true,
});

// --
// export
// --

_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

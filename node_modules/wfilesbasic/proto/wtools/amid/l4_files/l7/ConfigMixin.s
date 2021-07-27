( function _ConfigMixin_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const FileRecord = _.files.FileRecord;
const Abstract = _.FileProvider.Abstract;
const Partial = _.FileProvider.Partial;
const Find = _.FileProvider.FindMixin;
const fileRead = Partial.prototype.fileRead;

_.assert( _.entity.lengthOf( _.files.ReadEncoders ) > 0 );
_.assert( _.routineIs( _.files.FileRecord ) );
_.assert( _.routineIs( Abstract ) );
_.assert( _.routineIs( Partial ) );
_.assert( _.routineIs( Find ) );
_.assert( _.routineIs( fileRead ) );

//

/**
 @classdesc Mixin to add operations on group of files with very specific purpose. For example, it has a method to search for text in files.
 @class wFileProviderConfigMixin
 @namespace wTools.FileProvider
 @module Tools/mid/Files
*/

const Parent = null;
const Self = wFileProviderConfigMixin;
function wFileProviderConfigMixin( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'ConfigMixin';

// --
// read
// --

// function configRead2( o )
// {
//
//   let self = this;
//   o = o || Object.create( null );
//
//   if( _.strIs( o ) )
//   {
//     o = { name : o || null };
//   }
//
//   if( o.dir === undefined )
//   o.dir = self.path.normalize( self.path.effectiveMainDir() );
//
//   if( o.result === undefined )
//   o.result = Object.create( null );
//
//   _.routine.options_( configRead2, o );
//
//   if( !o.name )
//   {
//     o.name = 'config';
//     self._configRead2( o );
//     o.name = 'public';
//     self._configRead2( o );
//     o.name = 'private';
//     self._configRead2( o );
//   }
//   else
//   {
//     self._configRead2( o );
//   }
//
//   return o.result;
// }
//
// configRead2.defaults =
// {
//   name : null,
//   dir : null,
//   result : null,
// }
//
// var having = configRead2.having = Object.create( null );
//
// having.writing = 0;
// having.reading = 1;
// having.driving = 0;
//
// //
//
// function _configRead2( o ) /* zzz : remove? */
// {
//   let self = this;
//   let read;
//
//   // _.include( 'wProcess' );
//
//   if( o.name === undefined )
//   o.name = 'config';
//
//   let terminal = self.path.join( o.dir, o.name );
//
//   /**/
//
//   if( typeof Coffee !== 'undefined' )
//   {
//     let fileName = terminal + '.coffee';
//     if( self.statResolvedRead( fileName ) )
//     {
//
//       read = self.fileReadSync( fileName );
//       read = Coffee.eval( read,
//       {
//         filename : fileName,
//       });
//       _.props.extend( o.result, read );
//
//     }
//   }
//
//   /**/
//
//   let fileName = terminal + '.json';
//   if( self.statResolvedRead( fileName ) )
//   {
//
//     read = self.fileReadSync( fileName );
//     read = JSON.parse( read );
//     _.props.extend( o.result, read );
//
//   }
//
//   /**/
//
//   fileName = terminal + '.s';
//   if( self.statResolvedRead( fileName ) )
//   {
//
//     debugger;
//     read = self.fileReadSync( fileName );
//     read = _.exec( read );
//     _.props.extend( o.result, read );
//
//   }
//
//   return o.result;
// }
//
// _configRead2.defaults = configRead2.defaults;

//

/**
 * @description Finds config files that have name of files from `o.filePath`.
 * Mixes name of files from `o.filePath` with different extensions to find config files that can be read by availbale read encoders.
 * Returns results as array or map.
 * @param {Object} o Options map.
 * @param {Array|String} o.filePath Source paths.
 * @param {String} o.outputFormat='array', Possible formats: array, map.
 * @function configFind
 * @class wFileProviderConfigMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

/*
qqq : cover configFind
*/

function configFind_body( o )
{
  let self = this;
  let path = self.path;
  let result = o.outputFormat === 'array' ? [] : Object.create( null );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longHas( [ 'array', 'map' ], o.outputFormat ) );

  let exts = Object.create( null );

  // debugger;
  // let encoders = _.files.encoder.deduce({ feature : { reader : true }, single : 0 });
  // debugger;

  for( let e in _.files.ReadEncoders )
  {
    let encoder = _.files.ReadEncoders[ e ];
    if( encoder === null )
    continue;
    _.assert( _.object.is( encoder ), `Read encoder ${e} is missing` );
    if( encoder.exts )
    {
      for( let s = 0 ; s < encoder.exts.length ; s++ )
      exts[ encoder.exts[ s ] ] = e;
    }
  }

  o.filePath = _.array.as( o.filePath );
  _.assert( _.strsAreAll( o.filePath ) );

  /* */

  _.each( exts, ( encoderName, ext ) =>
  {
    _.each( o.filePath, ( filePath ) =>
    {
      _.assert( _.strIs( ext ) );
      _.assert( _.strIs( filePath ) );
      let filePath2 = _.strAppendOnce( filePath, '.' + ext );
      if( self.statRead( filePath2 ) )
      {
        let element =
        {
          particularPath : filePath2,
          abstractPath : filePath,
          encoding : exts[ ext ],
          ext,
        }
        if( o.outputFormat === 'array' )
        {
          result.push( element );
        }
        else
        {
          _.sure( result[ filePath ] === undefined, () => 'Several configs exists for ' + _.strQuote( filePath ) );
          result[ filePath ] = element;
        }
      }
    });
  });

  /* */

  return result;
}

var defaults = configFind_body.defaults = Object.create( null );
defaults.filePath = null;
defaults.outputFormat = 'array';
// defaults.recursive = 1;

let configFind = _.routine.uniteCloning_replaceByUnite( Partial.prototype._preFilePathVectorWithProviderDefaults, configFind_body );

//

// function _fileRead_head( routine, args )
// {
//   let self = this;
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( args && args.length === 1 );
//
//   let o = args[ 0 ];
//
//   if( self.path.like( o ) )
//   o = { filePath : self.path.from( o ) };
//
//   _.routine.options_( routine, o );
//
//   o.filePath = self.path.normalize( o.filePath );
//
//   _.assert( self.path.isAbsolute( o.filePath ), 'Expects absolute path {-o.filePath-}, but got', o.filePath );
//
//   if( o.verbosity === null )
//   o.verbosity = _.numberClamp( self.verbosity - 4, 0, 9 );
//
//   self._providerDefaultsApply( o );
//
//   return o;
// }

//

/*
qqq : add test
*/

/**
 * @summary Read config files one by one and extends result with fields from each config file.
 * @description Finds config files if they were not provided through option `o.found`.
 * @param {Object} o Options map.
 * @param {Array|String} o.filePath Source paths.
 * @param {Array|Object} o.found Container to store found config files.
 * @param {String} o.many='all' Checks if each of files `o.filePath` have at least one config file.
 * @function configRead
 * @class wFileProviderConfigMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function configRead_body( o )
{
  let self = this;
  let result = null;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longHas( [ 'all', 'any' ], o.many ) );

  if( !o.found )
  o.found = self.configFind({ filePath : o.filePath });

  /* */

  if( o.many === 'all' )
  {
    let filePath = _.array.as( o.filePath ).slice();
    let found = o.found.slice();

    for( let f1 = filePath.length-1 ; f1 >= 0 ; f1-- )
    {
      let filePath1 = filePath[ f1 ];
      for( let f2 = found.length-1 ; f2 >= 0 ; f2-- )
      if( found[ f2 ].abstractPath === filePath1 || found[ f2 ].particularPath === filePath1 )
      {
        filePath.splice( f1, 1 );
        found.splice( f2, 1 );
        continue;
      }
    }

    for( let f1 = filePath.length-1 ; f1 >= 0 ; f1-- )
    {
      let filePath1 = filePath[ f1 ];
      //debugger;
      if( !o.throwing && o.throwing !== null && o.throwing !== undefined )
      return null;
      throw _.err( 'None config was found\n', _.strQuote( filePath1 ) );
    }

    for( let f2 = found.length-1 ; f2 >= 0 ; f2-- )
    {
      debugger;
      if( !o.throwing && o.throwing !== null && o.throwing !== undefined )
      return null;
      throw _.err( 'Some configs were loaded several times\n', _.strQuote( found[ f2 ].particularPath ) );
    }

  }

  /* */

  if( o.found && o.found.length )
  {

    for( let f = 0 ; f < o.found.length ; f++ )
    {
      let file = o.found[ f ];

      let o2 = _.props.extend( null, o );
      o2.filePath = file.particularPath;
      o2.encoding = file.encoding;
      // if( o2.verbosity >= 2 )
      // o2.verbosity = 5;
      delete o2.many;
      delete o2.found;

      let read = self.fileRead( o2 );

      if( read === undefined )
      read = Object.create( null );

      _.sure( _.mapIs( read ), () => 'Expects map, but read ' + _.entity.exportStringDiagnosticShallow( result ) + ' from ' + o2.filePath );

      if( result === null )
      result = read;
      else
      result = _.mapExtendRecursive( result, read );

    }

  }

  /* */

  if( result === null || result === undefined )
  {
    debugger;
    if( o.throwing )
    throw _.err( 'Found no config at', () => o.filePath + '.*' );
    result = null;
  }

  /* */

  return result;
}

_.routineExtend( configRead_body, fileRead.body );

var defaults = configRead_body.defaults;

defaults.encoding = null;
defaults.many = 'all';
defaults.found = null;

//

var configRead = _.routine.uniteCloning_replaceByUnite( Partial.prototype._preFilePathVectorWithProviderDefaults, configRead_body );

configRead.having.aspect = 'entry';

//

function configUserPath( o )
{
  let self = this;
  let path = self.path;

  if( !_.mapIs( o ) )
  o = { name : o || configUserPath.defaults.name }

  o = _.routine.options_( configUserPath, o );
  _.assert( _.strDefined( o.name ) );

  if( o.filePath )
  return o.filePath;

  let userPath = path.dirUserHome();
  o.filePath = path.join( userPath, o.dirPath, o.name );

  return o.filePath;
}

configUserPath.defaults =
{
  filePath : null,
  dirPath : '.',
  name : '.wenv.yml',
}

//

function configUserRead( o )
{
  let self = this;
  let path = self.path;

  if( !_.mapIs( o ) )
  o = { name : o || configUserRead.defaults.name }

  o = _.routine.options_( configUserRead, o );

  let o2 = _.mapOnly_( null, o, self.configUserPath.defaults );
  let filePath = self.configUserPath( o2 );

  if( !self.fileExists( filePath ) )
  return null;

  if( o.locking )
  self.configUserLock({ filePath });

  return self.configRead
  ({
    filePath,
    throwing : 0,
  });

}

configUserRead.defaults =
{
  ... configUserPath.defaults,
  locking : 0,
}

//

function configUserWrite( o )
{
  let self = this;
  let path = self.path;

  if( !_.mapIs( o ) )
  o = { name : arguments[ 0 ], structure : ( arguments.length > 1 ? arguments[ 1 ] : null ) }
  o = _.routine.options_( configUserWrite, o );
  _.assert( o.structure !== null );

  let o2 = _.mapOnly_( null, o, self.configUserPath.defaults );
  let filePath = self.configUserPath( o2 );

  /* qqq : cover option encoding of method fileWrite */
  /* qqq : cover encoding : _.unknown of method fileWrite */
  let result = self.fileWrite
  ({
    filePath,
    data : o.structure,
    encoding : _.unknown,
    sync : 1,
  });

  _.assert( !_.consequenceLike( result ) );

  if( o.unlocking )
  self.configUserUnlock({ filePath });

  return result;
}

configUserWrite.defaults =
{
  ... configUserPath.defaults,
  structure : null,
  unlocking : 0,
}

//

function configUserLock( o )
{
  let self = this;
  let path = self.path;

  if( !_.mapIs( o ) )
  o = { name : arguments[ 0 ] }
  o = _.routine.options_( configUserLock, o );

  let filePath = self.configUserPath( o );

  return self.fileLock({ filePath });
}

configUserLock.defaults =
{
  ... configUserPath.defaults,
}

//

function configUserUnlock( o )
{
  let self = this;
  let path = self.path;

  if( !_.mapIs( o ) )
  o = { name : arguments[ 0 ] }
  o = _.routine.options_( configUserUnlock, o );

  let filePath = self.configUserPath( o );

  return self.fileUnlock({ filePath });
}

configUserUnlock.defaults =
{
  ... configUserPath.defaults,
}

// --
// storage
// --

function storageNameFrom( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routine.options_( storageNameFrom, o );

  _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );

  return self.path.normalize( o.storageDir );
}

storageNameFrom.defaults =
{
  storageName : null,
  storagePath : null,
  storageDir : null,
}

//

function storagePathFrom( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routine.options_( storagePathFrom, o );

  if( o.storagePath === null )
  o.storagePath = self.configUserPath( o.storageName );

  return o.storagePath;
}

storagePathFrom.defaults =
{
  ... storageNameFrom.defaults,
}

//

function storageNameMapFrom( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routine.options_( storageNameMapFrom, o );

  if( o.storageName === null )
  o.storageName = self.storageNameFrom( o );
  if( o.storagePath === null )
  o.storagePath = self.storagePathFrom( o );

  return o;
}

storageNameMapFrom.defaults =
{
  ... storageNameFrom.defaults,
}

//

function storageRead( o )
{
  let self = this;
  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageDir : arguments[ 0 ] };
    o = _.routine.options_( storageRead, o );

    _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );

    self.storageNameMapFrom( o );

    if( !self.fileExists( o.storagePath ) )
    return null;

    let result = self.filesRead
    ({
      filePath : self.path.join( o.storagePath, '**' ),
      encoding : _.unknown,
    });

    return result.dataMap;
  }
  catch( err )
  {
    throw _.err( err, `\nFailed to read storage::${o.storageName} at ${o.storagePath}` );
  }
}

storageRead.defaults =
{
  ... storageNameMapFrom.defaults,
}

//

function storageDel( o )
{
  let self = this;

  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageDir : arguments[ 0 ] };
    o = _.routine.options_( storageDel, o );

    _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );

    let o2 = _.mapOnly_( null, o, self.storageNameMapFrom.defaults );
    self.storageNameMapFrom( o2 );
    _.props.extend( o, o2 );

    if( self.fileExists( o.storagePath ) )
    self.filesDelete
    ({
      filePath : o.storagePath,
      verbosity : o.verbosity ? 3 : 0,
    });

  }
  catch( err )
  {
    throw _.err( err, `\nFailed to delete storage::${o.storageName} at ${o.storagePath}` );
  }

}

storageDel.defaults =
{
  ... storageNameMapFrom.defaults,
  verbosity : 0,
}

//

function storageProfileNameFrom( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routine.options_( storageProfileNameFrom, o );

  _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );
  _.assert( _.strIs( o.profileDir ), 'Expects defined {- o.profileDir -}' );

  if( o.storageName === null )
  o.storageName = self.path.join
  (
    o.storageDir,
    o.profileDir,
  );

  return o.storageName;
}

storageProfileNameFrom.defaults =
{
  storageDir : null,
  profileDir : 'default',
  storageName : null,
  storagePath : null,
}

//

function storageProfilePathFrom( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routine.options_( storageProfilePathFrom, o );

  if( o.storagePath === null )
  o.storagePath = self.configUserPath( o.storageName );

  return o.storagePath
}

storageProfilePathFrom.defaults =
{
  ... storageProfileNameFrom.defaults,
}

//

function storageProfileNameMapFrom( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routine.options_( storageProfileNameMapFrom, o );

  if( o.storageName === null )
  o.storageName = self.storageProfileNameFrom( o );
  if( o.storagePath === null )
  o.storagePath = self.storageProfilePathFrom( o );

  return o;
}

storageProfileNameMapFrom.defaults =
{
  ... storageProfileNameFrom.defaults,
}

//

function storageProfileRead( o )
{
  let self = this;
  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageDir : arguments[ 0 ] };
    o = _.routine.options_( storageProfileRead, o );

    _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );
    _.assert( _.strIs( o.profileDir ), 'Expects defined {- o.profileDir -}' );

    self.storageProfileNameMapFrom( o );

    if( !self.fileExists( o.storagePath ) )
    return null;

    let result = self.filesRead
    ({
      filePath : self.path.join( o.storagePath, '**' ),
      encoding : _.unknown,
    });

    return result.dataMap;
  }
  catch( err )
  {
    throw _.err( err, `\nFailed to read storage::${o.storageName} at ${o.storagePath}` );
  }
}

storageProfileRead.defaults =
{
  ... storageProfileNameMapFrom.defaults,
}

//

function storageProfileDel( o )
{
  let self = this;

  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageDir : arguments[ 0 ] };
    o = _.routine.options_( storageProfileDel, o );

    _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );
    _.assert( _.strIs( o.profileDir ), 'Expects defined {- o.profileDir -}' );

    let o2 = _.mapOnly_( null, o, self.storageProfileNameMapFrom.defaults );
    self.storageProfileNameMapFrom( o2 );
    _.props.extend( o, o2 );

    if( self.fileExists( o.storagePath ) )
    self.filesDelete
    ({
      filePath : o.storagePath,
      verbosity : o.verbosity ? 3 : 0,
    });

  }
  catch( err )
  {
    throw _.err( err, `\nFailed to delete storage::${o.storageName} at ${o.storagePath}` );
  }

}

storageProfileDel.defaults =
{
  ... storageProfileNameMapFrom.defaults,
  verbosity : 0,
}

//

function storageTerminalNameFrom( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routine.options_( storageTerminalNameFrom, o );

  _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );
  _.assert( _.strIs( o.profileDir ), 'Expects defined {- o.profileDir -}' );
  _.assert( _.strIs( o.storageTerminalPrefix ), 'Expects defined {- o.storageTerminalPrefix -}' );
  _.assert( _.strIs( o.storageTerminal ), 'Expects defined {- o.storageTerminal -}' );
  _.assert( _.strIs( o.storageTerminalPostfix ), 'Expects defined {- o.storageTerminalPostfix -}' );

  if( o.storageName === null )
  o.storageName = self.path.join
  (
    o.storageDir,
    o.profileDir,
    o.storageTerminalPrefix + o.storageTerminal + o.storageTerminalPostfix,
  );

  _.assert( _.strDefined( o.storageName ) );

  return o.storageName;
}

storageTerminalNameFrom.defaults =
{
  storageDir : null,
  profileDir : 'default',
  storageTerminalPrefix : '',
  storageTerminal : null,
  storageTerminalPostfix : '',
  storageName : null,
  storagePath : null,
}

//

function storageTerminalPathFrom( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routine.options_( storageTerminalPathFrom, o );

  if( o.storagePath === null )
  o.storagePath = self.configUserPath( o.storageName );

  // return self.storageTerminalNameMapFrom( o ).storagePath;

  return o.storagePath;
}

storageTerminalPathFrom.defaults =
{
  ... storageTerminalNameFrom.defaults,
}

//

function storageTerminalNameMapFrom( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routine.options_( storageTerminalNameMapFrom, o );

  if( o.storageName === null )
  o.storageName = self.storageTerminalNameFrom( o );
  if( o.storagePath === null )
  o.storagePath = self.storageTerminalPathFrom( o );

  return o;
}

storageTerminalNameMapFrom.defaults =
{
  ... storageTerminalNameFrom.defaults,
}

//

function storageTerminalRead( o )
{
  let self = this;
  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageDir : arguments[ 0 ] };
    o = _.routine.options_( storageTerminalRead, o );

    self.storageTerminalNameMapFrom( o );

    if( !self.fileExists( o.storagePath ) )
    return null;

    return self.configUserRead
    ({
      name : o.storageName,
      locking : 0,
    });

  }
  catch( err )
  {
    throw _.err( err, `\nFailed to read storage::${o.storageName} at ${o.storagePath}` );
  }
}

storageTerminalRead.defaults =
{
  ... storageTerminalNameMapFrom.defaults,
}

//

function storageTerminalOpen( o )
{
  let self = this;
  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageName : arguments[ 0 ] };
    o = _.routine.options_( storageTerminalOpen, o );

    let o2 = _.mapOnly_( null, o, self.storageTerminalNameFrom.defaults );
    self.storageTerminalNameMapFrom( o2 );
    _.props.extend( o, o2 );

    o.storage = self.configUserRead
    ({
      name : o.storageName,
      locking : o.locking,
    });

    if( !o.storage )
    {
      o.storage = o.onStorageConstruct( o );
      _.assert( _.mapIs( o.storage ) );
      self.configUserWrite( o.storageName, o.storage );
      if( o.locking )
      self.configUserLock( o.storageName );
    }

    return o;
  }
  catch( err )
  {
    if( !o.throwing )
    return null;
    throw _.err( err, `\nFailed to open storage::${o.storageName}` );
  }
}

storageTerminalOpen.defaults =
{
  ... storageTerminalNameMapFrom.defaults,
  onStorageConstruct : null,
  locking : 1,
  throwing : 1,
}

//

function storageTerminalClose( o )
{
  let self = this;
  // let storageName;

  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageDir : arguments[ 0 ] };
    o = _.routine.options_( storageTerminalClose, o );

    _.assert( _.mapIs( o.storage ), 'Expects defined {- o.storage -}' );

    let o2 = _.mapOnly_( null, o, self.storageTerminalNameFrom.defaults );
    self.storageTerminalNameMapFrom( o2 );
    _.props.extend( o, o2 );

    o.storage = self.configUserWrite
    ({
      name : o.storageName,
      structure : o.storage,
      unlocking : o.locking,
    });

    return o;
  }
  catch( err )
  {
    if( !o.throwing )
    return null;
    throw _.err( err, `\nFailed to close storage::${storageName}` );
  }
}

storageTerminalClose.defaults =
{
  ... storageTerminalOpen.defaults,
  storage : null,
}

//

function storageTerminalDel( o )
{
  let self = this;
  // let storageName, storagePath;

  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageDir : arguments[ 0 ] };
    o = _.routine.options_( storageTerminalDel, o );

    let o2 = _.mapOnly_( null, o, self.storageTerminalNameMapFrom.defaults );
    self.storageTerminalNameMapFrom( o2 );
    _.props.extend( o, o2 );

    if( self.fileExists( o.storagePath ) )
    self.filesDelete
    ({
      filePath : o.storagePath,
      verbosity : o.verbosity ? 3 : 0,
    });

  }
  catch( err )
  {
    throw _.err( err, `\nFailed to delete storage::${o.storageName} at ${o.storagePath}` );
  }

}

storageTerminalDel.defaults =
{
  ... storageTerminalNameMapFrom.defaults,
  verbosity : 0,
}

// --
// relations
// --

let Composes =
{
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

// --
// declare
// --

let Supplement =
{

  // read

  // configRead2,
  // _configRead2,

  configFind,
  configRead,

  // user config

  configUserPath, /* qqq : cover */
  configUserRead, /* qqq : cover */
  configUserWrite, /* qqq : cover */
  configUserLock, /* qqq : cover */
  configUserUnlock, /* qqq : cover */

  // storage

  storageNameFrom,
  storagePathFrom,
  storageNameMapFrom,
  storageRead,
  storageDel,

  storageProfileNameFrom,
  storageProfilePathFrom,
  storageProfileNameMapFrom,
  storageProfileRead,
  storageProfileDel,

  storageTerminalNameFrom,
  storageTerminalPathFrom,
  storageTerminalNameMapFrom,
  storageTerminalRead,
  storageTerminalOpen,
  storageTerminalClose,
  storageTerminalDel,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,

}

//

_.classDeclare
({
  cls : Self,
  supplement : Supplement,
  withMixin : true,
  withClass : true,
});

_.FileProvider = _.FileProvider || Object.create( null );
_.FileProvider[ Self.shortName ] = Self;
Self.mixin( Partial );

_.assert( !!_.FileProvider.Partial.prototype.configUserRead );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

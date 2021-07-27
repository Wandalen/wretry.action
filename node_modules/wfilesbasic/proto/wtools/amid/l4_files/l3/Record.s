( function _Record_s_()
{

'use strict';

// --
// declare
// --

/**
 * @classdesc Class to create record for a file.
 * @class wFileRecord
 * @namespace wTools
 * @module Tools/mid/Files
*/

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wFileRecord;
function wFileRecord( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'FileRecord';

_.assert( !_.files.FileRecord );

// --
// inter
// --

function init( o )
{
  let record = this;

  if( _.strIs( o ) )
  o = { input : o }

  _.assert( arguments.length === 1 );
  _.assert( !( arguments[ 0 ] instanceof _.files.FileRecordFactory ) );
  _.assert( _.strIs( o.input ), () => 'Expects string {-o.input-}, but got ' + _.entity.strType( o.input ) );
  _.assert( _.object.isBasic( o.factory ) );

  _.workpiece.initFields( record );

  record._filterReset();
  record._statReset();

  // if( _.strEnds( o.input, 'recordStat/file' ) )
  // debugger;

  record.copy( o );

  let f = record.factory;
  if( f.strict )
  Object.preventExtensions( record );

  if( !f.formed )
  {
    if( !f.basePath && !f.dirPath && !f.stemPath )
    {
      f.basePath = _.uri.dir( o.input );
      f.stemPath = f.basePath;
    }
    f.form();
  }

  record.form();
  return record;
}

//

function form()
{
  let record = this;

  _.assert( Object.isFrozen( record.factory ) );
  _.assert( !!record.factory.formed, 'Record factory is not formed' );
  _.assert( record.factory.system instanceof _.FileProvider.Abstract );
  _.assert( record.factory.effectiveProvider instanceof _.FileProvider.Abstract );
  _.assert( _.strIs( record.input ), '{ record.input } must be a string' );
  _.assert( record.factory instanceof _.files.FileRecordFactory, 'Expects instance of { FileRecordFactory }' );

  record._pathsForm();

  _.assert( record.fullName.indexOf( '/' ) === -1, 'something wrong with filename' );

  return record;
}

//

/**
 * @summary Returns a clone of current file record.
 * @function clone
 * @class wFileRecord
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function clone( src )
{
  let record = this;
  let f = record.factory;

  src = src || record.input;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.strIs( src ) );

  let result = _.files.FileRecord({ input : src, factory : f });

  return result;
}

//

/**
 * @summary Creates instance of FileRecord from provided entity `src`.
 * @param {Object|String} src Options map or path to a file.
 * @function From
 * @class wFileRecord
 * @namespace wTools
 * @module Tools/mid/Files
*/

function From( src )
{
  return Self( src );
}

//

/**
 * @summary Creates several instances of FileRecord from provided arguments.
 * @param {Array} src Array with options or paths.
 * @function FromMany
 * @class wFileRecord
 * @namespace wTools
 * @module Tools/mid/Files
*/

function FromMany( src )
{
  let result = [];

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.arrayIs( src ) );

  for( let s = 0 ; s < src.length ; s++ )
  result[ s ] = Self.From( src[ s ] );

  return result;
}

//

/**
 * @summary Returns absolute path to a file associated with provided `record`.
 * @description Uses current instance if no argument provided.
 * @param {Object} record Instance of FileRecord.
 * @function toAbsolute
 * @class wFileRecord
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function toAbsolute( record )
{

  if( record === undefined )
  record = this;

  if( _.strIs( record ) )
  return record;

  _.assert( _.object.isBasic( record ) );

  let result = record.absolute;

  _.assert( _.strIs( result ) );

  return result;
}

//

function _safeCheck()
{
  let record = this;
  let path = record.path;
  let f = record.factory;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( f.safe && f.stating )
  {
    if( record.stat )
    if( !path.isSafe( record.absolute, f.safe ) )
    {
      debugger;
      throw path.ErrorNotSafe( 'Making record', record.absolute, f.safe );
    }
    if( record.stat && !record.stat.isTerminal() && !record.stat.isDir() && !record.stat.isSymbolicLink() )
    {
      debugger;
      throw path.ErrorNotSafe( 'Making record. Unknown kind of file', record.absolute, f.safe );
    }
  }

  return true;
}

//

function _pathsForm()
{
  let record = this;
  let f = record.factory;
  const fileProvider = f.effectiveProvider;
  let path = record.path
  let inputPath = record.input;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.strIs( f.basePath ) );
  _.assert( _.strIs( f.stemPath ) );
  _.assert( path.isAbsolute( f.stemPath ) );

  /* input path */

  inputPath = path.normalize( inputPath );
  let isAbsolute = path.isAbsolute( inputPath );

  if( !isAbsolute )
  if( f.dirPath )
  inputPath = path.join( f.basePath, f.dirPath, f.stemPath, inputPath );
  else if( f.basePath )
  inputPath = path.join( f.basePath, f.stemPath, inputPath );
  else if( !path.isAbsolute( inputPath ) )
  _.assert( 0, 'FileRecordFactory expects defined fields {-dirPath-} or {-basePath-} or absolute path' );

  inputPath = fileProvider.path.preferredFromGlobal( inputPath );

  /* relative path */

  record[ relativeSymbol ] = path.relative( f.basePath, inputPath );
  _.assert( record.relative[ 0 ] !== '/' );
  record[ relativeSymbol ] = path.dot( record.relative );

  /* absolute path */

  if( f.basePath )
  record[ absoluteSymbol ] = path.resolve( f.basePath, record.relative );
  else
  record[ absoluteSymbol ] = inputPath;

  record[ absoluteSymbol ] = path.normalize( record[ absoluteSymbol ] );

  /* */

  f.system._recordFormBegin( record );

  return record;
}

//

function _filterReset()
{
  let record = this;
  let f = record.factory;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  record[ isTransientSymbol ] = null;
  record[ isActualSymbol ] = null;

}

//

function _filterApply()
{
  let record = this;
  let f = record.factory;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( record[ isTransientSymbol ] === null )
  record[ isTransientSymbol ] = true;
  if( record[ isActualSymbol ] === null )
  record[ isActualSymbol ] = true;

  if( f.filter )
  {
    _.assert( f.filter.formed === 5, 'Expects formed filter' );
    f.filter.applyTo( record );
  }

}

//

function _statReset()
{
  let record = this;
  let f = record.factory;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  record[ realSymbol ] = 0;
  record[ statSymbol ] = 0;
  record[ isCycledSymbol ] = null;
  record[ isMissedSymbol ] = null;

}

//

function _statRead()
{
  let record = this;
  let f = record.factory;
  let stat;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  record[ realSymbol ] = record.absolute;

  if( f.resolvingSoftLink || f.resolvingTextLink )
  {

    let o2 =
    {
      system : f.system,
      filePath : record.absolute,
      resolvingSoftLink : f.resolvingSoftLink,
      resolvingTextLink : f.resolvingTextLink,
      resolvingHeadDirect : 1,
      resolvingHeadReverse : 1,
      allowingMissed : f.allowingMissed,
      allowingCycled : f.allowingCycled,
      throwing : 1,
    }

    let resolved = f.effectiveProvider.pathResolveLinkFull( o2 );
    record[ realSymbol ] = resolved.filePath;

    record[ isCycledSymbol ] = !!resolved.isCycled;
    record[ isMissedSymbol ] = !!resolved.isMissed;

    // if( _.strEnds( record.absolute, 'Cycled.txt' ) )
    // debugger;

    stat = o2.stat;
  }

  /* read and set stat */

  if( f.stating )
  {

    _.assert( _.routineIs( f.effectiveProvider.statReadAct ) );
    if( stat === undefined )
    stat = f.effectiveProvider.statReadAct
    ({
      filePath : record.real,
      throwing : 0,
      resolvingSoftLink : 0,
      sync : 1,
    });

    record[ statSymbol ] = stat;

  }

  /* analyze stat */

  return record;
}

//

function _statAnalyze()
{
  let record = this;
  let f = record.factory;
  const fileProvider = f.effectiveProvider;
  let path = record.path;
  let logger = fileProvider.logger || _global.logger;

  _.assert( f instanceof _.files.FileRecordFactory, '_record expects instance of ( FileRecordFactory )' );
  _.assert( fileProvider instanceof _.FileProvider.Abstract, 'Expects file provider instance of FileProvider' );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( f.stating )
  {
    _.assert( record.stat === null || _.fileStatIs( record.stat ) );
    record._safeCheck();
  }

  f.system._recordFormEnd( record );

}

//

/**
 * @summary Resets stats and filter values of current instance.
 * @function reset
 * @class wFileRecord
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function reset()
{
  let record = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  record._filterReset();
  record._statReset();

}

//

/**
 * @summary Changes file extension of current record.
 * @param {String} ext New file extension.
 * @function changeExt
 * @class wFileRecord
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function changeExt( ext )
{
  let record = this;
  let path = record.path;
  _.assert( arguments.length === 1, 'Expects single argument' );
  record.input = path.changeExt( record.input, ext );
}

//

/**
 * @summary Returns file hash of current record.
 * @function hashRead
 * @class wFileRecord
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function hashRead()
{
  let record = this;
  let f = record.factory;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( record.hash !== null )
  return record.hash;

  record.hash = f.effectiveProvider.hashRead
  ({
    filePath : record.absolute,
    logger : 0,
  });

  return record.hash;
}

//

function _isTransientGet()
{
  let record = this;
  let result = record[ isTransientSymbol ];
  if( result === null )
  {
    record._filterApply();
    result = record[ isTransientSymbol ];
  }
  return result;
}

//

function _isTransientSet( src )
{
  let record = this;
  src = !!src;
  record[ isTransientSymbol ] = src;
  return src;
}

//

function _isActualGet()
{
  let record = this;
  let result = record[ isActualSymbol ];
  if( result === null )
  {
    record._filterApply();
    result = record[ isActualSymbol ];
  }
  return result;
}

//

function _isActualSet( src )
{
  let record = this;
  src = !!src;
  record[ isActualSymbol ] = src;
  return src;
}

//

function _isStemGet()
{
  let record = this;
  let f = record.factory;
  return f.stemPath === record.absolute;
}

//

function _isDirGet()
{
  let record = this;

  if( !record.stat )
  return false;

  _.assert( _.routineIs( record.stat.isDir ) );

  return record.stat.isDir();
}

//

function _isTerminalGet()
{
  let record = this;

  if( !record.stat )
  return false;

  _.assert( _.routineIs( record.stat.isTerminal ) );

  return record.stat.isTerminal();
}

//

function _isHardLinkGet()
{
  let record = this;
  let f = record.factory;

  if( !record.stat )
  return false;

  return record.stat.isHardLink();
}

//

function _isSoftLinkGet()
{
  let record = this;
  let f = record.factory;

  if( !f.usingSoftLink )
  return false;

  if( !record.stat )
  return false;

  return record.stat.isSoftLink();
}

//

function _isTextLinkGet()
{
  let record = this;
  let f = record.factory;

  if( !f.usingTextLink )
  return false;

  if( f.resolvingTextLink )
  return false;

  debugger;

  if( !record.stat )
  return false;

  return record.stat.isTextLink();
}

//

function _isLinkGet()
{
  let record = this;
  let f = record.factory;
  return record._isSoftLinkGet() || record._isTextLinkGet();
}

//

function absoluteSet( src )
{
  let record = this;
  let f = record.factory;
  let formed = !!record[ absoluteSymbol ];

  record.reset();

  if( src )
  {
    record[ absoluteSymbol ] = null;
    record[ relativeSymbol ] = null;
    record[ inputSymbol ] = src;
    if( formed )
    record._pathsForm();
  }

}

//

function relativeSet( src )
{
  let record = this;
  let f = record.factory;
  let formed = !!record[ absoluteSymbol ];

  record.reset();

  if( src )
  {
    record[ absoluteSymbol ] = null;
    record[ relativeSymbol ] = null;
    record[ inputSymbol ] = src;
    if( formed )
    record._pathsForm();
  }

}

//

function inputSet( src )
{
  let record = this;
  let f = record.factory;
  let formed = !!record[ absoluteSymbol ];

  record.reset();

  if( src )
  {
    record[ absoluteSymbol ] = null;
    record[ relativeSymbol ] = null;
    record[ inputSymbol ] = src;
    if( formed )
    record._pathsForm();
  }

}

//

function _pathGet()
{
  let record = this;
  let f = record.factory;
  // _.assert( !!f );
  if( !f )
  return null;
  const fileProvider = f.system;
  return fileProvider.path;
}

//

function _effectiveProviderGet()
{
  let record = this;
  let f = record.factory;
  if( !f )
  return null;
  return f.effectiveProvider;
}

//

function _systemGet()
{
  let record = this;
  let f = record.factory;
  if( !f )
  return null;
  return f.effectiveProvider;
}

//

function _statGet()
{
  let record = this;
  if( record[ statSymbol ] === 0 )
  {
    record._statRead();
    record._statAnalyze();
  }
  return record[ statSymbol ];
}

//

function _realGet()
{
  let record = this;
  if( record[ realSymbol ] === 0 )
  {
    debugger;
    record._statRead();
    record._statAnalyze();
  }
  return record[ realSymbol ];
}

//

function _absoluteGlobalGet()
{
  let record = this;
  let f = record.factory;
  const fileProvider = f.effectiveProvider;
  return fileProvider.path.globalFromPreferred( record.absolute );
}

//

function _realGlobalGet()
{
  let record = this;
  let f = record.factory;
  const fileProvider = f.effectiveProvider;
  return fileProvider.path.globalFromPreferred( record.real );
}

//

function _absolutePreferredGet()
{
  let record = this;
  let f = record.factory;
  const fileProvider = f.system;
  return fileProvider._recordAbsoluteGlobalMaybeGet( record );
}

//

function _realPreferredGet()
{
  let record = this;
  let f = record.factory;
  const fileProvider = f.system;
  return fileProvider._recordRealGlobalMaybeGet( record );
}

//

function _dirGet()
{
  let record = this;
  let f = record.factory;
  let path = record.path;
  return path.dir( record.absolute );
}

//

function _extsGet()
{
  let record = this;
  let f = record.factory;
  let path = record.path;
  return path.exts( record.absolute );
}

//

function _extGet()
{
  let record = this;
  let f = record.factory;
  let path = record.path;
  return path.ext( record.absolute );
}

//

function _extWithDotGet()
{
  let record = this;
  let f = record.factory;
  let ext = record.ext;
  return ext ? '.' + ext : '';
}

//

function _qualifiedNameGet()
{
  let record = this;
  let f = record.factory;
  if( f && f.path )
  return '{ ' + record.constructor.shortName + ' : ' + f.path.name( record.absolute ) + ' }';
  else
  return '{ ' + record.constructor.shortName + ' }';
}

//

function _nameGet()
{
  let record = this;
  let f = record.factory;
  let path = record.path;
  return path.name( record.absolute );
}

//

function _fullNameGet()
{
  let record = this;
  let f = record.factory;
  let path = record.path;
  return path.fullName( record.absolute );
}

// --
// statics
// --

function statCopier( it )
{
  let record = this;
  if( it.technique === 'data' )
  return _.props.fields( it.src );
  else
  return it.src;
}

// --
// relations
// --

let statSymbol = Symbol.for( 'stat' );
let realSymbol = Symbol.for( 'real' );
let isTransientSymbol = Symbol.for( 'isTransient' );
let isActualSymbol = Symbol.for( 'isActual' );

let inputSymbol = Symbol.for( 'input' );
let relativeSymbol = Symbol.for( 'relative' );
let absoluteSymbol = Symbol.for( 'absolute' );

let isCycledSymbol = Symbol.for( 'isCycled' );
let isMissedSymbol = Symbol.for( 'isMissed' );

/**
 * @typedef {Object} Fields
 * @property {String} absolute Absolute path to a file.
 * @property {String} relative Relative path to a file.
 * @property {String} input Source path to a file.
 * @property {String} hash Hash of a file.
 * @property {Object} factory Instance of FileRecordFactory.
 * @class wFileRecord
 * @namespace wTools
 * @module Tools/mid/Files
*/

let Composes =
{

  absolute : null,
  relative : null,
  input : null,
  hash : null,
  included : null,

}

let Aggregates =
{
}

let Associates =
{
  factory : null,
  associated : null,
}

let Restricts =
{
}

let Statics =
{
  From,
  FromMany,
  toAbsolute,
}

let Copiers =
{
  stat : statCopier,
}

let Forbids =
{
}

let Accessors =
{

  path : { writable : 0 },
  effectiveProvider : { writable : 0 },
  system : { writable : 0 },
  stat : { writable : 0 },

  real : { writable : 0 },
  absoluteGlobal : { writable : 0 },
  realGlobal : { writable : 0 },
  absolutePreferred : { writable : 0 },
  realPreferred : { writable : 0 },

  dir : { writable : 0 },
  exts : { writable : 0 },
  ext : { writable : 0 },
  extWithDot : { writable : 0 },
  qualifiedName : { writable : 0 },
  name : { writable : 0 },
  fullName : { writable : 0 },

  isTransient : { writable : 1 },
  isActual : { writable : 1 },
  isStem : { writable : 0 },
  isDir : { writable : 0 },
  isTerminal : { writable : 0 },
  isHardLink : { writable : 0 },
  isSoftLink : { writable : 0 },
  isTextLink : { writable : 0 },
  isLink : { writable : 0 },

  isCycled : { set : 0 },
  isMissed : { set : 0 },

  absolute : { set : absoluteSet },
  relative : { set : relativeSet },
  input : { set : inputSet },

}

// --
// defined
// --

let Extension =
{

  init,
  form,
  clone,
  From,
  FromMany,
  toAbsolute,

  _safeCheck,
  _pathsForm,
  _filterReset,
  _filterApply,
  _statReset,
  _statRead,
  _statAnalyze,

  reset,
  changeExt,
  hashRead,

  _isTransientGet,
  _isTransientSet,
  _isActualGet,
  _isActualSet,
  _isStemGet,
  _isDirGet,
  _isTerminalGet,
  _isHardLinkGet,
  _isSoftLinkGet,
  _isTextLinkGet,
  _isLinkGet,

  absoluteSet,
  relativeSet,
  inputSet,

  _pathGet,
  _effectiveProviderGet,
  _systemGet,
  _statGet,

  _realGet,
  _absoluteGlobalGet,
  _realGlobalGet,
  _absolutePreferredGet,
  _realPreferredGet,

  _dirGet,
  _extsGet,
  _extGet,
  _extWithDotGet,
  _qualifiedNameGet,
  _nameGet,
  _fullNameGet,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Copiers,
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

_.Copyable.mixin( Self );

_.assert( !_global_.wFileRecord && !_.files.FileRecord, 'wFileRecord already defined' );

_.files[ Self.shortName ] = Self;

})();

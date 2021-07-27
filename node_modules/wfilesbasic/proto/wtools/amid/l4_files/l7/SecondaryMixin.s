( function _SecondaryMixin_s_()
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
 @class wFileProviderSecondaryMixin
 @namespace wTools.FileProvider
 @module Tools/mid/Files
*/

const Parent = null;
const Self = wFileProviderSecondaryMixin;
function wFileProviderSecondaryMixin( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'SecondaryMixin';

// --
// files read
// --

// function filesReadOld( o )
// {
//   let self = this;
//
//   /* options */
//
//   if( _.arrayIs( o ) )
//   o = { paths : o };
//
//   if( o.preset )
//   {
//     _.assert( _.object.isBasic( filesReadOld.presets[ o.preset ] ), 'unknown preset', o.preset );
//     _.mapSupplementAppending( o, filesReadOld.presets[ o.preset ] );
//   }
//
//   _.routine.options_( filesReadOld, o );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.arrayIs( o.paths ) || _.object.isBasic( o.paths ) || _.strIs( o.paths ) );
//
//   o.onBegin = o.onBegin ? _.array.as( o.onBegin ) : [];
//   o.onEnd = o.onEnd ? _.array.as( o.onEnd ) : [];
//   o.onProgress = o.onProgress ? _.array.as( o.onProgress ) : [];
//
//   let onBegin = o.onBegin;
//   let onEnd = o.onEnd;
//   let onProgress = o.onProgress;
//
//   delete o.onBegin;
//   delete o.onEnd;
//   delete o.onProgress;
//
//   if( Config.debug )
//   {
//     for( let i = 0 ; i < onBegin.length ; i++ )
//     _.assert( onBegin[ i ].length === 1 );
//     for( let i = 0 ; i < onEnd.length ; i++ )
//     _.assert( onEnd[ i ].length === 1 );
//     for( let i = 0 ; i < onProgress.length ; i++ )
//     _.assert( onProgress[ i ].length === 1 );
//   }
//
//   /* paths */
//
//   if( _.object.isBasic( o.paths ) )
//   {
//     let _paths = [];
//     for( let p in o.paths )
//     _paths.push({ filePath : o.paths[ p ], name : p });
//     o.paths = _paths;
//   }
//
//   o.paths = _.array.as( o.paths );
//
//   /* result */
//
//   let result = Object.create( null );
//   result.options = o;
//
//   /* */
//
//   o._filesReadOldEnd = _filesReadOldEnd;
//   o._optionsForFileRead = _optionsForFileRead;
//
//   /* begin */
//
//   _filesReadOldBegin();
//
//   if( o.sync )
//   {
//     return self._filesReadOldSync( o );
//   }
//   else
//   {
//     return self._filesReadOldAsync( o );
//   }
//
//   /* - */
//
//   function _optionsForFileRead( src )
//   {
//     let readOptions = _.mapOnly_( null, o, self.fileRead.defaults );
//     readOptions.onEnd = o.onEach;
//
//     if( _.object.isBasic( src ) )
//     {
//       if( _.files.FileRecord && src instanceof _.files.FileRecord )
//       readOptions.filePath = src.absolute;
//       else
//       _.props.extend( readOptions, _.mapOnly_( null, src, self.fileRead.defaults ) );
//     }
//     else
//     readOptions.filePath = src;
//
//     return readOptions;
//   }
//
//   /* */
//
//   function _filesReadOldBegin()
//   {
//     if( !onBegin.length )
//     return;
//     debugger;
//     _.routinesCall( self, onBegin, [ result ] );
//   }
//
//   /* */
//
//   function _filesReadOldEnd( errs, got )
//   {
//     let err;
//     let errsArray = [];
//
//     for( let k in errs )
//     errsArray.push( errs[ k ] );
//
//     if( errsArray.length )
//     {
//       errs.total = errsArray.length;
//       err = _.err.apply( _, errsArray );
//     }
//
//     let read = got;
//     if( !o.returningRead )
//     read = _.container.map_( null, got, ( e ) => e.result );
//
//     if( o.map === 'name' )
//     {
//
//       let read2 = Object.create( null );
//       let got2 = Object.create( null );
//
//       for( let p = 0 ; p < o.paths.length ; p++ )
//       {
//         let path = o.paths[ p ];
//         let name;
//
//         if( _.strIs( path ) )
//         {
//           name = self.path.name( path );
//         }
//         else if( _.object.isBasic( path ) )
//         {
//           _.assert( _.strIs( path.name ) )
//           name = path.name;
//         }
//         else
//         _.assert( 0, 'unknown type of path', _.entity.strType( path ) );
//
//         read2[ name ] = read[ p ];
//         got2[ name ] = got[ p ];
//       }
//
//       read = read2;
//       got = got2;
//
//     }
//     else if( o.map )
//     _.assert( 0, 'unknown map : ' + o.map );
//
//     result.read = read;
//     result.data = read;
//     result.got = got;
//     result.errs = errs;
//     result.err = err;
//
//     if( onEnd.length )
//     {
//       _.routinesCall( self, onEnd, [ result ] );
//     }
//
//     return result;
//   }
//
// }
//
// filesReadOld.defaults =
// {
//   paths : null,
//   onEach : null,
//   map : '',
//   sync : 1,
//   preset : null,
// }
//
// filesReadOld.defaults.__proto__ = fileRead.defaults;
//
// filesReadOld.presets = Object.create( null );
//
// filesReadOld.presets.js =
// {
//   onEnd : function format( o )
//   {
//     let prefix = '// ======================================\n( function() {\n';
//     let postfix = '\n})();\n';
//     _.assert( _.arrayIs( o.data ) );
//     if( o.data.length > 1 )
//     o.data = prefix + o.data.join( postfix + prefix ) + postfix;
//     else
//     o.data = o.data[ 0 ];
//   }
// }

//

function _filesReadOldSync( o )
{
  let self = this;

  _.assert( !o.onProgress, 'not implemented' );

  let read = [];
  let errs = Object.create( null );

  let _filesReadOldEnd = o._filesReadOldEnd;
  delete o._filesReadOldEnd;

  let _optionsForFileRead = o._optionsForFileRead;
  delete o._optionsForFileRead;

  let throwing = o.throwing;
  o.throwing = 1;

  /* exec */

  for( let p = 0 ; p < o.paths.length ; p++ )
  {
    let readOptions = _optionsForFileRead( o.paths[ p ] );

    try
    {
      read[ p ] = self.fileRead( readOptions );
    }
    catch( err )
    {

      if( throwing )
      throw err;

      errs[ p ] = err;
      read[ p ] = null;
    }
  }

  /* end */

  let result = _filesReadOldEnd( errs, read );

  /* */

  return result;
}

//

function _filesReadOldAsync( o )
{
  let self = this;
  let con = new _.Consequence();

  _.assert( !o.onProgress, 'not implemented' );

  let read = [];
  let errs = [];
  let err = null;

  let _filesReadOldEnd = o._filesReadOldEnd;
  delete o._filesReadOldEnd;

  let _optionsForFileRead = o._optionsForFileRead;
  delete o._optionsForFileRead;

  /* exec */

  for( let p = 0 ; p < o.paths.length ; p++ ) ( function( p )
  {

    con.give( 1 );

    let readOptions = _optionsForFileRead( o.paths[ p ] );

    _.Consequence.From( self.fileRead( readOptions ) ).give( function filesReadOldFileEnd( _err, arg )
    {

      if( _err || arg === undefined || arg === null )
      {
        err = _.errAttend( err );
        err = _.err( 'Cant read : ' + _.entity.exportString( readOptions.filePath ) + '\n', ( _err || 'unknown reason' ) );
        errs[ p ] = err;
      }
      else
      {
        read[ p ] = arg;
      }

      con.take( null );

    });

  })( p );

  /* end */

  con.take( null ).give( function filesReadOldEnd()
  {
    let result = _filesReadOldEnd( errs, read );
    con.take( o.throwing ? err : undefined, result );
  });

  /* */

  return con;
}

// --
// etc
// --

// /**
//  * @summary Returns true if file from `dst` is newer than file from `src`.
//  * @param {String} src Source path.
//  * @param {String} dst Destination path.
//  * @returns {Boolean} Returns result of comparison as boolean.
//  * @function filesAreUpToDate
//  * @class wFileProviderSecondaryMixin
// * @namespace wTools.FileProvider
// * @module Tools/mid/Files
//  */
//
// function filesAreUpToDate( dst, src )
// {
//   let self = this;
//   let odst = dst;
//   let osrc = src;
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   /* */
//
//   dst = from( dst );
//   src = from( src );
//
//   // logger.log( 'dst', dst[ 0 ] );
//   // logger.log( 'src', src[ 0 ] );
//
//   let dstMax = _.entityMax( dst, function( e ){ return e.stat ? e.stat.mtime : Infinity; } );
//   let srcMax = _.entityMax( src, function( e ){ return e.stat ? e.stat.mtime : Infinity; } );
//
//   debugger;
//   // logger.log( 'dstMax.element.stat.mtime', dstMax.element.stat.mtime );
//   // logger.log( 'srcMax.element.stat.mtime', srcMax.element.stat.mtime );
//
//   if( !dstMax.element.stat )
//   return false;
//
//   if( !srcMax.element.stat )
//   return false;
//
//   if( dstMax.element.stat.mtime >= srcMax.element.stat.mtime )
//   return true;
//   else
//   return false;
//
//   /* */
//
//   function _from( file )
//   {
//     if( _.fileStatIs( file ) )
//     return  { stat : file };
//     else if( _.strIs( file ) )
//     return { stat : self.statResolvedRead( file ) };
//     else if( !_.object.isBasic( file ) )
//     throw _.err( 'unknown descriptor of file' );
//   }
//
//   /* */
//
//   function from( file )
//   {
//     if( _.arrayIs( file ) )
//     {
//       let result = [];
//       for( let i = 0 ; i < file.length ; i++ )
//       result[ i ] = _from( file[ i ] );
//       return result;
//     }
//     return [ _from( file ) ];
//   }
//
// }
//
// var having = filesAreUpToDate.having = Object.create( null );
//
// having.writing = 0;
// having.reading = 1;
// having.driving = 0;

//

/**
 * Returns true if any file from o.dst is newer than other any from o.src.
 * @example :
 * wTools.filesAreUpToDate2
 * ({
 *   src : [ 'foo/file1.txt', 'foo/file2.txt' ],
 *   dst : [ 'bar/file1.txt', 'bar/file2.txt' ],
 * });
 * @param {Object} o
 * @param {string[]} o.src array of paths
 * @param {Object} [o.srcOptions]
 * @param {string[]} o.dst array of paths
 * @param {Object} [o.dstOptions]
 * @param {boolean} [o.verbosity=true] turns on/off logging
 * @returns {boolean}
 * @throws {Error} If passed object has unexpected parameter.
 * @function filesAreUpToDate2
 * @class wFileProviderSecondaryMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

/*
qqq :
- add GOOD coverage for the routine filesAreUpToDate2
- make head/body for the routine
*/

function filesAreUpToDate2_head( routine, args )
{
  var o = args[ 0 ];

  _.assert( args.length === 1, 'Expects single argument' )
  _.assert( arguments.length === 2 );
  _.assert( !o.newer || _.dateIs( o.newer ) );

  _.routine.options_( routine, o );

  return o;
}

function filesAreUpToDate2_body( o )
{
  let self = this;
  let factory = self.recordFactory({ allowingMissed : 1 });
  let srcFiles = factory.records( _.array.as( o.src ) );

  if( !srcFiles.length )
  {
    if( o.verbosity )
    logger.log( 'No source' );
    return true;
  }

  /*
    stat could have no mtime
  */

  let srcNewest = _.entityMax( srcFiles, function( file )
  {
    if( !file.stat )
    return +Infinity;
    if( !file.stat.mtime )
    return +Infinity;
    return file.stat.mtime.getTime();
  }).value;

  /* */

  let dstFiles = factory.records( _.array.as( o.dst ) );
  if( !dstFiles.length )
  {
    if( o.verbosity )
    logger.log( 'No destination' );
    return false;
  }

  let dstOldest = _.entityMin( dstFiles, function( file )
  {
    if( !file.stat )
    return -Infinity;
    if( !file.stat.mtime )
    return -Infinity;
    return file.stat.mtime.getTime();
  }).value;

  /* */

  if( o.youngerThan )
  {
    if( o.youngerThan.getTime() >= dstOldest )
    {
      if( o.verbosity )
      logger.log( 'Younger' );
      return true;
    }
    else
    {
      if( o.verbosity )
      logger.log( 'Older' );
      return false;
    }
  }
  else
  {
    if( srcNewest <= dstOldest )
    {
      if( o.verbosity )
      logger.log( 'Up to date' );
      return true;
    }
    else
    {
      if( o.verbosity )
      logger.log( 'Outdated' );
      return false;
    }
  }

}

filesAreUpToDate2_body.defaults =
{
  src : null,
  dst : null,
  verbosity : 0,
  youngerThan : null,
}

var having = filesAreUpToDate2_body.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.driving = 0;

var filesAreUpToDate2 = _.routine.uniteCloning_replaceByUnite( filesAreUpToDate2_head, filesAreUpToDate2_body );

//

function filesAreOnSameDevice_head( routine, args )
{
  var o = args[ 0 ];

  _.assert( args.length === 1 || args.length === 2 );
  _.assert( arguments.length === 2 );

  if( args.length === 2 )
  {
    o = { src : args[ 0 ], dst : args[ 1 ] }
  }

  _.routine.options_( routine, o );

  _.assert( _.strDefined( o.src ) );
  _.assert( _.strDefined( o.dst ) );

  return o;
}

//

function filesAreOnSameDevice_body( o )
{
  let self = this;

  let src =
  {
    filePath : o.src,
    resolvingSoftLink : 1,
    throwing : 0
  }
  self.pathResolveLinkFull( src );

  let dst =
  {
    filePath : o.dst,
    resolvingSoftLink : 1,
    throwing : 0
  }
  self.pathResolveLinkFull( dst );

  if( !src.stat || !dst.stat )
  {
    let trace = self.path.traceToRoot( o.src );
    if( !trace.length )
    {
      _.assert( o.filePath === '/' );
      trace = [ o.filePath ];
    }
    else if( trace.length > 1 )
    trace.shift();

    let common = self.path.common( o.dst, trace[ 0 ] );
    return common === trace[ 0 ];
  }

  return src.stat.dev === dst.stat.dev;
}

filesAreOnSameDevice_body.defaults =
{
  src : null,
  dst : null
}

var having = filesAreOnSameDevice_body.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.driving = 0;

var filesAreOnSameDevice = _.routine.uniteCloning_replaceByUnite( filesAreOnSameDevice_head, filesAreOnSameDevice_body );

//

/**
 * @summary Calculates date resolution time in milliseconds for current file system.
 * @function systemBitrateTimeGet
 * @class wFileProviderSecondaryMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function systemBitrateTimeGet()
{
  let self = this;

  let result = 10;

  if( _.FileProvider.HardDrive && self instanceof _.FileProvider.HardDrive )
  {
    let testDir = self.path.tempOpen({ filePath : self.path.join( __dirname, '../../..'  ), name : 'SecondaryMixin' });
    let tempFile = self.path.join( testDir, 'systemBitrateTimeGet' );
    self.fileWrite( tempFile, tempFile );
    let ostat = self.statResolvedRead( tempFile );
    let mtime = new Date( ostat.mtime.getTime() );
    let ms = 500;
    mtime.setMilliseconds( ms );
    try
    {
      self.timeWrite( tempFile, ostat.atime, mtime );
      let stat = self.statResolvedRead( tempFile );
      let diff = mtime.getTime() - stat.mtime.getTime();
      if( diff )
      {
        debugger
        result  = ( diff / 1000 ).toFixed() * 1000;
        _.assert( !!result );
      }
    }
    catch( err )
    {
      throw _.err( err );
    }
    finally
    {
      self.path.tempClose( testDir );
    }
  }

  return result;
}

systemBitrateTimeGet.defaults =
{
}

var having = systemBitrateTimeGet.having = Object.create( null );

having.writing = 1;
having.reading = 0;
having.driving = 1;

// --
// top
// --

function filesSearchText( o )
{
  let self = this;
  let result = [];

  _.routine.options_( filesSearchText, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  o.ins = _.array.as( o.ins );
  o.ins = _.regexpsMaybeFrom
  ({
    srcStr : o.ins,
    stringWithRegexp : o.stringWithRegexp,
    toleratingSpaces : o.toleratingSpaces,
  });

  let o2 = _.mapOnly_( null, o, self.filesFind.defaults );

  o2.onUp = _.arrayAppendElement( o2.onUp, handleUp );

  let records = self.filesFind( o2 );

  return result;

  /* */

  function handleUp( record )
  {
    let read = record.factory.effectiveProvider.fileRead( record.absolute );

    let o2 = _.mapOnly_( null, o, _.strSearch.defaults );
    o2.src = read;
    o2.stringWithRegexp = 0;
    o2.toleratingSpaces = 0;

    let matches = _.strSearch( o2 );

    for( let m = 0 ; m < matches.length ; m++ )
    {
      let match = matches[ m ];
      match.file = record;
      result.push( match );
    }

    return false;
  }

}

_.routineExtend( filesSearchText, Find.prototype.filesFind );

var defaults = filesSearchText.defaults;

_.props.supplement( defaults, _.mapBut_( null, _.strSearch.defaults, { src : null } ) );

defaults.determiningLineNumber = 1;

// --
// read
// --

/**
 * @summary Read source code from provided file `o.filePath` and wraps it with self enclosed function of name `o.name`.
 * @param {Object} o Options map.
 * @param {String} o.filePath Source path.
 * @param {String} o.encoding='utf8' Encoding used in file reading.
 * @param {Boolean} o.wrapping=1 Adds custom `o.prefix` and `o.postfix` to source code.
 * @param {Boolean} o.routine=0 Creates routine from result string.
 * @param {String} o.name Name for self enclosed function.
 * @param {String} o.prefix Inserts this string before source code.
 * @param {String} o.postfix Inserts this string after source code.
 * @function fileCodeRead
 * @class wFileProviderSecondaryMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function fileCodeRead_body( o )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.sync, 'not implemented' );

  let o2 = _.mapOnly_( null, o, self.fileRead.defaults );
  let result = self.fileRead( o2 );

  if( o.name === null )
  o.name = _.strVarNameFor( self.path.fullName( o.filePath ) );

  if( o.wrapping )
  {

    if( _.TemplateTreeResolver )
    {
      let resolver = _.TemplateTreeResolver({ tree : o });
      o.prefix = resolver.resolve( o.prefix );
      o.postfix = resolver.resolve( o.postfix );
    }

    result = o.prefix + result + o.postfix;

  }

  if( o.routine )
  {
    result = _.routineMake({ code : result, name : o.name });
  }

  return result;
}

var defaults = fileCodeRead_body.defaults = _.props.extend( null, fileRead.defaults );

defaults.encoding = 'utf8';
defaults.wrapping = 1;
defaults.routine = 0;
defaults.name = null;
defaults.prefix = '// ======================================\n( function {{name}}() {\n';
defaults.postfix = '\n})();\n';

_.routineExtend( fileCodeRead_body, fileRead.body );

var fileCodeRead = _.routine.uniteCloning_replaceByUnite( fileRead.head, fileCodeRead_body );

fileCodeRead.having.aspect = 'entry';

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

  // files read

  // filesReadOld,
  // _filesReadOldAsync,
  // _filesReadOldSync,

  // etc

  // filesAreUpToDate,
  filesAreUpToDate2,
  filesAreOnSameDevice,

  filesSearchText,

  systemBitrateTimeGet,

  // read

  fileCodeRead,

  //

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

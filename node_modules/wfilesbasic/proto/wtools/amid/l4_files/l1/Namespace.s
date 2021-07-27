( function _Namespace_s_()
{

'use strict';

/**
 * @namespace Tools.files
 * @module Tools/mid/Files
 */

/**
 * @namespace wTools.files.FileProvider
 * @module Tools/mid/Files
 */

/**
 * @namespace wTools.files.FileFilter
 * @module Tools/mid/Files
 */

/**
 * @namespace wTools.files.ReadEncoders
 * @module Tools/mid/Files
 */

/**
 * @namespace wTools.files.WriteEncoders
 * @module Tools/mid/Files
 */

const _global = _global_;
const _ = _global_.wTools;
const Self = _.files = _.files || Object.create( null );
let Crypto;

_.FileProvider = _.files.FileProvider = _.FileProvider || _.files.FileProvider || Object.create( null );
_.FileFilter = _.files.FileFilter = _.FileFilter || _.files.FileFilter || Object.create( null );
_.files.ReadEncoders = _.files.ReadEncoders || Object.create( null );
_.files.WriteEncoders = _.files.WriteEncoders || Object.create( null );
_.files._ = _.files._ || Object.create( null );

_.assert( !!_.FieldsStack );
_.assert( !_.files.FileRecord );
_.assert( !_.files.FileRecordFactory );
_.assert( !_.files.FileRecordFilter );
_.assert( !_.files.FileStat );

// --
// meta
// --

let vectorize = _.routineDefaults( null, _.vectorize, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeAll = _.routineDefaults( null, _.vectorizeAll, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeAny = _.routineDefaults( null, _.vectorizeAny, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeNone =
_.routineDefaults( null, _.vectorizeNone, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );

//

function vectorizeKeysAndVals( routine, select )
{
  select = select || 1;

  let routineName = routine.name;

  _.assert( _.routineIs( routine ) );
  _.assert( _.strDefined( routineName ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  let routine2 = _.routineVectorize_functor
  ({
    routine : [ routineName ],
    vectorizingArray : 1,
    vectorizingMapVals : 1,
    vectorizingMapKeys : 1,
    select,
  });

  _.routineExtend( routine2, routine );

  return routine2;
}


// --
// implementation
// --

/**
 * @description Creates RegexpObject based on passed path, array of paths, or RegexpObject.
 * Paths turns into regexps and adds to 'includeAny' property of result Object.
 * Methods adds to 'excludeAny' property the next paths by default :
 * 'node_modules',
 * '.unique',
 * '.git',
 * '.svn',
 * /(^|\/)\.(?!$|\/|\.)/, // any hidden paths
 * /(^|\/)-(?!$|\/)/,
 * @example
 * let paths =
 *  {
 *    includeAny : [ 'foo/bar', 'foo2/bar2/baz', 'some.txt' ],
 *    includeAll : [ 'index.js' ],
 *    excludeAny : [ 'Gruntfile.js', 'gulpfile.js' ],
 *    excludeAll : [ 'package.json', 'bower.json' ]
 *  };
 * let regObj = regexpAllSafe( paths );
 *
 * @param {string|string[]|RegexpObject} [mask]
 * @returns {RegexpObject}
 * @throws {Error} if passed more than one argument.
 * @see {@link wTools~RegexpObject} RegexpObject
 * @function regexpAllSafe
 * @namespace wTools.files
 * @module Tools/mid/Files
 */

function regexpAllSafe( mask )
{

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let excludeMask = _.RegexpObject
  ({
    excludeAny :
    [
      // /(\W|^)node_modules(\W|$)/,
      // /\.unique(?:$|\/)/,
      // /\.git(?:$|\/)/,
      // /\.svn(?:$|\/)/,
      // /\.hg(?:$|\/)/,
      // /\.DS_Store(?:$|\/)/,
      // /\.tmp(?:$|\/)/,
      /\.(?:unique|git|svn|hg|DS_Store|tmp)(?:$|\/)/,
      /(^|\/)-/,
    ],
  });

  if( mask )
  {
    mask = _.RegexpObject( mask || Object.create( null ), 'includeAny' );
    excludeMask = excludeMask.and( mask );
  }

  return excludeMask;
}

//

function regexpTerminalSafe( mask )
{

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let excludeMask = _.RegexpObject
  ({
    excludeAny : [],
  });

  if( mask )
  {
    mask = _.RegexpObject( mask || Object.create( null ), 'includeAny' );
    excludeMask = excludeMask.and( mask );
  }

  return excludeMask;
}

//

function regexpDirSafe( mask )
{

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let excludeMask = _.RegexpObject
  ({
    excludeAny :
    [
      /(^|\/)\.(?!$|\/|\.)/,
      // /(^|\/)-/,
    ],
  });

  if( mask )
  {
    mask = _.RegexpObject( mask || Object.create( null ), 'includeAny' );
    excludeMask = excludeMask.and( mask );
  }

  return excludeMask;
}

//

function filterSafer( filter )
{
  _.assert( filter === null || _.mapIs( filter ) || filter instanceof _.files.FileRecordFilter );

  filter = filter || Object.create( null );

  filter.maskAll = _.files.regexpAllSafe( filter.maskAll );
  filter.maskTerminal = _.files.regexpTerminalSafe( filter.maskTerminal );
  filter.maskDirectory = _.files.regexpDirSafe( filter.maskDirectory );
  filter.maskTransientAll = _.files.regexpAllSafe( filter.maskTransientAll );
  // filter.maskTransientTerminal = _.files.regexpTerminalSafe( filter.maskTransientTerminal );
  filter.maskTransientDirectory = _.files.regexpDirSafe( filter.maskTransientDirectory );

  return filter;
}

// --
// etc
// --

/**
 * Return o for file red/write. If `filePath is an object, method returns it. Method validate result option
    properties by default parameters from invocation context.
 * @param {string|Object} filePath
 * @param {Object} [o] Object with default o parameters
 * @returns {Object} Result o
 * @private
 * @throws {Error} If arguments is missed
 * @throws {Error} If passed extra arguments
 * @throws {Error} If missed `PathFiile`
 * @function _fileOptionsGet
 * @namespace wTools.files
 * @module Tools/mid/Files
 */

function _fileOptionsGet( filePath, o ) /* xxx : check */
{
  o = o || Object.create( null );

  if( _.object.isBasic( filePath ) )
  {
    o = filePath;
  }
  else
  {
    o.filePath = filePath;
  }

  if( !o.filePath )
  throw _.err( 'Expects "o.filePath"' );

  _.map.assertHasOnly( o, this.defaults );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( o.sync === undefined )
  o.sync = 1;

  return o;
}

//

/**
 * Returns path/stats associated with file with newest modified time.
 * @example
 * let fs = require('fs');

   let path1 = 'tmp/sample/file1',
   path2 = 'tmp/sample/file2',
   buffer = BufferNode.from( [ 0x01, 0x02, 0x03, 0x04 ] );

   wTools.fileWrite( { filePath : path1, data : buffer } );
   setTimeout( function()
   {
     wTools.fileWrite( { filePath : path2, data : buffer } );


     let newer = wTools.filesNewer( path1, path2 );
     // 'tmp/sample/file2'
   }, 100);
 * @param {string|File.Stats} dst first file path/stat
 * @param {string|File.Stats} src second file path/stat
 * @returns {string|File.Stats}
 * @throws {Error} if type of one of arguments is not string/file.Stats
 * @function filesNewer
 * @namespace wTools.files
 * @module Tools/mid/Files
 */

function filesNewer( dst, src )
{
  let odst = dst;
  let osrc = src;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.fileStatIs( src ) )
  src = { stat : src };
  else if( _.strIs( src ) )
  src = { stat : _.fileProvider.statRead( src ) };
  else if( !_.object.isBasic( src ) )
  throw _.err( 'unknown src type' );

  if( _.fileStatIs( dst ) )
  dst = { stat : dst };
  else if( _.strIs( dst ) )
  dst = { stat : _.fileProvider.statRead( dst ) };
  else if( !_.object.isBasic( dst ) )
  throw _.err( 'unknown dst type' );


  let timeSrc = _.entityMax( [ src.stat.mtime/* , src.stat.birthtime */ ] ).value;
  let timeDst = _.entityMax( [ dst.stat.mtime/* , dst.stat.birthtime */ ] ).value;

  // When mtime of the file is changed by timeWrite( fs.utime ), there is difference between passed and setted value.
  // if( _.number.equivalent.call( { accuracy : 500 }, timeSrc.getTime(), timeDst.getTime() ) )
  // return null;

  if( timeSrc > timeDst )
  return osrc;
  else if( timeSrc < timeDst )
  return odst;

  return null;
}

//

/**
 * Returns path/stats associated with file with older modified time.
 * @example
 * let fs = require('fs');

 let path1 = 'tmp/sample/file1',
 path2 = 'tmp/sample/file2',
 buffer = BufferNode.from( [ 0x01, 0x02, 0x03, 0x04 ] );

 wTools.fileWrite( { filePath : path1, data : buffer } );
 setTimeout( function()
 {
   wTools.fileWrite( { filePath : path2, data : buffer } );

   let newer = wTools.filesOlder( path1, path2 );
   // 'tmp/sample/file1'
 }, 100);
 * @param {string|File.Stats} dst first file path/stat
 * @param {string|File.Stats} src second file path/stat
 * @returns {string|File.Stats}
 * @throws {Error} if type of one of arguments is not string/file.Stats
 * @function filesOlder
 * @namespace wTools.files
 * @module Tools/mid/Files
 */

function filesOlder( dst, src )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let result = filesNewer( dst, src );

  if( result === dst )
  return src;
  else if( result === src )
  return dst;
  else
  return null;

}

//

/**
 * Returns spectre of file content.
 * @example
 * let path = '/home/tmp/sample/file1',
 * textData1 = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
 *
 * wTools.fileWrite( { filePath : path, data : textData1 } );
 * let spectre = wTools.filesSpectre( path );
 * //{
 * //   L : 1,
 * //   o : 4,
 * //   r : 3,
 * //   e : 5,
 * //   m : 3,
 * //   ' ' : 7,
 * //   i : 6,
 * //   p : 2,
 * //   s : 4,
 * //   u : 2,
 * //   d : 2,
 * //   l : 2,
 * //   t : 5,
 * //   a : 2,
 * //   ',' : 1,
 * //   c : 3,
 * //   n : 2,
 * //   g : 1,
 * //   '.' : 1,
 * //   length : 56
 * // }
 * @param {string|wFileRecord} src absolute path or FileRecord instance
 * @returns {Object}
 * @throws {Error} If count of arguments are different from one.
 * @throws {Error} If `src` is not absolute path or FileRecord.
 * @function filesSpectre
 * @namespace wTools.files
 * @module Tools/mid/Files
*/

function filesSpectre( src ) /* xxx : redo or remove */
{

  _.assert( arguments.length === 1, 'filesSpectre :', 'expect single argument' );

  src = _.fileProvider.recordFactory().record( src );
  let read = src.read;

  if( !read )
  read = _.FileProvider.HardDrive().fileRead
  ({
    filePath : src.absolute,
    // silent : 1,
    // returnRead : 1,
  });

  return _.strLattersSpectre( read );
}

//

/**
 * Compares specters of two files. Returns the rational number between 0 and 1. For the same specters returns 1. If
 * specters do not have the same letters, method returns 0.
 * @example
 * let path1 = 'tmp/sample/file1',
 * path2 = 'tmp/sample/file2',
 * textData1 = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
 *
 * wTools.fileWrite( { filePath : path1, data : textData1 } );
 * wTools.fileWrite( { filePath : path2, data : textData1 } );
 * let similarity = wTools.filesSimilarity( path1, path2 ); // 1
 * @param {string} src1 path string 1
 * @param {string} src2 path string 2
 * @param {Object} [o]
 * @param {Function} [onReady]
 * @returns {number}
 * @function filesSimilarity
 * @namespace wTools.files
 * @module Tools/mid/Files
*/

function filesSimilarity( o )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( filesSimilarity, o );

  o.src1 = _.fileProvider.recordFactory().record( o.src1 );
  o.src2 = _.fileProvider.recordFactory().record( o.src2 );

  let latters1 = _.files.filesSpectre( o.src1.absolute );
  let latters2 = _.files.filesSpectre( o.src2.absolute );

  let result = _.strLattersSpectresSimilarity( latters1, latters2 );

  return result;
}

filesSimilarity.defaults =
{
  src1 : null,
  src2 : null,
}

//

function filesShadow( shadows, owners ) /* xxx : check */
{

  for( let s = 0 ; s < shadows.length ; s++ )
  {
    let shadow = shadows[ s ];
    shadow = _.object.isBasic( shadow ) ? shadow.relative : shadow;

    for( let o = 0 ; o < owners.length ; o++ )
    {

      let owner = owners[ o ];

      owner = _.object.isBasic( owner ) ? owner.relative : owner;

      if( _.strBegins( shadow, _.path.prefixGet( owner ) ) )
      {
        shadows.splice( s, 1 );
        s -= 1;
        break;
      }

    }

  }

}

//

function fileReport( file ) /* xxx : rename */
{
  let report = '';

  file = _.files.FileRecord( file );

  let fileTypes = {};

  if( file.stat )
  {
    fileTypes.isFile = file.stat.isFile();
    fileTypes.isDirectory = file.stat.isDirectory();
    fileTypes.isBlockDevice = file.stat.isBlockDevice();
    fileTypes.isCharacterDevice = file.stat.isCharacterDevice();
    fileTypes.isSymbolicLink = file.stat.isSymbolicLink();
    fileTypes.isFIFO = file.stat.isFIFO();
    fileTypes.isSocket = file.stat.isSocket();
  }

  report += _.entity.exportString( file, { levels : 2, wrap : 0 } );
  report += '\n';
  report += _.entity.exportString( file.stat, { levels : 2, wrap : 0 } );
  report += '\n';
  report += _.entity.exportString( fileTypes, { levels : 2, wrap : 0 } );

  return report;
}

//

function hashFrom( o )
{

  if( !_.mapIs( arguments[ 0 ] ) )
  o = { src : arguments[ 0 ] }
  _.routine.options_( hashFrom, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  return _.files.hashMd5From( o );
}

hashFrom.defaults =
{
  src : null,
}

//

function hashSzFrom( o )
{

  if( !_.mapIs( arguments[ 0 ] ) )
  o = { src : arguments[ 0 ] }
  _.routine.options_( hashSzFrom, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !_.streamIs( o.src ), 'not implemented' ); /* qqq : implement */

  let result = _.files.hashMd5From( o );

  if( !result )
  return result;

  let size = _.entity.sizeOf( o.src, 0 );
  _.assert( _.numberIs( size ) );
  result = size + '-' + result;

  return result;
}

hashSzFrom.defaults =
{
  ... hashFrom.defaults,
}

//

function hashMd5From( o )
{

  if( !_.mapIs( arguments[ 0 ] ) )
  o = { src : arguments[ 0 ] }
  _.routine.options_( hashMd5From, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( Crypto === undefined )
  Crypto = require( 'crypto' );
  let md5sum = Crypto.createHash( 'md5' );

  /* */

  if( _.streamIs( o.src ) )
  {
    let con = new _.Consequence();
    let done = false;

    o.src.on( 'data', function( d )
    {
      md5sum.update( d );
    });

    o.src.on( 'end', function()
    {
      if( done )
      return;
      done = true;
      let hash = md5sum.digest( 'hex' );
      con.take( hash );
    });

    o.src.on( 'error', function( err )
    {
      if( done )
      return;
      done = true;
      con.error( _.err( err ) );
    });

    return con;
  }
  else
  {
    let result;
    try
    {
      o.src = _.bufferNodeFrom( o.src );
      md5sum.update( o.src );
      result = md5sum.digest( 'hex' );
    }
    catch( err )
    {
      _.errAttend( err );
      throw err;
    }
    return result;
  }

  /* */

}

hashMd5From.defaults =
{
  ... hashFrom.defaults,
}

//

function nodeJsIsSameOrNewer( src ) /* xxx : rename */
{
  _.assert( arguments.length === 1 );
  _.assert( _.longIs( src ) );
  _.assert( src.length === 3 );
  _.assert( !!_global.process );

  let parsed = /^v(\d+).(\d+).(\d+)/.exec( _global.process.version );
  for( let i = 1; i < 4; i++ )
  {
    if( parsed[ i ] < src[ i - 1 ] )
    return false;

    if( parsed[ i ] > src[ i - 1 ] )
    return true;
  }

  return true;
}

// --
// declaration
// --

let Restricts =
{

  vectorize,
  vectorizeAll,
  vectorizeAny,
  vectorizeNone,

  vectorizeKeysAndVals, /* zzz : required? */

}

_.props.supplement( _.files._, Restricts );

//

let FilesExtension =
{

  // regexp

  regexpMakeSafe : regexpAllSafe,
  regexpAllSafe,
  regexpTerminalSafe,
  regexpDirSafe,
  filterSafer,

  // etc

  _fileOptionsGet,

  filesNewer,
  filesOlder,

  filesSpectre,
  filesSimilarity,

  filesShadow,

  fileReport,

  nodeJsIsSameOrNewer,

  hashFrom, /* qqq : cover */
  hashMd5From, /* qqq : cover */
  hashSzFrom, /* qqq : cover */

  // fields


}

_.props.supplement( _.files, FilesExtension );

})();

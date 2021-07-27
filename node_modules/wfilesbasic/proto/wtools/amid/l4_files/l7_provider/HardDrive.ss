( function _HardDrive_ss_()
{

'use strict';

let File, StandardFile, Os, LockFile;

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  File = require( 'fs' );
  StandardFile = require( 'fs' ); /* xxx : remove */
  Os = require( 'os' );
  LockFile = require( 'proper-lockfile' )

}

//

/**
 @classdesc Class to perform file operations on local drive.
 @class wFileProviderHardDrive
 @namespace wTools.FileProvider
 @module Tools/mid/Files
*/

const _global = _global_;
const _ = _global_.wTools;
const FileRecord = _.files.FileRecord;
const Parent = _.FileProvider.Partial;
const Self = wFileProviderHardDrive;
function wFileProviderHardDrive( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'HardDrive';

// --
// inter
// --

function init( o )
{
  let self = this;
  Parent.prototype.init.call( self, o );
}

// --
// path
// --

let pathNativizeAct = process.platform === 'win32' ? ( src ) => _.path._nativizeWindows( src ) : ( src ) => _.path._nativizePosix( src );

_.assert( _.routineIs( pathNativizeAct ) );

//

function pathCurrentAct()
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( arguments.length === 1 && arguments[ 0 ] )
  {
    let path = self.path.nativize( arguments[ 0 ] );
    process.chdir( path );
  }

  let result = process.cwd();

  return result;
}

//

function _pathHasDriveLetter( filePath )
{
  _.assert( _.strIs( filePath ), 'Expects nativized path.' );

  if( process.platform === 'win32' )
  return /^[a-zA-Z]:\\/.test( filePath );
  return true;
}

//

function _isTextLink( filePath )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !self.usingTextLink )
  return false;

  // let result = self._pathResolveTextLink({ filePath : filePath, allowingMissed : true });

  let stat = self.statReadAct
  ({
    filePath,
    throwing : 0,
    sync : 1,
    resolvingSoftLink : 0,
  });

  if( stat && stat.isTerminal() )
  {
    let read = self.fileReadAct
    ({
      filePath,
      sync : 1,
      encoding : 'utf8',
      advanced : null,
      resolvingSoftLink : 0
    })
    let regexp = /^link ([^\n]+)\n?$/;
    return regexp.test( read );
  }

  // return !!result.resolved;
  return false;
}

var having = _isTextLink.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.driving = 0;

var operates = _isTextLink.operates = Object.create( null );

operates.filePath = { pathToRead : 1 }

//

let buffer;
// function pathResolveTextLinkAct( filePath, visited, hasLink, allowingMissed )
// function pathResolveTextLinkAct( o )
// {
//   let self = this;

//   _.routine.assertOptions( pathResolveTextLinkAct, arguments );
//   _.assert( arguments.length === 1 );
//   _.assert( _.arrayIs( o.visited ) );

//   if( !buffer )
//   buffer = BufferNode.alloc( 512 );

//   if( o.visited.indexOf( o.filePath ) !== -1 )
//   throw _.err( 'Cyclic text link :', o.filePath );
//   o.visited.push( o.filePath );

//   o.filePath = self.path.normalize( o.filePath );
//   let exists = _.fileProvider.fileExists({ filePath : o.filePath /*, resolvingTextLink : 0*/ });

//   let prefix, parts;
//   if( o.filePath[ 0 ] === '/' )
//   {
//     prefix = '/';
//     parts = o.filePath.substr( 1 ).split( '/' );
//   }
//   else
//   {
//     prefix = '';
//     parts = o.filePath.split( '/' );
//   }

//   for( var p = exists ? p = parts.length-1 : 0 ; p < parts.length ; p++ )
//   {

//     let cpath = _.fileProvider.path.nativize( prefix + parts.slice( 0, p+1 ).join( '/' ) );

//     let stat = _.fileProvider.statResolvedRead({ filePath : cpath, resolvingTextLink : 0, resolvingSoftLink : 0 });
//     if( !stat )
//     {
//       if( o.allowingMissed )
//       return o.filePath;
//       else
//       return false;
//     }

//     if( stat.isTerminal() )
//     {

//       let regexp = /^link ([^\n]+)\n?$/;
//       let size = Number( stat.size );
//       let readSize = _.bigIntIs( size ) ? BigInt( 256 ) : 256;
//       let f = File.openSync( cpath, 'r' );
//       let m;
//       do
//       {

//         readSize *= _.bigIntIs( size ) ? BigInt( 2 ) : 2;
//         readSize = readSize < size ? readSize : size;
//         if( buffer.length < readSize )
//         buffer = BufferNode.alloc( readSize );
//         File.readSync( f, buffer, 0, readSize, 0 );
//         let read = buffer.toString( 'utf8', 0, readSize );
//         m = read.match( regexp );

//       }
//       while( m && readSize < size );
//       File.closeSync( f );

//       if( m )
//       o.hasLink = true;

//       if( !m )
//       if( p !== parts.length-1 )
//       return false;
//       else
//       return o.hasLink ? o.filePath : false;

//       /* */

//       let o2 = _.props.extend( null, o );
//       o2.filePath = self.path.join( m[ 1 ], parts.slice( p+1 ).join( '/' ) );

//       if( o2.filePath[ 0 ] === '.' )
//       o2.filePath = self.path.reroot( cpath , '..' , o2.filePath );

//       let result = self.pathResolveTextLinkAct( o2 );
//       if( o2.hasLink )
//       {
//         if( !result )
//         {
//           throw _.err
//           (
//             'Cant resolve : ' + o.visited[ 0 ] +
//             '\nnot found : ' + ( m ? m[ 1 ] : o.filePath ) +
//             '\nlooked at :\n' + ( o.visited.join( '\n' ) )
//           );
//         }
//         else
//         return result;
//       }
//       else
//       {
//         throw _.err( 'not expected' );
//         return result;
//       }
//     }

//   }

//   return o.hasLink ? o.filePath : false;
// }

// pathResolveTextLinkAct.defaults =
// {
//   filePath : null,
//   visited : null,
//   hasLink : null,
//   allowingMissed : true,
// }

function pathResolveTextLinkAct( o )
{
  let self = this;

  _.routine.assertOptions( pathResolveTextLinkAct, arguments );
  _.assert( arguments.length === 1 );

  let result;

  if( !buffer )
  buffer = BufferNode.alloc( 512 );

  if( o.resolvingIntermediateDirectories )
  return resolveIntermediateDirectories();

  let stat = self.statReadAct
  ({
    filePath : o.filePath,
    throwing : 0,
    sync : 1,
    resolvingSoftLink : 0,
  });

  if( !stat )
  return false;

  if( !stat.isTerminal() )
  return false;

  let filePath = self.path.nativize( o.filePath );
  let regexp = /^link ([^\n]+)\n?$/;
  let size = Number( stat.size );
  let readSize = _.bigIntIs( size ) ? BigInt( 256 ) : 256;
  let f = File.openSync( filePath, 'r' );
  readSize *= _.bigIntIs( size ) ? BigInt( 2 ) : 2;
  readSize = readSize < size ? readSize : size;
  if( buffer.length < readSize )
  buffer = BufferNode.alloc( readSize );
  File.readSync( f, buffer, 0, readSize, 0 );
  File.closeSync( f );
  let read = buffer.toString( 'utf8', 0, readSize );
  let m = read.match( regexp );

  if( !m )
  return false;

  result = m[ 1 ];

  if( o.resolvingMultiple )
  return multipleResolve();

  return result;

  /**/

  function resolveIntermediateDirectories()
  {
    let splits = self.path.split( o.filePath );
    let o2 = _.props.extend( null, o );

    o2.resolvingIntermediateDirectories = 0;
    o2.filePath = '/';

    for( let i = 1 ; i < splits.length ; i++ )
    {
      o2.filePath = self.path.join( o2.filePath, splits[ i ] );

      if( self.isTextLink( o2.filePath ) )
      {
        result = self.pathResolveTextLinkAct( o2 )
        o2.filePath = self.path.join( o2.filePath, result );
      }
    }
    return o2.filePath;
  }

  /**/

  function multipleResolve()
  {
    result = self.path.join( o.filePath, self.path.normalize( result ) );
    if( !self.isTextLink( result ) )
    return result;
    let o2 = _.props.extend( null, o );
    o2.filePath = result;
    return self.pathResolveTextLinkAct( o2 );
  }
}

_.routineExtend( pathResolveTextLinkAct, Parent.prototype.pathResolveTextLinkAct )


//

function pathResolveSoftLinkAct( o )
{
  let self = this;
  let path = self.system ? self.system.path : self.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( path.isAbsolute( o.filePath ) );

  let result;

  try
  {
    if( o.resolvingIntermediateDirectories )
    return resolveIntermediateDirectories();

    if( !self.isSoftLink( o.filePath ) )
    return o.filePath;

    /* qqq : optimize for resolvingMultiple:1 case */

    result = File.readlinkSync( self.path.nativize( o.filePath ) );

    /* qqq : why? add experiment please? */
    /* aaa : makes path relative to link instead of directory where link is located */
    if( !path.isAbsolute( path.normalize( result ) ) )
    {
      if( _.strBegins( result, '.\\' ) )
      result = _.strIsolateLeftOrNone( result, '.\\' )[ 2 ];
      result = '..\\' + result;
    }

    if( o.resolvingMultiple )
    return multipleResolve();

    return result;
  }
  catch( err )
  {
    throw _.err( 'Error resolving softLink', o.filePath, '\n', err );
  }

  /**/

  function resolveIntermediateDirectories()
  {
    if( o.resolvingMultiple )
    return File.realpathSync( self.path.nativize( o.filePath ) );

    let splits = path.split( o.filePath );
    let o2 = _.props.extend( null, o );

    o2.resolvingIntermediateDirectories = 0;
    o2.filePath = '/';

    for( let i = 1 ; i < splits.length ; i++ )
    {
      o2.filePath = path.join( o2.filePath, splits[ i ] );

      if( self.isSoftLink( o2.filePath ) )
      {
        result = self.pathResolveSoftLinkAct( o2 )
        o2.filePath = path.join( o2.filePath, result );
      }
    }
    return o2.filePath;
  }

  /**/

  function multipleResolve()
  {
    result = path.join( o.filePath, path.normalize( result ) );
    if( !self.isSoftLink( result ) )
    return result;
    let o2 = _.props.extend( null, o );
    o2.filePath = result;
    return self.pathResolveSoftLinkAct( o2 );
  }

}

_.routineExtend( pathResolveSoftLinkAct, Parent.prototype.pathResolveSoftLinkAct );

//

function pathDirTempAct()
{
  let self = this;
  let path = self.path;
  return path.normalize( Os.tmpdir() );
}

//

/**
 * Returns `home` directory. On depend from OS it's will be value of 'HOME' for posix systems or 'USERPROFILE'
 * for windows environment variables.
 * @returns {string}
 * @function pathDirUserHomeAct
 * @class wFileProviderHardDrive
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function pathDirUserHomeAct()
{
  _.assert( arguments.length === 0, 'Expects single argument' );
  let result = process.env[ ( process.platform === 'win32' ) ? 'USERPROFILE' : 'HOME' ] || __dirname;
  _.assert( _.strIs( result ) );
  result = _.path.normalize( result );
  return result;
}

//

function pathAllowedAct( filePath )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( self.path.isNormalized( filePath ), 'Expects normalized path.' );
  _.assert( self.path.isAbsolute( filePath ), 'Expects absolute path.' );

  filePath = self.path.unescape( filePath );

  if( process.platform === 'win32' )
  return !_.strHasAny( filePath, [ '<', '>', ':', '"', '\\', '|', '?', '*' ] );

  if( process.platform === 'darwin' )
  return !_.strHasAny( filePath, [ ':' ] );

  return true;
}


// --
// read
// --

function fileReadAct( o )
{
  let self = this;
  let con;
  let stack = null;
  let result = null;

  // _.routine.assertOptions( fileReadAct, arguments );
  _.map.assertHasAll( o, fileReadAct.defaults );
  _.assert( self.path.isNormalized( o.filePath ) );
  // _.assert( o.fileProvider === self );

  let filePath = self.path.nativize( o.filePath );

  // if( Config.debug )
  // if( !o.sync )
  // stack = _.introspector.stack([ 1, Infinity ]);

  o.fileProvider = self;
  o.encoder = fileReadAct.encoders[ o.encoding ];
  if( o.encoder && o.encoder.onSelect )
  o.encoder.onSelect.call( self, o );

  /* exec */

  handleBegin();

  if( !o.resolvingSoftLink && self.isSoftLink( o.filePath ) )
  {
    let err = _.err( 'fileReadAct: Reading from soft link is not allowed when "resolvingSoftLink" is disabled' );
    return handleError( err );
  }

  if( o.sync )
  {
    try
    {
      result = File.readFileSync( filePath, { encoding : self._encodingFor( o.encoding ) } );
    }
    catch( err )
    {
      return handleError( err );
    }

    return handleEnd( result );
  }
  else
  {
    con = new _.Consequence();

    File.readFile( filePath, { encoding : self._encodingFor( o.encoding ) }, function( err, data )
    {
      if( err )
      return handleError( err );
      else
      return handleEnd( data );
    });

    return con;
  }

  /* begin */

  function handleBegin()
  {

    if( o.encoder && o.encoder.onBegin )
    o.encoder.onBegin.call( self, { operation : o, encoder : o.encoder })

  }

  /* end */

  function handleEnd( data )
  {

    if( o.encoder && o.encoder.onEnd )
    data = o.encoder.onEnd.call( self, { data, operation : o, encoder : o.encoder })

    if( o.sync )
    return data;
    else
    return con.take( data );

  }

  /* error */

  function handleError( err )
  {

    err = _._err
    ({
      args : [ '\nfileReadAct( ', o.filePath, ' )\n', err ],
      usingSourceCode : 0,
      level : 0,
      // stack : stack,
    });

    if( o.encoder && o.encoder.onError )
    try
    {
      err = o.encoder.onError.call( self, { error : err, operation : o, encoder : o.encoder })
    }
    catch( err2 )
    {
      console.error( err2.message );
      console.error( err2.stack );
      console.error( err.message );
      console.error( err.stack );
    }

    if( o.sync )
    throw err;
    else
    return con.error( err );

  }

}

_.routineExtend( fileReadAct, Parent.prototype.fileReadAct );

//

function streamReadAct( o )
{
  let self = this;
  let result;

  // _.assert( o.fileProvider === self );

  _.routine.assertOptions( streamReadAct, arguments );

  o.fileProvider = self;
  o.encoder = fileReadAct.encoders[ o.encoding ];
  if( o.encoder && o.encoder.onSelect)
  o.encoder.onSelect.call( self, o );

  let filePath = self.path.nativize( o.filePath );

  handleBegin();

  try
  {
    result = File.createReadStream( filePath, { encoding : self._encodingFor( o.encoding ) } );
  }
  catch( err )
  {
    throw _.err( err );
  }

  result.on( 'error', ( err ) => handleError( err ) );
  result.on( 'end', () => handleEnd() );

  return result;

  /* begin */

  function handleBegin()
  {

    if( o.encoder && o.encoder.onBegin )
    o.encoder.onBegin.call( self, { operation : o, encoder : o.encoder });

  }

  /* end */

  function handleEnd()
  {

    if( o.encoder && o.encoder.onEnd )
    o.encoder.onEnd.call( self, { stream : result, operation : o, encoder : o.encoder })

  }

  /* error */

  function handleError( err )
  {

    err = _._err
    ({
      args : [ '\nfileReadAct( ', o.filePath, ' )\n', err ],
      usingSourceCode : 0,
      level : 0,
      // stack : stack,
    });

    if( o.encoder && o.encoder.onError )
    try
    {
      err = o.encoder.onError.call( self, { error : err, operation : o, encoder : o.encoder });
    }
    catch( err2 )
    {
      console.error( err2.message );
      console.error( err2.stack );
      console.error( err.message );
      console.error( err.stack );
    }

  }

}

_.routineExtend( streamReadAct, Parent.prototype.streamReadAct );

//

function dirReadAct( o )
{
  let self = this;
  let result = null;

  _.routine.assertOptions( dirReadAct, arguments );

  let nativizedFilePath = self.path.nativize( o.filePath );

  /* read dir */

  if( o.sync )
  {
    try
    {
      let stat = self.statReadAct
      ({
        filePath : o.filePath,
        throwing : 1,
        sync : 1,
        resolvingSoftLink : 1,
      });
      if( stat.isDir() )
      {
        result = File.readdirSync( nativizedFilePath );
        return result
      }
      else
      {
        result = self.path.name({ path : o.filePath, full : 1 });
      }
    }
    catch( err )
    {
      throw _.err( err );
      result = null;
    }

    return result;
  }
  else
  {
    let con = new _.Consequence();

    self.statReadAct
    ({
      filePath : o.filePath,
      sync : 0,
      resolvingSoftLink : 1,
      throwing : 1,
    })
    .give( function( err, stat )
    {
      if( err )
      {
        con.error( _.err( err ) );
      }
      else if( stat.isDir() )
      {
        File.readdir( nativizedFilePath, function( err, files )
        {
          if( err )
          {
            con.error( _.err( err ) );
          }
          else
          {
            con.take( files || null );
          }
        });
      }
      else
      {
        result = self.path.name({ path : o.filePath, full : 1 });
        con.take( result );
      }
    });

    return con;
  }

}

_.routineExtend( dirReadAct, Parent.prototype.dirReadAct );

// --
// read stat
// --

/*
xxx : return maybe undefined if error, but exists?
*/

function statReadAct( o )
{
  let self = this;
  let result = null;

  _.assert( self.path.isAbsolute( o.filePath ), 'Expects absolute {-o.FilePath-}, but got', o.filePath );
  _.assert( self.path.isNormalized( o.filePath ), 'Expects normalized {-o.FilePath-}, but got', o.filePath );
  _.routine.assertOptions( statReadAct, arguments );

  let nativizedFilePath = self.path.nativize( o.filePath );
  let args = [ nativizedFilePath ];

  if( self.UsingBigIntForStat )
  args.push( { bigint : true } );

  /* */

  if( o.sync )
  {

    try
    {
      if( o.resolvingSoftLink )
      result = StandardFile.statSync.apply( StandardFile, args );
      else
      result = StandardFile.lstatSync.apply( StandardFile, args );
    }
    catch( err )
    {
      if( o.throwing )
      throw _.err( 'Error getting stat of', o.filePath, '\n', err );
    }

    if( result )
    handleEnd( result );

    return result;
  }

  /* */

  let con = new _.Consequence();

  args.push( handleAsyncEnd );

  if( o.resolvingSoftLink )
  StandardFile.stat.apply( StandardFile, args );
  else
  StandardFile.lstat.apply( StandardFile, args );

  return con;

  /* */

  function handleAsyncEnd( err, stat )
  {
    if( err )
    {
      if( o.throwing )
      con.error( _.err( err ) );
      else
      con.take( null );
    }
    else
    {
      handleEnd( stat );
      con.take( stat );
    }
  }

  /* */

  function isTerminal()
  {
    return this.isFile();
  }

  /* */

  function isDir()
  {
    return this.isDirectory();
  }

  /* */

  let _isTextLink;
  function isTextLink()
  {
    if( this._isTextLink !== undefined )
    return this._isTextLink;
    this._isTextLink = self._isTextLink( o.filePath );
    return this._isTextLink;
  }

  /* */

  function isSoftLink()
  {
    return this.isSymbolicLink();
  }

  /* */

  function isHardLink()
  {
    if( !this.isFile() )
    return false;
    return this.nlink >= 2;
  }

  /* */

  function handleEnd( stat )
  {
    let extend =
    {
      filePath : o.filePath,
      isTerminal,
      isDir,
      isTextLink,
      isSoftLink,
      isHardLink,
      isLink : _.files.FileStat.prototype.isLink,
    }
    _.props.extend( stat, extend );
    return stat;
  }

}

_.assert( _.routineIs( _.files.FileStat.prototype.isLink ) );
_.routineExtend( statReadAct, Parent.prototype.statReadAct );

//

function fileExistsAct( o )
{
  let self = this;
  let nativizedFilePath = self.path.nativize( o.filePath );
  try
  {
    File.accessSync( nativizedFilePath, File.constants.F_OK );
  }
  catch( err )
  {
    if( err.code === 'ENOENT' )
    { /*
        Used to check if symlink is present on Unix when referenced file doesn't exist.
        qqq : Check if same behavior can be obtained by using combination of File.constants in accessSync
        aaa : possible solution is to use faccessat, it accepts flag that disables resolving of the soft links.
        But we need to implement own c++ addon for faccessat. https://linux.die.net/man/2/faccessat.
      */
      if( process.platform !== 'win32' )
      return !!self.statReadAct({ filePath : o.filePath, sync : 1, throwing : 0, resolvingSoftLink : 0 });
      return false;
    }
    if( err.code === 'ENOTDIR' )
    return false;
  }
  _.assert( arguments.length === 1 );
  return true;
}

_.routineExtend( fileExistsAct, Parent.prototype.fileExistsAct );

// --
// write
// --

/**
 * Writes data to a file. `data` can be a string or a buffer. Creating the file if it does not exist yet.
 * Returns wConsequence instance.
 * By default method writes data synchronously, with replacing file if exists, and if parent dir hierarchy doesn't
   exist, it's created. Method can accept two parameters : string `filePath` and string\buffer `data`, or single
   argument : options map, with required 'filePath' and 'data' parameters.
 * @example
 *
    let data = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      options =
      {
        filePath : 'tmp/sample.txt',
        data : data,
        sync : false,
      };
    let con = wTools.fileWrite( options );
    con.give( function()
    {
        console.log('write finished');
    });
 * @param {Object} options write options
 * @param {string} options.filePath path to file is written.
 * @param {string|BufferNode} [options.data=''] data to write
 * @param {boolean} [options.append=false] if this options sets to true, method appends passed data to existing data
    in a file
 * @param {boolean} [options.sync=true] if this parameter sets to false, method writes file asynchronously.
 * @param {boolean} [options.force=true] if it's set to false, method throws exception if parents dir in `filePath`
    path is not exists
 * @param {boolean} [options.silentError=false] if it's set to true, method will catch error, that occurs during
    file writes.
 * @param {boolean} [options.verbosity=false] if sets to true, method logs write process.
 * @param {boolean} [options.clean=false] if sets to true, method removes file if exists before writing
 * @returns {wConsequence}
 * @throws {Error} If arguments are missed
 * @throws {Error} If passed more then 2 arguments.
 * @throws {Error} If `filePath` argument or options.PathFile is not string.
 * @throws {Error} If `data` argument or options.data is not string or BufferNode,
 * @throws {Error} If options has unexpected property.
 * @function fileWriteAct
 * @class wFileProviderHardDrive
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function fileWriteAct( o )
{
  let self = this;

  _.routine.assertOptions( fileWriteAct, arguments );
  _.assert( self.path.isNormalized( o.filePath ) );
  _.assert( self.WriteMode.indexOf( o.writeMode ) !== -1 );
  // _.assert( o.fileProvider === self );

  o.fileProvider = self;
  o.encoder = fileWriteAct.encoders[ o.encoding ];
  if( o.encoder && o.encoder.onSelect)
  o.encoder.onSelect.call( self, o );

  if( o.encoder && o.encoder.onBegin )
  _.sure( o.encoder.onBegin.call( self, { operation : o, encoder : o.encoder, data : o.data } ) === undefined );

  /* data conversion */

  if( _.bufferTypedIs( o.data ) && !_.bufferBytesIs( o.data ) || _.bufferRawIs( o.data ) )
  o.data = _.bufferNodeFrom( o.data );

  _.assert
  (
    _.strIs( o.data ) || _.bufferNodeIs( o.data ) || _.bufferBytesIs( o.data ),
    'Expects string or node buffer, but got', _.entity.strType( o.data )
  );

  let nativizedFilePath = self.path.nativize( o.filePath );

  _.assert
  (
    self._pathHasDriveLetter( nativizedFilePath ),
    `Expects path that begins with drive letter, but got:"${o.filePath}"`
  );

  /* write */

  if( o.sync )
  {

    if( o.writeMode === 'rewrite' )
    {
      File.writeFileSync( nativizedFilePath, o.data, { encoding : self._encodingFor( o.encoding ) } );
    }
    else if( o.writeMode === 'append' )
    {
      File.appendFileSync( nativizedFilePath, o.data, { encoding : self._encodingFor( o.encoding ) } );
    }
    else if( o.writeMode === 'prepend' )
    {
      if( self.fileExistsAct({ filePath : o.filePath, sync : 1 }) )
      {
        let data = File.readFileSync( nativizedFilePath, { encoding : undefined } );
        o.data = _.bufferJoin( _.bufferNodeFrom( o.data ), data );
      }
      File.writeFileSync( nativizedFilePath, o.data, { encoding : self._encodingFor( o.encoding ) } );
    }
    else
    {
      throw _.err( 'Not implemented write mode', o.writeMode );
    }
    return;

  }

  /* */

  let con = _.Consequence();

  if( o.writeMode === 'rewrite' )
  {
    File.writeFile( nativizedFilePath, o.data, { encoding : self._encodingFor( o.encoding ) }, handleEnd );
  }
  else if( o.writeMode === 'append' )
  {
    File.appendFile( nativizedFilePath, o.data, { encoding : self._encodingFor( o.encoding ) }, handleEnd );
  }
  else if( o.writeMode === 'prepend' )
  {
    if( self.fileExistsAct({ filePath : o.filePath, sync : 1 }) )
    File.readFile( nativizedFilePath, { encoding : undefined }, function( err, data )
    {
      if( err )
      return handleEnd( err );
      o.data = _.bufferJoin( _.bufferNodeFrom( o.data ), data );
      File.writeFile( nativizedFilePath, o.data, { encoding : self._encodingFor( o.encoding ) }, handleEnd );
    });
    else
    {
      File.writeFile( nativizedFilePath, o.data, { encoding : self._encodingFor( o.encoding ) }, handleEnd );
    }
  }
  else
  {
    handleEnd( _.err( 'Not implemented write mode', o.writeMode ) );
  }

  return con;

  /* */

  function handleEnd( err )
  {
    if( err )
    return con.error(  _.err( err ) );
    return con.take( o );
  }

}

_.routineExtend( fileWriteAct, Parent.prototype.fileWriteAct );

//

function streamWriteAct( o )
{
  let self = this;

  _.routine.assertOptions( streamWriteAct, arguments );

  let filePath = self.path.nativize( o.filePath );

  _.assert( self._pathHasDriveLetter( filePath ), `Expects path that begins with drive letter, but got:"${o.filePath}"` );

  try
  {
    return File.createWriteStream( filePath );
  }
  catch( err )
  {
    throw _.err( err );
  }
}

_.routineExtend( streamWriteAct, Parent.prototype.streamWriteAct );

//

function timeWriteAct( o )
{
  let self = this;

  _.routine.assertOptions( timeWriteAct, arguments );

  // File.utimesSync( o.filePath, o.atime, o.mtime );

  /*
    futimesSync atime/mtime precision:
    win32 up to seconds, throws error milliseconds
    unix up to nanoseconds, but stat.mtime works properly up to milliseconds otherwise returns "Invalid Date"
  */

  let nativizedFilePath = self.path.nativize( o.filePath );

  _.assert
  (
    self._pathHasDriveLetter( nativizedFilePath ),
    `Expects path that begins with drive letter, but got:"${o.filePath}"`
  );

  let flags = process.platform === 'win32' ? 'r+' : 'r';
  let descriptor = File.openSync( nativizedFilePath, flags );
  try
  {
    File.futimesSync( descriptor, o.atime, o.mtime );
    File.closeSync( descriptor );
  }
  catch( err )
  {
    File.closeSync( descriptor );
    throw _.err( err );
  }
}

_.routineExtend( timeWriteAct, Parent.prototype.timeWriteAct );

//

function rightsWriteAct( o )
{
  let self = this;
  let nativizedFilePath = self.path.nativize( o.filePath );

  /*
    https://nodejs.org/api/fs.html#fs_file_modes
    Node caveats: on Windows only the write permission can be changed, and the distinction among the permissions of group, owner or others is not implemented.
  */

  _.routine.assertOptions( rightsWriteAct, o );

  if( o.addRights !== null || o.delRights !== null )
  {

    if( o.setRights === null )
    o.setRights = self.rightsRead({ filePath : o.filePath, sync : 1 });
    if( o.addRights !== null )
    o.setRights = Number( o.setRights ) | Number( o.addRights );
    if( o.delRights !== null )
    o.setRights = Number( o.setRights ) & Number( ~o.delRights );

  }

  if( o.setRights !== null )
  {
    let d = File.openSync( nativizedFilePath, 'r' );
    File.fchmodSync( d, Number( o.setRights ) );
    File.closeSync( d );
    return true;
  }

  return false;
}

_.routineExtend( rightsWriteAct, Parent.prototype.rightsWriteAct );

//

/**
 * Delete file of directory. Accepts path string or options map. Returns wConsequence instance.
 * @example
 * let StandardFile = require( 'fs' );

  const fileProvider = _.FileProvider.Default();

   let path = 'tmp/fileSize/data',
   textData = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
   delOptions =
  {
     filePath : path,
     sync : 0
   };

   fileProvider.fileWrite( { filePath : path, data : textData } ); // create test file

   console.log( StandardFile.existsSync( path ) ); // true (file exists)
   let con = fileProvider.fileDelete( delOptions );

   con.give( function(err)
   {
     console.log( StandardFile.existsSync( path ) ); // false (file does not exist)
   } );

 * @param {string|Object} o - options map.
 * @param {string} o.filePath path to file/directory for deleting.
 * @param {boolean} [o.force=false] if sets to true, method remove file, or directory, even if directory has
    content. Else when directory to remove is not empty, wConsequence returned by method, will rejected with error.
 * @param {boolean} [o.sync=true] If set to false, method will remove file/directory asynchronously.
 * @returns {wConsequence}
 * @throws {Error} If missed argument, or pass more than 1.
 * @throws {Error} If filePath is not string.
 * @throws {Error} If options map has unexpected property.
 * @function fileDeleteAct
 * @class wFileProviderHardDrive
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function fileDeleteAct( o )
{
  let self = this;

  _.routine.assertOptions( fileDeleteAct, arguments );
  _.assert( self.path.isAbsolute( o.filePath ) );
  _.assert( self.path.isNormalized( o.filePath ) );

  // console.log( 'fileDeleteAct', o.filePath );

  let filePath = self.path.nativize( o.filePath );

  _.assert( self._pathHasDriveLetter( filePath ), `Expects path that begins with drive letter, but got:"${o.filePath}"` );

  if( o.sync )
  {
    let stat = self.statReadAct
    ({
      filePath : o.filePath,
      resolvingSoftLink : 0,
      sync : 1,
      throwing : 0,
    });

    if( stat && stat.isDir() )
    File.rmdirSync( filePath );
    else if( stat && process.platform === 'win32' )
    {
      /*
        The problem is that on windows, when you unlink a file that is opened, it doesn't really get deleted.
        It is just marked for deletion, but the directory entry is still there until the file is closed

        rename + unlink combination fixes the problem:

        rename moves file to temp directory, unlink marks file fo delete, it is not longer located in the original directory
        and will be deleted when original file is closed.

        Limitation : rename fails if temp directory is located on other device
      */
      let tempPath = tempPathGet();
      try
      {
        File.renameSync( filePath, tempPath );
      }
      catch( err )
      {
        _.errLogOnce( err );
        return File.unlinkSync( filePath );
      }

      // File.unlink( tempPath, ( err ) => /* Dmytro : we should use sync methods in sync branch */
      File.unlinkSync( tempPath, ( err ) =>
      {
        if( err )
        throw err;
      });

    }
    else
    File.unlinkSync( filePath );

    return;
  }

  /* */

  let con = self.statReadAct
  ({
    filePath : o.filePath,
    resolvingSoftLink : 0,
    sync : 0,
    throwing : 0,
  });
  con.give( ( err, stat ) =>
  {
    if( err )
    return con.error( err );

    if( stat && stat.isDir() )
    File.rmdir( filePath, handleResult );
    else if( process.platform === 'win32' )
    {
      let tempPath = tempPathGet();
      File.rename( filePath, tempPath, ( err ) =>
      {
        if( err )
        _.errLogOnce( err );
        else
        filePath = tempPath;

        File.unlink( filePath, handleResult );
      });
    }
    else
    File.unlink( filePath, handleResult );
  })

  return con;

  /* */

  function tempPathGet()
  {
    let tempPath = _.strRemoveEnd( self.path.normalize( o.filePath ), '/' ); /* Dmytro : maybe, normalizing is overhead */
    tempPath = self.path.nativize( o.filePath );
    let fileName = self.path.name({ path : tempPath, full : 1 });
    let tempName = fileName + '-' + _.idWithGuid() + '.tmp';
    return tempPath + tempName;
    // let fileName = self.path.name({ path : o.filePath, full : 1 });
    // let tempName = fileName + '-' + _.idWithGuid() + '.tmp';
    // // let tempDirPath = self.path.tempOpen( o.filePath ); /* Dmytro : opening and closing ( missed ) of temp path is overhead for simple renaming, we can modify path to get unique name */
    // // let tempPath = self.path.join( tempDirPath, tempName );
    // let tempPath = _.strRemoveEnd( self.path.normalize( o.filePath ), '/' ); /* Dmytro : maybe, normalizing is overhead */
    // tempPath = self.path.nativize( tempPath+tempName );
    // return tempPath;
  }

  /* */

  function handleResult( err )
  {
    if( err )
    con.error( err );
    else
    con.take( true );
  }

}

_.routineExtend( fileDeleteAct, Parent.prototype.fileDeleteAct );

//

function dirMakeAct( o )
{
  let self = this;
  let nativizedFilePath = self.path.nativize( o.filePath );

  _.routine.assertOptions( dirMakeAct, arguments );
  _.assert
  (
    self._pathHasDriveLetter( nativizedFilePath ),
    `Expects path that begins with drive letter, but got:"${o.filePath}"`
  );


  if( o.sync )
  {

    try
    {
      File.mkdirSync( nativizedFilePath );
    }
    catch( err )
    {
      throw _.err( err );
    }

  }
  else
  {
    let con = new _.Consequence();

    File.mkdir( nativizedFilePath, function( err )
    {
      if( err )
      con.error( err );
      else
      con.take( true );
    });

    return con;
  }

}

_.routineExtend( dirMakeAct, Parent.prototype.dirMakeAct );

//

let lockFileCounterMap = Object.create( null );

function fileLockAct( o )
{
  let self = this;
  let nativizedFilePath = self.path.nativize( o.filePath );

  _.assert( !o.locking, 'not implemented' );
  _.assert( !o.sharing || o.sharing === 'process', 'not implemented' );
  _.assert( self.path.isNormalized( o.filePath ) );
  _.assert( !o.waiting || o.timeOut >= 1000 );
  _.routine.assertOptions( fileLockAct, arguments );
  _.assert
  (
    self._pathHasDriveLetter( nativizedFilePath ),
    `Expects path that begins with drive letter, but got:"${o.filePath}"`
  );

  let con = _.Consequence.Try( () =>
  {
    if( !self.fileExistsAct({ filePath : o.filePath }) )
    throw _.err( 'File:', o.filePath, 'doesn\'t exist.' );

    if( lockFileCounterMap[ o.filePath ] )
    if( self.fileExistsAct({ filePath : o.filePath + '.lock' } ) )
    {
      if( !o.sharing )
      throw _.err( 'File', nativizedFilePath, 'is already locked by current process' );

      if( !o.waiting )
      {
        return true;
      }
      else if( o.sync )
      {
        throw _.err
        (
          'File', nativizedFilePath, 'is already locked by current process.',
          'With option {-o.waiting-} enabled, lock will be waiting for itself.',
          'Please use existing lock or execute method with {-o.sync-} set to 0.'
        )
      }
    }

    let lockOptions = Object.create( null );

    if( o.sync )
    {
      LockFile.lockSync( nativizedFilePath, lockOptions );
      return true;
    }
    else
    {
      if( o.waiting )
      lockOptions.retries =
      {
        retries : o.timeOut / 1000,
        minTimeout : 1000,
        maxRetryTime : o.timeOut
      }
      return _.Consequence.From( LockFile.lock( nativizedFilePath, lockOptions ) );
    }
  })

  con.then( ( got ) =>
  {
    if( lockFileCounterMap[ o.filePath ] === undefined )
    lockFileCounterMap[ o.filePath ] = 0;

    lockFileCounterMap[ o.filePath ] += 1;

    return true;
  })

  if( o.sync )
  return con.sync();

  return con;
}

_.routineExtend( fileLockAct, Parent.prototype.fileLockAct );

//

function fileUnlockAct( o )
{
  let self = this;
  let nativizedFilePath = self.path.nativize( o.filePath );

  _.assert( self.path.isNormalized( o.filePath ) );
  _.routine.assertOptions( fileUnlockAct, arguments );
  _.assert
  (
    self._pathHasDriveLetter( nativizedFilePath ),
    `Expects path that begins with drive letter, but got:"${o.filePath}"`
  );

  let con = _.Consequence.Try( () =>
  {
    if( !self.fileExistsAct({ filePath : o.filePath }) )
    throw _.err( 'File:', o.filePath, 'doesn\'t exist.' );

    if( lockFileCounterMap[ o.filePath ] !== undefined )
    {
      _.assert( lockFileCounterMap[ o.filePath ] > 0 );

      lockFileCounterMap[ o.filePath ] -= 1;

      if( lockFileCounterMap[ o.filePath ] > 0 )
      return true;
    }

    if( o.sync )
    {
      LockFile.unlockSync( nativizedFilePath );
      return true;
    }
    else
    {
      return _.Consequence.From( LockFile.unlock( nativizedFilePath ) );
    }

  })

  con.then( ( got ) =>
  {
    if( lockFileCounterMap[ o.filePath ] === 0 )
    {
      delete lockFileCounterMap[ o.filePath ];
    }

    return true;
  })

  if( o.sync )
  return con.sync();

  return con;
}

_.routineExtend( fileUnlockAct, Parent.prototype.fileUnlockAct );

//

function fileIsLockedAct( o )
{
  let self = this;
  let nativizedFilePath = self.path.nativize( o.filePath );

  _.routine.assertOptions( fileIsLockedAct, arguments );
  _.assert( self.path.isNormalized( o.filePath ) );

  let con = _.Consequence.Try( () =>
  {
    if( o.sync )
    {
      return LockFile.checkSync( nativizedFilePath );
    }
    else
    {
      return _.Consequence.From( LockFile.check( nativizedFilePath ) );
    }
  })

  if( o.sync )
  return con.sync();

  return con;
}

_.routineExtend( fileIsLockedAct, Parent.prototype.fileIsLockedAct );


//

function fileRenameAct( o )
{
  let self = this;

  _.routine.assertOptions( fileRenameAct, arguments );
  _.assert( self.path.isNormalized( o.srcPath ) );
  _.assert( self.path.isNormalized( o.dstPath ) );

  let dstPath = self.path.nativize( o.dstPath );
  let srcPath = self.path.nativize( o.srcPath );

  _.assert( self._pathHasDriveLetter( srcPath ), `Expects src path that begins with drive letter, but got:"${o.srcPath}"` );
  _.assert( self._pathHasDriveLetter( dstPath ), `Expects dst path that begins with drive letter, but got:"${o.dstPath}"` );

  _.assert( !!dstPath );
  _.assert( !!srcPath );

  if( o.sync )
  {
    File.renameSync( srcPath, dstPath );
  }
  else
  {
    let con = new _.Consequence();
    File.rename( srcPath, dstPath, function( err )
    {
      if( err )
      con.error( err );
      else
      con.take( true );
    });
    return con;
  }

}

_.routineExtend( fileRenameAct, Parent.prototype.fileRenameAct );
_.assert( fileRenameAct.defaults.originalDstPath === undefined );
_.assert( fileRenameAct.defaults.relativeDstPath !== undefined );

//

function fileCopyAct( o )
{
  let self = this;

  _.routine.assertOptions( fileCopyAct, arguments );
  _.assert( self.path.isNormalized( o.srcPath ) );
  _.assert( self.path.isNormalized( o.dstPath ) );

  if( self.isDir( o.srcPath ) )
  {
    let err = _.err( o.srcPath, ' is not a terminal file of link!' );
    if( o.sync )
    throw err;
    return new _.Consequence().error( err );
  }

  if( self.isSoftLink( o.srcPath ) ) /* qqq2 : should not be here. move to partial aaa: should be here becase Extract has more optiomal implementation of this case */
  {
    if( self.fileExistsAct({ filePath : o.dstPath }) )
    self.fileDeleteAct({ filePath : o.dstPath, sync : 1 })
    return self.softLinkAct
    ({
      srcPath : o.srcPath,
      dstPath : o.dstPath,

      relativeSrcPath : o.relativeSrcPath,
      relativeDstPath : o.relativeDstPath,

      sync : o.sync,
      type : null
    })
  }


  let dstPath = self.path.nativize( o.dstPath );
  let srcPath = self.path.nativize( o.srcPath );

  _.assert( self._pathHasDriveLetter( srcPath ), `Expects src path that begins with drive letter, but got:"${o.srcPath}"` );
  _.assert( self._pathHasDriveLetter( dstPath ), `Expects dst path that begins with drive letter, but got:"${o.dstPath}"` );

  _.assert( !!dstPath );
  _.assert( !!srcPath );

  /* */

  if( o.sync )
  {
    // File.copySync( o.srcPath, o.dstPath );
    File.copyFileSync( srcPath, dstPath );
  }
  else
  {
    let con = new _.Consequence().take( null );
    let readCon = new _.Consequence();
    let writeCon = new _.Consequence();

    con.andKeep( [ readCon, writeCon ] );

    con.ifNoErrorThen( ( got ) =>
    {
      let errs = got.filter( ( result ) => _.errIs( result ) );

      if( errs.length )
      throw _.err.apply( _, errs );

      return got;
    })

    let readStream = self.streamReadAct
    ({
      filePath : srcPath,
      encoding : self.encoding,
      onStreamBegin : null
    });

    readStream.on( 'error', ( err ) =>
    {
      readCon.take( _.err( err ) );
    })

    readStream.on( 'end', () =>
    {
      readCon.take( null );
    })

    let writeStream = self.streamWriteAct({ filePath : dstPath });

    writeStream.on( 'error', ( err ) =>
    {
      writeCon.take( _.err( err ) );
    })

    writeStream.on( 'finish', () =>
    {
      writeCon.take( null );
    })

    readStream.pipe( writeStream );

    return con;
  }

}

_.routineExtend( fileCopyAct, Parent.prototype.fileCopyAct );

//

// function softLinkAct( o )
// {
//   let self = this;
//   let srcIsAbsolute = self.path.isAbsolute( o.relativeSrcPath );
//   let srcPath = o.srcPath;
//
//   _.routine.assertOptions( softLinkAct, arguments );
//   _.assert( self.path.isAbsolute( o.dstPath ) );
//   _.assert( self.path.isNormalized( o.srcPath ) );
//   _.assert( self.path.isNormalized( o.dstPath ) );
//   _.assert( o.type === null || o.type === 'dir' ||  o.type === 'file' );
//
//   if( !srcIsAbsolute )
//   {
//     srcPath = o.relativeSrcPath;
//     if( _.strBegins( srcPath, './' ) )
//     srcPath = _.strIsolateLeftOrNone( srcPath, './' )[ 2 ];
//     if( _.strBegins( srcPath, '..' ) )
//     srcPath = '.' + _.strIsolateLeftOrNone( srcPath, '..' )[ 2 ];
//   }
//
//   if( process.platform === 'win32' )
//   {
//
//     if( o.type === null )
//     {
//       let srcPathResolved = srcPath;
//
//       /* not dir */
//       if( !srcIsAbsolute )
//       srcPathResolved = self.path.resolve( self.path.dir( o.dstPath ), srcPath );
//
//       let srcStat = self.statReadAct
//       ({
//         filePath : srcPathResolved,
//         resolvingSoftLink : 1,
//         sync : 1,
//         throwing : 0,
//       });
//
//       if( srcStat )
//       o.type = srcStat.isDirectory() ? 'dir' : 'file';
//
//     }
//
//   }
//
//   let dstNativePath = self.path.nativize( o.dstPath );
//   let srcNativePath = self.path.nativize( srcPath );
//
//   _.assert
//   (
//     !srcIsAbsolute || self._pathHasDriveLetter( srcNativePath ),
//     `Expects src path that begins with drive letter, but got:"${srcPath}"`
//   );
//   _.assert
//   (
//     self._pathHasDriveLetter( dstNativePath ),
//     `Expects dst path that begins with drive letter, but got:"${o.dstPath}"`
//   );
//
//   /* */
//
//   if( o.sync )
//   {
//
//     if( process.platform === 'win32' )
//     File.symlinkSync( srcNativePath, dstNativePath, o.type );
//     else
//     File.symlinkSync( srcNativePath, dstNativePath );
//
//     return;
//   }
//
//   let con = new _.Consequence();
//
//   if( process.platform === 'win32' )
//   File.symlink( srcNativePath, dstNativePath, o.type, onSymlink );
//   else
//   File.symlink( srcNativePath, dstNativePath, onSymlink );
//
//   return con;
//
//   /* */
//
//   function onSymlink( err )
//   {
//     if( err )
//     con.error( err );
//     else
//     con.take( true );
//   }
//
// }

function softLinkAct_functor()
{
  let con;
  const isWindows = process.platform === 'win32' ? 1 : 0;
  const nodejsSoftLinkingChanged = _.files.nodeJsIsSameOrNewer([ 15, 0, 0 ]) ? 1 : 0;

  const softLinkSyncRoutines =
  [
    softLinkSync,
    softLinkSyncWindows,
    softLinkSyncWindowsWithTry,
  ];

  const softLinkSyncRoutine = softLinkSyncRoutines[ isWindows + nodejsSoftLinkingChanged ];
  const softLinkAsyncRoutine = isWindows ? softLinkAsyncWindows : softLinkAsync;

  return softLinkAct;

  /* */

  function softLinkSync( srcNativePath, dstNativePath, type )
  {
    File.symlinkSync( srcNativePath, dstNativePath );
  }

  /* */

  function softLinkSyncWindows( srcNativePath, dstNativePath, type )
  {
    File.symlinkSync( srcNativePath, dstNativePath, type );
  }

  /* */

  function softLinkSyncWindowsWithTry( srcNativePath, dstNativePath, type )
  {
    /*
      Dmytro : try-catch imitate njs file system API of njs versions earlier than 15.
      The behavior of routine is similar to posix-like OS
    */
    try
    {
      File.symlinkSync( srcNativePath, dstNativePath, type );
    }
    catch( err )
    {
      if( err.code === 'ELOOP' )
      if( type === null ) /* Dmytro : can be changed only not defined type */
      {
        File.symlinkSync( srcNativePath, dstNativePath, 'dir' );
        return;
      }

      throw _.err( err );
    }
  }

  /* */

  function softLinkAsync( srcNativePath, dstNativePath, type )
  {
    con = new _.Consequence();
    File.symlink( srcNativePath, dstNativePath, onSymlink );
    return con;
  }

  /* */

  function softLinkAsyncWindows( srcNativePath, dstNativePath, type )
  {
    con = new _.Consequence();
    File.symlink( srcNativePath, dstNativePath, type, onSymlink );
    return con;
  }

  /* */

  function onSymlink( err )
  {
    if( err )
    con.error( err );
    else
    con.take( true );
  }

  /* */

  function softLinkAct( o )
  {
    let self = this;
    let srcIsAbsolute = self.path.isAbsolute( o.relativeSrcPath );
    let srcPath = o.srcPath;

    _.routine.assertOptions( softLinkAct, arguments );
    _.assert( self.path.isAbsolute( o.dstPath ) );
    _.assert( self.path.isNormalized( o.srcPath ) );
    _.assert( self.path.isNormalized( o.dstPath ) );
    _.assert( o.type === null || o.type === 'dir' ||  o.type === 'file' );

    if( !srcIsAbsolute )
    {
      srcPath = o.relativeSrcPath;
      if( _.strBegins( srcPath, './' ) )
      srcPath = _.strIsolateLeftOrNone( srcPath, './' )[ 2 ];
      if( _.strBegins( srcPath, '..' ) )
      srcPath = '.' + _.strIsolateLeftOrNone( srcPath, '..' )[ 2 ];
    }

    if( isWindows )
    {
      if( o.type === null )
      {
        let srcPathResolved = srcPath;

        /* not dir */
        if( !srcIsAbsolute )
        srcPathResolved = self.path.resolve( self.path.dir( o.dstPath ), srcPath );

        let srcStat = self.statReadAct
        ({
          filePath : srcPathResolved,
          resolvingSoftLink : 1,
          sync : 1,
          throwing : 0,
        });

        if( srcStat )
        o.type = srcStat.isDirectory() ? 'dir' : 'file';
      }
    }

    let dstNativePath = self.path.nativize( o.dstPath );
    let srcNativePath = self.path.nativize( srcPath );

    _.assert
    (
      !srcIsAbsolute || self._pathHasDriveLetter( srcNativePath ),
      `Expects src path that begins with drive letter, but got:"${srcPath}"`
    );
    _.assert
    (
      self._pathHasDriveLetter( dstNativePath ),
      `Expects dst path that begins with drive letter, but got:"${o.dstPath}"`
    );

    /* */

    if( o.sync )
    return softLinkSyncRoutine( srcNativePath, dstNativePath, o.type );
    else
    return softLinkAsyncRoutine( srcNativePath, dstNativePath, o.type );
  }
}

const softLinkAct = softLinkAct_functor();
_.routineExtend( softLinkAct, Parent.prototype.softLinkAct );

//

/**
 * Creates new name (hard link) for existing file. If srcPath is not file or not exists method returns false.
    This method also can be invoked in next form : wTools.hardLinkAct( dstPath, srcPath ). If `o.dstPath` is already
    exists and creating link finish successfully, method rewrite it, otherwise the file is kept intact.
    In success method returns true, otherwise - false.
 * @example

 * const fileProvider = _.FileProvider.Default();
 * let path = 'tmp/hardLinkAct/data.txt',
   link = 'tmp/hardLinkAct/h_link_for_data.txt',
   textData = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
   textData1 = ' Aenean non feugiat mauris';

   fileProvider.fileWrite( { filePath : path, data : textData } );
   fileProvider.hardLinkAct( link, path );

   let content = fileProvider.fileReadSync(link); // Lorem ipsum dolor sit amet, consectetur adipiscing elit.
   console.log(content);
   fileProvider.fileWrite( { filePath : path, data : textData1, append : 1 } );

   fileProvider.fileDelete( path ); // delete original name

   content = fileProvider.fileReadSync( link );
   console.log( content );
   // Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean non feugiat mauris
   // but file is still exists)
 * @param {Object} o options parameter
 * @param {string} o.dstPath link path
 * @param {string} o.srcPath file path
 * @param {boolean} [o.verbosity=false] enable logging.
 * @returns {boolean}
 * @throws {Error} if missed one of arguments or pass more then 2 arguments.
 * @throws {Error} if one of arguments is not string.
 * @throws {Error} if file `o.dstPath` is not exist.
 * @function hardLinkAct
 * @class wFileProviderHardDrive
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function hardLinkAct( o )
{
  let self = this;

  _.routine.assertOptions( hardLinkAct, arguments );

  let dstPath = self.path.nativize( o.dstPath );
  let srcPath = self.path.nativize( o.srcPath );

  _.assert( self._pathHasDriveLetter( srcPath ), `Expects src path that begins with drive letter, but got:"${o.srcPath}"` );
  _.assert( self._pathHasDriveLetter( dstPath ), `Expects dst path that begins with drive letter, but got:"${o.dstPath}"` );

  _.assert( !!o.dstPath );
  _.assert( !!o.srcPath );

  /* */

  let con = _.Consequence().take( true );

  if( o.dstPath === o.srcPath )
  return o.sync ? true : con;

  con.then( checkSrc )

  if( o.context )
  {
    con.then( () => o.context.tempRenameMaybe() )
    con.then( handleHardlinkBreaking );
  }

  con.then( link );

  if( o.context )
  {
    con.then( tempDelete );
    con.finally( tempRenameRevert );
  }

  if( o.sync )
  return con.sync();

  return con;

  /* */

  function checkSrc()
  {
    var con = _.Consequence.Try( () =>
    {
      return self.statReadAct
      ({
        filePath : o.srcPath,
        throwing : 0,
        sync : o.sync,
        resolvingSoftLink : 0,
      });
    })

    con.then( function( stat )
    {
      if( !stat )
      throw _.err( '{o.srcPath} does not exist on hard drive:', o.srcPath );
      if( !stat.isTerminal() )
      throw _.err( '{o.srcPath} is not a terminal file:', o.srcPath );
      return null;
    });

    if( o.sync )
    return con.sync();

    return con;
  }

  /* */

  function handleHardlinkBreaking()
  {
    let c = o.context;

    if( c.options.breakingSrcHardLink )
    if( !self.fileExists( o.dstPath ) )
    {
      if( c.srcStat.isHardLink() )
      return self.hardLinkBreak({ filePath : o.srcPath, sync : o.sync });
    }
    else
    {
      if( !c.options.breakingDstHardLink )
      if( c.dstStat.isHardLink() )
      {
        let con = _.Consequence.Try( () =>
        {
          return self.fileReadAct
          ({
            filePath : o.srcPath,
            encoding : self.encoding,
            advanced : null,
            resolvingSoftLink : self.resolvingSoftLink,
            sync : o.sync
          })
        })
        .then( ( srcData ) =>
        {
          let r = self.fileWriteAct
          ({
            filePath : o.dstPath,
            data : srcData,
            encoding : 'meta.original',
            writeMode : 'rewrite',
            sync : o.sync,
            advanced : null,
          })
          return o.sync ? true : r;
        })
        .then( () =>
        {
          let r = self.fileDeleteAct
          ({
            filePath : o.srcPath,
            sync : o.sync
          })
          return o.sync ? true : r;
        })
        .then( () =>
        {
          let dstPathTemp = dstPath;
          dstPath = srcPath
          srcPath = dstPathTemp;
          return null;
        })

        if( o.sync )
        return con.sync();

        return con;
      }
    }
    return null;
  }

  /* */

  function link()
  {
    if( o.sync )
    {
      File.linkSync( srcPath, dstPath );
      return true;
    }

    let linkReady = new _.Consequence();
    File.link( srcPath, dstPath, function( err )
    {
      if( err )
      return linkReady.error( err )
      linkReady.take( true )
    });
    return linkReady;
  }

  /* */

  function tempDelete( got )
  {
    let r = _.Consequence.Try( () =>
    {
      let result = o.context.tempDelete();
      return o.sync ? true : result;
    })
    r.then( () => got );

    if( o.sync )
    return r.sync();

    return r;
  }

  /* */

  function tempRenameRevert( err, got )
  {
    if( !err )
    return got;

    _.errAttend( err );

    let r = _.Consequence.Try( () =>
    {
      let result = o.context.tempRenameRevert()
      return o.sync ? true : result;
    })
    .finally( () =>
    {
      throw _.err( err );
    })

    if( o.sync )
    return r.sync();

    return r;
  }

}

_.routineExtend( hardLinkAct, Parent.prototype.hardLinkAct );

//

function areHardLinkedAct( o )
{
  let self = this;

  _.routine.assertOptions( areHardLinkedAct, arguments );
  _.assert( o.filePath.length === 2, 'Expects exactly two arguments' );

  if( o.filePath[ 0 ] === o.filePath[ 1 ] )
  {
    if( self.UsingBigIntForStat )
    return true;
    return _.maybe;
  }

  let statFirst = self.statRead( o.filePath[ 0 ] );
  if( !statFirst )
  return false;

  let statSecond = self.statRead( o.filePath[ 1 ] );
  if( !statSecond )
  return false;

  /*
    should return _.maybe, not true if result is not precise
  */

  return _.files.stat.areHardLinked( statFirst, statSecond );
}

_.routineExtend( areHardLinkedAct, Parent.prototype.areHardLinkedAct );

// --
// etc
// --

function _encodingFor( encoding )
{
  let self = this;
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( encoding ) );

  if( encoding === 'buffer.node' || encoding === 'buffer.bytes' || encoding === 'buffer.raw' )
  result = undefined;
  else
  result = encoding;

  _.assert( self.KnownNativeEncodings.has( result ), () => `Unknown encoding: ${result}` );

  return result;
}

// --
// encoders
// --

var encoders = {};

encoders[ 'buffer.raw' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'buffer.raw' );
    e.operation.encoding = 'buffer.node';
  },

  onEnd : function( e )
  {
    if( e.stream )
    return;
    _.assert( _.bufferNodeIs( e.data ) || _.bufferTypedIs( e.data ) || _.bufferRawIs( e.data ) );
    let result = _.bufferRawFrom( e.data );
    _.assert( !_.bufferNodeIs( result ) );
    _.assert( _.bufferRawIs( result ) );
    return result;
  },

}

//

// yyy
// encoders[ 'js.node' ] =
// {
//
//   exts : [ 'js', 's', 'ss' ],
//
//   onBegin : function( e )
//   {
//     e.operation.encoding = 'utf8';
//   },
//
//   onEnd : function( e )
//   {
//     return require( _.fileProvider.path.nativize( e.operation.filePath ) );
//   },
// }

encoders[ 'buffer.bytes' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'buffer.bytes' );
  },

  onEnd : function( e )
  {
    if( !e.stream )
    return _.bufferBytesFrom( e.data );
  },

}

//

encoders[ 'meta.original' ] =
{

  onBegin : function( e )
  {
    _.assert( 0 );
  },

  onEnd : function( e )
  {
    _.assert( 0 );
  },

  onSelect : function( operation )
  {
    // let system = this.system || this;
    let system = this;
    _.assert( operation.encoding === 'meta.original' );
    if( this.fileReadAct.encoders[ system.encoding ] && system.encoding !== 'meta.original' )
    operation.encoding = system.encoding;
    else if( this.ExtraNativeEncodings.has( system.encoding ) )
    operation.encoding = system.encoding;
    else
    operation.encoding = 'buffer.bytes';
    operation.encoder = this.fileReadAct.encoders[ operation.encoding ];
  },

}

fileReadAct.encoders = encoders;

//

var encoders = Object.create( null );

encoders[ 'meta.original' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'meta.original' );

    if( _.strIs( e.data ) )
    e.operation.encoding = 'utf8';
    else if( _.bufferBytesIs( e.data ) )
    e.operation.encoding = 'buffer.bytes';
    else if( _.bufferRawIs( e.data ) )
    e.operation.encoding = 'buffer.raw';
    else
    e.operation.encoding = 'buffer.node';

  }

}

fileWriteAct.encoders = encoders;

// --
// relations
// --

let KnownNativeEncodings = new Set([ undefined, 'ascii', 'base64', 'binary', 'hex', 'ucs2', 'ucs-2', 'utf16le', 'utf-16le', 'utf8', 'latin1' ]);
let ExtraNativeEncodings = new Set([ ... KnownNativeEncodings, 'buffer.node', 'buffer.bytes' ]);
let UsingBigIntForStat = _.files.nodeJsIsSameOrNewer( [ 10, 5, 0 ] ); /* xxx : remove */

let Composes =
{
  protocols : _.define.own([ 'hd', 'file' ]),
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

  pathNativizeAct,
  KnownNativeEncodings,
  ExtraNativeEncodings,
  UsingBigIntForStat,
  Path : _.path.CloneExtending({ fileProvider : Self }),

  SupportsIno : 1,
  SupportsRights : 1,

}

// --
// declare
// --

let Extension =
{

  // inter

  init,

  // path

  pathNativizeAct,
  pathCurrentAct,
  _pathHasDriveLetter,

  _isTextLink,
  pathResolveTextLinkAct,
  pathResolveSoftLinkAct,

  pathDirTempAct,
  pathDirUserHomeAct,
  pathAllowedAct,

  // read

  fileReadAct,
  streamReadAct,
  dirReadAct,
  statReadAct,
  fileExistsAct,

  // write

  fileWriteAct,
  streamWriteAct,
  timeWriteAct,
  rightsWriteAct,
  fileDeleteAct,
  dirMakeAct,

  // locking

  fileLockAct,
  fileUnlockAct,
  fileIsLockedAct,

  // linkingAction

  fileRenameAct,
  fileCopyAct,
  softLinkAct,
  hardLinkAct,

  // link

  areHardLinkedAct,

  // etc

  _encodingFor,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

_.assert( _.routineIs( Self.prototype.pathCurrentAct ) );
_.assert( _.routineIs( Self.Path.current ) );

if( Config.interpreter === 'njs' )
if( !_.FileProvider.Default )
{
  _.FileProvider.Default = Self;
  if( !_.fileProvider )
  _.FileProvider.Default.MakeDefault();
}

_.FileProvider[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

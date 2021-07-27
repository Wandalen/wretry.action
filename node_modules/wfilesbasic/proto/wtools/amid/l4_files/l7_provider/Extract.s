( function _Extract_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Abstract = _.FileProvider.Abstract;
const Partial = _.FileProvider.Partial;
const FileRecord = _.files.FileRecord;
const Find = _.FileProvider.FindMixin;

_.assert( _.routineIs( _.files.FileRecord ) );
_.assert( _.routineIs( Abstract ) );
_.assert( _.routineIs( Partial ) );
_.assert( !!Find );
_.assert( !_.FileProvider.Extract );

//

/**
 @classdesc Class that allows file manipulations on filesTree - object based on some folders/files tree,
 where folders are nested objects with same depth level as in real folder and contains some files that are properties
 with corresponding names and file content as a values.
 @class wFileProviderExtract
 @namespace wTools.FileProvider
 @module Tools/mid/Files
*/

const Parent = Partial;
const Self = wFileProviderExtract;
function wFileProviderExtract( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Extract';

// --
// inter
// --

function init( o )
{
  let self = this;
  Parent.prototype.init.call( self, o );

  if( self.filesTree === null )
  self.filesTree = Object.create( null );

}

// --
// path
// --

function pathNativizeAct( filePath )
{
  let self = this;
  let result = filePath;
  _.assert( _.strIs( filePath ), 'Expects string' );
  _.assert( _.routineIs( self.path.unescape ) );
  result = self.path.unescape( result ); /* yyy */
  return result;
}

//

/**
 * @summary Return path to current working directory.
 * @description Changes current path to `path` if argument is provided.
 * @param {String} [path] New current path.
 * @function pathCurrentAct
 * @class wFileProviderExtract
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function pathCurrentAct()
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( arguments.length === 1 && arguments[ 0 ] )
  {
    let path = arguments[ 0 ];
    _.assert( self.path.is( path ) );
    self._currentPath = path;
  }

  let result = self._currentPath;

  return result;
}

//

/**
 * @summary Resolves soft link `o.filePath`.
 * @description Accepts single argument - map with options. Expects that map `o` contains all necessary options and don't have redundant fields.
 * Returns input path `o.filePath` if source file is not a soft link.
 * @param {Object} o Options map.
 * @param {String} o.filePath Path to soft link.
 * @param {Boolean} o.resolvingMultiple=0 Resolves chain of terminal links.
 * @param {Boolean} o.resolvingIntermediateDirectories=0 Resolves intermediate soft links.
 * @function pathResolveSoftLinkAct
 * @class wFileProviderExtract
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function pathResolveSoftLinkAct( o )
{
  let self = this;
  // let filePath = o.filePath;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.path.isAbsolute( o.filePath ) );

  // /* using self.resolvingSoftLink causes recursion problem in pathResolveLinkFull */
  // debugger;
  // if( !self.isSoftLink( o.filePath ) )
  // return o.filePath;

  let result;

  if( o.resolvingIntermediateDirectories )
  return resolveIntermediateDirectories();

  let filePath = self._pathResolveIntermediateDirs( o.filePath );

  let descriptor = self._descriptorRead( filePath );

  if( !self._DescriptorIsSoftLink( descriptor ) )
  return o.filePath;

  result = self._descriptorResolveSoftLinkPath( descriptor );

  _.assert( _.strIs( result ) )

  if( o.resolvingMultiple )
  return resolvingMultiple();

  return result;

  /*  */

  function resolveIntermediateDirectories()
  {
    let splits = self.path.split( o.filePath );
    let o2 = _.props.extend( null, o );

    o2.resolvingIntermediateDirectories = 0;
    o2.filePath = '/';

    for( let i = 1 ; i < splits.length ; i++ )
    {
      o2.filePath = self.path.join( o2.filePath, splits[ i ] );

      let descriptor = self._descriptorRead( o2.filePath );

      if( self._DescriptorIsSoftLink( descriptor ) )
      {
        result = self.pathResolveSoftLinkAct( o2 )
        o2.filePath = self.path.join( o2.filePath, result );
      }
    }
    return o2.filePath;
  }

  /**/

  function resolvingMultiple()
  {
    result = self.path.join( o.filePath, self.path.normalize( result ) );
    let descriptor = self._descriptorRead( result );
    if( !self._DescriptorIsSoftLink( descriptor ) )
    return result;
    let o2 = _.props.extend( null, o );
    o2.filePath = result;
    return self.pathResolveSoftLinkAct( o2 );
  }
}

_.routineExtend( pathResolveSoftLinkAct, Parent.prototype.pathResolveSoftLinkAct )

//

/**
 * @summary Resolves text link `o.filePath`.
 * @description Accepts single argument - map with options. Expects that map `o` contains all necessary options and don't have redundant fields.
 * Returns input path `o.filePath` if source file is not a text link.
 * @param {Object} o Options map.
 * @param {String} o.filePath Path to text link.
 * @param {Boolean} o.resolvingMultiple=0 Resolves chain of text links.
 * @param {Boolean} o.resolvingIntermediateDirectories=0 Resolves intermediate text links.
 * @function pathResolveTextLinkAct
 * @class wFileProviderExtract
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function pathResolveTextLinkAct( o )
{
  let self = this;
  let filePath = o.filePath;
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.path.isAbsolute( o.filePath ) );

  if( o.resolvingIntermediateDirectories )
  return resolveIntermediateDirectories();

  let file = self._descriptorRead( o.filePath );

  if( self._DescriptorIsSoftLink( file ) )
  return false;
  if( _.numberIs( file ) )
  return false;

  if( _.bufferRawIs( file ) || _.bufferTypedIs( file ) )
  file = _.bufferToStr( file );

  if( _.arrayIs( file ) )
  file = file[ 0 ].data;

  _.assert( _.strIs( file ) );

  let regexp = /^link ([^\n]+)\n?$/;
  let m = file.match( regexp );

  if( !m )
  return false;

  result = m[ 1 ];

  if( o.resolvingMultiple )
  return resolvingMultiple();

  return result;

  /*  */

  function resolveIntermediateDirectories()
  {
    let splits = self.path.split( o.filePath );
    let o2 = _.props.extend( null, o );

    o2.resolvingIntermediateDirectories = 0;
    o2.filePath = '/';

    for( let i = 1 ; i < splits.length ; i++ )
    {
      o2.filePath = self.path.join( o2.filePath, splits[ i ] );

      let descriptor = self._descriptorRead( o2.filePath );

      if( self._DescriptorIsTextLink( descriptor ) )
      {
        result = self.pathResolveTextLinkAct( o2 )
        o2.filePath = self.path.join( o2.filePath, result );
      }
    }
    return o2.filePath;
  }

  /**/

  function resolvingMultiple()
  {
    result = self.path.join( o.filePath, self.path.normalize( result ) );
    let descriptor = self._descriptorRead( result );
    if( !self._DescriptorIsTextLink( descriptor ) )
    return result;
    let o2 = _.props.extend( null, o );
    o2.filePath = result;
    return self.pathResolveTextLinkAct( o2 );
  }
}

_.routineExtend( pathResolveTextLinkAct, Parent.prototype.pathResolveTextLinkAct )

// --
// read
// --

/**
 * @summary Reads content of a terminal file.
 * @description Accepts single argument - map with options. Expects that map `o` contains all necessary options and don't have redundant fields.
 * If `o.sync` is false, return instance of wConsequence, that gives a message with concent of a file when reading is finished.
 * @param {Object} o Options map.
 * @param {String} o.filePath Path to terminal file.
 * @param {String} o.encoding Desired encoding of a file concent.
 * @param {*} o.advanced
 * @param {Boolean} o.resolvingSoftLink Enable resolving of soft links.
 * @param {String} o.sync Determines how to read a file, synchronously or asynchronously.
 * @function fileReadAct
 * @class wFileProviderExtract
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function fileReadAct( o )
{
  let self = this;
  let con = new _.Consequence();
  let result = null;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.map.assertHasAll( o, fileReadAct.defaults );
  // _.routine.assertOptions( fileReadAct, o );
  _.assert( _.strIs( o.encoding ) );
  // _.assert( o.fileProvider === self );

  // let encoder = fileReadAct.encoders[ o.encoding ];
  o.fileProvider = self;
  o.encoder = fileReadAct.encoders[ o.encoding ];
  if( o.encoder && o.encoder.onSelect)
  o.encoder.onSelect.call( self, o );

  if( o.encoding )
  if( !o.encoder )
  return handleError( _.err( 'Encoding: ' + o.encoding + ' is not supported!' ) )

  /* exec */

  handleBegin();

  o.filePath = self.pathResolveLinkFull
  ({
    filePath : o.filePath,
    resolvingSoftLink : o.resolvingSoftLink,
    // resolvingTextLink : o.resolvingTextLink,
  }).absolutePath;

  if( self.system && _.path.isGlobal( o.filePath ) )
  {
    _.assert( self.system !== self );
    return self.system.fileReadAct( o );
  }

  result = self._descriptorRead( o.filePath );

  if( self._DescriptorIsHardLink( result ) )
  {
    result = result[ 0 ].data;
    _.assert( result !== undefined );
  }

  if( result === undefined || result === null )
  {
    debugger;
    result = self._descriptorRead( o.filePath );
    return handleError( _.err( 'File at', _.strQuote( o.filePath ), 'doesn`t exist!' ) );
  }

  if( self._DescriptorIsDir( result ) )
  return handleError( _.err( 'Can`t read from dir : ' + _.strQuote( o.filePath ) + ' method expects terminal file' ) );
  else if( self._DescriptorIsLink( result ) )
  return handleError( _.err( 'Can`t read from link : ' + _.strQuote( o.filePath ) + ', without link resolving enabled' ) );
  else if( !self._DescriptorIsTerminal( result ) )
  return handleError( _.err( 'Can`t read file : ' + _.strQuote( o.filePath ), result ) );

  if( self.usingExtraStat )
  self._timeWriteAct({ filePath : o.filePath, atime : _.time.now() });

  return handleEnd( result );

  /* begin */

  function handleBegin()
  {

    if( o.encoder && o.encoder.onBegin )
    _.sure( o.encoder.onBegin.call( self, { operation : o, encoder : o.encoder }) === undefined );

  }

  /* end */

  function handleEnd( data )
  {

    let context = { data, operation : o, encoder : o.encoder };
    if( o.encoder && o.encoder.onEnd )
    _.sure( o.encoder.onEnd.call( self, context ) === undefined );
    data = context.data;

    if( o.sync )
    {
      return data;
    }
    else
    {
      return con.take( data );
    }

  }

  /* error */

  function handleError( err )
  {

    debugger;
    err = _._err
    ({
      // args : [ stack, '\nfileReadAct( ', o.filePath, ' )\n', err ],
      args : [ err, '\nfileRead( ', o.filePath, ' )\n' ],
      usingSourceCode : 0,
      level : 0,
    });

    if( o.encoder && o.encoder.onError )
    try
    {
      err = o.encoder.onError.call( self, { error : err, operation : o, encoder : o.encoder })
    }
    catch( err2 )
    {
      console.error( err2 );
      console.error( err.toString() + '\n' + err.stack );
    }

    if( o.sync )
    {
      throw err;
    }
    else
    {
      return con.error( err );
    }

  }

}

_.routineExtend( fileReadAct, Parent.prototype.fileReadAct );

//

function dirReadAct( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( dirReadAct, o );

  let result;

  if( o.sync )
  {
    readDir();
    return result;
  }
  else
  {
    return _.time.out( 0, function()
    {
      readDir();
      return result;
    });
  }

  /* */

  function readDir()
  {
    o.filePath = self.pathResolveLinkFull({ filePath : o.filePath, resolvingSoftLink : 1 }).absolutePath;

    let file = self._descriptorRead( o.filePath );

    if( file !== undefined )
    {
      if( _.object.isBasic( file ) )
      {
        result = Object.keys( file );
      }
      else
      {
        result = self.path.name({ path : o.filePath, full : 1 });
      }
    }
    else
    {
      result = null;
      throw _.err( 'File ', _.strQuote( o.filePath ), 'doesn`t exist!' );;
    }
  }

}

_.routineExtend( dirReadAct, Parent.prototype.dirReadAct );

// --
// read stat
// -

function statReadAct( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( statReadAct, o );

  /* */

  if( o.sync )
  {
    return _statReadAct( o.filePath );
  }
  else
  {
    return _.time.out( 0, function()
    {
      return _statReadAct( o.filePath );
    })
  }

  /* */

  function _statReadAct( filePath )
  {
    let result = null;

    if( o.resolvingSoftLink )
    {

      let o2 =
      {
        filePath,
        resolvingSoftLink : o.resolvingSoftLink,
        resolvingTextLink : 0,
      };

      filePath = self.pathResolveLinkFull( o2 ).absolutePath;
      _.assert( o2.stat !== undefined );

      if( !o2.stat && o.throwing )
      throw _.err( 'File', _.strQuote( filePath ), 'doesn`t exist!' );

      return o2.stat;
    }
    else
    {
      filePath = self._pathResolveIntermediateDirs( filePath );
    }

    let d = self._descriptorRead( filePath );

    if( !_.definedIs( d ) )
    {
      if( o.throwing )
      throw _.err( 'File', _.strQuote( filePath ), 'doesn`t exist!' );
      return result;
    }

    result = new _.files.FileStat();

    if( self.extraStats && self.extraStats[ filePath ] )
    {
      let extraStat = self.extraStats[ filePath ];
      result.atime = new Date( extraStat.atime );
      result.mtime = new Date( extraStat.mtime );
      result.ctime = new Date( extraStat.ctime );
      result.birthtime = new Date( extraStat.birthtime );
      result.ino = extraStat.ino || null;
      result.dev = extraStat.dev || null;
    }

    result.filePath = filePath;
    result.isTerminal = returnFalse;
    result.isDir = returnFalse;
    result.isTextLink = returnFalse; /* qqq : implement and add coverage, please */
    result.isSoftLink = returnFalse;
    result.isHardLink = returnFalse; /* qqq : implement and add coverage, please */
    result.isFile = returnFalse;
    result.isDirectory = returnFalse;
    result.isSymbolicLink = returnFalse;
    result.nlink = 1;

    if( result.ino === null )
    result.ino = d;

    if( self._DescriptorIsDir( d ) )
    {
      result.isDirectory = returnTrue;
      result.isDir = returnTrue;
    }
    else if( self._DescriptorIsTerminal( d ) || self._DescriptorIsHardLink( d ) )
    {
      if( self._DescriptorIsHardLink( d ) )
      {
        if( _.arrayIs( d[ 0 ].hardLinks ) )
        result.nlink = d[ 0 ].hardLinks.length;

        d = d[ 0 ].data;
        result.isHardLink = returnTrue;
      }

      result.isTerminal = returnTrue;
      result.isFile = returnTrue;

      if( _.numberIs( d ) )
      result.size = String( d ).length;
      else if( _.strIs( d ) )
      result.size = d.length;
      else
      result.size = d.byteLength;

      _.assert( result.size >= 0 );

      result.isTextLink = function isTextLink()
      {
        if( !self.usingTextLink )
        return false;
        return self._DescriptorIsTextLink( d );
      }
    }
    else if( self._DescriptorIsSoftLink( d ) )
    {
      result.isSymbolicLink = returnTrue;
      result.isSoftLink = returnTrue;
    }
    // else if( self._DescriptorIsHardLink( d ) ) /* Dmytro : strange duplicate */
    // {
    //   _.assert( 0 );
    //   // result.isHardLink = returnTrue;
    // }
    else if( self._DescriptorIsScript( d ) )
    {
      result.isTerminal = returnTrue;
      result.isFile = returnTrue;
    }

    return result;
  }

  /* */

  function returnFalse()
  {
    return false;
  }

  /* */

  function returnTrue()
  {
    return true;
  }

}

_.routineExtend( statReadAct, Parent.prototype.statReadAct );

//

function fileExistsAct( o )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( self.path.isNormalized( o.filePath ) );

  let filePath = o.filePath;

  filePath = self._pathResolveIntermediateDirs( filePath );

  let file = self._descriptorRead( filePath );
  return !!file;
}

_.routineExtend( fileExistsAct, Parent.prototype.fileExistsAct );

// --
// write
// --

function fileWriteAct( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( fileWriteAct, o );
  _.assert( self.path.isNormalized( o.filePath ) );
  _.assert( self.WriteMode.indexOf( o.writeMode ) !== -1 );

  o.fileProvider = self;
  o.encoder = fileWriteAct.encoders[ o.encoding ];
  if( o.encoder && o.encoder.onSelect)
  o.encoder.onSelect.call( self, o );

  _.assert( self._DescriptorIsTerminal( o.data ), `Expects string or BufferNode, but got ${_.entity.strType( o.data )}` );

  /* */

  if( o.sync )
  {
    write();
  }
  else
  {
    return _.time.out( 0, () => write() );
  }

  /* */

  function handleError( err )
  {
    err = _.err( err );
    if( o.sync )
    throw err;
    return new _.Consequence().error( err );
  }

  /* begin */

  function handleBegin( read )
  {
    if( !o.encoder )
    return o.data;

    _.assert( _.routineIs( o.encoder.onBegin ) )
    let context = { data : o.data, read, operation : o, encoder : o.encoder };
    _.sure( o.encoder.onBegin.call( self, context ) === undefined );

    return context.data;
  }

  /* */

  function write()
  {

    let filePath =  o.filePath;
    let descriptor = self._descriptorRead( filePath );
    let read;

    if( self._DescriptorIsLink( descriptor ) )
    {
      let resolvedPath = self.pathResolveLinkFull
      ({
        filePath,
        allowingMissed : 1,
        allowingCycled : 0,
        resolvingSoftLink : 1,
        resolvingTextLink : 0,
        preservingRelative : 0,
        throwing : 1
      }).absolutePath;
      descriptor = self._descriptorRead( resolvedPath );
      filePath = resolvedPath;

      // descriptor should be missing/text/hard/terminal
      _.assert
      (
        descriptor === undefined
        || self._DescriptorIsTerminal( descriptor )
        || self._DescriptorIsHardLink( descriptor )
      );

    }

    let dstDir = self._descriptorRead( self.path.dir( filePath ) );
    if( !dstDir )
    throw _.err( 'Directory for', filePath, 'does not exist' );
    else if( !self._DescriptorIsDir( dstDir ) )
    throw _.err( 'Parent of', filePath, 'is not a directory' );

    if( self._DescriptorIsDir( descriptor ) )
    throw _.err( 'Incorrect path to file!\nCan`t rewrite dir :', filePath );

    let writeMode = o.writeMode;

    _.assert( _.longHas( self.WriteMode, writeMode ), 'Unknown write mode:' + writeMode );

    if( descriptor === undefined || self._DescriptorIsLink( descriptor ) )
    {
      if( self._DescriptorIsHardLink( descriptor ) )
      {
        read = descriptor[ 0 ].data;
      }
      else
      {
        read = '';
        writeMode = 'rewrite';
      }
    }
    else
    {
      read = descriptor;
    }

    let data = handleBegin( read );

    _.assert( self._DescriptorIsTerminal( read ) );

    /* qqq : xxx : rewrite using extending module::Tools */
    if( writeMode === 'append' || writeMode === 'prepend' )
    {
      if( !o.encoder )
      {
        //converts data from file to the type of o.data
        if( _.strIs( data ) )
        {
          if( !_.strIs( read ) )
          read = _.bufferToStr( read );
        }
        else
        {
          _.assert( 0, 'not tested' );

          if( _.bufferBytesIs( data ) )
          read = _.bufferBytesFrom( read )
          else if( _.bufferRawIs( data ) )
          read = _.bufferRawFrom( read )
          else
          _.assert( 0, 'not implemented for:', _.entity.strType( data ) );
        }
      }

      if( _.strIs( read ) )
      {
        if( writeMode === 'append' )
        data = read + data;
        else
        data = data + read;
      }
      else
      {
        if( writeMode === 'append' )
        data = _.bufferJoin( read, data );
        else
        data = _.bufferJoin( data, read );
      }

    }
    else
    {
      _.assert( writeMode === 'rewrite', 'Not implemented write mode:', writeMode );
    }

    self._descriptorWrite( filePath, data );

    /* what for is that needed ??? */
    /*self._descriptorRead({ selector : dstDir, set : structure });*/

    return true;
  }

}

_.routineExtend( fileWriteAct, Parent.prototype.fileWriteAct );

//

function timeWriteAct( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.map.assertHasOnly( o, timeWriteAct.defaults );

  let file = self._descriptorRead( o.filePath );
  if( !file )
  throw _.err( 'File:', o.filePath, 'doesn\'t exist. Can\'t set time stats.' );

  self._timeWriteAct( o );

}

_.routineExtend( timeWriteAct, Parent.prototype.timeWriteAct );

//

function _timeWriteAct( o )
{
  let self = this;

  if( !self.usingExtraStat )
  return;

  if( _.strIs( arguments[ 0 ] ) )
  o = { filePath : arguments[ 0 ] };

  _.assert( self.path.isAbsolute( o.filePath ), o.filePath );
  _.assert( o.atime === undefined || o.atime === null || _.numberIs( o.atime ) );
  _.assert( o.mtime === undefined || o.mtime === null || _.numberIs( o.mtime ) );
  _.assert( o.ctime === undefined || o.ctime === null || _.numberIs( o.ctime ) );
  _.assert( o.birthtime === undefined || o.birthtime === null || _.numberIs( o.birthtime ) );

  let extra = self.extraStats[ o.filePath ];

  if( !extra )
  {
    extra = self.extraStats[ o.filePath ] = Object.create( null );
    extra.atime = null;
    extra.mtime = null;
    extra.ctime = null;
    extra.birthtime = null;
    extra.ino = ++Self.InoCounter;
    Object.preventExtensions( extra );
  }

  if( o.atime )
  extra.atime = o.atime;

  if( o.mtime )
  extra.mtime = o.mtime;

  if( o.ctime )
  extra.ctime = o.ctime;

  if( o.birthtime )
  extra.birthtime = o.birthtime;

  if( o.updatingDir )
  {
    let dirPath = self.path.dir( o.filePath );
    if( dirPath === '/' )
    return;

    extra.birthtime = null;

    _.assert( !!o.atime && !!o.mtime && !!o.ctime );
    _.assert( o.atime === o.mtime && o.mtime === o.ctime );

    o.filePath = dirPath;

    self._timeWriteAct( o );
  }

  return extra;
}

_timeWriteAct.defaults =
{
  filePath : null,
  atime : null,
  mtime : null,
  ctime : null,
  birthtime : null,
  updatingDir : false
}

//

function fileDeleteAct( o )
{
  let self = this;

  _.routine.assertOptions( fileDeleteAct, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.path.isNormalized( o.filePath ) );

  if( o.sync )
  {
    act();
  }
  else
  {
    return _.time.out( 0, () => act() );
  }

  /* - */

  function act()
  {
    let filePath = o.filePath;

    let stat = self.statReadAct
    ({
      filePath,
      resolvingSoftLink : 0,
      sync : 1,
      throwing : 0,
    });

    if( !stat )
    {
      debugger;
      throw _.err( 'Path', _.strQuote( o.filePath ), 'doesn`t exist!' );
    }

    /* Vova: intermediate dirs should be resolved, stat.filePath stores that resolved path */

    filePath = stat.filePath;

    let file = self._descriptorRead( filePath );
    if( self._DescriptorIsDir( file ) && Object.keys( file ).length )
    {
      debugger;
      throw _.err( 'Directory is not empty : ' + _.strQuote( o.filePath ) );
    }

    let dirPath = self.path.dir( filePath );
    let dir = self._descriptorRead( dirPath );

    _.sure( !!dir, () => `Cant delete root directory ${ o.filePath }` );

    let fileName = self.path.nativize( self.path.name({ path : filePath, full : 1 }) );
    delete dir[ fileName ];

    delete self.extraStats[ o.filePath ];
    self._descriptorTimeUpdate( dirPath, 0 );

    return true;
  }

}

_.routineExtend( fileDeleteAct, Parent.prototype.fileDeleteAct );

//

function dirMakeAct( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( dirMakeAct, o );

  /* */

  if( o.sync )
  {
    __make();
  }
  else
  {
    return _.time.out( 0, () => __make() );
  }

  /* - */

  function __make( )
  {
    if( self._descriptorRead( o.filePath ) )
    {
      debugger;
      throw _.err( 'File', _.strQuote( o.filePath ), 'already exists!' );
    }

    // _.assert( !!self._descriptorRead( self.path.dir( o.filePath ) ), 'Directory ', _.strQuote( o.filePath ), ' doesn\'t exist!' );

    let dstDir = self._descriptorRead( self.path.dir( o.filePath ) );
    if( !dstDir )
    throw _.err( 'Directory for', o.filePath, 'does not exist' );
    else if( !self._DescriptorIsDir( dstDir ) )
    throw _.err( 'Parent of', o.filePath, 'is not a directory' );

    self._descriptorWrite( o.filePath, Object.create( null ) );

    return true;
  }

}

_.routineExtend( dirMakeAct, Parent.prototype.dirMakeAct );

//

function fileLockAct( o )
{
  let self = this;

  _.assert( !o.locking, 'not implemented' );
  _.assert( !o.sharing || o.sharing === 'process', 'not implemented' );
  _.assert( self.path.isNormalized( o.filePath ) );
  _.assert( !o.waiting || o.timeOut >= 1000 );
  _.routine.assertOptions( fileLockAct, arguments );

  let con = _.Consequence.Try( () =>
  {
    if( !self._descriptorRead( o.filePath ) )
    throw _.err( 'File:', o.filePath, 'doesn\'t exist.' );

    let lockFilePath = o.filePath + '.lock';

    if( self.lockMap )
    if( self.lockMap[ o.filePath ] )
    if( self._descriptorRead( lockFilePath ) )
    {
      if( !o.sharing )
      throw _.err( 'File', o.filePath, 'is already locked by current process' );

      if( !o.waiting )
      {
        return true;
      }
      else if( o.sync )
      {
        throw _.err
        (
          'File', o.filePath, 'is already locked by current process.',
          'With option {-o.waiting-} enabled, lock will be waiting for itself.',
          'Please use existing lock or execute method with {-o.sync-} set to 0.'
        )
      }
    }

    let tries, con;

    if( !o.waiting )
    {
      return lock();
    }
    else
    {
      tries = o.timeOut / 1000;
      con = new _.Consequence();

      lockTry();

      return con;
    }

    /*  */

    function lock()
    {
      let lockFileDescriptor = self._descriptorRead( lockFilePath );

      if( lockFileDescriptor )
      throw _.err( 'File:', o.filePath, 'is locked, but lock file is not associated with current extract instance.' );

      self._descriptorWrite( lockFilePath, o.filePath );
      return true;
    }

    function lockTry()
    {
      tries -= 1;
      try
      {
        let result = lock();
        con.take( result );
      }
      catch( err )
      {
        if( tries < 0 )
        return con.error( err );

        _.time.out( 1000, () =>
        {
          lockTry();
          return null;
        })
      }
    }
  })

  con.then( ( got ) =>
  {
    if( self.lockMap === null )
    self.lockMap = Object.create( null );

    if( self.lockMap[ o.filePath ] === undefined )
    self.lockMap[ o.filePath ] = 0;

    self.lockMap[ o.filePath ] += 1;

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

  _.assert( self.path.isNormalized( o.filePath ) );
  _.routine.assertOptions( fileUnlockAct, arguments );

  let con = _.Consequence.Try( () =>
  {
    if( !self._descriptorRead( o.filePath ) )
    throw _.err( 'File:', o.filePath, 'doesn\'t exist.' );

    let lockFilePath = o.filePath + '.lock';
    let lockFileDescriptor = self._descriptorRead( lockFilePath );

    if( self.lockMap )
    if( self.lockMap[ o.filePath ] !== undefined )
    {
      _.assert( self.lockMap[ o.filePath ] > 0 );

      self.lockMap[ o.filePath ] -= 1;

      if( self.lockMap[ o.filePath ] > 0 )
      return true;

      if( !lockFileDescriptor )
      return true;

      let con = self.fileDeleteAct({ filePath : lockFilePath, sync : o.sync });

      if( o.sync )
      return true;

      return con;
    }

    if( lockFileDescriptor )
    throw _.err( 'File:', o.filePath, 'is locked, but lock file is not associated with current extract instance.' );
    else
    throw _.err( 'File:', o.filePath, 'is not locked.' );
  })

  con.then( ( got ) =>
  {
    if( self.lockMap[ o.filePath ] === 0 )
    {
      delete self.lockMap[ o.filePath ];
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

  _.routine.assertOptions( fileIsLockedAct, arguments );
  _.assert( self.path.isNormalized( o.filePath ) );

  let con = _.Consequence.Try( () =>
  {
    if( !self._descriptorRead( o.filePath ) )
    throw _.err( 'File:', o.filePath, 'doesn\'t exist.' );

    let lockFilePath = o.filePath + '.lock';
    let lockFileDescriptor = self._descriptorRead( lockFilePath );
    return !!lockFileDescriptor;
  })

  if( o.sync )
  return con.sync();

  return con;
}

_.routineExtend( fileIsLockedAct, Parent.prototype.fileIsLockedAct );


// --
// linkingAction
// --

function fileRenameAct( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( fileRenameAct, arguments );
  _.assert( self.path.isNormalized( o.srcPath ) );
  _.assert( self.path.isNormalized( o.dstPath ) );

  if( o.sync )
  {
    return rename();
  }
  else
  {
    return _.time.out( 0, () => rename() );
  }

  /* - */

  /* rename */

  function rename( )
  {
    let dstName = self.path.nativize( self.path.name({ path : o.dstPath, full : 1 }) );
    let srcName = self.path.nativize( self.path.name({ path : o.srcPath, full : 1 }) );
    let srcDirPath = self.path.dir( o.srcPath );
    let dstDirPath = self.path.dir( o.dstPath );

    let srcDir = self._descriptorReadResolved( srcDirPath );
    if( !srcDir || !srcDir[ srcName ] )
    throw _.err( 'Source path', _.strQuote( o.srcPath ), 'doesn`t exist!' );

    /*  */

    let dstDir = self._descriptorReadResolved( dstDirPath );
    if( !dstDir )
    throw _.err( 'Directory for', o.dstPath, 'does not exist' );
    else if( !self._DescriptorIsDir( dstDir ) )
    throw _.err( 'Parent of', o.dstPath, 'is not a directory' );
    if( dstDir[ dstName ] )
    throw _.err( 'Destination path', _.strQuote( o.dstPath ), 'already exists!' );

    dstDir[ dstName ] = srcDir[ srcName ];
    delete srcDir[ srcName ];

    self.extraStats[ o.dstPath ] = self.extraStats[ o.srcPath ];
    delete self.extraStats[ o.srcPath ];

    if( dstDir !== srcDir )
    {
      self._descriptorTimeUpdate( srcDirPath, 0 );
      self._descriptorTimeUpdate( dstDirPath, 0 );
    }

    return true;
  }

}

_.routineExtend( fileRenameAct, Parent.prototype.fileRenameAct );

//

function fileCopyAct( o )
{
  let self = this;
  let srcFile;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( fileCopyAct, arguments );
  _.assert( self.path.isNormalized( o.srcPath ) );
  _.assert( self.path.isNormalized( o.dstPath ) );

  if( o.sync  ) // qqq : synchronize async version aaa : done
  {
    _copyPre();

    let dstStat = self.statReadAct
    ({
      filePath : o.dstPath,
      resolvingSoftLink : 0,
      sync : 1,
      throwing : 0,
    });

    // let srcStat = self.statReadAct
    // ({
    //   filePath : o.srcPath,
    //   resolvingSoftLink : 0,
    //   sync : 1,
    //   throwing : 0,
    // });

    _.assert( self.isTerminal( o.srcPath ), () => _.strQuote( o.srcPath ), 'is not terminal' );

    /* qqq : ? aaa : redundant, just copy the descriptor instead of this */
    // if( self.isSoftLink( o.srcPath ) )
    // {
    //   if( self.fileExistsAct({ filePath : o.dstPath }) )
    //   self.fileDeleteAct({ filePath : o.dstPath, sync : 1 })
    //   return self.softLinkAct
    //   ({
    //     originalDstPath : o.originalDstPath,
    //     originalSrcPath : o.originalSrcPath,
    //     srcPath : self.pathResolveSoftLink( o.srcPath ),
    //     dstPath : o.dstPath,
    //     sync : o.sync,
    //     type : null
    //   })
    // }
    // self.fileWriteAct({ filePath : o.dstPath, data : srcFile, sync : 1 });

    let data = self.fileRead({ filePath : o.srcPath, encoding : 'meta.original', sync : 1, resolvingTextLink : 0 });
    _.assert( data !== null && data !== undefined );

    if( dstStat )
    if( dstStat.isSoftLink() )
    {
      o.dstPath = self.pathResolveLinkFull
      ({
        filePath : o.dstPath,
        allowingMissed : 1,
        allowingCycled : 0,
        resolvingSoftLink : 1,
        resolvingTextLink : 0,
        preservingRelative : 0,
        throwing : 1
      }).absolutePath;
    }

    self._descriptorWrite( o.dstPath, data );

  }
  else
  {
    let con = new _.Consequence().take( null );
    let dstStat, data;

    con.then( () =>
    {
      _copyPre();
      return self.statReadAct
      ({
        filePath : o.dstPath,
        resolvingSoftLink : 0,
        sync : 0,
        throwing : 0,
      })
    })
    .then( ( got ) =>
    {
      dstStat = got;
      return null;
    })
    .then( () =>
    {
      return self.fileRead
      ({
        filePath : o.srcPath,
        encoding : 'meta.original',
        sync : 0,
        resolvingTextLink : 0
      })
    })
    .then( ( got ) =>
    {
      data = got;

      _.assert( data !== null && data !== undefined );

      if( dstStat )
      if( dstStat.isSoftLink() )
      return self.pathResolveLinkFull
      ({
        filePath : o.dstPath,
        allowingMissed : 1,
        allowingCycled : 0,
        resolvingSoftLink : 1,
        resolvingTextLink : 0,
        preservingRelative : 0,
        sync : 0,
        throwing : 1
      })
      .then( ( resolved ) =>
      {
        o.dstPath = resolved.absolutePath;
        return true;
      })

      return true;
    })
    .then( () =>
    {
      self._descriptorWrite( o.dstPath, data );
      return true;
    })

    return con;
  }

  /* - */

  function _copyPre( )
  {

    let srcIsTerminal = self.isTerminal( o.srcPath );
    if( !srcIsTerminal )
    {
      debugger;
      throw _.err( 'File', _.strQuote( o.srcPath ), 'doesn`t exist or isn`t terminal!' );
    }

    let dstDirIsDir = self.isDir( self.path.dir( o.dstPath ) );
    if( !dstDirIsDir )
    {
      debugger;
      throw _.err( 'File', _.strQuote( self.path.dir( o.dstPath ) ), 'doesn`t exist or isn`t directory!' );
    }

    // srcFile  = self._descriptorRead( o.srcPath );
    //
    // if( !srcFile )
    // {
    //   debugger;
    //   throw _.err( 'File', _.strQuote( o.srcPath ), 'doesn`t exist!' );
    // }
    //
    // if( self._DescriptorIsDir( srcFile ) )
    // {
    //   debugger;
    //   throw _.err( o.srcPath, ' is not a terminal file!' );
    // }

    // let dstDir = self._descriptorRead( self.path.dir( o.dstPath ) );
    // if( !dstDir )
    // throw _.err( 'Directory for', o.dstPath, 'does not exist' );

    // let dstDir = self._descriptorRead( self.path.dir( o.dstPath ) );
    // if( !dstDir )
    // throw _.err( 'Directory for', o.dstPath, 'does not exist' );
    // else if( !self._DescriptorIsDir( dstDir ) )
    // throw _.err( 'Parent of', o.dstPath, 'is not a directory' );

    let dstIsDir = self.isDir( o.dstPath );
    // let dstPath = self._descriptorRead( o.dstPath );
    // if( self._DescriptorIsDir( dstPath ) )
    if( dstIsDir )
    throw _.err( 'Can`t rewrite directory by terminal file : ' + o.dstPath );

    return true;
  }

}

_.routineExtend( fileCopyAct, Parent.prototype.fileCopyAct );

//

function softLinkAct( o )
{
  let self = this;

  // debugger
  _.routine.assertOptions( softLinkAct, arguments );

  _.assert( self.path.is( o.srcPath ) );
  _.assert( self.path.isAbsolute( o.dstPath ) );
  _.assert( self.path.isNormalized( o.srcPath ) );
  _.assert( self.path.isNormalized( o.dstPath ) );

  // if( !self.path.isAbsolute( o.originalSrcPath ) )
  // debugger;
  // if( !self.path.isAbsolute( o.originalSrcPath ) )
  // o.srcPath = o.originalSrcPath;

  if( o.sync )
  {
    // if( o.dstPath === o.srcPath )
    // return true;

    if( self.statRead( o.dstPath ) )
    throw _.err( 'softLinkAct', o.dstPath, 'already exists' );

    dstDirCheck();

    /*
      qqq : add tests for linkingAction act routines
      qqq : don't forget throwing cases
    */

    self._descriptorWrite( o.dstPath, self._DescriptorSoftLinkMake( o.relativeSrcPath ) );

    return true;
  }
  else
  {
    // if( o.dstPath === o.srcPath )
    // return new _.Consequence().take( true );

    return self.statRead({ filePath : o.dstPath, sync : 0 })
    .finally( ( err, stat ) =>
    {
      if( err )
      throw _.err( err );

      if( stat )
      throw _.err( 'softLinkAct', o.dstPath, 'already exists' );


      dstDirCheck();

      self._descriptorWrite( o.dstPath, self._DescriptorSoftLinkMake( o.relativeSrcPath ) );

      return true;
    })
  }

  /*  */

  function dstDirCheck()
  {
    let dstDir = self._descriptorReadResolved( self.path.dir( o.dstPath ) );
    if( !dstDir )
    throw _.err( 'Directory for', o.dstPath, 'does not exist' );
    else if( !self._DescriptorIsDir( dstDir ) )
    throw _.err( 'Parent of', o.dstPath, 'is not a directory' );
  }
}

_.routineExtend( softLinkAct, Parent.prototype.softLinkAct );

//

function hardLinkAct( o )
{
  let self = this;

  _.routine.assertOptions( hardLinkAct, arguments );
  _.assert( self.path.isNormalized( o.srcPath ) );
  _.assert( self.path.isNormalized( o.dstPath ) );

  let con = _.Consequence().take( true );

  if( o.dstPath === o.srcPath )
  return o.sync ? true : con;

  let dstPath = o.dstPath;
  let srcPath = o.srcPath;

  con.then( checkPaths )

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

  function checkPaths()
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
      return true;
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
    if( self.fileExists( dstPath ) )
    throw _.err( dstPath, 'already exists' );

    let dstDir = self._descriptorRead( self.path.dir( dstPath ) );
    if( !dstDir )
    throw _.err( 'Directory for', dstPath, 'does not exist' );
    else if( !self._DescriptorIsDir( dstDir ) )
    throw _.err( 'Parent of', dstPath, 'is not a directory' );

    let srcDescriptor = self._descriptorRead( srcPath );
    let descriptor = self._DescriptorHardLinkMake( [ dstPath, srcPath ], srcDescriptor );
    if( srcDescriptor !== descriptor )
    self._descriptorWrite( srcPath, descriptor );
    self._descriptorWrite( dstPath, descriptor );

    if( self.usingExtraStat )
    self.extraStats[ o.dstPath ] = self.extraStats[ o.srcPath ]; /* Vova : check which stats hardlinked files should have in common */

    return true;
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

// --
// link
// --

function hardLinkBreakAct( o )
{
  let self = this;
  let descriptor = self._descriptorRead( o.filePath );

  _.assert( self._DescriptorIsHardLink( descriptor ) );

  // let read = self._descriptorResolve({ descriptor : descriptor });
  // _.assert( self._DescriptorIsTerminal( read ) );

  let con = _.Consequence.Try( () =>
  {
    _.arrayRemoveOnce( descriptor[ 0 ].hardLinks, o.filePath );

    self._descriptorWrite
    ({
      filePath : o.filePath,
      data : descriptor[ 0 ].data,
      breakingHardLink : true
    });

    return true;
  })

  if( o.sync )
  return con.sync();

  return con;
}

_.routineExtend( hardLinkBreakAct, Parent.prototype.hardLinkBreakAct );

//

function areHardLinkedAct( o )
{
  let self = this;

  _.routine.assertOptions( areHardLinkedAct, arguments );
  _.assert( o.filePath.length === 2, 'Expects exactly two arguments' );

  if( o.filePath[ 0 ] === o.filePath[ 1 ] )
  return true;

  let filePath1 = self._pathResolveIntermediateDirs( o.filePath[ 0 ] );
  let filePath2 = self._pathResolveIntermediateDirs( o.filePath[ 1 ] );

  if( filePath1 === filePath2 )
  return true;

  let descriptor1 = self._descriptorRead( filePath1 );
  let descriptor2 = self._descriptorRead( filePath2 );

  if( !self._DescriptorIsHardLink( descriptor1 ) )
  return false;
  if( !self._DescriptorIsHardLink( descriptor2 ) )
  return false;

  if( descriptor1 === descriptor2 )
  return true;

  _.assert
  (
    !_.longHas( descriptor1[ 0 ].hardLinks, o.filePath[ 1 ] ),
    'Hardlinked files are desynchronized, two hardlinked files should share the same descriptor, but those do not :',
    '\n', o.filePath[ 0 ],
    '\n', o.filePath[ 1 ]
  );

  return false;
}

_.routineExtend( areHardLinkedAct, Parent.prototype.areHardLinkedAct );

// --
// etc
// --

function isInoAct( o )
{
  let self = this;
  _.routine.assertOptions( isInoAct, arguments );

  if( self.usingExtraStat )
  {
    if( _.numberIs( o.ino ) || _.bigIntIs( o.ino ) )
    return true;
  }
  else
  {
    return self._DescriptorIs( o.ino );
  }

  return false;
}

isInoAct.defaults =
{
  ... Parent.prototype.isInoAct.defaults,
}

//

function filesTreeSet( src )
{
  let self = this;

  if( self[ filesTreeSymbol ] === src )
  return src;

  _.mapDelete( self.extraStats );

  self[ filesTreeSymbol ] = src;

  if( src && _.props.keys( src ).length && self.usingExtraStat )
  self.statsAdopt();

  return src;
}

//

function statsAdopt()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.filesFindNominal( '/', ( r ) =>
  {
    self._timeWriteAct({ filePath : r.absolute, atime : r.stat.atime || _.time.now() });
    return r;
  });

  return self;
}

//

// function linksRebase( o )
// {
//   let self = this;
//
//   _.routine.options_( linksRebase, o );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( 0, 'not tested' );
//
//   self.filesFind
//   ({
//     filePath : o.filePath,
//     recursive : 2,
//     onUp : onUp,
//   });
//
//   function onUp( file )
//   {
//     let descriptor = self._descriptorRead( file.absolute );
//
//     if( self._DescriptorIsHardLink( descriptor ) )
//     {
//       debugger;
//       descriptor = descriptor[ 0 ];
//       let was = descriptor.hardLink;
//       let url = _.uri.parseAtomic( descriptor.hardLink );
//       url.longPath = self.path.rebase( url.longPath, o.oldPath, o.newPath );
//       descriptor.hardLink = _.uri.str( url );
//       logger.log( '* linksRebase :', descriptor.hardLink, '<-', was );
//       debugger;
//     }
//
//     return file;
//   }
//
// }
//
// linksRebase.defaults =
// {
//   filePath : '/',
//   oldPath : '',
//   newPath : '',
// }

// --
//
// --

function _pathResolveIntermediateDirs( filePath )
{
  let self = this;

  // resolves intermediate dir(s) except terminal

  _.assert( self.path.isAbsolute( filePath ) );
  _.assert( self.path.isNormalized( filePath ) );

  if( _.strCount( filePath, self.path.upToken ) > 1 )
  {
    let fileName = self.path.name({ path : filePath, full : 1 });
    filePath = self.pathResolveSoftLinkAct
    ({
      filePath : self.path.dir( filePath ),
      resolvingIntermediateDirectories : 1,
      resolvingMultiple : 1
    });
    filePath = self.path.join( filePath, fileName );
  }

  return filePath;

}

// --
// descriptor read
// --

function _descriptorRead( o )
{
  let self = this;
  let path = self.path;

  if( _.strIs( arguments[ 0 ] ) )
  o = { filePath : arguments[ 0 ] };

  _.routine.options_( _descriptorRead, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !path.isGlobal( o.filePath ), 'Expects local path, but got', o.filePath );

  if( o.upToken === null )
  o.upToken = [ './', '/' ];
  if( o.filePath === '.' )
  o.filePath = '';
  if( !o.filesTree )
  o.filesTree = self.filesTree;

  let o2 = Object.create( null );

  // o2.setting = 0;
  o2.action = _.Selector.Action.no;
  o2.selector = o.filePath;
  o2.src = o.filesTree;
  o2.upToken = o.upToken;
  // o2.usingIndexedAccessToMap = 0;
  o2.globing = 0;

  // if( _.strEnds( o2.selector, '"?a8"' ) )
  // debugger;

  let result = _.select( o2 );

  return result;
}

_descriptorRead.defaults =
{
  filePath : null,
  filesTree : null,
  upToken : null,
}

//

function _descriptorReadResolved( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { filePath : arguments[ 0 ] };

  let filePath = self._pathResolveIntermediateDirs( o.filePath );

  let result = self._descriptorRead( filePath );

  if( self._DescriptorIsLink( result ) )
  {
    let filePathResolved = self.pathResolveLinkFull
    ({
      filePath,
      allowingMissed : 1,
      allowingCycled : 0,
      resolvingSoftLink : 1,
      resolvingTextLink : 0,
      preservingRelative : 0,
      throwing : 1
    });
    result = self._descriptorRead( filePathResolved.absolutePath );
    // result = self._descriptorResolve({ descriptor : result });
  }

  return result;
}

_.routineExtend( _descriptorReadResolved, _descriptorRead );

//

function _descriptorResolve( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.descriptor );
  _.routine.options_( _descriptorResolve, o );
  self._providerDefaultsApply( o );
  _.assert( !o.resolvingTextLink );

  if( self._DescriptorIsHardLink( o.descriptor ) /* && self.resolvingHardLink */ )
  {
    return self._descriptorResolveHardLink( o.descriptor );
    // o.descriptor = self._descriptorResolveHardLink( o.descriptor );
    // return self._descriptorResolve
    // ({
    //   descriptor : o.descriptor,
    //   // resolvingHardLink : o.resolvingHardLink,
    //   resolvingSoftLink : o.resolvingSoftLink,
    //   resolvingTextLink : o.resolvingTextLink,
    // });
  }

  if( self._DescriptorIsSoftLink( o.descriptor ) && self.resolvingSoftLink )
  {
    o.descriptor = self._descriptorResolveSoftLink( o.descriptor );
    return self._descriptorResolve
    ({
      descriptor : o.descriptor,
      // resolvingHardLink : o.resolvingHardLink,
      resolvingSoftLink : o.resolvingSoftLink,
      resolvingTextLink : o.resolvingTextLink,
    });
  }

  return o.descriptor;
}

_descriptorResolve.defaults =
{
  descriptor : null,
  // resolvingHardLink : null,
  resolvingSoftLink : null,
  resolvingTextLink : null,
}

// function _descriptorResolvePath( o )
// {
//   let self = this;

//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( o.descriptor );
//   _.routine.options_( _descriptorResolve, o );
//   self._providerDefaultsApply( o );
//   _.assert( !o.resolvingTextLink );

//   let descriptor = self._descriptorRead( o.descriptor );

//   if( self._DescriptorIsHardLink( descriptor ) && self.resolvingHardLink )
//   {
//     o.descriptor = self._descriptorResolveHardLinkPath( descriptor );
//     return self._descriptorResolvePath
//     ({
//       descriptor : o.descriptor,
//       resolvingHardLink : o.resolvingHardLink,
//       resolvingSoftLink : o.resolvingSoftLink,
//       resolvingTextLink : o.resolvingTextLink,
//     });
//   }

//   if( self._DescriptorIsSoftLink( descriptor ) && self.resolvingSoftLink )
//   {
//     o.descriptor = self._descriptorResolveSoftLinkPath( descriptor );
//     return self._descriptorResolvePath
//     ({
//       descriptor : o.descriptor,
//       resolvingHardLink : o.resolvingHardLink,
//       resolvingSoftLink : o.resolvingSoftLink,
//       resolvingTextLink : o.resolvingTextLink,
//     });
//   }

//   return o.descriptor;
// }

// _descriptorResolvePath.defaults =
// {
//   descriptor : null,
//   resolvingHardLink : null,
//   resolvingSoftLink : null,
//   resolvingTextLink : null,
// }

//

// function _descriptorResolveHardLinkPath( descriptor )
// {
//   let self = this;
//   descriptor = descriptor[ 0 ];
//
//   _.assert( descriptor.data !== undefined );
//   return descriptor.data;
//
//   // _.assert( !!descriptor.hardLink );
//   // return descriptor.hardLink;
// }

//

function _descriptorResolveHardLink( descriptor )
{
  let self = this;
  let result;

  _.assert( descriptor.data !== undefined );
  return descriptor.data;

  // let filePath = self._descriptorResolveHardLinkPath( descriptor );
  // let url = _.uri.parse( filePath );
  //
  // _.assert( arguments.length === 1 )
  //
  // if( url.protocol )
  // {
  //   debugger;
  //   throw _.err( 'not implemented' );
  //   // _.assert( url.protocol === 'file', 'can handle only "file" protocol, but got', url.protocol );
  //   // result = _.fileProvider.fileRead( url.localPath );
  //   // _.assert( _.strIs( result ) );
  // }
  // else
  // {
  //   debugger;
  //   result = self._descriptorRead( url.localPath );
  // }

  return result;
}

//

function _descriptorResolveSoftLinkPath( descriptor, withPath )
{
  let self = this;
  descriptor = descriptor[ 0 ];
  _.assert( !!descriptor.softLink );
  return descriptor.softLink;
}

//

function _descriptorResolveSoftLink( descriptor )
{
  let self = this;
  let result;
  let filePath = self._descriptorResolveSoftLinkPath( descriptor );
  let url = _.uri.parse( filePath );

  _.assert( arguments.length === 1 )

  if( url.protocol )
  {
    debugger;
    throw _.err( 'not implemented' );
    // _.assert( url.protocol === 'file', 'can handle only "file" protocol, but got', url.protocol );
    // result = _.fileProvider.fileRead( url.localPath );
    // _.assert( _.strIs( result ) );
  }
  else
  {
    debugger;
    result = self._descriptorRead( url.resourcePath );
  }

  return result;
}

//

function _DescriptorIs( file )
{
  if( file === undefined )
  return false;
  return true;
}

//

function _DescriptorIsDir( file )
{
  return _.object.isBasic( file );
}

//

function _DescriptorIsTerminal( file )
{
  if( _.strIs( file ) )
  return true;
  if( _.numberIs( file ) )
  return true;
  if( _.bufferRawIs( file ) )
  return true;
  if( _.bufferTypedIs( file ) )
  return true;
  if( _.bufferNodeIs( file ) )
  return true;
  return false;
}

//

function _DescriptorIsLink( file )
{
  if( !_.arrayIs( file ) )
  return false;

  // if( _.arrayIs( file ) )
  // {
  _.assert( file.length === 1 );
  file = file[ 0 ];
  // }
  _.assert( !!file );
  return !!( file.hardLinks || file.softLink );
}

//

function _DescriptorIsSoftLink( file )
{
  if( !_.arrayIs( file ) )
  return false;

  // if( _.arrayIs( file ) )
  // {
  _.assert( file.length === 1 );
  file = file[ 0 ];
  // }
  _.assert( !!file );
  return !!file.softLink;
}

//

function _DescriptorIsHardLink( file )
{
  if( !_.arrayIs( file ) )
  return false;

  // if( _.arrayIs( file ) )
  // {
  _.assert( file.length === 1 );
  file = file[ 0 ];
  // }

  _.assert( !!file );
  _.assert( !file.hardLink );

  return !!file.hardLinks;
}

//

function _DescriptorIsTextLink( file )
{
  if( !_.definedIs( file ) )
  return false;
  if( _.arrayIs( file ) )
  return false;
  if( _.object.isBasic( file ) )
  return false;

  let regexp = /^link ([^\n]+)\n?$/;
  if( _.bufferRawIs( file ) || _.bufferTypedIs( file ) )
  file = _.bufferToStr( file )
  _.assert( _.strIs( file ) );
  return regexp.test( file );
}

//

function _DescriptorIsScript( file )
{
  if( !_.arrayIs( file ) )
  return false;

  // if( _.arrayIs( file ) )
  // {
  _.assert( file.length === 1 );
  file = file[ 0 ];
  // }

  _.assert( !!file );
  return !!file.code;
}

// --
// descriptor write
// --

function _descriptorWrite( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { filePath : arguments[ 0 ], data : ( arguments.length > 1 ? arguments[ 1 ] : null ) };

  _.routine.options_( _descriptorWrite, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( o.upToken === null )
  o.upToken = [ './', '/' ];
  if( o.filePath === '.' )
  o.filePath = '';

  if( !o.filesTree )
  {
    _.assert( _.objectLike( self.filesTree ) );
    o.filesTree = self.filesTree;
  }

  o.filePath = self._pathResolveIntermediateDirs( o.filePath )

  let file = self._descriptorRead( o.filePath );
  let willBeCreated = file === undefined;
  let time = _.time.now();

  let result;

  if( !o.breakingHardLink && self._DescriptorIsHardLink( file ) )
  {
    result = file[ 0 ].data = o.data;
  }
  else
  {
    let o2 = Object.create( null );

    // o2.setting = 1;
    o2.action = _.Selector.Action.set;
    o2.set = o.data;
    o2.selector = o.filePath;
    o2.src = o.filesTree;
    o2.upToken = o.upToken;
    // o2.usingIndexedAccessToMap = 0;
    o2.globing = 0;

    result = _.select( o2 );
  }

  o.filePath = self.path.join( '/', o.filePath );

  let timeOptions =
  {
    filePath : o.filePath,
    ctime : time,
    mtime : time
  }

  if( willBeCreated )
  {
    timeOptions.atime = time;
    timeOptions.birthtime = time;
    timeOptions.updatingDir = 1;
  }

  if( self.usingExtraStat )
  self._timeWriteAct( timeOptions );

  return result;
}

_descriptorWrite.defaults =
{
  filePath : null,
  filesTree : null,
  data : null,
  upToken : null,
  breakingHardLink : false
}

//

function _descriptorTimeUpdate( filePath, created )
{
  let self = this;
  let time = _.time.now();

  _.assert( arguments.length === 2 );

  if( !self.usingExtraStat )
  return;

  let o2 =
  {
    filePath,
    ctime : time,
    mtime : time
  }

  if( created )
  {
    o2.atime = time;
    o2.birthtime = time;
    o2.updatingDir = 1;
  }

  self._timeWriteAct( o2 );
}

// //
//
// function _DescriptorScriptMake( filePath, data )
// {
//
//   if( _.strIs( data ) )
//   try
//   {
//     data = _.routineMake({ code : data, prependingReturn : 0 });
//   }
//   catch( err )
//   {
//     debugger;
//     throw _.err( 'Cant make routine for file :\n' + filePath + '\n', err );
//   }
//
//   _.assert( _.routineIs( data ) );
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   let d = Object.create( null );
//   d.filePath = filePath;
//   d.code = data;
//   // d.ino = ++Self.InoCounter;
//   return [ d ];
// }

//

function _DescriptorSoftLinkMake( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  let d = Object.create( null );
  d.softLink = filePath;
  // d.ino = ++Self.InoCounter;
  return [ d ];
}

//

function _DescriptorHardLinkMake( filePath, data )
{
  _.assert( arguments.length === 2 );
  _.assert( _.arrayIs( filePath ) );

  if( this._DescriptorIsHardLink( data ) )
  {
    _.arrayAppendArrayOnce(  data[ 0 ].hardLinks, filePath );
    return data;
  }

  let d = Object.create( null );
  d.hardLinks = filePath;
  d.data = data;
  // d.ino = ++Self.InoCounter;

  return [ d ];
}

// --
// encoders
// --

let readEncoders = Object.create( null );
let writeEncoders = Object.create( null );

fileReadAct.encoders = readEncoders;
fileWriteAct.encoders = writeEncoders;

//

readEncoders[ 'utf8' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'utf8' );
  },

  onEnd : function( e )
  {
    if( !_.strIs( e.data ) )
    e.data = _.bufferToStr( e.data );
    _.assert( _.strIs( e.data ) );;
  },

}

//

readEncoders[ 'ascii' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'ascii' );
  },

  onEnd : function( e )
  {
    if( !_.strIs( e.data ) )
    e.data = _.bufferToStr( e.data );
    _.assert( _.strIs( e.data ) );;
  },

}

//

readEncoders[ 'latin1' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'latin1' );
  },

  onEnd : function( e )
  {
    if( !_.strIs( e.data ) )
    e.data = _.bufferToStr( e.data );
    _.assert( _.strIs( e.data ) );;
  },

}

//

readEncoders[ 'buffer.raw' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'buffer.raw' );
  },

  onEnd : function( e )
  {

    e.data = _.bufferRawFrom( e.data );

    _.assert( !_.bufferNodeIs( e.data ) );
    _.assert( _.bufferRawIs( e.data ) );

  },

}

//

readEncoders[ 'buffer.bytes' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'buffer.bytes' );
  },

  onEnd : function( e )
  {
    e.data = _.bufferBytesFrom( e.data );
  },

}

//

readEncoders[ 'meta.original' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'meta.original' );
  },

  onEnd : function( e )
  {
    _.assert( _DescriptorIsTerminal( e.data ) );
  },

}

//

if( Config.interpreter === 'njs' )
readEncoders[ 'buffer.node' ] =
{

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'buffer.node' );
  },

  onEnd : function( e )
  {
    e.data = _.bufferNodeFrom( e.data );
    // let result = BufferNode.from( e.data );
    // _.assert( _.strIs( e.data ) );
    _.assert( _.bufferNodeIs( e.data ) );
    _.assert( !_.bufferRawIs( e.data ) );
    // return result;
  },

}

//

writeEncoders[ 'meta.original' ] =
{
  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'meta.original' );

    if( e.read === undefined || e.operation.writeMode === 'rewrite' )
    return;

    if( _.strIs( e.read ) )
    {
      if( !_.strIs( e.data ) )
      e.data = _.bufferToStr( e.data );
    }
    else
    {

      if( _.bufferBytesIs( e.read ) )
      e.data = _.bufferBytesFrom( e.data )
      else if( _.bufferRawIs( e.read ) )
      e.data = _.bufferRawFrom( e.data )
      else
      {
        _.assert( 0, 'not implemented for:', _.entity.strType( e.read ) );
        // _.bufferCoerceFrom({ src : data, bufferConstructor : read.constructor });
      }
    }
  }
}

// --
// relations
// --

/**
 * @typedef {Object} Fields
 * @property {Boolean} usingExtraStat
 * @property {Array} protocols
 * @property {Boolean} safe
 * @property {Object} filesTree
 * @namespace wTools.FileProvider
 @module Tools/mid/Files
 */

let Composes =
{
  usingExtraStat : null, /* add test suite for this provider and usingExtraStat : 1 */
  protocols : _.define.own( [] ),
  _currentPath : '/',
  safe : 0,
}

let Aggregates =
{
  filesTree : null,
}

let Associates =
{
}

let Restricts =
{
  extraStats : _.define.own( {} ),
  lockMap : null
}

let Accessors =
{
  filesTree : { set : filesTreeSet },
}

let Statics =
{

  _DescriptorIs,
  _DescriptorIsDir,
  _DescriptorIsTerminal,
  _DescriptorIsLink,
  _DescriptorIsSoftLink,
  _DescriptorIsHardLink,
  _DescriptorIsTextLink,

  // _DescriptorScriptMake, /* zzz : deprecate */
  _DescriptorSoftLinkMake,
  _DescriptorHardLinkMake,

  Path : _.uri.CloneExtending({ fileProvider : Self }),
  InoCounter : 0,

  SupportsIno : 1,

}

let filesTreeSymbol = Symbol.for( 'filesTree' );

// --
// declare
// --

let Extension =
{

  init,

  // path

  pathNativizeAct,
  pathCurrentAct,
  pathResolveSoftLinkAct,
  pathResolveTextLinkAct,

  // read

  fileReadAct,
  dirReadAct,
  streamReadAct : null,
  statReadAct,
  fileExistsAct,

  // write

  fileWriteAct,
  timeWriteAct,
  _timeWriteAct,
  fileDeleteAct,
  dirMakeAct,
  streamWriteAct : null,

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

  hardLinkBreakAct,
  areHardLinkedAct,

  // etc

  isInoAct,

  filesTreeSet,
  statsAdopt,
  // linksRebase,

  //

  _pathResolveIntermediateDirs,

  // descriptor read

  _descriptorRead,
  _descriptorReadResolved,

  _descriptorResolve,
  // _descriptorResolvePath,

  // _descriptorResolveHardLinkPath,
  _descriptorResolveHardLink,
  _descriptorResolveSoftLinkPath,
  _descriptorResolveSoftLink,

  _DescriptorIs,
  _DescriptorIsDir,
  _DescriptorIsTerminal,
  _DescriptorIsLink,
  _DescriptorIsSoftLink,
  _DescriptorIsHardLink,
  _DescriptorIsScript,

  // descriptor write

  _descriptorWrite,

  _descriptorTimeUpdate,

  // _DescriptorScriptMake,
  _DescriptorSoftLinkMake,
  _DescriptorHardLinkMake,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Accessors,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

// --
// export
// --

_.FileProvider[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

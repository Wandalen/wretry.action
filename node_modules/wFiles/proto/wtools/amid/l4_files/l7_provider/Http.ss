( function _Http_ss_()
{

'use strict';

let Needle;

//

/* qqq : add such test routine

  return a.fileProvider.filesReflect
  ({
    reflectMap : { [ imagePath ] : a.abs( `file.img` ) },
    sync : 1,
  });

*/

/**
 @classdesc Class to transfer data over http protocol using GET/POST methods. Implementation for a server side.
 @class wFileProviderHttp
 @namespace wTools.FileProvider
 @module Tools/mid/Files
*/

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.FileProvider.Partial;
const Self = wFileProviderHttp;
function wFileProviderHttp( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Http';

_.assert( !_.FileProvider.Http );

// --
// inter
// --

function init( o )
{
  let self = this;
  Parent.prototype.init.call( self, o );
}

//

function streamReadAct( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.path.isAbsolute( o.filePath ), 'Expects absolute {-o.filePath-}' );
  // _.assert( _.strIs( o.filePath ), 'streamReadAct :', 'Expects {-o.filePath-}' );

  o.filePath = o.filePath.replace( '///', '//' );

  if( !Needle )
  Needle = require( 'needle' );

  let stream = Needle.get( o.filePath, { follow_max : 5 } );

  if( o.onStreamBegin === null )
  o.onStreamBegin = function( o )
  {
    if( o.response.statusCode >= 400 && o.response.statusCode < 500 )
    o.stream.emit( 'error', _.err( `Client error. StatusCode: ${o.response.statusCode}` ) );
  }

  stream.on( 'response', ( res ) =>
  {
    o.onStreamBegin.call( self, { operation : o, stream, response : res } );
  })

  return stream;
}

streamReadAct.defaults = Object.create( Parent.prototype.streamReadAct.defaults );
streamReadAct.having = Object.create( Parent.prototype.streamReadAct.having );

//

/**
 * @summary Reads content of a remote resourse performing GET request.
 * @description Accepts single argument - map with options. Expects that map `o` contains all necessary options and don't have redundant fields.
 * If `o.sync` is false, return instance of wConsequence, that gives a message with concent of a file when reading is finished.
 *
 * @param {Object} o Options map.
 * @param {String} o.filePath Remote url.
 * @param {String} o.encoding Desired encoding of a file concent.
 * @param {Boolean} o.resolvingSoftLink Enable resolving of soft links.
 * @param {String} o.sync Determines how to read a file, synchronously or asynchronously.
 * @param {Object} o.advanced Advanced options for http method
 * @param {*} o.advanced.send Data to send.
 * @param {String} o.advanced.method Which http method to use: 'GET' or 'POST'.
 * @param {String} o.advanced.user Username, is used in authorization
 * @param {String} o.advanced.password Password, is used in authorization
 *
 * @function fileReadAct
 * @class wFileProviderHttp
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function fileReadAct( o )
{
  let self = this;
  let con = new _.Consequence( );

  // if( _.strIs( o ) )
  // {
  //   o = { filePath : o };
  // }

  _.routine.assertOptions( fileReadAct, arguments );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.filePath ), 'fileReadAct :', 'Expects {-o.filePath-}' );
  _.assert( _.strIs( o.encoding ), 'fileReadAct :', 'Expects {-o.encoding-}' );
  _.assert( !o.sync, 'sync version is not implemented' );

  o.encoding = o.encoding.toLowerCase();
  let encoder = fileReadAct.encoders[ o.encoding ];

  logger.log( 'fileReadAct', o );

  /* on encoding : arraybuffer or encoding : buffer should return buffer( in consequence ) */

  function handleError( err )
  {

    err = _._err
    ({
      // args : [ stack, '\nfileReadAct( ', o.filePath, ' )\n', err ],
      args : [ err, '\nfileRead( ', o.filePath, ' )\n' ],
      usingSourceCode : 0,
      level : 0,
    });

    if( encoder && encoder.onError )
    try
    {
      // err = _._err
      // ({
      //   args : [ stack,'\nfileReadAct( ',o.filePath,' )\n',err ],
      //   usingSourceCode : 0,
      //   level : 0,
      // });
      err = encoder.onError.call( self, { error : err, operation : o, encoder } );
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
      con.error( err );
    }
  }

  /* */

  function onData( data )
  {

    if( o.encoding === null )
    {
      _.bufferMove
      ({
        dst : result,
        src : data,
        dstOffset
      });

      dstOffset += data.length;
    }
    else
    {
      result += data;
    }

  }

  /* */

  let result = null;;
  let totalSize = null;
  let dstOffset = 0;

  if( encoder && encoder.onBegin )
  _.sure( encoder.onBegin.call( self, { operation : o, encoder }) === undefined );

  self.streamReadAct({ filePath :  o.filePath })
  .give( function( err, response )
  {
    if( err )
    return handleError( err );

    _.assert( _.strIs( o.encoding ) || o.encoding === null );

    if( o.encoding === null )
    {
      totalSize = response.headers[ 'content-length' ];
      result = new BufferRaw( totalSize );
    }
    else
    {
      response.setEncoding( o.encoding );
      result = '';
    }

    response.on( 'data', onData );
    response.on( 'end', onEnd );
    response.on( 'error', handleError );

  });

  return con;

  /* */

  function onEnd()
  {
    if( o.encoding === null )
    _.assert( _.bufferRawIs( result ) );
    else
    _.assert( _.strIs( result ) );

    let context = { data : result, operation : o, encoder };
    if( encoder && encoder.onEnd )
    _.sure( encoder.onEnd.call( self, context ) === undefined );
    result = context.data

    con.take( result );
  }

}

fileReadAct.defaults = Object.create( Parent.prototype.fileReadAct.defaults );
fileReadAct.having = Object.create( Parent.prototype.fileReadAct.having );

fileReadAct.advanced =
{
  send : null,
  method : 'GET',
  user : null,
  password : null,
}

//

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

  /* */

  let con = new _.Consequence();
  let dstFileProvider = o.dst.providerForPath();
  let srcPath = o.src.filePathSimplest();
  let dstPath = o.dst.filePathSimplest();
  // let srcPath = o.srcPath;
  // let dstPath = o.dstPath;
  let srcCurrentPath;

  // if( _.mapIs( srcPath ) )
  // {
  //   _.assert( _.props.vals( srcPath ).length === 1 );
  //   _.assert( _.props.vals( srcPath )[ 0 ] === true || _.props.vals( srcPath )[ 0 ] === dstPath );
  //   srcPath = _.props.keys( srcPath )[ 0 ];
  // }

  srcPath = srcPath.replace( '///', '//' );

  /* */

  _.sure( _.strIs( srcPath ) );
  _.sure( _.strIs( dstPath ) );
  _.assert( dstFileProvider instanceof _.FileProvider.HardDrive || dstFileProvider.originalFileProvider instanceof _.FileProvider.HardDrive, 'Support only downloading on hard drive' );
  _.sure( !o.src || !o.src.hasFiltering(), 'Does not support filtering, but {o.src} is not empty' );
  _.sure( !o.dst || !o.dst.hasFiltering(), 'Does not support filtering, but {o.dst} is not empty' );
  // _.sure( !o.filter || !o.filter.hasFiltering(), 'Does not support filtering, but {o.filter} is not empty' );

  /* log */

  // logger.log( '' );
  // logger.log( 'srcPath', srcPath );
  // logger.log( 'dstPath', dstPath );
  // logger.log( '' );

  /* */

  dstFileProvider.dirMake( dstFileProvider.path.dir( dstPath ) );

  let writeStream = null;
  writeStream = dstFileProvider.streamWrite({ filePath : dstPath });
  writeStream.on( 'error', onError );
  writeStream.on( 'finish', function( )
  {
    writeStream.close( () => con.take( null ) )
  });

  let readStream = self.streamRead({ filePath : srcPath })

  readStream.on( 'header', ( statusCode ) =>
  {
    if( statusCode === 200 )
    readStream.pipe( writeStream );
  })

  readStream.on( 'error', onError )

  /* handle error if any */

  con.then( () => recordsMake() )

  return con;

  /* */

  function recordsMake()
  {
    /* qqq : fast solution to return some records instead of empty arrray. find better solution */
    if( o.outputFormat !== 'nothing' )
    o.result = dstFileProvider.filesReflectEvaluate
    ({
      src : { filePath : dstPath },
      dst : { filePath : dstPath },
    });
    return o.result;
  }

  /* begin */

  function onError( err )
  {
    try
    {
      dstFileProvider.fileDelete( dstPath );
    }
    catch( err )
    {
    }
    con.error( _.err( err ) );
  }

}

_.routineExtend( filesReflectSingle_body, _.FileProvider.FindMixin.prototype.filesReflectSingle.body );

var extra = filesReflectSingle_body.extra = Object.create( null );
extra.fetching = 1;

var defaults = filesReflectSingle_body.defaults;
let filesReflectSingle =
_.routine.uniteCloning_replaceByUnite( _.FileProvider.FindMixin.prototype.filesReflectSingle.head, filesReflectSingle_body );

//

/**
 * @summary Saves content of a remote resourse to the hard drive. Actual implementation.
 * @description Accepts single argument - map with options. Expects that map `o` contains all necessary options and don't have redundant fields.
 *
 * @param {Object} o Options map.
 * @param {String} o.url Remote url.
 * @param {String} o.filePath Destination path.
 * @param {String} o.encoding Desired encoding of a file concent.
 * @param {Boolean} o.resolvingSoftLink Enable resolving of soft links.
 * @param {String} o.sync Determines how to read a file, synchronously or asynchronously.
 * @param {Object} o.advanced Advanced options for http method
 * @param {*} o.advanced.send Data to send.
 * @param {String} o.advanced.method Which http method to use: 'GET' or 'POST'.
 * @param {String} o.advanced.user Username, is used in authorization
 * @param {String} o.advanced.password Password, is used in authorization
 *
 * @function fileCopyToHardDriveAct
 * @class wFileProviderHttp
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function fileCopyToHardDriveAct( o )
{
  let self = this;
  let con = new _.Consequence();

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.url ), 'fileCopyToHardDriveAct :', 'Expects {-o.filePath-}' );
  _.assert( _.strIs( o.filePath ), 'fileCopyToHardDriveAct :', 'Expects {-o.filePath-}' );

  let dstFileProvider = _.FileProvider.HardDrive( );
  let writeStream = null;
  let dstPath = dstFileProvider.path.nativize( o.filePath );

  console.log( 'dstPath', dstPath );

  writeStream = dstFileProvider.streamWrite({ filePath : dstPath });
  writeStream.on( 'error', onError );
  writeStream.on( 'finish', function()
  {
    writeStream.close( function()
    {
      con.take( o.filePath );
    })
  });

  self.streamReadAct({ filePath : o.url })
  .give( function( errn, response )
  {
    response.pipe( writeStream );
    response.on( 'error', onError );
  });

  return con;

  /* begin */

  function onError( err )
  {
    try
    {
      HardDrive.fileDelete( o.filePath );
    }
    catch( err )
    {
    }
    con.error( _.err( err ) );
  }

}

var defaults = fileCopyToHardDriveAct.defaults = Object.create( Parent.prototype.fileReadAct.defaults );

defaults.url = null;

fileCopyToHardDriveAct.advanced =
{
  send : null,
  method : 'GET',
  user : null,
  password : null,

}

//

/**
 * @summary Saves content of a remote resourse to the hard drive.
 * @description Accepts single argument - map with options. Expects that map `o` contains all necessary options and don't have redundant fields.
 *
 * @param {Object} o Options map.
 * @param {String} o.url Remote url.
 * @param {String} o.filePath Destination path.
 * @param {String} o.encoding Desired encoding of a file concent.
 * @param {Boolean} o.resolvingSoftLink Enable resolving of soft links.
 * @param {String} o.sync Determines how to read a file, synchronously or asynchronously.
 * @param {Object} o.advanced Advanced options for http method
 * @param {*} o.advanced.send Data to send.
 * @param {String} o.advanced.method Which http method to use: 'GET' or 'POST'.
 * @param {String} o.advanced.user Username, is used in authorization
 * @param {String} o.advanced.password Password, is used in authorization
 *
 * @function fileCopyToHardDriveAct
 * @class wFileProviderHttp
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function fileCopyToHardDrive( o )
{
  let self = this;

  if( _.strIs( o ) )
  {
    let filePath = self.path.join( self.path.realMainDir( ), self.path.name({ path : o, full : 1 }) );
    o = { url : o, filePath };
  }
  else
  {
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( o.url ), 'fileCopyToHardDrive :', 'Expects {-o.filePath-}' );
    _.assert( _.strIs( o.filePath ), 'fileCopyToHardDrive :', 'Expects {-o.filePath-}' );

    let HardDrive = _.FileProvider.HardDrive();
    let dirPath = self.path.dir( o.filePath );
    let stat = HardDrive.statResolvedRead({ filePath : dirPath, throwing : 0 });
    if( !stat )
    {
      try
      {
        HardDrive.dirMake({ filePath : dirPath, recursive : 1 })
      }
      catch( err )
      {
      }
    }

  }

  return self.fileCopyToHardDriveAct( o );
}

var defaults = fileCopyToHardDrive.defaults = Object.create( Parent.prototype.fileReadAct.defaults );

defaults.url = null;

fileCopyToHardDrive.advanced =
{
  send : null,
  method : 'GET',
  user : null,
  password : null,

}

// --
// encoders
// --

let WriteEncoders = {};

WriteEncoders[ 'buffer.raw' ] =
{

  onBegin : function( e )
  {
    e.operation.encoding = null;
  },

}

WriteEncoders[ 'buffer.node' ] =
{

  onBegin : function( e )
  {
    e.operation.encoding = null;
  },

}

WriteEncoders[ 'blob' ] =
{

  onBegin : function( e )
  {
    throw _.err( 'not tested' );
    e.operation.encoding = 'blob';
  },

}

WriteEncoders[ 'document' ] =
{

  onBegin : function( e )
  {
    throw _.err( 'not tested' );
    e.operation.encoding = 'document';
  },

}

WriteEncoders[ 'buffer.bytes' ] =
{

  responseType : 'arraybuffer',

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'buffer.bytes' );
  },

  onEnd : function( e )
  {
    let result = _.bufferBytesFrom( e.data );
    return result;
  },

}

fileReadAct.encoders = WriteEncoders;

// --
// relations
// --

/**
 * @typedef {Object} Fields
 * @param {Boolean} safe=0
 * @param {Boolean} stating=0
 * @param {String[]} protocols=[ 'http', 'https' ]
 * @param {Boolean} resolvingSoftLink=0
 * @param {Boolean} resolvingTextLink=0
 * @param {Boolean} usingSoftLink=0
 * @param {Boolean} usingTextLink=0
 * @param {Boolean} usingGlobalPath=1
 * @class wFileProviderHttp
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

let Composes =
{

  safe : 0,
  protocols : _.define.own([ 'http', 'https' ]),

  resolvingSoftLink : 0,
  resolvingTextLink : 0,
  usingSoftLink : 0,
  usingTextLink : 0,
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
  Path : _.weburi.CloneExtending({ fileProvider : Self }),
}

// --
// declare
// --

let Extension =
{

  init,

  // read

  streamReadAct,
  fileReadAct,

  // write

  filesReflectSingle,

  // special

  fileCopyToHardDriveAct,
  fileCopyToHardDrive,

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

//

if( typeof module === 'undefined' )
if( !_.FileProvider.Default )
_.FileProvider.Default = Self;

_.FileProvider[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})( );

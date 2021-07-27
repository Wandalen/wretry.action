( function _Imap_ss_()
{

'use strict';

let Imap;

if( typeof module !== 'undefined' )
{
  Imap = require( 'imap-simple' );
}

const _global = _global_;
const _ = _global_.wTools;
const Abstract = _.FileProvider.Abstract;
const Partial = _.FileProvider.Partial;
const Find = _.FileProvider.FindMixin;

_.assert( _.routineIs( _.files.FileRecord ) );
_.assert( _.routineIs( Abstract ) );
_.assert( _.routineIs( Partial ) );
_.assert( !!Find );
_.assert( !_.FileProvider.Imap );

//

/**
 * @classdesc Imap files provider.
 * @class wFileProviderImap
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

const Parent = Partial;
const Self = wFileProviderImap;
function wFileProviderImap( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Imap';

// --
// inter
// --

function init( o )
{
  let self = this;
  Parent.prototype.init.call( self, o );
  self.ready = _.Consequence();
  self.form();
}

//

function form()
{
  let self = this;
  let path = self.path;

  _.assert( _.strDefined( self.login ) );
  _.assert( _.strDefined( self.password ) );
  _.assert( _.strDefined( self.hostUri ) );

  if( !path.isGlobal( self.hostUri ) )
  self.hostUri = '://' + self.hostUri;

  let parsed = path.parse( self.hostUri );
  let config =
  {
    imap :
    {
      user : self.login,
      password : self.password,
      host : parsed.host,
      port : parsed.port || 993,
      tls : self.tls,
      authTimeout : self.authTimeOut,
    }
  };

  let error = null;
  for( let i = 0 ; i < self.authRetryLimit ; i++ )
  {
    let provider = connect()
    .deasync()
    .sync();
    if( provider )
    return provider;
  }

  throw _.err( error, 'Cannot connect to server' );

  /* */

  function connect()
  {
    return _.Consequence.Try( () => Imap.connect( config ) )
    .then( function( connection )
    {
      self._connection = connection;
      self.ready.take( connection );
      return connection;
    })
    .catch( ( err ) =>
    {
      error = _.err( err );
      error = _.errOnce( error );
      _.errAttend( error );
      return null;
    })
  }
}

// function form()
// {
//   let self = this;
//   let path = self.path;
//
//   _.assert( _.strDefined( self.login ) );
//   _.assert( _.strDefined( self.password ) );
//   _.assert( _.strDefined( self.hostUri ) );
//
//   if( !path.isGlobal( self.hostUri ) )
//   self.hostUri = '://' + self.hostUri;
//
//   let parsed = path.parse( self.hostUri );
//   let config =
//   {
//     imap :
//     {
//       user : self.login,
//       password : self.password,
//       host : parsed.host,
//       port : parsed.port || 993,
//       tls : self.tls,
//       authTimeout : self.authTimeOut,
//     }
//   };
//
//   return _.Consequence.Try( () => Imap.connect( config ) )
//   .then( function( connection )
//   {
//     self._connection = connection;
//     self.ready.take( connection );
//     return connection;
//   })
//   .catch( ( err ) =>
//   {
//     err = _.err( err );
//     self.ready.error( err );
//     throw err;
//   });
//
// }

//

function unform()
{
  let self = this;
  // let a = self._connection.imap.closeBox( true );
  self._connection.end();
  return self;
}

// --
// path
// --

/**
 * @summary Return path to current working directory.
 * @description Changes current path to `path` if argument is provided.
 * @param {String} [path] New current path.
 * @function pathCurrentAct
 * @class wFileProviderImap
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
 * @class wFileProviderImap
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function pathResolveSoftLinkAct( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.path.isAbsolute( o.filePath ) );
  _.assert( 0, 'not implemented' );

}

_.routineExtend( pathResolveSoftLinkAct, Parent.prototype.pathResolveSoftLinkAct )

//

function pathParse( filePath )
{
  let self = this;
  let path = self.path;
  let result = Object.create( null );

  result.originalPath = filePath;
  result.unabsolutePath = path.unabsolute( filePath );
  result.dirPath = path.dir( result.originalPath );
  result.fullName = path.fullName( filePath );

  result.isTerminal = _.strInsideOf( result.fullName, '<', '>' );
  result.stripName = result.isTerminal ? result.isTerminal : result.fullName;
  result.isTerminal = !!result.isTerminal;

  return result;
}

//

function _pathDirNormalize( srcPath )
{
  let self = this;
  let path = self.path;

  return srcPath.split( path.upToken ).join( path.hereToken );
}

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
 * @class wFileProviderImap
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function fileReadAct( o )
{
  let self = this;
  let path = self.path;
  let ready = self.ready.split();
  let result = null;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( fileReadAct, o );
  _.assert( _.strIs( o.encoding ) );
  // o.advanced = _.routine.options_( null, o.advanced || Object.create( null ), fileReadAct.advanced );
  o.advanced = _.mapSupplementAssigning( o.advanced || Object.create( null ), fileReadAct.advanced );
  _.map.assertHasOnly( o.advanced, fileReadAct.advanced );

  let parsed = self.pathParse( o.filePath );
  parsed.dirPath = path.unabsolute( parsed.dirPath );

  if( !parsed.isTerminal )
  throw _.err( `${ o.filePath } is not a terminal` );

  let attachments;
  if( o.advanced.withTail )
  attachments = self.attachmentsGet
  ({
    filePath : o.filePath,
    decoding : 1,
    sync : 1,
  });

  ready.then( () => _read() );
  ready.then( () =>
  {
    if( o.advanced.withTail && attachments && attachments.length > 0 );
    result.attachments = attachments;

    if( o.encoding === 'map' )
    return result;

    if( o.advanced.withHeader && o.advanced.withBody && o.advanced.withTail )
    {
      result = result.parts[ result.parts.length - 1 ].body;
    }
    else
    {
      let message = '{\n';
      if( o.advanced.withHeader )
      {
        if( _.props.keys( result.header ).length > 0 )
        message += '"header" : ' + _.entity.exportJson( result.header ) + ',\n';
      }
      if( o.advanced.withBody )
      {
        let bodyArray = result.parts.filter( ( e ) => e.which === 'TEXT' );
        if( bodyArray[ 0 ].body )
        message += '"body" : ' + _.entity.exportJson( bodyArray[ 0 ].body ) + ',\n';
      }
      if( o.advanced.withTail )
      {
        if( result.attachments.length > 0 )
        message += '"attachments" : ' + _.entity.exportJson( result.attachments ) + '\n';
      }

      if( _.strEnds( message, ',\n' ) )
      message = _.strReplaceEnd( message, ',\n', '\n' );
      message += '}';

      result = message;
    }

    if( o.encoding === 'buffer.raw' )
    {
      result = _.bufferBytesFrom( result ).buffer;
    }
    else if( !( o.encoding === 'utf8' ) && !( o.encoding === 'meta.original' ) )
    {
      try
      {
        result = BufferNode.from( result, o.encoding ).toString( 'utf8' );
      }
      catch( err )
      {
        _.errAttend( err );
        throw _.err( 'Unknown encoding', err );
      }
    }

    return result;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function _read()
  {
    let mailbox = self._pathDirNormalize( parsed.dirPath );
    return self._connection.openBox( mailbox ).then( function ( extra ) /* xxx : need to close? */
    {
      let searchCriteria = [ `${parsed.stripName}` ];
      let bodies = [];

      if( o.advanced.withHeader )
      bodies.push( 'HEADER' );
      if( o.advanced.withBody )
      bodies.push( 'TEXT' );
      // if( o.advanced.withTail )
      bodies.push( '' );

      let fetchOptions =
      {
        bodies,
        struct : !!o.advanced.structing,
        markSeen : false,
      };
      return self._connection.search( searchCriteria, fetchOptions ).then( function( messages )
      {
        _.assert( messages.length >= 1, 'Terminal does not exist' );
        _.assert( messages.length <= 1, 'There are several such terminals' );
        result = messages[ 0 ];
        resultHandle( result );
        self._connection.closeBox( parsed.dirPath );
      });
    });
  }

  /* */

  function resultHandle( result )
  {
    if( o.advanced.withHeader )
    {
      result.header = Object.create( null );
      let headers = result.parts.filter( ( e ) => e.which === 'HEADER' );
      headers.forEach( ( header ) =>
      {
        _.props.extend( result.header, header.body );
      });
    }
  }

}

_.routineExtend( fileReadAct, Parent.prototype.fileReadAct );

fileReadAct.advanced =
{
  withHeader : 1,
  withBody : 1,
  withTail : 1,
  structing : 1,
}

//

function attachmentsGet( o )
{
  let self = this;
  let path = self.path;
  let result = null;
  let conWithdata;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( attachmentsGet, o );

  let parsed = self.pathParse( o.filePath );
  parsed.dirPath = path.unabsolute( parsed.dirPath );
  let mailbox = self._pathDirNormalize( parsed.dirPath );

  if( !parsed.isTerminal )
  throw _.err( `${ o.filePath } is not a terminal` );

  let ready = _attachmentsGet();
  ready.then( () => result );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function _attachmentsGet()
  {
    let ready = _.take( null );

    if( !self.fileExists( o.filePath ) )
    return ready.take( null );

    return ready.give( attachmentGetFromBox )
    .then( () =>
    {
      self._connection.closeBox( mailbox );
      return null;
    });
  }

  /* */

  function attachmentGetFromBox()
  {
    let con = this;

    self._connection.openBox( mailbox )
    .then( ( extra ) =>
    {
      let searchCriteria = [ `${ parsed.stripName }` ];
      let bodies = [ '' ];

      let fetchOptions =
      {
        bodies,
        struct : true,
        markSeen : false,
      };

      return self._connection.search( searchCriteria, fetchOptions )
      .then( ( messages ) =>
      {
        _.assert( messages.length === 1, 'Expects single message.' );

        let message = messages[ 0 ];
        result = messageStructFilter( message.attributes.struct );

        /* */

        let con2 = replacePartsByAttachments( result, message );
        con.take( con2 );
      })
    });
  }

  /* */

  function messageStructFilter( msgs )
  {
    return _.filter_( null, msgs, ( e ) =>
    {
      if( _.arrayIs( e ) )
      e = e[ 0 ];
      if( e.disposition && e.disposition.type )
      if( _.longHasAny( [ 'INLINE', 'ATTACHMENT' ], e.disposition.type.toUpperCase() ) )
      return e;
    });
  }

  /* */

  function replacePartsByAttachments( parts, message )
  {
    let con = new _.Consequence().take( null );
    for( let i = 0 ; i < parts.length ; i++ )
    {
      con.then( () =>
      {
        conWithdata = new _.Consequence();
        attachmentDataGet( message, parts[ i ] );
        return conWithdata;
      })
      .then( ( data ) =>
      {
        let attachment = Object.create( null );
        attachment.fileName = parts[ i ].disposition.params.filename;

        if( o.decoding )
        {
          data = dataDecode( data, o.encoding );
          attachment.encoding = o.encoding;
          attachment.size = data.length;
        }
        else
        {
          attachment.encoding = parts[ i ].encoding;
          attachment.size = parts[ i ].size;
        }

        attachment.data = data;

        parts[ i ] = attachment;
        return data;
      })
    }

    return con;
  }

  /* */

  function attachmentDataGet( message, part )
  {
    self._connection.getPartData( message, part )
    .then( ( data ) => conWithdata.take( data ) );
  }

  /* */

  function dataDecode( data, encoding )
  {
    _.assert( BufferNode.isEncoding( encoding ), 'Unknown encoding' );
    return BufferNode.from( data ).toString( encoding );
  }

}

attachmentsGet.defaults =
{
  sync : 1,
  filePath : null,

  decoding : 0,
  encoding : 'utf8',
};

//

function dirReadAct( o )
{
  let self = this;
  let path = self.path;
  let ready = self.ready.split();
  let result;

  _.routine.assertOptions( dirReadAct, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.path.isNormalized( o.filePath ) );

  ready.then( () => self._connection.getBoxes() );
  ready.then( ( map ) =>
  {
    result = filter( map );
    return result;
  });

  ready.then( () => _mailsRead( o.filePath ) );
  ready.then( () => result );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function _mailsRead( filePath )
  {
    if( result === null )
    return result;
    if( filePath === '/' )
    return result;

    filePath = path.unabsolute( filePath );
    filePath = self._pathDirNormalize( filePath );
    return self._connection.openBox( filePath ).then( function( extra ) /* xxx : need to close? */
    {
      let searchCriteria = [ 'ALL' ];
      let fetchOptions =
      {
        bodies : [ 'HEADER' ],
        struct : false,
        markSeen : false,
      };
      return self._connection.search( searchCriteria, fetchOptions ).then( function( messages )
      {
        messageEachCheckAndAppend( messages );
        self._connection.closeBox( filePath );
      });
    });

  }

  /* */

  function messageEachCheckAndAppend( messages )
  {
    messages.forEach( function( message, k )
    {
      let mid = message.attributes.uid;
      _.assert( _.numberIs( mid ) );
      _.arrayAppendOnceStrictly( result, '<' + String( mid ) + '>' );
    });
  }

  /* */

  function filter( map )
  {
    if( o.filePath === path.rootToken )
    return _.props.keys( map );
    let isAbsolute = path.isAbsolute( o.filePath );

    let filePath = path.unabsolute( o.filePath );
    filePath = filePath.split( '/' )
    .map( ( e, k ) => `${e}/children` )
    .join( '/' );

    if( isAbsolute )
    filePath = path.absolute( filePath );

    let result = _.select( map, filePath );
    if( result === null )
    return [];
    if( !result )
    return null;
    return _.props.keys( result );
  }

  /* */

}

_.routineExtend( dirReadAct, Parent.prototype.dirReadAct );

// --
// read stat
// --

function statReadAct( o )
{
  let self = this;
  let path = self.path;
  let parsed = self.pathParse( o.filePath );
  let stat;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( statReadAct, o );

  /* */

  let result = _statReadAct();

  if( o.sync )
  {
    if( _.consequenceIs( result ) )
    {
      result.deasync();
      return result.sync();
    }
  }
  else
  {
    if( !_.consequenceIs( result ) )
    return new _.Consequence().take( result );
  }

  return result;

  /* */

  function _statReadAct()
  {
    stat = null;
    let throwing = 0;
    let sync = 1;

    if( parsed.isTerminal )
    {
      let files = self.dirRead({ filePath : parsed.dirPath, throwing, sync });
      if( files === null || !_.longHas( files, parsed.fullName ) )
      {
        if( o.throwing )
        throw _.err( `File ${o.filePath} does not exist` );
        return null;
      }
      let advanced =
      {
        withHeader : 1,
        withBody : 0,
        withTail : 0,
        structing : 0,
      }
      let o2 = _.props.supplement( { filePath : o.filePath, advanced, throwing, sync, encoding : 'map' }, self.fileReadAct.defaults );
      let read = self.fileRead( o2 );
      stat = statMake();
      stat.isFile = returnTrue;
      stat.atime = read.attributes.date;
      stat.size = read.parts[ 1 ].size >= 0 ? read.parts[ 1 ].size : null;
    }
    else
    {
      stat = statMake();
      stat.isDirectory = returnTrue;
      stat.isDir = returnTrue;
      let ready = _.Consequence.From( _dirRead() );
      ready.finally( ( err, arg ) =>
      {
        if( err )
        {
          if( o.throwing )
          throw _.err( err );
          _.errAttend( err );
          return null;
        }
        return arg;
      })
      return ready;
    }

    return stat;
  }

  /* */

  function _dirRead()
  {
    return self.ready.split()
    .give( function()
    {
      let con = this;
      let dirPath = self._pathDirNormalize( parsed.unabsolutePath );

      self._connection.openBox( dirPath )
      .then( ( extra ) => /* xxx : need to close? */
      {
        result.extra = extra;
        self._connection.closeBox( dirPath );
        con.take( stat );
      })
      .catch( ( err ) =>
      {
        con.error( _.err( err ) );
      });
    });
    // .then( () =>
    // {
    //   return result;
    // });
  }

  /* */

  function statMake()
  {
    let result = new _.files.FileStat();

    // if( self.extraStats && self.extraStats[ filePath ] )
    // {
    //   let extraStat = self.extraStats[ filePath ];
    //   result.atime = new Date( extraStat.atime );
    //   result.mtime = new Date( extraStat.mtime );
    //   result.ctime = new Date( extraStat.ctime );
    //   result.birthtime = new Date( extraStat.birthtime );
    //   result.ino = extraStat.ino || null;
    //   result.dev = extraStat.dev || null;
    // }

    result.filePath = o.filePath;
    result.isTerminal = returnFalse;
    result.isDir = returnFalse;
    result.isTextLink = returnFalse;
    result.isSoftLink = returnFalse;
    result.isHardLink = returnFalse;
    result.isDirectory = returnFalse;
    result.isFile = returnFalse;
    result.isSymbolicLink = returnFalse;
    result.nlink = 1;

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

  /* */

}

_.routineExtend( statReadAct, Parent.prototype.statReadAct );

//

function fileExistsAct( o )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( self.path.isNormalized( o.filePath ) );

  let exists = self.statReadAct
  ({
    filePath : o.filePath,
    sync : 1,
    throwing : 0,
    resolvingSoftLink : 0,
  });
  return !!exists;
}

_.routineExtend( fileExistsAct, Parent.prototype.fileExistsAct );

// --
// write
// --

function fileWriteAct( o )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( fileWriteAct, o );
  _.assert( self.path.isNormalized( o.filePath ) );
  _.assert( self.WriteMode.indexOf( o.writeMode ) !== -1 );
  // o.advanced = _.routine.options_( null, o.advanced || Object.create( null ), fileWriteAct.advanced );
  o.advanced = _.mapSupplementAssigning( o.advanced || Object.create( null ), fileWriteAct.advanced );
  _.map.assertHasOnly( o.advanced, fileWriteAct.advanced );

  /* data conversion */

  if( _.bufferTypedIs( o.data ) && !_.bufferBytesIs( o.data ) || _.bufferRawIs( o.data ) )
  o.data = _.bufferNodeFrom( o.data );

  _.assert( _.strIs( o.data ) || _.bufferNodeIs( o.data ) || _.bufferBytesIs( o.data ), 'Expects string or node buffer, but got', _.entity.strType( o.data ) );

  /* write */

  let result = _fileWrite();

  if( o.sync )
  {
    result.deasync();
    return result.sync();
  }

  return result;

  /* */

  function _fileWrite()
  {
    return self.ready.split()
    .give( function()
    {
      let con = this;
      let parsed = self.pathParse( o.filePath );

      if( parsed.fullName !== '<$>' )
      return con.error( _.err( 'Cannot write file with defined filename. Please, use name <$> instead.' ) );

      if( o.writeMode === 'rewrite' )
      {
        let dirPath = path.unabsolute( parsed.dirPath );
        let mailbox = self._pathDirNormalize( dirPath );

        let o2 = Object.create( null );
        o2.mailbox = mailbox;
        if( o.advanced.flag !== null )
        o2.flags = o.advanced.flags;

        self._connection.append( o.data, o2 )
        .then( ( etra ) =>
        {
          con.take( true );
        })
        .catch( ( err ) =>
        {
          con.error( _.err( err ) );
        })
      }
      else
      {
        con.error( _.err( `Not implemented write mode ${ o.writeMode }` ) );
      }
    });
  }

}

fileWriteAct.advanced =
{
  flags : null,
};

_.routineExtend( fileWriteAct, Parent.prototype.fileWriteAct );

//

function fileDeleteAct( o )
{
  let self = this;
  let path = self.path;
  let parsed = self.pathParse( o.filePath );

  _.routine.assertOptions( fileDeleteAct, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( path.isNormalized( o.filePath ) );

  let result = _fileDelete();

  if( o.sync )
  {
    result.deasync();
    return result.sync();
  }

  return result;

  /* */

  function _fileDelete()
  {
    let con = new _.Consequence();
    let stat = self.statReadAct
    ({
      filePath : o.filePath,
      sync : 1,
      throwing : 0,
      resolvingSoftLink : 0
    });
    let mailbox = path.unabsolute( parsed.isTerminal ? parsed.dirPath : parsed.originalPath );
    mailbox = self._pathDirNormalize( mailbox );

    if( stat && stat.isDir() )
    {
      if( _.longHas( [ '.', 'Drafts', 'INBOX', 'Junk', 'Sent', 'Trash' ], mailbox ) )
      throw _.err( 'Unable to delete builtin directory.' );

      let deletedList = [ mailbox ];

      /* Dmytro : server can't delete directories with subdirectories directly, paths list creates iterative */
      let dirQueue = [ o.filePath ];
      while( dirQueue.length > 0 )
      {
        let dirs = self.dirRead({ filePath : dirQueue[ 0 ], throwing : 0, sync : 1 });
        dirs = dirs.filter( ( e ) => !_.strInsideOf( e, '<', '>' ) );
        dirQueue.push( ... dirs.map( ( e ) => `${ dirQueue[ 0 ] }/${ e }` ) );

        let mailboxPath = path.unabsolute( dirQueue[ 0 ] );
        mailboxPath = self._pathDirNormalize( mailboxPath );
        deletedList.push( ... dirs.map( ( e ) => `${ mailboxPath }.${ e }` ) );

        dirQueue.shift();
      }

      let ready = new _.Consequence().take( null );
      for( let i = deletedList.length - 1 ; i >= 0 ; i-- )
      ready.then( () => self._connection.delBox( deletedList[ i ] ) );

      con.take( ready );
    }
    else
    {
      let files = self.dirRead({ filePath : parsed.dirPath, sync : 1, throwing : 0 });

      if( !_.longHas( files, parsed.fullName ) )
      return con.error( _.err( `File ${ parsed.originalPath } does not exists.` ) );

      self._connection.openBox( mailbox )
      .then( () =>
      {
        self._connection.deleteMessage( parsed.stripName )
        .then( () =>
        {
          self._connection.closeBox( mailbox );
          con.take( null );
        })
        .catch( ( err ) =>
        {
          con.error( _.err( err ) );
        })
      })
      .catch( ( err ) =>
      {
        con.error( _.err( err ) );
      })
    }

    return con;
  }
}

_.routineExtend( fileDeleteAct, Parent.prototype.fileDeleteAct );

//

function dirMakeAct( o )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( dirMakeAct, o );
  _.assert( self.path.isNormalized( o.filePath ) );

  let ready = _dirMake();

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function _dirMake()
  {
    let con = new _.Consequence();
    let parsed = self.pathParse( o.filePath );

    if( parsed.isTerminal )
    return con.error( 'Path to directory should have not name of terminal file.' );

    let dirPath = self._pathDirNormalize( parsed.unabsolutePath );

    self._connection.addBox( dirPath )
    .then( () => /* xxx : need to close? */
    {
      con.take( null );
    })
    .catch( ( err ) =>
    {
      con.error( _.err( err ) );
    });

    return con;
  }
}

_.routineExtend( dirMakeAct, Parent.prototype.dirMakeAct );

// --
// linkingAction
// --

function fileRenameAct( o )
{
  let self = this;
  let ready = new _.Consequence();

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( fileRenameAct, arguments );
  _.assert( self.path.isNormalized( o.srcPath ) );
  _.assert( self.path.isNormalized( o.dstPath ) );

  let result = new _.Consequence().take( null );
  result.then( () => _fileRename() );

  if( o.sync )
  {
    result.deasync();
    return result.sync();
  }

  return result;

  /* */

  function _fileRename()
  {
    let srcParsed = self.pathParse( o.srcPath );
    if( srcParsed.isTerminal )
    return ready.error( _.err( '{-o.srcPath-} should be path to directory.' ) );
    if( _.longHas( [ '.', 'Drafts', 'INBOX', 'Junk', 'Sent', 'Trash' ], srcParsed.unabsolutePath ) )
    return ready.error( _.err( 'Unable to rename builtin directory.' ) );
    let dstParsed = self.pathParse( o.dstPath );
    if( dstParsed.isTerminal )
    return ready.error( _.err( '{-o.dstPath-} should be path to directory.' ) );

    let srcPath = self._pathDirNormalize( srcParsed.unabsolutePath );
    let dstPath = self._pathDirNormalize( dstParsed.unabsolutePath );

    self._connection.imap.renameBox( srcPath, dstPath, handleErr );

    return ready;
  }

  function handleErr( err )
  {
    if( err )
    ready.error( _.err( err ) );
    else
    ready.take( true );
  }
}

_.routineExtend( fileRenameAct, Parent.prototype.fileRenameAct );

//

function fileCopyAct( o )
{
  let self = this;
  let path = self.path;
  let ready = new _.Consequence();

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( fileCopyAct, arguments );
  _.assert( path.isNormalized( o.srcPath ) );
  _.assert( path.isNormalized( o.dstPath ) );

  let srcParsed = self.pathParse( o.srcPath );
  let dstParsed = self.pathParse( o.dstPath );

  let result = new _.Consequence().take( null );
  result.then( () => _fileCopy() );

  if( o.sync )
  {
    result.deasync();
    return result.sync();
  }

  return result;

  /* */

  function _fileCopy()
  {

    if( !srcParsed.isTerminal )
    return ready.error( _.err( '{-o.srcPath-} should be path to terminal file.' ) );

    if( dstParsed.fullName !== '<$>' )
    return ready.error( _.err( '{-o.dstPath-} should be path to file with name <$>.' ) );

    let srcPath = path.unabsolute( srcParsed.dirPath );
    srcPath = self._pathDirNormalize( srcPath );
    let dstPath = path.unabsolute( dstParsed.dirPath );
    dstPath = self._pathDirNormalize( dstPath );
    let msgId = _.array.as( srcParsed.stripName );

    self._connection.openBox( srcPath )
    .then( () =>
    {
      self._connection.imap.copy( msgId, dstPath, handle );
    })

    ready.finally( ( err, arg ) =>
    {
      if( err )
      throw _.err( err );

      o.context.options.dstPath = self.pathUnmock( o.dstPath );
      return arg;
    });

    return ready;
  }

  function handle( err )
  {
    if( err )
    ready.error( _.err( err ) );
    else
    ready.take( true );
  }

}

_.routineExtend( fileCopyAct, Parent.prototype.fileCopyAct );

//

function _fileCopyPrepare( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single options map {-o-}.' );
  _.routine.options_( _fileCopyPrepare, o );

  let read = o.srcProvider.system.fileRead({ filePath : o.options.srcPath, encoding : 'utf8', sync : 1 });

  if( o.srcProvider instanceof _.FileProvider.Imap || !o.srcProvider )
  {
    _.assert( !!o.dstProvider, 'Expects destination provider {-dstProvider-}.' );

    let numberOfLines = _.strLinesCount( read );
    if( numberOfLines === 1 )
    {
      o.data = BufferNode.from( read, 'base64' );
      o.data = _.bufferBytesFrom( o.data );
      o.options.context.srcResolvedStat.size = o.options.context.srcStat.size = o.data.length;
    }
  }
  else if( o.srcProvider instanceof _.FileProvider.Abstract )
  {
    _.assert( !o.dstProvider || o.dstProvider instanceof _.FileProvider.Imap, 'Expects provider Imap {-o.dstProvider-}.' );

    let parsed = self.pathParse( o.options.srcPath );
    if( !parsed.isTerminal )
    {
      o.data = BufferNode.from( read ).toString( 'base64' );
      o.options.context.srcResolvedStat.size = o.options.context.srcStat.size = o.data.length;
    }
  }
  else
  {
    _.assert( 0, 'Unknown instance of file provider {-o.srcProvider-}.' );
  }

  return o.data;
}

_fileCopyPrepare.defaults =
{
  srcProvider : null,
  dstProvider : null,
  options : null,
  data : null,
};

//

function softLinkAct( o )
{
  let self = this;

  _.routine.assertOptions( softLinkAct, arguments );
  _.assert( self.path.is( o.srcPath ) );
  _.assert( self.path.isAbsolute( o.dstPath ) );
  _.assert( self.path.isNormalized( o.srcPath ) );
  _.assert( self.path.isNormalized( o.dstPath ) );

  _.assert( 0, 'not implemented' );

}

_.routineExtend( softLinkAct, Parent.prototype.softLinkAct );

//

function hardLinkAct( o )
{
  let self = this;

  _.routine.assertOptions( hardLinkAct, arguments );
  _.assert( self.path.isNormalized( o.srcPath ) );
  _.assert( self.path.isNormalized( o.dstPath ) );
  _.assert( 0, 'not implemented' );

}

_.routineExtend( hardLinkAct, Parent.prototype.hardLinkAct );

// --
// link
// --

function hardLinkBreakAct( o )
{
  let self = this;
  let descriptor = self._descriptorRead( o.filePath );

  _.assert( 0, 'not implemented' );

}

_.routineExtend( hardLinkBreakAct, Parent.prototype.hardLinkBreakAct );

//

function areHardLinkedAct( o )
{
  let self = this;

  _.routine.assertOptions( areHardLinkedAct, arguments );
  _.assert( o.filePath.length === 2, 'Expects exactly two arguments' );
  _.assert( self.path.isNormalized( o.filePath[ 0 ] ) );
  _.assert( self.path.isNormalized( o.filePath[ 1 ] ) );

  if( o.filePath[ 0 ] === o.filePath[ 1 ] )
  return true;
  return false;
}

_.routineExtend( areHardLinkedAct, Parent.prototype.areHardLinkedAct );

//

function pathMock( path, global )
{
  let self = this;

  let parsed = self.pathParse( path );
  return self.path.join( parsed.dirPath, '<$>' );
}

//

function pathUnmock( path, global )
{
  let self = this;

  let parsed = self.pathParse( path );
  if( !parsed.isTerminal )
  return;

  let prefix = global ? self.originPath : '';
  let files = self.dirReadAct({ filePath : parsed.dirPath, sync : 1 });
  return self.path.join( prefix + parsed.dirPath, files[ files.length - 1 ] );
}

// --
// relations
// --

let Composes =
{

  protocols : _.define.own( [ 'imap' ] ),

  login : null,
  password : null,
  hostUri : null,
  authTimeOut : 5000, /* 5000 */
  authRetryLimit : 3,
  tls : true,
  // tls : false,
  safe : 0,
  pathMocking : 1,

}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
  ready : null,
  _connection : null,
  _currentPath : null,
  _formed : 0,
}

let Accessors =
{
}

let Statics =
{
  Path : _.uri.CloneExtending({ fileProvider : Self }),
  SupportsLinks : 0,
}

// --
// declare
// --

let Extension =
{

  // inter

  init,
  form,
  unform,

  // path

  pathCurrentAct,
  pathResolveSoftLinkAct,
  pathParse,
  _pathDirNormalize,

  // read

  fileReadAct,
  attachmentsGet,
  dirReadAct,
  streamReadAct : null,
  statReadAct,
  fileExistsAct,

  // write

  fileWriteAct,
  timeWriteAct : null,
  fileDeleteAct,
  dirMakeAct,
  streamWriteAct : null,

  // linkingAction

  fileRenameAct,
  fileCopyAct,
  _fileCopyPrepare,
  softLinkAct,
  hardLinkAct,

  hardLinkBreakAct,
  areHardLinkedAct,

  //

  pathMock,
  pathUnmock,

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

_.FileProvider[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

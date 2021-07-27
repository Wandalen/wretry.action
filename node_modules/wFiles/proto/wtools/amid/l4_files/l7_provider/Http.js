( function _Http_js_()
{

'use strict';

// if( typeof module !== 'undefined' )
// {
//   const _ = require( '../../../../node_modules/Tools' );
//   if( !_.FileProvider )
//   require( '../UseMid.s' );
// }

//

/**
 @classdesc Class to transfer data over http protocol using GET/POST methods. Implementation for a browser.
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

/**
 * @summary Return path to current working directory.
 * @description Changes current path to `path` if argument is provided.
 * @param {String} [path] New current path.
 * @function pathCurrentAct
 * @class wFileProviderHttp
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
 * @summary Returns stats object for a remote resource `o.filePath`.
 * @description Changes current path to `path` if argument is provided.
 * @param {Object} o Options map.
 * @param {Object} o.filePath Url of a resource.
 * @param {String} o.sync Determines how to read a file, synchronously or asynchronously.
 * @param {String} o.throwing Controls error throwing. Returns null if disabled and error occurs.
 * @param {Boolean} o.resolvingSoftLink Enable resolving of soft links.
 * @function statReadAct
 * @class wFileProviderHttp
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

function statReadAct( o )
{
  let self = this;
  let result = new _.files.FileStat();
  let con;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.assertOptions( statReadAct, arguments );

  /* */

  function errorGive( err )
  {
    result = null;
    if( o.throwing )
    {
      err = _.err( err );
      if( con )
      con.error( err );
      else
      throw err
    }
    return null;
  }

  /* */

  function fileSizeGet()
  {

    let request = new XMLHttpRequest();
    request.open( 'HEAD', o.filePath, !o.sync );
    request.onreadystatechange = function( e )
    {

      if( this.status !== 200 )
      {
        return errorGive( '#' + this.status + ' : ' + this.statusText );
      }

      // if( this.readyState == this.DONE )
      if( this.readyState === this.DONE )
      {
        let size = parseInt( request.getResponseHeader( 'Content-Length' ) );
        result.size = size;
        if( con )
        con.take( result );
      }
    }
    request.send();
  }

  /* */

  function getFileStat()
  {
    result.isFile = function() { return true; };
    result.isDir = function() { return false; };
    try
    {
      fileSizeGet();
    }
    catch( err )
    {
      return errorGive( err );
    }
    return result;
  }

  /* */

  if( o.sync )
  {
    return getFileStat( o.filePath );
  }
  else
  {
    con = new _.Consequence();
    getFileStat( o.filePath );
    return con;
  }

}

statReadAct.defaults = Object.create( Parent.prototype.statReadAct.defaults );
statReadAct.having = Object.create( Parent.prototype.statReadAct.having );

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
  let con = _.Consequence();
  let Reqeust, request, total, result;

  _.routine.assertOptions( fileReadAct, arguments );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.filePath ), 'fileReadAct :', 'Expects {-o.filePath-}' );
  _.assert( _.strIs( o.encoding ), 'fileReadAct :', 'Expects {-o.encoding-}' );

  o.encoding = o.encoding.toLowerCase();
  let encoder = fileReadAct.encoders[ o.encoding ];

  /* advanced */

  o.advanced = _.routine.options_( fileReadAct, o.advanced || {}, fileReadAct.advanced );
  o.advanced.method = o.advanced.method.toUpperCase();

  /* http request */

  if( typeof XMLHttpRequest !== 'undefined' )
  Reqeust = XMLHttpRequest;
  else if( typeof ActiveXObject === 'undefined' )
  throw _.err( 'not implemented' );
  else
  Reqeust = new ActiveXObject( 'Microsoft.XMLHTTP' );
  // if( typeof XMLHttpRequest !== 'undefined' )
  // Reqeust = XMLHttpRequest;
  // else if( typeof ActiveXObject !== 'undefined' )
  // Reqeust = new ActiveXObject( 'Microsoft.XMLHTTP' );
  // else
  // throw _.err( 'not implemented' );

  /* set */

  request = o.request = new Reqeust();

  if( !o.sync )
  request.responseType = 'text';

  request.addEventListener( 'progress', handleProgress );
  request.addEventListener( 'load', handleEnd );
  request.addEventListener( 'error', handleErrorEvent );
  request.addEventListener( 'timeout', handleErrorEvent );
  request.addEventListener( 'readystatechange', handleState );
  request.open( o.advanced.method, o.filePath, !o.sync, o.advanced.user, o.advanced.password );
  /*request.setRequestHeader( 'Content-type', 'application/octet-stream' );*/

  handleBegin();

  try
  {
    if( o.advanced && o.advanced.send !== null )
    request.send( o.advanced.send );
    else
    request.send();
  }
  catch( err )
  {
    handleError( err );
  }

  if( o.sync )
  return result;
  else
  return con;

  /* - */

  /* handler */

  function getData( response )
  {
    if( request.responseType === 'text' )
    return response.responseText || response.response;
    if( request.responseType === 'document' )
    return response.responseXML || response.response;
    return response.response;
  }

  /* begin */

  function handleBegin()
  {

    if( encoder && encoder.onBegin )
    _.sure( encoder.onBegin.call( self, { operation : o, encoder }) === undefined );

    if( !o.sync )
    if( encoder && encoder.responseType )
    request.responseType = encoder.responseType;

  }

  /* end */

  function handleEnd( e )
  {

    if( o.ended )
    return;

    try
    {

      result = getData( request );

      let context = { data : result, operation : o, encoder };
      if( encoder && encoder.onEnd )
      _.sure( encoder.onEnd.call( self, context ) === undefined );
      result = context.data

      o.ended = 1;

      con.take( result );
    }
    catch( err )
    {
      handleError( err );
    }

  }

  /* progress */

  function handleProgress( e )
  {
    console.debug( 'REMINDER : implement handleProgress' );
    /* qqq : not implemented well, please implement */
    if( e.lengthComputable )
    if( o.onProgress )
    _.Consequence.Take( o.onProgress, { progress : e.loaded / e.total, options : o });
  }

  /* error */

  function handleError( err )
  {

    o.ended = 1;

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
      err = encoder.onError.call( self, { error : err, operation : o, encoder });
    }
    catch( err2 )
    {
      console.error( err2 );
      console.error( err.toString() + '\n' + err.stack );
    }

    con.error( err );
  }

  /* error event */

  function handleErrorEvent( e )
  {
    let err = _.err( 'Network error', e );
    return handleError( err );
  }

  /* state */

  function handleState( e )
  {

    if( o.ended )
    return;

    if( this.readyState === 2 )
    {

    }
    else if( this.readyState === 3 )
    {

      let data = getData( this );
      if( !data )
      return;
      if( !total ) total = this.getResponseHeader( 'Content-Length' );
      total = Number( total ) || 1;
      if( isNaN( total ) )
      return;
      handleProgress( data.length / total, o );

    }
    else if( this.readyState === 4 )
    {

      if( o.ended )
      return;

      /*if( this.status === 200 || this.status === 0 )*/
      if( this.status === 200 )
      {

        handleEnd( e );

      }
      else if( this.status === 0 )
      {
      }
      else
      {

        handleError( '#' + this.status );

      }

    }

  }

}

fileReadAct.defaults = Object.create( Parent.prototype.fileReadAct.defaults );
fileReadAct.having = Object.create( Parent.prototype.fileReadAct.having );

var advanced = fileReadAct.advanced = Object.create( null );
advanced.send = null;
advanced.method = 'GET';
advanced.user = null;
advanced.password = null;

// --
// encoders
// --

var encoders = {};

encoders[ 'utf8' ] =
{

  responseType : 'text',
  onBegin : function( e )
  {
  },

}

encoders[ 'buffer.raw' ] =
{

  responseType : 'arraybuffer',
  onBegin : function( e )
  {
  },

}

//

encoders[ 'buffer.bytes' ] =
{

  responseType : 'arraybuffer',

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

encoders[ 'blob' ] =
{

  responseType : 'blob',
  onBegin : function( e )
  {
    throw _.err( 'not tested' );
    e.operation.encoding = 'blob';
  },

}

encoders[ 'document' ] =
{

  responseType : 'document',
  onBegin : function( e )
  {
    throw _.err( 'not tested' );
    e.operation.encoding = 'document';
  },

}

fileReadAct.encoders = encoders;

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
  stating : 0,
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
  _currentPath : '/',
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

  pathCurrentAct,
  statReadAct,
  fileReadAct,

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

// if( _.FileProvider.FindMixin )
// _.FileProvider.FindMixin.mixin( Self );
// if( _.FileProvider.Secondary )
// _.FileProvider.Secondary.mixin( Self );

//

if( Config.interpreter === 'browser' )
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

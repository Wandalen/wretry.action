( function _Agent_s_() {

'use strict';

if( typeof module !== 'undefined' )
{
  var Net = require( 'net' );
}

//

const _ = _global_.wTools;
const Parent = null;
const Self = wRemoteAgent;
function wRemoteAgent( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Agent';

// --
// inter
// --

function finit()
{
  let agent = this;
  agent.unform();
  _.Copyable.prototype.finit.call( agent );
}

//

function init( o )
{
  let agent = this;

  _.assert( arguments.length === 1 );

  _.workpiece.initFields( agent );
  Object.preventExtensions( agent );

  if( o )
  agent.copy( o );

  return agent;
}

//

function unform()
{
  let agent = this;
  let flock = agent.flock;

  agent.close();

/*
qqq : cover, please
*/

}

//

function form()
{
  let agent = this;
  let flock = agent.flock;

  _.assert( agent.flock instanceof _.remote.Flock );

  return agent._form();
}

// --
// send
// --

function send( body )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  return agent._send
  ({
    deserialized : { body },
  });

}

//

function _send( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.routineOptions( _send, arguments );
  _.mapOptionsApplyDefaults( o.deserialized, agent.Packet );
  _.assert( o.deserialized.recipient === null || _.remote.agentPathIs( o.deserialized.recipient ) );

  if( o.deserialized.recipient )
  {
    if( o.deserialized.recipient === agent.agentPath )
    {
      _.assert( flock.role === 'master' );
      agent.masterRecieveGot({ deserialized : o.deserialized });
      return;
    }
  }

  if( o.connection === null )
  o.connection = flock.connectionDefaultGet();

  if( o.serialized === null )
  {
    o.serialized = agent._serialize( o.deserialized );
  }

  o.connection.write( o.serialized );

}

_send.defaults =
{
  connection : null,
  deserialized : null,
  serialized : null,
}

//

function requestCall( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( _.remote.agentPathIs( o.recipient ) );
  _.assert( _.longIs( o.args ) );
  _.assert( _.strDefined( o.routine ) );

  if( o.context !== null )
  o.context = flock.handleFrom( o.context );
  o.object = flock.handleFrom( o.object );

  if( o.context === o.object )
  o.context = null;

  _.assert( o.context === null || flock.PrimitiveHandleIs( o.context ) );
  _.assert( flock.PrimitiveHandleIs( o.object ) );

  o.context = agent._pack({ structure : o.context });
  o.object = agent._pack({ structure : o.object });
  o.args = agent._pack({ structure : o.args });

  let body =
  {
    object : o.object,
    routine : o.routine,
    args : o.args,
    context : o.context,
  }

  return agent.request
  ({
    deserialized :
    {
      channel : 'call',
      recipient : o.recipient,
      body : body,
    },
  });

}

requestCall.defaults =
{
  recipient : null,
  object : null,
  routine : null,
  args : null,
  context : null,
}

//

function request( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  let request = agent._requestOpen( ... arguments );

  agent._send( o );

  return request;
}

request.defaults =
{
  ... _send.defaults,
}

//

function _requestOpen( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.routineOptions( _requestOpen, arguments );
  _.mapOptionsApplyDefaults( o.deserialized, agent.Packet );
  _.assert( arguments.length === 1 );
  _.assert( o.deserialized.requestId === null );

  agent.requestCounter += 1;
  let id = agent.requestCounter;
  o.deserialized.requestId = id;

  let request =
  {
    id,
    deserialized : o.deserialized,
    ready : _.Consequence(),
    status : 1,
    returned : _.undefined,
  }

  _.assert( agent.requests[ id ] === undefined );

  agent.requests[ id ] = request;

  return request;
}

_requestOpen.defaults =
{
  ... request.defaults,
}

//

function _requestClose( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.routineOptions( _requestClose, arguments );

  let request = agent.requests[ o.id ];
  _.assert( !!request, `Unknown request id ${o.id}` );
  _.assert( request.status === 1 );

  if( o.unpacked === _.undefined )
  o.unpacked = agent._unpack({ structure : o.packed });

  request.unpacked = o.unpacked;
  request.packed = o.packed;
  request.status = 2;
  request.ready.take( o.unpacked );

  delete agent.requests[ o.id ];

  return request;
}

_requestClose.defaults =
{
  id : null,
  packed : _.undefined,
  unpacked : _.undefined,
}

//

function _requestPerform( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.routineOptions( _requestPerform, arguments );

  return _.Consequence.Try( () =>
  {

    if( o.unpacked === _.undefined )
    o.unpacked = agent._unpack({ structure : o.packed });

    _.assert( _.longIs( o.unpacked.args ) );
    _.assert( o.id >= 1 );

    let object = flock.localHandleToObject( o.unpacked.object );

    _.assert( _.routineIs( object[ o.unpacked.routine ] ), `No such routine::${o.unpacked.routine}` );

    let result = object[ o.unpacked.routine ]( ... o.unpacked.args );
    if( result === undefined )
    result = _.undefined;
    return result;
  })
  .then( ( result ) =>
  {

    let packet =
    {
      channel : 'response',
      body : agent._pack({ structure : result }),
      requestId : o.id,
    }

    let o2 =
    {
      connection : o.connection || flock.connectionDefaultGet(),
      deserialized : packet,
    }

    agent._send( o2 );

    return result;
  });
}

_requestPerform.defaults =
{
  id : null,
  packed : _.undefined,
  unpacked : _.undefined,
  connection : null,
}

//

function _serialize( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  let serialized;
  try
  {
    _.assert( _.strDefined( o.channel ), 'Channel is not specified' );
    serialized = _.entity.exportJson( o );
    serialized = serialized.length + ' ' + serialized;
  }
  catch( err )
  {
    err = _.err( err, `Agent::{${agent.agentPath}} failed to _serialize structure` );
  }
  return serialized;
}

_serialize.defaults =
{
  channel : null,
  data : null,
}

//

function _deserialize( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  let converter = _.gdf.selectSingleContext({ inFormat : 'string', outFormat : 'structure', ext : 'json', single : 1 })
  let result = [];

  if( _.bufferAnyIs( o.data ) )
  o.data = _.bufferToStr( o.data );

  let left = o.data;

  do
  {
    try
    {
      let size = parseFloat( left );
      _.assert( size > 0, () => `Failed to parse prologue of the package "${left.substring( 0, Math.max( left.length, 30 ) )}..."` );
      let sizeStr = String( size );
      let current = left.substring( sizeStr.length + 1, sizeStr.length + size + 1 );
      left = left.substring( sizeStr.length + size + 1, left.length );
      debugger;
      let deserialized = converter.encode({ data : current });
      _.assert( _.mapIs( deserialized.data ) );
      // let deserialized = JSON.parse( o.data );
      result.push( deserialized.data );
    }
    catch( err )
    {
      err = _.err( err, `\nagent::{${agent.agentPath}} failed to parse recieved packet\n` );
      debugger;
      throw err;
    }
  }
  while( left.length );

  return result;
}

_deserialize.defaults =
{
  data : null,
}

//

function _pack( o )
{
  let agent = this;
  let flock = agent.flock;
  return o.structure;
}

_pack.defaults =
{
  structure : null,
}

//

function _unpack( o )
{
  let agent = this;
  let flock = agent.flock;
  return o.structure;
}

_unpack.defaults =
{
  structure : null,
}

// --
// common
// --

function close()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  return agent._close();
}

//

function commonRecieveGot( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.routineOptions( commonRecieveGot, arguments );

  if( o.deserialized === null )
  o.deserialized = agent._deserialize({ data : o.serialized });

  if( _.longIs( o.deserialized ) )
  {
    for( let d = 0 ; d < o.deserialized.length ; d++ )
    agent.commonRecieveGot
    ({
      deserialized : o.deserialized[ d ],
      connection : o.connection,
    });
    return;
  }

  if( o.deserialized.recipient )
  {
    if( o.deserialized.recipient !== agent.agentPath )
    {
      agent._send
      ({
        deserialized : o.deserialized,
      });
      flock.log( -5, `resend . ${o.deserialized.body}` );
      return;
    }
  }

  if( o.deserialized.channel !== null )
  {
    _.assert( _.strDefined( o.deserialized.channel ) );
    let methodName = `_channel${_.strCapitalize( o.deserialized.channel )}`;
    _.sure( _.routineIs( agent[ methodName ] ), `Unknown channel ${o.deserialized.channel}` );
    agent[ methodName ]( o );
  }

  flock.log( -5, `recieved . ${o.deserialized.channel} . ${o.deserialized.body}` );
}

commonRecieveGot.defaults =
{
  serialized : null,
  deserialized : null,
  connection : null,
}

//

function commonErrorGot( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  logger.error( _.errOnce( `Error of ${agent.agentPath || flock.role}\n`, o.err ) );

  agent.masterCloseSoonMaybe();

  flock.eventGive
  ({
    kind : 'errorGot',
    representative : !o.connection ? null : flock.connectionToRepresentative( o.connection ),
    err : o.err,
  });

}

commonErrorGot.defaults =
{
  err : null,
  connection : null,
}

//

function _channelMessage( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  flock.eventGive
  ({
    kind : 'channelMessage',
    representative : !o.connection ? null : flock.connectionToRepresentative( o.connection ),
    message : o.deserialized.body,
  });

}

//

function _channelCall( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  return agent._requestPerform
  ({
    id : o.deserialized.requestId,
    packed : o.deserialized.body,
    connection : o.connection,
  });
}

//

function _channelResponse( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  return agent._requestClose
  ({
    id : o.deserialized.requestId,
    packed : o.deserialized.body,
  });
}

//

function _channelIdentity( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  agent.slaveConnectEnd
  ({
    connection : o.connection,
    attempt : agent._connectAttemptsMade,
    id : o.deserialized.body.id,
  });

}

// --
// slave
// --

function slaveOpenSlave( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.routineOptions( slaveOpenSlave, o );

  debugger;

  if( flock.role === 'master' )
  {

    return agent.masterSlaveOpen()
    .then( ( slaveFlock ) =>
    {
      debugger;
      return slaveFlock.object;
    });

  }
  else
  {

    let body =
    {
      object : 'agent',
      routine : 'slaveOpenSlave',
      args : [],
    }

    return agent.request
    ({
      deserialized :
      {
        channel : 'call',
        recipient : '/master1',
        body : body,
      },
    });

  }

}

slaveOpenSlave.defaults =
{
}

//

function slaveOpenMaster()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  flock.masterPath = flock.freeLocalMasterPathFind();

  _.assert( _.strDefined( flock.masterPath ) );
  _.assert( _.strDefined( flock.entryPath ) );
  _.assert( agent._process === null );

  let result = agent._process = _.process.startNjs
  ({
    execPath : flock.entryPath,
    args : `role:master masterPath:${flock.masterPath}`,
    sync : 0,
    deasync : 0,
    detaching : 1,
    stdio : 'pipe',
  });

  result.then( ( process ) =>
  {
    _.assert( agent._process === result );
    agent._process = process;
    return process;
  });

  return result;
}

//

function slaveConnectMaster()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  let masterPathParsed = _.uri.parse( flock.masterPath );
  masterPathParsed.port = _.numberFromStrMaybe( masterPathParsed.port );

  agent._connectAttemptsMade += 1;

  let attempt = agent._connectAttemptsMade;

  _.assert( _.numberDefined( masterPathParsed.port ) );
  _.assert( flock.role === 'slave' );
  _.assert( flock.connections.length === 0 );
  _.assert( agent._connectAttemptsMade <= flock.connectAttempts );
  _.assert( agent._connectStatus === 'closed' );

  agent.slaveConnectBegin({ attempt });

  let o2 = { port : masterPathParsed.port };
  let connection = Net.createConnection( o2, () => agent.slaveConnectEndWaitingForIdentity({ attempt, connection }) );

  flock.connections.push( connection );

  connection.on( 'data', ( data ) => agent.slaveRecieveGot({ serialized : data }) );
  connection.on( 'error', ( err ) => agent.slaveErrorGot({ err }) );
  connection.on( 'end', () => agent.slaveDisconnectEnd({ connection, attempt }) )

  let ready = _.Consequence();

  flock.once( 'connectEnd', connectEnd );
  flock.once( 'errorGot', errorGot );

  return ready;

  function connectEnd( e )
  {
    flock.off( 'connectEnd', connectEnd );
    flock.off( 'errorGot', errorGot );
    ready.take( flock.master );
  }

  function errorGot( e )
  {
    flock.off( 'connectEnd', connectEnd );
    flock.off( 'errorGot', errorGot );
    ready.error( e.error );
  }

}

//

function slaveConnectMasterMaybe()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  if( _.longHas( [ 'closed', 'connecting', 'connection.waiting.for.identity' ], agent._connectStatus ) )
  if( flock.connectAttempts > agent._connectAttemptsMade )
  {
    _.time.begin( flock.connectAttemptDelay, () => agent.slaveConnectMaster() );
    return true;
  }

  return false;
}

//

function slaveDisconnectMaster()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  agent._connectStatus = 'closed';

  if( flock.connections.length )
  {
    _.assert( flock.connections.length === 1 );
    flock.connections[ 0 ].end();
  }

  if( agent._process )
  {
    let process = agent._process;
    agent._process = null;
    process.disconnect();

    /* yyy */
    process.conTerminate.catch( err =>
    {
      if( err.reason != 'disconnected' )
      throw err;
      _.errAttend( err );
      return process;
    })
    /* yyy */

  }

}

//

function slaveIsConnected()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  return !!flock.connections.length;
}

//

function slaveConnectBegin( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( agent._connectStatus === 'closed' );
  agent._connectStatus = 'connecting';

  flock.eventGive
  ({
    kind : 'connectBegin',
    attempt : o.attempt,
  });

  flock.log( -7, `slaveConnectBegin. Attempt ${agent._connectAttemptsMade} / ${flock.connectAttempts}` );
}

slaveConnectBegin.defaults =
{
  attempt : null,
}

//

function slaveConnectEndWaitingForIdentity( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( !!o.connection );
  _.assert( agent._connectStatus === 'connecting' );
  agent._connectStatus = 'connection.waiting.for.identity';

  flock.master = flock.representativeMake
  ({
    agentPath : _.remote.agentPathFromRole( 'master' ),
    connection : o.connection,
  })

  flock.eventGive
  ({
    kind : 'connectEndWaitingForIdentity',
    attempt : o.attempt,
    representative : flock.master,
  });

  flock.log( -7, `slaveConnectEndWaitingForIdentity` );
}

slaveConnectEndWaitingForIdentity.defaults =
{
  connection : null,
  attempt : null,
}

//

function slaveConnectEnd( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( !!o.connection );
  _.assert( agent._connectStatus === 'connection.waiting.for.identity' );
  agent._connectStatus = 'connected';

  /* qqq : write explanation for every assert. ask how to */

  _.assert( flock.role === 'slave' );
  _.assert( agent.id === 0 );
  _.assert( o.id >= 2 );
  _.assert( _.numberIs( o.id ) );
  agent.id = o.id;
  _.assert( agent.agentPath === null );
  agent.agentPath = _.remote.agentPathFromRole( flock.role, agent.id );

  flock.eventGive
  ({
    kind : 'connectEnd',
    attempt : o.attempt,
    representative : flock.master,
  });

  flock.log( -7, `slaveConnectEnd` );
}

slaveConnectEnd.defaults =
{
  connection : null,
  attempt : null,
  id : null,
}

//

function slaveDisconnectEnd( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  flock.log( -7, `slaveDisconnectEnd` );

  _.assert( flock.connections.length === 1 );
  _.assert( flock.connections[ 0 ] === o.connection )

  flock.connections.splice( 0, 1 );
}

slaveDisconnectEnd.defaults =
{
  connection : null,
  attempt : null,
}

//

function slaveRecieveGot( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  _.routineOptions( slaveRecieveGot, arguments );
  if( o.connection === null )
  o.connection = flock.connectionDefaultGet();
  return agent.commonRecieveGot( o );
}

slaveRecieveGot.defaults =
{
  ... commonRecieveGot.defaults,
}

//

function slaveErrorGot( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  debugger;
  try
  {
    if( !flock.connectionIsAlive( flock.connections[ 0 ] ) )
    {
      flock.connections.splice( 0, 1 );
      agent.slaveDisconnectMaster();
      if( agent.slaveConnectMasterMaybe() )
      return;
    }
  }
  catch( err )
  {
    logger.error( _.errOnce( 'slaveErrorGot error\n', err ) );
  }

  if( !o.connection )
  try
  {
    if( flock.connections.length )
    o.connection = flock.connectionDefaultGet();
  }
  catch( err )
  {
    logger.error( _.errOnce( 'slaveErrorGot error\n', err ) );
  }

  return agent.commonErrorGot( o );
}

slaveErrorGot.defaults =
{
  ... commonErrorGot.defaults,
}

// --
// master
// --

function masterOpen()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( flock.agentCounter === 0 );
  flock.agentCounter += 1;
  _.assert( agent.id === 0 );
  agent.id = flock.agentCounter;
  _.assert( agent.agentPath === null );
  agent.agentPath = _.remote.agentPathFromRole( flock.role, agent.id );

  agent.masterOpenBegin();

  if( !flock.masterPath )
  flock.masterPath = flock.freeLocalMasterPathFind();

  _.assert( !!flock.masterPath );
  let masterPathParsed = _.uri.parse( flock.masterPath );
  masterPathParsed.port = _.numberFromStrMaybe( masterPathParsed.port );
  _.assert( _.numberDefined( masterPathParsed.port ) );

  agent.server = Net.createServer( ( connection ) =>
  {
    agent.masterConnectBegin({});
    connection
    .on( 'data', ( data ) => agent.masterRecieveGot({ connection, serialized : data }) )
    .on( 'end', () => agent.masterDisconnectEnd({ connection }) )
    .on( 'error', ( err ) => agent.masterErrorGot({ connection, err }) )
    ;
    agent.masterConnectEnd({ connection });
  })
  .on( 'error', ( err ) => agent.masterErrorGot({ err }) )
  .on( 'close', () => agent.masterCloseEnd() )
  ;

  agent.server.listen( masterPathParsed.port, () => agent.masterOpenEnd() );

  return agent;
}

//

function masterClose()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( !!agent.server );

  agent.masterCloseBegin();

  agent.server.close();

  return agent;
}

//

function masterIsOpened()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  return !!agent.server;
}

//

function masterCloseSoonMaybe()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  if( !agent.masterCloseCan() )
  return false;

  agent.terminationTimer = _.time.begin( flock.terminationPeriod, () => agent._masterCloseMaybe() );

  return true;
}

//

function masterCloseSoonCancel()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  if( agent.terminationTimer )
  {
    agent.terminationTimer = _.time.cancel( agent.terminationTimer );
    agent.terminationTimer = null;
  }

}

//

function _masterCloseMaybe()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  if( agent.masterCloseCan() )
  agent.masterClose();

}

//

function masterCloseCan()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  if( flock.connections.length )
  return false;

  return true;
}

//

function masterCloseBegin()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
}

//

function masterCloseEnd()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  agent.server = null;
  _.assert( flock.connections.length === 0 ); /* qqq : reproduce the case when this assertion fails */
}

//

function masterOpenBegin()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( agent._connectStatus === 'closed' );
  agent._connectStatus = 'opening';

  _.time.out( flock.terminationOnOpeningExtraPeriod, () => agent.masterCloseSoonMaybe() );

}

//

function masterOpenEnd()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( agent._connectStatus === 'opening' );
  agent._connectStatus = 'opened';

  flock.log( -7, `opened server on port::${agent.server.address().port}` );
}

//

function masterConnectBegin( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( !o.connection );

  agent.masterCloseSoonCancel();

  flock.eventGive
  ({
    kind : 'connectBegin',
  });

}

masterConnectBegin.defaults =
{
}

//

function masterConnectEnd( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.assert( !!o.connection );

  _.arrayAppendOnceStrictly( flock.connections, o.connection );

  flock.agentCounter += 1;
  let id = flock.agentCounter;
  let agentPath = _.remote.agentPathFromRole( 'slave', id );

  _.assert( id >= 2 );

  let representative = flock.representativeMake
  ({
    agentPath,
    connection : o.connection,
  });

  _.assert( flock.representativesMap[ id ] === representative );
  _.assert( id === representative.id );
  _.assert( o.connection === representative.connection );

  agent._send
  ({
    connection : o.connection,
    deserialized :
    {
      channel : 'identity',
      body : { id }
    }
  });

  flock.eventGive
  ({
    kind : 'connectEnd',
    representative,
  });

  flock.log( -7, `${o.connection.remoteAddress} connected. ${flock.connections.length} connection(s)` );

}

masterConnectEnd.defaults =
{
  connection : null,
}

//

function masterDisconnectEnd( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  _.arrayRemoveOnceStrictly( flock.connections, o.connection );

  agent.masterCloseSoonMaybe();

  flock.log( -7, `${o.connection.remoteAddress} disconnected. ${flock.connections.length} connection(s)` );
}

masterDisconnectEnd.defaults =
{
  connection : null,
}

//

function masterRecieveGot( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  _.routineOptions( masterRecieveGot, arguments );

  return agent.commonRecieveGot( ... arguments );
}

masterRecieveGot.defaults =
{
  ... commonRecieveGot.defaults,
}

//

function masterErrorGot( o )
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;
  return agent.commonErrorGot( o );
}

masterErrorGot.defaults =
{
  ... commonErrorGot.defaults,
}

// --
// relations
// --

let Packet =
{
  recipient : null,
  requestId : null,
  channel : 'message',
  body : null,
}

let Composes =
{
}

let Associates =
{
  flock : null,
}

let Restricts =
{

  agentPath : null,

  server : null,
  _process : null,

  terminationTimer : null,

  id : 0,
  _connectAttemptsMade : 0,
  _connectStatus : 'closed',

  requestCounter : 0,
  requests : _.define.own( {} ),

}

let Statics =
{

  Packet,

}

let Forbids =
{

  terminationPeriod : 'terminationPeriod',
  terminationOnOpeningExtraPeriod : 'terminationOnOpeningExtraPeriod',
  slaveDelay : 'slaveDelay',
  masterDelay : 'masterDelay',
  connectAttempts : 'connectAttempts',
  connectAttemptDelay : 'connectAttemptDelay',
  role : 'role',
  entryPath : 'entryPath',
  masterPath : 'masterPath',
  agentCounter : 'agentCounter',
  agent : 'agent',
  master : 'master',
  representativesMap : 'representativesMap',
  connectionToRepresentativeHash : 'connectionToRepresentativeHash',
  objectCounter : 'objectCounter',
  idToHandleDescriptorHash : 'idToHandleDescriptorHash',
  nameToHandleDescriptorHash : 'nameToHandleDescriptorHash',
  objectToHandleDescriptorHash : 'objectToHandleDescriptorHash',
  object : 'object',

}

let Accessor =
{
}

// --
// prototype
// --

let Proto =
{

  // inter

  finit,
  init,
  unform,
  form,
  _form : null,

  // send

  send,
  _send,

  requestCall,
  request,
  _requestOpen,
  _requestClose,
  _requestPerform,

  _serialize,
  _deserialize,
  _pack,
  _unpack,

  // common

  close,
  _close : null,

  commonRecieveGot,
  commonErrorGot,

  _channelMessage,
  _channelCall,
  _channelResponse,
  _channelIdentity,

  // slave

  slaveOpenSlave,
  slaveOpenMaster,
  slaveConnectMaster,
  slaveConnectMasterMaybe,
  slaveDisconnectMaster,
  slaveIsConnected,

  slaveConnectBegin,
  slaveConnectEndWaitingForIdentity,
  slaveConnectEnd,
  slaveDisconnectEnd,
  slaveRecieveGot,
  slaveErrorGot,

  // master

  masterOpen,
  masterClose,
  masterIsOpened,
  masterCloseSoonMaybe,
  masterCloseSoonCancel,
  _masterCloseMaybe,
  masterCloseCan,

  masterCloseBegin,
  masterCloseEnd,
  masterOpenBegin,
  masterOpenEnd,
  masterConnectBegin,
  masterConnectEnd,
  masterDisconnectEnd,
  masterRecieveGot,
  masterErrorGot,

  // relations

  Composes,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessor,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.remote[ Self.shortName ] = Self;

})();

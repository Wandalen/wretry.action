( function _Flock_s_() {

'use strict';

//

const _ = _global_.wTools;
const Parent = null;
const Self = wRemoteFlock;
function wRemoteFlock( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Flock';

// --
// inter
// --

function finit()
{
  let flock = this;
  flock.unform();
  _.Copyable.prototype.finit.call( flock );
}

//

function init( o )
{
  let flock = this;

  _.assert( arguments.length === 1 );

  _.workpiece.initFields( flock );
  Object.preventExtensions( flock );

  if( o )
  flock.copy( o );

  return flock;
}

//

function unform()
{
  let flock = this;

  flock.agent.finit();

/*
qqq : cover, please
*/

}

//

function form()
{
  let flock = this;
  let ready = _.Consequence().take( null );

  if( flock.logger === null )
  {
    flock.logger = new _.Logger({ output : _global_.logger });
    flock.logger.verbosity = 7;
  }

  let logger = flock.logger;

  // debugger;
  // _.process.on( 'exit', flock, () =>
  _.process.on( 'exit', () =>
  {
    flock.exitGot();
  });
  // debugger;

  ready.then( () => flock.roleDetermine() );

  ready.then( ( arg ) =>
  {
    flock.enterGot();

    if( flock.role === 'slave' )
    {
      flock.agent = new _.remote.Slave({ flock });
    }
    else
    {
      flock.agent = new _.remote.Master({ flock });
    }

    return flock.agent.form();
  });

  return ready;
}

// --
// etc
// --

function close()
{
  let flock = this;
  let logger = flock.logger;

  if( flock.agent )
  flock.agent.close();

}

//

function connectionIs( connection )
{
  let flock = this;
  return _.objectIs( connection );
}

//

function connectionIsAlive( connection )
{
  let flock = this;
  _.assert( connection.destroyed !== undefined );
  return !connection.destroyed;
}

//

function connectionDefaultGet()
{
  let flock = this;
  _.assert( flock.connections.length === 1 );
  return flock.connections[ 0 ];
}

//

function connectionToRepresentative( connection )
{
  let flock = this;
  _.assert( flock.connectionIs( connection ) );
  return flock.connectionToRepresentativeHash.get( connection );
}

//

function roleDetermine()
{
  let flock = this;

  if( flock.role !== null )
  return end();

  if( flock.masterPath === null || flock.masterPath === undefined )
  flock.masterPath = flock.openedRemoteMasterPathFind();

  if( flock.masterPath )
  return end( 'slave' );

  flock._roleDetermine();

  return end();

  function end( role )
  {
    if( role !== undefined )
    flock.role = role;
    _.assert( _.longHas( [ 'slave', 'master' ], flock.role ), () => `Unknown role ${flock.role}` );

    return flock.role;
  }
}

//

function _roleDetermine()
{
  let flock = this;

  _.assert( flock.role === null );

  let args = _.process.input();

  if( args.map.role !== undefined )
  {
    flock.role = args.map.role;
  }
  else
  {
    flock.role = 'slave';
  }

  return flock.role;
}

//

function format()
{
  let flock = this;
  let logger = flock.logger;
  return [ `${flock.role} .`, ... arguments ];
}

//

function log( level, ... msgs )
{
  let flock = this;
  let logger = flock.logger;

  logger.begin({ verbosity : level });
  logger.log( ... flock.format( ... msgs ) );
  logger.end({ verbosity : level });

}

//

function representativeMake( o )
{
  let flock = this;
  let logger = flock.logger;

  o.flock = flock;

  return _.remote.Representative( o );
}

// --
// handle
// --

function LocalHandleIs( src )
{
  if( _.numberIs( src ) )
  return true;
  if( _.strIs( src ) )
  return true;
  return false;
}

//

function localHandleToObjectDescriptor( key )
{
  let flock = this;
  _.assert( _.strIs( key ) || _.numberIs( key ) );
  if( _.strIs( key ) )
  return flock.nameToHandleDescriptorHash.get( key );
  else
  return flock.idToHandleDescriptorHash.get( key );
}

//

function objectToLocalHandleDescriptor( object )
{
  let flock = this;
  return flock.objectToHandleDescriptorHash.get( object );
}

//

function localHandleToObject( key )
{
  let flock = this;
  let desc = flock.localHandleToObjectDescriptor( key );
  if( !desc )
  return;
  return desc.object;
}

//

function objectToId( object )
{
  let flock = this;
  let desc = flock.objectToLocalHandleDescriptor( object );
  if( !desc )
  return;
  return desc.id;
}

//

function localHandlesAdd( o )
{
  let flock = this;

  _.routineOptions( localHandlesAdd, arguments );

  let result = _.map_( null, o.objects, ( object, k ) =>
  {
    if( _.numberIs( k ) )
    return flock._localHandleAdd({ object });
    else
    return flock._localHandleAdd({ object, name : k });
  });

  return result;
}

localHandlesAdd.defaults =
{
  objects : null,
}

//

function _localHandleAdd( o )
{
  let flock = this;
  let desc;

  _.assert( o.object !== undefined && o.object !== null );
  _.routineOptions( _localHandleAdd, arguments );
  _.assert( o.name === null || _.strDefined( o.name ) );

  desc = flock.objectToHandleDescriptorHash.get( o.object );
  if( desc )
  {
    _.assert( desc.name === o.name, `Object already added with name ${desc.name}. Cant change name to ${o.name}` );
    return desc;
  }

  if( o.name )
  {
    desc = flock.nameToHandleDescriptorHash.get( o.name );
    if( desc )
    {
      debugger;
      throw _.err( `Object with name ${o.name} already exists. Cant overwrite it.` );
    }
  }

  flock.objectCounter += 1;

  desc = Object.create( null );
  desc.id = flock.objectCounter;
  desc.name = o.name;
  desc.object = o.object;

  flock.idToHandleDescriptorHash.set( desc.id, desc );
  if( o.name )
  flock.nameToHandleDescriptorHash.set( desc.name, desc );
  flock.objectToHandleDescriptorHash.set( desc.object, desc );

  return desc;
}

_localHandleAdd.defaults =
{
  name : null,
  object : null,
}

//

function localHandlesRemoveObjects( objects )
{
  let flock = this;

  _.routineOptions( localHandlesRemoveObjects, arguments );

  let result = _.map_( null, objects, ( object, k ) =>
  {
    return flock.localHandlesRemoveObject( object );
  });

  return result;
}

//

function localHandlesRemoveObject( object )
{
  let flock = this;

  let desc = flock.objectToHandleDescriptorHash.get( object );

  _.assert( !!desc, () => `Cant remove object. It was not added` );

  return result;
}

//

function PrimitiveHandleIs( src )
{
  if( _.numberIs( src ) )
  return true;
  if( _.strIs( src ) )
  return true;
  return false;
}

//

function RemoteHandleIs( src )
{
  if( !_.objectIs( src ) )
  return false;
  if( !src[ twinSymbol ] )
  return false;
  return true;
}

//

function handleFrom( src )
{
  let flock = this;
  let result = src;
  if( flock.RemoteHandleIs( result ) )
  result = src[ twinSymbol ].handle;
  _.assert( flock.PrimitiveHandleIs( result ) );
  return result;
}

// --
// communication
// --

function send( body )
{
  let flock = this;
  let agent = flock.agent;
  return agent.send( ... arguments );
}

//

function openedRemoteMasterPathFind()
{
  let flock = this;
  let logger = flock.logger;
  return null;
}

//

function freeLocalMasterPathFind()
{
  let flock = this;
  let logger = flock.logger;
  return 'http://0.0.0.0:13000';
}

//

function enterGot()
{
  let flock = this;
  let logger = flock.logger;
  flock.log( -5, `enter` );
}

//

function exitGot()
{
  let flock = this;
  let logger = flock.logger;
  flock.log( -5, `exit` );
}

// --
// relations
// --

let twinSymbol = Symbol.for( 'twin' );

let Composes =
{

  terminationPeriod : 5000,
  terminationOnOpeningExtraPeriod : 5000,
  slaveDelay : 1000,
  masterDelay : 0,

  connectAttempts : 2,
  connectAttemptDelay : 250,

  role : null,
  entryPath : null,
  masterPath : null,

}

let Associates =
{

  logger : null,

}

let Restricts =
{

  agentCounter : 0,
  agent : null,
  master : null,

  connections : _.define.own( [] ),
  representativesMap : _.define.own( {} ),
  connectionToRepresentativeHash : _.define.own( new HashMap ),

  objectCounter : 0,
  idToHandleDescriptorHash : _.define.own( new HashMap ),
  nameToHandleDescriptorHash : _.define.own( new HashMap ),
  objectToHandleDescriptorHash : _.define.own( new HashMap ),

}

let Events =
{

  errorGot : {},

  connectBegin : {},
  connectEndWaitingForIdentity : {},
  connectEnd : {},

  channelMessage : {},

}

let Statics =
{

  LocalHandleIs,
  PrimitiveHandleIs,
  RemoteHandleIs,

}

let Forbids =
{

  object : 'object',
  agentPath : 'agentPath',
  server : 'server',
  _process : '_process',
  terminationTimer : 'terminationTimer',
  id : 'id',
  _connectAttemptsMade : '_connectAttemptsMade',
  _connectStatus : '_connectStatus',
  requestCounter : 'requestCounter',
  requests : 'requests',

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

  // etc

  close,
  connectionIs,
  connectionIsAlive,
  connectionDefaultGet,
  connectionToRepresentative,

  roleDetermine,
  _roleDetermine,
  format,
  log,

  representativeMake,

  // handles

  LocalHandleIs,

  localHandleToObjectDescriptor,
  objectToLocalHandleDescriptor,
  localHandleToObject,
  objectToId,

  localHandlesAdd,
  _localHandleAdd,

  localHandlesRemoveObjects,
  localHandlesRemoveObject,

  PrimitiveHandleIs,
  RemoteHandleIs,
  handleFrom,

  // communication

  send,
  openedRemoteMasterPathFind,
  freeLocalMasterPathFind,

  enterGot,
  exitGot,

  // relations

  Composes,
  Associates,
  Restricts,
  Events,
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
_.EventHandler.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.remote[ Self.shortName ] = Self;

})();

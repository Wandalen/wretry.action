( function _Master_s_() {

'use strict';

if( typeof module !== 'undefined' )
{
  var Net = require( 'net' );
}

//

const _ = _global_.wTools;
const Parent = _.remote.Agent;
const Self = wRemoteAgentMaster;
function wRemoteAgentMaster( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Master';

// --
// inter
// --

function _form()
{
  let agent = this;
  let flock = agent.flock;
  let ready = _.Consequence().take( null );

  ready.then( () => _.time.out( flock.masterDelay ) );
  ready.then( () => agent.masterOpen() );

  return ready;
}

//

function _close()
{
  let agent = this;
  let flock = agent.flock;
  let logger = flock.logger;

  if( agent.masterIsOpened() )
  agent.masterClose();

}

// --
// relations
// --

let Composes =
{
}

let Associates =
{
}

let Restricts =
{
}

let Events =
{

}

let Statics =
{
}

let Forbids =
{
  object : 'object',
  role : 'role',
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

  _form,
  _close,

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

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.remote[ Self.shortName ] = Self;

})();

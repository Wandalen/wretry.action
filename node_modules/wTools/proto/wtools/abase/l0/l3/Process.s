( function _l3_Process_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
//
// --

function on( o )
{
  o = _.event.onHead( _.event.on, arguments );
  return _.event.on( this._edispatcher, o );
}

on.defaults =
{
  callbackMap : null,
};

//

function once( o )
{
  o = _.event.once.head( _.event.once, arguments );
  return _.event.once( this._edispatcher, o );
}

once.defaults =
{
  callbackMap : null,
};

//

function off( o )
{
  o = _.event.offHead( _.event.off, arguments );
  return _.event.off( this._edispatcher, o );
}

off.defaults =
{
  callbackMap : null,
};

//

function eventHasHandler( o )
{
  o = _.event.eventHasHandlerHead( _.event.eventHasHandler, arguments );
  return _.event.eventHasHandler( this._edispatcher, o );
}

eventHasHandler.defaults =
{
  eventName : null,
  eventHandler : null,
}

//

function eventGive()
{
  let o = _.event.eventGiveHead( this._edispatcher, eventGive, arguments );
  return _.event.eventGive( this._edispatcher, o );
  // return _.event.eventGive( this._edispatcher, ... arguments );
}

eventGive.defaults =
{
  ... _.event.eventGive.defaults,
  origination : null,
  err : null,
}

// --
//
// --

let Inspector = null;
function isDebugged()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );

  // return false; // xxx

  if( typeof process === 'undefined' )
  return false;

  if( Inspector === null )
  try
  {
    Inspector = require( 'inspector' );
  }
  catch( err )
  {
    Inspector = false;
  }

  if( Inspector )
  return _.strIs( Inspector.url() );

  if( !process.execArgv.length )
  return false;

  let execArgvString = process.execArgv.join();
  return _.strHasAny( execArgvString, [ '--inspect', '--inspect-brk', '--debug-brk' ] );
}

//

function insideTestContainer()
{
  if( !_global_.process )
  return false;
  return 'CI' in _global_.process.env;
}

//

function entryPointStructure()
{
  let result = Object.create( null );
  if( _global.process !== undefined )
  {
    if( _global.process.argv )
    result.execPath = _global.process.argv.join( ' ' );
    if( _.routine.is( _global.process.cwd ) )
    result.currentPath = _global.process.cwd();
  }
  return result;
}

//

function entryPointInfo()
{
  let data = _.process.entryPointStructure();
  let result = '';

  if( data.currentPath )
  result = join( 'Current path', data.currentPath );
  if( data.execPath )
  result = join( 'Exec path', data.execPath );

  return result;

  /* */

  function join( left, right )
  {
    if( result )
    result += '\n';
    result += left + ' : ' + right;
    return result;
  }
}

// --
// implementation
// --

let Events =
{
  'available' : [],
  'uncaughtError' : [],
}

let _edispatcher =
{
  events : Events,
}

let Extension =
{

  // event

  _edispatcher,
  on,
  once,
  off,
  eventHasHandler,
  eventGive,

  // dichotomy

  isDebugged,
  insideTestContainer,

  // entry point

  entryPointStructure,
  entryPointInfo,

}

//

Object.assign( _.process, Extension );

})();

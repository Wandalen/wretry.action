( function _EventHandler_s_()
{

'use strict';

/**
 * Mixin adds events dispatching mechanism to your class. EventHandler provides methods to bind/unbind handler of an event, to handle a specific event only once, to associate an event with a namespace what later make possible to unbind handler of event with help of namespace. EventHandler allows redirecting events to/from another instance. Unlike alternative implementation of the concept, EventHandler is strict by default and force developer to explicitly declare / bind / unbind all events supported by object. Use it to add events dispatching mechanism to your classes and avoid accumulation of technical dept and potential errors.
  @module Tools/base/EventHandler
*/

/*

+ implement tracking of event kinds !!!
- remove deprecated features !!!
- refactor !!!
- off of not offed event handler should throw error !!!

*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wProto' );

}

//

/**
 * @classdesc Mixin adds events dispatching mechanism to your class
 * @class wEventHandler
 * @namespace Tools
 * @module Tools/base/EventHandler
 */

const _global = _global_;
const _ = _global_.wTools;
const _ObjectHasOwnProperty = Object.hasOwnProperty;
const Parent = null;
const Self = wEventHandler;
function wEventHandler( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'EventHandler';

// --
//
// --

/**
 * Mixin this methods into prototype of another object.
 * @param {object} dstPrototype - prototype of another object.
 * @method copy
 * @module Tools/base/EventHandler
 * @namespace Tools
 * @class wEventHandler
 */

function onMixinApply( mixinDescriptor, dstClass )
{
  let dstPrototype = dstClass.prototype;

  _.mixinApply( this, dstPrototype );

  _.assert( _.object.isBasic( dstPrototype.Restricts._eventHandler ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.routineIs( dstClass ) );
  _.assert( _.object.isBasic( dstPrototype.Events ) );
  _.assert( _.strIs( dstPrototype.Events.init ) );
  _.assert( _.strIs( dstPrototype.Events.finit ) );

  _.accessor.ownForbid( dstPrototype, '_eventHandlers' );

}

// --
// Functors
// --

/**
 * Functors to produce init.
 * @param { routine } original - original method.
 * @method init
 * @module Tools/base/EventHandler
 * @namespace Tools
 * @class wEventHandler
 */

function init( original )
{

  return function initEventHandler()
  {
    let self = this;

    self._eventHandlerInit();

    let result = original ? original.apply( self, arguments ) : undefined;

    self.eventGive( 'init' );

    return result;
  }

}

//

/**
 * Functors to produce finit.
 * @param { routine } original - original method.
 * @method finit
 * @module Tools/base/EventHandler
 * @namespace Tools
 * @class wEventHandler
 */

function finit( original )
{

  return function finitEventHandler()
  {
    let self = this;
    let result;

    self.eventGive( 'finit' );

    if( original )
    result = original ? original.apply( self, arguments ) : undefined;

    self._eventHandlerFinit();

    return result;
  }

}

// --
// register
// --

function _eventHandlerInit()
{
  let self = this;

  _.assert( !self._eventHandler, () => 'EventHandler.init already done for ' + self.qualifiedName );
  _.assert( self instanceof self.constructor );

  if( !self._eventHandler )
  self._eventHandler = Object.create( null );

  if( !self._eventHandler.descriptors )
  self._eventHandler.descriptors = Object.create( null );

}

//

function _eventHandlerFinit()
{
  let self = this;

  if( Config.debug || !self.strictEventHandling )
  {

    let handlers = self._eventHandler.descriptors;
    if( !handlers )
    return;

    for( let h in handlers )
    {
      if( !handlers[ h ] || handlers[ h ].length === 0 )
      continue;
      if( h === 'finit' )
      continue;
      let err = 'Finited instance has bound handler(s), but should not' + h + ':\n' + _.entity.exportString( handlers[ h ], { levels : 2 } );
      console.error( err.toString() + '\n' + err.stack );
      console.error( handlers[ h ][ 0 ].onHandle );
      console.error( self.eventReport() );
      throw _.err( err );
    }

  }

  self.eventHandlerRemove();
}

//

function eventReport()
{
  let self = this;
  let result = 'Event Map of ' + ( self.qualifiedName || 'an instance' ) + ':\n';
  let handlerArray;

  let handlers = self._eventHandler.descriptors || {};
  for( let h in handlers )
  {
    handlerArray = handlers[ h ];
    if( !handlerArray || handlerArray.length === 0 )
    continue;
    let onHandle = handlerArray.map( ( e ) => _.entity.exportString( e.onHandle ) );
    result += h + ' : ' + onHandle.join( ', ' ) + '\n';
  }

  for( let h in self.Events )
  {
    handlerArray = handlers[ h ];
    if( !handlerArray || handlerArray.length === 0 )
    {
      result += h + ' : ' + '-' + '\n';
    }
  }

  return result;
}

//

function eventHandlerPrepend( kind, onHandle )
{
  let self = this;
  let owner;

  _.assert( arguments.length === 2 || arguments.length === 3, 'eventHandlerAppend:', 'Expects "kind" and "onHandle" as arguments' );

  if( arguments.length === 3 )
  {
    owner = arguments[ 1 ];
    onHandle = arguments[ 2 ];
  }

  let descriptor =
  {
    kind,
    onHandle,
    owner,
    appending : 0,
  }

  self._eventHandlerRegister( descriptor );

  return self;
}

//

/**
 * @summary Registers handler `onHandle` routine for event `kind`.
 * @param { String } kind - name of event
 * @param { Function } onHandle - event handler
 * @method on
 * @module Tools/base/EventHandler
 * @namespace Tools
 * @class wEventHandler
 */

function eventHandlerAppend( kind, onHandle )
{
  let self = this;
  let owner;

  _.assert( arguments.length === 2 || arguments.length === 3, 'eventHandlerAppend:', 'Expects "kind" and "onHandle" as arguments' );

  if( arguments.length === 3 )
  {
    owner = arguments[ 1 ];
    onHandle = arguments[ 2 ];
  }

  let descriptor =
  {
    kind,
    onHandle,
    owner,
    appending : 1,
  }

  self._eventHandlerRegister( descriptor );

  return self;
}

//

function eventHandlerRegisterProvisional( kind, onHandle )
{
  let self = this;
  let owner;

  _.assert( arguments.length === 2 || arguments.length === 3, 'eventHandlerRegisterProvisional:', 'Expects "kind" and "onHandle" as arguments' );

  if( arguments.length === 3 )
  {
    owner = arguments[ 1 ];
    onHandle = arguments[ 2 ];
  }

  let descriptor =
  {
    kind,
    onHandle,
    owner,
    once : 0,
    provisional : 1,
    appending : 0,
  }

  self._eventHandlerRegister( descriptor );

  return self;
}

//

/**
 * @summary Register handler `onHandle` routine for event `kind`. Handler will be called only once.
 * @param { String } kind - name of event
 * @param { Function } onHandle - event handler
 * @method once
 * @module Tools/base/EventHandler
 * @namespace Tools
 * @class wEventHandler
 */

function eventHandlerRegisterOneTime( kind, onHandle )
{
  let self = this;
  let owner;

  _.assert( arguments.length === 2 || arguments.length === 3, 'eventHandlerRegisterOneTime:', 'Expects "kind" and "onHandle" as arguments' );

  if( arguments.length === 3 )
  {
    owner = arguments[ 1 ];
    onHandle = arguments[ 2 ];
  }

  let descriptor =
  {
    kind,
    onHandle,
    owner,
    once : 1,
    appending : 0,
  }

  self._eventHandlerRegister( descriptor );

  return self;
}

//

function eventHandlerRegisterEclipse( kind, onHandle )
{
  let self = this;
  let owner;

  _.assert( arguments.length === 2 || arguments.length === 3, 'eventHandlerRegisterEclipse:', 'Expects "kind" and "onHandle" as arguments' );

  if( arguments.length === 3 )
  {
    owner = arguments[ 1 ];
    onHandle = arguments[ 2 ];
  }

  let descriptor =
  {
    kind,
    onHandle,
    owner,
    eclipse : 1,
    appending : 0,
  }

  self._eventHandlerRegister( descriptor );

  return self;
}

//
//
// function eventForbid( kinds )
// {
//   var self = this;
//   var owner;
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.strIs( kinds ) || _.arrayIs( kinds ) );
//
//   var kinds = _.array.as( kinds );
//
//   function onHandle()
//   {
//     throw _.err( kinds.join( ' ' ), 'event is forbidden in', self.qualifiedName );
//   }
//
//   for( var k = 0 ; k < kinds.length ; k++ )
//   {
//
//     var kind = kinds[ k ];
//
//     var descriptor =
//     {
//       kind,
//       onHandle,
//       // forbidden : 1,
//       appending : 0,
//     }
//
//     self._eventHandlerRegister( descriptor );
//
//   }
//
//   return self;
// }
//
//

function _eventHandlerRegister( o )
{
  let self = this;

  if( o.kind === _.anything )
  {
    o.kind = [];
    for( let k in self.Events )
    {
      o.kind.push( k );
    }
  }

  if( _.arrayIs( o.kind ) )
  {
    for( let k = 0 ; k < o.kind.length ; k++ )
    {
      let d = _.props.extend( null, o );
      d.kind = o.kind[ k ];
      self._eventHandlerRegister( d );
    }
    return self;
  }

  /* verification */

  _.assert( _.strIs( o.kind ) );
  _.assert( _.routineIs( o.onHandle ), 'Expects routine {-onHandle-}, but got', _.entity.strType( o.oHandle ) );
  _.map.assertHasOnly( o, _eventHandlerRegister.defaults );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !( o.provisional && o.once ) );
  _.assert( !!self.constructor.prototype.Events || ( !self.constructor.prototype.strictEventHandling && self.constructor.prototype.strictEventHandling !== undefined ), 'Expects static Events' );
  _.assert( !self.strictEventHandling || !!self.Events[ o.kind ], self.constructor.name, 'is not aware about event', _.strQuote( o.kind ) )

  // if( o.forbidden )
  // console.debug( 'REMINDER : forbidden event is not implemented!' );

  let handlers = self._eventHandlerDescriptorsByKind( o.kind );

  if( self._eventKinds && self._eventKinds.indexOf( kind ) === -1 )
  throw _.err( 'eventHandlerAppend:', 'Object does not support such kind of events :', kind, self );

  /* */

  o.onHandleEffective = o.onHandle;

  /* eclipse */

  if( o.eclipse )
  o.onHandleEffective = function handleEclipse()
  {
    let result = o.onHandle.apply( this, arguments );

    self._eventHandlerRemove
    ({
      kind : o.kind,
      onHandle : o.onHandle,
      strict : 0,
    });

    return result;
  }

  /* once */

  if( o.once )
  if( self._eventHandlerDescriptorByKindAndHandler( o.kind, o.onHandle ) )
  return self;

  if( o.once )
  o.onHandleEffective = function handleOnce()
  {
    let result = o.onHandle.apply( this, arguments );

    self._eventHandlerRemove
    ({
      kind : o.kind,
      onHandle : o.onHandle,
      strict : 0,
    });

    return result;
  }

  /* provisional */

  if( o.provisional )
  o.onHandleEffective = function handleProvisional()
  {
    let result = o.onHandle.apply( this, arguments );

    if( result === false )
    self._eventHandlerRemove
    ({
      kind : o.kind,
      onHandle : o.onHandle,
      strict : 0,
    });

    return result;
  }

  /* owner */

  if( o.owner !== undefined && o.owner !== null )
  self.eventHandlerRemoveByKindAndOwner( o.kind, o.owner );

  /* */

  if( o.appending )
  handlers.push( o );
  else
  handlers.unshift( o );

  /* kinds */

  if( self._eventKinds )
  {
    _.arrayAppendOnce( self._eventKinds, kind );
  }

  return self;
}

_eventHandlerRegister.defaults =
{
  kind : null,
  onHandle : null,
  owner : null,
  proxy : 0,
  once : 0,
  eclipse : 0,
  provisional : 0,
  appending : 1,
}

// --
// unregister
// --

/**
 * @summary Unregisters handler `onHandle` routine for event `kind`.
 * @param { String } kind - name of event
 * @param { Function } onHandle - event handler
 * @method off
 * @module Tools/base/EventHandler
 * @namespace Tools
 * @class wEventHandler
 */

function eventHandlerRemove()
{
  let self = this;

  if( !self._eventHandler.descriptors )
  return self;

  if( arguments.length === 0 )
  {

    self._eventHandlerRemove( Object.create( null ) );

  }
  else if( arguments.length === 1 )
  {

    if( _.strIs( arguments[ 0 ] ) )
    {

      self._eventHandlerRemove
      ({
        kind : arguments[ 0 ],
      });

    }
    else if( _.routineIs( arguments[ 0 ] ) )
    {

      self._eventHandlerRemove
      ({
        onHandle : arguments[ 0 ],
      });

    }
    else if( _.longIs( arguments[ 0 ] ) )
    {

      for( let i = 0; i < arguments[ 0 ].length; i++ )
      self.eventHandlerRemove( arguments[ 0 ][ i ] );

    }
    else throw _.err( 'unexpected' );

  }
  else if( arguments.length === 2 )
  {

    if( _.longIs( arguments[ 0 ] ) )
    {

      for( let i = 0; i < arguments[ 0 ].length; i++ )
      self.eventHandlerRemove( arguments[ 0 ][ i ], arguments[ 1 ] );

    }
    else if( _.routineIs( arguments[ 1 ] ) )
    {

      self._eventHandlerRemove
      ({
        kind : arguments[ 0 ],
        onHandle : arguments[ 1 ],
      });

    }
    else
    {
      self._eventHandlerRemove
      ({
        kind : arguments[ 0 ],
        owner : arguments[ 1 ],
      });
    }
  }
  else _.assert( 0, 'unexpected' );

  return self;
}

//

function _eventHandlerRemove( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.map.assertHasOnly( o, _eventHandlerRemove.defaults );
  if( Object.keys( o ).length && o.strict === undefined )
  o.strict = 1;

  let handlers = self._eventHandler.descriptors;
  if( !handlers )
  return self;

  let length = Object.keys( o ).length;

  if( o.kind !== undefined )
  _.assert( _.strIs( o.kind ), 'Expects "kind" as string' );

  if( o.onHandle !== undefined )
  _.assert( _.routineIs( o.onHandle ), 'Expects "onHandle" as routine' );

  if( length === 0 )
  {

    for( let h in handlers )
    handlers[ h ].splice( 0, handlers[ h ].length );

  }
  else if( length === 1 && o.kind )
  {

    let handlers = handlers[ o.kind ];
    if( !handlers )
    return self;

    handlers.splice( 0, handlers.length );

  }
  else
  {

    // console.error( 'REMINDER', 'fix me' ); debugger; xxx
    // return;
    // let handlers;  // !!!
    let removed = 0;
    if( o.kind )
    {

      handlers = handlers[ o.kind ];
      if( handlers )
      removed = _.arrayRemovedElement( handlers, o, equalizer );

    }
    else for( let h in handlers )
    {

      removed += _.arrayRemovedElement( handlers[ h ], o, equalizer );

    }

    _.assert( removed > 0 || !o.onHandle || !o.strict, 'The handler was not registered to unregister it' );

  }

  function equalizer( a, b )
  {
    if( o.kind !== undefined )
    if( a.kind !== b.kind )
    return false;

    if( o.onHandle !== undefined )
    if( a.onHandle !== b.onHandle )
    return false;

    if( o.owner !== undefined )
    if( a.owner !== b.owner )
    return false;

    return true;
  }

  return self;
}

_eventHandlerRemove.defaults =
{
  kind : null,
  onHandle : null,
  owner : null,
  strict : 1,
}

//

function eventHandlerRemoveByKindAndOwner( kind, owner )
{
  let self = this;

  _.assert( arguments.length === 2 && !!owner, 'eventHandlerRemove:', 'Expects "kind" and "owner" as arguments' );

  let handlers = self._eventHandler.descriptors;
  if( !handlers )
  return self;

  handlers = handlers[ kind ];
  if( !handlers )
  return self;

  let descriptor; // !!!
  do
  {

    descriptor = self._eventHandlerDescriptorByKindAndOwner( kind, owner );

    if( descriptor )
    _.arrayRemoveElementOnce( handlers, descriptor );

  }
  while( descriptor );

  return self;
}


// --
// handle
// --

function eventGive( event )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.routineIs( self._eventGive ) );

  if( _.strIs( event ) )
  event = { kind : event };

  return self._eventGive( event, Object.create( null ) );
}

//

function eventHandleUntil( event, value )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.strIs( event ) )
  event = { kind : event };

  return self._eventGive( event, { until : value } );
}

//

function eventHandleSingle( event )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.strIs( event ) )
  event = { kind : event };

  return self._eventGive( event, { single : 1 } );
}

//

function _eventGive( event, o )
{
  let self = this;
  let result = o.result = o.result || [];
  let untilFound = 0;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( event.type === undefined || event.kind !== undefined, 'event should have "kind" field, no "type" field' );
  _.assert( !!self.constructor.prototype.Events || ( !self.constructor.prototype.strictEventHandling && self.constructor.prototype.strictEventHandling !== undefined ), 'Expects static Events' );
  _.assert( !self.strictEventHandling || !!self.Events[ event.kind ], () => self.constructor.name + ' is not aware about event ' + _.strQuote( event.kind ) );
  _.assert( _.object.isBasic( self._eventHandler ) );

  if( self.eventVerbosity )
  logger.log( 'fired event', self.qualifiedName + '.' + event.kind );

  /* head */

  let handlers = self._eventHandler.descriptors;
  if( handlers === undefined )
  return result;

  let handlerArray = handlers[ event.kind ];
  if( handlerArray === undefined )
  return result;

  handlerArray = handlerArray.slice( 0 );

  event.target = self;

  if( self.eventVerbosity )
  logger.up();

  if( o.single )
  _.assert( handlerArray.length <= 1, 'Expects single handler, but has ' + handlerArray.length );

  /* iterate */

  for( let i = 0, il = handlerArray.length; i < il; i ++ )
  {

    let handler = handlerArray[ i ];

    if( self.eventVerbosity )
    logger.log( event.kind, 'caught by', handler.onHandle.name );

    if( handler.proxy )
    {
      handler.onHandleEffective.call( self, event, o );
    }
    else
    {

      result.push( handler.onHandleEffective.call( self, event ) );
      if( o.until !== undefined )
      {
        if( result[ result.length-1 ] === o.until )
        {
          untilFound = 1;
          result = o.until;
          break;
        }
      }

    }

    if( handler.eclipse )
    break;

  }

  /* post */

  if( self.eventVerbosity )
  logger.down();

  if( o.single )
  result = result[ 0 ];

  if( o.until && !untilFound )
  result = undefined;

  return result;
}

//

/**
 * @summary Returns `Consequence` instance that gives a message when event fires. Message is given only once.
 * @param { String } kind - name of event
 * @method eventWaitFor
 * @module Tools/base/EventHandler
 * @namespace Tools
 * @class wEventHandler
 */

function eventWaitFor( kind )
{
  let self = this;
  let con = new _.Consequence();

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( kind ) );

  let descriptor =
  {
    kind,
    onHandle : function( e, o )
    {
      _.time.begin( 0, () => con.take( e ) );
    },
    eclipse : 0,
    once : 1,
    appending : 1,
  }

  self._eventHandlerRegister( descriptor );

  return con;
}

// --
// get
// --

function _eventHandlerDescriptorByKindAndOwner( kind, owner )
{
  let self = this;

  let handlers = self._eventHandler.descriptors;
  if( !handlers )
  return;

  handlers = handlers[ kind ];
  if( !handlers )
  return;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  function eq( a, b ){ return a.kind === b.kind && a.owner === b.owner; };
  let element = { kind, owner };
  let index = _.longRightIndex( handlers, element, eq );

  if( !( index >= 0 ) )
  return;

  let result = handlers[ index ];
  result.index = index;

  return result;
}

//

function _eventHandlerDescriptorByKindAndHandler( kind, onHandle )
{
  let self = this;

  let handlers = self._eventHandler.descriptors;
  if( !handlers )
  return;

  handlers = handlers[ kind ];
  if( !handlers )
  return;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  function eq( a, b ){ return a.kind === b.kind && a.onHandle === b.onHandle; };
  let element = { kind, onHandle };
  let index = _.longRightIndex( handlers, element, eq );

  if( !( index >= 0 ) )
  return;

  let result = handlers[ index ];
  result.index = index;

  return result;
}

//

function _eventHandlerDescriptorByHandler( onHandle )
{
  let self = this;

  _.assert( _.routineIs( onHandle ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let handlers = self._eventHandler.descriptors;
  if( !handlers )
  return;

  for( let h in handlers )
  {

    let index = _.longRightIndex( handlers[ h ], { onHandle }, ( a, b ) => a.onHandle === b.onHandle );

    if( index >= 0 )
    {
      handlers[ h ][ index ].index = index;
      return handlers[ h ][ index ];
    }

  }

}

//

function _eventHandlerDescriptorsByKind( kind )
{
  let self = this;

  _.assert( _.object.isBasic( self._eventHandler ) );

  // if( !self._eventHandler.descriptors )
  // debugger;

  let handlers = self._eventHandler.descriptors;
  handlers = handlers[ kind ] = handlers[ kind ] || [];

  return handlers;
}

//

function _eventHandlerDescriptorsAll()
{
  let self = this;
  let result = [];

  for( let d in self._eventHandler.descriptors )
  {
    let descriptor = self._eventHandler.descriptors[ d ];

    result.push( descriptor );

  }

  return result;
}

//

function eventHandlerDescriptorsFilter( filter )
{
  let self = this;
  let handlers =
  (
    filter.kind ? self._eventHandlerDescriptorsByKind( filter.kind ) : self._eventHandlerDescriptorsAll( filter.kind )
  );

  if( _.object.isBasic( filter ) )
  _.map.assertHasOnly( filter, eventHandlerDescriptorsFilter.defaults );

  let result = _.filter_( null, handlers, filter );

}

eventHandlerDescriptorsFilter.defaults =
{
  kind : null,
  onHandle : null,
  owner : null,
}

// --
// proxy
// --

function eventProxyTo( dstPrototype, rename )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.object.isBasic( dstPrototype ) || _.arrayIs( dstPrototype ) );
  _.assert( _.mapIs( rename ) || _.strIs( rename ) );

  if( _.arrayIs( dstPrototype ) )
  {
    for( let d = 0 ; d < dstPrototype.length ; d++ )
    self.eventProxyTo( dstPrototype[ d ], rename );
    return self;
  }

  /* */

  _.assert( _.routineIs( dstPrototype.eventGive ) );
  _.assert( _.routineIs( dstPrototype._eventGive ) );

  if( _.strIs( rename ) )
  {
    let r = Object.create( null );
    r[ rename ] = rename;
    rename = r;
  }

  /* */

  for( let r in rename ) ( function()
  {
    let name = r;
    _.assert( rename[ r ] && _.strIs( rename[ r ] ), 'eventProxyTo :', 'Expects name as string' );

    let descriptor =
    {
      kind : r,
      onHandle : function( event, o )
      {
        if( name !== rename[ name ] )
        {
          event = _.props.extend( null, event );
          event.kind = rename[ name ];
        }
        return dstPrototype._eventGive( event, o );
      },
      owner : dstPrototype,
      proxy : 1,
      appending : 1,
    }

    self._eventHandlerRegister( descriptor );

  })();

  return self;
}

//

function eventProxyFrom( src, rename )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.arrayIs( src ) )
  {
    for( let s = 0 ; s < src.length ; s++ )
    self.eventProxyFrom( src[ s ], rename );
    return self;
  }

  return src.eventProxyTo( self, rename );
}

// --
// relations
// --

let Groups =
{
  Events : 'Events',
}

let Composes =
{
}

let Restricts =
{

  eventVerbosity : 0,
  _eventHandler : _.define.own( {} ),

}

let Statics =
{

  strictEventHandling : 1,

}

let Events =
{
  init : 'init',
  finit : 'finit',
}

let Forbids =
{
  _eventHandlers : '_eventHandlers',
  _eventHandlerOwners : '_eventHandlerOwners',
  _eventHandlerDescriptors : '_eventHandlerDescriptors',
}

// --
// declaration
// --

let Supplement =
{

  // register

  _eventHandlerInit,
  _eventHandlerFinit,

  eventReport,

  eventHandlerPrepend,
  eventHandlerAppend,
  addEventListener : eventHandlerAppend,
  on : eventHandlerAppend,

  eventHandlerRegisterProvisional,
  provisional : eventHandlerRegisterProvisional,

  eventHandlerRegisterOneTime,
  once : eventHandlerRegisterOneTime,

  eventHandlerRegisterEclipse,
  eclipse : eventHandlerRegisterEclipse,

  _eventHandlerRegister,

  // unregister

  removeListener : eventHandlerRemove,
  removeEventListener : eventHandlerRemove,
  off : eventHandlerRemove,
  eventHandlerRemove,
  _eventHandlerRemove,

  eventHandlerRemoveByKindAndOwner,

  // handle

  dispatchEvent : eventGive,
  emit : eventGive,
  eventGive,
  eventHandleUntil,
  eventHandleSingle,

  _eventGive,

  eventWaitFor,

  // get

  _eventHandlerDescriptorByKindAndOwner,
  _eventHandlerDescriptorByKindAndHandler,
  _eventHandlerDescriptorByHandler,
  _eventHandlerDescriptorsByKind,
  _eventHandlerDescriptorsAll,
  eventHandlerDescriptorsFilter,

  // proxy

  eventProxyTo,
  eventProxyFrom,

  // relations

  Groups,
  Composes,
  Restricts,
  Statics,
  Events,
  Forbids,

}

//

let Functors =
{

  init,
  finit,

}

//

_.classDeclare
({
  cls : Self,
  supplement : Supplement,
  onMixinApply,
  functors : Functors,
  withMixin : true,
  withClass : true,
});

_.assert( _.mapIs( _.DefaultFieldsGroups ) );

// --
// export
// --

_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

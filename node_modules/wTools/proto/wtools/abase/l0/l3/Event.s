( function _l3_Event_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function _chainGenerate( args )
{
  let chain = [];

  _.assert( arguments.length === 1 );
  _.assert( _.longIs( args ) );

  for( let a = 0 ; a < args.length-2 ; a++ )
  chainMake( a );

  chain.push([ _.event.nameValueFrom( args[ args.length-2 ] ), args[ args.length-1 ] ]);

  _.assert( _.routine.is( args[ args.length-1 ] ) );

  return chain;

  /* */

  function chainMake( a )
  {
    let e1 = _.event.nameValueFrom( args[ a ] );
    chain.push([ e1, on ]);
    function on()
    {
      let self = this;
      let next = chain[ a + 1 ];

      if( _.routine.is( self.on ) )
      {
        /*
            Dmytro : it is strange code because the owners of edispatcher can be classes like Process.
            And this solution allows direct call of callbacks when the routine eventGive is not used :
            https://github.com/Wandalen/wProcess/blob/master/proto/wtools/abase/l4_process/Basic.s#L210
            https://github.com/Wandalen/wProcedure/blob/master/proto/wtools/abase/l8_procedure/Namespace.s#L59
        */
        self.on( next[ 0 ], next[ 1 ] );
        if( self.eventHasHandler( e1, on ) )
        self.off( e1, on );
      }
      else
      {
        let o = _.event.onHead( _.event.on, next );
        o.once = on.once;
        _.event._on( self, o );

        if( !on.once )
        if( _.event.eventHasHandler( self, { eventName : e1, eventHandler : on } ) )
        _.event.off( self, { callbackMap : { [ e1 ] : on } } );
      }

    }
  }
}

//

function _chainToCallback( args )
{
  let chain = _.event._chainGenerate( args );
  let firstPair = chain[ 0 ];
  return firstPair[ 1 ];
}

//

function _chainValidate( chain )
{

  for( let i = 0 ; i < chain.length - 1 ; i++ )
  {
    _.assert( _.event.nameIs( chain[ i ] ) );
  }
  _.assert( _.routine.is( chain[ chain.length - 1 ] ) );

  return true;
}

//

function _callbackMapValidate( callbackMap )
{

  _.assert( _.mapIs( callbackMap ) );
  for( let k in callbackMap )
  {
    let callback = callbackMap[ k ];
    _.assert( _.routine.is( callback ) || _.longIs( callback ) );
    if( _.routine.is( callback ) )
    continue;
    _.event._chainValidate( callback );
  }

}

//

function nameValueFrom( name )
{
  if( _.strIs( name ) )
  return name;
  _.assert( _.event.nameIs( name ) );
  return name.value;
}

//

function nameIs( name )
{
  return name instanceof _.event.Name;
}

//

/**
 * The routine chainIs() checks of whether the passed value {-src-} is an instance of wTools.event.Chain.
 *
 * @example
 * var chain = { chain : [ 'event1', 'event2' ] };
 * console.log( _.event.chainIs( chain ) );
 * // log : false
 *
 * @example
 * var chain = _.event.chain( 'event1', 'event2' );
 * console.log( _.event.chainIs( chain ) );
 * // log : true
 *
 * @param { * } src - The value to check.
 * @returns { Boolean } - Returns true if {-src-} is an instance of class wTools.event.Chain.
 * Otherwise, routine returns false.
 * @function chainIs
 * @namespace wTools.event
 * @extends Tools
 */

function chainIs( src )
{
  return src instanceof _.event.Chain;
}

//

/*
_.process.on( 'available', _.event.Name( 'exit' ), _.event.Name( 'exit' ), _.procedure._eventProcessExitHandle )
->
_.process.on( _.event.Chain( 'available', 'exit', 'exit' ), _.procedure._eventProcessExitHandle )
*/

/* qqq for Dmytro : remove the class */
function Name( name )
{
  if( !( this instanceof Name ) )
  {
    if( _.event.nameIs( name ) )
    return name;
    return new Name( ... arguments );
  }
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ) );
  this.value = name;
  return this;
}

Name.prototype = Object.create( null );

//

/**
 * The routine Chain() implements class Chain. The instance of the class holds chain of event names.
 *
 * @example
 * var chain = _.event.chain( 'event1', 'event2' );
 * console.log( _.event.chainIs( chain ) );
 * // log : true
 * console.log( chain.chain );
 * // log : [ 'event1', 'event2' ]
 *
 * @example
 * var name1 = _.event.Name( 'event1' );
 * var name2 = _.event.Name( 'event2' );
 * var chain = _.event.chain( name1, name2 );
 * console.log( _.event.chainIs( chain ) );
 * // log : true
 * console.log( chain.chain.length );
 * // log : 2
 * console.log( chain.chain[ 0 ] === name1 );
 * // log : true
 * console.log( chain.chain[ 1 ] === name2 );
 * // log : true
 *
 * @param { String|wTools.event.Name|wTools.event.Chain } ... arguments - The set of event names of single instance of Chain.
 * @returns { wTools.event.Chain } - Returns instance of class.
 * @function Chain
 * @class wTools.event.Chain
 * @throws { Error } If arguments.length is less than 1.
 * @throws { Error } If arguments have incompatible type.
 * @throws { Error } If arguments contain instance of Chain and another elements.
 * @namespace wTools.event
 * @extends Tools
 */

function Chain()
{
  if( !( _.event.chainIs( this ) ) )
  {
    if( _.event.chainIs( arguments[ 0 ] ) )
    {
      _.assert( arguments.length === 1, 'Expects single Chain or set of event names' );
      return arguments[ 0 ];
    }
    return new Chain( ... arguments );
  }

  let result = _.array.make( arguments.length );
  _.assert( arguments.length >= 1, 'Expects events names' );
  for( let i = 0 ; i < arguments.length ; i++ )
  result[ i ] = _.event.Name( arguments[ i ] );

  this.chain = result;
  return this;
}

Chain.prototype = Object.create( null );

//

function onHead( routine, args )
{
  let o;

  _.assert( _.longIs( args ) );
  _.assert( arguments.length === 2 );

  if( args.length === 2 )
  {
    _.assert( _.routine.is( args[ 1 ] ) );

    o = Object.create( null );
    o.callbackMap = Object.create( null );

    if( _.event.chainIs( args[ 0 ] ) )
    {
      let chain = args[ 0 ].chain;
      o.callbackMap[ chain[ 0 ].value ] = _.longOnly_( null, chain, [ 1, chain.length - 1 ] );
      o.callbackMap[ chain[ 0 ].value ].push( args[ 1 ] );
    }
    else if( _.strIs( args[ 0 ] ) )
    {
      o.callbackMap[ args[ 0 ] ] = args[ 1 ];
    }
    else if( _.event.nameIs( args[ 0 ] ) )
    {
      o.callbackMap[ args[ 0 ].value ] = args[ 1 ];
    }
    else
    {
      _.assert( 0, 'Expects Chain with names or single name of event.' );
    }
  }
  else if( args.length === 1 )
  {
    o = args[ 0 ];
  }
  else
  {
    _.assert( 0, 'Expects single options map {-o-} or events Chain and callback as arguments.' );
  }

  if( Config.debug )
  {
    _.assert( _.mapIs( o ) );
    _.event._callbackMapValidate( o.callbackMap );
  }

  // _.event._callbackMapNormalize( o.callbackMap );

  return o;
}

//

function _on( edispatcher, o )
{

  _.routine.options( _on, o );
  _.assert( _.mapIs( o.callbackMap ) );
  _.assert( _.object.isBasic( edispatcher ) );
  _.assert( _.object.isBasic( edispatcher.events ) );
  _.map.assertHasOnly( o.callbackMap, edispatcher.events, 'Unknown kind of event' );
  _.assert( arguments.length === 2 );

  const once = !!o.once;
  let descriptors = Object.create( null );
  let append;
  if( o.first )
  append = _.arrayPrepend;
  else
  append = _.arrayAppend;

  for( let c in o.callbackMap )
  {
    let callback = o.callbackMap[ c ];
    descriptors[ c ] = descriptorMake();

    if( _.longIs( callback ) )
    callback = _.event._chainToCallback([ c, ... callback ]);

    _.assert( _.routine.is( callback ) );

    callback = callbackOn_functor.call( descriptors[ c ], callback, c );
    descriptors[ c ].off = off_functor.call( descriptors[ c ], edispatcher, { callbackMap : { [ c ] : callback } } );

    append( edispatcher.events[ c ], callback );

    // if( o.first )
    // _.arrayPrepend( edispatcher.events[ c ], callback );
    // else
    // _.arrayAppend( edispatcher.events[ c ], callback );

    /* */

  }

  return descriptors;

  /* */

  // function callbackOn_functor( callback ) /* Dmytro : can't extract name from descriptor. Maybe, it can contains field `name` */
  function callbackOn_functor( callback, name )
  {
    let self = this;

    function callbackOn()
    {
      let result;
      if( self.enabled )
      {
        result = callback.apply( this, arguments );
        if( once === true )
        _.event.off( edispatcher, { callbackMap : { [ name ] : callbackOn } } );
        // _.event.off( edispatcher, { callbackMap : { [ name ] : callbackOnce } } ); /* Dmytro : callbackOnce does not exist */
      }
      return result;
    }
    callbackOn.native = callback;
    callbackOn.native.once = once;

    return callbackOn;
  }

  /* */

  function descriptorMake()
  {
    let descriptor = Object.create( null );
    descriptor.off = null;
    descriptor.enabled = true;
    descriptor.first = o.first; /* Dmytro : please, explain, does it need to save original value? */
    descriptor.callbackMap = o.callbackMap; /* Dmytro : please, explain, does it need to save link to original callback map? */
    return descriptor;
  }

  /* */

  function off_functor( edispatcher, o )
  {
    let self = this;

    return function()
    {
      _.assert( arguments.length === 0, 'Expects no arguments.' );
      return _.event.off( edispatcher, o );
    }
  }

  /* */

}

_on.defaults =
{
  callbackMap : null,
  first : false,
  once : false,
}

// const on = _.routine.uniteCloning( on_head, on_body );
// on.defaults.once = false;

//

function on( edispatcher, o )
{
  o.once = false;
  return _.event._on( edispatcher, o );
}

// //
//
// function on( edispatcher, o )
// {
//
//   // if( _.longIs( o.callbackMap ) )
//   // o.callbackMap = callbackMapFromChain( o.callbackMap );
//
//   _.routine.options( on, o );
//   _.assert( _.mapIs( o.callbackMap ) );
//   _.assert( _.object.isBasic( edispatcher ) );
//   _.assert( _.object.isBasic( edispatcher.events ) );
//   _.map.assertHasOnly( o.callbackMap, edispatcher.events, 'Unknown kind of event' );
//   _.assert( arguments.length === 2 );
//
//   let descriptors = Object.create( null );
//
//   for( let c in o.callbackMap )
//   {
//     let callback = o.callbackMap[ c ];
//     descriptors[ c ] = descriptorMake();
//
//     if( _.longIs( callback ) )
//     callback = _.event._chainToCallback([ c, ... callback ]);
//
//     _.assert( _.routine.is( callback ) );
//
//     callback = callbackOn_functor.call( descriptors[ c ], callback );
//     descriptors[ c ].off = off_functor.call( descriptors[ c ], edispatcher, { callbackMap : { [ c ] : callback } } );
//
//     if( o.first )
//     _.arrayPrepend( edispatcher.events[ c ], callback );
//     else
//     _.arrayAppend( edispatcher.events[ c ], callback );
//
//     /* */
//
//   }
//
//   return descriptors;
//
//   /* */
//
//   function callbackOn_functor( callback )
//   {
//     let self = this;
//
//     function callbackOn()
//     {
//       let result;
//       if( self.enabled )
//       result = callback.apply( this, arguments );
//       return result;
//     }
//     callbackOn.native = callback;
//
//     return callbackOn;
//   }
//
//   /* */
//
//   function descriptorMake()
//   {
//     let descriptor = Object.create( null );
//     descriptor.off = null;
//     descriptor.enabled = true;
//     descriptor.first = o.first; /* Dmytro : please, explain, does it need to save original value? */
//     descriptor.callbackMap = o.callbackMap; /* Dmytro : please, explain, does it need to save link to original callback map? */
//     return descriptor;
//   }
//
//   /* */
//
//   function off_functor( edispatcher, o )
//   {
//     let self = this;
//
//     return function()
//     {
//       _.assert( arguments.length === 0, 'Expects no arguments.' );
//       return _.event.off( edispatcher, o );
//     }
//   }
//
//   /* */
//
// }
//
// on.head = on_head;
// on.defaults =
// {
//   callbackMap : null,
//   first : 0,
// };

// //
//
// function on( edispatcher, o )
// {
//
//   // if( _.longIs( o.callbackMap ) )
//   // o.callbackMap = callbackMapFromChain( o.callbackMap );
//
//   _.routine.options( on, o );
//   _.assert( _.mapIs( o.callbackMap ) );
//   _.assert( _.object.isBasic( edispatcher ) );
//   _.assert( _.object.isBasic( edispatcher.events ) );
//   _.map.assertHasOnly( o.callbackMap, edispatcher.events, 'Unknown kind of event' );
//   _.assert( arguments.length === 2 );
//
//   let descriptors = Object.create( null );
//
//   for( let c in o.callbackMap )
//   {
//     let callback = o.callbackMap[ c ];
//     descriptors[ c ] = descriptorMake();
//
//     if( _.longIs( callback ) )
//     callback = _.event._chainToCallback([ c, ... callback ]);
//
//     _.assert( _.routine.is( callback ) );
//
//     callback = callbackOn_functor.call( descriptors[ c ], callback );
//     descriptors[ c ].off = off_functor.call( descriptors[ c ], edispatcher, { callbackMap : { [ c ] : callback } } );
//
//     if( o.first )
//     _.arrayPrepend( edispatcher.events[ c ], callback );
//     else
//     _.arrayAppend( edispatcher.events[ c ], callback );
//
//     /* */
//
//   }
//
//   return descriptors;
//
//   /* */
//
//   function callbackOn_functor( callback )
//   {
//     let self = this;
//
//     function callbackOn()
//     {
//       let result;
//       if( self.enabled )
//       result = callback.apply( this, arguments );
//       return result;
//     }
//     callbackOn.native = callback;
//
//     return callbackOn;
//   }
//
//   /* */
//
//   function descriptorMake()
//   {
//     let descriptor = Object.create( null );
//     descriptor.off = null;
//     descriptor.enabled = true;
//     descriptor.first = o.first; /* Dmytro : please, explain, does it need to save original value? */
//     descriptor.callbackMap = o.callbackMap; /* Dmytro : please, explain, does it need to save link to original callback map? */
//     return descriptor;
//   }
//
//   /* */
//
//   function off_functor( edispatcher, o )
//   {
//     let self = this;
//
//     return function()
//     {
//       _.assert( arguments.length === 0, 'Expects no arguments.' );
//       return _.event.off( edispatcher, o );
//     }
//   }
//
//   /* */
//
// }
//
// on.head = on_head;
// on.defaults =
// {
//   callbackMap : null,
//   first : 0,
// };

//

/**
 * The routine once() registers callback of some kind in event handler {-edispatcher-}.
 * Registered callback executes once and deleted from queue.
 *
 * @example
 * let edispatcher = { events : { begin : [] } };
 * let result = [];
 * let onBegin = () => result.push( result.length );
 * console.log( edispatcher.events.begin.length );
 * // log : 0
 * _.event.once( edispatcher, { callbackMap : { begin : onBegin } } );
 * console.log( edispatcher.events.begin.length );
 * // log : 1
 * console.log( result );
 * // log : []
 *
 * @example
 * let edispatcher = { events : { begin : [] } };
 * let result = [];
 * let onBegin = () => result.push( result.length );
 * _.event.once( edispatcher, { callbackMap : { begin : onBegin } } );
 * _.event.eventGive( edispatcher, 'begin' );
 * console.log( edispatcher.events.begin.length );
 * // log : 0
 * console.log( result );
 * // log : [ 0 ]
 *
 * @example
 * let edispatcher = { events : { begin : [], end : [] } };
 * let result = [];
 * let onBegin = () => result.push( result.length );
 * let onBegin2 = () => result.push( result.length + 1 );
 * let onEnd = result.splice();
 * _.event.once( edispatcher, { callbackMap : { begin : onBegin } } );
 * _.event.once( edispatcher, { callbackMap : { begin : onBegin2 } } );
 * _.event.once( edispatcher, { callbackMap : { end : onEnd } } );
 * _.event.eventGive( edispatcher, 'begin' );
 * console.log( edispatcher.events.begin.length );
 * // log : 0
 * console.log( result );
 * // log : [ 0, 2 ]
 * _.event.eventGive( edispatcher, 'end' );
 * console.log( result );
 * // log : []
 *
 * @param { Object } edispatcher - The events handler with map of available events.
 * @param { Map|Aux } o - Options map.
 * @param { Map } o.callbackMap - Map with pairs: [ eventName ] : [ callback ]. The value
 * [ callback ] can be a Function or Array with callbacks.
 * @param { Boolean|BoolLike } o.first - If it has value `true`, then callback prepends to callback queue.
 * Otherwise, callback appends to callback queue.
 * @returns { Map|Aux } - Returns options map {-o-}.
 * @function once
 * @throws { Error } If arguments.length is not equal to 2.
 * @throws { Error } If {-edispatcher-} is not an Object.
 * @throws { Error } If {-edispatcher.events-} is not an Object.
 * @throws { Error } If {-o-} has incompatible type.
 * @throws { Error } If {-o-} has extra options.
 * @throws { Error } If {-o.callbackMap-} is not a Map.
 * @throws { Error } If {-o.callbackMap-} has events than does not exist in map {-edispatcher.events-}.
 * @namespace wTools.event
 * @extends Tools
 */

// const once = _.routine.uniteCloning( on_head, on_body );
// once.defaults.once = true;
// _.assert( on.defaults.once === false );

function once( edispatcher, o )
{
  o.once = true;
  return _.event._on( edispatcher, o );
}

/* qqq : for Dmytro : bad! */
// function once( edispatcher, o )
// {
//
//   _.routine.options( once, o );
//   _.assert( _.mapIs( o.callbackMap ) );
//   _.assert( _.object.isBasic( edispatcher ) );
//   _.assert( _.object.isBasic( edispatcher.events ) );
//   _.map.assertHasOnly( o.callbackMap, edispatcher.events, 'Unknown kind of event' );
//   _.assert( arguments.length === 2 );
//
//   let descriptors = Object.create( null );
//
//   for( let c in o.callbackMap )
//   {
//     let callback = o.callbackMap[ c ];
//     descriptors[ c ] = descriptorMake();
//
//     if( _.longIs( callback ) )
//     {
//       let length = callback.length;
//       _.assert( _.routine.is( callback[ length - 1 ] ), 'Expects routine to execute.' );
//
//       let name = callback[ length - 2 ] || c;
//       name = name.value !== undefined ? name.value : name;
//       callback[ length - 1 ] = callbackOnce_functor.call( descriptors[ c ], name, callback[ length - 1 ] );
//       callback = _.event._chainToCallback([ c, ... callback ]);
//     }
//     else
//     {
//       callback = callbackOnce_functor.call( descriptors[ c ], c, callback );
//     }
//     descriptors[ c ].off = off_functor.call( descriptors[ c ], edispatcher, { callbackMap : { [ c ] : callback } } );
//
//     _.assert( _.routine.is( callback ) );
//
//     callbackAdd( edispatcher, c, callback );
//   }
//
//   return descriptors;
//
//   /* */
//
//   function callbackOnce_functor( name, callback )
//   {
//     let self = this;
//
//     function callbackOnce()
//     {
//       let result;
//       if( self.enabled )
//       {
//         callback.apply( this, arguments );
//         _.event.off( edispatcher, { callbackMap : { [ name ] : callbackOnce } } );
//       }
//       return result;
//     }
//     callbackOnce.native = callback; /* Dmytro : this solution does not affects original callback and interfaces of calls. And simultaneously it slow down searching in routine `off` */
//
//     return callbackOnce;
//   }
//
//   /* */
//
//   function callbackAdd( handler, name, callback )
//   {
//     if( o.first )
//     _.arrayPrepend( handler.events[ name ], callback );
//     else
//     _.arrayAppend( handler.events[ name ], callback );
//   }
//
//   /* */
//
//   function descriptorMake()
//   {
//     let descriptor = Object.create( null );
//     descriptor.off = null;
//     descriptor.enabled = true;
//     descriptor.first = o.first; /* Dmytro : please, explain, does it need to save original value? */
//     descriptor.callbackMap = o.callbackMap; /* Dmytro : please, explain, does it need to save link to original callback map? */
//
//     return descriptor;
//   }
// }
//
// once.head = on_head;
// once.defaults =
// {
//   callbackMap : null,
//   first : 0,
// };

//

/**
 * The routine off() removes callback of some kind in event handler {-edispatcher-}.
 *
 * @example
 * let onBegin = () => result.push( result.length );
 * let onBegin2 = () => result.push( result.length );
 * let edispatcher = { events : { begin : [ onBegin, onBegin2 ] } };
 * _.event.off( edispatcher, { callbackMap : { begin : onBegin } } );
 * console.log( edispatcher.events.begin.length );
 * // log : 1
 * console.log( edispatcher.events.begin[ 0 ] === onBegin2 );
 * // log : true
 *
 * @example
 * let onBegin = () => result.push( result.length );
 * let onBegin2 = () => result.push( result.length );
 * let edispatcher = { events : { begin : [ onBegin, onBegin2 ] } };
 * _.event.off( edispatcher, { callbackMap : { begin : null } } );
 * console.log( edispatcher.events.begin.length );
 * // log : 0
 *
 * @param { Object } edispatcher - The events handler with map of available events.
 * @param { Map|Aux } o - Options map.
 * @param { Map } o.callbackMap - Map with pairs: [ eventName ] : [ callback ]. The value
 * [ callback ] can be a Function or Null. If null is provided, routine removes all callbacks.
 * @returns { Map|Aux } - Returns options map {-o-}.
 * @function off
 * @throws { Error } If arguments.length is not equal to 2.
 * @throws { Error } If {-edispatcher-} is not an Object.
 * @throws { Error } If {-edispatcher.events-} is not an Object.
 * @throws { Error } If {-o-} has incompatible type.
 * @throws { Error } If {-o-} has extra options.
 * @throws { Error } If {-o.callbackMap-} is not a Map.
 * @throws { Error } If {-o.callbackMap-} has events than does not exist in map {-edispatcher.events-}.
 * @throws { Error } If {-edispatcher.events-} callback queue has a few callbacks
 * which should be removed separately.
 * @namespace wTools.event
 * @extends Tools
 */

function offHead( routine, args )
{

  _.assert( _.longIs( args ) );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ];
  if( args.length === 2 )
  o = { callbackMap : { [ args[ 0 ] ] : args[ 1 ] } }
  else if( _.strIs( args[ 0 ] ) )
  o = { callbackMap : { [ args[ 0 ] ] : null } }

  _.assert( _.mapIs( o ) );

  return o;
}

//

function off( edispatcher, o )
{

  _.routine.options( off, o );
  _.assert( _.mapIs( o.callbackMap ) );
  _.assert( _.object.isBasic( edispatcher ) );
  _.assert( _.object.isBasic( edispatcher.events ) );
  _.map.assertHasOnly( o.callbackMap, edispatcher.events, 'Unknown kind of event' );
  _.assert( arguments.length === 2 );

  for( let c in o.callbackMap )
  {
    if( o.callbackMap[ c ] === null )
    _.array.empty( edispatcher.events[ c ] );
    else
    _.arrayRemoveOnceStrictly( edispatcher.events[ c ], o.callbackMap[ c ], callbackEqualize );
  }

  return o;

  /* */

  function callbackEqualize( callback, handler )
  {
    return handler === callback || handler === callback.native;
  }
}

// off.head = off_head;
off.defaults =
{
  callbackMap : null,
}

//

function eventHasHandlerHead( routine, args )
{
  let o;

  _.assert( _.longIs( args ) );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  if( args.length > 1 )
  {
    o = Object.create( null );
    o.eventName = args[ 0 ];
    o.eventHandler = args[ 1 ];
  }
  else
  {
    o = args[ 0 ]
  }

  _.assert( _.mapIs( o ) );

  return o;
}

//

/* xxx */
function eventHasHandler( edispatcher, o )
{

  _.routine.options( eventHasHandler, o );
  _.assert( _.strIs( o.eventName ) );
  _.assert( _.routine.is( o.eventHandler ) );
  _.assert( _.mapIs( edispatcher ) );
  _.assert( _.mapIs( edispatcher.events ) );
  _.assert( arguments.length === 2 );

  return _.longHas( edispatcher.events[ o.eventName ], o.eventHandler, handlerEqualize );

  /* */

  function handlerEqualize( callback, handler )
  {
    return handler === callback || handler === callback.native;
  }
}

// eventHasHandler.head = eventHasHandler_head;
eventHasHandler.defaults =
{
  eventName : null,
  eventHandler : null,
}

//

function eventGiveHead( edispatcher, routine, args )
{
  let o = args[ 0 ];

  _.assert( arguments.length === 3, 'Expects exactly three arguments.' );
  _.assert( args.length > 0 );
  _.assert( _.aux.is( edispatcher.events ), 'Expects events dispatcher.' );

  if( _.strIs( o ) )
  o = { event : o };
  _.assert( _.aux.is( o ), 'Expects string or options map in {-o.args[ 1 ]-}.' ); /* Dmytro : restrict using options map in first argument */

  if( o.onError === null || o.onError === undefined )
  o.onError = onError;

  _.map.assertHasOnly( o, routine.defaults );

  if( o.args )
  _.assert( args.length === 1 ); /* Dmytro : restrict using options map in first argument */
  else /* Dmytro : do not overwrite arguments if the field exists */
  o.args = args;

  // if( o.args === null )
  // {
  //   o.args = [ Object.create( null ) ];
  //   o.args[ 0 ].event = o.event;
  // }

  return o;

  /* */

  function onError( err, o )
  {
    throw _.err( `Error on handing event ${o.event}\n`, err );
  }
}

//

function eventGive( edispatcher, o )
{

  // if( _.strIs( o ) )
  // o = { event : o }
  // _.routine.options( eventGive, o );
  //
  // if( o.onError === null )
  // o.onError = onError;
  // if( o.args === null )
  // {
  //   o.args = [ Object.create( null ) ];
  //   o.args[ 0 ].event = o.event;
  // }

  _.assert( arguments.length === 2 );
  _.assert( !!edispatcher.events[ o.event ], `Unknown event ${o.event}` );
  _.assert( _.long.is( o.args ), 'Expects arguments {-o.args-}' );

  let was;
  let visited = [];
  do
  {
    was = visited.length;
    let events = edispatcher.events[ o.event ].slice();
    _.each( events, ( callback ) =>
    {
      if( _.longHas( visited, callback ) )
      return;
      visited.push( callback );
      try
      {
        callback.apply( edispatcher, o.args );
      }
      catch( err )
      {
        o.onError( err, o );
      }
    });
  }
  while( was !== visited.length );

  /* */

  // function onError( err, o )
  // {
  //   throw _.err( `Error on handing event ${o.event}\n`, err );
  // }

}

eventGive.defaults =
{
  event : null,
  args : null,
  onError : null,
}

// --
// extension
// --

let Extension =
{

  _chainGenerate,
  _chainToCallback,
  _chainValidate,
  _callbackMapValidate,

  nameValueFrom,
  nameIs,
  chainIs,
  Name,
  Chain,

  onHead,
  _on,
  on,
  once,
  offHead,
  off,
  // off_functor,

  eventHasHandlerHead,
  eventHasHandler,
  eventGiveHead,
  eventGive,

}

Object.assign( _.event, Extension );

})();

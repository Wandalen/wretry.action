( function _Namespace_s_()
{

'use strict';

/**
 * Advanced synchronization mechanism. Asynchronous routines may use Consequence to wrap postponed result, what allows classify callback for such routines as output, not input, what improves analyzability of a program. Consequence may be used to make a queue for mutually exclusive access to a resource. Algorithmically speaking Consequence is 2 queues ( FIFO ) and a customizable arbitrating algorithm. The first queue contains available resources, the second queue includes competitors for this resources. At any specific moment, one or another queue may be empty or full. Arbitrating algorithm makes resource available for a competitor as soon as possible. There are 2 kinds of resource: regular and erroneous. Unlike Promise, Consequence is much more customizable and can solve engineering problem which Promise cant. But have in mind with great power great responsibility comes. Consequence can coexist and interact with a Promise, getting fulfillment/rejection of a Promise or fulfilling it. Use Consequence to get more flexibility and improve readability of asynchronous aspect of your application.
  @module Tools/base/Consequence
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  _.include( 'wProto' );
  _.include( 'wCopyable' );
  _.include( 'wProcedure' );
}

const _global = _global_;
const _ = _global_.wTools;

_.assert( !_.Consequence, 'Consequence included several times' );

// --
// time
// --

/**
 * The routine sleep() suspends program execution on time delay {-delay-}.
 *
 * @example
 * let result = [];
 * let periodic = _.time.periodic( 100, () => result.length < 10 ? result.push( 1 ) : undefined );
 * let before = _.time.now();
 *  _.time.sleep( 500 );
 * console.log( result.length <= 1 );
 * // log : true
 * let after = _.time.now();
 * let delta = after - before;
 * console.log( delta <= 550 );
 * // log : true
 *
 * @param { Number } delay - The delay to suspend program.
 * @returns { Undefined } - Returns not a value, suspends program.
 * @function sleep
 * @throws { Error } If arguments.length is less then 1 or great then 2.
 * @throws { Error } If {-delay-} is not a Number.
 * @throws { Error } If {-delay-} is less then zero.
 * @throws { Error } If {-delay-} has not finite value.
 * @namespace wTools.time
 * @extends Tools
 */

function sleep( delay )
{
  _.assert( arguments.length === 1 );
  _.assert( _.intIs( delay ) && delay >= 0, 'Specify valid value {-delay-}.' );
  let con = new _.Consequence().take( null );
  con.delay( delay ).deasync();
}

//

/**
 * Routine creates timer that executes provided routine( onReady ) after some amout of time( delay ).
 * Returns wConsequence instance. {@link module:Tools/base/Consequence.wConsequence wConsequence}
 *
 * If ( onReady ) is not provided, time.out returns consequence that gives empty message after ( delay ).
 * If ( onReady ) is a routine, time.out returns consequence that gives message with value returned or error throwed by ( onReady ).
 * If ( onReady ) is a consequence or routine that returns it, time.out returns consequence and waits until consequence from ( onReady ) resolves the message, then
 * time.out gives that resolved message throught own consequence.
 * If ( delay ) <= 0 time.out performs all operations on nextTick in node
 * @see {@link https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/#the-node-js-event-loop-timers-and-process-nexttick }
 * or after 1 ms delay in browser.
 * Returned consequence controls the timer. Timer can be easly stopped by giving an error from than consequence( see examples below ).
 * Important - Error that stops timer is returned back as regular message inside consequence returned by time.out.
 * Also time.out can run routine with different context and arguments( see example below ).
 *
 * @param {Number} delay - Delay in ms before ( onReady ) is fired.
 * @param {Function|wConsequence} onReady - Routine that will be executed with delay.
 *
 * @example
 * // simplest, just timer
 * let t = _.time.out( 1000 );
 * t.give( () => console.log( 'Message with 1000ms delay' ) )
 * console.log( 'Normal message' )
 *
 * @example
 * // run routine with delay
 * let routine = () => console.log( 'Message with 1000ms delay' );
 * let t = _.time.out( 1000, routine );
 * t.give( () => console.log( 'Routine finished work' ) );
 * console.log( 'Normal message' )
 *
 * @example
 * // routine returns consequence
 * let routine = () => new _.Consequence().take( 'msg' );
 * let t = _.time.out( 1000, routine );
 * t.give( ( err, got ) => console.log( 'Message from routine : ', got ) );
 * console.log( 'Normal message' )
 *
 * @example
 * // time.out waits for long time routine
 * let routine = () => _.time.out( 1500, () => 'work done' ) ;
 * let t = _.time.out( 1000, routine );
 * t.give( ( err, got ) => console.log( 'Message from routine : ', got ) );
 * console.log( 'Normal message' )
 *
 * @example
 * // how to stop timer
 * let routine = () => console.log( 'This message never appears' );
 * let t = _.time.out( 5000, routine );
 * t.error( 'stop' );
 * t.give( ( err, got ) => console.log( 'Error returned as regular message : ', got ) );
 * console.log( 'Normal message' )
 *
 * @example
 * // running routine with different context and arguments
 * function routine( y )
 * {
 *   let self = this;
 *   return self.x * y;
 * }
 * let context = { x : 5 };
 * let arguments = [ 6 ];
 * let t = _.time.out( 100, context, routine, arguments );
 * t.give( ( err, got ) => console.log( 'Result of routine execution : ', got ) );
 *
 * @returns {wConsequence} Returns wConsequence instance that resolves message when work is done.
 * @throws {Error} If ( delay ) is not a Number.
 * @throws {Error} If ( onEnd ) is not a routine or wConsequence instance.
 * @function time.out
 * @namespace Tools
 */

function out_head( routine, args )
{
  let o, procedure;

  _.assert( arguments.length === 2 );
  _.assert( !!args );

  if( _.procedureIs( args[ 1 ] ) )
  {
    procedure = args[ 1 ];
    args = _.longBut_( args, [ 1, 1 ] );
    // args = _.longBut( args, [ 1, 2 ] );
  }

  if( _.mapIs( args[ 0 ] ) )
  {
    o = args[ 0 ];
  }
  else
  {
    if( args.length === 1 || args.length === 2 )
    {
      let delay = args[ 0 ];
      let onEnd = args[ 1 ];

      if( onEnd !== undefined && !_.routineIs( onEnd ) && !_.consequenceIs( onEnd ) )
      {
        _.assert( args.length === 2, 'Expects two arguments if second one is not callable' );
        _.assert( !routine.defaults.error, 'Time out throwing error should have callback to attend it' ); /* qqq : cover */
        let returnOnEnd = args[ 1 ];
        onEnd = function onEnd()
        {
          return returnOnEnd;
        }
      }

      if( onEnd === undefined )
      o = { delay }
      else
      o = { delay, onEnd }
    }
    else
    {
      _.assert( args.length <= 4 );

      let delay = args[ 0 ];
      let onEnd = _.routineJoin.call( _, args[ 1 ], args[ 2 ], args[ 3 ] );  /* qqq : cover by separate test routine */

      o = { delay, onEnd }
    }
  }


  // if( !_.mapIs( args[ 0 ] ) || args.length === 2 )
  // if( !_.mapIs( args[ 0 ] ) )
  // {
  //   if( args.length === 1 || args.length === 2 )
  //   {
  //     let delay = args[ 0 ];
  //     let onEnd = args[ 1 ];
  //
  //     if( onEnd !== undefined && !_.routineIs( onEnd ) && !_.consequenceIs( onEnd ) )
  //     {
  //       _.assert( args.length === 2, 'Expects two arguments if second one is not callable' );
  //       _.assert( !routine.defaults.error, 'Time out throwing error should have callback to attend it' ); /* qqq : cover */
  //       let returnOnEnd = args[ 1 ];
  //       onEnd = function onEnd()
  //       {
  //         return returnOnEnd;
  //       }
  //     }
  //     // else if( _.routineIs( onEnd ) && !_.consequenceIs( onEnd ) )
  //     // {
  //     //   let _onEnd = onEnd;
  //     //   onEnd = function timeOutEnd( timer )
  //     //   {
  //     //     let result = _onEnd.apply( this, arguments );
  //     //     return result === undefined ? timer : result;
  //     //   }
  //     // }
  //
  //     o = { delay, onEnd }
  //   }
  //   else
  //   {
  //
  //     _.assert( args.length <= 4 );
  //
  //     // if( args[ 1 ] !== undefined && args[ 2 ] === undefined && args[ 3 ] === undefined )
  //     // _.assert( _.routineIs( onEnd ) || _.consequenceIs( onEnd ) );
  //     // else if( args[ 2 ] !== undefined || args[ 3 ] !== undefined )
  //     // _.assert( _.routineIs( args[ 2 ] ) );
  //     //
  //     // if( args[ 2 ] !== undefined || args[ 3 ] !== undefined )
  //
  //     let delay = args[ 0 ];
  //     let onEnd = _.routineJoin.call( _, args[ 1 ], args[ 2 ], args[ 3 ] );  /* qqq : cover by separate test routine */
  //
  //     o = { delay, onEnd }
  //   }
  // }
  // else
  // {
  //   o = args[ 0 ];
  // }

  _.assert( _.mapIs( o ) );

  if( procedure )
  o.procedure = procedure;

  _.routine.options_( routine, o );
  _.assert( _.numberIs( o.delay ) );
  _.assert( o.onEnd === null || _.routineIs( o.onEnd ) );

  return o;
}

//

function out_body( o )
{
  let con = new _.Consequence();
  let timer = null;

  _.routine.assertOptions( out_body, arguments );

  /* */

  if( o.procedure === null )
  o.procedure = _.Procedure( 3 ).name( 'time.out' ); /* delta : 3 to not include info about `routine.unite` in the stack */
  _.assert( _.procedureIs( o.procedure ) );

  if( Config.debug )
  if( con.tag === null )
  con.tag = 'time.out';
  con.procedure( o.procedure.clone() );
  con.finally( timeEnd2 );

  /* */

  timer = _.time.begin( o.delay, o.procedure, timeEnd1 );

  return con;

  /* */

  function timeEnd2( err, arg )
  {
    if( _.time.timerInEndBegun( timer ) )
    {
      if( _.consequenceIs( o.onEnd ) )
      {
        arg = o.onEnd;
        err = undefined;
      }
      else
      {
        if( o.onEnd )
        arg = o.onEnd.call( timer, err ? err : arg );
        if( arg === undefined )
        arg = timer;
        else
        err = undefined;
      }
    }
    else
    {
      _.time.cancel( timer );
      if( Config.debug )
      if( !_.symbolIs( err ) )
      {
        let err2 = _.err
        (
          'Only symbol in error channel of conseqeucne should be used to cancel timer.'
          + '\nFor example: "consequence.error( _.dont );"'
          + ( err === undefined ? `` : `\nError of type ${_.entity.strType( err )} was recieved instead` )
          + ( err === undefined ? `\nArgument of type ${_.entity.strType( arg )} was recieved instead` : `` )
        );
        _.error._handleUncaught2({ err : err2 });
        throw err2;
      }
    }

    // if( !_.time.timerInEndBegun( timer ) )
    // {
    //   _.time.cancel( timer );
    //   if( Config.debug )
    //   if( !_.symbolIs( err ) )
    //   {
    //     let err2 = _.err
    //     (
    //       'Only symbol in error channel of conseqeucne should be used to cancel timer.'
    //       + '\nFor example: "consequence.error( _.dont );"'
    //       + ( err !== undefined ? `\nError of type ${_.entity.strType( err )} was recieved instead` : `` )
    //       + ( err !== undefined ? `` : `\nArgument of type ${_.entity.strType( arg )} was recieved instead` )
    //     );
    //     _.error._handleUncaught2({ err : err2 });
    //     throw err2;
    //   }
    // }
    // else
    // {
    //   if( _.consequenceIs( o.onEnd ) )
    //   {
    //     arg = o.onEnd;
    //     err = undefined;
    //   }
    //   else
    //   {
    //     if( o.onEnd )
    //     arg = o.onEnd.call( timer, err ? err : arg );
    //     if( arg === undefined )
    //     arg = timer;
    //     else
    //     err = undefined;
    //   }
    // }

    if( err )
    throw err;
    return arg;
  }

  /* */

  function timeEnd1()
  {
    if( !con.competitorOwn( timeEnd2 ) )
    return;
    if( o.error )
    con.error( errMake() );
    else
    con.take( timer );
  }

  /* */

  function errMake()
  {
    let err = _.time._errTimeOut
    ({
      message : 'Time out!',
      reason : 'time out',
      consequnce : con,
      procedure : o.procedure,
    });
    return err;
  }

  /* */

}

out_body.defaults =
{
  delay : null,
  onEnd : null,
  procedure : null,
  error : 0,
}

let out = _.routine.uniteCloning_replaceByUnite( out_head, out_body );
out.defaults.error = 0;

//

/**
 * Routine works moslty same like {@link wTools.time.out} but has own small features:
 *  Is used to set execution time limit for async routines that can run forever or run too long.
 *  wConsequence instance returned by time.outError always give an error:
 *  - Own 'time.out' error message if ( onReady ) was not provided or it execution dont give any error.
 *  - Error throwed or returned in consequence by ( onRead ) routine.
 *
 * @param {Number} delay - Delay in ms before ( onReady ) is fired.
 * @param {Function|wConsequence} onReady - Routine that will be executed with delay.
 *
 * @example
 * // time.out error after delay
 * let t = _.time.outError( 1000 );
 * t.give( ( err, got ) => { throw err; } )
 *
 * @example
 * // using time.outError with long time routine
 * let time = 5000;
 * let time.out = time / 2;
 * function routine()
 * {
 *   return _.time.out( time );
 * }
 * // orKeepingSplit waits until one of provided consequences will resolve the message.
 * // In our example single time.outError consequence was added, so orKeepingSplit adds own context consequence to the queue.
 * // Consequence returned by 'routine' resolves message in 5000 ms, but time.outError will do the same in 2500 ms and 'time.out'.
 * routine()
 * .orKeepingSplit( _.time.outError( time.out ) )
 * .give( function( err, got )
 * {
 *   if( err )
 *   throw err;
 *   console.log( got );
 * })
 *
 * @returns {wConsequence} Returns wConsequence instance that resolves error message when work is done.
 * @throws {Error} If ( delay ) is not a Number.
 * @throws {Error} If ( onReady ) is not a routine or wConsequence instance.
 * @function time.outError
 * @namespace Tools
 */

let outError = _.routine.uniteCloning_replaceByUnite( out_head, out_body );
outError.defaults.error = 1;

// /* zzz : remove the body, use out_body */
// function outError_body( o )
// {
//   _.assert( _.routineIs( _.Consequence ) );
//   _.routine.assertOptions( outError_body, arguments );
//
//   if( _.numberIs( o.procedure ) )
//   o.procedure += 1;
//   else if( o.procedure === null )
//   o.procedure = 2;
//
//   if( !o.procedure || _.numberIs( o.procedure ) )
//   o.procedure = _.procedure.from( o.procedure ).nameElse( 'time.outError' );
//
//   let con = _.time.out.body.call( _, o );
//   if( Config.debug && con.tag === '' )
//   con.tag = 'TimeOutError';
//
//   _.assert( con._procedure === null );
//   con.procedure( o.procedure.clone() );
//   con.finally( outError );
//   _.assert( con._procedure === null );
//
//   return con;
//
//   function outError( err, arg )
//   {
//     if( err )
//     throw err;
//     if( arg === _.dont )
//     return arg;
//
//     err = _.time._errTimeOut
//     ({
//       message : 'Time out!',
//       reason : 'time out',
//       consequnce : con,
//       procedure : o.procedure,
//     });
//
//     throw err;
//   }
//
// }
//
// outError_body.defaults = Object.create( out_body.defaults );
//
// let outError = _.routine.uniteCloning_replaceByUnite( out_head, outError_body );

//

function _errTimeOut( o )
{
  if( _.strIs( o ) )
  o = { message : o }
  o = _.routine.options_( _errTimeOut, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  o.message = o.message || 'Time out!';
  o.reason = o.reason || 'time out';

  let err = _._err
  ({
    args : [ o.message ],
    throws : o.procedure ? [ o.procedure._sourcePath ] : [],
    asyncCallsStack : o.procedure ? [ o.procedure.stack() ] : [],
    reason : o.reason,
    throwCallsStack : o.procedure ? o.procedure._stack : null,
  });

  if( o.consequnce )
  {
    let properties =
    {
      enumerable : false,
      configurable : false,
      writable : false,
      value : o.consequnce,
    };
    Object.defineProperty( err, 'consequnce', properties );
  }

  return err;
}

_errTimeOut.defaults =
{
  message : null,
  reason : null,
  consequnce : null,
  procedure : null,
}

// --
// experimental
// --

function take()
{
  if( arguments.length )
  return new _.Consequence().take( ... arguments );
  else
  return new _.Consequence().take( null );

  // if( !arguments.length )
  // return new _.Consequence().take( null );
  // else
  // return new _.Consequence().take( ... arguments );
}

//

// function Now()
// {
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//   return new _.Consequence().take( null );
// }

//

function After( resource )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( arguments.length === 0 || resource !== undefined );

  if( resource === undefined )
  return new _.Consequence().take( null );
  else
  return _.Consequence.From( resource );

  // if( resource !== undefined )
  // return _.Consequence.From( resource );
  // else
  // return new _.Consequence().take( null );
}

// //
//
// function Before( consequence )
// {
//   _.assert( arguments.length === 1 );
//   _.assert( arguments.length === 0 || consequence !== undefined );
//   _.assert( 0, 'not tested' );
//
//   let result;
//   if( _.consequenceLike( consequence ) )
//   {
//     consequence = _.Consequence.From( consequence );
//   }
//
//   let result = _.Consequence();
//   result.lateFinally( consequence );
//
//   return result;
// }

//

function stagesRun( stages, o )
{
  let logger = _global.logger || _global.console;

  o = o || Object.create( null );

  _.routine.options( stagesRun, o );

  o.stages = stages;
  o.stack = _.introspector.stackRelative( o.stack, 1 );

  Object.preventExtensions( o );

  /* validation */

  _.assert( _.object.isBasic( stages ) || _.longIs( stages ), 'Expects array or object ( stages ), but got', _.entity.strType( stages ) );

  for( let s in stages )
  {

    let routine = stages[ s ];

    if( o.onRoutine )
    routine = o.onRoutine( routine );

    // _.assert( routine || routine === null,'stagesRun :','#'+s,'stage is not defined' );
    _.assert( _.routineIs( routine ) || routine === null, () => 'stage' + '#'+s + ' does not have routine to execute' );

  }

  /*  let */

  let ready = _.time.out( 1 );
  let keys = Object.keys( stages );
  let s = 0;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  /* begin */

  if( o.onBegin )
  {
    ready.procedure({ _stack : o.stack });
    ready.finally( o.onBegin );
    _.assert( ready._procedure === null );
  }

  handleStage();

  return ready;

  /* end */

  function handleEnd()
  {

    ready.procedure({ _stack : o.stack });
    ready.finally( function( err, data )
    {
      if( err )
      {
        throw _.errLogOnce( err );
      }
      else
      {
        return data;
      }
    });
    _.assert( ready._procedure === null );

    if( o.onEnd )
    {
      ready.procedure({ _stack : o.stack });
      ready.finally( o.onEnd );
      _.assert( ready._procedure === null );
    }

  }

  /* staging */

  function handleStage()
  {

    let stage = stages[ keys[ s ] ];
    let iteration = Object.create( null );

    iteration.index = s;
    iteration.key = keys[ s ];

    s += 1;

    if( stage === null )
    return handleStage();

    if( !stage )
    return handleEnd();

    /* arguments */

    iteration.stage = stage;
    if( o.onRoutine )
    iteration.routine = o.onRoutine( stage );
    else
    iteration.routine = stage;
    iteration.routine = _.routineJoin( o.context, iteration.routine, o.args );

    function routineCall()
    {
      let ret = iteration.routine();
      return ret;
    }

    /* exec */

    if( o.onEachRoutine )
    {
      ready.procedure({ _stack : o.stack });
      ready.ifNoErrorThen( _.routineSeal( o.context, o.onEachRoutine, [ iteration.stage, iteration, o ] ) );
      _.assert( ready._procedure === null );
    }

    if( !o.manual )
    {
      ready.procedure({ _stack : o.stack });
      ready.ifNoErrorThen( routineCall );
      _.assert( ready._procedure === null );
    }

    ready.procedure({ _stack : o.stack });
    ready.delay( o.delay );
    _.assert( ready._procedure === null );

    handleStage();

  }

}

stagesRun.defaults = /* qqq : make head and body. refactor maybe */
{
  delay : 1,
  stack : null,

  args : undefined,
  context : undefined,
  manual : false,

  onEachRoutine : null,
  onBegin : null,
  onEnd : null,
  onRoutine : null,
}

//

function sessionsRun_head( routine, args )
{
  let o;

  if( _.longIs( args[ 0 ] ) )
  o = { sessions : args[ 0 ] };
  else
  o = args[ 0 ];

  o = _.routine.options_( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1, 'Expects single argument' );
  _.assert( _.longIs( o.sessions ) );

  return o;
}

/* qqq for junior : cover please */
function sessionsRun_body( o )
{
  let firstReady = new _.Consequence().take( null );
  let prevReady = firstReady;
  let readies = [];
  let begins = [];
  let ends = [];
  let readyRoutine = null;

  if( !o.ready )
  {
    o.ready = _.take( null );
  }
  else if( !_.consequenceIs( o.ready ) )
  {
    readyRoutine = o.ready;
    o.ready = _.take( null );
  }

  if( o.sessions.length )
  o.ready.thenGive( () =>
  {

    o.sessions.forEach( ( session, i ) =>
    {

      if( o.concurrent )
      {
        prevReady.then( session.ready );
      }
      else
      {
        prevReady.finally( session.ready );
        prevReady = session.ready;
      }

      try
      {
        o.onRun( session );
      }
      catch( err )
      {
        o.error = o.error || err;
        session.ready.error( err );
      }

      _.assert( _.consequenceIs( session[ o.conBeginName ] ) );
      _.assert( _.consequenceIs( session[ o.conEndName ] ) );
      _.assert( _.consequenceIs( session[ o.readyName ] ) );

      begins.push( session[ o.conBeginName ] );
      ends.push( session[ o.conEndName ] );
      readies.push( session[ o.readyName ] );

      if( !o.concurrent )
      session.ready.catch( ( err ) =>
      {
        o.error = o.error || err;
        if( o.onError )
        o.onError( err );
        else
        throw err;
      });

    });

    let onBegin;
    if( o.concurrent )
    onBegin = _.Consequence.AndImmediate( ... begins );
    else
    onBegin = _.Consequence.OrKeep( ... begins );
    let onEnd = _.Consequence.AndImmediate( ... ends );
    let ready = _.Consequence.AndImmediate( ... readies );

    o.onBegin = direct( onBegin, o.onBegin );
    o.onEnd = direct( onEnd, o.onEnd );

    ready.finally( o.ready );

  });

  if( readyRoutine )
  o.ready.finally( readyRoutine );

  return o;

  function direct( icon, ocon )
  {
    if( _.consequenceIs( ocon ) )
    icon.finally( ocon );
    else if( ocon )
    icon.tap( ( err, arg ) =>
    {
      ocon( err, err ? undefined : o );
    });
    else
    ocon = icon;
    return ocon;
  }

}

sessionsRun_body.defaults =
{
  concurrent : 1,
  sessions : null,
  error : null,
  conBeginName : 'conBegin',
  conEndName : 'conEnd',
  readyName : 'ready',
  onRun : null,
  onBegin : null,
  onEnd : null,
  onError : null,
  ready : null,
}

let sessionsRun = _.routine.uniteCloning_replaceByUnite( sessionsRun_head, sessionsRun_body ); /* qqq for junior : cover */

//

function retry( o )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument.' );

  if( o.defaults )
  _.mapSupplementNulls( o, o.defaults );
  _.routine.options( retry, o );
  _.assert( _.routine.is( o.routine ), 'Expects routine {-o.routine-} to run.' );
  _.assert( o.attemptLimit > 0 );
  _.assert( o.attemptDelay >= 0 );

  o.onError = o.onError || onError;
  let attempt = 1;
  let attemptDelay = o.attemptDelay;
  const con = new _.Consequence();
  return _run( o )
  .finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( err );
    return arg;
  });

  /* */

  function _run( o )
  {
    if( attempt > o.attemptLimit )
    return con.error( _.err( o.err, `\nAttempts is exhausted, made ${ attempt - 1 } attempts` ) );

    _.take( null ).then( () => _.Consequence.Try( o.routine ) )
    .finally( ( err, arg ) =>
    {
      if( err )
      {
        o.err = err;
        let shouldRetry = false;
        try
        {
          if( o.onError( err ) !== false )
          shouldRetry = true;
        }
        catch( _err )
        {
          return con.error( _.err( err, '\nThe error thown in callback {-onError-}' ) );
        }

        if( shouldRetry )
        return _retry( o );
        return con.error( _.err( err ) );
      }
      if( o.onSuccess && !o.onSuccess( arg ) )
      return _retry( o );
      return con.take( arg );
    });

    return con;
  }

  /* */

  function _retry( o )
  {
    if( attempt >= 2 )
    attemptDelay = attemptDelay * o.attemptDelayMultiplier;
    attempt += 1;
    return _.time.out( attemptDelay, () => _run( o ) );
  }

  /* */

  function onError( err )
  {
    _.error.attend( err );
    return true;
  }
}

retry.defaults = /* aaa : cover */ /* Dmytro : covered */
{
  routine : null,
  onError : null,
  onSuccess : null,
  attemptLimit : 3,
  attemptDelay : 100,
  attemptDelayMultiplier : 1,
  defaults : null,
};

// --
// meta
// --

// function _Extend( dstGlobal, srcGlobal )
// {
//   _.assert( _.routineIs( srcGlobal.wConsequence.After ) );
//   _.assert( _.mapIs( srcGlobal.wConsequence.Tools ) );
//   _.props.extend( dstGlobal.wTools, srcGlobal.wConsequence.Tools );
//   const Self = srcGlobal.wConsequence;
//   dstGlobal.wTools[ Self.shortName ] = Self;
//   if( typeof module !== 'undefined' )
//   module[ 'exports' ] = Self;
//   return;
// }

//

/**
 * The routine ready() executes callback {-onReady-} when web-page is loaded.
 * If routine is executed in browser environment, then callback can be executed after
 * loading page with specified delay {-timeOut-}.
 * If routine is executed in NodeJS environment, then the callback is executed after
 * specified delay {-timeOut-}.
 *
 * @example
 * let result = [];
 * let ready = _.process.ready( () => result.push( 'ready' ) );
 * // when a page is loaded routine will push 'ready' in array `result` immediatelly
 * _.consequenceIs( ready );
 * // returns : true
 *
 * @example
 * let result = [];
 * let ready = _.process.ready( 500, () => result.push( 'ready' ) );
 * // when a page is loaded routine will push 'ready' in array `result` after time out
 * _.consequenceIs( ready );
 * // returns : true
 *
 * First parameter set :
 * @param { Number } timeOut - The time delay.
 * @param { Function } onReady - Callback to execute.
 * Second parameter set :
 * @param { Map|Aux } o - Options map.
 * @param { Number } o.timeOut - The time delay.
 * @param { Procedure } o.procedure - The procedure to associate with new Consequence.
 * @param { Function } o.onReady - Callback to execute.
 * @returns { Consequence } - Returns Consequence with result of execution.
 * @function ready
 * @throws { Error } If arguments.length is greater than 2.
 * @throws { Error } If single argument call is provided without callback {-onReady-} and options
 * map {-o-} has no option {-o.onReady-}.
 * @throws { Error } If {-timeOut-} has defined non integer value or not finite value.
 * @throws { Error } If {-o.procedure-} is provided and it is not a Procedure.
 * @namespace wTools.time
 * @extends Tools
 */

function ready_body( o )
{

  if( !o.procedure )
  o.procedure = _.Procedure({ _stack : 3, _name : 'timeReady' }); /* delta : 3 to not include info about `routine.unite` and `routineClone` in the stack */

  _.assert( _.procedureIs( o.procedure ) );

  if( typeof window !== 'undefined' && typeof document !== 'undefined' && document.readyState !== 'complete' )
  {
    let con = new _.Consequence({ tag : 'timeReady' });
    window.addEventListener( 'load', function() { handleReady( con, ... arguments ) } );
    return con;
  }
  else
  {
    return _.time.out( o.timeOut, o.procedure, o.onReady );
  }

  /* */

  function handleReady( con )
  {
    return _.time.out( o.timeOut, o.procedure, o.onReady ).finally( con );
  }

}

ready_body.defaults =
{
  timeOut : 0,
  procedure : null,
  onReady : null,
};

//

let ready = _.routine.uniteCloning_replaceByUnite( _.process.ready.head, ready_body );

//

function readyJoin( context, routine, args )
{
  let joinedRoutine = _.routineJoin( context, routine, args );
  return _timeReady;
  function _timeReady()
  {
    let args = arguments;
    let procedure = _.Procedure({ _stack : 1, _name : 'timeReadyJoin' });
    let joinedRoutine2 = _.routineSeal( this, joinedRoutine, args );
    return _.process.ready({ procedure, onReady : joinedRoutine2 });
  }
}

// --
// relations
// --

let ToolsExtension =
{
  take,
  // now : Now, yyy
  // async : Now, yyy
  after : After,
  // before : Before,
  stagesRun,
  sessionsRun,
  retry,
};

let TimeExtension =
{
  sleep,
  out,
  outError,
  _errTimeOut,
};

let ProcessExtension =
{
  ready,
  readyJoin,
};

_.props.extend( _, ToolsExtension );
_.props.extend( _global.wTools, ToolsExtension );
_.time = /* _.props.extend */Object.assign( _.time || null, TimeExtension );
_global.wTools.time = _.props.extend( _global.wTools.time || null, TimeExtension );
_.process = /* _.props.extend */Object.assign( _.process || null, ProcessExtension );
_global.wTools.process = _.props.extend( _global.wTools.process || null, ProcessExtension );

require( './Consequence.s' );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();


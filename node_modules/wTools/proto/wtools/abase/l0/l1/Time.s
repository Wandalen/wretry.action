( function _l1_Time_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.time = _.time || Object.create( null );

// --
// time
// --

function timerIs( src )
{
  if( !src )
  return false;
  return _.strIs( src.type ) && !!src.time && !!src.cancel;
}

//

function competitorIs( src )
{
  if( !src )
  return false;
  if( !_.mapIs( src ) )
  return false;
  return src.competitorRoutine !== undefined;
}

//

/**
 * The routine timerInBegin() checks the state of timer {-timer-}. If {-timer-} is created and
 * timer methods is not executed, then routine returns true. Otherwise, false is returned.
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.timerInBegin( timer );
 * // returns : true
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.cancel( timer );
 * _.time.timerInBegin( timer );
 * // returns : false
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.out( 2000, () => _.time.timerInBegin( timer ) );
 * // returns : false
 *
 * @param { Timer } timer - The timer to check.
 * @returns { Boolean } - Returns true if timer methods is not executed. Otherwise, false is returned.
 * @function timerInBegin
 * @throws { Error } If arguments is not provided.
 * @throws { Error } If {-timer-} is not a Timer.
 * @namespace wTools.time
 * @extends Tools
 */

function timerInBegin( timer )
{
  _.assert( _.timerIs( timer ) );
  return timer.state === 0;
}

//

/**
 * The routine timerInCancelBegun() checks the state of timer {-timer-}. If {-timer-} starts executing of callback
 * {-onCancel-} and not finished it, then routine returns true. Otherwise, false is returned.
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.timerInCancelBegun( timer );
 * // returns : false
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', onCancel );
 * _.time.cancel( timer );
 * function onCancel()
 * {
 *   _.time.timerInCancelBegun( timer );
 *   // returns : true
 *   return 'canceled';
 * }
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.out( 2000, () => _.time.timerInCancelBegun( timer ) );
 * // returns : false
 *
 * @param { Timer } timer - The timer to check.
 * @returns { Boolean } - Returns true if timer starts canceling and not finished it.
 * Otherwise, false is returned.
 * @function timerInCancelBegun
 * @throws { Error } If arguments is not provided.
 * @throws { Error } If {-timer-} is not a Timer.
 * @namespace wTools.time
 * @extends Tools
 */

function timerInCancelBegun( timer )
{
  _.assert( _.timerIs( timer ) );
  return timer.state === -1;
}

//

/**
 * The routine timerInCancelEnded() checks the state of timer {-timer-}. If {-timer-} finished executing of
 * callback {-onCancel-}, then routine returns true. Otherwise, false is returned.
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.timerInCancelEnded( timer );
 * // returns : false
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', onCancel );
 * _.time.cancel( timer );
 * function onCancel()
 * {
 *   _.time.timerInCancelEnded( timer );
 *   // returns : false
 *   return 'canceled';
 * }
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.out( 2000, () => _.time.timerInCancelEnded( timer ) );
 * // returns : false
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.cancel( timer );
 * // returns : true
 *
 * @param { Timer } timer - The timer to check.
 * @returns { Boolean } - Returns true if timer starts canceling and finished it.
 * Otherwise, false is returned.
 * @function timerInCancelEnded
 * @throws { Error } If arguments is not provided.
 * @throws { Error } If {-timer-} is not a Timer.
 * @namespace wTools.time
 * @extends Tools
 */

function timerInCancelEnded( timer )
{
  _.assert( _.timerIs( timer ) );
  return timer.state === -2;
}

//

function timerIsCanceled( timer )
{
  _.assert( _.timerIs( timer ) );
  return timer.state === -1 || timer.state === -2;
}

//

/**
 * The routine timerInEndBegun() checks the state of timer {-timer-}. If {-timer-} starts executing of callback
 * {-onTime-} and not finished it, then routine returns true. Otherwise, false is returned.
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.timerInEndBegun( timer );
 * // returns : false
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', onCancel );
 * _.time.cancel( timer );
 * function onCancel()
 * {
 *   _.time.timerInEndBegun( timer );
 *   // returns : false
 *   return 'canceled';
 * }
 *
 * @example
 * let timer = _.time.begin( 500, onTime, () => 'canceled' );
 * function onTime()
 * {
 *  _.time.timerInEndBegun( timer );
 *  // returns : true
 *  return 'executed';
 * }
 *
 * @param { Timer } timer - The timer to check.
 * @returns { Boolean } - Returns true if timer starts executing of callback {-onTime-} and not finished it.
 * Otherwise, false is returned.
 * @function timerInEndBegun
 * @throws { Error } If arguments is not provided.
 * @throws { Error } If {-timer-} is not a Timer.
 * @namespace wTools.time
 * @extends Tools
 */

function timerInEndBegun( timer )
{
  _.assert( _.timerIs( timer ) );
  return timer.state === 1;
}

//

/**
 * The routine timerInEndEnded() checks the state of timer {-timer-}. If {-timer-} finished executing of callback
 * {-onTime-}, then routine returns true. Otherwise, false is returned.
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.timerInEndEnded( timer );
 * // returns : false
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', onCancel );
 * _.time.cancel( timer );
 * function onCancel()
 * {
 *   _.time.timerInEndEnded( timer );
 *   // returns : false
 *   return 'canceled';
 * }
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.out( 2000, () => _.time.timerInEndEnded( timer ) );
 * // returns : true
 *
 * @param { Timer } timer - The timer to check.
 * @returns { Boolean } - Returns true if timer finished executing of callback {-onTime-}.
 * Otherwise, false is returned.
 * @function timerInEndEnded
 * @throws { Error } If arguments is not provided.
 * @throws { Error } If {-timer-} is not a Timer.
 * @namespace wTools.time
 * @extends Tools
 */

function timerInEndEnded( timer )
{
  _.assert( _.timerIs( timer ) );
  return timer.state === 2;
}

// --
//
// --

let _TimeInfinity = Math.pow( 2, 31 )-1;

//

function _begin( delay, onTime, onCancel )
{
  let native;

  if( delay >= _TimeInfinity )
  delay = _TimeInfinity;

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );

  if( delay > 0 )
  native = setTimeout( time, delay );
  else
  native = soon( timeNonCancelable ) || null;

  let timer = Object.create( null );
  timer.onTime = onTime;
  timer.onCancel = onCancel;
  timer._time = _time;
  timer._cancel = _cancel;
  timer.time = native === null ? timeNonCancelable : time;
  timer.cancel = cancel;
  timer.state = 0;
  timer.type = 'delay';
  timer.native = native;
  return timer;

  /* */

  function _time()
  {
    if( timer.state === 1 || timer.state === -1 )
    return;

    _.assert( timer.state > -2, 'Cannot change state of timer.' );
    _.assert( timer.state < 2, 'Timer can be executed only one time.' );

    timer.state = 1;
    try
    {
      if( onTime )
      timer.result = onTime( timer );
    }
    finally
    {
      _.assert( timer.state === 1 );
      timer.state = 2;
    }
  }

  /* */

  function _cancel()
  {
    if( timer.state === 1 || timer.state === -1 )
    return;

    _.assert( timer.state < 2, 'Cannot change state of timer.' );
    _.assert( timer.state > -2, 'Timer can be canceled only one time.' );

    timer.state = -1;
    clearTimeout( timer.native );
    try
    {
      if( onCancel )
      timer.result = onCancel( timer );
    }
    finally
    {
      _.assert( timer.state === -1 );
      timer.state = -2;
    }
  }

  /* */

  function timeNonCancelable()
  {
    if( timer.state !== 0 )
    return;
    return time.call( this, arguments );
  }

  /* */

  function time()
  {
    timer._time();
    clearTimeout( timer.native );
    return timer;
  }

  /* */

  function cancel()
  {
    return timer._cancel();
  }

}

//

function _finally( delay, onTime )
{
  _.assert( arguments.length === 2 );
  let timer = _.time._begin( delay, onTime, onTime );
  return timer;
}

//

function _periodic( delay, onTime, onCancel )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects exactly two or three arguments' );

  let native = setInterval( time, delay );

  let timer = Object.create( null );
  timer.onTime = onTime;
  timer.onCancel = onCancel;
  timer._time = _time;
  timer._cancel = _cancel;
  timer.time = time;
  timer.cancel = cancel;
  timer.state = 0;
  timer.type = 'periodic';
  timer.native = native;
  return timer;

  /* */

  function _time()
  {
    _.assert( timer.state !== -1 && timer.state !== -2, 'Illegal call, timer is canceled. Please, use new timer.' );

    timer.state = 1;
    try
    {
      if( onTime )
      timer.result = onTime( timer );
    }
    finally
    {
      if( timer.result === undefined || timer.result === _.dont ) /* Dmytro : if it needs, change to any other stop value */
      timer.cancel();
      else
      timer.state = 2;
    }
  }

  /* */

  function _cancel()
  {

    _.assert( timer.state !== -1 && timer.state !== -2, 'Illegal call, timer is canceled.' );

    timer.state = -1;
    clearInterval( timer.native );
    try
    {
      if( onCancel )
      timer.result = onCancel( timer );
    }
    finally
    {
      timer.state = -2;
    }
  }

  /* */

  function time()
  {
    return timer._time();
  }

  /* */

  function cancel()
  {
    return timer._cancel();
  }

}

//

function _cancel( timer )
{
  _.assert( _.timerIs( timer ) );

  timer.cancel();

  return timer;
}

//

/**
 * The routine begin() make new timer for procedure {-procedure-}. The timer executes callback {-onTime-} only once.
 * Callback {-onTime-} executes when time delay {-delay-} is elapsed. If the timer is canceled, then the callback
 * {-onCancel-} is executed.
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.out( 1000, () =>
 * {
 *  console.log( timer.result );
 *  // log : 'executed'
 *  return null;
 * });
 * console.log( timer.result );
 * // log : undefined
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * _.time.cancel( timer );
 * console.log( timer.result );
 * // log : 'canceled'
 *
 * @param { Number } delay - The time delay.
 * @param { Procedure|Undefined } procedure - The procedure for timer.
 * @param { Function|Undefined|Null } onTime - The callback to execute when time is elapsed.
 * @param { Function|Undefined|Null } onCancel - The callback to execute when timer is canceled.
 * @returns { Timer } - Returns timer.
 * @function begin
 * @throws { Error } If arguments.length is less than 2 or great than 4.
 * @throws { Error } If {-delay-} is not a Number.
 * @throws { Error } If {-onTime-} neither is a Function, nor undefined, nor null.
 * @throws { Error } If {-onCancel-} neither is a Function, nor undefined, nor null.
 * @namespace wTools.time
 * @extends Tools
 */

function begin( /* delay, procedure, onTime, onCancel */ )
{
  let delay = arguments[ 0 ];
  let procedure = arguments[ 1 ];
  let onTime = arguments[ 2 ];
  let onCancel = arguments[ 3 ];

  if( !_.procedureIs( procedure ) )
  {
    onTime = arguments[ 1 ] === undefined ? null : arguments[ 1 ];
    onCancel = arguments[ 2 ] === undefined ? null : arguments[ 2 ];
  }

  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4 );
  _.assert( _.number.is( delay ) );
  _.assert( _.routine.is( onTime ) || onTime === undefined || onTime === null );
  _.assert( _.routine.is( onCancel ) || onCancel === undefined || onCancel === null );

  return this._begin( delay, onTime, onCancel );
}

//

/**
 * The routine finally() make new timer for procedure {-procedure-}. The timer executes callback {-onTime-} only once.
 * Callback {-onTime-} executes when time delay {-delay-} is elapsed or if the timer is canceled.
 *
 * @example
 * let timer = _.time.finally( 500, () => 'executed' );
 * _.time.out( 1000, () =>
 * {
 *  console.log( timer.result );
 *  // log : 'executed'
 *  return null;
 * });
 * console.log( timer.result );
 * // log : undefined
 *
 * @example
 * let timer = _.time.finally( 500, () => 'executed', () => 'canceled' );
 * _.time.cancel( timer );
 * console.log( timer.result );
 * // log : 'executed'
 *
 * @param { Number } delay - The time delay.
 * @param { Procedure|Undefined } procedure - The procedure for timer.
 * @param { Function|Undefined|Null } onTime - The callback to execute when time is elapsed.
 * @param { Function|Undefined|Null } onCancel - The callback to execute when timer is canceled.
 * @returns { Timer } - Returns timer.
 * @function finally
 * @throws { Error } If arguments.length is less than 2 or great than 3.
 * @throws { Error } If {-delay-} is not a Number.
 * @throws { Error } If {-onTime-} neither is a Function, nor undefined, nor null.
 * @namespace wTools.time
 * @extends Tools
 */

function finally_( delay, procedure, onTime )
{
  if( arguments.length === 2 )
  if( !_.procedureIs( procedure ) )
  onTime = arguments[ 1 ] === undefined ? null : arguments[ 1 ];

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( _.number.is( delay ) );
  _.assert( _.routine.is( onTime ) || onTime === undefined || onTime === null );

  return this._finally( delay, onTime );
}

//

/**
 * The routine periodic() make new periodic timer for procedure {-procedure-}. The timer executes callback {-onTime-}
 * periodically with time interval {-delay-}. If callback {-onTime-} returns undefined or Symbol _.dont, then the
 * callback {-onCancel-} executes and timer stops.
 * If the times is canceled, then the callback {-onCancel-} is executed.
 *
 * @example
 * let result = [];
 * function onTime()
 * {
 *   if( result.length < 3 )
 *   return result.push( 1 );
 *   else
 *   return undefined;
 * }
 * let timer = _.time.periodic( 500, onTime, () => 'canceled' );
 * _.time.out( 3000, () =>
 * {
 *   console.log( result );
 *   // log : [ 1, 1, 1 ]
 *   console.log( timer.result );
 *   // log : 'canceled'
 *   return null;
 * });
 * console.log( timer.result );
 * // log : undefined
 *
 * @example
 * let result = [];
 * function onTime()
 * {
 *   if( result.length < 3 )
 *   return result.push( 1 );
 *   else
 *   return undefined;
 * }
 * let timer = _.time.periodic( 500, onTime, () => 'canceled' );
 * _.time.cancel( timer );
 * console.log( result );
 * // log : []
 * console.log( timer.result );
 * // log : 'canceled'
 *
 * @param { Number } delay - The time delay.
 * @param { Procedure|Undefined } procedure - The procedure for timer.
 * @param { Function } onTime - The callback to execute when time is elapsed.
 * @param { Function|Undefined|Null } onCancel - The callback to execute when timer is canceled.
 * @returns { Timer } - Returns periodic timer.
 * @function begin
 * @throws { Error } If arguments.length is less than 2 or great than 4.
 * @throws { Error } If {-delay-} is not a Number.
 * @throws { Error } If {-onTime-} is not a Function.
 * @throws { Error } If {-onCancel-} neither is a Function, nor undefined, nor null.
 * @namespace wTools.time
 * @extends Tools
 */

function periodic( /* delay, procedure, onTime, onCancel */ )
{
  let delay = arguments[ 0 ];
  let procedure = arguments[ 1 ];
  let onTime = arguments[ 2 ];
  let onCancel = arguments[ 3 ];

  if( !_.procedureIs( procedure ) )
  {
    onTime = arguments[ 1 ] === undefined ? null : arguments[ 1 ];
    onCancel = arguments[ 2 ] === undefined ? null : arguments[ 2 ];
  }

  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4 );
  _.assert( _.number.is( delay ) );
  _.assert( _.routine.is( onTime ) );
  _.assert( _.routine.is( onCancel ) || onCancel === undefined || onCancel === null );

  return this._periodic( delay, onTime, onCancel );
}

//

/**
 * The routine cancel() cancels timer {-timer-}.
 *
 * @example
 * let timer = _.time.begin( 500, () => 'executed', () => 'canceled' );
 * let canceled = _.time.cancel( timer );
 * console.log( timer.result );
 * // log : 'canceled'
 * console.log( timer === canceled );
 * // log : true
 *
 * @example
 * let timer = _.time.periodic( 500, () => 'executed', () => 'canceled' );
 * let canceled = _.time.cancel( timer );
 * console.log( timer.result );
 * // log : 'canceled'
 * console.log( timer === canceled );
 * // log : true
 *
 * @param { Timer } timer - The timer to cancel.
 * @returns { Timer } - Returns canceled timer.
 * @function cancel
 * @throws { Error } If {-timer-} is not a Timer.
 * @namespace wTools.time
 * @extends Tools
 */

function cancel( timer )
{
  return _.time._cancel( ... arguments );
}

//

/**
 * The routine _now_functor() make the better function to get current time in ms.
 * The returned function depends on environment.
 *
 * @example
 * let now = _.time._now_functor();
 * console.log( _.routine.is( now ) );
 * // log : true
 * console.log( now() );
 * // log : 1603172830154
 *
 * @returns { Function } - Returns function to get current time in ms.
 * @function _now_functor
 * @namespace wTools.time
 * @extends Tools
 */

function _now_functor()
{
  let now;

  if( typeof performance !== 'undefined' && performance.now !== undefined )
  now = _.routine.join( performance, performance.now );
  else if( Date.now )
  now = _.routine.join( Date, Date.now );
  else
  now = function(){ return Date().getTime() };

  return now;
}

//

/**
 * The routine soon() execute routine {-h-} asynchronously as soon as possible. In NodeJS interpreter it
 * executes on nextTick, in another interpreters in async queue.
 *
 * @example
 * let result = [ _.time.now() ];
 * _.time.soon( () => result.push( _.time.now() ) );
 * // the delta ( result[ 1 ] - result[ 0 ] ) is small as possible
 *
 * @param { Function } h - The routine to execute.
 * @returns { Undefined } - Returns undefined, executes routine {-h-}.
 * @function soon
 * @throws { Error } If arguments is not provided.
 * @throws { Error } If {-h-} is not a Function.
 * @namespace wTools.time
 * @extends Tools
 */

const soon = typeof process === 'undefined' ? function( h ){ return setTimeout( h, 0 ) } : process.nextTick;

// --
// implementation
// --

/* qqq : make namespace _.timer */
let TimeExtension =
{

  /* qqq : for junior : bad */
  timerIs, /* qqq : cover */
  competitorIs, /* xxx : move */

  timerInBegin,
  timerInCancelBegun,
  timerInCancelEnded,
  timerIsCanceled,
  timerInEndBegun,
  timerInEndEnded,

  _begin,
  _finally,
  _periodic,
  _cancel,

  begin,
  finally : finally_,
  periodic,
  cancel,

  _now_functor,
  now : _now_functor(),
  soon,

}

//

Object.assign( _.time, TimeExtension );

//

let ToolsExtension =
{

  /* qqq : for junior : bad */
  timerIs,
  competitorIs, /* xxx : move */

}

//

Object.assign( _, ToolsExtension );

/* qqq : for junior : replace Routines+Fields -> {- name of namespace -}Extension in all files */

})();

( function _Namespace_s_()
{

'use strict';

const _global = _global_;
const _ = _global.wTools;

_.assert( !!_global.wTools, 'Does not have wTools' );
_.assert( _global.wTools.procedure === undefined, 'wTools.procedure is already defined' );
_.assert( _global.wTools.Procedure === undefined, 'wTools.Procedure is already defined' );

_.procedure = _.procedure || Object.create( null );

// _realGlobal_._ProcedureGlobals_ = _realGlobal_._ProcedureGlobals_ || [];
// _.arrayAppendOnce( _realGlobal_._ProcedureGlobals_, _global );

// --
// event
// --

function on( o )
{
  o = _.event.onHead( _.event.on, arguments );
  return _.event.on( _.procedure._edispatcher, o );
}

on.defaults =
{
  callbackMap : null,
}

//

function off( o )
{

  o = _.event.offHead( _.event.off, arguments );
  _.event.off( _.procedure._edispatcher, o );

}

off.defaults =
{
  callbackMap : null,
}

//

function _eventTerminationBeginHandle()
{

  _.procedure._edispatcher.events.terminationBegin.forEach( ( callback ) =>
  {
    try
    {
      callback.call( _.procedure );
    }
    catch( err )
    {
      logger.error( _.errOnce( 'Error in callback of event "terminationBegin"\n', err ) );
    }
  });

}

//

function _eventTerminationEndHandle()
{

  _.procedure._edispatcher.events.terminationEnd.forEach( ( callback ) =>
  {
    try
    {
      /* namespace should be in the context */
      callback.call( _.procedure );
    }
    catch( err )
    {
      logger.error( _.errOnce( 'Error in callback of event "terminationEnd"\n', err ) );
    }
  });

}

//

function _eventProcessExitHandle()
{
  _.Procedure._Exiting = 1;
  _.procedure.terminationBegin();
}

// --
// termination
// --

/**
 * @summary Prints report with number of procedures that are still working.
 * @routine terminationReport
 * @module Tools/base/Procedure
 * @namespace Tools.procedure
 */

function terminationReport()
{

  let procedures = _.Procedure.Find({ _quasi : 0 });
  if( _.procedure._terminationListInvalidated )
  logger.log( _.Procedure.ExportInfo( procedures ) );

  _.procedure._terminationListInvalidated = 0;
  logger.log( `Waiting for ${procedures.length} procedure(s) ...` );
}

//

/**
 * @summary Starts procedure of termination.
 * @routine terminationBegin
 * @module Tools/base/Procedure
 * @namespace Tools.procedure
 */

function terminationBegin()
{

  _.assert( this === _.procedure );

  if( _.Procedure._Terminating )
  return;

  _.routine.options_( terminationBegin, arguments );
  _.Procedure._Terminating = 1;
  _.procedure._terminationListInvalidated = 1;

  _.procedure._eventTerminationBeginHandle();
  _.procedure._terminationRestart();

  _.each( _realGlobal_._globals_, ( global ) =>
  {
    if( global.wTools && global.wTools.procedure && global.wTools.procedure.terminationBegin )
    global.wTools.procedure.terminationBegin();
  });

}

terminationBegin.defaults =
{
}

//

function _terminationIteration()
{
  _.assert( arguments.length === 1 );
  _.assert( _.Procedure._Terminating === 1 );

  _.procedure._terminationTimer = null;
  _.procedure.terminationReport();

  _.procedure._terminationRestart();

}

//

function _terminationRestart()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.Procedure._Terminating >= 1 );

  if( _.Procedure._Terminating === 2 )
  {
    return;
  }

  if( _.procedure._terminationTimer )
  _.time._cancel( _.procedure._terminationTimer );
  _.procedure._terminationTimer = null;

  let procedures = _.Procedure.Find({ _quasi : 0 });

  if( procedures.length && !_.Procedure._Exiting )
  {
    _.procedure._terminationTimer = _.time._begin( _.procedure.terminationPeriod, _.procedure._terminationIteration );
  }
  else
  {
    _.procedure._terminationEnd();
  }

}

//

function _terminationEnd()
{

  try
  {

    // console.log( '_terminationEnd' ); debugger;

    _.assert( arguments.length === 0, 'Expects no arguments' );
    _.assert( _.Procedure._Terminating === 1 );
    _.assert( _.procedure._terminationTimer === null );

    _.Procedure._Terminating = 2;

    if( !_.Procedure._Exiting || _.Procedure.EntryProcedure === _.Procedure.ActiveProcedure )
    if( _.Procedure.EntryProcedure && _.Procedure.EntryProcedure.isAlive() )
    {
      _.Procedure.EntryProcedure.activate( 0 );
      _.Procedure.EntryProcedure.end();
    }

    /* end all timers */

    _.procedure._timersEnd();

    /* end all timers */

    _.procedure._eventTerminationEndHandle();

  }
  catch( err )
  {
    _.error._handleUncaught2({ err, origination : 'uncaught error in procedures termination routine' })
  }

}

//

function _timersEnd()
{

  for( let p in _.Procedure.NamesMap )
  {
    let procedure = _.Procedure.NamesMap[ p ];
    if( !_.timerIs( procedure._object ) )
    {
      continue;
    }
    _.time.cancel( procedure._object );
  }

}

// --
// time
// --

function _timeBegin( o )
{

  if( o.onTime === undefined )
  o.onTime = null;
  if( o.onCancel === undefined )
  o.onCancel = o.onTime;

  _.routine.assertOptions( _timeBegin, arguments );

  if( o.procedure === undefined || o.procedure === null )
  o.procedure = 0;
  if( _.numberIs( o.procedure ) )
  {
    _.assert( _.intIs( o.procedure ) );
    o.procedure += 1;
  }
  o.procedure = _.Procedure( o.procedure );
  o.procedure.nameElse( 'time.begin' );
  if( o.onTime !== null )
  o.procedure.routineElse( o.onTime );

  let wasAlive = o.procedure.isAlive();
  if( !wasAlive )
  {
    _.assert( o.procedure._waitTimer === null );
    o.procedure._waitTimer = false;
    o.procedure.begin();
  }
  let timer;

  // if( o.method.name === '_periodic' )
  // debugger;
  timer = o.method.call( _.time, o.delay, o.onTime, o.onCancel );
  timer.procedure = o.procedure;
  o.procedure.object( timer );

  let _time = timer._time;
  let _cancel = timer._cancel;
  timer._time = o.method.name === '_periodic' ? timePeriodic : time;
  timer._cancel = cancel;

  return timer;

  /* */

  function time()
  {

    if( !o.procedure.use() )
    o.procedure.activate( true );

    try
    {
      return _time.apply( this, arguments );
    }
    finally
    {
      o.procedure.unuse();
      // if( o.procedure.isUsed() )
      // return;
      if( !o.procedure.isUsed() )
      {
        o.procedure.activate( false );
        _.assert( !o.procedure.isActivated() );
        o.procedure.end();
      }
    }
  }

  /* */

  function timePeriodic()
  {
    o.procedure.activate( true );
    try
    {
      return _time.apply( this, arguments );
    }
    finally
    {
      // _.assert( !o.procedure.isFinited() );
      /* Dmytro : periodic timer finishes procedure if callback returns undefined */
      if( !o.procedure.isFinited() )
      {
        o.procedure.activate( false );
        _.assert( !o.procedure.isActivated() );
      }
    }
  }

  /* */

  function cancel()
  {

    /* xxx aaa for Dmytro : look suspicious! */ /* Dmytro : add conditions to fix behavior of routine */
    // if( timer.state !== 0 && o.method.name !== '_periodic' )
    if( timer.state !== 0 && timer.state !== -2 && timer.state !== 2 && o.method.name !== '_periodic' )
    return;

    if( !o.procedure.use() && !o.procedure.isTopMost() )
    o.procedure.activate( true );

    try
    {
      return _cancel( this, arguments );
    }
    finally
    {
      o.procedure.unuse();
      // if( o.procedure.isUsed() )
      // return;

      if( !o.procedure.isUsed() )
      {
        o.procedure.activate( false );
        _.assert( !o.procedure.isActivated() );
        o.procedure.end();
      }
    }

  }

}

_timeBegin.defaults =
{
  delay : null,
  procedure : null,
  onTime : null,
  onCancel : null,
  method : _.time._begin,
}

//

function timeBegin( /* delay, procedure, onTime, onCancel */ )
{
  let delay = arguments[ 0 ];
  let procedure = arguments[ 1 ];
  let onTime = arguments[ 2 ];
  let onCancel = arguments[ 3 ];

  if( !_.procedureIs( procedure ) )
  {
    onTime = arguments[ 1 ];
    onCancel = arguments[ 2 ];
    procedure = 1;
  }

  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4 );
  _.assert( _.numberIs( delay ) );
  _.assert( _.routineIs( onTime ) || onTime === undefined || onTime === null );
  _.assert( _.routineIs( onCancel ) || onCancel === undefined || onCancel === null );

  let o2 = Object.create( null );
  o2.delay = delay;
  o2.procedure = procedure;
  o2.onTime = onTime;
  o2.onCancel = onCancel || null;
  o2.method = _.time._begin;

  return _timeBegin.call( this, o2 );
}

//

function timeFinally( delay, procedure, onTime )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( !_.procedureIs( procedure ) )
  {
    onTime = arguments[ 1 ];
    procedure = 1;
  }

  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4 );
  _.assert( _.numberIs( delay ) );
  _.assert( _.routineIs( onTime ) || onTime === undefined || onTime === null );

  let o2 = Object.create( null );
  o2.delay = delay;
  o2.procedure = procedure;
  o2.onTime = onTime;
  o2.onCancel = onTime;
  o2.method = _.time._begin;

  let timer = _timeBegin.call( this, o2 );
  return timer;
}

//

function timePeriodic( /* delay, procedure, onTime, onCancel */ )
{
  let delay = arguments[ 0 ];
  let procedure = arguments[ 1 ];
  let onTime = arguments[ 2 ];
  let onCancel = arguments[ 3 ];

  if( !_.procedureIs( procedure ) )
  {
    onTime = arguments[ 1 ];
    onCancel = arguments[ 2 ];
    procedure = 1;
  }

  _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4 );
  _.assert( _.numberIs( delay ) );
  _.assert( _.routineIs( onTime ) );
  _.assert( _.routineIs( onCancel ) || onCancel === undefined || onCancel === null );

  let o2 = Object.create( null );
  o2.delay = delay;
  o2.procedure = procedure;
  o2.onTime = onTime;
  o2.onCancel = onCancel || null;
  o2.method = _.time._periodic;

  return _timeBegin.call( this, o2 );
}

// --
// etc
// --

function begin( o )
{
  o = _.Procedure.OptionsFrom( ... arguments );
  o._stack = _.Procedure.Stack( o._stack, 1 );
  let result = _.Procedure.From( o );
  result.begin();
  return result;
}

// --
// meta
// --

function _Setup1()
{
  _.assert( _.strIs( _.setup._entryProcedureStack ) );

  _.assert( _.Procedure.InstancesArray.length === 0 );

  if( !_.Procedure.EntryProcedure )
  _.Procedure.EntryProcedure = _.procedure.begin
  ({
    _stack : _.setup._entryProcedureStack,
    _object : null,
    _name : 'entry',
    _quasi : true,
    _waitTimer : false,
  });

  _.assert( _.Procedure.ActiveProcedures.length === 0 );

  _.Procedure.EntryProcedure.activate( true );

  _.assert( !!_.process && !!_.process.on );

  _.process.on( _.event.Chain( 'available', 'exit', 'exit' ), _.procedure._eventProcessExitHandle );
  // _.process.on( 'available', _.event.Name( 'exit' ), _.event.Name( 'exit' ), _.procedure._eventProcessExitHandle );

  /* xxx : add explenation */
  /* xxx aaa for Dmytro : introduce mini-class _.event.Chain() // Dmytro : introduced, covered
  _.process.on( 'available', _.event.Name( 'exit' ), _.event.Name( 'exit' ), _.procedure._eventProcessExitHandle )
  ->
  _.process.on( _.event.Chain( 'available', 'exit', 'exit' ), _.procedure._eventProcessExitHandle )
  aaa for Dmytro : restrict routines _.*.on() to accept 2 arguments // Dmytro : done
  */

}

// --
// relations
// --

let Events =
{
  terminationBegin : [],
  terminationEnd : [],
}

Object.freeze( Events );

let _edispatcher =
{
  events : Events,
}

let TimeExtension =
{
  begin : timeBegin,
  finally : timeFinally,
  periodic : timePeriodic,
}

let ProcedureExtension =
{

  // event

  on,
  off,
  _eventTerminationBeginHandle,
  _eventTerminationEndHandle,
  _eventProcessExitHandle,

  // termination

  terminationReport,
  terminationBegin,
  _terminationIteration,
  _terminationRestart,
  _terminationEnd,
  _timersEnd,

  // etc

  begin,

  // meta

  _Setup1,

  // fields

  _edispatcher,

}

// --
// define namspeces
// --

_.assert( _.routineIs( _.accessor.define.getter.alias ) );
_.assert( _.routineIs( _.accessor.define.suite.alias ) );

Object.assign( _.time, TimeExtension );
Object.assign( _.procedure, ProcedureExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _.procedure;

})();

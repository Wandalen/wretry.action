( function _Basic_s_()
{

'use strict';

let System, ChildProcess, StripAnsi, WindowsKill, WindowsProcessTree;
const _global = _global_;
const _ = _global_.wTools;
_.process = _.process || Object.create( null );

_.assert( !!_realGlobal_ );

// --
// dichotomy
// --

function isNativeDescriptor( src )
{
  if( !src )
  return false;
  if( !ChildProcess )
  ChildProcess = require( 'child_process' );
  return src instanceof ChildProcess.ChildProcess;
}

//

function isSession( src )
{
  if( !_.object.isBasic( src ) )
  return false;
  return src.ipc !== undefined && src.procedure !== undefined && src.process !== undefined;
}

//

function pidFrom( src )
{
  _.assert( arguments.length === 1 );

  if( _.numberIs( src ) )
  return src;
  if( _.object.isBasic( src ) )
  {
    if( src.process )
    src = src.process;
    if( src.pnd )
    src = src.pnd;
    if( Config.debug )
    {
      if( !ChildProcess )
      ChildProcess = require( 'child_process' );
      _.assert( src instanceof ChildProcess.ChildProcess );
    }
    return src.pid;
  }

  _.assert( 0, `Cant get PID from ${_.entity.strType( src )}` );
}

// --
// temp
// --

let _tempFiles = [];

/* qqq : for Vova : reuse _.program.* */
function tempOpen_head( routine, args )
{
  let o;

  if( _.strIs( args[ 0 ] ) || _.bufferRawIs( args[ 0 ] ) )
  o = { routineCode : args[ 0 ] };
  else
  o = args[ 0 ];

  o = _.routine.options_( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1, 'Expects single argument' );

  return o;
}

//

function tempOpen_body( o )
{
  _.routine.assertOptions( tempOpen, arguments );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert
  (
    _.strIs( o.routineCode ) || _.bufferRawIs( o.routineCode ),
    'Expects string or buffer raw {-o.routineCode-}, but got', _.entity.strType( o.routineCode )
  );

  let tempDirPath = _.path.tempOpen( _.path.realMainDir(), 'ProcessTempOpen' );
  let filePath = _.path.join( tempDirPath, _.idWithDateAndTime() + '.ss' );
  _tempFiles.push( filePath );
  _.fileProvider.fileWrite( filePath, o.routineCode );
  return filePath;
}

var defaults = tempOpen_body.defaults = Object.create( null );
defaults.routineCode = null;

let tempOpen = _.routine.uniteCloning_replaceByUnite( tempOpen_head, tempOpen_body );

//

function tempClose_head( routine, args )
{
  let o;

  if( _.strIs( args[ 0 ] ) )
  o = { filePath : args[ 0 ] };
  else
  o = args[ 0 ];

  if( !o )
  o = Object.create( null );

  o = _.routine.options_( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length <= 1, 'Expects single argument or none' );

  return o;
}

function tempClose_body( o )
{
  _.routine.assertOptions( tempClose, arguments );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.filePath ) || o.filePath === null, 'Expects string or null {-o.filePath-}, but got', _.entity.strType( o.filePath ) );

  if( !o.filePath )
  {
    if( !_tempFiles.length )
    return;

    _.fileProvider.filesDelete( _tempFiles );
    _tempFiles.splice( 0 );
  }
  else
  {
    let i = _.longLeftIndex( _tempFiles, o.filePath );
    _.assert( i !== -1, `Requested {-o.filePath-} ${o.filePath} is not a path of temp application.` )
    _.fileProvider.fileDelete( o.filePath );
    _tempFiles.splice( i, 1 );
  }
}

var defaults = tempClose_body.defaults = Object.create( null );
defaults.filePath = null;

let tempClose = _.routine.uniteCloning_replaceByUnite( tempClose_head, tempClose_body );

// --
// eventer
// --

let _on = _.process.on;
function on()
{
  let o2 = _on.apply( this, arguments );
  if( o2.available ) /* Dmytro : use descriptor field in new implementation */
  _.process._eventAvailableHandle();
  return o2;
}

on.defaults =
{
  callbackMap : null,
}

//

function _eventAvailableHandle()
{
  if( !_.process._edispatcher.events.available.length )
  return;

  let callbacks = _.process._edispatcher.events.available.slice();
  callbacks.forEach( ( callback ) =>
  {
    try
    {
      _.arrayRemoveOnceStrictly( _.process._edispatcher.events.available, callback );
      callback.call( _.process );
    }
    catch( err )
    {
      throw _.err( `Error in handler::${callback.name} of an event::available of module::Process\n`, err );
    }
  });

}

//

_realGlobal_._exitHandlerRepairDone = _realGlobal_._exitHandlerRepairDone || 0;
_realGlobal_._exitHandlerRepairTerminating = _realGlobal_._exitHandlerRepairTerminating || 0;
function _exitHandlerRepair()
{

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( _realGlobal_._exitHandlerRepairDone )
  return;
  _realGlobal_._exitHandlerRepairDone = 1;

  if( !_global.process )
  return;

  process.on( 'SIGHUP', handle_functor( 'SIGHUP', 1 ) );
  process.on( 'SIGQUIT', handle_functor( 'SIGQUIT', 3 ) );
  process.on( 'SIGINT', handle_functor( 'SIGINT', 2 ) );
  process.on( 'SIGTERM', handle_functor( 'SIGTERM', 15 ) );
  process.on( 'SIGUSR1', handle_functor( 'SIGUSR1', 16 ) );
  process.on( 'SIGUSR2', handle_functor( 'SIGUSR2', 17 ) );

  function handle_functor( signal, signalCode )
  {
    return function handle()
    {
      if( _.process._verbosity )
      console.log( signal );
      if( _realGlobal_._exitHandlerRepairTerminating )
      return;
      _realGlobal_._exitHandlerRepairTerminating = 1;
      if( !_.process.exitReason() )
      {
        let err = _._err
        ({
          args : [ `Exit signal : ${signal} ( 128+${signalCode} )` ],
          concealed : { exitSignal : signal },
          reason : 'exit signal',
        });
        _.process.exitReason( err );
      }
      /*
       short delay is required to set exit reason of the process
       otherwise reason will be exit code, not exit signal
      */
      _.time._begin( _.process._sanitareTime, () =>
      {
        try
        {
          process.removeListener( signal, handle );
          if( !process._exiting )
          {
            try
            {
              process._exiting = true;
              process.emit( 'exit', 128 + signalCode );
            }
            catch( err )
            {
              console.error( _.err( err ) );
            }
            process.kill( process.pid, signal );
          }
        }
        catch( err )
        {
          console.log( `Error on signal ${signal}` );
          console.log( err.toString() );
          console.log( err.stack );
          process.removeAllListeners( 'exit' );
          process.exit( -1 );
        }
      });
    }
  }

}

//

function _eventsSetup()
{

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( !_global.process )
  return;

  if( !_.process._registeredExitHandler )
  {
    _global.process.once( 'exit', _.process._eventExitHandle );
    _.process._registeredExitHandler = _.process._eventExitHandle;
  }

  if( !_.process._registeredExitBeforeHandler )
  {
    _global.process.on( 'beforeExit', _.process._eventExitBeforeHandle );
    _.process._registeredExitBeforeHandler = _.process._eventExitBeforeHandle;
  }

}

//

function _eventExitHandle()
{
  let args = arguments;
  _.process.exiting = true;
  process.removeListener( 'exit', _.process._registeredExitHandler );
  _.process._registeredExitHandler = null;
  _.process.eventGive({ event : 'exit', args });
  _.process._edispatcher.events.exit.splice( 0, _.process._edispatcher.events.exit.length );
}

//

function _eventExitBeforeHandle()
{
  let args = arguments;
  _.process.eventGive({ event : 'exitBefore', args });
}

// --
// exit
// --

/**
 * @summary Allows to set/get exit reason of current process.
 * @description Saves exit reason if argument `reason` was provided, otherwise returns current exit reason value.
 * Returns `null` if reason was not defined yet.
 * @function exitReason
 * @module Tools/base/ProcessBasic
 * @namespace Tools.process
 */

function exitReason( reason )
{
  if( !_realGlobal_.wTools )
  _realGlobal_.wTools = Object.create( null );
  if( !_realGlobal_.wTools.process )
  _realGlobal_.wTools.process = Object.create( null );
  if( _realGlobal_.wTools.process._exitReason === undefined )
  _realGlobal_.wTools.process._exitReason = null;
  if( reason === undefined )
  return _realGlobal_.wTools.process._exitReason;
  _realGlobal_.wTools.process._exitReason = reason;
  return _realGlobal_.wTools.process._exitReason;
}

//

/**
 * @summary Allows to set/get exit code of current process.
 * @description Updates exit code if argument `status` was provided and returns previous exit code. Returns current exit code if no argument provided.
 * Returns `0` if exit code was not defined yet.
 * @function exitCode
 * @module Tools/base/ProcessBasic
 * @namespace Tools.process
 */

function exitCode( status )
{
  let result;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( status === undefined || _.numberIs( status ) );

  if( _global.process )
  {
    result = process.exitCode || 0;
    if( status !== undefined )
    process.exitCode = status;
  }

  return result;
}

//

function exit( exitCode )
{

  exitCode = exitCode !== undefined ? exitCode : _.process.exitCode();

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( exitCode === undefined || _.numberIs( exitCode ) );

  if( _global.process )
  {
    process.exit( exitCode );
  }
  else
  {
    /*debugger;*/
  }

}

//

function exitWithBeep()
{
  let exitCode = _.process.exitCode();

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( exitCode === undefined || _.numberIs( exitCode ) );

  _.diagnosticBeep();

  if( exitCode )
  _.diagnosticBeep();

  _.process.exit( exitCode );

  return exitCode;
}

// --
// args
// --

function _argsForm( o )
{

  o.args = _.array.as( o.args );

  let _argsLength = o.args.length;

  if( _.strIs( o.execPath ) )
  {
    o.execPath2 = o.execPath;
    let execArgs = execPathParse( o.execPath );
    if( o.mode !== 'shell' )
    execArgs = _.process._argsUnqoute( execArgs );
    o.execPath = null;
    if( execArgs.length )
    {
      o.execPath = execArgs.shift();
      o.args = _.arrayPrependArray( o.args || [], execArgs );
    }
  }

  if( o.execPath === null )
  {
    _.assert( o.args.length > 0, 'Expects {-args-} to have at least one argument if {-execPath-} is not defined' );
    o.execPath = o.args.shift();
    o.execPath2 = o.execPath;
    _argsLength = o.args.length;
    o.execPath = _.process._argUnqoute( o.execPath );
  }

  o.args2 = o.args.slice();

  /* passingThrough */

  if( o.passingThrough )
  {
    let argumentsOwn = process.argv.slice( 2 );
    if( argumentsOwn.length )
    o.args2 = _.arrayAppendArray( o.args2 || [], argumentsOwn );
  }

  _.assert( o.interpreterArgs === null || _.arrayIs( o.interpreterArgs ) );
  if( o.interpreterArgs && o.mode !== 'fork' )
  o.args2 = _.arrayPrependArray( o.args2, o.interpreterArgs );

  /* Escapes and quotes:
    - Original args provided via o.args
    - Arguments of parent process if o.passingThrough is enabled
    Skips arguments parsed from o.execPath.
  */

  if( o.mode === 'shell' )
  {
    let appendedArgs = o.passingThrough ? process.argv.length - 2 : 0;
    let prependedArgs = o.args2.length - ( _argsLength + appendedArgs );
    for( let i = prependedArgs; i < o.args2.length; i++ )
    {
      o.args2[ i ] = _.process._argEscape( o.args2[ i ] );
      o.args2[ i ] = _.strQuote( o.args2[ i ] );
    }
  }

  /* */

  function execPathParse( src )
  {
    let strOptions =
    {
      src,
      delimeter : [ ' ' ],
      quoting : 1,
      quotingPrefixes : [ '"', `'`, '`' ],
      quotingPostfixes : [ '"', `'`, '`' ],
      preservingEmpty : 0,
      preservingQuoting : 1,
      stripping : 1
    }
    let args = _.strSplit( strOptions );

    let quotes = [ '"', `'`, '`' ];
    for( let i = 0; i < args.length; i++ )
    {
      let begin = _.strBeginOf( args[ i ], quotes ); /* xxx */
      let end = _.strEndOf( args[ i ], quotes );
      if( begin && end && begin === end )
      continue;

      if( _.longHas( quotes, args[ i ] ) )
      continue;

      let r = _.strQuoteAnalyze
      ({
        src : args[ i ],
        quote : strOptions.quotingPrefixes
      });

      quotes.forEach( ( quote ) =>
      {
        let found = _.strFindAll( args[ i ], quote );
        if( found.length % 2 === 0 )
        return;
        for( let k = 0 ; k < found.length ; k += 1 )
        {
          let pos = found[ k ].charsRangeLeft[ 0 ];
          for( let j = 0 ; j < r.ranges.length ; j += 2 )
          if( pos >= r.ranges[ j ] && pos <= r.ranges[ j + 1 ] )
          break;
          throw _.err( `Arguments string in execPath: ${src} has not closed quoting in argument: ${args[ i ]}` );
        }
      })
    }

    return args;
  }

}

_argsForm.defaults =
{
  args : null,
  args2 : null,
  execPath : null,
  execPath2 : null,
  mode : null,
  interpreterArgs : null,
  passingThrough : null,
}

//

function _argUnqoute( arg )
{
  let quotes = [ '"', `'`, '`' ];
  let result = _.strInsideOf
  ({
    src : arg,
    begin : quotes,
    end : quotes,
    pairing : 1,
  })
  if( result )
  return result;
  return arg;
}

//

function _argsUnqoute( args )
{
  for( let i = 0; i < args.length; i++ )
  args[ i ] = _.process._argUnqoute( args[ i ] );
  return args;
}

// --
// escape
// --

function _argsEscape( args )
{
  /* xxx */

  for( let i = 0 ; i < args.length ; i++ )
  {
    let quotesToEscape = process.platform === 'win32' ? [ '"' ] : [ '"', '`' ];
    args[ i ] = _.process._argEscape( args[ i ] );
    args[ i ] = _.strQuote( args[ i ] );
    // args[ i ] = _.process._argEscape2( args[ i ]  ); /* zzz for Vova : use this routine, review fails */
  }

  return args;
}

//

function _argEscape( arg, quote )
{

  if( quote === undefined )
  quote = process.platform === 'win32' ? [ '"' ] : [ '"', '`' ];

  _.assert( _.strIs( arg ) );
  _.assert( !!quote );

  // xxx : remove this if after fix of strReplaceAll
  if( _.longIs( quote ) )
  {
    quote.forEach( ( quote ) => arg = act( arg, quote ) );
    return arg;
  }
  return act( arg, quote );

  function act( arg, quote )
  {
    _.assert( _.strIs( arg ) );
    _.assert( _.strIs( quote ) );
    return _.strReplaceAll( arg, quote, ( match, it ) =>
    {
      if( it.input[ it.charsRangeLeft[ 0 ] - 1 ] === '\\' )
      return match;
      return '\\' + match;
    });
  }
}

//

function _argEscape2( arg )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( arg ) );

  if( process.platform !== 'win32' )
  {
		// Backslash-escape any hairy characters:
    arg = arg.replace( /([^a-zA-Z0-9_])/g, '\\$1' );
  }
  else
  {
    //Sequence of backslashes followed by a double quote:
    //double up all the backslashes and escape the double quote
    arg = arg.replace( /(\\*)"/g, '$1$1\\"' );

    // Sequence of backslashes followed by the end of the string
    // (which will become a double quote later):
    // double up all the backslashes
    arg = arg.replace( /(\\*)$/,'$1$1' );

    // All other backslashes occur literally

    // Quote the whole thing:
    arg = `"${arg}"`;

    // Escape shell metacharacters:
    arg = arg.replace( /([()\][%!^"`<>&|;, *?])/g, '^$1' );
  }

  return arg;
}

//

function _argProgEscape( prog )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( prog ) );

  // Windows cmd.exe: needs special treatment
  if( process.platform === 'win32' )
  {
		// Escape shell metacharacters:
    prog = prog.replace( /([()\][%!^"`<>&|;, *?])/g, '^$1' );
  }
  else
  {
    // Unix shells: same procedure as for arguments
		prog = _.process._argEscape2( prog );
  }

  return prog;
}


//

function _argCmdEscape( prog, args )
{
  _.assert( arguments.length === 2 );
  _.assert( _.strIs( prog ) );
  _.assert( _.arrayIs( args ) );

  prog = _.process._argProgEscape( prog );

  if( !args.length )
  return prog;

  args = args.map( ( arg ) => _.process._argEscape2( arg ) );

  return `${prog} ${args.join( ' ' )}`;
}

// --
// meta
// --

function _Setup1()
{
  if( _.path && _.path.current )
  this._initialCurrentPath = _.path.current();

  _.process._eventAvailableHandle();
  _.process._exitHandlerRepair();
  _.process._eventsSetup();

}

// --
// declare
// --

let Events =
{
  available : [],
  exit : [],
  exitBefore : [],
}

let Extension =
{

  // etc

  isNativeDescriptor,
  isSession,
  pidFrom,

  // temp

  tempOpen,
  tempClose,

  // eventer

  on,
  _eventAvailableHandle,

  // event

  _exitHandlerRepair,
  _eventsSetup,
  _eventExitHandle,
  _eventExitBeforeHandle,

  // exit

  exitReason,
  exitCode,
  exit,
  exitWithBeep,

  // args

  _argsForm,
  _argUnqoute,
  _argsUnqoute,

  // escape

  _argsEscape,
  _argEscape,
  _argEscape2,
  _argProgEscape,
  _argCmdEscape,

  // meta

  _Setup1,

  // fields

  _verbosity : 1,
  _sanitareTime : 1,
  _exitReason : null,
  exiting : false,

  _tempFiles,
  _registeredExitHandler : null,
  _registeredExitBeforeHandler : null,
  _initialCurrentPath : null,

}

Object.assign( _.process, Extension );
_.props.supplement( _.process._edispatcher.events, Events );
_.assert( !_.process.start );
_.process._Setup1();

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

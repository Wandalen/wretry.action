( function _Execution_s_()
{

'use strict';

let System, ChildProcess, WindowsProcessTree, Stream;
const _global = _global_;
const _ = _global_.wTools;
_.process = _.process || Object.create( null );

_.assert( !!_realGlobal_ );

// --
// starter
// --

/* Return values of routine start for each combination of options sync and deasync:

  Single process
  | Combination      | Options map | Consequence |
  | ---------------- | ----------- | ----------- |
  | sync:0 deasync:0 | +           | +           |
  | sync:1 deasync:1 | +           | -           |
  | sync:0 deasync:1 | +           | +           |
  | sync:1 deasync:0 | +           | -           |

  Multiple processes
  | Combination      | Array of maps of options | Single options map | Consequence |
  | ---------------- | ------------------------ | ------------------ | ----------- |
  | sync:0 deasync:0 | +                        | -                  | +           |
  | sync:1 deasync:1 | +                        | -                  | -           |
  | sync:0 deasync:1 | +                        | -                  | +           |
  | sync:1 deasync:0 | -                        | +                  | -           |
*/

//

function startMinimalHeadCommon( routine, args )
{
  let o;

  if( _.strIs( args[ 0 ] ) || _.arrayIs( args[ 0 ] ) )
  o = { execPath : args[ 0 ] };
  else
  o = args[ 0 ];

  o = _.routine.options_( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1, 'Expects single argument' );
  _.assert( _.longHas( [ 'fork', 'spawn', 'shell' ], o.mode ), `Supports mode::[ 'fork', 'spawn', 'shell' ]. Unknown mode ${o.mode}` );
  _.assert( !!o.args || !!o.execPath, 'Expects {-args-} either {-execPath-}' )
  _.assert
  (
    o.args === null || _.arrayIs( o.args ) || _.strIs( o.args ) || _.routineIs( o.args )
    , () => `If defined option::arg should be either [ string, array, routine ], but it is ${_.entity.strType( o.args )}`
  );

  /* timeOut */

  _.assert
  (
    o.timeOut === null || _.numberIs( o.timeOut ),
    () => `Expects null or number {-o.timeOut-}, but got ${_.entity.strType( o.timeOut )}`
  );
  _.assert
  (
    o.timeOut === null || !o.sync || !!o.deasync, `Option::timeOut should not be defined if option::sync:1 and option::deasync:0`
  );

  _.assert
  (
    !o.detaching || !_.longHas( _.array.as( o.stdio ), 'inherit' ),
    `Unsupported stdio: ${o.stdio} for process detaching. Parent will wait for child process.` /* zzz : check */
  );
  _.assert( !o.detaching || _.longHas( [ 'fork', 'spawn', 'shell' ], o.mode ), `Unsupported mode: ${o.mode} for process detaching` );
  _.assert( o.conStart === null || _.routineIs( o.conStart ) );
  _.assert( o.conTerminate === null || _.routineIs( o.conTerminate ) );
  _.assert( o.conDisconnect === null || _.routineIs( o.conDisconnect ) );
  _.assert( o.ready === null || _.routineIs( o.ready ) );
  _.assert( o.mode !== 'fork' || !o.sync || !!o.deasync, 'Mode::fork is available only if either sync:0 or deasync:1' );

  if( _.boolLike( o.throwingExitCode ) )
  o.throwingExitCode = o.throwingExitCode ? 'full' : false;
  _.assert
  (
    _.longHasAny( [ false, 'full', 'brief' ], o.throwingExitCode )
    , `Unknown value of option::throwingExitCode, acceptable : [ false, 'full', 'brief' ]`
  );

  if( o.outputColoring === null || _.boolLikeTrue( o.outputColoring ) )
  o.outputColoring = { out : 1, err : 1 };
  if( _.boolLikeFalse( o.outputColoring ) )
  o.outputColoring = { out : 0, err : 0 };
  _.assert( _.object.isBasic( o.outputColoring ) );
  _.assert
  (
    _.boolLike( o.outputColoring.out ),
    `o.outputColoring.out expects BoolLike, but got ${o.outputColoring.out}`
  );
  _.assert
  (
    _.boolLike( o.outputColoring.err ),
    `o.outputColoring.err expects BoolLike, but got ${o.outputColoring.err}`
  );

  if( !_.numberIs( o.verbosity ) )
  o.verbosity = o.verbosity ? 1 : 0;
  if( o.verbosity < 0 )
  o.verbosity = 0;
  if( o.outputPiping === null )
  {
    if( o.stdio === 'pipe' || o.stdio[ 1 ] === 'pipe' )
    o.outputPiping = o.verbosity >= 2;
  }
  o.outputPiping = !!o.outputPiping;
  _.assert( _.numberIs( o.verbosity ) );
  _.assert( _.boolLike( o.outputPiping ) );
  _.assert( _.boolLike( o.outputCollecting ) );

  if( Config.debug )
  if( o.outputPiping || o.outputCollecting )
  _.assert
  (
    o.stdio === 'pipe' || o.stdio[ 1 ] === 'pipe' || o.stdio[ 2 ] === 'pipe'
    , '"stdout" is not available to collect output or pipe it. Set stdout/stderr channel(s) or option::stdio to "pipe", please'
  );

  if( o.outputAdditive === null )
  o.outputAdditive = true; /* yyy */
  o.outputAdditive = !!o.outputAdditive;
  _.assert( _.boolLike( o.outputAdditive ) );

  if( o.ipc === null )
  o.ipc = o.mode === 'fork' ? true : false;
  _.assert( _.boolLike( o.ipc ) );

  if( _.strIs( o.stdio ) )
  o.stdio = _.dup( o.stdio, 3 );
  if( o.ipc )
  {
    if( !_.longHas( o.stdio, 'ipc' ) )
    o.stdio.push( 'ipc' );
  }

  _.assert( _.longIs( o.stdio ) );
  _.assert( !o.ipc || _.longHas( [ 'fork', 'spawn' ], o.mode ), `Mode::${o.mode} doesn't support inter process communication.` );
  _.assert( o.mode !== 'fork' || !!o.ipc, `In mode::fork option::ipc must be true. Such subprocess can not have no ipc.` );

  if( _.strIs( o.interpreterArgs ) )
  o.interpreterArgs = _.strSplitNonPreserving({ src : o.interpreterArgs });
  _.assert( o.interpreterArgs === null || _.arrayIs( o.interpreterArgs ) );

  _.assert
  (
    ( _.numberIs( o.streamSizeLimit ) && o.streamSizeLimit > 0 ) || o.streamSizeLimit === null,
    'Option::streamSizeLimit must be a positive Number which is greater than zero'
  )

  if( o.streamSizeLimit !== null )
  _.assert
  (
    o.sync && ( o.mode === 'spawn' || o.mode === 'shell' ),
    'Option::streamSizeLimit is supported in mode::spawn and mode::shell with sync::1'
  )

  return o;
}

//

function startMinimal_head( routine, args )
{
  let o = startMinimalHeadCommon( routine, args );

  _.assert( arguments.length === 2 );

  _.assert( _.longHas( [ 'instant' ], o.when ) || _.object.isBasic( o.when ), `Unsupported starting mode: ${o.when}` );

  _.assert
  (
    o.execPath === null || _.strIs( o.execPath )
    , () => `Expects string or strings {-o.execPath-}, but got ${_.entity.strType( o.execPath )}`
  );

  _.assert
  (
    o.currentPath === null || _.strIs( o.currentPath )
    , () => `Expects string or strings {-o.currentPath-}, but got ${_.entity.strType( o.currentPath )}`
  );

  return o;
}

//

function startMinimal_body( o )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  /* qqq for junior : use buffer instead */
  let _errOutput = '';
  let _decoratedOutOutput = '';
  let _outAdditive = '';
  let _decoratedErrOutput = '';
  let _errAdditive = '';
  let _errPrefix = null;
  let _outPrefix = null;
  let _readyCallback;

  form1();
  form2();

  return run1();

  /* subroutines :

  form1,
  form2,
  form3,
  run1,
  run2,
  run3,
  runFork,
  runSpawn,
  runShell,
  end1,
  end2,
  end3,

  handleClose,
  handleExit,
  handleError,
  handleDisconnect,
  disconnect,
  timeOutForm,
  pipe,
  inputMirror,
  argsForm,
  optionsForSpawn,
  optionsForFork,
  execPathForFork,
  _handleProcedureTerminationBegin,
  exitCodeSet,
  infoGet,
  handleStreamOutput,
  log,

*/

  /* */

  function form1()
  {

    if( o.ready === null )
    {
      o.ready = new _.Consequence().take( null );
    }
    else if( !_.consequenceIs( o.ready ) )
    {
      _readyCallback = o.ready;
      _.assert( _.routineIs( _readyCallback ) );
      o.ready = new _.Consequence().take( null );
    }

    _.assert( !_.consequenceIs( o.ready ) || o.ready.resourcesCount() <= 1 );

    /* procedure */

    if( o.procedure === null || _.boolLikeTrue( o.procedure ) ) /* xxx : qqq : for junior : bad  | aaa : fixed. */
    o.stack = _.Procedure.Stack( o.stack, 4 ); /* delta : 4 to not include info about `routine.unite` in the stack */

  }

  /* */

  function form2()
  {

    o.logger = o.logger || _global.logger;

    /* consequences */

    if( o.conStart === null )
    {
      o.conStart = new _.Consequence();
    }
    else if( !_.consequenceIs( o.conStart ) )
    {
      o.conStart = new _.Consequence().finally( o.conStart );
    }

    if( o.conTerminate === null )
    {
      o.conTerminate = new _.Consequence();
    }
    else if( !_.consequenceIs( o.conTerminate ) )
    {
      o.conTerminate = new _.Consequence({ _procedure : false }).finally( o.conTerminate );
    }

    if( o.conDisconnect === null )
    {
      o.conDisconnect = new _.Consequence();
    }
    else if( !_.consequenceIs( o.conDisconnect ) )
    {
      o.conDisconnect = new _.Consequence({ _procedure : false }).finally( o.conDisconnect );
    }

    _.assert( o.conStart !== o.conTerminate );
    _.assert( o.conStart !== o.conDisconnect );
    _.assert( o.conTerminate !== o.conDisconnect );
    _.assert( o.ready !== o.conStart && o.ready !== o.conDisconnect && o.ready !== o.conTerminate );
    _.assert( o.conStart.resourcesCount() === 0 );
    _.assert( o.conDisconnect.resourcesCount() === 0 );
    _.assert( o.conTerminate.resourcesCount() === 0 );

    /* output */

    _.assert( _.object.isBasic( o.outputColoring ) );
    _.assert( _.boolLike( o.outputCollecting ) );

    /* ipc */

    _.assert( _.boolLike( o.ipc ) );
    _.assert( _.longIs( o.stdio ) );
    _.assert( !o.ipc || _.longHas( [ 'fork', 'spawn' ], o.mode ), `Mode::${o.mode} doesn't support inter process communication.` );
    _.assert( o.mode !== 'fork' || !!o.ipc, `In mode::fork option::ipc must be true. Such subprocess can not have no ipc.` );

    /* etc */

    _.assert( !_.arrayIs( o.execPath ) && !_.arrayIs( o.currentPath ) );

    /* */

    if( !_.strIs( o.when ) )
    {
      if( Config.debug )
      {
        let keys = _.props.keys( o.when );
        _.assert( _.mapIs( o.when ) );
        _.assert( keys.length === 1 && _.longHas( [ 'time', 'delay' ], keys[ 0 ] ) );
        _.assert( _.numberIs( o.when.delay ) || _.numberIs( o.when.time ) )
      }
      if( o.when.time !== undefined )
      o.when.delay = Math.max( 0, o.when.time - _.time.now() );
      _.assert
      (
        o.when.delay >= 0,
        `Wrong value of {-o.when.delay } or {-o.when.time-}. Starting delay should be >= 0, current : ${o.when.delay}`
      );
    }

    /* */

    // xxx
    // _.assert( _.mapIs( o ) );
    // let o3 = _.ProcessMinimal.Retype( o );
    // _.assert( o3 === o );
    // _.assert( !Object.isExtensible( o ) );

    /* */

    o.disconnect = disconnect;
    o._end = end3;
    o.state = 'initial'; /* `initial`, `starting`, `started`, `terminating`, `terminated`, `disconnected` */
    o.exitReason = null;
    o.exitCode = null;
    o.exitSignal = null;
    o.error = o.error || null;
    o.args2 = null;
    o.pnd = null;
    o.execPath2 = null;
    o.output = o.outputCollecting ? '' : null;
    o.ended = false;
    o._handleProcedureTerminationBegin = false;
    o.streamOut = null;
    o.streamErr = null;

    Object.preventExtensions( o );
  }

  /* */

  function form3()
  {

    if( o.procedure === null || _.boolLikeTrue( o.procedure ) )
    {
      o.procedure = _.Procedure({ _stack : o.stack });
    }

    if( _.routineIs( o.args ) )
    o.args = o.args( o );
    if( o.args === null )
    o.args = [];

    _.assert
    (
      _.arrayIs( o.args ) || _.strIs( o.args )
      , () => `If defined option::arg should be either [ string, array ], but it is ${_.entity.strType( o.args )}`
    );

    argsForm();

    /* */

    o.currentPath = _.path.resolve( o.currentPath || '.' );

    _.assert( _.boolLike( o.outputAdditive ) );
    _.assert( _.numberIs( o.verbosity ) );
    _.assert( _.boolLike( o.outputPiping ) );
    _.assert( _.boolLike( o.outputCollecting ) );

    /* dependencies */

    if( !ChildProcess )
    ChildProcess = require( 'child_process' );

    // if( o.outputGraying )
    // if( !StripAnsi )
    // StripAnsi = require( 'strip-ansi' );

    if( o.outputColoring.err || o.outputColoring.out && typeof module !== 'undefined' )
    try
    {
      _.include( 'wColor' );
    }
    catch( err )
    {
      o.outputColoring.err = 0;
      o.outputColoring.out = 0;
      if( o.verbosity >= 2 )
      log( _.errOnce( err ), 'err' );
    }

    /* prefixing */

    if( o.outputPrefixing )
    {
      _errPrefix = `${ ( o.outputColoring.err ? _.ct.format( 'err', { fg : 'dark red' } ) : 'err' ) } : `;
      _outPrefix = `${ ( o.outputColoring.out ? _.ct.format( 'out', { fg : 'dark white' } ) : 'out' ) } : `;
    }

    /* handler of event terminationBegin */

    if( o.detaching )
    {
      let handler = _.procedure.on( 'terminationBegin', _handleProcedureTerminationBegin ); /* zzz : use handler instead of callback */
      o._handleProcedureTerminationBegin = _handleProcedureTerminationBegin;
    }

    /* if session already has error, running should not start */
    if( o.error )
    throw o.error;
  }

  /* */

  function run1()
  {

    if( o.sync && !o.deasync )
    {
      try
      {
        o.ready.deasync();
        o.ready.thenGive( 1 );
        if( o.when.delay )
        _.time.sleep( o.when.delay );
        run2();
      }
      catch( err )
      {
        if( !o.ended )
        end2( err );
        throw err;
      }
      _.assert( o.state === 'terminated' || o.state === 'disconnected' );
      end2( undefined );
    }
    else
    {
      /* qqq for Dmytro : ! */
      // console.log( 'run1', o.ready.exportString() );
      if( o.when.delay )
      o.ready.delay( o.when.delay );
      o.ready.thenGive( run2 );
    }

    return end1();
  }

  /* */

  function run2()
  {
    // console.log( 'run2', o.ready.exportString() );

    try
    {

      form3();
      run3();
      timeOutForm();
      pipe();
      disconnectMaybe();

      /* qqq for Dmytro : ! */
      // console.log( 'run2:1' );
      if( o.dry )
      {
        // console.log( 'run2:2' );
        if( o.error )
        handleError( o.error );
        else
        handleClose( null, null );
        // console.log( 'run2:3' );
      }
      else
      {
        if( o.sync && !o.deasync )
        {
          if( o.pnd.error )
          handleError( o.pnd.error );
          else
          handleClose( o.pnd.status, o.pnd.signal );
        }
      }
      // console.log( 'run2:4' );

    }
    catch( err )
    {
      handleError( err );
    }

  }

  /* */

  function run3()
  {

    _.assert( o.state === 'initial' );
    o.state = 'starting';

    if( Config.debug )
    _.assert
    (
      _.fileProvider.resolvedIsDir( o.currentPath ),
      () => `Current path ( ${o.currentPath} ) doesn\'t exist or it\'s not a directory.\n> ${o.execPath2}`
    );

    if( o.mode === 'fork')
    runFork();
    else if( o.mode === 'spawn' )
    runSpawn();
    else if( o.mode === 'shell' )
    runShell();
    else _.assert( 0, `Unknown mode ${o.mode} to start process at path ${o.currentPath}` );

    /* procedure */

    if( o.procedure )
    {
      if( o.pnd )
      {
        let name = 'PID:' + o.pnd.pid;
        if( Config.debug )
        {
          let result = _.procedure.find( name );
          _.assert( result.length === 0, `No procedure expected for child process with pid:${o.pnd.pid}` );
        }
        o.procedure.name( name );
      }
      o.procedure._object = o.pnd;
      o.procedure.begin();
    }

    /* state */

    o.state = 'started';

    if( o.detaching !== 2 )
    o.conStart.take( o );

  }

  /* */

  function runFork()
  {
    let execPath = o.execPath;

    let o2 = optionsForFork();
    execPath = execPathForFork( execPath );

    execPath = _.path.nativize( execPath );

    o.execPath2 = _.strConcat([ execPath, ... o.args2 ]);
    inputMirror();

    if( o.dry )
    return;

    o.pnd = ChildProcess.fork( execPath, o.args2, o2 );

  }

  /* */

  function runSpawn()
  {
    let execPath = o.execPath;

    execPath = _.path.nativizeMinimal( execPath );

    let o2 = optionsForSpawn();

    o.execPath2 = _.strConcat([ execPath, ... o.args2 ]);
    inputMirror();

    if( o.dry )
    return;

    if( o.sync && !o.deasync )
    o.pnd = ChildProcess.spawnSync( execPath, o.args2, o2 );
    else
    o.pnd = ChildProcess.spawn( execPath, o.args2, o2 );

  }

  /* */

  function runShell()
  {
    let execPath = o.execPath;

    execPath = _.path.nativizeEscaping( execPath );
    /* execPath = _.process._argProgEscape( execPath ); */
    /* zzz for Vova: use this routine, review fails */

    let shellPath = process.platform === 'win32' ? 'cmd' : 'sh';
    let arg1 = process.platform === 'win32' ? '/c' : '-c';
    let arg2 = execPath;
    let o2 = optionsForSpawn();

    /*

    windowsVerbatimArguments allows to have arguments with space(s) in shell on Windows
    Following calls will not work as expected( argument will be splitted by space ), if windowsVerbatimArguments is disabled:

    _.process.start( 'node path/to/script.js "path with space"' );
    _.process.start({ execPath : 'node path/to/script.js', args : [ "path with space" ] });

   */

    o2.windowsVerbatimArguments = true;

    if( o.args2.length )
    arg2 = arg2 + ' ' + o.args2.join( ' ' );

    o.execPath2 = arg2;

    /* zzz for Vova : Fixes problem with space in path on windows and makes behavior similar to unix
      Examples:
      win: shell({ execPath : '"/path/with space/node.exe"', throwingExitCode : 0 }) - works
      unix: shell({ execPath : '"/path/with space/node"', throwingExitCode : 0 }) - works
      both: shell({ execPath : 'node -v && node -v', throwingExitCode : 0 }) - prints version twice
      both: shell({ execPath : '"node -v && node -v"', throwingExitCode : 0 }) - expected error about unknown command
    */

    if( process.platform === 'win32' )
    arg2 = _.strQuote( arg2 );

    inputMirror();

    if( o.dry )
    return;

    if( o.sync && !o.deasync )
    o.pnd = ChildProcess.spawnSync( shellPath, [ arg1, arg2 ], o2 );
    else
    o.pnd = ChildProcess.spawn( shellPath, [ arg1, arg2 ], o2 );
  }

  /* */

  function end1()
  {
    if( _readyCallback )
    o.ready.finally( _readyCallback );
    if( o.deasync )
    o.ready.deasync();
    if( o.sync )
    return o.ready.sync();
    return o.ready;
  }

  /* */

  function end2( err )
  {

    if( Config.debug )
    try
    {
      _.assert( o.state === 'terminated' || o.state === 'disconnected' || !!o.error );
      _.assert( o.ended === false );
    }
    catch( err2 )
    {
      err = err || err2;
    }

    if( err )
    o.error = o.error || err;

    return end3();
  }

  /* */

  function end3()
  {

    if( o.procedure )
    if( o.procedure.isAlive() )
    o.procedure.end();
    else
    o.procedure.finit();

    if( o._handleProcedureTerminationBegin )
    {
      _.procedure.off( 'terminationBegin', o._handleProcedureTerminationBegin );
      o._handleProcedureTerminationBegin = false;
    }

    if( !o.outputAdditive )
    {
      if( _decoratedOutOutput )
      o.logger.log( _decoratedOutOutput );
      if( _decoratedErrOutput )
      o.logger.error( _decoratedErrOutput );
    }

    if( o.exitReason === null && o.error )
    o.exitReason = 'error';

    o.ended = true;
    Object.freeze( o );

    let consequence1 = o.state === 'disconnected' ? o.conDisconnect : o.conTerminate;
    let consequence2 = o.state === 'disconnected' ? o.conTerminate : o.conDisconnect;

    if( o.error )
    {
      if( o.state === 'initial' || o.state === 'starting' )
      o.conStart.error( o.error );
      consequence1.error( o.error );
      consequence2.error( o.error );
      o.ready.error( o.error );
      if( o.sync && !o.deasync )
      throw _.err( o.error );
    }
    else
    {
      consequence1.take( o );
      consequence2.error( _.dont );
      o.ready.take( o );
    }

    return o;
  }

  /* */

  function handleClose( exitCode, exitSignal )
  {
    // /*
    // console.log( 'handleClose', _.process.realMainFile(), o.ended, ... arguments );
    // */

    if( o.outputAdditive && _outAdditive )
    {
      o.logger.log( _outAdditive );
      _outAdditive = '';
    }

    if( o.ended )
    return;

    o.state = 'terminated';

    exitCodeSet( exitCode );
    o.exitSignal = exitSignal;
    if( o.pnd && o.pnd.signalCode === undefined )
    o.pnd.signalCode = exitSignal;

    if( o.error )
    throw err;

    if( exitSignal )
    o.exitReason = 'signal';
    else if( exitCode )
    o.exitReason = 'code';
    else if( exitCode === 0 )
    o.exitReason = 'normal';

    if( o.verbosity >= 5 && o.inputMirroring )
    {
      log( ` < Process returned error code ${exitCode}\n`, 'out' );
      if( exitCode )
      log( infoGet(), 'out' );
    }

    if( !o.error && o.throwingExitCode )
    if( exitSignal || exitCode ) /* should be not strict condition to handle properly value null */
    {
      if( _.numberIs( exitCode ) )
      o.error = _._err({ args : [ 'Process returned exit code', exitCode, '\n', infoGet() ], reason : 'exit code' });
      else if( o.reason === 'time' )
      o.error = _._err({ args : [ 'Process timed out, killed by exit signal', exitSignal, '\n', infoGet() ], reason : 'time out' });
      else
      o.error = _._err({ args : [ 'Process was killed by exit signal', exitSignal, '\n', infoGet() ], reason : 'exit signal' });
      if( o.throwingExitCode === 'brief' )
      o.error = _.errBrief( o.error );
    }

    if( o.error )
    {
      end2( o.error );
    }
    else if( !o.sync || o.deasync )
    {
      end2( undefined );
    }

  }

  /* */

  function handleExit( exitCode, exitSignal )
  {
    /* xxx : use handleExit */
    // /*
    // console.log( 'handleExit', _.process.realMainFile(), o.ended, ... arguments );
    // */
    // handleClose( exitCode, exitSignal );
  }

  /* */

  function handleError( err )
  {
    err = _.err
    (
      err
      , `\nError starting the process`
      , `\n    Exec path : ${o.execPath2 || o.execPath}`
      , `\n    Current path : ${o.currentPath}`
    );

    if( o.outputAdditive && _errAdditive )
    {
      o.logger.error( _errAdditive );
      _errAdditive = '';
    }

    if( o.ended )
    {
      throw err;
    }

    exitCodeSet( -1 );

    o.exitReason = 'error';
    o.error = err;
    if( o.verbosity )
    log( _.errOnce( o.error ), 'err' );

    end2( o.error );
  }

  /* */

  function handleDisconnect( arg )
  {
    /*
    console.log( 'handleDisconnect', _.process.realMainFile(), o.ended );
    */

    /*
    event "disconnect" may come just before event "close"
    so need to give a chance to event "close" to come first
    */

    /*
    if( !o.ended )
    _.time.begin( 1000, () =>
    {
      if( !o.ended )
      {
        o.state = 'disconnected';
        o.conDisconnect.take( this );
        end2( undefined );
        throw _.err( 'not tested' );
      }
    });
    */

    /* bad solution
    subprocess waits what does not let emit event "close" in parent process
    */

    if( o.detaching === 2 )
    o.conStart.take( o );

  }

  /* */

  function disconnect()
  {
    /*
    console.log( 'disconnect', _.process.realMainFile(), this.ended );
    */

    _.assert( !!this.pnd, 'Process is not started. Cant disconnect.' );

    /*
    close event will not be called for regular/detached process
    */

    if( this.pnd.stdin )
    this.pnd.stdin.end();
    if( this.pnd.stdout )
    this.pnd.stdout.destroy();
    if( this.pnd.stderr )
    this.pnd.stderr.destroy();

    this.pnd.unref();

    if( this.pnd.disconnect )
    if( this.pnd.connected )
    this.pnd.disconnect();

    if( !this.ended )
    {
      this.state = 'disconnected';
      end2( undefined );
    }

    return true;
  }

  /* */

  function timeOutForm()
  {

    if( o.timeOut && !o.dry )
    if( !o.sync || o.deasync )
    _.time.begin( o.timeOut, () =>
    {
      if( o.state === 'terminated' || o.error )
      return;
      o.exitReason = 'time';
      _.process.terminate
      ({
        pnd : o.pnd,
        withChildren : 1,
        ignoringErrorPerm : 1,
      });
    });

  }

  /* */

  function pipe()
  {
    if( o.dry )
    return;

    _.assert
    (
      ( !o.outputPiping && !o.outputCollecting ) || !!o.pnd.stdout || !!o.pnd.stderr,
      'stdout is not available to collect output or pipe it. Set option::stdio to "pipe"'
    );

    if( _.streamIs( o.pnd.stdout ) )
    o.streamOut = o.pnd.stdout;
    if( _.streamIs( o.pnd.stderr ) )
    o.streamErr = o.pnd.stderr;

    /* piping out channel */

    if( o.outputPiping || o.outputCollecting )
    if( o.pnd.stdout )
    if( o.sync && !o.deasync )
    handleStreamOutput( o.pnd.stdout, 'out' );
    else
    o.pnd.stdout.on( 'data', ( data ) => handleStreamOutput( data, 'out' ) );

    /* piping error channel */

    /*
    there is no if options here because algorithm should collect error output in _errOutput anyway
    */
    if( o.pnd.stderr )
    if( o.sync && !o.deasync )
    handleStreamOutput( o.pnd.stderr, 'err' );
    else
    o.pnd.stderr.on( 'data', ( data ) => handleStreamOutput( data, 'err' ) );

    /* handling */

    if( !o.sync || o.deasync )
    {
      o.pnd.on( 'error', handleError );
      o.pnd.on( 'close', handleClose );
      o.pnd.on( 'exit', handleExit );
      o.pnd.on( 'disconnect', handleDisconnect );
    }

  }

  /* */

  function inputMirror()
  {
    /* logger */
    try
    {

      if( !o.inputMirroring )
      return;

      if( o.verbosity >= 3 )
      {
        let output = ' @ ';
        if( o.outputColoring.out )
        output = _.ct.format( output, { fg : 'bright white' } ) + _.ct.format( o.currentPath, 'path' );
        else
        output = output + o.currentPath
        log( output + '\n', 'out' );
      }

      if( o.verbosity )
      {
        let prefix = ' > ';
        if( o.outputColoring.out )
        prefix = _.ct.format( prefix, { fg : 'bright white' } );
        log( prefix + o.execPath2 + '\n', 'out' );
      }

    }
    catch( err )
    {
      log( _.errOnce( err ), 'err' );
    }
  }

  /* */

  function argsForm()
  {
    _.process._argsForm( o );
  }

  /* */

  function optionsForSpawn()
  {
    let o2 = Object.create( null );
    if( o.stdio )
    o2.stdio = o.stdio;
    o2.detached = !!o.detaching;
    if( o.env )
    o2.env = o.env;
    if( o.currentPath )
    o2.cwd = _.path.nativize( o.currentPath );
    if( o.timeOut && o.sync )
    o2.timeout = o.timeOut;
    o2.windowsHide = !!o.hiding;
    if( o.streamSizeLimit )
    o2.maxBuffer = o.streamSizeLimit;

    if( process.platform !== 'win32' )
    {
      o2.uid = o.uid;
      o2.gid = o.gid;
    }
    return o2;
  }

  /* */

  function optionsForFork()
  {
    let o2 =
    {
      detached : !!o.detaching,
      env : o.env,
      stdio : o.stdio,
      execArgv : o.interpreterArgs || process.execArgv,
    }
    if( o.currentPath )
    o2.cwd = _.path.nativize( o.currentPath );
    if( process.platform !== 'win32' )
    {
      o2.uid = o.uid;
      o2.gid = o.gid;
    }
    return o2;
  }

  /* */

  function execPathForFork( execPath )
  {
    return _.process._argUnqoute( execPath );
  }

  /* */

  function _handleProcedureTerminationBegin()
  {
    o.disconnect();
  }

  /* */

  function exitCodeSet( exitCode )
  {
    /*
    console.log( _.process.realMainFile(), 'exitCodeSet', exitCode );
    */
    if( o.exitCode )
    return;
    if( exitCode === null )
    return;
    o.exitCode = exitCode;
    if( o.pnd )
    if( o.pnd.exitCode === undefined || o.pnd.exitCode === null )
    o.pnd.exitCode = exitCode;
    exitCode = _.numberIs( exitCode ) ? exitCode : -1;
    if( o.applyingExitCode )
    _.process.exitCode( exitCode );
  }

  /* */

  function infoGet()
  {
    let result = '';
    result += `Launched as ${_.strQuote( o.execPath2 )} \n`;
    result += `Launched at ${_.strQuote( o.currentPath )} \n`;
    if( _errOutput.length )
    result += `\n -> Stderr\n -  ${_.strLinesIndentation( _errOutput, ' -  ' )} '\n -< Stderr\n`;
    return result;
  }

  /* */

  function handleStreamOutput( data, channel )
  {
    if( _.bufferNodeIs( data ) )
    data = data.toString( 'utf8' );

    if( !_.strIs( data ) )
    data = String( data );

    if( o.outputGraying )
    data = _.ct.stripAnsi( data );
    // data = StripAnsi( data );

    if( channel === 'err' )
    _errOutput += data;

    if( Object.isFrozen( o ) ) /* xxx */
    debugger;
    if( o.outputCollecting )
    o.output += data;

    if( !o.outputPiping )
    return;

    /* yyy qqq for junior : cover and complete */
    // data = _.strRemoveEnd( data, '\n' );

    let splits;
    if( o.outputPrefixing || ( channel === 'err' && o.outputColoring.err ) || ( channel === 'out' && o.outputColoring.out ) )
    splits = data.split( '\n' );

    /* qqq for junior : changed how option outputPrefixing works | aaa : Done. */
    if( o.outputPrefixing )
    {
      let prefix = channel === 'err' ? _errPrefix : _outPrefix;
      splits = splits.map( ( split, i ) => ( i < splits.length-1 || split.length ) ? prefix + split : split );
      // data = prefix + _.strLinesIndentation( data, prefix );
    }

    if( channel === 'err' )
    {
      if( o.outputColoring.err )
      splits = splits.map( ( data ) => data ? _.ct.format( data, 'pipe.negative' ) : data );
      // data = _.ct.format( data, 'pipe.negative' );
    }
    else if( channel === 'out' )
    {
      if( o.outputColoring.out )
      splits = splits.map( ( data ) => data ? _.ct.format( data, 'pipe.neutral' ) : data );
      // data = _.ct.format( data, 'pipe.neutral' );
    }
    else _.assert( 0 );

    if( splits !== undefined )
    data = splits.join( '\n' )

    log( data, channel );
  }

  /* */

  function log( msg, channel )
  {
    _.assert( channel === 'err' || channel === 'out' );

    if( msg === undefined )
    return;

    if( !_.strIs( msg ) )
    {
      msg = String( msg );
      if( !_.strEnds( msg, '\n' ) )
      msg = msg + '\n';
    }

    if( o.outputAdditive )
    {

      if( _.strEnds( msg, '\n' ) )
      {
        // msg = _.strRemoveEnd( msg, '\n' );
        if( channel === 'err' )
        {
          msg = _errAdditive + _.strRemoveEnd( msg, '\n' );
          _errAdditive = '';
        }
        else
        {
          msg = _outAdditive + _.strRemoveEnd( msg, '\n' );
          _outAdditive = '';
        }
      }
      else
      {
        /* xxx yyy qqq for junior : not implemeted yet | aaa : Implemented. */
        if( !_.strHas( msg, '\n' ) )
        {
          if( channel === 'err' )
          _errAdditive += msg;
          else
          _outAdditive += msg;
          return;
        }
        else
        {
          let lastBreak = msg.lastIndexOf( '\n' );
          let left = msg.slice( lastBreak + 1 );
          msg = msg.slice( 0, lastBreak );
          if( channel === 'err' )
          _errAdditive += left;
          else
          _outAdditive += left;
        }
      }
      /* qqq : for junior : bad : it cant be working */
      if( channel === 'err' )
      o.logger.error( msg );
      else
      o.logger.log( msg );
    }
    else
    {
      _decoratedOutOutput += msg;
      if( channel === 'err' )
      _decoratedErrOutput += msg;
      /* yyy qqq for junior : cover */
      // _decoratedOutOutput += msg + '\n';
      // if( channel === 'err' )
      // _decoratedErrOutput += msg + '\n';
    }

  }

  /* */

  function disconnectMaybe()
  {
    if( o.detaching === 2 )
    o.disconnect();
  }

}

startMinimal_body.defaults =
{

  execPath : null,
  currentPath : null,
  args : null,
  interpreterArgs : null,
  passingThrough : 0,

  sync : 0,
  deasync : 0,
  when : 'instant', /* instant / afterdeath / time / delay */
  dry : 0,

  mode : 'shell', /* fork / spawn / shell */
  stdio : 'pipe', /* pipe / ignore / inherit */
  ipc : null,

  logger : null,
  procedure : null,
  stack : null,
  sessionId : 0,

  ready : null,
  conStart : null,
  conTerminate : null,
  conDisconnect : null,

  env : null,
  detaching : 0,
  hiding : 1,
  uid : null,
  gid : null,
  streamSizeLimit : null,
  timeOut : null,

  throwingExitCode : 'full', /* [ bool-like, 'full', 'brief' ] */ /* must be on by default */  /* qqq for junior : cover | aaa : Done. */
  applyingExitCode : 0,

  verbosity : 2,
  outputPrefixing : 0,
  outputPiping : null,
  outputCollecting : 0,
  outputAdditive : null, /* qqq for junior : cover the option | aaa : Done. */
  outputColoring : 1,
  outputGraying : 0,
  inputMirroring : 1,

}

/* xxx : move advanced options to _.process.startSingle() */

let startMinimal = _.routine.uniteCloning_replaceByUnite( startMinimal_head, startMinimal_body );

//

function startSingle_head( routine, args )
{
  let o = startMinimalHeadCommon( routine, args );

  _.assert( arguments.length === 2 );

  _.assert( _.longHas( [ 'instant', 'afterdeath' ], o.when ) || _.object.isBasic( o.when ), `Unsupported starting mode: ${o.when}` );

  return o;
}

//

function startSingle_body( o )
{
  let _readyCallback;

  if( o.when === 'afterdeath' )
  formAfterDeath();

  /* */

  form1();

  let result = _.process.startMinimal.body.call( _.process, o );

  if( o.when === 'afterdeath' )
  runAfterDeath();

  return result;

  /* subroutines :

  form1,
  run2,
  end1,

*/

  function form1()
  {

    if( o.ready === null )
    {
      o.ready = new _.Consequence().take( null );
    }
    else if( !_.consequenceIs( o.ready ) )
    {
      _readyCallback = o.ready;
      _.assert( _.routineIs( _readyCallback ) );
      o.ready = new _.Consequence().take( null );
    }

    _.assert( !_.consequenceIs( o.ready ) || o.ready.resourcesCount() <= 1 );

    /* procedure */

    if( o.procedure === null || _.boolLikeTrue( o.procedure ) )
    o.stack = _.Procedure.Stack( o.stack, 4 ); /* delta : 4 to not include info about `routine.unite` in the stack */

  }

  /* */

  function run1()
  {

    if( o.sync && !o.deasync )
    {
      try
      {
        o.ready.deasync();
        o.ready.thenGive( 1 );
        if( o.when.delay )
        _.time.sleep( o.when.delay );
        run2();
      }
      catch( err )
      {
        err = _.err( err );
        if( !o.ended )
        {
          o.error = o.error || err;
          o._end();
        }
        throw err;
      }
      _.assert( o.state === 'terminated' || o.state === 'disconnected' );
      o._end();
    }
    else
    {
      if( o.when.delay )
      o.ready.delay( o.when.delay );
      o.ready.thenGive( run2 );
    }

    return end1();
  }

  /* */

  function run2()
  {
    return _.process.startMinimal.body.call( _.process, o );
  }

  /* */

  function end1()
  {
    if( _readyCallback )
    o.ready.finally( _readyCallback );
    if( o.deasync )
    o.ready.deasync();
    if( o.sync )
    return o.ready.sync();
    return o.ready;
  }

  /* */

  function formAfterDeath()
  {
    let toolsPath = _.path.nativize( _.path.join( __dirname, '../../../../node_modules/Tools' ) );
    let excludeOptions =
    {
      ready : null,
      conStart : null,
      conTerminate : null,
      conDisconnect : null,
      logger : null,
      procedure : null,
      when : null,
      sessionId : null
    }
    let locals = { toolsPath, o : _.mapBut_( null, o, excludeOptions ), parentPid : process.pid };
    let secondaryProcessRoutine = _.program.preform({ entry : afterDeathSecondaryProcess, locals })
    let secondaryFilePath = _.process.tempOpen({ routineCode : secondaryProcessRoutine.entry.routineCode });

    o.execPath = _.path.nativize( secondaryFilePath );
    o.mode = 'fork';
    o.ipc = true;
    o.args = [];
    o.detaching = true;
    o.stdio = _.dup( 'ignore', 3 );
    o.stdio.push( 'ipc' );
    o.inputMirroring = 0;
    o.outputPiping = 0;
    o.outputCollecting = 0;

  }

  /* */

  function afterDeathSecondaryProcess()
  {
    const _ = require( toolsPath );
    _.include( 'wProcess' );
    _.include( 'wFilesBasic' );
    // let ipc = require( ipcPath );

    let ready = _.Consequence();
    let terminated = false;

    waitForParent( 1000 );

    // setupIpc();

    ready.then( () =>
    {
      // if( ipc.server.stop )
      // ipc.server.stop();

      return _.process.startMultiple( o );
    })

    process.send( 'ready' );

    /* */

    function waitForParent( period )
    {
      return _.time.periodic( period, () =>
      {
        if( terminated )
        return;
        if( _.process.isAlive( parentPid ) )
        return true;
        ready.take( true )
        terminated = true;
      })
    }

    // function setupIpc()
    // {
    //   ipc.config.id = 'afterdeath.' + process.pid;
    //   ipc.config.retry= 1500;
    //   ipc.config.silent = true;
    //   ipc.serve( () =>
    //   {
    //     ipc.server.on( 'exit', () =>
    //     {
    //       waitForParent( 150 );
    //     });
    //   });

    //   ipc.server.start();

    //   process.send( ipc.config.id )
    // }

  }

  /* */

  function runAfterDeath()
  {
    o.conStart.then( ( op ) =>
    {
      let disconnected = _.Consequence();

      o.pnd.on( 'message', () =>
      {
        o.pnd.on( 'disconnect', () => disconnected.take( op ) );
        o.disconnect();
      })

      return disconnected;

      // let ipc = require( 'node-ipc' );

      // o.pnd.on( 'message', ( ipcHostId ) =>
      // {
      //   o.disconnect();

      //   ipc.config.id = 'afterdeath.parent:' + process.pid;
      //   ipc.config.retry = 1500;
      //   ipc.config.silent = true;

      //   _.process.on( 'exit', () =>
      //   {
      //      ipc.connectTo( ipcHostId, () =>
      //      {
      //       ipc.of[ ipcHostId ].emit( 'exit', true );
      //       ipc.disconnect( ipcHostId );
      //      });
      //   })
      // })
    })
  }

}

startSingle_body.defaults =
{

  ... _.mapBut_( null, startMinimal.defaults, [ 'onStart', 'onTerminate', 'onDisconnect' ] ),

  when : 'instant',

  ready : null,
  conStart : null,
  conTerminate : null,
  conDisconnect : null,

}

let startSingle = _.routine.uniteCloning_replaceByUnite( startSingle_head, startSingle_body );

//

function startMultiple_head( routine, args )
{
  let o = startMinimalHeadCommon( routine, args );

  _.assert( arguments.length === 2 );

  _.assert( _.longHas( [ 'instant', 'afterdeath' ], o.when ) || _.object.isBasic( o.when ), `Unsupported starting mode: ${o.when}` );
  _.assert
  (
    !o.concurrent || !o.sync || !!o.deasync
    , () => `option::concurrent should be 0 if sync:1 and deasync:0`
  );
  _.assert
  (
    o.execPath === null || _.strIs( o.execPath ) || _.strsAreAll( o.execPath )
    , () => `Expects string or strings {-o.execPath-}, but got ${_.entity.strType( o.execPath )}`
  );
  _.assert
  (
    o.currentPath === null || _.strIs( o.currentPath ) || _.strsAreAll( o.currentPath )
    , () => `Expects string or strings {-o.currentPath-}, but got ${_.entity.strType( o.currentPath )}`
  );

  return o;
}

//

/**
 * @summary Executes command in a controled child process.
 *
 * @param {Object} o Options map
 * @param {String} o.execPath Command to execute, path to application, etc.
 * @param {String} o.currentPath Current working directory of child process.

 * @param {Boolean} o.sync=0 Execute command in synchronous mode.
   There are two synchrounous modes: first uses sync method of `ChildProcess` module , second uses async method, but in combination with {@link https://www.npmjs.com/package/deasync deasync} and `wConsequence` to turn async execution into synchrounous.
   Which sync mode will be selected depends on value of `o.deasync` option.
   Sync mode returns options map.
   Async mode returns instance of {@link module:Tools/base/Consequence.Consequence wConsequence} with gives a message( options map ) when execution of child process is finished.
 * @param {Boolean} o.deasync=1 Controls usage of `deasync` module in synchrounous mode. Allows to run command synchrounously in modes( o.mode ) that don't support synchrounous execution, like `fork`.

 * @param {Array} o.args=null Arguments for command.
 * @param {Array} o.interpreterArgs=null Arguments for node. Used only in `fork` mode. {@link https://nodejs.org/api/cli.html Command Line Options}
 * @param {String} o.mode='shell' Execution mode. Possible values: `fork`, `spawn`, `shell`. {@link https://nodejs.org/api/child_process.html Details about modes}
 * @param {Object} o.ready=null `wConsequence` instance that gives a message when execution is finished.
 * @param {Object} o.logger=null `wLogger` instance that prints output during command execution.

 * @param {Object} o.env=null Environment variables( key-value pairs ).
 * @param {String/Array} o.stdio='pipe' Controls stdin,stdout configuration. {@link https://nodejs.org/api/child_process.html#child_process_options_stdio Details}
 * @param {Boolean} o.ipc=0  Creates `ipc` channel between parent and child processes.
 * @param {Boolean} o.detaching=0 Creates independent process for a child. Allows child process to continue execution when parent process exits. Platform dependent option. {@link https://nodejs.org/api/child_process.html#child_process_options_detached Details}.
 * @param {Boolean} o.hiding=1 Hide the child process console window that would normally be created on Windows. {@link https://nodejs.org/api/child_process.html#child_process_child_process_spawn_command_args_options Details}.
 * @param {Boolean} o.passingThrough=0 Allows to pass arguments of parent process to the child process.
 * @param {Boolean} o.concurrent=0 Allows paralel execution of several child processes. By default executes commands one by one.
 * @param {Number} o.timeOut=null Time in milliseconds before execution will be terminated.

 * @param {Boolean} o.throwingExitCode='full' Throws an Error if child process returns non-zero exit code. Child returns non-zero exit code if it was terminated by parent, timeOut or when internal error occurs.

 * @param {Boolean} o.applyingExitCode=0 Applies exit code to parent process.

 * @param {Number} o.verbosity=2 Controls amount of output, `0` disables output at all.
 * @param {Boolean|Object} o.outputColoring=1 Logger prints with styles applied for both channels.
 *  Option can be specified more precisely via map of the form { out : 1, err : 0 }
 *  Coloring is applied to a corresponding channel.
 * @param {Boolean} o.outputPrefixing=0 Add prefix with name of output channel( stderr, stdout ) to each line.
 * @param {Boolean} o.outputPiping=null Handles output from `stdout` and `stderr` channels. Is enabled by default if `o.verbosity` levels is >= 2 and option is not specified explicitly. This option is required by other "output" options that allows output customization.
 * @param {Boolean} o.outputCollecting=0 Enables coullection of output into sinle string. Collects output into `o.output` property if enabled.
 * @param {Boolean} o.outputAdditive=null Prints output during execution. Enabled by default if shell executes only single command and option is not specified explicitly.
 * @param {Boolean} o.inputMirroring=1 Print complete input line before execution: path to command, arguments.
 *
 * @return {Object} Returns `wConsequence` instance in async mode. In sync mode returns options map. Options map contains not only input options, but child process descriptor, collected output, exit code and other useful info.
 *
 * @example //short way, command and arguments in one string
 *
 * const _ = require( 'wTools' )
 * _.include( 'wProcessBasic' )
 * _.include( 'wConsequence' )
 * _.include( 'wLogger' )
 *
 * let con = _.process.startMultiple( 'node -v' );
 *
 * con.then( ( op ) =>
 * {
 *  console.log( 'ExitCode:', op.exitCode );
 *  return op;
 * })
 *
 * @example //command and arguments as options
 *
 * const _ = require( 'wTools' )
 * _.include( 'wProcessBasic' )
 * _.include( 'wConsequence' )
 * _.include( 'wLogger' )
 *
 * let con = _.process.startMultiple({ execPath : 'node', args : [ '-v' ] });
 *
 * con.then( ( op ) =>
 * {
 *  console.log( 'ExitCode:', op.exitCode );
 *  return op;
 * })
 *
 * @function startMultiple
 * @module Tools/base/ProcessBasic
 * @namespace Tools.process
 */

function startMultiple_body( o )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  let _processPipeCounter = 0;
  let _readyCallback;

  form0();

  if( _.arrayIs( o.execPath ) || _.arrayIs( o.currentPath ) )
  return run1();

  return _.process.startSingle.body.call( this, o );

  /* subroutines index :

  form0,
  form1,
  form2,
  run1,
  run2,
  end1,
  end2,

  formStreams,
  processPipe,
  streamPipe,
  handleStreamOut,

*/

  /* */

  function form0()
  {
    if( o.procedure === null || _.boolLikeTrue( o.procedure ) ) /* xxx : qqq : for junior : bad  | aaa : fixed. */
    o.stack = _.Procedure.Stack( o.stack, 4 ); /* delta : 4 to not include info about `routine.unite` in the stack */
  }

  /* */

  function form1()
  {

    if( o.ready === null )
    {
      o.ready = new _.Consequence().take( null );
    }
    else if( !_.consequenceIs( o.ready ) )
    {
      _readyCallback = o.ready;
      _.assert( _.routineIs( _readyCallback ) );
      o.ready = new _.Consequence().take( null );
    }

    _.assert( !_.consequenceIs( o.ready ) || o.ready.resourcesCount() <= 1 );

    o.logger = o.logger || _global.logger;

  }

  /* */

  function form2()
  {

    if( o.conStart === null )
    {
      o.conStart = new _.Consequence();
    }
    else if( !_.consequenceIs( o.conStart ) )
    {
      o.conStart = new _.Consequence().finally( o.conStart );
    }

    if( o.conTerminate === null )
    {
      o.conTerminate = new _.Consequence();
    }
    else if( !_.consequenceIs( o.conTerminate ) )
    {
      o.conTerminate = new _.Consequence({ _procedure : false }).finally( o.conTerminate );
    }

    _.assert( _.object.isBasic( o.outputColoring ) );
    _.assert( _.boolLike( o.outputCollecting ) );

    if( o.outputAdditive === null )
    o.outputAdditive = _.arrayIs( o.execPath ) && o.execPath.length > 1 && o.concurrent;
    _.assert( _.boolLike( o.outputAdditive ) );
    o.currentPath = o.currentPath || _.path.current();

    // xxx
    // _.assert( _.mapIs( o ) );
    // let o3 = _.ProcessMultiple.Retype( o );
    // _.assert( o3 === o );
    // _.assert( !Object.isExtensible( o ) );

    o.sessions = [];
    o.state = 'initial'; /* `initial`, `starting`, `started`, `terminating`, `terminated`, `disconnected` */
    o.exitReason = null;
    o.exitCode = null;
    o.exitSignal = null;
    o.error = o.error || null;
    o.output = o.outputCollecting ? '' : null;
    o.ended = false;

    o.streamOut = null;
    o.streamErr = null

    Object.preventExtensions( o );

  }

  /* */

  function run1()
  {

    try
    {

      form1();
      form2();

      if( o.stdio[ 1 ] !== 'ignore' || o.stdio[ 2 ] !== 'ignore' )
      formStreams();

      if( o.procedure === null || _.boolLikeTrue( o.procedure ) )
      {
        o.procedure = _.procedure.begin({ _object : o, _stack : o.stack });
      }
      else if( o.procedure )
      {
        if( !o.procedure.isAlive() )
        o.procedure.begin();
      }

      if( o.sync && !o.deasync )
      o.ready.deasync();

    }
    catch( err )
    {
      err = _.err( err );
      end2( err, undefined );
    }

    o.ready
    .then( run2 )
    .finally( end2 )
    ;

    return end1();
  }

  /* */

  function run2()
  {
    let execPath = _.array.as( o.execPath );
    let currentPath = _.array.as( o.currentPath );
    let sessionId = 0;

    for( let p = 0 ; p < execPath.length ; p++ )
    for( let c = 0 ; c < currentPath.length ; c++ )
    {
      let currentReady = new _.Consequence();
      sessionId += 1;
      let o2 = _.props.extend( null, o );
      o2.conStart = null;
      o2.conTerminate = null;
      o2.conDisconnect = null;
      o2.execPath = execPath[ p ];
      o2.args = _.arrayIs( o.args ) ? o.args.slice() : o.args;
      o2.currentPath = currentPath[ c ];
      o2.ready = currentReady;
      o2.sessionId = sessionId;
      delete o2.sessions;
      delete o2.output;
      delete o2.exitReason;
      delete o2.exitCode;
      delete o2.exitSignal;
      delete o2.error;
      delete o2.ended;
      delete o2.concurrent;
      delete o2.state;

      if( !!o.procedure )
      o2.procedure = _.Procedure({ _stack : o.stack });

      if( o.deasync )
      {
        o2.deasync = 0;
        o2.sync = 0;
      }

      o.sessions.push( o2 );
    }

    /* xxx : introduce concurrent.limit */
    /* xxx qqq : cover sessionsRun */

    let o2;
    if( o.sessions.length ) /* Dmytro : for empty sessions creates procedure that never ended. In new PR added assertion for it */
    {
      o2 = _.sessionsRun
      ({
        concurrent : o.concurrent,
        sessions : o.sessions,
        conBeginName : 'conStart',
        conEndName : 'conTerminate',
        readyName : 'ready',
        onRun : ( session ) =>
        {
          _.map.assertHasAll( session, _.process.startSingle.defaults );
          _.process.startSingle.body.call( _.process, session );
          if( !o.dry )
          if( o.streamOut || o.streamErr )
          processPipe( session );
        },
        onBegin : ( err, o2 ) =>
        {
          if( !o.ended )
          o.state = o.concurrent ? 'started' : 'starting';
          o.conStart.take( err, err ? undefined : o );
        },
        onEnd : ( err, o2 ) =>
        {
          if( !o.ended )
          o.state = 'terminating';
          o.conTerminate.take( err, err ? undefined : o );
        },
        onError : ( err ) =>
        {
          o.error = o.error || err;
          if( o.state !== 'terminated' )
          serialEnd();
          throw err;
        },
        ready : null,
      });

      return o2.ready;
    }

    return _.take( null );
  }

  /* */

  function end1()
  {
    if( _readyCallback )
    o.ready.finally( _readyCallback );
    if( o.deasync )
    o.ready.deasync();
    if( o.sync )
    return o.ready.sync();
    return o.ready;
  }

  /* */

  function end2( err, arg )
  {
    o.state = 'terminated';
    o.ended = true;

    if( !o.error && err )
    o.error = err;

    if( o.procedure )
    if( o.procedure.isAlive() )
    o.procedure.end();
    else
    o.procedure.finit();

    if( o.exitCode === null && o.exitSignal === null )
    for( let a = 0 ; a < o.sessions.length ; a++ )
    {
      let o2 = o.sessions[ a ];
      if( o2.exitCode || o2.exitSignal )
      {
        o.exitCode = o2.exitCode;
        o.exitSignal = o2.exitSignal;
        o.exitReason = o2.exitReason;
        break;
      }
    }

    if( o.exitCode === null && o.exitSignal === null )
    for( let a = 0 ; a < o.sessions.length ; a++ )
    {
      let o2 = o.sessions[ a ];
      if( o2.exitCode !== null || o2.exitSignal !== null )
      {
        o.exitCode = o2.exitCode;
        o.exitSignal = o2.exitSignal;
        o.exitReason = o2.exitReason;
        break;
      }
    }

    if( !o.error )
    for( let a = 0 ; a < o.sessions.length ; a++ )
    {
      let o2 = o.sessions[ a ];
      if( o2.error )
      {
        o.error = o2.error;
        if( !o.exitReason )
        o.exitReason = o2.exitReason;
        break;
      }
    }

    if( o.outputCollecting )
    if( o.sync && !o.deasync )
    for( let a = 0 ; a < o.sessions.length ; a++ )
    {
      let o2 = o.sessions[ a ];
      o.output += o2.output;
    }

    if( !o.exitReason )
    o.exitReason = o.error ? 'error' : 'normal';

    if( err && !o.concurrent )
    serialEnd();

    Object.freeze( o );
    if( err )
    throw err;
    return o;
  }

  /* */

  /*
    forward error to the the next process descriptor
  */

  function serialEnd()
  {
    o.sessions.forEach( ( o2 ) =>
    {
      if( o2.ended )
      return;
      try
      {
        o2.error = o2.error || o.error;
        if( !o2.state )
        return;
        o2._end();
        _.assert( !!o2.ended );
      }
      catch( err2 )
      {
        o.logger.error( _.err( err2 ) );
      }
    });
  }

  /* */

  function formStreams()
  {

    if( !Stream )
    Stream = require( 'stream' );

    if( o.stdio[ 1 ] !== 'ignore' )
    if( !o.sync || o.deasync )
    {
      o.streamOut = new Stream.PassThrough();
      _.assert( o.streamOut._pipes === undefined );
      o.streamOut._pipes = [];
    }

    if( o.stdio[ 2 ] !== 'ignore' )
    if( !o.sync || o.deasync )
    {
      o.streamErr = new Stream.PassThrough();
      _.assert( o.streamErr._pipes === undefined );
      o.streamErr._pipes = [];
    }

    /* piping out channel */

    if( o.outputCollecting )
    if( o.streamOut )
    o.streamOut.on( 'data', handleStreamOut );

    /* piping error channel */

    if( o.outputCollecting )
    if( o.streamErr )
    o.streamErr.on( 'data', handleStreamOut );

  }

  /* */

  function processPipe( o2 )
  {

    o2.conStart.tap( ( err, op2 ) =>
    {
      _processPipeCounter += 1;
      if( err )
      return;
      if( o2.pnd.stdout )
      streamPipe( o.streamOut, o2.pnd.stdout );
      if( o2.pnd.stderr )
      streamPipe( o.streamErr, o2.pnd.stderr );
    });

  }

  /* */

  function streamPipe( dst, src )
  {

    _.assert( !o.sync || !!o.deasync );

    if( _.longHas( dst._pipes, src ) )
    {
      return;
    }

    _.assert( !!src && !!src.pipe );
    _.arrayAppendOnceStrictly( dst._pipes, src );
    src.pipe( dst, { end : false } );

    src.on( 'end', () =>
    {
      _.arrayRemoveOnceStrictly( dst._pipes, src );
      if( dst._pipes.length === 0 )
      if( _processPipeCounter === o.sessions.length )
      {
        dst.end();
      }
    });

  }

  /* */

  function handleStreamOut( data )
  {
    if( _.bufferNodeIs( data ) )
    data = data.toString( 'utf8' );
    if( o.outputGraying )
    data = _.ct.stripAnsi( data );
    // data = StripAnsi( data );
    if( o.outputCollecting )
    o.output += data;
  }

  /* */

}

startMultiple_body.defaults =
{

  ... _.mapBut_( null, startSingle.defaults, [ 'sessionId' ] ),

  concurrent : 0,

}

let startMultiple = _.routine.uniteCloning_replaceByUnite( startMultiple_head, startMultiple_body );

//

let startPassingThrough = _.routine.uniteCloning_replaceByUnite( startMultiple_head, startMultiple_body );

var defaults = startPassingThrough.defaults;

defaults.verbosity = 0;
defaults.passingThrough = 1;
defaults.applyingExitCode = 1;
defaults.throwingExitCode = 0;
defaults.outputPiping = 1;
defaults.stdio = 'inherit';
defaults.mode = 'spawn';

//

/**
 * @summary Short-cut for {@link module:Tools/base/ProcessBasic.Tools.process.start start} routine. Executes provided script in with `node` runtime.
 * @description
 * Expects path to javascript file in `o.execPath` option. Automatically prepends `node` prefix before script path `o.execPath`.
 * @param {Object} o Options map, see {@link module:Tools/base/ProcessBasic.Tools.process.start start} for detailed info about options.
 * @param {Boolean} o.passingThrough=0 Allows to pass arguments of parent process to the child process.
 * @param {Boolean} o.maximumMemory=0 Allows `node` to use all available memory.
 * @param {Boolean} o.applyingExitCode=1 Applies exit code to parent process.
 * @param {String|Array} o.stdio='inherit' Prints all output through stdout,stderr channels of parent.
 *
 * @return {Object} Returns `wConsequence` instance in async mode. In sync mode returns options map. Options map contains not only input options, but child process descriptor, collected output, exit code and other useful info.
 *
 * @example
 *
 * const _ = require( 'wTools' )
 * _.include( 'wProcessBasic' )
 * _.include( 'wConsequence' )
 * _.include( 'wLogger' )
 *
 * let con = _.process.startNjs({ execPath : 'path/to/script.js' });
 *
 * con.then( ( op ) =>
 * {
 *  console.log( 'ExitCode:', op.exitCode );
 *  return op;
 * })
 *
 * @function startNjs
 * @module Tools/base/ProcessBasic
 * @namespace Tools.process
 */

function startNjs_body( o )
{

  if( !System )
  System = require( 'os' );

  _.routine.assertOptions( startNjs_body, o );
  _.assert( !o.code );
  _.assert( arguments.length === 1, 'Expects single argument' );

  _.assert( _.arrayIs( o.interpreterArgs ) || o.interpreterArgs === null );

  /*
  1024*1024 for megabytes
  1.4 factor found empirically for windows
      implementation of nodejs for other OSs could be able to use more memory
  */

  let logger = o.logger || _global.logger;
  let interpreterArgs = '';
  if( o.maximumMemory )
  {
    let totalmem = System.totalmem();
    if( o.verbosity >= 3 )
    logger.log( 'System.totalmem()', _.strMetricFormatBytes( totalmem ) );
    if( totalmem < 1024*1024*1024 )
    Math.floor( ( totalmem / ( 1024*1024*1.4 ) - 1 ) / 256 ) * 256;
    else
    Math.floor( ( totalmem / ( 1024*1024*1.1 ) - 1 ) / 256 ) * 256;
    interpreterArgs = '--expose-gc --stack-trace-limit=999 --max_old_space_size=' + totalmem;
    interpreterArgs = _.strSplitNonPreserving({ src : interpreterArgs });
  }

  let execPath = o.execPath || '';

  if( interpreterArgs !== '' )
  o.interpreterArgs = _.arrayAppendArray( o.interpreterArgs, interpreterArgs );

  if( o.mode === 'spawn' || o.mode === 'shell' )
  execPath = _.strConcat([ 'node', execPath ]);

  o.execPath = execPath;

  let result = _.process.startMultiple.body.call( _.process, o );

  return result;
}

var defaults = startNjs_body.defaults = Object.create( startMultiple.defaults );

defaults.passingThrough = 0;
defaults.maximumMemory = 0;
defaults.applyingExitCode = 1;
defaults.stdio = 'inherit';
defaults.mode = 'fork';

let startNjs = _.routine.uniteCloning_replaceByUnite( startMultiple_head, startNjs_body );

//

/**
 * @summary Short-cut for {@link module:Tools/base/ProcessBasic.Tools.process.startNjs startNjs} routine.
 * @description
 * Passes arguments of parent process to the child and allows `node` to use all available memory.
 * Expects path to javascript file in `o.execPath` option. Automatically prepends `node` prefix before script path `o.execPath`.
 * @param {Object} o Options map, see {@link module:Tools/base/ProcessBasic.Tools.process.start start} for detailed info about options.
 * @param {Boolean} o.passingThrough=1 Allows to pass arguments of parent process to the child process.
 * @param {Boolean} o.maximumMemory=1 Allows `node` to use all available memory.
 * @param {Boolean} o.applyingExitCode=1 Applies exit code to parent process.
 *
 * @return {Object} Returns `wConsequence` instance in async mode. In sync mode returns options map. Options map contains not only input options, but child process descriptor, collected output, exit code and other useful info.
 *
 * @example
 *
 * const _ = require( 'wTools' )
 * _.include( 'wProcessBasic' )
 * _.include( 'wConsequence' )
 * _.include( 'wLogger' )
 *
 * let con = _.process.startNjsPassingThrough({ execPath : 'path/to/script.js' });
 *
 * con.then( ( op ) =>
 * {
 *  console.log( 'ExitCode:', op.exitCode );
 *  return op;
 * })
 *
 * @function startNjsPassingThrough
 * @module Tools/base/ProcessBasic
 * @namespace Tools.process
 */

let startNjsPassingThrough = _.routine.uniteCloning_replaceByUnite( startMultiple_head, startNjs.body );

var defaults = startNjsPassingThrough.defaults;

defaults.verbosity = 0;
defaults.passingThrough = 1;
defaults.maximumMemory = 1;
defaults.applyingExitCode = 1;
defaults.throwingExitCode = 0;
defaults.mode = 'fork';

//

/**
 * @summary Generates start routine that reuses provided option on each call.
 * @description
 * Routine vectorize `o.execPath` and `o.args` options. `wConsequence` instance `o.ready` can be reused to run several starts in a row, see examples.
 * @param {Object} o Options map
 *
 * @return {Function} Returns start routine with options saved as inner state.
 *
 * @example //single command execution
 *
 * const _ = require( 'wTools' )
 * _.include( 'wProcessBasic' )
 * _.include( 'wConsequence' )
 * _.include( 'wLogger' )
 *
 * let start = _.process.starter({ execPath : 'node' });
 *
 * let con = start({ args : [ '-v' ] });
 *
 * con.then( ( op ) =>
 * {
 *  console.log( 'ExitCode:', op.exitCode );
 *  return op;
 * })
 *
 * @example //multiple commands execution with same args
 *
 * const _ = require( 'wTools' )
 * _.include( 'wProcessBasic' )
 * _.include( 'wConsequence' )
 * _.include( 'wLogger' )
 *
 * let start = _.process.starter({ args : [ '-v' ]});
 *
 * let con = start({ execPath : [ 'node', 'npm' ] });
 *
 * con.then( ( op ) =>
 * {
 *  console.log( 'ExitCode:', op.exitCode );
 *  return op;
 * })
 *
 * @example
 * //multiple commands execution with same args, using sinle consequence
 * //second command will be executed when first is finished
 *
 * const _ = require( 'wTools' )
 * _.include( 'wProcessBasic' )
 * _.include( 'wConsequence' )
 * _.include( 'wLogger' )
 *
 * let ready = new _.Consequence().take( null );
 * let start = _.process.starter({ args : [ '-v' ], ready });
 *
 * start({ execPath : 'node' });
 *
 * ready.then( ( op ) =>
 * {
 *  console.log( 'node ExitCode:', op.exitCode );
 *  return op;
 * })
 *
 * start({ execPath : 'npm' });
 *
 * ready.then( ( op ) =>
 * {
 *  console.log( 'npm ExitCode:', op.exitCode );
 *  return op;
 * })
 *
 * @function starter
 * @module Tools/base/ProcessBasic
 * @namespace Tools.process
 */

function starter( o0 )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( _.strIs( o0 ) )
  o0 = { execPath : o0 }
  o0 = _.routine.options_( starter, o0 || null );
  o0.ready = o0.ready || new _.Consequence().take( null );

  _.routineExtend( er, _.process.startMultiple );
  _.assert( er.defaults !== _.process.startMultiple.defaults );
  er.predefined = o0;

  for( let k in o0 )
  if( _.primitive.is( o0[ k ] ) )
  er.defaults[ k ] = o0[ k ];

  return er;

  /* */

  function er()
  {
    /*
      non-primitive options :

      - execPath( in multiple runs )        : array
      - currentPath( in multiple runs )     : array
      - args                                : array
      - interpreterArgs                     : array
      - stdio                               : array
      - logger                              : object
      - procedure                           : object
      - ready                               : routine
      - conStart                            : routine
      - conTerminate                        : routine
      - conDisconnect                       : routine
      - outputColoring                      : aux
      - env                                 : aux
    */
    let o = optionsFrom( arguments[ 0 ] );
    let o00 = _.props.extend( null, o0 );
    for( let k in o00 )
    {
      if( _.arrayIs( o00[ k ] ) )
      o00[ k ] = o00[ k ].slice();
      else if( _.aux.is( o00[ k ] ) )
      o00[ k ] = _.props.extend( null, o00[ k ] );
    }
    merge( o00, o );
    _.props.extend( o, o00 )

    for( let a = 1 ; a < arguments.length ; a++ )
    {
      let o1 = optionsFrom( arguments[ a ] );
      merge( o, o1 );
      _.props.extend( o, o1 );
    }

    /*
      if o.stack to starter is number add it to the delta,
      if not, overwrite with o.stack passed to instance
    */
    /* xxx : qqq : for junior : bad | aaa : fixed. */
    if( _.numberIs( o0.stack ) )
    o.stack = _.Procedure.Stack( o.stack, 1 + o0.stack );
    else
    o.stack = _.Procedure.Stack( o.stack, 1 );

    return _.process.startMultiple( o );
  }

  function optionsFrom( options )
  {
    if( _.strIs( options ) || _.arrayIs( options ) )
    options = { execPath : options }
    options = options || Object.create( null );
    _.map.assertHasOnly( options, starter.defaults );
    return options;
  }

  function merge( dst, src )
  {
    if( _.strIs( src ) || _.arrayIs( src ) )
    src = { execPath : src }
    _.map.assertHasOnly( src, starter.defaults );

    if( src.execPath !== null && src.execPath !== undefined && dst.execPath !== null && dst.execPath !== undefined )
    {
      _.assert
      (
        _.arrayIs( src.execPath ) || _.strIs( src.execPath ),
        () => `Expects string or array, but got ${_.entity.strType( src.execPath )}`
      );
      if( _.arrayIs( src.execPath ) )
      src.execPath = _.arrayFlatten( src.execPath );

      /*
      condition required, otherwise vectorization of results will be done what is not desirable
      */

      if( _.arrayIs( dst.execPath ) || _.arrayIs( src.execPath ) )
      dst.execPath = _.permutation.eachSample( [ dst.execPath, src.execPath ] ).map( ( path ) => path.join( ' ' ) );
      else
      dst.execPath = dst.execPath + ' ' + src.execPath;

      delete src.execPath;
    }

    _.props.extend( dst, src );

    return dst;
  }

}

starter.defaults = _.mapBut_( null, startMultiple.defaults, [ 'procedure' ] );

// --
// children
// --

function isAlive( src )
{
  let pid = _.process.pidFrom( src );
  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( pid ), `Expects process id as number, but got:${pid}` );

  try
  {
    return process.kill( pid, 0 );
  }
  catch( err )
  {
    return err.code === 'EPERM'
  }

}

//

function statusOf( src )
{
  _.assert( arguments.length === 1 );
  let isAlive = _.process.isAlive( src );
  return isAlive ? 'alive' : 'dead';
}

//

function signal_head( routine, args )
{
  let o = args[ 0 ];

  _.assert( args.length === 1 );

  if( _.numberIs( o ) )
  o = { pid : o };
  else if( _.process.isNativeDescriptor( o ) )
  o = { pnd : o };

  o = _.routine.options_( routine, o );

  if( o.pnd )
  {
    _.assert( o.pid === o.pnd.pid || o.pid === null );
    o.pid = o.pnd.pid;
    _.assert( _.intIs( o.pid ) );
  }

  return o;
}

//

function signal_body( o )
{
  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( o.timeOut ), 'Expects number as option {-timeOut-}' );
  _.assert( _.strIs( o.signal ), 'Expects signal to be provided explicitly as string' );
  _.assert( _.intIs( o.pid ) );

  let isWindows = process.platform === 'win32';
  let ready = _.Consequence().take( null );
  let cons = [];
  let signal = o.signal;

  ready.then( () =>
  {
    if( o.withChildren )
    return _.process.children({ pid : o.pid, format : 'list' });
    return { pid : o.pid, pnd : o.pnd };
  })

  ready.then( processKill );
  ready.then( handleResult );
  ready.catch( handleError1 );

  return end();

  /* - */

  function end()
  {
    if( o.sync )
    {
      ready.deasync();
      return ready.sync();
    }
    return ready;
  }

  /* */

  function signalSend( p )
  {
    _.assert( _.intIs( p.pid ) );

    if( !_.process.isAlive( p.pid ) )
    return true;

    let pnd = p.pnd;
    if( !pnd && o.pnd && o.pnd.pid === p.pid )
    pnd = o.pnd;

    try
    {
      process.kill( pnd ? pnd.pid : p.pid, o.signal );
    }
    catch( err )
    {
      console.error( 'signalSend.error :', err.code ); /* xxx : remove later */
      console.error( processInfoGet( p ) );
      if( o.ignoringErrorEsrch && err.code === 'ESRCH' )
      return true;
      if( o.ignoringErrorPerm && err.code === 'EPERM' )
      return true;
      throw handleError2( p, err );
    }

    let con = waitForDeath( p );
    cons.push( con );
  }

  /* */

  function processKill( processes )
  {

    _.assert( !o.withChildren || o.pid === processes[ 0 ].pid, 'Something wrong, first process must be the leader' );

    /*
      leader of the group of processes should receive the signal first
      so progression sould be positive
      it gives chance terminal to terminate child processes properly
      otherwise more fails appear in shell mode for OS spawing extra process for applications
    */

    if( o.withChildren )
    for( let i = 0 ; i < processes.length ; i++ )
    {
      let process = processes[ i ];
/*
      if( isWindows && i && process.name === 'conhost.exe' )
      continue;
*/
      if( _.process._windowsSystemLike( process ) )
      console.error( `Attemp to send signal to Windows system process.\n${processInfoGet( process )}` )

      signalSend( process );
    }
    else
    {
      signalSend( processes );
    }

    if( !cons.length )
    return true;

    return _.Consequence.AndKeep( ... cons );
  }

  /* - */

  function waitForDeath( p )
  {
    let timeOut = signal === 'SIGKILL' ? 5000 : o.timeOut;

    if( timeOut === 0 )
    return kill( p );

    let ready = _.process.waitForDeath({ pid : p.pid, timeOut })

    ready.catch( ( err ) =>
    {

      if( err.reason === 'time out' )
      {
        _.errAttend( err );
        if( signal === 'SIGKILL' )
        err = _.err( `Target process is still alive after kill. Waited for ${o.timeOut} ms.` );
        else
        return kill( p );
      }

      err = _.err( err, processInfoGet( p ) );

      throw err;
    })

    return ready;
  }

  /* - */

  function kill( p )
  {
    return _.process.kill
    ({
      pid : p.pid,
      pnd : p.pnd,
      withChildren : 0,
      // ignoringErrorPerm : 1, /* xxx : enable? */
    });
  }

  /* - */

  function handleError1( err )
  {
    console.log( 'handleError1' ); /* xxx : remove later */
    throw handleError2( o, err );
  }

  /* - */

  function handleError2( p, err )
  {
    console.log( 'handleError2' ); /* xxx : remove later */
    // if( err.code === 'EINVAL' )
    // err = _.err( err, '\nAn invalid signal was specified:', _.strQuote( o.signal ) )
    if( err.code === 'EPERM' )
    err = _.err( err, `\nCurrent process does not have permission to kill target process: ${o.pid}` );
    if( err.code === 'ESRCH' )
    err = _.err( err, `\nTarget process does not exist.` );

    if( !err.processInfo && p )
    // if( p )
    {
      let processInfo = processInfoGet( p );
      _.error.concealedSet( err, { processInfo : processInfo } )
      _.err( err, processInfo );
      // console.log( 'handleError2 :', processInfo );
    }
    // else
    // {
    //   console.log( 'handleError2 :', 'no p' );
    // }

    if( err && err.processInfo )
    console.log( 'handleError2 :', err.processInfo );

    if( !p )
    console.log( 'handleError2 : no p' );

    return _.err( err );
  }

  /* - */

  function processInfoGet( p )
  {
    let info;

    try
    {
      if( p.pnd )
      {
        info = `\nPID : ${p.pnd.pid}\nExecPath : ${p.pnd.spawnfile}\nArgs : ${p.pnd.spawnargs}`; /* qqq for junior : seems not covered */
      }
      else
      {
        let execPath = _.process.execPathOf({ pid : p.pid, sync : 1, throwing : 0 });
        info = `\nPID : ${p.pid}\nExecPath : ${execPath}`; /* qqq for junior : seems not covered */
      }
    }
    catch( err )
    {
      console.error( err );
      info = `\nFailed to get ExecPath of proces with pid::${p.pnd.pid}`
    }

    return info;
  }

  /* - */

  function handleResult( result )
  {
    result = _.array.as( result );
    for( let i = 0 ; i < result.length ; i++ )
    {
      if( result[ i ] !== true )
      return result[ i ];
    }
    return true;
  }

}

signal_body.defaults =
{
  pid : null,
  pnd : null,
  withChildren : 1,
  timeOut : 5000,
  signal : null,
  ignoringErrorPerm : 0,
  ignoringErrorEsrch : 1,
  sync : 0,
}

let _signal = _.routine.uniteCloning_replaceByUnite( signal_head, signal_body );

//

function kill_body( o )
{
  _.assert( arguments.length === 1 );
  let o2 = _.props.extend( null, o );
  o2.signal = 'SIGKILL';
  o2.timeOut = 5000;
  return _.process._signal.body( o2 );
}

kill_body.defaults =
{
  ... _.mapBut_( null, _signal.defaults, [ 'signal', 'timeOut' ] ),
}

let kill = _.routine.uniteCloning_replaceByUnite( signal_head, kill_body );


//

/*
  zzz for Vova: shell mode have different behaviour on Windows, OSX and Linux
  look for solution that allow to have same behaviour on each mode
*/

function terminate_body( o )
{
  _.assert( arguments.length === 1 );
  o.signal = o.timeOut ? 'SIGTERM' : 'SIGKILL';
  return _.process._signal.body( o );
}

terminate_body.defaults =
{
  ... _.mapBut_( null, _signal.defaults, [ 'signal' ] ),
}

let terminate = _.routine.uniteCloning_replaceByUnite( signal_head, terminate_body );

//

function waitForDeath_body( o )
{
  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( o.pid ) );
  _.assert( _.numberIs( o.timeOut ) );

  let isWindows = process.platform === 'win32';
  let interval = isWindows ? 250 : 25;

  /*
    zzz : hangs up on Windows with interval below 150 if run in sync mode. see test routine killSync
  */

  let ready = _.Consequence().take( true );

  // console.log( `waitForDeath ${o.pid} ${_.process.isAlive( o.pid )}` );

  if( !_.process.isAlive( o.pid ) )
  return end();

  if( isWindows )
  ready.then( () => _.process.spawnTimeOf({ pid : o.pid }) )

  ready.then( _waitForDeath );

  return end();

  /* */

  function end()
  {
    if( o.sync )
    {
      ready.deasync();
      return ready.sync();
    }
    return ready;
  }

  /* */

  function _waitForDeath( spawnTime )
  {
    let ready = _.Consequence();
    let timer = _.time.periodic( interval, () =>
    {
      if( _.process.isAlive( o.pid ) )
      return true;
      ready.take( true );
    });

    let timeOutError = _.time.outError( o.timeOut )

    ready.orKeeping( [ timeOutError ] ); /* zzz : implement option::cenceling for consequence? */

    ready.finally( ( err, arg ) =>
    {
      if( !err || err.reason !== 'time out' )
      timeOutError.error( _.dont );

      if( !err )
      return arg;

      timer.cancel();

      if( err.reason === 'time out' )
      {
        err = _.err( err, `\nTarget process: ${_.strQuote( o.pid )} is still alive. Waited ${o.timeOut} ms.` );
        if( isWindows )
        {
          let spawnTime2 = _.process.spawnTimeOf({ pid : o.pid })
          if( spawnTime != spawnTime2 )
          {
            _.errAttend( err );
            return null;
          }
          else
          {
            let execPath = _.process.execPathOf({ pid : o.pid, sync : 1, throwing : 0 });
            let info = `waitForDeath: Spawn time of process:${o.pid} did not change after time out.\nspawnTime:${spawnTime} spawnTime2:${spawnTime2}\nExec path:${execPath}`
            console.error( info );
          }
        }
      }

      throw err;
    })

    return ready;
  }
}

waitForDeath_body.defaults =
{
  pid : null,
  pnd : null,
  timeOut : 5000,
  sync : 0
}

let waitForDeath = _.routine.uniteCloning_replaceByUnite( signal_head, waitForDeath_body )

//

function children( o )
{
  if( _.numberIs( o ) )
  o = { pid : o };
  else if( _.process.isNativeDescriptor( o ) )
  o = { process : o }

  _.routine.options_( children, o )
  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( o.pid ) );
  _.assert( _.longHas( [ 'list', 'tree' ], o.format ) );

  if( o.pnd )
  {
    _.assert( o.pid === null );
    o.pid = o.pnd.pid;
  }

  let result;

  if( !_.process.isAlive( o.pid ) )
  {
    let err = _.err( `\nTarget process: ${_.strQuote( o.pid )} does not exist.` );
    return new _.Consequence().error( err );
  }

  if( process.platform === 'win32' )
  {
    if( !WindowsProcessTree )
    {
      try
      {
        WindowsProcessTree = require( 'w.process.tree.windows' );
      }
      catch( err )
      {
        throw _.err( err, '\nFailed to get child process list.' );
      }
    }

    let con = new _.Consequence();
    if( o.format === 'list' )
    {
      WindowsProcessTree.getProcessList( o.pid, ( result ) => con.take( result ) );
    }
    else
    {
      WindowsProcessTree.getProcessTree( o.pid, ( list ) =>
      {
        result = Object.create( null );
        handleWindowsResult( result, list );
        con.take( result );
      })
    }
    return con;
  }
  else
  {
    if( o.format === 'list' )
    result = [];
    else
    result = Object.create( null );

    if( process.platform === 'darwin' )
    return childrenOf( 'pgrep -P', o.pid, result );
    else
    return childrenOf( 'ps -o pid --no-headers --ppid', o.pid, result );
    /* zzz for Vova : use optimal solution */
  }

  /* */

  function childrenOf( command, pid, _result )
  {
    return _.process.startSingle
    ({
      execPath : command + ' ' + pid,
      outputCollecting : 1,
      outputPiping : 0,
      throwingExitCode : 0,
      inputMirroring : 0,
      stdio : 'pipe',
    })
    .then( ( op ) =>
    {
      if( o.format === 'list' )
      _result.push({ pid : _.numberFrom( pid ) });
      else
      _result[ pid ] = Object.create( null );
      if( op.exitCode !== 0 )
      return result;
      let ready = new _.Consequence().take( null );
      let pids = _.strSplitNonPreserving({ src : op.output, delimeter : '\n' });
      _.each( pids, ( cpid ) => ready.then( () => childrenOf( command, cpid, o.format === 'list' ? _result : _result[ pid ] ) ) )
      return ready;
    })
  }

  function handleWindowsResult( tree, result )
  {
    tree[ result.pid ] = Object.create( null );
    if( result.children && result.children.length )
    _.each( result.children, ( child ) => handleWindowsResult( tree[ result.pid ], child ) )
    return tree;
  }

}

children.defaults =
{
  process : null,
  pid : null,
  format : 'list',
}

//

function execPathOf( o )
{
  _.assert( arguments.length === 1 );

  if( _.numberIs( o ) )
  o = { pid : o };
  else if( _.process.isNativeDescriptor( o ) )
  o = { pnd : o };

  o = _.routine.options_( execPathOf, o );

  if( o.pnd )
  {
    _.assert( o.pid === o.pnd.pid || o.pid === null );
    o.pid = o.pnd.pid;
    _.assert( _.intIs( o.pid ) );
  }

  let ready = _.Consequence()

  if( !_.process.isAlive( o.pid ) )
  {
    if( !o.throwing )
    {
      ready.take( null );
      return end();
    }
    let err = _.err( `\nTarget process: ${_.strQuote( o.pid )} does not exist.` );
    if( o.sync )
    throw err;
    return ready.error( err );
  }

  if( process.platform === 'win32' )
  {
    if( !WindowsProcessTree )
    {
      try
      {
        WindowsProcessTree = require( 'w.process.tree.windows' );
      }
      catch( err )
      {
        err = _.err( err, '\nFailed to get process name.' );
        if( o.sync )
        throw err;
        return ready.error( err );
      }
    }

    WindowsProcessTree.getProcessList( o.pid, ( list ) =>
    {
      ready.take( list[ 0 ].commandLine );
    }, WindowsProcessTree.ProcessDataFlag.CommandLine )
  }
  else
  {
    let op =
    {
      execPath : `ps -p ${o.pid} -o command`,
      mode : 'shell',
      stdio : 'pipe',
      outputPiping : 0,
      outputCollecting : 1,
      inputMirroring : 0,
      ready
    }

    _.process.start( op );

    ready.then( ( op ) =>
    {
      let lines = _.strSplitNonPreserving({ src : op.output, delimeter : '\n' });
      return lines[ lines.length - 1 ];
    })

    ready.catch( ( err ) =>
    {
      throw _.err( `Failed to get exec path of process:${o.pid}.`, err );
    })

    ready.take( null );
  }

  return end();

  function end()
  {
    if( o.sync )
    {
      ready.deasync();
      return ready.sync();
    }
    return ready;
  }
}


execPathOf.defaults =
{
  pid : null,
  pnd : null,
  throwing : 1,
  sync : 1, /* qqq for junior : cover option::sync. don't forget all cases thorwing error and option::throwing */
}

//

function spawnTimeOf( o )
{
  _.assert( arguments.length === 1 );

  if( _.numberIs( o ) )
  o = { pid : o };
  else if( _.process.isNativeDescriptor( o ) )
  o = { pnd : o };

  o = _.routine.options_( spawnTimeOf, o );

  if( o.pnd )
  {
    _.assert( o.pid === o.pnd.pid || o.pid === null );
    o.pid = o.pnd.pid;
    _.assert( _.intIs( o.pid ) );
  }

  _.assert( process.platform === 'win32', 'Implemented only for Windows' );

  if( !WindowsProcessTree )
  {
    try
    {
      WindowsProcessTree = require( 'w.process.tree.windows' );
    }
    catch( err )
    {
      throw _.err( err, '\nFailed to get process name.' );
    }
  }

  return WindowsProcessTree.getProcessCreationTime( o.pid );
}

spawnTimeOf.defaults =
{
  pid : null,
  pnd : null
}

//

function _windowsSystemLike( pnd )
{
  if( process.platform !== 'win32' )
  return false;

  let list =
  [
    'csrss.exe',
    'wininit.exe',
    'services.exe',
    'smartscreen.exe',
    'ShellExperienceHost.exe',
    'SearchUI.exe',
    'RuntimeBroker.exe',
    'taskhostw.exe',
    'provisioner.exe',
    'conhost.exe',
    'Runner.Listener.exe',
    'Runner.Worker.exe',
    'spoolsv.exe',
    'sihost.exe',
    'WaAppAgent.exe',
    'WaSecAgentProv.exe',
    'SMSvcHost.exe',
    'IpOverUsbSvc.exe',
    'WindowsAzureGuestAgent.exe',
    'MsMpEng.exe',
    'WindowsAzureNetAgent.exe',
    'mqsvc.exe',
    'SMSvcHost.exe',
    'ctfmon.exe',
    'vds.exe',
    'msdtc.exe',
    'svchost.exe',
    'lsass.exe',
    'fontdrvhost.exe',
  ]

  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( pnd.name ) );

  return list.indexOf( pnd.name ) !== -1;
}

//

function _startTree( o )
{
  o = o || {};

  _.routine.options_( _startTree, o );

  if( o.executionTime === null )
  o.executionTime = [ 50, 100 ];

  if( o.spawnPeriod === null )
  o.spawnPeriod = [ 25, 50 ];

  let locals =
  {
    toolsPath : _.module.resolve( 'wTools'),
    ... o
  };

  /* qqq : for Vova : reuse _.program.* */
  let preformedChild = _.program.preform({ entry : child, locals });
  let preformedChildPath = _.process.tempOpen({ routineCode : preformedChild.entry.entry.routineCode });
  locals.childPath = preformedChildPath;
  let preformed = _.program.preform({ entry : program, locals });
  let preformedFilePath = _.process.tempOpen({ routineCode : preformed.entry.routineCode });

  o.list = [];

  let op = o.rootOp =
  {
    execPath : preformedFilePath,
    mode : 'fork',
    inputMirroring : 0,
    throwingExitCode : 0,
  }

  _.process.startSingle( op );

  o.ready = _.Consequence();

  op.pnd.on( 'message', ( pnd ) =>
  {
    o.list.push( pnd );

    if( o.list.length === o.max )
    o.ready.take( null );
  })

  // o.ready.then( () =>
  // {
  //   let cons = [ op.conTerminate  ];
  //   o.list.forEach( ( pnd ) =>
  //   {
  //     if( !_.process.isAlive( pnd.pid ) )
  //     return;
  //     cons.push( _.process.waitForDeath({ pid : pnd.pid }) )
  //   })
  //   return _.Consequence.AndKeep( ... cons );
  // })

  o.ready.then( () => o.rootOp.ready );
  o.ready.then( () => o );

  return o.ready;

  /* */

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wProcess' );
    _.include( 'wFilesBasic' );

    process.send({ pid : process.pid, ppid : process.ppid });

    let c = 0;

    _.time.periodic( _.numberRandom( spawnPeriod ), () =>
    {
      if( c === max )
      return;

      c += 1;

      let op =
      {
        execPath : childPath,
        mode : 'fork',
        // detaching : 1,
        inputMirroring : 0,
        throwingExitCode : 0,
      }
      _.process.startSingle( op );

      op.conStart.tap( () =>
      {
        process.send({ pid : op.pnd.pid, ppid : process.pid });
        // op.disconnect();
      })

      return true;
    })
  }

  /* */

  function child()
  {
    const _ = require( toolsPath );
    _.include( 'wProcess' );
    _.include( 'wFilesBasic' );

    let timeOut = _.numberRandom( executionTime );
    setTimeout( () =>
    {
      process.exit( 0 )
    }, timeOut );
  }

  /* */

  function calculateNumberOfProcesses()
  {
    let expectedNumberOfNodes = 1;
    let prev = 1;
    for( let i = 1; i < o.depth; i++ )
    {
      prev = prev * o.breadth;
      expectedNumberOfNodes += prev;
    }
    return expectedNumberOfNodes;
  }
}

_startTree.defaults =
{
  max : 20,
  spawnPeriod : null,
  executionTime : null,
}

// --
// declare
// --

let Extension =
{

  // start

  startMinimal,
  startSingle,
  startMultiple,
  start : startMultiple,

  startPassingThrough,
  startNjs,
  startNjsPassingThrough,
  starter,

  // children

  isAlive,
  statusOf,

  _signal,
  kill,
  terminate,
  waitForDeath,

  children,
  execPathOf,
  spawnTimeOf,

  _windowsSystemLike,
  _startTree

  // fields

}

/* _.props.extend */Object.assign( _.process, Extension );
_.assert( _.routineIs( _.process.start ) );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

( function _Process_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.process = _.process || Object.create( null );

_.assert( !!_realGlobal_ );

// --
// dichotomy
// --

let ProcessMinimalInput = _.Blueprint
({
  typed : _.trait.typed( true ),

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

  throwingExitCode : 'full', /* [ bool-like, 'full', 'brief' ] */ /* must be on by default */ /* qqq for junior : cover */
  applyingExitCode : 0,

  verbosity : 2,
  outputPrefixing : 0,
  outputPiping : null,
  outputCollecting : 0,
  outputAdditive : null, /* qqq for junior : cover the option */
  outputColoring : 1,
  outputGraying : 0,
  inputMirroring : 1,

});

let ProcessMinimal = _.Blueprint
({
  inherit : _.define.inherit( ProcessMinimalInput ),

  disconnect : null,
  _end : null,
  state : null, /* `initial`, `starting`, `started`, `terminating`, `terminated`, `disconnected` */
  exitReason : null,
  exitCode : null,
  exitSignal : null,
  error : null,
  args2 : null,
  pnd : null,
  execPath2 : null,
  output : null,
  ended : false,
  _handleProcedureTerminationBegin : false,
  streamOut : null,
  streamErr : null,

});

let ProcessMultipleInput = _.Blueprint
({
  // xxx
  // inherit : _.define.inherit( ProcessMinimalInput ),
  // but : _.define.but( 'sessionId' ),

  typed : _.trait.typed( true ),

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

  throwingExitCode : 'full', /* [ bool-like, 'full', 'brief' ] */ /* must be on by default */ /* qqq for junior : cover */
  applyingExitCode : 0,

  verbosity : 2,
  outputPrefixing : 0,
  outputPiping : null,
  outputCollecting : 0,
  outputAdditive : null, /* qqq for junior : cover the option */
  outputColoring : 1,
  outputGraying : 0,
  inputMirroring : 1,

});

let ProcessMultiple = _.Blueprint
({
  inherit : _.define.inherit( ProcessMultipleInput ),

  sessions : null,
  state : null,
  exitReason : null,
  exitCode : null,
  exitSignal : null,
  error : null,
  output : null,
  ended : null,

  streamOut : null,
  streamErr : null,

});

// --
// declare
// --

let ToolsExtension =
{

  ProcessMinimalInput,
  ProcessMinimal,

  ProcessMultipleInput,
  ProcessMultiple,

}

_.props.extend( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

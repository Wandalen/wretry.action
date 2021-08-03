const core = require( '@actions/core' );
const common = require( './Common.js' );
const _ = require( 'wTools' );
_.include( 'wConsequence' );

try
{
  const actionName = core.getInput( 'action' );
  if( !actionName )
  throw _.err( 'Please, specify Github action name' );

  const remoteActionPath = common.remotePathFromActionName( actionName );
  const localActionPath = _.path.nativize( _.path.join( __dirname, '../../../', remoteActionPath.repo ) );
  common.actionClone( localActionPath, remoteActionPath );

  const config = common.actionConfigRead( localActionPath );

  const optionsStrings = core.getMultilineInput( 'with' );
  const options = common.actionOptionsParse( optionsStrings );
  _.map.sureHasOnly( options, config.inputs );
  const envOptions = envOptionsFrom( options );
  common.envOptionsSetup( envOptions );

  /* */

  let routine;
  if( _.strBegins( config.runs.using, 'node' ) )
  {
    const runnerPath = _.path.nativize( _.path.join( __dirname, 'Runner.js' ) );
    const mainPath = _.path.nativize( _.path.join( localActionPath, config.runs.main ) );
    routine = () =>
    {
      const o =
      {
        currentPath : _.path.current(),
        execPath : `node ${ runnerPath } ${ mainPath }`,
        inputMirroring : 0,
        mode : 'spawn',
        ipc : 1,
      };
      _.process.start( o );
      o.pnd.on( 'message', ( data ) => _.map.extend( process.env, data ) );
      return o.ready;
    }
  }
  else
  {
    throw _.err( 'not implemented' );
  }


  const attemptLimit = _.number.from( core.getInput( 'attempt_limit' ) ) || 2;
  const attemptDelay = _.number.from( core.getInput( 'attempt_delay' ) ) || 0;

  const ready = _.retry
  ({
    routine,
    attemptLimit,
    attemptDelay,
    onSuccess,
  });
  ready.deasync();
  return ready.sync();
}
catch( error )
{
  _.error.attend( error );
  core.setFailed( _.error.brief( error.message ) );
}

/* */

function onSuccess( arg )
{
  if( arg.exitCode !== 0 )
  return false;
  return true
};


const core = require( '@actions/core' );
const common = require( './Common.js' );
const _ = require( 'wTools' );
_.include( 'wConsequence' );

//

function retry( scriptType )
{
  try
  {
    let routine;
    const actionName = core.getInput( 'action' );
    const command = core.getMultilineInput( 'command' );
    if( !actionName )
    {
      if( !command.length )
      throw _.error.brief( 'Please, specify Github action name or shell command.' );

      routine = () =>
      {
        const o =
        {
          currentPath : _.path.current(),
          execPath : command,
          inputMirroring : 0,
          stdio : 'inherit',
          mode : 'shell',
        };
        _.process.start( o );
        return o.ready;
      };
    }
    else
    {
      if( command.length )
      throw _.error.brief( 'Expects Github action name or command, but not both.' );
      const remoteActionPath = common.remotePathFromActionName( actionName );
      const localActionPath = _.path.nativize( _.path.join( __dirname, '../../../', remoteActionPath.repo ) );
      common.actionClone( localActionPath, remoteActionPath );

      const config = common.actionConfigRead( localActionPath );
      if( !config.runs[ scriptType ] )
      return null;

      const optionsStrings = core.getMultilineInput( 'with' );
      const options = common.actionOptionsParse( optionsStrings );
      _.map.sureHasOnly( options, config.inputs );
      const envOptions = common.envOptionsFrom( options );
      common.envOptionsSetup( envOptions );

      if( _.strBegins( config.runs.using, 'node' ) )
      {
        const runnerPath = _.path.nativize( _.path.join( __dirname, 'Runner.js' ) );
        const scriptPath = _.path.nativize( _.path.join( localActionPath, config.runs[ scriptType ] ) );
        routine = () =>
        {
          const o =
          {
            currentPath : _.path.current(),
            execPath : `node ${ runnerPath } ${ scriptPath }`,
            inputMirroring : 0,
            stdio : 'inherit',
            mode : 'spawn',
            ipc : 1,
          };
          _.process.start( o );
          o.pnd.on( 'message', ( data ) => _.map.extend( process.env, data ) );
          return o.ready;
        };
      }
      else
      {
        throw _.error.brief( 'implemented only for NodeJS interpreter' );
      }
    }

    /* */

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
}

module.exports = { retry };


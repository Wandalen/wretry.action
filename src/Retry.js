const core = require( '@actions/core' );
const common = require( './Common.js' );
require( '../node_modules/Joined.s' );
const _ = wTools;

//

function retry( scriptType )
{
  let shouldRetry = core.getInput( 'retry_condition' ) || true;

  return _.Consequence.Try( () =>
  {
    let routine, startTime;
    const con = _.take( null );
    const actionName = core.getInput( 'action' );
    const command = core.getMultilineInput( 'command' );

    const timeLimit = _.number.from( core.getInput( 'time_out' ) ) || null;
    let timeoutGet = () => null;
    if( timeLimit )
    {
      startTime = _.time.now();
      timeoutGet = () =>
      {
        let now = _.time.now();
        let spent = now - startTime;
        if( spent >= timeLimit )
        shouldRetry = false;
        return timeLimit - spent;
      };
    }

    if( !actionName )
    {
      const commands = common.commandsForm( command );
      const commandsScriptPath = _.path.join( __dirname, process.platform === 'win32' ? 'script.ps1' : 'script.sh' );
      _.fileProvider.fileWrite( commandsScriptPath, commands.join( '\n' ) );

      let currentPath = core.getInput( 'current_path' ) || _.path.current();
      if( !_.path.isAbsolute( currentPath ) )
      currentPath = _.path.join( _.path.current(), currentPath );
      const execPath =
        process.platform === 'win32' ?
        `pwsh -command ". '${ _.path.nativize( commandsScriptPath ) }'"` :
        `bash --noprofile --norc -eo pipefail ${ _.path.nativize( commandsScriptPath ) }`;

      routine = () =>
      {
        const o =
        {
          currentPath,
          execPath,
          inputMirroring : 0,
          stdio : 'inherit',
          mode : 'shell',
        };
        o.timeOut = timeoutGet();
        _.process.start( o );
        return o.ready;
      };
    }
    else
    {
      if( command.length )
      throw _.error.brief( 'Expects Github action name or command, but not both.' );

      process.env.RETRY_ACTION = actionName;
      const token = core.getInput( 'github_token' );
      const remoteActionPath = common.remotePathForm( actionName, token );
      const localActionDir = _.path.nativize( _.path.join( __dirname, '../../../', remoteActionPath.repo ) );

      con.then( () => common.actionClone( localActionDir, remoteActionPath ) );
      con.then( () =>
      {
        const actionFileDir = _.path.nativize( _.path.join( localActionDir, remoteActionPath.localVcsPath ) );
        const config = common.actionConfigRead( actionFileDir );
        if( common.shouldExit( config, scriptType ) )
        return null;

        const currentPath = process.env.GITHUB_WORKSPACE || _.path.current();

        const optionsStrings = core.getInput( 'with' );
        const options = common.actionOptionsParse( optionsStrings );

        let fullOptions = Object.create( null );
        let envOptions = Object.create( null );
        if( config.inputs && _.map.keys( config.inputs ).length > 0 )
        {
          _.map.sureHasOnly( options, config.inputs );
          fullOptions = common.optionsExtendByInputDefaults( options, config.inputs );
          envOptions = common.envOptionsFrom( fullOptions );
          common.envOptionsSetup( envOptions );
        }
        else
        {
          if( config.inputs )
          _.sure( _.map.keys( config.inputs ).length === 0, 'Expects no options' );
        }

        if( _.str.begins( config.runs.using, 'node' ) )
        {
          const node = process.argv[ 0 ];
          const runnerPath = _.path.nativize( _.path.join( __dirname, 'Runner.mjs' ) );
          const scriptPath = _.path.nativize( _.path.join( actionFileDir, config.runs[ scriptType ] ) );
          routine = () =>
          {
            const o =
            {
              currentPath,
              execPath : `${ node } ${ runnerPath } ${ scriptPath }`,
              inputMirroring : 0,
              stdio : 'inherit',
              mode : 'spawn',
              ipc : 1,
            };
            o.timeOut = timeoutGet();
            _.process.start( o );
            o.pnd.on( 'message', ( data ) => _.map.extend( process.env, data ) );
            return o.ready;
          };
        }
        else if( config.runs.using === 'docker' )
        {
          if( scriptType === 'pre' || scriptType === 'post' )
          throw _.error.brief
          (
            `The required feature "${ scriptType }-entrypoint" does not implemented.`
            + '\nPlease, open an issue with the request for the feature.'
          );
          const docker = require( './Docker.js' );
          const imageName = docker.imageBuild( actionFileDir, config.runs.image );
          const args = docker.commandArgsFrom( config.runs.args, fullOptions );
          const execPath = docker.runCommandForm( imageName, envOptions, args );

          routine = () =>
          {
            const o =
            {
              currentPath,
              execPath,
              inputMirroring : 1,
              stdio : 'inherit',
              mode : 'shell',
            };
            _.process.start( o );
            return o.ready;
          };
        }
        else
        {
          throw _.error.brief
          (
            `Runner "${ config.runs.using }" does not implemented.\nPlease, search/open a related issue.`
          );
        }
        return null;
      });
    }

    /* */

    const attemptLimit = _.number.from( core.getInput( 'attempt_limit' ) ) || 2;
    const attemptDelay = _.number.from( core.getInput( 'attempt_delay' ) ) || 0;

    return con.then( () =>
    {
      if( routine )
      return _.retry
      ({
        routine,
        attemptLimit,
        attemptDelay,
        onSuccess,
        onError,
      });
      return null;
    });
  })
  .catch( ( error ) =>
  {
    _.error.attend( error );
    core.setFailed( _.error.brief( error.message ) );
    return error;
  });

  /* */

  function onSuccess( arg )
  {
    if( arg.exitCode !== 0 )
    return false;
    return true
  }

  function onError( err )
  {
    _.error.attend( err );
    if( _.bool.is( shouldRetry ) )
    return shouldRetry;
    return !!common.evaluateExpression( shouldRetry );
  }
}

module.exports = { retry };


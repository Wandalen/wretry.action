const core = require( '@actions/core' );
const common = require( './Common.js' );
require( '../node_modules/Joined.s' );
const _ = wTools;

//

function retry( scriptType )
{
  return _.Consequence.Try( () =>
  {
    let routine;
    const con = _.take( null );
    const actionName = core.getInput( 'action' );
    const command = core.getMultilineInput( 'command' );

    if( !actionName )
    {
      const commands = common.commandsForm( command );
      const commandsScriptPath = _.path.join( __dirname, 'script' );
      _.fileProvider.fileWrite( commandsScriptPath, commands.join( '\n' ) );

      let currentPath = core.getInput( 'current_path' ) || _.path.current();
      if( !_.path.isAbsolute( currentPath ) )
      currentPath = _.path.join( _.path.current(), currentPath );

      routine = () =>
      {
        const o =
        {
          currentPath,
          execPath : `bash ${ _.path.nativize( commandsScriptPath ) }`,
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

      process.env.RETRY_ACTION = actionName;
      const remoteActionPath = common.remotePathFromActionName( actionName );
      const localActionDir = _.path.nativize( _.path.join( __dirname, '../../../', remoteActionPath.repo ) );

      con.then( () => common.actionClone( localActionDir, remoteActionPath ) );
      con.then( () =>
      {
        const actionFileDir = _.path.nativize( _.path.join( localActionDir, remoteActionPath.localVcsPath ) );
        const config = common.actionConfigRead( actionFileDir );
        if( !config.runs[ scriptType ] )
        return null;

        const optionsStrings = core.getInput( 'with' );
        const options = common.actionOptionsParse( optionsStrings );
        _.map.sureHasOnly( options, config.inputs );

        if( _.strBegins( config.runs.using, 'node' ) )
        {
          const envOptions = common.envOptionsFrom( options, config.inputs );
          common.envOptionsSetup( envOptions );

          const node = process.argv[ 0 ];
          const runnerPath = _.path.nativize( _.path.join( __dirname, 'Runner.js' ) );
          const scriptPath = _.path.nativize( _.path.join( actionFileDir, config.runs[ scriptType ] ) );
          routine = () =>
          {
            const o =
            {
              currentPath : _.path.current(),
              execPath : `${ node } ${ runnerPath } ${ scriptPath }`,
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
  };
}

module.exports = { retry };


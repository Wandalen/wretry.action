const core = require( '@actions/core' );
const { toCommandValue } = require( '@actions/core/lib/utils' );
if( typeof wTools === 'undefined' )
require( '../node_modules/Joined.s' );
const _ = wTools;
const GithubActionsParser = require( 'github-actions-parser' );

//

function commandsForm( command )
{
  _.assert( command.length > 0, 'Please, specify Github action name or shell command.' );

  if( command[ 0 ] === '|' )
  {
    _.assert( command.length > 1, 'Expected multiline command.' );
    command.shift();
  }

  _.assert( !_.str.ends( command[ command.length - 1 ], /\s\\/ ), 'Last command should have no continuation.' );

  if( process.platform === 'win32' )
  {
    command.unshift( `$ErrorActionPreference = 'stop'` );
    command.push( 'if ((Test-Path -LiteralPath variable:\LASTEXITCODE)) { exit $LASTEXITCODE }' );
  }

  return command;
}

//

function serverUrlGet()
{
  return ( process.env.GITHUB_SERVER_URL || 'https://github.com' ).replace( /\/+$/, '' );
}

//

function authTokenEncode( token )
{
  return Buffer.from( `x-access-token:${ token }` ).toString( 'base64' );
}

//

function secretsRedact( message, token )
{
  if( !token )
  return message;
  return String( message ).split( authTokenEncode( token ) ).join( '***' ).split( token ).join( '***' );
}

//

function remotePathForm( name )
{
  if( _.str.begins( name, [ './', 'docker:' ] ) )
  {
    _.assert( 0, 'unimplemented' );
  }
  else
  {
    name = name.replace( /^([^\/]+\/[^\/]+)\//, '$1.git/' );
    const parsed = _.git.path.parse( `${ serverUrlGet() }/${ _.str.replace( name, '@', '!' ) }` );
    if( !parsed.repo )
    {
      const [ user, repo ] = name.split( '@' )[ 0 ].split( '/' );
      parsed.user = user;
      parsed.repo = repo.replace( /\.git$/, '' );
    }
    return parsed;
  }
}

//

function actionClone( localPath, remotePath, token )
{
  if( !_.fileProvider.fileExists( localPath ) )
  {
    const saved = Object.create( null );
    const con = _.take( null );
    con.then( () =>
    {
      if( !token )
      return null;
      const index = Number.parseInt( process.env.GIT_CONFIG_COUNT ) || 0;
      const env =
      {
        GIT_CONFIG_COUNT : String( index + 1 ),
        [ `GIT_CONFIG_KEY_${ index }` ] : `http.${ serverUrlGet() }/.extraheader`,
        [ `GIT_CONFIG_VALUE_${ index }` ] : `AUTHORIZATION: basic ${ authTokenEncode( token ) }`,
      };
      for( let key in env )
      {
        saved[ key ] = process.env[ key ];
        process.env[ key ] = env[ key ];
      }
      return null;
    });
    con.then( () =>
    {
      return _.git.repositoryClone
      ({
        remotePath,
        localPath,
        sync : 0,
        attemptLimit : 4,
        attemptDelay : 500,
        attemptDelayMultiplier : 4,
      });
    });
    con.then( () =>
    {
      if( remotePath.tag !== 'master' )
      return _.git.tagLocalChange
      ({
        localPath,
        tag : remotePath.tag,
        sync : 0
      });
      return true;
    });
    con.finally( ( err, arg ) =>
    {
      for( let key in saved )
      if( saved[ key ] === undefined )
      delete process.env[ key ];
      else
      process.env[ key ] = saved[ key ];

      if( err )
      {
        require( 'fs' ).rmSync( _.path.nativize( localPath ), { recursive : true, force : true } );
        throw err;
      }
      return arg;
    });
    return con;
  }
  return null;
}

//

function actionConfigRead( actionDir )
{
  let configPath = _.path.join( actionDir, 'action.yml' );
  if( !_.fileProvider.fileExists( configPath ) )
  configPath = _.path.join( actionDir, 'action.yaml' )

  _.assert( _.fileProvider.fileExists( configPath ), 'Expects action path `action.yml` or `action.yaml` in the action dir: ' + actionDir );

  return _.fileProvider.fileRead
  ({
    filePath : configPath,
    encoding : 'yaml',
  });
}

//

function actionOptionsParse( src )
{
  const jsYaml = require( 'js-yaml' );
  return jsYaml.load( src ) || {};
}

//

function optionsExtendByInputDefaults( options, inputs )
{
  const result = Object.create( null );

  for( let key in options )
  result[ key ] = options[ key ];

  if( inputs )
  {
    for( let key in inputs )
    {
      if( key in options )
      {
        if( inputs[ key ].required )
        _.sure( options[ key ] !== undefined, `Please, provide value for option "${ key }"` )
      }
      else
      {
        const defaultValue = inputs[ key ].default;
        if( inputs[ key ].required )
        _.sure( defaultValue !== undefined, `Please, provide value for option "${ key }"` )

        let value = defaultValue;
        if( _.str.is( value ) )
        if( value.startsWith( '${{' ) && value.endsWith( '}}' ) )
        {
          value = evaluateExpression( value );
        }
        result[ key ] = value;
      }
    }
  }

  return result;
}

//

function envOptionsFrom( options )
{
  const result = Object.create( null );
  for( let key in options )
  result[ `INPUT_${ key.replace( / /g, '_' ).toUpperCase() }` ] = options[ key ];
  return result;
}

//

function contextInputParse( name )
{
  const input = core.getInput( `${ name }_context` );
  if( !input )
  return {};
  return JSON.parse( input );
}

//

function githubContextFromEnv()
{
  const keys =
  [
    'action', 'action_repository', 'actor', 'actor_id', 'api_url', 'base_ref', 'event_name', 'event_path',
    'graphql_url', 'head_ref', 'job', 'ref', 'ref_name', 'ref_protected', 'ref_type', 'repository',
    'repository_id', 'repository_owner', 'repository_owner_id', 'retention_days', 'run_attempt', 'run_id', 'run_number', 'server_url', 'sha',
    'triggering_actor', 'workflow', 'workflow_ref', 'workflow_sha', 'workspace'
  ];
  const context = {};
  for( let key of keys )
  {
    const value = process.env[ `GITHUB_${ key.toUpperCase() }` ];
    if( value !== undefined )
    context[ key ] = value;
  }
  context.token = core.getInput( 'github_token' ) || process.env.GITHUB_TOKEN || '';
  context.event = {};
  const eventPath = process.env.GITHUB_EVENT_PATH;
  if( eventPath && _.fileProvider.fileExists( eventPath ) )
  context.event = JSON.parse( _.fileProvider.fileRead({ filePath : eventPath }) );
  return context;
}

//

function githubOutputRead()
{
  if( !process.env.GITHUB_OUTPUT || !_.fileProvider.fileExists( process.env.GITHUB_OUTPUT ) )
  return null;
  const rawFile = _.fileProvider.fileRead({ filePath : process.env.GITHUB_OUTPUT });
  const lines = rawFile.split( '\n' ).map( ( line ) => line.endsWith( '\r' ) ? line.slice( 0, -1 ) : line );
  const result = {};
  for( let i = 0; i < lines.length; i++ )
  {
    const line = lines[ i ];
    if( line === '' )
    continue;
    const heredoc = /^([^=<]*)<<(.+)$/.exec( line );
    const eq = line.indexOf( '=' );
    if( heredoc && ( eq === -1 || heredoc[ 1 ].length < eq ) )
    {
      const value = [];
      for( i++; i < lines.length && lines[ i ] !== heredoc[ 2 ]; i++ )
      value.push( lines[ i ] );
      result[ heredoc[ 1 ] ] = value.join( '\n' );
    }
    else if( eq !== -1 )
    {
      result[ line.slice( 0, eq ) ] = line.slice( eq + 1 );
    }
  }
  return result;
}

//

function contextGet( contextName )
{
  if( contextName === 'env' )
  {
    let envContext = contextInputParse( 'env' );
    if( _.map.keys( envContext ).length === 0 )
    return process.env;
    return envContext;
  }
  else if( contextName === 'github' )
  {
    let githubContext = core.getInput( 'github_context' ) ? contextInputParse( 'github' ) : githubContextFromEnv();
    githubContext = githubContextUpdate( githubContext );
    return githubContext;
  }
  else if( contextName === 'steps' )
  {
    const context = contextInputParse( contextName );
    const parsed = githubOutputRead();
    if( parsed )
    context._this = { outputs : parsed, outcome : 'failure', conclusion : 'failure' };
    return context;
  }
  else if(  [ 'job', 'matrix', 'inputs' ].includes( contextName ) )
  {
    return contextInputParse( contextName );
  }
  else if( contextName === 'runner' )
  {
    const input = core.getInput( 'runner_context' );
    if( input )
    {
      const parsed = JSON.parse( input );
      if( Object.keys( parsed ).length > 0 )
      return parsed;
    }
    const map =
    {
      os : 'RUNNER_OS',
      arch : 'RUNNER_ARCH',
      name : 'RUNNER_NAME',
      environment : 'RUNNER_ENVIRONMENT',
      temp : 'RUNNER_TEMP',
      tool_cache : 'RUNNER_TOOL_CACHE'
    };
    const context = Object.create( null );
    for( let key in map )
    if( process.env[ map[ key ] ] !== undefined )
    context[ key ] = process.env[ map[ key ] ];
    return context;
  }

  _.sure
  (
    false,
    `The requested context "${ contextName }" does not supported by action.`
    + '\nPlease, open an issue with the request for the feature.'
  );

  /* */

  function githubContextUpdate( githubContext )
  {
    if( process.env.RETRY_ACTION )
    {
      const localName = process.env.RETRY_ACTION;
      if( localName.startsWith( './' ) || _.path.isAbsolute( localName ) )
      {
        const localDir = _.path.isAbsolute( localName ) ? localName : _.path.join( process.env.GITHUB_WORKSPACE || _.path.current(), localName );
        githubContext.action_path = _.path.nativize( localDir );
        githubContext.action_ref = '';
        return githubContext;
      }
      const remoteActionPath = remotePathForm( process.env.RETRY_ACTION );
      const localActionPath = _.path.nativize( _.path.join( __dirname, '../../../', remoteActionPath.repo ) );
      githubContext.action_path = localActionPath;
      githubContext.action_ref = remoteActionPath.tag;
    }
    return githubContext;
  }
}

//

function envOptionsSetup( options )
{
  for( let key in options )
  process.env[ key ] = toCommandValue( options[ key ] );
}

//

function shouldExit( config, scriptType )
{
  const using = config.runs.using;
  if( _.strBegins( using, 'node' ) || using === 'docker' )
  {
    if( using === 'docker' && scriptType === 'main' )
    return false;

    const localScriptType = using === 'docker' ? `${ scriptType }-entrypoint` : scriptType;
    if( !config.runs[ localScriptType ] )
    return true;

    if( config.runs[ `${ scriptType }-if` ] )
    {
      return !evaluateExpression( config.runs[ `${ scriptType }-if` ] );
    }
  }

  return false;
}

//

function evaluateExpression( expression, getter )
{
  return GithubActionsParser.evaluateExpression( expression, { get : getter || contextGet } );
}

// --
// export
// --

const Self =
{
  commandsForm,
  secretsRedact,
  authTokenEncode,
  remotePathForm,
  actionClone,
  actionConfigRead,
  actionOptionsParse,
  optionsExtendByInputDefaults,
  envOptionsFrom,
  contextInputParse,
  githubContextFromEnv,
  githubOutputRead,
  contextGet,
  envOptionsSetup,
  shouldExit,
  evaluateExpression,
};

module.exports = Self;


const core = require( '@actions/core' );
if( typeof wTools === 'undefined' )
require( '../node_modules/Joined.s' );
const _ = wTools;

let GithubActionsParser = null;

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
    command.push( 'if ((Test-Path -LiteralPath variable:\LASTEXITCODE)) { exit $LASTEXITCODE }' );
    command.unshift( `$ErrorActionPreference = 'stop'` );
  }

  return command;
}

//

function remotePathFromActionName( name )
{
  if( _.str.begins( name, [ './', 'docker:' ] ) )
  {
    _.assert( 0, 'unimplemented' );
  }
  else
  {
    name = name.replace( /^([^\/]+\/[^\/]+)\//, '$1.git/' );
    return _.git.path.parse( `https://github.com/${ _.str.replace( name, '@', '!' ) }` );
  }
}

//

function actionClone( localPath, remotePath )
{
  if( !_.fileProvider.fileExists( localPath ) )
  {
    const con = _.take( null );
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
  return jsYaml.load( src );
}

//

function envOptionsFrom( options, inputs )
{
  const result = Object.create( null );

  for( let key in options )
  result[ `INPUT_${ key.replace( / /g, '_' ).toUpperCase() }` ] = options[ key ];

  if( inputs )
  {
    for( let key in inputs )
    {
      const defaultValue = inputs[ key ].default;
      if( !( key in options ) && defaultValue !== undefined && defaultValue !== null )
      {
        let value = defaultValue;
        if( _.str.is( value ) )
        if( value.startsWith( '${{' ) && value.endsWith( '}}' ) )
        {
          if( GithubActionsParser === null )
          GithubActionsParser = require( 'github-actions-parser' );
          value = GithubActionsParser.evaluateExpression( value, { get : contextGet } );
        }
        result[ `INPUT_${key.replace(/ /g, '_').toUpperCase()}` ] = value;
      }
    }
  }

  return result;
}

//

function contextGet( contextName )
{
  if( contextName === 'env' )
  {
    let envContext = JSON.parse( core.getInput( 'env_context' ) );
    if( _.map.keys( envContext ).length === 0 )
    return process.env;
    return envContext;
  }
  else if( contextName === 'github' )
  {
    let githubContext = JSON.parse( core.getInput( 'github_context' ) );
    githubContext = githubContextUpdate( githubContext );
    return githubContext;
  }
  else if( contextName === 'job' )
  {
    const jobContext = JSON.parse( core.getInput( 'job_context' ) );
    return jobContext;
  }
  else if( contextName === 'matrix' )
  {
    const matrixContext = JSON.parse( core.getInput( 'matrix_context' ) );
    return matrixContext;
  }
  else if( contextName === 'inputs' )
  {
    const inputsContext = JSON.parse( core.getInput( 'inputs_context' ) );
    return inputsContext;
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
    console.log( process.env.RETRY_ACTION );
    const remoteActionPath = remotePathFromActionName( process.env.RETRY_ACTION );
    const localActionPath = _.path.nativize( _.path.join( __dirname, '../../../', remoteActionPath.repo ) );
    githubContext.action_path = localActionPath;
    githubContext.action_ref = remoteActionPath.tag;
    return githubContext;
  }
}

//

function envOptionsSetup( options )
{
  for( let key in options )
  core.exportVariable( key, options[ key ] );
}

// --
// export
// --

const Self =
{
  commandsForm,
  remotePathFromActionName,
  actionClone,
  actionConfigRead,
  actionOptionsParse,
  envOptionsFrom,
  contextGet,
  envOptionsSetup,
};

module.exports = Self;


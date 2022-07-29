const core = require( '@actions/core' );
if( typeof wTools === 'undefined' )
require( '../node_modules/Joined.s' );
const _ = wTools;

let GithubActionsParser = null;
// let ChildProcess = null;

//

function remotePathFromActionName( name )
{
  return _.git.path.parse( `https://github.com/${ _.strReplace( name, '@', '!' ) }` );
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

  _.sure( _.fileProvider.fileExists( configPath ), 'Expects action path `action.yml` or `action.yaml`' );

  return _.fileProvider.fileRead
  ({
    filePath : configPath,
    encoding : 'yaml',
  });
}

//

function actionOptionsParse( src )
{
  const result = Object.create( null );
  for( let i = 0 ; i < src.length ; i++ )
  {
    const splits = _.strStructureParse({ src : src[ i ], toNumberMaybe : 0 });
    _.map.extend( result, splits );
  }
  return result;
}

//

function envOptionsFrom( options, inputs )
{
  const result = Object.create( null );

  for( let key in options )
  result[ `INPUT_${key.replace(/ /g, '_').toUpperCase()}` ] = options[ key ];

  if( inputs )
  {
    for( let key in inputs )
    if( !( key in options ) && inputs[ key ].default !== undefined )
    {
      let value = inputs[ key ].default;
      if( _.str.is( value ) )
      if( value.startsWith( '${{' ) && value.endsWith( '}}' ) )
      {
        if( GithubActionsParser === null )
        GithubActionsParser = require( 'github-actions-parser' );
        value = GithubActionsParser.evaluateExpression( value, { get : getContext } );
      }
      result[ `INPUT_${key.replace(/ /g, '_').toUpperCase()}` ] = value;
    }
  }

  return result;

  /* */

  function getContext( contextName )
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

    _.assert( false, `The requested context "${ contextName }" does not supported by action.\nPlease, open an issue with the request for the feature.` );
  }

  /* */

  function githubContextUpdate( githubContext )
  {
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
  remotePathFromActionName,
  actionClone,
  actionConfigRead,
  actionOptionsParse,
  envOptionsFrom,
  envOptionsSetup,
};

module.exports = Self;


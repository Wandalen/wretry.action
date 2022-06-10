const core = require( '@actions/core' );
if( typeof wTools === 'undefined' )
require( '../node_modules/Joined.s' );
const _ = wTools;

let GithubActionsParser = null;
let ActionsGithub = null;

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

  _.assert( _.fileProvider.fileExists( configPath ), 'Expects action path `action.yml` or `action.yaml`' );

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
    if( contextName === "env" )
    {
      return process.env;
    }
    else if( contextName === "github" )
    {
      if( ActionsGithub === null )
      {
        ActionsGithub = require( '@actions/github' );

        const remoteActionPath = remotePathFromActionName( process.env.RETRY_ACTION );
        const localActionPath = _.path.nativize( _.path.join( __dirname, '../../../', remoteActionPath.repo ) );
        ActionsGithub.context.action_path = localActionPath;
        ActionsGithub.context.action_ref = remoteActionPath.tag;
        ActionsGithub.context.action_repository = process.env.GITHUB_ACTION_REPOSITORY;
        // ActionsGithub.context.action_status = undefined;
        ActionsGithub.context.api_url = ActionsGithub.context.apiUrl;
        ActionsGithub.context.base_ref = process.env.GITHUB_BASE_REF;
        ActionsGithub.context.env = process.env.GITHUB_ENV;
        ActionsGithub.context.event = ActionsGithub.context.payload;
        ActionsGithub.context.event_name = ActionsGithub.context.eventName;
        ActionsGithub.context.event_path = process.env.GITHUB_EVENT_PATH;
        ActionsGithub.context.graphql_url = ActionsGithub.context.graphqlUrl;
        ActionsGithub.context.head_ref = process.env.GITHUB_HEAD_REF;
        ActionsGithub.context.job = process.env.GITHUB_JOB;
        ActionsGithub.context.ref_name = process.env.GITHUB_REF_NAME;
        ActionsGithub.context.ref_protected = process.env.GITHUB_REF_PROTECTED;
        ActionsGithub.context.ref_type = process.env.GITHUB_REF_TYPE;
        ActionsGithub.context.path = process.env.GITHUB_PATH;
        ActionsGithub.context.repository = process.env.GITHUB_REPOSITORY;
        ActionsGithub.context.repository_owner = process.env.GITHUB_REPOSITORY_OWNER;
        ActionsGithub.context.repositoryUrl = `https://github.com/${process.env.GITHUB_REPOSITORY}.git`;
        ActionsGithub.context.retention_days = process.env.GITHUB_RETENTION_DAYS;
        ActionsGithub.context.run_id = ActionsGithub.context.runId;
        ActionsGithub.context.run_number = ActionsGithub.context.runNumber;
        ActionsGithub.context.run_attempt = process.env.GITHUB_RUN_ATTEMPT;
        ActionsGithub.context.server_url = ActionsGithub.context.serverUrl;
        ActionsGithub.context.sha = ActionsGithub.context.sha;
        ActionsGithub.context.token = core.getInput( "github_token" );
        ActionsGithub.context.workflow = ActionsGithub.context.workflow;
        ActionsGithub.context.workspace = process.env.GITHUB_WORKSPACE;
      }

      return ActionsGithub.context;
    }

    _.assert( false, `The requested context "${ contextName }" does not supported by action.` );
  }
}

//

function envOptionsSetup( options )
{
  for( let key in options )
  {
    core.exportVariable( key, options[ key ] );
    process.env[ key ] = options[ key ];
  }
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


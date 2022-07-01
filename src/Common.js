const core = require( '@actions/core' );
if( typeof wTools === 'undefined' )
require( '../node_modules/Joined.s' );
const _ = wTools;

let GithubActionsParser = null;
let ActionsGithub = null;
let ChildProcess = null;

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
    if( contextName === 'env' )
    {
      return process.env;
    }
    else if( contextName === 'github' )
    {
      if( ActionsGithub === null )
      {
        ActionsGithub = require( '@actions/github' );
        githubContextSetup( ActionsGithub );
      }
      return ActionsGithub.context;
    }
    else if( contextName === 'job' )
    {
      const jobContext = jobContextGet();
      jobContext.status = core.getInput( 'job_status' );
      return jobContext;
    }

    _.assert( false, `The requested context "${ contextName }" does not supported by action.` );
  }

  /* */

  function githubContextSetup( github )
  {
    const remoteActionPath = remotePathFromActionName( process.env.RETRY_ACTION );
    const localActionPath = _.path.nativize( _.path.join( __dirname, '../../../', remoteActionPath.repo ) );
    github.context.action_path = localActionPath;
    github.context.action_ref = remoteActionPath.tag;
    github.context.action_repository = process.env.GITHUB_ACTION_REPOSITORY;
    // github.context.action_status = undefined;
    github.context.api_url = github.context.apiUrl;
    github.context.base_ref = process.env.GITHUB_BASE_REF;
    github.context.env = process.env.GITHUB_ENV;
    github.context.event = github.context.payload;
    github.context.event_name = github.context.eventName;
    github.context.event_path = process.env.GITHUB_EVENT_PATH;
    github.context.graphql_url = github.context.graphqlUrl;
    github.context.head_ref = process.env.GITHUB_HEAD_REF;
    github.context.job = process.env.GITHUB_JOB;
    github.context.ref_name = process.env.GITHUB_REF_NAME;
    github.context.ref_protected = process.env.GITHUB_REF_PROTECTED;
    github.context.ref_type = process.env.GITHUB_REF_TYPE;
    github.context.path = process.env.GITHUB_PATH;
    github.context.repository = process.env.GITHUB_REPOSITORY;
    github.context.repository_owner = process.env.GITHUB_REPOSITORY_OWNER;
    github.context.repositoryUrl = `https://github.com/${process.env.GITHUB_REPOSITORY}.git`;
    github.context.retention_days = process.env.GITHUB_RETENTION_DAYS;
    github.context.run_id = github.context.runId;
    github.context.run_number = github.context.runNumber;
    github.context.run_attempt = process.env.GITHUB_RUN_ATTEMPT;
    github.context.server_url = github.context.serverUrl;
    github.context.sha = github.context.sha;
    github.context.token = core.getInput( 'github_token' );
    github.context.workflow = github.context.workflow;
    github.context.workspace = process.env.GITHUB_WORKSPACE;
  }

  /* */

  function jobContextGet()
  {
    const context = Object.create( null );

    if( dockerExists() )
    {
      const containersIds = execSyncNonThrowing( 'docker ps --all --filter status=running --no-trunc --format "{{.ID}}"' );
      const ids = _.strSplit({ src : containersIds.toString(), delimeter : '\n', preservingEmpty : 0 });
      context.container = Object.create( null );
      context.services = Object.create( null );
      for( let i = 0 ; i < ids.length ; i++ )
      {
        const output = execSyncNonThrowing( `docker inspect ${ ids[ i ].trim() }` );
        const parsed = JSON.parse( output.toString() );
        if( !context.container.network )
        context.container.network = parsed[ 0 ].HostConfig.NetworkMode;

        const service = Object.create( null );
        service.id = parsed[ 0 ].Id;
        service.ports = Object.create( null );
        for( let key in parsed[ 0 ].NetworkSettings.Ports )
        if( parsed[ 0 ].NetworkSettings.Ports[ key ] !== null )
        service.ports[ key.split( '/' )[ 0 ] ] = parsed[ 0 ].NetworkSettings.Ports[ key ][ 0 ].HostPort;
        service.network = context.container.network;

        context.services[ parsed[ 0 ].Args[ 0 ] ] = service;
      }
    }

    return context;
  }

  function dockerExists()
  {
    return !_.error.is( execSyncNonThrowing( 'docker -v' ) );
  }

  /*
     To get context, synchronous command execution is required.
     _.process uses Consequence in each `start*` routine and for synchronous execution it requires `deasync`.
     `deasync` is the binary module. To prevent failures during action build and decrease time of setup the action,
     we exclude `deasync` and compile.

     So, to run commands synchronously and with no async this wrapper is used.
  */

  function execSyncNonThrowing( command )
  {
    if( ChildProcess === null )
    ChildProcess = require( 'child_process' );

    try
    {
      return ChildProcess.execSync( command, { stdio : 'pipe' } );
    }
    catch( err )
    {
      _.error.attend( err );
      return err;
    }
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


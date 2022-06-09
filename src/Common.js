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
        value = GithubActionsParser.evaluateExpression( value, { get : getContextVariable } );
      }
      result[ `INPUT_${key.replace(/ /g, '_').toUpperCase()}` ] = value;
    }
  }

  return result;

  /* */

  function getContextVariable( contextName )
  {
    debugger;
    if( contextName === "env" )
    {
      return process.env;
    }
    else if( contextName === "github" )
    {
      if( ActionsGithub === null )
      ActionsGithub = require( '@actions/github' );

      ActionsGithub.context.event = ActionsGithub.context.payload;
      return ActionsGithub.context;
    }
    _.assert( false, 'Unknown context' );
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


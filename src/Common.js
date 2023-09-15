const core = require( '@actions/core' );
if( typeof wTools === 'undefined' )
require( '../node_modules/Joined.s' );
const _ = wTools;

let GithubActionsParser = null;

//

function commandsForm( command )
{
  _.assert( command.length > 0, 'Please, specify Github action name or shell command.' );

  const commands = [ command[ 0 ] ];
  let i = 1;
  if( command[ 0 ] === '|' )
  {
    _.assert( command.length > 1, 'Expected multiline command.' );
    commands[ 0 ] = command[ 1 ];
    i = 2;
  }

  for( i ; i < command.length ; i++ )
  {
    if( _.str.ends( commands[ commands.length - 1 ], /\s\\/ ) )
    commands[ commands.length - 1 ] = `${ commands[ commands.length - 1 ] }\n${ command[ i ] }`;
    else
    commands.push( command[ i ] );
  }

  _.assert( !_.str.ends( commands[ commands.length - 1 ], /\s\\/ ), 'Last command should have no continuation.' );

  return commands;
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
    const regex = /^([^\/]+\/[^\/]+)\/?(\S*)(@\S*)/;
    const actionRepo = name.replace( regex, '$1.git/$3' );
    const actionDir = name.replace( regex, '$2' );
    const parseResult = _.git.path.parse( `https://github.com/${_.str.replace( actionRepo, '@', '!' ) }` );

    const remotePath = Object.assign(parseResult, {localVcsPath: parseResult.localVcsPath + actionDir});

    console.log('remotePath: ', remotePath, 'from Action name:', name );

    return remotePath;

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
  src = src.split( '\n' );

  const result = Object.create( null );
  for( let i = 0 ; i < src.length ; i++ )
  {
    const splits = _.strStructureParse({ src : src[ i ], toNumberMaybe : 0 });
    for( let key in splits )
    if( splits[ key ] === '|' && i + 1 < src.length )
    {
      let keySpacesNumber = src[ i ].search( /\S/ );
      let spacesNumber = src[ i + 1 ].search( /\S/ );

      let prefix = [];
      if( spacesNumber == -1 )
      {
        i += 1;
        while( i < src.length )
        {
          let entryPosition = src[ i ].search( /\S/ );
          if( entryPosition === -1 )
          {
            prefix.push( '\n' );
            i += 1;
          }
          else if( entryPosition > keySpacesNumber )
          {
            spacesNumber = entryPosition;
            break;
          }
          else if ( entryPosition <= keySpacesNumber )
          {
            break;
          }
        }
        i -= 1;
      }

      if( spacesNumber > keySpacesNumber )
      {
        i += 1;
        splits[ key ] = '';
        let multilineSplits = splits;
        let multileneKey= key;
        let multilineKeyIs = true;
        while( multilineKeyIs && i < src.length )
        {
          let positionEntry = src[ i ].search( /\S/ );
          if( positionEntry >= spacesNumber )
          {
            multilineSplits[ multileneKey ] += `\n${ src[ i ].substring( spacesNumber ) }`;
            i += 1;
          }
          else if( positionEntry === -1 )
          {
            multilineSplits[ multileneKey ] += `\n${ src[ i ] }`;
            i += 1;
          }
          else
          {
            let pref = prefix.join( '' );
            multilineSplits[ multileneKey ] = multilineSplits[ multileneKey ].substring( 1 );
            multilineSplits[ multileneKey ] = `${ pref }${ multilineSplits[ multileneKey ] }`;
            _.map.extend( result, multilineSplits );
            multilineKeyIs = false;
            i -= 1;
          }
        }
        if( i === src.length && multilineKeyIs )
        {
          let pref = prefix.join( '\n' );
          multilineSplits[ multileneKey ] = multilineSplits[ multileneKey ].substring( 1 );
          multilineSplits[ multileneKey ] = `${ pref }${ multilineSplits[ multileneKey ] }`;
          _.map.extend( result, multilineSplits );
        }
      }
      else
      {
        _.map.extend( result, splits );
      }
    }
    else
    {
      _.map.extend( result, splits );
    }
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
          value = GithubActionsParser.evaluateExpression( value, { get : getContext } );
        }
        result[ `INPUT_${key.replace(/ /g, '_').toUpperCase()}` ] = value;
      }
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

    _.assert( false, `The requested context "${ contextName }" does not supported by action. Please, open an issue with the request for the feature.` );
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
  commandsForm,
  remotePathFromActionName,
  actionClone,
  actionConfigRead,
  actionOptionsParse,
  envOptionsFrom,
  envOptionsSetup,
};

module.exports = Self;


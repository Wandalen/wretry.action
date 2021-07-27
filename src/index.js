const core = require( '@actions/core' );
const _ = require( 'wTools' );
_.include( 'wGitTools' );

try
{
  const actionName = core.getInput( 'action' );
  if( !actionName )
  throw new Error( 'Please, specify Github action name' );

  const remoteActionPath = remotePathFromActionName( actionName );
  const localActionPath = _.path.join( __dirname, '../../../', remoteActionPath.repo );
  actionClone( localActionPath, remoteActionPath );

  const config = actionConfigRead( localActionPath );

  const optionsStrings = core.getMultilineInput( 'with' );
  const options = actionOptionsParse( optionsStrings );
  actionOptionsVerify( options, config.inputs );
  const envOptions = envOptionsFrom( options );
  envOptionsSetup( envOptions );

  const attemptLimit = _.number.from( core.getInput( 'attempt_limit' ) ) || 2;

  let routine;
  if( _.strBegins( config.runs.using, 'node' ) )
  {
    routine = run_functor( _.path.nativize( _.path.join( localActionPath, config.runs.main ) ) );
  }
  else
  {
    routine = () =>
    {
      _.process.start
      ({
        execPath : _.path.nativize( _.path.join( localActionPath, config.runs.main ) ),
        currentPath : process.env.GITHUB_WORKSPACE,
        mode : 'shell',
        sync : 1,
        outputCollecting : 1,
      });
    }
  }

  const ready = _.retry
  ({
    routine,
    attemptLimit,
    attemptDelay : 0,
    onSuccess,
  });
  ready.deasync();
  return ready.sync();
}
catch( error )
{
  core.setFailed( error.message );
}

/* */

function remotePathFromActionName( name )
{
  return _.git.path.parse( `https://github.com/${ _.strReplace( name, '@', '!' ) }` );
}

/* */

function actionClone( localPath, remotePath )
{
  _.git.repositoryClone
  ({
    remotePath,
    localPath,
    sync : 1,
    attemptDelayMultiplier : 4,
  });

  _.git.tagLocalChange
  ({
    localPath,
    tag : remotePath.tag,
  });
}

/* */

function actionConfigRead( actionDir )
{
  return _.fileProvider.fileRead
  ({
    filePath : _.path.join( actionDir, 'action.yml' ),
    encoding : 'yaml',
  });
}

/* */

function actionOptionsParse( src )
{
  const result = Object.create( null );
  for( let i = 0 ; i < src.length ; i++ )
  {
    const splits = src[ i ].split( ':' );
    result[ splits[ 0 ].trim() ] = splits[ 1 ].trim();
  }
  return result;
}

/* */

function actionOptionsVerify( src, screen )
{
  if( screen === undefined )
  for( let key in src )
  throw new Error( 'Expects no options' );

  for( let key in src )
  if( !( key in screen ) )
  throw new Error( `Unexpected option ${ key }` );
}

/* */

function envOptionsFrom( options )
{
  const result = Object.create( null );
  for( let key in options )
  result[ `INPUT_${key.replace(/ /g, '_').toUpperCase()}` ] = options[ key ];
  return result;
}

/* */

function envOptionsSetup( options )
{
  for( let key in options )
  {
    core.exportVariable( key, options[ key ] );
    process.env[ key ] = options[ key ];
  }
}

/* */

function run_functor( path )
{
  return function run()
  {
    delete require.cache[ path ];
    return require( path );
  }
}

/* */

function onSuccess( arg )
{
  if( process.exitCode !== 0 )
  {
    process.exitCode = 0;
    return false;
  }
  return true
};


const core = require( '@actions/core' );
if( typeof wTools === 'undefined' )
require( '../node_modules/Joined.s' );
const _ = wTools;

const ChildProcess = require( 'child_process' );

//

/*
   To run commands synchronously and with no `deasync` this wrapper is used because
   _.process uses Consequence in each `start*` routine and for synchronous execution it requires `deasync`.
   `deasync` is the binary module. To prevent failures during action build and decrease time of setup the action,
   we exclude `deasync` and compile action code.
*/

function execSyncNonThrowing( command )
{
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

//

function exists()
{
  return !_.error.is( execSyncNonThrowing( 'docker -v' ) );
}

//

function imageBuild( actionPath, image )
{
  const docker = this;

  _.assert
  (
    docker.exists(),
    'Current OS has no Docker utility.\n'
    + 'Please, visit https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#preinstalled-software\n'
    + 'and select valid workflow runner.'
  );

  if( image === 'Dockerfile' )
  {
    const actionName = _.path.name( actionPath );
    const imageName = `${ actionName }_repo:${ actionName }_tag`.toLowerCase();
    const dockerfilePath = _.path.join( actionPath, 'Dockerfile' );
    const command = `docker build -t ${ imageName } -f ${ dockerfilePath } ${ actionPath }`;
    const build = execSyncNonThrowing( command );
    if( _.error.is( build ) )
    throw _.error.brief( build );

    core.info( `Dockerfile for action : ${ dockerfilePath }.` );
    core.info( command );
    core.info( build.toString() );

    return imageName;
  }

  _.assert( false, `The action does not support requested Docker image type "${ image }". Please, open an issue with the request for the feature.` );
}

// --
// export
// --

const Self =
{
  exists,
  imageBuild,
};

module.exports = Self;

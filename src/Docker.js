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

// --
// export
// --

const Self =
{
  exists,
};

module.exports = Self;

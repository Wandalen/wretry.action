
const ChildProcess = require( 'child_process' );
ChildProcess.execSync( 'npm i --production', { stdio : 'inherit', cwd : __dirname } );

const core = require( '@actions/core' );
if( !core.getInput( 'action' ) )
return;

const { retry } = require( './Retry.js' );
retry( 'pre' );


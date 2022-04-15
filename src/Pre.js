const core = require( '@actions/core' );
if( !core.getInput( 'action' ) )
return;

const { retry } = require( './Retry.js' );
retry( 'pre' );


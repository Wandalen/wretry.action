const core = require( '@actions/core' );
if( !core.getInput( 'action' ) )
return;

if( core.getInput( 'disable_pre_and_post' ) == 'true' )
return;

const { retry } = require( './Retry.js' );
retry( 'pre' );


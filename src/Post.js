const core = require( '@actions/core' );
const actionName = core.getInput( 'action' );

if( core.getInput( 'disable_pre_and_post' ) == 'true' )
return;

if( actionName )
{
  const { retry } = require( './Retry.js' );
  retry( 'post' );
}

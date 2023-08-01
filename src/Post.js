const core = require( '@actions/core' );
const actionName = core.getInput( 'action' );
const disablePreAndPost = core.getInput('disablePreAndPost');

if( actionName && !disablePreAndPost )
{
  const { retry } = require( './Retry.js' );
  retry( 'post' );
}

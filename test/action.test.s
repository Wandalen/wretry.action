( function _action_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;
const core = require( '@actions/core' );

// --
// test
// --

function trivial( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/dmvict/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );

  const testAction = 'dmvict/test.action@v0.0.2';

  /* */

  begin().then( () =>
  {
    test.case = 'not enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '3' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    debugger;
    return null;
  });
  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ actionPath }` );
    return a.ready;
  }
}

trivial.timeOut = 60000;

// --
// declare
// --

const Proto =
{
  name : 'action',
  silencing : 1,

  tests :
  {
    trivial
  },
};

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


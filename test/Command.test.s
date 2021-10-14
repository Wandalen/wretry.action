( function _Command_test_s_()
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

function retryWithoutCommand( test )
{
  let context = this;
  const a = test.assetFor( false );
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Main.js' ) ) }`;

  /* - */

  a.ready.then( () =>
  {
    test.case = 'without action name';
    core.exportVariable( `INPUT_WITH`, 'value : 4' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  actionSetup();

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 1 );
    test.identical( _.strCount( op.output, '::error::Please, specify Github action name' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function actionSetup()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.filesReflect({ reflectMap : { [ context.actionDirPath ] : actionPath } });
      return null;
    });
    a.shellNonThrowing( `node ${ a.path.nativize( a.abs( actionPath, 'src/Pre.js' ) ) }` );
    return a.ready;
  }
}

// --
// declare
// --

const Proto =
{
  name : 'Command',
  silencing : 1,
  routineTimeOut : 60000,

  context :
  {
    actionDirPath : __.path.join( __dirname, '..' ),
  },

  tests :
  {
    retryWithoutCommand,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


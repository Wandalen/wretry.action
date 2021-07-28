( function _Action_test_s_()
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

function retryFetchActionWithoutTagOrHash( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );

  const testAction = 'dmvict/test.action';
  actionSetup();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/Index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
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
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ actionPath }` );
    return a.ready;
  }
}

//

function retryFetchActionWithTag( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );

  const testAction = 'dmvict/test.action@v0.0.2';
  actionSetup();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/Index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
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
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ actionPath }` );
    return a.ready;
  }
}

//

function retryFetchActionWithHash( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );

  /* - */

  var testAction = 'dmvict/test.action@e7a23fbc543bef807cb8a62825de2195ac6fe646';
  actionSetup().then( () =>
  {
    test.case = 'full hash, enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/Index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
    return null;
  });

  /* */

  var testAction = 'dmvict/test.action@e7a23fb';
  actionSetup().then( () =>
  {
    test.case = 'partial hash, enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/Index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
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
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ actionPath }` );
    return a.ready;
  }
}

//

function retryWithOptionAttemptLimit( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );

  const testAction = 'dmvict/test.action@v0.0.2';
  actionSetup();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'default number of attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/Index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::set-env' ), 2 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 2 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 2 attempts/ ), 1 );
    test.identical( _.strCount( op.output, 'Success' ), 0 );
    return null;
  });

  /* */
  a.ready.then( () =>
  {
    test.case = 'not enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '3' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/Index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 1 );
    test.identical( _.strCount( op.output, 'Success' ), 0 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/Index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
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
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ actionPath }` );
    return a.ready;
  }
}

retryWithOptionAttemptLimit.timeOut = 60000;

//

function retryWithOptionAttemptDelay( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const testAction = 'dmvict/test.action@v0.0.2';
  actionSetup();

  /* - */

  var start;
  a.ready.then( () =>
  {
    test.case = 'enought attempts, default value of attempt_delay';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    start = _.time.now();
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/Index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    var spent = _.time.now() - start;
    test.le( spent, 3500 );
    test.identical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'enought attempts, not default value of attempt_delay';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    core.exportVariable( `INPUT_ATTEMPT_DELAY`, '2000' );
    start = _.time.now();
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath : `node ${ a.abs( actionPath, 'src/Index.js' ) }` });
  a.ready.then( ( op ) =>
  {
    var spent = _.time.now() - start;
    test.ge( spent, 6000 );
    test.identical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
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
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ actionPath }` );
    return a.ready;
  }
}

// --
// declare
// --

const Proto =
{
  name : 'Action',
  silencing : 1,
  routineTimeOut : 30000,

  tests :
  {
    retryFetchActionWithoutTagOrHash,
    retryFetchActionWithTag,
    retryFetchActionWithHash,

    retryWithOptionAttemptLimit,
    retryWithOptionAttemptDelay,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


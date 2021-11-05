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

//

function onSuiteBegin()
{
  let context = this;
  context.actionDirPath = __.path.join( __dirname, '..' );
}

//

function onRoutineBegin()
{
  delete process.env.INPUT_ACTION;
  delete process.env.INPUT_COMMAND;
  delete process.env.INPUT_ATTEMPT_LIMIT;
  delete process.env.INPUT_WITH;
  delete process.env.INPUT_ATTEMPT_DELAY;
}

//

function onRoutineEnd()
{
  onSuiteBegin.call( this );
}

// --
// test
// --

function retryWithoutCommand( test )
{
  const context = this;
  const a = test.assetFor( false );
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Main.js' ) ) }`;

  /* - */

  a.ready.then( () =>
  {
    test.case = 'without command and action name';
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  actionSetup();

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
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

//

function retryWithWrongComand( test )
{
  let context = this;
  const a = test.assetFor( false );
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Main.js' ) ) }`;

  /* - */

  a.ready.then( () =>
  {
    test.case = 'without action name';
    core.exportVariable( `INPUT_COMMAND`, 'wrong command' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  actionSetup();

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '::error::Please, specify Github action name' ), 0 );
    test.identical( _.strCount( op.output, '::error::Process returned exit code' ), 1 );
    test.identical( _.strCount( op.output, 'Launched as "wrong command"' ), 1 );
    test.identical( _.strCount( op.output, 'Attempts exhausted, made 4 attempts' ), 1 );
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

//

function retryWithValidComand( test )
{
  let context = this;
  const a = test.assetFor( false );
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Main.js' ) ) }`;

  /* - */

  a.ready.then( () =>
  {
    test.case = 'without action name';
    core.exportVariable( `INPUT_COMMAND`, 'echo str' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  actionSetup();

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '::error::Please, specify Github action name' ), 0 );
    test.identical( _.strCount( op.output, 'Attempts exhausted, made 4 attempts' ), 0 );
    test.identical( _.strCount( op.output, 'str' ), 1 );
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
  routineTimeOut : 120000,

  onSuiteBegin,
  onRoutineBegin,
  onRoutineEnd,

  context :
  {
    actionDirPath : null,
  },

  tests :
  {
    retryWithoutCommand,
    retryWithWrongComand,
    retryWithValidComand,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


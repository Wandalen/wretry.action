( function _Env_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const fs = require( 'fs' );
const os = require( 'os' );
const path = require( 'path' );
const childProcess = require( 'child_process' );
const common = require( '../src/Common.js' );
const mainPath = path.join( __dirname, '../src/Main.js' );

//

function onRoutineBegin()
{
  for( let key of Object.keys( process.env ) )
  if( key.startsWith( 'INPUT_' ) )
  delete process.env[ key ];
  delete process.env.GITHUB_OUTPUT;
  delete process.env.GITHUB_ENV;
}

//

function tempDirMake()
{
  const dir = fs.mkdtempSync( path.join( os.tmpdir(), 'wretry-env-' ) );
  fs.writeFileSync( path.join( dir, 'env.txt' ), '' );
  fs.writeFileSync( path.join( dir, 'out.txt' ), '' );
  return dir;
}

//

function wrapperRun( dir, inputs )
{
  const env = Object.assign( {}, process.env );
  for( let key of Object.keys( env ) )
  if( key.startsWith( 'INPUT_' ) )
  delete env[ key ];
  Object.assign( env,
  {
    GITHUB_ENV : path.join( dir, 'env.txt' ),
    GITHUB_OUTPUT : path.join( dir, 'out.txt' ),
    GITHUB_WORKSPACE : dir,
    INPUT_ATTEMPT_LIMIT : '1',
  });
  /* emulates the runner: GITHUB_ENV of previous steps is applied to the next step */
  const lines = fs.readFileSync( path.join( dir, 'env.txt' ), 'utf8' ).split( '\n' );
  for( let i = 0 ; i < lines.length ; i++ )
  {
    const match = lines[ i ].match( /^(\w+)<<(.+)$/ );
    if( !match )
    continue;
    const value = [];
    for( i++ ; i < lines.length && lines[ i ] !== match[ 2 ] ; i++ )
    value.push( lines[ i ] );
    env[ match[ 1 ] ] = value.join( '\n' );
  }
  for( let key in inputs )
  env[ `INPUT_${ key.toUpperCase() }` ] = inputs[ key ];
  return childProcess.spawnSync( process.execPath, [ mainPath ], { cwd : dir, env, encoding : 'utf8' } );
}

//

function localActionMake( dir )
{
  const actionDir = path.join( dir, 'act' );
  fs.mkdirSync( actionDir );
  fs.writeFileSync( path.join( actionDir, 'action.yml' ),
    'name: t\ninputs:\n  command:\n    default: wrapped-default\n  plain:\n    default: p\nruns:\n  using: node24\n  main: main.js\n' );
  fs.writeFileSync( path.join( actionDir, 'main.js' ),
    'console.log( `SEEN command=${ process.env.INPUT_COMMAND } plain=${ process.env.INPUT_PLAIN }` );\n' );
}

// --
// test
// --

function envOptionsSetupNoFileCommand( test )
{
  const dir = tempDirMake();
  process.env.GITHUB_ENV = path.join( dir, 'env.txt' );

  test.case = 'values reach process.env, GITHUB_ENV file stays empty';
  common.envOptionsSetup({ INPUT_COMMAND : 'echo a', INPUT_PLAIN : 'abc\ndef' });
  test.identical( process.env.INPUT_COMMAND, 'echo a' );
  test.identical( process.env.INPUT_PLAIN, 'abc\ndef' );
  test.identical( fs.readFileSync( process.env.GITHUB_ENV, 'utf8' ), '' );

  test.case = 'non-string value is converted';
  common.envOptionsSetup({ INPUT_NUM : 5, INPUT_BOOL : true, INPUT_NIL : undefined });
  test.identical( process.env.INPUT_NUM, '5' );
  test.identical( process.env.INPUT_BOOL, 'true' );
  test.identical( process.env.INPUT_NIL, '' );
}

//

function actionModeDoesNotLeakInputs( test )
{
  const dir = tempDirMake();
  localActionMake( dir );

  test.case = 'wrapped action receives its inputs, GITHUB_ENV stays empty';
  var got = wrapperRun( dir, { action : './act' } );
  test.identical( got.status, 0 );
  test.identical( got.stdout.includes( 'SEEN command=wrapped-default plain=p' ), true );
  test.identical( fs.readFileSync( path.join( dir, 'env.txt' ), 'utf8' ), '' );

  test.case = 'second wrapper step with only action is not poisoned by the first one';
  var got = wrapperRun( dir, { action : './act' } );
  test.identical( got.status, 0 );
  test.identical( got.stdout.includes( 'not both' ), false );
  test.identical( got.stdout.includes( 'SEEN command=wrapped-default plain=p' ), true );
}

//

function actionModeKeepsWithOptions( test )
{
  const dir = tempDirMake();
  localActionMake( dir );

  test.case = 'option from with overrides the default in the wrapped action only';
  var got = wrapperRun( dir, { action : './act', with : 'plain: custom' } );
  test.identical( got.status, 0 );
  test.identical( got.stdout.includes( 'SEEN command=wrapped-default plain=custom' ), true );
  test.identical( fs.readFileSync( path.join( dir, 'env.txt' ), 'utf8' ), '' );
}

//

function commandModeDoesNotWriteEnvFile( test )
{
  const dir = tempDirMake();

  test.case = 'command mode leaves GITHUB_ENV empty';
  var got = wrapperRun( dir, { command : 'node -e "console.log(1)"' } );
  test.identical( got.status, 0 );
  test.identical( fs.readFileSync( path.join( dir, 'env.txt' ), 'utf8' ), '' );
}

// --
// declare
// --

const Proto =
{
  name : 'Env',
  silencing : 1,
  onRoutineBegin,

  routineTimeOut : 60000,

  tests :
  {
    envOptionsSetupNoFileCommand,
    actionModeDoesNotLeakInputs,
    actionModeKeepsWithOptions,
    commandModeDoesNotWriteEnvFile,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

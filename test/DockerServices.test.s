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
const common = require( '../src/Common.js' );

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

function envOptionsFromJobContextExpressionInputs( test )
{
  if( !_.process.insideTestContainer() || process.platform === 'macos' )
  return test.true( true );

  if( process.env.GITHUB_WORKFLOW !== 'github_services' )
  return test.true( true );

  /* - */

  test.case = 'resolve job status, field always exists';
  var inputs =
  {
    job_status :
    {
      description : 'status',
      default : '${{ job.status }}'
    }
  };
  var src = {};
  var got = common.envOptionsFrom( src, inputs );
  test.identical( got, { INPUT_JOB_STATUS : '' } );

  test.case = 'resolve job container network';
  var inputs =
  {
    job_network :
    {
      description : 'network',
      default : '${{ job.container.network }}'
    }
  };
  var src = {};
  var got = common.envOptionsFrom( src, inputs );
  test.identical( _.map.keys( got ), [ 'INPUT_JOB_NETWORK' ] );
  test.true( _.str.is( got.INPUT_JOB_NETWORK ) && got.INPUT_JOB_NETWORK.length > 0 );

  test.case = 'resolve job container network';
  var inputs =
  {
    job_network :
    {
      description : 'network',
      default : '${{ job.container.network }}'
    },
    service_network :
    {
      description : 'network',
      default : '${{ job.services.postgres.network }}'
    }
  };
  var src = {};
  var got = common.envOptionsFrom( src, inputs );
  test.identical( _.map.keys( got ), [ 'INPUT_JOB_NETWORK', 'INPUT_SERVICE_NETWORK' ] );
  test.true( _.str.is( got.INPUT_JOB_NETWORK ) && got.INPUT_JOB_NETWORK.length > 0 );
  test.identical( got.INPUT_JOB_NETWORK, got.INPUT_SERVICE_NETWORK );
}

// --
// declare
// --

const Proto =
{
  name : 'DockerServices',
  silencing : 1,
  routineTimeOut : 60000,

  onSuiteBegin,
  onRoutineBegin,
  onRoutineEnd,

  context :
  {
    actionDirPath : null,
  },

  tests :
  {
    envOptionsFromJobContextExpressionInputs,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


( function _Docker_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;
const docker = require( '../src/Docker.js' );

// --
// test
// --

function exists( test )
{
  if( !_.process.insideTestContainer() )
  return test.true( true );

  test.case = "docker exists on ubuntu-latest and windows-latest";
  var got = docker.exists();
  if( _.str.begins( process.env.ImageOS, 'ubuntu' ) || _.str.begins( process.env.ImageOS, 'win' ) )
  test.identical( got, true );
  else
  test.identical( got, false );
}

// --
// declare
// --

const Proto =
{
  name : 'Docker',
  silencing : 1,

  tests :
  {
    exists,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


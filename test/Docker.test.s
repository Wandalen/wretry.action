( function _Docker_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  _.include( 'wTesting' );
  _.include( 'wPathBasic' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;
const docker = require( '../src/Docker.js' );

// --
// context
// --

function onSuiteBegin()
{
  let context = this;
  context.assetsOriginalPath = __.path.join( __dirname, '_asset' );
  context.suiteTempPath = __.path.tempOpen( __.path.join( __dirname, '../..' ), 'Docker' );
}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.str.has( context.suiteTempPath, '/Docker-' ) )
  __.path.tempClose( context.suiteTempPath );
}

// --
// test
// --

function exists( test )
{
  if( !_.process.insideTestContainer() )
  return test.true( true );

  const ubuntuIs = _.str.begins( process.env.ImageOS, 'ubuntu' );
  const windowsLatestIs = process.env.ImageOS === 'win22';

  /* - */

  test.case = "docker exists on ubuntu-latest and windows-latest";
  var got = docker.exists();
  if( ubuntuIs || windowsLatestIs )
  test.identical( got, true );
  else
  test.identical( got, false );
}

//

function imageBuild( test )
{
  if( !_.process.insideTestContainer() )
  return test.true( true );

  const a = test.assetFor( 'image' );
  a.reflect();

  const ubuntuIs = _.str.begins( process.env.ImageOS, 'ubuntu' );
  const windowsLatestIs = process.env.ImageOS === 'win22';

  if( !ubuntuIs && !windowsLatestIs )
  return test.shouldThrowErrorSync( () => docker.imageBuild( a.routinePath, 'Dockerfile' ) );

  /* - */

  test.case = "build an image";
  var got = docker.imageBuild( a.routinePath, 'Dockerfile' );
  test.identical( got, 'imagebuild_repo:imagebuild_tag' );

  /* - */

  if( !Config.debug )
  return;

  var onResolve = ( err, arg ) =>
  {
    test.identical( arg, undefined );
    test.true( _.error.is( err ) );
    var msg = 'The action does not support requested Docker image type "wrong:image". Please, open an issue with the request for the feature.';
    test.identical( err.originalMessage, msg );
  };
  test.shouldThrowErrorSync( () => docker.imageBuild( a.routinePath, 'wrong:image' ), onResolve );
}

// --
// declare
// --

const Proto =
{
  name : 'Docker',
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    assetsOriginalPath : null,
    suiteTempPath : null,
  },

  tests :
  {
    exists,
    imageBuild,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


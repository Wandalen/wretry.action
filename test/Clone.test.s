( function _Clone_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  _.include( 'wTesting' );
  _.include( 'wGitTools' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;
const common = require( '../src/Common.js' );

// --
// test
// --

function remotePathFormTokenFree( test )
{
  const serverUrl = process.env.GITHUB_SERVER_URL;
  delete process.env.GITHUB_SERVER_URL;

  test.case = 'token is not embedded in the path';
  var got = common.remotePathForm( 'action/name/subdir@9b5d00b', 'SECRETTOKEN123' );
  var exp =
  {
    protocol : 'https',
    longPath : 'github.com/action/name.git/',
    tag : '9b5d00b',
    localVcsPath : 'subdir',
    protocols : [ 'https' ],
    isFixated : false,
    service : 'github.com',
    user : 'action',
    repo : 'name'
  };
  test.identical( got, exp );
  test.identical( JSON.stringify( got ).indexOf( 'SECRETTOKEN123' ), -1 );

  test.case = 'default server is github.com';
  var got = common.remotePathForm( 'action/name@v1' );
  test.identical( got.service, 'github.com' );
  test.identical( got.tag, 'v1' );

  /* - */

  test.open( 'custom server' );

  process.env.GITHUB_SERVER_URL = 'https://ghe.example.com/';

  test.case = 'host follows GITHUB_SERVER_URL, trailing slash is ignored';
  var got = common.remotePathForm( 'action/name/subdir@v1', 'SECRETTOKEN123' );
  var exp =
  {
    protocol : 'https',
    longPath : 'ghe.example.com/action/name.git/',
    tag : 'v1',
    localVcsPath : 'subdir',
    protocols : [ 'https' ],
    isFixated : false,
    service : 'example.com',
    user : 'action',
    repo : 'name'
  };
  test.identical( got, exp );
  test.identical( JSON.stringify( got ).indexOf( 'SECRETTOKEN123' ), -1 );

  test.close( 'custom server' );

  /* - */

  if( serverUrl === undefined )
  delete process.env.GITHUB_SERVER_URL;
  else
  process.env.GITHUB_SERVER_URL = serverUrl;
}

//

function authTokenEncode( test )
{
  test.case = 'encodes basic credentials of the token';
  var got = common.authTokenEncode( 'SECRETTOKEN123' );
  test.identical( Buffer.from( got, 'base64' ).toString(), 'x-access-token:SECRETTOKEN123' );
}

//

function secretsRedact( test )
{
  const token = 'SECRETTOKEN123';
  const encoded = common.authTokenEncode( token );

  test.case = 'no token';
  var got = common.secretsRedact( 'message', '' );
  test.identical( got, 'message' );

  test.case = 'message without secrets';
  var got = common.secretsRedact( 'message', token );
  test.identical( got, 'message' );

  test.case = 'token and encoded token, several occurrences';
  var got = common.secretsRedact( `a ${ token } b ${ encoded } c ${ token }`, token );
  test.identical( got, 'a *** b *** c ***' );
}

//

function actionCloneFailure( test )
{
  const a = test.assetFor( false );
  const localPath = a.abs( 'clone' );
  const token = 'SECRETTOKEN123';
  const serverUrl = process.env.GITHUB_SERVER_URL;
  const countBefore = process.env.GIT_CONFIG_COUNT;

  /* - */

  a.ready.then( () =>
  {
    test.case = 'failed clone removes the target directory, restores environment and does not leak the token';
    process.env.GITHUB_SERVER_URL = 'http://127.0.0.1:1';
    var remotePath = common.remotePathForm( 'action/name@v1' );
    var con = common.actionClone( localPath, remotePath, token );
    return con.finally( ( err, arg ) =>
    {
      test.true( _.error.is( err ) );
      _.error.attend( err );
      test.identical( err.message.indexOf( token ), -1 );
      test.identical( err.message.indexOf( common.authTokenEncode( token ) ), -1 );
      return null;
    });
  });
  a.ready.then( () =>
  {
    test.false( a.fileProvider.fileExists( localPath ) );
    test.identical( process.env.GIT_CONFIG_COUNT, countBefore );
    test.identical( process.env.GIT_CONFIG_KEY_0, undefined );
    test.identical( process.env.GIT_CONFIG_VALUE_0, undefined );
    if( serverUrl === undefined )
    delete process.env.GITHUB_SERVER_URL;
    else
    process.env.GITHUB_SERVER_URL = serverUrl;
    return null;
  });

  /* - */

  return a.ready;
}

actionCloneFailure.timeOut = 60000;

// --
// declare
// --

const Proto =
{
  name : 'Clone',
  silencing : 1,

  tests :
  {
    remotePathFormTokenFree,
    authTokenEncode,
    secretsRedact,
    actionCloneFailure,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

( function _Common_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;
const common = require( '../src/Common.js' );

// --
// test
// --

function remotePathFromActionName( test )
{
  test.case = 'without hash or tag';
  var got = common.remotePathFromActionName( 'action/name' );
  var exp =
  {
    protocol : 'https',
    longPath : 'github.com/action/name',
    tag : 'master',
    localVcsPath : './',
    protocols : [ 'https' ],
    isFixated : false,
    service : 'github.com',
    user : 'action',
    repo : 'name'
  };
  test.identical( got, exp );

  test.case = 'with tag';
  var got = common.remotePathFromActionName( 'action/name@v0.0.0' );
  var exp =
  {
    protocol : 'https',
    longPath : 'github.com/action/name',
    tag : 'v0.0.0',
    localVcsPath : './',
    protocols : [ 'https' ],
    isFixated : false,
    service : 'github.com',
    user : 'action',
    repo : 'name'
  };
  test.identical( got, exp );

  test.case = 'with short hash';
  var got = common.remotePathFromActionName( 'action/name@9b5d00b' );
  var exp =
  {
    protocol : 'https',
    longPath : 'github.com/action/name',
    tag : '9b5d00b',
    localVcsPath : './',
    protocols : [ 'https' ],
    isFixated : false,
    service : 'github.com',
    user : 'action',
    repo : 'name'
  };
  test.identical( got, exp );

  test.case = 'with long hash';
  var got = common.remotePathFromActionName( 'action/name@9b5d00b7245dae0586efca5052f41ae023cb7659' );
  var exp =
  {
    protocol : 'https',
    longPath : 'github.com/action/name',
    tag : '9b5d00b7245dae0586efca5052f41ae023cb7659',
    localVcsPath : './',
    protocols : [ 'https' ],
    isFixated : false,
    service : 'github.com',
    user : 'action',
    repo : 'name'
  };
  test.identical( got, exp );
}

//

function actionClone( test )
{
  const a = test.assetFor( false );
  const localPath = a.abs( '.' );

  /* */

  test.case = 'action without hash or tag';
  var remotePath = common.remotePathFromActionName( 'dmvict/test.action' );
  var got = common.actionClone( localPath, remotePath );
  test.identical( got, undefined );
  test.identical( __.git.tagLocalRetrive({ localPath }), 'master' );
  a.fileProvider.filesDelete( localPath );

  test.case = 'action with tag';
  var remotePath = common.remotePathFromActionName( 'dmvict/test.action@v0.0.2' );
  var got = common.actionClone( localPath, remotePath );
  test.identical( got, undefined );
  test.identical( __.git.tagLocalRetrive({ localPath }), 'v0.0.2' );
  a.fileProvider.filesDelete( localPath );

  test.case = 'action with short hash';
  var remotePath = common.remotePathFromActionName( 'dmvict/test.action@3d21630' );
  var got = common.actionClone( localPath, remotePath );
  test.identical( got, undefined );
  test.identical( __.git.tagLocalRetrive({ localPath }), 'v0.0.1' );
  a.fileProvider.filesDelete( localPath );

  test.case = 'action with long hash';
  var remotePath = common.remotePathFromActionName( 'dmvict/test.action@3d2163092fd3c83e02895189bf8fb845c5dc9e3f' );
  var got = common.actionClone( localPath, remotePath );
  test.identical( got, undefined );
  test.identical( __.git.tagLocalRetrive({ localPath }), 'v0.0.1' );
  a.fileProvider.filesDelete( localPath );
}

actionClone.timeOut = 30000;

//

function actionConfigRead( test )
{
  const a = test.assetFor( false );
  const actionPath = a.abs( '.' );

  /* */

  test.case = 'read directory with action file';
  common.actionClone( actionPath, common.remotePathFromActionName( 'dmvict/test.action@v0.0.2' ) );
  var got = common.actionConfigRead( actionPath );
  var exp =
  {
    name : 'test.action',
    author : 'dmvict <dm.vict.kr@gmail.com>',
    description : 'An action for testing purpose, no real usage expected.',
    inputs :
    {
      value : { 'description' : 'A test value', 'required' : true, 'default' : 0 }
    },
    runs : { 'using' : 'node12', 'main' : 'src/index.js' }
  };
  test.identical( got, exp );
  a.fileProvider.filesDelete( actionPath );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'config file does not exists';
  common.actionClone( actionPath, common.remotePathFromActionName( 'dmvict/test.action@v0.0.2' ) );
  a.fileProvider.filesDelete( a.abs( actionPath, 'action.yml' ) );
  test.shouldThrowErrorSync( () => common.actionConfigRead( actionPath ) );
}

// --
// declare
// --

const Proto =
{
  name : 'Common',
  silencing : 1,

  tests :
  {
    remotePathFromActionName,
    actionClone,
    actionConfigRead,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


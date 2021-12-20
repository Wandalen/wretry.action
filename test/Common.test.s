( function _Common_test_s_()
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

  /* - */

  a.ready.then( () =>
  {
    test.case = 'action without hash or tag';
    var remotePath = common.remotePathFromActionName( 'dmvict/test.action' );
    return common.actionClone( localPath, remotePath );
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    test.identical( __.git.tagLocalRetrive({ localPath }), 'master' );
    a.fileProvider.filesDelete( localPath );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'action with tag';
    var remotePath = common.remotePathFromActionName( 'dmvict/test.action@v0.0.2' );
    return common.actionClone( localPath, remotePath );
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    test.identical( __.git.tagLocalRetrive({ localPath }), 'v0.0.2' );
    a.fileProvider.filesDelete( localPath );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'action with short hash';
    var remotePath = common.remotePathFromActionName( 'dmvict/test.action@3d21630' );
    return common.actionClone( localPath, remotePath );
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    test.identical( __.git.tagLocalRetrive({ localPath }), 'v0.0.1' );
    a.fileProvider.filesDelete( localPath );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'action with long hash';
    var remotePath = common.remotePathFromActionName( 'dmvict/test.action@3d2163092fd3c83e02895189bf8fb845c5dc9e3f' );
    return common.actionClone( localPath, remotePath );
  });
  a.ready.then( ( op ) =>
  {
    test.identical( op, true );
    test.identical( __.git.tagLocalRetrive({ localPath }), 'v0.0.1' );
    a.fileProvider.filesDelete( localPath );
    return null;
  });

  /* - */

  return a.ready;
}

actionClone.timeOut = 30000;

//

function actionConfigRead( test )
{
  const a = test.assetFor( false );
  const actionPath = a.abs( '.' );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'read directory with action file';
    return common.actionClone( actionPath, common.remotePathFromActionName( 'dmvict/test.action@v0.0.2' ) );
  });
  a.ready.then( ( op ) =>
  {
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
    return null;
  });

  /* - */

  if( Config.debug )
  {
    a.ready.then( () => common.actionClone( actionPath, common.remotePathFromActionName( 'dmvict/test.action@v0.0.2' ) ) );
    a.ready.then( () =>
    {
      test.case = 'config file does not exists';
      a.fileProvider.filesDelete( a.abs( actionPath, 'action.yml' ) );
      test.shouldThrowErrorSync( () => common.actionConfigRead( actionPath ) );
      return null;
    });
  }

  /* - */

  return a.ready;
}

actionConfigRead.timeOut = 20000;

//

function actionOptionsParse( test )
{
  test.case = 'empty array';
  var src = [];
  var got = common.actionOptionsParse( src );
  test.identical( got, {} );

  /* - */

  test.open( 'without spaces' );

  test.case = 'string with delimeter, no value';
  var src = [ 'str:' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { str : '' } );

  test.case = 'string with delimeter, no key';
  var src = [ ':str' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { '' : 'str' } );

  test.case = 'string with delimeter, key-value';
  var src = [ 'str:value' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { str : 'value' } );

  test.case = 'string with delimeter, key-value, value is number';
  var src = [ 'str:3' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { str : '3' } );

  test.case = 'several strings';
  var src = [ 'str:value', 'number:2' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { str : 'value', number : '2' } );

  test.case = 'string with uri';
  var src = [ 'url:https://google.com' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { url : 'https://google.com' } );

  test.close( 'without spaces' );

  /* - */

  test.open( 'with spaces' );

  test.case = 'string with delimeter, no value';
  var src = [ ' str : ' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { str : '' } );

  test.case = 'string with delimeter, no key';
  var src = [ ' :  str  ' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { '' : 'str' } );

  test.case = 'string with delimeter, key-value';
  var src = [ '  str    : value   ' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { str : 'value' } );

  test.case = 'string with delimeter, key-value, value is number';
  var src = [ '  str : 3' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { str : '3' } );

  test.case = 'several strings';
  var src = [ ' str  : value', 'number : 2   ' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { str : 'value', number : '2' } );

  test.case = 'string with uri';
  var src = [ ' url  : https://google.com    ' ];
  var got = common.actionOptionsParse( src );
  test.identical( got, { url : 'https://google.com' } );

  test.close( 'with spaces' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without delimeter';
  var src = [ 'str' ];
  test.shouldThrowErrorSync( () => common.actionOptionsParse( src ) );
}

//

function envOptionsFrom( test )
{
  test.case = 'no options';
  var src = {};
  var got = common.envOptionsFrom( src );
  test.identical( got, {} );
  test.true( got !== src );

  test.case = 'simple option, lower case';
  var src = { 'a' : '1' };
  var got = common.envOptionsFrom( src );
  test.identical( got, { INPUT_A : '1' } );
  test.true( got !== src );

  test.case = 'option with spaces, lower case';
  var src = { 'a b c' : '1' };
  var got = common.envOptionsFrom( src );
  test.identical( got, { INPUT_A_B_C : '1' } );
  test.true( got !== src );

  test.case = 'simple option, upper case';
  var src = { 'A' : '1' };
  var got = common.envOptionsFrom( src );
  test.identical( got, { INPUT_A : '1' } );
  test.true( got !== src );

  test.case = 'option with spaces, upper case';
  var src = { 'A B C' : '1' };
  var got = common.envOptionsFrom( src );
  test.identical( got, { INPUT_A_B_C : '1' } );
  test.true( got !== src );

  test.case = 'option with spaces, mixed case';
  var src = { 'A b c' : '1' };
  var got = common.envOptionsFrom( src );
  test.identical( got, { INPUT_A_B_C : '1' } );
  test.true( got !== src );
}

//

function envOptionsSetup( test )
{
  const beginEnvs = _.map.extend( null, process.env );

  /* */

  test.case = 'empty options';
  var src = {};
  common.envOptionsSetup( src );
  test.identical( _.mapBut_( null, process.env, beginEnvs ), {} );

  test.case = 'several options';
  var src = { 'option1' : 'a', 'INPUT_V' : 'input' };
  common.envOptionsSetup( src );
  test.identical( _.mapBut_( null, process.env, beginEnvs ), { 'option1' : 'a', 'INPUT_V' : 'input' } );
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
    actionOptionsParse,
    envOptionsFrom,
    envOptionsSetup,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


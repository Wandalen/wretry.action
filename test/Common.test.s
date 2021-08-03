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
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();


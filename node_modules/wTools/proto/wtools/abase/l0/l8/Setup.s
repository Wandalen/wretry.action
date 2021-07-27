( function _Setup_s_()
{

'use strict';

const _global = _global_;
const _ = _global.wTools;
const Self = _.setup = _.setup || Object.create( null );
_.error = _.error || Object.create( null );

// --
// setup
// --

function _setupConfig()
{

  if( _global.__GLOBAL_NAME__ !== 'real' )
  return;

  if( !_global.Config )
  _global.Config = Object.create( null );

  if( _global.Config.debug === undefined )
  _global.Config.debug = true;

  _global.Config.debug = !!_global.Config.debug;

}

//

function _setupLoggerPlaceholder()
{

  if( !_global.console.debug )
  _global.console.debug = function debug()
  {
    this.log.apply( this, arguments );
  }

  if( !_global.logger )
  _global.logger =
  {
    log : function log() { console.log.apply( console, arguments ); },
    logUp : function logUp() { console.log.apply( console, arguments ); },
    logDown : function logDown() { console.log.apply( console, arguments ); },
    error : function error() { console.error.apply( console, arguments ); },
    errorUp : function errorUp() { console.error.apply( console, arguments ); },
    errorDown : function errorDown() { console.error.apply( console, arguments ); },
    info : function info() { console.info.apply( console, arguments ); },
    warn : function warn() { console.warn.apply( console, arguments ); },
    debug : function debug() { console.debug.apply( console, arguments ); },
  }

}

//

function _setupTesterPlaceholder()
{

  if( !_global.wTestSuite )
  _global.wTestSuite = function wTestSuite( testSuit )
  {

    if( !_realGlobal_.wTests )
    _realGlobal_.wTests = Object.create( null );

    if( !testSuit.suiteFilePath )
    testSuit.suiteFilePath = _.introspector.location( 1 ).filePath;

    if( !testSuit.suiteFileLocation )
    testSuit.suiteFileLocation = _.introspector.location( 1 ).fileNameLineCol;

    _.assert( _.strDefined( testSuit.suiteFileLocation ), 'Test suit expects a mandatory option ( suiteFileLocation )' );
    _.assert( _.object.isBasic( testSuit ) );

    if( !testSuit.abstract )
    _.assert( !_realGlobal_.wTests[ testSuit.name ], 'Test suit with name "' + testSuit.name + '" already registered!' );
    _realGlobal_.wTests[ testSuit.name ] = testSuit;

    testSuit.inherit = function inherit()
    {
      this.inherit = _.longSlice( arguments );
    }

    return testSuit;
  }

  /* */

  if( !_realGlobal_.wTester )
  {
    _realGlobal_.wTester = Object.create( null );
    _realGlobal_.wTester.test = function test( testSuitName )
    {
      if( _.workerIs() ) /* xxx : temp */
      return;
      if( Config.interpreter !== 'njs' ) /* xxx : temp. remove aster fixing starter */
      return;
      _.assert( arguments.length === 0 || arguments.length === 1 );
      _.assert( _.strIs( testSuitName ) || testSuitName === undefined, 'test : expects string {-testSuitName-}' );
      debugger;
      _.process.ready( function()
      {
        debugger;
        if( _realGlobal_.wTester.test === test )
        throw _.err( 'Cant run tests. Include module::wTesting.' );
        _realGlobal_.wTester.test.call( _realGlobal_.wTester, testSuitName );
      });
    }
  }

}

//

function _setupProcedure()
{

  if
  (
    _realGlobal_ !== _global
    && _realGlobal_.wTools
    && _realGlobal_.wTools.setup
    && _realGlobal_.wTools.setup._entryProcedureStack
  )
  {
    Self._entryProcedureStack =  _realGlobal_.wTools.setup._entryProcedureStack;
  }

  if( Self._entryProcedureStack )
  return;

  let stack = _.introspector.stack().split( '\n' );
  for( let s = stack.length-1 ; s >= 0 ; s-- )
  {
    let call = stack[ s ];
    let location = _.introspector.locationFromStackFrame( call );
    if( !location.internal && !location.abstraction )
    {
      stack.splice( s+1, stack.length );
      stack.splice( 0, s );
      break;
    }
  }

  Self._entryProcedureStack = stack.join( '\n' );
}

//

function _setupTime()
{

  _.assert( !!_.time && !!_.time.now );
  _.setup.startTime = _.time.now();

}

//

function _validate()
{

  if( !Config.debug )
  return;

  _.assert( _.routine.is( _.array._elementWithKey ) );
  _.assert( _.routine.is( _.argumentsArray._elementWithKey ) );
  _.assert( _.routine.is( _.long._elementWithKey ) );
  _.assert( _.routine.is( _.map._elementWithKey ) );
  _.assert( _.routine.is( _.object._elementWithKey ) );

  if( !Object.hasOwnProperty.call( _global_, 'wTools' ) || !_global_.wTools.maybe )
  {
    debugger;
    throw new Error( 'Failed to include module::wTools' );
  }

}

//

function _Setup9()
{

  _.assert( _global._WTOOLS_SETUP_EXPECTED_ !== false );

  if( _global._WTOOLS_SETUP_EXPECTED_ !== false )
  {
    _.setup._setupConfig();
    _.error._setupUncaughtErrorHandler9();
    _.setup._setupLoggerPlaceholder();
    _.setup._setupTesterPlaceholder();
    _.setup._setupProcedure();
    _.setup._setupTime();
    _.setup._validate();
  }

}

// --
// implementation
// --

let SetupExtension =
{

  _setupConfig,
  _setupLoggerPlaceholder,
  _setupTesterPlaceholder,
  _setupProcedure,
  _setupTime,
  _validate,

  _Setup9,

  //

  startTime : null,
  _entryProcedureStack : null,

}

Object.assign( _.setup, SetupExtension );
Self._Setup9();

})();

( function _l1_1Diagnostic_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.diagnostic = _.diagnostic || Object.create( null );

// --
//
// --

function _err()
{
  return new Error( ... arguments );
}

// --
// surer
// --

/* xxx : solve problem exporting routines using __boolLike */
function __boolLike( src )
{
  let type = Object.prototype.toString.call( src );
  return type === '[object Boolean]' || type === '[object Number]';
}

//

function _sureDebugger( condition )
{
  if( !_.error.breakpointOnAssertEnabled )
  return;
  debugger; /* eslint-disable-line no-debugger */
}

//

function sure( condition, ... args )
{

  if( !condition || !__boolLike( condition ) )
  {
    _sureDebugger( condition );
    if( !_._err )
    throw Error( ... args );
    if( arguments.length === 1 )
    throw _._err
    ({
      args : [ 'Assertion fails' ],
      level : 2,
    });
    else if( arguments.length === 2 )
    throw _._err
    ({
      args : [ arguments[ 1 ] ],
      level : 2,
    });
    else
    throw _._err
    ({
      args : Array.prototype.slice.call( arguments, 1 ),
      level : 2,
    });
  }

  return;
}

//

function sureBriefly( condition, ... args )
{

  if( !condition || !__boolLike( condition ) )
  {
    _sureDebugger( condition );
    if( !_._err )
    throw Error( ... args );
    if( arguments.length === 1 )
    throw _._err
    ({
      args : [ 'Assertion fails' ],
      level : 2,
      brief : 1,
    });
    else if( arguments.length === 2 )
    throw _._err
    ({
      args : [ arguments[ 1 ] ],
      level : 2,
      brief : 1,
    });
    else
    throw _._err
    ({
      args : Array.prototype.slice.call( arguments, 1 ),
      level : 2,
      brief : 1,
    });
  }

  return;
}

//

function sureWithoutDebugger( condition, ... args )
{

  if( !condition || !__boolLike( condition ) )
  {
    if( !_._err )
    throw Error( ... args );
    if( arguments.length === 1 )
    throw _._err
    ({
      args : [ 'Assertion fails' ],
      level : 2,
    });
    else if( arguments.length === 2 )
    throw _._err
    ({
      args : [ arguments[ 1 ] ],
      level : 2,
    });
    else
    throw _._err
    ({
      args : Array.prototype.slice.call( arguments, 1 ),
      level : 2,
    });
  }

  return;
}

// --
//
// --

/**
 * Checks condition passed by argument( condition ). Works only in debug mode. Uses StackTrace level 2.
 *
 * @see {@link wTools.err err}
 *
 * If condition is true routine returns without exceptions, otherwise routine generates and throws exception. By default generates error with message 'Assertion fails'.
 * Also generates error using message(s) or existing error object(s) passed after first argument.
 *
 * @param {*} condition - condition to check.
 * @param {String|Error} [ msgs ] - error messages for generated exception.
 *
 * @example
 * let x = 1;
 * _.assert( _.strIs( x ), 'incorrect variable type->', typeof x, 'Expects string' );
 *
 * // log
 * // caught eval (<anonymous>:2:8)
 * // incorrect variable type-> number expects string
 * // Error
 * //   at _err (file:///.../wTools/staging/Base.s:3707)
 * //   at assert (file://.../wTools/staging/Base.s:4041)
 * //   at add (<anonymous>:2)
 * //   at <anonymous>:1
 *
 * @example
 * function add( x, y )
 * {
 *   _.assert( arguments.length === 2, 'incorrect arguments count' );
 *   return x + y;
 * }
 * add();
 *
 * // log
 * // caught add (<anonymous>:3:14)
 * // incorrect arguments count
 * // Error
 * //   at _err (file:///.../wTools/staging/Base.s:3707)
 * //   at assert (file://.../wTools/staging/Base.s:4035)
 * //   at add (<anonymous>:3:14)
 * //   at <anonymous>:6
 *
 * @example
 *   function divide ( x, y )
 *   {
 *      _.assert( y != 0, 'divide by zero' );
 *      return x / y;
 *   }
 *   divide( 3, 0 );
 *
 * // log
 * // caught     at divide (<anonymous>:2:29)
 * // divide by zero
 * // Error
 * //   at _err (file:///.../wTools/staging/Base.s:1418:13)
 * //   at wTools.errLog (file://.../wTools/staging/Base.s:1462:13)
 * //   at divide (<anonymous>:2:29)
 * //   at <anonymous>:1:1
 * @throws {Error} If passed condition( condition ) fails.
 * @function assert
 * @namespace Tools
 */

//

function assert( condition, ... args )
{

  if( Config.debug === false )
  return true;

  if( condition !== true )
  {
    _assertDebugger( condition, arguments );
    if( !_._err )
    throw Error( ... args );
    if( arguments.length === 1 )
    throw _._err
    ({
      args : [ 'Assertion fails' ],
      level : 2,
    });
    else if( arguments.length === 2 )
    throw _._err
    ({
      args : [ arguments[ 1 ] ],
      level : 2,
    });
    else
    throw _._err
    ({
      args : Array.prototype.slice.call( arguments, 1 ),
      level : 2,
    });
  }

  return true;

  function _assertDebugger( condition, args )
  {
    if( !_.error.breakpointOnAssertEnabled )
    return;
    debugger; /* eslint-disable-line no-debugger */
  }

}

//

function assertWithoutBreakpoint( condition, ... args )
{

  if( Config.debug === false )
  return true;

  if( !condition || !__boolLike( condition ) )
  {
    if( !_._err )
    throw Error( ... args );
    if( arguments.length === 1 )
    throw _._err
    ({
      args : [ 'Assertion fails' ],
      level : 2,
    });
    else if( arguments.length === 2 )
    throw _._err
    ({
      args : [ arguments[ 1 ] ],
      level : 2,
    });
    else
    throw _._err
    ({
      args : Array.prototype.slice.call( arguments, 1 ),
      level : 2,
    });
  }

  return;
}

//

function assertNotTested( src )
{
  _.assert( false, 'not tested : ' + stack( 1 ) );
}

//

/**
 * If condition failed, routine prints warning messages passed after condition argument
 * @example
 * function checkAngles( a, b, c )
 * {
 *    _.assertWarn( (a + b + c) === 180, 'triangle with that angles does not exists' );
 * };
 * checkAngles( 120, 23, 130 );
 *
 * // log 'triangle with that angles does not exists'
 *
 * @param condition Condition to check.
 * @param messages messages to print.
 * @function assertWarn
 * @namespace Tools
 */

function assertWarn( condition )
{

  if( Config.debug )
  return;

  if( !condition || !__boolLike( condition ) )
  {
    console.warn.apply( console, [].slice.call( arguments, 1 ) );
  }

}

// --
// declare
// --

if( Config.debug )
Object.defineProperty( _, 'debugger',
{
  enumerable : false,
  configurable : true,
  set : function( val )
  {
    let debuggerSymbol = Symbol.for( 'debugger' );
    if( _[ debuggerSymbol ] === val )
    return;
    _[ debuggerSymbol ] = val;
    for( let k in _globals_ )
    if( _globals_[ k ].wTools[ debuggerSymbol ] !== val )
    _globals_[ k ].wTools[ debuggerSymbol ] = val;
  },
  get : function()
  {
    let debuggerSymbol = Symbol.for( 'debugger' );
    let val = _[ debuggerSymbol ];
    if( val )
    debugger; /* eslint-disable-line no-debugger */
    return val;
  },
});

// --
// diagnostic extension
// --

let DiagnosticExtension =
{

  // sure

  sure,
  sureBriefly,
  sureWithoutDebugger,

  // assert

  assert,
  assertWithoutBreakpoint,
  assertNotTested,
  assertWarn,

}

//

Object.assign( _.diagnostic, DiagnosticExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  //

  _err,

  // sure

  sure,
  sureBriefly,
  sureWithoutDebugger,

  // assert

  assert,
  assertWithoutBreakpoint,
  assertNotTested,
  assertWarn,

}

Object.assign( _, ToolsExtension );

})();

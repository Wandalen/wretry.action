( function _l3_Err_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function _handleUncaught2( o )
{
  const __ = _global_.globals && _globals_.testing.wTools;
  const process0 = processNamespaceGet();

  optionsRefine();

  /* xxx qqq : resolve issue in browser
    if file has syntax error then unachught error should not ( probably ) be throwen
    because browser thows uncontrolled information about syntax error after that
    avoid duplication of errors in log
  */

  o.err = errRefine( o.err );

  processUncaughtErrorEvent();

  if( _.error.isAttended( o.err ) )
  return;

  consoleUnbar();

  console.error( o.prefix );

  errLogFields();
  errLog();

  console.error( o.postfix );

  processExit();

  /* */

  function optionsRefine()
  {

    if( !o.origination )
    o.origination = 'uncaught error';

    // for( let k in o )
    // if( _handleUncaught2.defaults[ k ] !== undefined )
    // {
    //   console.error( `Routine::_handleUncaught2() does not expect option::${k}` );
    // }

    o.prefix = `--------------- ${o.origination} --------------->\n`;
    o.postfix = `--------------- ${o.origination} ---------------<\n`;
    o.logger = _global.logger || _global.console;

  }

  /* */

  function consoleUnbar()
  {
    let Logger = loggerClassGet();
    try
    {
      if( Logger && Logger.ConsoleBar && Logger.ConsoleIsBarred( console ) )
      Logger.ConsoleBar({ on : 0 });
    }
    catch( err2 )
    {
      debugger;
      console.error( err2 );
    }
  }

  /* */

  function errLog()
  {
    try
    {
      if( _.error && _.error._log )
      _.error._log( o.err, o.logger );
      else
      console.error( o.err );
    }
    catch( err2 )
    {
      debugger;
      console.error( err2 );
      console.error( o.err );
    }
  }

  /* */

  function errLogFields()
  {
    if( !o.err.originalMessage && _.object.like && _.object.like( o.err ) )
    try
    {
      let props = Object.create( null );
      for( let k in o.err )
      props[ k ] = o.err[ k ];
      // let serr = _.entity.exportString && _.props ? _.entity.exportString.fields( o.err, { errorAsMap : 1 } ) : o.err;
      o.logger.error( _.entity.exportString( props ) );
      debugger;
    }
    catch( err2 )
    {
      debugger;
      console.error( err2 );
    }
  }

  /* */

  function errRefine( err )
  {
    try
    {
      return _.error.process( err );
    }
    catch( err2 )
    {
      console.error( err2 );
      return err;
    }
  }

  /* */

  function processNamespaceGet()
  {
    let result;
    if( !result && _.process && _.process.exitReason )
    result = _.process;
    if( !result && _realGlobal_ && _realGlobal_.wTools && _realGlobal_.wTools.process && _realGlobal_.wTools.process.exitReason )
    result = _realGlobal_.wTools.process;
    if
    (
      !result
      && _realGlobal_._globals_.testing
      && __
      && __.process
      && __.process.exitReason
    )
    result = __.process;
    if( !result )
    result = _.process;
    return result;
  }

  /* */

  function loggerClassGet()
  {
    let result;
    if( !result && _.Logger && _.Logger.ConsoleBar )
    result = _.Logger;
    if( !result && _realGlobal_ && _realGlobal_.wTools && _realGlobal_.wTools.Logger && _realGlobal_.wTools.Logger.ConsoleBar )
    result = _realGlobal_.wTools.Logger;
    if
    (
      !result
      && __
      && __.Logger
      && __.Logger.ConsoleBar
    )
    result = __.Logger;
    return result;
  }

  /* */

  function processUncaughtErrorEvent()
  {
    try
    {
      // if( process0.eventGive ) /* xxx : cover in starter not catching uncaught error */
      if( process0 && process0.eventGive )
      // process0.eventGive({ event : 'uncaughtError', args : [ o ] });
      /* xxx : move to namespace app? */
      process0.eventGive({ event : 'uncaughtError', origination : o.origination, err : o.err });
      for( let g in _realGlobal_._globals_ )
      {
        const _global = _realGlobal_._globals_[ g ];
        if( _global.wTools && _global.wTools.process && _global.wTools.process.eventGive )
        if( _global.wTools.process !== process0 )
        _global.wTools.process.eventGive({ event : 'uncaughtError', origination : o.origination, err : o.err });
        // _global.wTools.process.eventGive({ event : 'uncaughtError', args : [ o ] });
      }
    }
    catch( err2 )
    {
      debugger;
      console.log( err2 );
      exitError( err2, false );
    }
  }

  /* */

  function exitError( err, rewriting )
  {
    let set = false;
    debugger;
    if( process0 && process0.exit )
    try
    {
      process0.exitCode( -1 );
      if( !process0.exitReason() )
      process0.exitReason( err );
      set = true;
    }
    catch( err2 )
    {
      debugger;
      console.log( err2 );
    }
    if( !set )
    try
    {
      if( _global.process )
      {
        if( !process.exitCode )
        process.exitCode = -1;
        set = true;
      }
    }
    catch( err2 )
    {
    }
  }

  /* */

  function processExit()
  {
    exitError( o.err, true );
    if( process0 && process0.exit )
    try
    {
      process0.exit();
    }
    catch( err2 )
    {
      debugger;
      console.log( err2 );
      exitError( o.err, false );
    }
    try
    {
      if( _global.process )
      process.exit();
    }
    catch( err2 )
    {
    }
  }

}

_handleUncaught2.defaults =
{
  err : null,
  origination : null,
}

//

function _handleUncaughtAsync( err )
{

  if( _.error.isAttended( err ) )
  return err;

  if( !err )
  debugger;
  _.error.wary( err, 1 );

  if( _.error.isSuspended( err ) )
  return err;

  let timer = _.time._finally( _.error.uncaughtDelayTime, function uncaught()
  {

    if( _.error.isAttended( err ) )
    return;

    if( _.error.isSuspended( err ) )
    return;

    if( !err )
    debugger;

    _.error._handleUncaught2({ err, origination : 'uncaught asynchronous error' });

  });

  return err;
}

//

function _setupUncaughtErrorHandler9()
{

  if( !_realGlobal_._setupUncaughtErrorHandlerDone )
  {
    debugger;
    throw Error( 'setup0 should be called first' );
  }

  if( _realGlobal_._setupUncaughtErrorHandlerDone > 1 )
  return;

  _realGlobal_._setupUncaughtErrorHandlerDone = 2;

  /* */

  if( _global.process && _.routine.is( _global.process.on ) )
  {
    _.error._handleUncaughtHead = _errHeadNode;
  }
  else if( Object.hasOwnProperty.call( _global, 'onerror' ) )
  {
    _.error._handleUncaughtHead = _errHeadBrowser;
  }

  /* */

  function _errHeadBrowser( args )
  {
    let [ message, sourcePath, lineno, colno, error ] = args;
    let err = error || message;

    if( _._err )
    err = _._err
    ({
      args : [ error || message ],
      level : 1,
      fallBackStack : 'at handleError @ ' + sourcePath + ':' + lineno,
      throwLocation :
      {
        filePath : sourcePath,
        line : lineno,
        col : colno,
      },
    });

    return [ { err, args } ];
  }

  /* */

  function _errHeadNode( args )
  {
    return [ { err : args[ 0 ], args } ];
  }

  /* */

}

//

/* qqq : for junior : for Rahul : implement performance test */
/* xxx : optimize */
function error_functor( name, onErrorMake )
{

  _.assert( _._err.defaults[ name ] === undefined );

  if( _.strIs( onErrorMake ) || _.arrayIs( onErrorMake ) )
  {
    let prepend = onErrorMake;
    onErrorMake = function onErrorMake()
    {
      debugger;
      let args = _.arrayAppendArrays( [], [ prepend, arguments ] );
      return args;
    }
  }
  else if( !onErrorMake )
  {
    onErrorMake = function onErrorMake()
    {
      return arguments;
    }
  }

  let Error =
  {
    [ name ] : function()
    {
      if( ( this instanceof ErrorConstructor ) )
      {

        let err1 = this;
        let args1 = onErrorMake.apply( err1, arguments );
        _.assert( _.argumentsArray.like( args1 ) );
        let args2 = args1;

        if( !Array.prototype.includes.call( args2, err1 ) )
        args2 = [ err1, ... args1 ];
        let err2 = _._err({ args : args2, level : 2, concealed : { [ name ] : true } });
        _.assert( err1 === err2 );
        _.assert( err2 instanceof _global.Error );
        _.assert( err2 instanceof ErrorConstructor );
        return err2;

      }
      else
      {

        if( arguments.length === 1 && arguments[ 0 ] && arguments[ 0 ] instanceof ErrorConstructor )
        return arguments[ 0 ];

        let err1;
        for( let i = 0 ; i < arguments.length ; i++ )
        if( arguments[ i ] && arguments[ i ] instanceof ErrorConstructor )
        {
          err1 = arguments[ i ];
          break;
        }

        if( err1 )
        return ErrorConstructor.apply( err1, arguments );
        return new ErrorConstructor( ... arguments );
      }
    }
  }

  let ErrorConstructor = Error[ name ];

  _.assert
  (
    ErrorConstructor.name === name,
    'Looks like your interpreter does not support dynamice naming of functions. Please use ES2015 or later interpreter.'
  );

  ErrorConstructor.prototype = Object.create( _global.Error.prototype );
  ErrorConstructor.prototype.constructor = ErrorConstructor;
  // ErrorConstructor.constructor = ErrorConstructor;
  // ErrorConstructor.constructor = Object.create( _global.Error.constructor );
  Object.setPrototypeOf( ErrorConstructor, _global.Error );

  return ErrorConstructor;
}

// --
// extension
// --

let Extension =
{

  _handleUncaught2,
  _handleUncaughtAsync,
  _setupUncaughtErrorHandler9,

  error_functor,

  uncaughtDelayTime : 100,

}

//

/* _.props.extend */Object.assign( _.error, Extension );

})();

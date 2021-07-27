( function _Tools_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
let Esprima;

// --
// routine
// --

/**
 * Return function that will call passed routine function with delay.
 * @param {number} delay delay in milliseconds
 * @param {Function} routine function that will be called with delay.
 * @returns {Function} result function
 * @throws {Error} If arguments less then 2
 * @throws {Error} If `delay` is not a number
 * @throws {Error} If `routine` is not a function
 * @function routineDelayed
 * @namespace Tools.program
 */

function routineDelayed( delay, routine )
{

  _.assert( arguments.length >= 2, 'Expects at least two arguments' );
  _.assert( _.numberIs( delay ) );
  _.assert( _.routineIs( routine ) );

  if( arguments.length > 2 )
  {
    _.assert( arguments.length <= 4 );
    routine = _.routineJoin.call( _, arguments[ 1 ], arguments[ 2 ], arguments[ 3 ] );
  }

  return function delayed()
  {
    _.time.out( delay, this, routine, arguments );
  }

}

//

/**
 * Calls function( routine ) with custom context( context ) and arguments( args ).
 * @param {Object} context custom context
 * @param {Function} routine function that will be called
 * @param {Array} args arrat of arguments
 * @function routineCall
 * @namespace Tools.program
 */

function routineCall( context, routine, args )
{
  let result;

  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  /* */

  if( arguments.length === 1 )
  {
    let routine = arguments[ 0 ];
    result = routine();
  }
  else if( arguments.length === 2 )
  {
    let context = arguments[ 0 ];
    let routine = arguments[ 1 ];
    result = routine.call( context );
  }
  else if( arguments.length === 3 )
  {
    let context = arguments[ 0 ];
    let routine = arguments[ 1 ];
    let args = arguments[ 2 ];
    _.assert( _.longIs( args ) );
    result = routine.apply( context, args );
  }
  else _.assert( 0, 'unexpected' );

  return result;
}

//

/**
 * Calls function with custom context and options.
 * Takes only options that are supported by provided routines.
 *
 * @param {Object} context custom context
 * @param {Function} routine function that will be called
 * @param {Object} options options map
 * @function routineTolerantCall
 * @namespace Tools.program
 */

function routineTolerantCall( context, routine, options )
{

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( _.routineIs( routine ) );
  _.assert( _.object.isBasic( routine.defaults ) );
  _.assert( _.object.isBasic( options ) );

  options = _.mapOnly_( null, options, routine.defaults );
  let result = routine.call( context, options );

  return result;
}

//

function routinesJoin()
{
  let result, routines, index;
  let args = _.longSlice( arguments );

  _.assert( arguments.length >= 1 && arguments.length <= 3 );

  /* */

  function makeResult()
  {

    _.assert( _.object.isBasic( routines ) || _.arrayIs( routines ) || _.routineIs( routines ) );

    if( _.routineIs( routines ) )
    routines = [ routines ];

    result = _.entity.cloneShallow( routines );

  }

  /* */

  if( arguments.length === 1 )
  {
    routines = arguments[ 0 ];
    index = 0;
    makeResult();
  }
  else if( arguments.length === 2 )
  {
    routines = arguments[ 1 ];
    index = 1;
    makeResult();
  }
  else if( arguments.length === 3 )
  {
    routines = arguments[ 1 ];
    index = 1;
    makeResult();
  }
  else _.assert( 0, 'unexpected' );

  /* */

  if( _.arrayIs( routines ) )
  for( let r = 0 ; r < routines.length ; r++ )
  {
    args[ index ] = routines[ r ];
    result[ r ] = _.routineJoin.apply( this, args );
  }
  else
  for( let r in routines )
  {
    args[ index ] = routines[ r ];
    result[ r ] = _.routineJoin.apply( this, args );
  }

  /* */

  return result;
}

//

function _routinesCall( o )
{
  let result, context, routines, args;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.args.length >= 1 && o.args.length <= 3 );

  /* */

  if( o.args.length === 1 )
  {
    routines = o.args[ 0 ];

    makeResult();

    if( _.arrayIs( routines ) )
    for( let r = 0 ; r < routines.length ; r++ )
    {
      result[ r ] = routines[ r ]();
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }
    else
    for( let r in routines )
    {
      result[ r ] = routines[ r ]();
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }

  }
  else if( o.args.length === 2 )
  {
    context = o.args[ 0 ];
    routines = o.args[ 1 ];

    makeResult();

    if( _.arrayIs( routines ) )
    for( let r = 0 ; r < routines.length ; r++ )
    {
      result[ r ] = routines[ r ].call( context );
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }
    else
    for( let r in routines )
    {
      result[ r ] = routines[ r ].call( context );
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }

  }
  else if( o.args.length === 3 )
  {
    context = o.args[ 0 ];
    routines = o.args[ 1 ];
    args = o.args[ 2 ];

    _.assert( _.longIs( args ) );

    makeResult();

    if( _.arrayIs( routines ) )
    for( let r = 0 ; r < routines.length ; r++ )
    {
      result[ r ] = routines[ r ].apply( context, args );
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }
    else
    for( let r in routines )
    {
      result[ r ] = routines[ r ].apply( context, args );
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }

  }
  else _.assert( 0, 'unexpected' );

  return result;

  /* */

  function makeResult()
  {

    _.assert
    (
      _.object.isBasic( routines ) || _.arrayIs( routines ) || _.routineIs( routines ),
      'Expects object, array or routine (-routines-), but got', _.entity.strType( routines )
    );

    if( _.routineIs( routines ) )
    routines = [ routines ];

    result = _.entity.cloneShallow( routines );

  }

}

_routinesCall.defaults =
{
  args : null,
  whileTrue : 0,
}

//

/**
* Call each routines in array with passed context and arguments.
   The context and arguments are same for each called functions.
   Can accept only routines without context and args.
   Can accept single routine instead array.
* @example
    let x = 2, y = 3,
        o { z : 6 };

    function sum( x, y )
    {
        return x + y + this.z;
    },
    prod = function( x, y )
    {
        return x * y * this.z;
    },
    routines = [ sum, prod ];
    let res = wTools.routinesCall( o, routines, [ x, y ] ); // [ 11, 36 ]
*
* @param {Object} [context] Context in which calls each function.
* @param {Function} routines Array of called function
* @param {Array} [args] Arguments that will be passed to each functions.
* @returns {Array} Array with results of functions invocation.
* @function routinesCall
* @namespace Tools.program
*/

function routinesCall()
{
  let result;

  result = _routinesCall
  ({
    args : arguments,
    whileTrue : 0,
  });

  return result;
}

//

function routinesCallEvery()
{
  let result;

  result = _routinesCall
  ({
    args : arguments,
    whileTrue : 1,
  });

  return result;
}

//

/**
 * @summary Calls provided methods with custom context and arguments.
 * @description
 * Each method is called with onlyOwn context. Arguments are common. Saves result of each call into array.
 * @param {Array} contexts array of contexts
 * @param {Function} methods methods that will be called
 * @param {Array} [args] arguments array
 * @throws {Error} If context for the method doesn't exist or vise versa.
 * @returns {Array} Returns results of methods call as array.
 * @function methodsCall
 * @namespace Tools.program
 */

function methodsCall( contexts, methods, args )
{
  let result = [];

  if( args === undefined )
  args = [];

  let isContextsArray = _.longIs( contexts );
  let isMethodsArray = _.longIs( methods );
  let l1 = isContextsArray ? contexts.length : 1;
  let l2 = isMethodsArray ? methods.length : 1;
  let l = Math.max( l1, l2 );

  _.assert( l >= 0 );
  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );

  if( !l )
  return result;

  let contextGet;
  if( isContextsArray )
  contextGet = ( i ) => contexts[ i ];
  else
  contextGet = ( i ) => contexts;

  let methodGet;
  if( isMethodsArray )
  methodGet = ( i ) => methods[ i ];
  else
  methodGet = ( i ) => methods;

  for( let i = 0 ; i < l ; i++ )
  {
    let context = contextGet( i );
    let routine = context[ methodGet( i ) ];
    _.assert( _.routineIs( routine ) );
    result[ i ] = routine.apply( context, args )
  }

  return result;
}

// --
//
// --

/**
 * @summary Extracts routine's source code.
 * @description
 * Accepts options map or routine as single argument.
 * @param {Object} o options map
 * @param {Function} o.routine source function
 * @param {Boolean} o.wrap=1
 * @param {Boolean} o.withWrap=1 wraps source code with routine definition
 * @param {Boolean} o.usingInline=1
 * @param {Object} o.toJsOptions=null options for {@link module:Tools/base/Stringer.Stringer.toJs} routine
 *
 * @example //source code and definition
 * _.routineSourceGet( _.routineDelayed );
 *
 * @example //only source code
 * _.routineSourceGet({ routine : _.routineDelayed, withWrap : 0 });
 *
 * @returns {String} Returns routine's source code as string.
 * @function routineSourceGet
 * @namespace Tools.program
 */

function routineSourceGet( o )
{
  if( _.routineIs( o ) )
  o = { routine : o };

  _.routine.options_( routineSourceGet, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.routineIs( o.routine ) );
  _.assert( _.routineIs( o.routine.toSource ) || _.routineIs( o.routine.toString ) );

  let result = o.routine.toSource ? o.routine.toSource() : o.routine.toString();

  if( !o.withWrap )
  result = unwrap( result )[ 1 ];

  if( o.usingInline && o.routine.inlines )
  {
    let prefix = '\n';
    for( let i in o.routine.inlines )
    {
      let inline = o.routine.inlines[ i ];
      prefix += '  let ' + i + ' = ' + _.entity.exportJs( inline, o.toJsOptions || Object.create( null ) ) + ';\n';
    }
    let splits = unwrap( result );
    splits[ 1 ] = prefix + '\n' + splits[ 1 ];
    result = splits.join( '' );
  }

  return result;

  function unwrap( code )
  {

    let reg1 = /^\s*function\s*\w*\s*\([^\)]*\)\s*\{/;
    let reg2 = /\}\s*$/;

    let before = reg1.exec( code );
    let after = reg2.exec( code );

    if( before && after )
    {
      code = code.replace( reg1, '' );
      code = code.replace( reg2, '' );
    }

    return [ before[ 0 ], code, after[ 0 ] ];
  }

}

routineSourceGet.defaults =
{
  routine : null,
  wrap : 1,
  withWrap : 1,
  usingInline : 1,
  toJsOptions : null,
}

//

/**
 * @summary Makes routine from source code.
 * @description
 * Accepts options map or routine's source code as single argument.
 * @param {Object} o options map
 * @param {Boolean} o.debug=0 prepends `debugger` prefix
 * @param {String} o.code=null source code
 * @param {String} o.filePath=null path to source file, will be inserted as comment
 * @param {Boolean} o.prependingReturn=0 prepends `return` statement before source code
 * @param {Boolean} o.fallingBack=1 tries to make routine without `return` prefix if first attempt with `o.prependingReturn:1` fails.
 * @param {Boolean} o.usingStrict=0 enables strict mode
 * @param {Object} o.externals=null map with external properties that are needed for routine
 * @param {String} o.name=null name of the routine
 *
 * @example //source code and definition
 * let src = 'return 1'
 * let routine = _.routineMake( src );
 * routine(); //1
 *
 * @example //filePath
 * let src = 'return 1'
 * let routine = _.routineMake({ code : src, filePath : '/path/to/source.js' });
 * routine.toString();
 *
 * @example //prependingReturn
 * let src = '1'
 * let routine = _.routineMake({ code : src, prependingReturn : 1 });
 * routine(); //1
 *
 * @example //using externals option
 * let src = 'return a';
 * let routine = _.routineMake({ code : src, externals : { a : 1 } });
 * routine();
 *
 * @returns {Function} Returns created function.
 * @function routineSourceGet
 * @namespace Tools.program
 */

function routineMake( o )
{
  let result;

  if( _.strIs( o ) )
  o = { code : o };

  _.routine.options_( routineMake, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.object.isBasic( o.externals ) || o.externals === null );
  _.assert( !!_realGlobal_ );

  /* prefix */

  let prefix = '\n';

  if( o.usingStrict )
  prefix += `'use strict';\n`;
  if( o.debug )
  prefix += 'debugger;\n';
  if( o.filePath )
  prefix += '// ' + o.filePath + '\n';

  if( o.externals )
  {
    if( !_realGlobal_.__wTools__externals__ )
    _realGlobal_.__wTools__externals__ = [];
    _realGlobal_.__wTools__externals__.push( o.externals );
    prefix += '\n';
    for( let e in o.externals )
    prefix += 'let ' + e + ' = ' + '_realGlobal_.__wTools__externals__[ ' + String( _realGlobal_.__wTools__externals__.length-1 ) + ' ].' + e + ';\n';
    prefix += '\n';
  }

  /* */

  let code;
  try
  {

    if( o.prependingReturn )
    try
    {
      code = prefix + 'return ' + o.code.trimLeft();
      result = make( code );
    }
    catch( err )
    {
      if( o.fallingBack )
      {
        code = prefix + o.code;
        result = make( code );
      }
      else throw err;
    }
    else
    {
      code = prefix + o.code;
      result = make( code );
    }

  }
  catch( err )
  {

    // err = _.err( 'Cant parse the routine\n', _.strLinesNumber( '\n' + code ), '\n', err );
    err = _.err( err, `\nCant parse the routine ${o.name || ''}` );

    if( _global.document )
    {
      let e = document.createElement( 'script' );
      e.type = 'text/javascript';
      e.src = 'data:text/javascript;charset=utf-8,' + escape( o.code );
      document.head.appendChild( e );
    }
    else if( _global.Blob && _global.Worker )
    {
      let worker = _.makeWorker( code );
    }
    else handleErrorWithEsprima( err )
    err = _.err( _.strLinesNumber( code ), '\n', err );

    // throw _.err( err, '\n', 'More information about error is comming asynchronously..' );
    throw err;
    return null;
  }

  return result;

  /* */

  function handleErrorWithEsprima( err )
  {

    if( !Esprima && !_global.esprima )
    try
    {
      Esprima = require( 'esprima' );
    }
    catch( err )
    {
    }

    if( Esprima || _global.esprima )
    {
      let esprima = Esprima || _global.esprima;
      try
      {
        let parsed = esprima.parse( '(function(){\n' + code + '\n})();' );
      }
      catch( err2 )
      {
        if( err2.lineNumber !== undefined )
        code = _.strLinesSelect
        ({
          src : code,
          nearestLines : 5,
          line : err2.lineNumber
        });
        throw _._err
        ({
          args : [ err, err2 ],
          level : 1,
          sourceCode : code,
        });
      }
      return true;
    }

    return false;
  }

  /* */

  function make( code )
  {
    try
    {
      if( o.name )
      code = 'return function ' + o.name + '()\n{\n' + code + '\n}';
      let result = new Function( code );
      if( o.name )
      result = result();
      return result;
    }
    catch( err )
    {
      throw _.err( err );
    }
  }

}

routineMake.defaults =
{
  debug : 0,
  code : null,
  filePath : null,
  // prependingReturn : 1,
  prependingReturn : 0,
  fallingBack : 1,
  usingStrict : 0,
  externals : null,
  name : null,
}

//

/**
 * @summary Makes routine from source code and executes it.
 * @description
 * Accepts options map or routine's source code as single argument.
 * @param {Object} o options map
 * @param {Boolean} o.debug=0 prepends `debugger` prefix
 * @param {String} o.code=null source code
 * @param {String} o.filePath=null path to source file, will be inserted as comment
 * @param {Boolean} o.prependingReturn=0 prepends `return` statement before source code
 * @param {Boolean} o.fallingBack=1 tries to make routine without `return` prefix if first attempt with `o.prependingReturn:1` fails.
 * @param {Boolean} o.usingStrict=0 enables strict mode
 * @param {Object} o.externals=null map with external properties that are needed for routine
 * @param {String} o.name=null name of the routine
 * @param {Object} o.context=null executes routine with provided context
 *
 * @example
 * let src = 'return 1'
 * let r = _.routineExec( src );
 * console.log( r.result ); //1
 *
 * @example //execute with custom context
 * let src = 'return this.a'
 * let r = _.routineExec({ code : src, context : { a : 1 } });
 * console.log( r.result ); //1
 *
 * @returns {Object} Returns options map with result of execution in `result` property.
 * @function routineExec
 * @namespace Tools.program
 */

function routineExec( o )
{
  let result = Object.create( null );

  if( _.strIs( o ) )
  o = { code : o };
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( routineExec, o );

  o.routine = _.routineMake
  ({
    code : o.code,
    debug : o.debug,
    filePath : o.filePath,
    prependingReturn : o.prependingReturn,
    externals : o.externals,
  });

  /* */

  try
  {
    if( o.context )
    o.result = o.routine.apply( o.context );
    else
    o.result = o.routine.call( _global );
  }
  catch( err )
  {
    throw _._err
    ({
      args : [ err ],
      level : 1,
      sourceCode : { code : o.routine.toString() },
      throwLocation : { filePath : o.filePath },
    });
  }

  /* */

  return o;
}

var defaults = routineExec.defaults = Object.create( routineMake.defaults );

defaults.context = null;

//

/**
 * @summary Short-cut for {@link module:Tools/base/IntrospectorBasic.IntrospectorBasic.routineExec} routine.
 * Returns result of routine execution instead of options map.
 * @param {Object} o options map
 * @param {Boolean} o.debug=0 prepends `debugger` prefix
 * @param {String} o.code=null source code
 * @param {String} o.filePath=null path to source file, will be inserted as comment
 * @param {Boolean} o.prependingReturn=0 prepends `return` statement before source code
 * @param {Boolean} o.fallingBack=1 tries to make routine without `return` prefix if first attempt with `o.prependingReturn:1` fails.
 * @param {Boolean} o.usingStrict=0 enables strict mode
 * @param {Object} o.externals=null map with external properties that are needed for routine
 * @param {String} o.name=null name of the routine
 * @param {Object} o.context=null executes routine with provided context
 *
 * @example
 * let src = 'return 1'
 * let r = _.exec( src );
 * console.log( r); //1
 *
 * @example //execute with custom context
 * let src = 'return this.a'
 * let r = _.exec({ code : src, context : { a : 1 } });
 * console.log( r ); //1
 *
 * @returns {} Returns result of routine execution.
 * @function exec
 * @namespace Tools.program
 */

function exec( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( _.strIs( o ) )
  o = { code : o };
  _.routineExec( o );
  return o.result;
}

var defaults = exec.defaults = Object.create( routineExec.defaults );

//

function execInWorker( o )
{
  let result;

  if( _.strIs( o ) )
  o = { code : o };
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( execInWorker, o );

  let blob = new Blob( [ o.code ], { type : 'text/javascript' } );
  let worker = new Worker( URL.createObjectURL( blob ) );

  throw _.err( 'not implemented' );

}

execInWorker.defaults =
{
  code : null,
}

//

function makeWorker( o )
{
  let result;

  if( _.strIs( o ) )
  o = { code : o };
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( makeWorker, o );

  let blob = new Blob( [ o.code ], { type : 'text/javascript' } );
  let worker = new Worker( URL.createObjectURL( blob ) );

  return worker;
}

makeWorker.defaults =
{
  code : null,
}

// --
//
// --

function routineNew( routine, name, usingExtendtype )
{
  _.assert( _.routineIs( routine ), 'creating routine from string is not implemented' );

  if( usingExtendtype === undefined ) usingExtendtype = true;
  if( name === undefined ) name = '_noname_';

  let f = new Function( 'let _' + name + ' = arguments[ 0 ];\nreturn function ' + name + ' ()\n{\n  return ' + '_' + name + '(this, arguments) \n};' );
  let result = f( Function.prototype.apply.bind( routine ) );

  result._name = name;

  if( usingExtendtype )
  result.prototype = routine.prototype;

  return result;
}

//

function routineInfo( routine )
{

  _.assert( _.routineIs( routine ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = _routineInfo
  ({
    routine,
    tab : '',
  });

  return result;
}

//

function _routineInfo( o )
{
  let result = '';
  let assets = _.mapOnly_( null, o.routine, _routineAssets );

  result += o.routine.name || 'noname';
  result += '\n';
  result += _.entity.exportString( assets, { levels : 2, tab : o.tab, prependTab : 1, wrap : 0 });
  result += '\n----------------\n';

  o.tab += '  ';

  for( let i in o.routine.inline )
  {
    result += o.tab + i + ' : ';
    let opt = _.props.extend( null, o );
    o.routine = o.routine.inline[ i ];
    result += _routineInfo( o );
  }

  return result;
}

//

function routineCollectAssets( dst, routine )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.routineIs( routine ) );

  return _routineCollectAssets( dst, routine, [] );
}

//

function _routineCollectAssets( dst, routine, visited )
{

  _.assert( _.routineIs( routine ) );
  _.assert( visited.indexOf( routine ) === -1 );
  visited.push( routine );

  for( let a in _routineAssets )
  {

    if( !routine[ a ] )
    continue;

    dst[ a ] = dst[ a ] || Object.create( null );
    _.map.assertHasNone( dst[ a ], routine[ a ] );
    dst[ a ] = _.mapsFlatten
    ({
      src : [ dst[ a ], routine[ a ] ],
      allowingCollision : 0,
    });

  }

  if( dst.inline )
  for( let i in dst.inline )
  {

    if( visited.indexOf( dst.inline[ i ] ) === -1 )
    _routineCollectAssets( dst, dst.inline[ i ], visited );

  }

}

//

_global_._routineIsolate = [];
function routineIsolate( o )
{

  if( _.routineIs( o ) )
  o = { routine : o };
  _.assert( o.routine );
  _.map.assertHasOnly( o, routineIsolate.defaults );

  let name = o.name || o.routine.name;
  _.assert( _.strIs( name ) && name.length );

  _.routineCollectAssets( o, o.routine );

  /* */

  let parsed;

  if( o.inline || o.routine.inline )
  {

    parsed = _.routineInline
    ({
      routine : o.routine,
      inline : o.inline,
    });

  }
  else
  {

    parsed = { source : o.routine.toString() };

  }

  /* */

  let sconstant = '';
  if( o.constant )
  for( let s in o.constant )
  {
    sconstant += 'const ' + s + ' = ' + _.entity.exportString( o.constant[ s ], { levels : 99, escaping : 1 } ) + ';\n';
  }

  /* */

  let sexternal = '';
  if( o.external )
  {

    let descriptor = Object.create( null );
    _routineIsolate.push( descriptor );
    descriptor.external = o.external;

    for( let s in o.external )
    {
      sexternal += 'const ' + s + ' = ' + '_routineIsolate[ ' + ( _routineIsolate.length-1 ) + ' ].external.' + s + '' + ';\n';
    }

  }

  /* */

  let source =
  sconstant + '\n'
  + sexternal + '\n'
  + ( o.debug ? 'debugger;\n' : '' )
  + 'return ( ' + parsed.source + ' );';

  let result = new Function
  (
    o.args || [],
    source
  )();

  result.inline = o.inline;
  result.external = o.external;
  result.constant = o.constant;

  return result;
}

routineIsolate.defaults =
{
  routine : null,
  constant : null,
  external : null,
  inline : null,
  debug : 0,
  name : null,
}

//

function routineInline( o )
{

  if( _.routineIs( o ) )
  o = { routine : o };
  _.assert( _.routineIs( o.routine ) );
  _.assert( arguments.length === 1 );
  _.routine.options_( routineInline, o );

  // if( _.routineIs( o ) )
  // o = { routine : o };
  // _.assert( o.routine );
  //
  // if( o.routine.debugParse )
  // debugger;

  let source = o.routine.toString();
  let result = Object.create( null );
  result.source = source;

  //

  if( o.routine.inline )
  {
    o.inline = o.inline || Object.create( null );
    _.map.assertHasNone( o.inline, o.routine.inline );
    o.inline = _.mapsFlatten
    ({
      src : [ o.inline, o.routine.inline ],
      allowingCollision : 0,
    });
  }

  //

  if( !o.inline || !Object.keys( o.inline ).length )
  return _.routineParse( o.routine );

  let inlined = 0;

  if( !inlines() )
  return _.routineParse( o.routine );

  if( !inlines() )
  return _.routineParse( o.routine );

  while( inlines() );

  return _.routineParse( o.routine );
  // return parse();

  // //
  //
  // function parse()
  // {
  //
  //   let r = /function\s+(\w*)\s*\(([^\)]*)\)(\s*{[^]*})$/;
  //
  //   let parsed = r.exec( source );
  //
  //   result.name = parsed[ 1 ];
  //   result.args = _.strSplitNonPreserving
  //   ({
  //     src : parsed[ 2 ],
  //     delimeter : ',',
  //     preservingDelimeters : 0,
  //   });
  //   result.body = parsed[ 3 ];
  //
  //   result.reproduceSource = function()
  //   {
  //     return 'function ' + result.name + '( ' + result.args.join( ', ' ) + ' )\n' + result.body;
  //   }
  //
  //   return result;
  // }

  //

  function inlineFull( ins, sub )
  {

    let regexp = new RegExp( '(((let\\s+)?(\\w+)\\s*=\\s*)?|(\\W))(' + ins + ')\\s*\\.call\\s*\\(([^)]*)\\)', 'gm' );
    let rreturn = /return(\s+([^;}]+))?([;}]?)/mg;
    result.source = result.source.replace( regexp, function( original )
    {

      _.assert( sub.name );

      /* let */

      let r = '';
      let variableName = arguments[ 4 ];
      let body = sub.body;

      /* args */

      let args = _.strSplitNonPreserving
      ({
        src : arguments[ 7 ],
        delimeter : ',',
        preservingDelimeters : 0,
      });

      _.assert( args.length - 1 === sub.args.length );

      let renamedArgs = _.strJoin([ '_' + sub.name + '_', sub.args, '_' ]);
      /*let renamedArgs = _.strStick( sub.args.slice(),'_' + sub.name + '_', '_' );*/
      body = _.strReplaceWords( body, sub.args, renamedArgs );

      for( let a = 0 ; a < renamedArgs.length ; a++ )
      {
        r += '  let ' + renamedArgs[ a ] + ' = ' + args[ a+1 ] + ';';
      }

      /* return */

      if( variableName )
      r += 'let ' + variableName + ';\n';

      body = body.replace( rreturn, function()
      {
        throw _.err( 'not tested' );

        let rep = '{ ';
        rep += variableName;
        rep += ' = ';
        rep += _.strStrip( arguments[ 2 ] || '' ) ? arguments[ 2 ] : 'undefined';
        rep += arguments[ 3 ];
        rep += ' }';
        return rep;
      });

      /* body */

      r += body;

      r = '\n/* _inlineFull_' + ins + '_ */\n{\n' + r + '\n}\n/* _inlineFull_' + ins + '_ */\n';

      /* validation */

      if( Config.debug )
      if( r.indexOf( 'return' ) !== -1 )
      {
        throw _.err( 'not expected' );
      }

      inlined += 1;

      return r;
    });

  }

  //

  function inlineCall( ins, sub )
  {

    let regexp = new RegExp( '(\\W)(' + ins + ')\\s*\\.', 'gm' );
    result.source = result.source.replace( regexp, function( b ) /* Yevhen : was : a, b, c, d, e, removed unused a, c, d, e */
    {
      inlined += 1;
      return b + '/* _inlineCall_' + ins + '_ */' + '( ' + sub.source + ' ).' + '/* _inlineCall_' + ins + '_ */';
    });

  }

  //

  function inlineRegular( ins, sub )
  {

    let regexp = new RegExp( '(\\W)(' + ins + ')(\\W)', 'gm' );
    result.source = result.source.replace( regexp, function( b, d ) /* Yevhen : was : a, b, c, d, e, removed unused a, c, e */
    {
      inlined += 1;
      return b + '/* _inlineRegular_' + ins + '_ */( ' + sub.source + ' )/* _inlineRegular_' + ins + '_ */' + d;
    });

  }

  //

  function inline( ins, sub )
  {

    inlined = 0;

    if( !_.routineIs( sub ) )
    throw _.err( 'not tested' );

    /*
        if( _.routineIs( sub ) )
        {
          sub = _.routineInline( sub );
        }
        else
        {
          let sub = { source : sub };
          throw _.err( 'not tested' );
        }
    */

    sub = _.routineInline( sub );

    let regexp = new RegExp( 'function\\s+' + ins + '\\s*\\(', 'gm' );
    sub.source = sub.source.replace( regexp, 'function _' + ins + '_(' );

    /**/

    let returnCount = _.strCount( sub.source, 'return' );
    if( returnCount === 0 && sub.body )
    {

      inlineFull( ins, sub );

    }

    inlineCall( ins, sub );
    inlineRegular( ins, sub );

    /**/

    return inlined;
  }

  //

  function inlines()
  {
    let r = 0;

    for( let i in o.inline )
    {
      r += inline( i, o.inline[ i ] );
    }

    return r;
  }

}

routineInline.defaults =
{
  routine : null,
  inline : null,
}

//

/**
 * @summary Gets information about routine( routine ).
 * Result contains such information:
 * * routine's name
 * * arguments
 * * full source code( including definition )
 * * routine's body( code inside square brackets )
 * @param {Function} routine source routine
 *
 * @returns {Object} Returns map with information about provided routine.
 * @function routineParse
 * @namespace Tools.program
 */

function routineParse( o )
{

  if( _.routineIs( o ) )
  o = { routine : o };
  _.assert( _.routineIs( o.routine ) );
  _.assert( arguments.length === 1 );
  _.routine.options_( routineParse, o );

  let source = o.routine.toString();
  let result = Object.create( null );
  result.source = source;

  return parse();

  /* */

  function parse()
  {

    let r = /function\s+(\w*)\s*\(([^\)]*)\)(\s*{[^]*})$/;
    let parsed = r.exec( source );

    result.name = parsed[ 1 ];
    result.args = _.strSplitNonPreserving
    ({
      src : parsed[ 2 ],
      delimeter : ',',
      preservingDelimeters : 0,
      preservingEmpty : 0,
      stripping : 1,
      quoting : 0,
    });
    result.body = parsed[ 3 ];
    result.bodyUnwrapped = _.strRemove( result.body, /(?:^\s*{)|(?:}\s*$)/g );

    result.reproduceSource = function()
    {
      return 'function ' + result.name + '( ' + result.args.join( ', ' ) + ' )\n' + result.body;
    }

    return result;
  }

}

routineParse.defaults =
{
  routine : null,
}

// --
// declare
// --

let _routineAssets =
{
  inline : 'inline',
  external : 'external',
  constant : 'constant',
}

// --
// tools extension
// --

let ToolsExtension =
{

  routineDelayed,

  routineCall,
  routineTolerantCall,

  routinesJoin,
  _routinesCall,
  routinesCall,
  routinesCallEvery,
  methodsCall,

  //

  routineSourceGet,

  routineMake, /* xxx : review */
  routineExec,

  exec,

  execInWorker,
  makeWorker,

  //

  routineNew,
  routineInfo,

  routineCollectAssets,
  _routineCollectAssets,
  routineIsolate,
  routineInline,

  routineParse,

  _routineAssets,

}

Object.assign( _, ToolsExtension );

})();

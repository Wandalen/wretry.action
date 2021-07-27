( function _l1_Introspector_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.introspector = _.introspector || Object.create( null );

// --
// relation
// --

let Location =
{
  original : null,
  filePath : null,
  routineName : null,
  routineAlias : null,
  internal : null,
  abstraction : null,
  line : null,
  col : null,
  filePathLineCol : null,
  routineFilePathLineCol : null,
  fileName : null,
  fileNameLineCol : null,
}

// --
// implementation
// --

/* qqq : for junior : write performance test for this
let basePath = _.path.dir( _.introspector.location({ level : 2 }).filePath )
qqq : make it super optimal
qqq : implement routine _.introspector.dirPathOf( 2 );
qqq : implement routine _.introspector.filePathOf( 2 );
dont forget about performance test and optimization
*/

function location( o )
{
  if( _.number.is( o ) )
  o = { level : o }
  else if( _.strIs( o ) )
  o = { stack : o, level : 0 }
  else if( _.error.is( o ) )
  o = { error : o, level : 0 }
  else if( o === undefined )
  o = { stack : _.introspector.stack([ 1, Infinity ]) };

  /* */

  if( location.defaults )
  for( let e in o )
  {
    if( location.defaults[ e ] === undefined )
    throw Error( 'Unknown option ' + e );
  }

  if( location.defaults )
  for( let e in location.defaults )
  {
    if( o[ e ] === undefined )
    o[ e ] = location.defaults[ e ];
  }

  if( !( arguments.length === 0 || arguments.length === 1 ) )
  throw Error( 'Expects single argument or none' );

  if( !_.mapIs( o ) )
  throw Error( 'Expects options map' );

  if( !o.level )
  o.level = 0;

  /* */

  if( !o.location )
  o.location = Object.create( null );

  /* */

  if( o.error )
  {
    let location2 = o.error.location || Object.create( null );

    var args0 =
    [
      location2.filePath,
      o.location.filePath,
      o.error.filename,
      o.error.fileName
    ];
    o.location.filePath = _.longLeftDefined( args0 ).element;

    var args1 =
    [
      location2.line,
      o.location.line,
      o.error.line,
      o.error.linenumber,
      o.error.lineNumber,
      o.error.lineNo,
      o.error.lineno
    ];
    o.location.line = _.longLeftDefined( args1 ).element;

    var args2 =
    [
      location2.col,
      o.location.col,
      o.error.col,
      o.error.colnumber,
      o.error.colNumber,
      o.error.colNo,
      o.error.colno
    ];
    o.location.col = _.longLeftDefined( args2 ).element;

  }

  /* */

  if( !o.stack )
  {
    if( o.error )
    {
      o.stack = _.introspector.stack( o.error, undefined );
    }
    else
    {
      o.stack = _.introspector.stack();
      o.level += 1;
    }
  }

  if( o.stack === null || o.stack === undefined )
  return o.location;

  _.assert( _.strIs( o.stack ) || _.arrayIs( o.stack ) );

  let stack = o.stack;
  if( _.strIs( stack ) )
  stack = stack.split( '\n' );
  let stackFrame = stack[ o.level ];

  return _.introspector.locationFromStackFrame({ stackFrame, location : o.location });
}

location.defaults =
{
  level : 0,
  stack : null,
  error : null,
  location : null,
}

//

function location_( o )
{

  if( _.number.is( o ) )
  o = { level : o }
  else if( _.strIs( o ) )
  o = { stack : o, level : 0 }
  else if( _.error.is( o ) )
  o = { error : o, level : 0 }
  else if( o === undefined )
  o = { stack : _.introspector.stack([ 1, Infinity ]) };

  /* */

  if( location_.defaults )
  for( let e in o )
  {
    if( location_.defaults[ e ] === undefined )
    throw Error( 'Unknown option ' + e );
  }

  if( location_.defaults )
  for( let e in location_.defaults )
  {
    if( o[ e ] === undefined )
    o[ e ] = location_.defaults[ e ];
  }

  if( !( arguments.length === 0 || arguments.length === 1 ) )
  throw Error( 'Expects single argument or none' );

  if( !_.mapIs( o ) )
  throw Error( 'Expects options map' );

  if( !o.level )
  o.level = 0;

  /* */

  if( !o.location )
  o.location = Object.create( null );

  /* */

  if( o.error )
  {
    let location2 = o.error.location || Object.create( null );

    var args0 =
    [
      location2.filePath,
      o.location.filePath,
      o.error.filename,
      o.error.fileName
    ];
    o.location.filePath = _.longLeftDefined( args0 ).element;

    var args1 =
    [
      location2.line,
      o.location.line,
      o.error.line,
      o.error.linenumber,
      o.error.lineNumber,
      o.error.lineNo,
      o.error.lineno
    ];
    o.location.line = _.longLeftDefined( args1 ).element;

    var args2 =
    [
      location2.col,
      o.location.col,
      o.error.col,
      o.error.colnumber,
      o.error.colNumber,
      o.error.colNo,
      o.error.colno
    ];
    o.location.col = _.longLeftDefined( args2 ).element;

  }

  /* */

  if( !o.stack )
  {
    if( o.error )
    {
      o.stack = _.introspector.stack( o.error, undefined );
    }
    else
    {
      o.stack = _.introspector.stack();
      o.level += 1;
    }
  }

  if( o.stack === null || o.stack === undefined )
  return o.location;

  _.assert( _.strIs( o.stack ) || _.arrayIs( o.stack ) );

  let stack = o.stack;
  if( _.strIs( stack ) )
  stack = stack.split( '\n' );
  let stackFrame = stack[ o.level ];

  // return _.introspector.locationFromStackFrame({ stackFrame, location : o.location });

  o.location.original = stackFrame;
  _.introspector.locationNormalize( o.location );
  return o.location;

}

location_.defaults =
{
  level : 0,
  stack : null,
  error : null,
  location : null,
}

//

function locationFromStackFrame( o )
{

  if( _.strIs( o ) )
  o = { stackFrame : o };

  if( !( arguments.length === 1 ) )
  throw Error( 'Expects single argument' );

  if( !_.mapIs( o ) )
  throw Error( 'Expects options map' );

  /* */

  if( locationFromStackFrame.defaults ) /* Dmytro : maybe it is the redundant condition, the routine has defaults */
  for( let e in o )
  {
    if( locationFromStackFrame.defaults[ e ] === undefined )
    throw Error( 'Unknown option : ' + e );
  }

  if( locationFromStackFrame.defaults ) /* Dmytro : maybe it is the redundant condition, the routine has defaults */
  for( let e in locationFromStackFrame.defaults )
  {
    if( o[ e ] === undefined )
    o[ e ] = locationFromStackFrame.defaults[ e ];
  }

  /* */

  if( !( _.strIs( o.stackFrame ) ) )
  throw Error( `Expects string {- stackFrame -}, but fot ${_.entity.strType( o.stackFrame )}` );

  if( o.location && !_.mapIs( o.location ) )
  throw Error( 'Expects map option::location' );

  /* */

  if( !o.location )
  o.location = Object.create( null );
  o.location.original = o.stackFrame;
  _.introspector.locationNormalize( o.location );
  return o.location;
}

locationFromStackFrame.defaults =
{
  stackFrame : null,
  location : null,
};

//

function locationNormalize( o )
{

  if( !( arguments.length === 1 ) )
  throw Error( 'Expects single argument' );

  if( !_.mapIs( o ) )
  throw Error( 'Expects options map' );

  /* */

  if( locationNormalize.defaults )
  for( let e in o )
  {
    if( locationNormalize.defaults[ e ] === undefined )
    throw Error( 'Unknown option ' + e );
  }

  if( locationNormalize.defaults )
  for( let e in locationNormalize.defaults )
  {
    if( o[ e ] === undefined )
    o[ e ] = locationNormalize.defaults[ e ];
  }

  /* */

  let hadPath = !!o.filePath;
  if( !o.filePath )
  o.filePath = pathFromStack();

  pathCanonize();
  routineFromStack();
  routineAliasFromStack();
  internalForm();
  abstractionForm();

  // if( !_.strIs( o.filePath ) )
  // return end();

  if( !_.number.defined( o.line ) || !_.number.defined( o.col ) )
  o.filePath = lineColFromPath( o.filePath );

  if( !_.number.is( o.line ) && hadPath )
  {
    let path = pathFromStack();
    if( path )
    lineColFromPath( path );
  }

  return end();

  /* */

  function end()
  {
    let path = o.filePath;

    /* filePathLineCol */

    o.filePathLineCol = path || '';
    if( _.number.defined( o.line ) )
    {
      o.filePathLineCol += ':' + o.line;
      if( _.number.defined( o.col ) )
      o.filePathLineCol += ':' + o.col;
    }

    /* routineFilePathLineCol */

    if( o.routineName )
    o.routineFilePathLineCol = o.routineName + ' @ ' + o.filePathLineCol;

    /* fileName */

    if( path )
    {
      let fileName = path;
      _.assert( _.routine.is( fileName.lastIndexOf ) );
      let i1 = fileName.lastIndexOf( '/' );
      let i2 = fileName.lastIndexOf( '\\' );
      let i = Math.max( i1, i2 );
      if( i !== -1 )
      fileName = fileName.substr( i+1 );
      o.fileName = fileName;
    }

    /* fileNameLineCol */

    o.fileNameLineCol = o.fileName || '';
    if( _.number.defined( o.line ) )
    {
      o.fileNameLineCol += ':' + o.line;
      if( _.number.defined( o.col ) )
      o.fileNameLineCol += ':' + o.col;
    }

    return o;
  }

  /* */

  function pathCanonize()
  {
    if( !o.filePath )
    return;

    if( _.path && _.path.canonize )
    o.filePath = _.path.canonize( o.filePath );
  }

  /* */

  function routineFromStack()
  {
    let routineName;

    if( o.routineName )
    return o.routineName;
    if( !o.original )
    return o.routineName;

    routineName = o.original;

    // if( !_.strIs( routineName ) ) // xxx /* Dmytro : deprecated comment, delete with label, please */
    // return '{-anonymous-}';
    if( !_.strIs( routineName ) ) // xxx /* Dmytro : deprecated comment, delete with label, please */
    {
      routineName = '{-anonymous-}';
    }
    else
    {
      routineName = routineName.replace( /at eval \(eval at/, '' );
      let t = /^\s*(?:at\s+)?([\w.<>]+)\s*.+/;
      let executed = t.exec( routineName );
      if( executed )
      routineName = executed[ 1 ] || '';

      routineName = routineName.replace( /<anonymous>/gm, '{-anonymous-}' );

      if( _.strEnds( routineName, '.' ) )
      routineName += '{-anonymous-}';
    }

    o.routineName = routineName;
    return o.routineName;
  }

  /* */

  function routineAliasFromStack()
  {
    let routineAlias;

    if( o.routineAlias )
    return o.routineAlias;
    if( !o.original )
    return o.routineAlias;

    routineAlias = null;

    let t = /\[as ([^\]]*)\]/;
    let executed = t.exec( o.original );
    if( executed )
    routineAlias = executed[ 1 ] || null;

    if( routineAlias )
    routineAlias = routineAlias.replace( /<anonymous>/gm, '{-anonymous-}' );

    o.routineAlias = routineAlias;
    return o.routineAlias;
  }

  /* */

  function internalForm()
  {

    if( _.number.defined( o.internal ) )
    return;

    o.internal = 0;

    if( o.filePath )
    {
      if( o.internal < 2 )
      if( _.strBegins( o.filePath, 'internal/' ) )
      o.internal = 2;

      if( o.internal < 2 )
      if( _.strBegins( o.filePath, 'node:internal/' ) )
      o.internal = 2;

    }

  }

  /* */

  function abstractionForm()
  {

    if( _.number.defined( o.abstraction ) )
    return;

    o.abstraction = 0;

    if( o.routineName )
    {
      if( o.abstraction < 2 )
      if( _.strBegins( o.routineName, '__' ) || o.routineName.indexOf( '.__' ) !== -1 )
      o.abstraction = 2;
      if( o.abstraction < 1 )
      if( _.strBegins( o.routineName, '_' ) || o.routineName.indexOf( '._' ) !== -1 )
      o.abstraction = 1;
    }

    if( o.routineAlias )
    {
      if( o.abstraction < 2 )
      if( _.strBegins( o.routineAlias, '__' ) || o.routineAlias.indexOf( '.__' ) !== -1 )
      o.abstraction = 2;
      if( o.abstraction < 1 )
      if( _.strBegins( o.routineAlias, '_' ) || o.routineAlias.indexOf( '._' ) !== -1 )
      o.abstraction = 1;
    }

  }

  /* */

  function pathFromStack()
  {
    let path = o.original;

    if( !_.strIs( path ) )
    return;

    path = path.replace( /^\s+/, '' );
    path = path.replace( /^\w+@/, '' );
    path = path.replace( /^at/, '' );
    path = path.replace( /^\s+/, '' );
    path = path.replace( /\s+$/, '' );

    let regexp = /^.*\(([^)]*)\).*$/;
    var parsed = regexp.exec( path );
    if( parsed )
    path = parsed[ 1 ];

    return path;
  }

  /* line / col number from path */

  function lineColFromPath( path )
  {
    if( !path )
    {
      if( o.line )
      o.line = numberFromToInt( o.line );
      if( o.col )
      o.col = numberFromToInt( o.col )
    }
    else
    {
      let lineNumber, colNumber;
      let postfix = /(.+?):(\d+)(?::(\d+))?[^:/]*$/;
      let parsed = postfix.exec( path );

      if( parsed )
      {
        path = parsed[ 1 ];
        lineNumber = parsed[ 2 ];
        colNumber = parsed[ 3 ];
      }

      lineNumber = numberFromToInt( lineNumber );
      colNumber = numberFromToInt( colNumber );

      if( !_.number.defined( o.line ) )
      if( _.number.defined( lineNumber ) )
      o.line = lineNumber;

      if( !_.number.defined( o.col ) )
      if( _.number.defined( colNumber ) )
      o.col = colNumber;
    }

    if( !_.number.defined( o.line ) )
    o.line = null;
    if( !_.number.defined( o.col ) )
    o.col = null;

    return path;
  }

  /* */

  function numberFromToInt( src )
  {
    if( _.strIs( src ) )
    src = parseInt( src );
    else
    src = Math.floor( Number( src ) );

    return src;
  }

}

locationNormalize.defaults =
{
  ... Location,
}

//

function locationToStack( o )
{
  if( !( arguments.length === 1 ) )
  throw Error( 'Expects single argument' );

  if( !_.mapIs( o ) )
  throw Error( 'Expects options map' );

  /* */

  // _.map.assertHasOnly( o, locationToStack.defaults );
  if( Config.debug )
  {
    let extraKeys = mapButKeys( o, locationToStack.defaults );
    _.assert( extraKeys.length === 0, () => `Routine "locationToStack" does not expect options: ${ keysQuote( extraKeys ) }` );
  }

  _.introspector.locationNormalize( o );

  if( !o.filePathLineCol )
  return null;

  // if( o.routineFilePathLineCol )
  // {
  //   _.assert( 0, 'not tested' );
  // }

  if( o.routineName )
  return `at ${o.routineName} (${o.filePathLineCol})`;
  else
  return `at (${o.filePathLineCol})`;

  /*
    at Object.locationToStack (http://127.0.0.1:5000//builder/include/wtools/abase/l0/l3/Introspector.s:723:10)
  */

  /* */

  function mapButKeys( srcMap, butMap )
  {
    let result = [];

    for( let s in srcMap )
    if( !( s in butMap ) )
    result.push( s );

    return result;
  }

  /* */

  function keysQuote( keys )
  {
    let result = `"${ keys[ 0 ] }"`;
    for( let i = 1 ; i < keys.length ; i++ )
    result += `, "${ keys[ i ] }"`;
    return result.trim();
  }
}

locationToStack.defaults =
{
  ... Location,
}

//

/**
 * Routine stack() returns stack trace from provided argument {-stack-} as a string. If {-stack-} is not provided,
 * then routine returns stack trace at a current position of code.
 *
 * @param { String|Array|Unroll|Error } stack - A stack to trace. If {-stack-} is not provided, then routine generates
 * stack trace at a current code position.
 * @param { Range } range - A range of lines selected from stack trace. If {-range-} is undefined, then routine returns
 * full stack trace. If range[ 0 ] < 0, then routine counts lines from the end of stack trace. If stack[ 1 ] < 0, then
 * routine counts end line from the end of stack trace.
 *
 * @example
 * let stack;
 * function function1()
 * {
 *   function2();
 * }
 *
 * function function2()
 * {
 *   function3();
 * }
 *
 * function function3()
 * {
 *   stack = _.introspector.stack();
 * }
 *
 * function1();
 * console.log( stack );
 * // log
 * //"  at function3 (<anonymous>:10:17)
 * //   at function2 (<anonymous>:6:2)
 * //   at function1 (<anonymous>:2:2)
 * //   at <anonymous>:1:1"
 *
 * @example
 * let stack;
 * function function1()
 * {
 *   function2();
 * }
 *
 * function function2()
 * {
 *   function3();
 * }
 *
 * function function3()
 * {
 *   stack = _.introspector.stack( [ 0, 1 ] );
 * }
 *
 * function1();
 * console.log( stack );
 * // log
 * //"  at function3 (<anonymous>:10:17)
 *
 * @returns { String } - Return stack trace from call point.
 * @function stack
 * @throws { Error } If arguments.length is more than two.
 * @throws { Error } If {-range-} is not a Range.
 * @namespace Tools
 * @module Tools/base/Fundamental
 */

function stack( stack, range )
{

  if( arguments.length === 1 )
  {
    if( !_.error.is( stack ) )
    if( !_.strIs( stack ) )
    {
      range = arguments[ 0 ];
      stack = undefined;
    }
  }

  if( stack === undefined || stack === null )
  {
    stack = new Error();
    if( range === undefined )
    {
      range = [ 1, Infinity ];
    }
    else
    {
      if( _.number.is( range[ 0 ] ) ) /* Dmytro : previous implementation affects range - not a number value + number => NaN, so assertion does not word properly */
      range[ 0 ] += 1;
      if( _.number.is( range[ 1 ] ) && range[ 1 ] >= 0 )
      range[ 1 ] += 1;
    }
  }

  if( range === undefined )
  range = [ 0, Infinity ];

  if( arguments.length !== 0 && arguments.length !== 1 && arguments.length !== 2 )
  {
    debugger;
    throw Error( 'stack : expects one or two or none arguments' );
  }

  if( !_.intervalIs( range ) )
  {
    debugger;
    throw Error( 'stack : expects range but, got ' + _.entity.strType( range ) );
  }

  let first = range[ 0 ];
  let last = range[ 1 ];

  // if( !_.number.is( first ) ) // Dmytro : it's unnecessary assertions, _.intervalIs checks number value in passed array
  // {
  //   debugger;
  //   throw Error( 'stack : expects number range[ 0 ], but got ' + _.entity.strType( first ) );
  // }
  //
  // if( !_.number.is( last ) )
  // {
  //   debugger;
  //   throw Error( 'stack : expects number range[ 0 ], but got ' + _.entity.strType( last ) );
  // }

  let errIs = 0;
  if( _.error.is( stack ) )
  {
    stack = _.error.originalStack( stack );
    errIs = 1;
  }

  if( !stack )
  return '';

  if( !_.arrayIs( stack ) && !_.strIs( stack ) )
  return;

  // if( !_.arrayIs( stack ) && !_.strIs( stack ) ) // Dmytro : previous condition is almost identical
  // {
  //   debugger;
  //   throw Error( 'stack expects array or string' );
  // }

  if( !_.arrayIs( stack ) )
  stack = stack.split( '\n' );

  // debugger;

  /* remove redundant lines */

  while( stack.length )
  {
    let splice = 0;
    splice |= ( _.strHas( stack[ 0 ], /(^| )at / ) === false && stack[ 0 ].indexOf( '@' ) === -1 );
    splice |= stack[ 0 ].indexOf( '(vm.js:' ) !== -1;
    splice |= stack[ 0 ].indexOf( '(module.js:' ) !== -1;
    splice |= stack[ 0 ].indexOf( '(internal/module.js:' ) !== -1;
    if( splice )
    stack.splice( 0, 1 );
    else break;
  }

  if( stack[ 0 ] )
  if( stack[ 0 ].indexOf( 'at ' ) === -1 && stack[ 0 ].indexOf( '@' ) === -1 ) // Dmytro : it's dubious - while loop removes all strings if stack[ 0 ] has not 'at ' or '@'
  {
    console.error( 'stack : failed to parse stack' );
    debugger;
  }

  stack = stack.map( ( line ) => line.trim() );
  stack = stack.filter( ( line ) => line );

  /* */

  first = first === undefined ? 0 : first;
  last = last === undefined ? stack.length : last;

  // if( _.number.is( first ) ) // Dmytro : first and last - is always some numbers, see above about assertions
  if( first < 0 )
  first = stack.length + first;

  // if( _.number.is( last ) )
  if( last < 0 )
  last = stack.length + last + 1;

  /* */

  if( first !== 0 || last !== stack.length )
  {
    stack = stack.slice( first || 0, last );
  }

  /* */

  stack = String( stack.join( '\n' ) );

  return stack;
}

//

function stackRelative( stack, delta )
{
  _.assert( delta === undefined || _.number.is( delta ) );
  _.assert( stack === undefined || stack === null || _.bool.is( stack ) || _.number.is( stack ) || _.strIs( stack ) );
  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );

  if( _.strIs( stack ) )
  return stack;
  if( stack === false )
  return '';

  if( stack === undefined || stack === null || stack === true )
  stack = 1;
  else if( _.number.is( stack ) )
  stack += 1;

  if( delta )
  stack += delta;
  if( _.number.is( stack ) )
  stack = _.introspector.stack([ stack, Infinity ]);

  _.assert( _.strIs( stack ) );

  return stack;
}

//

function stackRemoveLeft( stack, include, exclude )
{
  if( arguments.length !== 3 )
  throw Error( 'Expects three arguments' );
  if( !_.regexpIs( include ) && include !== null )
  throw Error( 'Expects regexp either null as the second argument' );
  if( !_.regexpIs( exclude ) && exclude !== null )
  throw Error( 'Expects regexp either null as the third argument' );

  if( !_.strIs( stack ) )
  return stack;

  stack = stack.split( '\n' );

  for( let s = stack.length-1 ; s >= 0 ; s-- )
  {
    let line = stack[ s ];
    if( include && include.test( line ) )
    {
      stack.splice( s, 1 );
      continue;
    }
    if( exclude && exclude.test( line ) )
    {
      stack.splice( s, 1 );
      continue;
    }
  }

  return stack.join( '\n' );
}

//

function stackCondense( stack )
{

  if( arguments.length !== 1 )
  throw Error( 'Expects single arguments' );

  if( !_.strIs( stack ) )
  {
    debugger;
    throw Error( 'Expects string' );
  }

  stack = stack.split( '\n' );

  for( let s = stack.length-1 ; s >= 0 ; s-- )
  {
    let line = stack[ s ];
    if( s > 0 )
    if( /(\W|^)__\w+/.test( line ) )
    {
      stack.splice( s, 1 );
      continue;
    }
    if( _.strHas( line, '.test.' ) )
    line += ' *';
    stack[ s ] = line;
  }

  return stack.join( '\n' );
}

//

function stackFilter( stack, onEach )
{
  let result = [];

  if( _.routine.is( stack ) )
  {
    onEach = stack;
    stack = undefined;
  }

  if( !_.strIs( stack ) )
  stack = _.introspector.stack( stack, undefined ); // Dmytro : missed second argument, which has influence on the result

  _.assert( _.strIs( stack ) );
  _.assert( _.routine.is( onEach ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  stack = stack.split( '\n' );

  stack.forEach( ( stackFrame, k ) =>
  {
    let location = _.introspector.locationFromStackFrame( stackFrame );
    let r = onEach( location, k );
    if( r === undefined )
    return;
    if( _.strIs( r ) )
    {
      result.push( r );
      return;
    }
    _.assert( _.object.isBasic( r ) );
    _.assert( _.strIs( r.original ) );
    result.push( r.original );
  });

  return result.join( '\n' );
}

//

function code()
{
  return undefined;
}

// --
//
// --

let Extnesion =
{

  Location,

  location,
  location_,
  locationFromStackFrame,
  locationNormalize, /* aaa for Dmytro : write good test */ /* Dmytro : covered */
  locationToStack,

  stack,
  stackRelative,
  stackRemoveLeft,
  stackCondense,
  stackFilter,

  code,

}

//

Object.assign( _.introspector, Extnesion );

})();

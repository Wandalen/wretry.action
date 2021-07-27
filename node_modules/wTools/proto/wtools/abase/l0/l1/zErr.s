( function _l1_1Err_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _global_.wTools;

_.error = _.error || Object.create( null );

// --
// dichotomy
// --

function is( src )
{
  return src instanceof Error || Object.prototype.toString.call( src ) === '[object Error]';
}

//

function isFormed( src )
{
  if( !_.error.is( src ) )
  return false;
  return src.originalMessage !== undefined;
}

//

function isAttended( src )
{
  if( !_.error.is( src ) )
  return false;
  return !!src.attended;
}

//

function isLogged( src )
{
  if( _.error.is( src ) === false )
  return false;
  return !!src.logged;
}

//

function isSuspended( src )
{
  if( _.error.is( src ) === false )
  return false;
  return !!src.suspended;
}

//

function isWary( src )
{
  if( _.error.is( src ) === false )
  return false;
  return !!src.wary;
}

//

function isBrief( src )
{
  if( !_.error.is( src ) )
  return false;
  return !!src.brief;
}


// --
// generator
// --

function _sectionsJoin( o )
{
  o.message = o.message || '';

  // _.map.assertHasAll( o, _sectionsJoin.defaults );

  if( Config.debug )
  for( let k in _sectionsJoin.defaults )
  {
    if( o[ k ] === undefined )
    throw Error( `Expects defined option::${k}` );
  }

  for( let s in o.sections )
  {
    let section = o.sections[ s ];
    let head = section.head || '';
    let body = strLinesIndentation( section.body, '    ' );
    if( !body.trim().length )
    continue;
    o.message += ` = ${head}\n${body}\n\n`;
  }

  return o.message;

  function strLinesIndentation( str, indentation )
  {
    if( _.strLinesIndentation )
    return indentation + _.strLinesIndentation( str, indentation );
    else
    return str;
  }

}

_sectionsJoin.defaults =
{
  sections : null,
  message : '',
}

//

function _messageForm( o )
{

  o.message = o.message || '';

  if( !_.strIs( o.originalMessage ) )
  throw 'Expects string {- o.originalMessage -}';

  // _.map.assertHasAll( o, _messageForm.defaults );

  if( Config.debug )
  for( let k in _messageForm.defaults )
  {
    if( o[ k ] === undefined )
    throw Error( `Expects defined option::${k}` );
  }

  if( o.brief )
  {
    o.message += o.originalMessage;
  }
  else
  {
    o.message = _.error._sectionsJoin( o );
  }

  if( o.error )
  nonenumerable( 'message', o.message );

  return o.message;

  /* */

  function nonenumerable( propName, value )
  {
    try
    {
      let o2 =
      {
        enumerable : false,
        configurable : true,
        writable : true,
        value,
      };
      Object.defineProperty( o.error, propName, o2 );
    }
    catch( err2 )
    {
      console.error( err2 );
    }
  }

}

_messageForm.defaults =
{
  error : null,
  sections : null,
  brief : false,
  message : '',
}

//

/* qqq : cover please */
function sectionRemove( error, name )
{

  _.assert( arguments.length === 2 );
  _.assert( !!error );
  _.assert( _.strDefined( name ) );

  if( !_.error.isFormed( error ) )
  error = _.err( error );

  delete eror.sections[ name ];

  let o2 = Object.create( null );
  o2.error = error;
  o2.sections = error.sections;
  o2.brief = error.brief;
  o2.message = '';
  o2.originalMessage = error.originalMessage;
  _.error._messageForm( o2 );

  return error;
}

//

function sectionAdd( o )
{

  if( arguments.length === 2 )
  {
    o = arguments[ 1 ];
    o.error = arguments[ 0 ];
  }

  _.routine.options( sectionAdd, o ); /* qqq : eliminate such routines here */
  if( o.head === null )
  o.head = o.name.substring( 0, 1 ).toUpperCase() + o.name.substring( 1 );

  _.assert( _.strDefined( o.name ) ); /* qqq : eliminate such routines here */
  _.assert( _.strDefined( o.head ) );
  _.assert( _.strDefined( o.body ) );
  _.assert( !!o.error );

  if( !_.error.isFormed( o.error ) )
  {
    o.error = _._err({ args : [ o.error ], sections : { [ o.name ] : { head : o.head, body : o.body } } });
    return o.error;
  }

  o.sections = o.error.sections;
  _.error._sectionAdd( o );

  o.brief = o.error.brief;
  o.message = '';
  o.originalMessage = o.error.originalMessage;
  _.error._messageForm( o );

  return o.error;
}

sectionAdd.defaults =
{
  error : null,
  name : null,
  head : null,
  body : null,
}

//

function _sectionAdd( o )
{

  if( Config.debug )
  for( let k in _sectionAdd.defaults )
  {
    if( o[ k ] === undefined )
    throw Error( `Expects defined option::${k}` );
  }

  let section = Object.create( null );
  section.name = o.name;
  section.head = o.head;
  section.body = o.body;
  o.sections[ o.name ] = section;
  return section;
}

_sectionAdd.defaults =
{
  sections : null,
  name : null,
  head : null,
  body : null,
}

//

function _sectionExposedAdd( o )
{
  const exportString = _.entity.exportString ? _.entity.exportString.bind( _.entity ) : String;

  if( Config.debug )
  for( let k in _sectionExposedAdd.defaults )
  {
    if( o[ k ] === undefined )
    throw Error( `Expects defined option::${k}` );
  }

  let i = 0;
  let body = '';
  for( let k in o.exposed )
  {
    if( i > 0 )
    body += `\n`;
    body += `${k} : ${exportString( o.exposed[ k ] )}`;
    i += 1;
  }

  _.error._sectionAdd
  ({
    sections : o.sections,
    name : 'exposed',
    head : 'Exposed',
    body,
  });
}

_sectionExposedAdd.defaults =
{
  sections : null,
  exposed : null,
}

//

function exposedSet( args, props )
{

  _.assert( arguments.length === 2 );
  _.assert( _.mapIs( props ) )

  if( !_.longIs( args ) )
  args = [ args ];

  let err = args[ 0 ];

  if( _.symbol.is( err ) )
  {
    _.assert( args.length === 1 );
    return err;
  }

  if( args.length !== 1 || !_.error.isFormed( err ) )
  err = _._err
  ({
    args,
    level : 2,
  });

  /* */

  try
  {

    for( let f in props )
    {
      err[ f ] = props[ f ];
    }

  }
  catch( err )
  {
    if( Config.debug )
    console.error( `Cant assign "${f}" property to error\n${err.toString()}` );
  }

  /* */

  return err;
}

//

function concealedSet( args, props )
{

  _.assert( arguments.length === 2 );
  _.assert( _.mapIs( props ) )

  if( !_.longIs( args ) )
  args = [ args ];

  let err = args[ 0 ];

  if( _.symbol.is( err ) )
  {
    _.assert( args.length === 1 );
    return err;
  }

  if( args.length !== 1 || !_.error.isFormed( err ) )
  err = _._err
  ({
    args,
    level : 2,
  });

  /* */

  try
  {

    for( let f in props )
    {
      let o =
      {
        enumerable : false,
        configurable : true,
        writable : true,
        value : props[ f ],
      };
      Object.defineProperty( err, f, o );
    }

  }
  catch( err )
  {
    if( Config.debug )
    console.error( `Cant assign "${f}" property to error\n${err.toString()}` );
  }

  /* */

  return err;
}

//

function _inStr( errStr )
{
  _.assert( _.strIs( errStr ) );

  if( !_.strHas( errStr, /\=\s+Message of/m ) )
  return false;

  if( !_.strHas( errStr, /(^|\n)\s*=\s+Beautified calls stack/m ) )
  return false;

  return true;
}

// --
// introductor
// --

function _make( o )
{
  const logger = _global_.logger || _global_.console;

  if( arguments.length !== 1 )
  throw Error( 'Expects single argument : options map' );

  if( !_.mapIs( o ) )
  throw Error( 'Expects single argument : options map' );

  for( let k in o )
  {
    if( _make.defaults[ k ] === undefined )
    throw Error( `Unknown option::${k}` );
  }

  for( let k in _.error._make.defaults )
  {
    if( o[ k ] === undefined )
    o[ k ] = _.error._make.defaults[ k ];
  }

  if( !_.error.is( o.error ) )
  throw Error( 'Expects option.error:Error' );

  if( !_.strIs( o.originalMessage ) )
  throw Error( 'Expects option.originalMessage:String' );

  if( !_.strIs( o.combinedStack ) )
  throw Error( 'Expects option.combinedStack:String' );

  if( !_.strIs( o.throwCallsStack ) )
  throw Error( 'Expects option.throwCallsStack:String' );

  if( !_.strIs( o.throwsStack ) )
  throw Error( 'Expects option.throwsStack:String' );

  if( !o.throwLocation )
  throw Error( 'Expects option.throwLocation:Location' );

  attributesForm();
  exposedForm();
  sectionsForm();
  _.error._messageForm( o );
  form();

  return o.error;

  /* */

  function attributesForm()
  {

    if( o.attended === null || o.attended === undefined )
    o.attended = o.error.attended;
    o.attended = !!o.attended;

    if( o.logged === null || o.logged === undefined )
    o.logged = o.error.logged;
    o.logged = !!o.logged;

    if( o.brief === null || o.brief === undefined )
    o.brief = o.error.brief;
    o.brief = !!o.brief;

    if( o.reason === null || o.reason === undefined )
    o.reason = o.error.reason;

    o.sections = o.sections || Object.create( null );
    if( o.error.section )
    _.props.supplement( o.sections, o.error.section );

    o.id = o.error.id;
    if( !o.id )
    {
      _.error._errorCounter += 1;
      o.id = _.error._errorCounter;
    }

  }

  /* */

  function exposedForm()
  {
    var has = false;
    for( let k in o.error )
    {
      has = true;
      break;
    }
    if( has )
    {
      if( o.exposed )
      {
        for( let k in o.error )
        if( !Reflect.has( o.exposed, k ) )
        o.exposed[ k ] = o.error[ k ];
      }
      else
      {
        o.exposed = Object.create( null );
        for( let k in o.error )
        o.exposed[ k ] = o.error[ k ];
      }
    }
  }

  /* */

  function sectionsForm()
  {
    let result = '';

    // sectionAdd( 'message', `Message of Error#${o.id}`, o.originalMessage );
    sectionAdd( 'message', `Message of ${o.error.name || 'error'}#${o.id}`, o.originalMessage );
    sectionAdd( 'combinedStack', o.stackCondensing ? 'Beautified calls stack' : 'Calls stack', o.combinedStack );
    sectionAdd( 'throwsStack', `Throws stack`, o.throwsStack );

    /* xxx : postpone */
    if( o.sourceCode )
    if( _.strIs( o.sourceCode ) )
    sectionAdd( 'sourceCode', `Source code`, o.sourceCode );
    else if( _.routine.is( o.sourceCode.read ) )
    sectionAdd( 'sourceCode', `Source code from ${o.sourceCode.path}`, o.sourceCode.read );
    else if( _.strIs( o.sourceCode.code ) )
    sectionAdd( 'sourceCode', `Source code from ${o.sourceCode.path}`, o.sourceCode.code );
    else
    console.error( 'Unknown format of {- o.sourceCode -}' );

    if( o.exposed && Object.keys( o.exposed ).length > 0 )
    _.error._sectionExposedAdd( o );

    for( let s in o.sections )
    {
      let section = o.sections[ s ];
      if( !_.strIs( section.head ) )
      {
        logger.error
        (
          `Each section of an error should have head, but head of section::${s} is ${_.entity.strType(section.head)}`
        );
        delete o.sections[ s ];
      }
      if( !_.strIs( section.body ) )
      {
        logger.error
        (
          `Each section of an error should have body, but body of section::${s} is ${_.entity.strType(section.body)}`
        );
        delete o.sections[ s ];
      }
    }

    return result;
  }

  /* */

  function sectionAdd( name, head, body )
  {
    _.error._sectionAdd({ name, head, body, sections : o.sections });
  }

  /* */

  function form()
  {

    nonenumerable( 'originalMessage', o.originalMessage );
    logging( 'stack' );
    nonenumerable( 'reason', o.reason );

    nonenumerable( 'combinedStack', o.combinedStack );
    nonenumerable( 'throwCallsStack', o.throwCallsStack );
    nonenumerable( 'asyncCallsStack', o.asyncCallsStack );
    nonenumerable( 'throwsStack', o.throwsStack );
    nonenumerable( 'catchCounter', o.error.catchCounter ? o.error.catchCounter+1 : 1 );

    nonenumerable( 'attended', o.attended );
    nonenumerable( 'logged', o.logged );
    nonenumerable( 'brief', o.brief );

    if( o.throwLocation.line !== undefined )
    nonenumerable( 'lineNumber', o.throwLocation.line );
    if( o.error.throwLocation === undefined )
    nonenumerable( 'location', o.throwLocation );
    nonenumerable( 'sourceCode', o.sourceCode || null );
    nonenumerable( 'id', o.id );

    nonenumerable( 'toString', function() { return this.stack } );
    nonenumerable( 'sections', o.sections );

    getter( 'name', function() { return this.constructor.name } );

    o.error[ Symbol.for( 'nodejs.util.inspect.custom' ) ] = o.error.toString;

    if( o.concealed )
    {
      for( let k in o.concealed )
      nonenumerable( k, o.concealed[ k ] );
    }

  }

  /* */

  function nonenumerable( propName, value )
  {
    try
    {
      let o2 =
      {
        enumerable : false,
        configurable : true,
        writable : true,
        value,
      };
      Object.defineProperty( o.error, propName, o2 );
    }
    catch( err2 )
    {
      console.error( err2 );
    }
  }

  /* */

  function getter( propName, get )
  {
    try
    {
      let o2 =
      {
        enumerable : false,
        configurable : true,
        get,
      };
      Object.defineProperty( o.error, propName, o2 );
    }
    catch( err2 )
    {
      console.error( err2 );
    }
  }

  /* */

  function logging( propName )
  {
    try
    {
      let o2 =
      {
        enumerable : false,
        configurable : true,
        get,
        set,
      };
      Object.defineProperty( o.error, propName, o2 );
    }
    catch( err2 )
    {
      console.error( err2 );
    }
    function get()
    {
      /*
      workaround to avoid Njs issue: Njs stingify inherited error
      */
      /* zzz : qqq : find better solution */
      if( ( new Error().stack ).split( '\n' ).length !== 3 )
      {
        _.error.logged( this );
        _.error.attend( this );
      }
      return this.message;
    }
    function set( src )
    {
      this.message = src;
      return src;
    }
  }

}

_make.defaults =
{

  error : null,
  id : null,
  throwLocation : null,
  sections : null, /* qqq : cover please */
  concealed : null, /* qqq : cover please */
  exposed : null,

  attended : null,
  logged : null,
  brief : null,
  stackCondensing : null,

  originalMessage : null,
  combinedStack : '',
  throwCallsStack : '',
  throwsStack : '',
  asyncCallsStack : '',
  sourceCode : null,
  reason : null,

}

//

/**
 * Creates Error object based on passed options.
 * Result error contains in message detailed stack trace and error description.
 * @param {Object} o Options for creating error.
 * @param {String[]|Error[]} o.args array with messages or errors objects, from which will be created Error obj.
 * @param {number} [o.level] using for specifying in error message on which level of stack trace was caught error.
 * @returns {Error} Result Error. If in `o.args` passed Error object, result will be reference to it.
 * @private
 * @throws {Error} Expects single argument if pass les or more than one argument
 * @throws {Error} o.args should be array like, if o.args is not array.
 * @function _err
 * @namespace Tools
 */

function _err( o )
{
  const exportString = _.entity.exportString ? _.entity.exportString.bind( _.entity ) : String;
  let error;

  if( arguments.length !== 1 )
  throw Error( '_err : Expects single argument : options map' );

  if( !_.mapIs( o ) )
  throw Error( '_err : Expects single argument : options map' );

  if( !_.longIs( o.args ) )
  throw Error( '_err : Expects Long option::args' );

  for( let e in o )
  {
    if( _err.defaults[ e ] === undefined )
    {
      debugger;
      throw Error( `Unknown option::${e}` );
    }
  }

  for( let e in _err.defaults )
  {
    if( o[ e ] === undefined )
    o[ e ] = _err.defaults[ e ];
  }

  if( _.error._errorMaking )
  {
    throw Error( 'Recursive dead lock because of error inside of routine _err()!' );
  }
  _.error._errorMaking = true;

  if( o.level === undefined || o.level === null )
  o.level = null;

  /* let */

  if( !o.message )
  o.message = '';
  let fallBackMessage = '';
  let errors = [];
  let combinedStack = '';

  /* algorithm */

  try
  {

    argumentsPreprocessArguments();
    argumentsPreprocessErrors();
    locationForm();
    stackAndErrorForm();
    attributesForm();
    catchesForm();
    sourceCodeForm();
    originalMessageForm();

    error = _.error._make
    ({
      error,
      throwLocation : o.throwLocation,
      sections : o.sections,
      concealed : o.concealed,
      exposed : o.exposed,

      attended : o.attended,
      logged : o.logged,
      brief : o.brief,
      stackCondensing : o.stackCondensing,

      originalMessage : o.message,
      combinedStack,
      throwCallsStack : o.throwCallsStack,
      throwsStack : o.throwsStack,
      asyncCallsStack : o.asyncCallsStack,
      sourceCode : o.sourceCode,
      reason : o.reason,
    });

  }
  catch( err2 )
  {
    _.error._errorMaking = false;
    console.log( err2.message );
    console.log( err2.stack );
  }
  _.error._errorMaking = false;

  return error;

  /* */

  function argumentsPreprocessArguments()
  {

    for( let a = 0 ; a < o.args.length ; a++ )
    {
      let arg = o.args[ a ];

      if( !_.error.is( arg ) && _.routine.is( arg ) )
      {
        if( arg.length === 0 )
        {
          try
          {
            arg = o.args[ a ] = arg();
          }
          catch( err )
          {
            let original = arg;
            arg = o.args[ a ] = 'Error throwen by callback for formatting of error string';
            console.error( String( err ) );
            if( _.strLinesSelect ) /* aaa : for Dmytro : make sure it works and cover */ /* Dmytro : works, covered. Test routine `_errWithArgsIncludedRoutine` */
            console.error( _.strLinesSelect
            ({
              src : original.toString(),
              line : 0,
              nearestLines : 5,
              numbering : 1,
            }));
            else
            console.error( original.toString() );
          }
        }
        if( _.unrollIs( arg ) )
        {
          debugger;
          o.args = [ ... Array.prototype.slice.call( o.args, 0, a ), ... arg, ... Array.prototype.slice.call( o.args, a+1, o.args.length ) ];
          // o.args = _.longBut_( null, o.args, [ a, a ], arg );
          // o.args = _.longBut( o.args, [ a, a+1 ], arg );
          a -= 1;
          continue;
        }
      }

    }

  }

  /* */

  function argumentsPreprocessErrors()
  {

    for( let a = 0 ; a < o.args.length ; a++ )
    {
      let arg = o.args[ a ];

      if( _.error.is( arg ) )
      {

        errProcess( arg );
        o.args[ a ] = _.error.originalMessage( arg )

      }
      else if( _.strIs( arg ) && _.error._inStr( arg ) )
      {

        let err = _.error.fromStr( arg );
        errProcess( err );
        o.args[ a ] = _.error.originalMessage( err );

      }

    }

  }

  /* */

  function errProcess( arg )
  {

    if( !error )
    {
      error = arg;
      if( !o.sourceCode )
      o.sourceCode = arg.sourceCode || null;
      if( o.attended === null )
      o.attended = arg.attended || false;
      if( o.logged === null )
      o.logged = arg.logged || false;
    }

    if( arg.throwCallsStack )
    if( !o.throwCallsStack )
    o.throwCallsStack = arg.throwCallsStack;

    // if( arg.asyncCallsStack )
    // if( !o.asyncCallsStack )
    // o.asyncCallsStack = arg.asyncCallsStack;

    if( arg.throwsStack )
    if( o.throwsStack )
    o.throwsStack += '\n' + arg.throwsStack;
    else
    o.throwsStack = arg.throwsStack;

    if( arg.constructor )
    fallBackMessage = fallBackMessage || arg.constructor.name;
    errors.push( arg );

  }

  /* */

  function locationForm()
  {

    if( !error )
    for( let a = 0 ; a < o.args.length ; a++ )
    {
      let arg = o.args[ a ];
      if( !_.primitive.is( arg ) && _.object.like( arg ) )
      try
      {
        o.throwLocation = _.introspector.location
        ({
          error : arg,
          location : o.throwLocation,
        });
      }
      catch( err2 )
      {
        console.error( err2 );
      }
    }

    o.throwLocation = o.throwLocation || Object.create( null );
    o.catchLocation = o.catchLocation || Object.create( null );

  }

  /* */

  function stackAndErrorForm()
  {

    if( error )
    {

      /* qqq : cover each if-branch. ask how to. *difficult problem* */

      if( !o.throwCallsStack )
      if( o.throwLocation )
      o.throwCallsStack = _.introspector.locationToStack( o.throwLocation );
      if( !o.throwCallsStack )
      o.throwCallsStack = _.error.originalStack( error );
      if( !o.throwCallsStack )
      o.throwCallsStack = _.introspector.stack([ ( o.level || 0 ) + 1, Infinity ]);

      if( !o.catchCallsStack && o.catchLocation )
      o.catchCallsStack = _.introspector.locationToStack( o.catchLocation );
      if( !o.catchCallsStack )
      o.catchCallsStack = _.introspector.stack( o.catchCallsStack, [ ( o.level || 0 ) + 1, Infinity ] );

      if( !o.throwCallsStack && o.catchCallsStack )
      o.throwCallsStack = o.catchCallsStack;
      if( !o.throwCallsStack )
      o.throwCallsStack = _.introspector.stack( error, [ ( o.level || 0 ) + 1, Infinity ] );

      o.level = 0;

    }
    else
    {

      error = new Error( o.message + '\n' );
      if( o.throwCallsStack )
      {
        error.stack = o.throwCallsStack;
        o.catchCallsStack = _.introspector.stack( o.catchCallsStack, [ o.level + 1, Infinity ] );
        o.level = 0;
      }
      else
      {
        if( o.catchCallsStack )
        {
          o.throwCallsStack = error.stack = o.catchCallsStack;
        }
        else
        {
          if( o.level === undefined || o.level === null )
          o.level = 1;
          o.level += 1;
          o.throwCallsStack = error.stack = _.introspector.stack( error.stack, [ o.level, Infinity ] );
        }
        o.level = 0;
        if( !o.catchCallsStack )
        o.catchCallsStack = o.throwCallsStack;
      }

    }

    _.assert( o.level === 0 );

    if( ( o.stackRemovingBeginIncluding || o.stackRemovingBeginExcluding ) && o.throwCallsStack )
    o.throwCallsStack = _.introspector.stackRemoveLeft
    (
      o.throwCallsStack, o.stackRemovingBeginIncluding || null, o.stackRemovingBeginExcluding || null
    );

    if( !o.throwCallsStack )
    o.throwCallsStack = error.stack = o.fallBackStack;

    combinedStack = o.throwCallsStack;

    _.assert
    (
      error.asyncCallsStack === undefined
      || error.asyncCallsStack === null
      || error.asyncCallsStack === ''
      || _.arrayIs( error.asyncCallsStack )
    );
    if( error.asyncCallsStack && error.asyncCallsStack.length )
    {
      o.asyncCallsStack = o.asyncCallsStack || [];
      o.asyncCallsStack.push( ... error.asyncCallsStack );
      // _.arrayAppendArray( o.asyncCallsStack, error.asyncCallsStack );
    }

    if( o.asyncCallsStack === null || o.asyncCallsStack === undefined )
    if( _.Procedure && _.Procedure.ActiveProcedure )
    o.asyncCallsStack = [ _.Procedure.ActiveProcedure.stack() ];

    _.assert( o.asyncCallsStack === null || _.arrayIs( o.asyncCallsStack ) );
    if( o.asyncCallsStack && o.asyncCallsStack.length )
    {
      combinedStack += '\n\n' + o.asyncCallsStack.join( '\n\n' );
    }

    _.assert( _.strIs( combinedStack ) );
    if( o.stackCondensing )
    combinedStack = _.introspector.stackCondense( combinedStack );

  }

  /* */

  function attributesForm()
  {

    try
    {
      o.catchLocation = _.introspector.location
      ({
        stack : o.catchCallsStack,
        location : o.catchLocation,
      });
    }
    catch( err2 )
    {
      console.error( err2 );
    }

    try
    {
      o.throwLocation = _.introspector.location
      ({
        error : error,
        stack : o.throwCallsStack,
        location : o.throwLocation,
      });
    }
    catch( err2 )
    {
      console.error( err2 );
    }

  }

  /* */

  function catchesForm()
  {

    if( o.throws )
    {
      _.assert( _.arrayIs( o.throws ) );
      o.throws.forEach( ( c ) =>
      {
        c = _.introspector.locationFromStackFrame( c ).routineFilePathLineCol;
        if( o.throwsStack )
        o.throwsStack += `\nthrown at ${c}`;
        else
        o.throwsStack = `thrown at ${c}`;
      });
    }

    _.assert( _.number.is( o.catchLocation.abstraction ) );
    if( !o.catchLocation.abstraction || o.catchLocation.abstraction === 1 )
    {
      if( o.throwsStack )
      o.throwsStack += `\nthrown at ${o.catchLocation.routineFilePathLineCol}`;
      else
      o.throwsStack = `thrown at ${o.catchLocation.routineFilePathLineCol}`;
    }

  }

  /* */

  function sourceCodeForm()
  {

    if( !o.usingSourceCode )
    return;

    if( o.sourceCode )
    return;

    if( error.sourceCode === undefined )
    {
      let c = _.introspector.code
      ({
        location : o.throwLocation,
        sourceCode : o.sourceCode,
        asMap : 1,
      });
      if( c && c.code && c.code.length < 400 )
      {
        o.sourceCode = c;
      }
    }

  }

  /* */

  function originalMessageForm()
  {
    let result = [];

    if( o.message )
    return;

    for( let a = 0 ; a < o.args.length ; a++ )
    {
      let arg = o.args[ a ];
      let str;

      if( arg && !_.primitive.is( arg ) )
      {

        if( _.routine.is( arg.toStr ) )
        {
          str = arg.toStr();
        }
        else if( _.error.is( arg ) && _.strIs( arg.originalMessage ) )
        {
          str = arg.originalMessage;
        }
        else if( _.error.is( arg ) )
        {
          if( _.strIs( arg.message ) )
          str = arg.message;
          else
          str = exportString( arg );
        }
        else
        {
          str = exportString( arg, { levels : 2 } );
        }
      }
      else if( arg === undefined )
      {
        str = '\n' + String( arg ) + '\n';
      }
      else
      {
        str = String( arg );
      }

      result[ a ] = str;

    }

    let o2 =
    {
      onToStr : eachMessageFormat,
      onPairWithDelimeter : strConcatenateCounting
    };
    o.message = _.strConcat( result, o2 );

    /*
      remove redundant spaces at the begin and the end of lines
    */

    o.message = o.message || fallBackMessage || 'UnknownError';
    o.message = o.message.replace( /^\s*/, '' );
    o.message = o.message.replace( /\x20*$/gm, '' );
    o.message = o.message.replace( /\s*$/, '' );

  }

  /* */

  function eachMessageFormat( str )
  {
    let strBeginsWithRegular = _.strBegins( str, /\S/ );
    let strEndsWithRegular = _.strEnds( str, /\S/ );

    if( !strBeginsWithRegular )
    {
      let notSpaceLikeSymbol = /\S/.exec( str );

      if( notSpaceLikeSymbol === null )
      {
        str = str.replace( /\x20+/g, '' );
        strEndsWithRegular = true;
      }
      else
      {
        let before = str.substring( 0, notSpaceLikeSymbol.index );
        let spaces = /(?<=\n)\x20+$/.exec( before );
        before = before.replace( /\x20+/g, '' );
        before += spaces ? spaces[ 0 ] : '';

        str = before + str.substring( notSpaceLikeSymbol.index );
      }
    }

    if( str && !strEndsWithRegular )
    {
      let notSpaceLikeSymbol = /\S\s*$/.exec( str );

      let after = str.substring( notSpaceLikeSymbol.index + 1 );
      let spaces = /^\x20+(?=\n)/.exec( after );
      after = after.replace( /\x20+/g, '' );
      after += spaces ? spaces[ 0 ] : '';

      str = str.substring( 0, notSpaceLikeSymbol.index + 1 ) + after;
    }

    return str;
  }

  /* */

  function strConcatenateCounting( src1, src2 )
  {
    let result;
    if( _.strEnds( src1, '\n' ) && _.strBegins( src2, '\n' ) )
    {
      let right = /\n+$/.exec( src1 );
      let left = /^\n+/.exec( src2 );

      result = src1.substring( 0, right.index );
      result += right[ 0 ].length > left[ 0 ].length ? right[ 0 ] : left[ 0 ];
      result += src2.substring( left[ 0 ].length );
    }
    else
    {
      result = src1 + src2;
    }
    return result;
  }
}

_err.defaults =
{

  /**/

  args : null,
  sections : null,
  concealed : null,
  exposed : null,
  level : 1, /* to make catch stack work properly level should be 1 by default */

  /* String */

  message : null, /* qqq : cover the option */
  reason : null,
  sourceCode : null,

  /* Boolean */

  stackRemovingBeginIncluding : 0,
  stackRemovingBeginExcluding : 0,
  usingSourceCode : 1,
  stackCondensing : 1,
  attended : null,
  logged : null,
  brief : null,

  /* Location */

  throwLocation : null,
  catchLocation : null,

  /* Stack */

  asyncCallsStack : null,
  throwCallsStack : null,
  catchCallsStack : null,
  fallBackStack : null,
  throwsStack : '',
  throws : null,

}

//

/**
 * Creates error object, with message created from passed `msg` parameters and contains error trace.
 * If passed several strings (or mixed error and strings) as arguments, the result error message is created by
 concatenating them.
 *
 * @example
 * function divide( x, y )
 * {
 *   if( y == 0 )
 *     throw _.err( 'divide by zero' )
 *   return x / y;
 * }
 * divide( 3, 0 );
 *
 * // log
 * // Error:
 * // caught     at divide (<anonymous>:2:29)
 * // divide by zero
 * // Error
 * //   at _err (file:///.../wTools/staging/Base.s:1418:13)
 * //   at wTools.err (file:///.../wTools/staging/Base.s:1449:10)
 * //   at divide (<anonymous>:2:29)
 * //   at <anonymous>:1:1
 *
 * @param {...String|Error} msg Accepts list of messeges/errors.
 * @returns {Error} Created Error. If passed existing error as one of parameters, routine modified it and return
 * reference.
 * @function err
 * @namespace Tools
 */

function err()
{
  return _._err
  ({
    args : arguments,
    level : 2,
  });
}

//

/* qqq : optimize */
function brief()
{
  return _._err
  ({
    args : arguments,
    level : 2,
    brief : 1,
  });
}

//

function unbrief()
{
  return _._err
  ({
    args : arguments,
    level : 2,
    brief : 0,
  });
}

//

function process( err )
{

  if( arguments.length !== 1 || !_.error.isFormed( err ) )
  err = _.err( ... arguments );

  if( _.process && _.process.entryPointInfo )
  _.error.sectionAdd( err, { name : 'process', body : _.process.entryPointInfo() });

  return err;
}

//

function unprocess()
{

  if( arguments.length !== 1 || !_.error.isFormed( err ) )
  err = _.err( ... arguments );

  _.error.sectionRemove( err, 'process' );

  return err;
}

//

function fromStr( errStr )
{

  try
  {

    errStr = _.str.lines.strip( errStr );

    let sectionBeginRegexp = /[=]\s+(.*?)\s*\n/mg;
    let splits = _.strSplitFast
    ({
      src : errStr,
      delimeter : sectionBeginRegexp,
    });

    let sectionName;
    let throwCallsStack = '';
    let throwsStack = '';
    let stackCondensing = true;
    let messages = [];
    for( let s = 0 ; s < splits.length ; s++ )
    {
      let split = splits[ s ];
      let sectionNameParsed = sectionBeginRegexp.exec( split + '\n' );
      if( sectionNameParsed )
      {
        sectionName = sectionNameParsed[ 1 ];
        continue;
      }

      if( !sectionName )
      messages.push( split );
      else if( !sectionName || _.strBegins( sectionName, 'Message of' ) )
      messages.push( split );
      else if( _.strBegins( sectionName, 'Beautified calls stack' ) )
      throwCallsStack = split;
      else if( _.strBegins( sectionName, 'Throws stack' ) )
      throwsStack = split;

    }

    let error = new Error();

    let throwLocation = _.introspector.locationFromStackFrame( throwCallsStack || error.stack );

    let originalMessage = messages.join( '\n' );

    let result = _.error._make
    ({
      error,
      throwLocation,
      stackCondensing,
      originalMessage,
      combinedStack : throwCallsStack,
      throwCallsStack,
      throwsStack,
    });

    return result;
  }
  catch( err2 )
  {
    console.error( err2 );
    return Error( errStr );
  }
}

// --
// stater
// --

function attend( err, value )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( value === undefined )
  value = Config.debug ? _.introspector.stack([ 0, Infinity ]) : true;
  let result = _.error.concealedSet( err, { attended : value } );
  return result;
}

//

function logged( err, value )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( value === undefined )
  value = Config.debug ? _.introspector.stack([ 0, Infinity ]) : true;
  // console.log( `logged ${value}` );
  return _.error.concealedSet( err, { logged : value } );
}

//

function suspend( err, owner, value )
{
  _.assert( arguments.length === 3 );
  _.assert( !!owner );

  /*
  cant suspend/resume suspended by another owner error
  */

  if( err.suspended && err.suspended !== owner )
  return _.error.concealedSet( err, {} );

  let value2 = err.suspended;
  if( value === undefined )
  value = true;
  let result = _.error.concealedSet( err, { suspended : value ? owner : false } );

  /*
  resuming of suspended wary error object should resume _handleUncaughtAsync
  */

  if( value2 && !value && err.wary )
  {
    _.error._handleUncaughtAsync( err );
  }

  return result
}

//

function wary( err, value )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( value === undefined )
  value = true;
  return _.error.concealedSet( err, { wary : value } );
}

//

/* zzz : standartize interface of similar routines */
function reason( err, value )
{

  if( arguments.length === 1 )
  {
    return err.reason;
  }
  else if( arguments.length === 2 )
  {
    // nonenumerable( 'reason', value );
    _.error.concealedSet( err, { reason : value } );
    return err.reason;
  }

  throw Error( 'Expects one or two argument' );

  // /* */
  //
  // function nonenumerable( propName, value )
  // {
  //   try
  //   {
  //     let o =
  //     {
  //       enumerable : false,
  //       configurable : true,
  //       writable : true,
  //       value,
  //     };
  //     Object.defineProperty( err, propName, o );
  //   }
  //   catch( err2 )
  //   {
  //     console.error( err2 );
  //   }
  // }

}

//

function restack( err, level )
{

  if( !( arguments.length === 1 || arguments.length === 2 ) )
  throw Error( 'Expects single argument or none' );

  if( level === undefined )
  level = 1;

  if( !_.number.defined( level ) )
  throw Error( 'Expects defined number' );

  let err2 = _._err
  ({
    args : [],
    level : level + 1,
  });

  return _.err( err2, err );
}

//

function once( err )
{

  err = _._err
  ({
    args : arguments,
    level : 2,
  });

  if( err.logged )
  return undefined;

  _.error.attend( err );

  return err;
}

//

function originalMessage( err )
{

  if( arguments.length !== 1 )
  throw Error( 'error.originalMessage : Expects single argument' );

  if( _.strIs( err ) )
  return err;

  if( !err )
  return;

  if( err.originalMessage )
  return err.originalMessage;

  let message = err.message;

  if( !message && message !== '' )
  message = err.msg;
  if( !message && message !== '' )
  message = err.name;

  return message;
}

//

function originalStack( err )
{

  if( arguments.length !== 1 )
  throw Error( 'error.originalStack : Expects single argument' );

  if( !_.error.is( err ) )
  throw Error( 'error.originalStack : Expects error' );

  if( err.throwCallsStack )
  return err.throwCallsStack;

  if( err.combinedStack )
  return err.combinedStack;

  if( err[ stackSymbol ] )
  return err[ stackSymbol ];

  if( err.stack )
  return _.introspector.stack( err.stack );

  /* should return null if nothing found */
  return null;
}

// --
// log
// --

function _log( err, logger )
{
  logger = logger || _global.logger || _global.console;

  /* */

  if( _.routine.is( err.toString ) )
  {
    let str = err.toString();
    if( _.color && _.color.strFormat )
    str = _.color.strFormat( str, 'negative' );
    logger.error( str )
  }
  else
  {
    logger.error( 'Error does not have toString' );
    logger.error( err );
  }

  /* */

  _.error.logged( err );
  _.error.attend( err );

  /* */

  return err;
}

//

/**
 * Creates error object, with message created from passed `msg` parameters and contains error trace.
 * If passed several strings (or mixed error and strings) as arguments, the result error message is created by
 concatenating them. Prints the created error.
 * If _global_.logger defined, routine will use it to print error, else uses console
 *
 * @see {@link wTools.err See err}
 *
 * @example
 * function divide( x, y )
 * {
 *   if( y == 0 )
 *    throw _.error.log( 'divide by zero' )
 *    return x / y;
 * }
 * divide( 3, 0 );
 *
 * // log
 * // Error:
 * // caught     at divide (<anonymous>:2:29)
 * // divide by zero
 * // Error
 * //   at _err (file:///.../wTools/staging/Base.s:1418:13)
 * //   at wTools.errLog (file:///.../wTools/staging/Base.s:1462:13)
 * //   at divide (<anonymous>:2:29)
 * //   at <anonymous>:1:1
 *
 * @param {...String|Error} msg Accepts list of messeges/errors.
 * @returns {Error} Created Error. If passed existing error as one of parameters, routine modified it and return
 * @function errLog
 * @namespace Tools
 */

function log()
{

  let err = _._err
  ({
    args : arguments,
    level : 2,
  });

  return _.error._log( err );
}

//

function logOnce( err )
{

  err = _._err
  ({
    args : arguments,
    level : 2,
  });

  if( err.logged )
  return err;

  return _.error._log( err );
}

//

function _Setup()
{

  Error.stackTraceLimit = Infinity;
/* Error.stackTraceLimit = 99; */

}

// --
// namespace
// --

let stackSymbol = Symbol.for( 'stack' );

let ToolsExtension =
{

  errIs : is,

  _errMake : _make,
  _err,
  err,
  errBrief : brief,
  errUnbrief : unbrief,
  errProcess : process,
  errUnprocess : unprocess,
  errAttend : attend,
  errLogged : logged,
  errSuspend : suspend,
  errWary : wary,
  errRestack : restack,
  errOnce : once,

  _errLog : _log,
  errLog : log,
  errLogOnce : logOnce,

}

Object.assign( _, ToolsExtension );

//

/**
 * @property {Object} error={}
 * @property {Boolean} breakpointOnAssertEnabled=!!Config.debug
 * @name ErrFields
 * @namespace Tools
 */

let ErrorExtension =
{

  // dichotomy

  is,
  isFormed,
  isAttended,
  isBrief,
  isLogged,
  isSuspended,
  isWary,

  // generator

  _sectionsJoin,
  _messageForm,
  sectionRemove,
  sectionAdd,
  _sectionAdd,
  _sectionExposedAdd,

  exposedSet,
  concealedSet,
  _inStr,

  // introductor

  _make,
  _err,
  err,
  brief,
  unbrief,
  process, /* qqq : cover please */
  unprocess, /* qqq : cover please */
  fromStr,

  // stater

  attend,
  logged,
  suspend, /* qqq : cover, please. should work okay with symbols */
  wary, /* qqq : cover */
  reason, /* qqq : cover */
  restack, /* qqq : cover */
  once, /* qqq : cover */
  originalMessage,
  originalStack,

  // log

  _log,
  log,
  logOnce,

  // meta

  _Setup,

  // fields

  breakpointOnDebugger : 0,
  breakpointOnAssertEnabled : !!Config.debug,
  _errorCounter : 0,
  _errorMaking : false,

}

Object.assign( _.error, ErrorExtension );
_.error._Setup();

/* zzz : improve formatting of stack with table */
/* xxx : postpone reading files as late as possible */
/* xxx : move unhandled error event to namespacer::error */
/* xxx : add module files stack */

})();

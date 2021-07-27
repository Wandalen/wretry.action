( function _l1_Routine_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.routine = _.routine || Object.create( null );
_.routines = _.routine.s = _.routines || _.routine.s || Object.create( null );
// _.ddds = _.ddd.s = _.ddds || _.ddd.s || Object.create( null );

_.routine.chainer = _.routine.chainer || Object.create( null );
_.routine.tail = _.routine.tail || Object.create( null );

// --
// routine
// --

function __mapButKeys( srcMap, butMap )
{
  let result = [];

  for( let s in srcMap )
  if( !( s in butMap ) )
  result.push( s );

  return result;
}

//

function __mapUndefinedKeys( srcMap )
{
  let result = [];

  for( let s in srcMap )
  if( srcMap[ s ] === undefined )
  result.push( s );

  return result;
}

//

function __keysQuote( keys )
{
  let result = `"${ keys[ 0 ] }"`;
  for( let i = 1 ; i < keys.length ; i++ )
  result += `, "${ keys[ i ] }"`;
  return result.trim();
}

//

function __primitiveLike( src )
{
  if( _.primitive.is( src ) )
  return true;
  if( _.regexpIs( src ) )
  return true;
  if( _.routineIs( src ) )
  return true;
  return false;
}

//

function __strType( src )
{
  if( _.strType )
  return _.strType( src );
  return String( src );
}

//

function __mapSupplementWithoutUndefined( dstMap, srcMap )
{
  for( let k in srcMap )
  {
    if( Config.debug )
    _.assert
    (
      __primitiveLike( srcMap[ k ] ),
      () => `Defaults map should have only primitive elements, but option::${ k } is ${ __strType( srcMap[ k ] ) }`
    );
    if( dstMap[ k ] !== undefined )
    continue;
    dstMap[ k ] = srcMap[ k ];
  }
}

__mapSupplementWithoutUndefined.meta = Object.create( null );
__mapSupplementWithoutUndefined.meta.locals =
{
  __primitiveLike,
  __strType,
}

//

function __mapSupplementWithUndefined( dstMap, srcMap )
{
  for( let k in srcMap )
  {
    if( Config.debug )
    _.assert
    (
      __primitiveLike( srcMap[ k ] ),
      () => `Defaults map should have only primitive elements, but option::${ k } is ${ __strType( srcMap[ k ] ) }`
    );
    if( Object.hasOwnProperty.call( dstMap, k ) )
    continue;
    dstMap[ k ] = srcMap[ k ];
  }
}

__mapSupplementWithUndefined.meta = Object.create( null );
__mapSupplementWithUndefined.meta.locals =
{
  __primitiveLike,
  __strType,
}

//

function __mapSupplementWithUndefinedTollerant( dstMap, srcMap )
{
  for( let k in srcMap )
  {
    if( Object.hasOwnProperty.call( dstMap, k ) )
    continue;
    dstMap[ k ] = srcMap[ k ];
  }
}

__mapSupplementWithUndefinedTollerant.meta = Object.create( null );
__mapSupplementWithUndefinedTollerant.meta.locals =
{
}

//

function __arrayFlatten( src )
{
  let result = [];
  if( src === null )
  return result;
  if( !_.argumentsArray.like( src ) )
  result.push( src );
  else
  for( let i = 0 ; i < src.length ; i++ )
  {
    let e = src[ i ];
    if( _.array.is( e ) || _.argumentsArray.is( e ) )
    result.push( ... e );
    else
    result.push( e );
  }
  return result;
}

// --
// dichotomy
// --

function is( src )
{
  let typeStr = Object.prototype.toString.call( src );
  return _.routine._is( src, typeStr );
}

//

function _is( src, typeStr )
{
  return typeStr === '[object Function]' || typeStr === '[object AsyncFunction]';
}

//

function like( src )
{
  let typeStr = Object.prototype.toString.call( src );
  return _.routine._like( src, typeStr );
}

//

function _like( src, typeStr )
{
  return typeStr === '[object Function]' || typeStr === '[object AsyncFunction]' || typeStr === '[object GeneratorFunction]' || typeStr === '[object AsyncGeneratorFunction]';
}

//

function routineIsTrivial_functor()
{

  const syncPrototype = Object.getPrototypeOf( Function );
  const asyncPrototype = Object.getPrototypeOf( _async );
  return routineIsTrivial;

  function routineIsTrivial( src )
  {
    if( !src )
    return false;
    let prototype = Object.getPrototypeOf( src );
    if( prototype === syncPrototype )
    return true;
    if( prototype === asyncPrototype )
    return true;
    return false;
  }

  async function _async()
  {
  }

}

let isTrivial = routineIsTrivial_functor();
isTrivial.functor = routineIsTrivial_functor;

//

function isSync( src )
{
  return Object.prototype.toString.call( src ) === '[object Function]';
}

//

function isAsync( src )
{
  return Object.prototype.toString.call( src ) === '[object AsyncFunction]';
}

//

function isGenerator( src )
{
  let typeStr = Object.prototype.toString.call( src );
  return typeStr === '[object GeneratorFunction]' || typeStr === '[object AsyncGeneratorFunction]';
}

//

function isSyncGenerator( src )
{
  return Object.prototype.toString.call( src ) === '[object GeneratorFunction]';
}

//

function isAsyncGenerator( src )
{
  return Object.prototype.toString.call( src ) === '[object AsyncGeneratorFunction]';
}

//

function are( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.argumentsArray.like( src ) )
  {
    for( let s = 0 ; s < src.length ; s++ )
    if( !_.routine.is( src[ s ] ) )
    return false;
    return true;
  }

  return _.routine.is( src );
}

//

function withName( src )
{
  if( !_.routine.like( src ) )
  return false;
  if( !src.name )
  return false;
  return true;
}

// --
// joiner
// --

/**
 * Internal implementation.
 * @param {object} object - object to check.
 * @return {object} object - name in key/value format.
 * @function _routineJoin
 * @namespace Tools
 */

function _join( o )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.bool.is( o.sealing ) );
  _.assert( _.bool.is( o.extending ) );
  _.assert( _.routine.is( o.routine ), 'Expects routine' );
  _.assert( _.longIs( o.args ) || o.args === undefined );

  let routine = o.routine;
  let args = o.args;
  let context = o.context;
  let result = act();

  if( o.extending )
  {
    _.props.extend( result, routine );

    let o2 =
    {
      value : routine,
      enumerable : false,
    };
    Object.defineProperty( result, 'originalRoutine', o2 ); /* qqq : cover */

    if( context !== undefined )
    {
      let o3 =
      {
        value : context,
        enumerable : false,
      };
      Object.defineProperty( result, 'boundContext', o3 ); /* qqq : cover */
    }

    if( args !== undefined )
    {
      let o3 =
      {
        value : args,
        enumerable : false,
      };
      Object.defineProperty( result, 'boundArguments', o3 ); /* qqq : cover */
    }

  }

  return result;

  /* */

  function act()
  {

    if( context !== undefined && args !== undefined )
    {
      if( o.sealing === true )
      {
        let name = routine.name || '__sealedContextAndArguments';
        _.assert( _.strIs( name ) );
        let __sealedContextAndArguments =
        {
          [ name ] : function()
          {
            return routine.apply( context, args );
          }
        }
        return __sealedContextAndArguments[ name ];
      }
      else
      {
        // let a = _.arrayAppendArray( [ context ], args );
        let a = [ context ]
        a.push( ... args );
        return Function.prototype.bind.apply( routine, a );
      }
    }
    else if( context !== undefined && args === undefined )
    {
      if( o.sealing === true )
      {
        let name = routine.name || '__sealedContext';
        let __sealedContext =
        {
          [ name ] : function()
          {
            return routine.call( context );
          }
        }
        return __sealedContext[ name ];
      }
      else
      {
        return Function.prototype.bind.call( routine, context );
      }
    }
    else if( context === undefined && args !== undefined )
    {
      if( o.sealing === true )
      {
        let name = routine.name || '__sealedArguments';
        _.assert( _.strIs( name ) );
        let __sealedContextAndArguments =
        {
          [ name ] : function()
          {
            return routine.apply( this, args );
          }
        }
        return __sealedContextAndArguments[ name ];
      }
      else
      {
        let name = routine.name || '__joinedArguments';
        let __joinedArguments =
        {
          [ name ] : function()
          {
            // let args2 = _.arrayAppendArrays( null, [ args, arguments ] );
            let args2 = [ ... args, ... arguments ];
            return routine.apply( this, args2 );
          }
        }
        return __joinedArguments[ name ];
      }
    }
    else if( context === undefined && args === undefined ) /* zzz */
    {
      return routine;
    }
    else _.assert( 0 );
  }

}

//

function constructorJoin( routine, args )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  return _.routine._join
  ({
    routine,
    context : routine,
    args : args || [],
    sealing : false,
    extending : false,
  });

}

//

/**
 * The join() routine creates a new function with its 'this' ( context ) set to the provided `context`
 * value. Argumetns `args` of target function which are passed before arguments of binded function during
 * calling of target function. Unlike bind routine, position of `context` parameter is more intuitive.
 *
 * @example
 * let o = { z: 5 };
 * let y = 4;
 * function sum( x, y )
 * {
 *   return x + y + this.z;
 * }
 * let newSum = _.routine.join( o, sum, [ 3 ] );
 * newSum( y );
 * // returns 12
 *
 * @example
 * function f1()
 * {
 *   console.log( this )
 * };
 * let f2 = f1.bind( undefined ); // context of new function sealed to undefined (or global object);
 * f2.call( o ); // try to call new function with context set to { z: 5 }
 * let f3 = _.routine.join( undefined, f1 ); // new function.
 * f3.call( o )
 * // log { z: 5 }
 *
 * @param {Object} context The value that will be set as 'this' keyword in new function
 * @param {Function} routine Function which will be used as base for result function.
 * @param {Array<*>} args Argumetns of target function which are passed before arguments of binded function during
 calling of target function. Must be wraped into array.
 * @returns {Function} New created function with preceding this, and args.
 * @throws {Error} When second argument is not callable throws error with text 'first argument must be a routine'
 * @thorws {Error} If passed arguments more than 3 throws error with text 'Expects 3 or less arguments'
 * @function join
 * @namespace Tools
 */

function join( context, routine, args )
{

  _.assert( arguments.length <= 3, 'Expects 3 or less arguments' );

  return _.routine._join
  ({
    routine,
    context,
    args,
    sealing : false,
    extending : true,
  });

}

//

/**
 * The join() routine creates a new function with its 'this' ( context ) set to the provided `context`
 * value. Argumetns `args` of target function which are passed before arguments of binded function during
 * calling of target function. Unlike bind routine, position of `context` parameter is more intuitive.
 *
 * @example
 * let o = { z: 5 };
 * let y = 4;
 * function sum( x, y )
 * {
 *   return x + y + this.z;
 * }
 * let newSum = _.routine.join( o, sum, [ 3 ] );
 * newSum( y );
 * // returns 12
 *
 * @example
 * function f1()
 * {
 *   console.log( this )
 * };
 * let f2 = f1.bind( undefined ); // context of new function sealed to undefined (or global object);
 * f2.call( o ); // try to call new function with context set to { z: 5 }
 * let f3 = _.routine.join( undefined, f1 ); // new function.
 * f3.call( o )
 * // log { z: 5 }
 *
 * @param {Object} context The value that will be set as 'this' keyword in new function
 * @param {Function} routine Function which will be used as base for result function.
 * @param {Array<*>} args Argumetns of target function which are passed before arguments of binded function during
 calling of target function. Must be wraped into array.
 * @returns {Function} New created function with preceding this, and args.
 * @throws {Error} When second argument is not callable throws error with text 'first argument must be a routine'
 * @thorws {Error} If passed arguments more than 3 throws error with text 'Expects 3 or less arguments'
 * @function routineJoin
 * @namespace Tools
 */

function join( context, routine, args )
{

  _.assert( arguments.length <= 3, 'Expects 3 or less arguments' );

  return _.routine._join
  ({
    routine,
    context,
    args,
    sealing : false,
    extending : true,
  });

}

//

/**
 * Return new function with sealed context and arguments.
 *
 * @example
 * let o = { z : 5 };
 * function sum( x, y )
 * {
 *   return x + y + this.z;
 * }
 * let newSum = _.routine.seal( o, sum, [ 3, 4 ] );
 * newSum();
 * // returns : 12
 *
 * @param { Object } context - The value that will be set as 'this' keyword in new function
 * @param { Function } routine - Function which will be used as base for result function.
 * @param { Array } args - Arguments wrapped into array. Will be used as argument to `routine` function
 * @returns { Function } - Result function with sealed context and arguments.
 * @function seal
 * @namespace Tools
 */

function seal( context, routine, args )
{

  _.assert( arguments.length <= 3, 'Expects 3 or less arguments' );

  return _.routine._join
  ({
    routine,
    context,
    args,
    sealing : true,
    extending : true,
  });

}

// --
// options
// --

// //
//
// function mapOptionsApplyDefaults( options, defaults )
// {
//
//   _.assert( arguments.length === 2 );
//   _.map.assertHasOnly( options, defaults, `Does not expect options:` );
//   _.mapSupplementStructureless( options, defaults );
//   _.map.assertHasNoUndefine( options, `Options map should have no undefined fileds, but it does have` );
//
//   return options;
// }

/* qqq : for Dmytro : bad : discuss
should be { defaults : {} } in the first argument
*/

function optionsWithoutUndefined( routine, options )
{

  if( _.argumentsArray.like( options ) )
  {
    _.assert
    (
      options.length === 0 || options.length === 1,
      `Expects single options map, but got ${options.length} arguments`
    );
    if( options.length === 0 )
    options = Object.create( null )
    else
    options = options[ 0 ];
  }

  if( Config.debug )
  {
    _.assert( arguments.length === 2, 'Expects exactly 2 arguments' );
    _.assert( _.routineIs( routine ) || _.aux.is( routine ) || routine === null, 'Expects an object with options' );
    _.assert( _.object.isBasic( options ) || options === null, 'Expects an object with options' );
  }

  if( options === null || options === undefined )
  options = Object.create( null );

  let name = routine.name || '';
  let defaults = routine.defaults;
  _.assert( _.aux.is( defaults ), `Expects map of defaults, but got ${_.strType( defaults )}` );

  // if( options === undefined ) /* qqq : for Dmytro : bad : should be error */
  // options = Object.create( null );
  // if( defaults === null )
  // defaults = Object.create( null );

  // let name = _.routineIs( defaults ) ? defaults.name : '';
  // defaults = ( _.routineIs( defaults ) && defaults.defaults ) ? defaults.defaults : defaults;
  // _.assert( _.aux.is( defaults ), 'Expects defined defaults' );

  /* */

  if( Config.debug )
  {
    let extraKeys = __mapButKeys( options, defaults );
    _.assert( extraKeys.length === 0, () => `Routine "${ name }" does not expect options: ${ __keysQuote( extraKeys ) }` );
  }

  __mapSupplementWithoutUndefined( options, defaults );

  if( Config.debug )
  {
    let undefineKeys = __mapUndefinedKeys( options );
    _.assert
    (
      undefineKeys.length === 0,
      () => `Options map for routine "${ name }" should have no undefined fields, but it does have ${ __keysQuote( undefineKeys ) }`
    );
  }

  return options;
}

optionsWithoutUndefined.meta = Object.create( null );
optionsWithoutUndefined.meta.locals =
{
  __mapButKeys,
  __mapUndefinedKeys,
  __keysQuote,
  __mapSupplementWithoutUndefined,
}

//

function assertOptionsWithoutUndefined( routine, options )
{

  if( _.argumentsArray.like( options ) )
  {
    _.assert
    (
      options.length === 0 || options.length === 1,
      `Expects single options map, but got ${options.length} arguments`
    );
    options = options[ 0 ];
  }

  if( Config.debug )
  {
    _.assert( arguments.length === 2, 'Expects exactly 2 arguments' );
    _.assert( _.routineIs( routine ) || _.aux.is( routine ) || routine === null, 'Expects an object with options' );
    _.assert( _.object.isBasic( options ) || options === null, 'Expects an object with options' );
  }

  let name = routine.name || '';
  let defaults = routine.defaults;
  _.assert( _.aux.is( defaults ), `Expects map of defaults, but got ${_.strType( defaults )}` );

  /* */

  if( Config.debug )
  {

    let extraKeys = __mapButKeys( options, defaults );
    _.assert( extraKeys.length === 0, () => `Routine "${ name }" does not expect options: ${ __keysQuote( extraKeys ) }` );

    let undefineKeys = __mapUndefinedKeys( options );
    _.assert
    (
      undefineKeys.length === 0,
      () => `Options map for routine "${ name }" should have no undefined fields, but it does have ${ __keysQuote( undefineKeys ) }`
    );

    for( let k in defaults )
    {
      _.assert
      (
        __primitiveLike( defaults[ k ] ),
        () => `Defaults map should have only primitive elements, but option::${ k } is ${ __strType( defaults[ k ] ) }`
      );
      _.assert
      (
        Reflect.has( options, k ),
        `Options map does not have option::${k}`
      )
    }

  }

  return options;
}

assertOptionsWithoutUndefined.meta = Object.create( null );
assertOptionsWithoutUndefined.meta.locals =
{
  __mapButKeys,
  __mapUndefinedKeys,
  __keysQuote,
  __primitiveLike,
  __strType,
}

//

function optionsWithUndefined( routine, options )
{

  if( _.argumentsArray.like( options ) )
  {
    _.assert
    (
      options.length === 0 || options.length === 1,
      `Expects single options map, but got ${options.length} arguments`
    );
    if( options.length === 0 )
    options = Object.create( null )
    else
    options = options[ 0 ];
  }

  if( Config.debug )
  {
    _.assert( arguments.length === 2, 'Expects exactly 2 arguments' );
    _.assert( _.routineIs( routine ) || _.aux.is( routine ) || routine === null, 'Expects an object with options' );
    _.assert( _.object.isBasic( options ) || options === null, 'Expects an object with options' );
  }

  if( options === null )
  options = Object.create( null );
  let name = routine.name || '';
  let defaults = routine.defaults;
  _.assert( _.aux.is( defaults ), `Expects map of defaults, but got ${_.strType( defaults )}` );

  /* */

  if( Config.debug )
  {
    let extraKeys = __mapButKeys( options, defaults );
    _.assert( extraKeys.length === 0, () => `Routine "${ name }" does not expect options: ${ __keysQuote( extraKeys ) }` );
  }

  __mapSupplementWithUndefined( options, defaults );

  return options;
}

optionsWithUndefined.meta = Object.create( null );
optionsWithUndefined.meta.locals =
{
  __keysQuote,
  __mapSupplementWithUndefined,
}

//

function optionsWithUndefinedTollerant( routine, options )
{
  if( _.argumentsArray.like( options ) )
  {
    _.assert
    (
      options.length === 0 || options.length === 1,
      `Expects single options map, but got ${options.length} arguments`
    );
    if( options.length === 0 )
    options = Object.create( null )
    else
    options = options[ 0 ];
  }

  if( Config.debug )
  {
    _.assert( arguments.length === 2, 'Expects exactly 2 arguments' );
    _.assert( _.routineIs( routine ) || _.aux.is( routine ) || routine === null, 'Expects an object with options' );
    _.assert( _.object.isBasic( options ) || options === null, 'Expects an object with options' );
  }

  if( options === null )
  options = Object.create( null );
  let name = routine.name || '';
  let defaults = routine.defaults;
  _.assert( _.aux.is( defaults ), `Expects map of defaults, but got ${_.strType( defaults )}` );

  /* */

  if( Config.debug )
  {
    let extraKeys = __mapButKeys( options, defaults );
    _.assert( extraKeys.length === 0, () => `Routine "${ name }" does not expect options: ${ __keysQuote( extraKeys ) }` );
  }

  __mapSupplementWithUndefinedTollerant( options, defaults );

  return options;
}

optionsWithUndefinedTollerant.meta = Object.create( null );
optionsWithUndefinedTollerant.meta.locals =
{
  __keysQuote,
  __mapSupplementWithUndefinedTollerant,
}


//

function assertOptionsWithUndefined( routine, options )
{

  if( _.argumentsArray.like( options ) )
  {
    _.assert
    (
      options.length === 0 || options.length === 1,
      `Expects single options map, but got ${options.length} arguments`
    );
    options = options[ 0 ];
  }

  if( Config.debug )
  {
    _.assert( arguments.length === 2, 'Expects exactly 2 arguments' );
    _.assert( _.routineIs( routine ) || _.aux.is( routine ) || routine === null, 'Expects an object with options' );
    _.assert( _.object.isBasic( options ) || options === null, 'Expects an object with options' );
  }

  let name = routine.name || '';
  let defaults = routine.defaults;
  _.assert( _.aux.is( defaults ), `Expects map of defaults, but got ${_.strType( defaults )}` );

  /* */

  if( Config.debug )
  {

    let extraKeys = __mapButKeys( options, defaults );
    _.assert( extraKeys.length === 0, () => `Routine "${ name }" does not expect options: ${ __keysQuote( extraKeys ) }` );

    for( let k in defaults )
    {
      _.assert
      (
        __primitiveLike( defaults[ k ] ),
        () => `Defaults map should have only primitive elements, but option::${ k } is ${ __strType( defaults[ k ] ) }`
      );
      _.assert
      (
        Reflect.has( options, k ),
        `Options map does not have option::${k}`
      )
    }

  }

  return options;
}

assertOptionsWithUndefined.meta = Object.create( null );
assertOptionsWithUndefined.meta.locals =
{
  __keysQuote,
  __primitiveLike,
  __strType,
}

//

function _verifyDefaults( defaults )
{

  for( let k in defaults )
  {
    _.assert
    (
      __primitiveLike( defaults[ k ] ),
      () => `Defaults map should have only primitive elements, but option::${ k } is ${ __strType( defaults[ k ] ) }`
    );
  }

}

_verifyDefaults.meta = Object.create( null );
_verifyDefaults.meta.locals =
{
  __primitiveLike,
  __strType,
}

// --
// amend
// --

/* qqq : for Dmytro : cover and optimize */
function _amend( o )
{
  let dst = o.dst;
  let srcs = o.srcs;
  let srcIsVector = _.vectorIs( srcs );
  let extended = false;

  _.routine.assertOptions( _amend, o );
  _.assert( arguments.length === 1 );
  _.assert( _.routine.is( dst ) || dst === null );
  _.assert( srcs === null || srcs === undefined || _.aux.is( srcs ) || _.routine.is( srcs ) || _.vector.is( srcs ) );
  _.assert( o.amending === 'extending', 'not implemented' );
  _.assert
  (
    o.strategy === 'cloning' || o.strategy === 'replacing' || o.strategy === 'inheriting',
    () => `Unknown strategy ${o.strategy}`
  );

  /* generate dst routine */

  if( dst === null ) /* qqq : for Dmytro : good coverage required */
  dst = _dstMake( srcs );

  // /* shallow clone properties of dst routine */
  //
  // if( o.strategy === 'cloning' )
  // _fieldsClone( dst );
  // else if( o.strategy === 'inheriting' )
  // _fieldsInherit( dst );

  /* extend dst routine */

  let _dstAmend;
  if( o.strategy === 'cloning' )
  _dstAmend = _dstAmendCloning;
  else if( o.strategy === 'replacing' )
  _dstAmend = _dstAmendReplacing;
  else if( o.strategy === 'inheriting' )
  _dstAmend = _dstAmendInheriting;
  else _.assert( 0, 'not implemented' );

  if( srcIsVector )
  for( let src of srcs )
  _dstAmend( dst, src );
  else
  _dstAmend( dst, srcs );

  /* qqq : for Dmytro : it should be optimal, no redundant cloning of body should happen
  check and cover it by good test, please
  */
  if( extended )
  // if( dst.body && dst.body.defaults )
  if( dst.body )
  dst.body = bodyFrom( dst.body );

  if( Config.debug )
  {
    /* qqq : for Dmytro : cover, please */
    if( _.strEnds( dst.name, '_body' ) )
    {
      _.assert( dst.body === undefined, 'Body of routine should not have its own body' );
      _.assert( dst.head === undefined, 'Body of routine should not have its own head' );
      _.assert( dst.tail === undefined, 'Body of routine should not have its own tail' );
    }
    // xxx : uncomment?
    // if( dst.defaults )
    // _.routine._verifyDefaults( dst.defaults );
  }

  return dst;

  /* */

  function _dstMake( srcs )
  {
    let dstMap = Object.create( null );

    /* qqq : option amendment influence on it */
    if( srcIsVector )
    for( let src of srcs )
    {
      if( src === null )
      continue;
      _.props.extend( dstMap, src );
    }
    else
    {
      if( srcs !== null )
      _.props.extend( dstMap, srcs );
    }

    if( dstMap.body )
    {
      // dst = _.routine.uniteCloning( dstMap.head, dstMap.body );
      dst = _.routine.unite
      ({
        head : dstMap.head || null,
        body : dstMap.body || null,
        tail : dstMap.tail || null,
        name : dstMap.name || null,
        strategy : o.strategy,
      });
    }
    else
    {
      if( srcIsVector )
      dst = dstFrom( srcs[ 0 ] );
      else
      dst = dstFrom( srcs );
    }

    _.assert( _.routineIs( dst ) );
    // _.props.extend( dst, dstMap );

    return dst;
  }

  /* */

  // function _fieldsClone( dst )
  // {
  //
  //   for( let s in dst )
  //   {
  //     let property = dst[ s ];
  //     if( _.object.isBasic( property ) )
  //     {
  //       property = _.props.extend( null, property );
  //       dst[ s ] = property;
  //     }
  //   }
  //
  // }
  //
  // /* */
  //
  // function _fieldsInherit( dst )
  // {
  //
  //   for( let s in dst )
  //   {
  //     let property = dst[ s ];
  //     if( _.object.isBasic( property ) )
  //     {
  //       property = Object.create( property );
  //       dst[ s ] = property;
  //     }
  //   }
  //
  // }

  /* */

  function _dstAmendCloning( dst, src )
  {
    _.assert( !!dst );
    _.assert( _.aux.is( src ) || _.routine.is( src ) );
    for( let s in src )
    {
      let property = src[ s ];
      if( dst[ s ] === property )
      continue;
      let d = Object.getOwnPropertyDescriptor( dst, s );
      if( d && !d.writable )
      continue;
      extended = true;
      if( _.object.isBasic( property ) )
      {
        _.assert( !_.props.own( dst, s ) || _.object.isBasic( dst[ s ] ) );

        if( dst[ s ] )
        _.props.extend( dst[ s ], property );
        else
        dst[ s ] = property = _.props.extend( null, property );

        // property = _.props.extend( null, property );
        // if( dst[ s ] )
        // _.props.supplement( property, dst[ s ] );
      }
      else
      {
        dst[ s ] = property;
      }
    }
  }

  /* */

  function _dstAmendInheriting( dst, src )
  {
    _.assert( !!dst );
    _.assert( _.aux.is( src ) || _.routine.is( src ) );
    /* qqq : for Dmytro : on extending should inherit from the last one, on supplementing should inherit from the first one
    implement, and cover in separate test
    */
    for( let s in src )
    {
      let property = src[ s ];
      if( dst[ s ] === property )
      continue;
      let d = Object.getOwnPropertyDescriptor( dst, s );
      if( d && !d.writable )
      continue;
      extended = true;
      if( _.object.isBasic( property ) )
      {
        property = Object.create( property );
        if( dst[ s ] )
        _.props.supplement( property, dst[ s ] );
      }
      dst[ s ] = property;
    }
  }

  /* */

  function _dstAmendReplacing( dst, src )
  {
    _.assert( !!dst );
    _.assert( _.aux.is( src ) || _.routine.is( src ) );
    for( let s in src )
    {
      let property = src[ s ];
      if( dst[ s ] === property )
      continue;
      let d = Object.getOwnPropertyDescriptor( dst, s );
      if( d && !d.writable )
      continue;
      extended = true;
      dst[ s ] = property;
    }
  }

  /* */

  function bodyFrom()
  {
    const body = dst.body;
    let body2 = body;
    _.assert( body.head === undefined, 'Body should not have own head' );
    _.assert( body.tail === undefined, 'Body should not have own tail' );
    _.assert( body.body === undefined, 'Body should not have own body' );
    {
      // let srcs = srcIsVector ? _.map_( null, o.srcs, ( src ) => propertiesBut( src ) ) : [ propertiesBut( o.srcs ) ];
      let srcs;
      if( srcIsVector )
      {
        // debugger;
        srcs = o.srcs.map( (src ) => propertiesBut( src ) );
      }
      else
      {
        srcs = [ propertiesBut( o.srcs ) ];
      }
      srcs.unshift( body );
      body2 = _.routine._amend
      ({
        dst : o.strategy === 'replacing' ? body2 : null,
        srcs,
        strategy : o.strategy,
        amending : o.amending,
      });
      _.assert( body2.head === undefined, 'Body should not have own head' );
      _.assert( body2.tail === undefined, 'Body should not have own tail' );
      _.assert( body2.body === undefined, 'Body should not have own body' );
    }
    return body2;
  }

  /* */

  function propertiesBut( src )
  {
    if( !src )
    return src;
    let result = _.props.extend( null, src );
    delete result.head;
    delete result.body;
    delete result.taul;
    // return src ? _.mapBut_( null, src, [ 'head', 'body', 'tail' ] ) : src;
    return result;
  }

  /* */

  /* xxx : make routine? */
  function routineClone( routine )
  {
    _.assert( _.routine.is( routine ) );
    let name = routine.name;
    // const routine2 = routine.bind();
    // _.assert( routine2 !== routine );
    const routine2 =
    ({
      [ name ] : function()
      {
        return routine.apply( this, arguments );
      }
    })[ name ];

    let o2 =
    {
      value : routine,
      enumerable : false,
    };
    Object.defineProperty( routine2, 'originalRoutine', o2 ); /* qqq : for Dmytro : cover */

    return routine2;
  }

  /* */

  function dstFrom( routine )
  {
    return routineClone( routine );
  }

  /* */

}

_amend.defaults =
{
  dst : null,
  srcs : null,
  strategy : 'cloning', /* qqq : for Dmytro : cover */
  amending : 'extending', /* qqq : for Dmytro : implement and cover */
}

//

/**
 * The routine _.routine.extendCloning() is used to copy the values of all properties
 * from source routine to a target routine.
 *
 * It takes first routine (dst), and shallow clone each destination property of type map.
 * Then it checks properties of source routine (src) and extends dst by source properties.
 * The dst properties can be owerwriten by values of source routine
 * if descriptor (writable) of dst property is set.
 *
 * If the first routine (dst) is null then
 * routine _.routine.extendCloning() makes a routine from routines head and body
 * @see {@link wTools.routine.unite} - Automatic routine generating
 * from preparation routine and main routine (body).
 *
 * @param{ routine } dst - The target routine or null.
 * @param{ * } src - The source routine or object to copy.
 *
 * @example
 * var src =
 * {
 *   head : _.routine.s.compose.head,
 *   body : _.routine.s.compose.body,
 *   someOption : 1,
 * }
 * var got = _.routine.extendCloning( null, src );
 * // returns [ routine routinesCompose ], got.option === 1
 *
 * @example
 * _.routine.extendCloning( null, _.routine.s.compose );
 * // returns [ routine routinesCompose ]
 *
 * @example
 * _.routine.extendCloning( _.routine.s.compose, { someOption : 1 } );
 * // returns [ routine routinesCompose ], routinesCompose.someOption === 1
 *
 * @example
 * _.routine.s.composes.someOption = 22;
 * _.routine.extendCloning( _.routine.s.compose, { someOption : 1 } );
 * // returns [ routine routinesCompose ], routinesCompose.someOption === 1
 *
 * @returns { routine } It will return the target routine with extended properties.
 * @function extendCloning
 * @throws { Error } Throw an error if arguments.length < 1 or arguments.length > 2.
 * @throws { Error } Throw an error if dst is not routine or not null.
 * @throws { Error } Throw an error if dst is null and src has not head and body properties.
 * @throws { Error } Throw an error if src is primitive value.
 * @namespace Tools
 */

function extendCloning( dst, ... srcs )
{

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  return _.routine._amend
  ({
    dst,
    srcs : [ ... srcs ],
    strategy : 'cloning',
    amending : 'extending',
  });

}

// qqq : for Dmytro : cover please
function extendInheriting( dst, ... srcs )
{

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  return _.routine._amend
  ({
    dst,
    srcs : [ ... srcs ],
    strategy : 'inheriting',
    amending : 'extending',
  });

}

//
/*qqq : for Dmytro : cover please */
function extendReplacing( dst, ... srcs )
{

  _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  return _.routine._amend
  ({
    dst,
    srcs : [ ... srcs ],
    strategy : 'replacing',
    amending : 'extending',
  });

}

//

function defaults( dst, src, defaults )
{

  if( arguments.length === 2 )
  {
    defaults = arguments[ 1 ];
    _.assert( _.aux.is( defaults ) );
    return _.routine.extend( dst, { defaults } );
  }
  else
  {
    _.assert( arguments.length === 3 );
    _.assert( _.aux.is( defaults ) );
    return _.routine.extend( dst, src, { defaults } );
  }

  // _.assert( dst === null || src === null );
  // _.assert( _.aux.is( defaults ) );
  // return _.routine.extend( dst, src, { defaults } );
}

// --
// unite
// --

function unite_head( routine, args )
{
  let o = args[ 0 ];

  if( args[ 1 ] !== undefined )
  {
    if( args.length === 3 )
    o = { head : args[ 0 ], body : args[ 1 ], tail : args[ 2 ] };
    else
    o = { head : args[ 0 ], body : ( args.length > 1 ? args[ 1 ] : null ) };
  }

  _.routine.optionsWithoutUndefined( routine, o );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 2 );
  _.assert
  (
    o.head === null || _.numberIs( o.head ) || _.routine.is( o.head ) || _.routine.s.are( o.head )
    , 'Expects either routine, routines or number of arguments {-o.head-}'
  );
  _.assert( _.routine.is( o.body ), 'Expects routine {-o.body-}' );
  _.assert( o.tail === null || _.routine.is( o.tail ), () => `Expects routine {-o.tail-}, but got ${_.entity.strType( o.tail )}` );
  _.assert( o.body.defaults !== undefined, 'Body should have defaults' );

  return o;
}

//

function unite_body( o )
{

  if( _.longIs( o.head ) )
  {
    /* xxx : deprecate compose */
    /* qqq : for Dmytro : implement without compose */
    // let _head = _.routine.s.compose( o.head, function( /* args, result, op, k */ )
    // {
    //   let args = arguments[ 0 ];
    //   let result = arguments[ 1 ];
    //   let op = arguments[ 2 ];
    //   let k = arguments[ 3 ];
    //   _.assert( arguments.length === 4 );
    //   _.assert( !_.unrollIs( result ) );
    //   _.assert( _.object.isBasic( result ) );
    //   return _.unrollAppend([ unitedRoutine, [ result ] ]);
    // });
    let _head = _.routine.s.compose( o.head, function( /* args, result, op, k */ )
    {
      let args = arguments[ 0 ];
      let result = arguments[ 1 ];
      let op = arguments[ 2 ];
      let k = arguments[ 3 ];
      _.assert( arguments.length === 4 );
      _.assert( !_.unrollIs( result ) );
      _.assert( _.object.isBasic( result ) );
      return _.unroll.from([ unitedRoutine, [ result ] ]);
    });
    _.assert( _.routine.is( _head ) );
    o.head = function head()
    {
      let result = _head.apply( this, arguments );
      return result[ result.length-1 ];
    }
    o.head.composed = _head.composed;
  }
  else if( _.number.is( o.head ) )
  {
    o.head = headWithNargs_functor( o.head, o.body );
  }

  if( o.head === null )
  {
    /* qqq : for Dmytro : cover please */
    if( o.body.defaults )
    o.head = headWithDefaults;
    else
    o.head = headWithoutDefaults;
  }

  if( !o.name )
  {
    _.assert( _.strDefined( o.body.name ), 'Body routine should have name' );
    o.name = o.body.name;
    if( o.name.indexOf( '_body' ) === o.name.length-5 && o.name.length > 5 )
    o.name = o.name.substring( 0, o.name.length-5 );
  }

  /* generate body */

  /* qqq : for Dmytro : cover in separate test routine */
  let body;
  if( o.strategy === 'replacing' )
  body = o.body;
  else
  body = _.routine._amend
  ({
    dst : null,
    srcs : o.body,
    strategy : o.strategy,
    amending : 'extending',
  });

  /* make routine */

  let unitedRoutine = _unite_functor( o.name, o.head, body, o.tail );

  _.assert( _.strDefined( unitedRoutine.name ), 'Looks like your interpreter does not support dynamic naming of functions. Please use ES2015 or later interpreter.' );

  /* qqq : for Dmytro : cover option::strategy */

  _.routine._amend
  ({
    dst : unitedRoutine,
    srcs : body,
    strategy : 'replacing',
    amending : 'extending',
  });

  unitedRoutine.head = o.head;
  unitedRoutine.body = body;
  if( o.tail )
  unitedRoutine.tail = o.tail;

  _.assert
  (
    unitedRoutine.defaults === body.defaults,
    'Something wrong, united routined should have same instance of defaults its body has'
  );

  return unitedRoutine;

  function headWithNargs_functor( nargs, body )
  {
    _.assert( !!o.body.defaults );
    return function headWithDefaults( routine, args )
    {
      _.assert( args.length <= nargs+1 );
      _.assert( arguments.length === 2 );
      let o = _.routine.options( routine, args[ nargs ] || Object.create( null ) );
      return _.unroll.from([ ... Array.prototype.slice.call( args, 0, nargs ), o ]);
    }
  }

  /* */

  function headWithoutDefaults( routine, args )
  {
    let o = args[ 0 ];
    _.assert( arguments.length === 2 );
    _.assert( args.length === 0 || args.length === 1, () => `Expects optional argument, but got ${args.length} arguments` );
    _.assert( args.length === 0 || o === undefined || o === null || _.auxIs( o ) );
    return o || null;
  }

  /* */

  function headWithDefaults( routine, args )
  {
    let o = args[ 0 ];
    _.assert( arguments.length === 2 );
    _.assert( args.length === 0 || args.length === 1, () => `Expects optional argument, but got ${args.length} arguments` );
    _.assert( args.length === 0 || o === undefined || o === null || _.auxIs( o ) );
    return _.routine.options( routine, o || Object.create( null ) );
  }

  /* */

  function _unite_functor()
  {
    const name = arguments[ 0 ];
    const head = arguments[ 1 ];
    const body = arguments[ 2 ];
    const tail = arguments[ 3 ];
    let r;

    _.assert( head === null || _.routineIs( head ) );
    _.assert( body === null || _.routineIs( body ) );
    _.assert( tail === null || _.routineIs( tail ) );

    if( tail === null )
    r =
    {
      [ name ] : function()
      {
        let result;
        let o = head.call( this, unitedRoutine, arguments );

        _.assert( !_.argumentsArray.is( o ), 'does not expect arguments array' );

        if( _.unrollIs( o ) )
        result = body.apply( this, o );
        else
        result = body.call( this, o );

        return result;
      }
    };
    else if( head === null )
    r =
    {
      [ name ] : function()
      {
        let result;
        let o = arguments[ 0 ];

        _.assert( arguments.length === 1, 'Expects single argument {-o-}.' );

        if( _.unrollIs( o ) )
        result = body.apply( this, o );
        else if( _.mapIs( o ) )
        result = body.call( this, o );
        else
        _.assert( 0, 'Unexpected type of {-o-}, expects options map or unroll.' );

        result = tail.call( this, result, o );

        return result;
      }
    };
    else
    r =
    {
      [ name ] : function()
      {
        let result;
        let o = head.call( this, unitedRoutine, arguments );

        _.assert( !_.argumentsArray.is( o ), 'does not expect arguments array' );

        if( _.unrollIs( o ) )
        result = body.apply( this, o );
        else
        result = body.call( this, o );

        debugger;
        result = tail.call( this, result, o );

        return result;
      }
    };

    return r[ name ]
  }
}

unite_body.defaults =
{
  head : null,
  body : null,
  tail : null,
  name : null,
  strategy : null,
}

//

/* qqq : for Dmytro : write the article. it should explain why, when, what for! */
function uniteCloning()
{
  let o = uniteCloning.head.call( this, uniteCloning, arguments );
  let result = uniteCloning.body.call( this, o );
  return result;
}

uniteCloning.head = unite_head;
uniteCloning.body = unite_body;
uniteCloning.defaults = { ... unite_body.defaults, strategy : 'cloning' };

//

function uniteInheriting()
{
  let o = uniteInheriting.head.call( this, uniteInheriting, arguments );
  let result = uniteInheriting.body.call( this, o );
  return result;
}

uniteInheriting.head = unite_head;
uniteInheriting.body = unite_body;
uniteInheriting.defaults = { ... unite_body.defaults, strategy : 'inheriting' };

//

function uniteReplacing()
{
  let o = uniteReplacing.head.call( this, uniteReplacing, arguments );
  let result = uniteReplacing.body.call( this, o );
  return result;
}

uniteReplacing.head = unite_head;
uniteReplacing.body = unite_body;
uniteReplacing.defaults = { ... unite_body.defaults, strategy : 'replacing' };

//

function _compose_old_head( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { bodies : args[ 0 ] };
  if( args[ 1 ] !== undefined )
  o.chainer = args[ 1 ];

  // if( o.bodies === null )
  // debugger;
  // o.bodies = _.arrayAppendArrays( [], [ o.bodies ] );
  // o.bodies = merge( o.bodies );

  o.bodies = __arrayFlatten( o.bodies );
  o.bodies = o.bodies.filter( ( e ) => e !== null );

  _.routine.options( routine, o );
  _.assert( _.routine.s.are( o.bodies ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( args.length === 1 || !_.object.isBasic( args[ 0 ] ) );
  _.assert( _.arrayIs( o.bodies ) || _.routine.is( o.bodies ) );
  _.assert( _.routine.is( args[ 1 ] ) || args[ 1 ] === undefined || args[ 1 ] === null );
  _.assert( o.chainer === null || _.routine.is( o.chainer ) );
  _.assert( o.tail === null || _.routine.is( o.tail ) );

  return o;

  // function merge( arrays )
  // {
  //   let result = [];
  //   if( arrays === null )
  //   return result;
  //   for( let i = 0 ; i < arrays.length ; i++ )
  //   {
  //     let array = arrays[ i ];
  //     if( _.array.is( array ) || _.argumentsArray.is( array ) )
  //     result.push( ... array );
  //     else
  //     result.push( array );
  //   }
  //   return result;
  // }
}

_compose_old_head.locals =
{
  __arrayFlatten,
}

//

function _compose_old_body( o )
{

  if( o.chainer === null )
  o.chainer = _.routine.chainer.default;

  // if( o.chainer === null )
  // o.chainer = _.routine.chainer.original;
  // o.bodies = __arrayFlatten( o.bodies );

  let bodies = [];
  for( let s = 0 ; s < o.bodies.length ; s++ )
  {
    let src = o.bodies[ s ];
    _.assert( _.routine.is( src ) );
    if( src.composed )
    {
      if( src.composed.chainer === o.chainer && src.composed.tail === o.tail )
      {
        bodies.push( ... src.composed.elements );
      }
      else
      {
        bodies.push( ... src );
      }
    }
    else
    {
      bodies.push( src );
    }
  }

  o.bodies = bodies;

  let tail = o.tail;
  let chainer = o.chainer;
  let act;

  _.assert( _.routine.is( chainer ) );
  _.assert( tail === null || _.routine.is( tail ) );

  /* */

  if( bodies.length === 0 )
  act = function empty()
  {
    return [];
  }
  else act = function composition()
  {
    let result = [];
    let args = _.unroll.from( arguments );
    for( let k = 0 ; k < bodies.length ; k++ )
    {
      // _.assert( _.unrollIs( args ), () => `Expects unroll, but got ${_.entity.strType( args )}` );
      let routine = bodies[ k ];
      let r = routine.apply( this, args );
      _.assert( !_.argumentsArray.is( r ) );
      if( r !== undefined )
      _.unrollAppend( result, r );
      args = chainer( args, r, o, k );
      _.assert( args !== undefined && args !== false );
      if( args === _.dont )
      break;
      args = _.unroll.from( args );
    }
    return result;
  }

  o.act = act;
  act.composed = o;

  if( tail )
  {
    _.routine.extend( compositionSupervise, act );
    return compositionSupervise;
  }

  return act;

  function compositionSupervise()
  {
    // let result = tail( this, arguments, act, o );
    let result = tail.call( this, arguments, o );
    return result;
  }
}

_compose_old_body.defaults =
{
  bodies : null,
  chainer : null,
  tail : null,
}

//

function compose_old()
{
  let o = _.routine.s.compose_old.head( compose_old, arguments );
  let result = _.routine.s.compose_old.body( o );
  return result;
}

compose_old.head = _compose_old_head;
compose_old.body = _compose_old_body;
compose_old.defaults = Object.assign( Object.create( null ), compose_old.body.defaults );

//

function _compose_head( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { bodies : args[ 0 ] };
  if( args[ 1 ] !== undefined )
  o.chainer = args[ 1 ];

  // if( o.bodies === null )
  // debugger;
  // o.bodies = _.arrayAppendArrays( [], [ o.bodies ] );
  // o.bodies = merge( o.bodies );

  // let bodies2 = __arrayFlatten( o.bodies );
  // if( bodies2.length && bodies2[ 0 ] === undefined )
  // debugger;

  o.bodies = __arrayFlatten( o.bodies );
  o.bodies = o.bodies.filter( ( e ) => e !== null );

  _.routine.options( routine, o );
  _.assert( _.routine.s.are( o.bodies ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( args.length === 1 || !_.object.isBasic( args[ 0 ] ) );
  _.assert( _.arrayIs( o.bodies ) || _.routine.is( o.bodies ) );
  _.assert( _.routine.is( args[ 1 ] ) || args[ 1 ] === undefined || args[ 1 ] === null );
  _.assert( o.chainer === null || _.routine.is( o.chainer ) );
  _.assert( o.tail === null || _.routine.is( o.tail ) );

  return o;

  // function merge( arrays )
  // {
  //   let result = [];
  //   if( arrays === null )
  //   return result;
  //   for( let i = 0 ; i < arrays.length ; i++ )
  //   {
  //     let array = arrays[ i ];
  //     if( _.array.is( array ) || _.argumentsArray.is( array ) )
  //     result.push( ... array );
  //     else
  //     result.push( array );
  //   }
  //   return result;
  // }
}

_compose_head.locals =
{
  __arrayFlatten,
}

//

function _compose_body( o )
{

  // if( o.chainer === null )
  // o.chainer = defaultChainer;
  // o.bodies = __arrayFlatten( o.bodies );
  if( o.chainer === null )
  o.chainer = _.routine.chainer.default;

  let bodies = [];
  for( let s = 0 ; s < o.bodies.length ; s++ )
  {
    let body = o.bodies[ s ];
    _.assert( _.routine.is( body ) );
    if( body.composed )
    {
      if( body.composed.chainer === o.chainer && body.composed.tail === o.tail )
      {
        bodies.push( ... body.composed.elements );
      }
      else
      {
        bodies.push( ... body );
      }
    }
    else
    {
      bodies.push( body );
    }
  }

  o.bodies = bodies;

  let tail = o.tail;
  let chainer = o.chainer;

  _.assert( _.routine.is( chainer ) );
  _.assert( tail === null || _.routine.is( tail ) );

  /* */

  if( bodies.length === 0 )
  o.act = compositionEmpty;
  else if( bodies.length === 1 )
  o.act = compositionOfSingle;
  else
  o.act = composition;

  o.act.composed = o;

  if( tail )
  {
    _.routine.extendReplacing( routineWithTail, o.act );
    return routineWithTail;
  }

  return o.act;

  /* */

  function compositionEmpty()
  {
    return [];
  }

  function compositionOfSingle()
  {
    let result = [];
    let args = _.unroll.from( arguments );
    // _.assert( _.unrollIs( args ), () => `Expects unroll, but got ${_.entity.strType( args )}` );
    let routine = bodies[ 0 ];
    let r = routine.apply( this, args );
    _.assert( !_.argumentsArray.is( r ) );
    if( r !== undefined )
    _.unrollAppend( result, r );
    return result;
  }

  function composition()
  {
    let result = [];
    let args = _.unroll.from( arguments );
    for( let k = 0 ; k < bodies.length ; k++ )
    {
      // _.assert( _.unrollIs( args ), () => `Expects unroll, but got ${_.entity.strType( args )}` );
      let routine = bodies[ k ];
      let r = routine.apply( this, args );
      _.assert( !_.argumentsArray.is( r ) );
      if( r !== undefined )
      _.unrollAppend( result, r );
      args = chainer( args, r, o, k );
      if( args === _.dont )
      break;
      _.assert( _.unroll.is( args ) );
    }
    return result;
  }

  // function defaultChainer( /* args, result, op, k */ )
  // {
  //   let args = arguments[ 0 ];
  //   let result = arguments[ 1 ];
  //   let op = arguments[ 2 ];
  //   let k = arguments[ 3 ];
  //   if( result === _.dont )
  //   return result;
  //   return args;
  // }

  function routineWithTail()
  {
    let result = tail.call( this, arguments, o );
    return result;
  }
}

_compose_body.defaults =
{
  chainer : null,
  bodies : null,
  tail : null,
}

//

function compose()
{
  let o = _.routine.s.compose.head( compose, arguments );
  let result = _.routine.s.compose.body( o );
  return result;
}

compose.head = _compose_head;
compose.body = _compose_body;
compose.defaults = _compose_body.defaults;

// --
// chainers
// --

function defaultChainer( /* args, result, op, k */ )
{
  let args = arguments[ 0 ];
  let result = arguments[ 1 ];
  let op = arguments[ 2 ];
  let k = arguments[ 3 ];
  if( result === _.dont )
  return result;
  return args;
}

// --
// declaration
// --

let ChainerExtension =
{
  default : defaultChainer,
}

Object.assign( _.routine.chainer, ChainerExtension );

// --
// routine extension
// --

let RoutineExtension =
{

  // fields

  NamespaceName : 'routine',
  NamespaceNames : [ 'routine' ],
  NamespaceQname : 'wTools/routine',
  TypeName : 'Routine',
  TypeNames : [ 'Routine', 'Function' ],
  // SecondTypeName : 'Function',
  InstanceConstructor : null,
  tools : _,

  // dichotomy

  is,
  _is,
  like,
  _like,
  isTrivial,
  isSync,
  isAsync,
  isGenerator,
  isSyncGenerator,
  isAsyncGenerator,
  withName,

  // joiner

  _join,
  constructorJoin,
  join,
  seal,

  // option

  optionsWithoutUndefined,
  assertOptionsWithoutUndefined,
  optionsWithUndefined,
  optionsWithUndefinedTollerant,
  assertOptionsWithUndefined,
  options : optionsWithUndefined,
  assertOptions : assertOptionsWithUndefined,
  options_ : optionsWithUndefined,
  optionsTollerant : optionsWithUndefinedTollerant,
  assertOptions_ : assertOptionsWithUndefined,
  _verifyDefaults,

  // options_deprecated,
  // assertOptions_deprecated,
  // optionsPreservingUndefines_deprecated,
  // assertOptionsPreservingUndefines_deprecated,

  // amend

  _amend,
  extend : extendCloning,
  extendCloning,
  extendInheriting,
  extendReplacing,
  defaults,

  // unite

  unite : uniteReplacing,
  uniteCloning,
  uniteCloning_replaceByUnite : uniteCloning,
  uniteInheriting,
  uniteReplacing,
  /* qqq : cover routines uniteReplacing, uniteInheriting, uniteCloning */

}

Object.assign( _.routine, RoutineExtension );

// --
// routines extension
// --

let RoutinesExtension =
{

  are,
  compose_old,
  compose,

}

Object.assign( _.routines, RoutinesExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  routineIs : is.bind( _.routine ),
  _routineIs : _is.bind( _.routine ),
  routineLike : like.bind( _.routine ),
  _routineLike : _like.bind( _.routine ),
  routineIsTrivial : isTrivial.bind( _.routine ),
  routineIsSync : isSync.bind( _.routine ),
  routineIsAsync : isAsync.bind( _.routine ),
  routinesAre : are.bind( _.routine ),
  routineWithName : withName.bind( _.routine ),

  routineIsGenerator : isGenerator.bind( _.routine ),
  routineIsSyncGenerator : isSyncGenerator.bind( _.routine ),
  routineIsAsyncGenerator : isAsyncGenerator.bind( _.routine ),

  _routineJoin : _join.bind( _.routine ),
  constructorJoin : constructorJoin.bind( _.routine ),
  routineJoin : join.bind( _.routine ),
  routineSeal : seal.bind( _.routine ),

  routineExtend : extendCloning.bind( _.routine ),
  routineDefaults : defaults.bind( _.routine ),

  routinesCompose : compose.bind( _.routines ), /* xxx : review */

}

Object.assign( _, ToolsExtension );

//

})();

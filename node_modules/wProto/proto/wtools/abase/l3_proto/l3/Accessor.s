( function _Accessor_s_() {

'use strict';

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

/**
 * @summary Collection of getters
 * @namespace wTools.accessor.getter
 * @extends Tools.accessor
 * @module Tools/base/Proto
 */

 /**
 * @summary Collection of setters
 * @namespace wTools.accessor.setter
 * @extends Tools.accessor
 * @module Tools/base/Proto
 */

 /**
 * @summary Collection of putters
 * @namespace wTools.accessor.putter
 * @extends Tools.accessor
 * @module Tools/base/Proto
 */

/**
 * @summary Collection of setters
 * @namespace wTools.accessor.suite
 * @extends Tools.accessor
 * @module Tools/base/Proto
 */

// --
// declare
// --

/**
 * Registers provided accessor.
 * Writes accessor's descriptor into accessors map of the prototype ( o.proto ).
 * Supports several combining methods: `rewrite`, `supplement`, `append`.
 *  * Adds diagnostic information to descriptor if running in debug mode.
 * @param {Object} o - options map
 * @param {String} o.name - accessor's name
 * @param {Object} o.proto - target prototype object
 * @param {String} o.declaratorName
 * @param {Array} o.declaratorArgs
 * @param {String} o.declaratorKind
 * @param {String} o.combining - combining method
 * @private
 * @function _register
 * @namespace Tools.accessor
 */

function _register( o )
{

  _.routine.options_( _register, arguments );
  _.assert( _.workpiece.prototypeIsStandard( o.proto ), 'Expects formal prototype' );
  _.assert( _.strDefined( o.declaratorName ) );
  _.assert( _.arrayIs( o.declaratorArgs ) );
  _.workpiece.fieldsGroupFor( o.proto, '_Accessors' );

  let accessors = o.proto._Accessors;

  if( o.combining && o.combining !== 'rewrite' && o.combining !== 'supplement' )
  debugger;

  if( Config.debug )
  if( !o.combining )
  {
    let stack = accessors[ o.name ] ? accessors[ o.name ].stack : '';
    _.assert
    (
      !accessors[ o.name ],
      'defined at' + '\n',
      stack,
      '\naccessor', o.name, 'of', o.proto.constructor.name
    );
    if( accessors[ o.name ] )
    debugger;
  }

  _.assert( !o.combining || o.combining === 'rewrite' || o.combining === 'append' || o.combining === 'supplement', 'not supported ( o.combining )', o.combining );
  _.assert( _.strIs( o.name ) );

  if( accessors[ o.name ] && o.combining === 'supplement' )
  return;

  let descriptor =
  {
    name : o.name,
    declaratorName : o.declaratorName,
    declaratorArgs : o.declaratorArgs,
    declaratorKind : o.declaratorKind,
    combining : o.combining,
  }

  // yyy
  // if( Config.debug )
  // descriptor.stack = _.introspector.stack();

  if( o.combining === 'append' )
  {
    if( _.arrayIs( accessors[ o.name ] ) )
    accessors[ o.name ].push( descriptor );
    else
    accessors[ o.name ] = [ descriptor ];
  }

  accessors[ o.name ] = descriptor;

  return descriptor;
}

_register.defaults =
{
  name : null,
  proto : null,
  declaratorName : null,
  declaratorArgs : null,
  declaratorKind : null,
  combining : 0,
}

//

/**
 * @summary Supplements target object( dst ) with accessors from source object( src ).
 *
 * @description
 * Both objects should have accessorts map defined.
 * Ignores accessor that is already declared on destination object( dst ).
 *
 * @param {Object} src - source object
 * @param {Object} dst - destination object
 *
 * @throws {Exception} If number of arguments is not supported.
 * @throws {Exception} If combining method of source accessor is unknown.
 * @throws {Exception} If accessor.declaratorArgs is not a Array.
 * @throws {Exception} If one of object doesn't have _Accessors map
 * @function supplement
 *
 * @namespace Tools.accessor
 */

function supplement( dst, src )
{

  _.workpiece.fieldsGroupFor( dst, '_Accessors' );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( Object.hasOwnProperty.call( dst, '_Accessors' ), 'supplement : dst should has _Accessors map' );
  _.assert( Object.hasOwnProperty.call( src, '_Accessors' ), 'supplement : src should has _Accessors map' );

  /* */

  for( let a in src._Accessors )
  {

    let accessor = src._Accessors[ a ];

    if( _.object.isBasic( accessor ) )
    supplement( a, accessor );
    else for( let i = 0 ; i < accessor.length ; i++ )
    supplement( a, accessor[ i ] );

  }

  /* */

  function supplement( name, accessor )
  {

    _.assert( _.arrayIs( accessor.declaratorArgs ) );
    _.assert( !accessor.combining || accessor.combining === 'rewrite' || accessor.combining === 'supplement' || accessor.combining === 'append', 'not implemented' );

    if( _.object.isBasic( dst._Accessors[ name ] ) )
    return;

    if( accessor.declaratorName !== 'accessor' )
    {
      _.assert( _.routineIs( dst[ accessor.declaratorName ] ), 'dst does not have accessor maker', accessor.declaratorName );
      dst[ accessor.declaratorName ].apply( dst, accessor.declaratorArgs );
    }
    else
    {
      _.assert( accessor.declaratorArgs.length === 1 );
      let optionsForAccessor = _.props.extend( null, accessor.declaratorArgs[ 0 ] );
      optionsForAccessor.object = dst;
      if( !optionsForAccessor.methods )
      optionsForAccessor.methods = dst;
      _.accessor.declare( optionsForAccessor );
    }

  }

}

// --
// etc
// --

/**
 * Returns true if source object( proto ) has accessor with name( name ).
 * @param {Object} proto - target object
 * @param {String} name - name of accessor
 * @function has
 * @namespace Tools.accessor
 */

function has( proto, name )
{
  let accessors = proto._Accessors;
  if( !accessors )
  return false;
  return !!accessors[ name ];
}

//

function suiteMakerFrom_functor( fop )
{

  if( arguments.length === 2 )
  fop = { getterFunctor : arguments[ 0 ], setterFunctor : arguments[ 1 ] }

  _.routine.options_( suiteMakerFrom_functor, fop );

  let defaults;
  if( fop.getterFunctor )
  defaults = _.props.extend( null, fop.getterFunctor.defaults );
  else
  defaults = _.props.extend( null, fop.setterFunctor.defaults );

  if( Config.debug )
  {
    if( fop.getterFunctor )
    _.entity.identicalShallow( defaults, _.props.extend( null, fop.getterFunctor.defaults ) )
    // _.assert( _.entityIdentical( defaults, _.props.extend( null, fop.getterFunctor.defaults ) ) );
    if( fop.setterFunctor )
    _.entity.identicalShallow( defaults, _.props.extend( null, fop.setterFunctor.defaults ) )
    // _.assert( _.entityIdentical( defaults, _.props.extend( null, fop.setterFunctor.defaults ) ) );
    /* xxx : use _.identicalShallow() */
  }

  let _head = fop.getterFunctor.head || fop.setterFunctor.head;
  if( _head )
  accessorMaker.head = head;

  accessorMaker.defaults = defaults;

  return accessorMaker;

  /* */

  function head( routine, args )
  {
    let o2 = _head( routine, args );
    return o2;
  }

  /* */

  function accessorMaker( o )
  {
    let r = Object.create( null );

    if( _head )
    o = head( accessorMaker, arguments );
    else
    o = _.routine.options_( accessorMaker, arguments );

    if( fop.setterFunctor )
    if( fop.setterFunctor.body )
    r.set = fop.setterFunctor.body( o );
    else
    r.set = fop.setterFunctor( o );

    if( fop.getterFunctor )
    if( fop.getterFunctor.body )
    r.get = fop.getterFunctor.body( o );
    else
    r.get = fop.getterFunctor( o );

    return r;
  }

}

suiteMakerFrom_functor.defaults =
{
  getterFunctor : null,
  setterFunctor : null,
}

// --
// meta
// --

function _DefinesGenerate( dst, src, kind )
{
  if( dst === null )
  dst = Object.create( null );

  _.assert( arguments.length === 3 );

  for( let s in src )
  {
    dst[ s ] = _DefineGenerate( src[ s ], kind );
  }

  return dst;
}

//

function _DefineGenerate( original, kind )
{
  _.assert( _.routineIs( original ) );

  let r =
  {
    [ original.name ] : function()
    {
      let definition = _.define[ kind ]({ val : arguments, routine : original });
      _.assert( _.definitionIs( definition ) );
      return definition;
    }
  }

  let routine = r[ original.name ];

  _.routineExtend( routine, original );
  _.assert( arguments.length === 2 );

  routine.originalFunctor = original;

  _.assert( _.routineIs( _.define[ kind ] ) );

  return routine;
}

// --
// relations
// --

let DefaultAccessorsMap = Object.create( null );
DefaultAccessorsMap.Accessors = _.accessor.declare;
DefaultAccessorsMap.Forbids = _.accessor.forbid;
DefaultAccessorsMap.AccessorsForbid = _.accessor.forbid;
DefaultAccessorsMap.AccessorsReadOnly = _.accessor.readOnly;

_.assert( _.routineIs( _.accessor.declare ) );
_.assert( _.routineIs( _.accessor.forbid ) );
_.assert( _.routineIs( _.accessor.readOnly ) );

let Forbids =
{
  _ArrayDescriptor : '_ArrayDescriptor',
  ArrayDescriptor : 'ArrayDescriptor',
  _ArrayDescriptors : '_ArrayDescriptors',
  ArrayDescriptors : 'ArrayDescriptors',
  arrays : 'arrays',
  arrayOf : 'arrayOf',
}

//

let AccessorExtension =
{

  // declare

  _register,

  supplement,

  // etc

  has,

  // meta

  suiteMakerFrom_functor,
  _DefinesGenerate,
  _DefineGenerate,

  // fields

  DefaultAccessorsMap,

}

//

let ToolsExtension =
{
}

// --
// extend
// --

_.accessor = _.accessor || Object.create( null );
_.props.supplement( _, ToolsExtension );
/* _.props.extend */Object.assign( _.accessor, AccessorExtension );

_.accessor.forbid( _, Forbids );
_.accessor.forbid( _.accessor, Forbids );

_.accessor.getter = _.accessor.getter || Object.create( null );
_.accessor.graber = _.accessor.graber || Object.create( null );
_.accessor.setter = _.accessor.setter || Object.create( null );
_.accessor.putter = _.accessor.putter || Object.create( null );
_.accessor.suite = _.accessor.suite || Object.create( null );
_.accessor.define = _.accessor.define || Object.create( null );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

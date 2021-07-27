( function _Define_s_() {

'use strict';

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

/**
* Creates property-like entity with getter that returns reference to source object.
* @param {Object-like|Long} src - source value
* @returns {module:Tools/base/Proto.wTools.define.Definition}
* @function common
* @namespace Tools.define
*/

function common( src )
{
  let o2 = { val : src }
  o2.defGroup = 'definition.named';
  let definition = new _.Definition( o2 );

  _.assert( src !== undefined, () => 'Expects object-like or long, but got ' + _.entity.strType( src ) );
  _.assert( arguments.length === 1 );
  _.assert( definition.val !== undefined );

  // definition.toVal = function get() { debugger; return this.val }
  definition.toVal = function get( val ) { return val }

  _.props.conceal( definition, 'toVal' );

  Object.freeze( definition );
  return definition;
}

//

/**
* Creates property-like entity with getter that returns shallow copy of source object.
* @param {Object-like|Long} src - source value
* @returns {module:Tools/base/Proto.wTools.define.Definition}
* @function own
* @namespace Tools.define
*/

function own( src )
{
  let o2 = { val : src }
  o2.defGroup = 'definition.named';
  let definition = new _.Definition( o2 );

  _.assert( src !== undefined, () => 'Expects object-like or long, but got ' + _.entity.strType( src ) );
  _.assert( arguments.length === 1 );
  _.assert( definition.val !== undefined );

  definition.toVal = function get( val ) { return _.cloneJust( val ) };
  // definition.toVal = function get( val ) { return _.entity.cloneDeep( val ) }; /* xxx0 : use replicator */

  _.props.conceal( definition, 'toVal' );

  Object.freeze( definition );
  return definition;
}

//

/**
* Creates property-like entity with getter that returns new instance of source constructor.
* @param {Function} src - source constructor
* @returns {module:Tools/base/Proto.wTools.define.Definition}
* @function instanceOf
* @namespace Tools.define
*/

function instanceOf( src )
{
  let o2 = { val : src }
  o2.defGroup = 'definition.named';
  let definition = new _.Definition( o2 );

  _.assert( _.routineIs( src ), 'Expects constructor' );
  _.assert( arguments.length === 1 );
  _.assert( definition.val !== undefined );

  // definition.toVal = function get() { return new this.val() };
  definition.toVal = function get( val ) { return new val() };

  _.props.conceal( definition, 'toVal' );

  Object.freeze( definition );
  return definition;
}

//

/**
* Creates property-like entity with getter that returns result of source routine call.
* @param {Function} src - source routine
* @returns {module:Tools/base/Proto.wTools.define.Definition}
* @function makeWith
* @namespace Tools.define
*/

function makeWith( src )
{
  let o2 = { val : src }
  o2.defGroup = 'definition.named';
  let definition = new _.Definition( o2 );

  _.assert( _.routineIs( src ), 'Expects constructor' );
  _.assert( arguments.length === 1 );
  _.assert( definition.val !== undefined );

  // definition.toVal = function get() { return this.val() }
  definition.toVal = function get( val ) { return val() };

  _.props.conceal( definition, 'toVal' );

  Object.freeze( definition );
  return definition;
}

//

/**
* @param {Object} src
* @returns {module:Tools/base/Proto.wTools.define.Definition}
* @function contained
* @namespace Tools.define
*/

function contained( src )
{

  _.assert( _.mapIs( src ) );
  _.assert( arguments.length === 1 );
  _.assert( src.val !== undefined );

  let container = _.mapBut_( null, src, contained.defaults );
  let o = _.mapOnly_( null, src, contained.defaults );
  o.container = container;
  o.val = src.val;
  o.defGroup = 'definition.named';
  let definition = new _.Definition( o );

  if( o.shallowCloning )
  definition.toVal = function get( val )
  {
    let result = _.props.extend( null, container );
    result.value = _.entity.make( val );
    return result;
  }
  else
  definition.toVal = function get( val )
  {
    let result = _.props.extend( null, container );
    result.value = val;
    return result;
  }

  _.props.conceal( definition, 'toVal' );
  Object.freeze( definition );
  _.assert( definition.val !== undefined );
  return definition;
}

contained.defaults =
{
  val : null,
  shallowCloning : 0,
}

//

function accessor( o )
{

  if( _.routineIs( o ) )
  o = { routine : arguments[ 0 ] }

  _.routine.options_( accessor, o );

  o.defGroup = 'definition.named';
  o.subKind = 'accessor';
  // o.constructionAmend = constructionAmend;
  o.toVal = toVal;

  _.assert( _.routineIs( o.routine ) );
  _.assert( arguments.length === 1 );

  let definition = new _.Definition( o );
  _.props.conceal( definition, 'constructionAmend' );
  _.assert( definition.val !== undefined );
  return definition;

  /* */

  function toVal( val )
  {
    _.assert( _.routineIs( val ) );
    return val;
  }

  /* */

  // function constructionAmend( dst, key, amend )
  // {
  //   _.assert( 0, 'deprecated' );
  //   let instanceIsStandard = _.workpiece.instanceIsStandard( dst );
  //   _.assert( arguments.length === 3 );
  //
  //   let args = []
  //   for( let i = 0 ; i < o.val.length ; i++ )
  //   args[ i ] = _.entity.cloneShallow( o.val[ i ] );
  //   let o2;
  //   if( o.routine.head )
  //   {
  //     o2 = o.routine.head( o.routine, args );
  //   }
  //   else
  //   {
  //     debugger;
  //     _.assert( args.length === 1 );
  //     o2 = args[ 0 ];
  //   }
  //
  //   _.assert( _.mapIs( o2 ) );
  //
  //   if( o.routine.defaults.propName !== undefined )
  //   if( o2.propName === undefined || o2.propName === null )
  //   {
  //     _.assert( 0, 'not tested' ); /* zzz : test */
  //     o2.propName = key;
  //   }
  //
  //   let r;
  //   if( o.routine.body )
  //   r = o.routine.body( o2 );
  //   else
  //   r = o.routine( o2 );
  //
  //   if( _.boolLike( o.get ) && !o.get && o.set === null )
  //   {
  //     if( _.routineIs( r ) )
  //     {
  //       o.set = r;
  //       if( o.put === null || _.boolLikeTrue( o.put ) )
  //       o.put = r;
  //     }
  //     else if( _.mapIs( r ) )
  //     {
  //       o.set = r.set;
  //       if( o.put === null || _.boolLikeTrue( o.put ) )
  //       if( r.put )
  //       o.put = r.put;
  //     }
  //     else _.assert( 0 );
  //   }
  //   else if( _.boolLike( o.set ) && !o.set && o.get === null )
  //   {
  //     if( _.routineIs( r ) )
  //     o.get = r;
  //     else if( _.mapIs( r ) )
  //     o.get = r.get
  //     else _.assert( 0 );
  //   }
  //   else
  //   {
  //     if( _.mapIs( r ) )
  //     {
  //       if( o.get === null || _.boolLikeTrue( o.get ) )
  //       o.get = r.get;
  //       if( o.set === null || _.boolLikeTrue( o.set ) )
  //       o.set = r.set;
  //       if( o.put === null || _.boolLikeTrue( o.put ) )
  //       o.put = r.put;
  //     }
  //   }
  //
  //   _.assert( _.boolLikeFalse( o.get ) || _.routineIs( o.get ) );
  //   _.assert( _.boolLikeFalse( o.set ) || _.routineIs( o.set ) );
  //
  //   _.accessor.declare
  //   ({
  //     object : dst,
  //     names : key,
  //     grab : o.grab,
  //     get : o.get,
  //     put : o.put,
  //     set : o.set,
  //     prime : instanceIsStandard,
  //     strict : instanceIsStandard,
  //   });
  //
  // }

  /* */

}

accessor.defaults =
{
  val : null,
  routine : null,
  grab : null,
  get : null,
  put : null,
  set : null,
}



function getter( o )
{

  if( _.routineIs( o ) )
  o = { routine : arguments[ 0 ] }

  _.routine.options_( getter, o );

  o.get = null;
  o.put = false;
  o.set = false;

  return _.define.accessor( o );
}

getter.defaults =
{
  val : null,
  routine : null,
}



function setter( o )
{

  if( _.routineIs( o ) )
  o = { routine : arguments[ 0 ] }

  _.routine.options_( setter, o );

  o.get = false;
  o.put = null;
  o.set = null;

  return _.define.accessor( o );
}

setter.defaults =
{
  val : null,
  routine : null,
}

//

function putter( o )
{

  if( _.routineIs( o ) )
  o = { routine : arguments[ 0 ] }

  _.routine.options_( putter, o );

  o.get = false;
  o.set = false;
  o.put = null;

  return _.define.accessor( o );
}

putter.defaults =
{
  val : null,
  routine : null,
}

// --
// define
// --

/**
* Collection of definitions for constructions.
* @namespace wTools.define
* @extends Tools
* @module Tools/base/Proto
*/

let DefineExtension =
{

  // field,
  common,
  own,
  instanceOf,
  makeWith,
  contained,

  accessor,
  getter,
  setter,
  putter,

}

_.define = _.define || Object.create( null );
/* _.props.extend */Object.assign( _.define, DefineExtension );

//

/**
* Routines to manipulate definitions.
* @namespace wTools.definition
* @extends Tools
* @module Tools/base/Proto
*/

let DefinitionExtension =
{
}

_.definition = _.definition || Object.create( null );
/* _.props.extend */Object.assign( _.definition, DefinitionExtension );
_.assert( _.routineIs( _.definitionIs ) );
_.assert( _.definition.is === _.definitionIs );

//

let ToolsExtension =
{
}

_.props.extend( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

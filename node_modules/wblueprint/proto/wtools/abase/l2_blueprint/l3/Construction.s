( function _Construction_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function isTyped( construction )
{
  _.assert( arguments.length === 1 );

  if( !construction )
  return false;

  let next = construction;
  do
  {
    construction = next
    next = Object.getPrototypeOf( construction );
  }
  while( next )

  if( construction !== _.Construction.prototype )
  return false;

  return true;
}

//

function isInstanceOf( construction, runtime )
{

  if( _.blueprint.isDefinitive( runtime ) )
  runtime = runtime.runtime;

  _.assert( arguments.length === 2 );
  _.assert( _.blueprint.isRuntime( runtime ) );
  _.assert( _.fuzzyLike( runtime.typed ) );
  _.assert( _.routineIs( runtime.make ) );

  if( !construction )
  return false;

  if( runtime.typed && runtime.make.prototype !== null )
  {
    return construction instanceof runtime.make;
  }

  if( _.mapIs( construction ) )
  return _.maybe;
  return false;
}

//

function amend( o )
{
  o = _.routine.options_( amend, arguments );
  if( o.dstConstruction === null )
  o.dstConstruction = Object.create( null );
  let amending = o.amending;

  let blueprint = _.blueprint.singleAt( o.src ).blueprint;

  if( !blueprint )
  {
    let defs = [];
    let prototype = _.prototype.of( o.dstConstruction );
    let add = o.amending === 'supplement' ? 'push' : 'unshift';

    defs[ add ]( o.src );

    {
      let opts = Object.create( null );
      opts.val = _.maybe;
      if( prototype && prototype !== Object.prototype )
      {
        opts.prototype = prototype;
        opts.new = false;
      }
      opts._synthetic = o.dstConstruction;
      defs[ add ]( _.trait.typed( opts ) );
    }

    defs[ add ]( _.trait.extendable( true ) );

    blueprint = _.blueprint._define({ src : defs, amending : o.amending });
  }

  constructionBlueprintExtend( o.dstConstruction, blueprint, null );

  return o.dstConstruction;

  /* */

  function constructionBlueprintExtend( dstConstruction, blueprint, name )
  {
    _.assert( !_.blueprint.is( dstConstruction ) );
    _.construction._retype
    ({
      construction : dstConstruction,
      runtime : blueprint.runtime,
      amending,
    });
  }

  /* */

}

amend.defaults =
{
  dstConstruction : null,
  src : null,
  amending : 'extend',
}

//

/* zzz qqq : cover and extend */
function extend( dstConstruction, src )
{
  return _.construction.amend
  ({
    dstConstruction,
    src,
    amending : 'extend'
  });
}

//

/* zzz qqq : cover and extend */
function supplement( dstConstruction, src )
{
  return _.construction.amend
  ({
    dstConstruction,
    src,
    amending : 'supplement'
  });
}

//

function _amendCant( construction, definition, key )
{
  throw _.err
  (
    `Definition::${definition.kind} cant extend created construction after initialization.`
    + ` Use this definition during initialization only.`
  );
}

// --
// make
// --

function _make_head( routine, args )
{
  let genesis;

  if( args.length === 3 )
  {
    genesis = Object.create( null );
    genesis.construction = args[ 0 ];
    genesis.runtime = args[ 1 ];
    genesis.args = args[ 2 ];
    if( args[ 2 ][ 0 ] )
    {
      genesis.construction = args[ 2 ][ 0 ];
    }
    else if( !_.construction.isInstanceOf( genesis.construction, genesis.runtime ) )
    {
      _.assert( !( genesis.construction instanceof genesis.runtime.retype ), 'Use no "new" to call routine::from' );
      genesis.construction = null;
    }
  }
  else
  {
    genesis = args[ 0 ];
    _.assert( _.mapIs( genesis ) );
  }

  _.routine.options_( routine, genesis );

  if( genesis.args === null )
  genesis.args = [];

  if( Config.debug )
  {
    let isInstance = _.construction.isInstanceOf( genesis.construction, genesis.runtime );
    _.assert( args.length === 1 || args.length === 3 );
    _.assert( !( genesis.construction instanceof genesis.runtime.retype ), 'Use no "new" to call routine::from' );
    _.assert( genesis.args.length === 0 || genesis.args.length === 1 );
    _.assert( genesis.runtime.makeCompiled === undefined, 'not implemented' );
  }

  return genesis;
}

//

function _make3( genesis )
{

  if( genesis.args === undefined || genesis.args === null )
  genesis.args = [];

  _.routine.assertOptions( _make3, arguments );
  _.assert( genesis.construction === null || _.object.isBasic( genesis.construction ) );
  _.assert( _.argumentsArray.like( genesis.args ) );
  _.assert( genesis.args.length === 0 || genesis.args.length === 1 );
  _.assert( arguments.length === 1 );
  _.assert( _.fuzzyIs( genesis.runtime.typed ) );

  if( genesis.constructing === 'retype' )
  {
    genesis.construction = genesis.runtime._practiceMap.retype( genesis );
  }
  else if( genesis.constructing === 'allocate' )
  {
    let wasNull = genesis.construction === null
    genesis.construction = genesis.runtime._practiceMap.allocate( genesis );
    _.assert
    (
      !!genesis.runtime.typed === false
      || genesis.runtime.make.prototype === null
      || genesis.construction instanceof genesis.runtime.make
    );
    if( !!genesis.runtime.typed && wasNull )
    return genesis.construction;
  }
  else _.assert( genesis.constructing === false );

  _.construction._init( genesis );
  _.construction._extendArguments( genesis );

  return genesis.construction;
}

_make3.defaults =
{
  constructing : null,
  construction : null,
  amending : null,
  args : null,
  runtime : null,
}

//

function _make2( construction, runtime, args )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );

  let genesis = Object.create( null );
  genesis.construction = construction;
  genesis.args = args;
  genesis.runtime = runtime;
  genesis.constructing = 'allocate';
  genesis.amending = 'extend';

  return _.construction._make3( genesis );
}

//

function _make( construction, runtime, args )
{

  _.assert( arguments.length === 3 );

  if( !runtime.typed && runtime.make.prototype !== null && construction instanceof runtime.make )
  {
    construction = null;
  }
  else if( _.construction.isInstanceOf( construction, runtime ) )
  {
  }
  else
  {
    construction = null;
  }

  _.assert( !runtime.makeCompiled, 'not tested' );

  construction = _.construction._make2( construction, runtime, args );

  return construction;
}

//

function _makeEach( construction, runtime, args )
{
  let result = [];
  _.assert( arguments.length === 3 );
  for( let a = 0 ; a < args.length ; a++ )
  {
    let construction = runtime.make( args[ a ] );
    if( construction !== undefined )
    result.push( construction );
  }
  return result;
}

//

function _from( construction, runtime, args )
{

  if( Config.debug )
  {
    let isInstance = _.construction.isInstanceOf( construction, runtime );
    _.assert( arguments.length === 3 );
    _.assert( isInstance === false || isInstance === _.maybe );
    _.assert( runtime.make.prototype === null || !( construction instanceof runtime.make ) );
    _.assert( !( construction instanceof runtime.from ), 'Use no "new" to call routine::from' );
  }

  if( _.construction.isInstanceOf( args[ 0 ], runtime ) )
  {
    _.assert( args.length === 1 );
    construction = args[ 0 ];
    return construction;
  }
  else
  {
    construction = null;
  }

  _.assert( !runtime.makeCompiled, 'not tested' );
  construction = _.construction._make2( construction, runtime, args );

  return construction;
}

//

function _fromEach( construction, runtime, args )
{
  let result = [];
  _.assert( arguments.length === 3 );
  for( let a = 0 ; a < args.length ; a++ )
  {
    let construction = runtime.from( args[ a ] );
    if( construction !== undefined )
    result.push( construction );
  }
  return result;
}

//

function _retype_body( genesis )
{

  if( Config.debug )
  {
    let isInstance = _.construction.isInstanceOf( genesis.construction, genesis.runtime );
    _.assert( arguments.length === 1 );
    _.assert( !( genesis.construction instanceof genesis.runtime.retype ), 'Use no "new" to call routine::from' );
    _.assert( genesis.args.length === 0 || genesis.args.length === 1 );
    _.assert( genesis.runtime.makeCompiled === undefined, 'not implemented' );
  }

  return _.construction._make3( genesis );
}

_retype_body.defaults =
{
  ... _make3.defaults,
  constructing : 'retype',
  amending : 'supplement',
}

let _retype = _.routine.uniteCloning_replaceByUnite( _make_head, _retype_body );

//

function _retypeEach( construction, runtime, args )
{
  let result = [];
  _.assert( arguments.length === 3 );
  for( let a = 0 ; a < args.length ; a++ )
  {
    let construction = runtime.retype( args[ a ] );
    if( construction !== undefined )
    result.push( construction );
  }
  return result;
}

//

function _init( genesis )
{
  _.assert( arguments.length === 1 );

  if( genesis.runtime._practiceMap.initBegin )
  for( let i = 0 ; i < genesis.runtime._practiceMap.initBegin.length ; i++ )
  genesis.runtime._practiceMap.initBegin[ i ]( genesis );

  _.construction._initFields( genesis );
  _.construction._initDefines( genesis );

  if( genesis.runtime._practiceMap.constructionInitEnd )
  for( let i = 0 ; i < genesis.runtime._practiceMap.constructionInitEnd.length ; i++ )
  genesis.runtime._practiceMap.constructionInitEnd[ i ]( genesis );

  return genesis;
}

_init.defaults =
{
  constructing : null,
  construction : null,
  amending : null,
  runtime : null,
}

//

function _initFields( genesis )
{

  _.assert( _.object.isBasic( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( arguments.length === 1 );
  _.assert( _.longHas( [ 'extend', 'supplement' ], genesis.amending ) );
  _.assert( _.mapIs( genesis.runtime.propsSupplementation ) );

  if( genesis.amending === 'extend' )
  _.props.extend( genesis.construction, genesis.runtime.propsExtension );
  else
  _.props.supplement( genesis.construction, genesis.runtime.propsExtension );

  _.props.supplement( genesis.construction, genesis.runtime.propsSupplementation );

  return genesis.construction;
}

_initFields.defaults =
{
  construction : null,
  runtime : null,
  constructing : null,
}

//

function _initDefines( genesis )
{

  _.assert( _.object.isBasic( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( arguments.length === 1 );
  _.assert( _.longHas( [ 'extend', 'supplement' ], genesis.amending ) );

  if( genesis.runtime._practiceMap.constructionInit )
  for( let i = 0 ; i < genesis.runtime._practiceMap.constructionInit.length ; i++ )
  {
    let constructionInit = genesis.runtime._practiceMap.constructionInit[ i ];
    constructionInit( genesis );
  }

  return genesis.construction;
}

_initDefines.defaults =
{
  construction : null,
  runtime : null,
  constructing : null,
}

//

function _extendArguments( genesis )
{

  _.assert( _.object.isBasic( genesis.construction ) );
  _.assert( _.blueprint.isRuntime( genesis.runtime ) );
  _.assert( genesis.args === undefined || _.argumentsArray.like( genesis.args ) );
  _.assert( genesis.args === undefined || genesis.args.length === 0 || genesis.args.length === 1 );
  _.assert( arguments.length === 1 );

  if( !genesis.args || !genesis.args.length )
  return genesis.construction;

  _.assert( genesis.args.length === 1 );

  let o = genesis.args[ 0 ];
  if( o === null )
  return genesis.construction;

  _.assert( _.object.isBasic( o ) );

  if( genesis.construction !== o )
  _.props.extend( genesis.construction, o );

  return genesis.construction;
}

_extendArguments.defaults =
{
  construction : null,
  args : null,
  runtime : null,
  constructing : null,
}

// --
// class Construction
// --

function Construction()
{
}

Construction.prototype = Object.create( null );
Object.freeze( Construction.prototype );

// --
// namespace construction
// --

let construction = Object.create( null );

var ConstructionExtension =
{

  isTyped,
  isInstanceOf,

  amend,
  extend,
  supplement,
  // _amendDefinitionWithoutMethod,
  _amendCant,

  _make2,
  _make3,

  _make,
  _makeEach,
  _from,
  _fromEach,
  _retype,
  _retypeEach,

  _init,
  _initFields,
  _initDefines,
  _extendArguments,

}

Object.assign( construction, ConstructionExtension );

// --
// namespace tools
// --

var ToolsExtension =
{

  construction,
  Construction,

}

_.assert( _.construction === undefined );

Object.assign( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

( function _Traits_s_()
{

'use strict';

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

let Definition = _.Definition;
_.routineIs( Definition );

// --
// implementation
// --

function _pairArgumentsHead( routine, args )
{
  let o = args[ 1 ];

  if( o )
  o.val = args[ 0 ];
  else
  o = { val : args[ 0 ] };

  o = _.routine.options_( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 0 || args.length === 1 || args.length === 2 );
  _.assert( args[ 1 ] === undefined || _.mapIs( args[ 1 ] ) );

  return o;
}

//

function callable( o )
{
  if( !_.mapIs( o ) )
  o = { callback : arguments[ 0 ] };
  _.routine.options_( callable, o );
  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( o.callback ) );
  o.kind = 'callable';
  return _.definition._traitMake( o );
  // return _.definition._traitMake( 'callable', o );
}

callable.defaults =
{
  callback : null,
  _blueprint : false,
}

callable.identity = { definition : true, trait : true, enabled : false };

//

/*

== typed:0

prototype:0
preserve prototype of the map, but change if not map to pure map

prototype:1
change prototype to null

prototype:null
change prototype to null

prototype:object
throw error

== typed:1

prototype:0
preserve prototype of typed destination, but change if it is map

prototype:1
set generated prototype

prototype:null
throw error

prototype:object
set custom prototype

== typed:maybe

prototype:0
preserve prototype of typed destination
preserve as map if untyped destination
create typed

prototype:1
set generated prototype if destination is typed
change prototype to null if untyped
create typed

prototype:null
preserve prototype if typed
set prototype to null if untyped
create untyped

prototype:object
set custom prototype if typed
preserve if untyped
create typed

*/

function typed_head( routine, args )
{
  let o = args[ 1 ];

  if( _.mapIs( args[ 0 ] ) )
  {
    o = args[ 0 ];
    _.assert( args.length === 1 );
  }
  else if( o )
  {
    o.val = args[ 0 ];
  }
  else
  {
    if( args.length > 0 )
    o = { val : args[ 0 ] };
    else
    o = {};
  }

  o = _.routine.options_( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 0 || args.length === 1 || args.length === 2 );
  _.assert( args[ 1 ] === undefined || _.mapIs( args[ 1 ] ) );

  return o;
}

function typed_body( o )
{
  _.routine.options_( typed_body, o );

  if( !_.mapIs( o ) )
  o = arguments.length > 0 ? { val : arguments[ 0 ] } : {};
  _.routine.optionsWithoutUndefined( typed, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( _.boolLike( o.val ) )
  o.val = !!o.val;
  if( _.boolLike( o.new ) )
  o.new = !!o.new;
  if( _.boolLike( o.prototype ) )
  o.prototype = !!o.prototype;

  _.assert( _.fuzzyIs( o.val ), () => `Expects fuzzy-like argument, but got ${_.entity.strType( o.val )}` );
  _.assert
  (
    o.new === _.nothing || _.boolIs( o.new ),
    () => `Expects bool-like option::new, but got ${_.entity.strType( o.new )}`
  );
  _.assert
  (
    o.val !== false || _.primitiveIs( o.prototype )
    , () => `Trait::typed should be either not false or prototype should be [ true, false, null ]`
    + `, it is ${_.entity.strType( o.prototype )}`
  );
  _.assert( o.prototype !== null || o.val !== true, 'Object with null prototype cant be typed' );

  o.blueprintDefinitionRewrite = blueprintDefinitionRewrite;
  o.blueprintForm1 = blueprintForm1;
  o.blueprintForm2 = blueprintForm2;

  let allocate, retype;

  o.kind = 'typed';
  return _.definition._traitMake( o );

/* -

- blueprintDefinitionRewrite
- bluprintDefinitionSupplement
- bluprintDefinitionSupplementAct
- definitionRewritePrototype
- canRewritePrototype
- blueprintForm1
- blueprintForm2
- allocateTyped
- allocateUntyped
- retypeMaybe
- retypeTyped
- retypeUntypedPreserving
- retypeUntypedForcing
- retypeToMap

*/

  /* */

  function blueprintDefinitionRewrite( op )
  {
    _.assert( !op.primeDefinition || !op.secondaryDefinition || op.primeDefinition.kind === op.secondaryDefinition.kind );

    if( op.primeDefinition && op.secondaryDefinition )
    bluprintDefinitionSupplement( op );

    if( op.primeDefinition && op.secondaryDefinition && !_.boolIs( op.secondaryDefinition._synthetic ) )
    {

      // if( _global_.debugger )
      // debugger;
      _.assert( _.boolIs( op.primeDefinition._synthetic ) );

      let prototype = _.prototype.of( op.secondaryDefinition._synthetic );
      let definition = op.primeDefinition

      _.assert( definition._blueprint === op.blueprint || definition._blueprint === null, 'not tested' )
      if( definition._blueprint !== op.blueprint && definition._blueprint !== null )
      definition.cloneShallow();
      definition._blueprint = op.blueprint;

      if( op.primeDefinition.val === true && op.primeDefinition.prototype === _.nothing )
      definition.prototype = true;

      if
      (
           prototype
        && prototype !== Object.prototype
        && op.primeDefinition.val
        && ( definition.prototype === _.nothing || definition.prototype === false ) )
      {

        definition.prototype = prototype;
        definition.new = false;

      }
      else if
      (
           !_.boolIs( op.secondaryDefinition._synthetic )
        && ( _.boolIs( definition.prototype ) || definition.prototype === _.nothing )
        && op.primeDefinition.val === _.maybe
      )
      {

        if( definition.prototype === _.nothing )
        {
          if( prototype === Object.prototype )
          definition.prototype = false;
          else
          definition.prototype = prototype;
        }
        else if( prototype === null || prototype === Object.prototype )
        {
          if( definition.prototype !== true )
          definition.prototype = false;
        }

      }

      op.blueprint.traitsMap[ op.primeDefinition.kind ] = definition;
      return;
    }

    /*
    default handler otherwise
    */
    op.blueprintDefinitionRewrite( op );

  }

/*

= extend

- typed1    ↓
- synthetic ↓
- typed2    ↓

= supplement

- typed2     ↑
- synthetic  ↑
- typed1     ↑

*/

  /* */

  function bluprintDefinitionSupplement( op )
  {
    let secondaryDefinition = op.secondaryDefinition;

    // if( _global_.debugger )
    // debugger;

    if( op.primeDefinition._synthetic === true )
    {
      if( secondaryDefinition._synthetic === true )
      op.primeDefinition._notSyntheticDefinition = secondaryDefinition._notSyntheticDefinition;
      else
      op.primeDefinition._notSyntheticDefinition = secondaryDefinition;
      /* preserve non-synthetic definition to use in case of attempt of partial supplementation */
    }

    if( secondaryDefinition._synthetic === true )
    {
      if( op.primeDefinition.prototype !== _.nothing || !canRewritePrototype( op, secondaryDefinition ) )
      {
        /* reject partial supplementing by trait generated inheriting */
        if( secondaryDefinition._notSyntheticDefinition === _.nothing )
        return;
        else
        secondaryDefinition = secondaryDefinition._notSyntheticDefinition;
      }
    }
    else if( !_.boolIs( secondaryDefinition._synthetic ) )
    {
      /* reject partial supplementing by trait generated construction */
      return;
    }

    return bluprintDefinitionSupplementAct( op, secondaryDefinition );
  }

  /* */

  function bluprintDefinitionSupplementAct( op, secondaryDefinition )
  {

    let prototypeRewriting = false;
    if( op.primeDefinition.prototype === _.nothing )
    prototypeRewriting = true;

    let newRewriting = false;
    if( op.primeDefinition.new === _.nothing )
    newRewriting = true;

    if( op.primeDefinition._blueprint && op.primeDefinition._blueprint !== op.blueprint )
    op.primeDefinition = op.primeDefinition.cloneShallow();

    if( prototypeRewriting )
    {
      definitionRewritePrototype( op, secondaryDefinition );
    }
    else
    {
      if
      (
        op.primeDefinition._secondaryPrototype === _.nothing
        || op.primeDefinition._secondaryPrototype === op.primeDefinition.prototype
      )
      if( secondaryDefinition.prototype !== _.nothing )
      op.primeDefinition._secondaryPrototype = secondaryDefinition.prototype; /* qqq : cover logic of amending of prototype in case of many amendings */
    }

    if( newRewriting )
    op.primeDefinition.new = secondaryDefinition.new;

    return true;
  }

  /* */

  function definitionRewritePrototype( op, secondaryDefinition )
  {
    if( canRewritePrototype( op, secondaryDefinition.prototype ) )
    op.primeDefinition.prototype = secondaryDefinition.prototype;
    else if( canRewritePrototype( op, secondaryDefinition._secondaryPrototype ) )
    op.primeDefinition.prototype = secondaryDefinition._secondaryPrototype;
    else
    op.primeDefinition._secondaryPrototype = secondaryDefinition.prototype;
  }

  /* */

  function canRewritePrototype( op, prototype )
  {
    if( prototype === _.nothing )
    return false;
    if( !op.primeDefinition.val && !_.primitiveIs( prototype ) )
    return false;
    if( op.primeDefinition.val === true && prototype === null )
    return false;
    return true;
  }

  /* */

  function blueprintForm1( op )
  {
    let prototype;
    let trait = op.blueprint.traitsMap.typed;
    let runtime = op.blueprint.runtime;

    /**/

    if( _.boolLike( trait.new ) )
    trait.new = !!trait.new;
    if( _.boolLike( trait.prototype ) )
    trait.prototype = !!trait.prototype;

    if( trait.prototype === _.nothing )
    {
      if( _.mapIs( trait._synthetic ) && trait.val === _.maybe )
      trait.prototype = false;
      else if( trait.val === true )
      trait.prototype = true;
      else
      trait.prototype = false;
    }

    if( trait.new === _.nothing )
    {
      if( trait.val === _.maybe && trait.prototype === true )
      trait.new = false;
      else
      trait.new = _.blueprint.is( trait.prototype ) || trait.prototype === true;
    }

    _.assert( _.boolIs( trait.new ), () => `Expects bool-like option::new, but got ${_.entity.strType( trait.new )}` );
    _.assert
    (
      trait.prototype === null || _.boolIs( trait.prototype ) || !_.primitiveIs( trait.prototype )
      , () => `Prototype should be either bool, null or non-primitive, but is ${_.entity.strType( trait.prototype )}`
    );
    _.assert
    (
      trait.val !== false || _.primitiveIs( trait.prototype )
      , () => `Trait::typed should be either not false or prototype should be any of [ true, false, null ]`
      + `, but it is ${_.entity.strType( trait.prototype )}`
    );
    _.assert( trait._blueprint === op.blueprint );

    /* */

    if( trait._synthetic )
    trait._synthetic = false;

    _.assert( trait._synthetic === false );
    _.assert( op.blueprint.make === null );
    _.assert( runtime.prototype === null );

    if( _.boolIs( trait.prototype ) )
    {

      if( trait.val === false && trait.val !== _.maybe )
      {
        prototype = null;
      }
      else if( trait.val === _.maybe )
      {
        if( trait.prototype === true || trait.prototype === false )
        prototype = Object.create( _.Construction.prototype );
        else
        prototype = runtime.prototype;
      }
      else
      {
        prototype = Object.create( _.Construction.prototype );
      }

      runtime.prototype = prototype;
    }
    else
    {

      if( _.blueprint.is( trait.prototype ) )
      {
        prototype = trait.prototype.prototype;
        _.assert( _.routineIs( trait.prototype.make ) );
        _.assert
        (
          _.object.isBasic( trait.prototype.prototype )
          , `Cant use ${_.blueprint.qnameOf( trait.prototype )} as prototype. This blueprint is not prototyped.`
        );
      }
      else if( trait.val === _.maybe && trait.prototype === null )
      {
        prototype = _.Construction.prototype;
      }
      else
      {
        prototype = trait.prototype;
      }

      if( ( prototype === _.Construction.prototype || trait.new ) && prototype )
      runtime.prototype = Object.create( prototype );
      else
      runtime.prototype = prototype;

    }

    /* */

    // runtime._makingTyped = !!op.blueprint.traitsMap.typed.val;

    /* */

    runtime._prototyping = trait.prototype;

    /* */

    allocate = trait.val ? allocateTyped : allocateUntyped;

    /* */

    retype = trait.val ? retypeTyped : retypeUntypedPreserving;
    if( trait.val === _.maybe )
    retype = retypeMaybe;
    else if( trait.val === false && ( trait.prototype === null || trait.prototype === true ) )
    retype = retypeUntypedForcing;

    _.blueprint._practiceAdd( op.blueprint, 'allocate', allocate );
    _.blueprint._practiceAdd( op.blueprint, 'retype', retype );

  }

  /* */

  function blueprintForm2( op )
  {
    let trait = op.blueprint.traitsMap.typed;
    let prototype;

    _.assert( _.fuzzyIs( trait.val ) );
    _.assert( op.blueprint.typed === trait.val || trait.val === _.maybe );
    _.assert( trait._blueprint === op.blueprint );
    _.assert( _.fuzzyIs( op.blueprint.typed ) );

    Object.freeze( trait );

    if( _.boolIs( trait.prototype ) )
    return;

    if( _.blueprint.is( trait.prototype ) )
    {
      prototype = trait.prototype.prototype;
      _.assert( _.blueprint.isDefinitive( trait.prototype ) );
      _.assert( _.routineIs( op.blueprint.make ) );
      _.assert( _.routineIs( trait.prototype.make ) );
      Object.setPrototypeOf( op.blueprint.make, trait.prototype.make );
    }
    else
    {
      prototype = trait.prototype;
      _.assert( prototype !== null || op.blueprint.typed !== true, 'Object with null prototype cant be typed' );
      if( prototype && Object.hasOwnProperty.call( prototype, 'constructor' ) && _.routineIs( prototype.constructor ) )
      if( op.blueprint.make !== prototype.constructor )
      Object.setPrototypeOf( op.blueprint.make, prototype.constructor );
    }

  }

  /* */

  function allocateTyped( genesis )
  {
    // if( _global_.debugger )
    // debugger;
    _.assert( !!genesis.runtime.typed );
    if( genesis.construction === null )
    genesis.construction = new( _.constructorJoin( genesis.runtime.make, genesis.args ) );
    _.assert
    (
      genesis.construction === null || !genesis.runtime.prototype || genesis.construction instanceof genesis.runtime.make
    );
    return genesis.construction;
  }

  /* */

  function allocateUntyped( genesis )
  {
    // if( _global_.debugger )
    // debugger;

    if( genesis.runtime.prototype === null && !_.mapIsPure( genesis.construction ) )
    genesis.construction = Object.create( null );
    else if( genesis.construction && genesis.runtime.prototype !== null && genesis.construction instanceof genesis.runtime.make )
    genesis.construction = Object.create( null );
    else if( genesis.construction === null )
    genesis.construction = Object.create( null );
    _.assert( genesis.construction === null || _.mapIs( genesis.construction ) );
    _.assert( genesis.runtime.prototype === null || !( genesis.construction instanceof genesis.runtime.make ) );
    return genesis.construction;
  }

  /* */

  function retypeMaybe( genesis )
  {
    // if( _global_.debugger )
    // debugger;

    if( genesis.construction === null )
    {
      if( !genesis.runtime._prototyping || genesis.runtime.prototype === null )
      {
        _.assert( 0, 'not tested' );
        genesis.construction = Object.create( null );
      }
      else
      {
        _.assert( 0, 'not tested' );
        genesis.construction = new( _.constructorJoin( genesis.runtime.make, genesis.args ) );
      }
    }
    else if( _.mapIs( genesis.construction ) )
    {
      if( genesis.runtime._prototyping === null || genesis.runtime._prototyping === true )
      if( Object.getPrototypeOf( genesis.construction ) !== null )
      Object.setPrototypeOf( genesis.construction, null );
    }
    else
    {

      if( genesis.runtime._prototyping )
      if( Object.getPrototypeOf( genesis.construction ) !== genesis.runtime.prototype )
      Object.setPrototypeOf( genesis.construction, genesis.runtime.prototype );

    }

    return genesis.construction;
  }

  /* */

  function retypeTyped( genesis )
  {
    // if( _global_.debugger )
    // debugger;
    if( genesis.construction === null )
    {
      genesis.construction = new( _.constructorJoin( genesis.runtime.make, genesis.args ) );
    }
    else if( genesis.construction )
    {
      if( genesis.runtime._prototyping !== false || _.mapIs( genesis.construction ) )
      if( genesis.runtime.prototype === null || !( genesis.construction instanceof genesis.runtime.make ) )
      Object.setPrototypeOf( genesis.construction, genesis.runtime.prototype );
    }

    _.assert
    (
      !_.mapIs( genesis.construction )
    );

    _.assert
    (
      genesis.runtime._prototyping === false
      || genesis.runtime.typed === _.maybe
      || genesis.runtime.prototype === null
      || genesis.construction instanceof genesis.runtime.make
    );
    return genesis.construction;
  }

  /* */

  function retypeUntypedPreserving( genesis )
  {
    // if( _global_.debugger )
    // debugger;
    if( genesis.construction )
    {
      let wasProto = Object.getPrototypeOf( genesis.construction );
      if( wasProto !== null && wasProto !== Object.prototype )
      if( genesis.runtime.typed !== _.maybe )
      Object.setPrototypeOf( genesis.construction, null );
    }
    else if( genesis.construction === null )
    {
      genesis.construction = Object.create( null );
    }
    _.assert( _.mapIs( genesis.construction ) );
    return genesis.construction;
  }

  /* */

  function retypeUntypedForcing( genesis )
  {
    // if( _global_.debugger )
    // debugger;
    if( genesis.construction )
    {
      let wasProto = Object.getPrototypeOf( genesis.construction );
      if( genesis.runtime.typed !== _.maybe )
      Object.setPrototypeOf( genesis.construction, null );
    }
    else if( genesis.construction === null )
    {
      genesis.construction = Object.create( null );
    }
    _.assert( _.mapIs( genesis.construction ) );
    return genesis.construction;
  }

  /* */

}

typed_body.defaults =
{
  val : true,
  prototype : _.nothing,
  new : _.nothing,
  _synthetic : false, /* false for ordinary, true if created by inheriting, construction if spawned by _.construction.amend */
  _blueprint : null,
  _notSyntheticDefinition : _.nothing,
  _secondaryPrototype : _.nothing,
}

typed_body.identity = { definition : true, trait : true };

let typed = _.routine.uniteCloning_replaceByUnite( typed_head, typed_body );

//

function constructor( o )
{
  if( !_.mapIs( o ) )
  o = arguments.length > 0 ? { val : arguments[ 0 ] } : {};
  _.routine.options_( constructor, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolLike( o.val ) );

  o.val = !!o.val;
  o.blueprintForm2 = blueprintForm2;
  o._blueprint = false;
  o.kind = 'constructor';
  return _.definition._traitMake( o );

  /* */

  function blueprintForm2( op )
  {

    // if( _global_.debugger )
    // debugger;

    if( !op.blueprint.traitsMap.constructor.val )
    return;

    let prototyped = op.blueprint.prototype && op.blueprint.prototype !== Object.prototype;

    _.assert( _.routineIs( op.blueprint.make ) );
    _.assert( _.fuzzyIs( op.blueprint.typed ) );

    if( prototyped )
    if( op.amending !== 'supplement' || !_.mapOnlyOwnKey( op.blueprint.prototype, 'constructor' ) )
    {
      let properties =
      {
        value : op.blueprint.make,
        enumerable : false,
        configurable : false,
        writable : false,
      };
      Object.defineProperty( op.blueprint.prototype, 'constructor', properties );
    }

    let prototype = op.blueprint.prototype;
    let supplementing = op.amending === 'supplement';
    let constructor = op.blueprint.make;
    let typed = op.blueprint.typed;
    if( typed !== true )
    {
      _.blueprint._practiceAdd( op.blueprint, 'constructionInitEnd', constructionInitEnd );
    }

    function constructionInitEnd( genesis )
    {
      // if( _global_.debugger )
      // debugger;
      _.assert( !_.primitiveIs( genesis.construction ) );
      if( typed )
      {
        let prototype2 = Object.getPrototypeOf( genesis.construction );
        if( prototype2 && prototype2 === prototype )
        return;
      }
      if( genesis.amending === 'supplement' && Object.hasOwnProperty.call( genesis.construction, 'constructor' ) )
      return;
      let properties =
      {
        value : constructor,
        enumerable : false,
        configurable : false,
        writable : false,
      };
      Object.defineProperty( genesis.construction, 'constructor', properties );
    }

  }

}

constructor.identity = { definition : true, trait : true };
constructor.defaults =
{
  val : true,
}

//

function extendable( o )
{
  if( !_.mapIs( o ) )
  o = arguments.length > 0 ? { val : arguments[ 0 ] } : {};
  _.routine.options_( extendable, o );

  if( _.boolLike( o.val ) )
  o.val = !!o.val;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.boolIs( o.val ) );

  o.blueprintForm2 = blueprintForm2;

  o.kind = 'extendable';
  return _.definition._traitMake( o );

  function blueprintForm2( op )
  {
    _.assert( _.boolIs( op.blueprint.traitsMap.extendable.val ) );
    if( op.blueprint.traitsMap.extendable.val )
    return;
    _.blueprint._practiceAdd( op.blueprint, 'constructionInitEnd', preventExtensions );
  }

  function preventExtensions( genesis )
  {
    Object.preventExtensions( genesis.construction );
  }

}

extendable.identity = { definition : true, trait : true };
extendable.defaults =
{
  val : true,
  _blueprint : false,
}

//

function name( o )
{
  if( !_.mapIs( o ) )
  o = arguments.length > 0 ? { val : arguments[ 0 ] } : {};
  _.routine.options_( name, o );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.val ) );
  o.blueprintForm1 = blueprintForm1;
  o.kind = 'name';
  return _.definition._traitMake( o );

  function blueprintForm1( op )
  {
    _.assert( op.blueprint.make === null );
    _.assert( op.blueprint.name === null );
    op.blueprint.runtime.name = op.definition.val;
  }

}

name.identity = { definition : true, trait : true };
name.defaults =
{
  val : null,
  _blueprint : false,
}

// --
// define
// --

/**
* Collection of definitions which are traits.
* @namespace wTools.trait
* @extends Tools
* @module Tools/base/Proto
*/

let TraitExtension =
{

  callable,
  typed,
  constructor, /* xxx : reuse static:maybe _.define.prop() ?*/
  extendable,
  name,

}

_.definition.extend( TraitExtension );

//

/**
* Routines to manipulate traits.
* @namespace wTools.definition
* @extends Tools
* @module Tools/base/Proto
*/

let DefinitionTraitExtension =
{

  is : _.traitIs,

}

_.definition.trait = _.definition.trait || Object.create( null );
/* _.props.extend */Object.assign( _.definition.trait, DefinitionTraitExtension );
_.assert( _.routineIs( _.traitIs ) );
_.assert( _.definition.trait.is === _.traitIs );

//

let ToolsExtension =
{
}

_.props.extend( _, ToolsExtension );
_.assert( _.routineIs( _.traitIs ) );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

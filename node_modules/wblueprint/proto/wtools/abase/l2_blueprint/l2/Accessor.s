( function _Accessor_s_()
{

'use strict';

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

/**
 * @summary Collection of routines for declaring accessors
 * @namespace wTools.accessor
 * @extends Tools
 * @module Tools/base/Proto
 */

// --
// fields
// --

/**
 * Accessor defaults
 * @typedef {Object} DeclarationOptions
 * @property {Boolean} [ strict=1 ]
 * @property {Boolean} [ preservingValue=1 ]
 * @property {Boolean} [ prime=1 ]
 * @property {String} [ combining=null ]
 * @property {Boolean} [ writable=true ]
 * @property {Boolean} [ readOnlyProduct=0 ]
 * @property {Boolean} [ enumerable=1 ]
 * @property {Boolean} [ configurable=0 ]
 * @property {Function} [ getter=null ]
 * @property {Function} [ graber=null ]
 * @property {Function} [ setter=null ]
 * @property {Function} [ suite=null ]
 * @namespace Tools.accessor
 **/

let Combining = [ 'rewrite', 'supplement', 'apppend', 'prepend' ];
let StoringStrategy = [ 'symbol', 'underscore' ];
let AmethodTypes = [ 'grab', 'get', 'put', 'set', 'move' ];

let AmethodTypesMap =
{
  grab : null,
  get : null,
  put : null,
  set : null,
  move : null,
}

let DeclarationSpecialDefaults =
{
  // name : null,
  object : null,
  methods : null,
  needed : null,
  normalizedAsuite : null,
}

let DeclarationOptions =
{

  name : null,
  val : _.nothing,
  suite : null,

  preservingValue : null,
  prime : null,
  combining : null,
  addingMethods : null,
  enumerable : null,
  configurable : null,
  writable : null,
  storingStrategy : null,
  storageIniting : null,
  valueGetting : null,
  valueSetting : null,

  strict : true, /* zzz : deprecate */

}

let DeclarationDefaults =
{

  name : null,
  val : _.nothing,
  suite : null,

  preservingValue : true,
  prime : null,
  combining : null,
  addingMethods : false,
  enumerable : true,
  configurable : true,
  writable : null,
  storingStrategy : 'symbol',
  storageIniting : true,
  valueGetting : true,
  valueSetting : true,

  strict : true,

}

let DeclarationMultipleToSingleOptions =
{
  ... AmethodTypesMap,
  ... DeclarationOptions,
  methods : null,
}

// --
// getter / setter generator
// --

function _propertyGetterSetterNames( propertyName )
{
  let result = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( propertyName ) );

  result.grab = '_' + propertyName + 'Grab';
  result.get = '_' + propertyName + 'Get';
  result.put = '_' + propertyName + 'Put';
  result.set = '_' + propertyName + 'Set';
  result.move = '_' + propertyName + 'Move';

  /* zzz : use it? */

  return result;
}

//

function _normalizedAsuiteForm_head( routine, args )
{
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  let o = _.routine.options_( routine, args );
  return o;
}

function _normalizedAsuiteForm_body( o )
{

  _.assert( arguments.length === 1 );
  _.assert( o.methods === null || !_.primitiveIs( o.methods ) );
  _.assert( _.strIs( o.name ) || _.symbolIs( o.name ) );
  _.assert( _.mapIs( o.normalizedAsuite ) );
  _.assert( o.writable === null || _.boolIs( o.writable ) );
  _.map.assertHasOnly( o.normalizedAsuite, _.accessor.AmethodTypesMap );
  _.routine.assertOptions( _normalizedAsuiteForm_body, o );

  let propName;
  if( _.symbolIs( o.name ) )
  {
    propName = Symbol.keyFor( o.name );
  }
  else
  {
    propName = o.name;
  }

  if( o.suite )
  _.map.assertHasOnly( o.suite, _.accessor.AmethodTypes );

  // for( let k in o.normalizedAsuite, _.accessor.AmethodTypesMap )
  for( let k in _.accessor.AmethodTypesMap )
  methodNormalize( k );

  _.assert( o.writable !== false || !o.normalizedAsuite.set );

  /* grab */

  if( o.normalizedAsuite.grab === null || o.normalizedAsuite.grab === true )
  {
    if( o.normalizedAsuite.move )
    o.normalizedAsuite.grab = _.accessor._amethodFromMove( propName, 'grab', o.normalizedAsuite.move );
    else if( _.routineIs( o.normalizedAsuite.get ) )
    o.normalizedAsuite.grab = o.normalizedAsuite.get;
    else
    o.normalizedAsuite.grab = _.accessor._amethodFunctor( propName, 'grab', o.storingStrategy );
  }

  /* get */

  if( o.normalizedAsuite.get === null || o.normalizedAsuite.get === true )
  {
    if( o.normalizedAsuite.move )
    o.normalizedAsuite.get = _.accessor._amethodFromMove( propName, 'get', o.normalizedAsuite.move );
    else if( _.routineIs( o.normalizedAsuite.grab ) )
    o.normalizedAsuite.get = o.normalizedAsuite.grab;
    else
    o.normalizedAsuite.get = _.accessor._amethodFunctor( propName, 'get', o.storingStrategy );
  }

  /* put */

  if( o.normalizedAsuite.put === null || o.normalizedAsuite.put === true )
  {
    if( o.normalizedAsuite.move )
    o.normalizedAsuite.put = _.accessor._amethodFromMove( propName, 'put', o.normalizedAsuite.move );
    else if( _.routineIs( o.normalizedAsuite.set ) )
    o.normalizedAsuite.put = o.normalizedAsuite.set;
    else
    o.normalizedAsuite.put = _.accessor._amethodFunctor( propName, 'put', o.storingStrategy );
  }

  /* set */

  if( o.normalizedAsuite.set === null || o.normalizedAsuite.set === true )
  {
    if( o.writable === false )
    {
      _.assert( o.normalizedAsuite.set === null );
      o.normalizedAsuite.set = false;
    }
    else if( o.normalizedAsuite.move )
    o.normalizedAsuite.set = _.accessor._amethodFromMove( propName, 'set', o.normalizedAsuite.move );
    else if( _.routineIs( o.normalizedAsuite.put ) )
    o.normalizedAsuite.set = o.normalizedAsuite.put;
    else if( o.normalizedAsuite.put !== false || o.normalizedAsuite.set )
    o.normalizedAsuite.set = _.accessor._amethodFunctor( propName, 'set', o.storingStrategy );
    else
    o.normalizedAsuite.set = false;
  }

  /* move */

  if( o.normalizedAsuite.move === true )
  {
    o.normalizedAsuite.move = function move( it )
    {
      _.assert( 0, 'not tested' ); /* zzz */
      return it.src;
    }
  }
  else if( !o.normalizedAsuite.move )
  {
    o.normalizedAsuite.move = false;
    _.assert( o.normalizedAsuite.move === false );
  }

  // /* readOnlyProduct */
  //
  // if( o.readOnlyProduct && o.normalizedAsuite.get )
  // {
  //   let get = o.normalizedAsuite.get;
  //   o.normalizedAsuite.get = function get()
  //   {
  //     debugger;
  //     let o.normalizedAsuite = get.apply( this, arguments );
  //     if( !_.primitiveIs( o.normalizedAsuite ) )
  //     o.normalizedAsuite = _.proxyReadOnly( o.normalizedAsuite );
  //     return o.normalizedAsuite;
  //   }
  // }

  /* validation */

  if( Config.debug )
  {
    for( let k in AmethodTypesMap )
    _.assert
    (
      _.definitionIs( o.normalizedAsuite[ k ] ) || _.routineIs( o.normalizedAsuite[ k ] ) || o.normalizedAsuite[ k ] === false,
      () => `Field "${propName}" is not read only, but setter not found ${_.entity.exportStringDiagnosticShallow( o.methods )}`
    );
  }

  return o.normalizedAsuite;

  /* */

  function methodNormalize( name )
  {
    let capitalName = _.strCapitalize( name );
    _.assert
    (
      o.normalizedAsuite[ name ] === null
      || _.boolLike( o.normalizedAsuite[ name ] )
      || _.routineIs( o.normalizedAsuite[ name ] )
      || _.definitionIs( o.normalizedAsuite[ name ] )
    );

    if( o.suite && _.boolLikeFalse( o.suite[ name ] ) )
    {
      _.assert( !o.normalizedAsuite[ name ] );
      o.normalizedAsuite[ name ] = false;
      o.suite[ name ] = false;
    }
    else if( _.boolLikeFalse( o.normalizedAsuite[ name ] ) )
    {
      o.normalizedAsuite[ name ] = false;
    }
    else if( _.boolLikeTrue( o.normalizedAsuite[ name ] ) )
    {
      o.normalizedAsuite[ name ] = true;
    }

    if( o.normalizedAsuite[ name ] === null || o.normalizedAsuite[ name ] === true )
    {
      if( _.routineIs( o.normalizedAsuite[ name ] ) || _.definitionIs( o.normalizedAsuite[ name ] ) )
      o.normalizedAsuite[ name ] = o.normalizedAsuite[ name ];
      else if( o.suite && ( _.routineIs( o.suite[ name ] ) || _.definitionIs( o.suite[ name ] ) ) )
      o.normalizedAsuite[ name ] = o.suite[ name ];
      else if( o.methods && o.methods[ '' + propName + capitalName ] )
      o.normalizedAsuite[ name ] = o.methods[ propName + capitalName ];
      else if( o.methods && o.methods[ '_' + propName + capitalName ] )
      o.normalizedAsuite[ name ] = o.methods[ '_' + propName + capitalName ];
    }
  }

  /* */

}

_normalizedAsuiteForm_body.defaults =
{
  suite : null,
  normalizedAsuite : null,
  methods : null,
  writable : null,
  storingStrategy : 'symbol',
  name : null,
}

let _normalizedAsuiteForm = _.routine.uniteCloning_replaceByUnite( _normalizedAsuiteForm_head, _normalizedAsuiteForm_body );

//

function _normalizedAsuiteUnfunct( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o.normalizedAsuite ) );
  _.routine.assertOptions( _normalizedAsuiteUnfunct, arguments );

  for( let mname in _.accessor.AmethodTypesMap )
  resultUnfunct( mname );

  return o.normalizedAsuite;

  /* */

  function resultUnfunct( kind )
  {
    _.assert( _.primitiveIs( kind ) );
    if( !o.normalizedAsuite[ kind ] )
    return;
    let amethod = o.normalizedAsuite[ kind ];
    let r = _.accessor._amethodUnfunct
    ({
      amethod,
      kind,
      accessor : o.accessor,
      withDefinition : o.withDefinition,
      withFunctor : o.withFunctor,
    });
    o.normalizedAsuite[ kind ] = r;
    return r;
  }

}

var defaults = _normalizedAsuiteUnfunct.defaults =
{
  accessor : null,
  normalizedAsuite : null,
  withDefinition : false,
  withFunctor : true,
}

//

function _amethodUnfunct( o )
{

  _.assert( arguments.length === 1 );
  if( !o.amethod )
  return o.amethod;

  _.assert( !_.routineIs( o.amethod ) || !o.amethod.identity || _.mapIs( o.amethod.identity ) );

  if( o.withFunctor && o.amethod.identity && o.amethod.identity.functor )
  {
    functorUnfunct();
    if( o.kind === 'suite' && o.withDefinition && _.definitionIs( o.amethod ) )
    definitionUnfunct();
  }
  else if( o.kind === 'suite' && o.withDefinition && _.definitionIs( o.amethod ) )
  {
    definitionUnfunct();
    if( o.withFunctor && o.amethod.identity && o.amethod.identity.functor )
    functorUnfunct();
  }

  _.assert( o.amethod !== undefined );
  return o.amethod;

  function functorUnfunct()
  {
    let o2 = Object.create( null );
    if( o.amethod.defaults )
    {
      if( o.amethod.defaults.propName !== undefined )
      o2.propName = o.accessor.name;
      if( o.amethod.defaults.accessor !== undefined )
      o2.accessor = o.accessor;
      if( o.amethod.defaults.accessorKind !== undefined )
      o2.accessorKind = o.kind;
    }
    o.amethod = o.amethod( o2 );
  }

  function definitionUnfunct()
  {
    _.assert( _.routineIs( o.amethod.asAccessorSuite ) );
    o.amethod = o.amethod.asAccessorSuite( o );
    _.assert( o.amethod !== undefined );
  }

}

_amethodUnfunct.defaults =
{
  amethod : null,
  accessor : null,
  kind : null,
  withDefinition : false,
  withFunctor : true,
}

//

function _objectMethodsNamesGet( o )
{

  _.routine.options_( _objectMethodsNamesGet, o );

  if( o.anames === null )
  o.anames = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o.normalizedAsuite ) );
  _.assert( _.strIs( o.name ) );
  _.assert( !!o.object );

  for( let t = 0 ; t < _.accessor.AmethodTypes.length ; t++ )
  {
    let type = _.accessor.AmethodTypes[ t ];
    if( o.normalizedAsuite[ type ] && !o.anames[ type ] )
    {
      let type2 = _.strCapitalize( type );
      if( o.object[ o.name + type2 ] === o.normalizedAsuite[ type ] )
      o.anames[ type ] = o.name + type2;
      else if( o.object[ '_' + o.name + type2 ] === o.normalizedAsuite[ type ] )
      o.anames[ type ] = '_' + o.name + type2;
      else
      o.anames[ type ] = o.name + type2;
    }
  }

  return o.anames;
}

_objectMethodsNamesGet.defaults =
{
  object : null,
  normalizedAsuite : null,
  anames : null,
  name : null,
}

//

function _objectMethodsGet( object, propertyName )
{
  let result = Object.create( null );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.object.isBasic( object ) );
  _.assert( _.strIs( propertyName ) );

  result.grabName = object[ propertyName + 'Grab' ] ? propertyName + 'Grab' : '_' + propertyName + 'Grab';
  result.getName = object[ propertyName + 'Get' ] ? propertyName + 'Get' : '_' + propertyName + 'Get';
  result.putName = object[ propertyName + 'Put' ] ? propertyName + 'Put' : '_' + propertyName + 'Put';
  result.setName = object[ propertyName + 'Set' ] ? propertyName + 'Set' : '_' + propertyName + 'Set';
  result.moveName = object[ propertyName + 'Move' ] ? propertyName + 'Move' : '_' + propertyName + 'Move';

  result.grab = object[ result.grabName ];
  result.get = object[ result.getName ];
  result.set = object[ result.setName ];
  result.put = object[ result.putName ];
  result.move = object[ result.moveName ];

  return result;
}

//

function _objectMethodsValidate( o )
{

  if( !Config.debug )
  return true;

  _.assert( _.strIs( o.name ) || _.symbolIs( o.name ) );
  _.assert( !!o.object );
  _.routine.options_( _objectMethodsValidate, o );

  let name = _.symbolIs( o.name ) ? Symbol.keyFor( o.name ) : o.name;
  let AmethodTypes = _.accessor.AmethodTypes;

  for( let t = 0 ; t < AmethodTypes.length ; t++ )
  {
    let type = AmethodTypes[ t ];
    if( !o.normalizedAsuite[ type ] )
    {
      let name1 = name + _.strCapitalize( type );
      let name2 = '_' + name + _.strCapitalize( type );
      _.assert( !( name1 in o.object ), `Object should not have method ${name1}, if accessor has it disabled` );
      _.assert( !( name2 in o.object ), `Object should not have method ${name2}, if accessor has it disabled` );
    }
  }

  return true;
}

_objectMethodsValidate.defaults =
{
  object : null,
  normalizedAsuite : null,
  name : null,
}

//

function _objectMethodMoveGet( srcInstance, name )
{
  _.assert( arguments.length === 2 );
  _.assert( _.strIs( name ) );

  if( !_.instanceIs( srcInstance ) )
  return null;

  if( srcInstance[ name + 'Move' ] )
  return srcInstance[ name + 'Move' ];
  else if( srcInstance[ '_' + name + 'Move' ] )
  return srcInstance[ '_' + name + 'Move' ];

  return null;
}

//

function _declaringIsNeeded( o )
{
  let prop = _.props.descriptorActiveOf( o.object, o.name );
  if( prop.descriptor )
  {

    _.assert
    (
      o.combining === null || _.longHas( _.accessor.Combining, o.combining )
      , () => `Option::combining of property ${o.name}`
      + ` supposed to be either any of ${_.accessor.Combining} or null`
      + ` but it is ${o.combining}`
    );
    _.assert
    (
      !!o.combining
      , 'Overriding of accessor is not allowed, to allow it set option::combining to rewrite'
    );
    _.assert( o.combining === 'rewrite' || o.combining === 'append' || o.combining === 'supplement', 'not implemented' );

    if( o.combining === 'supplement' )
    return false;

    _.assert
    (
      prop.object !== o.object,
      () => `Attempt to redefine own accessor "${o.name}" of ${_.entity.exportStringDiagnosticShallow( o.object )}`
    );

  }
  return true;
}

_declaringIsNeeded.defaults =
{
  object : null,
  name : null,
  combining : null,
}

//

function _defaultsApply( o )
{

  if( o.prime === null )
  o.prime = !!_.workpiece && _.workpiece.prototypeIsStandard( o.object );

  for( let k in o )
  {
    if( o[ k ] === null && _.accessor.DeclarationDefaults[ k ] !== undefined )
    o[ k ] = _.accessor.DeclarationDefaults[ k ];
  }

  _.assert( _.boolLike( o.prime ) );
  _.assert( _.boolLike( o.configurable ) );
  _.assert( _.boolLike( o.enumerable ) );
  _.assert( _.boolLike( o.addingMethods ) );
  _.assert( _.boolLike( o.preservingValue ) );

}

_defaultsApply.defaults =
{
  ... DeclarationDefaults,
}

//

function _methodsNormalize( o )
{

  _.assert( arguments.length === 1 );

  for( let mname in _.accessor.AmethodTypesMap )
  methodNormalize( o, mname );

  function methodNormalize( o, n1 )
  {
    if( _.boolLike( o[ n1 ] ) )
    o[ n1 ] = !!o[ n1 ];
  }

}

//

function _objectInitStorageUnderscore( object )
{
  _.assert( arguments.length === 1 );
  if( !Object.hasOwnProperty.call( object, '_' ) )
  Object.defineProperty( object, '_',
  {
    value : Object.create( _.object.isBasic( object._ ) ? object._ : null ),
    enumerable : false,
    writable : false,
    configurable : false,
  });
}

//

function methodWithStoringStrategyUnderscore( routine )
{
  routine.objectInitStorage = _objectInitStorageUnderscore;
  return routine;
}

//

function _amethodFunctor( propName, amethodType, storingStrategy )
{
  let fieldSymbol;

  if( storingStrategy === 'symbol' )
  {
    fieldSymbol = Symbol.for( propName );
    if( amethodType === 'grab' )
    return grabWithSymbol;
    else if( amethodType === 'get' )
    return getWithSymbol;
    else if( amethodType === 'put' )
    return putWithSymbol;
    else if( amethodType === 'set' )
    return setWithSymbol;
    else _.assert( 0 );
  }
  else if( storingStrategy === 'underscore' )
  {
    if( amethodType === 'grab' )
    return methodWithStoringStrategyUnderscore( grabWithUnderscore );
    else if( amethodType === 'get' )
    return methodWithStoringStrategyUnderscore( getWithUnderscore );
    else if( amethodType === 'put' )
    return methodWithStoringStrategyUnderscore( putWithUnderscore );
    else if( amethodType === 'set' )
    return methodWithStoringStrategyUnderscore( setWithUnderscore );
    else _.assert( 0 );
  }
  else _.assert( 0 );

  /* */

  function grabWithSymbol()
  {
    return this[ fieldSymbol ];
  }

  function getWithSymbol()
  {
    return this[ fieldSymbol ];
  }

  function putWithSymbol( src )
  {
    this[ fieldSymbol ] = src;
    return src;
  }

  function setWithSymbol( src )
  {
    this[ fieldSymbol ] = src;
    return src;
  }

  /* */

  function grabWithUnderscore()
  {
    return this._[ propName ];
  }

  function getWithUnderscore()
  {
    return this._[ propName ];
  }

  function putWithUnderscore( src )
  {
    this._[ propName ] = src;
    return src;
  }

  function setWithUnderscore( src )
  {
    this._[ propName ] = src;
    return src;
  }

  /* */

}

//

function _amethodFromMove( propName, amethodType, move )
{

  if( amethodType === 'grab' )
  return grab;
  else if( amethodType === 'get' )
  return get;
  else if( amethodType === 'put' )
  return put;
  else if( amethodType === 'set' )
  return set;
  else _.assert( 0 );

  /* */

  function grab()
  {
    let it = _.accessor._moveItMake
    ({
      srcInstance : this,
      instanceKey : propName,
      accessorKind : 'grab',
    });
    move.call( this, it );
    return it.value;
  }

  function get()
  {
    let it = _.accessor._moveItMake
    ({
      srcInstance : this,
      instanceKey : propName,
      accessorKind : 'get',
    });
    move.call( this, it );
    return it.value;
  }

  function put( src )
  {
    let it = _.accessor._moveItMake
    ({
      dstInstance : this,
      instanceKey : propName,
      value : src,
      accessorKind : 'put',
    });
    move.call( this, it );
    return it.value;
  }

  function set( src )
  {
    let it = _.accessor._moveItMake
    ({
      dstInstance : this,
      instanceKey : propName,
      value : src,
      accessorKind : 'set',
    });
    move.call( this, it );
    return it.value;
  }

}

//

function _moveItMake( o )
{
  return _.routine.options_( _moveItMake, arguments );
}

_moveItMake.defaults =
{
  dstInstance : null,
  srcInstance : null,
  instanceKey : null,
  srcContainer : null,
  dstContainer : null,
  containerKey : null,
  accessorKind : null,
  value : null,
}

//

function _objectSetValue( o )
{

  _.map.assertHasAll( o, _objectSetValue.defaults );

  let descriptor = Object.getOwnPropertyDescriptor( o.object, o.name );
  // if( descriptor && descriptor.configurable && descriptor.get == undefined && descriptor.set === undefined ) /* yyy */
  if( descriptor && descriptor.configurable && descriptor.get === undefined && descriptor.set === undefined )
  delete o.object[ o.name ];

  let val2 = _.escape.right( o.val );

  if( o.normalizedAsuite.put )
  {
    o.normalizedAsuite.put.call( o.object, val2 );
  }
  else if( o.normalizedAsuite.set )
  {
    o.normalizedAsuite.set.call( o.object, val2 );
  }
  else
  {
    let put = _.accessor._amethodFunctor( o.name, 'put', o.storingStrategy );
    put.call( o.object, val2 );
  }

}

_objectSetValue.defaults =
{
  object : null,
  normalizedAsuite : null,
  storingStrategy : null,
  name : null,
  val : null,
}

//

function _objectAddMethods( o )
{

  _.routine.assertOptions( _objectAddMethods, o );

  for( let n in o.normalizedAsuite )
  {
    if( !o.normalizedAsuite[ n ] )
    continue;
    let currentVal = o.object[ o.anames[ n ] ];
    _.assert
    (
      !Object.hasOwnProperty.call( o.object, o.anames[ n ] )
      || currentVal === o.normalizedAsuite[ n ]
      || ( _.routineIs( currentVal ) && currentVal.identity && currentVal.identity.functor )
      || _.definitionIs( currentVal )
      , () => `Object already own property ${o.anames[ n ]}`
    );
    Object.defineProperty( o.object, o.anames[ n ],
    {
      value : o.normalizedAsuite[ n ],
      enumerable : false,
      writable : true,
      configurable : true,
    });
  }

}

_objectAddMethods.defaults =
{
  object : null,
  normalizedAsuite : null,
  anames : null,
}

//

function _objectInitStorage( object, normalizedAsuite )
{
  let initers = new Set();

  _.assert( arguments.length === 2 );
  _.assert( _.mapIs( normalizedAsuite ) );

  for( let k in normalizedAsuite )
  {
    let method = normalizedAsuite[ k ];
    if( !method.objectInitStorage )
    continue;
    initers.add( method.objectInitStorage );
  }

  // if( initers.size > 1 )
  // debugger;

  for( let initer of initers )
  {
    initer( object );
  }

}

//

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
  _.assert( _.strDefined( o.declaratorName ) );
  _.assert( _.arrayIs( o.declaratorArgs ) );

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

// --
// declare
// --

function suiteMove( dst, src )
{
  let hasAccessor = dst !== undefined && dst !== null && dst !== false;

  for( let k in _.accessor.AmethodTypesMap )
  if( src[ k ] !== undefined && src[ k ] !== null )
  {
    hasAccessor = true
    break;
  }

  if( hasAccessor )
  {
    if( _.mapIs( dst ) )
    {
      dst = Object.assign( Object.create( null ), dst );
    }
    else
    {
      _.assert( !_.boolLikeFalse( dst ) );
      dst = Object.create( null );
    }
    for( let k in _.accessor.AmethodTypesMap )
    if( src[ k ] !== undefined && src[ k ] !== null )
    dst[ k ] = src[ k ];
  }

  for( let k in _.accessor.AmethodTypesMap )
  if( src[ k ] !== undefined && src[ k ] !== null )
  delete src[ k ];

  return dst;
}

//

function suiteSupplement( dst, src )
{

  _.assert( dst === null || _.mapIs( dst ) );
  _.assert( _.mapIs( src ) );

  dst = dst || Object.create( null );

  for( let m in _.accessor.AmethodTypesMap )
  {
    if( dst[ m ] === null || dst[ m ] === undefined || _.boolLikeTrue( dst[ m ] ) )
    if( _.routineIs( src[ m ] ) || _.boolLikeFalse( src[ m ] ) )
    dst[ m ] = src[ m ];
  }

  return dst;
}

//

function suiteNormalize_body( o )
{

  _.map.assertHasAll( o, suiteNormalize_body.defaults );

  /* */

  _.debugger;

  if( !o.normalizedAsuite )
  {

    o.suite = _.accessor._amethodUnfunct
    ({
      amethod : o.suite,
      accessor : o,
      kind : 'suite',
      withDefinition : true,
      withFunctor : true,
    });

    o.normalizedAsuite = _.accessor._normalizedAsuiteForm.body
    ({
      name : o.name,
      methods : o.methods,
      suite : o.suite,
      writable : o.writable,
      storingStrategy : o.storingStrategy,
      normalizedAsuite :
      {
        grab : o.grab,
        get : o.get,
        put : o.put,
        set : o.set,
        move : o.move,
      },
    });

    _.accessor._normalizedAsuiteUnfunct
    ({
      accessor : o,
      normalizedAsuite : o.normalizedAsuite,
      withDefinition : false,
      withFunctor : true,
    });

  }

  return o;
}

var defaults = suiteNormalize_body.defaults =
{
  ... AmethodTypesMap,
  ... DeclarationSpecialDefaults,
  ... DeclarationOptions,
}

let suiteNormalize = _.routine.uniteCloning_replaceByUnite( declareSingle_head, suiteNormalize_body );

//

function declareSingle_head( routine, args )
{

  let o = args[ 0 ];
  if( o.val === null )
  o.val = _.null;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  _.routine.options_( routine, o );
  _.assert( !_.primitiveIs( o.object ), 'Expects object as argument but got', o.object );
  _.assert( _.strIs( o.name ) || _.symbolIs( o.name ) );
  _.assert( _.longHas( [ null, 0, false, 1, true, 'rewrite', 'supplement' ], o.combining ), 'not tested' );

  if( _.boolLikeTrue( o.combining ) )
  o.combining = 'rewrite';

  if( _.boolLike( o.writable ) )
  o.writable = !!o.writable;

  if( _.boolLikeTrue( o.suite ) )
  o.suite = Object.create( null );

  _.map.assertHasAll( o, routine.defaults );

  _.accessor._methodsNormalize( o );
  _.accessor._defaultsApply( o );

  _.assert( _.boolIs( o.writable ) || o.writable === null );

  return o;
}

function declareSingle_body( o )
{

  _.map.assertHasAll( o, declareSingle_body.defaults );
  _.assert( _.boolIs( o.writable ) || o.writable === null );
  _.assert( o.object !== Object, 'Attempt to polute _global_.Object' );
  _.assert( !_.prototype._ofStandardEntity( o.object ), 'Attempt to pollute _global_.Object.prototype' );

  /* */

  _.debugger;
  o.needed = _.accessor._declaringIsNeeded( o );
  if( !o.needed )
  return false;

  /* */

  if( !o.normalizedAsuite )
  _.accessor.suiteNormalize( o );

  if( o.writable === null )
  o.writable = !!o.normalizedAsuite.set;
  _.assert( _.boolLike( o.writable ) );

  let anames;
  if( o.prime || o.addingMethods )
  anames = _.accessor._objectMethodsNamesGet
  ({
    object : o.object,
    normalizedAsuite : o.normalizedAsuite,
    name : o.name,
  })

  /* */

  if( o.prime )
  register();

  /* addingMethods */

  if( o.addingMethods )
  _.accessor._objectAddMethods
  ({
    object : o.object,
    normalizedAsuite : o.normalizedAsuite,
    anames,
  });

  /* init storage */

  if( o.storageIniting )
  _.accessor._objectInitStorage( o.object, o.normalizedAsuite );

  /* cache value */

  _.debugger;
  if( o.storageIniting && o.valueGetting)
  {

    if( _.definitionIs( o.normalizedAsuite.get ) )
    {
      if( o.val === _.nothing )
      o.val = _.definition.toVal( o.normalizedAsuite.get );
      o.normalizedAsuite.get = null;
    }

    if( o.val === _.nothing )
    if( o.preservingValue && Object.hasOwnProperty.call( o.object, o.name ) )
    o.val = o.object[ o.name ];

  }

  /* define accessor */

  let descriptor = _.props.declare.body
  ({
    object : o.object,
    name : o.name,
    enumerable : !!o.enumerable,
    configurable : !!o.configurable,
    writable : !!o.writable,
    get : o.normalizedAsuite.get,
    set : o.normalizedAsuite.set,
    val : o.normalizedAsuite.get === null ? o.val : _.nothing,
  });

  /* set value */

  _.debugger;
  if( o.storageIniting && o.valueSetting )
  if( o.val !== _.nothing && descriptor.get )
  {
    _.accessor._objectSetValue
    ({
      object : o.object,
      normalizedAsuite : o.normalizedAsuite,
      storingStrategy : o.storingStrategy,
      name : o.name,
      val : o.val,
    });
  }

  /* validate */

  if( Config.debug )
  validate();

  return o;

  /* - */

  function validate()
  {
    _.accessor._objectMethodsValidate({ object : o.object, name : o.name, normalizedAsuite : o.normalizedAsuite });
  }

  /* */

  function register()
  {

    let o2 = _.props.extend( null, o );
    o2.names = o.name;
    o2.methods = Object.create( null );
    o2.object = null;
    delete o2.name;
    delete o2.normalizedAsuite;

    for( let k in o.normalizedAsuite )
    if( o.normalizedAsuite[ k ] )
    o2.methods[ anames[ k ] ] = o.normalizedAsuite[ k ];

    _.accessor._register
    ({
      proto : o.object,
      name : o.name,
      declaratorName : 'accessor',
      declaratorArgs : [ o2 ],
      combining : o.combining,
    });

  }

  /* */

}

var defaults = declareSingle_body.defaults =
{
  ... AmethodTypesMap,
  ... DeclarationSpecialDefaults,
  ... DeclarationOptions,
}

let declareSingle = _.routine.uniteCloning_replaceByUnite( declareSingle_head, declareSingle_body );

//

/**
 * Accessor options
 * @typedef {Object} AccessorOptions
 * @property {Object} [ object=null ] - source object wich properties will get getter/setter defined.
 * @property {Object} [ names=null ] - map that that contains names of fields for wich function defines setter/getter.
 * Function uses values( rawName ) of object( o.names ) properties to check if fields of( o.object ) have setter/getter.
 * Example : if( rawName ) is 'a', function searchs for '_aSet' or 'aSet' and same for getter.
 * @property {Object} [ methods=null ] - object where function searchs for existing setter/getter of property.
 * @property {Array} [ message=null ] - setter/getter prints this message when called.
 * @property {Boolean} [ strict=true ] - makes object field private if no getter defined but object must have own constructor.
 * @property {Boolean} [ enumerable=true ] - sets property descriptor enumerable option.
 * @property {Boolean} [ preservingValue=true ] - saves values of existing object properties.
 * @property {Boolean} [ prime=true ]
 * @property {String} [ combining=null ]
 * @property {Boolean} [ writable=true ] - if false function doesn't define setter to property.
 * @property {Boolean} [ configurable=false ]
 * @property {Function} [ get=null ]
 * @property {Function} [ set=null ]
 * @property {Function} [ suite=null ]
 *
 * @namespace Tools.accessor
 **/

/**
 * Defines set/get functions on source object( o.object ) properties if they dont have them.
 * If property specified by( o.names ) doesn't exist on source( o.object ) function creates it.
 * If ( o.object.constructor.prototype ) has property with getter defined function forbids set/get access
 * to object( o.object ) property. Field can be accessed by use of Symbol.for( rawName ) function,
 * where( rawName ) is value of property from( o.names ) object.
 *
 * Can be called in three ways:
 * - First by passing all options in one object( o );
 * - Second by passing ( object ) and ( names ) options;
 * - Third by passing ( object ), ( names ) and ( message ) option as third parameter.
 *
 * @param {Object} o - options {@link module:Tools/base/Proto.wTools.accessor~AccessorOptions}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * _.accessor.declare( Self, { a : 'a' }, 'set/get call' )
 * Self.a = 1; // set/get call
 * Self.a;
 * // returns
 * // set/get call
 * // 1
 *
 * @throws {exception} If( o.object ) is not a Object.
 * @throws {exception} If( o.names ) is not a Object.
 * @throws {exception} If( o.methods ) is not a Object.
 * @throws {exception} If( o.message ) is not a Array.
 * @throws {exception} If( o ) is extented by unknown property.
 * @throws {exception} If( o.strict ) is true and object doesn't have own constructor.
 * @throws {exception} If( o.writable ) is false and property has own setter.
 * @function declare
 * @namespace Tools.accessor
 */

function declareMultiple_head( routine, args )
{
  let o;

  _.assert( arguments.length === 2 );

  if( args.length === 1 )
  {
    o = args[ 0 ];
  }
  else
  {
    o = Object.create( null );
    o.object = args[ 0 ];
    o.names = args[ 1 ];
    _.assert( args.length >= 2 );
  }

  if( args.length > 2 )
  {
    _.assert( o.messages === null || o.messages === undefined );
    o.message = _.longSlice( args, 2 );
  }

  if( _.strIs( o.names ) )
  o.names = { [ o.names ] : o.names }

  _.routine.options_( routine, o );

  if( _.boolLike( o.writable ) )
  o.writable = !!o.writable;

  _.assert( !_.primitiveIs( o.object ), 'Expects object as argument but got', o.object );
  _.assert( _.object.isBasic( o.names ) || _.arrayIs( o.names ), 'Expects object names as argument but got', o.names );

  return o;
}

function declareMultiple_body( o )
{

  _.routine.assertOptions( declareMultiple_body, arguments );

  if( _.argumentsArray.like( o.object ) )
  {
    _.each( o.object, ( object ) =>
    {
      let o2 = _.props.extend( null, o );
      o2.object = object;
      declareMultiple_body( o2 );
    });
    return o.object;
  }

  if( !o.methods )
  o.methods = o.object;

  /* verification */

  _.assert( !_.primitiveIs( o.methods ) );
  _.assert( !_.primitiveIs( o.object ), () => 'Expects object {-object-}, but got ' + _.entity.exportStringDiagnosticShallow( o.object ) );
  _.assert( _.object.isBasic( o.names ), () => 'Expects object {-names-}, but got ' + _.entity.exportStringDiagnosticShallow( o.names ) );

  /* */

  let result = Object.create( null );
  for( let name in o.names )
  result[ name ] = declare( name, o.names[ name ] );

  let names2 = Object.getOwnPropertySymbols( o.names );
  for( let n = 0 ; n < names2.length ; n++ )
  result[ names2[ n ] ] = declare( names2[ n ], o.names[ names2[ n ] ] );

  return result;

  /* */

  function declare( name, extension )
  {
    let o2 = Object.assign( Object.create( null ), o );

    _.assert( !_.routineIs( extension ) || !extension.identity || _.mapIs( extension.identity ) );

    if( _.mapIs( extension ) )
    {
      _.map.assertHasOnly( extension, _.accessor.DeclarationMultipleToSingleOptions );
      _.props.extend( o2, extension );
      _.assert( !!o2.object );
    }
    else if( _.definitionIs( extension ) )
    {
      o2.suite = extension;
    }
    else if( _.routineIs( extension ) && extension.identity && extension.identity.functor )
    {
      _.props.extend( o2, { suite : extension } );
    }
    else _.assert( name === extension, `Unexpected type ${_.entity.strType( extension )}` );

    o2.name = name;
    delete o2.names;

    return _.accessor.declareSingle( o2 );
    // return _.accessor.declareSingle.body( o2 );
  }

}

var defaults = declareMultiple_body.defaults = _.props.extend( null, declareSingle.defaults );
defaults.names = null;
delete defaults.name;

let declareMultiple = _.routine.uniteCloning_replaceByUnite( declareMultiple_head, declareMultiple_body );

//

/**
 * @summary Declares forbid accessor.
 * @description
 * Forbid accessor throws an Error when user tries to get value of the property.
 * @param {Object} o - options {@link module:Tools/base/Proto.wTools.accessor~AccessorOptions}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * _.accessor.forbid( Self, { a : 'a' } )
 * Self.a; // throw an Error
 *
 * @function forbid
 * @namespace Tools.accessor
 */

function forbid_body( o )
{

  _.routine.assertOptions( forbid_body, arguments );

  if( !o.methods )
  o.methods = Object.create( null );

  if( _.argumentsArray.like( o.object ) )
  {
    _.each( o.object, ( object ) =>
    {
      let o2 = _.props.extend( null, o );
      o2.object = object;
      forbid_body( o2 );
    });
    return o.object;
  }

  if( _.object.isBasic( o.names ) )
  o.names = _.props.extend( null, o.names );

  if( o.prime === null )
  o.prime = !!_.workpiece && _.workpiece.prototypeIsStandard( o.object );

  /* verification */

  _.assert( !_.primitiveIs( o.object ), () => 'Expects object {-o.object-} but got ' + _.entity.exportStringDiagnosticShallow( o.object ) );
  _.assert( _.object.isBasic( o.names ) || _.arrayIs( o.names ), () => 'Expects object {-o.names-} as argument but got ' + _.entity.exportStringDiagnosticShallow( o.names ) );

  /* message */

  let _constructor = o.object.constructor || null;
  _.assert( _.routineIs( _constructor ) || _constructor === null );
  if( !o.protoName )
  o.protoName = ( _constructor ? ( _constructor.name || _constructor._name || '' ) : '' ) + '.';
  if( o.message )
  o.message = _.arrayIs( o.message ) ? o.message.join( ' : ' ) : o.message;
  else
  o.message = 'is deprecated';

  /* property */

  if( _.object.isBasic( o.names ) )
  {
    let result = Object.create( null );

    for( let n in o.names )
    {
      let name = o.names[ n ];
      let o2 = _.props.extend( null, o );
      o2.propName = name;
      _.assert( n === name, () => 'Key and value should be the same, but ' + _.strQuote( n ) + ' and ' + _.strQuote( name ) + ' are not' );
      let declared = _.accessor._forbidSingle( o2 );
      if( declared )
      result[ name ] = declared;
      else
      delete o.names[ name ];
    }

    return result;
  }
  else
  {
    let result = [];
    let namesArray = o.names;

    o.names = Object.create( null );
    for( let n = 0 ; n < namesArray.length ; n++ )
    {
      let name = namesArray[ n ];
      let o2 = _.props.extend( null, o );
      o2.propName = name;
      let delcared = _.accessor._forbidSingle( o2 );
      if( declared )
      {
        o.names[ name ] = declared;
        result.push( declared );
      }
    }

    return result;
  }

}

var defaults = forbid_body.defaults =
{

  ... declareMultiple.body.defaults,

  preservingValue : 0,
  enumerable : 0,
  combining : 'rewrite',
  writable : true,
  message : null,

  prime : 0,
  strict : 0,

}

let forbid = _.routine.uniteCloning_replaceByUnite( declareMultiple_head, forbid_body );

//

function _forbidSingle()
{
  let o = _.routine.options_( _forbidSingle, arguments );
  let messageLine = o.protoName + o.propName + ' : ' + o.message;

  _.assert( _.strIs( o.protoName ) );
  _.assert( _.object.isBasic( o.methods ) );

  /* */

  let propertyDescriptor = _.props.descriptorActiveOf( o.object, o.propName );
  if( propertyDescriptor.descriptor )
  {
    _.assert( _.strIs( o.combining ), 'forbid : if accessor overided expect ( o.combining ) is', _.accessor.Combining.join() );

    if( _.routineIs( propertyDescriptor.descriptor.get ) && propertyDescriptor.descriptor.get.name === 'forbidden' )
    {
      return false;
    }

  }

  /* */

  if( !Object.isExtensible( o.object ) )
  {
    return false;
  }

  o.methods = null;
  o.suite = Object.create( null );
  o.suite.grab = forbidden;
  o.suite.get = forbidden;
  o.suite.put = forbidden;
  o.suite.set = forbidden;
  forbidden.isForbid = true;

  /* */

  if( o.prime )
  {

    _.assert( 0, 'not tested' );
    let o2 = _.props.extend( null, o );
    o2.names = o.propName;
    o2.object = null;
    delete o2.protoName;
    delete o2.propName;

    _.accessor._register
    ({
      proto : o.object,
      name : o.propName,
      declaratorName : 'forbid',
      declaratorArgs : [ o2 ],
      combining : o.combining,
    });

  }

  _.assert( !o.strict );
  _.assert( !o.prime );

  o.strict = 0;
  o.prime = 0;

  let o2 = _.mapOnly_( null, o, _.accessor.declare.body.defaults );
  o2.name = o.propName;
  delete o2.names;
  return _.accessor.declareSingle.body( o2 );

  /* */

  function forbidden()
  {
    throw _.err( messageLine );
  }

}

var defaults = _forbidSingle.defaults =
{
  ... forbid.defaults,
  propName : null,
  protoName : null,
}

//

/**
 * Checks if source object( object ) has own property( name ) and its forbidden.
 * @param {Object} object - source object
 * @param {String} name - name of the property
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * _.accessor.forbid( Self, { a : 'a' } );
 * _.accessor.ownForbid( Self, 'a' ) // returns true
 * _.accessor.ownForbid( Self, 'b' ) // returns false
 *
 * @function ownForbid
 * @namespace Tools.accessor
 */

function ownForbid( object, name )
{
  if( !Object.hasOwnProperty.call( object, name ) )
  return false;

  let descriptor = Object.getOwnPropertyDescriptor( object, name );
  if( _.routineIs( descriptor.get ) && descriptor.get.isForbid )
  {
    return true;
  }
  else
  {
    return false;
  }

}

// --
// etc
// --

/**
 * @summary Declares read-only accessor( s ).
 * @description Expects two arguments: (object), (names) or single as options map {@link module:Tools/base/Proto.wTools.accessor~AccessorOptions}
 *
 * @param {Object} object - target object
 * @param {Object} names - contains names of properties that will get read-only accessor
 *
 * @example
 * var Alpha = function _Alpha(){}
 * _.classDeclare
 * ({
 *   cls : Alpha,
 *   parent : null,
 *   extend : { Composes : { a : null } }
 * });
 * _.accessor.readOnly( Alpha.prototype,{ a : 'a' });
 *
 * @function forbid
 * @namespace Tools.accessor
 */

function readOnly_body( o )
{
  _.routine.assertOptions( readOnly_body, arguments );
  _.assert( _.boolLikeFalse( o.writable ) );
  return _.accessor.declare.body( o );
}

var defaults = readOnly_body.defaults = _.props.extend( null, declareMultiple.body.defaults );
defaults.writable = false;

let readOnly = _.routine.uniteCloning_replaceByUnite( declareMultiple_head, readOnly_body );

//

let AccessorExtension =
{

  // getter / setter generator

  _propertyGetterSetterNames,
  _normalizedAsuiteForm,
  _normalizedAsuiteUnfunct,
  _amethodUnfunct,

  _objectMethodsNamesGet,
  _objectMethodsGet,
  _objectMethodsValidate,
  _objectMethodMoveGet,

  _objectSetValue,
  _objectAddMethods,
  _objectInitStorage,
  _declaringIsNeeded,

  _defaultsApply,
  _methodsNormalize,
  _objectInitStorageUnderscore,
  methodWithStoringStrategyUnderscore,
  _amethodFunctor,
  _amethodFromMove,
  _moveItMake,
  _register,

  // declare

  suiteMove, /* qqq : cover */
  suiteSupplement, /* qqq : cover */
  suiteNormalize,

  declareSingle,
  declareMultiple,
  declare : declareMultiple,

  // forbid

  forbid,
  _forbidSingle,
  ownForbid,

  // etc

  readOnly,

  // fields

  Combining,
  AmethodTypes,
  AmethodTypesMap,
  DeclarationOptions,
  DeclarationDefaults,
  DeclarationMultipleToSingleOptions,

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

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

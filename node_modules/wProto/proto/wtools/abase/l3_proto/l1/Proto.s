( function _Proto_s_() {

'use strict';

/**
 * Collection of cross-platform routines to define classes and relations between them.
 */

/**
* Definitions :

*  self :: current object.
*  Self :: current class.
*  Parent :: parent class.
*  Statics :: static fields.
*  extend :: extend destination with all properties from source.
*  supplement :: supplement destination with those properties from source which do not belong to source.

*  routine :: arithmetical, logical and other manipulations on input data, context and globals to get output data.
*  function :: routine which does not have side effects and don't use globals or context.
*  procedure :: routine which use globals, possibly modify global's states.
*  method :: routine which has context, possibly modify context's states.

* Synonym :

  A composes B
    :: A consists of B.s
    :: A comprises B.
    :: A made up of B.
    :: A exists because of B, and B exists because of A.
    :: A складається із B.
  A aggregates B
    :: A has B.
    :: A exists because of B, but B exists without A.
    :: A має B.
  A associates B
    :: A has link on B
    :: A is linked with B
    :: A посилається на B.
  A restricts B
    :: A use B.
    :: A has occasional relation with B.
    :: A використовує B.
    :: A має обмежений, не чіткий, тимчасовий звязок із B.

*/

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

const _ObjectHasOwnProperty = Object.hasOwnProperty;
const _ObjectPropertyIsEumerable = Object.propertyIsEnumerable;
// let _nameFielded = _.nameFielded;

_.assert( _.object.isBasic( _.props ), 'wProto needs Tools/wtools/abase/l1/FieldMapper.s' );
// _.assert( _.routineIs( _nameFielded ), 'wProto needs Tools/wtools/l3/NameTools.s' );

// --
// prototype
// --

/**
 * Make united interface for several maps. Access to single map cause read and write to original maps.
 * @param {array} protos - maps to united.
 * @return {object} united interface.
 * @function prototypeUnitedInterface
 * @namespace Tools
 * @module Tools/base/Proto
 */

function prototypeUnitedInterface( protos )
{
  let result = Object.create( null );
  let unitedArraySymbol = Symbol.for( '_unitedArray_' );
  let unitedMapSymbol = Symbol.for( '_unitedMap_' );
  let protoMap = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( protos ) );

  /* */

  for( let p = 0 ; p < protos.length ; p++ )
  {
    let proto = protos[ p ];
    for( let f in proto )
    {
      if( f in protoMap )
      throw _.err( 'prototypeUnitedInterface :', 'several objects try to unite have same field :', f );
      protoMap[ f ] = proto;

      let methods = Object.create( null )
      methods[ f + 'Get' ] = get( f );
      methods[ f + 'Set' ] = set( f );
      let names = Object.create( null );
      names[ f ] = f;
      _.accessor.declare
      ({
        object : result,
        names,
        methods,
        strict : 0,
        prime : 0,
      });

    }
  }

  /*result[ unitedArraySymbol ] = protos;*/
  result[ unitedMapSymbol ] = protoMap;

  return result;

  /* */

  function get( propName )
  {
    return function unitedGet()
    {
      return this[ unitedMapSymbol ][ propName ][ propName ];
    }
  }
  function set( propName )
  {
    return function unitedSet( value )
    {
      this[ unitedMapSymbol ][ propName ][ propName ] = value;
    }
  }
}

//

/**
 * Append prototype to object. Find archi parent and replace its proto.
 * @param {object} dstMap - dst object to append proto.
 * @function prototypeAppend
 * @namespace Tools
 * @module Tools/base/Proto
 */

function prototypeAppend( dstMap )
{

  _.assert( _.object.isBasic( dstMap ) );

  for( let a = 1 ; a < arguments.length ; a++ )
  {
    let proto = arguments[ a ];

    _.assert( _.object.isBasic( proto ) );

    let parent = _.prototypeArchyGet( dstMap );
    Object.setPrototypeOf( parent, proto );

  }

  return dstMap;
}

//

/**
 * Returns parent which has default proto.
 * @param {object} srcPrototype - dst object to append proto.
 * @function prototypeArchyGet
 * @namespace Tools
 * @module Tools/base/Proto
 */

function prototypeArchyGet( srcPrototype )
{

  _.assert( _.object.isBasic( srcPrototype ) );

  while( Object.getPrototypeOf( srcPrototype ) !== Object.prototype )
  srcPrototype = Object.getPrototypeOf( srcPrototype );

  return srcPrototype;
}

//

/*
_.prototypeCrossRefer
({
  namespace : _,
  entities :
  {
    System : Self,
  },
  names :
  {
    System : 'LiveSystem',
    Node : 'LiveNode',
  },
});
*/

let _protoCrossReferAssociations = Object.create( null );
function prototypeCrossRefer( o )
{
  let names = _.props.keys( o.entities );
  let length = names.length;

  let association = _protoCrossReferAssociations[ o.name ];
  if( !association )
  {
    _.assert( _protoCrossReferAssociations[ o.name ] === undefined );
    association = _protoCrossReferAssociations[ o.name ] = Object.create( null );
    association.name = o.name;
    association.length = length;
    association.have = 0;
    association.entities = _.props.extend( null, o.entities );
  }
  else
  {
    _.assert( _.arraySetIdentical( _.props.keys( association.entities ), _.props.keys( o.entities ) ), 'cross reference should have same associations' );
  }

  _.assert( association.name === o.name );
  _.assert( association.length === length );

  for( let e in o.entities )
  {
    if( !association.entities[ e ] )
    association.entities[ e ] = o.entities[ e ];
    else if( o.entities[ e ] )
    _.assert( association.entities[ e ] === o.entities[ e ] );
  }

  association.have = 0;
  for( let e in association.entities )
  if( association.entities[ e ] )
  association.have += 1;

  if( association.have === association.length )
  {

    for( let src in association.entities )
    for( let dst in association.entities )
    {
      if( src === dst )
      continue;
      let dstEntity = association.entities[ dst ];
      let srcEntity = association.entities[ src ];
      _.assert( !dstEntity[ src ] || dstEntity[ src ] === srcEntity, 'override of entity', src );
      _.assert( !dstEntity.prototype[ src ] || dstEntity.prototype[ src ] === srcEntity );
      _.classExtend( dstEntity, { Statics : { [ src ] : srcEntity } } );
      _.assert( dstEntity[ src ] === srcEntity );
      _.assert( dstEntity.prototype[ src ] === srcEntity );
    }

    _protoCrossReferAssociations[ o.name ] = null;

    return true;
  }

  return false;
}

prototypeCrossRefer.defaults =
{
  entities : null,
  name : null,
}

// --
// proxy
// --

function proxyNoUndefined( ins )
{

  let validator =
  {
    set : function( obj, k, e )
    {
      if( obj[ k ] === undefined )
      throw _.err( 'Map does not have field', k );
      obj[ k ] = e;
      return true;
    },
    get : function( obj, k )
    {
      if( !_.symbolIs( k ) )
      if( obj[ k ] === undefined )
      throw _.err( 'Map does not have field', k );
      return obj[ k ];
    },

  }

  let result = new Proxy( ins, validator );

  return result;
}

//

function proxyReadOnly( ins )
{

  let validator =
  {
    set : function( obj, k, e )
    {
      throw _.err( 'Read only', _.entity.strType( ins ), ins );
    }
  }

  let result = new Proxy( ins, validator );

  return result;
}

//

function ifDebugProxyReadOnly( ins )
{

  if( !Config.debug )
  return ins;

  return _.proxyReadOnly( ins );
}

//

// function proxyMap( front, back )
function proxyMap( o )
{

  if( arguments.length === 2 )
  o = { front : arguments[ 0 ], back : arguments[ 1 ] }
  o = _.routine.options_( proxyMap, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !!o.front );
  _.assert( !!o.back );
  let back = o.back;

  let handler =
  {
    get : function( front, key, proxy )
    {
      if( front[ key ] !== undefined )
      return front[ key ];
      return back[ key ];
    },
    set : function( front, key, val, proxy )
    {
      if( front[ key ] !== undefined )
      front[ key ] = val;
      else if( back[ key ] !== undefined )
      back[ key ] = val;
      else
      front[ key ] = val;
      return true;
    },
  }

  let result = new Proxy( o.front, handler );

  return result;
}

proxyMap.defaults =
{
  front : null,
  back : null,
}

//

function proxyShadow( o )
{

  if( arguments.length === 2 )
  o = { front : arguments[ 0 ], back : arguments[ 1 ] }
  o = _.routine.options_( proxyShadow, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !!o.front );
  _.assert( !!o.back );
  let front = o.front;

  let handler =
  {
    get : function( back, key, context )
    {
      if( front[ key ] !== undefined )
      return front[ key ];
      return Reflect.get( ... arguments );
    },
    set : function( back, key, val, context )
    {
      if( front[ key ] !== undefined )
      {
        front[ key ] = val;
        return true;
      }
      return Reflect.set( ... arguments );
    },
  };

  let shadowProxy = new Proxy( o.back, handler );

  return shadowProxy;
}

proxyShadow.defaults =
{
  front : null,
  back : null,
}

// --
// default
// --

/*
apply default to each element of map, if present
*/

function defaultApply( src )
{

  _.assert( _.object.isBasic( src ) || _.longIs( src ) );

  let defVal = src[ _.def ];

  if( !defVal )
  return src;

  _.assert( _.object.isBasic( src ) );

  if( _.object.isBasic( src ) )
  {

    for( let s in src )
    {
      if( !_.object.isBasic( src[ s ] ) )
      continue;
      _.props.supplement( src[ s ], defVal );
    }

  }
  else
  {

    for( let s = 0 ; s < src.length ; s++ )
    {
      if( !_.object.isBasic( src[ s ] ) )
      continue;
      _.props.supplement( src[ s ], defVal );
    }

  }

  return src;
}

//

/*
activate default proxy
*/

function defaultProxy( map )
{

  _.assert( _.object.isBasic( map ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let validator =
  {
    set : function( obj, k, e )
    {
      obj[ k ] = _.defaultApply( e );
      return true;
    }
  }

  let result = new Proxy( map, validator );

  for( let k in map )
  {
    _.defaultApply( map[ k ] );
  }

  return result;
}

//

function defaultProxyFlatteningToArray( src )
{
  let result = [];

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.object.isBasic( src ) || _.arrayIs( src ) );

  function flatten( src )
  {

    if( _.arrayIs( src ) )
    {
      for( let s = 0 ; s < src.length ; s++ )
      flatten( src[ s ] );
    }
    else
    {
      if( _.object.isBasic( src ) )
      result.push( defaultApply( src ) );
      else
      result.push( src );
    }

  }

  flatten( src );

  return result;
}

// --
// type
// --

class wCallableObject extends Function
{
  constructor()
  {
    super( 'return this.routine.__call__.apply( this.routine, arguments );' );
    let context = Object.create( null );
    let routine = this.bind( context );
    context.routine = routine;
    Object.freeze( context );
    return routine;
  }
}

wCallableObject.shortName = 'CallableObject';

_.assert( wCallableObject.shortName === 'CallableObject' );

// --
// fields
// --

/**
 * @typedef {Object} DefaultFieldsGroups - contains predefined class fields groups.
 * @module Tools/base/Proto
 */

/**
 * @typedef {Object} DefaultFieldsGroupsRelations - contains predefined class relationship types.
 * @module Tools/base/Proto
 */

/**
 * @typedef {Object} DefaultFieldsGroupsCopyable - contains predefined copyable class fields groups.
 * @module Tools/base/Proto
 */

/**
 * @typedef {Object} DefaultFieldsGroupsTight
 * @module Tools/base/Proto
 */

/**
 * @typedef {Object} DefaultFieldsGroupsInput
 * @module Tools/base/Proto
 */

/**
 * @typedef {Object} DefaultForbiddenNames - contains names of forbidden properties
 * @module Tools/base/Proto
 */

let DefaultFieldsGroups = Object.create( null );
DefaultFieldsGroups.Groups = 'Groups';
DefaultFieldsGroups.Composes = 'Composes';
DefaultFieldsGroups.Aggregates = 'Aggregates';
DefaultFieldsGroups.Associates = 'Associates';
DefaultFieldsGroups.Restricts = 'Restricts';
DefaultFieldsGroups.Medials = 'Medials';
DefaultFieldsGroups.Statics = 'Statics';
DefaultFieldsGroups.Copiers = 'Copiers';
Object.freeze( DefaultFieldsGroups );

let DefaultFieldsGroupsRelations = Object.create( null );
DefaultFieldsGroupsRelations.Composes = 'Composes';
DefaultFieldsGroupsRelations.Aggregates = 'Aggregates';
DefaultFieldsGroupsRelations.Associates = 'Associates';
DefaultFieldsGroupsRelations.Restricts = 'Restricts';
Object.freeze( DefaultFieldsGroupsRelations );

let DefaultFieldsGroupsCopyable = Object.create( null );
DefaultFieldsGroupsCopyable.Composes = 'Composes';
DefaultFieldsGroupsCopyable.Aggregates = 'Aggregates';
DefaultFieldsGroupsCopyable.Associates = 'Associates';
Object.freeze( DefaultFieldsGroupsCopyable );

let DefaultFieldsGroupsTight = Object.create( null );
DefaultFieldsGroupsTight.Composes = 'Composes';
DefaultFieldsGroupsTight.Aggregates = 'Aggregates';
Object.freeze( DefaultFieldsGroupsTight );

let DefaultFieldsGroupsInput = Object.create( null );
DefaultFieldsGroupsInput.Composes = 'Composes';
DefaultFieldsGroupsInput.Aggregates = 'Aggregates';
DefaultFieldsGroupsInput.Associates = 'Associates';
DefaultFieldsGroupsInput.Medials = 'Medials';
Object.freeze( DefaultFieldsGroupsInput );

let DefaultForbiddenNames = Object.create( null );
DefaultForbiddenNames.Static = 'Static';
DefaultForbiddenNames.Type = 'Type';
Object.freeze( DefaultForbiddenNames );

// --
// define
// --

let ToolsExtension =
{

  // prototype

  prototypeUnitedInterface, /* experimental */

  prototypeAppend, /* experimental */
  prototypeArchyGet, /* experimental */

  prototypeCrossRefer, /* experimental */

  // proxy

  proxyNoUndefined,
  proxyReadOnly,
  ifDebugProxyReadOnly,
  proxyMap,
  proxyShadow,

  // default

  defaultApply,
  defaultProxy,
  defaultProxyFlatteningToArray,

  // fields

  DefaultFieldsGroups,
  DefaultFieldsGroupsRelations,
  DefaultFieldsGroupsCopyable,
  DefaultFieldsGroupsTight,
  DefaultFieldsGroupsInput,

  DefaultForbiddenNames,
  CallableObject : wCallableObject,

}

//

_.props.extend( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;


})();

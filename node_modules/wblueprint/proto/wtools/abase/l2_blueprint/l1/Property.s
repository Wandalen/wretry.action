( function _Property_s_()
{

'use strict';

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

/**
 * @summary Defines hidden property with name( name ) and value( value ) on target object( dstPrototype ).
 *
 * @description
 * Property is defined as not enumarable.
 * Also accepts second argument as map of properties.
 * If second argument( name ) is a map and third argument( value ) is also defined, then all properties will have value of last arg.
 *
 * @param {Object} dstPrototype - target object
 * @param {String|Object} name - name of property or map of names
 * @param {*} value - destination object
 *
 * @throws {Exception} If number of arguments is not supported.
 * @throws {Exception} If dstPrototype is not an Object
 * @function conceal
 *
 * @namespace Tools.property
 * @module Tools/base/Proto
 */

function conceal( dstPrototype, name, value )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( !_.primitiveIs( dstPrototype ), () => 'dstPrototype is needed, but got ' + _.entity.exportStringDiagnosticShallow( dstPrototype ) );

  if( _.containerIs( name ) )
  {
    if( !_.object.isBasic( name ) )
    name = _.indexExtending( name, ( e ) => { return { [ e ] : undefined } } );
    _.each( name, ( v, n ) =>
    {
      if( value === undefined )
      _.props.conceal( dstPrototype, n, v );
      else
      _.props.conceal( dstPrototype, n, value );
    });
    return;
  }

  if( value === undefined )
  value = dstPrototype[ name ];

  _.assert( _.strIs( name ), 'name is needed, but got', name );

  Object.defineProperty( dstPrototype, name,
  {
    value,
    enumerable : false,
    writable : true,
    configurable : true,
  });

}

//

/**
 * Makes constants properties on object by creating new or replacing existing properties.
 * @param {object} dstPrototype - prototype of class which will get new constant property.
 * @param {object} namesObject - name/value map of constants.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * let Constants = { num : 100  };
 * _.props.constant( Self.prototype, Constants );
 * console.log( Self.prototype ); // returns { num: 100 }
 * Self.prototype.num = 1;// error assign to read only property
 *
 * @function constant
 * @throws {exception} If no argument provided.
 * @throws {exception} If( dstPrototype ) is not a Object.
 * @throws {exception} If( name ) is not a Map.
 * @namespace Tools.property
 * @module Tools/base/Proto
 */

function _constant( dstPrototype, name, value )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( !_.primitiveIs( dstPrototype ), () => 'dstPrototype is needed, but got ' + _.entity.exportStringDiagnosticShallow( dstPrototype ) );

  if( _.containerIs( name ) )
  {
    if( !_.object.isBasic( name ) )
    name = _.indexExtending( name, ( e ) => { return { [ e ] : undefined } } );
    _.each( name, ( v, n ) =>
    {
      if( value === undefined )
      _.props.constant( dstPrototype, n, v );
      else
      _.props.constant( dstPrototype, n, value );
    });
    return;
  }

  if( value === undefined )
  value = dstPrototype[ name ];

  _.assert( _.strIs( name ), 'name is needed, but got', name );

  Object.defineProperty( dstPrototype, name,
  {
    value,
    enumerable : true,
    writable : false,
    configurable : false,
  });

}

//

function declare_head( routine, args )
{

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  let o;

  if( args.length === 2 )
  {
    o = args[ 1 ];
    _.assert( !o.object );
    o.object = args[ 0 ];
  }
  else
  {
    o = args[ 0 ];
  }

  _.routine.options_( routine, o );

  if( o.writable === null )
  o.writable = !( o.set === false );

  _.assert( !_.primitiveIs( o.object ), 'Expects object as argument but got', o.object );
  _.assert( _.strIs( o.name ) || _.symbolIs( o.name ) );

  return o;
}

//

function declare_body( o ) /* xxx : move back to accessor? */
{

  _.assert( o.get === false || o.get === null || _.routineIs( o.get ) );
  _.assert( o.set === false || o.set === null || _.routineIs( o.set ) );
  _.assert( _.boolIs( o.enumerable ) );
  _.assert( _.boolIs( o.configurable ) );
  _.assert( _.boolIs( o.writable ) );

  let o2 =
  {
    enumerable : !!o.enumerable,
    configurable : !!o.configurable,
  }

  // if( o.name === 'f1' )
  // debugger;

  if( o.get === false )
  {
    if( o.set )
    o2.set = o.set;
    o2.get = noGet;
    _.assert( o.val === _.nothing );
  }
  else if( _.routineIs( o.get ) )
  {
    if( o.set )
    o2.set = o.set;
    o2.get = o.get;
    _.assert( o.val === _.nothing );
  }
  else if( o.get === null )
  {
    _.assert( o.set === false || o.set === null );
    o2.value = o.val;
    o2.writable = !!o.writable;
  }
  else _.assert( 0 );

  _.assert( !o.writable || o.set !== false );
  _.assert( o.writable || !o.set );

  Object.defineProperty( o.object, o.name, o2 );

  return o2;

  function noGet()
  {
    throw _.err( 'No getter defined' );
  }

}

declare_body.defaults =
{
  object : null,
  name : null,
  enumerable : true,
  configurable : true,
  writable : null,
  get : null,
  set : null,
  val : _.nothing,
}

let declare = _.routine.uniteCloning_replaceByUnite( declare_head, declare_body );
_.routine.er( declare );

// --
// define
// --

let PropertyExtension =
{

  conceal,
  constant : _constant,
  declare, /* qqq : cover */

}

_.props = _.props || Object.create( null );
/* _.props.extend */Object.assign( _.props, PropertyExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

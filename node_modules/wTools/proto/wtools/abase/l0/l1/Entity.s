( function _l1_Entity_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.entity = _.entity || Object.create( null );

// --
// dichotomy
// --

function is( src )
{
  return true;
}

//

function like( src )
{
  return _.entity.is( src );
}

// --
// exporter
// --

function strPrimitive( src )
{
  let result = '';

  _.assert( arguments.length === 1, 'Expects exactly one argument' );

  if( src === null || src === undefined )
  return;

  if( _.primitive.is( src ) )
  return String( src );

  return;
}

//

/**
 * Return primitive type of src.
 *
 * @example
 * let str = _.entity.strTypeSecondary( 'testing' );
 *
 * @param {*} src
 *
 * @return {string}
 * string name of type src
 * @function strTypeSecondary
 * @namespace Tools
 */

function strTypeSecondary( src )
{

  let name = Object.prototype.toString.call( src );
  let result = /\[(\w+) (\w+)\]/.exec( name );
  _.assert( !!result, 'unknown type', name );
  return result[ 2 ];
}

//

/**
 * Return type of src.
 *
 * @example
 * let str = _.entity.strType( 'testing' );
 *
 * @param {*} src
 *
 * @return {string}
 * string name of type src
 * @function strType
 * @namespace Tools
 */

/* qqq for junior : jsdoc */
/* xxx : optimize later */
/* xxx : move to namesapce type? */
function strTypeWithTraits( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.aux.is( src ) )
  {

    if( _.mapIsPure( src ) )
    return end( 'Map.pure' );
    else if( _.mapIsPolluted( src ) )
    return end( 'Map.polluted' );
    else if( _.aux.isPure( src ) && _.aux.isPrototyped( src ) )
    return end( 'Aux.pure.prototyped' );
    else if( _.aux.isPolluted( src ) && _.aux.isPrototyped( src ) )
    return end( 'Aux.polluted.prototyped' );
    else _.assert( 0, 'undexpected' );

  }

  if( _.primitive.is( src ) )
  return end( _.entity.strTypeSecondary( src ) );

  let proto = Object.getPrototypeOf( src );
  if( proto && proto.constructor && proto.constructor !== Object && proto.constructor.name )
  return end( proto.constructor.name );

  return end( _.entity.strTypeSecondary( src ) );

  function end( result )
  {
    let translated = _.entity.TranslatedTypeMap[ result ];
    if( translated )
    result = translated;

    if( !_.entity.StandardTypeSet.has( result ) )
    {
      if( _.countableIs( src ) )
      result += '.countable';
      if( _.constructibleIs( src ) )
      result += '.constructible';
    }

    return result;
  }

}

//

/* qqq for junior : jsdoc */
function strTypeWithoutTraits( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.aux.is( src ) )
  {
    if( _.mapIs( src ) )
    return 'Map';
    else
    return 'Aux';
  }

  if( _.primitive.is( src ) )
  return end( _.entity.strTypeSecondary( src ) );

  let proto = Object.getPrototypeOf( src );
  if( proto && proto.constructor && proto.constructor !== Object && proto.constructor.name )
  return end( proto.constructor.name );

  return end( _.entity.strTypeSecondary( src ) );

  function end( result )
  {
    let translated = _.entity.TranslatedTypeMap[ result ];
    if( translated )
    result = translated;
    return result;
  }

}

// --
// meta
// --

function namespaceForIterating( src ) /* qqq for junior : cover please */
{
  _.assert( arguments.length === 1 );

  if( src === undefined )
  return _.blank;
  if( _.primitive.is( src ) )
  return _.itself;
  if( _.hashMap.like( src ) )
  return _.hashMap;
  if( _.set.like( src ) )
  return _.set;
  if( _.long.is( src ) )
  return _.long;
  if( _.buffer.like( src ) )
  return _.buffer;
  if( _.countable.is( src ) )
  return _.object;
  if( _.aux.is( src ) )
  return _.aux;
  if( _.object.is( src ) )
  return _.object;

  return _.props;
}

// --
// entity extension
// --

let TranslatedTypeMap =
{

  'BigUint64Array' : 'U64x',
  'Uint32Array' : 'U32x',
  'Uint16Array' : 'U16x',
  'Uint8Array' : 'U8x',
  'Uint8ClampedArray' : 'U8xClamped',

  'BigInt64Array' : 'I64x',
  'Int32Array' : 'I32x',
  'Int16Array' : 'I16x',
  'Int8Array' : 'I8x',

  'Float64Array' : 'F64x',
  'Float32Array' : 'F32x',

  'Buffer' : 'BufferNode',
  'ArrayBuffer' : 'BufferRaw',
  'SharedArrayBuffer' : 'BufferRawShared',
  'Map' : 'HashMap',
  'WeakMap' : 'HashMapWeak',
  'Function' : 'Routine',
  'Arguments' : 'ArgumentsArray',

}

let StandardTypeSet = new Set
([

  'U64x',
  'U32x',
  'U16x',
  'U8x',
  'U8xClamped',
  'I64x',
  'I32x',
  'I16x',
  'I8x',
  'F64x',
  'F32x',

  'BufferNode',
  'BufferRaw',
  'BufferRawShared',
  'HashMap',
  'HashMapWeak',

  'ArgumentsArray',
  'Array',
  'Set',
  'Routine',
  'Global',

]);

//

let EntityExtension =
{

  // fields

  NamespaceName : 'entity',
  NamespaceNames : [ 'entity' ],
  NamespaceQname : 'wTools/entity',
  TypeName : 'Entity',
  TypeNames : [ 'Entity' ],
  // SecondTypeName : 'Entity',
  InstanceConstructor : null,
  tools : _,
  TranslatedTypeMap,
  StandardTypeSet,

  // dichotmoy

  is,
  like,

  // maker

  // _cloneShallow : _.container._cloneShallow, /* xxx : implement? */
  cloneShallow : _.container.cloneShallow, /* qqq : cover */
  // _make : _.container._make, /* qqq : implement */
  make : _.container.make, /* xxx : implement? */
  // _makeEmpty : _.container._makeEmpty, /* qqq : implement */
  makeEmpty : _.container.makeEmpty, /* xxx : implement? */
  // _makeUndefined : _.container._makeUndefined, /* qqq : implement */
  makeUndefined : _.container.makeUndefined, /* xxx : implement? */

  // exporter

  strPrimitive,
  strTypeSecondary,
  strType : strTypeWithTraits,
  strTypeWithTraits,
  strTypeWithoutTraits,

  // meta

  namespaceForIterating,
  namespaceForExporting : _.container.namespaceForExporting,
  namespaceOf : namespaceForIterating,
  namespaceWithDefaultOf : _.props.namespaceWithDefaultOf,
  _functor_functor : _.props._functor_functor,

}

//

Object.assign( _.entity, EntityExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  entityIs : is.bind( _.entity ),
  entityLike : like.bind( _.entity ),

  strType : strTypeWithTraits,

}

//

Object.assign( _, ToolsExtension );

})();

( function _Workpiece_s_() {

'use strict';

/**
* @namespace wTools.workpiece
* @extends Tools
* @module Tools/base/Proto
*/

const _global = _global_;
const _ = _global_.wTools;
_.workpiece = _.workpiece || Object.create( null );;
const _ObjectHasOwnProperty = Object.hasOwnProperty;

_.assert( _.object.isBasic( _.props ), 'wProto needs Tools/wtools/abase/l1/FieldMapper.s' );

// --
// prototype
// --

function prototypeIsStandard( src )
{

  if( !_.workpiece.prototypeIs( src ) )
  return false;

  if( !Object.hasOwnProperty.call( src, 'Composes' ) )
  return false;

  return true;
}

//

function prototypeOf( src )
{
  _.assert( arguments.length === 1, 'Expects single argument, probably you want routine isPrototypeOf' );

  if( !( 'constructor' in src ) )
  return null;

  let c = _.workpiece.constructorOf( src );

  _.assert( arguments.length === 1, 'Expects single argument' );

  return c.prototype;
}

//

function prototypeHasField( src, propName )
{
  let prototype = _.workpiece.prototypeOf( src );

  _.assert( _.workpiece.prototypeIsStandard( prototype ), 'Expects standard prototype' );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( propName ) );

  for( let f in _.DefaultFieldsGroupsRelations )
  if( prototype[ f ][ propName ] !== undefined )
  return true;

  return false;
}

//

function prototypeAndConstructorOf( o )
{
  let result = Object.create( null );

  if( !result.cls )
  if( o.prototype )
  result.cls = o.prototype.constructor;

  if( !result.cls )
  if( o.extend )
  if( o.extend.constructor !== Object.prototype.constructor )
  result.cls = o.extend.constructor;

  if( !result.cls )
  if( o.usingStatics && o.extend && o.extend.Statics )
  if( o.extend.Statics.constructor !== Object.prototype.constructor )
  result.cls = o.extend.Statics.constructor;

  if( !result.cls )
  if( o.supplement )
  if( o.supplement.constructor !== Object.prototype.constructor )
  result.cls = o.supplement.constructor;

  if( !result.cls )
  if( o.usingStatics && o.supplement && o.supplement.Statics )
  if( o.supplement.Statics.constructor !== Object.prototype.constructor )
  result.cls = o.supplement.Statics.constructor;

  if( o.prototype )
  result.prototype = o.prototype;
  else if( result.cls )
  result.prototype = result.cls.prototype;

  if( o.prototype )
  _.assert( result.cls === o.prototype.constructor );

  return result;
}

// --
// constructor
// --

/**
 * Get parent's constructor.
 * @function parentOf
 * @namespace Tools
 * @module Tools/base/Proto
 */

function parentOf( src )
{
  let c = _.workpiece.constructorOf( src );

  _.assert( arguments.length === 1, 'Expects single argument' );

  let proto = Object.getPrototypeOf( c.prototype );
  let result = proto ? proto.constructor : null;

  return result;
}

//

function constructorIsStandard( cls )
{

  _.assert( _.constructorIs( cls ) );

  let prototype = _.workpiece.prototypeOf( cls );

  return _.workpiece.prototypeIsStandard( prototype );
}

//

function constructorOf( src )
{
  let proto;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _ObjectHasOwnProperty.call( src, 'constructor' ) )
  {
    proto = src; /* proto */
  }
  else if( _ObjectHasOwnProperty.call( src, 'prototype' )  )
  {
    if( src.prototype )
    proto = src.prototype; /* constructor */
    else
    proto = Object.getPrototypeOf( Object.getPrototypeOf( src ) ); /* instance behind ruotine */
  }
  else
  {
    proto = Object.getPrototypeOf( src ); /* instance */
  }

  if( proto === null )
  return null;
  else
  return proto.constructor;
}

// --
// instance
// --

function instanceIsStandard( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !_.instanceIs( src ) )
  return false;

  let proto = _.workpiece.prototypeOf( src );

  if( !proto )
  return false;

  return _.workpiece.prototypeIsStandard( proto );
}

//

function instanceLikeStandard( src )
{
  if( _.primitiveIs( src ) )
  return false;
  if( src.Composes )
  return true;
  return false;
}

// --
// fields group
// --

function fieldsGroupsGet( src )
{
  // _.assert( _.object.isBasic( src ), () => 'Expects map {-src-}, but got ' + _.entity.strType( src ) );
  _.assert( !_.primitiveIs( src ), () => 'Expects map {-src-}, but got ' + _.entity.strType( src ) );
  _.assert( src.Groups === undefined || _.object.isBasic( src.Groups ) );

  if( src.Groups )
  return src.Groups;

  return _.DefaultFieldsGroups;
}

//

function fieldsGroupFor( dst, fieldsGroupName )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( fieldsGroupName ) );
  _.assert( !_.primitiveIs( dst ) );

  if( !_ObjectHasOwnProperty.call( dst, fieldsGroupName ) )
  {
    let field = dst[ fieldsGroupName ];
    dst[ fieldsGroupName ] = Object.create( null );
    if( field )
    Object.setPrototypeOf( dst[ fieldsGroupName ], field );
  }

  if( Config.debug )
  {
    let parent = Object.getPrototypeOf( dst );
    if( parent && parent[ fieldsGroupName ] )
    _.assert( Object.getPrototypeOf( dst[ fieldsGroupName ] ) === parent[ fieldsGroupName ] );
  }

  return dst;
}

//

/**
* Default options for fieldsGroupDeclare function
* @typedef {object} wTools~protoAddDefaults
* @property {object} [ o.fieldsGroupName=null ] - object that contains class relationship type name.
* Example : { Composes : 'Composes' }. See {@link wTools~DefaultFieldsGroupsRelations}
* @property {object} [ o.dstPrototype=null ] - prototype of class which will get new constant property.
* @property {object} [ o.srcMap=null ] - name/value map of defaults.
* @property {bool} [ o.extending=false ] - to extending defaults if exist.
*/

/**
 * Adds own defaults to object. Creates new defaults container, if there is no such own.
 * @param {wTools~protoAddDefaults} o - options {@link wTools~protoAddDefaults}.
 * @private
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * _.workpiece.fieldsGroupDeclare
 * ({
 *   fieldsGroupName : { Composes : 'Composes' },
 *   dstPrototype : Self.prototype,
 *   srcMap : { a : 1, b : 2 },
 * });
 * console.log( Self.prototype ); // returns { Composes: { a: 1, b: 2 } }
 *
 * @function fieldsGroupDeclare
 * @throws {exception} If no argument provided.
 * @throws {exception} If( o.srcMap ) is not a Object.
 * @throws {exception} If( o ) is extented by unknown property.
 * @namespace Tools.workpiece
 */

function fieldsGroupDeclare( o )
{
  o = o || Object.create( null );

  _.routine.options_( fieldsGroupDeclare, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.srcMap === null || !_.primitiveIs( o.srcMap ), 'Expects object {-o.srcMap-}, got', _.entity.strType( o.srcMap ) );
  _.assert( _.strIs( o.fieldsGroupName ) );
  // _.assert( _.routineIs( o.filter ) && _.strIs( o.filter.functionFamily ) );
  _.assert( _.props.transformerIs( o.filter ) );

  _.workpiece.fieldsGroupFor( o.dstPrototype, o.fieldsGroupName );

  let fieldGroup = o.dstPrototype[ o.fieldsGroupName ];

  if( o.srcMap )
  _.mapExtendConditional( o.filter, fieldGroup, o.srcMap );

}

fieldsGroupDeclare.defaults =
{
  dstPrototype : null,
  srcMap : null,
  filter : _.props.mapper.bypass(),
  fieldsGroupName : null,
}

//

/**
 * Adds own defaults( Composes ) to object. Creates new defaults container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * let Composes = { tree : null };
 * _.workpiece.fieldsGroupComposesExtend( Self.prototype, Composes );
 * console.log( Self.prototype ); // returns { Composes: { tree: null } }
 *
 * @function _.workpiece.fieldsGroupComposesExtend
 * @throws {exception} If no arguments provided.
 * @namespace Tools.workpiece
 */

function fieldsGroupComposesExtend( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let fieldsGroupName = 'Composes';
  return _.workpiece.fieldsGroupDeclare
  ({
    fieldsGroupName,
    dstPrototype,
    srcMap,
    // filter : _.props.mapper.bypass(),
  });

}

//

/**
 * Adds own aggregates to object. Creates new aggregates container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * let Aggregates = { tree : null };
 * _.workpiece.fieldsGroupAggregatesExtend( Self.prototype, Aggregates );
 * console.log( Self.prototype ); // returns { Aggregates: { tree: null } }
 *
 * @function fieldsGroupAggregatesExtend
 * @throws {exception} If no arguments provided.
 * @namespace Tools.workpiece
 */

function fieldsGroupAggregatesExtend( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let fieldsGroupName = 'Aggregates';
  return _.workpiece.fieldsGroupDeclare
  ({
    fieldsGroupName,
    dstPrototype,
    srcMap,
    // filter : _.props.mapper.bypass(),
  });

}

//

/**
 * Adds own associates to object. Creates new associates container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * let Associates = { tree : null };
 * _.workpiece.fieldsGroupAssociatesExtend( Self.prototype, Associates );
 * console.log( Self.prototype ); // returns { Associates: { tree: null } }
 *
 * @function fieldsGroupAssociatesExtend
 * @throws {exception} If no arguments provided.
 * @namespace Tools.workpiece
 */

function fieldsGroupAssociatesExtend( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let fieldsGroupName = 'Associates';
  return _.workpiece.fieldsGroupDeclare
  ({
    fieldsGroupName,
    dstPrototype,
    srcMap,
    // filter : _.props.mapper.bypass(),
  });

}

//

/**
 * Adds own restricts to object. Creates new restricts container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * let Restricts = { tree : null };
 * _.workpiece.fieldsGroupRestrictsExtend( Self.prototype, Restricts );
 * console.log( Self.prototype ); // returns { Restricts: { tree: null } }
 *
 * @function _.workpiece.fieldsGroupRestrictsExtend
 * @throws {exception} If no arguments provided.
 * @namespace Tools.workpiece
 */

function fieldsGroupRestrictsExtend( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let fieldsGroupName = 'Restricts';
  return _.workpiece.fieldsGroupDeclare
  ({
    fieldsGroupName,
    dstPrototype,
    srcMap,
    // filter : _.props.mapper.bypass(),
  });

}

//

/**
 * Adds own defaults( Composes ) to object. Creates new defaults container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * let Composes = { tree : null };
 * _.workpiece.fieldsGroupComposesSupplement( Self.prototype, Composes );
 * console.log( Self.prototype ); // returns { Composes: { tree: null } }
 *
 * @function fieldsGroupComposesSupplement
 * @throws {exception} If no arguments provided.
 * @namespace Tools.workpiece
 */

function fieldsGroupComposesSupplement( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let fieldsGroupName = 'Composes';
  return _.workpiece.fieldsGroupDeclare
  ({
    fieldsGroupName,
    dstPrototype,
    srcMap,
    filter : _.props.mapper.dstNotHas(),
  });

}

//

/**
 * Adds own aggregates to object. Creates new aggregates container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * let Aggregates = { tree : null };
 * _.workpiece.fieldsGroupAggregatesSupplement( Self.prototype, Aggregates );
 * console.log( Self.prototype ); // returns { Aggregates: { tree: null } }
 *
 * @function _.workpiece.fieldsGroupAggregatesSupplement
 * @throws {exception} If no arguments provided.
 * @namespace Tools.workpiece
 */

function fieldsGroupAggregatesSupplement( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let fieldsGroupName = 'Aggregates';
  return _.workpiece.fieldsGroupDeclare
  ({
    fieldsGroupName,
    dstPrototype,
    srcMap,
    filter : _.props.mapper.dstNotHas(),
  });

}

//

/**
 * Adds own associates to object. Creates new associates container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * let Associates = { tree : null };
 * _.workpiece.fieldsGroupAssociatesSupplement( Self.prototype, Associates );
 * console.log( Self.prototype ); // returns { Associates: { tree: null } }
 *
 * @function fieldsGroupAssociatesSupplement
 * @throws {exception} If no arguments provided.
 * @namespace Tools.workpiece
 */

function fieldsGroupAssociatesSupplement( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let fieldsGroupName = 'Associates';
  return _.workpiece.fieldsGroupDeclare
  ({
    fieldsGroupName,
    dstPrototype,
    srcMap,
    filter : _.props.mapper.dstNotHas(),
  });

}

//

/**
 * Adds own restricts to object. Creates new restricts container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * const Self = ClassName;
function ClassName( o ) { };
 * let Restricts = { tree : null };
 * _.workpiece.fieldsGroupRestrictsSupplement( Self.prototype, Restricts );
 * console.log( Self.prototype ); // returns { Restricts: { tree: null } }
 *
 * @function fieldsGroupRestrictsSupplement
 * @throws {exception} If no arguments provided.
 * @namespace Tools.workpiece
 */

function fieldsGroupRestrictsSupplement( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let fieldsGroupName = 'Restricts';
  return _.workpiece.fieldsGroupDeclare
  ({
    fieldsGroupName,
    dstPrototype,
    srcMap,
    filter : _.props.mapper.dstNotHas(),
  });

}

//

function fieldsOfRelationsGroupsFromPrototype( src )
{
  let prototype = src;
  let result = Object.create( null );

  // _.assert( !_.primitiveIs( prototype ) );
  _.assert( !_.primitiveIs( prototype ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let g in _.DefaultFieldsGroupsRelations )
  {
    if( src[ g ] )
    _.props.extend( result, src[ g ] );
  }

  return result;
}

//

function fieldsOfCopyableGroupsFromPrototype( src )
{
  let prototype = src;
  let result = Object.create( null );

  _.assert( !_.primitiveIs( prototype ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let g in _.DefaultFieldsGroupsCopyable )
  {
    if( src[ g ] )
    _.props.extend( result, src[ g ] );
  }

  return result;
}

//

function fieldsOfTightGroupsFromPrototype( src )
{
  let prototype = src;
  let result = Object.create( null );

  _.assert( !_.primitiveIs( prototype ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let g in _.DefaultFieldsGroupsTight )
  {
    if( src[ g ] )
    _.props.extend( result, src[ g ] );
  }

  return result;
}

//

function fieldsOfInputGroupsFromPrototype( src )
{
  let prototype = src;
  let result = Object.create( null );

  _.assert( !_.primitiveIs( prototype ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let g in _.DefaultFieldsGroupsInput )
  {
    if( src[ g ] )
    _.props.extend( result, src[ g ] );
  }

  return result;
}

//

function fieldsOfRelationsGroups( src )
{
  let prototype = src;

  if( !_.workpiece.prototypeIs( prototype ) )
  prototype = _.workpiece.prototypeOf( src );

  _.assert( _.workpiece.prototypeIs( prototype ) );
  _.assert( _.workpiece.prototypeIsStandard( prototype ), 'Expects standard prototype' );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.instanceIs( src ) )
  {
    return _.mapOnly_( null, src, _.workpiece.fieldsOfRelationsGroupsFromPrototype( prototype ) );
  }

  return _.workpiece.fieldsOfRelationsGroupsFromPrototype( prototype );
}

//

function fieldsOfCopyableGroups( src )
{
  let prototype = src;

  if( !_.workpiece.prototypeIs( prototype ) )
  prototype = _.workpiece.prototypeOf( src );

  _.assert( _.workpiece.prototypeIs( prototype ) );
  _.assert( _.workpiece.prototypeIsStandard( prototype ), 'Expects standard prototype' );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.instanceIs( src ) )
  return _.mapOnly_( null, src, _.workpiece.fieldsOfCopyableGroupsFromPrototype( prototype ) );

  return _.workpiece.fieldsOfCopyableGroupsFromPrototype( prototype );
}

//

function fieldsOfTightGroups( src )
{
  let prototype = src;

  if( !_.workpiece.prototypeIs( prototype ) )
  prototype = _.workpiece.prototypeOf( src );

  _.assert( _.workpiece.prototypeIs( prototype ) );
  _.assert( _.workpiece.prototypeIsStandard( prototype ), 'Expects standard prototype' );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.instanceIs( src ) )
  return _.mapOnly_( null, src, _.workpiece.fieldsOfTightGroupsFromPrototype( prototype ) );

  return _.workpiece.fieldsOfTightGroupsFromPrototype( prototype );
}

//

function fieldsOfInputGroups( src )
{
  let prototype = src;

  if( !_.workpiece.prototypeIs( prototype ) )
  prototype = _.workpiece.prototypeOf( src );

  _.assert( _.workpiece.prototypeIs( prototype ) );
  _.assert( _.workpiece.prototypeIsStandard( prototype ), 'Expects standard prototype' );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.instanceIs( src ) )
  return _.mapOnly_( null, src, _.workpiece.fieldsOfInputGroupsFromPrototype( prototype ) );

  return _.workpiece.fieldsOfInputGroupsFromPrototype( prototype );
}

//

function fieldsGroupsDeclare( o )
{

  _.routine.options_( fieldsGroupsDeclare, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.srcMap === null || !_.primitiveIs( o.srcMap ), 'Expects object {-o.srcMap-}, got', _.entity.strType( o.srcMap ) );

  if( !o.srcMap )
  return;

  if( !o.fieldsGroups )
  o.fieldsGroups = _.workpiece.fieldsGroupsGet( o.dstPrototype );

  _.assert( _.prototype.isSubPrototypeOf( o.fieldsGroups, _.DefaultFieldsGroups ) );

  for( let f in o.fieldsGroups )
  {

    if( !o.srcMap[ f ] )
    continue;

    _.workpiece.fieldsGroupDeclare
    ({
      fieldsGroupName : f,
      dstPrototype : o.dstPrototype,
      srcMap : o.srcMap[ f ],
      filter : o.filter,
    });

    if( !_.DefaultFieldsGroupsRelations[ f ] )
    continue;

    if( Config.debug )
    {
      for( let f2 in _.DefaultFieldsGroupsRelations )
      if( f2 === f )
      {
        continue;
      }
      else for( let k in o.srcMap[ f ] )
      {
        _.assert( o.dstPrototype[ f2 ][ k ] === undefined, 'Fields group', '"'+f2+'"', 'already has fields', '"'+k+'"', 'fields group', '"'+f+'"', 'should not have the same' );
      }
    }

  }

}

fieldsGroupsDeclare.defaults =
{
  dstPrototype : null,
  srcMap : null,
  fieldsGroups : null,
  filter : fieldsGroupDeclare.defaults.filter,
}

//

function fieldsGroupsDeclareForEachFilter( o )
{

  _.assert( arguments.length === 1 );
  _.routine.assertOptions( fieldsGroupsDeclareForEachFilter, arguments );
  _.map.assertHasNoUndefine( o );

  let oldFieldsGroups = _.workpiece.fieldsGroupsGet( o.dstPrototype );
  let newFieldsGroups = Object.create( oldFieldsGroups )
  if( ( o.extendMap && o.extendMap.Groups ) || ( o.supplementOwnMap && o.supplementOwnMap.Groups ) || ( o.supplementMap && o.supplementMap.Groups ) )
  {
    if( o.supplementMap && o.supplementMap.Groups )
    _.props.supplement( newFieldsGroups, o.supplementMap.Groups );
    if( o.supplementOwnMap && o.supplementOwnMap.Groups )
    _.mapExtendDstNotOwn( newFieldsGroups, o.supplementOwnMap.Groups );
    if( o.extendMap && o.extendMap.Groups )
    _.props.extend( newFieldsGroups, o.extendMap.Groups );
  }

  if( !o.dstPrototype.Groups )
  o.dstPrototype.Groups = Object.create( _.DefaultFieldsGroups );

  for( let f in newFieldsGroups )
  _.workpiece.fieldsGroupFor( o.dstPrototype, f );

  _.workpiece.fieldsGroupsDeclare
  ({
    dstPrototype : o.dstPrototype,
    srcMap : o.extendMap,
    fieldsGroups : newFieldsGroups,
    filter : _.props.mapper.bypass(),
  });

  _.workpiece.fieldsGroupsDeclare
  ({
    dstPrototype : o.dstPrototype,
    srcMap : o.supplementOwnMap,
    fieldsGroups : newFieldsGroups,
    filter : _.props.mapper.dstOwn(),
  });

  _.workpiece.fieldsGroupsDeclare
  ({
    dstPrototype : o.dstPrototype,
    srcMap : o.supplementMap,
    fieldsGroups : newFieldsGroups,
    filter : _.props.mapper.dstNotHas(),
  });

}

fieldsGroupsDeclareForEachFilter.defaults =
{
  dstPrototype : null,
  extendMap : null,
  supplementOwnMap : null,
  supplementMap : null,
}

// --
// instance
// --

/*
  usage : return _.workpiece.construct( Self, this, arguments );
  replacement for :

  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.constructorJoin( Self, arguments ) );
  return Self.prototype.init.apply( this, arguments );

*/

function construct( cls, context, args )
{

  _.assert( args.length === 0 || args.length === 1, () => `Expects optional argument, but got ${args.length} arguments` );
  _.assert( arguments.length === 3 );
  _.assert( _.routineIs( cls ) );
  _.assert( _.argumentsArray.like( args ) );

  let o = args[ 0 ];

  if( !( context instanceof cls ) )
  if( o instanceof cls )
  {
    _.assert( args.length === 1 );
    return o;
  }
  else
  {
    if( args.length === 1 && _.argumentsArray.like( args[ 0 ] ) )
    {
      let result = [];
      for( let i = 0 ; i < args[ 0 ].length ; i++ )
      {
        let o = args[ 0 ][ i ];
        if( o === null )
        continue;
        if( o instanceof cls )
        result.push( o );
        else
        result.push( new( _.constructorJoin( cls, [ o ] ) ) );
      }
      return result;
    }
    else
    {
      return new( _.constructorJoin( cls, args ) );
    }
  }

  // debugger;
  // _.assert( 0 );
  return cls.prototype.init.apply( context, args );
}

//

/**
 * Is this instance finited.
 * @function isFinited
 * @param {object} src - instance of any class
 * @namespace Tools.workpiece
 * @module Tools/base/Proto
 */

function isFinited( src )
{
  _.assert( _.instanceIs( src ), () => 'Expects instance, but got ' + _.entity.exportStringDiagnosticShallow( src ) )
  _.assert( !_.primitiveIs( src ) );
  return Object.isFrozen( src );
}

//

function finit( src )
{

  _.assert( !Object.isFrozen( src ), () => `Seems instance ${_.workpiece.qualifiedNameTry( src )} is already finited` );
  _.assert( !_.primitiveIs( src ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  // let validator =
  // {
  //   set : function( obj, k, e )
  //   {
  //     debugger;
  //     throw _.err( 'Attempt ot access to finited instance with field', k );
  //     return false;
  //   },
  //   get : function( obj, k, e )
  //   {
  //     debugger;
  //     throw _.err( 'Attempt ot access to finited instance with field', k );
  //     return false;
  //   },
  // }
  // let result = new Proxy( src, validator );

  Object.freeze( src );
}

//

/**
 * Complements instance by its semantic relations : Composes, Aggregates, Associates, Medials, Restricts.
 * @param {object} instance - instance to complement.
 *
 * @example
 * const Self = Alpha;
function Alpha( o ) { };
 *
 * let Proto = { constructor: Self, Composes : { a : 1, b : 2 } };
 *
 * _.classDeclare
 * ({
 *     constructor: Self,
 *     extend: Proto,
 * });
 * let obj = new Self();
 * console.log( _.workpiece.initFields( obj ) ); //returns Alpha { a: 1, b: 2 }
 *
 * @return {object} Returns complemented instance.
 * @function initFields
 * @namespace Tools.workpiece
 */

function initFields( instance, prototype )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( prototype === undefined || prototype === null )
  prototype = instance;

  _.mapSupplementOwnFromDefinitionStrictlyPrimitives( instance, prototype.Restricts );
  _.mapSupplementOwnFromDefinitionStrictlyPrimitives( instance, prototype.Composes );
  _.mapSupplementOwnFromDefinitionStrictlyPrimitives( instance, prototype.Aggregates );
  _.mapSupplementOwnFromDefinitionStrictlyPrimitives( instance, prototype.Associates );

  return instance;
}

//

function initWithArguments( o )
{

  o = _.routine.options_( initWithArguments, arguments );
  _.assert( arguments.length === 1 );
  _.assert( o.args.length === 0 || o.args.length === 1 );
  _.workpiece.initFields( o.instance );

  Object.preventExtensions( o.instance, o.prototype );

  if( o.args[ 0 ] )
  o.instance.copy( o.args[ 0 ] );

  return o.instance;
}

initWithArguments.defaults =
{
  instance : null,
  prototype : null,
  args : null,
}

//

function initExtending( instance, prototype )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( prototype === undefined )
  prototype = instance;

  _.mapExtendConditional( _.props.mapper.assigning(), instance, prototype.Restricts );
  _.mapExtendConditional( _.props.mapper.assigning(), instance, prototype.Composes );
  _.mapExtendConditional( _.props.mapper.assigning(), instance, prototype.Aggregates );
  _.props.extend( instance, prototype.Associates );

  return instance;
}

//

function initFilter( o )
{

  _.routine.options_( initFilter, o );
  _.assertOwnNoConstructor( o );
  _.assert( _.routineIs( o.cls ) );
  _.assert( !o.args || o.args.length === 0 || o.args.length === 1 );

  let result = Object.create( null );

  _.workpiece.initFields( result, o.cls.prototype );

  if( o.args[ 0 ] )
  _.Copyable.prototype.copyCustom.call( o.cls.prototype,
  {
    proto : o.cls.prototype,
    src : o.args[ 0 ],
    dst : result,
    technique : 'object',
  });

  if( !result.original )
  result.original = _.FileProvider.Default();

  _.props.extend( result, o.extend );

  Object.setPrototypeOf( result, result.original );

  if( o.strict )
  Object.preventExtensions( result );

  return result;
}

initFilter.defaults =
{
  cls : null,
  parent : null,
  extend : null,
  args : null,
  strict : 1,
}

//

function singleFrom( src, cls )
{
  cls = _.workpiece.constructorOf( cls );

  _.assert( arguments.length === 2 );

  if( src instanceof cls )
  return src;
  return new( _.constructorJoin( cls, arguments ) );
}

//

function from( srcs, cls )
{
  cls = _.workpiece.constructorOf( cls );

  _.assert( arguments.length === 2 );

  if( srcs instanceof cls )
  {
    return srcs;
  }

  if( _.argumentsArray.like( srcs ) )
  {
    debugger;
    var result = _.container.map_( null, srcs, ( src ) =>
    {
      return _.workpiece.singleFrom( src );
    });
    return result;
  }

  return _.workpiece.singleFrom.call( srcs, cls );
}

//

function lowClassName( instance )
{
  _.assert( _.instanceIs( instance ) );
  _.assert( arguments.length === 1 );
  let name = _.workpiece.className( instance );
  name = _.strDecapitalize( name );
  return name;
}

//

function className( instance )
{
  _.assert( _.instanceIs( instance ) );
  _.assert( arguments.length === 1 );
  let cls = _.workpiece.constructorOf( instance );
  _.assert( cls === null || _.strIs( cls.name ) || _.strIs( cls._name ) );
  return cls ? ( cls.name || cls._name ) : '';
}

//

function qualifiedNameTry( instance )
{
  try
  {
    let result = _.workpiece.qualifiedName( instance );
    return result;
  }
  catch( err )
  {
    return '';
  }
}

//

function qualifiedName( instance )
{
  _.assert( _.instanceIs( instance ) );
  _.assert( arguments.length === 1 );

  if( _.routineIs( instance._qualifiedNameGet ) )
  return instance._qualifiedNameGet();

  if( instance.qualifiedName !== undefined )
  {
    _.assert( !_.routineIs( instance.qualifiedName ) );
    return instance.qualifiedName;
  }

  return _.workpiece._qualifiedNameGet( instance );
}

//

function _qualifiedNameGet( instance )
{
  _.assert( _.instanceIs( instance ) );
  _.assert( arguments.length === 1 );

  let name = ( instance.key || instance.name || '' );
  let index = '';

  if( _.numberIs( instance.instanceIndex ) )
  name += '#in' + instance.instanceIndex;
  if( Object.hasOwnProperty.call( instance, 'id' ) )
  name += '#id' + instance.id;

  let result = _.workpiece.className( instance ) + '::' + name;

  return result;
}

// //
//
// function qualifiedName( instance )
// {
//   _.assert( _.instanceIs( instance ) );
//   _.assert( arguments.length === 1 );
//
//   let name = ( instance.key || instance.name || '' );
//   let index = '';
//   if( _.numberIs( instance.instanceIndex ) )
//   name += '#in' + instance.instanceIndex;
//   if( Object.hasOwnProperty.call( instance, 'id' ) )
//   name += '#id' + instance.id;
//
//   let result = _.workpiece.className( instance ) + '::' + name;
//
//   return result;
// }

//

function uname( instance )
{
  _.assert( _.instanceIs( instance ) );
  _.assert( arguments.length === 1 );
  let name = _.workpiece.className( instance );
  return '#id' + self.id + '::' + name;
}

//

function toStr( instance, options )
{
  var result = '';
  var o = o || Object.create( null );

  _.assert( _.instanceIs( instance ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( !o.jsLike && !o.jsonLike )
  result += _.workpiece.qualifiedName( instance ) + '\n';

  var fields = _.workpiece.fieldsOfTightGroups( instance );

  var t = _.entity.exportString( fields, o );
  _.assert( _.strIs( t ) );
  result += t;

  return result;
}

//

/**
 * Make sure src does not have redundant fields.
 * @param {object} src - source object of the class.
 * @function assertDoesNotHaveReduntantFields
 * @namespace Tools.workpiece
 */

function assertDoesNotHaveReduntantFields( src )
{

  let Composes = src.Composes || Object.create( null );
  let Aggregates = src.Aggregates || Object.create( null );
  let Associates = src.Associates || Object.create( null );
  let Restricts = src.Restricts || Object.create( null );

  _.assert( _.ojbectIs( src ) )
  _.map.assertOwnOnly( src, [ Composes, Aggregates, Associates, Restricts ] );

  return dst;
}

//

function exportStructure( self, ... args )
{
  let o = _.routine.options_( exportStructure, args );

  _.assert( _.instanceIs( self ) );

  if( o.src === null )
  o.src = self;

  if( o.dst === null )
  o.dst = Object.create( null );

  o.dst = _.replicate
  ({
    src : o.src,
    dst : o.dst,
    srcChanged,
    // onSrcChanged,
    ascend,
    // onAscend : onAscend,
  });

  return o.dst;

  // function onSrcChanged()
  function srcChanged()
  {
    let it = this;

    debugger;
    it.Seeker.srcChanged.call( it );

    if( !it.iterable )
    if( _.instanceIs( it.src ) )
    {
      if( it.src === self )
      {
        it.src = _.mapOnly_( null, it.src, it.src.Export || it.src.Import );
        it.iterable = _.looker.Looker.ContainerType.aux;
        // it.iterable = _.looker.ContainerType.aux;
      }
    }

  }

  // function onAscend()
  function ascend()
  {
    let it = this;

    if( !it.iterable && _.instanceIs( it.src ) )
    {
      it.dst = _.routineCallButOnly( it.src, 'exportStructure', o, [ 'src', 'dst' ] );
    }
    else
    {
      debugger;
      _.looker.Looker.Iterator.call( this );
      // _.looker.Looker.Iterator.onAscend.call( this );
    }

  }

}

exportStructure.defaults =
{
  src : null,
  dst : null,
}

//

function exportString( self, ... args )
{
  let o = _.routine.options_( exportString, args );

  _.assert( _.instanceIs( self ) );
  _.assert( o.style === 'nice' );

  o.dst = o.dst || '';

  if( o.src === null )
  o.src = _.routineCallButOnly( self, 'exportStructure', o, [ 'dst' ] )

  o.dst += _.workpiece.qualifiedName( self ) + '\n';
  o.dst += _.entity.exportStringNice( o.src );

  return o.dst;
}

exportString.defaults =
{
  ... exportStructure.defaults,
  dst : '',
  src : null,
  style : 'nice',
  it : null,
}

// --
// fields
// --

/**
 * @typedef {Object} KnownConstructorFields - contains fields allowed for class constructor.
 * @property {String} name - full name
 * @property {String} _name - private name
 * @property {String} shortName - short name
 * @property {Object} prototype - prototype object
 * @module Tools/base/Proto
 */

let KnownConstructorFields =
{
  name : null,
  _name : null,
  shortName : null,
  prototype : null,
}

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

let Extension =
{

  // prototype

  prototypeIs : _.prototypeIs,
  prototypeIsStandard,
  prototypeOf,
  prototypeHasField,
  prototypeAndConstructorOf,

  // constructor

  parentOf,
  constructorIs : _.constructorIs,
  constructorIsStandard,
  constructorOf,
  classGet : constructorOf,

  // instance

  instanceIs : _.instanceIs,
  instanceIsStandard,
  instanceLikeStandard,

  // fields group

  fieldsGroupsGet,
  fieldsGroupFor, /* experimental */
  fieldsGroupDeclare, /* experimental */

  fieldsGroupComposesExtend, /* experimental */
  fieldsGroupAggregatesExtend, /* experimental */
  fieldsGroupAssociatesExtend, /* experimental */
  fieldsGroupRestrictsExtend, /* experimental */

  fieldsGroupComposesSupplement, /* experimental */
  fieldsGroupAggregatesSupplement, /* experimental */
  fieldsGroupAssociatesSupplement, /* experimental */
  fieldsGroupRestrictsSupplement, /* experimental */

  fieldsOfRelationsGroupsFromPrototype,
  fieldsOfCopyableGroupsFromPrototype,
  fieldsOfTightGroupsFromPrototype,
  fieldsOfInputGroupsFromPrototype,

  fieldsOfRelationsGroups,
  fieldsOfCopyableGroups,
  fieldsOfTightGroups,
  fieldsOfInputGroups,

  fieldsGroupsDeclare,
  fieldsGroupsDeclareForEachFilter,

  //

  construct,

  isFinited,
  finit,

  initFields,
  initWithArguments,
  initExtending,
  initFilter, /* deprecated */

  singleFrom,
  from,

  lowClassName,
  className,
  qualifiedNameTry,
  qualifiedName,
  _qualifiedNameGet,
  uname,
  toStr,

  assertDoesNotHaveReduntantFields,

  //

  exportStructure,
  exportString,

  //

  KnownConstructorFields,

  DefaultFieldsGroups,
  DefaultFieldsGroupsRelations,
  DefaultFieldsGroupsCopyable,
  DefaultFieldsGroupsTight,
  DefaultFieldsGroupsInput,

  DefaultForbiddenNames,

}

//

/* _.props.extend */Object.assign( _.workpiece, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

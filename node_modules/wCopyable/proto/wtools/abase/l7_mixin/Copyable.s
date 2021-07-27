( function _Copyable_s_()
{

'use strict';

/**
 * Copyable mixin add copyability and clonability to your class. The module uses defined relation to deduce how to copy / clone the instanceCopyable mixin adds copyability and clonability to your class. The module uses defined relation to deduce how to copy / clone the instance.
  @module Tools/base/CopyableMixin
*/

/**
 *  */

/**
 * @classdesc Copyable mixin add copyability and clonability to your class.
 * @class wCopyable
 * @namespace Tools
 * @module Tools/base/CopyableMixin
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wProto' );
  _.include( 'wCloner' );
  _.include( 'wStringer' );
  _.include( 'wLooker' );
  _.include( 'wEqualer' );

}

//

const _global = _global_;
const _ = _global_.wTools;
const _ObjectHasOwnProperty = Object.hasOwnProperty;

_.assert( !!_._cloner );

//

/**
 * Mixin this into prototype of another object.
 * @param {object} dstClass - constructor of class to mixin.
 * @method onMixinApply
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function onMixinApply( mixinDescriptor, dstClass )
{

  var dstPrototype = dstClass.prototype;
  var has =
  {
    Composes : 'Composes',
    constructor : 'constructor',
  }

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.routineIs( dstClass ), () => 'mixin expects constructor, but got ' + _.entity.strTypeSecondary( dstClass ) );
  _.map.assertOwnAll( dstPrototype, has );
  _.assert( _ObjectHasOwnProperty.call( dstPrototype, 'constructor' ), 'prototype of object should has own constructor' );

  /* */

  _.mixinApply( this, dstPrototype );

  /* prototype accessors */

  var readOnly = { combining : 'supplement', set : false };
  var names =
  {

    Self : readOnly,
    Parent : readOnly,
    className : readOnly,
    lowName : readOnly,
    qualifiedName : readOnly,
    uname : readOnly,

    fieldsOfRelationsGroups : readOnly,
    fieldsOfCopyableGroups : readOnly,
    fieldsOfTightGroups : readOnly,
    fieldsOfInputGroups : readOnly,

    FieldsOfCopyableGroups : readOnly,
    FieldsOfTightGroups : readOnly,
    FieldsOfRelationsGroups : readOnly,
    FieldsOfInputGroups : readOnly,

  }

  _.accessor.readOnly
  ({
    object : dstPrototype,
    names,
    preservingValue : 0,
    strict : 0,
    prime : 0,
    enumerable : 0,
  });

  /* constructor accessors */

  var names =
  {

    Self : readOnly,
    Parent : readOnly,
    className : readOnly,
    lowName : readOnly,

    fieldsOfRelationsGroups : readOnly,
    fieldsOfCopyableGroups : readOnly,
    fieldsOfTightGroups : readOnly,
    fieldsOfInputGroups : readOnly,

    FieldsOfCopyableGroups : readOnly,
    FieldsOfTightGroups : readOnly,
    FieldsOfRelationsGroups : readOnly,
    FieldsOfInputGroups : readOnly,

  }

  _.accessor.readOnly
  ({
    object : dstClass,
    names,
    preservingValue : 0,
    strict : 0,
    prime : 0,
    enumerable : 0,
  });

  /* xxx : temp workaround */

  if( mixinDescriptor.supplement && mixinDescriptor.supplement[ equalAreSymbol ] !== undefined )
  if( dstPrototype[ equalAreSymbol ] === undefined )
  dstPrototype[ equalAreSymbol ] = mixinDescriptor.supplement[ equalAreSymbol ];
  if( mixinDescriptor.extend && mixinDescriptor.extend[ equalAreSymbol ] !== undefined )
  dstPrototype[ equalAreSymbol ] = mixinDescriptor.extend[ equalAreSymbol ];

  /* */

  if( !Config.debug )
  return;

  if( dstPrototype[ equalAreSymbol ] )
  _.assert( dstPrototype[ equalAreSymbol ].length <= 1 );

  _.assert( !( 'equalWith' in dstPrototype ) );
  if( _.routineIs( dstPrototype.equalWith ) )
  _.assert( dstPrototype.equalWith.length <= 2 );

  _.assert( !!dstClass.prototype.FieldsOfRelationsGroupsGet );
  _.assert( !!dstClass.FieldsOfRelationsGroupsGet );
  _.assert( !!dstClass.fieldsOfRelationsGroups );
  _.assert( !!dstClass.FieldsOfRelationsGroups );
  _.assert( !!dstClass.prototype.fieldsOfRelationsGroups );
  _.assert( !!dstClass.prototype.FieldsOfRelationsGroups );

  _.assert( dstPrototype._fieldsOfRelationsGroupsGet === _fieldsOfRelationsGroupsGet );
  _.assert( dstPrototype._fieldsOfCopyableGroupsGet === _fieldsOfCopyableGroupsGet );
  _.assert( dstPrototype._fieldsOfTightGroupsGet === _fieldsOfTightGroupsGet );
  _.assert( dstPrototype._fieldsOfInputGroupsGet === _fieldsOfInputGroupsGet );

  _.assert( dstPrototype.constructor.FieldsOfRelationsGroupsGet === FieldsOfRelationsGroupsGet );
  _.assert( dstPrototype.constructor.FieldsOfCopyableGroupsGet === FieldsOfCopyableGroupsGet );
  _.assert( dstPrototype.constructor.FieldsOfTightGroupsGet === FieldsOfTightGroupsGet );
  _.assert( dstPrototype.constructor.FieldsOfInputGroupsGet === FieldsOfInputGroupsGet );

  _.assert( _.routineIs( dstPrototype[ equalAreSymbol ] ), `Lack of method ${String( equalAreSymbol )}` );
  _.assert( _.routineIs( dstPrototype[ equalAreSymbol ].head ), `Lack of method ${String( equalAreSymbol )}.head` );
  _.assert( _.routineIs( dstPrototype[ equalAreSymbol ].body ), `Lack of method ${String( equalAreSymbol )}.body` );

  _.assert( dstPrototype.finit.name !== 'finitEventHandler', 'wEventHandler mixin should goes after wCopyable mixin.' );
  _.assert( !_.mixinHas( dstPrototype, 'wEventHandler' ), 'wEventHandler mixin should goes after wCopyable mixin.' );

}

//

/**
 * Default instance constructor.
 * @method init
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function init( o )
{
  return _.workpiece.initWithArguments({ instance : this, args : arguments });
}

//

/**
 * Instance descturctor.
 * @method finit
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function finit()
{
  var self = this;
  _.workpiece.finit( self );
}

//

/**
 * Is this instance finited.
 * @method isFinited
 * @param {object} ins - another instance of the class
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function isFinited()
{
  var self = this;
  return _.workpiece.isFinited( self );
}

//

function From( src )
{
  return _.workpiece.from( src );
}

//

function Froms( srcs )
{
  return _.workpiece.froms( src );
}

//

/**
 * Copy data from another instance.
 * @param {object} src - another isntance.
 * @method copy
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function copy( src )
{
  var self = this;
  var routine = ( self._traverseAct || _traverseAct );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( src instanceof self.Self || _.mapIs( src ), 'Expects instance of Class or map as argument' );

  var o =
  {
    dst : self,
    src,
    technique : 'object',
    copyingMedials : _.instanceIs( src ) ? 0 : 1,
  };
  var it = _._cloner( routine, o );

  return routine.call( self, it );
}

//

/**
 * Copy data from one instance to another. Customizable static function.
 * @param {object} o - options.
 * @param {object} o.Prototype - prototype of the class.
 * @param {object} o.src - src isntance.
 * @param {object} o.dst - dst isntance.
 * @param {object} o.constitutes - to constitute or not fields, should be off for serializing and on for deserializing.
 * @method copyCustom
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function copyCustom( o )
{
  var self = this;
  var routine = ( self._traverseAct || _traverseAct );

  _.assert( arguments.length === 1 );

  if( o.dst === undefined )
  o.dst = self;

  var it = _._cloner( copyCustom, o );

  return routine.call( self, it );
}

copyCustom.iterationDefaults = Object.create( _._cloner.iterationDefaults );
copyCustom.defaults = _.mapExtendDstNotOwn( Object.create( _._cloner.defaults ), copyCustom.iterationDefaults );

//

function copyDeserializing( o )
{
  var self = this;

  _.map.assertHasAll( o, copyDeserializing.defaults )
  _.map.assertHasNoUndefine( o );
  _.assert( arguments.length === 1 );
  _.assert( _.object.isBasic( o ) );

  var optionsMerging = Object.create( null );
  optionsMerging.src = o;
  optionsMerging.proto = Object.getPrototypeOf( self );
  optionsMerging.dst = self;
  optionsMerging.deserializing = 1;

  var result = _.cloneObjectMergingBuffers( optionsMerging );

  return result;
}

copyDeserializing.defaults =
{
  descriptorsMap : null,
  buffer : null,
  data : null,
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneObject
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function cloneObject( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.routine.options_( cloneObject, o );

  var it = _._cloner( cloneObject, o );

  return self._cloneObject( it );
}

cloneObject.iterationDefaults = Object.create( _._cloner.iterationDefaults );
cloneObject.defaults = _.mapExtendDstNotOwn( Object.create( _._cloner.defaults ), cloneObject.iterationDefaults );
cloneObject.defaults.technique = 'object';

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method _cloneObject
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function _cloneObject( it )
{
  var self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.iterator.technique === 'object' );

  /* */


  if( it.dst )
  {
    it.dst._traverseAct( it );
  }
  else
  {
    dst = it.dst = new it.src.constructor( it.src );
    if( it.dst === it.src )
    {
      dst = it.dst = new it.src.constructor();
      it.dst._traverseAct( it );
    }
  }

  // if( !it.dst )
  // {
  //   dst = it.dst = new it.src.constructor( it.src );
  //   if( it.dst === it.src )
  //   {
  //     dst = it.dst = new it.src.constructor();
  //     it.dst._traverseAct( it );
  //   }
  // }
  // else
  // {
  //   it.dst._traverseAct( it );
  // }

  return it.dst;
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneData
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function cloneData( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o.src === undefined )
  o.src = self;

  if( o.dst === undefined || o.dst === null )
  o.dst = Object.create( null );

  var it = _._cloner( cloneData, o );

  return self._cloneData( it );
}

cloneData.iterationDefaults = Object.create( _._cloner.iterationDefaults );
cloneData.iterationDefaults.dst = null;
cloneData.iterationDefaults.copyingAggregates = 3;
cloneData.iterationDefaults.copyingAssociates = 0;
cloneData.defaults = _.mapExtendDstNotOwn( Object.create( _._cloner.defaults ), cloneData.iterationDefaults );
cloneData.defaults.technique = 'data';

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method _cloneData
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function _cloneData( it )
{
  var self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.iterator.technique === 'data' );

  return self._traverseAct( it );
}

//

function _traverseAct_head( routine, args )
{
  let self = this;
  let it = args[ 0 ];

  _.assert( _.object.isBasic( it ) );
  _.assert( arguments.length === 2, 'Expects single argument' );
  _.assert( args.length === 1, 'Expects single argument' );

  /* adjust */

  if( it.src === undefined )
  it.src = self;

  if( it.iterator.technique === 'data' )
  if( !it.dst )
  it.dst = Object.create( null );

  if( !it.proto && it.dst )
  it.proto = Object.getPrototypeOf( it.dst );
  if( !it.proto && it.src )
  it.proto = Object.getPrototypeOf( it.src );

  return it;
}

//

/**
 * Copy data from one instance to another. Customizable static function.
 * @param {object} o - options.
 * @param {object} o.Prototype - prototype of the class.
 * @param {object} o.src - src isntance.
 * @param {object} o.dst - dst isntance.
 * @param {object} o.constitutes - to constitute or not fields, should be off for serializing and on for deserializing.
 * @method _traverseAct
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

var _empty = Object.create( null );
function _traverseAct_body( it )
{
  var self = this;

  /* adjust */

  _.assert( !_.primitiveIs( it.proto ) );

  /* var */

  var proto = it.proto;
  var src = it.src;
  var dst = it.dst;
  var dropFields = it.dropFields || _empty;
  var Composes = proto.Composes || _empty;
  var Aggregates = proto.Aggregates || _empty;
  var Associates = proto.Associates || _empty;
  var Restricts = proto.Restricts || _empty;
  var Medials = proto.Medials || _empty;

  /* verification */

  _.map.assertHasNoUndefine( it );
  _.map.assertHasNoUndefine( it.iterator );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( src !== dst );
  _.assert( !!src );
  _.assert( _.strIs( it.path ) );
  _.assert( !_.primitiveIs( proto ), 'Expects object {-proto-}, but got', _.entity.strType( proto ) );
  _.assert( !it.customFields || _.object.isBasic( it.customFields ) );
  _.assert( it.level >= 0 );
  _.assert( _.numberIs( it.copyingDegree ) );
  _.assert( _.routineIs( self.__traverseAct ) );

  if( _.workpiece.instanceIsStandard( src ) )
  _.map.assertOwnOnly( src, [ Composes, Aggregates, Associates, Restricts ], () => 'Options instance for ' + self.qualifiedName + ' should not have fields :' );
  else
  _.map.assertOwnOnly( src, [ Composes, Aggregates, Associates, Medials ], () => 'Options map for ' + self.qualifiedName + ' should not have fields :' );

  /* */

  if( it.dst === null )
  {

    dst = it.dst = new it.src.constructor( it.src );
    if( it.dst === it.src )
    {
      dst = it.dst = new it.src.constructor();
      self.__traverseAct( it );
    }

  }
  else
  {

    self.__traverseAct( it );

  }

  /* done */

  return dst;
}

_traverseAct_body.iterationDefaults = Object.create( _._cloner.iterationDefaults );
_traverseAct_body.defaults = _.mapExtendDstNotOwn( Object.create( _._cloner.defaults ), _traverseAct_body.iterationDefaults );

let _traverseAct = _.routine.uniteCloning_replaceByUnite( _traverseAct_head, _traverseAct_body );

//

function __traverseAct( it )
{

  /* var */

  var proto = it.proto;
  var src = it.src;
  var dst = it.dst = it.dst;
  var dropFields = it.dropFields || _empty;
  var Composes = proto.Composes || _empty;
  var Aggregates = proto.Aggregates || _empty;
  var Associates = proto.Associates || _empty;
  var Restricts = proto.Restricts || _empty;
  var Medials = proto.Medials || _empty;

  var ordersHash = new HashMap;
  var standardOrder = true;

  /* */

  var newIt = it.iterationClone();

  // if( _global_.debugger )
  // debugger;

  copyFacets( Composes, it.copyingComposes );
  copyFacets( Aggregates, it.copyingAggregates );
  copyFacets( Associates, it.copyingAssociates );
  copyFacets( _.mapOnly_( null, Medials, Restricts ), it.copyingMedialRestricts );
  copyFacets( Restricts, it.copyingRestricts );
  copyFacets( it.customFields, it.copyingCustomFields );

  run();

  /* done */

  return dst;

  /* */

  function copyFacets( screen, copyingDegree )
  {

    if( screen === null )
    return;

    if( !copyingDegree )
    return;

    _.assert( _.mapIs( screen ) || _.aux.isPrototyped( screen ) );
    let screen2 = _.props.extend( null, screen );
    _.assert( _.numberIs( copyingDegree ) );
    _.assert( it.dst === dst );
    _.assert( _.mapIs( screen2 ) || _.aux.isPrototyped( screen2 ) || !copyingDegree );

    let newIt2 = Object.create( null );
    newIt2.screenFields = screen2;
    newIt2.copyingDegree = Math.min( copyingDegree, it.copyingDegree );
    newIt2.instanceAsMap = 1;

    _.assert( it.copyingDegree === 3, 'not tested' );
    _.assert( newIt2.copyingDegree === 1 || newIt2.copyingDegree === 3, 'not tested' );

    /* copyingDegree applicable to fields, so increment is needed */

    if( newIt2.copyingDegree === 1 )
    newIt2.copyingDegree += 1;

    for( let s in screen2 )
    {
      let e = screen[ s ];
      if( _.definitionIs( e ) )
      if( e.order < 0 || e.order > 0 )
      {
        let newIt3 = _.props.extend( null, newIt2 );
        newIt3.screenFields = Object.create( null );
        newIt3.screenFields[ s ] = screen2[ s ];
        delete screen2[ s ];
        orderAdd( e.order, newIt3 );
      }
    }

    orderAdd( 0, newIt2 );

  }

  /* */

  function orderAdd( order, newIt2 )
  {
    _.assert( _.numberIs( order ) );

    if( !ordersHash.has( order ) )
    ordersHash.set( order, [] );

    ordersHash.get( order ).push( newIt2 );

  }

  /* */

  function run()
  {

    let orders = Array.from( ordersHash.keys() );
    orders.sort();

    orders.forEach( ( order ) =>
    {
      let its = ordersHash.get( order );
      its.forEach( ( newIt2 ) =>
      {
        _.props.extend( newIt, newIt2 );
        _._traverseMap( newIt );
      });
    });

  }

}

//

function Clone( o )
{
  var cls = this.Self;
  o = o || Object.create( null );

  _.assert( arguments.length <= 1 );

  if( o instanceof cls )
  return o.clone();
  else
  return cls( o )
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneSerializing
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function cloneSerializing( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o.src === undefined )
  o.src = self;

  if( o.copyingMedials === undefined )
  o.copyingMedials = 0;

  if( o.copyingMedialRestricts === undefined )
  o.copyingMedialRestricts = 1;

  var result = _.cloneDataSeparatingBuffers( o );

  return result;
}

cloneSerializing.defaults =
{
  copyingMedialRestricts : 1,
}

// cloneSerializing.defaults.__proto__ = _.cloneDataSeparatingBuffers.defaults;
Object.setPrototypeOf( cloneSerializing.defaults, _.cloneDataSeparatingBuffers.defaults )

//

/**
 * Clone instance.
 * @method clone
 * @param {object} [self] - optional destination
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function clone()
{
  var self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  var dst = new self.constructor( self );
  _.assert( dst !== self );

  return dst;
}

//

function cloneExtending( override )
{
  var self = this;

  _.assert( arguments.length <= 1 );

  // if( !override )
  if( override )
  {
    var src = _.mapOnly_( null, self, self.Self.FieldsOfCopyableGroups );
    _.props.extend( src, override );
    var dst1 = new self.constructor( src );
    _.assert( dst1 !== self && dst1 !== src );
    return dst1;

    // var dst0 = new self.constructor( self );
    // _.assert( dst0 !== self );
    // return dst0;
  }
  else
  {
    var dst0 = new self.constructor( self );
    _.assert( dst0 !== self );
    return dst0;

    // var src = _.mapOnly_( null, self, self.Self.FieldsOfCopyableGroups );
    // _.props.extend( src, override );
    // var dst1 = new self.constructor( src );
    // _.assert( dst1 !== self && dst1 !== src );
    // return dst1;
  }

}

//

function cloneEmpty()
{
  var self = this;
  return self.clone();
}

// --
// etc
// --

/**
 * Gives descriptive string of the object.
 * @method toStr
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function toStr( o )
{
  return _.workpiece.toStr( this, o );
}

// --
// dichotomy
// --

function _equalAre_functor( fieldsGroupsMap )
{
  _.assert( arguments.length <= 1 );

  fieldsGroupsMap = _.routine.options_( _equalAre_functor, fieldsGroupsMap || null );

  _.routineExtend( _equalAre, _.equaler._equal );

  return _equalAre;

  function _equalAre( it )
  {

    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.object.isBasic( it ) );
    _.assert( it.strictTyping !== undefined );
    _.assert( it.containing !== undefined );

    if( !it.src )
    return end( false );

    if( !it.src2 )
    return end( false );

    if( it.strictTyping )
    if( it.src.constructor !== it.src2.constructor )
    return end( false );

    if( it.src === it.src2 )
    return end( true );

    /* */

    var fieldsMap = Object.create( null );
    for( var g in fieldsGroupsMap )
    if( fieldsGroupsMap[ g ] )
    _.props.extend( fieldsMap, this[ g ] );

    /* */

    let c = 0;
    for( var f in fieldsMap )
    {
      if( !it.continue || !it.iterator.continue )
      break;
      var newIt = it.iterationMake().choose( it.src[ f ], f, c, true );
      c += 1;
      if( !_.props.own( it.src, f ) )
      return end( false );
      newIt.iterate();
      // if( !_.equaler._equal.body( newIt ) )
      // return end( false );
    }

    if( !it.iterator.continue )
    return;
    // yyy
    // return it.result;

    /* */

    if( !it.containing )
    {
      if( !( it.src2 instanceof this.constructor ) )
      if( _.props.keys( _.mapBut_( null, it.src, fieldsMap ) ).length )
      return end( false );
    }

    if( !( it.src instanceof this.constructor ) )
    if( _.props.keys( _.mapBut_( null, it.src, fieldsMap ) ).length )
    return end( false );

    /* */

    return end( true );

    /* */

    function end( result )
    {
      it.continue = false;
      it.result = result;
    }

  }

}

_equalAre_functor.defaults = Object.create( null );

var on = _.map.make( _.DefaultFieldsGroupsCopyable );
var off = _.mapBut_( null, _.DefaultFieldsGroups, _.DefaultFieldsGroupsCopyable );
_.mapAllValsSet( on, 1 );
_.mapAllValsSet( off, 0 );
_.props.extend( _equalAre_functor.defaults, on, off );

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method _equalAre
 * @param {object} ins - another instance of the class
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

var _equalAre = _equalAre_functor();

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method identicalWith
 * @param {object} src - another instance of the class
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function identicalWith( src, opts )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !opts || _.mapIs( opts ), 'not tested' );

  var args = [ self, src, opts ];
  var it = self[ equalAreSymbol ].head.call( self, self.identicalWith, args );
  var r = this[ equalAreSymbol ]( it );

  return it.result;
}

_.routine.extendReplacing( identicalWith, { defaults : _.entityIdentical.defaults } );

//

/**
 * Is this instance equivalent with another one. Use relation maps to compare.
 * @method equivalentWith
 * @param {object} src - another instance of the class
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function equivalentWith( src, opts )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !opts || _.mapIs( opts ), 'not tested' );

  var args = [ self, src, opts ];
  var it = self[ equalAreSymbol ].head.call( self, self.equivalentWith, args );
  var r = this[ equalAreSymbol ]( it );

  return it.result;
}

_.routine.extendReplacing( equivalentWith, { defaults : _.entityEquivalent.defaults } );

//

/**
 * Does this instance contain with another instance or map.
 * @method contains
 * @param {object} src - another instance of the class
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function contains( src, opts )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !opts || _.mapIs( opts ), 'not tested' );

  var args = [ self, src, opts ];
  var it = self[ equalAreSymbol ].head.call( self, self.contains, args );

  // _.assert( it.src === null );
  // _.assert( it.src2 === null );
  //
  // it.src = it.src;
  // it.src2 = it.src2;

  var r = this[ equalAreSymbol ]( it );

  return it.result;
}

_.routine.extendReplacing( contains, { defaults : _.entityContains.defaults } );

//

function instanceIs()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return _.instanceIs( this );
}

//

function prototypeIs()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return _.workpiece.prototypeIs( this );
}

//

function constructorIs()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return _.constructorIs( this );
}

// --
// field
// --

/**
 * Get map of all fields.
 * @method FieldsOfRelationsGroupsGet
 * @class wCopyable
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 */

function _fieldsOfRelationsGroupsGet()
{
  var self = this;
  return _.workpiece.fieldsOfRelationsGroups( this );
}

//

/**
 * Get map of copyable fields.
 * @method _fieldsOfCopyableGroupsGet
 * @class wCopyable
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 */

function _fieldsOfCopyableGroupsGet()
{
  var self = this;
  return _.workpiece.fieldsOfCopyableGroups( this );
}

//

/**
 * Get map of loggable fields.
 * @method _fieldsOfTightGroupsGet
 * @class wCopyable
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 */

function _fieldsOfTightGroupsGet()
{
  var self = this;
  return _.workpiece.fieldsOfTightGroups( this );
}

//

function _fieldsOfInputGroupsGet()
{
  var self = this;
  return _.workpiece.fieldsOfInputGroups( this );
}

//

/**
 * Get map of all relations fields.
 * @method FieldsOfRelationsGroupsGet
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function FieldsOfRelationsGroupsGet()
{
  return _.workpiece.fieldsOfRelationsGroups( this.Self );
}

//

/**
 * Get map of copyable fields.
 * @method FieldsOfCopyableGroupsGet
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function FieldsOfCopyableGroupsGet()
{
  return _.workpiece.fieldsOfCopyableGroups( this.Self );
}

//

/**
 * Get map of tight fields.
 * @method FieldsOfTightGroupsGet
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function FieldsOfTightGroupsGet()
{
  return _.workpiece.fieldsOfTightGroups( this.Self );
}

//

/**
 * Get map of input fields.
 * @method FieldsOfInputGroupsGet
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function FieldsOfInputGroupsGet()
{
  return _.workpiece.fieldsOfInputGroups( this.Self );
}

//

function hasField( propName )
{
  return _.workpiece.prototypeHasField( this, propName );
}

// --
// class
// --

/**
 * Return own constructor.
 * @method _SelfGet
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function _SelfGet()
{
  var result = _.workpiece.constructorOf( this );
  return result;
}

//

/**
 * Return parent's constructor.
 * @method _ParentGet
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function _ParentGet()
{
  var result = _.workpiece.parentOf( this );
  return result;
}

// --
// name
// --

function _lowNameGet()
{
  return _.workpiece.lowClassName( this );
}

//

/**
 * Return name of class constructor.
 * @method _classNameGet
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function _classNameGet()
{
  return _.workpiece.className( this );
}

//

/**
 * Nick name of the object.
 * @method _qualifiedNameGet
 * @module Tools/base/CopyableMixin
 * @namespace Tools
 * @class wCopyable
 */

function _qualifiedNameGet()
{
  return _.workpiece._qualifiedNameGet( this );
}

//

function unameGet()
{
  return _.workpiece.uname( this );
}

// --
// relations
// --

var equalAreSymbol = Symbol.for( 'equalAre' );

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
}

var Medials =
{
}

var Statics =
{

  From,
  Froms,

  Clone,

  instanceIs,
  prototypeIs,
  constructorIs,

  _fieldsOfRelationsGroupsGet,
  _fieldsOfCopyableGroupsGet,
  _fieldsOfTightGroupsGet,
  _fieldsOfInputGroupsGet,

  FieldsOfRelationsGroupsGet,
  FieldsOfCopyableGroupsGet,
  FieldsOfTightGroupsGet,
  FieldsOfInputGroupsGet,

  hasField,

  _SelfGet,
  _ParentGet,
  _classNameGet,
  _lowNameGet,

}

Object.freeze( Composes );
Object.freeze( Aggregates );
Object.freeze( Associates );
Object.freeze( Restricts );
Object.freeze( Medials );
Object.freeze( Statics );

// --
// declare
// --

var Supplement =
{

  init,
  finit,
  isFinited,

  From,
  Froms,

  copy,

  copyCustom,
  copyDeserializing,

  _traverseAct,
  __traverseAct,

  cloneObject,
  _cloneObject,

  cloneData,
  _cloneData,

  Clone,
  cloneSerializing,
  clone,
  cloneExtending,
  cloneEmpty,

  // etc

  toStr,

  // dichotomy

  _equalAre_functor,
  [ equalAreSymbol ] : _equalAre,

  identicalWith,
  equivalentWith,
  contains,

  instanceIs,
  prototypeIs,
  constructorIs,

  // field

  _fieldsOfRelationsGroupsGet,
  _fieldsOfCopyableGroupsGet,
  _fieldsOfTightGroupsGet,
  _fieldsOfInputGroupsGet,

  // class

  _SelfGet,
  _ParentGet,

  // name

  _lowNameGet,
  _classNameGet,
  _qualifiedNameGet,
  unameGet,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Medials,
  Statics,

}

//

const Self = _.mixinDelcare
({
  supplement : Supplement,
  onMixinApply,
  name : 'wCopyable',
  shortName : 'Copyable',
});

//

_.assert( !Self.copy );
_.assert( _.routineIs( Self.prototype.copy ) );
_.assert( _.strIs( Self.shortName ) );
_.assert( _.object.isBasic( Self.__mixin__ ) );
_.assert( !Self.onMixinApply );
_.assert( _.routineIs( Self.mixin ) );

// --
// export
// --

_global_[ Self.name ] = _[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

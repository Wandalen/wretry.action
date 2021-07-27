( function _Class_s_() {

'use strict';

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

const _ObjectHasOwnProperty = Object.hasOwnProperty;
const _ObjectPropertyIsEumerable = Object.propertyIsEnumerable;
// let _nameFielded = _.nameFielded;

_.assert( _.object.isBasic( _.props ), 'wProto needs Tools/wtools/abase/l1/FieldMapper.s' );
// _.assert( _.routineIs( _nameFielded ), 'wProto needs Tools/wtools/l3/NameTools.s' );

// --
// mixin
// --

/**
 * Make mixin which could be mixed into prototype of another object.
 * @param {object} o - options.
 * @function _mixinDelcare
 * @namespace Tools
 * @module Tools/base/Proto
 */

function _mixinDelcare( o )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( o ) || _.routineIs( o ) );
  _.assert( _.routineIs( o.onMixinApply ) || o.onMixinApply === undefined || o.onMixinApply === null, 'Expects routine {-o.onMixinApply-}, but got', _.entity.strType( o ) );
  _.assert( _.strDefined( o.name ), 'mixin should have name' );
  _.assert( _.object.isBasic( o.extend ) || o.extend === undefined || o.extend === null );
  _.assert( _.object.isBasic( o.supplementOwn ) || o.supplementOwn === undefined || o.supplementOwn === null );
  _.assert( _.object.isBasic( o.supplement ) || o.supplement === undefined || o.supplement === null );
  _.assertOwnNoConstructor( o );
  _.routine.options_( _mixinDelcare, o );

  o.mixin = function mixin( dstClass )
  {
    let md = this.__mixin__;

    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.routineIs( dstClass ), 'Expects constructor' );
    _.assert( dstClass === dstClass.prototype.constructor );
    _.map.assertHasOnly( this, [ _.KnownConstructorFields, { mixin : 'mixin', __mixin__ : '__mixin__' }, this.prototype.Statics || {} ] );

    if( md.onMixinApply )
    md.onMixinApply( md, dstClass );
    else
    _.mixinApply( md, dstClass.prototype );
    if( md.onMixinEnd )
    md.onMixinEnd( md, dstClass );

    return dstClass;
  }

  /* */

  if( !o.prototype )
  {
    let got = _.workpiece.prototypeAndConstructorOf( o );

    if( got.prototype )
    o.prototype = got.prototype;
    else
    o.prototype = Object.create( null );

    _.classExtend
    ({
      cls : got.cls || null,
      prototype : o.prototype,
      extend : o.extend || null,
      supplementOwn : o.supplementOwn || null,
      supplement : o.supplement || null,
    });

  }

  _.assert( !o.prototype.mixin, 'not tested' );
  o.prototype.mixin = o.mixin;
  if( o.prototype.constructor )
  {
    _.assert( !o.prototype.constructor.mixin || o.prototype.constructor.mixin === o.mixin, 'not tested' );
    o.prototype.constructor.mixin = o.mixin;
  }

  Object.freeze( o );
  return o;
}

_mixinDelcare.defaults =
{

  name : null,
  shortName : null,
  prototype : null,

  extend : null,
  supplementOwn : null,
  supplement : null,
  functors : null,

  onMixinApply : null,
  onMixinEnd : null,

}

//

function mixinDelcare( o )
{
  let result = Object.create( null );

  _.assert( o.mixin === undefined );

  let md = result.__mixin__ = _._mixinDelcare.apply( this, arguments );
  result.name = md.name;
  result.shortName = md.shortName;
  result.prototype = md.prototype;
  result.mixin = md.mixin;

  Object.freeze( result );
  return result;
}

mixinDelcare.defaults = Object.create( _mixinDelcare.defaults );

//

/**
 * Mixin methods and fields into prototype of another object.
 * @param {object} o - options.
 * @function mixinApply
 * @namespace Tools
 * @module Tools/base/Proto
 */

function mixinApply( mixinDescriptor, dstPrototype )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( !_.primitiveIs( dstPrototype ), () => 'Second argument {-dstPrototype-} does not look like prototype, got ' + _.entity.strType( dstPrototype ) );
  _.assert( _.routineIs( mixinDescriptor.mixin ), 'First argument does not look like mixin descriptor' );
  _.assert( _.object.isBasic( mixinDescriptor ) );
  _.assert( Object.isFrozen( mixinDescriptor ), 'First argument does not look like mixin descriptor' );
  _.map.assertHasOnly( mixinDescriptor, _.MixinDescriptorFields );

  /* mixin into routine */

  if( !_.mapIs( dstPrototype ) )
  {
    _.assert( dstPrototype.constructor.prototype === dstPrototype, 'mixin :', 'Expects prototype with own constructor field' );
    _.assert( dstPrototype.constructor.name.length > 0 || dstPrototype.constructor._name.length > 0, 'mixin :', 'constructor should has name' );
    _.assert( _.routineIs( dstPrototype.init ) );
  }

  /* extend */

  _.assert( _.mapOnlyOwnKey( dstPrototype, 'constructor' ) );
  _.assert( dstPrototype.constructor.prototype === dstPrototype );
  _.classExtend
  ({
    cls : dstPrototype.constructor,
    extend : mixinDescriptor.extend,
    supplementOwn : mixinDescriptor.supplementOwn,
    supplement : mixinDescriptor.supplement,
    functors : mixinDescriptor.functors,
  });

  /* mixins map */

  if( !_ObjectHasOwnProperty.call( dstPrototype, '_mixinsMap' ) )
  {
    dstPrototype._mixinsMap = Object.create( dstPrototype._mixinsMap || null );
    _.props.conceal( dstPrototype, '_mixinsMap' );
  }

  _.assert
  (
    !dstPrototype._mixinsMap[ mixinDescriptor.name ],
      'Attempt to mixin same mixin ' + _.strQuote( mixinDescriptor.name ) +
      ' several times into ' + _.strQuote( dstPrototype.constructor.name )
  );

  dstPrototype._mixinsMap[ mixinDescriptor.name ] = 1;
}

//

function mixinHas( proto, mixin )
{
  if( _.constructorIs( proto ) )
  proto = _.workpiece.prototypeOf( proto );

  _.assert( _.workpiece.prototypeIsStandard( proto ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let result;

  if( _.strIs( mixin ) )
  {
    result = proto._mixinsMap && proto._mixinsMap[ mixin ];
  }
  else
  {
    _.assert( _.routineIs( mixin.mixin ), 'Expects mixin, but got not mixin', _.entity.strType( mixin ) );
    _.assert( _.strDefined( mixin.name ), 'Expects mixin, but got not mixin', _.entity.strType( mixin ) );
    result = proto._mixinsMap && proto._mixinsMap[ mixin.name ];
  }

  return !!result;
}

// --
// class
// --

/**
* @typedef {object} wTools~prototypeOptions
* @property {routine} [o.cls=null] - constructor for which prototype is needed.
* @property {routine} [o.parent=null] - constructor of parent class.
* @property {object} [o.extend=null] - extend prototype by this map.
* @property {object} [o.supplement=null] - supplement prototype by this map.
* @property {object} [o.static=null] - static fields of a class.
* @property {boolean} [o.usingPrimitiveExtension=false] - extends class with primitive fields from relationship descriptors.
* @property {boolean} [o.usingOriginalPrototype=false] - makes prototype using original constructor prototype.
*/

/**
 * Make prototype for constructor repairing relationship : Composes, Aggregates, Associates, Medials, Restricts.
 * Execute optional extend / supplement if such o present.
 * @param {wTools~prototypeOptions} o - options {@link wTools~prototypeOptions}.
 * @returns {object} Returns constructor's prototype based on( o.parent ) prototype and complemented by fields, static and non-static methods.
 *
 * @example
 *  const Parent = function Alpha(){ };
 *  Parent.prototype.init = function(  )
 *  {
 *    let self = this;
 *    self.c = 5;
 *  };
 *
 *  const Self = Betta;
 *  function Betta( o )
 *  {
 *    return _.workpiece.construct( Self, this, arguments );
 *  }
 *
 *  function init()
 *  {
 *    let self = this;
 *    Parent.prototype.init.call( this );
 *    _.mapExtendConditional( _.props.mapper.srcOwn(), self, Composes );
 *  }
 *
 *  let Composes =
 *  {
 *   a : 1,
 *   b : 2,
 *  }
 *
 *  let Proto =
 *  {
 *   init,
 *   Composes
 *  }
 *
 *  _.classDeclare
 *  ({
 *    cls : Self,
 *    parent : Parent,
 *    extend : Proto,
 *  });
 *
 *  let betta = new Betta();
 *  console.log( proto === Self.prototype ); //returns true
 *  console.log( Parent.prototype.isPrototypeFor( betta ) ); //returns true
 *  console.log( betta.a, betta.b, betta.c ); //returns 1 2 5
 *
 * @function classDeclare
 * @throws {exception} If no argument provided.
 * @throws {exception} If( o ) is not a Object.
 * @throws {exception} If( o.cls ) is not a Routine.
 * @throws {exception} If( o.cls.name ) is not defined.
 * @throws {exception} If( o.cls.prototype ) has not own constructor.
 * @throws {exception} If( o.cls.prototype ) has restricted properties.
 * @throws {exception} If( o.parent ) is not a Routine.
 * @throws {exception} If( o.extend ) is not a Object.
 * @throws {exception} If( o.supplement ) is not a Object.
 * @throws {exception} If( o.parent ) is equal to( o.extend ).
 * @throws {exception} If function cant rewrite constructor using original prototype.
 * @throws {exception} If( o.usingOriginalPrototype ) is false and ( o.cls.prototype ) has manually defined properties.
 * @throws {exception} If( o.cls.prototype.constructor ) is not equal( o.cls  ).
 * @namespace Tools
 * @module Tools/base/Proto
 */

/*
_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});
*/

function classDeclare( o )
{
  let result;

  if( o.withClass === undefined )
  o.withClass = true;

  if( o.cls && !o.name )
  o.name = o.cls.name;

  if( o.cls && !o.shortName )
  o.shortName = o.cls.shortName;

  /* */

  let has = {}
  has.constructor = 'constructor';

  let hasNot =
  {
    Parent : 'Parent',
    Self : 'Self',
  }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.object.isBasic( o ) );
  _.assertOwnNoConstructor( o, 'options for classDeclare should have no constructor' );
  _.assert( !( 'parent' in o ) || o.parent !== undefined, 'parent is "undefined", something is wrong' );

  if( o.withClass )
  {

    _.assert( _.routineIs( o.cls ), 'Expects {-o.cls-}' );
    _.assert( _.routineIs( o.cls ), 'classDeclare expects constructor' );
    _.assert( _.strIs( o.cls.name ) || _.strIs( o.cls._name ), 'constructor should have name' );
    _.assert( _ObjectHasOwnProperty.call( o.cls.prototype, 'constructor' ) );
    _.assert( !o.name || o.cls.name === o.name || o.cls._name === o.name, 'class has name', o.cls.name + ', but options', o.name );
    _.assert( !o.shortName || !o.cls.shortName|| o.cls.shortName === o.shortName, 'class has short name', o.cls.shortName + ', but options', o.shortName );

    _.map.assertOwnAll( o.cls.prototype, has, 'classDeclare expects constructor' );
    _.map.assertOwnNone( o.cls.prototype, hasNot );
    _.map.assertOwnNone( o.cls.prototype, _.DefaultForbiddenNames );

    if( o.extend && _ObjectHasOwnProperty.call( o.extend, 'constructor' ) )
    _.assert( o.extend.constructor === o.cls );

  }
  else
  {
    _.assert( !o.cls );
  }

  _.assert( _.routineIs( o.parent ) || o.parent === undefined || o.parent === null, () => 'Wrong type of parent : ' + _.entity.strType( 'o.parent' ) );
  _.assert( _.object.isBasic( o.extend ) || o.extend === undefined );
  _.assert( _.object.isBasic( o.supplement ) || o.supplement === undefined );
  _.assert( o.parent !== o.extend || o.extend === undefined );

  if( o.extend )
  {
    _.assert( o.extend.cls === undefined );
    _.assertOwnNoConstructor( o.extend );
  }
  if( o.supplementOwn )
  {
    _.assert( o.supplementOwn.cls === undefined );
    _.assertOwnNoConstructor( o.supplementOwn );
  }
  if( o.supplement )
  {
    _.assert( o.supplement.cls === undefined );
    _.assertOwnNoConstructor( o.supplement );
  }

  _.routine.options_( classDeclare, o );

  /* */

  let prototype;
  if( !o.parent )
  o.parent = null;

  /* make prototype */

  if( o.withClass )
  {

    if( o.usingOriginalPrototype )
    {

      prototype = o.cls.prototype;
      _.assert( o.parent === null || o.parent === Object.getPrototypeOf( o.cls.prototype ) );

    }
    else
    {
      if( o.cls.prototype )
      {
        _.assert( Object.keys( o.cls.prototype ).length === 0, 'misuse of classDeclare, prototype of constructor has properties which where put there manually', Object.keys( o.cls.prototype ) );
        _.assert( o.cls.prototype.constructor === o.cls );
      }
      if( o.parent )
      {
        prototype = o.cls.prototype = Object.create( o.parent.prototype );
      }
      else
      {
        prototype = o.cls.prototype = Object.create( null );
      }
    }

    /* constructor */

    prototype.constructor = o.cls;

    if( o.parent )
    {
      Object.setPrototypeOf( o.cls, o.parent );
    }

    /* extend */

    _.classExtend
    ({
      cls : o.cls,
      extend : o.extend,
      supplementOwn : o.supplementOwn,
      supplement : o.supplement,
      usingPrimitiveExtension : o.usingPrimitiveExtension,
      usingStatics : 1,
      allowingExtendStatics : o.allowingExtendStatics,
    });

    /* statics */

    _.assert( _.routineIs( prototype.constructor ) );
    _.assert( _.object.isBasic( prototype.Statics ) );
    _.map.assertHasAll( prototype.constructor, prototype.Statics );
    _.assert( prototype === o.cls.prototype );
    _.assert( _ObjectHasOwnProperty.call( prototype, 'constructor' ), 'prototype should own constructor' );
    _.assert( _.routineIs( prototype.constructor ), 'prototype should has own constructor' );

    /* mixin tracking */

    if( !_ObjectHasOwnProperty.call( prototype, '_mixinsMap' ) )
    {
      prototype._mixinsMap = Object.create( prototype._mixinsMap || null );
    }

    _.assert( !prototype._mixinsMap[ o.cls.name ] );

    prototype._mixinsMap[ o.cls.name ] = 1;

    result = o.cls;

    /* handler */

    if( prototype.OnClassMakeEnd_meta )
    prototype.OnClassMakeEnd_meta.call( prototype, o );

    if( o.onClassMakeEnd )
    o.onClassMakeEnd.call( prototype, o );

  }

  /* */

  if( o.withMixin )
  {

    let mixinOptions = _.props.extend( null, o );

    _.assert( !o.usingPrimitiveExtension );
    _.assert( !o.usingOriginalPrototype );
    _.assert( !o.parent );
    _.assert( !o.cls || !!o.withClass );

    delete mixinOptions.parent;
    delete mixinOptions.cls;
    delete mixinOptions.withMixin;
    delete mixinOptions.withClass;
    delete mixinOptions.usingPrimitiveExtension;
    delete mixinOptions.usingOriginalPrototype;
    delete mixinOptions.allowingExtendStatics;
    delete mixinOptions.onClassMakeEnd;

    if( mixinOptions.extend )
    mixinOptions.extend = _.props.extend( null, mixinOptions.extend );
    if( mixinOptions.supplement )
    mixinOptions.supplement = _.props.extend( null, mixinOptions.supplement );
    if( mixinOptions.supplementOwn )
    mixinOptions.supplementOwn = _.props.extend( null, mixinOptions.supplementOwn );

    mixinOptions.prototype = prototype; /* zzz : remove? */

    _._mixinDelcare( mixinOptions );
    o.cls.__mixin__ = mixinOptions;
    o.cls.mixin = mixinOptions.mixin;

    _.assert( mixinOptions.extend === null || mixinOptions.extend.constructor === undefined );
    _.assert( mixinOptions.supplement === null || mixinOptions.supplement.constructor === undefined );
    _.assert( mixinOptions.supplementOwn === null || mixinOptions.supplementOwn.constructor === undefined );

  }

  /* */

  if( Config.debug )
  if( prototype )
  {
    let descriptor = Object.getOwnPropertyDescriptor( prototype, 'constructor' );
    _.assert( descriptor.writable || descriptor.set );
    _.assert( descriptor.configurable );
  }

  return result;
}

classDeclare.defaults =
{
  cls : null,
  parent : null,

  onClassMakeEnd : null,
  onMixinApply : null,
  onMixinEnd : null,

  extend : null,
  supplementOwn : null,
  supplement : null,
  functors : null,

  name : null,
  shortName : null,

  usingPrimitiveExtension : false,
  usingOriginalPrototype : false,
  allowingExtendStatics : false,

  withMixin : false,
  withClass : true,

}

//

/**
 * Extends and supplements( o.cls ) prototype by fields and methods repairing relationship : Composes, Aggregates, Associates, Medials, Restricts.
 *
 * @param {wTools~prototypeOptions} o - options {@link wTools~prototypeOptions}.
 * @returns {object} Returns constructor's prototype complemented by fields, static and non-static methods.
 *
 * @example
 * const Self = Betta;
function Betta( o ) { };
 * let Statics = { staticFunction : function staticFunction(){ } };
 * let Composes = { a : 1, b : 2 };
 * let Proto = { Composes, Statics };
 *
 * let proto =  _.classExtend
 * ({
 *     cls : Self,
 *     extend : Proto,
 * });
 * console.log( Self.prototype === proto ); //returns true
 *
 * @function classExtend
 * @throws {exception} If no argument provided.
 * @throws {exception} If( o ) is not a Object.
 * @throws {exception} If( o.cls ) is not a Routine.
 * @throws {exception} If( prototype.cls ) is not a Routine.
 * @throws {exception} If( o.cls.name ) is not defined.
 * @throws {exception} If( o.cls.prototype ) has not own constructor.
 * @throws {exception} If( o.parent ) is not a Routine.
 * @throws {exception} If( o.extend ) is not a Object.
 * @throws {exception} If( o.supplement ) is not a Object.
 * @throws {exception} If( o.static) is not a Object.
 * @throws {exception} If( o.cls.prototype.Constitutes ) is defined.
 * @throws {exception} If( o.cls.prototype ) is not equal( prototype ).
 * @namespace Tools
 * @module Tools/base/Proto
 */

function classExtend( o )
{

  if( arguments.length === 2 )
  o = { cls : arguments[ 0 ], extend : arguments[ 1 ] };

  if( !o.prototype )
  o.prototype = o.cls.prototype;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.object.isBasic( o ) );
  _.assert( !_ObjectHasOwnProperty.call( o, 'constructor' ) );
  _.assertOwnNoConstructor( o );
  _.assert( _.object.isBasic( o.extend ) || o.extend === undefined || o.extend === null );
  _.assert( _.object.isBasic( o.supplementOwn ) || o.supplementOwn === undefined || o.supplementOwn === null );
  _.assert( _.object.isBasic( o.supplement ) || o.supplement === undefined || o.supplement === null );
  _.assert( _.routineIs( o.cls ) || _.object.isBasic( o.prototype ), 'Expects class constructor or class prototype' );

  /*
  mixin could have none class constructor
  */

  if( o.cls )
  {

    _.assert( _.routineIs( o.cls ), 'Expects constructor of class ( o.cls )' );
    _.assert( _.strIs( o.cls.name ) || _.strIs( o.cls._name ), 'Class constructor should have name' );
    _.assert( !!o.prototype );

  }

  if( o.extend )
  {
    _.assert( o.extend.cls === undefined );
    _.assertOwnNoConstructor( o.extend );
  }
  if( o.supplementOwn )
  {
    _.assert( o.supplementOwn.cls === undefined );
    _.assertOwnNoConstructor( o.supplementOwn );
  }
  if( o.supplement )
  {
    _.assert( o.supplement.cls === undefined );
    _.assertOwnNoConstructor( o.supplement );
  }

  _.routine.options_( classExtend, o );

  // _.assert( _.object.isBasic( o.prototype ) );
  _.assert( !_.primitiveIs( o.prototype ) && !_.routineIs( o.prototype ) );

  /* fields groups */

  _.workpiece.fieldsGroupsDeclareForEachFilter
  ({
    dstPrototype : o.prototype,
    extendMap : o.extend,
    supplementOwnMap : o.supplementOwn,
    supplementMap : o.supplement,
  });

  /* get constructor */

  if( !o.cls )
  o.cls = _.workpiece.prototypeAndConstructorOf( o ).cls;

  /* */

  let staticsOwn = _.props.onlyOwn( o.prototype.Statics );
  let staticsAll = staticsAllGet();
  let fieldsGroups = _.workpiece.fieldsGroupsGet( o.prototype );

/*

to prioritize ordinary facets adjustment order should be

- static extend
- ordinary extend
- ordinary supplement
- static supplement

*/

  /* static extend */

  if( o.extend && o.extend.Statics )
  declareStaticsForMixin( o.extend.Statics, _.props.extend.bind( _.props ) );

  /* ordinary extend */

  if( o.extend )
  fieldsDeclare( _.props.extend.bind( _.props ), o.extend );

  /* ordinary supplementOwn */

  if( o.supplementOwn )
  fieldsDeclare( _.mapExtendDstNotOwn, o.supplementOwn );

  /* ordinary supplement */

  if( o.supplement )
  fieldsDeclare( _.props.supplement.bind( _.props ), o.supplement );

  /* static supplementOwn */

  if( o.supplementOwn && o.supplementOwn.Statics )
  declareStaticsForMixin( o.supplementOwn.Statics, _.mapExtendDstNotOwn );

  /* static supplement */

  if( o.supplement && o.supplement.Statics )
  declareStaticsForMixin( o.supplement.Statics, _.props.supplement.bind( _.props ) );

  /* primitive extend */

  if( o.usingPrimitiveExtension )
  {
    debugger;
    for( let f in _.DefaultFieldsGroupsRelations )
    if( f !== 'Statics' )
    if( _.mapOnlyOwnKey( o.prototype, f ) )
    _.mapExtendConditional( _.props.mapper.srcOwnPrimitive(), o.prototype, o.prototype[ f ] );
  }

  /* accessors */

  if( o.supplement )
  declareAccessors( o.supplement );
  if( o.supplementOwn )
  declareAccessors( o.supplementOwn );
  if( o.extend )
  declareAccessors( o.extend );

  /* statics */

  let fieldsOfRelationsGroups = _.workpiece.fieldsOfRelationsGroupsFromPrototype( o.prototype );

  if( o.supplement && o.supplement.Statics )
  declareStaticsForClass( o.supplement.Statics, 1, 0 );
  if( o.supplementOwn && o.supplementOwn.Statics )
  declareStaticsForClass( o.supplementOwn.Statics, 1, 1 );
  if( o.extend && o.extend.Statics )
  declareStaticsForClass( o.extend.Statics, 0, 0 );

  /* functors */

  if( o.functors )
  for( let m in o.functors )
  {
    let func = o.functors[ m ].call( o, o.prototype[ m ] );
    _.assert( _.routineIs( func ), 'not tested' );
    o.prototype[ m ] = func;
  }

  /* validation */

  /*
  mixin could could have none class constructor
  */

  if( o.cls )
  {
    _.assert( o.prototype === o.cls.prototype );
    _.assert( _ObjectHasOwnProperty.call( o.prototype, 'constructor' ), 'prototype should has own constructor' );
    _.assert( _.routineIs( o.prototype.constructor ), 'prototype should has own constructor' );
    _.assert( o.cls === o.prototype.constructor );
  }

  _.assert( _.object.isBasic( o.prototype.Statics ) );

  return o.prototype;

  /* */

  function fieldsDeclare( extend, src )
  {
    let map = _.mapBut_( null, src, fieldsGroups );
    for( let s in staticsAll )
    if( map[ s ] === staticsAll[ s ] )
    delete map[ s ];
    extend( o.prototype, map );

    // if( _global_.debugger )
    // debugger;
    // let symbols = Object.getOwnPropertySymbols( src ); debugger;
    // for( let s in staticsAll )
    // if( symbols[ s ] === staticsAll[ s ] )
    // delete symbols[ s ];
    // extend( o.prototype, symbols );

    if( Config.debug )
    if( !o.allowingExtendStatics )
    if( Object.getPrototypeOf( o.prototype.Statics ) )
    {
      map = _.mapBut_( null, map, staticsOwn );

      let keys = _.props.keys( _.mapOnly_( null, map, Object.getPrototypeOf( o.prototype.Statics ) ) );
      if( keys.length )
      {
        _.assert( 0, 'attempt to extend static field', keys );
      }
    }
  }

  /* */

  function declareStaticsForMixin( statics, extend )
  {

    if( !o.usingStatics )
    return;

    extend( staticsAll, statics );

    /* is pure mixin */
    if( o.prototype.constructor )
    return;

    if( o.usingStatics && statics )
    {
      extend( o.prototype, statics );
      if( o.cls )
      extend( o.cls, statics );
    }

  }

  /* */

  function staticsAllGet()
  {
    let staticsAll = _.props.extend( null, o.prototype.Statics );
    if( o.supplement && o.supplement.Statics )
    _.props.supplement( staticsAll, o.supplement.Statics );
    if( o.supplementOwn && o.supplementOwn.Statics )
    _.mapExtendDstNotOwn( staticsAll, o.supplementOwn.Statics );
    if( o.extend && o.extend.Statics )
    _.props.extend( staticsAll, o.extend.Statics );
    return staticsAll;
  }

  /* */

  function declareStaticsForClass( statics, dstNotHasOnly, dstNotOwnOnly )
  {

    /* is class */
    if( !o.prototype.constructor )
    return;
    if( !o.usingStatics )
    return;

    for( let s in statics )
    {

      if( !_ObjectHasOwnProperty.call( o.prototype.Statics, s ) )
      continue;

      _.staticDeclare
      ({
        name : s,
        value : o.prototype.Statics[ s ],
        prototype : o.prototype,
        // extending : !dstNotHasOnly,
        dstNotHasOnly : dstNotHasOnly,
        dstNotOwnOnly : dstNotOwnOnly,
        fieldsOfRelationsGroups,
      });

    }

  }

  /* */

  function declareAccessors( src )
  {
    for( let d in _.accessor.DefaultAccessorsMap )
    if( src[ d ] )
    {
      _.accessor.DefaultAccessorsMap[ d ]( o.prototype, src[ d ] );
    }
  }

}

classExtend.defaults =
{
  cls : null,
  prototype : null,

  extend : null,
  supplementOwn : null,
  supplement : null,
  functors : null,

  usingStatics : true,
  usingPrimitiveExtension : false,
  allowingExtendStatics : false,
}

//

function staticDeclare( o )
{

  if( !( 'value' in o ) )
  o.value = o.prototype.Statics[ o.name ];

  if( _.definitionIs( o.value ) )
  {
    _.props.extend( o, o.value.toVal( o.value.val ) );
  }

  _.routine.options_( staticDeclare, arguments );
  _.assert( _.strIs( o.name ) );
  _.assert( arguments.length === 1 );

  if( !o.fieldsOfRelationsGroups )
  o.fieldsOfRelationsGroups = _.workpiece.fieldsOfRelationsGroupsFromPrototype( o.prototype );

  let pd = _.props.descriptorOf( o.prototype, o.name );
  let cd = _.props.descriptorOf( o.prototype.constructor, o.name );

  if( pd.object !== o.prototype )
  pd.descriptor = null;

  if( cd.object !== o.prototype.constructor )
  cd.descriptor = null;

  if( o.name === 'constructor' )
  return;

  let symbol = Symbol.for( o.name );
  let aname = _.accessor._propertyGetterSetterNames( o.name );
  let methods = Object.create( null );

  // if( o.name === 'UsingUniqueNames' )
  // debugger;

  /* */

  let prototype = o.prototype;
  if( o.writable )
  methods[ aname.set ] = function set( src )
  {
    /*
      should assign fields to the original class / prototype
      not descendant
    */
    prototype[ symbol ] = src;
    prototype.constructor[ symbol] = src;
  }
  methods[ aname.get ] = function get()
  {
    return this[ symbol ];
  }

  /* */

  if( o.fieldsOfRelationsGroups[ o.name ] === undefined )
  if( !pd.descriptor || ( !o.dstNotHasOnly && pd.descriptor.value === undefined ) )
  {

    if( cd.descriptor )
    {
      o.prototype[ o.name ] = o.value;
    }
    else
    {
      o.prototype[ symbol ] = o.value;

      _.accessor.declare
      ({
        object : o.prototype,
        methods,
        names : o.name,
        combining : 'rewrite',
        configurable : true,
        enumerable : false,
        strict : false,
        writable : o.writable,
      });

    }
  }

  /* */

  if( !cd.descriptor || ( !o.dstNotHasOnly && cd.descriptor.value === undefined ) )
  {
    if( pd.descriptor )
    {
      o.prototype.constructor[ o.name ] = o.value;
    }
    else
    {
      o.prototype.constructor[ symbol ] = o.value;

      _.accessor.declare
      ({
        object : o.prototype.constructor,
        methods,
        names : o.name,
        combining : 'rewrite',
        enumerable : true,
        configurable : true,
        prime : false,
        strict : false,
        writable : o.writable,
      });

    }

  }

  /* */

  return true;
}

var defaults = staticDeclare.defaults = Object.create( null );

defaults.name = null;
defaults.value = null;
defaults.prototype = null;
defaults.fieldsOfRelationsGroups = null;
defaults.dstNotHasOnly = 1; /**/
defaults.dstNotOwnOnly = 0; /* !!! not used yet */
defaults.writable = 1;

// --
// fields
// --

/**
 * @typedef {Object} KnownConstructorFields - contains fields allowed for class constructor.
 * @property {String} name - full name
 * @property {String} _name - private name
 * @property {String} shortName - short name
 * @property {Object} prototype - prototype object
 * @namespace Tools
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
 * @typedef {Object} MixinDescriptorFields - fields of mixin descriptor.
 * @property {String} name - full name
 * @namespace Tools
 * @module Tools/base/Proto
 */

let MixinDescriptorFields =
{

  name : null,
  shortName : null,
  prototype : null,

  extend : null,
  supplementOwn : null,
  supplement : null,
  functors : null,

  onMixinApply : null,
  onMixinEnd : null,
  mixin : null,

}

// --
// definiton
// --

let Extension =
{

  // mixin

  _mixinDelcare,
  mixinDelcare,
  mixinApply,
  mixinHas,

  // class

  classDeclare,
  classExtend,
  staticDeclare,

  //

  KnownConstructorFields,
  MixinDescriptorFields,

}

//

_.props.extend( _, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

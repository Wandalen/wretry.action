( function _l3_Diagnostic_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --
//

function objectMake( o )
{
  let result;

  _.assert( arguments.length === 1 );

  o = optionsAdjust( o )

  let originalOptions = o;
  let constructor = o.pure ? countableConstructorPure : countableConstructorPolluted;

  result = _make( o );

  return result;

  /* - */

  function _make( o )
  {
    let result;
    if( o.new )
    {
      if( o.pure )
      result = new countableConstructorPure( o );
      else
      result = new countableConstructorPolluted( o );
    }
    else
    {
      result = _objectMake( null, o );
    }
    return result;
  }

  /* - */

  function optionsAdjust( o )
  {
    _.aux.supplement( o, objectMake.defaults );

    if( o.countable === null )
    o.countable = true;
    if( o.vector === null )
    o.vector = _.number.is( o.length ) ? true : false;

    countableConstructorPure.prototype = Object.create( null );

    let constructor = o.pure ? countableConstructorPure : countableConstructorPolluted;

    if( o.withConstructor )
    {
      countableConstructorPure.prototype.constructor = countableConstructorPure;
      _.assert( countableConstructorPolluted.prototype.constructor === countableConstructorPolluted );
    }
    else
    {
      delete countableConstructorPolluted.prototype.constructor;
    }

    _.assert( countableConstructorPolluted.prototype !== Object.prototype );
    _.assert( countableConstructorPolluted.prototype !== Function.prototype );

    if( o.countable )
    if( o.elements === undefined || o.elements === null )
    o.elements = [];

    if( o.vector && o.length === undefined )
    {
      _.assert( _.long.is( o.elements ) );
      o.length = o.elements.length;
    }

    _.assert( !o.vector || !!o.countable );
    _.assert( !!o.vector === !!_.number.is( o.length ) );

    return o;
  }

  /* */

  function optionsMake( o )
  {
    o = o || Object.create( null );
    return _.props.extend( o, { countable : originalOptions.countable, vector : originalOptions.vector } );
  }

  /* */

  function TypeNameGet()
  {
    return 'Custom1';
  }

  /* */

  function* _iterateGenerator()
  {
    yield 1;
    yield 2;
    yield 3;
  }

  /* */

  function _iterate()
  {

    let iterator = Object.create( null );
    iterator.next = next;
    iterator.index = 0;
    iterator.instance = this;
    return iterator;

    function next()
    {
      let result = Object.create( null );
      result.done = this.index === this.instance.elements.length;
      if( result.done )
      return result;
      result.value = this.instance.elements[ this.index ];
      this.index += 1;
      return result;
    }

  }

  /* */

  function countableConstructorPure( o )
  {
    if( _.long.is( o ) )
    o = optionsAdjust( optionsMake({ elements : o }) );
    else if( !o )
    o = optionsAdjust( optionsMake() );
    return _objectMake( this, o );
  }

  /* */

  function countableConstructorPolluted( o )
  {
    if( _.long.is( o ) )
    o = optionsAdjust( optionsMake({ elements : o }) );
    else if( !o )
    o = optionsAdjust( optionsMake() );
    let result = _objectMake( this, o );
    if( !o.withConstructor )
    {
      _.assert( Object.getPrototypeOf( result ) !== Object.prototype );
      // delete Object.getPrototypeOf( result ).constructor;
      _.assert( Object.getPrototypeOf( result ).constructor === Object.prototype.constructor );
    }
    return result
  }

  /* */

  function _objectMake( dst, o )
  {
    if( dst === null )
    if( o.pure )
    dst = Object.create( null );
    else
    dst = {};
    _.props.extend( dst, o );

    if( o.countable )
    {
      if( o.iteratorIsGenerator )
      dst[ Symbol.iterator ] = _iterateGenerator;
      else
      dst[ Symbol.iterator ] = _iterate;
    }

    if( o.withOwnConstructor )
    dst.constructor = constructor;
    // dst.constructor = function ownConstructor(){}

    if( !o.basic )
    {
      Object.defineProperty( constructor.prototype, Symbol.toStringTag,
      {
        enumerable : false,
        configurable : false,
        get : TypeNameGet,
      });
    }

    Object.defineProperty( dst, 'makeUndefined',
    {
      enumerable : false,
      configurable : true,
      writable : true,
      value : makeUndefined,
    });

    Object.defineProperty( dst, 'eSet',
    {
      enumerable : false,
      configurable : true,
      writable : true,
      value : eSet,
    });

    return dst;
  }

  /* */

  function eSet( key, val )
  {
    _.assert( arguments.length === 2 );
    _.assert( _.number.is( key ) );
    this.elements[ key ] = val;
  }

  /* */

  function makeUndefined()
  {
    debugger;
    if( _.object.is( this ) )
    {
      let o2 = optionsMake();
      if( o2.elements === null || o2.elements === undefined )
      {
        if( _.number.is( this.length ) )
        o2.elements = new Array( this.elements.length );
        if( this.elements && _.number.is( this.elements.length ) )
        o2.elements = new Array( this.elements.length );
      }
      optionsAdjust( o2 );
      // return new this.constructor( o2 );
      return _make( o2 );
    }
    _.assert( 0 );
  }

  /* */

}

objectMake.defaults =
{
  new : 1,
  pure : 0,
  basic : 1,
  countable : null,
  iteratorIsGenerator : 0,
  vector : null,
  withOwnConstructor : 0,
  withConstructor : 1,
  elements : null,
}

// --
// declare
// --

let ToolsExtension =
{

}

Object.assign( _, ToolsExtension );

//

let DiagnosticExtension =
{

  objectMake,
  /* qqq : for junior : use _.diagnostic.objectMake() in all tests */

}

Object.assign( _.diagnostic, DiagnosticExtension );

})();

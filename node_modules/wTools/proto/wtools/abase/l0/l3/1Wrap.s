( function _l3_1Wrap_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implement
// --

function is( src )
{
  if( !src )
  return false;
  return src instanceof this.class;
}

//

function make( src )
{
  if( arguments.length !== 1 )
  throw new Error( 'Expects exactly one argument' );
  return new this.class( src );
}

//

function from( src )
{
  if( arguments.length !== 1 )
  throw new Error( 'Expects exactly one argument' );
  if( this.is( src ) )
  return src;
  return this.make( src );
}

//

function cloneShallow()
{
  _.assert( !( this instanceof cloneShallow ) );
  return this;
}

//

function cloneDeep()
{
  debugger;
  _.assert( !( this instanceof cloneDeep ) );
  return this;
}

//

function equalAre_functor( fo )
{
  let cls = fo.class;

  return function equalAre( it )
  {
    let self = this;

    _.assert( arguments.length === 1 );

    if( !it.src )
    return it.stop( false );
    if( !it.src2 )
    return it.stop( false );

    if( !( it.src instanceof cls ) )
    return it.stop( false );
    if( !( it.src2 instanceof cls ) )
    return it.stop( false );

    if( it.src.val === it.src2.val )
    return it.stop( true );

    if( !( it.src.val instanceof cls ) )
    return it.stop( false );
    if( !( it.src2.val instanceof cls ) )
    return it.stop( false );
  }

}

//

function iterator()
{

  let iterator = Object.create( null );
  iterator.next = next;
  iterator.index = 0;
  iterator.instance = this;
  return iterator;

  function next()
  {
    let result = Object.create( null );
    result.done = this.index === 1;
    if( result.done )
    return result;
    result.value = this.instance.val;
    this.index += 1;
    return result;
  }

}

//

function exportString()
{
  if( _.symbol.is( this.val ) )
  return `{- ${this.constructor.name} {- Symbol ${Symbol.keyFor( this.val )} -} -}`;
  else
  return `{- ${this.constructor.name} ${String( this.val )} -}`;
}

//

function declare( fo )
{

  fo.class = { [ fo.name ] : function( val )
  {
    if( arguments.length !== 1 )
    throw new Error( 'Expects exactly 1 argument' );
    this.val = val;
    Object.freeze( this );
    return this;
  }}[ fo.name ];

  _.class.declareBasic
  ({
    constructor : fo.class,
    iterator,
    equalAre : equalAre_functor( fo ),
    exportString,
    cloneShallow, /* xxx : implement */
    cloneDeep, /* xxx : implement */
  });

  _.assert( fo.namespace === undefined );
  _.assert( fo.class.name === fo.name );

  fo.namespace =
  {
    is,
    make,
    from,
    class : fo.class,
  }

  return fo;
}

declare.defaults =
{
  name : null,
}

//

var Extension =
{

  declare,

}

//

Object.assign( _.wrap, Extension );

})();

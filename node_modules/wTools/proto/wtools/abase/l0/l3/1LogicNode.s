( function _l3_1LogicNode_s_()
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
    debugger;
    if( !it.src.type !== it.src2.type )
    return it.stop( false );

    if( it.src.elements.length !== it.src2.elements.length )
    return it.stop( false );

    for( let i = 0 ; i < it.src.elements.length ; i++ )
    {
      debugger; xxx
      it.equal( it.src, it.src2 );
    }

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
    let instance = this.instance;
    result.done = this.index === instance.elements.length;
    if( result.done )
    return result;
    result.value = instance.elements[ this.index ];
    this.index += 1;
    return result;
  }

}

//

function exportString()
{
  return `{- ${this.type} with ${String( this.elements.length )} elements -}`;
}

//

function exportStructure()
{

}

//

function lengthGet()
{
  return this.elements.length;
}

//

function exec( o )
{
  o = _.routine.options( exec, arguments );
  o.onEach = o.onEach || defaultOnEach;
  let r = this._exec( o );
  return r;

  function defaultOnEach( e, it )
  {
    return e;
  }

}

exec.defaults =
{
  onEach : null,
}

//

function _orExec( it )
{
  let result = false;
  this.elements.some( ( e ) =>
  {
    if( _.logic.isNode( e ) )
    e = e._exec( it );
    e = it.onEach( e, it );
    if( e )
    {
      result = e;
      return true;
    }
  });
  return result;
}

//

function _andExec( it )
{
  let result = true;
  this.elements.every( ( e ) =>
  {
    if( _.logic.isNode( e ) )
    e = e._exec( it );
    e = it.onEach( e, it );
    if( !e )
    {
      result = e;
      return false;
    }
    return true;
  });
  return result;
}

//

function _xorExec( it )
{
  let result = false;
  this.elements.forEach( ( e ) =>
  {
    if( _.logic.isNode( e ) )
    e = e._exec( it );
    e = it.onEach( e, it );
    if( e )
    result = !result;
  });
  return result;
}

//

function _xandExec( it )
{
  let result = true;
  this.elements.forEach( ( e ) =>
  {
    if( _.logic.isNode( e ) )
    e = e._exec( it );
    e = it.onEach( e, it );
    if( e )
    result = !result;
  });
  return result;
}

//

function _ifExec( it )
{

  for( let i = 0, l = this.elements.length - 1 ; i < l ; i++ )
  {
    let e = this.elements[ i ];
    if( _.logic.isNode( e ) )
    e = e._exec( it );
    e = it.onEach( e, it );
    if( !e )
    return true;
  }

  if( this.elements.length > 0 )
  {
    let e = this.elements[ this.elements.length-1 ];
    if( _.logic.isNode( e ) )
    e = e._exec( it );
    e = it.onEach( e, it );
    return e;
  }

  return true;
}

//

function _firstExec( it )
{
  let e = this.elements[ 0 ];
  if( _.logic.isNode( e ) )
  e = e._exec( it );
  e = it.onEach( e, it );
  return e;
}

//

function _secondExec( it )
{
  let e = this.elements[ 1 ];
  if( _.logic.isNode( e ) )
  e = e._exec( it );
  e = it.onEach( e, it );
  return e;
}

//

function _notExec( it )
{
  let e = this.elements[ 0 ];
  if( _.logic.isNode( e ) )
  e = e._exec( it );
  e = it.onEach( e, it );
  return !e;
}

// --
// meta
// --

function DeclareAbstract( fo )
{

  fo.class = function LogicAbstractNode( elements )
  {
    if( arguments.length !== 1 )
    throw new Error( 'Expects exactly 1 argument' );
    this.elements = elements;
    Object.freeze( this );
    return this;
  }

  _.class.declareBasic
  ({
    constructor : fo.class,
    iterator,
    equalAre : equalAre_functor( fo ),
    exportString,
    cloneShallow, /* xxx : implement */
    cloneDeep, /* xxx : implement */
  });

  const prototype = fo.class.prototype;
  prop( 'constructor', constructor );
  prop( 'type', 'abstract' );
  prop( 'exec', exec );
  prop( 'exportStructure', exportStructure );

  Object.defineProperty( fo.class, 'length',
  {
    get : lengthGet,
    enumerable : false,
    configurable : false,
  });

  return fo;

  function prop( k, v )
  {
    Object.defineProperty( prototype, k,
    {
      value : v,
      enumerable : false,
      configurable : false,
    });
  }

}

DeclareAbstract.defaults =
{
}

//

function Declare( fo )
{
  fo.parent = fo.parent || _.logic.node.Abstract;

  const type = fo.type;
  const parent = fo.parent;

  fo.class = { [ fo.name ] : function( val )
  {
    return parent.apply( this, arguments );
  }}[ fo.name ];

  const prototype = fo.class.prototype = Object.create( parent.prototype );
  prop( 'constructor', fo.class );
  prop( 'type', type );
  Object.setPrototypeOf( fo.class, parent );

  _.props.extend( prototype, Methods[ type ] );

  return fo;

  function prop( k, v )
  {
    Object.defineProperty( prototype, k,
    {
      value : v,
      enumerable : false,
      configurable : false,
    });
  }

}

Declare.defaults =
{
  name : null,
  parent : null,
}

// --
//
// --

let Methods =
{

  or :
  {
    _exec : _orExec,
  },
  and :
  {
    _exec : _andExec,
  },
  xor :
  {
    _exec : _xorExec,
  },
  xand :
  {
    _exec : _xandExec,
  },
  if :
  {
    _exec : _ifExec,
  },

  first :
  {
    _exec : _firstExec,
  },
  second :
  {
    _exec : _secondExec,
  },
  not :
  {
    _exec : _notExec,
  },

}

// --
//
// --

var Extension =
{

  DeclareAbstract,
  Declare,

}

Object.assign( _.logic.node, Extension );

_.logic.node.Abstract = _.logic.node.DeclareAbstract({}).class;
_.logic.node.Or = _.logic.node.Declare({ type : 'or', name : 'LogicOr' }).class;
_.logic.node.And = _.logic.node.Declare({ type : 'and', name : 'LogicAnd' }).class;
_.logic.node.Xor = _.logic.node.Declare({ type : 'xor', name : 'LogicXor' }).class;
_.logic.node.Xand = _.logic.node.Declare({ type : 'xand', name : 'LogicXand' }).class;
_.logic.node.First = _.logic.node.Declare({ type : 'first', name : 'LogicFirst' }).class;
_.logic.node.Second = _.logic.node.Declare({ type : 'second', name : 'LogicSecond' }).class;
_.logic.node.Not = _.logic.node.Declare({ type : 'not', name : 'LogicNot' }).class;
_.logic.node.If = _.logic.node.Declare({ type : 'if', name : 'LogicIf' }).class;

})();

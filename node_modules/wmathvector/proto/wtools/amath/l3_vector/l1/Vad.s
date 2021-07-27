(function _Vad_s_() {

'use strict';

const _ = _global_.wTools;

// --
// class
// --

const Self = VectorAdapter;
function VectorAdapter()
{
  throw _.err( 'should not be called' )
};

Self.prototype = Object.create( null );
Self.prototype._vectorBuffer = null;
_.VectorAdapter = Self;

//

function _metaDefine( how, key, value )
{
  let opts =
  {
    enumerable : false,
    configurable : false,
  }

  if( how === 'get' )
  {
    opts.get = value;
    Object.defineProperty( Self.prototype, key, opts );
  }
  else if( how === 'field' )
  {
    opts.value = value;
    Object.defineProperty( Self.prototype, key, opts );
  }
  else if( how === 'static' )
  {
    opts.get = value;
    Object.defineProperty( Self, key, opts );
    Object.defineProperty( Self.prototype, key, opts );
  }
  else _.assert( 0 );

}

//

function _iterate()
{

  let iterator = Object.create( null );
  iterator.next = next;
  iterator.index = 0;
  iterator.vector = this;
  return iterator;

  function next()
  {
    let result = Object.create( null );
    result.done = this.index === this.vector.length;
    if( result.done )
    return result;
    result.value = this.vector.eGet( this.index );
    this.index += 1;
    return result;
  }

}

//

function _toStringTag()
{
  return 'VectorAdapter';
}

//

function _toPrimitive( hint )
{
  return this.toStr();
}

//

function _inspectCustom()
{
  return this.toStr();
}

//

_metaDefine( 'field', Symbol.iterator, _iterate );
_metaDefine( 'get', Symbol.toStringTag, _toStringTag );
_metaDefine( 'field', Symbol.toPrimitive, _toPrimitive );
_metaDefine( 'field', Symbol.for( 'nodejs.util.inspect.custom' ), _inspectCustom );
// _metaDefine( 'field', Symbol.for( 'notLong' ), true );

// --
// declare
// --

let AdapterClassExtension =
{
  vectorAdapter : _.vectorAdapter,
}

/* _.props.extend */Object.assign( _.VectorAdapter, AdapterClassExtension );
/* _.props.extend */Object.assign( _.VectorAdapter.prototype, AdapterClassExtension );

})();

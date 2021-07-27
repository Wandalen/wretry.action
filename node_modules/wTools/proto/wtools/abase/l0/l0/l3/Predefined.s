( function _Predefined_s_()
{

'use strict';

// global

const _global = _global_;

// verification

if( _global_.__GLOBAL_NAME__ === 'real' )
{
  if( _global_.wTools && _global_.wTools.Module )
  {
    debugger;
    throw new Error( 'module::wTools was included several times' );
  }
}

// setup current global namespace

if( !_global.__GLOBAL_NAME__ )
throw Error( 'Current global does not have name. Something wrong!' );

const Self = _global.wTools;
let _ = Self;
Self.__GLOBAL_NAME__ = _global.__GLOBAL_NAME__;
Self.tools = Self;

// name conflict

// if( _global_.__GLOBAL_NAME__ === 'real' )
// if( _global_._ )
// {
//   _global_.Underscore = _global_._;
//   delete _global_._;
// }

// special tokens

Self.def = Symbol.for( 'def' );
Self.null = Symbol.for( 'null' );
Self.undefined = Symbol.for( 'undefined' );
Self.void = Symbol.for( 'void' );
Self.nothing = Symbol.for( 'nothing' );
Self.anything = Symbol.for( 'anything' );
Self.maybe = Symbol.for( 'maybe' );
Self.unknown = Symbol.for( 'unknown' );
Self.dont = Symbol.for( 'dont' );
// Self.unroll = Symbol.for( 'unroll' ); /* xxx : qqq : ask */
Self.self = Symbol.for( 'self' );
Self.optional = Symbol.for( 'optional' );

// type aliases

_realGlobal_.U64x = BigUint64Array;
_realGlobal_.U32x = Uint32Array;
_realGlobal_.U16x = Uint16Array;
_realGlobal_.U8x = Uint8Array;
_realGlobal_.U8xClamped = Uint8ClampedArray;
_realGlobal_.Ux = _realGlobal_.U32x;

_realGlobal_.I64x = BigInt64Array;
_realGlobal_.I32x = Int32Array;
_realGlobal_.I16x = Int16Array;
_realGlobal_.I8x = Int8Array;
_realGlobal_.Ix = _realGlobal_.I32x;

_realGlobal_.F64x = Float64Array;
_realGlobal_.F32x = Float32Array;
_realGlobal_.Fx = _realGlobal_.F32x;

if( typeof Buffer !== 'undefined' )
_realGlobal_.BufferNode = Buffer;
_realGlobal_.BufferRaw = ArrayBuffer;
if( typeof SharedArrayBuffer !== 'undefined' )
_realGlobal_.BufferRawShared = SharedArrayBuffer;
_realGlobal_.BufferView = DataView;

_realGlobal_.HashMap = Map;
_realGlobal_.HashMapWeak = WeakMap;

// --
// export
// --

// _global[ 'wTools' ] = Self;
_global.wTools = Self;
// _global.wBase = Self;

// if( typeof module !== 'undefined' )
// module[ 'exports' ] = Self;

})();

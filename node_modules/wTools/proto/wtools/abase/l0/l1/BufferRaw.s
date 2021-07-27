( function _l1_BufferRaw_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.bufferRaw = _.bufferRaw || Object.create( null );

// --
// implementation
// --

function rawIs( src )
{
  let type = Object.prototype.toString.call( src );
  // let result = type === '[object ArrayBuffer]';
  // return result;
  if( type === '[object ArrayBuffer]' || type === '[object SharedArrayBuffer]' )
  return true;
  return false;
}

// --
// declaration
// --

let BufferRawExtension =
{

  //

  NamespaceName : 'bufferRaw',
  NamespaceNames : [ 'bufferRaw' ],
  NamespaceQname : 'wTools/bufferRaw',
  TypeName : 'BufferRaw',
  TypeNames : [ 'BufferRaw', 'ArrayBuffer' ],
  // SecondTypeName : 'ArrayRaw',
  InstanceConstructor : ArrayBuffer,
  tools : _,

  // dichotomy

  rawIs,
  is : rawIs,
  like : rawIs,

  // maker

  _make : _.buffer._make, /* qqq : cover */
  make : _.buffer.make,
  _makeEmpty : _.buffer._makeEmpty,
  makeEmpty : _.buffer.makeEmpty,
  _makeUndefined : _.buffer._makeUndefined, /* qqq : implement */
  makeUndefined : _.buffer.makeUndefined,
  // _makeZeroed : _.buffer._makeZeroed,
  // makeZeroed : _.buffer.makeZeroed, /* qqq : for junior : cover */
  // _cloneShallow : _.buffer._cloneShallow,
  // cloneShallow : _.buffer.cloneShallow, /* qqq : for junior : cover */
  // from : _.buffer.from, /* qqq : for junior : cover */
  // qqq : implement

}

Object.assign( _.bufferRaw, BufferRawExtension );

//

let BufferExtension =
{

  // dichotomy

  rawIs : rawIs.bind( _.buffer ),

}

Object.assign( _.buffer, BufferExtension );

//

let ToolsExtension =
{

  // dichotomy

  bufferRawIs : rawIs.bind( _.buffer ),

}

//

Object.assign( _, ToolsExtension );

})();

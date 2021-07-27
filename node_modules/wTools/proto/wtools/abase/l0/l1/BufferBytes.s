( function _l1_BufferBytes_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.assert( _.bufferBytes === undefined );
_.assert( _.u8x === undefined );
_.bufferBytes = _.u8x = _.bufferBytes || _.u8x || Object.create( null );

// --
// implementation
// --

function is( src )
{
  if( _.buffer.nodeIs( src ) )
  return false;
  return src instanceof U8x;
}

// --
// declaration
// --

let BufferBytesExtension =
{

  //

  NamespaceName : 'u8x',
  NamespaceNames : [ 'u8x', 'bufferBytes' ],
  NamespaceQname : 'wTools/u8x',
  TypeName : 'U8x',
  TypeNames : [ 'U8x', 'Uint8Array', 'BufferBytes',  ],
  InstanceConstructor : U8x,
  tools : _,

  // dichotomy

  // bytesIs,
  is,
  like : is,

  // maker

  // _make : _.buffer._make, /* qqq : cover */
  // make : _.buffer.make,
  // _makeEmpty : _.buffer._makeEmpty,
  // makeEmpty : _.buffer.makeEmpty,
  // _makeUndefined : _.buffer._makeUndefined, /* qqq : implement */
  // makeUndefined : _.buffer.makeUndefined,
  // _makeZeroed : _.buffer._makeZeroed,
  // makeZeroed : _.buffer.makeZeroed, /* qqq : for junior : cover */
  // _cloneShallow : _.buffer._cloneShallow,
  // cloneShallow : _.buffer.cloneShallow, /* qqq : for junior : cover */
  // from : _.buffer.from, /* qqq : for junior : cover */
  // qqq : implement

}

Object.assign( _.bufferBytes, BufferBytesExtension );

//

let BufferExtension =
{

  // dichotomy

  bytesIs : is.bind( _.bufferBytes ),

}

Object.assign( _.buffer, BufferExtension );

//

let ToolsExtension =
{

  // dichotomy

  bufferBytesIs : is.bind( _.bufferBytes ),
  bufferBytesLike : is.bind( _.bufferBytes ),

}

Object.assign( _, ToolsExtension );

})();

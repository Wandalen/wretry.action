( function _l1_BufferNode_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.bufferNode = _.bufferNode || Object.create( null );

// --
// implementation
// --

/* qqq : for Rahul : write performance test and optimize */
function nodeIs( src )
{
  // if( typeof BufferNode !== 'undefined' )
  if( _global_.BufferNode )
  return src instanceof BufferNode;
  return false;
}

// --
// declaration
// --

let BufferNodeExtension =
{

  //

  NamespaceName : 'bufferNode',
  NamespaceNames : [ 'bufferNode' ],
  NamespaceQname : 'wTools/bufferNode',
  TypeName : 'BufferNode',
  TypeNames : [ 'BufferNode' ],
  // SecondTypeName : 'ArrayNode',
  InstanceConstructor : _global.BufferNode,
  tools : _,

  // dichotomy

  nodeIs,
  is : nodeIs,
  like : nodeIs,

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

Object.assign( _.bufferNode, BufferNodeExtension );

//

let BufferExtension =
{

  // dichotomy

  nodeIs : nodeIs.bind( _.buffer ),

}

Object.assign( _.buffer, BufferExtension );

//

let ToolsExtension =
{

  // dichotomy

  bufferNodeIs : nodeIs.bind( _.buffer ),

}

//

Object.assign( _, ToolsExtension );

})();

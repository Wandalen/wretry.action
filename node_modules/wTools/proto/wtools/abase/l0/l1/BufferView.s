( function _l1_BufferView_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.bufferView = _.bufferView || Object.create( null );

// --
// implementation
// --

function viewIs( src )
{
  let type = Object.prototype.toString.call( src );
  let result = type === '[object DataView]';
  return result;
}

// --
// declaration
// --

let BufferViewExtension =
{

  //

  NamespaceName : 'bufferView',
  NamespaceNames : [ 'bufferView' ],
  NamespaceQname : 'wTools/bufferView',
  TypeName : 'BufferView',
  TypeNames : [ 'BufferView', 'DataView' ],
  // SecondTypeName : 'DataView',
  InstanceConstructor : DataView,
  tools : _,

  // dichotomy

  viewIs,
  is : viewIs,
  like : viewIs,

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

Object.assign( _.bufferView, BufferViewExtension );

//

let BufferExtension =
{

  // dichotomy

  viewIs : viewIs.bind( _.buffer ),

}

Object.assign( _.buffer, BufferExtension );

//

let ToolsExtension =
{

  // dichotomy

  bufferViewIs : viewIs.bind( _.buffer ),

}

//

Object.assign( _, ToolsExtension );

})();

( function _l1_Logic_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.logic = _.logic || Object.create( null );

// --
// logic
// --

function is( src )
{
  if( src === true || src === false || src === _.maybe )
  return true;
  if( !src )
  return false;
  if( src instanceof _.logic.node.Abstract )
  return true;
  return false;
}

//

function like( src )
{
  return this.is( src );
}

//

function isNode( src )
{
  if( src instanceof _.logic.node.Abstract )
  return true;
  return false;
}

// --
// extension
// --

let LogicExtension =
{

  is,
  like,
  isNode

}

Object.assign( _.logic, LogicExtension );

//

let ToolsExtension =
{

  logicIs : is.bind( _.logic ),
  logicLike : like.bind( _.logic ),
  logicIsNode : isNode.bind( _.logic ),

}

Object.assign( _, ToolsExtension );

})();

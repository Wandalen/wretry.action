( function _l3_Logic_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// logic
// --

function _identicalShallow( src1, src2 )
{
  if( src1 === src2 )
  return true;
  return false;
}

//

function identicalShallow( src1, src2, o )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !this.like( src1 ) )
  return false;
  if( !this.like( src2 ) )
  return false;
  return this._identicalShallow( src1, src2 );
}

//

function _equivalentShallow( src1, src2 )
{
  if
  (
    src1 === src2
  )
  return true;
  return false;
}

//

function equivalentShallow( src1, src2, o )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !this.like( src1 ) )
  return false;
  if( !this.like( src2 ) )
  return false;
  return this._equivalentShallow( src1, src2 );
}

//

function or( elements )
{
  return new _.logic.node.Or( ... arguments );
}

//

function and( elements )
{
  return new _.logic.node.And( ... arguments );
}

//

function xor( elements )
{
  return new _.logic.node.Xor( ... arguments );
}

//

function xand( elements )
{
  return new _.logic.node.Xand( ... arguments );
}

//

function _if( elements )
{
  return _.logic.node.If( ... arguments );
}

//

function first( elements )
{
  return new _.logic.node.First( ... arguments );
}

//

function second( elements )
{
  return new _.logic.node.Second( ... arguments );
}

//

function not( elements )
{
  return new _.logic.node.Not( ... arguments );
}

//

function exec( logic, ... args )
{
  return logic.exec( ... args );
}

// --
// logic extension
// --

let LogicExtension =
{

  // equaler

  _identicalShallow,
  identicalShallow,
  identical : identicalShallow,
  _equivalentShallow,
  equivalentShallow,
  equivalent : equivalentShallow,

  //

  and,
  or,
  xor,
  xand,
  first,
  second,
  not,
  if : _if,

  //

  exec,

}

Object.assign( _.logic, LogicExtension );

// --
// tools extension
// --

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

})();

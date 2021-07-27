( function _l1_ContainerAdapter_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// exporter
// --

// function is( src )
// {
//   if( !src )
//   return false;
//   return src instanceof ContainerAdapterAbstract;
// }

//

function is( src )
{
  // if( _.primitive.is( src ) )
  // return false;
  if( !src )
  return false;
  if( !_.containerAdapter.Abstract )
  return false;
  return src instanceof _.containerAdapter.Abstract;
}

//

function like( src )
{
  return this.is( src );
}

//

function isContainer( src )
{
  if( _.set.like( src ) )
  return true;
  if( _.long.like( src ) )
  return true;
  if( _.containerAdapter.is( src ) )
  return true;
  return false;
}

//

// function adapterLike( src )
function setLike( src )
{
  if( !src )
  return false;
  if( _.set.like( src ) )
  return true;
  if( !_.containerAdapter || !_.containerAdapter.Set )
  return false;
  if( src instanceof _.containerAdapter.Set )
  return true;
  return false;
}

//

function longLike( src )
{
  if( !src )
  return false;
  if( _.long.like( src ) )
  return true;
  if( !_.containerAdapter || !_.containerAdapter.Array )
  return false;
  if( src instanceof _.containerAdapter.Array )
  return true;
  return false;
}

// --
//
// --

class ContainerAdapterNamespace
{
  static[ Symbol.hasInstance ]( instance )
  {
    return is( instance );
  }
}

let Handler =
{
  construct( original, args )
  {
    return ContainerAdapterNamespace.make( ... args );
  }
};

const Self = new Proxy( ContainerAdapterNamespace, Handler );
Self.original = ContainerAdapterNamespace;
_.assert( _.containerAdapter === undefined );
_.containerAdapter = Self;

// --
// container adapter extension
// --

let ContainerAdapterExtension =
{

  is,
  like,
  isContainer,
  setLike,
  longLike,

}

Object.assign( _.containerAdapter, ContainerAdapterExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  is : is.bind( _.containerAdapter ),
  like : like.bind( _.containerAdapter ),

}

Object.assign( _, ToolsExtension );

})();

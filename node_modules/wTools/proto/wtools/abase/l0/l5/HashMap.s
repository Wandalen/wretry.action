( function _l5_HashMap_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function extend( dst, src )
{
  _.assert( arguments.length === 2 );
  _.assert( dst === null || _.hashMap.like( dst ) || _.aux.is( dst ) );
  _.assert( _.hashMapLike( src ) || _.aux.is( src ) );

  if( dst === null )
  dst = new HashMap;

  if( dst === src )
  return dst;

  if( _.hashMap.like( dst ) )
  {
    if( _.hashMapLike( src ) )
    {
      for( let [ k, e ] of src )
      dst.set( k, e );
    }
    else
    {
      for( let k in src )
      {
        dst.set( k, src[ k ] );
      }
    }
  }
  else
  {
    if( _.hashMap.like( src ) )
    {
      for( let [ k, e ] of src )
      {
        _.assert( _.strIs( k ) );
        dst[ k ] = e;
      }
    }
    else
    {
      for( let k in src )
      {
        dst[ k ] = src[ k ];
      }
    }
  }

  return dst;
}

// //
//
// function fromMap( dstMap, srcMap )
// {
//   if( arguments.length === 1 )
//   {
//     srcMap = arguments[ 0 ];
//     dstMap = null;
//   }
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( !_.primitive.is( srcMap ) );
//   _.assert( dstMap === null || _.hashMapIs( dstMap ) );
//
//   if( dstMap === null )
//   dstMap = new HashMap;
//
//   for( let k in srcMap )
//   {
//     dstMap.set( k, srcMap[ k ] );
//   }
//
//   return dstMap;
// }

// --
// extension
// --

let ToolsExtension =
{
  hashMapExtend : extend,
}

//

let Extension =
{

  extend, /* qqq : cover */
  // fromMap, /* qqq : cover */

}

Object.assign( _, ToolsExtension );
Object.assign( _.hashMap, Extension );

})();

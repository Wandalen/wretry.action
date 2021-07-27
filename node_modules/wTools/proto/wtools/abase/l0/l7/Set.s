( function _l7_Set_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

// function adapterLike( src )
// {
//   if( !src )
//   return false;
//   if( _.set.like( src ) )
//   return true;
//   if( !_.containerAdapter || _.containerAdapter.Set )
//   return false;
//   if( src instanceof _.containerAdapter.Set )
//   return true;
//   return false;
// }

// --
// extension
// --

let ToolsExtension =
{

  // setAdapterLike : adapterLike,

}

Object.assign( _, ToolsExtension );

//

let SetExtension =
{

  // adapterLike, /* xxx : move out */

}

Object.assign( _.set, SetExtension );

//

let SetsExtension =
{

}

//

Object.assign( _.set.s, SetsExtension );

})();

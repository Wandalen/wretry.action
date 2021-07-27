( function _l7_Pair_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function isOf( src, Element )
{
  if( !Element )
  return false;
  if( !this.is( src ) )
  return false;
  return src[ 0 ] instanceof Element && src[ 1 ] instanceof Element;
}

//

var Extension =
{
  isOf,
}

//

_.assert( _.pair !== undefined );
_.props.supplement( _.pair, Extension );

})();

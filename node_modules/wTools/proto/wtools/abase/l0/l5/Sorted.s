( function _l5_Sorted_s_()
{

'use strict';

//

const _global = _global_;
const _ = _global_.wTools;
_.sorted = _.sorted || Object.create( null );

// --
// implementation
// --

function searchFirstIndex( srcArr, ins )
{
  let l = 0;
  let r = srcArr.length;
  let m;
  if( srcArr.length )

  do
  {
    m = Math.floor( ( l + r ) / 2 );
    if( srcArr[ m ] < ins )
    l = m+1;
    else if( srcArr[ m ] > ins )
    r = m;
    else
    return m;
  }
  while( l < r );
  if( srcArr[ m ] < ins )
  return m+1;

  return m;
}

// --
// extension
// --

let Extension =
{

  searchFirstIndex,
  // searchFirst,

}

_.props.supplement( _.sorted, Extension );

})();

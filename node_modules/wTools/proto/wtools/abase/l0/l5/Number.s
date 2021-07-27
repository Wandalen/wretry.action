( function _l5_Numbers_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// number
// --

function clamp( src, low, high )
{
  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );
  _.assert( _.number.is( src ) );

  if( arguments.length === 2 )
  {
    _.assert( arguments[ 1 ].length === 2 );
    low = arguments[ 1 ][ 0 ];
    high = arguments[ 1 ][ 1 ];
  }

  if( src > high )
  return high;

  if( src < low )
  return low;

  return src;
}

//

function mix( ins1, ins2, progress )
{
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  return ins1*( 1-progress ) + ins2*( progress );
}

// --
// extension
// --

/*
zzz : review and merge with similar routines _.range.*
*/

let ToolsExtension =
{

  numberClamp : clamp, /* teach it to accept cintervals */
  numberMix : mix,

}

Object.assign( _, ToolsExtension );

//

let NumberExtension =
{

  clamp,
  mix,

}

Object.assign( _.number, NumberExtension );

})();

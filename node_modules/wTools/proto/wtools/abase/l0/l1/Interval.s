( function _l1_Interval_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _global_.wTools;

// --
// range
// --

function intervalIs( range )
{
  _.assert( arguments.length === 1 );
  if( !_.number.s.areAll( range ) )
  return false;
  if( range.length !== 2 )
  return false;
  return true;
}

//

function intervalIsValid( range )
{
  _.assert( arguments.length === 1 );
  if( !_.intervalIs( range ) )
  return false;
  if( !_.intIs( range[ 0 ] ) )
  return false;
  if( !_.intIs( range[ 1 ] ) )
  return false;
  return true;
}

// --
// implementation
// --

let ToolsExtension =
{

  /* zzz : review and rearrange */

  // range

  intervalIs,
  intervalIsValid, /* xxx : remove later */
  intervalDefined : intervalIsValid, /* xxx : remove later */

}

//

Object.assign( _, ToolsExtension );

})();

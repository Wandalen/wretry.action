( function _Namespace_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.files = _.files || Object.create( null );

// --
// implementation
// --

// --
// meta
// --

function _Setup()
{

  if( !_.fileProvider )
  _.FileProvider.Default.MakeDefault();

  _.path.currentAtBegin = _.path.current();

}

// --
// declaration
// --

let Extension =
{

  // meta

  _Setup,

}

_.props.supplement( _.files, Extension );

_.files._Setup();

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

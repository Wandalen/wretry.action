( function _l5_Diagnostic_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.diagnostic = _.diagnostic || Object.create( null );

// --
// diagnostic
// --

// --
// try
// --

function tryCatch( routine )
{
  _.assert( arguments.length === 1 );
  _.assert( _.routine.is( routine ) )
  try
  {
    return routine();
  }
  catch( err )
  {
    throw _._err({ args : [ err ] });
  }
}

//

function tryCatchBrief( routine )
{
  _.assert( arguments.length === 1 );
  _.assert( _.routine.is( routine ) )

  try
  {
    return routine();
  }
  catch( err )
  {
    throw _._err({ args : [ err ], brief : 1 });
  }
}

// //
//
// function tryCatchDebug( routine )
// {
//   _.assert( arguments.length === 1 );
//   _.assert( _.routine.is( routine ) )
//   try
//   {
//     return routine();
//   }
//   catch( err )
//   {
//     throw _._err({ args : [ err ], debugging : 1 });
//   }
// }

// --
// declare
// --

let ToolsExtension =
{

  tryCatch,
  tryCatchBrief,

}

Object.assign( _, ToolsExtension );

//

let Extension =
{

}

//

Object.assign( Self, Extension );

})();

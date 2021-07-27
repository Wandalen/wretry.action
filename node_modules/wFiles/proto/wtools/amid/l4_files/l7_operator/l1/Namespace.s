( function _Namespace_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.files.operator = _.files.operator || Object.create( null );

// --
//
// --

function includeIs( src )
{
  return src instanceof _.files.operator.FileUsage;
  // if( !_.map.is( src ) )
  // return false;
  // if( !src.file )
  // return false;
  // if( !src.deed )
  // return false;
  // return true;
}

// --
//
// --

/**
 * @namespace wTools.files.operator
 * @module Tools/mid/Files
 */

let OperatorExtension =
{

  includeIs,

}

/* _.props.extend */Object.assign( _.files.operator, OperatorExtension );

})();

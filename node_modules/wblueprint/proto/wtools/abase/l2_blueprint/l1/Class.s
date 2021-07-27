( function _Class_s_()
{

'use strict';

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

/**
 * @namespace Tools.class
 * @module Tools/base/Proto
 */

//

function isSubClassOf( subCls, cls )
{

  _.assert( _.routineIs( cls ) );
  _.assert( _.routineIs( subCls ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( cls === subCls )
  return true;

  return Object.isPrototypeOf.call( cls.prototype, subCls.prototype );
}

// --
// define
// --

let ClassExtension =
{

  isSubClassOf,

}

_.class = _.class || Object.create( null );
/* _.props.extend */Object.assign( _.class, ClassExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

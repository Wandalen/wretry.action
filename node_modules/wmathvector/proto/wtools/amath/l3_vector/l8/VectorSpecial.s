(function _VectorSpecial_s_() {

'use strict';

const _ = _global_.wTools;
const meta = _.vectorAdapter._meta;

// --
//
// --

function toStr( src )
{

  _.assert( _.vectorIs( src ) );
  _.assert( arguments.length === 1, 'not tested' );

  if( _.vadIs( src ) )
  return src.toStr();

  return _.entity.exportString( src );
}

// --
// declare
// --

let Extension =
{

  toStr,

}

/* _.props.extend */Object.assign( _.vector, Extension );

// --
// declare
// --

_.assert( _.routineIs( _.vector.toStr ) );

})();

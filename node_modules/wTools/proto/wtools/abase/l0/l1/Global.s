( function _l1_Global_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const __ = _realGlobal_.wTools;
const Self = _.global = _.global || Object.create( null );

// --
// implementation
// --

/* xxx : qqq : for junior : dicuss tests */
function is( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.primitive.is( src ) )
  return false;

  // if( src === _global_ )
  // return true;

  if( _.prototype.has( src, _global_ ) )
  return true;

  return false;
}

//

function isReal( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  // if( _.primitive.is( src ) )
  // return false;

  if( src === _realGlobal_ )
  return true;
  return false;
}

//

function isDerivative( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  // if( _.primitive.is( src ) )
  // return false;

  if( _.global.is( src ) && !_.global.isReal( src ) )
  return true;
  return false;
}

// --
// extension
// --

var Extension =
{

  is,
  isReal,
  isDerivative,

  get : __.global.get,
  new : __.global.new,
  open : __.global.open,
  close : __.global.close,
  openForChildren : __.global.openForChildren,
  closeForChildren : __.global.closeForChildren,
  setup : __.global.setup,

  _stack : __.global._stack,

}

//

Object.assign( _.global, Extension );

})();

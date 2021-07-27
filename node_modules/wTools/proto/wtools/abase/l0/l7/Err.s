( function _l7_Err_s_()
{

'use strict';

const _global = _global_;
const _ = _global.wTools;
const _err = _._err;

// --
// dichotomy
// --

function _isInstanceOrClass( _constructor, _this )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  debugger;
  let result =
  (
    _this === _constructor
    || _this instanceof _constructor
    || Object.isPrototypeOf.call( _constructor, _this )
    || Object.isPrototypeOf.call( _constructor, _this.prototype )
  );
  return result;
}

// //
//
// function _ownNoConstructor( ins )
// {
//   _.assert( !_.primitive.is( ins ) );
//   _.assert( arguments.length === 1 );
//   let result = !Object.hasOwnProperty.call( ins, 'constructor' );
//   return result;
// }

//

function sureInstanceOrClass( _constructor, _this )
{
  _.sure( arguments.length === 2, 'Expects exactly two arguments' );
  _.sure( _._isInstanceOrClass( _constructor, _this ) );
}

//

function sureOwnNoConstructor( ins )
{
  _.sure( !_.primitive.is( ins ) );
  let args = Array.prototype.slice.call( arguments );
  args[ 0 ] = !Object.hasOwnProperty.call( ins, 'constructor' );
  _.sure.apply( _, args );
}

//

function assertInstanceOrClass( _constructor, _this )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _._isInstanceOrClass( _constructor, _this ) );
}

//

function assertOwnNoConstructor( ins )
{
  _.assert( !_.primitive.is( ins ) );
  let args = Array.prototype.slice.call( arguments );
  args[ 0 ] = !Object.hasOwnProperty.call( ins, 'constructor' );
  _.assert.apply( _, args );
  // _.assert( !_.primitive.is( ins ) );
  // let args = Array.prototype.slice.call( arguments );
  // args[ 0 ] = _.sureOwnNoConstructor( ins );
  //
  // if( args.length === 1 )
  // args.push( () => 'Entity should not own constructor, but own ' + _.entity.exportStringDiagnosticShallow( ins ) );
  //
  // _.assert.apply( _, args );
}

// --
// errrors
// --

let ErrorAbort = _.error.error_functor( 'ErrorAbort' );

// --
// declare
// --

/* zzz : move into independent module or namespace */

let ErrorExtension =
{
  ErrorAbort,
}

let ToolsExtension =
{

  // dichotomy

  _isInstanceOrClass,
  // _ownNoConstructor,

  // sure

  sureInstanceOrClass,
  sureOwnNoConstructor,

  // assert

  assertInstanceOrClass,
  assertOwnNoConstructor,

}

Object.assign( _.error, ErrorExtension );
Object.assign( _, ToolsExtension );

})();

( function _l1_Printer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.printer = _.printer || Object.create( null );

// --
// printer
// --

function is( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !src )
  return false;

  if( _.routine.is( src ) )
  return false;

  let prototype = Object.getPrototypeOf( src );
  if( !prototype )
  return false;

  if( src.MetaType === 'Printer' )
  return true;

  return false;
}

//

function like( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.printer.is( src ) )
  return true;

  if( _.consoleIs( src ) )
  return true;

  if( src === _global_.logger )
  return true;

  return false;
}

// --
// extension
// --

let ToolsExtension =
{
  printerIs : is,
  printerLike : like,
}

//

let Extension =
{
  is,
  like,
}

Object.assign( _.printer, Extension );
Object.assign( _, ToolsExtension );

})();

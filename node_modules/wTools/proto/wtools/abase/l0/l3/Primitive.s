( function _l3_Primitive_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// primitive
// --

function _identicalShallow( src1, src2 )
{

  if( !_.primitive.is( src1 ) )
  return false;
  if( !_.primitive.is( src2 ) )
  return false;

  return Object.is( src1, src2 );
}

//

function identicalShallow( src1, src2, o )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( !this.like( src1 ) )
  return false;
  if( !this.like( src2 ) )
  return false;

  return this._identicalShallow( ... arguments );
}

//

function _equivalentShallow( src1, src2, accuracy )
{

  if( _.strsAreAll([ src1, src2 ]) )
  return _.str.equivalentShallow( src1, src2 );

  if( _.bool.like( src1 ) && _.bool.like( src2 ) )
  return _.bool.equivalentShallow( src1, src2 );

  if
  (
    ( _.number.is( src1 ) || _.bigInt.is( src1 ) )
    && ( _.number.is( src2 ) || _.bigInt.is( src2 ) )
  )
  return _.number.equivalentShallow( src1, src2, accuracy );

  return Object.is( src1, src2 );
}

//

function equivalentShallow( src1, src2, accuracy )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !this.like( src1 ) )
  return false;
  if( !this.like( src2 ) )
  return false;
  return this._equivalentShallow( ... arguments );
}

// --
//
// --

function exportStringCodeShallow( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( _.primitive.is( src ) );

  if( _.symbol.is( src ) )
  return _.symbol.exportStringCodeShallow( src );

  if( _.bigInt.is( src ) )
  return _.bigInt.exportStringCodeShallow( src );

  if( _.strIs( src ) )
  return `'${src}'`;

  return String( src );
}

//

function exportStringDiagnosticShallow( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( _.primitive.is( src ) );

  if( _.symbol.is( src ) )
  return _.symbol.exportStringDiagnosticShallow( src );

  if( _.bigInt.is( src ) )
  return _.bigInt.exportStringDiagnosticShallow( src );

  return String( src );
}

// --
// extension
// --

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

//

let PrimitiveExtension =
{

  // equaler

  _identicalShallow,
  identicalShallow,
  identical : identicalShallow,
  _equivalentShallow,
  equivalentShallow,
  equivalent : equivalentShallow,

  // exporter

  exportStringCodeShallow,
  exportStringDiagnosticShallow,
  exportString : exportStringDiagnosticShallow,

}

Object.assign( _.primitive, PrimitiveExtension );

})();

( function _l1_Symbol_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.symbol = _.symbol || Object.create( null );

// --
// symbol
// --

function is( src )
{
  let result = Object.prototype.toString.call( src ) === '[object Symbol]';
  return result;
}

//

function exportStringCodeShallow( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( _.symbol.is( src ) );

  let text = src.toString().slice( 7, -1 );
  let result = `Symbol.for(${text ? ' \'' + text + '\' )' : ')'}`;
  return result;
}

//

function exportStringDiagnosticShallow( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( _.symbol.is( src ) );

  let text = src.toString().slice( 7, -1 );
  let result = `{- Symbol${text ? ' ' + text + ' ' : ' '}-}`;
  return result;
}

// --
// extension
// --

let ToolsExtension =
{
  symbolIs : is
}

//

let Extension =
{

  // dichotomy

  is,

  // exporter

  exportString : exportStringDiagnosticShallow,
  // exportStringDiagnosticShallow : exportStringDiagnosticShallow,
  exportStringCodeShallow,
  exportStringDiagnosticShallow,
  // exportStringDiagnostic : exportStringDiagnosticShallow,
  // exportStringCode : exportStringCodeShallow,

  // symbols

  def : Symbol.for( 'def' ),
  null : Symbol.for( 'null' ),
  undefined : Symbol.for( 'undefined' ),
  void : Symbol.for( 'void' ),
  nothing : Symbol.for( 'nothing' ),
  anything : Symbol.for( 'anything' ),
  maybe : Symbol.for( 'maybe' ),
  unknown : Symbol.for( 'unknown' ),
  dont : Symbol.for( 'dont' ),
  self : Symbol.for( 'self' ),
  optional : Symbol.for( 'optional' ),

  unroll : Symbol.for( 'unroll' ),
  prototype : Symbol.for( 'prototype' ),
  constructor : Symbol.for( 'constructor' ),

}

Object.assign( _, ToolsExtension );
Object.assign( Self, Extension );

})();

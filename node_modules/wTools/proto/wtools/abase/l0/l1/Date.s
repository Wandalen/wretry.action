( function _l1_Date_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.date = _.date || Object.create( null );

// --
// dichotomy
// --

function is( src )
{
  return Object.prototype.toString.call( src ) === '[object Date]';
}

//

function identicalShallow( src1, src2, o )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );


  if( !_.date.is( src1 ) )
  return false;
  if( !_.date.is( src2 ) )
  return false;

  return _.date._identicalShallow( src1, src2 );
}

//

function _identicalShallow( src1, src2 )
{
  src1 = src1.getTime();
  src2 = src2.getTime();

  return src1 === src2;
}

//

function exportStringDiagnosticShallow( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( _.date.is( src ) );

  return src.toISOString();
}

//

function exportStringCodeShallow( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( _.date.is( src ) );

  return `new Date( '${src.toISOString()}' )`;
}

// --
// extension
// --

let ToolsExtension =
{
  dateIs : is,
  datesAreIdentical : identicalShallow,
}

//

let Extension =
{
  is,
  identicalShallow,
  _identicalShallow,
  areIdentical : identicalShallow,
  equivalentShallow : identicalShallow,

  // exporter

  exportString : exportStringDiagnosticShallow,
  // exportStringDiagnosticShallow : exportStringDiagnosticShallow,
  exportStringCodeShallow,
  exportStringDiagnosticShallow,
  // exportStringDiagnostic : exportStringDiagnosticShallow,
  // exportStringCode : exportStringCodeShallow
}

//

Object.assign( _, ToolsExtension );
Object.assign( _.date, Extension );

})();

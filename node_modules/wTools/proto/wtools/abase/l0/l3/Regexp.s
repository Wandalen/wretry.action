( function _l3_Regexp_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// regexp
// --

function _identicalShallow( src1, src2 )
{
  return src1.source === src2.source && src1.flags === src2.flags;
}

//

function identicalShallow( src1, src2, o )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !_.regexp.is( src1 ) || !_.regexp.is( src2 ) )
  return false;
  return _.regexp._identicalShallow( src1, src2 );
}

//

function _equivalentShallow( src1, src2 )
{
  let strIs1 = _.strIs( src1 );
  let strIs2 = _.strIs( src2 );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( !strIs1 && strIs2 )
  return _.regexp._equivalentShallow( src2, src1 );

  _.assert( _.regexpLike( src1 ), 'Expects string-like ( string or regexp )' );
  _.assert( _.regexpLike( src1 ), 'Expects string-like ( string or regexp )' );

  if( strIs1 && strIs2 )
  {
    return src1 === src2;
    // if( src1 === src2 )
    // return true;
    // return _.str.lines.strip( src1 ) === _.str.lines.strip( src2 );
  }
  else if( strIs1 )
  {
    _.assert( !!src2.exec );
    let matched = src2.exec( src1 );
    if( !matched )
    return false;
    if( matched[ 0 ].length !== src1.length )
    return false;
    return true;
  }
  else
  {
    return _.regexp.identical( src1, src2 );
  }

  return false;
}

//

function equivalentShallow( src1, src2 )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !_.regexp.like( src1 ) || !_.regexp.like( src2 ) )
  return false;
  return _.regexp._equivalentShallow( src1, src2 );
}

//

function exportStringDiagnosticShallow( src )
{
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( _.regexp.is( src ) );

  return `/${src.source}/${src.flags}`;
}

// --
// extension
// --

let ToolsExtension =
{

  regexpIdentical : identicalShallow,
  regexpEquivalent : equivalentShallow,

}

Object.assign( _, ToolsExtension )

//

let RegexpExtension =
{

  // regexp

  _identicalShallow,
  identicalShallow,
  identical : identicalShallow,
  _equivalentShallow,
  equivalentShallow,
  equivalent : equivalentShallow,

  // exporter

  exportString : exportStringDiagnosticShallow,
  exportStringDiagnosticShallow,
  exportStringCodeShallow : exportStringDiagnosticShallow,

}

Object.assign( _.regexp, RegexpExtension )

//

let RegexpsExtension =
{


}

Object.assign( _.regexp.s, RegexpsExtension )

})();

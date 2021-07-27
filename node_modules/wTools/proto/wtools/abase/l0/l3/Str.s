( function _l3_Str_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// exporter
// --

function _exportStringDiagnosticShallow( src, o )
{
  return src;
}

//

function exportStringDiagnosticShallow( src, o )
{
  let result;
  _.assert( arguments.length === 1 || arguments.length === 2, 'Expects 1 or 2 arguments' );
  _.assert( this.like( src ) );
  return this._exportStringDiagnosticShallow( ... arguments );
}

//

function _exportStringCodeShallow( src, o )
{
  return `'${src}'`;
}

//

function exportStringCodeShallow( src, o )
{
  let result;
  _.assert( arguments.length === 1 || arguments.length === 2, 'Expects 1 or 2 arguments' );
  _.assert( this.like( src ) );
  return this._exportStringCodeShallow( ... arguments );
}

// --
// equaler
// --

function _identicalShallow( src1, src2 )
{
  return src1 === src2;
}

//

function identicalShallow( src1, src2, accuracy )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !this.is( src1 ) )
  return false;
  if( !this.is( src2 ) )
  return false;
  return this._identicalShallow( ... arguments );
}

//

// function _equivalentShallow( src1, src2 )
// {
//   let strIs1 = _.strIs( src1 );
//   let strIs2 = _.strIs( src2 );
//
//   // _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   //
//   // if( !strIs1 && strIs2 )
//   // return this._equivalentShallow( src2, src1 );
//
//   // _.assert( _.regexpLike( src1 ), 'Expects string-like ( string or regexp )' );
//   // _.assert( _.regexpLike( src1 ), 'Expects string-like ( string or regexp )' );
//
//   if( strIs1 && strIs2 )
//   {
//     /* qqq : for junior : bad | aaa : Fixed. */
//     if( src1 === src2 )
//     return true;
//     return _.str.lines.strip( src1 ) === _.str.lines.strip( src2 );
//   }
//   else
//   {
//     return false;
//     // return _.regexpIdentical( src1, src2 );
//   }
//
//   return false;
// }

//
//
// function _equivalentShallow( src1, src2 )
// {
//   let strIs1 = _.strIs( src1 );
//   let strIs2 = _.strIs( src2 );
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   if( !strIs1 && strIs2 )
//   return this._equivalentShallow( src2, src1 );
//
//   _.assert( _.regexpLike( src1 ), 'Expects string-like ( string or regexp )' );
//   _.assert( _.regexpLike( src1 ), 'Expects string-like ( string or regexp )' );
//
//   if( strIs1 && strIs2 )
//   {
//     /* qqq : for junior : bad | aaa : Fixed. */
//     if( src1 === src2 )
//     return true;
//
//     return _.str.lines.strip( src1 ) === _.str.lines.strip( src2 );
//
//   }
//   else if( strIs1 )
//   {
//     _.assert( !!src2.exec );
//     let matched = src2.exec( src1 );
//     if( !matched )
//     return false;
//     if( matched[ 0 ].length !== src1.length )
//     return false;
//     return true;
//   }
//   else
//   {
//     return _.regexpIdentical( src1, src2 );
//   }
//
//   return false;
// }

//

function _equivalentShallow( src1, src2 )
{
  let strIs1 = _.strIs( src1 );
  let strIs2 = _.strIs( src2 );

  if( !strIs1 && strIs2 )
  return this._equivalentShallow( src2, src1 );

  if( strIs1 && strIs2 )
  {
    if( src1 === src2 )
    return true;
    return _.str.lines.strip( src1 ) === _.str.lines.strip( src2 );
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
    return _.regexpIdentical( src1, src2 );
  }

  return false;
}

//

function equivalentShallow( src1, src2, accuracy )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( !_.regexp.like( src1 ) )
  return false;
  if( !_.regexp.like( src2 ) )
  return false;
  return _.str._equivalentShallow( ... arguments );
}

//
// //
//
// function strsEquivalent( src1, src2 )
// {
//
//   _.assert( _.strIs( src1 ) || _.regexpIs( src1 ) || _.longIs( src1 ), 'Expects string/regexp or array of strings/regexps {-src1-}' );
//   _.assert( _.strIs( src2 ) || _.regexpIs( src2 ) || _.longIs( src2 ), 'Expects string/regexp or array of strings/regexps {-src2-}' );
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   let isLong1 = _.longIs( src1 );
//   let isLong2 = _.longIs( src2 );
//
//   if( isLong1 && isLong2 )
//   {
//     let result = [];
//     _.assert( src1.length === src2.length );
//     for( let i = 0, len = src1.length ; i < len; i++ )
//     {
//       result[ i ] = _.str.equivalent( src1[ i ], src2[ i ] );
//     }
//     return result;
//   }
//   else if( !isLong1 && isLong2 )
//   {
//     let result = [];
//     for( let i = 0, len = src2.length ; i < len; i++ )
//     {
//       result[ i ] = _.str.equivalent( src1, src2[ i ] );
//     }
//     return result;
//   }
//   else if( isLong1 && !isLong2 )
//   {
//     let result = [];
//     for( let i = 0, len = src1.length ; i < len; i++ )
//     {
//       result[ i ] = _.str.equivalent( src1[ i ], src2 );
//     }
//     return result;
//   }
//   else
//   {
//     return _.str.equivalent( src1, src2 );
//   }
//
// }

// --
//
// --

/**
  * Prepends string( begin ) to the source( src ) if prefix( begin ) is not match with first chars of string( src ),
  * otherwise returns original string.
  * @param { String } src - Source string to parse.
  * @param { String } begin - String to prepend.
  *
  * @example
  * _.strPrependOnce( 'test', 'test' );
  * // returns 'test'
  *
  * @example
  * _.strPrependOnce( 'abc', 'x' );
  * // returns 'xabc'
  *
  * @returns { String } Returns result of prepending string( begin ) to source( src ) or original string.
  * @function prependOnce
  * @namespace Tools
  */

function prependOnce( src, begin )
{
  _.assert( _.strIs( src ) && _.strIs( begin ), 'Expects {-src-} and {-begin-} as strings' );
  if( src.lastIndexOf( begin, 0 ) === 0 )
  return src;
  else
  return begin + src;
}

//

/**
  * Appends string( end ) to the source( src ) if postfix( end ) is not match with last chars of string( src ),
  * otherwise returns original string.
  * @param {string} src - Source string to parse.
  * @param {string} end - String to append.
  *
  * @example
  * _.strAppendOnce( 'test', 'test' );
  * // returns 'test'
  *
  * @example
  * _.strAppendOnce( 'abc', 'x' );
  * // returns 'abcx'
  *
  * @returns {string} Returns result of appending string( end ) to source( src ) or original string.
  * @function appendOnce
  * @namespace Tools
  */

function appendOnce( src, end )
{
  _.assert( _.strIs( src ) && _.strIs( end ), 'Expects {-src-} and {-end-} as strings' );
  if( src.indexOf( end, src.length - end.length ) === -1 )
  return src + end;
  else
  return src;
}

// --
// str extension
// --

let StrExtension =
{

  // exporter

  _exportStringDiagnosticShallow,
  exportStringDiagnosticShallow,
  _exportStringCodeShallow,
  exportStringCodeShallow,
  exportString : exportStringDiagnosticShallow,

  // equaler

  _identicalShallow,
  identicalShallow,
  identical : identicalShallow,
  _equivalentShallow,
  equivalentShallow,
  equivalent : equivalentShallow,

  prependOnce,
  appendOnce,

}

Object.assign( _.str, StrExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  /* qqq : for Rahul : ask */

  strPrependOnce : prependOnce,
  strAppendOnce : appendOnce,

}

Object.assign( _, ToolsExtension );

})();

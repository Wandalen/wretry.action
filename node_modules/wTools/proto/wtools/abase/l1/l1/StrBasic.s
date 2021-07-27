(function _StrBasic_s_()
{

'use strict';

/*

qqq : write article "strIsolate* difference"

*/

//

const _global = _global_;
const _ = _global_.wTools;

const _ArraySlice = Array.prototype.slice;
const _FunctionBind = Function.prototype.bind;
const _ObjectToString = Object.prototype.toString;
const _ObjectHasOwnProperty = Object.hasOwnProperty;

const _longSlice = _.longSlice;
const strType = _.entity.strType;

// --
// dichotomy
// --

function strIsHex( src )
{
  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1 );
  let parsed = parseInt( src, 16 )
  if( isNaN( parsed ) )
  return false;
  return parsed.toString( 16 ).length === src.length;
}

//

function strIsMultilined( src )
{
  if( !_.strIs( src ) )
  return false;
  if( src.indexOf( '\n' ) !== -1 )
  return true;
  return false;
}

//

function strHasAny( src, ins )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.arrayIs( ins ) )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    if( _.strHas( src, ins[ i ] ) )
    return true;
    return false;
  }

  return _.strHas( src, ins );
}

//

function strHasAll( src, ins )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.arrayIs( ins ) )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    if( !_.strHas( src, ins[ i ] ) )
    return false;
    return true;
  }

  return _.strHas( src, ins );
}

//

function strHasNone( src, ins )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.arrayIs( ins ) )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    if( _.strHas( src, ins[ i ] ) )
    return false;
    return true;
  }

  return !_.strHas( src, ins );
}

//

function strHasSeveral( src, ins )
{
  let result = 0;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.arrayIs( ins ) )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    if( _.strHas( src, ins[ i ] ) )
    result += 1;
    return result;
  }

  return _.strHas( src, ins ) ? 1 : 0;
}

//

function strsAnyHas( srcs, ins )
{
  _.assert( _.strIs( srcs ) || _.strsAreAll( srcs ) );
  _.assert( _.strIs( ins ) );

  if( _.strIs( srcs ) )
  return _.strHas( srcs, ins );

  return srcs.some( ( src ) => _.strHas( src, ins ) );
}

//

function strsAllHas( srcs, ins )
{
  _.assert( _.strIs( srcs ) || _.strsAreAll( srcs ) );
  _.assert( _.strIs( ins ) );

  if( _.strIs( srcs ) )
  return _.strHas( srcs, ins );

  return srcs.every( ( src ) => _.strHas( src, ins ) );
}

//

function strsNoneHas( srcs, ins )
{
  _.assert( _.strIs( srcs ) || _.strsAreAll( srcs ) );
  _.assert( _.strIs( ins ) );

  if( _.strIs( srcs ) )
  return !_.strHas( srcs, ins );

  return srcs.every( ( src ) => !_.strHas( src, ins ) );
}

// --
// evaluator
// --

/**
 * Returns number of occurrences of a substring( ins ) in a string( src ),
 * Expects two objects in order: source string, substring.
 * Returns zero if one of arguments is empty string.
 *
 * @param {string} src - Source string.
 * @param {string} ins - Substring.
 * @returns {Number} Returns number of occurrences of a substring in a string.
 *
 * @example
 * _.strCount( 'aabab', 'ab' );
 * // returns 2
 *
 * @example
 * _.strCount( 'aabab', '' );
 * // returns 0
 *
 * @method strCount
 * @throws { Exception } Throw an exception if( src ) is not a String.
 * @throws { Exception } Throw an exception if( ins ) is not a String.
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 2.
 * @namespace Tools
 *
 */

function strCount( src, ins )
{
  let result = 0;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( src ) );
  _.assert( _.regexpLike( ins ) );

  let i = 0;
  do
  {
    // let found = _.strLeft( src, ins, [ i, src.length ] );
    let found = _.strLeft_( src, ins, [ i, src.length-1 ] );
    if( found.entry === undefined )
    break;
    i = found.index + found.entry.length;
    if( !found.entry.length )
    i += 1;
    result += 1;
    _.assert( i !== -1, 'not tested' );
  }
  while( i !== -1 && i < src.length );

  return result;
}

//

function strStripCount( src, ins )
{
  return _.strCount( _.str.lines.strip( src ), _.str.lines.strip( ins ) );
}

//

function strsShortest( src )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( src ) || _.argumentsArray.like( src ) );
  if( _.strIs( src ) )
  return src;
  return src.sort( ( a, b ) => a.length - b.length )[ 0 ];
}

//

function strsLongest()
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( src ) || _.argumentsArray.like( src ) );
  if( _.strIs( src ) )
  return src;
  return src.sort( ( a, b ) => b.length - a.length )[ 0 ];
}

// --
// replacer
// --

function _strRemoved( srcStr, insStr )
{
  let result = srcStr;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( srcStr ), 'Expects string {-src-}' );

  if( _.longIs( insStr ) )
  {
    for( let i = 0; i < insStr.length; i++ )
    result = result.replace( insStr[ i ], '' );
  }
  else
  {
    result = result.replace( insStr, '' );
  }
  // if( !_.longIs( insStr ) )
  // {
  //   result = result.replace( insStr, '' );
  // }
  // else
  // {
  //   for( let i = 0; i < insStr.length; i++ )
  //   {
  //     result = result.replace( insStr[ i ], '' );
  //   }
  // }

  return result;
}

//

/**
* Finds substring or regexp ( insStr ) first occurrence from the source string ( srcStr ) and removes it.
* Returns original string if source( src ) does not have occurrence of ( insStr ).
*
* @param { String } srcStr - Source string to parse.
* @param { String } insStr - String/RegExp that is to be dropped.
* @returns { String } Returns string with result of substring removement.
*
* @example
* _.strRemove( 'source string', 's' );
* // returns ource tring
*
* @example
* _.strRemove( 'example', 's' );
* // returns example
*
* @function strRemove
* @throws { Exception } Throws a exception if( srcStr ) is not a String.
* @throws { Exception } Throws a exception if( insStr ) is not a String or a RegExp.
* @throws { Exception } Throws a exception if( arguments.length ) is not equal 2.
* @namespace Tools
*
*/

/*
aaa : extend coverage of routines strRemove, strReplace, make sure tests cover regexp cases
Dmytro : coverage is extended
*/

function strRemove( srcStr, insStr )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.longIs( srcStr ) || _.regexpLike( srcStr ), () => 'Expects string or array of strings {-srcStr-}, but got ' + _.entity.strType( srcStr ) );

  if( _.longIs( insStr ) )
  {
    for( let i = 0 ; i < insStr.length ; i++ )
    _.assert( _.strIs( insStr[ i ] ) || _.regexpIs( insStr[ i ] ), () => 'Expects string/regexp or array of strings/regexps' );
  }
  else
  {
    _.assert( _.strIs( insStr ) || _.regexpIs( insStr ), () => 'Expects string/regexp or array of strings/regexps' );
  }
  //_.assert( _.longIs( insStr ) || _.regexpLike( insStr ), () => 'Expects string/regexp or array of strings/regexps {-begin-}' );

  let result = [];

  if( _.strIs( srcStr ) && !_.longIs( srcStr ) )
  return _._strRemoved( srcStr, insStr );

  srcStr = _.array.as( srcStr );

  for( let s = 0; s < srcStr.length; s++ )
  {
    let src = srcStr[ s ];
    result[ s ] = _._strRemoved( src, insStr );
  }

  if( !_.longIs( srcStr ) )
  return result[ 0 ];

  return result;
}

// //
//
// /**
//   * Prepends string( begin ) to the source( src ) if prefix( begin ) is not match with first chars of string( src ),
//   * otherwise returns original string.
//   * @param { String } src - Source string to parse.
//   * @param { String } begin - String to prepend.
//   *
//   * @example
//   * _.strPrependOnce( 'test', 'test' );
//   * // returns 'test'
//   *
//   * @example
//   * _.strPrependOnce( 'abc', 'x' );
//   * // returns 'xabc'
//   *
//   * @returns { String } Returns result of prepending string( begin ) to source( src ) or original string.
//   * @function strPrependOnce
//   * @namespace Tools
//   */
//
// function strPrependOnce( src, begin )
// {
//   _.assert( _.strIs( src ) && _.strIs( begin ), 'Expects {-src-} and {-begin-} as strings' );
//   if( src.lastIndexOf( begin, 0 ) === 0 )
//   return src;
//   else
//   return begin + src;
// }
//
// //
//
// /**
//   * Appends string( end ) to the source( src ) if postfix( end ) is not match with last chars of string( src ),
//   * otherwise returns original string.
//   * @param {string} src - Source string to parse.
//   * @param {string} end - String to append.
//   *
//   * @example
//   * _.strAppendOnce( 'test', 'test' );
//   * // returns 'test'
//   *
//   * @example
//   * _.strAppendOnce( 'abc', 'x' );
//   * // returns 'abcx'
//   *
//   * @returns {string} Returns result of appending string( end ) to source( src ) or original string.
//   * @function strAppendOnce
//   * @namespace Tools
//   */
//
// function strAppendOnce( src, end )
// {
//   _.assert( _.strIs( src ) && _.strIs( end ), 'Expects {-src-} and {-end-} as strings' );
//   if( src.indexOf( end, src.length - end.length ) === -1 )
//   return src + end;
//   else
//   return src;
// }

// --
// etc
// --

/**
 * Replaces occurrence of each word from array( ins ) in string( src ) with word
 * from array( sub ) considering it position.
 * @param {string} src - Source string to parse.
 * @param {array} ins - Array with strings to replace.
 * @param {string} sub - Array with new strings.
 * @returns {string} Returns string with result of replacements.
 *
 * @example
 * _.strReplaceWords( ' my name is', [ 'my', 'name', 'is' ], [ 'your', 'cars', 'are' ] )
 * // returns ' your cars are'
 *
 * @method strReplaceWords
 * @throws { Exception } Throws a exception if( ins ) is not a Array.
 * @throws { Exception } Throws a exception if( sub ) is not a Array.
 * @throws { TypeError } Throws a exception if( src ) is not a String.
 * @throws { Exception } Throws a exception if( arguments.length ) is not equal 3.
 * @namespace Tools
 *
 */

function strReplaceWords( src, ins, sub )
{
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( _.strIs( src ) );
  _.assert( _.arrayIs( ins ) );
  _.assert( _.arrayIs( sub ) );
  _.assert( ins.length === sub.length );

  let result = src;
  for( let i = 0 ; i < ins.length ; i++ )
  {
    _.assert( _.strIs( ins[ i ] ) );
    let r = new RegExp( '(\\W|^)' + ins[ i ] + '(?=\\W|$)', 'gm' );
    result = result.replace( r, function( original )
    {
      if( original[ 0 ] === sub[ i ][ 0 ] )
      return sub[ i ];
      else
      return original[ 0 ] + sub[ i ];
      // if( original[ 0 ] !== sub[ i ][ 0 ] )
      // return original[ 0 ] + sub[ i ];
      // else
      // return sub[ i ];
    });
  }

  return result;
}

// --
// etc
// --

/**
 * Routine strCommonLeft() finds common symbols from the begining of all strings passed to arguments list.
 * Routine uses first argument {-ins-} as a pattern. If some string doesn`t have the same first symbols
 * as the pattern {-ins-}, the function returns an empty string.
 * Otherwise, it returns the symbol sequence that appears from the start of each string.
 *
 * @param { String } ins - Sequence of possible symbols.
 * @param { String } ... - Another strings to search common sequence of symbols.
 *
 * @example
 * _.strCommonLeft( 'abcd', 'ab', 'abc', 'abd' );
 * // returns 'ab'
 *
 * @example
 * _.strCommonLeft( 'abcd', 'abc', 'abcd' );
 * // returns 'abc'
 *
 * @example
 * _.strCommonLeft( 'abcd', 'abc', 'd' )
 * // returns ''
 *
 * @returns { String } - Returns found common symbols.
 * @function strCommonLeft
 * @throws { Error } If {-ins-} is not a String.
 * @namespace Tools
 *
 */

function strCommonLeft( ins )
{

  if( arguments.length === 0 )
  return '';
  if( arguments.length === 1 )
  return ins;

  _.assert( _.strIs( ins ) );

  let length = +Infinity;

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    length = Math.min( length, src.length );
  }

  let i = 0;
  for( ; i < length ; i++ )
  for( let a = 1 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    if( src[ i ] !== ins[ i ] )
    return ins.substring( 0, i );
  }

  return ins.substring( 0, i );
}

//

/**
 * Routine strCommonRight() finds common symbols from the end of all strings passed to arguments list.
 * Routine uses first argument {-ins-} as a pattern. If some string doesn`t have the same end symbols
 * as the pattern {-ins-}, the function returns an empty string.
 * Otherwise, it returns the symbol sequence that appears from the end of each string.
 *
 * @param { String } ins - Sequence of possible symbols.
 * @param { String } ... - Another strings to search common sequence of symbols.
 *
 * @example
 * _.strCommonRight( 'same', 'came', 'me', 'code' );
 * // returns 'e'
 *
 * @example
 * _.strCommonRight( 'add', 'dd'+'d', 'hdd' );
 * // returns 'dd'
 *
 * @example
 * _.strCommonRight( 'abcd', 'abc', 'd' )
 * // returns ''
 *
 * @returns { String } - Returns found common symbols.
 * @function strCommonRight
 * @throws { Error } If {-ins-} is not a String.
 * @namespace Tools
 *
 */

function strCommonRight( ins )
{

  if( arguments.length === 0 )
  return '';
  if( arguments.length === 1 )
  return ins;

  _.assert( _.strIs( ins ) );

  let length = +Infinity;

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    length = Math.min( length, src.length );
  }

  let i = 0;
  for( ; i < length ; i++ )
  for( let a = 1 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    if( src[ src.length - i - 1 ] !== ins[ ins.length - i - 1 ] )
    return ins.substring( ins.length-i );
  }

  return ins.substring( ins.length-i );
}

//

/**
 * Routine strRandom() makes string with random length with random symbols defined
 * by option {-o.alphabet-}.
 * Routine accepts two types of parameter. First of them is options map {-o-}, the second
 * is Number (Range) {-length-}.
 *
 * First set of parameters
 * @param { Map } o - Options map.
 * @param { Number|Range } o.length - The length of random string.
 * The generated string may has fixed length if {-o.length-} defined by a number. If {-o.length-}
 * defined by a Range, then length of generated string is variable.
 * @param { String } o.alphabet - String with symbols for generated string.
 * Default range of symbols is 'a' - 'z'.
 *
 * Second set of parameters
 * @param { Number|Range } length - The length of random string.
 * The generated string may has fixed length if {-o.length-} defined by a number. If {-o.length-}
 * defined by a Range, then length of generated string is variable.
 * @param { String } o.alphabet - String with symbols for generated string.
 *
 * @example
 * _.strRandom( 0 );
 * // returns ''
 *
 * @example
 * _.strRandom( 2 );
 * // returns 'vb'
 * // string with 2 random symbols from 'a' to 'z'
 *
 * @example
 * _.strRandom( [ 1, 5 ] )
 * // returns 'soyx'
 * // string with length from 1 to 5 and random symbols from 'a' to 'z'
 *
 * @example
 * _.strRandom( { length : 3, alphabet : 'a' } )
 * // returns 'aaa'
 * // string with length 3 and symbol 'a'
 *
 * @example
 * _.strRandom( { length : [ 1, 5 ], alphabet : 'ab' } )
 * // returns 'aabab'
 * // string with length from 1 to 5 and random symbols 'a' and 'b'
 *
 * @returns { String } - Returns string with random length and symbols.
 * @function strRandom
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If options map {-o-} has unnacessary fields.
 * @throws { Error } If parameter {-length-} or option {-o.length-} is not a Number and not a Range.
 * @namespace Tools
 *
 */

function strRandom( o )
{
  if( !_.mapIs( o ) )
  o = { length : o }

  o = _.routine.options( strRandom, o );

  if( _.number.is( o.length ) )
  o.length = [ o.length, o.length+1 ];
  if( o.alphabet === null )
  o.alphabet = _.strAlphabetFromRange([ 'a', 'z' ]);

  _.assert( _.intervalIs( o.length ) );
  _.assert( arguments.length === 1 );

  let length = o.length[ 0 ];
  if( o.length[ 0 ]+1 !== o.length[ 1 ] )
  {
    length = _.intRandom( o.length );
  }

  let result = '';
  for( let i = 0 ; i < length ; i++ )
  {
    result += o.alphabet[ _.intRandom( o.alphabet.length ) ];
  }
  return result;
}

strRandom.defaults =
{
  length : null,
  alphabet : null,
}

//

/**
 * Routine strAlphabetFromRange() generates a string with a sequence of symbols started from
 * first element of {-range-} and ended on previous element before last.
 *
 * @param { Range } range - Range of symbols. It is two elements array. Elements of {-range-}
 * should have a String or a Number type.
 *
 * @example
 * _.strAlphabetFromRange( [ 97, 98 ] );
 * // returns 'a'
 *
 * @example
 * _.strAlphabetFromRange( 97, 100 );
 * // returns 'abc'
 *
 * @example
 * _.strAlphabetFromRange( [ 'a', 'b' ] );
 * // returns 'a'
 *
 * @example
 * _.strAlphabetFromRange( 'a', 'd' );
 * // returns 'abc'
 *
 * @example
 * _.strAlphabetFromRange( [ 'a', 98 ] );
 * // returns 'a'
 *
 * @example
 * _.strAlphabetFromRange( 97, 'd' );
 * // returns 'abc'
 *
 * @returns { String } - Returns string with sequence of symbols.
 * @function strAlphabetFromRange
 * @throws { Error } If arguments.length is less then one.
 * @throws { Error } If range.length is less or more then two.
 * @throws { Error } If range[ 0 ] or range[ 1 ] is not a Number and not a String.
 * @namespace Tools
 *
 */

function strAlphabetFromRange( range )
{
  _.assert( _.arrayIs( range ) && range.length === 2 )
  _.assert( _.strIs( range[ 0 ] ) || _.number.is( range[ 0 ] ) );
  _.assert( _.strIs( range[ 1 ] ) || _.number.is( range[ 1 ] ) );
  if( _.strIs( range[ 0 ] ) )
  range[ 0 ] = range[ 0 ].charCodeAt( 0 );
  if( _.strIs( range[ 1 ] ) )
  range[ 1 ] = range[ 1 ].charCodeAt( 0 );
  let result = String.fromCharCode( ... _.longFromRange([ range[ 0 ], range[ 1 ] ]) );
  return result;
}

// --
// formatter
// --

function strForRange( range )
{
  let result;

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( range ) );

  result = '[ ' + range[ 0 ] + '..' + range[ 1 ] + ' ]';

  return result;
}

//

function strForCall()
{
  let nameOfRoutine = arguments[ 0 ];
  let args = arguments[ 1 ];
  let ret = arguments[ 2 ];
  let o = arguments[ 3 ];

  let result = nameOfRoutine + '( ';
  let first = true;

  _.assert( _.arrayIs( args ) || _.object.isBasic( args ) );
  _.assert( arguments.length <= 4 );

  _.each( args, function( e, k )
  {

    if( first === false )
    result += ', ';

    if( _.object.isBasic( e ) )
    result += k + ' :' + _.entity.exportString( e, o );
    else
    result += _.entity.exportString( e, o );

    first = false;

  });

  result += ' )';

  if( arguments.length >= 3 )
  result += ' -> ' + _.entity.exportString( ret, o );

  return result;
}

//

function strDifference( src1, src2 )
{
  _.assert( _.strIs( src1 ) );
  _.assert( _.strIs( src2 ) );

  if( src1 === src2 )
  return false;

  let l = Math.min( src1.length, src2.length );
  for( let i = 0 ; i < l ; i++ )
  if( src1[ i ] !== src2[ i ] )
  return src1.substr( 0, i ) + '*';

  return src1.substr( 0, l ) + '*';
}

// --
// transformer
// --

/**
 * Returns string with first letter converted to upper case.
 * Expects one object: the string to be formatted.
 *
 * @param {string} src - Source string.
 * @returns {String} Returns a string with the first letter capitalized.
 *
 * @example
 * _.strCapitalize( 'test string' );
 * // returns Test string
 *
 * @example
 * _.strCapitalize( 'another_test_string' );
 * // returns Another_test_string
 *
 * @method strCapitalize
 * @throws { Exception } Throw an exception if( src ) is not a String.
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 1.
 * @namespace Tools
 *
 */

function strCapitalize( src )
{
  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  /*_.assert( src.length > 0 );*/
  /*_.assert( src.match(/(^\W)/) === null );*/

  if( src.length === 0 )
  return src;

  return src[ 0 ].toUpperCase() + src.substring( 1 );
}

//

/**
 * The routine `strDecapitalize` returns string with first letter converted to lower case.
 * Expects one object: the string to be formatted.
 *
 * @param {string} src - Source string.
 * @returns {String} Returns a string with the first letter lowercased.
 *
 * @example
 * _.strCapitalize( 'Test string' );
 * // returns test string
 *
 * @example
 * _.strCapitalize( 'Another_test_string' );
 * // returns another_test_string
 *
 * @method strDecapitalize
 * @throws { Exception } Throw an exception if( src ) is not a String.
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 1.
 * @namespace Tools
 *
 */

function strDecapitalize( src )
{
  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( src.length === 0 )
  return src;

  return src[ 0 ].toLowerCase() + src.substring( 1 );
}

//

/**
 * The routine `strSign` adds {- prefix -} to a source string.
 * @param { String } src - Source string.
 * @param { String } prefix - String to be added.
 * @returns { String } Returns string with added {- prefix -} character.
 *
 * @example
 * _.strSign( 'a' );
 * // returns 'wA'
 *
 * @example
 * _.strSign( 'Tools' );
 * // returns 'wTools'
 *
 * @example
 * _.strSign( 'A', 'q' );
 * // returns 'qA'
 *
 * @method strSign
 * @throws { Exception } If( src ) is not a String.
 * @throws { Exception } If( arguments.length ) is not equal to 1.
 * @throws { Exception } If( {- prefix -}.length ) is not equal to 1.
 * @namespace Tools
 *
 */

function strSign( src, prefix )
{
  _.assert( _.strIs( src ) && src.length > 0, '{- src -} must be non empty string');
  _.assert( arguments.length === 1 || arguments.length === 2, 'Expects one or two arguments' );

  if( prefix === undefined )
  prefix = 'w';

  _.assert( prefix.length === 1 );
  _.assert( !_.strIsSigned( src, prefix ), 'Expects not signed string' );

  return prefix + src[ 0 ].toUpperCase() + src.substring( 1 );
}

//

/**
 * The routine `strDesign` removes {- prefix -} character if it's placed before uppercase letter in a source string.
 * @param { String } src - Source string.
 * @param { String } prefix - String to be removed.
 * @returns { String } Returns string with removed {- prefix -} character.
 *
 * @example
 * _.strDesign( 'wA' );
 * // returns 'A'
 *
 * @example
 * _.strDesign( 'wTools' );
 * // returns 'Tools'
 *
 * @example
 * _.strDesign( 'qA', 'q' );
 * // returns 'A'
 *
 * @method strDesign
 * @throws { Exception } If( src ) is not a String.
 * @throws { Exception } If( arguments.length ) is not equal to 1.
 * @throws { Exception } If( {- prefix -}.length ) is not equal to 1.
 * @namespace Tools
 *
 */

function strDesign( src, prefix )
{
  _.assert( _.strIs( src ) && src.length > 0, '{- src -} must be non empty string');
  _.assert( arguments.length === 1 || arguments.length === 2, 'Expects one or two arguments' );

  if( prefix === undefined )
  prefix = 'w';

  _.assert( prefix.length === 1 );
  _.assert( _.strIsSigned( src, prefix ), 'Expects signed string' );

  return src.substring( 1 );
}

//

/**
 * The routine `strIsSigned` checks a source string to be signed.
 * @param { String } src - Source string.
 * @param { String } prefix - string to be checked.
 * @returns { String } Returns true if string has {- prefix -} as the first character and a capital letter as the second, otherwise - returns false
 *
 * @example
 * _.strIsSigned( 'wa' );
 * // returns false
 *
 * @example
 * _.strIsSigned( 'wTools' );
 * // returns true
 *
 * @example
 * _.strIsSigned( 'w123' );
 * // returns false
 *
 * @example
 * _.strIsSigned( 'qA', 'q' );
 * // returns true
 *
 * @method strIsSigned
 * @throws { Exception } If( src ) is not a String.
 * @throws { Exception } If( arguments.length ) is not equal to 1.
 * @throws { Exception } If( {- prefix -}.length ) is not equal to 1.
 * @namespace Tools
 *
 */

function strIsSigned( src, prefix )
{
  _.assert( _.strIs( src ) && src.length > 0, '{- src -} must be non empty string');
  _.assert( arguments.length === 1 || arguments.length === 2, 'Expects one or two arguments' );

  if( !prefix )
  prefix = 'w';

  _.assert( prefix.length === 1 );

  return new RegExp( `^${prefix}[A-Z0-9]` ).test( src );

}

//

/**
 * Disables escaped characters in source string( src ).
 * Example: '\n' -> '\\n', '\u001b' -> '\\u001b' etc.
 * Returns string with disabled escaped characters, source string if nothing changed or  empty string if source is zero length.
 * @param {string} src - Source string.
 * @returns {string} Returns string with disabled escaped characters.
 *
 * @example
 * _.strEscape( '\nhello\u001bworld\n' );
 * // returns '\nhello\u001bworld\n'
 *
 * @example
 * _.strEscape( 'string' );
 * // returns 'string'
 *
 * @example
 * _.strEscape( 'str\'' );
 * // returns 'str\''
 *
 * @example
 * _.strEscape( '' );
 * // returns ''
 *
 * @method strEscape
 * @throw { Exception } If( src ) is not a String.
 * @namespace Tools
 *
 */

function strEscape( o )
{

  // 007f : ''
  // . . .
  // 009f : ''

  // 00ad : '­'

  // \'   single quote   byte 0x27 in ASCII encoding
  // \'   double quote   byte 0x22 in ASCII encoding
  // \\   backslash   byte 0x5c in ASCII encoding
  // \b   backspace   byte 0x08 in ASCII encoding
  // \f   form feed - new page   byte 0x0c in ASCII encoding
  // \n   line feed - new line   byte 0x0a in ASCII encoding
  // \r   carriage return   byte 0x0d in ASCII encoding
  // \t   horizontal tab   byte 0x09 in ASCII encoding
  // \v   vertical tab   byte 0x0b in ASCII encoding
  // source : http://en.cppreference.com/w/cpp/language/escape

  if( _.strIs( o ) )
  o = { src : o }

  _.assert( _.strIs( o.src ), 'Expects string {-o.src-}, but got', _.entity.strType( o.src ) );
  _.routine.options( strEscape, o );

  let result = '';
  let stringWrapperCode = o.stringWrapper.charCodeAt( 0 );
  for( let s = 0 ; s < o.src.length ; s++ )
  {
    let code = o.src.charCodeAt( s );

    if( o.stringWrapper === '`' && code === 0x24 /* $ */ )
    {
      result += '\\$';
    }
    else if( o.stringWrapper && code === stringWrapperCode )
    {
      result += '\\' + o.stringWrapper;
    }
    else if( 0x007f <= code && code <= 0x009f || code === 0x00ad /*|| code >= 65533*/ )
    {
      result += _.strCodeUnicodeEscape( code );
    }
    else switch( code )
    {

      case 0x5c /* '\\' */ :
        result += '\\\\';
        break;

      case 0x08 /* '\b' */ :
        result += '\\b';
        break;

      case 0x0c /* '\f' */ :
        result += '\\f';
        break;

      case 0x0a /* '\n' */ :
        result += '\\n';
        break;

      case 0x0d /* '\r' */ :
        result += '\\r';
        break;

      case 0x09 /* '\t' */ :
        result += '\\t';
        break;

      // /* xxx : extend coverage of routine _.strEscape. don't forget this test case */
      // case 0x0b /* '\v' */ :
      //   result += '\\v';
      //   break;

      default :
        if( code < 32 )
        {
          result += _.strCodeUnicodeEscape( code );
        }
        else
        {
          result += String.fromCharCode( code );
        }

    }

  }

  return result;
}

strEscape.defaults =
{
  src : null,
  stringWrapper : '\'',
  charsToEscape : null, /* xxx : qqq : implement */
}

//

/**
 * Converts number {-code-} into unicode representation.
 * Returns result of conversion as new string.
 *
 * @param { Number } code - The code to convert into unicode representation.
 *
 * @example
 * _.strCodeUnicodeEscape( 70 );
 * // returns '\\u0046'
 *
 * @example
 * _.strCodeUnicodeEscape( 77 );
 * // returns '\\u004d'
 *
 * @returns { String } - Returns string with result of conversion.
 * @function strCodeUnicodeEscape
 * @throws { Exception } If arguments.length is less or more then one.
 * @throws { Exception } If {-src-} is not a Number.
 * @namespace Tools
 *
 */

function strCodeUnicodeEscape( code )
{
  let result = '';

  _.assert( _.number.is( code ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let h = code.toString( 16 );
  let d = _.strDup( '0', 4-h.length ) + h;

  result += '\\u' + d;

  return result;
}

//

/**
 * Converts source string {-str-} into unicode representation by replacing each symbol with its escaped unicode equivalent.
 * Returns result of conversion as new string or empty string if source has zero length.
 *
 * @param { String } str - Source string to parse.
 *
 * @example
 * _.strUnicodeEscape( 'abc' );
 * // returns \u0061\u0062\u0063;
 *
 * @example
 * _.strUnicodeEscape( 'world' );
 * // returns \u0077\u006f\u0072\u006c\u0064
 *
 * @example
 * _.strUnicodeEscape( '//test//' );
 * // returns \u002f\u002f\u0074\u0065\u0073\u0074\u002f\u002f
 *
 * @returns { String } - Returns string with result of conversion.
 * @function strUnicodeEscape
 * @throws { Exception } If arguments.length is less or more then one.
 * @throws { Exception } If {-src-} is not a String.
 * @namespace Tools
 *
 */

function strUnicodeEscape( src )
{
  let result = '';

  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let i = 0 ; i < src.length ; i++ )
  {
    let code = src.charCodeAt( i );
    result += _.strCodeUnicodeEscape( code );
  }

  return result;
}

//

function strReverse( srcStr )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  let result = '';
  for( let i = 0 ; i < srcStr.length ; i++ )
  result = srcStr[ i ] + result;
  return result;
}

// --
// splitter
// --

/**
 * Parses a source string( src ) and separates numbers and string values
 * in to object with two properties: 'str' and 'number', example of result: ( { str: 'bd', number: 1 } ).
 *
 * @param {string} src - Source string.
 * @returns {object} Returns the object with two properties:( str ) and ( number ),
 * with values parsed from source string. If a string( src ) doesn't contain number( s ),
 * function returns the object with value of string( src ).
 *
 * @example
 * _.strSplitStrNumber( 'bd1' );
 * // returns { str: 'bd', number: 1 }
 *
 * @example
 * _.strSplitStrNumber( 'bdxf' );
 * // returns { str: 'bdxf' }
 *
 * @method strSplitStrNumber
 * @throws { Exception } Throw an exception if( src ) is not a String.
 * @throws { Exception } Throw an exception if no argument provided.
 * @namespace Tools
 *
 */

function strSplitStrNumber( src )
{
  let result = Object.create( null );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) );

  let mnumber = src.match(/\d+/);
  if( mnumber && mnumber.length )
  {
    let mstr = src.match(/[^\d]*/);
    result.str = mstr[ 0 ];
    result.number = _.number.from( mnumber[ 0 ] );
  }
  else
  {
    result.str = src;
  }

  return result;
}

//

function strSplitChunks( o )
{
  let result = Object.create( null );
  result.chunks = [];

  if( arguments.length === 2 )
  {
    o = arguments[ 1 ] || Object.create( null );
    o.src = arguments[ 0 ];
  }
  else
  {
    _.assert( arguments.length === 1, 'Expects single argument' );
    if( _.strIs( arguments[ 0 ] ) )
    o = { src : arguments[ 0 ] };
  }

  _.routine.options( strSplitChunks, o );
  _.assert( _.strIs( o.src ), 'Expects string (-o.src-), but got', _.entity.strType( o.src ) );

  if( !_.regexpIs( o.prefix ) )
  o.prefix = RegExp( _.regexpEscape( o.prefix ), 'm' );

  if( !_.regexpIs( o.postfix ) )
  o.postfix = RegExp( _.regexpEscape( o.postfix ), 'm' );

  let src = o.src;

  /* */

  let line = 0;
  let column = 0;
  let chunkIndex = 0;
  let begin = -1;
  let end = -1;
  do
  {

    /* begin */

    begin = src.search( o.prefix );
    if( begin === -1 ) begin = src.length;

    /* text chunk */

    if( begin > 0 )
    makeChunkStatic( begin );

    /* break */

    if( !src )
    {
      if( !result.chunks.length )
      makeChunkStatic( 0 );
      break;
    }

    /* end */

    end = src.search( o.postfix );
    if( end === -1 )
    {
      result.lines = _.str.lines.split( src ).length;
      result.error = _.err( 'Openning prefix', o.prefix, 'of chunk #' + result.chunks.length, 'at'+line, 'line does not have closing tag :', o.postfix );
      return result;
    }

    /* code chunk */

    let chunk = makeChunkDynamic();

    /* wind */

    chunkIndex += 1;
    line += _.strLinesCount( chunk.prefix + chunk.code + chunk.postfix ) - 1;

  }
  while( src );

  return result;

  /* - */

  function colAccount( text )
  {
    let i = text.lastIndexOf( '\n' );

    if( i === -1 )
    {
      column += text.length;
    }
    else
    {
      column = text.length - i;
    }

    _.assert( column >= 0 );
  }

  /* - */

  function makeChunkStatic( begin )
  {
    let chunk = Object.create( null );
    chunk.line = line;
    chunk.text = src.substring( 0, begin );
    chunk.index = chunkIndex;
    chunk.kind = 'static';
    result.chunks.push( chunk );

    src = src.substring( begin );
    line += _.strLinesCount( chunk.text ) - 1;
    chunkIndex += 1;

    colAccount( chunk.text );
  }

  /* - */

  function makeChunkDynamic()
  {
    let chunk = Object.create( null );
    chunk.line = line;
    chunk.column = column;
    chunk.index = chunkIndex;
    chunk.kind = 'dynamic';
    chunk.prefix = src.match( o.prefix )[ 0 ];
    chunk.code = src.substring( chunk.prefix.length, end );
    if( o.investigate )
    {
      chunk.lines = _.str.lines.split( chunk.code );
      chunk.tab = /^\s*/.exec( chunk.lines[ chunk.lines.length-1 ] )[ 0 ];
    }

    /* postfix */

    src = src.substring( chunk.prefix.length + chunk.code.length );
    chunk.postfix = src.match( o.postfix )[ 0 ];
    src = src.substring( chunk.postfix.length );

    result.chunks.push( chunk );
    return chunk;
  }

}

strSplitChunks.defaults =
{
  src : null,
  investigate : 1,
  prefix : '//>-' + '->//',
  postfix : '//<-' + '-<//',
}

//

/*
aaa : cover it by test
Dmytro : covered,

maybe, routine needs assertion
_.assert( arguments.length === 1, 'Expects one argument' );
if assertion will be accepted, then test.case = 'a few arguments' will throw error
*/

function strSplitCamel( src )
{

  let splits = _.strSplitFast( src, /[A-Z]/ );

  for( let s = splits.length-2 ; s >= 0 ; s-- )
  {
    if( s % 2 === 1 )
    splits.splice( s, 2, splits[ s ].toLowerCase() + splits[ s + 1 ] );
  }

  return splits;
}

// --
// extractor
// --

/**
 * Routine _strOnly() gets substring out of source string {-srcStr-} according to a given range {-range-}.
 * The end value of the range is not included in the substring.
 *
 * @param { String } srcStr - Source string.
 * @param { Range } range - Range to get substring.
 * If range[ 0 ] or range[ 1 ] is less then 0, then reference point is length of source string {-srcStr-}.
 *
 * @example
 * _._strOnly( '', [ 0, 2 ] );
 * // returns ''
 *
 * @example
 * _._strOnly( 'first', [ 0, 7 ] );
 * // returns 'first'
 *
 * @example
 * _._strOnly( 'first', [ 0, 2 ] );
 * // returns 'fi'
 *
 * @example
 * _._strOnly( 'first', [ -2, 5 ] );
 * // returns 'st'
 *
 * @example
 * _._strOnly( 'first', [ 2, 2 ] );
 * // returns ''
 *
 * @function _strOnly
 * @returns { String } - Returns substring from source string.
 * @throws { Error } If arguments.length is less or more then two.
 * @throws { Error } If {-srcStr-} is not a String.
 * @throws { Error } If {-range-} is not a Range.
 * @namespace Tools
 */

function _strOnly( srcStr, cinterval )
{

  /*
    _.strOnly( 'abc', [ -2, -1 ] ) => 'b'
    _.strOnly( 'abc', [ 1, 2 ] ) => 'b'

    3-2 = 1
    3-1 = 2
  */

  if( _.number.is( cinterval ) )
  {
    if( cinterval < 0 )
    cinterval = srcStr.length + cinterval;
    cinterval = [ cinterval, cinterval ];
  }
  else
  {
    cinterval = _.long.make( cinterval ); /* Dmytro : vectorized routine should not change original range */

    if( cinterval[ 1 ] < -1 )
    cinterval[ 1 ] = srcStr.length + cinterval[ 1 ];
    if( cinterval[ 0 ] < 0 )
    cinterval[ 0 ] = srcStr.length + cinterval[ 0 ];
  }

  if( cinterval[ 0 ] > cinterval[ 1 ] )
  cinterval[ 1 ] = cinterval[ 0 ] - 1;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( srcStr ) );
  _.assert( _.cinterval.defined( cinterval ) );

  return srcStr.substring( cinterval[ 0 ], cinterval[ 1 ] + 1 );
}

//

/**
 * Routine strOnly() gets substring out of each string in vector of strings {-srcStr-} according to a given range {-range-}.
 * The end value of the range is not included in the substring.
 *
 * @param { String|Long } srcStr - Source string or array of strings.
 * @param { Range } range - Range to get substring.
 * If range[ 0 ] or range[ 1 ] is less then 0, then reference point is length of source string {-srcStr-}.
 *
 * @example
 * _.strOnly( '', [ 0, 1 ] );
 * // returns ''
 *
 * @example
 * _.strOnly( 'first', [ 0, 6 ] );
 * // returns 'first'
 *
 * @example
 * _.strOnly( 'first', [ 0, 1 ] );
 * // returns 'fi'
 *
 * @example
 * _.strOnly( 'first', [ -2, 4 ] );
 * // returns 'st'
 *
 * @example
 * _.strOnly( 'first', [ 2, 1 ] );
 * // returns ''
 *
 * @example
 * _.strOnly( [ '', 'a', 'ab', 'abcde' ], [ 0, 1 ] );
 * // returns [ '', 'a', 'ab', 'ab' ]
 *
 * @example
 * _.strOnly( [ '', 'a', 'ab', 'abcde' ], [ 0, 6 ] );
 * // returns [ '', 'a', 'ab', 'abcde' ]
 *
 * @example
 * _.strOnly( [ '', 'a', 'ab', 'abcde' ], [ -2, 4 ] );
 * // returns [ '', 'a', 'ab', 'de' ]
 *
 * @example
 * _.strOnly( [ '', 'a', 'ab', 'abcde' ], [ 2, 1 ] );
 * // returns[ '', '', '', '' ]
 *
 * @function strOnly
 * @returns { String|Long } - Returns substrings from source string or array of strings.
 * @throws { Error } If arguments.length is less or more then two.
 * @throws { Error } If {-srcStr-} is not a String, not a Long.
 * @throws { Error } If {-srcStr-} is a Long and includes not a String value.
 * @throws { Error } If {-range-} is not a Range.
 * @namespace Tools
 */

let strOnly = _.vectorize( _strOnly );

//

// srcStr:str ins:str -> str
// srcStr:str ins:[ * str ] -> [ * str ]
// srcStr:[ * str ] ins:[ * str ] -> [ * str ]

/**
 * Routine _strBut() replaces substring from source string {-srcStr-} to new value {-ins-}
 * The ranges of substring defines according to a given range {-cinterval-}.
 * The end value of the range is included in the substring.
 *
 * @example
 * _._strBut( '', [ 0, 2 ] );
 * // returns : ''
 *
 * @example
 * _._strBut( 'first', [ 0, 7 ] );
 * // returns : ''
 *
 * @example
 * _._strBut( 'first', [ 0, 1 ] );
 * // returns : 'rst'
 *
 * @example
 * _._strBut( 'first', [ -2, 4 ] );
 * // returns : 'firt'
 *
 * @example
 * _._strBut( 'first', [ 2, 1 ] );
 * // returns : 'first'
 *
 * @example
 * _._strBut( 'first', [ 0, 1 ], 'abc' );
 * // returns : 'abcrst'
 *
 * @example
 * _._strBut( 'first', [ 0, 1 ], [ 'a', 'b', 'c' ] );
 * // returns : [ 'arst', 'brst', 'crst' ]
 *
 * @example
 * _._strBut( 'first', [ 2, 1 ], 'abc' );
 * // returns : [ 'fiarst', 'fibrst', 'ficrst' ]
 *
 * @param { String } srcStr - Source string.
 * @param { Crange } cinterval - Closed range to get substring.
 * If cinterval[ 0 ] or cinterval[ 1 ] is less then 0, then reference point is length of source string {-srcStr-}.
 * @param { String|Long } ins - Inserted string or array with inserted elements.
 * If {-ins-} is a Long, then routine concatenates string from elements of Long. The delimeter is single space.
 * If {-ins-} is not provided or if it is undefined, then routine removes substring from source string to a given range.
 * @function _strBut
 * @returns { String } - Returns source string, part of which replaced to the new value.
 * @throws { Error } If arguments.length is less then two or more then three.
 * @throws { Error } If {-srcStr-} is not a String.
 * @throws { Error } If {-range-} is not a Range.
 * @throws { Error } If {-ins-} is not a String, not a Long, not undefined.
 * @namespace Tools
 */

function _strBut( srcStr, cinterval, ins )
{


  /*
  aaa : reference point of negative is length. implement and cover please
  Dmytro : implemented a time ago
  */

  if( _.number.is( cinterval ) )
  {
    if( cinterval < 0 )
    cinterval = srcStr.length + cinterval;
    cinterval = [ cinterval, cinterval ];
  }
  else
  {
    cinterval = _.long.make( cinterval ); /* Dmytro : vectorized routine should not change original range */

    if( cinterval[ 1 ] < -1 )
    cinterval[ 1 ] = srcStr.length + cinterval[ 1 ];
    if( cinterval[ 0 ] < 0 )
    cinterval[ 0 ] = srcStr.length + cinterval[ 0 ];
  }

  if( cinterval[ 0 ] > cinterval[ 1 ] )
  cinterval[ 1 ] = cinterval[ 0 ] - 1;

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( _.strIs( srcStr ) );
  _.assert( _.cinterval.defined( cinterval ) );
  _.assert( ins === undefined || _.strIs( ins ) || _.longIs( ins ) );

  /*
     aaa : implement for case ins is long
     Dmytro : implemented, elements of long joins by spaces
     aaa for Dmytro : no really
     Dmytro : fixed
  */

  let result;
  if( _.longIs( ins ) )
  {
    result = _.array.make( ins.length );
    for( let i = 0 ; i < ins.length ; i++ )
    result[ i ] = _strConcat( srcStr, cinterval, ins[ i ] );
  }
  else
  {
    result = _strConcat( srcStr, cinterval, ins ? ins : '' );
  }

  return result;

  /* */

  function _strConcat( src, range, insertion )
  {
    return src.substring( 0, range[ 0 ] ) + insertion + src.substring( range[ 1 ] + 1, src.length );
  }
}

//

/**
 * Routine strBut() gets substring out of each string in vector of strings {-srcStr-} according to a given range {-range-}
 * and replaces it to new string {-ins-}.
 * The end value of the range is not included in the substring.
 *
 * @param { String|Long } srcStr - Source string or array of strings.
 * @param { Range } range - Range to get substring.
 * If range[ 0 ] or range[ 1 ] is less then 0, then reference point is length of source string {-srcStr-}.
 * @param { String|Long } ins - Inserted string or array with inserted elements.
 * If {-ins-} is a Long, then routine concatenates string from elements of Long. The delimeter is single space.
 * If {-ins-} is not provided or if it is undefined, then routine removes substring from source string to a given range.
 *
 * @example
 * _.strBut( '', [ 0, 2 ] );
 * // returns ''
 *
 * @example
 * _.strBut( 'first', [ 0, 7 ] );
 * // returns ''
 *
 * @example
 * _.strBut( 'first', [ 0, 2 ], 'abc' );
 * // returns 'abcrst'
 *
 * @example
 * _.strBut( 'first', [ -2, 5 ], [ 'a', 'b', 'c' ] );
 * // returns 'fira b c'
 *
 * @example
 * _.strBut( [ '', 'a', 'ab', 'abcde' ], [ 0, 2 ], 'fg' );
 * // returns [ 'fg', 'fg', 'fg', 'fgcde' ]
 *
 * @example
 * _.strBut( [ '', 'a', 'ab', 'abcde' ], [ 0, 7 ], [ 'f', 'g' ] );
 * // returns [ 'f g', 'f g', 'f g', 'f g' ]
 *
 * @example
 * _.strBut( [ '', 'a', 'ab', 'abcde' ], [ -2, 5 ], 'fg' );
 * // returns [ 'fg', 'fg', 'fg', 'abcfg' ]
 *
 * @example
 * _.strBut( [ '', 'a', 'ab', 'abcde' ], [ 2, 2 ], [ 'f', 'g' ] );
 * // returns [ 'f g', 'af g', 'abf g', 'abf gcde' ]
 *
 * @function strBut
 * @returns { String|Long } - Returns source string or vector of strings, part of which replaced to the new value.
 * @throws { Error } If arguments.length is less then two or more then three.
 * @throws { Error } If {-srcStr-} is not a String or not a Long.
 * @throws { Error } If {-srcStr-} is a Long and includes not a String value.
 * @throws { Error } If {-range-} is not a Range.
 * @throws { Error } If {-ins-} is not a String, not a Long, not undefined.
 * @namespace Tools
 */

let strBut = _.vectorize( _strBut );

//

/**
 * Routine strUnjoin() splits string {-srcStr-} into parts using array {-maskArray-} as mask and returns an array with splitted parts.
 * Mask {-maskArray-} contains string(s) separated by marker ( strUnjoin.any ). Mask must starts/ends with first/last letter from source
 * or can be replaced with marker ( strUnjoin.any ). Position of ( strUnjoin.any ) determines which part of source string will be splited:
 * - If ( strUnjoin.any ) is provided before string, it marks everything before that string. Example: ( [ _.strUnjoin.any, 'postfix' ] ).
 * - If ( strUnjoin.any ) is provided after string, it marks everything after that string. Example: ( [ 'prefix', _.strUnjoin.any ] ).
 * - If ( strUnjoin.any ) is provided between two strings, it marks everything between them. Example: ( [ 'prefix', _.strUnjoin.any, 'postfix' ] ).
 * - If ( strUnjoin.any ) is provided before and after string, it marks all except that string. Example: ( [ '_.strUnjoin.any', something, '_.strUnjoin.any' ] ).
 *
 * @param {string} srcStr - Source string.
 * @param {array} maskArray - Contains mask for source string.
 *
 * @example
 * _.strUnjoin( 'prefix_something_postfix', [ 'prefix', _.strUnjoin.any, 'postfix' ] );
 * // returns [ 'prefix', '_something_', 'postfix' ]
 *
 * @example
 * _.strUnjoin( 'prefix_something_postfix', [ _.strUnjoin.any, 'something', _.strUnjoin.any, 'postfix' ] );
 * // returns [ 'prefix_', 'something', '_', 'postfix' ]
 *
 * @example
 * _.strUnjoin( 'prefix_something_postfix', [ _.strUnjoin.any, 'postfix' ] );
 * // returns [ 'prefix_something_', 'postfix' ]
 *
 * @example
 * _.strUnjoin( 'prefix_something_postfix', [ 'prefix', _.strUnjoin.any ] );
 * // returns [ 'prefix', '_something_postfix' ]
 *
 * @example
 * _.strUnjoin( 'prefix_something_postfix', [ _.strUnjoin.any, 'x', _.strUnjoin.any, 'p', _.strUnjoin.any ] );
 * // returns [ 'prefi', 'x', '_something_', 'p', 'ostfix' ]
 *
 * @returns {array} Returns array with unjoined string part.
 * @function strUnjoin
 * @throws { Exception } If arguments.length is less or more then two.
 * @throws { Exception } If {-srcStr-} is not a String.
 * @throws { Exception } If {-maskArray-} is not an Array.
 * @throws { Exception } If {-maskArray-} value is not String or strUnjoin.any.
 * @namespace Tools
 *
 */

function strUnjoin( srcStr, maskArray )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( srcStr ) );
  _.assert( _.arrayIs( maskArray ) );

  let result = [];
  let index = 0;
  let rindex = -1;

  /**/

  for( let m = 0 ; m < maskArray.length ; m++ )
  {

    let mask = maskArray[ m ];

    if( !checkMask( mask ) )
    return;

  }

  if( rindex !== -1 )
  {
    index = srcStr.length;
    if( !checkToken() )
    return;
  }

  if( index !== srcStr.length )
  return;

  /**/

  return result;

  /**/

  function checkToken()
  {

    if( rindex !== -1 )
    {
      _.assert( rindex <= index );
      result.push( srcStr.substring( rindex, index ) );
      rindex = -1;
      return true;
    }

    return false;
  }

  /**/

  function checkMask( mask )
  {

    _.assert( _.strIs( mask ) || mask === strUnjoin.any, 'Expects string or strUnjoin.any, got', _.entity.strType( mask ) );

    if( _.strIs( mask ) )
    {
      index = srcStr.indexOf( mask, index );

      if( index === -1 )
      return false;

      if( rindex === -1 && index !== 0 )
      return false;

      checkToken();

      result.push( mask );
      index += mask.length;

    }
    else if( mask === strUnjoin.any )
    {
      rindex = index;
    }
    else _.assert( 0, 'unexpected mask' );

    return true;
  }

}

strUnjoin.any = _.any;
_.assert( _.routine.is( strUnjoin.any ) );

// --
// joiner
// --

/**
 * Routine _strDup() returns a string with the source string appended to itself n-times.
 * Expects two parameter: source string {-s-} ( or array of strings ) and number of concatenations {-times-}.
 * The string {-s-}  and the number {-times-} remain unchanged.
 *
 * @param { Array/String } s - Source array of strings or source string.
 * @param { Number } times - Number of concatenation cycles.
 *
 * @example
 * _.strDup( 'Word', 5 );
 * // returns WordWordWordWordWord
 *
 * @example
 * _.strDup( '1 '+'2', 2 );
 * // returns 1 21 2
 *
 * @example
 * _.strDup( [ 'ab', 'd', '3 4'], 2 );
 * // returns [ 'abab', 'dd', '3 43 4']
 *
 * @returns { String|Array } - Returns a string or an array of string containing the src string concatenated n-times.
 * @function strDup
 * @throws { Exception } If arguments.length is less or more then two.
 * @throws { Exception } If {-s-} is not a String or an array of strings.
 * @throws { Exception } If {-times-} is not a Number.
 * @namespace Tools
 */

function _strDup( s, times )
{
  let result = '';

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( s ) );
  _.assert( _.number.is( times ) );

  for( let t = 0 ; t < times ; t++ )
  result += s;

  return result;
}

//

/**
 * Joins objects inside the source array, by concatenating their values in order that they are specified.
 * The source array can contain strings, numbers and arrays. If arrays are provided, they must have same length.
 * Joins arrays by concatenating all elements with same index into one string and puts it into new array at same position.
 * Joins array with other object by concatenating each array element with that object value. Examples: ( [ [ 1, 2 ], 3 ] ) -> ( [ '13', '23' ] ),
 * ( [ [ 1, 2 ], [ 1, 2] ] ) -> ( [ '11', '22' ] ).
 * An optional second string argument can be passed to the function. This argument ( joiner ) defines the string that joins the
 * srcArray objects.  Examples: ( [ [ 1, 2 ], 3 ], '*' ) -> ( [ '1*3', '2*3' ] ),
 * ( [ [ 1, 2 ], [ 1, 2 ] ], ' to ' ) -> ( [ '1 to 1', '2 to 2' ] ).
 *
 * @param { Array-like } srcs - Source array with the provided objects.
 * @param { String } joiner - Optional joiner parameter.
 * @returns { Object } Returns concatenated objects as string or array. Return type depends from arguments type.
 *
 * @example
 * _.strJoin([ 1, 2, 3 ]);
 * // returns '123'
 *
 * @example
 * _.strJoin([ [ 1, 2, 3 ], 2 ]);
 * // returns [ '12', '22', '32' ]
 *
 * @example
 * _.strJoin([ [ 1, 2 ], [ 1, 3 ] ]);
 * // returns [ '11', '23' ]
 *
 * @example
 * _.strJoin([ 1, 2, [ 3, 4, 5 ], [ 6, 7, 8 ] ]);
 * // returns [ '1236', '1247', '1258' ]
 *
 * @example
 * _.strJoin([ 1, 2, [ 3, 4, 5 ], [ 6, 7, 8 ] ], ' ');
 * // returns [ '1 2 3 6', '1 2 4 7', '1 2 5 8' ]
 *
 * @method strJoin
 * @throws { Exception } If ( arguments.length ) is not one or two.
 * @throws { Exception } If some object from( srcs ) is not a Array, String or Number.
 * @throws { Exception } If length of arrays in srcs is different.
 * @throws { Exception } If ( joiner ) is not undefined or a string .
 * @namespace Tools
 *
 */

function strJoin_head( routine, args )
{

  let o = args[ 0 ];
  if( args[ 1 ] !== undefined || _.argumentsArray.like( args[ 0 ] ) )
  o = { srcs : args[ 0 ], join : ( args.length > 1 ? args[ 1 ] : null ) };

  _.routine.options( routine, o );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2, () => 'Expects an array of string and optional join, but got ' + args.length + ' arguments' );
  _.assert( _.argumentsArray.like( o.srcs ), () => 'Expects an array of strings, but got ' + _.entity.strType( o.srcs ) );
  _.assert( o.join === undefined || o.join === null || _.strIs( o.join ), () => 'Expects optional join, but got ' + _.entity.strType( o.join ) );

  return o;
}

//

/* xxx : review */
// function strJoin_body( srcs, delimeter )
function strJoin_body( o )
{
  // let result = [ '' ];
  // let arrayEncountered = 0;
  let arrayLength;

  _.routine.assertOptions( strJoin_body, arguments );

  let delimeter = o.join || '';
  if( o.join === null || o.join === undefined || _.strIs( o.join ) )
  o.join = join;

  // debugger;

  if( !o.srcs.length )
  return [];

  /* */

  for( let a = 0 ; a < o.srcs.length ; a++ )
  {
    let src = o.srcs[ a ];

    if( _.arrayIs( src ) )
    {
      _.assert( arrayLength === undefined || arrayLength === src.length, 'All arrays should have the same length' );
      arrayLength = src.length;
    }

  }

  if( arrayLength === 0 )
  return [];

  /* */

  if( arrayLength === undefined )
  {
    let result = '';

    for( let a = 0 ; a < o.srcs.length ; a++ )
    {
      let src = o.srcs[ a ];
      let srcStr = o.str( src );
      _.assert( _.strIs( srcStr ), () => 'Expects primitive or array, but got ' + _.entity.strType( src ) );
      result = o.join( result, srcStr, a );
    }

    return result;
  }
  else
  {

    let result = [];
    for( let i = 0 ; i < arrayLength ; i++ )
    result[ i ] = '';

    for( let a = 0 ; a < o.srcs.length ; a++ )
    {
      let src = o.srcs[ a ];

      // _.assert( _.strIs( srcStr ) || _.arrayIs( src ), () => 'Expects primitive or array, but got ' + _.entity.strType( src ) );
      // _.assert( _.strIs( src ) || _.number.is( src ) || _.arrayIs( src ) );

      if( _.arrayIs( src ) )
      {

        // if( arrayEncountered === 0 )
        // for( let s = 1 ; s < src.length ; s++ )
        // result[ s ] = result[ 0 ];

        // _.assert( arrayLength === undefined || arrayLength === src.length, 'All arrays should have the same length' );
        // arrayLength = src.length;

        // arrayEncountered = 1;
        for( let s = 0 ; s < result.length ; s++ )
        result[ s ] = o.join( result[ s ], src[ s ], a );

      }
      else
      {

        let srcStr = o.str( src );
        _.assert( _.strIs( srcStr ), () => 'Expects primitive or array, but got ' + _.entity.strType( src ) );
        for( let s = 0 ; s < result.length ; s++ )
        result[ s ] = o.join( result[ s ], srcStr, a );

      }

    }

    return result;
  }

  /* */

  /* qqq : investigate */

  if( arrayEncountered )
  return result;
  else
  return result[ 0 ];

  /* */

  function join( result, src, a )
  {
    if( delimeter && a > 0 )
    return result + delimeter + src;
    else
    return result + src;
  }

}

strJoin_body.defaults =
{
  srcs : null,
  join : null,
  str : _.entity.strPrimitive,
}

let strJoin = _.routine.unite( strJoin_head, strJoin_body );

//

/**
 * Routine strJoinPath() joins objects inside the source array, by concatenating their values in order that they are specified.
 * The source array can contain strings, numbers and arrays. If arrays are provided, they must have same length.
 * Joins arrays by concatenating all elements with same index into one string and puts it into new array at same position.
 * Joins array with other object by concatenating each array element with that object value.
 * Examples: ( [ [ 1, 2 ], 3 ], '' ) -> ( [ '13', '23' ] ), ( [ [ 1, 2 ], [ 1, 2] ] ) -> ( [ '11', '22' ], '' ).
 * Second argument should be string type. This argument ( joiner ) defines the string that joins the
 * srcArray objects.  Examples: ( [ [ 1, 2 ], 3 ], '*' ) -> ( [ '1*3', '2*3' ] ),
 * ( [ [ 1, 2 ], [ 1, 2 ] ], ' to ' ) -> ( [ '1 to 1', '2 to 2' ] ).
 * If the ( srcs ) objects has ( joiner ) at begin or end, ( joiner ) will be replaced. ( joiner ) replaced only between joined objects.
 * Example: ( [ '/11/', '//22//', '/3//' ], '/' ) --> '/11//22//3//'
 *
 * @param { Array-like } srcs - Source array with the provided objects.
 * @param { String } joiner - Joiner parameter.
 *
 * @example
 * _.strJoinPath( [ 1, 2, 3 ], '' );
 * // returns '123'
 *
 * @example
 * _.strJoinPath( [ [ '/a//', 'b', '//c//' ], 2 ], '/' );
 * // returns '/a//b//c//'
 *
 * @example
 * _.strJoinPath( [ [ 1, 2 ], [ 1, 3 ] ], '.');
 * // returns [ '1.1', '2.3' ]
 *
 * @example
 * _.strJoinPath( [ 1, 2, [ 3, 4, 5 ], [ 6, 7, 8 ] ], ',');
 * // returns [ '1,2,3,6', '1,2,4,7', '1,2,5,8' ]
 *
 * @method strJoinPath
 * @returns { String|Array-like } Returns concatenated objects as string or array. Return type depends from arguments type.
 * @throws { Exception } If ( arguments.length ) is less or more than two.
 * @throws { Exception } If some object from ( srcs ) is not a Array, String or Number.
 * @throws { Exception } If length of arrays in ( srcs ) is different.
 * @throws { Exception } If ( joiner ) is not a string.
 * @namespace Tools
 *
 */

function strJoinPath( srcs, joiner )
{
  let result = [ '' ];
  let arrayEncountered = 0;
  let arrayLength;

  _.assert( arguments.length === 2, () => 'Expects an array of string and joiner, but got ' + arguments.length + ' arguments' );
  _.assert( _.argumentsArray.like( srcs ), () => 'Expects an array of strings, but got ' + _.entity.strType( srcs ) );
  _.assert( _.strIs( joiner ), () => 'Expects joiner, but got ' + _.entity.strType( joiner ) );

  /* xxx : investigate */

  for( let a = 0 ; a < srcs.length ; a++ )
  {
    let src = srcs[ a ];

    _.assert( _.strIs( src ) || _.number.is( src ) || _.arrayIs( src ) );

    if( _.arrayIs( src ) )
    {

      if( arrayEncountered === 0 )
      {
        for( let s = 1 ; s < src.length ; s++ )
        result[ s ] = result[ 0 ];
      }

      _.assert( arrayLength === undefined || arrayLength === src.length, 'All arrays should have the same length' );
      arrayLength = src.length;

      arrayEncountered = 1;
      for( let s = 0 ; s < src.length ; s++ )
      join( src[ s ], s, a );

    }
    else
    {

      for( let s = 0 ; s < result.length ; s++ )
      join( src, s, a );

    }

  }

  if( arrayEncountered )
  return result;
  else
  return result[ 0 ];

  /* */

  function join( src, s, a )
  {
    if( _.number.is( src ) )
    src = src.toString();

    if( a > 0 && joiner )
    {
      let ends = _.strEnds( result[ s ], joiner );
      let begins = _.strBegins( src, joiner );
      if( begins && ends )
      result[ s ] = _.strRemoveEnd( result[ s ], joiner ) + src;
      else if( begins || ends )
      result[ s ] += src;
      else
      result[ s ] += joiner + src;
    }
    else
    {
      result[ s ] += src;
    }
  }
}

// --
// liner
// --

/**
 * Adds indentation character(s) to passed string.
 * If( src ) is a multiline string, function puts indentation character( tab ) before first
 * and every next new line in a source string( src ).
 * If( src ) represents single line, function puts indentation at the begining of the string.
 * If( src ) is a Array, function prepends indentation character( tab ) to each line( element ) of passed array.
 *
 * @param { String/Array } src - Source string to parse or array of lines( not array of texts ).
 * With line we mean it does not have eol. Otherwise please join the array to let the routine to resplit the text,
 * like that: _.strLinesIndentation( array.join( '\n' ), '_' ).
 * @param { String } tab - Indentation character.
 * @returns { String } Returns indented string.
 *
 * @example
 *  _.strLinesIndentation( 'abc', '_' )
 * // returns '_abc'
 *
 * @example
 * _.strLinesIndentation( 'a\nb\nc', '_' )
 * // returns
 * // _a
 * // _b
 * // _c
 *
 * @example
 * _.strLinesIndentation( [ 'a', 'b', 'c' ], '_' )
 * // returns
 * // _a
 * // _b
 * // _c
 *
 * @example
 * let array = [ 'a\nb', 'c\nd' ];
 * _.strLinesIndentation( array.join( '\n' ), '_' )
 * // returns
 * // _a
 * // _b
 * // _c
 * // _d
 *
 * @method strLinesIndentation
 * @throws { Exception } Throw an exception if( src ) is not a String or Array.
 * @throws { Exception } Throw an exception if( tab ) is not a String.
 * @throws { Exception } Throw an exception if( arguments.length ) is not a equal 2.
 * @namespace Tools
 *
 */

function strLinesIndentation( src, tab, every )
{

  if( every === undefined )
  every = true;

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( _.strIs( src ) || _.arrayIs( src ), 'Expects src as string or array' );
  _.assert( _.strIs( tab ) || _.number.is( tab ), 'Expects tab as string or number' );
  _.assert( every === undefined || _.bool.like( every ) );

  if( _.number.is( tab ) )
  tab = _.strDup( ' ', tab );

  if( _.strIs( src ) )
  {
    if( src.indexOf( '\n' ) === -1 )
    return src;
    src = _.str.lines.split( src );
  }

  /*
    should be no tab in prolog
  */

  if( every === true )
  {
    let result = src.join( '\n' + tab );
    return result;
  }
  else
  {
    let result = '';
    src.forEach( ( e, c ) =>
    {
      if( c > 0 )
      result += '\n';
      result += e.length > 0 && c > 0 ? tab + e : e;
    });
    return result;
  }
}

//

/**
 * Routine strLinesBut() replaces a range {-range-} of lines in source string {-src-} to new
 * values in {-ins-} parameter.
 *
 * @param { String|Long } src - Source string or array of strings.
 * If {-src-} is a String, then it split to parts using delimeter '\n'.
 * @param { Range|Number } range - Range of lines to be replaced.
 * If {-range-} is a Number, then routine replace only one line defined by value of {-range-}.
 * @param { String|Long } ins - String or array of strings to be inserted in source string.
 * If {-ins-} is a Long, then elements of Long concatenates using delimeter '\n'.
 * If range[ 0 ] or range[ 1 ] is less than zero, then routine count lines from the end of {-src-}.
 *
 * @example
 * _.strLinesBut( 'ab \n bc \n cd \n de', 1 );
 * // returns 'ab \n cd \n de'
 *
 * @example
 * _.strLinesBut( 'ab \n bc \n cd \n de', -1 );
 * // returns 'ab \n bc \n cd '
 *
 * @example
 * _.strLinesBut( 'ab \n bc \n cd \n de', [ 1, 4 ], '' );
 * // returns 'ab '
 *
 * @example
 * _.strLinesBut( 'ab \n bc \n cd \n de', [ 1, -1 ], '' );
 * // returns 'ab \n de'
 *
 * @example
 * _.strLinesBut( 'ab \n bc \n cd \n de', 1, ' some \n string ' );
 * // returns 'ab \n some \n string \n cd \n de'
 *
 * @example
 * _.strLinesBut( 'ab \n bc \n cd \n de', -1, ' some \n string ' );
 * // returns 'ab \n bc \n cd \n some \n string '
 *
 * @example
 * _.strLinesBut( 'ab \n bc \n cd \n de', [ 1, 4 ], [ ' some ', ' string' ] );
 * // returns 'ab \n some \n string'
 *
 * @example
 * _.strLinesBut( 'ab \n bc \n cd \n de', [ 1, -1 ], [ ' some ', ' string' ] );
 * // returns 'ab \n some \n string\n de'
 *
 * @example
 * _.strLinesBut( [ 'ab ', ' bc ', ' cd ', ' de' ], 1, ' some \n string ' );
 * // returns 'ab \n some \n string \n cd \n de'
 *
 * @example
 * _.strLinesBut( [ 'ab ', ' bc ', ' cd ', ' de' ], -1, ' some \n string ' );
 * // returns 'ab \n bc \n cd \n some \n string '
 *
 * @example
 * _.strLinesBut( [ 'ab ', ' bc ', ' cd ', ' de' ], [ 1, 4 ], [ ' some ', ' string' ] );
 * // returns 'ab \n some \n string'
 *
 * @example
 * _.strLinesBut( [ 'ab ', ' bc ', ' cd ', ' de' ], [ 1, -1 ], [ ' some ', ' string' ] );
 * // returns 'ab \n some \n string\n de'
 *
 * @returns { String } - Returns string concatenated from original source string and inserted values.
 * @function strLinesBut
 * @throws { Exception } If arguments.length is less then two or more then three.
 * @throws { Exception } If {-src-} is not a String or a Long.
 * @throws { Exception } If {-ins-} is not a String, not a Long, not undefined.
 * @namespace Tools
 */

function strLinesBut( src, range, ins )
{

  if( _.strIs( src ) )
  src = _.str.lines.split( src );

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( _.longIs( src ) );
  _.assert( ins === undefined || _.strIs( ins ) || _.longIs( ins ) );
  // _.assert( !_.longIs( ins ), 'not implemented' );

  if( _.number.is( range ) )
  {
    if( range < 0 )
    range = src.length + range;
    range = [ range, range + 1 ];
  }

  if( range[ 1 ] < 0 )
  range[ 1 ] = src.length + range[ 1 ];

  _.assert( _.intervalIs( range ) );

  /*
    aaa : should work
    _.strLinesBut( _.strLinesBut( got1, 0 ), -1 )

    Dmytro : works
  */

  /*
    aaa : implement not implemented
    Dmytro : implemented
  */

  let range2 = [ range[ 0 ], range[ 1 ] - 1 ]
  /* qqq for Dmtro : check and improve code */

  if( _.longIs( ins ) )
  return _.longBut_( null, src, range2, ins ).join( '\n' );
  else if( _.strIs( ins ) )
  return _.longBut_( null, src, range2, [ ins ] ).join( '\n' );
  else
  return _.longBut_( null, src, range2 ).join( '\n' );

  // if( _.longIs( ins ) )
  // return _.longBut( src, range, ins ).join( '\n' );
  // else if( _.strIs( ins ) )
  // return _.longBut( src, range, [ ins ] ).join( '\n' );
  // else
  // return _.longBut( src, range ).join( '\n' );

  // if( ins )
  // {
  //   _.assert( _.strIs( ins ) );
  //   return _.longBut( src, range, [ ins ] ).join( '\n' );
  // }
  // else
  // {
  //   return _.longBut( src, range ).join( '\n' );
  // }

}

//

/**
 * Routine strLinesOnly() selects a range {-range-} of lines in source string {-src-} and returns
 * new string joined from it.
 *
 * @param { String|Long } src - Source string or array of strings.
 * If {-src-} is a String, then it split to parts using delimeter '\n'.
 * @param { Range|Number } range - Range of lines to be selected.
 * If {-range-} is a Number, then routine selects only one line defined by value of {-range-}.
 * If range[ 0 ] or range[ 1 ] is less than zero, then routine count lines from the end of {-src-}.
 *
 * @example
 * _.strLinesOnly( 'ab \n bc \n cd \n de', 1 );
 * // returns ' bc '
 *
 * @example
 * _.strLinesOnly( 'ab \n bc \n cd \n de', -1 );
 * // returns ' de'
 *
 * @example
 * _.strLinesOnly( 'ab \n bc \n cd \n de', [ 1, 4 ] );
 * // returns ' bc \n cd \n de'
 *
 * @example
 * _.strLinesOnly( 'ab \n bc \n cd \n de', [ 1, -1 ] );
 * // returns ' bc \n cd '
 *
 * @example
 * _.strLinesOnly( [ 'ab ', ' bc ', ' cd ', ' de' ], 1 );
 * // returns ' bc '
 *
 * @example
 * _.strLinesOnly( [ 'ab ', ' bc ', ' cd ', ' de' ], -1 );
 * // returns ' de'
 *
 * @example
 * _.strLinesOnly( [ 'ab ', ' bc ', ' cd ', ' de' ], [ 1, 4 ] );
 * // returns ' bc \n cd \n de'
 *
 * @example
 * _.strLinesOnly( [ 'ab ', ' bc ', ' cd ', ' de' ], [ 1, -1 ] );
 * // returns ' bc \n cd '
 *
 * @returns { String } - Returns a range of lines from source string concatenated by new line symbol.
 * @function strLinesOnly
 * @throws { Exception } If arguments.length is less then two or more then three.
 * @throws { Exception } If {-src-} is not a String or a Long.
 * @namespace Tools
 */

function strLinesOnly( src, range )
{

  if( _.strIs( src ) )
  src = _.str.lines.split( src );

  _.assert( arguments.length === 2 );
  _.assert( _.longIs( src ) );

  if( _.number.is( range ) )
  range = [ range, range + 1 ];
  if( range[ 0 ] < 0 )
  range[ 0 ] = src.length >= -range[ 0 ] ? src.length + range[ 0 ] : 0
  if( range[ 1 ] < 0 )
  range[ 1 ] = src.length + range[ 1 ];

  _.assert( _.intervalIs( range ) );

  let result = [];
  for( let i = range[ 0 ]; i < range[ 1 ] && i < src.length; i++ )
  result[ i - range[ 0 ] ] = src[ i ];

  return result.join( '\n' );

}

//

/**
 * Puts line counter before each line/element of provided source( o.src ).
 * If( o.src ) is a string, function splits it into array using new line as splitter, then puts line counter at the beginning of each line( element ).
 * If( o.src ) is a array, function puts line counter at the beginning of each line( element ).
 * Initial value of a counter can be changed by defining( o.first ) options( o ) property.
 * Can be called in two ways:
 * - First by passing all options in one object;
 * - Second by passing source only and using default value of( first ).
 *
 * @param { Object } o - options.
 * @param { String/Array } [ o.src=null ] - Source string or array of lines( not array of texts ).
 * With line we mean it does not have EOF. Otherwise please join the array to let the routine to resplit the text,
 * like that: _.strLinesNumber( array.join( '\n' ) ).
 * @param { Number} [ o.first=1 ] - Sets initial value of a counter.
 * @returns { String } Returns string with line enumeration.
 *
 * @example
 * _.strLinesNumber( 'line' );
 * // returns '1 : line'
 *
 * @example
 * _.strLinesNumber( 'line1\nline2\nline3' );
 * // returns
 * // 1: line1
 * // 2: line2
 * // 3: line3
 *
 * @example
 * _.strLinesNumber( [ 'line', 'line', 'line' ] );
 * // returns
 * // 1: line1
 * // 2: line2
 * // 3: line3
 *
 * @example
 * _.strLinesNumber( { src:'line1\nline2\nline3', zeroLine : 2 } );
 * // returns
 * // 2: line1
 * // 3: line2
 * // 4: line3
 *
 * @method strLinesNumber
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o.src ) is not a String or Array.
 * @namespace Tools
 */

function strLinesNumber( o )
{

  if( !_.object.isBasic( o ) )
  o = { src : arguments[ 0 ], zeroLine : ( arguments.length > 1 ? arguments[ 1 ] : null ) };

  _.routine.options( strLinesNumber, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( o.src ) || _.strsAreAll( o.src ), 'Expects string or strings {-o.src-}' );

  /* */

  if( o.zeroLine === null )
  {
    if( o.zeroChar === null )
    {
      o.zeroLine = 1;
    }
    else if( _.number.is( o.zeroChar ) )
    {
      let src = _.arrayIs( o.src ) ? o.src.join( '\n' ) : o.src;
      o.zeroLine = _.strLinesCount( src.substring( 0, o.zeroChar+1 ) );
    }
  }

  /* */

  let lines = _.strIs( o.src ) ? _.str.lines.split( o.src ) : o.src;

  /* */

  let maxNumberLength = String( lines.length - 1 + o.zeroLine ).length;
  let zeroLineLength = String( o.zeroLine ).length;
  let maxNumLength = maxNumberLength > zeroLineLength ? maxNumberLength : zeroLineLength;

  if( o.onLine )
  for( let l = 0; l < lines.length; l += 1 )
  {
    let numLength = String( l + o.zeroLine ).length;

    lines[ l ] = o.onLine( [ ' '.repeat( maxNumLength - numLength ), ( l + o.zeroLine ), ' : ', lines[ l ] ], o.zeroLine + l, o );
    if( lines[ l ] === undefined )
    {
      lines.splice( l, 1 );
      l -= 1;
    }
    _.assert( _.strIs( lines[ l ] ) );
  }
  else
  for( let l = 0; l < lines.length; l += 1 )
  {
    let numLength = String( l + o.zeroLine ).length;
    lines[ l ] = ' '.repeat( maxNumLength - numLength ) + ( l + o.zeroLine ) + ' : ' + lines[ l ];
  }
  if( o.highlightingToken && o.highlighting )
  {
    let results;

    _.assert( o.highlighting === null || _.number.is( o.highlighting ) || _.longIs( o.highlighting ), 'Expects number or array of numbers {-o.highlighting-}' );

    if( !_.arrayIs( o.highlighting ) )
    {
      if( o.highlighting > o.zeroLine + lines.length - 1 || o.highlighting < o.zeroLine )
      return lines.join( '\n' );
    }

    results = lines.map( ( el ) =>
    {
      if( _.arrayIs( o.highlighting ) )
      return o.highlighting.includes( parseInt( el, 10 ) ) ? '' + o.highlightingToken + ' ' + el : '' + ' '.repeat( o.highlightingToken.length + 1 ) + el;
      else
      return ( '' + o.highlighting ).includes( parseInt( el, 10 ) ) ? '' + o.highlightingToken + ' ' + el : '' + ' '.repeat( o.highlightingToken.length + 1 ) + el;
    } )

    if( JSON.stringify( lines ) === JSON.stringify( results.map( ( el ) => el.trim() ) ) )
    return lines.join( '\n' );

    return results.join( '\n' );

  }

  return lines.join( '\n' );
}

strLinesNumber.defaults =
{
  src : null,
  zeroLine : null,
  zeroChar : null,
  onLine : null,
  highlighting : null,
  highlightingToken : '*', /* qqq : if null then highlighting is off */
}

/* qqq2 : implement and cover option o.highlighting

_.strLinesNumber({ src, highlighting : 867 });

//   863 : 7 : Last one
//   864 : + replace 5 in ${ a.abs( 'before/File2.js' ) }
//   865 : Done 1 action(s). Thrown 0 error(s).
//   866 : `
// * 867 :     test.equivalent( op.output, exp );

_.strLinesNumber({ src, highlighting : 867, highlightingToken : '-->' });

//     863 : 7 : Last one
//     864 : + replace 5 in ${ a.abs( 'before/File2.js' ) }
//     865 : Done 1 action(s). Thrown 0 error(s).
//     866 : `
// --> 867 :     test.equivalent( op.output, exp );

_.strLinesNumber({ src, highlighting : [ 865, 867 ] });

//   863 : 7 : Last one
//   864 : + replace 5 in ${ a.abs( 'before/File2.js' ) }
// * 865 : Done 1 action(s). Thrown 0 error(s).
//   866 : `
// * 867 :     test.equivalent( op.output, exp );

*/

//

/**
 * Selects range( o.range ) of lines from source string( o.src ).
 * If( o.range ) is not specified and ( o.line ) is provided function uses it with ( o.selectMode ) option to generate new range.
 * If( o.range ) and ( o.line ) are both not provided function generates range by formula: [ 0, n + 1 ], where n: number of ( o.delimteter ) in source( o.src ).
 * Returns selected lines range as string or empty string if nothing selected.
 * Can be called in three ways:
 * - First by passing all parameters in one options map( o ) ;
 * - Second by passing source string( o.src ) and range( o.range ) as array or number;
 * - Third by passing source string( o.src ), range start and end position.
 *
 * @param {Object} o - Options.
 * @param {String} [ o.src=null ] - Source string.
 * @param {Array|Number} [ o.range=null ] - Sets range of lines to select from( o.src ) or single line number.
 * @param {Number} [ o.zero=1 ] - Sets base value for a line counter.
 * @param {Number} [ o.number=0 ] - If true, puts line counter before each line by using o.range[ 0 ] as initial value of a counter.
 * @param {String} [ o.delimteter='\n' ] - Sets new line character.
 * @param {String} [ o.line=null ] - Sets line number from which to start selecting, is used only if ( o.range ) is null.
 * @param {Number} [ o.nearestLines=3 ] - Sets maximal number of lines to select, is used only if ( o.range ) is null and ( o.line ) option is specified.
 * @param {String} [ o.selectMode='center' ] - Determines in what way funtion must select lines, works only if ( o.range ) is null and ( o.line ) option is specified.
 * Possible values:
 * - 'center' - uses ( o.line ) index as center point and selects ( o.nearestLines ) lines in both directions.
 * - 'begin' - selects ( o.nearestLines ) lines from start point ( o.line ) in forward direction;
 * - 'end' - selects ( o.nearestLines ) lines from start point ( o.line ) in backward direction.
 * @returns {string} Returns selected lines as new string or empty if nothing selected.
 *
 * @example
 * // selecting single line
 * _.strLinesSelect( 'a\nb\nc', 1 );
 * // returns 'a'
 *
 * @example
 * // selecting first two lines
 * _.strLinesSelect( 'a\nb\nc', [ 1, 3 ] );
 * // returns
 * // 'a
 * // b'
 *
 * @example
 * // selecting first two lines, second way
 * _.strLinesSelect( 'a\nb\nc', 1, 3 );
 * // returns
 * // 'a
 * // b'
 *
 * @example
 * // custom new line character
 * _.strLinesSelect({ src : 'a b c', range : [ 1, 3 ], delimteter : ' ' });
 * // returns 'a b'
 *
 * @example
 * // setting preferred number of lines to select, line option must be specified
 * _.strLinesSelect({ src : 'a\nb\nc', line : 2, nearestLines : 1 });
 * // returns 'b'
 *
 * @example
 * // selecting 2 two next lines starting from second
 * _.strLinesSelect({ src : 'a\nb\nc', line : 2, nearestLines : 2, selectMode : 'begin' });
 * // returns
 * // 'b
 * // c'
 *
 * @example
 * // selecting 2 two lines starting from second in backward direction
 * _.strLinesSelect({ src : 'a\nb\nc', line : 2, nearestLines : 2, selectMode : 'end' });
 * // returns
 * // 'a
 * // b'
 *
 * @method strLinesSelect
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @throws { Exception } Throw an exception if( o.range ) is not a Array or Number.
 * @throws { Exception } Throw an exception if( o ) is extended by unknown property.
 * @namespace Tools
 */

function strLinesSelect( o )
{

  if( arguments.length === 2 )
  {

    if( _.arrayIs( arguments[ 1 ] ) )
    o = { src : arguments[ 0 ], range : arguments[ 1 ] };
    else if( _.number.is( arguments[ 1 ] ) )
    o = { src : arguments[ 0 ], range : [ arguments[ 1 ], arguments[ 1 ]+1 ] };
    else _.assert( 0, 'unexpected argument', _.entity.strType( range ) );

  }
  else if( arguments.length === 3 )
  {
    o = { src : arguments[ 0 ], range : [ arguments[ 1 ], arguments[ 2 ] ] };
  }

  _.routine.options( strLinesSelect, o );
  _.assert( arguments.length <= 3 );
  _.assert( _.strIs( o.src ) );
  _.assert( _.bool.like( o.highlighting ) || _.longHas( [ '*' ], o.highlighting ) );

  if( _.bool.like( o.highlighting ) && o.highlighting )
  o.highlighting = '*';

  /* range */

  if( !o.range )
  {
    if( o.line === null )
    {
      o.range = [ 0, _.strCount( o.src, o.delimteter )+1 ];
    }
    else
    {
      if( o.selectMode === 'center' )
      o.range = [ o.line - Math.ceil( ( o.nearestLines + 1 ) / 2 ) + 1, o.line + Math.floor( ( o.nearestLines - 1 ) / 2 ) + 1 ];
      else if( o.selectMode === 'begin' )
      o.range = [ o.line, o.line + o.nearestLines ];
      else if( o.selectMode === 'end' )
      o.range = [ o.line - o.nearestLines+1, o.line+1 ];
    }
    // if( o.line !== null )
    // {
    //   if( o.selectMode === 'center' )
    //   o.range = [ o.line - Math.ceil( ( o.nearestLines + 1 ) / 2 ) + 1, o.line + Math.floor( ( o.nearestLines - 1 ) / 2 ) + 1 ];
    //   else if( o.selectMode === 'begin' )
    //   o.range = [ o.line, o.line + o.nearestLines ];
    //   else if( o.selectMode === 'end' )
    //   o.range = [ o.line - o.nearestLines+1, o.line+1 ];
    // }
    // else
    // {
    //   o.range = [ 0, _.strCount( o.src, o.delimteter )+1 ];
    // }
  }

  if( o.line === null )
  {
    if( o.selectMode === 'center' )
    o.line = Math.floor( ( o.range[ 0 ] + o.range[ 1 ] ) / 2 );
    else if( o.selectMode === 'begin' )
    o.line = o.range[ 0 ];
    else if( o.selectMode === 'end' )
    o.line = o.range[ 1 ] - 1;

    o.line = o.line > 0 ? o.line : 1;
  }

  _.assert( _.longIs( o.range ) );
  _.assert( _.intIs( o.line ) && o.line >= 0, 'Expects positive integer {-o.line-}.' );

  /* */

  let f = 0;
  let counter = o.zeroLine;
  while( counter < o.range[ 0 ] )
  {
    f = o.src.indexOf( o.delimteter, f );
    if( f === -1 )
    return '';
    f += o.delimteter.length;
    counter += 1;
  }

  /* */

  let l = f-1;
  while( counter < o.range[ 1 ] )
  {
    l += 1;
    l = o.src.indexOf( o.delimteter, l );
    if( l === -1 )
    {
      l = o.src.length;
      break;
    }
    counter += 1;
  }

  /* */

  let result = f < l ? o.src.substring( f, l ) : '';

  /* numbering */

  let zeroLine = o.range[ 0 ] <= 0 ? o.zeroLine : o.range[ 0 ];

  if( o.numbering && result.length )
  result = _.strLinesNumber
  ({
    src : result,
    zeroLine,
    onLine : lineHighlight,
  });

  return result;

  /* */

  function lineHighlight( line, l )
  {
    if( !o.highlighting )
    return line.join( '' );
    if( l === o.line )
    line[ 0 ] = '* ' + line[ 0 ];
    else
    line[ 0 ] = '  ' + line[ 0 ];
    // line[ 1 ] = _.strBut( line[ 1 ], 0, '*' );
    return line.join( '' );
  }

  /* */

}

strLinesSelect.defaults =
{

  src : null,
  range : null,

  line : null,
  nearestLines : 3,
  selectMode : 'center',
  highlighting : '*',

  numbering : 0,
  zeroLine : 1,
  delimteter : '\n',

}

/* aaa :
- cover option highlighting
Dmytro : covered
- cover option zeroLine
Dmytro : covered
*/

//

/**
 *
 * Get the nearest ( o.nearestLines ) lines to the range ( o.charsRangeLeft ) from source string( o.src ).
 * Returns object with two elements: .
 * Can be called in two ways:
 * - First by passing all parameters in one options map( o ) ;
 * - Second by passing source string( o.src ) and range( o.range ) as array or number;

 * The routine strLinesNearest returns the nearest {-o.numberOfLines-} lines to the range {-o.charsRangeLeft-} from source string {-o.src-}.
 * Returns object with two elements: splits - array with a substring & the nearest lines and spans - array of indexes of the nearest lines.
 * Can be called in two ways:
 * - First by passing all parameters in one options map {-o-} ;
 * - Second by passing source string {-o.src-} and range {-o.range-} as array or number;

 *
 * @example
 * // selecting single line
 * _.strLinesNearest
 * ({
 *   src : `\na\nbc\ndef\nghij\n\n`,
 *   charsRangeLeft : [ 2, 4 ],
 *   nearestLines : 1,
 * });
 * // returns o.splits = [ 'a', '\nb', 'c' ];
 * // returns o.spans = [ 1, 2, 4, 5 ];
 *
 * @example
 * // selecting single line
 * _.strLinesNearest
 * ({
 *   src : `\na\nbc\ndef\nghij\n\n`,
 *   charsRangeLeft : 3,
 *   nearestLines : 2,
 * });
 * // returns o.splits = [ 'a\n', 'b', 'c' ];
 * // returns o.spans = [ 1, 3, 4, 5 ];
 *
 * @returns { Aux } - Returns object with next fields:
 * splits - Array with three entries:
 * splits[ 0 ] and splits[ 2 ] contains a string with the nearest lines,
 * and splits[ 1 ] contains the substring corresponding to the range.
 * spans - Array with indexes of begin and end of nearest lines.
 * @param { Aux } o - Options.
 * @param { String } o.src - Source string.
 * @param { Array|Number } o.range - Sets range of lines to select from {-o.src-} or single line number.
 * @param { Number } o.numberOfLines - Sets number of lines to select.
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if {-o.src-} is not a String.
 * @throws { Exception } Throw an exception if {-o.charsRangeLeft-} is not a Array or Number.
 * @throws { Exception } Throw an exception if {-o-} is extended by unknown property.
 * @function strLinesNearest
 * @namespace Tools
 */

function strLinesNearest_head( routine, args )
{

  let o = args[ 0 ];
  if( args[ 1 ] !== undefined )
  o = { src : args[ 0 ], charsRangeLeft : args[ 1 ] };

  _.routine.options( routine, o );

  if( _.number.is( o.charsRangeLeft ) )
  o.charsRangeLeft = [ o.charsRangeLeft, o.charsRangeLeft+1 ];

  _.assert( _.intervalIs( o.charsRangeLeft ) );
  _.assert( _.numberIs( o.nearestLines ) );

  return o;
}

//

function strLinesNearest_body( o )
{
  let result = Object.create( null );
  // let resultCharRange = [];
  let i, nearestLines;

  result.splits = [];
  result.spans = [ o.charsRangeLeft[ 0 ], o.charsRangeLeft[ 0 ], o.charsRangeLeft[ 1 ], o.charsRangeLeft[ 1 ] ];

  // logger.log( 'Result', result )
  // logger.log( )
  // /* */

  if( o.nearestLines === 0 )
  {
    // result = [];
    result.splits = [];
    result.splits[ 0 ] = '';
    result.splits[ 1 ] = o.src.substring( o.charsRangeLeft[ 0 ], o.charsRangeLeft[ 1 ] );
    result.splits[ 2 ] = '';
    return result;
  }

  /* */

  let nearestLinesLeft = Math.ceil( ( o.nearestLines+1 ) / 2 );
  nearestLines = nearestLinesLeft;
  if( nearestLines > 0 )
  {
    for( i = o.charsRangeLeft[ 0 ]-1 ; i >= 0 ; i-- )
    {
      if( o.src[ i ] === '\n' )
      nearestLines -= 1;
      if( nearestLines <= 0 )
      break;
    }
    i = i+1;
  }
  result.spans[ 0 ] = i;

  /*
    // 0 -> 0 + 0 = 0
    // 1 -> 1 + 1 = 2
    // 2 -> 2 + 1 = 3
    // 3 -> 2 + 2 = 4
  */

  /* */

  let nearestLinesRight = o.nearestLines + 1 - nearestLinesLeft;
  nearestLines = nearestLinesRight;
  if( nearestLines > 0 )
  {
    for( i = o.charsRangeLeft[ 1 ] ; i < o.src.length ; i++ )
    {
      if( o.src[ i ] === '\n' )
      nearestLines -= 1;
      if( nearestLines <= 0 )
      break;
    }
  }
  result.spans[ 3 ] = i;

  /* */

  result.splits[ 0 ] = o.src.substring( result.spans[ 0 ], result.spans[ 1 ] );
  result.splits[ 1 ] = o.src.substring( result.spans[ 1 ], result.spans[ 2 ] );
  result.splits[ 2 ] = o.src.substring( result.spans[ 2 ], result.spans[ 3 ] );

  // result.splits[ 0 ] = o.src.substring( resultCharRange[ 0 ], o.charsRangeLeft[ 0 ] );
  // result.splits[ 1 ] = o.src.substring( o.charsRangeLeft[ 0 ], o.charsRangeLeft[ 1 ] );
  // result.splits[ 2 ] = o.src.substring( o.charsRangeLeft[ 1 ], resultCharRange[ 1 ] );

  return result;
}

strLinesNearest_body.defaults =
{
  src : null,
  charsRangeLeft : null,
  nearestLines : 3,
  // outputFormat : 'map',
}

let strLinesNearest = _.routine.unite( strLinesNearest_head, strLinesNearest_body );

//

/**
 * The routine strLinesNearestLog returns a report about found string from the source string {-o.src-}.
 * Returns object with 2 elements: nearest - array with a substring & the nearest lines around, report - string with the found substring & surrounding lines.
 *
 * @example
 * // selecting first 5 letters, next 3 letters and rest letters
 * _.strLinesNearestLog
 * ({
 *   src : 'function add( x,y ) { return x + y }',
 *   charsRangeLeft : [ 5, 8 ],
 *   gray : 1,
 *   numberOfLines : 1
 * });
 * // returns {
 * //           nearest : [ 'funct', 'ion', ' add( x,y ) { return x + y }' ],
 * //           report : '1 : function add( x,y ) { return x + y }'
 * //         }
 *
 * @returns { Aux } - Returns object with next fileds:
 *    nearest { Array } - 3 elements: 1 - lines to the left of charsRangeLeft if {-numberOfLines-} allows, 2 - chars in range {-o.charsRangeLeft-}, 3 - lines to the right of {-o.charsRangeLeft-} if {-numberOfLines-} allows.
 *    report { String } - report about found string along with surrounding lines {-numberOfLines-}
 * @param { Aux } o - Options.
 * @param { String } o.src - Source string.
 * @param { Array|Number } o.charsRangeLeft - Sets range of lines to select from {-o.src-} or single line number.
 * @param { Number } o.numberOfLines - Sets number of lines to select.
 * @param { Number } o.gray - 0: Paints searched text in yellow, everything else in gray, 1: No highlighting
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if {-o.src-} is not a String.
 * @throws { Exception } Throw an exception if {-o.charsRangeLeft-} is not a Array or Number.
 * @throws { Exception } Throw an exception if {-o-} is extended by unknown property.
 * @function strLinesNearestLog
 * @namespace Tools
*/

function strLinesNearestLog_body( o )
{
  let result = o;

  _.assert( o.charsRangeLeft[ 0 ] >= 0 && o.charsRangeLeft[ 1 ] >= 0, 'Expects positive ranges' );
  _.assert
  (
    o.charsRangeLeft[ 0 ] <= o.src.length && o.charsRangeLeft[ 1 ] <= o.src.length,
    'Expects valid range for source string {-o.src-}'
  );
  _.assert( o.sub === null || _.strIs( o.sub ) );

  if( o.charsRangeLeft[ 0 ] > o.charsRangeLeft[ 1 ] )
  o.charsRangeLeft[ 1 ] = o.charsRangeLeft[ 0 ];

  if( !result.nearest )
  result.nearest = _.strLinesNearest.body( o ).splits;

  result.log = result.nearest.slice();
  if( o.gray )
  {
    if( o.sub !== null )
    result.log[ 1 ] = `{- ${result.log[ 1 ]} -} -> {- ${o.sub} -}`;
  }
  else
  {
    let str;
    if( o.sub === null )
    str = _.color.strFormat( result.log[ 1 ], { fg : 'yellow' } );
    else
    str = _.color.strFormat( result.log[ 1 ], { fg : 'red' } ) + _.color.strFormat( o.sub, { fg : 'green' } );
    result.log[ 1 ] = _.color.strUnescape( str );
  }
  result.log = result.log.join( '' );

  result.log = _.strLinesSplit( result.log );
  if( !o.gray )
  result.log = _.color.strEscape( result.log );

  let left = o.src.substring( 0, o.charsRangeLeft[ 0 ] );
  // ---- BUG
  // let zeroLine = left ? _.strLinesCount( left ) : 1;
  // ----

  // ---- FIX (Yevhen S.)
  let zeroLine;
  if( left )
  {
    let linesNum = _.strLinesCount( left )
    if( linesNum <= 1 )
    zeroLine = 1;
    else
    zeroLine = linesNum - ( Math.floor( o.nearestLines / 2 ) ) <= 0 ? 1 : linesNum - ( Math.floor( o.nearestLines / 2 ) );
  }
  else
  {
    zeroLine = 1
  }
  // ----

  result.log = _.strLinesNumber
  ({
    src : result.log,
    zeroLine,
    onLine : ( line ) =>
    {
      if( !o.gray )
      {
        line[ 0 ] = _.color.strFormat( line[ 0 ], { fg : 'bright black' } );
        line[ 1 ] = _.color.strFormat( line[ 1 ], { fg : 'bright black' } );
      }
      return line.join( '' );
    }
  });

  return result;
}

strLinesNearestLog_body.defaults =
{
  src : null,
  sub : null,
  nearest : null, /* qqq2 : cover the option */
  charsRangeLeft : null,
  nearestLines : 3,
  gray : 0,
}

let strLinesNearestLog = _.routine.unite( strLinesNearest_head, strLinesNearestLog_body );

//

/**
 * Returns a count of lines in a string.
 * Expects one object: the string( src ) to be processed.
 *
 * @param {string} src - Source string.
 * @returns {number} Returns a number of lines in string.
 *
 * @example
 * _.strLinesCount( 'first\nsecond' );
 * // returns 2
 *
 * @example
 * _.strLinesCount( 'first\nsecond\nthird\n' );
 * // returns 4
 *
 * @method strLinesCount
 * @throws { Exception } Throw an exception if( src ) is not a String.
 * @throws { Exception } Throw an exception if no argument provided.
 * @namespace Tools
 *
*/

function strLinesCount( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) );
  let result = src.indexOf( '\n' ) === -1 ? 1 : _.str.lines.split( src ).length;
  return result;
}

//

function strLinesSize( o )
{
  let lines;

  if( !_.mapIs( o ) )
  o = { src : arguments[ 0 ] }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.src ) || _.argumentsArray.like( o.src ) );
  _.routine.options( strLinesSize, o );
  if( o.onLength === null )
  o.onLength = ( src ) => src.length;

  if( _.strIs( o.src ) )
  {
    if( o.onLength( o.src ) === '' )
    return [ 0, 0 ];
    if( o.src.indexOf( '\n' ) === -1 )
    return [ 1, o.onLength( o.src ) ];
    lines = _.str.lines.split( o.src );
  }
  else
  {
    lines = o.src;
    if( lines.length === 0 )
    return [ 0, 0 ];
    else if( lines.length === 1 && lines[ 0 ] === '' )
    return [ 0, 0 ];
  }

  let w = lines.reduce( ( a, e ) => Math.max( a, o.onLength( e ) ), 0 );

  return [ lines.length, w ];
}

strLinesSize.defaults =
{
  src : null,
  onLength : null,
}

//

function strLinesRangeWithCharRange_head( routine, args )
{

  let o = args[ 0 ];
  if( args[ 1 ] !== undefined )
  o = { src : args[ 0 ], charsRangeLeft : args[ 1 ] }

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( _.intervalIs( o.charsRangeLeft ) );
  _.assert( _.strIs( o.src ) );
  _.routine.options( routine, o );

  return o;
}

//

function strLinesRangeWithCharRange_body( o )
{

  let head = o.src.substring( 0, o.charsRangeLeft[ 0 ] );
  let mid = o.src.substring( o.charsRangeLeft[ 0 ], o.charsRangeLeft[ 1 ] + 1 );
  let result = []

  result[ 0 ] = _.strLinesCount( head )-1;
  result[ 1 ] = result[ 0 ] + _.strLinesCount( mid );

  return result;
}

strLinesRangeWithCharRange_body.defaults =
{
  src : null,
  charsRangeLeft : null,
}

let strLinesRangeWithCharRange = _.routine.unite( strLinesRangeWithCharRange_head, strLinesRangeWithCharRange_body );

// --
// declare
// --

let Proto =
{

  // dichotomy

  strIsHex,
  strIsMultilined,

  strHasAny,
  strHasAll,
  strHasNone,
  strHasSeveral,

  strsAnyHas,
  strsAllHas,
  strsNoneHas,

  // evaluator

  strCount,
  strStripCount,
  strsShortest,
  strsLongest,

  // replacer

  _strRemoved,
  strRemove,

  // strPrependOnce,
  // strAppendOnce,

  strReplaceWords,

  // etc

  strCommonLeft,
  strCommonRight,
  strRandom,
  strAlphabetFromRange,

  // formatter

  strForRange, /* xxx : investigate */
  strForCall, /* xxx : investigate */
  strDifference,

  // transformer

  strCapitalize,
  strDecapitalize,
  strSign,
  strDesign,
  strIsSigned,

  strEscape,
  strCodeUnicodeEscape,
  strUnicodeEscape,
  strReverse,

  // splitter

  strSplitStrNumber, /* experimental */
  strSplitChunks, /* experimental */

  strSplitCamel,

  // extractor

  _strOnly,
  strOnly,
  _strBut,
  strBut,
  strUnjoin,

  // joiner

  _strDup,
  strDup : _.vectorize( _strDup ),
  strJoin,
  strJoinPath,

  // liner

  strLinesIndentation,
  strLinesBut,
  strLinesOnly,

  // strLinesSplit,
  // strLinesJoin,
  // strLinesStrip,

  strLinesNumber,
  strLinesSelect,
  strLinesNearest,
  strLinesNearestLog,
  strLinesCount,
  strLinesSize, /* qqq2 : cover */
  strLinesRangeWithCharRange,

}

_.props.extend( _, Proto );

})();

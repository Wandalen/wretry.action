( function _l7_Regexp_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

const _ArrayIndexOf = Array.prototype.indexOf;
const _ArrayLastIndexOf = Array.prototype.lastIndexOf;
const _ArraySlice = Array.prototype.slice;
const _ArraySplice = Array.prototype.splice;
const _FunctionBind = Function.prototype.bind;
const _ObjectToString = Object.prototype.toString;
const _ObjectPropertyIsEumerable = Object.propertyIsEnumerable;

// --
// regexp
// --

let regexpsEscape = null;

//

/**
 * Make regexp from string.
 *
 * @example
 * _.regexp.from( 'Hello. How are you?' );
 * // returns /Hello\. How are you\?/
 *
 * @param {RegexpLike} src - string or regexp
 * @returns {String} Regexp
 * @throws {Error} Throw error with message 'unknown type of expression, expects regexp or string, but got' error
 if src not string-like ( string or regexp )
 * @function from
 * @namespace Tools
 */

function from( src, flags )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( flags === undefined || _.strIs( flags ) );

  if( _.regexpIs( src ) )
  return src;

  _.assert( _.strIs( src ) );

  return new RegExp( _.regexpEscape( src ), flags );
}

//

function maybeFrom( o )
{
  if( !_.mapIs( o ) )
  o = { srcStr : arguments[ 0 ] }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.srcStr ) || _.regexpIs( o.srcStr ) );
  _.routine.options( maybeFrom, o );

  let result = o.srcStr;
  let strips;

  if( _.strIs( result ) )
  {

    if( o.stringWithRegexp )
    {
      let optionsExtract =
      {
        delimeter : '//',
        src : result,
      }
      // let strips = _.strSplitInlined( optionsExtract ); // Dmytro : it's local variable
      strips = _.strSplitInlined( optionsExtract );
    }
    else
    {
      // let strips = [ result ]; // Dmytro : it's local variable
      strips = [ result ];
    }

    for( let s = 0 ; s < strips.length ; s++ )
    {
      let strip = strips[ s ];

      if( s % 2 === 0 )
      {
        strip = _.regexpEscape( strip );
        if( o.toleratingSpaces )
        strip = strip.replace( /\s+/g, '\\s*' );
      }

      strips[ s ] = strip;
    }

    result = RegExp( strips.join( '' ), o.flags );
  }

  return result;
}

maybeFrom.defaults =
{
  srcStr : null,
  stringWithRegexp : 1,
  toleratingSpaces : 1,
  flags : 'g',
}

//

let regexpsMaybeFrom = _.routineVectorize_functor( { routine : maybeFrom, select : 'srcStr' } );

//

function regexpsSources( o )
{
  if( _.arrayIs( arguments[ 0 ] ) )
  {
    o = Object.create( null );
    o.sources = arguments[ 0 ];
  }

  // o.sources = o.sources ? _.longSlice( o.sources ) : [];
  o.sources = _.longSlice( o.sources );
  if( o.flags === undefined )
  o.flags = null;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options( regexpsSources, o );

  /* */

  for( let s = 0 ; s < o.sources.length ; s++ )
  {
    let src = o.sources[ s ];
    if( _.regexpIs( src ) )
    {
      o.sources[ s ] = src.source;
      _.assert
      (
        o.flags === null || src.flags === o.flags,
        () => `All RegExps should have flags field with the same value "${ src.flags }" != "${ o.flags }"`
      );
      if( o.flags === null )
      o.flags = src.flags;
    }
    else
    {
      if( o.escaping )
      o.sources[ s ] = _.regexpEscape( src );
    }
    _.assert( _.strIs( o.sources[ s ] ) );
  }

  /* */

  return o;
}

regexpsSources.defaults =
{
  sources : null,
  flags : null,
  escaping : 0,
}

//

function regexpsJoin( o )
{
  if( !_.mapIs( o ) )
  o = { sources : o }

  _.routine.options( regexpsJoin, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  let result = o.sources.join( '' );

  return new RegExp( result, o.flags || '' );
}

regexpsJoin.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

function regexpsJoinEscaping( o )
{
  if( !_.mapIs( o ) )
  o = { sources : o }

  _.routine.options( regexpsJoinEscaping, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!o.escaping );

  return _.regexpsJoin( o );
}

var defaults = regexpsJoinEscaping.defaults = Object.create( regexpsJoin.defaults );

defaults.escaping = 1;

//

function regexpsAtLeastFirst( o )
{

  if( !_.mapIs( o ) )
  o = { sources : o }

  _.routine.options( regexpsAtLeastFirst, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  let result = '';
  let prefix = '';
  let postfix = '';

  for( let s = 0 ; s < o.sources.length ; s++ )
  {
    let src = o.sources[ s ];

    if( s === 0 )
    {
      prefix = prefix + src;
    }
    else
    {
      prefix = prefix + '(?:' + src;
      postfix =  ')?' + postfix
    }

  }

  result = prefix + postfix;
  return new RegExp( result, o.flags || '' );
}

regexpsAtLeastFirst.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

function regexpsAtLeastFirstOnly( o )
{

  if( !_.mapIs( o ) )
  o = { sources : o }

  _.routine.options( regexpsAtLeastFirst, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  let result = '';

  if( o.sources.length === 1 )
  {
    result = o.sources[ 0 ]
  }
  else for( let s = 0 ; s < o.sources.length ; s++ )
  {
    let src = o.sources[ s ];
    if( s < o.sources.length-1 )
    result += '(?:' + o.sources.slice( 0, s+1 ).join( '' ) + '$)|';
    else
    result += '(?:' + o.sources.slice( 0, s+1 ).join( '' ) + ')';
  }

  return new RegExp( result, o.flags || '' );
}

regexpsAtLeastFirst.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

/**
 *  Generates "but" regular expression pattern. Accepts a list of words, which will be used in regexp.
 *  The result regexp matches the strings that do not contain any of those words.
 *
 * @example
 * _.regexpsNone( 'yellow', 'red', 'green' );
 * // returns /^(?:(?!yellow|red|green).)+$/
 *
 * let options =
 * {
 *    but : [ 'yellow', 'red', 'green' ],
 *    atLeastOnce : false
 * };
 * _.regexpsNone(options);
 * // returns /^(?:(?!yellow|red|green).)*$/
 *
 * @param {Object} [options] options for generate regexp. If this argument omitted then default options will be used
 * @param {String[]} [options.but=null] a list of words, from each will consist regexp
 * @param {boolean} [options.atLeastOne=true] indicates whether search matches at least once
 * @param {...String} [words] a list of words, from each will consist regexp. This arguments can be used instead
 * options map.
 * @returns {RegExp} Result regexp
 * @throws {Error} If passed arguments are not strings or options map.
 * @throws {Error} If options contains any different from 'but' or 'atLeastOnce' properties.
 * @function regexpsNone
 * @namespace Tools
 */

function regexpsNone( o )
{
  if( !_.mapIs( o ) )
  o = { sources : o }

  _.routine.options( regexpsNone, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  o = _.regexpsSources( o );

  /* ^(?:(?!(?:abc)).)+$ */

  let result = '^(?:(?!(?:';
  result += o.sources.join( ')|(?:' );
  result += ')).)+$';

  return new RegExp( result, o.flags || '' );
}

regexpsNone.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

function regexpsAny( o )
{
  if( !_.mapIs( o ) )
  o = { sources : o }

  _.routine.options( regexpsAny, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.regexpIs( o.sources ) )
  {
    _.assert( o.sources.flags === o.flags || o.flags === null );
    return o.sources;
  }

  _.assert( !!o.sources );
  let src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  let result = '(?:';
  result += o.sources.join( ')|(?:' );
  result += ')';

  return new RegExp( result, o.flags || '' );
}

regexpsAny.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

function regexpsAll( o )
{
  if( !_.mapIs( o ) )
  o = { sources : o }

  _.routine.options( regexpsAll, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.regexpIs( o.sources ) )
  {
    _.assert( o.sources.flags === o.flags || o.flags === null );
    return o.sources;
  }

  let src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  let result = ''

  if( o.sources.length > 0 )
  {

    if( o.sources.length > 1 )
    {
      result += '(?=';
      result += o.sources.slice( 0, o.sources.length-1 ).join( ')(?=' );
      result += ')';
    }

    result += '(?:';
    result += o.sources[ o.sources.length-1 ];
    result += ')';

  }

  return new RegExp( result, o.flags || '' );
}

regexpsAll.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

/**
 * Wraps regexp(s) into array and returns it. If in `src` passed string - turn it into regexp
 *
 * @example
 * _.regexp.array.make( ['red', 'white', /[a-z]/] );
 * // returns [ /red/, /white/, /[a-z]/ ]
 *
 * @param {String[]|String} src - array of strings/regexps or single string/regexp
 * @returns {RegExp[]} Array of regexps
 * @throw {Error} if `src` in not string, regexp, or array
 * @function arrayMake
 * @namespace Tools
 */

function arrayMake( src )
{

  _.assert( _.regexpLike( src ) || _.argumentsArray.like( src ), 'Expects array/regexp/string, got ' + _.entity.strType( src ) );

  src = _.arrayFlatten( [], _.array.as( src ) );

  for( let k = src.length-1 ; k >= 0 ; k-- )
  {
    let e = src[ k ]

    if( e === null )
    {
      src.splice( k, 1 );
      continue;
    }

    src[ k ] = _.regexpFrom( e );

  }

  return src;
}

//

/**
 * Routine arrayIndex() returns the index of the first regular expression that matches substring
 * Otherwise, it returns -1.
 *
 * @example
 * let str = "The RGB color model is an additive color model in which red, green, and blue light are added together in various ways to reproduce a broad array of colors";
 * let regArr1 = [/white/, /green/, /blue/];
 * _.regexp.arrayIndex(regArr1, str);
 * // returns 1
 *
 * @param {RegExp[]} arr Array for regular expressions.
 * @param {String} ins String, inside which will be execute search
 * @returns {number} Index of first matching or -1.
 * @throws {Error} If first argument is not array.
 * @throws {Error} If second argument is not string.
 * @throws {Error} If element of array is not RegExp.
 * @function arrayIndex
 * @namespace Tools
 */

function arrayIndex( arr, ins )
{
  _.assert( _.arrayIs( arr ) );
  _.assert( _.strIs( ins ) );

  for( let a = 0 ; a < arr.length ; a++ )
  {
    let regexp = arr[ a ];
    _.assert( _.regexpIs( regexp ) );
    if( regexp.test( ins ) )
    return a;
  }

  return -1;
}

//

/**
 * Checks if any regexp passed in `arr` is found in string `ins`
 * If match was found - returns match index
 * If no matches found and regexp array is not empty - returns false
 * If regexp array is empty - returns some default value passed in the `ifEmpty` input param
 *
 * @example
 * let str = "The RGB color model is an additive color model in which red, green, and blue light are added together in various ways to reproduce a broad array of colors";
 * let regArr2 = [/yellow/, /blue/, /red/];
 * _.arrayAny(regArr2, str, false);
 * // returns 1
 *
 * @example
 * let regArr3 = [/yellow/, /white/, /greey/]
 * _.regexp.arrayAny(regArr3, str, false);
 * // returns false
 *
 * @param {String[]} arr Array of regular expressions strings
 * @param {String} ins - string that is tested by regular expressions passed in `arr` parameter
 * @param {*} none - Default return value if array is empty
 * @returns {*} Returns the first match index, false if input array of regexp was empty or default value otherwise
 * @thows {Error} If missed one of arguments
 * @function arrayAny
 * @namespace Tools
 */

function arrayAny( arr, ins, ifEmpty )
{

  _.assert( _.arrayIs( arr ) || _.regexpIs( src ) );
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  arr = _.array.as( arr );
  for( let m = 0 ; m < arr.length ; m++ )
  {
    _.assert( _.routine.is( arr[ m ].test ) );
    if( arr[ m ].test( ins ) )
    return m;
  }

  return arr.length ? false : ifEmpty;
}

//

/**
 * Checks if all regexps passed in `arr` are found in string `ins`
 * If any of regex was not found - returns match index
 * If regexp array is not empty and all regexps passed test - returns true
 * If regexp array is empty - returns some default value passed in the `ifEmpty` input param
 *
 * @example
 * let str = "The RGB color model is an additive color model in which red, green, and blue light are added together in various ways to reproduce a broad array of colors";
 * let regArr1 = [/red/, /green/, /blue/];
 * _.regexp.arrayAll(regArr1, str, false);
 * // returns true
 *
 * @example
 * let regArr2 = [/yellow/, /blue/, /red/];
 * _.regexp.arrayAll(regArr2, str, false);
 * // returns 0
 *
 * @param {String[]} arr Array of regular expressions strings
 * @param {String} ins - string that is tested by regular expressions passed in `arr` parameter
 * @param {*} none - Default return value if array is empty
 * @returns {*} Returns the first match index, false if input array of regexp was empty or default value otherwise
 * @thows {Error} If missed one of arguments
 * @function arrayAll
 * @namespace Tools
 */

function arrayAll( arr, ins, ifEmpty )
{
  _.assert( _.arrayIs( arr ) || _.regexpIs( src ) );
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  arr = _.array.as( arr );
  for( let m = 0 ; m < arr.length ; m++ )
  {
    if( !arr[ m ].test( ins ) )
    return m;
  }

  return arr.length ? true : ifEmpty;
}

//

function arrayNone( arr, ins, ifEmpty )
{

  _.assert( _.arrayIs( arr ) || _.regexpIs( src ) );
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  arr = _.array.as( arr );
  for( let m = 0 ; m < arr.length ; m++ )
  {
    _.assert( _.routine.is( arr[ m ].test ) );
    if( arr[ m ].test( ins ) )
    return false;
  }

  return arr.length ? true : ifEmpty;
}

// --
// regexp extension
// --

let RegexpExtension =
{

  // regexp

  from,

  maybeFrom,

  arrayMake,
  arrayIndex,
  arrayAny,
  arrayAll,
  arrayNone,

}

Object.assign( _.regexp, RegexpExtension );

// --
// regexps extension
// --

let RegexpsExtension =
{

  // regexps

  maybeFrom : regexpsMaybeFrom,

  sources : regexpsSources,
  join : regexpsJoin,
  joinEscaping : regexpsJoinEscaping,
  atLeastFirst : regexpsAtLeastFirst,
  atLeastFirstOnly : regexpsAtLeastFirstOnly,

  none : regexpsNone,
  any : regexpsAny,
  all : regexpsAll,

}

Object.assign( _.regexps, RegexpsExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  regexpFrom : from,

  regexpMaybeFrom : maybeFrom,
  regexpsMaybeFrom,

  regexpsSources,
  regexpsJoin,
  regexpsJoinEscaping,
  regexpsAtLeastFirst,
  regexpsAtLeastFirstOnly,

  regexpsNone,
  regexpsAny,
  regexpsAll,

  regexpArrayMake : arrayMake,
  regexpArrayIndex : arrayIndex,
  regexpArrayAny : arrayAny,
  regexpArrayAll : arrayAll,
  regexpArrayNone : arrayNone,

}

Object.assign( _, ToolsExtension );

//

})();

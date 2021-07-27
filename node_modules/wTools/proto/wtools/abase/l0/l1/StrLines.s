( function _l1_Str_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.str = _.str || Object.create( null );
_.str.lines = _.str.lines || Object.create( null );

// --
// lines
// --

function split( src, eol )
{
  if( _.arrayIs( src ) )
  return src;
  _.assert( _.strIs( src ) || _.arrayIs( src ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( eol === undefined )
  eol = _.str.lines.Eol.default;
  return src.split( eol );
}

//

function join( src, eol )
{
  _.assert( _.strIs( src ) || _.arrayIs( src ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( eol === undefined )
  eol = _.str.lines.Eol.default;
  let result = src;
  if( _.arrayIs( src ) )
  result = src.join( eol );
  return result;
}

//

/**
 * Remove espace characters and white spaces at the begin or at the end of each line.
 * Input arguments can be strings or arrays of strings. If input is a string, it splits it in lines and
 * removes the white/escape characters from the beggining and the end of each line. If input is an array,
 * it treats it as a single string split into lines, where each entry corresponds to a line. Therefore,
 * it removes the white/escape characters only from the beggining and the end of the strings in the array.
 *
 * @param { String/Array } [ src ] - Source string or array of strings.
 * @returns { String/Array } Returns string/array with empty lines and spaces removed.
 *
 * @example input string
 * _.str.lines.strip( '  Hello \r\n\t World \n\n ' );
 * // returns 'Hello\nWorld'
 *
 * @example input array
 * _.str.lines.strip( [ '  Hello \r\n\t world \n\n ', '\n! \n' ] );
 * // returns  [ 'Hello \r\n\t world', '!' ]
 *
 * @example input strings
 * _.str.lines.strip( '  Hello \r\n\t', ' World \n\n  ! \n\n', '\n\n' );
 * // returns [ 'Hello', 'World\n!', '' ]
 *
 * @example input arrays
 * _.str.lines.strip( [ '  Hello \r\n\t world \n\n ', '\n! \n' ], [ '\n\nHow\n\nAre  ', '  \r\nyou ? \n'], [ '\t\r\n  ' ] );
 * // returns [ [ 'Hello \r\n\t world', '!' ], [ 'How\n\nAre', 'you ?' ], [] ]
 *
 * @method strip
 * @throws { Exception } Throw an exception if( src ) is not a String or Array.
 * @namespace Tools/str/lines/strip
 */

/* qqq : measure time and optimize. ask */
function strip( src )
{

  if( arguments.length > 1 )
  {
    let result = _.unroll.make( null );
    for( let a = 0 ; a < arguments.length ; a++ )
    result[ a ] = _.str.lines.strip( arguments[ a ] );
    return result;
  }

  _.assert( _.strIs( src ) || _.arrayIs( src ) );
  _.assert( arguments.length === 1 );

  let lines = _.strLinesSplit( src );
  lines = lines.map( ( line ) => line.trim() ).filter( ( line ) => line );

  if( _.strIs( src ) )
  lines = _.str.lines.join( lines );
  return lines;
}

//

function atLeft( src, index, eol )
{
  let result;

  _.assert( _.number.is( index ) );

  if( index < 0 )
  {
    result = Object.create( null );
    result.src = src;
    result.lineIndex = index;
    result.charInterval = [ 0, -1 ];
    return result;
  }

  let o2 = Object.create( null );
  o2.src = src;
  o2.eol = eol;
  o2.onEach = onEach;
  o2.interval = [ index, index ];
  o2.withLine = false;
  this.eachLeft( o2 );

  if( !result )
  {
    result = Object.create( null );
    result.src = src;
    result.lineIndex = index;
    result.charInterval = [ src.length, src.length-1 ];
  }

  delete result.eol;
  delete result.onEach;
  delete result.interval;
  delete result.withLine;

  return result;

  function onEach( it )
  {
    result = it;
    result.line = src.slice( it.charInterval[ 0 ], it.charInterval[ 1 ]-it.nl.length+1 );
  }

}

//

function atRight( src, index, eol )
{
  let result;

  _.assert( _.number.is( index ) );

  if( index < 0 )
  {
    result = Object.create( null );
    result.src = src;
    result.lineIndex = index;
    result.charInterval = [ src.length, src.length-1 ];
    return result;
  }

  let o2 = Object.create( null );
  o2.src = src;
  o2.eol = eol;
  o2.onEach = onEach;
  o2.interval = [ index, index ];
  o2.withLine = false;

  this.eachRight( o2 );

  if( !result )
  {
    result = Object.create( null );
    result.src = src;
    result.lineIndex = index;
    result.charInterval = [ 0, -1 ];
  }

  delete result.eol;
  delete result.onEach;
  delete result.interval;
  delete result.withLine;

  return result;

  function onEach( it )
  {
    result = it;
    result.line = src.slice( it.charInterval[ 0 ], it.charInterval[ 1 ]-it.nl.length+1 );
  }

}

//

function _eachLeft( o )
{

  if( o.eol === undefined )
  o.eol = _.str.lines.Eol.default;
  else if( !_.str.is( o.eol ) )
  o.eol = [ ... o.eol ];

  const lastIndex = o.interval ? o.interval[ 1 ] : Infinity;
  const src = o.src;
  let foundTokenIndex;
  let foundOffset;
  let handleEach;

  o.charInterval = [ -1, -1 ];
  o.lineIndex = -1;

  if( o.interval && o.interval[ 1 ] < 0 )
  {
    o.charInterval[ 0 ] = 0;
    return o;
  }

  o.nl = '';

  if( o.interval )
  {
    if( o.withLine )
    handleEach = handleWithIntervalWithLine;
    else
    handleEach = handleWithIntervalWithoutLine;
  }
  else
  {
    if( o.withLine )
    handleEach = handleWithoutIntervalWithLine;
    else
    handleEach = handleWithoutIntervalWithoutLine;
  }

  if( _.str.is( o.eol ) )
  single();
  else
  multiple();

  if( !o.interval || o.lineIndex < o.interval[ 1 ] )
  {
    o.lineIndex += 1;
    o.charInterval[ 0 ] = src.length;
    _.assert( o.charInterval[ 1 ] === src.length - 1 );
    if( o.withLine )
    o.line = '';
  }

  return o;

  /* */

  function single()
  {

    o.nl = o.eol;
    while( o.lineIndex !== lastIndex )
    {
      o.charInterval[ 0 ] = Math.max( o.charInterval[ 0 ], o.charInterval[ 1 ] ) + 1;
      o.charInterval[ 1 ] = src.indexOf( o.eol, o.charInterval[ 0 ] );
      o.lineIndex += 1;

      if( o.charInterval[ 1 ] === -1 )
      {
        o.charInterval[ 1 ] = src.length - 1;
        o.nl = '';
        handleEach();
        break;
      }
      else
      {
        o.charInterval[ 1 ] += o.nl.length - 1;
        handleEach();
      }

    }

  }

  /* */

  function multiple()
  {

    foundTokenIndex = -1;
    foundOffset = src.length;

    let first = indexInit();

    if( first.length === 1 )
    {
      o.eol = o.eol[ foundTokenIndex ];
      return single();
    }

    if( first.length === 0 )
    {

      o.lineIndex = 0;
      o.charInterval[ 0 ] = 0;
      o.charInterval[ 1 ] = src.length-1;
      handleEach();

      return;
    }

    while( o.lineIndex !== lastIndex )
    {
      o.charInterval[ 0 ] = Math.max( o.charInterval[ 0 ], o.charInterval[ 1 ] ) + 1;
      o.charInterval[ 1 ] = indexOf( first );
      o.lineIndex += 1;

      if( o.charInterval[ 1 ] === o.src.length )
      {
        o.charInterval[ 1 ] = src.length - 1;
        o.nl = '';
        handleEach();
        break;
      }
      else
      {
        o.nl = o.eol[ foundTokenIndex ];
        o.charInterval[ 1 ] += o.nl.length - 1;
        handleEach();
      }

    }

  }

  /* */

  function indexInit()
  {
    let first = [];
    for( let i = o.eol.length - 1 ; i >= 0 ; i-- )
    {
      let offset = src.indexOf( o.eol[ i ] );
      if( offset !== -1 )
      {
        first.unshift( offset );
        if( foundOffset >= offset )
        {
          foundOffset = offset;
          foundTokenIndex = i;
        }
      }
      else
      {
        o.eol.splice( i, 1 );
        foundTokenIndex -= 1;
      }
    }
    return first;
  }

  /* */

  function indexOf( first )
  {
    if( first[ foundTokenIndex ] >= o.charInterval[ 0 ] )
    return first[ foundTokenIndex ];
    foundOffset = src.length;
    for( let i = first.length - 1; i >= 0 ; i-- )
    {
      let offset = first[ i ];
      if( offset < o.charInterval[ 0 ] )
      {
        offset = src.indexOf( o.eol[ i ], first[ i ]+1 );
        if( offset === -1 )
        {
          tokenDelete( first, i );
          if( first.length === 0 )
          return src.length;
        }
        else
        {
          first[ i ] = offset;
          if( foundOffset >= offset )
          {
            foundOffset = offset;
            foundTokenIndex = i;
          }
        }
      }
      else
      {
        if( foundOffset >= offset )
        {
          foundOffset = offset;
          foundTokenIndex = i;
        }
      }
    }
    return first[ foundTokenIndex ];
  }

  /* */

  function tokenDelete( first, i )
  {
    o.eol.splice( i, 1 );
    first.splice( i, 1 );
    if( foundTokenIndex > i )
    foundTokenIndex -= 1;
  }

  /* */

  function handleWithoutIntervalWithoutLine()
  {
    o.onEach( o );
  }

  /* */

  function handleWithIntervalWithoutLine()
  {
    if( o.interval && o.interval[ 0 ] > o.lineIndex )
    return;
    o.onEach( o );
  }

  /* */

  function handleWithoutIntervalWithLine()
  {
    o.line = src.slice( o.charInterval[ 0 ], o.charInterval[ 1 ] - o.nl.length + 1 );
    o.onEach( o );
  }

  /* */

  function handleWithIntervalWithLine()
  {
    if( o.interval && o.interval[ 0 ] > o.lineIndex )
    return;
    o.line = src.slice( o.charInterval[ 0 ], o.charInterval[ 1 ] - o.nl.length + 1 );
    o.onEach( o );
  }

  /* */

}

_eachLeft.defaults =
{
  src : null,
  eol : null,
  interval : null,
  withLine : true,
}

//

function eachLeft( o )
{

  if( !_.map.is( o ) )
  {
    _.assert( arguments.length === 2 || arguments.length === 3 );
    if( arguments.length === 3 )
    o = { src : arguments[ 0 ], interval : arguments[ 1 ], onEach : arguments[ 2 ] };
    else
    o = { src : arguments[ 0 ], onEach : arguments[ 1 ] };
  }
  else
  {
    _.assert( arguments.length === 1 );
  }

  if( o.withLine === undefined )
  o.withLine = true;

  _.assert( _.routine.is( o.onEach ) );
  _.assert( _.str.is( o.src ) );

  return this._eachLeft( o );
}

//

function _eachRight( o )
{

  if( o.eol === undefined )
  o.eol = _.str.lines.Eol.default;
  else if( !_.str.is( o.eol ) )
  o.eol = [ ... o.eol ];

  const lastIndex = o.interval ? o.interval[ 1 ] : Infinity;
  const src = o.src;
  let foundTokenIndex;
  let foundOffset;
  let nnl = '';
  let handleEach;

  if( o.interval )
  {
    if( o.withLine )
    handleEach = handleWithIntervalWithLine;
    else
    handleEach = handleWithIntervalWithoutLine;
  }
  else
  {
    if( o.withLine )
    handleEach = handleWithoutIntervalWithLine;
    else
    handleEach = handleWithoutIntervalWithoutLine;
  }

  o.charInterval = [ o.src.length, o.src.length ];
  o.lineIndex = -1;

  if( o.interval && o.interval[ 1 ] < 0 )
  {
    o.charInterval[ 1 ] = o.src.length-1;
    return o;
  }

  o.nl = '';

  if( _.str.is( o.eol ) )
  single();
  else
  multiple();

  if( !o.interval || o.lineIndex < o.interval[ 1 ] )
  {
    o.lineIndex += 1;
    o.charInterval[ 1 ] = -1;
    _.assert( o.charInterval[ 0 ] === 0 );
    if( o.withLine )
    o.line = '';
  }

  return o;

  /* */

  function single()
  {

    while( o.lineIndex !== lastIndex )
    {

      o.lineIndex += 1;
      o.nl = nnl;

      o.charInterval[ 1 ] = o.charInterval[ 0 ] - 1;
      let right = o.charInterval[ 1 ] - o.nl.length;
      if( right >= 0 || o.lineIndex === 0 )
      o.charInterval[ 0 ] = src.lastIndexOf( o.eol, right );
      else
      o.charInterval[ 0 ] = -1;

      if( o.charInterval[ 0 ] === -1 )
      {
        o.charInterval[ 0 ] = 0;
        handleEach();
        break;
      }
      else
      {
        nnl = o.eol;
        o.charInterval[ 0 ] += nnl.length;
        handleEach();
      }

    }

  }

  /* */

  function multiple()
  {

    foundTokenIndex = -1;
    foundOffset = 0;

    let first = indexInit();

    if( first.length === 1 )
    {
      o.eol = o.eol[ foundTokenIndex ];
      return single();
    }

    if( first.length === 0 )
    {
      o.lineIndex = 0;
      o.charInterval[ 0 ] = 0;
      o.charInterval[ 1 ] = src.length-1;
      handleEach();
      return;
    }

    while( o.lineIndex !== lastIndex )
    {

      o.lineIndex += 1;
      o.nl = nnl;

      o.charInterval[ 1 ] = o.charInterval[ 0 ] - 1;
      o.charInterval[ 0 ] = indexOf( first );

      if( o.charInterval[ 0 ] === -1 )
      {
        o.charInterval[ 0 ] = 0;
        handleEach();
        break;
      }
      else
      {
        nnl = o.eol[ foundTokenIndex ];
        handleEach();
      }

    }

  }

  /* */

  function indexInit()
  {
    let first = [];
    for( let i = o.eol.length - 1 ; i >= 0 ; i-- )
    {
      let offset = src.lastIndexOf( o.eol[ i ] );
      if( offset !== -1 )
      {
        offset += o.eol[ i ].length;
        first.unshift( offset );
        if( foundOffset <= offset )
        {
          foundOffset = offset;
          foundTokenIndex = i;
        }
      }
      else
      {
        o.eol.splice( i, 1 );
        foundTokenIndex -= 1;
      }
    }
    return first;
  }

  /* */

  function indexOf( first )
  {
    let left = o.charInterval[ 0 ] - nnl.length - 1;
    if( first[ foundTokenIndex ] <= left )
    return first[ foundTokenIndex ];
    foundOffset = -1;
    for( let i = first.length - 1; i >= 0 ; i-- )
    {
      let offset = first[ i ];
      if( offset > left )
      {
        if( left >= 0 )
        offset = src.lastIndexOf( o.eol[ i ], left );
        else
        offset = -1;
        if( offset === -1 )
        {
          tokenDelete( first, i );
          if( first.length === 0 )
          return -1;
        }
        else
        {
          offset += o.eol[ i ].length;
          first[ i ] = offset;
          if( foundOffset <= offset )
          {
            foundOffset = offset;
            foundTokenIndex = i;
          }
        }
      }
      else
      {
        if( foundOffset <= offset )
        {
          foundOffset = offset;
          foundTokenIndex = i;
        }
      }
    }
    return first[ foundTokenIndex ];
  }

  /* */

  function tokenDelete( first, i )
  {
    o.eol.splice( i, 1 );
    first.splice( i, 1 );
    if( foundTokenIndex > i )
    foundTokenIndex -= 1;
  }

  /* */

  function handleWithoutIntervalWithoutLine()
  {
    o.onEach( o );
  }

  /* */

  function handleWithIntervalWithoutLine()
  {
    if( o.interval && o.interval[ 0 ] > o.lineIndex )
    return;
    o.onEach( o );
  }

  /* */

  function handleWithoutIntervalWithLine()
  {
    o.line = src.slice( o.charInterval[ 0 ], o.charInterval[ 1 ] - o.nl.length + 1 );
    o.onEach( o );
  }

  /* */

  function handleWithIntervalWithLine()
  {
    if( o.interval && o.interval[ 0 ] > o.lineIndex )
    return;
    o.line = src.slice( o.charInterval[ 0 ], o.charInterval[ 1 ] - o.nl.length + 1 );
    o.onEach( o );
  }

  /* */

}

_eachRight.defaults =
{
  ... _eachLeft.defaults,
}

//

function eachRight( o )
{

  if( !_.map.is( o ) )
  {
    _.assert( arguments.length === 2 || arguments.length === 3 );
    if( arguments.length === 3 )
    o = { src : arguments[ 0 ], interval : arguments[ 1 ], onEach : arguments[ 2 ] };
    else
    o = { src : arguments[ 0 ], onEach : arguments[ 1 ] };
  }
  else
  {
    _.assert( arguments.length === 1 );
  }

  if( o.withLine === undefined )
  o.withLine = true;

  _.assert( _.routine.is( o.onEach ) );
  _.assert( _.str.is( o.src ) );

  return this._eachRight( o );
}

// --
// str extension
// --

let Eol =
{
  any : [ '\r\n', '\n\r', '\n' ],
  posix : '\n',
  windows : '\r\n',
  mac : '\n\r',
  default : '\n',
}

let StrLinesExtension =
{

  Eol,

  split,
  join,
  strip,

  atLeft,
  atRight,
  at : atLeft,

  _eachLeft,
  eachLeft,
  _eachRight,
  eachRight,
  each : eachLeft,

}

Object.assign( _.str.lines, StrLinesExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  strLinesSplit : split,
  strLinesJoin : join,
  strLinesStrip : strip,

}

Object.assign( _, ToolsExtension );

//

})();

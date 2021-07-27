( function _l7_String_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

const _ArraySlice = Array.prototype.slice;
const _FunctionBind = Function.prototype.bind;
const _ObjectToString = Object.prototype.toString;

// --
// str
// --

function strIsolate_head( routine, args )
{
  let o;

  if( args.length > 1 )
  {
    if( args.length === 3 )
    o = { src : args[ 0 ], delimeter : args[ 1 ], times : args[ 2 ] };
    else if( args.length === 2 )
    o = { src : args[ 0 ], delimeter : args[ 1 ] };
    else
    o = { src : args[ 0 ] };
  }
  else
  {
    o = args[ 0 ];
    _.assert( args.length === 1, 'Expects single argument' );
  }

  _.routine.options( routine, o );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( o.src ) );
  _.assert( _.regexpsLikeAll( o.delimeter ) )
  _.assert( _.number.is( o.times ) );

  return o;
}

//

/**
* @typedef {object} wTools.entity.exportStringInhalfOptions
* @property {string} [ o.src=null ] - Source string.
* @property {string | array} [ o.delimeter=' ' ] - Splitter of the string.
* @property {boolean} [ o.left=1 ] - Finds occurrence from begining of the string.
*/

/**
 * Finds occurrence of delimeter( o.delimeter ) in source( o.src ) and splits string in finded position by half.
 * If function finds  more then one occurrence, it separates string in the position of the last.
 *
 * @param {wTools.entity.exportStringInhalfOptions} o - Contains data and options {@link wTools.entity.exportStringInhalfOptions}.
 * @returns {array} Returns array with separated parts of string( o.src ) or original string if nothing finded.
 *
 * @example
 * _.strIsolate( { src : 'sample, string', delimeter : [ ',' ] } );
 * // returns [ 'sample', 'string' ]
 *
 * @example
 *_.strIsolate( { src : 'sample string', delimeter : ' ' } )
 * // returns [ 'sample', 'string' ]
 *
 * @example
 * _.strIsolate( { src : 'sample string, name string', delimeter : [ ',', ' ' ] } )
 * // returns [ 'sample string, name', 'string' ]
 *
 * @method strIsolate
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o ) is not a Map.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @throws { Exception } Throw an exception if( o.delimeter ) is not a Array or String.
 * @throws { Exception } Throw an exception if( o ) is extended by unknown property.
 * @namespace Tools
 *
 */

// function strIsolate( o )
// {
//   let result = [];
//   let times = o.times;
//   let delimeter
//   let index = o.left ? -1 : o.src.length;
//
//   _.routine.assertOptions( strIsolate, o );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.strIs( o.src ), 'Expects string {-o.src-}, got', _.entity.strType( o.src ) );
//   _.assert( _.strIs( o.delimeter ) || _.arrayIs( o.delimeter ) );
//   _.assert( _.number.is( o.times ) );
//
//   /* */
//
//   if( !( times >= 1 ) )
//   {
//     return everything( o.left ^ o.none );
//   }
//
//   if( _.arrayIs( o.delimeter ) && o.delimeter.length === 1 )
//   o.delimeter = o.delimeter[ 0 ];
//
//   let closest = o.left ? strLeft : strRight;
//
//   /* */
//
//   while( times > 0 )
//   {
//
//     index += o.left ? +1 : -1;
//
//     if( _.arrayIs( o.delimeter ) )
//     {
//
//       if( !o.delimeter.length )
//       {
//         return everything( o.left ^ o.none );
//       }
//
//       let c = closest( index );
//
//       delimeter = c.element;
//       index = c.value;
//
//       if( o.times === 1 && index === o.src.length && o.left )
//       index = -1;
//
//     }
//     else
//     {
//
//       delimeter = o.delimeter;
//       index = o.left ? o.src.indexOf( delimeter, index ) : o.src.lastIndexOf( delimeter, index );
//
//       if( o.left && !( index >= 0 ) && o.times > 1 )
//       {
//         index = o.src.length;
//         break;
//       }
//
//     }
//
//     /* */
//
//     if( !o.left && times > 1 && index === 0  )
//     {
//       return everything( !o.none )
//     }
//
//     if( !( index >= 0 ) && o.times === 1 )
//     {
//       return everything( o.left ^ o.none )
//     }
//
//     times -= 1;
//
//   }
//
//   /* */
//
//   result.push( o.src.substring( 0, index ) );
//   result.push( delimeter );
//   result.push( o.src.substring( index + delimeter.length ) );
//
//   return result;
//
//   /* */
//
//   function everything( side )
//   {
//     return ( side ) ? [ o.src, '', '' ] : [ '', '', o.src ];
//   }
//
//   /* */
//
//   function strLeft( index )
//   {
//     return _.entityMin( o.delimeter, function( a )
//     {
//       let i = o.src.indexOf( a, index );
//       if( i === -1 )
//       return o.src.length;
//       return i;
//     });
//   }
//
//   /* */
//
//   function strRight( index )
//   {
//     return _.entityMax( o.delimeter, function( a )
//     {
//       let i = o.src.lastIndexOf( a, index );
//       return i;
//     });
//   }
//
// }
//
// strIsolate.defaults =
// {
//   src : null,
//   delimeter : ' ',
//   quote : null,
//   left : 1,
//   times : 1,
//   none : 1,
// }

function strIsolate_body( o )
{
  let result = [];
  let times = o.times;
  let delimeter
  let index = o.left ? 0 : o.src.length;
  let more = o.left ? strLeft : strRight;
  let delta = ( o.left ? +1 : -1 );

  _.routine.assertOptions( strIsolate_body, arguments );

  /* */

  if( _.arrayIs( o.delimeter ) && o.delimeter.length === 1 )
  o.delimeter = o.delimeter[ 0 ];

  let quote;
  if( o.quote )
  quote = _.strQuoteAnalyze({ src : o.src, quote : o.quote });

  /* */

  while( times > 0 )
  {
    let found = more( index );

    if( found.entry === undefined )
    break;

    times -= 1;

    if( o.left )
    index = found.index + delta;
    else
    index = found.index + found.entry.length + delta;

    if( times === 0 )
    {
      result.push( o.src.substring( 0, found.index ) );
      result.push( found.entry );
      result.push( o.src.substring( found.index + found.entry.length ) );
      return result;
    }

    /* */

    if( o.left )
    {
      if( index >= o.src.length )
      break;
    }
    else
    {
      if( index <= 0 )
      break;
    }

  }

  /* */

  if( !result.length )
  {

    if( o.times === 0 )
    return everything( !o.left );
    else if( times === o.times )
    return everything( o.left ^ o.none );
    else
    return everything( o.left );

  }

  return result;

  /* */

  function everything( side )
  {
    return ( side ) ? [ o.src, undefined, '' ] : [ '', undefined, o.src ];
  }

  /* */

  function strLeft( index )
  {
    // let r = _._strLeftSingle( o.src, o.delimeter, [ index, undefined ] );
    let r = _._strLeftSingle_( o.src, o.delimeter, [ index, undefined ] );
    if( quote )
    if( r.entry !== undefined )
    {
      let range = inQuoteRange( r.index );
      if( range )
      return strLeft( range[ 1 ]+1 );
    }
    return r;
  }

  /* */

  function strRight( index )
  {
    // let r = _._strRightSingle( o.src, o.delimeter, [ undefined, index ] );
    let r = _._strRightSingle_( o.src, o.delimeter, [ undefined, index-1 ] );
    if( quote )
    if( r.entry !== undefined )
    {
      let range = inQuoteRange( r.index );
      if( range )
      return strRight( range[ 0 ] );
    }
    return r;
  }

  /* */

  function inQuoteRange( offset )
  {
    let i = _.sorted.searchFirstIndex( quote.ranges, offset );
    if( i % 2 )
    {
      i -= 1;
    }
    if( i < 0 || i >= quote.ranges.length )
    return false;
    let b = quote.ranges[ i ];
    let e = quote.ranges[ i+1 ];
    if( !( b <= offset && offset <= e ) )
    return false;
    return [ b, e ];
  }

  /* */

  // function binSearch( val )
  // {
  //   let l = 0;
  //   let r = quote.ranges.length;
  //   let m;
  //   if( quote.ranges.length )
  //   debugger;
  //   do
  //   {
  //     m = Math.floor( ( l + r ) / 2 );
  //     if( quote.ranges[ m ] < val )
  //     l = m+1;
  //     else if( quote.ranges[ m ] > val )
  //     r = m;
  //     else
  //     return m;
  //   }
  //   while( l < r );
  //   if( quote.ranges[ m ] < val )
  //   return m+1;
  //   return m;
  // }

  /* */

  // let quotedRanges = [];
  //
  // function quoteRangesSetup( index )
  // {
  //   let quotes = [];
  //   for( let i = 0 ; i < o.src.length ; i++ )
  //   {
  //     if( _.arrayHas( o.quote,  ) )
  //   }
  // }
  //
  // function quoteRange( index )
  // {
  //   for( let i = 0 ; i < x ; i++ )
  //
  // }

}

strIsolate_body.defaults =
{
  src : null,
  delimeter : ' ',
  quote : 0,
  // quoting : [ '"', '`', '\'' ],
  left : 1,
  times : 1,
  none : 1,
}

//

/**
 * Short-cut for strIsolate function.
 * Finds occurrence of delimeter( o.delimeter ) from begining of ( o.src ) and splits string in finded position by half.
 *
 * @param {wTools.entity.exportStringInhalfOptions} o - Contains data and options {@link wTools.entity.exportStringInhalfOptions}.
 * @returns {array} Returns array with separated parts of string( o.src ) or original string if nothing finded.
 *
 * @example
 * _.strIsolateLeftOrNone( { src : 'sample, string', delimeter : [ ', ' ] } );
 * // returns [ 'sample', 'string' ]
 *
 * @example
 *_.strIsolateLeftOrNone( { src : 'sample string', delimeter : ' ' } )
 * // returns [ 'sample', 'string' ]
 *
 * @example
 * _.strIsolateLeftOrNone( 'sample string, name string', ',' )
 * // returns [ 'sample string, name', 'string' ]
 *
 * @method strIsolateLeftOrNone
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o ) is not a Map.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @namespace Tools
 *
 */

function strIsolateLeftOrNone_body( o )
{
  o.left = 1;
  o.none = 1;
  let result = _.strIsolate.body( o );
  return result;
}

strIsolateLeftOrNone_body.defaults =
{
  src : null,
  delimeter : ' ',
  times : 1,
  quote : null,
}

//

function strIsolateLeftOrAll_body( o )
{
  o.left = 1;
  o.none = 0;
  let result = _.strIsolate.body( o );
  return result;
}

strIsolateLeftOrAll_body.defaults =
{
  src : null,
  delimeter : ' ',
  times : 1,
  quote : null,
}

//

/**
 * Short-cut for strIsolate function.
 * Finds occurrence of delimeter( o.delimeter ) from end of ( o.src ) and splits string in finded position by half.
 *
 * @param {wTools.entity.exportStringInhalfOptions} o - Contains data and options {@link wTools.entity.exportStringInhalfOptions}.
 * @returns {array} Returns array with separated parts of string( o.src ) or original string if nothing finded.
 *
 * @example
 * _.strIsolateRightOrNone( { src : 'sample, string', delimeter : [ ',' ] } );
 * // returns [ 'sample', 'string' ]
 *
 * @example
 *_.strIsolateRightOrNone( { src : 'sample string', delimeter : ' ' } )
 * // returns [ 'sample', 'string' ]
 *
 * @method strIsolateRightOrNone
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o ) is not a Map.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @namespace Tools
 *
 */

function strIsolateRightOrNone_body( o )
{
  o.left = 0;
  o.none = 1;
  let result = _.strIsolate.body( o );
  return result;
}

strIsolateRightOrNone_body.defaults =
{
  src : null,
  delimeter : ' ',
  times : 1,
  quote : null,
}

//

function strIsolateRightOrAll_body( o )
{
  o.left = 0;
  o.none = 0;
  let result = _.strIsolate.body( o );
  return result;
}

strIsolateRightOrAll_body.defaults =
{
  src : null,
  delimeter : ' ',
  times : 1,
  quote : null,
}

//

// function strIsolateInsideOrNoneSingle( src, begin, end )
// {
//
//   _.assert( _.strIs( src ), 'Expects string {-src-}' );
//   _.assert( arguments.length === 3, 'Expects exactly three arguments' );
//
//   let b = _.strLeft( src, begin );
//
//   if( b.entry === undefined )
//   return notFound();
//
//   let e = _.strRight( src, end );
//
//   if( e.entry === undefined )
//   return notFound();
//
//   if( e.index < b.index + b.entry.length )
//   return notFound();
//
//   let result =
//   [
//     src.substring( 0, b.index ),
//     b.entry,
//     src.substring( b.index + b.entry.length, e.index ),
//     e.entry,
//     src.substring( e.index+e.entry.length, src.length )
//   ];
//
//   return result;
//
//   function notFound()
//   {
//     return [];
//   }
// }
//
// //
//
// function strIsolateInsideOrNone( src, begin, end )
// {
//
//   _.assert( arguments.length === 3, 'Expects exactly three arguments' );
//
//   if( _.argumentsArray.like( src ) )
//   {
//     let result = [];
//     for( let s = 0 ; s < src.length ; s++ )
//     result[ s ] = _.strIsolateInsideOrNoneSingle( src[ s ], begin, end );
//     return result;
//   }
//   else
//   {
//     return _.strIsolateInsideOrNoneSingle( src, begin, end );
//   }
//
// }

//

/**
  * Routine isolateInsideSignle() split source strings {-src-} into parts separated by delimeters {-begin-} and {-end-}. Routine returns
  * an array with parts of source string {-src-}.
  * The array contains of five parts:
  * - substring from start of source string to begin of first delimeter {-begin-}.
  * - delimeter {-begin-}.
  * - substring between delimeters {-begin-} and {-end-}.
  * - delimeter {-end-}.
  * - substring from end of delimeter {-end-} to end of source line.
  * If routine does not find part between {-begin-} and {-end-} delimeters, then routine transform begin and end substrings to empty
  * strings and delimeters to undefined.
  * So, finally routine returns the array with source string: [ '', undefined, {-src-}, undefined, '' ].
  *
  * @param { String } src - The source string.
  * @param { String|Array } begin - String or array of strings to find begin of split part in the source string.
  * @param { String|Array } end - String or array of strings to find end of split part in the source source.
  *
  * @example
  * _.strIsolateInsideSignle( 'aabdcdd', 'a', 'd' );
  * // returns [ '', 'a', 'abdcd', 'd', '' ]
  *
  * @example
  * _.strIsolateInsideSignle( 'cabdcdc', 'a', 'd' );
  * // returns [ 'c', 'a', 'bdc', 'd', 'c' ]
  *
  * @example
  * _.strIsolateInsideSignle( 'cabdcdc', 'f', 'd' );
  * // returns [ '', undefined, 'cabdcdc', undefined, '' ]
  *
  * @example
  * _.strIsolateInsideSignle( 'cabdcdc', 'a', 'f' );
  * // returns [ '', undefined, 'cabdcdc', undefined, '' ]
  *
  * @example
  * _.strIsolateInsideSignle( 'cabdcdc', [ 'f', 'b' ], 'd' );
  * // returns [ 'ca', 'b', 'dc', 'd', 'c' ]
  *
  * @example
  * _.strIsolateInsideSignle( 'cabdcdc', 'b', [ 'f', 'd' ] );
  * // returns [ 'ca', 'b', 'dc', 'd', 'c' ]
  *
  * @example
  * _.strIsolateInsideSignle( 'cabdcdc', [ 'b', 'c' ], [ 'c', 'd' ] );
  * // returns [ 'ca', 'b', 'dcd', 'c', '' ]
  *
  * @returns { Array } - Returns array with parts of source string.
  * @function isolateInsideSignle
  * @throws { Exception } If arguments.length is less then one or more then three.
  * @throws { Exception } If source string {-str-} is not a String.
  * @throws { Exception } If delimeter {-begin-} is not a String or an Array of strings.
  * @throws { Exception } If delimeter {-end-} is not a String or an Array of strings.
  * @namespace Tools
  */

function isolateInsideSignle( src, begin, end )
{

  _.assert( _.strIs( src ), 'Expects string {-src-}' );
  _.assert( arguments.length === 2 || arguments.length === 3 );
  let b, e;

  if( end === undefined )
  {
    let pairs = arguments[ 1 ];
    _.assert( _.strIs( pairs ) || _.arrayIs( pairs ) );
    pairs = _.strQuotePairsNormalize( pairs );

    let l = 0;
    let begin = [];
    for( let q = 0 ; q < pairs.length ; q++ )
    {
      let quotingPair = pairs[ q ];
      begin.push( quotingPair[ 0 ] );
    }

    do
    {

      // b = _.strLeft( src, begin, [ l, src.length ] );
      b = _.strLeft_( src, begin, [ l, src.length-1 ] );

      if( b.entry === undefined )
      return notFound();

      _.assert( _.number.is( b.instanceIndex ) );
      let end = pairs[ b.instanceIndex ][ 1 ];

      // e = _.strRight( src, end, Math.min( b.index+1, src.length ) );
      // e = _.strRight_( src, end, Math.min( b.index, src.length-1 ) ); /* Dmytro : if cinterval is a Number, it is defined first index, not last */
      e = _.strRight_( src, end, Math.min( b.index, src.length ) );

      if( e.entry === undefined )
      l = b.index+1;
      else
      break;
      // return notFound();

    }
    while( l < src.length );

    if( e.entry === undefined )
    return notFound();

  }
  else
  {

    // b = _.strLeft( src, begin );
    b = _.strLeft_( src, begin );

    if( b.entry === undefined )
    return notFound();

    // e = _.strRight( src, end, Math.min( b.index+1, src.length ) );
    // e = _.strRight_( src, end, Math.min( b.index, src.length-1 ) ); /* Dmytro : if cinterval is a Number, it is defined first index, not last */
    e = _.strRight_( src, end, Math.min( b.index, src.length ) );

    if( e.entry === undefined )
    return notFound();

  }

  if( e.index < b.index + b.entry.length )
  return notFound();

  let result =
  [
    src.substring( 0, b.index ),
    b.entry,
    src.substring( b.index + b.entry.length, e.index ),
    e.entry,
    src.substring( e.index + e.entry.length, src.length )
  ];

  return result;

  function notFound()
  {
    // return [ '', '', src, '', '' ];
    return [ '', undefined, src, undefined, '' ];
  }
}

//

/**
  * Routine isolateInside() split source strings of vector {-src-} into parts separated by delimeters {-begin-} and {-end-}. Routine
  * returns a vector with arrays. Each array of vector corresponds to element of vector {-src-}.
  * Each array contains of five parts:
  * - substring from start of source string to begin of first delimeter {-begin-}.
  * - delimeter {-begin-}.
  * - substring between delimeters {-begin-} and {-end-}.
  * - delimeter {-end-}.
  * - substring from end of delimeter {-end-} to end of source line.
  * If routine does not find part between {-begin-} and {-end-} delimeters, then routine transform begin and end substrings to empty
  * strings and delimeters to undefined.
  * So, finally routine returns the array with source string: [ '', undefined, {-src-}, undefined, '' ].
  *
  * @param { String|Array } src - The source string or vector of source strings. If {-src-} is a vector, then routine returns vector
  * with resulted arrays. Otherwise, routine returns only one resulted array for scalar source string.
  * @param { String|Array } begin - String or array of strings to find begin of split part in the source string.
  * @param { String|Array } end - String or array of strings to find end of split part in the source source.
  *
  * @example
  * _.strIsolateInside( 'aabdcdd', 'a', 'd' );
  * // returns [ '', 'a', 'abdcd', 'd', '' ]
  *
  * @example
  * _.strIsolateInside( 'cabdcdc', 'a', 'd' );
  * // returns [ 'c', 'a', 'bdc', 'd', 'c' ]
  *
  * @example
  * _.strIsolateInside( 'cabdcdc', 'f', 'd' );
  * // returns [ '', undefined, 'cabdcdc', undefined, '' ]
  *
  * @example
  * _.strIsolateInsideSignle( 'cabdcdc', 'a', 'f' );
  * // returns [ '', undefined, 'cabdcdc', undefined, '' ]
  *
  * @example
  * _.strIsolateInside( 'cabdcdc', [ 'f', 'b' ], 'd' );
  * // returns [ 'ca', 'b', 'dc', 'd', 'c' ]
  *
  * @example
  * _.strIsolateInside( 'cabdcdc', 'b', [ 'f', 'd' ] );
  * // returns [ 'ca', 'b', 'dc', 'd', 'c' ]
  *
  * @example
  * _.strIsolateInside( 'cabdcdc', [ 'b', 'c' ], [ 'c', 'd' ] );
  * // returns [ 'ca', 'b', 'dcd', 'c', '' ]
  *
  * @example
  * _.strIsolateInside( [ 'cabdcdc', 'ddccbbaa' ], 'b', 'd' );
  * // returns [ [ 'ca', 'b', 'dc', 'd', 'c' ], [ '', '', 'ddccbbaa', '', '' ] ]
  *
  * @example
  * _.strIsolateInside( [ 'cabdcdc', 'ddccbbaa' ], [ 'b', 'c' ], [ 'c', 'd' ] );
  * // returns [ [ 'ca', 'b', 'dcd', 'c', '' ], [ 'dd', 'c', '', 'c', 'bbaa' ] ]
  *
  * @returns { Array|ArraysVector } - If source string is a scalar, then routine returns array with parts of source string.
  * If source string is a vector, then routine returns vector of arrays.
  * @function isolateInside
  * @throws { Exception } If arguments.length is less then one or more then three.
  * @throws { Exception } If source string {-str-} is not a String.
  * @throws { Exception } If delimeter {-begin-} is not a String or an Array of strings.
  * @throws { Exception } If delimeter {-end-} is not a String or an Array of strings.
  * @namespace Tools
  */

function isolateInside( src, begin, end )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( _.argumentsArray.like( src ) )
  {
    let result = [];
    for( let s = 0 ; s < src.length ; s++ )
    result[ s ] = _.strIsolateInsideSignle( src[ s ], begin, end );
    return result;
  }
  else
  {
    return _.strIsolateInsideSignle( src, begin, end );
  }

}

// --
// str extension
// --

let StrExtension =
{

  isolate : _.routine.unite( strIsolate_head, strIsolate_body ),
  isolateLeftOrNone : _.routine.unite( strIsolate_head, strIsolateLeftOrNone_body ),
  isolateLeftOrAll : _.routine.unite( strIsolate_head, strIsolateLeftOrAll_body ),
  isolateRightOrNone : _.routine.unite( strIsolate_head, strIsolateRightOrNone_body ),
  isolateRightOrAll : _.routine.unite( strIsolate_head, strIsolateRightOrAll_body ),

  isolateInsideSignle,
  isolateInside,

}

Object.assign( _.str, StrExtension );

// --
// extension
// --

let ToolsExtension =
{

  strIsolate : _.routine.unite( strIsolate_head, strIsolate_body ),
  strIsolateLeftOrNone : _.routine.unite( strIsolate_head, strIsolateLeftOrNone_body ),
  strIsolateLeftOrAll : _.routine.unite( strIsolate_head, strIsolateLeftOrAll_body ),
  strIsolateRightOrNone : _.routine.unite( strIsolate_head, strIsolateRightOrNone_body ),
  strIsolateRightOrAll : _.routine.unite( strIsolate_head, strIsolateRightOrAll_body ),

  // strIsolateInsideOrNoneSingle,
  // strIsolateInsideOrNone,
  strIsolateInsideSignle : isolateInsideSignle,
  strIsolateInside : isolateInside,

}

Object.assign( _, ToolsExtension );

})();

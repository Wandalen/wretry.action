(function _Stringer_s_() {

'use strict';

/**
 * Stringer nicely stringifies structures does not matter how complex or cycled them are. Convenient tool for fast diagnostic and inspection of data during development and in production. Use it to see more, faster. Refactoring required.
 * Collection of tools for fast diagnostic and inspection of data during development and in production.
 @module Tools/base/Stringer
 @extends Tools
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

}

//

const Self = _global_.wTools;
const _global = _global_;
const _ = _global_.wTools;

const _ArraySlice = Array.prototype.slice;
const _FunctionBind = Function.prototype.bind;
const _ObjectToString = Object.prototype.toString;
const _ObjectHasOwnProperty = Object.hasOwnProperty;

//

/**
 * Short-cut for exportString function that works only with Routine type entities.
 * Converts object passed by argument( src ) to string representation using
 * options provided by argument( o ).
 *
 * @param {object} src - Source object.
 * @param {Object} o - conversion o {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @param {boolean} [ options.onlyRoutines=true ] - makes object behavior Routine only.
 * @see {@link wTools.exportStringFine} Check out main function for more usage options and details.
 * @returns {string} Returns string that represents object data.
 *
 * @example
 * //returns { routine add }
 * _.entity.exportStringMethods( ( function add(){} ), { } )
 *
 * @example
 * //returns { routine noname }
 * _.entity.exportStringMethods( ( function(){} ), { } )
 *
 * @function exportStringMethods
 * @namespace Tools
 * @module Tools/base/Stringer
 *
 */

function exportStringMethods( src, o )
{
  var o = o || Object.create( null );
  o.onlyRoutines = 1;
  var result = _.entity.exportStringFine( src, o );
  return result;
}

//

/**
 * Short-cut for exportString function that works with all entities, but ingnores Routine type.
 * Converts object passed by argument( src ) to string representation using
 * options provided by argument( o ).
 *
 * @param {object} src - Source object.
 * @param {Object} o - conversion o {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @param {boolean} [ options.noRoutine=false ] - Ignores all entities of type Routine.
 * @see {@link wTools.exportStringFine} Check out main function for more usage options and details.
 * @returns {string} Returns string that represents object data.
 *
 * @example
 * //returns [ 0, "a" ]
 * _.entity.exportStringFields( [ function del(){}, 0, 'a' ], {} )
 *
 * @example
 * //returns { c : 1, d : "2" }
 * _.entity.exportStringFields( { a : function b(){},  c : 1 , d : '2' }, {} )
 *
 * @function exportStringFields
 * @namespace Tools
 * @module Tools/base/Stringer
 *
 */

function exportStringFields( src, o )
{
  var o = o || Object.create( null );
  o.noRoutine = 1;
  var result = _.entity.exportStringFine( src, o );
  return result;
}

//

/**
* @summary Options object for exportString function.
* @typedef {Object} exportStringOptions
* @property {boolean} [ o.wrap=true ] - Wrap array-like and object-like entities
* into "[ .. ]" / "{ .. }" respecitvely.
* @property {boolean} [ o.stringWrapper='\'' ] - Wrap string into specified string.
* @property {boolean} [ o.multilinedString=false ] - Wrap string into backtick ( `` ).
* @property {number} [ o.level=0 ] - Sets the min depth of looking into source object. Function starts from zero level by default.
* @property {number} [ o.levels=1 ] - Restricts max depth of looking into source object. Looks only in one level by default.
* @property {number} [ o.limitElementsNumber=0 ] - Outputs limited number of elements from object or array.
* @property {number} [ o.widthLimit=0 ] - Outputs limited number of characters from source string.
* @property {boolean} [ o.prependTab=true ] - Prepend tab before first line.
* @property {boolean} [ o.errorAsMap=false ] - Interprets Error as Map if true.
* @property {boolean} [ o.onlyOwn=true ] - Use only onlyOwn properties of ( src ), ignore properties of ( src ) prototype.
* @property {string} [ o.tab='' ] - Prepended before each line tab.
* @property {string} [ o.dtab='  ' ] - String attached to ( o.tab ) each time the function parses next level of object depth.
* @property {string} [ o.colon=' : ' ] - Colon between name and value, example : { a : 1 }.
* @property {boolean} [ o.noRoutine=false ] - Ignores all entities of type Routine.
* @property {boolean} [ o.noAtomic=false ] - Ignores all entities of type Atomic.
* @property {boolean} [ o.noArray=false ] - Ignores all entities of type Array.
* @property {boolean} [ o.noObject=false ] - Ignores all entities of type Object.
* @property {boolean} [ o.noRow=false ] - Ignores all entities of type Row.
* @property {boolean} [ o.noError=false ] - Ignores all entities of type Error.
* @property {boolean} [ o.noNumber=false ] - Ignores all entities of type Number.
* @property {boolean} [ o.noString=false ] - Ignores all entities of type String.
* @property {boolean} [ o.noUndefines=false ] - Ignores all entities of type Undefined.
* @property {boolean} [ o.noDate=false ] - Ignores all entities of type Date.
* @property {boolean} [ o.onlyRoutines=false ] - Ignores all entities, but Routine.
* @property {boolean} [ o.onlyEnumerable=true ] - Ignores all non-enumerable properties of object ( src ).
* @property {boolean} [ o.noSubObject=false ] - Ignores all child entities of type Object.
* @property {number} [ o.precision=null ] - An integer specifying the number of significant digits, example : [ '1500' ].
* Number must be between 1 and 21.
* @property {number} [ o.fixed=null ] - The number of digits to appear after the decimal point, example : [ '58912.001' ].
* Number must be between 0 and 20.
* @property {string} [ o.comma=', ' ] - Splitter between elements, example : [ 1, 2, 3 ].
* @property {boolean} [ o.multiline=false ] - Writes each object property in new line.
* @property {boolean} [ o.escaping=false ] - enable escaping of special characters.
* @property {boolean} [ o.jsonLike=false ] - enable conversion to JSON string.
* @property {boolean} [ o.jsLike=false ] - enable conversion to JS string.
* @namespace Tools
 * @module Tools/base/Stringer
*/

/**
 * Converts object passed by argument( src ) to string format using parameters passed
 * by argument( o ).If object ( src ) has onlyOwn ( exportString ) method defined function uses it for conversion.
 *
 * @param {object} src - Source object for representing it as string.
 * @param {Object} o - conversion o {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @returns {string} Returns string that represents object data.
 *
 * @example
 * //Each time function parses next level of object depth
 * //the ( o.dtab ) string ( '-' ) is attached to ( o.tab ).
 * //returns
 * // { // level 1
 * // -a : 1,
 * // -b : 2,
 * // -c :
 * // -{ // level 2
 * // --subd : "some test",
 * // --sube : true,
 * // --subf : {  x : 1  // level 3}
 * // -}
 * // }
 * _.entity.exportString( { a : 1, b : 2, c : { subd : 'some test', sube : true, subf : { x : 1 } } }, { levels : 3, dtab : '-'} );
 *
 * @example
 * //returns " \n1500 "
 * _.entity.exportString( ' \n1500 ', { escaping : 1 } );
 *
 * @example
 * //returns
 * // "
 * // 1500 "
 * _.entity.exportString( ' \n1500 ' );
 *
 * @example
 * //returns 14.5333
 * _.entity.exportString( 14.5333 );
 *
 * @example
 * //returns 1.50e+3
 * _.entity.exportString( 1500, { precision : 3 } );
 *
 * @example
 * //returns 14.53
 * _.entity.exportString( 14.5333, { fixed : 2 } );
 *
 * @example
 * //returns true
 * _.entity.exportString( 1 !== 2 );
 *
 * @example
 * //returns ''
 * _.entity.exportString( 1 !== 2, { noAtomic :  1 } );
 *
 * @example
 * //returns [ 1, 2, 3, 4 ]
 * _.entity.exportString( [ 1, 2, 3, 4 ] );
 *
 * @example
 * //returns [Array with 3 elements]
 * _.entity.exportString( [ 'a', 'b', 'c' ], { levels : 0 } );
 *
 * @example
 * //returns [ 1, 2, 3 ]
 * _.entity.exportString( _.entity.exportString( [ 'a', 'b', 'c', 1, 2, 3 ], { levels : 2, noString : 1} ) );
 *
 * @example
 * //returns
 * // [
 * //  { Object with 1 elements },
 * //  { Object with 1 elements }
 * // ]
 * _.entity.exportString( [ { a : 1 }, { b : 2 } ] );
 *
 * @example
 * //returns
 * // "    a : 1
 * //      b : 2"
 * _.entity.exportString( [ { a : 1 }, { b : 2 } ], { levels : 2, wrap : 0 } );
 *
 * @example
 * //returns
 * // [
 * //  { a : 1 },
 * //  { b : 2 }
 * // ]
 * _.entity.exportString( [ { a : 1 }, { b : 2 } ], { levels : 2 } );
 *
 * @example
 * //returns 1 , 2 , 3 , 4
 * _.entity.exportString( [ 1, 2, 3, 4 ], { wrap : 0, comma : ' , ' } );
 *
 * @example
 * //returns [ 0.11, 40 ]
 * _.entity.exportString( [ 0.11112, 40.4 ], { precision : 2 } );
 *
 * @example
 * //returns [ 2.00, 1.56 ]
 * _.entity.exportString( [ 1.9999, 1.5555 ], { fixed : 2 } );
 *
 * @example
 * //returns
 * // [
 * //  0,
 * //  [
 * //   1,
 * //   2,
 * //   3
 * //  ],
 * //  4
 * // ]
 * _.entity.exportString( [ 0, [ 1, 2, 3 ], 4 ], { levels : 2, multiline : 1 } );
 *
 * @example
 * //returns [ 1, 2, [ other 3 element(s) ] ]
 * _.entity.exportString( [ 1, 2 , 3, 4, 5 ], { limitElementsNumber : 2 } );
 *
 * @example
 * //returns [ routine sample ]
 * _.entity.exportString( function sample( ){ });
 *
 * @example
 * //returns [ rotuine without name ]
 * _.entity.exportString( function add( ){ }, { levels : 0 } );
 *
 * @example
 * //If object ( src ) has onlyOwn ( exportString ) method defined function uses it for conversion
 * //returns
 * //function func(  ) {
 * //console.log('sample');
 * //}
 * var x = function func (  )
 * {
 *   console.log( 'sample' );
 * }
 * x.exportString = x.toString;
 * _.entity.exportString( x );
 *
 * @example
 * //returns { o : 1, y : 3 }
 * _.entity.exportString( { o : 1, y : 3 } );
 *
 * @example
 * //returns { Object with 1 elements }
 * _.entity.exportString( { o : 1 }, { levels : 0 } );
 *
 * @example
 * //returns
 * {
 *    o : { p : "value" }
 * }
 * _.entity.exportString( { o : { p : 'value' } }, { levels : 2 } );
 *
 * @example
 * //returns
 * // {
 * //   y : "value1"
 * // }
 * _.entity.exportString( { y : 'value1', o : { p : 'value2' } }, { levels : 2, noSubObject : 1} );
 *
 * @example
 * //returns a : 1 | b : 2
 * _.entity.exportString( { a : 1, b : 2 }, { wrap : 0, comma : ' | ' } );
 *
 * @example
 * //returns { b : 1, c : 2 }
 * _.entity.exportString( { a : 'string', b : 1 , c : 2  }, { levels : 2 , noString : 1 } );
 *
 * @example
 * //returns { a : string, b : str, c : 2 }
 * _.entity.exportString( { a : 'string', b : "str" , c : 2  }, { levels : 2 , stringWrapper : '' } );
 *
 * @example
 * //returns { "a" : "string", "b" : 1, "c" : 2 }
 * _.entity.exportString( { a : 'string', b : 1 , c : 2  }, { levels : 2 , jsonLike : 1 } );
 *
 * @example
 * //returns
 * // '{',
 * // '  a : 1, ',
 * // ' b : 2, ',
 * // '{ other 2 element(s) }',
 * // '}',
 * _.entity.exportString( { a : 1, b : 2, c : 3, d : 4 }, { limitElementsNumber : 2 } );
 *
 * @example
 * //returns { stack : "Error: my message2"..., message : "my message2" }
 * _.entity.exportString( new Error('my message2'), { onlyEnumerable : 0, errorAsMap : 1 } );
 *
 * @example
 * //returns
 * // "{
 * //  a : `line1
 * // line2
 * // line3`
 * // }"
 * _.entity.exportString( { a : "line1\nline2\nline3" }, { levels: 2, multilinedString : 1 } );
 *
 * @function exportString
 * @throws { Exception } Throw an exception if( o ) is not a Object.
 * @throws { Exception } Throw an exception if( o.stringWrapper ) is not equal true when ( o.jsonLike ) is true.
 * @throws { Exception } Throw an exception if( o.multilinedString ) is not equal false when ( o.jsonLike ) is true.
 * @throws { RangeError } Throw an exception if( o.precision ) is not between 1 and 21.
 * @throws { RangeError } Throw an exception if( o.fixed ) is not between 0 and 20.
 * @namespace Tools
 * @module Tools/base/Stringer
 *
 */

function _exportStringFine_functor()
{

  var primeFilter =
  {

    noRoutine : 0,
    noAtomic : 0,
    noArray : 0,
    noObject : 0,
    noRow : 0,
    noError : 0,
    noNumber : 0,
    noString : 0,
    noDate : 0,
    noUndefines : 0,

  }

  var composes =
  {

    levels : 1,
    level : 0,

    wrap : 1,
    // stringWrapper : '\'',
    stringWrapper : null,
    keyWrapper : '',
    prependTab : 1,
    errorAsMap : 0,
    onlyOwn : 1,
    tab : '',
    dtab : '  ',
    colon : ' : ',
    limitElementsNumber : 0,
    widthLimit : 0,
    heightLimit : 0,

    format : 'string.diagnostic',

  }

  /**/

  var optional =
  {

    /* secondary filter */

    noSubObject : 0,
    onlyRoutines : 0,
    onlyEnumerable : 1,

    /**/

    precision : null,
    fixed : null,
    // comma : ', ',
    comma : null,
    multiline : 0,
    multilinedString : null,
    escaping : 0,
    jsonLike : 0,
    jsLike : 0,

  }

  var restricts =
  {
    /*level : 0, */
  }

  Object.preventExtensions( primeFilter );
  Object.preventExtensions( composes );
  Object.preventExtensions( optional );
  Object.preventExtensions( restricts );

  var def;

  def = _.props.extend( null, optional, primeFilter, composes );

  var routine = exportStringFine;
  routine.defaults = def;
  routine.methods = _.entity.exportStringMethods;
  routine.fields = _.entity.exportStringFields;
  // routine.notMethod = 1;
  return routine;

  function exportStringFine( src, o )
  {

    _.assert( arguments.length === 1 || arguments.length === 2 );
    _.assert( _.object.isBasic( o ) || o === undefined, 'Expects map {-o-}' );

    var o = o || Object.create( null );
    var exportStringDefaults = Object.create( null );
    // if( !_.primitiveIs( src ) && 'exportString' in src && _.routineIs( src.exportString ) && !src.exportString.notMethod && _.object.isBasic( src.exportString.defaults ) )
    if( !_.primitiveIs( src ) && 'exportString' in src && _.routineIs( src.exportString ) && _.instanceIs( src ) && _.object.isBasic( src.exportString.defaults ) )
    exportStringDefaults = src.exportString.defaults;

    if( o.levels === undefined || o.levels === null )
    if( o.jsonLike || o.jsLike )
    o.levels = 1 << 20;

    if( o.jsLike )
    {
      if( o.escaping === undefined || o.escaping === null )
      o.escaping = 1;
      if( o.keyWrapper === undefined || o.keyWrapper === null )
      o.keyWrapper = '"';
      if( o.stringWrapper === undefined || o.stringWrapper === null )
      o.stringWrapper = '`';
    }

    if( o.jsonLike )
    {
      if( o.escaping === undefined || o.escaping === null )
      o.escaping = 1;
      if( o.keyWrapper === undefined || o.keyWrapper === null )
      o.keyWrapper = '"';
      if( o.stringWrapper === undefined || o.stringWrapper === null )
      o.stringWrapper = '"';
    }

    // _.map.assertHasOnly( o, [ composes, primeFilter, optional ] );
    // o = _.props.supplement( null, o, exportStringDefaults, composes, primeFilter );

    _.map.assertHasOnly( o, def );
    o = _.props.supplement( o, def );

    if( o.multilinedString === undefined || o.multilinedString === null )
    o.multilinedString = o.stringWrapper === '`';

    if( o.stringWrapper === undefined || o.stringWrapper === null )
    if( o.multilinedString )
    o.stringWrapper = '`';
    else
    o.stringWrapper = `'`;

    if( o.onlyRoutines )
    {
      _.assert( !o.noRoutine, 'Expects {-o.noRoutine-} false if( o.onlyRoutines ) is true' );
      for( var f in primeFilter )
      o[ f ] = 1;
      o.noRoutine = 0;
    }

    if( o.comma === undefined || o.comma === null )
    o.comma = o.wrap ? ', ' : ' ';

    if( o.comma && !_.strIs( o.comma ) )
    o.comma = ', ';

    // if( o.stringWrapper === '`' && o.multilinedString === undefined )
    // o.multilinedString = 1;

    _.assert( _.strIs( o.stringWrapper ), 'Expects string {-o.stringWrapper-}' );

    if( o.jsonLike )
    {
      if( !o.jsLike )
      _.assert( o.stringWrapper === '"', 'Expects double quote ( o.stringWrapper ) true if either ( o.jsonLike ) or ( o.jsLike ) is true' );
      _.assert( !o.multilinedString, 'Expects {-o.multilinedString-} false if either ( o.jsonLike ) or ( o.jsLike ) is true to make valid JSON' );
    }

    var r = _.entity._exportString( src, o );

    return r ? r.text : '';
  }

}

//

let exportStringFine = _exportStringFine_functor();
exportStringFine.functor = _exportStringFine_functor;
let exportString = exportStringFine;
_.assert( exportString.defaults.multilinedString !== undefined );

//

function exportStringNice( src, o )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  o = _.routine.options_( exportStringNice, o || null );

  var result = _.entity.exportString( src, o );

  return result;
}

exportStringNice.defaults =
{
  ... exportStringFine.defaults,
  escaping : 0,
  multilinedString : 0,
  multiline : 1,
  levels : 9,
  stringWrapper : '',
  keyWrapper : '',
  tab : '',
  wrap : 0,
  comma : '',
}

//

function exportStringSolo( src, o )
{
  o = _.routine.options_( exportStringSolo, o || null );
  let result = _.entity.exportStringNice( src, o );
  // return _.strReplace( result, '\n', ' ' );
  return _.entity.exportStringNice( src, o )
  .split( '\n' )
  .map( ( e ) => e.trim() )
  .join( ' ' );
}

exportStringSolo.defaults =
{
  ... exportStringNice.defaults,
  levels : 1,
}

//

function exportJson( src, o )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  o = _.routine.options_( exportJson, o || null );

  if( o.cloning )
  src = _.cloneData({ src });

  delete o.cloning;

  var result = _.entity.exportString( src, o );

  return result;
}

exportJson.defaults =
{
  jsonLike : 1,
  levels : 1 << 20,
  cloning : 1,
}

//

function exportJs( src, o )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  o = _.routine.options_( exportJs, o || null );

  var result = _.entity.exportString( src, o );

  return result;
}

exportJs.defaults =
{
  escaping : 1,
  multilinedString : 1,
  levels : 1 << 20,
  stringWrapper : null,
  keyWrapper : null,
  jsLike : 1,
}

//

function _exportString( src, o )
{

  if( o.precision !== null )
  if( o.precision < 1 || o.precision > 21 )
  {
    throw _.err( 'RangeError' );
  }

  if( o.fixed !== null )
  if( o.fixed < 0 || o.fixed > 20 )
  throw _.err( 'RangeError' );

  var result = '';
  var simple = 1;
  var type = _.entity.strTypeSecondary( src );

  if( o.level >= o.levels )
  {
    return { text : _.entity._exportStringShortAct( src, o ), simple : 1 };
  }

  if( !_.entity._exportStringIsVisibleElement( src, o ) )
  return;

  var isPrimitive = _.primitiveIs( src );
  var isLong = _.longIs( src );
  var isArray = _.arrayIs( src );
  var isObject = !isLong && _.object.isBasic( src );
  var isObjectLike = !isLong && _.objectLike( src ) && !( 'toString' in src );

  /* */

  // if( !isPrimitive && 'exportString' in src && _.routineIs( src.exportString ) && !src.exportString.notMethod && !_ObjectHasOwnProperty.call( src, 'constructor' ) )
  if( !isPrimitive && 'exportString' in src && _.routineIs( src.exportString ) && _.instanceIs( src ) )
  {

    _.assert
    (
      src.exportString.length === 0 || src.exportString.length === 1,
      'Method exportString should expect either none or one argument'
    );

    // var r = src.exportString( o );
    var r = src.exportString({ it : o });
    if( _.object.isBasic( r ) )
    {
      _.assert( r.simple !== undefined && r.text !== undefined );
      simple = r.simple;
      result += r.text;
    }
    else if( _.strIs( r ) )
    {
      simple = r.indexOf( '\n' ) === -1;
      result += r;
    }
    else throw _.err( 'unexpected' );

  }
  // else if( _.vectorAdapterIs( src ) )
  // {
  //   result += _.vectorAdapter.exportString( src, o );
  // }
  else if( _.errIs( src ) )
  {

    if( !o.errorAsMap )
    {
      result += src.toString();
    }
    else
    {
      if( o.onlyEnumerable === undefined || o.onlyEnumerable === null )
      o.onlyEnumerable = 1;
      var o2 = _.props.extend( null, o );
      o2.onlyEnumerable = 0;
      var r = _.entity._exportStringFromObject( src, o2 );
      result += r.text;
      simple = r.simple;
    }

  }
  else if( type === 'Function' )
  {
    result += _.entity._exportStringFromRoutine( src, o );
  }
  else if( type === 'Number' && _.numberIs( src ) )
  {
    result += _.entity._exportStringFromNumber( src, o );
  }
  else if( type === 'BigInt' )
  {
    result += _.entity._exportStringFromBigInt( src, o );
  }
  else if( type === 'String' )
  {
    result += _.entity._exportStringFromStr( src, o );
  }
  else if( type === 'Date' )
  {
    if( o.jsonLike )
    result += '"' + src.toISOString() + '"';
    else if( o.jsLike )
    result += 'new Date( \'' + src.toISOString() + '\' )';
    else
    result += src.toISOString();
  }
  else if( type === 'Symbol' )
  {
    result += _.entity._exportStringFromSymbol( src, o );
  }
  else if( _.bufferRawIs( src ) )
  {
    var r = _.entity._exportStringFromBufferRaw( src, o );
    result += r.text;
    simple = r.simple;
  }
  else if( _.bufferTypedIs( src ) )
  {
    var r = _.entity._exportStringFromBufferTyped( src, o );
    result += r.text;
    simple = r.simple;
  }
  else if( _.bufferNodeIs( src ) )
  {
    var r = _.entity._exportStringFromBufferNode( src, o );
    result += r.text;
    simple = r.simple;
  }
  else if( isLong )
  {
    var r = _.entity._exportStringFromArray( src, o );
    result += r.text;
    simple = r.simple;
  }
  else if( isObject )
  {
    var r = _.entity._exportStringFromObject( src, o );
    result += r.text;
    simple = r.simple;
  }
  else if( _.hashMapLike( src ) )
  {
    var r = _.entity._exportStringFromHashMap( src, o );
    result += r.text;
    simple = r.simple;
  }
  else if( _.setLike( src ) )
  {
    var r = _.entity._exportStringFromSet( src, o );
    result += r.text;
    simple = r.simple;
  }
  else if( !isPrimitive && _.routineIs( src.toString ) )
  {
    result += src.toString();
  }
  else
  {
    if( o.jsonLike )
    {
      if( src === undefined || src === NaN )
      result += 'null';
      else
      result += String( src );
    }
    else
    {
      result += String( src );
    }
  }

  return { text : result, simple };
}

//

/**
 * Converts object passed by argument( src ) to string representation using
 * options provided by argument( o ) for string and number types.
 * Returns string with object type for routines and errors, iso format for date, string representation for atomic.
 * For object, array and row returns count of elemets, example: '[ Row with 3 elements ]'.
 *
 * @param {object} src - Source object.
 * @param {Object} o - Conversion options {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @returns {string} Returns string that represents object data.
 *
 * @example
 * //returns [ Array with 3 elements ]
 * _._exportStringShortAct( [ function del(){}, 0, 'a' ], { levels : 0 } )
 *
 * @function _exportStringShortAct
 * @namespace Tools
 * @module Tools/base/Stringer
 *
 */

function _exportStringShortAct( src, o )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.object.isBasic( o ), 'Expects map {-o-}' );

  var result = '';

  try
  {

    if( _.strIs( src ) )
    {

      /* xxx : ? */
      var o2 =
      {
        widthLimit : o.widthLimit ? Math.min( o.widthLimit, 40 ) : 40,
        heightLimit : o.heightLimit || 0,
        stringWrapper : o.stringWrapper,
        prefix : o.prefix,
        postfix : o.postfix,
        infix : o.infix,
        shortDelimeter : o.shortDelimeter,
      }
      result = _.entity._exportStringFromStr( src, o2 );

    }
    else if( _.errIs( src ) )
    {
      result += _ObjectToString.call( src );
    }
    else if( _.routineIs( src ) )
    {
      result += _.entity._exportStringFromRoutine( src, o );
    }
    else if( _.numberIs( src ) )
    {
      result += _.entity._exportStringFromNumber( src, o );
    }
    else
    {
      result = _.entity.exportStringDiagnosticShallow( src );
    }

  }
  catch( err )
  {
    throw _.err( err );
  }

  return result;
}

//

/**
 * Checks if object provided by argument( src ) must be ignored by exportString() function.
 * Filters are provided by argument( o ).
 * Returns false if object must be ignored.
 *
 * @param {object} src - Source object.
 * @param {Object} o - Filters {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @returns {boolean} Returns result of filter check.
 *
 * @example
 * //returns false
 * _.entity.exportStringIsVisibleElement( function del(){}, { noRoutine : 1 } );
 *
 * @function _exportStringIsVisibleElement
 * @namespace Tools
 * @module Tools/base/Stringer
 *
 */

function _exportStringIsVisibleElement( src, o )
{

  var isPrimitive = _.primitiveIs( src );
  var isArray = _.longIs( src );
  var isObject = !isArray && _.objectLike( src );
  var type = _.entity.strTypeSecondary( src );

  /* */

  // if( !isPrimitive && 'exportString' in src && _.routineIs( src.exportString ) && !src.exportString.notMethod )
  if( !isPrimitive && 'exportString' in src && _.routineIs( src.exportString ) && _.instanceIs( src ) )
  {
    if( isObject && o.noObject )
    return false;
    if( isArray && o.noArray )
    return false;

    return true;
  }
  else if( _.vectorAdapterIs( src ) )
  {
    if( o.noRow )
    return false;
    return true;
  }
  else if( _.errIs( src ) )
  {
    if( o.noError )
    return false;
    return true;
  }
  else if( type === 'Function' )
  {
    if( o.noRoutine )
    return false;
    return true;
  }
  else if( type === 'Number' )
  {
    if( o.noNumber || o.noAtomic )
    return false;
    return true;
  }
  else if( type === 'String' )
  {
    if( o.noString || o.noAtomic  )
    return false;
    return true;
  }
  else if( type === 'Date' )
  {
    if( o.noDate )
    return false;
    return true;
  }
  else if( isArray )
  {
    if( o.noArray )
    return false;

    if( !o.wrap )
    {
      src = _.entity._exportStringFromArrayFiltered( src, o );
      if( !src.length )
      return false;
    }

    return true;
  }
  else if( isObject )
  {
    if( o.noObject )
    return false;

    if( !o.wrap )
    {
      var keys = _.entity._exportStringFromObjectKeysFiltered( src, o );
      if( !keys.length )
      return false;
    }

    return true;
  }
  else if( !isPrimitive && _.routineIs( src.toString ) )
  {
    if( isObject && o.noObject )
    return false;
    if( isArray && o.noArray )
    return false;
    return true;
  }
  else
  {
    if( o.noAtomic )
    return false;
    if( o.noUndefines && src === undefined )
    return false;
    return true;
  }

}

//

/**
 * Checks if object length provided by argument( element ) is enough to represent it as single line string.
 * Options are provided by argument( o ).
 * Returns true if object can be represented as one line.
 *
 * @param {object} element - Source object.
 * @param {Object} o - Check options {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @param {boolean} [ o.escaping=false ] - enable escaping of special characters.
 * @returns {boolean} Returns result of length check.
 *
 * @example
 * //returns true
 * _.entity.exportStringIsSimpleElement( 'string', { } );
 *
 * @example
 * //returns false
 * _.entity.exportStringIsSimpleElement( { a : 1, b : 2, c : 3, d : 4, e : 5 }, { } );
 *
 * @function _exportStringIsSimpleElement
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 2.
 * @namespace Tools
 * @module Tools/base/Stringer
 *
 */

function _exportStringIsSimpleElement( element, o )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.object.isBasic( o ) || o === undefined, 'Expects map {-o-}' );

  if( _.strIs( element ) )
  {
    if( element.length > 40 )
    return false;
    if( !o.escaping )
    return element.indexOf( '\n' ) === -1;
    return true;
  }
  else if( element && !_.object.isBasic( element ) && _.numberIs( element.length ) )
  return !element.length;
  else if( _.object.isBasic( element ) || _.objectLike( element ) )
  return !_.entity.lengthOf( element );
  else
  return _.primitiveIs( element );

}

//

/**
 * Returns string representation of routine provided by argument( src ) using options
 * from argument( o ).
 *
 * @param {object} src - Source object.
 * @param {Object} o - conversion options {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @returns {string} Returns routine as string.
 *
 * @example
 * //returns [ routine a ]
 * _.entity.exportStringFromRoutine( function a(){}, {} );
 *
 * @function _exportStringFromRoutine
 * @namespace Tools
 * @module Tools/base/Stringer
 *
 */

function _exportStringFromRoutine( src, o )
{
  var result = '';

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.routineIs( src ), 'Expects routine {-src-}' );

  if( o.jsLike )
  {
    if( _.routineSourceGet )
    result = _.routineSourceGet( src );
    else
    result = src.toString();
  }
  else
  {
    result = '[ routine ' + ( src.name || src._name || 'without name' ) + ' ]';
  }

  return result;
}

//

/**
 * Converts Number( src ) to String using one of two possible options: precision or fixed.
 * If no option specified returns source( src ) as simple string.
 *
 * @param {Number} src - Number to convert.
 * @param {Object} o - Contains conversion options {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @returns {String} Returns number converted to the string.
 *
 * @example
 * //returns 8.9
 * _._exportStringFromNumber( 8.923964453, { precision : 2 } );
 *
 * @example
 * //returns 8.9240
 * _._exportStringFromNumber( 8.923964453, { fixed : 4 } );
 *
 * @example
 * //returns 8.92
 * _._exportStringFromNumber( 8.92, { } );
 *
 * @function _exportStringFromNumber
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If( src ) is not a Number.
 * @throws {Exception} If( o ) is not a Object.
 * @throws {RangeError} If( o.precision ) is not between 1 and 21.
 * @throws {RangeError} If( o.fixed ) is not between 0 and 20.
 * @namespace Tools
 * @module Tools/base/Stringer
 *
*/

function _exportStringFromNumber( src, o )
{
  var result = '';

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( src ) && _.object.isBasic( o ) );

  if( o.precision !== null )
  if( o.precision < 1 || o.precision > 21 )
  throw _.err( 'RangeError' );

  if( o.fixed !== null )
  if( o.fixed < 0 || o.fixed > 20 )
  throw _.err( 'RangeError' );

  if( _.numberIs( o.precision ) )
  result += src.toPrecision( o.precision );
  else if( _.numberIs( o.fixed ) )
  result += src.toFixed( o.fixed );
  else
  result += String( src );

  if( Object.is( src, -0 ) )
  result = '-' + result;

  return result;
}

//

function _exportStringFromBigInt( src, o )
{
  let result = '';

  if( o.jsonLike )
  result += '"' + src.toString() + 'n"';
  else if( o.jsLike )
  result += src.toString() + 'n';
  else
  result += String( src );

  return result;
}

//

function _exportStringFromSymbol( src, o )
{
  let text = src.toString().slice( 7, -1 );
  let result = `{- Symbol${text ? ' ' + text + ' ' : ' '}-}`;
  return result;
}

//

/**
 * Adjusts source string. Takes string from argument( src ) and options from argument( o ).
 * Limits string length using option( o.widthLimit ), disables escaping characters using option( o.escaping ),
 * wraps source into specified string using( o.stringWrapper ).
 * Returns result as new string or source string if no changes maded.
 *
 * @param {object} src - String to parse.
 * @param {Object} o - Contains conversion  options {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @returns {String} Returns result of adjustments as new string.
 *
 * @example
 * //returns "hello"
 * _._exportStringFromStr( 'hello', {} );
 *
 * @example
 * //returns "test\n"
 * _._exportStringFromStr( 'test\n', { escaping : 1 } );
 *
 * @example
 * //returns [ "t" ... "t" ]
 * _._exportStringFromStr( 'test', { widthLimit: 2 } );
 *
 * @example
 * //returns `test`
 * _._exportStringFromStr( 'test', { stringWrapper : '`' } );
 *
 * @function _exportStringFromStr
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If( src ) is not a String.
 * @throws {Exception} If( o ) is not a Object.
 * @namespace Tools
 * @module Tools/base/Stringer
 *
*/

function _exportStringFromStr( src, o )
{
  var result = '';

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( src ), 'Expects string {-src-}' );
  _.assert( _.object.isBasic( o ) || o === undefined, 'Expects map {-o-}' );

  if( o.stringWrapper === undefined )
  o.stringWrapper = `\'`;

  var q = o.stringWrapper;

  if( o.widthLimit )
  {

    if( o.shortDelimeter === undefined || o.shortDelimeter === null )
    o.shortDelimeter = _.strShort_.defaults.delimeter || '...';

    result = _.strShort_
    ({
      src : _.strEscape( src ),
      widthLimit : o.widthLimit - q.length*2,
      heightLimit : o.heightLimit || 0,
      delimeter : o.shortDelimeter,
    }).result;

    // if( result.length > o.widthLimit )
    // {
    //   result = '[ ' + result + ' ]';
    //   q = '';
    // }
  }
  else if( o.escaping )
  {
    if( o.stringWrapper === undefined )
    debugger;
    result = _.strEscape({ src, stringWrapper : o.stringWrapper });
  }
  else
  {
    result = src;
  }

  // if( o.stringWrapper && !o.widthLimit )
  // {
  //   result = q + result + q;
  // }

  if( q )
  // if( !o.widthLimit || result.length < o.widthLimit )
  {
    result = q + result + q;
  }

  return result;
}

//

function _exportStringFromHashMap( src, o )
{
  var result = 'HashMap\n';
  var simple = 0;

  _.assert( src instanceof HashMap );

  src.forEach( function( e, k )
  {
    // result += '\n' + k + ' : ' + e;
    result += '\n' + k + ' : ' + _.entity.exportStringDiagnosticShallow( e );
  });

  return { text : result, simple : 0 };

  /* item options */

  var optionsItem = _.props.extend( null, o );
  optionsItem.noObject = o.noSubObject ? 1 : optionsItem.noObject;
  optionsItem.tab = o.tab + o.dtab;
  optionsItem.level = o.level + 1;
  optionsItem.prependTab = 0;

  /* get names */

  var keys = _.entity._exportStringFromObjectKeysFiltered( src, o );

  /* empty case */

  var length = keys.length;
  if( length === 0 )
  {
    if( !o.wrap )
    return { text : '', simple : 1 };
    return { text : '{}', simple : 1 };
  }

  /* is simple */

  var simple = !optionsItem.multiline;
  if( simple )
  simple = length < 4;
  if( simple )
  for( var k in src )
  {
    simple = _.entity._exportStringIsSimpleElement( src[ k ], optionsItem );
    if( !simple )
    break;
  }

  /* */

  result += _.entity._exportStringFromContainer
  ({
    values : src,
    names : keys,
    optionsContainer : o,
    optionsItem,
    simple,
    prefix : '{',
    postfix : '}',
  });

  return { text : result, simple };
}

//

function _exportStringFromSet( src, o )
{
  let result = _.entity._exportStringFromArray( _.array.from( src ), o );
  result.text = `new Set(${result.text})` ;
  return result;
}

//

function _exportStringFromBufferTyped( src, o )
{
  var result = '';

  _.assert( _.bufferTypedIs( src ) );

  src.forEach( function( e, k )
  {
    if( k !== 0 )
    result += ', ';
    result += _.entity._exportStringFromNumber( e, o );
  });

  result = '( new ' + src.constructor.name + '([ ' + result + ' ]) )';

  return { text : result, simple : true };
}

//

function _exportStringFromBufferRaw( src, o )
{
  var result = '';

  _.assert( _.bufferRawIs( src ) );

  ( new U8x( src ) ).forEach( function( e, k )
  {
    if( k !== 0 )
    result += ', ';
    result += '0x' + e.toString( 16 );
  });

  result = '( new U8x([ ' + result + ' ]) ).buffer';

  return { text : result, simple : true };
}

//

function _exportStringFromBufferNode( src, o )
{
  var result = '';

  _.assert( _.bufferNodeIs( src ) );

  let k = 0;
  for ( let value of src.values() )
  {
    if( k !== 0 )
    result += ', ';
    result += value;
    ++k;
  }

  result = '( BufferNode.from([ ' + result + ' ]) )';

  return { text : result, simple : true };
}

//

function _exportStringFromArrayFiltered( src, o )
{
  var result = '';

  _.assert( arguments.length === 2 );

  /* item options */

  var optionsItem = _.props.extend( null, o );
  optionsItem.level = o.level + 1;

  /* filter */

  var v = 0;
  var length = src.length;
  for( var i = 0 ; i < length ; i++ )
  {
    v += !!_.entity._exportStringIsVisibleElement( src[ i ], optionsItem );
  }

  if( v !== length )
  {
    var i2 = 0;
    var i = 0;
    var src2 = _.long.makeUndefined( src, v );
    while( i < length )
    {
      if( _.entity._exportStringIsVisibleElement( src[ i ], optionsItem ) )
      {
        src2[ i2 ] = src[ i ];
        i2 += 1;
      }
      i += 1;
    }
    src = src2;
    length = src.length;
  }

  return src;
}

//

/**
 * Converts array provided by argument( src ) into string representation using options provided by argument( o ).
 *
 * @param {object} src - Array to convert.
 * @param {Object} o - Contains conversion options {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @returns {String} Returns string representation of array.
 *
 * @example
 * //returns
 * //[
 * //  [ Object with 1 elements ],
 * //  [ Object with 1 elements ]
 * //]
 * _.entity.exportStringFromArray( [ { a : 1 }, { b : 2 } ], {} );
 *
 * @example
 * //returns
 * // [
 * //   1,
 * //   [
 * //     2,
 * //     3,
 * //     4'
 * //   ],
 * //   5
 * // ]
 * _.entity.exportStringFromArray( [ 1, [ 2, 3, 4 ], 5 ], { levels : 2, multiline : 1 } );
 *
 * @function _exportStringFromArray
 * @throws { Exception } If( src ) is undefined.
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( o ) is not a Object.
 * @namespace Tools
 * @module Tools/base/Stringer
 *
 */

function _exportStringFromArray( src, o )
{
  var result = '';

  _.assert( arguments.length === 2 );
  _.assert( src && _.numberIs( src.length ) );
  _.assert( _.object.isBasic( o ) || o === undefined, 'Expects map {-o-}' );


  if( o.level >= o.levels )
  {
    return { text : _.entity._exportStringShortAct( src, o ), simple : 1 };
  }

  /* item options */

  var optionsItem = _.props.extend( null, o );
  optionsItem.tab = o.tab + o.dtab;
  optionsItem.level = o.level + 1;
  optionsItem.prependTab = 0;

  /* empty case */

  if( src.length === 0 )
  {
    if( !o.wrap )
    return { text : '', simple : 1 };
    return { text : '[]', simple : 1 };
  }

  /* filter */

  src = _.entity._exportStringFromArrayFiltered( src, o );

  /* is simple */

  var length = src.length;
  var simple = !optionsItem.multiline;
  if( simple )
  simple = length < 8;
  if( simple )
  for( var i = 0 ; i < length ; i++ )
  {
    simple = _.entity._exportStringIsSimpleElement( src[ i ], optionsItem );;
    if( !simple )
    break;
  }

  /* */

  result += _.entity._exportStringFromContainer
  ({
    values : src,
    optionsContainer : o,
    optionsItem,
    simple,
    prefix : '[',
    postfix : ']',
  });

  return { text : result, simple };
}

//

/**
 * Builds string representation of container structure using options from
 * argument( o ). Takes keys from option( o.names ) and values from option( o.values ).
 * Wraps array-like and object-like entities using ( o.prefix ) and ( o.postfix ).
 *
 * @param {object} o - Contains data and options.
 * @param {object} [ o.values ] - Source object that contains values.
 * @param {array} [ o.names ] - Source object keys.
 * @param {string} [ o.prefix ] - Denotes begin of container.
 * @param {string} [ o.postfix ] - Denotes end of container.
 * @param {Object} o.optionsContainer - Options for container {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @param {Object} o.optionsItem - Options for item {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @returns {String} Returns string representation of container.
 *
 * @function _exportStringFromContainer
 * @throws { Exception } If no argument provided.
 * @throws { Exception } If( o ) is not a Object.
 * @namespace Tools
 * @module Tools/base/Stringer
 *
 */

function _exportStringFromContainer( o )
{
  var result = '';

  _.assert( arguments.length > 0 );
  _.assert( _.object.isBasic( o ) || o === undefined, 'Expects map {-o-}' );
  _.assert( _.arrayIs( o.names ) || !o.names );

  var values = o.values;
  var names = o.names;
  var optionsContainer = o.optionsContainer;
  var optionsItem = o.optionsItem;

  var length = ( names ? names.length : values.length );
  var simple = o.simple;
  var prefix = o.prefix;
  var postfix = o.postfix;
  var limit = optionsContainer.limitElementsNumber;
  var l = length;

  if( o.keyWrapper === undefined )
  o.keyWrapper = '';

  if( limit > 0 && limit < l )
  {
    l = limit;
    optionsContainer.limitElementsNumber = 0;
  }

  /* line postfix */

  var linePostfix = '';
  if( optionsContainer.comma )
  linePostfix += optionsContainer.comma;

  if( !simple )
  {
    linePostfix += '\n' + optionsItem.tab;
  }

  /* prepend */

  if( optionsContainer.prependTab  )
  {
    result += optionsContainer.tab;
  }

  /* wrap */

  if( optionsContainer.wrap )
  {
    result += prefix;
    if( simple )
    {
      if( l )
      result += ' ';
    }
    else
    {
      result += '\n' + optionsItem.tab;
    }
  }
  else if( !simple )
  {
    /*result += '\n' + optionsItem.tab;*/
  }

  /* keyWrapper */

  if( optionsContainer.json )
  {
    optionsContainer.keyWrapper = '"';
  }

  /* exec */

  var r;
  var written = 0;
  for( var n = 0 ; n < l ; n++ )
  {

    _.assert( optionsItem.tab === optionsContainer.tab + optionsContainer.dtab );
    _.assert( optionsItem.level === optionsContainer.level + 1 );

    if( names )
    r = _.entity._exportString( values[ names[ n ] ], optionsItem );
    else
    r = _.entity._exportString( values[ n ], optionsItem );

    _.assert( _.object.isBasic( r ) && _.strIs( r.text ) );
    _.assert( optionsItem.tab === optionsContainer.tab + optionsContainer.dtab );

    if( written > 0 )
    {
      result += linePostfix;
    }
    else if( !optionsContainer.wrap )
    if( !names || !simple )
    //if( !simple )
    {
      result += optionsItem.dtab;
    }

    if( names )
    {
      if( o.keyWrapper === undefined )
      debugger;
      let name = _.strEscape({ src : names[ n ], stringWrapper : o.keyWrapper });
      if( optionsContainer.keyWrapper )
      result += optionsContainer.keyWrapper + name + optionsContainer.keyWrapper + optionsContainer.colon;
      else
      result += name + optionsContainer.colon;

      if( !r.simple )
      result += '\n' + optionsItem.tab;
    }

    if( r.text )
    {
      result += r.text;
      written += 1;
    }

  }

  /* other */

  // if( names && l < names.length )
  // result += other( names.length );
  // else if( l < names.length )
  // result += other( names.length );

  /* wrap */

  if( length - l > 0 )
  result += other( length );

  if( optionsContainer.wrap )
  {
    if( simple )
    {
      if( l )
      result += ' ';
    }
    else
    {
      result += '\n' + optionsContainer.tab;
    }
    result += postfix;
  }

  return result;

  function other( length )
  {
    return linePostfix + '[ ... other '+ ( length - l ) +' element(s) ]';
  }

}

//

function _exportStringFromObjectKeysFiltered( src, o )
{
  var result = '';

  _.assert( arguments.length === 2 );

  /* item options */

  var optionsItem = _.props.extend( null, o );
  optionsItem.noObject = o.noSubObject ? 1 : optionsItem.noObject;

  /* get keys */

  var keys = _.props._keys
  ({
    srcMap : src,
    onlyOwn : o.onlyOwn,
    onlyEnumerable : o.onlyEnumerable || o.onlyEnumerable === undefined || o.onlyEnumerable === null || false,
  });

  /* filter */

  for( var n = 0 ; n < keys.length ; n++ )
  {
    if( !_.entity._exportStringIsVisibleElement( src[ keys[ n ] ], optionsItem ) )
    {
      keys.splice( n, 1 );
      n -= 1;
    }
  }

  return keys;
}

//

/**
 * Converts object provided by argument( src ) into string representation using options provided by argument( o ).
 *
 * @param {object} src - Object to convert.
 * @param {Object} o - Contains conversion options {@link module:Tools/base/Stringer.Tools.Stringer.exportStringOptions}.
 * @returns {String} Returns string representation of object.
 *
 * @example
 * //returns
 * // {
 * //  r : 9,
 * //  t : { a : 10 },
 * //  y : 11
 * // }
 * _.entity.exportStringFromObject( { r : 9, t : { a : 10 }, y : 11 }, { levels : 2 } );
 *
 * @example
 * //returns ''
 * _.entity.exportStringFromObject( { h : { d : 1 }, g : 'c', c : [2] }, { levels : 2, noObject : 1 } );
 *
 * @function _exportStringFromObject
 * @throws { Exception } If( src ) is not a object-like.
 * @throws { Exception } If not all arguments provided.
 * @throws { Exception } If( o ) is not a Object.
 * @namespace Tools
 * @module Tools/base/Stringer
 *
*/

function _exportStringFromObject( src, o )
{
  var result = '';

  _.assert( arguments.length === 2 );
  _.assert( _.objectLike( src ) || _.entity.strTypeSecondary( src ) === 'Error' );
  _.assert( _.object.isBasic( o ) || o === undefined, 'Expects map {-o-}' );


  if( o.level >= o.levels )
  {
    return { text : _.entity._exportStringShortAct( src, o ), simple : 1 };
  }

  if( o.noObject )
  return;

  /* item options */

  var optionsItem = _.props.extend( null, o );
  optionsItem.noObject = o.noSubObject ? 1 : optionsItem.noObject;
  optionsItem.tab = o.tab + o.dtab;
  optionsItem.level = o.level + 1;
  optionsItem.prependTab = 0;

  /* get names */

  var keys = _.entity._exportStringFromObjectKeysFiltered( src, o );

  /* empty case */

  var length = keys.length;
  if( length === 0 )
  {
    if( !o.wrap )
    return { text : '', simple : 1 };
    return { text : '{}', simple : 1 };
  }

  /* is simple */

  var simple = !optionsItem.multiline;
  if( simple )
  simple = length < 4;
  if( simple )
  for( var k in src )
  {
    simple = _.entity._exportStringIsSimpleElement( src[ k ], optionsItem );
    if( !simple )
    break;
  }

  /* */

  result += _.entity._exportStringFromContainer
  ({
    values : src,
    names : keys,
    optionsContainer : o,
    optionsItem,
    simple,
    prefix : '{',
    postfix : '}',
    keyWrapper : o.keyWrapper,
    stringWrapper : o.stringWrapper,
  });

  return { text : result, simple };
}

// --
// declare
// --

let EntityExtension =
{

  exportString,
  exportStringFine,
  exportStringMethods,
  exportStringFields,
  // exportStringDiagnosticShallow,
  exportStringNice,
  exportStringSolo,
  exportJson,
  exportJs,

  _exportStringFine_functor,

  _exportString,
  _exportStringShortAct,

  _exportStringIsVisibleElement,
  _exportStringIsSimpleElement,

  _exportStringFromRoutine,
  _exportStringFromNumber,
  _exportStringFromBigInt,
  _exportStringFromSymbol,
  _exportStringFromStr,

  _exportStringFromHashMap,
  _exportStringFromSet,

  _exportStringFromBufferRaw,
  _exportStringFromBufferNode,
  _exportStringFromBufferTyped,

  _exportStringFromArrayFiltered,
  _exportStringFromArray,

  _exportStringFromContainer,

  _exportStringFromObjectKeysFiltered,
  _exportStringFromObject,

  Stringer : 1,
}

/* _.props.extend */Object.assign( _.entity, EntityExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

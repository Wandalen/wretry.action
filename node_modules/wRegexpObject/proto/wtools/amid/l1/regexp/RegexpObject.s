( function _RegexpObject_s_()
{

'use strict';

/**
 * Class which encapsulates a trivial logical combination( expression ) and regular expressions which may be applied to a string to tell does that string satisfies regular expressions as well as the logic. RegexpObject provides functionality to compose, combine several instances of the class, extend it, apply to a string and other. Use it to treat multiple conditions as a single object. Refactoring required.
  @module Tools/mid/RegexpObject
 */

/**
 *  */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  _.include( 'wCopyable' );
}

//

/**
 * @classdesc Class which encapsulates a trivial logical combination( expression ) and regular expressions
 * which may be applied to a string to tell does that string satisfies regular expressions as well as the logic.
 * @class wRegexpObject
 * @module Tools/mid/RegexpObject
 */

/**
 * The complete RegexpObject object.
 * @typedef {Object} wRegexpObject
 * @property {RegExp[]} includeAny - Array of RegExps, to check matching any of them;
 * @property {RegExp[]} includeAll - Array of RegExps, to check matching all of them;
 * @property {RegExp[]} excludeAny - Array of RegExps, to check mismatch any of them;
 * @property {RegExp[]} excludeAll - Array of RegExps, to check mismatch all of them;
 * @module Tools/mid/RegexpObject
 */

const _ = _global_.wTools;
const Parent = null;
const Self = wRegexpObject;
function wRegexpObject( src, defaultMode )
{
  if( !( this instanceof Self ) )
  if( src instanceof Self )
  return src;
  else
  return new( _.constructorJoin( Self, arguments ) );
  return Self.prototype.init.apply( this, arguments );
  // return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'RegexpObject';

//

/**
* @summary Make RegexpObject from different type sources.
* @description
* All strings in sources will be turned into RegExps.
* * If passed RegexpObject or map with properties similar to RegexpObject but with string in values, then the second
* parameter is not required;
* * If passed single RegExp/String or array of RegExps/Strings, then method will return RegexpObject with
* `defaultMode` as key, and array of RegExps created from first parameter as value.
* * If passed array of RegexpObject, mixed with ordinary RegExps/Strings, the result object will be created by merging
* with anding (see [and]{@link wTools#and}) RegexpObjects and RegExps that associates
* with `defaultMode` key.
*
* @example
 let src = [
     /hello/,
     'world',
     {
       includeAny : [ 'yellow', 'blue', 'red' ],
       includeAll : [ /red/, /green/, /brown/ ],
       excludeAny : [ /yellow/, /white/, /grey/ ],
       excludeAll : [ /red/, /green/, /blue/ ]
     }
 ];
 _.wRegexpObject( src, 'excludeAll' );

 // {
 //    includeAny: [ /yellow/, /blue/, /red/ ],
 //    includeAll: [ /red/, /green/, /brown/ ],
 //    excludeAny: [ /yellow/, /white/, /grey/ ],
 //    excludeAll: [ /hello/, /world/ ]
 // }
* @param {RegexpObject|String|RegExp|RegexpObject[]|String[]|RegExp[]} src Source for making RegexpObject
* @param {String} [defaultMode] Key for result RegexpObject map. Can be one of next strings: 'includeAny',
'includeAll', 'excludeAny' or 'excludeAll'.
* @returns {RegexpObject} Result RegexpObject
* @throws {Error} Missing arguments if call without argument
* @throws {Error} Missing arguments if passed array without `defaultMode`
* @throws {Error} Unknown mode `defaultMode`
* @throws {Error} Unknown src if first argument is not array, map, string or regexp.
* @throws {Error} Unexpected if type of array element is not string regexp or RegexpObject.
* @throws {Error} Unknown regexp filters if passed map has unexpected properties (see RegexpObject).
* @routine init
* @class wRegexpObject
* @namespace wTools
* @module Tools/mid/RegexpObject
*/

function init( src, defaultMode )
{
  let self = this;

  _.workpiece.initFields( self );

  if( self.Self === Self )
  Object.preventExtensions( self );

  /**/

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.object.isBasic( src ) || _.arrayIs( src ) || _.regexpIs( src ) || _.strIs( src ) || src === null, () => 'Unknown type of arguments ' + _.entity.strType( src ) );

  /**/

  if( _.regexpIs( src ) )
  src = [ src ];

  if( _.strIs( src ) )
  src = [ new RegExp( _.regexpEscape( src ) ) ];

  if( src === null )
  src = [];

  /**/

  if( _.arrayIs( src ) )
  {

    src = _.arrayFlatten( [], src );

    let ar = [];
    for( let s = 0 ; s < src.length ; s += 1 )
    {
      if( _.regexpIs( src[ s ] ) || _.strIs( src[ s ] ) )
      ar.push( _.regexpFrom( src[ s ] ) );
      else if( _.object.isBasic( src[ s ] ) )
        self = Self.Or( self, Self( src[ s ] ) );
      else _.assert( 0, 'Unexpected' );
    }

    if( ar.length )
    {

      defaultMode = defaultMode || 'includeAny';
      _.assert( arguments.length <= 2, 'Expects second argument as default mode, for example "includeAny"' );
      _.assert( !!self.Names[ defaultMode ], 'Unknown mode :', defaultMode );

      if( self[ defaultMode ] && self[ defaultMode ].length )
      {
        let r = {};
        r[ defaultMode ] = ar;
        //Self.And( self, r );
        Self.Or( self, r );
      }
      else
      {
        self[ defaultMode ] = ar;
      }
    }

  }
  else if( _.object.isBasic( src ) )
  {

    for( let k in src )
    {
      if( !Reflect.hasOwnProperty.call( src, k ) )
      continue;
      let e = src[ k ];
      self[ k ] = _.regexpArrayMake( e );
    }

    // _.eachOwn( src, function onEach( e, k )
    // {
    //   if( e === null )
    //   {
    //     debugger;
    //     throw _.err( 'not tested' );
    //     delete self[ k ];
    //     return;
    //   }
    //   self[ k ] = _.regexpArrayMake( e );
    // });

  }
  else _.assert( 0, 'wRegexpObject :', 'unknown src', src );

  _.map.assertOwnOnly( self, self.Names, 'Unknown regexp fields' );

  if( Config.debug )
  self.validate();

  return self;
}

//

function validate()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  for( let f in Composes )
  {
    _.assert( _.arrayIs( self[ f ] ) );
    for( let i = 0 ; i < self[ f ].length ; i++ )
    {
      _.assert( _.regexpIs( self[ f ][ i ] ), 'Regexp object expects regexps, but got', _.entity.strType( self[ f ][ i ] ) );
    }
  }

}

//

/**
 * Test the `ins` string by condition specified in `src`. If all condition are met, return true
 * _test( options, str ); // true
 * @param {Object} src Object with options for test
 * @param {Regexp[]} [src.excludeAll] Array with regexps for testing. If all of the regexps match at `ins` method
 * return the "excludeAll" string, otherwise checks next property in the `src` object
 * @param {Regexp[]} [src.excludeAny] Array with regexps for testing. If any of them match `ins` string` method return
 * it source string, otherwise checks next property in the `src` object
 * @param {Regexp[]} [src.includeAll] Array with regexps for testing. If all of them match `ins` string method check
 * next property in `src` object, otherwise return source of regexp that don't match.
 * @param {Regexp[]} [src.includeAny] Array with regexps for testing. If no one regexp don't match method return
 * "inlcude none from includeAny" string. Else method return true;
 * @param {String} ins String for testing
 * @returns {String|boolean} If all reason match, return true, otherwise return string with fail reason
 * @throws {Error} Throw an 'Expects string' error if `ins` is not string
 * @throws {Error} Throw an 'Expects object' error if `src` is not object
 * @method _test
 * @class wRegexpObject
 * @namespace wTools
 * @module Tools/mid/RegexpObject
*/

//function _test( src, ins )
function _test( ins )
{
  let src = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !_.strIs( ins ) )
  throw _.err( 'test :', 'Expects string as second argument', ins );

  if( src.excludeAll )
  {
    let r = _.regexpArrayAll( src.excludeAll, ins, false );
    if( r === true )
    return 'excludeAll';
  }

  if( src.excludeAny )
  {
    let r = _.regexpArrayAny( src.excludeAny, ins, false );
    if( r !== false )
    return src.excludeAny[ r ].source;
  }

  if( src.includeAll )
  {
    let r = _.regexpArrayAll( src.includeAll, ins, true );
    if( r !== true )
    return src.includeAll[ r ].source;
  }

  if( src.includeAny )
  {
    let r = _.regexpArrayAny( src.includeAny, ins, true );
    if( r === false )
    return 'include none from includeAny';
  }

  return true;
}

//

/**
 * Function for testing `ins` string for different regexps combination. If all condition passed in `src` object are
 * met method return true
 *
 * @example
 * let str = "The RGB color model is an additive color model in which red, green,
 *   and blue light are added together in various ways to reproduce a broad array of colors";
 *     regArr1 = [/red/, /green/, /blue/],
 *     regArr2 = [/yellow/, /blue/, /red/],
 *     regArr3 = [/yellow/, /white/, /greey/],
 *     options = {
 *        includeAny : regArr2,
 *        includeAll : regArr1,
 *        excludeAny : regArr3,
 *        excludeAll : regArr2
 *     };
 *
 * wTools.test( options, str ); // true
 * @param {Object} src Map object in wich keys are strings each of them mean different condition for test, and values
 * are the arrays of regexps;
 * @param {Regexp[]} [src.excludeAll] Array with regexps for testing. If all of the regexps match at `ins` method
 * return false
 * @param {Regexp[]} [src.excludeAny] Array with regexps for testing. If any of them match `ins` string` method return
 * false
 * @param {Regexp[]} [src.includeAll] Array with regexps for testing. If any of them don't match `ins` string method
 * return false
 * @param {Regexp[]} [src.includeAny] Array with regexps for testing. If no one of regexps don't match `ins` string
 * method return false
 * @param ins String for testing
 * @returns {boolean} If all test passed return true;
 * @throws {Error} Throw an 'Expects string' error if `ins` is not string
 * @throws {Error} Throw an 'Expects object' error if `src` is not object
 * @method test
 * @class wRegexpObject
 * @namespace wTools
 * @module Tools/mid/RegexpObject
*/

function test( ins )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = self._test( ins );

  if( _.strIs( result ) )
  return false;

  if( result === true )
  return true;

  throw _.err( 'unexpected' );
}

//

/**
 * @summary Function for testing `ins` string for different regexps combination. If all condition passed in `src` object are
 * met method return true
 *
 * @example
 * let str = "The RGB color model is an additive color model in which red, green,
 *  and blue light are added together in various ways to reproduce a broad array of colors";
 *     regArr1 = [/red/, /green/, /blue/],
 *     regArr2 = [/yellow/, /blue/, /red/],
 *     regArr3 = [/yellow/, /white/, /greey/],
 *     options = {
 *        includeAny : regArr2,
 *        includeAll : regArr1,
 *        excludeAny : regArr3,
 *        excludeAll : regArr2
 *     };
 *
 * wTools.test( options, str ); // true
 * @param {Object} src Map object in wich keys are strings each of them mean different condition for test, and values
 * are the arrays of regexps;
 * @param {Regexp[]} [src.excludeAll] Array with regexps for testing. If all of the regexps match at `ins` method
 * return false
 * @param {Regexp[]} [src.excludeAny] Array with regexps for testing. If any of them match `ins` string` method return
 * false
 * @param {Regexp[]} [src.includeAll] Array with regexps for testing. If any of them don't match `ins` string method
 * return false
 * @param {Regexp[]} [src.includeAny] Array with regexps for testing. If no one of regexps don't match `ins` string
 * method return false
 * @param ins String for testing
 * @returns {boolean} If all test passed return true;
 * @throws {Error} Throw an 'Expects string' error if `ins` is not string
 * @throws {Error} Throw an 'Expects object' error if `src` is not object
 * @function test
 * @module Tools/mid/RegexpObject.wRegexpObject.
*/

function Test( self, ins )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  self = Self( self, 'includeAll' );
  return self.test( ins );
}

//

/**
 * @summary Merge several RegexpObjects extending one by others.
 * @description Order of extending make difference because joining of some parameters without lose is not possible.
 * o.anding gives a hint in what direction the lost should be made.
 * @param {object} o - options of merging.
 * @param {RegexpObject} options.dst RegexpObject to merge in.
 * @param {RegexpObject} options.srcs RegexpObjects to merge from.
 * @param {Boolean} options.anding Shrinking or broadening mode.
  Joining of some parameters without lose is not possible.
  This parameter gives a hint in what direction the lost should be made.
 * @returns {RegexpObject} Returns merged RegexpObject.
 * @throws {Error} If in options missed any of 'dst', 'srcs' or 'anding' properties
 * @throws {Error} If options.dst is not object
 * @throws {Error} If options.srcs is not longIs object
 * @throws {Error} If options.srcs element is not RegexpObject object
 * @method _Extend
 * @class wRegexpObject
 * @namespace wTools
 * @module Tools/mid/RegexpObject
 */

function _Extend( o )
{

  if( o.dst === null )
  o.dst = new Self( [] );

  _.routine.options_( _Extend, o );
  _.assert( _.object.isBasic( o.dst ) );
  _.assert( _.longIs( o.srcs ) );
  _.assert( _.longHas( [ 'extend', 'or', 'and' ], o.mode ) );

  o.srcs = _.arrayFlatten( [], o.srcs );

  let result = o.dst;
  for( let n in Names )
  if( !result[ n ] )
  result[ n ] = [];
  result = Self( result );

  for( let s = 0 ; s < o.srcs.length ; s++ )
  {
    let src = o.srcs[ s ];

    if( src === null )
    {
      continue;
    }
    else if( !_.object.isBasic( src ) )
    {
      // src = Self( src, o.anding ? 'includeAll' : 'includeAny' );
      src = Self( src, o.mode === 'and' ? 'includeAll' : 'includeAny' );
    }

    _.map.assertOwnOnly( src, Names );

    // let toExtend = o.anding ? RegexpModeNamesToExtendMap : Names;
    let toExtend = o.mode === 'and' ? RegexpModeNamesToExtendMap : Names;

    for( let n in toExtend )
    if( src[ n ] )
    if( ( _.arrayIs( src[ n ] ) && src[ n ].length ) || !_.arrayIs( src[ n ] ) )
    {
      result[ n ] = _.arrayFlattenOnce( result[ n ], [ src[ n ] ], _.regexpIdentical );
    }

    if( o.mode === 'and' )
    for( let n in RegexpModeNamesToReplaceMap )
    if( src[ n ] )
    if( ( _.arrayIs( src[ n ] ) && src[ n ].length ) || !_.arrayIs( src[ n ] ) )
    {
      if( _.regexpIs( src[ n ] ) )
      result[ n ] = [ src[ n ] ];
      else
      result[ n ] = src[ n ];
    }

  }

  /* normalize */

  for( let r in result )
  for( let i = 0; i < result[ r ].length ; i++ )
  {
    let element = result[ r ][ i ];
    if( _.strIs( element ) )
    result[ r ][ i ] = new RegExp( _.regexpEscape( element ) );
  }

  /* */

  _.assert( result instanceof Self );
  if( Config.debug )
  result.validate();

  return result;
}

_Extend.defaults =
{
  dst : null,
  srcs : null,
  // anding : true,
  mode : 'extend',
}

//

function Extension( dst )
{

  let result = this._Extend
  ( {
    dst : null,
    srcs : _.longSlice( arguments, 0 ),
    mode : 'extend',
    // anding : 1,
  } );

  return result;
}

//

/**
 * @summary Extends `result` of RegexpObjects by merging other RegexpObjects.
 * @description
 * The properties such as includeAll, excludeAny are complemented from appropriate properties in source  objects
 *  by merging all of them;
 * Properties includeAny and excludeAll are always replaced by appropriate properties from sources without merging,
 *
 * @example
 * let dest = {
 *     includeAny : [/yellow/, /blue/],
 *     includeAll : [/red/],
 *     excludeAny : [/yellow/],
 *     excludeAll : [/red/]
 * },
 *
 * src1 = {
 *     includeAll : [/green/],
 *     excludeAny : [/white/],
 *     excludeAll : [/green/, /blue/]
 * },
 * src2 = {
 *     includeAny : [/red/],
 *     includeAll : [/brown/],
 *     excludeAny : [/greey/],
 * }
 *
 * RegexpObject.And( dest, src1, src2 );
 *
 * //{
 * //    includeAny : [/red/],
 * //    includeAll : [/red/, /green/, /brown/],
 * //    excludeAny : [/yellow/, /white/, /greey/],
 * //    excludeAll : [/green/, /blue/]
 * //};
 * @param {RegexpObject} result RegexpObject to merge in.
 * @param {...RegexpObject} [src] RegexpObjects to merge from.
 * @returns {RegexpObject} Reference to `result` parameter;
 * @throws {Error} If missed arguments
 * @throws {Error} If arguments are not RegexpObject
 * @function And
 * @module Tools/mid/RegexpObject.wRegexpObject.
*/

function And( dst )
{

  let result = this._Extend
  ( {
    dst : null,
    srcs : _.longSlice( arguments, 0 ),
    // anding : 1,
    mode : 'and',
  } );

  return result;
}

//

/**
 * @summary Extends `result` of RegexpObjects by merging other RegexpObjects.
 * @description Appropriate properties such as includeAny, includeAll, excludeAny and excludeAll are complemented from appropriate
 * properties in source objects by merging;
 *
 * @example
 * let dest = {
 *     includeAny : [/yellow/, /blue/],
 *     includeAll : [/red/],
 *     excludeAny : [/yellow/],
 *     excludeAll : [/red/]
 * },
 *
 * src1 = {
 *     includeAll : [/green/],
 *     excludeAny : [/white/],
 *     excludeAll : [/green/, /blue/]
 * },
 * src2 = {
 *     includeAny : [/red/],
 *     includeAll : [/brown/],
 *     excludeAny : [/greey/],
 * }
 *
 * wTools.Or( dest, src1, src2 );
 *
 * //{
 * //    includeAny : [/yellow/, /blue/, /red/],
 * //    includeAll : [/red/, /green/, /brown/],
 * //    excludeAny : [/yellow/, /white/, /greey/],
 * //    excludeAll : [/red/, /green/, /blue/]
 * //};
 * @param {RegexpObject} result RegexpObject to merge in.
 * @param {...RegexpObject} [src] RegexpObjects to merge from.
 * @returns {RegexpObject} Reference to `result` parameter;
 * @throws {Error} If missed arguments
 * @throws {Error} If arguments are not RegexpObject
 * @function Or
 * @module Tools/mid/RegexpObject.wRegexpObject.
 */

function Or( dst )
{

  let result = this._Extend
  ( {
    dst : null,
    srcs : _.longSlice( arguments, 0 ),
    // anding : 0,
    mode : 'or',
  } );

  return result;
}

//

function extend()
{
  let self = this;

  self._Extend
  ( {
    dst : self,
    srcs : arguments,
    // anding : 1,
    mode : 'extend',
  } );

  return self;
}

//

function and()
{
  let self = this;

  self._Extend
  ( {
    dst : self,
    srcs : arguments,
    // anding : 1,
    mode : 'and',
  } );

  return self;
}

//

function or()
{
  let self = this;

  self._Extend
  ( {
    dst : self,
    srcs : arguments,
    mode : 'or'
    // anding : 0,
  } );

  // debugger;
  // throw _.err( 'not tested' );

  return self;
}

//

/**
 * @description
 * Create RegexpObject, that represents the subtraction for match`s/mismatched with the input RegexpObject object
 * e.g. if { includeAll: [ /red/, /green/, /blue/ ] } represents subset of all strings that contains each 'red', 'green'
 * and 'blue' words, then result of but() - { excludeAll: [ /red/, /green/, /blue/ ]} will represent the
 * subset of all strings that does not contains at least one of those worlds.
 *
 * @example
 * let options =
 * {
 *       includeAny : [/yellow/, /blue/, /red/],
 *       includeAll : [/red/, /green/, /blue/],
 *       excludeAny : [/yellow/, /white/, /grey/],
 *       excludeAll : [/black/, /brown/, /pink/]
 * };
 *
 * _.RegexpObject.But( options );
 *
 * // {
 * //   "includeAny":[/yellow/, /white/, /grey/],
 * //   "excludeAny":[/yellow/, /blue/, /red/],
 * //   "excludeAll":[/red/, /green/, /blue/],
 * //   "includeAll":[/black/, /brown/, /pink/]
 * // }
 *
 * @param {...RegexpObject|...String|...RegExp} [src] Input RegexpObject map/maps. If passed primitive values, they will
 * be interpreted as value for `includeAny` property of RegexpObject. If objects more than one, their includeAny and
 * excludeAny properties will be merged. Notice: if objects more than one and every has includeAll/excludeAll arrays
 * with more than one elements, method will throw error.
 * @returns {RegexpObject} Result RegexpObject map.
 * @throws {Error} If objects more than one and every has includeAll/excludeAll arrays with more than one elements
 * throws 'cant combineMethodUniform such regexp objects with "but" combiner'
 * @method But
 * @class wRegexpObject
 * @namespace wTools
 * @module Tools/mid/RegexpObject
 */

function But()
{
  let result = Self( [], Self.Names.includeAny );

  for( let a = 0, al = arguments.length ; a < al ; a++ )
  {
    let argument = arguments[ a ];
    let src = Self( argument, Self.Names.includeAny );

    if( src.includeAny ) result.excludeAny = _.arrayAppendArray( result.excludeAny || [], src.includeAny );
    if( src.excludeAny ) result.includeAny = _.arrayAppendArray( result.includeAny || [], src.excludeAny );

    if( src.includeAll && src.includeAll.length )
    {
      if( src.includeAll.length === 1 )
      {
        result.excludeAny = _.arrayAppendArray( result.excludeAny || [], src.includeAll );
      }
      else if( !result.excludeAll || result.excludeAll.length === 0 )
      {
        result.excludeAll = _.arrayAppendArray( result.excludeAll || [], src.includeAll );
      }
      else throw _.err( 'Cant combineMethodUniform such regexp objects with "but" combiner' );
    }

    if( src.excludeAll && src.excludeAll.length )
    {
      if( src.excludeAll.length === 1 )
      {
        result.includeAny = _.arrayAppendArray( result.includeAny || [], src.excludeAll );
      }
      else if( !result.includeAll || result.includeAll.length === 0 )
      {
        result.includeAll = _.arrayAppendArray( result.includeAll || [], src.excludeAll );
      }
      else throw _.err( 'Cant combineMethodUniform such regexp objects with "but" combiner' );
    }

  }

  return result;
}

//

/**
 * @description
 * Creates array of RegexpObjects, that will be associated with some ordered set of subsets of strings.
 * Accepts array of strings. They will be used as base for RegexpObjects. The empty string in array will be
 * converted into RegexpObject that associates with subset what is the subtraction of all possible subsets of strings
 * and union of subsets which match other words in array.
 * If several arrays are passed in the method, the result will be cartesian product of appropriates arrays described
 * above.
 * @example
 *
 * let arr1 = ['red', 'blue'],
 * arr2 = ['', 'green'];
 *
 * wTools.Order(arr1, arr2);
 * // [
 * //     {
 * //         includeAny:[],
 * //         includeAll:[/red/],
 * //         excludeAny:[/green/],
 * //         excludeAll:[]},
 * //
 * //     {
 * //         includeAny:[],
 * //         includeAll:[/red/, /green/],
 * //         excludeAny:[],
 * //         excludeAll:[]},
 * //
 * //     {
 * //         includeAny:[],
 * //         includeAll:[/blue/],
 * //         excludeAny:[/green/],
 * //         excludeAll:[]},
 * //
 * //     {
 * //         includeAny:[],
 * //         includeAll:[/blue/, /green/],
 * //         excludeAny:[],
 * //         excludeAll:[]
 * //     }
 * // ]
 * @param {...String[]} ordering аrray/аrrays of strings
 * @returns {RegexpObject[]} аrray of RegexpObject that represent resulting ordering
 * @throws {Error} Unexpected type, if passed arguments is not arrays.
 * @method Order
 * @class wRegexpObject
 * @namespace wTools
 * @module Tools/mid/RegexpObject
 */

function Order( ordering )
{
  let res = [];

  if( arguments.length === 1 && arguments[ 0 ].length === 0 )
  return res;

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    let argument = arguments[ a ];
    if( _.arrayIs( argument[ 0 ] ) )
    for( let i = 0 ; i < argument.length ; i++ )
      res.push( _OrderingExclusion( argument[ i ] ) );
    else if( _.strIs( argument[ 0 ] ) )
      res.push( _OrderingExclusion( argument ) );
    else throw _.err( 'unexpected' );
  }

  if( res.length === 1 )
  return res[ 0 ];

  let result = [];
  _.permutation.eachSample
  ({
    leftToRight : 0,
    sets : res,
    onEach : function( sample, index )
    {
      let mask = Self.And( {}, sample[ 0 ] );
      for( let s = 1 ; s < sample.length ; s++ )
      Self.And( mask, sample[ s ] );
      result.push( mask );
    }
  });

  return result;
}

//

/**
 * @description
 * Wrap strings passed in `ordering` array into RegexpObjects.
 * Any non empty string in input array turns into RegExp which is wraped into array and assign to includeAll,
 * property of appropriate object. An empty string in array are replaced by merged subtractions for all created
 * RegexpObjects objects.
 *
 * @param {String[]} ordering - array of strings.
 * @returns {RegexpObject[]} Returns array of RegexpObject
 * @private
 * @throws {Error} If no arguments, or arguments more than 1.
 * @method _OrderingExclusion
 * @class wRegexpObject
 * @namespace wTools
 * @module Tools/mid/RegexpObject
 */

function _OrderingExclusion( ordering )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !ordering || _.arrayIs( ordering ) );

  if( !ordering )
  return [];

  if( !ordering.length )
  return ordering;

  let result = [];

  for( let o = 0 ; o < ordering.length ; o++ )
  {
    _.assert( _.strIs( ordering[ o ] ) );
    if( ordering[ o ] === '' )
    continue;
    result.push( Self( ordering[ o ], Names.includeAll ) );
  }

  let nomask = {};
  for( let r = 0 ; r < result.length ; r++ )
  {
    Self.And( nomask, Self.But( result[ r ] ) );
  }

  for( let o = 0 ; o < ordering.length ; o++ )
  {
    if( ordering[ o ] === '' )
    result.splice( o, 0, nomask );
  }

  return result;
}

//

function isEmpty()
{
  let self = this;

  if( self.includeAny.length > 0 )
  return false;
  if( self.includeAll.length > 0 )
  return false;
  if( self.excludeAny.length > 0 )
  return false;
  if( self.excludeAll.length > 0 )
  return false;

  return true;
}

//

function compactField( it )
{
  let self = this;

  if( it.dst === null )
  return;

  if( _.arrayIs( it.dst ) && !it.dst.length )
  return;

  return it.dst;
}

//

function _equalAre( it )
{
  let self = this;

  _.assert( arguments.length === 1 );

  it.continue = false;

  if( !it.src )
  return end( false );
  if( !it.src2 )
  return end( false );

  if( it.strictTyping )
  if( !( it.src instanceof Self ) )
  return end( false );
  if( it.strictTyping )
  if( !( it.src2 instanceof Self ) )
  return end( false );

  if( it.containing )
  {

    for( let n in self.Names )
    {
      if( !it.src[ n ] || !it.src[ n ].length )
      if( !it.src2[ n ] || !it.src2[ n ].length )
      continue;
      // if( !it.equal( it.src[ n ], it.src2[ n ] ) )
      if( !it.reperform( it.src[ n ], it.src2[ n ] ) )
      return end( false );
    }

  }
  else
  {
    for( let n in self.Names )
    if( !it.reperform( it.src[ n ], it.src2[ n ] ) )
    // if( !_.entity.identicalShallow( it.src[ n ], it.src2[ n ] ) )
    return end( false );
  }

  return end( true );

  function end( result )
  {
    it.result = result;
  }
}

// --
// class let
// --

// let Names = _.namesCoded
let Names =
{
  includeAny : 'includeAny',
  includeAll : 'includeAll',
  excludeAny : 'excludeAny',
  excludeAll : 'excludeAll',
}

// let RegexpModeNamesToExtendMap = _.namesCoded
let RegexpModeNamesToExtendMap =
{
  includeAll : 'includeAll',
  excludeAny : 'excludeAny',
}

// let RegexpModeNamesToReplaceMap = _.namesCoded
let RegexpModeNamesToReplaceMap =
{
  includeAny : 'includeAny',
  excludeAll : 'excludeAll',
}

// --
// relations
// --

let Composes =
{
  includeAny : _.define.own( [] ),
  includeAll : _.define.own( [] ),
  excludeAny : _.define.own( [] ),
  excludeAll : _.define.own( [] ),
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{

  Test,

  _Extend,
  Extension,
  And,
  Or,

  But,

  Order,
  _OrderingExclusion,

  Names,
  RegexpModeNamesToExtendMap,
  RegexpModeNamesToReplaceMap,

}

// --
// declare
// --

let ExtendRoutines =
{

  init,
  validate,

  _test,
  test,

  _Extend,
  Extension,
  And,
  Or,

  extend,
  and,
  or,

  Order,
  _OrderingExclusion,

  isEmpty,
  compactField,

  _equalAre,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,

}

//

let SupplementRoutines =
{
  Statics,
}

//

_.classDeclare
( {
  cls : Self,
  parent : Parent,
  extend : ExtendRoutines,
  supplement : SupplementRoutines,
} );

_.Copyable.mixin( Self );

Self.prototype[ Symbol.for( 'equalAre' ) ] = _equalAre;

// --
// export
// --

_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();

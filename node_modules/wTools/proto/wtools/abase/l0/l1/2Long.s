( function _l1_Long_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

_.assert( _.long === undefined );
_.assert( _.withLong === undefined );
_.long = _.long || Object.create( null );
_.long.namespaces = _.long.namespaces || Object.create( null );
_.long.toolsNamespacesByType = _.long.toolsNamespacesByType || Object.create( null );
_.long.toolsNamespacesByName = _.long.toolsNamespacesByName || Object.create( null );
_.long.toolsNamespaces = _.long.toolsNamespacesByName;
_.withLong = _.long.toolsNamespacesByType;

// --
// dichotomy
// --

/**
 * The routine longIs() determines whether the passed value is an array-like or an Array.
 * Imortant : longIs returns false for Object, even if the object has length field.
 *
 * If {-srcMap-} is an array-like or an Array, true is returned,
 * otherwise false is.
 *
 * @param { * } src - The object to be checked.
 *
 * @example
 * _.longIs( [ 1, 2 ] );
 * // returns true
 *
 * @example
 * _.longIs( 10 );
 * // returns false
 *
 * @example
 * let isArr = ( function() {
 *   return _.longIs( arguments );
 * } )( 'Hello there!' );
 * // returns true
 *
 * @returns { boolean } Returns true if {-srcMap-} is an array-like or an Array.
 * @function longIs.
 * @namespace Tools
 */

// function is( src )
// {
//   if( Array.isArray( src ) )
//   return true
//   if( _.bufferTyped.is( src ) )
//   return true;
//   if( Object.prototype.toString.call( src ) === '[object Arguments]' )
//   return true;
//
//   return false;
// }

function is_functor()
{
  let result;
  const TypedArray = Object.getPrototypeOf( Int8Array );
  //const iteratorSymbol = Symbol.iterator;

  if( _global_.BufferNode )
  result = isNjs;
  else
  result = isBrowser;
  result.functor = is_functor;
  return result;

  function isNjs( src )
  {
    if( Array.isArray( src ) )
    return true

    if( src instanceof TypedArray )
    {
      if( src instanceof BufferNode )
      return false;
      return true;
    }
    isNjs.functor = is_functor;

    // if( arguments[ iteratorSymbol ] === undefined )
    // return false;
    if( Object.prototype.toString.call( src ) === '[object Arguments]' )
    return true;

    return false;
  }

  function isBrowser( src )
  {
    if( Array.isArray( src ) )
    return true

    if( src instanceof TypedArray )
    return true;

    // if( arguments[ iteratorSymbol ] === undefined )
    // return false;
    if( Object.prototype.toString.call( src ) === '[object Arguments]' )
    return true;

    return false;
  }
  isBrowser.functor = is_functor;

}

const is = is_functor();

//

function isOld( src )
{

  if( _.primitive.is( src ) )
  return false;
  if( !_.class.methodIteratorOf( src ) )
  return false;

  if( _.argumentsArray.like( src ) )
  return true;
  if( _.bufferTyped.is( src ) )
  return true;

  return false;
}

//

function isCompact( src )
{
  if( _.argumentsArray.like( src ) )
  return true;
  if( _.bufferTyped.is( src ) )
  return true;

  return false;
}

//

function isUnfolded( src )
{
  if( Object.prototype.toString.call( src ) === '[object Arguments]' )
  return true;
  if( Array.isArray( src ) )
  return true
  if( _.bufferTyped.is( src ) )
  return true;

  return false;
}

//

function isUnfoldedSmartOrder( src )
{
  if( Array.isArray( src ) )
  return true
  if( _.bufferTyped.is( src ) )
  return true;
  // if( !arguments[ Symbol.iterator ] )
  // return false;
  if( Object.prototype.toString.call( src ) === '[object Arguments]' )
  return true;

  return false;
}

//

function isUnfoldedSmarter_functor()
{

  const TypedArray = Object.getPrototypeOf( Int8Array );
  //const iteratorSymbol = Symbol.iterator;

  if( _global_.BufferNode )
  return isUnfoldedSmarterNjs;
  return isUnfoldedSmarterBrowser;

  function isUnfoldedSmarterNjs( src )
  {
    if( Array.isArray( src ) )
    return true

    if( src instanceof TypedArray )
    {
      if( src instanceof BufferNode )
      return false;
      return true;
    }

    // if( arguments[ iteratorSymbol ] === undefined )
    // return false;
    if( Object.prototype.toString.call( src ) === '[object Arguments]' )
    return true;

    return false;
  }

  function isUnfoldedSmarterBrowser( src )
  {
    if( Array.isArray( src ) )
    return true

    if( src instanceof TypedArray )
    return true;

    // if( arguments[ iteratorSymbol ] === undefined )
    // return false;
    if( Object.prototype.toString.call( src ) === '[object Arguments]' )
    return true;

    return false;
  }

}

const isUnfoldedSmarter = isUnfoldedSmarter_functor();

// function is( src )
// {
//
//   if( _.primitive.is( src ) )
//   return false;
//   if( _.argumentsArray.like( src ) )
//   return true;
//   if( _.bufferTypedIs( src ) )
//   return true;
//
//   return false;
// }

//

function isEmpty( src )
{
  if( !_.long.is( src ) )
  return false;
  return src.length === 0;
}

//

function isPopulated( src )
{
  if( !_.long.is( src ) )
  return false;
  return src.length > 0;
}

//

function like( src ) /* qqq : cover */
{
  if( _.primitive.is( src ) )
  return false;
  return _.long.is( src );
}

//

function isResizable( src )
{
  if( _.array.is( src ) )
  return true;
  return false;
  // return this.is( src );
}

//

function IsResizable()
{
  return this.default.IsResizable();
}

// --
// maker
// --

function _makeEmpty( src )
{
  if( arguments.length === 1 )
  {
    if( _.argumentsArray.is( src ) )
    return _.argumentsArray._makeEmpty( 0 );
    else if( _.unroll.is( src ) )
    return _.unroll._makeEmpty();
    if( _.routine.is( src ) )
    {
      let result = new src( 0 );
      _.assert( _.long.is( result ) );
      return result;
    }
    if( this.is( src ) )
    return new src.constructor();
  }

  return this.tools.long.default._makeEmpty();
}

//

function makeEmpty( src )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( arguments.length === 1 )
  {
    _.assert( _.countable.is( src ) || _.routine.is( src ) );
    // _.assert( this.like( src ) || _.routine.is( src ) ); /* Dmytro : for compatibility with ContainerAdapters source instance should be a Vector, not simple Long */
    return this._makeEmpty( src );
  }

  return this._makeEmpty();
}

//

function _makeUndefined( src, length )
{
  if( arguments.length === 2 )
  {
    if( !_.number.is( length ) )
    {
      if( _.number.is( length.length ) )
      length = length.length;
      else
      length = [ ... length ].length;
    }

    if( src === null )
    return this.tools.long.default._makeUndefined( length );
    if( _.argumentsArray.is( src ) )
    return _.argumentsArray._makeUndefined( src, length );
    if( _.unroll.is( src ) )
    return _.unroll._makeUndefined( src, length );
    if( _.routine.is( src ) )
    {
      let result = new src( length );
      _.assert( _.long.is( result ) );
      return result;
    }
    return new src.constructor( length );
  }
  else if( arguments.length === 1 )
  {
    let constructor;
    if( this.like( src ) )
    {
      if( _.argumentsArray.is( src ) )
      return _.argumentsArray._makeUndefined( src );
      if( _.unroll.is( src ) )
      return _.unroll._makeUndefined( src );
      constructor = src.constructor;
      length = src.length;
    }
    else
    {
      return this.tools.long.default._makeUndefined( src );
    }
    return new constructor( length );
  }

  return this.tools.long.default._makeUndefined();
}

//

function makeUndefined( src, length )
{
  // _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  _.assert( 0 <= arguments.length && arguments.length <= 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || _.long.is( src ) || _.routine.is( src ) );
    _.assert( _.number.is( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.number.is( src ) || this.like( src ) || _.countable.is( src ) || _.routine.is( src ) );
  }
  return this._makeUndefined( ... arguments );
}

//

function _makeZeroed( src, length )
{
  if( arguments.length === 2 )
  {
    if( !_.number.is( length ) )
    {
      if( _.number.is( length.length ) )
      length = length.length;
      else
      length = [ ... length ].length;
    }

    if( src === null )
    return this.tools.long.default._makeZeroed( length );
    if( _.argumentsArray.is( src ) )
    return _.argumentsArray._makeZeroed( src, length );
    if( _.unroll.is( src ) )
    return _.unroll._makeZeroed( src, length );
    if( _.routine.is( src ) )
    {
      let result = fill( new src( length ) );
      _.assert( _.long.is( result ) );
      return result;
    }
    return fill( new src.constructor( length ) );
  }
  else if( arguments.length === 1 )
  {
    let constructor;
    if( this.like( src ) )
    {
      if( _.argumentsArray.is( src ) )
      return _.argumentsArray._makeZeroed( src );
      if( _.unroll.is( src ) )
      return _.unroll._makeZeroed( src );
      constructor = src.constructor;
      length = src.length;
    }
    else
    {
      return this.tools.long.default._makeZeroed( src );
    }
    return fill( new constructor( length ) );
  }

  return this.tools.long.default._make();

  /* */

  function fill( dst )
  {
    let l = dst.length;
    for( let i = 0 ; i < l ; i++ )
    dst[ i ] = 0;
    return dst;
  }
}

//

function makeZeroed( src, length )
{
  // _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  _.assert( 0 <= arguments.length && arguments.length <= 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || _.long.is( src ) || _.routine.is( src ) );
    _.assert( _.number.is( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.number.is( src ) || this.like( src ) || _.countable.is( src ) || _.routine.is( src ) );
  }
  return this._makeZeroed( ... arguments );
}

//

function _makeFilling( type, value, length )
{
  if( arguments.length === 2 )
  {
    value = arguments[ 0 ];
    length = arguments[ 1 ];

    if( this.like( length ) )
    type = length;
    else
    type = null;
  }

  if( !_.number.is( length ) )
  // if( _.long.is( length ) )
  if(  length.length )
  length = length.length;
  else if( _.countable.is( length ) )
  length = [ ... length ].length;

  let result = this._make( type, length );
  for( let i = 0 ; i < length ; i++ )
  result[ i ] = value;

  return result;
}

//

function makeFilling( type, value, length )
{
  if( arguments.length === 2 )
  {
    _.assert( _.number.is( value ) || _.countable.is( value ) );
    _.assert( type !== undefined );
  }
  else if( arguments.length === 3 )
  {
    _.assert( value !== undefined );
    _.assert( _.number.is( length ) || _.countable.is( length ) );
    _.assert( type === null || this.like( type ) || _.routine.is( type ) );
  }
  else
  {
    _.assert( 0, 'Expects 2 or 3 arguments' );
  }

  return this._makeFilling( ... arguments );
}

//

function _make( src, length )
{
  if( arguments.length === 2 )
  {
    let data = length;
    if( _.number.is( length ) )
    {
      data = src;
    }
    else
    {
      if( _.number.is( length.length ) )
      {
        length = length.length;
      }
      else
      {
        data = [ ... length ];
        length = data.length;
      }
    }
    if( _.argumentsArray.is( src ) )
    return fill( _.argumentsArray._make( length ), data );
    if( _.unroll.is( src ) )
    return fill( _.unroll._make( length ), data );
    if( src === null )
    return fill( this.tools.long.default._make( length ), data );
    let result;
    if( _.routine.is( src ) )
    result = fill( new src( length ), data )
    else if( src.constructor )
    result = fill( new src.constructor( length ), data );
    _.assert( _.long.is( result ), 'Not clear how to make such long' );
    return result;
  }
  else if( src !== undefined && src !== null )
  {
    if( _.number.is( src ) )
    return this.tools.long.default._make( src );
    if( _.unroll.is( src ) )
    return _.unroll._make( src );
    if( _.argumentsArray.is( src ) )
    return _.argumentsArray._make( src );
    if( src.constructor === Array )
    return [ ... src ];
    if( _.buffer.typedIs( src ) )
    return new src.constructor( src );
    if( _.countable.is( src ) )
    return this.tools.long.default._make( src );
    if( _.routine.is( src ) )
    {
      let result = new src();
      _.assert( this.is( result ), 'Expects long as returned instance' );
      return result;
    }
  }

  return this.tools.long.default.make();

  /* */

  function fill( dst, data )
  {
    if( data === null || data === undefined )
    return dst;
    let l = Math.min( length, data.length );
    for( let i = 0 ; i < l ; i++ )
    dst[ i ] = data[ i ];
    return dst;
  }
}

//

function make( src, length )
{
  _.assert( arguments.length <= 2 );
  if( arguments.length === 2 )
  {
    _.assert( src === null || _.long.is( src ) || _.routine.is( src ) );
    _.assert( _.number.is( length ) || _.countable.is( length ) );
  }
  else if( arguments.length === 1 )
  {
    _.assert( src === null || _.number.is( src ) || _.long.is( src ) || _.countable.is( src ) || _.routine.is( src ) );
  }
  return this._make( ... arguments );
}

//

function _cloneShallow( src )
{
  if( _.argumentsArray.is( src ) )
  return _.argumentsArray.make( src );
  if( _.unroll.is( src ) )
  return _.unroll.make( src );
  // if( _.number.is( src ) ) /* Dmytro : wrong branch, public interface forbids numbers as argument */
  // return this.tools.long.default.make( src );
  if( src.constructor === Array )
  return [ ... src ];
  else
  return new src.constructor( src );
}

//

function cloneShallow( src )
{
  _.assert( this.like( src ) );
  _.assert( arguments.length === 1 );
  return this._cloneShallow( src );
}

//

function from( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( this.is( src ) )
  return src;
  if( src === null )
  return this.make( null );
  return this.make( null, src );
}

// --
// long sequential search
// --

function leftIndex( /* arr, ins, evaluator1, evaluator2 */ )
{
  let arr = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let fromIndex = 0;

  if( _.number.is( arguments[ 2 ] ) )
  {
    fromIndex = arguments[ 2 ];
    evaluator1 = arguments[ 3 ];
    evaluator2 = arguments[ 4 ];
  }

  _.assert( 2 <= arguments.length && arguments.length <= 5, 'Expects 2-5 arguments: source array, element, and optional evaluator / equalizer' );
  _.assert( _.longLike( arr ), 'Expect a Long' );
  _.assert( _.number.is( fromIndex ) );
  _.assert( !evaluator1 || evaluator1.length === 1 || evaluator1.length === 2 || evaluator1.length === 3 );
  _.assert( !evaluator1 || _.routine.is( evaluator1 ) );
  _.assert( !evaluator2 || evaluator2.length === 1 );
  _.assert( !evaluator2 || _.routine.is( evaluator2 ) );

  if( !evaluator1 )
  {
    _.assert( !evaluator2 );
    return Array.prototype.indexOf.call( arr, ins, fromIndex );
  }
  else if( evaluator1.length === 1 ) /* equalizer */
  {

    if( evaluator2 )
    ins = evaluator2( ins );
    else
    ins = evaluator1( ins );

    if( arr.findIndex && fromIndex === 0 )
    {
      return arr.findIndex( ( val ) => evaluator1( val ) === ins );
    }
    else
    {
      for( let a = fromIndex; a < arr.length ; a++ )
      {
        if( evaluator1( arr[ a ] ) === ins )
        return a;
      }
    }

  }
  else /* evaluator */
  {
    _.assert( !evaluator2 );
    for( let a = fromIndex ; a < arr.length ; a++ )
    {
      if( evaluator1( arr[ a ], ins ) )
      return a;
    }
  }

  return -1;
}

//

function rightIndex( /* arr, ins, evaluator1, evaluator2 */ )
{
  let arr = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let evaluator1 = arguments[ 2 ];
  let evaluator2 = arguments[ 3 ];

  let fromIndex = arr.length-1;

  if( _.number.is( arguments[ 2 ] ) )
  {
    fromIndex = arguments[ 2 ];
    evaluator1 = arguments[ 3 ];
    evaluator2 = arguments[ 4 ];
  }

  _.assert( 2 <= arguments.length && arguments.length <= 5, 'Expects 2-5 arguments: source array, element, and optional evaluator / equalizer' );
  _.assert( _.number.is( fromIndex ) );
  _.assert( !evaluator1 || evaluator1.length === 1 || evaluator1.length === 2 || evaluator1.length === 3 );
  _.assert( !evaluator1 || _.routine.is( evaluator1 ) );
  _.assert( !evaluator2 || evaluator2.length === 1 );
  _.assert( !evaluator2 || _.routine.is( evaluator2 ) );

  if( !evaluator1 )
  {
    _.assert( !evaluator2 );
    return Array.prototype.lastIndexOf.call( arr, ins, fromIndex );
  }
  else if( evaluator1.length === 1 ) /* equalizer */
  {

    if( evaluator2 )
    ins = evaluator2( ins );
    else
    ins = evaluator1( ins );

    for( let a = fromIndex ; a >= 0 ; a-- )
    {
      if( evaluator1( arr[ a ] ) === ins )
      return a;
    }

  }
  else /* evaluator */
  {
    _.assert( !evaluator2 );
    for( let a = fromIndex ; a >= 0 ; a-- )
    {
      if( evaluator1( arr[ a ], ins ) )
      return a;
    }
  }

  return -1;
}

//

/**
 * The routine longLeft() returns a new object containing the properties, (index, element),
 * corresponding to a found value {-ins-} from a Long {-arr-}.
 * If element is not founded, then routine return new object with property (index), which value is -1.
 *
 * @param { Long } arr - A Long to check.
 * @param { * } ins - An element to locate in the {-arr-}.
 * @param { Number } fromIndex - An index from which routine starts search left to right.
 * If {-fromIndex-} not defined, then routine starts search from the first index.
 * @param { Function } evaluator1 - It's a callback. If the routine has two parameters,
 * it is used as an equalizer, and if it has only one, then routine is used as the evaluator.
 * @param { Function } onEvaluate2 - The second part of evaluator. Accepts the {-ins-} to search.
 *
 * @example
 * _.longLeft( [ 1, 2, false, 'str', 2, 5 ], 2 );
 * // returns { index : 1, element : 2 }
 *
 * @example
 * _.longLeft( [ 1, 2, false, 'str', 2, 5 ], [ 2 ] );
 * // returns { index : -1 }
 *
 * @example
 * _.longLeft( [ 1, 2, false, 'str', 2, 5 ], 2, 3 );
 * // returns { index : 4, element : 2 }
 *
 * @example
 * _.longLeft( [ 1, 2, false, 'str', 2, 5 ], [ 2 ], ( val ) => val[ 0 ] );
 * // returns { index : -1 }
 *
 * @example
 * _.longLeft( [ 1, [ 2 ], false, 'str', 2, 5 ], [ 2 ], ( val ) => val[ 0 ] );
 * // returns { index : 1, element : [ 2 ] }
 *
 * @example
 * _.longLeft( [ 1, [ 2 ], false, 'str', 2, 5 ], [ 2 ], ( val ) => val - 3, ( ins ) => ins[ 0 ] );
 * // returns { index : 5, element : 5 }
 *
 * @example
 * _.longLeft( [ 1, [ 2 ], false, 'str', 2, 5 ], [ 2 ], 3, ( val ) => val + 1, ( ins ) => ins[ 0 ] );
 * // returns { index : 5, element : 5 }
 *
 * @example
 * _.longLeft( [ 1, 2, false, 'str', 2, 5 ], 2, ( val, ins ) => val === ins );
 * // returns { index : 1, element : 2 }
 *
 * @returns { Object } Returns a new object containing the properties, (index, element),
 * corresponding to the found value {-ins-} from the array {-arr-}.
 * Otherwise, it returns the object with property (index), which value is -1.
 * @function longLeft
 * @throws { Error } If arguments.length is less then two or more then five.
 * @throws { Error } If {-fromIndex-} is not a number.
 * @throws { Error } If {-onEvaluate1-} is not a routine.
 * @throws { Error } If {-onEvaluate1-} is undefines and onEvaluate2 provided.
 * @throws { Error } If {-onEvaluate1-} is evaluator and accepts less or more then one parameter.
 * @throws { Error } If {-onEvaluate1-} is equalizer and onEvaluate2 provided.
 * @throws { Error } If {-onEvaluate2-} is not a routine.
 * @throws { Error } If {-onEvaluate2-} accepts less or more then one parameter.
 * @namespace Tools
 */

function left( /* arr, ins, fromIndex, evaluator1, evaluator2 */ )
{
  let arr = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let fromIndex = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result = Object.create( null );
  let i = _.longLeftIndex( arr, ins, fromIndex, evaluator1, evaluator2 );

  _.assert( 2 <= arguments.length && arguments.length <= 5 );

  result.index = i;

  if( i >= 0 )
  result.element = arr[ i ];

  return result;
}

//

/**
 * The routine longRight() returns a new object containing the properties, (index, element),
 * corresponding to a found value {-ins-} from a Long {-arr-}.
 * If element is not founded, then routine return new object with property (index), which value is -1.
 *
 * @param { Long } arr - A Long to check.
 * @param { * } ins - An element to locate in the {-arr-}.
 * @param { Number } fromIndex - An index from which routine starts search right to left.
 * If {-fromIndex-} not defined, then routine starts search from the last index.
 * @param { Function } evaluator1 - It's a callback. If the routine has two parameters,
 * it is used as an equalizer, and if it has only one, then routine is used as the evaluator.
 * @param { Function } onEvaluate2 - The second part of evaluator. Accepts the {-ins-} to search.
 *
 * @example
 * _.longRight( [ 1, 2, false, 'str', 2, 5 ], 2 );
 * // returns { index : 4, element : 2 }
 *
 * @example
 * _.longRight( [ 1, 2, false, 'str', 2, 5 ], [ 2 ] );
 * // returns { index : -1 }
 *
 * @example
 * _.longRight( [ 1, 2, false, 'str', 2, 5 ], 2, 3 );
 * // returns { index : 1, element : 2 }
 *
 * @example
 * _.longRight( [ 1, 2, false, 'str', 2, 5 ], [ 2 ], ( val ) => val[ 0 ] );
 * // returns { index : -1 }
 *
 * @example
 * _.longRight( [ 1, [ 2 ], false, 'str', 2, 5 ], [ 2 ], ( val ) => val[ 0 ] );
 * // returns { index : 1, element : [ 2 ] }
 *
 * @example
 * _.longRight( [ 1, [ 2 ], false, 'str', 2, 5 ], [ 2 ], ( val ) => val - 3, ( ins ) => ins[ 0 ] );
 * // returns { index : 5, element : 5 }
 *
 * @example
 * _.longRight( [ 1, [ 2 ], false, 'str', 2, 5 ], [ 2 ], 4, ( val ) => val - 3, ( ins ) => ins[ 0 ] );
 * // returns { index : -1 }
 *
 * @example
 * _.longRight( [ 1, 2, false, 'str', 2, 5 ], 2, ( val, ins ) => val === ins );
 * // returns { index : 4, element : 2 }
 *
 * @returns { Object } Returns a new object containing the properties, (index, element),
 * corresponding to the found value {-ins-} from the array {-arr-}.
 * Otherwise, it returns the object with property (index), which value is -1.
 * @function longRight
 * @throws { Error } If arguments.length is less then two or more then five.
 * @throws { Error } If {-fromIndex-} is not a number.
 * @throws { Error } If {-onEvaluate1-} is not a routine.
 * @throws { Error } If {-onEvaluate1-} is undefines and onEvaluate2 provided.
 * @throws { Error } If {-onEvaluate1-} is evaluator and accepts less or more then one parameter.
 * @throws { Error } If {-onEvaluate1-} is equalizer and onEvaluate2 provided.
 * @throws { Error } If {-onEvaluate2-} is not a routine.
 * @throws { Error } If {-onEvaluate2-} accepts less or more then one parameter.
 * @namespace Tools
 */

function right( /* arr, ins, fromIndex, evaluator1, evaluator2 */ )
{
  let arr = arguments[ 0 ];
  let ins = arguments[ 1 ];
  let fromIndex = arguments[ 2 ];
  let evaluator1 = arguments[ 3 ];
  let evaluator2 = arguments[ 4 ];

  let result = Object.create( null );
  let i = _.longRightIndex( arr, ins, fromIndex, evaluator1, evaluator2 );

  _.assert( 2 <= arguments.length && arguments.length <= 5 );

  result.index = i;

  if( i >= 0 )
  result.element = arr[ i ];

  return result;
}

//

/**
 * The routine longLeftDefined() returns a new object containing the properties, (index, element),
 * of first left element in a Long {-arr-}, which value is not equal to undefined.
 * If element is not founded, then routine return new object with property (index), which value is -1.
 *
 * @param { Long } arr - A Long to check.
 *
 * @example
 * _.longLeftDefined( [ undefined, undefined, undefined, undefined, undefined ] );
 * // returns { index : -1 }
 *
 * @example
 * _.longLeftDefined( [ 1, undefined, 2, false, 'str', 2, undefined, 5 ] );
 * // returns { index : 0, element : 1 }
 *
 * @example
 * _.longLeftDefined( [ undefined, undefined, 2, false, 'str', 2 ] );
 * // returns { index : 2, element : 2 }
 *
 * @returns { Object } Returns a new object containing the properties, (index, element),
 * of first left element in a Long {-arr-}, which value is not equal to undefined.
 * Otherwise, it returns the object with property (index), which value is -1.
 * @function longRight
 * @throws { Error } If arguments.length is less then or more then one.
 * @namespace Tools
 */

function leftDefined( arr )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.longLeft( arr, true, function( val ){ return val !== undefined; } );
}

//

/**
 * The routine longRightDefined() returns a new object containing the properties, (index, element),
 * of first right element in a Long {-arr-}, which value is not equal to undefined.
 * If element is not founded, then routine return new object with property (index), which value is -1.
 *
 * @param { Long } arr - A Long to check.
 *
 * @example
 * _.longRightDefined( [ undefined, undefined, undefined, undefined, undefined ] );
 * // returns { index : -1 }
 *
 * @example
 * _.longRightDefined( [ 1, 2, false, 'str', 2, undefined, 5 ] );
 * // returns { index : 6, element : 5 }
 *
 * @example
 * _.longRightDefined( [ 1, 2, false, 'str', 2, undefined, undefined ] );
 * // returns { index : 4, element : 2 }
 *
 * @returns { Object } Returns a new object containing the properties, (index, element),
 * of first right element in a Long {-arr-}, which value is not equal to undefined.
 * Otherwise, it returns the object with property (index) which, value is -1.
 * @function longRight
 * @throws { Error } If arguments.length is less then or more then one.
 * @namespace Tools
 */

function rightDefined( arr )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.longRight( arr, true, function( val ){ return val !== undefined; } );
}

// --
// meta
// --

// function _namespaceRegister( namespace )
// {
//   let aggregatorNamespace = this;
//   if( !aggregatorNamespace )
//   aggregatorNamespace = _.long;
//
//   if( Config.debug )
//   verify();
//
//   aggregatorNamespace.namespaces[ namespace.NamespaceName ] = namespace;
//
//   _.assert( !!namespace.IsResizable );
//   _.assert( namespace.IsLong === undefined || namespace.IsLong === true );
//   namespace.IsLong = true;
//
//   namespace.asDefault = aggregatorNamespace._asDefaultGenerate( namespace );
//
//   /* */
//
//   function verify()
//   {
//     _.assert( !!namespace.NamespaceName );
//     _.assert( aggregatorNamespace.namespaces[ namespace.Name ] === undefined );
//     _.assert( _[ namespace.NamespaceName ] === namespace );
//     _.assert( _select( _global_, namespace.NamespaceQname ) === namespace );
//   }
//
//   /* */
//
//   function _select( src, selector )
//   {
//     selector = selector.split( '/' );
//     while( selector.length && !!src )
//     {
//       src = src[ selector[ 0 ] ];
//       selector.splice( 0, 1 )
//     }
//     return src;
//   }
//
//   /* */
//
// }
//
// //
//
// function _asDefaultGenerate( namespace )
// {
//   let aggregatorNamespace = this;
//
//   _.assert( !!namespace );
//   _.assert( !!namespace.TypeName );
//
//   let result = aggregatorNamespace.toolsNamespacesByType[ namespace.TypeName ];
//   if( result )
//   return result;
//
//   result = aggregatorNamespace.toolsNamespacesByType[ namespace.TypeName ] = Object.create( _ );
//
//   aggregatorNamespace.toolsNamespacesByName[ namespace.NamespaceName ] = result;
//
//   /* xxx : introduce map _.namespaces */
//   for( let name in aggregatorNamespace.namespaces )
//   {
//     let namespace = aggregatorNamespace.namespaces[ name ];
//     result[ namespace.TypeName ] = Object.create( namespace );
//     result[ namespace.TypeName ].tools = result;
//   }
//
//   result[ aggregatorNamespace.NamespaceName ] = Object.create( aggregatorNamespace );
//   result[ aggregatorNamespace.NamespaceName ].tools = result;
//   result[ aggregatorNamespace.NamespaceName ].default = namespace;
//
//   return result;
// }

function _namespaceRegister( namespace )
{
  let aggregatorNamespace = this;
  if( !aggregatorNamespace )
  aggregatorNamespace = _.long;

  if( Config.debug )
  verify();

  // if( namespace.NamespaceName === 'u32x' )
  // debugger;

  namespace.NamespaceNames.forEach( ( name ) =>
  {
    _.assert( aggregatorNamespace.namespaces[ name ] === undefined );
    aggregatorNamespace.namespaces[ name ] = namespace;
  });

  _.assert( !!namespace.IsResizable );
  _.assert( namespace.IsLong === undefined || namespace.IsLong === true );
  namespace.IsLong = true;

  namespace.asDefault = aggregatorNamespace._asDefaultGenerate( namespace );

  /* */

  function verify()
  {
    _.assert( !!namespace.NamespaceName );
    _.assert( aggregatorNamespace.namespaces[ namespace.Name ] === undefined );
    _.assert( _[ namespace.NamespaceName ] === namespace );
    _.assert( _select( _global_, namespace.NamespaceQname ) === namespace );
  }

  /* */

  function _select( src, selector )
  {
    selector = selector.split( '/' );
    while( selector.length && !!src )
    {
      src = src[ selector[ 0 ] ];
      selector.splice( 0, 1 )
    }
    return src;
  }

  /* */

}

//

function _asDefaultGenerate( namespace )
{
  let aggregatorNamespace = this;

  _.assert( !!namespace );
  _.assert( !!namespace.TypeName );

  let result = aggregatorNamespace.toolsNamespacesByType[ namespace.TypeName ];
  if( result )
  return result;

  result = aggregatorNamespace.toolsNamespacesByType[ namespace.TypeName ] = Object.create( _ );
  namespace.TypeNames.forEach( ( name ) =>
  {
    _.assert
    (
         aggregatorNamespace.toolsNamespacesByType[ name ] === undefined
      || aggregatorNamespace.toolsNamespacesByType[ name ] === result
    );
    aggregatorNamespace.toolsNamespacesByType[ name ] = result;
  });

  /* xxx : introduce map _.namespaces */
  for( let name in aggregatorNamespace.namespaces )
  {
    let namespace2 = aggregatorNamespace.namespaces[ name ];
    let namespace3 = result[ namespace2.TypeName ] = Object.create( namespace2 );
    namespace3.tools = result;
    namespace3.TypeNames.forEach( ( name ) =>
    {
      result[ name ] = namespace3;
    });
  }

  let namespace2 = result[ aggregatorNamespace.NamespaceName ] = Object.create( aggregatorNamespace );
  namespace2.tools = result;
  namespace2.default = namespace;
  aggregatorNamespace.NamespaceNames.forEach( ( name ) =>
  {
    result[ name ] = namespace2;
  });

  return result;
}

//

/* qqq : optimize */
function namespaceOf( src )
{

  if( _.unroll.is( src ) )
  return _.unroll;
  if( _.array.is( src ) )
  return _.array;
  if( _.argumentsArray.is( src ) )
  return _.argumentsArray;

  let result = _.bufferTyped.namespaceOf( src );
  if( result )
  return result;

  if( _.long.is( src ) )
  return _.long;

  // if( _.vector.is( src ) )
  // return _.vector;
  // if( _.countable.is( src ) )
  // return _.countable;

  return null;
}

//

function namespaceWithDefaultOf( src )
{
  if( src === null )
  debugger;
  if( src === null )
  return this.default;
  return this.namespaceOf( src );
}

//

function _functor_functor( methodName, typer, which )
{
  _.assert( !!( methodName ) );
  if( !typer )
  typer = 'namespaceOf';
  if( !which )
  which = 0;
  if( which === 0 )
  return end( _functor0 );
  if( which === 1 )
  return end( _functor1 );
  _.assert( 0 );

  function _functor0( container )
  {
    _.assert( arguments.length === 1 );
    _.assert( _.routine.is( this[ typer ] ), () => `No routine::${typer} in the namesapce::${this.NamespaceName}` );
    const namespace = this[ typer ]( container );
    _.assert( _.routine.is( namespace[ methodName ] ), `No routine::${methodName} in the namesapce::${namespace.NamespaceName}` );
    return namespace[ methodName ].bind( namespace, container );
  }

  function _functor1( container )
  {
    _.assert( arguments.length === 1 );
    _.assert( _.routine.is( this[ typer ] ), () => `No routine::${typer} in the namesapce::${this.NamespaceName}` );
    const namespace = this[ typer ]( container );
    _.assert( _.routine.is( namespace[ methodName ] ), `No routine::${methodName} in the namesapce::${namespace.NamespaceName}` );
    const routine0 = namespace[ methodName ];
    return routine1.bind( namespace );
    function routine1( arg1, ... args )
    {
      return routine0.call( this, arg1, container, ... args );
    }
  }

  function end( result )
  {
    result.functor = new Function( `return _.long._functor_functor( '${methodName}', '${typer}', ${which} )` );
    return result;
  }

}

// --
// long extension
// --

let LongExtension =
{

  //

  NamespaceName : 'long',
  NamespaceNames : [ 'long' ],
  NamespaceQname : 'wTools/long',
  MoreGeneralNamespaceName : 'long',
  MostGeneralNamespaceName : 'countable',
  TypeName : 'Long',
  TypeNames : [ 'Long' ],
  InstanceConstructor : null,
  IsLong : true,
  tools : _,

  // dichotomy

  is,
  isOld, /* xxx : remove later */
  isCompact,
  isUnfolded,
  isUnfoldedSmartOrder,
  isUnfoldedSmarter,
  isEmpty,
  isPopulated,
  like,
  isResizable,
  IsResizable,

  // maker

  _makeEmpty,
  makeEmpty, /* qqq : for junior : cover */
  _makeUndefined,
  makeUndefined, /* qqq : for junior : cover */
  _makeZeroed,
  makeZeroed, /* qqq : for junior : cover */
  _makeFilling,
  makeFilling,
  _make,
  make, /* qqq : for junior : cover */
  _cloneShallow,
  cloneShallow, /* qqq : for junior : cover */
  from, /* qqq : for junior : cover */

  // long sequential search

  leftIndex,
  rightIndex,

  left,
  right,

  leftDefined,
  rightDefined,

  // meta

  _namespaceRegister,
  _asDefaultGenerate,

  // meta

  namespaceOf,
  namespaceWithDefaultOf,
  _functor_functor,

}

//

Object.assign( _.long, LongExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  // dichotomy

  longIs : is.bind( _.long ),
  longIsEmpty : isEmpty.bind( _.long ),
  longIsPopulated : isPopulated.bind( _.long ),
  longLike : like.bind( _.long ),

  // maker

  longMakeEmpty : makeEmpty.bind( _.long ),
  longMakeUndefined : makeUndefined.bind( _.long ),
  longMakeZeroed : makeZeroed.bind( _.long ),
  longMakeFilling : makeFilling.bind( _.long ),
  longMake : make.bind( _.long ),
  longCloneShallow : cloneShallow.bind( _.long ),
  longFrom : from.bind( _.long ),

  // long sequential search

  longLeftIndex : leftIndex,
  longRightIndex : rightIndex,

  longLeft : left,
  longRight : right,

  longLeftDefined : leftDefined,
  longRightDefined : rightDefined,

}

Object.assign( _, ToolsExtension );

//

})();

( function _l7_Functional_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _global_.wTools;

// --
//
// --

function _entityFilterDeep( o )
{

  let result;
  let onEach = _._filter_functor( o.onEach, o.conditionLevels );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.object.like( o.src ) || _.longIs( o.src ), 'entityFilter : expects objectLike or longIs src, but got', _.entity.strType( o.src ) );
  _.assert( _.routine.is( onEach ) );

  /* */

  if( _.longIs( o.src ) )
  {
    if( _.argumentsArray.is( o.src ) ) /* Dmytro : seems as hack, this primitive realization use type check. The more type independent realization creates resulted container of full length and routine longBut_ */ /* qqq xxx : Dmytro : please, discuss it */
    result = [];
    else
    result = _.long.make( o.src, 0 );

    // result = _.long.make( o.src, o.src.length ); /* Dmytro : second variant */
    let s, d;
    for( s = 0, d = 0 ; s < o.src.length ; s++ )
    // for( let s = 0, d = 0 ; s < o.src.length ; s++, d++ )
    {
      let r = onEach.call( o.src, o.src[ s ], s, o.src );

      if( _.unrollIs( r ) )
      {
        _.arrayAppendArray( result, r );
        // _.longBut_( result, d, r ); /* Dmytro : second variant */
        d += r.length;
      }
      else if( r !== undefined )
      {
        result[ d ] = r;
        d += 1;
      }

      // if( r === undefined )
      // d--;
      // else
      // result[ d ] = r;

    }
    if( d < o.src.length )
    result = _.longSlice( result, 0, d );
    // result = _.array.slice( result, 0, d );
  }
  else
  {
    result = _.entity.makeUndefined( o.src );
    for( let s in o.src )
    {
      let r = onEach.call( o.src, o.src[ s ], s, o.src );
      // r = onEach.call( o.src, o.src[ s ], s, o.src );
      if( r !== undefined )
      result[ s ] = r;
    }
  }

  /* */

  return result;
}

_entityFilterDeep.defaults =
{
  src : null,
  onEach : null,
  conditionLevels : 1,
}

//

function entityFilterDeep( src, onEach )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return _entityFilterDeep
  ({
    src,
    onEach,
    conditionLevels : 1024,
  });
}

//

/*
qqq : for Dmytro : poor coverage and implementation was wrong!
*/

function _entityIndex_functor( fop )
{

  fop = _.routine.options( _entityIndex_functor, fop );

  let extendRoutine = fop.extendRoutine;

  return function entityIndex( src, onEach )
  {
    let result = Object.create( null );

    if( onEach === undefined )
    onEach = function( e, k )
    {
      if( k === undefined && extendRoutine )
      return { [ e ] : undefined };
      return k;
    }
    else if( _.strIs( onEach ) )
    {
      let selector = onEach;
      _.assert( _.routine.is( _.select ) );
      _.assert( _.strBegins( selector, '*/' ), () => `Selector should begins with "*/", but "${selector}" does not` );
      selector = _.strRemoveBegin( selector, '*/' );
      onEach = function( e, k )
      {
        return _.select( e, selector );
      }
      /* Dmytro : Note. Selector selects properties of entities. For example:
      var got = ( 'str', '\*\/length' );
      var exp = { 3 : 'str' };
      test.identical( got, exp );
      */
    }

    _.assert( arguments.length === 1 || arguments.length === 2 );
    _.assert( _.routine.is( onEach ) );
    _.assert( src !== undefined, 'Expects {-src-}' );

    /* */

    if( _.aux.is( src ) )
    {

      for( let k in src )
      {
        let val = src[ k ];
        let r = onEach( val, k, src );
        extend( r, val );
      }

    }
    else if( _.longIs( src ) )
    {

      for( let k = 0 ; k < src.length ; k++ )
      {
        let val = src[ k ];
        let r = onEach( val, k, src );
        extend( r, val );
      }

    }
    else
    {

      let val = src;
      let r = onEach( val, undefined, undefined );
      extend( r, val );

    }

    return result;

    /* */

    function extend( ext, val )
    {
      if( ext === undefined )
      return;

      if( _.unrollIs( ext ) )
      return ext.forEach( ( ext ) => extend( ext, val ) );

      if( extendRoutine === null )
      {
        // if( ext !== undefined ) // Dmytro : it's unnecessary condition, see 10 lines above
        result[ ext ] = val;
      }
      else
      {
        if( !_.aux.is( ext ) )
        {
          _.assert( _.primitive.is( ext ) );
          ext = { [ ext ] : val }
        }
        extendRoutine( result, ext );
        // // else if( ext !== undefined ) // Dmytro : it's unnecessary condition, see 16 lines above
        // else
        // result[ ext ] = val;
      }

    }

  }

}

_entityIndex_functor.defaults =
{
  extendRoutine : null,
}

//

/**
 * The routine entityIndex() returns a new pure map. The values of the map defined by elements of provided
 * entity {-src-} and keys defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndex( null );
 * // returns {}
 *
 * @example
 * _.entityIndex( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndex( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndex( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '1' : 1, '3' : 2, '5' : 3, '7' : 4 }
 *
 * @example
 * _.entityIndex( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndex( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { '1' : 1, '2' : 2, '3' : 3 }
 *
 * @example
 * _.entityIndex( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 3 }, '2' : { f1 : 2, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys defined by results of callback execution on corresponding elements.
 * @function entityIndex
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */

let entityIndex = _entityIndex_functor({ extendRoutine : null });

//

/**
 * The routine entityIndexSupplementing() returns a new pure map. The pairs key-value of the map formed by results
 * of callback execution on the entity elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine does not change existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndexSupplementing( null );
 * // returns { 'null' : undefined }
 *
 * @example
 * _.entityIndexSupplementing( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndexSupplementing( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexSupplementing( [ 1, 2, 3, 4 ], ( el, key ) => key > 2 ? key : 1 );
 * // returns { '1' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexSupplementing( { a : 1, b : 1, c : 1 } );
 * // returns { a : 1, b : 1, c : 1 }
 *
 * @example
 * _.entityIndexSupplementing( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndexSupplementing( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : key, 'x' : el } } );
 * // returns { a : 'a', x : 1, b : 'b', c : 'c' }
 *
 * @example
 * _.entityIndexSupplementing( { a : { f1 : 1, f2 : 3 }, b : { f1 : 1, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys of defines by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine does not replaces the previous value with the new one.
 * @function entityIndexSupplementing
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */

let entityIndexSupplementing = _entityIndex_functor({ extendRoutine : _.props.supplement.bind( _.props ) });

//

/**
 * The routine entityIndexExtending() returns a new pure map. The pairs key-value of the map formed by results
 * of callback execution on the entity elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine replaces existed value to the new.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndexExtending( null );
 * // returns { 'null' : undefined }
 *
 * @example
 * _.entityIndexExtending( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndexExtending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexExtending( [ 1, 2, 3, 4 ], ( el, key ) => key > 2 ? key : 1 );
 * // returns { '1' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexExtending( { a : 1, b : 1, c : 1 } );
 * // returns { a : 1, b : 1, c : 1 }
 *
 * @example
 * _.entityIndexExtending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndexExtending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : key, 'x' : el } } );
 * // returns { a : 'a', x : 3, b : 'b', c : 'c' }
 *
 * @example
 * _.entityIndexExtending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 1, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys of defines by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine replaces the previous value with the new one.
 * @function entityIndexExtending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */

let entityIndexExtending = _entityIndex_functor({ extendRoutine : _.props.extend.bind( _.props ) });

//

/**
 * The routine entityIndexPrepending() returns a new pure map. The pairs key-value of the map formed by results
 * of callback execution on the entity elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine prepends new values to the existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndexPrepending( null );
 * // returns { 'null' : undefined }
 *
 * @example
 * _.entityIndexPrepending( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndexPrepending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexPrepending( [ 1, 2, 3, 4 ], ( el, key ) => key > 2 ? key : 1 );
 * // returns { '1' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexPrepending( { a : 1, b : 1, c : 1 } );
 * // returns { a : 1, b : 1, c : 1 }
 *
 * @example
 * _.entityIndexPrepending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndexPrepending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : key, 'x' : el } } );
 * // returns { a : 'a', x : [ 3, 2, 1 ], b : 'b', c : 'c' }
 *
 * @example
 * _.entityIndexPrepending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 1, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys of defines by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine prepends new value to the previous.
 * @function entityIndexPrepending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */

let entityIndexPrepending = _entityIndex_functor({ extendRoutine : _.mapExtendPrepending });

//

/**
 * The routine entityIndexAppending() returns a new pure map. The pairs key-value of the map formed by results
 * of callback execution on the entity elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine appends new values to the existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndexAppending( null );
 * // returns { 'null' : undefined }
 *
 * @example
 * _.entityIndexAppending( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndexAppending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexAppending( [ 1, 2, 3, 4 ], ( el, key ) => key > 2 ? key : 1 );
 * // returns { '1' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexAppending( { a : 1, b : 1, c : 1 } );
 * // returns { a : 1, b : 1, c : 1 }
 *
 * @example
 * _.entityIndexAppending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndexAppending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : key, 'x' : el } } );
 * // returns { a : 'a', x : [ 1, 2, 3 ], b : 'b', c : 'c' }
 *
 * @example
 * _.entityIndexAppending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 1, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys of defines by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine appends new value to the previous.
 * @function entityIndexAppending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */

let entityIndexAppending = _entityIndex_functor({ extendRoutine : _.mapExtendAppending });

//

function _entityRemap_functor( fop )
{

  fop = _.routine.options( _entityRemap_functor, fop );

  let extendRoutine = fop.extendRoutine;

  return function entityRemap( src, onEach )
  {
    let result = Object.create( null );

    if( onEach === undefined )
    onEach = function( e, k )
    {
      if( e === undefined && extendRoutine )
      return { [ k ] : e };
      return e;
    }
    else if( _.strIs( onEach ) )
    {
      let selector = onEach;
      _.assert( _.routine.is( _.select ) );
      _.assert( _.strBegins( selector, '*/' ), () => `Selector should begins with "*/", but "${selector}" does not` );
      selector = _.strRemoveBegin( selector, '*/' );
      onEach = function( e, k )
      {
        return _.select( e, selector );
      }
    }

    _.assert( arguments.length === 1 || arguments.length === 2 );
    _.assert( _.routine.is( onEach ) );
    _.assert( src !== undefined, 'Expects src' );

    /* */

    if( _.aux.is( src ) )
    {

      for( let k in src )
      {
        let val = src[ k ];
        let r = onEach( val, k, src );
        extend( r, k );
      }

    }
    else if( _.longIs( src ) )
    {

      for( let k = 0 ; k < src.length ; k++ )
      {
        let val = src[ k ];
        let r = onEach( val, k, src );
        extend( r, k );
      }

    }
    else
    {

      let val = src;
      let r = onEach( val, undefined, undefined );
      extend( r, undefined );

    }

    return result;

    /* */

    function extend( res, key )
    {
      if( res === undefined )
      return;

      if( _.unrollIs( res ) )
      return res.forEach( ( res ) => extend( res, key ) );

      if( extendRoutine === null )
      {
        if( key !== undefined )
        result[ key ] = res;
      }
      else
      {
        if( _.aux.is( res ) )
        extendRoutine( result, res );
        else if( key !== undefined )
        result[ key ] = res;
      }

    }

  }

}

_entityRemap_functor.defaults =
{
  extendRoutine : null,
}

//

/**
 * The routine entityRemap() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemap( null );
 * // returns {}
 *
 * @example
 * _.entityRemap( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemap( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemap( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemap( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemap( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemap( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements.
 * @function entityRemap
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */

let entityRemap = _entityRemap_functor({ extendRoutine : null });

//

/**
 * The routine entityRemapSupplementing() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine does not change existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemapSupplementing( null );
 * // returns {}
 *
 * @example
 * _.entityRemapSupplementing( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemapSupplementing( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemapSupplementing( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemapSupplementing( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapSupplementing( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemapSupplementing( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : el, x : el } } );
 * // returns { a : 1, x : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapSupplementing( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine does not replaces the previous value with the new one.
 * @function entityRemapSupplementing
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */


let entityRemapSupplementing = _entityRemap_functor({ extendRoutine : _.props.supplement.bind( _.props ) });

//

/**
 * The routine entityRemapExtending() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine does change existed value to the new one.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemapExtending( null );
 * // returns {}
 *
 * @example
 * _.entityRemapExtending( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemapExtending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemapExtending( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemapExtending( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapExtending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemapExtending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : el, x : el } } );
 * // returns { a : 1, x : 3, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapExtending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine replaces the previous value with the new one.
 * @function entityRemapExtending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */

let entityRemapExtending = _entityRemap_functor({ extendRoutine : _.props.extend.bind( _.props ) });

//

/**
 * The routine entityRemapPrepending() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine prepends new values to the existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemapPrepending( null );
 * // returns {}
 *
 * @example
 * _.entityRemapPrepending( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemapPrepending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemapPrepending( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemapPrepending( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapPrepending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemapPrepending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : el, x : el } } );
 * // returns { a : 1, x : [ 3, 2, 1 ], b : 2, c : 3 }
 *
 * @example
 * _.entityRemapPrepending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine prepends new values to the existed value.
 * @function entityRemapPrepending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */

let entityRemapPrepending = _entityRemap_functor({ extendRoutine : _.mapExtendPrepending });

//

/**
 * The routine entityRemapAppending() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine appends new values to the existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemapAppending( null );
 * // returns {}
 *
 * @example
 * _.entityRemapAppending( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemapAppending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemapAppending( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemapAppending( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapAppending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemapAppending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : el, x : el } } );
 * // returns { a : 1, x : [ 3, 2, 1 ], b : 2, c : 3 }
 *
 * @example
 * _.entityRemapAppending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine appends new values to the existed value.
 * @function entityRemapAppending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @namespace Tools
 */

let entityRemapAppending = _entityRemap_functor({ extendRoutine : _.mapExtendAppending });

// --
// implementation
// --

let ToolsExtension =
{

  // eachSample_, /* xxx : review */
  // eachPermutation_, /* xxx : move out */
  // swapsCount, /* xxx : move out */
  // _factorial, /* xxx : move out */
  // factorial, /* xxx : move out */

  _entityFilterDeep,
  entityFilterDeep,
  filterDeep : entityFilterDeep,

  _entityIndex_functor,
  entityIndex,
  index : entityIndex,
  entityIndexSupplementing,
  indexSupplementing : entityIndexSupplementing,
  entityIndexExtending,
  indexExtending : entityIndexExtending,
  entityIndexPrepending,
  indexPrepending : entityIndexPrepending,
  entityIndexAppending,
  indexAppending : entityIndexAppending,

  _entityRemap_functor,
  entityRemap,
  remap : entityRemap,
  entityRemapSupplementing,
  remapSupplementing : entityRemapSupplementing,
  entityRemapExtending,
  remapExtending : entityRemapExtending,
  entityRemapPrepending,
  remapPrepending : entityRemapPrepending,
  entityRemapAppending,
  remapAppending : entityRemapAppending,

}

//

Object.assign( _, ToolsExtension );

})();

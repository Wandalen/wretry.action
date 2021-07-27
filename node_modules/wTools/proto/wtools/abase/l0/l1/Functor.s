( function _l1_Functor_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.functor = _.functor || Object.create( null );

// --
// implementation
// --

/*
qqq : for Dmytro : add support and coverage of Set. discuss
*/

function vectorize_head( routine, args )
{
  let o = args[ 0 ];

  if( args.length === 2 )
  o = { routine : args[ 0 ], select : args[ 1 ] }
  else if( _.routine.is( o ) || _.strIs( o ) )
  o = { routine : args[ 0 ] }

  _.routine.options( routine, o );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.routine.is( o.routine ) || _.strIs( o.routine ) || _.strsAreAll( o.routine ), () => 'Expects routine {-o.routine-}, but got ' + o.routine );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( o.select >= 1 || _.strIs( o.select ) || _.argumentsArray.like( o.select ), () => 'Expects {-o.select-} as number >= 1, string or array, but got ' + o.select );

  return o;
}

function vectorize_body( o )
{

  _.routine.assertOptions( vectorize_body, arguments );

  if( _.argumentsArray.like( o.routine ) && o.routine.length === 1 )
  o.routine = o.routine[ 0 ];

  let routine = o.routine;
  let propertyCondition = o.propertyCondition;
  let bypassingFilteredOut = o.bypassingFilteredOut;
  let bypassingEmpty = o.bypassingEmpty;
  let vectorizingArray = o.vectorizingArray;
  let vectorizingMapVals = o.vectorizingMapVals;
  let vectorizingMapKeys = o.vectorizingMapKeys;
  let vectorizingContainerAdapter = o.vectorizingContainerAdapter;
  let unwrapingContainerAdapter = o.unwrapingContainerAdapter;
  let head = null;
  let select = o.select === null ? 1 : o.select;
  let selectAll = o.select === Infinity;
  let multiply = select > 1 ? multiplyReally : multiplyNo;

  routine = routineNormalize( routine );

  _.assert( _.routine.is( routine ), () => 'Expects routine {-o.routine-}, but got ' + routine );

  /* */

  let resultRoutine = vectorizeArray;

  if( _.number.is( select ) )
  {

    if( !vectorizingArray && !vectorizingMapVals && !vectorizingMapKeys )
    resultRoutine = routine;
    else if( propertyCondition )
    resultRoutine = vectorizeWithFilters;
    else if( vectorizingMapKeys )
    {

      if( vectorizingMapVals )
      {
        _.assert( select === 1, 'Only single argument is allowed if {-o.vectorizingMapKeys-} and {-o.vectorizingMapVals-} are enabled.' );
        resultRoutine = vectorizeMapWithKeysOrArray;
      }
      else
      {
        resultRoutine = vectorizeKeysOrArray;
      }

    }
    else if( !vectorizingArray || vectorizingMapVals )
    resultRoutine = vectorizeMapOrArray;
    else if( multiply === multiplyNo )
    resultRoutine = vectorizeArray;
    else
    resultRoutine = vectorizeArrayMultiplying;

  }
  else
  {
    _.assert( multiply === multiplyNo );
    if( routine.head )
    {
      head = routine.head;
      routine = routine.body;
    }
    if( propertyCondition )
    {
      _.assert( 0, 'not implemented' );
    }
    else if( vectorizingArray || !vectorizingMapVals )
    {
      if( _.strIs( select ) )
      resultRoutine = vectorizeForOptionsMap;
      else
      resultRoutine = vectorizeForOptionsMapForKeys;
    }
    else _.assert( 0, 'not implemented' );
  }

  /* */

  resultRoutine.vectorized = o;

  /* */

  _.routine.extend( resultRoutine, routine );
  return resultRoutine;

  /*
    vectorizeWithFilters : multiply + array/map vectorizing + filter
    vectorizeArray : array vectorizing
    vectorizeArrayMultiplying :  multiply + array vectorizing
    vectorizeMapOrArray :  multiply +  array/map vectorizing
  */

  /* - */

  function routineNormalize( routine )
  {

    if( _.strIs( routine ) )
    {
      return function methodCall()
      {
        _.assert( _.routine.is( this[ routine ] ), () => 'Context ' + _.entity.exportStringDiagnosticShallow( this ) + ' does not have routine ' + routine );
        return this[ routine ].apply( this, arguments );
      }
    }
    else if( _.argumentsArray.like( routine ) )
    {
      _.assert( routine.length === 2 );
      return function methodCall()
      {
        let c = this[ routine[ 0 ] ];
        _.assert( _.routine.is( c[ routine[ 1 ] ] ), () => 'Context ' + _.entity.exportStringDiagnosticShallow( c ) + ' does not have routine ' + routine );
        return c[ routine[ 1 ] ].apply( c, arguments );
      }
    }

    return routine;
  }

  /* - */

  function multiplyNo( args )
  {
    return args;
  }

  /* - */

  function multiplyReally( args )
  {
    let length, keys;

    args = [ ... args ];

    if( selectAll )
    select = args.length;

    _.assert( args.length === select, () => 'Expects ' + select + ' arguments, but got ' + args.length );

    for( let d = 0 ; d < select ; d++ )
    {
      if( vectorizingArray && _.argumentsArray.like( args[ d ] ) )
      {
        length = args[ d ].length;
        break;
      }
      else if( vectorizingArray && _.set.like( args[ d ] ) )
      {
        length = args[ d ].size;
        break;
      }
      else if( vectorizingContainerAdapter && _.containerAdapter.is( args[ d ] ) )
      {
        length = args[ d ].length;
        break;
      }
      else if( vectorizingMapVals && _.aux.is( args[ d ] ) )
      {
        keys = _.props.onlyOwnKeys( args[ d ] );
        break;
      }
    }

    if( length !== undefined )
    {
      for( let d = 0 ; d < select ; d++ )
      {
        if( vectorizingMapVals )
        _.assert( !_.mapIs( args[ d ] ), () => 'Arguments should have only arrays or only maps, but not both. Incorrect argument : ' + args[ d ] );
        else if( vectorizingMapKeys && _.mapIs( args[ d ] ) )
        continue;
        args[ d ] = _.multiple( args[ d ], length );
      }

    }
    else if( keys !== undefined )
    {
      for( let d = 0 ; d < select ; d++ )
      if( _.mapIs( args[ d ] ) )
      {
        _.assert( _.arraySet.identical( _.props.onlyOwnKeys( args[ d ] ), keys ), () => 'Maps should have same keys : ' + keys );
      }
      else
      {
        if( vectorizingArray )
        _.assert( !_.argumentsArray.like( args[ d ] ), () => 'Arguments should have only arrays or only maps, but not both. Incorrect argument : ' + args[ d ] );
        let arg = Object.create( null );
        _.mapSetWithKeys( arg, keys, args[ d ] );
        args[ d ] = arg;
      }
    }

    return args;
  }

  /* - */

  function vectorizeArray()
  {
    if( bypassingEmpty && !arguments.length )
    return [];

    let args = arguments;
    let src = args[ 0 ];

    if( _.arrayIs( src ) ) /* Dmytro : arrayLike returns true for instances of containerAdapter */
    {
      let args2 = [ ... args ];
      let result = _.long.makeEmpty( src );
      let append = _.long.appender( result );
      let each = _.long.eacher( src );
      each( ( e ) =>
      {
        args2[ 0 ] = e;
        append( routine.apply( this, args2 ) );
      });
      return result;
    }
    else if( _.set.like( src ) ) /* qqq : cover please */
    {
      let args2 = [ ... args ];
      let result = new Set;
      for( let e of src )
      {
        args2[ 0 ] = e;
        result.add( routine.apply( this, args2 ) );
      }
      return result;
    }
    else if( vectorizingContainerAdapter && _.containerAdapter.is( src ) )
    {
      let args2 = [ ... args ];
      let result = src.filter( ( e ) =>
      {
        args2[ 0 ] = e;
        return routine.apply( this, args2 );
      });
      if( unwrapingContainerAdapter )
      return result.original;
      else
      return result;
    }

    return routine.apply( this, args );
  }

  /* - */

  function vectorizeArrayMultiplying()
  {
    if( bypassingEmpty && !arguments.length )
    return [];

    let args = multiply( arguments );
    let src = args[ 0 ];

    if( _.argumentsArray.like( src ) )
    {

      let args2 = [ ... args ];
      let result = _.long.makeEmpty( src );
      let append = _.long.appender( result );
      let each = _.long.eacher( src );
      each( ( e, r ) =>
      {
        for( let m = 0 ; m < select ; m++ )
        args2[ m ] = args[ m ][ r ]; /* zzz qqq : use _.long.get */
        append( routine.apply( this, args2 ) );
      });
      return result;
    }

    return routine.apply( this, args );
  }

  /* - */

  function vectorizeForOptionsMap( srcMap )
  {
    if( bypassingEmpty && !arguments.length )
    return [];

    let src = srcMap[ select ];
    let args = [ ... arguments ];
    _.assert( arguments.length === 1, 'Expects single argument' );

    if( _.argumentsArray.like( src ) )
    {
      if( head )
      {
        args = head( routine, args );
        _.assert( _.arrayLikeResizable( args ) );
      }

      let result = _.long.makeEmpty( src );
      let append = _.long.appender( result );
      let each = _.long.eacher( src );
      each( ( e ) =>
      {
        args[ 0 ] = _.props.extend( null, srcMap );
        args[ 0 ][ select ] = e;
        append( routine.apply( this, args ) );
      });
      return result;

    }
    else if( _.set.like( src ) ) /* qqq : cover */
    {
      if( head )
      {
        args = head( routine, args );
        _.assert( _.arrayLikeResizable( args ) );
      }
      let result = new Set;
      for( let e of src )
      {
        args[ 0 ] = _.props.extend( null, srcMap );
        args[ 0 ][ select ] = e;
        result.add( routine.apply( this, args ) );
      }
      return result;
    }
    else if( vectorizingContainerAdapter && _.containerAdapter.is( src ) ) /* qqq : cover */
    {
      if( head )
      {
        args = head( routine, args );
        _.assert( _.arrayLikeResizable( args ) );
      }
      result = src.filter( ( e ) =>
      {
        args[ 0 ] = _.props.extend( null, srcMap );
        args[ 0 ][ select ] = e;
        return routine.apply( this, args );
      });
      if( unwrapingContainerAdapter )
      return result.original;
      else
      return result;
    }

    return routine.apply( this, arguments );
  }

  /* - */

  function vectorizeForOptionsMapForKeys()
  {
    let result = [];

    if( bypassingEmpty && !arguments.length )
    return result;

    for( let i = 0; i < o.select.length; i++ )
    {
      select = o.select[ i ];
      result[ i ] = vectorizeForOptionsMap.apply( this, arguments );
    }
    return result;
  }

  /* - */

  function vectorizeMapOrArray()
  {
    if( bypassingEmpty && !arguments.length )
    return [];

    let args = multiply( arguments );
    let src = args[ 0 ];

    if( vectorizingArray && _.argumentsArray.like( src ) )
    {

      let args2 = [ ... args ];
      let result = _.long.makeEmpty( src );
      let append = _.long.appender( result );
      let each = _.long.eacher( src );
      each( ( e, r ) =>
      {

        for( let m = 0 ; m < select ; m++ )
        args2[ m ] = args[ m ][ r ]; /* qqq zzz : use _.long.get? */

        append( routine.apply( this, args2 ) );
      });
      return result;
    }
    else if( vectorizingMapVals && _.mapIs( src ) )
    {
      let args2 = [ ... args ];
      let result = Object.create( null );
      for( let r in src )
      {
        for( let m = 0 ; m < select ; m++ )
        args2[ m ] = args[ m ][ r ];

        result[ r ] = routine.apply( this, args2 );
      }
      return result;
    }

    return routine.apply( this, arguments );
  }

  /* - */

  function vectorizeMapWithKeysOrArray()
  {
    if( bypassingEmpty && !arguments.length )
    return [];

    let args = multiply( arguments );
    let srcs = args[ 0 ];

    _.assert( args.length === select, () => 'Expects ' + select + ' arguments but got : ' + args.length );

    if( vectorizingMapKeys && vectorizingMapVals &&_.mapIs( srcs ) )
    {
      let result = Object.create( null );
      for( let s in srcs )
      {
        let val = routine.call( this, srcs[ s ] );
        let key = routine.call( this, s );
        result[ key ] = val;
      }
      return result;
    }
    else if( vectorizingArray && _.argumentsArray.like( srcs ) )
    {
      let result = [];
      for( let s = 0 ; s < srcs.length ; s++ )
      result[ s ] = routine.call( this, srcs[ s ] );
      return result;
    }

    return routine.apply( this, arguments );
  }

  /* - */

  function vectorizeWithFilters( src )
  {

    _.assert( 0, 'not tested' ); /* qqq : cover please */
    _.assert( arguments.length === 1, 'Expects single argument' );

    let args = multiply( arguments );

    if( vectorizingArray && _.argumentsArray.like( src ) )
    {
      args = [ ... args ];
      throw _.err( 'not tested' ); /* cover please */

      let result = _.long.makeEmpty( src );
      let append = _.long.appender( result );
      let each = _.long.eacher( src );
      each( ( e, r ) =>
      {
        if( propertyCondition( e, r, src ) )
        {
          args[ 0 ] = e;
          append( routine.apply( this, args ) );
        }
        else if( bypassingFilteredOut )
        {
          append( e );
        }

        args2[ 0 ] = e;
        append( routine.apply( this, args2 ) );
      });
      return result;

    }
    else if( vectorizingMapVals && _.mapIs( src ) )
    {
      args = [ ... args ];
      let result = Object.create( null );
      throw _.err( 'not tested' ); /* qqq : cover please */
      for( let r in src )
      {
        if( propertyCondition( src[ r ], r, src ) )
        {
          args[ 0 ] = src[ r ];
          result[ r ] = routine.apply( this, args );
        }
        else if( bypassingFilteredOut )
        {
          result[ r ] = src[ r ];
        }
      }
      return result;
    }

    return routine.call( this, src );
  }

  /* - */

  function vectorizeKeysOrArray()
  {
    if( bypassingEmpty && !arguments.length )
    return [];

    // let args = multiply( _.originalsFromAdaptersInplace( arguments ) );
    let args = multiply( arguments );
    let src = args[ 0 ];
    let args2, result, map, mapIndex, arr;

    _.assert( args.length === select, () => 'Expects ' + select + ' arguments but got : ' + args.length );

    if( vectorizingMapKeys )
    {
      for( let d = 0; d < select; d++ )
      {
        if( vectorizingArray && _.argumentsArray.like( args[ d ] ) )
        arr = args[ d ];
        else if( _.mapIs( args[ d ] ) )
        {
          _.assert( map === undefined, () => 'Arguments should have only single map. Incorrect argument : ' + args[ d ] );
          map = args[ d ];
          mapIndex = d;
        }
      }
    }

    if( map )
    {
      result = Object.create( null );
      args2 = [ ... args ];

      if( vectorizingArray && _.argumentsArray.like( arr ) )
      {
        for( let i = 0; i < arr.length; i++ )
        {
          for( let m = 0 ; m < select ; m++ )
          args2[ m ] = args[ m ][ i ];

          for( let k in map )
          {
            args2[ mapIndex ] = k;
            let key = routine.apply( this, args2 );
            result[ key ] = map[ k ];
          }
        }
      }
      else
      {
        for( let k in map )
        {
          args2[ mapIndex ] = k;
          let key = routine.apply( this, args2 );
          result[ key ] = map[ k ];
        }
      }

      return result;
    }
    else if( vectorizingArray && _.argumentsArray.like( src ) )
    {

      let args2 = [ ... args ];
      let result = _.long.makeEmpty( src );
      let append = _.long.appender( result );
      let each = _.long.eacher( src );
      each( ( e, r ) =>
      {
        for( let m = 0 ; m < select ; m++ )
        args2[ m ] = args[ m ][ r ]; /* qqq zzz : use _.long.get */
        append( routine.apply( this, args2 ) );
      });
      return result;

    }

    return routine.apply( this, arguments );
  }

}

/* qqq : implement options combination vectorizingMapVals : 1, vectorizingMapKeys : 1, vectorizingArray : [ 0, 1 ] */
/* qqq : cover it */

/* qqq : implement bypassingEmpty for all combinations of options */
/* qqq : options bypassingEmpty of routine _.vectorize requires good coverage */

vectorize_body.defaults =
{
  routine : null,
  propertyCondition : null,
  bypassingFilteredOut : 1,
  bypassingEmpty : 0,
  vectorizingArray : 1, /* qqq2 : for Dmytro : add option vectorizingCountable : 1. discuss */
  vectorizingMapVals : 0,
  vectorizingMapKeys : 0,
  vectorizingContainerAdapter : 0,
  unwrapingContainerAdapter : 0,
  select : 1,
}

//

function vectorize()
{
  let o = vectorize.head.call( this, vectorize, arguments );
  let result = vectorize.body.call( this, o );
  return result;
}

vectorize.head = vectorize_head;
vectorize.body = vectorize_body;
vectorize.defaults = { ... vectorize_body.defaults };

//

function vectorizeAll_body( o )
{
  _.routine.assertOptions( vectorize, arguments );

  let routine1 = _.vectorize.body.call( this, o );

  _.routine.extend( all, o.routine );

  return all;

  function all()
  {
    let result = routine1.apply( this, arguments );
    return _.all( result );
  }

}

vectorizeAll_body.defaults = { ... vectorize_body.defaults };

//

function vectorizeAll()
{
  let o = vectorizeAll.head.call( this, vectorizeAll, arguments );
  let result = vectorizeAll.body.call( this, o );
  return result;
}

vectorizeAll.head = vectorize_head;
vectorizeAll.body = vectorizeAll_body;
vectorizeAll.defaults = { ... vectorizeAll_body.defaults };

//

function vectorizeAny_body( o )
{
  _.routine.assertOptions( vectorize, arguments );

  let routine1 = _.vectorize.body.call( this, o );
  _.routine.extend( any, o.routine );

  return any;

  function any()
  {
    let result = routine1.apply( this, arguments );
    return !!_.any( result );
  }

}

vectorizeAny_body.defaults = { ... vectorize_body.defaults };

//

function vectorizeAny()
{
  let o = vectorizeAny.head.call( this, vectorizeAny, arguments );
  let result = vectorizeAny.body.call( this, o );
  return result;
}

vectorizeAny.head = vectorize_head;
vectorizeAny.body = vectorizeAny_body;
vectorizeAny.defaults = { ... vectorizeAny_body.defaults };

//

function vectorizeNone_body( o )
{
  _.routine.assertOptions( vectorize, arguments );

  let routine1 = _.vectorize.body.call( this, o );
  _.routine.extend( none, o.routine );

  return none;

  function none()
  {
    let result = routine1.apply( this, arguments );
    return _.none( result );
  }

}

vectorizeNone_body.defaults = { ... vectorize_body.defaults };

//

function vectorizeNone()
{
  let o = vectorizeNone.head.call( this, vectorizeNone, arguments );
  let result = vectorizeNone.body.call( this, o );
  return result;
}

vectorizeNone.head = vectorize_head;
vectorizeNone.body = vectorizeNone_body;
vectorizeNone.defaults = { ... vectorizeNone_body.defaults };

//

/**
 * The routine vectorizeAccess() creates proxy object for each element of passed vector {-vector-}.
 * Proxy object provides access to existed properties of {-vector-} elements uses only get()
 * and set() handlers.
 * If get() handler is used, then routine returns new proxy object with vector of property values.
 * If a property is a routine, then its routines can be applied to a set of arguments. The result is
 * a new proxy with vector of returned values.
 * To get original vector uses property `$`.
 * If set() handler is used, then property of each proxy element is assigned to one value.
 *
 * @param { Long } vector - The vector of objects and vectors to get proxy access to properties.
 *
 * @example
 * let obj1 = { a : 1, b : 2, c : 3 };
 * let obj2 = { a : 5, b : 6 };
 * let vector = _.vectorizeAccess( [ obj1, obj2 ] );
 * console.log( vector );
 * // log Proxy [
 * //       [ { a : 1, b : 2, c : 3 }, { a : 5, b : 6 } ],
 * //       { get: [Function: get], set: [Function: set] }
 * //     ]
 * console.log( vector[ '$' ] );
 * // log [ { a : 1, b : 2, c : 3 }, { a : 5, b : 6 } ]
 * let vectorA = vector.a; // or vector[ 'a' ]
 * console.log( vectorA );
 * // log Proxy [ [ 1, 5 ], { get: [Function: get], set: [Function: set] } ]
 *
 * @example
 * let cb1 = ( e ) => Math.pow( e, 2 );
 * let cb2 = ( e ) => Math.sqrt( e, 2 );
 * let obj1 = { callback : cb1, name : 'obj1' };
 * let obj2 = { callback : cb2, name : 'obj2' };
 * let vector = _.vectorizeAccess( [ obj1, obj2 ] );
 * let result = vector.callback( 4 );
 * console.log( result );
 * // log Proxy [ [ 16, 2 ], { get: [Function: get], set: [Function: set] } ]
 *
 * @example
 * let v1 = [ 1, 2, 3 ];
 * let v2 = [ 5, 6 ];
 * let vector = _.vectorizeAccess( [ v1, v2 ] );
 * vector[ 1 ] = 10;
 * console.log( vector[ '$' ] );
 * // log [ [ 1, 10, 3 ], [ 5, 10 ] ]
 *
 * @returns { Proxy } - Proxy object, which provides access to existed properties in elements of vector.
 * @function vectorizeAccess
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If {-vector-} is not a Long.
 * @namespace Tools
 */

function vectorizeAccess( vector )
{

  _.assert( _.longIs( vector ) );
  _.assert( arguments.length === 1 );

  let handler =
  {
    get,
    set,
  };

  let proxy = new Proxy( vector, handler );

  return proxy;

  /* */

  function set( /* back, key, val, context */ )
  {
    let back = arguments[ 0 ];
    let key = arguments[ 1 ];
    let val = arguments[ 2 ];
    let context = arguments[ 3 ];

    vector.map( ( scalar ) =>
    {
      _.assert( scalar[ key ] !== undefined, `One or several element(s) of vector does not have ${key}` );
    });

    vector.map( ( scalar ) =>
    {
      scalar[ key ] = val;
    });

    return true;
  }

  /* */

  function get( back, key, context )
  {
    if( key === '$' )
    {
      return vector;
    }

    let routineIs = vector.some( ( scalar ) => _.routine.is( scalar[ key ] ) );

    if( !routineIs )
    if( _.all( vector, ( scalar ) => scalar[ key ] === undefined ) )
    return;

    vector.map( ( scalar ) =>
    {
      _.assert( scalar[ key ] !== undefined, `One or several element(s) of vector does not have ${String( key )}` );
    });

    if( routineIs )
    return function()
    {
      let self = this;
      let args = arguments;
      let revectorizing = false;
      let result = vector.map( ( scalar ) =>
      {
        let r = scalar[ key ].apply( scalar, args );
        if( r !== scalar )
        revectorizing = true;
        return r; // Dmytro : it returns result in vector, if it not exists, then result has only undefined => [ undefined, undefined, undefined ]
      });
      if( revectorizing )
      {
        return vectorizeAccess( result );
      }
      else
      {
        return proxy;
      }
    }

    let result = vector.map( ( scalar ) =>
    {
      return scalar[ key ];
    });

    return vectorizeAccess( result );
  }

}

// --
// implementation
// --

let ToolsExtension =
{

  routineVectorize_functor : vectorize,
  vectorize,
  vectorizeAll,
  vectorizeAny,
  vectorizeNone,

  vectorizeAccess,

}

Object.assign( _, ToolsExtension );

//

let FunctorExtension =
{

  vectorize,
  vectorizeAll,
  vectorizeAny,
  vectorizeNone,

  vectorizeAccess,

}

Object.assign( _.functor, FunctorExtension );

})();

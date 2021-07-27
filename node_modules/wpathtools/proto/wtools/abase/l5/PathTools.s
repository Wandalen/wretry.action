( function _PathTools_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to operate paths reliably and consistently. Implements routines for manipulating paths maps and globing. Extends module PathBasic.
  @module Tools/base/Path
*/

/**
 *  */

/**
 * @summary Collection of cross-platform routines to operate paths reliably and consistently.
 * @namespace wTools.path
 * @module Tools/PathTools
 */

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );
  _.include( 'wPathBasic' );
  _.include( 'wStringsExtra' );

}

//

const _global = _global_;
const _ = _global_.wTools;
_.path = _.path || Object.create( null );
_.path.map = _.path.map || Object.create( null );

// --
// path map
// --

function _filterPairs( o )
{
  let self = this;
  let result = Object.create( null );
  let hasDst = false;
  let hasSrc = false;
  let it = Object.create( null );
  it.src = '';
  it.dst = '';

  _.routine.options_( _filterPairs, o );
  _.assert( arguments.length === 1 );
  _.routineIs( o.onEach );

  if( o.filePath === null )
  {
    o.filePath = '';
  }
  if( _.strIs( o.filePath ) )
  {
    if( o.isSrc )
    it.src = o.filePath;
    else
    it.dst = o.filePath;

    let r = o.onEach( it );
    elementsWrite( result, it, r );
  }
  else if( _.arrayIs( o.filePath ) )
  {
    if( o.isSrc )
    {
      for( let p = 0 ; p < o.filePath.length ; p++ )
      {
        if( !_.boolIs( o.filePath[ p ] ) )
        {
          it.src = o.filePath[ p ] === null ? '' : o.filePath[ p ];
          let r = o.onEach( it );
          elementsWrite( result, it, r );
        }
      }
    }
    else
    {
      for( let p = 0 ; p < o.filePath.length ; p++ )
      {
        if( !_.boolIs( o.filePath[ p ] ) )
        {
          it.src = '';
          it.dst = o.filePath[ p ] === null ? '' : o.filePath[ p ];
          let r = o.onEach( it );
          elementsWrite( result, it, r );
        }
      }
    }
  }
  else if( _.mapIs( o.filePath ) )
  {
    for( let src in o.filePath )
    {
      let dst = o.filePath[ src ];
      if( _.arrayIs( dst ) )
      {
        if( dst.length === 0 )
        {
          it.src = src;
          it.dst = '';
          let r = o.onEach( it );
          elementsWrite( result, it, r );
        }
        else
        {
          for( let d = 0 ; d < dst.length ; d++ )
          {
            it.src = src;
            it.dst = dst[ d ] === null ? '' : dst[ d ];
            let r = o.onEach( it );
            elementsWrite( result, it, r );
          }
        }
      }
      else
      {
        it.src = src;
        it.dst = dst === null ? '' : dst;
        let r = o.onEach( it );
        elementsWrite( result, it, r );
      }
    }
  }
  else _.assert( 0 );

  return end();

  /* */

  function elementsWrite( result, it, elements )
  {

    if( elements === it )
    {
      _.assert( it.dst === null || _.strIs( it.dst ) || _.arrayIs( it.dst ) || _.boolLike( it.dst ) );
      elements = Object.create( null );
      if( _.arrayIs( it.src ) )
      {
        for( let s = 0 ; s < it.src.length ; s++ )
        put( elements, it.src[ s ], it.dst );
      }
      else
      {
        _.assert( it.src === null || _.strIs( it.src ) );
        put( elements, it.src, it.dst );
      }
    }

    if( _.arrayIs( elements ) )
    {
      elements.forEach( ( r ) => elementsWrite( result, it, r ) );
      return result;
    }
    else if( elements === undefined )
    {
      return result;
    }
    else if( elements === null || elements === '' )
    {
      return elementWrite( result, '', '' );
    }
    else if( _.strIs( elements ) )
    {
      return elementWrite( result, elements, it.dst );
    }
    // else if( _.arrayIs( elements ) )
    // {
    //   elements.forEach( ( src ) => elementWrite( result, src, it.dst ) );
    //   return result;
    // }
    else if( _.mapIs( elements ) )
    {
      for( let src in elements )
      {
        let dst = elements[ src ];
        elementWrite( result, src, dst );
      }
      return result;
    }

    _.assert( 0 );
  }

  /* */

  function put( container, src, dst )
  {
    if( src === null )
    src = '';
    if( dst === null )
    dst = '';
    _.assert( container[ src ] === undefined || container[ src ] === dst );
    _.assert( _.strIs( src ) );
    // _.assert( _.strIs( dst ) || _.arrayIs( dst ) || _.boolLike( dst ) ); // Dmytro : has no sense, this assertions checks above
    container[ src ] = dst;
  }

  /* */

  function elementWrite( result, src, dst )
  {
    if( _.arrayIs( dst ) )
    {
      if( dst.length )
      dst.forEach( ( dst ) => elementWriteSingle( result, src, dst ) );
      else
      elementWriteSingle( result, src, '' );

      return result;
    }
    else
    {
      elementWriteSingle( result, src, dst );
      return result;
    }
  }

  /* */

  function elementWriteSingle( result, src, dst )
  {
    if( dst === null )
    dst = '';
    if( src === null )
    src = '';

    _.assert( _.strIs( src ) );
    _.assert( _.strIs( dst ) || _.boolLike( dst ) || _.instanceIs( dst ) );


    if( _.boolLike( dst ) )
    {
      dst = !!dst;
    }

    if( _.boolLike( result[ src ] ) )
    {
      if( dst !== '' )
      result[ src ] = dst;
    }
    else if( _.arrayIs( result[ src ] ) )
    {
      if( dst !== '' && !_.boolLike( dst ) )
      result[ src ] = _.scalarAppendOnce( result[ src ], dst );
    }
    else if( _.strIs( result[ src ] ) || _.instanceIs( result[ src ] ) )
    {
      if( result[ src ] === '' || result[ src ] === dst || dst === false )
      result[ src ] = dst;
      else if( result[ src ] !== '' && dst !== '' )
      {
        if( dst !== true )
        result[ src ] = _.scalarAppendOnce( result[ src ], dst );
      }
    }
    else
    {
      result[ src ] = dst;
    }

    if( src )
    hasSrc = true;
    if( dst !== '' )
    hasDst = true;

    return result;
  }

  /* */

  function end()
  {
    let r;

    if( result[ '' ] === '' )
    delete result[ '' ];

    if( !hasSrc )
    {
      if( !hasDst )
      return '';
      else if( !o.isSrc && !_.mapIs( o.filePath ) )
        return _.props.vals( result )[ 0 ];
      return result;
    }
    else if( !hasDst )
    {
      r = _.props.keys( result );
    }
    else if( !o.isSrc && !_.mapIs( o.filePath ) )
    {
      let keys = _.props.keys( result );
      if( keys.length === 1 && keys[ 0 ] === '' )
      return result[ '' ];
      return result;
    }
    else
    {
      return result;
    }

    if( r.length === 1 )
    r = r[ 0 ]
    else if( r.length === 0 )
      r = '';

    _.assert( _.strIs( r ) || _.arrayIs( r ) )
    return r;
  }

}
_filterPairs.defaults =
{
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

function filterPairs( filePath, onEach )
{

  _.assert( arguments.length === 2 )

  return this._filterPairs
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterSrcPairs( filePath, onEach )
{

  _.assert( arguments.length === 2 )

  return this._filterPairs
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterDstPairs( filePath, onEach )
{

  _.assert( arguments.length === 2 )

  return this._filterPairs
  ({
    filePath,
    onEach,
    isSrc : false,
  });
}

// function filterPairs( filePath, onEach )
// {
//   let result = Object.create( null );
//   let hasDst = false;
//   let hasSrc = false;
//   let it = Object.create( null );
//   it.src = '';
//   it.dst = '';
//
//   _.assert( arguments.length === 2 );
//   _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
//   _.routineIs( onEach );
//
//   if( filePath === null || filePath === '' )
//   {
//     let r = onEach( it );
//     elementsWrite( result, it, r );
//   }
//   else if( _.strIs( filePath ) )
//   {
//     it.src = filePath;
//     let r = onEach( it );
//     elementsWrite( result, it, r );
//   }
//   else if( _.arrayIs( filePath ) )
//   {
//     for( let p = 0 ; p < filePath.length ; p++ )
//     {
//       it.src = filePath[ p ];
//       if( filePath[ p ] === null )
//       it.src = '';
//       if( _.boolIs( filePath[ p ] ) )
//       {
//       }
//       else
//       {
//         let r = onEach( it );
//         elementsWrite( result, it, r );
//       }
//     }
//   }
//   else if( _.mapIs( filePath ) )
//   {
//     for( let src in filePath )
//     {
//       let dst = filePath[ src ];
//       if( _.arrayIs( dst ) )
//       {
//         if( !dst.length )
//         {
//           it.src = src;
//           it.dst = '';
//           let r = onEach( it );
//           elementsWrite( result, it, r );
//         }
//         else
//         for( let d = 0 ; d < dst.length ; d++ )
//         {
//           it.src = src;
//           it.dst = dst[ d ];
//           if( it.dst === null )
//           it.dst = '';
//           let r = onEach( it );
//           elementsWrite( result, it, r );
//         }
//       }
//       else
//       {
//         it.src = src;
//         it.dst = dst;
//         if( it.dst === null )
//         it.dst = '';
//         let r = onEach( it );
//         elementsWrite( result, it, r );
//       }
//     }
//   }
//   else _.assert( 0 );
//
//   return end();
//
//   /* */
//
//   function elementsWrite( result, it, elements )
//   {
//
//     if( _.arrayIs( elements ) )
//     {
//       elements.forEach( ( r ) => elementsWrite( result, it, r ) );
//       return result;
//     }
//
//     _.assert( elements === undefined || elements === null || _.strIs( elements ) || _.arrayIs( elements ) || _.mapIs( elements ) );
//
//     if( elements === undefined )
//     return result;
//
//     if( elements === null || elements === '' )
//     return elementWrite( result, '', '' );
//
//     if( _.strIs( elements ) )
//     return elementWrite( result, elements, it.dst );
//
//     if( _.arrayIs( elements ) )
//     {
//       elements.forEach( ( src ) => elementWrite( result, src, it.dst ) );
//       return result;
//     }
//
//     if( _.mapIs( elements ) )
//     {
//       for( let src in elements )
//       {
//         let dst = elements[ src ];
//         elementWrite( result, src, dst );
//       }
//       return result;
//     }
//
//     _.assert( 0 );
//   }
//
//   /* */
//
//   function elementWrite( result, src, dst )
//   {
//     if( _.arrayIs( dst ) )
//     {
//       if( dst.length )
//       dst.forEach( ( dst ) => elementWriteSingle( result, src, dst ) );
//       else
//       elementWriteSingle( result, src, '' );
//       return result;
//     }
//     elementWriteSingle( result, src, dst );
//     return result;
//   }
//
//   /* */
//
//   function elementWriteSingle( result, src, dst )
//   {
//     if( dst === null )
//     dst = '';
//     if( src === null )
//     src = '';
//
//     _.assert( _.strIs( src ) );
//     _.assert( _.strIs( dst ) || _.boolLike( dst ) || _.instanceIs( dst ) );
//
//
//     if( _.boolLike( dst ) )
//     dst = !!dst;
//
//     if( _.boolLike( result[ src ] ) )
//     {
//       if( dst !== '' )
//       result[ src ] = dst;
//     }
//     else if( _.arrayIs( result[ src ] ) )
//     {
//       if( dst !== '' && !_.boolLike( dst ) )
//       result[ src ] =  _.scalarAppendOnce( result[ src ], dst );
//     }
//     else if( _.strIs( result[ src ] ) || _.instanceIs( result[ src ] ) )
//     {
//       if( result[ src ] === '' || result[ src ] === dst || dst === false )
//       result[ src ] = dst;
//       else if( result[ src ] !== '' && dst !== '' )
//       {
//         if( dst !== true )
//         result[ src ] =  _.scalarAppendOnce( result[ src ], dst );
//       }
//     }
//     else
//     result[ src ] = dst;
//
//     // result[ src ] = _.scalarAppendOnce( result[ src ], dst );
//
//     if( src )
//     hasSrc = true;
//
//     if( dst !== '' )
//     hasDst = true;
//
//     return result;
//   }
//
//   /* */
//
//   function end()
//   {
//     let r;
//
//     if( result[ '' ] === '' )
//     delete result[ '' ];
//
//     if( !hasSrc )
//     {
//       if( !hasDst )
//       return '';
//       return result;
//     }
//     else if( !hasDst )
//     {
//       r = _.props.keys( result );
//     }
//     else
//     return result;
//
//     if( _.arrayIs( r ) )
//     {
//       if( r.length === 1 )
//       r = r[ 0 ]
//       else if( r.length === 0 )
//       r = '';
//     }
//
//     _.assert( _.strIs( r ) || _.arrayIs( r ) )
//     return r;
//   }
//
// }

//

// function _filterPairsInplace( filePath, onEach )
function _filterPairsInplace( o )
{
  let result = Object.create( null );
  let hasDst = false;
  let hasSrc = false;
  let it = Object.create( null );
  it.src = '';
  it.dst = '';

  _.routine.options_( _filterPairsInplace, arguments );
  _.assert( arguments.length === 1 );
  _.routineIs( o.onEach );

  if( o.filePath === null )
  {
    o.filePath = '';
  }
  if( _.strIs( o.filePath ) )
  {

    if( o.isSrc )
    it.src = o.filePath;
    else
    it.dst = o.filePath;

    let r = o.onEach( it );
    elementsWrite( result, it, r );

    o.filePath = result;

    let keys = _.props.keys( o.filePath );
    if( o.isSrc )
    {
      let vals = _.props.vals( o.filePath );
      if( vals.length === 1 && ( vals[ 0 ] === '' || vals[ 0 ] === null ) )
      return keys[ 0 ];
      else if( vals.length === 0 )
        return '';
    }
    else
    {
      if( keys.length === 1 && keys[ 0 ] === '' )
      return o.filePath[ '' ];
      else if( keys.length === 0 )
        return '';
    }

  }
  else if( _.arrayIs( o.filePath ) )
  {

    if( o.isSrc )
    {
      let filePath2 = _.arrayAppendArraysOnce( [], o.filePath );
      o.filePath.splice( 0, o.filePath.length );

      for( let p = 0 ; p < filePath2.length ; p++ )
      {
        if( !_.boolIs( filePath2[ p ] ) )
        {
          it.src = filePath2[ p ] === null ? '' : filePath2[ p ];
          let r = o.onEach( it );
          elementsWrite( result, it, r );
        }
      }
      _.arrayAppendArrayOnce( o.filePath, normalizeArray( _.props.keys( result ) ) );
    }
    else
    {
      for( let p = 0; p < o.filePath.length; p++ )
      {
        if( !_.boolIs( o.filePath[ p ] ) )
        {
          it.src = '';
          it.dst = o.filePath[ p ] === null ? '' : o.filePath[ p ];
          let r = o.onEach( it );
          elementsWrite( result, it, r );
        }
      }

      let keys = _.props.keys( result );
      if( keys.length === 1 && keys[ 0 ] === '' )
      {
        o.filePath.splice( 0, o.filePath.length );
        if( _.arrayIs( result[ '' ] ) )
        _.arrayAppendArrayOnce( o.filePath, result[ '' ] );
        else
        _.arrayAppendOnce( o.filePath, result[ '' ] );

        normalizeArray( o.filePath );
      }
      else if( keys.length === 0 )
      {
        o.filePath.splice( 0, o.filePath.length );
      }
      else
      {
        o.filePath = result;
      }
    }

  }
  else if( _.mapIs( o.filePath ) )
  {

    for( let src in o.filePath )
    {
      let dst = o.filePath[ src ];

      delete o.filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        if( dst.length === 0 )
        {
          it.src = src;
          it.dst = '';
          let r = o.onEach( it );
          elementsWrite( o.filePath, it, r );
        }
        else
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ] === null ? '' : dst[ d ];
          let r = o.onEach( it );
          elementsWrite( o.filePath, it, r );
        }
      }
      else
      {
        it.src = src;
        it.dst = dst === null ? '' : dst;
        let r = o.onEach( it );
        elementsWrite( o.filePath, it, r );
      }
    }

  }
  else _.assert( 0 );

  if( _.mapIs( o.filePath ) )
  {
    if( o.filePath[ '' ] === '' )
    delete o.filePath[ '' ];
  }

  return o.filePath;

  /* */

  function elementsWrite( filePath, it, elements )
  {

    if( elements === it )
    {
      _.assert( it.dst === null || _.strIs( it.dst ) || _.arrayIs( it.dst ) || _.boolLike( it.dst ) );
      elements = Object.create( null );
      if( _.arrayIs( it.src ) )
      {
        for( let s = 0 ; s < it.src.length ; s++ )
        put( elements, it.src[ s ], it.dst );
      }
      else
      {
        _.assert( it.src === null || _.strIs( it.src ) );
        put( elements, it.src, it.dst );
      }
    }

    if( elements === undefined )
    {
      return filePath;
    }
    else if( elements === null || elements === '' )
    {
      return elementWrite( filePath, '', '' );
    }
    else if( _.strIs( elements ) )
    {
      if( o.isSrc )
      return elementWrite( filePath, elements, it.dst );
      else
      return elementWrite( filePath, it.src, elements );
    }
    else if( _.arrayIs( elements ) )
    {
      if( elements.length === 0 )
      return elementWrite( filePath, '', '' );
      elements.forEach( ( r ) => elementsWrite( filePath, it, r ) );
      return filePath;
    }
    else if( _.mapIs( elements ) )
    {
      for( let src in elements )
      {
        let dst = elements[ src ];
        elementWrite( filePath, src, dst );
      }
      return filePath;
    }

    _.assert( 0 );
  }

  /* */

  function put( container, src, dst )
  {
    if( src === null )
    src = '';
    if( dst === null )
    dst = '';
    _.assert( container[ src ] === undefined || container[ src ] === dst );
    _.assert( _.strIs( src ) );
    // _.assert( _.strIs( dst ) || _.arrayIs( dst ) || _.boolLike( dst ) );
    // Dmytro : it has no sense, this assertions check dst above
    container[ src ] = dst;
  }

  /* */

  function elementWrite( filePath, src, dst )
  {
    if( _.arrayIs( dst ) )
    {
      if( dst.length )
      dst.forEach( ( dst ) => elementWriteSingle( filePath, src, dst ) );
      else
      elementWriteSingle( filePath, src, '' );

      return filePath;
    }
    else
    {
      elementWriteSingle( filePath, src, dst );
      return filePath;
    }
  }

  /* */

  function elementWriteSingle( filePath, src, dst )
  {
    if( dst === null )
    dst = '';
    if( src === null )
    src = '';

    _.assert( _.strIs( src ) );
    _.assert( _.strIs( dst ) || _.boolLike( dst ) || _.instanceIs( dst ) );

    if( _.boolLike( dst ) )
    {
      dst = !!dst;
    }

    if( _.boolLike( filePath[ src ] ) )
    {
      if( dst !== '' )
      filePath[ src ] = dst;
    }
    else if( _.arrayIs( filePath[ src ] ) )
    {
      if( dst !== '' && !_.boolLike( dst ) )
      filePath[ src ] = _.scalarAppendOnce( filePath[ src ], dst );
    }
    else if( _.strIs( filePath[ src ] ) || _.instanceIs( filePath[ src ] ) )
    {
      if( filePath[ src ] === '' || filePath[ src ] === dst || dst === false )
      filePath[ src ] = dst;
      else if( filePath[ src ] !== '' && dst !== '' )
      {
        if( dst !== true )
        filePath[ src ] = _.scalarAppendOnce( filePath[ src ], dst );
      }
    }
    else
    {
      filePath[ src ] = dst;
    }

    return filePath;
  }

  /* */

  function normalizeArray( src )
  {
    return _.arrayRemoveElement( src, '' );
  }

}

_filterPairsInplace.defaults =
{
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

function filterPairsInplace( filePath, onEach )
{
  _.assert( arguments.length === 2 );

  return this._filterPairsInplace
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterSrcPairsInplace( filePath, onEach )
{
  _.assert( arguments.length === 2 );

  return this._filterPairsInplace
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterDstPairsInplace( filePath, onEach )
{
  _.assert( arguments.length === 2 );

  return this._filterPairsInplace
  ({
    filePath,
    onEach,
    isSrc : false,
  });
}

//

function filterPairs_head( routine, args )
{
  _.assert( arguments.length === 2 );

  let o = Object.create( null );
  if( args.length === 1 )
  {
    _.assert( _.mapIs( args[ 0 ] ) );
    o = args[ 0 ];
  }
  else
  {
    if( args.length === 3 )
    {
      o.onEach = args[ 2 ];
      o.filePath = args[ 1 ];

      if( args[ 0 ] === null )
      o.dst = true;
      else if( args[ 0 ] === o.filePath )
        o.dst = false;
      else if( _.arrayIs( args[ 0 ] ) || _.mapIs( args[ 0 ] ) )
        o.dst = args[ 0 ];
      else
        _.assert( 0 );
    }
    else if( args.length === 2 )
    {
      o.onEach = args[ 1 ];
      o.filePath = args[ 0 ];
      o.dst = false;
    }
    else
      _.assert( 0 );
  }

  _.routine.options_( routine, o );
  _.routineIs( o.onEach, '{-onEach-} should be a routine' );

  return o;
}

//

function filterPairs_body( o )
{
  let self = this;
  let result = Object.create( null );
  let hasDst = false;
  let hasSrc = false;
  let it = Object.create( null );
  it.src = '';
  it.dst = '';

  if( o.filePath === null )
  {
    o.filePath = '';
  }
  if( _.strIs( o.filePath ) )
  {

    if( o.isSrc )
    it.src = o.filePath;
    else
    it.dst = o.filePath;

    let r = o.onEach( it );
    elementsWrite( result, it, r );

  }
  else if( _.arrayIs( o.filePath ) )
  {

    if( o.isSrc )
    {
      for( let p = 0; p < o.filePath.length; p++ )
      {
        it.src = o.filePath[ p ] === null ? '' : o.filePath[ p ];
        it.dst = '';

        if( !_.boolIs( o.filePath[ p ] ) )
        {
          let r = o.onEach( it );
          elementsWrite( result, it, r );
        }
      }
    }
    else
    {
      for( let p = 0; p < o.filePath.length; p++ )
      {
        it.src = '';
        it.dst = o.filePath[ p ] === null ? '' : o.filePath[ p ];

        if( !_.boolIs( o.filePath[ p ] ) )
        {
          let r = o.onEach( it );
          elementsWrite( result, it, r );
        }
      }
    }

  }
  else if( _.mapIs( o.filePath ) )
  {
    for( let src in o.filePath )
    {
      let dst1 = o.filePath[ src ];

      if( _.arrayIs( dst1 ) )
      {
        if( dst1.length === 0 )
        {
          it.src = src;
          it.dst = '';
          let r = o.onEach( it );
          elementsWrite( result, it, r );
        }
        else
        for( let d = 0 ; d < dst1.length ; d++ )
        {
          it.src = src;
          it.dst = dst1[ d ] === null ? '' : dst1[ d ];
          let r = o.onEach( it );
          elementsWrite( result, it, r );
        }
      }
      else
      {
        it.src = src;
        it.dst = dst1 === null ? '' : dst1;
        let r = o.onEach( it );
        elementsWrite( result, it, r );
      }
    }
  }
  else
  {
    _.assert( 0 );
  }

  return end();

  /* */

  function elementsWrite( filePath, it, elements )
  {

    if( elements === it )
    {
      _.assert( it.dst === null || _.strIs( it.dst ) || _.arrayIs( it.dst ) || _.boolLike( it.dst ) );
      elements = Object.create( null );
      if( _.arrayIs( it.src ) )
      {
        for( let s = 0 ; s < it.src.length ; s++ )
        put( elements, it.src[ s ], it.dst );
      }
      else
      {
        _.assert( it.src === null || _.strIs( it.src ) );
        put( elements, it.src, it.dst );
      }
    }

    if( elements === undefined )
    {
      return filePath;
    }
    else if( elements === null || elements === '' )
    {
      return elementWrite( filePath, '', '' );
    }
    else if( _.strIs( elements ) )
    {
      return elementWrite( filePath, elements, it.dst );
    }
    else if( _.arrayIs( elements ) )
    {
      if( elements.length === 0 )
      return elementWrite( filePath, '', '' );

      for( let i = 0; i < elements.length; i++ )
      elementsWrite( filePath, it, elements[ i ] );
      return filePath;
    }
    else if( _.mapIs( elements ) )
    {
      for( let src in elements )
        elementWrite( filePath, src, elements[ src ] );
      return filePath;
    }

    _.assert( 0 );
  }

  /* */

  function put( container, src, dst )
  {
    if( src === null )
    src = '';
    if( dst === null )
    dst = '';
    _.assert( _.strIs( src ) );
    _.assert( container[ src ] === undefined || container[ src ] === dst );
    container[ src ] = dst;
  }

  /* */

  function elementWrite( filePath, src, dst )
  {
    if( _.arrayIs( dst ) )
    {
      if( dst.length )
      dst.forEach( ( dst ) => elementWriteSingle( filePath, src, dst ) );
      else
      elementWriteSingle( filePath, src, '' );
      return filePath;
    }
    else
    {
      elementWriteSingle( filePath, src, dst );
      return filePath;
    }
  }

  /* */

  function elementWriteSingle( filePath, src, dst )
  {
    if( dst === null )
    dst = '';
    if( src === null )
    src = '';

    _.assert( _.strIs( src ) );
    _.assert( _.strIs( dst ) || _.boolLike( dst ) || _.instanceIs( dst ) );

    if( _.boolLike( dst ) )
    {
      dst = !!dst;
    }

    if( _.boolLike( filePath[ src ] ) )
    {
      if( dst !== '' )
      filePath[ src ] = dst;
    }
    else if( _.arrayIs( filePath[ src ] ) )
    {
      if( dst !== '' && !_.boolLike( dst ) )
      filePath[ src ] = _.scalarAppendOnce( filePath[ src ], dst );
    }
    else if( _.strIs( filePath[ src ] ) || _.instanceIs( filePath[ src ] ) )
    {
      if( filePath[ src ] === '' || filePath[ src ] === dst || dst === false )
      filePath[ src ] = dst;
      else if( filePath[ src ] !== '' && dst !== '' )
      {
        if( dst !== true )
        filePath[ src ] = _.scalarAppendOnce( filePath[ src ], dst );
      }
    }
    else
    {
      filePath[ src ] = dst;
    }

    if( src )
    hasSrc = true;
    if( dst !== '' )
    hasDst = true;

    return filePath;
  }

  /* */

  function end()
  {
    if( !hasSrc )
    {
      if( !hasDst )
      result = '';
      else if( !o.isSrc && !_.mapIs( o.filePath ) )
        result = _.props.vals( result )[ 0 ];
    }
    else if( !hasDst && o.isSrc )
      result = _.props.keys( result );

    if( o.dst === false )
    {
      if( _.arrayIs( o.filePath ) )
      {
        o.filePath.splice( 0, o.filePath.length );

        if( _.arrayIs( result ) )
        {
          result = _.arrayAppendArrayOnce( o.filePath, result );
        }
        else if( _.mapIs( result ) )
        {
          if( o.isSrc )
          result = _.arrayAppendArrayOnce( o.filePath, _.props.keys( result ) );
        }
        else
        {
          result = _.arrayAppendOnce( o.filePath, result );
        }
      }
      else if( _.mapIs( o.filePath ) )
      {
        for( let k in o.filePath )
          delete o.filePath[ k ];

        if( _.mapIs( result ) )
        for( let k in result )
          o.filePath[ k ] = result[ k ];

        else if( _.arrayIs( result ) )
          for( let i = 0; i < result.length; i++ )
            o.filePath[ result[ i ] ] = '';
        else
          o.filePath[ result ] = '';

        result = o.filePath;
      }
      else if( _.primitiveIs( o.filePath ) )
      {
        if( result.length === 1 )
        return result[ 0 ];
      }

      result = self.simplify_( result, result );
    }
    else if( o.dst === true )
    {
      if( result.length === 1 )
      return result[ 0 ];
      else if( result.length === 0 )
      return '';

      result = self.simplify_( null, result );
    }
    else
    {
      if( _.arrayIs( o.dst ) )
      {
        if( _.arrayIs( result ) )
        result = _.arrayAppendArrayOnce( o.dst, result );
        else if( _.mapIs( result ) )
        {
          if( o.isSrc )
          result = _.arrayAppendArrayOnce( o.dst, _.props.keys( result ) );
          else
          result = _.arrayAppendArraysOnce( o.dst, _.props.vals( result ) );
        }
        else
          result = _.arrayAppendOnce( o.dst, result );
      }
      else if( _.mapIs( o.dst ) )
      {
        if( _.mapIs( result ) )
        {
          if( !o.isSrc && !_.mapIs( o.filePath ) )
          {
            for( let k in result )
              o.dst[ '' ] = _.scalarAppendOnce( o.dst[ '' ], result[ k ] );
          }
          else
          {
            for( let k in result )
              o.dst[ k ] = result[ k ];
          }
        }

        else if( _.arrayIs( result ) )
        {
          if( !o.isSrc && !_.mapIs( o.filePath ) )
          {
            for( let i = 0; i < result.length; i++ )
            o.dst[ '' ] = _.scalarAppend( o.dst[ '' ], result[ i ] );
          }
          else
          {
            for( let i = 0; i < result.length; i++ )
            o.dst[ result[ i ] ] = '';
          }
        }
        else
        {
          if( o.isSrc )
          o.dst[ result ] = '';
          else
          o.dst[ '' ] = result;
        }

        result = o.dst;
      }
      result = self.simplify_( result, result );

    }

    if( _.mapIs( result ) && result[ '' ] === '' )
    delete result[ '' ];

    return result;
  }

}
filterPairs_body.defaults =
{
  dst : null,
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

var filterPairs_ = _.routine.uniteCloning_replaceByUnite( filterPairs_head, filterPairs_body );
filterPairs_.defaults =
{
  dst : null,
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

var filterSrcPairs_ = _.routine.uniteCloning_replaceByUnite( filterPairs_head, filterPairs_body );
filterSrcPairs_.defaults =
{
  dst : null,
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

var filterDstPairs_ = _.routine.uniteCloning_replaceByUnite( filterPairs_head, filterPairs_body );
filterDstPairs_.defaults =
{
  dst : null,
  filePath : null,
  onEach : null,
  isSrc : false,
}

//

function _filterInplace( o )
{
  let it = Object.create( null );

  _.routine.options_( _filterInplace, o );
  _.assert( arguments.length === 1 );
  _.routineIs( o.onEach );

  if( o.filePath === null )
  {
    o.filePath = '';
  }
  if( _.strIs( o.filePath ) )
  {

    it.value = o.filePath;
    if( o.isSrc )
    {
      it.src = o.filePath;
      it.dst = '';
      it.side = 'src';
    }
    else
    {
      it.src = '';
      it.dst = o.filePath;
      it.side = 'dst';
    }
    let r = o.onEach( it.value, it );

    if( r === undefined || r === null )
    return '';
    else if( _.strIs( r ) )
      return r;
    else if( _.arrayIs( r ) )
      r = write( it, r );

    if( r.length === 0 )
    return '';
    if( r.length === 1 )
    return r[ 0 ];
    else
    return r;
  }
  else if( _.arrayIs( o.filePath ) )
  {
    if( o.isSrc )
    {
      let filePath2 = o.filePath.slice();
      o.filePath.splice( 0, o.filePath.length );
      it.side = 'src';

      for( let p = 0 ; p < filePath2.length ; p++ )
      {

        it.index = p;
        it.src = filePath2[ p ] === null ? '' : filePath2[ p ];
        it.dst = '';
        it.value = it.src;

        let r = o.onEach( it.value, it );
        if( r !== undefined )
        _.arrayAppendArraysOnce( o.filePath, r );
      }
      return write( it, o.filePath );
    }
    else
    {
      let filePath2 = o.filePath.slice();
      o.filePath.splice( 0, o.filePath.length );
      it.side = 'dst';

      for( let p = 0 ; p < filePath2.length ; p++ )
      {
        it.index = p;
        it.src = '';
        it.dst = filePath2[ p ] === null ? '' : filePath2[ p ];
        it.value = it.dst;

        let r = o.onEach( it.value, it );
        if( r !== undefined )
        _.arrayAppendArraysOnce( o.filePath, r );
      }
      return write( it, o.filePath );
    }
  }
  else if( _.mapIs( o.filePath ) )
  {
    for( let src in o.filePath )
    {
      let dst = o.filePath[ src ];

      delete o.filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        if( dst.length === 0 )
        {
          it.src = src;
          it.dst = '';
          it.value = it.src;
          it.side = 'src';
          let srcResult = o.onEach( it.value, it );
          it.side = 'dst';
          it.value = it.dst;
          let dstResult = o.onEach( it.value, it );
          write( o.filePath, srcResult, dstResult );
        }
        else
        {
          for( let d = 0 ; d < dst.length ; d++ )
          {
            it.src = src;
            it.dst = dst[ d ] === null ? '' : dst[ d ];
            it.value = it.src;
            it.side = 'src';
            let srcResult = o.onEach( it.value, it );
            it.value = it.dst;
            it.side = 'dst';
            let dstResult = o.onEach( it.value, it );
            write( o.filePath, srcResult, dstResult );
          }
        }
      }
      else
      {
        it.src = src;
        it.dst = dst === null ? '' : dst;
        it.value = it.src;
        it.side = 'src';
        let srcResult = o.onEach( it.value, it );
        it.side = 'dst';
        it.value = it.dst;
        let dstResult = o.onEach( it.value, it );
        write( o.filePath, srcResult, dstResult );
      }

    }

  }
  else _.assert( 0 );

  if( _.mapIs( o.filePath ) )
  {
    if( o.filePath[ '' ] === '' )
    delete o.filePath[ '' ];
  }

  return o.filePath;

  /* */

  function write( pathMap, src, dst )
  {
    if( src === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    src = '';
    if( dst === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    dst = '';
    if( _.arrayIs( dst ) && dst.length === 1 )
    dst = dst[ 0 ];
    if( _.boolLike( dst ) )
    dst = !!dst;

    _.assert( src === undefined || _.strIs( src ) || _.arrayIs( src ) );

    if( dst !== undefined )
    {
      if( _.arrayIs( src ) )
      {
        for( let s = 0 ; s < src.length ; s++ )
        if( src[ s ] !== undefined )
        pathMap[ src[ s ] ] = append( pathMap[ src[ s ] ], dst );
      }
      else
      {
        if( src !== undefined )
        pathMap[ src ] = append( pathMap[ src ], dst );
      }
    }
    else if( _.arrayIs( src ) )
    {
      let src2 = src.slice();
      src.splice( 0, src.length );
      for( let i = 0 ; i < src2.length ; i++ )
      {
        if( src2[ i ] !== null && src2[ i ] !== '' && src2[ i ] !== undefined && !_.boolLike( src2[ i ] ) )
        _.arrayAppendOnce( src, src2[ i ] );
      }
      return src;
    }

  }

  function append( dst, src )
  {
    if( src === '' )
    dst = src;
    else if( _.boolLike( src ) )
      dst = src;
    else
    {
      if( _.strIs( dst ) || _.arrayIs( dst ) )
      dst = _.scalarAppendOnce( dst, src );
      else
      dst = src;
    }
    return dst;
  }

}
_filterInplace.defaults =
{
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

function filterInplace( filePath, onEach )
{

  _.assert( arguments.length === 2 );

  return _filterInplace
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterSrcInplace( filePath, onEach )
{

  _.assert( arguments.length === 2 );

  return _filterInplace
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterDstInplace( filePath, onEach )
{

  _.assert( arguments.length === 2 );

  return _filterInplace
  ({
    filePath,
    onEach,
    isSrc : false,
  });
}

//

function _filter( o )
{
  let self = this;
  let it = Object.create( null );
  let result;

  _.routine.options_( _filter, o );
  _.assert( arguments.length === 1 );
  _.routineIs( o.onEach );

  if( o.filePath === null )
  {
    o.filePath = '';
  }
  if( _.strIs( o.filePath ) )
  {

    it.value = o.filePath;
    if( o.isSrc )
    {
      it.src = o.filePath;
      it.dst = '';
      it.side = 'src';
    }
    else
    {
      it.src = '';
      it.dst = o.filePath;
      it.side = 'dst';
    }

    result = o.onEach( it.value, it );
    if( result === undefined )
    return null;

  }
  else if( _.arrayIs( o.filePath ) )
  {

    result = [];

    if( o.isSrc )
    {
      it.side = 'src';
      for( let p = 0; p < o.filePath.length; p++ )
      {
        it.index = p;
        it.src = o.filePath[ p ] === null ? '' : o.filePath[ p ];
        it.dst = '';
        it.value = it.src;

        let r = o.onEach( it.value, it );
        if( r !== undefined )
        _.arrayAppendArraysOnce( result, r );
      }
    }
    else
    {
      it.side = 'dst';
      for( let p = 0; p < o.filePath.length; p++ )
      {
        it.index = p;
        it.src = '';
        it.dst = o.filePath[ p ] === null ? '' : o.filePath[ p ];
        it.value = it.dst;
        let r = o.onEach( it.value, it );
        if( r !== undefined )
        _.arrayAppendArraysOnce( result, r );
      }
    }

  }
  else if( _.mapIs( o.filePath ) )
  {

    result = Object.create( null );
    for( let src in o.filePath )
    {
      let dst = o.filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        if( dst.length === 0 )
        {
          it.src = src;
          it.dst = '';
          it.value = it.src;
          it.side = 'src';
          let srcResult = o.onEach( it.value, it );
          it.value = it.dst;
          it.side = 'dst';
          let dstResult = o.onEach( it.value, it );
          write( result, srcResult, dstResult );
        }
        else
        {
          for( let d = 0 ; d < dst.length ; d++ )
          {
            it.src = src;
            it.dst = dst[ d ] === null ? '' : dst[ d ];
            it.value = it.src;
            it.side = 'src';
            let srcResult = o.onEach( it.value, it );
            it.value = it.dst;
            it.side = 'dst';
            let dstResult = o.onEach( it.value, it );
            write( result, srcResult, dstResult );
          }
        }
      }
      else
      {
        it.src = src;
        it.dst = dst === null ? '' : dst;
        it.value = it.src;
        it.side = 'src';
        let srcResult = o.onEach( it.value, it );
        it.value = it.dst;
        it.side = 'dst';
        let dstResult = o.onEach( it.value, it );
        write( result, srcResult, dstResult );
      }
    }

  }
  else _.assert( 0 );

  return self.simplify( result );

  /* */

  function write( pathMap, src, dst )
  {
    if( src === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    src = '';
    if( dst === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    dst = '';

    _.assert( src === undefined || _.strIs( src ) || _.arrayIs( src ) );

    if( dst !== undefined )
    {
      if( _.arrayIs( src ) )
      {
        for( let s = 0 ; s < src.length ; s++ )
        if( src[ s ] !== undefined )
        pathMap[ src[ s ] ] = _.scalarAppend( pathMap[ src[ s ] ], dst );
      }
      else if( src !== undefined )
      {
        pathMap[ src ] = _.scalarAppend( pathMap[ src ], dst );
      }
    }

  }

}
_filter.defaults =
{
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

function filter( filePath, onEach )
{

  _.assert( arguments.length === 2 );

  return this._filter
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterSrc( filePath, onEach )
{

  _.assert( arguments.length === 2 );

  return this._filter
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterDst( filePath, onEach )
{

  _.assert( arguments.length === 2 );

  return this._filter
  ({
    filePath,
    onEach,
    isSrc : false,
  });
}

//

// function filter( filePath, onEach )
// {
//   let self = this;
//   let it = Object.create( null );
//
//   _.assert( arguments.length === 2 );
//   _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
//   _.routineIs( onEach );
//
//   if( filePath === null || _.strIs( filePath ) )
//   {
//     it.value = filePath;
//     let r = onEach( it.value, it );
//     if( r === undefined )
//     return null;
//     return self.simplify( r );
//   }
//   else if( _.arrayIs( filePath ) )
//   {
//     let result = [];
//     for( let p = 0 ; p < filePath.length ; p++ )
//     {
//       it.index = p;
//       it.value = filePath[ p ];
//       let r = onEach( it.value, it );
//       if( r !== undefined )
//       result.push( r );
//     }
//     return self.simplify( result );
//   }
//   else if( _.mapIs( filePath ) )
//   {
//     let result = Object.create( null );
//     for( let src in filePath )
//     {
//       let dst = filePath[ src ];
//
//       if( _.arrayIs( dst ) )
//       {
//         dst = dst.slice();
//         for( let d = 0 ; d < dst.length ; d++ )
//         {
//           it.src = src;
//           it.dst = dst[ d ];
//           it.value = it.src;
//           it.side = 'src';
//           let srcResult = onEach( it.value, it );
//           it.value = it.dst;
//           it.side = 'dst';
//           let dstResult = onEach( it.value, it );
//           write( result, srcResult, dstResult );
//         }
//       }
//       else
//       {
//         it.src = src;
//         it.dst = dst;
//         it.value = it.src;
//         it.side = 'src';
//         let srcResult = onEach( it.value, it );
//         it.value = it.dst;
//         it.side = 'dst';
//         let dstResult = onEach( it.value, it );
//         write( result, srcResult, dstResult );
//       }
//
//     }
//
//     return self.simplify( result );
//   }
//   else _.assert( 0 );
//
//   /* */
//
//   function write( pathMap, src, dst )
//   {
//
//     _.assert( src === undefined || _.strIs( src ) || _.arrayIs( src ) );
//
//     if( dst !== undefined )
//     {
//       if( _.arrayIs( src ) )
//       {
//         for( let s = 0 ; s < src.length ; s++ )
//         if( src[ s ] !== undefined )
//         pathMap[ src[ s ] ] = _.scalarAppend( pathMap[ src[ s ] ], dst );
//       }
//       else if( src !== undefined )
//       {
//         pathMap[ src ] = _.scalarAppend( pathMap[ src ], dst );
//       }
//     }
//
//   }
//
// }

//

function filter_head( routine, args )
{
  _.assert( arguments.length === 2 );

  let o = Object.create( null );
  if( args.length === 1 )
  {
    _.assert( _.mapIs( args[ 0 ] ) );
    o = args[ 0 ];
  }
  else
  {
    if( args.length === 3 )
    {
      o.onEach = args[ 2 ];
      o.filePath = args[ 1 ];

      if( args[ 0 ] === null )
      o.dst = true;
      else if( args[ 0 ] === args[ 1 ] )
        o.dst = false;
      else if( _.arrayIs( args[ 0 ] ) || _.mapIs( args[ 0 ] ) )
        o.dst = args[ 0 ];
      else
        _.assert( 0 );
    }
    else if( args.length === 2 )
    {
      o.onEach = args[ 1 ];
      o.filePath = args[ 0 ];
      o.dst = false;
    }
    else
      _.assert( 0 );


  }

  _.routine.options_( routine, o );
  _.routineIs( o.onEach, '{-onEach-} should be a routine' );

  return o;
}


function filter_body( o )
{

  if( o.filePath === null )
  o.filePath = '';

  let result;
  let it = Object.create( null );

  if( o.dst === true )
  result = new o.filePath.constructor();
  else if( o.dst === false )
    result = o.filePath;
  else
    result = o.dst;

  if( _.strIs( o.filePath ) )
  {
    it.value = o.filePath;
    if( o.isSrc )
    {
      it.src = o.filePath;
      it.dst = '';
      it.side = 'src';
    }
    else
    {
      it.src = '';
      it.dst = o.filePath;
      it.side = 'dst';
    }

    let r = o.onEach( it.value, it );
    if( r === undefined || r === null )
    {
      r = '';
    }
    else if( _.arrayIs( r ) )
    {
      if( r.length === 0 )
      r = '';
      else if( r.length === 1 )
        r = r[ 0 ];
    }

    if( _.arrayIs( result ) )
    {
      if( _.arrayIs( r ) )
      _.arrayAppendArrayOnce( result, r );
      else
      _.arrayAppendOnce( result, r );
    }
    else if( _.mapIs( result ) )
    {
      result[ r ] = '';
    }
    else
    {
      result = r;
    }
  }
  else if( _.arrayIs( o.filePath ) )
  {
    if( o.isSrc )
    {
      it.side = 'src';
      for( let p = 0; p < o.filePath.length; p++ )
      {
        it.index = p;
        it.src = o.filePath[ p ] === null ? '' : o.filePath[ p ];
        it.dst = '';
        it.value = it.src;

        let r = o.onEach( it.value, it );
        writeArrayResult( r, p, result );
      }
    }
    else
    {
      it.side = 'dst';
      for( let p = 0; p < o.filePath.length; p++ )
      {
        it.index = p;
        it.src = '';
        it.dst = o.filePath[ p ] === null ? '' : o.filePath[ p ];
        it.value = it.dst;

        let r = o.onEach( it.value, it );
        writeArrayResult( r, p, result );
      }
    }

  }
  else if( _.mapIs( o.filePath ) )
  {
    for( let src in o.filePath )
    {
      let dst = o.filePath[ src ];

      if( o.dst === false )
      delete o.filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        if( dst.length === 0 )
        {
          it.src = src;
          it.dst = '';
          it.value = it.src;
          it.side = 'src';
          let srcResult = o.onEach( it.value, it );
          it.side = 'dst';
          it.value = it.dst;
          let dstResult = o.onEach( it.value, it );
          write( result, srcResult, dstResult );
        }
        else
        {
          dst = dst.slice();
          for( let d = 0; d < dst.length; d++ )
          {
            it.src = src;
            it.dst = dst[ d ] === null ? '' : dst[ d ];
            it.value = it.src;
            it.side = 'src';
            let srcResult = o.onEach( it.value, it );
            it.value = it.dst;
            it.side = 'dst';
            let dstResult = o.onEach( it.value, it );
            write( result, srcResult, dstResult );
          }
        }
      }
      else
      {
        it.src = src;
        it.dst = dst === null ? '' : dst;
        it.value = it.src;
        it.side = 'src';
        let srcResult = o.onEach( it.value, it );
        it.side = 'dst';
        it.value = it.dst;
        let dstResult = o.onEach( it.value, it );
        write( result, srcResult, dstResult );
      }

    }
  }
  else _.assert( 0 );

  if( o.dst === true )
  {
    result = this.simplify_( null, result );
  }
  else
  {
    if( _.mapIs( result ) && result[ '' ] === '' )
    delete result[ '' ];
    result = this.simplify_( result, result );
  }

  return result;

  /* */

  function write( pathMap, src, dst )
  {
    if( src === null || ( _.arrayIs( src ) && src.length === 0 ) )
    src = '';
    if( dst === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    dst = '';
    if( _.arrayIs( dst ) && dst.length === 1 )
    dst = dst[ 0 ];
    if( _.boolLike( dst ) )
    dst = !!dst;

    if( dst !== undefined )
    {
      if( _.mapIs( pathMap ) )
      {
        if( _.arrayIs( src ) )
        {
          for( let s = 0 ; s < src.length ; s++ )
          if( src[ s ] !== undefined )
          pathMap[ src[ s ] ] = append( pathMap[ src[ s ] ], dst );
        }
        else if( _.strIs( src ) )
          pathMap[ src ] = append( pathMap[ src ], dst );
        else if( src !== undefined )
          _.assert( 0 );
      }
      else
      {
        if( _.arrayIs( src ) )
        {
          for( let s = 0; s < src.length; s++ )
          _.arrayAppendArrays( pathMap, [ src[ s ], dst ] );
        }
        else
        {
          if( src !== undefined )
          _.arrayAppendOnce( pathMap, src );
          if( dst !== undefined )
          _.arrayAppendOnce( pathMap, dst );

        }
      }
    }

    function append( dst, src )
    {
      if( src === '' )
      dst = src;
      else if( _.boolLike( src ) )
        dst = src;
      else
      {
        if( _.strIs( dst ) || _.arrayIs( dst ) )
        dst = _.scalarAppendOnce( dst, src );
        else
        dst = src;
      }
      return dst;
    }
  }

  /* */

  function writeArrayResult( r, i, result )
  {
    if( r === undefined || r === null )
    {
      r = '';
    }
    else if( _.arrayIs( r ) )
    {
      if( r.length === 0 )
      r = '';
      else if( r.length === 1 )
        r = r[ 0 ];
    }

    if( o.dst === false )
    result[ i ] = r;
    else if( _.arrayIs( result ) )
      _.arrayAppendArraysOnce( result, r );
    else if( _.mapIs( result ) )
      result[ r ] = '';
  }

}
filter_body.defaults =
{
  dst : null,
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

let filter_ = _.routine.uniteCloning_replaceByUnite( filter_head, filter_body );
filter_.defaults =
{
  dst : null,
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

let filterSrc_ = _.routine.uniteCloning_replaceByUnite( filter_head, filter_body );
filterSrc_.defaults =
{
  dst : null,
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

let filterDst_ = _.routine.uniteCloning_replaceByUnite( filter_head, filter_body );
filterDst_.defaults =
{
  dst : null,
  filePath : null,
  onEach : null,
  isSrc : false,
}

//

function all( filePath, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  let it = Object.create( null );
  if( filePath === null || _.strIs( filePath ) )
  {
    it.value = filePath;
    let r = onEach( it.value, it );
    if( !r )
    return false;
    return true;
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.index = p;
      it.value = filePath[ p ];
      let r = onEach( it.value, it );
      if( !r )
      return false;
    }
    return true;
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];
      var r;
      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ];
          it.value = it.src;
          it.side = 'src';
          r = onEach( it.value, it );
          if( !r )
          return false;
          it.value = it.dst;
          it.side = 'dst';
          r = onEach( it.value, it );
          if( !r )
          return false;
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        it.value = it.src;
        it.side = 'src';
        r = onEach( it.value, it );
        if( !r )
        return false;
        it.value = it.dst;
        it.side = 'dst';
        r = onEach( it.value, it );
        if( !r )
        return false;
      }

    }
    return true;
  }
  else _.assert( 0 );

}

//

function any( filePath, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  let it = Object.create( null );

  if( filePath === null || _.strIs( filePath ) )
  {
    it.value = filePath;
    let r = onEach( it.value, it );
    if( r )
    return true;
    return false;
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.index = p;
      it.value = filePath[ p ];
      let r = onEach( it.value, it );
      if( r )
      return true;
    }
    return false;
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];
      var r;
      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ];
          it.value = it.src;
          it.side = 'src';
          r = onEach( it.value, it );
          if( r )
          return true;
          it.value = it.dst;
          it.side = 'dst';
          r = onEach( it.value, it );
          if( r )
          return true;
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        it.value = it.src;
        it.side = 'src';
        r = onEach( it.value, it );
        if( r )
        return true;
        it.value = it.dst;
        it.side = 'dst';
        r = onEach( it.value, it );
        if( r )
        return true;
      }

    }
    return false;
  }
  else _.assert( 0 );

}

//

function none( filePath, onEach )
{
  return !this.any.apply( this, arguments )
}

//

// function isEmpty( src )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1 );
//
//   if( src === null || src === '' )
//   {
//     return true;
//   }
//   else if( _.strIs( src ) )
//   {
//     return false;
//   }
//   else if( _.arrayIs( src ) )
//   {
//     if( src.length === 0 )
//     return true;
//     if( src.length === 1 )
//     if( src[ 0 ] === null || src[ 0 ] === '' )
//     return true;
//     return false;
//   }
//   else if( _.mapIs( src ) )
//   {
//     let keys = _.props.keys( src );
//     if( keys.length === 0 )
//     return true;
//     if( keys.length === 1 )
//     if( src[ '' ] === null || src[ '' ] === '' )
//     return true;
//     return false;
//   }
//   else
//   _.assert( 0 );
// }

function isEmpty( src )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( src === null || _.arrayIs( src ) || _.strIs( src ) || _.mapIs( src ) );

  if( src === null || src === '' )
  return true;

  if( _.strIs( src ) )
  return false;

  if( _.arrayIs( src ) )
  {
    if( src.length === 0 )
    return true;
    if( src.length === 1 )
    if( src[ 0 ] === null || src[ 0 ] === '' || src[ 0 ] === '.' ) // qqq zzz : refactor to remove dot case | Dmytro : uncomment routine above, please
      return true;
    return false;
  }

  if( _.props.keys( src ).length === 0 )
  return true;
  if( _.props.keys( src ).length === 1 )
  if( src[ '.' ] === null || src[ '.' ] === '' || src[ '' ] === null || src[ '' ] === '' ) // qqq zzz : refactor to remove dot | Dmytro : uncomment routine above, please
    return true;

  return false;
}

//

function _mapExtend( o )
{
  let self = this;
  let used = false;

  _.routine.optionsWithoutUndefined( _mapExtend, arguments );
  _.assert( o.dstPathMap === null || _.strIs( o.dstPathMap ) || _.arrayIs( o.dstPathMap ) || _.mapIs( o.dstPathMap ) );
  _.assert( !_.mapIs( o.dstPath ) );
  _.assert( _.longHas( [ 'replace', 'append', 'prepend' ], o.mode ) );

  o.dstPath = dstPathNormalize( o.dstPath );
  o.srcPathMap = srcPathMapNormalize( o.srcPathMap );

  if( o.supplementing )
  {
    getDstPathFromSrcMap();
    getDstPathFromDstMap();
  }
  else
  {
    getDstPathFromDstMap();
    getDstPathFromSrcMap();
  }

  [ o.dstPathMap, used ] = dstPathMapNormalize( o.dstPathMap );

  if( o.srcPathMap !== '' )
  used = dstPathMapExtend( o.dstPathMap, o.srcPathMap, o.dstPath ) || used;

  if( used && o.dstPathMap[ '' ] === o.dstPath )
  {
    delete o.dstPathMap[ '' ];
  }

  /* */

  return o.dstPathMap;

  /* */

  function dstPathNormalize( dstPath )
  {
    dstPath = self.simplify( dstPath );
    return dstPath;
  }

  /* */

  function srcPathMapNormalize( srcPathMap )
  {
    srcPathMap = self.simplify( srcPathMap );
    return srcPathMap;
  }

  /* */

  function getDstPathFromDstMap()
  {

    if( o.dstPath === null || o.dstPath === '' )
    if( _.mapIs( o.dstPathMap ) )
      if( o.dstPathMap[ '' ] !== undefined && o.dstPathMap[ '' ] !== null && o.dstPathMap[ '' ] !== '' )
        if( o.srcPathMap !== '' )
          if( o.dstPath !== o.dstPathMap[ '' ] )
          {
            o.dstPath = o.dstPathMap[ '' ];
            used = false;
          }

  }

  /* */

  function getDstPathFromSrcMap()
  {

    if( o.dstPath === null || o.dstPath === '' )
    if( _.mapIs( o.srcPathMap ) )
      if( o.srcPathMap[ '' ] !== undefined && o.srcPathMap[ '' ] !== null && o.srcPathMap[ '' ] !== '' )
        if( o.dstPath !== o.srcPathMap[ '' ] )
        {
          o.dstPath = o.srcPathMap[ '' ];
          used = false;
        }

  }

  /* */

  function dstPathMapNormalize( dstPathMap )
  {
    let used = false;

    if( dstPathMap === null )
    {
      dstPathMap = Object.create( null );
    }
    else if( _.strIs( dstPathMap ) )
    {
      let originalDstPath = dstPathMap;
      dstPathMap = Object.create( null );
      if( originalDstPath !== '' || ( o.dstPath !== null && o.dstPath !== '' ) )
      {
        dstPathMap[ originalDstPath ] = o.dstPath;
        if( originalDstPath !== '' )
        used = true;
      }
    }
    else if( _.arrayIs( dstPathMap ) )
    {
      let originalDstPath = dstPathMap;
      dstPathMap = Object.create( null );
      originalDstPath.forEach( ( p ) =>
      {
        dstPathMap[ p ] = o.dstPath;
        used = true;
      });
    }
    else if( _.mapIs( dstPathMap ) )
    {
      for( let f in dstPathMap )
      {
        let val = dstPathMap[ f ];
        if( ( val === null || val === '' ) && !_.boolLike( o.dstPath ) )
        {
          dstPathMap[ f ] = o.dstPath;
          used = true;
        }
        else
        if( _.boolLike( val ) )
        {
          dstPathMap[ f ] = !!val;
        }
      }

    }

    /* get dstPath from dstPathMap if it has empty key */

    if( dstPathMap[ '' ] === '' || dstPathMap[ '' ] === null )
    {
      delete dstPathMap[ '' ];
    }

    _.assert( _.mapIs( dstPathMap ) );
    return [ dstPathMap, used ];
  }

  /* */

  function dstPathMapRemove( dstPathMap, dstPath )
  {
    if( dstPath !== '' && _.props.keys( dstPathMap ).length === 0 )
    {
      dstPathMap[ '' ] = dstPath;
    }
    else for( let src in dstPathMap )
    {
      dstPathMap[ src ] = dstPath;
      if( src === '' && dstPath === '' )
      delete dstPathMap[ '' ];
    }
  }

  /* */

  function dstPathMapExtend( dstPathMap, srcPathMap, dstPath )
  {
    let used = false;

    if( _.strIs( srcPathMap ) )
    {
      let dst;
      srcPathMap = self.normalize( srcPathMap );
      [ dst, used ] = dstJoin( dstPathMap[ srcPathMap ], dstPath, srcPathMap );
      if( srcPathMap !== '' || dst !== '' )
      dstPathMap[ srcPathMap ] = dst;
    }
    else if( _.mapIs( srcPathMap ) )
    {
      for( let g in srcPathMap )
      {
        let dstPath2 = srcPathMap[ g ];
        let tryingToUse = false;

        dstPath2 = dstPathNormalize( dstPath2 );

        if( ( dstPath2 === null ) || ( dstPath2 === '' ) )
        {
          dstPath2 = dstPath;
          tryingToUse = true;
        }

        if( tryingToUse )
        used = dstPathMapExtend( dstPathMap, g, dstPath2 ) || used;
        else
        dstPathMapExtend( dstPathMap, g, dstPath2 );
      }
    }
    else if( _.argumentsArray.like( srcPathMap ) )
    {
      for( let g = 0 ; g < srcPathMap.length ; g++ )
      {
        let srcPathMap2 = srcPathMap[ g ];
        srcPathMap2 = srcPathMapNormalize( srcPathMap2 );
        used = dstPathMapExtend( dstPathMap, srcPathMap2, dstPath ) || used;
      }
    }
    else _.assert( 0, () => 'Expects srcPathMap, got ' + _.entity.strType( srcPathMap ) );

    return used;
  }

  /* */

  function dstJoin( dst, src, key )
  {
    let used = false;
    let r;

    if( _.boolLike( src ) )
    src = !!src;

    _.assert
    (
      dst === undefined
      || dst === null
      || _.arrayIs( dst )
      || _.strIs( dst )
      || _.boolIs( dst )
      || _.object.isBasic( dst )
    );
    _.assert
    (
      src === null
      || _.arrayIs( src )
      || _.strIs( src )
      || _.boolIs( src )
      || _.object.isBasic( src )
    );

    if( o.mode === 'replace' )
    {
      if( o.supplementing )
      {
        r = dst;
        if( dst === undefined || dst === null || dst === '' )
        {
          r = src;
          if( key !== '' )
          used = true;
        }
      }
      else
      {
        if( key !== '' )
        used = true;
        r = src;
      }
    }
    else
    {
      r = dst;

      if( dst === undefined || dst === null || dst === '' )
      {
        r = src;
        if( key !== '' )
        used = true;
      }
      else if( src === null || src === '' || _.boolLike( src ) || _.boolLike( dst ) )
      {
        if( o.supplementing && ( src === null || src === '' || _.boolLike( src ) ) )
        {
          r = dst;
        }
        else
        {
          r = src;
          if( key !== '' )
          used = true;
        }
      }
      // {
      //   if( o.supplementing )
      //   {
      //     r = dst;
      //   }
      //   else
      //   {
      //     r = src;
      //     if( key !== '' )
      //     used = true;
      //   }
      // }
      else
      {
        if( key !== '' )
        used = true;
        if( o.mode === 'append' )
        r = _.scalarAppendOnce( dst, src );
        else
        r = _.scalarPrependOnce( dst, src );
      }

    }

    r = self.simplifyInplace( r );

    return [ r, used ];
  }

}

_mapExtend.defaults =
{
  dstPathMap : null,
  srcPathMap : null,
  dstPath : null,
  mode : 'replace',
  supplementing : 0,
}

//

function mapExtend( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.cinterval.assertIn( arguments, [ 1, 3 ] );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'replace',
    supplementing : 0,
  });
}

//

function mapSupplement( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.cinterval.assertIn( arguments, [ 1, 3 ] );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'replace',
    supplementing : 1,
  });
}

//

function mapAppend( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.cinterval.assertIn( arguments, [ 1, 3 ] );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'append',
    supplementing : 1,
  });
}

//

function mapPrepend( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'prepend',
    supplementing : 1,
  });
}

//

function mapsPair( dstFilePath, srcFilePath )
{
  let self = this;
  // let srcPath1;
  // let srcPath2;
  // let dstPath1;
  // let dstPath2;

  _.assert( srcFilePath !== undefined );
  _.assert( dstFilePath !== undefined );
  _.assert( arguments.length === 2 );

  if( srcFilePath && dstFilePath )
  {

    // srcPath1 = self.mapSrcFromSrc( srcFilePath );
    // srcPath2 = self.mapSrcFromDst( dstFilePath );
    // dstPath1 = self.mapDstFromSrc( srcFilePath );
    // dstPath2 = self.mapDstFromDst( dstFilePath );

    // srcPath1 = self.mapSrcFromSrc( srcFilePath ).filter( ( e ) => e !== null );
    // srcPath2 = self.mapSrcFromDst( dstFilePath ).filter( ( e ) => e !== null );
    // dstPath1 = self.mapDstFromSrc( srcFilePath ).filter( ( e ) => e !== null );
    // dstPath2 = self.mapDstFromDst( dstFilePath ).filter( ( e ) => e !== null );

    if( _.mapIs( srcFilePath ) && _.mapIs( dstFilePath ) )
    {
      mapsVerify();
    }
    else
    {
      srcVerify();
      // dstVerify();
    }

    if( _.mapIs( dstFilePath ) )
    {
      dstFilePath = self.mapExtend( null, dstFilePath, null );
      srcFilePath = dstFilePath = self.mapSupplement( dstFilePath, srcFilePath, null );
    }
    else
    {
      srcFilePath = dstFilePath = self.mapExtend( null, srcFilePath, dstFilePath );
    }

  }
  else if( srcFilePath )
  {
    if( self.isEmpty( srcFilePath ) )
    srcFilePath = dstFilePath = null;
    else
    srcFilePath = dstFilePath = self.mapExtend( null, srcFilePath, null );
  }
  else if( dstFilePath )
  {
    if( self.isEmpty( dstFilePath ) )
    srcFilePath = dstFilePath = null;
    else if( _.mapIs( dstFilePath ) )
      srcFilePath = dstFilePath = self.mapExtend( null, dstFilePath, null );
    else
      srcFilePath = dstFilePath = self.mapExtend( null, { '' : dstFilePath }, dstFilePath ); // yyy
  }
  else
  {
    srcFilePath = dstFilePath = null;
  }

  return srcFilePath;

  /* */

  function mapsVerify()
  {
    _.assert
    (
      _.map.identical( srcFilePath, dstFilePath ),
      () => 'File maps are inconsistent\n' + _.entity.exportString( srcFilePath ) + '\n' + _.entity.exportString( dstFilePath )
    );
  }

  /* */

  function srcVerify()
  {
    if( dstFilePath && srcFilePath && Config.debug )
    {
      let srcPath1 = self.mapSrcFromSrc( srcFilePath ).filter( ( e ) => e !== null );
      let srcPath2 = self.mapSrcFromDst( dstFilePath ).filter( ( e ) => e !== null );
      let srcFilteredPath1 = srcPath1.filter( ( e ) => !_.boolLike( e ) && e !== null );
      let srcFilteredPath2 = srcPath2.filter( ( e ) => !_.boolLike( e ) && e !== null );
      _.assert
      (
        srcFilteredPath1.length === 0 || srcFilteredPath2.length === 0
        || self.isEmpty( srcFilteredPath1 ) || self.isEmpty( srcFilteredPath2 )
        || _.arraySetIdentical( srcFilteredPath1, srcFilteredPath2 ),
        () => 'Source paths are inconsistent ' + _.entity.exportString( srcFilteredPath1 ) + ' ' + _.entity.exportString( srcFilteredPath2 )
      );
    }
  }

}

//

function simplify( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( src === null )
  return '';

  if( _.strIs( src ) )
  return src;

  if( _.boolLike( src ) )
  return !!src;

  if( _.arrayIs( src ) )
  {
    let src2 = _.arrayAppendArrayOnce( null, src );
    src2 = src2.filter( ( e ) => e !== null && e !== '' );
    if( src2.length !== src.length )
    src = src2;
    if( src.length === 0 )
    return '';
    else if( src.length === 1 )
      return src[ 0 ]
    else
      return src;
  }

  if( !_.mapIs( src ) )
  return src;

  for( let k in src )
  {
    src[ k ] = self.simplify( src[ k ] );
  }

  let keys = _.props.keys( src );
  if( keys.length === 0 )
  return '';
  if( keys.length !== 1 && keys.includes( '' ) && src[ '' ] === '' )
  delete src[ '' ];

  let vals = _.props.vals( src );
  vals = vals.filter( ( e ) => e !== null && e !== '' );
  if( vals.length === 0 )
  {
    if( keys.length === 1 && keys[ 0 ] === '' )
    return '';
    else if( keys.length === 1 )
      return keys[ 0 ]
    else
      return src;
  }

  return src;
}

//

function simplifyDst( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( src === null )
  return '';

  if( _.strIs( src ) )
  return src;

  if( _.boolLike( src ) )
  return !!src;

  if( _.arrayIs( src ) )
  {
    let src2 = _.arrayAppendArrayOnce( null, src );
    src2 = src2.filter( ( e ) => e !== null && e !== '' );
    if( src2.length !== src.length )
    src = src2;
    if( src.length === 0 )
    return '';
    else if( src.length === 1 )
      return src[ 0 ]
    else
      return src;
  }

  if( !_.mapIs( src ) )
  return src;

  for( let k in src )
  {
    src[ k ] = self.simplifyDst( src[ k ] );
  }

  let keys = _.props.keys( src );
  if( keys.length === 0 )
  return '';

  if( keys.length === 1 && src[ '' ] !== undefined )
  src = src[ '' ];

  return src;
}

//

function simplifyInplace( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( src === null )
  return '';

  if( _.boolLike( src ) )
  return !!src;

  if( _.strIs( src ) )
  return src;

  if( _.arrayIs( src ) )
  {
    src = _.arrayRemoveDuplicates( src, ( e ) => e );
    src = _.arrayRemoveElement( src, '', ( e ) => e === null || e === '' );
    return src;
  }

  if( !_.mapIs( src ) )
  return src;

  for( let k in src )
  {
    src[ k ] = self.simplifyInplace( src[ k ] );
  }

  return src;
}

//

function simplify_( dst, src )
{
  let self = this;
  let result;

  if( arguments.length === 1 )
  {
    src = dst;
    dst = true;
  }
  else
  _.assert( arguments.length === 2 );

  if( dst === null )
  dst = true;
  else if( dst === src )
    dst = false;

  if( src === null )
  {
    result = '';
  }
  else if( _.strIs( src ) )
  {
    result = src;
  }
  else if( _.boolLike( src ) )
  {
    result = !!src;
  }
  else if( _.arrayIs( src ) )
  {
    if( dst === false )
    {
      result = _.arrayRemoveDuplicates( src, ( e ) => e );
      result = _.arrayRemoveElement( result, '', ( e ) => e === null || e === '' );
      return result;
    }
    else
    {
      result = _.arrayAppendArrayOnce( null, src );
      result = result.filter( ( e ) => e !== null && e !== '' );
      if( result.length === 0 )
      result = '';
      else if( result.length === 1 )
        result = result[ 0 ];
    }
  }
  else if( _.mapIs( src ) )
  {
    if( dst === false )
    {
      for( let k in src )
      src[ k ] = self.simplify( src[ k ] );
      result = src;
    }
    else
    {
      result = Object.create( null );

      for( let k in src )
        result[ k ] = self.simplify( src[ k ] );

      let keys = _.props.keys( result );
      if( keys.length > 0 )
      {
        if( keys.length !== 1 && keys.includes( '' ) && result[ '' ] === '' )
        delete result[ '' ];

        let vals = _.props.vals( result );
        vals = vals.filter( ( e ) => e !== null && e !== '' );
        if( vals.length === 0 )
        {
          if( keys.length === 1 && keys[ 0 ] === '' )
          result = '';
          else if( keys.length === 1 )
            result = keys[ 0 ];
        }
      }
      else
      result = '';
    }
  }
  else
  {
    result = src;
  }

  fillDst();

  return result;

  /* */

  function fillDst()
  {
    if( !_.boolIs( dst ) )
    {
      if( _.arrayIs( dst ) )
      {
        if( _.arrayIs( result ) )
        _.arrayAppendArrayOnce( dst, result );
        else if( _.mapIs( result ) )
          _.arrayAppendArrayOnce( dst, _.props.keys( result ) );
        else if( result !== '' )
          _.arrayAppendOnce( dst, result );
      }
      else if( _.mapIs( dst ) )
      {
        if( _.mapIs( result ) )
        {
          for( let k in result )
            dst[ k ] = result[ k ];
        }
        else if( _.arrayIs( result ) )
        {
          for( let i in result )
            dst[ result[ i ] ] = '';
        }
        else
          dst[ result ] = '';
      }
      else
        dst = result;

      result = self.simplify_( dst, dst );
    }
  }

}

//

function mapDstFromSrc( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  {
    if( pathMap === null )
    return [];
    else
    return [ null ];
  }

  let result = [];

  for( let k in pathMap )
  {
    if( _.arrayIs( pathMap[ k ] ) )
    _.arrayAppendArrayOnce( result, pathMap[ k ] );
    else
    _.arrayAppendOnce( result, pathMap[ k ] );
  }

  return result;
}

//

function mapDstFromDst( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  {
    if( pathMap === null )
    return [];
    else
    return _.array.asShallow( pathMap );
  }

  let result = [];

  for( let k in pathMap )
  {
    if( _.arrayIs( pathMap[ k ] ) )
    _.arrayAppendArrayOnce( result, pathMap[ k ] );
    else
    _.arrayAppendOnce( result, pathMap[ k ] );
  }

  return result;
}

//

function mapSrcFromSrc( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  {
    if( pathMap === null )
    return [];
    else
    return _.array.asShallow( pathMap );
  }

  let result = [];

  for( let k in pathMap )
  if( k !== '' || ( pathMap[ k ] !== '' && pathMap[ k ] !== null ) )
  result.push( k );

  return result;
}

//

function mapSrcFromDst( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  {
    if( pathMap === null )
    return [];
    else
    return [ null ];
  }

  let result = [];

  for( let k in pathMap )
    result.push( k );

  return result;
}

// --
// etc
// --

function traceToRoot( filePath )
{
  let self = this;
  let result = [];

  filePath = self.normalize( filePath );
  // filePath = self.detrail( filePath ); // Dmytro : cycled loop if path is absolute and has form '/..'
  // filePath = self.canonize( filePath );

  _.assert( arguments.length === 1 );
  _.assert( self.isAbsolute( filePath ) );

  /*
    should preserve trailing of the longest path
    /a/b/ -> [ '/', '/a', '/a/b/' ]
  */

  // if( self.isAbsolute( filePath ) )
  // {
  result.push( filePath );
  filePath = self.detrail( filePath );
  while( filePath !== self.rootToken )
  {
    _.assert
    (
      filePath !== self.rootToken + self.downToken
      && !_.strBegins( filePath, self.rootToken + self.downToken + self.upToken )
    );
    filePath = self.dir( filePath );
    result.push( filePath );
    // filePath = self.detrail( dir ); /* qqq : not optimal! | aaa : Moved outside of the loop. */
  }
  // }
  // else
  // {
  //   filePath = self.undot( filePath );
  //   if( !self.isDotted( filePath ) )
  //   do
  //   {
  //     result.unshift( filePath );
  //     filePath = self.detrail( self.dir( filePath ) ); /* qqq : not optimal! */
  //   }
  //   while( !self.isDotted( filePath ) );
  // }

  // result.push( filePath );

  return result.reverse();
}

//

function group( o )
{
  let self = this;

  _.routine.options_( group, arguments );
  _.assert( _.arrayIs( o.vals ) );
  _.assert( o.result === null || _.mapIs( o.result ) );

  o.result = o.result || Object.create( null );
  o.result[ '/' ] = o.result[ '/' ] || [];

  let vals = _.arrayFlattenOnce( null, o.vals );
  let keys = o.keys;

  keys = self.s.from( keys );
  vals = self.s.from( vals );

  keys = self.mapSrcFromSrc( keys );

  _.assert( _.arrayIs( keys ) );
  _.assert( _.arrayIs( vals ) );

  // if( o.vals && o.vals.length )

  /* */

  for( let k = 0 ; k < keys.length ; k++ )
  {
    let key = keys[ k ];
    let res = o.result[ key ] = o.result[ key ] || [];
  }

  /* */

  for( let key in o.result )
  {
    let res = o.result[ key ];
    for( let v = 0 ; v < vals.length ; v++ )
    {
      let val = vals[ v ];
      if( self.begins( val, key ) )
      _.sorted.addOnce( res, val, ( a, b ) =>
      {
        a = a.toLowerCase();
        b = b.toLowerCase();
        if( a === b )
        return 0;
        if( a < b )
        return -1;
        return +1;
      });
      // _.arrayAppendOnce( res, val );
    }

  }

  /* */

  // if( o.vals && o.vals.length )

  return o.result;
}

group.defaults =
{
  keys : null,
  vals : null,
  result : null,
}

//

function mapGroupByDst( pathMap )
{
  let path = this;
  let result = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( pathMap ) );

  /* */

  for( let src in pathMap )
  {
    let normalizedSrc = path.fromGlob( src );
    let dst = pathMap[ src ];

    if( _.boolLike( dst ) )
    continue;

    if( _.strIs( dst ) )
    {
      extend( dst, src );
    }
    else
    {
      _.assert( _.arrayIs( dst ) );
      for( var d = 0 ; d < dst.length ; d++ )
      extend( dst[ d ], src );
    }

  }

  /* */

  for( let src in pathMap )
  {
    let dst = pathMap[ src ];

    if( !_.boolLike( dst ) )
    continue;

    for( var dst2 in result )
    {

      for( var src2 in result[ dst2 ] )
      {
        if( path.isRelative( src ) ^ path.isRelative( src2 ) )
        {
          result[ dst2 ][ src ] = !!dst;
        }
        else
        {
          let srcBase = path.fromGlob( src );
          let srcBase2 = path.fromGlob( src2 );
          if( path.begins( srcBase, srcBase2 ) || path.begins( srcBase2, srcBase ) )
          result[ dst2 ][ src ] = !!dst;
        }
      }

    }

  }

  /* */

  return result;

  /* */

  function extend( dst, src )
  {
    dst = path.normalize( dst );
    result[ dst ] = result[ dst ] || Object.create( null );
    result[ dst ][ src ] = '';
  }

}

//

function mapOptimize( filePath, basePath )
{
  let self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( basePath === undefined || _.mapIs( basePath ) );
  _.assert( self.isElement( filePath ) );

  if( !_.mapIs( filePath ) )
  filePath = self.mapExtend( null, filePath );

  let include = [];
  let exclude = [];
  let trunk = [];

  for( let src in filePath )
  {
    let dst = filePath[ src ];
    if( !_.boolLike( dst ) )
    trunk.push( src );
    else if( dst )
      include.push( src );
    else
      exclude.push( src );
  }

  optimize( include );
  optimize( exclude );
  optimize( trunk );

  return filePath;

  /* */

  function optimize( array )
  {
    array.sort();
    for( let i1 = 0 ; i1 < array.length ; i1++ )
    {
      let path1 = array[ i1 ];
      for( let i2 = i1+1 ; i2 < array.length ; i2++ )
      {
        let path2 = array[ i2 ];

        if( !self.begins( path2, path1 ) )
        break;

        if( filePath[ path1 ] !== filePath[ path2 ] )
        continue;

        if( basePath )
        {
          if( basePath[ path1 ] === basePath[ path2 ] )
          delete basePath[ path2 ];
          else
          continue;
        }

        array.splice( i2, 1 );
        delete filePath[ path2 ];
        i2 -= 1;
      }
    }
  }

}

//

function identical( src1, src2 )
{
  /* qqq : write performance test and optimize it */

  if( _.mapIs( src1 ) )
  return mapIdentical( src1, src2 );
  else if( _.arrayIs( src1 ) )
  return _.long.identical( src1, src2 );
  else
  return src1 === src2;

  function mapIdentical( src1, src2 )
  {
    if( !_.mapIs( src2 ) )
    return false;
    let keys1 = Object.keys( src1 );
    let keys2 = Object.keys( src2 );
    if( keys1.length !== keys2.length )
    return false;
    for( let i = 0, l = keys1.length ; i < l ; i++ )
    {
      let k = keys1[ i ];
      if( _.arrayIs( src1[ k ] ) )
      {
        if( !_.long.identical( src1[ k ], src2[ k ] ) )
        return false;
      }
      else
      {
        if( src1[ k ] !== src2[ k ] )
        return false
      }
    }
    return true;
  }

}

// --
// implementation
// --

let PathExtension =
{

  // path map

  _filterPairs, /* !!! */
  filterPairs, /* !!! */
  filterSrcPairs, /* !!! */
  filterDstPairs, /* !!! */

  _filterPairsInplace, /* !!! */
  filterPairsInplace, /* !!! */
  filterSrcPairsInplace, /* !!! */
  filterDstPairsInplace, /* !!! */

  _filterInplace, /* !!! */
  filterInplace, /* !!! */
  filterSrcInplace, /* !!! */
  filterDstInplace, /* !!! */

  _filter, /* !!! */
  filter, /* !!! */
  filterSrc, /* !!! */
  filterDst, /* !!! */

  all, /* !!! */
  any, /* !!! */
  none, /* !!! */

  isEmpty, /* !!! */
  _mapExtend, /* !!! */
  mapExtend, /* !!! */
  mapSupplement, /* !!! */
  mapAppend, /* !!! */
  mapPrepend, /* !!! */
  mapsPair, /* !!! */

  simplify, /* !!! */
  simplifyDst, /* !!! */
  simplifyInplace, /* !!! */

  mapDstFromSrc, /* !!! */
  mapDstFromDst, /* !!! */
  mapSrcFromSrc, /* !!! */
  mapSrcFromDst, /* !!! */

  // etc

  traceToRoot,
  group,
  mapGroupByDst, /* !!! */
  mapOptimize, /* !!! */

  // to replace

  /* xxx : replace */
  filterPairs_, /* !!! : use instead of filterPairs, filterPairsInplace */
  filterSrcPairs_, /* !!! : use instead of filterSrcPairs, filterSrcPairsInplace */
  filterDstPairs_, /* !!! : use instead of filterDstPairs, filterDstPairsInplace */
  filter_, /* !!! : use instead of filter, filterInplace */
  filterSrc_, /* !!! : use instead of filterSrc, filterSrcInplace */
  filterDst_, /* !!! : use instead of filterDst, filterDstInplace */
  simplify_, /* !!! : use instead of simplify, simplifyInplace */

  /*
    | routine         | makes new dst container                          | saves dst container                                 |
    | ----------------| -------------------------------------------------| ----------------------------------------------------|
    | filterPairs_    | _.path.filterPairs_( null, filePath, onEach )    | _.path.filterPairs_( filePath, onEach )             |
    |                 |                                                  | _.path.filterPairs_( filePath, filePath, onEach )   |
    |                 |                                                  | _.path.filterPairs_( dst, filePath, onEach )        |
    |                 |                                                  | dst should be array or map                          |
    | ----------------| -------------------------------------------------| ----------------------------------------------------|
    | filterSrcPairs_ | _.path.filterSrcPairs_( null, filePath, onEach ) | _.path.filterSrcPairs_( filePath, onEach )          |
    |                 |                                                  | _.path.filterSrcPairs_( filePath, filePath, onEach )|
    |                 |                                                  | _.path.filterSrcPairs_( dst, filePath, onEach )     |
    |                 |                                                  | dst should be array or map                          |
    | ----------------| -------------------------------------------------| ----------------------------------------------------|
    | filterDstPairs_ | _.path.filterDstPairs_( null, filePath, onEach ) | _.path.filterDstPairs_( filePath, onEach )          |
    |                 |                                                  | _.path.filterDstPairs_( filePath, filePath, onEach )|
    |                 |                                                  | _.path.filterDstPairs_( dst, filePath, onEach )     |
    |                 |                                                  | dst should be array or map                          |
    | ----------------| -------------------------------------------------| ----------------------------------------------------|
    | filter_         | _.path.filter_( null, filePath, onEach )         | _.path.filter_( filePath, onEach )                  |
    |                 |                                                  | _.path.filter_( filePath, filePath, onEach )        |
    |                 |                                                  | _.path.filter_( dst, filePath, onEach )             |
    |                 |                                                  | dst should be array or map                          |
    | --------------- | -------------------------------------------------| ----------------------------------------------------|
    | filterSrc_      | _.path.filterSrc_( null, filePath, onEach )      | _.path.filterSrc_( filePath, onEach )               |
    |                 |                                                  | _.path.filterSrc_( filePath, filePath, onEach )     |
    |                 |                                                  | _.path.filterSrc_( dst, filePath, onEach )          |
    |                 |                                                  | dst should be array or map                          |
    | --------------- | -------------------------------------------------| ----------------------------------------------------|
    | filterDst_      | _.path.filterDst_( null, filePath, onEach )      | _.path.filterDst_( filePath, onEach )               |
    |                 |                                                  | _.path.filterDst_( filePath, filePath, onEach )     |
    |                 |                                                  | _.path.filterDst_( dst, filePath, onEach )          |
    |                 |                                                  | dst should be array or map                          |
    | --------------- | -------------------------------------------------| ----------------------------------------------------|
    | simplify_       | _.path.simplify_( filePath )                     | _.path.simplify_( filePath, filePath )              |
    |                 | _.path.simplify_( null, filePath )               | _.path.simplify_( dst, filePath )                   |
    |                 | _.path.simplify_( dst, filePath )                |                                                     |
    |                 | if dst is not resizable                          |                                                     |
  */

}

let PathMapExtension =
{
  /* qqq : duplicate relevant routines here | aaa : Done. Yevhen S. */

  _filterPairs,
  filterPairs,
  filterSrcPairs,
  filterDstPairs,

  _filterPairsInplace,
  filterPairsInplace,
  filterSrcPairsInplace,
  filterDstPairsInplace,

  _filterInplace,
  filterInplace,
  filterSrcInplace,
  filterDstInplace,

  _filter,
  filter,
  filterSrc,
  filterDst,

  all,
  any,
  none,

  isEmpty,
  _extend : _mapExtend,
  extend : mapExtend,
  supplement : mapSupplement,
  append : mapAppend,
  prepend : mapPrepend,
  pair : mapsPair,

  simplify,
  simplifyDst,
  simplifyInplace,

  dstFromSrc : mapDstFromSrc,
  dstFromDst : mapDstFromDst,
  srcFromSrc : mapSrcFromSrc,
  srcFromDst : mapSrcFromDst,

  groupByDst : mapGroupByDst,
  optimize : mapOptimize,

  identical, /* qqq : implement very optimal version */


  /* qqq : implement equivalent */

}

_.props.supplement( _.path, PathExtension );
_.props.supplement( _.path.map, PathMapExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
{
  module[ 'exports' ] = _;
  require( './Glob.s' );
}

})();

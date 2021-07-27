( function _l7_Container_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function extendReplacing( dst, src )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( dst === null || dst === undefined )
  {

    if( _.aux.is( src ) )
    dst = _.props.extend( null, src );
    else if( _.longLike( src ) )
    dst = _.arrayExtendAppending( null, src );
    else if( _.hashMap.like( src ) )
    dst = _.hashMap.extend( null, src );
    else if( _.set.like( src ) )
    dst = _.arraySet.union_( null, src );
    else
    dst = src;

  }
  else if( _.aux.is( src ) )
  {

    if( _.aux.is( dst ) )
    dst = _.props.extend( dst, src );
    else if( _.hashMap.like( dst ) )
    dst = _.hashMap.extend( dst, src );
    else
    dst = _.container.extendReplacing( null, src );

  }
  else if( _.longLike( src ) )
  {

    if( _.longIs( dst ) )
    {
      for( let i = src.length - 1 ; i >= 0 ; i-- )
      dst[ i ] = src[ i ];
    }
    else
    {
      dst = _.container.extendReplacing( null, src );
    }

  }
  else if( _.hashMap.like( src ) )
  {

    if( _.hashMap.like( dst ) || _.aux.is( dst ) )
    dst = _.hashMap.extend( dst, src );
    else
    dst = _.container.extendReplacing( null, src );

  }
  else if( _.set.like( src ) )
  {

    if( _.set.like( dst ) || _.longLike( dst ) )
    dst = _.arraySet.union_( dst, src );
    else
    dst = _.container.extendReplacing( null, src );

  }
  else
  {

    dst = src;

  }

  return dst;
}

//

function extendAppending( dst, src )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( dst === null || dst === undefined )
  {

    if( _.aux.is( src ) )
    dst = _.props.extend( null, src );
    else if( _.longLike( src ) )
    dst = _.arrayExtendAppending( null, src );
    else if( _.hashMap.like( src ) )
    dst = _.hashMap.extend( null, src );
    else if( _.set.like( src ) )
    dst = _.arraySet.union_( null, src );
    else
    dst = src;

  }
  else if( _.aux.is( dst ) )
  {

    if( _.aux.is( src ) )
    dst = _.props.extend( dst, src );
    else if( _.hashMap.like( src ) )
    dst = _.hashMap.extend( dst, src );
    else
    dst = _.arrayExtendAppending( dst, src );

  }
  else if( _.longLike( dst ) )
  {

    dst = _.arrayExtendAppending( dst, src );

  }
  else if( _.hashMap.like( dst ) )
  {

    if( _.hashMap.like( src ) || _.aux.is( src ) )
    dst = _.hashMap.extend( dst, src );
    else
    dst = _.arrayExtendAppending( dst, src );

  }
  else if( _.set.like( dst ) )
  {

    if( _.set.like( src ) || _.longLike( src ) )
    dst = _.arraySet.union_( dst, src );
    else
    dst = _.arrayExtendAppending( dst, src );

  }
  else
  {

    dst = src;

  }

  return dst;
}

// --
// declaration
// --

let ContainerExtension =
{

  extendReplacing, /* zzz : dubious */
  extendAppending, /* zzz : dubious */

}

_.props.supplement( _.container, ContainerExtension );

//

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

})();

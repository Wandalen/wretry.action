( function _l5_Set_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function butElement( dst, src1, element )
{

  if( dst === null )
  dst = new Set();
  else if( dst === _.self )
  dst = src1;

  _.assert( arguments.length === 3 );
  _.assert( _.set.is( dst ) || dst === null );
  _.assert( _.countable.is( src1 ) );

  if( dst === src1 )
  {
    dst.delete( element );
  }
  else
  {
    for( let e of src1 )
    if( e !== element )
    dst.add( e );
  }

  return dst;
}

//

/* qqq : cover */
/* qqq : add test cases src1/src2 is set/countable/array/unrolls */
function but( dst, src1, src2 )
{

  if( dst === null )
  dst = new Set();
  else if( dst === _.self )
  dst = src1;

  _.assert( arguments.length === 3 );
  _.assert( _.set.is( dst ) || dst === null );
  _.assert( _.countable.is( src1 ) );
  _.assert( _.countable.is( src2 ) );

  if( dst === src1 )
  {
    for( let e of src2 )
    if( dst.has( e ) )
    dst.delete( e );
  }
  else
  {
    if( !_.set.is( src2 ) )
    src2 = [ ... src2 ];
    for( let e of src1 )
    if( !src2.has( e ) )
    dst.add( e );
  }

  return dst;
}

//

/* qqq : cover */
/* qqq : src1 could be countable or unroll */
/* qqq : src2 could be countable or unroll */
function only( dst, src1, src2 )
{
  // if( arguments.length === 2 )
  // {
  //   dst = null;
  //   src1 = arguments[ 0 ];
  //   src2 = arguments[ 1 ];
  // }

  _.assert( arguments.length === 3 );
  _.assert( dst === null || _.set.is( dst ) );
  _.assert( _.countable.is( src1 ) );
  _.assert( _.countable.is( src2 ) );

  if( dst === null )
  dst = new Set();

  for( let e of src1 )
  if( src2.has( e ) )
  dst.add( e );

  return dst;
}

//

/* qqq : cover */
/* qqq : src1 could be countable or unroll */
/* qqq : src2 could be countable or unroll */
function union( dst, src1, src2 )
{

  // if( arguments.length === 2 )
  // {
  //   dst = null;
  //   src1 = arguments[ 0 ];
  //   src2 = arguments[ 1 ];
  // }

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( dst === null || _.set.is( dst ) );
  _.assert( _.countable.is( src1 ) );
  _.assert( _.countable.is( src2 ) );

  if( dst === null )
  dst = new Set();

  if( _.unrollIs( src1 ) )
  {
    _.assert( 0, 'not implemented' );
    for( let set of src1 )
    {
      _.assert( _.set.is( set ) );
      for( let e of set )
      dst.add( e );
    }
  }
  else
  {
    for( let e of src1 )
    dst.add( e );
  }

  if( src2 !== undefined )
  if( _.unrollIs( src2 ) )
  {
    xxx
    for( let set of src2 )
    {
      _.assert( _.set.is( set ) );
      for( let e of set )
      dst.add( e );
    }
  }
  else
  {
    for( let e of src2 )
    dst.add( e );
  }

  return dst;
}

//

/* qqq : cover */
function diff( dst, src1, src2 )
{

  if( arguments.length === 2 )
  {
    dst = null;
    src1 = arguments[ 0 ];
    src2 = arguments[ 1 ];
  }

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( dst === null || _.aux.is( dst ) );
  _.assert( _.set.is( src1 ) );
  _.assert( _.set.is( src2 ) );

  dst = dst || Object.create( null );
  dst.src1 = _.set.but( dst.src1 || null, src1, src2 );
  dst.src2 = _.set.but( dst.src2 || null, src2, src1 );
  dst.diff = new Set([ ... dst.src1, ... dst.src2 ]);
  dst.identical = dst.src1.size === 0 && dst.src2.size === 0;

  return dst;
}

//

function appendContainer( dst, src )
{
  if( dst === null )
  dst = new Set;

  _.assert( arguments.length === 2 );

  if( _.countable.is( src ) )
  {
    dst.add( ... src );
  }
  else
  {
    dst.add( src );
  }

  return dst;
}

// --
// extension
// --

let ToolsExtension =
{

}

Object.assign( _, ToolsExtension );

//

let SetExtension =
{

  /* xxx2 : review */
  butElement,
  but,
  only,
  union,
  diff,

  appendContainer,

}

Object.assign( _.set, SetExtension );

//

let SetsExtension =
{

}

//

Object.assign( _.set.s, SetsExtension );

})();

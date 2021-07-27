( function _l3_Escape_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

_.escape.escaped = _.escape.escaped || Object.create( null );

// _.assert( _.symbolIs( _.symbol.prototype ) );
// _.assert( _.symbolIs( _.symbol.constructor ) );

// --
// implementation
// --

function isEscapable( src )
{
  if( _.escape._EscapeMap.has( src ) )
  return true;
  if( _.escape.is( src ) )
  return true;
  return false;
}

//

function left( src )
{
  _.assert( arguments.length === 1 );
  if( _.escape._EscapeMap.has( src ) )
  return _.escape._EscapeMap.get( src );
  if( _.escape.is( src ) )
  return new _.Escape( src );
  return src;
}

//

function rightWithNothing( src )
{
  _.assert( arguments.length === 1 );
  if( _.escape.is( src ) )
  return src.val;

  if( src === _.undefined )
  return undefined;
  if( src === _.null )
  return null;

  if( src === _.nothing )
  return undefined;

  return src;
}

//

function rightWithoutNothing( src )
{
  _.assert( arguments.length === 1 );
  if( _.escape.is( src ) )
  return src.val;

  if( src === _.undefined )
  return undefined;
  if( src === _.null )
  return null;

  return src;
}

//

function wrap( src )
{
  _.assert( arguments.length === 1 );
  _.assert( !_.escape.is( src ) );
  return new _.Escape( src );
}

//

function unwrap( src )
{
  _.assert( arguments.length === 1 );
  if( _.escape.is( src ) )
  return src.val;
  return src;
}

// --
// class
// --

let fo = _.wrap.declare({ name : 'Escape' });
_.assert( _.Escape === undefined );
_.assert( _.routineIs( fo.class ) );
_.assert( fo.class.name === 'Escape' );
_.Escape = fo.class;
_.assert( _.mapIs( fo.namespace ) );
Object.assign( _.escape, fo.namespace );

// --
// extension
// --

var Extension =
{
  isEscapable,
  left,
  rightWithNothing,
  rightWithoutNothing,
  right : rightWithNothing,
  wrap,
  unwrap,
}

//

Object.assign( _.escape, Extension );
_.escape.escaped.nothing = _.escape.wrap( _.nothing );
_.escape.escaped.null = _.escape.wrap( _.null );
_.escape.escaped.undefined = _.escape.wrap( _.undefined );

_.escape._EscapeMap = new HashMap();
_.escape._EscapeMap.set( _.nothing, _.escape.escaped.nothing );
_.escape._EscapeMap.set( _.null, _.escape.escaped.null );
_.escape._EscapeMap.set( _.undefined, _.escape.escaped.undefined );
_.escape._EscapeMap.set( undefined, _.undefined );
_.escape._EscapeMap.set( null, _.null );

})();

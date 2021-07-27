( function _Compose_s_()
{

'use strict'; /* xxx : deprecate? */

const _global = _global_;
const _ = _global_.wTools;
// _.compose = _.compose || Object.create( null );
_.routine.chainer = _.routine.chainer || Object.create( null );
_.routine.tail = _.routine.tail || Object.create( null );

// --
// chainer
// --

function originalChainer( /* args, result, fo, k */ )
{
  let args = arguments[ 0 ];
  let result = arguments[ 1 ];
  let fo = arguments[ 2 ];
  let k = arguments[ 3 ];
  _.assert( result !== false );
  return args;
}

//

function originalWithDontChainer( /* args, result, fo, k */ )
{
  let args = arguments[ 0 ];
  let result = arguments[ 1 ];
  let fo = arguments[ 2 ];
  let k = arguments[ 3 ];

  _.assert( result !== false );
  if( result === _.dont )
  return _.dont;
  return args;
}

//

function composeAllChainer( /* args, result, fo, k */ )
{
  let args = arguments[ 0 ];
  let result = arguments[ 1 ];
  let fo = arguments[ 2 ];
  let k = arguments[ 3 ];

  _.assert( result !== false );
  if( result === _.dont )
  return _.dont;
  return args;
}

//

function chainingChainer( /* args, result, fo, k */ )
{
  let args = arguments[ 0 ];
  let result = arguments[ 1 ];
  let fo = arguments[ 2 ];
  let k = arguments[ 3 ];

  _.assert( result !== false );
  if( result === undefined )
  return args;
  if( result === _.dont )
  return _.dont;
  return _.unroll.from( result );
}

// --
// tail
// --

function returningLastTail( args, fo )
{
  // let self = arguments[ 0 ];
  // let args = arguments[ 1 ];
  // let act = arguments[ 2 ];
  // let fo = arguments[ 3 ];
  let self = this;
  let act = fo.act;

  let result = act.apply( self, args );
  return result[ result.length-1 ];
}

//

function composeAllTail( args, fo )
{
  // let self = arguments[ 0 ];
  // let args = arguments[ 1 ];
  // let act = arguments[ 2 ];
  // let fo = arguments[ 3 ];
  let self = this;
  let act = fo.act;

  let result = act.apply( self, args );
  _.assert( !!result );
  if( !result.length )
  return result;
  if( result[ result.length-1 ] === _.dont )
  return false;
  if( !_.all( result ) )
  return false;
  return result;
}

//

function chainingTail( args, fo )
{
  // let self = arguments[ 0 ];
  // let args = arguments[ 1 ];
  // let act = arguments[ 2 ];
  // let fo = arguments[ 3 ];
  let self = this;
  let act = fo.act;

  let result = act.apply( self, args );
  if( result[ result.length-1 ] === _.dont )
  result.pop();
  return result;
}

// --
// declare
// --

let chainer =
{
  original : originalChainer,
  originalWithDont : originalWithDontChainer,
  composeAll : composeAllChainer,
  chaining : chainingChainer,
}

Object.assign( _.routine.chainer, chainer );

let tail =
{
  returningLast : returningLastTail,
  composeAll : composeAllTail,
  chaining : chainingTail,
}

Object.assign( _.routine.tail, tail );

// --
// extend
// --

// let Extension =
// {
//
//   chainer,
//   supervisor
//
// }
//
// Object.assign( Self, Extension );
// /* xxx : qqq : remove */

})();

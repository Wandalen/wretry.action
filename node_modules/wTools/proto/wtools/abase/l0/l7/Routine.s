( function _l7_Routine_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// routine
// --

function routineCallButOnly( /* context, routine, options, but, only */ )
{
  let context = arguments[ 0 ];
  let routine = arguments[ 1 ];
  let options = arguments[ 2 ];
  let but = arguments[ 3 ];
  let only = arguments[ 4 ];

  if( _.routine.is( routine ) || _.strIs( routine ) )
  {

    _.assert( arguments.length === 3 || arguments.length === 4 || arguments.length === 5 );
    _.assert( _.mapIs( options ) );

    if( _.strIs( routine ) )
    routine = context[ routine ];

  }
  else
  {

    routine = arguments[ 0 ];
    options = arguments[ 1 ];
    but = arguments[ 2 ];
    only = arguments[ 3 ];

    _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4 );
    _.assert( _.mapIs( options ) );

  }

  _.assert( _.routine.is( routine ) );

  if( !only )
  only = routine.defaults

  if( but )
  options = _.mapBut_( null, options, but )
  if( only )
  options = _.mapOnly_( null, options, only )

  return routine.call( context, options );
}

//

function _routinesComposeWithSingleArgument_head( routine, args )
{
  let o = _.routine.s.compose.head.call( this, routine, args );

  _.assert( args.length === 1 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  return o;
}

//

function routinesComposeReturningLast()
{
  let o = _.routine.s.composeReturningLast.head( routinesComposeReturningLast, arguments );
  let result = _.routine.s.composeReturningLast.body( o );
  return result;
}

routinesComposeReturningLast.head = _.routine.s.compose.head;
routinesComposeReturningLast.body = _.routine.s.compose.body;
routinesComposeReturningLast.defaults = Object.create( _.routine.s.compose.defaults );

routinesComposeReturningLast.defaults.tail = _.routine.tail.returningLast;

function routinesComposeAll()
{
  let o = _.routine.s.composeAll.head( routinesComposeAll, arguments );
  let result = _.routine.s.composeAll.body( o );
  return result;
}

routinesComposeAll.head = _routinesComposeWithSingleArgument_head;
routinesComposeAll.body = _.routine.s.compose.body;

var defaults = routinesComposeAll.defaults = Object.create( _.routine.s.compose.defaults );
defaults.chainer = _.routine.chainer.composeAll;
defaults.tail = _.routine.tail.composeAll;

_.assert( _.routine.is( _.routine.chainer.originalWithDont ) );
_.assert( _.routine.is( _.routine.tail.composeAll ) );

//

function routinesComposeAllReturningLast()
{
  let o = _.routine.s.composeAllReturningLast.head( routinesComposeAllReturningLast, arguments );
  let result = _.routine.s.composeAllReturningLast.body( o );
  return result;
}

routinesComposeAllReturningLast.head = _routinesComposeWithSingleArgument_head;
routinesComposeAllReturningLast.body = _.routine.s.compose.body;

var defaults = routinesComposeAllReturningLast.defaults = Object.create( _.routine.s.compose.defaults );
defaults.chainer = _.routine.chainer.originalWithDont;
defaults.tail = _.routine.tail.returningLast;

//

function routinesChain()
{
  let o = _.routine.s.chain.head( routinesChain, arguments );
  let result = _.routine.s.chain.body( o );
  return result;
}

routinesChain.head = _routinesComposeWithSingleArgument_head;
routinesChain.body = _.routine.s.compose.body;

var defaults = routinesChain.defaults = Object.create( _.routine.s.compose.defaults );
defaults.chainer = _.routine.chainer.chaining;
defaults.tail = _.routine.tail.chaining;

//

function _equalizerFromMapper( mapper )
{

  if( mapper === undefined )
  mapper = function mapper( a, b ){ return a === b };

  _.assert( 0, 'not tested' )
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( mapper.length === 1 || mapper.length === 2 );

  if( mapper.length === 1 )
  {
    let equalizer = equalizerFromMapper;
    return equalizer;
  }

  return mapper;

  function equalizerFromMapper( a, b )
  {
    return mapper( a ) === mapper( b );
  }
}

//

function _comparatorFromEvaluator( evaluator )
{

  if( evaluator === undefined )
  evaluator = function comparator( a, b ){ return a-b };

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( evaluator.length === 1 || evaluator.length === 2 );

  if( evaluator.length === 1 )
  {
    let comparator = comparatorFromEvaluator;
    return comparator;
  }

  return evaluator;

  function comparatorFromEvaluator( a, b )
  {
    return evaluator( a ) - evaluator( b );
  }
}

// --
// routine extension
// --

let RoutineExtension =
{

  callButOnly : routineCallButOnly, /* qqq : cover please */

  _equalizerFromMapper,
  _comparatorFromEvaluator, /* xxx : move out */

}

Object.assign( _.routine, RoutineExtension );

// --
// routines extension
// --

let RoutinesExtension =
{

  composeReturningLast : routinesComposeReturningLast,
  composeAll : routinesComposeAll,
  composeAllReturningLast : routinesComposeAllReturningLast, /* xxx */
  chain : routinesChain,

}

Object.assign( _.routines, RoutinesExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  routineCallButOnly, /* qqq : cover please */

  routinesComposeReturningLast,
  routinesComposeAll,
  routinesComposeAllReturningLast, /* xxx */
  routinesChain,

  _equalizerFromMapper,
  _comparatorFromEvaluator, /* xxx : move out */

}

Object.assign( _, ToolsExtension );

})();

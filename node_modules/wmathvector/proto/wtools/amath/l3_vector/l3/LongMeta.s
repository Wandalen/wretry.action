(function _LongMeta_s_() {

'use strict';

const _ = _global_.wTools;
const _min = Math.min;
const _max = Math.max;
let _arraySlice = Array.prototype.slice;
let _sqrt = Math.sqrt;
const _sqr = _.math.sqr;

const meta = _.vectorAdapter._meta = _.vectorAdapter._meta || Object.create( null );

// --
// declare
// --

function _routineLongWrap_functor( o )
{

  o = _.routine.options_( _routineLongWrap_functor, arguments );

  if( _.object.isBasic( o.routine ) )
  {
    let result = Object.create( null );
    for( let r in o.routine )
    {
      let optionsForWrapper = _.props.extend( null, o );
      optionsForWrapper.routine = o.routine[ r ];
      result[ r ] = _routineLongWrap_functor( optionsForWrapper );
    }
    return result;
  }

  let op = o.routine.operation;

  /* if routine does not take vector than this is not used at all */

  if( op.takingVectors && op.takingVectors[ 1 ] === 0 )
  o.usingThisAsFirstArgument = 0;

  /* */

  // let onReturn = o.onReturn;
  let usingThisAsFirstArgument = o.usingThisAsFirstArgument ? 1 : 0;
  let theRoutine = o.routine;

  let takingArguments = op.takingArguments;
  let takingVectors = op.takingVectors;
  let takingVectorsOnly = op.takingVectorsOnly;
  let returningSelf = op.returningSelf;
  let returningNew = op.returningNew;
  let returningLong = op.returningLong;
  let modifying = op.modifying;
  let notMethod = op.notMethod;

  /* verification */

  _.assert( _.mapIs( op ) );
  _.assert( _.routineIs( theRoutine ) );
  _.assert( _.numberIs( takingArguments ) || _.arrayIs( takingArguments ) );
  _.assert( _.numberIs( takingVectors ) || _.arrayIs( takingVectors ) );
  _.assert( _.boolIs( takingVectorsOnly ) );
  _.assert( _.boolIs( returningSelf ) );
  _.assert( _.boolIs( returningNew ) );
  _.assert( _.boolIs( returningLong ) );
  _.assert( _.boolIs( modifying ) );

  // _.assert( _.routineIs( onReturn ) );
  _.assert( _.routineIs( theRoutine ) );

  /* adjust */

  if( _.numberIs( takingArguments ) ) takingArguments = Object.freeze([ takingArguments, takingArguments ]);
  else takingArguments = Object.freeze( takingArguments.slice() );

  if( _.numberIs( takingVectors ) )
  takingVectors = Object.freeze([ takingVectors, takingVectors ]);
  else
  takingVectors = Object.freeze( takingVectors.slice() );
  let hasOptionalVectors = takingVectors[ 0 ] !== takingVectors[ 1 ];

  longWrap.notMethod = notMethod;
  longWrap.operation = op;

  return longWrap;

  /* */

  function end( result, theRoutine )
  {
    let op = theRoutine.operation;

    if( op.returningPrimitive && _.primitiveIs( result ) )
    {
      return result;
    }
    else if( op.returningSelf )
    {
      return result.toLong();
    }
    else if( op.returningNew && _.vectorAdapterIs( result ) )
    {
      return result.toLong();
    }
    else if( op.returningLong )
    {
      _.assert( _.arrayIs( result ) || _.bufferTypedIs( result ), 'unexpected' );
      return result;
    }
    else return result;
  }

  /* */

  function makeVector( arg )
  {
    if( _.routineIs( arg ) )
    return arg;

    // if( _hasLength( arg ) && ( !_.Matrix || !( arg instanceof _.Matrix ) ) )
    if( _.longIs( arg ) )
    return _.vectorAdapter.fromLong( arg );
    return arg;
  }

  /* */

  function longWrap()
  {
    let l = arguments.length + usingThisAsFirstArgument;
    let args = new Array( l );

    _.assert( takingArguments[ 0 ] <= l && l <= takingArguments[ 1 ] );

    let s = 0;
    let d = 0;
    if( usingThisAsFirstArgument )
    {
      args[ d ] = this;
      d += 1;
    }

    for( ; d < takingVectors[ 0 ] ; d++, s++ )
    {
      args[ d ] = makeVector( arguments[ s ] );
      _.assert( _.vectorAdapterIs( args[ d ] ) || ( d === 0 && returningNew ) );
    }

    let optionalLength;
    if( hasOptionalVectors )
    {
      optionalLength = _min( takingVectors[ 1 ], l );
      for( ; d < optionalLength ; d++, s++ )
      args[ d ] = makeVector( arguments[ s ] );
    }

    optionalLength = _min( takingArguments[ 1 ], l );
    for( ; d < optionalLength ; d++, s++ )
    args[ d ] = arguments[ s ];

    let result = theRoutine.apply( _.vectorAdapter, args );

    return end.call( this, result, theRoutine );
  }

}

_routineLongWrap_functor.defaults =
{
  usingThisAsFirstArgument : null,
  routine : null,
}

//

function _routinesLongWrap_functor()
{

  let routines = _.vectorAdapter._routinesMathematical;
  for( let r in routines )
  {

    if( _.mapOnlyOwnKey( _.avector, r ) )
    {
      debugger;
      continue;
    }

    _.avector[ r ] = meta._routineLongWrap_functor
    ({
      routine : routines[ r ],
      usingThisAsFirstArgument : 0,
    });

  }

}

// --
// declare extension
// --

let MetaExtension =
{

  _routineLongWrap_functor,
  _routinesLongWrap_functor,

  vectorAdapter : _.vectorAdapter,

}

/* _.props.extend */Object.assign( _.vectorAdapter._meta, MetaExtension );

})();

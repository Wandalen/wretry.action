( function _Basic_s_()
{

'use strict';

let needle = require( 'needle' );
const _ = _global_.wTools;
_.http = _.http || Object.create( null );

// --
// inter
// --

// function retrieve( o )
// {
//   let ops = [];
//   let ready = new _.Consequence().take( null );
//   let opened = 0;
//   let closed = 0;
//
//   if( !_.mapIs( o ) )
//   o = { uri : o }
//   _.routine.options_( retrieve, o );
//
//   if( o.successStatus === null )
//   o.successStatus = [ 200 ];
//   else
//   o.successStatus = _.array.as( o.successStatus );
//
//   let isSingle = !_.arrayIs( o.uri );
//   o.uri = _.array.as( o.uri );
//
//   if( o.openTimeOut === null )
//   o.openTimeOut = o.individualTimeOut;
//   if( o.responseTimeOut === null )
//   o.responseTimeOut = o.individualTimeOut;
//   if( o.readTimeOut === null )
//   o.readTimeOut = o.individualTimeOut;
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.strsAreAll( o.uri ), 'Expects only strings as a package name' );
//   _.assert( o.attemptLimit > 0 );
//   _.assert( o.attemptDelay >= 0 );
//   _.assert( o.openTimeOut >= 0 );
//   _.assert( o.responseTimeOut >= 0 );
//   _.assert( o.readTimeOut >= 0 );
//   _.assert( o.individualTimeOut >= 0 );
//   _.assert( o.concurrentLimit >= 1 );
//
//   /* code before concurrentLimit implementation*/
//   for( let i = 0; i < o.uri.length; i++ )
//   ready.also( () => _request( { uri : o.uri[ i ], attempt : 0, index : i } ) );
//
//   ready.then( ( result ) =>
//   {
//     /* remove heading null */
//     result.splice( 0, 1 )
//     if( isSingle )
//     return result[ 0 ];
//     return result;
//   } );
//   /* code before concurrentLimit implementation*/
//
//   /* concurrentLimit implementation code start */
//   // let firstLimite = o.uri.splice( 0, o.concurrentLimit );
//   // for( let i = 0; i < firstLimite.length; i++ )
//   // ready.also( () => _request( { uri : firstLimite[ i ], attempt : 0, index : i } ) );
//
//   // ready.then( ( result ) =>
//   // {
//   //   /* remove heading null */
//   //   result.splice( 0, 1 )
//   //   if( isSingle )
//   //   return result[ 0 ];
//   //   return result;
//   // } );
//   /* concurrentLimit implementation code end */
//
//   if( o.sync )
//   {
//     ready.deasync();
//     return ready.sync();
//   }
//
//   return ready;
//
//   /* */
//
//   function retry( op )
//   {
//     op.attempt += 1;
//     delete op.err;
//     _.time.begin( o.attemptDelay, () => _request( op ) );
//   }
//
//   /* */
//
//   function _request( op )
//   {
//
//     if( !op.ready )
//     op.ready = new _.Consequence();
//
//     if( op.attempt === 0 )
//     opened += 1;
//
//     if( op.attempt >= o.attemptLimit )
//     throw _.err( `Failed to retrieve ${op.uri}, made ${op.attempt} attemptLimit` );
//
//     ops[ op.index ] = op;
//     if( o.verbosity >= 3 )
//     console.log( ` . Attempt ${op.attempt} to retrieve ${op.index} ${op.uri}..` );
//
//     let o2 =
//     {
//       open_timeout : o.openTimeOut,
//       response_timeout : o.responseTimeOut,
//       read_timeout : o.readTimeOut,
//     }
//
//     needle.get( op.uri, o2, function( err, response )
//     {
//       op.err = err;
//       op.response = response;
//       if( err )
//       return retry( op );
//       if( !_.longHas( o.successStatus, op.response.statusCode ) )
//       return retry( op );
//       if( o.onSuccess && !o.onSuccess( op ) )
//       return retry( op );
//       handleEnd( op );
//     } );
//
//     return op.ready;
//   }
//
//   /* */
//
//   function handleEnd( op )
//   {
//     closed += 1;
//     if( o.verbosity >= 3 )
//     console.log( ` + Retrieved ${op.index} ${closed} / ${opened} ${op.uri}.` );
//
//     // // concurrentLimit code start
//     // if( o.uri.length )
//     // ready.also( () => _request( { uri : o.uri.splice( 0, 1 )[ 0 ], attempt : 0, index : 0 } ) );
//     // // concurrentLimit code end
//
//     op.ready.take( op );
//   }
//
// }
//
// retrieve.defaults = /* qqq : cover */
// {
//   uri : null,
//   verbosity : 0,
//   successStatus : null,
//   sync : 0,
//   onSuccess : null,
//   attemptLimit : 3,
//   attemptDelay : 100,
//   openTimeOut : null,
//   responseTimeOut : null,
//   readTimeOut : null,
//   individualTimeOut : 10000,
//   concurrentLimit : 256, /* qqq : implement and cover option concurrentLimit */
// }

function retrieve( o )
{
  let ops = [];
  let ready = new _.Consequence().take( null );
  let opened = 0;
  let closed = 0;

  if( !_.mapIs( o ) )
  o = { uri : o };

  _.routine.options_( retrieve, o );

  if( o.successStatus === null )
  o.successStatus = [ 200 ];
  else
  o.successStatus = _.array.as( o.successStatus );

  let isSingle = !_.arrayIs( o.uri );
  o.uri = _.array.as( o.uri );

  if( o.openTimeOut === null )
  o.openTimeOut = o.individualTimeOut;
  if( o.responseTimeOut === null )
  o.responseTimeOut = o.individualTimeOut;
  if( o.readTimeOut === null )
  o.readTimeOut = o.individualTimeOut;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strsAreAll( o.uri ), 'Expects only strings as a package name' );
  // _.assert( o.attemptLimit > 0 );
  // _.assert( o.attemptDelay >= 0 );
  _.assert( o.openTimeOut >= 0 );
  _.assert( o.responseTimeOut >= 0 );
  _.assert( o.readTimeOut >= 0 );
  _.assert( o.individualTimeOut >= 0 );
  _.assert( o.concurrentLimit >= 1 );

  /* code before concurrentLimit implementation*/
  for( let i = 0; i < o.uri.length; i++ )
  {
    opened +=1;
    ready.also( () => _request( { uri : o.uri[ i ], attempt : 0, index : i } ) );
  }

  ready.then( ( result ) =>
  {
    /* remove heading null */
    result.splice( 0, 1 )
    if( isSingle )
    return result[ 0 ];
    return result;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function _request( op )
  {
    return _.retry
    ({
      routine : () => _retrieve( op ),
      attemptLimit : o.attemptLimit,
      attemptDelay : o.attemptDelay,
      attemptDelayMultiplier : o.attemptDelayMultiplier,
      defaults : _.remote.attemptDefaults,
    });
  }

  /* */

  function _retrieve( op )
  {
    op.ready = new _.Consequence();

    op.attempt += 1;
    ops[ op.index ] = op;

    if( o.verbosity >= 3 )
    console.log( ` . Attempt ${op.attempt} to retrieve ${op.index} ${op.uri}..` );

    let o2 =
    {
      open_timeout : o.openTimeOut,
      response_timeout : o.responseTimeOut,
      read_timeout : o.readTimeOut,
    };

    needle.get( op.uri, o2, ( err, response ) =>
    {
      op.err = err;
      op.response = response;
      if( err )
      return op.ready.error( _.err( err ) );
      if( !_.longHas( o.successStatus, op.response.statusCode ) )
      return op.ready.error( _.err( `Unexpected status code: ${ op.response.statusCode }` ) );
      if( o.onSuccess && !o.onSuccess( response ) )
      return op.ready.error( _.err( 'Callback {-o.onSuccess-} accept no response' ) );
      return handleEnd( op );
    });

    return op.ready;
  }

  /* */

  function handleEnd( op )
  {
    closed += 1;
    if( o.verbosity >= 3 )
    console.log( ` + Retrieved ${op.index} ${closed} / ${opened} ${op.uri}.` );

    op.ready.take( op );
  }

}

retrieve.defaults = /* qqq : cover */
{
  uri : null,
  verbosity : 0,
  successStatus : null,
  sync : 0,
  onSuccess : null,
  openTimeOut : null,
  responseTimeOut : null,
  readTimeOut : null,
  individualTimeOut : 10000,
  concurrentLimit : 256, /* qqq : implement and cover option concurrentLimit */

  attemptLimit : null,
  attemptDelay : null,
  attemptDelayMultiplier : null,
};

// --
// declare
// --

let Extension =
{

  protocols : [ 'http', 'https' ],

  retrieve,

}

/* _.props.extend */Object.assign( _.http, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();

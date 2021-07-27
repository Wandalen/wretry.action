( function _l7_Process_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.process = _.process || Object.create( null );

// --
// implementation
// --

/**
 * The routine ready() delays execution of code to moment when web-page ( or program itself ) is loaded.
 * Optionally routine accept additional time out {-timeOut-} and callback {-onReady-} to execute after
 * loading.
 *
 * @example
 * let result = [];
 * _.process.ready();
 * // the code will continue execution when the page is loaded
 *
 * @example
 * let result = [];
 * let onReady = () => result.push( 'ready' );
 * _.process.ready( 500, onReady );
 * // the code will continue execution when the page is loaded and simultaneously routine adds delayed
 * // execution of callback `onReady`
 *
 * First parameter set :
 * @param { Number } timeOut - The time delay.
 * @param { Function } onReady - Callback to execute.
 * Second parameter set :
 * @param { Map|Aux } o - Options map.
 * @param { Number } o.timeOut - The time delay.
 * @param { Function } o.onReady - Callback to execute.
 * @returns { Undefined } - Returns not a value, executes code when a web-page is ready.
 * @function ready
 * @throws { Error } If arguments.length is greater than 2.
 * @throws { Error } If {-timeOut-} has defined non integer value or not finite value.
 * @namespace wTools.process
 * @extends Tools
 */

function ready_head( routine, args )
{
  let o = args[ 0 ];
  if( !_.mapIs( o ) )
  {
    o = Object.create( null );

    if( args.length === 2 )
    {
      o.timeOut = args[ 0 ];
      o.onReady = args[ 1 ];
    }
    else
    {
      o.onReady = args[ 0 ];
    }
  }

  _.routine.options( routine, o );

  if( !o.timeOut )
  o.timeOut = 0;

  _.assert( 0 <= args.length || args.length <= 2 );
  _.assert( _.intIs( o.timeOut ) );
  _.assert( _.routine.is( o.onReady ) || o.onReady === null || o.onReady === undefined );

  return o;
}

//

function ready_body( o )
{

  if( typeof window !== 'undefined' && typeof document !== 'undefined' && document.readyState !== 'complete' )
  window.addEventListener( 'load', handleReady );
  else
  handleReady();

  /* */

  function handleReady()
  {
    _.time.begin( o.timeOut, o.onReady );
  }
}

ready_body.defaults =
{
  timeOut : 0,
  onReady : null,
};

//

let ready = _.routine.unite( ready_head, ready_body );

// --
// declaration
// --

let Extension =
{

  ready,

}

Object.assign( _.process, Extension );

})();

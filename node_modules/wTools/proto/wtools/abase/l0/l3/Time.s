( function _l3_Time_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function _sleep( delay )
{
  _.assert( _.intIs( delay ) && delay >= 0, 'Specify valid value {-delay-}.' );
  let now = _.time.now();
  while( ( _.time.now() - now ) < delay )
  {
    if( Math.random() === 0 );
  }
}

//

/**
 * The routine sleep() suspends program execution on time delay {-delay-}.
 *
 * @example
 * let result = [];
 * let periodic = _.time.periodic( 100, () => result.length < 10 ? result.push( 1 ) : undefined );
 * let before = _.time.now();
 *  _.time.sleep( 500 );
 * console.log( result.length <= 1 );
 * // log : true
 * let after = _.time.now();
 * let delta = after - before;
 * console.log( delta <= 550 );
 * // log : true
 *
 * @param { Number } delay - The delay to suspend program.
 * @returns { Undefined } - Returns not a value, suspends program.
 * @function sleep
 * @throws { Error } If arguments.length is less then 1 or great then 2.
 * @throws { Error } If {-delay-} is not a Number.
 * @throws { Error } If {-delay-} is less then zero.
 * @throws { Error } If {-delay-} has not finite value.
 * @namespace wTools.time
 * @extends Tools
 */

function sleep( delay )
{
  _.assert( arguments.length === 1 );
  _.time._sleep.apply( this, arguments );
}

//

/**
 * The routine from() returns the time since 01.01.1970 in ms.
 *
 * @example
 * let date = new Date();
 * console.log( _.time.from( date ) );
 * // log : 1603174830154
 *
 * @param { Number|Date|String } time - The time to convert.
 * @returns { Number } - Returns time since 01.01.1970.
 * @function from
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-time-} neither is a Number, nor a Date, nor a valid time String.
 * @namespace wTools.time
 * @extends Tools
 */

function from( time )
{

  _.assert( arguments.length === 1 );

  if( _.number.is( time ) )
  {
    return time;
  }
  if( _.date.is( time ) )
  {
    return time.getTime();
  }
  if( _.strIs( time ) )
  {
    time = Date.parse( time );
    if( !isNaN( time ) )
    return time;
    else
    _.assert( 0, 'Wrong time format' );
  }
  _.assert( 0, 'Not clear how to coerce to time', _.entity.strType( time ) );
}

// --
// extension
// --

let TimeExtension =
{

  _sleep,
  sleep,

  from,

}

//

Object.assign( _.time, TimeExtension );

})();

( function _l5_Time_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

/**
 * The routine spent() calculate spent time from time {-time-} and converts
 * the value to formatted string with seconds. If the description {-description-}
 * is provided, then routine prepend description to resulted string.
 *
 * @example
 * let now = _time.now();
 * _.time.sleep( 500 );
 * let spent = _.time.spent( 'Spent : ', now );
 * console.log( spent );
 * // log : 'Spent : 0.5s'
 *
 * @param { String } description - The description for spent time. Optional parameter.
 * @param { Number } time - The start time.
 * @returns { Number } - Returns string with spent seconds.
 * @function spent
 * @throws { Error } If arguments.length is less than 1 or greater than 2.
 * @throws { Error } If {-description-} is not a String.
 * @throws { Error } If {-time-} is not a Number.
 * @namespace wTools.time
 * @extends Tools
 */

/* qqq : introduce namespace _.units */
/* xxx : expose units formatter interface in wTools */
/* qqq xxx : use units formatters */
function spent( description, time )
{
  let now = _.time.now();

  if( arguments.length === 1 )
  {
    time = arguments[ 0 ];
    description = '';
  }

  _.assert( 1 <= arguments.length && arguments.length <= 2 );
  _.assert( _.number.is( time ) );
  _.assert( _.strIs( description ) );

  let result = description + _.time.spentFormat( now-time );

  return result;
}

//

/**
 * The routine spentFormat() converts spent time in milliseconds to seconds.
 * Routine returns string with seconds.
 *
 * @example
 * let now = _time.now();
 * _.time.sleep( 500 );
 * let spent = _.time.now() - now;
 * console.log( _.time.spentFormat( spent ) );
 * // log : '0.5s'
 *
 * @param { Number } spent - The time to convert, in ms.
 * @returns { Number } - Returns string with spent seconds.
 * @function spentFormat
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-spent-} is not a Number.
 * @namespace wTools.time
 * @extends Tools
 */

function spentFormat( spent )
{

  _.assert( 1 === arguments.length );
  _.assert( _.number.is( spent ) );

  let result = ( 0.001*( spent ) ).toFixed( 3 ) + 's';

  return result;
}

// --
// extension
// --

let TimeExtension =
{

  spent,
  spentFormat,

}

//

_.props.supplement( _.time, TimeExtension );

})();

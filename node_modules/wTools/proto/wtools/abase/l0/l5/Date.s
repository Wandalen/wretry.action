( function _l5_Date_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.date = _.date || Object.create( null );

// --
// dichotomy
// --

/**
 * The routine dateToStr() converts Date object {-date-} to formatted string.
 * The format is : YYYY.MM.DD
 *
 * @example
 * let date = new Date();
 * console.log( _.time.dateToStr( date ) );
 * // log : '2020.10.20'
 *
 * @param { Date } date - The date to convert.
 * @returns { String } - Returns date in string format.
 * @function dateToStr
 * @namespace wTools.time
 * @extends Tools
 */

function toStr( date )
{
  debugger;
  let y = date.getFullYear();
  let m = date.getMonth() + 1;
  let d = date.getDate();
  if( m < 10 ) m = '0' + m;
  if( d < 10 ) d = '0' + d;
  let result = [ y, m, d ].join( '.' );
  return result;
}

// --
// extension
// --

let ToolsExtension =
{
  dateToStr : toStr
}

//

let Extension =
{
  toStr,
}

//

Object.assign( _, ToolsExtension );
Object.assign( Self, Extension );

})();

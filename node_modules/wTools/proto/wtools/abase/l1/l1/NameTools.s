( function _NameTools_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

const _ArraySlice = Array.prototype.slice;
const _FunctionBind = Function.prototype.bind;
const _ObjectToString = Object.prototype.toString;
const _ObjectHasOwnProperty = Object.hasOwnProperty;

// --
// name and symbol
// --

// /**
//  * Produce fielded name from string.
//  * @param {string} nameString - object coded name or string.
//  * @return {object} nameKeyValue - name in key/value format.
//  * @method nameFielded
//  * @namespace Tools
//  */
//
// function nameFielded( nameString )
// {
//
//   if( _.object.isBasic( nameString ) )
//   {
//     return nameString;
//   }
//   else if( _.strIs( nameString ) )
//   {
//     var name = {};
//     name[ nameString ] = nameString;
//     return name;
//   }
//   else _.assert( 0, 'nameFielded :', 'Expects string or ' );
//
// }

//

/**
 * Returns name splitted in coded/raw fields.
 * @param {object} nameObject - fielded name or name as string.
 * @return {object} name splitted in coded/raw fields.
 * @method nameUnfielded
 * @namespace Tools
 */

function nameUnfielded( nameObject )
{
  var name = {};

  if( _.mapIs( nameObject ) )
  {
    var keys = Object.keys( nameObject );
    _.assert( keys.length === 1 );
    name.coded = keys[ 0 ];
    name.raw = nameObject[ name.coded ];
  }
  else if( _.strIs( nameObject ) )
  {
    name.raw = nameObject;
    name.coded = nameObject;
  }
  else if( _.symbol.is( nameObject ) )
  {
    name.raw = nameObject;
    name.coded = nameObject;
  }
  else _.assert( 0, 'nameUnfielded :', 'Unknown arguments' );

  // _.assert( arguments.length === 1 );
  // _.assert( _.strIs( name.raw ) || _.symbol.is( name.raw ), 'nameUnfielded :', 'not a string, something wrong :', nameObject );
  // _.assert( _.strIs( name.coded ) || _.symbol.is( name.coded ), 'nameUnfielded :', 'not a string, something wrong :', nameObject );

  return name;
}

// //
//
// /**
//  * Returns name splitted in coded/coded fields. Drops raw part replacing it by coded.
//  * @param {object} namesMap - fielded names.
//  * @return {object} expected map.
//  * @method namesCoded
//  * @namespace Tools
//  */
//
// function namesCoded( namesMap )
// {
//   var result = {}
//
//   if( _.assert )
//   _.assert( arguments.length === 1 );
//   if( _.assert )
//   _.assert( _.object.isBasic( namesMap ) );
//
//   for( var n in namesMap )
//   result[ n ] = n;
//
//   return result;
// }

// --
// id
// --

function idWithOnlyDate( prefix, postfix )
{
  var date = new Date;

  _.assert( 0 <= arguments.length && arguments.length <= 2 );

  prefix = prefix ? prefix : '';
  postfix = postfix ? postfix : '';

  var d =
  [
    date.getFullYear(),
    date.getMonth()+1,
    date.getDate(),
  ].join( '-' );

  return prefix + d + postfix
}

//

function idWithDateAndTime( prefix, postfix, fast )
{
  var date = new Date;

  _.assert( 0 <= arguments.length && arguments.length <= 3 );

  prefix = prefix ? prefix : '';
  postfix = postfix ? postfix : '';

  if( fast )
  return prefix + date.valueOf() + postfix;

  var d =
  [
    date.getFullYear(),
    date.getMonth()+1,
    date.getDate(),
    date.getHours(),
    date.getMinutes(),
    date.getSeconds(),
    date.getMilliseconds(),
    Math.floor( Math.random()*0x10000 ).toString( 16 ),
  ].join( '-' );

  return prefix + d + postfix
}

//

function idWithTime( prefix, postfix )
{
  var date = new Date;

  _.assert( 0 <= arguments.length && arguments.length <= 2 );

  prefix = prefix ? prefix : '';
  postfix = postfix ? postfix : '';

  var d =
  [
    String( date.getHours() ) + String( date.getMinutes() ) + String( date.getSeconds() ),
    String( date.getMilliseconds() ),
    Math.floor( Math.random()*0x10000 ).toString( 16 ),
  ].join( '-' );

  return prefix + d + postfix
}

//

/* aaa : reimplement it more properly | Dmytro : new implementation is written below, it use futures of random RFC4122 GUIDs v4. Guids can be more complex for example https://www.npmjs.com/package/uuid */

function idWithGuid()
{

  _.assert( arguments.length === 0 );

  var result =
  [
    s4() + s4(),
    s4(),
    s4(),
    s4(),
    s4() + s4() + s4(),
  ].join( '-' );

  return result;

  function s4()
  {
    return Math.floor( ( 1 + Math.random() ) * 0x10000 )
    .toString( 16 )
    .substring( 1 );
  }

}

//

// function idWithGuid()
// {
//   let guid = '$$$$$$$$-$$$$-4$$$-y$$$-$$$$$$$$$$$$';
//
//   return guid.replace( /[$y]/g, replaceSymbol );
//
//   /* */
//
//   function replaceSymbol( sym )
//   {
//     let r = Math.random() * 16 | 0;
//     return ( sym === '$' ? r : ( r & 0x3 | 0x8 ) ).toString( 16 );
//   }
// }

//

/**
 * Routine idWithTimeGuid() returns random GUID of RFC4122 standard.
 * GUID v4 is used.
 * Routine does not accepts parameters.
 *
 * @example
 * _.idWithTimeGuid()
 * // returns '0d796bf0-dc89-4ccd-b751-01430f6ec71f'
 *
 * @return { String } - Returns GUID v4.
 * @function idWithTimeGuid
 * @namespace Tools
 */

function idWithTimeGuid()
{
  let guid = '$$$$$$$$-$$$$-4$$$-y$$$-$$$$$$$$$$$$';
  let date = _.time.now();

  _.assert( arguments.length === 0 );

  return guid.replace( /[$y]/g, replaceSymbol );

  /* */

  function replaceSymbol( sym )
  {
    let r = ( date + Math.random() * 16 ) % 16 | 0;
    date = Math.floor( date / 16 );
    return ( sym === '$' ? r : ( r & 0x3 | 0x8 ) ).toString( 16 );
  }
}

//

var idWithInt = (function()
{

  var counter = 0;

  return function()
  {
    _.assert( arguments.length === 0, 'Expects no arguments' );
    counter += 1;
    return counter;
  }

})();

// --
// declare
// --

const Proto =
{

  // name and symbol

  // nameFielded, /* experimental */
  nameUnfielded, /* xxx : move */
  // namesCoded, /* experimental */

  // id

  idWithOnlyDate,
  idWithDateAndTime,
  idWithTime,
  idWithGuid,
  idWithTimeGuid,
  idWithInt,

}

_.props.extend( _, Proto );

})();

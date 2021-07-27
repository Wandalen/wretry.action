( function _l1_Type_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _global_.wTools;

// --
// type test
// --

function undefinedIs( src )
{
  if( src === undefined )
  return true;
  return false;
}

//

function nullIs( src )
{
  if( src === null )
  return true;
  return false;
}

//

function nothingIs( src )
{
  if( src === null )
  return true;
  if( src === undefined )
  return true;
  if( src === _.nothing )
  return true;
  return false;
}

//

function definedIs( src )
{
  return src !== undefined && src !== null && !Number.isNaN( src ) && src !== _.nothing;
}

//

// function primitiveIs( src )
// {
//   if( !src )
//   return true;
//   let t = Object.prototype.toString.call( src );
//   return t === '[object Symbol]' || t === '[object Number]' || t === '[object BigInt]' || t === '[object Boolean]' || t === '[object String]';
// }

//

function consequenceIs( src )
{
  if( !src )
  return false;

  let prototype = Object.getPrototypeOf( src );

  if( !prototype )
  return false;

  return prototype.shortName === 'Consequence';
}

//

function consequenceLike( src )
{
  if( _.consequenceIs( src ) )
  return true;

  if( _.promiseIs( src ) )
  return true;

  return false;
}

//

function promiseIs( src )
{
  if( !src )
  return false;
  return src instanceof Promise;
}

//

function promiseLike( src )
{
  if( !src )
  return false;
  // if( !_.object.isBasic( src ) )
  // return false;
  return _.routine.is( src.then ) && _.routine.is( src.catch ) && ( src.constructor ) && ( src.constructor.name !== 'wConsequence' );
}

//

function typeOf( src, constructor )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  {
    return _.typeOf( src ) === constructor;
  }

  if( src === null || src === undefined )
  {
    return null;
  }
  else if( _.number.is( src ) || _.bool.is( src ) || _.strIs( src ) ) /* yyy */
  {
    return src.constructor;
  }
  else if( src.constructor )
  {
    _.assert( _.routine.is( src.constructor ) && src instanceof src.constructor );
    return src.constructor;
  }
  else
  {
    return null;
  }

}

// //
//
// function prototypeIsStandard( src )
// {
//
//   if( !_.workpiece.prototypeIs( src ) )
//   return false;
//
//   if( !Object.hasOwnProperty.call( src, 'Composes' ) )
//   return false;
//
//   return true;
// }

//

/**
 * Checks if argument( cls ) is a constructor.
 * @function constructorIs
 * @param {Object} cls - entity to check
 * @namespace Tools
 */

function constructorIs( cls )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.routine.is( cls ) && !instanceIs( cls );
}

//

/**
 * Is instance of a class.
 * @function instanceIs
 * @param {object} src - entity to check
 * @namespace Tools
 */

function instanceIs( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.primitive.is( src ) )
  return false;

  if( Object.hasOwnProperty.call( src, 'constructor' ) )
  return false;
  if( !Reflect.has( src, 'constructor' ) )
  return false;

  let prototype = Object.getPrototypeOf( src );
  _.assert( prototype !== undefined );

  if( prototype === null )
  return false;
  // if( prototype === undefined )
  // return false;
  if( prototype === Object.prototype )
  return false;
  if( _.routine.is( prototype ) )
  return false;

  // return Object.hasOwnProperty.call( prototype, 'constructor' );

  return true;
}

//

function workerIs( src )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( arguments.length === 1 )
  {
    if( typeof WorkerGlobalScope !== 'undefined' && src instanceof WorkerGlobalScope )
    return true;
    if( typeof Worker !== 'undefined' && src instanceof Worker )
    return true;
    return false;
  }
  else
  {
    return typeof WorkerGlobalScope !== 'undefined';
  }
}

//

function streamIs( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.object.isBasic( src ) && _.routine.is( src.pipe )
}

//
// xxx : remove from here
//
// function consoleIs( src )
// {
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   if( console.Console )
//   if( src && src instanceof console.Console )
//   return true;
//
//   if( src !== console )
//   return false;
//
//   let result = Object.prototype.toString.call( src );
//   if( result === '[object Console]' || result === '[object Object]' )
//   return true;
//
//   return false;
// }
//
// //
//
// function loggerIs( src )
// {
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   if( !_.Logger )
//   return false;
//
//   if( src instanceof _.Logger )
//   return true;
//
//   return false;
// }

//

function processIs( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  // let type = _.entity.strType( src );
  let type = _.entity.strTypeSecondary( src );
  if( type === 'ChildProcess' || type === 'process' )
  return true;

  return false;
}

//

function procedureIs( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( !src )
  return false;
  if( !_.Procedure )
  return false;
  return src instanceof _.Procedure;
}

//

function definitionIs( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !src )
  return false;

  if( !_.Definition )
  return false;

  return src instanceof _.Definition;
}

//

function traitIs( trait )
{
  if( !_.definitionIs( trait ) )
  return false;
  return trait.defGroup === 'trait';
}

//

function blueprintIsDefinitive( blueprint )
{
  if( !blueprint )
  return false;
  if( !_.blueprint.isDefinitive )
  return false;
  return _.blueprint.isDefinitive( blueprint );
}

//

function blueprintIsRuntime( blueprint )
{
  if( !blueprint )
  return false;
  if( !_.blueprint.isRuntime )
  return false;
  return _.blueprint.isRuntime( blueprint );
}

// --
// implementation
// --

let ToolsExtension =
{

  // primitive

  undefinedIs,
  nullIs,
  nothingIs,
  definedIs,

  //

  consequenceIs,
  consequenceLike,
  promiseIs,
  promiseLike,

  typeOf,
  constructorIs,
  instanceIs,

  workerIs,
  streamIs,
  // consoleIs,
  // loggerIs,
  processIs,
  procedureIs,

  definitionIs, /* xxx : move to namespace::property */
  traitIs, /* xxx : move to namespace::property */

  blueprintIsDefinitive,
  blueprintIsRuntime,

}

//

Object.assign( _, ToolsExtension );

})();

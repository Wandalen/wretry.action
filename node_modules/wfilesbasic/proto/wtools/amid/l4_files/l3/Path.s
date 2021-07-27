( function _Path_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

_.assert( _.object.isBasic( _.path ) );

let vectorizeKeysAndVals = _.files._.vectorizeKeysAndVals;
let vectorize = _.files._.vectorize;
let vectorizeAll = _.files._.vectorizeAll;
let vectorizeAny = _.files._.vectorizeAny;
let vectorizeNone = _.files._.vectorizeNone;

// // --
// // functor
// // --
//
// function _vectorizeKeysAndVals( routine, select )
// {
//   select = select || 1;
//
//   let routineName = routine.name;
//
//   _.assert( _.routineIs( routine ) );
//   _.assert( _.strDefined( routineName ) );
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//
//   let routine2 = _.routineVectorize_functor
//   ({
//     routine : [ routineName ],
//     vectorizingArray : 1,
//     vectorizingMapVals : 1,
//     vectorizingMapKeys : 1,
//     select : select,
//   });
//
//   _.routineExtend( routine2, routine );
//
//   return routine2;
// }
// zzz : clean

// --
// implementation
// --

function like( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( this.is( path ) )
  return true;
  if( _.files.FileRecord )
  if( path instanceof _.files.FileRecord )
  return true;
  return false;
}

//

/**
 * Returns absolute path to file. Accepts file record object. If as argument passed string, method returns it.
 * @example
 * let str = 'foo/bar/baz',
    fileRecord = FileRecord( str );
   let path = wTools.path.from( fileRecord ); // '/home/user/foo/bar/baz';
 * @param {string|wFileRecord} src file record or path string
 * @returns {string}
 * @throws {Error} If missed argument, or passed more then one.
 * @throws {Error} If type of argument is not string or wFileRecord.
 * @function from
 * @namespace wTools.path
 * @module Tools/mid/Files
 */

function from( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.strIs( src ) )
  return src;
  else if( src instanceof _.files.FileRecord )
  return src.absolute;
  else _.assert( 0, 'Expects string, but got', _.entity.strType( src ) );

}

//

/**
 * @summary Converts source path `src` to platform-specific path.
 * @param {String} src Source path.
 * @function nativize
 * @namespace wTools.path
 * @module Tools/mid/Files
*/

function nativize( src )
{
  _.assert( arguments.length === 1 );

  if( this.fileProvider )
  {
    _.assert( !!this.fileProvider );
    _.assert( _.routineIs( this.fileProvider.pathNativizeAct ) );
    return this.fileProvider.pathNativizeAct( src );
  }
  else
  {
    let nativize;
    if( _global.process && _global.process.platform === 'win32' )
    nativize = this._nativizeWindows;
    else
    nativize = this._nativizePosix;
    return nativize.apply( this, arguments );
  }

}

//

/**
 * Returns the current working directory of the Node.js process. If as argument passed path to existing directory,
   method sets current working directory to it. If passed path is an existing file, method set its parent directory
   as current working directory.
 * @param {string} [path] path to set current working directory.
 * @returns {string}
 * @throws {Error} If passed more than one argument.
 * @throws {Error} If passed path to not exist directory.
 * @function current
 * @namespace wTools.path
 * @module Tools/mid/Files
 */

function current()
{
  let path = this;
  let provider = this.fileProvider;

  _.assert( _.object.isBasic( provider ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.routineIs( provider.pathCurrentAct ) );
  _.assert( _.routineIs( path.isAbsolute ) );

  if( arguments[ 0 ] )
  try
  {

    let filePath = arguments[ 0 ];
    _.assert( _.strIs( filePath ), 'Expects string' );

    if( !path.isAbsolute( filePath ) )
    filePath = path.join( provider.pathCurrentAct(), filePath );

    if( provider.fileExists( filePath ) && provider.isTerminal( filePath ) )
    filePath = path.resolve( filePath, '..' );

    provider.pathCurrentAct( filePath );

  }
  catch( err )
  {
    throw _.err( 'File was not found : ' + arguments[ 0 ] + '\n', err );
  }

  let result = provider.pathCurrentAct();

  _.assert( _.strIs( result ) );

  result = path.normalize( result );

  return result;
}

//

/**
 * @summary Converts global path `globalPath` to local.
 * @param {String} globalPath Source path.
 * @function preferredFromGlobal
 * @namespace wTools.path
 * @module Tools/mid/Files
*/

function preferredFromGlobal( globalPath )
{
  let path = this;
  let provider = this.fileProvider;
  return provider.preferredFromGlobalAct( globalPath );
}

//

/**
 * @summary Converts local path `localPath` to global.
 * @param {String} localPath Source path.
 * @function globalFromPreferred
 * @namespace wTools.path
 * @module Tools/mid/Files
*/

function globalFromPreferred( localPath )
{
  let path = this;
  let provider = this.fileProvider;
  return provider.globalFromPreferredAct( localPath );
}

//

function hasLocally( filePath )
{
  let path = this;
  let provider = this.fileProvider;

  if( !path.isGlobal( filePath ) )
  return true;

  let parsed = _.uri.parse( filePath );

  if( !parsed.protocol )
  return true;

  if( _.longHas( provider.protocols, parsed.protocol ) )
  return true;

  return false;
}

// --
// declare
// --

let Extension =
{

  like,

  from,

  preferredFromGlobal,
  localsFromGlobals : vectorizeKeysAndVals( preferredFromGlobal ),
  globalFromPreferred,
  globalsFromLocals : vectorizeKeysAndVals( globalFromPreferred ),

  nativize,
  current,
  hasLocally,

}

/* _.props.extend */Object.assign( _.path, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _.path;

})();

( function _StatNamespace_s_()
{

'use strict';

let File;

if( typeof module !== 'undefined' )
{

  try
  {
    if( Config.interpreter === 'njs' )
    File = require( 'fs' );
  }
  catch( err )
  {
  }

}

/**
 * @namespace wTools.files.stat
 * @module Tools/mid/Files
 */

const _global = _global_;
const _ = _global_.wTools;
const Self = _.files.stat = _.files.stat || Object.create( null );

// --
//
// --

/**
 * @summary Returns true if entity `src` is a file stats object.
 * @param {Object} src Entity to check.
 * @function fileStatIs
 * @namespace wTools/files
 * @module Tools/mid/Files
 */

function fileStatIs( src )
{
  if( File )
  if( src instanceof File.Stats )
  return true;
  if( _.files.FileStat )
  if( src instanceof _.files.FileStat )
  return true;
  let proto = Object.getPrototypeOf( File.Stats );
  if( proto.name && src instanceof proto )
  return true;
  return false;
}

//

/**
 * @summary Determines if two files have different content by comparing their stat object.
 * @description Returns `true` if files have different concents, `false` if files have same concent and `null` if result is not precise.
 * @param {Object} stat1 Stat object of first file.
 * @param {Object} stat2 Stat object of second file.
 * @function different
 * @namespace wTools/files
 * @module Tools/mid/Files
 */

function different( stat1, stat2 )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.bigIntIs( stat1.ino ) )
  if( stat1.ino === stat2.ino )
  return false;

  if( stat1.size !== stat2.size )
  return true;

  if( stat1.size === 0 || stat2.size === 0 )
  return null;

  return null;
}

//

/**
 * @summary Determines if two files are hard linked by comparing their stat object.
 * @description Returns `true` if files have different concents, `false` if files have same concent and `null` if result is not precise.
 * @param {Object} stat1 Stat object of first file.
 * @param {Object} stat2 Stat object of second file.
 * @function areHardLinked
 * @namespace wTools/files
 * @module Tools/mid/Files
 */

function areHardLinked( stat1, stat2 )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.fileStatIs( stat1 ) );
  _.assert( _.fileStatIs( stat2 ) );

  /*
  ino comparison is not reliable test on nodejs below 10.5
  it's reliable only if ino is BigNumber
  */

  if( _.bigIntIs( stat1.ino ) )
  return stat1.ino === stat2.ino;

  if( stat1.ino !== stat2.ino )
  return false;

  /*
  try to make a good guess if ino comprison is not possible
  */

  /* notes :
    should return true for comparing file with itself
    so nlink could be 1
  */

  if( stat1.nlink !== stat2.nlink )
  return false;

  if( stat1.mode !== stat2.mode )
  return false;

  if( stat1.size !== stat2.size )
  return false;

  if( stat1.mtime && stat2.mtime )
  if( stat1.mtime.getTime() !== stat2.mtime.getTime() )
  return false;

  if( stat1.ctime && stat2.ctime )
  if( stat1.ctime.getTime() !== stat2.ctime.getTime() )
  return false;

  if( stat1.birthtime && stat2.birthtime )
  if( stat1.birthtime.getTime() !== stat2.birthtime.getTime() )
  return false;

  return _.maybe;
}

//

/**
 * @summary Generates hash from stat object.
 * @param {Object} stat Stat object.
 * @function hashStatFrom
 * @namespace wTools/files
 * @module Tools/mid/Files
 */

function hashStatFrom( stat )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.bigIntIs( stat.ino ) )
  return stat.ino;

  let ino = stat.ino || 0;
  let mtime = stat.mtime.getTime();
  let ctime = stat.ctime.getTime();

  _.assert( _.numberIs( mtime ) );
  _.assert( _.numberIs( ctime ) );
  _.assert( _.numberIs( stat.nlink ) );

  let result = ino + '' + mtime + '' + ctime + '' + stat.size;

  _.assert( _.strIs( result ) );

  return result;
}

// --
//
// --

let Tools =
{
  fileStatIs,
  // different,
  // areHardLinked,
  // hashStatFrom,
}

/* zzz : clean */

_.props.extend( _, Tools );

//

let StatExtension =
{

  is : fileStatIs,
  different,
  areHardLinked,
  hashStatFrom,

}

/* _.props.extend */Object.assign( _.files.stat, StatExtension );

})();

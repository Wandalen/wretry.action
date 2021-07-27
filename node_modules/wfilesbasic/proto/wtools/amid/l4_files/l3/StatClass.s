( function _StatClass_s_()
{

'use strict';

//

/**
 * @class wFileStat
 * @namespace wTools
 * @module Tools/mid/Files
*/

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wFileStat;
function wFileStat( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'FileStat';

// --
// implementation
// --

function init( o )
{
  let self = this;

  _.workpiece.initFields( self );

  if( o )
  self.copy( o );

  Object.preventExtensions( self );

}

//

/**
 * @summary Returns true if current stats object refers to soft or text link.
 * @function isLink
 * @class wFileStat
 * @namespace wTools
 * @module Tools/mid/Files
*/

function isLink()
{
  let stat = this;
  let result = false;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( !result )
  result = stat.isSoftLink();

  if( !result )
  result = stat.isTextLink();

  return result;
}

//

function returnFalse()
{
  return false;
}

/**
 * @typedef {Object} Fields
 * @property {Number} dev
 * @property {Number} mode
 * @property {Number} nlink
 * @property {Number} uid
 * @property {Number} gid
 * @property {Number} rdev
 * @property {Number} blksize
 * @property {Number} ino
 * @property {Number} size
 * @property {Number} blocks
 * @property {Date} atime
 * @property {Date} mtime
 * @property {Date} ctime
 * @property {Date} birthtime
 * @property {String} filePath
 * @class wFileStat
 * @namespace wTools
 * @module Tools/mid/Files
*/

// --
// relation
// --

let Composes =
{
  dev : null,
  mode : null,
  nlink : null,
  uid : null,
  gid : null,
  rdev : null,
  blksize : null,
  ino : null,
  size : null,
  blocks : null,
  atime : null,
  mtime : null,
  ctime : null,
  birthtime : null,
}

let Aggregates =
{
}

let Associates =
{
  associated : null,
  filePath : null,
}

let Restricts =
{

  isDir : null,
  isTerminal : null,
  isTextLink : null,
  isSoftLink : null,
  isHardLink : null,

  isDirectory : null, /* alias */
  isFile : null, /* alias */
  isSymbolicLink : null, /* alias */

  isBlockDevice : returnFalse,
  isCharacterDevice : returnFalse,
  isFIFO : returnFalse,
  isSocket : returnFalse,

}

let Statics =
{
}

let Forbids =
{
}

// --
// declare
// --

let Extension =
{

  init,

  isDir : null,
  isTerminal : null,
  isTextLink : null,
  isSoftLink : null,
  isHardLink : null,
  isLink,

  isDirectory : null, /* alias */
  isFile : null, /* alias */
  isSymbolicLink : null, /* alias */

  isBlockDevice : returnFalse,
  isCharacterDevice : returnFalse,
  isFIFO : returnFalse,
  isSocket : returnFalse,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

if( _global_.wCopyable )
_.Copyable.mixin( Self );
_.files[ Self.shortName ] = Self;

})();

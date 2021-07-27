( function _Reroot_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
var Abstract = _.FileProvider.Abstract;
var Partial = _.FileProvider.Partial;
var Default = _.FileProvider.Default;
const Parent = null;
const Self = wFileFilterReroot;
function wFileFilterReroot( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Reroot';

_.assert( !_.FileFilter.Reroot );

//

function init( o )
{
  var self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.workpiece.initFields( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  _.assert( _.object.isBasic( self.original ) );

  var self = _.proxyMap( self, self.original );

  if( self.path === null )
  {
    self.path = self.Path.CloneExtending({ fileProvider : self });
  }

  return self;
}

//

function pathNativizeAct( filePath )
{
  var self = this;

  _.assert( arguments.length === 1 );

  filePath = self.path.rebase( filePath, self.oldPath, self.newPath );
  filePath = self.original.path.nativize( filePath );

  return filePath;
}

// --
// relations
// --

var Composes =
{
  oldPath : '/',
  newPath : '/',
}

var Aggregates =
{
}

var Associates =
{
  original : null,
  path : null,
}

var Restricts =
{
}

// --
// declare
// --

var Extension =
{

  init,

  pathNativizeAct,

  //


  Composes,
  Aggregates,
  Associates,
  Restricts,

}

/* qqq : normalize styles */
/* qqq : implement basic test */

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

_.Copyable.mixin( Self );

_.FileFilter = _.FileFilter || Object.create( null );
_.FileFilter[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

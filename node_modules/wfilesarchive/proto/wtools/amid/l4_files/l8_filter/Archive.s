( function _Archive_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Abstract = _.FileProvider.Abstract;
const Partial = _.FileProvider.Partial;
const Default = _.FileProvider.Default;
const Parent = Abstract;
const Self = wFileFilterArchive;
function wFileFilterArchive( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Archive';

// --
// implementtation
// --

function init( o )
{
  let self = this;

  _.assert( arguments.length <= 1 );
  _.workpiece.initFields( self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( !self.original )
  self.original = new _.FileProvider.Default();
  // self.original = _.fileProvider;

  let proxy = _.proxyMap( self, self.original );

  if( !proxy.archive )
  proxy.archive = new _.FilesArchive({ fileProvider : proxy });

  return proxy;
}

// --
// relations
// --

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
  archive : null,
  original : null,
}

let Restricts =
{
}

// --
// declare
// --

let Extension =
{

  init,

  // fileCopyAct : fileCopyAct,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

_.Copyable.mixin( Self );

//

_.FileFilter = _.FileFilter || Object.create( null );
_.FileFilter[ Self.shortName ] = Self;

} )();

( function _Abstract_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
var FileRecord = _.files.FileRecord;
var FileRecordFilter = _.files.FileRecordFilter;
var FileRecordFactory = _.files.FileRecordFactory;

_.assert( !_.FileProvider.Abstract );
_.assert( _.routineIs( _.files.FileRecord ) );
_.assert( _.routineIs( FileRecordFilter ) );
_.assert( _.routineIs( FileRecordFactory ) );

/**
 * @class wFileProviderAbstract
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
*/

const Parent = null;
const Self = wFileProviderAbstract;
function wFileProviderAbstract( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Abstract';

//

function init( o )
{
}

// --
// relations
// --

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
}

var Statics =
{
  Record : FileRecord,
  RecordFilter : FileRecordFilter,
  RecordFactory : FileRecordFactory,
}

// --
// declare
// --

var Extension =
{

  init,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

//

_.FileProvider = _.FileProvider || Object.create( null );
_.FileProvider[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

( function _Mission_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.files.operator.AbstractResource;
const Self = wOperatorMission;
function wOperatorMission( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Mission';

// --
//
// --

function finit()
{
  let mission = this;
  mission.unform();

  _.assert( mission.operationArray.length === 0 );

  return _.Copyable.prototype.finit.call( mission );
}

//

function init( o )
{
  let mission = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.workpiece.initFields( mission );

  if( mission.Self === Self )
  Object.preventExtensions( mission );

  if( o )
  mission.copy( o );

  mission.form();

  return mission;
}

//

function unform()
{
  let mission = this;
  let operator = mission.operator;

  if( !mission.id )
  return;

  mission.operationArray.slice().forEach( ( operation ) => operation.finit() );
  _.assert( mission.operationArray.length === 0 );

  _.assert( operator.missionSet.has( mission ) );
  operator.missionSet.delete( mission );

  mission.id = -1;
  return mission;
}

//

function form()
{
  let mission = this;
  let operator = mission.operator;

  if( !mission.operator )
  operator = mission.operator = new _.files.operator.Operator();

  mission.thirdOperation = _.files.operator.Operation
  ({
    operator,
    mission,
    action : 'third',
  });

  mission.operator.missionSet.add( mission );
  mission.id = operator.idAllocate();

  return mission;
}

//

function filesReflect( o )
{
  let mission = this;
  let operator = mission.operator;
  let filesSystem = operator.filesSystem;

  o = filesSystem.filesReflect.head.call( filesSystem, filesSystem.filesReflect, arguments );

  let src = o.src;
  let dst = o.dst;

  _.assert( src instanceof _.files.FileRecordFilter );
  _.assert( dst instanceof _.files.FileRecordFilter );

  delete o.src;
  delete o.dst;

  let operation = _.files.operator.Operation
  ({
    mission,
    options : o,
    action : 'filesReflect',
    dst,
    src,
  });

  return operation;
}

filesReflect.defaults =
{
  ... _.FileProvider.FindMixin.prototype.filesReflect.defaults,
}

//

function redo( o )
{
  let mission = this;
  let ready = _.take( null );
  o = _.routine.options( redo, arguments );

  mission.operationArray.forEach( ( operation ) =>
  {
    ready.then( () => operation.redo( o ) );
  });

  return ready;
}

redo.defaults =
{
}

// --
// exporter
// --

function exportString( o )
{
  let mission = this;

  o = _.routine.options( exportString, o || null );

  let it = o.it = _.stringer.it( o.it || { verbosity : 2 } );
  it.opts = o;

  if( o.withName )
  {
    it.write( mission.clname );
    // it.iterator.result += mission.clname;
    // it.tabLevelUp();
  }

  if( it.verbosity >= 2 )
  mission.operationArray.forEach( ( operation, c ) =>
  {
    let o2 = { it : it.verbosityUp() };
    if( it.verbosity === 2 )
    o2.withName = 0;
    o2.it.eolWrite();
    o2.it.write( o2.it.tab );
    operation.exportString( o2 );
    o2.it.verbosityDown();
  });

  if( o.withName )
  {
    // it.tabLevelDown();
  }

  return it;
}

exportString.defaults =
{
  format : 'diagnostic',
  withName : 1,
  it : null,
}

// --
// relations
// --

let Composes =
{
  missionName : null,
}

let Aggregates =
{
  operationArray : _.define.own([]),
}

let Associates =
{
  id : null,
  operator : null,
}

let Restricts =
{
  thirdOperation : null,
}

let Statics =
{
  // OwnerName : 'operator',
}

// --
// declare
// --

let Extension =
{

  finit,
  init,
  unform,
  form,

  filesReflect,

  redo,

  exportString,

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

_.files.operator[ Self.shortName ] = Self;

})();

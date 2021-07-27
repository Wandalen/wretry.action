( function _Operation_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.files.operator.AbstractResource;
const Self = wOperatorOperation;
function wOperatorOperation( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Operation';

// --
//
// --

function finit()
{
  let operation = this;
  operation.unform();

  _.assert( operation.deedArray.length === 0 );

  return _.Copyable.prototype.finit.call( this );
}

//

function init( o )
{
  let operation = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.workpiece.initFields( operation );

  if( operation.Self === Self )
  Object.preventExtensions( operation );

  if( o )
  operation.copy( o );

  operation.form();

  return operation;
}

//

function unform()
{
  let operation = this;
  let mission = operation.mission;
  let operator = operation.operator;

  if( !operation.id )
  return;

  _.assert( mission instanceof _.files.operator.Mission );
  _.assert( operator instanceof _.files.operator.Operator );

  _.container.each( operation.deedArray.slice(), ( deed ) => deed.finit() );
  _.assert( operation.deedArray.length === 0 );

  _.arrayRemoveOnceStrictly( operator.operationArray, operation );
  _.arrayRemoveOnceStrictly( mission.operationArray, operation );

  operation.id = -1;
  return operation;
}

//

function form()
{
  let operation = this;
  let mission = operation.mission;
  let operator = operation.operator;

  if( operation.operator === null )
  operator = operation.operator = mission.operator;
  if( mission && mission.operator === null )
  mission.operator = operator.operator;

  _.assert( operation.id === null );
  _.assert( mission === null || mission instanceof _.files.operator.Mission );
  _.assert( mission === null || mission.operator === operator );
  _.assert( operator instanceof _.files.operator.Operator );

  operation.id = operator.idAllocate();

  if( mission )
  _.arrayAppendOnceStrictly( mission.operationArray, operation );
  _.arrayAppendOnceStrictly( operator.operationArray, operation );

  if( operation.action === 'filesReflect' )
  {
    operation._boot = operation.reflectBoot;
    operation._redo = operation.reflectRedo;
  }
  else if( operation.action === 'third' )
  {
    operation._boot = operation.thirdBoot;
    operation._redo = operation.thirdRedo;
  }
  else _.assert( 0, `Unknown action ${operation.action} of operation` );

  return operation;
}

//

function form2()
{
  let operation = this;
  let usages = operation.usageHashmapGet();

  // logger.log( operation.exportString().result );

  _.hashMap.each( usages, ( usage ) =>
  {
    usage.file.reform2();
  });

  // logger.log( operation.exportString({ format : 'files.status' }).result );

}

//

function deedMake( o )
{
  let operation = this;
  return new _.files.operator.Deed
  ({
    operation,
    ... o,
  })
}

//

function usageHashmapGet()
{
  let operation = this;
  let files = new HashMap;

  operation.deedArray.forEach( ( deed ) =>
  {
    _.set.each( deed.fileSet, ( usage ) => files.set( usage.file.globalPath, usage ) );
  });

  return files;
}

//

function redo( o )
{
  let operation = this;
  let mission = operation.mission;
  let operator = operation.operator;

  if( operation.status === 'unbooted' )
  operation._boot( o );
  else
  operation._redo( o );

  return o;
}

redo.defaults =
{
}

//

function reflectBoot( o )
{
  let operation = this;
  let mission = operation.mission;
  let operator = mission.operator;
  let ignoredAction = new Set([ 'nop', 'fileDelete', 'exclude', 'ignore' ]);
  o.ready = o.ready || _.take( null );

  let opts = _.props.extend( null, operation.options );
  opts.dst = operation.dst;
  opts.src = operation.src;
  opts.src = _.entity.make( opts.src );
  opts.dst = _.entity.make( opts.dst );

  opts.onUp = opts.onUp ? _.array.as( opts.onUp ) : [];
  opts.onUp.push( handleUp );
  opts.onDown = opts.onDown ? _.array.as( opts.onDown ) : [];
  opts.onDown.push( handleDown );

  o.ready.then( () => operator.filesSystem.filesReflect( opts ) );
  o.ready.then( handleEnd );

  return o.ready;

  /* */

  function handleUp( record, op )
  {
    let mtr = _.path.moveTextualReport( record.dst.absolute, record.src.absolute );
    // logger.log( ` + handleUp ${mtr}` );

    let dst = operator.fileFor( record.dst.absoluteGlobal, record.dst.absolute );
    let src = operator.fileFor( record.src.absoluteGlobal, record.src.absolute );
    record.deed = operation.deedMake();
    record.srcUsage = record.deed.use( src );
    record.srcUsage.facetSet = 'reading';
    record.dstUsage = record.deed.use( dst );

    if( record.dst.stat )
    if( dst.firstEffectiveDeed === null )
    {
      record.thirdDeed = mission.thirdOperation.deedMake
      ({
        // facetSet : [ 'third' ],
        action : 'third',
        status : 'uptodate',
      });
      var dstUsage = record.thirdDeed.use( dst );
      dstUsage.facetSet = 'third';
    }

  }

  /* */

  function handleDown( record, op )
  {
    let mtr = _.path.moveTextualReport( record.dst.absolute, record.src.absolute );
    logger.log( ` + handleDown ${mtr} ${record.action}` );

    _.assert( !!record.deed );

    let deed = record.deed;
    deed.action = record.action;
    deed.status = 'uptodate';
    if( ignoredAction.has( record.action ) )
    {
      _.assert( 0, 'not tested' );
      if( record.thirdDeed )
      record.thirdDeed.finit();
      deed.finit();
      return;
    }

    // let dst = [ ... deed.dst ][ 0 ];
    if( record.action === 'fileDelete' )
    record.dstUsage.facetSet = [ 'deleting' ];
    else
    record.dstUsage.facetSet = [ 'producing' ];

  }

  /* */

  function handleEnd()
  {
    operation.status = 'uptodate';
    operation.form2();
    return o;
  }

  /* */

}

//

function reflectRedo( o )
{
  let operation = this;
  let mission = operation.mission;
  let operator = mission.operator;

  let opts = _.props.extend( null, operation.options );
  opts.dst = operation.dst;
  opts.src = operation.src;
  opts.src = _.entity.make( opts.src );
  opts.dst = _.entity.make( opts.dst );

  operator.filesSystem.filesReflect( opts );

  return o;
}

//

function thirdBoot( o )
{
  let operation = this;
  let mission = operation.mission;
  let operator = mission.operator;

  return o;
}

//

function thirdRedo( o )
{
  let operation = this;
  let mission = operation.mission;
  let operator = mission.operator;

  return o;
}

// --
// exporter
// --

function exportStructure()
{
  let operation = this;

  o = _.routine.options( exportStructure, o || null );
  o.it = o.it || { verbosity : 2, result : Object.create( null ) };

  return o;
}

exportStructure.defaults =
{
  format : 'diagnostic',
  withName : 1,
  it : null,
}

//

function exportString( o )
{
  let operation = this;
  let Format = new Set([ 'diagnostic', 'files.status' ]);

  o = _.routine.options( exportString, o || null );
  _.assert( Format.has( o.format ) );

  let verbosity = o.format === 'files.status' ? 3 : 2;
  let it = o.it = _.stringer.it( o.it || { verbosity } );
  it.opts = o;

  // debugger;

  if( o.withName )
  {
    // it.iterator.result += operation.clname;
    // it.iterator.resultStructure.push( operation.clname );
    it.lineWrite( operation.clname );
  }

  if( it.verbosity >= 2 )
  operation.deedArray.forEach( ( deed, c ) =>
  {
    let o2 = { it : it.verbosityUp() };
    if( it.verbosity === 2 )
    o2.withName = 0;
    // o2.it.eolWrite().tabWrite();
    deed.exportString( o2 );
    o2.it.verbosityDown();
  });

  if( it.verbosity >= 2 )
  {
    let usages = operation.usageHashmapGet();
    _.hashMap.each( usages, ( usage ) =>
    {
      let o2 = { it : it.verbosityUp() };
      // o2.it.eolWrite().tabWrite();
      usage.exportString( o2 );
      o2.it.verbosityDown();
    });
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
  action : null,
  options : null,
  dst : null,
  src : null,
  direction : 'both',
  status : 'unbooted',
  canceler : null,
}

let Aggregates =
{
  deedArray : _.define.own( [] ),
}

let Associates =
{
  id : null,
  mission : null,
  operator : null,
}

let Restricts =
{
  _boot : null,
  _redo : null,
}

let Statics =
{
  OwnerName : 'mission',
}

let Accessors =
{
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
  form2,
  deedMake,

  usageHashmapGet,
  redo,
  reflectBoot,
  reflectRedo,
  thirdBoot,
  thirdRedo,

  // exporter

  exportStructure,
  exportString,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Accessors,

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

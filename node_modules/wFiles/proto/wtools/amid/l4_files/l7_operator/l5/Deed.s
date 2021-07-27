( function _Deed_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.files.operator.AbstractResource;
const Self = wOperatorDeed;
function wOperatorDeed( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Deed';

// --
//
// --

function finit()
{
  let deed = this;
  deed.unform();

  _.assert( deed.fileSet.size === 0 );

  return _.Copyable.prototype.finit.call( deed );
}

//

function init( o )
{
  let deed = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.workpiece.initFields( deed );

  if( deed.Self === Self )
  Object.preventExtensions( deed );

  if( o )
  deed.copy( o );

  deed.form();
  return deed;
}

//

function unform()
{
  let deed = this;
  let operation = deed.operation;
  let operator = operation.operator;

  if( !deed.id )
  return;

  deed.fileSet.forEach( ( usage ) => usage.finit() );

  _.arrayRemoveOnceStrictly( operation.deedArray, deed );
  _.arrayRemoveOnceStrictly( operator.deedArray, deed );

  deed.id = -1;
  return deed;
}

//

function form()
{
  let deed = this;
  let operation = deed.operation;
  let mission = operation.mission;
  let operator = operation.operator;

  _.assert( operation instanceof _.files.operator.Operation );
  _.assert( mission === null || mission instanceof _.files.operator.Mission );
  _.assert( operator instanceof _.files.operator.Operator );
  _.assert( deed.id === null );

  deed.id = operator.idAllocate();
  deed.fileSet.forEach( ( usage ) => usage.file.deedOn( usage ) );

  _.arrayAppendOnceStrictly( operation.deedArray, deed );
  _.arrayAppendOnceStrictly( operator.deedArray, deed );

  return deed;
}

//

function reform2()
{
  let deed = this;
  let operation = deed.operation;
  let mission = operation.mission;
  let operator = operation.operator;
  // let files = [];
  //
  // _.set.each( deed.src, ( file ) => files.push(  ) );
  // _.set.each( deed.dst, ( file ) => file.reval() );

  // _.set.each( deed.src, ( file ) => file.account( deed, 'reading' ) );
  // _.set.each( deed.dst, ( file ) => file.account( deed, deed.facetSet ) );

}

//

function use( file )
{
  let deed = this;
  _.assert( arguments.length === 1 );
  _.assert( file instanceof _.files.operator.File );
  let usage = _.files.operator.FileUsage({ file, deed });
  return usage;
}

//

function actionSet( src )
{
  let deed = this;
  _.assert( src === null || deed.Action[ src ] !== undefined );
  deed[ actionSymbol ] = src;
}

//

function fileSetSet( src )
{
  let deed = this;
  let symbol = fileSetSymbol;

  if( deed[ symbol ] === undefined )
  {
    deed[ symbol ] = src;
  }
  else
  {
    deed[ symbol ].clear();
    _.set.appendContainer( deed[ symbol ], src );
  }

}

// //
//
// function facetSetSet( src )
// {
//   let deed = this;
//   let symbol = facetSetSymbol;
//
//   if( deed[ symbol ] === undefined )
//   {
//     deed[ symbol ] = src;
//   }
//   else
//   {
//     deed[ symbol ].clear();
//     _.set.appendContainer( deed[ symbol ], src );
//     if( Config.debug )
//     _.set.each( deed[ symbol ], ( attribute ) => _.assert( !!deed.Attribute[ attribute ] ) );
//   }
//
// }

//

function dstGet()
{
  let deed = this;
  let result = _.set.filter( null, deed.fileSet, ( usage ) => usage.facetSet.has( 'reading' ) ? undefined : usage.file );
  return result;
}

//

function srcGet()
{
  let deed = this;
  let result = _.set.filter( null, deed.fileSet, ( usage ) => usage.facetSet.has( 'reading' ) ? usage.file : undefined );
  return result;
}

// --
// exporter
// --

function exportString( o )
{
  let deed = this;

  o = _.routine.options( exportString, o || null );
  let it = o.it = _.stringer.it( o.it || { verbosity : 2 } );
  it.opts = o;

  if( it.verbosity <= 0 )
  return;

  if( o.withName )
  {
    // it.iterator.result += deed.clname;
    // it.iterator.resultStructure.push( deed.clname );
    it.lineWrite( deed.clname );
    it.tabLevelUp();
  }

  let dst = [ ... _.set.map( null, deed.dstGet(), ( file ) => file.localPath ) ][ 0 ] || null;
  let src = [ ... _.set.map( null, deed.srcGet(), ( file ) => file.localPath ) ][ 0 ] || null;
  let mtr = _.path.moveTextualReport( dst, src ); /* xxx */
  if( it.verbosity >= 2 )
  it.lineWrite( mtr );
  else
  it.lineWrite( mtr );
  // it.iterator.result += mtr;

  if( it.verbosity >= 2 )
  {
    if( deed.action !== null )
    it.lineWrite( `action : ${deed.action}` );
    if( deed.status !== null )
    it.lineWrite( `status : ${deed.status}` );
    // if( deed.facetSet.size )
    // it.lineWrite( `facetSet : ${_.entity.exportString( deed.facetSet )}` );
  }

  if( o.withName )
  {
    it.tabLevelDown();
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

let actionSymbol = Symbol.for( 'action' );
let fileSetSymbol = Symbol.for( 'fileSet' );
// let facetSetSymbol = Symbol.for( 'facetSet' );

let Action =
{
  'third' : 'third',
  'fileDelete' : 'fileDelete',
  'dirMake' : 'dirMake',
  'fileCopy' : 'fileCopy',
  'softLink' : 'softLink',
  'hardLink' : 'hardLink',
  'textLink' : 'textLink',
}

let Attribute =
{
  'producing' : 'producing',
  'deleting' : 'deleting',
  'third' : 'third',
  'editing' : 'editing',
  'reading' : 'reading',
}

let Composes =
{
  action : null,
  status : null,
  fileSet : _.define.own( new Set ),
  // facetSet : _.define.own( new Set ), /* xxx : remove? */
}

let Aggregates =
{
}

let Associates =
{
  id : null,
  operation : null,
}

let Restricts =
{
}

let Statics =
{
  Action,
  Attribute,
  OwnerName : 'operation',
}

let Accessors =
{
  action : { set : actionSet },
  fileSet : { set : fileSetSet },
  // facetSet : { set : facetSetSet },
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
  reform2,

  use,
  actionSet,
  // facetSetSet,

  dstGet,
  srcGet,

  // exporter

  exportString,

  //

  Action,
  Attribute,

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

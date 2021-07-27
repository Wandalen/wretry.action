( function _FileUsage_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.files.operator.AbstractResource;
const Self = wOperatorFileUsage;
function wOperatorFileUsage( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'FileUsage';

// --
//
// --

function finit()
{
  let usage = this;
  usage.unform();
  return _.Copyable.prototype.finit.call( this );
}

//

function init( o )
{
  let usage = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.workpiece.initFields( usage );

  if( usage.Self === Self )
  Object.preventExtensions( usage );

  if( o )
  usage.copy( o );

  usage.form();
  return usage;
}

//

function unform()
{
  let usage = this;
  let deed = usage.deed;
  let file = usage.file;

  if( !usage.id )
  return;

  _.arrayRemoveElementOnceStrictly( file.deedArray, usage );
  deed.fileSet.delete( usage );

  if( file.deedArray.length === 0 )
  file.finit();

  usage.id = -1;
  return usage;
}

//

function form()
{
  let usage = this;
  let deed = usage.deed;
  let file = usage.file;
  let operator = file.operator;

  _.assert( deed instanceof _.files.operator.Deed );
  _.assert( file instanceof _.files.operator.File );
  _.assert( usage.id === null );

  _.arrayAppendElementOnceStrictly( file.deedArray, usage );
  deed.fileSet.add( usage );

  usage.id = operator.idAllocate();
  return usage;
}

//

function facetSetSet( src )
{
  let usage = this;
  let symbol = facetSetSymbol;

  if( usage[ symbol ] === undefined )
  {
    usage[ symbol ] = src;
  }
  else
  {
    usage[ symbol ].clear();
    _.set.appendContainer( usage[ symbol ], src );
    if( Config.debug )
    _.set.each( usage[ symbol ], ( attribute ) => _.assert( !!_.files.operator.Deed.Attribute[ attribute ] ) );
  }

}

//

function exportString( o )
{
  let usage = this;

  o = _.routine.options( exportString, o || null );

  let it = o.it = _.stringer.it( o.it || { verbosity : 2 } );
  it.opts = o;

  if( it.verbosity <= 0 )
  return it;

  usage.file.exportString( o );

  if( it.verbosity >= 2 )
  {
    it.tabLevelUp();
    if( usage.facetSet !== null && usage.facetSet.size )
    it.lineWrite( `facetSet : ${ [ ... usage.facetSet ].join( ' ' ) }` );
    it.tabLevelDown();
  }

  return it;
}

exportString.defaults =
{
  format : 'diagnostic',
  withName : null,
  it : null,
}

// --
// relations
// --

let facetSetSymbol = Symbol.for( 'facetSet' );

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
  deed : null,
  file : null,
  facetSet : _.define.own( new Set ),
  id : null,
}

let Restricts =
{
}

let Statics =
{
  OwnerName : 'deed',
}

let Accessors =
{
  facetSet : { set : facetSetSet },
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

  facetSetSet,

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

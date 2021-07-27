( function _AbstractResource_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wOperatorAbstractResource;
function wOperatorAbstractResource( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'AbstractResource';

// --
//
// --

function finit()
{
  let self = this;
  self.unform();
  return _.Copyable.prototype.finit.call( this );
}

//

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.workpiece.initFields( self );

  if( self.Self === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  self.form();

  return self;
}

// --
// exporter
// --

function exportStructure()
{
  let self = this;

  o = _.routine.options( exportStructure, o );
  o.it = o.it || { verbosity : 3, result : Object.create( null ) };

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
  let self = this;

  o = _.routine.options( exportString, o );
  o.it = o.it || { verbosity : 3, tab : '', dtab : '  ', result : '' };

  if( o.withName )
  o.it.result += self.clname;

  return o;
}

exportString.defaults =
{
  format : 'diagnostic',
  withName : 1,
  it : null,
}

//

function nameGet()
{
  let self = this;
  return `#${self.id}`;
}

//

function qnameGet()
{
  let self = this;
  return `${self.constructor.shortName}::${self.nameGet()}`;
}

//

function lnameGet()
{
  let self = this;
  let owner = self[ self.OwnerName ];
  if( owner )
  return `${owner.lname} / ${self.qname}`;
  return `${self.qname}`;
}

//

function clnameGet()
{
  let self = this;
  let result = self.lname;
  return _.ct.format( result, 'entity' );
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
  id : null,
  operator : null,
}

let Restricts =
{
}

let Statics =
{
}

let Accessors =
{
  name : { get : nameGet, set : false },
  qname : { get : qnameGet, set : false },
  lname : { get : lnameGet, set : false },
  clname : { get : clnameGet, set : false },
}

// --
// declare
// --

let Extension =
{

  finit,
  init,

  // exporter

  exportStructure,
  exportString,
  nameGet,
  qnameGet,
  lnameGet,

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

_.Copyable.mixin( Self );
_.files.operator[ Self.shortName ] = Self;

})();

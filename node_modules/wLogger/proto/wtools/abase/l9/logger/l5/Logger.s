(function _Logger_s_()
{

'use strict';


/*

Kinds of Chain : [ ordinary, excluding, original ]

Kinds of Print-like object : [ console, printer ]

Kinds of situations :

conosle -> ordinary -> self
printer -> ordinary -> self
conosle -> excluding -> self
printer -> excluding -> self
self -> ordinary -> conosle
self -> ordinary -> printer
self -> original -> conosle
self -> original -> printer

*/

/**
 * @classdesc Creates a logger for printing colorful and well formatted diagnostic code on server-side or in the browser. Based on [wLoggerTop]{@link wLoggerTop}.
 * @class wLogger
 * @namespace Tools
 * @module Tools/base/Logger
 */

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.LoggerMid;
const Self = wLoggerTop;
function wLoggerTop( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Logger';

// --
//
// --

function init( o )
{
  let self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 );
  Parent.prototype.init.call( self, o );
}

// --
// relations
// --

let Composes =
{
  name : '',
}

let Aggregates =
{
}

let Associates =
{
  output : null,
}

let Restricts =
{
}

let Statics =
{
}

// --
// declare
// --

let Proto =
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
  extend : Proto,
});

//

_.PrinterChainingMixin.mixin( Self );
_.PrinterColoredMixin.mixin( Self );

_.assert( _.routineIs( _.PrinterChainingMixin.prototype._writeAct ) );
_.assert( Self.prototype._writeAct === _.PrinterChainingMixin.prototype._writeAct );

if( !_global_.logger || !( _global_.logger instanceof Self ) )
_global_.logger = _global_[ 'logger' ] = new Self({ output : console, name : 'global' });

// --
// export
// --

_[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

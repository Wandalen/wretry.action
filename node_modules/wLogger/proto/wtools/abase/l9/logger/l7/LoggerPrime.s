(function _LoggerPrime_s_()
{

'use strict';

/**
 * @classdesc Creates a logger for printing colorful and well formatted diagnostic code on server-side or in the browser. Based on [wLoggerTop]{@link wLoggerTop}.
 * @class wLoggerPrime
 * @namespace Tools
 * @module Tools/base/Logger
 */

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.Logger;
const Self = wLoggerPrime;
function wLoggerPrime( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'LoggerPrime';

//

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  Parent.prototype.init.call( self, o );

  if( !self.outputs.length )
  self.outputTo( _global_.logger );

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

_[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

( function _Verbal_s_()
{

'use strict';

/**
 * Verbal is small mixin which adds verbosity control to your class. It tracks verbosity changes, reflects any change of verbosity to instance's components, and also clamp verbosity in [ 0 .. 9 ] range. Use it as a companion for a logger, mixing it into logger's carrier.
  @module Tools/mid/Verbal
*/

/**
 *  */

/**
 * @classdesc Verbal is small mixin which adds verbosity control to your class.
 * @class wVerbal
 * @namespace wTools
 * @module Tools/mid/Verbal
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wProto' );

}


//

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wVerbal;
function wVerbal( o )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Verbal';

// --
// implementation
// --

function verbal_functor( o )
{
  if( _.routineIs( o ) )
  o = { routine : o }
  _.routine.options_( verbal_functor, o );
  _.assert( _.strDefined( o.routine.name ) );
  let routine = o.routine;
  let title = _.strCapitalize( _.strToTitle( o.routine.name ) );

  return function verbal()
  {
    let self = this;
    let logger = self.logger;
    let result;
    logger.rbegin({ verbosity : -1 });
    logger.log( title + ' ..' );
    logger.up();

    try
    {
      result = routine.apply( this, arguments );
    }
    catch( err )
    {
      throw _.err( err );
    }

    _.Consequence.From( result ).split()
    .finally( () =>
    {
      logger.down();
      logger.rend({ verbosity : -1 });
      return true;
    });

    return result;
  }
}

verbal_functor.defaults =
{
  routine : null,
}

//

function _verbosityGet()
{
  let self = this;
  if( !self.logger )
  return 0;
  return self.logger.verbosity;
}

//

function _verbositySet( src )
{
  let self = this;

  if( _.boolIs( src ) )
  src = src ? 1 : 0;

  src = _.numberClamp( src, 0, 9 );

  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( src ) );
  _.assert( src === 0 || !!self.logger, () => 'Verbal ' + self.qualifiedName + ' does not have logger to set verbosity to ' + src );

  // self[ verbositySymbol ] = src;

  let change = self.logger && self.logger.verbosity !== src;
  if( self.logger )
  self.logger.verbosity = src;

  if( change )
  return self._verbosityChange();
}

//

function _verbosityChange()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  // if( self.fileProvider )
  // self.fileProvider.verbosity = self._verbosityForFileProvider();

  // if( self.logger )
  // {
  //   // self.logger.verbosity = self._verbosityForLogger();
  //   self.logger.outputGray = self.coloring ? 0 : 1;
  //   return src;
  // }

  return 0;
}

//

// function _coloringSet( src )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1 );
//   _.assert( _.boolLike( src ) );
//
//   if( !src )
//   debugger;
//
//   if( self.logger )
//   {
//     self[ coloringSymbol ] = src;
//     self.logger.outputGray = src ? 0 : 1;
//   }
//   else
//   {
//     self[ coloringSymbol ] = src;
//   }
//
// }

//

function _coloringGet()
{
  let self = this;
  if( !self.logger )
  return false;
  return !self.logger.outputGray;
  // return self[ coloringSymbol ];
}

//

// function _verbosityForFileProvider()
// {
//   let self = this;
//   let less = _.numberClamp( self.verbosity-2, 0, 9 );
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//   return less;
// }

//

// function _fileProviderSet( src )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1 );
//
//   // if( src )
//   // src.verbosity = self._verbosityForFileProvider();
//
//   self[ fileProviderSymbol ] = src;
//
//   self._verbosityChange();
//
// }
//
// //
//
// function _verbosityForLogger()
// {
//   let self = this;
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//   return self.verbosity;
// }

//

function _loggerSet( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( self[ loggerSymbol ] )
  {
    self[ loggerSymbol ].off( 'verbosityChange', self );
  }

  self[ loggerSymbol ] = src;

  // if( src )
  // debugger;
  if( src )
  src.on( 'verbosityChange', self, () => self._verbosityChange() );

  // if( src )
  // {
  //   // src.verbosity = self._verbosityForLogger();
  //   // src.outputGray = self.coloring ? 0 :1;
  // }

  self._verbosityChange();

  return src;
}

// --
// vars
// --

// let verbositySymbol = Symbol.for( 'verbosity' );
let coloringSymbol = Symbol.for( 'coloring' );
// let fileProviderSymbol = Symbol.for( 'fileProvider' );
let loggerSymbol = Symbol.for( 'logger' );

// --
// relations
// --

let Composes =
{
  // verbosity : 0,
  // coloring : 1,
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
  verbal_functor,
}

let Forbids =
{
  _verbosityForFileProvider : '_verbosityForFileProvider',
  _fileProviderSet : '_fileProviderSet',
  _verbosityForLogger : '_verbosityForLogger',
  _coloringSet : '_coloringSet',
}

let Accessors =
{
  verbosity : { combining : 'supplement' },
  coloring : { combining : 'supplement' },
  // fileProvider : { combining : 'supplement' },
  logger : { combining : 'supplement' },
}

// --
// declare
// --

let Supplement =
{

  _verbosityGet,
  _verbositySet,
  _verbosityChange,
  // _coloringSet : _coloringSet,
  _coloringGet,

  // _verbosityForFileProvider : _verbosityForFileProvider,
  // _fileProviderSet : _fileProviderSet,
  // _verbosityForLogger : _verbosityForLogger,

  _loggerSet,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  supplement : Supplement,
  withMixin : true,
  withClass : true,
});

// --
// export
// --

_global_[ Self.name ] = _[ Self.shortName ] = Self;


if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

( function _RecordFactoryAbstract_s_()
{

'use strict';

/**
 * @class wFileRecordContext
 * @namespace wTools
 * @module Tools/mid/Files
*/

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wFileRecordContext;
function wFileRecordContext( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'FileRecordContext';

_.assert( !_.files.FileRecordContext );

// --
// routine
// --

/**
 * @summary Creates factory instance ignoring unknown options.
 * @param {Object} o Options map.
 * @function TolerantFrom
 * @class wFileRecordContext
 * @namespace wTools
 * @module Tools/mid/Files
*/

function TolerantFrom( o )
{
  let Cls = _.workpiece.constructorOf( this );
  _.assert( arguments.length >= 1, 'Expects at least one argument' );
  _.assert( _.object.isBasic( Cls.prototype.Composes ) );
  o = _.mapsExtend( null, arguments );
  return new Cls( _.mapOnly_( null, o, Cls.prototype.fieldsOfCopyableGroups ) );
}

//

function init( o )
{
  let factory = this;

  _.workpiece.initFields( factory );
  Object.preventExtensions( factory );

  return factory;
}

//

function _formAssociations()
{
  let factory = this;

  /* find file system */

  if( !factory.system )
  if( factory.effectiveProvider && factory.effectiveProvider instanceof _.FileProvider.System )
  {
    factory.system = factory.effectiveProvider;
    factory.effectiveProvider = null;
  }

  if( !factory.system )
  if
  (
    factory.effectiveProvider
    && factory.effectiveProvider.system
    && factory.effectiveProvider.system instanceof _.FileProvider.System
  )
  {
    factory.system = factory.effectiveProvider.system;
  }

  if( !factory.system )
  if( factory.defaultProvider && factory.defaultProvider instanceof _.FileProvider.System )
  {
    factory.system = factory.defaultProvider;
  }

  if( !factory.system )
  if
  (
    factory.defaultProvider
    && factory.defaultProvider.system
    && factory.defaultProvider.system instanceof _.FileProvider.System
  )
  {
    factory.system = factory.defaultProvider.system;
  }

  if( factory.system )
  if( factory.system.system && factory.system.system !== factory.system )
  {
    _.assert( !( factory.system instanceof _.FileProvider.System ) );
    if( !factory.effectiveProvider )
    factory.effectiveProvider = factory.system;
    factory.system = factory.system.system;
  }

  /* find effective provider */

  if( factory.effectiveProvider && factory.effectiveProvider instanceof _.FileProvider.System )
  {
    _.assert( factory.system === null || factory.system === factory.effectiveProvider );
    factory.system = factory.effectiveProvider;
    factory.effectiveProvider = null;
  }

  /* reset system */

  if( factory.effectiveProvider && factory.effectiveProvider.system )
  {
    _.assert( factory.system === null || factory.system === factory.effectiveProvider.system );
    factory.system = factory.effectiveProvider.system;
  }

  /* find default provider */

  if( !factory.defaultProvider )
  {
    factory.defaultProvider = factory.defaultProvider || factory.effectiveProvider || factory.system;
  }

  /* reset system */

  if( factory.system && !( factory.system instanceof _.FileProvider.System ) )
  {
    _.assert( factory.system === factory.defaultProvider || factory.system === factory.effectiveProvider )
    factory.system = null;
  }

  // if( factory.system )
  // {
  //   if( factory.system.system && factory.system.system !== factory.system )
  //   {
  //     _.assert( factory.effectiveProvider === null || factory.effectiveProvider === factory.system );
  //     factory.effectiveProvider = factory.system;
  //     factory.system = factory.system.system;
  //   }
  // }
  //
  // if( factory.effectiveProvider )
  // {
  //   if( factory.effectiveProvider instanceof _.FileProvider.System )
  //   {
  //     _.assert( factory.system === null || factory.system === factory.effectiveProvider );
  //     factory.system = factory.effectiveProvider;
  //     factory.effectiveProvider = null;
  //   }
  // }
  //
  // if( factory.effectiveProvider && factory.effectiveProvider.system )
  // {
  //   _.assert( factory.system === null || factory.system === factory.effectiveProvider.system );
  //   factory.system = factory.effectiveProvider.system;
  // }
  //
  // if( !factory.defaultProvider )
  // {
  //   factory.defaultProvider = factory.defaultProvider || factory.effectiveProvider || factory.system;
  // }

  /* */

  _.assert( !factory.system || factory.system instanceof _.FileProvider.Abstract, 'Expects {- factory.system -}' );
  _.assert( factory.defaultProvider instanceof _.FileProvider.Abstract );
  _.assert( !factory.effectiveProvider || !( factory.effectiveProvider instanceof _.FileProvider.System ) );

  /* */

  _.assert
  (
    !factory.system || factory.system instanceof _.FileProvider.System,
    () => '{- factory.system -} should be instance of {- _.FileProvider.System -}, but it is ' + _.entity.exportStringDiagnosticShallow( factory.system )
  );
  _.assert
  (
    !factory.effectiveProvider || !( factory.effectiveProvider instanceof _.FileProvider.System ),
    () => '{- factory.effectiveProvider -} cant be instance of {- _.FileProvider.System -}, but it is'
  );
  _.assert
  (
    factory.defaultProvider instanceof _.FileProvider.Abstract,
    () => '{- factory.system -} should be instance of {- _.FileProvider.Abstract -}, but it is ' + _.entity.exportStringDiagnosticShallow( factory.defaultProvider )
  );

}

// --
// relation
// --

/**
 * @typedef {Object} Fields
 * @class wFileRecordContext
 * @namespace wTools
 * @module Tools/mid/Files
*/

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
  system : null,
  effectiveProvider : null,
  defaultProvider : null,
}

let Medials =
{
}

let Restricts =
{
}

let Statics =
{
  TolerantFrom,
}

let Forbids =
{
}

let Accessors =
{
}

// --
// declare
// --

let Extension =
{

  TolerantFrom,
  init,
  _formAssociations,

  /* */

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
  extend : Extension,
});

_.Copyable.mixin( Self );
_.files[ Self.shortName ] = Self;

})();

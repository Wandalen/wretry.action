( function _Operator_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Parent = null;
const Self = wOperator;
function wOperator( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Operator';

// --
//
// --

function finit()
{
  let operator = this;
  operator.unform();

  _.assert( operator.missionSet.size === 0 );
  _.assert( operator.operationArray.length === 0 );
  _.assert( operator.deedArray.length === 0 );
  _.assert( _.props.keys( operator.filesMap ).length === 0 );

  return _.Copyable.prototype.finit.call( operator );
}

//

function init( o )
{
  let operator = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.workpiece.initFields( operator );

  if( operator.Self === Self )
  Object.preventExtensions( operator );

  if( o )
  operator.copy( o );

  operator.form();

  return operator;
}

//

function unform()
{
  let operator = this;

  _.container.each( operator.missionSet, ( mission ) => mission.finit() );
  _.container.each( operator.operationArray.slice(), ( operation ) => operation.finit() );

  _.assert( operator.missionSet.size === 0 );
  _.assert( operator.operationArray.length === 0 );
  _.assert( operator.deedArray.length === 0 );

  return operator;
}

//

function form()
{
  let operator = this;

  if( !operator.filesSystem )
  {
    let filesSystem = _.FileProvider.System({ providers : [] });
    _.FileProvider.Git().providerRegisterTo( filesSystem );
    _.FileProvider.Npm().providerRegisterTo( filesSystem );
    _.FileProvider.Http().providerRegisterTo( filesSystem );
    let defaultProvider = _.FileProvider.Default();
    defaultProvider.providerRegisterTo( filesSystem );
    filesSystem.defaultProvider = defaultProvider;
    operator.filesSystem = filesSystem;
  }

  _.assert( operator.counter === 0 );

  // operator.thirdOperation = _.files.operator.Operation({ operator });
  // _.assert( operator.thirdOperation.id === 1 );

  return operator;
}

//

function idAllocate()
{
  let operator = this;
  operator.counter += 1;
  return operator.counter;
}

//

function fileFor( globalPath, localPath )
{
  let operator = this;

  _.assert( _.strDefined( globalPath ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  let file = operator.filesMap[ globalPath ];
  if( !file )
  {
    file = _.files.operator.File
    ({
      globalPath,
      localPath : localPath || null,
      operator,
    });
    // file.form();
  }

  return file;
}

// --
// relations
// --

let Composes =
{
  counter : 0,
}

let Aggregates =
{
}

let Associates =
{
  missionSet : _.define.own( new Set ),
  operationArray : _.define.own([]),
  deedArray : _.define.own([]),
  filesMap : _.define.own({}),
}

let Restricts =
{
  filesSystem : null,
  // thirdOperation : null,
}

let Statics =
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

  idAllocate,
  fileFor,

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

_.Copyable.mixin( Self );
_.files[ Self.shortName ] = Self;
_.files.operator[ Self.shortName ] = Self;

})();

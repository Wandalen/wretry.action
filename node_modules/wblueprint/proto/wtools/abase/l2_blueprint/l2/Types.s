( function _Types_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

// --
// enums
// --

let DefinitionGroup = [ 'etc', 'trait', 'definition.unnamed', 'definition.named' ];

let DefinitionKnownFields =
{
  toVal : 'routine::toVal( map::o ) -> anything::',
  constructionAmend : 'routine::constructionAmend( Construction::construction Primitive::key ) -> Nothing::',
  blueprintAmend : 'routine::( map::o ) -> Nothing::',
  blueprintForm1 : 'routine::( Blueprint::blueprint ) -> Nothing::',
  blueprintForm2 : 'routine::( Blueprint::blueprint ) -> Nothing::',
  blueprintForm3 : 'routine::( Blueprint::blueprint ) -> Nothing::',
}

let BlueprintInternalRoutines =
{
  blueprintAmend : 'routine::( map::o ) -> Nothing::',
  blueprintForm1 : 'routine::( Blueprint::blueprint ) -> Nothing::',
  blueprintForm2 : 'routine::( Blueprint::blueprint ) -> Nothing::',
  blueprintForm3 : 'routine::( Blueprint::blueprint ) -> Nothing::',
}

let ConstructionRuntimeRoutines =
{
  constructionInit : { signature : 'routine::constructionInit( ConstructionContext::@ Genesis::@ ) -> Nothing::@', multiple : 1 },
  constructionAmend : { signature : 'routine::constructionAmend( Construction::@ Primitive::@ ) -> Nothing::@', multiple : 1 },
  allocate : { multiple : 0 },
  retype : { multiple : 0 },
  initBegin : { multiple : 1 },
  constructionInitEnd : { multiple : 1 },
}

let DefinitionExtension =
{

  DefinitionGroup,
  DefinitionKnownFields,

  BlueprintInternalRoutines,
  ConstructionRuntimeRoutines,

}

_.definition = _.definition || Object.create( null );
/* _.props.extend */Object.assign( _.definition, DefinitionExtension );

// --
// Blueprint
// --

function Blueprint()
{
  return _.blueprint.define( ... arguments );
}
Blueprint.prototype = Object.create( null );
Object.setPrototypeOf( Blueprint, null );
Object.preventExtensions( Blueprint );

// --
// define tools
// --

var ToolsExtension =
{

  Blueprint,

}

Object.assign( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

( function _PropertyTransformer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.props = _.props || Object.create( null );

// --
//
// --

function dstNotOwnFromDefinition()
{
  let routine = dstNotOwnFromDefinition;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotOwnFromDefinition( dstContainer, srcContainer, key )
  {

    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return;

    if( Object.hasOwnProperty.call( dstContainer, Symbol.for( key ) ) )
    return;

    let srcElement = srcContainer[ key ];
    if( _.definitionIs( srcElement ) )
    dstContainer[ key ] = srcElement.toVal( srcElement.val );
    else
    dstContainer[ key ] = srcElement;

  }

}

dstNotOwnFromDefinition.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function dstNotOwnFromDefinitionStrictlyPrimitive()
{
  let routine = dstNotOwnFromDefinitionStrictlyPrimitive;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotOwnFromDefinitionStrictlyPrimitive( dstContainer, srcContainer, key )
  {

    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return;

    if( Object.hasOwnProperty.call( dstContainer, Symbol.for( key ) ) )
    return;

    let srcElement = srcContainer[ key ];
    if( _.definitionIs( srcElement ) )
    {
      dstContainer[ key ] = srcElement.toVal( srcElement.val );
    }
    else
    {
      _.assert
      (
        !_.consequenceIs( srcElement ) && ( _.primitiveIs( srcElement ) || _.routineIs( srcElement ) ),
        () => `${ _.entity.exportStringDiagnosticShallow( dstContainer ) } has non-primitive element "${ key }",`
        + ` use _.define.own instead`
      );
      dstContainer[ key ] = srcElement;
    }

  }

}

dstNotOwnFromDefinitionStrictlyPrimitive.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

// --
// tools
// --

function mapSupplementOwnFromDefinition( dstMap, srcMap )
{
  return _.mapExtendConditional( _.props.mapper.dstNotOwnFromDefinition(), ... arguments );
}

//

function mapSupplementOwnFromDefinitionStrictlyPrimitives( dstMap, srcMap )
{
  return _.mapExtendConditional( _.props.mapper.dstNotOwnFromDefinitionStrictlyPrimitive(), ... arguments );
}

// --
// extension
// --

let Transformers =
{

  dstNotOwnFromDefinition,
  dstNotOwnFromDefinitionStrictlyPrimitive,

}

_.props.transformersRegister( Transformers );

//

let Extension =
{

  mapSupplementOwnFromDefinition,
  mapSupplementOwnFromDefinitionStrictlyPrimitives,

}

_.props.extend( _, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

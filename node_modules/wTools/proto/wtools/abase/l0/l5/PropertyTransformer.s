( function _l5_PropertyTransformer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function mapperFromCondition( routine )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.routine.is( routine ), 'Expects routine but got', _.entity.strType( routine ) );
  _.assert( !!routine.identity );

  if( routine.identity.propertyCondition )
  {
    if( routine.identity.functor )
    {
      functor.identity = { propertyMapper : true, propertyTransformer : true, functor : true };
      return functor;
    }
    else
    {
      mapper.identity = { propertyMapper : true, propertyTransformer : true };
      return mapper;
    }
  }
  else if( routine.identity.propertyMapper )
  {
    return routine;
  }
  else _.assert( 0, 'Expects PropertyTransformer' );

  function mapper( dstContainer, srcContainer, key )
  {
    let result = routine( dstContainer, srcContainer, key );
    _.assert( _.bool.is( result ) );
    if( result === false )
    return;
    dstContainer[ key ] = srcContainer[ key ];
  }

  function functor()
  {
    let routine2 = routine( ... arguments );
    _.assert( _.props.conditionIs( routine2 ) && !routine2.identity.functor );
    mapper.identity = { propertyMapper : true, propertyTransformer : true };
    return mapper;
    function mapper( dstContainer, srcContainer, key )
    {
      let result = routine2( dstContainer, srcContainer, key );
      _.assert( _.bool.is( result ) );
      if( result === false )
      return;
      dstContainer[ key ] = srcContainer[ key ];
    }
  }

}

//

function mapperFrom( routine )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.routine.is( routine ), 'Expects routine but got', _.entity.strType( routine ) );

  if( routine.identity )
  {
    if( routine.identity.propertyMapper )
    {
      routine.identity.propertyTransformer = true;
      return routine;
    }
    else
    {
      return _.props.mapperFromCondition( routine );
    }
  }

  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;
}

//

function conditionFrom( routine )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.routine.is( routine ), 'Expects routine but got', _.entity.strType( routine ) );

  if( routine.identity )
  {
    if( !routine.identity.propertyCondition )
    {
      _.assert( !routine.identity.propertyMapper, 'It is not possible to convert FieldMapper to FieldFilter' );
      _.assert( routine.identity.propertyCondition === undefined );
      routine.identity.propertyCondition = true;
    }
    routine.identity.propertyTransformer = true;
    return routine;
  }

  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;
}

//

function transformerRegister( fi, name )
{

  if( !name )
  name = fi.name;

  _.assert( _.strDefined( name ) );
  _.assert( _.object.isBasic( fi.identity ), 'Not property transformer' );
  _.assert( !!fi.identity );

  if( fi.identity.propertyMapper )
  {
    _.assert( _.props.mapper[ name ] === undefined );
    _.props.mapper[ name ] = mapperFrom( fi );
    return;
  }
  else if( fi.identity.propertyCondition )
  {
    _.assert( _.props.condition[ name ] === undefined );
    _.assert( _.props.mapper[ name ] === undefined );
    _.props.mapper[ name ] = _.props.mapperFromCondition( fi );
    _.props.condition[ name ] = fi;
    return;
  }
  else _.assert( 0, 'unexpected' );

}

//

function transformersRegister( transformers )
{

  _.assert( _.mapIs( transformers ) );

  for( let f in transformers )
  {
    let fi = transformers[ f ];

    // if( fi.length )
    // debugger;
    // if( fi.length ) /* xxx*/
    // continue;
    // fi = fi();

    _.assert( !!fi.identity && !!fi.identity.functor, `Routine::${f} is not functor` );
    _.props.transformerRegister( fi, f );
  }

}

//

function transformerUnregister( transformerName, transformerType )
{
  transformerType = transformerType || 'mapper';

  _.assert( _.strIs( transformerName ) );
  _.assert( _.strIs( transformerType ) );
  _.assert( _.props[ transformerType ][ transformerName ] !== undefined, 'Transformer must be registered' );

  delete _.props[ transformerType ][ transformerName ];
  return;
}

//

function transformersUnregister( transformerNames, transformerType )
{
  _.assert( _.arrayIs( transformerNames ) );
  _.assert( _.strIs( transformerType ) );

  transformerNames.forEach( ( transformerName ) => _.props.transformerUnregister( transformerName, transformerType ) )
  return;
}

//

function transformerIs( transformer )
{
  if( !_.routine.is( transformer ) )
  return false;
  if( !_.object.isBasic( transformer.identity ) )
  return false;

  let result =
  (
    !!( transformer.identity.propertyTransformer
    || transformer.identity.propertyCondition
    || transformer.identity.propertyMapper )
  );

  return result;
}

//

function mapperIs( transformer )
{
  if( !_.routine.is( transformer ) )
  return false;
  if( !_.object.isBasic( transformer.identity ) )
  return false;
  return !!transformer.identity.propertyMapper;
}

//

function conditionIs( transformer )
{
  if( !_.routine.is( transformer ) )
  return false;
  if( !_.object.isBasic( transformer.identity ) )
  return false;
  return !!transformer.identity.propertyCondition;
}

// --
// extend
// --

let PropsExtension =
{

  mapperFromCondition,
  mapperFrom,
  conditionFrom,
  transformerRegister, 
  transformersRegister,
  transformerUnregister,
  transformersUnregister,
  transformerIs,
  mapperIs,
  conditionIs,

}

Object.assign( _.props, PropsExtension );

})();

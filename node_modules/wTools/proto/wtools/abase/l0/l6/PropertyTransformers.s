( function _PropertyTransformer_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
//
// --

function bypass()
{
  let routine = bypass;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function bypass( dstContainer, srcContainer, key )
  {
    /*dstContainer[ key ] = srcContainer[ key ];*/
    return true;
  }
}

bypass.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function assigning()
{
  let routine = assigning;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;
  function assigning( dstContainer, srcContainer, key )
  {
    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
  }
}

assigning.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function primitive()
{
  let routine = primitive;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function primitive( dstContainer, srcContainer, key )
  {
    if( !_.primitive.is( srcContainer[ key ] ) )
    return false;

    return true;
  }
}

primitive.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function hiding()
{
  let routine = hiding;

  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function hiding( dstContainer, srcContainer, key )
  {
    let properties =
    {
      value : srcContainer[ key ],
      enumerable : false,
      configurable : true,
    };
    Object.defineProperty( dstContainer, key, properties );
  }

}

hiding.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function appendingAnything()
{
  let routine = appendingAnything;

  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function appendingAnything( dstContainer, srcContainer, key )
  {
    if( dstContainer[ key ] === undefined )
    dstContainer[ key ] = srcContainer[ key ];
    else if( _.arrayIs( dstContainer[ key ] ) )
    dstContainer[ key ] = _.arrayAppendArrays( dstContainer[ key ], [ srcContainer[ key ] ] );
    else
    dstContainer[ key ] = _.arrayAppendArrays( [], [ dstContainer[ key ], srcContainer[ key ] ] );
  }

}

appendingAnything.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function prependingAnything()
{
  let routine = prependingAnything;

  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function prependingAnything( dstContainer, srcContainer, key )
  {
    if( dstContainer[ key ] === undefined )
    dstContainer[ key ] = srcContainer[ key ];
    else if( _.arrayIs( dstContainer[ key ] ) )
    dstContainer[ key ] = _.arrayPrependArrays( dstContainer[ key ], [ srcContainer[ key ] ] );
    else
    dstContainer[ key ] = _.arrayPrependArrays( [], [ dstContainer[ key ], srcContainer[ key ] ] );
  }

}

prependingAnything.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function appendingOnlyArrays()
{
  let routine = appendingOnlyArrays;

  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function appendingOnlyArrays( dstContainer, srcContainer, key )
  {
    if( _.arrayIs( dstContainer[ key ] ) && _.arrayIs( srcContainer[ key ] ) )
    _.arrayAppendArray( dstContainer[ key ], srcContainer[ key ] );
    else
    dstContainer[ key ] = srcContainer[ key ];
  }

}

appendingOnlyArrays.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function appendingOnce()
{
  let routine = appendingOnce;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function appendingOnce( dstContainer, srcContainer, key )
  {
    if( _.arrayIs( dstContainer[ key ] ) && _.arrayIs( srcContainer[ key ] ) )
    _.arrayAppendArrayOnce( dstContainer[ key ], srcContainer[ key ] );
    else
    dstContainer[ key ] = srcContainer[ key ];
  }

}

appendingOnce.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function removing()
{
  let routine = removing;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function removing( dstContainer, srcContainer, key )
  {
    let dstElement = dstContainer[ key ];
    let srcElement = srcContainer[ key ];
    if( _.arrayIs( dstElement ) && _.arrayIs( srcElement ) )
    {
      if( dstElement === srcElement )
      dstContainer[ key ] = [];
      else
      _.arrayRemoveArrayOnce( dstElement, srcElement );
    }
    else if( dstElement === srcElement )
    {
      delete dstContainer[ key ];
    }
  }

}

removing.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function notPrimitiveAssigning()
{
  let routine = notPrimitiveAssigning;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function notPrimitiveAssigning( dstContainer, srcContainer, key )
  {
    if( _.primitive.is( srcContainer[ key ] ) )
    return;

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
  }

}

notPrimitiveAssigning.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function assigningRecursive()
{
  let routine = assigningRecursive;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function assigningRecursive( dstContainer, srcContainer, key )
  {
    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key, _.entity.assign2FieldFromContainer );
  }

}

assigningRecursive.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function drop( dropContainer )
{

  debugger;

  _.assert( _.object.isBasic( dropContainer ) );

  let routine = drop;

  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function drop( dstContainer, srcContainer, key )
  {
    if( dropContainer[ key ] !== undefined )
    return false

    /*dstContainer[ key ] = srcContainer[ key ];*/
    return true;
  }

}

drop.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function notIdentical()
{
  let routine = notIdentical;
  routine.identity = { propertyCondition : true, propertyTransformer : true }; ;
  return routine;
  function notIdentical( dstContainer, srcContainer, key )
  {
    if( dstContainer[ key ] === srcContainer[ key ] )
    return false;
    return true;
  }
}

notIdentical.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

// --
// src
// --

function srcDefined()
{
  let routine = srcDefined;
  routine.identity = { propertyCondition : true, propertyTransformer : true }; ;
  return routine;

  function srcDefined( dstContainer, srcContainer, key )
  {
    if( srcContainer[ key ] === undefined )
    return false;
    return true;
  }
}

srcDefined.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotHasOrSrcNotNull()
{
  let routine = dstNotHasOrSrcNotNull;
  routine.identity = { propertyCondition : true, propertyTransformer : true }; ;
  return routine;
  function dstNotHasOrSrcNotNull( dstContainer, srcContainer, key )
  {
    if( key in dstContainer && dstContainer[ key ] !== undefined )
    return false;
    if( srcContainer[ key ] === null )
    return false;
    return true;
  }
}

dstNotHasOrSrcNotNull.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

// --
// dst
// --

function dstNotConstant()
{
  let routine = dstNotConstant;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotConstant( dstContainer, srcContainer, key )
  {
    let d = Object.getOwnPropertyDescriptor( dstContainer, key );
    if( !d )
    return true;
    if( !d.writable )
    return false;
    return true;
  }

}

dstNotConstant.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstAndSrcOwn()
{
  let routine = dstAndSrcOwn;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstAndSrcOwn( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return false;
    if( !Object.hasOwnProperty.call( dstContainer, key ) )
    return false;

    return true;
  }

}

dstAndSrcOwn.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstUndefinedSrcNotUndefined()
{
  let routine = dstUndefinedSrcNotUndefined;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstUndefinedSrcNotUndefined( dstContainer, srcContainer, key )
  {
    if( dstContainer[ key ] !== undefined )
    return false;
    if( srcContainer[ key ] === undefined )
    return false;
    return true;
  }

}

dstUndefinedSrcNotUndefined.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

// --
// dstNotHas
// --

function dstNotHas()
{
  let routine = dstNotHas;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotHas( dstContainer, srcContainer, key )
  {

    if( key in dstContainer )
    return false;

    return true;
  }

}

dstNotHas.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotHasOrHasNull()
{
  let routine = dstNotHasOrHasNull;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotHasOrHasNull( dstContainer, srcContainer, key )
  {
    if( key in dstContainer && dstContainer[ key ] !== null )
    return false;
    return true;
  }

}

dstNotHasOrHasNull.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotHasOrHasNil()
{
  let routine = dstNotHasOrHasNil;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotHasOrHasNil( dstContainer, srcContainer, key )
  {

    if( key in dstContainer && dstContainer[ key ] !== _.nothing )
    return false;

    return true;
  }

}

dstNotHasOrHasNil.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotHasAssigning()
{
  let routine = dstNotHasAssigning;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotHasAssigning( dstContainer, srcContainer, key )
  {
    if( dstContainer[ key ] !== undefined )
    return;

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
  }

}

dstNotHasAssigning.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function dstNotHasAppending()
{
  let routine = dstNotHasAppending;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotHasAppending( dstContainer, srcContainer, key )
  {
    if( key in dstContainer )
    {
      debugger;
      if( _.arrayIs( dstContainer[ key ] ) && _.arrayIs( srcContainer[ key ] ) )
      _.arrayAppendArray( dstContainer, srcContainer, key );
      return;
    }
    dstContainer[ key ] = srcContainer[ key ];
  }

}

dstNotHasAppending.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function dstNotHasSrcPrimitive()
{
  let routine = dstNotHasSrcPrimitive;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotHasSrcPrimitive( dstContainer, srcContainer, key )
  {
    debugger;
    if( key in dstContainer )
    return false;

    if( !_.primitive.is( srcContainer[ key ] ) )
    return false;

    return true;
  }

}

dstNotHasSrcPrimitive.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotHasSrcOwn()
{
  let routine = dstNotHasSrcOwn;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotHasSrcOwn( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return false;
    if( key in dstContainer )
    return false;

    /*dstContainer[ key ] = srcContainer[ key ];*/
    return true;
  }

}

dstNotHasSrcOwn.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotHasSrcOwnAssigning()
{
  let routine = dstNotHasSrcOwnAssigning;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotHasSrcOwnAssigning( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return;
    if( key in dstContainer )
    return;

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
  }

}

dstNotHasSrcOwnAssigning.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function dstNotHasSrcOwnRoutines()
{
  let routine = dstNotHasSrcOwnRoutines;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotHasSrcOwnRoutines( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return false;
    if( !_.routine.is( srcContainer[ key ] ) )
    return false;
    if( key in dstContainer )
    return false;

    /*dstContainer[ key ] = srcContainer[ key ];*/

    return true;
  }

}

dstNotHasSrcOwnRoutines.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotHasAssigningRecursive()
{
  let routine = dstNotHasAssigningRecursive;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotHasAssigningRecursive( dstContainer, srcContainer, key )
  {
    if( key in dstContainer )
    return;

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key, _.entity.assign2FieldFromContainer );
  }

}

dstNotHasAssigningRecursive.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

// --
// dstOwn
// --

function dstOwn()
{
  let routine = dstOwn;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstOwn( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( dstContainer, key ) )
    return false;
    return true;
  }

}

dstOwn.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotOwn()
{
  let routine = dstNotOwn;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotOwn( dstContainer, srcContainer, key )
  {
    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return false;
    return true;
  }

}

dstNotOwn.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotOwnNotSame()
{
  let routine = dstNotOwnNotSame;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotOwnNotSame( dstContainer, srcContainer, key )
  {
    if( key === 'groupTextualReport' )
    debugger;
    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return false;
    if( dstContainer[ key ] === srcContainer[ key ] )
    return false;
    return true;
  }

}

dstNotOwnNotSame.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotOwnSrcOwn()
{
  let routine = dstNotOwnSrcOwn;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstNotOwnSrcOwn( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return false;

    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return false;

    return true;
  }

}

dstNotOwnSrcOwn.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstNotOwnSrcOwnAssigning()
{
  let routine = dstNotOwnSrcOwnAssigning;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotOwnSrcOwnAssigning( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return;

    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return;

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
  }

}

dstNotOwnSrcOwnAssigning.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function dstNotOwnOrUndefinedAssigning()
{
  let routine = dstNotOwnOrUndefinedAssigning;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotOwnOrUndefinedAssigning( dstContainer, srcContainer, key )
  {

    if( Object.hasOwnProperty.call( dstContainer, key ) )
    {

      if( dstContainer[ key ] !== undefined )
      return;

    }

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
  }

}

dstNotOwnOrUndefinedAssigning.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function dstNotOwnAssigning()
{
  let routine = dstNotOwnAssigning;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotOwnAssigning( dstContainer, srcContainer, key )
  {

    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return;

    let srcElement = srcContainer[ key ];
    if( _.mapIs( srcElement ) || _.arrayIs( srcElement ) )
    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
    else
    dstContainer[ key ] = srcContainer[ key ];

  }

}

dstNotOwnAssigning.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function dstNotOwnAppending()
{
  let routine = dstNotOwnAppending;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function dstNotOwnAppending( dstContainer, srcContainer, key )
  {
    debugger;
    if( dstContainer[ key ] !== undefined )
    {
      debugger;
      if( _.arrayIs( dstContainer[ key ] ) && _.arrayIs( srcContainer[ key ] ) )
      _.arrayAppendArray( dstContainer, srcContainer, key );
    }
    if( Object.hasOwnProperty.call( dstContainer, key ) )
    return;
    dstContainer[ key ] = srcContainer[ key ];
  }

}

dstNotOwnAppending.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

// --
// dstHas
// --

function dstHasMaybeUndefined()
{
  let routine = dstHasMaybeUndefined;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstHasMaybeUndefined( dstContainer, srcContainer, key )
  {
    if( key in dstContainer )
    return true;
    return false;
  }

}

dstHasMaybeUndefined.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstHasButUndefined()
{
  let routine = dstHasButUndefined;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstHasButUndefined( dstContainer, srcContainer, key )
  {
    if( dstContainer[ key ] === undefined )
    return false;
    return true;
  }

}

dstHasButUndefined.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstHasSrcOwn()
{
  let routine = dstHasSrcOwn;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstHasSrcOwn( dstContainer, srcContainer, key )
  {
    if( !( key in dstContainer ) )
    return false;
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return false;
    return true;
  }

}

dstHasSrcOwn.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function dstHasSrcNotOwn()
{
  let routine = dstHasSrcNotOwn;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function dstHasSrcNotOwn( dstContainer, srcContainer, key )
  {
    if( !( key in dstContainer ) )
    return false;
    if( Object.hasOwnProperty.call( srcContainer, key ) )
    return false;
    return true;
  }

}

dstHasSrcNotOwn.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

// --
// srcOwn
// --

function srcOwn()
{
  let routine = srcOwn;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function srcOwn( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return false;

    /*dstContainer[ key ] = srcContainer[ key ];*/
    return true;
  }

}

srcOwn.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function srcOwnRoutines()
{
  let routine = srcOwnRoutines;
  routine.identity = { propertyCondition : true, propertyTransformer : true }; ;
  return routine;

  function srcOwnRoutines( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return false;
    if( !_.routine.is( srcContainer[ key ] ) )
    return false;

    /*dstContainer[ key ] = srcContainer[ key ];*/
    return true;
  }

}

srcOwnRoutines.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function srcOwnAssigning()
{
  let routine = assigning;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function assigning( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return;

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
  }

}

srcOwnAssigning.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function srcOwnPrimitive()
{
  let routine = srcOwnPrimitive;
  routine.identity = { propertyCondition : true, propertyTransformer : true };
  return routine;

  function srcOwnPrimitive( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return false;
    if( !_.primitive.is( srcContainer[ key ] ) )
    return false;

    /*dstContainer[ key ] = srcContainer[ key ];*/
    return true;
  }

}

srcOwnPrimitive.identity = { propertyCondition : true, propertyTransformer : true, functor : true };

//

function srcOwnNotPrimitiveAssigning()
{
  let routine = srcOwnNotPrimitiveAssigning;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function srcOwnNotPrimitiveAssigning( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return;
    if( _.primitive.is( srcContainer[ key ] ) )
    return;

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key );
  }

}

srcOwnNotPrimitiveAssigning.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function srcOwnNotPrimitiveAssigningRecursive()
{
  let routine = srcOwnNotPrimitiveAssigningRecursive;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function srcOwnNotPrimitiveAssigningRecursive( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return;
    if( _.primitive.is( srcContainer[ key ] ) )
    return;

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key, _.entity.assign2FieldFromContainer );
  }

}

srcOwnNotPrimitiveAssigningRecursive.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

//

function srcOwnAssigningRecursive()
{
  let routine = srcOwnAssigningRecursive;
  routine.identity = { propertyMapper : true, propertyTransformer : true };
  return routine;

  function srcOwnAssigningRecursive( dstContainer, srcContainer, key )
  {
    if( !Object.hasOwnProperty.call( srcContainer, key ) )
    return;

    _.entity.assign2FieldFromContainer( dstContainer, srcContainer, key, _.entity.assign2FieldFromContainer );
  }

}

srcOwnAssigningRecursive.identity = { propertyMapper : true, propertyTransformer : true, functor : true };

// --
// make
// --

let _Transformers =
{

  //

  bypass,
  assigning,
  primitive,
  hiding,
  appendingAnything,
  prependingAnything,
  appendingOnlyArrays,
  appendingOnce,
  removing,
  notPrimitiveAssigning,
  assigningRecursive,
  drop,
  notIdentical,

  // src

  srcDefined,
  dstNotHasOrSrcNotNull,

  // dst

  dstNotConstant,
  dstAndSrcOwn,
  dstUndefinedSrcNotUndefined,

  // dstNotHas

  dstNotHas,
  dstNotHasOrHasNull,
  dstNotHasOrHasNil,

  dstNotHasAssigning,
  dstNotHasAppending,
  dstNotHasSrcPrimitive,

  dstNotHasSrcOwn,
  dstNotHasSrcOwnAssigning,
  dstNotHasSrcOwnRoutines,
  dstNotHasAssigningRecursive,

  // dstOwn

  dstOwn,
  dstNotOwn,
  dstNotOwnNotSame,
  dstNotOwnSrcOwn,
  dstNotOwnSrcOwnAssigning,
  dstNotOwnOrUndefinedAssigning,
  dstNotOwnAssigning,
  dstNotOwnAppending,

  // dstHas

  dstHasMaybeUndefined,
  dstHasButUndefined,
  dstHasSrcOwn,
  dstHasSrcNotOwn,

  // srcOwn

  srcOwn,
  srcOwnRoutines,
  srcOwnAssigning,
  srcOwnPrimitive,
  srcOwnNotPrimitiveAssigning,
  srcOwnNotPrimitiveAssigningRecursive,
  srcOwnAssigningRecursive,

}

// --
// extend
// --

_.props.transformersRegister( _Transformers );

})();

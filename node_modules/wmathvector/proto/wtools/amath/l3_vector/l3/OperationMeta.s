(function _OperationMeta_s_() {

'use strict';

const _ = _global_.wTools;
const _hasLength = _.vector.hasLength;
const _longSlice = _.longSlice;
const _sqr = _.math.sqr;
const _sqrt = _.math.sqrt;
// let _assertMapHasOnly = _.map.assertHasOnly;
const _routineIs = _.routineIs;

const _min = Math.min;
const _max = Math.max;
const _pow = Math.pow;
const sqrt = Math.sqrt;
const abs = Math.abs;

const meta = _.vectorAdapter._meta = _.vectorAdapter._meta || Object.create( null );
_.vectorAdapter._meta.routines = _.vectorAdapter._meta.routines || Object.create( null );

// --
// structure
// --

function operationSupplement( operation, scalarOperation )
{
  operation = _.props.supplement( operation, scalarOperation );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  /* */

  if( _.routineIs( operation.onContinue ) )
  operation.onContinue = [ operation.onContinue ];
  else if( !operation.onContinue )
  operation.onContinue = [];

  if( _.routineIs( operation.onScalar ) )
  operation.onScalar = [ operation.onScalar ];
  else if( !operation.onScalar )
  operation.onScalar = [];

  if( _.routineIs( operation.onScalarsBegin ) )
  operation.onScalarsBegin = [ operation.onScalarsBegin ];
  else if( !operation.onScalarsBegin )
  operation.onScalarsBegin = [];

  if( _.routineIs( operation.onScalarsEnd ) )
  operation.onScalarsEnd = [ operation.onScalarsEnd ];
  else if( !operation.onScalarsEnd )
  operation.onScalarsEnd = [];

  if( _.routineIs( operation.onVectorsBegin ) )
  operation.onVectorsBegin = [ operation.onVectorsBegin ];
  else if( !operation.onVectorsBegin )
  operation.onVectorsBegin = [];

  if( _.routineIs( operation.onVectorsEnd ) )
  operation.onVectorsEnd = [ operation.onVectorsEnd ];
  else if( !operation.onVectorsEnd )
  operation.onVectorsEnd = [];

  if( _.routineIs( operation.onVectors ) )
  operation.onVectors = [ operation.onVectors ];
  else if( !operation.onVectors )
  operation.onVectors = [];

  /* */

  if( operation.onContinue === scalarOperation.onContinue )
  operation.onContinue = operation.onContinue.slice();

  if( operation.onScalar === scalarOperation.onScalar )
  operation.onScalar = operation.onScalar.slice();

  if( operation.onScalarsBegin === scalarOperation.onScalarsBegin )
  operation.onScalarsBegin = operation.onScalarsBegin.slice();

  if( operation.onScalarsEnd === scalarOperation.onScalarsEnd )
  operation.onScalarsEnd = operation.onScalarsEnd.slice();

  if( operation.onVectorsBegin === scalarOperation.onVectorsBegin )
  operation.onVectorsBegin = operation.onVectorsBegin.slice();

  if( operation.onVectorsEnd === scalarOperation.onVectorsEnd )
  operation.onVectorsEnd = operation.onVectorsEnd.slice();

  if( operation.onVectors === scalarOperation.onVectors )
  operation.onVectors = operation.onVectors.slice();

  /* */

  if( _.numberIs( operation.takingArguments ) )
  operation.takingArguments = [ operation.takingArguments, operation.takingArguments ];
  else if( operation.takingArguments && operation.takingArguments === scalarOperation.takingArguments )
  operation.takingArguments = operation.takingArguments.slice();

  if( _.numberIs( operation.takingVectors ) )
  operation.takingVectors = [ operation.takingVectors, operation.takingVectors ];
  else if( operation.takingVectors && operation.takingVectors === scalarOperation.takingVectors )
  operation.takingVectors = operation.takingVectors.slice();

  return operation;
}

//

function _operationLogicalReducerAdjust( operation )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  let def =
  {
    usingExtraSrcs : 0,
    usingDstAsSrc : 0,
    interruptible : 1,
    reducing : 1,
    returningPrimitive : 1,
    returningBoolean : 1,
    returningNumber : 0,
    returningNew : 0,
    returningSelf : 0,
    returningLong : 0,
    modifying : 0,
  }

  _.props.extend( operation, def );

}

//

function operationNormalizeInput( operation, routineName )
{

  let delimeter = [ 'w', 'r', 'v', 's', 'm', 't', 'a', 'n', '?', '*', '+', '!' ];
  let tokenRoutine =
  {
    'w' : tokenWrite,
    'r' : tokenRead,
    'v' : tokenVector,
    'l' : tokenLong,
    's' : tokenScalar,
    'm' : tokenMatrix,
    't' : tokenSomething,
    'a' : tokenAnything,
    'n' : tokenNull,
    '?' : tokenTimesOptional,
    '*' : tokenTimesAny,
    '+' : tokenTimesAtLeast,
    '!' : tokenBut,
  }

  if( _.strIs( operation.input ) )
  operation.input = operation.input.split( ' ' );

  if( _.mapIs( operation.input ) )
  return operation.input;

  routineName = routineName || operation.name;

  _.assert( _.strDefined( routineName ) );
  _.assert( _.longIs( operation.input ), () => `Routine::${routineName} does not have operation.input` );

  operation.input = _.longSlice( operation.input );
  // operation.input = _.longOnly( operation.input );

  // logger.log( `operationNormalizeInput ${routineName}` );

  let definition = operation.input.join( ' ' );

  for( let i = 0 ; i < operation.input.length ; i++ )
  {
    operation.input[ i ] = argParse( operation.input[ i ] );
  }

  let inputDescriptor = Object.create( null );
  inputDescriptor.definition = definition;
  inputDescriptor.args = operation.input;
  inputDescriptor.takingArguments = [ 0, 0 ];
  inputDescriptor.takingVectors = [ 0, 0 ];
  inputDescriptor.takingVectorsOnly = true;
  operation.input = inputDescriptor;

  seriesByLengthForm();
  takingForm();

  return inputDescriptor;

  /* */

  function argParse( definition )
  {
    let argDescriptor = Object.create( null );
    argDescriptor.types = [];
    argDescriptor.readable = false;
    argDescriptor.writable = false;
    argDescriptor.alternatives = [];
    argDescriptor.definition = definition;
    argDescriptor.times = [ Infinity, 0 ];
    argDescriptor.isVector = null;
    let alternatives = definition.split( '|' );
    for( let i = 0 ; i < alternatives.length ; i++ )
    {
      let typeDescriptor = typeParse( alternatives[ i ] )
      typeCollect( argDescriptor, typeDescriptor );
    }
    return argDescriptor;
  }

  /* */

  function typeCollect( argDescriptor, typeDescriptor )
  {

    _.assert( _.strIs( typeDescriptor.type ) );
    argDescriptor.types.push( typeDescriptor.type );

    _.assert( _.boolIs( typeDescriptor.writable ) )
    if( typeDescriptor.writable )
    argDescriptor.writable = typeDescriptor.writable;

    _.assert( _.boolIs( typeDescriptor.readable ) )
    if( typeDescriptor.readable )
    argDescriptor.readable = typeDescriptor.readable;

    argDescriptor.times[ 0 ] = Math.min( argDescriptor.times[ 0 ], typeDescriptor.times[ 0 ] );
    argDescriptor.times[ 1 ] = Math.max( argDescriptor.times[ 1 ], typeDescriptor.times[ 1 ] );

    _.assert( typeDescriptor.isVector === _.maybe || _.boolIs( typeDescriptor.isVector ) );

    // argDescriptor.isVector = _.fuzzy.and( argDescriptor.isVector, argDescriptor.isVector ); /* zzz */

    if( argDescriptor.isVector === null )
    {
      argDescriptor.isVector = typeDescriptor.isVector;
    }
    else if( argDescriptor.isVector !== _.maybe && typeDescriptor.type !== 'n' )
    {
      if( typeDescriptor.isVector === _.maybe || argDescriptor.isVector === _.maybe )
      argDescriptor.isVector = _.maybe;
      else if( typeDescriptor.isVector === false && argDescriptor.isVector === true )
      argDescriptor.isVector = _.maybe;
      else if( typeDescriptor.isVector === true && argDescriptor.isVector === false )
      argDescriptor.isVector = _.maybe;
      else
      argDescriptor.isVector = typeDescriptor.isVector;
    }

  }

  /* */

  function tokenWrite( c )
  {
    c.typeDescriptor.writable = true;
  }

  /* */

  function tokenRead( c )
  {
    c.typeDescriptor.readable = true;
  }

  /* */

  function tokenVector( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 'v';
    if( !_.longHas( c.splits, '!' ) )
    {
      _.assert( c.typeDescriptor.isVector === null );
      c.typeDescriptor.isVector = true;
    }
  }

  /* */

  function tokenLong( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 'l';
    _.assert( c.typeDescriptor.isVector === null );
    c.typeDescriptor.isVector = false;
  }

  /* */

  function tokenScalar( c )
  {
    c.typeDescriptor.readable = true;
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 's';
    _.assert( c.typeDescriptor.isVector === null );
    c.typeDescriptor.isVector = false;
  }

  /* */

  function tokenMatrix( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 'm';
    _.assert( c.typeDescriptor.isVector === null );
    c.typeDescriptor.isVector = false;
  }

  /* */

  function tokenSomething( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 't';
    if( !_.longHas( c.splits, '!' ) )
    {
      _.assert( c.typeDescriptor.isVector === null );
      c.typeDescriptor.isVector = false;
    }
  }

  /* */

  function tokenAnything( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 'a';
    if( !_.longHas( c.splits, '!' ) )
    {
      _.assert( c.typeDescriptor.isVector === null );
      c.typeDescriptor.isVector = _.maybe;
    }
  }

  /* */

  function tokenNull( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 'n';
    _.assert( c.typeDescriptor.isVector === null );
    c.typeDescriptor.isVector = false;
  }

  /* */

  function tokenTimesOptional( c )
  {
    _.assert( c.typeDescriptor.times[ 0 ] === 1 );
    c.typeDescriptor.times[ 0 ] = 0;
  }

  /* */

  function tokenTimesAny( c )
  {
    if( c.i > 0 && !_.longHas( delimeter, c.splits[ c.i-1 ] ) )
    return;
    _.assert( c.typeDescriptor.times[ 0 ] === 1 );
    _.assert( c.typeDescriptor.times[ 1 ] === 1 );
    c.typeDescriptor.times[ 0 ] = 0;
    c.typeDescriptor.times[ 1 ] = Infinity;
  }

  /* */

  function tokenTimesAtLeast( c )
  {
    _.assert( c.typeDescriptor.times[ 0 ] === 1 );
    _.assert( c.typeDescriptor.times[ 1 ] === 1 );
    c.typeDescriptor.times[ 0 ] = 1;
    c.typeDescriptor.times[ 1 ] = Infinity;
  }

  /* */

  function tokenBut( c )
  {
    _.assert( c.i+1 < c.splits.length );
    let next = c.splits[ c.i+1 ];
    c.typeDescriptor.type = '!' + next;
    c.i += 1;
    _.assert( c.typeDescriptor.isVector === null );
    if( next === 'v' || next === 'a' )
    c.typeDescriptor.isVector = false;
    else
    c.typeDescriptor.isVector = _.maybe;
  }

  /* */

  function tokenEtc( c )
  {
    let times = _.numberFromStr( c.split );
    _.assert( _.numberDefined( times ) );
    _.assert( c.splits[ c.i+1 ] === '*' );
    _.assert( c.typeDescriptor.times[ 0 ] === 1 );
    _.assert( c.typeDescriptor.times[ 1 ] === 1 );
    c.typeDescriptor.times[ 0 ] = times;
    c.typeDescriptor.times[ 1 ] = times;
  }

  /* */

  function typeParse( definition )
  {
    let c = Object.create( null );
    c.typeDescriptor = Object.create( null );
    c.typeDescriptor.type = null;
    c.typeDescriptor.readable = false;
    c.typeDescriptor.writable = false;
    c.typeDescriptor.definition = definition;
    c.typeDescriptor.times = [ 1, 1 ];
    c.typeDescriptor.isVector = null;
    c.splits = _.strSplitFast({ src : definition, delimeter : delimeter, preservingEmpty : 0 });

    for( let i = 0 ; i < c.splits.length ; i++ )
    {
      c.split = c.splits[ i ];
      c.i = i;

      let routine = tokenRoutine[ c.split ];
      if( !routine )
      routine = tokenEtc;

      routine( c );
      i = c.i;
    }

    return c.typeDescriptor;
  }

  /* */

  function seriesByLengthForm()
  {
    let alternatives = [ [] ];

    // if( routineName === 'add' )
    // debugger;
    // if( inputDescriptor.definition === '?vw|?n 3*vr|3*s' )
    // debugger;

    for( let i = 0 ; i < inputDescriptor.args.length ; i++ )
    {
      let argDescriptor = inputDescriptor.args[ i ];

      _.assert( argDescriptor.times[ 1 ] >= 1 );

      // if( routineName === 'add' )
      // debugger;

      let first = 0;
      let last = alternatives.length-1;
      let al = alternatives.length;
      if( argDescriptor.times[ 0 ] === 0 )
      {
        for( let a = 0 ; a < al ; a++ )
        {
          alternatives[ a+al ] = alternatives[ a ].slice();
        }
        first += al;
        last += al;
      }

      // let tl = Math.min( argDescriptor.times[ 1 ], 5 );
      // for( let t = Math.max( argDescriptor.times[ 0 ], 1 ) ; t <= tl ; t++ )
      {
        let last2 = Math.max( argDescriptor.times[ 0 ], 1 );
        for( let a = first ; a <= last ; a++ )
        {
          for( let d = 1 ; d <= last2 ; d++ )
          {
            alternatives[ a ].push( argDescriptor.types.slice() );
          }
        }
      }

      {
        let first2 = Math.max( argDescriptor.times[ 0 ]+1, 2 );
        let last2 = Math.min( argDescriptor.times[ 1 ], 5 );
        for( let t = first2 ; t <= last2 ; t++ )
        {
          for( let a = first ; a <= last ; a++ )
          {
            let alt2 = alternatives[ a ].slice();
            alternatives.push( alt2 );
            for( let d = 2 ; d <= t ; d++ )
            {
              alt2.push( argDescriptor.types.slice() );
            }
          }
        }
      }

    }

    // if( routineName === 'add' )
    // debugger;

    inputDescriptor.seriesByLength = Object.create( null );

    // if( inputDescriptor.definition === '?vw|?n 3*vr|3*s' )
    // debugger;

    for( let a = 0 ; a < alternatives.length ; a++ )
    {
      let alt = alternatives[ a ];
      if( !inputDescriptor.seriesByLength[ alt.length ] )
      {
        let series = inputDescriptor.seriesByLength[ alt.length ] = [];
        for( let s = 0 ; s < alt.length ; s++ )
        series[ s ] = alt[ s ].slice();
      }
      else
      {
        let series = inputDescriptor.seriesByLength[ alt.length ];
        for( let s = 0 ; s < alt.length ; s++ )
        _.arrayAppendArrayOnce( series[ s ], alt[ s ] );
      }
    }

    // if( inputDescriptor.definition === '?vw|?n 3*vr|3*s' )
    // debugger;

  }

  /* */

  function takingForm()
  {

    for( let i = 0 ; i < inputDescriptor.args.length ; i++ )
    {
      let argDescriptor = inputDescriptor.args[ i ];

      inputDescriptor.takingArguments[ 0 ] += argDescriptor.times[ 0 ];
      inputDescriptor.takingArguments[ 1 ] += argDescriptor.times[ 1 ];
      if( argDescriptor.isVector )
      {
        if( argDescriptor.isVector === true )
        inputDescriptor.takingVectors[ 0 ] += argDescriptor.times[ 0 ];
        inputDescriptor.takingVectors[ 1 ] += argDescriptor.times[ 1 ];
        if( argDescriptor.isVector === _.maybe )
        inputDescriptor.takingVectorsOnly = false;
      }
      else
      {
        inputDescriptor.takingVectorsOnly = false;
      }
    }

  }

  /* */

  /*

  'vw' 'vw|s', 'vr|s', '?vr', '*a', '3*a'

  */
}

//

function operationNormalizeArity( operation )
{

  _.assert( !!operation.input );

  if( operation.takingArguments === undefined || operation.takingArguments === null )
  operation.takingArguments = operation.input.takingArguments;
  // if( operation.takingArguments === undefined || operation.takingArguments === null )
  // operation.takingArguments = operation.takingVectors;

  if( operation.takingVectors === undefined || operation.takingVectors === null )
  operation.takingVectors = operation.input.takingVectors;
  // if( operation.takingVectors === undefined || operation.takingVectors === null )
  // operation.takingVectors = operation.takingArguments;

  if( operation.takingArguments === undefined || operation.takingArguments === null )
  operation.takingArguments = [ 1, Infinity ];

  if( operation.takingVectors === undefined || operation.takingVectors === null )
  operation.takingVectors = [ 1, Infinity ];

  operation.takingArguments = _.numbersFromNumber( operation.takingArguments, 2 ).slice();
  operation.takingVectors = _.numbersFromNumber( operation.takingVectors, 2 ).slice();

  if( operation.takingArguments[ 0 ] < operation.takingVectors[ 0 ] )
  operation.takingArguments[ 0 ] = operation.takingVectors[ 0 ];

  if( operation.takingVectorsOnly === undefined || operation.takingVectorsOnly === null )
  operation.takingVectorsOnly = operation.input.takingVectorsOnly;

  if( operation.takingVectorsOnly === undefined || operation.takingVectorsOnly === null )
  if( operation.takingVectors[ 0 ] === operation.takingVectors[ 1 ] && operation.takingVectors[ 1 ] === operation.takingArguments[ 1 ] )
  operation.takingVectorsOnly = true;

  operation.inputWithoutLast = operation.input.args.slice( 0, operation.input.args.length-1 );
  operation.inputLast = operation.input.args[ operation.input.args.length-1 ];

  return operation;
}

//

function operationNormalize1( operation )
{

  if( !operation.name )
  operation.name = operation.onScalar.name;

  operation.onScalar.operation = operation;

  if( _.numberIs( operation.takingArguments ) )
  operation.takingArguments = [ operation.takingArguments, operation.takingArguments ];

  if( _.numberIs( operation.takingVectors ) )
  operation.takingVectors = [ operation.takingVectors, operation.takingVectors ];

  _.map.assertHasOnly( operation, _.vectorAdapter.OperationDescriptor0.propsExtension );

}

//

function operationNormalize2( operation )
{

  _.assert( operation.onVectorsBegin === undefined );
  _.assert( operation.onVectorsEnd === undefined );

  _.assert( _.mapIs( operation ) );
  _.assert( _.routineIs( operation.onScalar ) );
  _.assert( _.strDefined( operation.name ) );
  _.assert( operation.onScalar.length === 1 );

  _.assert( _.boolIs( operation.usingExtraSrcs ) );
  _.assert( _.boolIs( operation.usingDstAsSrc ) );

  _.assert( _.strIs( operation.kind ) );

  // _.map.assertHasOnly( operation, _.vectorAdapter.OperationDescriptor0.propsExtension );

}

//

function operationSinglerAdjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let scalarWiseSingler = operations.scalarWiseSingler = operations.scalarWiseSingler || Object.create( null );

  for( let name in routines.scalarWiseSingler )
  {
    let operation = routines.scalarWiseSingler[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'singler';

    if( operation.takingArguments === undefined )
    operation.takingArguments = [ 1, 1 ];
    operation.homogeneous = true;
    operation.scalarWise = true;

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;

    _.assert( _.arrayIs( operation.takingArguments ) );
    _.assert( operation.takingArguments.length === 2 );
    _.assert( !operations.scalarWiseSingler[ name ] );

    this.operationNormalize2( operation );

    operations.scalarWiseSingler[ name ] = operation;
  }

}

//

function operationsLogical1Adjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let logical1 = operations.logical1 = operations.logical1 || Object.create( null );

  for( let name in routines.logical1 )
  {
    let operation = routines.logical1[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'logical1';

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;

    operation.homogeneous = true;
    operation.scalarWise = true;
    operation.reducing = true;
    operation.zipping = false;
    operation.interruptible = false;

    _.assert( !operations.logical1[ name ] );

    this.operationNormalize2( operation );

    operations.logical1[ name ] = operation;
  }

}

//

function operationsLogical2Adjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let logical2 = operations.logical2 = operations.logical2 || Object.create( null );

  for( let name in routines.logical2 )
  {
    let operation = routines.logical2[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'logical2';

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;

    operation.homogeneous = true;
    operation.scalarWise = true;
    operation.reducing = true;
    operation.zipping = true;
    operation.interruptible = false;
    operation.returningBoolean = true;

    _.assert( !operations.logical2[ name ] );

    this.operationNormalize2( operation );

    operations.logical2[ name ] = operation;
  }

}

//

function operationHomogeneousAdjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let scalarWiseHomogeneous = operations.scalarWiseHomogeneous = operations.scalarWiseHomogeneous || Object.create( null );

  for( let name in routines.scalarWiseHomogeneous )
  {
    let operation = routines.scalarWiseHomogeneous[ name ];

    // if( name === 'experiment1' )
    // debugger;

    this.operationNormalize1( operation );

    operation.kind = 'homogeneous';

    if( operation.takingArguments === undefined )
    operation.takingArguments = [ 2, 2 ];

    if( operation.takingVectors === undefined )
    operation.takingVectors = [ 0, operation.takingArguments[ 1 ] ];

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = true;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = true;

    operation.homogeneous = true;
    operation.scalarWise = true;

    _.assert( _.arrayIs( operation.takingArguments ) );
    _.assert( operation.takingArguments.length === 2 );
    _.assert( !operations.scalarWiseHomogeneous[ name ] );

    this.operationNormalize2( operation );

    operations.scalarWiseHomogeneous[ name ] = operation;
  }
}

//

function operationHeterogeneousAdjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let scalarWiseHeterogeneous = operations.scalarWiseHeterogeneous = operations.scalarWiseHeterogeneous || Object.create( null );

  for( let name in routines.scalarWiseHeterogeneous )
  {
    let operation = routines.scalarWiseHeterogeneous[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'heterogeneous';

    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;
    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;

    operation.homogeneous = false;
    operation.scalarWise = true;

    _.assert( _.arrayIs( operation.takingArguments ) );
    _.assert( operation.takingArguments.length === 2 );
    _.assert( !!operation.input );
    _.assert( !operations.scalarWiseHeterogeneous[ name ] );

    this.operationNormalize2( operation );

    operations.scalarWiseHeterogeneous[ name ] = operation;

  }

}

//

function operationReducingAdjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let scalarWiseReducing = operations.scalarWiseReducing = operations.scalarWiseReducing || Object.create( null );

  for( let name in routines.scalarWiseReducing )
  {
    let operation = routines.scalarWiseReducing[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'reducing';
    operation.homogeneous = false;
    operation.scalarWise = true;
    operation.reducing = true;

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;

    _.assert( !operations.scalarWiseReducing[ name ] );

    this.operationNormalize2( operation );

    operations.scalarWiseReducing[ name ] = operation;
  }

}

// --
// extension
// --

let MetaExtension =
{

  operationSupplement,
  _operationLogicalReducerAdjust,
  operationNormalizeInput,
  operationNormalizeArity,

  operationNormalize1,
  operationNormalize2,

  operationSinglerAdjust,
  operationsLogical1Adjust,
  operationsLogical2Adjust,
  operationHomogeneousAdjust,
  operationHeterogeneousAdjust,
  operationReducingAdjust,

}

/* _.props.extend */Object.assign( _.vectorAdapter._meta, MetaExtension );

})();

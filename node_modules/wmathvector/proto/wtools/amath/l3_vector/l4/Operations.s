(function _Operations_s_() {

'use strict';

const _ = _global_.wTools;
const _hasLength = _.vector.hasLength;
const _longSlice = _.longSlice;
const _sqr = _.math.sqr;
// let _assertMapHasOnly = _.map.assertHasOnly;
const _routineIs = _.routineIs;

const _min = Math.min;
const _max = Math.max;
let _sqrt = Math.sqrt;
let _abs = Math.abs;
const _pow = Math.pow;

let _floor = Math.floor;
let _ceil = Math.ceil;
let _round = Math.round;

let accuracy = _.accuracy;
let accuracySqr = _.accuracySqr;

let vad = _.vectorAdapter;
let operations = vad.operations = vad.operations || Object.create( null );
let meta = vad._meta;
let dop;

// --
// scalarWiseSingler
// --

let inv = dop = Object.create( null );

dop.onScalar = function inv( o )
{
  o.dstElement = 1 / o.srcElement;
}

//

let invOrOne = dop = Object.create( null );

dop.onScalar = function invOrOne( o )
{
  if( o.srcElement === 0 )
  o.dstElement = 1;
  else
  o.dstElement = 1 / o.srcElement;
}

//

let floorOperation = dop = Object.create( null );

dop.onScalar = function floor( o )
{
  o.dstElement = _floor( o.srcElement );
}

//

let ceilOperation = dop = Object.create( null );

dop.onScalar = function ceil( o )
{
  o.dstElement = _ceil( o.srcElement );
}

//

let roundOperation = dop = Object.create( null );

dop.onScalar = function round( o )
{
  debugger;
  o.dstElement = _round( o.srcElement );
}

//

let floorToPowerOfTwo = dop = Object.create( null );

dop.onScalar = function floor( o )
{
  o.dstElement = _.math.floorToPowerOfTwo( o.srcElement );
}

//

let ceilToPowerOfTwo = dop = Object.create( null );

dop.onScalar = function ceil( o )
{
  o.dstElement = _.math.ceilToPowerOfTwo( o.srcElement );
}

//

let roundToPowerOfTwo = dop = Object.create( null );

dop.onScalar = function round( o )
{
  o.dstElement = _.math.roundToPowerOfTwo( o.srcElement );
}

// --
// logical1
// --

let isNumber = dop = Object.create( null );

dop.onScalar = function isNumber( o )
{
  o.dstElement = _.numberIs( o.srcElement );
}

//

let isZero = dop = Object.create( null );

dop.onScalar = function isZero( o )
{
  o.dstElement = o.srcElement === 0;
}

//

let isFinite = dop = Object.create( null );

dop.onScalar = function isFinite( o )
{
  o.dstElement = _.numberIsFinite( o.srcElement );
}

//

let isInfinite = dop = Object.create( null );

dop.onScalar = function isInfinite( o )
{
  o.dstElement = _.numberIsInfinite( o.srcElement );
}

//

let isNan = dop = Object.create( null );

dop.onScalar = function isNan( o )
{
  o.dstElement = isNaN( o.srcElement );
}

//

let isInt = dop = Object.create( null );

dop.onScalar = function isInt( o )
{
  o.dstElement = _.intIs( o.srcElement );
}

//

let isString = dop = Object.create( null );

dop.onScalar = function isString( o )
{
  o.dstElement = _.strIs( o.srcElement );
}

// --
// logical2
// --

let isIdentical = dop = Object.create( null );

isIdentical.onScalar = function isIdentical( o )
{
  o.dstElement = o.dstElement === o.srcElement;
}

//

let isNotIdentical = dop = Object.create( null );

dop.onScalar = function isNotIdentical( o )
{
  o.dstElement = o.dstElement !== o.srcElement;
}

//

let isEquivalent = dop = Object.create( null );

dop.onScalar = function isEquivalent( o )
{
  o.dstElement = _.number.equivalent( o.dstElement, o.srcElement );
}

//

// let isEquivalent = dop = Object.create( null );
//
// dop.onScalar = function isEquivalent( o )
// {
//   _.assert( o.args.length <= 4 );
//
//   if( o.args.length === 4 )
//   o.dstElement = _.number.equivalent( o.srcContainers[ 0 ].eGet( o.key ), o.srcContainers[ 1 ].eGet( o.key ), o.srcContainers[ 2 ].eGet( o.key ) );
//   else
//   o.dstElement = _.number.equivalent( o.dstElement, o.srcElement );
// }
//
// dop.takingArguments = [ 2, 4 ];
// dop.takingVectors = [ 0, 3 ];
// dop.input = '?vw|?n vr|s vr|s ?s';
// dop.usingExtraSrcs = true;

//

let isNotEquivalent = dop = Object.create( null );

dop.onScalar = function isNotEquivalent( o )
{
  o.dstElement = !_.number.equivalent( o.dstElement, o.srcElement );
}

//

let isGreater = dop = Object.create( null );

dop.onScalar = function isGreater( o )
{
  o.dstElement = o.dstElement > o.srcElement;
}

//

let isGreaterEqual = dop = Object.create( null );

dop.onScalar = function isGreaterEqual( o )
{
  o.dstElement = o.dstElement >= o.srcElement;
}

//

let isGreaterEqualAprox = dop = Object.create( null );

dop.onScalar = function isGreaterEqualAprox( o )
{
  let result = o.dstElement >= o.srcElement;
  if( !result )
  result = _.number.equivalent( o.dstElement, o.srcElement )
  o.dstElement = result;
}

//

let isGreaterAprox = dop = Object.create( null );

dop.onScalar = function isGreaterAprox( o )
{
  let result = o.dstElement > o.srcElement;
  if( !result )
  result = _.number.equivalent( o.dstElement, o.srcElement );
  o.dstElement = result;
}

//

let isLess = dop = Object.create( null );

dop.onScalar = function isLess( o )
{
  o.dstElement = o.dstElement < o.srcElement;
}

//

let isLessEqual = dop = Object.create( null );

dop.onScalar = function isLessEqual( o )
{
  o.dstElement = o.dstElement <= o.srcElement;
}

//

let isLessEqualAprox = dop = Object.create( null );

dop.onScalar = function isLessEqualAprox( o )
{
  let result = o.dstElement <= o.srcElement;
  if( !result )
  result = _.number.equivalent( o.dstElement, o.srcElement );
  o.dstElement = result;
}

//

let isLessAprox = dop = Object.create( null );

dop.onScalar = function isLessAprox( o )
{
  let result = o.dstElement < o.srcElement;
  if( !result )
  result = _.number.equivalent( o.dstElement, o.srcElement );
  o.dstElement = result;
}

// --
// scalarWiseHomogeneous
// --

// let experiment1 = dop = Object.create( null );
//
// experiment1.onScalar = function experiment1( o )
// {
//   o.dstElement = Math.pow( o.srcElement, 2 );
// }
//
// dop.takingArguments = [ 1, 2 ];
// dop.takingVectors = [ 1, 2 ];
//
// debugger;

// experiemnt.onScalarsBegin = function experiemntBegin( o )
// {
//   o.dstElement = 0;
// }

//

let add = dop = Object.create( null );

add.onScalar = function add( o )
{
  o.dstElement = o.dstElement + o.srcElement;
}

add.onScalarsBegin = function addBegin( o )
{
  o.dstElement = 0;
}

//

let sub = dop = Object.create( null );

sub.onScalar = function sub( o )
{
  o.dstElement = o.dstElement - o.srcElement;
}

sub.onScalarsBegin = function subBegin( o )
{
  o.dstElement = 0;
}

//

let mul = dop = Object.create( null );

mul.onScalar = function mul( o )
{
  o.dstElement = o.dstElement * o.srcElement;
}

mul.onScalarsBegin = function mulBegin( o )
{
  o.dstElement = 1;
}

//

let div = dop = Object.create( null );

div.onScalar = function div( o )
{
  o.dstElement = o.dstElement / o.srcElement;
}

div.onScalarsBegin = function divBegin( o )
{
  o.dstElement = 1;
}

//

let assign = dop = Object.create( null );

assign.onScalar = function assign( o )
{
  o.dstElement = o.srcElement;
}

//

let min = dop = Object.create( null );

min.onScalar = function min( o )
{
  o.dstElement = _min( o.dstElement , o.srcElement );
}

min.onScalarsBegin = function minBegin( o )
{
  o.dstElement = +Infinity;
}

//

let max = dop = Object.create( null );

max.onScalar = function max( o )
{
  o.dstElement = _max( o.dstElement , o.srcElement );
}

max.onScalarsBegin = function maxBegin( o )
{
  o.dstElement = +Infinity;
}

// --
// scalarWiseHeterogeneous
// --

let addScaled = dop = Object.create( null );

dop.onScalar = function addScaled( o )
{
  _.assert( o.srcElements.length === 3 );
  o.dstElement = o.srcElements[ 0 ] + ( o.srcElements[ 1 ]*o.srcElements[ 2 ] );
}

dop.takingArguments = [ 3, 4 ];
dop.takingVectors = [ 0, 4 ];
dop.input = '?vw|?n 3*vr|3*l|3*s';
// dop.input = '?vw|?n 3*vr|3*s';
// dop.input = [ '?vw|?n', '3*vr|3*s' ];
dop.usingDstAsSrc = true;

//

let subScaled = dop = Object.create( null );

dop.onScalar = function subScaled( o )
{
  o.dstElement = o.srcElements[ 0 ] - ( o.srcElements[ 1 ]*o.srcElements[ 2 ] );
}

dop.takingArguments = [ 3, 4 ];
dop.takingVectors = [ 0, 4 ];
dop.input = '?vw|?n 3*vr|3*l|3*s';
// dop.input = [ '?vw|?n', '3*vr|3*s' ];
dop.usingDstAsSrc = true;

//

let mulScaled = dop = Object.create( null );

dop.onScalar = function mulScaled( o )
{
  o.dstElement = o.srcElements[ 0 ] * ( o.srcElements[ 1 ]*o.srcElements[ 2 ] );
}

dop.takingArguments = [ 3, 4 ];
dop.takingVectors = [ 0, 4 ];
dop.input = '?vw|?n 3*vr|3*l|3*s';
// dop.input = [ '?vw|?n', '3*vr|3*s' ];
dop.usingDstAsSrc = true;

//

let divScaled = dop = Object.create( null );

dop.onScalar = function divScaled( o )
{
  o.dstElement = o.srcElements[ 0 ] / ( o.srcElements[ 1 ]*o.srcElements[ 2 ] );
}

dop.takingArguments = [ 3, 4 ];
dop.takingVectors = [ 0, 4 ];
dop.input = '?vw|?n 3*vr|3*l|3*s';
// dop.input = [ '?vw|?n', '3*vr|3*s' ];
dop.usingDstAsSrc = true;

//

let clamp = dop = Object.create( null );

dop.onScalar = function clamp( o )
{
  o.dstElement = _min( _max( o.srcElements[ 0 ] , o.srcElements[ 1 ] ), o.srcElements[ 2 ] );
}

dop.input = '?vw|?n 3*vr|3*l|3*s';
// dop.input = [ '?vw|?n', '3*vr|3*s' ];
dop.takingArguments = [ 3, 4 ];
dop.takingVectors = [ 0, 4 ];
dop.returningNumber = true;
dop.returningPrimitive = true;
dop.returningNew = true;
dop.usingDstAsSrc = true;

//

let randomInRange = dop = Object.create( null );

dop.onScalar = function randomInRange( o )
{
  o.dstElement = o.srcElements[ 1 ] + Math.random()*( o.srcElements[ 2 ]-o.srcElements[ 1 ] );
}

dop.input = 'vw|n vr|s vr|s';
dop.takingArguments = [ 3, 3 ];
dop.takingVectors = [ 1, 3 ];
dop.returningNumber = true;
dop.returningPrimitive = true;
dop.returningNew = true;
dop.usingDstAsSrc = true;

//

let mix = dop = Object.create( null );

dop.onScalar = function mix( o )
{
  _.assert( o.srcElements.length === 3 );
  o.dstElement = ( o.srcElements[ 0 ] )*( 1-o.srcElements[ 2 ] ) + ( o.srcElements[ 1 ] )*( o.srcElements[ 2 ] );
}

dop.input = '?vw|?n 3*vr|3*vw|3*s';
dop.takingArguments = [ 3, 4 ];
dop.takingVectors = [ 0, 4 ];
dop.returningNumber = true;
dop.returningPrimitive = true;
dop.returningNew = true;
dop.usingDstAsSrc = true;

// --
// scalarWiseReducing
// --

let polynomApply = dop = Object.create( null );

dop.onScalar = function polynomApply( o )
{
  let x = o.args[ 1 ];
  o.result += o.element * _pow( x, o.key );
}

dop.onScalarsBegin = function( o )
{
  o.result = 0;
}

dop.onScalarsEnd = function( o )
{
}

dop.input = 'vr s';
dop.takingVectorsOnly = false;

//

let mean = dop = Object.create( null );

dop.onScalar = function mean( o )
{
  o.result.total += o.element;
  o.result.nelement += 1;
}

dop.onScalarsBegin = function( o )
{
  o.result = dop = Object.create( null );
  o.result.total = 0;
  o.result.nelement = 0;
}

dop.onScalarsEnd = function( o )
{
  if( o.result.nelement )
  o.result = o.result.total / o.result.nelement;
  else
  o.result = 0;
}

dop.input = 'vr';
dop.output = 's';

//

let moment = dop = Object.create( null );

dop.onScalar = function moment( o )
{
  o.result.total += _pow( o.element, o.args[ 1 ] );
  o.result.nelement += 1;
}

dop.onScalarsBegin = function( o )
{
  o.result = Object.create( null );
  o.result.total = 0;
  o.result.nelement = 0;
}

dop.onScalarsEnd = function( o )
{
  if( o.result.nelement )
  o.result = o.result.total / o.result.nelement;
  else
  o.result = 0;
}

dop.input = 'vr s';

//

let _momentCentral = dop = Object.create( null );

dop.onScalar = function _momentCentral( o )
{
  let degree = o.args[ 1 ];
  let mean = o.args[ 2 ];
  o.result.total += _pow( o.element - mean, degree );
  o.result.nelement += 1;
}

dop.onScalarsBegin = function( o )
{
  let degree = o.args[ 1 ];
  let mean = o.args[ 2 ];
  _.assert( _.numberIs( degree ) )
  _.assert( _.numberIs( mean ) )
  o.result = Object.create( null );
  o.result.total = 0;
  o.result.nelement = 0;
}

dop.onScalarsEnd = function( o )
{
  if( o.result.nelement )
  o.result = o.result.total / o.result.nelement;
  else
  o.result = 0;
}

dop.input = 'vr s s';

//

let reduceToMean = dop = Object.create( null );

dop.onScalar = function reduceToMean( o )
{
  o.result.total += o.element;
  o.result.nelement += 1;
}

dop.onScalarsBegin = function( o )
{
  o.result = Object.create( null );
  o.result.total = 0;
  o.result.nelement = 0;
}

dop.onScalarsEnd = function( o )
{
  o.result = o.result.total / o.result.nelement;
}

//

let reduceToProduct = dop = Object.create( null );

dop.onScalar = function reduceToProduct( o )
{
  o.result *= o.element;
}

dop.onScalarsBegin = function( o )
{
  o.result = 1;
}

//

let reduceToSum = dop = Object.create( null );

dop.onScalar = function reduceToSum( o )
{
  o.result += o.element;
}

dop.onScalarsBegin = function( o )
{
  o.result = 0;
}

//

let reduceToAbsSum = dop = Object.create( null );

dop.onScalar = function reduceToAbsSum( o )
{
  debugger;
  o.result += abs( o.element );
}

dop.onScalarsBegin = function( o )
{
  o.result = 0;
}

//

let reduceToMagSqr = dop = Object.create( null );

dop.onScalar = function reduceToMagSqr( o )
{
  o.result += _sqr( o.element );
}

dop.onScalarsBegin = function( o )
{
  o.result = 0;
}

//

let reduceToMag = dop = _.props.extend( null, reduceToMagSqr );

dop.onScalarsEnd = function reduceToMag( o )
{
  o.result = _sqrt( o.result );
}

// --
//
// --

/* operationSinglerAdjust, */

let scalarWiseSingler = //
{

  inv,
  invOrOne,

  floor : floorOperation,
  ceil : ceilOperation,
  round : roundOperation,

  floorToPowerOfTwo,
  ceilToPowerOfTwo,
  roundToPowerOfTwo,

}

/* operationsLogical1Adjust, */

let logical1 = //
{

  isNumber,
  isZero,
  isFinite,
  isInfinite,
  isNan,
  isInt,
  isString,

}

/* operationsLogical2Adjust, */

let logical2 = //
{

  isIdentical,
  isNotIdentical,
  isEquivalent,
  // isEquivalent2,
  isNotEquivalent,
  isGreater,
  isGreaterEqual,
  isGreaterEqualAprox,
  isGreaterAprox,
  isLess,
  isLessEqual,
  isLessEqualAprox,
  isLessAprox,

}

/* operationHomogeneousAdjust, */

let scalarWiseHomogeneous = //
{

  // experiment1,
  add,
  sub,
  mul,
  div,

  assign,
  min,
  max,

}

/* operationHeterogeneousAdjust, */

let scalarWiseHeterogeneous = //
{

  /* isEquivalent2, */

  addScaled,
  subScaled,
  mulScaled,
  divScaled,

  clamp,
  randomInRange,
  mix,

}

/* operationReducingAdjust, */

let scalarWiseReducing = //
{

  polynomApply,

  mean,
  moment,
  _momentCentral,

  reduceToMean,
  reduceToProduct,
  reduceToSum,
  reduceToAbsSum,
  reduceToMagSqr,
  reduceToMag,

}

let Routines = meta.operationRoutines =
{

  /* operationSinglerAdjust */

  scalarWiseSingler,

  /* operationsLogical1Adjust, */

  logical1,

  /* operationsLogical2Adjust, */

  logical2,

  /* operationHomogeneousAdjust */

  scalarWiseHomogeneous,

  /* operationHeterogeneousAdjust */

  scalarWiseHeterogeneous,

  /* operationReducingAdjust */

  scalarWiseReducing,

}

meta.operationSinglerAdjust();
meta.operationsLogical1Adjust();
meta.operationsLogical2Adjust();
meta.operationHomogeneousAdjust();
meta.operationHeterogeneousAdjust();
meta.operationReducingAdjust();

// _.assert( _.entity.identicalShallow( vad.operations, Routines ) );
_.assert( _.entityIdentical( vad.operations, Routines ) );

})();

(function _OperationDescriptor_s_() {

'use strict';

const _ = _global_.wTools;

// --
// structure
// --

let OperationDescriptor0 = _.Blueprint
({

  name : null,
  input : null,
  output : null,

  onScalar : null,
  onScalarsBegin : null,
  onScalarsEnd : null,

  takingArguments : null,
  takingVectors : null,
  takingVectorsOnly : null,

  usingDstAsSrc : null,

  returningNumber : null,
  returningNew : null,
  returningPrimitive : null,

})

/*

"onScalar", "kind", "takingArguments", "homogeneous", "scalarWise", "usingExtraSrcs", "usingDstAsSrc"

*/

let OperationDescriptor1 = _.Blueprint
({
  extension : _.define.extension( OperationDescriptor0 ),

  // takingArguments : null,
  // takingVectors : null,
  takingVectorsOnly : null,

  returningOnly : null,
  returningSelf : null,
  // returningNew : null,
  returningLong : null,
  // returningNumber : null,
  returningBoolean : null,
  // returningPrimitive : null,

  modifying : null,
  reducing : null,
  conditional : null,
  zipping : null,
  interruptible : null,
  homogeneous : null,
  scalarWise : null,
  // usingDstAsSrc : null,
  usingExtraSrcs : null,

  // onScalar : null,
  onContinue : null,
  // onScalarsBegin : null,
  // onScalarsEnd : null,
  onVectorsBegin : null,
  onVectorsEnd : null,
  onVectors : null,

  kind : null,
  generator : null,
  postfix : null,
  scalarOperation : null,

  inputWithoutLast : null,
  inputLast : null,

})

//

let OperationDescriptor2 = _.Blueprint
({
  extension : _.define.extension( OperationDescriptor1 ),

  special : null,

})

// --
// implementation
// --


let VectorExtension =
{

  OperationDescriptor0,
  OperationDescriptor1,
  OperationDescriptor2,

}

/* _.props.extend */Object.assign( _.vectorAdapter, VectorExtension );

})();

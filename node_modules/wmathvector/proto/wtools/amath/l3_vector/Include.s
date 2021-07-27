(function _Include_s_() {

'use strict';

/**
 * Collection of functions for vector math. MathVector introduces missing in JavaScript type VectorAdapter. VectorAdapter is a reference, it does not contain data but only refer on actual ( aka Long ) container of lined data. VectorAdapter could have offset, length and stride what makes look original container differently. Length of VectorAdapter is not necessarily equal to the length of the original container, siblings elements of VectorAdapter is not necessarily sibling in the original container, so storage format of vectors does not make a big difference for math algorithms. MathVector implements functions for the VectorAdapter and mirrors them for Array/BufferNode. Use MathVector to be more functional with math and less constrained with storage format.
  @module Tools/math/Vector
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wProto' );
  _.include( 'wEqualer' )
  _.include( 'wMathScalar' )

}

if( module !== 'undefined' )
{

  require( './l0/VadNamespace.s' );
  require( './l0/VectorNamespace.s' );
  require( './l1/Vad.s' );

  require( './l2/AdapterMake.s' );
  require( './l2/LongMake.s' );
  require( './l2/OperationDescriptor.s' );

  require( './l3/LongMeta.s' );
  require( './l3/OperationMeta.s' );
  require( './l3/RoutineMeta.s' );

  require( './l3_from/Long.s' );
  require( './l3_from/LongShrinked.s' );
  require( './l3_from/LongShrinkedWithStride.s' );
  require( './l3_from/Number.s' );

  require( './l4/Operations.s' );

  require( './l5/Routines.s' );

  require( './l8/VadSpecial.s' );
  require( './l8/VectorSpecial.s' );

}

if( module !== 'undefined' )
{
  if( typeof module !== 'undefined' )
  module[ 'exports' ] = _global_.wTools;
}

})();

( function _Operator_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  require( '../l7_operator/l1/Namespace.s' );

  require( '../l7_operator/l3/AbstractResource.s' );
  require( '../l7_operator/l3/Operator.s' );

  require( '../l7_operator/l5/Deed.s' );
  require( '../l7_operator/l5/File.s' );
  require( '../l7_operator/l5/FileUsage.s' );
  require( '../l7_operator/l5/Mission.s' );
  require( '../l7_operator/l5/Operation.s' );

  module[ 'exports' ] = _;
}

})();

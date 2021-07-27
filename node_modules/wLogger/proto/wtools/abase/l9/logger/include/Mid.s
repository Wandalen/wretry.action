( function _Mid_s_()
{

'use strict';

/* Logger */

if( typeof module !== 'undefined' )
{
  const _ = require( './Basic.s' );

  require( '../l1/LoggerBasic.s' );

  require( '../l3/Chainer.s' );
  require( '../l3/ChainingMixin.s' );
  require( '../l3/ColoredMixin.s' );
  require( '../l3/LoggerMid.s' );

  // require( '../l5/LoggerTop.s' );
  require( '../l5/Logger.s' );

  require( '../l7/LoggerPrime.s' );
  require( '../l7/ToLayeredHtml.s' );
  require( '../l7/ToString.s' );

  module[ 'exports' ] = _global_.wTools;
}

} )();

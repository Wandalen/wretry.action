( function _Gdf_s_( )
{

'use strict';

/**
 * Standardized abstract interface and collection of strategies to convert complex data structures from one generic data format ( GDF ) to another generic data format. You may use the module to serialize complex data structure to string or deserialize string back to the original data structure. Generic data format ( GDF ) is a format of data structure designed with taking into account none unique feature of data so that it is applicable to any kind of data.
  @module Tools/mid/Gdf
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../include/Mid.s' );
  module[ 'exports' ] = _global_.wTools;
}

/*
qqq : make it working
qqq : use algorithms from wgraphbasic to find shortest path
qqq : introduce field cost
let encoder = _.gdf.selectContext
({
  inFormat : 'buffer.raw',
  outFormat : 'structure',
  ext : 'yml',
})[ 0 ];
let structure = encoder.encode( bufferRaw );
*/

} )();

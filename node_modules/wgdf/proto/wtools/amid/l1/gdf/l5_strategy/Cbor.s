( function _Cbor_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.encode = _.encode || Object.create( null );

// --
// cbor
// --

let Cbor, CborPath;
try
{
  CborPath = require.resolve( 'cbor' );
}
catch( err )
{
}

let cborSupported =
{
  primitive : 3,
  regexp : 1,
  buffer : 1,
  structure : 2
}

let readCbor = null;
if( CborPath )
readCbor =
{

  ext : [ 'cbor' ],
  inFormat : [ 'buffer.node' ],
  outFormat : [ 'structure' ],
  feature : cborSupported,

  onEncode : function( op )
  {

    if( !Cbor )
    Cbor = require( CborPath );

    _.assert( _.bufferAnyIs( op.in.data ), 'Expects buffer' );
    op.in.data = _.bufferNodeFrom( op.in.data );
    op.out.data = Cbor.decodeFirstSync( op.in.data, { bigint : true } );
    op.out.format = 'structure';
  },

}

//

let writeCbor = null;
if( CborPath )
writeCbor =
{

  ext : [ 'cbor' ],
  inFormat : [ 'structure' ],
  outFormat : [ 'buffer.node' ],
  feature : cborSupported,

  onEncode : function( op )
  {

    if( !Cbor )
    Cbor = require( CborPath );

    _.assert( _.mapIs( op.in.data ) );

    let encoder = new Cbor.Encoder({ highWaterMark : 1 << 30 });
    encoder.write( op.in.data );
    op.out.data = encoder.read();

    _.assert( _.bufferNodeIs( op.out.data ) );

    op.out.format = 'buffer.node';
  },

}

// --
// declare
// --

var Extension =
{
}

/* _.props.extend */Object.assign( _.encode, Extension );

// --
// register
// --

_.Gdf([ readCbor, writeCbor ]);

} )();

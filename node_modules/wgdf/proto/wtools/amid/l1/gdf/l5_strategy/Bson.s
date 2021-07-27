( function _Bson_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.encode = _.encode || Object.create( null );

// --
// bson
// --

let Bson, BsonPath;
try
{
  BsonPath = require.resolve( 'bson' );
}
catch( err )
{
}

let bsonSupported =
{
  primitive : 2,
  regexp : 2,
  buffer : 0,
  structure : 2
}

let readBson = null;
if( BsonPath )
readBson =
{

  ext : [ 'bson' ],
  inFormat : [ 'buffer.node' ],
  outFormat : [ 'structure' ],

  feature : bsonSupported,

  onEncode : function( op )
  {
    if( !Bson )
    {
      Bson = require( BsonPath );
      Bson.setInternalBufferSize( 1 << 30 );
    }
    _.assert( _.bufferAnyIs( op.in.data ), 'Expects buffer' );
    op.in.data = _.bufferNodeFrom( op.in.data );
    op.out.data = Bson.deserialize( op.in.data );
    op.out.format = 'structure';
  },

}

let writeBson = null;
if( BsonPath )
writeBson =
{

  ext : [ 'bson' ],
  inFormat : [ 'structure' ],
  outFormat : [ 'buffer.node' ],

  feature : bsonSupported,

  onEncode : function( op )
  {

    if( !Bson )
    {
      Bson = require( BsonPath );
      Bson.setInternalBufferSize( 1 << 30 );
    }

    _.assert( _.mapIs( op.in.data ) );
    op.out.data = Bson.serialize( op.in.data );
    op.out.format = 'buffer.node';
  },

}

// --
// declare
// --

var Extension =
{

}

Object.assign( _.encode, Extension );

// --
// register
// --

// debugger;
_.Gdf([ readBson, writeBson ]);

} )();

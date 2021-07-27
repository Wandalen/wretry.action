( function _MsgpackLite_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.encode = _.encode || Object.create( null );

// --
// Msgpack-lite
// --

let MsgpackLite, MsgpackLitePath;
try
{
  MsgpackLitePath = require.resolve( 'msgpack-lite' );
}
catch( err )
{
}

let msgpackLiteSupported =
{
  primitive : 2,
  regexp : 2,
  buffer : 3,
  structure : 2
}

let readMsgpackLite = null;
if( MsgpackLitePath )
readMsgpackLite =
{

  ext : [ 'msgpack.lite' ],
  inFormat : [ 'buffer.node' ],
  outFormat : [ 'structure' ],
  feature : msgpackLiteSupported,

  onEncode : function( op )
  {

    if( !MsgpackLite )
    MsgpackLite = require( MsgpackLitePath );

    _.assert( _.bufferAnyIs( op.in.data ), 'Expects buffer' );
    op.in.data = _.bufferNodeFrom( op.in.data );
    op.out.data = MsgpackLite.decode( op.in.data );
    op.out.format = 'structure';
  },

}

let writeMsgpackLite = null;
if( MsgpackLitePath )
writeMsgpackLite =
{

  ext : [ 'msgpack.lite' ],
  inFormat : [ 'structure' ],
  outFormat : [ 'buffer.node' ],
  feature : msgpackLiteSupported,

  onEncode : function( op )
  {

    if( !MsgpackLite )
    MsgpackLite = require( MsgpackLitePath );

    _.assert( _.mapIs( op.in.data ) );
    op.out.data = MsgpackLite.encode( op.in.data );
    op.out.format = 'buffer.node';
  },

}

// --
// Msgpack-wtp
// --

// let MsgpackWtp, MsgpackWtpPath;
// try
// {
//   MsgpackWtpPath = require.resolve( 'what-the-pack' );
// }
// catch( err )
// {
// }

// let readMsgpackWtp = null;
// if( MsgpackWtpPath )
// readMsgpackWtp =
// {

//   ext : [ 'msgpack.wtp' ],
//   inFormat : [ 'buffer.node' ],
//   outFormat : [ 'structure' ],

//   onEncode : function( op )
//   {
//     _.assert( _.bufferAnyIs( op.in.data ), 'Expects buffer' );

//     if( !MsgpackWtp )
//     {
//       MsgpackWtp = require( MsgpackLitePath );
//       // if( !MsgpackWtp.decode )
//       MsgpackWtp = MsgpackWtp.initialize( 2**27 ); //134 MB
//     }

//     op.out.data = MsgpackWtp.decode( op.in.data );
//     op.out.format = 'structure';
//   },

// }

// let writeMsgpackWtp = null;
// if( MsgpackWtpPath )
// writeMsgpackWtp =
// {

//   ext : [ 'msgpack.wtp' ],
//   inFormat : [ 'structure' ],
//   outFormat : [ 'buffer.node' ],

//   onEncode : function( op )
//   {
//     _.assert( _.mapIs( op.in.data ) );

//     if( !MsgpackWtp )
//     {
//       MsgpackWtp = require( MsgpackLitePath );
//       MsgpackWtp = MsgpackWtp.initialize( 2**27 ); //134 MB
//     }

//     // if( !MsgpackWtp.encode )
//     // MsgpackWtp = MsgpackWtp.initialize( 2**27 ); //134 MB

//     op.out.data = MsgpackWtp.encode( op.in.data );
//     op.out.format = 'buffer.node';
//   },

// }

// --
// declare
// --

var Extension =
{
  readMsgpackLite,
  writeMsgpackLite
}

/* _.props.extend */Object.assign( _.encode, Extension );

// --
// register
// --

_.Gdf([ readMsgpackLite, writeMsgpackLite ]);

// _.Gdf([ readMsgpackLite, writeMsgpackLite, readMsgpackWtp, writeMsgpackWtp ]);

} )();

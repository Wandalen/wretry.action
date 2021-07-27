(function _Encoders_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _global_.wTools;

// --
// encoders
// --

let readJsSmart =
{

  name : 'js.smart',
  exts : [ 'js', 's', 'ss', 'jstruct', 'jslike' ],
  feature : { reader : true, config : true },
  // forConfig : 1,

  onBegin : function( e )
  {
    e.operation.encoding = 'utf8';
  },

  onEnd : function( e )
  {
    _.sure( _.strIs( e.data ), 'Expects string' );

    if( typeof process !== 'undefined' && typeof require !== 'undefined' )
    if( _.FileProvider.HardDrive && e.provider instanceof _.FileProvider.HardDrive )
    {
      try
      {
        e.data = require( _.fileProvider.path.nativize( e.operation.filePath ) );
        return;
      }
      catch( err )
      {
      }
    }

    e.data = _.exec
    ({
      code : e.data,
      filePath : e.operation.filePath,
      prependingReturn : 1,
    });
  },

}

//

let readJsNode =
{

  name : 'js.node',
  exts : [ 'js', 's', 'ss', 'jstruct' ],
  feature : { reader : true },
  // forConfig : 0,

  onBegin : function( e )
  {
    e.operation.encoding = 'utf8';
  },

  onEnd : function( e )
  {
    if( !_.strIs( e.data ) )
    throw _.err( 'Expects string' );
    e.data = require( _.fileProvider.path.nativize( e.operation.filePath ) );
  },

}

//

let readBufferBytes =
{

  name : 'buffer.bytes',
  feature : { reader : true },

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'buffer.bytes' );
  },

  onEnd : function( e )
  {
    if( e.stream ) /* xxx */
    debugger;
    if( e.stream )
    return;
    _.assert( _.bufferBytesIs( e.data ) );
  },

}

//

let readBufferRaw =
{

  name : 'buffer.raw',
  feature : { reader : true },

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'buffer.raw' );
  },

  onEnd : function( e )
  {
    _.assert( _.bufferRawIs( e.data ) );
  },

}

//

// let readOriginalType =
// {
//
//   name : 'meta.original',
//   feature : { reader : true },
//
//   onBegin : function( e )
//   {
//   },
//
//   onEnd : function( e )
//   {
//   },
//
//   onSelect : function( e )
//   {
//     let encoding = 'buffer.bytes';
//     if( e.fileProvider.encoding !== 'meta.original' )
//     encoding = e.encoding;
//     let e2 = e;
//     e2.encoding = e.fileProvider.encoding;
//     return _.files.encoder.for( e2 );
//   },
//
// }

// --
// declare
// --

_.files.ReadEncoders = _.files.ReadEncoders || Object.create( null );
_.files.WriteEncoders = _.files.WriteEncoders || Object.create( null );

_.files.encoder._registerWithExt( readJsSmart );
_.files.encoder._registerWithExt( readJsNode );
_.files.encoder._registerWithExt( readBufferBytes );
_.files.encoder._registerWithExt( readBufferRaw );
// _.files.encoder._registerWithExt( readOriginalType );
_.files.encoder.fromGdfs(); /* xxx : review and probably remove! */
_.files.encoder.gdfsWatch();

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

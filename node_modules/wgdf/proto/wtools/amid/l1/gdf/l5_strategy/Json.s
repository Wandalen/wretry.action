( function _Json_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.encode = _.encode || Object.create( null );

// --
// json
// --

let jsonSupported =
{
  primitive : 1,
  regexp : 0,
  buffer : 0,
  structure : 2
}

let readJson =
{

  ext : [ 'json' ],
  inFormat : [ 'string.utf8' ],
  outFormat : [ 'structure' ],

  feature : _.props.extend( null, jsonSupported, { default : 1 } ),

  onEncode : function( op )
  {

    /*

qqq : could throw different errors
cover them please

SyntaxError: Unexpected end of JSON input
    at JSON.parse (<anonymous>:null:null)
    at wGenericDataFormatConverter.onEncode (C:\pro\web\Dave\git\trunk\builder\include\wtools\abase\l8\GdfFormats.s:59:26)
    at wGenericDataFormatConverter.encode_body (C:\pro\web\Dave\git\trunk\builder\include\wtools\abase\l8\Converter.s:238:13)
    at Proxy.encode_body (C:\pro\web\Dave\git\trunk\builder\include\wtools\abase\l8\GdfCurrent.s:59:45)

*/
    try
    {
      op.out.data = JSON.parse( op.in.data );
    }
    catch( err )
    {
      let src = op.in.data;
      let position = /at position (\d+)/.exec( err.message );
      if( position )
      position = Number( position[ 1 ] );
      let first = 0;
      if( _.numberDefined( position ) && position >= 0 )
      {
        let nearest = _.strLinesNearest( src, position );
        first = _.strLinesCount( src.substring( 0, nearest.spans[ 0 ] ) );
        src = nearest.splits.join( '' );
      }
      let err2 = _.err( 'Error parsing JSON\n', err, '\n', _.strLinesNumber( src, first ) );
      throw err2;
    }

    // op.out.data = _.jsonParse( op.in.data );
    op.out.format = 'structure';

  },

}

//

let writeJsonMin =
{
  // default : 1,
  ext : [ 'json.min', 'json' ],
  shortName : 'json.min',
  inFormat : [ 'structure' ],
  outFormat : [ 'string.utf8' ],
  feature : _.props.extend( null, jsonSupported, { default : 1, fine : 0, min : 1 } ),

  onEncode : function( op )
  {
    op.out.data = JSON.stringify( op.in.data );
    op.out.format = 'string.utf8';
  }

}

//

let writeJsonFine =
{

  shortName : 'json.fine',
  ext : [ 'json.fine', 'json' ],
  inFormat : [ 'structure' ],
  outFormat : [ 'string.utf8' ],
  feature : _.props.extend( null, jsonSupported, { default : 0, fine : 1, min : 0 } ),

  onEncode : function( op )
  {
    op.out.data = _.cloneData({ src : op.in.data });
    op.out.data = _.entity.exportJson( op.out.data, { cloning : 0 } );
    op.out.format = 'string.utf8';
  }

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

_.Gdf([ readJson, writeJsonMin, writeJsonFine ]);

} )();

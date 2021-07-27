( function _JsStructure_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.encode = _.encode || Object.create( null );

// --
// js
// --

// let ProcessBasic;
let IntrospectorBasic;
try
{
  // ProcessBasic = _.include( 'wProcess' );
  IntrospectorBasic = _.include( 'wIntrospectorBasic' );
}
catch( err )
{
}

let jsSupported =
{
  primitive : 3,
  regexp : 2,
  buffer : 3,
  structure : 2
}

let readJsStructure = null;
if( IntrospectorBasic )
readJsStructure =
{

  // forConfig : 0,
  ext : [ 'js.structure', 'js', 's', 'ss', 'jstruct', 'jslike' ],
  inFormat : [ 'string.utf8' ],
  outFormat : [ 'structure' ],

  feature : jsSupported,

  // onEncode : function( op )
  // {
  //   op.out.format = 'string.utf8';
  // },

  onEncode : function( op )
  {
    // _.assert( _.strDefined( op.filePath ) );
    op.out.data = _.exec({ code : op.in.data, filePath : op.filePath, prependingReturn : 1 }); /* yyy */
    // op.out.data = _.exec({ code : op.in.data, filePath : op.filePath, prependingReturn : 0 });
    op.out.format = 'structure';
  },

}

//

// let readJsNode =
// {
//
//   forConfig : 0,
//   ext : [ 'js', 's', 'ss', 'jstruct', 'jslike' ],
//   inFormat : [ 'string.utf8' ],
//   outFormat : [ 'structure' ],
//
//   onEncode : function( op )
//   {
//     op.out.data = require( _.fileProvider.path.nativize( op.filePath ) );
//     op.out.format = 'structure';
//   },
//
// }
//
// //
//
// let readJsSmart =
// {
//
//   ext : [ 'js', 's', 'ss', 'jstruct', 'jslike' ],
//   inFormat : [ 'string.utf8' ],
//   outFormat : [ 'structure' ],
//
//   onEncode : function( op )
//   {
//
//     // qqq
//     // if( typeof process !== 'undefined' && typeof require !== 'undefined' )
//     // if( _.FileProvider.HardDrive && op.provider instanceof _.FileProvider.HardDrive )
//     // {
//     //   op.out.data = require( _.fileProvider.path.nativize( op.filePath ) );
//     //   op.out.format = 'structure';
//     //   return;
//     // }
//
//     op.out.data = _.exec
//     ({
//       code : op.in.data,
//       filePath : op.filePath,
//       prependingReturn : 1,
//     });
//
//     op.out.format = 'structure';
//
//   },
//
// }

//

let writeJsStrcuture =
{

  ext : [ 'js.structure', 'js', 's', 'ss', 'jstruct', 'jslike' ],
  inFormat : [ 'structure' ],
  outFormat : [ 'string.utf8' ],

  feature : jsSupported,

  onEncode : function( op )
  {
    op.out.data = _.entity.exportJs( op.in.data );
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

_.Gdf([ readJsStructure, /*readJsNode, readJsSmart, */ writeJsStrcuture ]);

} )();

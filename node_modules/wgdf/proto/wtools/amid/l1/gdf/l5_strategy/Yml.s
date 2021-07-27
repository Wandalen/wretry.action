( function _Yml_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.encode = _.encode || Object.create( null );

// --
// yaml
// --

let Yaml, YamlPath;
try
{
  YamlPath = require.resolve( 'js-yaml' );
}
catch( err )
{
}

let ymlSupported =
{
  primitive : 2,
  regexp : 2,
  buffer : 1,
  structure : 3
}

let readYml = null;
if( YamlPath )
readYml =
{

  ext : [ 'yaml', 'yml' ],
  inFormat : [ 'string.utf8' ],
  outFormat : [ 'structure' ],

  feature : ymlSupported,

  onEncode : function( op )
  {
    let o = Object.create( null );

    if( !Yaml )
    Yaml = require( YamlPath );

    if( op.filePath )
    o.filename = _.fileProvider.path.nativize( op.filePath )

    op.out.data = Yaml.load( op.in.data, o );
    op.out.format = 'structure';
  },

}

/* qqq xxx : uncomment when js-yaml will be updated to v4.0.0 or higher */
// readYml =
// {
//
//   ext : [ 'yaml', 'yml' ],
//   inFormat : [ 'string.utf8' ],
//   outFormat : [ 'structure' ],
//
//   feature : ymlSupported,
//
//   onEncode : function( op )
//   {
//     const o = Object.create( null );
//
//     if( !Yaml )
//     {
//       Yaml = require( YamlPath );
//       const schemaUnsafe = require( 'js-yaml-js-types' ).all;
//       Yaml.userUnsafeSchema = Yaml.DEFAULT_SCHEMA.extend( schemaUnsafe );
//     }
//
//     o.schema = Yaml.userUnsafeSchema;
//
//     if( op.filePath )
//     o.filename = _.fileProvider.path.nativize( op.filePath );
//
//     op.out.data = Yaml.load( op.in.data, o );
//     op.out.format = 'structure';
//   },
//
// }

let writeYml = null;
if( YamlPath )
writeYml =
{

  ext : [ 'yaml', 'yml' ],
  inFormat : [ 'structure' ],
  outFormat : [ 'string.utf8' ],

  feature : ymlSupported,

  onEncode : function( op )
  {

    if( !Yaml )
    Yaml = require( YamlPath );

    op.out.data = Yaml.dump( op.in.data );
    op.out.format = 'string.utf8';
  },

}

/* qqq xxx : uncomment when js-yaml will be updated to v4.0.0 or higher */
// writeYml =
// {
//
//   ext : [ 'yaml', 'yml' ],
//   inFormat : [ 'structure' ],
//   outFormat : [ 'string.utf8' ],
//
//   feature : ymlSupported,
//
//   onEncode : function( op )
//   {
//
//     if( !Yaml )
//     {
//       Yaml = require( YamlPath );
//       const schemaUnsafe = require( 'js-yaml-js-types' ).all;
//       Yaml.userUnsafeSchema = Yaml.DEFAULT_SCHEMA.extend( schemaUnsafe );
//     }
//
//     op.out.data = Yaml.dump( op.in.data, { schema : Yaml.userUnsafeSchema } );
//     op.out.format = 'string.utf8';
//   },
//
// }

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

_.Gdf([ readYml, writeYml ]);
_.assert( _.longHas( _.gdf.outMap[ 'structure' ].map( ( e ) => e.shortName ), 'yaml' ) );

} )();

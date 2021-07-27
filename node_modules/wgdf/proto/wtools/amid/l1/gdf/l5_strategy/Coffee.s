( function _Coffee_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.encode = _.encode || Object.create( null );

// --
// coffee
// --

let Coffee, CoffeePath;
try
{
  CoffeePath = require.resolve( 'coffeescript' );
}
catch( err )
{
}

let csonSupported =
{
  primitive : 1,
  regexp : 2,
  buffer : 3,
  structure : 2
}

let readCoffee = null;
if( CoffeePath )
readCoffee =
{

  ext : [ 'coffee', 'cson' ],
  inFormat : [ 'string.utf8' ],
  outFormat : [ 'structure' ],

  feature : csonSupported,

  onEncode : function( op )
  {
    let o = Object.create( null );

    if( !Coffee )
    Coffee = require( CoffeePath );

    if( op.filePath )
    o.filename = _.fileProvider.path.nativize( op.filePath )

    op.out.data = Coffee.eval( op.in.data, o );
    op.out.format = 'structure';
  },

}

//

let Js2coffee, Js2coffeePath;
try
{
  Js2coffeePath = require.resolve( 'js2coffee' );
}
catch( err )
{
}

let writeCoffee = null;
if( Js2coffeePath )
writeCoffee =
{

  ext : [ 'coffee', 'cson' ],
  inFormat : [ 'structure' ],
  outFormat : [ 'string.utf8' ],

  feature : csonSupported,

  onEncode : function( op )
  {

    if( !Js2coffee )
    Js2coffee = require( Js2coffeePath );

    let data = _.entity.exportString( op.in.data, { jsLike : 1, keyWrapper : '', stringWrapper : `'` } );
    if( _.mapIs( op.in.data ) )
    data = '(' + data + ')';
    op.out.data = Js2coffee( data );
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

_.Gdf([ readCoffee, writeCoffee ]);

} )();

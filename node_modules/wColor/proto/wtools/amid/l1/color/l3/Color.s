(function _Color_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to operate colors conveniently. Color provides functions to convert color from one color space to another color space, from name to color and from color to the closest name of a color. The module does not introduce any specific storage format of color what is a benefit. Color has a short list of the most common colors. Use the module for formatted colorful output or other sophisticated operations with colors.
  @module Tools/mid/Color
*/

/**
 * @summary Collection of cross-platform routines to operate colors conveniently.
 * @namespace wTools.color
 * @module Tools/mid/Color
*/

const _ = _global_.wTools;
const Self = _.color = _.color || Object.create( null );

// --
// implement
// --

function _fromTable( o )
{
  let result = o.colorMap[ o.src ];

  _.routine.assertOptions( _fromTable, o );

  if( !result )
  result = o.def;

  if( result )
  result = result.slice();

  return result;
}

_fromTable.defaults =
{
  src : null,
  def : null,
  colorMap : null,
}

//

/**
 * @summary Returns rgb value for color with provided `name`.
 * @param {String} name Target color name.
 * @param {*} def Default value. Is used if nothing was found.
 * @example
 * _.color.fromTable( 'black' );
 * @example
 * _.color.fromTable( 'black', [ 0, 0, 0 ] );
 * @throws {Error} If no arguments provided.
 * @function fromTable
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

// function fromTable( name, def, colorMap )
function fromTable( o )
{
  // let o = _.routineOptionsFromThis( fromTable, this, Self );

  if( !_.mapIs( o ) )
  o =
  {
    src : arguments[ 0 ],
    def : ( arguments.length > 1 ? arguments[ 1 ] : null ),
    colorMap : ( arguments.length > 2 ? arguments[ 2 ] : null ),
  }

  let result;
  if( !o.colorMap )
  o.colorMap = this.ColorMap;

  _.routine.options_( fromTable, o );
  _.assert( arguments.length <= 3 );
  _.assert( _.strIs( o.src ) );

  o.src = o.src.toLowerCase();
  o.src = o.src.trim();

  return this._fromTable( o );
  // return this._fromTable( o.src, o.def, o.colorMap );
}

fromTable.defaults =
{
  ... _fromTable.defaults,
}

//

/**
 * @summary Gets rgb values from bitmask `src`.
 * @param {Number} src Source bitmask.
 * @example
 * _.color.rgbByBitmask( 0xff00ff );
 * //[1, 0, 1]
 * @throws {Error} If no arguments provided.
 * @function rgbByBitmask
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

function rgbByBitmask( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( src ) );

  return _rgbByBitmask( src );
}

//

function _rgbByBitmask( src )
{
  let result = [];

  result[ 0 ] = ( ( src >> 16 ) & 0xff ) / 255;
  result[ 1 ] = ( ( src >> 8 ) & 0xff ) / 255;
  result[ 2 ] = ( ( src >> 0 ) & 0xff ) / 255;

  return result;
}

//

function _rgbaFromNotName( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( src ) || _.longIs( src ) || _.object.isBasic( src ) );

  if( _.object.isBasic( src ) )
  {
    _.map.assertHasOnly( src, { r : null, g : null, b : null, a : null } );
    let result = [];
    result[ 0 ] = src.r === undefined ? 1 : src.r;
    result[ 1 ] = src.g === undefined ? 1 : src.g;
    result[ 2 ] = src.b === undefined ? 1 : src.b;
    result[ 3 ] = src.a === undefined ? 1 : src.a;
    return result;
  }

  if( _.numberIs( src ) )
  {
    let result = this._rgbByBitmask( src );
    return _.longGrow_( result, result, [ 0, 3 ], 1 );
  }

  let result = [];

  /* */

  for( let r = 0 ; r < src.length ; r++ )
  result[ r ] = Number( src[ r ] );

  if( result.length < 4 )
  result[ 3 ] = 1;

  /* */

  return result;
}

//

/**
 * @summary Returns rgba color values for provided entity `src`.
 * @param {Number|Array|String|Object} src Source entity.
 * @example
 * _.color.rgbaFrom( 0xFF0080 );
 * //[ 1, 0, 0.5, 1 ]
 *
 * @example
 * _.color.rgbaFrom( { r : 0 } );
 * //[ 0, 1, 1, 1 ]
 *
 * @example
 * _.color.rgbaFrom( 'white' );
 * //[ 1, 1, 1, 1 ]
 *
 * @example
 * _.color.rgbaFrom( '#ffffff );
 * //[ 1, 1, 1, 1 ]
 *
 * @example
 * _.color.rgbaFrom( [ 1, 1, 1 ] );
 * //[ 1, 1, 1, 1 ]
 *
 * @throws {Error} If no arguments provided.
 * @function rgbaFrom
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

function rgbaFrom( o )
{

  if( !_.mapIs( o ) )
  o = { src : arguments[ 0 ], colorMap : ( arguments.length > 1 ? arguments[ 1 ] : null ) };
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( rgbaFrom, o );

  let result = this.rgbaFromTry( o );

  if( !result )
  debugger;
  if( !result )
  throw _.err( `Not color : "${_.entity.exportStringDiagnosticShallow( o.src )}"` );

  return result;

  // let result;
  //
  // if( !_.mapIs( o ) )
  // o = { src : arguments[ 0 ], colorMap : ( arguments.length > 1 ? arguments[ 1 ] : null ) };
  //
  // _.assert( arguments.length === 1, 'Expects single argument' );
  // _.routine.options_( rgnaFrom, arguments );
  //
  // if( _.numberIs( o.src ) || _.longIs( o.src ) || ( !_.mapIs( o.src ) && _.object.isBasic( o.src ) ) )
  // return this._rgbaFromNotName( o.src );
  //
  // /* */
  //
  // if( _.strIs( o.src ) )
  // result = this.fromTable( o );
  //
  // if( result )
  // return end();
  //
  // /* */
  //
  // if( _.strIs( o.src ) )
  // result = _.color.hexToColor( o.src );
  //
  // if( result )
  // return end();
  //
  // /* */
  //
  // _.assertWithoutBreakpoint( 0, 'Unknown color', _.strQuote( o.src ) );
  //
  // function end()
  // {
  //   _.assert( _.longIs( result ) );
  //   if( result.length !== 4 )
  //   result = _.longGrow_( result, result, [ 0, 3 ], 1 ); /* xxx : replace */
  //   return result;
  // }

}

rgbaFrom.defaults =
{
  src : null,
  colorMap : null,
}

//

/**
 * @summary Short-cut for {@link module:Tools/mid/Color.wTools.color.rgbaFrom}.
 * @description Returns rgb color values for provided entity `src`.
 * @param {Number|Array|String|Object} src Source entity.
 * @example
 * _.color.rgbFrom( 0xFF0080 );
 * //[ 1, 0, 0.5 ]
 *
 * @example
 * _.color.rgbFrom( { r : 0 } );
 * //[ 0, 1, 1 ]
 *
 * @example
 * _.color.rgbFrom( 'white' );
 * //[ 1, 1, 1 ]
 *
 * @example
 * _.color.rgbFrom( '#ffffff );
 * //[ 1, 1, 1 ]
 *
 * @example
 * _.color.rgbFrom( [ 1, 1, 1 ] );
 * //[ 1, 1, 1 ]
 *
 * @throws {Error} If no arguments provided.
 * @function rgbFrom
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

function rgbFrom( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.longIs( src ) )
  return _.longSlice( src, 0, 3 );

  let result = rgbaFrom.call( this, src );

  return _.longSlice( result, 0, 3 );
}

rgbFrom.defaults =
{
  ... rgbaFrom.defaults,
}

// rgbFrom.defaults.__proto__ = rgbaFrom.defaults;

//

/**
 * @summary Short-cut for {@link module:Tools/mid/Color.wTools.color.rgbaFromTry}.
 * @description Returns rgba color values for provided entity `src` or default value if nothing was found.
 * @param {Number|Array|String|Object} src Source entity.
 * @param {Array} def Default value.
 *
 * @example
 * _.color.rgbaFromTry( 'some_color', [ 1, 0, 0.5, 1 ] );
 * //[ 1, 0, 0.5, 1 ]
 *
 * @throws {Error} If no arguments provided.
 * @function rgbaFromTry
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

// function rgbaFromTry( src, def )
function rgbaFromTry( o )
{
  let result;

  if( !_.mapIs( o ) )
  o = { src : arguments[ 0 ] };

  _.assert( arguments.length === 1 );
  _.routine.options_( rgbaFromTry, o );

  if( _.numberIs( o.src ) || _.longIs( o.src ) || ( !_.mapIs( o.src ) && _.object.isBasic( o.src ) ) )
  return this._rgbaFromNotName( o.src );

  /* */

  if( _.strIs( o.src ) )
  result = this.fromTable( o );

  if( result )
  return end();

  /* */

  if( _.strIs( o.src ) )
  result = _.color.hexToColor( o.src );

  if( result )
  return end();

  /* */

  return o.def;

  function end()
  {
    _.assert( _.longIs( result ) );
    if( result.length !== 4 )
    result = _.longGrow_( result, result, [ 0, 3 ], 1 ); /* xxx : replace */
    return result;
  }

}

rgbaFromTry.defaults =
{
  ... rgbaFrom.defaults,
  def : null,
}

// {
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   try
//   {
//     return rgbaFrom.call( this, src );
//   }
//   catch( err )
//   {
//     return def;
//   }
//
// }
//
// rgbaFromTry.defaults =
// {
// }
//
// rgbaFromTry.defaults.__proto__ = rgbaFrom.defaults;

//

/**
 * @summary Short-cut for {@link module:Tools/mid/Color.wTools.color.rgbaFrom}.
 * @description Returns rgb color values for provided entity `src` or default value if nothing was found.
 * @param {Number|Array|String|Object} src Source entity.
 * @param {Array} def Default value.
 *
 * @example
 * _.color.rgbFrom( 'some_color', [ 1, 0, 0.5 ] );
 * //[ 1, 0, 0.5 ]
 *
 * @throws {Error} If no arguments provided.
 * @function rgbFromTry
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

function rgbFromTry( src, def )
{

  _.assert( arguments.length === 2, 'Expects single argument' );

  if( _.longIs( src ) )
  return _.longSlice( src, 0, 3 );

  let result = rgbaFrom.call( this, src );

  if( !result )
  result = def;

  if( result !== null )
  result = _.longSlice( result, 0, 3 );

  return result;

  // try
  // {
  //   return rgbFrom.call( this, src );
  // }
  // catch( err )
  // {
  //   return def;
  // }

}

rgbFromTry.defaults =
{
  ... rgbaFrom.defaults,
  def : null,
}

// rgbFromTry.defaults =
// {
// }
//
// rgbFromTry.defaults.__proto__ = rgbaFrom.defaults;


function rgbaHtmlFrom( o )
{

  if( !_.mapIs( o ) )
  o = { src : arguments[ 0 ], colorMap : ( arguments.length > 1 ? arguments[ 1 ] : null ) };
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( rgbaHtmlFrom, o );

  let result = this.rgbaHtmlFromTry( o );

  if( !result )
  debugger;
  if( !result )
  throw _.err( `Not color : "${_.entity.exportStringDiagnosticShallow( o.src )}"` );

  return result;

  // let result;
  //
  // if( !_.mapIs( o ) )
  // o = { src : arguments[ 0 ], colorMap : ( arguments.length > 1 ? arguments[ 1 ] : null ) };
  //
  // _.assert( arguments.length === 1, 'Expects single argument' );
  // _.routine.options_( rgnaFrom, arguments );
  //
  // if( _.numberIs( o.src ) || _.longIs( o.src ) || ( !_.mapIs( o.src ) && _.object.isBasic( o.src ) ) )
  // return this._rgbaFromNotName( o.src );
  //
  // /* */
  //
  // if( _.strIs( o.src ) )
  // result = this.fromTable( o );
  //
  // if( result )
  // return end();
  //
  // /* */
  //
  // if( _.strIs( o.src ) )
  // result = _.color.hexToColor( o.src );
  //
  // if( result )
  // return end();
  //
  // /* */
  //
  // _.assertWithoutBreakpoint( 0, 'Unknown color', _.strQuote( o.src ) );
  //
  // function end()
  // {
  //   _.assert( _.longIs( result ) );
  //   if( result.length !== 4 )
  //   result = _.longGrow_( result, result, [ 0, 3 ], 1 ); /* xxx : replace */
  //   return result;
  // }

}

rgbaHtmlFrom.defaults =
{
  src : null,
  colorMap : null,
}

//

function rgbHtmlFrom( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.longIs( src ) )
  return _.longSlice( src, 0, 3 );

  let result = rgbaHtmlFrom.call( this, src );

  return _.longSlice( result, 0, 3 );
}

rgbHtmlFrom.defaults =
{
  ... rgbaHtmlFrom.defaults,
}

//

function rgbaHtmlFromTry( o )
{
  let result;

  if( !_.mapIs( o ) )
  o = { src : arguments[ 0 ] };

  _.assert( arguments.length === 1 );
  _.routine.options_( rgbaHtmlFromTry, o );

  if( _.numberIs( o.src ) || _.longIs( o.src ) || ( !_.mapIs( o.src ) && _.object.isBasic( o.src ) ) )
  return this._rgbaFromNotName( o.src );

  /* */

  if( _.strIs( o.src ) )
  result = this.fromTable( o );

  if( result )
  return end();

  /* */

  if( _.strIs( o.src ) )
  result = _.color.hexToColor( o.src );

  if( result )
  return end();

  if( _.strIs( o.src ) )
  result = _.color.rgbaHtmlToRgba( o.src );

  if( result )
  return end();

  if( _.strIs( o.src ) )
  result = _.color.hslaToRgba( o.src );

  if( result )
  return end();

  /* */

  return o.def;

  function end()
  {
    _.assert( _.longIs( result ) );
    if( result.length !== 4 )
    result = _.longGrow_( result, result, [ 0, 3 ], 1 ); /* xxx : replace */
    return result;
  }

}

rgbaHtmlFromTry.defaults =
{
  ... rgbaHtmlFrom.defaults,
  def : null,
}

//

function rgbHtmlFromTry( src, def )
{

  _.assert( arguments.length === 2, 'Expects single argument' );

  if( _.longIs( src ) )
  return _.longSlice( src, 0, 3 );

  let result = rgbaHtmlFrom.call( this, src );

  if( !result )
  result = def;

  if( result !== null )
  result = _.longSlice( result, 0, 3 );

  return result;

  // try
  // {
  //   return rgbFrom.call( this, src );
  // }
  // catch( err )
  // {
  //   return def;
  // }

}

rgbHtmlFromTry.defaults =
{
  ... rgbaHtmlFrom.defaults,
  def : null,
}

//

function rgbaHtmlToRgba( src )
{
  _.assert( _.strDefined( src ) );

  let splitted = _.strSplitFast
  ({
    src,
    delimeter : [ '(', ')', ',' ],
    preservingDelimeters : 0,
    preservingEmpty : 0
  })

  if( _.strBegins( splitted[ 0 ], 'rgb' ) )
  {
    let result =
    [
      parseInt( splitted[ 1 ] ) / 255,
      parseInt( splitted[ 2 ] ) / 255,
      parseInt( splitted[ 3 ] ) / 255,
      1
    ]

    if( splitted[ 0 ] === 'rgba' )
    result[ 3 ] = Number( splitted[ 4 ] )

    return result;
  }

  return null;
}


//

function _colorDistance( c1, c2 )
{
  _.assert( _.longIs( c1 ) );
  _.assert( _.longIs( c2 ) );

  let a = c1.slice();
  let b = c2.slice();

  // function _definedIs( src )
  // {
  //   return src !== undefined && src !== null && !isNaN( src )
  // }

  for( let  i = 0 ; i < 4 ; i++ )
  {
    if( !_.numberIsFinite( a[ i ] ) )
    // a[ i ] = _definedIs( b[ i ] ) ? b[ i ] : 1;
    a[ i ] = 1;

    if( !_.numberIsFinite( b[ i ] ) )
    // b[ i ] = _definedIs( a[ i ] ) ? a[ i ] : 1;
    b[ i ] = 1;
  }

  // a[ 3 ] = _definedIs( a[ 3 ] ) ? a[ i ] : 1;
  // b[ 3 ] = _definedIs( b[ 3 ] ) ? b[ i ] : 1;

  return  Math.pow( a[ 0 ] - b[ 0 ], 2 )
          + Math.pow( a[ 1 ] - b[ 1 ], 2 )
          + Math.pow( a[ 2 ] - b[ 2 ], 2 )
          + Math.pow( a[ 3 ] - b[ 3 ], 2 )
}

//

function _colorNameNearest( color, map )
{
  let self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 1 )
  map = _.color.ColorMap;

  _.assert( _.object.isBasic( map ) );

  if( _.strIs( color ) )
  {
    _.assertWithoutBreakpoint( map[ color ], 'Unknown color', _.strQuote( color ) );

    if( _.objectLike( map[ color ] ) )
    {
      _.assert( map[ color ].name );
      return self._colorNameNearest( map[ color ].name, map );
    }

    return color;
  }

  color = this._rgbaFromNotName( color );

  _.assert( color.length === 4 );

  for( let r = 0 ; r < 4 ; r++ )
  {
    color[ r ] = Number( color[ r ] );
    if( color[ r ] < 0 )
    color[ r ] = 0;
    else if( color[ r ] > 1 )
    color[ r ] = 1;
  }

  // if( color[ 3 ] === undefined )
  // color[ 3 ] = 1;

  /* */

  let names = Object.keys( map );
  let nearest = names[ 0 ];
  let max = this._colorDistance( map[ names[ 0 ] ], color );

  if( max === 0 )
  return nearest;

  for( let i = 1; i <= names.length - 1; i++ )
  {
    let d = this._colorDistance( map[ names[ i ] ], color );
    if( d < max )
    {
      max = d;
      nearest = names[ i ];
    }

    if( d === 0 )
    return names[ i ];
  }

  return nearest;
}

//

/**
 * @summary Returns name of color that is nearest to provided `color`.
 * @param {Number|Array|String|Object} color Source color.
 *
 * @example
 * _.color.colorNameNearest( [ 1, 1, 1, 0.8 ] );
 * //'white'
 *
 * @example
 * _.color.colorNameNearest( [ 1, 1, 1, 0.3 ] );
 * //'transparent'
 *
 * @throws {Error} If no arguments provided.
 * @function colorNameNearest
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

function colorNameNearest( color )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.strIs( color ) )
  {
    let color2 = _.color.hexToColor( color );
    if( color2 )
    color = color2;
  }

  try
  {
    return self._colorNameNearest( color );
  }
  catch( err )
  {
    return;
  }

}

// //
//
// function _colorNearest( o )
// {
//   let self = this;
//
//   _.routine.options_( _colorNearest, o );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   if( _.strIs( o.color ) )
//   {
//     let _color = _.color.hexToColor( o.color );
//     if( _color )
//     o.color = _color;
//   }
//
//   try
//   {
//     let name = self._colorNameNearest( o.color, o.colorMap );
//     return o.colorMap[ name ];
//   }
//   catch( err )
//   {
//     return;
//   }
// }
//
// _colorNearest.defaults =
// {
//   color : null,
//   colorMap : null
// }

//

/**
 * @summary Returns value of color that is nearest to provided `color`.
 * @param {Number|Array|String|Object} color Source color.
 *
 * @example
 * _.color.colorNearest( [ 1, 1, 1, 0.8 ] );
 * //[ 1, 1, 1, 1 ]
 *
 * @throws {Error} If no arguments provided.
 * @function colorNameNearest
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

function colorNearest( color )
{
  let self = this;

  let name = self.colorNameNearest( color );
  if( name )
  return self.ColorMap[ name ];
}

//

/**
 * @summary Returns hex value for provided color `rgb`.
 * @param {Number|Array|String|Object} color Source color.
 * @param {Array} def Default value.
 *
 * @example
 * _.color.colorToHex( [ 1, 0, 1 ] );
 * //'#ff00ff'
 *
 * @throws {Error} If no arguments provided.
 * @function colorToHex
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

function colorToHex( rgb, def )
{

  _.assert( arguments.length === 1 || arguments.length === 2 )

  if( _.arrayIs( rgb ) )
  {
    return '#' + ( ( 1 << 24 ) + ( Math.floor( rgb[ 0 ]*255 ) << 16 ) + ( Math.floor( rgb[ 1 ]*255 ) << 8 ) + Math.floor( rgb[ 2 ]*255 ) )
    .toString( 16 ).slice( 1 );
  }
  else if( _.numberIs( rgb ) )
  {
    let hex = Math.floor( rgb ).toString( 16 );
    return '#' + _.strDup( '0', 6 - hex.length  ) + hex;
  }
  else if( _.object.isBasic( rgb ) )
  {
    return '#' + ( ( 1 << 24 ) + ( Math.floor( rgb.r*255 ) << 16 ) + ( Math.floor( rgb.g*255 ) << 8 ) + Math.floor( rgb.b*255 ) )
    .toString( 16 ).slice( 1 );
  }
  else if( _.strIs( rgb ) )
  {
    if( !rgb.length )
    return def;
    else if( rgb[ 0 ] === '#' )
    return rgb;
    else
    return '#' + rgb;
  }

  return def;
}

//

/**
 * @summary Returns rgb value for provided `hex` value.
 * @param {String} hex Source color.
 *
 * @example
 * _.color.colorToHex( '#ff00ff' );
 * //[ 1, 0, 1 ]
 *
 * @throws {Error} If no arguments provided.
 * @function hexToColor
 * @namespace wTools.color
 * @module Tools/mid/Color
 */

function hexToColor( hex )
{
  return _.color.rgba.fromHexStr( hex );
}

//

function colorToRgbHtml( src )
{
  let result = '';

  _.assert( _.strIs( src ) || _.object.isBasic( src ) || _.arrayIs( src ) );
  _.assert( arguments.length === 1, 'Expects single argument' );


  if( _.strIs( src ) )
  return src;

  if( _.object.isBasic( src ) )
  src = [ src.r, src.g, src.b, src.a ];

  if( _.arrayIs( src ) )
  {
    for( let i = 0; i < 3; i++ )
    _.assert( src[ i ] >= 0 && src[ i ] <= 1 )

    result += 'rgb( ';
    result += String( Math.floor( src[ 0 ]*255 ) ) + ', ';
    result += String( Math.floor( src[ 1 ]*255 ) ) + ', ';
    result += String( Math.floor( src[ 2 ]*255 ) );
    result += ' )';
  }
  else result = src;

  //console.log( 'colorHtmlToRgbHtml', result );

  return result;
}

//

function colorToRgbaHtml( src )
{
  let result = '';

  _.assert( _.strIs( src ) || _.object.isBasic( src ) || _.arrayIs( src ) || _.numberIs( src ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.strIs( src ) )
  return src;

  if( _.object.isBasic( src ) )
  src = [ src.r, src.g, src.b, src.a ];

  if( _.arrayIs( src ) )
  {
    for( let i = 0; i < 3; i++ )
    _.assert( src[ i ] >= 0 && src[ i ] <= 1 )

    result += 'rgba( ';
    result += String( Math.floor( src[ 0 ]*255 ) ) + ', ';
    result += String( Math.floor( src[ 1 ]*255 ) ) + ', ';
    result += String( Math.floor( src[ 2 ]*255 ) );
    if( src[ 3 ] !== undefined )
    result += ', ' + String( src[ 3 ] );
    else
    result += ', ' + '1';
    result += ' )';
  }
  else if( _.numberIs( src ) )
  {
    result = colorToRgbaHtml
    ({
      r : ( ( src >> 16 ) & 0xff ) / 255,
      g : ( ( src >> 8 ) & 0xff ) / 255,
      b : ( ( src ) & 0xff ) / 255
    });
  }
  else result = src;

  return result;
}

//

function mulSaturation( rgb, factor )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( factor >= 0 );

  let hsl = rgbToHsl( rgb );

  hsl[ 1 ] *= factor;

  let result = hslToRgb( hsl );

  if( rgb.length === 4 )
  result[ 3 ] = rgb[ 3 ];

  return result;
}

//

function brighter( rgb, factor )
{
  if( factor === undefined )
  factor = 0.1;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( factor >= 0 );

  return mulSaturation( rgb, 1 + factor );
}

//

/*
  ( 1+factor ) * c2 = c1
  ( 1-efactor ) * c1 = c2

  ( 1-efactor ) * ( 1+factor ) = 1
  1+factor-efactor-efactor*factor = 1
  factor-efactor-efactor*factor = 0
  -efactor( 1+factor ) = factor
  efactor = - factor / ( 1+factor )
*/

function paler( rgb, factor )
{
  if( factor === undefined )
  factor = 0.1;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( 0 <= factor && factor <= 1 );

  let efactor = factor / ( 1+factor );

  return mulSaturation( rgb, 1 - efactor );
}

// --
// int
// --

function colorWidthForExponential( width )
{

  return 1 + 63 * width;

}

//

function rgbWithInt( srcInt )
{
  let result = [];

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( srcInt ), 'rgbWithInt :', 'Expects srcInt' );

  /* eval degree */

  let degree = 1;
  let left = srcInt;

  if( left >= 6 )
  {

    left -= 6;
    degree = 2;
    let n = 6;
    let d = 0;

    while( left >= n )
    {
      left -= n;
      degree += 1;
      d += 1;
      n *= degree;
      n /= d;
    }

  }

  /* compose set of elements */

  let set = [ 0.1 ];
  let e = 0.95;
  if( degree >= 2 ) e = 0.8;
  do
  {
    set.push( e );
    //e /= 2;

    if( set.length === 2 )
    {
      e = 0.5;
    }
    else if( set.length === 3 )
    {
      e = 0.35;
    }
    else if( set.length === 4 )
    {
      e = 0.75;
    }
    else
    {
      e *= 0.5;
    }

  }
  while( set.length <= degree );
  let last = set.length - 1;

  /* fill routine */

  function fillWithElements( i1, i2, i3 )
  {
    result[ left ] = set[ i1 ];
    result[ ( left+1 )%3 ] = set[ i2 ];
    result[ ( left+2 )%3 ] = set[ i3 ];

    return result;
  }

  /* fill result vector */

  if( degree === 1 )
  {

    if( left < 3 )
    return fillWithElements( last, 0, 0 );
    left -= 3;

    if( left < 3 )
    return fillWithElements( 0, last, last );
    left -= 3;

  }

  /* */

  for( let c1 = set.length - 2 ; c1 >= 0 ; c1-- )
  {

    for( let c2 = c1 - 1 ; c2 >= 0 ; c2-- )
    {

      if( left < 3 )
      return fillWithElements( last, c1, c2 );
      left -= 3;

      if( left < 3 )
      return fillWithElements( last, c2, c1 );
      left -= 3;

    }

  }

  /* */

  throw _.err( 'rgbWithInt :', 'No color for', srcInt );
}

//

function _rgbWithInt( srcInt )
{
  let result;

  _.assert( _.numberIs( srcInt ), 'rgbWithInt :', 'Expects srcInt' );

  let c = 9;

  srcInt = srcInt % c;
  srcInt -= 0.3;
  if( srcInt < 0 ) srcInt += c;
  //result = hslToRgb([ srcInt / 11, 1, 0.5 ]);

  result = hslToRgb([ srcInt / c, 1, 0.5 ]);

  return result;
}

// --
// hsl
// --

function hslToRgb( hsl, result )
{
  result = result || [];
  let h = hsl[ 0 ];
  let s = hsl[ 1 ];
  let l = hsl[ 2 ];

  if( s === 0 ) /* Yevhen : achromatic, r = g = b = l, not 1 */
  {
    result[ 0 ] = l;
    result[ 1 ] = l;
    result[ 2 ] = l;
    return result;
  }

  function get( a, b, h )
  {

    if( h < 0 ) h += 1;
    if( h > 1 ) h -= 1;

    if( h < 1 / 6 )return b + ( a - b ) * 6 * h;
    if( h < 1 / 2 )return a;
    if( h < 2 / 3 )return b + ( a - b ) * 6 * ( 2 / 3 - h );

    return b;
  }

  let a = l <= 0.5 ? l * ( 1 + s ) : l + s - ( l * s );
  let b = ( 2 * l ) - a;

  result[ 0 ] = get( a, b, h + 1 / 3 );
  result[ 1 ] = get( a, b, h );
  result[ 2 ] = get( a, b, h - 1 / 3 );

  return result;
}

//

function hslaToRgba( hsla, result )
{

}

//

function rgbToHsl( rgb, result )
{
  result = result || [];
  let hue, saturation, lightness;
  let r = rgb[ 0 ];
  let g = rgb[ 1 ];
  let b = rgb[ 2 ];

  let max = Math.max( r, g, b );
  const min = Math.min( r, g, b );

  lightness = ( min + max ) / 2.0;

  if( min === max )
  {

    hue = 0;
    saturation = 0;

  }
  else
  {

    let diff = max - min;

    if( lightness <= 0.5 )
    saturation = diff / ( max + min );
    else
    saturation = diff / ( 2 - max - min );

    switch( max )
    {
      case r : hue = ( g - b ) / diff + ( g < b ? 6 : 0 ); break;
      case g : hue = ( b - r ) / diff + 2; break;
      case b : hue = ( r - g ) / diff + 4; break;
      default : break
    }

    hue /= 6;

  }

  result[ 0 ] = hue;
  result[ 1 ] = saturation;
  result[ 2 ] = lightness;

  return result;
}

//

function rgbaToHsla( rgba, result )
{

}

//

// function colorToHslHtml( rgb )
// {

// }

// //

// function colorToHslaHtml( rgba )
// {

// }

// --
// random
// --

function randomHsl( s, l )
{

  _.assert( arguments.length <= 2 );

  if( s === undefined )
  s = 1.0;
  if( l === undefined )
  l = 0.5;

  let hsl = [ Math.random(), s, l ];

  return hsl;
}

//

function randomRgbWithSl( s, l )
{

  _.assert( arguments.length <= 2 );

  if( s === undefined )
  s = 1.0;
  if( l === undefined )
  l = 0.5;

  let rgb = hslToRgb([ Math.random(), s, l ]);

  return rgb;
}

// --
// etc
// --

function gammaToLinear( dst )
{

  if( Object.isFrozen( dst ) )
  debugger;

  _.assert( dst.length === 3 || dst.length === 4 );

  dst[ 0 ] = dst[ 0 ]*dst[ 0 ];
  dst[ 1 ] = dst[ 1 ]*dst[ 1 ];
  dst[ 2 ] = dst[ 2 ]*dst[ 2 ];

  return dst;
}

//

function linearToGamma( dst )
{

  _.assert( dst.length === 3 || dst.length === 4 );

  dst[ 0 ] = _.math.sqrt( dst[ 0 ] );
  dst[ 1 ] = _.math.sqrt( dst[ 1 ] );
  dst[ 2 ] = _.math.sqrt( dst[ 2 ] );

  return dst;
}

// --
// str
// --

function strColorStyle( style )
{
  return _.ct.styleObjectFor( style );
}

//

function strStrip( srcStr )
{
  return _.ct.strip( srcStr );
}

// --
// etc
// --

function _validateNormalized( src )
{
  for( let i = 0; i < src.length; i++ )
  {
    if( !_.cinterval.has( [ 0, 1 ], src[ i ] ) )
    return false;
  }
  return true;
}

// --
// let
// --

let ColorMap =
{

  'invisible'       : [ 0.0, 0.0, 0.0, 0.0 ],
  'transparent'     : [ 1.0, 1.0, 1.0, 0.5 ],

  'cyan'            : [ 0.0, 1.0, 1.0 ],
  'magenta'         : [ 1.0, 0.0, 1.0 ],
  'maroon'          : [ 0.5, 0.0, 0.0 ],
  'dark green'      : [ 0.0, 0.5, 0.0 ],
  'navy'            : [ 0.0, 0.0, 0.5 ],
  'olive'           : [ 0.5, 0.5, 0.0 ],
  'teal'            : [ 0.0, 0.5, 0.5 ],
  'bright green'    : [ 0.5, 1.0, 0.0 ],
  'spring green'    : [ 0.0, 1.0, 0.5 ],
  'pink'            : [ 1.0, 0.0, 0.5 ],
  'dark orange'     : [ 1.0, 0.5, 0.0 ],
  'azure'           : [ 0.0, 0.5, 1.0 ],
  'dark blue'       : [ 0.0, 0.0, 0.63 ],
  'brown'           : [ 0.65, 0.16, 0.16 ],

}

//

let ColorMapGreyscale =
{

  'white'           : [ 1.0, 1.0, 1.0 ],
  'smoke'           : [ 0.9, 0.9, 0.9 ],
  'silver'          : [ 0.75, 0.75, 0.75 ],
  'gray'            : [ 0.5, 0.5, 0.5 ],
  'dim'             : [ 0.35, 0.35, 0.35 ],
  'black'           : [ 0.0, 0.0, 0.0 ],

}

//

let ColorMapDistinguishable =
{

  'yellow'          : [ 1.0, 1.0, 0.0 ],
  'purple'          : [ 0.5, 0.0, 0.5 ],
  'orange'          : [ 1.0, 0.65, 0.0 ],
  'bright blue'     : [ 0.68, 0.85, 0.9 ],
  'red'             : [ 1.0, 0.0, 0.0 ],
  'buff'            : [ 0.94, 0.86, 0.51 ],
  'gray'            : [ 0.5, 0.5, 0.5 ],
  'green'           : [ 0.0, 1.0, 0.0 ],
  'purplish pink'   : [ 0.96, 0.46, 0.56 ],
  'blue'            : [ 0.0, 0.0, 1.0 ],
  'yellowish pink'  : [ 1.0, 0.48, 0.36 ],
  'violet'          : [ 0.5, 0.0, 1.0 ],
  'orange yellow'   : [ 1.0, 0.56, 0.0 ],
  'purplish red'    : [ 0.7, 0.16, 0.32 ],
  'greenish yellow' : [ 0.96, 0.78, 0.0 ],
  'reddish brown'   : [ 0.5, 0.1, 0.05 ],
  'yellow green'    : [ 0.57, 0.6, 0.0 ],
  'yellowish brown' : [ 0.34, 0.2, 0.08 ],
  'reddish orange'  : [ 0.95, 0.23, 0.07 ],
  'olive green'     : [ 0.14, 0.17, 0.09 ],

}

// --
// declare
// --

let Extension =
{

  //

  _fromTable,
  fromTable,

  rgbByBitmask,
  _rgbByBitmask,

  _rgbaFromNotName,

  rgbaFrom, //xxx: merge with rgbaHtml* or rename
  rgbFrom, //xxx: merge with rgbaHtml* or rename

  rgbaFromTry, //xxx: merge with rgbaHtml* or rename
  rgbFromTry, //xxx: merge with rgbaHtml* or rename

  rgbaHtmlFrom, //qqq: cover
  rgbHtmlFrom, //qqq: cover

  rgbaHtmlFromTry, //qqq: cover
  rgbHtmlFromTry, //qqq: cover

  rgbaHtmlToRgba,

  _colorDistance,

  _colorNameNearest,
  colorNameNearest,

  // _colorNearest,
  colorNearest,

  colorToHex,
  hexToColor,

  colorToRgbHtml,
  colorToRgbaHtml,

  mulSaturation,
  brighter,
  paler,

  // int

  colorWidthForExponential,
  rgbWithInt,
  _rgbWithInt,

  // hsl

  hslToRgb, //qqq:extend with support of hsl( h, s, l ), cover
  hslaToRgba, //qqq:implement,extend with support of hsla( h, s, l, a ), cover
  rgbToHsl,
  rgbaToHsla, //qqq:implement,cover

  // colorToHslHtml, //qqq:implement,cover
  // colorToHslaHtml, //qqq:implement,cover

  // random

  randomHsl,
  randomRgb : randomRgbWithSl,
  randomRgbWithSl,

  // etc

  gammaToLinear,
  linearToGamma,

  // str

  /* xxx : remove */
  strBg : _.ct.bg,
  strFg : _.ct.fg,
  strFormat : _.ct.format,
  strFormatEach : _.ct.format,

  strEscape : _.ct.escape,
  strUnescape : _.ct.unescape,
  strColorStyle,

  strStrip,

  // etc

  _validateNormalized,

  // let

  ColorMap,
  ColorMapGreyscale,
  ColorMapDistinguishable,
  // ColorMapShell,

}

_.props.supplement( _.color, Extension );
_.props.supplement( _.color.ColorMap, ColorMap );
_.props.supplement( _.color.ColorMapGreyscale, ColorMapGreyscale );
_.props.supplement( _.color.ColorMapDistinguishable, ColorMapDistinguishable );

_.props.supplement( _.color.ColorMap, ColorMapGreyscale );
_.props.supplement( _.color.ColorMap, ColorMapDistinguishable );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

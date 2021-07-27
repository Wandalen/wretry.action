# module::Color [![status](https://github.com/Wandalen/wColor/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wColor/actions/workflows/StandardPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Collection of cross-platform routines to operate colors conveniently. Color provides functions to convert color from one color space to another color space, from name to color and from color to the closest name of a color. The module does not introduce any specific storage format of color what is a benefit. Color has a short list of the most common colors. Use the module for formatted colorful output or other sophisticated operations with colors.

The module in JavaScript provides convenient means for color conversion.
Contains map of predefined colors( ColorMap ) with rgb channels in [ 0,1 ] range and methods to convert colors between different formats and notations.

## Installation
```terminal
npm install wColor@alpha
```

### Try out from the repository

```
git clone https://github.com/Wandalen/wColor
cd wColor
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wColor@stable'
```

`Willbe` is not required to use the module in your project as submodule.

## Usage
After installation module becomes a part of [ wTools ]( https://github.com/Wandalen/wTools ) package and can be used as its 'color' property:
> wTools.color

Colors map is avaible at:
> wTools.color.ColorMap

### Methods
* Find color in colors map - [ colorByName ]()
* Extract rgb values from bitmask - [ rgbByBitmask ]()
* Get rgba color by name or hex value - [ rgbaFrom ]()
* Get rgb color by name or hex value - [ rgbFrom ]()
* Get name of nearest color - [ colorNameNearest ]()
* Convert rgb to hex - [ colorToHex ]()
* Convert hex to rgb - [ hexToColor ]()
* Convert rgb values from 0-1 range to browser compatible notation - [ colorToRgbHtml ]()
* Convert rgba values from 0-1 range to browser compatible notation - [ colorToRgbaHtml ]()
* Convert from rgb to hsl - [ rgbToHsl ]()
* Convert from hsl to rgb - [ hslToRgb ]()

##### Example #1
```javascript
/*Get color by name*/
let _ = wTools;
let rgb = _.color.colorByName( 'red' );
console.log( rgb );
/*
[ 1, 0, 0 ]
*/
```
##### Example #2
```javascript
/*Get color by name directly*/
let _ = wTools;
let rgb = _.color.ColorMap['red'];
console.log( rgb );
/*
[ 1, 0, 0 ]
*/
```
##### Example #3
```javascript
/*Get color by hex value*/
let _ = wTools;
let rgb = _.color.rgbFrom( 'ffffff' )
console.log( rgb );
/*
[ 1, 1, 1 ]
*/
```
##### Example #4
```javascript
/*Get color by bitmask*/
let _ = wTools;
let rgb = _.color.rgbByBitmask( 0x00ff00 )
console.log( rgb );
/*
[ 0, 1, 0 ]
*/
```
##### Example #5
```javascript
/*Find nearest color*/
let _ = wTools;
let name = _.color.colorNameNearest( 'ff0032' );
let rgb = _.color.ColorMap[ name ];
console.log( name, rgb );
/*
  red [ 1, 0, 0 ]
*/
```
##### Example #6
```javascript
/*Convert color to browser compatible rgb notation*/
let _ = wTools;
let rgb = _.color.ColorMap[ 'red' ];
let browser = _.color.colorToRgbHtml( rgb );
console.log( rgb, browser );
/*
  [ 1, 0, 0 ] 'rgb( 255, 0, 0 )'
*/
```

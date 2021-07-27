( function _l3_Path_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const Self = _.path;

// --
// meta
// --

function Init()
{
  let self = this;

  _.assert( _.strIs( self.rootToken ) );
  _.assert( _.strIs( self.upToken ) );
  _.assert( _.strIs( self.hereToken ) );
  _.assert( _.strIs( self.downToken ) );

  if( !self.downUpToken )
  self.downUpToken = self.downToken + self.upToken; /* ../ */
  if( !self.hereUpToken )
  self.hereUpToken = self.hereToken + self.upToken; /* ./ */

  let root = _.regexpEscape( self.rootToken );
  let up = _.regexpEscape( self.upToken );
  let down = _.regexpEscape( self.downToken );
  let here = _.regexpEscape( self.hereToken );

  let beginOrChar = '(?:.|^)';
  let butUp = `(?:(?!${up}).)+`;
  let notDownUp = `(?!${down}(?:${up}|$))`;
  let upOrBegin = `(?:^|${up})`;
  let upOrEnd = `(?:${up}|$)`;
  let splitOrUp = `(?:(?:${up}${up})|((${upOrBegin})${notDownUp}${butUp}${up}))`; /* split or / */

  self._delDownRegexp = new RegExp( `(${beginOrChar})${splitOrUp}${down}(${upOrEnd})`, '' );
  self._delHereRegexp = new RegExp( up + here + '(' + up + '|$)' );
  self._delUpDupRegexp = /\/{2,}/g;

}

//

function CloneExtending( o )
{
  _.assert( arguments.length === 1 );
  let result = Object.create( this )
  _.props.extend( result, Parameters, o );
  result.Init();
  return result;
}

// --
// dichotomy
// --

function is( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.strIs( path );
}

//

/**
 * Checks if string path is refined ( checks that the string doesn´t contain left( \\ ) or double slashes ( // ) ), and it also
 * returns true when the path has slash ( / ) in the end .
 * @param {String} filePath Source path for check
 * @returns {boolean}
 * @function isRefined
 * @namespace Tools.path
 */

function isRefined( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string {-path-}, but got', _.entity.strType( path ) );

  if( path[ 1 ] === ':' && path[ 2 ] === '\\' )
  return false;

  let leftSlash = /\\/g;
  let doubleSlash = /\/\//g;

  if( leftSlash.test( path ) )
  return false;

  return true;
}

//

/**
 * Checks if string path is normalized, and maybe trailed ( ends with a slash ( / ) ).
 * @param {String} filePath Source path for check
 * @returns {boolean}
 * @function isNormalized
 * @namespace Tools.path
 */

function isNormalized( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string' );
  let normalizedPath = this.normalize( filePath )
  let trailedPath = this.trail( normalizedPath );
  return normalizedPath === filePath || trailedPath === filePath;
}

//

function isAbsolute( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string {-filePath-}, but got', _.entity.strType( filePath ) );
  filePath = this.refine( filePath );
  return _.strBegins( filePath, this.upToken );
}

//

function isRelative( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string {-filePath-}, but got', _.entity.strType( filePath ) );
  return !this.isAbsolute( filePath );
}

//

function isGlobal( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string' );
  return _.strHas( filePath, '://' );
}

//

function isRoot( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string {-filePath-}, but got', _.entity.strType( filePath ) );
  if( filePath === this.rootToken )
  return true;
  if( this.isRelative( filePath ) )
  return false;
  if( this.normalize( filePath ) === this.rootToken )
  return true;
  return false;
}

//

function _isDotted( srcPath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( srcPath === this.hereToken )
  return true;
  if( srcPath === this.downToken )
  return true;
  if( _.strBegins( srcPath, this.hereToken + this.upToken ) )
  return true;
  if( _.strBegins( srcPath, this.downToken + this.upToken ) )
  return true;
  return false;
}

//

function isDotted( srcPath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( this._isDotted( srcPath ) )
  return true;
  if( _.strBegins( srcPath, this.hereToken + '\\' ) )
  return true;
  if( _.strBegins( srcPath, this.downToken + '\\' ) )
  return true;
  return false;
}

//

function isTrailed( srcPath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( srcPath === this.rootToken )
  return false;
  return _.strEnds( srcPath, this.upToken );
}

//

function begins( srcPath, beginPath )
{
  _.assert( arguments.length === 2, 'Expects two arguments' );
  _.assert( _.strIs( srcPath ), 'Expects string {-srcPath-}, but got', _.entity.strType( srcPath ) );
  _.assert( _.strIs( beginPath ), 'Expects string {-beginPath-}, but got', _.entity.strType( beginPath ) );
  if( srcPath === beginPath )
  return true;
  return _.strBegins( srcPath, this.trail( beginPath ) );
}

//

function ends( srcPath, endPath )
{
  _.assert( arguments.length === 2, 'Expects two arguments' );
  endPath = this.undot( endPath );

  if( !_.strEnds( srcPath, endPath ) )
  return false;

  let begin = _.strRemoveEnd( srcPath, endPath );
  if( begin === '' || _.strEnds( begin, this.upToken ) || _.strEnds( begin, this.hereToken ) )
  return true;

  return false;
}

// --
// reformer
// --

/**
  * The routine refine() regularize a Windows paths to posix path format by replacing left slashes to slash ( \\ to / ).
  * If the path has a disk label, the routine puts slash '/' before and after the disk label.
  * If the path is an empty string, method returns ''. Otherwise, routine returns original path.
  *
  * @param {string} src - path for refinement.
  *
  * @example
  *  // returns '/foo//bar/../';
  *  let path = '\\foo\\\\bar\\..\\';
  *  path = wTools.refine( path );
  *
  * @example
  *  // returns '/C/temp//foo/bar/../';
  *  let path = 'C:\\temp\\\\foo\\bar\\..\\';
  *  path = wTools.refine( path );
  *
  * @example
  *  // returns '';
  *  let path = '';
  *  path = wTools.refine( path );
  *
  * @example
  *  // returns '/foo/bar/';
  *  let path = '/foo/bar/';
  *  path = wTools.refine( path );
  *
  * @returns {string} Returns refined path.
  * @throws {Error} If {-arguments.length-} is less or more then one.
  * @throws {Error} If passed argument is not a string.
  * @function refine
  * @namespace Tools.path
  */

function refine( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) );

  let result = src;

  if( result[ 1 ] === ':' )
  {
    if( result[ 2 ] === '\\' || result[ 2 ] === '/' )
    {
      if( result.length > 3 )
      result = '/' + result[ 0 ] + '/' + result.substring( 3 );
      else
      result = '/' + result[ 0 ]
    }
    else if( result.length === 2 )
    {
      result = '/' + result[ 0 ];
    }
  }

  result = result.replace( /\\/g, '/' );

  return result;
}

//

function _normalize( o )
{
  // let debug = 0;
  // if( 0 )
  // debug = 1;

  _.routine.assertOptions( _normalize, arguments );
  _.assert( _.strIs( o.src ), 'Expects string' );

  if( !o.src.length )
  return '';

  let result = o.src;

  result = this.refine( result );

  // if( debug )
  // console.log( 'normalize.refined : ' + result );

  /* detrailing */

  if( o.tolerant )
  {
    /* remove "/" duplicates */
    result = result.replace( this._delUpDupRegexp, this.upToken );
  }

  let endsWithUp = false;
  let beginsWithHere = false;

  /* remove right "/" */

  if( result !== this.upToken && !_.strEnds( result, this.upToken + this.upToken ) && _.strEnds( result, this.upToken ) )
  {
    endsWithUp = true;
    result = _.strRemoveEnd( result, this.upToken );
  }

  /* undoting */

  while( !_.strBegins( result, this.hereUpToken + this.upToken ) && _.strBegins( result, this.hereUpToken ) )
  {
    beginsWithHere = true;
    result = _.strRemoveBegin( result, this.hereUpToken );
  }

  /* remove second "." */

  if( result.indexOf( this.hereToken ) !== -1 )
  {

    while( this._delHereRegexp.test( result ) )
    result = result.replace( this._delHereRegexp, function( match, postSlash )
    {
      return postSlash || '';
    });
    if( result === '' )
    result = this.upToken;

  }

  /* remove .. */

  if( result.indexOf( this.downToken ) !== -1 )
  {

    while( this._delDownRegexp.test( result ) )
    result = result.replace( this._delDownRegexp, function( /* match, notBegin, split, preSlash, postSlash */ )
    {
      let match = arguments[ 0 ];
      let notBegin = arguments[ 1 ];
      let split = arguments[ 2 ];
      let preSlash = arguments[ 3 ];
      let postSlash = arguments[ 4 ];

      if( preSlash === '' )
      return notBegin;
      if( !notBegin )
      return notBegin + preSlash;
      else
      return notBegin + ( postSlash || '' );
    });

  }

  /* nothing left */

  if( !result.length )
  result = '.';

  /* dot and trail */

  if( o.detrailing )
  if( result !== this.upToken && !_.strEnds( result, this.upToken + this.upToken ) )
  result = _.strRemoveEnd( result, this.upToken );

  if( !o.detrailing && endsWithUp )
  if( result !== this.rootToken )
  result = result + this.upToken;

  if( !o.undoting && beginsWithHere )
  result = this._dot( result );

  // if( debug )
  // console.log( 'normalize.result : ' + result );

  return result;
}

_normalize.defaults =
{
  src : null,
  tolerant : false,
  detrailing : false,
  undoting : false,
}

//

/**
 * Regularize a path by collapsing redundant delimeters and resolving '..' and '.' segments,so A//B,A/./B and
    A/foo/../B all become A/B. This string manipulation may change the meaning of a path that contains symbolic links.
    On Windows,it converts forward slashes to backward slashes. If the path is an empty string,method returns '.'
    representing the current working directory.
 * @example
   let path = '/foo/bar//baz1/baz2//some/..'
   path = wTools.normalize( path ); // /foo/bar/baz1/baz2
 * @param {string} src path for normalization
 * @returns {string}
 * @function normalize
 * @namespace Tools.path
 */

function normalize( src )
{
  let result = this._normalize({ src, tolerant : false, detrailing : false, undoting : false });

  _.assert( _.strIs( src ), 'Expects string' );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( result.lastIndexOf( this.upToken + this.hereToken + this.upToken ) === -1 );
  _.assert( !_.strEnds( result, this.upToken + this.hereToken ) );

  if( Config.debug )
  {
    let i = result.lastIndexOf( this.upToken + this.downToken + this.upToken );
    _.assert( i === -1 || !/\w/.test( result.substring( 0, i ) ) );
  }

  return result;
}

//

function normalizeTolerant( src )
{
  _.assert( _.strIs( src ), 'Expects string' );

  let result = this._normalize({ src, tolerant : true, detrailing : false, undoting : false });

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( result === this.upToken || _.strEnds( result, this.upToken ) || !_.strEnds( result, this.upToken + this.upToken ) );
  _.assert( result.lastIndexOf( this.upToken + this.hereToken + this.upToken ) === -1 );
  _.assert( !_.strEnds( result, this.upToken + this.hereToken ) );

  if( Config.debug )
  {
    _.assert( !this._delUpDupRegexp.test( result ) );
  }

  return result;
}

//

function canonize( src )
{
  let result = this._normalize({ src, tolerant : false, detrailing : true, undoting : true });

  _.assert( _.strIs( src ), 'Expects string' );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( result === this.upToken || _.strEnds( result, this.upToken + this.upToken ) || !_.strEnds( result, this.upToken ) );
  _.assert( result.lastIndexOf( this.upToken + this.hereToken + this.upToken ) === -1 );
  _.assert( !_.strEnds( result, this.upToken + this.hereToken ) );

  if( Config.debug )
  {
    let i = result.lastIndexOf( this.upToken + this.downToken + this.upToken );
    _.assert( i === -1 || !/\w/.test( result.substring( 0, i ) ) );
  }

  return result;
}

//

function canonizeTolerant( src )
{
  _.assert( _.strIs( src ), 'Expects string' );

  let result = this._normalize({ src, tolerant : true, detrailing : true, undoting : true });

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( result === this.upToken || _.strEnds( result, this.upToken ) || !_.strEnds( result, this.upToken + this.upToken ) );
  _.assert( result.lastIndexOf( this.upToken + this.hereToken + this.upToken ) === -1 );
  _.assert( !_.strEnds( result, this.upToken + this.hereToken ) );

  if( Config.debug )
  {
    _.assert( !this._delUpDupRegexp.test( result ) );
  }

  return result;
}

//

function _nativizeMinimalWindows( filePath )
{
  let self = this;

  let result = filePath;

  result = result.replace( /\//g, '\\' );

  if( result[ 0 ] === '\\' )
  if( result.length === 2 || result[ 2 ] === ':' || result[ 2 ] === '\\' )
  result = result[ 1 ] + ':' + result.substring( 2 );

  if( result.length === 2 && result[ 1 ] === ':' )
  result = result + '\\';

  return result;
}

//

function _nativizeWindows( filePath )
{
  let self = this;
  _.assert( _.strIs( filePath ), 'Expects string' ) ;

  let result = filePath;

  _.assert( _.routine.is( self.unescape ) );
  result = self.unescape( result ); /* xxx : remove from here */

  result = self._nativizeMinimalWindows( result );

  return result;
}

//

function _nativizeMinimalPosix( filePath )
{
  let self = this;
  let result = filePath;
  return result;
}

//

function _nativizePosix( filePath )
{
  let self = this;
  let result = filePath;
  _.assert( _.strIs( filePath ), 'Expects string' );
  _.assert( _.routine.is( self.unescape ) );
  result = self.unescape( result ); /* xxx : remove from here */
  return result;
}

//

function _nativizeEscapingWindows( filePath )
{
  let self = this;
  let unescapeResult = self._unescape( filePath )

  let result = self._nativizeMinimalWindows( unescapeResult.unescaped );

  if( unescapeResult.wasEscaped )
  result = filePath.replace( unescapeResult.unescaped, result );

  return result;
}

//

function _nativizeEscapingPosix( filePath )
{
  let self = this;
  let result = filePath;
  _.assert( _.strIs( filePath ), 'Expects string' );
  return result;
}

//

function nativize()
{
  if( _global.process && _global.process.platform === 'win32' )
  this.nativize = this._nativizeWindows;
  else
  this.nativize = this._nativizePosix;
  return this.nativize.apply( this, arguments );
}

//

function nativizeMinimal()
{
  if( _global.process && _global.process.platform === 'win32' )
  this.nativizeMinimal = this._nativizeMinimalWindows;
  else
  this.nativizeMinimal = this._nativizeMinimalPosix;
  return this.nativizeMinimal.apply( this, arguments );
}

//

function nativizeEscaping()
{
  if( _global.process && _global.process.platform === 'win32' )
  this.nativizeEscaping = this._nativizeEscapingWindows;
  else
  this.nativizeEscaping = this._nativizeEscapingPosix;
  return this.nativizeEscaping.apply( this, arguments );
}

// //
//
// function escape( filePath )
// {
//   let self = this;
//   let splits = self.split( filePath );
//
//   splits = splits.map( ( split ) =>
//   {
//
//     {
//       let i = 0;
//       while( split[ i ] === '"' )
//       i += 1;
//       if( i > 0 )
//       split = split.substring( 0, i ) + split;
//     }
//
//     {
//       let i = split.length-1;
//       while( split[ i ] === '"' )
//       i -= 1;
//       if( i < split.length-1 )
//       split = split + split.substring( i+1, split.length );
//     }
//
//     let left = _.strLeft_( split, self.escapeTokens )
//     if( left.entry )
//     return `"${split}"`;
//     return split;
//
//   });
//
//   return splits.join( self.upToken );
// }

//

function _unescape( filePath )
{
  let self = this;
  // let splits = self.split( filePath );
  /*
  cant use routine self.split because it normalizes path
  */
  let splits = filePath.split( self.upToken );

  let result = Object.create( null );
  result.wasEscaped = false;

  splits = splits.map( ( split ) =>
  {

    {
      let i = 0;
      while( split[ i ] === '"' )
      i += 1;
      if( i > 0 )
      {
        let c = i;
        if( c % 2 === 1 )
        result.wasEscaped = true;
        let c2 = Math.floor( ( c + 1 ) / 2 );
        split = split.substring( c2, split.length );
      }
    }

    {
      let i = split.length-1;
      while( split[ i ] === '"' )
      i -= 1;
      if( i < split.length-1 )
      {
        let c = split.length - i - 1;
        if( c % 2 === 1 )
        result.wasEscaped = true;
        let c2 = Math.floor( ( c + 1 ) / 2 );
        split = split.substring( 0, split.length - c2 );
      }
    }

    return split;
  });

  result.unescaped = splits.join( self.upToken );
  return result;
}

//

function unescape( filePath )
{
  let self = this;
  return self._unescape( filePath ).unescaped;
}

/* qqq2 : implement test routine _nativizeWindows */
/* qqq2 : implement test routine _nativizePosix */

/* qqq2 : implement routine _.path.unescape to transform:

`"'some path'"` -> `'some path'`
`"some path"` -> `some path`
`""some path""` -> `"some path"`
`'"some path"'` -> `'"some path"'`
`'some path'` -> `'some path'`

`some"-"path/t.txt` -> `some"-"path/t.txt`
`"some"-"path"/'t.txt'` -> `some"-"path/'t.txt'`

*/

/* qqq2 : implement routine _.path.escape

`"'some path'"` -> `""'some path'""`
`"some path"` -> `""some path""`
`""some path""` -> `"""some path"""`
`'"some path"'` -> `'"some path"'`
`'some path'` -> `'some path'`

`#some'` -> `"#some"`
`so#me'` -> `"so#me"`
`some#'` -> `"some#"`

`@some'` -> `"@some"`
`so@me'` -> `"so@me"`
`some@'` -> `"some@"`

`?some'` -> `"?some"`
`so?me'` -> `"so?me"`
`some?'` -> `"some?"`

=

`"#` -> `"""#"`
`"!` -> `""!`

`"#"` -> `"""#"""`
`"!"` -> `""!""`

`""#""` -> `"""""#"""""`
`""!""` -> `""""!""""`

*/

/* qqq2 : implement routines _.path.nativizeWindows_ _.path.nativizePosix_ using code from _.path.nativize and _.path.escape
*/

// --
// transformer
// --

function _split( path )
{
  return path.split( this.upToken );
}

//

function split( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string' )
  let result = this._split( this.refine( path ) );
  return result;
}

//

function _dot( filePath )
{

  if( !this._isDotted( filePath ) )
  {
    _.assert( !_.strBegins( filePath, this.upToken ) );
    filePath = this.hereUpToken + filePath;
  }

  return filePath;
}

//

function dot( filePath )
{

  /*
    cant use isAbsolute
  */

  _.assert( !_.strBegins( filePath, this.upToken ) );
  _.assert( arguments.length === 1 );

  /*
    not .
    not begins with ./
    not ..
    not begins with ../
  */

  // if( filePath !== this.hereToken && !_.strBegins( filePath, this.hereUpToken ) && filePath !== this.downToken && !_.strBegins( filePath, this.downUpToken ) )
  if( !this.isDotted( filePath ) )
  {
    _.assert( !_.strBegins( filePath, this.upToken ) );
    filePath = this.hereUpToken + filePath;
  }

  return filePath;
}

//

function undot( filePath )
{
  if( filePath === this.hereUpToken )
  return filePath
  return _.strRemoveBegin( filePath, this.hereUpToken );
}

//

function absolute( filePath )
{
  return this.join( this.rootToken, filePath );
}

//

function unabsolute( filePath )
{
  return _.strRemoveBegin( filePath, this.rootToken );
}

//

function trail( srcPath )
{
  _.assert( this.is( srcPath ) );
  _.assert( arguments.length === 1 );

  if( !_.strEnds( srcPath, this.upToken ) )
  return srcPath + this.upToken;

  return srcPath;
}

//

function detrail( path )
{
  _.assert( this.is( path ) );
  _.assert( arguments.length === 1 );

  if( path !== this.rootToken )
  return _.strRemoveEnd( path, this.upToken );

  return path;
}

//

/**
 * Returns the directory name of `path`.
 * @example
 * let path = '/foo/bar/baz/text.txt'
 * wTools.dir( path ); // '/foo/bar/baz'
 * @param {string} path path string
 * @returns {string}
 * @throws {Error} If argument is not string
 * @function dir
 * @namespace Tools.path
 */

function dir_head( routine, args )
{
  let o = args[ 0 ];

  if( _.strIs( o ) )
  {
    if( args.length === 2 )
    o = { filePath : args[ 0 ], depth : args[ 1 ] };
    else
    o = { filePath : args[ 0 ] };
  }

  _.routine.options( routine, o );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( arguments.length === 2 );
  _.assert( _.intIs( o.depth ) );
  _.assert( _.strDefined( o.filePath ), 'Expects not empty string {- o.filePath -}' );

  return o;
}

function dir_body( o )
{
  let self = this;
  let isTrailed = this.isTrailed( o.filePath );

  _.routine.assertOptions( dir_body, arguments );

  if( o.first )
  o.filePath = this.normalize( o.filePath );
  else
  o.filePath = this.canonize( o.filePath );

  if( o.depth === 0 )
  {
    return o.filePath;
  }
  else if( o.depth > 1 )
  {
    for( let i = o.depth - 1; i >= 0; i-- )
    {
      if
      (
        o.filePath === this.rootToken || o.filePath === this.hereToken || o.filePath === this.downToken
        || o.filePath === this.hereToken + this.upToken || o.filePath === this.downToken + this.upToken
        || ( o.filePath.match( /\W{3}$/ ) && o.filePath.match( /\W{3}$/ )[ 0 ] === '/..' )
        || ( o.filePath.match( /\W{4}$/ ) && o.filePath.match( /\W{4}$/ )[ 0 ] === '/../' )
      )
      {
        if( o.filePath[ o.filePath.length - 1 ] === '/' )
        o.filePath = o.filePath + this.downToken + ( o.first ? this.upToken : '' );
        else
        o.filePath = o.filePath + this.upToken + this.downToken + ( o.first ? this.upToken : '' );
      }
      else
      {
        if( o.filePath[ o.filePath.length - 1 ] === '/' )
        {
          o.filePath = o.filePath.substring( 0, o.filePath.length - 1 );
          o.filePath = o.filePath.substring( 0, o.filePath.lastIndexOf( '/' ) + ( o.first ? 1 : 0 ) );
          if( o.filePath.length === 0 )
          o.filePath = '.';
        }
        else
        {
          let indexOfSubstr = o.filePath.lastIndexOf( '/' ) === 0 && !o.first ? 1 : o.filePath.lastIndexOf( '/' );
          o.filePath = o.filePath.substring( 0, indexOfSubstr + ( o.first ? 1 : 0 ) );
          if( o.filePath.length === 0 )
          o.filePath = '.';
        }
      }
    }

    if( !o.first )
    o.filePath = _.path.canonize( o.filePath );

    return o.filePath;
  }
  else
  {
    _.assert( o.depth > 0 );
  }

  if( o.first )
  if( isTrailed )
  return o.filePath;

  if( o.filePath === this.rootToken )
  {
    return o.filePath + this.downToken + ( o.first ? this.upToken : '' );
  }

  if( _.strEnds( o.filePath, this.upToken + this.downToken ) || o.filePath === this.downToken )
  {
    return o.filePath + this.upToken + this.downToken + ( o.first ? this.upToken : '' );
  }

  let i = o.filePath.lastIndexOf( this.upToken );

  if( i === 0 )
  {
    return this.rootToken;
  }

  if( i === -1 )
  {
    if( o.first )
    {
      if( o.filePath === this.hereToken )
      return this.downToken + this.upToken;
      else
      return this.hereToken + this.upToken;
    }
    else
    {
      if( o.filePath === this.hereToken )
      return this.downToken + ( isTrailed ? this.upToken : '' );
      else
      return this.hereToken + ( isTrailed ? this.upToken : '' );
    }
  }

  let result;

  if( o.first )
  result = o.filePath.substr( 0, i + self.upToken.length );
  else
  result = o.filePath.substr( 0, i );

  if( !o.first )
  if( isTrailed )
  result = _.strAppendOnce( result, self.upToken );

  _.assert( !!result.length )

  return result;
}

dir_body.defaults =
{
  filePath : null,
  first : 0,
  depth : 1,
}

let dir = _.routine.uniteCloning( dir_head, dir_body );
dir.defaults.first = 0;

let dirFirst = _.routine.uniteCloning( dir_head, dir_body );
dirFirst.defaults.first = 1;

_.assert( !dir.defaults.first );

//

/**
 * Returns path name (file name).
 * @example
 * wTools.name( '/foo/bar/baz.asdf' ); // 'baz'
 * @param {string|object} path|o Path string, or options
 * @param {boolean} o.full if this parameter set to true method return name with extension.
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @function name
 * @namespace Tools.path
 */

function name_head( routine, args )
{
  let o = args[ 0 ];
  if( _.strIs( o ) )
  o = { path : o };

  _.routine.options_( routine, o );
  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );
  _.assert( _.strIs( o.path ), 'Expects string {-o.path-}' );

  return o;
}

function name_body( o )
{

  if( _.strIs( o ) )
  o = { path : o };

  _.routine.assertOptions( name_body, arguments );

  o.path = this.canonize( o.path );

  let i = o.path.lastIndexOf( '/' );
  if( i !== -1 )
  o.path = o.path.substr( i+1 );

  if( !o.full )
  {
    let i = o.path.lastIndexOf( '.' );
    if( i !== -1 ) o.path = o.path.substr( 0, i );
  }

  return o.path;
}

name_body.defaults =
{
  path : null,
  full : 0,
}

let name = _.routine.uniteCloning( name_head, name_body );
name.defaults.full = 0;

let fullName = _.routine.uniteCloning( name_head, name_body );
fullName.defaults.full = 1;

// --
// extension
// --

let Parameters =
{

  rootToken : '/',
  upToken : '/',
  hereToken : '.',
  downToken : '..',
  hereUpToken : null, /* ./ */
  downUpToken : null, /* ../ */
  escapeTokens : [ '@', '#', '!', '?' ],

  _delHereRegexp : null,
  _delDownRegexp : null,
  _delUpDupRegexp : null,
  _pathIsGlobRegexp : null,

}

let Extension =
{

  // meta

  Init,
  CloneExtending,

  // dichotomy

  is,

  isRefined,
  isNormalized,
  isAbsolute,
  isRelative,
  isGlobal,
  isRoot,
  _isDotted,
  isDotted,
  isTrailed,

  begins,
  ends,

  // reformer

  refine,

  _normalize,
  normalize,
  normalizeTolerant,

  canonize,
  canonizeTolerant,

  _nativizeMinimalWindows,
  _nativizeWindows,
  _nativizeMinimalPosix,
  _nativizePosix,
  _nativizeEscapingWindows,
  _nativizeEscapingPosix,
  nativize,
  nativizeMinimal,
  nativizeEscaping,

  // escape,
  _unescape,
  unescape,

  // transformer

  _split,
  split,
  _dot,
  dot,
  undot,
  absolute, /* qqq : cover */
  unabsolute,
  trail,
  detrail,
  dir,
  dirFirst,
  name,
  fullName,

  // fields

  Parameters,

  fileProvider : null,
  path : Self,
  single : Self,
  s : null,

}

Object.assign( Self, Parameters );
Object.assign( Self, Extension );

Self.Init();

})();

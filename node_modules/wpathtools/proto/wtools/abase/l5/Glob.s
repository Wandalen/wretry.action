( function _Glob_s_()
{

'use strict';

/**
 *  */

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );
  _.include( 'wPathBasic' );
  _.include( 'wStringsExtra' );

}

//

const _global = _global_;
const _ = _global_.wTools;
const Self = _.path = _.path || Object.create( null );

// --
// functor
// --

function _vectorize( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  select = select || 1;
  return _.routineVectorize_functor
  ( {
    routine,
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 1,
    select,
  } );
}

// --
// simple transformer
// --

/*
(\*\*)| -- **
([?*])| -- ?*
(\[[!^]?.*\])| -- [!^]
([+!?*@]\(.*\))| -- @+!?*()
(\{.*\}) -- {}
(\(.*\)) -- ()
*/

let _pathIsGlobRegexpSource = '';
_pathIsGlobRegexpSource += '(?:[?*]+)'; /* asterix, question mark */
_pathIsGlobRegexpSource += '|(?:([!?*@+]*)\\((.*?(?:\\|(.*?))*)\\))'; /* parentheses */
_pathIsGlobRegexpSource += '|(?:\\[(.+?)\\])'; /* square brackets */
_pathIsGlobRegexpSource += '|(?:\\{(.*)\\})'; /* curly brackets */
_pathIsGlobRegexpSource += '\\(\\)|\\0'; /* zero */

let _pathIsGlobRegexp = new RegExp( _pathIsGlobRegexpSource );

function _fromGlob( glob )
{
  let self = this;
  let result;

  _.assert( _.strIs( glob ), () => 'Expects string {-glob-}, but got ' + _.entity.strType( glob ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( glob === '' || glob === null )
  return glob;

  let i = glob.search( _pathIsGlobRegexp );

  if( i >= 0 )
  {

    while( i >= 0 && glob[ i ] !== self.upToken )
    i -= 1;

    if( i === -1 )
    result = '';
    else
    result = glob.substr( 0, i+1 );

    result = self.detrail( result || self.hereToken );

  }
  else
  {
    result = glob;
  }

  _.assert( !self.isGlob( result ) );

  return result;
}

//

function globNormalize( glob )
{
  let self = this;
  let result = _.strReplaceAll( glob, { '()' : '', '*()' : '', '\0' : '' } ); /* xxx : cover */
  if( result !== glob )
  result = self.canonize( result );
  return result;
}

//

let _globShortSplitToRegexpSource = ( function functor()
{

  let self;
  let _globRegexpSourceCache = Object.create( null )

  let _transformation0 =
  [
    [ /\[(.+?)\]/g, handlePass ], /* square brackets */
    [ /\.\./g, handlePass ], /* dual dot */
    [ /\./g, handlePass ], /* dot */
    [ /\(\)|\0/g, handlePass ], /* empty parentheses or zero */
    [ /([!?*@+]*)\((.*?(?:\|(.*?))*)\)/g, handlePass ], /* parentheses */
    [ /\*\*\*/g, handlePass ], /* triple asterix */
    [ /\*\*/g, handlePass ], /* dual asterix */
    [ /(\*)/g, handlePass ], /* single asterix */
    [ /(\?)/g, handlePass ], /* question mark */
  ]

  let _transformation1 =
  [
    [ /\[(.+?)\]/g, handleSquareBrackets ], /* square brackets */
    [ /\{(.*)\}/g, handleCurlyBrackets ], /* curly brackets */
  ]

  let _transformation2 =
  [
    [ /\.\./g, '\\.\\.' ], /* dual dot */
    [ /\./g, '\\.' ], /* dot */
    [ /\(\)|\0/g, '' ], /* empty parentheses or zero */
    [ /([!?*@+]?)\((.*?(?:\|(.*?))*)\)/g, hanleParentheses ], /* parentheses */
    // [ /\/\*\*/g, '(?:\/.*)?', ], /* slash + dual asterix */
    [ /\*\*\*/g, '(?:.*)' ], /* triple asterix */
    [ /\*\*/g, '.*' ], /* dual asterix */
    [ /(\*)/g, '[^\/]*' ], /* single asterix */
    [ /(\?)/g, '[^\/]' ], /* question mark */
  ]

  /* */

  _globShortSplitToRegexpSource.functor = functor;
  return _globShortSplitToRegexpSource;

  function _globShortSplitToRegexpSource( src )
  {
    self = this;

    let result = _globRegexpSourceCache[ src ];
    if( result )
    return result;

    _.assert( _.strIs( src ) );
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert
    (
      !_.strHas( src, /(^|\/)\.\.(\/|$)/ ) || src === self.downToken,
      'glob should not has splits with ".." combined with something'
    );

    result = transform( src );

    _globRegexpSourceCache[ src ] = result;

    return result;
  }

  /* */

  function transform( src )
  {
    let result = src;

    result = _.strReplaceAll
    ( {
      src : result,
      dictionary : _transformation0,
      joining : 1,
      onUnknown : handleUnknown,
    } );

    result = _.strReplaceAll( result, _transformation1 );
    result = _.strReplaceAll( result, _transformation2 );

    return result;
  }

  /* */

  function handleUnknown( src )
  {
    return _.regexpEscape( src );
  }

  /* */

  function handlePass( src )
  {
    return src;
  }

  /* */

  function handleCurlyBrackets( src, it )
  {
    throw _.err( 'Glob with curly brackets is not allowed ', src );
  }

  /* */

  function handleSquareBrackets( src, it )
  {
    let inside = it.groups[ 0 ];
    /* escape inner [] */
    inside = inside.replace( /[\[\]]/g, ( m ) => '\\' + m );
    /* replace ! -> ^ at the beginning */
    inside = inside.replace( /^!/g, '^' );
    if( inside[ 0 ] === '^' )
    inside = inside + '\/';
    return [ '[' + inside + ']' ];
  }

  /* */

  function hanleParentheses( src, it )
  {

    let inside = it.groups[ 1 ].split( '|' );
    let multiplicator = it.groups[ 0 ];

    multiplicator = _.strReverse( multiplicator );
    if( multiplicator === '*' )
    multiplicator += '?';

    _.assert( _.strCount( multiplicator, '!' ) === 0 || multiplicator === '!' );
    _.assert( _.strCount( multiplicator, '@' ) === 0 || multiplicator === '@' );

    inside = inside.map( ( i ) => self._globShortSplitToRegexpSource( i ) );

    let result = '(?:' + inside.join( '|' ) + ')';
    if( multiplicator === '@' )
    result = result;
    else if( multiplicator === '!' )
      result = '(?:(?!(?:' + result + '|\/' + ')).)*?';
    else
      result += multiplicator;

    /* (?:(?!(?:abc)).)+ */

    return result;
  }

  /* */

} )();

// --
// short filter
// --

function globShortSplitToRegexp( glob )
{
  let self = this;

  _.assert( _.strIs( glob ) || _.regexpIs( glob ) );
  _.assert( arguments.length === 1 );

  if( _.regexpIs( glob ) )
  return glob;

  let str = self._globShortSplitToRegexpSource( glob );
  let result = new RegExp( '^' + str + '$' );
  return result;
}

//

function globShortFilter_head( routine, args )
{
  let result;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ];
  if( args[ 1 ] !== undefined )
  o = { src : args[ 0 ], selector : args[ 1 ] }

  o = _.routine.options_( routine, o );

  if( o.onEvaluate === null )
  o.onEvaluate = function byVal( e, k, src )
  {
    return e;
  }

  return o;
}

//

function globShortFilter_body( o )
{
  let self = this;
  let result;

  _.assert( arguments.length === 1 );

  // if( _global_.debugger )
  // debugger;

  if( self.isGlob( o.selector ) )
  {
    let regexp = self.globShortSplitsToRegexps( o.selector );
    result = _.filter_( null, o.src, ( e, k ) =>
    {
      let val = o.onEvaluate( e, k, o.src );
      return regexp.test( val ) ? e : undefined;
    } );
  }
  else
  {
    result = _.filter_( null, o.src, ( e, k ) =>
    {
      return o.onEvaluate( e, k, o.src ) === o.selector ? e : undefined;
    } );
  }

  return result;
}

globShortFilter_body.defaults =
{
  src : null,
  selector : null,
  onEvaluate : null,
}

let globShortFilter = _.routine.uniteCloning_replaceByUnite( globShortFilter_head, globShortFilter_body );

let globShortFilterVals = _.routine.uniteCloning_replaceByUnite( globShortFilter_head, globShortFilter_body );
globShortFilterVals.defaults.onEvaluate = function byVal( e, k, src )
{
  return e;
}

let globShortFilterKeys = _.routine.uniteCloning_replaceByUnite( globShortFilter_head, globShortFilter_body );
globShortFilterKeys.defaults.onEvaluate = function byKey( e, k, src )
{
  return _.arrayIs( src ) ? e : k;
}

//

function globShortFit_body( o )
{
  let self = this;
  let result = self.globShortFilter
  ( {
    src : [ o.src ],
    selector : o.selector,
    onEvaluate : o.onEvaluate,
  } );
  return result.length === 1;
}

globShortFit_body.defaults =
{
  src : null,
  selector : null,
  onEvaluate : null,
}

let globShortFit = _.routine.uniteCloning_replaceByUnite( globShortFilter_head, globShortFit_body );

// --
// long
// --

function _globLongSplitsToRegexps( glob )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( self.isGlob( glob ) );

  glob = self.canonize( glob );

  let analogs1 = self._globAnalogs1( glob );
  let result = [];

  let splits = self.split( analogs1 );
  if( splits[ 0 ] === '' )
  splits[ 0 ] = '/';
  let sources = splits.map( ( e, i ) => self._globShortSplitToRegexpSource( e ) );
  result = self._globRegexpSourceSplitsJoinForTerminal( sources );

  result = new RegExp( '^(?:' + result + ')$' );

  return result;
}

//

function globLongFilter_head( routine, args )
{
  let result;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ];
  if( args[ 1 ] !== undefined )
  o = { src : args[ 0 ], selector : args[ 1 ] }

  o = _.routine.options_( routine, o );

  if( o.onEvaluate === null )
  o.onEvaluate = function byVal( e, k, src )
  {
    return e;
  }

  return o;
}

//

function globLongFilter_body( o )
{
  let self = this;
  let result;

  _.assert( arguments.length === 1 );

  if( self.isGlob( o.selector ) )
  {
    let selectorIsAbsolute = self.isAbsolute( o.selector );
    let regexp = self._globLongSplitsToRegexps( o.selector );
    result = _.filter_( null, o.src, ( e, k ) =>
    {
      let val = o.onEvaluate( e, k, o.src );
      // if( selectorIsAbsolute && !self.isAbsolute( val ) )
      // return undefined;
      // debugger;
      val = self.canonize( val );
      return regexp.test( val ) ? e : undefined;
    } );
  }
  else
  {
    result = _.filter_( null, o.src, ( e, k ) =>
    {
      return o.onEvaluate( e, k, o.src ) === o.selector ? e : undefined;
    } );
  }

  return result;
}

globLongFilter_body.defaults =
{
  src : null,
  selector : null,
  onEvaluate : null,
}

let globLongFilter = _.routine.uniteCloning_replaceByUnite( globLongFilter_head, globLongFilter_body );

let globLongFilterVals = _.routine.uniteCloning_replaceByUnite( globLongFilter_head, globLongFilter_body );
globLongFilterVals.defaults.onEvaluate = function byVal( e, k, src )
{
  return e;
}

let globLongFilterKeys = _.routine.uniteCloning_replaceByUnite( globLongFilter_head, globLongFilter_body );
globLongFilterKeys.defaults.onEvaluate = function byKey( e, k, src )
{
  return _.arrayIs( src ) ? e : k;
}

//

function globLongFit_body( o )
{
  let self = this;
  let result = self.globLongFilter
  ( {
    src : [ o.src ],
    selector : o.selector,
    onEvaluate : o.onEvaluate,
  } );
  return result.length === 1;
}

globLongFit_body.defaults =
{
  src : null,
  selector : null,
  onEvaluate : null,
}

let globLongFit = _.routine.uniteCloning_replaceByUnite( globLongFilter_head, globLongFit_body );

// --
// full filter
// --

let _removeExtraDoubleAsterisk = new RegExp( '\\*\\*' + '(?:' + Self._upRegSource + '\\*\\*' + ')+' );

function _globAnalogs1( glob )
{
  let self = this;
  let splits = self.split( glob );
  let counter = 0;

  _.assert( _.strIs( glob ), 'Expects string {-glob-}' );

  /* separate dual asterisks */

  for( let s = splits.length-1 ; s >= 0 ; s-- )
  {
    let split = splits[ s ];

    if( split === '**' || split === '***' )
    continue;

    if( !_.strHas( split, '**' ) )
    continue;

    counter += 1;
    split = _.strSplitFast( { src : split, delimeter : [ '***', '**' ], preservingEmpty : 0 } );

    for( let e = split.length-1 ; e >= 0 ; e-- )
    {
      let element = split[ e ];
      if( element === '**' || element === '***' )
      {
        element = '***';
        split[ e ] = element;
        continue;
      }

      if( !element )
      {
        _.assert( 0, 'not expected' );
        split.splice( e, 1 );
        continue;
      }

      if( e > 0 )
      element = '*' + element;
      if( e < split.length-1 )
      element = element + '*';

      split[ e ] = element;
    }
    _.longBut_( splits, splits, [ s, s ], split );
    // _.longButInplace( splits, [ s, s+1 ], split );
  }

  /* concat */

  let result = splits.join( self.upToken );

  /* remove duplicates of dual asterisks */

  for( let r = result.length-1 ; r >= 0 ; r-- )
  {
    let res = result[ r ];
    do
    {
      res = res.replace( _removeExtraDoubleAsterisk, self.upToken );
      if( res === result[ r ] )
      break;
      else
      result[ r ] = res;
    }
    while( true );
  }

  /* */

  return result;
}

//

function _globAnalogs2( glob, stemPath, basePath )
{
  let self = this;

  if( _.arrayIs( glob ) )
  {
    return glob.map( ( glob ) => self._globAnalogs2( glob, stemPath, basePath ) );
  }

  _.assert( arguments.length === 3, 'Expects exactly four arguments' );
  _.assert( _.strIs( glob ), 'Expects string {-glob-}' );
  _.assert( _.strIs( stemPath ), 'Expects string' );
  _.assert( _.strIs( basePath ) );
  _.assert( !self.isRelative( glob ) === !self.isRelative( stemPath ), 'Expects both relative path either absolute' );
  _.assert( self.isGlob( glob ), () => 'Expects glob, but got ' + glob );

  let result = [];
  let globDir = self.fromGlob( glob );

  let globRelativeBase = self.relative( basePath, glob );
  let globDirRelativeBase = self.relative( basePath, globDir );
  let stemRelativeBase = self.relative( basePath, stemPath );
  let baseRelativeStem = self.relative( stemPath, basePath );
  let globDirRelativeStem = self.relative( stemPath, globDir );
  let stemRelativeGlobDir = self.relative( globDir, stemPath );
  let globRelativeGlobDir = self.relative( globDir, glob );

  if( globDirRelativeBase === self.hereToken && stemRelativeBase === self.hereToken )
  {

    result.push( self.dot( globRelativeBase ) );

  }
  else
  {

    if( isDotted( stemRelativeGlobDir ) )
    {
      if( self.begins( stemPath, globDir ) || self.begins( globDir, stemPath ) )
      handleInside();
      else
      handleNever();
    }
    else
    {
      handleOutside();
    }

  }

  return result;

  /* */

  function handleInside()
  {

    let globSplits = globRelativeGlobDir

    let glob3 = globSplits;
    if( globDirRelativeStem !== self.hereToken )
    glob3 = globDirRelativeStem + self.upToken + glob3;
    if( stemRelativeGlobDir === self.hereToken )
    {
      glob3 = globDirRelativeBase + self.upToken + glob3;
    }
    else
    {
      glob3 = self.join( stemRelativeBase, glob3 );
    }
    _.arrayAppendOnce( result, self.dot( glob3 ) );

    if( self.begins( globDir, basePath ) || self.begins( basePath, globDir ) )
    {
      let glob4 = globSplits;
      if( !isDotted( globDirRelativeBase ) )
      glob4 = globDirRelativeBase + self.upToken + glob4;
      _.arrayAppendOnce( result, self.dot( glob4 ) );
    }

  }

  /* */

  function handleOutside()
  {

    let globSplits = globRelativeGlobDir.split( self.upToken );
    let globRegexpSourceSplits = globSplits.map( ( e, i ) => self._globShortSplitToRegexpSource( e ) );

    if( handleCertain( globSplits, globRegexpSourceSplits ) )
    return;

    let s = 0;
    let firstAny = globSplits.length;
    while( s < globSplits.length )
    {
      let split = globSplits[ s ];
      if( split === '**' || split === '***' )
      {
        firstAny = s;
      }
      let globSliced = new RegExp( '^' + self._globRegexpSourceSplitsJoinForTerminal( globRegexpSourceSplits.slice( 0, s+1 ) ) + '$' );
      if( globSliced.test( stemRelativeGlobDir ) )
      {

        let splits3 = firstAny < globSplits.length ? globSplits.slice( firstAny ) : globSplits.slice( s+1 );
        if( stemRelativeBase !== self.hereToken )
        {
          if( isDotted( stemRelativeGlobDir ) )
          _.arrayPrependArray( splits3, self.split( baseRelativeStem ) );
          _.arrayPrependArray( splits3, self.split( stemRelativeBase ) );
          let glob3 = splits3.join( self.upToken );
          _.arrayAppendOnce( result, self.dot( glob3 ) );
        }

        let splits4 = firstAny < globSplits.length ? globSplits.slice( firstAny ) : globSplits.slice( s+1 );
        let glob4 = splits4.join( self.upToken );
        _.arrayAppendOnce( result, self.dot( glob4 ) );

      }
      s += 1;
    }

  }

  /* */

  function handleCertain( globSplits, globRegexpSourceSplits )
  {

    if( globSplits.length === 1 )
    if( globSplits[ 0 ] === '**' || globSplits[ 0 ] === '***' )
    {
      _.assert( result.length === 0 );
      result.push( '**' );
      return true;
    }

    if( globSplits[ globSplits.length - 1 ] !== '**' && globSplits[ globSplits.length - 1 ] !== '***' )
    return false;

    let globSliced = new RegExp( '^' + self._globRegexpSourceSplitsJoinForTerminal( globRegexpSourceSplits ) + '$' );
    if( !globSliced.test( stemRelativeGlobDir ) )
    return false;

    _.assert( result.length === 0 );
    result.push( '**' );
    return true;
  }

  /* */

  function handleNever()
  {
  }

  /* */

  function isDotted( filePath )
  {
    return filePath === self.hereToken || filePath === self.downToken || _.strBegins( filePath, self.downToken );
  }

  /* */

  function isUp( filePath )
  {
    return filePath === self.downToken || _.strBegins( filePath, self.downToken );
  }

  /* */

}

//

function globHas( superGlob, subGlob )
{
  let self = this;

  _.assert( _.strIs( superGlob ), 'Expects string' );
  _.assert( _.strIs( subGlob ), 'Expects string' );

  let superGlob0 = superGlob;
  let superGlobs = self.globNormalize( superGlob );
  superGlobs = _.array.as( self._globAnalogs1( superGlobs ) );

  let subGlob0 = subGlob;
  let subGlobs = self.globNormalize( subGlob );
  subGlobs = _.array.as( self._globAnalogs1( subGlobs ) );

  _.assert( _.arrayIs( superGlobs ) );
  _.assert( _.arrayIs( subGlobs ) );


  for( let sp = 0 ; sp < superGlobs.length ; sp++ )
  {
    let superGlob = superGlobs[ sp ];
    let superPath = self.fromGlob( superGlob );

    let superGlobSplits = superGlob.split( self.upToken );
    let lastSplit = superGlobSplits[ superGlobSplits.length-1 ];

    if( lastSplit !== '**' && lastSplit !== '***' )
    continue;

    for( let sb = 0 ; sb < subGlobs.length ; sb++ )
    {
      let subGlob = subGlobs[ sb ];
      let subPath = self.fromGlob( subGlob );

      if( self.begins( subGlob, superGlob ) )
      return true;

      if( !self.begins( subPath, superPath ) )
      continue;

      let superSourceSplits = superGlobSplits.map( ( e, i ) => self._globShortSplitToRegexpSource( e ) );

      let superRegexp = new RegExp( '^' + self._globRegexpSourceSplitsJoinForTerminal( superSourceSplits ) + '$' );
      if( superRegexp.test( subPath ) )
      return true;

    }
  }

  return false;
}

//

function _globRegexpSourceSplitsConcatWithSlashes( globRegexpSourceSplits )
{
  let result = [];

  /*
    asterisk and dual-asterisk are optional elements of pattern
    so them could be missing
  */

  let isPrevTriAsterisk = false;
  let isPrevRoot = false;
  for( let s = 0 ; s < globRegexpSourceSplits.length ; s++ )
  {
    let split = globRegexpSourceSplits[ s ];

    let isTriAsterisk = split === '(?:.*)'; /* *** */
    let isDualAsterisk = split === '.*'; /* ** */
    let isAsterisk = split === '[^\/]*'; /* * */
    let isRoot = split === '/'; /* / */
    let prefix = isPrevRoot ? '(?:)' : '(?:^|/)';
    // prefix = '(?:^|/)'; /* xxx : comment out later */

    if( isTriAsterisk )
    {
      split = `(?:${prefix}` + split + ')?';
    }
    else if( isDualAsterisk )
    {
      split = `(?:${prefix}` + split + ')?';
    }
    else if( isAsterisk )
    {
      split = `(?:${prefix}` + split + ')?';
    }
    else if( s > 0 )
    {
      if( isPrevTriAsterisk )
      split = `${prefix}?` + split;
      else
      split = prefix + split;
    }

    isPrevRoot = isRoot;
    isPrevTriAsterisk = isTriAsterisk;
    result[ s ] = split;
  }

  return result;
}

//

function _globRegexpSourceSplitsJoinForTerminal( globRegexpSourceSplits )
{
  let self = this;
  let splits = self._globRegexpSourceSplitsConcatWithSlashes( globRegexpSourceSplits );
  let result = splits.join( '' );
  return result;
}

//

function _globRegexpSourceSplitsJoinForDirectory( globRegexpSourceSplits )
{
  let self = this;
  let splits = self._globRegexpSourceSplitsConcatWithSlashes( globRegexpSourceSplits );
  let result = _.regexpsAtLeastFirst( splits ).source;
  return result;
}

//

let _globFullToRegexpSingleCache = Object.create( null ); /* xxx : try */
function _globFullToRegexpSingle( glob, stemPath, basePath )
{
  let self = this;

  _.assert( _.strIs( glob ), 'Expects string {-glob-}' );
  _.assert( _.strIs( stemPath ) && !self.isGlob( stemPath ) );
  _.assert( _.strIs( basePath ) && !self.isGlob( basePath ) );
  // _.assert( !!isPositive || isPositive === undefined ); /* xxx */
  // _.assert( arguments.length === 3 || arguments.length === 4 );
  _.assert( arguments.length === 3 );

  // if( isPositive !== undefined && !isPositive )
  // debugger;

  glob = self.join( stemPath, glob );

  _.assert( self.isGlob( glob ) );

  let analogs1 = self._globAnalogs1( glob );
  let analogs2 = self._globAnalogs2( analogs1, stemPath, basePath );

  let result = Object.create( null );
  result.transient = [];
  result.actual = [];
  result.certainly = [];

  for( let r = 0 ; r < analogs2.length ; r++ )
  {
    let analog = analogs2[ r ];
    let splits = self.split( analog );

    let certainlySplits;
    if( splits[ splits.length - 1 ] === '**' || splits[ splits.length - 1 ] === '***' )
    certainlySplits = splits.slice();

    let sources = splits.map( ( e, i ) => self._globShortSplitToRegexpSource( e ) );
    if( certainlySplits )
    certainlySplits = certainlySplits.map( ( e, i ) => self._globShortSplitToRegexpSource( e ) );

    result.actual.push( self._globRegexpSourceSplitsJoinForTerminal( sources ) );
    result.transient.push( self._globRegexpSourceSplitsJoinForDirectory( sources ) );
    if( certainlySplits )
    result.certainly.push( self._globRegexpSourceSplitsJoinForTerminal( certainlySplits ) );
  }

  result.transient = '(?:(?:' + result.transient.join( ')|(?:' ) + '))';
  result.transient = _.regexpsJoin( [ '^', result.transient, '$' ] );

  result.actual = '(?:(?:' + result.actual.join( ')|(?:' ) + '))';
  result.actual = _.regexpsJoin( [ '^', result.actual, '$' ] );

  if( result.certainly.length )
  {
    result.certainly = '(?:(?:' + result.certainly.join( ')|(?:' ) + '))';
    result.certainly = _.regexpsJoin( [ '^', result.certainly, '$' ] );
  }
  else
  {
    result.certainly = null;
  }

  return result;
}

//

function globsFullToRegexps()
{
  let self = this;
  let r = self._globsFullToRegexps.apply( this, arguments );
  if( _.arrayIs( r ) )
  {
    let result = Object.create( null );
    result.actual = r.map( ( e ) => e.actual );
    result.transient = r.map( ( e ) => e.transient );
    return result;
  }
  return r;
}

//

function pathMapToRegexps( o )
{
  let self = this;
  let regexps = Object.create( null );

  if( arguments[ 1 ] !== undefined )
  o = { filePath : arguments[ 0 ], basePath : arguments[ 1 ] }

  _.routine.options_( pathMapToRegexps, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.mapIs( o.basePath ) );
  _.assert( _.mapIs( o.filePath ) )

  /* has only booleans */

  let hasOnlyBools = 1;
  for( let srcGlob in o.filePath )
  {
    let dstPath = o.filePath[ srcGlob ];
    if( !_.boolLike( dstPath ) )
    {
      hasOnlyBools = 0;
      break;
    }
  }

  if( hasOnlyBools )
  {
    for( let srcGlob in o.filePath )
    if( _.boolLike( o.filePath[ srcGlob ] ) && o.filePath[ srcGlob ] )
    o.filePath[ srcGlob ] = '';
  }

  /* unglob filePath */

  fileUnglob();
  o.optimizedUnglobedFilePath = _.props.extend( null, o.unglobedFilePath );

  /* unglob basePath */

  o.unglobedBasePath = baseUnglob();
  o.optimizedUnglobedBasePath = _.props.extend( null, o.unglobedBasePath );

  /* group by path */

  o.groupsMap = groupBySrc( 0 );
  o.optimalGroupsMap = groupBySrc( 1 );

  /* */

  o.optimalRegexpsMap = Object.create( null );
  for( let stemPath in o.optimalGroupsMap )
  {
    let r = o.optimalRegexpsMap[ stemPath ] = regexpsMapFor( stemPath, o.optimalGroupsMap[ stemPath ] );
  }

  o.regexpsMap = Object.create( null );
  for( let stemPath in o.groupsMap )
  {
    let r = o.regexpsMap[ stemPath ] = regexpsMapFor( stemPath, o.groupsMap[ stemPath ] );
  }

  /* */

  return o;

  /* */

  function globRemoveLastTotal( filePath )
  {

    if( filePath[ filePath.length-1 ] !== '*' )
    return filePath;

    if( filePath === '***' )
    filePath = '.';
    else if( filePath === '**' )
      filePath = '.';
    else if( filePath === '/***' )
      filePath = '/';
    else if( filePath === '/**' )
      filePath = '/';
    else if( _.strEnds( filePath, '/***' ) )
      filePath = _.strRemoveEnd( filePath, '/**' )
    else
      filePath = _.strRemoveEnd( filePath, '/**' )

    return filePath;
  }

  /* */

  function regexpsMapFor( stemPath, group )
  {

    let basePath = o.unglobedBasePath[ stemPath ];
    let r = Object.create( null );
    r.certainlyHash = new HashMap;
    r.transient = [];
    r.actualAny = [];
    r.actualAny2 = [];
    r.actualAll = [];
    r.actualNone = [];

    _.assert( _.strDefined( basePath ), 'No base path for', stemPath );

    let logicPathArray = [];
    let shortPathArray = [];
    for( let fileGlob0 in group )
    {
      let fileGlob = fileGlob0;
      let value = group[ fileGlob ];

      fileGlob = self.globNormalize( fileGlob );
      fileGlob = self._globAnalogs1( fileGlob );
      _.assert( _.strIs( fileGlob ) );

      if( !self.isGlob( fileGlob ) )
      fileGlob = self.join( fileGlob, '**' );

      if( fileGlob0 !== fileGlob )
      {
        delete group[ fileGlob0 ];
        group[ fileGlob ] = value;
      }

      let shortGlob = self.fromGlob( fileGlob );

      if( _.boolLike( value ) )
      logicPathArray.push( shortGlob );
      else
      shortPathArray.push( [ shortGlob, fileGlob ] );

    }

    shortPathArray.sort( ( a, b ) =>
    {
      if( a[ 0 ] === b[ 0 ] )
      return 0;
      else if( a[ 0 ] < b[ 0 ] )
        return -1;
      else if( a[ 0 ] > b[ 0 ] )
        return +1;
    } );

    for( let s1 = 0 ; s1 < shortPathArray.length ; s1++ )
    {
      let short1Path = shortPathArray[ s1 ][ 0 ];
      let full1Path = shortPathArray[ s1 ][ 1 ];
      for( let s2 = s1+1 ; s2 < shortPathArray.length ; s2++ )
      {
        let short2Path = shortPathArray[ s2 ][ 0 ];
        let full2Path = shortPathArray[ s2 ][ 1 ];
        if( !self.begins( short2Path, short1Path ) )
        break;
        if( !self.globHas( full1Path, full2Path ) )
        continue;
        _.assert( group[ full2Path ] !== undefined );
        delete group[ full2Path ];
        shortPathArray.splice( s2, 1 );
        s2 -= 1;
      }
    }

    if( shortPathArray.length === 1 && shortPathArray[ 0 ][ 0 ] === stemPath )
    if( !self.isGlob( globRemoveLastTotal( shortPathArray[ 0 ][ 1 ] ) ) )
    {
      let shortPath = shortPathArray[ 0 ][ 0 ];
      let fullPath = shortPathArray[ 0 ][ 1 ];
      delete group[ fullPath ];
      shortPathArray.splice( 0, 1 );
    }

    for( let fileGlob in group )
    {
      let value = group[ fileGlob ];

      _.assert( self.isGlob( fileGlob ) );

      // let isPositive = !( ( _.boolLike( value ) && !value ) );
      // let regexps = regexpsFor( fileGlob, stemPath, basePath, isPositive );
      let regexps = regexpsFor( fileGlob, stemPath, basePath );

      if( regexps.certainly )
      r.certainlyHash.set( regexps.actual, regexps.certainly )

      if( value || value === null || value === '' )
      {
        if( _.boolLike( value ) )
        {
          r.actualAll.push( regexps.actual );
        }
        else
        {
          r.actualAny.push( regexps.actual );
        }
        r.transient.push( regexps.transient )
      }
      else
      {
        r.actualNone.push( regexps.actual );
      }

    }

    return r;
  }

  /* */

  function regexpsFor( fileGlob, stemPath, basePath )
  {
    let hash = fileGlob + '\0' + stemPath + '\0' + basePath;
    let result = regexps[ hash ];
    if( !result )
    result = regexps[ hash ] = self._globFullToRegexpSingle( fileGlob, stemPath, basePath );
    return result;
  }

  /* */

  // function unglobedBasePathAdd( unglobedBasePath, fileGlob, filePath, basePath )
  function unglobedBasePathAdd( op )
  {
    _.assert( _.strIs( op.fileGlob ) );
    _.assert( op.filePath === undefined || _.strIs( op.filePath ) );
    _.assert( _.strIs( op.basePath ) );
    _.assert( o.filePath[ op.fileGlob ] !== undefined, () => 'No file path for file glob ' + g );

    if( _.boolLike( o.filePath[ op.fileGlob ] ) )
    return;

    if( !op.filePath )
    op.filePath = self.fromGlob( op.fileGlob );

    _.assert
    (
      op.unglobedBasePath[ op.filePath ] === undefined || op.unglobedBasePath[ op.filePath ] === op.basePath,
      () => 'The same file path ' + _.strQuote( op.filePath ) + ' has several different base paths:'
      + '\n - ' + _.strQuote( op.unglobedBasePath[ op.filePath ] ),
      '\n - ' + _.strQuote( op.basePath )
    );

    op.unglobedBasePath[ op.filePath ] = op.basePath;
  }

  /* */

  function fileUnglob()
  {
    o.fileGlobToPathMap = Object.create( null );
    o.filePathToGlobMap = Object.create( null );
    o.unglobedFilePath = Object.create( null );
    for( let srcGlob in o.filePath )
    {
      let dstPath = o.filePath[ srcGlob ];

      if( dstPath === null )
      dstPath = '';

      _.assert( self.isAbsolute( srcGlob ), () => 'Expects absolute path, but ' + _.strQuote( srcGlob ) + ' is not' );

      let srcPath = self.fromGlob( srcGlob );

      o.fileGlobToPathMap[ srcGlob ] = srcPath;
      o.filePathToGlobMap[ srcPath ] = o.filePathToGlobMap[ srcPath ] || [];
      o.filePathToGlobMap[ srcPath ].push( srcGlob );
      let wasUnglobedFilePath = o.unglobedFilePath[ srcPath ];
      if( wasUnglobedFilePath === undefined || _.boolLike( wasUnglobedFilePath ) )
      if( !_.boolLike( dstPath ) )
      {
        _.assert( wasUnglobedFilePath === undefined || _.boolLike( wasUnglobedFilePath ) || wasUnglobedFilePath === dstPath );
        o.unglobedFilePath[ srcPath ] = dstPath;
      }

    }

  }

  /* */

  function baseUnglob()
  {

    let unglobedBasePath = Object.create( null );
    for( let fileGlob in o.basePath )
    {
      _.assert( self.isAbsolute( fileGlob ) );
      _.assert( !self.isGlob( o.basePath[ fileGlob ] ) );

      let filePath;
      let basePath = o.basePath[ fileGlob ];
      if( o.filePath[ fileGlob ] === undefined )
      {
        filePath = fileGlob;
        fileGlob = o.filePathToGlobMap[ filePath ];
      }

      if( _.arrayIs( filePath ) )
      filePath.forEach( ( filePath ) => unglobedBasePathAdd({ unglobedBasePath, fileGlob, filePath, basePath }) );
      else
      unglobedBasePathAdd({ unglobedBasePath, fileGlob, filePath, basePath })
    }

    return unglobedBasePath;
  }

  /* */

  function groupBySrc( optimal )
  {

    let groupsMap = Object.create( null );
    let redundantArray = o.redundantArray = Object.keys( o.filePath );
    redundantArray.sort();

    /*
    sorted, so paths with the same base are neighbours now
    */

    for( let f = 0 ; f < redundantArray.length ; f++ )
    {
      let fileGlob = redundantArray[ f ];
      let value = o.filePath[ fileGlob ];
      let filePath = o.fileGlobToPathMap[ fileGlob ];
      let group = { [ fileGlob ] : value };

      if( _.boolLike( value ) )
      continue;

      redundantArray.splice( f, 1 );
      f -= 1;

      for( let f2 = f+1 ; f2 < redundantArray.length ; f2++ )
      {
        let fileGlob2 = redundantArray[ f2 ];
        let value2 = o.filePath[ fileGlob2 ];
        let filePath2 = o.fileGlobToPathMap[ fileGlob2 ];
        let begin;

        if( _.boolLike( value2 ) )
        continue;

        _.assert( fileGlob !== fileGlob2 );

        if( self.begins( filePath2, filePath ) )
        begin = filePath;

        /* skip if different group */
        if( !begin )
        break;

        if( _.boolLike( value2 ) )
        {
          group[ fileGlob2 ] = value2;
        }
        else
        {
          if( filePath === filePath2 )
          {
            group[ fileGlob2 ] = value2;
            redundantArray.splice( f2, 1 );
            f2 -= 1;
          }
          else
          {
            if( optimal )
            if( o.basePath[ fileGlob2 ] === o.basePath[ fileGlob ] )
            {
              group[ fileGlob2 ] = value2;
              redundantArray.splice( f2, 1 );
              f2 -= 1;
              delete o.optimizedUnglobedFilePath[ filePath2 ];
              delete o.optimizedUnglobedBasePath[ filePath2 ];
            }
          }
        }

      }

      let commonPath = filePath;

      /* */

      if( optimal )
      for( let fileGlob2 in group )
      {
        let value2 = o.filePath[ fileGlob2 ];

        if( _.boolLike( value2 ) )
        continue;

        let filePath2 = o.fileGlobToPathMap[ fileGlob2 ];
        if( filePath2.length < commonPath.length )
        {
          _.assert( 0 );
          commonPath = filePath2;
        }

      }

      /* */

      for( let f2 = f ; f2 >= 0 ; f2-- )
      {
        let fileGlob2 = redundantArray[ f2 ];
        let value2 = o.filePath[ fileGlob2 ];
        let filePath2 = o.fileGlobToPathMap[ fileGlob2 ];
        let begin;

        if( !_.boolLike( value2 ) )
        continue;

        _.assert( fileGlob !== fileGlob2 );

        if( self.begins( filePath, filePath2 ) )
        begin = filePath;

        /* skip if different group */
        if( !begin )
        continue;

        group[ fileGlob2 ] = value2;
      }

      /* */

      for( let f2 = f+1 ; f2 < redundantArray.length ; f2++ )
      {
        let fileGlob2 = redundantArray[ f2 ];
        let value2 = o.filePath[ fileGlob2 ];
        let filePath2 = o.fileGlobToPathMap[ fileGlob2 ];
        let begin;

        if( !_.boolLike( value2 ) )
        continue;

        _.assert( fileGlob !== fileGlob2 );

        if( self.begins( filePath2, filePath ) )
        begin = filePath;

        /* skip if different group */
        if( !begin )
        break;

        group[ fileGlob2 ] = value2;
      }

      _.assert( groupsMap[ commonPath ] === undefined );
      groupsMap[ commonPath ] = group;

    }

    return groupsMap;
  }

}

pathMapToRegexps.defaults =
{
  filePath : null,
  basePath : null,
}

// --
// extension
// --

let Extension =
{

  // simple transformer

  _fromGlob,
  fromGlob : _vectorize( _fromGlob ),
  globNormalize,
  _globShortSplitToRegexpSource,

  // short filter

  globShortSplitToRegexp,
  globShortSplitsToRegexps : _vectorize( globShortSplitToRegexp ),
  globShortFilter,
  globShortFilterVals,
  globShortFilterKeys,
  globShortFit,

  // long filter

  _globLongSplitsToRegexps,
  globLongFilter,
  globLongFilterVals,
  globLongFilterKeys,
  globLongFit,

  // full filter

  _globAnalogs1,
  _globAnalogs2,
  globHas,

  _globRegexpSourceSplitsConcatWithSlashes,
  _globRegexpSourceSplitsJoinForTerminal,
  _globRegexpSourceSplitsJoinForDirectory,
  _globFullToRegexpSingle,
  _globsFullToRegexps : _vectorize( _globFullToRegexpSingle, 3 ),

  globsFullToRegexps,
  pathMapToRegexps,

}

_.props.supplement( Self, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();

( function _Uri_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to operate URIs ( URLs ) in the reliable and consistent way. Path leverages parsing, joining, extracting, normalizing, nativizing, resolving paths. Use the module to get uniform experience from playing with paths on different platforms.
  @module Tools/base/Uri
*/

/**
 * Collection of cross-platform routines to operate URIs ( URLs ) in the reliable and consistent way.
  @namespace wTools.uri
  @extends Tools
  @module Tools/base/Uri
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wStringer' );
  _.include( 'wPathBasic' );
  _.include( 'wBlueprint' );

}

//

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.path;
const Self = _.uriNew = _.uriNew || Object.create( Parent );
_.uri = _.uriNew;

// --
// relation
// --

let Uri = _.Blueprint
({
  typed : _.trait.typed(),
  extendable : _.trait.extendable(), /* qqq xxx : is it required? */
  protocol : null,
  query : null,
  hash : null,
  tag : null,
});

//

let UriFull = _.Blueprint
({
  extension : _.define.extension( Uri ),

  protocols : null,
  postfixedPath : null,
  resourcePath : null,
  longPath : null,
  full : null,

  hostFull : null,
  host : null,
  port : null,
  user : null,
  origin : null,

});

//

let UriAtomic = _.Blueprint
({
  extension : _.define.extension( Uri ),

  // resourcePath : null,
  // host : null,
});

//

let UriConsequtive = _.Blueprint
({
  extension : _.define.extension( Uri ),

  longPath : null,
});

/* qqq jsdoc structures Uri*. ask how to */

/**
 *
 * The URI component object.
 * @typedef {Object} UrlComponents
 * @property {string} protocol the URI's protocol scheme.;
 * @property {string} host host portion of the URI;
 * @property {string} port property is the numeric port portion of the URI
 * @property {string} resourcePath the entire path section of the URI.
 * @property {string} query the entire "query string" portion of the URI, not including '?' character.
 * @property {string} hash property consists of the "fragment identifier" portion of the URI.

 * @property {string} uri the whole URI
 * @property {string} hostFull host portion of the URI, including the port if specified.
 * @property {string} origin protocol + host + port
 * @private
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

// let UriComponents =
// {
//
//   /* atomic */
//
//   protocol : null, /* 'svn+http' */
//   host : null, /* 'www.site.com' */
//   port : null, /* '13' */
//   resourcePath : null, /* '/path/name' */
//   query : null, /* 'query=here&and=here' */
//   hash : null, /* 'anchor' */
//   tag : null, /* tag */
//
//   /* composite */
//
//   // qqq !!! : implement queries
//   // queries : null, /* { query : here, and : here } */
//   longPath : null, /* www.site.com:13/path/name */
//   postfixedPath : null, /* www.site.com:13/path/name?query=here#anchor@tag */
//   protocols : null, /* [ 'svn','http' ] */
//   hostFull : null, /* 'www.site.com:13' */
//   origin : null, /* 'svn+http://www.site.com:13' */
//   full : null, /* 'svn+http://www.site.com:13/path/name?query=here&and=here#anchor' */
//
// }

// --
// internal
// --

function _filterOnlyUrl( e, k, c )
{
  if( _.strIs( k ) )
  {
    if( _.strEnds( k, 'Url' ) )
    return true;
    else
    return false
  }
  return this.is( e );
}

//

function _filterNoInnerArray( arr )
{
  return arr.every( ( e ) => !_.arrayIs( e ) );
}

// --
// dichotomy
// --

// '^(https?:\\/\\/)?'                                     // protocol
// + '(\\/)?'                                              // relative
// + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'    // domain
// + '((\\d{1,3}\\.){3}\\d{1,3}))'                         // ip
// + '(\\:\\d+)?'                                          // port
// + '(\\/[-a-z\\d%_.~+]*)*'                               // path
// + '(\\?[;&a-z\\d%_.~+=-]*)?'                            // query
// + '(\\#[-a-z\\d_]*)?$';                                 // anchor

let isRegExpString =
  '^([\w\d]*:\\/\\/)?'                                    // protocol
  + '(\\/)?'                                              // relative
  + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'    // domain
  + '((\\d{1,3}\\.){3}\\d{1,3}))'                         // ip
  + '(\\:\\d+)?'                                          // port
  + '(\\/[-a-z\\d%_.~+]*)*'                               // path
  + '(\\?[;&a-z\\d%_.~+=-]*)?'                            // query
  + '(\\#[-a-z\\d_]*)?$';                                 // anchor

let isRegExp = new RegExp( isRegExpString, 'i' );
function is( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.strIs( path );
}

//

/**
 * @summary Checks if provided uri is safe.
 * @param {String} filePath Source uri
 * @param {Number} level Level of check
 *
 * @example
 * _.uriNew.isSafe( 'https:///web.archive.org' )// false
 *
 * @example
 * _.uriNew.isSafe( 'https:///web.archive.org/root' )// true
 *
 * @returns {Boolean} Returns result of check for safetiness.
 * @function isSafe
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function isSafe( path, level )
{
  let parent = this.path;

  _.assert( arguments.length === 1 || arguments.length === 2, 'Expects single argument' );
  _.assert( _.strDefined( path ) );

  if( this.isGlobal( path ) )
  path = this.parseConsecutive( path ).longPath;

  return parent.isSafe.call( this, path, level );
}

/*
qqq : module:Tools? | Dmytro : changed similar to module wPathBasic
*/

//

/**
 * @summary Checks if provided uri is refined.
 * @param {String} filePath Source uri
 *
 * @returns {Boolean} Returns true if {filePath} is refined, otherwise false.
 * @function isRefined
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function isRefined( filePath )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), () => 'Expects string {-filePath-}, but got ' + _.entity.strType( filePath ) );

  if( this.isGlobal( filePath ) )
  filePath = this.parseConsecutive( filePath ).longPath;

  return parent.isRefined.call( this, filePath );
}

// //
//
// /**
//  * @summary Checks if provided uri is refined.
//  * @param {String} filePath Source uri
//  *
//  * @returns {Boolean} Returns true if {filePath} is refined, otherwise false.
//  * @function isRefined
//  * @module Tools/UriBasic
// * @namespace Tools.uri
//  */
//
// function isRefined( filePath )
// {
//   let parent = this.path;
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.strIs( filePath ), () => 'Expects string {-filePath-}, but got ' + _.entity.strType( filePath ) );
//
//   if( this.isGlobal( filePath ) )
//   filePath = this.parseConsecutive( filePath ).longPath;
//
//   return parent.isRefined.call( this, filePath );
// }

//

/**
 * @summary Checks if provided uri is normalized.
 * @param {String} filePath Source uri
 *
 * @returns {Boolean} Returns true if {filePath} is normalized, otherwise false.
 * @function isNormalized
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function isNormalized( filePath )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), () => 'Expects string {-filePath-}, but got ' + _.entity.strType( filePath ) );

  if( this.isGlobal( filePath ) )
  filePath = this.parseConsecutive( filePath ).longPath;

  return parent.isNormalized.call( this, filePath );
}

// //
//
// /**
//  * @summary Checks if provided uri is normalized.
//  * @param {String} filePath Source uri
//  *
//  * @example
//  * _.uriNew.isNormalized( 'https:///web.archive.org' ); // returns true
//  *
//  * @example
//  * _.uriNew.isNormalized( 'https:/\\\\web.archive.org' ); // returns false
//  *
//  * @returns {Boolean} Returns true if {filePath} is normalized, otherwise false.
//  * @function isNormalized
//  * @module Tools/UriBasic
// * @namespace Tools.uri
//  */
//
// function isNormalized( path )
// {
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.strIs( path ), 'Expects string' );
//   return this.normalize( path ) === path;
// }

//

/**
 * @summary Checks if provided uri is absolute.
 * @param {String} filePath Source uri
 *
 * @example
 * _.uriNew.isAbsolute( 'https:/web.archive.org' )// false
 *
 * @example
 * _.uriNew.isAbsolute( 'https:///web.archive.org' )// true
 *
 * @returns {Boolean} Returns true if {filePath} is absolute, otherwise false.
 * @function isAbsolute
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function isAbsolute( path )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), () => 'Expects string {-path-}, but got ' + _.entity.strType( path ) );

  if( this.isGlobal( path ) )
  path = this.parseConsecutive( path ).longPath;

  return parent.isAbsolute.call( this, path );
}

//

/**
 * @summary Checks if provided uri is relative.
 * @param {String} filePath Source uri
 *
 * @returns {Boolean} Returns true if {filePath} is relative, otherwise false.
 * @function isRelative
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function isRelative( filePath )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), () => 'Expects string {-filePath-}, but got ' + _.entity.strType( filePath ) );

  if( this.isGlobal( filePath ) )
  filePath = this.parseConsecutive( filePath ).longPath;

  return parent.isRelative.call( this, filePath );
}

//

/**
 * @summary Checks if provided uri is root.
 * @param {String} filePath Source uri
 *
 * @example
 * _.uriNew.isRoot( 'https:/web.archive.org' )// false
 *
 * @example
 * _.uriNew.isRoot( 'https:///' )// true
 *
 * @returns {Boolean} Returns true if {filePath} is root, otherwise false.
 * @function isRoot
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function isRoot( filePath )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( this.isGlobal( filePath ) )
  filePath = this.parseConsecutive( filePath ).longPath;

  return parent.isRoot.call( this, filePath );
}

//

/**
 * @summary Checks if provided uri begins with dot.
 * @param {String} filePath Source uri
 *
 * @returns {Boolean} Returns true if path begins with dot, otherwise false.
 * @function isDotted
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function isDotted( filePath )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), () => 'Expects string {-filePath-}, but got ' + _.entity.strType( filePath ) );

  if( this.isGlobal( filePath ) )
  filePath = this.parseConsecutive( filePath ).longPath;

  return parent.isDotted.call( this, filePath );
}

//

/**
 * @summary Checks if provided uri ends with slash.
 * @param {String} filePath Source uri
 *
 * @returns {Boolean} Returns true if path ends with slash, otherwise false.
 * @function isTrailed
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function isTrailed( filePath )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), () => 'Expects string {-filePath-}, but got ' + _.entity.strType( filePath ) );

  if( this.isGlobal( filePath ) )
  filePath = this.parseConsecutive( filePath ).longPath;

  return parent.isTrailed.call( this, filePath );
}

//

/**
 * @summary Checks if provided uri is glob.
 * @param {String} filePath Source uri
 *
 * @returns {Boolean} Returns true if {filePath} is glob, otherwise false.
 * @function isGlob
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function isGlob( filePath )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), () => 'Expects string {-filePath-}, but got ' + _.entity.strType( filePath ) );

  if( this.isGlobal( filePath ) )
  filePath = this.parseConsecutive( filePath ).longPath;

  return parent.isGlob.call( this, filePath );
}

// --
// transformer
// --

function _parseOrigin( map, originPath )
{
  let self = this;

  let isolates = _.strIsolateLeftOrNone.body
  ({
    src : originPath,
    delimeter : self.protocolToken,
    times : 1,
    quote : false,
  });

  map.portocol = isolates[ 0 ];
  map.hostFull = isolates[ 2 ];

  self._parseHostFull( map, map.hostFull );
}

//

function _parseLongPath( map, longPath )
{
  let self = this;
  let isAbsolute = false;

  if( !longPath )
  return;

  if( _.strBegins( longPath[ 0 ], self.rootToken ) )
  {
    longPath = longPath.slice( self.rootToken.length );
    isAbsolute = true;
  }

  let isolates = _.strIsolateLeftOrAll.body
  ({
    src : longPath,
    delimeter : self.upToken,
    times : 1,
    quote : false,
  });

  map.hostFull = isolates[ 0 ];
  if( isolates[ 1 ] )
  map.resourcePath = isolates[ 2 ];

  if( isAbsolute )
  map.hostFull = self.rootToken + map.hostFull;

  self._parseHostFull( map, map.hostFull );

}

//

function _parseHostFull( map, hostFull )
{
  let self = this;
  let isAbsolute = false;

  // if( !hostFull )
  // return;

  if( _.strBegins( hostFull, self.rootToken ) )
  isAbsolute = true;

  let isolates2 = _.strIsolateRightOrNone.body
  ({
    src : hostFull,
    delimeter : self.portToken,
    times : 1,
    quote : false,
  });
  map.host = isolates2[ 0 ];

  if( isolates2[ 1 ] )
  map.port = _.numberFromStrMaybe( isolates2[ 2 ] );

  let isolates3 = _.strIsolateLeftOrNone.body
  ({
    src : map.host,
    delimeter : self.userToken,
    times : 1,
    quote : false,
  });

  if( isAbsolute && isolates3[ 1 ] )
  {
    isolates3[ 0 ] = isolates3[ 0 ].slice( self.rootToken.length );
    isolates3[ 2 ] = self.rootToken + isolates3[ 2 ];
  }

  if( isolates3[ 1 ] )
  map.user = isolates3[ 0 ];
  map.host = isolates3[ 2 ];

}

//

/*
http://www.site.com:13/path/name?query=here&and=here#anchor
2 - protocol
3 - hostFull( host + port )
5 - resourcePath
6 - query
8 - hash
*/

/*{
  'protocol' : 'complex+protocol',
  'host' : 'www.site.com',
  'port' : '13',
  'query' : 'query=here&and=here',
  'hash' : 'anchor',
  'resourcePath' : '/!a.js?',
  'longPath' : 'www.site.com:13/!a.js?',
}*/

function parse_head( routine, args )
{
  _.assert( args.length === 1, 'Expects single argument' );

  let o = { srcPath : args[ 0 ] };

  _.routine.options_( routine, o );
  _.assert( _.strIs( o.srcPath ) || _.mapIs( o.srcPath ) );
  _.assert( _.longHas( routine.Kind, o.kind ), () => 'Unknown kind of parsing ' + o.kind );

  return o;
}

function parse_body( o )
{
  let self = this;
  let result = Object.create( null );

  if( _.mapIs( o.srcPath ) )
  {
    _.map.assertHasOnly( o.srcPath, this.UriFull.propsExtension );
    if( o.srcPath.protocols )
    return o.srcPath;
    else if( o.srcPath.full )
    o.srcPath = o.srcPath.full;
    else
    o.srcPath = this.str( o.srcPath );
  }

  let postfixes = '';

  longPathParse();

  let delimeter = [ self.tagToken, self.hashToken, self.queryToken ];
  if( _.strHasAny( result.longPath, delimeter ) )
  postfixesParse( delimeter );

  /* */

  if( o.kind === 'full' )
  {

    result.postfixedPath = result.longPath + postfixes;

    self._parseLongPath( result, result.longPath );

    if( result.protocol )
    result.protocols = result.protocol.split( '+' );
    else
    result.protocols = [];

    if( _.strIs( result.protocol ) )
    result.origin = result.protocol + self.protocolToken + result.hostFull;

    result.full = o.srcPath;

  }
  else if( o.kind === 'consecutive' )
  {
  }
  else if( o.kind === 'atomic' )
  {
    self._parseLongPath( result, result.longPath );
    delete result.hostFull;
    delete result.longPath;
  }
  else _.assert( 0 );

  return result;

  /* */

  function longPathParse()
  {

    let isolates = _.strIsolateLeftOrNone.body
    ({
      src : o.srcPath,
      delimeter : self.protocolToken,
      times : 1,
      quote : false,
    });

    if( isolates[ 1 ] )
    result.protocol = isolates[ 0 ];

    result.longPath = isolates[ 2 ];
  }

  /* */

  function postfixesParse( delimeter )
  {

    let rest = '';
    let splits2 = _.path.split( result.longPath );
    let left, s;

    for( s = 0 ; s < splits2.length ; s++ )
    {
      let split = splits2[ s ];
      if( _.path._unescape( split ).wasEscaped )
      continue;
      left = _.strLeft_( split, delimeter );
      if( left.entry )
      {
        if( s > 0 )
        {
          result.longPath = splits2.slice( 0, s ).join( self.upToken );
          result.longPath += self.upToken + split.slice( 0, left.index );
        }
        else
        {
          result.longPath = split.slice( 0, left.index );
        }
        split = split.slice( left.index + 1 );
        splits2[ s ] = split
        rest = splits2.slice( s ).join( self.upToken );
        break;
      }
    }

    if( left && left.entry )
    restParse( rest, left.entry, delimeter );

  }

  /* */

  function restParse( rest, entry, delimeter )
  {

    _.arrayRemoveOnceStrictly( delimeter, entry );

    let isolates = _.strIsolateLeftOrAll( rest, delimeter );

    if( entry === self.queryToken )
    result.query = isolates[ 0 ];
    else if( entry === self.hashToken )
    result.hash = isolates[ 0 ];
    else if( entry === self.tagToken )
    result.tag = isolates[ 0 ];

    postfixes += entry + isolates[ 0 ];

    // rest = isolates[ 2 ]; /* xxx : remove variable? */
    if( isolates[ 1 ] )
    {
      restParse( isolates[ 2 ], isolates[ 1 ], delimeter );
    }

  }

  /* */

}

parse_body.defaults =
{
  srcPath : null,
  kind : 'full',
}

parse_body.components = UriFull.propsExtension;

parse_body.Kind = [ 'full', 'atomic', 'consecutive' ];

//

/**
 * Method parses URI string, and returns a UrlComponents object.
 * @example
 *
   let uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor'

   wTools.uri.parse( uri );

   // {
   //   protocol : 'http',
   //   hostFull : 'www.site.com:13',
   //   resourcePath : /path/name,
   //   query : 'query=here&and=here',
   //   hash : 'anchor',
   //   host : 'www.site.com',
   //   port : '13',
   //   origin : 'http://www.site.com:13'
   // }

 * @param {string} path Url to parse
 * @param {Object} o - parse parameters
    included into result
 * @returns {UrlComponents} Result object with parsed uri components
 * @throws {Error} If passed `path` parameter is not string
 * @function parse
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

let parse = _.routine.uniteCloning_replaceByUnite( parse_head, parse_body );

parse.components = UriFull.propsExtension;

//

let parseFull = _.routine.uniteCloning_replaceByUnite( parse_head, parse_body );
parseFull.defaults.kind = 'full';
parseFull.components = UriFull.propsExtension;

//

let parseAtomic = _.routine.uniteCloning_replaceByUnite( parse_head, parse_body );
parseAtomic.defaults.kind = 'atomic';

parseAtomic.components = UriAtomic.propsExtension;

//

let parseConsecutive = _.routine.uniteCloning_replaceByUnite( parse_head, parse_body );
parseConsecutive.defaults.kind = 'consecutive';

//

function localFromGlobal( globalPath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.boolLike( globalPath ) )
  return globalPath;

  if( _.strIs( globalPath ) )
  {
    if( !this.isGlobal( globalPath ) )
    return globalPath;

    globalPath = this.parseConsecutive( globalPath );
  }

  _.assert( _.mapIs( globalPath ) ) ;
  _.assert( _.strIs( globalPath.longPath ) );

  return globalPath.longPath;
}

//

/**
 * Routine str() assembles URI string from components.
 *
 * @example
 * let components =
 * {
 *   protocol : 'http',
 *   host : 'www.site.com',
 *   port : '13',
 *   resourcePath : '/path/name',
 *   query : 'query=here&and=here',
 *   hash : 'anchor',
 * };
 * _.uri.str( UrlComponents );
 * // returns : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
 *
 * @param { Map|Aux|String } map - Map with URI components.
 * @returns { String } - Returns complete URI string.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-map-} has incompatible type.
 * @see { @link UrlComponents }
 * @function str
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function str( map )
{
  let self = this;
  let result = '';

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.strIs( map ) )
  return map;

  if( Config.debug )
  {
    _.assert
    (
      map.longPath === undefined || map.longPath === null || longPathHas( map ),
      'Codependent components of URI map are not consistent', 'something wrong with {-longPath-}'
    );
    _.assert
    (
      map.protocols === undefined || map.protocols === null || protocolsHas( map ),
      'Codependent components of URI map are not consistent', 'something wrong with {-protocols-}'
    );
    _.assert
    (
      map.hostFull === undefined || map.hostFull === null || hostFullHas( map ),
      'Codependent components of URI map are not consistent', 'something wrong with {-hostFull-}'
    );
    _.assert
    (
      map.origin === undefined || map.origin === null || originHas( map ),
      'Codependent components of URI map are not consistent', 'something wrong with {-origin-}'
    );
    _.assert
    (
      map.full === undefined || map.full === null || fullHas( map ),
      'Codependent components of URI map are not consistent', 'something wrong with {-full-}'
    );
    _.assert( _.strIs( map ) || _.mapIs( map ) );
  }

  _.map.assertHasOnly( map, this.UriFull.propsExtension );

  /* */

  if( map.full )
  {
    _.assert( _.strDefined( map.full ) );
    return map.full;
  }

  map = _.props.extend( null, map );

  if( map.origin && ( map.protocol === null || map.protocol === undefined ) )
  if( _.strHas( map.origin, self.protocolToken ) )
  {
    map.protocol = _.strIsolateLeftOrNone( map.origin, self.protocolToken )[ 0 ];
  }

  if( ( map.protocol === null || map.protocol === undefined ) && map.protocols && map.protocols.length )
  map.protocol = map.protocols.join( '+' );

  if( map.origin )
  if
  (
    ( map.user === null || map.user === undefined )
    || ( map.host === null || map.host === undefined )
    || ( map.port === null || map.port === undefined )
  )
  componentsFromOrigin( map );

  if( map.longPath === undefined )
  map.longPath = longPathFrom( map );

  return fullFrom( map );

  /* */

  return result;

  /* */

  function componentsFromOrigin( map )
  {
    self._parseOrigin( map, map.origin );
  }

  /* */

  function longPathFrom( map )
  {
    let hostFull = map.hostFull;

    if( _.strIs( map.resourcePath ) )
    {
      if( !_.strIs( hostFull ) )
      hostFull = hostFullFrom( map );
      if( hostFull === undefined )
      return map.resourcePath;
      else
      return hostFull + self.upToken + map.resourcePath;
    }
    else if( map.longPath === undefined )
    {
      if( !_.strIs( hostFull ) )
      hostFull = hostFullFrom( map );
      return hostFull || '';
    }
    else
    {
      if( Config.debug )
      {
        if( !_.strIs( hostFull ) )
        hostFull = hostFullFrom( map );
        if( hostFull )
        _.assert( _.strBegins( map.longPath, hostFull ) );
      }
      return map.longPath;
    }

  }

  /* */

  function longPathHas( map )
  {

    if( map.host )
    if( !_.strHas( map.longPath, _.strRemoveBegin( map.host, self.rootToken ) ) )
    return false;

    if( map.user )
    if( !_.strHas( map.longPath, map.user + self.userToken ) )
    return false;

    if( map.port !== undefined && map.port !== null )
    if( !_.strHas( map.longPath, String( map.port ) ) )
    return false;

    if( map.resourcePath )
    if( !_.strEnds( map.longPath, map.resourcePath ) )
    return false;

    return true;
  }

  /* */

  function protocolsFrom( map )
  {
    return map.protocol.split( '+' );
  }

  /* */

  function protocolsHas( map )
  {
    if( map.protocol !== null && map.protocol !== undefined )
    if( map.protocols.join( '+' ) !== map.protocol )
    return false;
    return true;
  }

  /* */

  function hostFullFrom( map )
  {
    let hostFull = '';
    let host = map.host || '';

    if( map.host === undefined && map.user === undefined && map.port === undefined )
    {
      return;
    }

    if( _.strIs( map.user ) )
    {
      let prefix = '';
      if( _.strBegins( host, self.rootToken ) )
      {
        prefix = self.rootToken;
        host = host.slice( self.rootToken.length );
      }
      hostFull = prefix + map.user + self.userToken + host;
    }
    else
    {
      hostFull = host;
    }

    if( map.port !== undefined && map.port !== null )
    if( hostFull )
    hostFull += self.portToken + map.port;
    else
    hostFull = self.portToken + map.port;

    return hostFull;
  }

  /* */

  function hostFullHas( map )
  {

    if( map.host )
    if( !_.strHas( map.hostFull, _.strRemoveBegin( map.host, self.rootToken ) ) )
    return false;

    if( map.user )
    if( !_.strHas( map.hostFull, map.user + self.userToken ) )
    return false;

    if( map.port !== null && map.port !== undefined )
    if( !_.strHas( map.hostFull, String( map.port ) ) )
    return false;

    return true;
  }

  /* */

  function originFrom( map )
  {
    let result = '';
    let hostFull;

    if( map.hostFull )
    {
      hostFull = map.hostFull;
    }
    else
    {
      hostFull = hostFullFrom( map );
    }

    if( _.strIs( map.protocol ) && !hostFull )
    hostFull = '';

    if( _.strIs( map.protocol ) || _.strIs( hostFull ) )
    result += ( map.protocol || '' ) + self.protocolToken + ( hostFull || '' );

    return result;
  }

  /* */

  function originHas( map )
  {

    if( map.protocol )
    if( !_.strBegins( map.origin, map.protocol ) )
    return false;

    if( map.host )
    if( !_.strHas( map.origin, _.strRemoveBegin( map.host, self.rootToken ) ) )
    return false;

    if( map.port !== null && map.port !== undefined )
    if( !_.strHas( map.origin, String( map.port ) ) )
    return false;

    return true;
  }

  /* */

  function fullFrom( map )
  {
    _.assert( _.strIs( map.longPath ) );

    if( _.strIs( map.protocol ) )
    result += ( map.protocol || '' ) + self.protocolToken;

    result += map.longPath;

    /**/

    if( _.mapIs( map.query ) )
    map.query = _.strWebQueryStr({ src : map.query });

    _.assert( !map.query || _.strIs( map.query ) );

    if( map.query !== undefined && map.query !== undefined )
    result += self.queryToken + map.query;

    if( map.hash !== undefined && map.hash !== null )
    result += self.hashToken + map.hash;

    if( map.tag !== undefined && map.tag !== null )
    result += self.tagToken + map.tag;

    return result;
  }

  /* */

  function fullHas( map )
  {
    if( map.protocol )
    if( !_.strBegins( map.full, map.protocol ) )
    return false;

    if( map.host )
    if( !_.strHas( map.full, _.strRemoveBegin( map.host, self.rootToken ) ) )
    return false;

    if( map.port !== null && map.port !== undefined )
    if( !_.strHas( map.full, String( map.port ) ) )
    return false;

    if( map.resourcePath )
    if( !_.strHas( map.full, map.resourcePath ) )
    return false;

    if( map.query )
    if( !_.strHas( map.full, map.query ) )
    return false;

    if( map.hash )
    if( !_.strHas( map.full, map.hash ) )
    return false;

    if( map.tag )
    if( !_.strHas( map.full, map.tag ) )
    return false;

    if( map.longPath )
    if( !_.strHas( map.full, map.longPath ) )
    return false;

    return true;
  }

}

str.components = UriFull.propsExtension;

//

/**
 * Complements current window uri origin by components passed in o.
 * All components of current origin is replaced by appropriates components from o if they exist.
 * If { o.full } exists and valid, method returns it.
 * @example
 * // current uri http://www.site.com:13/foo/baz
   let components =
   {
     resourcePath : '/path/name',
     query : 'query=here&and=here',
     hash : 'anchor',
   };
   let res = wTools.uri.full( o );
   // 'http://www.site.com:13/path/name?query=here&and=here#anchor'
 *
 * @returns {string} composed uri
 * @function full
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function full( o )
{

  _.assert( arguments.length === 1 );
  _.assert( this.is( o ) || _.mapIs( o ) );

  if( _.strIs( o ) )
  o = this.parseAtomic( o )

  _.map.assertHasOnly( o, this.UriFull.propsExtension );

  if( !_realGlobal_.location )
  return this.str( o );

  let serverUri = this.server();
  let serverParsed = this.parseAtomic( serverUri );

  _.props.extend( serverParsed, o );

  return this.str( serverParsed );
}

//

function refine( filePath )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ) );

  if( this.isGlobal( filePath ) )
  filePath = this.parseConsecutive( filePath );
  else
  return parent.refine.call( this, filePath );

  if( _.strDefined( filePath.longPath ) )
  filePath.longPath = parent.refine.call( this, filePath.longPath );

  if( filePath.hash || filePath.tag )
  filePath.longPath = parent.detrail( filePath.longPath );

  return this.str( filePath );
}

function normalize( filePath )
{
  let parent = this.path;
  _.assert( _.strIs( filePath ), 'Expects string {-filePath-}' );
  if( _.strIs( filePath ) )
  {
    if( this.isGlobal( filePath ) )
    filePath = this.parseConsecutive( filePath );
    else
    return parent.normalize.call( this, filePath );
  }
  _.assert( !!filePath );
  filePath.longPath = parent.normalize.call( this, filePath.longPath );
  return this.str( filePath );
}

//

function canonize( filePath )
{
  let parent = this.path;
  if( _.strIs( filePath ) )
  {
    if( this.isGlobal( filePath ) )
    filePath = this.parseConsecutive( filePath );
    else
    return parent.canonize.call( this, filePath );
  }
  _.assert( !!filePath );
  filePath.longPath = parent.canonize.call( this, filePath.longPath );
  return this.str( filePath );
}

//

function normalizeTolerant( filePath )
{
  let parent = this.path;
  if( _.strIs( filePath ) )
  {
    if( this.isGlobal( filePath ) )
    filePath = this.parseConsecutive( filePath );
    else
    return parent.normalizeTolerant.call( this, filePath );
  }
  _.assert( !!filePath );
  filePath.longPath = parent.normalizeTolerant.call( this, filePath.longPath );
  return this.str( filePath );
}

//

function dot( path )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( path ) );

  if( !this.isGlobal( path ) )
  return parent.dot.call( this, path );

  path = this.parseConsecutive( path );
  path.longPath = parent.dot( path.longPath );

  return this.str( path );
}

//

function trail( srcPath )
{
  _.assert( arguments.length === 1 );
  return this.path.trail( srcPath );
}

//

function detrail( srcPath )
{
  _.assert( this.is( srcPath ) );
  _.assert( arguments.length === 1 );

  // debugger;
  if( _.strIs( srcPath ) )
  srcPath = this.parseConsecutive( srcPath );

  srcPath.longPath = this.path.detrail( srcPath.longPath );

  return this.str( srcPath );
}

//

function name( o )
{
  let parent = this.path;
  if( _.strIs( o ) )
  o = { path : o }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.path ) );
  _.routine.options_( name, o );

  if( !this.isGlobal( o.path ) )
  return parent.name.call( this, o );

  let path = this.parseConsecutive( o.path );

  let o2 = _.props.extend( null, o );
  o2.path = path.longPath;
  return parent.name.call( this, o2 );
}

name.defaults = Object.create( Parent.name.defaults );

//

function ext( path )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string' );

  if( this.isGlobal( path ) )
  path = this.parseConsecutive( path ).longPath;

  return parent.ext.call( this, path );
}

//

function exts( path )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( path ) );

  if( this.isGlobal( path ) )
  path = this.parseConsecutive( path ).longPath;

  return parent.exts.call( this, path );
}

//

function changeExt( path, ext )
{
  let parent = this.path;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strDefined( path ) );
  _.assert( _.strIs( ext ) );

  if( !this.isGlobal( path ) )
  return parent.changeExt.call( this, path, ext );

  path = this.parseConsecutive( path );

  path.longPath = parent.changeExt( path.longPath, ext );

  return this.str( path );
}

// --
// joiner
// --

function join_functor( gen )
{

  if( arguments.length === 2 )
  gen = { routineName : arguments[ 0 ], web : arguments[ 1 ] }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routine.assertOptions( join_functor, gen );

  let routineName = gen.routineName;
  let web = gen.web;

  return function joining()
  {

    let parent = this.path;
    let result = Object.create( null );
    let srcs = [];
    let isGlobal = false;

    /* */

    if( web )
    {

      for( let s = 0 ; s < arguments.length ; s++ )
      {
        if( arguments[ s ] !== null && this.isGlobal( arguments[ s ] ) )
        {
          isGlobal = true;
          srcs[ s ] = this.parseAtomic( arguments[ s ] );
        }
        else
        {
          isGlobal = arguments[ s ] !== null;
          srcs[ s ] = { resourcePath : arguments[ s ] };
        }
      }

    }
    else
    {

      for( let s = 0 ; s < arguments.length ; s++ )
      {
        if( arguments[ s ] !== null && this.isGlobal( arguments[ s ] ) )
        {
          isGlobal = true;
          srcs[ s ] = this.parseConsecutive( arguments[ s ] );
        }
        else
        {
          isGlobal = arguments[ s ] !== null;
          srcs[ s ] = { longPath : arguments[ s ] };
        }
      }

    }

    /* */

    if( web )
    {
      result.resourcePath = undefined;
    }
    else
    {
      result.longPath = undefined;
    }

    /* */

    for( let s = srcs.length-1 ; s >= 0 ; s-- )
    {
      let src = srcs[ s ];

      if( web )
      if( result.protocol && src.protocol )
      if( result.protocol !== src.protocol )
      continue;

      if( !result.protocol && src.protocol !== undefined )
      result.protocol = src.protocol;

      if( web )
      {

        let hostWas = result.host;
        if( !result.host && src.host !== undefined )
        result.host = src.host;

        if( !result.user && src.user !== undefined )
        result.user = src.user;

        if( !result.port && src.port !== undefined )
        if( !hostWas || !src.host || hostWas === src.host )
        result.port = src.port;

        if( !result.resourcePath && src.resourcePath !== undefined )
        result.resourcePath = src.resourcePath;
        else if( src.resourcePath )
        result.resourcePath = parent[ routineName ]( src.resourcePath, result.resourcePath );

        if( src.resourcePath === null )
        break;

      }
      else
      {

        if( result.longPath === undefined && src.longPath !== undefined )
        result.longPath = src.longPath;
        else if( src.longPath )
        result.longPath = parent[ routineName ]( src.longPath, result.longPath );

        if( src.longPath === null )
        break;

      }

      if( src.query !== undefined )
      if( result.query )
      result.query = src.query + '&' + result.query;
      else
      result.query = src.query;

      if( !result.hash && src.hash !==undefined )
      result.hash = src.hash;

      if( !result.tag && src.tag !==undefined )
      result.tag = src.tag;
    }

    /* */

    if( !isGlobal )
    {
      if( web )
      return result.resourcePath;
      else
      return result.longPath;
    }

    if( ( result.hash || result.tag ) && result.longPath )
    result.longPath = parent.detrail( result.longPath );

    return this.str( result );
  }

}

join_functor.defaults =
{
  routineName : null,
  web : 0,
}

//

let join = join_functor({ routineName : 'join', web : 0 });
let joinRaw = join_functor({ routineName : 'joinRaw', web : 0 });
let reroot = join_functor({ routineName : 'reroot', web : 0 });

//

function join_head( routine, args )
{
  let o = args[ 0 ];

  if( _.mapIs( o ) )
  _.assert( args.length === 1, 'Expects single options map {-o-}' );
  else
  o = { args };

  _.routine.options_( routine, o );
  _.assert( _.strIs( o.routineName ) );

  return o;
}

//

function join_body( o )
{
  let self = this;
  let parent = self.path;
  let isGlobal = false;

  /* */

  let srcs = pathsParseConsecutiveAndSetIsGlobal( o.args );
  let result = resultMapMake( srcs );

  /* */

  if( !isGlobal )
  return result.longPath;

  if( ( result.hash || result.tag ) && result.longPath )
  result.longPath = parent.detrail( result.longPath );

  return this.str( result );

  /* */

  function pathsParseConsecutiveAndSetIsGlobal( args )
  {
    let result = _.array.make( args.length );

    for( let s = 0 ; s < args.length ; s++ )
    {
      if( args[ s ] !== null && self.isGlobal( args[ s ] ) )
      {
        isGlobal = true;
        result[ s ] = self.parseConsecutive( args[ s ] );
      }
      else
      {
        isGlobal = args[ s ] !== null;
        result[ s ] = { longPath : args[ s ] };
      }
    }

    return result;
  }

  /* */

  function resultMapMake( srcs )
  {
    let result = Object.create( null );
    result.resourcePath = undefined;

    for( let s = srcs.length - 1 ; s >= 0 ; s-- )
    {
      let src = srcs[ s ];

      if( !result.protocol && src.protocol !== undefined )
      result.protocol = src.protocol;

      if( result.longPath === undefined && src.longPath !== undefined )
      result.longPath = src.longPath;
      else if( src.longPath )
      result.longPath = parent[ o.routineName ]( src.longPath, result.longPath );

      if( src.longPath === null )
      break;

      if( src.query !== undefined )
      if( result.query )
      result.query = src.query + '&' + result.query;
      else
      result.query = src.query;

      if( !result.hash && src.hash !== undefined )
      result.hash = src.hash;

      if( !result.tag && src.tag !== undefined )
      result.tag = src.tag;
    }

    return result;
  }
}

join_body.defaults =
{
  routineName : 'join',
  args : null,
};

//

let join_ = _.routine.uniteCloning_replaceByUnite( join_head, join_body );

//

let joinRaw_ = _.routine.uniteCloning_replaceByUnite( join_head, join_body );
joinRaw_.defaults.routineName = 'joinRaw';

//

let reroot_ = _.routine.uniteCloning_replaceByUnite( join_head, join_body );
reroot_.defaults.routineName = 'reroot';

//

function resolve()
{
  let parent = this.path;
  let args = []
  let hasNull;

  for( let i = arguments.length - 1 ; i >= 0 ; i-- )
  {
    let arg = arguments[ i ];
    if( arg === null )
    {
      hasNull = true;
      break;
    }
    else
    {
      args.unshift( arg );
    }
  }

  if( args.length === 0 )
  {
    if( hasNull )
    return null;
    else
    return parent.resolve.call( this );
  }

  let result = this.join.apply( this, args );
  if( hasNull || this.isAbsolute( result ) )
  return result;

  let parsed = this.parseConsecutive( result );
  parsed.longPath = parent.join.call( this, parent.resolve.call( this, '.' ), parsed.longPath );
  return this.str( parsed );
}

// {
//   let parent = this.path;
//   return this.join( parent.resolve.call( this, '.' ), ... arguments );
// }

// {
//   let parent = this.path;
//   let joined = this.join.apply( this, arguments );
//   if( joined === null )
//   return joined;
//   let parsed = this.parseConsecutive( joined );
//   parsed.longPath = parent.resolve.call( this, parsed.longPath ); /* xxx yyy */
//   // parsed.longPath = parent.resolve( parsed.longPath );
//   return this.str( parsed );
// }

//

function relative_body( o )
{
  let parent = this.path;

  _.routine.assertOptions( relative_body, arguments );

  if( !this.isGlobal( o.basePath ) && !this.isGlobal( o.filePath ) )
  {
    let o2 = _.props.extend( null, o );
    delete o2.global;
    return this._relative( o2 );
  }

  let basePath = this.parseConsecutive( o.basePath );
  let filePath = this.parseConsecutive( o.filePath );

  let o2 = _.props.extend( null, o );
  delete o2.global;
  o2.basePath = basePath.longPath;
  o2.filePath = filePath.longPath;
  let longPath = parent._relative( o2 );

  if( o.global )
  {
    _.props.extend( filePath, basePath );
    // _.props.supplement( basePath, filePath );
    // return this.str( basePath );
  }
  else
  {
    for( let c in filePath )
    {
      if( c === 'longPath' )
      continue;
      if( filePath[ c ] === basePath[ c ] )
      delete filePath[ c ];
    }
  }

  filePath.longPath = longPath;

  return this.str( filePath );
}

var defaults = relative_body.defaults = Object.create( Parent.relative.defaults );
defaults.global = 1; /* qqq : why is this option here? */

let relative = _.routine.uniteCloning_replaceByUnite( Parent.relative.head, relative_body );

//

/*
qqq : teach common to work with path maps and cover it by tests | Dmytro : new task was to teach common work with uri maps, done
*/

function common()
{
  let parent = this.path;
  let self = this;
  let uris = _.arrayFlatten( null, arguments );

  for( let s = uris.length-1 ; s >= 0 ; s-- )
  {
    // _.assert( !_.mapIs( uris[ s ] ), 'not tested' );

    /* Dmytro : added for :
       _.uriNew.common( path1, path2 );
       _.uriNew.common( _.uriNew.parse( path1 ), _.uriNew.parse( path2 ) );
       має давати однаковий результат */

    if( _.mapIs( uris[ s ] ) )
    uris[ s ] = self.str( uris[ s ] );
  }

  _.assert( _.strsAreAll( uris ), 'Expects only strings as arguments' );

  /* */

  if( !uris.length )
  return null;

  /* */

  let isRelative = null;
  for( let i = 0, len = uris.length ; i < len ; i++ )
  {
    uris[ i ] = parse( uris[ i ] );
    let isThisRelative = parent.isRelative.call( this, uris[ i ].longPath );
    _.assert( isRelative === isThisRelative || isRelative === null, 'Attempt to combine relative with absolutue paths' );
    isRelative = isThisRelative;
  }

  /* */

  let result = _.props.extend( null, uris[ 0 ] );
  let protocol = null;
  let withoutProtocol = 0;

  for( let i = 1, len = uris.length ; i < len ; i++ )
  {

    for( let c in result )
    if( uris[ i ][ c ] !== result[ c ] )
    delete result[ c ];

  }

  /* */

  for( let i = 0, len = uris.length; i < len; i++ )
  {
    let uri = uris[ i ];

    let protocol2 = uri.protocol || '';

    if( protocol === null )
    {
      protocol = uri.protocol;
      continue;
    }

    if( uri.protocol === protocol )
    continue;

    if( uri.protocol && protocol )
    return '';

    withoutProtocol = 1;

  }

  if( withoutProtocol )
  protocol = '';

  result.protocol = protocol;
  result.longPath = result.longPath || uris[ 0 ].longPath;

  /* */

  for( let i = 1, len = uris.length; i < len; i++ )
  {
    let uri = uris[ i ];
    result.longPath = parent._commonPair.call( this, uri.longPath, result.longPath );
  }

  /* */

  return this.str( result );

  /* */

  function parse( uri )
  {
    let result;

    if( _.strIs( uri ) )
    if( self.isGlobal( uri ) )
    {
      result = self.parseConsecutive( uri );
    }
    else
    {
      result = { longPath : uri };
    }

    return result;
  }

}

//

function rebase( srcPath, oldPath, newPath )
{
  let parent = this.path;
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  srcPath = this.parseConsecutive( srcPath );
  oldPath = this.parseConsecutive( oldPath );
  newPath = this.parseConsecutive( newPath );

  let dstPath = _.props.extend( null, srcPath, _.mapValsWithKeys( newPath, _.props.keys( srcPath ) ) );

  // if( srcPath.protocol !== undefined && oldPath.protocol !== undefined )
  // {
  //   if( srcPath.protocol === oldPath.protocol && newPath.protocol === undefined )
  //   delete dstPath.protocol;
  // }
  //
  // if( srcPath.host !== undefined && oldPath.host !== undefined )
  // {
  //   if( srcPath.host === oldPath.host && newPath.host === undefined )
  //   delete dstPath.host;
  // }

  // dstPath.resourcePath = null; xxx
  dstPath.longPath = parent.rebase.call( this, srcPath.longPath, oldPath.longPath, newPath.longPath );

  return this.str( dstPath );
}

//


function dir_body( o )
{
  let parent = this.path;

  if( !this.isGlobal( o.filePath ) )
  return parent.dir.body.call( this, o );

  let o2 = _.props.extend( null, o );
  let filePath = this.parseConsecutive( o.filePath );
  o2.filePath = filePath.longPath
  filePath.longPath = parent.dir.body.call( this, o2 )

  return this.str( filePath );
}

_.assert( _.aux.is( Parent.dir.body.defaults ) );
_.routineExtend( dir_body, Parent.dir.body );

let dir = _.routine.uniteCloning_replaceByUnite( Parent.dir.head, dir_body );
_.props.extend( dir.defaults, Parent.dir.defaults );

let dirFirst = _.routine.uniteCloning_replaceByUnite( Parent.dirFirst.head, dir_body );
_.props.extend( dirFirst.defaults, Parent.dirFirst.defaults );

//

function groupTextualReport_head( routine, args )
{
  let self = this;
  let parent = this.path;

  let o = args[ 0 ];

  _.assert( _.object.isBasic( o ), 'Expects object' );

  let basePathParsed;

  if( !o.onRelative )
  o.onRelative = function onRelative( basePath, filePath )
  {
    if( !basePathParsed )
    basePathParsed = self.parseConsecutive( basePath );

    let filePathParsed = self.parseConsecutive( filePath );
    filePathParsed.longPath = self.relative( basePathParsed.longPath, filePathParsed.longPath );

    let strOptions = { longPath : filePathParsed.longPath }

    if( !basePathParsed.hash )
    strOptions.hash = filePathParsed.hash;
    if( !basePathParsed.tag )
    strOptions.tag = filePathParsed.tag;
    if( !basePathParsed.protocol )
    strOptions.protocol = filePathParsed.protocol;
    if( !basePathParsed.query )
    strOptions.query = filePathParsed.query;

    return self.str( strOptions );
  }

  return parent.groupTextualReport.head.call( self, routine, [ o ] );
}

let groupTextualReport = _.routine.uniteCloning_replaceByUnite( groupTextualReport_head, Parent.groupTextualReport.body );

//

function commonTextualReport( filePath )
{
  let self = this;
  let parent = this.path;

  _.assert( arguments.length === 1 );

  let basePathParsed;
  let o =
  {
    filePath,
    onRelative
  }
  return parent._commonTextualReport.call( self, o );

  /*  */

  function onRelative( basePath, filePath )
  {
    if( !basePathParsed )
    basePathParsed = self.parseConsecutive( basePath );

    let filePathParsed = self.parseConsecutive( filePath );
    filePathParsed.longPath = self.relative( basePathParsed.longPath, filePathParsed.longPath );

    let strOptions = { longPath : filePathParsed.longPath }

    if( !basePathParsed.hash )
    strOptions.hash = filePathParsed.hash;
    if( !basePathParsed.tag )
    strOptions.tag = filePathParsed.tag;
    if( !basePathParsed.protocol )
    strOptions.protocol = filePathParsed.protocol;
    if( !basePathParsed.query )
    strOptions.query = filePathParsed.query;

    return self.str( strOptions );
  }
}

//

function moveTextualReport_head( routine, args )
{
  let self = this;
  let parent = this.path;

  let o = args[ 0 ];
  if( args[ 1 ] !== undefined )
  o = { dstPath : args[ 0 ], srcPath : args[ 1 ] }

  _.assert( _.object.isBasic( o ), 'Expects object' );

  let basePathParsed;

  if( !o.onRelative )
  o.onRelative = function onRelative( basePath, filePath )
  {
    if( !basePathParsed )
    basePathParsed = self.parseConsecutive( basePath );

    let filePathParsed = self.parseConsecutive( filePath );
    filePathParsed.longPath = self.relative( basePathParsed.longPath, filePathParsed.longPath );

    let strOptions = { longPath : filePathParsed.longPath }

    if( !basePathParsed.hash )
    strOptions.hash = filePathParsed.hash;
    if( !basePathParsed.tag )
    strOptions.tag = filePathParsed.tag;
    if( !basePathParsed.protocol )
    strOptions.protocol = filePathParsed.protocol;
    if( !basePathParsed.query )
    strOptions.query = filePathParsed.query;

    return self.str( strOptions );
  }

  return parent.moveTextualReport.head.call( self, routine, [ o ] );
}

let moveTextualReport = _.routine.uniteCloning_replaceByUnite( moveTextualReport_head, Parent.moveTextualReport.body );

//

/**
 * Returns origin plus path without query part of uri string.
 * @example
 *
   let path = 'https://www.site.com:13/path/name?query=here&and=here#anchor';
   wTools.uri.uri.documentGet( path, { withoutProtocol : 1 } );
   // 'www.site.com:13/path/name'
 * @param {string} path uri string
 * @param {Object} [o] o - options
 * @param {boolean} o.withoutServer if true rejects origin part from result
 * @param {boolean} o.withoutProtocol if true rejects protocol part from result uri
 * @returns {string} Return document uri.
 * @function documentGet
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function documentGet( path, o )
{
  let self = this;

  o = o || Object.create( null );

  if( path === undefined )
  path = _realGlobal_.location.href;

  if( path.indexOf( '//' ) === -1 )
  {
    path = 'http:/' + ( path[ 0 ] === '/' ? '' : '/' ) + path;
  }

  let a = path.split( '//' );
  let b = a[ 1 ].split( self.queryToken );

  /* */

  if( o.withoutServer )
  {
    let i = b[ 0 ].indexOf( '/' );
    if( i === -1 ) i = 0;
    return b[ 0 ].substr( i );
  }
  else
  {
    if( o.withoutProtocol )return b[ 0 ];
    else return a[ 0 ] + '//' + b[ 0 ];
  }

}

documentGet.defaults =
{
  path : null,
  withoutServer : null,
  withoutProtocol : null,
}

//

/**
 * Return origin (protocol + host + port) part of passed `path` string. If missed arguments, returns origin of
 * current document.
 * @example
 *
   let path = 'http://www.site.com:13/path/name?query=here'
   wTools.uri.server( path );
   // 'http://www.site.com:13/'
 * @param {string} [path] uri
 * @returns {string} Origin part of uri.
 * @function server
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function server( path )
{
  let a, b;

  if( path === undefined )
  path = _realGlobal_.location.origin;

  if( path.indexOf( '//' ) === -1 )
  {
    if( path[ 0 ] === '/' )return '/';
    a = [ '', path ]
  }
  else
  {
    a = path.split( '//' );
    a[ 0 ] += '//';
  }

  b = a[ 1 ].split( '/' );

  return a[ 0 ] + b[ 0 ] + '/';
}

//

/**
 * Returns query part of uri. If method is called without arguments, it returns current query of current document uri.
 * @example
   let uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor',
   wTools.uri.query( uri ); // 'query=here&and=here#anchor'
 * @param {string } [path] uri
 * @returns {string}
 * @function query
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function query( path )
{
  let self = this;
  if( path === undefined )
  path = _realGlobal_.location.href;
  if( path.indexOf( self.queryToken ) === -1 )
  return '';
  return path.split( self.queryToken )[ 1 ];
}

//

/**
 * Parse a query string passed as a 'query' argument. Result is returned as a dictionary.
 * The dictionary keys are the unique query variable names and the values are decoded from uri query variable values.
 * @example
 *
   let query = 'k1=&k2=v2%20v3&k3=v4_v4';

   let res = wTools.uri.dequery( query );
   // {
   //   k1 : '',
   //   k2 : 'v2 v3',
   //   k3 : 'v4_v4'
   // },

 * @param {string} query query string
 * @returns {Object}
 * @function dequery
 * @module Tools/UriBasic
 * @namespace Tools.uri
 */

function dequery( query )
{

  let result = Object.create( null );
  query = query || _global.location.search.split( self.queryToken )[ 1 ];
  if( !query || !query.length )
  return result;
  let vars = query.split( '&' );

  for( let i = 0 ; i < vars.length ; i++ )
  {

    let w = vars[ i ].split( '=' );
    w[ 0 ] = decodeURIComponent( w[ 0 ] );
    if( w[ 1 ] === undefined ) w[ 1 ] = '';
    else w[ 1 ] = decodeURIComponent( w[ 1 ] );

    if( ( w[ 1 ][ 0 ] === w[ 1 ][ w[ 1 ].length-1 ] ) && ( w[ 1 ][ 0 ] === '"' ) )
    w[ 1 ] = w[ 1 ].substr( 1, w[ 1 ].length-1 );

    if( result[ w[ 0 ] ] === undefined )
    {
      result[ w[ 0 ] ] = w[ 1 ];
    }
    else if( _.strIs( result[ w[ 0 ] ] ) )
    {
      result[ w[ 0 ] ] = result[ w[ 1 ] ]
    }
    else
    {
      result[ w[ 0 ] ].push( w[ 1 ] );
    }

  }

  return result;
}

// --
// relations
// --

let Parameters =
{

  protocolToken : '://',
  portToken : ':',
  userToken : '@',
  tagToken : '!', /* xxx : enable */
  // tagToken : '@',
  hashToken : '#',
  queryToken : '?',

}

//

let Extension =
{

  // internal

  _filterOnlyUrl,
  _filterNoInnerArray,

  // dichotomy

  is,
  isSafe,
  isRefined,
  isNormalized,
  isAbsolute,
  isRelative,
  isRoot,
  isDotted,
  isTrailed,
  isGlob,

  // transformer

  _parseOrigin,
  _parseLongPath,
  _parseHostFull,

  parse,
  parseFull,
  parseAtomic,
  parseConsecutive,
  localFromGlobal,

  str,
  full,

  refine,
  normalize,
  canonize,
  normalizeTolerant,

  dot,

  trail,
  detrail,

  name,
  ext,
  exts,
  changeExt,

  // joiner

  join_functor,

  join,
  join_, /* !!! use instead of join */ /* Dmytro : routine contains no redundant 'if' statements for WebUri */
  joinRaw,
  joinRaw_, /* !!! use instead of joinRaw */ /* Dmytro : routine contains no redundant 'if' statements for WebUri */
  reroot,
  reroot_, /* !!! use instead of reroot */ /* Dmytro : routine contains no redundant 'if' statements for WebUri */
  resolve,

  relative,
  common,
  rebase,

  dir,
  dirFirst,

  groupTextualReport,
  commonTextualReport,
  moveTextualReport,

  documentGet,
  server,
  query,
  dequery,

  // fields

  single : Self,

  Uri,
  UriFull,
  UriAtomic,
  UriConsequtive,
  /* qqq : use this blueprints with help of method Blueprint.Rconstruct() */

}

_.mapExtendDstNotOwn( Self, Extension );
_.mapExtendDstNotOwn( Self, Parameters );
_.mapExtendDstNotOwn( Self.Parameters, Parameters );

Self.Init();

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

if( typeof module !== 'undefined' )
require( '../l4/UriOld.s' );
if( typeof module !== 'undefined' )
require( '../l5/Uris.s' );

})();

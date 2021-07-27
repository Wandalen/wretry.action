( function _Basic_ss_()
{

'use strict';

const _ = _global_.wTools;
_.npm = _.npm || Object.create( null );

_.assert( _.routineIs( _.strLinesIndentation ) );

// --
// meta
// --

function _readChangeWrite_functor( fo )
{
  let defaults =
  {
    nativizing : 1,
    localPath : null,
    configPath : null,
    dry : 0,
    logger : 0,
    onChange : null,
  };

  if( !_.mapIs( fo ) )
  fo = { onChange : arguments[ 0 ], name : ( arguments.length > 1 ? arguments[ 1 ] : null ) }

  fo = _.routine.options( _readChangeWrite_functor, fo );
  fo.head = fo.head || head;
  fo.body = fo.body || body;

  const name = fo.name;
  const onChange = fo.onChange;
  _.assert( _.strDefined( name ) );
  _.assert( _.routineIs( fo.onChange ) );
  _.assert( _.aux.is( fo.onChange.defaults ) );
  _.assert( fo.onChange.defaults.config !== undefined );

  // if( !fo.body.defaults && fo.onChange.defaults )
  if( fo.onChange.defaults )
  fo.body.defaults = _.props.supplement( fo.body.defaults || null, fo.onChange.defaults )
  let defaults2 = Object.create( null );
  defaults2.logger = 0;
  defaults2.dry = 0;
  defaults2.localPath = null;
  defaults2.configPath = null;
  defaults2.nativizing = 1;
  _.props.supplement( fo.body.defaults, defaults2 )

  return _.routine.unite
  ({
    head : fo.head,
    body : fo.body,
    name : fo.name,
  });

  function head( routine, args )
  {
    let o = _.routine.options( routine, args );
    _.assert( arguments.length === 2 );
    _.assert( args.length === 1 );
    _.assert( o.logger !== undefined );
    // if( routine.defaults.logger !== undefined )
    // {
    o.logger = _.logger.maybe( o.logger );
      // if( _.numberIs( o.logger ) || _.boolIs( o.logger ) )
      // if( !o.logger || o.logger < 0 )
      // o.logger = 0;
    // }
    return o;
  }

  function body( o )
  {
    let self = this;

    try
    {
      let o2 = _.props.extend( null, o );
      _.props.supplement( o2, o2, defaults );
      o2.onChange = onChange;
      _readChangeWrite.call( self, o2 );
      _.props.extend( o, o2 );
      return o;
    }
    catch( err )
    {
      throw _.err( err, `\nFailed to ${name} version of npm config ${o.configPath}` );
    }

  }

  /* */

  function _readChangeWrite( o )
  {
    o.logger = _.logger.maybe( o.logger );
    _.assert( o.logger === 0 || _.logger.is( o.logger ) );

    if( !o.configPath )
    o.configPath = _.npm.pathConfigFromLocal( o.localPath );
    if( !o.config )
    o.config = _.fileProvider.fileReadUnknown( o.configPath );

    let o2 = Object.create( null );
    _.mapOnly_( o2, o, o.onChange.defaults );
    _.routine.options( o.onChange, o2 );
    o.onChange.call( this, o2 );
    _.assert( _.boolIs( o2.changed ) );
    o.changed = o2.changed;
    o.config = o2.config;

    if( !o.changed )
    return o;

    let str;
    if( o.nativizing )
    {
      o.config = _.npm.structureFormat({ config : o.config });
      str = JSON.stringify( o.config, null, '  ' ) + '\n';
    }
    else
    {
      let encoder = _.gdf.selectSingleContext
      ({
        inFormat : 'structure',
        outFormat : 'string',
        ext : 'json',
        feature : { fine : 1 },
      });

      str = encoder.encode({ data : o.config }).out.data;
      str = str.replace( /\s\n/mg, '\n' ) + '\n';
    };

    _.assert( _.strIs( str ) );

    if( o.logger && o.logger.verbosity >= 1 )
    o.logger.log( `Rewriting ${o.configPath}` );
    if( o.logger && o.logger.verbosity >= 2 )
    o.logger.log( '  ' + _.strLinesIndentation( str, '  ' ) );

    if( o.dry )
    return o;

    _.fileProvider.fileWrite( o.configPath, str );

    return o;
  }
}

_readChangeWrite_functor.defaults =
{
  head : null,
  body : null,
  onChange : null,
  name : null,
};

//

function _read( routine, args )
{
  let self = this;
  let path = _.uri;
  let o = args[ 0 ];

  if( _.strIs( o ) )
  o = { localPath : o }

  _.assert( arguments.length === 2 );
  _.routine.options_( routine, o );
  _.map.assertHasAll( o, _read.defaults );

  if( o.config === null || o.config === undefined )
  {
    if( !o.configPath )
    o.configPath = self.pathConfigFromLocal( o.localPath );
    if( !_.fileProvider.fileExists( o.configPath ) )
    return;
    o.config = _.fileProvider.fileReadUnknown( o.configPath );
  }

  return o;
}

_read.defaults =
{
  config : null,
  localPath : null,
  configPath : null,
}

// --
// path
// --

/**
 * @typedef {Object} RemotePathComponents
 * @property {String} protocol
 * @property {String} hash
 * @property {String} longPath
 * @property {String} localVcsPath
 * @property {String} remoteVcsPath
 * @property {String} remoteVcsLongerPath
 * @module Tools/mid/NpmTools
 */

/**
 * @summary Parses provided `remotePath` and returns object with components {@link module:Tools/mid/Files.wTools.FileProvider.Npm.RemotePathComponents}.
 * @param {String} remotePath Remote path.
 * @function pathParse
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function pathParse( remotePath ) /* xxx : rename into pathAnalyze() */
{
  let self = this;
  let path = _.uri;
  let result = Object.create( null );
  /* xxx : qqq : for Dmytro : use path and fileProvider of self everywhere in module::NpmToools and module::GitTools */

  if( _.mapIs( remotePath ) )
  return remotePath;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( remotePath ) );
  _.assert( path.isGlobal( remotePath ) );

  /* */

  let parsed1 = path.parseConsecutive( remotePath );
  _.props.extend( result, parsed1 );

  if( !result.tag && !result.hash )
  result.tag = 'latest';

  _.assert( !result.tag || !result.hash, 'Remote path:', _.strQuote( remotePath ), 'should contain only hash or tag, but not both.' )

  let [ name, localPath ] = pathIsolateGlobalAndLocal( parsed1.longPath );
  result.localVcsPath = localPath;

  /* */

  let parsed2 = _.props.extend( null, parsed1 );
  parsed2.protocol = null;
  parsed2.hash = null;
  parsed2.tag = null;
  parsed2.longPath = name;
  result.remoteVcsPath = path.str( parsed2 );

  // parsed2.hash = parsed1.hash;
  // parsed2.tag = parsed1.tag;
  result.remoteVcsLongerPath = result.remoteVcsPath + '@' + ( result.hash || result.tag );
  // result.remoteVcsLongerPath = self.pathNativize(  );

  // /* */
  //
  // let parsed3 = _.props.extend( null, parsed1 );
  // parsed3.longPath = parsed2.longPath;
  // parsed3.protocol = null;
  // parsed3.hash = null;
  // parsed3.tag = null;
  // result.remoteVcsLongerPath = path.str( parsed3 );
  // let version = parsed1.hash || parsed1.tag;
  // if( version )
  // result.remoteVcsLongerPath += '@' + version;

  /* */

  // result.isFixated = self.pathIsFixated( result );
  result.isFixated = _.npm.path.isFixated( result );

  return result

  /*
    remotePath : 'npm:///wColor/out/wColor#0.3.100'
    protocol : 'npm',
    hash : '0.3.100',
    longPath : '/wColor/out/wColor',
    localVcsPath : 'out/wColor',
    remoteVcsPath : 'wColor',
    remoteVcsLongerPath : 'wColor@0.3.100'
  */

  /* */

  function pathIsolateGlobalAndLocal( longPath )
  {
    let splits = _.path.split( longPath );
    if( splits[ 0 ] === '' )
    splits.splice( 0, 1 );
    return [ splits[ 0 ], splits.slice( 1 ).join( '/' ) ];
    // let parsed = path.parseConsecutive( longPath );
    // let splits = _.strIsolateLeftOrAll( parsed.longPath, /^\/?\w+\/?/ );
    // parsed.longPath = _.strRemoveEnd( _.strRemoveBegin( splits[ 1 ], '/' ), '/' );
    // let globalPath = path.str( parsed );
    // return [ globalPath, splits[ 2 ] ];
  }

}

//

function pathNativize( remotePath )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( remotePath ) );

  let parsedPath = _.uri.parseFull( remotePath );

  let result = parsedPath.longPath;

  if( parsedPath.hash || parsedPath.tag )
  result += '@' + ( parsedPath.hash || parsedPath.tag );

  return result;
}

//

/**
 * @summary Returns true if remote path `filePath` has fixed version of npm package.
 * @param {String} filePath Global path.
 * @function pathIsFixated
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function pathIsFixated( filePath )
{
  let self = this;
  let path = _.uri;
  // let parsed = self.pathParse( filePath );
  let parsed = _.npm.path.parse( filePath );

  if( !parsed.hash )
  return false;

  return true;
}

//

/**
 * @summary Changes version of package specified in path `o.remotePath` to latest available.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.logger=0 Level of logger.
 * @function pathIsFixated
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function pathFixate( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }
  _.routine.options( pathFixate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  // let parsed = self.pathParse( o.remotePath );
  let parsed = _.npm.path.parse( o.remotePath );
  let latestVersion = self.remoteVersionLatest
  ({
    remotePath : o.remotePath,
    logger : o.logger,
  });

  let result = path.str
  ({
    protocol : parsed.protocol,
    longPath : parsed.longPath,
    hash : latestVersion,
  });

  return result;
}

var defaults = pathFixate.defaults = Object.create( null );
defaults.remotePath = null;
defaults.logger = 0;

//

function pathConfigFromLocal( localPath )
{
  return _.path.join( localPath, 'package.json' );
}

//

function pathLocalFromConfig( configPath )
{
  _.assert( _.path.fullName( configPath ) === 'package.json' );
  return _.path.dir( configPath );
}

//

function pathLocalFromInside( insidePath )
{
  let fileProvider = _.fileProvider;
  let path = fileProvider.path;

  _.assert( arguments.length === 1 );

  insidePath = path.canonize( insidePath );

  if( check( insidePath ) )
  return insidePath;

  let paths = path.traceToRoot( insidePath );
  for( var i = paths.length - 1; i >= 0; i-- )
  if( check( paths[ i ] ) )
  return paths[ i ];

  return null;

  function check( dirPath )
  {
    if( !fileProvider.isTerminal( path.join( dirPath, 'package.json' ) ) )
    return false
    return true;
  }

}

//

/* xxx : qqq : implement and use similar routine for git */
function pathDownloadFromLocal( localPath )
{
  _.assert( arguments.length === 1, 'Expects single local path {-localPath-}' );
  return _.path.join( localPath, 'node_modules' );
}

//

function pathLocalFromDownload( configPath )
{
  _.assert( _.path.fullName( configPath ) === 'node_modules' );
  return _.path.dir( configPath );
}

// --
// write l2
// --

function structureFormat_functor()
{
  let npmJsVersionIsNewer;

  structureFormat.defaults =
  {
    logger : 0,
    nativizing : 1,
    config : null,
  };

  return structureFormat;

  function structureFormat( o )
  {
    if( o.changed === true )
    return o.config;

    let depSectionsNames =
    [
      'dependencies',
      'devDependencies',
      'optionalDependencies',
      'peerDependencies',
    ];

    // const npmJsVersionIsNewer = npmMajorVersionIsNewerOrSame( 7 );
    if( npmJsVersionIsNewer === undefined )
    npmJsVersionIsNewer = npmMajorVersionIsNewerOrSame( 7 );
    // const sortElements = npmJsVersionIsNewer ? sortElementsBackward : sortElementsForward;
    const sortElements = npmJsVersionIsNewer ? sortElementsForward : sortElementsBackward;

    _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
    _.assert( _.aux.is( o.config ), 'Expects structure {-o.config-}' );

    for( let i = 0; i < depSectionsNames.length; i++ )
    if( o.config[ depSectionsNames[ i ] ] )
    {
      const src = o.config[ depSectionsNames[ i ] ];
      const result = Object.create( null );
      const keys = _.props.keys( src );
      keys.sort( sortElements );
      for( let i = 0; i < keys.length; i++ )
      result[ keys[ i ] ] = src[ keys[ i ] ];
      o.config[ depSectionsNames[ i ] ] = result;
    }

    o.changed = true;

    return o.config;

    /* */

    // /* qqq : for Dmytro : very bad! */
    // function npmMajorVersionIsNewerOrSame( majorVersion )
    // {
    //   let op = _.process.start
    //   ({
    //     execPath : 'npm --version',
    //     outputCollecting : 1,
    //     mode : 'shell',
    //     sync : 1,
    //   });
    //   return _.number.from( op.output[ 0 ] ) >= majorVersion;
    // }

  }

  /* */

  /* qqq : for Dmytro : bad : poor and sloppy! */
  function npmMajorVersionIsNewerOrSame( majorVersion )
  {
    let op = _.process.start
    ({
      execPath : 'npm --version',
      outputCollecting : 1,
      mode : 'shell', /* aaa : for Dmytro : very bad! */ /* Dmytro : Windows cannot spawn NPM process, should use mode `shell` : https://github.com/Wandalen/wNpmTools/runs/2387247651?check_suite_focus=true */
      // mode : 'spawn',
      sync : 1,
      outputPiping : 0,
      verbosity : 0,
      logger : 0,
    });
    return _.number.from( op.output[ 0 ] ) >= majorVersion;
  }

  /* */

  function sortElementsForward( a, b )
  {
    return a.toLowerCase().localeCompare( b.toLowerCase() );
  }

  /* */

  function sortElementsBackward( a, b )
  {
    return b.toLowerCase().localeCompare( a.toLowerCase() );
  }
}

let structureFormat = structureFormat_functor();

//

/* aaa : for Dmytro : bad : lack of routine _.npm.structureFormat() ! */ /* Dmytro : implemented and used */
const fileFormat = _readChangeWrite_functor( structureFormat, 'fileFormat' );

// qqq : for Dmytro : sloppy!
// fileFormat.defaults =
// {
//   configPath : null,
//   nativizing : 1,
// };

// function fileFormat( o )
// {
//   let fileProvider = _.fileProvider;
//
//   _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
//   _.assert( _.strDefined( o.filePath ), 'Expects path to JSON file {-o.filePath-}' );
//
//   let config = fileProvider.fileReadUnknown({ filePath : o.filePath, encoding : 'json' });
//   config = _.npm.structureFormat( config );
//   fileProvider.fileWrite( o.filePath, JSON.stringify( config, null, '  ' ) + '\n' );
//   return true;
// }
//
// fileFormat.defaults = Object.create( null );
// fileFormat.defaults.filePath = null;

//

/**
 * @summary Fixates versions of the dependencies in provided config.
 * @param {Object} o.config Object representation of package.json file.
 * @param {String} o.tag Sets specified tag to all dependencies.
 * @param {Routine} o.onDep Callback routine executed for each dependecy. Accepts single argument - dependecy descriptor.
 * @param {Number} [o.logger=2] Verbosity control.
 * @function structureFixate
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function structureFixate( o )
{

  // let depSectionsNames =
  // [
  //   'dependencies',
  //   'devDependencies',
  //   'optionalDependencies',
  //   'bundledDependencies',
  //   'peerDependencies',
  // ];

  o = _.routine.options( structureFixate, o );
  o.changed = false;

  if( !o.onDep )
  o.onDep = function onDep( dep )
  {
    dep.version = o.tag;
  }

  _.assert( _.strDefined( o.tag ) );

  this.DepSectionsNames.forEach( ( s ) =>
  {
    if( o.config[ s ] )
    for( let depName in o.config[ s ] )
    {
      let depVersion = o.config[ s ][ depName ];
      let dep = Object.create( null );
      dep.name = depName;
      dep.version = depVersion;
      dep.config = o.config;
      if( dep.version )
      continue;
      let r = o.onDep( dep );
      _.assert( r === undefined );
      if( dep.version === depVersion && dep.name === depName )
      continue;
      o.changed = true;
      delete o.config[ s ][ depName ];
      if( dep.version === undefined || dep.name === undefined )
      continue;
      o.config[ s ][ dep.name ] = dep.version;
    }
  });

  // return o.changed;
  return o;
}

structureFixate.defaults =
{
  config : null,
  onDep : null,
  tag : null,
};

//

/**
 * @summary Fixates versions of the dependencies in provided package.
 * @param {String} o.localPath Path to package directory.
 * @param {String} o.configPath Path to package.json file.
 * @param {String} o.tag Sets specified tag to all dependencies.
 * @param {Routine} o.onDep Callback routine executed for each dependecy. Accepts single argument - dependecy descriptor.
 * @param {Boolean} [o.dry=0] Returns generated config without making changes in package.json.
 * @param {Number} [o.logger=2] Verbosity control.
 * @function fileFixate
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

const fileFixate = _readChangeWrite_functor( structureFixate, 'fileFixate' );

var defaults = fileFixate.defaults;
_.assert( defaults === fileFixate.body.defaults );
_.assert( defaults !== structureFixate.defaults );
_.assert( defaults.onDep !== undefined );

//

/**
 * @summary Bumps package version using provided config.
 * @param {Object} o.config Object representation of package.json file.
 * @function structureBump
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function structureBump( o )
{

  o = _.routine.options( structureBump, o );
  o.changed = false;

  let version = o.config.version || '0.0.0';
  let versionArray = version.split( '.' );
  versionArray[ 2 ] = Number( versionArray[ 2 ] );
  _.sure( _.intIs( versionArray[ 2 ] ), `Can't deduce current version : ${version}` );

  versionArray[ 2 ] += 1;
  version = versionArray.join( '.' );

  o.changed = true;
  o.config.version = version;

  // return version;
  return o;

  // function depVersionPatch( dep )
  // {
  //   return o.tag;
  // }

}

structureBump.defaults =
{
  config : null,
};

//

/**
 * @summary Bumps package version.
 * @param {String} o.localPath Path to package directory.
 * @param {Object} o.configPath Path to package.json file.
 * @param {Routine} o.onDep Callback routine executed for each dependecy. Accepts single argument - dependecy descriptor.
 * @param {Boolean} [o.dry=0] Returns generated config without making changes in package.json.
 * @param {Number} [o.logger=2] Verbosity control.
 * @function fileBump
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

const fileBump = _readChangeWrite_functor( structureBump, 'fileBump' );

//

function fileReadFilePath( o )
{
  let self = this;
  let path = _.uri;
  o = self._read( fileReadFilePath, arguments );
  if( !o.config )
  return;
  return o.config.files;
}

fileReadFilePath.defaults =
{
  localPath : null,
  configPath : null,
  config : null,
}

//

/* qqq : cover */

function fileAddFilePath_head( routine, args )
{
  let o = args[ 0 ];
  if( !_.mapIs( o ) )
  o = { localPath : arguments[ 0 ], filePath : ( arguments.length > 1 ? arguments[ 1 ] : null ) }
  o = _.routine.options( routine, args );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  // if( !o.verbosity || o.verbosity < 0 )
  // o.verbosity = 0;
  o.logger = _.logger.maybe( o.logger );
  return o;
}

//

function structureAddFilePath( o )
{
  let self = this;

  _.assert( _.object.isBasic( o.config ) );
  _.assert( _.strIs( o.filePath ) || _.strsAreAll( o.filePath ) );

  o.changed = false;
  o.config.files = o.config.files || [];

  let length = o.config.files.length;
  _.arrayAppendArraysOnce( o.config.files, o.filePath );
  if( length !== o.config.files.length )
  o.changed = true;

  return o;
}

structureAddFilePath.defaults =
{
  config : null,
  filePath : null,
}

const fileAddFilePath = _readChangeWrite_functor
({
  name : 'fileAddFilePath',
  head : fileAddFilePath_head,
  onChange : structureAddFilePath,
});

//

function fileReadField( o )
{
  let self = this;
  let path = _.uri;
  o = self._read( fileReadField, arguments );
  if( !o.config )
  return;
  return o.config[ o.key ];
}

fileReadField.defaults =
{
  localPath : null,
  configPath : null,
  config : null,
  key : null,
}

//

function _structureWriteField( o )
{
  let self = this;

  _.assert( _.object.isBasic( o.config ) );
  _.assert( _.strDefined( o.key ) );

  o.changed = false;
  if( o.config[ o.key ] !== o.val )
  {
    o.config[ o.key ] = o.val;
    o.changed = true;
  }

  return o;
}

_structureWriteField.defaults =
{
  config : null,
  key : null,
  val : null,
}

const fileWriteField = _readChangeWrite_functor
({
  name : 'fileWriteField',
  onChange : _structureWriteField,
});

//

/* qqq : cover */
function fileReadName( o )
{
  let self = this;
  let path = _.uri;
  o = self._read( fileReadName, arguments );
  if( !o.config )
  return;
  return o.config.name;
}

fileReadName.defaults =
{
  localPath : null,
  configPath : null,
  config : null,
}

//

function fileReadEntryPath( o )
{
  let self = this;
  let path = _.uri;
  o = self._read( fileReadEntryPath, arguments );
  if( !o.config )
  return;
  return o.config.main;
}

fileReadEntryPath.defaults =
{
  localPath : null,
  configPath : null,
  config : null,
}

// --
// write l3
// --

function depAdd( o )
{
  let will = this;
  let fileProvider = _.fileSystem;
  let path = _.uri;

  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.routine.options( depAdd, o );

  o.logger = _.logger.maybe( o.logger );
  let nodeModulesPath = _.npm.pathDownloadFromLocal( o.localPath );

  _.assert( _.strDefined( o.depPath ) );
  _.assert( _.boolLikeFalse( o.editing ), 'not implemented' );
  _.assert( _.boolLikeTrue( o.downloading ), 'not implemented' );
  _.assert( _.boolLikeTrue( o.linking ), 'not implemented' );
  _.assert( path.parse( o.depPath ).protocol === 'hd', 'not implemented' );

  _.sure
  (
    fileProvider.fileExists( _.npm.pathLocalFromDownload( nodeModulesPath ) ), `nodeModulesPath:${nodeModulesPath} does not exist`
  );
  _.sure( fileProvider.fileExists( o.depPath ), `depPath:${o.depPath} does not exist` );
  _.sure( _.strDefined( o.as ), '`as` is not specified' );
  let dstPath = path.join( nodeModulesPath, o.as );

  if( o.downloading )
  {
    if( o.linking )
    {
      if( o.logger )
      {
        o.logger.rbegin({ verbosity : -1 });
        o.logger.log( `Linking ${_.ct.format( o.depPath, 'path' )} to ${_.ct.format( dstPath, 'path' )}` );
        o.logger.rend({ verbosity : -1 });
      }
      if( !o.dry )
      fileProvider.softLink
      ({
        dstPath,
        srcPath : o.depPath,
        makingDirectory : 1,
        rewritingDirs : 1,
      });
    }
  }

  return true;
}

depAdd.defaults =
{
  as : null,
  localPath : null,
  depPath : null,
  editing : 1,
  downloading : 1,
  linking : 1,
  dry : 0,
  logger : 0,
};

/* xxx : aaa : for Dmytro : replace each option::verbosity by option::logger */ /* Dmytro : replaced, not me, I added missed logger declaration and remove unused option */

//

function depRemove_head( routine, args )
{
  let o = args[ 0 ];
  if( !_.mapIs( o ) )
  o = { localPath : arguments[ 0 ], depPath : ( arguments.length > 1 ? arguments[ 1 ] : null ) }
  o = _.routine.options( routine, args );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  o.logger = _.logger.maybe( o.logger );
  // if( !o.verbosity || o.verbosity < 0 )
  // o.verbosity = 0;
  return o;
}

function structureDepRemove( o )
{
  let self = this;

  _.assert( o.kind === null || _.longHas( self.DepSectionsNames, o.kind ) );
  _.assert( o.kind === null, 'not implemented' );
  _.assert( _.object.isBasic( o.config ) );
  _.assert( _.strDefined( o.depPath ) );

  o.changed = false;
  self.DepSectionsNames.forEach( ( e ) =>
  {
    if( o.config[ e ] )
    if( o.config[ e ][ o.depPath ] )
    {
      o.changed = true;
      delete o.config[ e ][ o.depPath ];
    }
  });

  return o;
}

/* qqq : cover. take into account complex cases. */
/* qqq : take into account case like depPath:mapbox/gyp */
structureDepRemove.defaults =
{
  config : null,
  depPath : null,
  kind : null, /* xxx : qqq : implement and make possible to path countable to select several kinds */
}

/* qqq2 : for Dmytro : write test routines
- make sure there is test wich delete submodule which already has a link. files which are referred by the link should not be deleted
- duplicate tests in NpmTools and willbe
*/

const depRemove = _readChangeWrite_functor
({
  name : 'depRemove',
  head : depRemove_head,
  onChange : structureDepRemove,
});

//

/* aaa : cover */ /* Dmytro : covered */
/* aaa : cover case o.localPath is soft link */ /* Dmytro : covered, throw error because it is not directory, test routine `installLocalPathIsSoftLink` */

function install( o )
{
  let self = this;
  let ready = _.take( null );
  let fileProvider = _.fileSystem;
  let path = _.uri;
  let abs = _.routineJoin( path, path.s.join, [ o.localPath ] );

  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.routine.options_( install, o );
  _.assert( _.strDefined( o.localPath ) );
  _.sure( fileProvider.isDir( o.localPath ) );

  o.logger = _.logger.maybe( o.logger );

  if( o.locked === null )
  o.locked = fileProvider.isTerminal( path.join( o.localPath, 'package-lock.json' ) );

  fileProvider.filesDelete( path.join( o.localPath, 'node_modules' ) );
  if( !o.locked )
  fileProvider.filesDelete( path.join( o.localPath, 'package-lock.json' ) );

  let execPath = o.locked ? 'npm ci' : 'npm install';

  let o2 =
  {
    execPath,
    currentPath : o.localPath,
    inputMirroring : 1,
    throwingExitCode : 1,
    outputPiping : 1,
    concurrent : 0,
    mode : 'shell',
    deasync : 0,
    sync : o.sync,
    logger : o.logger,
    verbosity : o.logger ? o.logger.verbosity : 0,
    dry : o.dry,
    ready,
  };

  /* xxx : qqq : why not additive output? */
  _.process.start( o2 );

  ready.then( ( op ) =>
  {
    if( !o.linkingSelf && o.linkingSelf !== null )
    return null;

    let linkAs = _.npm.fileReadName({ localPath : o.localPath });
    if( o.linkingSelf === null )
    o.linkingSelf = !!linkAs;

    if( o.linkingSelf )
    return _.npm.depAdd
    ({
      localPath : o.localPath,
      depPath : path.join( 'hd://.', o.localPath ),
      as : linkAs,
      editing : 0,
      downloading : 1,
      linking : 1,
      logger : o.logger,
      dry : o.dry,
    });

    return null;
  });

  if( o.sync )
  return ready.sync();
  return ready;
}

/* aaa2 : for Dmytro : write test routines
- make sure there is test wich delete submodule which already has a link. files which are referred by the link should not be deleted
- duplicate tests in NpmTools and willbe
*/
/* Dmytro : covered
- first case is actual for routine `depAdd`, this case was covered,
- duplicate for willbe commands
*/

install.defaults =
{
  locked : null,
  localPath : null,
  linkingSelf : null,
  logger : 0,
  dry : 0,
  sync : 1,
};

//

/* qqq : for Dmytro : cover */
/* qqq : for Dmytro : cover case o.localPath is soft link */
function clean( o )
{
  let self = this;
  let ready = _.take( null );
  let fileProvider = _.fileSystem;
  let path = _.uri;
  let abs = _.routineJoin( path, path.s.join, [ o.localPath ] );

  _.routine.options_( clean, o );
  _.assert( _.strDefined( o.localPath ) );
  _.sure( fileProvider.isDir( o.localPath ) );

  fileProvider.filesDelete( path.join( o.localPath, 'node_modules' ) );
  fileProvider.filesDelete( path.join( o.localPath, 'package-lock.json' ) );

  if( o.sync )
  return ready.sync();
  return ready;
}

/* qqq : cover each option */
clean.defaults =
{
  localPath : null,
  logger : 0, /* qqq : implement and cover the option */
  dry : 0,
  sync : 1,
}

//

/**
 * @summary Publishes a package to the npm registry.
 * {@see https://docs.npmjs.com/cli/publish}
 * @param {String} o.localPath Path to package directory.
 * @param {String} o.tag Registers the published package with the given tag.
 * @param {Object} o.ready Consequence instance.
 * @param {Number} o.logger Verbosity control.
 * @function publish
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function publish( o )
{
  let self = this;

  _.routine.options( publish, arguments );
  o.logger = _.logger.maybe( o.logger );
  // if( !o.verbosity || o.verbosity < 0 )
  // o.verbosity = 0;

  _.assert( _.path.isAbsolute( o.localPath ), 'Expects local path' );
  _.assert( _.strDefined( o.tag ), 'Expects tag' );

  if( !o.ready )
  o.ready = new _.Consequence().take( null );

  let start = _.process.starter
  ({
    currentPath : o.localPath,
    outputCollecting : 1,
    outputGraying : 1,
    outputPiping : o.logger ? o.logger.verbosity >= 2 : 0,
    inputMirroring : o.logger ? o.logger.verbosity >= 2 : 0,
    verbosity : o.logger ? o.logger.verbosity : 0,
    logger : o.logger,
    mode : 'shell',
    ready : o.ready,
  });

  return start( `npm publish --tag ${o.tag}` )
  .finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( err, `\nFailed publish ${o.localPath} with tag ${o.tag}` );
    return arg;
  });
}

publish.defaults =
{
  localPath : null,
  tag : null,
  ready : null,
  logger : 0,
};

// --
// read l3
// --

function versionLog( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.routine.options( versionLog, o );

  if( !o.tags )
  o.tags = [ 'latest' ];

  _.assert( _.strsAreAll( o.tags ), 'Expects strings {-o.tags-}.' );

  o.logger = _.logger.maybe( o.logger );

  if( !o.configPath )
  o.configPath = self.pathConfigFromLocal( o.localPath );

  _.assert( _.strDefined( o.configPath ) );
  _.assert( _.strDefined( o.remotePath ) );

  const packageJson =  _.fileProvider.fileRead({ filePath : o.configPath, encoding : 'json', throwing : 0 });
  const remotePath = _.npm.path.nativize( o.remotePath );

  /* */

  const unknownVersion = '-no-';
  const currentVersion = packageJson ? packageJson.version : unknownVersion;
  let ready = _.take( `Current version : ${ currentVersion }\n` );

  const prefixMap =
  {
    latest : 'Latest version of',
    stable : 'Stable version of',
  };

  // let start = _.process.starter
  // ({
  //   outputCollecting : 1,
  //   outputPiping : 0,
  //   inputMirroring : 0,
  //   throwingExitCode : 0,
  //   logger : o.logger,
  //   verbosity : o.logger.verbosity,
  // });

  let readies = [];
  for( let i = 0 ; i < o.tags.length ; i++ )
  readies.push( versionLogGet( o.tags[ i ] ) );

  return ready.andTake( readies )
  .finally( ( err, resolved ) =>
  {
    if( err )
    throw _.err( err );

    let log = resolved.join( '' );
    if( o.logger && o.logger.verbosity )
    o.logger.log( log );
    return log;
  });

  /* */

  function versionLogGet( tag )
  {
    const version = `${ remotePath }@${ tag }`
    return _.process.start
    ({
      execPath : `npm view ${ version } version`,
      outputCollecting : 1,
      outputPiping : 0,
      inputMirroring : 0,
      throwingExitCode : 0,
      logger : o.logger,
      verbosity : o.logger.verbosity,
    })
    .then( ( got ) =>
    {
      let latest = _.strStrip( got.output );
      if( got.exitCode || !latest )
      latest = unknownVersion;

      const postfix = `${ o.remotePath } : ${ latest }\n`;
      if( tag in prefixMap )
      return `${ prefixMap[ tag ] } ${ postfix }`;
      else
      return `${ tag } version of ${ postfix }`;
    });
  }
}

versionLog.defaults =
{
  logger : 1,
  remotePath : null,
  localPath : null,
  configPath : null,
  tags : null,
};

// function versionLog( o )
// {
//   let self = this;
//
//   _.routine.options( versionLog, o );
//
//   if( !o.configPath )
//   o.configPath = self.pathConfigFromLocal( o.localPath );
//   // o.configPath = _.path.join( o.localPath, 'package.json' ); /* xxx : qqq for Dmytro : introduce routine::localPathToConfigPath and use everywhere */
//
//   o.logger = _.logger.maybe( o.logger );
//
//   _.assert( _.strDefined( o.configPath ) );
//   _.assert( _.strDefined( o.remotePath ) );
//
//   // let logger = o.logger || _global_.logger;
//   let packageJson =  _.fileProvider.fileRead({ filePath : o.configPath, encoding : 'json', throwing : 0 });
//   // let remotePath = self.pathNativize( o.remotePath );
//   let remotePath = _.npm.path.nativize( o.remotePath );
//
//   // _.assert( !o.logging || !!logger, 'No defined logger' );
//
//   return _.process.start
//   ({
//     execPath : `npm view ${remotePath} version`,
//     outputCollecting : 1,
//     outputPiping : 0,
//     inputMirroring : 0,
//     throwingExitCode : 0,
//     logger : o.logger,
//     verbosity : o.logger.verbosity,
//   })
//   .then( ( got ) =>
//   {
//     let current = packageJson ? packageJson.version : 'unknown';
//     let latest = _.strStrip( got.output );
//
//     if( got.exitCode || !latest )
//     latest = 'unknown'
//
//     let log = '';
//     log += `Current version : ${current}\n`;
//     log += `Latest version of ${o.remotePath} : ${latest}\n`;
//
//     // if( o.logging )
//     // logger.log( log );
//
//     if( o.logger && o.logger.verbosity )
//     o.logger.log( log );
//
//     return log;
//   })
//
// }
//
// versionLog.defaults =
// {
//   logger : 1,
//   // logging : 1,
//   remotePath : null,
//   localPath : null,
//   configPath : null,
// };

// --
// remote
// --

/**
 * @summary Gets package metadata from npm registry.
 * @param {String} o.name Package name
 * @param {Boolean} [o.sync=1] Controls sync/async execution mode
 * @param {Boolean} [o.throwing=0] Controls error throwing
 * @function remoteAbout
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function remoteAbout( o )
{
  const self = this;
  const packageServer = 'https://registry.npmjs.org/';
  // let PackageJson = require( 'package-json' );

  if( _.strIs( arguments[ 0 ] ) )
  o = { name : arguments[ 0 ] };
  o = _.routine.options( remoteAbout, o );

  const splits = _.strIsolateLeftOrAll({ src : o.name, delimeter : '!' });
  o.name = splits[ 0 ];
  o.version = splits[ 2 ] ? splits[ 2 ] : 'latest';

  // let ready = _.Consequence.From( PackageJson( o.name, { fullMetadata : true, version : o.version } ) );
  const ready = _.http.retrieve
  ({
    uri : _.path.join( packageServer, o.name ),
    sync : 0,
    attemptLimit : o.attemptLimit,
    attemptDelay : o.attemptDelay,
    successStatus : [ 200, 404 ],
  });

  ready.then( handleResponse );

  // ready.catch( ( err ) =>
  // {
  //   if( !o.throwing )
  //   {
  //     _.errAttend( err );
  //     return null;
  //   }
  //   throw _.err( err, `\nFailed to get information about remote module ${name}` );
  // });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function handleResponse( op )
  {
    const response = op.response;
    let err;

    if( response.statusCode === 200 )
    {
      const data = response.body;
      const distTagVersion = data[ 'dist-tags' ][ o.version ];

      if( distTagVersion )
      return data.versions[ distTagVersion ];

      const versionData = data.versions[ o.version ];
      if( versionData )
      return versionData;

      err = _.err( `Wrong version tag ${ _.strQuote( o.version ) }` );
    }

    if( o.throwing )
    throw _.err( err ? err : response.body.error, `\nFailed to get information about remote module ${ _.strQuote( o.name ) }` );
    return null;
  }
}

remoteAbout.defaults =
{
  name : null,
  sync : 1,
  throwing : 1,
  attemptLimit : null,
  attemptDelay : 500,
};

//

/**
 * @summary Retrieves package dependants number from npm storage.
 * @param {(string|string[])} o.remotePath Package name or array of names(the same as on npm storage).
 * @param {boolean} [o.sync=0] Controls sync/async execution mode.
 * @param {number} [o.logger=0] Verbosity control.
 * @returns {(number|number[])} Dependanst number for one package or array of dependants for array of packages.
 * @function remoteDependants
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function remoteDependants( o )
{
  const self = this;
  const prefixUri = 'https://www.npmjs.com/package/';

  let counter = 0;

  if( !_.mapIs( o ) )
  o = { remotePath : o }
  _.routine.options( remoteDependants, o );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strsAreAll( o.remotePath ), 'Expects only strings as a package name' );

  let isSingle = !_.arrayIs( o.remotePath );
  o.remotePath = _.array.as( o.remotePath );
  o.logger = _.logger.maybe( o.logger );

  let uri = o.remotePath.map( ( remotePath ) => uriNormalize( remotePath ) );

  let ready = _.http.retrieve
  ({
    uri,
    sync : 0,
    verbosity : o.logger ? o.logger.verbosity : 0,
    attemptLimit : o.attemptLimit,
    attemptDelay : o.attemptDelay,
    attemptDelayMultiplier : o.attemptDelayMultiplier,
    successStatus : [ 200, 404 ],
  });

  ready.then( ( responses ) =>
  {
    let result = responses.map( ( response ) => responsesHandle( response ) );
    if( isSingle )
    return result[ 0 ];
    return result;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function uriNormalize( filePath )
  {
    let result;
    if( _.uri.isGlobal( filePath ) )
    {
      // let parsed = self.pathParse( filePath );
      let parsed = _.npm.path.parse( filePath );
      result = prefixUri + ( parsed.longPath[ 0 ] === '/' ? parsed.longPath.slice( 1 ) : parsed.longPath );
    }
    else
    {
      result = prefixUri + filePath;
    }
    return result;
  }

  /* */

  function responsesHandle( op )
  {
    let dependants = '';
    if( op.response.statusCode !== 200 )
    return NaN;

    const html = op.response.body;
    const strWithDep = html.match( /[0-9]*,?[0-9]*<\/span>Dependents/ );

    if( !strWithDep )
    return NaN;

    for( let i = strWithDep.index; html[ i ] !== '<'; i++ )
    dependants += html[ i ];
    dependants = Number( dependants.split( ',' ).join( '' ) );

    return dependants;
  }
}

remoteDependants.defaults =
{
  remotePath : null,
  sync : 0,
  // verbosity : 0,
  logger : 0,
  attemptLimit : null,
  attemptDelay : null,
  attemptDelayMultiplier : 4,
};

// --
// vcs
// --

/**
 * @summary Returns version of npm package located at `o.localPath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Path to npm package on hard drive.
 * @function localVersion
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function localVersion( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { localPath : arguments[ 0 ] }

  _.routine.options( localVersion, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = new _.Consequence().take( null );

  ready.then( () => self.isRepository( o ) )
  ready.then( ( isRepository ) =>
  {
    if( !isRepository )
    return '';

    return _.fileProvider.fileRead
    ({
      // filePath : path.join( o.localPath, 'package.json' ),
      filePath : self.pathConfigFromLocal( o.localPath ),
      encoding : 'json',
      sync : 0,
    });
  })
  ready.finally( ( err, read ) =>
  {
    if( err )
    return null;
    if( _.strIs( read ) )
    return read;
    if( !read.version )
    return null;
    return read.version;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = localVersion.defaults = Object.create( null );
defaults.localPath = null;
defaults.sync = 1;
// defaults.logger = 0; /* Dmytro : unused option */

//

/**
 * @summary Returns latest version of npm package using its remote path `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.logger=0 Level of verbosity.
 * @function remoteVersionLatest
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function remoteVersionLatest( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o };

  _.routine.options( remoteVersionLatest, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  o.logger = _.logger.maybe( o.logger );

  let ready = new _.Consequence().take( null );
  let shell = _.process.starter
  ({
    verbosity : o.logger ? o.logger.verbosity - 1 : 0,
    logger : o.logger,
    outputCollecting : 1,
    sync : 0,
    deasync : 0,
  });
  let parsed = null;

  ready.then( () =>
  {
    // parsed = _.npm.pathParse( o.remotePath );
    // return shell( 'npm show ' + parsed.remoteVcsPath );
    parsed = _.npm.path.parse({ remotePath : o.remotePath, full : 0, objects : 1 });
    return shell( 'npm show ' + parsed.host );
  })
  ready.then( ( got ) =>
  {
    let latestVersion = /latest.*?:.*?([0-9\.][0-9\.][0-9\.]+)/.exec( got.output );
    if( !latestVersion )
    {
      // throw _.err( 'Failed to get information about NPM package', parsed.remoteVcsPath );
      throw _.err( 'Failed to get information about NPM package', parsed.host );
    }
    latestVersion = latestVersion[ 1 ];

    return latestVersion;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = remoteVersionLatest.defaults = Object.create( null );
defaults.remotePath = null;
defaults.sync = 1;
defaults.logger = 0;

//

/**
 * @summary Returns current version of npm package using its remote path `o.remotePath`.
 * @description Returns latest version if no version specified in remote path.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.logger=0 Level of verbosity.
 * @function remoteVersionCurrent
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function remoteVersionCurrent( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o };

  _.routine.options( remoteVersionCurrent, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = _.take( null );

  ready.then( () =>
  {
    // let parsed = self.pathParse( o.remotePath );
    let parsed = self.path.parse( o.remotePath );
    if( parsed.isFixated )
    return parsed.hash;
    return self.remoteVersionLatest( o );
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = remoteVersionCurrent.defaults = Object.create( null );
defaults.remotePath = null;
defaults.sync = 1;
defaults.logger = 0;

//

function remoteVersion( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o };

  _.routine.options( remoteVersion, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  o.logger = _.logger.maybe( o.logger );

  let ready = new _.Consequence().take( null );
  let shell = _.process.starter
  ({
    verbosity : o.logger ? o.logger.verbosity - 1 : o.logger,
    logger : o.logger,
    outputCollecting : 1,
    sync : 0,
    deasync : 0,
  });

  ready.then( () =>
  {
    // let parsed = self.pathParse( o.remotePath );
    // return shell( 'npm show ' + parsed.remoteVcsLongerPath + ' version' );
    let packageVcsName = _.npm.path.nativize( o.remotePath );
    return shell( 'npm show ' + packageVcsName + ' version' );
  })
  ready.then( ( got ) =>
  {
    let version = _.strStrip( got.output );
    return version;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = remoteVersion.defaults = Object.create( null );
defaults.remotePath = null;
defaults.sync = 1;
defaults.logger = 0;

//

/**
 * @summary Returns true if local copy of package `o.localPath` is up to date with remote version `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.remotePath Remote path to package.
 * @param {Number} o.logger=0 Level of verbosity.
 * @function isUpToDate
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function isUpToDate( o )
{
  let self = this;
  let path = _.uri;

  _.routine.options( isUpToDate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  // let parsed = self.pathParse( o.remotePath );
  let parsed = self.path.parse( o.remotePath );

  let ready = new _.Consequence().take( null );
  let status = statusInit();

  ready.then( () => self.localVersion({ localPath : o.localPath, /* logger : o.logger, */ sync : 0 }) )
  ready.then( ( currentVersion ) =>
  {
    status.currentVersion = currentVersion;
    status.isRepository = !!currentVersion;

    if( !status.isRepository )
    return false;

    status.hasRemoteVersion = parsed.hash === currentVersion;

    if( status.hasRemoteVersion )
    return true;

    return self.remoteVersion({ remotePath : o.remotePath, logger : o.logger, sync : 0 })
    .then( ( latestVersion ) =>
    {
      status.latestVersion = latestVersion;
      status.hasLatestVersion = currentVersion === latestVersion;
      return status.hasLatestVersion;
    })
  })

  ready.then( end );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function statusInit()
  {
    let status = Object.create( null );
    status.isRepository = null;
    status.hasRemoteVersion = null;
    status.hasLatestVersion = null;
    return status;
  }

  /* */

  function end( result )
  {
    status.result = result;
    if( !o.detailing )
    return result;
    if( result )
    return status;
    if( status.isRepository === false )
    status.reason = `No npm module at: ${o.localPath}`
    else if( status.hasLatestVersion === false )
    status.reason = `Local npm module is not up-to-date with remote.`
                    + `\nCurrent version: ${status.currentVersion}`
                    + `\nLatest version: ${status.latestVersion}`
    return status;
  }
}

var defaults = isUpToDate.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.sync = 1;
defaults.logger = 0;
defaults.detailing = 0;

//

/**
 * @summary Returns true if path `o.localPath` contains npm package.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @function hasFiles
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function hasFiles( o )
{
  let localProvider = _.fileProvider;

  _.routine.options( hasFiles, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !localProvider.isDir( o.localPath ) )
  return false;
  if( !localProvider.dirIsEmpty( o.localPath ) )
  return true;

  return false;
}

var defaults = hasFiles.defaults = Object.create( null );
defaults.localPath = null;
// defaults.logger = 0; /* Dmytro : unused option */

//

/**
 * @summary Returns true if path `o.localPath` contains a package.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @function isRepository
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function isRepository( o )
{
  let self = this;
  let path = _.uri;

  _.routine.options( isRepository, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = _.Consequence.Try( () =>
  {
    if( !_.fileProvider.fileExists( o.localPath ) )
    return false;

    // if( !localProvider.isDir( path.join( o.localPath, 'node_modules' ) ) )
    // return false;

    // if( !_.fileProvider.isTerminal( path.join( o.localPath, 'package.json' ) ) )
    if( !_.fileProvider.isTerminal( self.pathConfigFromLocal( o.localPath ) ) )
    return false;

    return true;
  })

  if( o.sync )
  return ready.syncMaybe();

  return ready;
}

var defaults = isRepository.defaults = Object.create( null );
defaults.localPath = null;
defaults.sync = 1;
// defaults.logger = 0; /* Dmytro : unused option */

//

/**
 * @summary Returns true if path `o.localPath` contains a npm package that was installed from remote `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.remotePath Remote path to package.
 * @function hasRemote
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function hasRemote( o )
{
  let self = this;
  let localProvider = _.fileProvider;
  let path = localProvider.path;

  _.routine.options( hasRemote, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.remotePath ) );

  let ready = _.take( null );

  ready.then( () =>
  {
    let result = Object.create( null );
    result.downloaded = true;
    result.remoteIsValid = false;

    if( !localProvider.fileExists( o.localPath ) )
    {
      result.downloaded = false;
      return result;
    }

    // self.pathConfigFromLocal( o.localPath )
    // let configPath = path.join( o.localPath, 'package.json' );
    let configPath = self.pathConfigFromLocal( o.localPath );
    let configExists = localProvider.fileExists( configPath );

    if( !configExists )
    {
      result.downloaded = false;
      return result;
    }

    let config = localProvider.configRead( configPath );
    // let remoteVcsPath = self.pathParse( o.remotePath ).remoteVcsPath;
    let remoteVcsPath = _.npm.path.parse({ remotePath : o.remotePath, full : 0, objects : 1 }).host;
    let originVcsPath = config.name;

    _.sure( _.strDefined( remoteVcsPath ) );
    _.sure( _.strDefined( originVcsPath ) );

    result.remoteVcsPath = remoteVcsPath;
    result.originVcsPath = originVcsPath;
    result.remoteIsValid = originVcsPath === remoteVcsPath;

    return result;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = hasRemote.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.sync = 1;
// defaults.logger = 0; /* Dmytro : unused option */

//

function hasLocalChanges( o )
{
  if( _.object.isBasic( o ) )
  if( o.sync !== undefined )
  {
    if( o.sync )
    return false;
    else
    return new _.Consequence().take( false );
  }
  return false;
}

// --
// declare
// --

let DepSectionsNames =
[
  'dependencies',
  'devDependencies',
  'optionalDependencies',
  'bundledDependencies',
  'peerDependencies',
];

let Extension =
{

  protocols : [ 'npm' ],
  DepSectionsNames,

  // meta

  _readChangeWrite_functor,
  _read,

  // path

  pathParse,
  pathNativize,
  pathIsFixated,
  pathFixate,
  pathConfigFromLocal, /* qqq : cover */
  pathLocalFromConfig, /* qqq : cover */
  pathLocalFromInside,  /* qqq : cover */
  pathDownloadFromLocal, /* aaa : cover */ /* Dmytro : covered */
  pathLocalFromDownload, /* qqq : cover */

  // write l2

  structureFormat,
  fileFormat,

  fileFixate, /* qqq : cover please */
  structureFixate, /* qqq : cover please */
  fileBump, /* aaa : cover please */ /* Dmytro : covered */
  structureBump, /* qqq : cover please */

  fileReadFilePath,
  structureAddFilePath, /* qqq : implement and cover */
  fileAddFilePath, /* qqq : cover */
  /* qqq : implement structureRemoveFilePath and fileRemoveFilePath */

  fileReadField, /* xxx : qqq : implement and cover */
  _structureWriteField,
  fileWriteField, /* qqq : cover */

  /* xxx qqq : all routines using package.json should also fallback to package-lock.json if package.json does not exist */
  fileReadName,
  fileReadEntryPath,

  // write l3

  // structureDepAdd, /* qqq : implement and cover */
  depAdd, /* qqq : implement and cover */ /* Dmytro : covered behavior that was written before, added no additional features */ /* qqq : for Dmytro : cover output of routine */
  structureDepRemove, /* qqq : implement and cover */
  depRemove, /* qqq : cover */

  install,
  clean,
  publish,

  // read l3

  versionLog, /* qqq : cover */

  // remote

  remoteAbout,
  remoteDependants,

  // vcs

  /* xxx : rename */
  localVersion,
  remoteVersionLatest,
  remoteVersionCurrent,
  remoteVersion,
  isUpToDate,
  hasFiles,
  isRepository,
  hasRemote,
  hasLocalChanges,

}

/* _.props.extend */Object.assign( _.npm, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();

( function _FindMixin_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const FileRecord = _.files.FileRecord;
const Abstract = _.FileProvider.Abstract;
const Partial = _.FileProvider.Partial;
const fileRead = Partial.prototype.fileRead;

_.assert( _.entity.lengthOf( _.files.ReadEncoders ) > 0 );
_.assert( _.routineIs( _.files.FileRecord ) );
_.assert( _.routineIs( Abstract ) );
_.assert( _.routineIs( Partial ) );
_.assert( _.routineIs( fileRead ) );

//

/**
 @class wFileProviderFindMixin
 @class FileProvider
 @namespace wTools
 @module Tools/mid/Files
*/

const Parent = null;
const Self = wFileProviderFindMixin;
function wFileProviderFindMixin( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'FindMixin';

// --
// etc
// --

function recordsOrder( records, orderingExclusion )
{

  _.assert( _.arrayIs( records ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( !orderingExclusion.length )
  return records;

  orderingExclusion = _.RegexpObject.Order( orderingExclusion || [] );

  let removed = [];
  let result = [];
  let e = 0;
  for( ; e < orderingExclusion.length ; e++ )
  result[ e ] = [];

  for( let r = 0 ; r < records.length ; r++ )
  {
    let record = records[ r ];
    for( let e = 0 ; e < orderingExclusion.length ; e++ )
    {
      let mask = orderingExclusion[ e ];
      let match = mask.test( record.relative );
      if( match )
      {
        result[ e ].push( record );
        break;
      }
    }
    if( e === orderingExclusion.length )
    removed.push( record );
  }

  return _.arrayAppendArrays( [], result );
}

// --
// files find
// --

function _filesFindPrepare0( routine, args ) /* qqq : cover each case */
{
  let o;

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2, 'Expects one or two arguments' );

  if( args[ 0 ] && args[ 0 ] instanceof _.files.FileRecordFilter )
  {
    o = o || Object.create( null );
    o.filter = args[ 0 ];
  }
  else if( _.routineIs( args[ 0 ] ) )
  {
    o = o || Object.create( null );
    o.onUp = args[ 0 ];
  }
  else if( _.object.isBasic( args[ 0 ] ) )
  {
    o = args[ 0 ];
  }
  else
  {
    o = Object.create( null );
    if( args[ 0 ] !== undefined )
    o.filePath = args[ 0 ];
  }

  if( args.length === 2 )
  {
    if( args[ 1 ] && args[ 1 ] instanceof _.files.FileRecordFilter )
    {
      _.assert( !o.filter )
      o.filter = args[ 1 ];
    }
    else if( _.routineIs( args[ 1 ] ) )
    {
      _.assert( !o.onUp );
      o.onUp = args[ 1 ];
    }
    else _.assert( 0, 'Expects censor or callback onUp as the second argument' );
  }

  _.routine.options_( routine, o );

  o.filter = o.filter || Object.create( null );

  if( Config.debug )
  {
    _.assert( arguments.length === 2 );
    _.assert( 1 <= args.length && args.length <= 3 );
    _.assert( o.basePath === undefined );
    _.assert( o.prefixPath === undefined );
    _.assert( o.postfixPath === undefined );
    _.assert( _.object.isBasic( o.filter ) );
  }

  return o;
}

//

function _filesFindPrepare1( routine, args )
{
  let self = this;
  let path = self.path;
  let o = args[ 0 ];

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  /* */

  // if( o.onUp === null )
  // o.onUp = [];
  if( _.arrayIs( o.onUp ) )
  if( o.onUp.length === 0 )
  o.onUp = function( record, op ){ return record };
  else
  o.onUp = _.routinesComposeAllReturningLast( o.onUp );
  _.assert( _.routineIs( o.onUp ) || o.onUp === null );

  // if( o.onDown === null )
  // o.onDown = [];
  if( _.arrayIs( o.onDown ) )
  if( o.onDown.length === 0 )
  o.onDown = function( record, op ){};
  else
  o.onDown = _.routinesComposeReturningLast( o.onDown );
  _.assert( _.routineIs( o.onDown ) || o.onDown === null );

  /* */

  _.assert( o.filter instanceof _.files.FileRecordFilter );
  if( o.filter.formed < 5 )
  o.filter._formAssociations();

  let hasGlob = o.filter.filePathHasGlob();

  if( o.filter.recursive === null )
  {
    if( o.mode === 'distinct' )
    o.filter.recursive = hasGlob ? 2 : 0;
    else
    o.filter.recursive = hasGlob ? 2 : 2;
  }

  if( Config.debug )
  {
    _.assert( o.recursive === undefined );
    _.assert( !self.system || o.filter.system === self.system );
    _.assert( o.filter.filePath === null || path.s.allAreNormalized( o.filter.filePath ) );
  }

  return o;
}

//

function _filesFindPrepare2( routine, args )
{
  let self = this;
  let path = self.path;
  let o = args[ 0 ];

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  /* */

  let hasGlob = o.filter.filePathHasGlob();

  if( o.withDefunct === null )
  {
    if( o.mode === 'distinct' )
    o.withDefunct = !hasGlob;
    else
    o.withDefunct = false;
  }

  o.withTerminals = !!o.withTerminals;

  if( o.mode === 'distinct' && o.withDirs === null )
  {
    o.withDirs = !hasGlob;
  }
  o.withDirs = !!o.withDirs;

  if( o.withStem === null )
  o.withStem = true;
  o.withStem = !!o.withStem;

  if( Config.debug )
  {
    _.assert
    (
      o.filter.recursive === 0 || o.filter.recursive === 1 || o.filter.recursive === 2,
      () => 'Incorrect value of recursive option ' + _.strQuote( o.filter.recursive ) + ', should be 0, 1 or 2'
    );
  }

  return o;
}

//

function _filesFindFilterAbsorb( routine, args )
{
  let self = this;
  let path = self.path;
  let o = args[ 0 ];

  _.assert( !o.filter || !o.filter.formed <= 3, 'Filter is already formed, but should not be!' )
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  o.filter = self.recordFilter( o.filter || {} );

  if( o.filter.formed < 5 )
  if( o.filePath )
  {
    if( o.filePath instanceof _.files.FileRecordFilter )
    {
      o.filter.pathsExtend( o.filePath ).and( o.filePath );
      o.filePath = null;
    }
    else
    {
      o.filter.filePath = path.mapExtend( o.filter.filePath, o.filePath );
    }
    o.filePath = null;
  }

  /* in case of '' */
  o.filePath = null;

  return o;
}

//

function filesFindNominal_head( routine, args )
{
  let self = this;
  let path = self.path;

  let o = self._filesFindPrepare0( routine, args );
  self._filesFindFilterAbsorb( routine, [ o ] );
  self._filesFindPrepare1( routine, [ o ] );

  if( !o.filter.formed || o.filter.formed < 5 )
  o.filter.form();
  _.assert( !!o.filter.effectiveProvider );
  o.filter.effectiveProvider._providerDefaultsApply( o );

  if( !o.filePath )
  o.filePath = o.filter.filePathSimplest();

  _.assert( o.filePath && path.isNormalized( o.filePath ), 'Expects normalized path {-o.filePath-}' );
  _.assert( o.filePath && path.isAbsolute( o.filePath ), 'Expects absolute path {-o.filePath-}' );

  if( !o.factory )
  {
    let o2 =
    {
      stemPath : o.filePath,
      basePath : o.filter.formedBasePath[ o.filePath ],
    };
    _.assert( _.strDefined( o2.basePath ), 'No base path for', o.filePath );
    o.factory = _.files.FileRecordFactory.TolerantFrom( o, o2 ).form();
  }

  if( Config.debug )
  {

    _.routine.assertOptions( routine, o );
    _.assert
    (
      o.filter.recursive === 0 || o.filter.recursive === 1 || o.filter.recursive === 2,
      () => 'Incorrect value of recursive option ' + _.strQuote( o.filter.recursive ) + ', should be 0, 1 or 2'
    );
    _.assert( !self.system || o.filter.system === self.system );
    _.assert( !!o.filter.effectiveProvider );
    _.assert( _.routineIs( o.onUp ) || o.onUp === null );
    _.assert( _.routineIs( o.onDown ) || o.onDown === null );
    _.assert( o.filter.formed === 5, 'Expects formed filter' );
    _.assert( _.object.isBasic( o.filter.effectiveProvider ) );
    _.assert( _.mapIs( o.filter.formedBasePath ), 'Expects base path' );
    _.assert( o.filter.effectiveProvider instanceof _.FileProvider.Abstract );
    _.assert( o.filter.defaultProvider instanceof _.FileProvider.Abstract );
    _.assert( o.withTerminals === undefined );
    _.assert( o.withDirs === undefined );
    _.assert( o.withStem === undefined );
    _.assert( o.mandatory === undefined );
    _.assert( o.orderingExclusion === undefined );
    _.assert( o.outputFormat === undefined );
    _.assert( o.safe === undefined );
    _.assert( o.maskPreset === undefined );
    _.assert( o.mode === undefined );
    _.assert( o.result === undefined );
    _.assert( !!o.factory );
    _.assert( o.factory.basePath === o.filter.formedBasePath[ o.filePath ] );
    _.assert( o.factory.dirPath === null );
    _.assert( o.factory.effectiveProvider === o.filter.effectiveProvider );
    _.assert( o.factory.system === o.filter.system || o.filter.system === null );
    _.assert( o.factory.defaultProvider === o.filter.defaultProvider );

  }

  return o;
}

//

function filesFindNominal_body( o )
{
  let self = this;
  let path = self.path;

  o.filter.effectiveProvider.assertProviderDefaults( o );
  _.routine.assertOptions( filesFindNominal_body, arguments );
  _.assert( !!o.factory );
  _.assert( _.routineIs( o.onUp ) || o.onUp === null );
  _.assert( _.routineIs( o.onDown ) || o.onDown === null );

  /* */

  Object.freeze( o );

  let stemRecord = o.factory.record( o.filePath );
  _.assert( stemRecord.isStem === true );
  _.assert( o.factory.basePath === o.filter.formedBasePath[ o.filePath ] );
  _.assert( o.factory.dirPath === null );
  _.assert( o.factory.effectiveProvider === o.filter.effectiveProvider );
  _.assert( o.factory.system === o.filter.system || o.filter.system === null );
  _.assert( o.factory.defaultProvider === o.filter.defaultProvider );

  forStem( stemRecord, o );

  return o;

  /* */

  function forStem( r, op )
  {
    forDirectory( r, op )
    forTerminal( r, op )
  }

  /* */

  function forDirectory( r, op )
  {

    if( !r.isDir )
    return;
    if( !r.isTransient && !r.isActual )
    return;

    /* up */

    if( handleUp( r, op ) === _.dont )
    {
      handleDown( r, op );
      return false;
    }

    /* read */

    if( r.isTransient && op.filter.recursive )
    if( op.filter.recursive === 2 || r.isStem )
    {
      /* Vova : real path should be used for soft/text link to a dir for two reasons:
      - files from linked directory should be taken into account
      - usage of r.absolute path for a link will lead to recursion on next forDirectory( file, op ), because dirRead will return same path( r.absolute )
      outputFormat : relative is used because absolute path should contain path to a link in head
      */
      // let files = op.filter.effectiveProvider.dirRead({ filePath : r.absolute, outputFormat : 'absolute' });
      let files = op.filter.effectiveProvider.dirRead({ filePath : r.real, outputFormat : 'relative' });

      if( files === null )
      {
        if( o.factory.allowingMissed )
        {
          debugger;
          files = [];
        }
        else
        {
          debugger;
          throw _.err( 'Failed to read directory', _.strQuote( r.absolute ) );
        }
      }

      files = self.path.s.join( r.absolute, files );
      files = r.factory.records( files );

      /* terminals */

      for( let f = 0 ; f < files.length ; f++ )
      {
        let file = files[ f ];
        forTerminal( file, op );
      }

      /* dirs */

      for( let f = 0 ; f < files.length ; f++ )
      {
        let file = files[ f ];
        forDirectory( file, op );
      }

    }

    /* down */

    handleDown( r, op );

  }

  /* */

  function forTerminal( r, op )
  {

    if( r.isDir )
    return;
    if( !r.isTransient && !r.isActual )
    return;

    handleUp( r, op );
    handleDown( r, op );

  }

  /* - */

  function handleUp( record, op )
  {
    _.assert( arguments.length === 2 );
    if( op.onUp )
    {
      let r = op.onUp.call( self, record, op );
      _.assert
      (
        r === _.dont || r === record,
        () => `Callback onUp should return original record or _.dont, but returned ${_.entity.exportStringDiagnosticShallow( r )}`
      );
      return r;
    }
    return record;
  }

  /* - */

  function handleDown( record, op )
  {
    _.assert( arguments.length === 2 );
    if( op.onDown )
    {
      let r = op.onDown.call( self, record, op );
      _.assert
      (
        r === undefined,
        () => 'Callback onDown should return nothing( undefined ), but returned' + _.entity.exportStringDiagnosticShallow( r )
        // () => `Callback onDown should return nothing( undefined ), but returned ${_.entity.exportStringDiagnosticShallow( r )}`
        /* qqq : make global replacement by string-templates where it is appropriate */
      );
    }
  }

  /* - */

}

var defaults = filesFindNominal_body.defaults = Object.create( null );

defaults.sync = 1;
defaults.filePath = null;
defaults.filter = null;
defaults.factory = null;
defaults.onUp = null;
defaults.onDown = null;

var having = filesFindNominal_body.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.driving = 0;

let filesFindNominal = _.routine.uniteCloning_replaceByUnite( filesFindNominal_head, filesFindNominal_body );

//

function filesFindSingle_head( routine, args )
{
  let self = this;
  let path = self.path;

  let o = self._filesFindPrepare0( routine, args );
  self._filesFindFilterAbsorb( routine, [ o ] );
  self._filesFindPrepare1( routine, [ o ] );
  self._filesFindPrepare2( routine, [ o ] );

  if( !o.filter.formed || o.filter.formed < 5 )
  o.filter.form();
  _.assert( !!o.filter.effectiveProvider );
  o.filter.effectiveProvider._providerDefaultsApply( o );

  if( Config.debug )
  {
    _.routine.assertOptions( routine, o );
    _.assert( !self.system || o.filter.system === self.system );
    _.assert( !!o.filter.effectiveProvider );
    _.assert( _.routineIs( o.onUp ) || o.onUp === null );
    _.assert( _.routineIs( o.onDown ) || o.onDown === null );
    _.assert( path.isNormalized( o.filePath ), 'Expects normalized path {-o.filePath-}' );
    _.assert( path.isAbsolute( o.filePath ), 'Expects absolute path {-o.filePath-}' );
    _.assert( o.filter.formed === 5, 'Expects formed filter' );
    _.assert( _.object.isBasic( o.filter.effectiveProvider ) );
    _.assert( _.mapIs( o.filter.formedBasePath ), 'Expects base path' );
    _.assert( _.boolLike( o.withTerminals ) );
    _.assert( _.boolLike( o.withDirs ) );
    _.assert( _.boolLike( o.withStem ) );
    _.assert( !!o.filter.effectiveProvider );
    _.assert( o.filter.effectiveProvider instanceof _.FileProvider.Abstract );
    _.assert( o.filter.defaultProvider instanceof _.FileProvider.Abstract );
    _.assert( o.mandatory === undefined );
    _.assert( o.orderingExclusion === undefined );
    _.assert( o.outputFormat === undefined );
    _.assert( o.outputFormat === undefined );
    _.assert( o.safe === undefined );
    _.assert( o.maskPreset === undefined );
    _.assert( o.mode === undefined );
    _.assert( o.result === undefined );
    _.assert( !!o.factory );
  }

  return o;
}

//

function filesFindSingle_body( o )
{
  let self = this;
  let path = self.path;

  _.routine.assertOptions( filesFindSingle_body, arguments );

  let o2 = _.props.extend( null, o );
  delete o2.withTerminals;
  delete o2.withDirs;
  delete o2.withActual;
  delete o2.withTransient;
  delete o2.withStem;
  delete o2.withDefunct;
  delete o2.visitingCertain;

  o2.onUp = handleUp;
  o2.onDown = handleDown;

  let result = self.filesFindNominal.body.call( self, o2 );
  return result;

  /* - */

  function handleUp( record, op )
  {

    if( !o.visitingCertain && !record.isStem )
    {
      let hasMask = o.filter.hasMask();
      if( !hasMask )
      return _.dont;
    }

    let includingFile = record.isDir ? o.withDirs : o.withTerminals;
    let withTransient = ( o.withTransient && record.isTransient );
    let withActual = ( o.withActual && record.isActual );
    let included = true;
    included = included && ( withTransient || withActual );
    included = included && ( includingFile );
    included = included && ( o.withStem || !record.isStem );
    included = included && ( o.withDefunct || !!record.stat );
    included = included && ( o.withDefunct || record.isCycled !== true );
    included = included && ( o.withDefunct || record.isMissed !== true );
    record.included = included;

    _.assert( arguments.length === 2 );
    if( o.onUp )
    {
      let r = o.onUp.call( self, record, o );
      _.assert
      (
        r === _.dont || r === record,
        () => 'Callback onUp should return original record or _.dont, but returned' + _.entity.exportStringDiagnosticShallow( r )
      );
      return r;
    }
    return record;
  }

  /* - */

  function handleDown( record, op )
  {
    _.assert( arguments.length === 2 );
    if( o.onDown )
    {
      let r = o.onDown.call( self, record, o );
      _.assert
      (
        r === undefined,
        () => 'Callback onDown should return nothing( undefined ), but returned' + _.entity.exportStringDiagnosticShallow( r )
      );
    }
  }

}

_.assert( _.routineIs( filesFindNominal.body ) );
_.routineExtend( filesFindSingle_body, filesFindNominal.body );
_.assert( filesFindSingle_body.body === undefined );

var defaults = filesFindSingle_body.defaults = _.props.extend( null, filesFindSingle_body.defaults );

defaults.withTerminals = true;
defaults.withDirs = null;
defaults.withStem = true;
defaults.withDefunct = null;

defaults.withActual = true; /* xxx */
defaults.withTransient = false; /* xxx */
defaults.visitingCertain = true; /* xxx */

let filesFindSingle = _.routine.uniteCloning_replaceByUnite( filesFindSingle_head, filesFindSingle_body );

//

/**
 * @summary Searches for files in the specified path `o.filePath`.
 * @returns Returns flat array with FileRecord instances of found files.
 * @param {Object} o Options map.
 *
 * @param {*} o.filePath
 * @param {*} o.filter
 * @param {*} o.withTerminals=1
 * @param {*} o.withDirs=0
 * @param {*} o.withStem=1
 * @param {*} o.withActual=1
 * @param {*} o.withTransient=0
 * @param {*} o.allowingMissed=0
 * @param {*} o.allowingCycled=0
 * @param {Boolean} o.revisiting=null Controls how visited files are processed. Possible values:
 *  0 - visit and include each file once
 *  1 - visit and include each file once, break from loop on first links cycle and continue search ignoring file at which cycle begins
 *  2 - visit and include each file once, break from loop on first links cycle and continue search visiting file at which cycle begins
 *  3 - don't keep records of visited files
 *  Defaults: option o.revisiting in set to "1" if links resolving is enabled, otherwise default is "3".
 * @param {*} o.resolvingSoftLink=0
 * @param {*} o.resolvingTextLink=0
 * @param {*} o.maskPreset='default.exclude'
 * @param {*} o.outputFormat='record'
 * @param {*} o.safe=null
 * @param {*} o.sync=1
 * @param {*} o.orderingExclusion=[]
 * @param {*} o.sortingWithArray
 * @param {*} o.verbosity
 * @param {*} o.mandatory
 * @param {*} o.result=[]
 * @param {*} o.onUp=[]
 * @param {*} o.onDown=[]
 *
 * @function filesFind
 * @class wFileProviderFindMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function filesFind_head( routine, args )
{
  let self = this;
  let path = self.path;

  let o = self._filesFindPrepare0( routine, args );

  self._filesFindFilterAbsorb( routine, [ o ] );

  if( Config.debug )
  {

    _.assert( _.longHas( [ 'legacy', 'distinct' ], o.mode ), () => 'Unknown mode ' + _.strQuote( o.mode ) );

    if( 'outputFormat' in o )
    {
      // let knownFormats = [ 'absolute', 'relative', 'real', 'record', 'nothing' ];
      _.assert
      (
        // _.longHas( knownFormats, o.outputFormat ),
        !!self.FindOutputFormat[ o.outputFormat ],
        () => 'Unknown output format ' + _.entity.exportStringDiagnosticShallow( o.outputFormat )
        + '\nKnown output formats : ' + _.entity.exportString( _.props.keys( self.FindOutputFormat ) )
      );
    }

  }

  let hasGlob = o.filter.filePathHasGlob();

  if( o.mandatory === null )
  {
    if( o.mode === 'distinct' )
    o.mandatory = hasGlob;
    else
    o.mandatory = false;
  }

  if( o.result === null )
  o.result = [];

  if( o.maskPreset )
  {
    _.assert( o.maskPreset === 'default.exclude', 'Not supported preset', o.maskPreset );
    o.filter = o.filter || Object.create( null );
    if( !o.filter.formed || o.filter.formed < 5 )
    _.files.filterSafer( o.filter );
  }

  if( o.orderingExclusion === null )
  o.orderingExclusion = [];

  if( o.revisiting === null )
  if( o.resolvingSoftLink || o.resolvingTextLink )
  o.revisiting = 1;
  else
  o.revisiting = 3;

  _.assert( _.longHas( [ 0, 1, 2, 3 ], o.revisiting ) );
  _.assert( o.revisitingHardLinked === 0 || o.revisitingHardLinked === 1 );
  _.assert
  (
    o.revisitingHardLinked === 1 || self.SupportsIno >= 1,
    `Option revisitingHardLinked : 0 is supported only if file provider supports ino of file.`
    + `\nBut file provider ${self.constructor.name} does not support ino of file.`
  );

  if( o.revisiting === 0 )
  if( o.visitedMap === null )
  o.visitedMap = Object.create( null );

  if( o.revisitingHardLinked === 0 )
  if( o.visitedInosSet === null )
  o.visitedInosSet = new Set;

  if( o.revisiting === 1 || o.revisiting === 2 )
  if( o.visitedStack === null )
  o.visitedStack = [];

  self._filesFindPrepare1( routine, [ o ] );
  self._filesFindPrepare2( routine, [ o ] );

  if( !o.filter.formed || o.filter.formed < 5 )
  o.filter.form();
  _.assert( !!o.filter.effectiveProvider );
  o.filter.effectiveProvider._providerDefaultsApply( o );

  if( Config.debug )
  {
    _.assert( !self.system || o.filter.system === self.system );
    _.assert( !!o.filter.effectiveProvider );
  }

  return o;
}

function filesFind_body( o )
{
  let self = this;
  let path = self.path;
  let counter = 0;
  let ready = new _.Consequence().take( o );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.filePath === null );
  _.assert( o.filter.formed === 5 );
  _.assert( _.routineIs( o.onUp ) || o.onUp === null );
  _.assert( _.routineIs( o.onDown ) || o.onDown === null );

  let time;
  if( o.verbosity >= 1 )
  time = _.time.now();

  if( o.verbosity >= 3 )
  self.logger.log( 'filesFind', _.entity.exportString( o, { levels : 2 } ) );

  let pathMap = o.filter.formedFilePath;

  o.filePath = [];

  for( let src in pathMap )
  {
    let dst = pathMap[ src ];
    if( _.boolLike( dst ) )
    continue;
    o.filePath.push( src );
  }

  o.result = o.result || [];

  _.assert( _.strsAreAll( o.filePath ) );
  _.assert( !o.orderingExclusion.length || o.orderingExclusion.length === 0 || o.outputFormat === 'record' );

  if( o.mandatory )
  if( _.entity.lengthOf( o.filePath ) !== _.entity.lengthOf( o.filter.filePath ) )
  {
    for( let stemPath in o.filter.filePath )
    {
      if( _.boolLike( o.filter.filePath[ stemPath ] ) )
      continue;
      stemPath = path.fromGlob( stemPath );
      if( !self.fileExists( stemPath ) )
      throw _.err( 'Stem not found : ' + stemPath );
    }
  }

  forStems( o.filePath, o );

  return end();

  /* - */

  function forStems( stemPaths, op )
  {

    if( _.strIs( stemPaths ) )
    stemPaths = [ stemPaths ];
    stemPaths = _.longOnce( stemPaths );
    _.strsSort( stemPaths );
    _.assert( _.arrayIs( stemPaths ), 'Expects path or array of paths' );

    let o2 = Object.assign( Object.create( null ), op );

    delete o2.orderingExclusion;
    delete o2.sortingWithArray;
    delete o2.verbosity;
    delete o2.mode;
    delete o2.maskPreset;
    delete o2.mandatory;
    delete o2.outputFormat;
    delete o2.safe;
    delete o2.revisiting;
    delete o2.revisitingHardLinked;
    delete o2.visitedMap;
    delete o2.visitedStack;
    delete o2.visitedInosSet;
    delete o2.result;
    delete o2.resolvingSoftLink;
    delete o2.resolvingTextLink;
    delete o2.allowingMissed;
    delete o2.allowingCycled;

    o2.onUp = onUp_functor( op );
    o2.onDown = onDown_functor( op );

    for( let p = 0 ; p < stemPaths.length ; p++ ) ready.then( () =>
    {
      let stemPath = stemPaths[ p ];
      return forStem( stemPath, o2 )
    })

  }

  /* - */

  function forStem( stemPath, o2 )
  {
    let o3 = Object.assign( Object.create( null ), o2 );

    _.assert( _.strIs( stemPath ) );

    o3.filePath = stemPath;

    let o4 =
    {
      stemPath,
      basePath : o2.filter.formedBasePath[ stemPath ],
      resolvingSoftLink : o.resolvingSoftLink,
      resolvingTextLink : o.resolvingTextLink,
      allowingMissed : o.allowingMissed,
      allowingCycled : o.allowingCycled,
      safe : o.safe,
    };
    _.assert( _.strDefined( o4.basePath ), 'No base path for', stemPath );
    o3.factory = _.files.FileRecordFactory.TolerantFrom( o3, o4 ).form();

    _.assert( o3.factory.basePath === o3.filter.formedBasePath[ stemPath ] );
    _.assert( o3.factory.dirPath === null );
    _.assert( o3.factory.effectiveProvider === o3.filter.effectiveProvider );
    _.assert( o3.factory.system === o3.filter.system || o3.filter.system === null );
    _.assert( o3.factory.defaultProvider === o3.filter.defaultProvider );

    let counterWas = counter;

    return _.Consequence.Try( () =>
    {
      let r = self.filesFindSingle.body.call( self, o3 );
      return r;
    })
    .then( ( op ) =>
    {
      if( !o.mandatory )
      return op;

      if( o.result.length === 0 )
      {
        debugger;
        throw _.err( 'No file found at ' + stemPath );
      }
      else if( counterWas === counter )
      {
        if( !o.allowingMissed )
        {
          debugger;
          throw _.err( 'Stem does not exist ' + stemPath );
        }
      }

      return op;
    })
    .catch( ( err ) =>
    {
      debugger;
      throw _.err( err );
    });

  }

  /* - */

  function handleUp( record, op )
  {

    _.assert( arguments.length === 2, 'Expects single argument' );

    if( record.stat )
    counter += 1;

    let visited = false;

    if( o.visitedInosSet && record.stat )
    {
      _.assert( record.stat && self.isIno({ ino : record.stat.ino }) );
      if( o.visitedInosSet.has( record.stat.ino ) )
      return _.dont;
    }

    if( o.revisiting === 1 )
    {
      if( _.longHas( o.visitedStack, record.real ) )
      visited = true;
      o.visitedStack.push( record.real );
      if( visited )
      return _.dont;
    }
    else if( o.revisiting === 2 )
    {
      if( _.longHas( o.visitedStack, record.real ) )
      visited = true;
      o.visitedStack.push( record.real );
    }
    else if( o.visitedStack )
    {
      o.visitedStack.push( record.real );
    }

    if( o.revisiting === 0 )
    {
      if( o.visitedMap[ record.real ] )
      return _.dont;
    }

    if( o.onUp )
    {
      let r = o.onUp.call( self, record, o );
      _.assert
      (
        r === _.dont || r === record,
        () => 'Callback onUp should return original record or _.dont, but returned' + _.entity.exportStringDiagnosticShallow( r )
      );
      if( r === _.dont )
      return _.dont;
    }

    if( o.visitedMap )
    o.visitedMap[ record.real ] = record;

    if( o.visitedInosSet && record.stat )
    {
      _.assert( self.isIno({ ino : record.stat.ino }) );
      o.visitedInosSet.add( record.stat.ino );
    }

    if( visited )
    return 'dontButRecord';

    return record;
  }

  /* - */

  function handleDown( record, op )
  {

    if( o.revisiting === 1 )
    {
      _.assert( o.visitedStack[ o.visitedStack.length - 1 ] === record.real );
      o.visitedStack.pop();
      if( _.longHas( o.visitedStack, record.real ) )
      return;
    }
    else if( o.revisiting === 2 )
    {
      _.assert( o.visitedStack[ o.visitedStack.length - 1 ] === record.real );
      o.visitedStack.pop();
    }
    else if( o.visitedStack )
    {
      _.assert( o.visitedStack[ o.visitedStack.length - 1 ] === record.real );
      o.visitedStack.pop();
    }

    if( o.revisiting === 0 )
    {
      if( o.visitedMap[ record.real ] !== record )
      return;
    }

    if( o.onDown )
    {
      let r = o.onDown.call( self, record, o );
      _.assert
      (
        r === undefined,
        () => 'Callback onDown should return undefined' + _.entity.exportStringDiagnosticShallow( r )
      );
    }

  }

  /* - */

  function onUp_functor( fop )
  {
    let recordAdd;

    if( fop.outputFormat === 'absolute' )
    recordAdd = function addAbsolute( record, op )
    {
      let r = handleUp.apply( this, arguments );
      if( r === _.dont )
      return _.dont;
      if( record.included )
      fop.result.push( record.absolute );
      if( r === record )
      return record;
      else
      return _.dont;
    }
    else if( fop.outputFormat === 'relative' )
    recordAdd = function addRelative( record, op )
    {
      let r = handleUp.apply( this, arguments );
      if( r === _.dont )
      return _.dont;
      if( record.included )
      fop.result.push( record.relative );
      if( r === record )
      return record;
      else
      return _.dont;
    }
    else if( fop.outputFormat === 'real' )
    recordAdd = function addReal( record, op )
    {
      let r = handleUp.apply( this, arguments );
      if( r === _.dont )
      return _.dont;
      if( record.included )
      fop.result.push( record.real );
      if( r === record )
      return record;
      else
      return _.dont;
    }
    else if( fop.outputFormat === 'record' )
    recordAdd = function addRecord( record, op )
    {
      let r = handleUp.apply( this, arguments );
      if( r === _.dont )
      return _.dont;
      if( record.included )
      fop.result.push( record );
      if( r === record )
      return record;
      else
      return _.dont;
    }
    else if( fop.outputFormat === 'nothing' )
    recordAdd = function addNothing( record, op )
    {
      let r = handleUp.apply( this, arguments );
      if( r === _.dont )
      return _.dont;
      if( r === record )
      return record;
      else
      return _.dont;
    }
    else _.assert( 0, 'Unknown output format :', o.outputFormat );

    return recordAdd;
  }

  /* - */

  function onDown_functor( fop )
  {
    return handleDown;
  }

  /* - */

  function end()
  {
    ready.then( () =>
    {

      /* order */

      o.result = self.recordsOrder( o.result, o.orderingExclusion );

      /* sort */

      if( o.sortingWithArray )
      {

        _.assert( _.arrayIs( o.sortingWithArray ) );

        if( o.outputFormat === 'record' )
        o.result.sort( function( a, b )
        {
          return _.regexpArrayIndex( o.sortingWithArray, a.relative ) - _.regexpArrayIndex( o.sortingWithArray, b.relative );
        })
        else
        o.result.sort( function( a, b )
        {
          return _.regexpArrayIndex( o.sortingWithArray, a ) - _.regexpArrayIndex( o.sortingWithArray, b );
        });

      }

      /* mandatory */

      if( o.mandatory )
      if( !o.result.length )
      {
        debugger;
        throw _.err( 'No file found at ' + path.commonTextualReport( o.filter.filePath || o.filePath ) );
      }

      /* timing */

      if( o.verbosity >= 1 )
      self.logger.log( ' . Found ' + o.result.length + ' files at ' + o.filePath + ' in ', _.time.spent( time ) );

      return o.result;
    });

    if( o.sync )
    return ready.sync();
    else
    return ready;
  }

}

_.assert( filesFindSingle.body.body === undefined );
_.assert( filesFind_body.body === undefined );
_.routineExtend( filesFind_body, filesFindSingle.body );
_.assert( filesFindSingle.body.body === undefined );
_.assert( filesFind_body.body === undefined );

var defaults = filesFind_body.defaults = _.props.extend( null, filesFind_body.defaults );

delete defaults.factory;

defaults.sync = 1;
defaults.orderingExclusion = null;
defaults.sortingWithArray = null;
defaults.verbosity = null;
defaults.mandatory = null;
defaults.safe = null;
defaults.maskPreset = 'default.exclude';
defaults.outputFormat = 'record';
defaults.result = null;
defaults.mode = 'legacy'; /* qqq2 : xxx : change to distinct */
defaults.revisiting = null;
defaults.revisitingHardLinked = 1;
defaults.visitedMap = null;
defaults.visitedStack = null;
defaults.visitedInosSet = null;
defaults.resolvingSoftLink = 0;
defaults.resolvingTextLink = 0;
defaults.allowingMissed = 0;
defaults.allowingCycled = 0;

_.assert( defaults.maskAll === undefined );
_.assert( defaults.glob === undefined );

_.assert( filesFind_body.body === undefined );
let filesFind = _.routine.uniteCloning_replaceByUnite( filesFind_head, filesFind_body );
_.assert( filesFind_body.body === undefined );

filesFind.having.aspect = 'entry';

//

/**
 * @description Short-cut for {@link module:Tools/mid/Files.wTools.FileProvider.FindMixin.filesFind}.
 * Performs recursive search for files from specified path `o.filePath`.
 * Includes terminals,directories and transient files into the result array.
 * @param {Object} o Options map.
 *
 * @param {*} o.filePath
 * @param {*} o.filter
 * @param {*} o.withTerminals=1
 * @param {*} o.withDirs=1
 * @param {*} o.withStem=1
 * @param {*} o.withActual=1
 * @param {*} o.withTransient=1
 * @param {*} o.allowingMissed=1
 * @param {*} o.allowingCycled=1
 * @param {*} o.resolvingSoftLink=0
 * @param {*} o.resolvingTextLink=0
 * @param {*} o.maskPreset='default.exclude'
 * @param {*} o.outputFormat='record'
 * @param {*} o.safe=null
 * @param {*} o.sync=1
 * @param {*} o.orderingExclusion=[]
 * @param {*} o.sortingWithArray
 * @param {*} o.verbosity
 * @param {*} o.mandatory
 * @param {*} o.result=[]
 * @param {*} o.onUp=[]
 * @param {*} o.onDown=[]
 *
 * @function filesFindRecursive
 * @class wFileProviderFindMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function filesFindRecursive_head( routine, args )
{
  let self = this;
  let o = self._filesFindPrepare0( routine, args );
  // self._filesFindFilterAbsorb( routine, [ o ] );
  if( o.filter.recursive === undefined || o.filter.recursive === null )
  o.filter.recursive = 2;
  return self.filesFind.head.call( self, routine, [ o ] );
}

let filesFindRecursive = _.routine.uniteCloning_replaceByUnite( filesFindRecursive_head, filesFind.body );

var defaults = filesFindRecursive.defaults;
defaults.filePath = null;
// defaults.recursive = 2;
defaults.withTransient = 0;
defaults.withDirs = 1;
defaults.withTerminals = 1;
defaults.allowingMissed = 1;
defaults.allowingCycled = 1;

//

/**
 * @description Short-cut for {@link module:Tools/mid/Files.wTools.FileProvider.FindMixin.filesFind}.
 * Performs recursive search for files using glob pattern `o.filePath` using glob pattern.
 * Includes terminals,directories into the result array.
 * @param {Object} o Options map.
 *
 * @param {*} o.filePath
 * @param {*} o.filter
 * @param {*} o.withTerminals=1
 * @param {*} o.withDirs=1
 * @param {*} o.withStem=1
 * @param {*} o.withActual=1
 * @param {*} o.withTransient=0
 * @param {*} o.allowingMissed=0
 * @param {*} o.allowingCycled=0
 * @param {*} o.resolvingSoftLink=0
 * @param {*} o.resolvingTextLink=0
 * @param {*} o.maskPreset='default.exclude'
 * @param {*} o.outputFormat='absolute'
 * @param {*} o.safe=null
 * @param {*} o.sync=1
 * @param {*} o.orderingExclusion=[]
 * @param {*} o.sortingWithArray
 * @param {*} o.verbosity
 * @param {*} o.mandatory
 * @param {*} o.result=[]
 * @param {*} o.onUp=[]
 * @param {*} o.onDown=[]
 *
 * @function filesGlob
 * @class wFileProviderFindMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function filesGlob( o )
{
  let self = this;

  if( _.strIs( o ) )
  o = { filePath : o }

  // if( o.recursive === undefined )
  // o.recursive = 2;

  o.filter = o.filter || Object.create( null );

  if( o.filter.recursive === undefined || o.filter.recursive === null )
  o.filter.recursive = 2;

  if( !o.filePath && !o.filter.filePath )
  {
    o.filter.filePath = o.filter.recursive === 2 ? '**' : '*';
    // o.filter.filePath = o.recursive === 2 ? '**' : '*';
  }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.object.isBasic( o ) );

  let result = self.filesFind( o );

  return result;
}

_.routineExtend( filesGlob, filesFind );

var defaults = filesGlob.defaults;

// defaults.outputFormat = 'absolute';
// defaults.recursive = 2;
defaults.withTerminals = 1;
defaults.withDirs = 1;
defaults.withTransient = 0;

//

/**
 * @description Functor for {@link module:Tools/mid/Files.wTools.FileProvider.FindMixin.filesFind} routine.
 * Creates a filesFind routine with options saved in inner context.
 * It allows to reuse created routine changing only necessary options and don't worry about other options.
 * @param {Object} o Options map. Please see {@link module:Tools/mid/Files.wTools.FileProvider.FindMixin.filesFind} for options description.
 * @function filesFinder
 * @class wFileProviderFindMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function filesFinder_functor( routine )
{

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( routine ) );
  _.routineExtend( finder, routine );
  return finder;

  function finder()
  {
    let self = this;
    let path = self.path;
    let op0 = self._filesFindPrepare0( routine, arguments );
    _.map.assertHasOnly( op0, finder.defaults );
    return er;

    function er()
    {
      let o = _.props.extend( null, op0 );
      o.filter = self.recordFilter( o.filter );
      if( o.filePath )
      {
        o.filter.filePath = path.mapExtend( o.filter.filePath, o.filePath );
        o.filePath = null;
      }

      for( let a = 0 ; a < arguments.length ; a++ )
      {
        let op2 = arguments[ a ];

        if( !_.object.isBasic( op2 ) )
        op2 = { filePath : op2 }

        op2.filter = self.recordFilter( op2.filter || Object.create( null ) );

        if( op2.filePath )
        {
          op2.filter.filePath = path.mapExtend( op2.filter.filePath, op2.filePath );
          op2.filePath = null;
        }

        o.filter.and( op2.filter );
        o.filter.pathsExtendJoining( op2.filter );
        // o.filter.pathsJoin( op2.filter );

        op2.filter = o.filter;
        op2.filePath = o.filePath;

        _.props.extend( o, op2 );

      }

      // debugger;
      return routine.call( self, o );
    }

  }

}

let filesFinder = filesFinder_functor( filesFind );
let filesGlober = filesFinder_functor( filesGlob );

// --
// files find groups
// --

function filesFindGroups_head( routine, args )
{
  let self = this;
  let o = self._preFileFilterWithoutProviderDefaults.apply( self, arguments );
  return o;
}

//

/*
qqq : filesFindGroups requires tests

don't forget option mandatory

*/

function filesFindGroups_body( o )
{
  let self = this;
  let path = self.path;
  let ready = new _.Consequence();

  _.assert( o.src.formed === 3 );
  _.assert( o.dst.formed === 3 );

  let r = Object.create( null );
  r.options = o;
  r.pathsGrouped = path.mapGroupByDst( o.src.filePath );
  r.filesGrouped = Object.create( null );
  r.srcFiles = Object.create( null );
  r.errors = [];

  /* */

  for( let dstPath in r.pathsGrouped ) ( function( dstPath )
  {
    let srcPath = r.pathsGrouped[ dstPath ];
    let o2 = _.mapOnly_( null, o, self.filesFind.body.defaults );

    ready.finallyGive( 1 );

    o2.result = [];
    o2.filter = o.src.clone();
    o2.filter.filePathSelect( srcPath, dstPath );
    _.assert( o2.filter.formed === 3 );

    _.Consequence.Try( () => self.filesFind( o2 ) )
    .finally( ( err, files ) =>
    {

      if( err )
      {
        r.errors.push( err );
      }
      else
      {
        r.filesGrouped[ dstPath ] = files;
        files.forEach( ( file ) =>
        {
          if( _.strIs( file ) )
          r.srcFiles[ file ] = file;
          else
          r.srcFiles[ file.absolute ] = file;
        });
      }

      ready.take( null );
      return null;
    });

  })( dstPath );

  /* */

  ready.take( null );
  ready.finally( () =>
  {
    if( r.errors.length )
    {
      r.errors.forEach( ( err, index ) => index > 0 ? _.errAttend( err ) : null ); /* yyy */
      if( o.throwing )
      throw r.errors[ 0 ];
      // throw _.err.apply( _, r.errors )
    }
    return r;
  });


  if( o.sync )
  return ready.sync();
  return ready;
  // return ready.syncMaybe();
}

var defaults = filesFindGroups_body.defaults = _.props.extend( null, filesFind.defaults );

delete defaults.filePath;
delete defaults.filter;

defaults.src = null;
defaults.dst = null;
defaults.sync = 1;
defaults.throwing = null;
defaults.mode = 'distinct';

//

let filesFindGroups = _.routine.uniteCloning_replaceByUnite( filesFindGroups_head, filesFindGroups_body );

//

function filesReadGroups_head( routine, args )
{
  let self = this;

  // debugger;

  let o = self._preFileFilterWithoutProviderDefaults.apply( self, arguments );

  // debugger;

  return o;
}

function filesReadGroups_body( o )
{
  let self = this;
  let path = self.path;
  let ready = self.filesFindGroups( o );
  let r;

  _.assert( o.src.formed === 3 );

  /* */

  ready = _.Consequence.From( ready );

  ready.then( ( result ) =>
  {
    r = result;
    r.dataMap = Object.create( null );
    r.grouped = Object.create( null );

    for( let dstPath in r.filesGrouped )
    {
      let files = r.filesGrouped[ dstPath ];
      for( let f = 0 ; f < files.length ; f++ )
      fileRead( files[ f ], dstPath );
    }

    return r;
  });

  if( o.sync )
  return ready.sync();
  return ready;

  /* */

  function fileRead( record, dstPath )
  {
    let descriptor = r.grouped[ dstPath ];

    if( !descriptor )
    {
      descriptor = r.grouped[ dstPath ] = Object.create( null );
      descriptor.dstPath = dstPath;
      descriptor.pathsGrouped = r.pathsGrouped[ dstPath ];
      descriptor.filesGrouped = r.filesGrouped[ dstPath ];
      descriptor.dataMap = Object.create( null );
    }

    try
    {
      r.dataMap[ record.absolute ] = self.fileRead({ filePath : record.absolute, sync : o.sync });
      ready.finallyGive( 1 );
      _.Consequence.From( r.dataMap[ record.absolute ] )
      .finally( ( err, data ) =>
      {
        if( err )
        {
          r.errors.push( err );
          return null;
        }
        r.dataMap[ record.absolute ] = data;
        descriptor.dataMap[ record.absolute ] = data;
        return null;
      })
      .finally( ready );
    }
    catch( err )
    {
      r.errors.push( err );
    }

  }

}

filesReadGroups_body.defaults = Object.create( filesFindGroups.defaults );

let filesReadGroups = _.routine.uniteCloning_replaceByUnite( filesReadGroups_head, filesReadGroups_body );

// --
//
// --

function _filesFiltersPrepare( routine, o )
{
  let self = this;

  _.assert( arguments.length === 2 );

  /* */

  if( o.src === undefined || o.src === null )
  o.src = o.filter;

  o.src = self.recordFilter( o.src );
  o.dst = self.recordFilter( o.dst );

  o.src.pairWithDst( o.dst );
  o.src.pairRefineLight();

  if( o.filter ) /* qqq : cover please */
  {
    o.src.and( o.filter ).pathsSupplement( o.filter );
    o.dst.and( o.filter ).pathsSupplement( o.filter );
  }

  if( o.src.recursive === null )
  o.src.recursive = 2;
  o.dst.recursive = 2;

  /* */

  _.assert( _.object.isBasic( o.src ) );
  _.assert( _.object.isBasic( o.dst ) );
  _.assert( o.src.formed <= 1 );
  _.assert( o.dst.formed <= 1 );
  _.assert( _.object.isBasic( o.src.defaultProvider ) );
  _.assert( _.object.isBasic( o.dst.defaultProvider ) );
  _.assert( !( o.src.effectiveProvider instanceof _.FileProvider.System ) );
  _.assert( !( o.dst.effectiveProvider instanceof _.FileProvider.System ) );
  _.assert( o.srcProvider === undefined );
  _.assert( o.dstProvider === undefined );
  _.assert( o.dst.recursive === 2 );

}

//

function _filesReflectPrepare( routine, args )
{
  let self = this;
  let o = args[ 0 ];

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( args.length === 1 || args.length === 2 );

  if( args.length === 2 )
  o = { dst : args[ 0 ], src : args[ 1 ] }

  _.routine.options_( routine, o );
  self._providerDefaultsApply( o );

  if( o.onUp )
  o.onUp = _.routinesComposeAll( o.onUp );
  if( o.onDown )
  o.onDown = _.routinesComposeReturningLast( o.onDown );

  if( o.result === null )
  o.result = [];

  if( o.includingDst === null || o.includingDst === undefined )
  o.includingDst = o.dstDeleting;

  self._filesFiltersPrepare( routine, o );

  _.assert( o.srcPath === undefined );
  _.assert( o.dstPath === undefined );
  _.assert( o.src.isPaired( o.dst ) );
  _.assert( !o.dstDeleting || !!o.includingDst );
  _.assert( o.onDstName === null || _.routineIs( o.onDstName ) );
  _.assert( _.boolLike( o.includingDst ) );
  _.assert( _.boolLike( o.dstDeleting ) );
  _.assert( _.arrayIs( o.result ) );
  _.assert( _.routineIs( o.onUp ) || o.onUp === null );
  _.assert( _.routineIs( o.onDown ) || o.onDown === null );
  // _.assert( _.longHas( [ 'fileCopy', 'hardLink', 'hardLinkMaybe', 'softLink', 'softLinkMaybe', 'textLink', 'nop' ], o.linkingAction ), 'unknown kind of linkingAction', o.linkingAction );
  _.assert( !!self.ReflectAction[ o.linkingAction ], () => 'Unknown kind of linkingAction' + o.linkingAction );

  return o;
}

//

function filesReflectEvaluate_head( routine, args )
{
  let self = this;
  let o = self._filesReflectPrepare( routine, args );

  _.assert( o.filter === undefined );
  _.assert( o.rebasingLink === undefined );

  return o;
}

//

function filesReflectEvaluate_body( o )
{
  let self = this;
  let actionMap = Object.create( null );
  let touchMap = Object.create( null );
  let dstDeleteMap = Object.create( null );
  let recordAdd = recordAdd_functor( o );
  let recordRemove = recordRemove_functor( o );
  let dstPath = o.dst.filePathSimplest( o.dst.filePathNormalizedGet() );

  _.routine.assertOptions( filesReflectEvaluate_body, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( dstPath ) );
  _.assert( o.outputFormat === undefined );

  let srcOptions = srcOptionsForm();
  let dstOptions = dstOptionsForm();
  let dstRecordFactory = dstFactoryForm();
  let dst = o.dst.effectiveProvider;
  let src = o.src.effectiveProvider;

  _.assert( o.dst.system.hasProvider( o.dst.effectiveProvider ), 'System should have destination and source file providers' );
  _.assert( o.src.system.hasProvider( o.src.effectiveProvider ), 'System should have destination and source file providers' );
  _.assert( o.dst.system === o.src.system, 'System should have the same destination and source system' );
  _.assert( o.dst.effectiveProvider === dstRecordFactory.effectiveProvider );
  _.assert( o.dst.defaultProvider === dstRecordFactory.defaultProvider );
  _.assert( o.dst.system === dstRecordFactory.system || o.dst.system === null );
  _.assert( !!o.dst.effectiveProvider );
  _.assert( !!o.dst.defaultProvider );
  _.assert( !!o.src.effectiveProvider );
  _.assert( !!o.src.defaultProvider );
  _.assert( o.dst.effectiveProvider instanceof _.FileProvider.Abstract );
  _.assert( o.src.effectiveProvider instanceof _.FileProvider.Abstract );
  _.assert( dst.path.isAbsolute( dstPath ) );
  _.assert( o.src.isPaired( o.dst ) );
  _.assert( src.path.s.allAreNormalized( o.src.filePath ) );
  _.assert( dst.path.isNormalized( dstPath ) );
  _.assert( _.boolLike( o.mandatory ) );

  /* find */

  let found = self.filesFind( srcOptions );
  o.visitedMap = srcOptions.visitedMap;

  return o.result;

  /* src options */

  function srcOptionsForm()
  {

    if( !o.src.formed || o.src.formed < 5 )
    {
      o.src.system = o.src.system || self;
      o.src.form();
    }

    _.assert( o.srcPath === undefined );
    _.assert( o.dstPath === undefined );

    let srcOptions = _.mapOnly_( null, o, self.filesFind.defaults );
    srcOptions.withStem = 1;
    srcOptions.withTransient = 1;
    srcOptions.withDefunct = 1;
    srcOptions.allowingMissed = 1;
    srcOptions.allowingCycled = 1;
    srcOptions.verbosity = 0;
    srcOptions.maskPreset = 0;
    srcOptions.filter = o.src;
    srcOptions.result = null;
    srcOptions.onUp = [ handleSrcUp ];
    srcOptions.onDown = [ handleSrcDown ];

    return srcOptions;
  }

  /* dst options */

  function dstOptionsForm()
  {

    if( o.dst.formed < 5 )
    {
      o.dst.system = o.dst.system || self;
      o.dst.recursive = 2;
      o.dst.form();
    }

    _.assert( o.dst.basePath === null || _.object.isBasic( o.dst.basePath ) );
    _.assert( _.object.isBasic( o.dst.formedBasePath ) );
    _.assert( !!o.dst.effectiveProvider );
    _.assert( !!o.dst.defaultProvider );

    let dstOptions = _.props.extend( null, srcOptions );
    dstOptions.filter = o.dst;
    dstOptions.filePath = o.dst.filePathSimplest( o.dst.filePathNormalizedGet() );
    dstOptions.withStem = 1;
    dstOptions.revisiting = 3;
    dstOptions.resolvingSoftLink = 0;
    dstOptions.resolvingTextLink = 0;
    dstOptions.maskPreset = 0;
    dstOptions.verbosity = 0;
    dstOptions.result = null;
    dstOptions.onUp = [];
    dstOptions.onDown = [ handleDstDown ];

    _.assert( _.strIs( dstOptions.filePath ) );

    return dstOptions;
  }

  /* dst factory */

  function dstFactoryForm()
  {

    _.assert( _.strIs( dstPath ) );
    let dstOp =
    {
      basePath : o.dst.formedBasePath[ dstPath ] ? o.dst.formedBasePath[ dstPath ] : dstPath,
      stemPath : dstPath,
      filter : o.dst,
      allowingMissed : 1,
      allowingCycled : 1,
    }

    if( _.arrayIs( dstOp.stemPath ) && dstOp.stemPath.length === 1 )
    dstOp.stemPath = dstOp.stemPath[ 0 ];

    _.assert( !!dstOp.basePath, () => 'No base path for ' + _.strQuote( dstPath ) );
    let dstRecordFactory = _.files.FileRecordFactory.TolerantFrom( o, dstOp ).form();

    _.assert( _.strIs( dstOp.basePath ) );
    _.assert
    (
      dstRecordFactory.basePath === _.uri.parse( dstPath ).longPath
      || dstRecordFactory.basePath === _.uri.parse( o.dst.formedBasePath[ dstPath ] ).longPath
    );

    return dstRecordFactory;
  }

  /* add record to result array */

  function recordAdd_functor( o )
  {
    let routine;

    routine = function add( record )
    {
      _.assert( arguments.length === 1, 'Expects single argument' );
      _.assert( record.include === true );
      o.result.push( record );
    }

    return routine;
  }

  /* remove record from result array */

  function recordRemove_functor( o )
  {
    let routine;

    routine = function remove( record )
    {
      _.assert( arguments.length === 1, 'Expects single argument' );
      _.arrayRemoveElementOnceStrictly( o.result, record );
    }

    return routine;
  }

  /* */

  function recordMake( dstRecord, srcRecord, effectiveRecord )
  {
    _.assert( dstRecord === effectiveRecord || srcRecord === effectiveRecord );
    let record = Object.create( null );
    record.dst = dstRecord;
    record.src = srcRecord;
    record.effective = effectiveRecord;
    record.goingUp = true;
    record.upToDate = false;
    record.srcAction = null;
    record.srcAllow = true;
    record.reason = null;
    record.action = null;
    record.allow = true;
    record.preserve = false;
    record.deleteFirst = false;
    record.touch = false;
    record.include = true;

    dstRecord.associated = record;
    srcRecord.associated = record;

    return record;
  }

  /* */

  function handleUp( record, op )
  {

    if( touchMap[ record.dst.absolute ] )
    touch( record, touchMap[ record.dst.absolute ] );
    _.assert( touchMap[ record.dst.absolute ] === record.touch || !record.touch );

    _.sure( !_.strBegins( record.dst.absolute, '/../' ), () => 'Destination path ' + _.strQuote( record.dst.absolute ) + ' leads out of file system.' );

    if( !record.src.isActual && !record.dst.isActual )
    {
      if( !record.src.isDir && !record.dst.isDir )
      return end( false );
    }

    if( !o.includingDst && record.reason === 'dstDeleting' )
    return end( record );

    if( !o.withDirs && record.effective.isDir )
    return end( record );

    if( !o.withTerminals && !record.effective.isDir )
    return end( record );

    _.assert( _.routineIs( o.onUp ) || o.onUp === null );
    _.assert( arguments.length === 2 );

    let result = true;
    if( o.onUp )
    {
      let r = o.onUp.call( self, record, o );
      if( r === _.dont )
      return end( false );
    }

    handleUp2.call( self, record, o );

    return end( record );

    function end( result )
    {
      if( result && record.include && ( o.includingNonAllowed || record.allow ) )
      {
        recordAdd( record );
      }
      else
      {
        record.include = false;
      }
      return result;
    }

  }

  /* */

  function handleUp2( record, op )
  {

    // if( _.strEnds( record.dst.absolute, debugPath ) )
    // debugger;

    let a = actionMap[ record.dst.absolute ];
    let t = touchMap[ record.dst.absolute ];

    if( !o.writing )
    record.allow = false;

    if( record.reason !== 'srcLooking' && a )
    {
      record.include = false;
      return record
    }

    // if( _.strEnds( record.dst.absolute, debugPath ) )
    // debugger;

    _.assert( arguments.length === 2 );

    if( !record.src.stat )
    {
      /* src does not exist or is not actual */

      // if( 0 )
      // if( o.mandatory )
      // if( record.src.isStem )
      // throw _.err
      // (
      //   `Stem file does not exist: ${_.strQuote( record.src.absolute )}` +
      //   `\nTo fix it you may set option mandatory to false or exclude the file from filePath of source filter`
      // );

      if( record.reason === 'dstDeleting' && !record.dst.isActual )
      {
      }
      else if( record.reason === 'srcLooking' && record.dst.isActual && record.dst.isDir && !record.src.isActual && record.src.stat )
      {
        record.include = false;
      }
      else if( ( !record.dst.stat && !record.src.isDir ) || ( record.dst.isTerminal && !record.dst.isActual ) )
      {
        record.include = false;
      }

    }
    else if( record.src.isDir )
    {

      if( !record.dst.stat )
      {
        /* src is dir, dst does not exist */

      }
      else if( record.dst.isDir )
      {
        /* both src and dst are dir */

        if( record.reason === 'srcLooking' && record.dst.isActual && !record.src.isActual && !record.src.isTransient )
        {
          debugger;
          record.include = false;
          dstDelete( record, op );
        }

      }
      else
      {
        /* src is dir, dst is terminal */

        if( !record.dst.isActual )
        record.include = false;

        if( !record.src.isActual && record.dst.isActual )
        {
        }
        else if( !record.dst.isActual )
        {
          record.goingUp = false;
          ignore( record );
        }
        else if( !o.dstRewriting || !o.dstRewritingByDistinct )
        {
          record.goingUp = false;
          record.allow = false;
          dirMake( record );
          preserve( record );
          forbid( record );
        }
        else
        {
          record.deleteFirst = true;
          dirMake( record );
        }

      }

    }
    else
    {

      if( !record.dst.stat )
      {
        /* src is terminal, dst does not exist */

        /* checks if terminals with equal dst path are same before link */
        if( record.src.isTerminal )
        if( o.writing && o.dstRewriting && o.dstRewritingOnlyPreserving && a )
        checkSrcTerminalsSameDst( record, op );

        link( record );

      }
      else if( record.dst.isDir )
      {
        /* src is terminal, dst is dir */

        if( !record.src.isActual && record.reason !== 'dstDeleting' )
        {
          record.include = false;
        }
        else if( record.src.isActual )
        {
          record.deleteFirst = true;
        }

      }
      else
      {
        /* both src and dst are terminals */

        if( record.src.isActual )
        {

          if( shouldPreserve( record ) )
          record.preserve = true;

          if( !o.writing )
          record.allow = false;

          if( !o.dstRewriting )
          {
            forbid( record );
          }

          link( record );

        }
        else
        {

          if( record.reason !== 'srcLooking' && o.dstDeleting )
          fileDelete( record );
          else
          record.include = false;

        }

      }

    }

    return record;
  }

  /* */

  function handleDown( record, op )
  {

    // if( _.strEnds( record.dst.absolute, debugPath ) )
    // debugger;

    if( touchMap[ record.dst.absolute ] )
    touch( record, touchMap[ record.dst.absolute ] );
    _.assert( touchMap[ record.dst.absolute ] === record.touch || !record.touch );

    let srcExists = !!record.src.stat;
    let dstExists = !!record.dst.stat;

    _.assert( !!record.dst && !!record.src );
    _.assert( arguments.length === 2 );

    if( !record.include )
    return end( false );

    if( !record.src.isActual && !record.src.isDir && record.reason === 'srcLooking' )
    return end( false );

    if( !o.includingDst && record.reason === 'dstDeleting' )
    return end( record );

    if( !o.withDirs && record.effective.isDir )
    return end( record );

    if( !o.withTerminals && !record.effective.isDir )
    return end( record );

    handleDown2.call( self, record, o );
    if( o.onDown )
    {
      let r = o.onDown.call( self, record, o );
      _.assert
      (
        r === undefined,
        () => 'Callback onDown should return nothing( undefined ), but returned ' + _.entity.exportStringDiagnosticShallow( r )
      );
    }

    _.assert( record.action !== 'exclude' || record.touch === false, () => 'Attempt to exclude touched ' + record.dst.absolute );

    if( record.action === 'exclude' )
    return end( false );

    _.assert( touchMap[ record.dst.absolute ] === record.touch || !record.touch );

    if( !srcExists && record.reason === 'srcLooking' )
    return end( false );

    if( !record.src.isActual && !record.dst.isActual && !record.touch )
    return end( false );

    if( !o.includingNonAllowed && !record.allow )
    return end( false );

    return end( record.touch );

    function end( result )
    {
      if( result === false )
      {
        if( record.include )
        recordRemove( record );
        record.include = false;
      }
      return result;
    }
  }

  /* */

  function handleDown2( record, op )
  {

    // if( _.strEnds( record.dst.absolute, debugPath ) )
    // debugger;

    _.assert( arguments.length === 2 );
    _.assert( !!record.touch === !!touchMap[ record.dst.absolute ] );

    if( record.reason === 'srcLooking' )
    {
      if( !record.src.isActual || !record.src.stat )
      if( !record.touch || actionMap[ record.dst.absolute ] )
      {
        if( !record.touch )
        {
          action( record, 'exclude' );
        }
        else if( actionMap[ record.dst.absolute ] === 'dirMake' )
        {
          dirMake( record );
          preserve( record );
        }
        _.assert( !!record.action, () => 'Not clear what action to apply to ' + record.src.absolute );
        return;
      }
    }

    if( !record.src.stat )
    {
      /* src does not exist */

      if( record.reason === 'dstRewriting' )
      {
        /* if dst rewriting and src is included */
        if( !o.dstRewriting && record.src.isActual )
        {
          forbid( record );
        }
      }
      else if( record.reason === 'dstDeleting' )
      {
        /* if dst deleting or src is not included then treat as src does not exist */
        if( !o.dstDeleting )
        {
          forbid( record );
        }
      }
      else if( !record.src.isActual )
      {
        /* if dst deleting or src is not included then treat as src does not exist */
        if( !o.dstDeleting )
        {
          debugger;
          forbid( record );
        }
      }

      _.assert( !record.action );
      _.assert( !record.srcAction );
      _.assert( !!record.reason );

      if( record.reason === 'dstDeleting' && !record.dst.isActual && !record.touch )
      {
        ignore( record );
      }
      else if( record.reason !== 'dstDeleting' && ( !record.dst.isActual || !record.dst.stat ) && !record.touch )
      {
        debugger;
        forbid( record );
        action( record, 'exclude' );
      }
      else
      {
        dirDeleteOrPreserve( record, 'ignore' );
      }

    }
    else if( record.src.isDir )
    {

      if( !record.dst.stat )
      {
        /* src is dir, dst does not exist */

        if( !record.src.isActual )
        {
          if( record.touch === 'constructive' )
          dirMake( record );
          else
          action( record, 'exclude' );
        }
        else
        {
          dirMake( record );
        }

      }
      else if( record.dst.isDir )
      {
        /* both src and dst are dir */

        if( !record.src.isActual )
        {

          if( record.reason === 'srcLooking' && record.dst.isStem )
          {
            dirMake( record );
            preserve( record );
          }
          else
          {
            dirDeleteOrPreserve( record );
          }

        }
        else
        {
          dirMake( record );
        }

      }
      else
      {
        /* src is dir, dst is terminal */

        if( o.dstRewritingOnlyPreserving )
        if( o.writing && o.dstRewriting && o.dstRewritingByDistinct )
        {
          debugger;
          throw _.err( 'Can\'t rewrite terminal file ' + record.dst.absolute + ' by directory ' + record.src.absolute + ', dstRewritingOnlyPreserving is enabled' );
        }

        if( !record.src.isActual && record.dst.isActual )
        if( record.touch === 'constructive' )
        {
          record.deleteFirst = true;
          dirMake( record );
        }
        else
        {
          fileDelete( record );
        }

        _.assert( !record.src.isActual || !!record.touch );

      }

    }
    else
    {

      if( !record.dst.stat )
      {
        /* src is terminal file and dst does not exists */
        _.assert( record.action === o.linkingAction || _.strHas( o.linkingAction, 'Maybe' ) );
      }
      else if( record.dst.isDir )
      {
        /* src is terminal, dst is dir */

        if( !o.writing || !o.dstRewriting || !o.dstRewritingByDistinct )
        {
          forbid( record );
        }
        else if( o.dstRewritingOnlyPreserving )
        {
          if( record.dst.factory.effectiveProvider.filesHasTerminal( record.dst.absolute ) )
          {
            debugger;
            throw _.err( 'Can\'t rewrite directory ' + _.strQuote( record.dst.absolute ) + ' by terminal ' + _.strQuote( record.src.absolute ) + ', directory has terminal(s)' );
          }
        }

        if( record.touch === 'constructive' )
        {
          record.preserve = true;
          dirMake( record );
        }
        else
        {
          if( record.src.isActual )
          {
            record.deleteFirst = true;
            link( record );
          }
          else
          {
            _.assert( record.deleteFirst === false );
            if( !o.dstDeleting )
            {
              forbid( record );
            }
            if( !record.dst.isActual && record.touch !== 'destructive' )
            {
              debugger;
              forbid( record );
            }

            dirDeleteOrPreserve( record );
          }
        }

      }
      else
      {
        /* both src and dst are terminals */

        if( o.writing && o.dstRewriting && o.dstRewritingOnlyPreserving )
        if( !self.filesCanBeSame( record.src, record.dst, true ) )
        if( record.src.stat.size !== 0 || record.dst.stat.size !== 0 )
        {
          debugger;
          let same = self.filesCanBeSame( record.src, record.dst, true );
          throw _.err
          (
            'Can\'t rewrite terminal file ' + _.strQuote( record.dst.absolute ) + '\n'
            + 'by terminal file ' + _.strQuote( record.src.absolute ) + '\n'
            + 'files have different content'
          );
        }
      }

    }

    _.assert( !!record.reason );
    _.assert( !record.srcAction );
    _.assert( _.strIs( record.action ), () => 'Action for record ' + _.strQuote( record.src.relative ) + ' was not defined' );

    srcDeleteMaybe( record );

    return record;
  }

  /* */

  function handleDstUp( /* srcContext, reason, dst, dstRecord, op */ )
  {
    let srcContext = arguments[ 0 ];
    let reason = arguments[ 1 ];
    let dst = arguments[ 2 ];
    let dstRecord = arguments[ 3 ];
    let op = arguments[ 4 ];

    if( !dstRecord.included )
    return dstRecord;

    _.assert( arguments.length === 5 );
    _.assert( _.strIs( reason ) );
    let srcRecord = srcContext.record( dstRecord.relative );
    let record = recordMake( dstRecord, srcRecord, dstRecord );
    record.reason = reason;

    if( handleUp( record, op ) === false )
    record.include = false;

    return dstRecord;
  }

  /* */

  function handleDstDown( dstRecord, op )
  {
    let record = dstRecord.associated;

    if( !dstRecord.included )
    return;

    handleDown( record, op );
  }

  /* */

  function handleSrcUp( srcRecord, op )
  {

    if( !srcRecord.included )
    return srcRecord;

    let relative = srcRecord.relative;
    if( o.onDstName )
    relative = o.onDstName.call( self, relative, dstRecordFactory, op, o, srcRecord );

    let dstRecord = dstRecordFactory.record( relative );
    let record = recordMake( dstRecord, srcRecord, srcRecord );
    record.reason = 'srcLooking';

    // let isSoftLink = record.dst.isSoftLink;
    //
    // if( o.filesGraph )
    // {
    //   if( record.dst.absolute === dstPath )
    //   {
    //     debugger;
    //     o.filesGraph.dst.filePath = o.dst.filePath;
    //     o.filesGraph.src.filePath = o.src.filePath;
    //     o.filesGraph.actionBegin( o.dst.filePath + ' <- ' + o.src.filePath );
    //   }
    //   if( !record.src.isDir )
    //   {
    //     o.filesGraph.filesUpdate( record.dst );
    //     o.filesGraph.filesUpdate( record.src );
    //     if( o.filesGraph.fileIsUpToDate( record.dst ) )
    //     record.upToDate = true;
    //   }
    // }

    /* */

    handleUp( record, op );

    // if( _.strEnds( record.dst.absolute, debugPath ) )
    // debugger;

    if( record.include && record.src.isActual && record.src.stat )
    if( record.dst.isDir && !record.src.isDir )
    {
      /* src is terminal, dst is dir */

      _.assert( _.strIs( record.dst.factory.basePath ) );
      let filter2 = self.recordFilter
      ({
        effectiveProvider : dstOptions.filter.effectiveProvider,
        system : dstOptions.filter.system,
        recursive : 2,
      });
      filter2.filePath = null;
      filter2.basePath = record.dst.factory.basePath;

      let dstOptions2 = _.props.extend( null, dstOptions );
      dstOptions2.filePath = record.dst.absolute;
      dstOptions2.filter = filter2;
      dstOptions2.filter.filePath = null;
      dstOptions2.withStem = 0;
      dstOptions2.mandatory = 0;
      dstOptions2.withDefunct = 0;
      dstOptions2.onUp = [ _.routineJoin( undefined, handleDstUp, [ srcRecord.factory, 'dstRewriting', filter2 ] ) ];

      let found = self.filesFind( dstOptions2 );

    }

    /* */

    if( record.include && record.goingUp )
    return srcRecord;
    else
    return _.dont;
  }

  /* */

  function handleSrcDown( srcRecord, op )
  {
    let record = srcRecord.associated;

    if( !srcRecord.included )
    return;

    // if( o.filesGraph && !record.src.isDir && !record.upToDate )
    // {
    //   record.dst.reset();
    //   o.filesGraph.dependencyAdd( record.dst, record.src );
    // }

    dstDelete( record, op );
    handleDown( record, op );

    // if( o.filesGraph )
    // {
    //   if( record.dst.absolute === dstPath )
    //   o.filesGraph.actionEnd();
    // }

  }

  function dstDelete( record, op )
  {

    _.assert( !!record );
    if( !o.includingDst )
    return;
    if( !record.dst.isDir || !record.src.isDir )
    return;

    _.assert( _.strIs( record.dst.factory.basePath ) );
    _.assert( _.strIs( record.src.factory.basePath ) );

    let dstFiles = record.dst.factory.effectiveProvider.dirRead({ filePath : record.dst.absolute, outputFormat : 'absolute' });
    let dstRecords = record.dst.factory.records( dstFiles );
    let srcFiles = record.src.factory.effectiveProvider.dirRead({ filePath : record.src.absolute, outputFormat : 'absolute' });
    let srcRecords = record.src.factory.records( srcFiles );

    for( let f = dstRecords.length-1 ; f >= 0 ; f-- )
    {
      let dstRecord = dstRecords[ f ];
      let srcRecord = _.longLeft( srcRecords, dstRecord, ( r ) => r.relative ).element;
      if( !srcRecord )
      continue;
      if( !srcRecord.isActual )
      continue;
      dstRecords.splice( f, 1 );
    }

    // if( _.strEnds( record.dst.absolute, debugPath ) )
    // debugger;

    for( let f = 0 ; f < dstRecords.length ; f++ )
    {
      let dstRecord = dstRecords[ f ];

      if( dstDeleteMap[ dstRecord.absolute ] )
      continue;

      dstDeleteTouch( dstRecord );

      let dstOptions2 = _.props.extend( null, dstOptions );
      dstOptions2.filePath = dst.path.join( record.dst.factory.basePath, dstRecord.absolute );
      dstOptions2.filter = dstOptions2.filter.clone();
      dstOptions2.filter.filePath = null;
      dstOptions2.filter.filePath = null;
      dstOptions2.filter.basePath = record.dst.factory.basePath;
      dstOptions2.filter.recursive = 2;
      dstOptions2.mandatory = 0;
      dstOptions2.withDefunct = 0;
      dstOptions2.onUp = [ _.routineJoin( null, handleDstUp, [ record.src.factory, 'dstDeleting', null ] ) ];

      let found = self.filesFind( dstOptions2 );

    }

  }

  /* */

  function dstDeleteTouch( record )
  {

    _.assert( _.strIs( dstPath ) );
    _.assert( _.strIs( record.absolute ) );
    _.assert( arguments.length === 1 );

    let absolutePath = record.absolute;
    dstDeleteMap[ absolutePath ] = 1;

    do
    {
      absolutePath = dst.path.detrail( dst.path.dir( absolutePath ) );
      dstDeleteMap[ absolutePath ] = 1;
    }
    while( absolutePath !== dstPath && absolutePath !== '/' );

  }

  /* touch */

  function action( record, action )
  {

    // if( _.strEnds( record.dst.absolute, debugPath ) )
    // debugger;
    // if( _.strHas( record.dst.absolute, 'clean-special/out' ) )
    // debugger;

    _.assert( arguments.length === 2 );
    // _.assert( _.longHas( [ 'exclude', 'ignore', 'fileDelete', 'dirMake', 'fileCopy', 'softLink', 'hardLink', 'textLink', 'nop' ], action ), () => 'Unknown action ' + _.strQuote( action ) );
    _.assert( self.ReflecEvalAction[ action ] !== undefined, () => 'Unknown action ' + _.strQuote( action ) );

    let absolutePath = record.dst.absolute;
    let result = actionMap[ absolutePath ] === action;

    _.assert( record.action === null );
    record.action = action;

    if( action === 'exclude' || action === 'ignore' )
    {
      _.assert( actionMap[ absolutePath ] === undefined );
      return result;
    }

    actionMap[ absolutePath ] = action;

    return result
  }

  /* touch */

  function touch( record, kind )
  {

    // if( _.strEnds( record.dst.absolute, debugPath ) )
    // debugger;

    kind = kind || 'constructive';

    _.assert( _.strIs( dstPath ) );
    _.assert( arguments.length === 2 );
    _.assert( _.longHas( [ 'src', 'constructive', 'destructive' ], kind ) );

    let absolutePath = record.dst.absolute;
    kind = touchAct( absolutePath, kind );

    record.touch = kind;

    while( absolutePath !== dstPath && absolutePath !== '/' )
    {
      absolutePath = dst.path.detrail( dst.path.dir( absolutePath ) );
      touchAct( absolutePath, kind );
    }

    if( kind === 'destructive' )
    {
      for( let m in touchMap )
      if( _.strBegins( m, absolutePath ) )
      touchMap[ m ] = 'destructive';
    }

  }

  /* touchAct */

  function touchAct( absolutePath, kind )
  {

    if( kind === 'src' && touchMap[ absolutePath ] )
    return touchMap[ absolutePath ];

    if( kind === 'destructive' && touchMap[ absolutePath ] === 'constructive' )
    return touchMap[ absolutePath ];

    touchMap[ absolutePath ] = kind;

    return kind;
  }

  /* */

  function dirHaveFiles( record )
  {
    if( !record.dst.isDir )
    return false;
    if( touchMap[ record.dst.absolute ] === 'constructive' )
    return true;
    let files = record.dst.factory.effectiveProvider.dirRead({ filePath : record.dst.absolute, outputFormat : 'absolute' });
    files = files.filter( ( file ) => actionMap[ file ] !== 'fileDelete' );
    return !!files.length;
  }

  /* */

  function shouldPreserve( record )
  {

    if( !o.preservingSame )
    return false;

    if( record.upToDate )
    return true;

    if( o.linkingAction === 'fileCopy' ) /* xxx : qqq : investigate */
    {
      if( self.filesCanBeSame( record.dst, record.src, true ) )
      return true;
    }

    return false;
  }

  /* */

  function dirDeleteOrPreserve( record, preserveAction )
  {
    _.assert( !record.action );
    if( !preserveAction )
    preserveAction = 'dirMake';

    if( dirHaveFiles( record ) )
    {
      /* preserve dir if it has filtered out files */
      if( preserveAction === 'dirMake' )
      {
        dirMake( record );
        _.assert( record.preserve === true );
      }
      else
      ignore( record );
    }
    else
    {
      if( !o.writing )
      record.allow = false;

      if( !o.dstDeletingCleanedDirs )
      if( record.dst.isDir && !record.dst.isActual )
      return ignore( record );

      fileDelete( record );
    }

    return record;
  }

  /* */

  function preserve( record )
  {
    _.assert( _.strIs( record.action ) );
    record.preserve = true;
    touch( record, 'constructive' );
    return record;
  }

  /* */

  function link( record )
  {
    _.assert( !record.action );
    _.assert( !record.upToDate );

    if( !record.src.isActual )
    {
      record.include = false;
      return;
    }

    let linkingAction = o.linkingAction;
    if( _.strHas( linkingAction, 'Maybe' ) )
    {
      if( src === dst )
      linkingAction = _.strRemoveEnd( linkingAction, 'Maybe' );
      else
      linkingAction = 'fileCopy';
    }

    action( record, linkingAction );
    touch( record, 'constructive' );

    return record;
  }

  /* */

  function dirMake( record )
  {
    _.assert( !record.action );

    if( record.dst.isDir || actionMap[ record.dst.absolute ] === 'dirMake' )
    record.preserve = true;

    action( record, 'dirMake' );
    touch( record, 'constructive' );

    return record;
  }

  /* */

  function ignore( record )
  {
    _.assert( !record.action );
    touch( record, 'constructive' );
    action( record, 'ignore' );
    record.preserve = true;
    record.allow = false;
    return record;
  }

  /* */

  function forbid( record )
  {
    delete actionMap[ record.dst.absolute ];
    /* no need to delete it from touchMap */
    record.allow = false;
    return record;
  }

  /* */

  function fileDelete( record )
  {
    _.assert( !record.action );

    action( record, 'fileDelete' );
    touch( record, 'destructive' );

    if( record.reason === 'dstDeleting' && !o.dstDeleting )
    {
      forbid( record );
    }

  }

  /* */

  function srcDeleteMaybe( record )
  {

    if( !o.srcDeleting )
    return false;
    if( !record.src.isActual )
    return false;
    if( !record.allow )
    return false;
    if( !record.include )
    return false;

    srcDelete( record );
  }

  /* delete src */

  function srcDelete( record )
  {

    /* record.dst.isActual could be false */

    _.assert( !!record.src.isActual );
    _.assert( !!record.include );
    _.assert( !!record.allow );
    _.assert( !!record.action );
    _.assert( !!o.srcDeleting );

    // if( _.strEnds( record.dst.absolute, debugPath ) )
    // debugger;

    if( record.allow )
    if( !record.src.stat )
    {
    }
    else if( record.src.isDir )
    {
      _.assert( record.action === 'dirMake' || record.action === 'fileDelete' );
      record.srcAction = 'fileDelete';
      record.srcAllow = !!o.writing;
      touch( record, 'src' )
    }
    else
    {
      record.srcAction = 'fileDelete';
      record.srcAllow = !!o.writing;
      touch( record, 'src' )
    }

  }

  /* */

  function checkSrcTerminalsSameDst( record, op )
  {
    for( let i = op.result.length - 1; i >= 0; i-- )
    {
      let result = op.result[ i ];
      if( result.dst.absolute === record.dst.absolute )
      {
        if( result.src.isTerminal )
        {
          if( !self.filesCanBeSame( result.src, record.src, true ) )
          if( result.src.stat.size !== 0 || record.src.stat.size !== 0 )
          {
            debugger
            throw _.err
            (
              'Cant\'t rewrite destination file by source file, because they have different content and option::dstRewritingOnlyPreserving is true\n'
              + `\ndst: ${result.dst.absolute}`
              + `\nsrc: ${result.src.absolute}`
            );
            // throw _.err
            // (
            //   'Source terminal files: \n' + _.strQuote( result.src.absolute ) + ' and ' + _.strQuote( record.src.absolute ) + '\n' +
            //   'have same destination path: ' + _.strQuote( record.dst.absolute ) +', but different content.' + '\n' +
            //   'Can\'t perform rewrite operation when option dstRewritingOnlyPreserving is enabled.'
            // );
          }
        }
        break;
      }
    }
  }
}

let filesReflectPrimeDefaults = Object.create( null );
var defaults = filesReflectPrimeDefaults;

defaults.result = null;
defaults.visitedMap = null;
defaults.extra = null;
defaults.linkingAction = 'fileCopy';
// defaults.xxx = 'both';

defaults.verbosity = 0;
defaults.mandatory = 1;
defaults.allowingMissed = 0;
defaults.allowingCycled = 0;
defaults.withTerminals = 1;
defaults.withDirs = 1;
defaults.includingNonAllowed = 1;
defaults.includingDst = null;
defaults.revisiting = null;
defaults.resolvingSoftLink = 0;
defaults.resolvingTextLink = 0;

defaults.writing = 1;
defaults.srcDeleting = 0;
defaults.dstDeleting = 0;
defaults.dstDeletingCleanedDirs = 1;
defaults.dstRewriting = 1;
defaults.dstRewritingByDistinct = 1;
defaults.dstRewritingOnlyPreserving = 0; /* qqq2 xxx : rename to dstRewritingAllowingDiscrepancy and invert */
defaults.preservingTime = 0;
defaults.preservingSame = 0;

defaults.onUp = null;
defaults.onDown = null;
defaults.onDstName = null;

var defaults = filesReflectEvaluate_body.defaults = Object.create( filesReflectPrimeDefaults ); /* xxx : xxx : remove all inheriting of defaults */
// defaults.filesGraph = null;
defaults.src = null;
defaults.dst = null;

var having = filesReflectEvaluate_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;

let filesReflectEvaluate = _.routine.uniteCloning_replaceByUnite( filesReflectEvaluate_head, filesReflectEvaluate_body );
filesReflectEvaluate.having.aspect = 'entry';

//

function filesReflectSingle_head( routine, args )
{
  let self = this;
  let o = self._filesReflectPrepare( routine, args );

  if( o.rebasingLink === false )
  o.rebasingLink = 0
  else if( o.rebasingLink === true )
  o.rebasingLink = 2;

  _.assert( _.longHas( [ 0, 1, 2 ], o.rebasingLink ) );
  _.assert( _.boolLike( o.throwing ) );

  if( o.onWriteDstUp )
  o.onWriteDstUp = _.routinesCompose( o.onWriteDstUp );
  if( o.onWriteDstDown )
  o.onWriteDstDown = _.routinesCompose( o.onWriteDstDown );
  if( o.onWriteSrcUp )
  o.onWriteSrcUp = _.routinesCompose( o.onWriteSrcUp );
  if( o.onWriteSrcDown )
  o.onWriteSrcDown = _.routinesCompose( o.onWriteSrcDown );

  return o;
}

//

function filesReflectSingle_body( o )
{
  let self = this;
  let path = self.path;
  let srcToDstHash = null;

  _.routine.assertOptions( filesReflectSingle_body, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.boolLike( o.mandatory ) );
  _.assert( o.filter === undefined );
  _.assert( o.src.dst === o.dst );
  _.assert( o.dst.src === o.src );
  // _.assert( o.outputFormat === undefined );
  _.assert( _.boolLike( o.allowingMissed ) );

  if( o.rebasingLink && o.visitedMap === null )
  {
    o.visitedMap = Object.create( null );
  }

  let o2 = _.mapOnly_( null, o, self.filesReflectEvaluate.body.defaults );
  o2.result = [];
  _.assert( _.arrayIs( o2.result ) );
  self.filesReflectEvaluate.body.call( self, o2 );
  _.assert( o2.result !== o.result );
  _.arrayAppendArray( o.result, o2.result );

  let dirsMap = Object.create( null );
  let system = self.system || self;
  let src = o.src.effectiveProvider;
  let dst = o.dst.effectiveProvider;

  /* */

  if( o.writing )
  forEach( writeDstUp1, writeDstDown1 );

  if( o.writing )
  forEach( writeDstUp2, writeDstDown2 );

  if( o.writing && o.srcDeleting )
  if( o.writing ) /* xxx : use this */
  forEach( writeSrcUp, writeSrcDown );

  /* */

  return end();

  /* - */

  function end()
  {

    if( o.mandatory )
    if( !o2.result.length )
    {
      _.assert( o.src.isPaired() );
      let mtr = o.src.moveTextualReport();
      debugger;
      throw _.err( 'Error. No file moved :', mtr );
    }

    return o.result;
  }

  /* */

  function srcToDst( srcRecord )
  {
    if( !srcToDstHash )
    {
      srcToDstHash = new HashMap();
      for( let r = 0 ; r < o.result.length ; r++ )
      srcToDstHash.set( o.result[ r ].src, o.result[ r ].dst );
    }
    return srcToDstHash.get( srcRecord );
  }

  /* */

  function forEach( up, down )
  {
    let filesStack = [];

    for( let r = 0 ; r < o.result.length ; r++ )
    {
      let record = o.result[ r ];

      while( filesStack.length && !_.strBegins( record.dst.absolute, filesStack[ filesStack.length-1 ].dst.absolute ) )
      down( filesStack.pop() );
      filesStack.push( record );

      up( record );
    }

    while( filesStack.length )
    down( filesStack.pop() );

  }

  /*  */

  function writeDstUp1( record )
  {

    if( o.onWriteDstUp )
    {
      let onr = o.onWriteDstUp.call( self, record, o );
      _.assert( _.boolsAllAre( onr ) );
      onr = _.all( onr, ( e ) => e === _.dont ? false : e );
      _.assert( _.boolIs( onr ) );
      return onr;
    }

    return true;
  }

  /* */

  function writeDstDown1( record )
  {

    if( record.deleteFirst )
    dstDelete( record );
    else if( record.action === 'fileDelete' )
    dstDelete( record );

  }

  /*  */

  function writeDstUp2( record )
  {

    // let linkingAction = _.longHas( [ 'fileCopy', 'hardLink', 'softLink', 'textLink', 'nop' ], record.action );
    let linkingAction = !!self.ReflectMandatoryAction[ record.action ];
    if( linkingAction && record.allow && !path.isRoot( record.dst.absolute ) )
    {

      let dirPath = record.dst.dir;
      if( !dirsMap[ dirPath ] )
      {
        for( let d in dirsMap )
        if( _.strBegins( dirPath, d ) )
        {
          dirsMap[ dirPath ] = true;
          break;
        }
        if( !dirsMap[ dirPath ] )
        {
          record.dst.factory.effectiveProvider.dirMake
          ({
            recursive : 1,
            rewritingTerminal : 0,
            filePath : dirPath,
          });
          dirsMap[ dirPath ] = true;
        }
      }

    }

    if( linkingAction )
    link( record );
    else if( record.action === 'fileDelete' )
    {}
    else if( record.action === 'dirMake' )
    dstDirectoryMake( record );
    else if( record.action === 'ignore' )
    {}
    else _.assert( 0, 'Not implemented action ' + record.action );

  }

  /* */

  function writeDstDown2( record )
  {

    if( o.onWriteDstDown )
    {
      let onr = o.onWriteDstDown.call( self, record, o );
      _.assert( _.boolsAllAre( onr ) );
      onr = _.all( onr, ( e ) => e === _.dont ? false : e );
      _.assert( _.boolIs( onr ) );
      return onr;
    }

    return true;
  }

  /* */

  function writeSrcUp( record )
  {

    if( o.onWriteSrcUp )
    {
      let onr = o.onWriteSrcUp.call( self, record, o );
      _.assert( _.boolsAllAre( onr ) );
      onr = _.all( onr, ( e ) => e === _.dont ? false : e );
      _.assert( _.boolIs( onr ) );
      return onr
    }

    /* */

    return true;
    // if( !onr )
    // return onr;
    // return onr;
  }

  /* */

  function writeSrcDown( record )
  {

    srcDeleteMaybe( record );

    if( o.onWriteSrcDown )
    {
      let onr = o.onWriteSrcDown.call( self, record, o );
      _.assert( _.boolsAllAre( onr ) );
      onr = _.all( onr, ( e ) => e === _.dont ? false : e );
      _.assert( _.boolIs( onr ) );
      return onr;
    }

    return true;
  }

  /* */

  function dstDirectoryMake( record )
  {

    if( !record.allow )
    return;
    if( record.preserve )
    return;

    _.assert( !record.upToDate );
    _.assert( !!record.src.isActual || !!record.touch );
    _.assert( !!record.touch );
    _.assert( !!record.action );

    let r = record.dst.factory.effectiveProvider.dirMake
    ({
      recursive : 1,
      rewritingTerminal : 0,
      filePath : record.dst.absolute,
    });
    record.performed = r;

  }

  /* */

  function dstDelete( record )
  {
    if( !record.allow )
    return;
    if( record.dst.absolute === record.src.absolute )
    return;

    let r = record.dst.factory.effectiveProvider.fileDelete( record.dst.absolute );
    record.performed = r;
    /* qqq : should be in v >= 3 log as : " - deleted ..." */

  }

  /* */

  function linkRebasing( record )
  {

    if( !o.rebasingLink )
    return false;

    let isSoftLink = record.src.isSoftLink;
    let isTextLink = record.src.isTextLink;

    if( !isSoftLink && !isTextLink )
    if( ( o.resolvingSoftLink && self.usingSoftLink ) || ( o.resolvingTextLink && self.usingTextLink ) )
    {
      debugger;
      let stat = record.src.factory.effectiveProvider.statRead
      ({
        filePath : record.src.absolute,
        resolvingSoftLink : 0,
        resolvingTextLink : 0,
      });
      isSoftLink = stat.isSoftLink();
      isTextLink = stat.isTextLink();
    }

    if( isSoftLink && o.resolvingSrcSoftLink === 2 )
    return false;

    if( isTextLink && o.resolvingSrcTextLink === 2 )
    return false;

    if( !isSoftLink && !isTextLink )
    return false;

    let srcPath;
    let srcAbsolute = record.src.real;
    /* qqq : use ( resolvingMultiple / recursive ) option instead of if-else */

    // debugger;
    // if( _.strHas( srcAbsolute, 'terLink' ) )
    // debugger;

    let resolvingSrcSoftLink = self.usingSoftLink ? o.resolvingSrcSoftLink : 0;
    let resolvingSrcTextLink = self.usingTextLink ? o.resolvingSrcTextLink : 0;

    if( o.rebasingLink === 2 )
    {
      let resolved = src.pathResolveLinkFull
      ({
        filePath : srcAbsolute,
        resolvingSoftLink : 1,
        resolvingTextLink : 1,
        preservingRelative : 1,
        relativeOriginalFile : 1,
        throwing : o.throwing,
        allowingMissed : o.allowingMissed,
        allowingCycled : o.allowingCycled,
      });
      if( !resolved )
      {
        debugger;
        return false;
      }
      srcAbsolute = resolved.absolutePath;
      srcPath = resolved.filePath;
    }
    else if( o.rebasingLink === 1 )
    {

      if( resolvingSrcSoftLink || resolvingSrcTextLink )
      {

        let resolved = src.pathResolveLinkFull
        ({
          filePath : srcAbsolute,
          resolvingSoftLink : resolvingSrcSoftLink ? 1 : 0,
          resolvingTextLink : resolvingSrcTextLink ? 1 : 0,
          preservingRelative : 1,
          relativeOriginalFile : 1,
          throwing : o.throwing,
          allowingMissed : o.allowingMissed,
          allowingCycled : o.allowingCycled,
        });
        if( !resolved )
        {
          debugger;
          return false;
        }
        srcAbsolute = resolved.absolutePath;
        srcPath = resolved.filePath;

      }

      if( ( !resolvingSrcSoftLink && self.usingSoftLink ) || ( !resolvingSrcTextLink && self.usingTextLink ) )
      {
        let resolved = src.pathResolveLinkStep
        ({
          filePath : srcAbsolute,
          resolvingSoftLink : 1,
          resolvingTextLink : 1,
          preservingRelative : 1,
          relativeOriginalFile : 1,
          throwing : o.throwing,
          allowingMissed : o.allowingMissed,
          allowingCycled : o.allowingCycled,
        });

        srcPath = resolved.filePath;
        srcAbsolute = path.join( srcAbsolute, srcPath );
      }

    }
    else _.assert( 0 );

    if( !o.visitedMap[ srcAbsolute ] )
    debugger;
    if( !o.visitedMap[ srcAbsolute ] )
    return false

    if( path.isAbsolute( srcPath ) )
    debugger;

    let srcRecord = o.visitedMap[ srcAbsolute ];
    let dstRecord = srcToDst( srcRecord );
    if( record.src === dstRecord )
    debugger;
    if( record.src === dstRecord )
    return false;

    record.src = record.src.factory.record( srcAbsolute );

    // if( path.isAbsolute( srcPath ) )
    // {
    //   debugger;
    //   path.join( dstRecord.absolute, path.relative( srcRecord.absolute, srcAbsolute ) );
    // }

    let action = isSoftLink ? 'softLink' : 'textLink';

    if( action === 'softLink' )
    {
      if( o.resolvingSrcSoftLink === 2 )
      linkWithAction( record, record.dst.absolutePreferred, srcPath, 'fileCopy' );
      else
      linkWithAction( record, record.dst.absolutePreferred, srcPath, action, 1 );
    }
    else if( action === 'textLink' )
    {
      if( o.resolvingSrcTextLink === 2 )
      linkWithAction( record, record.dst.absolutePreferred, srcPath, 'fileCopy' );
      else
      linkWithAction( record, record.dst.absolutePreferred, srcPath, action, 1 );
    }

    return true;
  }

  /* */

  function linkWithAction( /* record, dstPath, srcPath, action, allowingMissed */ )
  {
    let record = arguments[ 0 ];
    let dstPath = arguments[ 1 ];
    let srcPath = arguments[ 2 ];
    let action = arguments[ 3 ];
    let allowingMissed = arguments[ 4 ];

    let r;

    if( action === 'nop' )
    {
      record.performed = 'nop';
      return false;
    }

    if( action === 'fileCopy' )
    {
      /* qqq : should return true / false / null. false if no change is done! */
      r = system.fileCopy
      ({
        dstPath,
        srcPath,
        makingDirectory : 0,
        allowingMissed : allowingMissed || o.allowingMissed,
        allowingCycled : o.allowingCycled,
        resolvingSrcSoftLink : o.resolvingSrcSoftLink,
        resolvingSrcTextLink : o.resolvingSrcTextLink,
        resolvingDstSoftLink : o.resolvingDstSoftLink,
        resolvingDstTextLink : o.resolvingDstTextLink,
        breakingDstHardLink : o.breakingDstHardLink,
      });
    }
    else if( action === 'hardLink' )
    {
      /* qqq : should not change time of file if it is already linked. check tests */
      /* qqq : should return true / false / null. false if no change is done! */

      r = dst.hardLink
      ({
        dstPath,
        srcPath,
        makingDirectory : 0,
        allowingMissed : allowingMissed || o.allowingMissed,
        allowingCycled : o.allowingCycled,
        resolvingSrcSoftLink : o.resolvingSrcSoftLink,
        resolvingSrcTextLink : o.resolvingSrcTextLink,
        resolvingDstSoftLink : o.resolvingDstSoftLink,
        resolvingDstTextLink : o.resolvingDstTextLink,
        breakingSrcHardLink : o.breakingSrcHardLink,
        breakingDstHardLink : o.breakingDstHardLink,
      });

    }
    else if( action === 'softLink' )
    {
      /* qqq : should not change time of file if it is already linked. check tests */
      /* qqq : should return true / false / null. false if no change is done! */
      if( path.isRelative( srcPath ) )
      debugger;
      r = system.softLink
      ({
        dstPath,
        srcPath,
        makingDirectory : 0,
        allowingMissed : allowingMissed || o.allowingMissed,
        allowingCycled : o.allowingCycled,
        resolvingSrcSoftLink : o.resolvingSrcSoftLink,
        resolvingSrcTextLink : o.resolvingSrcTextLink,
        resolvingDstSoftLink : o.resolvingDstSoftLink,
        resolvingDstTextLink : o.resolvingDstTextLink,
      });
    }
    else if( action === 'textLink' )
    {
      /* qqq : should not change time of file if it is already linked. check tests */
      /* qqq : should return true / false / null. false if no change is done! */
      r = system.textLink
      ({
        dstPath,
        srcPath,
        makingDirectory : 0,
        allowingMissed : allowingMissed || o.allowingMissed,
        allowingCycled : o.allowingCycled,
        resolvingSrcSoftLink : o.resolvingSrcSoftLink,
        resolvingSrcTextLink : o.resolvingSrcTextLink,
        resolvingDstSoftLink : o.resolvingDstSoftLink,
        resolvingDstTextLink : o.resolvingDstTextLink,
      });
    }
    else _.assert( 0 );

    if( _.consequenceIs( r ) )
    r.then( () => record.performed = r );
    else
    record.performed = r;

    return true;
  }

  /* */

  function link( record )
  {

    _.assert( !record.upToDate );
    _.assert( !!record.src.isActual );
    _.assert( !!record.touch );
    _.assert( !!record.action );

    if( !record.allow || record.preserve )
    return;

    if( record.action === 'nop' )
    {
      record.performed = 'nop';
      return false;
    }

    let action = record.action;

    if( linkRebasing( record ) )
    return true;

    return linkWithAction( record, record.dst.absolutePreferred, record.src.absolutePreferred, action );
  }

  /* */

  function srcDeleteMaybe( record )
  {
    if( !record.srcAllow || !record.srcAction )
    return false;
    srcDelete( record );
  }

  /* delete src */

  function srcDelete( record )
  {

    /* record.dst.isActual could be false */

    _.assert( !!record.src.isActual );
    _.assert( !!record.include );
    _.assert( !!record.allow );
    _.assert( !!record.action );
    _.assert( !!o.srcDeleting );
    _.assert( record.srcAction === 'fileDelete' );

    if( record.allow )
    if( !record.src.stat || !record.src.isActual )
    {
      _.assert( 0, 'not tested' );
    }
    else if( record.src.isDir )
    {
      _.assert( record.action === 'dirMake' || record.action === 'fileDelete' );
      if( !record.src.factory.effectiveProvider.dirRead( record.src.absolute ).length )
      {
        record.src.factory.effectiveProvider.fileDelete( record.src.absolute );
      }
      else
      {
        record.srcAllow = false;
      }
    }
    else
    {
      _.assert( record.action === 'fileCopy' || record.action === 'hardLink' || record.action === 'softLink' || record.action === 'textLink' || record.action === 'nop' );
      record.src.factory.effectiveProvider.fileDelete( record.src.absolute );
    }

  }

}

let filesReflectAdvancedDefaults = Object.create( null );
var defaults = filesReflectAdvancedDefaults;

defaults.onWriteDstUp = null;
defaults.onWriteDstDown = null;
defaults.onWriteSrcUp = null;
defaults.onWriteSrcDown = null;

defaults.breakingSrcHardLink = null;
defaults.resolvingSrcSoftLink = null;
defaults.resolvingSrcTextLink = null;
defaults.breakingDstHardLink = null;
defaults.resolvingDstSoftLink = null;
defaults.resolvingDstTextLink = null;
defaults.rebasingLink = 0;
defaults.sync = null;
defaults.throwing = null;

var defaults = filesReflectSingle_body.defaults = Object.create( filesReflectEvaluate.defaults );
_.props.extend( defaults, filesReflectAdvancedDefaults );
// defaults.outputFormat = 'record';
defaults.outputFormat = 'nothing'; /* xxx : qqq : optimization, controls records creation in filesReflectSingle */

var having = filesReflectSingle_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;

let filesReflectSingle = _.routine.uniteCloning_replaceByUnite( filesReflectSingle_head, filesReflectSingle_body );
filesReflectSingle.having.aspect = 'entry';

_.assert( filesReflectSingle.defaults.sync !== undefined );

//

function filesReflect_head( routine, args )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ]
  if( args.length === 2 )
  o = { reflectMap : { [ args[ 1 ] ] : args[ 0 ] } }

  self.filesReflectSingle.head.call( self, routine, args );

  if( Config.debug )
  {

    let srcFilePath = o.src.filePathSimplest();
    let dstFilePath = o.dst.filePathSimplest();

    _.assert( o.reflectMap === null || srcFilePath === null || srcFilePath === '' );
    _.assert( o.reflectMap === null || dstFilePath === null || dstFilePath === '' );
    _.assert( o.src.isPaired( o.dst ) );
    _.assert
    (
      o.filter === null || o.filter.filePath === null || o.filter.filePath === undefined
      || _.path.map.identical( o.filter.filePath, o.src.filePath ),
    );

    let knownFormats = [ 'src.absolute', 'src.relative', 'dst.absolute', 'dst.relative', 'record', 'nothing' ];
    _.assert
    (
      _.longHas( knownFormats, o.outputFormat ),
      () => 'Unknown output format ' + _.entity.exportStringDiagnosticShallow( o.outputFormat )
      + '\nKnown output formats : ' + _.entity.exportString( knownFormats )
    );

  }

  if( o.reflectMap )
  {
    if( Config.debug )
    if( !path.isEmpty( o.src.filePath ) )
    {
      let filePath1 = path.mapExtend( null, o.src.filePath );
      let filePath2 = path.mapExtend( null, o.reflectMap );
      debugger; /* xxx */
      _.assert( _.path.map.identical( filePath1, filePath2 ) );
    }
    o.src.filePath = o.reflectMap;
    o.reflectMap = null;
  }

  o.src.pairWithDst( o.dst );
  o.src.pairRefineLight();
  o.dst._formPaths();
  o.src._formPaths();

  _.assert( _.mapIs( o.src.filePath ), 'Cant deduce source filter' );
  _.assert( _.mapIs( o.dst.filePath ), 'Cant deduce destination filter' );
  _.assert( o.src.filePath === o.dst.filePath );
  _.assert( o.reflectMap === null );
  _.assert( o.dstPath === undefined );
  _.assert( o.srcPath === undefined );
  _.assert( o.src.formed <= 3 );
  _.assert( o.dst.formed <= 3 );

  return o;
}

//

/**
 * @summary Reflects files from source to the destination using `o.reflectMap`.
 * @description Reflect map contains key:value pairs. In signle pair key is a source path and value is a destination path.
 * @param {Object} o Options map.
 * @param {Object} o.reflectMap Map with keys as source path and values as destination path.
 * @param {Object} o.filesGraph
 * @param {Object} o.filter
 * @param {Object} o.rc
 * @param {Object} o.dst
 * @param {Array} o.result
 * @param {String} o.outputFormat='record'
 * @param {Number} o.verbosity=0
 * @param {Boolean} o.allowingMissed=0
 * @param {Boolean} o.allowingCycled=0
 * @param {Boolean} o.withTerminals=1
 * @param {Boolean} o.withDirs=1
 * @param {Boolean} o.includingNonAllowed=1
 * @param {Boolean} o.includingDst
 * @param {String} o.linkingAction='fileCopy'
 * @param {Boolean} o.writing=1
 * @param {Boolean} o.srcDeleting=0
 * @param {Boolean} o.dstDeleting=0
 * @param {Boolean} o.dstDeletingCleanedDirs=1
 * @param {Boolean} o.dstRewriting=1
 * @param {Boolean} o.dstRewritingByDistinct=1
 * @param {Boolean} o.dstRewritingOnlyPreserving=0
 * @param {Boolean} o.preservingTime=0
 * @param {Boolean} o.preservingSame=0
 * @param {*} o.extral
 * @param {Boolean} o.revisiting=null Controls how visited files are processed. Possible values:
 *  0 - visit and include each file once
 *  1 - visit and include each file once, break from loop on first links cycle and continue search ignoring file at which cycle begins
 *  2 - visit and include each file once, break from loop on first links cycle and continue search visiting file at which cycle begins
 *  3 - don't keep records of visited files
 *  Defaults: option o.revisiting in set to "1" if links resolving is enabled, otherwise default is "3".
 * @param {Function} o.onUp
 * @param {Function} o.onDown
 * @param {Function} o.onDstName
 * @param {Boolean} o.rebasingLink=0 Controls link rebasing during copy. Possible values:
 *  0 - keep link as is, destination path will lead to source file
 *  1 - rebase link, try to make destination file lead to other destination file if last was handled in same call of filesReflect
 *  2 - rebase and resolve link, try to create copy of a file referenced by a link
 * @function filesReflect
 * @class wFileProviderFindMixin
 * @namespace wTools.FileProvider
 * @module Tools/mid/Files
 */

function filesReflect_body( o )
{
  let self = this;
  let path = self.path;
  let cons = [];
  let time;

  if( o.verbosity >= 1 )
  time = _.time.now();

  _.routine.assertOptions( filesReflect_body, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.src.formed === 3 );
  _.assert( o.dst.formed === 3 );
  _.assert( o.dst.src === o.src );
  _.assert( o.src.dst === o.dst );
  _.assert( _.mapIs( o.src.filePath ) );
  _.assert( o.src.isPaired( o.dst ) );

  /* */

  let filePath = o.src.filePathMap( o.src.filePath, 1 );
  let groupedByDstMap = path.mapGroupByDst( filePath );
  for( let dstPath in groupedByDstMap )
  {

    let srcPath = groupedByDstMap[ dstPath ];
    let o2 = _.mapOnly_( null, o, self.filesReflectSingle.body.defaults );

    o2.result = [];

    o2.dst = o2.dst.clone();
    o2.src = o2.src.clone();
    o2.src.pairWithDst( o2.dst );
    o2.src.filePathSelect( srcPath, dstPath );

    let src = o2.src.effectiveProvider;
    _.assert( _.routineIs( src.filesReflectSingle ), () => 'Method filesReflectSingle is not implemented' );
    let r = src.filesReflectSingle.body.call( src, o2 );
    cons.push( r );

    if( _.consequenceIs( r ) )
    r.ifNoErrorThen( ( arg ) => _.arrayAppendArray( o.result, o2.result ) );
    else
    _.arrayAppendArray( o.result, o2.result );

  }

  /* */

  if( _.any( cons, ( ready ) => _.consequenceIs( ready ) ) )
  {
    let ready =
    new _.Consequence()
    .take( null )
    .andKeep( cons );

    ready.ifNoErrorThen( end );
    return ready;
  }

  return end();

  /* */

  function end()
  {

    if( o.mandatory && o.outputFormat !== 'nothing' ) /* xxx : review option mandatory */
    if( !o.result.length )
    {
      _.assert( o.src.isPaired() );
      let mtr = o.src.moveTextualReport();
      debugger;
      throw _.err( 'Error. No file moved :', mtr );
    }

    /* qqq xxx : implement tests to cover log
    Implement and use LoggerToString for that.
    */

    let result = o.result;

    if( o.verbosity >= 1 )
    result = result.filter( ( record ) => record.performed );

    if( o.verbosity >= 3 )
    {

      result.forEach( ( record ) =>
      {
        if( record.action === 'fileDelete' )
        {
          self.logger.log( ` - ${ record.action } ${ record.dst.absolute }` );
        }
        else
        {
          let mtr = path.moveTextualReport( record.dst.absolute, record.src.absolute );
          self.logger.log( ` + ${ record.action } ${ mtr }` );
        }
      });

      /* qqq xxx : verbosity > 3 should log each modified file, but not more
      */

    }

    if( o.verbosity >= 1 )
    if( result.length )
    {
      _.assert( o.src.isPaired() );
      let mtr = o.src.moveTextualReport();
      self.logger.log( ` + Reflect ${ result.length } files ${ mtr } in ${ _.time.spent( time ) }` );
    }

    if( o.outputFormat !== 'record' )
    {
      const resultForm =
      {
        'src.absolute' : pathsForm,
        'dst.absolute' : pathsForm,
        'src.relative' : pathsForm,
        'dst.relative' : pathsForm,
        'nothing' : nothingForm,
      };
      if( !( o.outputFormat in resultForm ) )
      _.assert( 0, `Unknown output format : ${ o.outputFormat }` );
      else
      result = resultForm[ o.outputFormat ]( o.result, o.outputFormat );

      // if( o.outputFormat === 'src.relative' )
      // {
      //   for( let r = 0 ; r < o.result.length ; r++ )
      //   o.result[ r ] = o.result[ r ].src.relative;
      // }
      // else if( o.outputFormat === 'src.absolute' )
      // {
      //   for( let r = 0 ; r < o.result.length ; r++ )
      //   o.result[ r ] = o.result[ r ].src.absolute;
      // }
      // else if( o.outputFormat === 'dst.relative' )
      // {
      //   for( let r = 0 ; r < o.result.length ; r++ )
      //   o.result[ r ] = o.result[ r ].dst.relative;
      // }
      // else if( o.outputFormat === 'dst.absolute' )
      // {
      //   for( let r = 0 ; r < o.result.length ; r++ )
      //   o.result[ r ] = o.result[ r ].dst.absolute;
      // }
      // else if( o.outputFormat === 'nothing' )
      // {
      //   o.result.splice( 0, o.result.length );
      // }
      // else _.assert( 0, 'Unknown output format :', o.outputFormat );
    }

    return o.result;
  }

  /* */

  function pathsForm( src, format )
  {
    format = format.split( '.' );
    for( let i = 0 ; i < src.length ; i++ )
    src[ i ] = o.result[ i ][ format[ 0 ] ][ format[ 1 ] ];
    return src;
  }

  /* */

  function nothingForm( src )
  {
    src.splice( 0, src.length );
    return src;
  }
}

var defaults = filesReflect_body.defaults = Object.create( filesReflectEvaluate.defaults );

_.props.extend( defaults, filesReflectAdvancedDefaults );

defaults.filter = null;
defaults.reflectMap = null;
// defaults.outputFormat = 'record';
defaults.outputFormat = 'nothing';

let filesReflect = _.routine.uniteCloning_replaceByUnite( filesReflect_head, filesReflect_body );

_.assert( _.boolLike( filesReflect_body.defaults.mandatory ) );

//

function filesReflector_functor( routine )
{

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( routine ) );
  _.routineExtend( reflector, routine );
  return reflector;

  function reflector()
  {
    let self = this;
    let op0 = self._filesFindPrepare0( routine, arguments );
    _.map.assertHasOnly( op0, reflector.defaults );
    return er;

    function er()
    {
      let o = _.props.extend( null, op0 );
      o.filter = self.recordFilter( o.filter );
      o.src = self.recordFilter( o.src );
      o.dst = self.recordFilter( o.dst );

      for( let a = 0 ; a < arguments.length ; a++ )
      {
        let op2 = arguments[ a ];

        if( _.strIs( op2 ) )
        op2 = { src : { filePath : { [ op2 ] : null } } }

        op2.filter = op2.filter || Object.create( null );
        op2.src = op2.src || Object.create( null );
        if( op2.src.filePath === undefined )
        op2.src.filePath = '';

        op2.dst = op2.dst || Object.create( null );

        o.filter.and( op2.filter ).pathsExtendJoining( op2.filter );
        o.src.and( op2.src ).pathsExtendJoining( op2.src );
        o.dst.and( op2.dst ).pathsExtendJoining( op2.dst );

        op2.filter = o.filter;
        op2.src = o.src;
        op2.dst = o.dst;

        _.props.extend( o, op2 );
      }

      return routine.call( self, o );
    }

  }

}

let filesReflector = filesReflector_functor( filesReflect );

//

function filesReflectTo_head( routine, args )
{
  let self = this;
  let path = self.path;
  let o = args[ 0 ];

  if( args[ 1 ] !== undefined || !_.mapIs( args[ 0 ] ) )
  o = { dstProvider : args[ 0 ], dst : ( args.length > 1 ? args[ 1 ] : routine.defaults.dst ) }

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( 1 === args.length || 2 === args.length );
  _.routine.options_( routine, o );
  _.assert( o.dstProvider instanceof _.FileProvider.Abstract, () => 'Expects file provider {- o.dstProvider -}, but got ' + _.entity.strType( o.dstProvider ) );
  // _.assert( path.s.isAbsolute( o.dst ), 'Expects simple path string {- o.dst -}' );
  // _.assert( path.s.isAbsolute( o.src ), 'Expects simple path string {- o.src -}' );

  return o;
}

//

function filesReflectTo_body( o )
{
  let self = this;
  let src = self;
  let dst = o.dstProvider;
  let system, result;

  if( src instanceof _.FileProvider.System )
  src = src.providerForPath( o.src );

  _.assert( !( src instanceof _.FileProvider.System ) && src instanceof _.FileProvider.Abstract, 'Source provider should be an instance of _.FileProvider.Abstract' )
  _.routine.assertOptions( filesReflectTo_body, arguments );
  _.assert( !src.system || !dst.system || src.system === dst.system, 'not implemented' );

  if( src.system )
  {
    system = src.system;
  }
  else if( dst.system )
  {
    system = dst.system;
  }
  else
  {
    system = new _.FileProvider.System({ empty : 1 });
  }

  let srcProtocol = src.protocol;
  let dstProtocol = dst.protocol;
  let srcRegistered = system.providersWithProtocolMap[ src.protocol ] === src;
  let dstRegistered = system.providersWithProtocolMap[ dst.protocol ] === dst;

  // debugger;
  // if( !src.protocol )
  // src.protocol = system.protocolNameGenerate( 0 );
  // if( !dst.protocol )
  // dst.protocol = system.protocolNameGenerate( 1 );

  if( !src.protocol )
  src.protocol = src.constructor.shortName + src.id;
  if( !dst.protocol )
  dst.protocol = dst.constructor.shortName + dst.id;

  try
  {

    if( !srcRegistered )
    src.providerRegisterTo( system );
    if( !dstRegistered )
    dst.providerRegisterTo( system );

    _.assert( src.system === dst.system );

    // let filePath = { [ src.path.globalFromPreferred( o.srcPath ) ] : dst.path.globalFromPreferred( o.dstPath ) }
    // let filePath = { [ src.path.globalFromPreferred( o.src ) ] : dst.path.globalFromPreferred( o.dst ) }

    if( Config.debug )
    {
      let dstProvider = system.providerForPath( dst.path.globalFromPreferred( o.dst ) );
      _.assert
      (
        dstProvider === dst,
        `Dst path: ${o.dst} reffers to different dst provider: ${dstProvider.protocol}, routine expects: ${dst.protocol}`
      );
    }

    o.src = src.recordFilter( o.src );
    o.dst = dst.recordFilter( o.dst );

    let o2 = _.mapOnly_( null, o, filesReflect.defaults );
    o2.outputFormat = 'record'; /* Dmytro : maybe can be removed and changed tests */

    // o2.reflectMap = filePath;
    // delete o2.src;
    // delete o2.dst;

    result = system.filesReflect( o2 );

    _.assert( !_.consequenceIs( result ), 'not implemented' );

  }
  catch( err )
  {
    debugger;
    throw _.err( err );
  }
  finally
  {
    if( !srcRegistered )
    src.providerUnregister();
    if( !dstRegistered )
    dst.providerUnregister();
    if( !srcRegistered && !dstRegistered )
    system.finit();
  }

  return result;
}

var defaults = filesReflectTo_body.defaults = Object.create( filesReflectPrimeDefaults );

_.props.extend( defaults, filesReflectAdvancedDefaults );

defaults.mandatory = 0;
defaults.dstProvider = null;
defaults.dst = '/';
defaults.src = '/';

let filesReflectTo = _.routine.uniteCloning_replaceByUnite( filesReflectTo_head, filesReflectTo_body );

//

function filesExtract_head( routine, args )
{
  let self = this;
  let path = self.path;
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { src : o }

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( args.length === 1 );
  _.routine.options_( routine, o );
  // _.assert( path.isAbsolute( o.filePath ) );

  return o;
}

//

function filesExtract_body( o )
{
  let self = this;

  _.assert( o.dstProvider === null );

  if( o.dstProvider === null )
  o.dstProvider = new _.FileProvider.Extract();

  let result = self.filesReflectTo( o )

  _.assert( !_.consequenceIs( result ), 'not implemented' );

  return o.dstProvider;
}

var defaults = filesExtract_body.defaults = Object.create( filesReflectTo.defaults );

let filesExtract = _.routine.uniteCloning_replaceByUnite( filesExtract_head, filesExtract_body );

//

function filesFindSame_body( o )
{
  let self = this;
  let logger = self.logger;
  let r = o.result = o.result || Object.create( null );

  /* result */

  _.assert( arguments.length === 1 );
  _.assert( _.object.isBasic( r ) );
  _.assert( _.strIs( o.filePath ) );
  _.assert( o.outputFormat === 'record' );

  /* time */

  let time;
  if( o.usingTiming )
  time = _.time.now();

  /* find */

  let findOptions = _.mapOnly_( null, o, filesFind.defaults );
  findOptions.outputFormat = 'record';
  findOptions.result = [];
  r.unique = self.filesFind.body.call( self, findOptions );

  /* adjust found */

  for( let f1 = 0 ; f1 < r.unique.length ; f1++ )
  {
    let file1 = r.unique[ f1 ];

    if( !file1.stat )
    {
      r.unique.splice( f1, 1 );
      f1 -= 1;
      continue;
    }

    if( file1.isDir )
    {
      r.unique.splice( f1, 1 );
      f1 -= 1;
      continue;
    }

    if( !file1.stat.size > o.maxSize )
    {
      r.unique.splice( f1, 1 );
      f1 -= 1;
      continue;
    }

  }

  /* compare */

  r.similarArray = [];
  r.similarMaps = Object.create( null );
  r.similarGroupsArray = [];
  r.similarGroupsMap = Object.create( null );
  r.similarFilesInTotal = 0;
  r.linkedFilesMap = Object.create( null );
  r.linkGroupsArray = [];

  /* */

  for( let f1 = 0 ; f1 < r.unique.length ; f1++ )
  {
    let file1 = r.unique[ f1 ]
    let path1 = o.relativePaths ? file1.relative : file1.absolute;

    for( let f2 = f1 + 1 ; f2 < r.unique.length ; f2++ )
    {

      let file2 = r.unique[ f2 ];
      let path2 = o.relativePaths ? file2.relative : file2.absolute;
      let minSize = Math.min( file1.stat.size, file2.stat.size );
      let maxSize = Math.max( file1.stat.size, file2.stat.size );

      if( _.files.stat.areHardLinked( file1.stat, file2.stat ) )
      {
        linkAdd();
        continue;
      }

      if( minSize / maxSize < o.similarityLimit )
      continue;

      if( !file1.stat.hash )
      file1.stat.hash = _.strLattersSpectre( self.fileRead( file1.absolute ) );
      if( !file2.stat.hash )
      file2.stat.hash = _.strLattersSpectre( self.fileRead( file2.absolute ) );

      if( self.verbosity >= 4 )
      self.logger.log( '. strLattersSpectresSimilarity', path1, path2 );
      let similarity = _.strLattersSpectresSimilarity( file1.stat.hash, file2.stat.hash );

      if( similarity < o.similarityLimit )
      continue;

      similarityAdd( similarity );

    }

  }

  /* */

  similarGroupsRefine();
  linkGroupsRefine();

  return o.result;

  /* */

  function similarityAdd( similarity )
  {

    let d = Object.create( null );
    d.path1 = path1;
    d.path2 = path2;
    d.similarity = similarity;
    d.id = r.similarArray.length;
    r.similarArray.push( d );

    let similarMap = r.similarMaps[ path1 ] = r.similarMaps[ path1 ] || Object.create( null );
    similarMap[ path2 ] = d;
    similarMap = r.similarMaps[ path2 ] = r.similarMaps[ path2 ] || Object.create( null );
    similarMap[ path1 ] = d;

    let group1 = r.similarGroupsMap[ path1 ];
    let group2 = r.similarGroupsMap[ path2 ];

    if( !group1 )
    r.similarFilesInTotal += 1;

    if( !group2 )
    r.similarFilesInTotal += 1;

    if( group1 && group2 )
    {
      if( group1 === group2 )
      return;
      groupMove( group1, group2 );
    }

    let group = group1 || group2;

    if( !group )
    {
      group = Object.create( null );
      group.paths = [];
      group.paths.push( path1 );
      group.paths.push( path2 );
      r.similarGroupsArray.push( group );
    }
    else if( !group1 )
    {
      _.arrayAppendOnceStrictly( group.paths, path1 );
    }
    else if( !group2 )
    {
      _.arrayAppendOnceStrictly( group.paths, path2 );
    }

    r.similarGroupsMap[ path1 ] = group;
    r.similarGroupsMap[ path2 ] = group;

    // if( r.similarGroupsMap[ path2 ] )
    // {
    //   debugger;
    //   if( r.similarGroupsMap[ similarGroup1 ] )
    //   similarGroup1 = groupMove( path2, similarGroup1 );
    // }
    // else
    // {
    //   r.similarFilesInTotal += 1;
    //
    //   if( !r.similarGroupsMap[ similarGroup1 ] )
    //   {
    //     _.arrayAppendOnceStrictly( r.similarGroupsArray, similarGroup1 );
    //     r.similarGroupsMap[ similarGroup1 ] = [];
    //     r.similarFilesInTotal += 1;
    //   }
    //
    //   let group = r.similarGroupsMap[ similarGroup1 ]
    //   _.arrayAppendOnce( group, path1 );
    //   _.arrayAppendOnce( group, path2 );
    //
    // }

  }

  /* */

  function groupMove( dst, src )
  {
    debugger;

    _.arrayAppendArrayOnceStrictly( dst.paths, src.paths );
    _.arrayRemoveElementOnceStrictly( r.similarGroupsArray, src );

    // if( _.strIs( r.similarGroupsMap[ dst ] ) )
    // debugger;
    // if( _.strIs( r.similarGroupsMap[ dst ] ) )
    // dst = r.similarGroupsMap[ dst ];
    // _.assert( _.arrayIs( r.similarGroupsMap[ src ] ) );
    // _.assert( _.arrayIs( r.similarGroupsMap[ dst ] ) );
    // for( let i = 0 ; i < r.similarGroupsMap[ src ].length ; i++ )
    // {
    //   debugger;
    //   let srcElement = r.similarGroupsMap[ src ][ i ];
    //   _.assert( _.strIs( r.similarGroupsMap[ srcElement ] ) || srcElement === src );
    //   _.arrayAppendOnceStrictly( r.similarGroupsMap[ dst ], srcElement );
    //   r.similarGroupsMap[ srcElement ] = dst;
    // }
    // _.arrayRemoveElementOnceStrictly( r.similarGroupsArray, src );

    return dst;
  }

  /* */

  function similarGroupsRefine()
  {
    for( let g in r.similarGroupsMap )
    {
      let group = r.similarGroupsMap[ g ];
      group.id = r.similarGroupsArray.indexOf( group );
      r.similarGroupsMap[ g ] = group.id;
    }
  }

  /* */

  function linkAdd()
  {
    let d1 = r.linkedFilesMap[ path1 ];
    let d2 = r.linkedFilesMap[ path2 ];
    _.assert( !d1 || !d2, 'Two link descriptors for the same instance of linked file', path1, path2 );
    let d = d1 || d2;
    if( !d )
    {
      d = Object.create( null );
      d.paths = [];
      d.paths.push( path1 );
      d.paths.push( path2 );
      r.linkGroupsArray.push( d );
    }
    else if( !d1 )
    {
      _.arrayAppendOnceStrictly( d.paths, path1 );
    }
    else
    {
      _.arrayAppendOnceStrictly( d.paths, path2 );
    }
    r.linkedFilesMap[ path1 ] = d;
    r.linkedFilesMap[ path2 ] = d;
  }

  /* */

  function linkGroupsRefine()
  {
    for( let f in r.linkedFilesMap )
    {
      let d = r.linkedFilesMap[ f ];
      d.id = r.linkGroupsArray.indexOf( d )
      r.linkedFilesMap[ f ] = d.id;
    }
  }

}

_.routineExtend( filesFindSame_body, filesFindRecursive.body );

var defaults = filesFindSame_body.defaults;
defaults.maxSize = 1 << 22;
// defaults.lattersFileSizeLimit = 1048576;
defaults.similarityLimit = 0.95;

// defaults.usingFast = 1;
// defaults.usingContentComparing = 1;
// defaults.usingTakingNameIntoAccountComparingContent = 1;
// defaults.usingLinkedCollecting = 0;
// defaults.usingSameNameCollecting = 0;

defaults.investigatingLinking = 1;
defaults.investigatingSimilarity = 1;
defaults.usingTiming = 0;
defaults.relativePaths = 0;

defaults.result = null;

let filesFindSame = _.routine.uniteCloning_replaceByUnite( filesFind.head, filesFindSame_body );

filesFindSame.having.aspect = 'entry';

// --
// delete
// --

function filesDelete_head( routine, args )
{
  let self = this;
  args = _.longSlice( args );
  let o = self.filesFind.head.call( self, routine, args );
  return o;
}

/*
qqq :
- add extended test routine
- cover option deletingEmptyDirs
- cover returned result, records of non-exitent files should not be in the result

- if deletingEmptyDirs : 1 then

/a/x
/a/b
/a/b/c
/a/b/c/f1
/a/b/c/f2

filesDelete [ /a/b/c/f1, /a/b/c/f2 ] should delete

/a/b
/a/b/c
/a/b/c/f1
/a/b/c/f2

*/

function filesDelete_body( o )
{
  let self = this;
  let provider = o.filter.effectiveProvider;
  let path = self.path;
  let ready, time;

  if( o.verbosity >= 1 )
  time = _.time.now();

  if( !o.sync )
  ready = new _.Consequence().take( null );

  if( o.late )
  o.visitingCertain = 0;

  _.assert( !o.withTransient, 'Transient files should not be included' );
  _.assert( o.resolvingTextLink === 0 || o.resolvingTextLink === false );
  _.assert( o.resolvingSoftLink === 0 || o.resolvingSoftLink === false );
  _.assert( _.numberIs( o.safe ) );
  _.assert( o.filter.formed === 5 );
  _.assert( arguments.length === 1 );

  /* */

  let o2 = _.mapOnly_( null, o, provider.filesFind.defaults );
  o2.verbosity = 0;
  o2.outputFormat = 'record';
  o2.withTransient = 1;
  _.assert( !!o.withDirs );
  _.assert( !!o.withActual );
  _.assert( !o.withTransient );
  _.assert( o.result === o2.result );

  /* */

  if( o.sync )
  {
    provider.filesFind.body.call( provider, o2 )
    handleResult();
    if( o.deletingEmptyDirs )
    deleteEmptyDirs();
    if( o.writing )
    {
      if( o.late )
      handleLateWriting();
      else
      handleWriting();
    }
    return end();
  }
  else
  {
    ready.then( () => provider.filesFind.body.call( provider, o2 ) );
    ready.then( () => handleResult() );
    if( o.deletingEmptyDirs )
    ready.then( () => deleteEmptyDirs() );
    if( o.writing )
    {
      if( o.late )
      ready.then( () => handleLateWriting() );
      else
      ready.then( () => handleWriting() );
    }
    ready.then( () => end() );
    return ready;
  }

  /* - */

  function handleLateWriting()
  {
    let opened = false;

    if( o.tempPath === null )
    {
      debugger;
      o.tempPath = path.tempOpen( o.result[ 0 ].absolute );
      opened = true;
    }

    let late = [];
    let deleteDirName = 'delete' + '-' + _.idWithDateAndTime();
    for( let f = o.result.length-1 ; f >= 0 ; f-- )
    {
      let record = o.result[ f ];
      if( !record.included || !record.isActual )
      continue;
      if( record.absolute === '/' )
      continue;

      let dstPath = path.join( o.tempPath, deleteDirName, record.relative );
      late.push( dstPath );

      debugger;
      self.fileRename
      ({
        srcPath : record.absolute,
        dstPath,
      })

    }

    _.time.out( 100, () =>
    {
      debugger;
      if( opened )
      path.tempClose( o.tempPath );
      else
      late.forEach( ( dstPath ) => self.filesDelete( dstPath ) );
      debugger;
    });

    return true;
  }

  /* - */

  function handleWriting()
  {
    for( let f = o.result.length-1 ; f >= 0 ; f-- )
    {
      let record = o.result[ f ];
      if( record.included && record.isActual )
      if( record.absolute !== '/' )
      fileDelete( record );
    }
    return true;
  }

  /* - */

  function handleResult()
  {
    for( let f1 = 0 ; f1 < o.result.length ; f1++ )
    {
      let file1 = o.result[ f1 ];

      if( file1.isActual )
      {

        if( !file1.isDir )
        continue;

        if( file1.isTransient )
        {
          /* delete dir if:
            recursive : 0
            its empty
            terminals from dir will be included in result
          */

          if( !o.filter.recursive )
          continue;
          if( o.filter.recursive === 2 && o.withTerminals )
          continue;
          if( provider.dirIsEmpty( file1.absolute ) )
          continue;
        }
      }

      o.result.splice( f1, 1 );
      f1 -= 1;

      if( !file1.isActual || !file1.isTransient )
      for( let f2 = f1 ; f2 >= 0 ; f2-- )
      {
        let file2 = o.result[ f2 ];
        // if( file2.relative === '.' ) /* qqq : ? */
        if( _.strBegins( file1.absolute, file2.absolute ) )
        {
          o.result.splice( f2, 1 );
          f1 -=1 ;
        }
      }
    }

    return true;
  }

  /* - */

  function end()
  {

    if( o.verbosity > 1 || ( o.verbosity === 1 && o.result.length ) )
    {
      let spentTime = _.time.now() - time;
      debugger;
      let groupsMap = path.group({ keys : o.filter.filePath, vals : o.result });
      let textualReport = path.groupTextualReport
      ({
        explanation : o.writing ? ' - Deleted ' : ' - Will delete ',
        groupsMap,
        verbosity : o.verbosity,
        spentTime,
      });
      if( textualReport )
      provider.logger.log( textualReport );
    }

    if( o.outputFormat === 'absolute' )
    o.result = _.select( o.result, '*/absolute' );
    else if( o.outputFormat === 'relative' )
    o.result = _.select( o.result, '*/relative' );
    else _.assert( o.outputFormat === 'record' );

    return o.result;
  }

  /* */

  function fileDelete( file )
  {
    if( o.sync )
    _fileDelete( file );
    else
    ready.then( () => _fileDelete( file ) );
  }

  /* */

  function _fileDelete( file )
  {
    let o2 =
    {
      filePath : file.absolute,
      throwing : o.throwing,
      verbosity : 0,
      safe : o.safe,
      sync : o.sync,
    }

    let r = file.factory.effectiveProvider.fileDelete( o2 );
    if( r === null )
    if( o.verbosity )
    provider.logger.log( ' ! Cant delete ' + file.absolute );
    return r;
  }

  /* - */

  function deleteEmptyDirs()
  {

    if( !o.result.length )
    return true;

    let dirsPath = path.traceToRoot( o.result[ 0 ].dir );
    let factory = o.result[ 0 ].factory;
    let filesMap = Object.create( null );

    _.each( o.result, ( r ) => filesMap[ r.absolute ] = r );

    for( let d = dirsPath.length-1 ; d >= 0 ; d-- )
    {
      let dirPath = dirsPath[ d ];
      let files = provider.dirRead({ filePath : dirPath, outputFormat : 'absolute' });

      for( let f = files.length-1 ; f >= 0 ; f-- )
      {
        let file = files[ f ];
        if( !filesMap[ file ] )
        break;
        files.splice( f, 1 )
      }

      if( files.length )
      break;

      _.assert( !filesMap[ dirPath ] )

      let file = factory.record( dirPath );
      file.isActual = true;
      file.isTransient = true;
      file.included = true;

      filesMap[ dirPath ] = file;

      o.result.unshift( file )
    }

    return true;
  }

}

_.assert( _.routineIs( filesFind.body ) );
_.routineExtend( filesDelete_body, filesFind.body );

var defaults = filesDelete_body.defaults;
defaults.outputFormat = 'record';
defaults.sync = 1;
defaults.withTransient = 0;
defaults.withDirs = 1;
defaults.withTerminals = 1;
defaults.resolvingSoftLink = 0;
defaults.resolvingTextLink = 0;
defaults.allowingMissed = 1;
defaults.allowingCycled = 1;
defaults.verbosity = null;
defaults.maskPreset = 0;
defaults.throwing = null;
defaults.safe = null;
defaults.writing = 1;
defaults.late = 0;
defaults.tempPath = null;
defaults.deletingEmptyDirs = 0;

_.assert( filesFind.defaults.deletingEmptyDirs === undefined );
_.assert( filesFind.body.defaults.deletingEmptyDirs === undefined );
_.assert( filesDelete_body.defaults.deletingEmptyDirs === 0 );
_.assert( filesDelete_body.body === undefined );

/*
qqq : implement and cover option late for method filesDelete.
*/

//

let filesDelete = _.routine.uniteCloning_replaceByUnite( filesFindRecursive.head, filesDelete_body );
filesDelete.having.aspect = 'entry';

var defaults = filesDelete.defaults;
var having = filesDelete.having;

_.assert( !!defaults );
_.assert( !!having );
_.assert( !!filesDelete.defaults.withDirs );

//

function filesDeleteTerminals_body( o )
{
  let self = this;

  _.routine.assertOptions( filesDeleteTerminals_body, arguments );
  _.assert( o.withTerminals );
  _.assert( !o.withDirs );
  _.assert( !o.withTransient, 'Transient files should not be included' );
  _.assert( o.resolvingTextLink === 0 || o.resolvingTextLink === false );
  _.assert( o.resolvingSoftLink === 0 || o.resolvingSoftLink === false );
  _.assert( _.numberIs( o.safe ) );
  _.assert( arguments.length === 1 );

  /* */

  let o2 = _.mapOnly_( null, o, self.filesFind.defaults );

  o2.onDown = _.arrayAppendElement( _.array.as( o.onDown ), handleDown );
  if( _.arrayIs( o2.onDown ) )
  o2.onDown = _.routinesComposeReturningLast( o2.onDown );

  let files = self.filesFind.body.call( self, o2 );

  return files;

  /* */

  function handleDown( record )
  {
    if( o.writing )
    if( record.isActual && !record.isDirectory && record.included )
    self.fileDelete
    ({
      filePath : record.absolute,
      throwing : o.throwing,
      verbosity : o.verbosity,
    });
  }

}

_.routineExtend( filesDeleteTerminals_body, filesDelete.body );

var defaults = filesDeleteTerminals_body.defaults;

defaults.withTerminals = 1;
defaults.withDirs = 0;
defaults.withTransient = 0;

let filesDeleteTerminals = _.routine.uniteCloning_replaceByUnite( filesFindRecursive.head, filesDeleteTerminals_body );

//

function filesDeleteEmptyDirs_body( o )
{
  let self = this;

  /* */

  _.routine.assertOptions( filesDeleteEmptyDirs_body, arguments );
  _.assert( !o.withTerminals );
  _.assert( o.withDirs );
  _.assert( !o.withTransient );

  /* */

  let o2 = _.mapOnly_( null, o, self.filesFind.defaults );

  o2.onDown = _.arrayAppendElement( _.array.as( o.onDown ), handleDown );
  if( _.arrayIs( o2.onDown ) )
  o2.onDown = _.routinesComposeReturningLast( o2.onDown );

  let files = self.filesFind.body.call( self, o2 );

  return files;

  /* */

  function handleDown( record )
  {

    if( !record.included )
    return;

    try
    {

      let sub = self.dirRead( record.absolute );
      if( !sub )
      debugger;

      if( !sub.length )
      self.fileDelete({ filePath : record.absolute, throwing : o.throwing, verbosity : o.verbosity });

    }
    catch( err )
    {
      if( o.throwing )
      throw _.err( err );
    }

  }

}

_.routineExtend( filesDeleteEmptyDirs_body, filesFind.body );

var defaults = filesDeleteEmptyDirs_body.defaults;
defaults.throwing = false;
defaults.verbosity = null;
defaults.outputFormat = 'absolute';
defaults.withTerminals = 0;
defaults.withDirs = 1;
defaults.withTransient = 0;

let filesDeleteEmptyDirs = _.routine.uniteCloning_replaceByUnite( filesFindRecursive.head, filesDeleteEmptyDirs_body );

// --
// other find
// --

function filesRead_head( routine, args )
{
  let self = this;
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { filePath : args[ 0 ] }

  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );

  o = self.filesFind.head.call( self, routine, [ o ] );

  return o;
}

function filesRead_body( o )
{
  let self = this;
  let path = self.path;
  let result = Object.create( null );
  result.dataMap = Object.create( null );
  result.dataArray = [];
  result.errors = [];

  _.assert( o.outputFormat === undefined );

  let o2 = _.mapOnly_( null, o, self.filesFind.defaults );
  o2.outputFormat = 'record';
  let ready = _.Consequence.From( self.filesFind.body.call( self, o2 ) );

  ready.then( ( files ) =>
  {
    let ready = _.Consequence().take( result );

    result.files = files;

    for( let i = 0 ; i < files.length ; i++ )
    ready.also( () => fileRead( files[ i ] ) );

    return ready;
  });

  ready.finally( ( err, arg ) =>
  {
    if( err )
    {
      if( o.throwing )
      throw _.err( err );
      else
      result.errors.push( _.err( err ) );
    }
    if( result.errors.length )
    if( o.throwing )
    throw _.err( result.errors[ 0 ] );
    return result;
  });

  if( o.sync )
  return ready.sync();
  return ready;

  /* */

  function fileRead( record, dstPath )
  {
    let r = null;
    let index = result.dataArray.length;

    try
    {
      let o2 = _.mapOnly_( null, o, self.fileRead.defaults );
      o2.filePath = record.absolute;
      o2.outputFormat = 'data';
      r = _.Consequence.From( self.fileRead( o2 ) );

      r.finally( ( err, data ) =>
      {
        if( err )
        {
          err = _.err( err, `\nFailed to read ${record.absolute}` );
          err.filePath = record.absolute;
          result.errors.push( err );
          return null;
        }
        result.dataMap[ record.absolute ] = data;
        result.dataArray[ index ] = data;
        return null;
      });

    }
    catch( err )
    {
      debugger;
      let error = _.err( err, `\nFailed to read ${record.absolute}` );
      error.filePath = record.absolute;
      result.errors.push( error );
    }

    return r;
  }

}

var defaults = filesRead_body.defaults = _.props.extend( null, Partial.prototype.fileRead.defaults, filesFind.defaults );

defaults.sync = 1;
defaults.throwing = null;
defaults.mode = 'distinct';
defaults.resolvingSoftLink = 1;
defaults.resolvingTextLink = 1;
defaults.withDirs = 0;

delete defaults.outputFormat;

let filesRead = _.routine.uniteCloning_replaceByUnite( filesRead_head, filesRead_body );

//

function filesRename_head( routine, args )
{
  let self = this;
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { filePath : args[ 0 ] }

  o = self.filesFind.head.call( self, routine, [ o ] );

  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );
  _.assert( _.routineIs( o.onRename ) );
  _.assert( _.routineIs( self[ o.linkingAction ] ), `Unknown linkingAction method ${o.linkingAction}` );

  return o;
}

function filesRename_body( o )
{
  let self = this;
  let path = self.path;
  let result = Object.create( null );
  result.dataMap = Object.create( null );
  result.dataArray = [];
  result.errors = [];

  _.assert( o.outputFormat === undefined );

  let o3 = _.mapOnly_( null, o, self[ o.linkingAction ].defaults );
  let o2 = _.mapOnly_( null, o, self.filesFind.defaults );
  o2.outputFormat = 'record';
  o2.onDown = onDown;
  return self.filesFind.body.call( self, o2 );

  function onDown( r )
  {
    let dstPath = o.onRename( r, o );
    _.assert( dstPath === undefined || path.isAbsolute( dstPath ), '{- o.onRename -} should return undefined or absolute path of destination' );
    if( dstPath !== undefined )
    {
      let o4 = Object.assign( Object.create( null ), o3 );
      o4.srcPath = r.absolute;
      o4.dstPath = dstPath;
      r.effectiveProvider[ o.linkingAction ]( o4 );
      r.absolute = dstPath;
    }
    if( o.onDown )
    return o.onDown( ... arguments );
  }

}

var defaults = filesRename_body.defaults = _.props.extend( null, Partial.prototype.fileRename.defaults, filesFind.defaults );

defaults.sync = 1;
defaults.throwing = null;
defaults.mode = 'distinct';
defaults.linkingAction = 'fileRename';
defaults.resolvingSoftLink = 1;
defaults.resolvingTextLink = 1;
defaults.withDirs = 0;
defaults.onRename = null;

delete defaults.outputFormat;

let filesRename = _.routine.uniteCloning_replaceByUnite( filesRename_head, filesRename_body );

//

function softLinksBreak_body( o )
{
  let self = this;

  // o = self.filesFind.head.call( self, softLinksBreak, arguments );

  _.routine.assertOptions( softLinksBreak_body, arguments );
  _.assert( o.outputFormat === 'record' );

  /* */

  let optionsFind = _.mapOnly_( null, o, filesFind.defaults );
  optionsFind.onDown = _.arrayAppendElement( _.array.as( optionsFind.onDown ), function( record )
  {

    debugger;
    throw _.err( 'not tested' );

    if( o.breakingSoftLink && record.isSoftLink )
    self.softLinkBreak( record.absolute );
    if( o.breakingTextLink && record.isTextLink )
    self.softLinkBreak( record.absolute );

  });

  let files = self.filesFind.body.call( self, optionsFind );

  return files;
}

// _.routineExtend( softLinksBreak, filesFind );

// var defaults = softLinksBreak_body.defaults;

_.routineExtend( softLinksBreak_body, filesFind.body );

var defaults = softLinksBreak_body.defaults;

defaults.outputFormat = 'record';
defaults.breakingSoftLink = 1;
defaults.breakingTextLink = 0;
// defaults.recursive = 2;

let softLinksBreak = _.routine.uniteCloning_replaceByUnite( filesFindRecursive.head, softLinksBreak_body );

//

function softLinksRebase_body( o )
{
  let self = this;
  // o = self.filesFind.head.call( self, softLinksRebase, arguments );

  _.routine.assertOptions( softLinksRebase_body, arguments );
  _.assert( o.outputFormat === 'record' );
  _.assert( !o.resolvingSoftLink );

  /* */

  let optionsFind = _.mapOnly_( null, o, filesFind.defaults );
  optionsFind.onDown = _.arrayAppendElement( _.array.as( optionsFind.onDown ), function( record )
  {

    if( !record.isSoftLink )
    return;

    record.isSoftLink;
    let resolvedPath = self.pathResolveSoftLink( record.absolutePreferred );
    let rebasedPath = self.path.rebase( resolvedPath, o.oldPath, o.newPath );
    self.fileDelete({ filePath : record.absolutePreferred, verbosity : 0 });
    self.softLink
    ({
      dstPath : record.absolutePreferred,
      srcPath : rebasedPath,
      allowingMissed : 1,
      allowingCycled : 1,
    });

    _.assert( !!self.statResolvedRead({ filePath : record.absolutePreferred, resolvingSoftLink : 0 }) );

  });

  let files = self.filesFind.body.call( self, optionsFind );

  return files;
}

_.routineExtend( softLinksRebase_body, filesFind.body );

var defaults = softLinksRebase_body.defaults;

// _.routineExtend( softLinksRebase, filesFind );
// var defaults = softLinksRebase_body.defaults;

defaults.outputFormat = 'record';
defaults.oldPath = null;
defaults.newPath = null;
// defaults.recursive = 2;
defaults.resolvingSoftLink = 0;

let softLinksRebase = _.routine.uniteCloning_replaceByUnite( filesFindRecursive.head, softLinksRebase_body );

//

/*
qqq : has poor coverage! please improve.
qqq : optimize
*/

function filesHasTerminal( filePath )
{
  let self = this;
  _.assert( arguments.length === 1 );

  let terminal = false;

  debugger;
  self.filesFindRecursive
  ({
    filePath,
    withStem : 1,
    withDirs : 1,
    withTerminals : 1,
    onUp,
    resolvingSoftLink : 0,
    resolvingTextLink : 0,
    // recursive : 2
  })

  return terminal;

  /* */

  function onUp( record )
  {
    debugger;
    if( terminal )
    return _.dont;
    if( record.stat && !record.isDir )
    terminal = record;
    return record;
  }
}

// --
// resolver
// --

function filesResolve( o )
{
  let self = this;
  let result;
  o = _.routine.options_( filesResolve, arguments );

  _.assert( _.object.isBasic( o.translator ) );

  let globPath = o.translator.realFor( o.globPath );
  let globOptions = _.mapOnly_( null, o, self.filesGlob.defaults );

  globOptions.filter = globOptions.filter || Object.create( null );
  globOptions.filePath = globPath;
  globOptions.filter.basePath = o.translator.realRootPath;
  globOptions.outputFormat = o.outputFormat;

  _.assert( !!self );

  result = self.filesGlob( globOptions );

  return result;
}

_.routineExtend( filesResolve, filesGlob );

var defaults = filesResolve.defaults;
defaults.globPath = null;
defaults.translator = null;
defaults.outputFormat = 'record';

// --
// relations
// --

let ReflectAction =
{
  'fileCopy' : 'fileCopy',
  'hardLink' : 'hardLink',
  'hardLinkMaybe' : 'hardLinkMaybe',
  'softLink' : 'softLink',
  'softLinkMaybe' : 'softLinkMaybe',
  'textLink' : 'textLink',
  'nop' : 'nop',
}

let ReflectMandatoryAction =
{
  'fileCopy' : 'fileCopy',
  'hardLink' : 'hardLink',
  'softLink' : 'softLink',
  'textLink' : 'textLink',
  'nop' : 'nop',
}

let ReflecEvalAction =
{
  'exclude' : 'exclude',
  'ignore' : 'ignore',
  'fileDelete' : 'fileDelete',
  'dirMake' : 'dirMake',
  'fileCopy' : 'fileCopy',
  'softLink' : 'softLink',
  'hardLink' : 'hardLink',
  'textLink' : 'textLink',
  'nop' : 'nop',
}

let FindOutputFormat =
{
  'absolute' : 'absolute',
  'relative' : 'relative',
  'real' : 'real',
  'record' : 'record',
  'nothing' : 'nothing',
}

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{
  ReflectAction,
  ReflectMandatoryAction,
  ReflecEvalAction,
  FindOutputFormat,
}

// --
// declare
// --

let Supplement =
{

  // etc

  recordsOrder,

  // find

  _filesFindPrepare0,
  _filesFindPrepare1,
  _filesFindPrepare2,
  _filesFindFilterAbsorb,

  filesFindNominal,
  filesFindSingle,
  filesFind,
  filesFindRecursive,
  filesGlob,

  filesFinder_functor,
  filesFinder,
  filesGlober,

  //

  filesFindGroups,
  filesReadGroups,

  // reflect

  _filesFiltersPrepare,
  _filesReflectPrepare,

  filesReflectEvaluate,
  filesReflectSingle,
  filesReflect, /* xxx qqq : write test of filesReflect into itself with goal to change extensions */

  filesReflector_functor,
  filesReflector,

  filesReflectTo,
  filesExtract,

  // same

  filesFindSame,

  // delete

  filesDelete,
  filesDeleteTerminals,
  filesDeleteEmptyDirs,

  // other find

  filesRead, /* qqq : cover please */
  filesRename, /* qqq : cover please */

  softLinksBreak,
  softLinksRebase,
  filesHasTerminal,

  // resolver

  filesResolve,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  supplement : Supplement,
  withMixin : true,
  withClass : true,
});

_.FileProvider = _.FileProvider || Object.create( null );
_.FileProvider[ Self.shortName ] = Self;

_.assert( !!_.FileProvider.FindMixin.prototype.filesDelete.defaults.withDirs );

Self.mixin( Partial );

_.assert( !!_.FileProvider.Partial.prototype.filesDelete.defaults.withDirs );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

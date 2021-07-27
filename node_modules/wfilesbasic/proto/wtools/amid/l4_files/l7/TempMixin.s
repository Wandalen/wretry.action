( function _TempMixin_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
const FileRecord = _.files.FileRecord;
const Abstract = _.FileProvider.Abstract;
const Partial = _.FileProvider.Partial;

_.assert( _.entity.lengthOf( _.files.ReadEncoders ) > 0 );
_.assert( _.routineIs( _.files.FileRecord ) );
_.assert( _.routineIs( Abstract ) );
_.assert( _.routineIs( Partial ) );

//

/**
 @class wFileProviderTempMixin
 @class FileProvider
 @namespace wTools
 @module Tools/mid/Files
*/

const Parent = null;
const Self = wFileProviderTempMixin;
function wFileProviderTempMixin( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'TempMixin';

// --
// implementation
// --

function tempCollectionMaking( o )
{
  let self = this;

  let tempCollection = self.TempCollection[ self.id ];
  if( !tempCollection )
  {
    tempCollection = self.TempCollection[ self.id ] = Object.create( null );
    tempCollection.associated = Object.create( null );
    tempCollection.wild = new Set;
  }

  return tempCollection;
}

//

function tempHead( routine, args )
{
  let self = this;
  let path = self.path;
  let o = args[ 0 ];

  if( !_.mapIs( args[ 0 ] ) )
  o = { srcPath : args[ 0 ] }
  if( args[ 1 ] !== undefined )
  o.name = args[ 1 ];

  if( o.srcPath === undefined || o.srcPath === null )
  o.srcPath = null;
  else
  o.srcPath = path.resolve( o.srcPath );

  _.routine.options( routine, o );
  _.assert( args.length <= 2 );
  _.assert( o.srcPath === null || path.isAbsolute( o.srcPath ) );
  _.assert( o.srcPath === null || path.isNormalized( o.srcPath ) );
  _.assert( arguments.length === 2 );

  return o;
}

//

function tempAt_body( o )
{
  let self = this;
  let path = self.path;
  let err;
  let dirTemp = path.dirTemp();
  let tempCollection = self.tempCollectionMaking();

  _.assert( !o.tempStoragePath );

  o.providerId = self.id;

  if( o.srcPath === null )
  {
    return make( dirTemp );
  }
  else
  {
    let result = tempCollection.associated[ o.srcPath ];
    if( result )
    return result;
  }

  let sameDevice = self.filesAreOnSameDevice( o.srcPath, dirTemp );
  if( sameDevice )
  return make( dirTemp );

  /* */

  let fileStat = statRead( o.srcPath );
  let trace = path.traceToRoot( o.srcPath );
  if( !trace.length )
  {
    _.assert( o.srcPath === '/' );
    trace = [ o.srcPath ];
  }
  else if( trace.length > 1 )
  trace.shift();

  for( let i = 0; i < trace.length; i++ )
  {
    try
    {
      if( trace[ i ] === '/' )
      continue;

      if( self.fileExists( trace[ i ] ) )
      {
        let currentStat = statRead( trace[ i ] );
        if( fileStat.dev != currentStat.dev )
        continue;
      }

      if( tempCollection.associated[ trace[ i ] ] )
      return tempCollection.associated[ trace[ i ] ];
      else
      return make( trace[ i ] );
    }
    catch( e )
    {
      err = e;
    }
  }

  return make( dirTemp );

  /* */

  function make( dirPath )
  {
    _.assert( !o.tempStoragePath );
    o.tempStoragePath = dirPath;
    return o;
  }

  /* */

  function statRead( filePath )
  {
    return self.statReadAct
    ({
      filePath,
      throwing : 0,
      sync : 1,
      resolvingSoftLink : 1,
    });
  }

  /* */

}

tempAt_body.defaults =
{
  srcPath : null,
}

let tempAt = _.routine.unite( tempHead, tempAt_body );

//

function tempMake_body( o )
{
  let self = this;
  let path = self.path;
  let err;
  let dirTemp = path.dirTemp();
  let tempCollection = self.tempCollectionMaking();

  if( !o.name )
  o.name = 'tmp';
  if( !o.tempName )
  o.tempName = o.name + '-' + _.idWithDateAndTime() + '.tmp';
  o.providerId = self.id;

  if( !o.tempStoragePath && !o.tempPath )
  o = self.tempAt.body.call( self, o );
  _.assert( !!o.tempStoragePath );

  if( o.counter )
  return reuse( o );
  return make( o );

  /* */

  function reuse( o )
  {
    o.counter += 1;
    return o;
  }

  /* */

  function make( o )
  {
    o.close = close;
    o.counter = 1;

    if( !o.tempPath )
    o.tempPath = path.join( o.tempStoragePath, o.tempName );
    if( !self.fileExists( o.tempPath ) )
    self.dirMake( o.tempPath );

    if( o.resolving ) /* xxx : qqq : cover the option please */
    o.tempPath = self.pathResolveLinkFull
    ({
      filePath : o.tempPath,
      resolvingSoftLink : 1,
    }).absolutePath;

    if( o.srcPath === null )
    tempCollection.wild.add( o );
    else
    tempCollection.associated[ o.srcPath ] = o;

    if( o.auto )
    _.process.on( _.event.Chain( 'available', 'exit' ), () =>
    {
      o.close();
    });

    return o;
  }

  /* */

  function close()
  {
    this.counter -= 1;
    _.assert( this.counter >= 0 );
    if( this.counter > 0 )
    return false;

    _.assert( this.counter === 0 );
    this.counter = -1;
    Object.freeze( this );

    if( o.srcPath === null )
    {
      _.assert( tempCollection.wild.has( o ) );
      tempCollection.wild.delete( o );
    }
    else
    {
      _.assert( !!tempCollection.associated[ this.srcPath ] );
      delete tempCollection.associated[ this.srcPath ];
    }

    self.filesDelete
    ({
      filePath : this.tempPath,
      safe : 0,
      throwing : 0,
    });
    _.assert
    (
      !self.fileExists( o.tempPath ),
      () => `Temp dir "${o.tempPath}" was closed, but still exist in file system.`
    );

    return true;
  }

}

tempMake_body.defaults =
{
  srcPath : null,
  tempPath : null,
  tempStoragePath : null,
  name : null,
  tempName : null,
  resolving : 1,
  auto : 1,
}

let tempMake = _.routine.unite( tempHead, tempMake_body );

//

function tempOpen_body( o )
{
  let self = this;
  let path = self.path;

  o = self.tempMake.body.call( self, o );

  return o;
}

tempOpen_body.defaults =
{
  ... tempMake.defaults,
}

let tempOpen = _.routine.unite( tempHead, tempOpen_body );

//
//

function tempClose( srcPath )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length <= 1 );
  _.assert( _.str.is( srcPath ) || srcPath === undefined );

  let tempCollection = self.TempCollection[ self.id ];
  if( !tempCollection )
  return;

  if( _.str.is( srcPath ) )
  {
    _.assert( path.isAbsolute( srcPath ) );
    _.assert( path.isNormalized( srcPath ) );
    let o = tempCollection.associated[ srcPath ];
    if( o.close )
    o.close();
  }
  else
  {
    for( let p in tempCollection.associated )
    tempCollection.associated[ p ].close();
    _.assert( _.props.keys( tempCollection ).length === 0 );

    for( let e of tempCollection.wild )
    e.close();
    _.assert( tempCollection.wild.size === 0 );

    delete self.TempCollection[ self.id ];
  }

}

// --
// relations
// --

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
  TempCollection : Object.create( null ),
}

// --
// declare
// --

let Supplement =
{

  tempCollectionMaking,
  tempAt,
  tempMake,
  tempOpen,
  tempClose,

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

Self.mixin( Partial );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();

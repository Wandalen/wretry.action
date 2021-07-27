( function _Linker_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

_.assert( _.object.isBasic( _.files ) );

const Self = _.files.linker = _.files.linker || Object.create( null );

// --
// linkingAction
// --

function multiple( o, link )
{
  let self = this;

  if( o.dstPath.length < 2 )
  return o.sync ? 0 : new _.Consequence().take( 0 );

  _.assert( !!o );
  _.assert( _.strIs( o.srcPath ) || o.srcPath === null );
  _.assert( _.strIs( o.sourceMode ) || _.longIs( o.sourceMode ) );
  _.assert( _.boolLike( o.allowingMissed ) );
  _.assert( _.boolLike( o.allowingCycled ) );

  let needed = 0;
  let factory = self.recordFactory({ allowingMissed : o.allowingMissed, allowingCycled : o.allowingCycled });
  let records = factory.records( o.dstPath );
  // Vova : should allow missing files?
  // Kos : test routine?
  let newestRecord, mostLinkedRecord;

  if( o.srcPath )
  {
    if( !self.statResolvedRead( o.srcPath ) )
    return error( _.err( '{ o.srcPath } ', o.srcPath, ' doesn\'t exist.' ) );
    newestRecord = mostLinkedRecord = self.record( o.srcPath );
  }
  else
  {
    let sorter = o.sourceMode;
    _.assert( !!sorter, 'Expects { option.sourceMode }' );
    newestRecord = self._recordsSort( records, sorter );

    if( !newestRecord )
    return error( _.err( 'Source file was not selected, probably provided paths { o.dstPath } do not exist.' ) );

    let zero = self.UsingBigIntForStat ? BigInt( 0 ) : 0;
    mostLinkedRecord = _.entityMax( records, ( record ) => record.stat ? record.stat.nlink : zero ).element;
  }

  for( let p = 0 ; p < records.length ; p++ )
  {
    let record = records[ p ];
    if( !record.stat || !_.files.stat.areHardLinked( newestRecord.stat, record.stat ) )
    {
      needed = 1;
      break;
    }
  }

  if( !needed )
  return o.sync ? 0 : new _.Consequence().take( 0 );

  /* */

  if( mostLinkedRecord.absolute !== newestRecord.absolute )
  {
    let read = self.fileRead({ filePath : newestRecord.absolute, encoding : 'meta.original' });
    self.fileWrite( mostLinkedRecord.absolute, read );
    /*
      fileCopy cant be used here
      because hardlinks of most linked file with other files should be preserved
    */
  }

  /* */

  let result = { err : undefined, got : true };

  if( o.sync )
  {
    for( let p = 0 ; p < records.length ; p++ )
    {
      if( !onRecord( records[ p ] ) )
      return false;
    }
    return true;
  }
  else
  {
    let cons = [];
    // let result = { err : undefined, got : true };
    let throwing = o.throwing;
    o.throwing = 1;

    for( let p = 0 ; p < records.length ; p++ )
    cons.push( onRecord( records[ p ] ).tap( handler ) );

    let con = new _.Consequence().take( null );

    con.andKeep( cons )
    .finally( () =>
    {
      if( result.err )
      {
        if( throwing )
        throw result.err;
        else
        return false;
      }
      return result.got;
    });

    return con;
  }

  /* - */

  function error( err )
  {
    if( o.sync )
    throw err;
    else
    return new _.Consequence().error( err );
  }

  /* */

  function handler( err, got )
  {
    if( !err )
    {
      result.got &= got;
    }
    else
    {
      _.errAttend( err );
      if( !_.definedIs( result.err ) )
      result.err = err;
    }
  }

  /* */

  function onRecord( record )
  {
    if( record === mostLinkedRecord )
    return o.sync ? true : new _.Consequence().take( true );

    // if( !o.allowingDiscrepancy ) /* qqq : cover */
    // if( !self.filesCanBeSame( result.src, record.src, true ) )
    // if( result.src.stat.size !== 0 || record.src.stat.size !== 0 )
    // {
    //   throw _.err
    //   (
    //     'Cant\'t rewrite destination file by source file, because they have different content and option::allowingDiscrepancy is false\n'
    //     + `\ndst: ${result.dst.absolute}`
    //     + `\nsrc: ${result.src.absolute}`
    //   );
    // }

    // if( !o.allowingDiscrepancy )
    // // if( record.stat && newestRecord.stat.mtime.getTime() === record.stat.mtime.getTime() && newestRecord.stat.birthtime.getTime() === record.stat.birthtime.getTime() )
    // {
    //   if( _.files.stat.different( newestRecord.stat , record.stat ) )
    //   {
    //     if( o.sync )
    //     throw err;
    //     else
    //     return new _.Consequence().error( err );
    //   }
    // }

    if( !record.stat || !_.files.stat.areHardLinked( mostLinkedRecord.stat, record.stat ) )
    {
      let linkOptions = _.props.extend( null, o );
      linkOptions.allowingMissed = 0; /* Vova : hardLink does not allow missing srcPath */
      linkOptions.dstPath = record.absolute;
      linkOptions.srcPath = mostLinkedRecord.absolute;
      return link.call( self, linkOptions );
    }

    return o.sync ? true : new _.Consequence().take( true );
  }

}

//

function onIsLink( stat )
{
  let self = this.provider;

  if( stat.isSoftLink() )
  return true;

  if( this.onIsLink2 )
  return this.onIsLink2.call( self, stat );

  return false;
}

//

function onStat( filePath, resolving )
{
  let c = this;
  let self = c.provider;

  if( c.onStat2 )
  return c.onStat2.call( self, filePath, resolving );

  return self.statRead
  ({
    filePath,
    throwing : 0,
    resolvingSoftLink : resolving,
    resolvingTextLink : 0,
    sync : 1,
  });
}

//

function verify1( args )
{
  let c = this;
  let o = c.options;

  _.assert( args.length === 1, 'Expects single argument' );
  _.assert( _.routineIs( c.linkDo ), 'method', c.actMethodName, 'is not implemented' );
  _.assert( _.object.isBasic( c.linkDo.defaults ), 'method', c.actMethodName, 'does not have defaults, but should' );
  _.routine.assertOptions( c.linkBody, args );
  _.assert( _.boolLike( o.resolvingSrcSoftLink ) || _.numberIs( o.resolvingSrcSoftLink ) );
  _.assert( _.boolLike( o.resolvingSrcTextLink ) || _.numberIs( o.resolvingSrcTextLink ) );
  _.assert( _.boolLike( o.resolvingDstSoftLink ) || _.numberIs( o.resolvingDstSoftLink ) );
  _.assert( _.boolLike( o.resolvingDstTextLink ) || _.numberIs( o.resolvingDstTextLink ) );
  _.assert( _.boolLike( o.allowingMissed ) );
  _.assert( _.boolLike( o.allowingCycled ) );
  _.assert( o.originalSrcPath === undefined );
  _.assert( o.originalDstPath === undefined );
  _.assert( o.relativeSrcPath === undefined );
  _.assert( o.relativeDstPath === undefined );

  if( c.onVerify1 )
  {
    let r = c.onVerify1.call( c.provider, c );
    _.assert( r === undefined );
  }

}

//

function verify1Async( args )
{
  let c = this;

  c.con.then( () =>
  {
    verify1.call( c, args );
    return true;
  })
}

//

function verify2()
{
  let c = this;
  let self = this.provider;
  let o = c.options;

  /* allowingMissed */

  if( !o.allowingMissed || c.skippingMissed )
  {
    if( !c.srcStat )
    {
      if( !o.allowingMissed )
      {
        let err = _.err( 'Source file', _.strQuote( o.srcPath ), 'does not exist' );
        c.error( err );
        return true;
      }
      if( c.skippingMissed )
      {
        c.end( false );
        return true;
      }
    }
  }

  /* equal paths */

  if( c.verifyEqualPaths() )
  return true;

  /* */

  /* xxx qqq : allowingDiscrepancy should be similar to !dstRewritingOnlyPreserving */
  if( _.boolLikeFalse( o.allowingDiscrepancy ) ) /* qqq : cover */
  if( c.srcResolvedStat )
  if( self.fileExists( c.options2.dstPath ) )
  if( !self.filesAreSameForSure( c.options2.srcPath, c.options2.dstPath, false ) ) /* qqq xxx : optimize */
  if( Number( c.srcResolvedStat.size ) !== 0 )
  {
    throw _.err
    (
      'Cant\'t rewrite destination file by source file, because they have different content and option::allowingDiscrepancy is false\n'
      + `\ndst: ${o.dstPath}`
      + `\nsrc: ${o.srcPath}`
    );
  }

  /* skipping */

  if( c.onVerify2 )
  {
    let r = c.onVerify2.call( self, c );
    _.assert( r === undefined );
  }

  return false;
}

//

function verifyEqualPaths()
{
  let c = this;
  let self = c.provider;
  let o = c.options;

  if( o.dstPath === o.srcPath )
  {

    if( c.skippingSamePath )
    {
      c.end( true );
      return true;
    }

    if( !o.allowingMissed )
    {
      let err = _.err( 'Making link on itself is not allowed. Please enable options {-o.allowingMissed-} if that was your goal.' );
      c.error( err );
      return true;
    }
  }

  return false;
}

//

function verify2Async()
{
  let c = this;

  c.con.then( () =>
  {
    if( c.ended )
    return c.end();
    return verify2.call( c );
  });
}

//

function verifyDstSync()
{
  let c = this;
  let self = this.provider;
  let o = c.options;
  let o2 = c.options2;

  if( !o.rewriting )
  throw _.err( 'Destination file ' + _.strQuote( o2.dstPath ) + ' exist and rewriting is off.' );

  if( c.dstStat === undefined )
  c.dstStat = self.statRead
  ({
    filePath : o2.dstPath,
    sync : 1,
  });

  if( c.dstStat.isDirectory() && !o.rewritingDirs )
  throw _.err( 'Destination file ' + _.strQuote( o2.dstPath ) + ' is a directory and rewritingDirs is off.' );

}

//

function verifyDstAsync()
{
  let c = this;
  let self = this.provider;
  let o = c.options;
  let o2 = c.options2;

  if( !o.rewriting )
  throw _.err( 'Destination file ' + _.strQuote( o2.dstPath ) + ' exist and rewriting is off.' );

  return self.statRead
  ({
    filePath : o2.dstPath,
    sync : 0,
  })
  .then( ( stat ) =>
  {
    _.assert( c.dstStat === undefined );
    c.dstStat = stat;
    if( c.dstStat.isDirectory() && !o.rewritingDirs )
    throw _.err( 'Destination file ' + _.strQuote( o2.dstPath ) + ' is a directory and rewritingDirs is off.' );
    return stat;
  })
}

//

/* qqq : implement test suite:
  - system
  - no default provider
  -
*/

function pathsLocalizeSync() /* qqq : ignoring provider is temp workaround. please redo */
{
  let c = this;
  let self = c.provider;
  let o = c.options;

  if( self instanceof _.FileProvider.System )
  {
    return;
  }

  if( self.path.isGlobal( o.dstPath ) )
  {
    let dstParsed = _.uri.parse( o.dstPath );
    if( dstParsed.protocol && !_.longHas( self.protocols, dstParsed.protocol ) )
    c.error( _.err( 'File provider ' + self.qualifiedName + ' does not support protocol ' + _.strQuote( dstParsed.protocol ) ) );
    o.dstPath = dstParsed.longPath;
  }

  if( self.path.isGlobal( o.srcPath ) )
  {
    let srcParsed = _.uri.parse( o.srcPath );
    if( srcParsed.protocol && _.longHas( self.protocols, srcParsed.protocol ) )
    o.srcPath = srcParsed.longPath;
  }

}

//

function pathsLocalizeAsync()
{
  let c = this;
  c.con.then( () =>
  {
    if( c.ended )
    return c.end();
    pathsLocalizeSync.call( c );
    return null;
  });
}

//

function pathResolve()
{
  let c = this;
  let self = c.provider;
  let path = self.system ? self.system.path : self.path;
  let o = c.options;

  o.relativeSrcPath = o.srcPath;
  o.relativeDstPath = o.dstPath;

  if( !path.isAbsolute( o.dstPath ) )
  {
    _.assert( path.isAbsolute( o.srcPath ), () => 'Expects absolute path {-o.srcPath-}, but got', _.strQuote( o.srcPath ) );
    o.dstPath = path.join( o.srcPath, o.dstPath );
  }
  else if( !path.isAbsolute( o.srcPath ) )
  {
    _.assert( path.isAbsolute( o.dstPath ), () => 'Expects absolute path {-o.dstPath-}, but got', _.strQuote( o.dstPath ) );
    o.srcPath = path.join( o.dstPath, o.srcPath );
  }
  else
  {
    /*
      add protocol if any
    */
    if( path.isGlobal( o.srcPath ) )
    o.dstPath = path.join( o.srcPath, o.dstPath );
    else if( path.isGlobal( o.dstPath ) )
    o.srcPath = path.join( o.dstPath, o.srcPath );
  }

  _.assert( path.isAbsolute( o.srcPath ) );
  _.assert( path.isAbsolute( o.dstPath ) );

  c.originalSrcResolvedPath = o.srcPath;

  /* check if equal early */

  c.verifyEqualPaths();
}

//

function pathResolveAsync()
{
  let c = this;
  c.con.then( () =>
  {
    if( c.ended )
    return c.end();
    pathResolve.call( c );
    return true;
  })
}

//

function linksResolve()
{
  let c = this;
  let self = c.provider;
  let path = self.system ? self.system.path : self.path;
  let o = c.options;

  try
  {

    _.assert( path.isAbsolute( o.srcPath ) );
    _.assert( path.isAbsolute( o.dstPath ) );

    if( o.resolvingDstSoftLink || ( o.resolvingDstTextLink && self.usingTextLink ) )
    {
      let o2 =
      {
        filePath : o.dstPath,
        resolvingSoftLink : o.resolvingDstSoftLink,
        resolvingTextLink : o.resolvingDstTextLink,
        allowingCycled : 1,
        allowingMissed : 1,
        preservingRelative : 1,
      }
      let resolved = self.pathResolveLinkFull( o2 );
      o.dstPath = resolved.absolutePath;
      o.relativeDstPath = resolved.relativePath;
      c.dstStat = o2.stat; /* it's ok */
    }
    else
    {
    }

    /* */

    if( o.resolvingSrcSoftLink || ( o.resolvingSrcTextLink && self.usingTextLink ) )
    {
      let o2 =
      {
        filePath : o.srcPath,
        resolvingSoftLink : o.resolvingSrcSoftLink,
        resolvingTextLink : o.resolvingSrcTextLink,
        allowingCycled : o.allowingCycled,
        allowingMissed : o.allowingMissed,
        throwing : o.throwing,
        preservingRelative : 1,
      }
      let resolved = self.pathResolveLinkFull( o2 );
      o.srcPath = resolved.absolutePath;

      if( ( resolved.filePath !== null && path.isRelative( resolved.filePath ) ) || path.isRelative( o.relativeSrcPath ) )
      {
        o.relativeSrcPath = path.relative( o.dstPath, resolved.absolutePath );
      }
      else /* xxx : qqq : ? */
      {
        o.relativeSrcPath = resolved.filePath;
      }

      // if( resolved.relativePath )
      // {
      //   if( path.isRelative( resolved.relativePath ) || path.isRelative( o.relativeSrcPath ) )
      //   o.relativeSrcPath = path.relative( o.dstPath, resolved.absolutePath );
      //   else
      //   o.relativeSrcPath = resolved.relativePath;
      // }

      c.srcStat = o2.stat;

      c.srcResolvedStat = c.srcStat;
      if( Config.debug )
      if( c.srcResolvedStat )
      if( c.onIsLink( c.srcResolvedStat ) )
      c.srcResolvedStat = c.onStat( o.srcPath, 1 );

    }
    else
    {
      /* do not read stat if possible */
      c.srcStat = c.onStat( o.srcPath, 0 );

      c.srcResolvedStat = c.srcStat;
      if( Config.debug )
      if( c.srcResolvedStat )
      if( c.onIsLink( c.srcResolvedStat ) )
      c.srcResolvedStat = c.onStat( o.srcPath, 1 );

    }

    _.assert( _.strIs( o.relativeSrcPath ) );
    _.assert( _.strIs( o.relativeDstPath ) );

  }
  catch( err )
  {
    c.error( err );
  }

}

//

function linksResolveAsync()
{
  let c = this;
  let self = this.provider;
  let path = self.system ? self.system.path : self.path;
  let o = c.options;

  c.con.then( () =>
  {
    if( c.ended )
    return c.end();

    _.assert( path.isAbsolute( o.srcPath ) );
    _.assert( path.isAbsolute( o.dstPath ) );

    if( o.resolvingDstSoftLink || ( o.resolvingDstTextLink && self.usingTextLink ) )
    {
      let o2 =
      {
        filePath : o.dstPath,
        resolvingSoftLink : o.resolvingDstSoftLink,
        resolvingTextLink : o.resolvingDstTextLink,
        sync : 0,
        allowingCycled : 1,
        allowingMissed : 1,
        preservingRelative : 1,
      }
      return self.pathResolveLinkFull( o2 ).then( ( resolved ) =>
      {
        o.dstPath = resolved.absolutePath;
        o.relativeDstPath = resolved.relativePath;
        c.dstStat = o2.stat;
        return true;
      })
    }

    return true;
  })

  /* */

  c.con.then( () =>
  {
    if( c.ended )
    return c.end();

    if( o.resolvingSrcSoftLink || ( o.resolvingSrcTextLink && self.usingTextLink ) )
    {
      let o2 =
      {
        filePath : o.srcPath,
        resolvingSoftLink : o.resolvingSrcSoftLink,
        resolvingTextLink : o.resolvingSrcTextLink,
        allowingCycled : o.allowingCycled,
        allowingMissed : o.allowingMissed,
        sync : 0,
        preservingRelative : 1,
        throwing : o.throwing
      }

      return self.pathResolveLinkFull( o2 )
      .then( ( resolved ) =>
      {
        o.srcPath = resolved.absolutePath;

        if( ( resolved.filePath !== null && path.isRelative( resolved.filePath ) ) || path.isRelative( o.relativeSrcPath ) )
        {
          o.relativeSrcPath = path.relative( o.dstPath, resolved.absolutePath );
        }
        else /* xxx : qqq : ? */
        {
          o.relativeSrcPath = resolved.filePath;
        }

        // if( resolved.filePath !== null && path.isRelative( resolved.filePath ) )
        // {
        //   o.relativeSrcPath = path.relative( o.dstPath, resolved.absolutePath );
        // }
        // else /* xxx : qqq : bad */
        // {
        //   o.relativeSrcPath = resolved.filePath;
        // }

        // if( resolved.relativePath )
        // {
        //   if( path.isRelative( resolved.relativePath ) || path.isRelative( o.relativeSrcPath ) )
        //   o.relativeSrcPath = path.relative( o.dstPath, resolved.absolutePath );
        //   else
        //   o.relativeSrcPath = resolved.relativePath;
        // }

        c.srcStat = o2.stat;
        return true;
      })
    }
    else
    {
      /* do not read stat if possible */
      return self.statRead({ filePath : o.srcPath, sync : 0 })
      .then( ( srcStat ) =>
      {
        c.srcStat = srcStat;
        return true;
      });
    }
  })
}

//

function log()
{
  let c = this;
  let self = this.provider;
  let path = self.system ? self.system.path : self.path;
  let o = c.options;

  if( !o.verbosity || o.verbosity < 2 )
  return;
  self.logger.log( ' +', c.entryMethodName, ':', path.moveTextualReport( o.dstPath, o.srcPath ) );
}

//

function tempRenameCan()
{
  let c = this;
  let o = c.options;

  _.assert( _.fileStatIs( c.dstStat ) );

  if( !c.renaming )
  return false;

  if( _.boolLike( o.breakingDstHardLink ) )
  if( !o.breakingDstHardLink && c.dstStat.isHardLink() )
  return false;

  return true;
}

//

function tempRenameSync()
{
  let c = this;
  let self = this.provider;
  let o = c.options;
  let o2 = c.options2;

  c.tempPath = c.tempNameMake( o2.dstPath );
  if( self.statRead({ filePath : c.tempPath }) )
  self.filesDelete( c.tempPath );
  self.fileRenameAct
  ({
    dstPath : c.tempPath,
    srcPath : o.dstPath,
    relativeDstPath : c.tempPath,
    relativeSrcPath : o.dstPath,
    sync : 1,
    context : c,
  });
  return true;
}

function tempRenameAsync()
{
  let c = this;
  let self = this.provider;
  let o = c.options;
  let o2 = c.options2;

  if( !c.tempRenameCan() )
  return false;

  c.tempPath = c.tempNameMake( o2.dstPath );
  return self.statRead
  ({
    filePath : c.tempPath,
    sync : 0
  })
  .then( ( tempStat ) =>
  {
    if( tempStat )
    return self.filesDelete( c.tempPath );
    return tempStat;
  })
  .then( () =>
  {
    return self.fileRenameAct
    ({
      dstPath : c.tempPath,
      srcPath : o.dstPath,
      relativeDstPath : c.tempPath,
      relativeSrcPath : o.dstPath,
      sync : 0,
      context : c,
    });
  })
}

//

function tempRenameMaybe()
{
  let c = this;
  let self = this.provider;
  let o = c.options;

  if( !self.fileExists( c.options2.dstPath ) )
  return false;
  if( !o.breakingDstHardLink && c.dstStat.isHardLink() )
  return false;
  c.renaming = true;
  return c.tempRename();
}

//

function tempRenameRevertSync()
{
  let c = this;
  let self = this.provider;
  let o = c.options;

  if( c.tempPath )
  {
    try
    {
      self.fileRenameAct
      ({
        dstPath : o.dstPath,
        srcPath : c.tempPath,
        relativeDstPath : o.dstPath,
        relativeSrcPath : c.tempPath,
        sync : 1,
        context : c,
      });
    }
    catch( err2 )
    {
      console.error( err2 );
    }
  }

}

//

function tempRenameRevertAsync()
{
  let c = this;
  let self = this.provider;
  let o = c.options;

  if( !c.tempPath )
  return new _.Consequence().take( null );

  return self.fileRenameAct
  ({
    dstPath : o.dstPath,
    srcPath : c.tempPath,
    relativeDstPath : o.dstPath,
    relativeSrcPath : c.tempPath,
    sync : 0,
    context : c,
  })
  .finally( ( err2, got ) =>
  {
    if( err2 )
    console.error( err2 );
    return got;
  })
}

//

function tempDelete()
{
  let c = this;
  let self = this.provider;
  let o = c.options;

  if( c.tempPath )
  {
    let tempPath = c.tempPath;
    c.tempPath = null;
    return self.filesDelete
    ({
      filePath : tempPath,
      verbosity : 0,
      sync : o.sync,
    });
  }

  return null;
}

//

function tempNameMake( filePath )
{
  let postfix = '-' + _.idWithGuid() + '.tmp';

  if( _.strEnds( filePath, '/' ) )
  return _.strReplaceEnd( filePath, '/', postfix )

  return filePath + postfix;
}

//

function validateSize()
{
  let c = this;
  let self = this.provider;
  let o = c.options;

  if( !Config.debug )
  return;

  if( o.srcPath === o.dstPath )
  return;

  let srcPath = o.srcPath;
  let dstPath = o.dstPath;

  let srcStat = c.srcResolvedStat;

  if( !srcStat && o.allowingMissed )
  return;

  if( !srcStat )
  {
    srcStat = c.srcStat;
    if( srcStat )
    {
      if( c.onSizeCheck )
      c.onSizeCheck.call( self, c );
      return;
    }
  }

  if( !srcStat )
  {
    let err = `Failed to ${c.entryMethodName} ${o.dstPath} from ${o.srcPath}. Source file does not exist.`;
    throw _.err( err );
  }

  c.dstStat = c.onStat( dstPath, 1 );

  if( !c.dstStat )
  {
    c.dstStat = c.onStat( dstPath, 0 );
    if( c.dstStat )
    return;
  }


  if( !c.dstStat )
  {
    let err = `Failed to ${c.entryMethodName} ${o.dstPath} from ${o.srcPath}. Destination file does not exist.`;
    throw _.err( err );
  }

  if( c.linkMaybe )
  {
    let updateStat =  _.strBegins( dstPath, srcPath );
    let filePath = srcStat.filePath;

    if( self instanceof _.FileProvider.System )
    {
      filePath = self.providerForPath( srcPath ).path.globalFromPreferred( filePath );
      dstPath = self.providerForPath( dstPath ).path.globalFromPreferred( dstPath )
    }

    if( updateStat || _.strBegins( dstPath, filePath ) )
    srcStat = c.onStat( filePath, 0 );

    // let updateStat =  _.strBegins( dstPath, srcPath );
    // let filePath = srcStat.filePath;
    //
    // if( self instanceof _.FileProvider.System  )
    // filePath = self.providerForPath( srcPath ).path.globalFromPreferred( filePath );
    //
    // if( !updateStat )
    // updateStat = _.strBegins( dstPath, filePath )
    //
    // if( _.strHas( srcPath, 'src/proto/dirLink1' ) )
    // if( updateStat  )
    // srcStat = c.onStat( filePath, 0 );
  }

  /* qqq: find better solution to check text links */
  if( /* srcStat.isTextLink() && */ c.dstStat.isTextLink() )
  if( self.areTextLinked([ c.dstStat.filePath, srcStat.filePath ]) )
  return;

  let srcSize = srcStat ? srcStat.size : NaN;
  let dstSize = c.dstStat ? c.dstStat.size : NaN;

  if( !( srcSize == dstSize ) )
  {
    let err =
    `Failed to ${c.entryMethodName} ${o.dstPath} (${dstSize}) from ${o.srcPath} (${srcSize}). `
    + `Have different size after ${c.entryMethodName} operation.`;
    err = _.err( err );
    debugger;
    throw err;
  }

}

//

function error( err )
{
  let c = this;
  let o = c.options;

  _.assert( arguments.length === 1 );

  if( o.throwing )
  {
    if( o.sync )
    throw err;
    c.result = new _.Consequence().error( err );
    return c.end( c.result );
  }
  else
  {
    _.errAttend( err );
    return c.end( null );
  }

}

//

function end( r )
{
  let c = this;
  let o = c.options;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( arguments.length === 0 || r !== undefined );
  c.ended = true;
  if( r !== undefined )
  if( o.sync )
  c.result = r;
  else if( _.consequenceIs( r ) )
  c.result = r;
  else
  c.result = _.Consequence().take( r );
  _.assert( !!o.sync || _.consequenceIs( c.result ) );
  _.assert( c.result !== undefined );
  return c.result;
}

//

/* xxx : qqq : not optimal. optimize */
function contextMake( o )
{
  _.assert( arguments.length === 1 );
  _.routine.options_( contextMake, o );

  let fop = o.fop;
  let options = o.options;
  let provider = o.provider;

  let c = Object.create( null );

  c.provider = provider;
  c.linkBody = undefined;

  _.assert( !!fop );

  if( fop )
  {
    c.actMethodName = fop.actMethodName;
    c.onVerify1 = fop.onVerify1;
    c.onVerify2 = fop.onVerify2;
    c.onIsLink2 = fop.onIsLink;
    c.onStat2 = fop.onStat;
    c.onSizeCheck = fop.onSizeCheck;
    c.renaming = fop.renaming;
    c.skippingSamePath = fop.skippingSamePath;
    c.skippingMissed = fop.skippingMissed;
    c.linkDo = fop.onDo;
    c.options2 = _.mapOnly_( null, options, c.linkDo.defaults );
  }

  c.entryMethodName = undefined;
  c.onIsLink = onIsLink;
  c.onStat = onStat;
  c.ended = false;
  c.result = undefined;
  c.tempPath = undefined;
  c.tempPathSrc = undefined;
  c.dstStat = undefined;
  c.srcStat = undefined;
  c.originalSrcResolvedPath = undefined;
  c.srcResolvedStat = undefined;
  c.options = options;

  c.verify1 = options.sync ? verify1 : verify1Async;
  c.verify2 = options.sync ? verify2 : verify2Async;
  c.verifyDst = options.sync ? verifyDstSync : verifyDstAsync;
  c.verifyEqualPaths = verifyEqualPaths;
  c.pathsLocalize = options.sync ? pathsLocalizeSync : pathsLocalizeAsync;
  c.pathResolve = options.sync ? pathResolve : pathResolveAsync;
  c.linksResolve = options.sync ? linksResolve : linksResolveAsync;
  c.log = log;
  c.tempRenameCan = tempRenameCan;
  c.tempRename = options.sync ? tempRenameSync : tempRenameAsync;
  c.tempRenameMaybe = tempRenameMaybe;
  c.tempRenameRevert = options.sync ? tempRenameRevertSync : tempRenameRevertAsync;
  c.tempDelete = tempDelete;
  c.tempNameMake = tempNameMake
  c.validateSize = validateSize;
  c.error = error;
  c.end = end;
  c.linkMaybe = fop.linkMaybe;

  if( !options.sync )
  {
    c.con = new _.Consequence().take( null );
  }

  Object.preventExtensions( c );
  return c;
}

contextMake.defaults =
{
  provider : null,
  options : null,
  fop : null
}

//

function functor_head( routine, args )
{
  let self = this;

  let o = self._preSrcDstPathWithoutProviderDefaults.apply( self, arguments );
  self._providerDefaultsApply( o );

  _.mapSupplementNulls( o, routine.defaults );
  return o;
}

//

function functor( fop )
{

  /*
    qqq : optimize, fix consequences problem
  */

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( functor, fop );

  let onDo = fop.onDo;
  let actMethodName = fop.actMethodName;
  let entryMethodName = _.strRemoveEnd( fop.actMethodName, 'Act' );
  let onVerify1 = fop.onVerify1;
  let onVerify2 = fop.onVerify2;
  let onIsLink2 = fop.onIsLink;
  let onStat2 = fop.onStat;
  let onSizeCheck = fop.onSizeCheck;
  let renaming = fop.renaming;
  let skippingSamePath = fop.skippingSamePath;
  let skippingMissed = fop.skippingMissed;
  let hardLinking = fop.hardLinking;

  _.assert( _.routineIs( onDo ) );
  _.assert( _.object.isBasic( onDo.defaults ) );
  _.assert( onVerify1 === null || _.routineIs( onVerify1 ) );
  _.assert( onVerify2 === null || _.routineIs( onVerify2 ) );
  _.assert( onIsLink2 === null || _.routineIs( onIsLink2 ) );
  _.assert( onStat2 === null || _.routineIs( onStat2 ) );
  _.assert( onSizeCheck === null || _.routineIs( onSizeCheck ) );

  _.routineExtend( link_body, onDo );
  link_body.defaults = _.props.extend( null, link_body.defaults ); /* xxx qqq : redundant? */
  delete link_body.defaults.originalSrcPath;
  delete link_body.defaults.originalDstPath;
  delete link_body.defaults.relativeSrcPath;
  delete link_body.defaults.relativeDstPath;

  var having = link_body.having;

  having.driving = 0;
  having.aspect = 'body';

  let linkEntry = _.routine.uniteReplacing({ head : functor_head, body : link_body, name : entryMethodName });

  var having = linkEntry.having = _.props.extend( null, linkEntry.having );
  having.aspect = 'entry';

  return linkEntry;

  /* */

  function link_body( o )
  {
    let self = this;
    let path = self.system ? self.system.path : self.path;
    let o2;
    let c = Self.contextMake({ provider : self, options : o, fop });

    c.entryMethodName = entryMethodName;
    c.linkBody = link_body;

    /* */

    if( o.sync )
    {

      c.verify1( arguments );
      if( c.ended )
      return c.end();

      /*
      zzz : multiple should work not only for hardlinks
      */

      if( _.longIs( o.dstPath ) && hardLinking )
      return multiple.call( self, o, link_body );
      _.assert( _.strIs( o.srcPath ) && _.strIs( o.dstPath ) );

      c.pathsLocalize();
      if( c.ended )
      return c.end();

      c.pathResolve();
      if( c.ended )
      return c.end();

      c.linksResolve();
      if( c.ended )
      return c.end();

      c.verify2();
      if( c.ended )
      return c.end();

      o2 = c.options2 = _.props.extend( c.options2, _.mapOnly_( null, o, c.linkDo.defaults ) );
      o2.context = c.options2.context = c;

      try
      {

        if( self.fileExists( o2.dstPath ) )
        {
          c.verifyDst()
          if( c.tempRenameCan() )
          tempRenameSync.call( c );
        }
        else if( o.makingDirectory )
        {
          self.dirMakeForFile( o2.dstPath );
        }

        c.linkDo.call( self, c );
        c.log();

        c.validateSize();
        c.tempDelete();

      }
      catch( err )
      {

        c.tempRenameRevert();
        return c.error( _.err( err, '\nCant', c.entryMethodName, o.dstPath, '<-', o.srcPath ) );

      }

      return true;
    }
    else /* async */
    {

      /* launcher */

      c.verify1( arguments );

      c.con.then( () =>
      {
        if( _.longIs( o.dstPath ) && hardLinking )
        {
          c.result = multiple.call( self, o, link_body );
          return true;
        }
        _.assert( _.strIs( o.srcPath ) && _.strIs( o.dstPath ) );

        c.pathsLocalize();
        c.pathResolve();
        c.linksResolve();
        c.verify2();

        return true;
      })

      c.con.then( () =>
      {
        /* return result if ended earlier */
        if( c.result !== undefined )
        return c.result;
        /* prepare options map and launch main part */
        o2 = c.options2 = _.props.extend( c.options2, _.mapOnly_( null, o, c.linkDo.defaults ) );
        o2.context = c.options2.context = c;
        /* main part */
        return mainPartAsync();
      })

      return c.con;
    }

    /* */

    function mainPartAsync()
    {
      let con = new _.Consequence().take( null );

      con.then( () => self.fileExists( o2.dstPath ) );
      con.then( ( dstExists ) =>
      {
        if( dstExists )
        {
          return c.verifyDst().then( () => tempRenameAsync.call( c ) );
        }
        else if( o.makingDirectory )
        {
          return self.dirMakeForFile({ filePath : o2.dstPath, sync : 0 });
        }
        return dstExists;
      });

      con.then( _.routineSeal( self, c.linkDo, [ c ] ) );

      con.then( ( got ) =>
      {
        c.log();
        return c.tempDelete();
      });
      con.then( () =>
      {
        c.tempPath = null;
        c.validateSize();
        return true;
      });

      con.catch( ( err ) =>
      {
        return c.tempRenameRevert()
        .finally( () =>
        {
          return c.error( _.err( err, '\nCant', c.entryMethodName, o.dstPath, '<-', o.srcPath ) );
        })
      })

      return con;
    }

  }

}

functor.defaults =
{

  actMethodName : null,
  onDo : null,
  onVerify1 : null,
  onVerify2 : null,
  onIsLink : null,
  onStat : null,
  onSizeCheck : null,

  linkMaybe : false,
  hardLinking : false,
  renaming : true,
  skippingSamePath : true,
  skippingMissed : false,

}

/*

fileCopy
fileRename
softLink
hardLink
textLink

*/

// --
//
// --

let LinkerExtension =
{

  multiple,

  onIsLink,
  onStat,

  verify1,
  verify1Async,
  verify2,
  verifyEqualPaths,
  verify2Async,
  verifyDstSync,
  verifyDstAsync,

  pathsLocalizeSync,
  pathsLocalizeAsync,

  pathResolve,
  pathResolveAsync,

  linksResolve,
  linksResolveAsync,

  log,

  tempRenameCan,
  tempRenameSync,
  tempRenameAsync,
  tempRenameMaybe,
  tempRenameRevertSync,
  tempRenameRevertAsync,

  tempDelete,
  tempNameMake,

  validateSize,

  error,
  end,

  contextMake,
  functor,

}

/* _.props.extend */Object.assign( _.files.linker, LinkerExtension )

//

})()


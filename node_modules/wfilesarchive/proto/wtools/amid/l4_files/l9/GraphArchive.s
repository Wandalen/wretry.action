// ( function _GraphArchive_s_()
// {
//
// 'use strict';
//
// //
//
// const _global = _global_;
// const _ = _global_.wTools;
// const Parent = null;
// const Self = wFilesGraphArchive;
// function wFilesGraphArchive( o )
// {
//   _.assert( arguments.length === 0 || arguments.length === 1, 'Expects single argument' );
//   return _.workpiece.construct( Self, this, arguments );
// }
//
// Self.shortName = 'FilesGraphArchive';
//
// // --
// // inter
// // --
//
// function init( o )
// {
//   let self = this;
//
//   _.assert( arguments.length === 0 || arguments.length === 1 );
//
//   _.workpiece.initFields( self );
//   Object.preventExtensions( self )
//
//   if( o )
//   self.copy( o );
//
//   self.form();
//
// }
//
// //
//
// function form()
// {
//   let self = this;
//
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//   _.assert( self.imageFileProvider instanceof _.FileProvider.Abstract );
//   _.assert( self.imageFileProvider.onCallBegin === null );
//   _.assert( self.imageFileProvider.onCallEnd === null );
//   _.assert( self.imageFileProvider.archive === null || self.imageFileProvider.archive === self );
//
//   self.imageFileProvider.archive = self;
//
//   self.factory = new _.ArchiveRecordFactory
//   ({
//     imageFileProvider : self.imageFileProvider,
//     originalFileProvider : self.imageFileProvider.originalFileProvider,
//   });
//
//   // self.records.filePath = self.records.filePath || Object.create( null );
//   // self.imageFileProvider.onCallBegin = self.callLog;
//
//   if( self.timelapseUsing )
//   self.imageFileProvider.onCall = _.routineJoin( self, self.timelapseCall );
//
// }
//
// //
//
// function originalCall( op )
// {
//   let o2 = op.args[ 0 ];
//   // if( op.reads.length )
//   // logger.log( 'original', op.routine.name, 'read', _.select( o2, op.reads ).join( ', ' ) );
//   // if( op.writes.length )
//   // logger.log( 'original', op.routine.name, 'write', _.select( o2, op.writes ).join( ', ' ) );
//   op.originalCall();
// }
//
// //
//
// function timelapseCall( op )
// {
//   let self = this;
//   let path = op.originalFileProvider.path;
//   let o2 = op.args[ 0 ];
//
//   _.assert( op.args.length === 1 );
//
//   if( !self.timelapseMode )
//   return self.originalCall( op );
//
//   if( !op.writesPaths )
//   op.writesPaths = _.arrayFlatten( _.props.vals( _.mapValsWithKeys( o2, op.writes ) ) );
//   if( !op.readsPaths )
//   op.readsPaths = _.arrayFlatten( _.props.vals( _.mapValsWithKeys( o2, op.reads ) ) );
//
//   let writingRecords = self.factory.recordsSelect( op.writesPaths );
//   // if( writingRecords.length )
//   // debugger;
//   // let writingRecords = _.props.vals( _.mapValsWithKeys( self.records.filePath, op.writesPaths ) ).filter( ( el ) => el !== undefined );
//   // if( _.entity.lengthOf( writingRecords ) )
//   // debugger;
//   // if( op.routineName === 'fileCopyAct' )
//   // debugger;
//   // if( op.routineName === 'fileWriteAct' )
//   // debugger;
//
//   if( op.routineName === 'fileDeleteAct' )
//   return self.timelapseCallDelete( op );
//   else if( op.routineName === 'statReadAct' )
//   return self.timelapseCallStatReadAct( op );
//   else if( op.routineName === 'fileExistsAct' )
//   return self.timelapseCallFileExistsAct( op );
//   else if( op.routineName === 'dirMakeAct' )
//   return self.timelapseCallDirMakeAct( op );
//   else if( op.routineName === 'fileCopyAct' )
//   return self.timelapseCallFileCopyAct( op );
//   else if( op.routineName === 'hardLinkAct' )
//   return self.timelapseCallHardLinkAct( op );
//   // else if( op.routineName === 'fileCopyAct' || op.routineName === 'fileRenameAct' || op.routineName === 'hardLinkAct' )
//   // return self.timelapseCallFileCopyAct( op );
//
//   if( writingRecords.length )
//   throw _.err( 'No timlapse hook for wirting method', op.routineName );
//
//   return self.originalCall( op );
// }
//
// //
//
// function timelapseSingleHook_functor( onDelayed )
// {
//
//   return function hook( op )
//   {
//     let self = this;
//     let path = op.originalFileProvider.path;
//     let o2 = op.args[ 0 ];
//
//     _.assert( op.args.length === 1 );
//     _.assert( arguments.length === 1 );
//     _.assert( path.isAbsolute( o2.filePath ) );
//
//     let arecord = self.factory.records.filePath[ o2.filePath ];
//     if( arecord && arecord.deleting === 1 )
//     {
//
//       // if( op.writesPaths.length )
//       // logger.log( 'after delay', op.routine.name, 'write', op.writesPaths.join( ', ' ) );
//       // if( op.readsPaths.length )
//       // logger.log( 'after delay', op.routine.name, 'read', op.readsPaths.join( ', ' ) );
//
//       onDelayed.call( self, op, arecord );
//       return;
//     }
//
//     return self.originalCall( op );
//   }
//
// }
//
// //
//
// function timelapseLinkingHook_functor( onDelayed )
// {
//
//   return function hook( op )
//   {
//     let self = this;
//     let path = op.originalFileProvider.path;
//     let o2 = op.args[ 0 ];
//
//     _.assert( op.args.length === 1 );
//     _.assert( arguments.length === 1 );
//     _.assert( path.isAbsolute( o2.srcPath ) );
//     _.assert( path.isAbsolute( o2.dstPath ) );
//
//     let srcRecord = self.factory.records.filePath[ o2.srcPath ];
//     let dstRecord = self.factory.records.filePath[ o2.dstPath ];
//
//     // if( op.writesPaths.length )
//     // logger.log( 'after delay', op.routine.name, 'write', op.writesPaths.join( ', ' ) );
//     // if( op.readsPaths.length )
//     // logger.log( 'after delay', op.routine.name, 'read', op.readsPaths.join( ', ' ) );
//
//     if( ( srcRecord && srcRecord.deleting ) || ( dstRecord && dstRecord.deleting ) )
//     return onDelayed.call( self, op, dstRecord, srcRecord );
//
//     return self.originalCall( op );
//   }
//
// }
//
// //
//
// function timelapseCallDelete( op )
// {
//   let self = this;
//   let path = op.originalFileProvider.path;
//   let o2 = op.args[ 0 ];
//
//   _.assert( op.routineName === 'fileDeleteAct' );
//   _.assert( op.args.length === 1 );
//   _.assert( arguments.length === 1 );
//
//   let stat = op.originalFileProvider.statRead({ sync : 1, filePath : o2.filePath });
//   if( !stat.isTerminal() && !stat.isDir() )
//   return self.originalCall( op );
//
//   // logger.log( 'delaying', op.routine.name, _.select( o2, op.writes ).join( ', ' ) );
//
//   let arecord = self.factory.record( o2.filePath );
//
//   _.assert( path.isAbsolute( o2.filePath ) );
//
//   arecord.stat = stat;
//   arecord.deleting = 1;
//   arecord.deletingOptions = o2;
//
//   _.assert( arecord === self.factory.records.filePath[ o2.filePath ] );
//   _.assert( arecord.factory === self.factory );
//
// }
//
// //
//
// let timelapseCallStatReadAct = timelapseSingleHook_functor( function( op )
// {
//   let self = this;
//   let o2 = op.args[ 0 ];
//
//   if( o2.throwing )
//   throw _.err( 'File', o2.filePath, 'was deleted' );
//   op.result = null;
//
// } );
//
// //
//
// let timelapseCallFileExistsAct = timelapseSingleHook_functor( function( op )
// {
//   let self = this;
//   let o2 = op.args[ 0 ];
//
//   op.result = false;
// } );
//
// //
//
// let timelapseCallDirMakeAct = timelapseSingleHook_functor( function( op, arecord )
// {
//   let self = this;
//   let o2 = op.args[ 0 ];
//
//   if( arecord.stat.isDir() )
//   {
//     arecord.finit();
//   }
//   else
//   {
//     arecord.timelapsedSubFilesDelete();
//     arecord.timelapsedDelete();
//     // arecord.deletingOptions.sync = 1;
//     // op.originalFileProvider.fileDeleteAct( arecord.deletingOptions );
//     let r = self.originalCall( op );
//     arecord.finit();
//     return r;
//   }
//
//   // if( !arecord.stat.isDir() )
//   // {
//   //   arecord.timelapsedSubFilesDelete();
//   //   arecord.timelapsedDelete();
//   //   // arecord.deletingOptions.sync = 1;
//   //   // op.originalFileProvider.fileDeleteAct( arecord.deletingOptions );
//   //   let r = self.originalCall( op );
//   //   arecord.finit();
//   //   return r;
//   // }
//   // else
//   // {
//   //   arecord.finit();
//   // }
//
//   // _.assert( self.records.filePath[ arecord.absolute ] === arecord );
//   // delete self.records.filePath[ arecord.absolute ];
//
//   return true;
// } );
//
// //
//
// let timelapseCallFileCopyAct = timelapseLinkingHook_functor( function fileCopyAct( op, dstRecord, srcRecord )
// {
//   let self = this;
//   let o2 = op.args[ 0 ];
//
//   _.assert( _.strIs( o2.srcPath ) );
//   _.assert( _.strIs( o2.dstPath ) );
//
//   if( !dstRecord )
//   {
//     _.assert( 0, 'not tested' );
//     return end();
//   }
//
//   if( o2.breakingDstHardLink )
//   {
//     _.assert( 0, 'not tested' );
//     return end();
//   }
//
//   let dstStat = dstRecord.stat;
//   let srcStat = op.originalFileProvider.statRead({ filePath : o2.srcPath, sync : 1 });
//
//   if( !srcStat.isTerminal() || !dstStat.isTerminal() )
//   {
//     return end();
//   }
//
//   let identical = true;
//   if( identical && dstStat.size !== srcStat.size )
//   identical = false;
//
//   if( identical )
//   if( !_.files.stat.areHardLinked( srcStat, dstStat ) )
//   {
//     if( _.files.stat.different( srcStat, dstStat ) )
//     identical = false;
//     if( identical )
//     {
//       let dstHash = dstRecord.hashRead();
//       let srcHash = op.originalFileProvider.hashRead({ sync : 1, filePath : o2.srcPath });
//       if( !srcHash || srcHash !== dstHash )
//       identical = false;
//     }
//   }
//
//   if( identical )
//   dstRecord.finit();
//   else
//   return end();
//
//   // if( !identical )
//   // {
//   //   return end();
//   // }
//   // else
//   // {
//   //   dstRecord.finit();
//   // }
//
//   op.result = true;
//
//   /* - */
//
//   function end()
//   {
//     if( dstRecord )
//     {
//       dstRecord.timelapsedSubFilesDelete();
//       dstRecord.timelapsedDelete();
//       dstRecord.finit();
//     }
//     return self.originalCall( op );
//   }
//
// } );
//
// //
//
// let timelapseCallHardLinkAct = timelapseLinkingHook_functor( function hardLinkAct( op, dstRecord, srcRecord )
// {
//   let self = this;
//   let o2 = op.args[ 0 ];
//
//   _.assert( _.strIs( o2.srcPath ) );
//   _.assert( _.strIs( o2.dstPath ) );
//   _.assert( _.boolLike( o2.breakingSrcHardLink ) );
//   _.assert( _.boolLike( o2.breakingDstHardLink ) );
//
//   if( !dstRecord )
//   {
//     _.assert( 0, 'not tested' );
//     return end();
//   }
//
//   if( o2.breakingSrcHardLink || !o2.breakingDstHardLink )
//   {
//     _.assert( 0, 'not tested' );
//     return end();
//   }
//
//   if( op.originalFileProvider.areHardLinked( o2.srcPath, o2.dstPath ) )
//   {
//     dstRecord.finit();
//   }
//   else
//   {
//     end();
//   }
//
//   /* - */
//
//   function end()
//   {
//     if( dstRecord )
//     {
//       dstRecord.timelapsedSubFilesDelete();
//       dstRecord.timelapsedDelete();
//       dstRecord.finit();
//     }
//     return self.originalCall( op );
//   }
//
// } );
//
// //
//
// function callLog( op )
// {
//   if( !op.writes.length && !op.reads.length )
//   return op.args;
//   let o2 = op.args[ 0 ];
//
//   _.assert( op.args.length === 1 );
//   _.assert( arguments.length === 1 );
//
//   if( op.reads.length )
//   logger.log( op.routine.name, 'read', _.select( o2, op.reads ).join( ', ' ) );
//   if( op.writes.length )
//   logger.log( op.routine.name, 'write', _.select( o2, op.writes ).join( ', ' ) );
//
//   // if( op.routine.name === 'fileRenameAct' )
//   // debugger;
//   // if( o2.filePath === '/src/f1' )
//   // debugger;
//
// }
//
// //
//
// function timelapseBegin( o )
// {
//   let self = this;
//   let logger = self.logger;
//
//   o = _.routine.options_( timelapseBegin, arguments );
//
//   _.assert( self.timelapseMode === 0 || self.timelapseMode === 1 );
//   _.assert( self.timelapseMode === 1 || _.props.keys( self.factory.records.filePath ).length === 0 );
//
//   self.timelapseMode = 1;
//
//   // logger.log( 'Timelapse begin' );
// }
//
// timelapseBegin.defaults =
// {
// }
//
// //
//
// function timelapseEnd( o )
// {
//   let self = this;
//   let logger = self.logger;
//
//   o = _.routine.options_( timelapseEnd, arguments );
//
//   self.timelapseMode = 0;
//
//   self.factory.recordsTimelapsedDelete();
//
//   // logger.log( 'Timelapse end' );
// }
//
// timelapseEnd.defaults =
// {
// }
//
// //
//
// function del( o )
// {
//   o = _.routine.options_( del, arguments );
//
//   logger.log( 'del' );
//
//   // records.
//
// }
//
// del.defaults =
// {
// }
//
// // --
// //
// // --
//
// let Composes =
// {
//   timelapseUsing : 1,
//   timelapseMode : 0,
// }
//
// let Aggregates =
// {
// }
//
// let Associates =
// {
//   factory : null,
//   imageFileProvider : null,
// }
//
// let Restricts =
// {
// }
//
// let Statics =
// {
// }
//
// let Forbids =
// {
//   fileProvider : 'fileProvider',
// }
//
// let Accessors =
// {
// }
//
// // --
// // declare
// // --
//
// let Extension =
// {
//
//   init,
//   form,
//
//   originalCall,
//
//   // callBeginDelete,
//   timelapseCall,
//   timelapseSingleHook_functor,
//   timelapseLinkingHook_functor,
//   timelapseCallDelete,
//   timelapseCallStatReadAct,
//   timelapseCallFileExistsAct,
//   timelapseCallDirMakeAct,
//   timelapseCallFileCopyAct,
//   timelapseCallHardLinkAct,
//
//   callLog,
//
//   timelapseBegin,
//   timelapseEnd,
//   del,
//
//   //
//
//   Composes,
//   Aggregates,
//   Associates,
//   Restricts,
//   Statics,
//   Forbids,
//   Accessors,
//
// }
//
// //
//
// _.classDeclare
// ({
//   cls : Self,
//   parent : Parent,
//   extend : Extension,
// });
//
// //
//
// _.Copyable.mixin( Self );
// _.StateStorage.mixin( Self );
//
// _[ Self.shortName ] = Self;
//
// // --
// // export
// // --
//
//
// if( typeof module !== 'undefined' )
// module[ 'exports' ] = Self;
//
// } )();

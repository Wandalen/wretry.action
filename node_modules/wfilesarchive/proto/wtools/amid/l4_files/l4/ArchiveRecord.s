// ( function _AtchiveRecord_s_()
// {
//
// 'use strict';
//
// //
//
// const _global = _global_;
// const _ = _global_.wTools;
// const Parent = null;
// const Self = wArchiveRecord;
// function wArchiveRecord( o )
// {
//   return _.workpiece.construct( Self, this, arguments );
// }
//
// Self.shortName = 'ArchiveRecord';
//
// // --
// // inter
// // --
//
// function finit()
// {
//   let record = this;
//   let factory = record.factory;
//
//   _.assert( factory.records.filePath[ record.absolute ] === record );
//   delete factory.records.filePath[ record.absolute ];
//
//   record.deleting = 0;
//   record.deletingOptions = null;
//   record.stat = null;
//
//   _.Copyable.prototype.finit.apply( record, arguments );
// }
//
// //
//
// function init( o )
// {
//   let record = this;
//
//   _.workpiece.initFields( record );
//
//   if( o )
//   {
//     record.copy( o );
//     if( o.absolute )
//     record.absolute = o.absolute;
//   }
//
//   Object.preventExtensions( record );
//
//   _.assert( _.strIs( record.absolute ) );
//   _.assert( record.factory instanceof _.ArchiveRecordFactory );
//
//   let factory = record.factory;
//   let path = factory.originalFileProvider.path;
//
//   _.assert( path.isAbsolute( record.absolute ) );
//   _.assert( factory.records.filePath[ record.absolute ] === undefined );
//
//   factory.records.filePath[ record.absolute ] = record;
//
// }
//
// //
//
// function hashRead()
// {
//   let record = this;
//
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//
//   if( !record.hash )
//   record.hash = record.factory.originalFileProvider.hashRead( record.absolute );
//
//   return record.hash;
// }
//
// //
//
// function timelapsedDelete()
// {
//   let record = this;
//   let factory = record.factory;
//
//   // logger.log( 'timelapsedDelete', record.absolute );
//
//   _.assert( _.mapIs( record.deletingOptions ) );
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//
//   record.deletingOptions.sync = 1;
//
//   let result = factory.originalFileProvider.fileDeleteAct( record.deletingOptions );
//
//   record.deletingOptions = null;
//   record.deleting = 0;
//
//   return result;
// }
//
// //
//
// function timelapsedSubFilesDelete()
// {
//   let record = this;
//   let factory = record.factory;
//   let path = factory.originalFileProvider.path;
//   let result = 0;
//
//   _.assert( _.mapIs( record.deletingOptions ) );
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//
//   for( let f in factory.records.filePath )
//   {
//     let record2 = factory.records.filePath[ f ];
//
//     if( record2.deleting && record2 !== record )
//     if( path.begins( record2.absolute, record.absolute ) )
//     {
//       record2.timelapsedDelete();
//       record2.finit();
//       result += 1;
//     }
//
//   }
//
//   return result;
// }
//
// // --
// //
// // --
//
// let Composes =
// {
//   deleting : 0,
//   hash : null,
// }
//
// let Aggregates =
// {
// }
//
// let Associates =
// {
//   deletingOptions : null,
//   stat : null,
//   factory : null,
// }
//
// let Restricts =
// {
//   absolute : null,
// }
//
// let Medials =
// {
//   absolute : null,
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
// // --
// // declare
// // --
//
// let Extension =
// {
//
//   finit,
//   init,
//
//   hashRead,
//   timelapsedDelete,
//   timelapsedSubFilesDelete,
//
//   //
//
//   Composes,
//   Aggregates,
//   Associates,
//   Restricts,
//   Medials,
//   Statics,
//   Forbids,
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
// _.Copyable.mixin( Self );
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

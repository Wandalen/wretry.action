// ( function _AtchiveRecordFactory_s_()
// {
//
// 'use strict';
//
// //
//
// const _global = _global_;
// const _ = _global_.wTools;
// const Parent = null;
// const Self = wArchiveRecordFactory;
// function wArchiveRecordFactory( o )
// {
//   return _.workpiece.construct( Self, this, arguments );
// }
//
// Self.shortName = 'ArchiveRecordFactory';
//
// // --
// // inter
// // --
//
// function finit()
// {
//   let self = this;
//   _.Copyable.prototype.finit.apply( self, arguments );
// }
//
// //
//
// function init( o )
// {
//   let self = this;
//
//   _.workpiece.initFields( self );
//   if( o )
//   self.copy( o );
//   Object.preventExtensions( self );
//
//   _.assert( self.records === null );
//   self.records = new _.files.FileRecordFilter({ defaultProvider : self.imageFileProvider });
//
//   self.records.filePath = self.records.filePath || Object.create( null );
// }
//
// //
//
// function record( o )
// {
//   let self = this;
//
//   if( _.strIs( o ) )
//   o = { absolute : o }
//
//   _.assert( arguments.length === 1 );
//   _.assert( _.strIs( o.absolute ) );
//   _.assert( o.factory === self || o.factory === undefined );
//
//   o.factory = self;
//
//   let record = _.ArchiveRecord( o );
//
//   return record;
// }
//
// //
//
// function recordsSelect( filePath )
// {
//   let self = this;
//
//   let result = _.props.vals( _.mapValsWithKeys( self.records.filePath, filePath ) ).filter( ( el ) => el !== undefined );
//
//   return result;
// }
//
// //
//
// function recordsTimelapsedDelete()
// {
//   let self = this;
//   let filePath = _.props.keys( self.records.filePath )
//
//   for( let f = filePath.length-1 ; f >= 0 ; f-- )
//   {
//     let record = self.records.filePath[ filePath[ f ] ];
//     _.assert( record.deleting === 1 );
//     record.timelapsedDelete();
//     record.finit();
//   }
//
// }
//
// // --
// //
// // --
//
// let Composes =
// {
// }
//
// let Aggregates =
// {
// }
//
// let Associates =
// {
//   // records : _.define.instanceOf( _.files.FileRecordFilter ),
//   records : null,
//   originalFileProvider : null,
//   imageFileProvider : null,
// }
//
// let Restricts =
// {
// }
//
// let Medials =
// {
// }
//
// let Statics =
// {
// }
//
// let Forbids =
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
//   finit,
//   init,
//
//   record,
//   recordsSelect,
//
//   recordsTimelapsedDelete,
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

// ( function _Image_s_()
// {
//
// 'use strict';
//
// const _global = _global_;
// const _ = _global_.wTools;
// const Abstract = _.FileProvider.Abstract;
// const Parent = Abstract;
// const Self = wFileFilterImage;
// function wFileFilterImage( o )
// {
//   return _.workpiece.construct( Self, this, arguments );
// }
//
// Self.shortName = 'Image';
//
// // --
// //
// // --
//
// function init( o )
// {
//   let self = this;
//
//   _.assert( arguments.length <= 1 );
//   _.workpiece.initFields( self )
//   Object.preventExtensions( self );
//
//   if( o )
//   self.copy( o );
//
//   let accessors =
//   {
//     get : function( self, k, proxy )
//     {
//       let result;
//       if( self[ k ] !== undefined )
//       result = self[ k ];
//       else
//       result = self.originalFileProvider[ k ];
//       if( self._routineDrivingAndChanging( result ) )
//       return self._routineFunctor( result, k );
//       return result;
//     },
//     set : function( /* self, k, val, proxy */ )
//     {
//       let self = arguments[ 0 ];
//       let k = arguments[ 1 ];
//       let val = arguments[ 2 ];
//       let proxy = arguments[ 3 ];
//
//       if( self[ k ] !== undefined )
//       self[ k ] = val;
//       else if( self.originalFileProvider[ k ] !== undefined )
//       self.originalFileProvider[ k ] = val;
//       else
//       self[ k ] = val;
//       return true;
//     },
//   };
//
//   let proxyImage = new Proxy( self, accessors );
//
//   self.proxyImage = proxyImage;
//   self.image = self;
//   if( !self.originalFileProvider )
//   self.originalFileProvider = _.fileProvider;
//
//   self.realFileProvider = self.originalFileProvider;
//   while( self.realFileProvider.originalFileProvider )
//   self.realFileProvider = self.realFileProvider.originalFileProvider;
//
//   _.assert( self.originalFileProvider instanceof _.FileProvider.Partial );
//   _.assert( self.realFileProvider instanceof _.FileProvider.Partial );
//
//   return proxyImage;
// }
//
// //
//
// function _routineDrivingAndChanging( routine )
// {
//
//   _.assert( arguments.length === 1 );
//
//   if( !_.routineIs( routine ) )
//   return false;
//
//   if( !routine.having )
//   return false;
//
//   if( !routine.having.reading && !routine.having.writing )
//   return false;
//
//   if( !routine.having.driving )
//   return false;
//
//   _.assert( _.object.isBasic( routine.operates ), () => 'Method ' + routine.name + ' does not have map {-operates-}' );
//
//   if( _.props.keys( routine.operates ).length === 0 )
//   return false;
//
//   return true;
// }
//
// //
//
// function _routineFunctor( routine, routineName )
// {
//   let self = this;
//
//   _.assert( arguments.length === 2 );
//   _.assert( _.routineIs( routine ) );
//   _.assert( !!routine.having );
//   _.assert( !!routine.having.reading || !!routine.having.writing );
//   _.assert( !!routine.having.driving );
//   _.assert( !!routine.operates );
//   _.assert( _.props.keys( routine.operates ).length > 0 );
//   _.assert( _.strDefined( routineName ) );
//   _.assert( routine.name === routineName );
//
//   if( self.routines[ routineName ] )
//   return self.routines[ routineName ];
//
//   let head = routine.head;
//   let body = routine.body || routine;
//   let op = Object.create( null );
//   op.routine = routine;
//   op.routineName = routineName;
//   op.reads = [];
//   op.writes = [];
//   op.image = self.proxyImage;
//   op.originalCall = function originalCall()
//   {
//     let op2 = this;
//     _.assert( arguments.length === 0, 'Expects no arguments' );
//     _.assert( _.argumentsArray.like( op2.args ) );
//     op2.result = op2.originalBody.apply( op2.image, op2.args );
//   }
//
//   for( let k in routine.operates )
//   {
//     let arg = routine.operates[ k ];
//     if( arg.pathToRead )
//     op.reads.push( k );
//     if( arg.pathToWrite )
//     op.writes.push( k );
//   }
//
//   let r =
//   {
//     [ routineName ] : function()
//     {
//       let op2 = _.props.extend( null, op );
//       op2.originalFileProvider = this.originalFileProvider;
//       op2.originalBody = body;
//       op2.args = _.unroll.from( arguments );
//       op2.result = undefined;
//
//       if( head )
//       {
//         // debugger;
//         // _.assert( 0, 'not tested' );
//         op2.args = head.call( this.originalFileProvider, resultRoutine, op2.args );
//         if( !_.unrollIs( op2.args ) )
//         op2.args = _.unroll.from([ op2.args ]);
//       }
//
//       if( this.onCallBegin )
//       {
//         let r = this.image.onCallBegin( op2 );
//         _.assert( r === undefined );
//       }
//
//       if( !_.unrollIs( op2.args ) )
//       op2.args = _.unroll.from([ op2.args ]);
//
//       _.assert( !_.argumentsArrayIs( op2.args ), 'Does not expect arguments array' );
//       let r = this.image.onCall( op2 );
//       _.assert( r === undefined );
//
//       if( this.onCallEnd )
//       {
//         let r = this.image.onCallEnd( op2 );
//         _.assert( r === undefined );
//       }
//
//       return op2.result;
//     }
//   }
//
//   let resultRoutine = self.routines[ routineName ] = r[ routineName ];
//
//   _.routineExtend( resultRoutine, routine );
//
//   return resultRoutine;
// }
//
// //
//
// function onCall( op )
// {
//   _.assert( arguments.length === 1 );
//   op.result = op.originalBody.apply( op.originalFileProvider, op.args );
// }
//
// // --
// // relations
// // --
//
// let Composes =
// {
// }
//
// let Aggregates =
// {
//   onCallBegin : null,
//   onCall,
//   onCallEnd : null,
// }
//
// let Associates =
// {
//   originalFileProvider : null,
//   realFileProvider : null,
//   archive : null,
// }
//
// let Restricts =
// {
//   routines : _.define.own({}),
//   proxyImage : null,
//   image : null,
// }
//
// let Events =
// {
// }
//
// let Frobids =
// {
//   original : 'original',
//   fileProvider : 'fileProvider',
//   proxy : 'proxy',
//   imageFilter : 'imageFilter',
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
//
//   _routineDrivingAndChanging,
//   _routineFunctor,
//
//   //
//
//   Composes,
//   Aggregates,
//   Associates,
//   Restricts,
//   Events,
//   Frobids,
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
// _.FileFilter = _.FileFilter || Object.create( null );
// _.FileFilter[ Self.shortName ] = Self;
//
// // --
// // export
// // --
//
// if( typeof module !== 'undefined' )
// module[ 'exports' ] = Self;
//
// })();

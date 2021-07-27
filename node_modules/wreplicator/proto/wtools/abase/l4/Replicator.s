( function _Replicator_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to replicate a complex data structure. It traverse input data structure deeply producing a copy of it.Collection of cross-platform routines to replicate a complex data structure. It traverses input data structure deeply producing a copy of it.
  @module Tools/base/Replicator
  @extends Tools
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wLooker' );

}

const _global = _global_;
const _ = _global_.wTools
const Parent = _.looker.Looker;
_.replicator = _.replicator || Object.create( _.looker );

_.assert( !!_realGlobal_ );

/* qqq : write nice example for readme */

// --
// relations
// --

var Prime = Object.create( null );
Prime.src = undefined;
Prime.dst = undefined;

// --
// implementation
// --

function optionsFromArguments( args )
{
  let o = args[ 0 ];

  if( args.length === 2 )
  {
    o = { dst : args[ 0 ], src : args[ 1 ] }
  }
  else if( args.length === 3 )
  {
    o = { dst : args[ 0 ], src : args[ 1 ], onUp : args[ 2 ] }
  }

  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );

  return o;
}

//

function optionsToIteration( iterator, o )
{
  let it = Parent.optionsToIteration.call( this, iterator, o );
  _.assert( arguments.length === 2 );
  _.assert( _.props.has( it, 'dst' ) );
  _.assert( it.dst !== null );
  _.assert( it.iterator.onUp === null || _.routineIs( it.iterator.onUp ) );
  _.assert( it.iterator.onDown === null || _.routineIs( it.iterator.onDown ) );
  return it;
}

//

function iteratorInitEnd( iterator )
{
  Parent.iteratorInitEnd.call( this, iterator );

  if( iterator.dst === null )
  iterator.dst = undefined;
  if( iterator.dst !== undefined )
  iterator.firstIterationPrototype.dstMaking = false;
  if( iterator.firstIterationPrototype.dst === null )
  iterator.firstIterationPrototype.dst = undefined;

  return iterator;
}

//

function performEnd()
{
  let it = this;
  it.iterator.originalResult = it.dst;
  it.iterator.result = it.iterator.originalResult;
  Parent.performEnd.apply( it, arguments );
  return it;
}

//

function dstWriteDown( eit )
{
  let it = this;
  it.DstWriteDown[ it.iterable ].call( it, eit );
}

//

function _dstWriteDownTerminal( eit )
{
  _.assert( 0, 'Cant write into terminal' );
}

//

function _dstWriteDownCountable( eit )
{
  if( eit.dst !== undefined )
  this.dst.push( eit.dst );
}

//

function _dstWriteDownAux( eit )
{
  if( eit.dst === undefined )
  delete this.dst[ eit.key ];
  else
  this.dst[ eit.key ] = eit.dst;
}

//

function _dstWriteDownHashMap( eit )
{
  if( eit.dst === undefined )
  this.dst.delete( eit.key );
  else
  this.dst.set( eit.key, eit.dst );
}

//

function _dstWriteDownSet( eit )
{
  if( eit.dst === undefined )
  this.dst.delete( eit.dst );
  else
  this.dst.add( eit.dst );
}

//

function _dstWriteDownCustom( eit )
{
  _.assert( 0, 'not implemented' );
}

//

function dstMake()
{
  let it = this;

  _.assert( it.iterable !== null && it.iterable !== undefined );
  _.assert( it.dstMaking );
  _.assert( arguments.length === 0 );
  _.assert( it.dst !== null );

  // if( it.dst !== undefined )
  // return;

  it.dst = it.ContainerMake[ it.iterable ].call( it );
}

//

function _containerMakeTerminal()
{
  let it = this;
  return it.src;
}

//

function _containerMakeCountable()
{
  let it = this;
  return [];
}

//

function _containerMakeAux()
{
  let it = this;
  return Object.create( null );
}

//

function _containerMakeHashMap()
{
  let it = this;
  return new HashMap;
}

//

function _containerMakeSet()
{
  let it = this;
  return new Set;
}

//

function _containerMakeCustom()
{
  let it = this;
  return it.src;
}

//

function visitUpBegin()
{
  let it = this;

  let r = Parent.visitUpBegin.call( it );

  // if( it.dstMaking )
  // it.dstMake();

  return r;
}

//

function visitUpEnd()
{
  let it = this;

  if( it.dstMaking )
  it.dstMake();

  return Parent.visitDownEnd.call( it );
}

//

function visitDownEnd()
{
  let it = this;
  _.assert( it.iterable !== null && it.iterable !== undefined );
  if( it.down && it.dstWritingDown )
  it.down.dstWriteDown( it );
  return Parent.visitDownEnd.call( it );
}

//

function exec_head( routine, args )
{
  _.assert( !!routine.defaults.Seeker );
  return routine.defaults.head( routine, args );
}

//

function exec_body( it )
{
  it.execIt.body.call( this, it );
  return it.result;
}

//

/* zzz qqq : implement please replication with buffer sepration
*/

// function cloneDataSeparatingBuffers( o )
// {
//   var result = Object.create( null );
//   var buffers = [];
//   var descriptorsArray = [];
//   var descriptorsMap = Object.create( null );
//   var size = 0;
//   var offset = 0;
//
//   _.routine.options_( cloneDataSeparatingBuffers, o );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   /* onBuffer */
//
//   o.onBuffer = function onBuffer( srcBuffer, it )
//   {
//
//     _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//     _.assert( _.bufferTypedIs( srcBuffer ), 'not tested' );
//
//     var index = buffers.length;
//     var id = _.strJoin([ '--buffer-->', index, '<--buffer--' ]);
//     var bufferSize = srcBuffer ? srcBuffer.length*srcBuffer.BYTES_PER_ELEMENT : 0;
//     size += bufferSize;
//
//     let bufferConstructorName;
//     if( srcBuffer )
//     {
//       let longDescriptor = _.LongTypeToDescriptorsHash.get( srcBuffer.constructor );
//
//       if( longDescriptor )
//       bufferConstructorName = longDescriptor.name;
//       else
//       bufferConstructorName = srcBuffer.constructor.name;
//
//     }
//     else
//     {
//       bufferConstructorName = 'null';
//     }
//
//     var descriptor =
//     {
//       'bufferConstructorName' : bufferConstructorName,
//       'sizeOfScalar' : srcBuffer ? srcBuffer.BYTES_PER_ELEMENT : 0,
//       'offset' : -1,
//       'size' : bufferSize,
//       'index' : index,
//     }
//
//     buffers.push( srcBuffer );
//     descriptorsArray.push( descriptor );
//     descriptorsMap[ id ] = descriptor;
//
//     it.dst = id;
//
//   }
//
//   /* clone data */
//
//   result.data = _._clone( o );
//   result.descriptorsMap = descriptorsMap;
//
//   /* sort by atom size */
//
//   descriptorsArray.sort( function( a, b )
//   {
//     return b[ 'sizeOfScalar' ] - a[ 'sizeOfScalar' ];
//   });
//
//   /* alloc */
//
//   result.buffer = new BufferRaw( size );
//   var dstBuffer = _.bufferBytesGet( result.buffer );
//
//   /* copy buffers */
//
//   for( var b = 0 ; b < descriptorsArray.length ; b++ )
//   {
//
//     var descriptor = descriptorsArray[ b ];
//     var buffer = buffers[ descriptor.index ];
//     var bytes = buffer ? _.bufferBytesGet( buffer ) : new U8x();
//     var bufferSize = descriptor[ 'size' ];
//
//     descriptor[ 'offset' ] = offset;
//
//     _.bufferMove( dstBuffer.subarray( offset, offset+bufferSize ), bytes );
//
//     offset += bufferSize;
//
//   }
//
//   return result;
// }
//
// cloneDataSeparatingBuffers.defaults =
// {
//   copyingBuffers : 1,
// }
//
// cloneDataSeparatingBuffers.defaults.__proto__ = cloneData.defaults;

//

/**
 * @summary Replicates a complex data structure using iterator.
 * @param {Object} o Options map
 * @param {Object} o.it Iterator object
 * @param {Object} o.root
 * @param {Object} o.src Source data structure
 * @param {Object} o.dst Target data structure
 * @param {Number} o.recursive=Infinity
 *
 * @returns {Object} Returns `dst` structure.
 * @function replicateIt
 * @namespace Tools
 * @module Tools/base/Replicator
 */

//

/**
 * @summary Replicates a complex data structure.
 * @param {*} src Source data scructure
 * @param {*} dst Target data scructure
 *
 * @returns {} Returns `dst` structure.
 * @function replicate
 * @namespace Tools
 * @module Tools/base/Replicator
 */

// --
// relations
// --

let DstWriteDown =
[
  _dstWriteDownTerminal,
  _dstWriteDownCountable,
  _dstWriteDownAux,
  _dstWriteDownHashMap,
  _dstWriteDownSet,
  _dstWriteDownCustom,
]

let ContainerMake =
[
  _containerMakeTerminal,
  _containerMakeCountable,
  _containerMakeAux,
  _containerMakeHashMap,
  _containerMakeSet,
  _containerMakeCustom,
]

let LookerExtension =
{
  constructor : function Replicator(){},
  optionsFromArguments,
  optionsToIteration,
  iteratorInitEnd,
  performEnd,
  dstWriteDown,
  _dstWriteDownTerminal,
  _dstWriteDownCountable,
  _dstWriteDownAux,
  _dstWriteDownHashMap,
  _dstWriteDownSet,
  _dstWriteDownCustom,
  dstMake,
  _containerMakeTerminal,
  _containerMakeCountable,
  _containerMakeAux,
  _containerMakeHashMap,
  _containerMakeSet,
  _containerMakeCustom,
  visitUpBegin,
  visitUpEnd,
  visitDownEnd,
  DstWriteDown,
  ContainerMake,
}

let Iterator = Object.create( null );
Iterator.result = undefined;
Iterator.originalResult = undefined;

let Iteration = Object.create( null );
Iteration.dst = undefined;
Iteration.dstMaking = true;
Iteration.dstWritingDown = true;

let Replicator = _.looker.classDefine
({
  name : 'Replicator',
  parent : _.looker.Looker,
  prime : Prime,
  seeker : LookerExtension,
  iterator : Iterator,
  iteration : Iteration,
  exec : { head : exec_head, body : exec_body },
});

_.assert( _.props.has( Replicator.Iteration, 'src' ) && Replicator.Iteration.src === undefined );
_.assert( _.props.has( Replicator.IterationPreserve, 'src' ) && Replicator.IterationPreserve.src === undefined );
_.assert( _.props.has( Replicator, 'src' ) && Replicator.src === undefined );
_.assert( _.props.has( Replicator.Iteration, 'dst' ) && Replicator.Iteration.dst === undefined );
_.assert( _.props.has( Replicator, 'dst' ) && Replicator.dst === undefined );
_.assert( _.props.has( Replicator.Iterator, 'result' ) && Replicator.Iterator.result === undefined );
_.assert( _.props.has( Replicator, 'result' ) && Replicator.result === undefined );

// --
// replicator extension
// --

let ReplicatorExtension =
{

  name : 'replicator',
  Seeker : Replicator,
  Replicator,
  replicateIt : Replicator.execIt,
  replicate : Replicator.exec,

}

Object.assign( _.replicator, ReplicatorExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  replicate : Replicator.exec,

}

Object.assign( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

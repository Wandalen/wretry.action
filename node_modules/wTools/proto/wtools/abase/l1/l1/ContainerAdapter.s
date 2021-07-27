( function _ContainerAdapter_s_()
{

'use strict';

const _global = _realGlobal_;
const _ = _global_.wTools;

if( _global !== _realGlobal_ && _realGlobal_.wTools.containerAdapter )
return ExportTo( _global, _realGlobal_ );

_.assert( _.routine.is( _.longLeft ) );

// --
// type test
// --

function make( container )
{

  _.assert( arguments.length === 1 );

  if( _.set.is( container ) )
  {
    return new _.containerAdapter.Set( container );
  }
  else if( _.arrayIs( container ) )
  {
    return new _.containerAdapter.Array( container );
  }
  else if( this.is( container ) )
  {
    return container.make();
  }
  else _.assert( 0, 'Unknown type of container' );

}

//

function from( container )
{
  _.assert( arguments.length === 1 );
  if( container instanceof ContainerAdapterAbstract )
  {
    return container;
  }
  else if( _.set.is( container ) )
  {
    return new _.containerAdapter.Set( container );
  }
  else if( _.arrayIs( container ) )
  {
    return new _.containerAdapter.Array( container );
  }
  else _.assert( 0, 'Unknown type of container' );
}

//

function toOriginal( dst )
{
  if( !dst )
  return dst;
  if( dst instanceof ContainerAdapterAbstract )
  return dst.original;
  return dst;
}

//

function toOriginals( dsts, srcs )
{
  if( srcs === undefined )
  srcs = dsts;

  if( srcs === dsts )
  {
    if( _.longIs( dsts ) ) /* Dmytro : in this context needs to check instance of some long */
    // if( _.argumentsArray.like( dsts ) )
    {
      for( let s = 0 ; s < dsts.length ; s++ )
      dsts[ s ] = this.toOriginal( dsts[ s ] );
      return dsts;
    }
    return this.toOriginal( dsts );
  }
  else
  {
    if( dsts === null )
    dsts = [];

    if( _.arrayIs( dsts ) )
    {
      if( _.longIs( srcs ) ) /* Dmytro : in this context needs to check instance of some long */
      // if( _.argumentsArray.like( srcs ) )
      {
        for( let s = 0 ; s < srcs.length ; s++ )
        // for( let e of srcs ) /* Dmytro : not optimal for longs */
        dsts.push( this.toOriginal( srcs[ s ] ) );
        return dsts;
      }
      else
      dsts.push( this.toOriginal( srcs ) );
      return dsts;
    }
    else
    {
      if( _.longIs( srcs ) ) /* Dmytro : in this context needs to check instance of some long */
      // if( _.argumentsArray.like( srcs ) )
      {
        let result = [];
        result.push( this.toOriginal( dsts ) );
        for( let e of srcs )
        result.push( this.toOriginal( e ) );
        return result;
      }
      return this.toOriginals( [], arguments );
    }
  }
}

// --
//
// --

class ContainerAdapterAbstract
{
  constructor( container )
  {
    _.assert( arguments.length === 1 );
    this.original = container;
  }
  static ToOriginal( container )
  {
    if( container instanceof ContainerAdapterAbstract )
    return container.original;
    return container;
  }
  ToOriginal( container )
  {
    return this.constructor.ToOriginal( container );
  }
  static Is( src )
  {
    return _.containerAdapter.is( src );
  }
  Is( src )
  {
    return this.constructor.Is( src );
  }
  static IsContainer( src )
  {
    return _.containerAdapter.isContainer( src );
  }
  IsContainer( src )
  {
    return this.constructor.IsContainer( src );
  }
  static Make( src )
  {
    return _.containerAdapter.make( ... arguments );
  }
  Make( src )
  {
    return this.constructor.Make( ... arguments );
  }
  static From( src )
  {
    return _.containerAdapter.from( src );
  }
  From( src )
  {
    return this.constructor.From( src );
  }
  _filterArguments( dst, onEach )
  {
    if( _.routine.is( arguments[ 0 ] ) )
    {
      _.assert( onEach === undefined );
      onEach = dst;
      dst = null;
    }
    if( dst === null || ( !dst && !onEach ) )
    dst = this.MakeEmpty();
    else if( dst === _.self )
    dst = this;
    else
    dst = this.From( dst );
    return [ dst, onEach ];
  }
  _onlyArguments( /* dst, src2, onEvaluate1, onEvaluate2 */ )
  {
    let dst = arguments[ 0 ];
    let src2 = arguments[ 1 ];
    let onEvaluate1 = arguments[ 2 ];
    let onEvaluate2 = arguments[ 3 ];

    if( _.routine.is( src2 ) || src2 === undefined )
    {
      if( dst === undefined )
      dst = null;

      onEvaluate2 = onEvaluate1;
      onEvaluate1 = src2;
      src2 = dst;
      dst = null;
    }

    if( dst === _.self )
    dst = this;
    else if( dst )
    dst = this.From( dst );
    else
    dst = this.MakeEmpty();

    if( src2 === _.self )
    src2 = this;
    else if( src2 )
    src2 = this.From( src2 );
    else
    src2 = this.MakeEmpty();

    return [ dst, src2, onEvaluate1, onEvaluate2 ];
  }
  _same( src )
  {
    return src.original === this.original;
  }
  same( src )
  {
    if( !src )
    return false;
    if( src instanceof ContainerAdapterAbstract )
    return this._same( src );
    return this.original === src;
  }
  removedContainer( src )
  {
    let result = 0;
    let self = this;

    if( self._same( src ) )
    src = self.From( [ ... src.original ] );
    else
    src = self.From( src );

    src.each( ( e ) => result += self.removed( e ) );
    return result;
  }
  removedContainerOnce( src, onEvaluate1, onEvaluate2 )
  {
    let result = 0;
    let self = this;

    if( self._same( src ) )
    src = self.From( [ ... src.original ] );
    else
    src = self.From( src );

    src.each( ( e ) =>
    {
      let r = self.removedOnce( e, onEvaluate1, onEvaluate2 );
      if( r !== -1 )
      result++;
    });
    return result;
  }
  removedContainerOnceStrictly( src, onEvaluate1, onEvaluate2 )
  {
    let self = this;

    if( self._same( src ) )
    src = self.From( [ ... src.original ] );
    else
    src = self.From( src );

    let result = src.length;
    src.each( ( e ) => self.removeOnceStrictly( e, onEvaluate1, onEvaluate2 ) );

    return result;
  }
  removeContainer( src )
  {
    let self = this;
    self.removedContainer.apply( self, arguments );
    return self;
  }
  removeContainerOnce( src, onEvaluate1, onEvaluate2 )
  {
    let self = this;
    self.removedContainerOnce.apply( self, arguments );
    return self;
  }
  removeContainerOnceStrictly( src, onEvaluate1, onEvaluate2 )
  {
    let self = this;
    self.removedContainerOnceStrictly.apply( self, arguments );
    return self;
  }
  min( onEach )
  {
    let self = this;
    if( onEach )
    return self.reduce( +Infinity, ( a, e ) => Math.min( a, onEach( e ) ) );
    else
    return self.reduce( +Infinity, ( a, e ) => Math.min( a, e ) );
  }
  max( onEach )
  {
    let self = this;
    if( onEach )
    return self.reduce( -Infinity, ( a, e ) => Math.max( a, onEach( e ) ) );
    else
    return self.reduce( -Infinity, ( a, e ) => Math.max( a, e ) );
  }
  least( dst, onEach )
  {
    let self = this;
    [ dst, onEach ] = this._filterArguments( ... arguments );
    let min = self.min( onEach );
    if( onEach )
    return self.filter( dst, ( e ) => onEach( e ) === min ? e : undefined );
    else
    return self.filter( dst, ( e ) => e === min ? e : undefined );
  }
  most( dst, onEach )
  {
    let self = this;
    [ dst, onEach ] = this._filterArguments( ... arguments );
    let max = self.max( onEach );
    if( onEach )
    return self.filter( dst, ( e ) => onEach( e ) === max ? e : undefined );
    else
    return self.filter( dst, ( e ) => e === max ? e : undefined );
  }
  only( /* dst, src2, onEvaluate1, onEvaluate2 */ )
  {
    let dst = arguments[ 0 ];
    let src2 = arguments[ 1 ];
    let onEvaluate1 = arguments[ 2 ];
    let onEvaluate2 = arguments[ 3 ];

    _.assert( 1 <= arguments.length && arguments.length <= 4 );

    let self = this;
    let container = self.original;

    [ dst, src2, onEvaluate1, onEvaluate2 ] = self._onlyArguments( ... arguments );

    if( self._same( src2 ) )
    {
      return self;
    }

    if( self._same( dst ) )
    {
      let temp = [ ... container ];

      for( let i = 0; i < temp.length; i++ )
      {
        if( !src2.has( temp[ i ], onEvaluate1, onEvaluate2 ) )
        dst.removeOnce( temp[ i ] );
      }
    }
    else
    {
      src2.each( ( e ) =>
      {
        if( self.has( e, onEvaluate1, onEvaluate2 ) )
        dst.appendOnce( e );
      });
    }

    return dst;
  }
  but( /* dst, src2, onEvaluate1, onEvaluate2 */ )
  {
    let dst = arguments[ 0 ];
    let src2 = arguments[ 1 ];
    let onEvaluate1 = arguments[ 2 ];
    let onEvaluate2 = arguments[ 3 ];

    _.assert( 1 <= arguments.length && arguments.length <= 4 );

    let self = this;
    let container = self.original;

    [ dst, src2, onEvaluate1, onEvaluate2 ] = self._onlyArguments( ... arguments );

    if( self._same( src2 ) )
    {
      self.empty();
      return self;
    }

    if( self._same( dst ) )
    {
      let temp = [ ... container ];

      for( let i = 0; i < temp.length; i++ )
      {
        if( src2.has( temp[ i ], onEvaluate1, onEvaluate2 ) )
        dst.removeOnce( temp[ i ] );
      }
    }
    else
    {
      self.each( ( e ) =>
      {
        if( !src2.has( e, onEvaluate1, onEvaluate2 ) )
        dst.appendOnce( e );
      });
    }

    return dst;
  }
  select( selector )
  {
    let self = this;
    let container = self.original;

    let result = [];
    for( let e of container )
    {
      if( _.select( e, selector ) )
      result.push( e )
    }

    return result;
  }
}

// --
// meta
// --

function ExportTo( dstGlobal, srcGlobal )
{
  let _ = dstGlobal.wTools;
  _.assert( _.containerAdapter === undefined );
  _.assert( _.mapIs( srcGlobal.wTools.containerAdapter ) );
  _.containerAdapter = srcGlobal.wTools.containerAdapter;
  if( typeof module !== 'undefined' )
  module[ 'exports' ] = _.containerAdapter;
}

// --
// declare
// --

var Extension =
{

  make,
  from,

  toOriginal,
  toOriginals,

  Abstract : ContainerAdapterAbstract,

}

//

Object.assign( _.containerAdapter, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

if( _global !== _realGlobal_ )
return ExportTo( _realGlobal_, _global );

})();

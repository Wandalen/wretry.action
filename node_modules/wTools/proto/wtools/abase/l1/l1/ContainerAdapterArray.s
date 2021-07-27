( function _ContainerAdapterArray_s_()
{

'use strict';

const _global = _realGlobal_;
const _ = _global_.wTools;

if( _global !== _realGlobal_ && _realGlobal_.wTools.containerAdapter )
return ExportTo( _global, _realGlobal_ );

_.assert( _.routine.is( _.containerAdapter.Abstract ) );
_.assert( _.routine.is( _.longLeft ) );

// --
// implementation
// --

function make()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return new ContainerAdapterArray( this.original.slice() );
}

//

function MakeEmpty()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return new ContainerAdapterArray( new Array );
}

//

function makeEmpty()
{
  return this.constructor.MakeEmpty();
}

//

function Make( src )
{
  if( src === undefined || src === null )
  return this.MakeEmpty();
  else if( _.number.is( src ) )
  return new ContainerAdapterArray( new Array( src ) );
  else if( this.IsContainer( src ) )
  return new ContainerAdapterArray( [ ... src ] );
  else if( this.Is( src ) )
  return new ContainerAdapterArray( [ ... src.original ] );
}

//

class ContainerAdapterArray extends _.containerAdapter.Abstract
{
  constructor( container )
  {
    if( container === undefined )
    container = new Array;
    super( container );
    _.assert( arguments.length === 0 || arguments.length === 1 );
    _.assert( _.longLike( container ) );
  }
  // make = make; // Dmytro : simple assigning methods as a property is able in NodeJs v12 and later. So, I assign this properties after class declaration.
  // static MakeEmpty = MakeEmpty;
  // MakeEmpty = makeEmpty;
  // static Make = Make;
  has( e, onEvaluate1, onEvaluate2 )
  {
    if( _.routine.is( onEvaluate1 ) || _.routine.is( onEvaluate2 ) )
    {
      if( _.longLeftIndex( this.original, e, onEvaluate1, onEvaluate2 ) !== -1 )
      return true;
      return false;
    }
    return this.original.includes( e );
  }
  count( e, onEvaluate1, onEvaluate2 )
  {
    return _.longCountElement( this.original, e, onEvaluate1, onEvaluate2 );
  }
  copyFrom( src )
  {
    let self = this;
    let container = self.original;

    if( self.same( src ) )
    return self;

    if( !self.IsContainer( src ) && !self.Is( src ) )
    _.assert( 0, '{-src-} should be container' );

    let i = 0;
    for( let e of src )
    {
      container[ i ] = e;
      i++;
    }

    return self;
  }
  append( e )
  {
    this.original.push( e );
    return this;
  }
  appendOnce( e, onEvaluate1, onEvaluate2 )
  {
    _.arrayAppendOnce( this.original, e, onEvaluate1, onEvaluate2 );
    return this;
  }
  appendOnceStrictly( e, onEvaluate1, onEvaluate2 )
  {
    _.arrayAppendOnceStrictly( this.original, e, onEvaluate1, onEvaluate2 )
    return this;
  }
  push( e )
  {
    return this.original.push( e );
  }
  appendContainer( container )
  {
    container = this.ToOriginal( container );
    if( _.longIs( container ) )
    {
      _.arrayAppendArray( this.original, container );
    }
    else if( _.set.is( container ) )
    {
      for( let e of container )
      {
        this.original.push( e );
      }
    }
    else
    {
      _.assert( 0, 'Unexpected data type' );
    }
    return this;
  }
  appendContainerOnce( container, onEvaluate1, onEvaluate2 )
  {
    container = this.ToOriginal( container );
    if( _.longIs( container ) )
    _.arrayAppendArrayOnce( this.original, container, onEvaluate1, onEvaluate2 );
    else if( _.set.is( container ) )
    _.arrayAppendArrayOnce( this.original, [ ... container ], onEvaluate1, onEvaluate2 );
    else _.assert( 0, 'Unexpected data type' );
    return this;
  }
  appendContainerOnceStrictly( container, onEvaluate1, onEvaluate2 )
  {
    container = this.ToOriginal( container );
    if( _.longIs( container ) )
    _.arrayAppendArrayOnceStrictly( this.original, container, onEvaluate1, onEvaluate2 );
    else if( _.set.is( container ) )
    _.arrayAppendArrayOnceStrictly( this.original, [ ... container ], onEvaluate1, onEvaluate2 );
    else _.assert( 0, 'Unexpected data type' );
    return this;
  }
  pop( e, onEvaluate1, onEvaluate2 )
  {
    var poped = this.original.pop();
    _.assert( e === undefined || _.entity.equal( poped, e, onEvaluate1, onEvaluate2 ) );
    return poped;
  }
  popStrictly( e, onEvaluate1, onEvaluate2 )
  {
    _.assert( 1 <= arguments.length && arguments.length <= 3 );
    _.assert( _.entity.equal( this.last(), e, onEvaluate1, onEvaluate2 ), 'Container does not have such element' );

    var poped = this.original.pop();
    return poped;
  }
  removed( e, onEvaluate1, onEvaluate2 )
  {
    return _.arrayRemoved( this.original, e, onEvaluate1, onEvaluate2 );
  }
  removedOnce( e, onEvaluate1, onEvaluate2 )
  {
    return _.arrayRemovedOnce( this.original, e, onEvaluate1, onEvaluate2 );
  }
  removedOnceLeft( e, onEvaluate1, onEvaluate2 )
  {
    return _.arrayRemovedOnce( this.original, e, onEvaluate1, onEvaluate2 );
  }
  removedOnceRight( e, onEvaluate1, onEvaluate2 )
  {
    let index = _.longRightIndex( this.original, e, onEvaluate1, onEvaluate2 );
    if( index !== -1 )
    this.original.splice( index, 1 );
    return index;
  }
  removedOnceStrictly( e, onEvaluate1, onEvaluate2 )
  {
    return _.arrayRemovedOnceStrictly( this.original, e, onEvaluate1, onEvaluate2 );
  }
  removedOnceStrictlyLeft( e, onEvaluate1, onEvaluate2 )
  {
    return _.arrayRemovedOnceStrictly( this.original, e, onEvaluate1, onEvaluate2 );
  }
  removedOnceStrictlyRight( e, onEvaluate1, onEvaluate2 )
  {
    let container = this.original;
    let index = _.longRightIndex( container, e, onEvaluate1, onEvaluate2 );
    _.assert( index !== -1, () => 'Container has not element ' + _.entity.exportStringDiagnosticShallow( e ) );
    container.splice( index, 1 );
    if( _.number.is( onEvaluate1 ) )
    onEvaluate1--;
    _.assert( _.longRightIndex( container, e, onEvaluate1, onEvaluate2 ) === -1, () => 'The element ' + _.entity.exportStringDiagnosticShallow( e ) + ' is several times in dstArray' );
    return index;
  }
  remove( e, onEvaluate1, onEvaluate2 )
  {
    _.arrayRemove( this.original, e, onEvaluate1, onEvaluate2 );
    return this;
  }
  removeOnce( e, onEvaluate1, onEvaluate2 )
  {
    _.arrayRemoveOnce( this.original, e, onEvaluate1, onEvaluate2 );
    return this;
  }
  removeOnceLeft( e, onEvaluate1, onEvaluate2 )
  {
    _.arrayRemoveOnce( this.original, e, onEvaluate1, onEvaluate2 );
    return this;
  }
  removeOnceRight( e, onEvaluate1, onEvaluate2 )
  {
    this.removedOnceRight( e, onEvaluate1, onEvaluate2 );
    return this;
  }
  removeOnceStrictly( e, onEvaluate1, onEvaluate2 )
  {
    _.arrayRemovedOnceStrictly( this.original, e, onEvaluate1, onEvaluate2 );
    return this;
  }
  removeOnceStrictlyLeft( e, onEvaluate1, onEvaluate2 )
  {
    _.arrayRemovedOnceStrictly( this.original, e, onEvaluate1, onEvaluate2 );
    return this;
  }
  removeOnceStrictlyRight( e, onEvaluate1, onEvaluate2 )
  {
    this.removedOnceStrictlyRight( e, onEvaluate1, onEvaluate2 );
    return this;
  }
  empty()
  {
    this.original.splice( 0, this.original.length );
  }
  map( dst, onEach )
  {
    let self = this;
    let container = this.original;
    [ dst, onEach ] = this._filterArguments( ... arguments );
    if( this._same( dst ) )
    {
      for( let k = 0 ; k < container.length ; k++ )
      {
        let e = container[ k ];
        let e2 = onEach( e, k, self );
        if( e2 !== undefined )
        {
          container[ k ] = e2;
        }
      }
    }
    else
    {
      for( let k = 0 ; k < container.length ; k++ )
      {
        let e = container[ k ];
        let e2 = onEach( e, k, self );
        if( e2 !== undefined )
        dst.append( e2 );
        else
        dst.append( e );
      }
    }
    return dst;
  }
  mapLeft( dst, onEach )
  {
    return this.map.apply( this, arguments );
  }
  mapRight( dst, onEach )
  {
    let container = this.original;
    [ dst, onEach ] = this._filterArguments( ... arguments );
    if( this._same( dst ) )
    {
      for( let k = container.length - 1; k >= 0; k-- )
      {
        let e2 = onEach( container[ k ], k, this );
        if( e2 !== undefined )
        container[ k ] = e2;
      }
    }
    else
    {
      for( let k = container.length - 1; k >= 0; k-- )
      {
        let e2 = onEach( container[ k ], k, this );
        if( e2 !== undefined )
        dst.append( e2 );
        else
        dst.append( container[ k ] );
      }
    }
    return dst;
  }
  filter( dst, onEach )
  {
    let self = this;
    let container = this.original;
    [ dst, onEach ] = this._filterArguments( ... arguments );

    if( this._same( dst ) )
    {
      for( let k = 0; k < container.length; k++ )
      {
        let e = container[ k ];
        let e2 = onEach( e, k, container );
        if( e2 === undefined )
        {
          container.splice( k, 1 );
          k--;
        }
        else if( e2 !== e )
        {
          container[ k ] = e2;
        }
      }
    }
    else
    {
      for( let k = 0; k < container.length; k++ )
      {
        let e = container[ k ];
        let e2 = onEach( e, k, container );
        if( e2 !== undefined )
        dst.append( e2 );
      }
    }

    return dst;
  }
  filterLeft( dst, onEach )
  {
    return this.filter.apply( this, arguments );
  }
  filterRight( dst, onEach )
  {
    let self = this;
    let container = this.original;
    [ dst, onEach ] = this._filterArguments( ... arguments );

    if( this._same( dst ) )
    {
      for( let k = container.length - 1; k >= 0; k-- )
      {
        let e2 = onEach( container[ k ], k, container );
        if( e2 === undefined )
        container.splice( k, 1 );
        else if( container[ k ] !== e2 )
        container[ k ] = e2;
      }
    }
    else
    {
      for( let k = container.length - 1; k >= 0; k-- )
      {
        let e2 = onEach( container[ k ], k, container );
        if( e2 !== undefined )
        dst.append( e2 );
      }
    }

    return dst;
  }
  flatFilter( dst, onEach )
  {
    let self = this;
    let container = self.original;
    [ dst, onEach ] = self._filterArguments( ... arguments );

    if( self._same( dst ) )
    {
      for( let k = 0; k < container.length; k++ )
      {
        let e = container[ k ];
        let e2 = onEach( e, k, self );
        if( e2 === undefined )
        {
          container.splice( k, 1 )
          k--;
        }
        else if( self.IsContainer( e2 ) || self.Is( e2 ) )
        {
          k += e2.length - 1;
          container.splice( k, 1, ... e2 );
        }
        else if( e2 !== e )
        {
          container[ k ] = e2;
        }
      }
    }
    else
    {
      for( let k = 0; k < container.length; k++ )
      {
        let e = container[ k ];
        let e2 = onEach( e, k, container );
        if( self.IsContainer( e2 ) || self.Is( e2 ) )
        dst.appendContainer( e2 )
        else if( e2 !== undefined )
        dst.append( e2 );
      }
    }

    return dst;
  }
  flatFilterLeft( dst, onEach )
  {
    return this.flatFilter.apply( this, arguments );
  }
  flatFilterRight( dst, onEach )
  {
    let self = this;
    let container = self.original;
    [ dst, onEach ] = self._filterArguments( ... arguments );

    if( self._same( dst ) )
    {
      for( let k = container.length - 1; k >= 0; k-- )
      {
        let e = container[ k ];
        let e2 = onEach( e, k, self );

        if( e2 === undefined )
        container.splice( k, 1 );
        else if( self.IsContainer( e2 ) || self.Is( e2 ) )
        container.splice( k, 1, ... e2 );
        else if( e2 !== e )
        container[ k ] = e2;
      }
    }
    else
    {
      for( let k = container.length - 1; k >= 0; k-- )
      {
        let e = container[ k ];
        let e2 = onEach( e, k, container );

        if( self.IsContainer( e2 ) || self.Is( e2 ) )
        dst.appendContainer( e2 )
        else if( e2 !== undefined )
        dst.append( e2 );
      }
    }

    return dst;
  }
  once( dst, onEvaluate1, onEvaluate2 )
  {
    let container = this.original;
    [ dst, dst, onEvaluate1, onEvaluate2 ] = this._onlyArguments( null, dst, onEvaluate1, onEvaluate2 );

    if( this._same( dst ) )
    _.longOnce( container, onEvaluate1, onEvaluate2 );
    else
    dst.appendContainerOnce( container, onEvaluate1, onEvaluate2 );

    return dst;
  }
  onceLeft( dst, onEvaluate1, onEvaluate2 )
  {
    return this.once.apply( this, arguments );
  }
  onceRight( dst, onEvaluate1, onEvaluate2 )
  {
    let container = this.original;
    [ dst, dst, onEvaluate1, onEvaluate2 ] = this._onlyArguments( null, dst, onEvaluate1, onEvaluate2 );

    if( this._same( dst ) )
    {
      _.longOnce( container, onEvaluate1, onEvaluate2 );
    }
    else
    {
      for( let i = container.length - 1; i >= 0; i-- )
      dst.appendOnce( container[ i ], onEvaluate1, onEvaluate2 );
    }

    return dst;
  }
  withIndex( index )
  {
    let self = this;
    return self.original[ index ];
  }
  first( onEach )
  {
    let self = this;
    let container = this.original;
    if( onEach )
    {
      if( !container.length )
      return undefined;
      return onEach( container[ 0 ], 0, self );
    }
    else
    {
      return container[ 0 ];
    }
  }
  last( onEach )
  {
    let self = this;
    let container = this.original;
    let l = container.length-1;
    if( onEach )
    {
      if( !container.length )
      return undefined;
      return onEach( container[ l ], l, self );
    }
    else
    {
      return container[ l ];
    }
  }
  each( onEach )
  {
    return this.eachLeft( onEach );
  }
  eachLeft( onEach )
  {
    let container = this.original;
    for( let i = 0; i < container.length; i++ )
    onEach( container[ i ], i, this );
    return this;
  }
  eachRight( onEach )
  {
    let self = this;
    let container = this.original;
    for( let k = container.length - 1 ; k >= 0 ; k-- )
    onEach( container[ k ], k, container );
    return this;
  }
  reduce( accumulator, onEach )
  {
    let self = this;
    let container = this.original;
    if( arguments[ 1 ] === undefined )
    {
      onEach = arguments[ 0 ];
      accumulator = undefined;
    }
    for( let k = 0, l = container.length ; k < l ; k++ )
    {
      let e = container[ k ];
      accumulator = onEach( accumulator, e, k, self );
    }
    return accumulator;
  }
  reduceLeft( accumulator, onEach )
  {
    return this.reduce.apply( this, arguments );
  }
  reduceRight( accumulator, onEach )
  {
    let self = this;
    let container = this.original;
    if( arguments[ 1 ] === undefined )
    {
      onEach = arguments[ 0 ];
      accumulator = undefined;
    }
    for( let k = container.length - 1; k >= 0; k-- )
    {
      let e = container[ k ];
      accumulator = onEach( accumulator, e, k, self );
    }
    return accumulator;
  }
  all( onEach )
  {
    return this.allLeft( onEach );
  }
  allLeft( onEach )
  {
    let container = this.original;
    for( let i = 0; i < container.length; i++ )
    {
      let r = onEach( container[ i ], i, container );
      if( !r )
      return false;
    }
    return true;
  }
  allRight( onEach )
  {
    let container = this.original;
    for( let i = container.length - 1; i >= 0; i-- )
    {
      let r = onEach( container[ i ], i, container );
      if( !r )
      return false;
    }
    return true;
  }
  any( onEach )
  {
    return this.anyLeft( onEach );
  }
  anyLeft( onEach )
  {
    let container = this.original;
    for( let i = 0; i < container.length; i++ )
    {
      let r = onEach( container[ i ], i, container );
      if( r )
      return true;
    }
    return false;
  }
  anyRight( onEach )
  {
    let container = this.original;
    for( let i = container.length-1; i >= 0; i-- )
    {
      let r = onEach( container[ i ], i, container );
      if( r )
      return true;
    }
    return false;
  }
  none( onEach )
  {
    return this.noneLeft( onEach );
  }
  noneLeft( onEach )
  {
    let container = this.original;
    for( let i = 0; i < container.length; i++ )
    {
      let r = onEach( container[ i ], i, container );
      if( r )
      return false;
    }
    return true;
  }
  noneRight( onEach )
  {
    let container = this.original;
    for( let i = container.length - 1; i >= 0; i-- )
    {
      let r = onEach( container[ i ], i, container );
      if( r )
      return false;
    }
    return true;
  }
  left( /* element, fromIndex, onEvaluate1, onEvaluate2 */ )
  {
    let element = arguments[ 0 ];
    let fromIndex = arguments[ 1 ];
    let onEvaluate1 = arguments[ 2 ];
    let onEvaluate2 = arguments[ 3 ];

    _.assert( 1 <= arguments.length && arguments.length <= 4 );
    return _.longLeft( this.original, element, fromIndex, onEvaluate1, onEvaluate2 );
  }
  right( /* element, fromIndex, onEvaluate1, onEvaluate2 */ )
  {
    let element = arguments[ 0 ];
    let fromIndex = arguments[ 1 ];
    let onEvaluate1 = arguments[ 2 ];
    let onEvaluate2 = arguments[ 3 ];

    _.assert( 1 <= arguments.length && arguments.length <= 4 );
    return _.longRight( this.original, element, fromIndex, onEvaluate1, onEvaluate2 );
  }
  reverse( dst )
  {
    let srcContainer = this.original;

    if( !dst )
    {
      dst = this.Make( this.length );
      let dstContainer = dst.original;
      for( let i1 = srcContainer.length - 1, i2 = 0; i1 >= 0; i1--, i2++ )
      {
        dstContainer[ i1 ] = srcContainer[ i2 ];
      }
    }
    else
    {
      dst = this.From( dst );
      let dstContainer = dst.original;
      if( srcContainer === dstContainer )
      {
        let last2 = ( srcContainer.length - srcContainer.length % 2 ) / 2;
        let last1 = ( srcContainer.length % 2 ? last2 : last2-1 );
        for( let i1 = last1, i2 = last2; i1 >= 0; i1--, i2++ )
        {
          let e = srcContainer[ i1 ];
          srcContainer[ i1 ] = srcContainer[ i2 ];
          srcContainer[ i2 ] = e;
        }
      }
      else
      {
        for( let i = srcContainer.length - 1; i >= 0; i-- )
        {
          dst.append( srcContainer[ i ] );
        }
      }
    }
    return dst;
  }
  join( delimeter )
  {
    return this.original.join( delimeter );
  }
  toArray()
  {
    return this;
  }
  toSet()
  {
    return new _.containerAdapter.Set( new Set([ ... this.original ]) );
  }
  [ Symbol.iterator ]()
  {
    return this.original[ Symbol.iterator ]();
  }
  get length()
  {
    return this.original.length;
  }
}
ContainerAdapterArray.Make = Make;
ContainerAdapterArray.MakeEmpty = MakeEmpty;
ContainerAdapterArray.prototype.make = make;
ContainerAdapterArray.prototype.MakeEmpty = makeEmpty;

// --
// meta
// --

function ExportTo( dstGlobal, srcGlobal )
{
  debugger;
  let _ = dstGlobal.wTools;
  _.assert( _.containerAdapter === srcGlobal.wTools.containerAdapter );
  _.assert( _.mapIs( srcGlobal.wTools.containerAdapter ) );
  if( typeof module !== 'undefined' )
  module[ 'exports' ] = _.containerAdapter;
}

// --
// declare
// --

const Self = _.containerAdapter;

//

var Extension =
{

  Array : ContainerAdapterArray,

}

//

Object.assign( _.containerAdapter, Extension );
_.assert( _.containerAdapter === Self );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

if( _global !== _realGlobal_ )
return ExportTo( _realGlobal_, _global );

})();

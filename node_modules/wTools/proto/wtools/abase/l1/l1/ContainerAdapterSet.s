( function _ContainerAdapterSet_s_()
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
  return new ContainerAdapterSet( new Set( this.original ) );
}

//

function MakeEmpty()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return new ContainerAdapterSet( new Set );
}

//

function Make( src )
{
  if( src === undefined || src === null )
  return this.MakeEmpty();
  else if( _.number.is( src ) )
  return new ContainerAdapterSet( new Set );
  else if( this.IsContainer( src ) )
  return new ContainerAdapterSet( new Set( src ) );
  else if( this.Is( src ) )
  return new ContainerAdapterSet( new Set( src.original ) );
}

//

function makeEmpty()
{
  return this.constructor.MakeEmpty();
}

//

class ContainerAdapterSet extends _.containerAdapter.Abstract
{
  // Dmytro : using constructor and super() method is old syntax, it can be deleted
  // aaa : cover constructors /* Dmytro : covered */
  constructor( container )
  {
    if( container === undefined )
    container = new Set;
    super( container );
    _.assert( arguments.length === 0 || arguments.length === 1 );
    _.assert( _.set.like( container ) );
  }
  // make = make; // Dmytro : simple assigning methods as a property is able in NodeJs v12 and later. So, I assign this properties after class declaration.
  // static MakeEmpty = MakeEmpty;
  // MakeEmpty = makeEmpty;
  // static Make = Make;
  has( e, onEvaluate1, onEvaluate2 )
  {
    _.assert( onEvaluate2 === undefined || _.routine.is( onEvaluate2 ) );

    let fromIndex = 0;
    if( _.number.is( onEvaluate1 ) )
    {
      fromIndex = onEvaluate1;
      onEvaluate1 = onEvaluate2;
      onEvaluate2 = undefined;
    }

    if( _.routine.is( onEvaluate1 ) )
    {
      if( onEvaluate1.length === 2 )
      {
        _.assert( !onEvaluate2 );

        for( let el of this.original )
        {
          if( fromIndex === 0 )
          {
            if( onEvaluate1( el, e ) )
            return true;
          }
          else
          {
            fromIndex -= 1;
          }
        }

        return false;
      }
      else if( onEvaluate1.length === 1 )
      {
        _.assert( !onEvaluate2 || onEvaluate2.length === 1 );

        if( onEvaluate2 )
        e = onEvaluate2( e );
        else
        e = onEvaluate1( e );

        for( let el of this.original )
        {
          if( fromIndex === 0 )
          {
            if( onEvaluate1( el ) === e )
            return true;
          }
          else
          {
            fromIndex -= 1;
          }
        }

        return false;
      }
      else _.assert( 0 );
    }
    else if( onEvaluate1 === undefined || onEvaluate1 === null )
    {
      return this.original.has( e );
    }
    else _.assert( 0 );
  }
  count( e, onEvaluate1, onEvaluate2 )
  {
    let container = this.original;

    if( _.routine.is( onEvaluate1 ) || _.routine.is( onEvaluate2 ) )
    {
      let from = 0;
      let result = 0;
      if( _.number.is( onEvaluate1 ) )
      {
        from = onEvaluate1;
        onEvaluate1 = onEvaluate2;
        onEvaluate2 = undefined;
      }

      for( let v of this.original )
      {
        if( from === 0 )
        {
          if( _.entity.equal( v, e, onEvaluate1, onEvaluate2 ) )
          result++;
        }
        else
        {
          from--;
        }
      }
      return result;
    }
    else
    {
      return container.has( e ) ? 1 : 0;
    }
  }
  copyFrom( src )
  {
    let self = this;
    let container = self.original;

    if( self.same( src ) )
    return self;

    if( !self.IsContainer( src ) && !self.Is( src ) )
    _.assert( 0, '{-src-} should be container' );

    if( self.length <= ( src.length || src.size ) )
    {
      self.empty();
      for( let e of src )
      {
        self.append( e );
      }
    }
    else
    {
      // let temp = [ ... container ];
      //
      // self.empty();
      // for( let e of src )
      // self.append( e );
      // for( let i = self.length; i < temp.length; i++ )
      // self.append( temp[ i ] );

      let length = this.length;
      let srcLength = src.length !== undefined ? src.length : src.size;
      let lengthDiff = length - srcLength;
      for( let e of src )
      {
        for( let v of container )
        {
          self.remove( v );
          break;
        }
        self.append( e );
      }
      for( let e of container )
      {
        if( lengthDiff !== 0 )
        {
          self.remove( e );
          self.append( e );
          lengthDiff--;
        }
        else
        {
          break;
        }
      }
    }

    return self;
  }
  append( e )
  {
    this.original.add( e );
    return this;
  }
  appendOnce( e, onEvaluate1, onEvaluate2 )
  {
    let container = this.original;

    if( onEvaluate1 || _.routine.is( onEvaluate2 ) )
    {
      if( !this.has( e, onEvaluate1, onEvaluate2 ) )
      container.add( e );
    }
    else
    {
      container.add( e );
    }

    return this;
  }
  appendOnceStrictly( e, onEvaluate1, onEvaluate2 )
  {
    let container = this.original;

    if( onEvaluate1 || _.routine.is( onEvaluate2 ) )
    {
      if( !this.has( e, onEvaluate1, onEvaluate2 ) )
      container.add( e );
      else
      _.assert( 0, 'Set already has such element' );
    }
    else
    {
      _.assert( !this.original.has( e ), 'Set already has such element' );
      container.add( e );
    }
    return this;
  }
  appendContainer( container )
  {
    container = this.ToOriginal( container );
    if( _.longIs( container ) )
    {
      for( let k = 0, l = container.length ; k < l ; k++ )
      this.original.add( container[ k ] );
    }
    else if( _.set.is( container ) )
    {
      for( let e of container )
      this.original.add( e );
    }
    else
    {
      _.assert( 0, 'Unexpected data type' );
    }
    return this;
  }
  appendContainerOnce( container, onEvaluate1, onEvaluate2 )
  {
    if( onEvaluate1 || _.routine.is( onEvaluate2 ) )
    {
      container = this.ToOriginal( container );

      if( _.longIs( container ) )
      {
        for( let i = 0; i < container.length; i++ )
        if( !this.has( container[ i ], onEvaluate1, onEvaluate2 ) )
        this.append( container[ i ] );
      }
      else if( _.set.is( container ) )
      {
        for( let e of container )
        if( !this.has( e, onEvaluate1, onEvaluate2 ) )
        this.append( e );
      }

      return this;
    }
    else
    {
      return this.appendContainer( container );
    }
  }
  appendContainerOnceStrictly( container, onEvaluate1, onEvaluate2 )
  {
    container = this.ToOriginal( container );

    if( _.longIs( container ) )
    {
      for( let i = 0; i < container.length; i++ )
      {
        _.assert( !this.has( container[ i ], onEvaluate1, onEvaluate2 ) );
        this.append( container[ i ] );
      }
    }
    else if( _.set.is( container ) )
    {
      for( let e of container )
      {
        _.assert( !this.has( e, onEvaluate1, onEvaluate2 ) );
        this.append( e );
      }
    }
    else _.assert( 0, 'Unexpected data type' );

    return this;
  }
  push( e )
  {
    this.original.add( e );
    return this.original.size;
  }
  pop( e, onEvaluate1, onEvaluate2 )
  {
    let self = this;
    let container = self.original;

    if( !onEvaluate1 || e === undefined )
    {
      if( e === undefined )
      e = self.last();
      let r = container.delete( e );
      _.assert( r === true );
      return e;
    }
    else
    {
      // aaa | Dmytro : tabs are removed
      // aaa : not clear. explain during call
      let last = _.nothing;
      self.reduce( ( a, e2 ) => _.entity.equal( e2, e, onEvaluate1, onEvaluate2 ) ? last = e2 : undefined );
      _.assert( last !== _.nothing );
      container.delete( last );
      return last;
    }
  }
  popStrictly( e, onEvaluate1, onEvaluate2 )
  {
    let last = this.last();
    _.assert( 1 <= arguments.length && arguments.length <= 3 );
    _.assert( _.entity.equal( last, e, onEvaluate1, onEvaluate2 ), 'Set does not have such an element' );

    this.original.delete( last );
    return last;
  }
  removed( e, onEvaluate1, onEvaluate2 )
  {
    if( onEvaluate1 || _.routine.is( onEvaluate2 ) )
    {
      let from = 0;
      let result = 0;
      if( _.number.is( onEvaluate1 ) )
      {
        from = onEvaluate1;
        onEvaluate1 = onEvaluate2;
        onEvaluate2 = undefined;
      }

      for( let v of this.original )
      {
        if( from === 0 )
        {
          if( _.entity.equal( v, e, onEvaluate1, onEvaluate2 ) )
          {
            this.original.delete( v );
            result++;
          }
        }
        else
        {
          from--;
        }
      }

      return result;
    }
    else
    {
      return this.original.delete( e ) ? 1 : 0;
    }
  }
  removedOnce( e, onEvaluate1, onEvaluate2 )
  {
    let from = 0;
    let index = -1;

    if( _.number.is( onEvaluate1 ) )
    {
      from = onEvaluate1;
      onEvaluate1 = onEvaluate2;
      onEvaluate2 = undefined;
    }

    for( let v of this.original )
    {
      if( from === 0 )
      {
        if( _.entity.equal( v, e, onEvaluate1, onEvaluate2 ) )
        {
          this.original.delete( v );
          return ++index;
        }
      }
      else
      {
        from--;
      }
      index++;
    }
    return -1;
  }
  removedOnceLeft( e, onEvaluate1, onEvaluate2 )
  {
    return this.removedOnce.apply( this, arguments );
  }
  removedOnceRight( e, onEvaluate1, onEvaluate2 )
  {
    let temp = [ ... this.original ];
    let to = this.length;
    if( _.number.is( onEvaluate1 ) )
    {
      to = onEvaluate1;
      onEvaluate1 = onEvaluate2;
      onEvaluate2 = undefined;
    }

    for( let i = to - 1; i >= 0; i-- )
    {
      if( _.entity.equal( temp[ i ], e, onEvaluate1, onEvaluate2 ) )
      {
        this.original.delete( temp[ i ] );
        return i;
      }
    }
    return -1;
  }
  removedOnceStrictly( e, onEvaluate1, onEvaluate2 )
  {
    let from = 0;
    let index = -1;
    let result;

    if( _.number.is( onEvaluate1 ) )
    {
      from = onEvaluate1;
      onEvaluate1 = onEvaluate2;
      onEvaluate2 = undefined;
    }

    for( let v of this.original )
    {
      if( from === 0 )
      {
        if( _.entity.equal( v, e, onEvaluate1, onEvaluate2 ) )
        {
          if( result === undefined )
          {
            this.original.delete( v );
            result = index + 1;
          }
          else
          {
            _.assert( 0, () => 'The element ' + _.entity.exportStringDiagnosticShallow( e ) + ' is several times in dstArray' );
          }
        }
      }
      else
      {
        from--;
      }
      index++;
    }

    _.assert( result !== undefined, 'Container does not have such an element' );
    return result;
  }
  removedOnceStrictlyLeft( e, onEvaluate1, onEvaluate2 )
  {
    return this.removedOnceStrictly.apply( this, arguments );
  }
  removedOnceStrictlyRight( e, onEvaluate1, onEvaluate2 )
  {
    let to = this.length;
    let temp = [ ... this.original ];
    let result;

    if( _.number.is( onEvaluate1 ) )
    {
      to = onEvaluate1;
      onEvaluate1 = onEvaluate2;
      onEvaluate2 = undefined;
    }

    for( let i = to - 1; i >= 0; i-- )
    {
      if( _.entity.equal( temp[ i ], e, onEvaluate1, onEvaluate2 ) )
      {
        if( result === undefined )
        {
          this.original.delete( temp[ i ] );
          result = i;
        }
        else
        {
          _.assert( 0, () => 'The element ' + _.entity.exportStringDiagnosticShallow( e ) + ' is several times in dstArray' )
        }
      }
    }
    _.assert( result !== undefined, 'Container does not have such an element' );
    return result;
  }
  remove( e, onEvaluate1, onEvaluate2 )
  {
    this.removed.apply( this, arguments );
    return this;
  }
  removeOnce( e, onEvaluate1, onEvaluate2 )
  {
    this.removedOnce.apply( this, arguments );
    return this;
  }
  removeOnceLeft( e, onEvaluate1, onEvaluate2 )
  {
    this.removedOnceLeft.apply( this, arguments );
    return this;
  }
  removeOnceRight( e, onEvaluate1, onEvaluate2 )
  {
    this.removedOnceRight.apply( this, arguments );
    return this;
  }
  removeOnceStrictly( e, onEvaluate1, onEvaluate2 )
  {
    this.removedOnceStrictly.apply( this, arguments );
    return this;
  }
  removeOnceStrictlyLeft( e, onEvaluate1, onEvaluate2 )
  {
    this.removedOnceStrictlyLeft.apply( this, arguments );
    return this;
  }
  removeOnceStrictlyRight( e, onEvaluate1, onEvaluate2 )
  {
    this.removedOnceStrictlyRight.apply( this, arguments );
    return this;
  }
  empty()
  {
    this.original.clear();
  }
  map( dst, onEach )
  {
    let self = this;
    let container = self.original;
    [ dst, onEach ] = self._filterArguments( ... arguments );
    let length = self.length;
    let index = -1;

    if( self._same( dst ) )
    {
      for( let e of container )
      {
        index += 1;
        if( index === length )
        break;

        let e2 = onEach( e, index, container );
        container.delete( e );
        if( e2 !== undefined && e !== e2 )
        container.add( e2 );
        else
        container.add( e );
      }
    }
    else
    {
      for( let e of container )
      {
        index += 1;
        let e2 = onEach( e, index, self );
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
    let self = this;
    let container = self.original;
    let temp = [ ... container ];
    [ dst, onEach ] = self._filterArguments( ... arguments );

    if( this._same( dst ) )
    {
      for( let i = temp.length - 1; i >= 0; i-- )
      {
        let e2 = onEach( temp[ i ], i, container );
        if( e2 !== undefined && temp[ i ] !== e2 )
        temp[ i ] = e2;
      }
      self.empty();
      temp.forEach( ( e ) => self.push( e ) )
    }
    else
    {
      for( let i = temp.length - 1; i >= 0; i-- )
      {
        let e2 = onEach( temp[ i ], i, self );
        if( e2 !== undefined )
        dst.append( e2 );
        else
        dst.append( temp[ i ] );
      }
    }

    return dst;
  }
  filter( dst, onEach )
  {
    let self = this;
    let container = self.original;
    [ dst, onEach ] = self._filterArguments( ... arguments );
    let length = self.length;
    let index = -1;

    if( self._same( dst ) )
    {

      for( let e of container )
      {
        index += 1;
        if( index === length )
        break;

        let e2 = onEach( e, index, container );

        if( e2 === undefined )
        {
          container.delete( e );
        }
        else if( e !== e2 )
        {
          container.add( e2 );
          container.delete( e );
        }
        else
        {
          container.add( e );
        }
      }
    }
    else
    {
      for( let e of container )
      {
        index += 1;
        let e2 = onEach( e, index, self );
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
    let container = self.original;
    let temp = [ ... container ];
    [ dst, onEach ] = self._filterArguments( ... arguments );

    if( self._same( dst ) )
    {
      for( let i = temp.length - 1; i >= 0; i-- )
      {
        let e2 = onEach( temp[ i ], i, container );
        if( e2 === undefined )
        temp.splice( i, 1 );
        else if( temp[ i ] !== e2 )
        temp[ i ] = e2;
      }
      self.empty();
      temp.forEach( ( e ) => self.push( e ) );
    }
    else
    {
      for( let i = temp.length - 1; i >= 0; i-- )
      {
        let e2 = onEach( temp[ i ], i, self );
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
    let length = container.size;
    let index = -1;

    if( self._same( dst ) )
    {
      for( let e of container )
      {
        index += 1;
        if( index === length )
        break;

        let e2 = onEach( e, index, self );
        self.remove( e );

        if( self.IsContainer( e2 ) || self.Is( e2 ) )
        self.appendContainer( e2 );
        else if( e2 !== undefined )
        self.append( e2 )
        else if( e2 === e && e !== undefined )
        self.append( e );
      }
    }
    else
    {
      for( let e of container )
      {
        index += 1;
        let e2 = onEach( e, index, self );

        if( self.IsContainer( e2 ) || self.Is( e2 ) )
        dst.appendContainer( e2 );
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
    let temp = [ ... container ];
    [ dst, onEach ] = self._filterArguments( ... arguments );
    let length = container.size;
    let index = -1;

    if( self._same( dst ) )
    {
      for( let i = temp.length - 1; i >= 0; i-- )
      {
        let e2 = onEach( temp[ i ], i, self );

        if( self.IsContainer( e2 ) || self.Is( e2 ) )
        temp.splice( i, 1, ... e2 );
        else if( e2 !== undefined && e2 !== temp[ i ] )
        temp[ i ] = e2;
        else if( e2 === undefined )
        temp.splice( i, 1 );
        self.empty();
        temp.forEach( ( e ) => self.push( e ) );
      }
    }
    else
    {
      for( let i = temp.length - 1; i >= 0; i-- )
      {
        let e2 = onEach( temp[ i ], i, self );

        if( self.IsContainer( e2 ) || self.Is( e2 ) )
        dst.appendContainer( e2 );
        else if( e2 !== undefined )
        dst.append( e2 );
      }
    }
    return dst;
  }
  once( dst, onEvaluate1, onEvaluate2 )
  {
    let self = this;
    let container = self.original;
    [ dst, dst, onEvaluate1, onEvaluate2 ] = self._onlyArguments( null, dst, onEvaluate1, onEvaluate2 );
    if( self._same( dst ) )
    {
      if( onEvaluate1 || _.routine.is( onEvaluate2 ) )
      {
        let length = this.length;
        let startLength = length;
        for( let e of container )
        {
          if( length === startLength )
          {
            self.append( e );
            length--;
          }
          else if( length !== 0 )
          {
            self.remove( e );
            self.appendOnce( e, onEvaluate1, onEvaluate2 )
            length--;
          }
        }
      }
    }
    else
    {
      dst.appendContainerOnce( container, onEvaluate1, onEvaluate2 );
    }

    return dst;
  }
  onceLeft( dst, onEvaluate1, onEvaluate2 )
  {
    return this.once.apply( this, arguments );
  }
  onceRight( dst, onEvaluate1, onEvaluate2 )
  {
    let self = this;
    let container = self.original;
    let temp = [ ... container ];
    [ dst, dst, onEvaluate1, onEvaluate2 ] = self._onlyArguments( null, dst, onEvaluate1, onEvaluate2 );
    if( self._same( dst ) )
    {
      if( onEvaluate1 || _.routine.is( onEvaluate2 ) )
      {
        self.empty();
        for( let i = 0; i < temp.length; i++ )
        self.appendOnce( temp[ i ], onEvaluate1, onEvaluate2 );
      }
    }
    else
    {
      for( let i = temp.length - 1; i >= 0; i-- )
      dst.appendOnce( temp[ i ], onEvaluate1, onEvaluate2 );
    }

    return dst;
  }
  withIndex( index )
  {
    let self = this;
    return [ ... self.original ][ index ];
  }
  first( onEach )
  {
    let self = this;
    let container = this.original;
    if( !container.size )
    return undefined;
    if( onEach )
    for( let e of container )
    {
      return onEach( e, 0, self );
    }
    else
    {
      for( let e of container )
      {
        return e;
      }
    }
  }
  last( onEach )
  {
    let last = this.reduce( ( a, e ) => e );
    if( onEach )
    return onEach( last, this.length - 1, this );
    else
    return last;
  }
  each( onEach )
  {
    return this.eachLeft( onEach );
  }
  eachLeft( onEach )
  {
    let self = this;
    let container = self.original;
    let index = -1;
    for( let e of container )
    {
      index += 1;
      onEach( e, index, self );
    }
    return self;
  }
  eachRight( onEach )
  {
    let self = this;
    let container = self.original;
    let temp = [ ... container ];
    for( let i = temp.length - 1; i >= 0; i-- )
    onEach( temp[ i ], i, self );
    return self;
  }
  reduce( accumulator, onEach )
  {
    let self = this;
    let container = self.original;
    if( arguments[ 1 ] === undefined )
    {
      onEach = arguments[ 0 ];
      accumulator = undefined;
    }
    let index = -1;
    for( let e of container )
    {
      index += 1;
      accumulator = onEach( accumulator, e, index, self );
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
    let container = self.original;
    let temp = [ ... container ];
    if( arguments[ 1 ] === undefined )
    {
      onEach = arguments[ 0 ];
      accumulator = undefined;
    }
    for( let i = temp.length - 1; i >= 0; i-- )
    {
      accumulator = onEach( accumulator, temp[ i ], i, self );
    }
    return accumulator;
  }
  all( onEach )
  {
    return this.allLeft( onEach );
  }
  allLeft( onEach )
  {
    let self = this;
    let container = self.original;
    let index = -1;
    for( let e of container )
    {
      index += 1;
      let r = onEach( e, index, self );
      if( !r )
      return false;
    }
    return true;
  }
  allRight( onEach )
  {
    let self = this;
    let container = this.original;
    let temp = [ ... container ];
    for( let k = temp.length - 1; k >= 0; k-- )
    {
      let r = onEach( temp[ k ], k, self );
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
    let self = this;
    let container = self.original;
    let index = -1;
    for( let e of container )
    {
      index += 1;
      let r = onEach( e, index, self );
      if( r )
      return true;
    }
    return false;
  }
  anyRight( onEach )
  {
    let self = this;
    let container = self.original;
    let temp = [ ... container ];
    for( let k = temp.length - 1; k >= 0; k-- )
    {
      let r = onEach( temp[ k ], k, self );
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
    let self = this;
    let container = self.original;
    let index = -1;
    for( let e of container )
    {
      index += 1;
      let r = onEach( e, index, self );
      if( r )
      return false;
    }
    return true;
  }
  noneRight( onEach )
  {
    let self = this;
    let container = self.original;
    let temp = [ ... container ];
    for( let k = temp.length - 1; k >= 0; k-- )
    {
      let r = onEach( temp[ k ], k, self );
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
    return _.arraySet.left( this.original, element, fromIndex, onEvaluate1, onEvaluate2 );
  }
  right( /* element, fromIndex, onEvaluate1, onEvaluate2 */ )
  {
    let element = arguments[ 0 ];
    let fromIndex = arguments[ 1 ];
    let onEvaluate1 = arguments[ 2 ];
    let onEvaluate2 = arguments[ 3 ];

    _.assert( 1 <= arguments.length && arguments.length <= 4 );
    return _.arraySet.right( this.original, element, fromIndex, onEvaluate1, onEvaluate2 );
  }
  reverse( dst )
  {

    let self = this;
    let container = self.original;
    let temp = [ ... container ];

    if( !dst )
    dst = this.MakeEmpty();
    else
    dst = this.From( dst );

    if( self._same( dst ) )
    {
      self.empty();
      for( let i = temp.length - 1; i >= 0; i-- )
      self.append( temp[ i ] );
    }
    else
    {
      for( let i = temp.length - 1; i >= 0; i-- )
      dst.append( temp[ i ] );
    }

    return dst;
  }
  join( delimeter )
  {
    return [ ... this.original ].join( delimeter );
  }
  toArray()
  {
    return new _.containerAdapter.Array( [ ... this.original ] );
  }
  toSet()
  {
    return this;
  }
  [ Symbol.iterator ]()
  {
    let container = this.original;
    return container[ Symbol.iterator ]();
  }
  get length()
  {
    return this.original.size;
  }
}
ContainerAdapterSet.Make = Make;
ContainerAdapterSet.MakeEmpty = MakeEmpty;
ContainerAdapterSet.prototype.make = make;
ContainerAdapterSet.prototype.MakeEmpty = makeEmpty;

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

  Set : ContainerAdapterSet,

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

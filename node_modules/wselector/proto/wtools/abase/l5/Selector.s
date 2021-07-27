( function _Selector_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to select a sub-structure from a complex data structure. Use the module to transform a data structure with the help of a short selector string.
  @module Tools/base/Selector
*/

/**
 * Collection of cross-platform routines to select a sub-structure from a complex data structure.
  @namespace Tools.selector
  @extends Tools
  @module Tools/base/Selector
*/

/* Problems :

zzz qqq : optimize
qqq : cover select with glob using test routine filesFindGlob of test suite FilesFind.Extract.test.s. ask how

qqq : write nice example for readme

qqq xxx : does not work
__.select( module.files, '* / sourcePath' )
and
__.select( module.files.values(), '* / sourcePath' )
where module.files is hash map

xxx : qqq : implement _.selector.isQuery()
xxx : qqq : move _.selector.isQuery() to module::Tools?

*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  _.include( 'wLooker' );
  _.include( 'wReplicator' );
  _.include( 'wPathTools' );
}

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.looker.Looker;
_.selector = _.selector || Object.create( _.looker );
_.selector.functor = _.selector.functor || Object.create( null );


_.assert( !!_realGlobal_ );
_.assert( !!Parent );

// --
// relations
// --

let Prime = Object.create( null );

// Prime.src = null;
Prime.selector = null;
Prime.missingAction = 'undefine';
Prime.preservingIteration = 0;
Prime.globing = 1;
Prime.revisiting = 2;
Prime.upToken = '/';
Prime.downToken = '..';
Prime.hereToken = '.';
Prime.visited = null;
Prime.set = null;
// Prime.setting = null;
Prime.action = null;
Prime.creating = null;
Prime.onUpBegin = null;
Prime.onUpEnd = null;
Prime.onDownBegin = null;
Prime.onDownEnd = null;
Prime.onQuantitativeFail = null;
Prime.onSelectorUndecorate = null;

let Action = Object.create( null );
Action.no = 0;
Action.set = 1;
Action.del = 2;
Action.last = 2;

// --
// extend looker
// --

function head( routine, args )
{
  _.assert( arguments.length === 2 );
  let o = routine.defaults.Seeker.optionsFromArguments( args );
  o.Seeker = o.Seeker || routine.defaults;
  _.assert( _.routineIs( routine ) || _.auxIs( routine ) );
  if( _.routineIs( routine ) ) /* zzz : remove "if" later */
  _.map.assertHasOnly( o, routine.defaults );
  else if( routine !== null )
  _.map.assertHasOnly( o, routine );
  let it = o.Seeker.optionsToIteration( null, o );
  return it;
}

//

function optionsFromArguments( args )
{
  let o = args[ 0 ];

  if( args.length === 2 )
  {
    o = { src : args[ 0 ], selector : args[ 1 ] }
  }

  _.assert( args.length === 1 || args.length === 2 );
  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );

  return o;
}

//

function optionsToIteration( iterator, o )
{
  let it = Parent.optionsToIteration.call( this, iterator, o );
  _.assert( arguments.length === 2 );
  _.assert( it.absoluteLevel === null );
  it.absoluteLevel = 0;
  _.assert( Object.hasOwnProperty.call( it.iterator, 'selector' ) );
  // _.assert( Object.hasOwnProperty.call( Object.getPrototypeOf( it ), 'selector' ) );
  return it;
}

//

function iteratorInitEnd( iterator )
{
  let looker = this;

  _.assert( iterator.iteratorProper( iterator ) );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( iterator.selector ) );
  _.assert( _.strIs( iterator.downToken ) );
  _.assert( _.strIs( iterator.hereToken ) );
  /* xxx : optimize */
  _.assert
  (
    _.longHas( [ 'undefine', 'ignore', 'throw', 'error' ], iterator.missingAction )
    , () => `Unknown missing action ${iterator.missingAction}`
  );
  _.assert( iterator.it === undefined );

  // if( iterator.setting === null && iterator.set !== null )
  // iterator.setting = 1;
  if( iterator.action === null )
  iterator.action = iterator.set === null ? iterator.Action.no : iterator.Action.set;
  if( iterator.creating === null )
  iterator.creating = iterator.action === iterator.Action.set;
  // iterator.creating = !!iterator.setting;

  _.assert( _.numberIs( iterator.action ) && iterator.action <= iterator.Action.last );

  return Parent.iteratorInitEnd.call( this, iterator );
}

//

function reperformIt()
{
  let it = this;

  _.assert( arguments.length === 1 );
  _.assert( it.selector !== null, () => `Iteration is not looked` );
  _.assert
  (
    it.iterationProper( it ),
    () => `Expects iteration of ${Self.constructor.name} but got ${_.entity.exportStringDiagnosticShallow( it )}`
  );

  let it2 = it.iterationMake();
  let args = _.longSlice( arguments );
  if( args.length === 1 && !_.object.isBasic( args[ 0 ] ) )
  args = [ it.src, args[ 0 ] ];
  let o = Self.optionsFromArguments( args );
  o.Seeker = o.Seeker || it.Seeker || Self;

  _.assert( _.mapIs( o ) );
  _.map.assertHasOnly( o, { src : null, selector : null, Seeker : null }, 'Implemented only for options::selector' );
  _.assert( _.strIs( o.selector ) );
  _.assert( _.strIs( it2.iterator.selector ) );

  it2.iterator.selector = it2.iterator.selector + _.strsShortest( it2.iterator.upToken ) + o.selector;
  it2.iteratorSelectorChanged();
  it2.chooseRoot();
  it2.iterate();
  /* qqq : call perform here? */

  return it2.lastIt;
}

//

function reperform( o )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let it2 = it.reperformIt( o );

  return it2.dst;
}

//

function performBegin()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( Object.hasOwnProperty.call( it.iterator, 'selector' ) );
  // _.assert( Object.hasOwnProperty.call( Object.getPrototypeOf( it ), 'selector' ) );
  _.assert( _.intIs( it.iterator.selector ) || _.strIs( it.iterator.selector ) );
  _.assert( !!it.upToken );
  _.assert( it.iterationProper( it ) );

  it.iteratorSelectorChanged();

  Parent.performBegin.apply( it, arguments );

  _.assert( it.state === 0 );
  it.iterator.state = 1;

}

//

function performEnd()
{
  let it = this;

  _.assert( it.state === 1 );
  it.iterator.state = 2;

  it.iterator.originalResult = it.dst;

  if( it.missingAction === 'error' && it.error )
  {
    it.result = it.error;
    return it;
  }

  it.iterator.result = it.originalResult;

  _.assert( it.error === null || it.error === true );

  Parent.performEnd.apply( it, arguments );
  return it;
}

//

function iterationMake()
{
  let it = this;
  let newIt = Parent.iterationMake.call( it );
  newIt.dst = undefined;
  return newIt;
}

//

function iterableEval()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.strIs( it.selectorType ) );

  if( it.selectorType === 'down' )
  {
    it.iterable = it.ContainerType.down;
  }
  else if( it.selectorType === 'here' )
  {
    it.iterable = it.ContainerType.here;
  }
  else if( it.selectorType === 'terminal' )
  {
    it.iterable = 0;
  }
  else if( it.selectorType === 'glob' )
  {

    /* xxx : custom? */
    if( _.longLike( it.src ) )
    {
      it.iterable = it.ContainerType.countable;
    }
    else if( _.object.isBasic( it.src ) )
    {
      it.iterable = it.ContainerType.aux;
    }
    else if( _.hashMapLike( it.src ) )
    {
      it.iterable = it.ContainerType.hashMap;
    }
    else if( _.setLike( it.src ) )
    {
      it.iterable = it.ContainerType.set;
    }
    else
    {
      it.iterable = 0;
    }

  }
  else
  {
    it.iterable = it.ContainerType.single;
  }

  _.assert( it.iterable >= 0 );
}

//

function selectorIsCardinal( src )
{
  let it = this;
  if( !_.strIs( src ) )
  return false;
  if( !_.strBegins( src, it.cardinalDelimeter ) )
  return false;
  return true;
}

//

function selectorCardinalParse( src )
{
  let it = this;
  if( !it.selectorIsCardinal( src ) )
  return false;
  let result = Object.create( null );
  result.str = _.strRemoveBegin( src, it.cardinalDelimeter );
  result.number = _.numberFromStrMaybe( result.str );
  if( !_.numberIs( result.number ) )
  return false;
  return result;
}

//

function elementGet( e, k, c )
{
  let it = this;
  let result;

  _.assert( arguments.length === 3 );

  _.debugger;
  let q = it.selectorCardinalParse( k );
  if( q )
  {
    result = _.entity.elementWithCardinal( e, q.number ); /* xxx : use maybe functor */
    return [ result[ 0 ], result[ 1 ], q.number, result[ 2 ] ];
  }
  else
  {
    result = _.entity.elementWithImplicit( e, k ); /* xxx : use maybe functor */
    if( c === null )
    c = _.container.cardinalWithKey( e, k );
    return [ result[ 0 ], result[ 1 ], c, result[ 2 ] ];
  }

}

//

function chooseBegin()
{
  let it = this;
  let e = arguments[ 0 ];
  let k = arguments[ 1 ];
  let c = arguments[ 2 ];
  let exists = arguments[ 3 ];

  [ e, k, c, exists ] = Parent.chooseBegin.call( it, ... arguments );

  // _.assert( arguments.length === 4, 'Expects three argument' );
  // _.assert( !!it.down );

  if( !it.fast )
  {
    it.absoluteLevel = it.down.absoluteLevel+1;
  }

  return [ e, k, c, exists ];
}

//

function chooseEnd()
{
  let it = this;
  let e = arguments[ 0 ];
  let k = arguments[ 1 ];
  let c = arguments[ 2 ];
  let exists = arguments[ 3 ];

  // _.assert( arguments.length === 4 );
  // _.assert( _.boolIs( exists ) || exists === null );

  it.exists = exists;
  it.selector = it.selectorArray[ it.level+1 ];
  it.iterationSelectorChanged();

  /* xxx : move out */
  if( it.creating )
  if( exists === false && k !== undefined && it.selectorType !== 'terminal' )
  if( it.down )
  {
    e = it.containerMake();
    it.down.srcWriteDown( e, k, c );
    it.exists = true;
  }

  let result = Parent.chooseEnd.call( it, e, k, c, exists );

  _.assert( _.boolIs( it.exists ) );

  if( it.exists === false )
  if( it.action === it.Action.no || ( it.action === it.Action.set && it.selectorType !== 'terminal' ) )
  {
    it.errDoesNotExistHandle();
  }

  it.srcChanged();
  it.revisitedEval( it.originalSrc );

  return [ e, k, c, exists ];
}

//

function chooseRoot()
{
  let it = this;

  _.assert( arguments.length === 0 );

  it.exists = true;
  it.selector = it.selectorArray[ it.level ];
  it.iterationSelectorChanged();

  return Parent.chooseRoot.call( it );
}

//

function containerMake()
{
  let it = this;
  return Object.create( null );
}

//

function iteratorSelectorChanged()
{
  let it = this;

  if( _.intIs( it.iterator.selector ) )
  it.iterator.selectorArray = [ it.iterator.selector ];
  else
  it.iterator.selectorArray = split( it.iterator.selector );

  /* */

  function split( selector )
  {
    let splits = _.strSplit
    ({
      src : selector,
      delimeter : it.upToken,
      preservingDelimeters : 0,
      preservingEmpty : 1,
      preservingQuoting : 0,
      stripping : 1,
    });

    if( _.strBegins( selector, it.upToken ) )
    splits.splice( 0, 1 );
    if( _.strEnds( selector, it.upToken ) )
    splits.pop();

    return splits;
  }

}

//

function iterationSelectorChanged()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( it.originalSelector === null )
  it.originalSelector = it.selector;

  if( it.selector !== undefined )
  if( it.onSelectorUndecorate )
  {
    it.onSelectorUndecorate();
  }

  /* xxx : move out and use it in ResolverAdv */

  if( it.selector === it.downToken )
  it.selectorType = 'down';
  else if( it.selector === it.hereToken )
  it.selectorType = 'here';
  else if( it.selector === undefined || it.selector === '/' )
  it.selectorType = 'terminal';

  if( it.globing && it.selector && it.selectorType === null )
  {

    let selectorIsGlob;
    if( _.path && _.path.selectorIsGlob )
    selectorIsGlob = function( selector )
    {
      return _.path.selectorIsGlob( selector )
    }
    else
    selectorIsGlob = function selectorIsGlob( selector )
    {
      return _.strHas( selector, '*' );
    }

    if( selectorIsGlob( it.selector ) )
    it.selectorType = 'glob';

  }

  if( it.selectorType === null )
  it.selectorType = 'single';

}

//

function globParse()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !!it.globing );

  let regexp = /(.*){?\*=(\d*)}?(.*)/;
  let match = it.selector.match( regexp );
  it.parsedSelector = it.parsedSelector || Object.create( null );

  if( match )
  {
    _.sure( _.strCount( it.selector, '=' ) <= 1, () => 'Does not support selector with several assertions, like ' + _.strQuote( it.selector ) );
    it.parsedSelector.glob = match[ 1 ] + '*' + match[ 3 ];
    if( match[ 2 ].length > 0 )
    {
      it.parsedSelector.limit = _.numberFromStr( match[ 2 ] );
      _.sure( !isNaN( it.parsedSelector.limit ) && it.parsedSelector.limit >= 0, () => 'Epects non-negative number after "=" in ' + _.strQuote( it.selector ) );
    }

  }
  else
  {
    it.parsedSelector.glob = it.selector;
  }

}

//

function errNoDown()
{
  let it = this;
  let err = this.errMake
  (
    'Cant go down', _.strQuote( it.selector ),
    '\nbecause', _.strQuote( it.selector ), 'does not exist',
    '\nat', _.strQuote( it.path ),
    '\nin container\n', _.entity.exportStringDiagnosticShallow( it.src )
  );
  return err;
}

//

function errNoDownHandle()
{
  let it = this;
  it.errHandle( () => it.errNoDown() );
}

//

function errCantSet()
{
  let it = this;
  let err = _.err
  (
    `Cant set ${it.key}`
  );
  return err;
}

//

function errCantSetHandle()
{
  let it = this;
  it.errHandle( () => it.errCantSet() );
}

//

function errDoesNotExist()
{
  let it = this;
  if( it.down )
  {
    return this.errMake
    (
      `Cant select ${it.iterator.selector} from ${_.entity.exportStringDiagnosticShallow( it.down.originalSrc )}`,
      `\n  because ${_.entity.exportStringDiagnosticShallow( it.down.originalSelector )} does not exist`,
      `\n  fall at ${_.strQuote( it.path )}`,
    );
  }
  else
  {
    return this.errMake
    (
      `Cant select ${it.iterator.selector} from ${_.entity.exportStringDiagnosticShallow( it.originalSrc )}`,
      `\n  because ${_.entity.exportStringDiagnosticShallow( it.originalSelector )} does not exist`,
      `\n  fall at ${_.strQuote( it.path )}`,
    );
  }
}

//

function errDoesNotExistHandle()
{
  let it = this;
  it.errHandle( () => it.errDoesNotExist() );
}

//

function errHandle( err )
{
  let it = this;
  it.continue = false;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( err ) || _.errIs( err ) );

  // debugger;

  if( it.missingAction === 'undefine' || it.missingAction === 'ignore' )
  {
    it.iterator.error = true;
    if( it.missingAction === 'undefine' )
    it.dst = undefined;
  }
  else
  {
    it.dst = undefined;
    if( !it.iterator.error || it.iterator.error === true )
    it.iterator.error = errMake();
    if( it.missingAction === 'throw' )
    {
      debugger; /* eslint-disable-line no-debugger */
      // console.log( `errHandle.1 attended:${it.iterator.error.attended}` );
      throw it.iterator.error;
    }
  }

  function errMake()
  {
    if( _.routineIs( err ) )
    return err();
    return err;
  }

}

//

function visitUp()
{
  let it = this;

  it.visitUpBegin();

  if( it.onUpBegin )
  it.onUpBegin.call( it );

  if( it.dstWritingDown )
  {

    if( it.selectorType === 'terminal' )
    it.terminalUp();
    else if( it.selectorType === 'down' )
    it.downUp();
    else if( it.selectorType === 'glob' )
    it.globUp();
    else
    it.singleUp();

  }

  if( it.onUpEnd )
  it.onUpEnd.call( it );

  /* */

  _.assert( it.visiting );
  _.assert( _.routineIs( it.onUp ) );
  let r = it.onUp.call( it, it.src, it.key, it );
  _.assert( r === undefined );

  it.visitUpEnd()

}

//

function visitUpBegin()
{
  let it = this;

  it.ascending = true;

  _.assert( it.visiting );

  it.dstWriteDownAct = function dstWriteDownAct( eit )
  {
    it.dst = eit.dst;
  }

  return Parent.visitUpBegin.apply( it, ... arguments );
}

//

function visitDown()
{
  let it = this;

  it.visitDownBegin();

  if( it.onDownBegin )
  it.onDownBegin.call( it );

  if( it.selectorType === 'terminal' )
  it.terminalDown();
  else if( it.selectorType === 'down' )
  it.downDown();
  else if( it.selectorType === 'glob' )
  it.globDown();
  else
  it.singleDown();

  it.downSet();

  if( it.onDownEnd )
  it.onDownEnd.call( it );

  /* */

  _.assert( it.visiting );
  if( it.onDown )
  {
    let r = it.onDown.call( it, it.src, it.key, it );
    _.assert( r === undefined );
  }

  it.visitDownEnd();

  /* */

  if( it.down )
  {
    // _.assert( _.routineIs( it.down.dstWriteDown ) );
    if( it.dstWritingDown )
    it.down.dstWriteDown( it );
  }

}

// //
//
// function performSet()
// {
//   let it = this;
//   let it2 = it;
//
//   if( !!it2.action && it2.selectorType === 'terminal' )
//   {
//     /* qqq2 : implement and cover for all type of containers */
//     if
//     (
//       it2.down
//       && !_.primitiveIs( it2.down.src )
//       && it2.key !== undefined
//     )
//     {
//       if( it2.action === it2.Action.del )
//       delete it2.down.src[ it2.key ];
//       else
//       it2.down.src[ it2.key ] = it2.set;
//       /* zzz : introduce method writeDown */
//     }
//     else
//     {
//       it2.errCantSetHandle();
//     }
//   }
//
// }

//

function downSet()
{
  let it = this;

  if( !!it.action && it.selectorType === 'terminal' )
  {
    // _.debugger;
    /* qqq2 : implement and cover for all type of containers */
    if
    (
      it.down
      && !_.primitiveIs( it.down.src )
      && it.key !== undefined
    )
    {
      // debugger;
      if( it.action === it.Action.del )
      // delete it.down.src[ it.key ];
      it.down.srcDel( it.set, it.key, it.cardinal );
      else
      it.down.srcWriteDown( it.set, it.key, it.cardinal );
      // it.down.src[ it.key ] = it.set;
    }
    else
    {
      it.errCantSetHandle();
    }
  }

}

//

/* xxx : merge src/dst writeDown? */

function srcDel( e, k, c )
{
  let it = this;
  let r;

  // r = _.entity.elementDel( it.src, k, e ); /* Dmytro : element*Del accept only 2 arguments : src and key */

  /* Dmytro : implementation that use flag `cardinal` */
  // if( c )
  // r = _.entity.elementWithCardinalDel( it.src, k );
  // else
  // r = _.entity.elementDel( it.src, k );
  r = _.entity.elementDel( it.src, k );

  if( r === false )
  {
    it.errCantSetHandle();
  }

}

//

/* xxx : merge src/dst writeDown? */

function srcWriteDown( e, k, c )
{
  let it = this;
  let r;

  let selectorIsCardinal = _.numberIs( k ) && it.selectorIsCardinal( it.selector );
  if( selectorIsCardinal )
  r = _.entity.elementWithCardinalSet( it.src, k, e );
  else
  r = _.entity.elementSet( it.src, k, e );

  if( r[ 1 ] === false )
  {
    it.errCantSetHandle();
  }

  // if( it._srcWriteDownMethod === null )
  // {
  //   let selectorIsCardinal = _.numberIs( k ) && it.selectorIsCardinal( it.selector );
  //   if( selectorIsCardinal )
  //   it._srcWriteDownMethod = _.entity.elementWithCardinalSet.functor.call( _.container, it.src );
  //   else
  //   it._srcWriteDownMethod = _.entity.elementSet.functor.call( _.container, it.src );
  // }
  //
  // let r = it._srcWriteDownMethod( k, e );
  //
  // if( r[ 2 ] === false )
  // {
  //   it.errCantSetHandle();
  // }

}

//

function dstWriteDown( eit )
{
  let it = this;
  _.assert( _.routineIs( it.dstWriteDownAct ) );
  if( eit.dst === undefined )
  if( it.missingAction === 'ignore' )
  return;
  let val = eit.dst;
  if( it.preservingIteration ) /* qqq : cover the option. seems it does not work in some cases */
  val = eit;
  return it.dstWriteDownAct( eit, val );
  // return it.ContainerTypeToDstWriteDownMap[ it.iterable ]( eit, val );
}

//

function dstWriteDownLong( eit, val )
{
  let it = this;
  it.dst.push( val );
}

//

function dstWriteDownAux( eit, val )
{
  let it = this;
  it.dst[ eit.key ] = val;
}

//

function dstWriteDownHashMap( eit, val )
{
  let it = this;
  it.dst.set( eit.key, val );
}

//

function dstWriteDownSet( eit, val )
{
  let it = this;
  it.dst.add( val );
}

//

function makeEmptyLong()
{
  let it = this;
  return [];
}

//

function makeEmptyAux()
{
  let it = this;
  return Object.create( null );
}

//

function makeEmptyHashMap()
{
  let it = this;
  return new HashMap();
}

//

function makeEmptySet( eit, val )
{
  let it = this;
  return new Set();
}

//

function downUp()
{
  let it = this;

  _.assert( it.selectorType === 'down' );

}

//

function downDown()
{
  let it = this;
}

//

function downAscend()
{
  let it = this;
  let counter = 1;
  let dit = it;

  _.assert( arguments.length === 1 );

  while( counter > 0 )
  {
    dit = dit.down;
    if( !dit )
    return it.errNoDownHandle();
    if( dit.selectorType === 'down' )
    {
      counter += 1;
    }
    else if( dit.selectorType === 'here' )
    {
    }
    else if( dit.selectorType === 'terminal' )
    {
    }
    else if( dit.selectorType !== 'terminal' )
    {
      counter -= 1;
    }
  }

  _.assert( it.iterationProper( dit ) );

  it.visitPop();
  dit.visitPop();

  /* */

  let nit = it.iterationMake();

  nit.choose( dit.src, it.selector, null, true );
  _.assert( nit.src === dit.src );
  _.assert( nit.exists === true );

  _.assert( nit.dst === undefined );
  nit.dst = undefined;
  nit.absoluteLevel -= 2;

  nit.iterate();

  return true;
}

//

function hereUp()
{
  let it = this;

}

//

function hereDown()
{
  let it = this;

  it.dst = it.src;

}

//

function hereAscend()
{
  let it = this;

  let eit = it.iterationMake().choose( it.src, it.selector, null, true );
  eit.iterate();

}

//

function singleUp()
{
  let it = this;
}

//

function singleDown()
{
  let it = this;
}

//

function singleAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let eit = it.iterationMake().choose( undefined, it.selector, null, null );
  eit.iterate();

}

//

function terminalUp()
{
  let it = this;

  it.dst = it.src;

}

//

function terminalDown()
{
  let it = this;
}

//

function globUp()
{
  let it = this;

  _.assert( !!it.globing );

  /* qqq : teach it to parse more than single "*=" */

  if( it.globing )
  it.globParse();

  if( it.globing )
  if( it.parsedSelector.glob !== '*' )
  {
    if( it.iterable )
    {
      /* qqq : optimize for ** */
      it.src = _.path.globShortFilter
      ({
        src : it.src,
        selector : it.parsedSelector.glob,
        onEvaluate : ( e, k ) => k,
      });
      it.iterable = null;
      it.srcChanged();
    }
  }

  /* xxx : refactor */

  let makeEmpty = it.ContainerTypeToMakeEmptyMap[ it.iterable ];
  if( makeEmpty )
  {
    it.dst = makeEmpty.call( it );
    it.dstWriteDownAct = it.ContainerTypeToDstWriteDownMap[ it.iterable ];
  }
  else
  {
    it.errDoesNotExistHandle();
  }

}

//

function globDown()
{
  let it = this;

  if( !it.dstWritingDown )
  return;

  if( it.parsedSelector.limit === undefined )
  return;

  _.assert( !!it.globing );

  let length = _.entity.lengthOf( it.dst );
  if( length !== it.parsedSelector.limit )
  {
    let currentSelector = it.selector;
    if( it.parsedSelector && it.parsedSelector.full )
    currentSelector = it.parsedSelector.full;
    let err = _.looker.SeekingError
    (
      `Select constraint "${ currentSelector }" failed with ${ length } elements`
      + `\nSelector "${ it.iterator.selector }"`
      + `\nAt : "${ it.path }"`
    );
    debugger; /* eslint-disable-line no-debugger */
    if( it.onQuantitativeFail )
    it.onQuantitativeFail.call( it, err );
    else
    throw err;
  }

}

// --
// namespace
// --

function select_head( routine, args )
{
  return routine.defaults.head( routine, args );
}

//

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @description Returns iterator with result of selection
 * @param {*} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @example //select element with key 'a1'
 * let it = _.selectIt( { a1 : 1, a2 : 2 }, 'a1' );
 * console.log( it.dst )//1
 *
 * @example //select any that starts with 'a'
 * let it = _.select( { a1 : 1, a2 : 2 }, 'a*' );
 * console.log( it.dst ) // { a1 : 1, a2 : 1 }
 *
 * @example //select with constraint, only one element should be selected
 * let it = _.select( { a1 : 1, a2 : 2 }, 'a*=1' );
 * console.log( it.error ) // error
 *
 * @example //select with constraint, two elements
 * let it = _.select( { a1 : 1, a2 : 2 }, 'a*=2' );
 * console.log( it.dst ) // { a1 : 1, a2 : 1 }
 *
 * @example //select inner element using path selector
 * let it = _.select( { a : { b : { c : 1 } } }, 'a/b' );
 * console.log( it.dst ) //{ c : 1 }
 *
 * @example //select value of each property with name 'x'
 * let it = _.select( { a : { x : 1 }, b : { x : 2 }, c : { x : 3 } }, '*\/x' );
 * console.log( it.dst ) //{a: 1, b: 2, c: 3}
 *
 * @example // select root
 * let it = _.select( { a : { b : { c : 1 } } }, '/' );
 * console.log( it.dst )
 *
 * @function selectIt
 * @module Tools/base/Selector
 * @namespace Tools.selector
*/

function exec_head( routine, args )
{
  return routine.defaults.head( routine, args );
}

function exec_body( it )
{
  it.execIt.body.call( this, it );
  return it.result;
}

//

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @description Short-cur for {@link module:Tools/base/Selector.Tools.selector.select _.selectIt }. Returns found element(s) instead of iterator.
 * @param {*} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @example //select element with key 'a1'
 * _.select( { a1 : 1, a2 : 2 }, 'a1' ); // 1
 *
 * @example //select any that starts with 'a'
 * _.select( { a1 : 1, a2 : 2 }, 'a*' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select with constraint, only one element should be selected
 * _.select( { a1 : 1, a2 : 2 }, 'a*=1' ); // error
 *
 * @example //select with constraint, two elements
 * _.select( { a1 : 1, a2 : 2 }, 'a*=2' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select inner element using path selector
 * _.select( { a : { b : { c : 1 } } }, 'a/b' ); //{ c : 1 }
 *
 * @example //select value of each property with name 'x'
 * _.select( { a : { x : 1 }, b : { x : 2 }, c : { x : 3 } }, '*\/x' ); //{a: 1, b: 2, c: 3}
 *
 * @example // select root
 * _.select( { a : { b : { c : 1 } } }, '/' );
 *
 * @function select
 * @module Tools/base/Selector
 * @namespace Tools.selector
*/

//

function onSelectorUndecorate()
{
  let it = this;
  _.assert( _.strIs( it.selector ) || _.numberIs( it.selector ) );
}

//

function onSelectorUndecorateDoubleColon()
{
  return function onSelectorUndecorateDoubleColon()
  {
    let it = this;
    if( !_.strIs( it.selector ) )
    return;
    if( !_.strHas( it.selector, '::' ) )
    return;
    it.selector = _.strIsolateRightOrAll( it.selector, '::' )[ 2 ];
  }
}

// --
// relations
// --

let last = _.looker.Looker.ContainerType.last;
_.assert( last > 0 );
let ContainerType =
{
  ... _.looker.Looker.ContainerType,
  down : last+1,
  here : last+2,
  single : last+3,
  last : last+3,
}

let ContainerTypeToName =
[
  ... _.looker.Looker.ContainerTypeToName,
  'down',
  'here',
  'single',
]

let Ascend =
[
  ... _.looker.Looker.Ascend,
  downAscend,
  hereAscend,
  singleAscend,
]

let ContainerTypeToMakeEmptyMap =
{
  1 : makeEmptyLong,
  2 : makeEmptyAux,
  3 : makeEmptyHashMap,
  4 : makeEmptySet,
}

let ContainerTypeToDstWriteDownMap =
{
  1 : dstWriteDownLong,
  2 : dstWriteDownAux,
  3 : dstWriteDownHashMap,
  4 : dstWriteDownSet,
}

  // 0 : 'terminal',
  // 1 : 'countable',
  // 2 : 'aux',
  // 3 : 'hashMap',
  // 4 : 'set',

//

let LookerExtension = Object.create( null );

LookerExtension.constructor = function Selector(){};
LookerExtension.head = head;
LookerExtension.optionsFromArguments = optionsFromArguments;
LookerExtension.optionsToIteration = optionsToIteration;
LookerExtension.iteratorInitEnd = iteratorInitEnd;
LookerExtension.reperformIt = reperformIt;
LookerExtension.reperform = reperform;
LookerExtension.performBegin = performBegin;
LookerExtension.performEnd = performEnd;
LookerExtension.iterationMake = iterationMake;
LookerExtension.iterableEval = iterableEval;
LookerExtension.selectorIsCardinal = selectorIsCardinal;
LookerExtension.selectorCardinalParse = selectorCardinalParse;
LookerExtension.elementGet = elementGet;
LookerExtension.chooseBegin = chooseBegin;
LookerExtension.chooseEnd = chooseEnd;
LookerExtension.chooseRoot = chooseRoot;
LookerExtension.containerMake = containerMake
LookerExtension.iteratorSelectorChanged = iteratorSelectorChanged;
LookerExtension.iterationSelectorChanged = iterationSelectorChanged;
LookerExtension.globParse = globParse;

LookerExtension.errNoDown = errNoDown;
LookerExtension.errNoDownHandle = errNoDownHandle;
LookerExtension.errCantSet = errCantSet;
LookerExtension.errCantSetHandle = errCantSetHandle;
LookerExtension.errDoesNotExist = errDoesNotExist;
LookerExtension.errDoesNotExistHandle = errDoesNotExistHandle;
LookerExtension.errHandle = errHandle;

LookerExtension.visitUp = visitUp;
LookerExtension.visitUpBegin = visitUpBegin;

LookerExtension.visitDown = visitDown;
// LookerExtension.performSet = performSet;
LookerExtension.downSet = downSet;

LookerExtension.srcWriteDown = srcWriteDown;
LookerExtension.srcDel = srcDel;
// LookerExtension.srcWriteDownMap = srcWriteDownMap;
LookerExtension.dstWriteDown = dstWriteDown;
LookerExtension.dstWriteDownLong = dstWriteDownLong; /* xxx : remove? */
LookerExtension.dstWriteDownAux = dstWriteDownAux;
LookerExtension.dstWriteDownHashMap = dstWriteDownHashMap;
LookerExtension.dstWriteDownSet = dstWriteDownSet;

LookerExtension.makeEmptyLong = makeEmptyLong; /* xxx : remove? */
LookerExtension.makeEmptyAux = makeEmptyAux;
LookerExtension.makeEmptyHashMap = makeEmptyHashMap;
LookerExtension.makeEmptySet = makeEmptySet;

// down

LookerExtension.downUp = downUp;
LookerExtension.downDown = downDown;
LookerExtension.downAscend = downAscend;

// here

LookerExtension.hereUp = hereUp;
LookerExtension.hereDown = hereDown;
LookerExtension.hereAscend = hereAscend;

// single

LookerExtension.singleUp = singleUp;
LookerExtension.singleDown = singleDown;
LookerExtension.singleAscend = singleAscend;

// terminal

LookerExtension.terminalUp = terminalUp;
LookerExtension.terminalDown = terminalDown;

// glob

LookerExtension.globUp = globUp;
LookerExtension.globDown = globDown;

// fields

LookerExtension.Action = Action;
LookerExtension.cardinalDelimeter = '#';
LookerExtension.ContainerType = ContainerType;
LookerExtension.ContainerTypeToName = ContainerTypeToName;
LookerExtension.Ascend = Ascend;
LookerExtension.ContainerTypeToDstWriteDownMap = ContainerTypeToDstWriteDownMap;
LookerExtension.ContainerTypeToMakeEmptyMap = ContainerTypeToMakeEmptyMap;

//

let Iterator = Object.create( null );

Iterator.selectorArray = null;
Iterator.result = undefined; /* qqq : cover please */
Iterator.originalResult = undefined; /* qqq : cover please */
Iterator.state = 0; /* qqq : cover please */
Iterator.absoluteLevel = null;

//

let Iteration = Object.create( null );

Iteration.exists = null;
Iteration.dst = undefined;
Iteration.selector = null;
Iteration.originalSelector = null;
Iteration.absoluteLevel = null;
Iteration.parsedSelector = null;

Iteration.selectorType = null;
Iteration.dstWritingDown = true;
Iteration.dstWriteDownAct = null;
// Iteration._srcWriteDownMethod = null;

//

let IterationPreserve = Object.create( null );
IterationPreserve.absoluteLevel = null;

//

const Selector = _.looker.classDefine
({
  name : 'Equaler',
  parent : _.looker.Looker,
  prime : Prime,
  seeker : LookerExtension,
  iterator : Iterator,
  iteration : Iteration,
  iterationPreserve : IterationPreserve,
  exec : { head : exec_head, body : exec_body },
});

_.assert( Selector.exec.head === exec_head );
_.assert( Selector.exec.body === exec_body );
_.assert( _.props.has( Selector.Iteration, 'dst' ) && Selector.Iteration.dst === undefined );
_.assert( _.props.has( Selector.Iterator, 'result' ) && Selector.Iterator.result === undefined );

const select = Selector.exec;
const selectIt = Selector.execIt;

//

/**
 * @summary Short-cut for {@link module:Tools/base/Selector.Tools.selector.select _.select }. Sets value of element selected by pattern ( o.selector ).
 * @param {Object} o Options map
 * @param {*} o.src Source entity
 * @param {String} o.selector Pattern to select element(s).
 * @param {*} o.set=null Entity to set.
 *
 * @example
 * let src = {};
   _.selectSet({ src, selector : 'a', set : 1 });
   console.log( src.a ); //1
 *
 * @function selectSet
 * @module Tools/base/Selector
 * @namespace Tools.selector
*/

let selectSet = _.routine.uniteInheriting( select.head, select.body );

var defaults = selectSet.defaults;
defaults.Seeker = defaults;
defaults.set = null;
defaults.action = Action.set;

_.assert( Action.set > 0 );

//

/**
 * @summary Short-cut for {@link module:Tools/base/Selector.Tools.selector.select _.select }. Returns only unique elements.
 * @param {*} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @function select
 * @module Tools/base/Selector
 * @namespace Tools.selector
*/

function selectUnique_body( o )
{
  _.assert( arguments.length === 1 );

  let selected = _.select.body( o );

  let result = _.replicate({ src : selected, onUp });

  return result;

  function onUp( e, k, it )
  {
    if( _.longLike( it.src ) )
    {
      if( _.arrayIs( it.src ) )
      it.src = _.longOnce_( it.src );
      else
      it.src = _.longOnce_( null, it.src );
    }
  }

}

_.routine.extendInheriting( selectUnique_body, select.body );
selectUnique_body.defaults.Seeker = selectUnique_body.defaults;
let selectUnique = _.routine.uniteReplacing( select.head, selectUnique_body );

//

var FunctorExtension =
{
  onSelectorUndecorateDoubleColon,
}

let SelectorExtension =
{

  name : 'selector',
  Seeker : Selector,
  Selector,
  Action,

  selectIt,
  select,
  selectSet,
  selectUnique,

  onSelectorUndecorate,

}

let ToolsSupplementation =
{

  Selector,
  selectIt,
  select,
  selectSet,
  selectUnique,

}

const Self = Selector;
_.props.extend( _, ToolsSupplementation );
/* _.props.extend */Object.assign( _.selector, SelectorExtension );
/* _.props.extend */Object.assign( _.selector.functor, FunctorExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();


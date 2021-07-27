( function _Looker_s_()
{

'use strict';

/**
 * Collection of routines to traverse complex data structure. The module takes care of cycles in a data structure( recursions ) and can be used for comparison, cloning, serialization or operation on several similar data structures. Many other modules based on this to traverse abstract data structures.
  @module Tools/base/Looker
*/

/**
 * Collection of light-weight routines to traverse complex data structure.
 * @namespace Tools.Seeker
 * @module Tools/base/Looker
 */

/**
 * Collection of light-weight routines to traverse complex data structure.
 * @class Tools.Seeker
 * @module Tools/base/Looker
 */

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

}

const _global = _global_;
const _ = _global_.wTools;
const _ObjectHasOwnProperty = Object.hasOwnProperty;

_.looker = _.looker || Object.create( null );

_.assert( !!_realGlobal_ );

// --
// relations
// --

/**
 * Default options for {@link module:Tools/base/Looker.Seeker.look} routine.
 * @typedef {Object} Prime
 * @property {Function} onUp
 * @property {Function} onDown
 * @property {Function} onTerminal
 * @property {Function} ascend
 * @property {Function} onIterable
 * @property {Number} recursive = Infinity
 * @property {Boolean} trackingVisits = 1
 * @property {String} upToken = '/'
 * @property {String} path = '/'
 * @property {Number} level = 0
 * @property {*} src = null
 * @property {*} root = null
 * @property {*} context = null
 * @property {Object} Looker = null
 * @property {Object} it = null
 * @class Tools.Seeker
 */

let Prime = Object.create( null );

Prime.src = undefined;
Prime.root = undefined;
Prime.onUp = onUp;
Prime.onDown = onDown;
Prime.onTerminal = onTerminal;
Prime.pathJoin = pathJoin;
Prime.fast = 0;
Prime.recursive = Infinity;
Prime.revisiting = 0;
Prime.withCountable = 'array';
Prime.withImplicit = 'aux';
Prime.upToken = '/';
Prime.defaultUpToken = null;
Prime.path = '/';
Prime.level = 0;
Prime.context = null;

// --
// iterator
// --

function iteratorRetype( iterator )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( iterator ) );
  _.assert( _.object.isBasic( this.Iterator ) );
  _.assert( _.object.isBasic( this.Iteration ) );
  _.assert( _.object.isBasic( iterator.Seeker ) );
  _.assert( iterator.Seeker === this );
  _.assert( iterator.looker === undefined );
  _.assert( iterator.iterableEval !== null );
  _.assert( iterator.iterator === undefined );
  _.assert( iterator.Seeker.Seeker === iterator.Seeker, 'Default of a routine and its default Looker are not in agreement' );
  _.assert( _.prototype.has( iterator.Seeker, iterator.Seeker.OriginalSeeker ) );

  Object.setPrototypeOf( iterator, iterator.Seeker );

  _.assert( iterator.it === undefined );

  return iterator;
}

//

function iteratorInitBegin( iterator )
{

  _.assert( arguments.length === 1 );
  _.assert( !_.mapIs( iterator ) );
  _.assert( _.object.isBasic( this.Iterator ) );
  _.assert( _.object.isBasic( this.Iteration ) );
  _.assert( _.object.isBasic( iterator.Seeker ) );
  _.assert( iterator.Seeker === this );
  _.assert( iterator.looker === undefined );
  _.assert( _.routineIs( iterator.iterableEval ) );
  _.assert( _.prototype.has( iterator.Seeker, iterator.Seeker.OriginalSeeker ) );
  _.assert( iterator.iterator === null );

  iterator.iterator = iterator;

  return iterator;
}

//

function iteratorInitEnd( iterator )
{

  /* */

  if( _.boolLike( iterator.withCountable ) )
  {
    if( iterator.withCountable )
    iterator.withCountable = 'countable';
    else
    iterator.withCountable = '';
  }
  if( _.boolLike( iterator.withImplicit ) )
  {
    if( iterator.withImplicit )
    iterator.withImplicit = 'aux';
    else
    iterator.withImplicit = '';
  }

  if( _.boolIs( iterator.recursive ) )
  iterator.recursive = iterator.recursive ? Infinity : 1;

  _.assert( iterator.iteratorProper( iterator ) );
  _.assert( iterator.Seeker.Seeker === iterator.Seeker, 'Default of a routine and its default Looker are not in agreement' );
  _.assert( iterator.looker === undefined );
  _.assert
  (
    !Reflect.has( iterator, 'onUp' ) || iterator.onUp === null || iterator.onUp.length === 0 || iterator.onUp.length === 3,
    'onUp should expect exactly three arguments'
  );
  _.assert
  (
    !Reflect.has( iterator, 'onDown' ) || iterator.onDown === null || iterator.onDown.length === 0 || iterator.onDown.length === 3,
    'onDown should expect exactly three arguments'
  );
  _.assert( _.numberIsNotNan( iterator.recursive ), 'Expects number {- iterator.recursive -}' );
  _.assert( 0 <= iterator.revisiting && iterator.revisiting <= 2 );
  _.assert
  (
    this.WithCountable[ iterator.withCountable ] !== undefined,
    'Unexpected value of option::withCountable'
  );
  _.assert
  (
    this.WithImplicict[ iterator.withImplicit ] !== undefined,
    'Unexpected value of option::withImplicit'
  );

  if( iterator.Seeker === null )
  iterator.Seeker = Looker;

  /* */

  iterator.isCountable = iterator.WithCountableToIsElementalFunctionMap[ iterator.withCountable ];
  iterator.hasImplicit = iterator.WithImplicitToHasImplicitFunctionMap[ iterator.withImplicit ];

  if( iterator.revisiting < 2 )
  {
    if( iterator.revisiting === 0 )
    iterator.visitedContainer = _.containerAdapter.from( new Set );
    else
    iterator.visitedContainer = _.containerAdapter.from( new Array );
  }

  if( iterator.root === undefined )
  iterator.root = iterator.src;

  if( iterator.defaultUpToken === null )
  iterator.defaultUpToken = _.strsShortest( iterator.upToken );

  _.seeker.Seeker.iteratorInitEnd.call( this, iterator );

  if( iterator.fast )
  {
    delete iterator.childrenCounter;
    delete iterator.level;
    delete iterator.path;
    delete iterator.lastPath;
    delete iterator.lastIt;
    delete iterator.upToken;
    delete iterator.defaultUpToken;
    delete iterator.context;
  }
  else
  {
    if( iterator.path === null )
    iterator.path = iterator.defaultUpToken;
    iterator.lastPath = iterator.path;
  }

  /*
  important assert, otherwise copying options from iteration could cause problem
  */
  _.assert( iterator.it === undefined );

  if( !iterator.fast )
  {
    _.assert( _.numberIs( iterator.level ) );
    _.assert( _.strIs( iterator.defaultUpToken ) );
    _.assert( _.strIs( iterator.path ) );
    _.assert( _.strIs( iterator.lastPath ) );
    _.assert( _.routineIs( iterator.iterableEval ) );
    _.assert( iterator.iterationPrototype.constructor === iterator.constructor );
    _.assert( iterator.iterationPrototype.constructor === iterator.Seeker.constructor );
  }

  return iterator;
}

//

function iteratorCopy( o )
{
  let it = this;

  _.assert( arguments.length === 1 );
  _.assert( _.object.isBasic( o ) )

  for( let k in o )
  {
    if( it[ k ] === null && o[ k ] !== null && o[ k ] !== undefined )
    {
      it[ k ] = o[ k ];
    }
  }

  return it;
}

// --
// iteration
// --

/**
 * @function iterationMake
 * @class Tools.Seeker
 */

function iterationMake()
{
  let it = this;

  // _.assert( arguments.length === 0, 'Expects no arguments' );
  // _.assert( it.level >= 0 );
  // _.assert( _.object.isBasic( it.iterator ) );
  // _.assert( _.object.isBasic( it.Seeker ) );
  // _.assert( it.looker === undefined );
  // _.assert( _.numberIs( it.level ) && it.level >= 0 );
  // _.assert( !!it.iterationPrototype );

  let newIt = Object.create( it.iterationPrototype );

  if( it.Seeker === Self ) /* zzz : achieve such optimization automatically */
  {
    newIt.level = it.level;
    newIt.path = it.path;
    newIt.src = it.src;
  }
  else
  {
    for( let k in it.Seeker.IterationPreserve )
    newIt[ k ] = it[ k ];
  }

  newIt.down = it;

  return newIt;
}

// --
// perform
// --

function reperform( src )
{
  let it = this;
  _.assert( arguments.length === 1 );
  _.assert( it.iterationProper( it ) );
  it.src = src;
  it.iterable = null;
  return it.perform();
}

//

function perform()
{
  let it = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  it.performBegin();
  it.iterate();
  it.performEnd();
  return it;
}

//

function performBegin()
{
  let it = this;
  _.assert( arguments.length === 0 );
  _.assert( it.iterationProper( it ) );
  _.assert( _.strDefined( it.path ) );
  it.chooseRoot();
  _.assert( _.strDefined( it.path ) );
  return it;
}

//

function performEnd()
{
  let it = this;
  _.assert( it.iterationProper( it ) );
  return it;
}

// --
// choose
// --

/**
 * @function elementGet
 * @class Tools.Seeker
 */

function elementGet( e, k, c )
{
  let it = this;
  let result;
  _.assert( arguments.length === 3, 'Expects two argument' );
  result = _.container.elementWithImplicit( e, k );
  if( c === null )
  c = _.container.cardinalWithKey( e, k );
  return [ result[ 0 ], result[ 1 ], c, result[ 2 ] ];
}

//

/**
 * @function choose
 * @class Tools.Seeker
 */

function choose()
{
  let it = this;
  let e = arguments[ 0 ];
  let k = arguments[ 1 ];
  let c = arguments[ 2 ];
  let exists = arguments[ 3 ];

  [ e, k, c, exists ] = it.chooseBegin( e, k, c, exists );

  _.assert( arguments.length === 4 );
  _.assert( _.boolIs( exists ) || exists === null );

  if( exists !== true )
  [ e, k, c, exists ] = it.elementGet( it.src, k, c );

  it.chooseEnd( e, k, c, exists );

  _.assert( arguments.length === 4, 'Expects three argument' );
  _.assert( _.object.is( it.down ) );
  _.assert( _.boolIs( exists ) );
  _.assert( it.fast || it.level >= 0 );

  return it;
}

//

function chooseBegin()
{
  let it = this;
  let e = arguments[ 0 ];
  let k = arguments[ 1 ];
  let c = arguments[ 2 ];
  let exists = arguments[ 3 ];

  // _.assert( _.object.is( it.down ) );
  // _.assert( it.fast || it.level >= 0 );
  // _.assert( it.originalKey === null );
  // _.assert( arguments.length === 4 );

  if( it.originalKey === null )
  it.originalKey = k;

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

  // _.assert( arguments.length === 4, 'Expects three argument' );
  // _.assert( _.object.isBasic( it.down ) );
  // _.assert( _.boolIs( exists ) );
  // _.assert( it.fast || it.level >= 0 );

  /*
  assigning of key and src should goes first
  */

  it.key = k;
  it.cardinal = c;
  it.src = e;
  it.originalSrc = e;

  if( it.fast )
  return it;

  it.level = it.level+1;

  let k2 = k;
  if( k2 === null )
  k2 = e;
  if( _.strIs( k2 ) )
  {
    /* zzz : test escaped path
    .!not-prototype
    .#not-cardinal
    */
    if( k2 === '' )
    k2 = '""';
  }
  else if( _.props.implicit.is( k2 ) )
  {
    k2 = `!${Symbol.keyFor( k2.val )}`;
  }
  else
  {
    _.assert( c >= 0 );
    k2 = `#${c}`;
  }
  _.assert( k2.length > 0 );
  let hasUp = _.strHasAny( k2, it.upToken );
  if( hasUp )
  k2 = '"' + k2 + '"';

  it.index = it.down.childrenCounter;
  it.path = it.pathJoin( it.path, k2 );
  it.iterator.lastPath = it.path;
  it.iterator.lastIt = it;

  it.srcChanged();
  it.revisitedEval( it.originalSrc );

  return [ e, k, c, exists ];
}

//

function chooseRoot()
{
  let it = this;

  _.assert( arguments.length === 0 );

  it.originalSrc = it.src;

  it.srcChanged();
  it.revisitedEval( it.originalSrc );

  it.iterator.lastPath = it.path;
  it.iterator.lastIt = it;

  return it;
}

// --
// eval
// --

function srcChanged()
{
  let it = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  it.iterableEval();
}

//

function iterableEval()
{
  let it = this;

  _.assert( it.iterable === null );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( _.aux.is( it.src ) )
  {
    it.iterable = it.ContainerType.aux;
  }
  else if( _.hashMap.like( it.src ) )
  {
    it.iterable = it.ContainerType.hashMap;
  }
  else if( _.set.like( it.src ) )
  {
    it.iterable = it.ContainerType.set;
  }
  else if( _.object.is( it.src ) && _.class.methodAscendOf( it.src ) )
  {
    it.iterable = it.ContainerType.custom;
  }
  else if( it.isCountable( it.src ) )
  {
    it.iterable = it.ContainerType.countable;
  }
  else
  {
    it.iterable = 0;
  }

  _.assert( it.iterable >= 0 );
}

//

function revisitedEval( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  if( it.iterator.visitedContainer )
  if( it.iterable )
  {
    if( it.iterator.visitedContainer.has( src ) )
    it.revisited = true;
  }

}

//

function isImplicit()
{
  let it = this;
  _.assert( it.iterationProper( it ) );
  return _.props.implicit.is( it.key );
}

// --
// iterate
// --

/**
 * @function look
 * @class Tools.Seeker
 */

function iterate()
{
  let it = this;

  it.visiting = it.canVisit();
  if( !it.visiting )
  return it;

  it.visitUp();

  it.ascending = it.canAscend();
  if( it.ascending )
  {
    it.ascend();
  }

  it.visitDown();

  return it;
}

//

/**
 * @function visitUp
 * @class Tools.Seeker
 */

function visitUp()
{
  let it = this;

  it.visitUpBegin();

  _.assert( _.routineIs( it.onUp ) );
  let r = it.onUp.call( it, it.src, it.key, it );
  _.assert( r === undefined, 'Callback should not return something' );
  _.assert( _.boolIs( it.continue ), () => 'Expects boolean it.continue, but got ' + _.entity.strType( it.continue ) );

  it.visitUpEnd();

}

//

/**
 * @function visitUpBegin
 * @class Tools.Seeker
 */

function visitUpBegin()
{
  let it = this;

  it.ascending = true;

  _.assert( it.visiting );

  if( !it.fast )
  if( it.down )
  it.down.childrenCounter += 1;

}

//

/**
 * @function visitUpEnd
 * @class Tools.Seeker
 */

function visitUpEnd()
{
  let it = this;

  it.visitPush();

}

//

function onUp( e, k, it )
{
}

//

/**
 * @function visitDown
 * @class Tools.Seeker
 */

function visitDown()
{
  let it = this;

  it.visitDownBegin();

  _.assert( it.visiting );

  if( it.onDown )
  {
    let r = it.onDown.call( it, it.src, it.key, it );
    _.assert( r === undefined );
  }

  it.visitDownEnd();

  return it;
}

//

/**
 * @function visitDownBegin
 * @class Tools.Seeker
 */

function visitDownBegin()
{
  let it = this;

  it.ascending = false;

  _.assert( it.visiting );

  it.visitPop();

}

//

/**
 * @function visitDownEnd
 * @class Tools.Seeker
 */

function visitDownEnd()
{
  let it = this;
}

//

function onDown( e, k, it )
{
}

//

function visitPush()
{
  let it = this;

  if( it.iterator.visitedContainer )
  if( it.visitCounting && it.iterable )
  {
    it.iterator.visitedContainer.push( it.originalSrc );
    it.visitCounting = true;
  }

}

//

function visitPop()
{
  let it = this;

  if( it.iterator.visitedContainer && it.iterator.revisiting !== 0 )
  if( it.visitCounting && it.iterable )
  if( _.arrayIs( it.iterator.visitedContainer.original ) || !it.revisited )
  {
    if( _.arrayIs( it.iterator.visitedContainer.original ) )
    _.assert
    (
      Object.is( it.iterator.visitedContainer.original[ it.iterator.visitedContainer.original.length-1 ], it.originalSrc ),
      () => `Top-most visit ${it.path} does not match`
      + `\n${it.originalSrc} <> ${ it.iterator.visitedContainer.original[ it.iterator.visitedContainer.original.length-1 ]}`
    );
    it.iterator.visitedContainer.pop( it.originalSrc );
    it.visitCounting = false;
  }

}

//

/**
 * @function canVisit
 * @class Tools.Seeker
 */

function canVisit()
{
  let it = this;

  if( !it.recursive && it.down )
  return false;

  return true;
}

//

/**
 * @function canAscend
 * @class Tools.Seeker
 */

function canAscend()
{
  let it = this;

  _.assert( _.boolIs( it.continue ) );
  _.assert( _.boolIs( it.iterator.continue ) );

  if( !it.ascending )
  return false;

  if( it.continue === false )
  return false;
  else if( it.iterator.continue === false )
  return false;
  else if( it.revisited )
  return false;

  _.assert( _.numberIs( it.recursive ) );
  // if( it.recursive > 0 )
  if( !( it.level < it.recursive ) )
  return false;

  return true;
}

//

function canSibling()
{
  let it = this;

  if( !it.continue || it.continue === _.dont )
  return false;

  if( !it.iterator.continue || it.iterator.continue === _.dont )
  return false;

  return true;
}

//

function ascendSrc( src )
{
  let it = this;
  it.src = src;
  it.iterable = null;
  it.srcChanged();
  it.ascend();
}

//

function ascend()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( it.iterable !== null && it.iterable !== undefined );
  _.assert( !!it.continue );
  _.assert( !!it.iterator.continue );

  return it.Ascend[ it.iterable ].call( it, it.src );
}

// --
// ascend
// --

function _termianlAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  it.onTerminal( src );

}

//

function onTerminal()
{
  let it = this;
  return it;
}

//

function _countableAscend( src )
{
  let it = this;

  if( _.class.methodIteratorOf( src ) )
  {
    let k = 0;
    for( let e of src )
    {
      let eit = it.iterationMake().choose( e, k, k, true );
      eit.iterate();
      if( !it.canSibling() )
      break;
      k += 1;
    }
  }
  else
  {
    for( let k = 0 ; k < src.length ; k++ )
    {
      let e = src[ k ];
      let eit = it.iterationMake().choose( e, k, k, true );
      eit.iterate();
      if( !it.canSibling() )
      break;
    }
  }

}

//

function _auxAscend( src )
{
  let it = this;
  let canSibling = true;

  _.assert( arguments.length === 1 );

  let c = 0;
  for( let k in src )
  {
    let e = src[ k ];
    let eit = it.iterationMake().choose( e, k, c, true );
    eit.iterate();
    canSibling = it.canSibling();
    c += 1;
    if( !canSibling )
    break;
  }

  if( canSibling )
  if( it.hasImplicit( src ) )
  {
    var props = _.props.onlyImplicit( src );

    for( var [ k, e ] of props )
    {
      let eit = it.iterationMake().choose( e, k, -1, true );
      eit.iterate();
      canSibling = it.canSibling();
      if( !canSibling )
      break;
    }

  }

}

//

function _hashMapAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let c = 0;
  for( var [ k, e ] of src )
  {
    let eit = it.iterationMake().choose( e, k, c, true );
    eit.iterate();
    c += 1;
    if( !it.canSibling() )
    break;
  }

}

//

function _setAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let c = 0;
  for( let e of src )
  {
    let eit = it.iterationMake().choose( e, e, c, true );
    eit.iterate();
    c += 1;
    if( !it.canSibling() )
    break;
  }

}

//

function _customAscend( src )
{
  let it = this;
  let method = _.class.methodAscendOf( it.src )
  method.call( src, it );
}

// --
// dichotomy
// --

function _isCountable( src )
{
  return _.countableIs( src );
}

//

function _isVector( src )
{
  return _.vectorIs( src );
}

//

function _isLong( src )
{
  return _.longIs( src );
}

//

function _isArray( src )
{
  return _.arrayIs( src );
}

//

function _isConstructibleLike( src )
{
  return _.constructibleLike( src );
}

//

function _isAux( src )
{
  return _.aux.isPrototyped( src );
}

//

function _false( src )
{
  return false;
}

// --
// etc
// --

function pathJoin( selectorPath, selectorName )
{
  let it = this;
  let result;

  _.assert( arguments.length === 2 );
  selectorPath = _.strRemoveEnd( selectorPath, it.upToken );
  result = selectorPath + it.defaultUpToken + selectorName;

  return result;
}

//

function errMake()
{
  let it = this;
  let err = _.looker.SeekingError
  (
    ... arguments
  );
  // debugger; /* eslint-disable-line no-debugger */
  return err;
}

// --
// expose
// --

/**
 * @function look
 * @class Tools.Seeker
 */

function exec_head( routine, args )
{
  return routine.defaults.head( routine, args );
}

function exec_body( it )
{
  return it.execIt.body.call( this, it );
}

function execIt_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.object.isBasic( it.Seeker ) );
  _.assert( _.prototype.isPrototypeFor( it.Seeker, it ) );
  _.assert( it.looker === undefined );
  it.perform();
  return it;
}

//

let _classDefine = _.seeker.classDefine;
_.routine.is( _classDefine );
function classDefine( o )
{

  let looker = _classDefine.call( this, o );
  validate();
  return looker;

  function validate()
  {
    /* qqq : add explanation for each assert */
    _.assert( looker.Prime.Seeker === undefined );
    _.assert( _.routineIs( looker.iterableEval ) );
    _.assert( _.props.has( looker.IterationPreserve, 'src' ) && looker.IterationPreserve.src === undefined );
    _.assert( _.props.has( looker, 'src' ) && looker.src === undefined );
    _.assert( !_.props.has( looker.Iteration, 'root' ) && looker.Iteration.root === undefined );
    _.assert( _.props.has( looker, 'root' ) && looker.root === undefined );
    _.assert( !_.props.has( looker.Iteration, 'src' ) || looker.Iteration.src === undefined );

    if( _.props.has( looker, 'dst' ) )
    {
      _.assert( _.props.has( looker.Iteration, 'dst' ) && looker.Iteration.dst === undefined );
      _.assert( _.props.has( looker, 'dst' ) && looker.dst === undefined );
    }
    if( _.props.has( looker, 'result' ) )
    {
      _.assert( _.props.has( looker.Iterator, 'result' ) && looker.Iterator.result === undefined );
      _.assert( _.props.has( looker, 'result' ) && looker.result === undefined );
    }
  }

}

classDefine.defaults =
{
  ... _.seeker.classDefine.defaults,
}

// --
// relations
// --

let SeekingError = _.error.error_functor( 'SeekingError' );

let ContainerType =
{
  'terminal' : 0,
  'countable' : 1,
  'aux' : 2,
  'hashMap' : 3,
  'set' : 4,
  'custom' : 5,
  'last' : 5,
}

let ContainerTypeToName =
[
  'terminal',
  'countable',
  'aux',
  'hashMap',
  'set',
  'custom',
]

let Ascend =
[
  _termianlAscend,
  _countableAscend,
  _auxAscend,
  _hashMapAscend,
  _setAscend,
  _customAscend,
]

let WithCountableToIsElementalFunctionMap =
{
  'countable' : _isCountable,
  'vector' : _isVector,
  'long' : _isLong,
  'array' : _isArray,
  '' : _false,
}

let WithImplicitToHasImplicitFunctionMap =
{
  'constructible.like' : _isConstructibleLike,
  'aux' : _isAux,
  '' : _false,
}

let WithCountable =
{
  'countable' : 'countable',
  'vector' : 'vector',
  'long' : 'long',
  'array' : 'array',
  '' : '',
}

let WithImplicict =
{
  'aux' : 'aux',
  '' : '',
}

//

_.assert( !_.looker.Looker );
_.assert( !!_.seeker.Seeker );
_.assert( _.seeker.Seeker === _.seeker.Seeker.Seeker );
_.assert( _.seeker.Seeker === _.seeker.Seeker.OriginalSeeker );

const LookerExtension = Object.create( null );

LookerExtension.constructor = function Looker() /* zzz : implement */
{
  _.assert( 0, 'not implemented' );
  let prototype = _.prototype.of( this );
  _.assert( _.object.isBasic( prototype ) );
  _.assert( prototype.exec.defaults === prototype );
  let result = this.head( prototype.exec, arguments );
  _.assert( result === this );
  return this;
}
LookerExtension.constructor.prototype = Object.create( null );

// iterator

LookerExtension.iteratorRetype = iteratorRetype;
LookerExtension.iteratorInitBegin = iteratorInitBegin;
LookerExtension.iteratorInitEnd = iteratorInitEnd;
LookerExtension.iteratorCopy = iteratorCopy;

// iteration

LookerExtension.iterationMake = iterationMake;

// perform

LookerExtension.reperform = reperform;
LookerExtension.perform = perform;
LookerExtension.performBegin = performBegin;
LookerExtension.performEnd = performEnd;

// choose

LookerExtension.elementGet = elementGet;
LookerExtension.choose = choose;
LookerExtension.chooseBegin = chooseBegin;
LookerExtension.chooseEnd = chooseEnd;
LookerExtension.chooseRoot = chooseRoot;

// eval

LookerExtension.srcChanged = srcChanged;
LookerExtension.iterableEval = iterableEval;
LookerExtension.revisitedEval = revisitedEval;
LookerExtension.isImplicit = isImplicit;

// iterate

LookerExtension.iterate = iterate;
LookerExtension.visitUp = visitUp;
LookerExtension.visitUpBegin = visitUpBegin;
LookerExtension.visitUpEnd = visitUpEnd;
LookerExtension.onUp = onUp;
LookerExtension.visitDown = visitDown;
LookerExtension.visitDownBegin = visitDownBegin;
LookerExtension.visitDownEnd = visitDownEnd;
LookerExtension.onDown = onDown;
LookerExtension.visitPush = visitPush;
LookerExtension.visitPop = visitPop;
LookerExtension.canVisit = canVisit;
LookerExtension.canAscend = canAscend;
LookerExtension.canSibling = canSibling;
LookerExtension.ascendSrc = ascendSrc;
LookerExtension.ascend = ascend;

// ascend

LookerExtension._termianlAscend = _termianlAscend;
LookerExtension.onTerminal = onTerminal;
LookerExtension._countableAscend = _countableAscend;
LookerExtension._auxAscend = _auxAscend;
LookerExtension._hashMapAscend = _hashMapAscend;
LookerExtension._setAscend = _setAscend;
LookerExtension._customAscend = _customAscend;

// dichotomy

LookerExtension._isCountable = _isCountable;
LookerExtension._isVector = _isVector;
LookerExtension._isLong = _isLong;
LookerExtension._isArray = _isArray;
LookerExtension._isConstructibleLike = _isConstructibleLike;
LookerExtension._isAux = _isAux;
LookerExtension._false = _false;

// etc

LookerExtension.pathJoin = pathJoin;
LookerExtension.errMake = errMake;

// feilds

LookerExtension.SeekingError = SeekingError;
LookerExtension.ContainerType = ContainerType;
LookerExtension.ContainerTypeToName = ContainerTypeToName;
LookerExtension.Ascend = Ascend;
LookerExtension.WithCountableToIsElementalFunctionMap = WithCountableToIsElementalFunctionMap;
LookerExtension.WithImplicitToHasImplicitFunctionMap = WithImplicitToHasImplicitFunctionMap;
LookerExtension.WithCountable = WithCountable;
LookerExtension.WithImplicict = WithImplicict;
LookerExtension.Prime = Prime;

//

/**
 * @typedef {Object} Iterator
 * @property {} iterator = null
 * @property {} iterationMake = iterationMake
 * @property {} choose = choose
 * @property {} iterate = iterate
 * @property {} visitUp = visitUp
 * @property {} visitUpBegin = visitUpBegin
 * @property {} visitUpEnd = visitUpEnd
 * @property {} visitDown = visitDown
 * @property {} visitDownBegin = visitDownBegin
 * @property {} visitDownEnd = visitDownEnd
 * @property {} canVisit = canVisit
 * @property {} canAscend = canAscend
 * @property {} path = '/'
 * @property {} lastPath = null
 * @property {} lastIt = null
 * @property {} continue = true
 * @property {} key = null
 * @property {} error = null
 * @property {} visitedContainer = null
 * @class Tools.Seeker
 */

let Iterator = LookerExtension.Iterator = Object.create( null );

Iterator.src = undefined;
Iterator.iterator = null;
Iterator.iterationPrototype = null;
Iterator.firstIterationPrototype = null;
Iterator.continue = true;
Iterator.error = null;
Iterator.visitedContainer = null;
Iterator.isCountable = null;
Iterator.hasImplicit = null;
Iterator.fast = 0;
Iterator.recursive = Infinity;
Iterator.revisiting = 0;
Iterator.withCountable = 'array';
Iterator.withImplicit = 'aux';
Iterator.upToken = '/';
Iterator.defaultUpToken = null;
Iterator.lastIt = null;
Iterator.lastPath = null;
Iterator.path = '/';
Iterator.level = 0;
Iterator.root = undefined;
Iterator.context = null;

_.props.extend( LookerExtension, Iterator );

//

/**
 * @typedef {Object} Iteration
 * @property {} childrenCounter = 0
 * @property {} level = 0
 * @property {} path = '/'
 * @property {} key = null
 * @property {} index = null
 * @property {} src = null
 * @property {} continue = true
 * @property {} ascending = true
 * @property {} revisited = false
 * @property {} _ = null
 * @property {} down = null
 * @property {} visiting = false
 * @property {} iterable = null
 * @property {} visitCounted = 1
 * @class Tools.Seeker.Seeker
 */

let Iteration = LookerExtension.Iteration = Object.create( null );
_.assert( _.map.is( Iteration ) );
Iteration.childrenCounter = 0;
Iteration.key = null;
Iteration.cardinal = null;
Iteration.originalKey = null;
Iteration.index = null;
Iteration.originalSrc = null;
Iteration.continue = true;
Iteration.ascending = true;
Iteration.revisited = false;
Iteration._ = null;
Iteration.down = null;
Iteration.visiting = false;
Iteration.iterable = null;
Iteration.visitCounting = true;

//

/**
 * @typedef {Object} IterationPreserve
 * @property {} level = null
 * @property {} path = null
 * @property {} src = null
 * @class Tools.Seeker.Seeker
 */

let IterationPreserve = LookerExtension.IterationPreserve = Object.create( null );
_.assert( _.map.is( IterationPreserve ) );
IterationPreserve.level = 0;
IterationPreserve.path = '/';
IterationPreserve.src = undefined;

_.assert( !_.props.has( LookerExtension.Iteration, 'src' ) && LookerExtension.Iteration.src === undefined );
_.assert( _.props.has( LookerExtension.IterationPreserve, 'src' ) && LookerExtension.IterationPreserve.src === undefined );
_.assert( _.props.has( LookerExtension, 'src' ) && LookerExtension.src === undefined );
_.assert( !_.props.has( LookerExtension.Iteration, 'root' ) && LookerExtension.Iteration.root === undefined );
_.assert( _.props.has( LookerExtension, 'root' ) && LookerExtension.root === undefined );

_.map.assertHasAll( LookerExtension, Prime );

//

const Looker = _.seeker.classDefine
({
  name : 'Looker',
  parent : _.seeker.Seeker,
  prime : Prime,
  seeker : LookerExtension,
  iterator : Iterator,
  iteration : Iteration,
  iterationPreserve : IterationPreserve,
});
const Self = Looker;

exec_body.defaults = Looker;
let exec = _.routine.uniteReplacing( exec_head, exec_body );
Looker.exec = exec;

execIt_body.defaults = Looker;
let execIt = _.routine.uniteReplacing( exec_head, execIt_body );
Looker.execIt = execIt;

_.assert( _.routine.is( Looker.optionsToIteration ) );
_.assert( _.routine.is( Looker.iteratorInit ) );
_.assert( _.routine.is( Looker.iteratorIterationMake ) );
_.assert( _.routine.is( Looker.iterationProper ) );
_.assert( _.routine.is( Looker.head ) );
_.assert( _.routine.is( Looker.optionsFromArguments ) );
_.assert( _.routine.is( Looker.iteratorProper ) );

// --
// declare
// --

let LookerNamespaceExtension =
{

  name : 'looker',
  Looker,
  Seeker : Looker,
  SeekingError,

  look : exec,
  lookIt : execIt,

  is : _.seeker.is,
  iteratorIs : _.seeker.iteratorIs,
  iterationIs : _.seeker.iterationIs,
  classDefine, /* qqq : cover please */

}

Object.assign( _.looker, LookerNamespaceExtension );

//

let ErrorExtension =
{

  SeekingError,

}

Object.assign( _.error, ErrorExtension );

//

let ToolsExtension =
{

  look : exec,

}

_.props.extend( _, ToolsExtension );

//

_.assert( _.looker.Looker === Looker );
_.assert( _.looker.Looker === _.looker.Looker.Seeker );
_.assert( _.looker.Looker === _.looker.Looker.OriginalSeeker );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();


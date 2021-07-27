( function _l5_1Seeker_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;

// --
// implementation
// --

function head( routine, args )
{
  _.assert( arguments.length === 2 );
  _.assert( !!routine.defaults.Seeker );
  let o = routine.defaults.Seeker.optionsFromArguments( args );
  o.Seeker = o.Seeker || routine.defaults;
  _.map.assertHasOnly( o, routine.defaults );
  _.assert
  (
    _.props.keys( routine.defaults ).length === _.props.keys( o.Seeker ).length,
    () => `${_.props.keys( routine.defaults ).length} <> ${_.props.keys( o.Seeker ).length}`
  );
  let it = o.Seeker.optionsToIteration( null, o );
  return it;
}

//

function optionsFromArguments( args )
{
  let o;

  if( args.length === 1 )
  {
    o = args[ 0 ];
  }
  else if( args.length === 2 )
  {
    o = { src : args[ 0 ], onUp : args[ 1 ] };
  }
  else if( args.length === 3 )
  {
    o = { src : args[ 0 ], onUp : args[ 1 ], onDown : args[ 2 ] };
  }
  else _.assert( 0, 'look expects single options-map, 2 or 3 arguments' );

  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 1 );
  _.assert( _.aux.is( o ) );

  return o;
}

//

function optionsToIteration( iterator, o )
{
  _.assert( o.it === undefined );
  _.assert( _.mapIs( o ) );
  _.assert( !_.props.ownEnumerable( o, 'constructor' ) );
  _.assert( arguments.length === 2 );
  if( iterator === null )
  iterator = o.Seeker.iteratorRetype( o );
  else
  Object.assign( iterator, o );
  o.Seeker.iteratorInit( iterator );
  let it = iterator.iteratorIterationMake();
  _.assert( it.Seeker.iterationProper( it ) );
  return it;
}

//

function iteratorProper( it )
{
  if( !it )
  return false;
  if( !it.Seeker )
  return false;
  if( it.iterator !== it )
  return false;
  if( it.constructor !== this.constructor )
  return false;
  return true;
}

//

function iteratorRetype( iterator )
{
  Object.setPrototypeOf( iterator, iterator.Seeker );
  iterator.iterator = iterator;
  return iterator;
}

//

function iteratorInit( iterator )
{
  let seeker = this;
  seeker.iteratorInitBegin( iterator );
  seeker.iteratorInitEnd( iterator );
}

//

function iteratorInitBegin( iterator )
{
  iterator.iterator = iterator;
  return iterator;
}

//

const _iteratorInitExcluding = new Set([ 'Seeker', 'iterationPrototype', 'firstIterationPrototype', 'iterator' ]);
function iteratorInitEnd( iterator )
{

  iterator.iterationPrototype = Object.create( iterator );
  iterator.firstIterationPrototype = Object.create( iterator.iterationPrototype );
  Object.assign( iterator.iterationPrototype, iterator.Seeker.Iteration );

  for( const [ key, val ] of Object.entries( iterator ) )
  {
    if( _iteratorInitExcluding.has( key ) )
    continue;

    if( !_.props.own( iterator.iterationPrototype, key ) )
    continue;

    if( _.props.has( iterator.Iteration, key ) )
    {
      if( iterator.firstIterationPrototype[ key ] !== val )
      {
        iterator.firstIterationPrototype[ key ] = val;
      }
    }
    else
    {
      if( iterator.iterationPrototype[ key ] !== val )
      {
        iterator.iterationPrototype[ key ] = val;
      }
    }

  }

  Object.preventExtensions( iterator.iterationPrototype );
  return iterator;
}

//

function iteratorIterationMake()
{
  let it = this;
  let newIt = Object.create( it.firstIterationPrototype );
  return newIt;
}

//

function iterationMake()
{
  let it = this;
  let newIt = Object.create( it.iterationPrototype );

  for( let k in it.Seeker.IterationPreserve )
  newIt[ k ] = it[ k ];

  newIt.down = it; /* xxx */

  return newIt;
}

//

function iterationProper( it )
{
  if( !it )
  return false;
  if( !it.Seeker )
  return false;
  if( !it.iterator )
  return false;
  if( it.iterator === it )
  return false;
  if( it.constructor !== this.constructor )
  return false;
  return true;
}

// --
//
// --

/**
 * @function is
 * @class Tools.Seeker
 */

function is( src )
{
  if( !src )
  return false;
  if( !src.Seeker )
  return false;
  return _.prototype.isPrototypeFor( src, src.Seeker );
}

//

/**
 * @function iteratorIs
 * @class Tools.Seeker
 */

function iteratorIs( it )
{
  if( !it )
  return false;
  if( !it.Seeker )
  return false;
  if( it.iterator !== it )
  return false;
  return true;
}

//

/**
 * @function iterationIs
 * @class Tools.Seeker
 */

function iterationIs( it )
{
  if( !it )
  return false;
  if( !it.Seeker )
  return false;
  if( !it.iterator )
  return false;
  if( it.iterator === it )
  return false;
  return true;
}

//

function classDefine( o )
{

  _.routine.options( classDefine, o );

  if( o.parent === null )
  o.parent = this.Seeker;
  if( o.name === null )
  o.name = 'CustomSeeker'

  _.assert( _.object.isBasic( o.parent ), `Parent should be object` );

  let seeker = _.props.extend( null, o.parent );

  if( !o.seeker || !o.seeker.constructor || o.seeker.constructor === Object )
  {
    let CustomSeeker = (function()
    {
      return ({
        [ o.name ] : function(){},
      })[ o.name ];
    })();
    seeker.constructor = CustomSeeker;
    _.assert( seeker.constructor.name === o.name );
  }

  if( o.prime )
  _.props.extend( seeker, o.prime );
  if( o.seeker )
  _.props.extend( seeker, o.seeker );
  if( o.iterator )
  _.props.extend( seeker, o.iterator );
  if( o.iterationPreserve )
  o.iteration = _.props.supplement( o.iteration || Object.create( null ), o.iterationPreserve );

  seeker.Seeker = seeker;
  seeker.OriginalSeeker = seeker;
  seeker.Prime = Object.create( seeker.Prime || null );
  if( o.prime )
  _.props.extend( seeker.Prime, o.prime );
  Object.preventExtensions( seeker.Prime );

  if( o.exec || seeker.exec )
  seeker.exec = exec_functor( o.exec || seeker.exec );
  if( o.execIt || seeker.execIt )
  seeker.execIt = exec_functor( o.execIt || seeker.execIt );

  let iterator = seeker.Iterator = Object.assign( Object.create( null ), seeker.Iterator );
  if( o.iterator )
  _.props.extend( iterator, o.iterator );

  seeker.Iteration = Object.assign( Object.create( null ), seeker.Iteration );
  let iterationPreserve = seeker.IterationPreserve = Object.assign( Object.create( null ), seeker.IterationPreserve );
  if( o.iterationPreserve )
  {
    _.props.extend( iterationPreserve, o.iterationPreserve );
  }
  if( o.iteration )
  _.props.extend( seeker.Iteration, o.iteration );

  Object.freeze( seeker.Iterator );
  Object.freeze( seeker.Iteration );
  Object.freeze( seeker.IterationPreserve );

  validate();

  return seeker;

  /* - */

  function exec_functor( original )
  {
    _.assert( _.routineIs( original.head ) );
    _.assert( _.routineIs( original.body ) );
    if( !original.body.defaults )
    original.body.defaults = seeker;
    let exec = _.routine._amend
    ({
      dst : null,
      srcs : [ original, { defaults : seeker } ],
      strategy : 'replacing',
      amending : 'extending',
    });
    _.assert( exec.defaults === seeker );
    _.assert( exec.body.defaults === seeker );
    return exec;
  }

  /* - */

  function validate()
  {
    if( !Config.debug )
    return;

    /* qqq : add explanation for each assert */
    _.assert( seeker.Prime.Seeker === undefined );
    _.assert( !_.props.has( seeker.Iteration, 'src' ) || seeker.Iteration.src === undefined );
    _.assert( !_.props.has( seeker.IterationPreserve, 'src' ) || seeker.IterationPreserve.src === undefined );
    _.assert( !_.props.has( seeker, 'src' ) || seeker.src === undefined );
    _.assert( !_.props.has( seeker.Iteration, 'root' ) || seeker.Iteration.root === undefined );
    _.assert( !_.props.has( seeker, 'root' ) || seeker.root === undefined );
    if( _.props.has( seeker, 'dst' ) )
    {
      _.assert( _.props.has( seeker.Iteration, 'dst' ) && seeker.Iteration.dst === undefined );
      _.assert( _.props.has( seeker, 'dst' ) && seeker.dst === undefined );
    }

    for( let k in seeker.Iteration )
    if( _.props.has( seeker, k ) )
    {
      _.assert
      (
        seeker[ k ] === seeker.Iteration[ k ],
        () => `Conflicting default value of field::${k} of Seeker::${o.name}`
        + `\n${seeker[ k ]} <> ${seeker.Iteration[ k ]}`
      );
    }

  }

  /* - */

}

classDefine.defaults =
{
  name : null,
  parent : null,
  prime : null,
  seeker : null,
  iterator : null,
  iteration : null,
  iterationPreserve : null,
  exec : null,
  execIt : null,
}

// --
//
// --

const Seeker = Object.create( null );
Seeker.OriginalSeeker = Seeker;
Seeker.Seeker = Seeker;
Seeker.constructor = function Seeker() /* xxx : implement */
{
  _.assert( 0, 'not implemented' );
  let prototype = _.prototype.of( this );
  _.assert( _.object.isBasic( prototype ) );
  _.assert( prototype.exec.defaults === prototype );
  let result = this.head( prototype.exec, arguments );
  _.assert( result === this );
  return this;
}

_.prototype.set( Seeker.constructor, null );
Seeker.constructor.prototype = Seeker;

Seeker.head = head;
Seeker.optionsToIteration = optionsToIteration;
Seeker.optionsFromArguments = optionsFromArguments;
Seeker.iteratorProper = iteratorProper;
Seeker.iteratorRetype = iteratorRetype;
Seeker.iteratorInit = iteratorInit;
Seeker.iteratorInitBegin = iteratorInitBegin;
Seeker.iteratorInitEnd = iteratorInitEnd;
Seeker.iteratorIterationMake = iteratorIterationMake;
Seeker.iterationMake = iterationMake;
Seeker.iterationProper = iterationProper;
Seeker.onUp = null;
Seeker.onDown = null;
Seeker.iterationPrototype = null;
Seeker.firstIterationPrototype = null;

/* xxx : remove Iterator? */
const Iterator = Seeker.Iterator = Object.create( null );

const Iteration = Seeker.Iteration = Object.create( null );
Iteration.down = null;

const IterationPreserve = Seeker.IterationPreserve = Object.create( null );

// --
// seeker extension
// --

let SeekerExtension =
{

  Seeker,

  is,
  iteratorIs,
  iterationIs,
  classDefine,

}

Object.assign( _.seeker, SeekerExtension );

// --
// tools extension
// --

let ToolsExtension =
{
}

Object.assign( _, ToolsExtension );

})();

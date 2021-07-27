( function _Consequence_s_()
{

'use strict';

/*

= Concepts

Consequence ::
Resource ::
Error of resource ::
Argument of resource ::
Competitor ::
Procedure ::

*/

/*

= Principles

1. Methods of Consequence should call callback instantly and synchronously if all necessary data provided, otherwise, Consequence should call callback asynchronously.
2. Handlers of keeping methods cannot return undefined. It is often a sign of a bug.
3. A resource of Consequence cannot have both an error and an argument but must have either one.

*/

/*

= Groups

1. then / except / finally
2. give / keep

*/

const _global = _global_;
const _ = _global_.wTools;
let Deasync = null;

_.assert( !_.Consequence, 'Consequence included several times' );

// relations

let KindOfResource =
{
  ErrorOnly : 1,
  ArgumentOnly : 2,
  Both : 3,
  BothWithCompetitor : 4,
}

//

/**

 */

/**
 * Function that accepts result of wConsequence value computation. Used as parameter in methods such as finallyGive(), finally(), etc.
 * @param {*} err Error object, or any other type, that represent or describe an error reason. If during resolving
 *  value no exception occurred, it will be set to null;
 * @param {*} value resolved by wConsequence value;
 * @callback Competitor
 * @class wConsequence
 * @namespace Tools
 * @module Tools/base/Consequence
 */

/**
 * @classdesc Class wConsequence creates objects that used for asynchronous computations. It represent the queue of results that
 * can computation asynchronously, and has a wide range of tools to implement this process.
 * @class wConsequence
 * @module Tools/base/Consequence
 */

/**
 * Creates instance of wConsequence
 * @param {Object|Function|wConsequence} [o] initialization options
 * @example
 * let con = new _.Consequence();
 * con.take( 'hello' ).finallyGive( function( err, value) { console.log( value ); } ); // hello
 *
 * let con = _.Consequence();
 * con.finallyGive( function( err, value) { console.log( value ); } ).take('world'); // world
 * @constructor wConsequence
 * @class wConsequence
 * @module Tools/base/Consequence
 * @returns {wConsequence}
 */

/* heavy optimization */

class wConsequence extends _.CallableObject
{
  constructor()
  {
    let self = super();
    Self.prototype.init.apply( self, arguments );
    // return self; /* Dmytro : eslint rule mark it as error. The removing of the line does not affect the behavior of module */
  }
}

let wConsequenceProxy = new Proxy
(
  wConsequence,
  {
    apply : function apply( original, context, args )
    {
      let o = args[ 0 ];

      if( o )
      if( o instanceof Self )
      {
        o = _.mapOnly_( null, o, Self.FieldsOfCopyableGroups );
      }

      if( Config.debug )
      {
        if( o === undefined )
        {
          o = Object.create( null );
          args[ 0 ] = o;
        }
      }

      return new original( ... args );
    },

    set : function set( original, name, value )
    {
      return Reflect.set( ... arguments );
    },
  }
);

const Parent = null;
const Self = wConsequenceProxy;

wConsequence.shortName = 'Consequence';

// --
// inter
// --

/**
 * Initialises instance of wConsequence
 * @param {Object|wConsequence} [o] initialization options
 * @private
 * @method init
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function init( o )
{
  let self = this;

  if( o )
  {
    if( !Config.debug )
    {
      delete o.tag;
      delete o.capacity;
    }
    if( o instanceof Self )
    {
      o = _.mapOnly_( null, o, self.FieldsOfCopyableGroups );
    }
    else
    {
      _.map.assertHasOnly( o, self.FieldsOfCopyableGroups );
    }
    if( o._resources )
    o._resources = o._resources.slice();
    _.props.extend( self, o );
  }

  if( RestrictsDebug.id === 0 )
  {
    self.Counter += 1;
    self.id = self.Counter;
  }

  _.assert( arguments.length === 0 || arguments.length === 1 );
}

//

function is( src )
{
  _.assert( arguments.length === 1 );
  return _.consequenceIs( src );
}

// --
// basic
// --

/**
 * Method appends resolved value and error competitor to wConsequence competitors sequence. That competitor accept only one
    value or error reason only once, and don't pass result of it computation to next competitor (unlike Promise 'finally').
    if finallyGive() called without argument, an empty competitor will be appended.
    After invocation, competitor will be removed from competitors queue.
    Returns current wConsequence instance.
 * @example
     function gotHandler1( error, value )
     {
       console.log( 'competitor 1: ' + value );
     };

     function gotHandler2( error, value )
     {
       console.log( 'competitor 2: ' + value );
     };

     let con1 = new _.Consequence();

     con1.finallyGive( gotHandler1 );
     con1.take( 'hello' ).take( 'world' );

     // prints only " competitor 1: hello ",

     let con2 = new _.Consequence();

     con2.finallyGive( gotHandler1 ).finallyGive( gotHandler2 );
     con2.take( 'foo' );

     // prints only " competitor 1: foo "

     let con3 = new _.Consequence();

     con3.finallyGive( gotHandler1 ).finallyGive( gotHandler2 );
     con3.take( 'bar' ).take( 'baz' );

     // prints
     // competitor 1: bar
     // competitor 2: baz
     //
 * @param {Competitor|wConsequence} [competitor] callback, that accepts resolved value or exception reason.
 * @returns {wConsequence}
 * @see {@link Competitor} competitor callback
 * @throws {Error} if passed more than one argument.
 * @method finallyGive
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function finallyGive( competitorRoutine )
{
  let self = this;
  let times = 1;

  _.assert
  (
    arguments.length === 1,
    () => `Expects none or single argument, but got ${arguments.length} arguments`
  );

  if( _.numberIs( competitorRoutine ) )
  {
    times = competitorRoutine;
    competitorRoutine = function(){};
  }

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : false,
    kindOfResource : Self.KindOfResource.Both,
    times,
    stack : 2,
  });

  self.__handleResourceSoon( false );

  return self;
}

finallyGive.having =
{
  consequizing : 1,
}

//

function finallyKeep( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : true,
    kindOfResource : Self.KindOfResource.Both,
    stack : 2,
    times : 1,
  });

  self.__handleResourceSoon( false );
  return self;
}

finallyKeep.having =
{
  consequizing : 1,
}

//

function thenGive( competitorRoutine )
{
  let self = this;
  let times = 1;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.numberIs( competitorRoutine ) ) /* qqq : cover */
  {
    times = competitorRoutine;
    competitorRoutine = function(){};
  }

  self._competitorAppend
  ({
    competitorRoutine,
    times,
    keeping : false,
    kindOfResource : Self.KindOfResource.ArgumentOnly,
    stack : 2,
  });

  self.__handleResourceSoon( false );
  return self;
}

thenGive.having =
{
  consequizing : 1,
}

//

/**
 * Method pushed `competitor` callback into wConsequence competitors queue. That callback will
   trigger only in that case if accepted error parameter will be null. Else accepted error will be passed to the next
   competitor in queue. After handling accepted value, competitor pass result to the next competitor, like finally
   method.
 * @returns {wConsequence}
 * @throws {Error} if passed more than one arguments
 * @see {@link module:Tools/base/Consequence.wConsequence#finallyGive} finally method
 * @method thenKeep
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function thenKeep( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  return self._promiseThen( arguments[ 0 ], arguments[ 1 ] );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : true,
    kindOfResource : Self.KindOfResource.ArgumentOnly,
    stack : 2,
  });

  self.__handleResourceSoon( false );
  return self;
}

thenKeep.having =
{
  consequizing : 1,
}

//

function catchGive( competitorRoutine )
{
  let self = this;
  let times = 1;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.numberIs( competitorRoutine ) )
  {
    times = competitorRoutine;
    competitorRoutine = function(){};
  }

  self._competitorAppend
  ({
    competitorRoutine,
    times,
    keeping : false,
    kindOfResource : Self.KindOfResource.ErrorOnly,
    stack : 2,
  });

  self.__handleResourceSoon( false );
  return self;
}

catchGive.having =
{
  consequizing : 1,
}

//

/**
 * catchKeep method pushed `competitor` callback into wConsequence competitors queue. That callback will
   trigger only in that case if accepted error parameter will be defined and not null. Else accepted parameters will
   be passed to the next competitor in queue.

 * @param {Competitor|wConsequence} competitor callback, that accepts exception  reason and value .
 * @returns {wConsequence}
 * @throws {Error} if passed more than one arguments
 * @see {@link module:Tools/base/Consequence.wConsequence#finallyGive} finally method
 * @method catchKeep
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function catchKeep( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : true,
    kindOfResource : Self.KindOfResource.ErrorOnly,
    stack : 2,
  });

  self.__handleResourceSoon( false );

  return self;
}

catchKeep.having =
{
  consequizing : 1,
}

// --
// promise
// --

function _promiseThen( resolve, reject )
{
  let self = this;

  _.assert( arguments.length === 2 );
  _.assert( _.routineIs( resolve ) && _.routineIs( reject ) );
  _.assert( resolve.length === 1 && reject.length === 1 );

  return self.finallyGive( ( err, got ) =>
  {
    if( err )
    reject( err );
    else
    resolve( got );
  })

}

//

function _promise( o )
{
  let self = this;
  let keeping = o.keeping;
  let kindOfResource =  o.kindOfResource;
  let procedure = self.procedure( 3 ).nameElse( 'promise' );
  self.procedureDetach();

  _.routine.assertOptions( _promise, arguments );

  let result = new Promise( function( resolve, reject )
  {
    self.procedure( procedure );

    self._competitorAppend
    ({
      keeping : 0,
      competitorRoutine,
      kindOfResource : self.KindOfResource.Both,
      stack : 3,
    });

    self.__handleResourceSoon( false );

    function competitorRoutine( err, arg )
    {
      if( err )
      {
        if( kindOfResource === self.KindOfResource.Both || kindOfResource === self.KindOfResource.ErrorOnly )
        reject( err );
      }
      else
      {
        if( kindOfResource === self.KindOfResource.Both || kindOfResource === self.KindOfResource.ErrorOnly )
        resolve( arg );
      }
      if( keeping )
      self.take( err, arg );
    };

  });

  return result;
}

_promise.defaults =
{
  keeping : null,
  kindOfResource : null,
}

_promise.having =
{
  consequizing : 1,
}

//

function finallyPromiseGive()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self._promise
  ({
    keeping : 0,
    kindOfResource : self.KindOfResource.Both,
  });
}

finallyPromiseGive.having = Object.create( _promise.having );

//

/**
 * Method accepts competitor for resolved value/error. This competitor method finally adds to wConsequence competitors sequence.
    After processing accepted value, competitor return value will be pass to the next competitor in competitors queue.
    Returns current wConsequence instance.

 * @example
   function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
     value++;
     return value;
   };

   function gotHandler3( error, value )
   {
     console.log( 'competitor 3: ' + value );
   };

   let con1 = new _.Consequence();

   con1.finally( gotHandler1 ).finally( gotHandler1 ).finallyGive(gotHandler3);
   con1.take( 4 ).take( 10 );

   // prints:
   // competitor 1: 4
   // competitor 1: 5
   // competitor 3: 6

 * @param {Competitor|wConsequence} competitor callback, that accepts resolved value or exception reason.
 * @returns {wConsequence}
 * @throws {Error} if missed competitor.
 * @throws {Error} if passed more than one argument.
 * @see {@link Competitor} competitor callback
 * @see {@link module:Tools/base/Consequence.wConsequence#finallyGive} finallyGive method
 * @method finally
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function finallyPromiseKeep()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self._promise
  ({
    keeping : 1,
    kindOfResource : self.KindOfResource.Both,
  });
}

finallyPromiseKeep.having = Object.create( _promise.having );

//

function thenPromiseGive()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self._promise
  ({
    keeping : 0,
    kindOfResource : self.KindOfResource.ArgumentOnly,
  });
}

thenPromiseGive.having = Object.create( _promise.having );

//

function thenPromiseKeep()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self._promise
  ({
    keeping : 1,
    kindOfResource : self.KindOfResource.ArgumentOnly,
  });
}

thenPromiseKeep.having = Object.create( _promise.having );

//

function catchPromiseGive()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self._promise
  ({
    keeping : 0,
    kindOfResource : self.KindOfResource.ErrorOnly,
  });
}

catchPromiseGive.having = Object.create( _promise.having );

//

function catchPromiseKeep()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self._promise
  ({
    keeping : 1,
    kindOfResource : self.KindOfResource.ErrorOnly,
  });
}

catchPromiseKeep.having = Object.create( _promise.having );

// --
// deasync
// --

function _deasync( o )
{
  let self = this;
  let procedure = self.procedure( 3 ).nameElse( 'deasync' );
  let keeping = o.keeping;
  let result = Object.create( null );
  let ready = false;

  _.routine.assertOptions( _deasync, arguments );
  _.assert
  (
    o.kindOfResource === 0
    || o.kindOfResource === self.KindOfResource.Both
    || o.kindOfResource === self.KindOfResource.ArgumentOnly
    || o.kindOfResource === self.KindOfResource.ErrorOnly
  );

  self._competitorAppend
  ({
    competitorRoutine,
    kindOfResource : self.KindOfResource.Both,
    keeping : 0,
    stack : 3,
  });

  self.__handleResourceSoon( false );

  if( Deasync === null )
  Deasync = require( 'wdeasync' ); /* yyy */
  Deasync.loopWhile( () => !ready )

  if( result.error )
  if( o.kindOfResource === self.KindOfResource.Both || o.kindOfResource === self.KindOfResource.ErrorOnly )
  throw result.error;
  else
  return new _.Consequence().error( result.error );

  if( o.kindOfResource === self.KindOfResource.Both || o.kindOfResource === self.KindOfResource.ArgumentOnly )
  return result.argument;
  else
  return new _.Consequence().take( result.argument );

  return self;

  function competitorRoutine( error, argument )
  {
    result.error = error;
    result.argument = argument;
    ready = true;
    if( keeping )
    self.take( error, argument );
  };

}

_deasync.defaults =
{
  keeping : null,
  kindOfResource : null,
}

_deasync.having =
{
  consequizing : 1,
}

//

function deasync()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self._deasync
  ({
    keeping : 1,
    kindOfResource : 0,
  });
}

deasync.having = Object.create( _deasync.having );

// --
// advanced
// --

function _first( src, stack )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.consequenceIs( src ) )
  {
    src.finally( self );
  }
  else if( _.routineIs( src ) )
  {
    let result;

    try
    {
      result = src();
      if( result === undefined )
      throw self.ErrNoReturn( src );
    }
    catch( err )
    {
      result = new _.Consequence().error( self.__handleError( err ) );
    }

    if( _.consequenceIs( result ) )
    {
      result.finally( self );
    }
    else if( _.promiseLike( result ) )
    {
      result.finally( Self.From( result ) );
    }
    else
    {
      self.take( result );
    }

  }
  else _.assert( 0, 'Method first expects consequence of routine, but got', _.entity.strType( src ) );

  return self;
}

//

/**
 * If type of `src` is function, the first method run it on begin, if the result of `src` invocation is instance of
   wConsequence, the current wConsequence will be wait for it resolving, else method added result to resources sequence
   of the current instance.
 * If `src` is instance of wConsequence, the current wConsequence delegates to it his first corespondent.
 * Returns current wConsequence instance.
 * @example
 * function handleGot1(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   let con = new  _.Consequence();

   con.first( function()
   {
     return 'foo';
   });

 con.take( 100 );
 con.finallyGive( handleGot1 );
 // prints: handleGot1 value: foo
*
  function handleGot1(err, val)
  {
    if( err )
    {
      console.log( 'handleGot1 error: ' + err );
    }
    else
    {
      console.log( 'handleGot1 value: ' + val );
    }
  };

  let con = new  _.Consequence();

  con.first( function()
  {
    return _.Consequence().take(3);
  });

 con.take(100);
 con.finallyGive( handleGot1 );
 * @param {wConsequence|Function} src wConsequence or routine.
 * @returns {wConsequence}
 * @throws {Error} if `src` has unexpected type.
 * @method first
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function first( src )
{
  let self = this;
  return self._first( src, null );
}

first.having =
{
  consequizing : 1,
}

//

/**
 * Returns new _.Consequence instance. If on cloning moment current wConsequence has uncaught resolved values in queue
   the first of them would be handled by new _.Consequence. Else pass accepted
 * @example
   function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
     value++;
     return value;
   };

   function gotHandler2( error, value )
   {
     console.log( 'competitor 2: ' + value );
   };

   let con1 = new _.Consequence();
   con1.take(1).take(2).take(3);
   let con2 = con1.split();
   con2.finallyGive( gotHandler2 );
   con2.finallyGive( gotHandler2 );
   con1.finallyGive( gotHandler1 );
   con1.finallyGive( gotHandler1 );

    // prints:
    // competitor 2: 1 // only first value copied into cloned wConsequence
    // competitor 1: 1
    // competitor 1: 2

 * @returns {wConsequence}
 * @throws {Error} if passed any argument.
 * @method splitKeep
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function splitKeep( first )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let result = new Self();

  if( first ) // xxx : remove, maybe argument?
  {
    result.finally( first );
    self.give( function( err, arg )
    {
      result.take( err, arg );
      this.take( err, arg );
    });
  }
  else
  {
    self.finally( result );
  }

  return result;
}

splitKeep.having =
{
  consequizing : 1,
}

//

function splitGive( first )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let result = new Self();

  if( first ) // xxx : remove, maybe argument?
  {
    result.finally( first );
    self.give( function( err, arg )
    {
      result.take( err, arg );
    });
  }
  else
  {
    self.finallyGive( result );
  }

  return result;
}

splitGive.having =
{
  consequizing : 1,
}

//

/**
 * Works like finallyGive() method, but value that accepts competitor, passes to the next taker in takers queue without
   modification.
 * @example
 *
   function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
     value++;
     return value;
   }

   function gotHandler2( error, value )
   {
     console.log( 'competitor 2: ' + value );
   }

   function gotHandler3( error, value )
   {
     console.log( 'competitor 3: ' + value );
   }

   let con1 = new _.Consequence();
   con1.take(1).take(4);

   // prints:
   // competitor 1: 1
   // competitor 2: 1
   // competitor 3: 4

 * @param {Competitor|wConsequence} competitor callback, that accepts resolved value or exception
   reason.
 * @returns {wConsequence}
 * @throws {Error} if passed more than one arguments
 * @see {@link module:Tools/base/Consequence.wConsequence#finallyGive} finallyGive method
 * @method tap
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function tap( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : false,
    tapping : true,
    kindOfResource : Self.KindOfResource.Both,
    stack : 2,
  });

  self.__handleResourceSoon( false );
  return self;
}

tap.having =
{
  consequizing : 1,
}

//

/**
 * Creates and adds to corespondents sequence error competitor. If handled resource contains error, corespondent logs it.
 * @returns {wConsequence}
 * @throws {Error} If called with any argument.
 * @method catchLog
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function catchLog()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self._competitorAppend
  ({
    competitorRoutine : errorLog,
    keeping : true,
    kindOfResource : Self.KindOfResource.ErrorOnly,
    stack : 2,
  });

  self.__handleResourceSoon( false );
  return self;

  /* - */

  function errorLog( err )
  {
    err = _.err( err );
    logger.error( _.errOnce( err ) );
    return null;
  }

}

catchLog.having =
{
  consequizing : 1,
}

//

/**
 * Creates and adds to corespondents sequence error competitor. If handled resource contains error, corespondent logs it.
 * @returns {wConsequence}
 * @throws {Error} If called with any argument.
 * @method catchBrief
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function catchBrief()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self._competitorAppend
  ({
    competitorRoutine : errorLog,
    keeping : true,
    kindOfResource : Self.KindOfResource.ErrorOnly,
    stack : 2,
  });

  self.__handleResourceSoon( false );
  return self;

  /* - */

  function errorLog( err )
  {
    err = _.errBrief( err );
    logger.error( _.errOnce( err ) );
    return null;
  }

}

catchBrief.having =
{
  consequizing : 1,
}

//

function syncMaybe()
{
  let self = this;

  if( self._resources.length === 1 )
  {
    let resource = self._resources[ 0 ];
    if( resource.error === undefined )
    {
      // _.assert( resource.error === undefined ); /* Dmytro : has no sense for this condition */
      _.assert( resource.argument !== undefined );
      return resource.argument;
    }
    else
    {
      // _.assert( resource.argument === undefined ); /* Dmytro : has no sense for this condition */
      _.assert( resource.error !== undefined );
      throw _.err( resource.error );
    }
    // if( resource.error !== undefined )
    // {
    //   _.assert( resource.argument === undefined );
    //   throw _.err( resource.error );
    // }
    // else
    // {
    //   _.assert( resource.error === undefined );
    //   return resource.argument;
    // }
  }

  return self;
}

//

function sync()
{
  let self = this;

  _.assert( self._resources.length <= 1, () => 'Cant return resource of consequence because it has ' + self._resources.length + ' of such!' );
  _.assert( self._resources.length >= 1, () => 'Cant return resource of consequence because it has none of such!' );

  return self.syncMaybe();
}

// --
// experimental
// --

function _competitorFinally( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : true,
    kindOfResource : Self.KindOfResource.BothWithCompetitor,
    stack : 2,
  });

  self.__handleResourceSoon( false );
  return self;
}

//

function wait()
{
  let self = this;
  let result = new _.Consequence();

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.finallyGive( function __wait( err, arg )
  {
    if( err )
    self.error( err );
    else
    self.take( result );
  });

  self.take( null );

  return result;
}

//

function participateGive( con )
{
  let self = this;

  _.assert( _.consequenceIs( con ) );
  _.assert( arguments.length === 1 );

  con.finallyGive( 1 );
  self.finallyGive( con );
  // con.take( self );

  return con;
}

//

function participateKeep( con )
{
  let self = this;

  _.assert( _.consequenceIs( con ) );
  _.assert( arguments.length === 1 );

  con.finallyGive( 1 );
  self.finallyKeep( con );

  return con;
}

//

function ErrNoReturn( routine )
{
  let err = _.err( `Callback of then of consequence should return something, but callback::${routine.name} returned undefined` )
  err = _.err( routine.toString(), '\n', err );
  return err;
}

// --
// put
// --

function _put( o )
{
  let self = this;
  let key = o.key;
  let container = o.container;
  let keeping = o.keeping;

  _.assert( !_.primitiveIs( o.container ), 'Expects one or two argument, container for resource or key and container' );
  _.assert( o.key === null || _.numberIs( o.key ) || _.strIs( o.key ), () => 'Key should be number or string, but it is ' + _.entity.strType( o.key ) );

  if( o.key !== null )
  {
    self._competitorAppend
    ({
      keeping,
      kindOfResource : o.kindOfResource,
      competitorRoutine : o.kindOfResource === Self.KindOfResource.ArgumentOnly ? __onPutWithKeyArgumentOnly : __onPutWithKey,
      stack : 4, /* delta : 4 to not include info about `routine.unite` in the stack */
    });
    self.__handleResourceSoon( false );
    return self;
  }
  else if( _.argumentsArray.like( o.container ) )
  {
    self._competitorAppend
    ({
      keeping,
      kindOfResource : o.kindOfResource,
      competitorRoutine : o.kindOfResource === Self.KindOfResource.ArgumentOnly ? __onPutToArrayArgumentOnly : __onPutToArray,
      stack : 4, /* delta : 4 to not include info about `routine.unite` in the stack */
    });
    self.__handleResourceSoon( false );
    return self;
  }
  else
  {
    _.assert( 0, 'Expects key for to put to objects or fixed-size long' );
  }

  /* */

  function __onPutWithKey( err, arg )
  {
    if( err === undefined )
    container[ key ] = arg;
    else
    container[ key ] = err;

    // if( err !== undefined )
    // container[ key ] = err;
    // else
    // container[ key ] = arg;

    if( !keeping )
    return;
    if( err )
    throw err;
    return arg;
  }

  /* */

  function __onPutWithKeyArgumentOnly( arg ) /* ArgumentOnly competitor should expect single argument */
  {
    container[ key ] = arg;

    if( !keeping )
    return;

    return arg;
  }

  /* */

  function __onPutToArray( err, arg )
  {
    _.assert( 0, 'not tested' );

    if( err === undefined )
    container.push( arg );
    else
    container.push( err );

    // if( err !== undefined )
    // container.push( err );
    // else
    // container.push( arg );

    if( !keeping )
    return;
    if( err )
    throw err;
    return arg;
  }

  /* */

  function __onPutToArrayArgumentOnly( arg ) /* ArgumentOnly competitor should expect single argument */
  {
    _.assert( 0, 'not tested' );

    container.push( arg );

    if( !keeping )
    return;
    return arg;
  }

}

_put.defaults =
{
  key : null,
  container :  null,
  kindOfResource : null,
  keeping  : null,
}

//

function put_head( routine, args )
{
  let self = this;
  let o = Object.create( null );

  if( args[ 1 ] === undefined )
  {
    o = { container : args[ 0 ] }
  }
  else
  {
    o = { container : args[ 0 ], key : args[ 1 ] }
  }

  _.assert( args.length === 1 || args.length === 2, 'Expects one or two argument, container for resource or key and container' );
  _.routine.options_( routine, o );

  return o;
}

//

let putGive = _.routine.uniteCloning_replaceByUnite({ head : put_head, body : _put, name : 'putGive' });
var defaults = putGive.defaults;
defaults.kindOfResource = KindOfResource.Both;
defaults.keeping = false;

let putKeep = _.routine.uniteCloning_replaceByUnite({ head : put_head, body : _put, name : 'putKeep' });
var defaults = putKeep.defaults;
defaults.kindOfResource = KindOfResource.Both;
defaults.keeping = true;

let thenPutGive = _.routine.uniteCloning_replaceByUnite({ head : put_head, body : _put, name : 'thenPutGive' });
var defaults = thenPutGive.defaults;
defaults.kindOfResource = KindOfResource.ArgumentOnly;
defaults.keeping = false;

let thenPutKeep = _.routine.uniteCloning_replaceByUnite({ head : put_head, body : _put, name : 'thenPutKeep' });
var defaults = thenPutKeep.defaults;
defaults.kindOfResource = KindOfResource.ArgumentOnly;
defaults.keeping = true;

// --
// time
// --

/**
 * Works like finally, but when competitor accepts resource from resources sequence, execution of competitor will be
    delayed. The result of competitor execution will be passed to the competitor that is first in competitor queue
    on execution end moment.

 * @example
 *
   function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
     value++;
     return value;
   }

   function gotHandler2( error, value )
   {
     console.log( 'competitor 2: ' + value );
   }

   let con = new _.Consequence();

   con.delay( 500, gotHandler1 ).finallyGive( gotHandler2 );
   con.take( 90 );
   //  prints:
   // competitor 1: 90
   // competitor 2: 91

 * @param {number} time delay in milliseconds
 * @param {Competitor|wConsequence} competitor callback, that accepts exception reason and value.
 * @returns {wConsequence}
 * @throws {Error} if missed arguments.
 * @throws {Error} if passed extra arguments.
 * @see {@link module:Tools/base/Consequence.wConsequence#finally} finally method
 * @method delay
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

//

function delay_head( routine, args )
{
  // let o = { time : args[ 0 ], callback : args[ 1 ] };
  let o = { time : args[ 0 ] };
  _.routine.options_( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( o.time ) );
  return o;
}

//

/* qqq : rewrite method _delay with routine _.time.begin() instead of routine _.time.out() */

function _delay( o )
{
  let self = this;
  let time = o.time;

  /* */

  let competitorRoutine;
  if( o.kindOfResource === Self.KindOfResource.Both )
  competitorRoutine = __delayFinally;
  else if( o.kindOfResource === Self.KindOfResource.ArgumentOnly )
  competitorRoutine = __delayThen;
  else if( o.kindOfResource === Self.KindOfResource.ErrorOnly )
  competitorRoutine = __delayCatch;
  else _.assert( 0 );

  /* */

  self._competitorAppend
  ({
    keeping : false,
    competitorRoutine,
    kindOfResource : o.kindOfResource,
    stack : 4, /* delta : 4 to not include info about `routine.unite` in the stack */
  });

  self.__handleResourceSoon( false );

  return self;

  /**/

  /* qqq for Dmytro : ! */
  function __delayFinally( err, arg )
  {
    // console.log( '__delayFinally:1' );
    _.time.begin( o.time, () =>
    {
      // console.log( '__delayFinally:2' );
      self.take( err, arg )
    });
  }

  /**/

  function __delayCatch( err )
  {
    _.time.begin( o.time, () => self.take( undefined, err ) );
  }

  /**/

  function __delayThen( arg )
  {
    _.time.begin( o.time, () => self.take( arg ) );
  }

  /**/

}

_delay.defaults =
{
  time : null,
  kindOfResource : null,
}

_delay.having =
{
  consequizing : 1,
}

let finallyDelay = _.routine.uniteCloning_replaceByUnite({ head : delay_head, body : _delay, name : 'finallyDelay' });
var defaults = finallyDelay.defaults;
defaults.kindOfResource = KindOfResource.Both;

let thenDelay = _.routine.uniteCloning_replaceByUnite({ head : delay_head, body : _delay, name : 'thenDelay' });
var defaults = thenDelay.defaults;
defaults.kindOfResource = KindOfResource.ArgumentOnly;

let exceptDelay = _.routine.uniteCloning_replaceByUnite({ head : delay_head, body : _delay, name : 'exceptDelay' });
var defaults = exceptDelay.defaults;
defaults.kindOfResource = KindOfResource.ErrorOnly;

//

function timeLimit_head( routine, args )
{
  let o = { time : args[ 0 ], callback : args[ 1 ] };
  if( o.callback === undefined )
  o.callback = _.nothing;
  _.routine.options_( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( _.numberIs( o.time ) );
  return o;
}

//

function _timeLimit( o )
{
  let self = this;
  let time = o.time;
  let callback = o.callback;
  let callbackConsequence = callback;
  let error = o.error;
  let timeOutConsequence = new _.Consequence();
  let done = false;
  let timer;
  let procedure = self.procedureDetach() || _.Procedure( 3 ); /* delta : 3 to not include info about `routine.unite` in the stack */

  _.assert( arguments.length === 1 );
  _.assert( callback !== undefined && callback !== _.nothing, 'Expects callback or consequnce to time limit it' );

  if( !_.consequenceIs( callbackConsequence ) )
  {
    if( _.routineIs( callbackConsequence ) )
    callbackConsequence = new _.Consequence();
    else
    callback = callbackConsequence = _.Consequence.From( callbackConsequence );

    // if( !_.routineIs( callbackConsequence ) )
    // callback = callbackConsequence = _.Consequence.From( callbackConsequence );
    // else
    // callbackConsequence = new _.Consequence();
  }

  let c = self._competitorAppend
  ({
    keeping : false,
    competitorRoutine : _timeLimitCallback,
    kindOfResource : KindOfResource.Both,
    stack : 4, /* delta : 4 to not include info about `routine.unite` in the stack */
  });

  self.procedure( () => procedure.clone() ).nameElse( 'timeLimit' );
  self.orKeeping([ callbackConsequence, timeOutConsequence ]);
  self.procedure( () => procedure.clone() ).nameElse( 'timeLimit' );
  self.tap( () =>
  {
    done = true;
    if( timer )
    _.time.cancel( timer );
  });

  self.__handleResourceSoon( false );

  return self;

  /* */

  function _timeLimitCallback( err, arg )
  {

    if( err )
    {
      _.assert( !done, 'not tested' );
      procedure.finit();
      if( !done )
      timeOutConsequence.error( err );
      return;
    }

    _.assert( !done, 'not tested' );
    if( !_.consequenceIs( callback ) )
    {
      callback = _.Consequence.Try( () => callback() )
      // callback.procedure( () => procedure.clone() ); /* yyy */
      callback.finally( callbackConsequence );
    }

    timer = _.time.begin( o.time, procedure, () =>
    {
      if( done )
      return;
      if( error )
      timeOutConsequence.error( _.time._errTimeOut({ procedure, reason : 'time limit', consequnce : self }) );
      else
      timeOutConsequence.take( _.time.out );
    })

  }

  /* */

}

_timeLimit.defaults =
{
  time : null,
  callback : null,
  error : 0,
}

_timeLimit.having =
{
  consequizing : 1,
}

let timeLimit = _.routine.uniteCloning_replaceByUnite({ head : timeLimit_head, body : _timeLimit, name : 'timeLimit' });
var defaults = timeLimit.defaults;
defaults.kindOfResource = KindOfResource.Both;
defaults.error = 0;

let timeLimitError = _.routine.uniteCloning_replaceByUnite({ head : timeLimit_head, body : _timeLimit, name : 'timeLimitError' });
var defaults = timeLimitError.defaults;
defaults.kindOfResource = KindOfResource.Both;
defaults.error = 1;

//

function timeLimitSplit( time )
{
  let self = this;
  let result = new _.Consequence();
  self._procedure = new _.Procedure( 1 ); /* create a procedure to later detach it in `_timeLimit` to have a proper _sourcePath */

  _.assert( arguments.length === 1 );

  result._timeLimit
  ({
    time,
    callback : self,
    kindOfResource : KindOfResource.Both,
    error : 0,
  });

  result.take( null );

  return result;
}

//

function timeLimitErrorSplit( time )
{
  let self = this;
  let result = new _.Consequence();
  self._procedure = new _.Procedure( 1 ); /* create a procedure to later detach it in `_timeLimit` to have a proper _sourcePath */

  _.assert( arguments.length === 1 );

  result._timeLimit
  ({
    time,
    callback : self,
    kindOfResource : KindOfResource.Both,
    error : 1,
  });

  result.take( null );

  return result;
}

//

function TimeLimit( timeLimit, consequence )
{
  let result = new _.Consequence({ _procedure : new _.Procedure( 1 ) }).take( null ) /* create a procedure to later detach it in `_timeLimit` to have a proper _sourcePath */
  .timeLimit( timeLimit, consequence );
  return result;
}

//

function TimeLimitError( timeLimit, consequence )
{
  let result = new _.Consequence({ _procedure : new _.Procedure( 1 ) }).take( null ) /* create a procedure to later detach it in `_timeLimit` to have a proper _sourcePath */
  .timeLimitError( timeLimit, consequence );
  return result;
}

// --
// and
// --

function and_head( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { competitors : args[ 0 ] };

  _.routine.options_( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  return o;
}

//

function _and( o )
{
  let self = this;
  let errs = [];
  let args = [];
  let anyErr;
  let competitors = o.competitors;
  let keeping = o.keeping;
  let accumulative = o.accumulative;
  let waitingResource = o.waitingResource;
  let waitingOthers = o.waitingOthers;
  let procedure = self.procedure( o.stack, 2 ).nameElse( '_and' ); /* aaa2 : cover procedure.sourcePath of each derived routine */ /* Dmytro : covered */ /* delta : 2 to not include info about `routine.unite` in the stack */
  let escaped = 0;
  let errOwner = {};

  _.routine.assertOptions( _and, arguments );

  /* */

  if( _.argumentsArray.like( competitors ) )
  competitors = _.longSlice( competitors );
  else
  competitors = [ competitors ];

  if( waitingResource )
  competitors.push( self );
  else
  competitors.unshift( self );

  let left = competitors.length;
  let first = waitingResource ? 0 : 1;
  let last = waitingResource ? competitors.length-1 : competitors.length;
  let indexOfSelf =  waitingResource ? competitors.length-1 : 0;

  /* */

  if( Config.debug && self.Diagnostics )
  competitorsCheck();

  /* */

  if( waitingResource )
  self.finallyGive( start );
  else
  start();

  escaped = 1;
  return self;

  /* - */

  function start( err, arg )
  {

    callbacksStart();

    if( waitingResource )
    {
      got2({ index : indexOfSelf, competitor : self, err, arg });
    }
    else
    self.finallyGive( ( err, arg ) =>
    {
      got2({ index : indexOfSelf, competitor : self, err, arg });
    });

  }

  /* - */

  function callbacksStart()
  {
    let competitors2 = [];

    for( let c = first ; c < last ; c++ ) (function( c )
    {
      let competitor = competitors[ c ];
      let originalCompetitor = competitor;
      let wasRoutine = false;

      if( !_.consequenceIs( competitor ) && _.routineIs( competitor ) )
      try
      {
        wasRoutine = true;
        competitor = competitors[ c ] = competitor();
      }
      catch( err )
      {
        competitor = competitors[ c ] = new _.Consequence().error( _.err( err ) );
      }

      // if( _.promiseLike( competitor ) )
      // competitor = competitors[ c ] = _.Consequence.From( competitor );

      _.assert
      (
        competitor !== undefined
        , () => `Expects defined value, but got ${_.entity.strType( competitor )}`
        + `${ _.routineIs( originalCompetitor ) ? '\n' + originalCompetitor.toString() : ''}`
      );

      if( waitingResource )
      {

        if( !_.consequenceIs( competitor ) ) /* xxx : teach And to accept non-consequence and cover */
        {
          got2({ index : c, competitor : null, err : undefined, arg : competitor });
          return;
        }
        else if( _.longHas( competitors2, competitor ) )
        {
          return;
        }

      }
      else
      {

        if( _.consequenceIs( competitor ) )
        {
          if( _.longHas( competitors2, competitor ) )
          return;
        }
        else
        {
          got2({ index : c, competitor : null, err : undefined, arg : competitor });
          return;
        }

      }

      /*
      accounting of dependencies of routines
      consequences have already been accounted
      */

      competitors2.push( competitor );

      if( wasRoutine )
      if( _.consequenceIs( competitor ) )
      if( Config.debug && self.Diagnostics )
      {
        competitor.assertNoDeadLockWith( self );
        _.assert( !_.longHas( self._dependsOf, competitor ) );
        _.arrayAppendOnceStrictly( self._dependsOf, competitor );
      }

      competitor.procedure({ _stack : procedure.stack() }).nameElse( 'and' );
      competitor.finallyGive( ( err, arg ) => got2({ index : c, competitor, err, arg }) );


    })( c );

  }

  /* */

  function got2( op )
  {

    _.assert( _.consequenceIs( op.competitor ) || op.competitor === null );

    if( op.err && !anyErr )
    anyErr = op.err;

    if( _.consequenceIs( op.competitor ) && op.index === undefined )
    for( let c = 0 ; c < competitors.length ; c++ )
    {
      let competitor2 = competitors[ c ];
      if( competitor2 === op.competitor )
      op.index = c;
    }

    _.assert( op.competitor === competitors[ op.index ] || op.competitor === null );

    if( _.consequenceIs( op.competitor ) )
    for( let c = 0 ; c < competitors.length ; c++ )
    {
      let competitor2 = competitors[ c ];
      if( competitor2 === op.competitor )
      account({ ... op, index : c });
    }
    else
    {
      account( op );
    }

    if( Config.debug && self.Diagnostics )
    if( op.competitor !== self && _.consequenceIs( op.competitor ) )
    {
      _.arrayRemoveElementOnceStrictly( self._dependsOf, op.competitor );
    }

    if( !waitingOthers && op.competitor !== self && _.consequenceIs( op.competitor ) )
    {
      op.competitor.take( op.err, op.arg );
    }

    _.assert( left >= 0 );
    if( left === 0 )
    {
      if( escaped && waitingResource )
      _.time.soon( done );
      else
      done();
    }

  }

  /* */

  function account( op )
  {
    _.assert( op.index >= 0 )
    if( op.err )
    {
      op.err = _.errSuspend( op.err, errOwner, true );
      // _.assert( op.err.suspended === errOwner );
    }
    errs[ op.index ] = op.err;
    args[ op.index ] = op.arg;
    left -= 1;
  }

  /* */

  function done()
  {
    let competitors2 = [];

    for( let i = first ; i < last ; i++ )
    {
      let err = errs[ i ];
      if( err )
      err = _.errSuspend( err, errOwner, false );
    }

    if( keeping && waitingOthers )
    for( let i = first ; i < last ; i++ )
    if( competitors[ i ] )
    {
      let competitor = competitors[ i ];
      if( _.longHas( competitors2, competitor ) )
      continue;
      if( !_.consequenceIs( competitor ) )
      continue;

      let err = errs[ i ];
      // if( err )
      // err = _.errSuspend( err, errOwner, false );

      competitor.take( err, args[ i ] );
      competitors2.push( competitor );
    }

    if( accumulative )
    args = _.arrayFlatten( args );

    if( anyErr )
    {
      anyErr = _.errSuspend( anyErr, errOwner, false );
    }

    if( anyErr )
    self.error( anyErr );
    else
    self.take( args );

  }

  /* */

  function competitorsCheck()
  {
    let competitors2 = [];
    let convertedPromises;

    for( let s = first ; s < last ; s++ )
    {
      let competitor = competitors[ s ];

      // if( _.promiseLike( competitor ) ) /* Dmytro : base implementation */
      // competitor = competitors[ s ] = _.Consequence.From( competitor );

      if( _.promiseLike( competitor ) ) /* Dmytro : needs conversion, because it allows append competitor in queue */
      competitor = promiseConvert( competitor, s, convertedPromises );

      // _.assert /* Dmytro : allows to accept any type of competitors */
      // (
      //   _.consequenceIs( competitor ) || _.routineIs( competitor ) || competitor === null,
      //   () => 'Consequence.and expects consequence, routine, promise or null, but got ' + _.entity.strType( competitor )
      // );

      if( !_.consequenceIs( competitor ) )
      continue;
      if( _.longHas( competitors2, competitor ) )
      continue;

      competitor.assertNoDeadLockWith( self );
      _.arrayAppendOnceStrictly( self._dependsOf, competitor );
      competitors2.push( competitor );
    }

  }

  /* */

  function promiseConvert( competitor, s, convertedPromises )
  {

    if( !convertedPromises )
    convertedPromises = new HashMap(); /* Dmytro : provide fast search, contains links and indexes, temporary container */

    let index = convertedPromises.get( competitor );
    if( index === undefined )
    {
      convertedPromises.set( competitor, s );
      competitor = competitors[ s ] = _.Consequence.From( competitor );
    }
    else
    {
      competitor = competitors[ s ] = competitors[ index ];
    }

    return competitor;
  }

}

_and.defaults =
{
  competitors : null,
  keeping : 0,
  accumulative : 0,
  waitingResource : 1,
  waitingOthers : 1,
  stack : 2,
}

var having = _and.having = Object.create( null );
having.consequizing = 1;
having.andLike = 1;

//

/**
 * Method andTake() takes each resource, which is received by competitors {-competitors-}. The competitors does not
 * resolve resources. If Consequence-owner is ready to resolve its own resource and any of handled Consequences
 * receives not resource, then it will wait until all passed competitors will receive resource. Finally,
 * Consequence-owner resolve all received resources and its own resource.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.andTake([ con1, con2 ]);
 *
 * conOwner.take( 100 );
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   con1.cancel();
 *   con2.cancel();
 *
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // [ 'con1 take', 'con2 take' ]
 * // Value : [ 'value1', 'value2', 100 ]
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors of any type.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors of any type.
 * @returns { Consequence } - Returns Consequence-owner when all handled Consequences will be resolved.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method andTake
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let andTake = _.routine.uniteCloning_replaceByUnite({ head : and_head, body : _and, name : 'andTake' });
var defaults = andTake.defaults;
defaults.keeping = false;

//

/**
 * Method andKeep() copies each resource, which is received by competitors {-competitors-} to own resources.
 * Each handled competitor resolve its resources. If Consequence-owner is ready to resolve its own resource
 * and any of handled Consequences resolve not resource, then it will wait until all passed competitors will
 * receive and resolve resource. Finally, Consequence-owner resolve all received resources and its own resource.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.andKeep([ con1, con2 ]);
 *
 * conOwner.take( 100 );
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // con2 competitor executed with value : value2 and error : undefined
 * // [ 'con1 take', 'con1 tap', 'con2 take', 'con2 tap' ]
 * // Value : [ 'value1', 'value2', 100 ]
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors of any type.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors of any type.
 * @returns { Consequence } - Returns Consequence-owner when all handled Consequences will be resolved.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method andKeep
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let andKeep = _.routine.uniteCloning_replaceByUnite({ head : and_head, body : _and, name : 'andKeep' });
var defaults = andKeep.defaults;
defaults.keeping = true;

//

/* aaa : jsdoc, please */ /* Dmytro : documented */

/**
 * Method andImmediate() copies each resource, which resolved by competitors {-competitors-} to own resources.
 * If Consequence-owner is ready to resolve its own resource and any of handled Consequences has unresolved resource,
 * then it will wait until all passed competitors will be resolved. Finally, Consequence-owner resolve own resources.
 * If any of competitors was rejected, then Consequence-owner resolve not own resource and get only rejected error.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.andImmediate([ con1, con2 ]);
 *
 * conOwner.take( 100 );
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   con1.cancel();
 *   con2.cancel();
 *
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // con2 competitor executed with value : value2 and error : undefined
 * // [ 'con1 take', 'con1 tap', 'con2 take', 'con2 tap' ]
 * // Value : [ 'value1', 'value2', 100 ]
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors of any type.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors of any type.
 * @returns { Consequence } - Returns Consequence-owner when all handled Consequences will be resolved.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method andImmediate
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let andImmediate = _.routine.uniteCloning_replaceByUnite({ head : and_head, body : _and, name : 'andKeep' });
var defaults = andImmediate.defaults;
defaults.keeping = true;
defaults.waitingOthers = false;

//

/* aaa : jsdoc, please */ /* Dmytro : documented */

/**
 * Method andKeepAccumulative() copies each resource, which received by competitors {-competitors-} to own resources.
 * If Consequence-owner is ready to resolve its own resource and any of handled Consequences received no resource,
 * then it will wait until all passed competitors will have resource. Finally, competitors resolve own resources in order
 * of receiving and Consequence-owner resolve all resources.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.andKeepAccumulative([ con1, con2 ]);
 *
 * conOwner.take( 100 );
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   con1.cancel();
 *   con2.cancel();
 *
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // con2 competitor executed with value : value2 and error : undefined
 * // [ 'con1 take', 'con1 tap', 'con2 take', 'con2 tap' ]
 * // Value : [ 'value1', 'value2', 100 ]
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors of any type.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors of any type.
 * @returns { Consequence } - Returns Consequence-owner when all handled Consequences will be resolved.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method andKeepAccumulative
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let andKeepAccumulative = _.routine.uniteCloning_replaceByUnite({ head : and_head, body : _and, name : 'andKeepAccumulative' });
var defaults = andKeepAccumulative.defaults;
defaults.keeping = true;
defaults.accumulative = true;

//

/**
 * Method alsoTake() calls passed callback without waiting for resource and takes result of the call into an array.
 * To convert serial code to parallel replace methods {then}/{finally} by methods {also*}, without need to change
 * structure of the code, what methods {and*} require.
 * First element of returned array has a resource which the Consequence-owner have had before call of ${also}
 * or the first which the Consequence will get later.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.alsoTake([ con1, con2 ]);
 *
 * conOwner.take( 100 );
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   con1.cancel();
 *   con2.cancel();
 *
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // [ 'con1 take', 'con2 take' ]
 * // Value : [ 100, 'value1', 'value2' ]
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors of any type.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors of any type.
 * @returns { Consequence } - Returns Consequence-owner when all handled Consequences will be resolved.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method alsoTake
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */


let alsoTake = _.routine.uniteCloning_replaceByUnite({ head : and_head, body : _and, name : 'alsoTake' });
var defaults = alsoTake.defaults;
defaults.keeping = false;
defaults.accumulative = true;
defaults.waitingResource = false;

//

/**
 * Method alsoKeep() calls passed callback without waiting for resource and copies result of the call into an array.
 * To convert serial code to parallel replace methods {then}/{finally} by methods {also*}, without need to change
 * structure of the code, what methods {and*} require.
 * First element of returned array has a resource which the Consequence-owner have had before call of ${also}
 * or the first which the Consequence will get later.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.alsoKeep([ con1, con2 ]);
 *
 * conOwner.take( 100 );
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // con2 competitor executed with value : value2 and error : undefined
 * // [ 'con1 take', 'con2 take', 'con1.tap', 'con2.tap' ]
 * // Value : [ 100, 'value1', 'value2' ]
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors of any type.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors of any type.
 * @returns { Consequence } - Returns Consequence-owner when all handled Consequences will be resolved.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method alsoKeep
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let alsoKeep = _.routine.uniteCloning_replaceByUnite({ head : and_head, body : _and, name : 'alsoKeep' });
var defaults = alsoKeep.defaults;
defaults.keeping = true;
defaults.accumulative = true;
defaults.waitingResource = false;

//

/* aaa : jsdoc please */ /* Dmytro : documented */

/**
 * Method alsoImmediate() calls passed callback without waiting for resource and immediatelly receive resource from the result.
 * The resource copies to array. To convert serial code to parallel replace methods {then}/{finally} by methods {also*}, without
 * need to change * structure of the code, what methods {and*} require.
 * First element of returned array has a resource which the Consequence-owner have had before call of ${also}
 * or the first which the Consequence will get later.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.alsoImmediate([ con1, con2 ]);
 *
 * conOwner.take( 100 );
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // con2 competitor executed with value : value2 and error : undefined
 * // [ 'con1 take', 'con1.tap', 'con2 take', 'con2.tap' ]
 * // Value : [ 100, 'value1', 'value2' ]
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors of any type.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors of any type.
 * @returns { Consequence } - Returns Consequence-owner when all handled Consequences will be resolved.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method alsoImmediate
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let alsoImmediate = _.routine.uniteCloning_replaceByUnite({ head : and_head, body : _and, name : 'alsoImmediate' });
var defaults = alsoImmediate.defaults;
defaults.keeping = true;
defaults.accumulative = true;
defaults.waitingResource = false;
defaults.waitingOthers = false;

//

/* aaa : jsdoc please */ /* Dmytro : documented */

/**
 * Static routine AndTake() takes each resource, which is received by competitors provided in arguments. The competitors
 * does not resolve resources. The routine returns resulted Consequence when all passed competitors will receive resource.
 *
 * @example
 * let track = [];
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * let conOwner = _.Consequence.AndTake( con1, con2 );
 *
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   con1.cancel();
 *   con2.cancel();
 *
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // [ 'con1 take', 'con2 take' ]
 * // Value : [ 'value1', 'value2' ]
 *
 * @param { * } ... arguments - Unlimited number of competitors of any type in arguments.
 * @returns { Consequence } - Returns new Consequence when all passed competitors will be resolved.
 * @throws { Error } If routine calls by instance of Consequence.
 * @static
 * @function AndTake
 * @module Tools/base/Consequence
 * @namespace wTools.Consequence
 * @class wConsequence
 */

function AndTake()
{
  _.assert( !_.instanceIs( this ) )
  let result = _.Consequence().take( null );
  result.procedure( 1 );
  result.andTake( arguments );
  result.procedure( 1 ).nameElse( 'AndTake' );
  result.then( ( arg ) =>
  {
    _.assert( arg[ arg.length - 1 ] === null );
    arg.splice( arg.length - 1, 1 );
    return arg;
  });
  return result;
}

//

/* aaa : cover that procedures of AndTake and AndKeep has correct sourcePath */ /* Dmytro : covered */

/* qqq : jsdoc please */ /* Dmytro : documented */

/**
 * Static routine AndKeep() copies each resource, which is received by competitors provided in arguments. The competitors
 * resolve resources. The routine returns resulted Consequence when all passed competitors will receive resource.
 *
 * @example
 * let track = [];
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * let conOwner = _.Consequence.AndKeep( con1, con2 );
 *
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // con2 competitor executed with value : value2 and error : undefined
 * // [ 'con1 take', 'con1.tap', 'con2 take', 'con2.tap' ]
 * // Value : [ 'value1', 'value2' ]
 *
 * @param { * } ... arguments - Unlimited number of competitors of any type in arguments.
 * @returns { Consequence } - Returns new Consequence when all passed competitors will be resolved.
 * @throws { Error } If routine calls by instance of Consequence.
 * @static
 * @function AndKeep
 * @module Tools/base/Consequence
 * @namespace wTools.Consequence
 * @class wConsequence
 */

function AndKeep()
{
  _.assert( !_.instanceIs( this ) )
  let result = _.Consequence().take( null );
  result.procedure( 1 );
  result.andKeep( arguments );
  result.procedure( 1 ).nameElse( 'AndKeep' );
  result.then( ( arg ) =>
  {
    _.assert( arg[ arg.length - 1 ] === null );
    arg.splice( arg.length - 1, 1 );
    return arg;
  });
  return result;
}

//

/* aaa : jsdoc please */ /* Dmytro : documented */

/* aaa : cover please */ /* Dmytro : covered */

/**
 * Static routine AndImmediate() copies each resource, which is received by competitors provided in arguments. The competitors
 * resolve resources immediatelly after receiving. The routine returns resulted Consequence when all passed competitors will
 * receive resource.
 *
 * @example
 * let track = [];
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * let conOwner = _.Consequence.AndImmediate( con1, con2 );
 *
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // con2 competitor executed with value : value2 and error : undefined
 * // [ 'con1 take', 'con1.tap', 'con2 take', 'con2.tap' ]
 * // Value : [ 'value1', 'value2' ]
 *
 * @param { * } ... arguments - Unlimited number of competitors of any type in arguments.
 * @returns { Consequence } - Returns new Consequence when all passed competitors will be resolved.
 * @throws { Error } If routine calls by instance of Consequence.
 * @static
 * @function AndImmediate
 * @module Tools/base/Consequence
 * @namespace wTools.Consequence
 * @class wConsequence
 */

function AndImmediate()
{
  _.assert( !_.instanceIs( this ) )
  let result = _.Consequence().take( null );
  result.procedure( 1 );
  result.andImmediate( arguments );
  result.procedure( 1 ).nameElse( 'AndImmediate' );
  result.then( ( arg ) =>
  {
    _.assert( arg[ arg.length - 1 ] === null );
    arg.splice( arg.length - 1, 1 );
    return arg;
  });
  return result;
}

// --
// or
// --

/* aaa2 : write head similar _and has and use it in or* routines */ /* Dmytro : implemented, used */

function or_head( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { competitors : args[ 0 ] };

  _.routine.options_( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  return o;
}

//

function _or( o )
{
  let self = this;
  let count = 0;
  let procedure = self.procedure( o.stack, 2 ).nameElse( '_or' ); /* aaa2 : cover procedure.sourcePath of each derived routine */ /* Dmytro : covered */ /* delta : 2 to not include info about `routine.unite` in the stack */
  let competitors = o.competitors;
  let competitorRoutines = [];

  _.routine.assertOptions( _or, arguments );

  if( _.argumentsArray.like( competitors ) )
  competitors = _.longSlice( competitors );
  else
  competitors = [ competitors ];

  /* aaa2 : implement tests : arguments are promises */ /* Dmytro : implemented */

  for( let c = competitors.length-1 ; c >= 0 ; c-- )
  {
    let competitorRoutine = competitors[ c ];
    if( _.promiseLike( competitorRoutine ) )
    competitors[ c ] = competitorRoutine = _.Consequence.From( competitorRoutine );
    // competitorRoutine = _.Consequence.From( competitorRoutine ); /* Dmytro : competitor should be a Consequence, see below */
    _.assert( _.consequenceIs( competitorRoutine ) || competitorRoutine === null );
    if( competitorRoutine === null )
    competitors.splice( c, 1 );
  }

  /* */

  if( o.waitingResource )
  {
    self.thenGive( function( arg )
    {
      _init();
    });
  }
  else
  {
    competitors.unshift( self );
    _init();
  }

  return self;

  /* - */

  function _init()
  {

    for( let c = 0 ; c < competitors.length ; c++ )
    {
      let competitor = competitors[ c ];

      _.assert( _.consequenceIs( competitor ) );

      let competitorRoutine = competitorRoutines[ c ] = _.routineJoin( undefined, _got, [ c ] );
      competitor.procedure({ _stack : procedure.stack() }).nameElse( 'orVariant' );
      competitor.finallyGive( competitorRoutine );

      if( count )
      break;
    }

  }

  /* - */

  function _got( index, err, arg )
  {

    count += 1;

    _.assert( count === 1 );

    for( let c = 0 ; c < competitors.length ; c++ )
    {
      let competitor = competitors[ c ];
      let competitorRoutine = competitorRoutines[ c ];
      _.assert( !!competitor );
      if( competitorRoutine )
      if( competitor.competitorOwn( competitorRoutine ) )
      competitor.competitorsCancel( competitorRoutine );
    }

    if( o.keeping )
    if( o.waitingResource || index !== 0 )
    competitors[ index ].take( err, arg );

    if( count === 1 )
    self.take( err, arg );

  }

  /* - */

}

_or.defaults =
{
  competitors : null,
  keeping : null,
  waitingResource : null,
  stack : 2,
}

/* xxx : implement option::cenceling for consequence? */
/* xxx : remove map having? */

_or.having =
{
  consequizing : 1,
  orLike : 1,
}

//

// function afterOrTaking( competitors )
// {
//   let self = this;
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   return self._or
//   ({
//     competitors,
//     keeping : false,
//     waitingResource : true,
//     stack : 2,
//   });
// }

/**
 * Method afterOrTaking() takes first received resource and resolve it - any of resource received by competitors {-competitors-}.
 * The competitor, which is received resource does not resolve it.
 * If Consequence-owner receives resource before any of competitors {-competitors-} receives resource, then Consequence-
 * owner resolves resource received by another competitor after it receives resource.
 * If Consequence-owner receives no resource after all competitors {-competitors-} receive resources, then Consequence-
 * owner waits for resource.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.afterOrKeeping([ con1, con2 ]);
 *
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   con1.cancel();
 *
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // [ 'con1 take' ]
 * // Value : 'value1'
 * // con2 competitor executed with value : value2 and error : undefined
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors. A competitor can be a Consequences, a Promise or Null.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors. A competitor can be a Consequences, a Promise or Null.
 * @returns { Consequence } - Returns Consequence-owner when any of competitors received its resource.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If any of elements of {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If any of elements of {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method afterOrKeeping
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let afterOrTaking = _.routine.uniteCloning_replaceByUnite({ head : or_head, body : _or, name : 'afterOrTaking' });

afterOrTaking.defaults = Object.create( _or.defaults );
afterOrTaking.defaults.keeping = false;
afterOrTaking.defaults.waitingResource = true;

afterOrTaking.having = Object.create( _or.having );

//

// function afterOrKeeping( competitors )
// {
//   let self = this;
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   return self._or
//   ({
//     competitors,
//     keeping : true,
//     waitingResource : true,
//     stack : 2,
//   });
// }

/**
 * Method afterOrKeeping() takes first received resource and resolve it - any of resource received by competitors {-competitors-}.
 * The competitor, which is received resource resolves it.
 * If Consequence-owner receives resource before any of competitors {-competitors-} receives resource, then Consequence-
 * owner resolves resource received by another competitor after it receives resource.
 * If Consequence-owner receives no resource after all competitors {-competitors-} receive resources, then Consequence-
 * owner waits for resource.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.afterOrKeeping([ con1, con2 ]);
 *
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // [ 'con1 take', 'con1.tap' ]
 * // Value : 'value1'
 * // con2 competitor executed with value : value2 and error : undefined
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors. A competitor can be a Consequences, a Promise or Null.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors. A competitor can be a Consequences, a Promise or Null.
 * @returns { Consequence } - Returns Consequence-owner when any of competitors received its resource.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If any of elements of {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If any of elements of {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method afterOrKeeping
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let afterOrKeeping = _.routine.uniteCloning_replaceByUnite({ head : or_head, body : _or, name : 'afterOrKeeping' });

afterOrKeeping.defaults = Object.create( _or.defaults );
afterOrKeeping.defaults.keeping = true;
afterOrKeeping.defaults.waitingResource = true;

afterOrKeeping.having = Object.create( _or.having );

/*
con0.orKeepingSplit([ con1, con2 ]) -> _.Consequence.Or( con0, con1, con2 );
*/

// //
//
// function orKeepingSplit( competitors )
// {
//   let self = this;
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   if( _.argumentsArray.like( competitors ) )
//   competitors = _.longSlice( competitors );
//   else
//   competitors = [ competitors ];
//
//   competitors.unshift( self );
//
//   let con = new Self().take( null );
//
//   con.procedure( 2 ).nameElse( 'orKeepingSplit' );
//   con.afterOrKeeping( competitors );
//
//   return con;
// }
//
// orKeepingSplit.having = Object.create( _or.having );

//

// function orTaking( competitors )
// {
//   let self = this;
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   return self._or
//   ({
//     competitors,
//     keeping : false,
//     waitingResource : false,
//     stack : 2,
//   });
// }

/**
 * Method orTaking() takes first received resource and resolve it - its own resource or any of resource received by
 * competitors {-competitors-}. The competitor, which is received resource does not resolve it.
 * If Consequence-owner receives resource before any of competitors {-competitors-} receives resource, then Consequence-
 * owner resolves received resource immediately.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.orTaking([ con1, con2 ]);
 *
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   con1.cancel();
 *
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // [ 'con1 take' ]
 * // Value : 'value1'
 * // con2 competitor executed with value : value2 and error : undefined
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors. A competitor can be a Consequences, a Promise or Null.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors. A competitor can be a Consequences, a Promise or Null.
 * @returns { Consequence } - Returns Consequence-owner when any of competitors received its resource.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If any of elements of {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If any of elements of {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method orTaking
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let orTaking = _.routine.uniteCloning_replaceByUnite({ head : or_head, body : _or, name : 'orTaking' });

orTaking.defaults = Object.create( _or.defaults );
orTaking.defaults.keeping = false;
orTaking.defaults.waitingResource = false;

orTaking.having = Object.create( _or.having );

//

// function orKeeping( competitors )
// {
//   let self = this;
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   return self._or
//   ({
//     competitors,
//     keeping : true,
//     waitingResource : false,
//     stack : 2,
//   });
// }

/**
 * Method orKeeping() resolve first received resource - its own resource or any of resource received by
 * competitors {-competitors-}. The competitor, which is received resource resolves it immediately.
 * If Consequence-owner receives resource before any of competitors {-competitors-} receives resource, then Consequence-
 * owner resolves received resource immediately.
 *
 * @example
 * let track = [];
 * let conOwner = new  _.Consequence();
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * conOwner.orKeeping([ con1, con2 ]);
 *
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // [ 'con1 take', 'con1 tap' ]
 * // Value : 'value1'
 * // con2 competitor executed with value : value2 and error : undefined
 *
 * Basic parameter set :
 * @param { Array } competitors - Array of competitors. A competitor can be a Consequences, a Promise or Null.
 * Alternative parameter set :
 * @param { Map } o - Options map.
 * @param { Array } o.competitors - Array of competitors. A competitor can be a Consequences, a Promise or Null.
 * @returns { Consequence } - Returns Consequence-owner when any of competitors resolve its resource.
 * @throws { Error } If arguments.length is 0.
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If {-competitors-} has not valid type.
 * @throws { Error } If any of elements of {-competitors-} has not valid type.
 * @throws { Error } If {-o-} has not valid type.
 * @throws { Error } If {-o.competitors-} has not valid type.
 * @throws { Error } If any of elements of {-o.competitors-} has not valid type.
 * @throws { Error } If {-o-} has extra properties.
 * @method orKeeping
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

let orKeeping = _.routine.uniteCloning_replaceByUnite({ head : or_head, body : _or, name : 'orKeeping' });

orKeeping.defaults = Object.create( _or.defaults );
orKeeping.defaults.keeping = true;
orKeeping.defaults.waitingResource = false;

orKeeping.having = Object.create( _or.having );

//

/**
 * Static routine OrTake() takes first received resource from any of passed competitors and resolve it.
 * The competitor, which received a resource, does not resolve resource.
 *
 * @example
 * let track = [];
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * let conOwner = _.Consequence.OrTake( con1, con2 );
 *
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   con1.cancel();
 *
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // [ 'con1 take' ]
 * // Value : 'value1'
 * // con2 competitor executed with value : value2 and error : undefined
 *
 * @param { Consequence|Promise|Null } ... arguments - Competitors to handle.
 * @returns { Consequence } - Returns new Consequence when any of competitors received its resource.
 * @throws { Error } If any of elements of {-arguments-} has not valid type.
 * @throws { Error } If routine calls by instance of Consequence.
 * static
 * @method OrTake
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function OrTake( srcs )
{
  _.assert( !_.instanceIs( this ) )
  let result = new _.Consequence().take( null );
  result.procedure( 1 ).nameElse( 'OrTake' );
  result.afterOrTaking( arguments );
  return result;
}

//

/**
 * Static routine OrKeep() takes first received resource from any of passed competitors and resolve it.
 * The competitor, which received a resource, resolves resource before.
 *
 * @example
 * let track = [];
 * let con1 = new _.Consequence();
 * let con2 = new _.Consequence();
 *
 * let conOwner = _.Consequence.OrKeep( con1, con2 );
 *
 * _.time.out( 50, () =>
 * {
 *   track.push( 'con1 take' );
 *   con1.take( 'value1' );
 * });
 * _.time.out( 200, () =>
 * {
 *   track.push( 'con2 take' );
 *   con2.take( 'value2' );
 * });
 *
 * con1.tap( ( err, value ) =>
 * {
 *   track.push( 'con1 tap' );
 *   console.log( `con1 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * con2.tap( ( err, value ) =>
 * {
 *   track.push( 'con2 tap' );
 *   console.log( `con2 competitor executed with value : ${ value } and error : ${ err }` );
 * });
 *
 * conOwner.finallyGive( ( err, val ) =>
 * {
 *   console.log( _.entity.exportString( track ) );
 *   if( err )
 *   console.log( `Error : ${ err }` );
 *   else
 *   console.log( `Value : ${ _.entity.exportString( val ) }` );
 * });
 *
 * // log :
 * // con1 competitor executed with value : value1 and error : undefined
 * // [ 'con1 take', 'con1.tap' ]
 * // Value : 'value1'
 * // con2 competitor executed with value : value2 and error : undefined
 *
 * @param { Consequence|Promise|Null } ... arguments - Competitors to handle.
 * @returns { Consequence } - Returns new Consequence when any of competitors received its resource.
 * @throws { Error } If any of elements of {-arguments-} has not valid type.
 * @throws { Error } If routine calls by instance of Consequence.
 * static
 * @method OrKeep
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function OrKeep( srcs )
{
  _.assert( !_.instanceIs( this ) )
  let result = new _.Consequence().take( null );
  result.procedure( 1 ).nameElse( 'OrKeep' );
  result.afterOrKeeping( arguments );
  return result;
}

//

function tolerantCallback()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return function tolerantCallback( err, arg )
  {
    if( !err )
    err = undefined;
    if( arg === null || err )
    arg = undefined;
    return self( err, arg );
  }
}

// --
// resource
// --

function takeLater( timeOut, error, argument )
{
  let self = this;

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( _.numberIs( timeOut ) );

  if( argument === undefined )
  {
    argument = arguments[ 1 ];
    error = undefined;
  }

  if( error === null )
  error = undefined;

  _.assert( error !== undefined || argument !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( error === undefined || argument === undefined, 'Cant take both error and argument, one should be undefined' );

  /* */

  _.time.begin( timeOut, function now()
  {
    self.take( error, argument );
  });

  return self;
}

takeLater.having =
{
  consequizing : 1,
}

//

function takeSoon( error, argument )
{
  let self = this;

  if( arguments.length === 1 )
  {
    argument = error;
    error = undefined;
  }

  if( error === null )
  error = undefined;

  _.assert( arguments.length === 2 || arguments.length === 1, 'Expects 1 or 2 arguments, but got ' + arguments.length );
  _.assert( error !== undefined || argument !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( error === undefined || argument === undefined, 'Cant take both error and argument, one should be undefined' );

  // self.__onTake( error, argument );

  _.time.begin( 1, () =>
  {
    self.take( error, argument );
  });

  return self;
}

//

function takeAll()
{
  let self = this;

  for( let a = 0 ; a < arguments.length ; a++ )
  self.take( arguments[ a ] );

  return self;
}

//

/**
 * Method pushes `resource` into wConsequence resources queue.
 * Method also can accept two parameters: error, and
 * Returns current wConsequence instance.
 * @example
 * function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
   };

   let con1 = new _.Consequence();

   con1.finallyGive( gotHandler1 );
   con1.take( 'hello' );

   // prints " competitor 1: hello ",
 * @param {*} [resource] Resolved value
 * @returns {wConsequence} consequence current wConsequence instance.
 * @throws {Error} if passed extra parameters.
 * @method take
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function take( error, argument )
{
  let self = this;

  if( arguments.length === 1 )
  {
    argument = error;
    error = undefined;
  }

  if( error === null )
  error = undefined;

  _.assert( arguments.length === 2 || arguments.length === 1, 'Expects 1 or 2 arguments, but got ' + arguments.length );
  _.assert( error !== undefined || argument !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( error === undefined || argument === undefined, 'Cant take both error and argument, one should be undefined' );

  if( error !== undefined )
  error = self.__handleError( error )

  self.__take( error, argument );

  if( self.AsyncCompetitorHanding || self.AsyncResourceAdding )
  self.__handleResourceSoon( true );
  else
  self.__handleResourceNow();

  return self;
}

take.having =
{
  consequizing : 1,
}

//

/**
 * Using for adds to resource queue error reason, that using for informing corespondent that will handle it, about
 * exception
 * @example
   function showResult(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   let con = new  _.Consequence();

   function divade( x, y )
   {
     let result;
     if( y!== 0 )
     {
       result = x / y;
       con.take(result);
     }
     else
     {
       con.error( 'divide by zero' );
     }
   }

   con.finallyGive( showResult );
   divade( 3, 0 );

   // prints : handleGot1 error: divide by zero
 * @param {*|Error} error error, or value that represent error reason
 * @throws {Error} if passed extra parameters.
 * @method error
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function error( error )
{
  let self = this;

  _.assert( arguments.length === 1 || arguments.length === 0 );

  if( arguments.length === 0 )
  error = _.err();

  if( error !== undefined )
  error = self.__handleError( error )

  self.__take( error, undefined );

  if( self.AsyncCompetitorHanding || self.AsyncResourceAdding )
  self.__handleResourceSoon( true );
  else
  self.__handleResourceNow();

  return self;
}

error.having =
{
  consequizing : 1,
}

//

function __take( error, argument )
{
  let self = this;

  let resource = Object.create( null );
  resource.error = error;
  resource.argument = argument;

  _.assert( error !== undefined || argument !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( error === undefined || argument === undefined, 'Cant take both error and argument, one should be undefined' );
  _.assert( arguments.length === 2 );

  // self.__onTake( error, argument ); /*  aaa : Dmytro : commented due to task. Maybe, need to remove */

  if( _.consequenceIs( argument ) )
  {
    argument.finallyGive( self );
    return self;
  }
  else if( _.promiseLike( argument ) )
  {
    Self.From( argument ).finallyGive( self );
    return self;
  }

  if( Config.debug )
  {
    if( error === undefined )
    if( !( !self.capacity || self._resources.length < self.capacity ) )
    {
      let args =
      [
        `Resource capacity of ${self.qualifiedName} set to ${self.capacity}, but got more resources.`
        + `\nConsider resetting : "{ capacity : 0 }"`
      ]
      throw _._err({ args, stackRemovingBeginExcluding : /\bConsequence.s\b/ });
    }
    if( !( error === undefined || argument === undefined ) )
    {
      let args =
      [
        '{-error-} and {-argument-} channels should not be in use simultaneously\n'
        + '{-error-} or {-argument-} should be undefined, but currently '
        + '\n{-error-} is ' + _.entity.strType( error )
        + '\n{-argument-} is ' + _.entity.strType( argument )
      ]
      throw _._err({ args, stackRemovingBeginExcluding : /\bConsequence.s\b/ });
    }
  }

  self._resources.push( resource );

  return self;
}

// //
//
// function __onTake( err, arg ) /*  aaa : Dmytro : commented due to task. Maybe, need to remove */
// {
//   let self = this;
//
// }
//
// //

// /**
//  * Creates and pushes resource object into wConsequence resources sequence, and trying to get and return result of
//     handling this resource by appropriate competitor.
//  * @example
//    let con = new  _.Consequence();
//
//    function increment( err, value )
//    {
//      return ++value;
//    };
//
//
//    con.finallyGive( increment );
//    let result = con.ping( undefined, 4 );
//    console.log( result );
//    // prints 5;
//  * @param {*} error
//  * @param {*} argument
//  * @returns {*} result
//  * @throws {Error} if missed arguments or passed extra arguments
//  * @method ping
//  * @module Tools/base/Consequence
// * @namespace Tools
// * @class wConsequence
//  */
//
// function _ping( error, argument )
// {
//   let self = this;
//
//   throw _.err( 'deprecated' );
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   let resource =
//   {
//     error,
//     argument,
//   }
//
//   self._resources.push( resource );
//   let result = self.__handleResourceSoon();
//
//   return result;
// }

// --
// handling mechanism
// --

/**
 * Creates and handles error object based on `err` parameter.
 * Returns new _.Consequence instance with error in resources queue.
 * @param {*} err error value.
 * @returns {wConsequence}
 * @private
 * @method __handleError
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function __handleError( err, competitor )
{
  let self = this;

  if( _.symbolIs( err ) )
  return err;

  if( Config.debug && competitor && err && !err.asyncCallsStack )
  {
    err = _._err
    ({
      args : [ err ],
      level : 3,
      asyncCallsStack : competitor.procedure ? [ competitor.procedure.stack() ] : null,
    });
  }
  else
  {
    if( !_.error.isFormed( err ) )
    err = _._err
    ({
      args : [ err ],
      level : 3,
    });
  }

  // if( _.error.isAttended( err ) )
  // return err;

  _.error._handleUncaughtAsync( err );

  return err;
  // let timer = _.time._finally( self.UncaughtTimeOut, function uncaught()
  // {
  //
  //   if( _.error.isAttended( err ) )
  //   return;
  //
  //   // if( !_.time.timerInCancelBegun( timer ) && _.error.isSuspended( err ) ) /* yyy */
  //   // return;
  //
  //   if( _.error.isSuspended( err ) )
  //   return;
  //
  //   _.error._handleUncaught2( err, 'uncaught asynchronous error' );
  //   return null;
  // });
  //
  // return err;
}

//

/**
 * Method for processing corespondents and _resources queue. Provides handling of resolved resource values and errors by
    corespondents from competitors value. Method takes first resource from _resources sequence and try to pass it to
    the first corespondent in corespondents sequence. Method returns the result of current corespondent execution.
    There are several cases of __handleResourceSoon behavior:
    - if corespondent is regular function:
      trying to pass resources error and argument values into corespondent and executing. If during execution exception
      occurred, it will be catch by __handleError method. If corespondent was not added by tap or persist method,
      __handleResourceSoon will remove resource from head of queue.

      If corespondent was added by finally, _onceThen, catchKeep, or by other "thenable" method of wConsequence, finally:

      1) if result of corespondents is ordinary value, finally __handleResourceSoon method appends result of corespondent to the
      head of resources queue, and therefore pass it to the next competitor in corespondents queue.
      2) if result of corespondents is instance of wConsequence, __handleResourceSoon will append current wConsequence instance
      to result instance corespondents sequence.

      After method try to handle next resource in queue if exists.

    - if corespondent is instance of wConsequence:
      in that case __handleResourceSoon pass resource into corespondent`s resources queue.

      If corespondent was added by tap, or one of finally, _onceThen, catchKeep, or by other "thenable" method of
      wConsequence finally __handleResourceSoon try to pass current resource to the next competitor in corespondents sequence.

    - if in current wConsequence are present corespondents added by persist method, finally __handleResourceSoon passes resource to
      all of them, without removing them from sequence.

 * @returns {*}
 * @throws {Error} if on invocation moment the _resources queue is empty.
 * @private
 * @method __handleResourceSoon
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function __handleResourceSoon( isResource )
{
  let self = this;
  let async = isResource ? self.AsyncResourceAdding : self.AsyncCompetitorHanding;

  _.assert( _.boolIs( isResource ) );

  if( async )
  {

    if( !self._competitorsEarly.length && !self._competitorsLate.length )
    return;
    if( !self._resources.length )
    return;

    _.time.soon( () => self.__handleResourceNow() );

  }
  else
  {
    self.__handleResourceNow();
  }

}

//

function __handleResourceNow()
{
  let self = this;
  let counter = 0;
  let consequences = [];

  do
  {
    while( __iteration() );
    self = consequences.pop();
  }
  while( self );

  function __iteration()
  {

    if( !self._resources.length )
    return false;
    if( !self._competitorsEarly.length && !self._competitorsLate.length )
    return false;

    /* */

    let resource = self._resources[ 0 ];
    let competitor, isEarly;

    if( self._competitorsEarly.length > 0 )
    {
      competitor = self._competitorsEarly.shift();
      isEarly = true;
    }
    else
    {
      competitor = self._competitorsLate.shift();
      isEarly = false;
    }

    let isConsequence = _.consequenceIs( competitor.competitorRoutine )
    let errorOnly = competitor.kindOfResource === Self.KindOfResource.ErrorOnly;
    let argumentOnly = competitor.kindOfResource === Self.KindOfResource.ArgumentOnly;

    let executing = true;
    executing = executing && ( !errorOnly || ( errorOnly && !!resource.error ) );
    executing = executing && ( !argumentOnly || ( argumentOnly && !resource.error ) );

    if( !executing )
    {
      if( competitor.procedure )
      competitor.procedure.end();
      return true;
    }

    /* resourceReusing */

    _.assert( !!competitor.instant, 'not implemented' );

    let resourceReusing = false;
    resourceReusing = resourceReusing || !executing;
    resourceReusing = resourceReusing || competitor.tapping;
    if( isConsequence && competitor.keeping && competitor.instant )
    resourceReusing = true;

    if( !resourceReusing )
    self._resources.shift();

    /* debug */

    if( Config.debug )
    if( self.Diagnostics )
    {
      if( isConsequence )
      _.arrayRemoveElementOnceStrictly( competitor.competitorRoutine._dependsOf, self );
    }

    if( isConsequence )
    {

      competitor.competitorRoutine.__take( resource.error, resource.argument );

      if( competitor.procedure )
      competitor.procedure.end();

      // if( !competitor.instant && competitor.keeping )
      // competitor.competitorRoutine._competitorAppend
      // ({
      //   competitorRoutine : self,
      //   keeping : true,
      //   kindOfResource : Self.KindOfResource.Both,
      //   stack : 3,
      //   instant : 1,
      //   late : 1,
      // });

      if( competitor.competitorRoutine.AsyncCompetitorHanding || competitor.competitorRoutine.AsyncResourceAdding )
      {
        competitor.competitorRoutine.__handleResourceSoon( true );
      }
      else
      {
        consequences.push( self );
        self = competitor.competitorRoutine;
      }

    }
    else
    {

      /* call routine */

      let throwenErr = 0;
      let result;

      if( competitor.procedure )
      {
        if( !competitor.procedure.use() )
        competitor.procedure.activate( true );
        _.assert( competitor.procedure.isActivated() );
      }

      try
      {
        if( errorOnly )
        result = competitor.competitorRoutine.call( self, resource.error );
        else if( argumentOnly )
        result = competitor.competitorRoutine.call( self, resource.argument );
        else
        result = competitor.competitorRoutine.call( self, resource.error, resource.argument );
      }
      catch( err )
      {
        throwenErr = self.__handleError( err, competitor );
      }

      if( competitor.procedure )
      {
        competitor.procedure.unuse();
        if( !competitor.procedure.isUsed() )
        {
          competitor.procedure.activate( false );
          competitor.procedure.end();
        }
      }

      if( !throwenErr )
      if( competitor.keeping && result === undefined )
      {
        let err = self.ErrNoReturn( competitor.competitorRoutine );
        throwenErr = self.__handleError( err, competitor )
      }

      /* keeping */

      if( throwenErr )
      {
        self.__take( throwenErr, undefined );
      }
      else if( competitor.keeping )
      {

        if( _.consequenceIs( result ) )
        {
          result.finally( self );
        }
        else if( _.promiseLike( result ) )
        {
          Self.From( result ).finally( self );
        }
        else
        {
          self.__take( undefined, result );
        }

      }

    }

    if( self.AsyncCompetitorHanding || self.AsyncResourceAdding )
    return self.__handleResourceSoon( true );

    counter += 1;
    return true;
  }

}

//

/**
 * Method created and appends competitor object, based on passed options into wConsequence competitors queue.
 *
 * @param {Object} o options map
 * @param {Competitor|wConsequence} o.competitorRoutine callback
 * @param {Object} [o.context] if defined, it uses as 'this' context in competitor function.
 * @param {Array<*>|ArrayLike} [o.argument] values, that will be used as binding arguments in competitor.
 * @param {boolean} [o.keeping=false] If sets to true, finally result of current competitor will be passed to the next competitor
    in competitors queue.
 * @param {boolean} [o.persistent=false] If sets to true, finally competitor will be work as queue listener ( it will be
 * processed every value resolved by wConsequence).
 * @param {boolean} [o.tapping=false] enabled some breakpoints in debug mode;
 * @returns {wConsequence}
 * @private
 * @method _competitorAppend
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function _competitorAppend( o )
{
  let self = this;
  let competitorRoutine = o.competitorRoutine;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.consequenceIs( self ) );
  _.assert
  (
    _.routineIs( competitorRoutine ) || _.consequenceIs( competitorRoutine ),
    () => 'Expects routine or consequence, but got ' + _.entity.strType( competitorRoutine )
  );
  _.assert( o.kindOfResource >= 1 );
  _.assert( competitorRoutine !== self, 'Consquence cant depend on itself' );
  _.assert( o.stack >= 0, 'Competitor should have stack level greater or equal to zero' );
  _.routine.options_( _competitorAppend, o );

  /* */

  if( o.times !== 1 )
  {
    let o2 = _.props.extend( null, o );
    o2.times = 1;
    for( let t = 0 ; t < o.times ; t++ )
    self._competitorAppend( o2 );
    return;
  }

  let stack = o.stack;
  delete o.times;
  delete o.stack;

  /* */

  if( Config.debug )
  {

    if( !_.consequenceIs( competitorRoutine ) )
    {
      if( o.kindOfResource === Self.KindOfResource.ErrorOnly )
      _.assert( competitorRoutine.length <= 1, 'ErrorOnly competitor should expect single argument' );
      else if( o.kindOfResource === Self.KindOfResource.ArgumentOnly )
      _.assert( competitorRoutine.length <= 1, 'ArgumentOnly competitor should expect single argument' );
      else if( o.kindOfResource === Self.KindOfResource.Both )
      _.assert( competitorRoutine.length === 0 || competitorRoutine.length === 2, 'Finally competitor should expect two arguments' );
    }

    if( _.consequenceIs( competitorRoutine ) )
    if( self.Diagnostics )
    {
      self.assertNoDeadLockWith( competitorRoutine );
      competitorRoutine._dependsOf.push( self );
    }

    // if( self.Diagnostics && self.Stacking )
    // {
    //   competitorDescriptor.stack = _.introspector.stack([ stack, Infinity ]);
    // }

  }

  /* procedure */

  _.assert( _.routineIs( o.competitorRoutine ) );

  if( o.procedure === null && !_.consequenceIs( o.competitorRoutine ) )
  {
    if( self._procedure )
    {
      o.procedure = self._procedure;
      self._procedure = null
    }
    else
    {
      if( self._procedure !== false )
      o.procedure = new _.Procedure({ _stack : stack });
    }
  }
  else
  {
    _.assert
    (
      self._procedure === null,
      'Procedure should not be allocated for consequence in role of callback'
    );
    _.assert
    (
      !_.consequenceIs( o.competitorRoutine ) || o.procedure === null,
      'Procedure should not be allocated for consequence in role of callback ( passed to _competitorAppend )'
    );
  }

  if( o.procedure )
  {
    if( !o.procedure.name() )
    o.procedure.name( o.competitorRoutine.name || '' );

    _.assert( o.procedure._routine === null || o.procedure._routine === o.competitorRoutine );

    if( !o.procedure._routine )
    o.procedure._routine = o.competitorRoutine;
    if( !o.procedure._object )
    o.procedure._object = o;
    o.procedure.begin();
  }

  /* */

  // if( o.late === null )
  // o.late = _.consequenceIs( o.competitorRoutine );
  // if( o.late )
  // zzz : implement con1.then( con )

  if( o.late )
  self._competitorsLate.unshift( o );
  else
  self._competitorsEarly.push( o );

  return o;
}

_competitorAppend.defaults =
{
  competitorRoutine : null,
  keeping : null,
  tapping : null,
  kindOfResource : null,
  late : false,
  instant : true,
  // instant : false, // zzz : implement con1.then( con )
  times : 1,
  stack : null,
  procedure : null,
}

// --
// accounter
// --

function dependencyChainFor( competitor )
{
  let self = this;

  _.assert( _.consequenceIs( competitor ) );

  return look( self, competitor, [] );

  /* */

  function look( con1, con2, visited )
  {

    if( _.longHas( visited, con1 ) )
    return null;
    visited.push( con1 );

    _.assert( _.consequenceIs( con1 ) );

    if( !con1._dependsOf )
    return null;
    if( con1 === con2 )
    return [ con1 ];

    for( let c = 0 ; c < con1._dependsOf.length ; c++ )
    {
      let con1b = con1._dependsOf[ c ];
      if( _.consequenceIs( con1b ) )
      {
        let chain = look( con1b, con2, visited );
        if( chain )
        {
          chain.unshift( con1 );
          return chain;
        }
      }
    }

    return null;
  }

}

//

function doesDependOf( competitor )
{
  let self = this;

  _.assert( _.consequenceIs( competitor ) );

  let chain = self.dependencyChainFor( competitor );

  return !!chain;

  // if( !self._dependsOf )
  // return false;
  //
  // for( let c = 0 ; c < self._dependsOf.length ; c++ )
  // {
  //   let cor = self._dependsOf[ c ];
  //   if( cor === competitor )
  //   return true;
  //   if( _.consequenceIs( cor ) )
  //   if( cor.doesDependOf( competitor ) )
  //   return true;
  // }
  //
  // return false;
}

//

function assertNoDeadLockWith( competitor )
{
  let self = this;

  _.assert( _.consequenceIs( competitor ) );

  let result = self.doesDependOf( competitor );

  if( !result )
  return !result;

  return true;
  // logger.log( self.deadLockReport( competitor ) );
  //
  // let msg = 'Dead lock!\n';
  //
  // _.assert( !result, msg );
  //
  // return result;
}

//

function deadLockReport( competitor )
{
  let self = this;

  _.assert( _.consequenceIs( competitor ) );

  let chain = self.dependencyChainFor( competitor );

  if( !chain )
  return '';

  let log = '';

  chain.forEach( ( con ) =>
  {
    if( log )
    log += '\n';
    log += con.qualifiedName ;
  });

  return log;
}

//

function isEmpty()
{
  let self = this;
  if( self.resourcesCount() )
  return false;
  if( self.competitorsCount() )
  return false;
  return true;
}

//

/**
 * Clears all resources and corespondents of wConsequence.
 * @method cancel
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function cancel()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.competitorsCancel();
  self.resourcesCancel();

  return self;
}

// --
// competitors
// --

function competitorOwn( competitorRoutine )
{
  let self = this;

  _.assert( _.routineIs( competitorRoutine ) );

  for( let c = 0 ; c < self._competitorsEarly.length ; c++ )
  {
    let competitor = self._competitorsEarly[ c ];
    if( competitor.competitorRoutine === competitorRoutine )
    return competitor;
  }

  for( let c = 0 ; c < self._competitorsLate.length ; c++ )
  {
    let competitor = self._competitorsLate[ c ];
    if( competitor.competitorRoutine === competitorRoutine )
    return competitor;
  }

  return false;
}

//

function competitorHas( competitorRoutine )
{
  let self = this;

  _.assert( _.routineIs( competitorRoutine ) );

  for( let c = 0 ; c < self._competitorsEarly.length ; c++ )
  {
    let competitor = self._competitorsEarly[ c ];
    if( competitor.competitorRoutine === competitorRoutine )
    return competitor;
    if( _.consequenceIs( competitor ) )
    if( competitor.competitorHas( competitorRoutine ) )
    return competitor;
  }

  for( let c = 0 ; c < self._competitorsLate.length ; c++ )
  {
    let competitor = self._competitorsLate[ c ];
    if( competitor.competitorRoutine === competitorRoutine )
    return competitor;
    if( _.consequenceIs( competitor ) )
    if( competitor.competitorHas( competitorRoutine ) )
    return competitor;
  }

  return false;
}

//

function competitorsCount( competitorRoutine )
{
  let self = this;

  if( arguments.length === 0 )
  {
    return self._competitorsEarly.length + self._competitorsLate.length;
  }
  else if( arguments.length === 1 )
  {
    _.assert( _.routineIs( competitorRoutine ), 'Expects competitor routine {-competitorRoutine-}' );

    let competitorRoutinesEqualize = ( competitor, routine ) => competitor.competitorRoutine === routine;
    let numberOfEarlyCompetitors = _.longCountElement( self._competitorsEarly, competitorRoutine, competitorRoutinesEqualize );
    let numberOfLateCompetitors = _.longCountElement( self._competitorsLate, competitorRoutine, competitorRoutinesEqualize );

    return numberOfEarlyCompetitors + numberOfLateCompetitors;
  }
  else
  {
    _.assert( 0, 'Expects no arguments or single competitor routine {-competitorRoutine-}.' );
  }
}

//

/**
 * The _corespondentMap object
 * @typedef {Object} _corespondentMap
 * @property {Function|wConsequence} competitor function or wConsequence instance, that accepts resolved resources from
 * resources queue.
 * @property {boolean} keeping determines if corespondent pass his result back into resources queue.
 * @property {boolean} tapping determines if corespondent return accepted resource back into  resources queue.
 * @property {boolean} errorOnly turn on corespondent only if resource represent error;
 * @property {boolean} argumentOnly turn on corespondent only if resource represent no error;
 * @property {boolean} debug enables debugging.
 * @property {string} id corespondent id.
 * @class wConsequence
 * @namespace Tools
 * @module Tools/base/Consequence
 */

/**
 * Returns array of corespondents
 * @example
 * function corespondent1(err, val)
   {
     console.log( 'corespondent1 value: ' + val );
   };

   function corespondent2(err, val)
   {
     console.log( 'corespondent2 value: ' + val );
   };

   function corespondent3(err, val)
   {
     console.log( 'corespondent1 value: ' + val );
   };

   let con = _.Consequence();

   con.tap( corespondent1 ).finally( corespondent2 ).finallyGive( corespondent3 );

   let corespondents = con.competitorsEarlyGet();

   console.log( corespondents );

 * @returns {_corespondentMap}
 * @method competitorsEarlyGet
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function competitorsEarlyGet()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self._competitorsEarly;
}

//

function competitorsLateGet()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self._competitorsLate;
}

//

function competitorsGet()
{
  let self = this;
  let r = [];
  _.assert( arguments.length === 0, 'Expects no arguments' );
  if( self._competitorsEarly.length )
  _.arrayAppendArray( r, self._competitorsEarly );
  if( self._competitorsLate.length )
  _.arrayAppendArray( r, self._competitorsLate );
  return r;
}

//

/**
 * If called without arguments, method competitorsCancel() removes all corespondents from wConsequence
 * competitors queue.
 * If as argument passed routine, method competitorsCancel() removes it from corespondents queue if exists.
 * @example
 function corespondent1(err, val)
 {
   console.log( 'corespondent1 value: ' + val );
 };

 function corespondent2(err, val)
 {
   console.log( 'corespondent2 value: ' + val );
 };

 function corespondent3(err, val)
 {
   console.log( 'corespondent1 value: ' + val );
 };

 let con = _.Consequence();

 con.finallyGive( corespondent1 ).finallyGive( corespondent2 );
 con.competitorsCancel();

 con.finallyGive( corespondent3 );
 con.take( 'bar' );

 // prints
 // corespondent1 value: bar
 * @param {Routine} [competitor]
 * @method competitorsCancel
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function competitorsCancel( competitorRoutine )
{
  let self = this;
  let r = 0;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( arguments.length === 0 || _.routineIs( competitorRoutine ) );

  if( arguments.length === 0 )
  {

    for( let c = self._competitorsEarly.length - 1 ; c >= 0 ; c-- )
    {
      let competitorDescriptor = self._competitorsEarly[ c ];
      if( competitorDescriptor.procedure )
      competitorDescriptor.procedure.end();
      self._competitorsEarly.splice( c, 1 );
      r += 1;
    }

    for( let c = self._competitorsLate.length - 1 ; c >= 0 ; c-- )
    {
      let competitorDescriptor = self._competitorsLate[ c ];
      if( competitorDescriptor.procedure )
      competitorDescriptor.procedure.end();
      self._competitorsLate.splice( c, 1 );
      r += 1;
    }

  }
  else
  {

    let found = _.longLeft( self._competitorsEarly, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
    while( found.element )
    {
      _.assert( found.element.competitorRoutine === competitorRoutine );
      if( found.element.procedure )
      found.element.procedure.end();
      self._competitorsEarly.splice( found.index, 1 )
      found = _.longLeft( self._competitorsEarly, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
      r += 1;
    }

    found = _.longLeft( self._competitorsLate, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
    while( found.element )
    {
      _.assert( found.element.competitorRoutine === competitorRoutine );
      if( found.element.procedure )
      found.element.procedure.end();
      self._competitorsLate.splice( found.index, 1 )
      found = _.longLeft( self._competitorsLate, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
      r += 1;
    }

    _.assert( r > 0, `Found no competitor ${competitorRoutine.name}` );

  }

  return self;
}

//

function argumentsCount( arg )
{
  let self = this;
  // self._resources.filter( ( e ) => console.log( e ) );

  if( arguments.length === 0 )
  return self._resources.filter( ( e ) => e.argument !== undefined ).length;
  else if( arguments.length === 1 )
  return self._resources.filter( ( e ) => e.argument === arg ).length;
  else
  _.assert( 0, 'Expects no arguments or single argument {-arg-}.' );
}

//

function errorsCount( err )
{
  let self = this;

  if( arguments.length === 0 )
  return self._resources.filter( ( e ) => e.error !== undefined ).length;
  else if( arguments.length === 1 )
  return self._resources.filter( ( e ) => e.error === err ).length;
  else
  _.assert( 0, 'Expects no arguments or single argument {-err-}.' );
}

//

/**
 * Returns number of resources in current resources queue.
 * @example
 * let con = _.Consequence();

   let conLen = con.resourcesCount();
   console.log( conLen );

   con.take( 'foo' );
   con.take( 'bar' );
   con.error( 'baz' );
   conLen = con.resourcesCount();
   console.log( conLen );

   con.resourcesCancel();

   conLen = con.resourcesCount();
   console.log( conLen );
   // prints: 0, 3, 0;

 * @returns {number}
 * @method resourcesCount
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function resourcesCount( arg )
{
  let self = this;

  if( arguments.length === 0 )
  return self._resources.length;
  else if( arguments.length === 1 )
  return self._resources.filter( ( e ) => e.argument === arg || e.error === arg ).length;
  else
  _.assert( 0, 'Expects no arguments or single argument {-arg-}.' );
}

//
//

/**
 * The internal wConsequence view of resource.
 * @typedef {Object} _resourceObject
 * @property {*} error error value
 * @property {*} argument resolved value
 * @class wConsequence
 * @namespace Tools
 * @module Tools/base/Consequence
 */

/**
 * Returns resources queue.
 * @example
 * let con = _.Consequence();

   con.take( 'foo' );
   con.take( 'bar ');
   con.error( 'baz' );


   let resources = con.resourcesGet();

   console.log( resources );

   // prints
   // [ { error: null, argument: 'foo' },
   // { error: null, argument: 'bar ' },
   // { error: 'baz', argument: undefined } ]

 * @returns {_resourceObject[]}
 * @method resourcesGet
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function resourcesGet( index )
{
  let self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 )
  _.assert( index === undefined || _.numberIs( index ) );
  if( index === undefined )
  return self._resources;
  else
  return self._resources[ index ];

  // if( index !== undefined )
  // return self._resources[ index ];
  // else
  // return self._resources;
}

//

function argumentsGet( index )
{
  let self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 )
  _.assert( index === undefined || _.numberIs( index ) );
  if( index === undefined )
  return _.filter_( null, self._resources, ( r ) => r.argument ? r.argument : undefined );
  else
  return self._resources[ index ].argument;

  // if( index !== undefined )
  // return self._resources[ index ].argument;
  // else
  // return _.filter_( null, self._resources, ( r ) => r.argument ? r.argument : undefined );
}

//

function errorsGet( index )
{
  let self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 )
  _.assert( index === undefined || _.numberIs( index ) );
  if( index === undefined )
  return _.filter_( null, self._resources, ( r ) => r.error ? r.error : undefined );
  else
  return self._resources[ index ].error;

  // if( index !== undefined )
  // return self._resources[ index ].error;
  // else
  // return _.filter_( null, self._resources, ( r ) => r.error ? r.error : undefined );
}

//

/**
 * If called without arguments, method removes all resources from wConsequence
 * competitors queue.
 * If as argument passed value, method resourcesCancel() removes it from resources queue if resources queue contains it.
 * @example
 * let con = _.Consequence();

   con.take( 'foo' );
   con.take( 'bar ');
   con.error( 'baz' );

   con.resourcesCancel();
   let resources = con.resourcesGet();

   console.log( resources );
   // prints: []
 * @param {_resourceObject} arg resource object for removing.
 * @throws {Error} If passed extra arguments.
 * @method competitorsCancel
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function resourcesCancel( arg )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( arguments.length === 0 )
  {
    self._resources.splice( 0, self._resources.length );
  }
  else
  {
    throw _.err( 'not tested' );
    _.arrayRemoveElement( self._resources, arg );
  }

}

// --
// procedure
// --

function procedure( arg )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );

  if( self._procedure )
  return self._procedure;

  if( self._procedure === false && arg !== true )
  return self._procedure;

  if( _.routineIs( arg ) )
  arg = arg();

  if( arguments.length === 2 )
  {
    _.assert( arg === undefined || arg === null || _.strIs( arg ) || _.numberIs( arg ) );
    _.assert( _.numberIs( arguments[ 1 ] ) );
    self._procedure = _.Procedure({ _stack : _.Procedure.Stack( arg, arguments[ 1 ] ) });
  }
  else if( _.procedureIs( arg ) )
  {
    self._procedure = arg;
    return arg;
  }
  else if( _.numberIs( arg ) )
  {
    self._procedure = _.Procedure({ _stack : arg + 1 }); /* yyy */
  }
  else if( _.strIs( arg ) )
  {
    self._procedure = _.Procedure({ _name : arg, _stack : 1 }); /* yyy : should be 1 not 2 */
  }
  else if( _.mapIs( arg ) )
  {
    _.assert( arg._stack !== undefined );
    self._procedure = _.Procedure( arg );
  }
  else if( arg === false )
  {
    self._procedure = false;
  }
  else if( arg === true )
  {
    self._procedure = null;
  }
  else if( arg === null )
  {
    self._procedure = _.Procedure();
  }
  else _.assert( 0 );

  return self._procedure;
}

//

function procedureDetach()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  let procedure = self._procedure;

  if( self._procedure )
  self._procedure = null;

  return procedure;
}

// --
// exporter
// --

function _exportString( o, it )
{
  let self = this;
  let result = '';

  _.routine.assertOptions( _exportString, o );

  if( o.verbosity >= 2 )
  {
    result += self.qualifiedName;
    result += '\n  argument resources : ' + self.argumentsCount();
    result += '\n  error resources : ' + self.errorsCount();
    result += '\n  early competitors : ' + self.competitorsEarlyGet().length;
    result += '\n  late competitors : ' + self.competitorsLateGet().length;
  }
  else
  {
    if( o.verbosity >= 1 )
    result += self.qualifiedName;
    result += ' ' + self.resourcesCount() + ' / ' + self.competitorsCount();
  }

  return result;
}

_exportString.defaults =
{
  verbosity : 1,
  it : null,
}

//

function exportString( o )
{
  let self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 );
  o = _.routine.options( exportString, o || null );
  return self._exportString( o );
}

_.routineExtend( exportString, _exportString );

//

function _callbacksInfoLog()
{
  let self = this;

  self._competitorsEarly.forEach( ( competitor ) =>
  {
    console.log( competitor.competitorRoutine );
  });

  self._competitorsLate.forEach( ( competitor ) =>
  {
    console.log( competitor.competitorRoutine );
  });

  return self.exportString();
}

//

/**
 * Serializes current wConsequence instance.
 * @example
 * function corespondent1(err, val)
   {
     console.log( 'corespondent1 value: ' + val );
   };

   let con = _.Consequence();
   con.finallyGive( corespondent1 );

   let conStr = con.toStr();

   console.log( conStr );

   con.take( 'foo' );
   con.take( 'bar' );
   con.error( 'baz' );

   conStr = con.toStr();

   console.log( conStr );
   // prints:

   // wConsequence( 0 )
   // resource : 0
   // competitors : 1
   // competitor names : corespondent1

   // corespondent1 value: foo

   // wConsequence( 0 )
   // resource : 2
   // competitors : 0
   // competitor names :

 * @returns {string}
 * @method toStr
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

function toStr( o )
{
  let self = this;
  return self.exportString( _.mapOnly_( null, o || Object.create( null ), self.exportString.defaults ) );
}

//

function toString( o )
{
  let self = this;
  return self.exportString( _.mapOnly_( null, o || Object.create( null ), self.exportString.defaults ) );
}

//

function _inspectCustom()
{
  let self = this;
  return self.exportString();
}

//

function _toPrimitive()
{
  let self = this;
  return self.exportString();
}

//

// /**
//  * Can use as competitor. If `err` is not null, throws exception based on `err`. Returns `arg`.
//  * @callback wConsequence._onDebug
//  * @param {*} err Error object, or any other type, that represent or describe an error reason. If during resolving
//  value no exception occurred, it will be set to null;
//  * @param {*} arg resolved by wConsequence value;
//  * @returns {*}
//  * @module Tools/base/Consequence
// * @namespace Tools
// * @class wConsequence
//  */
//
// function _onDebug( err, arg )
// {
//   if( err )
//   throw _.err( err );
//   return arg;
// }

// --
// accessor
// --

function AsyncModeSet( mode )
{
  let constr = this.Self;
  _.assert( constr.AsyncCompetitorHanding !== undefined );
  _.assert( mode.length === 2 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  constr.AsyncCompetitorHanding = !!mode[ 0 ];
  constr.AsyncResourceAdding = !!mode[ 1 ];
  return [ constr.AsyncCompetitorHanding, constr.AsyncResourceAdding ];
}

//

function AsyncModeGet( mode )
{
  let constr = this.Self;
  _.assert( constr.AsyncCompetitorHanding !== undefined );
  return [ constr.AsyncCompetitorHanding, constr.AsyncResourceAdding ];
}

//

function qualifiedNameGet()
{
  let result = this.shortName;
  if( this.tag )
  result = result + '::' + this.tag;
  else
  result = result + '::';
  if( this.id !== undefined )
  result += `#${this.id}`;
  return result;
}

//

function _arrayGetter_functor( name )
{
  let symbol = Symbol.for( name );
  return function _get()
  {
    var self = this;
    if( self[ symbol ] === undefined )
    self[ symbol ] = [];
    return self[ symbol ];
  }
}

//

function _defGetter_functor( name, def )
{
  let symbol = Symbol.for( name );
  return function _get()
  {
    var self = this;
    if( self[ symbol ] === undefined )
    return def;
    return self[ symbol ];
  }
}

//

function __call__()
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  if( arguments.length === 2 )
  self.take( arguments[ 0 ], arguments[ 1 ] );
  else
  self.take( arguments[ 0 ] );

}

// --
// static
// --

/* aaa : remove second argument */
// function From( src, timeLimit )

function From( src ) /* qqq : cover */
{
  let con = src;

  // _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( arguments.length === 1 );
  // _.assert( timeLimit === undefined || _.numberIs( timeLimit ) );

  if( _.promiseLike( src ) )
  {
    con = new Self();
    let onFulfilled = ( arg ) => { arg === undefined ? con.take( null ) : con.take( arg ); }
    let onRejected = ( err ) => { con.error( err ); }
    src.then( onFulfilled, onRejected );
  }

  if( _.consequenceIs( con ) )
  {
    // let con2 = con;
    // if( timeLimit !== undefined )
    // con2 = new _.Consequence().take( null ).timeLimitError( timeLimit, con );
    // return con2;
    return con;
  }

  if( _.errIs( src ) )
  return new Self().error( src );
  return new Self().take( src );
}

//

function FromCalling( src )
{
  if( !_.consequenceIs( src ) && _.routineIs( src ) )
  src = src();
  src = this.From( src );
  return src;
}

//

/**
 * If `consequence` if instance of wConsequence, method pass arg and error if defined to it's resource sequence.
 * If `consequence` is routine, method pass arg as arguments to it and return result.
 * @example
 * function showResult(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   let con = new  _.Consequence();

   con.finallyGive( showResult );

   _.Consequence.take( con, 'hello world' );
   // prints: handleGot1 value: hello world
 * @param {Function|wConsequence} consequence
 * @param {*} arg argument value
 * @param {*} [error] error value
 * @returns {*}
 * @static
 * @method take
 * @module Tools/base/Consequence
 * @namespace wConsequence
 */

function Take( consequence )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );

  let err, arg;
  if( arguments.length === 2 )
  {
    arg = arguments[ 1 ];
  }
  else if( arguments.length === 3 )
  {
    err = arguments[ 1 ];
    arg = arguments[ 2 ];
  }

  let args = [ arg ];

  return _Take
  ({
    consequence,
    context : undefined,
    error : err,
    args,
  });

}

//

/**
 * If `o.consequence` is instance of wConsequence, method pass o.args and o.error if defined, to it's resource sequence.
 * If `o.consequence` is routine, method pass o.args as arguments to it and return result.
 * @param {Object} o parameters object.
 * @param {Function|wConsequence} o.consequence wConsequence or routine.
 * @param {Array} o.args values for wConsequence resources queue or arguments for routine.
 * @param {*|Error} o.error error value.
 * @returns {*}
 * @private
 * @throws {Error} if missed arguments.
 * @throws {Error} if passed argument is not object.
 * @throws {Error} if o.consequence has unexpected type.
 * @method _Take
 * @module Tools/base/Consequence
 * @namespace Tools
 * @class wConsequence
 */

/* zzz : deprecate? */
function _Take( o )
{
  let context;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.object.isBasic( o ) );
  _.assert( _.argumentsArray.like( o.args ) && o.args.length <= 1, 'not tested' );
  _.routine.assertOptions( _Take, arguments );

  /* */

  if( _.argumentsArray.like( o.consequence ) )
  {

    for( let i = 0 ; i < o.consequence.length ; i++ )
    {
      let optionsGive = _.props.extend( null, o );
      optionsGive.consequence = o.consequence[ i ];
      _Take( optionsGive );
    }

  }
  else if( _.consequenceIs( o.consequence ) )
  {

    _.assert( _.argumentsArray.like( o.args ) && o.args.length <= 1 );

    context = o.consequence;

    o.consequence.take( o.error, o.args[ 0 ] );

  }
  else if( _.routineIs( o.consequence ) )
  {

    _.assert( _.argumentsArray.like( o.args ) && o.args.length <= 1 );

    return o.consequence.call( context, o.error, o.args[ 0 ] );

  }
  else throw _.err( 'Unknown type of consequence : ' + _.entity.strType( o.consequence ) );

}

_Take.defaults =
{
  consequence : null,
  context : null,
  error : null,
  args : null,
}

//

/**
 * If `consequence` if instance of wConsequence, method error to it's resource sequence.
 * If `consequence` is routine, method pass error as arguments to it and return result.
 * @example
 * function showResult(err, val)
 * {
 *   if( err )
 *    {
 *      console.log( 'handleGot1 error: ' + err );
 *    }
 *    else
 *    {
 *      console.log( 'handleGot1 value: ' + val );
 *    }
 *  };
 *
 *  let con = new  _.Consequence();
 *
 *  con.finallyGive( showResult );
 *
 *  wConsequence.error( con, 'something wrong' );
 * // prints: handleGot1 error: something wrong
 * @param {Function|wConsequence} consequence
 * @param {*} error error value
 * @returns {*}
 * @static
 * @method error
 * @module Tools/base/Consequence
 * @namespace wConsequence
 */

function Error( consequence, error )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  return _Take
  ({
    consequence,
    context : undefined,
    error,
    args : [],
  });

}

//

function Try( routine )
{

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( routine ) );

  try
  {
    let r = routine();
    return Self.From( r );
  }
  catch( err )
  {
    let error = _.err( err );
    return new Self().error( error );
  }

}

//

/**
 * Can use as competitor. If `err` is not null, throws exception based on `err`. Returns `arg`.
 * @callback PassThru
 * @param {*} err Error object, or any other type, that represent or describe an error reason. If during resolving
 value no exception occurred, it will be set to null;
 * @param {*} arg resolved by wConsequence value;
 * @returns {*}
 * @class wConsequence
 * @namespace Tools
 * @module Tools/base/Consequence
 */

function FinallyPass( err, arg )
{
  _.assert( err !== undefined || arg !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( err === undefined || arg === undefined, 'Cant take both error and argument, one should be undefined' );
  if( err )
  throw err;
  return arg;
}

// --
// meta
// --

function _metaDefine( how, key, value )
{
  let opts =
  {
    enumerable : false,
    configurable : false,
  }

  if( how === 'get' )
  {
    opts.get = value;
    Object.defineProperty( Self.prototype, key, opts );
  }
  else if( how === 'field' )
  {
    opts.value = value;
    Object.defineProperty( Self.prototype, key, opts );
  }
  else if( how === 'static' )
  {
    opts.get = value;
    Object.defineProperty( Self, key, opts );
    Object.defineProperty( Self.prototype, key, opts );
  }
  else _.assert( 0 );

}

// --
// relations
// --

/**
 * @typedef {Object} Fields
 * @property {Array} [_competitorsEarly=[]] Queue of competitor that are penging for resource.
 * @property {Array} [_resources=[]] Queue of messages that are penging for competitor.
 * @property {wProcedure} [_procedure=null] Instance of wProcedure.
 * @property {String} tag
 * @property {Number} id Id of current instance
 * @property {Array} [_dependsOf=[]]
 * @property {Number} [capacity=0] Maximal number of resources. Unlimited by default.
 * @class wConsequence
 * @namespace Tools
 * @module Tools/base/Consequence
*/


let Composes =
{
  capacity : 1,
  _resources : null,
}

let ComposesDebug =
{
  tag : '',
}

if( Config.debug )
_.props.extend( Composes, ComposesDebug );

let Aggregates =
{
  _procedure : null,
}

let Restricts =
{
  _competitorsEarly : null,
  _competitorsLate : null,
}

let RestrictsDebug =
{
  _dependsOf : null,
  // id : 0,
}

if( Config.debug )
_.props.extend( Restricts, RestrictsDebug );

let Medials =
{
  tag : '',
}

let Statics =
{

  // Now : _.now,
  // Async : _.now,
  After : _.after,
  From, /* qqq : cover please */
  FromCalling,
  Take,
  Error,
  ErrNoReturn,
  Try, /* qqq : cover please */

  TimeLimit,
  TimeLimitError,

  AndTake,
  AndKeep,
  AndImmediate,
  And : AndKeep,

  OrTake,
  OrKeep,
  Or : OrKeep,

  FinallyPass,
  // ThenPass, /*  aaa : Dmytro : commented due to task. Maybe, need to remove */
  // CatchPass, /*  aaa : Dmytro : commented due to task. Maybe, need to remove */

  AsyncModeSet,
  AsyncModeGet,

  // ToolsExtension,
  KindOfResource,

  // _Extend,

  //

  // UncaughtTimeOut : 100,
  Diagnostics : 1,
  AsyncCompetitorHanding : 0, /* xxx : deprecate */
  AsyncResourceAdding : 0, /* xxx : deprecate */
  Counter : 0,

  shortName : 'Consequence',

}

let Forbids =
{
  every : 'every',
  mutex : 'mutex',
  mode : 'mode',
  resourcesCounter : 'resourcesCounter',
  _competitor : '_competitor',
  _competitorPersistent : '_competitorPersistent',
  dependsOf : 'dependsOf',
}

let Accessors =
{
  competitorNext : 'competitorNext',
  _competitorsEarly : { get : _arrayGetter_functor( '_competitorsEarly' ) },
  _competitorsLate : { get : _arrayGetter_functor( '_competitorsLate' ) },
  _resources : { get : _arrayGetter_functor( '_resources' ) },
  _procedure : { get : _defGetter_functor( '_procedure', null ) },
  capacity : { get : _defGetter_functor( 'capacity', 1 ) },
}

let DebugAccessors =
{
  tag : { get : _defGetter_functor( 'tag', null ) },
  _dependsOf : { get : _arrayGetter_functor( '_dependsOf' ) },
}

if( Config.debug )
_.props.extend( Accessors, DebugAccessors );

// --
// declare
// --

let Extension =
{

  init,
  is,

  // basic

  finallyGive,
  give : finallyGive,
  finallyKeep,
  finally : finallyKeep,

  thenGive,
  // ifNoErrorGot : thenGive,
  // got : thenGive,
  thenKeep,
  then : thenKeep,
  ifNoErrorThen : thenKeep,

  catchGive,
  catchKeep,
  catch : catchKeep,
  ifErrorThen : catchGive,

  // to promise // qqq : cover please

  _promiseThen,
  _promise,
  finallyPromiseGive,
  finallyPromiseKeep,
  promise : finallyPromiseKeep,
  thenPromiseGive,
  thenPromiseKeep,
  catchPromiseGive,
  catchPromiseKeep,

  // deasync // qqq : cover please

  _deasync,
  deasync,

  // advanced

  _first,
  first,

  split : splitKeep,
  splitKeep,
  splitGive,
  tap,
  catchLog,
  catchBrief,
  syncMaybe,
  sync,

  // experimental

  _competitorFinally,
  wait,
  participateGive,
  participateKeep,

  // etc

  ErrNoReturn,

  // put

  _put,
  put : thenPutGive,
  putGive,
  putKeep,
  thenPutGive,
  thenPutKeep,

  // time

  _delay, /* yyy : rename */
  finallyDelay,
  thenDelay,
  exceptDelay,
  delay : finallyDelay,

  _timeLimit,
  timeLimit,
  timeLimitError,
  timeLimitSplit,
  timeLimitErrorSplit,
  TimeLimit, /* qqq : cover please */
  TimeLimitError, /* qqq : cover please */

  // and

  _and,
  andTake,
  andKeep,
  andImmediate,
  andKeepAccumulative,

  alsoTake,
  alsoKeep,
  alsoImmediate,
  also : alsoKeep,

  AndTake,
  AndKeep,
  And : AndKeep,
  AndImmediate,

  // or

  _or,
  afterOrTaking,
  afterOrKeeping,
  // orKeepingSplit, /* yyy : depracate? */
  orTaking,
  orKeeping,
  or : orKeeping,

  OrTake, /* qqq : cover. separate test routine for procedure and its sourcePath checking */
  OrKeep, /* qqq : cover. separate test routine for procedure and its sourcePath checking */
  Or : OrKeep,

  // adapter

  tolerantCallback,

  // resource

  takeLater,
  takeSoon,
  takeAll,
  take,
  resolve : take,
  error,
  reject : error,
  __take,
  // __onTake, /*  aaa : Dmytro : commented due to task. Maybe, need to remove */

  // handling mechanism

  __handleError,
  __handleResourceSoon,
  __handleResourceNow,
  _competitorAppend,

  // accounter

  doesDependOf,
  dependencyChainFor,
  assertNoDeadLockWith,
  deadLockReport,

  isEmpty,
  cancel,

  // competitor

  competitorOwn, /* aaa2 : cover */ /* Dmytro : covered, _competitorsLate restricted and not used */
  competitorHas,
  competitorsCount, /* aaa2 : cover */ /* Dmytro : covered, _competitorsLate restricted and not used */
  competitorsEarlyGet,
  competitorsLateGet,
  competitorsGet,
  competitorsCancel,

  // resource

  argumentsCount, /* aaa2 : cover */ /* Dmytro : covered */
  errorsCount, /* aaa2 : cover */ /* Dmytro : covered */
  resourcesCount, /* aaa2 : cover */ /* Dmytro : covered */
  resourcesGet,
  argumentsGet,
  errorsGet,
  resourcesCancel,

  // procedure

  procedure,
  procedureDetach,

  // exporter

  _exportString,
  exportString,
  _callbacksInfoLog,
  toStr,
  toString,
  _inspectCustom,
  _toPrimitive,

  // accessor

  AsyncModeSet,
  AsyncModeGet,
  qualifiedNameGet,

  __call__,

  // relations

  Composes,
  Aggregates,
  Restricts,
  Medials,
  Forbids,
  Accessors,

}

//

/* statics should be supplemental not extending */

let Supplement =
{
  Statics,
}

//

_.classDeclare
({
  cls : wConsequence,
  parent : null,
  extend : Extension,
  supplement : Supplement,
  usingOriginalPrototype : 1,
});

_.Copyable.mixin( wConsequence ); /* zzz : remove the mixin, maybe */

_metaDefine( 'field', Symbol.toPrimitive, _toPrimitive );
_metaDefine( 'field', Symbol.for( 'nodejs.util.inspect.custom' ), _inspectCustom );

//

_.assert( _.routineIs( wConsequence.prototype.FinallyPass ) );
_.assert( _.routineIs( wConsequence.FinallyPass ) );
_.assert( _.object.isBasic( wConsequence.prototype.KindOfResource ) );
_.assert( _.object.isBasic( wConsequence.KindOfResource ) );
_.assert( _.strDefined( wConsequence.name ) );
_.assert( _.strDefined( wConsequence.shortName ) );
_.assert( _.routineIs( wConsequence.prototype.take ) );

_.assert( _.routineIs( wConsequenceProxy.prototype.FinallyPass ) );
_.assert( _.routineIs( wConsequenceProxy.FinallyPass ) );
_.assert( _.object.isBasic( wConsequenceProxy.prototype.KindOfResource ) );
_.assert( _.object.isBasic( wConsequenceProxy.KindOfResource ) );
_.assert( _.strDefined( wConsequenceProxy.name ) );
_.assert( _.strDefined( wConsequenceProxy.shortName ) );
_.assert( _.routineIs( wConsequenceProxy.prototype.take ) );

_.assert( wConsequenceProxy.shortName === 'Consequence' );

_.assert( !!Self.FieldsOfRelationsGroupsGet );
_.assert( !!Self.prototype.FieldsOfRelationsGroupsGet );
_.assert( !!Self.FieldsOfRelationsGroups );
_.assert( !!Self.prototype.FieldsOfRelationsGroups );
_.assert( _.props.keys( Self.FieldsOfRelationsGroups ).length > 0 );

_.assert( _.mapIs( Self.KindOfResource ) );
_.assert( _.mapIs( Self.prototype.KindOfResource ) );
_.assert( Self.AsyncCompetitorHanding === 0 );
_.assert( Self.prototype.AsyncCompetitorHanding === 0 );

_global_[ Self.name ] = _[ Self.shortName ] = Self;
if( !_global_.__GLOBAL_PRIVATE_CONSEQUENCE__ )
_realGlobal_[ Self.name ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
